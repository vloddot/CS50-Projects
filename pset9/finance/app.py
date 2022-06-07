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
    quotes = db.execute('SELECT * FROM quotes WHERE user_id = ?', session["user_id"])
    totals = {}
    total = 0
    cash = db.execute('SELECT cash FROM users WHERE id = ?', session["user_id"])
    if len(cash) != 1:
        return apology("something went wrong")
    
    cash = cash[0]['cash']
    for quote in quotes:
        totals[quote['symbol']] = quote['price'] * quote['shares']
        total += quote['price'] * quote['shares']
        
    total += cash
    
    return render_template("index.html", quotes=quotes, totals=totals, cash=cash, total=total)


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    if request.method == "POST":
        symbol = request.form['symbol']
        shares = request.form['shares']
        if not symbol or not shares:
            return apology("must provide symbol and shares")
        
        try:
            shares = float(shares)
            
            if shares % 1 != 0 or shares < 1:
                raise ValueError
            
            shares = int(shares)

        except ValueError:
            return apology('must provide a valid number of shares')
    
        quote = lookup(symbol)
        if not quote:
            return apology("invalid symbol")
        
        cash = db.execute('SELECT cash FROM users WHERE id = ?', session['user_id'])
        if len(cash) != 1:
            return apology("something went wrong")
        
        cash = cash[0]['cash']
        
        if cash < quote['price'] * shares:
            return apology("You do not have enough cash for this transaction")
        
        db.execute('UPDATE users SET cash = cash - ? WHERE id = ?', quote['price'] * shares, session['user_id'])
        quotes = db.execute('SELECT * FROM quotes WHERE user_id = ? AND symbol = ?', session['user_id'], quote['symbol'])
        if len(quotes) == 0:
            db.execute('INSERT INTO quotes (user_id, symbol, name, shares, price) VALUES (?, ?, ?, ?, ?)', session['user_id'], quote['symbol'], quote['name'], shares, quote['price'])
        else:
            db.execute('UPDATE quotes SET shares = shares + ? WHERE user_id = ? AND symbol = ?', shares, session['user_id'], quote['symbol'])

        db.execute('INSERT INTO transactions (user_id, type, symbol, name, shares, price) VALUES (?, ?, ?, ?, ?, ?)', session['user_id'], 'Buy', quote['symbol'], quote['name'], shares, quote['price'])
        return redirect('/')

    return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    transactions = db.execute('SELECT * FROM transactions WHERE user_id = ?', session['user_id'])
    totals = {}
    total = 0
    cash = db.execute('SELECT cash FROM users WHERE id = ?', session['user_id'])
    if len(cash) != 1:
        return apology("something went wrong")
    
    cash = cash[0]['cash']
    
    for transaction in transactions:
        totals[transaction['symbol']] = transaction['price'] * transaction['shares']
        total += transaction['price'] * transaction['shares']
        
    total += cash
    return render_template("history.html", transactions=transactions, totals=totals, cash=cash, total=total)


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
            return apology("must provide symbol", 400)
        
        quote = lookup(symbol)
        if not quote:
            return apology("invalid symbol", 400)
        
        return render_template('quote.html', quote=quote)
    
    return render_template('search.html')




@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""
    if request.method == "POST":
        username = request.form['username']
        password = request.form['password']
        confirmation = request.form['confirmation']
        
        if not username:
            return apology("must provide username", 400)
        
        if not password:
            return apology("must provide password", 400)
        
        if not confirmation:
            return apology("must provide confirmation", 400)
        
        if password != confirmation:
            return apology("passwords do not match", 400)
        
        try:
            db.execute('INSERT INTO users (username, hash) VALUES (?, ?)', username, generate_password_hash(password))
        except ValueError:
            return apology('username already exists', 400)
        
        session['user_id'] = db.execute('SELECT id FROM users WHERE username = ?', username)
        
        if len(session['user_id']) != 1:
            return apology('something went wrong', 500)
        
        session['user_id'] = session['user_id'][0]['id']
        
        return redirect('/')

    return render_template('register.html')


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""
    if request.method == "POST":
        symbol = request.form['symbol']
        shares = request.form['shares']
        
        if not symbol:
            return apology("must provide symbol")
        
        if not shares:
            return apology("must provide shares")
        
        
        try:
            shares = float(shares)
            
            if shares % 1 != 0 or shares < 1:
                raise ValueError
            
            shares = int(shares)

        except ValueError:
            return apology('must provide a valid number of shares')
        
        quote = lookup(symbol)
        
        if not quote:
            return apology("invalid symbol")
        
        current_shares = db.execute('SELECT shares FROM quotes WHERE symbol = ? AND user_id = ?', symbol, session['user_id'])
        
        if len(current_shares) != 1:
            return apology("something went wrong")
        
        current_shares = current_shares[0]['shares']
        
        if shares > current_shares:
            return apology("you do not have enough shares")
        
        db.execute('UPDATE users SET cash = cash + ? WHERE id = ?', quote['price'] * shares, session['user_id'])
        if shares == current_shares:
            db.execute('DELETE FROM quotes WHERE symbol = ? AND user_id = ?', symbol, session['user_id'])
        else:
            db.execute('UPDATE quotes SET shares = shares - ? WHERE symbol = ? AND user_id = ?', shares, symbol, session['user_id'])

        db.execute('INSERT INTO transactions (user_id, type, symbol, name, shares, price) VALUES (?, ?, ?, ?, ?, ?)', session['user_id'], 'Sell', quote['symbol'], quote['name'], shares, quote['price'])
        
        return redirect('/')

    quotes = db.execute('SELECT * FROM quotes WHERE user_id = ?', session['user_id'])
    return render_template("sell.html", quotes=quotes)
