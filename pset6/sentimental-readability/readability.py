def calcaulte_letters(s):
    return len(list(filter(isalpha, s)))


def calculate_words(s):
    return s.count(' ') + 1


def calculate_sentences(s):
    return (s.count('.')) + s.count('!') + s.count('?')


def isalpha(s):
    # !WARNING for use in filter() only
    return s.isalpha()


def main():
    s = input('Text: ').strip()

    letters = calcaulte_letters(s)
    words = calculate_words(s)
    sentences = calculate_sentences(s)

    L = letters / words * 100
    S = sentences / words * 100
    
    index = 0.0588 * L - 0.296 * S - 15.8
    
    if index > 16:
        print('Grade 16+')
        return

    if index < 1:
        print('Before Grade 1')
        return

    print(f'Grade {round(index)}')


if __name__ == '__main__':
    main()
