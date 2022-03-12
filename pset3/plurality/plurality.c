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
} candidate;

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
    // Specifying name and number of votes for each candidate.
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
    // For each candidate
    for (int i = 0; i < candidate_count; i++)
    {
        // If the given name from the input equals the current candidate's name
        if (strcmp(candidates[i].name, name) == 0)
        {
            // Increment current candidate's votes by 1
            candidates[i].votes++;

            // Return true indicating that vote is counted
            return true;
        }
    }

    // Return false indicating that vote is not counted
    return false;
}
// Print the winner (or winners) of the election
void print_winner(void)
{
    // Make a structure including the best candidate's votes and name
    typedef struct
    {
        string name;
        int votes;
    } best;

    // Create a best candidate object
    best best_candidate;

    // Set best candidate's votes to 0 as a starting point
    best_candidate.votes = 0;

    for (int i = 0; i < candidate_count; i++)
    {
        // If current candidate has more votes than the best candidate
        if (candidates[i].votes > best_candidate.votes)
        {
            // Set the best candidate to be the current candidate with all of his data passed in
            best_candidate.votes = candidates[i].votes;
            best_candidate.name = candidates[i].name;
        }

        // If there's a tie
        else if (candidates[i].votes == best_candidate.votes)
        {
            // Print current candidate
            printf("%s\n", candidates[i].name);
        }
    }

    // Print best candidate
    printf("%s\n", best_candidate.name);
    return;
}