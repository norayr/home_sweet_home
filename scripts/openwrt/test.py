import sys

# Check if a command-line argument is provided
if len(sys.argv) < 2:
    print("Usage: python your_script.py <hex_data>")
    sys.exit(1)

# Get the hex_data from the command-line argument
hex_data = sys.argv[1]

# Convert the hexadecimal data to bytes
bytes_data = bytes.fromhex(hex_data)

# Decode the UCS-2 bytes to a Unicode string
decoded_text = bytes_data.decode('utf-16')

print(decoded_text)

