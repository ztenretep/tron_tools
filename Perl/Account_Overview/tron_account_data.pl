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
my $TRON_ADDRESS = '<your_tron_address>';

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
sub printaccountresource {
    # Declare the array.
    my $array; 
    # Set the format strings.
    my $fmtstr = "%-11s%s / %s\n";
    # Get account resource.
    my $tron = tron_account_data->new('address' => $TRON_ADDRESS, 'service' => 'getaccountresource');
    my $content = $tron->getserviceresponse();
    my $decoded = $tron->decode($content);
    my @array = $tron->parseaccountresource($decoded);
    my ($TotalBandwidth, $FreeBandwidth, $TotalEnergy, $FreeEnergy) = @array;
    # Print result into terminal window.
    printf($fmtstr, "Bandwidth:", "$FreeBandwidth", "$TotalBandwidth"); 
    printf($fmtstr, "Energy:", "$FreeEnergy", "$TotalEnergy"); 
};

# ======================
# Subroutine printreward
# ======================
sub printreward {
    # Declare the array.
    my $array; 
    # Set the format string.
    my $fmtstr = "%-19s%s TRX\n";
    # Get reward.
    my $tron = tron_account_data->new('address' => $TRON_ADDRESS, 'service' => 'getreward');
    my $content = $tron->getserviceresponse();
    my $decoded = $tron->decode($content);
    my $reward = $tron->parsereward($decoded);
    # Print result into terminal window.
    printf($fmtstr, "Available Rewards:", "$reward"); 
};

# ===============================
# Subroutine printmaintenancetime
# ===============================
sub printmaintenancetime {
    # Declare the array.
    my $array; 
    # Set the format strings.
    my $fmtstr = "%-23s%s\n";
    # Get the data from the request.
    my $tron = tron_account_data->new('address' => $TRON_ADDRESS, 'service' => 'getnextmaintenancetime');
    my $content = $tron->getserviceresponse();
    my $decoded = $tron->decode($content);
    my $maintenance = $tron->parsenextmaintenancetime($decoded);
    # Print the data into the terminal window.
    printf($fmtstr, "Next Maintenance Time:", "$maintenance"); 
};

# =======================
# Subroutine printbalance
# =======================
sub printaccountbalance {
    # Declare the array.
    my $array; 
    # Set the format strings.
    my $fmtstr0 = "%-15s%s TRX\n";
    my $fmtstr1 = "%-26s%s TRX\n";
    my $fmtstr2 = "%-26s%s\n";
    my $fmtstr3 = "%-13s%s\n\n";
    my $fmtstr4 = "%-23s%s\n";
    my $fmtstr5 = "%-32s%s\n";
    # Get the data from the response.
    my $tron = tron_account_data->new('address' => $TRON_ADDRESS, 'service' => 'getaccount');
    my $content = $tron->getserviceresponse();
    my $decoded = $tron->decode($content);
    my $maintenance = $tron->parseaccountbalance($decoded);
    my ($total_votes, $sr_hash, $frozen_expire, $energy_expire, $free, $frozen, $energy, $total, $total_frozen,
        $create_time, $latest_consume_free_time, $latest_consume_time,
        $latest_withdraw_time, $latest_opration_time, $latest_consume_time_for_energy) = $tron->parseaccountbalance($decoded);
    # Print result into terminal window.
    printf($fmtstr0, "Total Balance:", "$total"); 
    printf($fmtstr0, "Free Balance:", "$free"); 
    print "\n";
    printf($fmtstr1, "Frozen for Bandwidth:", "$frozen"); 
    printf($fmtstr2, "Expiration Date and Time:", "$frozen_expire"); 
    printf($fmtstr1, "Frozen for Energy:", "$energy"); 
    printf($fmtstr2, "Expiration Date and Time:", "$energy_expire"); 
    printf($fmtstr1, "Total Frozen Balance:", "$total_frozen"); 
    print "\n";
    printf($fmtstr3, "Total votes:", "$total_votes");
    while (my ($key, $value) = each %$sr_hash) {
	print "$key $value\n";
    }
    print "\n";
    printf($fmtstr4, "Creation Time:", "$create_time"); 
    printf($fmtstr4, "Latest Operation Time:", "$latest_opration_time"); 
    printf($fmtstr4, "Latest Withdraw Time:", "$latest_withdraw_time"); 
    print "\n";
    printf($fmtstr5, "Latest Consume Time for Energy:", "$latest_consume_time_for_energy"); 
    printf($fmtstr5, "Latest Consume Free Time:", "$latest_consume_free_time"); 
    printf($fmtstr5, "Latest Consume Time:", "$latest_consume_time"); 
};

##########################
# Main script subroutine #
##########################
sub main {
    # Print account resource.
    printaccountbalance();
    print "\n";
    # Print account resource.
    printaccountresource();
    print "\n";
    # Print reward.
    printreward();
    print "\n";
    # Print account resource.
    printmaintenancetime();
};

# +++++++++++++++++++++++++++++++++++++++
# Call the main script subroutine main().
# +++++++++++++++++++++++++++++++++++++++
&main();
