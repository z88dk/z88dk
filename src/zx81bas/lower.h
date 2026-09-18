//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast.h"
#include "symtab.h"
#include <memory>
#include <string>
#include <vector>
#include "errors.h"

struct LoweredExpr {
    std::vector<StmtPtr> preamble;  // stmts to compute the expression
    ExprPtr rewritten;              // the rewritten expression
};

struct LoweringPass {
    struct ControlStackEntry {
        enum class Type {
            Loop,
            Proc,
        };
        Type type;
        std::string end_label;      // label for the end of the control structure

        ControlStackEntry(Type type_, const std::string& end_label_)
            : type(type_), end_label(end_label_) {}
    };

    Prog& prog;
    Symtab& symtab;
    std::vector<ControlStackEntry> control_stack;

    explicit LoweringPass(Prog& p, Symtab& s) : prog(p), symtab(s) {}
    virtual ~LoweringPass() = default;

    void lower_prog();
    std::vector<StmtPtr> lower_main();
    std::vector<StmtPtr> lower_procs();
    std::vector<StmtPtr> lower_proc(DefProcStmt& proc);

    std::vector<StmtPtr> lower_stmts(std::vector<StmtPtr>& stmts);

    LoweredExpr lower(NumberExpr& expr);
    LoweredExpr lower(LabelLineRefExpr& expr);
    LoweredExpr lower(LabelAddrRefExpr& expr);
    LoweredExpr lower(StringLiteralExpr& expr);
    LoweredExpr lower(VariableExpr& expr);
    LoweredExpr lower(ArrayRefExpr& expr);
    LoweredExpr lower(SliceExpr& expr);
    LoweredExpr lower(UnaryExpr& expr);
    LoweredExpr lower(BinaryExpr& expr);
    LoweredExpr lower(BasicFuncCallExpr& expr);
    LoweredExpr lower(ProcCallExpr& expr);
    LoweredExpr lower(FnCallExpr& expr);

    std::vector<StmtPtr> lower(LabelStmt& stmt);
    std::vector<StmtPtr> lower(LineNumStmt& stmt);
    std::vector<StmtPtr> lower(LetStmt& stmt);
    std::vector<StmtPtr> lower(DimStmt& stmt);
    std::vector<StmtPtr> lower(IfStmt& stmt);
    std::vector<StmtPtr> lower(RepeatStmt& stmt);
    std::vector<StmtPtr> lower(WhileStmt& stmt);
    std::vector<StmtPtr> lower(ForStmt& stmt);
    std::vector<StmtPtr> lower(NextStmt& stmt);
    std::vector<StmtPtr> lower(DefProcStmt& stmt);
    std::vector<StmtPtr> lower(ProcCallStmt& stmt);
    std::vector<StmtPtr> lower(LocalStmt& stmt);
    std::vector<StmtPtr> lower(DefFnStmt& stmt);
    std::vector<StmtPtr> lower(ExitStmt& stmt);
    std::vector<StmtPtr> lower(GotoStmt& stmt);
    std::vector<StmtPtr> lower(GosubStmt& stmt);
    std::vector<StmtPtr> lower(ReturnStmt& stmt);
    std::vector<StmtPtr> lower(StopStmt& stmt);
    std::vector<StmtPtr> lower(EndStmt& stmt);
    std::vector<StmtPtr> lower(PrintStmt& stmt);
    std::vector<StmtPtr> lower(LPrintStmt& stmt);
    std::vector<StmtPtr> lower(InputStmt& stmt);
    std::vector<StmtPtr> lower(RemStmt& stmt);
    std::vector<StmtPtr> lower(RunStmt& stmt);
    std::vector<StmtPtr> lower(ListStmt& stmt);
    std::vector<StmtPtr> lower(LListStmt& stmt);
    std::vector<StmtPtr> lower(NewStmt& stmt);
    std::vector<StmtPtr> lower(ClsStmt& stmt);
    std::vector<StmtPtr> lower(LoadStmt& stmt);
    std::vector<StmtPtr> lower(SaveStmt& stmt);
    std::vector<StmtPtr> lower(PokeStmt& stmt);
    std::vector<StmtPtr> lower(PokewStmt& stmt);
    std::vector<StmtPtr> lower(PlotStmt& stmt);
    std::vector<StmtPtr> lower(UnplotStmt& stmt);
    std::vector<StmtPtr> lower(RandStmt& stmt);
    std::vector<StmtPtr> lower(PauseStmt& stmt);
    std::vector<StmtPtr> lower(FastStmt& stmt);
    std::vector<StmtPtr> lower(SlowStmt& stmt);
    std::vector<StmtPtr> lower(ScrollStmt& stmt);
    std::vector<StmtPtr> lower(ContStmt& stmt);
    std::vector<StmtPtr> lower(ClearStmt& stmt);
    std::vector<StmtPtr> lower(CopyStmt& stmt);
    std::vector<StmtPtr> lower(PragmaNumVarStmt& stmt);
    std::vector<StmtPtr> lower(PragmaStrVarStmt& stmt);
    std::vector<StmtPtr> lower(PragmaNumVarArrayStmt& stmt);
    std::vector<StmtPtr> lower(PragmaStrVarArrayStmt& stmt);

    void append_stmts(std::vector<StmtPtr>& stmts,
                      std::vector<StmtPtr>& move_from);
    void add_let_stmt(std::vector<StmtPtr>& stmts,
                      const std::string& var_name,
                      ExprPtr rhs, const SourceLoc& loc);
    void add_goto_stmt(std::vector<StmtPtr>& stmts,
                       const std::string& label, const SourceLoc& loc);
    void add_gosub_stmt(std::vector<StmtPtr>& stmts,
                        const std::string& label, const SourceLoc& loc);
    void add_return_stmt(std::vector<StmtPtr>& stmts, const SourceLoc& loc);
    void add_label_stmt(std::vector<StmtPtr>& stmts,
                        const std::string& label, const SourceLoc& loc);
    void add_if_not_cond_goto_stmt(std::vector<StmtPtr>& stmts,
                                   ExprPtr cond_expr, const std::string& target_label,
                                   const SourceLoc& loc);
    void add_stop_stmt(std::vector<StmtPtr>& stmts, const SourceLoc& loc);
};

bool lower_prog(Prog& prog, Symtab& symtab);
