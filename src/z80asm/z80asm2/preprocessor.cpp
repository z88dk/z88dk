//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "expr.h"
#include "keywords.h"
#include "lexer.h"
#include "preprocessor.h"
#include <algorithm>
#include <cassert>
#include <cctype>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <functional>
#include <regex>
#include <sstream>
#include <stack>

// Forward-declare the file-local helper so member functions that call it
// (e.g. resolve_include_path) can be defined earlier in the file.
static std::string resolve_include_candidate(const std::string& filename,
        bool is_angle,
        const std::vector<std::string>& include_paths,
        const std::string& current_dir);

Preprocessor::Preprocessor(ErrorReporter& reporter)
    : reporter_(reporter) {
}

void Preprocessor::add_include_path(const std::string& path) {
    // Store as given; resolution will use std::filesystem when searching.
    include_paths_.push_back(path);
}

bool Preprocessor::open(const std::string& filename) {
    file_stack_.clear();
    macros_.clear();
    split_queue_.clear();
    if_stack_.clear();

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
                    // Treat both LINE and C_LINE specially so we can persist the
                    // directive into the InputFile (like #line) and also handle
                    // C_LINE's "don't increment" behaviour here.
                    if (keyword == Keyword::LINE ||
                            keyword == Keyword::C_LINE) {
                        if (process_directive(keyword, p, out_location)) {
                            // #line / #c_line directive: update file.location
                            // for future lines
                            file.location = out_location;
                            file.line_directive_active = true;
                            // Track the value and physical line for #line / #c_line
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

                // If any enclosing IF is inactive, skip rest of processing
                if (!ifs_all_active()) {
                    continue;
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
                    // logical line number for next line (unless disabled in Location)
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

// Resolve an include/binary filename using include paths and the current file directory.
// Returns the resolved normalized absolute path or empty string if not found.
std::string Preprocessor::resolve_include_path(const std::string& filename,
        bool is_angle) const {
    // Determine current include directory (directory of the file that contains the directive)
    std::string current_dir;
    if (!file_stack_.empty()) {
        try {
            std::filesystem::path pf(file_stack_.back().filename);
            current_dir = pf.parent_path().string();
        }
        catch (...) {
            current_dir.clear();
        }
    }
    return resolve_include_candidate(filename, is_angle, include_paths_,
                                     current_dir);
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
    // Convert filename to a canonical absolute form when possible to improve
    // recursive-include detection and diagnostics. If filesystem operations
    // fail, fall back to the original string.
    std::string resolved = filename;
    try {
        std::filesystem::path p(filename);
        if (!p.is_absolute()) {
            p = std::filesystem::absolute(p);
        }
        // Lexically normalize to remove ../ etc.
        resolved = p.lexically_normal().string();
    }
    catch (...) {
        // ignore filesystem errors, keep original filename
        resolved = filename;
    }

    // Check for recursive include using the new member function
    if (is_recursive_include(resolved)) {
        reporter_.error(ErrorCode::RecursiveInclude, filename);
        return;
    }

    // read the whole file
    std::vector<LogicalLine> lines;
    if (read_file(resolved, lines)) {
        InputFile file;
        file.filename = resolved;
        file.lines = std::move(lines);
        file.line_index = 0;
        file.location = Location(resolved, 0);
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

    // Control directives related to conditional compilation must always be
    // processed so nesting is tracked even when outer branches are inactive.
    if (keyword_is_conditional_directive(keyword)) {
        switch (keyword) {
        case Keyword::IF:
            return process_if(p, location);
        case Keyword::IFDEF:
            return process_ifdef(p, location);
        case Keyword::IFNDEF:
            return process_ifndef(p, location);
        case Keyword::ELIF:
            return process_elif(p, location);
        case Keyword::ELIFDEF:
            return process_elifdef(p, location);
        case Keyword::ELIFNDEF:
            return process_elifndef(p, location);
        case Keyword::ELSE:
            return process_else(p, location);
        case Keyword::ENDIF:
            return process_endif(p, location);
        default:
            assert(0);
            return false; // not reached
        }
    }

    // If any enclosing IF is inactive, skip non-control directives and lines.
    if (!ifs_all_active()) {
        // We still need to consume/ignore the directive line. Returning true
        // signals to the caller that the directive was handled (skipped).
        return true;
    }

    // now check the other directives
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
    case Keyword::C_LINE:
        return process_c_line(p, location);
    case Keyword::MACRO:
        return process_macro(p, location);
    case Keyword::REPT:
        return process_rept(p, location);
    case Keyword::REPTC:
        return process_reptc(p, location);
    case Keyword::REPTI:
        return process_repti(p, location);
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
    case Keyword::BINARY:
    case Keyword::INCBIN:
        return process_binary(p, location);
    default:
        assert(0);
        return false; // not reached
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

// Helper: scan a filename (quoted "file" or <file> or unquoted token) from p.
// Advances p past the filename and returns true on success. Does not report errors.
// Also returns via out_angle whether the include used angle brackets "<...>".
static bool scan_filename_from_p(const char*& p, std::string& out_filename,
                                 bool& out_angle) {
    const char* start = p;
    skip_whitespace(p);
    out_filename.clear();
    out_angle = false;

    if (*p == '"' || *p == '<') {
        char open = *p++;
        char close = (open == '"') ? '"' : '>';
        out_angle = (open == '<');
        while (*p && *p != close) {
            out_filename += *p++;
        }
        if (*p == close) {
            ++p; // skip closing quote/bracket
        }
    }
    else {
        // Unquoted filename: read until whitespace
        const char* q = p;
        while (*q && !isspace(static_cast<unsigned char>(*q))) {
            ++q;
        }
        out_filename.assign(p, q - p);
        p = q;
    }

    out_filename = trim(out_filename);
    if (out_filename.empty()) {
        p = start; // restore on failure
        return false;
    }
    return true;
}

// Helper: try candidates according to include semantics and include_paths_,
// return resolved path if found or empty string if not found.
static std::string resolve_include_candidate(const std::string& filename,
        bool is_angle,
        const std::vector<std::string>& include_paths,
        const std::string& current_dir) {
    namespace fs = std::filesystem;

    std::vector<fs::path> candidates;

    fs::path fname(filename);
    // If the filename is absolute, try it directly
    if (fname.is_absolute()) {
        candidates.push_back(fname);
    }
    else {
        // For quoted includes: search current file directory first, then include_paths, then CWD
        if (!is_angle) {
            if (!current_dir.empty()) {
                candidates.push_back(fs::path(current_dir) / fname);
            }
            for (const auto& p : include_paths) {
                candidates.push_back(fs::path(p) / fname);
            }
            candidates.push_back(fs::current_path() / fname);
            candidates.push_back(fname); // finally try as given (relative to caller)
        }
        else {
            // For angle includes: search include_paths, then CWD, then as-given
            for (const auto& p : include_paths) {
                candidates.push_back(fs::path(p) / fname);
            }
            candidates.push_back(fs::current_path() / fname);
            candidates.push_back(fname);
        }
    }

    for (const auto& c : candidates) {
        try {
            fs::path norm = c;
            // Do not require file to be accessible by canonical (it may throw), use exists
            if (fs::exists(norm) && fs::is_regular_file(norm)) {
                try {
                    // Prefer lexically_normal absolute path
                    if (!norm.is_absolute()) {
                        norm = fs::absolute(norm);
                    }
                    return norm.lexically_normal().string();
                }
                catch (...) {
                    return norm.string();
                }
            }
        }
        catch (...) {
            // ignore path errors and move on
        }
    }

    return std::string();
}

bool Preprocessor::process_include(const char*& p, Location& location) {
    skip_whitespace(p);

    std::string filename;
    bool is_angle = false;
    if (!scan_filename_from_p(p, filename, is_angle)) {
        reporter_.error(location, ErrorCode::InvalidSyntax, "Empty INCLUDE filename");
        return true;
    }

    // Resolve using include search semantics (current file dir, include paths, CWD, etc.)
    std::string resolved = resolve_include_path(filename, is_angle);

    if (resolved.empty()) {
        // Not found -> report using original filename (as before)
        reporter_.error(location, ErrorCode::FileNotFound, filename);
        return true;
    }

    push_file(resolved);
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

    return process_name_define(p, name, params);
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

    // Parse optional filename using the shared helper (quoted, <...> or unquoted token)
    std::string filename;
    bool is_angle = false;
    // filename is optional; we ignore the return value - on failure `p` is restored
    scan_filename_from_p(p, filename, is_angle);

    if (new_line > 0) {
        location.set_line_num(new_line);
    }
    if (!filename.empty()) {
        location.set_filename(filename);
    }

    return true;
}

bool Preprocessor::process_c_line(const char*& p, Location& location) {
    skip_whitespace(p);

    // Parse line number
    int new_line = 0;
    if (!scan_integer(p, new_line)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed C_LINE directive (missing line number)");
        return true;
    }

    skip_whitespace(p);

    // Parse optional filename using the shared helper (quoted, <...> or unquoted token)
    std::string filename;
    bool is_angle = false;
    // filename is optional; we ignore the return value - on failure `p` is restored
    scan_filename_from_p(p, filename, is_angle);

    if (new_line > 0) {
        location.set_line_num(new_line);
    }
    if (!filename.empty()) {
        location.set_filename(filename);
    }

    // C_LINE: disable incrementing logical line numbers while in effect.
    // Do not modify file_stack_ here; next_line's directive handling will
    // persist the Location into the InputFile (and we handle disabling there).
    location.set_increment_line_numbers(false);

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

    // special case "foo = 42"
    skip_whitespace(p);
    if (*p == '=') {
        ++p; // skip '='
        keyword = Keyword::EQU;
        return true;
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
        return process_name_define(p, name, {});
    case Keyword::MACRO:
        return process_name_macro(p, name);
    case Keyword::REPTC:
        return process_name_reptc(p, name);
    case Keyword::REPTI:
        return process_name_repti(p, name);
    case Keyword::EQU:
        return process_name_equ(p, name);
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
                                       const std::string& name,
                                       std::vector<std::string> params) {

    // scan optional '=' for compatibility
    skip_whitespace(p);
    if (*p == '=') {
        ++p; // skip '='
    }

    // The rest of the line is the macro body
    std::string body = p;

    // Remove whitespace
    body = trim(body);

    p = body.c_str();
    int value = 0;

    if (body.empty()) {
        body = "1"; // default body
    }
    else if (eval_const_expr(p, value) && *p == '\0') {
        body = std::to_string(value);
    }
    else {
        // keep body as is
    }

    // Store macro
    Macro macro;
    macro.params = params;
    macro.body_lines.push_back(tokenize_macro_body(body));
    macros_[name] = macro;
    return true;
}

// Handle "name MACRO ..." alternative syntax.
bool Preprocessor::process_name_macro(const char*& p, const std::string& name) {
    // p is positioned after the 'MACRO' token already.
    skip_whitespace(p);

    // Parse parameters using the shared helpers
    std::vector<std::string> params;
    const char* after_directive = p;
    skip_whitespace(p);
    if (*p == '(' && after_directive == p) {
        if (!parse_param_list_parenthesized(p, params)) {
            if (!file_stack_.empty()) {
                reporter_.error(file_stack_.back().location, ErrorCode::InvalidSyntax,
                                "Malformed MACRO parameter list (name-first form)");
            }
            return true;
        }
    }
    else {
        parse_param_list_comma_separated(p, params);
    }

    if (file_stack_.empty()) {
        reporter_.error(ErrorCode::FileNotFound,
                        "Internal: no input file during MACRO definition (name-first)");
        return true;
    }

    Macro macro;
    macro.params = params;

    read_macro_body(macro);
    macros_[name] = std::move(macro);
    // read_macro_body already reports missing ENDM if it reached EOF.
    return true;
}

bool Preprocessor::process_name_reptc(const char*& p, const std::string& name) {
    static Location dummy_location;
    return do_reptc_common(p, &name,
                           file_stack_.empty() ?
                           dummy_location :
                           file_stack_.back().location);
}

bool Preprocessor::process_name_repti(const char*& p, const std::string& name) {
    static Location dummy_location;
    return do_repti_common(p, &name,
                           file_stack_.empty() ?
                           dummy_location :
                           file_stack_.back().location);
}

bool Preprocessor::process_name_equ(const char*& p, const std::string& name) {
    // p is positioned after the directive token (either after 'EQU' or after '=')
    skip_whitespace(p);

    // Capture RHS (rest of logical line) and trim trailing whitespace
    std::string rhs = p;
    rhs = rtrim(rhs);

    // Determine location for error reporting if needed
    Location loc;
    bool have_loc = false;
    if (!file_stack_.empty()) {
        loc = file_stack_.back().location;
        have_loc = true;
    }

    if (rhs.empty()) {
        if (have_loc) {
            reporter_.error(loc, ErrorCode::InvalidSyntax,
                            "Malformed EQU directive (missing RHS)");
        }
        else {
            reporter_.error(ErrorCode::InvalidSyntax,
                            "Malformed EQU directive (missing RHS)");
        }
        return true;
    }

    // Expand macros in RHS. If expansion returns empty (e.g. pushed a virtual file),
    // fall back to the original RHS so we still produce a DEFC line.
    std::string expanded = expand_macros(rhs);
    if (expanded.empty()) {
        expanded = rhs;
    }
    expanded = trim(expanded);

    // Build DEFC line: "DEFC name = <expanded>"
    std::string defc_line = std::string("DEFC ") + name + "=" + expanded;

    // Create a small virtual input file that yields the DEFC line so the rest of the
    // preprocessor pipeline (location tracking, splitting, etc.) handles it uniformly.
    InputFile virt;
    int uniq_id = ++macro_expansion_counter_;
    virt.filename = "<EQU:" + name + ":" + std::to_string(uniq_id) + ">";
    int phys_line_num = get_invocation_physical_line_num();
    virt.lines.push_back(LogicalLine{ defc_line, phys_line_num });
    virt.line_index = 0;
    virt.location = Location(virt.filename, 0);
    // Do not advance the parent's logical line number when this virtual file is processed.
    virt.location.set_increment_line_numbers(false);
    virt.line_directive_active = false;
    virt.is_macro_expansion = false;

    file_stack_.push_back(std::move(virt));
    return true;
}

// Helper: parse a parenthesized parameter list. Expects p at '(' and advances past ')'.
bool Preprocessor::parse_param_list_parenthesized(const char*& p,
        std::vector<std::string>& params) {
    if (*p != '(') {
        return false;
    }
    ++p; // consume '('
    while (true) {
        skip_whitespace(p);
        if (*p == ')') {
            ++p; // consume ')'
            break;
        }
        std::string param;
        if (!scan_identifier(p, param)) {
            return false;
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
    return true;
}

// Helper: parse comma-separated identifiers until a non-identifier is seen.
void Preprocessor::parse_param_list_comma_separated(const char*& p,
        std::vector<std::string>& params) {
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
    p = q;
}

// Helper: read macro body lines `macro` until ENDM directive or EOF.
bool Preprocessor::read_macro_body(Macro& macro) {
    // Reuse centralized raw-block reader to collect logical lines up to ENDM.
    std::vector<LogicalLine> raw_lines;
    bool found_end = read_raw_block_until(Keyword::ENDM, raw_lines);

    // Tokenize each collected raw logical line into macro body tokens.
    for (const auto& ll : raw_lines) {
        std::vector<MacroToken> tokens = tokenize_macro_body(ll.text);
        macro.body_lines.push_back(std::move(tokens));
    }

    // If the terminating ENDM was not found, read_raw_block_until already reported
    // the missing terminator. Propagate failure to the caller.
    return found_end;
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
    bool in_multiline_comment = false;

    while (file.line_index < file.lines.size()) {
        const std::string& line = file.lines[file.line_index].text;
        std::vector<MacroToken> tokens = tokenize_macro_body(line);
        for (size_t i = 0; i < tokens.size(); ++i) {
            if (!in_multiline_comment) {
                if (i + 1 < tokens.size() &&
                        tokens[i].type == MacroTokenType::Punctuator &&
                        tokens[i].text == "/" &&
                        tokens[i + 1].type == MacroTokenType::Punctuator &&
                        tokens[i + 1].text.front() == '*') {    // may be "*" or "**"
                    std::string rest;
                    for (size_t j = i; j < tokens.size(); ++j) {
                        rest += tokens[j].text;
                    }
                    rest = rest.substr(2);
                    size_t end_pos = rest.find("*/");
                    if (end_pos != std::string::npos) {
                        rest = rest.substr(end_pos + 2);
                        tokens = tokenize_macro_body(rest);
                        i = -1; // will become 0 in next loop iteration
                        in_multiline_comment = false;
                    }
                    else {
                        // Entire rest of line is in comment
                        in_multiline_comment = true;
                        break;
                    }
                }
                else if (i + 1 < tokens.size() &&
                         tokens[i].type == MacroTokenType::Punctuator &&
                         tokens[i].text == "/" &&
                         tokens[i + 1].type == MacroTokenType::Punctuator &&
                         tokens[i + 1].text == "/") {
                    break;
                }
                else if (tokens[i].type == MacroTokenType::Punctuator &&
                         tokens[i].text == ";") {
                    break;
                }
                else {
                    result += tokens[i].text;
                }
            }
            else {
                std::string rest;
                for (size_t j = i; j < tokens.size(); ++j) {
                    rest += tokens[j].text;
                }
                size_t end_pos = rest.find("*/");
                if (end_pos != std::string::npos) {
                    rest = rest.substr(end_pos + 2);
                    tokens = tokenize_macro_body(rest);
                    i = -1; // will become 0 in next loop iteration
                    in_multiline_comment = false;
                }
                else {
                    // Entire rest of line is in comment
                    break;
                }
            }
        }

        ++file.line_index;
        if (!in_multiline_comment) {
            break;
        }
    }
    return trim((result));
}

// Splits a labbel at the start of the line to its own split_lines entry
// Returns the text after the label.
static std::string split_label(const std::string& line,
                               std::vector<std::string>& split_lines) {
    const char* p = line.c_str();
    std::string ident;

    skip_whitespace(p);
    if (*p == '.') {
        ++p; // eat dot
        if (scan_label(p, ident)) {
            split_lines.push_back("." + ident);
            return std::string(p);
        }
    }
    if (scan_label(p, ident)) {
        skip_whitespace(p);
        if (*p == ':') {
            ++p; // eat colon
            split_lines.push_back("." + ident);
            return std::string(p);
        }
    }

    return line;
}

void Preprocessor::split_lines(const std::string& line,
                               std::vector<std::string>& split_lines) {
    split_lines.clear();
    std::string current;
    int ternary_depth = 0;
    std::string rest = split_label(line, split_lines);
    std::vector<MacroToken> tokens = tokenize_macro_body(rest);
    for (size_t i = 0; i < tokens.size(); ++i) {
        const MacroToken& tok = tokens[i];
        if (tok.type == MacroTokenType::Punctuator &&
                tok.text == "?") {
            ++ternary_depth;
            current += tok.text;
        }
        else if (tok.type == MacroTokenType::Punctuator &&
                 tok.text == ":") {
            if (ternary_depth > 0) {
                --ternary_depth;
                current += tok.text;
            }
            else {
                current = trim(current);
                if (!current.empty()) {
                    split_lines.push_back(current);
                }
                current.clear();
            }
        }
        else if (tok.type == MacroTokenType::Punctuator &&
                 tok.text == "\\") {
            current = trim(current);
            if (!current.empty()) {
                split_lines.push_back(current);
            }
            current.clear();
        }
        else if (tok.type == MacroTokenType::StringLiteral) {
            std::string bytes = unescape_string(tok.text);
            for (size_t i = 0; i < bytes.size(); ++i) {
                int c = static_cast<unsigned char>(bytes[i]);
                if (i > 0) {
                    current += ",";
                }
                current += std::to_string(c);
            }
        }
        else {
            current += tok.text;
        }
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

    // Parse parameters: support both '(a,b,...)' or 'a,b,...' forms.
    std::vector<std::string> params;
    const char* after_name = p;
    skip_whitespace(p);
    if (*p == '(' && after_name == p) {
        // Parenthesized form with no whitespace between name and '('
        if (!parse_param_list_parenthesized(p, params)) {
            reporter_.error(location, ErrorCode::InvalidSyntax,
                            "Malformed macro parameter list");
            return true;
        }
    }
    else {
        // Comma-separated identifiers (name-first style) - look ahead and advance `p`.
        parse_param_list_comma_separated(p, params);
    }

    // Now read lines from the current input file until ENDM is found.
    if (file_stack_.empty()) {
        reporter_.error(location, ErrorCode::FileNotFound,
                        "Internal: no input file during MACRO definition");
        return true;
    }

    Macro macro;
    macro.params = params;

    // Delegate the body-read to helper
    read_macro_body(macro);
    macros_[name] = std::move(macro);
    // read_macro_body already reports missing ENDM if it reached EOF.
    return true;
}

bool Preprocessor::process_binary(const char*& p, Location& location) {
    skip_whitespace(p);

    std::string filename;
    bool is_angle = false;
    if (!scan_filename_from_p(p, filename, is_angle)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed BINARY/INCBIN directive (missing filename)");
        return true;
    }

    // Resolve binary path using the same semantics as include (current file dir, include paths, CWD, etc.)
    std::string resolved = resolve_include_path(filename, is_angle);
    if (resolved.empty()) {
        reporter_.error(location, ErrorCode::FileNotFound, filename);
        return true;
    }

    // Try to open binary file using resolved path
    std::ifstream in(resolved.c_str(), std::ios::binary);
    if (!in) {
        // Report file-not-found using location for context
        reporter_.error(location, ErrorCode::FileNotFound, resolved);
        return true;
    }

    // Read file contents
    in.seekg(0, std::ios::end);
    std::streamsize filesize = in.tellg();
    in.seekg(0, std::ios::beg);

    std::vector<unsigned char> data;
    if (filesize > 0) {
        data.resize(static_cast<size_t>(filesize));
        in.read(reinterpret_cast<char*>(data.data()), filesize);
    }

    // If no data, nothing to emit
    if (data.empty()) {
        return true;
    }

    // Build DEFB lines: 16 bytes per line, decimal values separated by commas (no spaces).
    int phys_line_num = get_invocation_physical_line_num();
    std::vector<LogicalLine> virt_lines;
    const size_t per_line = 16;
    size_t idx = 0;
    while (idx < data.size()) {
        size_t chunk = std::min(per_line, data.size() - idx);
        std::string line = "DEFB ";
        for (size_t j = 0; j < chunk; ++j) {
            if (j > 0) {
                line += ",";
            }
            line += std::to_string(static_cast<int>(data[idx + j]));
        }
        virt_lines.push_back(LogicalLine{ line, phys_line_num });
        idx += chunk;
    }

    // Push a virtual InputFile for these lines so regular pipeline emits them.
    // Use push_macro_and_suffix_files to keep behavior consistent with other virtual files
    // and ensure the resulting Location.filename() is the invoking file.
    int uniq_id = ++macro_expansion_counter_;
    // Include resolved path in the internal macro name for traceability, but the Location
    // filename will be set to the invocation file by the helper.
    std::string internal_name = std::string("binary:") + resolved;
    push_macro_and_suffix_files(internal_name, uniq_id, std::move(virt_lines),
                                std::string(), phys_line_num);

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
std::vector<Preprocessor::LogicalLine> Preprocessor::build_virt_lines_from_macro(
    const Macro& macro,
    const std::unordered_map<std::string, std::string>& combined_param_map,
    int phys_line_num
) const {
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
        std::vector<LogicalLine>&& virt_lines,
        const std::string& invocation_filename) {
    InputFile virt;
    virt.filename = "<macro:" + name + ":" + std::to_string(uniq_id) + ">";
    virt.lines = std::move(virt_lines);
    virt.line_index = 0;

    // Initialize location with the virtual filename but override the filename
    // with the invocation filename when available so Location reports the
    // original source file where the macro was invoked.
    virt.location = Location(virt.filename, 0);
    virt.location.set_increment_line_numbers(false);
    virt.line_directive_active = false;
    virt.is_macro_expansion = true;

    if (!invocation_filename.empty()) {
        virt.location.set_filename(invocation_filename);
    }
    else if (!file_stack_.empty()) {
        // If caller didn't supply invocation_filename, use the current top-of-stack file.
        virt.location.set_filename(file_stack_.back().filename);
    }

    file_stack_.push_back(std::move(virt));
}

// Helper: read raw logical lines until the given end directive
// (e.g. ENDR or ENDM).
// Fills out_lines with raw logical lines (no comment removal
// performed here - each line is obtained by remove_comments which
// advances the current file line_index). Returns true if the end
// directive was found, false on EOF (and reports a missing-end error).
bool Preprocessor::read_raw_block_until(Keyword endDirective,
                                        std::vector<LogicalLine>& out_lines) {
    out_lines.clear();
    if (file_stack_.empty()) {
        return false;
    }
    InputFile& file = file_stack_.back();
    while (file.line_index < file.lines.size()) {
        int physical_line_num = file.lines[file.line_index].physical_line_num;
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

        std::string raw = remove_comments(file);
        if (raw.empty()) {
            continue;
        }

        const char* rp = raw.c_str();
        Keyword kw;
        if (is_directive(rp, kw) && kw == endDirective) {
            // found terminating directive
            return true;
        }

        // store the raw logical line and its physical line number
        out_lines.push_back(LogicalLine{ raw, physical_line_num });
    }

    // EOF reached without endDirective
    std::string name = keyword_to_string(endDirective);
    reporter_.error(file.location, ErrorCode::InvalidSyntax,
                    "Missing " + name);
    return false;
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
    // Capture invocation filename (the file that triggered this macro expansion)
    std::string invocation_filename;
    if (!file_stack_.empty()) {
        invocation_filename = file_stack_.back().filename;
    }

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

        // Record invocation filename for diagnostics on the suffix as well
        if (!invocation_filename.empty()) {
            suffix_virt.location.set_filename(invocation_filename);
        }

        file_stack_.push_back(std::move(suffix_virt));
    }

    // Now push the macro virtual file (will be processed immediately).
    // Pass the invocation filename so the virtual file reports the original source.
    push_virtual_macro_file(name, uniq_id, std::move(virt_lines),
                            invocation_filename);
}

// REPT directive: REPT <count> ... ENDR
// Count must be a constant integer. If not, report error and skip block.
bool Preprocessor::process_rept(const char*& p, Location& location) {
    skip_whitespace(p);

    int count = 0;
    if (!get_constant_value(p, count)) {
        // Non-constant count -> report error and skip until ENDR
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "REPT requires a constant integer count");
        std::vector<LogicalLine> tmp;
        read_raw_block_until(Keyword::ENDR,
                             tmp); // consume block (reports missing ENDR if needed)
        return true;
    }

    // Collect body lines up to ENDR
    std::vector<LogicalLine> body_lines;
    read_raw_block_until(Keyword::ENDR, body_lines);

    // Build virtual lines repeated 'count' times, associating the
    // invocation physical line
    int phys_line_num = get_invocation_physical_line_num();
    std::vector<LogicalLine> virt_lines;
    if (count > 0) {
        virt_lines.reserve(body_lines.size() * static_cast<size_t>(count));
        for (int r = 0; r < count; ++r) {
            for (const auto& ll : body_lines) {
                virt_lines.push_back(LogicalLine{ ll.text, phys_line_num });
            }
        }
    }

    // Push a virtual file for the repeated body
    int uniq_id = ++macro_expansion_counter_;
    push_virtual_macro_file("REPT", uniq_id, std::move(virt_lines));
    return true;
}

bool Preprocessor::process_reptc(const char*& p, Location& location) {
    return do_reptc_common(p, nullptr, location);
}

bool Preprocessor::process_repti(const char*& p, Location& location) {
    return do_repti_common(p, nullptr, location);
}

// Helper: expand macros in the text starting at p and scan the resulting text
// for a constant integer. Returns true and sets 'value' on success.
bool Preprocessor::get_constant_value(const char*& p, int& value) {
    value = 0;

    // Do not modify caller's p. Work on a copy/snapshot of the remaining text.
    const char* pp = p;
    skip_whitespace(pp);
    std::string tail = pp;
    tail = trim(tail);
    if (tail.empty()) {
        return false;
    }

    // Expand any macros in the tail. If expansion requires pushing a virtual file
    // expand_macros will return an empty string; treat that as failure here.
    std::string expanded = expand_macros(tail);
    if (expanded.empty()) {
        return false;
    }

    const char* q = expanded.c_str();
    if (eval_const_expr(q, value) && *q == '\0') {
        return true;
    }

    // Local constant evaluation failed. Ask caller (assembler) via callback, if registered.
    if (eval_callback_) {
        // Determine a best-effort Location for context: use top of file_stack_ if any.
        Location loc;
        if (!file_stack_.empty()) {
            loc = file_stack_.back().location;
        }
        EvalResult res = eval_callback_(expanded, loc);
        if (res.ok) {
            value = res.value;
            return true;
        }
    }

    // If assembler couldn't evaluate, fall through and return false.
    return false;
}

bool Preprocessor::do_reptc_common(const char*& p,
                                   const std::string* name, Location& location) {
    // If name==nullptr: syntax is "REPTC var, arg"
    // If name!=nullptr: syntax is "var REPTC arg" (name holds var)
    skip_whitespace(p);

    std::string var;
    if (name == nullptr) {
        // Expect identifier then comma
        if (!scan_identifier(p, var)) {
            reporter_.error(location, ErrorCode::InvalidSyntax,
                            "Malformed REPTC directive (missing variable name)");
            // try to consume block to avoid resync problems
            std::vector<LogicalLine> tmp;
            read_raw_block_until(Keyword::ENDR, tmp);
            return true;
        }
        skip_whitespace(p);
        if (*p != ',') {
            reporter_.error(location, ErrorCode::InvalidSyntax,
                            "Malformed REPTC directive (missing comma)");
            std::vector<LogicalLine> tmp;
            read_raw_block_until(Keyword::ENDR, tmp);
            return true;
        }
        ++p; // skip comma
    }
    else {
        var = *name;
    }

    // Now parse the argument expression/text starting at p
    const char* q = p;
    skip_whitespace(q);
    if (*q == '\0') {
        // Missing argument -> report error and consume block like REPT handling
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed REPTC directive (missing argument)");
        std::vector<LogicalLine> tmp;
        read_raw_block_until(Keyword::ENDR, tmp);
        return true;
    }

    // Capture the rest of the logical text (p -> end)
    std::string tail = q;
    tail = trim(tail);

    // Expand macros in tail first. If expansion needs to push a virtual file
    // expand_macros may return empty string -> treat as syntax failure.
    std::string expanded = expand_macros(tail);
    if (expanded.empty()) {
        // If expanded is empty but there was input, it might be a macro that expanded to empty.
        // Treat that as empty iteration (no output) but still consume the block.
        std::vector<LogicalLine> body_lines;
        read_raw_block_until(Keyword::ENDR, body_lines);
        return true;
    }

    // Determine the string to iterate over.
    std::string iter_str;
    std::string quoted_str;
    const char* pp = expanded.c_str();
    skip_whitespace(pp);
    if (*pp == '"' && scan_string_literal(pp, quoted_str)) {
        iter_str = unescape_string(quoted_str);
    }
    else {
        iter_str = expanded;
    }

    // Collect body up to ENDR
    std::vector<LogicalLine> body_lines;
    read_raw_block_until(Keyword::ENDR, body_lines);

    // If iter_str is empty -> produces no output (consume block already done)
    if (iter_str.empty()) {
        return true;
    }

    // Build virtual lines. For each character: undef var; define var <code>; then body lines
    int phys_line_num = get_invocation_physical_line_num();
    std::vector<LogicalLine> virt_lines;
    virt_lines.reserve(iter_str.size() * (2 + body_lines.size()));

    for (unsigned char c : iter_str) {
        // #undef var
        std::string uline = std::string("#undef ") + var;
        virt_lines.push_back(LogicalLine{ uline, phys_line_num });

        // #define var <num>
        std::string dline = std::string("#define ") + var + " " + std::to_string(
                                static_cast<int>(c));
        virt_lines.push_back(LogicalLine{ dline, phys_line_num });

        // append body lines
        for (const auto& bl : body_lines) {
            virt_lines.push_back(LogicalLine{ bl.text, phys_line_num });
        }
    }

    // Push a virtual file with these lines
    int uniq_id = ++macro_expansion_counter_;
    push_virtual_macro_file("REPTC", uniq_id, std::move(virt_lines));
    return true;
}

bool Preprocessor::do_repti_common(const char*& p, const std::string* name,
                                   Location& location) {
    // If name==nullptr: syntax is "REPTI var, a, b, c"
    // If name!=nullptr: syntax is "var REPTI a, b, c" (name holds var)
    skip_whitespace(p);

    std::string var;
    if (name == nullptr) {
        // Expect identifier then comma
        if (!scan_identifier(p, var)) {
            reporter_.error(location, ErrorCode::InvalidSyntax,
                            "Malformed REPTI directive (missing variable name)");
            // consume block to stay in sync
            std::vector<LogicalLine> tmp;
            read_raw_block_until(Keyword::ENDR, tmp);
            return true;
        }
        skip_whitespace(p);
        if (*p != ',') {
            // Treat missing list as empty (no iterations) but consume block
            std::vector<LogicalLine> tmp;
            read_raw_block_until(Keyword::ENDR, tmp);
            return true;
        }
        ++p; // skip comma
    }
    else {
        var = *name;
    }

    // Parse remaining text (the list) from p
    const char* q = p;
    skip_whitespace(q);

    // If no list present treat as empty list (consume block and no output)
    if (*q == '\0') {
        std::vector<LogicalLine> tmp;
        read_raw_block_until(Keyword::ENDR, tmp);
        return true;
    }

    // Capture the rest of the logical text (p -> end) and expand macros in it.
    std::string tail = q;
    tail = trim(tail);

    std::string expanded = expand_macros(tail);
    if (expanded.empty()) {
        // Expansion resulted in empty string (e.g. macros expanded to nothing)
        // Consume the block and produce no output.
        std::vector<LogicalLine> tmp;
        read_raw_block_until(Keyword::ENDR, tmp);
        return true;
    }

    // Split expanded list into comma-separated items while respecting strings/parentheses.
    std::vector<std::string> items;
    std::string cur;
    int paren_depth = 0;
    std::vector<MacroToken> tokens = tokenize_macro_body(expanded);
    for (size_t i = 0; i < tokens.size(); ++i) {
        const MacroToken& tok = tokens[i];
        if (tok.type == MacroTokenType::Identifier ||
                tok.type == MacroTokenType::Number ||
                tok.type == MacroTokenType::StringLiteral ||
                tok.type == MacroTokenType::Operator) {
            cur += tok.text;
            continue;
        }

        if (tok.type == MacroTokenType::Punctuator && tok.text == "(") {
            ++paren_depth;
            cur += tok.text;
            continue;
        }

        if (tok.type == MacroTokenType::Punctuator && tok.text == ")") {
            if (paren_depth > 0) {
                --paren_depth;
            }
            cur += tok.text;
            continue;
        }

        if (tok.type == MacroTokenType::Punctuator && tok.text == "," &&
                paren_depth == 0) {
            std::string t = trim(cur);
            items.push_back(t);
            cur.clear();
            continue;
        }

        // default
        cur += tok.text;
    }

    if (!cur.empty()) {
        items.push_back(trim(cur));
    }

    // Read the body lines up to ENDR
    std::vector<LogicalLine> body_lines;
    read_raw_block_until(Keyword::ENDR, body_lines);

    // If no items (empty list) produce no output
    bool any_nonempty = false;
    for (const auto& it : items) {
        if (!it.empty()) {
            any_nonempty = true;
            break;
        }
    }
    if (!any_nonempty) {
        return true;
    }

    // Build virtual lines. For each item: undef var; define var <item>; then body lines
    int phys_line_num = get_invocation_physical_line_num();
    std::vector<LogicalLine> virt_lines;
    // Reserve a reasonable amount
    virt_lines.reserve(items.size() * (2 + body_lines.size()));

    for (const auto& it : items) {
        if (it.empty()) {
            continue; // skip empty elements
        }

        // #undef var
        std::string uline = std::string("#undef ") + var;
        virt_lines.push_back(LogicalLine{ uline, phys_line_num });

        // #define var <item>
        std::string dline = std::string("#define ") + var + " " + it;
        virt_lines.push_back(LogicalLine{ dline, phys_line_num });

        // append body lines
        for (const auto& bl : body_lines) {
            virt_lines.push_back(LogicalLine{ bl.text, phys_line_num });
        }
    }

    // Push a virtual file with these lines
    int uniq_id = ++macro_expansion_counter_;
    push_virtual_macro_file("REPTI", uniq_id, std::move(virt_lines));
    return true;
}

// Return true if every entry on the if_stack_ is currently active.
bool Preprocessor::ifs_all_active() const {
    for (const auto& e : if_stack_) {
        if (!e.active) {
            return false;
        }
    }
    return true;
}

// IF directive: evaluate the expression (macro-expanded) and push an IfEntry.
// If expression cannot be parsed, report a syntax error.
bool Preprocessor::process_if(const char*& p, Location& location) {
    skip_whitespace(p);

    int value = 0;
    if (!get_constant_value(p, value)) {
        // Treat as false (no branch taken) but still push an entry so nesting is correct.
        if_stack_.emplace_back(false, location);
    }
    else {
        bool cond = (value != 0);
        if_stack_.emplace_back(cond, location);
    }
    return true;
}

// ELIF directive: only meaningful if inside an IF. Evaluate expression and
// update the top-of-stack entry accordingly.
bool Preprocessor::process_elif(const char*& p, Location& location) {
    skip_whitespace(p);

    if (if_stack_.empty()) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "unbalanced control structure");
        return true;
    }

    IfEntry& top = if_stack_.back();
    if (top.else_seen) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "ELIF after ELSE");
        return true;
    }

    int value = 0;
    if (!get_constant_value(p, value)) {
        // Ensure current branch inactive if any previous branch already taken.
        if (!top.any_branch_taken) {
            top.active = false;
        }
        else {
            top.active = false;
        }
    }
    else {
        bool cond = (value != 0);
        if (top.any_branch_taken) {
            // a previous branch was true -> this and subsequent branches inactive
            top.active = false;
        }
        else {
            top.active = cond;
            top.any_branch_taken = cond;
        }
    }

    return true;
}

// IFDEF directive: check whether macro name is defined and push an IfEntry.
bool Preprocessor::process_ifdef(const char*& p, Location& location) {
    skip_whitespace(p);

    std::string name;
    if (!scan_identifier(p, name)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed IFDEF directive (missing name)");
        // push a false entry to keep nesting balanced
        if_stack_.emplace_back(false, location);
        return true;
    }

    bool defined = is_name_defined(name, location);
    if_stack_.emplace_back(defined, location);
    return true;
}

// IFNDEF directive: push true when name is not defined.
bool Preprocessor::process_ifndef(const char*& p, Location& location) {
    skip_whitespace(p);

    std::string name;
    if (!scan_identifier(p, name)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed IFNDEF directive (missing name)");
        if_stack_.emplace_back(false, location);
        return true;
    }

    bool defined = is_name_defined(name, location);
    if_stack_.emplace_back(!defined, location);
    return true;
}

// ELIFDEF directive: only meaningful inside an IF. Activate branch if name is defined.
bool Preprocessor::process_elifdef(const char*& p, Location& location) {
    skip_whitespace(p);

    if (if_stack_.empty()) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "unbalanced control structure");
        return true;
    }

    IfEntry& top = if_stack_.back();
    if (top.else_seen) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "ELIFDEF after ELSE");
        return true;
    }

    std::string name;
    if (!scan_identifier(p, name)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed ELIFDEF directive (missing name)");
        // treat as false branch
        top.active = false;
        return true;
    }

    bool defined = is_name_defined(name, location);
    if (top.any_branch_taken) {
        top.active = false;
    }
    else {
        top.active = defined;
        top.any_branch_taken = defined;
    }
    return true;
}

// ELIFNDEF directive: activate when name is not defined and no prior branch taken.
bool Preprocessor::process_elifndef(const char*& p, Location& location) {
    skip_whitespace(p);

    if (if_stack_.empty()) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "unbalanced control structure");
        return true;
    }

    IfEntry& top = if_stack_.back();
    if (top.else_seen) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "ELIFNDEF after ELSE");
        return true;
    }

    std::string name;
    if (!scan_identifier(p, name)) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Malformed ELIFNDEF directive (missing name)");
        top.active = false;
        return true;
    }

    bool defined = is_name_defined(name, location);
    bool cond = !defined;
    if (top.any_branch_taken) {
        top.active = false;
    }
    else {
        top.active = cond;
        top.any_branch_taken = cond;
    }
    return true;
}

