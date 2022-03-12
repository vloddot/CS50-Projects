#include <stdio.h>
#include <cs50.h>

int main(void)
{
    int Height = 0;
    do
    {
        Height = get_int("Height: ");
    }
    while (Height < 1 || Height > 8);

    
    for (int i = 0; i < Height; i++)
    {
        for (int j = Height - 1; j > i; j--)
        {
            printf(" ");
        }
        for (int j = 0; j <= i; j++)
        {
            printf("#");
        }

        printf("  ");

        for (int j = 0; j <= i; j++)
        {
            printf("#");
        }
        printf("\n");
    }

}