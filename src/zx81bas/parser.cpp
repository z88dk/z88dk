//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "ast_expr.h"
#include "ast_stmt.h"
#include "dump_context.h"
#include "errors.h"
#include "lexer.h"
#include "options.h"
#include "parser.h"
#include "release_assert.h"
#include "scan.h"
#include "utils.h"
#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <memory>
#include <string>
#include <unordered_set>
#include <utility>
#include <vector>

std::unordered_map<Keyword, Parser::StmtParser> Parser::pragma_parsers_lut = {
    { Keyword::AUTOSTART,       &Parser::parse_pragma_autostart },
    { Keyword::AUTOSTART_LINE,  &Parser::parse_pragma_autostart_line },
    { Keyword::INCREMENT,       &Parser::parse_pragma_increment },
    { Keyword::REMINVERT,       &Parser::parse_pragma_reminvert },
    { Keyword::FAST,            &Parser::parse_pragma_fast },
    { Keyword::VERBOSE,         &Parser::parse_pragma_verbose },
    { Keyword::VARS,            &Parser::parse_pragma_vars },
    { Keyword::DFILE,           &Parser::parse_pragma_dfile },
    { Keyword::DFILE_COLAPSED,  &Parser::parse_pragma_dfile_colapsed },
    { Keyword::SYSVARS,         &Parser::parse_pragma_sysvars },
};

std::unordered_map<Keyword, Parser::StmtParser> Parser::stmt_parsers_lut = {
    { Keyword::LET,             &Parser::parse_stmt_let },
    { Keyword::DIM,             &Parser::parse_stmt_dim },
    { Keyword::IF,              &Parser::parse_stmt_if },
    { Keyword::REPEAT,          &Parser::parse_stmt_repeat },
    { Keyword::WHILE,           &Parser::parse_stmt_while },
    { Keyword::FOR,             &Parser::parse_stmt_for },
    { Keyword::DEF,             &Parser::parse_stmt_def },
    { Keyword::LOCAL,           &Parser::parse_stmt_local },
    { Keyword::EXIT,            &Parser::parse_stmt_exit },
    { Keyword::GOTO,            &Parser::parse_stmt_goto },
    { Keyword::GOSUB,           &Parser::parse_stmt_gosub },
    { Keyword::RETURN,          &Parser::parse_stmt_return },
    { Keyword::STOP,            &Parser::parse_stmt_stop },
    { Keyword::END,             &Parser::parse_stmt_end },
    { Keyword::PRINT,           &Parser::parse_stmt_print },
    { Keyword::INPUT,           &Parser::parse_stmt_input },
    { Keyword::REM,             &Parser::parse_stmt_rem },
    { Keyword::RUN,             &Parser::parse_stmt_run },
    { Keyword::NEW,             &Parser::parse_stmt_new },
    { Keyword::CLS,             &Parser::parse_stmt_cls },
    { Keyword::LOAD,            &Parser::parse_stmt_load },
    { Keyword::SAVE,            &Parser::parse_stmt_save },
    { Keyword::POKE,            &Parser::parse_stmt_poke },
    { Keyword::POKEW,           &Parser::parse_stmt_pokew },
    { Keyword::RAND,            &Parser::parse_stmt_rand },
    { Keyword::PAUSE,           &Parser::parse_stmt_pause },
    { Keyword::FAST,            &Parser::parse_stmt_fast },
    { Keyword::SLOW,            &Parser::parse_stmt_slow },
    { Keyword::LIST,            &Parser::parse_stmt_list },
    { Keyword::PLOT,            &Parser::parse_stmt_plot },
    { Keyword::UNPLOT,          &Parser::parse_stmt_unplot },
    { Keyword::SCROLL,          &Parser::parse_stmt_scroll },
    { Keyword::CONT,            &Parser::parse_stmt_cont },
    { Keyword::CLEAR,           &Parser::parse_stmt_clear },
};

bool Parser::at_end() const {
    return pos >= line().tokens.size();
}

bool Parser::at_end_of_stmt() const {
    return at_end() ||
           peek().type == TokenType::Colon ||
           peek().keyword == Keyword::ELSE ||
           peek().keyword == Keyword::UNTIL ||
           peek().keyword == Keyword::WEND ||
           peek().keyword == Keyword::NEXT;
}

void Parser::check_end_of_stmt() {
    if (at_end_of_stmt()) {
        return;     // end of input
    }

    // expect end of statement or colon, but found something else
    syntax_error("expected end of statement, found '" + peek().text + "'");
}

bool Parser::match(TokenType type) {
    if (peek().type == type) {
        ++pos;
        return true;
    }
    return false;
}

bool Parser::match(Keyword keyword) {
    if (peek().keyword == keyword) {
        ++pos;
        return true;
    }
    return false;
}

const Token& Parser::expect(TokenType type) {
    if (peek().type == type) {
        return line().tokens[pos++];
    }

    if (at_end()) {
        syntax_error("expected '" + token_type_name(type) +
                     "', found end of line");
    }
    else {
        syntax_error("expected '" + token_type_name(type) + "', " +
                     "found '" + peek().text + "'");
    }

    static const Token dummy;
    return dummy;  // unreachable, but avoids compiler warning
}

const Token& Parser::expect(Keyword keyword) {
    if (peek().keyword == keyword) {
        return line().tokens[pos++];
    }

    if (at_end()) {
        syntax_error("expected '" + keyword_name(keyword) +
                     "', found end of line");
    }
    else {
        syntax_error("expected '" + keyword_name(keyword) + "', " +
                     "found '" + peek().text + "'");
    }

    static const Token dummy;
    return dummy;  // unreachable, but avoids compiler warning
}

const Token& Parser::peek(size_t offset) const {
    static const Token end_of_line;
    size_t p = pos + offset;
    if (p >= line().tokens.size()) {
        return end_of_line;
    }
    return line().tokens[p];
}

const TokLine& Parser::line() const {
    return tok_file.lines[cur_line];
}

const SourceLoc& Parser::loc() const {
    return tok_file.lines[cur_line].src_line.loc;
}

