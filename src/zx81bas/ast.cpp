//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "dump_context.h"
#include "errors.h"
#include "release_assert.h"
#include "utils.h"
#include <algorithm>
#include <string>

bool is_string_variable(const std::string& name) {
    return !name.empty() && name.back() == '$';
}

#ifdef _DEBUG
static void dump_expr_base(const Expr* e, DumpContext ctx) {
    if (!e) {
        ctx.line("nullptr");
        return;
    }
    ctx.line("type: " + std::string((e->type == ExprType::Number) ?
                                    "Number" : "String"));
    ctx.line("location: " + e->loc.filename + ":" +
             std::to_string(e->loc.line_num));
}

static void dump_expr_list(const char* name,
                           const std::vector<std::unique_ptr<Expr>>& list,
                           DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    for (const auto& e : list) {
        if (e) {
            e->dump(child_ctx);
        }
    }
    ctx.line("]");
}

static void dump_child_expr(const char* name, const Expr* e, DumpContext& ctx) {
    ctx.line(std::string(name) + ": ");
    if (e) {
        auto child_ctx = ctx.child();
        e->dump(child_ctx);
    }
    else {
        auto child_ctx = ctx.child();
        child_ctx.line("null");
    }
}

static void dump_stmt_common(const Stmt& stmt, DumpContext& ctx) {
    stmt.loc.dump(ctx);
}

static void dump_stmt_list(const char* name,
                           const std::vector<std::unique_ptr<Stmt>>& list,
                           DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    for (const auto& s : list) {
        if (s) {
            s->dump(child_ctx);
        }
    }
    ctx.line("]");
}

static void dump_string_list(const char* name,
                             const std::vector<std::string>& list,
                             DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    for (const auto& s : list) {
        child_ctx.line("\"" + s + "\"");
    }
    ctx.line("]");
}

static void dump_asm_lines(const std::vector<TokLine>& asm_lines,
                           DumpContext& ctx) {
    ctx.line("asm: [");
    auto child_ctx = ctx.child();
    for (const auto& line : asm_lines) {
        std::string text;
        for (const auto& token : line.tokens) {
            text += token.ws_before + token.text;
        }
        child_ctx.line(text);
    }
    ctx.line("]");
}
#endif

//-----------------------------------------------------------------------------
// Expression tree
//-----------------------------------------------------------------------------

Expr::Expr(ExprType type_, const SourceLoc& loc_)
    : type(type_), loc(loc_) {}

int precedence(const Expr& e) {
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
        case TokenType::NOT:
            return 7;
        default:
            release_assert(0);
        }
    }

    release_assert(0);
    return 99; // not reached
}

NumberExpr::NumberExpr(double value_, SourceLoc loc_)
    : Expr(ExprType::Number, loc_), value(value_) {}

std::unique_ptr<Expr> NumberExpr::clone() const {
    return std::make_unique<NumberExpr>(value, loc);
}

void NumberExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void NumberExpr::dump(DumpContext ctx) const {
    ctx.line("NumberExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    child_ctx.line("value: " + std::to_string(value));
    ctx.line("}");
}
#endif

LabelLineRefExpr::LabelLineRefExpr(const std::string& name_, SourceLoc loc_)
    : Expr(ExprType::Number, loc_), name(name_) {}

std::unique_ptr<Expr> LabelLineRefExpr::clone() const {
    return std::make_unique<LabelLineRefExpr>(name, loc);
}

void LabelLineRefExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void LabelLineRefExpr::dump(DumpContext ctx) const {
    ctx.line("LabelLineRefExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    ctx.line("}");
}
#endif

LabelAddrRefExpr::LabelAddrRefExpr(const std::string& name_, SourceLoc loc_)
    : Expr(ExprType::Number, loc_), name(name_) {}

std::unique_ptr<Expr> LabelAddrRefExpr::clone() const {
    return std::make_unique<LabelAddrRefExpr>(name, loc);
}

void LabelAddrRefExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void LabelAddrRefExpr::dump(DumpContext ctx) const {
    ctx.line("LabelAddrRefExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    ctx.line("}");
}
#endif

StringLiteralExpr::StringLiteralExpr(std::string val, SourceLoc loc_)
    : Expr(ExprType::String, loc_), value(std::move(val)) {}

std::unique_ptr<Expr> StringLiteralExpr::clone() const {
    return std::make_unique<StringLiteralExpr>(value, loc);
}

void StringLiteralExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void StringLiteralExpr::dump(DumpContext ctx) const {
    ctx.line("StringLiteralExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    child_ctx.line("value: \"" + value + "\"");
    ctx.line("}");
}
#endif

VariableExpr::VariableExpr(const std::string& name_, SourceLoc loc_)
    : Expr(is_string_variable(name_) ?
           ExprType::String : ExprType::Number, loc_),
      name(name_) {}

std::unique_ptr<Expr> VariableExpr::clone() const {
    return std::make_unique<VariableExpr>(name, loc);
}

void VariableExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void VariableExpr::dump(DumpContext ctx) const {
    ctx.line("VariableExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    ctx.line("}");
}
#endif

ArrayRefExpr::ArrayRefExpr(const std::string& name_, SourceLoc loc_)
    : Expr(is_string_variable(name_) ?
           ExprType::String : ExprType::Number, loc_),
      name(name_) {}

std::unique_ptr<Expr> ArrayRefExpr::clone() const {
    auto e = std::make_unique<ArrayRefExpr>(name, loc);
    for (auto& index : indices) {
        e->indices.push_back(index->clone());
    }
    return e;
}

void ArrayRefExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& e : indices) {
            e->accept(v);
        }
        v.leave(*this);
    }
}

