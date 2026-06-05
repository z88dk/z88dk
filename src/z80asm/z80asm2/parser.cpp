//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "expr.h"
#include "lexer_tokens.h"
#include "opcodes.h"
#include "opcodes_parse_trie.h"
#include "opcodes_trie_token.h"
#include "options.h"
#include "parser.h"
#include "source_loc.h"
#include <algorithm>
#include <cassert>
#include <cstdint>
#include <memory>
#include <utility>
#include <vector>

std::unique_ptr<LabelStmt> parse_label(ParseLine& pline) {
    // .label
    if (pline.peek().type == TokenType::Dot
            && pline.peek(1).type == TokenType::Identifier) {
        auto label = std::make_unique<LabelStmt>(pline.peek(1).text_id,
                     pline.peek().loc);
        pline.advance();
        pline.advance();
        return label;
    }

    // .label@local
    if (pline.peek().type == TokenType::Dot
            && pline.peek(1).type == TokenType::LocalLabel) {
        auto label = std::make_unique<LabelStmt>(pline.peek(1).text_id,
                     pline.peek().loc);
        label->is_local = true;
        label->at_pos = pline.peek(1).value.label_at_pos;
        pline.advance();
        pline.advance();
        return label;
    }

    // label:
    if (pline.peek().type == TokenType::Identifier
            && pline.peek(1).type == TokenType::Colon) {
        auto label = std::make_unique<LabelStmt>(pline.peek().text_id,
                     pline.peek().loc);
        pline.advance();
        pline.advance();
        return label;
    }

    // label@local:
    if (pline.peek().type == TokenType::LocalLabel
            && pline.peek(1).type == TokenType::Colon) {
        auto label = std::make_unique<LabelStmt>(pline.peek().text_id,
                     pline.peek().loc);
        label->is_local = true;
        label->at_pos = pline.peek().value.label_at_pos;
        pline.advance();
        pline.advance();
        return label;
    }

    return nullptr;
}

Parser::Parser(const std::vector<LogicalLine>& asm_lines_)
    : parser_cpu_id(g_args.options.cpu_id), asm_lines(asm_lines_) {
}

std::unique_ptr<Program> Parser::parse() {
    auto prog = std::make_unique<Program>();
    for (line_idx = 0; line_idx < asm_lines.size(); line_idx++) {
        parse_line(prog);
    }
    return prog;
}

