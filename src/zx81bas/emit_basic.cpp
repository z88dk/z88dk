//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "emit_basic.h"
#include "errors.h"
#include "lexer.h"
#include "release_assert.h"
#include "zx81bas.h"
#include <cctype>
#include <cmath>
#include <sstream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

static std::string string_literal_to_string(const std::string& text) {
    std::string escaped_value = text;
    // Escape double quotes in the string literal
    size_t pos = 0;
    while ((pos = escaped_value.find('"', pos)) != std::string::npos) {
        escaped_value.insert(pos, "\"");
        pos += 2; // Move past the escaped quote
    }
    return "\"" + escaped_value + "\"";
}

static int precedence(const Expr& e) {
    if (dynamic_cast<const NumberExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const StringLiteralExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const LabelLineRefExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const LabelAddrRefExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const VariableExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const ArrayRefExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const SliceExpr*>(&e)) {
        return 1;
    }
    if (dynamic_cast<const BasicFuncCallExpr*>(&e)) {
        return 1;
    }
    if (auto u = dynamic_cast<const UnaryExpr*>(&e)) {
        switch (u->op) {
        case TokenType::Minus:
        case TokenType::NOT:
            return 2;
        default:
            release_assert(0);
        }
    }
    if (auto b = dynamic_cast<const BinaryExpr*>(&e)) {
        switch (b->op) {
        case TokenType::Power:
            return 3;
        case TokenType::Multiply:
        case TokenType::Divide:
        case TokenType::IntDivide:
        case TokenType::MOD:
            return 4;
        case TokenType::Plus:
        case TokenType::Minus:
            return 5;
        case TokenType::Equal:
        case TokenType::Less:
        case TokenType::Greater:
        case TokenType::LessEqual:
        case TokenType::GreaterEqual:
        case TokenType::NotEqual:
            return 6;
        case TokenType::AND:
        case TokenType::OR:
            return 7;
        default:
            release_assert(0);
        }
    }

    release_assert(0);
    return 99; // not reached
}

static void append_token(std::vector<Token>& tokens, TokenType type,
                         const std::string& text, const SourceLoc& loc) {
    Token t;
    t.type = type;
    t.keyword = lookup_keyword(text);
    t.text = text;
    t.loc = loc;

    // prepend space if needed
    if (!tokens.empty()) {
        if (isalnum(text[0]) && isalnum(tokens.back().text.back())) {
            t.ws_before = " ";
        }
        else if (text[0] == '@' || text[0] == '&') {
            t.ws_before = " ";
        }
    }

    tokens.push_back(t);
}

static void emit_child(std::vector<Token>& tokens, const Expr& child,
                       int parent_prec, const SourceLoc& loc) {
    int child_prec = precedence(child);

    bool need_parens = child_prec > parent_prec;

    if (need_parens) {
        append_token(tokens, TokenType::LeftParen, "(", loc);
    }
    emit_expr(tokens, child, loc);
    if (need_parens) {
        append_token(tokens, TokenType::RightParen, ")", loc);
    }
}

