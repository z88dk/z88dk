//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast.h"
#include "symtab.h"
#include <memory>
#include <vector>

struct ASTVisitor {
    virtual ~ASTVisitor() = default;

    void walk_stmts(std::vector<StmtPtr>& list);
    void walk_expr(ExprPtr& expr);

    virtual bool enter(NumberExpr&);
    virtual void visit(NumberExpr&) {}
    virtual void leave(NumberExpr&) {}

    virtual bool enter(LabelLineRefExpr&);
    virtual void visit(LabelLineRefExpr&) {}
    virtual void leave(LabelLineRefExpr&) {}

    virtual bool enter(LabelAddrRefExpr&);
    virtual void visit(LabelAddrRefExpr&) {}
    virtual void leave(LabelAddrRefExpr&) {}

    virtual bool enter(StringLiteralExpr&);
    virtual void visit(StringLiteralExpr&) {}
    virtual void leave(StringLiteralExpr&) {}

    virtual bool enter(VariableExpr&);
    virtual void visit(VariableExpr&) {}
    virtual void leave(VariableExpr&) {}

    virtual bool enter(ArrayRefExpr&);
    virtual void visit(ArrayRefExpr&) {}
    virtual void leave(ArrayRefExpr&) {}

    virtual bool enter(SliceExpr&);
    virtual void visit(SliceExpr&) {}
    virtual void leave(SliceExpr&) {}

    virtual bool enter(UnaryExpr&);
    virtual void visit(UnaryExpr&) {}
    virtual void leave(UnaryExpr&) {}

    virtual bool enter(BinaryExpr&);
    virtual void visit(BinaryExpr&) {}
    virtual void leave(BinaryExpr&) {}

    virtual bool enter(BasicFuncCallExpr&);
    virtual void visit(BasicFuncCallExpr&) {}
    virtual void leave(BasicFuncCallExpr&) {}

    virtual bool enter(ProcCallExpr&);
    virtual void visit(ProcCallExpr&) {}
    virtual void leave(ProcCallExpr&) {}

    virtual bool enter(FnCallExpr&);
    virtual void visit(FnCallExpr&) {}
    virtual void leave(FnCallExpr&) {}

    virtual bool enter(LabelStmt&);
    virtual void visit(LabelStmt&) {}
    virtual void leave(LabelStmt&) {}

    virtual bool enter(LineNumStmt&);
    virtual void visit(LineNumStmt&) {}
    virtual void leave(LineNumStmt&) {}

    virtual bool enter(LetStmt&);
    virtual void visit(LetStmt&) {}
    virtual void leave(LetStmt&) {}

    virtual bool enter(DimStmt&);
    virtual void visit(DimStmt&) {}
    virtual void leave(DimStmt&) {}

    virtual bool enter(IfStmt&);
    virtual void visit(IfStmt&) {}
    virtual void leave(IfStmt&) {}

    virtual bool enter(RepeatStmt&);
    virtual void visit(RepeatStmt&) {}
    virtual void leave(RepeatStmt&) {}

    virtual bool enter(WhileStmt&);
    virtual void visit(WhileStmt&) {}
    virtual void leave(WhileStmt&) {}

    virtual bool enter(ForStmt&);
    virtual void visit(ForStmt&) {}
    virtual void leave(ForStmt&) {}

    virtual bool enter(NextStmt&);
    virtual void visit(NextStmt&) {}
    virtual void leave(NextStmt&) {}

    virtual bool enter(DefProcStmt&);
    virtual void visit(DefProcStmt&) {}
    virtual void leave(DefProcStmt&) {}

    virtual bool enter(ProcCallStmt&);
    virtual void visit(ProcCallStmt&) {}
    virtual void leave(ProcCallStmt&) {}

    virtual bool enter(LocalStmt&);
    virtual void visit(LocalStmt&) {}
    virtual void leave(LocalStmt&) {}

    virtual bool enter(DefFnStmt&);
    virtual void visit(DefFnStmt&) {}
    virtual void leave(DefFnStmt&) {}

    virtual bool enter(ExitStmt&);
    virtual void visit(ExitStmt&) {}
    virtual void leave(ExitStmt&) {}

    virtual bool enter(GotoStmt&);
    virtual void visit(GotoStmt&) {}
    virtual void leave(GotoStmt&) {}

    virtual bool enter(GosubStmt&);
    virtual void visit(GosubStmt&) {}
    virtual void leave(GosubStmt&) {}

    virtual bool enter(ReturnStmt&);
    virtual void visit(ReturnStmt&) {}
    virtual void leave(ReturnStmt&) {}

