//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "expr.h"
#include "keywords.h"
#include "options.h"
#include "preprocessor.h"
#include "symbol_table.h"
#include "utils.h"
#include <algorithm>
#include <cassert>
#include <fstream>
#include <set>
#include <sstream>
#include <sys/stat.h>
#include <unordered_set>

// Initialize static file cache
std::unordered_map<std::string, Preprocessor::CachedFile>
Preprocessor::file_cache_;

void Preprocessor::clear() {
    input_queue_.clear();
    file_stack_.clear();
    macros_.clear();
    if_stack_.clear();
    dep_files_.clear(); // also reset collected dependencies
    included_once_.clear(); // reset per-instance included-once tracking
}

void Preprocessor::clear_file_cache() {
    file_cache_.clear();
}

void Preprocessor::push_file(const std::string& filename) {
    // Normalize the path to ensure consistent filenames in locations
    std::string normalized_filename = normalize_path(filename);

    // Absolute path for cache key
    std::string abs_path = absolute_path(normalized_filename);

    // If file cached with pragma_once and already included in this instance, skip
    auto cit = file_cache_.find(abs_path);
    if (cit != file_cache_.end() &&
            cit->second.tokens_file &&
            included_once_.find(abs_path) != included_once_.end()) {
        // check for #pragma once
        if (cit->second.tokens_file->has_pragma_once()) {
            // Record dependency even when skipped
            dep_files_.push_back(normalized_filename);
            return; // skip include entirely
        }
        // check for #ifndef/#define
        if (cit->second.tokens_file->has_ifndef_guard()) {
            const std::string& guard_symbol =
                cit->second.tokens_file->ifndef_guard_symbol();
            auto mit = macros_.find(guard_symbol);
            if (mit != macros_.end()) {
                // Record dependency even when skipped
                dep_files_.push_back(normalized_filename);
                return; // skip include entirely
            }
        }
    }

    // Check if this file is already on the stack (recursive include detection)
    for (const File& f : file_stack_) {
        if (f.tokens_file &&
                f.tokens_file->filename() == normalized_filename) {
            g_errors.error(ErrorCode::RecursiveInclude,
                           normalized_filename);

            // Clear the file stack and input queue to stop all processing
            file_stack_.clear();
            input_queue_.clear();
            if_stack_.clear();
            return;
        }
    }

    // Get or create cached file
    std::shared_ptr<TokensFile> cached_tokens = get_cached_file(
                normalized_filename);

    // Record dependency (keep order, allow duplicates)
    dep_files_.push_back(normalized_filename);

    // Track inclusion for pragma once logic
    included_once_.insert(abs_path);

    // Take ownership via shared_ptr
    File f;
    f.tokens_file = cached_tokens;
    f.line_index = 0;
    f.has_forced_location = false;
    f.forced_constant_line_numbers = false;
    f.is_macro_expansion = false;
    f.exitm_found = false;

    // detect #ifndef/#define guard
    std::string symbol;
    if (detect_ifndef_guard(f, symbol)) {
        f.tokens_file->set_has_ifndef_guard(true);
        f.tokens_file->set_ifndef_guard_symbol(symbol);
    }

    file_stack_.push_back(std::move(f));
}

void Preprocessor::push_virtual_file(const std::string& content,
                                     const std::string& filename,
                                     int first_line_num,
                                     bool inc_line_nums) {
    File vf;
    vf.tokens_file = std::make_shared<TokensFile>(content, filename,
                     first_line_num,
                     inc_line_nums);
    vf.line_index = 0;
    vf.has_forced_location = false;
    vf.forced_constant_line_numbers = false;
    vf.is_macro_expansion = false;
    vf.exitm_found = false;
    file_stack_.push_back(std::move(vf));
}

void Preprocessor::push_virtual_file(const std::vector<TokensLine>& tok_lines,
                                     const std::string& filename,
                                     int first_line_num,
                                     bool inc_line_nums) {
    File vf;
    vf.tokens_file = std::make_shared<TokensFile>(tok_lines, filename,
                     first_line_num, inc_line_nums);
    vf.line_index = 0;
    vf.has_forced_location = false;
    vf.forced_constant_line_numbers = false;
    vf.is_macro_expansion = false;
    vf.exitm_found = false;
    file_stack_.push_back(std::move(vf));
}

void Preprocessor::push_binary_file(const std::string& bin_filename,
                                    const Location& location) {

    // Record dependency first (order-preserving, duplicates allowed)
    dep_files_.push_back(normalize_path(bin_filename));

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
        size_t byte_count = end - i;

        TokensLine line(location);
        // Reserve: 2 initial tokens (DEFB + space) + byte_count integers + (byte_count-1) commas
        line.reserve(2 + byte_count * 2 - 1);
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
        // If we have queued lines, process them as full input
        // (including directives)
        if (!input_queue_.empty()) {
            line = std::move(input_queue_.front());
            input_queue_.pop_front();

            if (handle_directives_for_line(line, true)) {
                continue;
            }
            else {
                return true;
            }
        }

        // read lines from top file in stack
        if (!fetch_line(line)) {
            // no more input
            line.clear();
            return false;
        }

        if (handle_directives_for_line(line, false)) {
            continue;
        }

        // expand macros in the line
        Location location = line.location();
        std::vector<TokensLine> expanded;

        bool changed_line = expand_macros(line, true, expanded);
        if (!changed_line) {
            // Refactored path: fast handling of unchanged line (and optional ## re-pass)
            std::vector<TokensLine> final_lines;
            finalize_line(line, false, final_lines);
            if (final_lines.size() == 1) {
                line = final_lines.front();
                return true;
            }
            add_virtual_file(final_lines);
            continue;
        }

        if (expanded.empty()) {
            continue;
        }

        add_virtual_file(expanded);
    }
}