void emit_expr(std::vector<Token>& tokens, const Expr& e,
               const SourceLoc& loc) {
    // Number
    if (auto n = dynamic_cast<const NumberExpr*>(&e)) {
        if (n->value < 0) {
            append_token(tokens, TokenType::Minus, "-", loc);
            append_token(tokens, TokenType::Float, double_to_string(- n->value), loc);
            tokens.back().nvalue = - n->value;
        }
        else {
            append_token(tokens, TokenType::Float, double_to_string(n->value), loc);
            tokens.back().nvalue = n->value;
        }
        return;
    }

    // Label line reference
    if (auto l = dynamic_cast<const LabelLineRefExpr*>(&e)) {
        append_token(tokens, TokenType::LabelRefLine, "@" + l->name, loc);
        tokens.back().svalue = l->name;
        return;
    }

    // Label address reference
    if (auto l = dynamic_cast<const LabelAddrRefExpr*>(&e)) {
        append_token(tokens, TokenType::LabelRefAddr, "&" + l->name, loc);
        tokens.back().svalue = l->name;
        return;
    }

    // String literal
    if (auto s = dynamic_cast<const StringLiteralExpr*>(&e)) {
        append_token(tokens, TokenType::StringLiteral,
                     string_literal_to_string(s->value), loc);
        tokens.back().svalue = s->value;
        return;
    }

    // Variable
    if (auto v = dynamic_cast<const VariableExpr*>(&e)) {
        append_token(tokens, TokenType::Identifier, v->name, loc);
        return;
    }

    // Array reference
    if (auto a = dynamic_cast<const ArrayRefExpr*>(&e)) {
        append_token(tokens, TokenType::Identifier, a->name, loc);
        append_token(tokens, TokenType::LeftParen, "(", loc);
        for (size_t i = 0; i < a->indices.size(); ++i) {
            if (i > 0) {
                append_token(tokens, TokenType::Comma, ",", loc);
            }
            emit_expr(tokens, *a->indices[i], loc);
        }
        append_token(tokens, TokenType::RightParen, ")", loc);
        return;
    }

    // Slice
    if (auto s = dynamic_cast<const SliceExpr*>(&e)) {
        emit_expr(tokens, *s->base, loc);
        append_token(tokens, TokenType::LeftParen, "(", loc);
        if (s->from) {
            emit_expr(tokens, *s->from, loc);
        }
        append_token(tokens, TokenType::Identifier, "TO", loc);
        if (s->to) {
            emit_expr(tokens, *s->to, loc);
        }
        append_token(tokens, TokenType::RightParen, ")", loc);
        return;
    }

    // Unary
    if (auto u = dynamic_cast<const UnaryExpr*>(&e)) {
        append_token(tokens, u->op, token_type_name(u->op), loc);
        emit_child(tokens, *u->operand, precedence(e), loc);
        return;
    }

    // Binary
    if (auto b = dynamic_cast<const BinaryExpr*>(&e)) {
        emit_child(tokens, *b->lhs, precedence(e), loc);
        append_token(tokens, b->op, token_type_name(b->op), loc);
        emit_child(tokens, *b->rhs, precedence(e), loc);
        return;
    }

    // BASIC function call
    if (auto f = dynamic_cast<const BasicFuncCallExpr*>(&e)) {
        append_token(tokens, TokenType::Identifier, keyword_name(f->keyword), loc);
        if (!f->args.empty()) {
            bool need_parens = f->args.size() > 1
                               || precedence(*f->args[0]) > precedence(e);
            if (need_parens) {
                append_token(tokens, TokenType::LeftParen, "(", loc);
            }
            for (size_t i = 0; i < f->args.size(); ++i) {
                if (i > 0) {
                    append_token(tokens, TokenType::Comma, ",", loc);
                }
                emit_expr(tokens, *f->args[i], loc);
            }
            if (need_parens) {
                append_token(tokens, TokenType::RightParen, ")", loc);
            }
        }
        return;
    }

    // PROC function call and FN function call have been lowered
    release_assert(0); // should not reach here
}

