//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "z80asm.h"

Errors g_errors;

//-----------------------------------------------------------------------------

Location::Location(const string& filename_, int line_num_)
    : filename(filename_), line_num(line_num_) {
}

void Location::clear() {
    filename.clear();
    line_num = 0;
    line_inc = 1;
}

bool Location::empty() const {
    return filename.empty() && line_num == 0;
}

void Location::inc_line_num() {
    if (!is_c_source)
        line_num += line_inc;
}

//-----------------------------------------------------------------------------

void Errors::clear() {
    location.clear();
    clear_lines();
}

void Errors::clear_lines() {
    source_line.clear();
    expanded_line.clear();
}

int Errors::exit_code() const {
    if (count)
        return EXIT_FAILURE;
    else
        return EXIT_SUCCESS;
}

void Errors::error(Code code, const string& arg) {
    show_message(true, code, arg);
}

void Errors::warning(Code code, const string& arg) {
    show_message(false, code, arg);
}

void Errors::os_error(Code code, const string& arg) {
    error(code, arg);
    perror(arg.c_str());
}

void Errors::show_message(bool is_error, Code code, const string& arg_) {
    static const char* messages[] = {
#define X(id, text)    text,
#include "errors.def"
    };

    string arg = str_chomp(arg_);

    if (is_error)
        count++;

    // error message
    if (!location.filename.empty()) {
        cerr << location.filename << ":";
        if (location.line_num)
            cerr << location.line_num << ":";
        cerr << " ";
    }

    if (is_error)
        cerr << "error: ";
    else
        cerr << "warning: ";

    cerr << messages[static_cast<int>(code)];

    if (!arg.empty())
        cerr << ": " << arg;
    cerr << endl;

    // source line - remove extra spaces
    string striped_source_line = str_remove_extra_blanks(source_line);
    string striped_expanded_line = str_remove_extra_blanks(expanded_line);

    if (!striped_source_line.empty()) {
        cerr << "  ^---- " << striped_source_line << endl;

        // only show expanded line if it differs from source, ignoring blanks
        if (!striped_expanded_line.empty()) {
            string source_line_wo_blanks = str_remove_all_blanks(striped_source_line);
            string expanded_line_wo_blanks = str_remove_all_blanks(striped_expanded_line);
            if (source_line_wo_blanks != expanded_line_wo_blanks)
                cerr << "      ^---- " << striped_expanded_line << endl;
        }
    }
}
