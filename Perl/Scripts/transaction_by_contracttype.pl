#!/usr/bin/perl -w
#
# The script reads the transactions related to transfers from the list of the
# last 50 transactions. The API itself only allows the maximum possible query
# of the last 50 transactions. 
#
# Change the TRON address <tron_address> in this script to your personal needs.
# The contract type can be chosen via a command line argument. In addition start
# and end date and time can be read from the command line arguments.
# 
# 1  -> TransferContract        (Transfer TRX)
# 2  -> TransferAssetContract   (Transdfer ASSET)
# 4  -> VoteWitnessContract     (Vote TRX)
# 11 -> FreezeBalanceContract   (Freeze TRX)
# 12 -> UnfreezeBalanceContract (Unfreeze TRX)
# 13 -> WithdrawBalanceContract (Claim TRX Rewards) 
#
# Reference: 
# https://github.com/tronscan/tronscan-frontend/blob/master/document/api.md

# Load the base Perl pragmatic modules (pragmas) as compiler directive.
use strict;
use warnings;
use diagnostics;
use constant MILLISECONDS => 1000;

# Load the required Perl modules or packages.
use URI;
use JSON::PP;
use Time::Piece;
use LWP::UserAgent;

# Define the global variables.
our(@NUMARR, $ADDRESS, $LIMIT, $ContractType, $PATTERN, $BASE_URL, $PATH_URL,
    $PARAMS, $API_URL, $JSON_PP, $ALL, $DTS, $START, $END, $START_EPOCH,
    $END_EPOCH);

# Set the TRON account address.
$ADDRESS = '<tron_address>';

# Set the number of transactions.
$LIMIT = 50;

# Initialise the contract type.
$ContractType = undef;

# Set the array with the allowed numbers.
#my @NUMARR = (0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13,
@NUMARR = (0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13,
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

# Initialise the variables.
$ALL = 0;
$DTS = 0;
$START = undef;
$END = undef;
$START_EPOCH = undef;
$END_EPOCH = undef;

# Set the date and time format string.
$PATTERN = "%Y-%m-%d %H:%M:%S";

# Set the API URL.
$BASE_URL = "https://apilist.tronscan.org";
$PATH_URL = "/api/transaction";
$PARAMS = "?sort=-timestamp&count=true&limit=" . "$LIMIT" . "&start=0" . "&address=" . "$ADDRESS";

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
# Subroutine help
# ===============
sub help {
    # Print allowed options into the terminal window. 
    print "Please provide one argument or three arguments as command line arguments.\n\n";
    print "Usage: perl $0 <arg0> <arg1> <arg2>\n\n";
    print "<arg0> -> [--help, --all, <ContractType>]\n\n";
    print "          --help         -> This help text\n";
    print "          --all          -> All contract types\n";
    print "          <ContractType> -> from list\n\n";
    print "<arg1> -> Start date and time in milliseconds since epoch\n";
    print "       -> Format = '%Y-%m-%d %H:%M:%S'\n\n";
    print "<arg2> -> End date and time in milliseconds since epoch\n";
    print "       -> Format = '%Y-%m-%d %H:%M:%S'\n";
    print "\nPossible Contract Types:\n";
    print "\x20\x201  -> TransferContract        (Transfer TRX)\n";
    print "\x20\x202  -> TransferContract        (Transfer ASSET)\n";
    print "\x20\x204  -> VoteWitnessContract     (Vote TRX)\n";
    print "\x20\x2011 -> FreezeBalanceContract   (Freeze TRX)\n"; 
    print "\x20\x2012 -> UnfreezeBalanceContract (Unfreeze TRX)\n";
    print "\x20\x2013 -> WithdrawBalanceContract (Claim TRX Rewards)\n\n";
    print "\x20\x20etc.\n\n";
    print "Exiting program!\n";
    # Exit script with error code 1.
    exit 1;
};

# =================
# Subroutine decode
# =================
sub decode {
    # Assign the argument to the local variable.
    my $content = $_[0];
    # Decode the content of the response.
    my $decoded = $JSON_PP->decode($content);
    # Return decoded.
    return $decoded;
};

# =================
# Subroutine encode
# =================
sub encode {
    # Assign the argument to the local variable.
    my $decoded = $_[0];
    # Set the keywords. 
    my $key0 = 'data'; 
    my $key1= 'contractType'; 
    # Initialise status to 1.
    my $status = 1;
    # Get the data from the content.
    my $data = $decoded->{$key0};
    # Check if data is null.
    if (!exists $decoded->{$key0}) { 
        # Set status to 0.
        $status = 0;
    };
    # Initialise the counter.
    my $count = 0;
    # Loop over the array of hashes.
    for my $hash (@$data) {
        # Get the contract type.
        my $contract_type = $hash->{$key1};
        # Check the contract type.
        if ($ALL eq 1) {
            # Print result to screen.      
            print $JSON_PP->encode($hash);
            # Increment the counter. 
            $count += 1;
        } else {
            if ($contract_type eq $ContractType) {
                # Print result to screen.      
                print $JSON_PP->encode($hash);
                # Increment the counter. 
                $count += 1;
           };
        };
    };
    # Print data sets found into terminal window.
    print "Data sets found: " . "$count" . "\n";
    # Return status.
    return $status;
};

# ===================
# Subroutine response
# ===================
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

# ====================
# Subroutine eval_args
# ====================
sub eval_args {
    # Get the number of arguments.
    my $ARGS = $#ARGV + 1;
    # Evaluate the command line arguments.
    if ($ARGS eq 0) {
        # Print the help message.
        help();
    } elsif ($ARGS ge 1) {
        if ($ARGV[0] eq '--help') {
            # Print the help message.
            help();
        } elsif ($ARGV[0] eq '--all') {
            # Set the variable to 1.
            $ALL = 1;
        } else {
            # Get a number from the command line argument.
            $ContractType = $ARGV[0];
            if ((grep {$_ eq $ContractType} @NUMARR) ne 1) {
                # Print the help message.
                help();
            };
        };
        if ($ARGS eq 3) {
            # Set switch for date and time difference.
            $DTS = 1;
            # Get start and end date and time.
            $START = $ARGV[1];
            $END = $ARGV[2];
        };
    }; 
};

# ###############
# Main subroutine
# ###############
sub main {
    # Evaluate the command line arguments.
    eval_args(@ARGV);
    # Modify the parameter list.
    if ($DTS eq 1) {
        # Get the date and time since epoch.
        $START_EPOCH = ((Time::Piece->strptime($START, $PATTERN))->epoch) * MILLISECONDS;
        $END_EPOCH = ((Time::Piece->strptime($END, $PATTERN))->epoch) * MILLISECONDS;
        # Get the further API parameter.
        $PARAMS = "$PARAMS" . "&start_timestamp=" . "$START_EPOCH" . "&end_timestamp=" . "$END_EPOCH";
    };
    # Assemble the API URL. 
    $API_URL = $BASE_URL . $PATH_URL . $PARAMS;
    # Get the content.
    my $content = response();
    # Decode the content.
    my $decoded = decode($content);
    # Encode the decoded content.
    if (!encode($decoded)) {
        # Print message into the terminal window.
        print $content;
    };
};

# ########################
# Call the main subroutine
# ########################
main();
