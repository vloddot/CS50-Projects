def validate_card(card):
    multiplied = 0
    added = 0
    for i in range(len(card)):
        if i % 2 == 0:
            added += int(card[i])
        else:
            # Multiply the values of card[i] by 2 and put them in multiplies[i]
            multiplied = int(card[i]) * 2

            # If the multiplied number is double digits, add its products and NOT the number, and same thing will work if it's not double digits

            multiplied = str(multiplied)
            for j in range(len(multiplied)):
                added += int(multiplied[j])

    added = str(added)
    # Checks if the second value in the added value is 0, if so return true
    if added[1] == '0':
        return True


    return False


def card_check(card):

    # Checks if the card is a valid AMEX card, if not it goes onto the next card check
    if len(card) == 15 and card[0] == '3' and (card[1] == '4' or card[1] == '7'):
        return "AMEX"

    # Checks if the card is a valid MasterCard, if not it goes onto the next card check
    if len(card) == 16 and card[0] == '5' and (card[1] == '1' or card[1] == '2' or card[1] == '3' or card[1] == '4' or card[1] == '5'):
        return "MASTERCARD"

    # Checks if the card is a valid Visa card, if not it goes onto the next card check
    if (len(card) == 13 or len(card) == 16) and card[0] == '4':
        return "VISA"

    return False
def main():
    # Ask user for input, which is the credit card number
    try:
        card = input("Credit card number: ").strip()

    # In case the user writes a string or anything other than an integer, print INVALID and return, effectively quitting the program
    except ValueError:
        print("INVALID")
        return


    # Check for if the card is valid or not by calling the validate_card function
    result = validate_card(card)

    # If the result is false, print INVALID and return, effectively quitting the program
    if result == False:
        print("INVALID")
        return

    # Checks for if the card has the same patterns as a VISA, MASTERCARD, or AMEX card
    result = card_check(card)

    # If the result is false, print INVALID
    if result == False:
        print("INVALID")
        return

    # Print the result returned by card_check(card) if it's not false
    print(result)
# Calling main
main()