//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "options.h"
#include "preproc.h"
#include "release_assert.h"
#include "utils.h"
#include <fstream>
#include <iostream>
#include <string>
#include <string_view>
#include <unordered_set>
#include <utility>
#include <vector>

static const std::string_view cpp_command =
    "z88dk-ucpp -lg -zI -Z -D__ZX81BAS__";

// scan a string
static void skip_whitespace(const std::string& text, size_t& pos) {
    while (pos < text.size() && isspace(text[pos])) {
        pos++;
    }
}

static bool match_char(const std::string& text, size_t& pos, char ch) {
    skip_whitespace(text, pos);
    if (pos < text.size() && text[pos] == ch) {
        pos++;
        return true;
    }
    return false;
}

static bool match_integer(const std::string& text, size_t& pos, int& out_num) {
    skip_whitespace(text, pos);
    if (pos < text.size() && isdigit(text[pos])) {
        size_t start = pos;
        pos++;
        while (pos < text.size() && isdigit(text[pos]))  {
            pos++;
        }
        out_num = std::stoi(text.substr(start, pos - start));
        return true;
    }
    return false;
}

static bool match_ident(const std::string& text, size_t& pos,
                        std::string& out_ident) {
    skip_whitespace(text, pos);
    if (pos < text.size() && (text[pos] == '_' || isalpha(text[pos]))) {
        size_t start = pos;
        pos++;
        while (pos < text.size() && (text[pos] == '_' || isalnum(text[pos]))) {
            pos++;
        }
        out_ident = text.substr(start, pos - start);
        return true;
    }
    return false;
}

static bool match_hash_ident(const std::string& text, size_t& pos,
                             std::string& out_ident) {
    pos = 0;
    if (match_char(text, pos, '#')) {
        if (match_ident(text, pos, out_ident)) {
            return true;
        }
    }
    pos = 0;
    return false;
}

static bool match_quoted_filename(const std::string& text, size_t& pos,
                                  std::string& out_filename) {
    if (match_char(text, pos, '"')) {
        size_t start = pos;
        size_t end = text.find('"', start);
        if (end != std::string::npos) {
            out_filename = text.substr(start, end - start);
            pos = end + 1;
            return true;
        }
    }
    return false;
}

static bool match_directive(const std::string& text, size_t& pos,
                            const std::string& directive) {
    std::string keyword;
    if (match_hash_ident(text, pos, keyword)) {
        if (keyword == directive) {
            return true;
        }
    }
    return false;
}

static bool match_basic_pragma(const std::string& text, size_t& pos) {
    std::string keyword;
    if (match_hash_ident(text, pos, keyword)) {
        if (keyword == "AUTOSTART" ||
                keyword == "AUTOSTART_LINE" ||
                keyword == "INCREMENT" ||
                keyword == "FAST" ||
                keyword == "VERBOSE" ||
                keyword == "VARS" ||
                keyword == "DFILE" ||
                keyword == "DFILE_COLAPSED" ||
                keyword == "SYSVARS" ||
                keyword == "ASM" ||
                keyword == "BASIC") {
            return true;
        }
    }
    return false;
}

static bool match_cpp_directive(const std::string& text, size_t& pos) {
    std::string keyword;
    if (match_hash_ident(text, pos, keyword)) {
        if (keyword == "include" ||
                keyword == "define" ||
                keyword == "undef" ||
                keyword == "if" ||
                keyword == "elif" ||
                keyword == "else" ||
                keyword == "endif" ||
                keyword == "ifdef" ||
                keyword == "ifndef" ||
                keyword == "line") {
            return true;
        }
    }
    return false;
}

static bool match_include(const std::string& text, size_t& pos,
                          std::string& out_filename) {
    pos = 0;
    if (match_directive(text, pos, "include")) {
        if (match_quoted_filename(text, pos, out_filename)) {
            // check for extra text after file name
            skip_whitespace(text, pos);
            if (pos < text.size()) {
                error("Unexpected text after #include: " + text.substr(pos));
            }
            return true;
        }
    }
    return false;
}