std::unique_ptr<Expr> Parser::parse_primary() {
    const Token& t = peek();

    // are we at end
    if (at_end()) {
        syntax_error("expected expression term, found end of line");
    }

    if (at_end_of_stmt()) {
        syntax_error("expected expression term, found '" +
                     peek().text + "'");
    }

    // Number
    if (match(TokenType::Integer)) {
        auto number_expr = std::make_unique<NumberExpr>(t.ivalue, loc());
        return number_expr;
    }

    if (match(TokenType::Float)) {
        auto number_expr = std::make_unique<NumberExpr>(t.nvalue, loc());
        return number_expr;
    }

    // String literal
    if (match(TokenType::StringLiteral)) {
        auto string_expr = std::make_unique<StringLiteralExpr>(t.svalue, loc());
        return string_expr;
    }

    // @label reference
    if (match(TokenType::At)) {
        const Token& ident = expect(TokenType::Identifier);
        std::string name = ident.text;
        if (is_string_variable(name)) {
            syntax_error("label reference cannot be a string variable");
        }
        auto label_ref = std::make_unique<LabelLineRefExpr>(name, loc());
        return label_ref;
    }

    // &label reference
    if (match(TokenType::Ampersand)) {
        const Token& ident = expect(TokenType::Identifier);
        std::string name = ident.text;
        if (is_string_variable(name)) {
            syntax_error("label reference cannot be a string variable");
        }
        auto label_ref = std::make_unique<LabelAddrRefExpr>(name, loc());
        return label_ref;
    }

    // Parenthesized expression
    if (match(TokenType::LeftParen)) {
        auto e = parse_expr();
        expect(TokenType::RightParen);
        return e;
    }

    // Identifier: variable, array, slice, function call
    if (t.type == TokenType::Identifier &&
            !at_end_of_stmt()) {	// so that UNTIL does not match
        std::string name = t.text;
        ++pos;

        // 0. Procedure call: PROCname(args)
        if (str_toupper(name).compare(0, 4, "PROC") == 0 &&
                match(TokenType::LeftParen)) {
            std::vector<std::unique_ptr<Expr>> args;

            if (!match(TokenType::RightParen)) {
                while (true) {
                    args.push_back(parse_expr());

                    if (match(TokenType::Comma)) {
                        continue;
                    }
                    break;
                }
                expect(TokenType::RightParen);
            }

            auto proc_call = std::make_unique<ProcCallExpr>(name, loc());
            proc_call->args = std::move(args);
            return proc_call;
        }

        // 0b. User function call: FNname(args)
        if (str_toupper(name).compare(0, 2, "FN") == 0 &&
                match(TokenType::LeftParen)) {
            std::vector<std::unique_ptr<Expr>> args;

            if (!match(TokenType::RightParen)) {
                while (true) {
                    args.push_back(parse_expr());

                    if (match(TokenType::Comma)) {
                        continue;
                    }
                    break;
                }
                expect(TokenType::RightParen);
            }

            auto fn_call = std::make_unique<FnCallExpr>(name, loc());
            fn_call->args = std::move(args);
            return fn_call;
        }

        // 1. Zero-argument function (PI, RND, INKEY$)
        if (is_func_zero_arg(t.keyword)) {
            auto func_call = std::make_unique<BasicFuncCallExpr>(t.keyword, loc());
            return func_call;
        }

        // 2. One-argument function with parentheses: FUNC(expr)
        if (is_func_one_arg(t.keyword) &&
                match(TokenType::LeftParen)) {
            std::vector<std::unique_ptr<Expr>> args;

            if (!match(TokenType::RightParen)) {
                args.push_back(parse_expr());
                expect(TokenType::RightParen);
            }

            auto func_call = std::make_unique<BasicFuncCallExpr>(t.keyword, loc());
            func_call->args = std::move(args);
            return func_call;
        }

        // 3. One-argument function without parentheses: FUNC expr
        if (is_func_one_arg(t.keyword)) {
            auto arg = parse_unary_expr();
            auto func_call = std::make_unique<BasicFuncCallExpr>(t.keyword, loc());
            func_call->args.push_back(std::move(arg));
            return func_call;
        }

        // 4. Array reference or slice
        if (match(TokenType::LeftParen)) {

            // Check for slice: look for TO anywhere inside the parentheses
            // First: try to parse the "from" expression, but it may be omitted.
            std::unique_ptr<Expr> from_expr;
            std::unique_ptr<Expr> to_expr;

            // Case 1: slice starts with TO (no from-expression)
            if (match(Keyword::TO)) {
                // from_expr stays nullptr
                // parse optional to-expression
                if (!match(TokenType::RightParen)) {
                    to_expr = parse_expr();
                    expect(TokenType::RightParen);
                }
                else {
                    // A$(TO)
                    to_expr = nullptr;
                }

                auto base = std::make_unique<VariableExpr>(name, loc());
                auto slice = std::make_unique<SliceExpr>(std::move(base), loc());
                slice->from = std::move(from_expr);
                slice->to = std::move(to_expr);
                return slice;
            }

            // Case 2: parse a possible from-expression
            from_expr = parse_expr();

            // Now check if this is a slice or an array reference
            if (match(Keyword::TO)) {
                // Slice: from_expr is valid
                // parse optional to-expression
                if (!match(TokenType::RightParen)) {
                    to_expr = parse_expr();
                    expect(TokenType::RightParen);
                }
                else {
                    // A$(m TO)
                    to_expr = nullptr;
                }

                auto base = std::make_unique<VariableExpr>(name, loc());
                auto slice = std::make_unique<SliceExpr>(std::move(base), loc());
                slice->from = std::move(from_expr);
                slice->to = std::move(to_expr);
                return slice;
            }

            // If no TO -> this is an array reference
            std::vector<std::unique_ptr<Expr>> indices;
            indices.push_back(std::move(from_expr));

            while (match(TokenType::Comma)) {
                indices.push_back(parse_expr());
            }

            expect(TokenType::RightParen);

            auto array_ref = std::make_unique<ArrayRefExpr>(name, loc());
            array_ref->indices = std::move(indices);
            return array_ref;
        }

        // 5. Simple variable
        auto var = std::make_unique<VariableExpr>(name, loc());
        return var;
    }

    // Error fallback
    syntax_error("unexpected token '" +
                 peek().text + "' in expression");
}

