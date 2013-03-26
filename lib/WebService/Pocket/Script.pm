package WebService::Pocket::Script;

use Moose;

extends 'WebService::Pocket'; # XXX: this would ideally be a role :/

with 'MooseX::SimpleConfig';
with 'MooseX::Getopt';

# XXX: is this good enough?
has '+configfile' => ( default => $ENV{HOME} . "/.pocketrc" );

sub config_any_args {
    return {
        force_plugins => ['Config::Any::INI'],
    }
}

sub run {
    my $self = shift;
    require Data::Dump;
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
    my $self = shift;

    my @items = map {
    {
        url => $_
    }
    } @_;
    my $res = $self->add(\@items);
    print join("\n*", map { $_->url } @$res);
}



1;
