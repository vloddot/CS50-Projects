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
app.config["TEMPLATES_AUTO_RELOAD"] = True


# Custom filter
app.jinja_env.filters["usd"] = usd
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)


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


@app.route("/", methods=["GET", "POST"])
@login_required
def index():
    total = list()
    """Show portfolio of stocks"""

    # The following line gets data from the quotes table in SQLite3
    quotes = db.execute("SELECT DISTINCT name, symbol, price, shares FROM quotes WHERE user_id = ?", session["user_id"])

    # The following line returns the amount of cash the user has
    cash_list = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
    if len(cash_list) != 1:
        return apology("Could not read cash value")

    cash = cash_list[0]["cash"]

    for i in range(len(quotes)):
        quotes[i]['total'] = quotes[i]['price'] * quotes[i]['shares']

    return render_template("index.html", cash=cash, quotes=quotes)


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    if request.method == "POST":

        # Get the inputted symbol and the shares
        symbol = request.form.get("symbol")
        shares = request.form.get("shares")

        # If the user did not input a symbol
        if not symbol:

            # Return an error to the user
            return apology("Input a symbol")

        # If the user did not input any value for shares
        if not shares:

            # Return an error to the user
            return apology("Enter an amount of shares")

        # Try except blocks in case the shares value is a float, string, etc.
        try:

            # Change shares' data type to integer
            shares = int(shares)

        # In case the shares property is not integer
        except ValueError:

            # Return an error to the user
            return apology("Invalid number of shares")

        # If shares entered are from minus infinity to 0
        if shares <= 0:

            # Return an error to the user
            return apology("Invalid number of shares")

        # Look for the inputted symbol
        quote_search = lookup(symbol)

        # If it's not possible to find the inputted symbol
        if not quote_search:

            # Return an error to the user
            return apology("Failed to find symbol")

        # Get the name and price of the quote the user is searching
        name = quote_search["name"]
        price = quote_search["price"]

        # Get the cash from the current user (as a list)
        cash_list = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])

        # If there are more or less elements in the SQL query than intended
        if len(cash_list) != 1:

            # Return an error to the user
            return apology("Could not read cash value")

        # Set cash to a new variable as a float
        cash = cash_list[0]["cash"]

        # If the cash is less than the amount of shares times the price
        if cash < (price * int(shares)):

            # Return an error to the user
            return apology("You cannot afford this stock")

        quotes = db.execute("SELECT * FROM quotes WHERE user_id = ?", session['user_id'])

        # Update the user's cash and quotes to render them later
        db.execute("UPDATE users SET cash = cash - ? WHERE id = ?", price * shares, session["user_id"])
        db.execute("INSERT INTO quotes (user_id, name, price, symbol, shares) VALUES (?, ?, ?, ?, ?)",
                   session['user_id'], name, price, quote_search['symbol'], shares)
        db.execute("INSERT INTO transactions (user_id, type, symbol, price, shares, name) VALUES (?, ?, ?, ?, ?, ?)",
                   session['user_id'], 'buy', symbol, price, shares, name)

        # Render the homepage
        return redirect("/")

    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""

    transactions = db.execute("SELECT * FROM transactions WHERE user_id = ?", session['user_id'])
    return render_template("history.html", transactions=transactions)


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
    # If the request method is post, lookup the database for the symbols inside the database
    if request.method == "POST":

        # Get the inputted symbol from the user
        symb_input = request.form.get("symbol")

        # If user didn't input a symbol
        if not symb_input:

            # Return an error to the user
            return apology("Input a symbol")

        # Look up for the quote the user entered
        quote_search = lookup(symb_input)

        # If the quote doesn't exist
        if not quote_search:

            # Return an error to the user
            return apology("Failed to find symbol")

        # Define variables for each of the data points of the quote
        name = quote_search["name"]
        price = quote_search["price"]
        symbol = quote_search["symbol"]

        # Return the search.html template with values passed in
        return render_template("search.html", name=name, price=price, symbol=symbol)
    else:

        return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""

    # If the request method is post (i.e., the user inputted the info), check the users' input and insert the data into the SQL database
    if request.method == "POST":
        # Declare variables for the username, password, and password confirmation
        username = request.form.get("username")
        password = request.form.get("password")
        confirmation = request.form.get("confirmation")

        # Check if username hasn't been inputted
        if not username:
            return apology("Input the username")

        # Check if password hasn't been inputted
        if not password:
            return apology("Input the password")

        # Check if password confirmation hasn't been inputted
        if not confirmation:
            return apology("Input the confirmation password")

        # Check if the password matches the confirmation
        if password != confirmation:
            return apology("The password field is not the same as the confirmation field")

        # Check if the username has already been used

        # Hash the password
        hash = generate_password_hash(password)

        # Input the username, and password into the SQL database
        try:
            db.execute("INSERT INTO users (username, hash) VALUES (?, ?)", username, hash)
        except ValueError:
            return apology("This username has already been used")

        session["user_id"] = db.execute("SELECT id FROM users WHERE username = ?", username)

        return render_template("login.html")
    # If the request method is not post (i.e., user sent a request and didn't input any info), just render for him register.html
    else:
        return render_template("register.html")


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""

    # If the request method is POST
    if request.method == "POST":

        # Get shares and symbol from user
        shares = request.form.get("shares")
        symbol = request.form.get("symbol")

        # If user didn't write anything in the shares box
        if not shares:

            # Return an error to the user
            return apology("Enter shares")

        # If user didn't write anything in the symbol box
        if not symbol:

            # Return an error to the user
            return apology("Enter symbol")

        # Look up the database for that stock symbol
        quote_search = lookup(symbol)

        # If there is no stock symbol found in the database
        if not quote_search:

            # Return an error to the user
            return apology("Failed to find quote")

        # Try converting shares to int
        try:

            # Convert shares to int
            shares = int(shares)

        # Except (coversion failed)
        except ValueError:

            # Return an error to the user
            return apology("Invalid shares")

        # If the shares are less than 1
        if shares < 1:

            # Return an error to the user
            return apology("Invalid shares")

        # Get the price from the quote search
        price = quote_search['price']

        # Get the amount of shares in the chosen stock symbol
        symb_shares_list = db.execute("SELECT shares FROM quotes WHERE user_id = ? AND symbol = ?", session['user_id'], symbol)

        # If something went wrong with finding the shares
        if len(symb_shares_list) != 1:

            # Return an error to the user
            return apology("Could not find amount of shares on your account")

        # Make symb_shares a list
        symb_shares = symb_shares_list[0]['shares']

        # If the chosen shares are more than the shares the user has
        if shares > symb_shares:

            # Return an error to the user
            return apology("Invalid shares")

        # Get the cash from the user
        cash_list = db.execute("SELECT cash FROM users WHERE id = ?", session['user_id'])

        # If there's an error and there's an unexpected number of users with the same id (i.e., 0, 2, 3, etc.)
        if len(cash_list) != 1:

            # Return an error to the user
            return apology("Could not read cash value")

        # Set cash to be the cash list
        cash = cash_list[0]['cash']

        # Update the user's cash
        db.execute("UPDATE users SET cash = cash + ? * ? WHERE id = ?", float(price), shares, session['user_id'])

        # Update cash
        cash_list = db.execute("SELECT cash FROM users WHERE id = ?", session['user_id'])

        db.execute("UPDATE quotes SET shares = shares - ? WHERE user_id = ? AND symbol = ?", shares, session['user_id'], symbol)

        # If tehre's an error and there's an unexpected number of users with the same id (i.e., 0, 2, 3, etc.)
        if len(cash_list) != 1:

            # Return an error to the user
            return apology("Could not read cash value")

        # Old cash variable before update
        old_cash = cash

        # Update cash
        cash = cash_list[0]['cash']

        # Set the total of sold amount
        total = (cash + price * shares) - old_cash

        quote_search = lookup(symbol)
        if not quote_search:
            return apology("Could not find quote")

        name = quote_search['name']
        db.execute("INSERT INTO transactions (user_id, type, symbol, price, shares, name) VALUES (?, ?, ?, ?, ?, ?)",
                   session['user_id'], 'sell', symbol, price, shares, name)
        # Return a happy success message
        return redirect('/')

    # Else (the request method is GET)
    else:

        # Get the quotes of the user
        quotes = db.execute("SELECT * FROM quotes WHERE user_id = ?", session['user_id'])

        # Return a page for the quotes to sell
        return render_template("sell.html", quotes=quotes)
