//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifdef _DEBUG

#include "../ast.h"
#include "../ast_expr.h"
#include "../ast_stmt.h"
#include "../dump_context.h"
#include "../lexer.h"
#include "../utils.h"
#include <memory>
#include <string>
#include <vector>

static void dump_stmt_common(const Stmt& stmt, DumpContext& ctx) {
    stmt.loc.dump(ctx);
}

static void dump_stmt_list(const char* name,
                           const std::vector<std::unique_ptr<Stmt>>& list,
                           DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    for (const auto& s : list) {
        if (s) {
            s->dump(child_ctx);
        }
    }
    ctx.line("]");
}

static void dump_string_list(const char* name,
                             const std::vector<std::string>& list,
                             DumpContext& ctx) {
    ctx.line(std::string(name) + ": [");
    auto child_ctx = ctx.child();
    for (const auto& s : list) {
        child_ctx.line("\"" + s + "\"");
    }
    ctx.line("]");
}

static void dump_asm_lines(const std::vector<TokLine>& asm_lines,
                           DumpContext& ctx) {
    ctx.line("asm: [");
    auto child_ctx = ctx.child();
    for (const auto& line : asm_lines) {
        std::string text;
        for (const auto& token : line.tokens) {
            text += token.ws_before + token.text;
        }
        child_ctx.line(text);
    }
    ctx.line("]");
}

void JumpTargetStmt::dump(DumpContext ctx) const {
    ctx.line("JumpTargetStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    if (!label.empty()) {
        child_ctx.line("label: \"" + label + "\"");
    }
    if (basic_line_num >= 0) {
        child_ctx.line("basic_line_num: " + std::to_string(basic_line_num));
    }
    ctx.line("}");
}

