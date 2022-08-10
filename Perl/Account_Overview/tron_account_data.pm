package tron_account_data;
# ########################################################
# Load the user defined package from within a Perl script:
# use lib '<full_path_to_lib>';
# use tron_account_data;
# ########################################################

# Load the Perl Exporter pragma.
use Exporter;

# Base class of this module.
@ISA = qw(Exporter);

# Export the implemented subroutines.
@EXPORT = qw(get_service_response parse_accountresource
             parse_reward parse_nextmaintenancetime
             parse_account_dates parse_account_votes
             parse_account_frozen encode decode);

# Load the standard Perl pragmas.
#use strict;
use warnings;

# Load the required Perl modules.
use URI;
use POSIX;
use JSON::PP;
use LWP::UserAgent;
use Try::Catch;
use Scalar::Util qw(looks_like_number);

# Set the variable $sun.
my $SUN = 1000000;

# Define the services hash.
my %SERVICES = (
    'getnextmaintenancetime' => ['wallet/getnextmaintenancetime', 'get'],
    'getaccountresource'     => ['wallet/getaccountresource',     'post'],
    'getaccount',            => ['walletsolidity/getaccount',     'post'],
    'getreward'              => ['wallet/getReward',              'post']
);

# Define the allowed attribute names.
my @ARGSARR = ('address', 'service');
my %ARGHASH = map { $_ => 1 } @ARGSARR;

# ============================
# Define the class constructor
# ============================
sub new {
    # Get class variable and arguements hash. 
    my ($class, %args) = @_;
    my $self = {};
    # Get service path and HTTP method.
    my $attrib = $args{'service'};
    my $service = $SERVICES{$attrib}[0];
    my $method = $SERVICES{$attrib}[1];
    # Blessing $self to be an object in $class.
    bless $self, $class;
    # Create a reference to a hash with names as its keys. 
    for my $attrib (keys %args) {
        if(exists($ARGHASH{$attrib})) {
            my $value = $args{$attrib};
            $self->{$attrib} = $value;
        } else {
            print "Invalid parameter '$attrib' passed to '$class' constructor.\n";
        };
    };
    # Get the address.
    my $address = $self->{'address'};
    # Create the payload.
    my $payload = "\{\"address\":\"$address\",\"visible\":\"True\"\}";    
    # Create $self.
    $self->{'payload'} = $payload;
    $self->{'service_path'} = $service;
    $self->{'service_url'} = 'https://api.trongrid.io/';
    $self->{'method'} = $method;
    $self->{'content'} = undef;
    $self->{'decoded'} = undef;
    # Return $self.
    return $self;
};

# ====================
# Subroutine date_time
# ====================
sub date_time {
    # Assign the argument to the local variable.
    my $dt_ms = $_[0];
    # Set the required devisor.
    my $milliseconds = 1000;
    # Get the date and time number. 
    my $dt_sec = int($dt_ms / $milliseconds);
    # Create the date and time string.
    my $date_time = strftime "%Y-%m-%d %H:%M:%S", localtime($dt_sec);
    # Return the date and time string.
    return $date_time;
};

# =================
# Subroutine encode
# =================
sub encode {
    # Get the class attributes.
    my ($self) = @_;
    my $content = $content_obj->{'content'}; 
    # Initialise the $json object.
    my $json = 'JSON::PP'->new->pretty;
    # Get the encoded content.
    my $encoded = $json->encode($json->decode($content));
    # Return the encoded content.
    return $encoded;
};

# =================
# Subroutine decode
# =================
sub decode {
    # Get the class attributes.
    my ($self) = @_;
    my $content = $self->{'content'};
    # Initialise the $json object.
    my $json = 'JSON::PP'->new->pretty;
    # Get the decoded content.
    my $decoded = $json->decode($content);
    # Assign $decoded to $self.
    $self->{decoded} = $decoded;
    #return $decoded;
    return $self;
};

