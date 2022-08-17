#!/usr/bin/perl -w
#
# Installation:
#   This failed:
#   Using cpan -> install Inline::Python 
#   This worked:  
#   sudo apt-get install libinline-python-perl
#
# References:
# https://github.com/niner/inline-python-pm
# https://metacpan.org/dist/Inline-Python/view/Python.pod

# Load the base Perl pragmatic modules (pragmas) as compiler directive.
use strict;
use warnings;
use diagnostics;

# Use the Inline Python module.
use Inline (Python => 'DATA',
            CLEAN_BUILD_AREA => 1,
            CLEAN_AFTER_BUILD => 1,
            PRINT_INFO => 0,
            WARNINGS => 0,
            REPORTBUG => 0);

# Create a new Trx object.
my $tron = new Trx;

# Set public key.
my $public_key = '<public_key>';
$tron->set_public_key($public_key);

# Set private key.
my $private_key = '<private_key>';
$tron->set_private_key($private_key);

# Print result of operation. 
my $response = $tron->claim_rewards();
print $response . "\n";

__DATA__
# Perl data section.
__Python__
# Python script section.

# Import the standard Python module.
import json

# Import the third party Python module.
from tronapi import Tron

# Define the Trx class.
class Trx():
    """Trx class."""
    def __init__(self):
        # Set public and private key to None.
        self.public_key = None
        self.private_key = None
        # Create a new Tron() object.
        self.tron = Tron()

    # Setter method.
    def set_public_key(self, public_key):
        self.public_key = public_key.decode()

    # Setter method.
    def set_private_key(self, private_key):
        self.private_key = private_key.decode()

    # Getter method.
    def get_public_key(self):
        # Return public key.
        return self.public_key

    # Getter method.
    def get_private_key(self):
        # Return private key.
        return self.private_key 

    # Claim rewards method.
    def claim_rewards(self):
        # Assign private key to self.tron here.
        self.tron.private_key = self.private_key
        # Assign public key to self.tron here.
        self.tron.default_address = self.public_key
        # Initialise withdraw.         
        withdraw = None
        # Try to claim rewards.
        try:
            # Claim rewards.
            withdraw_tx = self.tron.transaction_builder.withdraw_block_rewards()
            withdraw_sb = self.tron.trx.sign_and_broadcast(withdraw_tx)
            withdraw = json.dumps(withdraw_sb, indent=2)
        except Exception as err:
            # Set withdraw with the error string.
            withdraw = str(err)   
        # Return withdraw.
        return withdraw

__END__
