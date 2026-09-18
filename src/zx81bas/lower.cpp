//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "errors.h"
#include "lexer.h"
#include "lower.h"
#include "release_assert.h"
#include "symtab.h"
#include "utils.h"
#include "zx81bas.h"
#include <algorithm>
#include <iterator>
#include <memory>
#include <utility>
#include <vector>

static std::string gen_label(const std::string& prefix) {
    static int counter = 0;
    return SYMBOL_PREFIX + std::to_string(counter++) + str_toupper(prefix);;
}

void LoweringPass::lower_prog() {
    std::vector<StmtPtr> out;

    // lower main program statements
    auto lowered_main = lower_main();
    append_stmts(out, lowered_main);

    // end of program location, used for GOTO @END_OF_PROGRAM
    SourceLoc end_of_program_loc = out.empty() ? SourceLoc{} :
                                   out.back()->loc;

    // if last statement is a REM and has assembly lines,
    // must move it to after the proc defintions
    std::vector<StmtPtr> footer;
    if (!out.empty()) {
        if (auto rem_stmt = dynamic_cast<RemStmt*>(out.back().get())) {
            if (!rem_stmt->asm_lines.empty()) {
                footer.push_back(std::move(out.back()));
                out.pop_back();
            }
        }
    }

    // lower proc definitions
    auto lowered_procs = lower_procs();
    if (!lowered_procs.empty()) {
        // STOP
        add_stop_stmt(out, end_of_program_loc);

        // DEF PROC bodies
        append_stmts(out, lowered_procs);
    }

    // add footer statements
    append_stmts(out, footer);

    prog.stmts = std::move(out);
}

std::vector<StmtPtr> LoweringPass::lower_main() {
    return lower_stmts(prog.stmts);
}

std::vector<StmtPtr> LoweringPass::lower_procs() {
    std::vector<StmtPtr> out;

    // find list of called procedures
    std::vector<DefProcStmt*> called_procs;
    for (auto& [name, def_proc] : symtab.procs) {
        if (def_proc->called) {
            called_procs.push_back(def_proc);
        }
    }

    // sort called procedures by line number
    std::sort(called_procs.begin(), called_procs.end(),
    [](const DefProcStmt * a, const DefProcStmt * b) {
        return a->loc.line_num < b->loc.line_num;
    });

    // emit the lowered procedures in order of their line numbers
    for (auto* def_proc : called_procs) {
        auto lowered_proc = lower_proc(*def_proc);
        append_stmts(out, lowered_proc);
    }

    return out;
}

std::vector<StmtPtr> LoweringPass::lower_proc(DefProcStmt& proc) {
    std::vector<StmtPtr> out;

    // enter a new block for EXIT
    control_stack.emplace_back(ControlStackEntry::Type::Proc, "");

    // add start label for the proc
    add_label_stmt(out, proc.name, proc.loc);

    // body
    auto lowered_body = lower_stmts(proc.body);
    append_stmts(out, lowered_body);

    // RETURN
    add_return_stmt(out, proc.loc);

    // remove entry from control stack
    control_stack.pop_back();

    return out;
}

std::vector<StmtPtr> LoweringPass::lower_stmts(std::vector<StmtPtr>& stmts) {
    std::vector<StmtPtr> out;
    for (auto& stmt : stmts) {
        auto lowered = stmt->lower(*this);
        append_stmts(out, lowered);
    }
    return out;
}

LoweredExpr LoweringPass::lower(NumberExpr& expr) {
    LoweredExpr out;
    out.rewritten = expr.clone();
    return out;
}

LoweredExpr LoweringPass::lower(LabelLineRefExpr& expr) {
    LoweredExpr out;
    out.rewritten = expr.clone();
    return out;
}

LoweredExpr LoweringPass::lower(LabelAddrRefExpr& expr) {
    LoweredExpr out;
    out.rewritten = expr.clone();
    return out;
}

LoweredExpr LoweringPass::lower(StringLiteralExpr& expr) {
    LoweredExpr out;
    out.rewritten = expr.clone();
    return out;
}

