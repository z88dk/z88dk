//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "macros.h"
#include "utils.h"
#include <algorithm>
#include <unordered_map>

size_t g_unique_id_counter = 0;

//-----------------------------------------------------------------------------
// Recursion guard and limit (single-threaded assembler)
//-----------------------------------------------------------------------------
namespace {
struct RecursionGuard {
    Macro* macro_;
    explicit RecursionGuard(Macro* m) : macro_(m) {}
    ~RecursionGuard() {
        if (macro_ != nullptr) {
            macro_->decrement_recursion();
        }
    }
};
constexpr size_t MACRO_RECURSION_LIMIT = 100;
}

//-----------------------------------------------------------------------------
// Macro
//-----------------------------------------------------------------------------

Macro::Macro(const std::string& name, const Location& location)
    : name_(name), location_(location) {
}

const std::string& Macro::name() const {
    return name_;
}

const Location& Macro::location() const {
    return location_;
}

bool Macro::is_function_like() const {
    return is_function_like_;
}

void Macro::set_function_like(bool f) {
    is_function_like_ = f;
}

const std::vector<std::string>& Macro::parameters() const {
    return parameters_;
}

void Macro::add_parameter(const std::string& param) {
    if (std::find(parameters_.begin(), parameters_.end(), param) != parameters_.end()) {
        g_errors.error(ErrorCode::ParameterRedefined, param);
    }
    else {
        parameters_.push_back(param);
    }
}

const std::vector<std::string>& Macro::locals() const {
    return locals_;
}

void Macro::add_local(const std::string& local) {
    // error if local duplicates an existing local or parameter name
    if (std::find(locals_.begin(), locals_.end(), local) != locals_.end() ||
            std::find(parameters_.begin(), parameters_.end(), local) != parameters_.end()) {
        g_errors.error(ErrorCode::SymbolRedefined, local);
    }
    else {
        locals_.push_back(local);
    }
}

const std::vector<TokenLine>& Macro::body_lines() const {
    return body_lines_;
}

std::vector<TokenLine>& Macro::body_lines() {
    return body_lines_;
}

void Macro::add_body_line(const TokenLine& line) {
    body_lines_.push_back(line);
    body_lines_.back().set_location(location_);
}

void Macro::add_body_line(const TokenLine& line, size_t i) {
    std::vector<Token> tokens;
    tokens.reserve(line.tokens().size());
    while (i < line.tokens().size()) {
        tokens.push_back(line.tokens()[i]);
        ++i;
    }
    TokenLine tl(location_, std::move(tokens));
    body_lines_.push_back(std::move(tl));
}

