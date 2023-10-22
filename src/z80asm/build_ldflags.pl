#!/usr/bin/env perl

use strict;
use warnings;

@ARGV==2 or die "Usage: $0 CXX CROSS\n";
my($gcc, $cross) = @ARGV;

my $file = "build_ldflags$$";

# when corss compiling, need to link statically
if ($cross) {
	print "-static-libstdc++ -static-libgcc ";
}
else {
	# check if -lstdc++fs exists
	open(my $fh, ">", "$file.cpp") or die "open $file.cpp:$!";
	print $fh "int main(){}";
	close($fh);

	if (0 == system "$gcc -o $file $file.cpp -lstdc++fs 2> $file.err") {
		print "-lstdc++fs ";
	}
	else {
		# check if we need boost::filesystem
		open(my $fh, ">", "$file.cpp") or die "open $file.cpp:$!";
		print $fh <<END;
#if !__has_include(<filesystem>)	// std::filesystem from C++17
-lboost_filesystem-mt
#endif
END
		open(my $pipe, "$gcc -E $file.cpp |") or die;
		while (<$pipe>) {
			chomp;
			s/^#.*//;
			print "$_ ";
		}
		close($pipe);
	}
	print "\n";
}
unlink "$file.cpp", "$file.err", $file;
