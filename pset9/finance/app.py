from multiprocessing.sharedctypes import Value
import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")

# Make sure API key is set
if not os.environ.get("API_KEY"):
    raise RuntimeError("API_KEY not set")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""
    quotes = db.execute('SELECT * FROM quotes WHERE user_id = ?', session['user_id'])
    
    totals = {}
    total = 0
    for quote in quotes:
        totals[quote['symbol']] = quote['price'] * quote['shares']
        total += quote['price'] * quote['shares']
        
    cash_list = db.execute('SELECT cash FROM users WHERE id = ?', session['user_id'])
    if len(cash_list) != 1:
        return apology('Could not read cash value')
    
    cash = cash_list[0]['cash']
    
    total += cash

    return render_template('index.html', quotes=quotes, totals=totals, cash=cash, total=total)


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    
    if request.method == "POST":
        symbol = request.form['symbol']
        shares = request.form['shares']
        
        if not symbol:
            return apology('Enter a symbol')
        
        if not shares:
            return apology('Enter amount of shares')
        
        try:
            
            shares = int(shares)
            
            if shares <= 0 or shares % 1 != 0:
                print(2 / 0)

        except (ValueError, ZeroDivisionError):
            return apology('Enter valid share amount')
            
        quote = lookup(symbol)
        
        if not quote:
            return apology('Invalid symbol')
        
        cash_list = db.execute('SELECT cash FROM users WHERE id = ?', session['user_id'])
        
        if len(cash_list) != 1:
            return apology('Could not find cash value')
        
        cash = cash_list[0]['cash']
        
        if cash < quote['price'] * shares:
            return apology('You do not have enough cash for this transaction')
        
        db.execute('UPDATE users SET cash = cash - ? WHERE id = ?',
                   quote['price'] * shares, session['user_id'])
        
        if len(db.execute('SELECT * FROM quotes WHERE symbol = ? AND user_id = ?',
                          quote['symbol'], session['user_id'])) == 0:

            db.execute('INSERT INTO quotes (user_id, name, price, symbol, shares) VALUES (?, ?, ?, ?, ?)',
                       session['user_id'], quote['name'], quote['price'], quote['symbol'], shares)
        else:
            db.execute('UPDATE quotes SET shares = shares + ? WHERE symbol = ? AND user_id = ?',
                       shares, quote['symbol'], session['user_id'])
            
        db.execute('INSERT INTO transactions (user_id, type, symbol, shares, name, price) VALUES (?, ?, ?, ?, ?, ?)',
                   session['user_id'], 'Buy', quote['symbol'], shares, quote['name'], quote['price'])

        return redirect('/')
    else:
        return render_template('buy.html')


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    
    transactions = db.execute('SELECT * FROM transactions WHERE user_id = ?', session['user_id'])
    
    totals = {}
    for transaction in transactions:
        totals[transaction['symbol']] = transaction['price'] * transaction['shares']

    return render_template('history.html', transactions=transactions, totals=totals)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = ?", request.form.get("username"))

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""
    
    if request.method == "POST":
        symbol = request.form['symbol']
        
        if not symbol:
            return apology('Enter a symbol')


        quote = lookup(symbol)
        if not quote:
            return apology('Invalid symbol')

        return render_template('quote.html', quote=quote)

    else:
        return render_template('search.html')


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""
    
    if request.method == "POST":
        username = request.form['username']
        password = request.form['password']
        confirmation = request.form['confirmation']
        
        if not username:
            return apology('Enter a username')
        
        if not password:
            return apology('Enter a password')
        
        if not confirmation:
            return apology('Enter a confirmation for the password')
        
        if password != confirmation:
            return apology('Password and password confirmation do not match')
        
        hash = generate_password_hash(password)
        
        try:
            db.execute('INSERT INTO users (username, hash) VALUES (?, ?)', username, hash)
        except ValueError:
            return apology('Username already used')
        
        session['user_id'] = db.execute('SELECT id FROM users WHERE username = ?', username)
        
        return redirect('/login')

    else:
        return render_template('register.html')


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""
    
    if request.method == "POST":
        symbol = request.form['symbol']
        shares = request.form['shares']
        
        if not symbol:
            return apology('Enter a symbol')
        
        if not shares:
            return apology('Enter amount of shares')
        
        try:
            shares = int(shares)
            
            if shares <= 0 or shares % 1 != 0:
                print(2 / 0)

        except (ValueError, ZeroDivisionError):
            return apology('Enter valid share amount')
        
        quote = lookup(symbol)
        
        if not quote:
            return apology('Invalid symbol')
        
        current_shares_list = db.execute('SELECT shares FROM quotes WHERE symbol = ? AND user_id = ?',
                                         quote['symbol'], session['user_id'])
        
        if len(current_shares_list) != 1:
            return apology('Could not read the amount of shares for the chosen symbol')
        
        current_shares = current_shares_list[0]['shares']
        
        if shares > current_shares:
            return apology('Chosen shares must not be more than what you own')
        
        db.execute('UPDATE users SET cash = cash + ? WHERE id = ?',
                   quote['price'] * shares, session['user_id'])

        if shares == current_shares:
            db.execute('DELETE FROM quotes WHERE symbol = ? AND user_id = ?',
                       quote['symbol'], session['user_id'])
        
        else:
            db.execute('UPDATE quotes SET shares = shares - ? WHERE user_id = ?',
                       shares, session['user_id'])
            
        db.execute('INSERT INTO transactions (user_id, type, symbol, shares, name, price) VALUES (?, ?, ?, ?, ?, ?)',
                   session['user_id'], 'Sell', quote['symbol'], shares, quote['name'], quote['price'])
        
        return redirect('/')

    else:
        quotes = db.execute('SELECT * FROM quotes WHERE user_id = ?', session['user_id'])
        return render_template('sell.html', quotes=quotes)