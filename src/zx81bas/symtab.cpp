//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast_expr.h"
#include "ast_stmt.h"
#include "dump_context.h"
#include "errors.h"
#include "options.h"
#include "symtab.h"
#include <cstdlib>
#include <iostream>
#include <memory>
#include <utility>
#include <vector>
#include <string>

static void collect_defined_symbols(const std::vector<std::unique_ptr<Stmt>>&
                                    stmts,
                                    Symtab& symtab) {
    for (const auto& stmt : stmts) {
        if (auto jump_target_stmt = dynamic_cast<JumpTargetStmt*>(stmt.get())) {
            if (!jump_target_stmt->label.empty()) {
                auto it = symtab.labels.find(jump_target_stmt->label);
                if (it != symtab.labels.end()) {
                    error(jump_target_stmt->loc, "Duplicate label: " + jump_target_stmt->label);
                    error(it->second, "Previous label defined here");
                }
                else {
                    symtab.labels[jump_target_stmt->label] = jump_target_stmt->loc;
                }
            }
            if (jump_target_stmt->basic_line_num > 0) {
                auto it = symtab.line_nums.find(jump_target_stmt->basic_line_num);
                if (it != symtab.line_nums.end()) {
                    error(jump_target_stmt->loc,
                          "Duplicate line number: " + std::to_string(jump_target_stmt->basic_line_num));
                    error(it->second, "Previous line number defined here");
                }
                else {
                    symtab.line_nums[jump_target_stmt->basic_line_num] = jump_target_stmt->loc;
                }
            }
        }
        else if (auto let_stmt = dynamic_cast<LetStmt*>(stmt.get())) {
            if (auto var_expr = dynamic_cast<VariableExpr*>(let_stmt->lhs.get())) {
                // may be assigned multiple times, store the first location only
                auto it = symtab.vars.find(var_expr->name);
                if (it == symtab.vars.end()) {
                    symtab.vars[var_expr->name] = var_expr->loc;
                }
            }
            else if (auto array_ref_expr = dynamic_cast<ArrayRefExpr*>
                                           (let_stmt->lhs.get())) {
                // may be assigned multiple times, store the first location only
                auto it = symtab.arrays.find(array_ref_expr->name);
                if (it == symtab.arrays.end()) {
                    symtab.arrays[array_ref_expr->name] = array_ref_expr->loc;
                }
            }
        }
        else if (auto dim_stmt = dynamic_cast<DimStmt*>(stmt.get())) {
            for (const auto& dim_item : dim_stmt->items) {
                // may be assigned multiple times, store the first location only
                auto it = symtab.arrays.find(dim_item.name);
                if (it == symtab.arrays.end()) {
                    symtab.arrays[dim_item.name] = dim_stmt->loc;
                }
            }
        }
        else if (auto if_stmt = dynamic_cast<IfStmt*>(stmt.get())) {
            collect_defined_symbols(if_stmt->then_stmts, symtab);
            collect_defined_symbols(if_stmt->else_stmts, symtab);
        }
        else if (auto repeat_stmt = dynamic_cast<RepeatStmt*>(stmt.get())) {
            collect_defined_symbols(repeat_stmt->body, symtab);
        }
        else if (auto while_stmt = dynamic_cast<WhileStmt*>(stmt.get())) {
            collect_defined_symbols(while_stmt->body, symtab);
        }
        else if (auto for_stmt = dynamic_cast<ForStmt*>(stmt.get())) {
            // loop variable is defined in the FOR statement
            auto it = symtab.vars.find(for_stmt->name);
            if (it == symtab.vars.end()) {
                symtab.vars[for_stmt->name] = for_stmt->loc;
            }
            collect_defined_symbols(for_stmt->body, symtab);
        }
        else if (auto def_proc_stmt = dynamic_cast<DefProcStmt*>(stmt.get())) {
            auto it = symtab.procs.find(def_proc_stmt->name);
            if (it != symtab.procs.end()) {
                error(def_proc_stmt->loc, "Duplicate procedure: " + def_proc_stmt->name);
                error(it->second->loc, "Previous procedure defined here");
            }
            else {
                symtab.procs[def_proc_stmt->name] = def_proc_stmt;
            }
            for (const auto& param : def_proc_stmt->params) {
                std::string var_name = def_proc_stmt->name + param;
                auto it = symtab.vars.find(var_name);
                if (it == symtab.vars.end()) {
                    symtab.vars[var_name] = def_proc_stmt->loc;
                }
            }
            for (const auto& local : def_proc_stmt->locals) {
                std::string var_name = def_proc_stmt->name + local;
                auto it = symtab.vars.find(var_name);
                if (it == symtab.vars.end()) {
                    symtab.vars[var_name] = def_proc_stmt->loc;
                }
            }
            collect_defined_symbols(def_proc_stmt->body, symtab);
        }
        else if (auto def_fn_stmt = dynamic_cast<DefFnStmt*>(stmt.get())) {
            auto it = symtab.fns.find(def_fn_stmt->name);
            if (it != symtab.fns.end()) {
                error(def_fn_stmt->loc, "Duplicate function: " + def_fn_stmt->name);
                error(it->second->loc, "Previous function defined here");
            }
            else {
                symtab.fns[def_fn_stmt->name] = def_fn_stmt;
            }
            for (const auto& param : def_fn_stmt->params) {
                std::string var_name = def_fn_stmt->name + param;
                auto it = symtab.vars.find(var_name);
                if (it == symtab.vars.end()) {
                    symtab.vars[var_name] = def_fn_stmt->loc;
                }
            }
        }
        else if (auto input_stmt = dynamic_cast<InputStmt*>(stmt.get())) {
            for (const auto& var : input_stmt->vars) {
                if (auto var_expr = dynamic_cast<VariableExpr*>(var.get())) {
                    // may be assigned multiple times, store the first location only
                    auto it = symtab.vars.find(var_expr->name);
                    if (it == symtab.vars.end()) {
                        symtab.vars[var_expr->name] = var_expr->loc;
                    }
                }
                else if (auto array_ref_expr = dynamic_cast<ArrayRefExpr*>
                                               (var.get())) {
                    // may be assigned multiple times, store the first location only
                    auto it = symtab.arrays.find(array_ref_expr->name);
                    if (it == symtab.arrays.end()) {
                        symtab.arrays[array_ref_expr->name] = array_ref_expr->loc;
                    }
                }
            }
        }
        else if (auto vars_stmt = dynamic_cast<PragmaNumVarStmt*>(stmt.get())) {
            auto it = symtab.vars.find(vars_stmt->name);
            if (it == symtab.vars.end()) {
                symtab.vars[vars_stmt->name] = vars_stmt->loc;
            }
        }
        else if (auto vars_stmt = dynamic_cast<PragmaStrVarStmt*>(stmt.get())) {
            auto it = symtab.vars.find(vars_stmt->name);
            if (it == symtab.vars.end()) {
                symtab.vars[vars_stmt->name] = vars_stmt->loc;
            }
        }
        else if (auto vars_stmt = dynamic_cast<PragmaNumVarArrayStmt*>(stmt.get())) {
            auto it = symtab.arrays.find(vars_stmt->name);
            if (it == symtab.arrays.end()) {
                symtab.arrays[vars_stmt->name] = vars_stmt->loc;
            }
        }
        else if (auto vars_stmt = dynamic_cast<PragmaStrVarArrayStmt*>(stmt.get())) {
            auto it = symtab.arrays.find(vars_stmt->name);
            if (it == symtab.arrays.end()) {
                symtab.arrays[vars_stmt->name] = vars_stmt->loc;
            }
        }
    }
}

