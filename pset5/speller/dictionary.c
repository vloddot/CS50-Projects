// Implements a dictionary's functionality

#include <ctype.h>
#include <stdbool.h>
#include <strings.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

unsigned int words = 0;
// TODO: Choose number of buckets in hash table
const unsigned int N = (LENGTH + 1) * 'z';

// Hash table
node *table[N];

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    unsigned int location = hash(word);
    node *cursor = table[location];
    while (cursor != NULL) {
        if (strcasecmp(cursor->word, word) == 0) {
            return true;
        }
        cursor = cursor->next;
    }

    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO: Improve this hash function
    unsigned int hash = 0;
    for (int i = 0; i < strlen(word); i++)
    {
        hash += (unsigned int) tolower(word[i]);
    }
    return hash % N;
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{
    FILE *file = fopen(dictionary, "r");

    if (file == NULL) {
        return false;
    }

    char word[LENGTH + 1];
    while (fscanf(file, "%s", word) != EOF) {
        node *new_node = malloc(sizeof(node));
        if (new_node == NULL) {
            return false;
        }

        strcpy(new_node->word, word);
        new_node->next = NULL;

        int location = hash(word);
        if (table[location] == NULL) {
            table[location] = new_node;
        } else {
            new_node->next = table[location];
            table[location] = new_node;
        }
        words++;
    }

    fclose(file);
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    return words;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    for (int i = 0; i < N; i++) {
        node *head = table[i];
        node *cursor = head;
        node *temp = head;
        while (cursor != NULL) {
            cursor = cursor->next;
            free(temp);
            temp = cursor;
        }
    }
    return true;
}
