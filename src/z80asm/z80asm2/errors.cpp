//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "source_file.h"
#include "source_loc.h"
#include "string_interner.h"
#include "string_utils.h"
#include <iostream>
#include <string_view>

static size_t error_count_ = 0;

size_t error_count() {
    return error_count_;
}

static void print_source_line(std::string_view text, size_t column) {
    std::cerr << "    " << text << std::endl;

    if (column == 0) {
        return;
    }

    std::string marker;
    marker.reserve(column);

    for (size_t i = 0; i < column - 1; i++) {
        if (i < text.size() && is_space(text[i])) {
            marker += text[i];
        }
        else {
            marker += ' ';
        }
    }

    marker += '^';
    std::cerr << "    " << marker << std::endl;
}

static void print_message(const SourceLoc& loc,
                          std::string_view level,
                          std::string_view msg) {
    if (!loc.empty()) {
        std::cerr << loc.to_string() << ": ";
    }

    std::cerr << level << ": " << msg << std::endl;

    if (loc.empty()) {
        return;
    }

    std::string_view filename = g_strings.view(loc.file_id);
    if (filename.empty() || filename[0] == '<') {
        // no filename or special filename (e.g. <command line>)
        return;
    }

    std::string text = get_source_line(filename, loc.line);
    if (!text.empty()) {
        print_source_line(text, loc.column);
    }
}

void error(const SourceLoc& loc, std::string_view msg) {
    error_count_++;
    print_message(loc, "error", msg);
}

void warning(const SourceLoc& loc, std::string_view msg) {
    print_message(loc, "warning", msg);
}

void note(const SourceLoc& loc, std::string_view msg) {
    print_message(loc, "note", msg);
}
