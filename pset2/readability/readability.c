#include <cs50.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

float count_words(string text);
float count_letters(string text);
float count_sentences(string text);
int main(void)
{
    // Calculating letters, words and sentences of the text given.
    string text = get_string("Text: ");
    float n_letters = count_letters(text);
    float n_words = count_words(text);
    float n_sentences = count_sentences(text);

    // Calculates the number of letters per 100 words.
    float L = n_letters / n_words * 100;

    // Calculates the number of sentences per 100 words.
    float S = n_sentences / n_words * 100;

    // Calculates the index using the Coleman-Liau formula.
    float index = 0.0588 * L - 0.296 * S - 15.8;


    if (index > 16)
    {
        printf("Grade 16+\n");
    }


    else if (index < 1)
    {
        printf("Before Grade 1\n");
    }


    else
    {
        printf("Grade %i\n", (int) round(index));
    }
}

float count_letters(string text)
{
    float n_letters = 0;
    // For each letter of the text, check if it's alphabetical. If it is, add n_letters by 1.
    // If not alphabetical, just continue.
    // Return the value of n_letters.
    for (int i = 0; i < strlen(text); i++)
    {
        if (isalpha(text[i]))
        {
            n_letters = n_letters + 1;
        }
        else
        {
            continue;
        }
    }
    return n_letters;
}

float count_words(string text)
{
    float n_words = 0;
    // For each letter of the text, if it's a space, add n_words by 1.
    // If not a space, just continue.
    // Add n_words by 1 for the last word that might not include a space.
    // Return the value of n_words.
    for (int i = 0; i < strlen(text); i++)
    {
        if (isspace(text[i]))
        {
            n_words = n_words + 1;
        }
        else
        {
            continue;
        }

    }
    n_words = n_words + 1;
    return n_words;
}
float count_sentences(string text)
{
    float n_sentences = 0;
    // For each letter of the text, check if it has a dot, an exclamation point, or a question mark, and for each one, add n_sentences by 1.
    // If it's not a dot, an exclamation point, or a question mark, just continue.
    // Return the value of n_sentences.
    for (int i = 0; i < strlen(text); i++)
    {
        if (text[i] == '.' || text[i] == '!' || text[i] == '?')
        {
            n_sentences = n_sentences + 1;
        }
        else
        {
            continue;
        }
    }
    return n_sentences;
}