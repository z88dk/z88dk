//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "hla_ast.h"
#include "hla_builder.h"
#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "source_loc.h"
#include <cassert>
#include <memory>
#include <unordered_map>
#include <utility>
#include <vector>

// dispatch table for directives
std::unordered_map<Keyword, HLA_ProgramBuilder::DirectiveHandler>
HLA_ProgramBuilder::directive_handlers = {
    { Keyword::IF,       &HLA_ProgramBuilder::handle_if },
    { Keyword::ELIF,     &HLA_ProgramBuilder::handle_elseif },
    { Keyword::ELSEIF,   &HLA_ProgramBuilder::handle_elseif },
    { Keyword::ELSE,     &HLA_ProgramBuilder::handle_else },
    { Keyword::ENDIF,    &HLA_ProgramBuilder::handle_endif },
    { Keyword::WHILE,    &HLA_ProgramBuilder::handle_while },
    { Keyword::ENDWHILE, &HLA_ProgramBuilder::handle_endwhile },
    { Keyword::REPEAT,   &HLA_ProgramBuilder::handle_repeat },
    { Keyword::UNTIL,    &HLA_ProgramBuilder::handle_until },
    { Keyword::DJNZ,     &HLA_ProgramBuilder::handle_djnz },
    { Keyword::BREAK,    &HLA_ProgramBuilder::handle_break },
    { Keyword::CONTINUE, &HLA_ProgramBuilder::handle_continue },
};

// all HLA directives start with a '%' token, so we can use that to classify lines
bool HLA_ProgramBuilder::handle_directive(ParseLine& line) {
    if (line.peek().type != TokenType::Modulo) {
        return false;
    }
    line.pos++; // consume '%'

    Keyword kw = line.peek().keyword;
    SourceLoc kw_loc = line.peek().loc;

    if (!keyword_is_hla_directive(kw)) {
        return false;
    }

    line.pos++; // consume directive
    auto it = HLA_ProgramBuilder::directive_handlers.find(kw);
    if (it == HLA_ProgramBuilder::directive_handlers.end()) {
        g_diag.error(kw_loc, "Unsupported HLA directive: " + keyword_to_string(kw));
        return false;
    }

    // call handler method
    (this->*(it->second))(kw, kw_loc, line);
    return true;
}

std::unique_ptr<HLA_Program> HLA_ProgramBuilder::finish() {
    if (!stack.empty()) {
        auto node = stack.back().node;
        g_diag.error(node->loc,
                     "Unclosed HLA construct " + keyword_to_string(node->kw));
    }

    auto program = std::make_unique<HLA_Program>();
    program->nodes = std::move(root_body);
    return program;
}

void HLA_ProgramBuilder::handle_asm(ParseLine& line) {
    assert(!line.tokens.empty());

    SourceLoc loc = line.tokens.front().loc;

    LogicalLine ll(loc);
    ll.tokens = line.tokens;

    auto node = std::make_unique<HLA_Asm>();
    node->loc = loc;
    node->line = std::move(ll);

    current_body()->push_back(std::move(node));
}

std::vector<std::unique_ptr<HLA_Node>>* HLA_ProgramBuilder::current_body() {
    return stack.empty() ? &root_body : stack.back().body;
}

void HLA_ProgramBuilder::handle_if(Keyword kw, const SourceLoc& kw_loc,
                                   ParseLine& line) {
    auto condition = parse_condition(line);
    if (!condition) {
        return; // error already reported by parse_condition
    }
    if (!line.check_end_of_line(kw)) {
        return; // error already reported by check_end_of_line
    }

    auto node = std::make_unique<HLA_If>();
    node->kw = kw;
    node->loc = kw_loc;

    HLA_If::Branch branch;
    branch.loc = kw_loc;
    branch.condition = std::move(condition);
    node->branches.push_back(std::move(branch));

    auto* body = &node->branches.back().body; // pointer to the body of the first branch

    auto* node_ptr = node.get();                            // save before move
    current_body()->push_back(std::move(node));             // transfer ownership

    BlockContext ctx{ node_ptr, body };
    stack.push_back(std::move(ctx)); // push new block context
}

