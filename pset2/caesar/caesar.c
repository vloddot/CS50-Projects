#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
int main(int argc, string argv[])
{
    int i;
    int j;
    // Checks if there is only 1 command line argument, and if not, return an error code of 1.
    if (argc != 2)
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }

    // If the command line argument is not a digit, return an error code of 2.
    for (i = 0; i < strlen(argv[1]); i++)
    {
        if (!isdigit(argv[1][i]))
        {
            printf("Usage: ./caesar key\n");
            return 1;
        }
    }
    // Gets the plaintext from the user.
    string plaintext = get_string("Plain text: ");
    int length = strlen(plaintext);
    int key = atoi(argv[1]);


    // Prints "Ciphertext: "
    printf("Ciphertext: ");

    
    // For each character of plaintext, add it by key.
    for (i = 0; i < length; i++)
    {
        if (isalpha(plaintext[i]))
        {
            int ASCII_N = plaintext[i];
            if (isupper(plaintext[i]))
            {
                // % 26 is for if the character was Z and wanted to loop around back to A or B.
                plaintext[i] = (ASCII_N - 65 + key) % 26 + 65;
                printf("%c", plaintext[i]);
            }
            else
            {
                plaintext[i] = (ASCII_N - 97 + key) % 26 + 97;
                printf("%c", plaintext[i]);
            }
        }
        else
        {
            // This is for if the character wasn't an alphabetical character, for example: punctuation.
            printf("%c", plaintext[i]);
        }
    }
    printf("\n");
    return 0;
}