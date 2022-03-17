#include <cs50.h>
#include <stdio.h>

int get_one_digit(long number, long position);
int get_two_digits(long number, long position);

// TODO:
// 1. Ask for credit card number (Check)
// 2. Starting with the second to last digit, get every other number in the credit card number (Check)
// 3. Multiply these numbers by 2 (Check)
// 4. If any of these numbers are double digits, separate each digit from eachother (Check)
// 5. Add everything calculated (Check)
// 6. Add the numbers not divided by 2 from step 3 to the sum from step 5 (Check)
// 7. Check if last number from the sum of step 6 is a 0 (Check)
// 8. Check card length and what the starting digits are (Check)
// 9. Print AMEX, MASTERCARD, VISA or INVALID depending on step 7 and step 8 (Check)
int main(void)
{
    long i;
    long j;
    int digit;
    int sum = 0;
    int even_position_sum = 0;
    int odd_position_sum = 0;

    long n = get_long("Credit Card Number: ");
    for (i = 10; i < n; i *= 100)
    {
        digit = get_one_digit(n, i);
        digit *= 2;
        if (digit >= 10)
        {
            digit = get_one_digit(digit, 10) + get_one_digit(digit, 1);
        }
        even_position_sum += digit;
    }

    for (j = 1; j < n; j *= 100)
    {
        digit = get_one_digit(n, j);
        odd_position_sum += digit;
    }
    sum = even_position_sum + odd_position_sum;

    sum = get_one_digit(sum, 1);

    if (sum != 0)
    {
        printf("INVALID\n");
    }
    else if (4 == get_one_digit(n, 1000000000000000) || 4 == get_one_digit(n, 1000000000000))
    {
        printf("VISA\n");
    }
    else if (51 == get_two_digits(n, 100000000000000)  || 52 == get_two_digits(n, 100000000000000)
             || 53 == get_two_digits(n, 100000000000000) || 54 == get_two_digits(n, 100000000000000) || 55 == get_two_digits(n, 100000000000000))
    {
        printf("MASTERCARD\n");
    }
    else if (37 == get_two_digits(n, 10000000000000) || 34 == get_two_digits(n, 10000000000000))
    {
        printf("AMEX\n");
    }
    else
    {
        printf("INVALID\n");
    }
}

int get_one_digit(long number, long position)
{
    return (number % (position * 10)) / position;
}
int get_two_digits(long number, long position)
{
    return number / position;
}