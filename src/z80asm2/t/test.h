//-----------------------------------------------------------------------------
// Module tests with libtappp
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include <tap++/tap++.h>
#include <sys/stat.h>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <cstdio>

using namespace TAP;

// FILE_LINE macro that expands to a string, to passed as argument to ok(), etc.
inline std::string _file_line(const char *file, int line)
{
	std::ostringstream out;
	out << file << ':' << line;
	return out.str();
}
#define FILE_LINE() _file_line(__FILE__,__LINE__)

// call assertions with test location
#define OK(a)		ok(a,		_file_line(__FILE__, __LINE__))
#define NOT_OK(a)	not_ok(a,	_file_line(__FILE__, __LINE__))
#define PASS()		pass(		_file_line(__FILE__, __LINE__))
#define FAIL()		fail(		_file_line(__FILE__, __LINE__))
#define SKIP()		skip(		_file_line(__FILE__, __LINE__))
#define BAIL_OUT()	bail_out(	_file_line(__FILE__, __LINE__))
#define IS(a,b)		is(a,b,		_file_line(__FILE__, __LINE__))
#define ISNT(a,b)	isnt(a,b,	_file_line(__FILE__, __LINE__))

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
	struct stat status;
	if (stat(filename, &status) == 0)		// file exists
		if (std::remove(filename) != 0)		// remove failed
			FAIL();
}
