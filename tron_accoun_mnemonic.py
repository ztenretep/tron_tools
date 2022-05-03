#!/usr/bin/python3
"""Create Tron address from mnemonics.
"""
# pylint: disable=invalid-name

# Import the third party Python module.
from bip_utils import Bip39WordsNum, Bip39MnemonicGenerator, Bip39SeedGenerator
from bip_utils import Bip44Coins, Bip44

# Generate a random mnemonic string of 12 words with default language (English).
mnemonic = Bip39MnemonicGenerator().FromWordsNumber(Bip39WordsNum.WORDS_NUM_12)
print(mnemonic)

# Generate seed bytes with automatic language detection and passphrase (empty).
seed_bytes = Bip39SeedGenerator(mnemonic).Generate()

# Create bip44 object.
bip44_mst_ctx = Bip44.FromSeed(seed_bytes, Bip44Coins.TRON)

# Create private key.
b64_hex = bip44_mst_ctx.PrivateKey().Raw().ToHex()
print(b64_hex)

# Create Tron address.
addr = bip44_mst_ctx.PublicKey().ToAddress()
print(addr)
