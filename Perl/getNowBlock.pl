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
# https://developers.tron.network/reference/wallet-getnowblock

# Load the base Perl pragmatic modules (pragmas) as compiler directive.
use strict;
use warnings;

# Load the required Perl modules or packages.
use URI;
use JSON::PP;
use POSIX;
use LWP::UserAgent;

# Set the TRON service url.
my $api_url = 'https://api.trongrid.io';
my $api_path = '/walletsolidity/getnowblock';

# Assemble the service url.
my $service_url = "$api_url.$api_path";

# ============
# Trap SIGINT.
# ============
$SIG{INT} = sub {
    # Print message to terminal window.
    print "You pressed Ctrl-C. Exiting. Bye!" . "\n";
    # Exit script.
    exit 42;
};

# =====================================================================
# Function get_response()
#
# Description:
# The subroutine is using the method POST to retrieve the response from
# the given service url. The service url is given as string and then
# the service url converted to a HTTP URI object. The content is given
# back as string.
#
# @arg    $service_url -> STRING
# @return $content     -> STRING
# =====================================================================
sub get_response(){
    # Assign the argument to the local variable.
    my $service_url = $_[0];
    # Create the uri object from the service url.
    my $uri = URI->new($service_url);
    # Create a new useragent object.
    my $ua = LWP::UserAgent->new;
    # Set the header.
    my $header = [Accept => 'application/json',
                  Content_Type => 'application/json'];
    # Get the response from the uri.
    my $response = $ua->post($uri, $header);
    # Get the response content.
    my $response_content = $response->decoded_content;
    # Get the response header.
    my $response_header = $response->headers->as_string();
    # Get the content.
    my $content = $response->content;
    # Return the content.
    return ($content, $response_header, $response_content);
};

# ==========================================================
# Function dec_enc()
#
# Description:
# The subroutine is decoding and encoding the given content.
# Both are given back as array.
#
# @arg     $content                     -> STRING                    
# @returns ($json_encode, $json_decode) -> STRING, HASHREF
# ==========================================================
sub dec_enc(){
    # Assign the argument to the local variable.
    my $content = $_[0];
    # Set up the options for the Perl module.
    my $json = 'JSON::PP'->new->pretty;
    # Decode response content.
    my $json_decode = $json->decode($content);
    # Encode response content.
    my $json_encode = $json->encode($json_decode);
    # Return encoded and decoded data.
    return ($json_encode, $json_decode);
}

##########################
# Main script subroutine #
##########################
sub main(){
    # Assign the argument to the local variable.
    my $service_url = $_[0]; 
    # Get the content from the service url.
    #my $content = &get_response($service_url);
    my ($content, $response_header, $response_content) = &get_response($service_url);
    # Decode and encode content.
    my ($json_encode, $json_decode) = &dec_enc($content);
    # Print the raw json data to the terminal window.
    print "Response content:", "\n", $response_content, "\n";
    print "Response Header:", "\n", $response_header, "\n";
    print "Raw JSON data:", "\n", $json_encode;
}

# +++++++++++++++++++++++++++++++++++
# Call the main script routine run().
# +++++++++++++++++++++++++++++++++++
&main($service_url);