// ELSE directive: only meaningful if inside an IF. Toggle active based on previous branches.
bool Preprocessor::process_else(const char*& p, Location& location) {
    (void)p;
    if (if_stack_.empty()) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "unbalanced control structure");
        return true;
    }

    IfEntry& top = if_stack_.back();
    if (top.else_seen) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "Multiple ELSE in conditional");
        return true;
    }

    if (top.any_branch_taken) {
        // some previous branch already taken -> ELSE branch inactive
        top.active = false;
    }
    else {
        top.active = true;
        top.any_branch_taken = true;
    }
    top.else_seen = true;
    return true;
}

// ENDIF directive: pop the if stack. Unbalanced ENDIF reported as error.
bool Preprocessor::process_endif(const char*& p, Location& location) {
    (void)p;
    if (if_stack_.empty()) {
        reporter_.error(location, ErrorCode::InvalidSyntax,
                        "unbalanced control structure");
        return true;
    }
    if_stack_.pop_back();
    return true;
}

// Helper: test whether the given name is considered "defined".
// Returns true if either a preprocessor macro exists or the optional
// assembler-provided symbol-defined callback reports the name as defined.
bool Preprocessor::is_name_defined(const std::string& name,
                                   const Location& loc) const {
    if (macros_.find(name) != macros_.end()) {
        return true;
    }
    if (symbol_defined_callback_) {
        // callback may use Location for diagnostics/context
        return symbol_defined_callback_(name, loc);
    }
    return false;
}
