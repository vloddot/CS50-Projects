#include <cs50.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, string argv[])
{
    int i;
    int j;
    string key = argv[1];


    // If there is less than 1 or more than 1 command line argument, inform user and return an error code of 1.
    if (argc != 2)
    {
        printf("Usage: ./substitution key\n");
        return 1;
    }


    // If the key contains less than or more than 26 characters, inform user and return an error code of 1.
    if (strlen(argv[1]) != 26)
    {
        printf("Key must contain 26 characters.\n");
        return 1;
    }

    // If the key contains non-alphabetical characters, inform user and return an error code of 1.
    for (i = 0; i < strlen(argv[1]); i++)
    {
        if (!isalpha(argv[1][i]))
        {
            printf("Key must contain alphabetical characters.\n");
            return 1;
        }
    }

    // If there are any duplicate characters, inform user and return an error code of 1.
    for (i = 0; i < 26; i++)
    {
        for (j = i + 1; j < 26; j++)
        {
            if (tolower(key[i]) == tolower(key[j]))
            {
                printf("Key must not contain duplicate characters.\n");
                return 1;
            }
        }
    }

    string plaintext = get_string("plaintext: ");
    printf("ciphertext: ");
    int length = strlen(plaintext);

    // If a letter of the plaintext is alphabetical, check if it's uppercase or lowercase.
    // And if it's uppercase, subtract it by 65 i.e., capital A, and print it.
    // And if it's lowercase, subtract it by 97 i.e., lowercase a, and print it.

    // If it's not alphabetical, just print it.
    for (i = 0; i < length; i++)
    {
        if (isalpha(plaintext[i]))
        {
            if (isupper(plaintext[i]))
            {
                plaintext[i] = key[plaintext[i] - 'A'];
                printf("%c", toupper(plaintext[i]));
            }
            else
            {
                plaintext[i] = key[plaintext[i] - 'a'];
                printf("%c", tolower(plaintext[i]));
            }
        }
        else
        {
            printf("%c", plaintext[i]);
        }
    }
    printf("\n");
    return 0;
}