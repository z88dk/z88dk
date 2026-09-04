//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "ast_expr.h"
#include "ast_stmt.h"
#include "errors.h"
#include "symtab.h"
#include <memory>
#include <string>
#include <unordered_set>

struct SymbolDefinitionCollector : ASTWalker {
    using ASTWalker::visit; // so that base class visit methods are visible

    Prog& prog;
    Symtab& symtab;
    int proc_nesting = 0;
    DefProcStmt* cur_def_proc = nullptr;
    std::unordered_set<std::string> def_proc_locals;
    int last_line_num = -1;

    explicit SymbolDefinitionCollector(Prog& p, Symtab& s) : prog(p), symtab(s) {}

    void visit(LabelStmt& stmt) {
        // label already defined?
        auto it = symtab.labels.find(stmt.label);
        if (it != symtab.labels.end()) {
            error(stmt.loc, "Duplicate label: '" + stmt.label + "'");
            error(it->second->loc, "Previous definition");
            return;
        }
        symtab.labels[stmt.label] = &stmt;
    }

    void visit(LineNumStmt& stmt) {
        // label already defined?
        auto it = symtab.line_nums.find(stmt.line_num);
        if (it != symtab.line_nums.end()) {
            error(stmt.loc, "Duplicate line number: '" + std::to_string(
                      stmt.line_num) + "'");
            error(it->second->loc, "Previous definition");
            return;
        }
        if (stmt.line_num <= last_line_num) {
            error(stmt.loc, "Decreasing line number");
        }
        symtab.line_nums[stmt.line_num] = &stmt;
        last_line_num = stmt.line_num;
    }

    void visit(LetStmt& stmt) override {
        // collect variables and arrays from the LHS
        if (auto var_expr = dynamic_cast<VariableExpr*>(stmt.lhs.get())) {
            // may be assigned multiple times, store the first location only
            auto it = symtab.vars.find(var_expr->name);
            if (it == symtab.vars.end()) {
                symtab.vars[var_expr->name] = var_expr->loc;
            }
        }
        else if (auto array_ref_expr = dynamic_cast<ArrayRefExpr*>(stmt.lhs.get())) {
            // may be assigned multiple times, store the first location only
            auto it = symtab.arrays.find(array_ref_expr->name);
            if (it == symtab.arrays.end()) {
                symtab.arrays[array_ref_expr->name] = array_ref_expr->loc;
            }
        }
    }

    void visit(DimStmt& stmt) override {
        // collect arrays from the DIM statement
        for (auto& dim_item : stmt.items) {
            // may be assigned multiple times, store the first location only
            auto it = symtab.arrays.find(dim_item.name);
            if (it == symtab.arrays.end()) {
                symtab.arrays[dim_item.name] = stmt.loc;
            }
        }
    }

    void visit(ForStmt& stmt) override {
        // loop variable is defined in the FOR statement
        auto it = symtab.vars.find(stmt.name);
        if (it == symtab.vars.end()) {
            symtab.vars[stmt.name] = stmt.loc;
        }
    }

    void enter(DefProcStmt& stmt) override {
        proc_nesting++;

        // already in a PROC body?
        if (cur_def_proc != nullptr) {
            error(stmt.loc, "Nested PROC");
            return;
        }
        cur_def_proc = &stmt;

        // PROC already defined?
        auto it = symtab.procs.find(stmt.name);
        if (it != symtab.procs.end()) {
            error(stmt.loc, "Duplicate definition: '" + stmt.name + "'");
            error(it->second->loc, "Previous definition");
            return;
        }
        symtab.procs[stmt.name] = &stmt;

        // collect parameters, detect duplicates
        for (auto& param : stmt.params) {
            if (def_proc_locals.count(param) > 0) {
                error(stmt.loc, "Duplicate parameter: '" + param + "'");
            }
            else {
                def_proc_locals.insert(param);

                auto it = symtab.vars.find(param);
                if (it == symtab.vars.end()) {
                    symtab.vars[param] = stmt.loc;
                }
            }
        }
    }

    void visit(LocalStmt& stmt) override {
        // outside of a PROC body?
        if (cur_def_proc == nullptr) {
            error(stmt.loc, "LOCAL outside PROC");
            return;
        }

        // collect locals, detect duplicates
        for (auto& local : stmt.locals) {
            if (def_proc_locals.count(local) > 0) {
                error(stmt.loc, "Duplicate variable: '" + local + "'");
            }
            else {
                def_proc_locals.insert(local);
                cur_def_proc->locals.push_back(local);

                auto it = symtab.vars.find(local);
                if (it == symtab.vars.end()) {
                    symtab.vars[local] = stmt.loc;
                }
            }
        }
    }

