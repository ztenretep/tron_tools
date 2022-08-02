#!/usr/bin/perl
#
# Get now block from the FULL NODE HTTP API.
#
# Service URL:
# The difference between /walletsolidity/ and /wallet/ is, that
# a transaction queried by /wallet/* indicates that it has been
# on the blockchain but it is not necessarily confirmed. 
#
# Reference:
# https://developers.tron.network/reference/account-getaccount

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

# Set api url and api path.
my $API_URL = 'https://api.trongrid.io';
my $API_PATH = '/walletsolidity/getaccount';

# Set the account address.
$ADDRESS = "<address>";

# Assemble the payload from the address.
$PAYLOAD = "\{\"address\":\"$ADDRESS\",\"visible\":\"True\"\}";

# Set the request header.
$HEADER = [Accept => 'application/json',
           Content_Type => 'application/json'];

# Assemble the service url.
$SERVICE_URL = $API_URL.$API_PATH;

# ************
# Trap SIGINT.
# ************
$SIG{INT} = sub {
    # Print message to terminal window.
    print "You pressed Ctrl-C. Exiting. Bye!" . "\n";
    # Exit script.
    exit 42;
};

# ==========================================================
# Function encode()
#
# Description:
# The subroutine is decoding and encoding the given content.
#
# @arg     $content     -> STRING                    
# @returns $json_encode -> STRING
# ==========================================================
sub encode(){
    # Assign the argument to the local variable.
    my $content = $_[0];
    # Set up the options for the Perl module.
    my $json = 'JSON::PP'->new->pretty;
    # Decode the content of the response.
    my $json_decode = $json->decode($content);
    # Encode the decoded content of the response.
    my $json_encode = $json->encode($json_decode);
    # Return encoded and decoded data.
    return $json_encode;
}

# ===================================================================
# Function get_response()
#
# Description:
# The subroutine is using the method POST to retrieve the response
# from the given service url. The service url is given as string and
# then the service url converted to a HTTP URI object. The content is
# given back as string.
#
# @arg    $service_url -> STRING
# @return $content     -> STRING
# ===================================================================
sub get_response(){
    # Declare the variable.
    my $content = undef;
    # Create a new uri object.
    my $uri = URI->new($SERVICE_URL);
    # Create a new user agent object.
    my $ua = LWP::UserAgent->new;
    # Get the response from the uri.
    my $response = $ua->post($uri, $HEADER, Content => $PAYLOAD);
    # Check success of operation.
    if ($response->is_success) {
        # Get the content from the response.
        $content = $response->content;
    } else {
        # Print the error code and message to the terminal window.
        print "HTTP error code: ", $response->code, "\n";
        print "HTTP error message: ", $response->message, "\n";
        # Exit script.
        exit 66;
    }
    # Return the content.
    return $content;
};

##########################
# Main script subroutine #
##########################
sub main(){
    # Get the content from the service url.
    my $content = &get_response();
    # Encode the content.
    my $json_encode = &encode($content);
    # Print the raw json data to the terminal window.
    print $json_encode;
}

# +++++++++++++++++++++++++++++++++++
# Call the main script routine run().
# +++++++++++++++++++++++++++++++++++
&main();
