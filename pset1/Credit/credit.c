#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
/* TODO:
// 1. Ask for credit card number
2. Starting with the second to last digit, get every other number in the credit card number
3. Multiply these numbers by 2
4. If any of these numbers are double digits, separate each digit from eachother
5. Add everything calculated
6. Add the numbers not divided by 2 from step 3 to the sum from step 5
7. Check if last number from the sum of step 6 is a 0
8. Check card length and what the starting digits are
9. Print AMEX, MASTERCARD, VISA or INVALID depending on step 7 and step 8
*/

bool check_card(char *card);

int main(void) {
    // Get the credit card number from the user
    char *card = get_string("Credit card number: ");

    // Check if the card is invalid or not
    bool result = check_card(card);
    if (result == false) {
        printf("INVALID");
        return 1;
    }
}
bool check_card(char *card) {
    int multiples = 0;
    // Starting with the second to last digit, multiply every other number in the credit card number
    for (int i = strlen(card) - 1; i > 0; i -= 2) {
        multiples += atoi(&card[i]) * 2;
    }
    // Starting with the last digit, add every other number in the credit card number
    for (int i = strlen(card); i < 0; i -= 2) {
        multiples += atoi(&card[i]);
    }
    if (strcmp(itoa(multiples[1]), 0) == 0) {
        return true;
    }



}