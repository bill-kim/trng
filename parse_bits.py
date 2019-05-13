def hex_to_bin(hex_str):
    bin_str = bin(int(hex_str, 16))[2:]

    if (len(bin_str) % 4 != 0):
        bin_str = "0" * (4 - len(bin_str) % 4) + bin_str

    return bin_str

with open('rng_results.txt', 'r') as f:
    proceed = False
    for line in f:
        if proceed:
            pair = line.strip().split(",")
            filename = (pair[0] + ".txt")
            hex_str = pair[1]
            print(filename)
            with open(filename, 'w') as g:
                g.write(hex_to_bin(hex_str))
        proceed = True