static void emit_stmt(std::vector<Token>& tokens, const Stmt& stmt) {
    // LET statement
    if (auto s = dynamic_cast<const LetStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "LET", s->loc);
        emit_expr(tokens, *s->lhs, s->loc);
        append_token(tokens, TokenType::Equal, "=", s->loc);
        emit_expr(tokens, *s->rhs, s->loc);
        return;
    }

    // DIM statement
    if (auto s = dynamic_cast<const DimStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "DIM", s->loc);
        release_assert(s->items.size() == 1);
        auto& item = s->items[0];
        append_token(tokens, TokenType::Identifier, item.name, s->loc);
        release_assert(!item.dims.empty());
        append_token(tokens, TokenType::LeftParen, "(", s->loc);
        for (size_t i = 0; i < item.dims.size(); ++i) {
            if (i > 0) {
                append_token(tokens, TokenType::Comma, ",", s->loc);
            }
            emit_expr(tokens, *item.dims[i], s->loc);
        }
        append_token(tokens, TokenType::RightParen, ")", s->loc);
        return;
    }

    // IF statement
    if (auto s = dynamic_cast<const IfStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "IF", s->loc);
        emit_expr(tokens, *s->condition, s->loc);
        append_token(tokens, TokenType::Identifier, "THEN", s->loc);
        release_assert(s->then_stmts.size() == 1);
        release_assert(s->else_stmts.size() == 0);
        auto& then_stmt = s->then_stmts[0];
        emit_stmt(tokens, *then_stmt);
        return;
    }

    // FOR statement
    if (auto s = dynamic_cast<const ForStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "FOR", s->loc);
        append_token(tokens, TokenType::Identifier, s->name, s->loc);
        append_token(tokens, TokenType::Equal, "=", s->loc);
        emit_expr(tokens, *s->start_expr, s->loc);
        append_token(tokens, TokenType::Identifier, "TO", s->loc);
        emit_expr(tokens, *s->end_expr, s->loc);
        if (s->step_expr) {
            append_token(tokens, TokenType::Identifier, "STEP", s->loc);
            emit_expr(tokens, *s->step_expr, s->loc);
        }
        release_assert(s->body.empty());
        return;
    }

    // NEXT statement
    if (auto s = dynamic_cast<const NextStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "NEXT", s->loc);
        append_token(tokens, TokenType::Identifier, s->name, s->loc);
        return;
    }

    // GOTO statement
    if (auto s = dynamic_cast<const GotoStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "GOTO", s->loc);
        emit_expr(tokens, *s->target_expr, s->loc);
        return;
    }

    // GOSUB statement
    if (auto s = dynamic_cast<const GosubStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "GOSUB", s->loc);
        emit_expr(tokens, *s->target_expr, s->loc);
        return;
    }

    // RETURN statement
    if (auto s = dynamic_cast<const ReturnStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "RETURN", s->loc);
        return;
    }

    // STOP statement
    if (auto s = dynamic_cast<const StopStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "STOP", s->loc);
        return;
    }

    // PRINT statement
    if (auto s = dynamic_cast<const PrintStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "PRINT", s->loc);
        for (auto& item : s->items) {
            switch (item.type) {
            case PrintItem::Type::Expr:
                emit_expr(tokens, *item.expr, s->loc);
                break;
            case PrintItem::Type::Comma:
                append_token(tokens, TokenType::Comma, ",", s->loc);
                break;
            case PrintItem::Type::Semicolon:
                append_token(tokens, TokenType::Semicolon, ";", s->loc);
                break;
            case PrintItem::Type::At:
                append_token(tokens, TokenType::Identifier, "AT", s->loc);
                emit_expr(tokens, *item.line_expr, s->loc);
                append_token(tokens, TokenType::Comma, ",", s->loc);
                emit_expr(tokens, *item.col_expr, s->loc);
                break;
            case PrintItem::Type::Tab:
                append_token(tokens, TokenType::Identifier, "TAB", s->loc);
                emit_expr(tokens, *item.tab_expr, s->loc);
                break;
            default:
                release_assert(0);
            }
        }
        return;
    }

    // LPRINT statement
    if (auto s = dynamic_cast<const LPrintStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "LPRINT", s->loc);
        for (auto& item : s->items) {
            switch (item.type) {
            case PrintItem::Type::Expr:
                emit_expr(tokens, *item.expr, s->loc);
                break;
            case PrintItem::Type::Comma:
                append_token(tokens, TokenType::Comma, ",", s->loc);
                break;
            case PrintItem::Type::Semicolon:
                append_token(tokens, TokenType::Semicolon, ";", s->loc);
                break;
            case PrintItem::Type::At:
                append_token(tokens, TokenType::Identifier, "AT", s->loc);
                emit_expr(tokens, *item.line_expr, s->loc);
                append_token(tokens, TokenType::Comma, ",", s->loc);
                emit_expr(tokens, *item.col_expr, s->loc);
                break;
            case PrintItem::Type::Tab:
                append_token(tokens, TokenType::Identifier, "TAB", s->loc);
                emit_expr(tokens, *item.tab_expr, s->loc);
                break;
            default:
                release_assert(0);
            }
        }
        return;
    }

    // INPUT statement
    if (auto s = dynamic_cast<const InputStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "INPUT", s->loc);
        release_assert(s->vars.size() == 1);
        emit_expr(tokens, *s->vars[0], s->loc);
        return;
    }

    // REM statement
    if (auto s = dynamic_cast<const RemStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "REM", s->loc);
        if (!s->text.empty()) {
            append_token(tokens, TokenType::RemComment, s->text, s->loc);
            tokens.back().ws_before = " ";
        }
        return;
    }

    // RUN statement
    if (auto s = dynamic_cast<const RunStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "RUN", s->loc);
        if (s->target_expr) {
            emit_expr(tokens, *s->target_expr, s->loc);
        }
        return;
    }

    // LIST statement
    if (auto s = dynamic_cast<const ListStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "LIST", s->loc);
        if (s->target_expr) {
            emit_expr(tokens, *s->target_expr, s->loc);
        }
        return;
    }

    // LLIST statement
    if (auto s = dynamic_cast<const LListStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "LLIST", s->loc);
        if (s->target_expr) {
            emit_expr(tokens, *s->target_expr, s->loc);
        }
        return;
    }

    // NEW statement
    if (auto s = dynamic_cast<const NewStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "NEW", s->loc);
        return;
    }

    // CLS statement
    if (auto s = dynamic_cast<const ClsStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "CLS", s->loc);
        return;
    }

    // LOAD statement
    if (auto s = dynamic_cast<const LoadStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "LOAD", s->loc);
        emit_expr(tokens, *s->filename_expr, s->loc);
        return;
    }

    // SAVE statement
    if (auto s = dynamic_cast<const SaveStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "SAVE", s->loc);
        emit_expr(tokens, *s->filename_expr, s->loc);
        return;
    }

    // POKE statement
    if (auto s = dynamic_cast<const PokeStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "POKE", s->loc);
        emit_expr(tokens, *s->address_expr, s->loc);
        append_token(tokens, TokenType::Comma, ",", s->loc);
        emit_expr(tokens, *s->value_expr, s->loc);
        return;
    }

    // PLOT statement
    if (auto s = dynamic_cast<const PlotStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "PLOT", s->loc);
        emit_expr(tokens, *s->x_expr, s->loc);
        append_token(tokens, TokenType::Comma, ",", s->loc);
        emit_expr(tokens, *s->y_expr, s->loc);
        return;
    }

    // UNPLOT statement
    if (auto s = dynamic_cast<const UnplotStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "UNPLOT", s->loc);
        emit_expr(tokens, *s->x_expr, s->loc);
        append_token(tokens, TokenType::Comma, ",", s->loc);
        emit_expr(tokens, *s->y_expr, s->loc);
        return;
    }

    // RAND statement
    if (auto s = dynamic_cast<const RandStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "RAND", s->loc);
        emit_expr(tokens, *s->seed_expr, s->loc);
        return;
    }

    // PAUSE statement
    if (auto s = dynamic_cast<const PauseStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "PAUSE", s->loc);
        emit_expr(tokens, *s->duration_expr, s->loc);
        return;
    }

    // FAST statement
    if (auto s = dynamic_cast<const FastStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "FAST", s->loc);
        return;
    }

    // SLOW statement
    if (auto s = dynamic_cast<const SlowStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "SLOW", s->loc);
        return;
    }

    // SCROLL statement
    if (auto s = dynamic_cast<const ScrollStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "SCROLL", s->loc);
        return;
    }

    // CONT statement
    if (auto s = dynamic_cast<const ContStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "CONT", s->loc);
        return;
    }

    // CLEAR statement
    if (auto s = dynamic_cast<const ClearStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "CLEAR", s->loc);
        return;
    }

    // COPY statement
    if (auto s = dynamic_cast<const CopyStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, "COPY", s->loc);
        return;
    }

    // Pragma number variable
    if (auto s = dynamic_cast<const PragmaNumVarStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, s->name, s->loc);
        append_token(tokens, TokenType::Equal, "=", s->loc);
        append_token(tokens, TokenType::Float, double_to_string(s->value), s->loc);
        tokens.back().nvalue = s->value;
        return;
    }

    // Pragma string variable
    if (auto s = dynamic_cast<const PragmaStrVarStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, s->name, s->loc);
        append_token(tokens, TokenType::Equal, "=", s->loc);
        append_token(tokens, TokenType::StringLiteral,
                     string_literal_to_string(s->value), s->loc);
        tokens.back().svalue = s->value;
        return;
    }

    // Pragma number array
    if (auto s = dynamic_cast<const PragmaNumVarArrayStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, s->name, s->loc);
        append_token(tokens, TokenType::LeftParen, "(", s->loc);
        for (size_t i = 0; i < s->dims.size(); i++) {
            auto dim = s->dims[i];
            if (i > 0) {
                append_token(tokens, TokenType::Comma, ",", s->loc);
            }
            append_token(tokens, TokenType::Integer, std::to_string(dim), s->loc);
            tokens.back().ivalue = dim;
        }
        append_token(tokens, TokenType::RightParen, ")", s->loc);
        append_token(tokens, TokenType::Equal, "=", s->loc);
        for (size_t i = 0; i < s->values.size(); i++) {
            auto value = s->values[i];
            if (i > 0) {
                append_token(tokens, TokenType::Comma, ",", s->loc);
            }
            append_token(tokens, TokenType::Float, double_to_string(value), s->loc);
            tokens.back().nvalue = value;
        }
        return;
    }

    // Pragma string array
    if (auto s = dynamic_cast<const PragmaStrVarArrayStmt*>(&stmt)) {
        append_token(tokens, TokenType::Identifier, s->name, s->loc);
        append_token(tokens, TokenType::LeftParen, "(", s->loc);
        for (size_t i = 0; i < s->dims.size(); i++) {
            auto dim = s->dims[i];
            if (i > 0) {
                append_token(tokens, TokenType::Comma, ",", s->loc);
            }
            append_token(tokens, TokenType::Integer, std::to_string(dim), s->loc);
            tokens.back().ivalue = dim;
        }
        append_token(tokens, TokenType::RightParen, ")", s->loc);
        append_token(tokens, TokenType::Equal, "=", s->loc);
        for (size_t i = 0; i < s->values.size(); i++) {
            auto& value = s->values[i];
            if (i > 0) {
                append_token(tokens, TokenType::Comma, ",", s->loc);
            }
            append_token(tokens, TokenType::StringLiteral, string_literal_to_string(value),
                         s->loc);
            tokens.back().svalue = value;
        }
        return;
    }

    // Other statement types should not be present
    release_assert(0);
}

