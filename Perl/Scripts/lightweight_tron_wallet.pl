#!/usr/bin/perl -w
#
# TRON (TRX) Wallet
# Version 0.0.0.1
#
# Installation:
#   This failed:
#   Using cpan -> install Inline::Python 
#   This worked:  
#   sudo apt-get install libinline-python-perl
#
# Exchange <public_key> and <private_key> with your data.
#
# References:
# https://github.com/niner/inline-python-pm
# https://metacpan.org/dist/Inline-Python/view/Python.pod

# Load the base Perl pragmatic modules (pragmas) as compiler directive.
use strict;
use warnings;
use diagnostics;

# Load the Perl modules.
use Try::Catch;
use Bitcoin::Crypto::Base58 qw(
        encode_base58
        decode_base58
        encode_base58check
        decode_base58check
);
use open ":std", ":encoding(UTF-8)";

# Use the Inline Python module.
use Inline (Python => 'DATA',
            CLEAN_BUILD_AREA => 0,
            CLEAN_AFTER_BUILD => 0,
            PRINT_INFO => 0,
            WARNINGS => 0,
            REPORTBUG => 0);

# Use curses.
use Curses;

#-------------------#
# Initialise window # 
#-------------------#
initscr();
cbreak();

# Set global variables.
our($MAXX, $MAXY, $SPC0, $SPC1, $BALANCE, $TITLE, $FN_RESPONSE,
    $FN_ERROR, $PUBLIC_KEY, $PRIVATE_KEY, $DESTINATION, $AMOUNT);

# Set public key.
$PUBLIC_KEY = '<public_key>';

# Set private key.
$PRIVATE_KEY = '<private_key>';

# Try to create a new Trx object.
my $tron = undef; 
try {
    # Create a new Trx object.
    $tron = new Trx($PUBLIC_KEY, $PRIVATE_KEY);
} catch {
     # Print error message to screen.
     print "Could not create a new tron object. Maybe there is a problem with the public key or the private key.\n";
     # Exit script with error code 1. 
     exit 1;
};

# Initialise destination and amount.
$DESTINATION = undef;
$AMOUNT = undef;

# Set the filenames.
$FN_RESPONSE = 'trans_result.txt';
$FN_ERROR = 'trans_error.txt';

# Set the header string.
$TITLE = 'Lightweight Text Based Wallet for TRON (TRX) Transactions';

# Declare the windows variables.
$MAXX = undef;
$MAXY = undef;
$SPC0 = undef;
$SPC1 = undef;

#-------------#
# Trap SIGINT #
#-------------#
$SIG{INT} = sub {
    # Reset the Terminal window.
    system("reset");
    # Print message to terminal window.
    print "You pressed Ctrl-C. Exiting. Bye!\n";
    # Exit script without error.
    exit 0;
};

#--------------#
# Clear screen #
#--------------#
sub clear_screen {
    # Clear screen. 
     print "\33[H\33[3J";
}

#--------------#
# Reset screen #
#--------------#
sub reset_screen {
    # Reset screen. 
    print "\33c";
}

#----------------------------#
# Subroutine chk_base58_addr #
#----------------------------#
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
            # Initialise the variable $hex_addr.
            my $hex_addr = undef;
            # Convert the base58 address to the hex address.
            $hex_addr = decode_base58check($base58_addr);
            $hex_addr = unpack("H*", $hex_addr);
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

#-------------------# 
# Subroutine is_int #
#-------------------# 
sub is_int {
   # Assign subroutine argument to local variable.
   my $input = $_[0];
   # Set output variable.
   my $is_int = undef;
   # Set regex pattern using digits match.
   my $pattern = "^(([1-9]?\\d+)|0)\$";
   my $re = qr/$pattern/;
   # Check input with regex pattern.
   if ($input =~ $re) {
       $is_int = 1;
   } else {
       $is_int = 0;
   };
   # Return 0 (false) or 1 (true).
   return $is_int; 
};

#---------------------# 
# Subroutine is_float #
#---------------------# 
sub is_float {
   # Assign subroutine argument to local variable.
   my $input = $_[0];
   # Set output variable.
   my $is_float = undef;
   # Set regex pattern using digits match.
   my $pattern = "^(([0-9]|([1-9]\\d+))\\.?\\d+)\$";
   my $re = qr/$pattern/;
   # Check input with regex pattern.
   if ($input =~ $re) {
       $is_float = 1;
   } else {
       $is_float = 0;
   };
   # Return 0 (false) or 1 (true).
   return $is_float; 
};

#---------------#
# Print to file #
#---------------#
sub write_file {
    # Assign subroutine arguments to local variables.
    my $string = $_[0];
    my $filename = $_[1];
    # Open file.
    open(FH, '>', $filename);
    # Write response to file.
    print FH $string;
    # Close file.
    close(FH);
};

