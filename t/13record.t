use strict;
use warnings;
use Test::More;
use t::Utils;

use SVN::Dump::Record;

plan tests => 23;

# the record object
my $rec = SVN::Dump::Record->new();
isa_ok( $rec, 'SVN::Dump::Record' );

# no headers yet
is( $rec->type(), '', q{No headers yet, can't determine type} );

# create some headers
$rec->set_header( @$_ ) for (
    [ 'Node-path' => 'trunk/latin' ],
    [ 'Node-kind' => 'file' ],
    [ 'Node-action' => 'add' ],
);

# give the record some headers
is( $rec->type(), 'node', 'Type given by the headers' );
ok( ! $rec->has_prop(), 'Record has no property block' );
ok( ! $rec->has_text(), 'Record has no text block' );
is( $rec->property_length(), 0, 'Prop-length == 0' );
is( $rec->text_length(), 0, 'Text-length == 0' );

# create a property block
my @props = (
    [ 'svn:log'    => 'lorem ipsum sint' ],
    [ 'svn:author' => 'book' ],
    [ 'svn:date'   => '2006-01-06T02:36:55.834244Z' ],
);

$rec->set_property( @$_ ) for @props;

# check the headers were updated
is( $rec->get_header( $_->[0] ), $_->[1], "$_->[0] header" ) for (
    [ 'Prop-content-length' => '115' ],
    [ 'Content-length' => '115' ],
);

# check the properties were updated
is( $rec->get_property( $_->[0] ), $_->[1], "$_->[0] property" ) for @props;

ok( $rec->has_prop(), 'Record has a property block' );
ok( ! $rec->has_text(), 'Record has no text block' );
ok( $rec->has_prop_only(), 'Record has only a property block' );
ok( $rec->has_prop_or_text(), 'Record has a property or text block' );

# create a text block
my $t = << 'EOT';
eos magnam a incidunt ipsum enim sint sed voluptatum adipisicing
temporibus officia earum accusamus animi et possimus deserunt eveniet
esse reiciendis laboriosam facere voluptas repellendus mollitia hic ipsam
aliquid illum qui numquam amet quisquam provident lorem similique minus
sapiente exercitation cupiditate nostrum
EOT

# add some text
$rec->set_text( $t );

# check the headers were updated
is( $rec->get_header( $_->[0] ), $_->[1], "$_->[0] header" ) for (
    [ 'Text-content-length' => '322' ],
    [ 'Content-length' => '437' ],
);

# check the text is available
is( $rec->get_text(), $t, 'Text block' );

ok( $rec->has_prop(), 'Record has a property block' );
ok( $rec->has_text(), 'Record has a text block' );
ok( ! $rec->has_prop_only(), 'Record has not only a property block' );
ok( $rec->has_prop_or_text(), 'Record has a property or text block' );

