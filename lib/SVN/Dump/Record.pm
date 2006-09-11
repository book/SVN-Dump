package SVN::Dump::Record;

use strict;
use warnings;

my $NL = "\012";

sub new {
    my ($class, @args) = @_;
    return bless {}, $class
}

for my $attr (qw( headers property text included )) {
    no strict 'refs';
    *{"set_$attr"} = sub { $_[0]->{$attr} = $_[1]; };
    *{"get_$attr"} = sub { $_[0]->{$attr} };
}

sub type {
    my ($self) = @_;
    return $self->{headers} ? $self->{headers}->type() : '';
}

sub has_text { return exists $_[0]->{headers}{'Text-content-length'} }
sub has_prop { return exists $_[0]->{headers}{'Prop-content-length'} }
sub has_prop_only {
    return exists $_[0]->{headers}{'Prop-content-length'}
        && !exists $_[0]->{headers}{'Text-content-length'};
}
sub has_prop_or_text {
    return exists $_[0]->{headers}{'Prop-content-length'}
        || exists $_[0]->{headers}{'Text-content-length'};
}

sub as_string {
    my ($self) = @_;
    my $headers = $self->get_headers();

    # the headers
    my $string = $headers->as_string();

    # the properties
    $string .= $self->get_property()->as_string()
        if exists $headers->{'Prop-content-length'};

    # the text
    $string .= $self->get_text()->as_string()
        if exists $headers->{'Text-content-length'};

    # is there an included record?
    if( my $included = $self->get_included() ) {
        $string .= $included->as_string() . $NL;
    }

    # add a record separator if needed
    my $type = $self->type();
    return $string if $type =~ /\A(?:format|uuid)\z/;

    $string .= $type eq 'revision'  ? $NL
        : $self->has_prop_or_text() ? $NL x 2
        :                             $NL ;

    return $string;
}

1;

__END__

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

An C<SVN::Dump::Record> object represents a Subversion dump record.

=head1 METHODS

C<SVN::Dump> provides the following methods:

=over 4

=item new()

Create a new empty C<SVN::Dump::Record> object.

=item type()

Return the record type, as guessed from its headers.

The method dies if the record type cannot be determined.

=item set_headers( $headers )

=item get_headers()

Get or set the C<SVN::Dump::Headers> object that represents the record
headers.

=item set_property( $property )

=item get_property()

Get or set the C<SVN::Dump::Property> object that represents the record
property block.

=item set_text( $text )

=item get_text()

Get or set the C<SVN::Dump::Text> object that represents the record
text block.

=item set_included( $record )

=item get_included()

Some special record are actually output recursiveley by B<svnadmin dump>.
The "record in the record" is stored within the parent record, so they
are parsed as a single record with an included record.

C<get_record()> / C<set_record()> give access to the included record.

According to the Subversion sources (F<subversion/libsvn_repos/dump.c>),
this is a "delete original, then add-with-history" node. The dump looks
like this:

    Node-path: tags/mytag/myfile
    Node-kind: file
    Node-action: delete
    
    Node-path: tags/mytag/myfile
    Node-kind: file
    Node-action: add
    Node-copyfrom-rev: 23
    Node-copyfrom-path: trunk/myfile
    
    
    
    

Note that there is a single blank line after the first header block,
and four after the included one.

=item has_prop()

Return a boolean value indicating if the record has a property block.

=item has_text()

Return a boolean value indicating if the record has a text block.

=item has_prop_only()

Return a boolean value indicating if the record has only a property block
(and no text block).

=item has_prop_or_text()

Return a boolean value indicating if the record has a property block
or a text block.

=item as_string()

Return a string representation of the record.

=back

=head1 SEE ALSO

C<SVN::Dump::Headers>, C<SVN::Dump::Property>, C<SVN::Dump::Text>.

=head1 COPYRIGHT & LICENSE

Copyright 2006 Philippe 'BooK' Bruhat, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

