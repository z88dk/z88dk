//-----------------------------------------------------------------------------
// z80asm
// Options
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "options.h"

using namespace std;

Options* g_options{ nullptr };

void Options::add_input_file(const string& filename) {
    m_input_files.push_back(filename);
}
