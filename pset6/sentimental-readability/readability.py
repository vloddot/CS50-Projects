def calculate_letters(text):
    letter_count = 0
    for i in range(len(text)):
        # If the current character is alphabetical, increment the letter count variable by 1
        if text[i].isalpha():
            letter_count += 1


    return letter_count

def calculate_words(text):
    word_count = 0
    for i in range(len(text)):
        # If the current character is a space, increment the word count variable by 1
        if text[i] == ' ':
            word_count += 1


    # Increment the word count variable by 1 for the last word that may not have a space in the end
    word_count += 1

    return word_count

def calculate_sentences(text):
    sentence_count = 0
    for i in range(len(text)):
        # If the current character is a space, exclamation point, or question mark, increment the sentence count variable by 1
        if text[i] == '.' or text[i] == '!' or text[i] == '?':
            sentence_count += 1


    return sentence_count

def main():
    # Ask the user for input and strip whitespace off of it
    text = input("Text: ").strip()

    # Calculates the number of letters in the text
    letters = calculate_letters(text)

    # Calculates the number of words in the text
    words = calculate_words(text)

    # Calculates the number of sentences in the text
    sentences = calculate_sentences(text)

    # Calculates the average number of letters per 100 words
    L = letters / words * 100

    # Calculates the average number of sentences per 100 words
    S = sentences / words * 100

    # Using the Coleman-Liau index formula, we can calculate the index (i.e., Grade level) for the text
    index = 0.0588 * L - 0.296 * S - 15.8

    # If the index (grade level) is less than 1, output "Before Grade 1"
    if index < 1:
        print("Before Grade 1")
        return

    # If the index (grade level) is bigger than 16, output "Grade 16+"
    if index > 16:
        print("Grade 16+")
        return
    # If both of the if statements did not return, print "Grade {index}"
    print(f"Grade {int(round(index))}")

main()