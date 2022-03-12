#include <ctype.h>
#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Points assigned to each letter of the alphabet
int POINTS[] = {1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10};

int compute_score(string word);
int j = 0;
int main(void)
{
    // Get input words from both players
    string word1 = get_string("Player 1: ");
    string word2 = get_string("Player 2: ");

    // Score both words
    int score1 = compute_score(word1);
    int score2 = compute_score(word2);
    // If Player 1's score is higher than Player 2's score, print Player 1 Wins!\n
    if (score1 > score2)
    {
        printf("Player 1 Wins!\n");
    }
    // If Player 2's score is higher than Player 1's score, print Player 2 Wins!\n
    else if (score1 < score2)
    {
        printf("Player 2 Wins!\n");
    }
    // If both conditions aren't true, then it has to be a tie, so print Tie\n
    else
    {
        printf("Tie!\n");
    }
}

int compute_score(string word)
{
    int score = 0;
    int sum_of_score = 0;
    // For each letter in the sentence, execute the following
    for (int i = 0; i <= strlen(word); i++)
    {
        // Using ASCII letters, we can identify which point gets assigned to each A-Z letter by subtracting 65 from the ASCII number of the letter.
        // For example, A is 65 in ASCII, and to get POINTS[0], which equals 1, we subtract 65 from A, and put that in a variable then put it as POINTS[J].
        j = word[j];
        j = toupper(word[i]);
        j -= 65;
        // For any issues on punctuation or any other strange characters the user inputs, we set its value to -1.
        if (j < 0 || j > 26)
        {
            j = -1;
        }
        score = POINTS[j];
        // Calculating the amount of scores.
        sum_of_score += score;
    }
    return sum_of_score;
}
