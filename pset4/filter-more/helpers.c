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

// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    // Create a copy of the image stored in memory
    RGBTRIPLE copy[height][width];

    // For each pixel
    for (int i = 0; i < height; i++) {

        for (int j = 0; j < width; j++) {

            // Copy the entire image onto this new one into memory
            copy[i][j] = image[i][j];
        }
    }

    // Gx and Gy arrays to traverse through
    int gx[3][3] = {
        {-1, 0, 1},
        {-2, 0, 2},
        {-1, 0, 1}
    };

    int gy[3][3] = {
        {-1, -2, -1},
        {0, 0, 0},
        {1, 2, 1}
    };

    // For each pixel
    for (int i = 0; i < height; i++) {

        for (int j = 0; j < width; j++) {

            // Set the borders of our image
            int x_start = j - 1;
            int x_end = j + 1;
            int y_start = i - 1;
            int y_end = i + 1;

            // Gx and Gy RGB values
            float gx_red = 0;
            float gx_green = 0;
            float gx_blue = 0;

            float gy_red = 0;
            float gy_green = 0;
            float gy_blue = 0;

            // For each pixel in the borders we created
            for (int y = y_start; y <= y_end; y++) {

                for (int x = x_start; x <= x_end; x++) {

                    // If the x and y aren't outside of the image's resolution
                    if (x >= 0 && x <= width - 1 && y >= 0 && y <= height - 1) {

                        // Add the RGB values of the copy of the image multiplied by the Gx of the current pixel
                        gx_red += copy[y][x].rgbtRed * gx[y_end - y][x_end - x];
                        gx_green += copy[y][x].rgbtGreen * gx[y_end - y][x_end - x];
                        gx_blue += copy[y][x].rgbtBlue * gx[y_end - y][x_end - x];

                        // Add the RGB values of the copy of the image multiplied by the Gy of the current pixel
                        gy_red += copy[y][x].rgbtRed * gy[y_end - y][x_end - x];
                        gy_green += copy[y][x].rgbtGreen * gy[y_end - y][x_end - x];
                        gy_blue += copy[y][x].rgbtBlue * gy[y_end - y][x_end - x];

                    }
                }
            }

            // Calculate the RGB channels of the current pixels using the square red
            // of gx squared + gy squared
            float chan_red = sqrt((gx_red * gx_red) + (gy_red * gy_red));
            float chan_green = sqrt((gx_green * gx_green) + (gy_green * gy_green));
            float chan_blue = sqrt((gx_blue * gx_blue) + (gy_blue * gy_blue));

            // Truncate channels to 255 if they're bigger than 255
            if (chan_red > 255) chan_red = 255;
            if (chan_green > 255) chan_green = 255;
            if (chan_blue > 255) chan_blue = 255;

            image[i][j].rgbtRed = round(chan_red);
            image[i][j].rgbtGreen = round(chan_green);
            image[i][j].rgbtBlue = round(chan_blue);
        }
    }
    return;
}
