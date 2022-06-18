#include <stdlib.h>
#include <string.h>
#include <stdio.h>

int isValid(char *c_num);

int main(void)
{
    // Allocate memory for the credit card number
    char *c_num = malloc(1024);
    if (c_num == NULL)
    {
        perror("MallocFailError: allocate for c_num\n");
        return 1;
    }

    // Get the credit card number
    printf("Enter your credit card number: ");
    scanf("%s", c_num);

    // Check if the credit card number is valid
    if (!isValid(c_num))
    {
        printf("INVALID\n");
    }

    // Find out which credit card company it belongs to
    else if (
        strncmp(c_num, "4", 1) == 0 && (strlen(c_num) == 13 || strlen(c_num) == 16))
    {
        printf("VISA\n");
    }
    else if (
        (strncmp(c_num, "51", 2) == 0 ||
         strncmp(c_num, "52", 2) == 0 ||
         strncmp(c_num, "53", 2) == 0 ||
         strncmp(c_num, "54", 2) == 0 ||
         strncmp(c_num, "55", 2) == 0) &&
        strlen(c_num) == 16)
    {
        printf("MASTERCARD\n");
    }
    else if (
        strncmp(c_num, "34", 2) == 0 ||
        strncmp(c_num, "37", 2) == 0 &&
        strlen(c_num) == 15)
    {
        printf("AMEX\n");
    }
    else
    {
        printf("INVALID\n");
    }

    // Free the memory allocated for the credit card number
    free(c_num);
    return 0;
}

int isValid(char *c_num)
{
    unsigned long len = strlen(c_num);
    int sum = 0;
    int digit;

    // Hans Peter Luhn's algorithm from the Wikipedia page: https://en.wikipedia.org/wiki/Luhn_algorithm
    /*
     * 1. Starting from the second-to-last digit, double every other digit
     * 2. If the doubled value of a digit is greater than 9, add the product's digits together.
     * 3. Sum the digits
     * 4. If the sum is a multiple of 10, the number is valid.
     */

    // Step 1
    /*
    Check if the length of the credit card is odd or even
    because we need to double every other digit *starting* from the second-to-last digit
     and the only way to know that is by checking the length
    */
    // Step 2
    /*
        If the length of the credit card is odd, then the second-to-last digit will be on an odd index
        Else, even index. So if i is even and length is even, we need to double that digit and vice versa.
        And if the doubled value of a digit is greater than 9, add the product's digits together.
        And we add all that to the sum.
    */
    // Step 3
    /*
        If the sum is a multiple of 10, the number is valid.
    */
    if (len % 2 == 1)
    {
        for (int i = 0; i < len; i++)
        {
            // Step 2
            digit = c_num[i] - '0';
            if (i % 2 == 1)
            {
                digit *= 2;
                if (digit > 9)
                {
                    // Add the products' digits together
                    digit = (digit % 10) + (digit / 10);
                }
            }
            sum += digit;
        }
    }
    else
    {
        for (int i = 0; i < len; i++)
        {
            digit = c_num[i] - '0';
            if (i % 2 == 0)
            {
                digit *= 2;
                if (digit > 9)
                {
                    digit = (digit % 10) + (digit / 10);
                }
            }
            sum += digit;
        }
    }

    return sum % 10 == 0;
}
