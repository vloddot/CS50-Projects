#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>


int count_letters(char *s);
int count_words(char *s);
int count_sentences(char *s);

int main(void) {
    char *s = malloc(4096);
    printf("Text: ");
    scanf("%s", s);

    int letters = count_letters(s);
    int words = count_words(s);
    int sentences = count_sentences(s);

    float L = letters / words * 100;
    float S = sentences / words * 100;

    float index = 0.0588 * L - 0.296 * S - 15.8;

    if (index > 16) {
        printf("Grade 16+");
        return 0;
    }

    if (index < 1) {
        printf("Before Grade 1");
        return 0;
    }

    printf("Grade %i", round(index));
}

int count_letters(char *s) {
    int letters = 0;
    for (int i = 0; i < strlen(s); i++) {
        if (isalpha(s[i])) {
            letters++;
        }
    }

    return letters;
}

int count_words(char *s) {
    int words = 0;
    for (int i = 0; i < strlen(s); i++) {
        if (s[i] == ' ') {
            words++;
        }
    }

    return words;
}

int count_sentences(char *s) {
    int sentences = 0;
    for (int i = 0; i < strlen(s); i++) {
        if (s[i] == '.' || s[i] == '!' || s[i] == '?') {
            sentences++;
        }
    }

    return sentences;
}