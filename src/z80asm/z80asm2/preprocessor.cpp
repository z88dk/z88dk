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

//-----------------------------------------------------------------------------
// class implementation
//-----------------------------------------------------------------------------
Preprocessor::Preprocessor() {
}

void Preprocessor::clear() {
    input_queue_.clear();
    file_stack_.clear();
    macros_.clear();
    if_stack_.clear();
    dependency_file_.clear();
    macro_fixpoint_iterations_ = 0;
    module_.clear();
}

void Preprocessor::push_file(const std::string& filename) {
    // Normalize the path to ensure consistent filenames in locations
    std::string normalized_filename = normalize_path(filename);

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
    return pp_next_line(out_line);
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

    // Other directives only execute when all IFs are active
    if (!output_active()) {
        return true; // skip line
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

    i = start;  // rewind
    return false;
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

Module* Preprocessor::pp_module() {
    return &module_;
}

Section* Preprocessor::pp_current_section() {
    return module_.current_section();
}

// Dependency collection API
// Returns the list of files that were pushed via push_file
// in the order they were recorded (duplicates preserved).
const std::vector<std::string>& Preprocessor::dependency_filenames() const {
    return dependency_file_.dependencies();
}

void Preprocessor::generate_dependency_file() {
    dependency_file_.write();
}

void Preprocessor::preprocess_file(const std::string& input_filename,
                                   const std::string& output_filename,
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
                std::cout << "Skipping preprocessing of object file: "
                          << asm_filename << std::endl;
            }
        }
        else {
            std::string i_filename = g_options.get_i_filename(asm_filename);

            if (g_options.verbose) {
                std::cout << "Preprocessing file: "
                          << asm_filename << " -> " << i_filename << std::endl;
            }

            Preprocessor::preprocess_file(asm_filename, i_filename, g_options.gen_dependencies);
        }
    }
}
