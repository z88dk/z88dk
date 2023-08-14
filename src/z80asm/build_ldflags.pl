#!/usr/bin/env perl

use Modern::Perl;
use Path::Tiny;

# check if we need boost::filesystem
my $file = "build_ldflags$$";
path("$file.cpp")->spew(<<END);
#if __has_include(<filesystem>)	// std::filesystem from C++17
#ifdef WIN32
#if CROSS == 1
-static-libstdc++ -static-libgcc
#endif
#endif
#else							// boost::filesystem from Boost
-lboost_filesystem-mt
#endif
END

open(my $pipe, "$ARGV[0] -DCROSS=$ARGV[1] -E $file.cpp |") or die;
while (<$pipe>) {
	chomp;
	s/^#.*//;
	print "$_ ";
}
close($pipe);
print "\n";
unlink "$file.cpp";
