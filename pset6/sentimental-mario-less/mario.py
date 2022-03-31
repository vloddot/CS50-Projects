def get_input():
    while True:
        height = 0
        try:
            height = int(input('Height: '))
            
            if height >= 1 and height <= 8:
                break
            
            print("Invalid height")
        except ValueError:
            print("Invalid height")
            
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