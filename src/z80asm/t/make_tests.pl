#!/usr/bin/perl

use Modern::Perl;

open(my $f, ">:raw", "t/test.def") or die $!;

@ARGV = <t/t_*.cpp>;
while (<>) {
    if (/^ \s* void \s+ (test_\w*) \s* \( \s* \) /x) {
    print $f <<"END";
#if EXEC_TEST==0
extern void $1();
$1();
#endif

END
    }
    elsif (/^ \s* int \s+ (exec_\w*) \s* \( \s* \) /x) {
    print $f <<"END";
#if EXEC_TEST==1
if (test == "$1") {
    extern int $1();
    int rv = $1();
    exit(rv);
}
#endif

END
    }
    elsif (/^ \s* int \s+ (exec_\w*) \s* \( \s* const \s+ string \s* & \s* \w+ \) /x) {
    print $f <<"END";
#if EXEC_TEST==2
if (test == "$1") {
    extern int $1(const string& arg);
    int rv = $1(arg);
    exit(rv);
}
#endif

END
    }
}
