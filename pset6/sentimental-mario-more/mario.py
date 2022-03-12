def get_input():
    # While the inputted height is less than or equals 1 or bigger than or equals 110, prompt user for height
    while True:
        try:
            height = int(input('Height: '))
            if height >= 1 and height <= 110:
                return height
            else:
                print('Invalid Height')
        except ValueError:
            print('Invalid Height')
            continue

def draw_pyramid(height):
    # Simple for loop to print out the hashes and spaces
    for i in range(height):

        # Print spaces
        print(' ' * (height - i - 1), end='')

        # Print hashes on the first pyramid for each i
        print('#' * (i + 1), end='')

        # Print two spaces for small distance between pyramids
        print('  ', end='')

        # Print hashes on the second pyramid for each i
        print('#' * (i + 1))

def main():
    height = get_input()
    draw_pyramid(height)

if __name__ == '__main__':
    main()