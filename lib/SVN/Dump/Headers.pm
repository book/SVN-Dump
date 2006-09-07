package SVN::Dump::Headers;

use strict;
use warnings;
use Carp;

my $NL = "\012";

sub new { return bless {}, shift; }

my %headers = (
    revision => [
        qw(
            Revision-number
            Prop-content-length
            Content-length
            )

    ],
    node => [
        qw(
            Node-path
            Node-kind
            Node-action
            Node-copyfrom-rev
            Node-copyfrom-path
            Prop-content-length
            Text-copy-source-md5
            Text-content-length
            Text-content-md5
            Content-length
            )
    ],
    uuid   => ['UUID'],
    format => ['SVN-fs-dump-format-version'],
);

# FIXME Prop-delta and Text-delta in version 3

sub as_string {
    my ($self) = @_;
    my $string = '';

    for my $k ( @{ $headers{ $self->type() } } ) {
        $string .= "$k: $self->{$k}$NL"
            if exists $self->{$k};
    }

    return $string . $NL;
}

sub type {
    my ($self) = @_;

    my $type =
          exists $self->{'Node-path'}                  ? 'node'
        : exists $self->{'Revision-number'}            ? 'revision'
        : exists $self->{'UUID'}                       ? 'uuid'
        : exists $self->{'SVN-fs-dump-format-version'} ? 'format'
        :   croak 'Unable to determine the record type';

    return $type;
}

1;

__END__

=head1 NAME

SVN::Dump::Headers - Headers of a SVN dump record

=head1 SYNOPSIS

=head1 DESCRIPTION

An C<SVN::Dump::Headers> object represents the headers of a
SVN dump record.

=head1 METHODS

C<SVN::Dump::Headers> provides the following methods:

=over 4

=item new()

Create and return a new empty C<SVN::Dump::Headers> object.

=item as_string()

Return a string that represents the record headers.

=item type()

One can guess the record type from its headers.

This method returns a string that represents the record type.
The string is one of C<revision>, C<node>, C<uuid> or C<format>.

The method dies if it can't determine the record type.

=back

=head1 SEE ALSO

C<SVN::Dump::Record>.

=head1 COPYRIGHT & LICENSE

Copyright 2006 Philippe 'BooK' Bruhat, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

