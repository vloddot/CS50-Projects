#include <cs50.h>
#include <stdio.h>
#include <math.h>

int main(void)
{
    // Prompt for start size

    int start_size;
    do
    {
        start_size = get_int("Start size: ");

    } while (start_size < 9);
    
    // Prompt for end size
    int end_size;
    do
    {
        end_size = get_int("End size: ");

    } while (end_size < start_size);
    
    // Calculate number of years until we reach threshold

    int years = 0;
    while (start_size < end_size)
    {
        start_size += round(start_size / 3);
        start_size -= round(start_size / 4);

        years++;
    }
    // Print number of years

    printf("Years: %i\n", years);
}
