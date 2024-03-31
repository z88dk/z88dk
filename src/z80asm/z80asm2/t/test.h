//-----------------------------------------------------------------------------
// unit tests
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include <iostream>
#include <sstream>
#include <string>
using namespace std;

// TAP-compliant test
extern int utests_failed_nr;
extern int utests_test_nr;
extern string utests_progname;
extern string utests_out;
extern string utests_err;

#define DIAG(out) cout << "# " << out << endl
#define _OK(cond, has_diag, diag) \
    do { \
        if (cond) \
            cout << "ok " << (++utests_test_nr) << endl; \
        else { \
            utests_failed_nr++; \
            cout << "not ok " << (++utests_test_nr) << endl; \
            DIAG("  Failed test at " << __FILE__ << " line " << __LINE__ << "."); \
            if (has_diag) DIAG(diag); \
        } \
    } while(0)

#define OK(cond)        _OK((cond),     0, "")
#define NOK(cond)       _OK(!(cond),    0, "")
#define IS(a, b)        _OK((a) == (b), 1, "'" << a << "' == '" << b << "'")
#define ISNT(a, b)      _OK((a) != (b), 1, "'" << a << "' != '" << b << "'")
#define PASS()          _OK(true,       0, "")
#define FAIL()          _OK(false,      0, "")
#define RUN_OK(func)    OK(run_exec_test(#func))
#define RUN_NOK(func)   NOK(run_exec_test(#func))
#define OUT_IS(a)       IS((a), (utests_out))
#define ERR_IS(a)       IS((a), (utests_err))

void start_testing(const string& progname);
void done_testing();
bool run_exec_test(const string & funcname);
void test_spew(const string & filename, const string & text);
string test_slurp(const string & filename);
