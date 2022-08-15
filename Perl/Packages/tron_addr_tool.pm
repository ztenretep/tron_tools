package tron_addr_tool;
# ##############################################################################
# How to load the user defined package from within a Perl script:
# use lib '<path_to_lib>';
# use tron_addr_tool;
# ##############################################################################

# Load the Perl pragma Exporter.
use Exporter;

# Base class of this (tron_addr) module.
@ISA = qw(Exporter);

# Exporting the implemented subroutines.
@EXPORT = qw(to_hex_addr to_base58_addr 
             chk_base58_addr chk_hex_addr);

# Load the Perl pragmas.
use strict;
use warnings;

# Load the required Perl modules.
use Try::Catch;
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

# ==========================
# Subroutine chk_base58_addr
# ==========================
sub chk_base58_addr {
    # Assign the function argument to the local variable.
    my $base58_addr = $_[0];
    # Initialise the variable $is_base58_addr to 1 (true). 
    my $is_base58_addr = 1;
    # Get the first char of the base58 address.
    my $chr_addr = substr($base58_addr, 0, 1);
    # Get the length of the base58 address.
    my $len_addr = length($base58_addr);
    # Check if the first char is T and the length of the address is 34.
    if (("$chr_addr" eq "T") and ($len_addr == 34)) {
        # Try to convert the address from base58 to hex.
        try {
            to_hex_addr($base58_addr); 
        } catch {
            # Set variable to 0 (false).
            $is_base58_addr = 0;
        };
    } else {
        # Set variable to 0 (false).
        $is_base58_addr = 0;
    };
    # Return true or false on result of check.
    return $is_base58_addr;
};

# =======================
# Subroutine chk_hex_addr
# =======================
sub chk_hex_addr {
    # Assign the function argument to the local variable.
    my $hex_addr = $_[0];
    # Initialise the variable $is_hex_addr to 1 (true). 
    my $is_hex_addr = 1;
    # Get the first two chars of the hex address.
    my $chrs_addr = substr($hex_addr, 0, 2);
    # Get the length of the hex address.
    my $len_addr = length($hex_addr);
    # Check if the first chars are 41 and the length of the address is 42.
    if (("$chrs_addr" eq "41") and ($len_addr == 42)) {
        # Try to convert the address from hex to base58.
        try {
            to_base58_addr($hex_addr); 
        } catch {
            # Set variable to 0 (false).
            $is_hex_addr = 0;
        };
    } else {
        # Set variable to 0 (false).
        $is_hex_addr = 0;
    };
    # Return true or false on result of check.
    return $is_hex_addr;
};

1;
