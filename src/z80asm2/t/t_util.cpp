//-----------------------------------------------------------------------------
// Dummy module test
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "test.hpp"
#include "util.hpp"
#include "string_utilities.hpp"

#define T_CREATE(data) \
		create_test_file("test.1", data); \
		file.open("test.1", std::ios::in | std::ios::binary); \
		OK(file.good())

#define T_READ(text) \
		OK(safeGetline(file, line).good()); IS(line, text)

#define T_EOF() \
		OK(!safeGetline(file, line).good()); IS(line, "")

#define T_DELETE() \
	OK(file.eof()); \
	file.close(); \
	delete_test_file("test.1")

void test_safeGetline()
{
	std::string line;
	std::ifstream file;

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
	T_EOF();
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

#define T_CREATE_FOLDER(dir) \
	OK(stlplus::folder_exists(dir) || stlplus::folder_create(dir))

#define T_SEARCH(file, path, expected) \
		result = file_lookup(file, path); \
		result = stlplus::translate(result, "\\", "/"); \
		IS(result, expected)

void test_file_lookup()
{
	std::string result;
	
	// create directories and files
	T_CREATE_FOLDER("test.x1");
	T_CREATE_FOLDER("test.x2");
	T_CREATE_FOLDER("test.x3");
	T_CREATE_FOLDER("test.x3/inc");
	
	create_test_file("test.f0", "");
	create_test_file("test.x1/test.f0", "");
	create_test_file("test.x1/test.f1", "");
	create_test_file("test.x2/test.f1", "");
	create_test_file("test.x2/test.f2", "");
	create_test_file("test.x3/test.f2", "");
	create_test_file("test.x3/test.f3", "");
	create_test_file("test.x3/inc/inc.1", "");
	
	// setup seach path
	std::vector<std::string> empty_path;
	std::vector<std::string> path;
	path.push_back("test.x1");
	path.push_back("test.x2");
	path.push_back("test.x3");
	
	T_SEARCH("test.f0", empty_path, "test.f0");
	T_SEARCH("test.f1", empty_path, "test.f1");
	T_SEARCH("test.f2", empty_path, "test.f2");
	T_SEARCH("test.f3", empty_path, "test.f3");
	T_SEARCH("test.f4", empty_path, "test.f4");
	T_SEARCH("inc/inc.1", empty_path, "inc/inc.1");
	T_SEARCH("test.f0", path, "test.f0");
	T_SEARCH("test.f1", path, "test.x1/test.f1");
	T_SEARCH("test.f2", path, "test.x2/test.f2");
	T_SEARCH("test.f3", path, "test.x3/test.f3");
	T_SEARCH("test.f4", path, "test.f4");
	T_SEARCH("inc/inc.1", path, "test.x3/inc/inc.1");

	OK(stlplus::folder_delete("test.x1", true));
	OK(stlplus::folder_delete("test.x2", true));
	OK(stlplus::folder_delete("test.x3", true));
	delete_test_file("test.f0");
}

int main() 
{
	test_safeGetline();
	test_file_lookup();
	
	done_testing();
	return exit_status();
}
