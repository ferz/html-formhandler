use strict;
use warnings;
use Test::More;
use Test::Exception;

# tests the SelectCSV field
{
    package MyApp::Form::Test;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler';

    has_field 'foo' => ( type => 'SelectCSV' );
    sub options_foo {
       (
          1 => 'One',
          2 => 'Two',
       )
    }
    has_field 'bar' => ( type => 'SelectCSV' );
    sub options_bar {
       (
          1 => 'One',
          2 => 'Two',
       )
    }
    has_field 'box' => ( type => 'Select', multiple => 1 );
    sub options_box {
       (
          1 => 'One',
          2 => 'Two',
          3 => 'Three',
       )
    }

}

my $form = MyApp::Form::Test->new;
ok( $form );
my $init_obj = { foo => '1', bar => '1,2', box => [2] };

$form->process( init_object => $init_obj );
my $fif = $form->fif;
is_deeply( $fif, { foo => [1], bar => [1,2], box => [2] },
   'fif is correct' );

lives_ok( sub { $form->field('bar')->as_label }, 'as_label works with SelectCSV field' );

my $rendered = $form->render;
ok( $rendered, 'rendering worked' );

my $params = { bar => [2,1]  };
$form->process( $params );
lives_ok( sub { $form->field('bar')->as_label }, 'as_label works with SelectCSV field' );
$fif = $form->fif;
is_deeply( $fif, $params, 'fif ok' );
my $value = $form->value;
is_deeply( $value, { foo => undef, bar => '1,2', box => [] }, 'right value' );
$rendered = $form->render;
ok( $rendered, 'rendering worked' );

done_testing;