bool Macro::parse_parameters(const TokenLine& line, size_t& index) {
    const auto& toks = line.tokens();
    size_t i = index;
    bool in_parens = false;
    std::vector<std::string> temp_params;

    auto fail = [&](ErrorCode ec, const std::string & message) {
        g_errors.error(ec, message);
        parameters_.clear();
        return false;
    };

    // Helper: add a parameter name ensuring duplicates inside the same list are rejected
    auto add_param_name = [&](const std::string & name) -> bool {
        if (std::find(temp_params.begin(), temp_params.end(), name) != temp_params.end()) {
            return fail(ErrorCode::ParameterRedefined, name);
        }
        temp_params.push_back(name);
        return true;
    };

    // Optional opening parenthesis
    if (i < toks.size() && toks[i].is(TokenType::LeftParen)) {
        in_parens = true;
        is_function_like_ = true;
        i++;

        // Empty list "()"
        if (i < toks.size() && toks[i].is(TokenType::RightParen)) {
            index = i + 1;
            return true;
        }

        // If right after '(' we don't have an identifier, it's a syntax error
        if (i >= toks.size() || !toks[i].is(TokenType::Identifier)) {
            return fail(ErrorCode::InvalidSyntax, "Identifier expected");
        }
    }

    // If not in parens and next token is not an identifier, treat as empty list
    if (!in_parens) {
        if (i >= toks.size() || !toks[i].is(TokenType::Identifier)) {
            // Empty parameter list without parentheses; success with index unchanged
            return true;
        }
    }

    // Parse first identifier
    if (i < toks.size() && toks[i].is(TokenType::Identifier)) {
        is_function_like_ = true;
        if (!add_param_name(toks[i].text())) {
            return false;
        }
        i++;
    }
    else {
        // Guard: should not happen due to checks above
        return fail(ErrorCode::InvalidSyntax, "Identifier expected");
    }

    // Parse subsequent ", identifier" pairs
    while (i < toks.size() && toks[i].is(TokenType::Comma)) {
        i++; // skip comma
        if (i < toks.size() && toks[i].is(TokenType::Identifier)) {
            if (!add_param_name(toks[i].text())) {
                return false;
            }
            i++;
        }
        else {
            return fail(ErrorCode::InvalidSyntax, "Identifier expected");
        }
    }

    // If we started with '(', we must end with ')'
    if (in_parens) {
        if (i < toks.size() && toks[i].is(TokenType::RightParen)) {
            i++;
        }
        else {
            return fail(ErrorCode::InvalidSyntax, "Right parenthesis expected");
        }
    }

    // Commit parsed parameters on success
    parameters_ = std::move(temp_params);

    // Success: return at first non-parsed token
    index = i;
    return true;
}

bool Macro::parse_locals(const TokenLine& line, size_t& index) {
    const auto& toks = line.tokens();
    size_t i = index;
    std::vector<std::string> temp_locals;

    auto fail = [&](ErrorCode ec, const std::string & message) {
        g_errors.error(ec, message);
        return false;
    };

    // Helper: add a local name ensuring duplicates within the list and
    // conflicts with existing locals/parameters are rejected
    auto add_local_name = [&](const std::string & name) -> bool {
        if (std::find(temp_locals.begin(), temp_locals.end(), name) != temp_locals.end()) {
            return fail(ErrorCode::SymbolRedefined, name);
        }
        if (std::find(locals_.begin(), locals_.end(), name) != locals_.end() ||
                std::find(parameters_.begin(), parameters_.end(), name) != parameters_.end()) {
            return fail(ErrorCode::SymbolRedefined, name);
        }
        temp_locals.push_back(name);
        return true;
    };

    // If next token is not an identifier, treat as empty list
    if (i >= toks.size() || !toks[i].is(TokenType::Identifier)) {
        // Empty locals list; success with index unchanged
        return true;
    }

    // Parse first identifier
    if (i < toks.size() && toks[i].is(TokenType::Identifier)) {
        if (!add_local_name(toks[i].text())) {
            return false;
        }
        i++;
    }
    else {
        return fail(ErrorCode::InvalidSyntax, "Identifier expected");
    }

    // Parse subsequent ", identifier" pairs
    while (i < toks.size() && toks[i].is(TokenType::Comma)) {
        i++; // skip comma
        if (i < toks.size() && toks[i].is(TokenType::Identifier)) {
            if (!add_local_name(toks[i].text())) {
                return false;
            }
            i++;
        }
        else {
            return fail(ErrorCode::InvalidSyntax, "Identifier expected");
        }
    }

    // Commit: append parsed locals on success
    locals_.insert(locals_.end(), temp_locals.begin(), temp_locals.end());

    // Success: return at first non-parsed token
    index = i;
    return true;
}

