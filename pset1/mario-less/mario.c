#include <stdio.h>

int main(void)
{
    // Asks user for input between 1 and 8
    int height;
    do
    {
        printf("Height: ");
        scanf("%i", &height);
    }
    while (height < 1 || height > 8);

    int i;
    int j;

    // If Height equals 3
    // i = 0
    // j = 3 - 1 = 2 true
    // j = 1 true
    // j = 0 false
    // Prints 2 spaces

    // i = 0
    // j = 0 true
    // j = 1 false
    // Prints one #
    // So, should look something like this (  #)
    // And when this repeats, should look like this:
    //   #
    //  ##
    // ###

    for (i = 0; i < height; i++)
    {
        for (j = height - 1; j > i; j--)
        {
            printf(" ");
        }

        for (j = 0; j <= i; j++)
        {
            printf("#");
        }
        printf("\n");
    }
}
