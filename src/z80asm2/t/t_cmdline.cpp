//-----------------------------------------------------------------------------
// Dummy module test
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "test.hpp"
#include "cmdline.hpp"
#include "global.hpp"

// test execution without errors; test errors in cmdline.t
int main() 
{
	char *argv[] = { (char*)"exe", (char*)"f0.asm", (char*)"@test.4", (char*)"f9.asm" };
	args_t args;
	
	create_test_file("test.1",		// all new-line types
					"f1.asm\n"
					"f2.asm\r"
					"f3.asm\r\n");
	create_test_file("test.2",		// comments
					"; comment 1\n"
					"\n"
					"# comment 2\n"
					"\n"
					"f4.asm");		// missing new-line
	create_test_file("test.3",		// recurse
					"@test.1\n"
					"f5.asm\n"
					"@test.2\n"
					"f6.asm\n");
	create_test_file("test.4",		// recurse
					"f7.asm\n"
					"@test.3\n"
					"f8.asm\n");
	
	OK(parse_cmdline(sizeof(argv)/sizeof(argv[0]), argv, args));
	IS(args.files.size(), 10);
	IS(args.files[0], "f0.asm");
	IS(args.files[1], "f7.asm");
	IS(args.files[2], "f1.asm");
	IS(args.files[3], "f2.asm");
	IS(args.files[4], "f3.asm");
	IS(args.files[5], "f5.asm");
	IS(args.files[6], "f4.asm");
	IS(args.files[7], "f6.asm");
	IS(args.files[8], "f8.asm");
	IS(args.files[9], "f9.asm");

	delete_test_file("test.1");
	delete_test_file("test.2");
	delete_test_file("test.3");
	delete_test_file("test.4");

	done_testing();
	return exit_status();
}
