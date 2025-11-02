//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "expr.h"
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
    f.is_macro_expansion = false;
    file_stack_.push_back(std::move(f));
}

void Preprocessor::push_virtual_file(const std::string& content,
                                     const std::string& filename,
                                     int first_line_num,
                                     bool inc_line_nums) {
    File vf;
    vf.tokens_file = TokensFile(content, filename,
                                first_line_num, inc_line_nums);
    vf.line_index = 0;
    vf.has_forced_location = false;
    vf.forced_constant_line_numbers = false;
    vf.is_macro_expansion = false;
    file_stack_.push_back(std::move(vf));
}

void Preprocessor::push_virtual_file(const std::vector<TokensLine>& tok_lines,
                                     const std::string& filename,
                                     int first_line_num,
                                     bool inc_line_nums) {
    File vf;
    vf.tokens_file = TokensFile(tok_lines, filename,
                                first_line_num, inc_line_nums);
    vf.line_index = 0;
    vf.has_forced_location = false;
    vf.forced_constant_line_numbers = false;
    vf.is_macro_expansion = false;
    file_stack_.push_back(std::move(vf));
}

void Preprocessor::push_binary_file(const std::string& bin_filename,
                                    const Location& location) {

    std::vector<unsigned char> bytes;
    try {
        bytes = read_file_to_bytes(bin_filename);
    }
    catch (...) {
        g_errors.error(ErrorCode::FileNotFound, bin_filename);
        return;
    }

    if (bytes.empty()) {
        return; // nothing to emit
    }

    // Build virtual file content: DEFB lines, up to 16 bytes per line, as pre-tokenized lines.
    std::vector<TokensLine> tok_lines;
    const size_t BYTES_PER_LINE = 16;
    tok_lines.reserve((bytes.size() + BYTES_PER_LINE - 1) / BYTES_PER_LINE);

    for (size_t i = 0; i < bytes.size(); i += BYTES_PER_LINE) {
        size_t end = std::min(bytes.size(), i + BYTES_PER_LINE);

        TokensLine line(location);
        // DEFB <space>
        line.push_back(Token(TokenType::Identifier, "DEFB"));
        line.push_back(Token(TokenType::Whitespace, " "));

        bool first = true;
        for (size_t j = i; j < end; ++j) {
            if (!first) {
                line.push_back(Token(TokenType::Comma, ","));
            }
            first = false;
            int v = static_cast<int>(bytes[j]);
            line.push_back(Token(TokenType::Integer, std::to_string(v), v));
        }

        tok_lines.push_back(std::move(line));
    }

    // Start the generated lines exactly at the directive's logical location, with constant line number.
    push_virtual_file(tok_lines, location.filename(),
                      location.line_num(), false);
}

bool Preprocessor::next_line(TokensLine& line) {
    line.clear();
    while (true) {
        // If we have queued lines, process them as full input (including directives)
        if (!input_queue_.empty()) {
            line = std::move(input_queue_.front());
            input_queue_.pop_front();

            g_errors.set_location(line.location());
            g_errors.set_expanded_line(line.to_string());

            if (line.empty()) {
                continue;
            }

            // Process directives appearing in queued lines
            Keyword keyword = Keyword::None;
            unsigned i = 0;
            if (is_directive(line, i, keyword)) {
                reading_queue_for_directive_ = true;
                process_directive(line, i, keyword);
                reading_queue_for_directive_ = false;
                continue; // consume and continue
            }

            // Process name-directive form from queued lines as well
            std::string name;
            keyword = Keyword::None;
            i = 0;
            if (is_name_directive(line, i, keyword, name)) {
                reading_queue_for_directive_ = true;
                process_name_directive(line, i, keyword, name);
                reading_queue_for_directive_ = false;
                continue; // consume and continue
            }

            // Not a directive -> return this logical line.
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

        // get next line from file (physical or virtual)
        line = file.tokens_file.get_tok_line(file.line_index);
        ++file.line_index;

        // Compute logical location here based on current file mapping.
        // Rules:
        // - If LINE/C_LINE was seen in this file: use forced_filename (if set) and
        //   either constant line (C_LINE) or LINE + (physical_index - forced_from_index)
        // - Otherwise: use file's own filename() and first_line_num() + physical_index
        {
            // true physical line number from source
            const int physical_line = line.location().line_num();

            Location loc = line.location();

            if (file.has_forced_location) {
                if (!file.forced_filename.empty()) {
                    loc.set_filename(file.forced_filename);
                }
                else {
                    loc.set_filename(file.tokens_file.filename());
                }

                if (file.forced_constant_line_numbers) {
                    // C_LINE: keep constant line number
                    loc.set_line_num(file.forced_start_line_num);
                }
                else {
                    // LINE: compute offset using physical line numbers
                    int start_physical = file.forced_at_line_num;
                    int offset = physical_line - start_physical - 1;
                    if (offset < 0) {
                        offset = 0;    // safety
                    }
                    loc.set_line_num(file.forced_start_line_num + offset);
                }
            }
            else {
                // Default mapping uses the physical line number provided by TokensLine
                loc.set_filename(file.tokens_file.filename());
                loc.set_line_num(physical_line);
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
        std::vector<TokensLine> expanded = expand_macros(line);
        if (expanded.empty()) {
            // nothing to emit from this physical line
            continue; // get next line
        }

        // split expanded lines into input queue
        split_lines(location, expanded);

        // Continue loop; either queued lines will be returned next, or the virtual
        // file we pushed will be read on the next iteration.
    }
}

void Preprocessor::define_macro(const std::string& name,
                                const std::string replacement) {
    TokensFile tf(replacement, "<macro>", 1, false);
    define_macro(name, tf.tok_lines());
}

void Preprocessor::define_macro(const std::string& name,
                                const std::vector<TokensLine>& replacement) {
    // Report redefinition to keep behavior consistent with DEFINE/MACRO directives
    if (macros_.find(name) != macros_.end()) {
        g_errors.error(ErrorCode::MacroRedefined, name);
    }

    Macro m;
    m.replacement = replacement;
    m.params.clear();
    m.locals.clear();
    m.is_function_like = false;
    macros_[name] = std::move(m);
}

void Preprocessor::expect_end(const TokensLine& line, unsigned i) const {
    if (!line.at_end(i)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected token: '" + line[i].text() + "'");
    }
}

bool Preprocessor::parse_params_list(const TokensLine& line, unsigned& i,
                                     std::vector<std::string>& out_params
                                    ) const {
    out_params.clear();
    unsigned j = i;
    line.skip_spaces(j);

    // Optional surrounding parentheses
    bool has_paren = false;
    if (j < line.size() && line[j].is(TokenType::LeftParen)) {
        has_paren = true;
        ++j; // consume '('
    }

    // If we have immediate ')' it's an empty list
    line.skip_spaces(j);
    if (has_paren && j < line.size() && line[j].is(TokenType::RightParen)) {
        ++j; // consume ')'
        i = j;
        return true;
    }

    // Parse zero or more identifiers separated by commas
    bool expect_ident = true;
    while (j < line.size()) {
        line.skip_spaces(j);
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
                line.skip_spaces(j);
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
    line.skip_spaces(j);

    bool has_paren = false;
    if (j < line.size() && line[j].is(TokenType::LeftParen)) {
        has_paren = true;
        ++j; // consume '('
    }

    // If parenthesized and immediate ')' -> empty list
    line.skip_spaces(j);
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
                                   Keyword keyword) const {
    line.skip_spaces(i);

    if (!(i < line.size() && line[i].is(TokenType::Integer))) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Expected line number in ") +
                       keyword_to_string(keyword) + " directive");
        return false;
    }

    out_linenum = line[i].int_value();
    ++i;

    line.skip_spaces(i);

    out_filename.clear();
    if (i < line.size() && line[i].is(TokenType::Comma)) {
        ++i;
        line.skip_spaces(i);
        // Accept quoted or plain filename after comma.
        bool is_angle = false;
        if (!parse_filename(line, i, out_filename, is_angle)) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           std::string("Expected filename after comma in ") + keyword_to_string(keyword) +
                           " directive");
            return false;
        }
    }

    expect_end(line, i);

    return true;
}