bool Macro::parse_arguments(const TokenLine& line, size_t& index,
                            std::vector<TokenLine>& out_arguments) {
    const auto& toks = line.tokens();
    size_t i = index;
    int paren_level = 0;

    std::vector<Token> current;
    bool last_was_top_level_comma = false; // track trailing separator

    while (i < toks.size()) {
        const Token& tok = toks[i];

        // Stop at a closing paren when not inside any paren list
        if (tok.is(TokenType::RightParen) && paren_level == 0) {
            // Do not consume this token; leave index at first non-parsed token
            break;
        }

        if (tok.is(TokenType::Comma) && paren_level == 0) {
            // Argument separator at top level: finalize current argument
            out_arguments.emplace_back(line.location(), current);
            current.clear();
            last_was_top_level_comma = true; // potential trailing empty arg
            ++i; // consume comma and continue
            continue;
        }

        // Track parenthesis nesting
        if (tok.is(TokenType::LeftParen)) {
            ++paren_level;
        }
        else if (tok.is(TokenType::RightParen)) {
            if (paren_level > 0) {
                --paren_level;
            }
            // Top-level ')' is handled by the early-stop case above
        }

        // Add token to current argument
        current.push_back(tok);
        last_was_top_level_comma = false; // we consumed a non-separator token
        ++i;
    }

    // Commit the last collected argument:
    // - If it has tokens, push it.
    // - Otherwise, if we ended right after a top-level comma, push an empty argument
    //   to account for trailing separators (e.g., "A,B," or "A,B,)" before ')').
    if (!current.empty()) {
        out_arguments.emplace_back(line.location(), current);
    }
    else if (last_was_top_level_comma) {
        out_arguments.emplace_back(line.location(), std::vector<Token> {});
    }

    // Return first non-parsed token index (points at ')' if present)
    index = i;

    // check if parens balanced
    if (paren_level != 0) {
        return false;
    }
    return true;
}

bool Macro::parse_body_line(const TokenLine& line) {
    const auto& toks = line.tokens();

    // Empty line: store and continue
    if (toks.empty()) {
        add_body_line(line);
        return true;
    }

    const Token& t0 = toks[0];

    // 1) Start of nested MACRO:
    //    - first token is 'MACRO', or
    //    - first is identifier and second is 'MACRO'
    if (t0.is(Keyword::MACRO) ||
            (t0.is(TokenType::Identifier) && toks.size() >= 2 && toks[1].is(Keyword::MACRO))) {
        ++nesting_level_;
        add_body_line(line);
        return true;
    }

    // 2) ENDM encountered:
    if (t0.is(Keyword::ENDM)) {
        // If there are more tokens beyond ENDM, report unexpected token
        if (toks.size() > 1) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           std::string("Unexpected token: '") + toks[1].text() + "'");
        }

        // Decrement nesting
        if (nesting_level_ > 0) {
            --nesting_level_;
        }

        // If nesting reached zero, this ENDM closes the outermost MACRO:
        // - do not store the line, return false
        if (nesting_level_ == 0) {
            return false;   // return false to signal end of macro body
        }

        // Still inside nested MACRO: store the line, return true
        add_body_line(line);
        return true;
    }

    // 3) LOCAL: parse locals, do not store the line
    if (t0.is(Keyword::LOCAL)) {
        size_t idx = 1; // parse after 'LOCAL'
        if (!parse_locals(line, idx)) {
            // error already reported
        }
        else if (idx < toks.size()) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           std::string("Unexpected token: '") + toks[idx].text() + "'");
        }
        return true;
    }

    // 4) Any other input: store the line and return true
    add_body_line(line);
    return true;
}

void Macro::expand(const Location& location, const std::vector<TokenLine>& arguments,
                   std::vector<TokenLine>& out_lines) {
    // Backward-compatible: use expanded args for both expanded and raw,
    // which means stringize will reflect the already-expanded argument.
    expand_with_raw(location, arguments, arguments, out_lines);
}

