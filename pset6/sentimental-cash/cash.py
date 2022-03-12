
# Import from the cs50 library a function called get_float()
from cs50 import get_float


def calculate_quarters(money):

    # Declare quarters as 0
    quarters = 0

    # While the money is bigger than or equals 25
    while money >= 25:

        # Increment quarters by 1
        quarters += 1

        # Decrement money by 25
        money -= 25

    # Return quarters
    return quarters

# calculate_dimes(money) takes one argument and calculates the number of dimes the customer should recieve


def calculate_dimes(money):

    # Declare dimes as 0
    dimes = 0

    # While the money is bigger than or equals 10
    while money >= 10:

        # Increment dimes by 1
        dimes += 1

        # Decrement money by 10
        money -= 10

    # Return dimes
    return dimes

# calculate_nickels(money) takes one argument and calculates the number of nickels the customer should recieve


def calculate_nickels(money):

    # Declare nickels as 0
    nickels = 0

    # While the money is bigger than or equals 5
    while money >= 5:

        # Increment nickels by 1
        nickels += 1

        # Decrement money by 5
        money -= 5

    # Return nickels
    return nickels

# calculate_pennies(money) takes one argument and calculates the number of pennies the customer should recieve


def calculate_pennies(money):

    # Declare pennies as 0
    pennies = 0

    # While the money is bigger than or equals 1
    while money >= 1:

        # Increment pennies by 1
        pennies += 1

        # Decrement money by 1
        money -= 1

    # Return pennies
    return pennies


# Forever, do the following
while True:

    # Get money from the user
    money = get_float("Change owed: ")

    # If the money variable is a correct amount, break from the infinite loop
    if money >= 0:
        break

# Multiplying by 100 to change it from for example: 0.41 to 41
money *= 100


# Calculates the number of quarters given to the customer
quarters = calculate_quarters(money)

# Lowering down money for each quarter
money -= (25 * quarters)

# Calculates the number of dimes given to the customer
dimes = calculate_dimes(money)

# Lowering down money for each dime
money -= (10 * dimes)

# Calculates the number of nickels given to the customer
nickels = calculate_nickels(money)

# Lowering down money for each nickel
money -= (5 * nickels)

# Calculates the number of pennies given to the customer
pennies = calculate_pennies(money)

# Lowering down money for each penny
money -= (1 * pennies)

# Calculates the amount of coins given to customer
sum = quarters + dimes + nickels + pennies

# Print the sum
print(sum)