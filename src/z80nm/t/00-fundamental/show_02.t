BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

my $dir = path($0)->dirname;
my $self = path($0)->basename(".t");
for (1..1) {
    my $version = sprintf "%02d", $_;
    capture_ok( "z80objfile.pl -v$version -b $dir/input/$self.def",
        "$dir/expected/${self}_z80objfile_v${version}.txt" );
    capture_ok( "z88dk-z80nm -a $dir/input/$self.def.o",
        "$dir/expected/${self}_z80nm_v${version}.txt" );
    unlink "$dir/input/$self.def.o";
}

unlink_testfiles;
done_testing;
