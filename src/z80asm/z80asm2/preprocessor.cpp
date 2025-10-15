//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "keywords.h"
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

bool Preprocessor::next_line(std::string& out_line,
                             Location& out_location) {
    while (true) {
        if (!split_queue_.empty()) {
            out_line = split_queue_.front();
            split_queue_.pop_front();
            return true;
        }

        while (!file_stack_.empty()) {
            InputFile& file = file_stack_.back();
            if (file.line_index < file.lines.size()) {
                int physical_line_num =
                    file.lines[file.line_index].physical_line_num;
                if (file.line_directive_active) {
                    file.location.set_logical_line_num(
                        file.line_directive_value,
                        file.line_directive_physical_line,
                        physical_line_num
                    );
                }
                else {
                    file.location.set_physical_line_num(physical_line_num);
                }

                out_location = file.location;
                out_location.set_source_line(
                    file.lines[file.line_index].text);

                std::string line = remove_comments(file);
                if (line.empty()) {
                    continue;
                }

                // Use pointer-based directive detection and processing
                const char* p = line.c_str();
                Keyword keyword;
                if (is_directive(p, keyword)) {
                    if (keyword == Keyword::LINE) {
                        if (process_directive(keyword, p, out_location)) {
                            // #line directive: update file.location
                            // for future lines
                            file.location = out_location;
                            file.line_directive_active = true;
                            // Track the value and physical line for #line
                            file.line_directive_value =
                                out_location.line_num();
                            file.line_directive_physical_line =
                                physical_line_num;
                            continue;
                        }
                    }
                    else {
                        if (process_directive(keyword, p, out_location)) {
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
                    // After returning a line, increment
                    // logical line number for next line
                    file.location.inc_line_num();
                    return true;
                }
            }
            else {
                pop_file();
            }
        }
        // If we get here, no more lines
        return false;
    }
}

// Helper: Normalize all line endings in-place to '\n' (NL).
// Accepts a mutable null-terminated C string.
static void normalize_line_endings(char* s) {
    char* src = s;
    char* dst = s;
    while (*src) {
        if (*src == '\r') {
            *dst++ = '\n';
            if (src[1] == '\n') {
                ++src; // skip LF after CR
            }
            ++src;
        }
        else {
            *dst++ = *src++;
        }
    }
    *dst = '\0';
}

void Preprocessor::split_logical_lines(const char* buffer,
                                       std::vector<LogicalLine>& lines) {
    std::istringstream iss(buffer);
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
        }
        else {
            logical_line += trimmed;
            if (!logical_line.empty()) { // Only push non-empty logical lines
                lines.push_back(LogicalLine{logical_line,
                                            logical_start_line});
            }
            logical_line.clear();
            logical_start_line = physical_line_num + 1;
        }
        ++physical_line_num;
    }
    if (!logical_line.empty()) {
        lines.push_back(LogicalLine{logical_line,
                                    logical_start_line});
    }
}

bool Preprocessor::read_file(const std::string& filename,
                             std::vector<LogicalLine>& lines) {
    std::ifstream in(filename.c_str(), std::ios::binary);
    if (!in) {
        reporter_.error(ErrorCode::FileNotFound, filename);
        return false;
    }

    // Read the entire file content directly into a mutable buffer
    in.seekg(0, std::ios::end);
    std::streamsize filesize = in.tellg();
    in.seekg(0, std::ios::beg);

    std::vector<char> buffer;
    if (filesize > 0) {
        buffer.resize(static_cast<size_t>(filesize));
        in.read(buffer.data(), filesize);
    }
    buffer.push_back('\0'); // null-terminate

    // Normalize line endings in-place
    normalize_line_endings(buffer.data());

    // Use the member function to split into logical lines
    split_logical_lines(buffer.data(), lines);

    return true;
}

// Add this private member function to Preprocessor (declare in preprocessor.h as well)
bool Preprocessor::is_recursive_include(const std::string& filename) const {
    for (const auto& f : file_stack_) {
        if (f.filename == filename) {
            return true;
        }
    }
    return false;
}