#---------------------#
# Wait on key pressed #
#---------------------#
sub key_pressed {
    # Print message to screen.
    my $enter_key = "Press key 'q' to quit or press ENTER to proceed";
    addstr($MAXY-6, 1, "$SPC1");
    addstr($MAXY-6, 3, "$enter_key");
    # Get key.
    my $key = getch();
    # Check if key equal q|Q.
    if (($key eq 'q') || ($key eq 'Q')) {
         # Restore echo. 
         echo();
         # Stop curses.
         endwin();
         # Clear screen. 
         print "\33[H\33[3J";
         # Print message.
         print "Have a nice day. Bye!\n";
         # Exit script with error code 1. 
         exit 1;
    }; 
};

#------------------#
# Print main frame #
#------------------#
sub print_main_frame {
    # Set chars array.
    my @chrs = ("\x{2503}", "\x{2501}", "\x{250F}", "\x{2513}",
                "\x{2523}", "\x{252B}", "\x{2517}", "\x{251B}");
    # Print left and right lines.
    for (my $i = 1; $i < $MAXY; $i++) {
        addstr($i, 0, "$chrs[0]");
        addstr($i, $MAXX, "$chrs[0]");
    };
    # Print top, middle and bottom lines.
    for (my $i = 1; $i < $MAXX; $i++) {
        addstr(0, $i, "$chrs[1]");
        addstr(4, $i, "$chrs[1]");
        addstr($MAXY, $i, "$chrs[1]");
    };
    # Print corners and junctions.
    addstr(0, 0, "$chrs[2]");
    addstr(0, $MAXX, "$chrs[3]");
    addstr(4, 0, "$chrs[4]");
    addstr(4, $MAXX, "$chrs[5]");
    addstr($MAXY, 0, "$chrs[6]");
    addstr($MAXY, $MAXX, "$chrs[7]");
};

#-------------------#
# Print inner lines #
#-------------------#
sub print_inner_lines {
    # Set chars array.
    my @chrs = ("\x{2500}", "\x{2520}", "\x{2528}");
    # Print horizontal lines.
    for (my $i = 1; $i < $MAXX; $i++) {
        addstr(9, $i,"$chrs[0]");
        addstr($MAXY-4, $i, "$chrs[0]");
    };
    # Print junctions. 
    addstr($MAXY-4, 0, "$chrs[1]");
    addstr($MAXY-4, $MAXX, "$chrs[2]");
    addstr(9, 0, "$chrs[1]");
    addstr(9, $MAXX, "$chrs[2]");
};

#--------------------#
# Print text overlay #
#--------------------#
sub print_text_overlay() {
    # Declare variable.
    my $msg = undef;
    # Print text strings.
    addstr(2, 3, "$TITLE");
    $msg = "\x{2524} Entry Mask \x{251C}";
    addstr(9, 3, $msg);
    $msg = "\x{2524} Status Bar \x{251C}";
    addstr($MAXY-4, 3, $msg);
    $msg = "Press CTRL-C to exit the user interface";
    addstr($MAXY-6, $MAXX-2-length("$msg"), "$msg");
};

#-------------#
# Print data0 #
#-------------#
sub print_data0 {
    # Print public key and private key to screen.
    addstr(6, 3, "Private Key: $PRIVATE_KEY");
    addstr(7, 3, "Public Key:  $PUBLIC_KEY");
};

#-------------#
# Print data1 #
#-------------#
sub print_data1 {
    # Print account balance to screen.
    my $str0 = "Available Free Balance:";
    my $len0 = length($str0);
    my $str1 = "$BALANCE TRX";
    my $len1 = length($str1);
    my $spc = "\x20" x ($len0 - $len1); 
    addstr(6, $MAXX-25, "$str0");
    addstr(7, $MAXX-25, "$str1");
};

#------------#
# Entry mask #
#------------#
sub entry_mask {
    # Set strings.
    my $str0 = "Destination Address:";
    my $str1 = "Transfer Amount:";
    my $str2 = "Input destination address (or nothing) followed by ENTER";
    my $str3 = "Input transfer amount (or nothing) followed by ENTER";
    # Add the entry fields.
    addstr(11, 1, "$SPC0");
    addstr(11, 3, "$str0");
    addstr(13, 1, "$SPC0");
    addstr(13, 3, "$str1");
    # Add message.
    addstr($MAXY-6, 1, "$SPC1");
    addstr($MAXY-6, 3, "$str2");
    # Move cursor.
    move(11, 24);
    # Get string.
    $DESTINATION = getstring();
    # Add message.
    addstr($MAXY-6, 1, "$SPC1");
    addstr($MAXY-6, 3, "$str3");
    # Move cursor.
    move(13, 20);
    $AMOUNT = getstring();
};

#--------------------# 
# Windows dimensions #
#--------------------# 
sub win_dim {
    my $MAXX = getmaxx;
    my $MAXY = getmaxy;
    $MAXX -= 2;
    $MAXY -= 1;
    return ($MAXY, $MAXX);
}

#-------------# 
# Empty lines #
#-------------# 
sub spc_lines {
    # Define empty lines.
    $SPC0 = "\x20" x ($MAXX-1);
    $SPC1 = "\x20" x 58;
    # Return empty lines.
    return ($SPC0, $SPC1);
} 

