#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Usage: ./recover IMAGE\n");
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (file == NULL)
    {
        printf("File cannot be opened\n");
        return 1;
    }
    const int BLOCK_SIZE = 512;
    uint8_t buffer[BLOCK_SIZE];
    int count = -1;
    FILE *img = NULL;
    char filename[8];
    // Read 512 bytes until end of file.
    while (fread(&buffer, BLOCK_SIZE, sizeof(char), file))
    {
        // If JPEG header
        if (buffer[0] == 0xff && buffer[1] == 0xd8 && buffer[2] == 0xff && (buffer[3] & 0xf0) == 0xe0)
        {
            count++;
            sprintf(filename, "%03i.jpg", count);
            // If another JPEG close the image.
            if (count > 0)
            {
                fclose(img);
            }

            // Open file in write mode.
            img = fopen(filename, "w");
            // If file could not be written.
            if (img == NULL)
            {
                printf("Could not write to file\n");
                return 1;
            }
        }
        // If file didn't end, write to it.
        if (count >= 0)
        {
            fwrite(&buffer, BLOCK_SIZE, sizeof(char), img);
        }
    }
    // Close files.
    fclose(img);
    fclose(file);
}