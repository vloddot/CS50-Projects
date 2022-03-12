#include "helpers.h"
#include <math.h>
// Swap function in order to swap pixel values in the reflect function.
void swap(RGBTRIPLE *a, RGBTRIPLE *b)
{
    RGBTRIPLE temp = *a;
    *a = *b;
    *b = temp;
}
// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    // For each pixel, calculate the average values of RGB in the pixel and convert each of red, green, and blue to that average.
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            /* has to be / 3.0 to change value to a float */
            int average = round((image[i][j].rgbtRed + image[i][j].rgbtGreen + image[i][j].rgbtBlue) / 3.0);
            /* setting each red, green, and blue value to the average (i.e., average of red, green, and blue in the pixel) */
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
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            // Initialize the sepia versions of each color for each pixel.
            int sepiaRed = round((.393 * image[i][j].rgbtRed) + (.769 * image[i][j].rgbtGreen) + (.189 * image[i][j].rgbtBlue));
            int sepiaGreen = round((.349 * image[i][j].rgbtRed) + (.686 * image[i][j].rgbtGreen) + (.168 * image[i][j].rgbtBlue));
            int sepiaBlue = round((.272 * image[i][j].rgbtRed) + (.534 * image[i][j].rgbtGreen) + (.131 * image[i][j].rgbtBlue));
            // If any of these sepia versions aren't between 0 and 255, round them to the nearest number.
            if (sepiaRed > 255)
            {
                sepiaRed = 255;
            }
            if (sepiaRed < 0)
            {
                sepiaRed = 0;
            }
            if (sepiaGreen > 255)
            {
                sepiaGreen = 255;
            }
            if (sepiaGreen < 0)
            {
                sepiaGreen = 0;
            }
            if (sepiaBlue > 255)
            {
                sepiaRed = 255;
            }
            if (sepiaBlue < 0)
            {
                sepiaBlue = 0;
            }

            // Set the values of each pixel to its sepia version.
            image[i][j].rgbtBlue = sepiaBlue;
            image[i][j].rgbtGreen = sepiaGreen;
            image[i][j].rgbtRed = sepiaRed;
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    // For each pixel in the image, swap the image values from the right, all the way to the left
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width / 2; j++)
        {
            // Swap the values of the pixels in each row from pixel 0 to pixel width - 1.
            swap(&image[i][j], &image[i][width - j - 1]);
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    int x_start;
    int x_end;
    int y_start;
    int y_end;
    float pixel_count = 0.0;
    RGBTRIPLE copy[height][width];
    // Initializing a new copy of image[height][width]
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            copy[i][j] = image[i][j];
        }
    }
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            // Get the radius of the pixels needed.
            y_start = i - 1;
            y_end = i + 1;
            x_start = j - 1;
            x_end = j + 1;
            // Checking if the radius is outside of the image array.
            if (y_start < 0)
            {
                y_start = 0;
            }
            if (y_end > height - 1)
            {
                y_end = height - 1;
            }
            if (x_start < 0)
            {
                x_start = 0;
            }
            if (x_end > width - 1)
            {
                x_end = width - 1;
            }
            float average_red = 0.0;
            float average_green = 0.0;
            float average_blue = 0.0;
            // For each pixel in the radius, add the values of their RGB, and increment the pixel count.
            for (int y = y_start; y <= y_end; y++)
            {
                for (int x = x_start; x <= x_end; x++)
                {
                    average_red += copy[y][x].rgbtRed;
                    average_green += copy[y][x].rgbtGreen;
                    average_blue += copy[y][x].rgbtBlue;
                    pixel_count++;
                }
            }
            // Set the red, green, and blue values created by the average of the red, green, and blue to the current pixel, and set the pixel count to 0.
            image[i][j].rgbtRed = round(average_red / pixel_count);
            image[i][j].rgbtGreen = round(average_green / pixel_count);
            image[i][j].rgbtBlue = round(average_blue / pixel_count);
            pixel_count = 0;
        }
    }
    return;
}