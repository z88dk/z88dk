#!/usr/bin/env perl

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

# https://github.com/z88dk/z88dk/issues/3222
# zsdcc -debug: the source file is named as given on the command line, as
# sccz80 does, so that z88dk-ticks finds a file-local symbol by the file of
# the line it stopped at

my $dir  = "${test}_dir";
# a header named like the source, and one of the same length: neither is the source
my $hdr_same = "h" x ( length("${test}.c") - 2 ) . ".h";
my $hdr_pref = "${test}.c.h";

sub clean {
    unlink_testfiles;
    path($dir)->remove_tree;
    path("${dir}\$")->remove_tree;
    path("${dir}_a")->remove_tree;
    path("${dir}_b")->remove_tree;
}

sub unmangle {
    ( my $s = shift ) =~ s/_([0-9a-f]{2})/chr(hex($1))/ge;
    return $s;
}

clean;
path($dir)->mkpath;
path("${dir}\$")->mkpath;
my $src = <<END;
static int counter;
int get(void)
{
    counter = 5;
    return counter;
}
int main(void)
{
    return get();
}
END
spew( "${dir}\$/${test}.c", $src );

# the file under test, a header with a static function, a header named like the
# source
spew( "$dir/${test}.c", <<END );
#include "$hdr_same"
#include "$hdr_pref"
static int counter;
int get(void)
{
    counter = 5;
    return counter;
}
int main(void)
{
    return get() + hf(1) + hg(2);
}
END
spew( "$dir/$hdr_same", "static int hf(int v)\n{\n    return v + 1;\n}\n" );
spew( "$dir/$hdr_pref", "static int hg(int v)\n{\n    return v + 2;\n}\n" );

# -------------------------------------------------------------------------
# the file name of the records and of the lines is the path as given

run_ok("zcc +test -compiler=sdcc -debug -m $dir/${test}.c -o ${test}.bin");

my ( @scope, @cline, $ret_addr );
for my $line ( path("${test}.map")->lines ) {
    if ( $line =~ /^__CDBINFO__(\S+)\s+=/ ) {
        my $rec = unmangle($1);
        push @scope, $1 if $rec =~ /^S:F(.*)\$counter\$/;
    }
    elsif ( $line =~ /^__C_LINE_(\d+)_(\S+)\s+=\s+\$([0-9A-F]+)/ ) {
        my ( $n, $name, $addr ) = ( $1, unmangle($2), $3 );
        $name =~ s/::.*//;
        push @cline, $name;
        $ret_addr = $addr if $n == 7 && $name eq "$dir/${test}.c";
    }
}
is_deeply \@scope, ["$dir/${test}.c"], "file-static counter is in the file as given";
is_deeply [ sort keys %{ { map { $_ => 1 } @cline } } ],
    [ sort "$dir/${test}.c", $hdr_same, $hdr_pref ],
    "C_LINE names the source as given, and the headers by their own names";

# -------------------------------------------------------------------------
# z88dk-ticks resolves the file-static at the line of the return

ok defined $ret_addr, "line 7 has an address" or die;
path("${test}.cmd")->spew("break 0x$ret_addr\ncont\nprint counter\nquit\n");
run_ok("z88dk-ticks -x ${test}.map -d ${test}.bin < ${test}.cmd > ${test}.out 2>&1");
like slurp("${test}.out"), qr/^.*\$1 = <int16_t> 5$/m, "z88dk-ticks prints counter";

# -------------------------------------------------------------------------
# two files of one name in different directories, each with a static counter:
# each has its own scope, its own module, its own counter in the map, and
# z88dk-ticks prints the right one

my ( $da, $db ) = ( "${dir}_a", "${dir}_b" );
path($_)->mkpath for $da, $db;
spew( "$da/${test}.c", <<END );
static int counter;
int fa(void)
{
    counter = 5;
    return counter;
}
END
spew( "$db/${test}.c", <<END );
static int counter;
int fa(void);
int main(void)
{
    counter = 7;
    return counter + fa();
}
END
run_ok("zcc +test -compiler=sdcc -debug -m $da/${test}.c $db/${test}.c -o ${test}3.bin");
@scope = ();
my ( $addr_fa, $addr_main, $counters );
for my $line ( path("${test}3.map")->lines ) {
    $counters++ if $line =~ /^_counter\s+=/;
    if ( $line =~ /^__CDBINFO__(\S+)\s+=/ ) {
        my $rec = unmangle($1);
        push @scope, $1 if $rec =~ /^S:F(.*)\$counter\$/;
    }
    elsif ( $line =~ /^__C_LINE_(\d+)_(\S+)\s+=\s+\$([0-9A-F]+)/ ) {
        my ( $n, $name, $addr ) = ( $1, unmangle($2), $3 );
        $addr_fa   = $addr if $n == 5 && $name =~ m{^\Q$da\E/};
        $addr_main = $addr if $n == 7 && $name =~ m{^\Q$db\E/};
    }
}
is_deeply [ sort @scope ], [ sort "$da/${test}.c", "$db/${test}.c" ], "the file-statics of the two files have a scope each";
is $counters, 2, "the map has a counter for each file";
ok defined $addr_fa && defined $addr_main, "the lines of fa and main have an address" or die;
path("${test}3.cmd")->spew("break 0x$addr_fa\nbreak 0x$addr_main\ncont\nprint counter\ncont\nprint counter\nquit\n");
run_ok("z88dk-ticks -x ${test}3.map -d ${test}3.bin < ${test}3.cmd > ${test}3.out 2>&1");
like slurp("${test}3.out"), qr/\$1 = <int16_t> 5\n.*\$2 = <int16_t> 7$/ms, "counter is 5 in fa and 7 in main";

# -------------------------------------------------------------------------
# the module is named by the path for a zsdcc -debug C file only: a build
# without -debug, and an asm file of a -debug build, keep the base name

sub module_of {
    my ( $map, $sym ) = @_;
    for my $line ( path($map)->lines ) {
        return $1 if $line =~ /^\Q$sym\E\s+=\s+\$[0-9A-F]+\s*;\s*[^,]*,\s*[^,]*,\s*,\s*([^,]*),/;
    }
    return "";
}

run_ok("zcc +test -compiler=sdcc -m $dir/${test}.c -o ${test}4.bin");
is module_of( "${test}4.map", "_get" ), "${test}_c", "without -debug the module of the C file is its base name";

spew( "$dir/${test}y.asm", "\tpublic\tyfn\nyfn:\tret\n" );
run_ok("zcc +test -compiler=sdcc -debug -m $dir/${test}.c $dir/${test}y.asm -o ${test}5.bin");
is module_of( "${test}5.map", "_get" ), "${dir}_${test}_c", "with -debug the module of the C file is its path";
is module_of( "${test}5.map", "yfn" ), "${test}y_asm", "with -debug the module of an asm file is its base name";

# -------------------------------------------------------------------------
# a '$' cannot be written in a record: the old name, and a warning

run_ok("zcc +test -compiler=sdcc -debug -m ${dir}\$/${test}.c -o ${test}2.bin 2> ${test}2.err");
like slurp("${test}2.err"), qr/Warning: .*\$.*cannot hold a '\$'/, "warning for a name with a '\$'";
@scope = ();
for my $line ( path("${test}2.map")->lines ) {
    next unless $line =~ /^__CDBINFO__(\S+)\s+=/;
    my $rec = unmangle($1);
    push @scope, $1 if $rec =~ /^S:F(.*)\$counter\$/;
}
is_deeply \@scope, ["${dir}\$_${test}"], "the file name of a path with a '\$' is the old one";

clean;
done_testing;
