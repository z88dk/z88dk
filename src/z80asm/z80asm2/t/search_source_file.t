#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2026
# License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
#------------------------------------------------------------------------------

BEGIN { use lib 't'; require 'testlib.pl'; }

use Modern::Perl;

#------------------------------------------------------------------------------
# file.asm exists, give only stem
unlink("$test.i");
unlink("$test.o");
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E $test", <<END);
Preprocessing file: $test.asm -> $test.i
END

# file.o exists, give only stem
unlink("$test.i");
unlink("$test.asm");
spew("$test.o", "");
capture_ok("z88dk-z80asm -v -E $test", <<END);
Skipping preprocessing for object file: $test.o
END

# file.asm exists, give .asm
unlink("$test.i");
unlink("$test.o");
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# file.o exists, give .asm
unlink("$test.i");
unlink("$test.asm");
spew("$test.o", "");
capture_ok("z88dk-z80asm -v -E $test.o", <<END);
Skipping preprocessing for object file: $test.o
END

# file.asm exists, give .o
unlink("$test.i");
unlink("$test.o");
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E $test.o", <<END);
Preprocessing file: $test.asm -> $test.i
END

# file.o exists, give .o
unlink("$test.i");
unlink("$test.asm");
spew("$test.o", "");
capture_ok("z88dk-z80asm -v -E $test.asm", <<END);
Skipping preprocessing for object file: $test.o
END


#------------------------------------------------------------------------------
# same with .o in $test.dir
mkdir "$test.dir";
unlink("$test.asm");
unlink("$test.o");
unlink("$test.i");

# file.asm exists, give only stem
unlink("$test.i");
unlink("$test.dir/$test.o");
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E -O$test.dir $test", <<END);
Preprocessing file: $test.asm -> $test.i
END

# file.o exists, give only stem
unlink("$test.i");
unlink("$test.asm");
spew("$test.dir/$test.o", "");
capture_ok("z88dk-z80asm -v -E -O$test.dir $test", <<END);
Skipping preprocessing for object file: $test.dir/$test.o
END

# file.asm exists, give .asm
unlink("$test.i");
unlink("$test.dir/$test.o");
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E -O$test.dir $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# file.o exists, give .asm
unlink("$test.i");
unlink("$test.asm");
spew("$test.dir/$test.o", "");
capture_ok("z88dk-z80asm -v -E -O$test.dir $test.o", <<END);
Skipping preprocessing for object file: $test.dir/$test.o
END

# file.asm exists, give .o
unlink("$test.i");
unlink("$test.dir/$test.o");
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E -O$test.dir $test.o", <<END);
Preprocessing file: $test.asm -> $test.i
END

# file.o exists, give .o
unlink("$test.i");
unlink("$test.asm");
spew("$test.dir/$test.o", "");
capture_ok("z88dk-z80asm -v -E -O$test.dir $test.asm", <<END);
Skipping preprocessing for object file: $test.dir/$test.o
END


#------------------------------------------------------------------------------
# same with .asm in $test.dir
path("$test.dir")->remove_tree;
mkdir "$test.dir";
unlink("$test.asm");
unlink("$test.o");
unlink("$test.i");

# file.asm exists, give only stem
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.o");
spew("$test.dir/$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E -I$test.dir $test", <<END);
Preprocessing file: $test.dir/$test.asm -> $test.dir/$test.i
END

# file.o exists, give only stem
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.asm");
spew("$test.dir/$test.o", "");
capture_ok("z88dk-z80asm -v -E -I$test.dir $test", <<END);
Skipping preprocessing for object file: $test.dir/$test.o
END

# file.asm exists, give .asm
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.o");
spew("$test.dir/$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E -I$test.dir $test.asm", <<END);
Preprocessing file: $test.dir/$test.asm -> $test.dir/$test.i
END

# file.o exists, give .asm
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.asm");
spew("$test.dir/$test.o", "");
capture_ok("z88dk-z80asm -v -E -I$test.dir $test.o", <<END);
Skipping preprocessing for object file: $test.dir/$test.o
END

# file.asm exists, give .o
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.o");
spew("$test.dir/$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E -I$test.dir $test.o", <<END);
Preprocessing file: $test.dir/$test.asm -> $test.dir/$test.i
END

# file.o exists, give .o
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.asm");
spew("$test.dir/$test.o", "");
capture_ok("z88dk-z80asm -v -E -I$test.dir $test.asm", <<END);
Skipping preprocessing for object file: $test.dir/$test.o
END


#------------------------------------------------------------------------------
# both exist, .o is newer, option -d
# both exist, give only stem
unlink("$test.i");
spew("$test.asm", "nop");
sleep(1);
spew("$test.o", "");
capture_ok("z88dk-z80asm -v -E -d $test", <<END);
Skipping preprocessing for object file: $test.o
END

