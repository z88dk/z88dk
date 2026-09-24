//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "emit_basic.h"
#include "errors.h"
#include "lexer.h"
#include "parser.h"
#include "preproc.h"
#include "release_assert.h"
#include "simplify_expr.h"
#include "walker.h"
#include <cmath>
#include <vector>

static constexpr double kPi = 3.14159265358979323846;

// recursively fold constants in the expression tree
static ExprPtr fold_constants(ExprPtr expr) {
    if (!expr) {
        return nullptr;
    }

    if (auto array_ref_expr = dynamic_cast<ArrayRefExpr*>(expr.get())) {
        for (auto& index : array_ref_expr->indices) {
            index = fold_constants(std::move(index));
        }
        return expr;
    }

    if (auto slice_expr = dynamic_cast<SliceExpr*>(expr.get())) {
        slice_expr->base = fold_constants(std::move(slice_expr->base));
        slice_expr->from = fold_constants(std::move(slice_expr->from));
        slice_expr->to = fold_constants(std::move(slice_expr->to));
        return expr;
    }

    if (auto unary_expr = dynamic_cast<UnaryExpr*>(expr.get())) {
        unary_expr->operand = fold_constants(std::move(unary_expr->operand));
        // if the operand is a number, we can evaluate the expression
        if (auto operand_num = dynamic_cast<NumberExpr*>(unary_expr->operand.get())) {
            double result = 0.0;
            switch (unary_expr->op) {
            case TokenType::Minus:
                result = -operand_num->value;
                break;
            case TokenType::NOT:
                result = !operand_num->value;
                break;
            default:
                return expr;  // unsupported operation
            }
            return make_node<NumberExpr>(result, expr->loc);
        }

        // fold double negation: - - A -> A, NOT NOT A -> A
        if (auto operand_unary_expr = dynamic_cast<UnaryExpr*>
                                      (unary_expr->operand.get())) {
            if (unary_expr->op == operand_unary_expr->op &&
                    (unary_expr->op == TokenType::Minus || unary_expr->op == TokenType::NOT)) {
                return std::move(operand_unary_expr->operand);
            }
        }

        // if the operator is NOT and operand is a comparison, invert the comparison
        if (auto operand_binary_expr = dynamic_cast<BinaryExpr*>
                                       (unary_expr->operand.get())) {
            if (unary_expr->op == TokenType::NOT) {
                TokenType not_op;
                switch (operand_binary_expr->op) {
                case TokenType::Equal:
                    not_op = TokenType::NotEqual;
                    break;
                case TokenType::NotEqual:
                    not_op = TokenType::Equal;
                    break;
                case TokenType::Less:
                    not_op = TokenType::GreaterEqual;
                    break;
                case TokenType::LessEqual:
                    not_op = TokenType::Greater;
                    break;
                case TokenType::Greater:
                    not_op = TokenType::LessEqual;
                    break;
                case TokenType::GreaterEqual:
                    not_op = TokenType::Less;
                    break;
                default:
                    return expr;
                }
                return make_node<BinaryExpr>(not_op,
                                             std::move(operand_binary_expr->lhs),
                                             std::move(operand_binary_expr->rhs),
                                             expr->loc);
            }
        }
        return expr;    // unsuported
    }

    if (auto binary_expr = dynamic_cast<BinaryExpr*>(expr.get())) {
        binary_expr->lhs = fold_constants(std::move(binary_expr->lhs));
        binary_expr->rhs = fold_constants(std::move(binary_expr->rhs));

        // if both sides are numbers, we can evaluate the expression
        if (auto lhs_num = dynamic_cast<NumberExpr*>(binary_expr->lhs.get())) {
            if (auto rhs_num = dynamic_cast<NumberExpr*>(binary_expr->rhs.get())) {
                double result = 0.0;
                switch (binary_expr->op) {
                case TokenType::Plus:
                    result = lhs_num->value + rhs_num->value;
                    break;
                case TokenType::Minus:
                    result = lhs_num->value - rhs_num->value;
                    break;
                case TokenType::Multiply:
                    result = lhs_num->value * rhs_num->value;
                    break;
                case TokenType::Divide:
                    result = lhs_num->value / rhs_num->value;
                    break;
                case TokenType::Power:
                    result = pow(lhs_num->value, rhs_num->value);
                    break;
                case TokenType::AND:
                    result = lhs_num->value && rhs_num->value;
                    break;
                case TokenType::OR:
                    result = lhs_num->value || rhs_num->value;
                    break;
                case TokenType::Equal:
                    result = lhs_num->value == rhs_num->value;
                    break;
                case TokenType::NotEqual:
                    result = lhs_num->value != rhs_num->value;
                    break;
                case TokenType::Less:
                    result = lhs_num->value < rhs_num->value;
                    break;
                case TokenType::LessEqual:
                    result = lhs_num->value <= rhs_num->value;
                    break;
                case TokenType::Greater:
                    result = lhs_num->value > rhs_num->value;
                    break;
                case TokenType::GreaterEqual:
                    result = lhs_num->value >= rhs_num->value;
                    break;
                default:
                    return expr;  // unsupported operation
                }
                return make_node<NumberExpr>(result, expr->loc);
            }
        }

        // fold identity operations: 0+A, A+0, 1*A, A*1 -> A
        if (auto lhs_num = dynamic_cast<NumberExpr*>(binary_expr->lhs.get())) {
            if (binary_expr->op == TokenType::Plus && lhs_num->value == 0.0) {
                return std::move(binary_expr->rhs);
            }
            if (binary_expr->op == TokenType::Multiply && lhs_num->value == 1.0) {
                return std::move(binary_expr->rhs);
            }
        }
        if (auto rhs_num = dynamic_cast<NumberExpr*>(binary_expr->rhs.get())) {
            if ((binary_expr->op == TokenType::Plus || binary_expr->op == TokenType::Minus)
                    && rhs_num->value == 0.0) {
                return std::move(binary_expr->lhs);
            }
            if (binary_expr->op == TokenType::Multiply && rhs_num->value == 1.0) {
                return std::move(binary_expr->lhs);
            }
        }
    }

    if (auto func_call_expr = dynamic_cast<BasicFuncCallExpr*>(expr.get())) {
        for (auto& arg : func_call_expr->args) {
            arg = fold_constants(std::move(arg));
        }

        if (func_call_expr->args.size() == 0) {
            switch (func_call_expr->keyword) {
            case Keyword::PI:
                return make_node<NumberExpr>(kPi, expr->loc);
            default:
                return expr;
            }
        }

        if (func_call_expr->args.size() == 1) {
            // if the operand is a number, we can evaluate the expression
            if (auto operand_num = dynamic_cast<NumberExpr*>
                                   (func_call_expr->args[0].get())) {
                double result = 0.0;
                switch (func_call_expr->keyword) {
                case Keyword::SIN:
                    result = sin(operand_num->value);
                    break;
                case Keyword::COS:
                    result = cos(operand_num->value);
                    break;
                case Keyword::TAN:
                    result = tan(operand_num->value);
                    break;
                case Keyword::ASN:
                    result = asin(operand_num->value);
                    break;
                case Keyword::ACS:
                    result = acos(operand_num->value);
                    break;
                case Keyword::ATN:
                    result = atan(operand_num->value);
                    break;
                case Keyword::LN:
                    result = log(operand_num->value);
                    break;
                case Keyword::EXP:
                    result = exp(operand_num->value);
                    break;
                case Keyword::INT:
                    result = floor(operand_num->value);
                    break;
                case Keyword::SQR:
                    result = sqrt(operand_num->value);
                    break;
                case Keyword::SGN:
                    result = (operand_num->value > 0) - (operand_num->value < 0);
                    break;
                case Keyword::ABS:
                    result = fabs(operand_num->value);
                    break;
                default:
                    return expr;
                }
                return make_node<NumberExpr>(result, expr->loc);
            }
        }
    }

    if (auto proc_call_expr = dynamic_cast<ProcCallExpr*>(expr.get())) {
        for (auto& arg : proc_call_expr->args) {
            arg = fold_constants(std::move(arg));
        }
        return expr;
    }

    if (auto fn_call_expr = dynamic_cast<FnCallExpr*>(expr.get())) {
        for (auto& arg : fn_call_expr->args) {
            arg = fold_constants(std::move(arg));
        }
        return expr;
    }

    return expr;  // return the original expression if no folding was done
}