void Macro::expand_with_raw(const Location& location,
                            const std::vector<TokenLine>& expanded_args,
                            const std::vector<TokenLine>& raw_args,
                            std::vector<TokenLine>& out_lines) {
    out_lines.clear();
    out_lines.reserve(body_lines_.size());

    // 1) Parameter count validation (must run before any short-cut)
    if (expanded_args.size() != parameters_.size()) {
        g_errors.error(ErrorCode::InvalidSyntax,
                       "Macro argument count mismatch for: " + name_);
        return;
    }

    // 2) Short-cut: no parameters and no locals --> copy body as-is
    if (parameters_.empty() && locals_.empty()) {
        for (const auto& body : body_lines_) {
            out_lines.emplace_back(location, body.tokens());
        }
        return;
    }

    // 3) Build mappings
    //    - parameters --> full token sequence of the provided expanded arguments
    //    - raw_parameters --> full token sequence of the provided raw (unexpanded) arguments (for stringize)
    //    - locals --> unique identifier string "<name>_<id>"
    std::unordered_map<std::string, std::vector<Token>> param_tokens;
    std::unordered_map<std::string, std::vector<Token>> raw_param_tokens;
    std::unordered_map<std::string, std::string>         local_names;

    // Map parameters to expanded/raw argument tokens
    for (size_t i = 0; i < parameters_.size(); ++i) {
        param_tokens[parameters_[i]] = expanded_args[i].tokens();
        raw_param_tokens[parameters_[i]] = raw_args[i].tokens();
    }

    // Generate unique name for locals for this expansion
    if (!locals_.empty()) {
        size_t unique_id = g_unique_id_counter++;
        const std::string unique_suffix = "_" + std::to_string(unique_id);

        for (const auto& local : locals_) {
            local_names[local] = local + unique_suffix;
        }
    }

    // 4) Produce expanded body lines
    for (const auto& body : body_lines_) {
        std::vector<Token> expanded;
        expanded.reserve(body.tokens().size());

        const auto& toks = body.tokens();
        for (size_t j = 0; j < toks.size(); ++j) {
            const Token& tok = toks[j];

            // Stringize: '#' followed by parameter identifier -> string token from RAW argument tokens
            if (tok.is(TokenType::Hash) && (j + 1) < toks.size() && toks[j + 1].is(TokenType::Identifier)) {
                const std::string& pname = toks[j + 1].text();
                auto rit = raw_param_tokens.find(pname);
                if (rit != raw_param_tokens.end()) {
                    const auto& raw_toks = rit->second;
                    std::string strval;
                    strval.reserve(32);
                    for (const auto& rt : raw_toks) {
                        strval += rt.text();
                        if (rt.has_space_after()) {
                            strval += " ";
                        }
                    }
                    // Create a string token with quoted text as token text and raw string value
                    Token string_tok(TokenType::String, std::string("\"") + escape_c_string(strval) + "\"", strval, false);
                    expanded.push_back(string_tok);
                    j++; // consume parameter identifier as well
                    continue;
                }
                // If not a parameter, emit '#' as-is
                expanded.push_back(tok);
                continue;
            }

            // Replace parameter identifiers with full EXPANDED argument token sequence
            if (tok.is(TokenType::Identifier)) {
                const std::string& name = tok.text();

                // Parameter substitution (expanded)
                auto pit = param_tokens.find(name);
                if (pit != param_tokens.end()) {
                    const auto& arg_tokens = pit->second;
                    expanded.insert(expanded.end(), arg_tokens.begin(), arg_tokens.end());
                    continue;
                }

                // Local substitution
                auto lit = local_names.find(name);
                if (lit != local_names.end()) {
                    expanded.emplace_back(TokenType::Identifier, lit->second, false);
                    continue;
                }
            }

            // Default: copy token as-is
            expanded.push_back(tok);
        }

        // Keep caller's location for expanded lines
        TokenLine out_line(location, expanded);
        out_lines.push_back(out_line);
    }
}

TokenLine Macro::expand_flat(const Location& location, const std::vector<TokenLine>& arguments) {
    std::vector<TokenLine> expanded;
    expand(location, arguments, expanded);
    std::vector<Token> flat_tokens;
    for (const auto& line : expanded) {
        const auto& toks = line.tokens();
        flat_tokens.insert(flat_tokens.end(), toks.begin(), toks.end());
    }
    return TokenLine(location, flat_tokens);
}