const TrieTransition* Parser::binary_search_transition(size_t node,
        TrieToken key) {
    const TrieNode& nd = opcodes_parse_trie_nodes[node];

    size_t base = nd.first_transition;
    size_t count = nd.count;

    if (count == 0) {
        return nullptr;
    }

    const TrieTransition* begin = &opcodes_parse_trie_transitions[base];
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

Parser::OpcodesMatch Parser::recognize_opcode(ParseLine& pline,
        ParseStatus& status) {
    OpcodesMatch res;
    size_t node = 0;
    const TrieTransition* tr = nullptr;
    status = ParseStatus::Unknown;

    // backtracking stack for handling multiple possible transitions
    std::vector<ChoicePoint> backtrack_stack;

    // label already collected in parse_line - skipped

    // first transition on CPU
    TrieToken cpu_tt = to_trie_token(parser_cpu_id);
    tr = binary_search_transition(node, cpu_tt);
    if (!tr) {
        return res;    // no match
    }
    node = tr->next_node;

    // next transitions on tokens
next_transition:
    while (pline.pos < pline.tokens.size()) {
        const Token& token = pline.peek();

        // Early acceptance: if we consumed all tokens, break and check accept state.
        if (token.type == TokenType::EndOfLine) {
            break;
        }

        // enumerate all possible transitions from this node
        // and add them to the backtracking stack in the reverse order
        // we want to try them
        // priority: keyword > token > DispExpr > Expr
        tr = binary_search_transition(node, TrieToken::Expr);
        if (tr) {
            backtrack_stack.push_back({
                ChoicePoint::Type::Expr,
                node, pline.pos, tr, res.exprs.size() });
        };

        tr = binary_search_transition(node, TrieToken::DispExpr);
        if (tr &&
                (token.type == TokenType::Plus || token.type == TokenType::Minus)) {
            backtrack_stack.push_back({
                ChoicePoint::Type::Expr,
                node, pline.pos, tr, res.exprs.size() });
        }

        TrieToken tt_tt = to_trie_token(token.type);
        tr = binary_search_transition(node, tt_tt);
        if (tr) {
            backtrack_stack.push_back({
                ChoicePoint::Type::Token,
                node, pline.pos, tr, res.exprs.size() });
        }

        if (token.keyword != Keyword::None) {
            TrieToken kw_tt = to_trie_token(token.keyword);
            tr = binary_search_transition(node, kw_tt);
            if (tr) {
                backtrack_stack.push_back({
                    ChoicePoint::Type::Token,
                    node, pline.pos, tr, res.exprs.size() });
            }
        }

        // otherwise, pop the next choice point and try it
        while (!backtrack_stack.empty()) {
            ChoicePoint cp = backtrack_stack.back();
            backtrack_stack.pop_back();

            node = cp.node;
            pline.pos = cp.token_pos;
            tr = cp.transition;
            assert(res.exprs.size() >= cp.expr_count);
            while (res.exprs.size() > cp.expr_count) {
                res.exprs.pop_back();
            }

            switch (cp.type) {
            case ChoicePoint::Type::Token:
                pline.advance();
                node = tr->next_node;
                goto next_transition;

            case ChoicePoint::Type::Expr: {
                size_t start = pline.pos;
                auto expr = parse_expression_ast(pline, status);
                if (status == ParseStatus::FatalError) {
                    return res;    // stop immediately on error
                }

                if (!expr) {
                    continue;   // backtrack
                }

                size_t end = pline.pos;
                if (end == start) {
                    continue;   // backtrack
                }

                res.exprs.push_back(std::move(expr));
                node = tr->next_node;
                goto next_transition;
            }
            default:
                assert(0);
            }
        }

        // if the stack is empty, no possible transitions - fail
        if (backtrack_stack.empty()) {
            return res;    // no match
        }
    }

    const TrieNode& n = opcodes_parse_trie_nodes[node];
    if (n.accept_id >= 0) {
        res.matched = true;
        res.accept_id = n.accept_id;
    }
    return res;
}

std::unique_ptr<OpcodeStmt> Parser::interpret_parse_bytecode(
    OpcodesMatch& match, const SourceLoc& loc) {
    auto opcode_stmt = std::make_unique<OpcodeStmt>(loc);

    // find range of tokens for the expanded opcodes
    assert(match.accept_id >= 0);
    const TrieAction& ta = opcodes_parse_trie_actions[match.accept_id];
    for (size_t i = ta.first_bytecode; i < ta.first_bytecode + ta.count; i++) {
        uint8_t bc = opcodes_parse_trie_bytecode[i];

        switch (bc) {
        case static_cast<uint8_t>(OpcodesOp::Bytes): {
            size_t size = opcodes_parse_trie_bytecode[++i];
            for (size_t j = 0; j < size; j++) {
                uint8_t byte = opcodes_parse_trie_bytecode[++i];
                opcode_stmt->bytes.push_back(byte);
            }
            break;
        }
        case static_cast<uint8_t>(OpcodesOp::ExprConst): {
            // create a Patch
            assert(!match.exprs.empty());
            auto expr = std::move(match.exprs.front());
            match.exprs.erase(match.exprs.begin());
            auto patch = std::make_unique<Patch>(std::move(expr), loc);

            // load data
            patch->offset = opcodes_parse_trie_bytecode[++i];
            patch->size = opcodes_parse_trie_bytecode[++i];
            patch->is_constant = true;
            patch->type = PatchType::Unsigned;
            patch->validation = static_cast<CheckRange>(opcodes_parse_trie_bytecode[++i]);
            patch->formula = static_cast<ExprFormula>(opcodes_parse_trie_bytecode[++i]);

            // load coeficients
            switch (patch->formula) {
            case ExprFormula::None:
                break;
            case ExprFormula::ScaleBelowThreshold:
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // A
                break;
            case ExprFormula::AddScaled:
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // A
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // B
                break;
            case ExprFormula::SelectOrAdd:
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // A
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // B
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // C
                break;
            case ExprFormula::Select2:
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // A
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // B
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // C
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // D
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // E
                break;
            case ExprFormula::Select3:
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // A
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // B
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // C
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // D
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // E
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // F
                patch->coefs.push_back(opcodes_parse_trie_bytecode[++i]); // G
                break;
            default:
                assert(0);
            }

            opcode_stmt->patches.push_back(std::move(patch));
            break;
        }
        case static_cast<uint8_t>(OpcodesOp::ExprPatch): {
            // create a Patch
            assert(!match.exprs.empty());
            auto expr = std::move(match.exprs.front());
            match.exprs.erase(match.exprs.begin());
            auto patch = std::make_unique<Patch>(std::move(expr), loc);

            // load data
            patch->offset = opcodes_parse_trie_bytecode[++i];
            patch->size = opcodes_parse_trie_bytecode[++i];
            patch->is_constant = false;
            patch->type = static_cast<PatchType>(opcodes_parse_trie_bytecode[++i]);
            patch->validation = CheckRange::Is_any;
            patch->formula = ExprFormula::None;

            opcode_stmt->patches.push_back(std::move(patch));
            break;
        }
        case static_cast<uint8_t>(OpcodesOp::AltJpOpcode): {
            // update the last patch
            assert(!opcode_stmt->patches.empty());
            auto& patch = opcode_stmt->patches.back();
            assert(patch->type == PatchType::PCrelative);

            // load alternative data
            if (patch->size == 1) {
                opcode_stmt->is_short_jump = true;
            }
            size_t alt_size = opcodes_parse_trie_bytecode[++i];
            for (size_t j = 0; j < alt_size; j++) {
                uint8_t alt_byte = opcodes_parse_trie_bytecode[++i];
                patch->alt_bytes.push_back(alt_byte);
            }
            patch->alt_offset = opcodes_parse_trie_bytecode[++i];
            patch->alt_size = opcodes_parse_trie_bytecode[++i];
            break;
        }
        default:
            assert(0);
        }
    }

    return opcode_stmt;
}

std::unique_ptr<OpcodeStmt> Parser::parse_opcode(ParseLine& pline,
        const SourceLoc& loc, ParseStatus& status) {
    auto m = recognize_opcode(pline, status);
    if (!m.matched) {
        return nullptr;
    }
    auto opcode_stmt = interpret_parse_bytecode(m, loc);
    return opcode_stmt;
}

void Parser::parse_line(std::unique_ptr<Program>& prog) {
    ParseLine pline(asm_lines[line_idx].tokens);
    ParseStatus status = ParseStatus::Unknown;

    // skip empty lines
    if (pline.eol()) {
        return;
    }

    // check for label
    auto label = parse_label(pline);
    if (label) {
        prog->stmts.push_back(std::move(label));
    }
    size_t pos0 = pline.pos;

    // if line has only a label, we're done
    if (pline.eol()) {
        return;
    }

    // check for directives
    pline.pos = pos0;
    status = ParseStatus::Unknown;
    auto dir_stmt = parse_directive(pline, asm_lines[line_idx].loc, status);
    if (status == ParseStatus::FatalError) {
        return;
    }

    if (dir_stmt) {
        prog->stmts.push_back(std::move(dir_stmt));
        return;
    }

    if (status == ParseStatus::Ok) {
        return; // directive parsed successfully but returned nullptr, done with this line
    }

    // check for opcode
    pline.pos = pos0;
    status = ParseStatus::Unknown;
    auto opcode_stmt = parse_opcode(pline, asm_lines[line_idx].loc, status);
    if (status == ParseStatus::FatalError) {
        return;
    }
    if (!opcode_stmt) {
        pline.error("Unrecognized instruction or directive");
        return;
    }

    pline.check_end_of_line();
    prog->stmts.push_back(std::move(opcode_stmt));
}
