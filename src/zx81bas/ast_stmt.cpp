//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "ast_expr.h"
#include "ast_stmt.h"

Stmt::Stmt(const SourceLoc& loc_)
    : loc(loc_) {
}

JumpTargetStmt::JumpTargetStmt(const SourceLoc& loc_,
                               const std::string& label_,
                               int basic_line_num_)
    : Stmt(loc_), label(label_), basic_line_num(basic_line_num_) {
}

std::unique_ptr<Stmt> JumpTargetStmt::clone() const {
    auto s = std::make_unique<JumpTargetStmt>(loc, label, basic_line_num);
    s->mark_for_removal = mark_for_removal;
    return s;
}

void JumpTargetStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> LetStmt::clone() const {
    auto s = std::make_unique<LetStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->lhs = lhs->clone();
    s->rhs = rhs->clone();
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

std::unique_ptr<Stmt> IfStmt::clone() const {
    auto s = std::make_unique<IfStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->condition = condition->clone();
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

std::unique_ptr<Stmt> RepeatStmt::clone() const {
    auto s = std::make_unique<RepeatStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    for (auto& stmt : body) {
        s->body.push_back(stmt->clone());
    }
    if (condition) {
        s->condition = condition->clone();
    }
    return s;
}

void RepeatStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> WhileStmt::clone() const {
    auto s = std::make_unique<WhileStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->condition = condition->clone();
    for (auto& stmt : body) {
        s->body.push_back(stmt->clone());
    }
    return s;
}

void WhileStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> ForStmt::clone() const {
    auto s = std::make_unique<ForStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->name = name;
    s->start_expr = start_expr->clone();
    s->end_expr = end_expr->clone();
    if (step_expr) {
        s->step_expr = step_expr->clone();
    }
    for (auto& stmt : body) {
        s->body.push_back(stmt->clone());
    }
    return s;
}

void ForStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> NextStmt::clone() const {
    auto s = std::make_unique<NextStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->name = name;
    return s;
}

void NextStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> DefProcStmt::clone() const {
    auto s = std::make_unique<DefProcStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->name = name;
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

std::unique_ptr<Stmt> ProcCallStmt::clone() const {
    auto s = std::make_unique<ProcCallStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->name = name;
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

std::unique_ptr<Stmt> DefFnStmt::clone() const {
    auto s = std::make_unique<DefFnStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->name = name;
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

std::unique_ptr<Stmt> GotoStmt::clone() const {
    auto s = std::make_unique<GotoStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->target_expr = target_expr->clone();
    return s;
}

void GotoStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> GosubStmt::clone() const {
    auto s = std::make_unique<GosubStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->target_expr = target_expr->clone();
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

std::unique_ptr<Stmt> RemStmt::clone() const {
    auto s = std::make_unique<RemStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->text = text;
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

std::unique_ptr<Stmt> LoadStmt::clone() const {
    auto s = std::make_unique<LoadStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->filename_expr = filename_expr->clone();
    return s;
}

void LoadStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> SaveStmt::clone() const {
    auto s = std::make_unique<SaveStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->filename_expr = filename_expr->clone();
    return s;
}

void SaveStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> PokeStmt::clone() const {
    auto s = std::make_unique<PokeStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->address = address->clone();
    s->value = value->clone();
    return s;
}

void PokeStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> PokewStmt::clone() const {
    auto s = std::make_unique<PokewStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->address = address->clone();
    s->value = value->clone();
    return s;
}

void PokewStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> PlotStmt::clone() const {
    auto s = std::make_unique<PlotStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->x_expr = x_expr->clone();
    s->y_expr = y_expr->clone();
    return s;
}

void PlotStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> UnplotStmt::clone() const {
    auto s = std::make_unique<UnplotStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->x_expr = x_expr->clone();
    s->y_expr = y_expr->clone();
    return s;
}

void UnplotStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> RandStmt::clone() const {
    auto s = std::make_unique<RandStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    if (seed_expr) {
        s->seed_expr = seed_expr->clone();
    }
    return s;
}

void RandStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> PauseStmt::clone() const {
    auto s = std::make_unique<PauseStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->duration_expr = duration_expr->clone();
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

std::unique_ptr<Stmt> PragmaNumVarStmt::clone() const {
    auto s = std::make_unique<PragmaNumVarStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->name = name;
    s->value = value;
    return s;
}

void PragmaNumVarStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> PragmaStrVarStmt::clone() const {
    auto s = std::make_unique<PragmaStrVarStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->name = name;
    s->value = value;
    s->asm_lines = asm_lines;
    return s;
}

void PragmaStrVarStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> PragmaNumVarArrayStmt::clone() const {
    auto s = std::make_unique<PragmaNumVarArrayStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->name = name;
    s->dims = dims;
    s->values = values;
    return s;
}

void PragmaNumVarArrayStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

std::unique_ptr<Stmt> PragmaStrVarArrayStmt::clone() const {
    auto s = std::make_unique<PragmaStrVarArrayStmt>(loc);
    s->mark_for_removal = mark_for_removal;
    s->name = name;
    s->dims = dims;
    s->values = values;
    return s;
}

void PragmaStrVarArrayStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

