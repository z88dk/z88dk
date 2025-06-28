//-----------------------------------------------------------------------------
// z80asm
// Options
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "options.h"
#include "utils.h"
using namespace std;

Options* g_options{ nullptr };

void Options::add_input_file(const string& filename) {
    m_input_files.push_back(sanitize_pathname(filename));
}

void Options::set_origin(int origin) {
    if (origin < 0)
        g_error->error_int_range(int_to_hex(origin, 4));
    else
        m_origin = origin;
}
