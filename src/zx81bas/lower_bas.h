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

struct LoweredExpr {
    std::vector<StmtPtr> preamble;  // stmts to compute the expression
    ExprPtr rewritten;              // the rewritten expression
};

struct LoweringPass {
    Prog& prog;
    Symtab& symtab;

    explicit LoweringPass(Prog& p, Symtab& s) : prog(p), symtab(s) {}
    virtual ~LoweringPass() = default;

    LoweredExpr lower_expr(Expr& expr);
    LoweredExpr lower_number(NumberExpr& expr);
    LoweredExpr lower_label_line_ref(LabelLineRefExpr& expr);
    LoweredExpr lower_label_addr_ref(LabelAddrRefExpr& expr);
    LoweredExpr lower_string_literal(StringLiteralExpr& expr);
    LoweredExpr lower_variable(VariableExpr& expr);
    LoweredExpr lower_array_ref(ArrayRefExpr& expr);
    LoweredExpr lower_slice(SliceExpr& expr);
    LoweredExpr lower_unary(UnaryExpr& expr);
    LoweredExpr lower_binary(BinaryExpr& expr);
    LoweredExpr lower_basic_func_call(BasicFuncCallExpr& expr);
    LoweredExpr lower_proc_call_expr(ProcCallExpr& expr);
    LoweredExpr lower_fn_call(FnCallExpr& expr);

    std::vector<StmtPtr> lower_stmt(Stmt& stmt);
    std::vector<StmtPtr> lower_label(LabelStmt& stmt);
    std::vector<StmtPtr> lower_line_num(LineNumStmt& stmt);
    std::vector<StmtPtr> lower_let(LetStmt& stmt);
    std::vector<StmtPtr> lower_dim(DimStmt& stmt);
    std::vector<StmtPtr> lower_if(IfStmt& stmt);
    std::vector<StmtPtr> lower_repeat(RepeatStmt& stmt);
    std::vector<StmtPtr> lower_while(WhileStmt& stmt);
    std::vector<StmtPtr> lower_for(ForStmt& stmt);
    std::vector<StmtPtr> lower_next(NextStmt& stmt);
    std::vector<StmtPtr> lower_def_proc(DefProcStmt& stmt);
    std::vector<StmtPtr> lower_proc_call(ProcCallStmt& stmt);
    std::vector<StmtPtr> lower_local(LocalStmt& stmt);
    std::vector<StmtPtr> lower_def_fn(DefFnStmt& stmt);
    std::vector<StmtPtr> lower_exit(ExitStmt& stmt);
    std::vector<StmtPtr> lower_goto(GotoStmt& stmt);
    std::vector<StmtPtr> lower_gosub(GosubStmt& stmt);
    std::vector<StmtPtr> lower_return(ReturnStmt& stmt);
    std::vector<StmtPtr> lower_stop(StopStmt& stmt);
    std::vector<StmtPtr> lower_end(EndStmt& stmt);
    std::vector<StmtPtr> lower_print(PrintStmt& stmt);
    std::vector<StmtPtr> lower_input(InputStmt& stmt);
    std::vector<StmtPtr> lower_rem(RemStmt& stmt);
    std::vector<StmtPtr> lower_run(RunStmt& stmt);
    std::vector<StmtPtr> lower_list(ListStmt& stmt);
    std::vector<StmtPtr> lower_new(NewStmt& stmt);
    std::vector<StmtPtr> lower_cls(ClsStmt& stmt);
    std::vector<StmtPtr> lower_load(LoadStmt& stmt);
    std::vector<StmtPtr> lower_save(SaveStmt& stmt);
    std::vector<StmtPtr> lower_poke(PokeStmt& stmt);
    std::vector<StmtPtr> lower_pokew(PokewStmt& stmt);
    std::vector<StmtPtr> lower_plot(PlotStmt& stmt);
    std::vector<StmtPtr> lower_unplot(UnplotStmt& stmt);
    std::vector<StmtPtr> lower_rand(RandStmt& stmt);
    std::vector<StmtPtr> lower_pause(PauseStmt& stmt);
    std::vector<StmtPtr> lower_fast(FastStmt& stmt);
    std::vector<StmtPtr> lower_slow(SlowStmt& stmt);
    std::vector<StmtPtr> lower_scroll(ScrollStmt& stmt);
    std::vector<StmtPtr> lower_cont(ContStmt& stmt);
    std::vector<StmtPtr> lower_clear(ClearStmt& stmt);
    std::vector<StmtPtr> lower_pragma_num_var(PragmaNumVarStmt& stmt);
    std::vector<StmtPtr> lower_pragma_str_var(PragmaStrVarStmt& stmt);
    std::vector<StmtPtr> lower_pragma_num_var_array(PragmaNumVarArrayStmt& stmt);
    std::vector<StmtPtr> lower_pragma_str_var_array(PragmaStrVarArrayStmt& stmt);
};

bool lower_prog(Prog& prog, Symtab& symtab);
