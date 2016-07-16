//-----------------------------------------------------------------------------
// Dummy module test
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifndef TEST_HPP
#define TEST_HPP

#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <file_system.hpp>

#include <tap++/tap++.h>
using namespace TAP;

// call assertions with test location
#define OK(a)		ok(a,		src_location(__FILE__, __LINE__))
#define NOT_OK(a)	not_ok(a,	src_location(__FILE__, __LINE__))
#define PASS()		pass(		src_location(__FILE__, __LINE__))
#define FAIL()		fail(		src_location(__FILE__, __LINE__))
#define SKIP()		skip(		src_location(__FILE__, __LINE__))
#define BAIL_OUT()	bail_out(	src_location(__FILE__, __LINE__))
#define IS(a,b)		is(a,b,		src_location(__FILE__, __LINE__))
#define ISNT(a,b)	isnt(a,b,	src_location(__FILE__, __LINE__))

// test location
inline std::string src_location(const char *file, int line)
{
	std::ostringstream out;
	out << file << ':' << line;
	return out.str();
}

// create test file
inline void create_test_file(const char *filename, const char *text)
{
	std::ofstream file(filename, std::ios::binary);
	OK(file.good());
	file << text;
	file.close();
}

// delete test file
inline void delete_test_file(const char *filename)
{
	if (stlplus::file_exists(filename) && !stlplus::file_delete(filename))
		FAIL();
}

// remove OS error from exception string
inline std::string remove_os_error(std::string what)
{
	std::string prefix = "OS error: ";

	std::size_t p1 = what.find(prefix);
	if (p1 != std::string::npos) {
		p1 += prefix.size();

		std::size_t p2 = what.find("\n", p1);
		if (p2 != std::string::npos) {
			std::string os_error = what.substr(p1, p2 - p1);
			note(os_error);
			what.replace(p1, p2 - p1, "???");
		}
	}
	return what;
}

#endif /* ndef TEST_HPP */
