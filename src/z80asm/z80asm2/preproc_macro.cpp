//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "lexer.h"
#include "lexer_tokens.h"
#include "preproc.h"
#include "string_interner.h"
#include "string_utils.h"
#include <algorithm>
#include <string>
#include <vector>

// Collect comma-separated arguments from tokens[pos] onward.
// If parenthesized is true, expects tokens[pos-1] was '(' and collects
// until the matching ')'. Returns false on error (missing ')').
// If parenthesized is false, collects bare arguments until EndOfLine.
// Returns false on error (unbalanced parentheses).
// Handles nested parentheses in both modes.
bool Preproc::collect_args_impl(const std::vector<Token>& tokens, size_t& pos,
                                std::vector<std::vector<Token>>& args,
                                bool parenthesized) {
    args.clear();

    // Handle empty parenthesized argument list: immediately closed
    if (parenthesized &&
            pos < tokens.size() &&
            tokens[pos].type == TokenType::RightParen) {
        pos++;
        return true;
    }

    std::vector<Token> current_arg;
    int paren_depth = 0;

    while (pos < tokens.size()) {
        const Token& tok = tokens[pos];

        if (tok.type == TokenType::EndOfLine) {
            break;
        }

        if (tok.type == TokenType::LeftParen) {
            paren_depth++;
            current_arg.push_back(tok);
            pos++;
        }
        else if (tok.type == TokenType::RightParen) {
            if (parenthesized && paren_depth == 0) {
                // End of parenthesized arguments
                args.push_back(std::move(current_arg));
                pos++; // consume ')'
                return true;
            }
            if (paren_depth == 0) {
                // Unmatched ')' in bare mode
                g_diag.error(tok.loc, "Unmatched ')'");
                return false;
            }
            paren_depth--;
            current_arg.push_back(tok);
            pos++;
        }
        else if (tok.type == TokenType::Comma && paren_depth == 0) {
            args.push_back(std::move(current_arg));
            current_arg.clear();
            pos++; // consume ','
        }
        else {
            current_arg.push_back(tok);
            pos++;
        }
    }

    // Bare mode: check for unbalanced '('
    if (!parenthesized) {
        if (paren_depth > 0) {
            // Find the location of the unmatched '(' for the error
            // Use the last token's location as a fallback
            SourceLoc err_loc = (pos > 0 && pos <= tokens.size())
                                ? tokens[pos - 1].loc : SourceLoc();
            g_diag.error(err_loc, "Unmatched '('");
            return false;
        }
        if (!current_arg.empty()) {
            args.push_back(std::move(current_arg));
        }
        return true;
    }

    return false; // parenthesized mode: missing ')'
}

bool Preproc::collect_parens_args(const std::vector<Token>& tokens, size_t& pos,
                                  std::vector<std::vector<Token>>& args) {
    return collect_args_impl(tokens, pos, args, true);
}

bool Preproc::collect_bare_args(const std::vector<Token>& tokens, size_t& pos,
                                std::vector<std::vector<Token>>& args) {
    return collect_args_impl(tokens, pos, args, false);
}

