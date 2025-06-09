//-----------------------------------------------------------------------------
// z80asm
// Options
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <vector>
using namespace std;

class Options {
public:
    const string& progname() const { return m_progname; }
    void set_progname(const string& progname) { m_progname = progname; }

    void add_input_file(const string& filename);
    const vector<string>& input_files() const { return m_input_files; }

    bool verbose() const { return m_verbose; }
    void set_verbose(bool f = true) { m_verbose = f; }

    bool preproc_only() const { return m_preproc_only; }
    void set_preproc_only(bool f = true) { m_preproc_only = f; }

private:
    string m_progname;
    vector<string> m_input_files;
    bool m_verbose{ false };
    bool m_preproc_only{ false };
};

extern Options* g_options;