bool Preprocessor::parse_filename(const TokensLine& line, unsigned& i,
                                  std::string& out_filename, bool& out_is_angle) const {
    line.skip_spaces(i);
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

bool Preprocessor::parse_identifier(const TokensLine& line, unsigned& i,
                                    std::string& out_name) const {
    out_name.clear();
    line.skip_spaces(i);
    if (i < line.size() && line[i].is(TokenType::Identifier)) {
        out_name = line[i].text();
        ++i;
        return true;
    }
    else {
        return false;
    }
}

bool Preprocessor::parse_keyword(const TokensLine& line, unsigned& i,
                                 Keyword& out_keyword) const {
    out_keyword = Keyword::None;
    line.skip_spaces(i);
    if (i < line.size() && line[i].is(TokenType::Identifier)) {
        out_keyword = line[i].keyword();
        if (out_keyword != Keyword::None) {
            ++i;
            return true;
        }
    }
    return false;
}

// Helper to collect the rest of the line into tokens, trimming trailing whitespace.
// Advances `i` to the end of the line.
TokensLine Preprocessor::collect_tokens(const TokensLine& line,
                                        unsigned& i) {
    line.skip_spaces(i);
    TokensLine result(line.location());
    while (i < line.size()) {
        result.push_back(line[i]);
        ++i;
    }
    while (!result.empty() && result.back().is(TokenType::Whitespace)) {
        result.pop_back();
    }
    return result;
}

// expand macros and check if the whole line is a constant expression
// return its value
bool Preprocessor::eval_const_expr(const TokensLine& expr_tokens,
                                   int& out_value, bool silent) {
    // try to evaluate as a constant expression.
    Expr expr;
    expr.set_silent(silent);
    unsigned i = 0;

    if (!expr.parse(expr_tokens, i)) {
        return false;
    }

    if (!expr_tokens.at_end(i)) {
        if (!silent) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           "Unexpected token in expression: '" + expr_tokens[i].text() + "'");
        }
        return false;
    }

    out_value = 0;
    if (!expr.evaluate(out_value)) {
        return false;
    }

    return true;
}

bool Preprocessor::is_directive(const TokensLine& line,
                                unsigned& i, Keyword& keyword) const {
    line.skip_spaces(i);

    // skip optional #
    if (i < line.size() && line[i].is(TokenType::Hash)) {
        ++i;
        line.skip_spaces(i);
    }

    // check for directive keywords
    keyword = Keyword::None;
    if (parse_keyword(line, i, keyword)) {
        if (keyword_is_directive(keyword)) {
            return true;
        }
    }

    i = 0;  // rewind
    return false;
}

bool Preprocessor::is_name_directive(const TokensLine& line, unsigned& i,
                                     Keyword& keyword,
                                     std::string& name) const {
    line.skip_spaces(i);
    name.clear();
    if (parse_identifier(line, i, name)) {
        line.skip_spaces(i);
        keyword = Keyword::None;
        if (line[i].is(TokenType::EQ)) {    // synonym for EQU
            keyword = Keyword::EQU;
            ++i;
            line.skip_spaces(i);
            return true;
        }
        else if (parse_keyword(line, i, keyword)) {
            line.skip_spaces(i);
            if (keyword_is_name_directive(keyword)) {
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
    case Keyword::UNDEFINE:
        process_undef(line, i);
        break;
    case Keyword::DEFL:
        process_defl(line, i);
        break;
    case Keyword::MACRO:
        process_macro(line, i);
        break;
    case Keyword::LOCAL:
        break;
    case Keyword::EXITM:
        process_exitm(line, i);
        break;
    case Keyword::REPT:
        process_rept(line, i);
        break;
    case Keyword::REPTC:
        process_reptc(line, i);
        break;
    case Keyword::REPTI:
        process_repti(line, i);
        break;
    case Keyword::EQU:
        process_equ(line, i);
        break;
    case Keyword::IF:
    case Keyword::IFDEF:
    case Keyword::IFNDEF:
    case Keyword::ELIF:
    case Keyword::ELIFDEF:
    case Keyword::ELIFNDEF:
    case Keyword::ELSE:
    case Keyword::ENDIF:
        // Minimal placeholder: report as unsupported to avoid hitting default assert.
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Unsupported conditional directive: ") + keyword_to_string(
                           keyword));
        break;
    case Keyword::ENDM:
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected ENDM directive without matching MACRO");
        break;
    case Keyword::ENDR:
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected ENDR directive without matching REPT");
        break;
    default:
        // Gracefully report unsupported name-directives flagged as IS_DIRECTIVE
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Unsupported directive: ") + keyword_to_string(keyword));
        break;
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
    case Keyword::UNDEFINE:
        process_name_undef(line, i, name);
        break;
    case Keyword::DEFL:
        process_name_defl(line, i, name);
        break;
    case Keyword::MACRO:
        process_name_macro(line, i, name);
        break;
    case Keyword::REPTC:
        process_name_reptc(line, i, name);
        break;
    case Keyword::REPTI:
        process_name_repti(line, i, name);
        break;
    case Keyword::EQU:
    case Keyword::DEFC:
        process_name_equ(line, i, name);
        break;
    default:
        // Gracefully report unsupported name-directives flagged as IS_NAME_DIRECTIVE
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Unsupported directive: ") + keyword_to_string(keyword));
        break;
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

    // Use the directive's own logical location (already accounts for LINE/C_LINE)
    const Location location = line.location();
    do_binary(filename, is_angle, location);
}

void Preprocessor::do_binary(const std::string& filename, bool is_angle,
                             const Location& location) {
    // Resolve include-path candidates first so BINARY/INCBIN honor include
    // search directories the same way #include does.
    std::string resolved = search_include_path(filename, is_angle);

    // Push a virtual file containing DEFB directives with the binary bytes,
    // starting exactly at the directive's logical location.
    push_binary_file(resolved, location);
}

void Preprocessor::process_line(const TokensLine& line, unsigned& i) {
    int linenum = 0;
    std::string filename;
    if (!parse_line_args(line, i, linenum, filename, Keyword::LINE)) {
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
    file.forced_at_line_num = line.location().line_num();
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
    if (!parse_line_args(line, i, linenum, filename, Keyword::C_LINE)) {
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
    file.forced_at_line_num = line.location().line_num();
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
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after DEFINE");
        return;
    }

    // Determine if function-like: must have '(' immediately after name (no space)
    std::vector<std::string> params;
    bool had_func_parens = false;
    if (i < line.size() && line[i].is(TokenType::LeftParen)) {
        had_func_parens = true;
        if (!parse_params_list(line, i, params)) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           "Invalid macro parameter list");
            return;
        }
    }

    // Delegate the remaining common work to do_define (consumes rest of line)
    do_define(line, i, name, params, had_func_parens);
}

