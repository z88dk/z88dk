//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "lexer.h"
#include "preprocessor.h"
#include <algorithm>
#include <cctype>
#include <fstream>
#include <regex>
#include <sstream>

Preprocessor::Preprocessor(ErrorReporter& reporter)
    : reporter_(reporter) {
}

bool Preprocessor::open(const std::string& filename) {
    file_stack_ = std::stack<InputFile>(); // clear stack
    macros_.clear(); // clear macros

    push_file(filename);
    return !file_stack_.empty();
}

bool Preprocessor::next_line(std::string& out_line, Location& out_location) {
    while (!file_stack_.empty()) {
        InputFile& file = file_stack_.top();
        if (file.line_index < file.lines.size()) {
            // Prepare location
            file.location.line_num = static_cast<int>(file.line_index + 1);
            out_location = file.location;
            out_location.source_line = file.lines[file.line_index];
            out_location.expanded_line.clear(); // to be filled after macro expansion

            Keyword keyword;
            size_t after_word;
            std::string line = file.lines[file.line_index++];
            if (is_directive(line, keyword, after_word)) {
                if (process_directive(keyword, line,
                                      after_word, out_location)) {
                    continue; // Skip output, process next line
                }
            }

            out_line = line;
            // TODO: handle macro expansion, comment removal, line splitting
            return true;
        }
        else {
            pop_file();
        }
    }
    return false;
}

bool Preprocessor::read_file(const std::string& filename,
                             std::vector<std::string>& lines) {
    std::ifstream in(filename.c_str(), std::ios::binary);
    if (!in) {
        reporter_.error(ErrorCode::FileNotFound, filename);
        return false;
    }

    std::string content(
        (std::istreambuf_iterator<char>(in)),
        std::istreambuf_iterator<char>());

    // Normalize line endings to '\n'
    std::string normalized;
    for (size_t i = 0; i < content.size(); ++i) {
        if (content[i] == '\r') {
            normalized += '\n';
            if (i + 1 < content.size() && content[i + 1] == '\n') {
                ++i;
            }
        }
        else {
            normalized += content[i];
        }
    }

    std::istringstream iss(normalized);
    std::string line;
    while (std::getline(iss, line)) {
        lines.push_back(line);
    }

    return true;
}

void Preprocessor::push_file(const std::string& filename) {
    std::vector<std::string> lines;
    if (read_file(filename, lines)) {
        InputFile file;
        file.filename = filename;
        file.lines = std::move(lines);
        file.line_index = 0;
        file.location = Location(filename, 0);
        file_stack_.push(std::move(file));
    }
}

void Preprocessor::pop_file() {
    if (!file_stack_.empty()) {
        file_stack_.pop();
    }
}

bool Preprocessor::is_directive(const std::string& line,
                                Keyword& keyword, size_t& after_word) const {
    size_t i = 0;

    // Skip leading whitespace
    while (i < line.size() &&
            std::isspace(static_cast<unsigned char>(line[i]))) {
        ++i;
    }

    // Optional hash
    if (i < line.size() && line[i] == '#') {
        ++i;

        // Skip whitespace after hash
        while (i < line.size() &&
                std::isspace(static_cast<unsigned char>(line[i]))) {
            ++i;
        }
    }

    // Extract first word
    size_t start = i;
    while (i < line.size() &&
            std::isalpha(static_cast<unsigned char>(line[i]))) {
        ++i;
    }
    if (start == i) {
        return false;    // No word found
    }

    std::string word = line.substr(start, i - start);
    keyword = to_keyword(word);
    if (keyword != Keyword::None) {
        after_word = i;
        return true;
    }
    else {
        return false;
    }
}

bool Preprocessor::process_directive(Keyword keyword,
                                     const std::string& line,
                                     size_t after_word, Location& location) {
    // rest = line after the directive word
    std::string rest = line.substr(after_word);

    // Remove leading whitespace
    size_t rest_start = rest.find_first_not_of(" \t");
    if (rest_start != std::string::npos) {
        rest = rest.substr(rest_start);
    }
    else {
        rest.clear();
    }

    switch (keyword) {
    case Keyword::INCLUDE: {
        // Support both "file" and <file>
        if (!rest.empty() && (rest.front() == '"' || rest.front() == '<')) {
            char quote = rest.front();
            size_t end = rest.find((quote == '"') ? '"' : '>');
            if (end != std::string::npos && end > 0) {
                std::string filename = rest.substr(1, end - 1);
                push_file(filename);
                return true;
            }
        }

        // If not quoted, treat as filename until whitespace
        std::istringstream iss(rest);
        std::string filename;
        iss >> filename;
        if (!filename.empty()) {
            push_file(filename);
            return true;
        }

        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed INCLUDE directive");
        return true;
    }
    case Keyword::DEFINE: {
        std::istringstream iss(rest);
        std::string name, value;
        iss >> name;
        std::getline(iss, value);

        // Remove leading whitespace from value
        size_t vstart = value.find_first_not_of(" \t");
        if (vstart != std::string::npos) {
            value = value.substr(vstart);
        }
        else {
            value.clear();
        }

        if (!name.empty()) {
            macros_[to_upper(name)] = value;
        }
        else {
            reporter_.error(location, ErrorCode::InvalidSyntax,
                            "Malformed DEFINE directive");
        }
        return true;
    }
    case Keyword::UNDEF: {
        std::istringstream iss(rest);
        std::string name;
        iss >> name;
        if (!name.empty()) {
            macros_.erase(to_upper(name));
        }
        else {
            reporter_.error(location, ErrorCode::InvalidSyntax,
                            "Malformed UNDEF directive");
        }
        return true;
    }
    case Keyword::LINE: {
        std::istringstream iss(rest);
        int new_line = 0;
        std::string filename;
        iss >> new_line;
        iss >> filename;

        if (!filename.empty() && filename.front() == '"') {
            // Remove quotes
            if (filename.size() > 1 && filename.back() == '"') {
                filename = filename.substr(1, filename.size() - 2);
            }
            else {
                filename = filename.substr(1);
            }
        }

        if (new_line > 0) {
            location.line_num = new_line;
        }
        if (!filename.empty()) {
            location.filename = filename;
        }

        return true;
    }
    default:
        return false; // Not a recognized directive
    }
}

