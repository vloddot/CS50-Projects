import sys


def main():
    c_num = input("Enter a credit card number: ").strip()
    if not is_valid(c_num):
        print('INVALID')
        sys.exit(1)

    # VISA cards start with 4 and are either 16 or 13 digits long
    if c_num[0] == '4' and (len(c_num) == 16 or len(c_num) == 13):
        print('VISA')
        sys.exit(0)

    # MASTERCARD starts with 51 through 55 and is 16 digits long
    if (c_num[:2] == '51' or c_num[:2] == '52' or c_num[:2] == '53' or c_num[:2] == '54' or c_num[:2] == '55') and len(c_num) == 16:

        print('MASTERCARD')
        sys.exit(0)

    # AMEX starts with 34 or 37 and is 15 digits long
    if c_num[:2] == '34' or c_num[:2] == '37' and len(c_num) == 15:
        print('AMEX')
        sys.exit(0)

    print('INVALID')
        



def is_valid(c_num):
    """
    Hans Peter Luhn's algorithm for credit card validation (https://en.wikipedia.org/wiki/Luhn_algorithm)
        It goes like this:
            Step 1:
                Double every other digit starting with the second-to-last digit and add the products' digits (i.e., if the number is 64 then we add 6 and 4 together) to a sum

            Step 2:
                Add the sum of the digits that weren't doubled to the sum

            Step 3:
                If the sum is divisible by 10, the number is valid
    """
    fullsum = 0

    try:
        if len(c_num) % 2 == 1:
            for i, digit in enumerate(map(int, c_num)):
                if i % 2 == 1:
                    digit *= 2
                    digit = (digit % 10) + (digit // 10)


                fullsum += digit
        else:
            for i, digit in enumerate(map(int, c_num)):
                if i % 2 == 0:
                    digit *= 2
                    digit = (digit % 10) + (digit // 10)


                fullsum += digit

    except ValueError:
        return False

    return fullsum % 10 == 0


if __name__ == '__main__':
    main()
