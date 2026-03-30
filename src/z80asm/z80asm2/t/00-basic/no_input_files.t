BEGIN { use lib 't'; require 'testlib.pl'; }

# no input files error if options are supplied but no files
capture_nok("z88dk-z80asm -v -d", "t/00-basic/expected/no_input_files.txt");

unlink_testfiles;
done_testing;