std::unique_ptr<Expr> Parser::parse_unary_expr() {
    // Unary minus
    if (match(TokenType::Minus)) {
        auto inner = parse_unary_expr();
        auto u = std::make_unique<UnaryExpr>(TokenType::Minus, std::move(inner), loc());
        return u;
    }

    // Unary plus
    if (match(TokenType::Plus)) {
        auto inner = parse_unary_expr();
        return inner;
    }

    // NOT
    if (match(Keyword::NOT)) {
        auto inner = parse_unary_expr();
        auto u = std::make_unique<UnaryExpr>(TokenType::NOT, std::move(inner), loc());
        return u;
    }

    // Otherwise: primary
    return parse_primary();
}

std::unique_ptr<Expr> Parser::parse_pow_expr() {
    auto left = parse_unary_expr();

    while (!at_end_of_stmt() &&
            peek().type == TokenType::Power) {
        TokenType op = peek().type;
        ++pos;
        auto right = parse_unary_expr();
        auto binary = std::make_unique<BinaryExpr>(op, std::move(left),
                      std::move(right), loc());
        left = std::move(binary);
    }

    return left;
}

std::unique_ptr<Expr> Parser::parse_mul_expr() {
    auto left = parse_pow_expr();

    while (!at_end_of_stmt()) {
        TokenType op = peek().type;
        Keyword kw = peek().keyword;

        TokenType binary_op = TokenType::None;

        if (op == TokenType::Multiply || op == TokenType::Divide ||
                op == TokenType::IntDivide) {
            binary_op = op;
        }
        else if (kw == Keyword::DIV) {
            binary_op = TokenType::IntDivide;
        }
        else if (kw == Keyword::MOD) {
            binary_op = TokenType::MOD;
        }

        if (binary_op != TokenType::None) {
            ++pos;
            auto right = parse_pow_expr();
            auto binary = std::make_unique<BinaryExpr>(binary_op, std::move(left),
                          std::move(right), loc());
            left = std::move(binary);
        }
        else {
            break;
        }
    }

    return left;
}

std::unique_ptr<Expr> Parser::parse_add_expr() {
    auto left = parse_mul_expr();

    while (!at_end_of_stmt()) {
        TokenType op = peek().type;
        if (op == TokenType::Plus || op == TokenType::Minus) {
            ++pos;
            auto right = parse_mul_expr();
            auto binary = std::make_unique<BinaryExpr>(op, std::move(left),
                          std::move(right), loc());
            left = std::move(binary);
        }
        else {
            break;
        }
    }

    return left;
}

std::unique_ptr<Expr> Parser::parse_rel_expr() {
    auto left = parse_add_expr();

    while (!at_end_of_stmt()) {
        TokenType op = peek().type;
        if (op == TokenType::Equal || op == TokenType::NotEqual ||
                op == TokenType::Less || op == TokenType::LessEqual ||
                op == TokenType::Greater || op == TokenType::GreaterEqual) {
            ++pos;
            auto right = parse_add_expr();
            auto binary = std::make_unique<BinaryExpr>(op, std::move(left),
                          std::move(right), loc());
            left = std::move(binary);
        }
        else {
            break;
        }
    }

    return left;
}

std::unique_ptr<Expr> Parser::parse_and_expr() {
    auto left = parse_rel_expr();

    while (!at_end_of_stmt() && peek().keyword == Keyword::AND) {
        TokenType op = TokenType::AND;
        ++pos;
        auto right = parse_rel_expr();
        auto binary = std::make_unique<BinaryExpr>(op, std::move(left),
                      std::move(right), loc());
        left = std::move(binary);
    }

    return left;
}

std::unique_ptr<Expr> Parser::parse_or_expr() {
    auto left = parse_and_expr();

    while (!at_end_of_stmt() &&
            peek().keyword == Keyword::OR) {
        TokenType op = TokenType::OR;
        ++pos;
        auto right = parse_and_expr();
        auto binary = std::make_unique<BinaryExpr>(op, std::move(left),
                      std::move(right), loc());
        left = std::move(binary);
    }

    return left;
}

std::unique_ptr<Expr> Parser::parse_expr() {
    return parse_or_expr();
}

std::unique_ptr<Expr> Parser::parse_assignable() {
    // Must start with identifier that is not end of statement
    if (at_end()) {
        syntax_error("expected variable name, found end of line");
    }
    if (peek().type != TokenType::Identifier || at_end_of_stmt()) {
        syntax_error("expected variable name, found '"
                     + peek().text + "'");
    }

    // name is A or A$ (string variable)
    std::string name = peek().text;
    bool is_string = is_string_variable(name);
    pos++;

    // First: parse base as either variable or array ref
    std::unique_ptr<Expr> base;

    // '(' after name -> either array ref or slice
    if (peek().type == TokenType::LeftParen &&
            !has_TO(line().tokens, pos + 1)) {

        // it's an array reference A(i, j, ...)
        pos++; // consume '('

        std::vector<std::unique_ptr<Expr>> indices;
        while (true) {
            auto idx = parse_expr();
            indices.push_back(std::move(idx));

            if (match(TokenType::Comma)) {
                continue;
            }
            break;
        }
        expect(TokenType::RightParen);

        auto arr = std::make_unique<ArrayRefExpr>(name, loc());
        arr->indices = std::move(indices);
        base = std::move(arr);
    }
    else {
        // Simple variable A or A$
        auto var = std::make_unique<VariableExpr>(name, loc());
        base = std::move(var);
    }

    // Now check for a trailing slice: base(... TO ...)
    // e.g. A$(I,J)(1 TO 3) or A$(1 TO 2) when we already parsed A$ as base
    if (is_string &&
            peek().type == TokenType::LeftParen &&
            has_TO(line().tokens, pos + 1)) {

        pos++; // consume '('

        std::unique_ptr<Expr> from = nullptr;
        if (peek().keyword != Keyword::TO) {
            from = parse_expr();
        }

        expect(Keyword::TO);

        std::unique_ptr<Expr> to = nullptr;
        if (peek().type != TokenType::RightParen) {
            to = parse_expr();
        }
        expect(TokenType::RightParen);

        auto slice = std::make_unique<SliceExpr>(std::move(base), loc());
        slice->from = std::move(from);
        slice->to = std::move(to);
        return slice;
    }

    // No slice -> just variable or array ref
    return base;
}