#ifdef _DEBUG
void ArrayRefExpr::dump(DumpContext ctx) const {
    ctx.line("ArrayRefExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    dump_expr_list("indices", indices, child_ctx);
    ctx.line("}");
}
#endif

SliceExpr::SliceExpr(std::unique_ptr<Expr> base_, SourceLoc loc_)
    : Expr(ExprType::String, loc_), base(std::move(base_)) {}

std::unique_ptr<Expr> SliceExpr::clone() const {
    auto e = std::make_unique<SliceExpr>(base->clone(), loc);
    if (from) {
        e->from = from->clone();
    }
    if (to) {
        e->to = to->clone();
    }
    return e;
}

void SliceExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        base->accept(v);
        if (from) {
            from->accept(v);
        }
        if (to) {
            to->accept(v);
        }
        v.leave(*this);
    }
}

#ifdef _DEBUG
void SliceExpr::dump(DumpContext ctx) const {
    ctx.line("SliceExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    dump_child_expr("base", base.get(), child_ctx);
    dump_child_expr("from", from.get(), child_ctx);
    dump_child_expr("to", to.get(), child_ctx);
    ctx.line("}");
}
#endif

UnaryExpr::UnaryExpr(TokenType op_, std::unique_ptr<Expr> operand_,
                     SourceLoc loc_)
    : Expr(operand_->type, loc_), op(op_), operand(std::move(operand_)) {}

std::unique_ptr<Expr> UnaryExpr::clone() const {
    return std::make_unique<UnaryExpr>(op, operand->clone(), loc);
}

void UnaryExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        operand->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void UnaryExpr::dump(DumpContext ctx) const {
    ctx.line("UnaryExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    child_ctx.line("op: " + token_type_name(op));
    dump_child_expr("operand", operand.get(), child_ctx);
    ctx.line("}");
}
#endif

BinaryExpr::BinaryExpr(TokenType op_,
                       std::unique_ptr<Expr> lhs_,
                       std::unique_ptr<Expr> rhs_, SourceLoc loc_)
    : Expr(lhs_->type, loc_), op(op_),
      lhs(std::move(lhs_)),
      rhs(std::move(rhs_)) {}

std::unique_ptr<Expr> BinaryExpr::clone() const {
    return std::make_unique<BinaryExpr>(op, lhs->clone(), rhs->clone(), loc);
}

void BinaryExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        lhs->accept(v);
        rhs->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void BinaryExpr::dump(DumpContext ctx) const {
    ctx.line("BinaryExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    child_ctx.line("op: " + token_type_name(op));
    dump_child_expr("lhs", lhs.get(), child_ctx);
    dump_child_expr("rhs", rhs.get(), child_ctx);
    ctx.line("}");
}
#endif

BasicFuncCallExpr::BasicFuncCallExpr(Keyword keyword_, SourceLoc loc_)
    : Expr(ExprType::Number, loc_), keyword(keyword_) {
    switch (keyword) {
    case Keyword::INKEY_DLR:
    case Keyword::STR_DLR:
    case Keyword::CHR_DLR:
        type = ExprType::String;
        break;
    default:
        type = ExprType::Number;
        break;
    }
}

std::unique_ptr<Expr> BasicFuncCallExpr::clone() const {
    auto e = std::make_unique<BasicFuncCallExpr>(keyword, loc);
    for (auto& arg : args) {
        e->args.push_back(arg->clone());
    }
    return e;
}

void BasicFuncCallExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& e : args) {
            e->accept(v);
        }
        v.leave(*this);
    }
}

#ifdef _DEBUG
void BasicFuncCallExpr::dump(DumpContext ctx) const {
    ctx.line("BasicFuncCallExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    child_ctx.line("keyword: \"" + keyword_name(keyword) + "\"");
    dump_expr_list("args", args, child_ctx);
    ctx.line("}");
}
#endif

ProcCallExpr::ProcCallExpr(const std::string& name_, SourceLoc loc_)
    : Expr(ExprType::Number, loc_), name(name_) {}