//-----------------------------------------------------------------------------
// Macros container
//-----------------------------------------------------------------------------

bool Macros::has_macro(const std::string& name) const {
    auto it = macros_.find(name);
    return it != macros_.end();
}

Macro* Macros::get_macro(const std::string& name) {
    auto it = macros_.find(name);
    return it != macros_.end() ? &it->second : nullptr;
}

const Macro* Macros::get_macro(const std::string& name) const {
    auto it = macros_.find(name);
    return it != macros_.end() ? &it->second : nullptr;
}

void Macros::add_macro(const Macro& macro) {
    if (has_macro(macro.name())) {
        g_errors.error(macro.location(), ErrorCode::MacroRedefined, macro.name());
        return;
    }
    macros_.insert_or_assign(macro.name(), macro);
}

void Macros::replace_macro(const Macro& macro) {
    macros_.insert_or_assign(macro.name(), macro);
}

void Macros::remove_macro(const std::string& name) {
    macros_.erase(name);
}

void Macros::clear() {
    macros_.clear();
}

bool Macros::expand(const TokenLine& line, std::vector<TokenLine>& out_lines) {
    size_t i = 0;
    return expand(line, i, out_lines);
}

static bool has_macro_or_paste_in_suffix(const Macros* self, const std::vector<Token>& toks, size_t start) {
    for (size_t k = start; k < toks.size(); ++k) {
        const Token& t = toks[k];
        if (t.is(TokenType::Identifier)) {
            if (self->has_macro(t.text())) {
                return true;
            }
            if ((k + 2) < toks.size() &&
                    toks[k + 1].is(TokenType::DoubleHash) &&
                    (toks[k + 2].is(TokenType::Identifier) || toks[k + 2].is(TokenType::Integer))) {
                return true;
            }
        }
    }
    return false;
}

bool Macros::expand_once(const TokenLine& line, std::vector<TokenLine>& out_lines) {
    size_t i = 0;
    return expand_once(line, i, out_lines);
}

