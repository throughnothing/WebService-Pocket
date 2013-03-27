package WebService::Pocket::Script;
#ABSTRACT: Wrap up WebService::Pocket into a runable script with a config file
use Moose;

extends 'WebService::Pocket'; # XXX: this would ideally be a role :/

with 'MooseX::SimpleConfig';
with 'MooseX::Getopt' => { -version => 0.48 };

# XXX: is this good enough?
has '+configfile' => (
    default => $ENV{HOME} . "/.pocketrc",
    traits => [qw/NoGetopt/]
);

has "+$_" => ( traits => [qw/NoGetopt/] )
for qw/api_key base_url ua json items list_since/;

has "+$_" => (documentation => "Set $_. Can also be set in ~/.pocketrc")
for qw/username password/;

before 'print_usage_text' => sub {
    print <<END;
$0 - Wrap up Webservice::Pocket in a script

Configure in ~/.pocketrc, add something like:

username=myusername
password=s3cr3t

Commands:

  add <url> [<url>]: Add url(s) to your pocket list

END
};


sub config_any_args {
    my ($self) = @_;
    return {
        force_plugins => ['Config::Any::INI'],
    }
}

sub run {
    my ($self) = @_;
    my @args = @{ $self->extra_argv };
    my $cmd = shift @args;
    unless ($cmd) {
        die "No command given, try add <url> [<url>] to add something to pocket";
    }
    if (my $action = $self->can("cmd_$cmd")) {
        $self->$action(@args);
    }
}

sub cmd_add {
    my ($self, @args) = @_;

    my @items = map {
    {
        url => $_
    }
    } @args;
    my $res = $self->add(\@items);
    print join("\n*", map { $_->url } @$res);
}



1;
