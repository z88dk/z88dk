//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "file_mgr.h"
#include "string_interner.h"
#include "string_utils.h"
#include <iostream>

Diagnostics g_diag;

void Diagnostics::error(const SourceLoc& loc, std::string_view msg) {
    error_count_++;
    print_message(loc, "error", msg);
}

void Diagnostics::warning(const SourceLoc& loc, std::string_view msg) {
    print_message(loc, "warning", msg);
}

void Diagnostics::note(const SourceLoc& loc, std::string_view msg) {
    print_message(loc, "note", msg);
}

void Diagnostics::add_mapping(const SourceLine& logical_line,
                              const SourceLine& physical_loc) {
    line_mappings_[logical_line] = physical_loc;
}

size_t Diagnostics::error_count() const {
    return error_count_;
}

void Diagnostics::print_message(const SourceLoc& loc,
                                std::string_view level, std::string_view msg) {
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

    // Try to get the source line text for the given location.
    // If the file is not cached, or the line number is out of range,
    // this will return an empty string, and we won't print the source line.
    std::string line_text = g_file_mgr.get_source_line(filename, loc.line);
    if (!line_text.empty()) {
        print_source_line(line_text, loc.column);
    }

    // print the physical location if different from the logical location
    SourceLine logical_line(loc);
    auto it = line_mappings_.find(logical_line);
    if (it == line_mappings_.end()) {
        return;
    }

    SourceLine physical_loc = it->second;
    if (physical_loc == logical_line) {
        return;
    }

    std::string_view physical_filename = g_strings.view(physical_loc.file_id);
    std::cerr << "    (physical location: "
              << physical_filename << ":"
              << physical_loc.line << ")" << std::endl;

    line_text = g_file_mgr.get_source_line(physical_filename,
                                           physical_loc.line);
    if (!line_text.empty()) {
        print_source_line(line_text, 0);
    }
}

void Diagnostics::print_source_line(std::string_view text, size_t column) {
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
