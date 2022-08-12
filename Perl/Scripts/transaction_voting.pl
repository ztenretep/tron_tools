#!/usr/bin/perl
#
# The script reads the transactions related to Votes from the list of the
# last 20 transactions. The API only allows the maximum possible query of
# the last 20 transactions. 
#
# 1  -> Transfer TRX
# 4  -> Vote
# 11 -> TRX Staking 
# 13 -> Claim Rewards  
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
$LIMIT = 20;

# Set the API URL.
$API_URL = "https://apilist.tronscan.org/api/transaction?sort=-timestamp&count=true&limit=" . "$LIMIT" . "&start=0&address=" . "$ADDRESS";

# Set the class variable.
$JSON_PP = 'JSON::PP';

# ************
# Trap SIGINT.
# ************
$SIG{INT} = sub {
    # Print message to terminal window.
    print "You pressed Ctrl-C. Exiting. Bye!" . "\n";
    # Exit the script without an error.
    exit 0;
};

# ===============
# Function encode
# ===============
sub encode {
    # Assign the argument to the local variable.
    my $content = $_[0];
    # Set up the options for the Perl module.
    my $json = $JSON_PP->new->pretty;
    # Decode the content of the response.
    my $decoded = $json->decode($content);
    # Get the data from the content.
    my $data = $decoded->{'data'};
    # Loop over the array of hashes.
    for my $hash (@$data) {
        # Get contract type.
        my $contract_type = $hash->{'contractType'};
        # Check the contract type.
        if ($contract_type eq 4) {
            # Print result to screen.      
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
        print "HTTP error code: ", $response->code, "\n";
        print "HTTP error message: ", $response->message, "\n";
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
