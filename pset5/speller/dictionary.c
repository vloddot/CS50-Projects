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

// Declare a total words variable to use in the size() function which is incremented for every word in the dictionary in load()
int total_words = 0;

// Choose number of buckets in hash table
const unsigned int N = (LENGTH + 1) * 'z';

// Hash table
node *table[N];

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    // Hash the word and put it in the index variable
    int index = hash(word);

    node *cursor = table[index];

    // Loop through the linked list using the cursor
    while (cursor != NULL)
    {
        // Compare words case insensitively
        if (strcasecmp(cursor->word, word) == 0)
        {
            // Return true
            return true;
        }

        // Move onto the next node
        cursor = cursor->next;

    }

    // Return false
    return false;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // Declare a sum variable
    int sum = 0;

    // For each character in the word
    for (int i = 0; i < strlen(word); i++)
    {
        // Add the ASCII value of the character to the sum
        sum += (tolower(word[i]));
    }

    // Return sum % N (% N is for if the sum is bigger than N and so it goes back up and loops over again to the start)
    return (sum % N);
}

// Return true if loading the dictionary was succesful, else return false
bool load(const char *dictionary)
{
    // Open file
    FILE *file = fopen(dictionary, "r");

    // If there is no memory
    if (file == NULL)
    {
        // Return false
        return false;
    }

    // Create a buffer for the word
    char word[LENGTH + 1];

    // While we're scanning the file until it returns EOF (End of file)
    while (fscanf(file, "%s", word) != EOF)
    {

        // Allocate memory for a new node
        node *n = malloc(sizeof(node));

        // If there is no memory
        if (n == NULL)
        {
            // Return false
            return false;
        }

        // Copy the current word into the allocated node's word
        strcpy(n->word, word);

        // Set the next node in the linked list to be NULL because we currently don't know it
        n->next = NULL;

        // Hash the word to get its index
        int index = hash(word);

        // If the table's index is NULL meaning it hasn't been created before
        if (table[index] == NULL)
        {
            // Set the value at the table's index to be the current word
            table[index] = n;
        }

        // Else (there is a node there already)
        else
        {
            // Set the next node in the new node to be the first item in the table's hash index
            n->next = table[index];

            // Set the next value in the table's hash to be the new node
            table[index] = n;
        }

        // Increment j by 1 to use in the size() function
        total_words++;
    }

    // Close the dictionary file
    fclose(file);

    // Return true
    return true;
}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{
    // Return the total words variable which was incremented by 1 for each word in the dictionary in load()
    return total_words;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
    // For each bucket in the table
    for (int i = 0; i < N; i++)
    {
        // Assign a new node called head to be the current table bucket at index i
        node *head = table[i];

        // Assign another new node to be head
        node *cursor = head;

        // Assign another new node to be head
        node *temp = head;

        // While the linked list still has items
        while (cursor != NULL)
        {
            // Move onto the next item in the cursor linked list
            cursor = cursor->next;

            // Free the temp item
            free(temp);

            // Move onto the next item in the temp linked list
            temp = cursor;
        }
    }

    // Return true
    return true;
}