# file.asm exists, give .asm
unlink("$test.i");
spew("$test.asm", "nop");
sleep(1);
spew("$test.o", "");
capture_ok("z88dk-z80asm -v -E -d $test.asm", <<END);
Skipping preprocessing for object file: $test.o
END

# both exists, give .o
unlink("$test.i");
spew("$test.asm", "nop");
sleep(1);
spew("$test.o", "");
capture_ok("z88dk-z80asm -v -E -d $test.o", <<END);
Skipping preprocessing for object file: $test.o
END


#------------------------------------------------------------------------------
# both exist, .asm is newer, option -d
# both exist, give only stem
unlink("$test.i");
spew("$test.o", "");
sleep(1);
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E -d $test", <<END);
Preprocessing file: $test.asm -> $test.i
END

# file.asm exists, give .asm
unlink("$test.i");
spew("$test.o", "");
sleep(1);
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E -d $test.asm", <<END);
Preprocessing file: $test.asm -> $test.i
END

# both exists, give .o
unlink("$test.i");
spew("$test.o", "");
sleep(1);
spew("$test.asm", "nop");
capture_ok("z88dk-z80asm -v -E -d $test.o", <<END);
Preprocessing file: $test.asm -> $test.i
END

#------------------------------------------------------------------------------
# .asm.pl script: execute Perl to generate .asm, then preprocess .asm
#------------------------------------------------------------------------------

# Local script generates $test.asm
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.pl");
spew("$test.asm.pl", <<END);
print "nop\n";
END

capture_ok("z88dk-z80asm -v -E $test.asm.pl", <<END);
% perl  "$test.asm.pl" > "$test.asm"
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
nop
END

# Script located in include path (-I), generates $test.dir/$test.asm
path("$test.dir")->remove_tree if -d "$test.dir";
mkdir "$test.dir";
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.pl");
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.o");
unlink("$test.dir/$test.asm");
unlink("$test.dir/$test.asm.pl");
spew("$test.dir/$test.asm.pl", <<END);
print "nop\n";
END

capture_ok("z88dk-z80asm -v -E -I$test.dir $test.asm.pl", <<END);
% perl  "$test.dir/$test.asm.pl" > "$test.dir/$test.asm"
Preprocessing file: $test.dir/$test.asm -> $test.dir/$test.i
END

check_text_file("$test.dir/$test.i", <<END);
#line 1, "$test.dir/$test.asm"
nop
END

#------------------------------------------------------------------------------
# Passing -perl=opts: ensure options are forwarded to the perl invocation
#------------------------------------------------------------------------------

# Local .asm.pl script with perl options
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.pl");
spew("$test.asm.pl", <<END);
print "nop\\n";
END

# Use a sample perl option string (e.g., -w -Mstrict)
capture_ok("z88dk-z80asm -v -E -perl=-w -perl=-Mstrict $test.asm.pl", <<END);
% perl -w -Mstrict "$test.asm.pl" > "$test.asm"
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
nop
END

# .asm.pl in include path with perl options forwarded
path("$test.dir")->remove_tree if -d "$test.dir";
mkdir "$test.dir";
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.pl");
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.o");
unlink("$test.dir/$test.asm");
unlink("$test.dir/$test.asm.pl");

spew("$test.dir/$test.asm.pl", <<END);
print "nop\\n";
END

capture_ok("z88dk-z80asm -v -E -I$test.dir -perl=-w -perl=-Mstrict $test.asm.pl", <<END);
% perl -w -Mstrict "$test.dir/$test.asm.pl" > "$test.dir/$test.asm"
Preprocessing file: $test.dir/$test.asm -> $test.dir/$test.i
END

check_text_file("$test.dir/$test.i", <<END);
#line 1, "$test.dir/$test.asm"
nop
END

#------------------------------------------------------------------------------
# .asm.m4 script: run m4 to generate .asm, then preprocess .asm
#------------------------------------------------------------------------------

