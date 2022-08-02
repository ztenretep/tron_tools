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

# Declare the global variable $FAC.
our $FAC;

# =====================================================================
# Function get_response()
#
# Description:
# The subroutine is using the method GET to retrieve the response from
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
    # Get the response from the service url or die.
    my $content = get($uri);
    die "Can't GET response from $uri" if (! defined $content);
    # Return the content from the response.
    return $content; 
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

# =============================
# Function get_date_time_str()
#
# Description:
# Divide given integer by 1000.
#
# @arg    $number -> INTEGER
# @return $dt     -> INTEGER
# =============================
sub get_dt_num{
    # Assign the argument to the local variable.
    my $number = $_[0];
    #my $fac = $_[1]; 
    my $dt = int($number / $FAC);
    # Return date and time number.
    return $dt;
};

# =======================================================
# Function date_time()
#
# Description:
# Create the date and time string from the given integer.
#
# @arg    $dt        -> INTEGER  
# @return $date_time -> STRING
# =======================================================
sub date_time(){
    # Assign the argument to the local variable.
    my $dt = $_[0];
    # Create the date and time string.
    my $date_time = strftime "%Y-%m-%d %H:%M:%S", localtime($dt);
    # Return the date and time string.
    return $date_time;
}

##########################
# Main script subroutine #
##########################
sub main(){
    # Assign the argument to the local variable.
    my $service_url = $_[0]; 
    # Initialise the variable $FAC in the local content.
    local $FAC = 1000;
    # Get content from url.
    my $content = &get_response($service_url);
    # Decode and encode content.
    my ($json_encode, $json_decode) = &dec_enc($content);
    # Extract number from json data.
    my $num = $json_decode->{'num'};
    # Get date and time number.
    #my $dt = &get_dt_num($num);
    my $dt = &get_dt_num($num);
    # Get date and time string.
    my $now_string = &date_time($dt);
    # Print the raw json data to the terminal window.
    print "Raw JSON data:", "\n", $json_encode;
    # Print date and time string to the terminal window.
    print "Next maintenance time: ", $now_string, "\n";
}

# +++++++++++++++++++++++++++++++++++
# Call the main script routine run().
# +++++++++++++++++++++++++++++++++++
&main($service_url);