# ===================
# Subroutine response
# ===================
sub response {
    # Assign the arguments to the local variables.
    my ($service_url, $payload, $method) = @_;
    # Declare the local variable $content.
    my $content = undef;
    # Create a uri object from the service url.
    my $uri = URI->new($service_url);
    # Create a user agent object.
    my $ua = LWP::UserAgent->new;
    # Set the default header for the request.
    $ua->default_header('Accept' => 'application/json',
                        'Content_Type' => 'application/json');
    # Get the response from the uri using the HTTP POST method.
    my $response = undef;
    if ("$method" eq 'post') {
        $response = $ua->post($uri, Content => $payload);
    } elsif ("$method" eq 'get') {
        $response = $ua->get($uri, Content => $payload);
    }
    # Check the success of the operation.
    if ($response->is_success) {
        # Get the content from the response.
        $content = $response->content;
    } else {
        # Print a error code and an error message into the terminal window.
        print "HTTP error code: ", $response->code, "\n";
        print "HTTP error message: ", $response->message, "\n";
        # Set the variable $content.
        $content = "";
    }
    # Return the content.
    return $content;
};

# ================================
# Subroutine parse_accountresource
# ================================
sub parse_accountresource {
    # Get the class attributes.
    my $self = shift;
    my $decoded = $self->{decoded};
    # Create an array with the keywords.
    my @keyarr = ('NetLimit', 'freeNetLimit', 'NetUsed',
                  'freeNetUsed', 'EnergyLimit', 'EnergyUsed');
    # Initialise the hash.
    my %data = ();
    for my $key (@keyarr) {
        $data{$key} = 0;
    };
    my $value = undef;
    # Loop over the hash.
    foreach my $key (keys %data) {
        # Get the value from the hash.
        try {
            $value = $decoded->{$key};
            if (defined($value) && $value ne '') {
                if (looks_like_number($value)) {
                    $data{$key} = $value;
                } else {
                    $data{$key} = 0;
                };
            } else {
                $data{$key} = 0;
            };
        } catch {
            $data{$key} = 0;
        }; 
    };
    # Determine bandwidth and energy.
    my $TotalBandwidth = $data{$keyarr[0]} + $data{$keyarr[1]};
    my $FreeBandwidth = $TotalBandwidth - $data{$keyarr[2]} - $data{$keyarr[3]};
    my $TotalEnergy = $data{$keyarr[4]};
    my $FreeEnergy = $TotalEnergy - $data{$keyarr[5]};
    # Assemble array.
    my @result = ($TotalBandwidth, $FreeBandwidth, $TotalEnergy, $FreeEnergy);
    # Return the array with the result.
    return @result;
};

# ==============================
# Subroutine parse_account_dates
# ==============================
sub parse_account_dates {
    # Get the class attributes.
    my $self = shift;
    my $decoded = $self->{decoded};
    # Create an array with the keywords.
    my @keys = ('account_resource', 'latest_consume_time_for_energy', 'create_time',
                'latest_consume_free_time', 'latest_consume_time', 'latest_withdraw_time',
                'latest_withdraw_time', 'latest_opration_time');
    # Get account data.
    my $latest_consume_time_for_energy = date_time($decoded->{$keys[0]}{$keys[1]});
    my $create_time = date_time($decoded->{$keys[2]});
    my $latest_consume_free_time = date_time($decoded->{$keys[3]});
    my $latest_consume_time = date_time($decoded->{$keys[4]});
    my $latest_withdraw_time = date_time($decoded->{$keys[5]});
    my $next_withdraw_time = date_time($decoded->{$keys[6]} + 86400*1000);
    my $latest_opration_time = date_time($decoded->{$keys[7]});
    # Assemble the array with the result.
    my @result = ($create_time, $latest_consume_free_time, $latest_consume_time, 
                $latest_withdraw_time, $next_withdraw_time, $latest_opration_time,
                $latest_consume_time_for_energy);
    # Return the array with the data.
    return @result;
};