void Preprocessor::define_macro(const std::string& name,
                                const std::string replacement) {
    TokensFile tf(replacement, "<macro>", 1, false);
    define_macro(name, tf.tok_lines());
}

void Preprocessor::define_macro(const std::string& name,
                                const std::vector<TokensLine>& replacement) {
    if (macros_.find(name) != macros_.end()) {
        g_errors.error(ErrorCode::MacroRedefined, name);
    }

    Macro m;
    m.replacement = replacement;
    m.params.clear();
    m.locals.clear();
    m.is_function_like = false;
    m.recursion_depth = 0;
    macros_[name] = std::move(m);
}

// Dependency collection API
// Returns the list of files that were pushed via push_file/push_binary_file,
// in the order they were recorded (duplicates preserved).
const std::vector<std::string>& Preprocessor::dependency_filenames() const {
    return dep_files_;
}

// Clears the collected dependency filenames.
void Preprocessor::clear_dependencies() {
    dep_files_.clear();
}

void Preprocessor::preprocess_file(const std::string& input_filename,
                                   const std::string& output_filename, bool gen_dependency) {
    Preprocessor pp;

    pp.push_file(input_filename);

    std::ofstream ofs(output_filename, std::ios::out | std::ios::binary);
    if (!ofs) {
        g_errors.error(ErrorCode::FileOpenError, output_filename);
        return;
    }

    Location location;
    TokensLine line;
    while (pp.next_line(line)) {
        if (g_errors.filename() != location.filename()) {
            // filename changed (e.g. due to #include)
            location.set_filename(g_errors.filename());
            location.set_line_num(g_errors.line_num());
            ofs << "#line " << location.line_num() << ", \"" << location.filename() << "\""
                << std::endl;
        }
        else if (g_errors.line_num() < location.line_num()) {
            // Line number decreased (e.g. due to #line directive)
            location.set_line_num(g_errors.line_num());
            ofs << "#line " << location.line_num() << std::endl;
        }
        else {
            // Normal line increment
            while (g_errors.line_num() > location.line_num()) {
                ofs << std::endl;
                location.inc_line_num();
            }
            location.set_line_num(g_errors.line_num());
        }
        ofs << line.to_string() << std::endl;
        location.inc_line_num();
    }

    if (gen_dependency) {
        pp.generate_dependency_file();
    }
}

void Preprocessor::generate_dependency_file() {
    const unsigned LINE_WIDTH = 80;

    std::vector<std::string> deps = dependency_filenames();
    if (deps.empty()) {
        return;
    }

    // get main source file
    std::string target = deps.front();

    // get dependency file name and target file name
    std::string d_filename = get_d_filename(target);
    std::string o_filename = get_o_filename(target);

    // generate dependency file
    std::ofstream ofs(d_filename, std::ios::out | std::ios::binary);
    if (!ofs) {
        g_errors.error(ErrorCode::FileOpenError, d_filename);
        return;
    }

    if (g_options.verbose) {
        std::cout << "Generating dependency file: " << d_filename << std::endl;
    }

    // output file names
    size_t pos = 0;
    ofs << o_filename << ":";
    pos += o_filename.size() + 1;

    for (auto& f : deps) {
        if (pos + f.size() + 1 + 2 >= LINE_WIDTH) { // +2: account for space-backslash
            pos = 7;
            ofs << " \\" << std::endl << std::string(pos, ' ');
        }

        ofs << " " << f;
        pos += f.size() + 1;
    }
    ofs << std::endl;
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
    // use unordered_set for faster duplicate checks
    std::unordered_set<std::string> seen_params;
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
                const std::string& param_name = line[j].text();

                // Check for duplicate parameter name
                if (seen_params.find(param_name) != seen_params.end()) {
                    g_errors.error(ErrorCode::DuplicateDefinition,
                                   param_name);
                }
                seen_params.insert(param_name);
                out_params.push_back(param_name);
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
    cur_arg.reserve(8);
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
    // accept negative line numbers
    int sign = 1;
    line.skip_spaces(i);
    if (i < line.size() && line[i].is(TokenType::Minus)) {
        ++i;
        sign = -1;
    }

    line.skip_spaces(i);
    if (!(i < line.size() && line[i].is(TokenType::Integer))) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Expected line number in ") +
                       keyword_to_string(keyword) + " directive");
        return false;
    }

    out_linenum = sign * line[i].int_value();
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
    // Reserve remaining tokens as baseline capacity
    if (i < line.size()) {
        result.reserve(line.size() - i);
    }
    while (i < line.size()) {
        result.push_back(line[i]);
        ++i;
    }
    result.trim();
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

bool Preprocessor::eval_if_expr(const TokensLine& line, unsigned& i,
                                Keyword keyword) {
    TokensLine expr_line = collect_tokens(line, i);
    if (expr_line.empty()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected expression in " + keyword_to_string(keyword));
    }
    TokensLine expr_tokens = expand_macros_in_line(expr_line);

    // evaluate the expression in silent mode, use 0 if it fails
    int cond_value = 0;
    if (!eval_const_expr(expr_tokens, cond_value, true)) {
        cond_value = 0;
    }

    return (cond_value != 0);
}

bool Preprocessor::eval_ifdef_name(const TokensLine& line, unsigned& i,
                                   bool negated, Keyword keyword) {
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier in " + keyword_to_string(keyword));
        return false;
    }
    expect_end(line, i);

    // check the macros
    bool is_def = macros_.find(name) != macros_.end();
    if (!is_def) {
        // also check symbol table
        const Symbol& sym = g_symbol_table.get_symbol(name);
        is_def = sym.is_defined;
    }

    bool cond = negated ? !is_def : is_def;
    return cond;
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
    unsigned start = i;
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

    i = start;  // rewind
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
    case Keyword::PRAGMA:
        process_pragma(line, i);
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
        assert(0);
    }
}

