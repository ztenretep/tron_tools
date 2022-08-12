#!/usr/bin/perl
#
# Reference: 
# https://github.com/tronscan/tronscan-frontend/blob/master/document/api.md

# Load the base Perl pragmatic modules (pragmas) as compiler directive.
use strict;
use warnings;

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

# ************
# Trap SIGINT.
# ************
$SIG{INT} = sub {
    # Print a message into the terminal window.
    print "You pressed Ctrl-C. Exiting. Bye!\n";
    # Exit the script without an error.
    exit 0;
};

# ===============
# Function encode
# ===============
sub encode {
    # Assign the argument to the local variable.
    my $content = $_[0];
    # Set keys.
    my $key0 = 'data';
    my $key1 = 'transferToAddress';
    # Set up the options for the Perl module.
    my $json = $JSON_PP->new->pretty;
    # Decode the content of the response.
    my $decoded = $json->decode($content);
    # Get the data from the content.
    my $data = $decoded->{$key0};
    # Loop over the array of hashes.
    for my $hash (@$data) {
        # Extract to address.
        my $ToAddress = $hash->{$key1};
        # Check on in transfers.  
        if ($ToAddress eq $ADDRESS) { 
            # Print the hash into the terminal window.
            print $json->encode($hash);
        };
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
        # Print the error code and message to the terminal window.
        print "HTTP error code:\x20", $response->code, "\n";
        print "HTTP error message:\x20", $response->message, "\n";
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
    my $encoded = encode($content);
};

# ++++++++++++++++++++
# Call subroutine main
# ++++++++++++++++++++
main();
