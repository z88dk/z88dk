//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "test.h"
#include <cassert>
#include <exception>
#include <fstream>
#include <iostream>
#include <regex>
using namespace std;

int test_count_run = 0;
int test_count_failed = 0;
string test_exec_out;
string test_exec_err;
static char* prog_name = nullptr;

static void print_summary() {
    cout << "1.." << test_count_run << endl;

    if (test_count_failed)
        cout << "Failed " << test_count_failed << " test"
             << (test_count_failed > 1 ? "s" : "") << " of " << test_count_run << endl;
    else
        cout << "All tests successful." << endl;
}

static string normalize_eol(const string& text) {
    string out;
    out.reserve(text.length());

    for (const char* p = text.c_str(); *p; ++p) {
        if (*p == '\r') {
            out += '\n';

            if (p[1] == '\n')
                p++;
        }
        else {
            out += *p;
		}
    }

    return out;
}

void test_str_is(const string& a, const string& b, 
			     const string& filename, int line_nr) {
	test_is(normalize_eol(a), normalize_eol(b), filename, line_nr);
}

void test_str_like(const string& str_, const string& pattern_, 
  				   const string& filename, int line_nr) {
    test_count_run++;

	string str = normalize_eol(str_);
	regex pattern{ pattern_ };
	
	if (regex_match(str, pattern)) {
		test_passed_diag();
	}
	else {
        test_failed_diag(str, pattern_, filename, line_nr);
        test_count_failed++;
    }
	
}

string test_file_slurp(const string& filename) {
    ifstream ifs(filename, ios::binary);

    if (!ifs.good()) {
        perror(filename.c_str());
        exit(EXIT_FAILURE);
    }

    // get length of file:
    ifs.seekg(0, ifs.end);
    size_t size = static_cast<size_t>(ifs.tellg());
    ifs.seekg(0, ifs.beg);

    // read in whole file
    string text;
    text.resize(size);

    if (!ifs.read(&text[0], size)) {
        perror(filename.c_str());	// not reached unless read fails
        exit(EXIT_FAILURE);
    }

    return text;
}

void test_file_spew(const string& filename, const string& text) {
    ofstream ofs(filename, ios::binary);

    if (!ofs.good()) {
        perror(filename.c_str());
        exit(EXIT_FAILURE);
    }

    if (!ofs.write(&text[0], text.size())) {
        perror(filename.c_str());	// not reached unless write fails
        exit(EXIT_FAILURE);
    }
}

void test_file_write(const string& filename, const byte_t* mem, size_t size) {
    ofstream ofs(filename, ios::binary);

    if (!ofs.good()) {
        perror(filename.c_str());
        exit(EXIT_FAILURE);
    }

    if (!ofs.write((const char*) & mem[0], size)) {
        perror(filename.c_str());	// not reached unless write fails
        exit(EXIT_FAILURE);
    }
}

static string slurp_remove(const string& filename) {
    string text = test_file_slurp(filename);
    OK(0 == remove(filename.c_str()));

    return text;
}

static bool test_exec_(bool has_arg, const string& test_name, const string& arg = "") {
    assert(prog_name);

    test_exec_out.clear();
    test_exec_err.clear();

    int test_id = rand();
    string out = string("test") + to_string(test_id) + ".out";
    string err = string("test") + to_string(test_id) + ".err";

    string cmd = string(prog_name) + " " + test_name;
    if (has_arg)
        cmd += " \"" + arg + "\"";
    cmd += " > " + out + " 2> " + err;
    DIAG(cmd);
    int rv = system(cmd.c_str());

    test_exec_out = normalize_eol(slurp_remove(out));
    test_exec_err = normalize_eol(slurp_remove(err));

    if (rv == 0)
        return true;
    else
        return false;
}

bool test_exec(const string& test_name) {
    return test_exec_(false, test_name);
}

bool test_exec(const string& test_name, const string& arg) {
    return test_exec_(true, test_name, arg);
}

int main(int argc, char* argv[]) {
    srand(static_cast<int>(time(NULL)));
    prog_name = argv[0];

    if (argc == 2) {				// sub-test
        string test = argv[1];
#define EXEC_TEST 1
#include "test.def"
#undef EXEC_TEST

        return EXIT_FAILURE;		// should not be reached
    }
    else if (argc == 3) {
        string test = argv[1];
        string arg = argv[2];
#define EXEC_TEST 2
#include "test.def"
#undef EXEC_TEST

        return EXIT_FAILURE;		// should not be reached
    }
    else if (argc == 1) {			// main test
        try {
#define EXEC_TEST 0
#include "test.def"
#undef EXEC_TEST
            PASS();
        }
        catch (exception& e) {
            FAIL();
            DIAG(e.what());
        }
    }
    else {
        DIAG("too many arguments");
        FAIL();
    }

    print_summary();

    if (!test_count_failed)
        return EXIT_SUCCESS;
    else
        return EXIT_FAILURE;
}
