#!/usr/bin/perl

# Load the standard Perl pragmas.
use strict;
use warnings;

# Load the user defined package.
use lib '/home/deathlok/TRON/Perl/Packages';
use tron_account_data;

# Load the required Perl modules.
use Term::ANSIColor;

# Set the TRON account address.
my $TRON_ADDRESS = '<tron_address>';

# ++++++++++++++++++++++
# Define the BEGIN block
# ++++++++++++++++++++++
BEGIN {
    # Clear the screen.
    system('clear');
    # Print test to screen.
    print colored('##############################################', 'white on_blue'), "\n";
    print colored('#             TRON Account DATA              #', 'white on_blue'), "\n";
    print colored('##############################################', 'white on_blue'), "\n\n"; 
    # Print a colored message into the terminal window.
    print colored('The script execution can be canceld by CTRL+C.', 'white on_yellow'), "\n\n";
};

# ++++++++++++++++++++
# Define the END block
# ++++++++++++++++++++
END {
    # Print a message into the terminal window.
    print "\nHave a nice day. Bye!\n";
};

# +++++++++++++++++++++
# Trap CTRL+C (SIGINT).
# +++++++++++++++++++++
$SIG{INT} = sub {
    # Print a message into the terminal window.
    print "You pressed Ctrl-C. Exiting script. Bye!\n";
    # Exit the script without error code.
    exit 0;
};

# ===============================
# Subroutine printaccountresource
# ===============================
sub print_accountresource {
    # Declare the array.
    my $array; 
    # Set the format strings.
    my $fmtstr = "%-11s%s / %s\n";
    # Get account resource.
    my %request = ('address' => $TRON_ADDRESS, 'service' => 'getaccountresource');
    my $tron = tron_account_data->new(%request);
    my @array = $tron->get_service_response->decode->parse_accountresource();
    my ($TotalBandwidth, $FreeBandwidth, $TotalEnergy, $FreeEnergy) = @array;
    # Print result into terminal window.
    printf($fmtstr, "Bandwidth:", "$FreeBandwidth", "$TotalBandwidth"); 
    printf($fmtstr, "Energy:", "$FreeEnergy", "$TotalEnergy"); 
};

# ======================
# Subroutine printreward
# ======================
sub print_reward {
    # Declare the array.
    my $array; 
    # Set the format string.
    my $fmtstr = "%-19s%s TRX\n";
    # Set the request data.
    my %request = ('address' => $TRON_ADDRESS,
                   'service' => 'getreward');
    # Create a new object.
    my $tron = tron_account_data->new(%request);
    my $reward = $tron->get_service_response->decode->parse_reward();
    # Print result into terminal window.
    printf($fmtstr, "Available Rewards:", "$reward"); 
};

# ===============================
# Subroutine printmaintenancetime
# ===============================
sub print_maintenancetime {
    # Declare the array.
    my $array; 
    # Set the format string.
    my $fmtstr = "%-23s%s\n";
    # Get the data from the request.
    my %request = ('address' => $TRON_ADDRESS, 'service' => 'getnextmaintenancetime');
    # Create a new object.
    my $tron = tron_account_data->new(%request);
    my $result = $tron->get_service_response->decode->parse_nextmaintenancetime();
    # Print the data into the terminal window.
    printf($fmtstr, "Next Maintenance Time:", "$result"); 
};

# ============================
# Subroutine print_accountdate
# ============================
sub print_accountdates {
    # Declare the array.
    my $array; 
    # Set the format strings.
    my $fmtstr1 = "%-23s%s\n";
    my $fmtstr2 = "%-32s%s\n";
    # Get the data from the response.
    my %request = ('address' => $TRON_ADDRESS, 'service' => 'getaccount');
    my $tron = tron_account_data->new(%request);
    my @data = $tron->get_service_response->decode->parse_account_dates();
    my ($create_time, $latest_consume_free_time, $latest_consume_time,
        $latest_withdraw_time, $next_withdraw_time, $latest_opration_time,
        $latest_consume_time_for_energy) = @data;
    printf($fmtstr1, "Creation Time:", "$create_time"); 
    printf($fmtstr1, "Latest Operation Time:", "$latest_opration_time"); 
    print "\n";
    printf($fmtstr1, "Latest Withdraw Time:", "$latest_withdraw_time"); 
    printf($fmtstr1, "Next Withdraw Time:", "$next_withdraw_time"); 
    print "\n";
    printf($fmtstr2, "Latest Consume Time for Energy:", "$latest_consume_time_for_energy"); 
    printf($fmtstr2, "Latest Consume Free Time:", "$latest_consume_free_time"); 
    printf($fmtstr2, "Latest Consume Time:", "$latest_consume_time"); 
};

# ===============================
# Subroutine print_account_frozen
# ===============================
sub print_accountfrozen {
    # Declare the array.
    my $array; 
    # Set the format strings.
    my $fmtstr0 = "%-15s%s TRX\n";
    my $fmtstr1 = "%-26s%s TRX\n";
    my $fmtstr2 = "%-26s%s\n";
    # Get the data from the response.
    my %request = ('address' => $TRON_ADDRESS, 'service' => 'getaccount');
    my $tron = tron_account_data->new(%request);
    my @data = $tron->get_service_response->decode->parse_account_frozen();
    my ($frozen_expire, $energy_expire, $free, $frozen, $energy, $total, $total_frozen) = @data;
    # Print the data into the terminal window.
    printf($fmtstr0, "Total Balance:", "$total"); 
    printf($fmtstr0, "Free Balance:", "$free"); 
    print "\n";
    printf($fmtstr1, "Frozen for Bandwidth:", "$frozen"); 
    printf($fmtstr2, "Expiration Date and Time:", "$frozen_expire"); 
    printf($fmtstr1, "Frozen for Energy:", "$energy"); 
    printf($fmtstr2, "Expiration Date and Time:", "$energy_expire"); 
    printf($fmtstr1, "Total Frozen Balance:", "$total_frozen"); 
};

# =============================
# Subroutine print_accountvotes
# =============================
sub print_accountvotes {
    # Declare the array.
    my $array; 
    # Set the format strings.
    my $fmtstr = "%-13s%s\n\n";
    # Get the data from the response.
    my %request = ('address' => $TRON_ADDRESS, 'service' => 'getaccount');
    my $tron = tron_account_data->new(%request);
    my @data = $tron->get_service_response->decode->parse_account_votes();
    my ($total_votes, $sr_hash) = @data;
    # Print the data into the terminal window.
    printf($fmtstr, "Total votes:", "$total_votes");
    while (my ($key, $value) = each %$sr_hash) {
        print "$key $value\n";
    };
};

##########################
# Main script subroutine #
##########################
sub main {
    # Print account frozen.
    print_accountfrozen();
    print "\n";
    # Print reward.
    print_reward();
    print "\n";
    # Print maintenancetime.
    print_maintenancetime();
    print "\n";
    # Print account resource.
    print_accountresource();
    print "\n";
    # Print account votes.
    print_accountvotes();
    print "\n";
    # Print account overview.
    print_accountdates();
};

# +++++++++++++++++++++++++++++++++++++++
# Call the main script subroutine main().
# +++++++++++++++++++++++++++++++++++++++
&main();