void Preprocessor::push_file(const std::string& filename) {
    // Check for recursive include using the new member function
    if (is_recursive_include(filename)) {
        reporter_.error(ErrorCode::RecursiveInclude, filename);
        return;
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

bool Preprocessor::is_directive(const char*& p, Keyword& keyword) const {
    keyword = Keyword::None;
    const char* start = p;

    // Skip leading whitespace
    skip_whitespace(p);

    // Optional hash
    if (*p == '#') {
        ++p;
        skip_whitespace(p);
    }

    // Try to scan an identifier
    std::string word;
    if (!scan_identifier(p, word)) {
        p = start;
        return false;
    }

    keyword = to_keyword(word);
    if (keyword_is_directive(keyword)) {
        // Found a directive keyword
        return true;
    }
    else {
        p = start;
        return false;
    }
}

bool Preprocessor::process_directive(Keyword keyword, const char*& p,
                                     Location& location) {

    // Skip leading whitespace
    skip_whitespace(p);

    switch (keyword) {
    case Keyword::INCLUDE:
        return process_include(p, location);
    case Keyword::DEFINE:
        return process_define(p, location);
    case Keyword::UNDEF:
        return process_undef(p, location);
    case Keyword::LINE:
        return process_line(p, location);
    default:
        return false;
    }
}

bool Preprocessor::process_include(const char*& p, Location& location) {
    skip_whitespace(p);

    std::string filename;

    // Handle quoted include: #include "file" or #include <file>
    if (*p == '"' || *p == '<') {
        char open = *p++;
        char close = (open == '"') ? '"' : '>';
        while (*p && *p != close) {
            filename += *p++;
        }
        if (*p == close) {
            ++p;    // skip closing quote/bracket
        }
        if (filename.empty()) {
            reporter_.error(location, ErrorCode::InvalidSyntax, "Empty INCLUDE filename");
            return true;
        }
        push_file(filename);
        return true;
    }

    // Fallback: read until whitespace
    while (*p && !isspace(static_cast<unsigned char>(*p))) {
        filename += *p++;
    }
    if (!filename.empty()) {
        push_file(filename);
        return true;
    }

    reporter_.error(location, ErrorCode::InvalidSyntax,
                    "Malformed INCLUDE directive");
    return true;
}

bool Preprocessor::process_define(const char*& p, Location& location) {
    skip_whitespace(p);

    // Parse macro name
    std::string name;
    if (!scan_identifier(p, name)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed DEFINE directive");
        return true;
    }

    std::vector<std::string> params;
    // Check for function-like macro: no whitespace between name and '('
    const char* after_name = p;
    skip_whitespace(p);
    if (*p == '(' && after_name == p) {
        ++p; // consume '('
        while (true) {
            skip_whitespace(p);
            if (*p == ')') {
                ++p; // consume ')'
                break;
            }
            std::string param;
            if (!scan_identifier(p, param)) {
                reporter_.error(location, ErrorCode::InvalidSyntax,
                                "Malformed macro parameter list");
                return true;
            }
            params.push_back(param);
            skip_whitespace(p);
            if (*p == ',') {
                ++p;
                continue;
            }
            if (*p == ')') {
                ++p;
                break;
            }
        }
    }

    // Skip whitespace before macro body
    skip_whitespace(p);

    // The rest of the line is the macro body
    std::string body = p;
    // Remove trailing whitespace
    body = rtrim(body);

    // Store macro
    Macro macro;
    macro.params = params;
    macro.body_tokens = tokenize_macro_body(body);
    macros_[name] = macro;
    return true;
}

bool Preprocessor::process_undef(const char*& p, Location& location) {
    skip_whitespace(p);

    std::string name;
    if (!scan_identifier(p, name)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed UNDEF directive");
        return true;
    }

    macros_.erase(name);
    return true;
}

bool Preprocessor::process_line(const char*& p, Location& location) {
    skip_whitespace(p);

    // Parse line number
    int new_line = 0;
    if (!scan_integer(p, new_line)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed LINE directive (missing line number)");
        return true;
    }

    skip_whitespace(p);

    // Parse filename (optional)
    std::string filename;
    if (*p == '"') {
        ++p; // skip opening quote
        while (*p && *p != '"') {
            if (*p == '\\' && p[1]) {
                filename += *p++;
                filename += *p++;
            }
            else {
                filename += *p++;
            }
        }
        if (*p == '"') {
            ++p;    // skip closing quote
        }
    }
    else if (*p) {
        // Unquoted filename: read until whitespace
        while (*p && !isspace(static_cast<unsigned char>(*p))) {
            filename += *p++;
        }
    }

    if (new_line > 0) {
        location.set_line_num(new_line);
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

// Helper: Expand an object-like macro recursively
std::string Preprocessor::expand_object_macro(const Macro& macro,
        int recursion_depth) {
    std::string macro_body;
    for (const auto& t : macro.body_tokens) {
        macro_body += t.text;
    }
    return expand_macros(macro_body, recursion_depth + 1);
}

// Helper: Expand a function-like macro invocation
std::string Preprocessor::expand_function_macro(const Macro& macro,
        const std::vector<MacroToken>& tokens,
        size_t& i, int recursion_depth) {
    size_t j = i + 1;
    // Skip whitespace
    while (j < tokens.size() &&
            tokens[j].type == MacroTokenType::Punctuator &&
            tokens[j].text == " ") {
        ++j;
    }

    if (j >= tokens.size() ||
            tokens[j].type != MacroTokenType::Punctuator ||
            tokens[j].text != "(") {
        return tokens[i].text; // Not a macro call, just return identifier
    }

    ++j; // skip '('
    std::vector<std::string> args;
    std::string arg;
    int paren_depth = 1;
    for (; j < tokens.size() && paren_depth > 0; ++j) {
        if (tokens[j].type == MacroTokenType::Punctuator &&
                tokens[j].text == "(") {
            ++paren_depth;
            arg += tokens[j].text;
        }
        else if (tokens[j].type == MacroTokenType::Punctuator &&
                 tokens[j].text == ")") {
            --paren_depth;
            if (paren_depth == 0) {
                args.push_back(expand_macros(arg,
                                             recursion_depth + 1)); // Expand argument
                break;
            }
            else {
                arg += tokens[j].text;
            }
        }
        else if (tokens[j].type == MacroTokenType::Punctuator &&
                 tokens[j].text == "," && paren_depth == 1) {
            args.push_back(expand_macros(arg,
                                         recursion_depth + 1)); // Expand argument
            arg.clear();
        }
        else {
            arg += tokens[j].text;
        }
    }

    std::string expanded = expand_macro_with_args(macro, args,
                           recursion_depth + 1);
    i = j; // skip to after ')'
    return expanded;
}

// Helper: Handle # and ## operators in macro expansion
bool Preprocessor::handle_macro_operators(
    const std::vector<MacroToken>& tokens,
    size_t& i, std::vector<std::string>& output) {
    const MacroToken& tok = tokens[i];

    if (tok.type == MacroTokenType::Operator && tok.text == "#") {
        if (i + 1 < tokens.size() &&
                tokens[i + 1].type == MacroTokenType::Identifier) {
            output.push_back(stringify(tokens[i + 1].text));
            ++i;
            return true;
        }
    }
    // Do not handle ## here!
    return false;
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
                    output.push_back(expand_function_macro(
                                         macro, tokens, i, recursion_depth));
                    continue;
                }
                else {
                    output.push_back(expand_object_macro(
                                         macro, recursion_depth));
                    continue;
                }
            }
        }

        if (handle_macro_operators(tokens, i, output)) {
            continue;
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

// Helper: Map macro parameters to their argument values
std::unordered_map<std::string, std::string> Preprocessor::make_param_map(
    const Macro& macro,
    const std::vector<std::string>& args) {
    std::unordered_map<std::string, std::string> param_map;
    for (size_t i = 0; i < macro.params.size(); ++i) {
        if (i < args.size()) {
            param_map[macro.params[i]] = args[i];
        }
        else {
            param_map[macro.params[i]] = "";
        }
    }
    return param_map;
}

// Helper: Expand a single macro token in macro body with arguments
void Preprocessor::expand_macro_token_with_args(
    const std::unordered_map<std::string, std::string>& param_map,
    const std::vector<MacroToken>& body_tokens,
    size_t& i,
    std::vector<std::string>& output) {
    const MacroToken& tok = body_tokens[i];
    if (tok.type == MacroTokenType::Identifier &&
            param_map.count(tok.text)) {
        // Substitute parameter with its argument value
        output.push_back(param_map.at(tok.text));
    }
    else if (tok.type == MacroTokenType::Operator &&
             tok.text == "#") {
        // Stringize the next parameter
        if (i + 1 < body_tokens.size() &&
                body_tokens[i + 1].type == MacroTokenType::Identifier &&
                param_map.count(body_tokens[i + 1].text)) {
            output.push_back(
                stringify(param_map.at(body_tokens[i + 1].text)));
            ++i;
        }
    }
    else if (tok.type == MacroTokenType::Operator && tok.text == "##") {
        // Token pasting: concatenate previous and next token,
        // skipping whitespace

        // Remove trailing whitespace from output
        while (!output.empty() && output.back() == " ") {
            output.pop_back();
        }

        // Skip whitespace tokens after ##
        size_t j = i + 1;
        while (j < body_tokens.size() &&
                body_tokens[j].type == MacroTokenType::Punctuator &&
                body_tokens[j].text == " ") {
            ++j;
        }

        if (!output.empty() && j < body_tokens.size()) {
            const MacroToken& next_tok = body_tokens[j];
            if (next_tok.type == MacroTokenType::Identifier
                    && param_map.count(next_tok.text)) {
                // Paste the full argument value
                output.back() += param_map.at(next_tok.text);
            }
            else {
                output.back() += next_tok.text;
            }
            i = j; // skip to pasted token
        }
    }
    else if (tok.type == MacroTokenType::Punctuator && tok.text == " ") {
        // Only add space if not pasting
        output.push_back(tok.text);
    }
    else {
        // Copy token as is
        output.push_back(tok.text);
    }
}

std::string Preprocessor::expand_macro_with_args(
    const Macro& macro,
    const std::vector<std::string>& args,
    int recursion_depth) {
    auto param_map = make_param_map(macro, args);

    std::vector<std::string> output;
    for (size_t i = 0; i < macro.body_tokens.size(); ++i) {
        expand_macro_token_with_args(param_map, macro.body_tokens,
                                     i, output);
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
                if (!in_char && line[i] == '"') {
                    handle_string_literal(line, i, result, in_string);
                    continue;
                }
                if (!in_string && line[i] == '\'') {
                    handle_char_literal(line, i, result, in_char);
                    continue;
                }
                if (i + 1 < line.size() && line[i] == '/' && line[i + 1] == '*') {
                    in_multiline_comment = true;
                    i += 2;
                    continue;
                }
                if (i + 1 < line.size() && line[i] == '/' && line[i + 1] == '/') {
                    break;
                }
                if (line[i] == ';') {
                    break;
                }
                result += line[i++];
            }
            else {
                if (handle_multiline_comment_end(line, i, in_multiline_comment)) {
                    continue;
                }
                ++i;
            }
        }
        ++file.line_index;
        if (!in_multiline_comment) {
            break;
        }
    }
    return rtrim(result);
}

// Handles a string literal, updating result and i, toggling in_string.
void Preprocessor::handle_string_literal(const std::string& line,
        size_t& i, std::string& result, bool& in_string) {
    result += line[i++];
    in_string = !in_string;
    while (in_string && i < line.size()) {
        result += line[i];
        if (line[i] == '\\' && i + 1 < line.size()) {
            ++i;
            result += line[i];
        }
        else if (line[i] == '"') {
            in_string = false;
        }
        ++i;
    }
}

// Handles a character literal, updating result and i, toggling in_char.
void Preprocessor::handle_char_literal(const std::string& line,
                                       size_t& i, std::string& result, bool& in_char) {
    result += line[i++];
    in_char = !in_char;
    while (in_char && i < line.size()) {
        result += line[i];
        if (line[i] == '\\' && i + 1 < line.size()) {
            ++i;
            result += line[i];
        }
        else if (line[i] == '\'') {
            in_char = false;
        }
        ++i;
    }
}

// Handles the end of a multi-line comment. Returns true if the end was found and handled.
bool Preprocessor::handle_multiline_comment_end(const std::string& line,
        size_t& i, bool& in_multiline_comment) {
    if (i + 1 < line.size() && line[i] == '*' && line[i + 1] == '/') {
        in_multiline_comment = false;
        i += 2;
        return true;
    }
    return false;
}

// Returns true if the line starts with an identifier (possibly after whitespace) followed by a colon.
// Sets first_colon_after_id to true if a label is detected.
static bool has_label(const std::string& line) {
    const char* p = line.c_str();
    skip_whitespace(p);

    std::string ident;
    if (scan_identifier(p, ident)) {
        skip_whitespace(p);
        if (*p == ':') {
            return true;
        }
    }
    return false;
}

void Preprocessor::split_lines(const std::string& line,
                               std::vector<std::string>& split_lines) {
    split_lines.clear();
    std::string current;
    bool in_string = false, in_char = false;
    bool first_colon_after_id = has_label(line);
    int ternary_depth = 0;

    const char* p = line.c_str();
    const char* start = p;

    while (*p) {
        char c = *p;

        // Handle string and char literals, with escape support
        if (!in_char && c == '"' && (p == start || *(p - 1) != '\\')) {
            in_string = !in_string;
            current += c;
            ++p;
            continue;
        }

        if (!in_string && c == '\'') {
            in_char = !in_char;
            current += c;
            ++p;
            continue;
        }

        if (in_string || in_char) {
            // If this is a backslash and not the last character, skip the next character (escaped)
            if (c == '\\' && *(p + 1)) {
                current += c;
                ++p;
                current += *p;
                ++p;
                continue;
            }
            current += c;
            ++p;
            continue;
        }

        // Track ternary operator depth
        if (c == '?') {
            ++ternary_depth;
            current += c;
            ++p;
            continue;
        }
        if (c == ':' && ternary_depth > 0) {
            --ternary_depth;
            current += c;
            ++p;
            continue;
        }

        // Handle backslash as split, only if not in string/char and not an escape
        if (c == '\\') {
            // Trim whitespace before pushing
            split_lines.push_back(rtrim(ltrim(current)));
            current.clear();
            ++p;
            continue;
        }

        // Handle colon as split, except first colon after identifier at start,
        // and except when inside a ternary expression
        if (c == ':') {
            if (first_colon_after_id) {
                current += c;
                first_colon_after_id = false;
            }
            else if (ternary_depth == 0) {
                split_lines.push_back(rtrim(ltrim(current)));
                current.clear();
            }
            else {
                current += c;
            }
            ++p;
            continue;
        }

        current += c;
        ++p;
    }

    // Add the last segment, trimmed
    split_lines.push_back(rtrim(ltrim(current)));
}