# Local m4 source generates $test.asm
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.m4");
spew("$test.asm.m4", <<END);
define(`OP', `nop')
OP
END

capture_ok("z88dk-z80asm -v -E $test.asm.m4", <<END);
% m4  "$test.asm.m4" > "$test.asm"
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 2, "$test.asm"
nop
END

# m4 source located in include path (-I), generates $test.dir/$test.asm
path("$test.dir")->remove_tree if -d "$test.dir";
mkdir "$test.dir";
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.m4");
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.o");
unlink("$test.dir/$test.asm");
unlink("$test.dir/$test.asm.m4");

spew("$test.dir/$test.asm.m4", <<END);
define(`OP', `nop')
OP
END

capture_ok("z88dk-z80asm -v -E -I$test.dir $test.asm.m4", <<END);
% m4  "$test.dir/$test.asm.m4" > "$test.dir/$test.asm"
Preprocessing file: $test.dir/$test.asm -> $test.dir/$test.i
END

check_text_file("$test.dir/$test.i", <<END);
#line 2, "$test.dir/$test.asm"
nop
END

#------------------------------------------------------------------------------
# Passing -m4=opts: ensure options are forwarded to the m4 invocation
#------------------------------------------------------------------------------

# Local .asm.m4 with macro provided via -m4 option
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.m4");
spew("$test.asm.m4", <<END);
OP
END

capture_ok("z88dk-z80asm -v -E -m4=-DOP=nop $test.asm.m4", <<END);
% m4 -DOP=nop "$test.asm.m4" > "$test.asm"
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
nop
END

# Multiple -m4 options are concatenated in order
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.m4");
spew("$test.asm.m4", <<END);
OP
END

capture_ok("z88dk-z80asm -v -E -m4=-DOP=nop -m4=-s $test.asm.m4", <<END);
% m4 -DOP=nop -s "$test.asm.m4" > "$test.asm"
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm.m4"
nop
END

# .asm.m4 in include path (-I) with m4 options forwarded
path("$test.dir")->remove_tree if -d "$test.dir";
mkdir "$test.dir";
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.m4");
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.o");
unlink("$test.dir/$test.asm");
unlink("$test.dir/$test.asm.m4");

spew("$test.dir/$test.asm.m4", <<END);
OP
END

capture_ok("z88dk-z80asm -v -E -I$test.dir -m4=-DOP=nop $test.asm.m4", <<END);
% m4 -DOP=nop "$test.dir/$test.asm.m4" > "$test.dir/$test.asm"
Preprocessing file: $test.dir/$test.asm -> $test.dir/$test.i
END

check_text_file("$test.dir/$test.i", <<END);
#line 1, "$test.dir/$test.asm"
nop
END

#------------------------------------------------------------------------------
# .asm.cpp source: run cpp to generate .asm, then preprocess .asm
#------------------------------------------------------------------------------

unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.cpp");
spew("$test.asm.cpp", <<END);
#define OP nop
OP
END

capture_ok("z88dk-z80asm -v -E $test.asm.cpp", <<END);
% cpp  "$test.asm.cpp" > "$test.asm"
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 2, "$test.asm.cpp"
nop
END

#------------------------------------------------------------------------------
# .asm.cpp in include path (-I): run cpp to generate .asm, then preprocess .asm
#------------------------------------------------------------------------------

path("$test.dir")->remove_tree if -d "$test.dir";
mkdir "$test.dir";
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.cpp");
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.o");
unlink("$test.dir/$test.asm");
unlink("$test.dir/$test.asm.cpp");

spew("$test.dir/$test.asm.cpp", <<END);
#define OP nop
OP
END

capture_ok("z88dk-z80asm -v -E -I$test.dir $test.asm.cpp", <<END);
% cpp  "$test.dir/$test.asm.cpp" > "$test.dir/$test.asm"
Preprocessing file: $test.dir/$test.asm -> $test.dir/$test.i
END

check_text_file("$test.dir/$test.i", <<END);
#line 2, "$test.dir/$test.asm.cpp"
nop
END

#------------------------------------------------------------------------------
# Passing -cpp=opts: ensure options are forwarded to the cpp invocation
#------------------------------------------------------------------------------

# Local .asm.cpp with macro provided via -cpp option
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.cpp");
spew("$test.asm.cpp", <<END);
OP
END

capture_ok("z88dk-z80asm -v -E -cpp=-DOP=nop $test.asm.cpp", <<END);
% cpp -DOP=nop "$test.asm.cpp" > "$test.asm"
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm.cpp"
nop
END

# Multiple -cpp options are concatenated in order
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.cpp");
spew("$test.asm.cpp", <<END);
OP
END

capture_ok("z88dk-z80asm -v -E -cpp=-DOP=nop -cpp=-DOTHER=1 $test.asm.cpp", <<END);
% cpp -DOP=nop -DOTHER=1 "$test.asm.cpp" > "$test.asm"
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm.cpp"
nop
END

# .asm.cpp in include path (-I) with cpp options forwarded
path("$test.dir")->remove_tree if -d "$test.dir";
mkdir "$test.dir";
unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.asm.cpp");
unlink("$test.dir/$test.i");
unlink("$test.dir/$test.o");
unlink("$test.dir/$test.asm");
unlink("$test.dir/$test.asm.cpp");

spew("$test.dir/$test.asm.cpp", <<END);
OP
END

capture_ok("z88dk-z80asm -v -E -I$test.dir -cpp=-DOP=nop $test.asm.cpp", <<END);
% cpp -DOP=nop "$test.dir/$test.asm.cpp" > "$test.dir/$test.asm"
Preprocessing file: $test.dir/$test.asm -> $test.dir/$test.i
END

check_text_file("$test.dir/$test.i", <<END);
#line 1, "$test.dir/$test.asm.cpp"
nop
END

#------------------------------------------------------------------------------
# cleanup
#------------------------------------------------------------------------------
path("$test.dir")->remove_tree if Test::More->builder->is_passing;
unlink_testfiles if Test::More->builder->is_passing;
done_testing;
