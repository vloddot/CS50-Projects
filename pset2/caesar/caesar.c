#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        printf("Usage: %s key\n", argv[0]);
        return 1;
    }
    int key = atoi(argv[1]);

    char *plaintext = malloc(1024);
    printf("Plaintext: ");
    scanf("%s", plaintext);

    printf("Ciphertext: ");

    unsigned long length = strlen(plaintext);
    for (int i = 0; i < length; i++)
    {
        if (isalpha(plaintext[i]))
        {
            if (isupper(plaintext[i]))
            {
                printf("%s", (((plaintext[i] - 'A') + key) % 26) + 'A');
            }
            else if (islower(plaintext[i]))
            {
                printf("%s", (((plaintext[i] - 'a') + key) % 26) + 'a');
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