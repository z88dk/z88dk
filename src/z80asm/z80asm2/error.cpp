//-----------------------------------------------------------------------------
// z80asm
// Error message output and counting
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "error.h"
#include "location.h"
#include <iostream>
using namespace std;

Error* g_error{ nullptr };

void Error::error(const string& message, const string& arg) {
    m_count++;
    output_message("error", message, arg);
}

void Error::warning(const string& message, const string& arg) {
    output_message("warning", message, arg);
}

void Error::output_message(const string& prefix, const string& message, const string& arg) {
    if (!g_location->empty())
        cerr << g_location->filename() << ":" << g_location->line_num() << ": ";
    cerr << prefix << ": " << message;
    if (!arg.empty())
        cerr << ": " << arg;
    cerr << endl;
    if (!g_location->text().empty()) {
        cerr << "  ^---- " << g_location->text() << endl;
        if (!g_location->expanded_text().empty())
            cerr << "    ^---- " << g_location->expanded_text() << endl;
    }
}