static void simplify_stmt(Parser& parser, std::vector<Token>& out_tokens) {
    auto& tok = parser.peek();
    switch (tok.keyword) {
    case Keyword::LET: {
        out_tokens.push_back(tok);  // keep the LET keyword
        parser.pos++;  // consume the LET keyword

        auto lhs = parser.parse_assignable();
        lhs = fold_constants(std::move(lhs));
        emit_expr(out_tokens, *lhs, lhs->loc);

        auto& equal_tok = parser.expect(TokenType::Equal);
        out_tokens.push_back(equal_tok);  // keep the '=' token

        auto rhs = parser.parse_expr();
        rhs = fold_constants(std::move(rhs));
        emit_expr(out_tokens, *rhs, rhs->loc);

        release_assert(parser.at_end());
        break;
    }
    case Keyword::DIM: {
        out_tokens.push_back(tok);  // keep the DIM keyword
        parser.pos++;  // consume the DIM keyword

        auto& var_tok = parser.expect(TokenType::Identifier);
        out_tokens.push_back(var_tok);  // keep the variable name

        auto& left_paren_tok = parser.expect(TokenType::LeftParen);
        out_tokens.push_back(left_paren_tok);  // keep the '(' token

        while (true) {
            auto dim_expr = parser.parse_expr();
            dim_expr = fold_constants(std::move(dim_expr));
            emit_expr(out_tokens, *dim_expr, dim_expr->loc);

            if (parser.peek().type == TokenType::RightParen) {
                break;
            }
            else {
                auto& comma_tok = parser.expect(TokenType::Comma);
                out_tokens.push_back(comma_tok);  // keep the ',' token
            }
        }
        auto& right_paren_tok = parser.expect(TokenType::RightParen);
        out_tokens.push_back(right_paren_tok);  // keep the ')' token

        release_assert(parser.at_end());
        break;
    }
    case Keyword::IF: {
        out_tokens.push_back(tok);  // keep the IF keyword
        parser.pos++;  // consume the IF keyword

        auto condition_expr = parser.parse_expr();
        condition_expr = fold_constants(std::move(condition_expr));
        emit_expr(out_tokens, *condition_expr, condition_expr->loc);

        auto& then_tok = parser.expect(Keyword::THEN);
        out_tokens.push_back(then_tok);  // keep the THEN keyword

        simplify_stmt(parser, out_tokens);  // recursively simplify the THEN statement

        release_assert(parser.at_end());
        break;
    }
    case Keyword::FOR: {
        out_tokens.push_back(tok);  // keep the FOR keyword
        parser.pos++;  // consume the FOR keyword

        auto& var_tok = parser.expect(TokenType::Identifier);
        out_tokens.push_back(var_tok);  // keep the variable name

        auto& equal_tok = parser.expect(TokenType::Equal);
        out_tokens.push_back(equal_tok);  // keep the '=' token

        auto start_expr = parser.parse_expr();
        start_expr = fold_constants(std::move(start_expr));
        emit_expr(out_tokens, *start_expr, start_expr->loc);

        auto& to_tok = parser.expect(Keyword::TO);
        out_tokens.push_back(to_tok);  // keep the TO keyword

        auto end_expr = parser.parse_expr();
        end_expr = fold_constants(std::move(end_expr));
        emit_expr(out_tokens, *end_expr, end_expr->loc);

        if (parser.peek().keyword == Keyword::STEP) {
            auto& step_tok = parser.expect(Keyword::STEP);

            auto step_expr = parser.parse_expr();
            step_expr = fold_constants(std::move(step_expr));

            bool do_step = true;
            if (auto step_num = dynamic_cast<NumberExpr*>(step_expr.get())) {
                if (step_num->value == 1.0) {
                    // omit the STEP 1 expression
                    do_step = false;
                }
            }

            if (do_step) {
                out_tokens.push_back(step_tok);  // keep the STEP keyword
                emit_expr(out_tokens, *step_expr, step_expr->loc);
            }
        }
        release_assert(parser.at_end());
        break;
    }
    case Keyword::GOTO:
    case Keyword::GOSUB: {
        out_tokens.push_back(tok);  // keep the GOTO keyword
        parser.pos++;  // consume the GOTO keyword

        auto target_expr = parser.parse_expr();
        target_expr = fold_constants(std::move(target_expr));
        emit_expr(out_tokens, *target_expr, target_expr->loc);

        release_assert(parser.at_end());
        break;
    }
    case Keyword::PRINT:
    case Keyword::LPRINT: {
        out_tokens.push_back(tok);  // keep the PRINT keyword
        parser.pos++;  // consume the PRINT keyword

        while (!parser.at_end()) {
            if (parser.peek().type == TokenType::Semicolon) {
                auto& semicolon_tok = parser.expect(TokenType::Semicolon);
                out_tokens.push_back(semicolon_tok);  // keep the ';' token
                continue;
            }
            if (parser.peek().type == TokenType::Comma) {
                auto& comma_tok = parser.expect(TokenType::Comma);
                out_tokens.push_back(comma_tok);  // keep the ',' token
                continue;
            }
            if (parser.peek().keyword == Keyword::AT) {
                auto& at_tok = parser.expect(Keyword::AT);
                out_tokens.push_back(at_tok);  // keep the AT keyword

                auto line_expr = parser.parse_expr();
                line_expr = fold_constants(std::move(line_expr));
                emit_expr(out_tokens, *line_expr, line_expr->loc);

                auto& comma_tok = parser.expect(TokenType::Comma);
                out_tokens.push_back(comma_tok);  // keep the ',' token

                auto col_expr = parser.parse_expr();
                col_expr = fold_constants(std::move(col_expr));
                emit_expr(out_tokens, *col_expr, col_expr->loc);
                continue;
            }
            if (parser.peek().keyword == Keyword::TAB) {
                auto& tab_tok = parser.expect(Keyword::TAB);
                out_tokens.push_back(tab_tok);  // keep the TAB keyword

                auto tab_expr = parser.parse_expr();
                tab_expr = fold_constants(std::move(tab_expr));
                emit_expr(out_tokens, *tab_expr, tab_expr->loc);
                continue;
            }
            auto print_expr = parser.parse_expr();
            print_expr = fold_constants(std::move(print_expr));
            emit_expr(out_tokens, *print_expr, print_expr->loc);
        }
        release_assert(parser.at_end());
        break;
    }
    case Keyword::INPUT: {
        out_tokens.push_back(tok);  // keep the INPUT keyword
        parser.pos++;  // consume the INPUT keyword

        auto var_expr = parser.parse_assignable();
        var_expr = fold_constants(std::move(var_expr));
        emit_expr(out_tokens, *var_expr, var_expr->loc);

        release_assert(parser.at_end());
        break;
    }
    case Keyword::RUN:
    case Keyword::LIST:
    case Keyword::LLIST: {
        out_tokens.push_back(tok);  // keep the RUN keyword
        parser.pos++;  // consume the RUN keyword

        if (!parser.at_end()) {
            auto target_expr = parser.parse_expr();
            target_expr = fold_constants(std::move(target_expr));
            emit_expr(out_tokens, *target_expr, target_expr->loc);
        }

        release_assert(parser.at_end());
        break;
    }
    case Keyword::LOAD:
    case Keyword::SAVE: {
        out_tokens.push_back(tok);  // keep the LOAD keyword
        parser.pos++;  // consume the LOAD keyword

        auto filename_expr = parser.parse_expr();
        filename_expr = fold_constants(std::move(filename_expr));
        emit_expr(out_tokens, *filename_expr, filename_expr->loc);

        release_assert(parser.at_end());
        break;
    }
    case Keyword::POKE: {
        out_tokens.push_back(tok);  // keep the POKE keyword
        parser.pos++;  // consume the POKE keyword

        auto addr_expr = parser.parse_expr();
        addr_expr = fold_constants(std::move(addr_expr));
        emit_expr(out_tokens, *addr_expr, addr_expr->loc);

        auto& comma_tok = parser.expect(TokenType::Comma);
        out_tokens.push_back(comma_tok);  // keep the ',' token

        auto value_expr = parser.parse_expr();
        value_expr = fold_constants(std::move(value_expr));
        emit_expr(out_tokens, *value_expr, value_expr->loc);

        release_assert(parser.at_end());
        break;
    }
    case Keyword::PLOT:
    case Keyword::UNPLOT: {
        out_tokens.push_back(tok);  // keep the PLOT keyword
        parser.pos++;  // consume the PLOT keyword

        auto x_expr = parser.parse_expr();
        x_expr = fold_constants(std::move(x_expr));
        emit_expr(out_tokens, *x_expr, x_expr->loc);

        auto& comma_tok = parser.expect(TokenType::Comma);
        out_tokens.push_back(comma_tok);  // keep the ',' token

        auto y_expr = parser.parse_expr();
        y_expr = fold_constants(std::move(y_expr));
        emit_expr(out_tokens, *y_expr, y_expr->loc);

        release_assert(parser.at_end());
        break;
    }
    case Keyword::RAND: {
        out_tokens.push_back(tok);  // keep the RAND keyword
        parser.pos++;  // consume the RAND keyword

        auto seed_expr = parser.parse_expr();
        seed_expr = fold_constants(std::move(seed_expr));
        emit_expr(out_tokens, *seed_expr, seed_expr->loc);

        release_assert(parser.at_end());
        break;
    }
    case Keyword::PAUSE: {
        out_tokens.push_back(tok);  // keep the PAUSE keyword
        parser.pos++;  // consume the PAUSE keyword

        auto duration_expr = parser.parse_expr();
        duration_expr = fold_constants(std::move(duration_expr));
        emit_expr(out_tokens, *duration_expr, duration_expr->loc);

        release_assert(parser.at_end());
        break;
    }
    default:
        // copy the remaining tokens as is for unhandled statements
        out_tokens.insert(out_tokens.end(),
                          parser.line().tokens.begin() + parser.pos,
                          parser.line().tokens.end());
        break;
    }
}

