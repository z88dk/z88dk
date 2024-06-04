//-----------------------------------------------------------------------------
// z80asm - expressions
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "common.h"
#include "expr.h"
#include "symtab.h"
#include "utils.h"
#include "xassert.h"
using namespace std;

//-----------------------------------------------------------------------------

class ExprException : public exception {
public:
    ExprException(ErrCode err_code, const string& err_arg = "");

    ErrCode err_code() const;
    const string& err_arg() const;
    void error();

private:
    ErrCode err_code_{ ErrOk };			// error message during expression parsing
    string	err_arg_;					// argument for error message
};

ExprException::ExprException(ErrCode err_code, const string& err_arg)
    : err_code_(err_code), err_arg_(err_arg) {
}

ErrCode ExprException::err_code() const {
    return err_code_;
}

const string& ExprException::err_arg() const {
    return err_arg_;
}

void ExprException::error() {
    g_errors.error(err_code_, err_arg_);
}

//-----------------------------------------------------------------------------

ExprResult::ExprResult(sym_type_t type, int value, ErrCode err_code, const string& err_arg)
    : type_(type), value_(value), err_code_(err_code), err_arg_(err_arg) {
}

sym_type_t ExprResult::type() const {
    return type_;
}

int ExprResult::value() const {
    return value_;
}

Section* ExprResult::section() const {
    return section_;
}

bool ExprResult::multi_section() const {
    return multi_section_;
}

bool ExprResult::ok() const {
    return err_code_ == ErrOk;
}

ErrCode ExprResult::err_code() const {
    return err_code_;
}

const string& ExprResult::err_arg() const {
    return err_arg_;
}

void ExprResult::error() {
    if (!ok())
        g_errors.error(err_code_, err_arg_);
}

void ExprResult::set_type(sym_type_t type) {
    type_ = type;
}

void ExprResult::set_value(int value) {
    value_ = value;
}

void ExprResult::set_section(Section* section) {
    section_ = section;
}

void ExprResult::set_multi_section(bool f) {
    multi_section_ = f;
}

void ExprResult::set_error(ErrCode err_code, const string& err_arg) {
    err_code_ = err_code;
    err_arg_ = err_arg;
}

ExprResult ExprResult::combine(const ExprResult& a, const ExprResult& b, TkCode op, int value) {
    ExprResult res;

    // merge type
    switch (a.type()) {
    case TYPE_UNDEFINED:
        res.set_type(TYPE_UNDEFINED);
        break;
    case TYPE_CONSTANT:
        switch (b.type()) {
        case TYPE_UNDEFINED:
            res.set_type(TYPE_UNDEFINED);
            break;
        case TYPE_CONSTANT:
            res.set_type(TYPE_CONSTANT);
            break;
        case TYPE_ADDRESS:
            res.set_type(TYPE_ADDRESS);
            res.set_section(b.section());
            res.set_multi_section(b.multi_section());
            break;
        case TYPE_COMPUTED:
            res.set_type(TYPE_COMPUTED);
            break;
        default:
            xassert(0);
        }
        break;
    case TYPE_ADDRESS:
        switch (b.type()) {
        case TYPE_UNDEFINED:
            res.set_type(TYPE_UNDEFINED);
            break;
        case TYPE_CONSTANT:
            res.set_type(TYPE_ADDRESS);
            res.set_section(a.section());
            res.set_multi_section(a.multi_section());
            break;
        case TYPE_ADDRESS:
            if (a.multi_section() || b.multi_section()) {
                res.set_section(nullptr);
                res.set_multi_section();
            }
            else if (a.section() != b.section()) {
                res.set_section(nullptr);
                res.set_multi_section();
            }
            else if (op == TK_MINUS) {
                res.set_type(TYPE_CONSTANT);
            }
            else {
                res.set_type(TYPE_COMPUTED);
            }
            break;
        case TYPE_COMPUTED:
            res.set_type(TYPE_COMPUTED);
            break;
        default:
            xassert(0);
        }
        break;
    case TYPE_COMPUTED:
        switch (b.type()) {
        case TYPE_UNDEFINED:
            res.set_type(TYPE_UNDEFINED);
            break;
        case TYPE_CONSTANT:
            res.set_type(TYPE_COMPUTED);
            break;
        case TYPE_ADDRESS:
            res.set_type(TYPE_COMPUTED);
            break;
        case TYPE_COMPUTED:
            res.set_type(TYPE_COMPUTED);
            break;
        default:
            xassert(0);
        }
        break;
    default:
        xassert(0);
    }

    // set value
    res.set_value(value);

    // merge errors
    if (!a.ok())
        res.set_error(a.err_code(), a.err_arg());
    else if (!b.ok())
        res.set_error(b.err_code(), b.err_arg());
    else
        res.set_error(ErrOk);

    return res;
}

