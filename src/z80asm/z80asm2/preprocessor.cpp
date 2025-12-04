//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "expr.h"
#include "keywords.h"
#include "module.h"
#include "options.h"
#include "preprocessor.h"
#include "symbols.h"
#include "utils.h"
#include <algorithm>
#include <cassert>
#include <fstream>
#include <set>
#include <sstream>
#include <sys/stat.h>
#include <unordered_set>

Preprocessor::Preprocessor()
    : hla_context_(this) {
}

void Preprocessor::clear() {
    input_queue_.clear();
    file_stack_.clear();
    macros_.clear();
    if_stack_.clear();
    dependency_file_.clear();
    included_once_.clear();
    current_line_chain_.reset();
    macro_fixpoint_iterations_ = 0;
    hla_context_.clear();
    module_.clear();
}

void Preprocessor::push_file(const std::string& filename) {
    // Normalize the path to ensure consistent filenames in locations
    std::string normalized_filename = normalize_path(filename);
    std::string abs_path = absolute_path(normalized_filename);

    // Check if this file is already on the stack (recursive include detection)
    for (const File& f : file_stack_) {
        if (f.tf_reader.filename() == normalized_filename) {
            g_errors.error(ErrorCode::RecursiveInclude,
                           normalized_filename);

            // Clear the file stack and input queue to stop all processing
            file_stack_.clear();
            input_queue_.clear();
            if_stack_.clear();
            return;
        }
    }

    // open file and detect inglude guards
    TokenFileReader tf_reader;
    if (!tf_reader.open((normalized_filename))) {
        return; // error already output
    }

    // Record dependency even when skipped
    dependency_file_.add_dependency(normalized_filename);

    if (included_once_.find(abs_path) != included_once_.end()) {
        // If file has pragma_once and already included in this instance, skip
        if (tf_reader.has_pragma_once()) {
            if (included_once_.find(abs_path) != included_once_.end()) {
                return; // skip include entirely
            }
        }

        // if file has ifndef/define guard and already defined, skip
        if (tf_reader.has_ifndef_guard()) {
            const std::string& guard_name = tf_reader.ifndef_guard_symbol();

            // check ifdef macro
            if (macros_.has_macro(guard_name)) {
                return; // skip include entirely
            }

            // check defc symbol
            auto symbol = module_.get_symbol(guard_name);
            if (symbol && symbol->is_defined()) {
                return; // skip include entirely
            }
        }
    }

    // Track inclusion for pragma once logic
    included_once_.insert(abs_path);

    // Push the file onto the stack
    File f;
    f.tf_reader = std::move(tf_reader);
    f.has_forced_location = false;
    f.forced_at_line_num = 0;
    f.forced_start_line_num = 0;
    f.forced_filename.clear();
    f.forced_constant_line_numbers = false;
    f.last_physical_line_num = 0;
    f.is_macro_expansion = false;
    f.exitm_found = false;
    f.is_virtual_file = false;

    file_stack_.push_back(std::move(f));
}

void Preprocessor::push_virtual_file(const std::string& content,
                                     const std::string& filename,
                                     int first_line_num,
                                     bool fixed_line_nums) {
    TokenFileReader tf_reader;
    tf_reader.inject(filename, first_line_num, fixed_line_nums, content);

    // Push the file onto the stack
    File vf;
    vf.tf_reader = std::move(tf_reader);
    vf.has_forced_location = false;
    vf.forced_at_line_num = 0;
    vf.forced_start_line_num = 0;
    vf.forced_filename.clear();
    vf.forced_constant_line_numbers = false;
    vf.last_physical_line_num = 0;
    vf.is_macro_expansion = false;
    vf.exitm_found = false;
    vf.is_virtual_file = true;

    file_stack_.push_back(std::move(vf));
}

void Preprocessor::push_virtual_file(const std::vector<TokenLine>& tok_lines) {
    TokenFileReader tf_reader;
    tf_reader.inject_tokens(tok_lines);

    // Push the file onto the stack
    File vf;
    vf.tf_reader = std::move(tf_reader);
    vf.has_forced_location = false;
    vf.forced_at_line_num = 0;
    vf.forced_start_line_num = 0;
    vf.forced_filename.clear();
    vf.forced_constant_line_numbers = false;
    vf.last_physical_line_num = 0;
    vf.is_macro_expansion = false;
    vf.exitm_found = false;
    vf.is_virtual_file = true;

    file_stack_.push_back(std::move(vf));
}

void Preprocessor::push_binary_file(const std::string& bin_filename,
                                    const Location& location) {

    // Record dependency first (order-preserving, duplicates allowed)
    dependency_file_.add_dependency(normalize_path(bin_filename));

    // read binary file content
    std::vector<uint8_t> bytes;
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
    std::vector<TokenLine> tok_lines;
    const size_t BYTES_PER_LINE = 16;
    tok_lines.reserve((bytes.size() + BYTES_PER_LINE - 1) / BYTES_PER_LINE);

    for (size_t i = 0; i < bytes.size(); i += BYTES_PER_LINE) {
        size_t end = std::min(bytes.size(), i + BYTES_PER_LINE);
        size_t byte_count = end - i;

        TokenLine line(location);
        // Reserve: 1 initial tokens (DEFB) + byte_count integers + (byte_count-1) commas
        line.tokens().reserve(1 + byte_count * 2 - 1);
        // DEFB <space>
        line.tokens().push_back(Token(TokenType::Identifier, "DEFB", true));

        bool first = true;
        for (size_t j = i; j < end; ++j) {
            if (!first) {
                line.tokens().push_back(Token(TokenType::Comma, ",", false));
            }
            first = false;
            int v = static_cast<int>(bytes[j]);
            line.tokens().push_back(Token(TokenType::Integer, std::to_string(v), v,
                                          false));
        }

        tok_lines.push_back(std::move(line));
    }

    // push the lines as a virtual file
    push_virtual_file(tok_lines);
}

