// Implements a dictionary's functionality

#include <ctype.h>
#include <stdbool.h>
#include <strings.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <cs50.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;
int j = 0;
// Choose number of buckets in hash table
const unsigned int N = 26;

// Hash table
node *table[N];

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    int location = hash(word);
    while (table[location]->next != NULL)
    {
        if (strcasecmp(table[location]->word, word) == 0)
        {
            return true;
        }
    }
    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    return toupper(word[0]) - 'A';
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    // Open the dictionary
    FILE *file = fopen(dictionary, "r");

    // If the file equals null, meaning an error occured while opening the file, return false and send an error
    if (file == NULL)
    {
        return false;
    }

    char *word = malloc(sizeof(char) * LENGTH);

    // Loop over all of the words in the dictionary to manage hash tables (function breaks when end of list inside loop body)
    while (true)
    {
        // Scan word and put return value in a variable to use return type later
        int scan = fscanf(file, "%s", word);

        // If the scanning is done, stop the infinite loop
        if (scan == EOF)
        {
            free(file);
            return true;
        }
        j++;
        // Allocate new node on the heap
        node *n = malloc(sizeof(node));

        // If there is no memory for allocating a new node, return false and send an error
        if (n == NULL)
        {
            return false;
        }

        // Copy the current word into the node's word
        strcpy(n->word, word);

        // Hash the word
        int location = hash(n->word);

        // Maybe? Insert the word into the hash table

        // Set the next memory location in the node to be the first element in the hash table
        n->next = malloc(sizeof(node));

        n->next = table[location];

        table[location] = n;
        free(n);
    }
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    return j;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    for (int i = 0; i < j; i++)
    {
        while (table[i]->next != NULL)
        {
            free(table[i]);
        }
    }
    return false;
}