// Substitute macro parameters in a token list.
// For each token that matches a parameter name, replace with the
// corresponding argument tokens. Handles # (stringification) and
// ## (token pasting).
// If locals is non-empty, each local label name is replaced by
// name_N where N is a unique counter incremented per invocation.
std::vector<Token> Preproc::substitute_params(
    const std::vector<Token>& body,
    const std::vector<StringInterner::Id>& params,
    const std::vector<std::vector<Token>>& args,
    const SourceLoc& call_loc,
    const std::vector<StringInterner::Id>& locals) {

    // Build local label replacement map: name -> name_N
    // The counter is static so that each expansion site gets a unique suffix
    static int local_counter = 0;

    std::unordered_map<StringInterner::Id, StringInterner::Id> local_map;
    if (!locals.empty()) {
        ++local_counter;
        std::string suffix = "_" + std::to_string(local_counter);
        for (StringInterner::Id id : locals) {
            std::string replacement = g_strings.to_string(id) + suffix;
            local_map[id] = g_strings.intern(replacement);
        }
    }

    std::vector<Token> result;
    size_t n = body.size();

    for (size_t i = 0; i < n; ++i) {
        const Token& tok = body[i];

        // -------------------------------------------------------
        // # operator (stringification): # PARAM -> string literal
        // -------------------------------------------------------
        if (tok.type == TokenType::Hash && i + 1 < n &&
                body[i + 1].type == TokenType::Identifier) {
            auto pit = std::find(params.begin(), params.end(),
                                 body[i + 1].text_id);
            if (pit != params.end()) {
                size_t param_idx =
                    static_cast<size_t>(pit - params.begin());
                ++i; // consume the parameter identifier

                // Build stringified value from argument tokens
                std::string text;
                if (param_idx < args.size()) {
                    for (const Token& at : args[param_idx]) {
                        if (!text.empty()) {
                            text += ' ';
                        }
                        text += g_strings.to_string(at.text_id);
                    }
                }

                std::string quoted = escape_string(text);
                result.push_back(
                    Token::string(quoted, text, call_loc));
                continue;
            }
        }

        // -------------------------------------------------------
        // ## operator (token pasting)
        // -------------------------------------------------------
        if (tok.type == TokenType::DoubleHash) {
            // Remove trailing whitespace-like tokens from result (none
            // expected, but be safe)
            // Paste: concatenate text of LHS and RHS
            if (result.empty() || i + 1 >= n) {
                continue; // malformed, skip
            }

            // Get the RHS token (may be a param to substitute)
            const Token& rhs_tok = body[i + 1];
            ++i; // consume RHS

            std::string rhs_text;
            if (rhs_tok.type == TokenType::Identifier) {
                auto pit = std::find(params.begin(), params.end(),
                                     rhs_tok.text_id);
                if (pit != params.end()) {
                    size_t param_idx =
                        static_cast<size_t>(pit - params.begin());
                    if (param_idx < args.size()) {
                        for (const Token& at : args[param_idx]) {
                            rhs_text +=
                                g_strings.to_string(at.text_id);
                        }
                    }
                }
                else {
                    rhs_text = g_strings.to_string(rhs_tok.text_id);
                }
            }
            else {
                rhs_text = g_strings.to_string(rhs_tok.text_id);
            }

            // Concatenate with LHS
            std::string lhs_text =
                g_strings.to_string(result.back().text_id);
            std::string pasted = lhs_text + rhs_text;

            // Re-tokenize the pasted text to get proper token type
            std::vector<Token> pasted_tokens =
                tokenize_text(pasted, call_loc);
            // Remove trailing EndOfLine from tokenize_text output
            while (!pasted_tokens.empty() &&
                    pasted_tokens.back().type == TokenType::EndOfLine) {
                pasted_tokens.pop_back();
            }

            result.pop_back(); // remove LHS
            for (const Token& pt : pasted_tokens) {
                result.push_back(pt);
            }
            continue;
        }

        // -------------------------------------------------------
        // Parameter substitution
        // -------------------------------------------------------
        if (tok.type == TokenType::Identifier) {
            auto pit = std::find(params.begin(), params.end(),
                                 tok.text_id);
            if (pit != params.end()) {
                size_t param_idx =
                    static_cast<size_t>(pit - params.begin());
                if (param_idx < args.size()) {
                    for (const Token& at : args[param_idx]) {
                        result.push_back(at);
                    }
                }
                // else: missing argument, substitute nothing
                continue;
            }

            // ---------------------------------------------------
            // Local label substitution
            // ---------------------------------------------------
            auto lit = local_map.find(tok.text_id);
            if (lit != local_map.end()) {
                Token replaced = tok;
                replaced.text_id = lit->second;
                result.push_back(replaced);
                continue;
            }
        }

        // -------------------------------------------------------
        // Regular token: copy as-is
        // -------------------------------------------------------
        result.push_back(tok);
    }

    return result;
}

