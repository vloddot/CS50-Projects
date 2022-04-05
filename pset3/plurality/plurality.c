#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max number of candidates
#define MAX 9

// Candidates have name and vote count
typedef struct
{
    string name;
    int votes;
}
candidate;

// Array of candidates
candidate candidates[MAX];

// Number of candidates
int candidate_count;

// Function prototypes
bool vote(string name);
void print_winner(void);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: plurality [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1;
    if (candidate_count > MAX)
    {
        printf("Maximum number of candidates is %i\n", MAX);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i].name = argv[i + 1];
        candidates[i].votes = 0;
    }

    int voter_count = get_int("Number of voters: ");

    // Loop over all voters
    for (int i = 0; i < voter_count; i++)
    {
        string name = get_string("Vote: ");

        // Check for invalid vote
        if (!vote(name))
        {
            printf("Invalid vote.\n");
        }
    }

    // Display winner of election
    print_winner();
}

// Update vote totals given a new vote
bool vote(string name)
{
    for (int i = 0; i < candidate_count; i++) {

        if (strcmp(name, candidates[i].name) == 0) {

            candidates[i].votes++;
            return true;
        }
    }

    return false;
}

// Print the winner (or winners) of the election
void print_winner(void)
{
    // Create a new candidate object which will store the best candidate in the entire election
    candidate best_candidate;

    // Declare the votes of the best candidate as 0
    best_candidate.votes = 0;

    // For each candidate
    for (int i = 0; i < candidate_count; i++) {

        // If the best candidate's votes is less than the current candidate's votes
        if (best_candidate.votes < candidates[i].votes) {

            // Set the new best candidate to be the current candidate
            best_candidate = candidates[i];
        }

        // If the best candidate's votes weren't less than the current votes
        // then check if it equals it
        else if (best_candidate.votes == candidates[i].votes) {

            // Print the current candidate's name
            printf("%s\n", candidates[i].name);
        }
    }

    // Print the best candidate's name
    printf("%s\n", best_candidate.name);
    return;
}