# ===============================
# Subroutine parse_account_frozen
# ===============================
sub parse_account_frozen {
    # Get the class attributes.
    my $self = shift;
    my $decoded = $self->{decoded};
    # Set the $keys.
    my @keys = ('balance', 'frozen', 'frozen_balance', 'account_resource',
                'frozen_balance_for_energy', 'expire_time');
    # Get expiration dates and times.
    my $frozen_expire = ($decoded->{$keys[1]}[0]{$keys[5]});
    my $energy_expire = ($decoded->{$keys[3]}{$keys[4]}{$keys[5]});
    $frozen_expire = date_time($frozen_expire);
    $energy_expire = date_time($energy_expire);
    # Get the frozen account data.
    my $free = ($decoded->{$keys[0]}) / $SUN;
    my $frozen = ($decoded->{$keys[1]}[0]{$keys[2]}) / $SUN;
    my $energy = ($decoded->{$keys[3]}{$keys[4]}{$keys[2]}) / $SUN;
    # Calculate the other account data.
    my $total = $free + $frozen + $energy;
    my $total_frozen = $frozen + $energy;
    # Assemble the final array with the result.
    my @result = ($frozen_expire, $energy_expire, $free,
                  $frozen, $energy, $total, $total_frozen);
    # Return the array with the data.
    return @result;
};

# ==============================
# Subroutine parse_account_votes
# ==============================
sub parse_account_votes {
    # Get the class attributes.
    my $self = shift;
    my $decoded = $self->{decoded};
    # Set the $key array.
    my @keys = ('votes', 'vote_address', 'vote_count');
    # Get total votes and list of Super Representatives (SR's).
    my $sr_address = undef;
    my $sr_votes = undef;
    my %sr_hash = (); 
    my $votes = $decoded->{$keys[0]};
    # Loop over the SR's.
    for my $ele (@$votes) {
        $sr_address = $ele->{$keys[1]};
        $sr_votes = $ele->{$keys[2]};
        $sr_hash{$sr_address} = $sr_votes;
    };
    # Return the hash with the data.
    return \%sr_hash;
};

# ============================
# Subroutine parse_total_votes
# ============================
sub parse_total_votes {
    # Get the class attributes.
    my $self = shift;
    my $decoded = $self->{decoded};
    # Set the $key array.
    my @keys = ('votes', 'vote_count');
    # Get the total votes.
    my $sr_votes = undef;
    my $total_votes = 0;
    my $votes = $decoded->{$keys[0]};
    # Loop over the votes array.
    for my $ele (@$votes) {
        # Get the total votes.
        $sr_votes = $ele->{$keys[1]};
        $total_votes += $sr_votes;
    };
    # Return the total votes.
    return $total_votes;
};

# =======================
# Subroutine parse_reward
# =======================
sub parse_reward {
    # Get the class attributes.
    my $self = shift;
    my $decoded = $self->{decoded};
    # Set the key.
    my $key = 'reward';
    # Get the reward as number in seconds.
    my $reward = ($decoded->{$key}) / $SUN;
    # Return the reward.
    return $reward;
};

# ====================================
# Subroutine parse_nextmaintenancetime
# ====================================
sub parse_nextmaintenancetime {
    # Get the class attributes.
    my $self = shift;
    my $decoded = $self->{decoded};
    # Set the key.
    my $key = 'num';
    # Get date and time as number.
    my $dt_num = ($decoded->{$key});
    # Get date and time as string.
    my $dt_str = date_time($dt_num);
    # Return date and time.
    return $dt_str;
};

# ===============================
# Subroutine get_service_response
# ===============================
sub get_service_response {
    # Get the class attributes.
    my $self = shift;
    my $method = $self->{method};
    my $service_url = $self->{service_url};
    my $service_path = $self->{service_path};
    my $payload = $self->{payload};
    # Set the service url.
    my $api_url = $service_url . $service_path;
    # Set the array for the HTTP request.
    my @arr = ($api_url, $payload, $method);
    # Get the content from the response.
    my $content = response(@arr);
    # Assign $content to $self.
    $self->{content} = $content;
    # Return $self;
    return $self;
};

1;