LoweredExpr LoweringPass::lower(VariableExpr& expr) {
    LoweredExpr out;
    out.rewritten = expr.clone();
    return out;
}

LoweredExpr LoweringPass::lower(ArrayRefExpr& expr) {
    LoweredExpr out;

    auto new_expr = make_node<ArrayRefExpr>(expr.name, expr.loc);
    for (auto& index_expr : expr.indices) {
        auto lowered_index = index_expr->lower(*this);
        append_stmts(out.preamble, lowered_index.preamble);
        new_expr->indices.push_back(std::move(lowered_index.rewritten));
    }
    out.rewritten = std::move(new_expr);

    return out;
}

LoweredExpr LoweringPass::lower(SliceExpr& expr) {
    LoweredExpr out;

    auto lowered_base = expr.base->lower(*this);
    append_stmts(out.preamble, lowered_base.preamble);
    auto new_expr = make_node<SliceExpr>(std::move(lowered_base.rewritten),
                                         expr.loc);
    if (expr.from) {
        auto lowered_from = expr.from->lower(*this);
        append_stmts(out.preamble, lowered_from.preamble);
        new_expr->from = std::move(lowered_from.rewritten);
    }
    if (expr.to) {
        auto lowered_to = expr.to->lower(*this);
        append_stmts(out.preamble, lowered_to.preamble);
        new_expr->to = std::move(lowered_to.rewritten);
    }
    out.rewritten = std::move(new_expr);

    return out;
}

LoweredExpr LoweringPass::lower(UnaryExpr& expr) {
    LoweredExpr out;

    auto lowered_operand = expr.operand->lower(*this);
    append_stmts(out.preamble, lowered_operand.preamble);
    auto new_expr = make_node<UnaryExpr>(expr.op,
                                         std::move(lowered_operand.rewritten), expr.loc);
    out.rewritten = std::move(new_expr);

    return out;
}

LoweredExpr LoweringPass::lower(BinaryExpr& expr) {
    LoweredExpr out;

    auto lowered_lhs = expr.lhs->lower(*this);
    append_stmts(out.preamble, lowered_lhs.preamble);
    auto lowered_rhs = expr.rhs->lower(*this);
    append_stmts(out.preamble, lowered_rhs.preamble);
    auto new_expr = make_node<BinaryExpr>(expr.op, std::move(lowered_lhs.rewritten),
                                          std::move(lowered_rhs.rewritten), expr.loc);
    out.rewritten = std::move(new_expr);

    return out;
}

LoweredExpr LoweringPass::lower(BasicFuncCallExpr& expr) {
    LoweredExpr out;

    auto new_expr = make_node<BasicFuncCallExpr>(expr.keyword, expr.loc);
    for (auto& arg_expr : expr.args) {
        auto lowered_arg = arg_expr->lower(*this);
        append_stmts(out.preamble, lowered_arg.preamble);
        new_expr->args.push_back(std::move(lowered_arg.rewritten));
    }
    out.rewritten = std::move(new_expr);

    return out;
}

LoweredExpr LoweringPass::lower(ProcCallExpr& expr) {
    LoweredExpr out;

    // get procedure definition from symbol table
    auto it = symtab.procs.find(expr.name);
    release_assert(it != symtab.procs.end());
    auto def_proc = it->second;
    release_assert(def_proc->params.size() == expr.args.size());

    for (size_t i = 0; i < def_proc->params.size(); i++) {
        // lower each argument
        std::string& param_name = def_proc->params[i];
        auto lowered_arg = expr.args[i]->lower(*this);
        append_stmts(out.preamble, lowered_arg.preamble);

        // create LET <PROC><PARAM> = lowered_arg
        add_let_stmt(out.preamble, param_name, std::move(lowered_arg.rewritten),
                     expr.loc);
    }

    // create GOSUB @<PROC>
    add_gosub_stmt(out.preamble, def_proc->name, expr.loc);

    // create LET TMP = PROC to get the result
    auto temp = gen_label("TEMP");
    auto result_expr = make_node<VariableExpr>(def_proc->name, expr.loc);
    add_let_stmt(out.preamble, temp, std::move(result_expr), expr.loc);

    // replace PROC Call expression by TEMP expression
    out.rewritten = make_node<VariableExpr>(temp, expr.loc);

    return out;
}