struct ConstantFoldingWalker : ASTVisitor {
    virtual ~ConstantFoldingWalker() = default;

    void visit(LetStmt& stmt) override {
        stmt.lhs = fold_constants(std::move(stmt.lhs));
        stmt.rhs = fold_constants(std::move(stmt.rhs));
    }

    void visit(DimStmt& stmt) override {
        for (auto& item : stmt.items) {
            for (auto& dim_expr : item.dims) {
                dim_expr = fold_constants(std::move(dim_expr));
            }
        }
    }

    void visit(IfStmt& stmt) override {
        stmt.condition = fold_constants(std::move(stmt.condition));
    }

    void visit(RepeatStmt& stmt) override {
        stmt.condition = fold_constants(std::move(stmt.condition));
    }

    void visit(WhileStmt& stmt) override {
        stmt.condition = fold_constants(std::move(stmt.condition));
    }

    void visit(ForStmt& stmt) override {
        stmt.start_expr = fold_constants(std::move(stmt.start_expr));
        stmt.end_expr = fold_constants(std::move(stmt.end_expr));
        stmt.step_expr = fold_constants(std::move(stmt.step_expr));
    }

    void visit(ProcCallStmt& stmt) override {
        for (auto& arg : stmt.args) {
            arg = fold_constants(std::move(arg));
        }
    }

