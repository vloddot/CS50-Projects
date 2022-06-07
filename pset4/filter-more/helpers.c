#include "helpers.h"
#include <math.h>
#include <stdio.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            int avg = round((image[i][j].rgbtBlue + image[i][j].rgbtGreen + image[i][j].rgbtRed) / 3.0);
            image[i][j].rgbtBlue = avg;
            image[i][j].rgbtGreen = avg;
            image[i][j].rgbtRed = avg;
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width / 2; j++)
        {
            RGBTRIPLE temp = image[i][j];
            image[i][j] = image[i][width - j - 1];
            image[i][width - j - 1] = temp;
        }
    }
    return;
}

// Blur image using Box Blur
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE temp[height][width];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            temp[i][j] = image[i][j];
        }
    }
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            float sumBlue = 0;
            float sumGreen = 0;
            float sumRed = 0;
            float count = 0;
            for (int k = -1; k < 2; k++)
            {
                for (int l = -1; l < 2; l++)
                {
                    if (i + k >= 0 && i + k < height && j + l >= 0 && j + l < width)
                    {
                        sumBlue += temp[i + k][j + l].rgbtBlue;
                        sumGreen += temp[i + k][j + l].rgbtGreen;
                        sumRed += temp[i + k][j + l].rgbtRed;
                        count++;
                    }
                }
            }
            image[i][j].rgbtBlue = round(sumBlue / count);
            image[i][j].rgbtGreen = round(sumGreen / count);
            image[i][j].rgbtRed = round(sumRed / count);
        }
    }
    return;
}

// Detect edges using Sobel operator
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE temp[height][width];
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            temp[i][j] = image[i][j];
        }
    }

    int Gx[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
    int Gy[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
    for (int i = 0; i < height; i++)
    {
        for (int j = 0; j < width; j++)
        {
            float sumGxRed = 0;
            float sumGxBlue = 0;
            float sumGxGreen = 0;

            float sumGyRed = 0;
            float sumGyGreen = 0;
            float sumGyBlue = 0;
            for (int k = -1; k < 2; k++)
            {
                for (int l = -1; l < 2; l++)
                {
                    if (i + k >= 0 && i + k < height && j + l >= 0 && j + l < width)
                    {
                        sumGxRed += temp[i + k][j + l].rgbtRed * Gx[k + 1][l + 1];
                        sumGxGreen += temp[i + k][j + l].rgbtGreen * Gx[k + 1][l + 1];
                        sumGxBlue += temp[i + k][j + l].rgbtBlue * Gx[k + 1][l + 1];

                        sumGyRed += temp[i + k][j + l].rgbtRed * Gy[k + 1][l + 1];
                        sumGyGreen += temp[i + k][j + l].rgbtGreen * Gy[k + 1][l + 1];
                        sumGyBlue += temp[i + k][j + l].rgbtBlue * Gy[k + 1][l + 1];
                    }
                }
            }
            float chan_red = sqrt(pow(sumGxRed, 2) + pow(sumGyRed, 2));
            float chan_green = sqrt(pow(sumGxGreen, 2) + pow(sumGyGreen, 2));
            float chan_blue = sqrt(pow(sumGxBlue, 2) + pow(sumGyBlue, 2));

            if (chan_red > 255)
            {
                chan_red = 255;
            }

            if (chan_green > 255)
            {
                chan_green = 255;
            }

            if (chan_blue > 255)
            {
                chan_blue = 255;
            }

            image[i][j].rgbtRed = round(chan_red);
            image[i][j].rgbtGreen = round(chan_green);
            image[i][j].rgbtBlue = round(chan_blue);
        }
    }
    return;
}