std::unique_ptr<Expr> ProcCallExpr::clone() const {
    auto e = std::make_unique<ProcCallExpr>(name, loc);
    for (auto& arg : args) {
        e->args.push_back(arg->clone());
    }
    return e;
}

void ProcCallExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& e : args) {
            e->accept(v);
        }
        v.leave(*this);
    }
}

#ifdef _DEBUG
void ProcCallExpr::dump(DumpContext ctx) const {
    ctx.line("ProcCallExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    dump_expr_list("args", args, child_ctx);
    ctx.line("}");
}
#endif

FnCallExpr::FnCallExpr(const std::string& name_, SourceLoc loc_)
    : Expr(ExprType::Number, loc_), name(name_) {}

std::unique_ptr<Expr> FnCallExpr::clone() const {
    auto e = std::make_unique<FnCallExpr>(name, loc);
    for (auto& arg : args) {
        e->args.push_back(arg->clone());
    }
    return e;
}

void FnCallExpr::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& e : args) {
            e->accept(v);
        }
        v.leave(*this);
    }
}

#ifdef _DEBUG
void FnCallExpr::dump(DumpContext ctx) const {
    ctx.line("FnCallExpr {");
    auto child_ctx = ctx.child();
    dump_expr_base(this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    dump_expr_list("args", args, child_ctx);
    ctx.line("}");
}
#endif

//-----------------------------------------------------------------------------
// Statement tree
//-----------------------------------------------------------------------------

template<typename T>
void erase_marked(std::vector<std::unique_ptr<T>>& vec) {
    vec.erase(
        std::remove_if(vec.begin(), vec.end(),
    [](auto & ptr) {
        return ptr->mark_for_removal;
    }),
    vec.end()
    );
}

Stmt::Stmt(const SourceLoc& loc_)
    : loc(loc_) {
}

LabelStmt::LabelStmt(const std::string& label_, const SourceLoc& loc_)
    : Stmt(loc_), label(label_) {
}

std::unique_ptr<Stmt> LabelStmt::clone() const {
    auto s = std::make_unique<LabelStmt>(label, loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void LabelStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void LabelStmt::dump(DumpContext ctx) const {
    ctx.line("LabelStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("label: \"" + label + "\"");
    ctx.line("}");
}
#endif

LineNumStmt::LineNumStmt(int line_num_, const SourceLoc& loc_)
    : Stmt(loc_), line_num(line_num_) {
}

std::unique_ptr<Stmt> LineNumStmt::clone() const {
    auto s = std::make_unique<LineNumStmt>(line_num, loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void LineNumStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void LineNumStmt::dump(DumpContext ctx) const {
    ctx.line("LineNumStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("line_num: " + std::to_string(line_num));
    ctx.line("}");
}
#endif

LetStmt::LetStmt(std::unique_ptr<Expr> lhs_, std::unique_ptr<Expr> rhs_,
                 const SourceLoc& loc_)
    : Stmt(loc_), lhs(std::move(lhs_)), rhs(std::move(rhs_)) {
}

std::unique_ptr<Stmt> LetStmt::clone() const {
    auto s = std::make_unique<LetStmt>(lhs->clone(), rhs->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void LetStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        lhs->accept(v);
        rhs->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void LetStmt::dump(DumpContext ctx) const {
    ctx.line("LetStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("lhs", lhs.get(), child_ctx);
    dump_child_expr("rhs", rhs.get(), child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> DimStmt::clone() const {
    auto s = std::make_unique<DimStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    for (auto& item : items) {
        DimItem new_item;
        new_item.name = item.name;
        for (auto& dim : item.dims) {
            new_item.dims.push_back(dim->clone());
        }
        s->items.push_back(std::move(new_item));
    }
    return s;
}

void DimStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& item : items) {
            for (auto& dim : item.dims) {
                dim->accept(v);
            }
        }
        v.leave(*this);
    }
}

#ifdef _DEBUG
void DimItem::dump(DumpContext ctx) const {
    ctx.line("DimItem {");
    auto child_ctx = ctx.child();
    child_ctx.line("name: \"" + name + "\"");
    dump_expr_list("dims", dims, child_ctx);
    ctx.line("}");
}

void DimStmt::dump(DumpContext ctx) const {
    ctx.line("DimStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("items: [");
    auto items_ctx = child_ctx.child();
    for (const auto& item : items) {
        item.dump(items_ctx);
    }
    child_ctx.line("]");
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> BlockStmt::clone() const {
    auto s = std::make_unique<BlockStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    for (auto& stmt : body) {
        s->body.push_back(stmt->clone());
    }
    return s;
}

void BlockStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& stmt : body) {
            stmt->accept(v);
        }
        erase_marked(body);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void BlockStmt::dump(DumpContext ctx) const {
    ctx.line("BlockStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_stmt_list("body", body, child_ctx);
    ctx.line("}");
}
#endif

IfStmt::IfStmt(std::unique_ptr<Expr> condition_, const SourceLoc& loc_)
    : Stmt(loc_), condition(std::move(condition_)) {
}

std::unique_ptr<Stmt> IfStmt::clone() const {
    auto s = std::make_unique<IfStmt>(condition->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    for (auto& stmt : then_stmts) {
        s->then_stmts.push_back(stmt->clone());
    }
    for (auto& stmt : else_stmts) {
        s->else_stmts.push_back(stmt->clone());
    }
    return s;
}

void IfStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        condition->accept(v);
        for (auto& stmt : then_stmts) {
            stmt->accept(v);
        }
        erase_marked(then_stmts);
        for (auto& stmt : else_stmts) {
            stmt->accept(v);
        }
        erase_marked(else_stmts);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void IfStmt::dump(DumpContext ctx) const {
    ctx.line("IfStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("condition", condition.get(), child_ctx);
    dump_stmt_list("then_stmts", then_stmts, child_ctx);
    dump_stmt_list("else_stmts", else_stmts, child_ctx);
    ctx.line("}");
}
#endif

RepeatStmt::RepeatStmt(std::unique_ptr<Expr> condition_, const SourceLoc& loc_)
    : Stmt(loc_), condition(std::move(condition_)) {
}

std::unique_ptr<Stmt> RepeatStmt::clone() const {
    auto s = std::make_unique<RepeatStmt>(condition->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    for (auto& stmt : body) {
        s->body.push_back(stmt->clone());
    }
    return s;
}

void RepeatStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& stmt : body) {
            stmt->accept(v);
        }
        erase_marked(body);
        condition->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void RepeatStmt::dump(DumpContext ctx) const {
    ctx.line("RepeatStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_stmt_list("body", body, child_ctx);
    dump_child_expr("condition", condition.get(), child_ctx);
    ctx.line("}");
}
#endif

WhileStmt::WhileStmt(std::unique_ptr<Expr> condition_, const SourceLoc& loc_)
    : Stmt(loc_), condition(std::move(condition_)) {
}

std::unique_ptr<Stmt> WhileStmt::clone() const {
    auto s = std::make_unique<WhileStmt>(condition->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    for (auto& stmt : body) {
        s->body.push_back(stmt->clone());
    }
    return s;
}

void WhileStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        condition->accept(v);
        for (auto& stmt : body) {
            stmt->accept(v);
        }
        erase_marked(body);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void WhileStmt::dump(DumpContext ctx) const {
    ctx.line("WhileStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("condition", condition.get(), child_ctx);
    dump_stmt_list("body", body, child_ctx);
    ctx.line("}");
}
#endif

ForStmt::ForStmt(const std::string& name_, std::unique_ptr<Expr> start_expr_,
                 std::unique_ptr<Expr> end_expr_, std::unique_ptr<Expr> step_expr_,
                 const SourceLoc& loc_)
    : Stmt(loc_), name(name_), start_expr(std::move(start_expr_)),
      end_expr(std::move(end_expr_)), step_expr(std::move(step_expr_)) {
}

std::unique_ptr<Stmt> ForStmt::clone() const {
    auto s = std::make_unique<ForStmt>(name,
                                       start_expr->clone(),
                                       end_expr->clone(),
                                       step_expr->clone(),
                                       loc);
    s->mark_for_removal = mark_for_removal;
    for (auto& stmt : body) {
        s->body.push_back(stmt->clone());
    }
    return s;
}

void ForStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        start_expr->accept(v);
        end_expr->accept(v);
        step_expr->accept(v);
        for (auto& stmt : body) {
            stmt->accept(v);
        }
        erase_marked(body);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void ForStmt::dump(DumpContext ctx) const {
    ctx.line("ForStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    dump_child_expr("start_expr", start_expr.get(), child_ctx);
    dump_child_expr("end_expr", end_expr.get(), child_ctx);
    dump_child_expr("step_expr", step_expr.get(), child_ctx);
    dump_stmt_list("body", body, child_ctx);
    ctx.line("}");
}
#endif

NextStmt::NextStmt(const std::string& name_, const SourceLoc& loc_)
    : Stmt(loc_), name(name_) {
}

std::unique_ptr<Stmt> NextStmt::clone() const {
    auto s = std::make_unique<NextStmt>(name, loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void NextStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void NextStmt::dump(DumpContext ctx) const {
    ctx.line("NextStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    ctx.line("}");
}
#endif

DefProcStmt::DefProcStmt(const std::string& name_, const SourceLoc& loc_)
    : Stmt(loc_), name(name_) {
}

std::unique_ptr<Stmt> DefProcStmt::clone() const {
    auto s = std::make_unique<DefProcStmt>(name, loc);
    s->mark_for_removal = mark_for_removal;
    s->params = params;
    s->locals = locals;
    s->called = called;
    for (auto& stmt : body) {
        s->body.push_back(stmt->clone());
    }
    return s;
}

void DefProcStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& stmt : body) {
            stmt->accept(v);
        }
        erase_marked(body);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void DefProcStmt::dump(DumpContext ctx) const {
    ctx.line("DefProcStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    dump_string_list("params", params, child_ctx);
    dump_string_list("locals", locals, child_ctx);
    dump_stmt_list("body", body, child_ctx);
    ctx.line("}");
}
#endif

ProcCallStmt::ProcCallStmt(const std::string& name_, const SourceLoc& loc_)
    : Stmt(loc_), name(name_) {
}

std::unique_ptr<Stmt> ProcCallStmt::clone() const {
    auto s = std::make_unique<ProcCallStmt>(name, loc);
    s->mark_for_removal = mark_for_removal;
    for (auto& arg : args) {
        s->args.push_back(arg->clone());
    }
    return s;
}

void ProcCallStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& arg : args) {
            arg->accept(v);
        }
        v.leave(*this);
    }
}

#ifdef _DEBUG
void ProcCallStmt::dump(DumpContext ctx) const {
    ctx.line("ProcCallStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    dump_expr_list("args", args, child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> LocalStmt::clone() const {
    auto s = std::make_unique<LocalStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->locals = locals;
    return s;
}

void LocalStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void LocalStmt::dump(DumpContext ctx) const {
    ctx.line("LocalStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_string_list("locals", locals, child_ctx);
    ctx.line("}");
}
#endif

DefFnStmt::DefFnStmt(const std::string& name_, const SourceLoc& loc_)
    : Stmt(loc_), name(name_) {
}

std::unique_ptr<Stmt> DefFnStmt::clone() const {
    auto s = std::make_unique<DefFnStmt>(name, loc);
    s->mark_for_removal = mark_for_removal;
    s->params = params;
    s->expr = expr->clone();
    return s;
}

void DefFnStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        expr->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void DefFnStmt::dump(DumpContext ctx) const {
    ctx.line("DefFnStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    dump_string_list("params", params, child_ctx);
    dump_child_expr("expr", expr.get(), child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> ExitStmt::clone() const {
    auto s = std::make_unique<ExitStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ExitStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void ExitStmt::dump(DumpContext ctx) const {
    ctx.line("ExitStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}
#endif

GotoStmt::GotoStmt(std::unique_ptr<Expr> target_expr_, const SourceLoc& loc_)
    : Stmt(loc_), target_expr(std::move(target_expr_)) {
}

std::unique_ptr<Stmt> GotoStmt::clone() const {
    auto s = std::make_unique<GotoStmt>(target_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void GotoStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        target_expr->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void GotoStmt::dump(DumpContext ctx) const {
    ctx.line("GotoStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("target_expr", target_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

GosubStmt::GosubStmt(std::unique_ptr<Expr> target_expr_, const SourceLoc& loc_)
    : Stmt(loc_), target_expr(std::move(target_expr_)) {
}

std::unique_ptr<Stmt> GosubStmt::clone() const {
    auto s = std::make_unique<GosubStmt>(target_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void GosubStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        target_expr->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void GosubStmt::dump(DumpContext ctx) const {
    ctx.line("GosubStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("target_expr", target_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> ReturnStmt::clone() const {
    auto s = std::make_unique<ReturnStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ReturnStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void ReturnStmt::dump(DumpContext ctx) const {
    ctx.line("ReturnStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> StopStmt::clone() const {
    auto s = std::make_unique<StopStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void StopStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void StopStmt::dump(DumpContext ctx) const {
    ctx.line("StopStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> EndStmt::clone() const {
    auto s = std::make_unique<EndStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void EndStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void EndStmt::dump(DumpContext ctx) const {
    ctx.line("EndStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> PrintStmt::clone() const {
    auto s = std::make_unique<PrintStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    for (auto& item : items) {
        PrintItem new_item;
        new_item.type = item.type;
        if (item.expr) {
            new_item.expr = item.expr->clone();
        }
        if (item.line_expr) {
            new_item.line_expr = item.line_expr->clone();
        }
        if (item.col_expr) {
            new_item.col_expr = item.col_expr->clone();
        }
        if (item.tab_expr) {
            new_item.tab_expr = item.tab_expr->clone();
        }
        s->items.push_back(std::move(new_item));
    }
    return s;
}

void PrintStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& item : items) {
            if (item.expr) {
                item.expr->accept(v);
            }
            if (item.line_expr) {
                item.line_expr->accept(v);
            }
            if (item.col_expr) {
                item.col_expr->accept(v);
            }
            if (item.tab_expr) {
                item.tab_expr->accept(v);
            }
        }
        v.leave(*this);
    }
}

#ifdef _DEBUG
void PrintStmt::dump(DumpContext ctx) const {
    ctx.line("PrintStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("items: [");
    auto items_ctx = child_ctx.child();
    for (const auto& item : items) {
        switch (item.type) {
        case PrintItem::Type::Expr:
            items_ctx.line("Expr:");
            if (item.expr) {
                auto e_ctx = items_ctx.child();
                item.expr->dump(e_ctx);
            }
            break;
        case PrintItem::Type::Comma:
            items_ctx.line("Comma");
            break;
        case PrintItem::Type::Semicolon:
            items_ctx.line("Semicolon");
            break;
        case PrintItem::Type::At:
            items_ctx.line("At:");
            {
                auto e_ctx = items_ctx.child();
                dump_child_expr("line_expr", item.line_expr.get(), e_ctx);
                dump_child_expr("col_expr", item.col_expr.get(), e_ctx);
            }
            break;
        case PrintItem::Type::Tab:
            items_ctx.line("Tab:");
            if (item.tab_expr) {
                auto e_ctx = items_ctx.child();
                item.tab_expr->dump(e_ctx);
            }
            break;
        }
    }
    child_ctx.line("]");
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> InputStmt::clone() const {
    auto s = std::make_unique<InputStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    for (auto& var : vars) {
        s->vars.push_back(var->clone());
    }
    return s;
}

void InputStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& var : vars) {
            var->accept(v);
        }
        v.leave(*this);
    }
}

#ifdef _DEBUG
void InputStmt::dump(DumpContext ctx) const {
    ctx.line("InputStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_expr_list("vars", vars, child_ctx);
    ctx.line("}");
}
#endif

RemStmt::RemStmt(const std::string& text_, const SourceLoc& loc_)
    : Stmt(loc_), text(text_) {
}

std::unique_ptr<Stmt> RemStmt::clone() const {
    auto s = std::make_unique<RemStmt>(text, loc);
    s->mark_for_removal = mark_for_removal;
    s->asm_lines = asm_lines;
    return s;
}

void RemStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void RemStmt::dump(DumpContext ctx) const {
    ctx.line("RemStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("text: \"" + text + "\"");
    dump_asm_lines(asm_lines, child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> RunStmt::clone() const {
    auto s = std::make_unique<RunStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    if (target_expr) {
        s->target_expr = target_expr->clone();
    }
    return s;
}

void RunStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        if (target_expr) {
            target_expr->accept(v);
        }
        v.leave(*this);
    }
}

#ifdef _DEBUG
void RunStmt::dump(DumpContext ctx) const {
    ctx.line("RunStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("target_expr", target_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> ListStmt::clone() const {
    auto s = std::make_unique<ListStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    if (target_expr) {
        s->target_expr = target_expr->clone();
    }
    return s;
}

void ListStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        if (target_expr) {
            target_expr->accept(v);
        }
        v.leave(*this);
    }
}

#ifdef _DEBUG
void ListStmt::dump(DumpContext ctx) const {
    ctx.line("ListStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("target_expr", target_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> NewStmt::clone() const {
    auto s = std::make_unique<NewStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void NewStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void NewStmt::dump(DumpContext ctx) const {
    ctx.line("NewStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> ClsStmt::clone() const {
    auto s = std::make_unique<ClsStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ClsStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void ClsStmt::dump(DumpContext ctx) const {
    ctx.line("ClsStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}
#endif

LoadStmt::LoadStmt(std::unique_ptr<Expr> filename_expr_, const SourceLoc& loc_)
    : Stmt(loc_), filename_expr(std::move(filename_expr_)) {
}

std::unique_ptr<Stmt> LoadStmt::clone() const {
    auto s = std::make_unique<LoadStmt>(filename_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void LoadStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        filename_expr->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void LoadStmt::dump(DumpContext ctx) const {
    ctx.line("LoadStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("filename_expr", filename_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

SaveStmt::SaveStmt(std::unique_ptr<Expr> filename_expr_, const SourceLoc& loc_)
    : Stmt(loc_), filename_expr(std::move(filename_expr_)) {
}

std::unique_ptr<Stmt> SaveStmt::clone() const {
    auto s = std::make_unique<SaveStmt>(filename_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void SaveStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        filename_expr->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void SaveStmt::dump(DumpContext ctx) const {
    ctx.line("SaveStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("filename_expr", filename_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

PokeStmt::PokeStmt(std::unique_ptr<Expr> address_expr_,
                   std::unique_ptr<Expr> value_expr_, const SourceLoc& loc_)
    : Stmt(loc_), address_expr(std::move(address_expr_)),
      value_expr(std::move(value_expr_)) {
}

std::unique_ptr<Stmt> PokeStmt::clone() const {
    auto s = std::make_unique<PokeStmt>(address_expr->clone(), value_expr->clone(),
                                        loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void PokeStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        address_expr->accept(v);
        value_expr->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void PokeStmt::dump(DumpContext ctx) const {
    ctx.line("PokeStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("address", address_expr.get(), child_ctx);
    dump_child_expr("value", value_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

PokewStmt::PokewStmt(std::unique_ptr<Expr> address_expr_,
                     std::unique_ptr<Expr> value_expr_, const SourceLoc& loc_)
    : Stmt(loc_), address_expr(std::move(address_expr_)),
      value_expr(std::move(value_expr_)) {
}

std::unique_ptr<Stmt> PokewStmt::clone() const {
    auto s = std::make_unique<PokewStmt>(address_expr->clone(), value_expr->clone(),
                                         loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void PokewStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        address_expr->accept(v);
        value_expr->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void PokewStmt::dump(DumpContext ctx) const {
    ctx.line("PokewStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("address", address_expr.get(), child_ctx);
    dump_child_expr("value", value_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

PlotStmt::PlotStmt(std::unique_ptr<Expr> x_expr_, std::unique_ptr<Expr> y_expr_,
                   const SourceLoc& loc_)
    : Stmt(loc_), x_expr(std::move(x_expr_)), y_expr(std::move(y_expr_)) {
}

std::unique_ptr<Stmt> PlotStmt::clone() const {
    auto s = std::make_unique<PlotStmt>(x_expr->clone(), y_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void PlotStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        x_expr->accept(v);
        y_expr->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void PlotStmt::dump(DumpContext ctx) const {
    ctx.line("PlotStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("x_expr", x_expr.get(), child_ctx);
    dump_child_expr("y_expr", y_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

UnplotStmt::UnplotStmt(std::unique_ptr<Expr> x_expr_,
                       std::unique_ptr<Expr> y_expr_, const SourceLoc& loc_)
    : Stmt(loc_), x_expr(std::move(x_expr_)), y_expr(std::move(y_expr_)) {
}

std::unique_ptr<Stmt> UnplotStmt::clone() const {
    auto s = std::make_unique<UnplotStmt>(x_expr->clone(), y_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void UnplotStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        x_expr->accept(v);
        y_expr->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void UnplotStmt::dump(DumpContext ctx) const {
    ctx.line("UnplotStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("x_expr", x_expr.get(), child_ctx);
    dump_child_expr("y_expr", y_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

RandStmt::RandStmt(std::unique_ptr<Expr> seed_expr_, const SourceLoc& loc_)
    : Stmt(loc_), seed_expr(std::move(seed_expr_)) {
}

std::unique_ptr<Stmt> RandStmt::clone() const {
    auto s = std::make_unique<RandStmt>(seed_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void RandStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        seed_expr->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void RandStmt::dump(DumpContext ctx) const {
    ctx.line("RandStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("seed", seed_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

PauseStmt::PauseStmt(std::unique_ptr<Expr> duration_expr_,
                     const SourceLoc& loc_)
    : Stmt(loc_), duration_expr(std::move(duration_expr_)) {
}

std::unique_ptr<Stmt> PauseStmt::clone() const {
    auto s = std::make_unique<PauseStmt>(duration_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void PauseStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        duration_expr->accept(v);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void PauseStmt::dump(DumpContext ctx) const {
    ctx.line("PauseStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("duration", duration_expr.get(), child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> FastStmt::clone() const {
    auto s = std::make_unique<FastStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void FastStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void FastStmt::dump(DumpContext ctx) const {
    ctx.line("FastStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> SlowStmt::clone() const {
    auto s = std::make_unique<SlowStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void SlowStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void SlowStmt::dump(DumpContext ctx) const {
    ctx.line("SlowStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> ScrollStmt::clone() const {
    auto s = std::make_unique<ScrollStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ScrollStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void ScrollStmt::dump(DumpContext ctx) const {
    ctx.line("ScrollStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> ContStmt::clone() const {
    auto s = std::make_unique<ContStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ContStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void ContStmt::dump(DumpContext ctx) const {
    ctx.line("ContStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}
#endif

std::unique_ptr<Stmt> ClearStmt::clone() const {
    auto s = std::make_unique<ClearStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ClearStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void ClearStmt::dump(DumpContext ctx) const {
    ctx.line("ClearStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}
#endif

PragmaNumVarStmt::PragmaNumVarStmt(std::string name_, double value_,
                                   const SourceLoc& loc_)
    : Stmt(loc_), name(std::move(name_)), value(value_) {
}

std::unique_ptr<Stmt> PragmaNumVarStmt::clone() const {
    auto s = std::make_unique<PragmaNumVarStmt>(name, value, loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void PragmaNumVarStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void PragmaNumVarStmt::dump(DumpContext ctx) const {
    ctx.line("PragmaNumVarStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: " + name);
    child_ctx.line("value: " + std::to_string(value));
    ctx.line("}");
}
#endif

PragmaStrVarStmt::PragmaStrVarStmt(std::string name_, std::string value_,
                                   const SourceLoc& loc_)
    : Stmt(loc_), name(std::move(name_)), value(std::move(value_)) {
}

std::unique_ptr<Stmt> PragmaStrVarStmt::clone() const {
    auto s = std::make_unique<PragmaStrVarStmt>(name, value, loc);
    s->mark_for_removal = mark_for_removal;
    s->asm_lines = asm_lines;
    return s;
}

void PragmaStrVarStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void PragmaStrVarStmt::dump(DumpContext ctx) const {
    ctx.line("PragmaStrVarStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: " + name);
    child_ctx.line("value: \"" + value + "\"");
    dump_asm_lines(asm_lines, child_ctx);
    ctx.line("}");
}
#endif

PragmaNumVarArrayStmt::PragmaNumVarArrayStmt(std::string name_,
        const SourceLoc& loc_)
    : Stmt(loc_), name(std::move(name_)) {
}

std::unique_ptr<Stmt> PragmaNumVarArrayStmt::clone() const {
    auto s = std::make_unique<PragmaNumVarArrayStmt>(name, loc);
    s->mark_for_removal = mark_for_removal;
    s->dims = dims;
    s->values = values;
    return s;
}

void PragmaNumVarArrayStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void PragmaNumVarArrayStmt::dump(DumpContext ctx) const {
    ctx.line("PragmaNumVarArrayStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: " + name);
    child_ctx.line("dimensions: [");
    auto grandchild_ctx = child_ctx.child();
    for (auto dim : dims) {
        grandchild_ctx.line(std::to_string(dim));
    }
    child_ctx.line("]");
    child_ctx.line("values: [");
    auto val_ctx = child_ctx.child();
    for (const auto& v : values) {
        val_ctx.line(std::to_string(v));
    }
    child_ctx.line("]");
    ctx.line("}");
}
#endif

PragmaStrVarArrayStmt::PragmaStrVarArrayStmt(std::string name_,
        const SourceLoc& loc_)
    : Stmt(loc_), name(std::move(name_)) {
}

std::unique_ptr<Stmt> PragmaStrVarArrayStmt::clone() const {
    auto s = std::make_unique<PragmaStrVarArrayStmt>(name, loc);
    s->mark_for_removal = mark_for_removal;
    s->dims = dims;
    s->values = values;
    return s;
}

void PragmaStrVarArrayStmt::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        v.leave(*this);
    }
}

#ifdef _DEBUG
void PragmaStrVarArrayStmt::dump(DumpContext ctx) const {
    ctx.line("PragmaStrVarArrayStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: " + name);
    child_ctx.line("dimensions: [");
    auto grandchild_ctx = child_ctx.child();
    for (auto dim : dims) {
        grandchild_ctx.line(std::to_string(dim));
    }
    child_ctx.line("]");
    dump_string_list("values", values, child_ctx);
    ctx.line("}");
}
#endif

void Prog::accept(ASTVisitor& v) {
    if (v.enter(*this)) {
        v.visit(*this);
        // accept children
        for (auto& stmt : stmts) {
            stmt->accept(v);
        }
        erase_marked(stmts);
        v.leave(*this);
    }
}

#ifdef _DEBUG
void Prog::dump(DumpContext ctx) const {
    ctx.line("Prog {");
    auto child_ctx = ctx.child();
    child_ctx.line("auto_start: " + std::string(auto_start ? "true" : "false"));
    child_ctx.line("auto_start_line: " + std::to_string(auto_start_line));
    child_ctx.line("auto_start_label: \"" + auto_start_label + "\"");
    child_ctx.line("increment: " + std::to_string(increment));
    child_ctx.line("rem_invert: " + std::string(rem_invert ? "true" : "false"));
    child_ctx.line("fast_mode: " + std::string(fast_mode ? "true" : "false"));
    child_ctx.line("dfile_lines: [");
    auto grandchild_ctx = child_ctx.child();
    for (const auto& line : dfile_lines) {
        grandchild_ctx.line("\"" + line + "\"");
    }
    child_ctx.line("]");
    child_ctx.line("dfile_colapsed: " + std::string(dfile_colapsed ? "true" :
                   "false"));
    child_ctx.line("sysvars_data: [");
    for (const auto& byte : sysvars_data) {
        grandchild_ctx.line(int_to_hex(byte));
    }
    child_ctx.line("]");
    dump_stmt_list("stmts", stmts, child_ctx);
    dump_stmt_list("pragma_vars", pragma_vars, child_ctx);
    ctx.line("}");
}
#endif
