//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "ast_expr.h"
#include "ast_stmt.h"
#include "errors.h"
#include <memory>
#include <string>
#include <utility>

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
    v.visit(*this);
}

LineNumStmt::LineNumStmt(int line_num_, const SourceLoc& loc_)
    : Stmt(loc_), line_num(line_num_) {
}

std::unique_ptr<Stmt> LineNumStmt::clone() const {
    auto s = std::make_unique<LineNumStmt>(line_num, loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void LineNumStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

NextStmt::NextStmt(const std::string& name_, const SourceLoc& loc_)
    : Stmt(loc_), name(name_) {
}

std::unique_ptr<Stmt> NextStmt::clone() const {
    auto s = std::make_unique<NextStmt>(name, loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void NextStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

std::unique_ptr<Stmt> LocalStmt::clone() const {
    auto s = std::make_unique<LocalStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->locals = locals;
    return s;
}

void LocalStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

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
    v.visit(*this);
}

std::unique_ptr<Stmt> ExitStmt::clone() const {
    auto s = std::make_unique<ExitStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ExitStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

GotoStmt::GotoStmt(std::unique_ptr<Expr> target_expr_, const SourceLoc& loc_)
    : Stmt(loc_), target_expr(std::move(target_expr_)) {
}

std::unique_ptr<Stmt> GotoStmt::clone() const {
    auto s = std::make_unique<GotoStmt>(target_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void GotoStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

GosubStmt::GosubStmt(std::unique_ptr<Expr> target_expr_, const SourceLoc& loc_)
    : Stmt(loc_), target_expr(std::move(target_expr_)) {
}

std::unique_ptr<Stmt> GosubStmt::clone() const {
    auto s = std::make_unique<GosubStmt>(target_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void GosubStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> ReturnStmt::clone() const {
    auto s = std::make_unique<ReturnStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ReturnStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> StopStmt::clone() const {
    auto s = std::make_unique<StopStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void StopStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> EndStmt::clone() const {
    auto s = std::make_unique<EndStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void EndStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

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
    v.visit(*this);
}

std::unique_ptr<Stmt> InputStmt::clone() const {
    auto s = std::make_unique<InputStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    for (auto& var : vars) {
        s->vars.push_back(var->clone());
    }
    return s;
}

void InputStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

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
    v.visit(*this);
}

std::unique_ptr<Stmt> RunStmt::clone() const {
    auto s = std::make_unique<RunStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    if (target_expr) {
        s->target_expr = target_expr->clone();
    }
    return s;
}

void RunStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> ListStmt::clone() const {
    auto s = std::make_unique<ListStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    if (target_expr) {
        s->target_expr = target_expr->clone();
    }
    return s;
}

void ListStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> NewStmt::clone() const {
    auto s = std::make_unique<NewStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void NewStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> ClsStmt::clone() const {
    auto s = std::make_unique<ClsStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ClsStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

LoadStmt::LoadStmt(std::unique_ptr<Expr> filename_expr_, const SourceLoc& loc_)
    : Stmt(loc_), filename_expr(std::move(filename_expr_)) {
}

std::unique_ptr<Stmt> LoadStmt::clone() const {
    auto s = std::make_unique<LoadStmt>(filename_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void LoadStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

SaveStmt::SaveStmt(std::unique_ptr<Expr> filename_expr_, const SourceLoc& loc_)
    : Stmt(loc_), filename_expr(std::move(filename_expr_)) {
}

std::unique_ptr<Stmt> SaveStmt::clone() const {
    auto s = std::make_unique<SaveStmt>(filename_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void SaveStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

RandStmt::RandStmt(std::unique_ptr<Expr> seed_expr_, const SourceLoc& loc_)
    : Stmt(loc_), seed_expr(std::move(seed_expr_)) {
}

std::unique_ptr<Stmt> RandStmt::clone() const {
    auto s = std::make_unique<RandStmt>(seed_expr->clone(), loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void RandStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

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
    v.visit(*this);
}

std::unique_ptr<Stmt> FastStmt::clone() const {
    auto s = std::make_unique<FastStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void FastStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> SlowStmt::clone() const {
    auto s = std::make_unique<SlowStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void SlowStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> ScrollStmt::clone() const {
    auto s = std::make_unique<ScrollStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ScrollStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> ContStmt::clone() const {
    auto s = std::make_unique<ContStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ContStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> ClearStmt::clone() const {
    auto s = std::make_unique<ClearStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void ClearStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

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
    v.visit(*this);
}