bool Parser::parse() {
    Keyword stop_kw = Keyword::None;
    parse_stmt_block({}, stop_kw, prog.stmts);
    return get_error_count() == 0;
}

bool Parser::is_func_one_arg(Keyword keyword) {
    static const std::unordered_set<Keyword> funcs = {
        Keyword::CODE, Keyword::VAL,
        Keyword::LEN,
        Keyword::SIN, Keyword::COS, Keyword::TAN,
        Keyword::ASN, Keyword::ACS, Keyword::ATN,
        Keyword::LN, Keyword::EXP, Keyword::INT, Keyword::SQR,
        Keyword::SGN, Keyword::ABS, Keyword::PEEK, Keyword::USR,
        Keyword::STR_DLR, Keyword::CHR_DLR,
        Keyword::PEEKW,
    };
    return funcs.count(keyword) > 0;
}

bool Parser::is_func_zero_arg(Keyword keyword) {
    static const std::unordered_set<Keyword> funcs = {
        Keyword::RND, Keyword::INKEY_DLR, Keyword::PI,
    };
    return funcs.count(keyword) > 0;
}

bool Parser::has_TO(const std::vector<Token>& tokens, size_t pos) {
    int depth = 0;

    while (pos < tokens.size()) {
        if (tokens[pos].type == TokenType::LeftParen) {
            depth++;
        }

        if (tokens[pos].type == TokenType::RightParen) {
            if (depth == 0) {
                return false;
            }
            depth--;
            if (depth == 0) {
                return false;
            }
        }

        if (tokens[pos].keyword == Keyword::TO && depth == 0) {
            return true;
        }

        ++pos;
    }
    return false;
}

void Parser::parse_stmt_block(const std::unordered_set<Keyword>& stop_keywords,
                              Keyword& out_stop_keyword,
                              std::vector<std::unique_ptr<Stmt>>& out_stmts) {
    while (cur_line < tok_file.lines.size()) {
        try {
            out_stop_keyword = Keyword::None;
            parse_stmt_line(stop_keywords, out_stop_keyword, out_stmts);
            if (out_stop_keyword != Keyword::None) {
                return;
            }
        }
        catch (const ParseError&) {
            // syntax_error() already reported the error
        }

        cur_line++;
        pos = 0;
    }
}

void Parser::parse_stmt_line(const std::unordered_set<Keyword>& stop_keywords,
                             Keyword& out_stop_keyword,
                             std::vector<std::unique_ptr<Stmt>>& out_stmts) {
    // if line is ASM, create and parse a RemStmt
    if (line().source_type == SourceType::ASM) {
        auto rem_stmt = create_rem_stmt();
        if (rem_stmt) {
            out_stmts.push_back(std::move(rem_stmt));
        }
        return;
    }

    // source type is BASIC, parse line number and label if any
    release_assert(line().source_type == SourceType::BASIC);
    std::string label;
    int basic_line_num = -1;
    if (parse_label_line_num(label, basic_line_num)) {
        auto jump_target_stmt =
            std::make_unique<JumpTargetStmt>(loc(), label, basic_line_num);
        out_stmts.push_back(std::move(jump_target_stmt));
    }

    // parse a colon-sepatated statement list
    parse_stmt_list(stop_keywords, out_stop_keyword, out_stmts);
}

void Parser::parse_stmt_list(const std::unordered_set<Keyword>& stop_keywords,
                             Keyword& out_stop_keyword,
                             std::vector<std::unique_ptr<Stmt>>& out_stmts) {
    while (!at_end()) {
        if (peek().type == TokenType::Colon) {
            pos++;  // skip colons
            continue;
        }

        // check for a stop-keyword (end of block)
        if (!stop_keywords.empty()) {
            Keyword kw = peek().keyword;
            if (kw != Keyword::None && stop_keywords.count(kw) > 0) {
                out_stop_keyword = kw;
                pos++;
                return;
            }
        }

        // parse a statement
        std::unique_ptr<Stmt> stmt = parse_stmt();
        if (stmt) {
            out_stmts.push_back(std::move(stmt));
        }
    }
}

std::unique_ptr<Stmt> Parser::parse_stmt() {
    std::unique_ptr<Stmt> stmt;

    // BASIC pragma statement
    if (peek().type == TokenType::Exclamation ||
            peek().type == TokenType::Hash) {
        pos++;  // consume '!' or '#'
        const Token& keyword_tok = expect(TokenType::Identifier);
        auto it = pragma_parsers_lut.find(keyword_tok.keyword);
        if (it != pragma_parsers_lut.end()) {
            StmtParser fn = it->second;
            stmt = (this->*fn)();
            check_end_of_stmt();
            return stmt;
        }
        else {
            syntax_error("unrecognized pragma statement '" + keyword_tok.text + "'");
        }
    }

    // BASIC statement
    auto it = stmt_parsers_lut.find(peek().keyword);
    if (it != stmt_parsers_lut.end()) {
        pos++;  // consume keyword
        StmtParser fn = it->second;
        auto stmt = (this->*fn)();
        check_end_of_stmt();
        return stmt;
    }

    // check for procedure call: PROCname(args) or PROCname args or PROCname
    if (!at_end_of_stmt() &&            // UNTIL cannot be assigned to
            peek(0).type == TokenType::Identifier &&
            str_toupper(peek(0).text).compare(0, 4, "PROC") == 0 &&
            peek(1).type != TokenType::Equal) {
        auto stmt = parse_stmt_proc_call();  // parse as a PROC call statement
        check_end_of_stmt();
        return stmt;
    }

    // check for variable assignment: A = expr (maybe PROCname = expr for return value)
    if (!at_end_of_stmt() &&            // UNTIL cannot be assigned to
            peek(0).type == TokenType::Identifier &&
            peek(1).type == TokenType::Equal) {
        auto stmt = parse_stmt_let();  // parse as a LET statement
        check_end_of_stmt();
        return stmt;
    }

    // check for variable assignment: A$(1 TO 3) = expr
    if (!at_end_of_stmt() &&            // UNTIL cannot be assigned to
            peek().type == TokenType::Identifier) {
        size_t save_pos = pos;
        std::unique_ptr<Expr> assignable = parse_assignable();
        if (peek().type == TokenType::Equal) {
            pos = save_pos;                 // restore position to parse as a LET statement
            auto stmt = parse_stmt_let();   // parse as a LET statement
            check_end_of_stmt();
            return stmt;
        }
        pos = save_pos;  // restore position if not an assignment
    }

    // fall through : unrecognized statement
    if (peek().type == TokenType::Identifier) {
        syntax_error("unrecognized statement '" + peek().text + "'");
    }
    else {
        syntax_error("expected a BASIC language statement, found '" +
                     peek().text + "'");
    }
    return nullptr;
}