    void leave(DefProcStmt&) {
        proc_nesting--;
        if (proc_nesting == 0) {
            cur_def_proc = nullptr;
            def_proc_locals.clear();
        }
    }

    void visit(DefFnStmt& stmt) override {
        // FN already defined?
        auto it = symtab.fns.find(stmt.name);
        if (it != symtab.fns.end()) {
            error(stmt.loc, "Duplicate definition: '" + stmt.name + "'");
            error(it->second->loc, "Previous definition");
            return;
        }
        symtab.fns[stmt.name] = &stmt;

        // collect parameters, detect duplicates
        std::unordered_set<std::string> params;
        for (auto& param : stmt.params) {
            if (params.count(param) > 0) {
                error(stmt.loc, "Duplicate parameter: '" + param + "'");
            }
            else {
                params.insert(param);

                auto it = symtab.vars.find(param);
                if (it == symtab.vars.end()) {
                    symtab.vars[param] = stmt.loc;
                }
            }
        }
    }

    void visit(InputStmt& stmt) override {
        // collect variables and arrays from the INPUT statement
        for (const auto& var : stmt.vars) {
            if (auto var_expr = dynamic_cast<VariableExpr*>(var.get())) {
                // may be assigned multiple times, store the first location only
                auto it = symtab.vars.find(var_expr->name);
                if (it == symtab.vars.end()) {
                    symtab.vars[var_expr->name] = var_expr->loc;
                }
            }
            else if (auto array_ref_expr = dynamic_cast<ArrayRefExpr*>(var.get())) {
                // may be assigned multiple times, store the first location only
                auto it = symtab.arrays.find(array_ref_expr->name);
                if (it == symtab.arrays.end()) {
                    symtab.arrays[array_ref_expr->name] = array_ref_expr->loc;
                }
            }
        }
    }

    void visit(PragmaNumVarStmt& stmt) override {
        auto it = symtab.vars.find(stmt.name);
        if (it == symtab.vars.end()) {
            symtab.vars[stmt.name] = stmt.loc;
        }

        // move to pragma_vars section
        prog.pragma_vars.push_back(stmt.clone());
        stmt.mark_for_removal = true;
    }

    void visit(PragmaStrVarStmt& stmt) override {
        auto it = symtab.vars.find(stmt.name);
        if (it == symtab.vars.end()) {
            symtab.vars[stmt.name] = stmt.loc;
        }

        // move to pragma_vars section
        prog.pragma_vars.push_back(stmt.clone());
        stmt.mark_for_removal = true;
    }

    void visit(PragmaNumVarArrayStmt& stmt) override {
        auto it = symtab.arrays.find(stmt.name);
        if (it == symtab.arrays.end()) {
            symtab.arrays[stmt.name] = stmt.loc;
        }

        // move to pragma_vars section
        prog.pragma_vars.push_back(stmt.clone());
        stmt.mark_for_removal = true;
    }

    void visit(PragmaStrVarArrayStmt& stmt) override {
        auto it = symtab.arrays.find(stmt.name);
        if (it == symtab.arrays.end()) {
            symtab.arrays[stmt.name] = stmt.loc;
        }

        // move to pragma_vars section
        prog.pragma_vars.push_back(stmt.clone());
        stmt.mark_for_removal = true;
    }
};

struct SymbolUsageVerifier : ASTWalker {
    using ASTWalker::visit; // so that base class visit methods are visible

    Prog& prog;
    Symtab& symtab;

    explicit SymbolUsageVerifier(Prog& p, Symtab& s) : prog(p), symtab(s) {}

    void visit(ProcCallStmt& stmt) override {
        auto it = symtab.procs.find(stmt.name);
        if (it == symtab.procs.end()) {
            error(stmt.loc, "Undefined procedure: '" + stmt.name + "'");
        }
        else {
            // check number of arguments
            auto def_proc = it->second;
            if (stmt.args.size() != def_proc->params.size()) {
                error(stmt.loc, "Procedure '" + stmt.name + "' expects " +
                      std::to_string(def_proc->params.size()) + " arguments, got " +
                      std::to_string(stmt.args.size()));
            }
        }
    }

    void visit(GotoStmt& stmt) override {
        if (auto label_ref_expr = dynamic_cast<LabelLineRefExpr*>
                                  (stmt.target_expr.get())) {
            if (symtab.labels.find(label_ref_expr->name) == symtab.labels.end()) {
                error(stmt.loc, "Undefined label: '" + label_ref_expr->name + "'");
            }
        }
        else if (auto line_num_expr = dynamic_cast<NumberExpr*>
                                      (stmt.target_expr.get())) {
            int line_num = static_cast<int>(line_num_expr->value);
            if (symtab.line_nums.find(line_num) == symtab.line_nums.end()) {
                error(stmt.loc, "Undefined line number: '" + std::to_string(line_num) + "'");
            }
        }
    }

