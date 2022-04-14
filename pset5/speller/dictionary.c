// Implements a dictionary's functionality

#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>
#include <stdlib.h>

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
const unsigned int N = (LENGTH + 1) * 'z';

// Hash table
node *table[N];

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    int index = hash(word);

    node *cursor = table[index];

    while (cursor != NULL)
    {
        if (strcasecmp(tolower(cursor->word), word) == 0)
        {
            return true;
        }

        cursor = cursor->next;
    }

    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    unsigned int sum = 0;

    for (int i = 0; i < strlen(word); i++)
    {
        sum += tolower(word[i]);
    }

    return sum % N;
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    // Open dictionary file
    FILE *file = fopen(dictionary, "r");

    // If there's no place in memory for loading a file into memory, throw an error
    if (file == NULL) return false;

    // Create a word buffer that has LENGTH + 1 chars and + 1 is for the terminating
    // null character '\0' and LENGTH is the length of the biggest possible word
    char word[LENGTH + 1];

    // Read the entirety of the file and each time put it into the word buffer
    while (fscanf(file, "%s", word) == 1) 
    {
        // Allocate memory for a new node
        node *n = malloc(sizeof(node));

        // If there's no place in memory for loading a file into memory, throw an error
        if (n == NULL) return false;

        // Copy the current word buffer into the node's word
        strcpy(n->word, word);

        // Set the next node pointer in the linked list to NULL because we don't know
        // which memory location we're going to point to
        n->next = NULL;

        // Hash the word
        int index = hash(n->word);

        // If the hashed word doesn't have a hash created yet
        if (table[index] == NULL) 
        {
            table[index] = n;
        }

        else
        {
            n->next = table[index];
            table[index] = n;
        }

        j++;
    }

    fclose(file);

    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{    
    return j;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    for (int i = 0; i < N; i++)
    {
        node *head = table[i];
        node *cursor = head;
        node *temp = cursor;

        while (cursor != NULL)
        {
            cursor = cursor->next;

            free(temp);

            temp = cursor;
        }
    }

    return true;
}
