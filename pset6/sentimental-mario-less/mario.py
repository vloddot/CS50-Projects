from multiprocessing.sharedctypes import Value


def get_input():
    while True:
        height = 0
        try:
            height = int(input('Height: '))
            
            if height >= 1 and height <= 8:
                break
            
        except ValueError:
            print("That is not a number")
            
    return height
    
def draw_pyramid(height):
    for i in range(height):
        print(' ' * (height - (i + 1)), end='')
        print('#' * (i + 1))
    
def main():
    height = get_input()
    draw_pyramid(height)
    
    
if __name__ == '__main__':
    main()