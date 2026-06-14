//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "cpu.h"
#include "expr.h"
#include "hla_ast.h"
#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "opcodes.h"
#include "opcodes_synth_trie.h"
#include "opcodes_trie_token.h"
#include "options.h"
#include "parser.h"
#include "source_loc.h"
#include "string_interner.h"
#include "string_utils.h"
#include "synth_expander.h"
#include <algorithm>
#include <cassert>
#include <cstdint>
#include <string>
#include <vector>

SynthExpander::SynthExpander(const std::vector<LogicalLine>& lines)
    : synth_expander_cpu_id(g_args.options.cpu_id), lines(lines) {}

std::vector<LogicalLine> SynthExpander::expand() {
    std::vector<LogicalLine> out;

    for (auto const& line : lines) {
        auto m = recognize_synthetic(line);
        if (!m.matched) {
            out.push_back(line);
            continue;
        }
        interpret_synth_bytecode(m, line, out);
    }
    return out;
}

void SynthExpander::collect_label_tokens(ParseLine& pline,
        std::vector<Token>& out) {
    size_t pos0 = pline.pos;
    auto label = parse_label(pline);
    if (label) {
        out.insert(out.end(), pline.tokens.begin() + pos0,
                   pline.tokens.begin() + pline.pos);
    }
}

const TrieTransition* SynthExpander::binary_search_transition(size_t node,
        TrieToken key) {
    const TrieNode& nd = opcodes_synth_trie_nodes[node];

    size_t base = nd.first_transition;
    size_t count = nd.count;

    if (count == 0) {
        return nullptr;
    }

    const TrieTransition* begin = &opcodes_synth_trie_transitions[base];
    const TrieTransition* end = begin + count;

    // Early-out: key outside range
    if (key < begin->token || key > (end - 1)->token) {
        return nullptr;
    }

    // Use STL lower_bound
    auto it = std::lower_bound(
                  begin, end,
                  key,
    [](const TrieTransition & tr, TrieToken k) {
        return tr.token < k;
    }
              );

    if (it != end && it->token == key) {
        return it;
    }

    return nullptr;
}

SynthExpander::SynthMatch SynthExpander::recognize_synthetic(
    const LogicalLine& line) {
    ParseLine pline(line.tokens);
    SynthMatch res;
    size_t node = 0;
    const TrieTransition* tr = nullptr;

    // collect label tokens at the start of the line
    collect_label_tokens(pline, res.label_tokens);

    // first transition on CPU
    TrieToken cpu_tt = to_trie_token(synth_expander_cpu_id);
    tr = binary_search_transition(node, cpu_tt);
    if (!tr) {
        return res;    // no match
    }
    node = tr->next_node;

    // next transitions on tokens
    while (pline.pos < pline.tokens.size()) {
        const Token& token = pline.peek();
        if (token.type == TokenType::EndOfLine) {
            break;
        }

        // check keyword transition first
        if (token.keyword != Keyword::None) {
            TrieToken kw_tt = to_trie_token(token.keyword);
            tr = binary_search_transition(node, kw_tt);
            if (tr) {
                pline.advance();
                node = tr->next_node;
                continue;
            }
        }

        // then check token type transition
        TrieToken tt_tt = to_trie_token(token.type);
        tr = binary_search_transition(node, tt_tt);
        if (tr) {
            pline.advance();
            node = tr->next_node;
            continue;
        }

        // check for DispExpr transition, i.e. a '+' or '-' followed by an expression
        tr = binary_search_transition(node, TrieToken::DispExpr);
        if (tr) {
            size_t start = pline.pos;
            if (token.type != TokenType::Plus && token.type != TokenType::Minus) {
                return res;    // no match
            }
            // include the '+' or '-' in the expression span
            if (!parse_expr_span(pline)) {
                return res;    // no match
            }
            size_t end = pline.pos;
            if (end == start) {
                return res;    // no match
            }

            res.expr_spans.push_back({ start, end });
            node = tr->next_node;
            continue;
        }

        // finally check expression transition
        tr = binary_search_transition(node, TrieToken::Expr);
        if (tr) {
            size_t start = pline.pos;
            if (!parse_expr_span(pline)) {
                return res;    // no match
            }
            size_t end = pline.pos;
            if (end == start) {
                return res;    // no match
            }

            res.expr_spans.push_back({ start, end });
            node = tr->next_node;
            continue;
        }

        return res;    // no match
    }

    const TrieNode& n = opcodes_synth_trie_nodes[node];
    if (n.accept_id >= 0) {
        res.matched = true;
        res.accept_id = n.accept_id;
    }
    return res;
}

