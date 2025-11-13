#------------------------------------------------------------------------------
# Z80 assembler
# Copyright (C) Paulo Custodio, 2011-2025
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

path("$test.dir")->remove_tree if Test::More->builder->is_passing;
unlink_testfiles if Test::More->builder->is_passing;
done_testing;
