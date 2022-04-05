#include "helpers.h"
#include <math.h>

// Swap function to use inside of reflect
void swap(RGBTRIPLE *a, RGBTRIPLE *b) {
    RGBTRIPLE temp = *a;
    *a = *b;
    *b = temp;
}

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    // For each pixel
    for (int i = 0; i < height; i++) {

        for (int j = 0; j < width; j++) {

            // Get the average of each of red, green, and blue of the current pixel
            float average = round((image[i][j].rgbtRed + image[i][j].rgbtGreen + image[i][j].rgbtBlue) / 3.0);

            // Set each red, green, and blue value of the current pixel to the average
            image[i][j].rgbtRed = average;
            image[i][j].rgbtGreen = average;
            image[i][j].rgbtBlue = average;
        }
    }

    return;
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++) {

        for (int j = 0; j < width; j++) {

            float sepiaRed = round(
                  0.393 * image[i][j].rgbtRed
                + 0.769 * image[i][j].rgbtGreen
                + 0.189 * image[i][j].rgbtBlue
            );

            float sepiaGreen = round(
                  0.349 * image[i][j].rgbtRed
                + 0.686 * image[i][j].rgbtGreen
                + 0.168 * image[i][j].rgbtBlue
            );

            float sepiaBlue = round(
                  0.272 * image[i][j].rgbtRed
                + 0.534 * image[i][j].rgbtGreen
                + 0.131 * image[i][j].rgbtBlue
            );

            if (sepiaRed > 255) sepiaRed = 255;
            if (sepiaGreen > 255) sepiaGreen = 255;
            if (sepiaBlue > 255) sepiaBlue = 255;

            image[i][j].rgbtRed = sepiaRed;
            image[i][j].rgbtGreen = sepiaGreen;
            image[i][j].rgbtBlue = sepiaBlue;
        }
    }

    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    // For each pixel
    for (int i = 0; i < height; i++) {

        for (int j = 0; j < width / 2; j++) {

            // Swap the pixels on the left and right
            swap(&image[i][j], &image[i][width - j - 1]);
        }
    }

    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
        // Create a copy of the image stored in memory
    RGBTRIPLE copy[height][width];

    // For each pixel
    for (int i = 0; i < height; i++) {

        for (int j = 0; j < width; j++) {

            // Set the RGB values of the image to the new copy we just created
            copy[i][j] = image[i][j];
        }
    }

    // For each pixel
    for (int i = 0; i < height; i++) {

        for (int j = 0; j < width; j++) {

            // Calculate the borders of the entire block we want to blur
            int x_start = j - 1;
            int x_end = j + 1;
            int y_start = i - 1;
            int y_end = i + 1;

            // Declare average values for each RGB value
            float average_red = 0;
            float average_green = 0;
            float average_blue = 0;

            // Declare the pixel count
            float pixel_count = 0;

            // For each pixel of the borders we calculated
            for (int y = y_start; y <= y_end; y++) {

                for (int x = x_start; x <= x_end; x++) {
                    
                    // If the current pixel isn't outside the image resolution
                    if (x >= 0 && x <= width - 1 && y >= 0 && y <= height - 1) {

                        // Add in the RGB values of the pixels inside of the borders to averages
                        average_red += copy[y][x].rgbtRed;
                        average_green += copy[y][x].rgbtGreen;
                        average_blue += copy[y][x].rgbtBlue;

                        // Increment pixel count by 1
                        pixel_count++;
                    }
                }
            }

            // Average the RGB values of the borders
            average_red = round(average_red / pixel_count);
            average_green = round(average_green / pixel_count);
            average_blue = round(average_blue / pixel_count);

            // Truncate averages to 255 if they're bigger than 255
            if (average_red > 255) average_red = 255;

            if (average_green > 255) average_green = 255;

            if (average_blue > 255) average_blue = 255;

            // Reset the image
            image[i][j].rgbtRed = average_red;
            image[i][j].rgbtGreen = average_green;
            image[i][j].rgbtBlue = average_blue;
        }
    }

    return;
}