//-----------------------------------------------------------------------------

Expr::Expr(const string& expr_text) {
    section_ = &g_section();
    Lexer lexer(expr_text);
    if (!parse_expr(&lexer))
        g_errors.error(ErrSyntaxExpr, expr_text);
}

Expr* Expr::clone() const {
    Expr* copy = new Expr();
    copy->text_ = text_;
    copy->section_ = section_;
    copy->rpn_tokens_.insert(copy->rpn_tokens_.end(), rpn_tokens_.begin(), rpn_tokens_.end());
    copy->lexer_ = nullptr;
    copy->parsing_if_ = false;
    return copy;
}

const string& Expr::text() const {
    return text_;
}

Section* Expr::section() const {
    return section_;
}

bool Expr::parse_expr(Lexer* lexer) {
    parsing_if_ = false;
    return parse_expr1(lexer);
}

bool Expr::parse_if_expr(Lexer* lexer) {
    parsing_if_ = true;
    return parse_expr1(lexer);
}

ExprResult Expr::eval() const {
    vector<ExprResult> stack;
    ExprResult a, b, c;
    ExprResult res;

    for (auto& token : rpn_tokens_) {
        switch (token.code()) {
        case TK_QUEST:
            xassert(stack.size() >= 3);
            c = stack.back(); stack.pop_back();
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            if (a.value()) 
                stack.push_back(b);
            else
                stack.push_back(c);
            break;

        case TK_LOGOR:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), (a.value() || b.value()) ? 1 : 0);
            stack.push_back(res);
            break;

        case TK_LOGXOR:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), (!!a.value() != !!b.value()) ? 1 : 0);
            stack.push_back(res);
            break;

        case TK_LOGAND:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), (a.value() && b.value()) ? 1 : 0);
            stack.push_back(res);
            break;

        case TK_BINOR:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), a.value() | b.value());
            stack.push_back(res);
            break;

        case TK_BINXOR:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), a.value() ^ b.value());
            stack.push_back(res);
            break;

        case TK_BINAND:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), a.value() & b.value());
            stack.push_back(res);
            break;

        case TK_LT:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), (a.value() < b.value()) ? 1 : 0);
            stack.push_back(res);
            break;

        case TK_LE:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), (a.value() <= b.value()) ? 1 : 0);
            stack.push_back(res);
            break;

        case TK_GT:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), (a.value() > b.value()) ? 1 : 0);
            stack.push_back(res);
            break;

        case TK_GE:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), (a.value() >= b.value()) ? 1 : 0);
            stack.push_back(res);
            break;

        case TK_EQ:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), (a.value() == b.value()) ? 1 : 0);
            stack.push_back(res);
            break;

        case TK_NE:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), (a.value() != b.value()) ? 1 : 0);
            stack.push_back(res);
            break;

        case TK_LSHIFT:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), a.value() << b.value());
            stack.push_back(res);
            break;

        case TK_RSHIFT:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), a.value() >> b.value());
            stack.push_back(res);
            break;

        case TK_PLUS:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), a.value() + b.value());
            stack.push_back(res);
            break;

        case TK_MINUS:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), a.value() - b.value());
            stack.push_back(res);
            break;

        case TK_MULT:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), a.value() * b.value());
            stack.push_back(res);
            break;

        case TK_DIV:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            if (b.value() == 0)
                return ExprResult(TYPE_UNDEFINED, 0, ErrDivisionByZero);
            else {
                res = ExprResult::combine(a, b, token.code(), a.value() / b.value());
                stack.push_back(res);
            }
            break;

        case TK_MOD:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            if (b.value() == 0)
                return ExprResult(TYPE_UNDEFINED, 0, ErrDivisionByZero);
            else {
                res = ExprResult::combine(a, b, token.code(), a.value() % b.value());
                stack.push_back(res);
            }
            break;

        case TK_POWER:
            xassert(stack.size() >= 2);
            b = stack.back(); stack.pop_back();
            a = stack.back(); stack.pop_back();
            res = ExprResult::combine(a, b, token.code(), ipow(a.value(), b.value()));
            stack.push_back(res);
            break;

        case TK_UNARY_MINUS:
            xassert(stack.size() >= 1);
            a = stack.back(); stack.pop_back();
            a.set_value(-a.value());
            stack.push_back(a);
            break;

        case TK_UNARY_PLUS:
            xassert(stack.size() >= 1);
            break;

        case TK_LOGNOT:
            xassert(stack.size() >= 1);
            a = stack.back(); stack.pop_back();
            a.set_value(!a.value());
            stack.push_back(a);
            break;

        case TK_BINNOT:
            xassert(stack.size() >= 1);
            a = stack.back(); stack.pop_back();
            a.set_value(~a.value());
            stack.push_back(a);
            break;

        case TK_LPAREN:
            xassert(stack.size() >= 1);
            break;

        case TK_IDENT:
            xassert(token.symbol());
            res = token.symbol()->eval();
            res.set_section(token.symbol()->section());
            if (res.err_code() != ErrOk)
                return res;                     // return error
            else
                stack.push_back(res);
            break;

        case TK_INTEGER:
            stack.push_back(ExprResult(TYPE_CONSTANT, token.ivalue()));
            break;

        default:
            xassert(0);
        }
    }

    xassert(stack.size() == 1);
    res = stack.back();
    return res;
}

