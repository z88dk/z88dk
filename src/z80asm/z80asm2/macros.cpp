//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "macros.h"
#include "errors.h"
#include <algorithm>
#include <unordered_map>

int g_unique_id_counter = 0;

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
        g_errors.error(location_, ErrorCode::ParameterRedefined, param);
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
        g_errors.error(location_, ErrorCode::SymbolRedefined, local);
    }
    else {
        locals_.push_back(local);
    }
}

const std::vector<TokenLine>& Macro::body_lines() const {
    return body_lines_;
}

void Macro::add_body_line(const TokenLine& line) {
    body_lines_.push_back(line);
    body_lines_.back().set_location(location_);
}

bool Macro::parse_parameters(const TokenLine& line, size_t& index) {
    const auto& toks = line.tokens();
    size_t i = index;
    bool in_parens = false;
    std::vector<std::string> temp_params;

    auto fail = [&](ErrorCode ec, const std::string & message) {
        g_errors.error(line.location(), ec, message);
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
        g_errors.error(line.location(), ec, message);
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
        ++i;
    }

    // Push the final argument only if it contains tokens.
    // Do NOT emit a single empty argument when there is no input.
    // In general, after parsing stops, we should commit the last collected `current`.
    if (!current.empty()) {
        out_arguments.emplace_back(line.location(), current);
    }

    // Success: return at first non-parsed token
    index = i;
    return true;
}

bool Macro::parse_body_line(const TokenLine& line) {
    const auto& toks = line.tokens();

    // Empty line: store and continue
    if (toks.empty()) {
        add_body_line(line);
        return false;
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
            g_errors.error(line.location(), ErrorCode::InvalidSyntax,
                           std::string("Unexpected token '") + toks[1].text() + "'");
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
            return true;
        }
        if (idx < toks.size()) {
            g_errors.error(line.location(), ErrorCode::InvalidSyntax,
                           std::string("Unexpected token '") + toks[idx].text() + "'");
            return true;
        }
        return true;
    }

    // 4) Any other input: store the line and return true
    add_body_line(line);
    return true;
}

void Macro::expand(const Location& location, const std::vector<TokenLine>& arguments,
                   std::vector<TokenLine>& out_lines) {

    out_lines.clear();
    out_lines.reserve(body_lines_.size());

    // 1) short-cut : no parameters and no locals --> copy body as-is
    if (parameters_.empty() && locals_.empty()) {
        for (const auto& body : body_lines_) {
            TokenLine out_line(location, body.tokens());
            out_lines.push_back(out_line);
        }
        return;
    }

    // 2) Parameter count validation
    if (arguments.size() != parameters_.size()) {
        g_errors.error(location, ErrorCode::InvalidSyntax,
                       "Macro argument count does not match parameters");
        return;
    }

    // 3) Build mappings
    //    - parameters --> full token sequence of the provided arguments
    //    - locals --> unique identifier string "var_<id>"
    std::unordered_map<std::string, std::vector<Token>> param_tokens;
    std::unordered_map<std::string, std::string>         local_names;

    // Map parameters to argument tokens
    for (size_t i = 0; i < parameters_.size(); ++i) {
        param_tokens[parameters_[i]] = arguments[i].tokens();
    }

    // Generate unique name for locals for this expansion
    if (!locals_.empty()) {
        int unique_id = g_unique_id_counter++;
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
        for (const auto& tok : toks) {
            // Replace parameter identifiers with full argument token sequence
            if (tok.is(TokenType::Identifier)) {
                const std::string& name = tok.text();

                // Parameter substitution
                auto pit = param_tokens.find(name);
                if (pit != param_tokens.end()) {
                    const auto& argTokens = pit->second;
                    expanded.insert(expanded.end(), argTokens.begin(), argTokens.end());
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
    macros_.emplace(macro.name(), macro);
}

void Macros::clear() {
    macros_.clear();
}

bool Macros::expand(const TokenLine& line, std::vector<TokenLine>& out_lines) {
    out_lines.clear();

    const auto& toks = line.tokens();
    size_t i = 0;
    bool expanded_any = false;

    // Build the resulting single line by splicing macro expansions inline.
    std::vector<Token> current;

    // Buffer subsequent expanded lines to preserve correct order:
    // first inline line (with trailing tokens) must be emitted before these.
    std::vector<std::vector<Token>> pending_lines;

    // DRY helper: splice first expanded line inline; queue remaining as separate lines.
    auto splice_expanded = [&](const std::vector<TokenLine>& macro_out) {
        if (!macro_out.empty()) {
            const auto& first_toks = macro_out.front().tokens();
            current.insert(current.end(), first_toks.begin(), first_toks.end());
            for (size_t k = 1; k < macro_out.size(); ++k) {
                pending_lines.push_back(macro_out[k].tokens());
            }
        }
    };

    while (i < toks.size()) {
        const Token& tok = toks[i];

        if (tok.is(TokenType::Identifier)) {
            Macro* macro = get_macro(tok.text());
            if (macro != nullptr) {
                expanded_any = true;

                if (macro->is_function_like()) {
                    // Optional parens for arguments
                    size_t idx = i + 1;
                    std::vector<TokenLine> args;
                    size_t arg_idx = idx;

                    if (idx < toks.size() && toks[idx].is(TokenType::LeftParen)) {
                        arg_idx = idx + 1;
                        macro->parse_arguments(line, arg_idx, args);
                        if (arg_idx < toks.size() && toks[arg_idx].is(TokenType::RightParen)) {
                            ++arg_idx; // consume ')'
                        }
                        else {
                            g_errors.error(line.location(), ErrorCode::InvalidSyntax,
                                           "Right parenthesis expected");
                        }
                    }
                    else {
                        // No '(' -> parse until top-level ')' or end of line
                        macro->parse_arguments(line, arg_idx, args);
                    }

                    // Recursively expand each argument flat
                    std::vector<TokenLine> expanded_args;
                    expanded_args.reserve(args.size());
                    for (const auto& a : args) {
                        expanded_args.emplace_back(expand_flat(a));
                    }

                    // Expand macro and splice inline (queue subsequent lines)
                    std::vector<TokenLine> macro_out;
                    macro->expand(line.location(), expanded_args, macro_out);
                    splice_expanded(macro_out);

                    i = arg_idx;
                    continue;
                }
                else {
                    // Object-like macro: expand and splice inline (queue subsequent lines)
                    std::vector<TokenLine> macro_out;
                    macro->expand(line.location(), std::vector<TokenLine> {}, macro_out);
                    splice_expanded(macro_out);

                    ++i;
                    continue;
                }
            }
        }

        // Not a macro: copy token verbatim
        current.push_back(tok);
        ++i;
    }

    // Emit single line with inline expansions first
    out_lines.emplace_back(line.location(), current);

    // Then emit queued subsequent lines in order
    for (const auto& pl : pending_lines) {
        out_lines.emplace_back(line.location(), pl);
    }

    return expanded_any;
}

TokenLine Macros::expand_flat(const TokenLine& line) {
    std::vector<TokenLine> expanded;
    expand(line, expanded);
    std::vector<Token> flat_tokens;
    for (const auto& expanded_line : expanded) {
        const auto& toks = expanded_line.tokens();
        flat_tokens.insert(flat_tokens.end(), toks.begin(), toks.end());
    }
    return TokenLine(line.location(), flat_tokens);
}