void Preprocessor::process_name_define(const TokensLine& line, unsigned& i,
                                       const std::string& name) {
    // name define ... -> treat as "#define name ..." (object-like)
    // No function-like params recognized in name-directive form
    std::vector<std::string> params;
    do_define(line, i, name, params, false);
}

void Preprocessor::do_define(const TokensLine& line, unsigned& i,
                             const std::string& name,
                             const std::vector<std::string>& params,
                             bool had_func_parens) {
    line.skip_spaces(i);

    // scan optional '=' for compatibility
    line.skip_spaces(i);
    if (i < line.size() && line[i].is(TokenType::EQ)) {
        ++i; // skip '='
        line.skip_spaces(i);
    }

    TokensLine replacement = collect_tokens(line, i);
    if (replacement.empty()) {
        replacement.push_back(Token(TokenType::Integer, "1", 1));
    }

    Macro macro;
    macro.params = params;
    macro.is_function_like = (!macro.params.empty()) || had_func_parens;
    macro.replacement.clear();
    macro.replacement.push_back(replacement);

    // Report redefinition for DEFINE (not for DEFL)
    if (macros_.find(name) != macros_.end()) {
        g_errors.error(ErrorCode::MacroRedefined, name);
    }

    macros_[name] = std::move(macro);
}

void Preprocessor::process_equ(const TokensLine& line, unsigned& i) {
    // Form: EQU name = value   or   EQU name value
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after EQU");
        return;
    }

    line.skip_spaces(i);
    if (i < line.size() && line[i].is(TokenType::EQ)) {
        ++i; // skip '=' if present
        line.skip_spaces(i);
    }

    // Collect value tokens and expand/collapse to one line
    TokensLine value = collect_tokens(line, i);
    TokensLine expanded = expand_macros_in_line(value);

    // Build a pre-tokenized DEFC line: DEFC <name> = <expanded>
    TokensLine defc(line.location());
    defc.push_back(Token(TokenType::Identifier, "DEFC"));
    defc.push_back(Token(TokenType::Whitespace, " "));
    defc.push_back(Token(TokenType::Identifier, name));
    defc.push_back(Token(TokenType::Whitespace, " "));
    defc.push_back(Token(TokenType::EQ, "="));
    defc.push_back(Token(TokenType::Whitespace, " "));
    for (const auto& t : expanded.tokens()) {
        defc.push_back(t);
    }

    std::vector<TokensLine> one_line;
    one_line.push_back(std::move(defc));

    // Emit DEFC at the directive's logical location
    push_virtual_file(one_line, line.location().filename(),
                      line.location().line_num(), false);
}

void Preprocessor::process_name_equ(const TokensLine& line, unsigned& i,
                                    const std::string& name) {
    // Form: name EQU value   (accept optional '=' after EQU)
    line.skip_spaces(i);
    if (i < line.size() && line[i].is(TokenType::EQ)) {
        ++i; // optional '='
        line.skip_spaces(i);
    }

    TokensLine value = collect_tokens(line, i);
    TokensLine expanded = expand_macros_in_line(value);

    // Build a pre-tokenized DEFC line: DEFC <name> = <expanded>
    TokensLine defc(line.location());
    defc.push_back(Token(TokenType::Identifier, "DEFC"));
    defc.push_back(Token(TokenType::Whitespace, " "));
    defc.push_back(Token(TokenType::Identifier, name));
    defc.push_back(Token(TokenType::Whitespace, " "));
    defc.push_back(Token(TokenType::EQ, "="));
    defc.push_back(Token(TokenType::Whitespace, " "));
    for (const auto& t : expanded.tokens()) {
        defc.push_back(t);
    }

    std::vector<TokensLine> one_line;
    one_line.push_back(std::move(defc));

    push_virtual_file(one_line, line.location().filename(),
                      line.location().line_num(), false);
}

void Preprocessor::process_undef(const TokensLine& line, unsigned& i) {
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after UNDEF");
    }
    else {
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

void Preprocessor::process_defl(const TokensLine& line, unsigned& i) {
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after DEFL");
    }
    else {
        line.skip_spaces(i);
        if (i < line.size() && line[i].is(TokenType::EQ)) {
            ++i; // consume '='
            line.skip_spaces(i);
        }

        do_defl(line, i, name);
    }
}

void Preprocessor::process_name_defl(const TokensLine& line, unsigned& i,
                                     const std::string& name) {
    // In the "<name> DEFL" form the identifier to define is provided as `name`.
    do_defl(line, i, name);
}