// Single-pass helper that processes only the suffix [i .. end) of one line,
// producing a list of TokenLine(s) without flattening.
// Returns whether it changed anything (macros expanded or token pasted).
bool Macros::expand_once(const TokenLine& line, size_t i, std::vector<TokenLine>& out_lines) {
    out_lines.clear();

    const auto& toks = line.tokens();
    if (i >= toks.size()) {
        out_lines.emplace_back(line.location(), std::vector<Token> {});
        return false;
    }

    // Quick path: no macros nor pasting in suffix -> return the original suffix as one line
    if (!has_macro_or_paste_in_suffix(this, toks, i)) {
        std::vector<Token> suffix(toks.begin() + static_cast<std::ptrdiff_t>(i), toks.end());
        out_lines.emplace_back(line.location(), std::move(suffix));
        return false;
    }

    bool changed = false;

    // Process suffix with single-pass logic
    std::vector<Token> suffix_out;
    suffix_out.reserve(toks.size() - i);

    // Collect subsequent macro lines to append after the first output line
    std::vector<TokenLine> trailing_lines;

    size_t k = i;
    while (k < toks.size()) {
        const Token& tok = toks[k];

        // Token pasting first
        if (tok.is(TokenType::Identifier)) {
            size_t paste_idx = k;
            std::string pasted_name = tok.text();

            while ((paste_idx + 2) < toks.size()
                    && toks[paste_idx + 1].is(TokenType::DoubleHash)
                    && (toks[paste_idx + 2].is(TokenType::Identifier) || toks[paste_idx + 2].is(TokenType::Integer))) {
                pasted_name += toks[paste_idx + 2].text();
                paste_idx += 2;
            }

            if (paste_idx > k) {
                // Emit pasted identifier; defer its macro expansion to later passes
                suffix_out.emplace_back(TokenType::Identifier, pasted_name, false);
                changed = true;
                k = paste_idx + 1;
                continue;
            }
        }

        // Macro expansion (single occurrence in this pass)
        if (tok.is(TokenType::Identifier)) {
            Macro* macro = get_macro(tok.text());
            if (macro != nullptr) {
                last_expanded_macro_ = macro->name();

                if (macro->recursion_count() >= MACRO_RECURSION_LIMIT) {
                    g_errors.error(ErrorCode::MacroRecursionLimit, macro->name());
                    // Emit verbatim; do not mark change to allow convergence
                    suffix_out.push_back(tok);
                    ++k;
                    continue;
                }

                macro->increment_recursion();
                RecursionGuard guard(macro);

                std::vector<TokenLine> macro_out;

                if (macro->is_function_like()) {
                    size_t arg_idx = k + 1;

                    // Parenthesized form
                    if (arg_idx < toks.size() && toks[arg_idx].is(TokenType::LeftParen)) {
                        size_t parse_idx = arg_idx + 1;

                        TokenLine temp(line.location(),
                                       std::vector<Token>(toks.begin() + static_cast<std::ptrdiff_t>(parse_idx), toks.end()));
                        size_t rel = 0;
                        std::vector<TokenLine> raw_args;
                        macro->parse_arguments(temp, rel, raw_args);

                        size_t consumed = parse_idx + rel;
                        if (consumed < toks.size() && toks[consumed].is(TokenType::RightParen)) {
                            ++consumed;
                        }
                        else {
                            g_errors.error(ErrorCode::InvalidSyntax, "Right parenthesis expected");
                        }

                        std::vector<TokenLine> expanded_args;
                        expanded_args.reserve(raw_args.size());
                        for (const auto& a : raw_args) {
                            expanded_args.emplace_back(expand_flat(a));
                        }

                        macro->expand_with_raw(line.location(), expanded_args, raw_args, macro_out);
                        k = consumed;
                    }
                    // Unparenthesized form: strict arity check required
                    else {
                        TokenLine temp(line.location(),
                                       std::vector<Token>(toks.begin() + static_cast<std::ptrdiff_t>(arg_idx), toks.end()));
                        size_t rel = 0;
                        std::vector<TokenLine> raw_args;
                        macro->parse_arguments(temp, rel, raw_args);

                        // Only expand if arity matches exactly; otherwise treat as literal (no expansion)
                        if (raw_args.size() != macro->parameters().size()) {
                            // Leave identifier as-is; do not consume arguments here
                            suffix_out.push_back(tok);
                            ++k;
                            continue;
                        }

                        std::vector<TokenLine> expanded_args;
                        expanded_args.reserve(raw_args.size());
                        for (const auto& a : raw_args) {
                            expanded_args.emplace_back(expand_flat(a));
                        }

                        macro->expand_with_raw(line.location(), expanded_args, raw_args, macro_out);
                        k = arg_idx + rel;
                    }
                }
                else {
                    macro->expand_with_raw(line.location(), std::vector<TokenLine> {}, std::vector<TokenLine> {}, macro_out);
                    ++k;
                }

                if (!macro_out.empty()) {
                    // First macro line goes inline into the current output line
                    suffix_out.insert(suffix_out.end(),
                                      macro_out[0].tokens().begin(),
                                      macro_out[0].tokens().end());
                    // Subsequent lines are queued to be appended after suffix_out
                    for (size_t m = 1; m < macro_out.size(); ++m) {
                        trailing_lines.push_back(macro_out[m]);
                    }
                }
                changed = true;
                continue;
            }
        }

        // Default: copy verbatim
        suffix_out.push_back(tok);
        ++k;
    }

    // Emit first output line (processed suffix)
    out_lines.emplace_back(line.location(), std::move(suffix_out));

    // Append subsequent macro lines in order
    for (auto& tl : trailing_lines) {
        out_lines.push_back(std::move(tl));
    }

    return changed;
}

