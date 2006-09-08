package SVN::Dump::Property;

use strict;
use warnings;

my $NL = "\012";

# FIXME should I use Tie::Hash::IxHash or Tie::Hash::Indexed?
sub new {
    my ( $class, @args ) = @_;
    return bless {
        keys => [],
        hash => {},
    }, $class;
}

sub set {
    my ( $self, $k, $v ) = @_;

    push @{ $self->{keys} }, $k if !exists $self->{hash}->{$k};
    $self->{hash}{$k} = $v;
}
sub get    { return $_[0]{hash}{ $_[1] }; }
sub keys   { return @{ $_[0]{keys} }; }
sub values { return @{ $_[0]{hash} }{ @{ $_[0]{keys} } }; }

sub as_string {
    my ($self) = @_;
    my $string = '';

    $string .=
          ( "K " . length($_) . $NL )
        . "$_$NL"
        . ( "V " . length( $self->{hash}{$_} ) . $NL )
        . "$self->{hash}{$_}$NL"
        for @{ $self->{keys} };

    # end marker
    $string .= "PROPS-END$NL$NL";

    return $string;
}

1;

__END__

=head1 NAME

SVN::Dump::Property - A property block from a svn dump

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

=head1 COPYRIGHT & LICENSE

Copyright 2006 Philippe 'BooK' Bruhat, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

