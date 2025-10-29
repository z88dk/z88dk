//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
//
// PSEUDOCODE / PLAN (detailed):
// - Fix incorrect use of TokenType::Newline inside TokensLine handling.
// - TokensLine represents one full input line and does NOT include a newline token.
// - Replace all logic that removes/relies on trailing Newline tokens with logic that
//   removes trailing Whitespace tokens instead (for trimming macro bodies).
// - Remove insertion of artificial Newline tokens when preparing argument TokensLine
//   for recursive expansion; simply pass the TokensLine as-is to expand_macros.
// - When copying tokens from expanded argument lines or macro replacement lines,
//   do not skip tokens based on TokenType::Newline (they no longer exist). Copy all tokens.
// - When a macro expansion yields multiple TokensLine results, append the first
//   line's tokens into the current output `out`, and for each subsequent expanded
//   line push the current `out` to `result` and start a fresh `out` initialized
//   with the tokens of that expanded line.
// - At the end of processing an input line, push `out` into `result` (no newline token).
// - Replace all occurrences of checks/removals for TokenType::Newline with loops
//   that remove trailing TokenType::Whitespace tokens.
// - Keep recursion guards and other logic unchanged except for newline handling.
//
// Implementation notes:
// - Use while-loop to pop trailing whitespace tokens from body_tokens.
// - When building `expanded_args_flat`, do not append a Newline token to argument lines.
// - Copy all tokens from expanded argument lines during parameter substitution.
// - When merging multi-line expansion results, use result.push_back(out) and reinitialize `out`
//   with the subsequent expanded line's tokens (no inserted newline tokens).
// - Ensure behavior still returns one TokensLine per logical output line.
//
// The rest of the file is the original code with the above fixes applied.

#include "options.h"
#include "preprocessor.h"
#include "utils.h"
#include <algorithm>
#include <cassert>
#include <fstream>
#include <sstream>

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