void Preprocessor::do_defl(const TokensLine& line, unsigned& i,
                           const std::string& name) {
    // 1) Predefine name as an empty macro if it does not exist, so that
    //    occurrences of <name> in the body expand to the previous value (if any)
    //    or to empty otherwise.
    if (macros_.find(name) == macros_.end()) {
        define_macro(name, "");
    }

    // 2) Collect all tokens up to end-of-line from current index.
    TokensLine body = collect_tokens(line, i);
    if (body.empty()) {
        // If no body, replace it with integer token '1'
        body.push_back(Token(TokenType::Integer, "1", 1));
    }

    // 3) Expand macros in the body (if 'name' is used here, it expands to the
    //    previous value, or empty when none existed).
    TokensLine expr_tokens = expand_macros_in_line(body);

    // 4) Flatten expanded lines into a single TokensLine (insert a single space between lines)
    // 5) Try to evaluate as a constant expression.
    //    If it parses successfully AND consumes the whole body, define <name>
    //    as the resulting integer. Otherwise, define <name> as the whole expanded body.
    int value = 0;
    if (eval_const_expr(expr_tokens, value, false)) {
        body.clear_tokens();
        body.push_back(Token(TokenType::Integer, std::to_string(value), value));
    }

    Macro macro;
    macro.params.clear();
    macro.replacement.clear();
    macro.replacement.push_back(body);

    // 6) Register/overwrite the macro definition of <name>.
    macros_[name] = std::move(macro);
    // Reset recursion guard counter for this macro name (safe guard)
    macro_recursion_count_[name] = 0;
}

// Fetch a raw next logical line for MACRO body parsing, from the proper source:
// - input_queue_ when reading_queue_for_directive_ is true
// - file_stack_ otherwise (and applies forced location if needed).
bool Preprocessor::fetch_line_for_macro_body(TokensLine& out) {
    if (reading_queue_for_directive_) {
        if (input_queue_.empty()) {
            return false;
        }
        out = std::move(input_queue_.front());
        input_queue_.pop_front();
        return true;
    }

    if (file_stack_.empty()) {
        return false;
    }

    File& file = file_stack_.back();
    if (file.line_index >= file.tokens_file.tok_lines_count()) {
        return false;
    }

    // Return the raw stored line; next_line() will handle user-visible mapping.
    out = file.tokens_file.get_tok_line(file.line_index);
    ++file.line_index;

    return true;
}

bool Preprocessor::collect_macro_body(std::vector<TokensLine>& out_body,
                                      std::vector<std::string>& out_locals,
                                      Keyword start_keyword, Keyword end_keyword) {
    out_body.clear();
    std::vector<Keyword> nesting_end{ end_keyword };
    TokensLine line;
    bool ok = true;

    // Collect body lines verbatim until ENDM
    while (true) {
        TokensLine raw;
        if (!fetch_line_for_macro_body(raw)) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           "Unexpected end of input in " +
                           keyword_to_string(start_keyword) +
                           " (expected " + keyword_to_string(end_keyword) + ")");
            return false;
        }

        // Check for directives that may affect nesting
        unsigned k = 0;
        Keyword kw = Keyword::None;
        if (is_directive(raw, k, kw)) {
            if (kw == nesting_end.back()) {
                expect_end(raw, k);     // error if extra tokens
                nesting_end.pop_back();
                if (nesting_end.empty()) {
                    break;
                }
                // else continue collecting
            }
            else if (kw == Keyword::ENDM || kw == Keyword::ENDR) {
                // mismatched end directive
                g_errors.error(ErrorCode::InvalidSyntax,
                               std::string("Unexpected ") +
                               keyword_to_string(kw) +
                               " directive without matching " +
                               (kw == Keyword::ENDM ? "MACRO" : "REPT"));
                ok = false;
                nesting_end.pop_back();
                if (nesting_end.empty()) {
                    break;
                }
                // else continue collecting
            }
            else if (kw == Keyword::MACRO) {
                nesting_end.push_back(Keyword::ENDM);
            }
            else if (kw == Keyword::REPT ||
                     kw == Keyword::REPTC ||
                     kw == Keyword::REPTI) {
                nesting_end.push_back(Keyword::ENDR);
            }
            else if (kw == Keyword::LOCAL && nesting_end.size() == 1) {
                // Delegate LOCAL parsing
                process_local(raw, k, out_locals);
                continue;   // do not store the LOCAL line
            }
        }
        else {
            k = 0;
            kw = Keyword::None;
            std::string dummy_name;
            if (is_name_directive(raw, k, kw, dummy_name)) {
                if (kw == Keyword::MACRO) {
                    nesting_end.push_back(Keyword::ENDM);
                }
                else if (kw == Keyword::REPTC ||
                         kw == Keyword::REPTI) {
                    nesting_end.push_back(Keyword::ENDR);
                }
            }
        }

        // colect line as-is
        out_body.push_back(raw);
    }

    return ok;
}

void Preprocessor::process_macro(const TokensLine& line, unsigned& i) {
    // Expect: MACRO name(param, ...) or MACRO name param, ...
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after MACRO");
    }
    else {
        do_macro(line, i, name);
    }
}

void Preprocessor::process_name_macro(const TokensLine& line,
                                      unsigned& i, const std::string& name) {
    // Form: <name> MACRO (param, ...) or <name> MACRO param, ...
    do_macro(line, i, name);
}

// Factor LOCAL parsing into process_local and use it from do_macro
void Preprocessor::do_macro(const TokensLine& line, unsigned& i,
                            const std::string& name) {
    // Parse optional parameter list (accepts with or without surrounding parentheses)
    std::vector<std::string> params;
    std::vector<std::string> locals;
    std::vector<TokensLine> body;
    unsigned j = i;
    line.skip_spaces(j);

    const bool had_paren = (j < line.size() && line[j].is(TokenType::LeftParen));
    if (j < line.size()) {
        if (!parse_params_list(line, j, params)) {
            g_errors.error(ErrorCode::InvalidSyntax, "Invalid macro parameter list");
            return;
        }
    }
    expect_end(line, j);

    // Collect body lines verbatim until ENDM
    if (!collect_macro_body(body, locals, Keyword::MACRO, Keyword::ENDM)) {
        return;
    }

    Macro macro;
    macro.params = std::move(params);
    macro.locals = std::move(locals);
    macro.is_function_like = (!macro.params.empty())
                             || had_paren; // true if params or empty ()
    macro.replacement = std::move(body);

    // Report redefinition for MACRO (not for DEFL)
    if (macros_.find(name) != macros_.end()) {
        g_errors.error(ErrorCode::MacroRedefined, name);
    }

    macros_[name] = std::move(macro);
    macro_recursion_count_[name] = 0;
}

