#!/usr/bin/perl
#
# Reference: 
# https://github.com/tronscan/tronscan-frontend/blob/master/document/api.md

# Load the base Perl pragmatic modules (pragmas) as compiler directive.
use strict;
use warnings;

# Set constants.
use constant SUN => 100000;

# Load the required Perl modules or packages.
use URI;
use POSIX;
use JSON::PP;
use LWP::UserAgent;

# Define the global variables.
our($ADDRESS, $PAYLOAD, $API_URL, $LIMIT, $JSON_PP);

# Set the TRON account address.
$ADDRESS = '<tron_address>';

# Set the number of transactions.
$LIMIT = 10000;

# Set the API URL.
my $BASE_URL = "https://apilist.tronscan.org";
my $PATH_URL = "/api/transfer";
my $PARAMS = "?sort=-timestamp&count=true&limit=" . "$LIMIT" . "&start=0&token=_&address=" . "$ADDRESS";

# Assemble the API url.
$API_URL = $BASE_URL . $PATH_URL . $PARAMS;

# Set the class variable.
$JSON_PP = 'JSON::PP';

# Define variable $SUN.
#my $SUN = 1000000;

# ************
# Trap SIGINT.
# ************
$SIG{INT} = sub {
    # Print a message into the terminal window.
    print "You pressed Ctrl-C. Exiting. Bye!\n";
    # Exit the script without an error.
    exit 0;
};

# ====================
# Subroutine date_time
# ====================
sub date_time {
    # Assign the argument to the local variable.
    my $dt_ms = $_[0];
    # Set the required devisor.
    my $milliseconds = 1000;
    # Get the date and time number. 
    my $dt_sec = int($dt_ms / $milliseconds);
    # Create the date and time string.
    my $date_time = strftime "%Y-%m-%d %H:%M:%S", localtime($dt_sec);
    # Return the date and time string.
    return $date_time;
};

# ===============
# Function encode
# ===============
sub decode {
    # Assign the argument to the local variable.
    my $content = $_[0];
    # Set up the options for the Perl module.
    my $json = $JSON_PP->new->pretty;
    # Decode the content of the response.
    my $decoded = $json->decode($content);
    # Return decoded;
    return $decoded;
    #};
};

# ==================
# Function transfers
# ==================
sub transfers {
    # Assign the argument to the local variable.
    my $decoded = $_[0];
    # Set the array of keys.
    my @keys = ('data', 'timestamp', 'amount', 'transferToAddress',
                'transferFromAddress', 'confirmed', 'contractRet');
    # Get the data from the content.
    my $data = $decoded->{$keys[0]};
    # Loop over the array of hashes.
    for my $hash (@$data) {
        # Parse the data.
        my $timestamp = $hash->{$keys[1]};
        my $amount = $hash->{$keys[2]};
        my $toAddress = $hash->{$keys[3]};
        my $fromAddress = $hash->{$keys[4]};
        my $confirmed = $hash->{$keys[5]};
        my $contractret = $hash->{$keys[6]};
        # Get the date and time string. 
        $timestamp = date_time($timestamp);
        # Check confirmed.
        ($confirmed eq 1) ? $confirmed = "NOT CONFIRMED" : $confirmed = "CONFIRMED";
        # Calculate the amount.
        $amount = $amount / SUN;
        # Print transfer into terminal window. 
        my $fmtstr = "%-19s\x20FROM:\x20%-34s\x20->\x20TO:\x20%-34s\x20%17.6f\x20TRX\x20->\x20%s\x20%s\n"; 
        printf($fmtstr, $timestamp, $fromAddress, $toAddress, $amount, $contractret, $confirmed); 
    };
};

# =================
# Function response
# =================
sub response {
    # Declare the variable.
    my $content = undef;
    # Create a new uri object.
    my $uri = URI->new($API_URL);
    # Create a new user agent object.
    my $ua = LWP::UserAgent->new;
    # Get the response from the uri.
    my $response = $ua->get($uri);
    # Check success of operation.
    if ($response->is_success) {
        # Get the content from the response.
        $content = $response->content;
    } else {
        # Get error code and message.
        my $code = $response->code;
        my $message = $response->message;
        # Print error code and error message into the terminal window.
        print "HTTP error code:\x20$code\n";
        print "HTTP error message:\x20$message\n";
        # Exit script.
        exit 1;
    };
    # Return the content.
    return $content;
};

##########################
# Main script subroutine #
##########################
sub main {
    # Get the content.
    my $content = response();
    # Encode the content.
    my $decoded = decode($content);
    # Print the transfers into terminal window.
    transfers($decoded);
};

# ++++++++++++++++++++
# Call subroutine main
# ++++++++++++++++++++
main();