// read file
static bool read_source_file(const std::string& filename,
                             std::vector<SrcLine>& out_lines) {
    // open file
    std::ifstream infile(filename);
    if (!infile) {
        error("Failed to open file: " + filename);
        return false;
    }

    // read each line
    int line_num = 0;
    std::string text;
    while (std::getline(infile, text)) {
        line_num++;
        SrcLine src_line(std::move(text), filename, line_num);
        out_lines.emplace_back(std::move(src_line));
    }

    return true;
}

// parse # line_num "filename" lines and ajust location of source
static void map_line_numbers(std::vector<SrcLine>& src_lines) {
    std::string filename;

    int line_num = 0;
    for (auto& src_line : src_lines) {
        line_num++;

        size_t pos = 0;
        if (match_char(src_line.text, pos, '#')) {
            int num = 0;
            if (match_integer(src_line.text, pos, num)) {
                line_num = num - 1;
                match_quoted_filename(src_line.text, pos, filename);    // ignore output
                src_line.text = "";         // delete line
                continue;
            }
        }

        src_line.filename = filename;
        src_line.line_num = line_num;
    }
}

static void remove_empty_lines(std::vector<SrcLine>& src_lines) {
    for (auto it = src_lines.begin(); it != src_lines.end(); ) {
        if (it->text.empty()) {
            it = src_lines.erase(it);
        }
        else {
            ++it;
        }
    }
}

// join continuation lines
static void join_continuation_lines(std::vector<SrcLine>& src_lines) {
    for (size_t i = 0; i < src_lines.size(); i++) {
        while (!src_lines[i].text.empty() && src_lines[i].text.back() == '\\') {
            src_lines[i].text.back() = ' ';
            if (i + 1 < src_lines.size()) {
                src_lines[i].text += src_lines[i + 1].text;
                src_lines.erase(src_lines.begin() + i + 1);
            }
        }
    }
}

// remove /* */
// ignore single quotes as they can be part of a name, e.g. af'
static void remove_multi_line_comments(std::vector<SrcLine>& src_lines) {
    enum class State { Code, String, Comment };
    State state = State::Code;

    size_t comment_start_row = 0;
    size_t comment_start_col = 0;

    size_t row = 0;
    while (row < src_lines.size()) {
        size_t col = 0;
rescan_row:
        std::string& text = src_lines[row].text;

        while (col < text.size()) {
            switch (state) {

            case State::Code: {
                // find next string or comment
                size_t quote_pos = text.find('"', col);
                size_t comment_pos = text.find("/*", col);

                size_t next_pos = std::min(quote_pos, comment_pos);

                if (next_pos == std::string::npos) {
                    col = text.size();
                }
                else if (next_pos == quote_pos) {
                    col = quote_pos + 1;
                    state = State::String;
                }
                else if (next_pos == comment_pos) {
                    // Replace the comment by a single space.
                    text.replace(comment_pos, 2, " ");

                    comment_start_row = row;
                    comment_start_col = comment_pos + 1;

                    col = comment_start_col;
                    state = State::Comment;
                }
                else {
                    release_assert(0);
                }
                break;
            }

            case State::String: {
                // find end of string, skipping backslash escapes
                // and considering a string ends at the end of the line
                while (col < text.size() && text[col] != '"') {
                    if (text[col] == '\\' && col + 1 < text.size()) {
                        col += 2;
                    }
                    else {
                        col++;
                    }
                }

                if (col < text.size()) {
                    ++col;
                }

                state = State::Code;
                break;
            }

            case State::Comment: {
                size_t end_comment = text.find("*/", col);

                if (end_comment == std::string::npos) {
                    // Entire remainder of this line is inside the comment.
                    text.erase(col);

                    col = text.size();
                }
                else {
                    // Text after the comment terminator.
                    std::string suffix = text.substr(end_comment + 2);

                    if (row == comment_start_row) {
                        // comment entirely on one line
                        text.erase(col, end_comment + 2 - col);

                        state = State::Code;
                        col = comment_start_col;
                    }
                    else {
                        // Multi-line comment:
                        // append suffix to the line where the comment started.
                        std::string& start_text = src_lines[comment_start_row].text;

                        // append suffix to start line
                        start_text += suffix;

                        // delete comment text on current line
                        text.clear();

                        state = State::Code;

                        // restart scanning on the start line because the
                        // appended suffix may contain strings/comments.
                        row = comment_start_row;
                        col = comment_start_col;
                        goto rescan_row;
                    }
                }
                break;
            }

            default:
                release_assert(0);
            }
        }

        row++;
    }
}

