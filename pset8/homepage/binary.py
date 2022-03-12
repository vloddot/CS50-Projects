num = 0
def check_binary(binary):
    for i in range(len(binary)):
        if binary[i] == '1' or binary[i] == '0' or binary[i] == '+' or binary[i] == '/' or binary[i] == '*' or binary[i] == '-':
            continue
        print("These aren't binary digits")
        raise ValueError

def read_binary(binary):
    multiples = []
    for i in range(len(binary)):
        multiples.append(2 ** ((len(binary) - i) - 1))

    return multiples

def write_binary(multiples, num):
    for i in range(len(binary)):
        if binary[i] == '1':
            num += multiples[i]
    print(num)

print("Binary: ", end="")
binary = input().strip()
check_binary(binary)
multiples = read_binary(binary)
write_binary(multiples, num)