    void visit(GosubStmt& stmt) override {
        if (auto label_ref_expr = dynamic_cast<LabelLineRefExpr*>
                                  (stmt.target_expr.get())) {
            if (symtab.labels.find(label_ref_expr->name) == symtab.labels.end()) {
                error(stmt.loc, "Undefined label: '" + label_ref_expr->name + "'");
            }
        }
        else if (auto line_num_expr = dynamic_cast<NumberExpr*>
                                      (stmt.target_expr.get())) {
            int line_num = static_cast<int>(line_num_expr->value);
            if (symtab.line_nums.find(line_num) == symtab.line_nums.end()) {
                error(stmt.loc, "Undefined line number: '" + std::to_string(line_num) + "'");
            }
        }
    }

    void visit(RunStmt& stmt) override {
        if (stmt.target_expr) {
            if (auto label_ref_expr = dynamic_cast<LabelLineRefExpr*>
                                      (stmt.target_expr.get())) {
                if (symtab.labels.find(label_ref_expr->name) == symtab.labels.end()) {
                    error(stmt.loc, "Undefined label: '" + label_ref_expr->name + "'");
                }
            }
            else if (auto line_num_expr = dynamic_cast<NumberExpr*>
                                          (stmt.target_expr.get())) {
                int line_num = static_cast<int>(line_num_expr->value);
                if (symtab.line_nums.find(line_num) == symtab.line_nums.end()) {
                    error(stmt.loc, "Undefined line number: '" + std::to_string(line_num) + "'");
                }
            }
        }
    }

    void visit(ListStmt& stmt) override {
        if (stmt.target_expr) {
            if (auto label_ref_expr = dynamic_cast<LabelLineRefExpr*>
                                      (stmt.target_expr.get())) {
                if (symtab.labels.find(label_ref_expr->name) == symtab.labels.end()) {
                    error(stmt.loc, "Undefined label: '" + label_ref_expr->name + "'");
                }
            }
            else if (auto line_num_expr = dynamic_cast<NumberExpr*>
                                          (stmt.target_expr.get())) {
                int line_num = static_cast<int>(line_num_expr->value);
                if (symtab.line_nums.find(line_num) == symtab.line_nums.end()) {
                    error(stmt.loc, "Undefined line number: '" + std::to_string(line_num) + "'");
                }
            }
        }
    }

    void visit(LabelLineRefExpr& expr) override {
        if (symtab.labels.find(expr.name) == symtab.labels.end()) {
            error(expr.loc, "Undefined label: '" + expr.name + "'");
        }
    }

    void visit(LabelAddrRefExpr& expr) override {
        if (symtab.labels.find(expr.name) == symtab.labels.end()) {
            error(expr.loc, "Undefined label: '" + expr.name + "'");
        }
    }

    void visit(VariableExpr& expr) override {
        if (symtab.vars.find(expr.name) == symtab.vars.end()) {
            error(expr.loc, "Undefined variable: '" + expr.name + "'");
        }
    }

    void visit(ArrayRefExpr& expr) override {
        if (symtab.arrays.find(expr.name) == symtab.arrays.end()) {
            error(expr.loc, "Undefined array: '" + expr.name + "'");
        }
    }

    void visit(ProcCallExpr& expr) override {
        auto it = symtab.procs.find(expr.name);
        if (it == symtab.procs.end()) {
            error(expr.loc, "Undefined procedure: '" + expr.name + "'");
        }
        else {
            // check number of arguments
            auto def_proc = it->second;
            if (expr.args.size() != def_proc->params.size()) {
                error(expr.loc, "Procedure '" + expr.name + "' expects " +
                      std::to_string(def_proc->params.size()) + " arguments, got " +
                      std::to_string(expr.args.size()));
            }
        }
    }

    void visit(FnCallExpr& expr) override {
        auto it = symtab.fns.find(expr.name);
        if (it == symtab.fns.end()) {
            error(expr.loc, "Undefined function: '" + expr.name + "'");
        }
        else {
            // check number of arguments
            auto def_fn = it->second;
            if (expr.args.size() != def_fn->params.size()) {
                error(expr.loc, "Function '" + expr.name + "' expects " +
                      std::to_string(def_fn->params.size()) + " arguments, got " +
                      std::to_string(expr.args.size()));
            }
        }
    }
};

bool create_symtab(Prog& prog, std::unique_ptr<Symtab>& symtab) {
    // create symbol table and collect definitions
    symtab = std::make_unique<Symtab>();
    SymbolDefinitionCollector collector(prog, *symtab);
    prog.accept(collector);

    // check for undefined symbols in expressions and statements
    SymbolUsageVerifier verifier(prog, *symtab);
    prog.accept(verifier);

    return get_error_count() == 0;
}
