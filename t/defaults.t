use Test::More;
use Test::Fatal;

use MooseX::UndefTolerant::Attribute ();

{
    package Foo;
    use Moose;

    has 'attr1' => (
        traits => [ qw(MooseX::UndefTolerant::Attribute)],
        is => 'ro',
        isa => 'Num',
        predicate => 'has_attr1',
        default => 1,
    );
    has 'attr2' => (
        is => 'ro',
        isa => 'Num',
        predicate => 'has_attr2',
        default => 2,
    );
}

{
    package Bar;
    use Moose;
    use MooseX::UndefTolerant;

    has 'attr1' => (
        is => 'ro',
        isa => 'Num',
        predicate => 'has_attr1',
        default => 1,
    );
    has 'attr2' => (
        is => 'ro',
        isa => 'Num',
        predicate => 'has_attr2',
        default => 2,
    );
}


package main;

sub do_tests
{
    note 'Testing class with a single UndefTolerant attribute';
    {
        my $obj = Foo->new;
        ok($obj->has_attr1, 'attr1 has a value');
        ok($obj->has_attr2, 'attr2 has a value');
        is($obj->attr1, 1, 'attr1\'s value is its default');
        is($obj->attr2, 2, 'attr2\'s value is its default');
    }

    {
        my $obj = Foo->new(attr1 => undef);
        ok($obj->has_attr1, 'UT attr1 has a value when assigned undef in constructor');
        is($obj->attr1, 1, 'attr1\'s value is its default');
        is($obj->attr2, 2, 'attr2\'s value is its default');
    }

    {
        my $obj = Foo->new(attr1 => 1234, attr2 => 5678);
        is($obj->attr1, 1234, 'assigning a defined value during construction works as normal');
        ok($obj->has_attr1, '...and the predicate returns true as normal');
        is($obj->attr2, 5678, 'assigning a defined value during construction works as normal');
        ok($obj->has_attr2, '...and the predicate returns true as normal');
    }


    note '';
    note 'Testing class with the entire class being UndefTolerant';
    {
        my $obj = Bar->new;
        ok($obj->has_attr1, 'attr1 has a value');
        ok($obj->has_attr2, 'attr2 has a value');
        is($obj->attr1, 1, 'attr1\'s value is its default');
        is($obj->attr2, 2, 'attr2\'s value is its default');
    }

    {
        my $obj = Bar->new(attr1 => undef);
        ok($obj->has_attr1, 'UT attr1 has a value when assigned undef in constructor');
        is($obj->attr1, 1, 'attr1\'s value is its default');
        is($obj->attr2, 2, 'attr2\'s value is its default');
    }

    {
        my $obj = Bar->new(attr1 => 1234, attr2 => 5678);
        is($obj->attr1, 1234, 'assigning a defined value during construction works as normal');
        ok($obj->has_attr1, '...and the predicate returns true as normal');
        is($obj->attr2, 5678, 'assigning a defined value during construction works as normal');
        ok($obj->has_attr2, '...and the predicate returns true as normal');
    }
}

note 'Default behaviour: mutable classes';
note '';
do_tests;

note '';
note 'Default behaviour: immutable classes';
note '';
Foo->meta->make_immutable;
Bar->meta->make_immutable;

TODO: {
    local $TODO = 'some immutable cases are not handled yet';
    # for now, catch errors
    ok(! exception { do_tests }, 'tests do not die');

    is(Test::More->builder->current_test, 44, 'if we got here, we can declare victory!');
}

done_testing;

