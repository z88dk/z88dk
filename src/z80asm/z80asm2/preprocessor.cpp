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
                std::string name;
                Keyword keyword;

                const char* p = line.c_str();
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

                p = line.c_str();
                if (is_name_directive(p, name, keyword)) {
                    if (process_name_directive(keyword, name, p)) {
                        continue;
                    }
                }

                // Expand macros. A multi-line macro expansion may push a virtual
                // InputFile on the file_stack_ and return an empty string
                std::string expanded = expand_macros(line);
                if (expanded.empty()) {
                    continue;
                }

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
    case Keyword::DEFL:
        return process_defl(p, location);
    case Keyword::UNDEF:
        return process_undef(p, location);
    case Keyword::LINE:
        return process_line(p, location);
    case Keyword::MACRO:
        return process_macro(p, location);
    case Keyword::EXITM:
        // If we are inside a macro virtual file, EXITM aborts the current macro expansion.
        if (!file_stack_.empty()) {
            InputFile& curr = file_stack_.back();
            if (curr.is_macro_expansion) {
                // Pop the macro virtual file to abort expansion
                pop_file();
                return true;
            }
        }
        // If not in a macro file, just ignore (or report warning)
        reporter_.warning(location, ErrorCode::InvalidSyntax,
                          "ENDM outside of macro epansion");
        return true;
    default:
        return false;
    }
}