bool Parser::parse_label_line_num(std::string& out_label,
                                  int& out_basic_line_num) {
    bool found_label = false;
    bool found_line_num = false;
    bool found_any = true;
    while (found_any) {
        found_any = false;

        if (peek().type == TokenType::At) {
            pos++;
            const Token& label_token = expect(TokenType::Identifier);
            expect(TokenType::Colon);

            if (found_label) {
                syntax_error("multiple labels in the same line are not allowed");
            }
            out_label = label_token.text;
            found_label = true;
            found_any = true;
        }

        if (peek().type == TokenType::Integer) {
            if (found_line_num) {
                syntax_error("multiple line numbers in the same line are not allowed");
            }
            out_basic_line_num = peek().ivalue;
            pos++;
            found_line_num = true;
            found_any = true;
        }
    }
    return found_label || found_line_num;
}

std::unique_ptr<Stmt> Parser::create_rem_stmt() {
    // create virtual REM statement
    TokLine rem_line;
    rem_line.source_type = SourceType::BASIC;
    rem_line.src_line.text = "REM";
    rem_line.src_line.loc = loc();
    tokenize_line(rem_line.src_line.text, rem_line.source_type,
                  rem_line.src_line.loc,
                  rem_line.tokens);

    auto stmt = std::make_unique<RemStmt>(rem_line.src_line.loc);
    collect_asm_lines(cur_line, stmt->asm_lines);
    return stmt;
}

void Parser::collect_asm_lines(size_t start_line,
                               std::vector<TokLine>& out_asm_lines) {
    bool collected = false;
    size_t last_line = 0;

    for (size_t i = start_line; i < tok_file.lines.size(); ++i) {
        if (tok_file.lines[i].source_type == SourceType::ASM) {
            out_asm_lines.push_back(tok_file.lines[i]);
            collected = true;
            last_line = i;
        }
        else {
            break;
        }
    }

    // point to last asm line collected, so that the main loop can continue from there
    if (collected) {
        cur_line = last_line;
        pos = line().tokens.size();
    }
}

