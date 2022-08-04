#!/usr/bin/perl

# Load the required Perl pragmas.
use strict;
use warnings;

# Load the required Perl modules.
use Term::ANSIColor;

# Load user the defined package.
use lib '<path_to_lib>';
use tron_addr_tool;

# Print installation path.
#print "\@INC is @INC\n";

# Define the global variables.
our($BASE58_ADDR, $HEX_ADDR);

# Set the address.
$BASE58_ADDR = 'TLrj4MzaitvA2jRH7a8G4f8JtqhTsTg4sy';
$HEX_ADDR = '41776F8FEAD2E1E8C256A85957B37A91BD90AB5EFE';

# +++++++++++++++++++++++
# Define the BEGIN block.
# +++++++++++++++++++++++
BEGIN {
    # Clear the screen.
    system('clear');
    # Print test to screen.
    print colored('################################################################################', 'white on_blue'), "\n";
    print colored('Script for testing the conversion from hex addr to base58 addr and vice versa   ', 'white on_blue'), "\n";
    print colored('################################################################################', 'white on_blue'), "\n\n"; 
    # Print a colored message into the terminal window.
    print colored('Cancel the script with CTRL+C.', 'white on_yellow'), "\n\n";
};

# +++++++++++++++++++++
# Define the END block.
# +++++++++++++++++++++
END {
    # Print a into the terminal window.
    print "\nHave a nice day. Bye!\n";
};

# +++++++++++++++++++++
# Trap CTRL+C (SIGINT).
# +++++++++++++++++++++
$SIG{INT} = sub {
    # Print a message into the terminal window.
    print "You pressed Ctrl-C. Exiting. Bye!\n";
    # Exit the script with error code 42.
    exit 42;
};

##########################
# Main script subroutine #
##########################
sub main {
    # Set the format string.
    my $fmtstr = "%-27s%s\n";
    # Base58 to hex conversion.
    my $hex_addr = &to_hex_addr($BASE58_ADDR);
    printf($fmtstr, "Given hex address:", $HEX_ADDR);
    printf($fmtstr, "Calculated hex address:", $hex_addr);
    if ("$HEX_ADDR" eq "$hex_addr") {
        print colored('Conversion OK.', 'white on_green'), "\n";
    } else {
        print colored('Conversion ERROR.', 'white on_red'), "\n";
    };
    # Hex to Base58 conversion.
    my $base58_addr = &to_base58_addr($HEX_ADDR);
    printf($fmtstr, "Given base58 address:", $BASE58_ADDR);
    printf($fmtstr, "Calculated base58 address:", $base58_addr);
    if ("$BASE58_ADDR" eq "$base58_addr") {
        print colored('Conversion OK.', 'white on_green'), "\n";
    } else {
        print colored('Conversion ERROR.', 'white on_red'), "\n";
    };
};

# ++++++++++++++++++++++++++++++++++++++
# Call the main script subroutine run().
# ++++++++++++++++++++++++++++++++++++++
&main();