static void emit_stmts(std::vector<BasicLine>& lines,
                       const std::vector<StmtPtr>& stmts) {
    int requested_line_num = -1;
    std::vector<std::string> requested_labels;

    for (const auto& stmt : stmts) {
        // Label statement
        if (auto label_stmt = dynamic_cast<const LabelStmt*>(stmt.get())) {
            requested_labels.push_back(label_stmt->label);
            continue; // Label statement does not produce a BASIC line
        }

        // Line number statement
        if (auto line_num_stmt = dynamic_cast<const LineNumStmt*>(stmt.get())) {
            requested_line_num = line_num_stmt->line_num;
            continue; // Line number statement does not produce a BASIC line
        }

        BasicLine line;
        line.line_num = requested_line_num;
        line.type = BasicLine::Type::BASIC;
        line.labels = std::move(requested_labels);
        emit_stmt(line.tokens, *stmt);
        lines.push_back(std::move(line));

        // Emit ASM lines if the statement is a REM statement
        if (auto rem_stmt = dynamic_cast<const RemStmt*>(stmt.get())) {
            for (const auto& asm_line : rem_stmt->asm_lines) {
                BasicLine line;
                line.line_num = -1; // ASM lines do not have BASIC line numbers
                line.type = BasicLine::Type::ASM;
                line.tokens = asm_line.tokens;
                lines.push_back(std::move(line));
            }
        }

        requested_line_num = -1;
        requested_labels.clear();
    }

    if (!requested_labels.empty()) {
        // If there are any remaining labels, create a BASIC line with no statement
        BasicLine line;
        line.line_num = requested_line_num;
        line.type = BasicLine::Type::BASIC;
        line.labels = std::move(requested_labels);
        lines.push_back(std::move(line));
    }
}

