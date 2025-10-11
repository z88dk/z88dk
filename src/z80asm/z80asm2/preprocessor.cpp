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
#include <stack>

Preprocessor::Preprocessor(ErrorReporter& reporter)
    : reporter_(reporter) {
}

bool Preprocessor::open(const std::string& filename) {
    file_stack_.clear();
    macros_.clear(); // clear macros

    push_file(filename);
    return !file_stack_.empty();
}

bool Preprocessor::next_line(std::string& out_line, Location& out_location) {
    while (true) {
        if (!split_queue_.empty()) {
            out_line = split_queue_.front();
            split_queue_.pop_front();
            return true;
        }

        while (!file_stack_.empty()) {
            InputFile& file = file_stack_.back();
            if (file.line_index < file.lines.size()) {
                Keyword keyword;
                size_t after_word;

                // Always set location to the physical line number unless a #line directive was just processed
                if (!file.line_directive_active) {
                    file.location.set_line_num(file.lines[file.line_index].physical_line_num);
                }
                
                out_location = file.location;
                out_location.set_source_line(file.lines[file.line_index].text);

                std::string line = remove_comments(file);
                if (line.empty())
                    continue;

                if (is_directive(line, keyword, after_word)) {
                    if (keyword == Keyword::LINE) {
                        if (process_directive(keyword, line, after_word, out_location)) {
                            // #line directive: update file.location for future lines
                            file.location = out_location;
                            file.line_directive_active = true;
                            continue;
                        }
                    } else {
                        if (process_directive(keyword, line, after_word, out_location)) {
                            continue;
                        }
                    }
                }

                std::string expanded = expand_macros(line);
                out_location.set_expanded_line(expanded);

                std::vector<std::string> split_lines_vec;
                split_lines(expanded, split_lines_vec);

                if (!split_lines_vec.empty()) {
                    out_line = split_lines_vec[0];
                    for (size_t i = 1; i < split_lines_vec.size(); ++i) {
                        split_queue_.push_back(split_lines_vec[i]);
                    }
                    // After returning a line, increment logical line number for next line
                    file.location.set_line_num(file.location.line_num() + 1);
                    return true;
                }
            } else {
                pop_file();
            }
        }
        // If we get here, no more lines
        return false;
    }
}

bool Preprocessor::read_file(const std::string& filename,
                             std::vector<LogicalLine>& lines) {
    std::ifstream in(filename.c_str(), std::ios::binary);
    if (!in) {
        reporter_.error(ErrorCode::FileNotFound, filename);
        return false;
    }

    // read the entire file content
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

    // Split into logical lines (handling backslash continuations)
    std::istringstream iss(normalized);
    std::string logical_line, physical_line;
    int physical_line_num = 1;
    int logical_start_line = 1;
    while (std::getline(iss, physical_line)) {
        std::string trimmed = rtrim(physical_line);
        if (!trimmed.empty() && trimmed.back() == '\\') {
            trimmed.pop_back();
            logical_line += trimmed;
            logical_line += " ";
            // Don't increment logical_start_line, as this is a continuation
        } else {
            logical_line += trimmed;
            lines.push_back(LogicalLine{logical_line, logical_start_line});
            logical_line.clear();
            logical_start_line = physical_line_num + 1;
        }
        ++physical_line_num;
    }
    if (!logical_line.empty()) {
        lines.push_back(LogicalLine{logical_line, logical_start_line});
    }
    return true;
}

void Preprocessor::push_file(const std::string& filename) {
    // Check for recursive include
    for (const auto& f : file_stack_) {
        if (f.filename == filename) {
            reporter_.error(ErrorCode::RecursiveInclude, filename);
            return;
        }
    }

    // read the whole file
    std::vector<LogicalLine> lines;
    if (read_file(filename, lines)) {
        InputFile file;
        file.filename = filename;
        file.lines = std::move(lines);
        file.line_index = 0;
        file.location = Location(filename, 0);
        file_stack_.push_back(std::move(file));
    }
}

