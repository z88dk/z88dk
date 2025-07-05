//-----------------------------------------------------------------------------
// z80asm
// Macro preprocessor
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "scanner.h"
#include <deque>
#include <string>
using namespace std;

class Preproc {
public:
    void clear();
    void expand(const string& input_line);
    bool getline(string& line);
    string autolabel();

    static void preproc_only(const string& filename);

private:
    deque<string> m_expanded_lines;
    Scanner m_in;
    Scanner m_out;
    int m_autolabel_id{ 1 };

    void expand_macros();
    void collect_statement();
    void push_out();
    void check_end();
};

extern Preproc* g_preproc;