void SynthExpander::interpret_synth_bytecode(const SynthMatch& match,
        const LogicalLine& line, std::vector<LogicalLine>& out) {
    LogicalLine cur(line.loc);

    // copy label tokens
    cur.tokens.insert(cur.tokens.end(), match.label_tokens.begin(),
                      match.label_tokens.end());

    // create temporary labels as needed
    std::vector<HLA_Label> labels;

    // lambda to get location at end of current line
    auto get_end_loc = [&]() {
        SourceLoc loc;
        if (cur.tokens.empty()) {
            loc = line.loc;
        }
        else {
            loc = cur.tokens.back().loc;
            loc.column += static_cast<uint16_t>(g_strings.view(
                                                    cur.tokens.back().text_id).size());
        }
        return loc;
    };

    // find range of tokens for the expanded opcodes
    assert(match.accept_id >= 0);
    const TrieAction& ta = opcodes_synth_trie_actions[match.accept_id];
    for (size_t i = ta.first_bytecode; i < ta.first_bytecode + ta.count; i++) {
        const SynthBytecode& bc = opcodes_synth_trie_bytecode[i];

        switch (bc.op) {
        case SynthOp::EmitToken: {
            TrieToken trie_token = static_cast<TrieToken>(bc.operand);
            TokenType token_type = to_token_type(trie_token);
            if (token_type != TokenType::None) {
                Token t = Token::token(token_type, to_string(token_type), get_end_loc());
                cur.tokens.push_back(t);
            }
            else {
                Keyword kw = to_keyword(trie_token);
                if (kw != Keyword::None) {
                    Token t = Token::identifier(to_lower(to_string(kw)), get_end_loc());
                    cur.tokens.push_back(t);
                }
                else {
                    // Invalid trie token
                    assert(0);
                }
            }
            break;
        }
        case SynthOp::EmitInteger: {
            int value = bc.operand;
            Token t = Token::integer(std::to_string(value), value, get_end_loc());
            cur.tokens.push_back(t);
            break;
        }
        case SynthOp::EmitExprRef: {
            size_t expr_index = bc.operand;
            assert(expr_index < match.expr_spans.size());
            auto [start, end] = match.expr_spans[expr_index];
            for (size_t j = start; j < end; j++) {
                cur.tokens.push_back(line.tokens[j]);
            }
            break;
        }
        case SynthOp::EmitDispExprRef: {
            cur.tokens.push_back(Token::token(TokenType::Plus, "+", get_end_loc()));
            cur.tokens.push_back(Token::token(TokenType::LeftParen, "(", get_end_loc()));
            {
                size_t expr_index = bc.operand;
                assert(expr_index < match.expr_spans.size());
                auto [start, end] = match.expr_spans[expr_index];
                for (size_t j = start; j < end; j++) {
                    cur.tokens.push_back(line.tokens[j]);
                }
            }
            cur.tokens.push_back(Token::token(TokenType::RightParen, ")", get_end_loc()));
            break;
        }
        case SynthOp::EmitLabelRef: {
            // create temporary labels as needed
            size_t label_id = bc.operand;
            while (label_id >= labels.size()) {
                labels.emplace_back();
            }

            // emit label reference token
            Token t = Token::identifier(labels[label_id].to_string(), get_end_loc());
            cur.tokens.push_back(t);
            break;
        }
        case SynthOp::EmitLineBreak: {
            if (!cur.tokens.empty()) {
                cur.tokens.push_back(Token::end_of_line(get_end_loc()));
                out.push_back(cur);
                cur.tokens.clear();
            }
            break;
        }
        default:
            assert(0);
        }
    }

    // emit end of line
    if (!cur.tokens.empty()) {
        cur.tokens.push_back(Token::end_of_line(get_end_loc()));
        out.push_back(cur);
    }
}