// heuristic to detect start of single-quoted string
// necessary because BASIC comments start with quote and ASM has AF'
static bool start_of_squoted_string(std::string& text, size_t pos) {
    if (pos >= text.size() || text[pos] != '\'') {
        return false;
    }
    if (pos + 2 < text.size() &&
            text[pos + 1] == '\\') {
        return true;                // quoted string with backslash
    }
    if (pos + 4 < text.size() &&
            text[pos + 1] == '^' &&
            text[pos + 2] != '\\' &&
            text[pos + 3] == '\'') {
        return true;                // single quoted inverted char '^X'
    }
    if (pos + 3 < text.size() &&
            text[pos + 2] == '\'') {
        return true;                // single quoted char
    }
    return false;
}

// remove "//" comments everywhere
// remove "'" comments in BASIC
// remove ";" comments in ASM
// ignore quote in after af'
// skip quotes in quoted strings escaped with backslash
// replace af' by af
static void remove_comment(std::string& text,
                           bool in_basic) {
    size_t pos = 0;
    while (pos < text.size()) {
        if (pos + 2 < text.size() &&
                tolower(text[pos]) == 'a' &&
                tolower(text[pos + 1]) == 'f' &&
                tolower(text[pos + 2]) == '\'') {
            text.erase(pos + 2, 1);     // remove quote in af'
            pos += 2;                   // advance past af
        }
        else if (text[pos] == '"' ||
                 (text[pos] == '\'' && start_of_squoted_string(text, pos))) {
            // string
            char quote = text[pos];
            pos++;      // squip quote
            while (pos < text.size() && text[pos] != quote) {
                if (text[pos] == '\\' && pos + 1 < text.size()) {
                    pos += 2;
                }
                else {
                    pos++;
                }
            }
            if (pos < text.size()) {
                pos++;  // skip quote
            }
        }
        else if (text.substr(pos, 2) == "//") {
            text.erase(pos);        // remove rest of line
        }
        else if (in_basic && text[pos] == '\'') {
            text.erase(pos);        // remove rest of line
        }
        else if (!in_basic && text[pos] == ';') {
            text.erase(pos);        // remove rest of line
        }
        else {
            pos++;
        }
    }
}

static void remove_comments(std::vector<SrcLine>& src_lines) {
    bool in_basic = true;
    for (size_t row = 0; row < src_lines.size(); row++) {
        std::string& text = src_lines[row].text;
        bool this_line_basic = in_basic;

        size_t col = 0;
        if (match_directive(text, col, "ASM")) {
            in_basic = false;
            this_line_basic = true;
        }
        else if (match_directive(text, col, "BASIC")) {
            in_basic = true;
            this_line_basic = true;
        }
        else if (match_basic_pragma(text, col)) {
            this_line_basic = true;
        }
        else if (match_cpp_directive(text, col)) {
        }

        remove_comment(text, this_line_basic);
    }
}

// replace #XXX by !XXX so that they survive ucpp
static void escape_basic_pragmas(std::vector<SrcLine>& src_lines) {
    for (size_t row = 0; row < src_lines.size(); row++) {
        std::string& text = src_lines[row].text;

        size_t col = 0;
        if (match_basic_pragma(text, col)) {
            col = 0;
            skip_whitespace(text, col);
            release_assert(col < text.size() && text[col] == '#');
            text[col] = '!';
        }
    }
}

