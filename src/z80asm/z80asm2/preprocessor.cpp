//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "options.h"
#include "preprocessor.h"
#include <algorithm>
#include <cassert>

void Preprocessor::clear() {
    input_queue_.clear();
    file_stack_.clear();
    macros_.clear();
    macro_recursion_count_.clear();
}

void Preprocessor::push_file(const std::string& filename) {
    // Take ownership copy of the file on the file stack
    // so its token lines remain valid.
    File f;
    f.tokens_file = TokensFile(filename, 1);
    f.line_index = 0;
    f.has_forced_location = false;
    f.forced_constant_line_numbers = false;
    file_stack_.push_back(std::move(f));
}

void Preprocessor::push_virtual_file(const std::string& content,
                                     const std::string& filename,
                                     int first_line_num) {
    File vf;
    vf.tokens_file = TokensFile(content, filename, first_line_num);
    vf.line_index = 0;
    vf.has_forced_location = false;
    vf.forced_constant_line_numbers = false;
    file_stack_.push_back(std::move(vf));
}

bool Preprocessor::next_line(TokensLine& line) {
    line.clear();
    while (true) {
        // read lines from input queue if any
        if (!input_queue_.empty()) {
            line = std::move(input_queue_.front());
            input_queue_.pop_front();
            g_errors.set_expanded_line(line.to_string());
            return true;
        }

        // read lines from top file in stack
        if (file_stack_.empty()) {
            // no more input
            return false;
        }

        File& file = file_stack_.back();
        if (file.line_index >= file.tokens_file.tok_lines_count()) {
            // end of file reached; pop file from stack
            file_stack_.pop_back();
            continue;
        }

        // get next line from file
        line = file.tokens_file.get_tok_line(file.line_index);
        ++file.line_index;

        // If a LINE/C_LINE directive previously set a forced logical location for this file,
        // apply it to the TokensLine we just retrieved so subsequent processing sees the
        // updated logical filename/line numbers.
        if (file.has_forced_location) {
            int physical_index = file.line_index - 1; // index of the line we just took
            Location loc = line.location();
            if (!file.forced_filename.empty()) {
                loc.set_filename(file.forced_filename);
            }
            if (file.forced_constant_line_numbers) {
                loc.set_line_num(file.forced_start_line_num);
            }
            else {
                int offset = physical_index - file.forced_from_index;
                loc.set_line_num(file.forced_start_line_num + offset);
            }
            line.set_location(loc);
        }

        g_errors.set_location(line.location());
        g_errors.set_source_line(line.to_string());

        if (line.empty()) {
            // skip empty lines
            continue;
        }

        // check for directives and process
        Keyword keyword = Keyword::None;
        int i = 0;
        if (is_directive(line, i, keyword)) {
            process_directive(line, i, keyword);
            continue; // get next line
        }

        // check for name directive and process
        std::string name;
        keyword = Keyword::None;
        i = 0;
        if (is_name_directive(line, i, keyword, name)) {
            process_name_directive(line, i, keyword, name);
            continue; // get next line
        }

        // expand macros in the line
        Location location = line.location();
        std::vector<TokensLine> input_lines{ line };
        std::vector<TokensLine> expanded = expand_macros(input_lines);
        if (expanded.empty()) {
            continue; // get next line
        }

        // split expanded lines into input queue
        split_lines(location, expanded);
    }
}

void Preprocessor::expect_end(const TokensLine& line, int i) const {
    skip_spaces(line, i);
    if (i < line.size()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected token: '" + line[i].text() + "'");
    }
}

void Preprocessor::skip_spaces(const TokensLine& line, int& i) const {
    while (i < line.size() && line[i].is(TokenType::Whitespace)) {
        ++i;
    }
}

bool Preprocessor::is_directive(const TokensLine& line,
                                int& i, Keyword& keyword) const {
    skip_spaces(line, i);

    // skip optional #
    if (i < line.size() && line[i].is(OperatorType::Hash)) {
        ++i;
        skip_spaces(line, i);
    }

    // check for directive keywords
    keyword = Keyword::None;
    if (i < line.size() && line[i].is(TokenType::Identifier)) {
        keyword = line[i].keyword();
        if (keyword_is_directive(keyword)) {
            ++i;
            return true;
        }
    }

    i = 0;  // rewind
    return false;
}

