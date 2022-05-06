
#!/usr/bin/python3
"""Check Private key generation of Bip39 and Bip44 against tronapi methods.

I used tronapi's approach to cross-check my calculation method. With the addition of
the possibility to use mnemonics fro the seed generation, this became necessary.
"""
# pylint: disable=invalid-name
# pylint: disable=line-too-long

# Import the standard Python module.
import os
from binascii import unhexlify

# Import the third party Python module.
import base58
from bip_utils import Bip39WordsNum, Bip39MnemonicGenerator, Bip39SeedGenerator
from bip_utils import Bip44Coins, Bip44
from eth_keys import KeyAPI
from tronapi import Tron

# Set the format string.
fmt_str = "{0:21s}{1}"

# Create an instance of Tron()
tron = Tron()

# Clear screen.
os.system("clear")

# Print message to screen.
print("*** Create a new 12 word mnemonic using Bip39 and Bip44\n")

# Generate a random mnemonic string of 12 words with default language (English)
mnemonic = Bip39MnemonicGenerator().FromWordsNumber(Bip39WordsNum.WORDS_NUM_12)

# Print the mnemonic to screen.
print(fmt_str.format("Mnemonic:", mnemonic))

# Print message to screen.
print("\n*** Create private key, public key and Tron address using Bip39 and Bip44\n")

# Generate with automatic language detection and passphrase (empty)
seed_bytes = Bip39SeedGenerator(mnemonic).Generate()

# Create Bip44 Tron object.
bip44_tron = Bip44.FromSeed(seed_bytes, Bip44Coins.TRON)

# Create a private key in hex and upper case.
private_key = bip44_tron.PrivateKey().Raw().ToHex().upper()

# Create a public key in upper case.
public_key = str(bip44_tron.PublicKey().RawUncompressed()).upper()

# Create Base58 address.
base58_addr = bip44_tron.PublicKey().ToAddress()

# Create a Hex address in hex and upper case.
hex_addr = base58.b58decode_check(base58_addr).hex().upper()

# Print result to screen.
print(fmt_str.format("Private Key:", private_key))
print(fmt_str.format("Address (Base58):", base58_addr))
print(fmt_str.format("Address (Hex): ", hex_addr))
print(fmt_str.format("Public Key: ", public_key))

# Print message to screen.
print("\n*** Recreate private key, create public key and Tron address like tronapi it does\n")

# Create a byte string.
private = unhexlify(bytes(private_key, encoding='utf8'))

# Create a hex string.
key = KeyAPI.PrivateKey(private)

# Create a bytes string.
raw_key = key.to_bytes()

# Create the private key.
# tronapi:
# import codecs
# private_key = codecs.decode(codecs.encode(_raw_key, 'hex'), 'ascii')
private_key = raw_key.hex().upper()

# Create the public key.
public_key = key.public_key
public_key_base58 = ('04' + str(public_key)[2:]).upper()
public_key_hex = ('41' + public_key.to_address()[2:]).upper()

# Create a Base58 address.
base58_addr = base58.b58encode_check(bytes.fromhex(public_key_hex)).decode("utf-8")

# Print result to screen.
print(fmt_str.format("Private Key:", private_key))
print(fmt_str.format("Address (Base58):", base58_addr))
print(fmt_str.format("Address (Hex): ", public_key_hex))
print(fmt_str.format("Public Key:", public_key_base58))

# Get address from tronapi.
# print(tron.address.from_private_key(private_key))

# Print farewell message.
print("\nHave a nice day. Bye!")