static void emit_dfile(std::vector<BasicLine>& lines,
                       const std::vector<std::string>& video_lines) {
    for (auto& vl : video_lines) {
        BasicLine line;
        line.type = BasicLine::Type::DFILE;
        append_token(line.tokens, TokenType::StringLiteral, vl, SourceLoc());
        line.tokens.back().svalue = vl;
        lines.push_back(std::move(line));
    }
}

static void emit_vars(std::vector<BasicLine>& lines,
                      const std::vector<StmtPtr>& vars) {
    for (const auto& stmt : vars) {
        BasicLine line;
        line.type = BasicLine::Type::VARS;
        emit_stmt(line.tokens, *stmt);
        lines.push_back(std::move(line));

        // Emit ASM lines if the statement is string variable
        if (auto var_stmt = dynamic_cast<const PragmaStrVarStmt*>(stmt.get())) {
            for (const auto& asm_line : var_stmt->asm_lines) {
                BasicLine line;
                line.line_num = -1; // ASM lines do not have BASIC line numbers
                line.type = BasicLine::Type::ASM;
                line.tokens = asm_line.tokens;
                lines.push_back(std::move(line));
            }
        }
    }
}

static void number_lines(std::vector<BasicLine>& lines, int increment) {
    // start line is zero if the first line is assembly
    int line_num = increment;
    if (lines.size() >= 2 &&
            lines[0].type == BasicLine::Type::BASIC &&
            !lines[0].tokens.empty() &&
            lines[0].tokens[0].keyword == Keyword::REM &&
            lines[1].type == BasicLine::Type::ASM) {
        line_num = 0;
    }

    // renumber BASIC lines
    for (auto& line : lines) {
        if (line.type != BasicLine::Type::BASIC) {
            continue; // Only number BASIC lines
        }

        if (line.line_num < 0) {
            line.line_num = line_num;
        }
        else if (line.line_num < line_num) {
            // error - lines out of sequence
            error(line.tokens.front().loc, "Line numbers out of sequence");
            return;
        }
        else {
            line_num = line.line_num;
        }
        line_num += increment;
    }
}

