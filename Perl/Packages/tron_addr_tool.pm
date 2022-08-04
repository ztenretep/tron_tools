package tron_addr_tool;
# ##############################################################################
# How to load the user defined package from within a Perl script:
# use lib '<path_to_package>';
# use tron_addr_tool;
# ##############################################################################

# Load the Perl pragma Exporter.
use Exporter;

# Base class of this (tron_addr) module.
@ISA = qw(Exporter);

# Exporting the implemented subroutines.
@EXPORT = qw(to_hex_addr to_base58_addr);

# Load the Perl pragmas.
use strict;
use warnings;

# Load the required Perl modules.
use Bitcoin::Crypto::Base58 qw(
        encode_base58
        decode_base58
        encode_base58check
        decode_base58check
);

# ======================
# Subroutine to_hex_addr
# ======================
sub to_hex_addr {
    # Assign the function argument to the local variable.
    my $base58_addr = $_[0];
    # Initialise the variable $hex_addr.
    my $hex_addr = undef;
    # Convert the base58 address to the hex address.
    $hex_addr = decode_base58check($base58_addr);
    $hex_addr = unpack("H*", $hex_addr);    
    $hex_addr = uc($hex_addr);
    # Return the hex address.
    return $hex_addr;
};

# =========================
# Subroutine to_base58_addr
# =========================
sub to_base58_addr {
    # Assign the function argument to the local variable.
    my $hex_addr = $_[0];
    # Initialise the variable $base58_addr.
    my $base58_addr = undef;
    # Convert the hex address to the base58 address.
    $base58_addr = pack("H*", $hex_addr);
    $base58_addr = encode_base58check($base58_addr);
    # Return the base58 address.
    return $base58_addr;
};

1;
