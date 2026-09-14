//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "dump_context.h"
#include "errors.h"
#include "symtab.h"
#include <algorithm>
#include <memory>
#include <memory>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

// collect all local statements and allocate to PROC
// called on the body of the PROC
struct LocalCollector : ASTVisitor {
    std::unordered_set<std::string> params;     // input formal params
    std::vector<std::string> locals;            // collect list of locals

    LocalCollector(const std::unordered_set<std::string>& p)
        : params(p) {}

    void visit(LocalStmt& stmt) override {
        for (const auto& local : stmt.locals) {
            if (params.count(local) > 0) {
                error(stmt.loc, "Local same as parameter: '" +
                      local + "'");
            }
            else if (std::find(locals.begin(), locals.end(), local) != locals.end()) {
                error(stmt.loc, "Duplicate local: '" +
                      local + "'");
            }
            else {
                locals.push_back(local);
            }
        }
        stmt.rewrite.remove = true; // remove the LOCAL statement after collecting
    }
};

// rename params and locals to <proc><param/local>
// called on the body of the PROC
struct StmtRewriter : ASTVisitor {
    std::string prefix;
    std::unordered_set<std::string> vars;

    StmtRewriter(const std::string& p,
                 const std::unordered_set<std::string>& v)
        : prefix(p), vars(v) {}

    void visit(VariableExpr& expr) override {
        if (vars.count(expr.name) > 0) {
            expr.name = prefix + expr.name;
        }
    }
};

// collect all PROC definitions, collect the LOCAL definitions and rewrite
// the body to use <proc_name><var>
struct ProcRewriter : ASTVisitor {
    int proc_nesting = 0;

    bool enter(DefProcStmt& stmt) override {
        // already in a PROC body?
        if (proc_nesting++ > 0) {
            error(stmt.loc, "Nested DEF PROC");
            return true;
        }

        // collect parameters, detect duplicates
        std::unordered_set<std::string> params;
        for (auto& param : stmt.params) {
            if (params.count(param) > 0) {
                error(stmt.loc, "Duplicate parameter: '" + param + "'");
            }
            else {
                params.insert(param);
            }
        }

        // collect locals, detect duplicates
        LocalCollector local_collector(params);
        stmt.accept(local_collector);
        stmt.locals = local_collector.locals;

        // rewrite the PROC body to replace local variables and parameters
        // with <proc-name><param-name>
        std::unordered_set<std::string> params_locals;
        for (auto& param : stmt.params) {
            params_locals.insert(param);
            param = stmt.name + param; // rename parameter to <proc><param>
        }
        for (auto& local : stmt.locals) {
            params_locals.insert(local);
            local = stmt.name + local; // rename local to <proc><local>
        }
        StmtRewriter rewriter(stmt.name, params_locals);
        stmt.accept(rewriter);

        return true;
    }

    void leave(DefProcStmt&) override {
        proc_nesting--;
    }

    void visit(LocalStmt& stmt) override {
        // outside of a PROC body?
        if (proc_nesting == 0) {
            error(stmt.loc, "LOCAL outside PROC");
        }
        stmt.rewrite.remove = true; // remove the LOCAL statement
    }
};

// check duplicate FN parameters
struct FnParamChecker : ASTVisitor {
    void visit(DefFnStmt& stmt) {
        std::unordered_set<std::string> params;
        for (auto& param : stmt.params) {
            if (params.count(param) > 0) {
                error(stmt.loc, "Duplicate parameter: '" + param + "'");
            }
            else {
                params.insert(param);
            }
        }
    }
};

// collect all symbol definitions
// move pragma vars to program header
struct SymbolCollector : ASTVisitor {
    Prog& prog;
    Symtab& symtab;
    int last_line_num = -1;

    explicit SymbolCollector(Prog& p, Symtab& s) : prog(p), symtab(s) {}

    // may be assigned multiple times, store the first location only
    void update_vars(const std::string& name, const SourceLoc& loc) {
        auto it = symtab.vars.find(name);
        if (it == symtab.vars.end()) {
            symtab.vars[name] = loc;
        }
    }

    // may be assigned multiple times, store the first location only
    void update_arrays(const std::string& name, const SourceLoc& loc) {
        auto it = symtab.arrays.find(name);
        if (it == symtab.arrays.end()) {
            symtab.arrays[name] = loc;
        }
    }

    void visit(LabelStmt& stmt) override {
        // label already defined?
        auto it = symtab.labels.find(stmt.label);
        if (it != symtab.labels.end()) {
            error(stmt.loc, "Duplicate label: '" + stmt.label + "'");
            error(it->second->loc, "Previous definition");
            return;
        }
        symtab.labels[stmt.label] = &stmt;
    }