void HLA_ProgramBuilder::handle_elseif(Keyword kw, const SourceLoc& kw_loc,
                                       ParseLine& line) {
    if (stack.empty() || !stack.back().node->is_if()) {
        g_diag.error(kw_loc, keyword_to_string(kw) + " without IF");
        return;
    }

    auto node = dynamic_cast<HLA_If*>(stack.back().node);
    assert(node);
    if (node->found_else) {
        g_diag.error(kw_loc, keyword_to_string(kw) + " invalid after ELSE");
        g_diag.note(node->else_loc, "ELSE definition");
        return;
    }

    auto condition = parse_condition(line);
    if (!condition) {
        return; // error already reported by parse_condition
    }
    if (!line.check_end_of_line(kw)) {
        return; // error already reported by check_end_of_line
    }

    HLA_If::Branch branch;
    branch.loc = kw_loc;
    branch.condition = std::move(condition);
    node->branches.push_back(std::move(branch));

    auto* body = &node->branches.back().body; // pointer to the body of the first branch
    stack.back().body = body;
}

void HLA_ProgramBuilder::handle_else(Keyword kw, const SourceLoc& kw_loc,
                                     ParseLine& line) {
    if (stack.empty() || !stack.back().node->is_if()) {
        g_diag.error(kw_loc, keyword_to_string(kw) + " without IF");
        return;
    }
    if (!line.check_end_of_line(kw)) {
        return; // error already reported by check_end_of_line
    }

    auto node = dynamic_cast<HLA_If*>(stack.back().node);
    assert(node);
    if (node->found_else) {
        g_diag.error(kw_loc, keyword_to_string(kw) + " already defined");
        g_diag.note(node->else_loc, "Previous definition");
        return;
    }
    node->found_else = true;
    node->else_loc = kw_loc;
    stack.back().body = &node->else_body; // switch to else body
}

void HLA_ProgramBuilder::handle_endif(Keyword kw, const SourceLoc& kw_loc,
                                      ParseLine& line) {
    if (stack.empty() || !stack.back().node->is_if()) {
        g_diag.error(kw_loc, keyword_to_string(kw) + " without IF");
        return;
    }

    if (!line.check_end_of_line(kw)) {
        return; // error already reported by check_end_of_line
    }

    stack.pop_back();
}

void HLA_ProgramBuilder::handle_while(Keyword kw, const SourceLoc& kw_loc,
                                      ParseLine& line) {
    auto condition = parse_condition(line);
    if (!condition) {
        return; // error already reported by parse_condition
    }

    if (!line.check_end_of_line(kw)) {
        return; // error already reported by check_end_of_line
    }

    auto node = std::make_unique<HLA_While>();
    node->kw = kw;
    node->loc = kw_loc;
    node->condition = std::move(condition);
    auto* body = &node->body;

    auto* node_ptr = node.get();                            // save before move
    current_body()->push_back(std::move(node));             // transfer ownership

    BlockContext ctx{ node_ptr, body };
    stack.push_back(std::move(ctx)); // push new block context
}

void HLA_ProgramBuilder::handle_endwhile(Keyword kw, const SourceLoc& kw_loc,
        ParseLine& line) {
    if (stack.empty() || !stack.back().node->is_while()) {
        g_diag.error(kw_loc, keyword_to_string(kw) + " without WHILE");
        return;
    }

    if (!line.check_end_of_line(kw)) {
        return; // error already reported by check_end_of_line
    }

    stack.pop_back();
}

void HLA_ProgramBuilder::handle_repeat(Keyword kw, const SourceLoc& kw_loc,
                                       ParseLine& line) {
    if (!line.check_end_of_line(kw)) {
        return; // error already reported by check_end_of_line
    }

    auto node = std::make_unique<HLA_Repeat>();
    node->kw = kw;
    node->loc = kw_loc;
    auto* body = &node->body;

    auto* node_ptr = node.get();                            // save before move
    current_body()->push_back(std::move(node));             // transfer ownership

    BlockContext ctx{ node_ptr, body };
    stack.push_back(std::move(ctx)); // push new block context
}

void HLA_ProgramBuilder::handle_until(Keyword kw, const SourceLoc& kw_loc,
                                      ParseLine& line) {
    if (stack.empty() || !stack.back().node->is_repeat()) {
        g_diag.error(kw_loc, keyword_to_string(kw) + " without REPEAT");
        return;
    }

    auto condition = parse_condition(line);
    if (!condition) {
        return; // error already reported by parse_condition
    }

    if (!line.check_end_of_line(kw)) {
        return; // error already reported by check_end_of_line
    }

    auto node = dynamic_cast<HLA_Repeat*>(stack.back().node);
    assert(node);
    node->type = RepeatType::UntilExpr;
    node->condition = std::move(condition);

    stack.pop_back(); // close REPEAT block
}