LoweredExpr LoweringPass::lower(FnCallExpr&) {
    LoweredExpr out;
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(LabelStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(LineNumStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(LetStmt& stmt) {
    std::vector<StmtPtr> out;

    auto lowered_lhs = stmt.lhs->lower(*this);
    append_stmts(out, lowered_lhs.preamble);

    auto lowered_rhs = stmt.rhs->lower(*this);
    append_stmts(out, lowered_rhs.preamble);

    auto new_stmt = std::make_unique<LetStmt>(std::move(lowered_lhs.rewritten),
                    std::move(lowered_rhs.rewritten), stmt.loc);
    out.push_back(std::move(new_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(DimStmt& stmt) {
    std::vector<StmtPtr> out;

    // generate one DIM statement per item
    for (auto& dim_item : stmt.items) {
        std::vector<ExprPtr> lowered_dims;

        for (auto& dim : dim_item.dims) {
            auto lowered_dim = dim->lower(*this);
            append_stmts(out, lowered_dim.preamble);
            lowered_dims.push_back(std::move(lowered_dim.rewritten));
        }

        DimItem new_item;
        new_item.name = dim_item.name;
        new_item.dims = std::move(lowered_dims);

        auto new_stmt = std::make_unique<DimStmt>(stmt.loc);
        new_stmt->items.push_back(std::move(new_item));

        out.push_back(std::move(new_stmt));
    }

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(IfStmt& stmt) {
    std::vector<StmtPtr> out;

    // generic IF form:
    // IF NOT cond THEN GOTO @else_label
    //     then_stmts
    //     GOTO @end_label
    // @else_label:
    //     else_stmts
    // @end_label:
    std::string label_radix = gen_label("IF");
    std::string else_label = label_radix + "ELSE";
    std::string end_label = label_radix + "END";

    // IF NOT condition THEN GOTO @else_label
    add_if_not_cond_goto_stmt(out, stmt.condition->clone(), else_label, stmt.loc);

    // then statements
    auto lowered_then_stmts = lower_stmts(stmt.then_stmts);
    append_stmts(out, lowered_then_stmts);

    // GOTO @end_label
    add_goto_stmt(out, end_label, stmt.loc);

    // @else_label:
    add_label_stmt(out, else_label, stmt.loc);

    // else statements
    auto lowered_else_stmts = lower_stmts(stmt.else_stmts);
    append_stmts(out, lowered_else_stmts);

    // @end_label:
    add_label_stmt(out, end_label, stmt.loc);

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(RepeatStmt& stmt) {
    std::vector<StmtPtr> out;

    // lower REPEAT ... UNTIL condition : into:
    // @start:
    //     body
    //     IF NOT condition THEN GOTO @start
    // @end:
    std::string label_radix = gen_label("REPEAT");
    std::string start_label = label_radix + "START";
    std::string end_label = label_radix + "END";

    // enter a new block for EXIT
    control_stack.emplace_back(ControlStackEntry::Type::Loop, end_label);

    // @start:
    add_label_stmt(out, start_label, stmt.loc);

    // body
    auto lowered_body_stmts = lower_stmts(stmt.body);
    append_stmts(out, lowered_body_stmts);

    // IF NOT condition THEN GOTO @start
    add_if_not_cond_goto_stmt(out, stmt.condition->clone(), start_label, stmt.loc);

    // @end_label:
    add_label_stmt(out, end_label, stmt.loc);

    // remove entry from control stack
    control_stack.pop_back();

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(WhileStmt& stmt) {
    std::vector<StmtPtr> out;

    // lower into:
    // @start:
    //     IF NOT condition THEN GOTO @end
    //     body
    //     GOTO @start
    // @end:
    std::string label_radix = gen_label("WHILE");
    std::string start_label = label_radix + "START";
    std::string end_label = label_radix + "END";

    // enter a new block for EXIT
    control_stack.emplace_back(ControlStackEntry::Type::Loop, end_label);

    // @start:
    add_label_stmt(out, start_label, stmt.loc);

    // IF NOT condition THEN GOTO @end
    add_if_not_cond_goto_stmt(out, stmt.condition->clone(), end_label, stmt.loc);

    // body
    auto lowered_body_stmts = lower_stmts(stmt.body);
    append_stmts(out, lowered_body_stmts);

    // GOTO @start
    add_goto_stmt(out, start_label, stmt.loc);

    // @end:
    add_label_stmt(out, end_label, stmt.loc);

    // remove entry from control stack
    control_stack.pop_back();

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(ForStmt& stmt) {
    std::vector<StmtPtr> out;

    // lower into:
    // FOR var = start TO end [STEP step]
    //     body
    // NEXT var
    // @end:
    std::string label_radix = gen_label("FOR");
    std::string end_label = label_radix + "END";

    // enter a new block for EXIT
    control_stack.emplace_back(ControlStackEntry::Type::Loop, end_label);

    // FOR var = start TO end [STEP step]
    auto lowered_start = stmt.start_expr->lower(*this);
    append_stmts(out, lowered_start.preamble);
    auto lowered_end = stmt.end_expr->lower(*this);
    append_stmts(out, lowered_end.preamble);
    auto lowered_step = stmt.step_expr->lower(*this);
    append_stmts(out, lowered_step.preamble);

    auto new_for_stmt = make_node<ForStmt>(stmt.name,
                                           std::move(lowered_start.rewritten),
                                           std::move(lowered_end.rewritten),
                                           std::move(lowered_step.rewritten),
                                           stmt.loc);
    out.push_back(std::move(new_for_stmt));

    // body
    auto lowered_body_stmts = lower_stmts(stmt.body);
    append_stmts(out, lowered_body_stmts);

    // NEXT var
    auto new_next_stmt = make_node<NextStmt>(stmt.name, stmt.loc);
    out.push_back(std::move(new_next_stmt));

    // @end:
    add_label_stmt(out, end_label, stmt.loc);

    // remove entry from control stack
    control_stack.pop_back();

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(NextStmt&) {
    std::vector<StmtPtr> out;
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(DefProcStmt&) {
    std::vector<StmtPtr> out;
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(ProcCallStmt& stmt) {
    std::vector<StmtPtr> out;

    // get procedure definition from symbol table
    auto it = symtab.procs.find(stmt.name);
    release_assert(it != symtab.procs.end());
    auto def_proc = it->second;
    release_assert(def_proc->params.size() == stmt.args.size());

    for (size_t i = 0; i < def_proc->params.size(); i++) {
        // lower each argument
        std::string& param_name = def_proc->params[i];
        auto lowered_arg = stmt.args[i]->lower(*this);
        append_stmts(out, lowered_arg.preamble);

        // create LET <PROC><PARAM> = lowered_arg
        add_let_stmt(out, param_name, std::move(lowered_arg.rewritten),
                     stmt.loc);
    }

    // create GOSUB @<PROC>
    add_gosub_stmt(out, def_proc->name, stmt.loc);

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(LocalStmt&) {
    std::vector<StmtPtr> out;
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(DefFnStmt&) {
    std::vector<StmtPtr> out;
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(ExitStmt& stmt) {
    std::vector<StmtPtr> out;

    if (control_stack.empty()) {
        error(stmt.loc, "EXIT statement not inside a loop or PROC");
        return out;
    }

    const auto& entry = control_stack.back();
    switch (entry.type) {
    case ControlStackEntry::Type::Loop:
        add_goto_stmt(out, entry.end_label, stmt.loc);
        break;
    case ControlStackEntry::Type::Proc:
        add_return_stmt(out, stmt.loc);
        break;
    default:
        release_assert(0);
    }

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(GotoStmt& stmt) {
    std::vector<StmtPtr> out;

    auto lowered_target = stmt.target_expr->lower(*this);
    append_stmts(out, lowered_target.preamble);
    auto goto_stmt = std::make_unique<GotoStmt>(std::move(lowered_target.rewritten),
                     stmt.loc);
    out.push_back(std::move(goto_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(GosubStmt& stmt) {
    std::vector<StmtPtr> out;

    auto lowered_target = stmt.target_expr->lower(*this);
    append_stmts(out, lowered_target.preamble);
    auto gosub_stmt = std::make_unique<GosubStmt>(std::move(
                          lowered_target.rewritten),
                      stmt.loc);
    out.push_back(std::move(gosub_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(ReturnStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(StopStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(EndStmt& stmt) {
    std::vector<StmtPtr> out;
    add_stop_stmt(out, stmt.loc);
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(PrintStmt& stmt) {
    std::vector<StmtPtr> out;

    auto new_stmt = std::make_unique<PrintStmt>(stmt.loc);
    for (auto& item : stmt.items) {
        switch (item.type) {
        case PrintItem::Type::Expr: {
            auto lowered_expr = item.expr->lower(*this);
            append_stmts(out, lowered_expr.preamble);
            PrintItem new_item;
            new_item.type = item.type;
            new_item.expr = std::move(lowered_expr.rewritten);
            new_stmt->items.push_back(std::move(new_item));
            break;
        }
        case PrintItem::Type::Comma:
        case PrintItem::Type::Semicolon:
            new_stmt->items.push_back(std::move(item));
            break;
        case PrintItem::Type::At: {
            auto lowered_line = item.line_expr->lower(*this);
            append_stmts(out, lowered_line.preamble);
            auto lowered_col = item.col_expr->lower(*this);
            append_stmts(out, lowered_col.preamble);
            PrintItem new_item;
            new_item.type = item.type;
            new_item.line_expr = std::move(lowered_line.rewritten);
            new_item.col_expr = std::move(lowered_col.rewritten);
            new_stmt->items.push_back(std::move(new_item));
            break;
        }
        case PrintItem::Type::Tab: {
            auto lowered_tab = item.tab_expr->lower(*this);
            append_stmts(out, lowered_tab.preamble);
            PrintItem new_item;
            new_item.type = item.type;
            new_item.tab_expr = std::move(lowered_tab.rewritten);
            new_stmt->items.push_back(std::move(new_item));
            break;
        }
        default:
            release_assert(0);
        }
    }
    out.push_back(std::move(new_stmt));
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(LPrintStmt& stmt) {
    std::vector<StmtPtr> out;

    auto new_stmt = std::make_unique<LPrintStmt>(stmt.loc);
    for (auto& item : stmt.items) {
        switch (item.type) {
        case PrintItem::Type::Expr: {
            auto lowered_expr = item.expr->lower(*this);
            append_stmts(out, lowered_expr.preamble);
            PrintItem new_item;
            new_item.type = item.type;
            new_item.expr = std::move(lowered_expr.rewritten);
            new_stmt->items.push_back(std::move(new_item));
            break;
        }
        case PrintItem::Type::Comma:
        case PrintItem::Type::Semicolon:
            new_stmt->items.push_back(std::move(item));
            break;
        case PrintItem::Type::At: {
            auto lowered_line = item.line_expr->lower(*this);
            append_stmts(out, lowered_line.preamble);
            auto lowered_col = item.col_expr->lower(*this);
            append_stmts(out, lowered_col.preamble);
            PrintItem new_item;
            new_item.type = item.type;
            new_item.line_expr = std::move(lowered_line.rewritten);
            new_item.col_expr = std::move(lowered_col.rewritten);
            new_stmt->items.push_back(std::move(new_item));
            break;
        }
        case PrintItem::Type::Tab: {
            auto lowered_tab = item.tab_expr->lower(*this);
            append_stmts(out, lowered_tab.preamble);
            PrintItem new_item;
            new_item.type = item.type;
            new_item.tab_expr = std::move(lowered_tab.rewritten);
            new_stmt->items.push_back(std::move(new_item));
            break;
        }
        default:
            release_assert(0);
        }
    }
    out.push_back(std::move(new_stmt));
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(InputStmt& stmt) {
    std::vector<StmtPtr> out;

    // each INPUT statement is lowered into one INPUT statement per variable
    for (auto& var : stmt.vars) {
        auto new_stmt = std::make_unique<InputStmt>(stmt.loc);
        auto lowered_var = var->lower(*this);
        append_stmts(out, lowered_var.preamble);
        new_stmt->vars.push_back(std::move(lowered_var.rewritten));
        out.push_back(std::move(new_stmt));
    }

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(RemStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(RunStmt& stmt) {
    std::vector<StmtPtr> out;

    auto new_stmt = std::make_unique<RunStmt>(stmt.loc);
    if (stmt.target_expr) {
        auto lowered_target = stmt.target_expr->lower(*this);
        append_stmts(out, lowered_target.preamble);
        new_stmt->target_expr = std::move(lowered_target.rewritten);
    }
    out.push_back(std::move(new_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(ListStmt& stmt) {
    std::vector<StmtPtr> out;

    auto new_stmt = std::make_unique<ListStmt>(stmt.loc);
    if (stmt.target_expr) {
        auto lowered_target = stmt.target_expr->lower(*this);
        append_stmts(out, lowered_target.preamble);
        new_stmt->target_expr = std::move(lowered_target.rewritten);
    }
    out.push_back(std::move(new_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(LListStmt& stmt) {
    std::vector<StmtPtr> out;

    auto new_stmt = std::make_unique<LListStmt>(stmt.loc);
    if (stmt.target_expr) {
        auto lowered_target = stmt.target_expr->lower(*this);
        append_stmts(out, lowered_target.preamble);
        new_stmt->target_expr = std::move(lowered_target.rewritten);
    }
    out.push_back(std::move(new_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(NewStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(ClsStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(LoadStmt& stmt) {
    std::vector<StmtPtr> out;

    auto lowered_filename = stmt.filename_expr->lower(*this);
    append_stmts(out, lowered_filename.preamble);
    auto new_stmt = std::make_unique<LoadStmt>(std::move(
                        lowered_filename.rewritten), stmt.loc);
    out.push_back(std::move(new_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(SaveStmt& stmt) {
    std::vector<StmtPtr> out;

    auto lowered_filename = stmt.filename_expr->lower(*this);
    append_stmts(out, lowered_filename.preamble);
    auto new_stmt = std::make_unique<SaveStmt>(std::move(
                        lowered_filename.rewritten), stmt.loc);
    out.push_back(std::move(new_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(PokeStmt& stmt) {
    std::vector<StmtPtr> out;

    auto lowered_address = stmt.address_expr->lower(*this);
    append_stmts(out, lowered_address.preamble);
    auto lowered_value = stmt.value_expr->lower(*this);
    append_stmts(out, lowered_value.preamble);
    auto new_stmt = std::make_unique<PokeStmt>(std::move(lowered_address.rewritten),
                    std::move(lowered_value.rewritten), stmt.loc);
    out.push_back(std::move(new_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(PokewStmt&) {
    std::vector<StmtPtr> out;
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(PlotStmt& stmt) {
    std::vector<StmtPtr> out;

    auto lowered_x = stmt.x_expr->lower(*this);
    append_stmts(out, lowered_x.preamble);
    auto lowered_y = stmt.y_expr->lower(*this);
    append_stmts(out, lowered_y.preamble);
    auto new_stmt = std::make_unique<PlotStmt>(std::move(lowered_x.rewritten),
                    std::move(lowered_y.rewritten), stmt.loc);
    out.push_back(std::move(new_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(UnplotStmt& stmt) {
    std::vector<StmtPtr> out;

    auto lowered_x = stmt.x_expr->lower(*this);
    append_stmts(out, lowered_x.preamble);
    auto lowered_y = stmt.y_expr->lower(*this);
    append_stmts(out, lowered_y.preamble);
    auto new_stmt = std::make_unique<UnplotStmt>(std::move(lowered_x.rewritten),
                    std::move(lowered_y.rewritten), stmt.loc);
    out.push_back(std::move(new_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(RandStmt& stmt) {
    std::vector<StmtPtr> out;

    auto lowered_seed = stmt.seed_expr->lower(*this);
    append_stmts(out, lowered_seed.preamble);
    auto new_stmt = std::make_unique<RandStmt>(std::move(lowered_seed.rewritten),
                    stmt.loc);
    out.push_back(std::move(new_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(PauseStmt& stmt) {
    std::vector<StmtPtr> out;

    auto lowered_duration = stmt.duration_expr->lower(*this);
    append_stmts(out, lowered_duration.preamble);
    auto new_stmt = std::make_unique<PauseStmt>(std::move(
                        lowered_duration.rewritten), stmt.loc);
    out.push_back(std::move(new_stmt));

    return out;
}

std::vector<StmtPtr> LoweringPass::lower(FastStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(SlowStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(ScrollStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(ContStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(ClearStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(CopyStmt& stmt) {
    std::vector<StmtPtr> out;
    out.push_back(stmt.clone());
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(PragmaNumVarStmt&) {
    std::vector<StmtPtr> out;
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(PragmaStrVarStmt&) {
    std::vector<StmtPtr> out;
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(PragmaNumVarArrayStmt&) {
    std::vector<StmtPtr> out;
    return out;
}

std::vector<StmtPtr> LoweringPass::lower(PragmaStrVarArrayStmt&) {
    std::vector<StmtPtr> out;
    return out;
}

void LoweringPass::append_stmts(std::vector<StmtPtr>& stmts,
                                std::vector<StmtPtr>& move_from) {
    stmts.insert(stmts.end(),
                 std::move_iterator(move_from.begin()),
                 std::move_iterator(move_from.end()));
}

void LoweringPass::add_let_stmt(std::vector<StmtPtr>& stmts,
                                const std::string& var_name, ExprPtr rhs, const SourceLoc& loc) {
    auto variable_expr = make_node<VariableExpr>(var_name, loc);
    auto let_stmt = make_node<LetStmt>(std::move(variable_expr),
                                       std::move(rhs),
                                       loc);
    stmts.push_back(std::move(let_stmt));
}

void LoweringPass::add_goto_stmt(std::vector<StmtPtr>& stmts,
                                 const std::string& label, const SourceLoc& loc) {
    auto label_expr = make_node<LabelLineRefExpr>(label, loc);
    auto goto_stmt = make_node<GotoStmt>(std::move(label_expr), loc);
    stmts.push_back(std::move(goto_stmt));
}

void LoweringPass::add_gosub_stmt(std::vector<StmtPtr>& stmts,
                                  const std::string& label, const SourceLoc& loc) {
    auto label_expr = make_node<LabelLineRefExpr>(label, loc);
    auto gosub_stmt = make_node<GosubStmt>(std::move(label_expr), loc);
    stmts.push_back(std::move(gosub_stmt));
}

void LoweringPass::add_return_stmt(std::vector<StmtPtr>& stmts,
                                   const SourceLoc& loc) {
    auto return_stmt = make_node<ReturnStmt>(loc);
    stmts.push_back(std::move(return_stmt));
}

void LoweringPass::add_label_stmt(std::vector<StmtPtr>& stmts,
                                  const std::string& label, const SourceLoc& loc) {
    auto label_stmt = make_node<LabelStmt>(label, loc);
    stmts.push_back(std::move(label_stmt));
}

void LoweringPass::add_if_not_cond_goto_stmt(std::vector<StmtPtr>& stmts,
        ExprPtr cond_expr, const std::string& target_label, const SourceLoc& loc) {
    auto lowered_condition = cond_expr->lower(*this);
    append_stmts(stmts, lowered_condition.preamble);

    auto not_cond_expr = make_node<UnaryExpr>(TokenType::NOT,
                         std::move(lowered_condition.rewritten), loc);

    auto new_if_stmt = make_node<IfStmt>(std::move(not_cond_expr), loc);
    add_goto_stmt(new_if_stmt->then_stmts, target_label, loc);
    stmts.push_back(std::move(new_if_stmt));
}

void LoweringPass::add_stop_stmt(std::vector<StmtPtr>& stmts,
                                 const SourceLoc& loc) {
    auto stop_stmt = make_node<StopStmt>(loc);
    stmts.push_back(std::move(stop_stmt));
}

bool lower_prog(Prog& prog, Symtab& symtab) {
    LoweringPass pass(prog, symtab);
    pass.lower_prog();
    return get_error_count() == 0;
}