static void replace_labels(std::vector<BasicLine>& lines,
                           std::unordered_map<std::string, int>& label_line) {

    // build label -> line number map
    for (const auto& line : lines) {
        if (line.type != BasicLine::Type::BASIC) {
            continue; // Only BASIC lines can have labels
        }
        for (const auto& label : line.labels) {
            release_assert(label_line.find(label) == label_line.end());
            label_line[label] = line.line_num;
        }
    }

    // replace label references with line numbers
    for (auto& line : lines) {
        for (auto& token : line.tokens) {
            if (token.type == TokenType::LabelRefLine) {
                // find the label in the map
                auto it = label_line.find(token.svalue);
                release_assert(it != label_line.end());

                // replace '@label' by line number
                token.type = TokenType::Integer;
                token.ivalue = it->second;
                token.text = std::to_string(it->second);
            }
        }
    }
}

static void replace_labels(std::vector<StmtPtr>& stmts,
                           const std::unordered_map<std::string, int>& label_line) {
    for (auto& stmt : stmts) {
        if (auto s = dynamic_cast<PragmaStrVarStmt*>(stmt.get())) {
            for (auto& asm_line : s->asm_lines) {
                for (auto& token : asm_line.tokens) {
                    if (token.type == TokenType::LabelRefLine) {
                        auto it = label_line.find(token.svalue);
                        if (it == label_line.end()) {
                            error(token.loc, "Undefined label: '" + token.svalue + "'");
                            continue;
                        }
                        token.type = TokenType::Integer;
                        token.ivalue = it->second;
                        token.text = std::to_string(it->second);
                    }
                }
            }
        }
    }
}

bool emit_basic(Prog& prog) {
    // emit BASIC lines from the AST
    std::vector<BasicLine> lines;
    emit_stmts(lines, prog.stmts);
    emit_dfile(lines, prog.dfile_lines);
    emit_vars(lines, prog.pragma_vars);
    prog.basic_lines = std::move(lines);

    // renumber lines and replace label references with line numbers
    number_lines(prog.basic_lines, prog.increment);
    replace_labels(prog.basic_lines, prog.label_line);
    replace_labels(prog.pragma_vars, prog.label_line);

    return get_error_count() == 0;
}