    void visit(LineNumStmt& stmt) override {
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
            update_vars(var_expr->name, var_expr->loc);
        }
        else if (auto array_ref_expr = dynamic_cast<ArrayRefExpr*>(stmt.lhs.get())) {
            update_arrays(array_ref_expr->name, array_ref_expr->loc);
        }
    }

    void visit(DimStmt& stmt) override {
        // collect arrays from the DIM statement
        for (auto& dim_item : stmt.items) {
            update_arrays(dim_item.name, stmt.loc);
        }
    }

    void visit(ForStmt& stmt) override {
        // loop variable is defined in the FOR statement
        update_vars(stmt.name, stmt.loc);
    }

    void visit(DefProcStmt& stmt) override {
        // PROC already defined?
        auto it = symtab.procs.find(stmt.name);
        if (it != symtab.procs.end()) {
            error(stmt.loc, "Duplicate PROC definition: '" + stmt.name + "'");
            error(it->second->loc, "Previous definition");
            return;
        }
        symtab.procs[stmt.name] = &stmt;

        // define variables for each parameter and local
        for (auto& param : stmt.params) {
            update_vars(param, stmt.loc);
        }
        for (auto& local : stmt.locals) {
            update_vars(local, stmt.loc);
        }
    }

    void visit(DefFnStmt& stmt) override {
        // FN already defined?
        auto it = symtab.fns.find(stmt.name);
        if (it != symtab.fns.end()) {
            error(stmt.loc, "Duplicate FN definition: '" + stmt.name + "'");
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
                update_vars(param, stmt.loc);
            }
        }
    }

    void visit(InputStmt& stmt) override {
        // collect variables and arrays from the INPUT statement
        for (const auto& var : stmt.vars) {
            if (auto var_expr = dynamic_cast<VariableExpr*>(var.get())) {
                update_vars(var_expr->name, var_expr->loc);
            }
            else if (auto array_ref_expr = dynamic_cast<ArrayRefExpr*>(var.get())) {
                update_arrays(array_ref_expr->name, array_ref_expr->loc);
            }
        }
    }

    void visit(PragmaNumVarStmt& stmt) override {
        update_vars(stmt.name, stmt.loc);

        // move to pragma_vars section
        prog.pragma_vars.push_back(stmt.clone());
        stmt.rewrite.remove = true;
    }

    void visit(PragmaStrVarStmt& stmt) override {
        update_vars(stmt.name, stmt.loc);

        // move to pragma_vars section
        prog.pragma_vars.push_back(stmt.clone());
        stmt.rewrite.remove = true;
    }

    void visit(PragmaNumVarArrayStmt& stmt) override {
        update_arrays(stmt.name, stmt.loc);

        // move to pragma_vars section
        prog.pragma_vars.push_back(stmt.clone());
        stmt.rewrite.remove = true;
    }

    void visit(PragmaStrVarArrayStmt& stmt) override {
        update_arrays(stmt.name, stmt.loc);

        // move to pragma_vars section
        prog.pragma_vars.push_back(stmt.clone());
        stmt.rewrite.remove = true;
    }
};

// collect undefined symbols
// check mismatched parameters
// mark called PROCs
struct UndefinedCollector : ASTVisitor {
    Symtab& symtab;

    explicit UndefinedCollector(Symtab& s) : symtab(s) {}

