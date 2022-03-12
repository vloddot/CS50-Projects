#include "helpers.h"
#include <math.h>

// Convert image float grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    // For each pixel, calculate the average values of = round(chan_red);
    // For each pixel, calculate the average values oGreen round(chan_green);
    // For each pixel, calculate the average values oBlue round(chan_blue) R;GB in the pixel and convert each of red, green and blue to that average.
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            float average = round((image[i][j].rgbtRed + image[i][j].rgbtGreen + image[i][j].rgbtBlue) / 3.0);
            image[i][j].rgbtRed = average;
            image[i][j].rgbtGreen = average;
            image[i][j].rgbtBlue = average;
        }
    }
    return;
}

// Swap function for swapping in reflect()
void swap(RGBTRIPLE *a, RGBTRIPLE *b)
{
    RGBTRIPLE temp = *a;
    *a = *b;
    *b = temp;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    // For each pixel, swap the image's RGB values
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width / 2; j++)
        {
            swap(&image[i][j], &image[i][width - j - 1]);
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE copy[height][width];

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
            int x_start = j - 1;
            int x_end = j + 1;
            int y_start = i - 1;
            int y_end = i + 1;

            float average_red = 0;
            float average_green = 0;
            float average_blue = 0;
            float pixel_count = 0;

            for (int y = y_start; y <= y_end; y++)
            {
                for (int x = x_start; x <= x_end; x++)
                {
                    if (x >= 0 && x <= width - 1 && y >= 0 && y <= height - 1)
                    {
                        average_red += copy[y][x].rgbtRed;
                        average_green += copy[y][x].rgbtGreen;
                        average_blue += copy[y][x].rgbtBlue;
                        pixel_count++;
                    }
                }
            }

            average_red = round(average_red / pixel_count);
            average_green = round(average_green / pixel_count);
            average_blue = round(average_blue / pixel_count);

            if (average_red > 255)
            {
                average_red = 255;
            }

            if (average_green > 255)
            {
                average_green = 255;
            }

            if (average_blue > 255)
            {
                average_blue = 255;
            }

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
    // Gx and Gy arrays to traverse through
    int gx[3][3] =
    {
        {-1, 0, 1},
        {-2, 0, 2},
        {-1, 0, 1}
    };
    int gy[3][3] =
    {
        {-1, -2, -1},
        {0, 0, 0},
        {1, 2, 1}
    };

    RGBTRIPLE copy[height][width];

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
            int x_start = j - 1;
            int x_end = j + 1;
            int y_start = i - 1;
            int y_end = i + 1;

            float gx_red = 0.0;
            float gx_green = 0.0;
            float gx_blue = 0.0;

            float gy_red = 0.0;
            float gy_green = 0.0;
            float gy_blue = 0.0;

            for (int y = y_start; y <= y_end; y++)
            {
                for (int x = x_start; x <= x_end; x++)
                {
                    if (x >= 0 && x <= width - 1 && y >= 0 && y <= height - 1)
                    {
                        gx_red += copy[y][x].rgbtRed * gx[y - y_start][x - x_start];
                        gx_green += copy[y][x].rgbtGreen * gx[y - y_start][x - x_start];
                        gx_blue += copy[y][x].rgbtBlue * gx[y - y_start][x - x_start];

                        gy_red += copy[y][x].rgbtRed * gy[y - y_start][x - x_start];
                        gy_green += copy[y][x].rgbtGreen * gy[y - y_start][x - x_start];
                        gy_blue += copy[y][x].rgbtBlue * gy[y - y_start][x - x_start];
                    }
                }
            }

            float chan_red = sqrt((gx_red * gx_red) + (gy_red * gy_red));
            float chan_green = sqrt((gx_green * gx_green) + (gy_green * gy_green));
            float chan_blue = sqrt((gx_blue * gx_blue) + (gy_blue * gy_blue));

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
