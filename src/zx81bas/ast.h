//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast_expr.h"
#include "ast_stmt.h"
#include "dump_context.h"
#include <memory>
#include <string>
#include <vector>

bool is_string_variable(const std::string& name);

struct ASTVisitor {
    virtual ~ASTVisitor() = default;

    // visit methods for each statement type
    virtual void visit(JumpTargetStmt&) {}
    virtual void visit(LetStmt&) {}
    virtual void visit(DimStmt&) {}
    virtual void visit(IfStmt&) {}
    virtual void visit(RepeatStmt&) {}
    virtual void visit(WhileStmt&) {}
    virtual void visit(ForStmt&) {}
    virtual void visit(NextStmt&) {}
    virtual void visit(DefProcStmt&) {}
    virtual void visit(ProcCallStmt&) {}
    virtual void visit(LocalStmt&) {}
    virtual void visit(DefFnStmt&) {}
    virtual void visit(ExitStmt&) {}
    virtual void visit(GotoStmt&) {}
    virtual void visit(GosubStmt&) {}
    virtual void visit(ReturnStmt&) {}
    virtual void visit(StopStmt&) {}
    virtual void visit(EndStmt&) {}
    virtual void visit(PrintStmt&) {}
    virtual void visit(InputStmt&) {}
    virtual void visit(RemStmt&) {}
    virtual void visit(RunStmt&) {}
    virtual void visit(ListStmt&) {}
    virtual void visit(NewStmt&) {}
    virtual void visit(ClsStmt&) {}
    virtual void visit(LoadStmt&) {}
    virtual void visit(SaveStmt&) {}
    virtual void visit(PokeStmt&) {}
    virtual void visit(PokewStmt&) {}
    virtual void visit(PlotStmt&) {}
    virtual void visit(UnplotStmt&) {}
    virtual void visit(RandStmt&) {}
    virtual void visit(PauseStmt&) {}
    virtual void visit(FastStmt&) {}
    virtual void visit(SlowStmt&) {}
    virtual void visit(ScrollStmt&) {}
    virtual void visit(ContStmt&) {}
    virtual void visit(ClearStmt&) {}
    virtual void visit(PragmaNumVarStmt&) {}
    virtual void visit(PragmaStrVarStmt&) {}
    virtual void visit(PragmaNumVarArrayStmt&) {}
    virtual void visit(PragmaStrVarArrayStmt&) {}

    // visit methods for each expression type
    virtual void visit(Expr&) {}
    virtual void visit(NumberExpr&) {}
    virtual void visit(LabelLineRefExpr&) {}
    virtual void visit(LabelAddrRefExpr&) {}
    virtual void visit(StringLiteralExpr&) {}
    virtual void visit(VariableExpr&) {}
    virtual void visit(ArrayRefExpr&) {}
    virtual void visit(SliceExpr&) {}
    virtual void visit(UnaryExpr&) {}
    virtual void visit(BinaryExpr&) {}
    virtual void visit(BasicFuncCallExpr&) {}
    virtual void visit(ProcCallExpr&) {}
    virtual void visit(FnCallExpr&) {}

};

struct ASTWalker : ASTVisitor {
    // enter/leave hooks for block statement type
    virtual void enter(IfStmt&) {}
    virtual void leave(IfStmt&) {}
    virtual void enter(RepeatStmt&) {}
    virtual void leave(RepeatStmt&) {}
    virtual void enter(WhileStmt&) {}
    virtual void leave(WhileStmt&) {}
    virtual void enter(ForStmt&) {}
    virtual void leave(ForStmt&) {}
    virtual void enter(DefProcStmt&) {}
    virtual void leave(DefProcStmt&) {}

    // enter/leave hooks for expressions holding other expressions type
    virtual void enter(ArrayRefExpr&) {}
    virtual void leave(ArrayRefExpr&) {}
    virtual void enter(SliceExpr&) {}
    virtual void leave(SliceExpr&) {}
    virtual void enter(UnaryExpr&) {}
    virtual void leave(UnaryExpr&) {}
    virtual void enter(BinaryExpr&) {}
    virtual void leave(BinaryExpr&) {}
    virtual void enter(BasicFuncCallExpr&) {}
    virtual void leave(BasicFuncCallExpr&) {}
    virtual void enter(ProcCallExpr&) {}
    virtual void leave(ProcCallExpr&) {}
    virtual void enter(FnCallExpr&) {}
    virtual void leave(FnCallExpr&) {}

    // ---- Default recursive behavior ----
    void visit(IfStmt& s) override;
    void visit(RepeatStmt& s) override;
    void visit(WhileStmt& s) override;
    void visit(ForStmt& s) override;
    void visit(DefProcStmt& s) override;

    void visit(ArrayRefExpr& e) override;
    void visit(SliceExpr& e) override;
    void visit(UnaryExpr& e) override;
    void visit(BinaryExpr& e) override;
    void visit(BasicFuncCallExpr& e) override;
    void visit(ProcCallExpr& e) override;
    void visit(FnCallExpr& e) override;

};

#ifdef _DEBUG

struct Expr;

void dump_expr_list(const char* name,
                    const std::vector<std::unique_ptr<Expr>>& list,
                    DumpContext& ctx);
void dump_child_expr(const char* name, const Expr* e, DumpContext& ctx);

#endif