bool Expr::in_parens() const {
    if (rpn_tokens_.empty())
        return false;
    else if (rpn_tokens_.front().code() == TK_LPAREN)
        return true;
    else
        return false;
}

const Token& Expr::token() {
    return lexer_->peek();
}

TkCode Expr::token_code() {
    return lexer_->peek().code();
}

void Expr::consume_token() {
    text_ = Token::concat(text_, lexer_->peek().to_string());
    lexer_->next();
}

bool Expr::parse_expr1(Lexer* lexer) {
    lexer_ = lexer;
    bool result = parse_expr();
    lexer_ = nullptr;
    return result;
}

bool Expr::parse_expr() {
    text_.clear();
    rpn_tokens_.clear();
    set_location(g_errors.location());

    bool ok = true;
    try {
        parse_ternary_condition();
    }
    catch (ExprException& e) {
        if (!parsing_if_)
            e.error();
        ok = false;
    }
    return ok;
}

void Expr::parse_ternary_condition() {
    parse_logical_or();
    if (token_code() == TK_QUEST) {
        consume_token();
        parse_ternary_condition();
        if (token_code() == TK_COLON) {
            consume_token();
            parse_ternary_condition();
            rpn_tokens_.push_back(Token(TK_QUEST));
        }
        else {
            throw ExprException(ErrColonExpected, lexer_->peek_text());
        }
    }
}

void Expr::parse_logical_or() {
    parse_logical_and();
    while (true) {
        switch (token_code()) {
        case TK_LOGOR:
            consume_token();
            parse_logical_and();
            rpn_tokens_.push_back(Token(TK_LOGOR));
            break;
        case TK_LOGXOR:
            consume_token();
            parse_logical_and();
            rpn_tokens_.push_back(Token(TK_LOGXOR));
            break;
        default:
            return;
        }
    }
}

void Expr::parse_logical_and() {
    parse_binary_or();
    while (true) {
        switch (token_code()) {
        case TK_LOGAND:
            consume_token();
            parse_binary_or();
            rpn_tokens_.push_back(Token(TK_LOGAND));
            break;
        default:
            return;
        }
    }
}

void Expr::parse_binary_or() {
    parse_binary_and();
    while (true) {
        switch (token_code()) {
        case TK_BINOR:
            consume_token();
            parse_binary_and();
            rpn_tokens_.push_back(Token(TK_BINOR));
            break;
        case TK_BINXOR:
            consume_token();
            parse_binary_and();
            rpn_tokens_.push_back(Token(TK_BINXOR));
            break;
        default:
            return;
        }
    }
}

void Expr::parse_binary_and() {
    parse_condition();
    while (true) {
        switch (token_code()) {
        case TK_BINAND:
            consume_token();
            parse_condition();
            rpn_tokens_.push_back(Token(TK_BINAND));
            break;
        default:
            return;
        }
    }
}

void Expr::parse_condition() {
    parse_shift();
    while (true) {
        switch (token_code()) {
        case TK_LT:
            consume_token();
            parse_shift();
            rpn_tokens_.push_back(Token(TK_LT));
            break;
        case TK_LE:
            consume_token();
            parse_shift();
            rpn_tokens_.push_back(Token(TK_LE));
            break;
        case TK_GT:
            consume_token();
            parse_shift();
            rpn_tokens_.push_back(Token(TK_GT));
            break;
        case TK_GE:
            consume_token();
            parse_shift();
            rpn_tokens_.push_back(Token(TK_GE));
            break;
        case TK_EQ:
            consume_token();
            parse_shift();
            rpn_tokens_.push_back(Token(TK_EQ));
            break;
        case TK_NE:
            consume_token();
            parse_shift();
            rpn_tokens_.push_back(Token(TK_NE));
            break;
        default:
            return;
        }
    }
}