void HLA_ProgramBuilder::handle_djnz(Keyword kw, const SourceLoc& kw_loc,
                                     ParseLine& line) {
    if (stack.empty() || !stack.back().node->is_repeat()) {
        g_diag.error(kw_loc, keyword_to_string(kw) + " without REPEAT");
        return;
    }

    if (line.peek().type != TokenType::Identifier) {
        line.error("Expected register after DJNZ");
        return;
    }

    if (!keyword_is_hla_djnz_register(line.peek().keyword)) {
        line.error("Invalid register for " + keyword_to_string(kw));
        return;
    }

    Keyword reg_kw = line.peek().keyword;
    line.pos++;

    if (!line.check_end_of_line(kw)) {
        return; // error already reported by check_end_of_line
    }

    auto node = dynamic_cast<HLA_Repeat*>(stack.back().node);
    assert(node);
    node->type = RepeatType::DjnzReg;
    node->reg_kw = reg_kw;

    stack.pop_back(); // close REPEAT block
}

void HLA_ProgramBuilder::handle_break(Keyword kw, const SourceLoc& kw_loc,
                                      ParseLine& line) {
    if (stack.empty() || !stack.back().node->is_loop()) {
        g_diag.error(kw_loc, keyword_to_string(kw) + " without WHILE or REPEAT");
        return;
    }

    auto node = std::make_unique<HLA_Break>();
    node->kw = kw;
    node->loc = kw_loc;

    // Check for optional IF condition
    if (line.peek().keyword == Keyword::IF) {
        line.pos++; // consume IF
        node->condition = parse_condition(line);
        if (!node->condition) {
            return; // error already reported by parse_condition
        }
    }

    if (!line.check_end_of_line(kw)) {
        return; // error already reported by check_end_of_line
    }

    current_body()->push_back(std::move(node));             // transfer ownership
}

void HLA_ProgramBuilder::handle_continue(Keyword kw, const SourceLoc& kw_loc,
        ParseLine& line) {
    if (stack.empty() || !stack.back().node->is_loop()) {
        g_diag.error(kw_loc, keyword_to_string(kw) + " without WHILE or REPEAT");
        return;
    }

    auto node = std::make_unique<HLA_Continue>();
    node->kw = kw;
    node->loc = kw_loc;

    // Check for optional IF condition
    if (line.peek().keyword == Keyword::IF) {
        line.pos++; // consume IF
        node->condition = parse_condition(line);
        if (!node->condition) {
            return; // error already reported by parse_condition
        }
    }

    if (!line.check_end_of_line(kw)) {
        return; // error already reported by check_end_of_line
    }

    current_body()->push_back(std::move(node));             // transfer ownership
}

std::unique_ptr<HLA_Expr> HLA_ProgramBuilder::parse_condition(ParseLine& line) {
    return parse_or(line);
}

std::unique_ptr<HLA_Expr> HLA_ProgramBuilder::parse_or(ParseLine& line) {
    auto left = parse_and(line);
    if (!left) {
        return nullptr;
    }
    while (line.peek().type == TokenType::LogicalOr) {
        line.pos++; // consume '||'
        auto right = parse_and(line);
        if (!right) {
            return nullptr;
        }
        auto node = std::make_unique<HLA_OrExpr>();
        node->loc = left->loc;
        node->left = std::move(left);
        node->right = std::move(right);
        left = std::move(node);
    }
    return left;
}

std::unique_ptr<HLA_Expr> HLA_ProgramBuilder::parse_and(ParseLine& line) {
    auto left = parse_not(line);
    if (!left) {
        return nullptr;
    }
    while (line.peek().type == TokenType::LogicalAnd) {
        line.pos++; // consume '&&'
        auto right = parse_not(line);
        if (!right) {
            return nullptr;
        }
        auto node = std::make_unique<HLA_AndExpr>();
        node->loc = left->loc;
        node->left = std::move(left);
        node->right = std::move(right);
        left = std::move(node);
    }
    return left;
}

std::unique_ptr<HLA_Expr> HLA_ProgramBuilder::parse_not(ParseLine& line) {
    if (line.peek().type == TokenType::LogicalNot) {
        line.pos++; // consume '!'
        auto child = parse_not(line);
        if (!child) {
            return nullptr;
        }
        auto node = std::make_unique<HLA_NotExpr>();
        node->loc = child->loc;
        node->child = std::move(child);
        return node;
    }

    return parse_primary(line);
}