void Preprocessor::push_binary_file(const std::string& bin_filename) {
    // Try to open the binary file. If we fail, fall back to push_file so the
    // normal file-not-found handling (and error messages) still apply.
    std::ifstream ifs(bin_filename, std::ios::binary);
    if (!ifs) {
        g_errors.error(ErrorCode::FileNotFound,
                       "Could not read file: " + bin_filename);
        return;
    }

    // Read all bytes
    std::vector<unsigned char> bytes((std::istreambuf_iterator<char>(ifs)),
                                     std::istreambuf_iterator<char>());

    // Determine logical filename and starting line number from the top file on stack.
    std::string virt_filename = bin_filename;
    int first_line_num = 1;
    if (!file_stack_.empty()) {
        File& top = file_stack_.back();
        // logical filename: prefer forced filename if set, otherwise the tokens_file filename
        if (top.has_forced_location) {
            if (!top.forced_filename.empty()) {
                virt_filename = top.forced_filename;
            }
            else {
                virt_filename = top.tokens_file.filename();
            }

            if (top.forced_constant_line_numbers) {
                first_line_num = top.forced_start_line_num;
            }
            else {
                // At the moment process_binary is called, the file's line_index has
                // already been incremented past the directive line. Use the physical
                // index of the directive (line_index - 1) so the generated virtual
                // file maps to the same logical line as the directive.
                int physical_index = top.line_index < 1 ? 0 : top.line_index - 1;
                int offset = physical_index - top.forced_from_index;
                first_line_num = top.forced_start_line_num + offset;
            }
        }
        else {
            virt_filename = top.tokens_file.filename();
            // As above, use the physical index of the directive (line_index - 1)
            // so the virtual file lines share the directive's logical line.
            int physical_index = top.line_index < 1 ? 0 : top.line_index - 1;
            first_line_num = top.tokens_file.first_line_num() + physical_index;
        }
    }

    // Build virtual file content: DEFB lines, up to 16 bytes per line.
    std::ostringstream oss;
    const size_t BYTES_PER_LINE = 16;
    for (size_t i = 0; i < bytes.size(); i += BYTES_PER_LINE) {
        size_t end = std::min(bytes.size(), i + BYTES_PER_LINE);
        oss << "DEFB ";
        for (size_t j = i; j < end; ++j) {
            if (j != i) {
                oss << ",";
            }
            oss << static_cast<int>(bytes[j]);
        }
        oss << "\n";
    }

    std::string content = oss.str();
    // Push the generated virtual file with the computed logical location.
    push_virtual_file(content, virt_filename, first_line_num);
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
        unsigned i = 0;
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

void Preprocessor::define_macro(const std::string& name,
                                const std::vector<TokensLine>& replacement) {
    Macro m;
    m.replacement = replacement;
    m.params.clear();
    m.is_function = false;
    macros_[name] = std::move(m);
}

void Preprocessor::expect_end(const TokensLine& line, unsigned i) const {
    skip_spaces(line, i);
    if (i < line.size()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected token: '" + line[i].text() + "'");
    }
}

void Preprocessor::skip_spaces(const TokensLine& line, unsigned& i) const {
    while (i < line.size() && line[i].is(TokenType::Whitespace)) {
        ++i;
    }
}

bool Preprocessor::parse_params_list(const TokensLine& line, unsigned& i,
                                     std::vector<std::string>& out_params
                                    ) const {
    out_params.clear();
    unsigned j = i;
    skip_spaces(line, j);

    // Optional surrounding parentheses
    bool has_paren = false;
    if (j < line.size() && line[j].is(TokenType::LeftParen)) {
        has_paren = true;
        ++j; // consume '('
    }

    // If we have immediate ')' it's an empty list
    skip_spaces(line, j);
    if (has_paren && j < line.size() && line[j].is(TokenType::RightParen)) {
        ++j; // consume ')'
        i = j;
        return true;
    }

    // Parse zero or more identifiers separated by commas
    bool expect_ident = true;
    while (j < line.size()) {
        skip_spaces(line, j);
        if (expect_ident) {
            if (j < line.size() && line[j].is(TokenType::Identifier)) {
                out_params.push_back(line[j].text());
                ++j;
                expect_ident = false;
                continue;
            }
            else {
                // Nothing valid found where an identifier was expected
                return false;
            }
        }
        else {
            // after an identifier: expect comma or closing parenthesis (if any) or stop
            if (j < line.size() && line[j].is(TokenType::Comma)) {
                ++j; // consume comma and expect next identifier
                expect_ident = true;
                continue;
            }
            if (has_paren) {
                skip_spaces(line, j);
                if (j < line.size() && line[j].is(TokenType::RightParen)) {
                    ++j; // consume ')'
                    i = j;
                    return true;
                }
                // neither comma nor ')' -> syntax error
                return false;
            }
            // no parentheses: stop parsing here (we successfully parsed the list)
            break;
        }
    }

    // If we exit loop normally:
    if (expect_ident) {
        // ended while expecting an identifier (e.g., trailing comma)
        return false;
    }

    // Commit consumed index
    i = j;
    return true;
}

// Parse macro argument list (optionally enclosed in parentheses).
// Behavior:
//  - Accept either parenthesized args "(a,b,...)" or unparenthesized args until end-of-line.
//  - Arguments are separated by commas at top-level (commas inside nested parentheses are part of an argument).
//  - An empty args list is accepted: either "()" or end-of-input (no tokens).
//  - Trailing comma (e.g. "a,b,") is considered a syntax error and returns false.
// On success returns true, sets i to the token index after the consumed argument list (after ')' if any, or end index),
// and fills out_args with one TokensLine per argument (arguments preserve tokens, including whitespace).
bool Preprocessor::parse_macro_args(const TokensLine& line, unsigned& i,
                                    std::vector<TokensLine>& out_args) {
    out_args.clear();
    unsigned j = i;
    skip_spaces(line, j);

    bool has_paren = false;
    if (j < line.size() && line[j].is(TokenType::LeftParen)) {
        has_paren = true;
        ++j; // consume '('
    }

    // If parenthesized and immediate ')' -> empty list
    skip_spaces(line, j);
    if (has_paren && j < line.size() && line[j].is(TokenType::RightParen)) {
        ++j; // consume ')'
        i = j;
        return true;
    }

    std::vector<Token> cur_arg;
    int depth = 0; // nested parentheses depth inside an argument
    bool last_was_comma = false;
    bool saw_any = false;

    auto commit_arg_trimmed = [&](bool push_empty_if_none) {
        // Trim TokenType::Whitespace from start and end of cur_arg and push as TokensLine
        unsigned s = 0;
        unsigned e = static_cast<unsigned>(cur_arg.size());
        while (s < e && cur_arg[s].is(TokenType::Whitespace)) {
            ++s;
        }
        while (e > s && cur_arg[e - 1].is(TokenType::Whitespace)) {
            --e;
        }
        TokensLine arg(line.location());
        for (unsigned k = s; k < e; ++k) {
            arg.push_back(cur_arg[k]);
        }
        if (push_empty_if_none || !arg.empty()) {
            out_args.push_back(arg);
        }
    };

    while (j < line.size()) {
        const Token& t = line[j];

        // Handle top-level closing paren for parenthesized lists
        if (has_paren && t.is(TokenType::RightParen) && depth == 0) {
            // commit current argument (trimmed)
            commit_arg_trimmed(true);
            cur_arg.clear();
            ++j; // consume ')'
            i = j;
            return true;
        }

        // Handle comma separators at top-level
        if (t.is(TokenType::Comma) && depth == 0) {
            // commit current argument (may be empty, keep it)
            commit_arg_trimmed(true);
            cur_arg.clear();
            last_was_comma = true;
            saw_any = true;
            ++j; // consume comma
            continue;
        }

        // Normal token processing:
        // adjust depth when seeing parentheses
        if (t.is(TokenType::LeftParen)) {
            depth++;
        }
        else if (t.is(TokenType::RightParen)) {
            if (depth > 0) {
                depth--;
            }
            // otherwise this right-paren will be handled above if it's a top-level closer
        }

        // append token to current arg
        cur_arg.push_back(t);
        last_was_comma = false;
        saw_any = true;
        ++j;
    }

    // We reached end-of-line/input
    if (has_paren) {
        // missing closing ')'
        return false;
    }

    // If the last processed top-level token was a comma, it's a trailing comma -> error
    if (last_was_comma) {
        return false;
    }

    // If we saw no tokens at all (unparenthesized end-of-input), accept empty args list
    if (!saw_any) {
        i = j;
        return true;
    }

    // commit final argument (trimmed)
    commit_arg_trimmed(true);
    cur_arg.clear();
    i = j;
    return true;
}

// Parse common LINE/C_LINE argument forms: <linenum> [ , "filename" ]
bool Preprocessor::parse_line_args(const TokensLine& line, unsigned& i,
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
        // Accept quoted or plain filename after comma.
        bool is_angle = false;
        if (!parse_filename(line, i, out_filename, is_angle)) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           std::string("Expected filename after comma in ") + directive_name +
                           " directive");
            return false;
        }
    }

    expect_end(line, i);

    return true;
}

