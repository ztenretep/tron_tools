#!/usr/bin/perl
#
# Get total balance from get account from the FULL NODE HTTP API.
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
use Term::ANSIColor;

# Define the global variables.
our($ADDRESS, $PAYLOAD, $SERVICE_URL, $SUN,
    $KEY1, $KEY2, $KEY3, $KEY4, $KEY5, $KEY6); 

# Set the account address.
$ADDRESS = "<address>";

# Assemble the payload. Double quotes needed. This variable is global.
$PAYLOAD = "\{\"address\":\"$ADDRESS\",\"visible\":\"True\"\}";

# Set the TRON service url.
my $API_URL = 'https://api.trongrid.io';
my $API_PATH = '/walletsolidity/getaccount';

# Assemble the service url.
$SERVICE_URL = $API_URL.$API_PATH;

# Set variable $SUN.
$SUN = 1000000;

# Set the key words.
$KEY1 = 'balance';
$KEY2 = 'frozen';
$KEY3 = 'frozen_balance';
$KEY4 = 'account_resource';
$KEY5 = 'frozen_balance_for_energy';

# Define the BEGIN block.
BEGIN {
    # Print a colored message into the terminal window.
    print colored('Cancel the script with CTRL+C.', 'black on_yellow'), "\n";
}

# Define the END block.
END {
    # Print a into the terminal window.
    print "Have a nice day. Bye!" . "\n";
}

# ***********
# Trap SIGINT
# ***********
$SIG{INT} = sub {
    # Print a message to the terminal window.
    print "You pressed Ctrl-C. Exiting. Bye!" . "\n";
    # Exit the script with an error code.
    exit 42;
};

##########################
# Main script subroutine #
##########################
sub main(){
    # Create the uri object from the service url.
    my $uri = URI->new($SERVICE_URL);
    # Create a new user agent object.
    my $ua = LWP::UserAgent->new;
    $ua->default_header('Accept' => 'application/json');
    $ua->default_header('Content_Type' => 'application/json');
    # Get the response from the uri using the HTTP POST method.
    my $response = $ua->post($uri, Content => $PAYLOAD);
    # Get the content from the response.
    my $content = $response->content;
    # Get the decoded content.
    my $json_decode = 'JSON::PP'->new->pretty->decode($content);
    # Extract the needed data from the decoded json data.
    my $free = $json_decode->{$KEY1};
    my $frozen = $json_decode->{$KEY2}[0]{$KEY3};
    my $energy = $json_decode->{$KEY4}{$KEY5}{$KEY3};
    # Calculate the total TRON balance.
    my $total = ($free + $frozen + $energy) / $SUN;
    # Print the total TRON balance to the screen.
    print $total . "\x20TRX" . "\n"; 
}

# +++++++++++++++++++++++++++++++++
# Call the script subroutine main()
# +++++++++++++++++++++++++++++++++
&main();