    void visit(DefFnStmt& stmt) override {
        stmt.expr = fold_constants(std::move(stmt.expr));
    }

    void visit(GotoStmt& stmt) override {
        stmt.target_expr = fold_constants(std::move(stmt.target_expr));
    }

    void visit(GosubStmt& stmt) override {
        stmt.target_expr = fold_constants(std::move(stmt.target_expr));
    }

    void visit(PrintStmt& stmt) override {
        for (auto& item : stmt.items) {
            item.expr = fold_constants(std::move(item.expr));
            item.line_expr = fold_constants(std::move(item.line_expr));
            item.col_expr = fold_constants(std::move(item.col_expr));
            item.tab_expr = fold_constants(std::move(item.tab_expr));
        }
    }

    void visit(LPrintStmt& stmt) override {
        for (auto& item : stmt.items) {
            item.expr = fold_constants(std::move(item.expr));
            item.line_expr = fold_constants(std::move(item.line_expr));
            item.col_expr = fold_constants(std::move(item.col_expr));
            item.tab_expr = fold_constants(std::move(item.tab_expr));
        }
    }

    void visit(InputStmt& stmt) override {
        for (auto& var : stmt.vars) {
            var = fold_constants(std::move(var));
        }
    }

    void visit(RunStmt& stmt) override {
        stmt.target_expr = fold_constants(std::move(stmt.target_expr));
    }