bool Preprocessor::parse_filename(const TokensLine& line, unsigned& i,
                                  std::string& out_filename, bool& out_is_angle) const {
    skip_spaces(line, i);
    out_filename.clear();
    out_is_angle = false;

    if (i < line.size() && line[i].is(TokenType::String)) {
        out_filename = line[i].string_value();
        const std::string txt = line[i].text();
        if (!txt.empty() && txt.front() == '<') {
            out_is_angle = true;
        }
        ++i;
        return true;
    }

    // Plain filename: consume tokens up to whitespace
    std::string filename;
    while (i < line.size() && line[i].is_not(TokenType::Whitespace)) {
        filename += line[i].text();
        ++i;
    }
    if (filename.empty()) {
        return false;
    }
    out_filename = filename;
    out_is_angle = false;
    return true;
}

bool Preprocessor::is_directive(const TokensLine& line,
                                unsigned& i, Keyword& keyword) const {
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

bool Preprocessor::is_name_directive(const TokensLine& line, unsigned& i,
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

void Preprocessor::process_directive(const TokensLine& line, unsigned& i,
                                     Keyword keyword) {
    switch (keyword) {
    case Keyword::INCLUDE:
        process_include(line, i);
        break;
    case Keyword::BINARY:
    case Keyword::INCBIN:
        process_binary(line, i);
        break;
    case Keyword::LINE:
        process_line(line, i);
        break;
    case Keyword::C_LINE:
        process_c_line(line, i);
        break;
    case Keyword::DEFINE:
        process_define(line, i);
        break;
    case Keyword::UNDEF:
        process_undef(line, i);
        break;
    default:
        assert(0);
    }
}

void Preprocessor::process_name_directive(const TokensLine& line,
        unsigned& i,
        Keyword keyword,
        const std::string& name) {
    // Handle directives of the form: <name> <directive> ...
    switch (keyword) {
    case Keyword::DEFINE:
        process_name_define(line, i, name);
        break;
    case Keyword::UNDEF:
        process_name_undef(line, i, name);
        break;
    default:
        assert(0);
    }
}

void Preprocessor::process_include(const TokensLine& line, unsigned& i) {
    // Reuse filename parsing helper. Plain and quoted forms are both accepted.
    std::string filename;
    bool is_angle = false;
    if (!parse_filename(line, i, filename, is_angle)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected filename in include directive");
        return;
    }

    expect_end(line, i);
    do_include(filename, is_angle);
}

void Preprocessor::do_include(const std::string& filename,
                              bool is_angle) {
    // Use centralized search helper so callers (include/binary/etc.) all use
    // the same include-path resolution logic. search_include_path now
    // returns a non-empty filename (resolved path or the original candidate).
    std::string resolved = search_include_path(filename, is_angle);
    push_file(resolved);
}

std::string Preprocessor::search_include_path(const std::string& filename,
        bool is_angle) const {
    // Wrapper for include resolution. Centralizes search logic so callers
    // (process_include/do_include/process_binary) all use the same routine.
    // Return the resolved path if found; otherwise return the original filename
    // so callers can simply assign the result and proceed.
    std::string resolved = resolve_include_candidate(filename, is_angle);
    if (resolved.empty()) {
        return filename;
    }
    else {
        return resolved;
    }
}

void Preprocessor::process_binary(const TokensLine& line, unsigned& i) {
    // Accept quoted or plain filename for BINARY/INCBIN.
    std::string filename;
    bool is_angle = false;
    if (!parse_filename(line, i, filename, is_angle)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected filename in BINARY/INCBIN directive");
        return;
    }

    expect_end(line, i);
    do_binary(filename, is_angle);
}

void Preprocessor::do_binary(const std::string& filename, bool is_angle) {
    // Resolve include-path candidates first so BINARY/INCBIN honor include
    // search directories the same way #include does.
    std::string resolved = search_include_path(filename, is_angle);
    // Push a virtual file containing DEFB directives with the binary bytes.
    push_binary_file(resolved);
}

void Preprocessor::process_line(const TokensLine& line, unsigned& i) {
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

void Preprocessor::process_c_line(const TokensLine& line, unsigned& i) {
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

void Preprocessor::process_define(const TokensLine& line, unsigned& i) {
    // #define form: parse name and body after directive
    skip_spaces(line, i);
    if (!(i < line.size() && line[i].is(TokenType::Identifier))) {
        g_errors.error(ErrorCode::InvalidSyntax, "Expected identifier after DEFINE");
        return;
    }
    std::string name = line[i].text();
    ++i;

    // Determine if function-like: must have '(' immediately after name (no space)
    bool has_args = false;
    std::vector<std::string> params;
    if (i < line.size() && line[i].is(TokenType::LeftParen)) {
        // '(' is immediate -> function-like macro. Delegate parsing to parse_params_list,
        // which will advance `i` past the parameter list on success.
        has_args = true;
        if (!parse_params_list(line, i, params)) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           "Invalid macro parameter list");
            return;
        }
    }

    // Delegate the remaining common work to do_define (consumes rest of line)
    do_define(line, i, name, has_args, params);
}

void Preprocessor::process_name_define(const TokensLine& line, unsigned& i,
                                       const std::string& name) {
    // name define ...  -> treat as "#define name ..." (object-like)
    // In the name-directive form the '(' would appear after the directive token;
    // for simplicity assume name define (no function params) in this form.
    unsigned j = i;

    // Delegate the remaining common work to do_define using local index j.
    bool has_args = false;
    std::vector<std::string> params;
    do_define(line, j, name, has_args, params);

    // advance caller index past what we consumed
    i = j;
}

void Preprocessor::do_define(const TokensLine& line, unsigned& i,
                             const std::string& name, bool has_args,
                             const std::vector<std::string>& params) {
    skip_spaces(line, i);

    // collect body tokens (rest of line)
    std::vector<Token> body_tokens;
    while (i < line.size()) {
        // collect body tokens (including whitespace); will trim trailing whitespace below
        body_tokens.push_back(line[i]);
        ++i;
    }
    // remove trailing whitespace tokens if present in body_tokens
    while (!body_tokens.empty() && body_tokens.back().is(TokenType::Whitespace)) {
        body_tokens.pop_back();
    }

    // Build replacement TokensLine(s)
    TokensLine rep;
    rep.set_location(line.location());
    for (const Token& t : body_tokens) {
        rep.push_back(t);
    }

    // If nothing in body, replace it with integer token '1'
    if (rep.empty()) {
        rep.push_back(Token(TokenType::Integer, "1", 1));
    }

    Macro macro;
    macro.is_function = has_args;
    macro.params = params;
    macro.replacement.clear();
    macro.replacement.push_back(rep);
    macros_[name] = std::move(macro);
}

void Preprocessor::process_undef(const TokensLine& line, unsigned& i) {
    skip_spaces(line, i);
    if (!(i < line.size() && line[i].is(TokenType::Identifier))) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after UNDEF");
    }
    else {
        std::string name = line[i].text();
        ++i;
        do_undef(name, line, i);
    }
}

void Preprocessor::process_name_undef(const TokensLine& line, unsigned& i,
                                      const std::string& name) {
    // In the "<name> UNDEF" form the identifier to remove is provided as `name`.
    // Delegate the remainder to the shared do_undef helper.
    do_undef(name, line, i);
}

void Preprocessor::do_undef(const std::string& name, const TokensLine& line,
                            unsigned& i) {
    // common trailing UNDEF logic: validate end-of-line and remove macro entries
    expect_end(line, i);
    macros_.erase(name);
    macro_recursion_count_.erase(name);
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
    unsigned i = 0;

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
                               const TokensLine& expanded, unsigned& i) {

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

// ------------------- Refactored helpers for expand_macros --------------------

bool Preprocessor::is_macro_call(const TokensLine& in_line, unsigned idx,
                                 const Macro& macro,
                                 unsigned& args_start_idx) const {
    args_start_idx = idx + 1;
    if (macro.params.size() != 0 && args_start_idx < in_line.size()) {
        const Token& nextTok = in_line[args_start_idx];
        if (nextTok.is(TokenType::LeftParen)) {
            return true;
        }
    }
    return false;
}

// Parse macro args and expand each argument (expand macros inside arguments).
// On success: fills expanded_args_flat with one TokensLine per argument (first line of expansion or empty line),
// sets out_after_idx to index after consumed args and returns true.
// Also fills out_original_args with the trimmed original (unexpanded, trimmed) TokensLine for each arg
// (used for '#' stringizing). On failure returns false (syntax error).
bool Preprocessor::parse_and_expand_macro_args(const TokensLine& in_line,
        unsigned args_start_idx,
        std::vector<TokensLine>& expanded_args_flat,
        std::vector<TokensLine>& out_original_args,
        unsigned& out_after_idx) {
    unsigned j = args_start_idx;
    std::vector<TokensLine> parsed_args;
    if (!parse_macro_args(in_line, j, parsed_args)) {
        return false;
    }

    expanded_args_flat.clear();
    out_original_args.clear();

    for (const TokensLine& argline : parsed_args) {
        // keep original trimmed argument tokens for '#' stringize operator
        out_original_args.push_back(argline);

        // expand macros inside argument (we only keep the first expanded logical line)
        std::vector<TokensLine> expanded = expand_macros(std::vector<TokensLine> { argline });
        if (!expanded.empty()) {
            expanded_args_flat.push_back(expanded.front());
        }
        else {
            TokensLine emptyline(in_line.location());
            expanded_args_flat.push_back(emptyline);
        }
    }

    out_after_idx = j;
    return true;
}

// Helper: handle '#' stringize operator in macro replacement.
// If `rep_line[pidx]` is '#' followed by a parameter identifier, produces
// the corresponding string token into `new_line`, advances `pidx` past
// both tokens and returns true. Otherwise returns false and does not
// modify `new_line` or `pidx`.
bool Preprocessor::try_stringize_parameter(const TokensLine& rep_line,
        unsigned& pidx,
        const Macro& macro,
        const std::vector<TokensLine>& original_args,
        TokensLine& new_line) {
    // Expect '#' at pidx (caller ensures this), confirm next token exists and is identifier.
    if (!(pidx < rep_line.size() && rep_line[pidx].is(OperatorType::Hash))) {
        return false;
    }
    if (pidx + 1 >= rep_line.size()) {
        return false;
    }
    const Token& next = rep_line[pidx + 1];
    if (!next.is(TokenType::Identifier)) {
        return false;
    }

    // Find matching parameter name
    for (unsigned pi = 0; pi < macro.params.size(); ++pi) {
        if (next.text() == macro.params[pi]) {
            // Build stringized argument from original_args[pi]
            const TokensLine& orig = original_args[pi];

            // Collapse whitespace tokens into a single space and join token texts.
            std::string joined;
            bool pending_space = false;
            for (unsigned k = 0; k < orig.size(); ++k) {
                const Token& tok = orig[k];
                if (tok.is(TokenType::Whitespace)) {
                    pending_space = true;
                    continue;
                }
                if (!joined.empty() && pending_space) {
                    joined += ' ';
                }
                joined += tok.text();
                pending_space = false;
            }

            // Escape and quote
            std::string escaped = escape_string(joined);
            std::string quoted_text = std::string("\"") + escaped + std::string("\"");

            // Create a string token: text with quotes/escapes, string_value as unescaped joined
            new_line.push_back(Token(TokenType::String, quoted_text, joined));

            // consume both '#' and the identifier
            pidx += 2;
            return true;
        }
    }

    // Not a parameter -> not handled here
    return false;
}

// Substitute parameters into macro replacement and then expand the substituted result.
// Returns the fully expanded replacement (may be multiple TokensLine elements).
// Supports the '#' operator via try_stringize_parameter above.
std::vector<TokensLine> Preprocessor::substitute_and_expand(
    const Macro& macro,
    const std::vector<TokensLine>& expanded_args_flat,
    const std::vector<TokensLine>& original_args,
    const std::string& name) {
    // Perform textual parameter substitution
    std::vector<TokensLine> substituted;
    for (const TokensLine& rep_line : macro.replacement) {
        TokensLine new_line(rep_line.location());
        unsigned pidx = 0;
        while (pidx < rep_line.size()) {
            const Token& rt = rep_line[pidx];
            bool substituted_flag = false;

            // Handle stringize operator: '#' followed by parameter identifier
            if (rt.is(OperatorType::Hash)) {
                if (try_stringize_parameter(rep_line, pidx, macro, original_args, new_line)) {
                    // handled and pidx advanced inside helper
                    continue;
                }
                // If not handled (not followed by a matching param), fall through to copy '#'
                new_line.push_back(rt);
                ++pidx;
                continue;
            }

            // Normal parameter substitution: identifier matching a parameter
            if (rt.is(TokenType::Identifier)) {
                for (unsigned pi = 0; pi < macro.params.size(); ++pi) {
                    if (rt.text() == macro.params[pi]) {
                        const TokensLine& argline = expanded_args_flat[pi];
                        for (unsigned at = 0; at < argline.size(); ++at) {
                            const Token& atok = argline[at];
                            new_line.push_back(atok);
                        }
                        substituted_flag = true;
                        break;
                    }
                }
            }
            if (!substituted_flag) {
                new_line.push_back(rt);
            }
            ++pidx;
        }
        substituted.push_back(new_line);
    }

    // Guard recursion while expanding substituted replacement
    int& rc = macro_recursion_count_[name];
    rc++;
    std::vector<TokensLine> further_expanded = expand_macros(substituted);
    rc--;
    return further_expanded;
}

// Append expanded results into `out` and `result` following multi-line semantics.
// first line of further_expanded is merged into current `out`
// each subsequent line causes current `out` to be pushed into `result` and `out` reinitialized
// with that subsequent line.
void Preprocessor::append_expansion_into_out(const std::vector<TokensLine>&
        further_expanded,
        TokensLine& out,
        std::vector<TokensLine>& result,
        const Location& in_location) {
    if (further_expanded.empty()) {
        return;
    }

    // append first line tokens into out
    const TokensLine& first = further_expanded.front();
    for (unsigned kk = 0; kk < first.size(); ++kk) {
        out.push_back(first[kk]);
    }

    // for remaining lines: push current out, then start new out with the expanded line
    for (unsigned rr = 1; rr < further_expanded.size(); ++rr) {
        result.push_back(out);
        out = TokensLine(in_location);
        const TokensLine& el = further_expanded[rr];
        for (unsigned kk = 0; kk < el.size(); ++kk) {
            out.push_back(el[kk]);
        }
    }
}

// ------------------- expand_macros (refactored) -------------------------------

// Expand macros in-place according to simple C-like semantics described.
// This implementation supports object-like and function-like macros (no varargs),
// expands macro parameters before substitution, and prevents infinite recursion
// using macro_recursion_count_. Returned TokensLine objects represent logical lines.
std::vector<TokensLine> Preprocessor::expand_macros(
    const std::vector<TokensLine>& lines) {

    std::vector<TokensLine> result;

    for (const TokensLine& in_line : lines) {
        // We'll produce exactly one output TokensLine per input line (preserve lines).
        TokensLine out(in_line.location());
        unsigned idx = 0;

        while (idx < in_line.size()) {
            const Token& tok = in_line[idx];

            // If token isn't an identifier, copy it and continue.
            if (!tok.is(TokenType::Identifier)) {
                out.push_back(tok);
                ++idx;
                continue;
            }

            std::string name = tok.text();
            auto mit = macros_.find(name);
            if (mit == macros_.end()) {
                // not a macro
                out.push_back(tok);
                ++idx;
                continue;
            }

            // Found macro
            Macro& macro = mit->second;

            // Recursion guard for this macro
            int& rc = macro_recursion_count_[name];
            if (rc >= MAX_MACRO_RECURSION) {
                g_errors.error(ErrorCode::MacroRecursionLimit,
                               "Macro recursion limit reached for: " + name);
                // emit original identifier literally
                out.push_back(tok);
                ++idx;
                continue;
            }

            // Determine if this is a function-like call (immediate '(')
            unsigned args_start_idx = 0;
            bool is_call = is_macro_call(in_line, idx, macro, args_start_idx);

            if (macro.params.size() != 0 && is_call) {
                // parse and expand args
                std::vector<TokensLine> expanded_args_flat;
                std::vector<TokensLine> original_args;
                unsigned after_idx = 0;
                if (!parse_and_expand_macro_args(in_line,
                                                 args_start_idx,
                                                 expanded_args_flat,
                                                 original_args,
                                                 after_idx)) {
                    // syntax error in args -> treat as plain identifier
                    out.push_back(tok);
                    ++idx;
                    continue;
                }

                // Validate argument count
                if (expanded_args_flat.size() != macro.params.size()) {
                    g_errors.error(ErrorCode::InvalidSyntax,
                                   "Macro argument count mismatch for: " + name);
                    out.push_back(tok);
                    ++idx;
                    continue;
                }

                // Substitute parameters and expand the replacement (handles nested macros)
                std::vector<TokensLine> further_expanded =
                    substitute_and_expand(macro,
                                          expanded_args_flat,
                                          original_args,
                                          name);

                // Append expanded result into out/result following multi-line rules
                append_expansion_into_out(further_expanded, out, result, in_line.location());

                // advance idx past args
                idx = after_idx;
            }
            else if (macro.params.empty()) {
                // Object-like macro
                // Copy replacement and expand (with recursion guard)
                std::vector<TokensLine> substituted = macro.replacement;

                rc++;
                std::vector<TokensLine> further_expanded = expand_macros(substituted);
                rc--;

                append_expansion_into_out(further_expanded, out, result, in_line.location());

                // consume the identifier token
                ++idx;
            }
            else {
                // macro has params but not invoked as call -> treat as identifier literal
                out.push_back(tok);
                ++idx;
            }
        } // end scanning tokens of a line

        // Push the resulting logical line (TokensLine represents a whole line; no newline token)
        result.push_back(out);
    }

    return result;
}