    virtual bool enter(StopStmt&);
    virtual void visit(StopStmt&) {}
    virtual void leave(StopStmt&) {}

    virtual bool enter(EndStmt&);
    virtual void visit(EndStmt&) {}
    virtual void leave(EndStmt&) {}

    virtual bool enter(PrintStmt&);
    virtual void visit(PrintStmt&) {}
    virtual void leave(PrintStmt&) {}

    virtual bool enter(LPrintStmt&);
    virtual void visit(LPrintStmt&) {}
    virtual void leave(LPrintStmt&) {}

    virtual bool enter(InputStmt&);
    virtual void visit(InputStmt&) {}
    virtual void leave(InputStmt&) {}

    virtual bool enter(RemStmt&);
    virtual void visit(RemStmt&) {}
    virtual void leave(RemStmt&) {}

    virtual bool enter(RunStmt&);
    virtual void visit(RunStmt&) {}
    virtual void leave(RunStmt&) {}

    virtual bool enter(ListStmt&);
    virtual void visit(ListStmt&) {}
    virtual void leave(ListStmt&) {}

    virtual bool enter(LListStmt&);
    virtual void visit(LListStmt&) {}
    virtual void leave(LListStmt&) {}

    virtual bool enter(NewStmt&);
    virtual void visit(NewStmt&) {}
    virtual void leave(NewStmt&) {}

    virtual bool enter(ClsStmt&);
    virtual void visit(ClsStmt&) {}
    virtual void leave(ClsStmt&) {}

    virtual bool enter(LoadStmt&);
    virtual void visit(LoadStmt&) {}
    virtual void leave(LoadStmt&) {}

    virtual bool enter(SaveStmt&);
    virtual void visit(SaveStmt&) {}
    virtual void leave(SaveStmt&) {}

    virtual bool enter(PokeStmt&);
    virtual void visit(PokeStmt&) {}
    virtual void leave(PokeStmt&) {}

    virtual bool enter(PokewStmt&);
    virtual void visit(PokewStmt&) {}
    virtual void leave(PokewStmt&) {}

    virtual bool enter(PlotStmt&);
    virtual void visit(PlotStmt&) {}
    virtual void leave(PlotStmt&) {}

    virtual bool enter(UnplotStmt&);
    virtual void visit(UnplotStmt&) {}
    virtual void leave(UnplotStmt&) {}

    virtual bool enter(RandStmt&);
    virtual void visit(RandStmt&) {}
    virtual void leave(RandStmt&) {}

    virtual bool enter(PauseStmt&);
    virtual void visit(PauseStmt&) {}
    virtual void leave(PauseStmt&) {}

    virtual bool enter(FastStmt&);
    virtual void visit(FastStmt&) {}
    virtual void leave(FastStmt&) {}

    virtual bool enter(SlowStmt&);
    virtual void visit(SlowStmt&) {}
    virtual void leave(SlowStmt&) {}

    virtual bool enter(ScrollStmt&);
    virtual void visit(ScrollStmt&) {}
    virtual void leave(ScrollStmt&) {}

    virtual bool enter(ContStmt&);
    virtual void visit(ContStmt&) {}
    virtual void leave(ContStmt&) {}

    virtual bool enter(ClearStmt&);
    virtual void visit(ClearStmt&) {}
    virtual void leave(ClearStmt&) {}

    virtual bool enter(CopyStmt&);
    virtual void visit(CopyStmt&) {}
    virtual void leave(CopyStmt&) {}

    virtual bool enter(PragmaNumVarStmt&);
    virtual void visit(PragmaNumVarStmt&) {}
    virtual void leave(PragmaNumVarStmt&) {}

    virtual bool enter(PragmaStrVarStmt&);
    virtual void visit(PragmaStrVarStmt&) {}
    virtual void leave(PragmaStrVarStmt&) {}

    virtual bool enter(PragmaNumVarArrayStmt&);
    virtual void visit(PragmaNumVarArrayStmt&) {}
    virtual void leave(PragmaNumVarArrayStmt&) {}

    virtual bool enter(PragmaStrVarArrayStmt&);
    virtual void visit(PragmaStrVarArrayStmt&) {}
    virtual void leave(PragmaStrVarArrayStmt&) {}

    virtual bool enter(PragmaLoopVarStmt&);
    virtual void visit(PragmaLoopVarStmt&) {}
    virtual void leave(PragmaLoopVarStmt&) {}

    virtual bool enter(Prog&);
    virtual void visit(Prog&) {}
    virtual void leave(Prog&) {}
};

bool semantic_transform(Prog& prog, Symtab& symtab);