static void verify_undefined_symbols(const Expr* expr, const Symtab& symtab) {
    if (auto label_ref_expr = dynamic_cast<const LabelLineRefExpr*>(expr)) {
        if (symtab.labels.find(label_ref_expr->name) == symtab.labels.end()) {
            error(label_ref_expr->loc, "Undefined label: " + label_ref_expr->name);
        }
    }
    else if (auto label_addr_ref_expr =
                 dynamic_cast<const LabelAddrRefExpr*>(expr)) {
        if (symtab.vars.find(label_addr_ref_expr->name) == symtab.vars.end()) {
            error(label_addr_ref_expr->loc,
                  "Undefined variable: " + label_addr_ref_expr->name);
        }
    }
    else if (auto var_expr = dynamic_cast<const VariableExpr*>(expr)) {
        if (symtab.vars.find(var_expr->name) == symtab.vars.end()) {
            error(var_expr->loc, "Undefined variable: " + var_expr->name);
        }
    }
    else if (auto array_ref_expr = dynamic_cast<const ArrayRefExpr*>(expr)) {
        if (symtab.arrays.find(array_ref_expr->name) == symtab.arrays.end()) {
            error(array_ref_expr->loc, "Undefined array: " + array_ref_expr->name);
        }
    }
    else if (auto slice_expr = dynamic_cast<const SliceExpr*>(expr)) {
        verify_undefined_symbols(slice_expr->base.get(), symtab);
        if (slice_expr->from) {
            verify_undefined_symbols(slice_expr->from.get(), symtab);
        }
        if (slice_expr->to) {
            verify_undefined_symbols(slice_expr->to.get(), symtab);
        }
    }
    else if (auto un_expr = dynamic_cast<const UnaryExpr*>(expr)) {
        verify_undefined_symbols(un_expr->operand.get(), symtab);
    }
    else if (auto bin_expr = dynamic_cast<const BinaryExpr*>(expr)) {
        verify_undefined_symbols(bin_expr->lhs.get(), symtab);
        verify_undefined_symbols(bin_expr->rhs.get(), symtab);
    }
    else if (auto call_expr = dynamic_cast<const BasicFuncCallExpr*>(expr)) {
        for (const auto& arg : call_expr->args) {
            verify_undefined_symbols(arg.get(), symtab);
        }
    }
    else if (auto call_expr = dynamic_cast<const ProcCallExpr*>(expr)) {
        if (symtab.procs.find(call_expr->name) == symtab.procs.end()) {
            error(call_expr->loc, "Undefined procedure: " + call_expr->name);
        }
        for (const auto& arg : call_expr->args) {
            verify_undefined_symbols(arg.get(), symtab);
        }
    }
    else if (auto call_expr = dynamic_cast<const FnCallExpr*>(expr)) {
        if (symtab.fns.find(call_expr->name) == symtab.fns.end()) {
            error(call_expr->loc, "Undefined function: " + call_expr->name);
        }
        for (const auto& arg : call_expr->args) {
            verify_undefined_symbols(arg.get(), symtab);
        }
    }
}

