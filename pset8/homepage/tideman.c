#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Max number of candidates
#define MAX 9

// preferences[i][j] is number of voters who prefer i over j
int preferences[MAX][MAX];

// locked[i][j] means i is locked in over j
bool locked[MAX][MAX];

// Each pair has a winner, loser
typedef struct
{
    int winner;
    int loser;
}
pair;

// Array of candidates
string candidates[MAX];
pair pairs[MAX * (MAX - 1) / 2];

int pair_count;
int candidate_count;

// Update preferences given one voter's ranks
bool vote(int rank, string name, int ranks[])
{
    // For each candidate, if their name matches the current candidates' name, set their rank to the current count and return true
    for (int i = 0; i < candidate_count; i++)
    {
        if (strcmp(name, candidates[i]) == 0)
        {
            ranks[rank] = i;
            return true;
        }
    }
    // If none of them match the candidates, just return false
    return false;
}
void record_preferences(int ranks[])
{
    // Two for loops in order to record the preferences based on the ranks[] array
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = i; j < candidate_count; j++)
        {
            preferences[ranks[i]][ranks[j + 1]]++;
        }
    }
    for (int i = 0; i < candidate_count; i++)
    {
        preferences[i][i] = 0;
    }
    return;
}

// Record pairs of candidates where one is preferred over the other
void add_pairs(void)
{
    // Two for loops in which if one candidate is preferred over the other, set the pairs array's winners and losers
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            if (preferences[i][j] > preferences[j][i])
            {
                pairs[pair_count].winner = i;
                pairs[pair_count].loser = j;
                pair_count++;
            }
        }
    }
    return;
}

// Sort pairs in decreasing order by strength of victory
void sort_pairs(void)
{
    int j;
    pair temp;
    // Bubble sort implementation
    for (int i = 1; i < pair_count; i++)
    {
        temp = pairs[i];
        for (j = i - 1; j >= 0 && preferences[pairs[j].winner][pairs[j].loser] < preferences[temp.winner][temp.loser]; j--)
        {
            pairs[j + 1] = pairs[j];
        }
        pairs[j + 1] = temp;
    }
}
bool isCycle(int winner, int loser, int winCycle, int loseCycle)
{
    locked[winCycle][loseCycle] = true;

    for (int i = 0; i < candidate_count; i++)
    {
        if (locked[loser][i] == true)
        {
            if (winCycle == loser && loseCycle == i)
            {
                return true;
            }
            if (isCycle(loser, i, winCycle, loseCycle) == true)
            {
                return true;
            }
        }
    }
    return false;
}
void lock_pairs(void)
{
    for (int i = 0; i < pair_count; i++)
    {
        int win = pairs[i].winner;
        int loss = pairs[i].loser;
        // For each iteration, check if it's not a cycle, if it's not, set the 2D locked boolean array to true
        if (isCycle(win, loss, win, loss) == false)
        {
            locked[win][loss] = true;
        }
        // For each iteration, check if it's a cycle, if it is, set the 2D locked boolean array to false
        if (isCycle(win, loss, win, loss) == true)
        {
            locked[win][loss] = false;
        }
    }
}


// Print the winner of the election
void print_winner(void)
{
    int counter = 0;
    for (int i = 0; i < pair_count; i++)
    {
        for (int j = 0; j < pair_count; j++)
        {
            // For each column, check if a candidate is being pointed to and increment the counter by 1
            if (locked[j][i] == false)
            {
                counter++;
            }
        }
        // If the current column has no arrows pointed to them, print the current candidate
        if (counter == pair_count)
        {
            printf("%s\n", candidates[i]);
        }
        // Reset counter
        counter = 0;
    }
    return;
}

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: tideman [candidate ...]\n");
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
        candidates[i] = argv[i + 1];
    }

    // Clear graph of locked in pairs
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            locked[i][j] = false;
        }
    }

    pair_count = 0;
    int voter_count = get_int("Number of voters: ");

    // Query for votes
    for (int i = 0; i < voter_count; i++)
    {
        // ranks[i] is voter's ith preference
        int ranks[candidate_count];

        // Query for each rank
        for (int j = 0; j < candidate_count; j++)
        {
            string name = get_string("Rank %i: ", j + 1);

            if (!vote(j, name, ranks))
            {
                printf("Invalid vote.\n");
                return 3;
            }
        }

        record_preferences(ranks);

        printf("\n");
    }

    add_pairs();
    sort_pairs();
    lock_pairs();
    print_winner();
    return 0;
}