//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "source.h"
#include "source_loc.h"
#include "strings.h"
#include "utils.h"
#include <iostream>
#include <string_view>

static int error_count_ = 0;

int error_count() {
    return error_count_;
}

static void print_source_line(std::string_view text, int column) {
    std::cerr << "    " << text << std::endl;

    if (column <= 0) {
        return;
    }

    std::string marker;
    marker.reserve(column);

    for (int i = 0; i < column - 1; i++) {
        if (i < static_cast<int>(text.size()) && is_space(text[i])) {
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
                          const std::string& level,
                          const std::string& msg) {
    if (!loc.empty()) {
        std::cerr << loc.to_string() << ": ";
    }

    std::cerr << level << ": " << msg << std::endl;

    if (loc.empty()) {
        return;
    }

    SourceFile* file = get_source_file(g_strings.to_string(loc.file_id), SourceLoc{});
    if (!file) {
        return;
    }

    if (loc.line < 1 || loc.line > file->line_offsets.size()) {
        return;
    }

    std::string text = read_line(*file, loc.line - 1, loc);
    if (!text.empty()) {
        print_source_line(text, loc.column);
    }
}

void error(const SourceLoc& loc, const std::string& msg) {
    error_count_++;
    print_message(loc, "error", msg);
}

void warning(const SourceLoc& loc, const std::string& msg) {
    print_message(loc, "warning", msg);
}

void note(const SourceLoc& loc, const std::string& msg) {
    print_message(loc, "note", msg);
}
