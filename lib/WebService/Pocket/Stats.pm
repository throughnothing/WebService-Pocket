use strict;
use warnings;
package WebService::Pocket::Stats;
use Moose;
use Moose::Util::TypeConstraints;

subtype 'WebService::Pocket::DateTime' => as class_type('DateTime');

coerce 'WebService::Pocket::DateTime' => from 'Num' => via {
    DateTime->from_epoch( epoch => $_ );
};

has count_list   => ( is => 'ro', isa => 'Int' );
has count_unread => ( is => 'ro', isa => 'Int' );
has count_read   => ( is => 'ro', isa => 'Int' );
has user_since   => ( is => 'ro',
    isa => 'WebService::Pocket::DateTime', coerce => 1 );

1;

=head1 DESCRIPTION

L<WebService::Pocket::Stats> represents user statistics for their
L<Pocket|http://getpocket.com/> account.

=head1 ATTRIBUTES

=head2 count_list

Total number of items in the users C<Pocket> account.

=head2 count_unread

Total number of unread items in the users C<Pocket> account.

=head2 count_read

Total number of read items in the users C<Pocket> account.

=head2 user_since

L<DateTime> object representing the time at which the users C<Pocket> account
was created.
