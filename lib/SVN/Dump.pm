package SVN::Dump;

use strict;
use warnings;
use Carp;

use SVN::Dump::Reader;

our $VERSION = '0.01';

sub new {
    my ( $class, $args ) = @_;

    # create the Reader object now
    my $self = bless {}, $class;
    open my $fh, $args->{file} or croak "Can't open $args->{file}: $!";
    $self->{reader} = SVN::Dump::Reader->new( $fh );

    return $self;
}

sub next_record {
    my ($self) = @_;
    my $record;

RECORD: {
        $record = $self->{reader}->read_record();
        return unless $record;

        # load the first records transparently
        my $type = $record->type();
        if ( $type =~ /\A(?:format|uuid)\z/ ) {
            $self->{$type} = $record;
            redo RECORD;
        }
    }

    return $record;
}

sub version {
    my ($self) = @_;
    return $self->{format}
        ? $self->{format}->get_headers()->{'SVN-fs-dump-format-version'}
        : '';
}

sub uuid {
    my ($self) = @_;
    return $self->{uuid} ? $self->{uuid}->get_headers()->{UUID} : '';
}

sub as_string {
    return join '', $_[0]->{$_}->as_string() for (qw( format uuid ));
}

__END__

=head1 NAME

SVN::Dump - A Perl interface to Subversion dumps

=head1 SYNOPSIS

    use SVN::Dump;
    
    my $file = shift;
    my $dump = SVN::Dump->new( { file => $file } );
    
    # compute some stats
    my %type;
    while ( my $record = $dump->next_record() ) {
        $type{ $record->type() }++;
    }
    
    # print the results
    print "Dump $file statistics:\n",
          "  version:   ", $dump->version(), "\n",
          "  uuid:      ", $dump->uuid(), "\n",
          "  revisions: ", $type{revision}, "\n",
          "  nodes:     ", $type{node}, "\n";

=head1 DESCRIPTION

B<This module is an alpha release. The interfaces will probably change
in the future, as I slowly learn my way inside the SVN dump format.>

An C<SVN::Dump> object represents a Subversion dump.

This module follow the semantics used in the reference document
(the file F<notes/fs_dumprestore.txt> in the Subversion source tree).

Each class has a C<as_string()> method that prints its content
in the dump format.

The most basic thing you can do with C<SVN::Dump> is simply copy
a dump:

    use SVN::Dump;

    my $dump = SVN::Dump->new( 'mydump.svn' );
    print $dump->as_string(); # only print the dump header

    while( $rev = $dump->next_record() ) {
        print $rev->as_string();
    }

After the operation, the resulting dump should be identical to the
original dump.

=head1 METHODS

C<SVN::Dump> provides the following methods:

=over 4

=item new()

Return a new C<SVN::Dump> object.

=item next_record()

Return the next record read from the dump.

=item version()

Return the dump format version.

=item uuid()

Return the dump UUID.

=item as_string()

Return a string representation of the dump specific blocks
(the C<format> and C<uuid> blocks only).

=back

=head1 SEE ALSO

C<SVN::Dump::Reader>.

=head1 COPYRIGHT & LICENSE

Copyright 2006 Philippe 'BooK' Bruhat, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