bool Preprocessor::is_name_directive(const TokensLine& line, int& i,
                                     Keyword& keyword,
                                     std::string& name) const {
    skip_spaces(line, i);
    if (i < line.size() && line[i].is(TokenType::Identifier)) {
        name = line[i].text();
        ++i;

        skip_spaces(line, i);
        keyword = Keyword::None;
        if (i < line.size() && line[i].is(TokenType::Identifier)) {
            keyword = line[i].keyword();
            if (keyword_is_name_directive(keyword)) {
                ++i;
                return true;
            }
        }
    }

    i = 0;  // rewind
    return false;
}

void Preprocessor::process_directive(const TokensLine& line, int& i,
                                     Keyword keyword) {
    switch (keyword) {
    case Keyword::INCLUDE:
        process_include(line, i);
        break;
    case Keyword::LINE:
        process_line(line, i);
        break;
    case Keyword::C_LINE:
        process_c_line(line, i);
        break;
    default:
        assert(0);
    }
}

void Preprocessor::process_name_directive(const TokensLine& line, int& i,
        Keyword keyword,
        const std::string& name) {
    (void)line;
    (void)i;
    (void)keyword;
    (void)name;
    //switch (keyword) {
    //default:
    assert(0);
    //}
}

void Preprocessor::process_include(const TokensLine& line, int& i) {
    skip_spaces(line, i);
    if (i < line.size() && line[i].is(TokenType::String)) {
        // double-quoted or angle-bracketed filename
        std::string filename = line[i].string_value();
        bool is_angle = line[i].text().front() == '<';
        ++i;
        expect_end(line, i);

        do_include(filename, is_angle);
    }
    else {
        // whitespace separated filename (plain)
        std::string filename;
        while (i < line.size() && line[i].is_not(TokenType::Whitespace)) {
            filename += line[i].text();
            ++i;
        }
        expect_end(line, i);

        if (filename.empty()) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           "Expected filename string in include directive");
        }
        else {
            // plain filename
            do_include(filename, false);
        }
    }
}

void Preprocessor::do_include(const std::string& filename,
                              bool is_angle) {
    // search include file
    std::string resolved = resolve_include_candidate(filename, is_angle);
    if (resolved.empty()) { // file not found
        push_file(filename);
    }
    else {
        push_file(resolved);
    }
}

// Parse common LINE/C_LINE argument forms: <linenum> [ , "filename" ]
bool Preprocessor::parse_line_args(const TokensLine& line, int& i,
                                   int& out_linenum, std::string& out_filename,
                                   const char* directive_name) const {
    skip_spaces(line, i);

    if (!(i < line.size() && line[i].is(TokenType::Integer))) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Expected line number in ") + directive_name + " directive");
        return false;
    }

    out_linenum = line[i].int_value();
    ++i;

    skip_spaces(line, i);

    out_filename.clear();
    if (i < line.size() && line[i].is(TokenType::Comma)) {
        ++i;
        skip_spaces(line, i);
        if (i < line.size() && line[i].is(TokenType::String)) {
            out_filename = line[i].string_value();
            ++i;
        }
        else {
            g_errors.error(ErrorCode::InvalidSyntax,
                           std::string("Expected quoted filename after comma in ") + directive_name +
                           " directive");
            return false;
        }
    }

    expect_end(line, i);

    return true;
}

void Preprocessor::process_line(const TokensLine& line, int& i) {
    int linenum = 0;
    std::string filename;
    if (!parse_line_args(line, i, linenum, filename, "LINE")) {
        return;
    }

    // Apply forced logical location for the top file so subsequent lines
    // will report the specified filename/line numbers.
    if (file_stack_.empty()) {
        // nothing to apply to
        return;
    }

    File& file = file_stack_.back();
    file.has_forced_location = true;
    file.forced_from_index = file.line_index; // next physical index to be read
    file.forced_start_line_num = linenum;
    file.forced_constant_line_numbers = false;
    if (!filename.empty()) {
        file.forced_filename = filename;
    }
    else {
        // If no filename provided, keep existing logical filename
        file.forced_filename = file.tokens_file.filename();
    }
}

