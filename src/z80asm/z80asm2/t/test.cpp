//-----------------------------------------------------------------------------
// unit tests
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "test.h"
#include <cassert>
#include <iostream>
#include <fstream>
using namespace std;

int utests_failed_nr = 0;
int utests_test_nr = 0;
string utests_progname = "test";
string utests_out;
string utests_err;

static string read_file(const string& filename);

void start_testing(const string& progname) {
    utests_progname = progname;
}

void done_testing() {
    cout << "1.." << utests_test_nr << endl;
    if (utests_failed_nr == 0) 
        exit(EXIT_SUCCESS);
    else {
        DIAG("Looks like you failed " << utests_failed_nr << " test" << 
             (utests_failed_nr > 1 ? "s" : "") << " of " << utests_test_nr << ".");
        exit(EXIT_FAILURE);
    }
}

bool run_exec_test(const string& funcname) {
    string base_filename = string("test") + std::to_string(rand());
    string out_filename = base_filename + ".out";
    string err_filename = base_filename + ".err";
    string command = utests_progname + " " + funcname + " > " + out_filename + " 2> " + err_filename;
    int rv = system(command.c_str());
    utests_out = read_file(out_filename);
    remove(out_filename.c_str());
    utests_err = read_file(err_filename);
    remove(err_filename.c_str());
    return rv == 0;
}

static string read_file(const string& filename) {
    string out;
    ifstream ifs(filename);
    if (ifs.is_open()) {
        string line;
        while (!getline(ifs, line).eof())
            out += line + "\n";
    }
    return out;
}
