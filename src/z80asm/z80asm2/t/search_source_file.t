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
# '@' list files: expand recursively, ignore blank and comment lines
#------------------------------------------------------------------------------

# Simple list: includes two .asm files; list contains blanks and comments
unlink("$test.i"); unlink("$test.o");
unlink("$test.a1.asm"); unlink("$test.a2.asm");
unlink("$test.lst");

spew("$test.a1.asm", "nop");
spew("$test.a2.asm", "nop");
spew("$test.lst", <<END);
; top comment
# another comment

$test.a1.asm
$test.a2       ; no extension, resolve to .asm
END

capture_ok("z88dk-z80asm -v -E \"\@$test.lst\"", <<END);
Preprocessing file: $test.a1.asm -> $test.a1.i
Preprocessing file: $test.a2.asm -> $test.a2.i
END

check_text_file("$test.a1.i", <<END);
#line 1, "$test.a1.asm"
nop
END

check_text_file("$test.a2.i", <<END);
#line 1, "$test.a2.asm"
nop
END

# Nested lists: list2 includes list3 via '@' and a direct asm
unlink("$test.i"); unlink("$test.o");
unlink("$test.a3.asm");
unlink("$test.list2"); unlink("$test.list3");

spew("$test.a3.asm", "nop");
spew("$test.list3", <<END);
; nested comment
$test.a3.asm
END

spew("$test.list2", <<END);
# outer comment
\@$test.list3
END

capture_ok("z88dk-z80asm -v -E \"\@$test.list2\"", <<END);
Preprocessing file: $test.a3.asm -> $test.a3.i
END

check_text_file("$test.a3.i", <<END);
#line 1, "$test.a3.asm"
nop
END

# List file found via -I include path; referenced asm in same directory
path("$test.dir")->remove_tree if -d "$test.dir";
mkdir "$test.dir";
unlink("$test.dir/$test.linc.asm");
unlink("$test.dir/$test.linc.lst");
unlink("$test.dir/$test.linc.i");

spew("$test.dir/$test.linc.asm", "nop");
spew("$test.dir/$test.linc.lst", <<END);
$test.dir/$test.linc.asm
END

capture_ok("z88dk-z80asm -v -E -I. \"\@$test.dir/$test.linc.lst\"", <<END);
Preprocessing file: $test.dir/$test.linc.asm -> $test.dir/$test.linc.i
END

check_text_file("$test.dir/$test.linc.i", <<END);
#line 1, "$test.dir/$test.linc.asm"
nop
END

#------------------------------------------------------------------------------
# Wildcard matching: *, ?, and ** (recursive directories)
#------------------------------------------------------------------------------

# Setup a directory tree with files
path("$test.dir")->remove_tree if -d "$test.dir";
mkdir "$test.dir";
mkdir "$test.dir/sub1";
mkdir "$test.dir/sub1/deeper";
mkdir "$test.dir/sub2";

# Create asm sources in various places
unlink("$test.i");
unlink("$test.o");
spew("$test.dir/a1.asm", "nop");
spew("$test.dir/a2.asm", "nop");
spew("$test.dir/bX.asm", "nop");
spew("$test.dir/sub1/c1.asm", "nop");
spew("$test.dir/sub1/deeper/d1.asm", "nop");
spew("$test.dir/sub2/e2.asm", "nop");

# 1) '*' matches any number of chars in a single path component
capture_ok("z88dk-z80asm -v -E \"$test.dir/*.asm\"", <<END);
Preprocessing file: $test.dir/a1.asm -> $test.dir/a1.i
Preprocessing file: $test.dir/a2.asm -> $test.dir/a2.i
Preprocessing file: $test.dir/bX.asm -> $test.dir/bX.i
END

check_text_file("$test.dir/a1.i", <<END);
#line 1, "$test.dir/a1.asm"
nop
END
check_text_file("$test.dir/a2.i", <<END);
#line 1, "$test.dir/a2.asm"
nop
END
check_text_file("$test.dir/bX.i", <<END);
#line 1, "$test.dir/bX.asm"
nop
END

# 2) '?' matches a single character
capture_ok("z88dk-z80asm -v -E \"$test.dir/b?.asm\"", <<END);
Preprocessing file: $test.dir/bX.asm -> $test.dir/bX.i
END

# 3) '**' matches subdirectories recursively
capture_ok("z88dk-z80asm -v -E \"$test.dir/**/c1.asm\"", <<END);
Preprocessing file: $test.dir/sub1/c1.asm -> $test.dir/sub1/c1.i
END
check_text_file("$test.dir/sub1/c1.i", <<END);
#line 1, "$test.dir/sub1/c1.asm"
nop
END

# 4) '**' combined with '*.asm' to collect many files across subdirs
capture_ok("z88dk-z80asm -v -E \"$test.dir/**/*.asm\"", <<END);
Preprocessing file: $test.dir/a1.asm -> $test.dir/a1.i
Preprocessing file: $test.dir/a2.asm -> $test.dir/a2.i
Preprocessing file: $test.dir/bX.asm -> $test.dir/bX.i
Preprocessing file: $test.dir/sub1/c1.asm -> $test.dir/sub1/c1.i
Preprocessing file: $test.dir/sub1/deeper/d1.asm -> $test.dir/sub1/deeper/d1.i
Preprocessing file: $test.dir/sub2/e2.asm -> $test.dir/sub2/e2.i
END

# Sanity checks for a couple of recursive outputs
check_text_file("$test.dir/sub1/deeper/d1.i", <<END);
#line 1, "$test.dir/sub1/deeper/d1.asm"
nop
END
check_text_file("$test.dir/sub2/e2.i", <<END);
#line 1, "$test.dir/sub2/e2.asm"
nop
END

# 5) Wildcards together with -I include path: pattern resolved from include dir
unlink(<$test.*>);
path("$test.dir2")->remove_tree if -d "$test.dir2";
mkdir "$test.dir2";
spew("$test.dir2/x1.asm", "nop");
spew("$test.dir2/y2.asm", "nop");

capture_ok("z88dk-z80asm -v -E -I$test.dir2 \"*.asm\"", <<END);
Preprocessing file: $test.dir2/x1.asm -> $test.dir2/x1.i
Preprocessing file: $test.dir2/y2.asm -> $test.dir2/y2.i
END

check_text_file("$test.dir2/x1.i", <<END);
#line 1, "$test.dir2/x1.asm"
nop
END
check_text_file("$test.dir2/y2.i", <<END);
#line 1, "$test.dir2/y2.asm"
nop
END

#------------------------------------------------------------------------------
# List file with environment variable reference ${TEST} expands and preprocesses
#------------------------------------------------------------------------------

# Prepare: set TEST environment to $test, create list and target asm
$ENV{TEST} = $test;

unlink("$test.i");
unlink("$test.o");
unlink("$test.asm");
unlink("$test.lst");

# The list file references ${TEST}.asm which should expand to $test.asm
spew("$test.lst", <<END);
\${TEST}.asm
END

# Create the referenced asm file
spew("$test.asm", "nop\n");

capture_ok("z88dk-z80asm -v -E \"\@$test.lst\"", <<END);
Preprocessing file: $test.asm -> $test.i
END

check_text_file("$test.i", <<END);
#line 1, "$test.asm"
nop
END

#------------------------------------------------------------------------------
# cleanup
#------------------------------------------------------------------------------
path("$test.dir")->remove_tree if Test::More->builder->is_passing;
path("$test.dir2")->remove_tree if Test::More->builder->is_passing;
unlink_testfiles if Test::More->builder->is_passing;
done_testing;