    void visit(ListStmt& stmt) override {
        stmt.target_expr = fold_constants(std::move(stmt.target_expr));
    }

    void visit(LListStmt& stmt) override {
        stmt.target_expr = fold_constants(std::move(stmt.target_expr));
    }

    void visit(LoadStmt& stmt) override {
        stmt.filename_expr = fold_constants(std::move(stmt.filename_expr));
    }

    void visit(SaveStmt& stmt) override {
        stmt.filename_expr = fold_constants(std::move(stmt.filename_expr));
    }

    void visit(PokeStmt& stmt) override {
        stmt.address_expr = fold_constants(std::move(stmt.address_expr));
        stmt.value_expr = fold_constants(std::move(stmt.value_expr));
    }

    void visit(PokewStmt& stmt) override {
        stmt.address_expr = fold_constants(std::move(stmt.address_expr));
        stmt.value_expr = fold_constants(std::move(stmt.value_expr));
    }

    void visit(PlotStmt& stmt) override {
        stmt.x_expr = fold_constants(std::move(stmt.x_expr));
        stmt.y_expr = fold_constants(std::move(stmt.y_expr));
    }

    void visit(UnplotStmt& stmt) override {
        stmt.x_expr = fold_constants(std::move(stmt.x_expr));
        stmt.y_expr = fold_constants(std::move(stmt.y_expr));
    }