void Preprocessor::process_rept(const TokensLine& line, unsigned& i) {
    // 1) Collect the count expression from the rest of the line
    TokensLine count_line = collect_tokens(line, i);
    if (count_line.empty()) {
        g_errors.error(ErrorCode::InvalidSyntax, "Expected count in REPT");
        return;
    }

    // 2) Expand macros in the count expression
    // 3) Flatten into a single TokensLine (insert single space between lines)
    TokensLine expr_tokens = expand_macros_in_line(count_line);

    // 4) Evaluate as a constant expression
    int count_value = 0;
    if (!eval_const_expr(expr_tokens, count_value, false)) {
        count_value = 0;    // continue to collect the body
    }

    // 5) Collect body lines until matching ENDR, with nesting support
    std::vector<TokensLine> body;
    std::vector<std::string> locals; // collect LOCALs for this block
    if (!collect_macro_body(body, locals, Keyword::REPT, Keyword::ENDR)) {
        return;
    }

    // 6) If count <= 0, nothing to emit (but body was consumed)
    if (count_value <= 0) {
        return;
    }

    // Helper to rename identifiers in one line according to a map
    auto rename_line = [](const TokensLine & src,
    const std::unordered_map<std::string, std::string>& rmap) {
        TokensLine out(src.location());
        for (unsigned t = 0; t < src.size(); ++t) {
            const Token& tk = src[t];
            if (tk.is(TokenType::Identifier)) {
                auto it = rmap.find(tk.text());
                if (it != rmap.end()) {
                    out.push_back(Token(TokenType::Identifier, it->second));
                    continue;
                }
            }
            out.push_back(tk);
        }
        return out;
    };

    // 7) Repeat body count_value times with LOCAL renaming per iteration
    std::vector<TokensLine> repeated;
    repeated.reserve(body.size() * static_cast<size_t>(count_value));
    for (int c = 0; c < count_value; ++c) {
        std::unordered_map<std::string, std::string> rmap;
        if (!locals.empty()) {
            ++local_id_counter_;
            const std::string suffix = "_" + std::to_string(local_id_counter_);
            for (const std::string& ln : locals) {
                rmap.emplace(ln, ln + suffix);
            }
        }
        for (const TokensLine& b : body) {
            if (rmap.empty()) {
                repeated.push_back(b);
            }
            else {
                repeated.push_back(rename_line(b, rmap));
            }
        }
    }

    // Start generated lines at the REPT directive's logical location
    push_virtual_file(repeated, line.location().filename(),
                      line.location().line_num(), false);
}

// REPTC: directive form "REPTC var, string"
void Preprocessor::process_reptc(const TokensLine& line, unsigned& i) {
    std::string var_name;
    if (!parse_identifier(line, i, var_name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after REPTC");
        return;
    }

    line.skip_spaces(i);
    if (!(i < line.size() && line[i].is(TokenType::Comma))) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected comma after variable name in REPTC");
        return;
    }
    ++i; // skip comma

    // Collect argument tokens up to end-of-line
    TokensLine arg = collect_tokens(line, i);
    if (arg.empty()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected string/identifier/number in REPTC");
        return;
    }

    do_reptc(var_name, arg, line);
}

// REPTC: name-directive form "var REPTC string"
void Preprocessor::process_name_reptc(const TokensLine& line, unsigned& i,
                                      const std::string& var_name) {
    // For name-directive form, accept the rest of the line as the string expression (no comma required)
    TokensLine arg = collect_tokens(line, i);
    if (arg.empty()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected string/identifier/number after REPTC");
        return;
    }

    do_reptc(var_name, arg, line);
}

void Preprocessor::do_reptc(const std::string& var_name,
                            const TokensLine& arg_line,
                            const TokensLine& directive_line) {
    // 1) Expand macros in the argument and flatten to a single line
    TokensLine flat = expand_macros_in_line(arg_line);

    // 2) Derive the source string to iterate:
    // - If exactly one String token (ignoring spaces): use string_value().
    // - Else if exactly one Integer token: use decimal text of its value.
    // - Else: concatenate texts of all non-whitespace tokens.
    std::string iter_text;

    auto is_only_token_type = [&](TokenType tt) -> bool {
        unsigned count = 0;
        for (unsigned k = 0; k < flat.size(); ++k) {
            const Token& tk = flat[k];
            if (tk.is(TokenType::Whitespace)) {
                continue;
            }
            if (!tk.is(tt)) {
                return false;
            }
            ++count;
        }
        return count == 1;
    };

    if (is_only_token_type(TokenType::String)) {
        for (unsigned k = 0; k < flat.size(); ++k) {
            const Token& tk = flat[k];
            if (tk.is(TokenType::String)) {
                iter_text = tk.string_value();
                break;
            }
        }
    }
    else if (is_only_token_type(TokenType::Integer)) {
        for (unsigned k = 0; k < flat.size(); ++k) {
            const Token& tk = flat[k];
            if (tk.is(TokenType::Integer)) {
                iter_text = std::to_string(tk.int_value());
                break;
            }
        }
    }
    else {
        // Concatenate non-whitespace token texts
        for (unsigned k = 0; k < flat.size(); ++k) {
            const Token& tk = flat[k];
            if (tk.is(TokenType::Whitespace)) {
                continue;
            }
            iter_text += tk.text();
        }
    }

    // 3) Collect body lines until ENDR, supporting nesting and LOCAL
    std::vector<TokensLine> body;
    std::vector<std::string> locals; // collect LOCALs
    if (!collect_macro_body(body, locals,
                            Keyword::REPTC, Keyword::ENDR)) {
        return;
    }

    // 4) Build substituted lines for each character of iter_text
    if (iter_text.empty()) {
        // Nothing to emit (but body consumed)
        return;
    }

    std::vector<TokensLine> out_lines;
    out_lines.reserve(static_cast<size_t>(iter_text.size()) * std::max<size_t>(1,
                      body.size()));

    for (unsigned ci = 0; ci < iter_text.size(); ++ci) {
        unsigned char ch = static_cast<unsigned char>(iter_text[ci]);

        // Per-iteration LOCAL rename map
        std::unordered_map<std::string, std::string> rmap;
        if (!locals.empty()) {
            ++local_id_counter_;
            const std::string suffix = "_" + std::to_string(local_id_counter_);
            for (const std::string& ln : locals) {
                rmap.emplace(ln, ln + suffix);
            }
        }

        for (const TokensLine& bline : body) {
            TokensLine sub(directive_line.location());
            for (unsigned t = 0; t < bline.size(); ++t) {
                const Token& tok = bline[t];

                // Substitute iteration variable first
                if (tok.is(TokenType::Identifier) && tok.text() == var_name) {
                    sub.push_back(Token(TokenType::Integer, std::to_string((int)ch), (int)ch));
                    continue;
                }

                // Apply LOCAL renaming
                if (tok.is(TokenType::Identifier) && !rmap.empty()) {
                    auto it = rmap.find(tok.text());
                    if (it != rmap.end()) {
                        sub.push_back(Token(TokenType::Identifier, it->second));
                        continue;
                    }
                }

                sub.push_back(tok);
            }
            out_lines.push_back(std::move(sub));
        }
    }

    // 5) Emit the substituted lines at the directive's logical location
    push_virtual_file(out_lines, directive_line.location().filename(),
                      directive_line.location().line_num(), false);
}

