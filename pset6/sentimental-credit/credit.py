import sys


def main():
    c_num = input("Enter a credit card number: ").strip()
    if not is_valid(c_num):
        print('INVALID')
        sys.exit(1)
        
    if c_num[0] == '4' and (len(c_num) == 16 or len(c_num) == 13):
        print('VISA')
        
    elif (c_num[:2] == '51' or \
        c_num[:2] == '52' or \
        c_num[:2] == '53' or \
        c_num[:2] == '54' or \
        c_num[:2] == '55') and len(c_num) == 16:

        print('MASTERCARD')
        
    elif c_num[:2] == '34' or c_num[:2] == '37' and len(c_num) == 15:
        print('AMEX')
        
    else:
        print('INVALID')



def is_valid(c_num):
    c_sum = 0
    if len(c_num) % 2 == 1:

        try:
            for i, digit in enumerate(map(int, c_num)):
                if i % 2 == 1:
                    digit *= 2
                    if digit > 9:
                        digit = (digit % 10) + (digit // 10)


                c_sum += digit
        except ValueError:
            return False
    else:
        for i, digit in enumerate(map(int, c_num)):
            if i % 2 == 0:
                digit *= 2
                if digit > 9:
                    digit = (digit % 10) + (digit // 10)


            c_sum += digit


    return c_sum % 10 == 0


if __name__ == '__main__':
    main()