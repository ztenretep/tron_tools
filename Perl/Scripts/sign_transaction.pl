#!/usr/bin/perl -w
#
# Installation:
#     This failed:
#         Using cpan -> install Inline::Python 
#     This worked:  
#         sudo apt-get install libinline-python-perl
#
# References:
# https://metacpan.org/dist/Inline-Python/view/Python.pod
# https://github.com/niner/inline-python-pm

# Load the base Perl pragmatic modules (pragmas) as compiler directive.
use strict;
use warnings;
use diagnostics;

# Use Inline Python module to define a function.
use Inline Python => <<'END_OF_PYTHON_CODE';

# Import the Python modules.
import sys
from eth_account import Account

# Define the Python function sign().
def sign(txID, privKey):
    txID = txID.decode()
    privKey = privKey.decode()
    sign_tx = Account.signHash(txID, privKey)
    sign_eth = sign_tx['signature']
    sign_hex = sign_eth.hex()[2:]
    return sign_hex

END_OF_PYTHON_CODE

# Set the transaction ID.
my $txID = '<transaction-hash>';

# Set the private key.
my $privKey = '<private-key>'

# Print signature into terminal window.
print sign($txID, $privKey) . "\n"; 
