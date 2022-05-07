#!/usr/bin/python3
"""Create Tron address from mnemonics.
"""
# pylint: disable=invalid-name

# Import the third party Python modules.
from bip_utils import Bip39WordsNum, Bip39MnemonicGenerator, Bip39SeedGenerator
from bip_utils import Bip44Coins, Bip44

# Generate a random mnemonic string of 12 words from default language (English).
mnemonic = Bip39MnemonicGenerator().FromWordsNumber(Bip39WordsNum.WORDS_NUM_12)
print(mnemonic)

# Generate seed bytes with automatic language detection and empty passphrase.
seed_bytes = Bip39SeedGenerator(mnemonic).Generate()

# Create bip44 object from seed for Tron.
bip44_mst_ctx = Bip44.FromSeed(seed_bytes, Bip44Coins.TRON)

# Create a private key.
b64_hex = bip44_mst_ctx.PrivateKey().Raw().ToHex()
print(b64_hex)

# Create a Tron address.
addr = bip44_mst_ctx.PublicKey().ToAddress()
print(addr)
