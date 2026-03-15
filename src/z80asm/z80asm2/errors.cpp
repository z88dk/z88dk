//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "source.h"
#include "source_loc.h"
#include "utils.h"
#include <iostream>
#include <string_view>

static int error_count_ = 0;

int error_count() {
    return error_count_;
}

static void print_source_line(const SourceLine& line, int column) {
    std::string_view text(line.text);

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

static void print_message(const SourceLoc& loc, const std::string& level, const std::string& msg) {
    if (!loc.empty()) {
        std::cerr << loc.to_string() << ": ";
    }
    std::cerr << level << ": " << msg << std::endl;

    SourceFile* file = get_source_file(loc.file);
    if (file != nullptr) {
        if (loc.line >= 1 && loc.line <= static_cast<int>(file->lines.size())) {
            const SourceLine& line = file->lines[loc.line - 1];
            print_source_line(line, loc.column);
        }
    }
}

void error(const std::string& msg) {
    error(SourceLoc(), msg);
}

void error(const SourceLoc& loc, const std::string& msg) {
    error_count_++;
    print_message(loc, "error", msg);
}

void warning(const std::string& msg) {
    warning(SourceLoc(), msg);
}

void warning(const SourceLoc& loc, const std::string& msg) {
    print_message(loc, "warning", msg);
}