    void visit(RandStmt& stmt) override {
        stmt.seed_expr = fold_constants(std::move(stmt.seed_expr));
    }

    void visit(PauseStmt& stmt) override {
        stmt.duration_expr = fold_constants(std::move(stmt.duration_expr));
    }
};

void simplify_exprs(Prog& prog) {
    ConstantFoldingWalker walker;
    prog.accept(walker);
}

void simplify_exprs(std::vector<Token>& tokens) {
    if (tokens.empty()) {
        return;
    }

    // create prog only with this line
    Prog prog;
    TokFile tok_file;

    SrcLine src_line;
    src_line.text = to_string(tokens);
    src_line.loc = tokens.front().loc;

    TokLine tok_line;
    tok_line.source_type = SourceType::BASIC;
    tok_line.src_line = src_line;
    tok_line.tokens = tokens;

    TokFile tok_file_single_line;
    tok_file_single_line.lines.push_back(tok_line);

    Prog prog_single_line;

    // create parser and parse the single line
    Parser parser{ prog_single_line, tok_file_single_line, 0, 0 };

    // create result vector of tokens and parse the single line into it
    std::vector<Token> result_tokens;
    simplify_stmt(parser, result_tokens);

    // move the result tokens back to the original tokens vector
    tokens = std::move(result_tokens);
}
