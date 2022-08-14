
#!/usr/bin/perl -w
#
# The script reads the transactions related to transfers from the list of
# the last 20 transactions. The API only allows the maximum possible query
# of the last 20 transactions. 
#
# 1  -> TransferContract      (Transfer TRX)
# 2  -> TransferAssetContract (Transdfer ASSET)
# 4  -> VoteWitnessContract   (Vote TRX)
# 11 -> FreezeBalanceContract   (Freeze TRX)
# 12 -> UnfreezeBalanceContract (Unfreeze TRX)
# 13 -> WithdrawBalanceContract (Claim TRX Rewards) 
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
our($ADDRESS, $PAYLOAD, $HEADER, $API_URL, $JSON_PP);

# Set the TRON account address.
$ADDRESS = '<tron_address>';

# Set the number of transactions.
my $LIMIT = 20;

# Initialise the contract type.
my $ContractType = undef;

# Set the array with the allowed numbers.
my @NUMARR = (0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13,
              14, 15, 16, 17, 18, 19, 20, 30, 31, 32, 33,
              41, 42, 43, 44, 45, 46, 48, 49, 51, 52, 53);

# AccountCreateContract           = 0;
# TransferContract                = 1;
# TransferAssetContract           = 2;
# VoteAssetContract               = 3;
# VoteWitnessContract             = 4;
# WitnessCreateContract           = 5;
# AssetIssueContract              = 6;
# WitnessUpdateContract           = 8;
# ParticipateAssetIssueContract   = 9;
# AccountUpdateContract           = 10;
# FreezeBalanceContract           = 11;
# UnfreezeBalanceContract         = 12;
# WithdrawBalanceContract         = 13;
# UnfreezeAssetContract           = 14;
# UpdateAssetContract             = 15;
# ProposalCreateContract          = 16;
# ProposalApproveContract         = 17;
# ProposalDeleteContract          = 18;
# SetAccountIdContract            = 19;
# CustomContract                  = 20;
# CreateSmartContract             = 30;
# TriggerSmartContract            = 31;
# GetContract                     = 32;
# UpdateSettingContract           = 33;
# ExchangeCreateContract          = 41;
# ExchangeInjectContract          = 42;
# ExchangeWithdrawContract        = 43;
# ExchangeTransactionContract     = 44;
# UpdateEnergyLimitContract       = 45;
# AccountPermissionUpdateContract = 46;
# ClearABIContract                = 48;
# UpdateBrokerageContract         = 49;
# ShieldedTransferContract        = 51;
# MarketSellAssetContract         = 52;
# MarketCancelOrderContract       = 53;

# =================
# Subroutine prnmsg
# =================
sub help {
    # Print allowed options into the terminal window. 
    print "Please provide exactly one number (contract type) as command line argument:\n";
    print "\x20\x201  -> TransferContract      (Transfer TRX)\n";
    print "\x20\x202  -> TransferContract      (Transfer ASSET)\n";
    print "\x20\x204  -> VoteWitnessContract   (Vote TRX)\n";
    print "\x20\x2011 -> FreezeBalanceContract   (Freeze TRX)\n"; 
    print "\x20\x2012 -> UnfreezeBalanceContract (Unfreeze TRX)\n";
    print "\x20\x2013 -> WithdrawBalanceContract (Claim TRX Rewards)\n";
    print "\x20\x20etc.\n";
    print "Exiting program!\n";
    # Exit script with error code 1.
    exit 1;
};

# Read the command line argument.
if ($#ARGV != 0 ) {
    # Print the help message.
    help();
} elsif ($ARGV[0] eq '--help') {
    # Print the help message.
    help();
} else {
    # Get a number from the command line argument.
    ($ContractType) = @ARGV;
    if ((grep {$_ eq $ContractType} @NUMARR) ne 1) {
        # Print the help message.
        help();
    };
};

# Set the API URL.
my $BASE_URL = "https://apilist.tronscan.org";
my $PATH_URL = "/api/transaction";
my $PARAMS = "?sort=-timestamp&count=true&limit=" . "$LIMIT" . "&start=0&address=" . "$ADDRESS";

# Assemble the API URL. 
$API_URL = $BASE_URL . $PATH_URL . $PARAMS;

# Set up the options for the Perl module.
$JSON_PP = 'JSON::PP'->new->pretty;

# ***********
# Trap SIGINT
# ***********
$SIG{INT} = sub {
    # Print message to terminal window.
    print "You pressed Ctrl-C. Exiting. Bye!\n";
    # Exit script without error.
    exit 0;
};

# ===============
# Function decode
# ===============
sub decode {
    # Assign the argument to the local variable.
    my $content = $_[0];
    # Decode the content of the response.
    my $decoded = $JSON_PP->decode($content);
    # Return decoded.
    return $decoded;
};

# ===============
# Function encode
# ===============
sub encode {
    # Assign the argument to the local variable.
    my $decoded = $_[0];
    # Set the keywords. 
    my $key0 = 'data'; 
    my $key1= 'contractType'; 
    # Get the data from the content.
    my $data = $decoded->{$key0};
    # Loop over the array of hashes.
    for my $hash (@$data) {
        # Get the contract type.
        my $contract_type = $hash->{$key1};
        # Check the contract type.
        if ($contract_type eq $ContractType) {
            # Print result to screen.      
            print $JSON_PP->encode($hash);
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
        # Get the error code and the error message.
        my $code = $response->code;
        my $message =  $response->message;
        # Print the error code and message into the terminal window.
        print "HTTP error code: ", "$code", "\n";
        print "HTTP error message: ", "$message", "\n";
        # Exit script.
        exit 1;
    };
    # Return the content.
    return $content;
};

# ###############
# Main subroutine
# ###############
sub main {
    # Get the content.
    my $content = response();
    # Decode the content.
    my $decoded = decode($content);
    # Encode the decoded content.
    encode($decoded);
};

# ++++++++++++++++++++++++
# Call the subroutine main
# ++++++++++++++++++++++++
main();
