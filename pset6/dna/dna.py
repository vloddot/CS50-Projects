import csv
import sys


def main():

    # Check for command-line usage
    if len(sys.argv) != 3:

        # Print error message to user
        print("Usage: python3 database sequence")

        # Exit with error code 1
        sys.exit(1)

    # A people list that will contain dictionaries
    people = []

    # Read database file into a variable

    # Open database file
    with open(sys.argv[1]) as file:

        # Declare a dict reader and set it to reader variable
        reader = csv.DictReader(file)

        # For each row in the reader
        for row in reader:

            # Append the row to the people list of dictionaries
            people.append(row)

        # Set STRs to be the names of STRs in fieldnames[1:end of list]
        STRs = reader.fieldnames[1:]
        
        print(people)

    # Declare a DNA string
    dna = ""

    # Read DNA sequence file into a variable

    # Open DNA sequence file
    with open(sys.argv[2]) as file:

        # Put the contents of the DNA sequence file into the DNA string variable
        dna = file.read()

    # Declare a dictionary called longest_strs to store the STRs of the DNA sequence
    longest_strs = {}

    # Find longest match of each STR in DNA sequence

    # For each dictionary in the people list
    for dict in people:

        # For each STR in the STRs list
        for STR in STRs:

            # Check for the longest match of the current DNA subsequence in the DNA sequence (i.e., 'AGATC') and put it in the longest_strs dictionary
            longest_strs[STR] = longest_match(dna, STR)

    # Check database for matching profiles

    # Declare a count variable and set it equal to 0
    count = 0

    # For each dictionary in the people list
    for dict in people:

        # For each STR in the STRs list
        for STR in STRs:

            # If the current longest STR count equals the current dict's STR count
            if longest_strs[STR] == int(dict[STR]):

                # Increment count by 1
                count += 1

            # If all the STRs match
            if count == len(STRs):

                # Print the current person
                print(dict['name'])

                # Exit with 0 (successful)
                sys.exit(0)

        # Reset count to 0
        count = 0

    # Print "No match" if no one matched the STR counts
    print("No match")


def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):

        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        # If a match, move substring to next potential match in sequence
        # Continue moving substring and checking for matches until out of consecutive matches
        while True:

            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in seqeuence, return longest run found
    return longest_run


if __name__ == '__main__':
    main()