void Preprocessor::process_c_line(const TokensLine& line, int& i) {
    int linenum = 0;
    std::string filename;
    if (!parse_line_args(line, i, linenum, filename, "C_LINE")) {
        return;
    }

    // Apply forced logical location for the top file so subsequent lines
    // will report the specified filename and the same line number for all lines.
    if (file_stack_.empty()) {
        // nothing to apply to
        return;
    }

    File& file = file_stack_.back();
    file.has_forced_location = true;
    file.forced_from_index = file.line_index; // next physical index to be read
    file.forced_start_line_num = linenum;
    file.forced_constant_line_numbers = true;
    if (!filename.empty()) {
        file.forced_filename = filename;
    }
    else {
        // If no filename provided, keep existing logical filename
        file.forced_filename = file.tokens_file.filename();
    }
}

void Preprocessor::split_lines(const Location& location,
                               const std::vector<TokensLine>& expanded) {
    for (const TokensLine& eline : expanded) {
        split_line(location, eline);
    }
}

void Preprocessor::split_line(const Location& location,
                              const TokensLine& expanded) {
    TokensLine current(location);
    int ternary_depth = 0;
    int i = 0;

    // check for label at start of line
    split_label(location, expanded, i);

    // process rest of line
    while (i < expanded.size()) {
        const Token& t = expanded[i];
        if (t.is(OperatorType::Colon) && ternary_depth == 0) {
            // end of current line; push current line to queue
            input_queue_.push_back(std::move(current));
            current = TokensLine(location);
            ++i;
            // skip spaces after colon
            skip_spaces(expanded, i);
            continue;
        }
        else if (t.is(OperatorType::Quest)) {
            ++ternary_depth;
        }
        else if (t.is(OperatorType::Colon)) {
            if (ternary_depth > 0) {
                --ternary_depth;
            }
        }
        else if (t.is(TokenType::Backslash)) {
            // end of current line; push current line to queue
            input_queue_.push_back(std::move(current));
            current = TokensLine(location);
            ++i;
            // skip spaces after colon
            skip_spaces(expanded, i);
            continue;
        }
        else if (t.is(TokenType::String)) {
            // transform strings in lists of numbers separated by commas
            std::string str_val = t.string_value();
            ++i;
            bool is_first = true;
            for (char c : str_val) {
                if (!is_first) {
                    // add comma token
                    Token comma_tok(TokenType::Comma, ",");
                    current.push_back(comma_tok);
                }
                // add character as integer token
                int char_int = static_cast<int>(
                                   static_cast<unsigned char>(c));
                Token char_tok(TokenType::Integer,
                               std::to_string(char_int), char_int);
                current.push_back(char_tok);
                is_first = false;
            }
            continue;
        }

        current.push_back(t);
        ++i;
    }

    if (!current.empty()) {
        input_queue_.push_back(std::move(current));
    }
}

void Preprocessor::split_label(const Location& location,
                               const TokensLine& expanded, int& i) {

    TokensLine label_line(location);

    // label:
    i = 0; // rewind
    skip_spaces(expanded, i);
    if (i < expanded.size() && expanded[i].is(TokenType::Identifier)) {
        std::string label_name = expanded[i].text();
        ++i;
        skip_spaces(expanded, i);
        if (i < expanded.size() && expanded[i].is(OperatorType::Colon)) {
            ++i;
            // found label
            label_line.push_back(Token(TokenType::Dot, "."));
            label_line.push_back(Token(TokenType::Identifier, label_name));
            input_queue_.push_back(std::move(label_line));

            skip_spaces(expanded, i);
            return;
        }
    }

    // .label
    i = 0; // rewind
    skip_spaces(expanded, i);
    if (i < expanded.size() && expanded[i].is(TokenType::Dot)) {
        ++i;
        skip_spaces(expanded, i);
        if (i < expanded.size() && expanded[i].is(TokenType::Identifier)) {
            std::string label_name = expanded[i].text();
            ++i;
            // found label
            label_line.push_back(Token(TokenType::Dot, "."));
            label_line.push_back(Token(TokenType::Identifier, label_name));
            input_queue_.push_back(std::move(label_line));

            skip_spaces(expanded, i);
            return;
        }
    }

    i = 0; // rewind
    skip_spaces(expanded, i);
}

std::vector<TokensLine> Preprocessor::expand_macros(
    const std::vector<TokensLine>& lines) {
    return lines;
}