bool Macros::expand(const TokenLine& line, size_t i, std::vector<TokenLine>& out_lines) {
    out_lines.clear();

    // First pass: expand only the suffix of the input line
    bool changed = expand_once(line, i, out_lines);
    if (!changed) {
        // Nothing to do -> already returned suffix as single line
        return false;
    }

    // Iterate over the full list of output lines, expanding each line from index 0
    constexpr size_t MAX_ITERATIONS = 100;
    size_t iteration = 0;

    while (true) {
        std::vector<TokenLine> next;
        bool changed_this_round = false;
        last_expanded_macro_.clear();

        // Process each line independently from index 0
        for (const auto& tl : out_lines) {
            std::vector<TokenLine> expanded_line_out;
            bool line_changed = expand_once(tl, 0, expanded_line_out);

            // Append expanded lines to next result
            next.insert(next.end(), expanded_line_out.begin(), expanded_line_out.end());

            if (line_changed) {
                changed_this_round = true;
            }
        }

        if (!changed_this_round) {
            // Stable -> done
            out_lines = std::move(next);
            return true;
        }

        ++iteration;
        if (iteration >= MAX_ITERATIONS) {
            std::string macro_name = last_expanded_macro_.empty() ? std::string("<unknown>") : last_expanded_macro_;
            g_errors.error(ErrorCode::MacroRecursionLimit,
                           std::string("Macro expansion iteration limit reached; last expanded: ") + macro_name);
            out_lines = std::move(next);
            return true;
        }

        // Feed back for next iteration
        out_lines = std::move(next);
    }
}

TokenLine Macros::expand_flat(const TokenLine& line) {
    std::vector<TokenLine> expanded;
    expand(line, expanded);
    return flatten(line.location(), std::move(expanded));
}

TokenLine Macros::expand_flat(const TokenLine& line, size_t i) {
    std::vector<TokenLine> expanded;
    expand(line, i, expanded);
    return flatten(line.location(), std::move(expanded));
}

const std::string& Macros::last_expanded_macro() const {
    return last_expanded_macro_;
}

TokenLine Macros::flatten(const Location& location, const std::vector<TokenLine>& lines) {
    std::vector<Token> flat_tokens;
    for (const auto& line : lines) {
        const auto& toks = line.tokens();
        flat_tokens.insert(flat_tokens.end(), toks.begin(), toks.end());
    }
    return TokenLine(location, std::move(flat_tokens));
}

//-----------------------------------------------------------------------------
// REPT* block
//-----------------------------------------------------------------------------

RepeatBlock::RepeatBlock(Type type, const Location& location)
    : type_(type), macro_("", location) {
}

const Location& RepeatBlock::location() const {
    return macro_.location();
}

void RepeatBlock::add_body_line(const TokenLine& line) {
    macro_.add_body_line(line);
}

bool RepeatBlock::parse_body_line(const TokenLine& line) {
    const auto& toks = line.tokens();

    // Empty line: store and continue
    if (toks.empty()) {
        add_body_line(line);
        return false;
    }

    const Token& t0 = toks[0];

    // 1) Start of nested REPT|RETPI|REPTC:
    //    - first token is 'REPT|RETPI|REPTC', or
    //    - first is identifier and second is 'RETPI|REPTC'
    if (t0.is(Keyword::REPT) ||
            t0.is(Keyword::REPTI) ||
            t0.is(Keyword::REPTC) ||
            (t0.is(TokenType::Identifier) && toks.size() >= 2 &&
             (toks[1].is(Keyword::REPTI) ||
              toks[1].is(Keyword::REPTC)))) {
        ++nesting_level_;
        add_body_line(line);
        return true;
    }

    // 2) ENDR encountered:
    if (t0.is(Keyword::ENDR)) {
        // If there are more tokens beyond ENDR, report unexpected token
        if (toks.size() > 1) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           std::string("Unexpected token: '") + toks[1].text() + "'");
        }

        // Decrement nesting
        if (nesting_level_ > 0) {
            --nesting_level_;
        }

        // If nesting reached zero, this ENDR closes the outermost repeat block:
        // - do not store the line, return false
        if (nesting_level_ == 0) {
            return false;   // return false to signal end of repeat body
        }

        // Still inside nested REPT*: store the line, return true
        add_body_line(line);
        return true;
    }

    // 3) LOCAL: parse locals, do not store the line
    if (t0.is(Keyword::LOCAL)) {
        size_t idx = 1; // parse after 'LOCAL'
        if (!macro_.parse_locals(line, idx)) {
            // error already reported
            return true;
        }
        if (idx < toks.size()) {
            g_errors.error(ErrorCode::InvalidSyntax,
                           std::string("Unexpected token: '") + toks[idx].text() + "'");
            return true;
        }
        return true;
    }

    // 3) Any other input: store the line and return true
    add_body_line(line);
    return true;
}