// REPTI: directive form "REPTI var, list"
void Preprocessor::process_repti(const TokensLine& line, unsigned& i) {
    std::string var_name;
    if (!parse_identifier(line, i, var_name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after REPTI");
        return;
    }

    line.skip_spaces(i);
    if (!(i < line.size() && line[i].is(TokenType::Comma))) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected ',' after REPTI variable name");
        return;
    }
    ++i;

    // Parse the comma-separated argument list (unparenthesized)
    TokensLine args_line = collect_tokens(line, i);
    std::vector<TokensLine> arg_list;
    unsigned ai = 0;
    if (!parse_macro_args(args_line, ai, arg_list)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Invalid argument list in REPTI");
        return;
    }

    do_repti(var_name, arg_list, line);
}

// REPTI: name-directive form "var REPTI list"
void Preprocessor::process_name_repti(const TokensLine& line, unsigned& i,
                                      const std::string& var_name) {
    // The rest of the line is the list
    TokensLine args_line = collect_tokens(line, i);
    std::vector<TokensLine> arg_list;
    unsigned ai = 0;
    if (!parse_macro_args(args_line, ai, arg_list)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Invalid argument list after REPTI");
        return;
    }

    do_repti(var_name, arg_list, line);
}

void Preprocessor::do_repti(const std::string& var_name,
                            const std::vector<TokensLine>& arg_list,
                            const TokensLine& directive_line) {
    // 1) Expand macros in each argument and flatten to a single TokensLine
    std::vector<TokensLine> flat_args;
    flat_args.reserve(arg_list.size());

    for (const TokensLine& raw_arg : arg_list) {
        TokensLine flat = expand_macros_in_line(raw_arg);
        flat_args.push_back(std::move(flat));
    }

    // 2) Collect body lines until matching ENDR, with nesting support (REPT/REPTC/REPTI)
    std::vector<TokensLine> body;
    std::vector<std::string> locals; // collect LOCALs
    if (!collect_macro_body(body, locals,
                            Keyword::REPTI, Keyword::ENDR)) {
        return;
    }

    // 3) If no arguments, nothing to emit (but body consumed)
    if (flat_args.empty()) {
        return;
    }

    // 4) For each argument, duplicate the body substituting var_name and renaming LOCALs
    std::vector<TokensLine> out_lines;
    for (const TokensLine& argtokens : flat_args) {
        // Per-iteration LOCAL rename map
        std::unordered_map<std::string, std::string> rmap;
        if (!locals.empty()) {
            ++local_id_counter_;
            const std::string suffix = "_" + std::to_string(local_id_counter_);
            for (const std::string& ln : locals) {
                rmap.emplace(ln, ln + suffix);
            }
        }

        for (const TokensLine& bline : body) {
            TokensLine sub(directive_line.location());
            for (unsigned t = 0; t < bline.size(); ++t) {
                const Token& tok = bline[t];

                // Substitute var_name (argument tokens inserted as-is; do not rename inside)
                if (tok.is(TokenType::Identifier) && tok.text() == var_name) {
                    for (unsigned at = 0; at < argtokens.size(); ++at) {
                        sub.push_back(argtokens[at]);
                    }
                    continue;
                }

                // Apply LOCAL renaming outside of argument substitution
                if (tok.is(TokenType::Identifier) && !rmap.empty()) {
                    auto it = rmap.find(tok.text());
                    if (it != rmap.end()) {
                        sub.push_back(Token(TokenType::Identifier, it->second));
                        continue;
                    }
                }

                sub.push_back(tok);
            }
            out_lines.push_back(std::move(sub));
        }
    }

    // 5) Emit the substituted lines at the directive's logical location
    push_virtual_file(out_lines, directive_line.location().filename(),
                      directive_line.location().line_num(), false);
}

void Preprocessor::process_exitm(const TokensLine& line, unsigned& i) {
    expect_end(line, i);
    do_exitm();
}

void Preprocessor::do_exitm() {
    if (!file_stack_.empty()) {
        File& top = file_stack_.back();
        if (top.is_macro_expansion) {
            // Discard the rest of this macro-expansion file
            file_stack_.pop_back();
        }
    }
}

void Preprocessor::process_local(const TokensLine& line, unsigned& i,
                                 std::vector<std::string>& out_locals) {
    // `i` is positioned right after the LOCAL keyword (spaces skipped by is_directive).
    // Accept identifiers list with or without parentheses. If parsing fails, accept bare "LOCAL".
    unsigned before = i;
    std::vector<std::string> local_names;
    if (parse_params_list(line, i, local_names)) {
        // Append parsed names
        out_locals.insert(out_locals.end(), local_names.begin(), local_names.end());
    }
    else {
        // Restore to allow "LOCAL" with no params
        i = before;
    }
    // Validate no trailing tokens
    expect_end(line, i);
}

// Replace previous split_lines implementation with a macro-expansion "virtual file" wrapper
// so directives like EXITM can abort the current expansion and all expanded lines
// carry the macro call-site logical location (constant line number).
void Preprocessor::split_lines(const Location& location,
                               const std::vector<TokensLine>& expanded) {
    // Fast path: single line -> split inline (no EXITM impact)
    if (expanded.size() <= 1) {
        if (!expanded.empty()) {
            split_line(location, expanded[0]);
        }
        return;
    }

    // Preserve per-line locations (call-site) already present in expanded lines.
    push_virtual_file(expanded, location.filename(),
                      location.line_num(), false);

    // Mark as macro-expansion so EXITM can discard the rest of this virtual file.
    if (!file_stack_.empty()) {
        File& top = file_stack_.back();
        top.is_macro_expansion = true;
        // No forced logical mapping here; each TokensLine already carries its call-site location.
    }
}

