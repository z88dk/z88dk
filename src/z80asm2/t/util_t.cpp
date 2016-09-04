//-----------------------------------------------------------------------------
// Test util.cpp
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "test.h"
#include "util.h"

#define T_CREATE(data) \
		create_test_file("test.1", data); \
		file.open("test.1", std::ios::in | std::ios::binary); \
		OK(file.good())

#define T_READ(text) \
		OK(safeGetline(file, line).good()); IS(line, text)

#define T_EOF() \
		OK(!safeGetline(file, line).good()); IS(line, ""); \
		OK(!safeGetline(file, line).good()); IS(line, ""); \
		OK(!safeGetline(file, line).good()); IS(line, "")

#define T_DELETE() \
	OK(file.eof()); \
	file.close(); \
	delete_test_file("test.1")

void test_safeGetline()
{
	std::string line;
	std::ifstream file;

	// empty file
	T_CREATE("");
	T_EOF();
	T_DELETE();

	// file with all new-line types, plus invalid LF-CR
	T_CREATE("f1.asm\n"
			 "f2.asm\r"
			 "f3.asm\r\n"
			 "f4.asm\n\r"
			 "f5.asm");

	T_READ("f1.asm");
	T_READ("f2.asm");
	T_READ("f3.asm");
	T_READ("f4.asm");
	T_READ("");
	T_READ("f5.asm");
	T_EOF();
	T_DELETE();

	// end file in all new-line types, plus invalid LF-CR
	T_CREATE("f1.asm"); T_READ("f1.asm"); T_EOF(); T_DELETE();
	T_CREATE("f1.asm\n"); T_READ("f1.asm"); T_EOF(); T_DELETE();
	T_CREATE("f1.asm\r"); T_READ("f1.asm"); T_EOF(); T_DELETE();
	T_CREATE("f1.asm\r\n"); T_READ("f1.asm"); T_EOF(); T_DELETE();
	T_CREATE("f1.asm\n\r"); T_READ("f1.asm"); T_READ(""); T_EOF(); T_DELETE();
}

#undef T_CREATE
#undef T_READ
#undef T_EOF
#undef T_DELETE

void test_file_exists()
{
	delete_test_file("test.1");
	OK(!file_exists("test.1"));
	create_test_file("test.1", "");
	OK(file_exists("test.1"));
	delete_test_file("test.1");
	OK(!file_exists("test.1"));
}

int main()
{
	test_safeGetline();
	test_file_exists();
	
	done_testing();
	return exit_status();
}