std::unique_ptr<Stmt> Parser::parse_pragma_autostart() {
    expect(TokenType::Equal);

    // #AUTOSTART = 0 or 1
    const Token& num_tok = expect(TokenType::Integer);
    prog.auto_start = num_tok.ivalue != 0;
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_autostart_line() {
    expect(TokenType::Equal);

    // #AUTOSTART_LINE = line_number
    if (peek().type == TokenType::Integer) {
        prog.auto_start_line = peek().ivalue;
        pos++;
        return nullptr;
    }

    // #AUTOSTART_LINE = label_name
    if (peek().type == TokenType::At) {
        pos++;
        const Token& ident = expect(TokenType::Identifier);
        prog.auto_start_label = ident.text;
        return nullptr;
    }

    syntax_error("expected '= number|@label' after '#AUTOSTART_LINE'");
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_increment() {
    // #INCREMENT = number
    expect(TokenType::Equal);
    const Token& num = expect(TokenType::Integer);
    if (num.ivalue < 1) {
        syntax_error("#INCREMENT must be positive");
    }
    prog.increment = num.ivalue;
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_reminvert() {
    // #REMINVERT = 0 or 1
    expect(TokenType::Equal);
    const Token& num = expect(TokenType::Integer);
    prog.rem_invert = num.ivalue != 0;
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_fast() {
    // #FAST = 0 or 1
    expect(TokenType::Equal);
    const Token& num = expect(TokenType::Integer);
    prog.fast_mode = num.ivalue != 0;
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_verbose() {
    // #VERBOSE = 0 or 1
    expect(TokenType::Equal);
    const Token& num = expect(TokenType::Integer);
    g_verbose = num.ivalue != 0;
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_vars() {
    // parse var[$][(n,n...,n)]
    std::string name;
    std::vector<int> dims;
    parse_vars_def(name, dims);
    expect(TokenType::Equal);

    if (is_string_variable(name)) {
        if (dims.size() == 0) {
            // #VARS A$="XXX"
            auto stmt = std::make_unique<PragmaStrVarStmt>(loc());
            stmt->name = name;
            const Token& str = expect(TokenType::StringLiteral);
            stmt->value = str.svalue;
            collect_asm_lines(cur_line + 1, stmt->asm_lines);
            return stmt;
        }
        else {
            // #VARS A$(n,n,...,n)="XXX","XXX",...
            auto stmt = std::make_unique<PragmaStrVarArrayStmt>(loc());
            stmt->name = name;
            stmt->dims = std::move(dims);
            while (true) {
                const Token& str = expect(TokenType::StringLiteral);
                stmt->values.push_back(str.svalue);
                if (match(TokenType::Comma)) {
                    continue;
                }
                else {
                    break;
                }
            }
            return stmt;
        }
    }
    else {
        if (dims.size() == 0) {
            // #VARS A=123
            auto stmt = std::make_unique<PragmaNumVarStmt>(loc());
            stmt->name = name;
            if (peek().type == TokenType::Integer) {
                const Token& num = expect(TokenType::Integer);
                stmt->value = num.ivalue;
            }
            else {
                const Token& num = expect(TokenType::Float);
                stmt->value = num.nvalue;
            }
            return stmt;
        }
        else {
            // #VARS A(n,n,...,n)=123,456,...
            auto stmt = std::make_unique<PragmaNumVarArrayStmt>(loc());
            stmt->name = name;
            stmt->dims = std::move(dims);
            while (true) {
                if (peek().type == TokenType::Integer) {
                    const Token& num = expect(TokenType::Integer);
                    stmt->values.push_back(num.ivalue);
                }
                else {
                    const Token& num = expect(TokenType::Float);
                    stmt->values.push_back(num.nvalue);
                }
                if (match(TokenType::Comma)) {
                    continue;
                }
                else {
                    break;
                }
            }
            return stmt;
        }
    }
}

void Parser::parse_vars_def(std::string& out_var_name,
                            std::vector<int>& out_dims) {
    out_dims.clear();

    // variable name
    const Token& ident = expect(TokenType::Identifier);
    out_var_name = ident.text;

    // either '(' for array or '=' for plain variable
    if (peek().type == TokenType::LeftParen) {
        pos++;  // skip '('
        while (true) {
            const Token& num = expect(TokenType::Integer);
            out_dims.push_back(num.ivalue);
            if (match(TokenType::Comma)) {
                continue;
            }
            else {
                break;
            }
        }
        expect(TokenType::RightParen);
    }
    // end with pos pointing at the '='
}

std::unique_ptr<Stmt> Parser::parse_pragma_dfile() {
    // #DFILE = "line 1", "line 2", ...
    expect(TokenType::Equal);
    prog.dfile_lines.clear();
    while (true) {
        const Token& str = expect(TokenType::StringLiteral);
        prog.dfile_lines.push_back(str.svalue);
        if (match(TokenType::Comma)) {
            continue;
        }
        else {
            break;
        }
    }
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_dfile_colapsed() {
    // #DFILE_COLAPSED = 0 or 1
    expect(TokenType::Equal);
    const Token& num = expect(TokenType::Integer);
    prog.dfile_colapsed = num.ivalue != 0;
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_pragma_sysvars() {
    // !SYSVARS = nn,nn,nn,...
    expect(TokenType::Equal);
    prog.sysvars_data.clear();
    while (true) {
        const Token& num = expect(TokenType::Integer);
        if (num.ivalue > 255) {
            syntax_error("values must be in range 0..255, found " +
                         std::to_string(num.ivalue));
        }
        prog.sysvars_data.push_back(static_cast<uint8_t>(num.ivalue));
        if (match(TokenType::Comma)) {
            continue;
        }
        else {
            break;
        }
    }
    return nullptr;
}

std::unique_ptr<Stmt> Parser::parse_stmt_let() {
    // Parse LHS assignable expression
    auto lhs = parse_assignable();
    expect(TokenType::Equal);

    // Parse RHS expression
    auto rhs = parse_expr();

    // Build AST node
    auto stmt = std::make_unique<LetStmt>(loc());
    stmt->lhs = std::move(lhs);
    stmt->rhs = std::move(rhs);

    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_dim() {
    auto stmt = std::make_unique<DimStmt>(loc());
    while (true) {
        auto item = parse_dim_item();
        stmt->items.push_back(std::move(*item));

        if (match(TokenType::Comma)) {
            continue;
        }
        break;
    }

    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_rem() {
    auto stmt = std::make_unique<RemStmt>(loc());

    // concatenate all remaining tokens in the line into a
    // single string for the REM statement
    // include the whitespace before each token to preserve the original formatting
    std::string text;
    while (!at_end()) {
        text += peek().ws_before + peek().text;
        pos++;
    }

    // remove the first blank after REM
    if (!text.empty() && isspace(text[0])) {
        text.erase(0, 1);
    }

    stmt->text = text;
    check_end_of_stmt();

    // collect assembly following REM
    collect_asm_lines(cur_line + 1, stmt->asm_lines);

    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_run() {
    auto stmt = std::make_unique<RunStmt>(loc());

    // Parse expression, if any
    if (!at_end_of_stmt()) {
        stmt->target_expr = parse_expr();
    }

    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_list() {
    auto stmt = std::make_unique<ListStmt>(loc());

    // Parse expression, if any
    if (!at_end_of_stmt()) {
        stmt->target_expr = parse_expr();
    }

    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_new() {
    return std::make_unique<NewStmt>(loc());
}

std::unique_ptr<Stmt> Parser::parse_stmt_cls() {
    return std::make_unique<ClsStmt>(loc());
}

std::unique_ptr<Stmt> Parser::parse_stmt_load() {
    auto stmt = std::make_unique<LoadStmt>(loc());
    stmt->filename_expr = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_save() {
    auto stmt = std::make_unique<SaveStmt>(loc());
    stmt->filename_expr = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_poke() {
    auto stmt = std::make_unique<PokeStmt>(loc());
    stmt->address = parse_expr();
    expect(TokenType::Comma);
    stmt->value = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_pokew() {
    auto stmt = std::make_unique<PokewStmt>(loc());
    stmt->address = parse_expr();
    expect(TokenType::Comma);
    stmt->value = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_plot() {
    auto stmt = std::make_unique<PlotStmt>(loc());
    stmt->x_expr = parse_expr();
    expect(TokenType::Comma);
    stmt->y_expr = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_unplot() {
    auto stmt = std::make_unique<UnplotStmt>(loc());
    stmt->x_expr = parse_expr();
    expect(TokenType::Comma);
    stmt->y_expr = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_rand() {
    auto stmt = std::make_unique<RandStmt>(loc());
    stmt->seed_expr = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_pause() {
    auto stmt = std::make_unique<PauseStmt>(loc());
    stmt->duration_expr = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_fast() {
    auto stmt = std::make_unique<FastStmt>(loc());
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_slow() {
    auto stmt = std::make_unique<SlowStmt>(loc());
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_scroll() {
    return std::make_unique<ScrollStmt>(loc());
}

std::unique_ptr<Stmt> Parser::parse_stmt_cont() {
    return std::make_unique<ContStmt>(loc());
}

std::unique_ptr<Stmt> Parser::parse_stmt_clear() {
    return std::make_unique<ClearStmt>(loc());
}

std::unique_ptr<Stmt> Parser::parse_stmt_exit() {
    return std::make_unique<ExitStmt>(loc());
}

std::unique_ptr<Stmt> Parser::parse_stmt_goto() {
    auto stmt = std::make_unique<GotoStmt>(loc());
    stmt->target_expr = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_gosub() {
    auto stmt = std::make_unique<GosubStmt>(loc());
    stmt->target_expr = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_return() {
    return std::make_unique<ReturnStmt>(loc());
}

std::unique_ptr<Stmt> Parser::parse_stmt_stop() {
    return std::make_unique<StopStmt>(loc());
}

std::unique_ptr<Stmt> Parser::parse_stmt_end() {
    return std::make_unique<EndStmt>(loc());
}

std::unique_ptr<Stmt> Parser::parse_stmt_print() {
    auto stmt = std::make_unique<PrintStmt>(loc());
    while (!at_end_of_stmt()) {
        PrintItem item;

        if (match(TokenType::Comma)) {
            item.type = PrintItem::Type::Comma;
        }
        else if (match(TokenType::Semicolon)) {
            item.type = PrintItem::Type::Semicolon;
        }
        else if (match(Keyword::AT)) {
            item.type = PrintItem::Type::At;
            item.line_expr = parse_expr();
            expect(TokenType::Comma);
            item.col_expr = parse_expr();
        }
        else if (match(Keyword::TAB)) {
            item.type = PrintItem::Type::Tab;
            item.tab_expr = parse_expr();
        }
        else {
            item.type = PrintItem::Type::Expr;
            item.expr = parse_expr();
        }

        stmt->items.push_back(std::move(item));
    }
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_input() {
    auto stmt = std::make_unique<InputStmt>(loc());
    while (true) {
        auto var = parse_assignable();
        stmt->vars.push_back(std::move(var));

        if (match(TokenType::Comma)) {
            continue;
        }
        break;
    }
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_if() {
    auto condition = parse_expr();
    expect(Keyword::THEN);

    auto stmt = std::make_unique<IfStmt>(loc());
    stmt->condition = std::move(condition);

    // THEN at end of line -> block form:
    // IF condition THEN
    //   statements
    // [ELSE
    //   statements]
    // ENDIF
    if (at_end()) {
        Keyword terminator = Keyword::None;
        parse_stmt_block({Keyword::ELSE, Keyword::ENDIF},
                         terminator,
                         stmt->then_stmts);
        if (terminator == Keyword::None) {
            syntax_error("expected 'ENDIF'");
        }

        if (terminator == Keyword::ELSE) {
            parse_stmt_block({Keyword::ENDIF},
                             terminator,
                             stmt->else_stmts);
            if (terminator == Keyword::None) {
                syntax_error("expected 'ENDIF'");
            }
        }

        return stmt;
    }

    // parse statements until ELSE or end of line
    Keyword terminator = Keyword::None;
    parse_stmt_list({Keyword::ELSE},
                    terminator,
                    stmt->then_stmts);

    // optional ELSE branch
    if (!at_end() && terminator == Keyword::ELSE) {
        parse_stmt_list({Keyword::ELSE},
                        terminator,
                        stmt->else_stmts);
    }

    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_repeat() {
    auto stmt = std::make_unique<RepeatStmt>(loc());

    // REPEAT at end of line -> block form:
    // REPEAT
    //   statements
    // UNTIL condition
    if (at_end()) {
        Keyword terminator = Keyword::None;
        parse_stmt_block({Keyword::UNTIL},
                         terminator,
                         stmt->body);
        if (terminator == Keyword::None) {
            syntax_error("expected 'UNTIL'");
        }
        stmt->condition = parse_expr();
        return stmt;
    }

    // inline form: REPEAT statement:statement...statement UNTIL condition
    Keyword terminator = Keyword::None;
    parse_stmt_list({Keyword::UNTIL},
                    terminator,
                    stmt->body);
    if (terminator != Keyword::UNTIL) {
        syntax_error("expected 'UNTIL'");
    }
    stmt->condition = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_while() {
    auto condition = parse_expr();

    auto stmt = std::make_unique<WhileStmt>(loc());
    stmt->condition = std::move(condition);

    // WHILE condition at end of line -> block form:
    // WHILE condition
    //   statements
    // WEND
    if (at_end()) {
        Keyword terminator = Keyword::None;
        parse_stmt_block({ Keyword::WEND },
                         terminator,
                         stmt->body);
        if (terminator == Keyword::None) {
            syntax_error("expected 'WEND'");
        }
        return stmt;
    }

    // inline form: WHILE condition : statement:statement...statement WEND
    Keyword terminator = Keyword::None;
    parse_stmt_list({ Keyword::WEND },
                    terminator,
                    stmt->body);
    if (terminator != Keyword::WEND) {
        syntax_error("expected 'WEND'");
    }
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_for() {
    if (at_end_of_stmt()) {		// guard against FOR UNTIL=...
        syntax_error("expected variable name, found '" + peek().text + "'");
    }
    const Token& ident = expect(TokenType::Identifier);
    std::string name = ident.text;
    if (is_string_variable(name)) {
        syntax_error("FOR variable cannot be a string variable");
    }
    expect(TokenType::Equal);
    auto start_expr = parse_expr();
    expect(Keyword::TO);
    auto end_expr = parse_expr();

    std::unique_ptr<Expr> step_expr;
    if (match(Keyword::STEP)) {
        step_expr = parse_expr();
    }
    else {
        auto default_step = std::make_unique<NumberExpr>(1.0, loc());
        step_expr = std::move(default_step);
    }

    auto stmt = std::make_unique<ForStmt>(loc());
    stmt->name = name;
    stmt->start_expr = std::move(start_expr);
    stmt->end_expr = std::move(end_expr);
    stmt->step_expr = std::move(step_expr);

    // FOR ... at end of line -> block form:
    // FOR var=start TO end [STEP step]
    //   statements
    // NEXT var
    if (at_end()) {
        Keyword terminator = Keyword::None;
        parse_stmt_block({ Keyword::NEXT },
                         terminator,
                         stmt->body);
        if (terminator == Keyword::None) {
            syntax_error("missing NEXT");
        }
        if (!at_end_of_stmt() && peek().type == TokenType::Identifier) {
            std::string next_var = peek().text;
            if (next_var != name) {
                syntax_error("NEXT variable '" + next_var +
                             "' does not match FOR variable '" + name + "'");
            }
            pos++; // consume variable
        }
        return stmt;
    }

    // inline form: FOR var=start TO end STEP step : statement:...:NEXT [var]
    Keyword terminator = Keyword::None;
    parse_stmt_block({ Keyword::NEXT },
                     terminator,
                     stmt->body);
    if (terminator == Keyword::None) {
        syntax_error("missing NEXT");
    }
    if (!at_end_of_stmt() && peek().type == TokenType::Identifier) {
        std::string next_var = peek().text;
        if (next_var != name) {
            syntax_error("NEXT variable '" + next_var +
                         "' does not match FOR variable '" + name + "'");
        }
        pos++; // consume variable
    }
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_def() {
    const Token& ident = expect(TokenType::Identifier);
    if (str_toupper(ident.text).compare(0, 4, "PROC") == 0) {
        return parse_stmt_def_proc(ident.text);
    }
    else if (str_toupper(ident.text).compare(0, 2, "FN") == 0) {
        return parse_stmt_def_fn(ident.text);
    }
    else {
        syntax_error("expected PROCname or FNname, found '" + ident.text + "'");
        return nullptr;
    }
}

std::unique_ptr<Stmt> Parser::parse_stmt_def_proc(const std::string& name) {
    auto stmt = std::make_unique<DefProcStmt>(loc());
    stmt->name = name;

    expect(TokenType::LeftParen);

    // possibly empty list of numeric variable identifiers
    if (peek().type != TokenType::RightParen) {
        while (true) {
            const Token& param = expect(TokenType::Identifier);
            std::string name = param.text;
            if (is_string_variable(name)) {
                syntax_error("string variable '" + name +
                             "' not allowed as parameter in DEF PROC statement");
            }

            stmt->params.push_back(name);
            if (match(TokenType::Comma)) {
                continue;
            }
            break;
        }
    }

    expect(TokenType::RightParen);
    check_end_of_stmt();

    // collect statements up to a single ENDPROC statement alone in a line
    Keyword terminator = Keyword::None;
    parse_stmt_block({ Keyword::ENDPROC },
                     terminator,
                     stmt->body);
    if (terminator == Keyword::None) {
        syntax_error("expected ENDPROC");
    }

    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_def_fn(const std::string& name) {
    auto stmt = std::make_unique<DefFnStmt>(loc());
    stmt->name = name;

    expect(TokenType::LeftParen);

    // possibly empty list of numeric variable identifiers
    if (peek().type != TokenType::RightParen) {
        while (true) {
            const Token& param = expect(TokenType::Identifier);
            std::string name = param.text;
            if (is_string_variable(name)) {
                syntax_error("string variable '" + name +
                             "' not allowed as parameter in DEF FN statement");
            }

            stmt->params.push_back(name);

            if (match(TokenType::Comma)) {
                continue;
            }
            break;
        }
    }

    expect(TokenType::RightParen);
    expect(TokenType::Equal);

    stmt->expr = parse_expr();
    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_proc_call() {
    const Token& ident = expect(TokenType::Identifier);

    auto stmt = std::make_unique<ProcCallStmt>(loc());
    stmt->name = ident.text;

    bool has_parens = peek().type == TokenType::LeftParen;
    if (has_parens) {
        pos++; // consume '('
    }

    // check for empty argument list before attempting to parse an expression:
    // PROCname / PROCname() -> no arguments
    // PROCname 10,20 / PROCname(10,20) -> list of expressions
    bool no_args = has_parens ? (peek().type == TokenType::RightParen)
                   : at_end_of_stmt();

    if (!no_args) {
        while (true) {
            auto arg = parse_expr();
            stmt->args.push_back(std::move(arg));

            if (match(TokenType::Comma)) {
                continue;
            }
            break;
        }
    }

    if (has_parens) {
        expect(TokenType::RightParen);
    }

    return stmt;
}

std::unique_ptr<Stmt> Parser::parse_stmt_local() {
    auto stmt = std::make_unique<LocalStmt>(loc());
    while (true) {
        const Token& ident = expect(TokenType::Identifier);
        std::string name = ident.text;
        if (is_string_variable(name)) {
            syntax_error("string variable '" + name + "' not allowed in LOCAL statement");
        }
        if (std::find(stmt->locals.begin(), stmt->locals.end(),
                      name) == stmt->locals.end()) {
            stmt->locals.push_back(name);
        }
        if (match(TokenType::Comma)) {
            continue;
        }
        break;
    }
    return stmt;
}

std::unique_ptr<DimItem> Parser::parse_dim_item() {
    const Token& ident = expect(TokenType::Identifier);
    auto item = std::make_unique<DimItem>();
    item->name = ident.text;
    expect(TokenType::LeftParen);
    while (true) {
        auto dim_expr = parse_expr();
        item->dims.push_back(std::move(dim_expr));

        if (match(TokenType::Comma)) {
            continue;
        }
        break;
    }
    expect(TokenType::RightParen);
    return item;
}

[[noreturn]]
void Parser::syntax_error(const std::string& msg) const {
    if (tok_file.lines.empty()) {
        error(msg);
    }
    else if (cur_line >= tok_file.lines.size()) {
        size_t last_line = tok_file.lines.size() - 1;
        SourceLoc error_loc = tok_file.lines[last_line].src_line.loc;
        error_loc.line_num++;
        error(error_loc, msg);
    }
    else {
        const Token& tok = at_end()
                           ? line().tokens.back()
                           : peek();
        error(tok.loc, msg);
    }
    throw ParseError(msg);
}

bool parse_basic_program(const TokFile& tok_file,
                         std::unique_ptr<Prog>& out_prog) {
    auto prog = std::make_unique<Prog>();

    Parser parser{ *prog, tok_file, 0, 0 };
    bool ok = parser.parse();
    if (ok) {
        out_prog = std::move(prog);
    }

#ifdef _DEBUG
    if (g_dump_step == 5) {
        if (ok) {
            DumpContext ctx(std::cout);
            out_prog->dump(ctx);
            exit(EXIT_SUCCESS);
        }
        else {
            std::cout << "Parsing failed with errors." << std::endl;
            exit(EXIT_FAILURE);
        }
    }
#endif

    return ok;
}

