//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <iostream>
#include <string>
#include <cinttypes>
using namespace std;

typedef uint8_t byte_t;

#define DIAG(out)	    cout << "# " << out << endl
#define OK(x)		    test_is((x), true, __FILE__, __LINE__)
#define NOK(x)          test_is((x), false, __FILE__, __LINE__)
#define IS(a, b)	    test_is((a), (b), __FILE__, __LINE__)
#define ISNT(a, b)	    test_isnt((a), (b), __FILE__, __LINE__)
#define STR_IS(a, b)    test_str_is((a), (b), __FILE__, __LINE__)
#define STR_LIKE(a, b)  test_str_like((a), (b), __FILE__, __LINE__)
#define RUN_OK(...)     OK(test_exec(__VA_ARGS__))
#define RUN_NOK(...)    NOK(test_exec(__VA_ARGS__))
#define PASS()          OK(true)
#define FAIL()          OK(false)

extern int test_count_run;
extern int test_count_failed;
extern string test_exec_out;
extern string test_exec_err;

void test_str_is(const string& a, const string& b, 
			     const string& filename, int line_nr);
void test_str_like(const string& str, const string& pattern, 
				   const string& filename, int line_nr);
bool test_exec(const string& test_name);
bool test_exec(const string& test_name, const string& arg);

string test_file_slurp(const string& filename);
void   test_file_spew(const string& filename, const string& text);
void   test_file_write(const string& filename, const byte_t* mem, size_t size);

inline void test_passed_diag() {
	cout << "ok " << test_count_run << endl;
}

template<class T>
void test_failed_diag(T got, T expected, const string& filename, int line_nr) {
	cout << "not ok " << test_count_run << endl;
	DIAG("Failed test at " << filename << " line " << line_nr);
	DIAG("got:      '" << got << "'");
	DIAG("expected: '" << expected << "'");
}

template<class T>
void test_is(T got, T expected, const string& filename, int line_nr) {
    test_count_run++;

	if (got == expected) {
		test_passed_diag();
	}
	else {
        test_failed_diag(got, expected, filename, line_nr);
        test_count_failed++;
    }
}

template<class T>
void test_isnt(T got, T expected, const string& filename, int line_nr) {
    test_count_run++;

	if (got != expected) {
		test_passed_diag();
	}
	else {
        test_failed_diag(got, expected, filename, line_nr);
        test_count_failed++;
    }
}
