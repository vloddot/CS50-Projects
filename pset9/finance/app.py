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
    # The following list of lines get data from the quotes SQL table
    quotes = db.execute("SELECT * FROM quotes WHERE id = ?", session["user_id"])
    quote_count = len(quotes)

    # The following line returns the amount of cash the user has
    cash_list = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])
    if len(cash_list) != 1:
        return apology("Could not read cash value")

    cash = cash_list[0]["cash"]

    return render_template("index.html", quote_count=quote_count, cash=cash, quotes=quotes)


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    if request.method == "POST":
        # Get the inputted symbol and the shares
        symbol = request.form.get("symbol")
        shares = request.form.get("shares")

        # If the user did not input a symbol return an apology to the user
        if not symbol:
            return apology("Input a symbol")

        # If the user did not input shares set shares to be 1
        if not shares:
            shares = "1"

        # Look for the inputted symbol
        quote_search = lookup(symbol)

        # If it's not possible to find the inputted symbol return an apology to the user
        if quote_search == None:
            return apology("Failed to find symbol")

        # If the user entered shares from minus infinity to 0 return an apology to the user
        if int(shares) <= 0:
            return apology("Invalid number of shares")

        # Get the name and price of the quote the user is searching
        name = quote_search["name"]
        price = quote_search["price"]

        # Get the cash from the current user (as a list)
        cash_list = db.execute("SELECT cash FROM users WHERE id = ?", session["user_id"])

        # If there are more or less elements in the SQL query than intended return an apology to the user
        if len(cash_list) != 1:
            return apology("Could not read cash value")

        # Set cash to a new variable as an int
        cash = cash_list[0]["cash"]

        # If the cash is less than the amount of shares times the price return an apology to the user
        if cash < (price * int(shares)):
            return apology("You cannot afford this stock")

        # Update the user's cash and quotes to render them later
        db.execute("UPDATE users SET cash = cash - ? WHERE id = ?", price * int(shares), session["user_id"])
        db.execute("INSERT INTO quotes (name, price, symbol, shares) VALUES (?, ?, ?, ?)", name, price, quote_search['symbol'], shares)

        # Render a success.html file saying that the buying was successful
        return redirect("/")

    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    return apology("TODO")


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
        symb_input = request.form.get("symbol")
        if not symb_input:
            return apology("Input a symbol")

        quote_search = lookup(symb_input)
        if quote_search == None:
            return apology("Failed to find symbol")

        name = quote_search["name"]
        price = quote_search["price"]
        symbol = quote_search["symbol"]
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
    return apology("TODO")