void LetStmt::dump(DumpContext ctx) const {
    ctx.line("LetStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("lhs", lhs.get(), child_ctx);
    dump_child_expr("rhs", rhs.get(), child_ctx);
    ctx.line("}");
}

void IfStmt::dump(DumpContext ctx) const {
    ctx.line("IfStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("condition", condition.get(), child_ctx);
    dump_stmt_list("then_stmts", then_stmts, child_ctx);
    dump_stmt_list("else_stmts", else_stmts, child_ctx);
    ctx.line("}");
}

void RepeatStmt::dump(DumpContext ctx) const {
    ctx.line("RepeatStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_stmt_list("body", body, child_ctx);
    dump_child_expr("condition", condition.get(), child_ctx);
    ctx.line("}");
}

void WhileStmt::dump(DumpContext ctx) const {
    ctx.line("WhileStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("condition", condition.get(), child_ctx);
    dump_stmt_list("body", body, child_ctx);
    ctx.line("}");
}

void DefProcStmt::dump(DumpContext ctx) const {
    ctx.line("DefProcStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    dump_string_list("params", params, child_ctx);
    dump_string_list("locals", locals, child_ctx);
    dump_stmt_list("body", body, child_ctx);
    ctx.line("}");
}

void ProcCallStmt::dump(DumpContext ctx) const {
    ctx.line("ProcCallStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    dump_expr_list("args", args, child_ctx);
    ctx.line("}");
}

void LocalStmt::dump(DumpContext ctx) const {
    ctx.line("LocalStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_string_list("locals", locals, child_ctx);
    ctx.line("}");
}

void DefFnStmt::dump(DumpContext ctx) const {
    ctx.line("DefFnStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: \"" + name + "\"");
    dump_string_list("params", params, child_ctx);
    dump_child_expr("body", expr.get(), child_ctx);
    ctx.line("}");
}

void ExitStmt::dump(DumpContext ctx) const {
    ctx.line("ExitStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}

void GotoStmt::dump(DumpContext ctx) const {
    ctx.line("GotoStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("target_expr", target_expr.get(), child_ctx);
    ctx.line("}");
}

void GosubStmt::dump(DumpContext ctx) const {
    ctx.line("GosubStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("target_expr", target_expr.get(), child_ctx);
    ctx.line("}");
}

void ReturnStmt::dump(DumpContext ctx) const {
    ctx.line("ReturnStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}

void StopStmt::dump(DumpContext ctx) const {
    ctx.line("StopStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}

void ForStmt::dump(DumpContext ctx) const {
    ctx.line("ForStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("var_name: \"" + var_name + "\"");
    dump_child_expr("start_expr", start_expr.get(), child_ctx);
    dump_child_expr("end_expr", end_expr.get(), child_ctx);
    dump_child_expr("step_expr", step_expr.get(), child_ctx);
    dump_stmt_list("body", body, child_ctx);
    ctx.line("}");
}

void PrintStmt::dump(DumpContext ctx) const {
    ctx.line("PrintStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("items: [");
    auto items_ctx = child_ctx.child();
    for (const auto& item : items) {
        switch (item.type) {
        case PrintItem::Type::Expr:
            items_ctx.line("Expr:");
            if (item.expr) {
                auto e_ctx = items_ctx.child();
                item.expr->dump(e_ctx);
            }
            break;
        case PrintItem::Type::Comma:
            items_ctx.line("Comma");
            break;
        case PrintItem::Type::Semicolon:
            items_ctx.line("Semicolon");
            break;
        case PrintItem::Type::At:
            items_ctx.line("At:");
            {
                auto e_ctx = items_ctx.child();
                dump_child_expr("line_expr", item.line_expr.get(), e_ctx);
                dump_child_expr("col_expr", item.col_expr.get(), e_ctx);
            }
            break;
        case PrintItem::Type::Tab:
            items_ctx.line("Tab:");
            if (item.tab_expr) {
                auto e_ctx = items_ctx.child();
                item.tab_expr->dump(e_ctx);
            }
            break;
        }
    }
    child_ctx.line("]");
    ctx.line("}");
}

void InputStmt::dump(DumpContext ctx) const {
    ctx.line("InputStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_expr_list("vars", vars, child_ctx);
    ctx.line("}");
}

void DimItem::dump(DumpContext ctx) const {
    ctx.line("DimItem {");
    auto child_ctx = ctx.child();
    child_ctx.line("name: \"" + name + "\"");
    dump_expr_list("dims", dims, child_ctx);
    ctx.line("}");
}

void DimStmt::dump(DumpContext ctx) const {
    ctx.line("DimStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("items: [");
    auto items_ctx = child_ctx.child();
    for (const auto& item : items) {
        item.dump(items_ctx);
    }
    child_ctx.line("]");
    ctx.line("}");
}

void RemStmt::dump(DumpContext ctx) const {
    ctx.line("RemStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("text: \"" + text + "\"");
    dump_asm_lines(asm_lines, child_ctx);
    ctx.line("}");
}

void RunStmt::dump(DumpContext ctx) const {
    ctx.line("RunStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("target_expr", target_expr.get(), child_ctx);
    ctx.line("}");
}

void ListStmt::dump(DumpContext ctx) const {
    ctx.line("ListStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("target_expr", target_expr.get(), child_ctx);
    ctx.line("}");
}

void NewStmt::dump(DumpContext ctx) const {
    ctx.line("NewStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}

void ClsStmt::dump(DumpContext ctx) const {
    ctx.line("ClsStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}

void LoadStmt::dump(DumpContext ctx) const {
    ctx.line("LoadStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("filename_expr", filename_expr.get(), child_ctx);
    ctx.line("}");
}

void SaveStmt::dump(DumpContext ctx) const {
    ctx.line("SaveStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("filename_expr", filename_expr.get(), child_ctx);
    ctx.line("}");
}

void EndStmt::dump(DumpContext ctx) const {
    ctx.line("EndStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}

void PokeStmt::dump(DumpContext ctx) const {
    ctx.line("PokeStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("address", address.get(), child_ctx);
    dump_child_expr("value", value.get(), child_ctx);
    ctx.line("}");
}

void PokewStmt::dump(DumpContext ctx) const {
    ctx.line("PokewStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("address", address.get(), child_ctx);
    dump_child_expr("value", value.get(), child_ctx);
    ctx.line("}");
}

void PlotStmt::dump(DumpContext ctx) const {
    ctx.line("PlotStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("x_expr", x_expr.get(), child_ctx);
    dump_child_expr("y_expr", y_expr.get(), child_ctx);
    ctx.line("}");
}

void UnplotStmt::dump(DumpContext ctx) const {
    ctx.line("UnplotStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("x_expr", x_expr.get(), child_ctx);
    dump_child_expr("y_expr", y_expr.get(), child_ctx);
    ctx.line("}");
}

void RandStmt::dump(DumpContext ctx) const {
    ctx.line("RandStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("seed", seed_expr.get(), child_ctx);
    ctx.line("}");
}

void PauseStmt::dump(DumpContext ctx) const {
    ctx.line("PauseStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    dump_child_expr("duration", duration_expr.get(), child_ctx);
    ctx.line("}");
}

void FastStmt::dump(DumpContext ctx) const {
    ctx.line("FastStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}

void SlowStmt::dump(DumpContext ctx) const {
    ctx.line("SlowStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}

void ScrollStmt::dump(DumpContext ctx) const {
    ctx.line("ScrollStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}

void ContStmt::dump(DumpContext ctx) const {
    ctx.line("ContStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}

void ClearStmt::dump(DumpContext ctx) const {
    ctx.line("ClearStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    ctx.line("}");
}

void PragmaStrVarStmt::dump(DumpContext ctx) const {
    ctx.line("PragmaStrVarStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: " + var_name);
    child_ctx.line("value: \"" + value + "\"");
    dump_asm_lines(asm_lines, child_ctx);
    ctx.line("}");
}

void PragmaNumVarStmt::dump(DumpContext ctx) const {
    ctx.line("PragmaNumVarStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: " + var_name);
    child_ctx.line("value: " + std::to_string(value));
    ctx.line("}");
}

void PragmaNumVarArrayStmt::dump(DumpContext ctx) const {
    ctx.line("PragmaNumVarArrayStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: " + var_name);
    child_ctx.line("dimensions: [");
    auto grandchild_ctx = child_ctx.child();
    for (auto dim : dims) {
        grandchild_ctx.line(std::to_string(dim));
    }
    child_ctx.line("]");
    child_ctx.line("values: [");
    auto val_ctx = child_ctx.child();
    for (const auto& v : values) {
        val_ctx.line(std::to_string(v));
    }
    child_ctx.line("]");
    ctx.line("}");
}

void PragmaStrVarArrayStmt::dump(DumpContext ctx) const {
    ctx.line("PragmaStrVarArrayStmt {");
    auto child_ctx = ctx.child();
    dump_stmt_common(*this, child_ctx);
    child_ctx.line("name: " + var_name);
    child_ctx.line("dimensions: [");
    auto grandchild_ctx = child_ctx.child();
    for (auto dim : dims) {
        grandchild_ctx.line(std::to_string(dim));
    }
    child_ctx.line("]");
    dump_string_list("values", values, child_ctx);
    ctx.line("}");
}

void Prog::dump(DumpContext ctx) const {
    ctx.line("Prog {");
    auto child_ctx = ctx.child();
    child_ctx.line("auto_start: " + std::string(auto_start ? "true" : "false"));
    child_ctx.line("auto_start_line: " + std::to_string(auto_start_line));
    child_ctx.line("auto_start_label: \"" + auto_start_label + "\"");
    child_ctx.line("increment: " + std::to_string(increment));
    child_ctx.line("rem_invert: " + std::string(rem_invert ? "true" : "false"));
    child_ctx.line("fast_mode: " + std::string(fast_mode ? "true" : "false"));
    child_ctx.line("dfile_lines: [");
    auto grandchild_ctx = child_ctx.child();
    for (const auto& line : dfile_lines) {
        grandchild_ctx.line("\"" + line + "\"");
    }
    child_ctx.line("]");
    child_ctx.line("dfile_colapsed: " + std::string(dfile_colapsed ? "true" :
                   "false"));
    child_ctx.line("sysvars_data: [");
    for (const auto& byte : sysvars_data) {
        grandchild_ctx.line(int_to_hex(byte));
    }
    child_ctx.line("]");
    dump_stmt_list("stmts", stmts, child_ctx);
    ctx.line("}");
}

#endif
