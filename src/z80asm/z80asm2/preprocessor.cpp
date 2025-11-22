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
    dep_files_.clear();
    included_once_.clear();
    current_line_chain_.reset();
    macro_fixpoint_iterations_ = 0;
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
        if (!input_queue_.empty()) {
            line = std::move(input_queue_.front());
            input_queue_.pop_front();
            if (handle_directives_for_line(line, true)) {
                continue;
            }
            else {
                TokensLine final_line;
                post_process_line(line, final_line);
                line = final_line;
                current_line_chain_.reset();
                macro_fixpoint_iterations_ = 0;
                return true;
            }
        }

        if (!fetch_line(line)) {
            line.clear();
            return false;
        }

        if (handle_directives_for_line(line, false)) {
            continue;
        }

        // --- Single-pass macro expansion with iterative feed-back ---
        {
            // merge ## operators first, then expand macros once
            TokensLine merged_line;
            std::vector<TokensLine> expanded_once;
            std::string last_macro;
            bool changed = false;
            if (merge_double_hash(line, merged_line)) {
                changed = true;
            }
            bool at_start_of_line = true;
            if (expand_macros_single_pass(merged_line, expanded_once,
                                          last_macro, at_start_of_line)) {
                changed = true;
            }
            if (expanded_once.empty()) {
                continue;
            }

            if (!changed && expanded_once.size() == 1) {
                // Do not finalize here. Queue the (possibly directive) line back so it goes
                // through normal directive handling first, then finalization happens at dequeue.
                input_queue_.push_front(expanded_once.front());
                current_line_chain_.reset();
                macro_fixpoint_iterations_ = 0;
                continue;
            }

            // Macro expansion occurred: force all expanded lines to use call-site logical location
            Location callsite = line.location();
            for (auto& l : expanded_once) {
                l.set_location(callsite);
            }

            ++macro_fixpoint_iterations_;
            if (macro_fixpoint_iterations_ > MAX_FIXPOINT_ITERATIONS) {
                std::string macro_name =
                    last_macro.empty() ? "<macro>" : last_macro;
                g_errors.error(ErrorCode::MacroRecursionLimit,
                               macro_name);

                current_line_chain_.reset();
                macro_fixpoint_iterations_ = 0;
                line.clear_tokens();
                return true;
            }

            // Push expansion as virtual file located at the call-site (constant line number)
            push_virtual_file(expanded_once,
                              callsite.filename(),
                              callsite.line_num(),
                              false);
            if (!file_stack_.empty()) {
                file_stack_.back().is_macro_expansion = true;
            }

            continue; // fetch first expanded line
        }
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
    int start_errors = g_errors.error_count();

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

    // remove output file if errors occurred
    if (g_errors.error_count() > start_errors) {
        ofs.close();
        std::remove(output_filename.c_str());
    }

    // only generate dependency file if no errors occurred
    if (gen_dependency && g_errors.error_count() == start_errors) {
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
    case Keyword::ELSEIF:
        process_elif(line, i);
        break;
    case Keyword::ELIFDEF:
    case Keyword::ELSEIFDEF:
        process_elifdef(line, i, false);
        break;
    case Keyword::ELIFNDEF:
    case Keyword::ELSEIFNDEF:
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
    // Use captured physical line number instead of current logical mapping
    file.forced_at_line_num = file.last_physical_line_num;
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
    // Use physical line number for start reference
    file.forced_at_line_num = file.last_physical_line_num;
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

    // 2) Collect raw body tokens (unexpanded)
    TokensLine raw_body = collect_tokens(line, i);
    if (raw_body.empty()) {
        // Empty body defaults to integer 1
        raw_body.clear_tokens();
        raw_body.push_back(Token(TokenType::Integer, "1", 1));
    }

    // 3) Expand macros in the body so stored value reflects current expansions
    //    (including previous value of <name> if referenced).
    TokensLine expanded_body = expand_macros_in_line(raw_body);

    // 4) Attempt constant-expression evaluation on the fully expanded body.
    //    If successful, store the numeric result. Otherwise store the expanded body as-is
    //    (supports lists like "5,6" and other non-constant sequences).
    int value = 0;
    TokensLine final_body(expanded_body.location());
    if (eval_const_expr(expanded_body, value, true)) {
        final_body.clear_tokens();
        final_body.push_back(Token(TokenType::Integer, std::to_string(value), value));
    }
    else {
        final_body = expanded_body; // preserve list / complex tokens
    }

    // 5) Register/overwrite the macro definition with the chosen body.
    Macro macro;
    macro.params.clear();
    macro.replacement.clear();
    macro.replacement.push_back(final_body);
    macro.recursion_depth = 0;
    macros_[name] = std::move(macro);
}