// DEFL: define-or-redefine a pure text macro where occurrences of the macro
// name in the RHL are replaced by the previous textual value of the macro.
// Example:
//   DEFL var = var+1   // -> var becomes "+1"
//   DEFL var = var+1   // -> var becomes "+1+1"
bool Preprocessor::process_defl(const char*& p, Location& location) {
    skip_whitespace(p);

    // Parse macro name
    std::string name;
    if (!scan_identifier(p, name)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed DEFL directive (missing name)");
        return true;
    }

    skip_whitespace(p);

    // Expect '='
    if (*p != '=') {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed DEFL directive (missing '=')");
        return true;
    }
    ++p; // skip '='

    // continue into process_name_defl
    return process_name_defl(p, name);
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
    macro.body_lines.push_back(tokenize_macro_body(body));
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

bool Preprocessor::is_name_directive(const char*& p, std::string& name,
                                     Keyword& keyword) const {
    const char* start = p;
    name.clear();
    std::string directive;

    // Scan first identifier (name)
    if (!scan_identifier(p, name)) {
        p = start;
        keyword = Keyword::None;
        return false;
    }

    // Scan second identifier (directive)
    if (!scan_identifier(p, directive)) {
        p = start;
        keyword = Keyword::None;
        return false;
    }

    // Convert to keyword and check if it's a name-directive
    keyword = to_keyword(directive);
    if (!keyword_is_name_directive(keyword)) {
        p = start;
        keyword = Keyword::None;
        return false;
    }

    return true;
}

bool Preprocessor::process_name_directive(Keyword keyword,
        const std::string& name, const char*& p) {
    // Skip leading whitespace
    skip_whitespace(p);

    switch (keyword) {
    case Keyword::DEFL:
        return process_name_defl(p, name);
    case Keyword::DEFINE:
        return process_name_define(p, name);
    default:
        return false;
    }
}

bool Preprocessor::process_name_defl(const char*& p,
                                     const std::string& name) {

    // Skip whitespace before macro body
    skip_whitespace(p);

    // Read RHS as raw text (rest of the line)
    std::string rhs = p;
    rhs = rtrim(rhs);

    // Determine previous textual value (concatenate token.text of existing macro body)
    std::string prev_text;
    auto it_prev = macros_.find(name);
    if (it_prev != macros_.end()) {
        for (const auto& l : it_prev->second.body_lines) {
            for (const auto& t : l) {
                prev_text += t.text;
            }
        }
    }

    // Tokenize RHS and perform pure text substitution for identifier tokens equal to name
    std::vector<MacroToken> rhs_tokens = tokenize_macro_body(rhs);
    std::string new_body_text;
    for (const auto& tok : rhs_tokens) {
        if (tok.type == MacroTokenType::Identifier && tok.text == name) {
            // paste previous textual value
            new_body_text += prev_text;
        }
        else {
            new_body_text += tok.text;
        }
    }

    // Store as an object-like macro (no params)
    Macro macro;
    macro.params.clear();
    macro.body_lines.push_back(tokenize_macro_body(new_body_text));
    macros_[name] = std::move(macro);

    return true;
}

bool Preprocessor::process_name_define(const char*& p,
                                       const std::string& name) {
    // Skip whitespace before macro body
    skip_whitespace(p);

    // The rest of the line is the macro body
    std::string body = p;
    // Remove trailing whitespace
    body = rtrim(body);

    // Store macro
    Macro macro;
    macro.params.clear();
    macro.body_lines.push_back(tokenize_macro_body(body));
    macros_[name] = macro;
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
    for (const auto& l : macro.body_lines) {
        for (const auto& t : l) {
            macro_body += t.text;
        }
    }
    return expand_macros(macro_body, recursion_depth + 1);
}

// Helper: Expand a function-like macro invocation
std::string Preprocessor::expand_function_macro(const Macro& macro,
        const std::vector<MacroToken>& tokens,
        size_t& i, int recursion_depth) {
    size_t j = 0;
    std::vector<std::string> args;
    if (!parse_macro_args(tokens, i + 1, j, args, recursion_depth)) {
        return tokens[i].text; // Not a macro call
    }

    std::string expanded = expand_macro_with_args(macro, args,
                           recursion_depth + 1);
    // j is the index of the token *after* the closing ')'.
    // Set i to j-1 so the outer for-loop's ++i advances to j (first token after ')'),
    // avoiding skipping that token (previously the token after ')' was lost).
    i = (j > 0) ? j - 1 : 0;
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
                if (macro.is_function_like()) {
                    // function-like macro
                    if (macro.is_multi_line()) {
                        // collect prefix text already accumulated on this logical line (preserve labels / leading text)
                        std::string prefix;
                        for (const auto& s : output) {
                            prefix += s;
                        }
                        output.clear();

                        // multi-line function-like macro: expand by creating a virtual input file (pass prefix)
                        std::string res = expand_multiline_macro_invocation(
                                              tok.text, macro, tokens, i, recursion_depth, prefix);
                        if (res.empty()) {
                            // virtual file pushed -> stop inline expansion and propagate sentinel (empty string)
                            return res;
                        }
                        else {
                            output.push_back(res);
                        }
                        continue;
                    }
                    else {
                        // single-line function-like macro (expand inline)
                        output.push_back(expand_function_macro(
                                             macro, tokens, i, recursion_depth));
                        continue;
                    }
                }
                else {
                    // object-like macro
                    if (macro.is_multi_line()) {
                        // collect prefix text already accumulated on this logical line (preserve labels / leading text)
                        std::string prefix;
                        for (const auto& s : output) {
                            prefix += s;
                        }
                        output.clear();

                        // multi-line object-like macro -> push virtual file (pass prefix)
                        std::string res = expand_multiline_object_macro_invocation(
                                              tok.text, macro, tokens, i, recursion_depth, prefix);
                        if (res.empty()) {
                            // virtual file pushed -> propagate sentinel (empty string) upward
                            return res;
                        }
                        else {
                            output.push_back(res);
                        }
                        continue;
                    }
                    else {
                        // single-line object-like macro
                        output.push_back(expand_object_macro(
                                             macro, recursion_depth));
                        continue;
                    }
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

    return trim(result);
}

std::string Preprocessor::expand_multiline_macro_invocation(
    const std::string& name,
    const Macro& macro,
    const std::vector<MacroToken>& tokens,
    size_t& i,
    int recursion_depth,
    const std::string& prefix) {

    // Parse argument list using the shared helper
    size_t j = 0;
    std::vector<std::string> args;
    if (!parse_macro_args(tokens, i + 1, j, args, recursion_depth)) {
        // Not a macro call; just return identifier text
        return tokens[i].text;
    }
    // j is index after ')'
    // We'll consume the remainder of the tokens as a suffix to be processed
    // after the macro expansion. Advance caller index to the end so the
    // parent will not try to process the trailing tokens.
    size_t suffix_start = j;
    i = tokens.size(); // mark as consumed in caller

    // Build parameter map for named params (function-like macro)
    auto param_map = make_param_map(macro, args);

    // Create unique suffix for this expansion, and build rename map for LOCALs
    int uniq_id = ++macro_expansion_counter_;
    auto local_renames = make_local_rename_map(macro, uniq_id);

    // Determine a physical_line_num to associate with virtual lines:
    int phys_line_num = get_invocation_physical_line_num();

    // Combine parameter map and local renames (locals override any same-named params)
    auto combined_param_map = param_map; // copy
    for (const auto& kv : local_renames) {
        combined_param_map[kv.first] = kv.second;
    }

    // For each logical body line, skip LOCAL directive lines and build expanded text
    auto virt_lines = build_virt_lines_from_macro(macro, combined_param_map,
                      phys_line_num);

    // Apply caller-provided prefix (text before the macro on the same logical line)
    apply_prefix_to_virt_lines(virt_lines, prefix);

    // Build suffix string (may be empty)
    std::string suffix;
    if (suffix_start < tokens.size()) {
        for (size_t k = suffix_start; k < tokens.size(); ++k) {
            suffix += tokens[k].text;
        }
        suffix = trim(suffix);
    }

    // Push files in the canonical order using the new helper
    push_macro_and_suffix_files(name, uniq_id, std::move(virt_lines), suffix,
                                phys_line_num);

    // Indicate to caller that we've pushed a macro file; caller should stop inline expansion
    return std::string();
}

std::string Preprocessor::expand_multiline_object_macro_invocation(
    const std::string& name,
    const Macro& macro,
    const std::vector<MacroToken>& tokens,
    size_t& i,
    int /*recursion_depth*/,
    const std::string& prefix) {
    // Build empty param map (object-like macros have no params)
    auto param_map = make_param_map(macro, std::vector<std::string>());

    // Determine where trailing tokens start (after the identifier)
    size_t suffix_start = i + 1;
    // mark as consumed for caller so parent doesn't process trailing tokens
    i = tokens.size();

    // Create unique suffix for this expansion and build rename map for LOCALs
    int uniq_id = ++macro_expansion_counter_;
    auto local_renames = make_local_rename_map(macro, uniq_id);

    // Determine a physical_line_num to associate with virtual lines:
    int phys_line_num = get_invocation_physical_line_num();

    // Combine parameter map and local renames (locals override any same-named params)
    auto combined_param_map = param_map; // copy
    for (const auto& kv : local_renames) {
        combined_param_map[kv.first] = kv.second;
    }

    // For each logical body line, skip LOCAL directive lines and build expanded text
    auto virt_lines = build_virt_lines_from_macro(macro, combined_param_map,
                      phys_line_num);

    // Apply caller-provided prefix (text before the macro on the same logical line)
    apply_prefix_to_virt_lines(virt_lines, prefix);

    // Build suffix string (may be empty)
    std::string suffix;
    if (suffix_start < tokens.size()) {
        for (size_t k = suffix_start; k < tokens.size(); ++k) {
            suffix += tokens[k].text;
        }
        suffix = trim(suffix);
    }

    // Push files in the canonical order using the new helper
    push_macro_and_suffix_files(name, uniq_id, std::move(virt_lines), suffix,
                                phys_line_num);

    // Indicate to caller that we've pushed a macro file; caller should stop inline expansion
    return std::string();
}

// Collect all identifiers declared by LOCAL directives in the macro body.
// Returns them in order of appearance.
std::vector<std::string> Preprocessor::collect_local_names(
    const Macro& macro) const {
    std::vector<std::string> local_names;
    for (const auto& body_line : macro.body_lines) {
        // find first non-space token
        size_t t = 0;
        while (t < body_line.size() &&
                body_line[t].type == MacroTokenType::Punctuator &&
                body_line[t].text == " ") {
            ++t;
        }
        if (t < body_line.size() &&
                body_line[t].type == MacroTokenType::Identifier &&
                to_keyword(body_line[t].text) == Keyword::LOCAL) {
            // collect following identifiers (comma separated)
            ++t;
            while (t < body_line.size()) {
                // skip spaces
                while (t < body_line.size() &&
                        body_line[t].type == MacroTokenType::Punctuator &&
                        body_line[t].text == " ") {
                    ++t;
                }
                if (t < body_line.size() &&
                        body_line[t].type == MacroTokenType::Identifier) {
                    local_names.push_back(body_line[t].text);
                    ++t;
                }
                // skip comma/space tokens
                while (t < body_line.size() &&
                        body_line[t].type == MacroTokenType::Punctuator &&
                        (body_line[t].text == " " || body_line[t].text == ",")) {
                    ++t;
                }
            }
        }
    }
    return local_names;
}

// Create a map from local identifier -> unique renamed identifier using uniq_id.
// Ensures same local name maps to same unique name.
std::unordered_map<std::string, std::string> Preprocessor::make_local_rename_map(
    const Macro& macro, int uniq_id) const {
    std::unordered_map<std::string, std::string> renames;
    auto local_names = collect_local_names(macro);
    for (const auto& ln : local_names) {
        if (renames.find(ln) == renames.end()) {
            renames[ln] = ln + "_" + std::to_string(uniq_id);
        }
    }
    return renames;
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
    return trim((result));
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
            split_lines.push_back(trim((current)));
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
                current = trim(current);
                if (!current.empty()) {
                    split_lines.push_back(current);
                }
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
    current = trim(current);
    if (!current.empty()) {
        split_lines.push_back(current);
    }
}

// Process multi-line macro definition:
// Syntax: MACRO name [ (param,...) | param1, param2, ... ]
// The lines up to ENDM (directive) are stored tokenized as body_lines.
bool Preprocessor::process_macro(const char*& p, Location& location) {
    skip_whitespace(p);

    // Parse macro name
    std::string name;
    if (!scan_identifier(p, name)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed MACRO directive (missing name)");
        return true;
    }

    // Parse parameters: support both '(a,b,...)' or 'a,b,...' forms
    std::vector<std::string> params;
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
    else {
        // Try simple comma separated identifiers until end-of-line
        const char* q = p;
        while (true) {
            skip_whitespace(q);
            std::string param;
            if (!scan_identifier(q, param)) {
                break;
            }
            params.push_back(param);
            skip_whitespace(q);
            if (*q == ',') {
                ++q;
                continue;
            }
            break;
        }
    }

    // Now read lines from the current input file until ENDM is found.
    if (file_stack_.empty()) {
        reporter_.error(location, ErrorCode::FileNotFound,
                        "Internal: no input file during MACRO definition");
        return true;
    }

    InputFile& file = file_stack_.back();
    Macro macro;
    macro.params = params;

    while (file.line_index < file.lines.size()) {
        // Prepare a temporary location for the line being read (informative)
        int physical_line_num = file.lines[file.line_index].physical_line_num;
        if (file.line_directive_active) {
            file.location.set_logical_line_num(
                file.line_directive_value,
                file.line_directive_physical_line,
                physical_line_num);
        }
        else {
            file.location.set_physical_line_num(physical_line_num);
        }
        Location line_location = file.location;
        line_location.set_source_line(file.lines[file.line_index].text);

        std::string raw = remove_comments(file);
        if (raw.empty()) {
            continue;
        }

        // Check for ENDM directive
        const char* rp = raw.c_str();
        Keyword kw;
        if (is_directive(rp, kw) && kw == Keyword::ENDM) {
            // Macro definition ended.
            macros_[name] = std::move(macro);
            return true;
        }

        // Tokenize line and examine
        std::vector<MacroToken> tokens = tokenize_macro_body(raw);

        // Tokenize line and store as one macro body logical line
        macro.body_lines.push_back(std::move(tokens));
    }

    // If we reach EOF without ENDM, report error but store macro anyway
    reporter_.error(location, ErrorCode::InvalidSyntax,
                    "Missing ENDM for MACRO " + name);
    macros_[name] = std::move(macro);
    return true;
}

std::string Preprocessor::expand_macro_with_args(
    const Macro& macro,
    const std::vector<std::string>& args,
    int recursion_depth) {
    // Build parameter map
    std::unordered_map<std::string, std::string> param_map;
    for (size_t idx = 0; idx < macro.params.size(); ++idx) {
        param_map[macro.params[idx]] = (idx < args.size()) ? args[idx] : std::string();
    }

    // Use first logical line for single-line macros (process_macro stores single-line #define bodies here)
    if (macro.body_lines.empty()) {
        return std::string();
    }

    const std::vector<MacroToken>& tokens = macro.body_lines.front();
    std::string out;

    for (size_t i = 0; i < tokens.size(); ++i) {
        const MacroToken& tok = tokens[i];

        // Stringize operator: '#' followed by an identifier/parameter
        if (tok.type == MacroTokenType::Operator && tok.text == "#") {
            if (i + 1 < tokens.size()) {
                const MacroToken& next = tokens[++i];
                if (next.type == MacroTokenType::Identifier && param_map.count(next.text)) {
                    out += stringify(param_map.at(next.text));
                }
                else {
                    // If not a parameter, stringize token text
                    out += stringify(next.text);
                }
            }
            continue;
        }

        // Token pasting '##'
        if (tok.type == MacroTokenType::Operator && tok.text == "##") {
            // remove trailing space from output if present
            while (!out.empty() && out.back() == ' ') {
                out.pop_back();
            }

            // find next non-space token
            size_t j = i + 1;
            while (j < tokens.size() && tokens[j].type == MacroTokenType::Punctuator
                    && tokens[j].text == " ") {
                ++j;
            }

            if (j < tokens.size()) {
                const MacroToken& nt = tokens[j];
                std::string rhs;
                if (nt.type == MacroTokenType::Identifier && param_map.count(nt.text)) {
                    rhs = param_map.at(nt.text);
                }
                else {
                    rhs = nt.text;
                }

                out += rhs;
                i = j; // advance to consumed token
            }
            continue;
        }

        // Whitespace punctuator - keep as-is (unless pasting removed it)
        if (tok.type == MacroTokenType::Punctuator && tok.text == " ") {
            out += ' ';
            continue;
        }

        // Identifier: substitute parameter if present
        if (tok.type == MacroTokenType::Identifier && param_map.count(tok.text)) {
            out += param_map.at(tok.text);
            continue;
        }

        // Default: copy token text
        out += tok.text;
    }

    // After substitution, recursively expand any macros produced
    return expand_macros(out, recursion_depth + 1);
}

std::unordered_map<std::string, std::string> Preprocessor::make_param_map(
    const Macro& macro,
    const std::vector<std::string>& args) {
    std::unordered_map<std::string, std::string> param_map;
    param_map.reserve(macro.params.size());
    for (size_t i = 0; i < macro.params.size(); ++i) {
        if (i < args.size()) {
            param_map[macro.params[i]] = args[i];
        }
        else {
            param_map[macro.params[i]] = std::string();
        }
    }
    return param_map;
}

void Preprocessor::expand_macro_token_with_args(
    const std::unordered_map<std::string, std::string>& param_map,
    const std::vector<MacroToken>& body_tokens,
    size_t& i,
    std::vector<std::string>& output) const {
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
    else if (tok.type == MacroTokenType::Operator &&
             tok.text == "##") {
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

// Helper: compute the physical line number of the invocation (the logical line that triggered the expansion).
// remove_comments() advances the InputFile::line_index after consuming the logical line, so the invocation's
// physical line lives at index (line_index - 1).
int Preprocessor::get_invocation_physical_line_num() const {
    if (file_stack_.empty()) {
        return 0;
    }
    const InputFile& curr = file_stack_.back();
    if (curr.line_index > 0 && curr.line_index <= curr.lines.size()) {
        return curr.lines[curr.line_index - 1].physical_line_num;
    }
    else if (!curr.lines.empty()) {
        return curr.lines.back().physical_line_num;
    }
    return 0;
}

// Build virtual logical lines for a macro using combined_param_map and a physical line number.
std::vector<Preprocessor::LogicalLine>
Preprocessor::build_virt_lines_from_macro(
    const Macro& macro,
    const std::unordered_map<std::string, std::string>& combined_param_map,
    int phys_line_num) const {
    std::vector<LogicalLine> virt_lines;
    virt_lines.reserve(macro.body_lines.size());

    for (const auto& body_line : macro.body_lines) {
        // detect LOCAL directive line and skip it
        size_t t = 0;
        while (t < body_line.size() &&
                body_line[t].type == MacroTokenType::Punctuator &&
                body_line[t].text == " ") {
            ++t;
        }
        if (t < body_line.size() &&
                body_line[t].type == MacroTokenType::Identifier &&
                to_keyword(body_line[t].text) == Keyword::LOCAL) {
            continue; // don't emit LOCAL lines
        }

        std::vector<std::string> parts;
        parts.reserve(body_line.size());
        for (size_t k = 0; k < body_line.size(); ++k) {
            expand_macro_token_with_args(combined_param_map, body_line, k, parts);
        }

        // join parts and trim
        std::string joined;
        for (const auto& p : parts) {
            joined += p;
        }
        joined = trim(joined);

        virt_lines.push_back(LogicalLine{ joined, phys_line_num });
    }

    return virt_lines;
}

// Push a virtual InputFile constructed from virt_lines for macro expansion.
void Preprocessor::push_virtual_macro_file(const std::string& name,
        int uniq_id,
        std::vector<LogicalLine>&& virt_lines) {
    InputFile virt;
    virt.filename = "<macro:" + name + ":" + std::to_string(uniq_id) + ">";
    virt.lines = std::move(virt_lines);
    virt.line_index = 0;
    virt.location = Location(virt.filename, 0);
    // Virtual macro files should not advance the parent's logical line counter.
    virt.location.set_increment_line_numbers(false);
    virt.line_directive_active = false;
    virt.is_macro_expansion = true;

    file_stack_.push_back(std::move(virt));
}

// Parse macro argument list starting at tokens[start_index].
// Returns true if a parenthesized argument list was parsed; out_index is set to the
// token index after ')' and out_args is filled with expanded argument strings.
bool Preprocessor::parse_macro_args(const std::vector<MacroToken>& tokens,
                                    size_t start_index,
                                    size_t& out_index,
                                    std::vector<std::string>& out_args,
                                    int recursion_depth) {
    out_args.clear();
    size_t j = start_index;

    // Skip initial whitespace punctuators
    while (j < tokens.size() &&
            tokens[j].type == MacroTokenType::Punctuator &&
            tokens[j].text == " ") {
        ++j;
    }

    // Expect '('
    if (j >= tokens.size() ||
            tokens[j].type != MacroTokenType::Punctuator ||
            tokens[j].text != "(") {
        return false; // not a call
    }
    ++j; // skip '('

    std::string arg;
    int paren_depth = 1;
    for (; j < tokens.size() && paren_depth > 0; ++j) {
        const MacroToken& tk = tokens[j];

        if (tk.type == MacroTokenType::Punctuator && tk.text == "(") {
            ++paren_depth;
            arg += tk.text;
        }
        else if (tk.type == MacroTokenType::Punctuator && tk.text == ")") {
            --paren_depth;
            if (paren_depth == 0) {
                out_args.push_back(expand_macros(arg, recursion_depth + 1));
                ++j; // advance to token after ')'
                break;
            }
            else {
                arg += tk.text;
            }
        }
        else if (tk.type == MacroTokenType::Punctuator && tk.text == ","
                 && paren_depth == 1) {
            out_args.push_back(expand_macros(arg, recursion_depth + 1));
            arg.clear();
        }
        else {
            arg += tk.text;
        }
    }

    out_index = j; // index of token after ')' (or tokens.size() if unterminated)
    return true;
}

// Apply a prefix to the virtual lines produced by a macro expansion.
// If both prefix and first virtual line are non-empty and neither end/start with a space,
// insert a single separating space.
void Preprocessor::apply_prefix_to_virt_lines(std::vector<LogicalLine>&
        virt_lines,
        const std::string& prefix) const {
    std::string pre = trim(prefix);
    if (pre.empty() || virt_lines.empty()) {
        return;
    }
    std::string& first = virt_lines[0].text;
    bool need_space = !first.empty() && pre.back() != ' ' && first.front() != ' ';
    std::string combined = pre;
    if (need_space) {
        combined += ' ';
    }
    combined += first;
    first = combined;
}

// New helper: push macro virtual file and optional suffix virtual file (suffix processed after macro)
void Preprocessor::push_macro_and_suffix_files(const std::string& name,
        int uniq_id,
        std::vector<LogicalLine>&& virt_lines,
        const std::string& suffix,
        int phys_line_num) {
    // virt_lines are expected to already have the caller prefix applied.
    // If a suffix is present, push a suffix virtual InputFile first (so it is processed after macro).
    if (!suffix.empty()) {
        InputFile suffix_virt;
        int suf_id = ++macro_expansion_counter_;
        suffix_virt.filename = "<suffix:" + std::to_string(suf_id) + ">";
        suffix_virt.lines.push_back(LogicalLine{ suffix, phys_line_num });
        suffix_virt.line_index = 0;
        suffix_virt.location = Location(suffix_virt.filename, 0);
        suffix_virt.location.set_increment_line_numbers(false);
        suffix_virt.line_directive_active = false;
        suffix_virt.is_macro_expansion = false;
        file_stack_.push_back(std::move(suffix_virt));
    }

    // Now push the macro virtual file (will be processed immediately)
    push_virtual_macro_file(name, uniq_id, std::move(virt_lines));
}
