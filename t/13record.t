use strict;
use warnings;
use Test::More;
use t::Utils;

use SVN::Dump::Record;
use SVN::Dump::Headers;
use SVN::Dump::Property;
use SVN::Dump::Text;

plan tests => 13;

# the record object
my $rec = SVN::Dump::Record->new();
isa_ok( $rec, 'SVN::Dump::Record' );

# create some headers
my $h = SVN::Dump::Headers->new();
$h->{$_->[0]} = $_->[1] for (
    [ 'Node-path' => 'trunk/latin' ],
    [ 'Node-kind' => 'file' ],
    [ 'Node-action' => 'add' ],
);

# create a property block
my $p = SVN::Dump::Property->new();
$p->set( @$_ ) for (
    [ 'svn:log'    => 'lorem ipsum sint' ],
    [ 'svn:author' => 'book' ],
    [ 'svn:date'   => '2006-01-06T02:36:55.834244Z' ],
);

# create a text block
my $t = SVN::Dump::Text->new( << 'EOT' );
eos magnam a incidunt ipsum enim sint sed voluptatum adipisicing
temporibus officia earum accusamus animi et possimus deserunt eveniet
esse reiciendis laboriosam facere voluptas repellendus mollitia hic ipsam
aliquid illum qui numquam amet quisquam provident lorem similique minus
sapiente exercitation cupiditate nostrum
EOT

# no headers yet
is( $rec->type(), '', q{No headers yet, can't determine type} );

# give the record some headers
$rec->set_headers( $h );
is( $rec->type(), $h->type(), 'Type given by the headers' );
ok( ! $rec->has_prop(), 'Record has no property block' );
ok( ! $rec->has_text(), 'Record has no text block' );

# add some properties
$rec->set_property( $p );
$h->{$_->[0]} = $_->[1] for (
    [ 'Prop-content-length' => '115' ],
    [ 'Content-length' => '115' ],
);
ok( $rec->has_prop(), 'Record has a property block' );
ok( ! $rec->has_text(), 'Record has no text block' );
ok( $rec->has_prop_only(), 'Record has only a property block' );
ok( $rec->has_prop_or_text(), 'Record has a property or text block' );

# add some text
$rec->set_text( $t );
$h->{$_->[0]} = $_->[1] for (
    [ 'Text-content-length' => '322' ],
    [ 'Content-length' => '437' ],
);
ok( $rec->has_prop(), 'Record has a property block' );
ok( $rec->has_text(), 'Record has a text block' );
ok( ! $rec->has_prop_only(), 'Record has not only a property block' );
ok( $rec->has_prop_or_text(), 'Record has a property or text block' );