static void verify_undefined_symbols(const std::vector<std::unique_ptr<Stmt>>&
                                     stmts, const Symtab& symtab) {

    for (const auto& stmt : stmts) {
        if (auto let_stmt = dynamic_cast<LetStmt*>(stmt.get())) {
            verify_undefined_symbols(let_stmt->rhs.get(), symtab);
        }
        else if (auto dim_stmt = dynamic_cast<DimStmt*>(stmt.get())) {
            for (const auto& dim_item : dim_stmt->items) {
                for (const auto& dim : dim_item.dims) {
                    verify_undefined_symbols(dim.get(), symtab);
                }
            }
        }
        else if (auto if_stmt = dynamic_cast<IfStmt*>(stmt.get())) {
            verify_undefined_symbols(if_stmt->condition.get(), symtab);
            verify_undefined_symbols(if_stmt->then_stmts, symtab);
            verify_undefined_symbols(if_stmt->else_stmts, symtab);
        }
        else if (auto repeat_stmt = dynamic_cast<RepeatStmt*>(stmt.get())) {
            verify_undefined_symbols(repeat_stmt->body, symtab);
            verify_undefined_symbols(repeat_stmt->condition.get(), symtab);
        }
        else if (auto while_stmt = dynamic_cast<WhileStmt*>(stmt.get())) {
            verify_undefined_symbols(while_stmt->condition.get(), symtab);
            verify_undefined_symbols(while_stmt->body, symtab);
        }
        else if (auto for_stmt = dynamic_cast<ForStmt*>(stmt.get())) {
            verify_undefined_symbols(for_stmt->start_expr.get(), symtab);
            verify_undefined_symbols(for_stmt->end_expr.get(), symtab);
            verify_undefined_symbols(for_stmt->step_expr.get(), symtab);
            verify_undefined_symbols(for_stmt->body, symtab);
        }
        else if (auto def_proc_stmt = dynamic_cast<DefProcStmt*>(stmt.get())) {
            verify_undefined_symbols(def_proc_stmt->body, symtab);
        }
        else if (auto proc_call_stmt = dynamic_cast<ProcCallStmt*>(stmt.get())) {
            for (const auto& arg : proc_call_stmt->args) {
                verify_undefined_symbols(arg.get(), symtab);
            }
        }
        else if (auto def_fn_stmt = dynamic_cast<DefFnStmt*>(stmt.get())) {
            verify_undefined_symbols(def_fn_stmt->expr.get(), symtab);
        }
        else if (auto goto_stmt = dynamic_cast<GotoStmt*>(stmt.get())) {
            verify_undefined_symbols(goto_stmt->target_expr.get(), symtab);
            if (auto line_num_expr = dynamic_cast<NumberExpr*>
                                     (goto_stmt->target_expr.get())) {
                int line_num = static_cast<int>(line_num_expr->value);
                if (symtab.line_nums.find(line_num) == symtab.line_nums.end()) {
                    error(line_num_expr->loc, "Undefined line number: " + std::to_string(line_num));
                }
            }
        }
        else if (auto gosub_stmt = dynamic_cast<GosubStmt*>(stmt.get())) {
            verify_undefined_symbols(gosub_stmt->target_expr.get(), symtab);
            if (auto line_num_expr = dynamic_cast<NumberExpr*>
                                     (gosub_stmt->target_expr.get())) {
                int line_num = static_cast<int>(line_num_expr->value);
                if (symtab.line_nums.find(line_num) == symtab.line_nums.end()) {
                    error(line_num_expr->loc, "Undefined line number: " + std::to_string(line_num));
                }
            }
        }
        else if (auto print_stmt = dynamic_cast<PrintStmt*>(stmt.get())) {
            for (const auto& item : print_stmt->items) {
                if (item.type == PrintItem::Type::Expr) {
                    verify_undefined_symbols(item.expr.get(), symtab);
                }
                else if (item.type == PrintItem::Type::At) {
                    verify_undefined_symbols(item.line_expr.get(), symtab);
                    verify_undefined_symbols(item.col_expr.get(), symtab);
                }
                else if (item.type == PrintItem::Type::Tab) {
                    verify_undefined_symbols(item.tab_expr.get(), symtab);
                }
            }
        }
        else if (auto run_stmt = dynamic_cast<RunStmt*>(stmt.get())) {
            if (run_stmt->target_expr) {
                verify_undefined_symbols(run_stmt->target_expr.get(), symtab);
                if (auto line_num_expr = dynamic_cast<NumberExpr*>
                                         (run_stmt->target_expr.get())) {
                    int line_num = static_cast<int>(line_num_expr->value);
                    if (symtab.line_nums.find(line_num) == symtab.line_nums.end()) {
                        error(line_num_expr->loc, "Undefined line number: " + std::to_string(line_num));
                    }
                }
            }
        }
        else if (auto list_stmt = dynamic_cast<ListStmt*>(stmt.get())) {
            if (list_stmt->target_expr) {
                verify_undefined_symbols(list_stmt->target_expr.get(), symtab);
                if (auto line_num_expr = dynamic_cast<NumberExpr*>
                                         (list_stmt->target_expr.get())) {
                    int line_num = static_cast<int>(line_num_expr->value);
                    if (symtab.line_nums.find(line_num) == symtab.line_nums.end()) {
                        error(line_num_expr->loc, "Undefined line number: " + std::to_string(line_num));
                    }
                }
            }
        }
        else if (auto load_stmt = dynamic_cast<LoadStmt*>(stmt.get())) {
            verify_undefined_symbols(load_stmt->filename_expr.get(), symtab);
        }
        else if (auto save_stmt = dynamic_cast<SaveStmt*>(stmt.get())) {
            verify_undefined_symbols(save_stmt->filename_expr.get(), symtab);
        }
        else if (auto poke_stmt = dynamic_cast<PokeStmt*>(stmt.get())) {
            verify_undefined_symbols(poke_stmt->address.get(), symtab);
            verify_undefined_symbols(poke_stmt->value.get(), symtab);
        }
        else if (auto pokew_stmt = dynamic_cast<PokewStmt*>(stmt.get())) {
            verify_undefined_symbols(pokew_stmt->address.get(), symtab);
            verify_undefined_symbols(pokew_stmt->value.get(), symtab);
        }
        else if (auto plot_stmt = dynamic_cast<PlotStmt*>(stmt.get())) {
            verify_undefined_symbols(plot_stmt->x_expr.get(), symtab);
            verify_undefined_symbols(plot_stmt->y_expr.get(), symtab);
        }
        else if (auto unplot_stmt = dynamic_cast<UnplotStmt*>(stmt.get())) {
            verify_undefined_symbols(unplot_stmt->x_expr.get(), symtab);
            verify_undefined_symbols(unplot_stmt->y_expr.get(), symtab);
        }
        else if (auto rand_stmt = dynamic_cast<RandStmt*>(stmt.get())) {
            verify_undefined_symbols(rand_stmt->seed_expr.get(), symtab);
        }
        else if (auto pause_stmt = dynamic_cast<PauseStmt*>(stmt.get())) {
            verify_undefined_symbols(pause_stmt->duration_expr.get(), symtab);
        }
    }
}

bool create_symtab(const Prog& prog, std::unique_ptr<Symtab>& out_symtab) {
    auto symtab = std::make_unique<Symtab>();

    // pass 1: collect all symbols from the program
    collect_defined_symbols(prog.vars, *symtab);
    collect_defined_symbols(prog.stmts, *symtab);

    // pass 2: check for duplicates and report errors
    verify_undefined_symbols(prog.stmts, *symtab);

#ifdef _DEBUG
    if (g_dump_step == 7) {
        if (get_error_count() > 0) {
            std::cerr << "Symbols check failed with " << get_error_count() << " errors\n";
        }
        else {
            DumpContext ctx(std::cout);
            symtab->dump(ctx);
        }
        exit(EXIT_SUCCESS);
    }
#endif

    if (get_error_count() > 0) {
        return false;
    }

    out_symtab = std::move(symtab);
    return true;
}