    void visit(ProcCallStmt& stmt) override {
        auto it = symtab.procs.find(stmt.name);
        if (it == symtab.procs.end()) {
            error(stmt.loc, "Undefined procedure: '" + stmt.name + "'");
        }
        else {
            // check number of arguments
            auto def_proc = it->second;
            def_proc->called = true;		// mark called for lower stage
            if (stmt.args.size() != def_proc->params.size()) {
                error(stmt.loc, "Procedure '" + stmt.name + "' expects " +
                      std::to_string(def_proc->params.size()) + " arguments, got " +
                      std::to_string(stmt.args.size()));
            }
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
            def_proc->called = true;		// mark called for lower stage
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

    void visit(GotoStmt& stmt) override {
        if (auto line_num_expr = dynamic_cast<NumberExpr*>
                                 (stmt.target_expr.get())) {
            int line_num = static_cast<int>(line_num_expr->value);
            if (symtab.line_nums.find(line_num) == symtab.line_nums.end()) {
                error(stmt.loc, "Undefined line number: '" + std::to_string(line_num) + "'");
            }
        }
    }

    void visit(GosubStmt& stmt) override {
        if (auto line_num_expr = dynamic_cast<NumberExpr*>
                                 (stmt.target_expr.get())) {
            int line_num = static_cast<int>(line_num_expr->value);
            if (symtab.line_nums.find(line_num) == symtab.line_nums.end()) {
                error(stmt.loc, "Undefined line number: '" + std::to_string(line_num) + "'");
            }
        }
    }

    void visit(RunStmt& stmt) override {
        if (stmt.target_expr) {
            if (auto line_num_expr = dynamic_cast<NumberExpr*>
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
            if (auto line_num_expr = dynamic_cast<NumberExpr*>
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
};

bool create_symtab(Prog& prog, std::unique_ptr<Symtab>& out_symtab) {
    out_symtab = std::make_unique<Symtab>();

    // rewrite PROC parameters and locals, detect nested PROCs
    ProcRewriter rewriter;
    prog.accept(rewriter);

    // check duplicate FN parameters
    FnParamChecker checker;
    prog.accept(checker);

    // collect all defined symbols, move pragma vars
    SymbolCollector symbol_collector(prog, *out_symtab);
    prog.accept(symbol_collector);

    // collect undefined symbols and
    // mismatch parameters to args in FN and PROC calls
    UndefinedCollector undef_collector(*out_symtab);
    prog.accept(undef_collector);

    return get_error_count() == 0;
}

#ifdef _DEBUG
static void dump_symtab_map(const char* name,
                            const std::unordered_map<std::string, SourceLoc>& map,
                            DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    std::vector<std::string> keys;
    keys.reserve(map.size());
    for (const auto& [key, loc] : map) {
        keys.push_back(key);
    }
    std::sort(keys.begin(), keys.end());
    for (const auto& key : keys) {
        child_ctx.line("\"" + key + "\" {");
        auto entry_ctx = child_ctx.child();
        map.at(key).dump(entry_ctx);
        child_ctx.line("}");
    }
    ctx.line("]");
}

static void dump_symtab_def_proc_stmt_map(const char* name,
        const std::unordered_map<std::string, DefProcStmt*>& map,
        DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    std::vector<std::string> keys;
    keys.reserve(map.size());
    for (const auto& [key, stmt] : map) {
        keys.push_back(key);
    }
    std::sort(keys.begin(), keys.end());
    for (const auto& key : keys) {
        child_ctx.line("\"" + key + "\" {");
        auto entry_ctx = child_ctx.child();
        map.at(key)->loc.dump(entry_ctx);
        child_ctx.line("}");
    }
    ctx.line("]");
}

static void dump_symtab_def_fn_stmt_map(const char* name,
                                        const std::unordered_map<std::string, DefFnStmt*>& map,
                                        DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    std::vector<std::string> keys;
    keys.reserve(map.size());
    for (const auto& [key, stmt] : map) {
        keys.push_back(key);
    }
    std::sort(keys.begin(), keys.end());
    for (const auto& key : keys) {
        child_ctx.line("\"" + key + "\" {");
        auto entry_ctx = child_ctx.child();
        map.at(key)->loc.dump(entry_ctx);
        child_ctx.line("}");
    }
    ctx.line("]");
}

static void dump_symtab_labels_map(const char* name,
                                   const std::unordered_map<std::string, LabelStmt*>& map,
                                   DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    std::vector<std::string> keys;
    keys.reserve(map.size());
    for (const auto& [key, stmt] : map) {
        keys.push_back(key);
    }
    std::sort(keys.begin(), keys.end());
    for (const auto& key : keys) {
        child_ctx.line("\"" + key + "\" {");
        auto entry_ctx = child_ctx.child();
        map.at(key)->loc.dump(entry_ctx);
        child_ctx.line("}");
    }
    ctx.line("]");
}

static void dump_symtab_line_nums_map(const char* name,
                                      const std::unordered_map<int, LineNumStmt*>& map,
                                      DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    std::vector<int> keys;
    keys.reserve(map.size());
    for (const auto& [key, stmt] : map) {
        keys.push_back(key);
    }
    std::sort(keys.begin(), keys.end());
    for (const auto& key : keys) {
        child_ctx.line(std::to_string(key) + " {");
        auto entry_ctx = child_ctx.child();
        map.at(key)->loc.dump(entry_ctx);
        child_ctx.line("}");
    }
    ctx.line("]");
}

void Symtab::dump(DumpContext ctx) const {
    ctx.line("Symtab {");
    auto child_ctx = ctx.child();
    dump_symtab_map("vars", vars, child_ctx);
    dump_symtab_map("arrays", arrays, child_ctx);
    dump_symtab_def_proc_stmt_map("procs", procs, child_ctx);
    dump_symtab_def_fn_stmt_map("fns", fns, child_ctx);
    dump_symtab_labels_map("labels", labels, child_ctx);
    dump_symtab_line_nums_map("line_nums", line_nums, child_ctx);
    ctx.line("}");
}
#endif

