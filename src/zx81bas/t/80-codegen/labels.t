BEGIN { use lib 't'; require 'testlib.pl'; }

test_zx81bas( "", 7, 14 );

unlink_testfiles;
done_testing;