std::unique_ptr<HLA_Expr> HLA_ProgramBuilder::parse_primary(ParseLine& line) {
    if (line.peek().keyword == Keyword::TRUE) {
        auto node = std::make_unique<HLA_True>();
        node->loc = line.peek().loc;
        line.pos++;
        return node;
    }

    if (line.peek().keyword == Keyword::FALSE) {
        auto node = std::make_unique<HLA_False>();
        node->loc = line.peek().loc;
        line.pos++;
        return node;
    }

    // we need to look-ahead to distinguish C - carry flag from C - register
    // C > 4 is register; C && Z is flag
    if (keyword_is_flag(line.peek().keyword) &&
            !is_compare_operator(line.peek(1))) {
        auto node = std::make_unique<HLA_FlagExpr>();
        node->loc = line.peek().loc;
        node->flag_token = line.peek();
        line.pos++;
        return node;
    }

    if (keyword_is_register(line.peek().keyword) ||
            line.peek().keyword == Keyword::MEM) {
        auto node = parse_comparison(line);
        return node;
    }

    if (line.peek().type == TokenType::LeftParen) {
        line.pos++; // consume '('
        auto node = parse_condition(line);
        if (!node) {
            return nullptr;
        }
        if (line.peek().type != TokenType::RightParen) {
            line.error("Expected ')'");
            return nullptr;
        }
        line.pos++; // consume ')'
        return node;
    }

    line.error("Unexpected token in condition: " +
               g_strings.to_string(line.peek().text_id));
    return nullptr;
}

std::unique_ptr<HLA_Expr> HLA_ProgramBuilder::parse_comparison(ParseLine& line) {
    auto node = std::make_unique<HLA_CompareExpr>();

    // get left hand side
    node->loc = line.peek().loc;
    node->left = collect_operand_tokens(line);
    if (node->left.empty()) {
        line.error("Expected expression");
        return nullptr;
    }

    // get comparison operator
    if (line.peek().type == TokenType::LT) {
        node->op = HLA_CompareExpr::Type::UnsignedLT;
        line.pos++;
    }
    else if (line.peek().type == TokenType::LE) {
        node->op = HLA_CompareExpr::Type::UnsignedLE;
        line.pos++;
    }
    else if (line.peek().type == TokenType::GT) {
        node->op = HLA_CompareExpr::Type::UnsignedGT;
        line.pos++;
    }
    else if (line.peek().type == TokenType::GE) {
        node->op = HLA_CompareExpr::Type::UnsignedGE;
        line.pos++;
    }
    else if (line.peek().keyword == Keyword::S &&
             line.peek(1).type == TokenType::LT) {
        node->op = HLA_CompareExpr::Type::SignedLT;
        line.pos += 2;
    }
    else if (line.peek().keyword == Keyword::S &&
             line.peek(1).type == TokenType::LE) {
        node->op = HLA_CompareExpr::Type::SignedLE;
        line.pos += 2;
    }
    else if (line.peek().keyword == Keyword::S &&
             line.peek(1).type == TokenType::GT) {
        node->op = HLA_CompareExpr::Type::SignedGT;
        line.pos += 2;
    }
    else if (line.peek().keyword == Keyword::S &&
             line.peek(1).type == TokenType::GE) {
        node->op = HLA_CompareExpr::Type::SignedGE;
        line.pos += 2;
    }
    else if (line.peek().type == TokenType::EQ) {
        node->op = HLA_CompareExpr::Type::EQ;
        line.pos++;
    }
    else if (line.peek().type == TokenType::NE) {
        node->op = HLA_CompareExpr::Type::NE;
        line.pos++;
    }
    else {
        line.error("Invalid comparison operator: " +
                   g_strings.to_string(line.peek().text_id));
        return nullptr;
    }

    // get right hand side
    node->right = collect_operand_tokens(line);
    if (node->right.empty()) {
        line.error("Expected expression");
        return nullptr;
    }

    return node;
}

std::vector<Token> HLA_ProgramBuilder::collect_operand_tokens(
    ParseLine& line)const {

    std::vector<Token> tokens;
    int depth = 0;

    while (line.peek().type != TokenType::EndOfLine) {
        const Token& tok = line.peek();

        // Check for stopping conditions (excluding these tokens)
        if (is_compare_operator(tok)) {
            break;
        }

        // Track parentheses depth
        if (tok.type == TokenType::LeftParen) {
            depth++;
        }
        else if (tok.type == TokenType::RightParen) {
            depth--;
            // Stop before depth becomes negative
            if (depth < 0) {
                break;
            }
        }

        if (tok.keyword == Keyword::MEM) {  // MEM(hl) for indirect memory access
            line.pos++;
            continue;
        }

        tokens.push_back(tok);
        line.pos++;
    }

    return tokens;
}

bool HLA_ProgramBuilder::is_compare_operator(const Token& tok) const {
    return tok.type == TokenType::LT ||
           tok.type == TokenType::LE ||
           tok.type == TokenType::GT ||
           tok.type == TokenType::GE ||
           tok.type == TokenType::EQ ||
           tok.type == TokenType::NE ||
           tok.keyword == Keyword::S;
}
