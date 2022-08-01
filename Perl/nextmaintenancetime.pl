#!/usr/bin/perl
#
# Get next manintenancetime from the FULL NODE HTTP API.
#
# Reference:
# https://developers.tron.network/reference/getnextmaintenancetime

# Load the base Perl pragmatic modules (pragmas) as compiler directive.
use strict;
use warnings;

# Load the required Perl modules or packages.
use URI;
use LWP::Simple;
use JSON::PP;
use POSIX;

# Set the TRON service url.
my $api_url = 'https://api.trongrid.io';
my $api_path = '/wallet/getnextmaintenancetime';

# Assemble the service url.
my $service_url = "$api_url.$api_path";

# ============================
# Function type_var()
# use Scalar::Type qw(:all);
# call: print &type_var($var);
# ============================
sub type_var(){
    # Load required Perl module.
    use Scalar::Type qw(:all);
    # Assign arguement to variable. 
    my $var = $_[0];
    # Get type of variable.
    my $chk_var = type($var) . "\n";
    # Return type of variable.
    return $chk_var;
}

# ======================================
# Function get_response()
#
# @arg    $service_url -> SCALAR(string)
# @return $content     -> SCALAR(string)
# ======================================
sub get_response(){
    # Read argument from function call.
    my $service_url = $_[0]; 
    # Create the servive url.
    my $url = URI->new($service_url);
    # Get the response from the service.
    my $content = get($url);
    die "Can't GET response from $url" if (! defined $content);
    # Return content from response.
    return $content; 
};

# ====================================================================
# Function dec_enc()
#
# @arg     $content                     -> SCALAR(string)                    
# @returns ($json_encode, $json_decode) -> SCALAR(string), REF_TO_HASH
# ====================================================================
sub dec_enc(){
    # Read argument from function call.
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

# ============================
# Function get_date_time_str()
#
# @arg    $number -> INTEGER
# @return $dt     -> INTEGER
# ============================
sub get_dt_num{
    # Read argument from function call.
    my $number = $_[0]; 
    my $dt = int($number / 1000);
    # Return date and time number.
    return $dt;
};

# ====================================
# Function date_time()
#
# @arg    $dt        -> INTEGER  
# @return $date_time -> SCALAR(string)
# ====================================
sub date_time(){
    # Get the argument from the function call.
    my $dt = $_[0]; 
    # Create the date and time string.
    my $date_time = strftime "%Y-%m-%d %H:%M:%S", localtime($dt);
    # Return the date and time string.
    return $date_time;
}

# ================
# Subroutine run()
# ================
sub run(){
    # Get the argument from the function call.
    my $service_url = $_[0]; 
    # Get content from url.
    my $content = &get_response($service_url);
    # Decode and encode content.
    my ($json_encode, $json_decode) = &dec_enc($content);
    # Extract number from json data.
    my $num = $json_decode->{'num'};
    # Get date and time number.
    my $dt = &get_dt_num($num);
    # Get date and time string.
    my $now_string = &date_time($dt);
    # Print result to terminal window.
    print "Raw JSON data:", "\n", $json_encode;
    # Print date and time string.
    print "Next maintenance time: ", $now_string, "\n";
}

#########################
# Call subroutine run() #
#########################
&run($service_url);