void Expr::parse_shift() {
    parse_addition();
    while (true) {
        switch (token_code()) {
        case TK_LSHIFT:
            consume_token();
            parse_addition();
            rpn_tokens_.push_back(Token(TK_LSHIFT));
            break;
        case TK_RSHIFT:
            consume_token();
            parse_addition();
            rpn_tokens_.push_back(Token(TK_RSHIFT));
            break;
        default:
            return;
        }
    }
}

void Expr::parse_addition() {
    parse_multiplication();
    while (true) {
        switch (token_code()) {
        case TK_PLUS:
            consume_token();
            parse_multiplication();
            rpn_tokens_.push_back(Token(TK_PLUS));
            break;
        case TK_MINUS:
            consume_token();
            parse_multiplication();
            rpn_tokens_.push_back(Token(TK_MINUS));
            break;
        default:
            return;
        }
    }
}

void Expr::parse_multiplication() {
    parse_power();
    while (true) {
        switch (token_code()) {
        case TK_MULT:
            consume_token();
            parse_power();
            rpn_tokens_.push_back(Token(TK_MULT));
            break;
        case TK_DIV:
            consume_token();
            parse_power();
            rpn_tokens_.push_back(Token(TK_DIV));
            break;
        case TK_MOD:
            consume_token();
            parse_power();
            rpn_tokens_.push_back(Token(TK_MOD));
            break;
        default:
            return;
        }
    }
}

void Expr::parse_power() {
    parse_unary();
    if (token_code() == TK_POWER) {
        consume_token();
        parse_power();
        rpn_tokens_.push_back(Token(TK_POWER));
    }
}

void Expr::parse_unary() {
    switch (token_code()) {
    case TK_MINUS:
        consume_token();
        parse_unary();
        rpn_tokens_.push_back(Token(TK_UNARY_MINUS));
        break;
    case TK_PLUS:
        consume_token();
        parse_unary();
        rpn_tokens_.push_back(Token(TK_UNARY_PLUS));
        break;
    case TK_LOGNOT:
        consume_token();
        parse_unary();
        rpn_tokens_.push_back(Token(TK_LOGNOT));
        break;
    case TK_BINNOT:
        consume_token();
        parse_unary();
        rpn_tokens_.push_back(Token(TK_BINNOT));
        break;
    case TK_LPAREN:
        consume_token();
        parse_ternary_condition();
        if (token_code() != TK_RPAREN)
            throw ExprException(ErrUnbalancedParens, lexer_->peek_text());
        consume_token();
        rpn_tokens_.push_back(Token(TK_LPAREN));
        break;
    case TK_LSQUARE:
        consume_token();
        parse_ternary_condition();
        if (token_code() != TK_RSQUARE)
            throw ExprException(ErrUnbalancedParens, lexer_->peek_text());
        consume_token();
        rpn_tokens_.push_back(Token(TK_LPAREN));
        break;
    default:
        parse_primary();
    }
}

void Expr::parse_primary() {
    string name;
    Token symbol_token, const_token;

    switch (token_code()) {
    case TK_IDENT:
        name = token().svalue();

        // do not create symbols refered to in IF or while checking if code is expr
        if (parsing_if_) {
            Symbol* symbol = g_asm.find_symbol(name);
            if (symbol) {
                symbol_token = token();
                symbol_token.set_symbol(symbol);
                rpn_tokens_.push_back(symbol_token);
            }
            else {
                const_token = token();
                const_token.set_code(TK_INTEGER);
                const_token.set_ivalue(0);
                rpn_tokens_.push_back(const_token);
            }
        }
        else {
            Symbol* symbol = g_asm.use_symbol(name);
            symbol_token = token();
            symbol_token.set_symbol(symbol);
            rpn_tokens_.push_back(symbol_token);
        }
        consume_token();
        break;

    case TK_ASMPC:
        xassert(g_asm.asmpc());
        symbol_token = token();
        symbol_token.set_svalue(g_asm.asmpc()->name());
        symbol_token.set_symbol(g_asm.asmpc());
        rpn_tokens_.push_back(symbol_token);
        consume_token();
        break;

    case TK_INTEGER:
        rpn_tokens_.push_back(token());
        consume_token();
        break;

    default:
        throw ExprException(ErrIntOrIdentExpected, lexer_->peek_text());
    }
}

//-----------------------------------------------------------------------------

Patch::Patch(range_t range, int offset, Expr* expr)
    : range_(range), offset_(offset), expr_(expr) {
}

Patch::~Patch() {
    delete expr_;
}

range_t Patch::range() const {
    return range_;
}

int Patch::offset() const {
    return offset_;
}

Expr* Patch::expr() {
    return expr_;
}

int Patch::size() const {
    return range_size(range_);
}