// process each ucpp inpuf file
static bool process_file(const std::string& input_file,
                         std::ofstream& outfile,
                         std::unordered_set<std::string>& files_in_progress) {
    // detect recursive include
    if (files_in_progress.count(input_file) > 0) {
        error("Recursive include detected: " + input_file);
        return false;
    }
    files_in_progress.insert(input_file);

    // read input of source file
    std::vector<SrcLine> src_lines;
    if (!read_source_file(input_file, src_lines)) {
        files_in_progress.erase(input_file);
        return false; // error already reported
    }

    // pre-process the file
    join_continuation_lines(src_lines);
    remove_multi_line_comments(src_lines);
    remove_comments(src_lines);
    escape_basic_pragmas(src_lines);

    // output #line directive to set the correct line number
    // and filename for the included file
    outfile << "#line 1 \"" << input_file << "\"" << std::endl;

    // process each line
    int line_num = 0;
    for (const auto& src_line : src_lines) {
        line_num++;

        // check for #include "filename"
        std::string include_filename;
        size_t pos = 0;
        if (match_include(src_line.text, pos, include_filename)) {
            if (!process_file(include_filename, outfile, files_in_progress)) {
                files_in_progress.erase(input_file);
                return false;
            }
            outfile << "#line " << (line_num + 1) << " \"" << input_file << "\"" <<
                    std::endl;
            continue;
        }

        // sync line numbers
        while (line_num < src_line.line_num) {
            outfile << std::endl;
            line_num++;
        }
        outfile << src_line.text << std::endl;
    }

    files_in_progress.erase(input_file);
    return true;
}

static bool preproc_with_cpp(const std::string& input_file,
                             const std::string& output_file) {
    std::string cmd = std::string(cpp_command)  +
                      " -o \"" + output_file + "\" \"" + input_file + "\"";
    if (g_verbose) {
        std::cout << "% " << cmd << std::endl;
    }
    if (system(cmd.c_str()) != 0) {
        error("cpp failed, command line: " + cmd);
        return false;
    }
    return true;
}

// prepare input file to ucpp by replacing BASIC pragmas and removing comments;
// necessary because BASIC pragmas start with '#' (replaced by '!') and
// source contains free-quotes (unterminated string) from BASIC
// comments and ex af, af' instruction
static bool prepare_input(const std::string& input_file,
                          const std::string& output_file) {
    // open output file for writing
    std::ofstream outfile(output_file);
    if (!outfile) {
        error("Failed to open output file: " + output_file);
        return false;
    }

    // process top level file
    std::unordered_set<std::string> files_in_progress;
    if (!process_file(input_file, outfile, files_in_progress)) {
        return false;
    }

    return true;
}

bool preproc(std::string input_file, std::vector<SrcLine>& out_lines) {
    // prepare input file for ucpp
    std::string prepared_file = input_file + ".pp";
    g_temp_files.push_back(prepared_file);

    if (!prepare_input(input_file, prepared_file)) {
        return false;
    }

#ifdef _DEBUG
    if (g_dump_step == 1) {
        cat_file(prepared_file);
        exit(EXIT_SUCCESS);
    }
#endif

    // preprocess with cpp
    std::string preproc_file = input_file + ".i";
    g_temp_files.push_back(preproc_file);

    if (!preproc_with_cpp(prepared_file, preproc_file)) {
        return false;
    }

#ifdef _DEBUG
    if (g_dump_step == 2) {
        cat_file(preproc_file);
        exit(EXIT_SUCCESS);
    }
#endif

    // read output
    out_lines.clear();
    if (!read_source_file(preproc_file, out_lines)) {
        return false;
    }
    map_line_numbers(out_lines);
    remove_empty_lines(out_lines);

#ifdef _DEBUG
    if (g_dump_step == 3) {
        std::cout << "Preprocessor output:" << std::endl;
        for (const auto& src_line : out_lines) {
            std::cout << src_line.filename << ":" << src_line.line_num << ": "
                      << src_line.text << std::endl;
        }
        exit(EXIT_SUCCESS);
    }
#endif

    return get_error_count() == 0;
}

bool match_ASM(const std::string& text) {
    size_t pos = 0;
    if (match_char(text, pos, '!')) {
        std::string keyword;
        if (match_ident(text, pos, keyword)) {
            if (keyword == "ASM") {
                return true;
            }
        }
    }
    return false;
}

bool match_BASIC(const std::string& text) {
    size_t pos = 0;
    if (match_char(text, pos, '!')) {
        std::string keyword;
        if (match_ident(text, pos, keyword)) {
            if (keyword == "BASIC") {
                return true;
            }
        }
    }
    return false;
}
