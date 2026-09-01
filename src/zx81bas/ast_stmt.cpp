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

void JumpTargetStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void LetStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void DimStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void IfStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void RepeatStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void WhileStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void ForStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void NextStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void DefProcStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void ProcCallStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void LocalStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void DefFnStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void ExitStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void GotoStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void GosubStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void ReturnStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void StopStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void EndStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void PrintStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void InputStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void RemStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void RunStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void ListStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void NewStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void ClsStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void LoadStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void SaveStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void PokeStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void PokewStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void PlotStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void UnplotStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void RandStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void PauseStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void FastStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void SlowStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void ScrollStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void ContStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void ClearStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void PragmaNumVarStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void PragmaStrVarStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void PragmaNumVarArrayStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void PragmaStrVarArrayStmt::accept(ASTVisitor& v) {
    v.visit(*this);
}

void Prog::accept(ASTVisitor& v) {
    for (auto& st : stmts) {
        st->accept(v);
    }
}