#-----------------------------------------# 
# Curses TRON (TRX) wallet user interface #
#-----------------------------------------#
sub user_interface {
    # Get the inner dimensions of the terminal window.
    ($MAXY, $MAXX) = win_dim();
    print $MAXX;
    print $MAXY;
    # Get needed empty lines.
    ($SPC0, $SPC1) = spc_lines();
    # Run an infinite loop.
    while (1) {
        # Print frame.
        print_main_frame(); 
        # Print frame.
        print_inner_lines(); 
        # Print text overlay.
        print_text_overlay(); 
        # print data.
        print_data0();
        # print data.
        print_data1();
        # Add enty mask.
        entry_mask();
        # Wait on key pressed.
        key_pressed();
        # Check address.
        if (chk_base58_addr($DESTINATION)) {
            # Check amount.
            if (is_float($AMOUNT) || is_int($AMOUNT)) {
                # Set Tron class attributes.
                addstr($MAXY-2, 1, "$SPC0");
                addstr($MAXY-2, 3, "Transaction in progress ...");
                # Refresh screen.
                refresh();
                # Disable echo. 
                noecho();
                # Check if amount is of type float.
                $tron->set_destination($DESTINATION);
                $tron->set_amount($AMOUNT);  
                # Get response from transaction. 
                my $retcode = $tron->transaction();
                my $response = $tron->get_restxt();
                my $errormsg = $tron->get_errmsg();
                # Write message to status line.
                addstr($MAXY-2, 3, "$SPC0");
                if ($retcode eq 1) {
                    write_file($response, $FN_RESPONSE);
                    addstr($MAXY-2, 3, "Transaction Successful");
                    my $string = "Response written to $FN_RESPONSE";
                    addstr($MAXY-2, $MAXX-2-length("$string"), "$string");
                } else {
                    write_file($errormsg, $FN_ERROR);
                    addstr($MAXY-2, 3, "Transaction Failed");
                    my $string = "Error written to $FN_ERROR";
                    addstr($MAXY-2, $MAXX-2-length("$string"), "$string");
                };
            } else {
                addstr($MAXY-2, 1, "$SPC0");
                addstr($MAXY-2, 3, "Amount is not a integer nor a floating point number");
            };
        } else {
            addstr($MAXY-2, 1, "$SPC0");
            addstr($MAXY-2, 3, "Destination address is not valid");
        };
        # Restore echo. 
        echo();
        # Refresh screen.
        refresh();
        # Get the inner dimensions of the terminal window.
        ($MAXY, $MAXX) = win_dim();
        # Get empty lines.
        ($SPC0, $SPC1) = spc_lines();
        # Get account balance.
        $BALANCE = $tron->balance();
    };
};

# /-------------------------------------/
# / The main script section starts here / 
# /-------------------------------------/

# Try to get the account balance.
$BALANCE = $tron->balance();

# Reset the terminal window.
reset_screen();

# Run the curses user interface.
user_interface();

# /------------------/
# / Terminate window /
# /------------------/
endwin();

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
    def __init__(self, publicKey, privateKey):
        # Create a new tron object.
        self.tron = Tron()
        # Assign the private key to self.tron here.
        self.tron.private_key = privateKey.decode('utf-8')
        # Assign the public key to self.tron here.
        self.tron.default_address = publicKey.decode('utf-8')
        # Define the destination address.
        self.destination = None
        # Define the TRON (TRX) amount.
        self.amount = None
        # Set balance.
        self.balance_trx = 0
        # Set the error message. 
        self.errmsg = 'NO ERROR'
        # Set the response text.
        self.restxt = ''

    # Setter method.
    def set_destination(self, destination):
        # Set destination address.
        self.destination = destination.decode('utf-8')

    # Setter method.
    def set_amount(self, amount):
        # Set amount.
        self.amount = float(amount.decode('utf-8'))
 
    # Getter method.
    def get_errmsg(self):
        # Return the error message. 
        return self.errmsg 

    # Getter method.
    def get_restxt(self):
        # Return the response text.
        return self.restxt 
    
    # Get balance
    def balance(self):
        # Get balance.
        balance_sun = self.tron.trx.get_balance()
        self.balance_trx = self.tron.fromSun(balance_sun)
        # Return balance.
        return self.balance_trx

    # Claim rewards method.
    def transaction(self):
        # Set the return code to None.
        retcode = None
        # Try to claim rewards.
        try:
            # Build a new transaction.
            transaction_tx = self.tron.trx.send_transaction(self.destination, self.amount)
            # Get the result of transaction.
            transaction_json = json.dumps(transaction_tx, indent=2)
            # Set the response text.
            self.restxt = transaction_json
            # Set the return code to 1.   
            retcode = 1
        except Exception as error:
            # Set the error message.
            self.errmsg = str(error)
            # Set the return code to 0.   
            retcode = 0
        # Return the return code.
        return retcode

__END__