//-----------------------------------------------------------------------------
// REPT block
//-----------------------------------------------------------------------------

RepeatCountBlock::RepeatCountBlock(const Location& location, size_t count)
    : RepeatBlock(Type::Count, location), count_(count) {
}

size_t RepeatCountBlock::count() const {
    return count_;
}

bool RepeatCountBlock::expand(const Location& location, std::vector<TokenLine>& out_lines) {
    out_lines.clear();
    if (count_ < 1) {
        return false;
    }

    out_lines.reserve(macro_.body_lines().size() * count_);
    for (size_t i = 0; i < count_; ++i) {
        std::vector<TokenLine> expansion;
        macro_.expand(location, std::vector<TokenLine> {}, expansion);
        out_lines.insert(out_lines.end(), expansion.begin(), expansion.end());
    }

    return true;
}

//-----------------------------------------------------------------------------
// REPTI block
//-----------------------------------------------------------------------------

RepeatIterateBlock::RepeatIterateBlock(const Location& location, const std::string& variable)
    : RepeatBlock(Type::Iterate, location) {
    macro_.add_parameter(variable);
}

const std::string& RepeatIterateBlock::variable() const {
    return macro_.parameters().front();
}

const std::vector<TokenLine>& RepeatIterateBlock::items() const {
    return items_;
}

std::vector<TokenLine>& RepeatIterateBlock::items() {
    return items_;
}

bool RepeatIterateBlock::parse_items(const TokenLine& line, size_t& index) {
    return macro_.parse_arguments(line, index, items_);
}

bool RepeatIterateBlock::expand(const Location& location, std::vector<TokenLine>& out_lines) {
    out_lines.clear();
    if (items_.empty()) {
        return false;
    }

    out_lines.reserve(macro_.body_lines().size() * items_.size());
    for (const auto& item : items_) {
        std::vector<TokenLine> args = { item };
        std::vector<TokenLine> expansion;
        macro_.expand(location, args, expansion);
        out_lines.insert(out_lines.end(), expansion.begin(), expansion.end());
    }

    return true;
}

//-----------------------------------------------------------------------------
// REPTC block
//-----------------------------------------------------------------------------

RepeatCharsBlock::RepeatCharsBlock(const Location& location, const std::string& variable)
    : RepeatIterateBlock(location, variable) {
}

bool RepeatCharsBlock::parse_items(const TokenLine& line, size_t& index) {
    return parse_chars(line, index);
}

bool RepeatCharsBlock::parse_chars(const TokenLine& line, size_t& index) {
    const auto& toks = line.tokens();
    while (index < toks.size()) {
        const Token& tok = toks[index];
        const std::string& text = tok.is(TokenType::String) ? tok.string_value() : tok.text();
        for (auto c : text) {
            int value = static_cast<int>(static_cast<unsigned char>(c));
            Token token(TokenType::Integer, std::to_string(value), value, false);
            TokenLine char_line(line.location(), { token });
            items_.push_back(char_line);
        }
        ++index;
    }

    return true;
}