void Preprocessor::process_contitional_directive(const TokensLine& line,
        unsigned& i, Keyword keyword) {
    switch (keyword) {
    case Keyword::IF:
        process_if(line, i);
        break;
    case Keyword::IFDEF:
        process_ifdef(line, i, false);
        break;
    case Keyword::IFNDEF:
        process_ifdef(line, i, true);
        break;
    case Keyword::ELIF:
        process_elif(line, i);
        break;
    case Keyword::ELIFDEF:
        process_elifdef(line, i, false);
        break;
    case Keyword::ELIFNDEF:
        process_elifdef(line, i, true);
        break;
    case Keyword::ELSE:
        process_else(line, i);
        break;
    case Keyword::ENDIF:
        process_endif(line, i);
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
    std::string including_filename;
    if (!file_stack_.empty()) {
        const File& top_file = file_stack_.back();
        including_filename = top_file.tokens_file->filename();
    }
    std::string resolved = resolve_include_candidate(filename, including_filename,
                           is_angle);
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
        file.forced_filename = file.tokens_file->filename();
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
        file.forced_filename = file.tokens_file->filename();
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
    macro.recursion_depth = 0;

    // Report redefinition for DEFINE (not for DEFL)
    if (macros_.find(name) != macros_.end()) {
        g_errors.error(ErrorCode::MacroRedefined, name);
    }

    macros_[name] = std::move(macro);
}

void Preprocessor::process_equ(const TokensLine& line, unsigned& i) {
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after EQU");
        return;
    }
    line.skip_spaces(i);
    if (i < line.size() && line[i].is(TokenType::EQ)) {
        ++i;
        line.skip_spaces(i);
    }
    TokensLine value = collect_tokens(line, i);
    TokensLine expanded = expand_macros_in_line(value);
    TokensLine defc(line.location());
    defc.reserve(6 + expanded.size());
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

void Preprocessor::process_name_equ(const TokensLine& line, unsigned& i,
                                    const std::string& name) {
    line.skip_spaces(i);
    if (i < line.size() && line[i].is(TokenType::EQ)) {
        ++i;
        line.skip_spaces(i);
    }
    TokensLine value = collect_tokens(line, i);
    TokensLine expanded = expand_macros_in_line(value);
    TokensLine defc(line.location());
    defc.reserve(6 + expanded.size());
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
    if (eval_const_expr(expr_tokens, value, true)) {
        body.clear_tokens();
        body.push_back(Token(TokenType::Integer, std::to_string(value), value));
    }

    Macro macro;
    macro.params.clear();
    macro.replacement.clear();
    macro.replacement.push_back(body);
    macro.recursion_depth = 0;

    // 6) Register/overwrite the macro definition of <name>.
    macros_[name] = std::move(macro);
}

bool Preprocessor::output_active() const {
    // check for exitm called
    if (!file_stack_.empty()) {
        const File& top = file_stack_.back();
        if (top.is_macro_expansion && top.exitm_found) {
            return false;
        }
    }

    // check IF stack
    if (if_stack_.empty()) {
        return true;
    }
    for (size_t n = 0; n < if_stack_.size(); ++n) {
        if (!if_stack_[n].branch_active) {
            return false;
        }
    }
    return true;
}

bool Preprocessor::fetch_line(TokensLine& out) {
    while (!file_stack_.empty()) {
        out.clear();
        File& file = file_stack_.back();

        // get from split queue
        if (!file.split_queue_.empty()) {
            out = std::move(file.split_queue_.front());
            file.split_queue_.pop_front();
            if (out.empty()) {
                // skip empty lines
                continue;
            }

            g_errors.set_location(out.location());
            g_errors.set_expanded_line(out.to_string());
            return true;
        }

        // get from inout file
        if (file.line_index >= file.tokens_file->tok_lines_count()) {
            // end of file reached; pop file from stack
            file_stack_.pop_back();
            continue;
        }

        // get next line from file (physical or virtual)
        out = file.tokens_file->get_tok_line(file.line_index);
        out.trim();
        ++file.line_index;

        // skip empty lines
        if (out.empty()) {
            continue;
        }

        // compute Location
        Location loc = compute_location(file, out);
        out.set_location(loc);

        g_errors.set_location(out.location());
        g_errors.set_source_line(out.to_string());

        // split line
        std::vector<TokensLine> segments;
        if (!split_line(out, segments)) {
            return true;    // did not split
        }

        for (auto& segment : segments) {
            file.split_queue_.push_back(std::move(segment));
        }
    }

    // no more input
    if (!if_stack_.empty()) {
        // Report unclosed conditional at end of input
        const IfFrame& top_frame = if_stack_.back();
        g_errors.set_location(top_frame.location);
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected end of input in IF (expected ENDIF)");
        if_stack_.clear();
    }

    out.clear();
    return false;
}

// Compute logical location here based on current file mapping.
// Rules:
// - If LINE/C_LINE was seen in this file: use forced_filename (if set) and
//   either constant line number (C_LINE) or LINE + (physical_index - forced_from_index)
// - Otherwise: use file's own filename() and first_line_num() + physical_index
Location Preprocessor::compute_location(const File& file,
                                        const TokensLine& out) {
    // true physical line number from source
    const int physical_line = out.location().line_num();

    Location loc = out.location();

    if (file.has_forced_location) {
        if (!file.forced_filename.empty()) {
            loc.set_filename(file.forced_filename);
        }
        else {
            loc.set_filename(file.tokens_file->filename());
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
        loc.set_filename(file.tokens_file->filename());
        loc.set_line_num(physical_line);
    }

    return loc;
}

void Preprocessor::collect_guard_segments(File& file, TokensLine& line,
        unsigned& line_index, std::vector<TokensLine>& segments) {
    while (segments.empty() && line_index < file.tokens_file->tok_lines_count()) {
        line = file.tokens_file->get_tok_line(line_index++);
        line.trim();
        if (line.empty()) {
            continue;
        }
        split_line(line, segments);
        while (!segments.empty() && segments.front().empty()) {
            segments.erase(segments.begin());
        }
    }
}

bool Preprocessor::split_line(const TokensLine& line,
                              std::vector<TokensLine>& out_segments) {
    out_segments.clear();
    if (line.empty()) {
        return false;
    }
    bool did_split = false;
    int ternary_depth = 0;
    unsigned i = 0;
    while (split_label(line.location(), line, i, out_segments)) {
        did_split = true;
    }
    TokensLine segment(line.location());
    line.skip_spaces(i);
    if (i < line.size()) {
        segment.reserve(line.size() - i);
    }
    out_segments.reserve(4);
    while (i < line.size()) {
        const Token& t = line[i];
        if ((t.is(TokenType::Colon) && ternary_depth == 0)
                || t.is(TokenType::Backslash)) {
            did_split = true;
            segment.trim();
            if (!segment.empty()) {
                out_segments.push_back(std::move(segment));
            }
            segment = TokensLine(line.location());
            line.skip_spaces(++i);
            if (i < line.size()) {
                segment.reserve(line.size() - i);
            }
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
        segment.push_back(t);
        ++i;
    }
    segment.trim();
    if (!segment.empty()) {
        out_segments.push_back(std::move(segment));
    }
    return did_split;
}

bool Preprocessor::split_label(const Location& location,
                               const TokensLine& line, unsigned& i,
                               std::vector<TokensLine>& out_segments) {
    unsigned start = i;
    TokensLine label_line(location);
    label_line.reserve(2);
    i = start;
    line.skip_spaces(i);
    if (i < line.size() && line[i].is(TokenType::Identifier)) {
        std::string label_name = line[i].text();
        Keyword label_kw = line[i].keyword();
        if (keyword_is_instruction(label_kw)) {
            i = start;
            line.skip_spaces(i);
            return false;
        }
        ++i;
        line.skip_spaces(i);
        if (i < line.size() && line[i].is(TokenType::Colon)) {
            ++i;
            label_line.push_back(Token(TokenType::Dot, "."));
            label_line.push_back(Token(TokenType::Identifier, label_name));
            out_segments.push_back(std::move(label_line));
            line.skip_spaces(i);
            return true;
        }
    }
    i = start;
    line.skip_spaces(i);
    if (i < line.size() && line[i].is(TokenType::Dot)) {
        ++i;
        line.skip_spaces(i);
        if (i < line.size() && line[i].is(TokenType::Identifier)) {
            std::string label_name = line[i].text();
            ++i;
            label_line.push_back(Token(TokenType::Dot, "."));
            label_line.push_back(Token(TokenType::Identifier, label_name));
            out_segments.push_back(std::move(label_line));
            line.skip_spaces(i);
            return true;
        }
    }
    i = start;
    line.skip_spaces(i);
    return false;
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
    if (file.line_index >= file.tokens_file->tok_lines_count()) {
        return false;
    }

    // Return the raw stored line; next_line() will handle user-visible mapping.
    out = file.tokens_file->get_tok_line(file.line_index);
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

// Helper to get file modification time
static std::time_t get_file_mod_time(const std::string& filename) {
#ifdef _WIN32
    struct _stat file_stat;
    if (_stat(filename.c_str(), &file_stat) == 0) {
        return file_stat.st_mtime;
    }
#else
    struct stat file_stat;
    if (stat(filename.c_str(), &file_stat) == 0) {
        return file_stat.st_mtime;
    }
#endif
    return 0; // Return 0 if stat fails
}

std::shared_ptr<TokensFile> Preprocessor::get_cached_file(
    const std::string& normalized_filename) {
    // Get the absolute path for cache indexing
    std::string abs_path = absolute_path(normalized_filename);

    // Get current modification time
    std::time_t current_mod_time = get_file_mod_time(abs_path);

    // Check if file is in cache
    auto it = file_cache_.find(abs_path);
    if (it != file_cache_.end()) {
        // Check if cached version is still valid
        if (it->second.mod_time >= current_mod_time &&
                current_mod_time != 0) {
            // Cache hit - file hasn't been modified
            return it->second.tokens_file;
        }
        // File was modified - remove stale entry
        file_cache_.erase(it);
    }

    // Cache miss or stale entry - read and tokenize the file
    auto tokens_file = std::make_shared<TokensFile>(
                           normalized_filename, 1);

    // Add to cache
    CachedFile cached;
    cached.tokens_file = tokens_file;
    cached.mod_time = current_mod_time;
    file_cache_[abs_path] = cached;

    return tokens_file;
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

    // Register the macro definition
    Macro macro;
    macro.params = std::move(params);
    macro.locals = std::move(locals);
    macro.is_function_like = (!macro.params.empty())
                             || had_paren; // true if params or empty ()
    macro.replacement = std::move(body);
    macro.recursion_depth = 0;

    // Report redefinition for MACRO (not for DEFL)
    if (macros_.find(name) != macros_.end()) {
        g_errors.error(ErrorCode::MacroRedefined, name);
    }

    macros_[name] = std::move(macro);
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
        for (unsigned k = 0; k < flat.size(); k++) {
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
        for (unsigned k = 0; k < flat.size(); k++) {
            const Token& tk = flat[k];
            if (tk.is(TokenType::String)) {
                iter_text = tk.string_value();
                break;
            }
        }
    }
    else if (is_only_token_type(TokenType::Integer)) {
        for (unsigned k = 0; k < flat.size(); k++) {
            const Token& tk = flat[k];
            if (tk.is(TokenType::Integer)) {
                iter_text = std::to_string(tk.int_value());
                break;
            }
        }
    }
    else {
        // Concatenate non-whitespace token texts
        for (unsigned k = 0; k < flat.size(); k++) {
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

    for (unsigned ci = 0; ci < iter_text.size(); ci++) {
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
    out_lines.reserve(flat_args.size() * body.size());
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

// --- IF / ELIF / ELSE / ENDIF (no virtual files) --------------------------------

void Preprocessor::process_if(const TokensLine& line, unsigned& i) {
    bool cond_value = eval_if_expr(line, i, Keyword::IF);

    IfFrame fr;
    fr.branch_active = cond_value;
    fr.any_taken = cond_value;
    fr.seen_else = false;
    if_stack_.push_back(fr);
}

void Preprocessor::process_elif(const TokensLine& line, unsigned& i) {
    if (if_stack_.empty()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected ELIF directive without matching IF");
        return;
    }

    IfFrame& fr = if_stack_.back();
    if (fr.seen_else) {
        g_errors.error(ErrorCode::InvalidSyntax, "ELIF after ELSE");
        // still parse remaining tokens to consume the line
    }

    bool cond_value = eval_if_expr(line, i, Keyword::ELIF);
    bool active_now = (!fr.any_taken) && cond_value;
    fr.branch_active = active_now;
    if (active_now) {
        fr.any_taken = true;
    }
}

void Preprocessor::process_else(const TokensLine& line, unsigned& i) {
    if (if_stack_.empty()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected ELSE directive without matching IF");
        return;
    }

    IfFrame& fr = if_stack_.back();
    expect_end(line, i);
    if (fr.seen_else) {
        g_errors.error(ErrorCode::InvalidSyntax, "Multiple ELSE in IF block");
    }

    fr.branch_active = !fr.any_taken;
    fr.any_taken = true;
    fr.seen_else = true;
}

void Preprocessor::process_endif(const TokensLine& line, unsigned& i) {
    if (if_stack_.empty()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected ENDIF directive without matching IF");
        return;
    }
    expect_end(line, i);
    if_stack_.pop_back();
}

// --- IFDEF / IFNDEF / ELIFDEF / ELIFNDEF ---------------------------------------

void Preprocessor::process_ifdef(const TokensLine& line, unsigned& i,
                                 bool negated) {
    bool cond = eval_ifdef_name(line, i, negated, Keyword::IFDEF);

    IfFrame fr;
    fr.branch_active = cond;
    fr.any_taken = cond;
    fr.seen_else = false;
    if_stack_.push_back(fr);
}

void Preprocessor::process_elifdef(const TokensLine& line, unsigned& i,
                                   bool negated) {
    IfFrame& fr = if_stack_.back();
    if (fr.seen_else) {
        g_errors.error(ErrorCode::InvalidSyntax, "ELIFDEF/ELIFNDEF after ELSE");
        // still parse identifier to consume line
    }

    bool cond = eval_ifdef_name(line, i, negated, Keyword::ELIFDEF);
    bool active_now = (!fr.any_taken) && cond;
    fr.branch_active = active_now;
    if (active_now) {
        fr.any_taken = true;
    }
}

void Preprocessor::process_exitm(const TokensLine& line, unsigned& i) {
    expect_end(line, i);
    do_exitm();
}

void Preprocessor::do_exitm() {
    if (!file_stack_.empty()) {
        File& top = file_stack_.back();
        if (top.is_macro_expansion) {
            top.exitm_found = true;
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
        out_locals.insert(out_locals.end(), local_names.begin(),
                          local_names.end());
    }
    else {
        // Restore to allow "LOCAL" with no params
        i = before;
    }
    // Validate no trailing tokens
    expect_end(line, i);
}

void Preprocessor::process_pragma(const TokensLine& line, unsigned& i) {
    line.skip_spaces(i);
    if (i < line.size() && line[i].is(Keyword::ONCE)) {
        ++i;
        expect_end(line, i);
        if (!file_stack_.empty()) {
            File& top = file_stack_.back();
            if (top.tokens_file) {
                top.tokens_file->set_has_pragma_once();
            }
        }
    }
    else {
        // ignore unknown pragmata
    }
}

// Replace strings by comma-separated integers
bool Preprocessor::post_process_line(const TokensLine& line, TokensLine& out) {
    // Fast path: if no string tokens present, only trimming may be needed.
    if (!line.has_token_type(TokenType::String)) { // replaced has_token_type
        out = line;
        // Trim whitespace; if trim changes, return true, else false
        bool trimmed = out.trim();
        return trimmed;
    }

    // Precompute capacity after expanding strings into comma-separated integers
    size_t capacity = 0;
    for (unsigned k = 0; k < line.size(); ++k) {
        const Token& t = line[k];
        if (t.is(TokenType::String)) {
            size_t L = t.string_value().size();
            if (L == 0) {
                capacity += 0;
            }
            else {
                capacity += (2 * L - 1);
            }
        }
        else {
            capacity += 1;
        }
    }
    out = TokensLine(line.location());
    out.reserve(capacity);
    bool changed = false;
    unsigned i = 0;
    while (i < line.size()) {
        const Token& t = line[i];
        if (t.is(TokenType::String)) {
            changed = true;
            std::string str_val = t.string_value();
            ++i;
            bool is_first = true;
            for (char c : str_val) {
                if (!is_first) {
                    out.push_back(Token(TokenType::Comma, ","));
                }
                int char_int = static_cast<int>(static_cast<unsigned char>(c));
                out.push_back(Token(TokenType::Integer, std::to_string(char_int), char_int));
                is_first = false;
            }
        }
        else {
            out.push_back(t);
            ++i;
        }
    }
    if (out.trim()) {
        changed = true;
    }
    if (!changed) {
        out = line;
    }
    return changed;
}

void Preprocessor::add_virtual_file(std::vector<TokensLine> expanded) {
    if (expanded.empty()) {
        return;
    }

    // Refactored: reuse finalize_line for each expanded line with full processing.
    std::vector<TokensLine> out;
    out.reserve(expanded.size() * 2);

    for (auto& tkl : expanded) {
        std::vector<TokensLine> processed;
        finalize_line(tkl, true, processed);
        out.insert(out.end(), processed.begin(), processed.end());
    }

    if (out.empty()) {
        return;
    }
    else if (out.size() == 1) {
        input_queue_.push_back(out.front());
        return;
    }

    push_virtual_file(out, expanded[0].location().filename(),
                      expanded[0].location().line_num(), false);

    if (expanded.size() > 1 && !file_stack_.empty()) {
        File& top = file_stack_.back();
        top.is_macro_expansion = true;
    }
}

bool Preprocessor::merge_double_hash(const TokensLine& line, TokensLine& out) {
    if (!line.has_token_type(TokenType::DoubleHash)) {
        out = line;
        return false;
    }
    out = TokensLine(line.location());
    out.reserve(line.size());
    bool merged_any = false;
    unsigned idx = 0;
    while (idx < line.size()) {
        const Token& cur = line[idx];
        if (cur.is(TokenType::Identifier)) {
            unsigned j = idx + 1;
            line.skip_spaces(j);
            if (j < line.size() && line[j].is(TokenType::DoubleHash)) {
                unsigned k = j + 1;
                line.skip_spaces(k);
                if (k < line.size() && (line[k].is(TokenType::Identifier)
                                        || line[k].is(TokenType::Integer))) {
                    std::string glued = cur.text() + line[k].text();
                    out.push_back(Token(TokenType::Identifier, glued));
                    idx = k + 1;
                    merged_any = true;
                    continue;
                }
            }
        }
        out.push_back(cur);
        ++idx;
    }
    return merged_any;
}

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
// (used for '#' stringize). On failure returns false (syntax error).
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
        std::vector<TokensLine> expanded;
        expand_macros(argline, false, expanded);
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
            std::string escaped = escape_c_string(joined);
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
bool Preprocessor::substitute_and_expand(
    Macro& macro,
    const std::vector<std::vector<TokensLine>>& expanded_args_flat,
    const std::vector<TokensLine>& original_args,
    std::vector<TokensLine>& out_expanded) {

    out_expanded.clear();
    bool did_substitute = false; // track any transformation

    // LOCAL renaming map (mark did_substitute only on actual local substitution later)
    std::unordered_map<std::string, std::string> local_rename;
    if (!macro.locals.empty()) {
        ++local_id_counter_;
        const std::string suffix = "_" + std::to_string(local_id_counter_);
        for (const std::string& ln : macro.locals) {
            local_rename[ln] = ln + suffix;
        }
    }

    // Collect substituted (before recursive macro expansion)
    std::vector<TokensLine> substituted;
    substituted.reserve(macro.replacement.size());

    for (const TokensLine& rep_line : macro.replacement) {
        std::vector<TokensLine> temp_lines;
        temp_lines.emplace_back(rep_line.location());

        unsigned pidx = 0;
        while (pidx < rep_line.size()) {
            const Token& rt = rep_line[pidx];

            // Stringize operator #
            if (rt.is(TokenType::Hash)) {
                if (try_stringize_parameter(rep_line, pidx, macro,
                                            original_args, temp_lines.back())) {
                    did_substitute = true;
                    continue;
                }
                // literal '#'
                temp_lines.back().push_back(rt);
                ++pidx;
                continue;
            }

            bool param_substituted = false;

            // Parameter substitution
            if (rt.is(TokenType::Identifier)) {
                for (unsigned pi = 0; pi < macro.params.size(); ++pi) {
                    if (rt.text() == macro.params[pi]) {
                        const auto& arg_lines = expanded_args_flat[pi];
                        if (!arg_lines.empty()) {
                            // first line
                            const TokensLine& first_arg = arg_lines.front();
                            for (unsigned at = 0; at < first_arg.size(); ++at) {
                                temp_lines.back().push_back(first_arg[at]);
                            }
                            // subsequent lines become new temp lines
                            for (size_t al = 1; al < arg_lines.size(); ++al) {
                                temp_lines.emplace_back(rep_line.location());
                                const TokensLine& later_arg = arg_lines[al];
                                for (unsigned at = 0; at < later_arg.size(); ++at) {
                                    temp_lines.back().push_back(later_arg[at]);
                                }
                            }
                        }
                        param_substituted = true;
                        did_substitute = true;
                        break;
                    }
                }
            }

            if (!param_substituted) {
                // LOCAL rename or literal copy
                if (rt.is(TokenType::Identifier)) {
                    auto it = local_rename.find(rt.text());
                    if (it != local_rename.end()) {
                        temp_lines.back().push_back(Token(TokenType::Identifier, it->second));
                        did_substitute = true; // mark only on actual local substitution
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

        // Token-paste (##) after substitution; return value indicates if a merge happened
        for (TokensLine& tln : temp_lines) {
            TokensLine merged;
            bool merged_any = merge_double_hash(tln, merged);
            if (merged_any) {
                did_substitute = true;
            }
            substituted.push_back(std::move(merged));
        }
    }

    // Decide if we need another macro expansion pass inside substituted lines:
    // Only if some substitution/token-paste happened.
    if (!did_substitute) {
        out_expanded = substituted;
        return false;
    }

    // Further macro expansion (may create additional lines)
    int& rc = macro.recursion_depth;
    rc++;
    std::vector<TokensLine> further_expanded;
    expand_macros(substituted, false, further_expanded);
    rc--;

    out_expanded = std::move(further_expanded);
    return true;
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
    if (further_expanded.size() > 1) {
        result.reserve(result.size() + further_expanded.size() - 1);
    }
    for (unsigned rr = 1; rr < further_expanded.size(); ++rr) {
        result.push_back(out);
        out = TokensLine(in_location);
        const TokensLine& el = further_expanded[rr];
        for (unsigned kk = 0; kk < el.size(); ++kk) {
            out.push_back(el[kk]);
        }
    }
}

bool Preprocessor::expand_macros(const TokensLine& line, bool at_start,
                                 std::vector<TokensLine>& out) {
    std::vector<TokensLine> lines{ line };
    return expand_macros(lines, at_start, out);
}

bool Preprocessor::expand_macros(const std::vector<TokensLine>& lines,
                                 bool at_start,
                                 std::vector<TokensLine>& out) {

    out.clear();
    bool any_changed = false;

    for (const TokensLine& in_line : lines) {
        // Skip macro expansion only for lines that start with a directive.
        if (at_start) {
            unsigned di = 0;
            Keyword dkw = Keyword::None;
            std::string name;
            if (is_directive(in_line, di, dkw)) {
                out.push_back(in_line); // leave directive line untouched
                continue;
            }
            di = 0;
            if(is_name_directive(in_line, di, dkw, name)) {
                out.push_back(in_line); // leave name-directive line untouched
                continue;
            }
        }

        // Per-line change tracking
        bool line_changed = false;
        TokensLine current(in_line.location());
        std::vector<TokensLine> multi_line_result;
        unsigned idx = 0;

        // Reserve typical small sizes to avoid reallocs
        multi_line_result.reserve(4);

        while (idx < in_line.size()) {
            const Token& tok = in_line[idx];

            if (!tok.is(TokenType::Identifier)) {
                current.push_back(tok);
                ++idx;
                continue;
            }

            std::string name = tok.text();
            auto mit = macros_.find(name);
            if (mit == macros_.end()) {
                current.push_back(tok);
                ++idx;
                continue;
            }

            Macro& macro = mit->second;
            int& rc = macro.recursion_depth;
            if (rc >= MAX_MACRO_RECURSION) {
                g_errors.error(ErrorCode::MacroRecursionLimit,
                               "Macro recursion limit reached for: " + name);
                current.push_back(tok);
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
                // Parse & expand arguments
                std::vector<std::vector<TokensLine>> expanded_args_flat;
                std::vector<TokensLine> original_args;
                unsigned after_idx = 0;
                if (!parse_and_expand_macro_args(in_line,
                                                 args_start_idx,
                                                 expanded_args_flat,
                                                 original_args,
                                                 after_idx)) {
                    current.push_back(tok);
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
                    current.push_back(tok);
                    ++idx;
                    continue;
                }

                // Substitute parameters and expand the replacement
                std::vector<TokensLine> further_expanded;
                substitute_and_expand(macro,
                                      expanded_args_flat,
                                      original_args,
                                      further_expanded);

                line_changed = true;
                any_changed = true;

                append_expansion_into_out(further_expanded, current, multi_line_result,
                                          in_line.location());

                // advance idx past the consumed args (works for both paren and non-paren forms)
                idx = after_idx;
            }
            else if (macro.params.empty()) {
                // Object-like macro always counts as a change
                line_changed = true;
                any_changed = true;

                std::vector<TokensLine> substituted = macro.replacement;
                rc++;
                std::vector<TokensLine> further_expanded;
                bool inner_changed = expand_macros(substituted, at_start, further_expanded);
                any_changed = any_changed || inner_changed;
                rc--;

                append_expansion_into_out(further_expanded, current, multi_line_result,
                                          in_line.location());

                ++idx;
            }
            else {
                // has params but not a call -> treat literally
                current.push_back(tok);
                ++idx;
            }
        }

        multi_line_result.push_back(current);

        if (!line_changed) {
            out.push_back(in_line);
        }
        else {
            for (const TokensLine& ml : multi_line_result) {
                out.push_back(ml);
            }
        }
    }

    return any_changed;
}

TokensLine Preprocessor::expand_macros_in_line(const TokensLine& line) {
    std::vector<TokensLine> expanded_lines;
    expand_macros(line, false, expanded_lines);

    if (expanded_lines.size() == 1) {
        TokensLine single = expanded_lines.front();
        single.trim();
        return single;
    }

    TokensLine expanded(line.location());
    expanded.reserve(expanded_lines.size());
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
    expanded.trim();

    return expanded;
}

bool Preprocessor::detect_ifndef_guard(File& file, std::string& out_symbol) {
    out_symbol.clear();

    TokensLine line;
    unsigned line_index = 0;

    // no more lines
    if (line_index >= file.tokens_file->tok_lines_count()) {
        return false;
    }

    std::string ifndef_name, define_name;
    std::vector<TokensLine> segments;

    // Read first line and split into segments
    collect_guard_segments(file, line, line_index, segments);
    if (segments.empty()) {
        return false;
    }

    // First line must be #ifndef <name>
    Keyword kw = Keyword::None;
    unsigned pos = 0;
    if (!(pos < segments[0].size() && is_directive(line, pos, kw) &&
            kw == Keyword::IFNDEF)) {
        return false;
    }
    ++pos;
    if (!parse_identifier(line, pos, ifndef_name)) {
        return false;
    }
    segments.erase(segments.begin());

    // Read second line or second segment of first line
    collect_guard_segments(file, line, line_index, segments);
    if (segments.empty()) {
        return false;
    }

    // Second must be #define <same_name>
    kw = Keyword::None;
    pos = 0;
    if (!(pos < segments[0].size() && is_directive(line, pos, kw) &&
            kw == Keyword::DEFINE)) {
        return false;
    }
    ++pos;
    if (!parse_identifier(line, pos, define_name)) {
        return false;
    }

    if (ifndef_name != define_name) {
        return false;
    }

    // found #ifndef/#define
    out_symbol = define_name;
    return true;
}

bool Preprocessor::handle_directives_for_line(TokensLine& line,
        bool reading_from_queue) {
    // skip empty lines
    if (line.empty()) {
        return true;
    }

    // if from queue, notify errors of expanded line
    if (reading_from_queue) {
        g_errors.set_location(line.location());
        g_errors.set_expanded_line(line.to_string());
    }

    // check for directives
    Keyword keyword = Keyword::None;
    unsigned i = 0;
    bool found_directive = false;
    if (is_directive(line, i, keyword)) {
        found_directive = true;

        // Conditional directives always execute
        if (keyword_is_conditional_directive(keyword)) {
            process_contitional_directive(line, i, keyword);
            return true;
        }
    }

    // Other directives only execute when all IFs are active
    if (!output_active()) {
        return true; // skip line
    }

    // process other directives
    if (found_directive) {
        if (reading_from_queue) {
            reading_queue_for_directive_ = true;
        }
        process_directive(line, i, keyword);
        if (reading_from_queue) {
            reading_queue_for_directive_ = false;
        }
        return true; // consume and continue
    }

    // Process name-directive
    std::string name;
    keyword = Keyword::None;
    i = 0;
    if (is_name_directive(line, i, keyword, name)) {
        if (reading_from_queue) {
            reading_queue_for_directive_ = true;
        }
        process_name_directive(line, i, keyword, name);
        if (reading_from_queue) {
            reading_queue_for_directive_ = false;
        }
        return true; // consume and continue
    }

    // ask caller to process normal line
    return false;
}

// NEW helper implementation
void Preprocessor::finalize_line(const TokensLine& in,
                                 bool full_processing,
                                 std::vector<TokensLine>& out_lines) {
    out_lines.clear();

    // Decide whether full processing (splitting + second expansion) is needed.
    bool has_tokpaste = in.has_token_type(TokenType::DoubleHash);
    bool advanced_path = full_processing || has_tokpaste;

    TokensLine after_paste;
    const TokensLine* base = &in;
    if (has_tokpaste) {
        merge_double_hash(in, after_paste);
        base = &after_paste;
    }

    if (!advanced_path) {
        // Fast path: identical to old next_line branch (no splitting)
        TokensLine pp;
        pp.reserve(base->size());
        post_process_line(*base, pp);
        out_lines.push_back(std::move(pp));
        return;
    }

    // Second macro expansion (only meaningful if token-paste occurred or full processing requested)
    std::vector<TokensLine> further;
    expand_macros(*base, true, further);

    if (further.empty()) {
        // Treat (possibly pasted) base line as single candidate
        further.push_back(*base);
    }

    for (const TokensLine& candidate : further) {
        if (full_processing) {
            // Always split in full processing mode (matches previous add_virtual_file behavior)
            std::vector<TokensLine> segments;
            if (split_line(candidate, segments)) {
                for (auto& seg : segments) {
                    TokensLine pp_seg;
                    pp_seg.reserve(seg.size());
                    post_process_line(seg, pp_seg);
                    out_lines.push_back(std::move(pp_seg));
                }
                continue;
            }
        }
        // In fast mode (next_line, no full_processing), only split if we arrived
        // here due to token-paste AND expansion produced new lines (i.e., further.size()>1).
        if (!full_processing && further.size() == 1) {
            TokensLine pp_single;
            pp_single.reserve(candidate.size());
            post_process_line(candidate, pp_single);
            out_lines.push_back(std::move(pp_single));
            continue;
        }

        // Split when there are multiple lines (macro generated extra lines) even in fast mode.
        std::vector<TokensLine> segments;
        if (split_line(candidate, segments)) {
            for (auto& seg : segments) {
                TokensLine pp_seg;
                pp_seg.reserve(seg.size());
                post_process_line(seg, pp_seg);
                out_lines.push_back(std::move(pp_seg));
            }
        }
        else {
            TokensLine pp_line;
            pp_line.reserve(candidate.size());
            post_process_line(candidate, pp_line);
            out_lines.push_back(std::move(pp_line));
        }
    }
}

void preprocess_only() {
    for (auto& asm_filename : g_input_files) {
        if (is_o_filename(asm_filename)) {
            if (g_options.verbose) {
                std::cout << "Skipping preprocessing for object file: "
                          << asm_filename << std::endl;
            }
        }
        else {
            std::string i_filename = get_i_filename(asm_filename);

            if (g_options.verbose) {
                std::cout << "Preprocessing file: " << asm_filename
                          << " -> " << i_filename << std::endl;
            }

            Preprocessor pp;
            pp.preprocess_file(asm_filename, i_filename, g_options.gen_dependencies);
        }
    }
}
