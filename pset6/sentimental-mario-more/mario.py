while True:
    try:
        height = int(input('Height: '))
        if height < 1 or height > 8:
            raise ValueError
        break
    except ValueError:
        print('Invalid height')

for i in range(height):
    print(' ' * (height - i - 1) + '#' * (i + 1) + '  ' + '#' * (i + 1))