void Preprocessor::split_line(const Location& location,
                              const TokensLine& expanded) {
    // Make a mutable copy so we can apply merging of '##' operator
    TokensLine line_to_process = expanded;
    merge_double_hash(line_to_process);

    // After token-paste, an identifier produced by '##' may form a macro name.
    // Run macro expansion on the pasted result and, if it changes the line
    // (or produces multiple logical lines), process those expanded results
    // instead of the original pasted line. This ensures that token-paste
    // followed by a macro name will cause that macro to be expanded.
    {
        std::vector<TokensLine> post_paste_expanded =
            expand_macros(line_to_process);

        // Determine if expansion changed the content in a meaningful way.
        bool changed = false;
        if (post_paste_expanded.size() != 1) {
            changed = true;
        }
        else {
            const TokensLine& p0 = post_paste_expanded.front();
            if (p0.size() != line_to_process.size()) {
                changed = true;
            }
            else {
                for (unsigned k = 0; k < p0.size(); ++k) {
                    if (p0[k].text() != line_to_process[k].text()) {
                        changed = true;
                        break;
                    }
                }
            }
        }

        if (changed) {
            // Process each expanded logical line resulting from macro expansion
            for (const TokensLine& el : post_paste_expanded) {
                split_line(location, el);
            }
            return;
        }
    }

    TokensLine current(location);
    int ternary_depth = 0;
    unsigned i = 0;

    // check for label at start of line (uses processed line)
    split_label(location, line_to_process, i);

    // process rest of line
    while (i < line_to_process.size()) {
        const Token& t = line_to_process[i];
        if (t.is(TokenType::Colon) && ternary_depth == 0) {
            // end of current line; push current line to queue
            input_queue_.push_back(std::move(current));
            current = TokensLine(location);
            ++i;
            // skip spaces after colon
            line_to_process.skip_spaces(i);
            continue;
        }
        else if (t.is(TokenType::Quest)) {
            ++ternary_depth;
        }
        else if (t.is(TokenType::Colon)) {
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
            line_to_process.skip_spaces(i);
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
    expanded.skip_spaces(i);
    if (i < expanded.size() && expanded[i].is(TokenType::Identifier)) {
        std::string label_name = expanded[i].text();
        ++i;
        expanded.skip_spaces(i);
        if (i < expanded.size() && expanded[i].is(TokenType::Colon)) {
            ++i;
            // found label
            label_line.push_back(Token(TokenType::Dot, "."));
            label_line.push_back(Token(TokenType::Identifier, label_name));
            input_queue_.push_back(std::move(label_line));

            expanded.skip_spaces(i);
            return;
        }
    }

    // .label
    i = 0; // rewind
    expanded.skip_spaces(i);
    if (i < expanded.size() && expanded[i].is(TokenType::Dot)) {
        ++i;
        expanded.skip_spaces(i);
        if (i < expanded.size() && expanded[i].is(TokenType::Identifier)) {
            std::string label_name = expanded[i].text();
            ++i;
            // found label
            label_line.push_back(Token(TokenType::Dot, "."));
            label_line.push_back(Token(TokenType::Identifier, label_name));
            input_queue_.push_back(std::move(label_line));

            expanded.skip_spaces(i);
            return;
        }
    }

    i = 0; // rewind
    expanded.skip_spaces(i);
}

void Preprocessor::merge_double_hash(TokensLine& line) {
    // Build a new TokensLine with merged tokens
    TokensLine out(line.location());

    unsigned idx = 0;
    while (idx < line.size()) {
        const Token& cur = line[idx];

        // Candidate: identifier on the left
        if (cur.is(TokenType::Identifier)) {
            unsigned j = idx + 1;
            // skip optional whitespace
            line.skip_spaces(j);

            // require DoubleHash operator token
            if (j < line.size() && line[j].is(TokenType::DoubleHash)) {
                unsigned k = j + 1;
                // skip optional whitespace after ##
                line.skip_spaces(k);

                // right side must be identifier or integer
                if (k < line.size() && (line[k].is(TokenType::Identifier)
                                        || line[k].is(TokenType::Integer))) {
                    // concatenate texts (no added space)
                    std::string glued = cur.text() + line[k].text();
                    out.push_back(Token(TokenType::Identifier, glued));
                    // advance past the matched sequence
                    idx = k + 1;
                    continue;
                }
            }
        }

        // default: copy current token
        out.push_back(cur);
        ++idx;
    }

    // replace original line with merged result
    line = out;
}


// ------------------- Refactored helpers for expand_macros --------------------

bool Preprocessor::is_macro_call(const TokensLine& in_line, unsigned idx,
                                 const Macro& macro,
                                 unsigned& args_start_idx) const {
    args_start_idx = idx + 1;

    // Only function-like macros use call syntax
    if (!macro.is_function_like) {
        return false;
    }

    // Must have something after the macro name to be considered a call candidate
    if (args_start_idx >= in_line.size()) {
        return false;
    }

    // Classic form: immediate '('
    if (in_line[args_start_idx].is(TokenType::LeftParen)) {
        return true;
    }

    // Also allow non-parenthesized calls where arguments follow and are separated by commas
    // The actual argument-count validation will be done after parsing.
    return true;
}

// Parse macro args and expand each argument (expand macros inside arguments).
// On success: fills expanded_args_flat with one TokensLine per argument (first line of expansion or empty line),
// sets out_after_idx to index after consumed args and returns true.
// Also fills out_original_args with the trimmed original (unexpanded, trimmed) TokensLine for each arg
// (used for '#' stringizing). On failure returns false (syntax error).
bool Preprocessor::parse_and_expand_macro_args(const TokensLine& in_line,
        unsigned args_start_idx,
        std::vector<std::vector<TokensLine>>& expanded_args_flat,
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

        // expand macros inside argument and keep all expanded logical lines
        std::vector<TokensLine> expanded = expand_macros(argline);
        if (!expanded.empty()) {
            expanded_args_flat.push_back(expanded);
        }
        else {
            TokensLine emptyline(in_line.location());
            expanded_args_flat.push_back(std::vector<TokensLine> { emptyline });
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
    if (!(pidx < rep_line.size() && rep_line[pidx].is(TokenType::Hash))) {
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
    const std::vector<std::vector<TokensLine>>& expanded_args_flat,
    const std::vector<TokensLine>& original_args,
    const std::string& name) {
    // Prepare LOCAL renaming map for this expansion, if any locals declared.
    std::unordered_map<std::string, std::string> local_rename;
    if (!macro.locals.empty()) {
        // Each macro expansion gets a new unique id
        ++local_id_counter_;
        const std::string suffix = "_" + std::to_string(local_id_counter_);
        for (const std::string& ln : macro.locals) {
            local_rename[ln] = ln + suffix;
        }
    }

    // Perform textual parameter substitution
    std::vector<TokensLine> substituted;
    for (const TokensLine& rep_line : macro.replacement) {
        // temp_lines holds 1..N TokensLine resulting from substituting this rep_line
        std::vector<TokensLine> temp_lines;
        temp_lines.emplace_back(rep_line.location());

        unsigned pidx = 0;
        while (pidx < rep_line.size()) {
            const Token& rt = rep_line[pidx];

            // Handle stringize operator: '#' followed by parameter identifier
            if (rt.is(TokenType::Hash)) {
                // try_stringize_parameter expects a TokensLine to append into.
                if (try_stringize_parameter(rep_line, pidx, macro, original_args,
                                            temp_lines.back())) {
                    // handled and pidx advanced inside helper
                    continue;
                }
                // If not handled (not followed by a matching param), copy '#'
                // If '#' appears in replacement (not stringize), copy as-is
                temp_lines.back().push_back(rt);
                ++pidx;
                continue;
            }

            bool substituted_flag = false;

            // Normal parameter substitution: identifier matching a parameter
            if (rt.is(TokenType::Identifier)) {
                for (unsigned pi = 0; pi < macro.params.size(); ++pi) {
                    if (rt.text() == macro.params[pi]) {
                        // expanded_args_flat[pi] is a vector<TokensLine>
                        const auto& arg_lines = expanded_args_flat[pi];

                        if (!arg_lines.empty()) {
                            // Append first expanded line into current last temp line
                            const TokensLine& first_arg = arg_lines.front();
                            for (unsigned at = 0; at < first_arg.size(); ++at) {
                                temp_lines.back().push_back(first_arg[at]);
                            }

                            // For subsequent expanded lines, create new temp lines
                            for (size_t al = 1; al < arg_lines.size(); ++al) {
                                temp_lines.emplace_back(rep_line.location());
                                const TokensLine& later_arg = arg_lines[al];
                                for (unsigned at = 0; at < later_arg.size(); ++at) {
                                    temp_lines.back().push_back(later_arg[at]);
                                }
                            }
                        }
                        substituted_flag = true;
                        break;
                    }
                }
            }

            if (!substituted_flag) {
                // Copy token into current last temp line
                // If this identifier is declared LOCAL for the macro, rename it.
                if (rt.is(TokenType::Identifier)) {
                    auto it = local_rename.find(rt.text());
                    if (it != local_rename.end()) {
                        temp_lines.back().push_back(Token(TokenType::Identifier, it->second));
                    }
                    else {
                        temp_lines.back().push_back(rt);
                    }
                }
                else {
                    temp_lines.back().push_back(rt);
                }
            }
            ++pidx;
        }

        // Apply token-paste (##) after parameter substitution on each produced line
        for (TokensLine& tln : temp_lines) {
            merge_double_hash(tln);
            substituted.push_back(tln);
        }
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

std::vector<TokensLine> Preprocessor::expand_macros(
    const TokensLine& line) {
    std::vector<TokensLine> lines{ line };
    return expand_macros(lines);
}

std::vector<TokensLine> Preprocessor::expand_macros(
    const std::vector<TokensLine>& lines) {

    std::vector<TokensLine> result;

    for (const TokensLine& in_line : lines) {
        TokensLine out(in_line.location());
        unsigned idx = 0;

        while (idx < in_line.size()) {
            const Token& tok = in_line[idx];

            if (!tok.is(TokenType::Identifier)) {
                out.push_back(tok);
                ++idx;
                continue;
            }

            std::string name = tok.text();
            auto mit = macros_.find(name);
            if (mit == macros_.end()) {
                out.push_back(tok);
                ++idx;
                continue;
            }

            Macro& macro = mit->second;

            int& rc = macro_recursion_count_[name];
            if (rc >= MAX_MACRO_RECURSION) {
                g_errors.error(ErrorCode::MacroRecursionLimit,
                               "Macro recursion limit reached for: " + name);
                out.push_back(tok);
                ++idx;
                continue;
            }

            // Determine if this is a function-like call (parenthesized or not)
            unsigned args_start_idx = 0;
            bool is_call = is_macro_call(in_line, idx, macro, args_start_idx);
            bool had_paren = (is_call && args_start_idx < in_line.size() &&
                              in_line[args_start_idx].is(TokenType::LeftParen));

            // Handle function-like macros (even with zero params, e.g. MACRO())
            if (macro.is_function_like && is_call) {
                // Try to parse and expand arguments (supports optional parentheses)
                std::vector<std::vector<TokensLine>> expanded_args_flat;
                std::vector<TokensLine> original_args;
                unsigned after_idx = 0;
                if (!parse_and_expand_macro_args(in_line,
                                                 args_start_idx,
                                                 expanded_args_flat,
                                                 original_args,
                                                 after_idx)) {
                    // If parenthesized form was used, treat as a syntax error-like scenario
                    // and fall back to literal; for non-paren ambiguous usage, keep literal.
                    out.push_back(tok);
                    ++idx;
                    continue;
                }

                // Validate argument count; if no parentheses were used and count doesn't match,
                // treat as plain identifier (avoid spurious errors for ambiguous non-paren usage).
                if (expanded_args_flat.size() != macro.params.size()) {
                    if (had_paren) {
                        g_errors.error(ErrorCode::InvalidSyntax,
                                       "Macro argument count mismatch for: " + name);
                    }
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

                // advance idx past the consumed args (works for both paren and non-paren forms)
                idx = after_idx;
            }
            else if (macro.params.empty()) {
                // Object-like macro
                std::vector<TokensLine> substituted = macro.replacement;

                rc++;
                std::vector<TokensLine> further_expanded =
                    expand_macros(substituted);
                rc--;

                append_expansion_into_out(further_expanded, out, result, in_line.location());

                ++idx;
            }
            else {
                // macro has params but is not considered a call -> treat name literally
                out.push_back(tok);
                ++idx;
            }
        }

        result.push_back(out);
    }

    return result;
}

TokensLine Preprocessor::expand_macros_in_line(const TokensLine& line) {
    std::vector<TokensLine> expanded_lines = expand_macros(line);
    TokensLine expanded(line.location());
    for (size_t li = 0; li < expanded_lines.size(); ++li) {
        const TokensLine& el = expanded_lines[li];
        if (li > 0) {
            // insert a space between lines to avoid token merging
            expanded.push_back(Token(TokenType::Whitespace, " "));
        }
        for (unsigned t = 0; t < el.size(); ++t) {
            expanded.push_back(el[t]);
        }
    }

    // Trim trailing whitespace for cleanliness (does not change semantics)
    while (expanded.size() > 0
            && expanded[expanded.size() - 1].is(TokenType::Whitespace)) {
        expanded.pop_back();
    }

    return expanded;
}
