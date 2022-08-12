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
our($ADDRESS, $PAYLOAD, $HEADER, $SERVICE_URL);

# Set the TRON account address.
$ADDRESS = '<tron_address>';

# Set the number of transactions.
my $LIMIT = 20;

# Set the params.
my $PARAM_LIMIT = $LIMIT;
my $PARAM_ADDRESS = $ADDRESS;

# Set the API URL.
$SERVICE_URL = "https://apilist.tronscan.org/api/transaction?sort=-timestamp&count=true&limit=" . "$PARAM_LIMIT" . "&start=0&address=" . "$PARAM_ADDRESS";

# ************
# Trap SIGINT.
# ************
$SIG{INT} = sub {
    # Print message to terminal window.
    print "You pressed Ctrl-C. Exiting. Bye!" . "\n";
    # Exit script.
    exit 42;
};

# ===============
# Function encode
# ===============
sub encode {
    # Assign the argument to the local variable.
    my $content = $_[0];
    # Set up the options for the Perl module.
    my $json = 'JSON::PP'->new->pretty;
    # Decode the content of the response.
    my $json_decode = $json->decode($content);
    # Get the data from the content.
    my $data = $json_decode->{'data'};
    # Loop over the array of hashes.
    for my $ele (@$data) {
        # Get contract type.
        my $contract_type = $ele->{'contractType'};
        # Check the contract type.
        if ($contract_type eq 4) {
            # Print result to screen.      
            print $json->encode($ele);
        };
    };
};

# =====================
# Function get_response
# =====================
sub get_response {
    # Declare the variable.
    my $content = undef;
    # Create a new uri object.
    my $uri = URI->new($SERVICE_URL);
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
    my $content = get_response();
    # Encode the content.
    my $json_encode = encode($content);
};

# +++++++++++++++++++++++++++++++
# Call the script subroutine main
# +++++++++++++++++++++++++++++++
main();
