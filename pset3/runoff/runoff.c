#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max voters and candidates
#define MAX_VOTERS 100
#define MAX_CANDIDATES 9

// preferences[i][j] is jth preference for voter i
int preferences[MAX_VOTERS][MAX_CANDIDATES];

// Candidates have name, vote count, eliminated status
typedef struct
{
    string name;
    int votes;
    bool eliminated;
} candidate;

// Array of candidates
candidate candidates[MAX_CANDIDATES];

// Numbers of voters and candidates
int voter_count;
int candidate_count;

// Function prototypes
bool vote(int voter, int rank, string name);
void tabulate(void);
bool print_winner(void);
int find_min(void);
bool is_tie(int min);
void eliminate(int min);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: runoff [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1;
    if (candidate_count > MAX_CANDIDATES)
    {
        printf("Maximum number of candidates is %i\n", MAX_CANDIDATES);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i].name = argv[i + 1];
        candidates[i].votes = 0;
        candidates[i].eliminated = false;
    }

    voter_count = get_int("Number of voters: ");
    if (voter_count > MAX_VOTERS)
    {
        printf("Maximum number of voters is %i\n", MAX_VOTERS);
        return 3;
    }

    // Keep querying for votes
    for (int i = 0; i < voter_count; i++)
    {

        // Query for each rank
        for (int j = 0; j < candidate_count; j++)
        {
            string name = get_string("Rank %i: ", j + 1);

            // Record vote, unless it's invalid
            if (!vote(i, j, name))
            {
                printf("Invalid vote.\n");
                return 4;
            }
        }

        printf("\n");
    }

    // Keep holding runoffs until winner exists
    while (true)
    {
        // Calculate votes given remaining candidates
        tabulate();

        // Check if election has been won
        bool won = print_winner();
        if (won)
        {
            break;
        }

        // Eliminate last-place candidates
        int min = find_min();
        bool tie = is_tie(min);

        // If tie, everyone wins
        if (tie)
        {
            for (int i = 0; i < candidate_count; i++)
            {
                if (!candidates[i].eliminated)
                {
                    printf("%s\n", candidates[i].name);
                }
            }
            break;
        }

        // Eliminate anyone with minimum number of votes
        eliminate(min);

        // Reset vote counts back to zero
        for (int i = 0; i < candidate_count; i++)
        {
            candidates[i].votes = 0;
        }
    }
    return 0;
}

// Record preference if vote is valid
bool vote(int voter, int rank, string name)
{
    // For each candidate
    for (int i = 0; i < candidate_count; i++)
    {
        // If the candidate the voter chose is the same as the current candidate's name
        if (strcmp(candidates[i].name, name) == 0)
        {
            // Set the preferences for the voter and his rank to be the current candidate's index
            preferences[voter][rank] = i;

            // Return true
            return true;
        }
    }

    // Return false
    return false;
}

// Tabulate votes for non-eliminated candidates
void tabulate(void)
{
    // For each voter
    for (int i = 0; i < voter_count; i++)
    {
        // For each candidate
        for (int j = 0; j < candidate_count; j++)
        {
            // If the candidate is not eliminated
            if (!candidates[preferences[i][j]].eliminated)
            {
                // Increment candidate's votes
                candidates[preferences[i][j]].votes++;

                // Break to go to the next voter
                break;
            }
        }
    }

    // Return, ending the vote count
    return;
}

// Print the winner of the election, if there is one
bool print_winner(void)
{
    // Make a struct that includes the index of the candidate and his votes
    typedef struct
    {
        int index;
        int votes;
    } best;

    // Make an object of the struct
    best best_candidate;

    // For each candidate
    for (int i = 0; i < candidate_count; i++)
    {
        // If the current candidate's votes is more than any other candidate seen before
        if (candidates[i].votes > best_candidate.votes)
        {
            // Set the max votes to be the current candidate's votes
            best_candidate.votes = candidates[i].votes;

            // Set the candidate with the most votes to be the candidate's index
            best_candidate.index = i;
        }
    }

    // If the most votes a person has is bigger than 50% of the votes
    if (best_candidate.votes > voter_count / 2)
    {
        // Print the candidate with the most votes
        printf("%s\n", candidates[best_candidate.index].name);

        // Return true indicating that there is a winner
        return true;
    }

    // Return false indicating that there is no winner
    return false;
}

// Return the minimum number of votes any remaining candidate has
int find_min(void)
{
    // Set a variable called min to be the minimum amount of votes each candidate has
    int min = MAX_VOTERS;

    // For each candidate
    for (int i = 0; i < candidate_count; i++)
    {
        // If current candidate is not eliminated
        if (!candidates[i].eliminated)
        {
            // If current candidate's votes is less than the minimum number of votes
            if (candidates[i].votes < min)
            {
                // Set the minimum number of votes to be current candidate's votes
                min = candidates[i].votes;
            }
        }
        // If current candidate is eliminated
        else
        {
            // Set current candidate's votes to 0
            candidates[i].votes = 0;
        }
    }

    // Return minimum number of votes
    return min;
}

// Return true if the election is tied between all candidates, false otherwise
bool is_tie(int min)
{
    // The number of eliminated candidates
    int num_eliminated = 0;

    // The count of people that have the minimum number of votes and are not eliminated
    int count = 0;

    // For each candidate
    for (int i = 0; i < candidate_count; i++)
    {
        // If current candidate is eliminated
        if (candidates[i].eliminated)
        {
            // Increment the num_eliminated variable by 1
            num_eliminated++;
        }

        // If current candidate's votes are the minimum number of votes and current candidate is eliminated
        if (candidates[i].votes == min && !candidates[i].eliminated)
        {
            // Increment the count variable by 1
            count++;
        }
    }

    // If the number of candidates that have the minimum number of votes and they aren't eliminated equals the number of candidates subtracted by the number of eliminated candidates
    if (count == candidate_count - num_eliminated)
    {
        // Return true
        return true;
    }
    // Return false
    return false;
}

// Eliminate the candidate (or candidates) in last place
void eliminate(int min)
{
    // For each candidate
    for (int i = 0; i < candidate_count; i++)
    {
        // If current candidate's votes equal the minimum number of votes, eliminate current candidate
        if (candidates[i].votes == min)
        {
            candidates[i].eliminated = true;
        }
    }
    return;
}