bool Preprocessor::output_active() const {
    // check for exitm called
    if (!file_stack_.empty()) {
        const File& top = file_stack_.back();
        if (top.exitm_found) {
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

        // end of file?
        if (file.line_index >= file.tokens_file->tok_lines_count()) {
            file_stack_.pop_back();
            continue;
        }

        // Fetch next physical line (raw location still physical here)
        out = file.tokens_file->get_tok_line(file.line_index);
        out.trim();
        ++file.line_index;

        // skip empty lines
        if (out.empty()) {
            continue;
        }

        // Capture physical line number BEFORE logical remap
        file.last_physical_line_num = out.location().line_num();

        // Compute logical location (may remap due to LINE/C_LINE)
        Location loc = compute_location(file, out);
        out.set_location(loc);

        g_errors.set_location(out.location());
        g_errors.set_source_line(out.to_string());

        // Potentially split line into segments
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
        g_errors.set_source_line("");
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

    // do not split lines with DEFINE
    unsigned i = 0;
    Keyword kw;
    if (is_directive(line, i, kw) && kw == Keyword::DEFINE) {
        return false;
    }

    i = 0;
    std::string name;
    if (is_name_directive(line, i, kw, name) && kw == Keyword::DEFINE) {
        return false;
    }

    // do not split labels
    i = 0;
    while (split_label(line, i, out_segments)) {
        did_split = true;
    }

    // split into segments
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

bool Preprocessor::split_label(const TokensLine& line, unsigned& i,
                               std::vector<TokensLine>& out_segments) {
    unsigned start = i;
    TokensLine label_line(line.location());
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
    // Parse and evaluate count expression (macro expanded).
    TokensLine count_line = collect_tokens(line, i);
    if (count_line.empty()) {
        g_errors.error(ErrorCode::InvalidSyntax, "Expected count in REPT");
        return;
    }
    TokensLine expr_tokens = expand_macros_in_line(count_line);
    int count_value = 0;
    if (!eval_const_expr(expr_tokens, count_value, false)) {
        count_value = 0; // still consume body
    }

    // Collect body (with nesting + LOCAL).
    std::vector<TokensLine> body;
    std::vector<std::string> locals;
    if (!collect_macro_body(body, locals, Keyword::REPT, Keyword::ENDR)) {
        return;
    }
    if (count_value <= 0) {
        return; // nothing to emit
    }

    // Build repeated lines using the REPT directive's logical location
    // (same logic as REPTC / REPTI for clarity).
    std::vector<TokensLine> repeated;
    repeated.reserve(static_cast<size_t>(count_value) * body.size());

    for (int iter = 0; iter < count_value; ++iter) {
        std::unordered_map<std::string, std::string> rmap;
        if (!locals.empty()) {
            ++local_id_counter_;
            const std::string suffix = "_" + std::to_string(local_id_counter_);
            for (const auto& ln : locals) {
                rmap.emplace(ln, ln + suffix);
            }
        }
        for (const TokensLine& src : body) {
            TokensLine out(line.location()); // force directive location
            out.reserve(src.size());
            for (unsigned ti = 0; ti < src.size(); ++ti) {
                const Token& tk = src[ti];
                if (tk.is(TokenType::Identifier) && !rmap.empty()) {
                    auto it = rmap.find(tk.text());
                    if (it != rmap.end()) {
                        out.push_back(Token(TokenType::Identifier, it->second));
                        continue;
                    }
                }
                out.push_back(tk);
            }
            repeated.push_back(std::move(out));
        }
    }

    push_virtual_file(repeated,
                      line.location().filename(),
                      line.location().line_num(),
                      false);
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
    fr.location = line.location();
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
    fr.location = line.location();
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
    if (file_stack_.empty()) {
        return;
    }

    // Find the latest (top-most) macro-expansion frame scanning downward.
    // If the bottom (index 0) is the only macro-expansion, we still mark it and all above.
    size_t pos = file_stack_.size();
    while (pos > 0) {
        --pos; // candidate index
        if (file_stack_[pos].is_macro_expansion) {
            for (size_t j = pos; j < file_stack_.size(); ++j) {
                file_stack_[j].exitm_found = true;
            }
            return;
        }
    }
    // No macro-expansion frame found: nothing to mark.
}

void Preprocessor::process_local(const TokensLine& line, unsigned& i,
                                 std::vector<std::string>& out_locals) {
    // `i` is positioned right after the LOCAL keyword (spaces skipped by is_directive).
    // Accept identifiers list with or without parentheses. If parsing fails, accept bare "LOCAL".
    unsigned before = i;
    std::vector<std::string> local_names;
    if (parse_params_list(line, i, local_names)) {
        // Append parsed names, reporting duplicates across the whole body
        // (duplicates inside the same LOCAL line are already caught by parse_params_list)
        for (const auto& ln : local_names) {
            if (std::find(out_locals.begin(), out_locals.end(), ln) != out_locals.end()) {
                // Report and skip adding the duplicate name
                g_errors.set_location(line.location());
                g_errors.set_expanded_line(line.to_string());
                g_errors.error(ErrorCode::DuplicateDefinition, ln);
                continue;
            }
            out_locals.push_back(ln);
        }
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
        const Token& first = line[idx];

        // Attempt to build a chained paste sequence starting from an identifier
        if (first.is(TokenType::Identifier)) {
            std::string glued = first.text();
            unsigned j = idx + 1;
            unsigned paste_start_ws_begin = 0;
            unsigned paste_start_ws_end = 0;
            bool found_any_paste = false;

            // Try to consume zero or more "## <ident|integer>" pairs.
            while (true) {
                // Record whitespace between previous glued token and next ##
                unsigned ws_begin = j;
                while (j < line.size() && line[j].is(TokenType::Whitespace)) {
                    ++j;
                }
                unsigned ws_end = j;

                if (j >= line.size() || !line[j].is(TokenType::DoubleHash)) {
                    // No more paste operator
                    break;
                }

                // Save first inter-token whitespace span so we can preserve it
                if (!found_any_paste) {
                    paste_start_ws_begin = ws_begin;
                    paste_start_ws_end = ws_end;
                }

                // Skip '##'
                ++j;

                // Skip whitespace after ##
                while (j < line.size() && line[j].is(TokenType::Whitespace)) {
                    ++j;
                }
                if (j >= line.size() ||
                        !(line[j].is(TokenType::Identifier) || line[j].is(TokenType::Integer))) {
                    // Invalid continuation: abort paste here (leave tokens untouched)
                    // Emit original identifier and any whitespace we skipped so far
                    out.push_back(first);
                    // Rewind to original next token (we consumed spaces and maybe ## incorrectly)
                    // We cannot easily rewind; safest is to restart from idx+1 original position
                    // so treat everything as normal tokens.
                    // Reconstruct: emit whitespace sequence and the '##' token we consumed partially.
                    // Simpler: fall back to copying tokens from idx+1 to current j treating them verbatim.
                    for (unsigned k = paste_start_ws_begin; k < j; ++k) {
                        out.push_back(line[k]);
                    }
                    idx = j;
                    goto next_iteration;
                }

                // Valid continuation
                glued += line[j].text();
                ++j;
                found_any_paste = true;
            }

            if (found_any_paste) {
                // Preserve the whitespace between the first identifier and the first ##
                for (unsigned k = paste_start_ws_begin; k < paste_start_ws_end; ++k) {
                    out.push_back(line[k]); // original inter-token whitespace retained
                }
                out.push_back(Token(TokenType::Identifier, glued));
                merged_any = true;
                idx = j;
                continue;
            }
        }

        // Not part of (or failed) paste sequence
        out.push_back(first);
        ++idx;

next_iteration:
        continue;
    }

    return merged_any;
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

        // Non-recursive fixpoint expansion flattened to one logical line.
        TokensLine expanded_line = expand_macros_in_line(argline);

        // Store as a single-line vector to keep existing substitution interface.
        expanded_args_flat.push_back({ expanded_line });
    }

    out_after_idx = j;
    return true;
}

bool Preprocessor::expand_macros_single_pass(const TokensLine& in_line,
        std::vector<TokensLine>& out_lines, std::string& last_macro_name,
        bool at_start_of_line) {

    out_lines.clear();
    last_macro_name.clear();

    // skip if directive line only if at start of line
    if (at_start_of_line) {
        unsigned di = 0;
        Keyword kw = Keyword::None;
        std::string dummy;
        if (is_directive(in_line, di, kw)
                || is_name_directive(in_line, di, kw, dummy)) {
            out_lines.push_back(in_line);
            return false;
        }
    }

    TokensLine current(in_line.location());
    bool any_change = false;

    for (unsigned idx = 0; idx < in_line.size(); ++idx) {
        const Token& tok = in_line[idx];
        if (!tok.is(TokenType::Identifier)) {
            current.push_back(tok);
            continue;
        }

        auto mit = macros_.find(tok.text());
        if (mit == macros_.end()) {
            current.push_back(tok);
            continue;
        }

        Macro& macro = mit->second;
        last_macro_name = tok.text();

        unsigned args_start = idx + 1;
        bool had_paren = (macro.is_function_like &&
                          args_start < in_line.size() &&
                          in_line[args_start].is(TokenType::LeftParen));
        bool is_call = macro.is_function_like && (args_start < in_line.size());

        std::vector<std::vector<TokensLine>> expanded_args_flat;
        std::vector<TokensLine> original_args;
        unsigned after_idx = args_start;

        if (macro.is_function_like && is_call) {
            if (!parse_and_expand_macro_args(in_line,
                                             args_start,
                                             expanded_args_flat,
                                             original_args,
                                             after_idx) ||
                    expanded_args_flat.size() != macro.params.size()) {
                if (had_paren) {
                    g_errors.error(ErrorCode::InvalidSyntax,
                                   "Macro argument count mismatch for: " + last_macro_name);
                }
                current.push_back(tok);
                continue;
            }
        }

        // Recursion detection for simple self or cyclic object-like chains
        if (!macro.is_function_like) {
            if (macro.replacement.size() == 1 &&
                    macro.replacement[0].size() == 1 &&
                    macro.replacement[0][0].is(TokenType::Identifier) &&
                    macro.replacement[0][0].text() == last_macro_name) {
                g_errors.error(ErrorCode::MacroRecursionLimit, last_macro_name);
                current.push_back(tok);
                continue;
            }
            if (macro.replacement.size() == 1 &&
                    macro.replacement[0].size() == 1 &&
                    macro.replacement[0][0].is(TokenType::Identifier)) {
                std::string target = macro.replacement[0][0].text();
                if (current_line_chain_.has_cycle(target)) {
                    g_errors.error(ErrorCode::MacroRecursionLimit, last_macro_name);
                    current.push_back(tok);
                    continue;
                }
                current_line_chain_.add(last_macro_name);
            }
        }

        any_change = true;

        if (macro.is_function_like && is_call) {
            // Function-like substitution (no recursive expansion this pass)
            std::unordered_map<std::string, std::string> local_rename;
            if (!macro.locals.empty()) {
                ++local_id_counter_;
                std::string suffix = "_" + std::to_string(local_id_counter_);
                for (const auto& ln : macro.locals) {
                    local_rename[ln] = ln + suffix;
                }
            }

            // Substitute each replacement line
            bool first_rep = true;
            for (const TokensLine& rep_line : macro.replacement) {
                TokensLine out(rep_line.location());
                for (unsigned p = 0; p < rep_line.size(); ++p) {
                    const Token& rt = rep_line[p];

                    // Stringize
                    if (rt.is(TokenType::Hash) && p + 1 < rep_line.size() &&
                            rep_line[p + 1].is(TokenType::Identifier)) {
                        std::string pname = rep_line[p + 1].text();
                        auto pit = std::find(macro.params.begin(), macro.params.end(), pname);
                        if (pit != macro.params.end()) {
                            size_t arg_index = std::distance(macro.params.begin(), pit);
                            const TokensLine& orig = original_args[arg_index];
                            std::string joined;
                            bool space_pending = false;
                            for (const auto& at : orig.tokens()) {
                                if (at.is(TokenType::Whitespace)) {
                                    space_pending = true;
                                    continue;
                                }
                                if (!joined.empty() && space_pending) {
                                    joined += ' ';
                                }
                                joined += at.text();
                                space_pending = false;
                            }
                            std::string escaped = escape_c_string(joined);
                            std::string quoted = "\"" + escaped + "\"";
                            out.push_back(Token(TokenType::String, quoted, joined));
                            ++p;
                            continue;
                        }
                    }

                    // Parameter substitution
                    if (rt.is(TokenType::Identifier)) {
                        auto pit = std::find(macro.params.begin(), macro.params.end(), rt.text());
                        if (pit != macro.params.end()) {
                            size_t arg_index = std::distance(macro.params.begin(), pit);
                            const auto& arg_lines = expanded_args_flat[arg_index];
                            // First argument line
                            for (const auto& tkl : arg_lines.front().tokens()) {
                                out.push_back(tkl);
                            }
                            // Additional argument lines become separate logical lines
                            for (size_t al = 1; al < arg_lines.size(); ++al) {
                                // Commit merged (with any preceding tokens)
                                if (first_rep) {
                                    // Merge current (tokens before macro) with out
                                    TokensLine merged(out.location());
                                    for (const auto& ct : current.tokens()) {
                                        merged.push_back(ct);
                                    }
                                    for (const auto& ot : out.tokens()) {
                                        merged.push_back(ot);
                                    }
                                    TokensLine pasted;
                                    merge_double_hash(merged, pasted);
                                    out_lines.push_back(pasted);
                                    current.clear_tokens();
                                }
                                else {
                                    TokensLine pasted2;
                                    merge_double_hash(out, pasted2);
                                    out_lines.push_back(pasted2);
                                }
                                out = TokensLine(rep_line.location());
                                for (const auto& tkl : arg_lines[al].tokens()) {
                                    out.push_back(tkl);
                                }
                                first_rep = false;
                            }
                            continue;
                        }
                        // LOCAL rename
                        auto lit = local_rename.find(rt.text());
                        if (lit != local_rename.end()) {
                            out.push_back(Token(TokenType::Identifier, lit->second));
                            continue;
                        }
                    }

                    out.push_back(rt);
                }

                TokensLine merged_line;
                merge_double_hash(out, merged_line);

                if (first_rep) {
                    // Merge into current (replacing macro token)
                    for (const auto& t : merged_line.tokens()) {
                        current.push_back(t);
                    }
                    first_rep = false;
                }
                else {
                    // Commit previous accumulated line, start new current with merged_line
                    out_lines.push_back(current);
                    current = merged_line;
                }
            }

            idx = after_idx;
        }
        else { // object-like macro
            std::unordered_map<std::string, std::string> local_rename;
            if (!macro.locals.empty()) {
                ++local_id_counter_;
                std::string suffix = "_" + std::to_string(local_id_counter_);
                for (const auto& ln : macro.locals) {
                    local_rename[ln] = ln + suffix;
                }
            }

            bool first_rep = true;
            for (const TokensLine& rep_line : macro.replacement) {
                TokensLine substituted(rep_line.location());
                for (unsigned p = 0; p < rep_line.size(); ++p) {
                    const Token& rt = rep_line[p];
                    if (rt.is(TokenType::Identifier)) {
                        auto lr = local_rename.find(rt.text());
                        if (lr != local_rename.end()) {
                            substituted.push_back(Token(TokenType::Identifier, lr->second));
                            continue;
                        }
                    }
                    substituted.push_back(rt);
                }

                TokensLine merged_line;
                merge_double_hash(substituted, merged_line);

                if (first_rep) {
                    // Append into current (replacing macro token)
                    for (const auto& t : merged_line.tokens()) {
                        current.push_back(t);
                    }
                    first_rep = false;
                }
                else {
                    // Commit previous accumulated line, start new one
                    out_lines.push_back(current);
                    current = merged_line;
                }
            }
        }

        // (Do not push current yet; continue scanning rest of original line)
    }

    // Final commit
    if (!current.empty()) {
        out_lines.push_back(current);
    }

    // If no change, return original line
    if (!any_change) {
        out_lines.clear();
        out_lines.push_back(in_line);
        return false;
    }

    // return out_lines
    return true;
}

TokensLine Preprocessor::expand_macros_in_line(const TokensLine& line) {
    // Non-recursive expansion: repeatedly apply single-pass expansion to all lines
    // until a fixpoint or MAX_FIXPOINT_ITERATIONS reached.
    std::vector<TokensLine> current_set;
    current_set.push_back(line);

    std::string last_macro_name;

    for (int iter = 0; iter < MAX_FIXPOINT_ITERATIONS; ++iter) {
        bool any_change = false;
        std::vector<TokensLine> next_set;
        next_set.reserve(current_set.size());
        current_line_chain_.reset(); // reset cycle detection per pass

        for (const auto& ln : current_set) {
            std::vector<TokensLine> expanded_pass;
            std::string pass_macro;
            bool at_start_of_line = false;
            bool changed = expand_macros_single_pass(ln, expanded_pass,
                           pass_macro, at_start_of_line);
            if (changed) {
                any_change = true;
                if (!pass_macro.empty()) {
                    last_macro_name = pass_macro;
                }
            }
            // expanded_pass always contains at least one line
            for (auto& e : expanded_pass) {
                next_set.push_back(std::move(e));
            }
        }

        if (!any_change) {
            // fixpoint reached
            current_set = std::move(next_set);
            break;
        }

        current_set = std::move(next_set);

        if (iter == MAX_FIXPOINT_ITERATIONS - 1) {
            std::string macro_name = last_macro_name.empty() ? "<macro>" : last_macro_name;
            g_errors.error(ErrorCode::MacroRecursionLimit, macro_name);
            break;
        }
    }

    // Flatten resulting logical lines into a single TokensLine (space separated)
    if (current_set.empty()) {
        return TokensLine(line.location());
    }
    if (current_set.size() == 1) {
        TokensLine single = current_set.front();
        single.trim();
        return single;
    }

    TokensLine flattened(line.location());
    bool first = true;
    for (const auto& ln : current_set) {
        if (!first) {
            flattened.push_back(Token(TokenType::Whitespace, " "));
        }
        for (unsigned i = 0; i < ln.size(); ++i) {
            flattened.push_back(ln[i]);
        }
        first = false;
    }
    flattened.trim();
    return flattened;
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