void Preprocessor::pop_file() {
    if (!file_stack_.empty()) {
        file_stack_.pop_back();
        // When returning to a parent file, synchronize logical line number and filename
        if (!file_stack_.empty()) {
            InputFile& parent = file_stack_.back();
            if (parent.line_index < parent.lines.size()) {
                // Set location to the next logical line's physical line number and correct filename
                parent.location.set_line_num(parent.lines[parent.line_index].physical_line_num);
                parent.location.set_filename(parent.filename);
            }
        }
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

    // Use scan_identifier to extract the first word
    std::istringstream iss(line.substr(i));
    std::string word;
    std::streampos before = iss.tellg();
    if (!scan_identifier(iss, word)) {
        return false;    // No word found
    }
    std::streampos after = iss.tellg();
    keyword = to_keyword(word);
    if (keyword != Keyword::None) {
        // after_word is the index in the original line after the keyword
        after_word = i + static_cast<size_t>(after);
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
    size_t rest_start = rest.find_first_not_of(" \t");
    if (rest_start != std::string::npos) {
        rest = rest.substr(rest_start);
    }
    else {
        rest.clear();
    }

    switch (keyword) {
    case Keyword::INCLUDE:
        return process_include(rest, location);
    case Keyword::DEFINE:
        return process_define(rest, location);
    case Keyword::UNDEF:
        return process_undef(rest, location);
    case Keyword::LINE:
        return process_line(rest, location);
    default:
        return false;
    }
}

bool Preprocessor::process_include(const std::string& rest,
                                   Location& location) {
    if (!rest.empty() && (rest.front() == '"' || rest.front() == '<')) {
        char quote = rest.front();
        // Find the closing quote, skipping the first character
        size_t end = rest.find((quote == '"') ? '"' : '>', 1);
        if (end != std::string::npos && end > 1) {
            std::string filename = rest.substr(1, end - 1);
            push_file(filename);
            return true;
        }
    }

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

bool Preprocessor::process_define(const std::string& rest, Location& location) {
    std::istringstream iss(rest);
    std::string name;

    if (!scan_identifier(iss, name)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed DEFINE directive");
        return true;
    }

    // Save stream position after macro name
    std::streampos after_name = iss.tellg();

    // Peek next character (without skipping whitespace)
    char next = iss.peek();

    std::vector<std::string> params;
    std::string body;

    if (next == '(') {
        // Function-like macro: no whitespace between name and '('
        iss.get(); // consume '('
        while (true) {
            // Skip whitespace
            iss >> std::ws;

            // Check for end of parameter list
            if (iss.peek() == ')') {
                iss.get(); // consume ')'
                break;
            }

            std::string param;
            if (!scan_identifier(iss, param)) {
                reporter_.error(location, ErrorCode::InvalidSyntax,
                                "Malformed macro parameter list");
                return true;
            }

            params.push_back(param);

            // Skip whitespace
            iss >> std::ws;
            if (iss.peek() == ',') {
                iss.get();
                continue;
            }

            // If next is ')', will be handled in next loop
        }
    }
    else {
        // Object-like macro: restore stream to after name, body is the rest
        iss.clear();
        iss.seekg(after_name);
    }

    // Skip whitespace before macro body
    iss >> std::ws;
    std::getline(iss, body);

    // Trim trailing whitespace from macro body
    body = rtrim(body);

    // Store macro
    Macro macro;
    macro.params = params;
    macro.body_tokens = tokenize_macro_body(body);
    macros_[name] = macro;
    return true;
}

bool Preprocessor::process_undef(const std::string& rest, Location& location) {
    std::istringstream iss(rest);
    std::string name;

    if (!scan_identifier(iss, name)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed UNDEF directive");
        return true;
    }

    macros_.erase(name);
    return true;
}

bool Preprocessor::process_line(const std::string& rest, Location& location) {
    std::istringstream iss(rest);
    int new_line = 0;
    std::string filename;

    iss >> new_line;
    iss >> filename;
    if (!filename.empty() && filename.front() == '"') {
        if (filename.size() > 1 && filename.back() == '"') {
            filename = filename.substr(1, filename.size() - 2);
        }
        else {
            filename = filename.substr(1);
        }
    }

    if (new_line > 0) {
        location.set_line_num( new_line);
    }

    if (!filename.empty()) {
        location.set_filename(filename);
    }

    return true;
}

// Helper: Stringify a macro argument
static std::string stringify(const std::string& arg) {
    std::string result = "\"";
    for (char c : arg) {
        if (c == '"' || c == '\\') {
            result += '\\';
        }
        result += c;
    }
    result += "\"";
    return result;
}

std::string Preprocessor::expand_macros(const std::string& line,
                                        int recursion_depth) {
    if (recursion_depth > MAX_MACRO_RECURSION) {
        return line;    // Prevent infinite recursion
    }

    std::vector<MacroToken> tokens = tokenize_macro_body(line);
    std::vector<std::string> output;

    for (size_t i = 0; i < tokens.size(); ++i) {
        const MacroToken& tok = tokens[i];

        if (tok.type == MacroTokenType::Identifier) {
            auto it = macros_.find(tok.text);
            if (it != macros_.end()) {
                const Macro& macro = it->second;
                if (!macro.params.empty()) {
                    // Function-like macro: parse arguments
                    size_t j = i + 1;
                    while (j < tokens.size() && tokens[j].type == MacroTokenType::Punctuator
                            && tokens[j].text == " ") {
                        ++j;
                    }
                    if (j < tokens.size() && tokens[j].type == MacroTokenType::Punctuator
                            && tokens[j].text == "(") {
                        ++j; // skip '('
                        std::vector<std::string> args;
                        std::string arg;
                        int paren_depth = 1;
                        for (; j < tokens.size() && paren_depth > 0; ++j) {
                            if (tokens[j].type == MacroTokenType::Punctuator && tokens[j].text == "(") {
                                ++paren_depth;
                                arg += tokens[j].text;
                            }
                            else if (tokens[j].type == MacroTokenType::Punctuator
                                     && tokens[j].text == ")") {
                                --paren_depth;
                                if (paren_depth == 0) {
                                    args.push_back(expand_macros(arg, recursion_depth + 1)); // Expand argument
                                    break;
                                }
                                else {
                                    arg += tokens[j].text;
                                }
                            }
                            else if (tokens[j].type == MacroTokenType::Punctuator && tokens[j].text == ","
                                     && paren_depth == 1) {
                                args.push_back(expand_macros(arg, recursion_depth + 1)); // Expand argument
                                arg.clear();
                            }
                            else {
                                arg += tokens[j].text;
                            }
                        }

                        // Expand macro with arguments
                        std::string expanded =
                            expand_macro_with_args(macro, args,
                                recursion_depth + 1);
                        output.push_back(expanded);
                        i = j; // skip to after ')'
                        continue;
                    }
                }
                else {
                    // Object-like macro: expand recursively
                    std::string macro_body;
                    for (const auto& t : macro.body_tokens) {
                        macro_body += t.text;
                    }
                    output.push_back(expand_macros(macro_body,
                        recursion_depth + 1));
                    continue;
                }
            }
        }

        // Handle # and ##
        if (tok.type == MacroTokenType::Operator && tok.text == "#") {
            if (i + 1 < tokens.size() && tokens[i + 1].type == MacroTokenType::Identifier) {
                output.push_back(stringify(tokens[i + 1].text));
                ++i;
                continue;
            }
        }

        if (tok.type == MacroTokenType::Operator && tok.text == "##") {
            if (!output.empty() && i + 1 < tokens.size()) {
                output.back() += tokens[i + 1].text;
                ++i;
                continue;
            }
        }

        // Default: copy token
        output.push_back(tok.text);
    }

    // Join output
    std::string result;
    for (const auto& s : output) {
        result += s;
    }
    return result;
}

std::string Preprocessor::expand_macro_with_args(const Macro& macro,
        const std::vector<std::string>& args, int recursion_depth) {
    std::unordered_map<std::string, std::string> param_map;

    // Map parameter names to their (already expanded) argument values
    for (size_t i = 0; i < macro.params.size(); ++i) {
        if (i < args.size()) {
            param_map[macro.params[i]] = args[i];
        }
        else {
            param_map[macro.params[i]] = "";
        }
    }

    std::vector<std::string> output;
    for (size_t i = 0; i < macro.body_tokens.size(); ++i) {
        const MacroToken& tok = macro.body_tokens[i];
        if (tok.type == MacroTokenType::Identifier && param_map.count(tok.text)) {
            // Substitute parameter with its argument value
            output.push_back(param_map[tok.text]);
        }
        else if (tok.type == MacroTokenType::Operator && tok.text == "#") {
            // Stringize the next parameter
            if (i + 1 < macro.body_tokens.size()
                    && macro.body_tokens[i + 1].type == MacroTokenType::Identifier
                    && param_map.count(macro.body_tokens[i + 1].text)) {
                output.push_back(stringify(param_map[macro.body_tokens[i + 1].text]));
                ++i;
            }
        }
        else if (tok.type == MacroTokenType::Operator && tok.text == "##") {
            // Token pasting: concatenate previous and next token
            if (!output.empty() && i + 1 < macro.body_tokens.size()) {
                output.back() += macro.body_tokens[i + 1].text;
                ++i;
            }
        }
        else {
            // Copy token as is
            output.push_back(tok.text);
        }
    }

    std::string result;
    for (const auto& s : output) {
        result += s;
    }

    // Recursively expand in case the result contains more macros
    return expand_macros(result, recursion_depth + 1);
}

// Remove all comments (single-line and multi-line, including across lines).
// Advances file.line_index as needed to consume multi-line comments.
std::string Preprocessor::remove_comments(InputFile& file) {
    std::string result;
    bool in_string = false, in_char = false;
    bool in_multiline_comment = false;

    while (file.line_index < file.lines.size()) {
        const std::string& line = file.lines[file.line_index].text;
        size_t i = 0;
        while (i < line.size()) {
            if (!in_multiline_comment) {
                // String literal
                if (!in_char && line[i] == '"') {
                    result += line[i++];
                    in_string = !in_string;
                    while (in_string && i < line.size()) {
                        result += line[i];
                        if (line[i] == '\\' && i + 1 < line.size()) {
                            ++i;
                            result += line[i];
                        } else if (line[i] == '"') {
                            in_string = false;
                        }
                        ++i;
                    }
                    continue;
                }
                // Char literal
                if (!in_string && line[i] == '\'') {
                    result += line[i++];
                    in_char = !in_char;
                    while (in_char && i < line.size()) {
                        result += line[i];
                        if (line[i] == '\\' && i + 1 < line.size()) {
                            ++i;
                            result += line[i];
                        } else if (line[i] == '\'') {
                            in_char = false;
                        }
                        ++i;
                    }
                    continue;
                }
                // Start of multi-line comment
                if (i + 1 < line.size() && line[i] == '/' && line[i + 1] == '*') {
                    in_multiline_comment = true;
                    i += 2;
                    continue;
                }
                // Single-line C++ comment
                if (i + 1 < line.size() && line[i] == '/' && line[i + 1] == '/') {
                    i = line.size();
                    break;
                }
                // Assembly comment
                if (line[i] == ';') {
                    i = line.size();
                    break;
                }
                // Normal character
                result += line[i++];
            } else {
                // Inside multi-line comment, look for end
                if (i + 1 < line.size() && line[i] == '*' && line[i + 1] == '/') {
                    in_multiline_comment = false;
                    i += 2;
                } else {
                    ++i;
                }
            }
        }
        ++file.line_index;
        // If we are not in a multi-line comment, break after this line
        if (!in_multiline_comment)
            break;
    }
    return rtrim(result);
}

void Preprocessor::split_lines(const std::string& line,
                               std::vector<std::string>& split_lines) {
    split_lines.clear();
    std::string current;
    bool in_string = false, in_char = false;
    bool first_colon_after_id = false;
    size_t i = 0;

    // Use a stream to call scan_identifier
    std::istringstream iss(line);
    std::string ident;
    size_t start = 0;

    // Skip leading whitespace
    while (start < line.size()
            && std::isspace(static_cast<unsigned char>(line[start]))) {
        ++start;
    }
    iss.seekg(start);

    if (scan_identifier(iss, ident)) {
        // Skip whitespace after identifier
        while (iss && std::isspace(iss.peek())) {
            iss.get();
        }

        if (iss && iss.peek() == ':') {
            // This is a label definition, skip the first colon
            first_colon_after_id = true;
        }
    }

    for (i = 0; i < line.size(); ++i) {
        char c = line[i];

        // Handle string and char literals, with escape support
        if (!in_char && c == '"' && (i == 0 || line[i - 1] != '\\')) {
            in_string = !in_string;
            current += c;
            continue;
        }

        if (!in_string && c == '\'' && (i == 0 || line[i - 1] != '\\')) {
            in_char = !in_char;
            current += c;
            continue;
        }

        if (in_string || in_char) {
            // If this is a backslash and not the last character, skip the next character (escaped)
            if (c == '\\' && (i + 1 < line.size())) {
                current += c;
                ++i;
                current += line[i];
                continue;
            }

            current += c;
            continue;
        }

        // Handle backslash as split, only if not in string/char and not an escape
        if (c == '\\') {
            split_lines.push_back(current);
            current.clear();
            continue;
        }

        // Handle colon as split, except first colon after identifier at start
        if (c == ':') {
            if (first_colon_after_id) {
                current += c;
                first_colon_after_id = false;
            }
            else {
                split_lines.push_back(current);
                current.clear();
            }
            continue;
        }

        current += c;
    }

    // Add the last segment
    split_lines.push_back(current);
}

