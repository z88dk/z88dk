//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
#include <stack>
#include <unordered_map>
#include <vector>
#include "error_reporter.h"
#include "lexer.h"

class Preprocessor {
public:
    Preprocessor(ErrorReporter& reporter);

    // Open the main file and start processing
    bool open(const std::string& filename);

    // Get the next preprocessed line, returns false at EOF
    bool next_line(std::string& out_line, Location& out_location);

private:
    struct InputFile {
        std::string filename;
        std::vector<std::string> lines;
        size_t line_index = 0;
        Location location;
    };

    ErrorReporter& reporter_;
    std::stack<InputFile> file_stack_;
    std::unordered_map<std::string, std::string> macros_;

    // Internal helpers
    bool read_file(const std::string& filename, std::vector<std::string>& lines);
    void push_file(const std::string& filename);
    void pop_file();
    bool is_directive(const std::string& line,
                      Keyword& keyword, size_t& after_word) const;
    bool process_directive(Keyword keyword,
                           const std::string& line,
                           size_t after_word, Location& location);



    void process_line(std::string& line, Location& location);
    void handle_directive(const std::string& line, InputFile& file);
    void expand_macros(std::string& line);
    void remove_comments(std::string& line);
    void split_lines(const std::string& line, std::vector<std::string>& split_lines,
                     Location& location);
    bool is_inside_string(const std::string& line, size_t pos) const;
};
