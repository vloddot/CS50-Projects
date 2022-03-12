#include <cs50.h>
#include <stdio.h>

int get_cents();
int calculate_quarters(int cents);
int calculate_dimes(int cents);
int calculate_nickels(int cents);
int calculate_pennies(int cents);
int main(void)
{
    // Ask how many cents the customer is owed
    int cents = get_cents();

    // Quarters is the number of quarters, not the number of cents, so is with each dime, nickel, and penny.
    // Calculate the number of quarters to give the customer
    int quarters = calculate_quarters(cents);
    cents = cents - quarters * 25;
/*  ^^^^^   ^^^^^   ^^^^^^^^
      41  =   41  -     1    * 25, cents = 16   */
    // Calculate the number of dimes to give the customer
    int dimes = calculate_dimes(cents);
    cents = cents - dimes * 10;
/*  ^^^^^   ^^^^^   ^^^^^
     16  =   16  -   1   * 10, cents = 6 */
    // Calculate the number of nickels to give the customer
    int nickels = calculate_nickels(cents);
    cents = cents - nickels * 5;
//  ^^^^^   ^^^^^   ^^^^^^^
//    6   =   6   -    1    * 5, cents = 1
    // Calculate the number of pennies to give the customer
    int pennies = calculate_pennies(cents);
    cents = cents - pennies * 1;
//  ^^^^^   ^^^^^   ^^^^^^^
//    1   =   1   -    1    * 1
    // Sum coins
    int coins = quarters + dimes + nickels + pennies;

    // Print total number of coins to give the customer
    printf("%i\n", coins);
}

int get_cents(void)
{
    int number;
    do
    {
        number = get_int("Amount owed: ");
    }
    while (number < 0);
    return number;
}
int calculate_quarters(int cents)
{
    if (cents >= 25)
    {
        int quarters = cents / 25;
        return quarters;
    }
    return 0;
}

int calculate_dimes(int cents)
{

    if (cents >= 10)
    {
        int quarters = cents / 10;
        return quarters;
    }
    return 0;
}

int calculate_nickels(int cents)
{

    if (cents >= 5)
    {
        int quarters = cents / 5;
        return quarters;
    }
    return 0;

}

int calculate_pennies(int cents)
{

    if (cents >= 1)
    {
        int quarters = cents / 1;
        return quarters;
    }
    return 0;

}