void Preprocessor::define_macro(const std::string& name, const Location& location, const std::string replacement) {
    TokenFileReader tfr;
    tfr.inject(location.filename(), location.line_num(), true, replacement);

    TokenLine replacement_line;
    std::vector<TokenLine> replacement_lines;
    while (tfr.next_token_line(replacement_line)) {
        replacement_lines.push_back(std::move(replacement_line));
    }

    define_macro(name, location, std::move(replacement_lines));
}

void Preprocessor::define_macro(const std::string& name, const Location& location,
                                const std::vector<TokenLine>& replacement) {

    Macro m(name, location);
    m.body_lines() = replacement;
    for (auto& tl : m.body_lines()) {
        // Ensure each line has correct location
        tl.set_location(location);
    }

    macros_.add_macro(std::move(m));
}

bool Preprocessor::next_line(TokenLine& out_line) {
    return hla_context_.next_line(out_line);
}

bool Preprocessor::pp_next_line(TokenLine& line) {
    line.clear();
    while (true) {
        if (!input_queue_.empty()) {
            line = std::move(input_queue_.front());
            input_queue_.pop_front();
            if (handle_directives_for_line(line, true)) {
                continue;
            }
            else {
                TokenLine final_line;
                post_process_line(line, final_line);
                line = std::move(final_line);
                update_symtab(line);
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

        // Macro expansion with iterative feed-back for directives inside macros
        bool changed = false;
        std::vector<TokenLine> expanded;

        // expand macros only once, so that directives inside macros are handled properly
        if (macros_.expand_once(line, expanded)) {
            changed = true;
        }

        if (expanded.empty()) {
            continue;
        }

        // Macro expansion occurred: force all expanded lines to use call-site logical location
        Location callsite = line.location();
        for (auto& tl : expanded) {
            tl.set_location(callsite);
        }

        if (!changed && expanded.size() == 1) {
            // Do not finalize here. Queue the (possibly directive) line back so it goes
            // through normal directive handling first, then finalization happens at dequeue.
            input_queue_.push_front(expanded.front());
            current_line_chain_.reset();
            macro_fixpoint_iterations_ = 0;
            continue;
        }

        // check for infinite recursion
        ++macro_fixpoint_iterations_;
        if (macro_fixpoint_iterations_ > MAX_FIXPOINT_ITERATIONS) {
            std::string macro_name = macros_.last_expanded_macro();
            if (macro_name.empty()) {
                macro_name = "<macro>";
            }
            g_errors.error(ErrorCode::MacroRecursionLimit, macro_name);

            current_line_chain_.reset();
            macro_fixpoint_iterations_ = 0;
            line.tokens().clear();
            return true;
        }

        // Push expansion as virtual file
        push_virtual_file(expanded);
        if (!file_stack_.empty()) {
            file_stack_.back().is_macro_expansion = true;
        }

        continue; // fetch first expanded line
    }
}

bool Preprocessor::fetch_line(TokenLine& out) {
    while (!file_stack_.empty()) {
        out.clear();
        File& file = file_stack_.back();

        // fectch next line
        if (!file.tf_reader.next_token_line(out)) {
            // end of file
            file_stack_.pop_back();
            continue;
        }

        // skip empty lines
        if (out.tokens().empty()) {
            continue;
        }

        // Capture physical line number BEFORE logical remap
        file.last_physical_line_num = out.location().line_num();

        // Compute logical location (may remap due to LINE/C_LINE)
        Location loc = compute_location(file, out);
        out.set_location(loc);

        // report position
        if (file.is_virtual_file) {
            g_errors.set_expanded_line(out.to_string());
        }
        g_errors.set_location(loc);

        return true;
    }

    // no more input
    if (!if_stack_.empty()) {
        // Report unclosed conditional at end of input
        const IfFrame& top_frame = if_stack_.back();
        g_errors.set_source_line("");
        g_errors.error(top_frame.location, ErrorCode::InvalidSyntax,
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
Location Preprocessor::compute_location(const File& file, const TokenLine& out) {
    // true physical line number from source
    const size_t physical_line = out.location().line_num();

    Location loc = out.location();

    if (file.has_forced_location) {
        if (!file.forced_filename.empty()) {
            loc.set_filename(file.forced_filename);
        }
        else {
            loc.set_filename(file.tf_reader.filename());
        }

        if (file.forced_constant_line_numbers) {
            // C_LINE: keep constant line number
            loc.set_line_num(file.forced_start_line_num);
        }
        else {
            // LINE: compute offset using physical line numbers
            size_t start_physical = file.forced_at_line_num;
            size_t offset = 0;
            if (physical_line > start_physical) {
                offset = physical_line - start_physical - 1;
            }
            loc.set_line_num(file.forced_start_line_num + offset);
        }
    }
    else {
        // Default mapping uses the physical line number provided by TokenLine
        const std::string& reader_filename = file.tf_reader.filename();
        if (!reader_filename.empty()) {
            loc.set_filename(reader_filename);
        }
        loc.set_line_num(physical_line);
    }

    return loc;
}

// Replace strings by comma-separated integers
bool Preprocessor::post_process_line(const TokenLine& line, TokenLine& out) {
    // Fast path if no string tokens present
    if (!line.has_token_type(TokenType::String)) {
        out = line;
        return false;
    }

    const auto& in_tokens = line.tokens();
    std::vector<Token> out_tokens;
    size_t i = 0;
    while (i < in_tokens.size()) {
        const Token& t = in_tokens[i];
        if (t.is(TokenType::String)) {
            const std::string& str_val = t.string_value();
            if (str_val.empty()) {
                // Remove a comma already emitted before the empty string
                bool comma_removed = false;
                if (!out_tokens.empty() && out_tokens.back().is(TokenType::Comma)) {
                    out_tokens.pop_back();
                    comma_removed = true;
                }
                // Skip the empty string token
                ++i;
                // Skip a following comma token in the source (do not emit it)
                if (!comma_removed && i < in_tokens.size() &&
                        in_tokens[i].is(TokenType::Comma)) {
                    ++i;
                }
                continue; // Nothing to emit for an empty string
            }

            ++i; // consume the string token
            bool is_first = true;
            for (char c : str_val) {
                if (!is_first) {
                    out_tokens.push_back(Token(TokenType::Comma, ",", false));
                }
                int char_int = static_cast<int>(static_cast<unsigned char>(c));
                out_tokens.push_back(Token(TokenType::Integer,
                                           std::to_string(char_int), char_int, false));
                is_first = false;
            }
        }
        else {
            out_tokens.push_back(t);
            ++i;
        }
    }

    out = TokenLine(line.location(), std::move(out_tokens));
    return true;
}

void Preprocessor::update_symtab(const TokenLine& line) {
    // parse labels
    const auto& tokens = line.tokens();
    if (tokens.size() >= 2 && tokens[0].is(TokenType::Dot) &&
            tokens[1].is(TokenType::Identifier)) {
        const std::string& name = tokens[1].text();
        module_.add_symbol(name, line.location(),
                           pp_current_section()->last_opcode(), 0,
                           SymbolType::AddressRelative);
        return;
    }

    // Common handler: consume expression starting at index i, define symbol `name`.
    auto consume_defc_expr = [&](size_t& i, const std::string & name) {
        // Empty body defaults to integer 1
        if (i >= tokens.size()) {
            module_.add_symbol(name, line.location(), 1, SymbolType::Constant);
            return;
        }

        Expression expr;
        if (!expr.parse(line, i, pp_module(), pp_current_section())) {
            // parse failed: define symbol as undefined
            module_.add_symbol(name, line.location());
            return;
        }

        // ignore extra tokens after expression, will be caught by later pass

        if (expr.is_constant()) {
            // define symbol as constant
            int value = expr.evaluate();
            module_.add_symbol(name, line.location(), value, SymbolType::Constant);
            return;
        }

        // define symbol as undefined
        module_.add_symbol(name, line.location());
    };

    // parse DEFC name = statements
    if (tokens.size() >= 3 && tokens[0].is(Keyword::DEFC) &&
            tokens[1].is(TokenType::Identifier) &&
            tokens[2].is(TokenType::EQ)) {
        const std::string& name = tokens[1].text();
        size_t i = 3;
        consume_defc_expr(i, name);
        return;
    }

    // parse name DEFC expr statements
    Keyword kw = Keyword::None;
    std::string name;
    size_t i = 0;
    if (is_name_directive(line, i, kw, name) && kw == Keyword::DEFC) {
        // Optional EQ for forms like: name DEFC = expr
        if (i < tokens.size() && tokens[i].is(TokenType::EQ)) {
            ++i;
        }
        consume_defc_expr(i, name);
        return;
    }
}

bool Preprocessor::handle_directives_for_line(TokenLine& line, bool reading_from_queue) {
    // skip empty lines
    if (line.tokens().empty()) {
        return true;
    }

    // if from queue, notify errors of expanded line
    if (reading_from_queue) {
        g_errors.set_location(line.location());
        g_errors.set_expanded_line(line.to_string());
    }

    // check for directives
    Keyword keyword = Keyword::None;
    size_t i = 0;
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

    // Support cpp style line markers: "# <nr>" or "# <nr> , <filename>" or "# <nr> <filename>"
    // Treat them as synonyms of "#line <nr> [ , filename ]"
    const auto& tokens = line.tokens();
    if (tokens.size() >= 2 && tokens[0].is(TokenType::Hash) &&
            tokens[1].is(TokenType::Integer)) {
        i = 1; // point to integer token
        process_LINE(line, i);
        return true; // consume directive
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

bool Preprocessor::is_directive(const TokenLine& line, size_t& i, Keyword& keyword) const {
    size_t start = i;
    keyword = Keyword::None;

    // skip optional #
    const auto& tokens = line.tokens();
    if (i < tokens.size() && tokens[i].is(TokenType::Hash)) {
        ++i;
    }

    // check for directive keywords
    if (parse_keyword(line, i, keyword)) {
        if (keyword_is_directive(keyword)) {
            return true;
        }
    }

    i = start; // rewind
    return false;
}

bool Preprocessor::is_name_directive(const TokenLine& line, size_t& i, Keyword& keyword, std::string& name) const {
    size_t start = i;
    keyword = Keyword::None;
    name.clear();

    const auto& tokens = line.tokens();
    if (!parse_identifier(line, i, name)) {
        i = start; // rewind
        return false;
    }

    // check for NAME=VALUE form
    if (i < tokens.size() && tokens[i].is(TokenType::EQ)) {    // synonym for EQU
        keyword = Keyword::EQU;
        ++i;
        return true;
    }

    // check for directive keywords
    if (parse_keyword(line, i, keyword) &&
            keyword_is_name_directive(keyword)) {
        return true;
    }

    i = start;  // rewind
    return false;
}

void Preprocessor::process_directive(const TokenLine& line, size_t& i, Keyword keyword) {
    switch (keyword) {
    case Keyword::INCLUDE:
        process_INCLUDE(line, i);
        break;
    case Keyword::BINARY:
    case Keyword::INCBIN:
        process_BINARY(line, i);
        break;
    case Keyword::LINE:
        process_LINE(line, i);
        break;
    case Keyword::C_LINE:
        process_C_LINE(line, i);
        break;
    case Keyword::DEFINE:
        process_DEFINE(line, i);
        break;
    case Keyword::UNDEF:
    case Keyword::UNDEFINE:
        process_UNDEF(line, i);
        break;
    case Keyword::DEFL:
        process_DEFL(line, i);
        break;
    case Keyword::MACRO:
        process_MACRO(line, i);
        break;
    case Keyword::LOCAL:
        process_LOCAL(line, i);
        break;
    case Keyword::EXITM:
        process_EXITM(line, i);
        break;
    case Keyword::REPT:
        process_REPT(line, i);
        break;
    case Keyword::REPTC:
        process_REPTC(line, i);
        break;
    case Keyword::REPTI:
        process_REPTI(line, i);
        break;
    case Keyword::EQU:
        process_EQU(line, i);
        break;
    case Keyword::PRAGMA:
        process_PRAGMA(line, i);
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

void Preprocessor::process_name_directive(const TokenLine& line, size_t& i, Keyword keyword, const std::string& name) {
    // Handle directives of the form: <name> <directive> ...
    switch (keyword) {
    case Keyword::DEFINE:
        process_name_DEFINE(line, i, name);
        break;
    case Keyword::UNDEF:
    case Keyword::UNDEFINE:
        process_name_UNDEF(line, i, name);
        break;
    case Keyword::DEFL:
        process_name_DEFL(line, i, name);
        break;
    case Keyword::MACRO:
        process_name_MACRO(line, i, name);
        break;
    case Keyword::REPTC:
        process_name_REPTC(line, i, name);
        break;
    case Keyword::REPTI:
        process_name_REPTI(line, i, name);
        break;
    case Keyword::EQU:
    case Keyword::DEFC:
        process_name_EQU(line, i, name);
        break;
    default:
        assert(0);
    }
}

void Preprocessor::process_contitional_directive(const TokenLine& line,
        size_t& i, Keyword keyword) {
    switch (keyword) {
    case Keyword::IF:
        process_IF(line, i);
        break;
    case Keyword::IFDEF:
        process_IFDEF(line, i, false);
        break;
    case Keyword::IFNDEF:
        process_IFDEF(line, i, true);
        break;
    case Keyword::ELIF:
    case Keyword::ELSEIF:
        process_ELIF(line, i);
        break;
    case Keyword::ELIFDEF:
    case Keyword::ELSEIFDEF:
        process_ELIFDEF(line, i, false);
        break;
    case Keyword::ELIFNDEF:
    case Keyword::ELSEIFNDEF:
        process_ELIFDEF(line, i, true);
        break;
    case Keyword::ELSE:
        process_ELSE(line, i);
        break;
    case Keyword::ENDIF:
        process_ENDIF(line, i);
        break;
    default:
        assert(0);
    }
}

void Preprocessor::expect_end(const TokenLine& line, size_t i) const {
    if (i < line.tokens().size()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected token: '" + line.tokens()[i].text() + "'");
    }
}

bool Preprocessor::parse_identifier(const TokenLine& line, size_t& i, std::string& out_name) const {
    out_name.clear();
    const auto& tokens = line.tokens();
    if (i < tokens.size() && tokens[i].is(TokenType::Identifier)) {
        out_name = tokens[i].text();
        ++i;
        return true;
    }
    else {
        return false;
    }
}

bool Preprocessor::parse_keyword(const TokenLine& line, size_t& i,
                                 Keyword& out_keyword) const {
    out_keyword = Keyword::None;
    const auto& tokens = line.tokens();
    if (i < tokens.size() && tokens[i].is(TokenType::Identifier)) {
        out_keyword = tokens[i].keyword();
        if (out_keyword != Keyword::None) {
            ++i;
            return true;
        }
    }
    return false;
}

void Preprocessor::process_INCLUDE(const TokenLine& line, size_t& i) {
    std::string filename;
    bool is_angle = false;
    if (!parse_filename(line, i, filename, is_angle)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected filename in include directive");
        return;
    }

    expect_end(line, i);
    do_INCLUDE(filename, is_angle);
}

void Preprocessor::do_INCLUDE(const std::string& filename,
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
    // (process_INCLUDE/do_INCLUDE/process_BINARY) all use the same routine.
    // Return the resolved path if found; otherwise return the original filename
    // so callers can simply assign the result and proceed.
    std::string including_filename;
    if (!file_stack_.empty()) {
        const File& top_file = file_stack_.back();
        including_filename = top_file.tf_reader.filename();
    }
    std::string resolved = g_options.resolve_include_candidate(filename,
                           including_filename, is_angle);
    if (resolved.empty()) {
        return filename;
    }
    else {
        return resolved;
    }
}

bool Preprocessor::parse_filename(const TokenLine& line, size_t& i, std::string& out_filename,
                                  bool& out_is_angle) const {
    out_filename.clear();
    out_is_angle = false;

    const auto& tokens = line.tokens();
    if (i < tokens.size() && tokens[i].is(TokenType::String)) {
        out_filename = tokens[i].string_value();
        const std::string& txt = tokens[i].text();
        if (!txt.empty() && txt.front() == '<') {
            out_is_angle = true;
        }
        ++i;
        return true;
    }

    // Plain filename: consume tokens up to whitespace
    std::string filename;
    while (i < tokens.size()) {
        filename += tokens[i].text();
        if (tokens[i].has_space_after()) {
            ++i;
            break;
        }
        ++i;
    }
    if (filename.empty()) {
        return false;
    }

    out_filename = filename;
    out_is_angle = false;
    return true;
}

void Preprocessor::process_BINARY(const TokenLine& line, size_t& i) {
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
    const Location& location = line.location();
    do_BINARY(filename, is_angle, location);
}

void Preprocessor::do_BINARY(const std::string& filename, bool is_angle,
                             const Location& location) {
    // Resolve include-path candidates first so BINARY/INCBIN honor include
    // search directories the same way #include does.
    std::string resolved = search_include_path(filename, is_angle);

    // Push a virtual file containing DEFB directives with the binary bytes,
    // starting exactly at the directive's logical location.
    push_binary_file(resolved, location);
}

void Preprocessor::process_LINE(const TokenLine& line, size_t& i) {
    size_t linenum = 0;
    std::string filename;
    if (!parse_LINE_args(line, i, linenum, filename, Keyword::LINE)) {
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
        file.forced_filename = file.tf_reader.filename();
    }
}

void Preprocessor::process_C_LINE(const TokenLine& line, size_t& i) {
    size_t linenum = 0;
    std::string filename;
    if (!parse_LINE_args(line, i, linenum, filename, Keyword::C_LINE)) {
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
        file.forced_filename = file.tf_reader.filename();
    }
}

// Parse common LINE/C_LINE argument forms: <linenum> [ , "filename" ]
bool Preprocessor::parse_LINE_args(const TokenLine& line, size_t& i,
                                   size_t& out_linenum, std::string& out_filename, Keyword keyword) const {

    const auto& tokens = line.tokens();

    // accept negative line numbers, but convert them to unsigned size_t
    int sign = 1;
    if (i < tokens.size() && tokens[i].is(TokenType::Minus)) {
        ++i;
        sign = -1;
    }

    if (!(i < tokens.size() && tokens[i].is(TokenType::Integer))) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       std::string("Expected line number in ") +
                       keyword_to_string(keyword) + " directive");
        return false;
    }

    out_linenum = static_cast<size_t>(sign * tokens[i].int_value());
    ++i;

    out_filename.clear();

    // Optional comma before filename
    if (i < tokens.size() && tokens[i].is(TokenType::Comma)) {
        ++i;
    }

    // Optional filename (with or without comma)
    if (i < tokens.size()) {
        std::string fname;
        bool is_angle = false;
        if (parse_filename(line, i, fname, is_angle)) {
            out_filename = fname;
        }
    }

    // cpp outputs other parameters after the filename, but we ignore them.
    //expect_end(line, i);

    return true;
}

void Preprocessor::process_DEFINE(const TokenLine& line, size_t& i) {
    const auto& tokens = line.tokens();

    // #define form: parse name and body after directive
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after DEFINE");
        return;
    }

    // define new macro
    Macro macro(name, line.location());

    // Determine if function-like: must have '(' immediately after name (no space)
    const Token& name_tok = tokens[i - 1];
    if (i < tokens.size() && !name_tok.has_space_after()
            && tokens[i].is(TokenType::LeftParen)) {
        // parse parameter list
        macro.set_function_like(true);
        if (!macro.parse_parameters(line, i)) {
            return; // error already emitted
        }
    }

    // Delegate the remaining common work to do_DEFINE (consumes rest of line)
    do_DEFINE(line, i, macro);
}

void Preprocessor::process_name_DEFINE(const TokenLine& line, size_t& i,
                                       const std::string& name) {
    // name define ... -> treat as "#define name ..." (object-like)
    // No function-like params recognized in name-directive form

    // define new macro
    Macro macro(name, line.location());

    do_DEFINE(line, i, macro);
}

void Preprocessor::do_DEFINE(const TokenLine& line, size_t& i, Macro& macro) {
    const auto& tokens = line.tokens();

    // scan optional '=' for compatibility
    if (i < tokens.size() && tokens[i].is(TokenType::EQ)) {
        ++i; // skip '='
    }

    if (i < tokens.size()) {
        macro.add_body_line(line, i);
    }
    else {
        // default to "1" if empty
        TokenLine tl(line.location(), { Token(TokenType::Integer, "1", 1, false) });
        macro.add_body_line(tl);
    }

    // if replacement is a constant expression, define a DEFC instead so that
    // the symbol in known at link time
    if (!macro.is_function_like()) {
        TokenLine expr_tokens = macros_.expand_flat(macro.body_lines()[0]);
        Expression expr;
        i = 0;
        if (expr.parse(expr_tokens, i, pp_module(), pp_current_section())) {  // parse ok
            if (i >= expr_tokens.tokens().size()) { // no extra tokens
                if (expr.is_constant()) { // constant value
                    int value = expr.evaluate();

                    // define DEFC
                    std::vector<Token> defc_tokens;
                    defc_tokens.reserve(4);
                    defc_tokens.push_back(Token(TokenType::Identifier, "DEFC", true));
                    defc_tokens.push_back(Token(TokenType::Identifier, macro.name(), true));
                    defc_tokens.push_back(Token(TokenType::EQ, "=", true));
                    defc_tokens.push_back(Token(TokenType::Integer, std::to_string(value), value, true));
                    TokenLine defc_tl(line.location(), std::move(defc_tokens));
                    std::vector<TokenLine> one_line;
                    one_line.push_back(std::move(defc_tl));
                    push_virtual_file(one_line);

                    return;
                }
            }
        }
    }

    // Report redefinition for DEFINE (not for DEFL)
    macros_.add_macro(macro);
}

void Preprocessor::process_EQU(const TokenLine& line, size_t& i) {
    const auto& tokens = line.tokens();

    // parse name
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after EQU");
        return;
    }

    // parse optional '='
    if (i < tokens.size() && tokens[i].is(TokenType::EQ)) {
        ++i;
    }

    do_EQU(line, i, name);
}

void Preprocessor::process_name_EQU(const TokenLine& line, size_t& i,
                                    const std::string& name) {
    const auto& tokens = line.tokens();

    // parse optional '='
    if (i < tokens.size() && tokens[i].is(TokenType::EQ)) {
        ++i;
    }

    do_EQU(line, i, name);
}

void Preprocessor::do_EQU(const TokenLine& line, size_t& i, const std::string& name) {
    // expand macros in value
    TokenLine expanded = macros_.expand_flat(line, i);

    std::vector<Token> defc_tokens;
    defc_tokens.reserve(3 + expanded.tokens().size());
    defc_tokens.push_back(Token(TokenType::Identifier, "DEFC", true));
    defc_tokens.push_back(Token(TokenType::Identifier, name, true));
    defc_tokens.push_back(Token(TokenType::EQ, "=", true));
    for (const auto& t : expanded.tokens()) {
        defc_tokens.push_back(t);
    }
    TokenLine defc(line.location(), std::move(defc_tokens));
    std::vector<TokenLine> one_line;
    one_line.push_back(std::move(defc));
    push_virtual_file(one_line);
}

void Preprocessor::process_UNDEF(const TokenLine& line, size_t& i) {
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after UNDEF");
        return;
    }

    do_UNDEF(name, line, i);
}

void Preprocessor::process_name_UNDEF(const TokenLine& line, size_t& i,
                                      const std::string& name) {
    // In the "<name> UNDEF" form the identifier to remove is provided as `name`.
    // Delegate the remainder to the shared do_UNDEF helper.
    do_UNDEF(name, line, i);
}

void Preprocessor::do_UNDEF(const std::string& name, const TokenLine& line,
                            size_t& i) {
    // common trailing UNDEF logic: validate end-of-line and remove macro entries
    expect_end(line, i);
    macros_.remove_macro(name);
}

void Preprocessor::process_DEFL(const TokenLine& line, size_t& i) {
    const auto& tokens = line.tokens();

    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after DEFL");
        return;
    }

    // consume optional '='
    if (i < tokens.size() && tokens[i].is(TokenType::EQ)) {
        ++i; // consume '='
    }

    do_DEFL(line, i, name);
}

void Preprocessor::process_name_DEFL(const TokenLine& line, size_t& i,
                                     const std::string& name) {
    const auto& tokens = line.tokens();

    // consume optional '='
    if (i < tokens.size() && tokens[i].is(TokenType::EQ)) {
        ++i; // consume '='
    }

    do_DEFL(line, i, name);
}

void Preprocessor::do_DEFL(const TokenLine& line, size_t& i,
                           const std::string& name) {
    // 1) Predefine name as an empty macro if it does not exist, so that
    //    occurrences of <name> in the body expand to the previous value (if any)
    //    or to empty otherwise.
    if (!macros_.has_macro(name)) {
        define_macro(name, line.location(), "");
    }

    if (macros_.get_macro(name)->is_function_like()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "DEFL cannot be used to redefine function-like macro '" + name + "'");
        return;
    }

    // 2) Collect and expand body so stored value reflects current expansions
    //    (including previous value of <name> if referenced).
    TokenLine expanded_body = macros_.expand_flat(line, i);
    if (expanded_body.tokens().empty()) {
        // Empty body defaults to integer 1
        expanded_body.tokens().push_back(Token(TokenType::Integer, "1", 1));
    }

    // 3) Attempt constant-expression evaluation on the fully expanded body.
    //    If successful, store the numeric result. Otherwise store the expanded body as-is
    //    (supports lists like "5,6" and other non-constant sequences).
    Expression expr;
    size_t j = 0;
    if (expr.parse(expanded_body, j, pp_module(), pp_current_section())) {
        if (j >= expanded_body.tokens().size()) {
            if (expr.is_constant()) {
                // constant expression -> store value
                int value = expr.evaluate();
                expanded_body.tokens().clear();
                if (value < 0) {
                    expanded_body.tokens().push_back(Token(TokenType::Minus, "-", false));
                    value = -value;
                }
                expanded_body.tokens().push_back(Token(TokenType::Integer, std::to_string(value), value, false));
            }
        }
    }

    // 4) Register/overwrite the macro definition with the chosen body.
    Macro m(name, line.location());
    m.add_body_line(std::move(expanded_body));
    macros_.replace_macro(std::move(m));
}

void Preprocessor::process_MACRO(const TokenLine& line, size_t& i) {
    // Expect: MACRO name(param, ...) or MACRO name param, ...
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after MACRO");
    }
    else {
        do_MACRO(line, i, name);
    }
}

void Preprocessor::process_name_MACRO(const TokenLine& line,
                                      size_t& i, const std::string& name) {
    // Form: <name> MACRO (param, ...) or <name> MACRO param, ...
    do_MACRO(line, i, name);
}

// Factor LOCAL parsing into process_LOCAL and use it from do_MACRO
void Preprocessor::do_MACRO(const TokenLine& line, size_t& i,
                            const std::string& name) {
    Macro m(name, line.location());

    // Parse optional parameter list (accepts with or without surrounding parentheses)
    bool ok = true;
    if (!m.parse_parameters(line, i)) {
        ok = false;
    }
    else {
        expect_end(line, i);
    }

    // Collect body lines verbatim until ENDM
    TokenLine body_line;
    bool found_endm = false;
    while (fetch_line_for_macro_body(body_line)) {
        if (!m.parse_body_line(body_line)) {
            found_endm = true;
            break;
        }
    }
    if (!found_endm) {
        g_errors.error(line.location(), ErrorCode::InvalidSyntax,
                       "Unexpected end of input in MACRO (expected ENDM)");
        return;
    }

    // Register the macro definition
    if (ok) {
        macros_.add_macro(std::move(m));
    }
}

void Preprocessor::process_REPT(const TokenLine& line, size_t& i) {
    // Parse and evaluate count expression (macro expanded).
    int count = 0;
    bool ok = eval_const_expr(line, i, count);
    expect_end(line, i);

    // Collect body (with nesting + LOCAL).
    RepeatCountBlock rbc(line.location(), count);
    collect_rept_body(line.location(), &rbc, Keyword::REPT);

    // Build repeated lines using the REPT directive's logical location
    std::vector<TokenLine> expanded;
    if (ok && count > 0 && rbc.expand(line.location(), expanded)) {
        push_virtual_file(expanded);
    }
}

// REPTC: directive form "REPTC var, string"
void Preprocessor::process_REPTC(const TokenLine& line, size_t& i) {
    const auto& tokens = line.tokens();
    bool ok = true;
    std::string var_name;
    if (!parse_identifier(line, i, var_name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after REPTC");
        ok = false;;
    }

    if (ok && i < tokens.size() && tokens[i].is(TokenType::Comma)) {
        ++i; // skip comma
    }
    else {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected ',' after REPTC variable name");
        ok = false;
    }

    // parse arguments and repeat body
    do_REPTC(ok, var_name, line, i);
}

// REPTC: name-directive form "var REPTC string"
void Preprocessor::process_name_REPTC(const TokenLine& line, size_t& i, const std::string& var_name) {
    do_REPTC(true, var_name, line, i);
}

void Preprocessor::do_REPTC(bool ok, const std::string& var_name, const TokenLine& line, size_t& i) {
    // 1) check for arguments
    if (ok && i >= line.tokens().size()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected string/identifier/number in REPTC");
        ok = false;
    }

    // 2) Expand macros in the argument and flatten to a single line
    TokenLine arg = macros_.expand_flat(line, i);

    // 2) Derive the source string to iterate:
    RepeatCharsBlock rcb(line.location(), var_name);
    size_t j = 0;
    if (ok && !rcb.parse_chars(arg, j)) {
        ok = false;
    }
    expect_end(arg, j);

    // 4) Collect body lines until ENDR, supporting nesting and LOCAL
    collect_rept_body(line.location(), &rcb, Keyword::REPTC);

    // 5) Build substituted lines for each character of iter_text
    std::vector<TokenLine> expanded;
    if (ok && rcb.expand(line.location(), expanded)) {
        push_virtual_file(expanded);
    }
}

// REPTI: directive form "REPTI var, list"
void Preprocessor::process_REPTI(const TokenLine& line, size_t& i) {
    const auto& tokens = line.tokens();
    bool ok = true;
    std::string var_name;
    if (!parse_identifier(line, i, var_name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier after REPTI");
        ok = false;;
    }

    if (ok && i < tokens.size() && tokens[i].is(TokenType::Comma)) {
        ++i; // skip comma
    }
    else {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected ',' after REPTI variable name");
        ok = false;
    }

    do_REPTI(ok, var_name, line, i);
}

// REPTI: name-directive form "var REPTI list"
void Preprocessor::process_name_REPTI(const TokenLine& line, size_t& i, const std::string& var_name) {
    do_REPTI(true, var_name, line, i);
}

void Preprocessor::do_REPTI(bool ok, const std::string& var_name, const TokenLine& line, size_t& i) {
    // 1) Parse the list of items to iterate
    RepeatIterateBlock rib(line.location(), var_name);
    if (ok && !rib.parse_items(line, i)) {
        g_errors.error(ErrorCode::InvalidSyntax, "Invalid argument list in REPTI");
        ok = false;
    }
    expect_end(line, i);

    // 2) Expand macros in the argument and flatten to a single line
    for (auto& arg : rib.items()) {
        arg = macros_.expand_flat(arg);
    }

    // 3) Collect body lines until ENDR, supporting nesting and LOCAL
    collect_rept_body(line.location(), &rib, Keyword::REPTI);

    // 4) Build substituted blocks for each character of iter_text
    std::vector<TokenLine> expanded;
    if (ok && rib.expand(line.location(), expanded)) {
        push_virtual_file(expanded);
    }
}

bool Preprocessor::collect_rept_body(const Location& location, RepeatBlock* block, Keyword keyword) {
    TokenLine body_line;
    bool found_endr = false;
    while (fetch_line_for_macro_body(body_line)) {
        if (!block->parse_body_line(body_line)) {
            found_endr = true;
            break;
        }
    }
    if (!found_endr) {
        g_errors.error(location, ErrorCode::InvalidSyntax,
                       "Unexpected end of input in " + keyword_to_string(keyword) +
                       " (expected ENDR)");
        return false;
    }
    return true;
}

// Fetch a raw next logical line for MACRO body parsing, from the proper source:
// - input_queue_ when reading_queue_for_directive_ is true
// - file_stack_ otherwise (and applies forced location if needed).
bool Preprocessor::fetch_line_for_macro_body(TokenLine& out) {
    out.clear();
    if (reading_queue_for_directive_) {
        if (input_queue_.empty()) {
            return false;
        }
        out = std::move(input_queue_.front());
        input_queue_.pop_front();

        g_errors.set_expanded_line(out.to_string());
        return true;
    }

    if (file_stack_.empty()) {
        return false;
    }

    // Return the raw stored line
    File& file = file_stack_.back();
    if (!file.tf_reader.next_token_line(out)) {
        return false;
    }

    g_errors.set_expanded_line(out.to_string());
    return true;
}

bool Preprocessor::eval_const_expr(const TokenLine& line, size_t& i, int& out_value) {
    Expression expr;
    if (!expr.parse(line, i, pp_module(), pp_current_section())) {
        g_errors.error(ErrorCode::InvalidSyntax, "Invalid expression");
        return false;
    }

    if (!expr.is_constant()) {
        g_errors.error(ErrorCode::InvalidSyntax, "Expected constant expression");
        return false;
    }

    out_value = expr.evaluate();
    return true;
}

void Preprocessor::process_IF(const TokenLine& line, size_t& i) {
    bool cond_value = eval_if_expr(line, i, Keyword::IF);

    IfFrame fr;
    fr.location = line.location();
    fr.branch_active = cond_value;
    fr.any_taken = cond_value;
    fr.seen_else = false;
    if_stack_.push_back(fr);
}

void Preprocessor::process_ELIF(const TokenLine& line, size_t& i) {
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

void Preprocessor::process_ELSE(const TokenLine& line, size_t& i) {
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

void Preprocessor::process_ENDIF(const TokenLine& line, size_t& i) {
    if (if_stack_.empty()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected ENDIF directive without matching IF");
        return;
    }
    expect_end(line, i);
    if_stack_.pop_back();
}

bool Preprocessor::eval_if_expr(const TokenLine& line, size_t& i, Keyword keyword) {
    TokenLine expr_line = macros_.expand_flat(line, i);
    Expression expr;
    if (!expr.parse(expr_line, pp_module(), pp_current_section())) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Invalid expression in " + keyword_to_string(keyword));
        return false;       // use false for parse errors
    }

    if (!expr.is_constant()) {
        return false;       // use false for non-constant expressions
    }
    else {
        return static_cast<bool>(expr.evaluate());
    }
}

void Preprocessor::process_IFDEF(const TokenLine& line, size_t& i,
                                 bool negated) {
    bool cond = eval_ifdef_name(line, i, negated, Keyword::IFDEF);

    IfFrame fr;
    fr.location = line.location();
    fr.branch_active = cond;
    fr.any_taken = cond;
    fr.seen_else = false;
    if_stack_.push_back(fr);
}

void Preprocessor::process_ELIFDEF(const TokenLine& line, size_t& i,
                                   bool negated) {
    if (if_stack_.empty()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Unexpected ELIFDEF directive without matching IF");
        return;
    }
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

bool Preprocessor::eval_ifdef_name(const TokenLine& line, size_t& i, bool negated, Keyword keyword) {
    std::string name;
    if (!parse_identifier(line, i, name)) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Expected identifier in " + keyword_to_string(keyword));
        return false;
    }
    expect_end(line, i);

    // check the macros
    bool is_def = macros_.has_macro(name);
    if (!is_def) {
        // also check symbol table
        auto symbol = module_.get_symbol(name);
        is_def = symbol && symbol->is_defined();
    }

    bool cond = negated ? !is_def : is_def;
    return cond;
}

void Preprocessor::process_EXITM(const TokenLine& line, size_t& i) {
    expect_end(line, i);
    do_EXITM();
}

void Preprocessor::do_EXITM() {
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

void Preprocessor::process_LOCAL(const TokenLine& /*line*/, size_t& /*i*/) {
    // LOCAL is processed in Macros while parsing the macro body
    g_errors.error(ErrorCode::InvalidSyntax,
                   "Unexpected LOCAL directive outside of MACRO/REPT body");
}

void Preprocessor::process_PRAGMA(const TokenLine& line, size_t& i) {
    // PRAGMA ONCE is parsed by FileTokenReader during open()
    // check syntax
    const auto& tokens = line.tokens();
    if (i < tokens.size() && tokens[i].is(Keyword::ONCE)) {
        ++i;
        expect_end(line, i);
    }
    else {
        // ignore other PRAGMA
    }
}

Module* Preprocessor::pp_module() {
    return &module_;
}

Section* Preprocessor::pp_current_section() {
    return module_.current_section();
}

// Dependency collection API
// Returns the list of files that were pushed via push_file/push_binary_file,
// in the order they were recorded (duplicates preserved).
const std::vector<std::string>& Preprocessor::dependency_filenames() const {
    return dependency_file_.dependencies();
}

void Preprocessor::generate_dependency_file() {
    dependency_file_.write();
}

void Preprocessor::preprocess_file(const std::string& input_filename, const std::string& output_filename,
                                   bool gen_dependency) {
    Preprocessor pp;
    int start_errors = g_errors.error_count();

    pp.push_file(input_filename);

    std::ofstream ofs(output_filename, std::ios::out | std::ios::binary);
    if (!ofs) {
        g_errors.error(ErrorCode::FileOpenError, output_filename);
        return;
    }

    Location location;
    TokenLine line;
    while (pp.next_line(line)) {
        if (g_errors.location().filename() != location.filename()) {
            // filename changed (e.g. due to #include)
            location = g_errors.location();
            ofs << "#line " << location.line_num() << ", \"" << location.filename() << "\""
                << std::endl;
        }
        else if (g_errors.location().line_num() < location.line_num()) {
            // Line number decreased (e.g. due to #line directive)
            location.set_line_num(g_errors.location().line_num());
            ofs << "#line " << location.line_num() << std::endl;
        }
        else {
            // Normal line increment
            while (g_errors.location().line_num() > location.line_num()) {
                ofs << std::endl;
                location.inc_line_num();
            }
            location.set_line_num(g_errors.location().line_num());
        }
        std::string text = line.to_string();
        ofs << text << std::endl;
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

void preprocess_only() {
    for (auto& asm_filename : g_options.input_files) {
        if (g_options.is_o_filename(asm_filename)) {
            if (g_options.verbose) {
                std::cout << "Skipping preprocessing for object file: " << asm_filename << std::endl;
            }
        }
        else {
            std::string i_filename = g_options.get_i_filename(asm_filename);

            if (g_options.verbose) {
                std::cout << "Preprocessing file: " << asm_filename << " -> " << i_filename << std::endl;
            }

            Preprocessor::preprocess_file(asm_filename, i_filename, g_options.gen_dependencies);
        }
    }
}