void Preproc::expand_line(const LogicalLine& in,
                          std::vector<Token>& out_tokens) {
    out_tokens.clear();

    // ---------------------------------------------------------------------
    // 1. Copy input tokens into working buffer
    // ---------------------------------------------------------------------
    std::vector<Token> work = in.tokens;

    // Per-token hide set: macros that have already been expanded to
    // produce this token. Prevents re-expansion of the same macro in
    // its own output, while allowing the same macro to appear
    // independently elsewhere on the line (e.g. "DEFB X, X").
    std::vector<std::vector<StringInterner::Id>> hide_sets(work.size());

    // Expansion iteration tracking
    int expansion_depth = 0;

    // ---------------------------------------------------------------------
    // 2. Main expansion loop: repeat until no more expansions
    // ---------------------------------------------------------------------
    bool expanded_any = true;
    while (expanded_any) {
        if (++expansion_depth > MAX_EXPANSION_DEPTH) {
            g_diag.error(in.loc, "Macro expansion limit exceeded");
            break;
        }

        expanded_any = false;

        // -------------------------------------------------------------
        // Scan tokens left-to-right
        // -------------------------------------------------------------
        for (size_t i = 0; i < work.size(); ++i) {
            Token& tok = work[i];

            // Only identifiers can be macro names
            if (tok.type != TokenType::Identifier) {
                continue;
            }

            StringInterner::Id name_id = tok.text_id;

            // Is this a defined macro?
            auto it = macros.find(name_id);
            if (it == macros.end()) {
                continue;
            }

            Macro& macro = it->second;

            // ---------------------------------------------------------
            // Recursion prevention: check this token's hide set
            // ---------------------------------------------------------
            if (std::find(hide_sets[i].begin(),
                          hide_sets[i].end(),
                          name_id) != hide_sets[i].end()) {
                // This token was already produced by expanding this
                // macro; do not expand again (breaks direct and
                // indirect recursion like A->B->A)
                continue;
            }

            // ---------------------------------------------------------
            // Classical multi-line macro
            // ---------------------------------------------------------
            if (macro.is_multiline) {
                // Collect arguments from tokens after the macro name
                size_t arg_pos = i + 1;
                std::vector<std::vector<Token>> args;

                // Skip whitespace/EndOfLine between name and args
                while (arg_pos < work.size() &&
                        work[arg_pos].type == TokenType::EndOfLine) {
                    ++arg_pos;
                }

                if (macro.has_parenthesized_params) {
                    // Parenthesized form: M6(arg1, arg2)
                    // Expect '(' immediately after name
                    if (arg_pos >= work.size() ||
                            work[arg_pos].type != TokenType::LeftParen) {
                        g_diag.error(tok.loc,
                                     "Expected '(' after macro '" +
                                     g_strings.to_string(name_id) + "'");
                        out_tokens.clear();
                        return;
                    }
                    arg_pos++; // consume '('

                    if (!collect_parens_args(work, arg_pos, args)) {
                        g_diag.error(tok.loc,
                                     "Missing ')' in macro invocation: " +
                                     g_strings.to_string(name_id));
                        out_tokens.clear();
                        return;
                    }
                }
                else {
                    // Bare form: M6 arg1, arg2
                    if (!collect_bare_args(work, arg_pos, args)) {
                        out_tokens.clear();
                        return; // error already emitted by collect_bare_args()
                    }
                }

                // Check argument count
                if (args.size() != macro.params.size()) {
                    g_diag.error(tok.loc,
                                 "Macro '" +
                                 g_strings.to_string(name_id) +
                                 "' expects " +
                                 std::to_string(macro.params.size()) +
                                 " arguments, got " +
                                 std::to_string(args.size()));
                    out_tokens.clear();
                    return;
                }

                // Build all expanded lines in a single deque
                std::deque<LogicalLine> expanded_lines;

                // Emit any tokens before the macro name as a separate
                // line (e.g. a label definition like "foo: MYMACRO arg")
                if (i > 0) {
                    LogicalLine prefix;
                    prefix.tokens.insert(prefix.tokens.end(),
                                         work.begin(),
                                         work.begin() + i);
                    prefix.tokens.push_back(Token::end_of_line(tok.loc));
                    prefix.loc = work[0].loc;
                    expanded_lines.push_back(std::move(prefix));
                }

                // Expand each macro body line
                for (const auto& body_line : macro.lines) {
                    // Strip trailing EndOfLine from body tokens before
                    // substitution; a fresh EndOfLine is appended below
                    // so that parameter tokens get the call-site location.
                    std::vector<Token> body_tokens = body_line.tokens;
                    while (!body_tokens.empty() &&
                            body_tokens.back().type == TokenType::EndOfLine) {
                        body_tokens.pop_back();
                    }

                    std::vector<Token> substituted =
                        substitute_params(body_tokens, macro.params,
                                          args, tok.loc, macro.locals);

                    LogicalLine ll;
                    ll.tokens = std::move(substituted);
                    ll.tokens.push_back(Token::end_of_line(tok.loc));
                    ll.loc = tok.loc;

                    expanded_lines.push_back(std::move(ll));
                }

                push_macro_expansion(name_id, std::move(expanded_lines));

                // Multi-line macros consume the entire line;
                // the expanded body lines are in the work queue
                // and will be emitted by next_logical_line.
                // Return empty output for the invocation line.
                out_tokens.clear();
                return;
            }

            // ---------------------------------------------------------
            // Function-like macro
            // ---------------------------------------------------------
            if (macro.is_function_like) {
                // Must have '(' immediately following (no spaces)
                size_t paren_pos = i + 1;
                if (paren_pos >= work.size() ||
                        work[paren_pos].type != TokenType::LeftParen) {
                    // Not a macro invocation, just an identifier
                    continue;
                }

                // Reject "NAME (" - the '(' must be adjacent to the identifier
                size_t ident_end = tok.loc.column +
                                   g_strings.view(tok.text_id).size();
                if (work[paren_pos].loc.column != ident_end) {
                    // Space between identifier and '(', not a macro call
                    continue;
                }

                // Consume '('
                paren_pos++;

                // Collect arguments
                std::vector<std::vector<Token>> args;
                if (!collect_parens_args(work, paren_pos, args)) {
                    g_diag.error(work[paren_pos].loc,
                                 "Missing ')' in macro invocation: " +
                                 g_strings.to_string(name_id));
                    continue;
                }

                // Check argument count
                if (args.size() != macro.params.size()) {
                    g_diag.error(tok.loc,
                                 "Macro '" +
                                 g_strings.to_string(name_id) +
                                 "' expects " +
                                 std::to_string(macro.params.size()) +
                                 " arguments, got " +
                                 std::to_string(args.size()));
                    continue;
                }

                // Substitute parameters in macro body
                std::vector<Token> substituted =
                    substitute_params(macro.tokens, macro.params,
                                      args, tok.loc, macro.locals);

                // Build the new hide set for replacement tokens:
                // inherit the hide set of the invocation token + add
                // the macro we just expanded
                std::vector<StringInterner::Id> new_hide = hide_sets[i];
                new_hide.push_back(name_id);

                // Replace tokens[i..paren_pos) with substituted
                size_t new_count = substituted.size();

                std::vector<Token> new_work;
                new_work.reserve(i + new_count + (work.size() - paren_pos));
                new_work.insert(new_work.end(),
                                work.begin(), work.begin() + i);
                new_work.insert(new_work.end(),
                                substituted.begin(),
                                substituted.end());
                new_work.insert(new_work.end(),
                                work.begin() + paren_pos,
                                work.end());

                // Rebuild hide sets
                std::vector<std::vector<StringInterner::Id>> new_hides;
                new_hides.reserve(new_work.size());
                new_hides.insert(new_hides.end(),
                                 hide_sets.begin(),
                                 hide_sets.begin() + i);
                new_hides.insert(new_hides.end(), new_count, new_hide);
                new_hides.insert(new_hides.end(),
                                 hide_sets.begin() + paren_pos,
                                 hide_sets.end());

                work = std::move(new_work);
                hide_sets = std::move(new_hides);

                expanded_any = true;
                break; // restart scanning from the beginning
            }

            // ---------------------------------------------------------
            // Object-like macro
            // ---------------------------------------------------------
            {
                // Build the new hide set for replacement tokens:
                // inherit the hide set of the invocation token + add
                // the macro we just expanded
                std::vector<StringInterner::Id> new_hide = hide_sets[i];
                new_hide.push_back(name_id);

                size_t new_count = macro.tokens.size();

                // Replace token at position i with macro.tokens
                std::vector<Token> new_work;
                new_work.reserve(i + new_count + (work.size() - i - 1));
                new_work.insert(new_work.end(),
                                work.begin(), work.begin() + i);
                new_work.insert(new_work.end(),
                                macro.tokens.begin(),
                                macro.tokens.end());
                new_work.insert(new_work.end(),
                                work.begin() + i + 1,
                                work.end());

                // Rebuild hide sets
                std::vector<std::vector<StringInterner::Id>> new_hides;
                new_hides.reserve(new_work.size());
                new_hides.insert(new_hides.end(),
                                 hide_sets.begin(),
                                 hide_sets.begin() + i);
                new_hides.insert(new_hides.end(), new_count, new_hide);
                new_hides.insert(new_hides.end(),
                                 hide_sets.begin() + i + 1,
                                 hide_sets.end());

                work = std::move(new_work);
                hide_sets = std::move(new_hides);

                expanded_any = true;
                break; // restart scanning from the beginning
            }
        }
    }

    // ---------------------------------------------------------------------
    // 3. Finalization: copy expanded tokens + EndOfLine
    // ---------------------------------------------------------------------
    out_tokens.reserve(work.size() + 1);
    out_tokens.insert(out_tokens.end(), work.begin(), work.end());

    // Ensure line ends with EndOfLine
    if (out_tokens.empty() ||
            out_tokens.back().type != TokenType::EndOfLine) {
        SourceLoc end_loc = in.loc;
        if (!out_tokens.empty()) {
            end_loc = out_tokens.back().loc;
            end_loc.column += static_cast<uint16_t>(
                                  g_strings.to_string(out_tokens.back().text_id).size());
        }
        out_tokens.push_back(Token::end_of_line(end_loc));
    }
}

