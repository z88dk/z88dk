//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast_expr.h"
#include "ast_stmt.h"
#include "dump_context.h"
#include "errors.h"
#include "lexer.h"
#include "lower.h"
#include "options.h"
#include "release_assert.h"
#include "symtab.h"
#include "utils.h"
#include "zx81bas.h"
#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <iterator>
#include <memory>
#include <string>
#include <utility>
#include <vector>

struct ControlStackEntry {
    enum class Type {
        Loop,
        Proc,
    };
    Type type;
    std::string end_label;  // label for the end of the control structure

    ControlStackEntry(Type type_, const std::string& end_label_)
        : type(type_), end_label(end_label_) {}
};

struct LoweredExpr {
    std::vector<std::unique_ptr<Stmt>> preamble;
    std::unique_ptr<Expr> rewritten;
};

static std::string gen_label(const std::string& prefix) {
    static int counter = 0;
    return SYMBOL_PREFIX + std::to_string(counter++) + str_toupper(prefix);;
}

static void append_stmts(std::vector<std::unique_ptr<Stmt>>& dst,
                         std::vector<std::unique_ptr<Stmt>>& src) {
    dst.insert(dst.end(),
               std::make_move_iterator(src.begin()),
               std::make_move_iterator(src.end()));
}

static LoweredExpr lower_expr(Expr& expr, Symtab& symtab) {
    if (auto num_expr = dynamic_cast<NumberExpr*>(&expr)) {
        return { {}, std::make_unique<NumberExpr>(num_expr->value, num_expr->loc) };
    }
    else if (auto label_ref = dynamic_cast<LabelLineRefExpr*>(&expr)) {
        return { {}, std::make_unique<LabelLineRefExpr>(label_ref->name, label_ref->loc) };
    }
    else if (auto label_addr_ref = dynamic_cast<LabelAddrRefExpr*>(&expr)) {
        return { {}, std::make_unique<LabelAddrRefExpr>(label_addr_ref->name, label_addr_ref->loc) };
    }
    else if (auto str_expr = dynamic_cast<StringLiteralExpr*>(&expr)) {
        return { {}, std::make_unique<StringLiteralExpr>(str_expr->value, str_expr->loc) };
    }
    else if (auto var_expr = dynamic_cast<VariableExpr*>(&expr)) {
        return { {}, std::make_unique<VariableExpr>(var_expr->name, var_expr->loc) };
    }
    else if (auto array_ref_expr = dynamic_cast<ArrayRefExpr*>(&expr)) {
        LoweredExpr lowered;
        std::vector<std::unique_ptr<Expr>> lowered_indices;
        for (auto& index_expr : array_ref_expr->indices) {
            auto lowered_index = lower_expr(*index_expr, symtab);
            append_stmts(lowered.preamble, lowered_index.preamble);
            lowered_indices.push_back(std::move(lowered_index.rewritten));
        }
        auto lowered_array_ref = std::make_unique<ArrayRefExpr>(array_ref_expr->name,
                                 array_ref_expr->loc);
        lowered_array_ref->indices = std::move(lowered_indices);
        return { std::move(lowered.preamble),
                 std::move(lowered_array_ref) };
    }
    else if (auto slice_expr = dynamic_cast<SliceExpr*>(&expr)) {
        LoweredExpr lowered;
        auto lowered_base = lower_expr(*slice_expr->base, symtab);
        append_stmts(lowered.preamble, lowered_base.preamble);
        auto lowered_slice =
            std::make_unique<SliceExpr>(std::move(lowered_base.rewritten), slice_expr->loc);
        if (slice_expr->from) {
            auto lowered_from = lower_expr(*slice_expr->from, symtab);
            append_stmts(lowered.preamble, lowered_from.preamble);
            lowered_slice->from = std::move(lowered_from.rewritten);
        }
        if (slice_expr->to) {
            auto lowered_to = lower_expr(*slice_expr->to, symtab);
            append_stmts(lowered.preamble, lowered_to.preamble);
            lowered_slice->to = std::move(lowered_to.rewritten);
        }
        lowered.rewritten = std::move(lowered_slice);
        return lowered;
    }
    else if (auto un_expr = dynamic_cast<UnaryExpr*>(&expr)) {
        LoweredExpr lowered;
        auto lowered_operand = lower_expr(*un_expr->operand, symtab);
        append_stmts(lowered.preamble, lowered_operand.preamble);
        auto  lowered_unary = std::make_unique<UnaryExpr>(un_expr->op,
                              std::move(lowered_operand.rewritten), un_expr->loc);
        lowered.rewritten = std::move(lowered_unary);
        return lowered;
    }
    else if (auto bin_expr = dynamic_cast<BinaryExpr*>(&expr)) {
        LoweredExpr lowered;
        auto lowered_lhs = lower_expr(*bin_expr->lhs, symtab);
        append_stmts(lowered.preamble, lowered_lhs.preamble);
        auto lowered_rhs = lower_expr(*bin_expr->rhs, symtab);
        append_stmts(lowered.preamble, lowered_rhs.preamble);
        auto lowered_binary = std::make_unique<BinaryExpr>(bin_expr->op,
                              std::move(lowered_lhs.rewritten),
                              std::move(lowered_rhs.rewritten),
                              bin_expr->loc);
        lowered.rewritten = std::move(lowered_binary);
        return lowered;
    }
    else if (auto fn_call_expr = dynamic_cast<BasicFuncCallExpr*>(&expr)) {
        LoweredExpr lowered;

        std::vector<std::unique_ptr<Expr>> lowered_args;
        for (auto& arg_expr : fn_call_expr->args) {
            auto lowered_arg = lower_expr(*arg_expr, symtab);
            append_stmts(lowered.preamble, lowered_arg.preamble);
            lowered_args.push_back(std::move(lowered_arg.rewritten));
        }

        // replace PEEKW x -> PEEK x+256*PEEK(x+1)
        if (fn_call_expr->keyword == Keyword::PEEKW) {
            release_assert(fn_call_expr->args.size() == 1);
            auto addr_expr = std::move(lowered_args.front());
            auto addr2 = addr_expr->clone();

            // PEEK x
            auto peek_lo = std::make_unique<BasicFuncCallExpr>
                           (Keyword::PEEK, fn_call_expr->loc);
            peek_lo->args.push_back(std::move(addr_expr));

            // (x+1)
            auto _1 = std::make_unique<NumberExpr>(1, fn_call_expr->loc);
            auto addr_plus_1 = std::make_unique<BinaryExpr>
                               (TokenType::Plus,
                                std::move(addr2),
                                std::move(_1),
                                fn_call_expr->loc);

            // PEEK(x+1)
            auto peek_hi = std::make_unique<BasicFuncCallExpr>
                           (Keyword::PEEK, fn_call_expr->loc);
            peek_hi->args.push_back(std::move(addr_plus_1));

            // 256*PEEK(x+1)
            auto _256 = std::make_unique<NumberExpr>(256, fn_call_expr->loc);
            auto _256_times_peek_hi = std::make_unique<BinaryExpr>
                                      (TokenType::Multiply,
                                       std::move(_256),
                                       std::move(peek_hi),
                                       fn_call_expr->loc);

            // PEEK x+256*PEEK(x+1)
            auto result = std::make_unique<BinaryExpr>
                          (TokenType::Plus,
                           std::move(peek_lo),
                           std::move(_256_times_peek_hi),
                           fn_call_expr->loc);

            lowered.rewritten = std::move(result);
            return lowered;
        }
        else {
            auto lowered_fn_call = std::make_unique<BasicFuncCallExpr>
                                   (fn_call_expr->keyword, fn_call_expr->loc);
            lowered_fn_call->args = std::move(lowered_args);
            lowered.rewritten = std::move(lowered_fn_call);
            return lowered;
        }
    }
    else if (auto proc_call_expr = dynamic_cast<ProcCallExpr*>(&expr)) {
        LoweredExpr lowered;

        // get procedure definition from symbol table
        auto it = symtab.procs.find(proc_call_expr->name);
        release_assert(it != symtab.procs.end());
        auto def_proc = it->second;
        release_assert(def_proc->params.size() == proc_call_expr->args.size());
        def_proc->called = true;

        // lower each argument
        for (size_t i = 0; i < def_proc->params.size(); i++) {
            std::string param_name = def_proc->params[i];
            auto lowered_arg = lower_expr(*proc_call_expr->args[i], symtab);
            append_stmts(lowered.preamble, lowered_arg.preamble);

            // create LET <PROC><PARAM>=lowered_arg
            std::string arg_name = proc_call_expr->name + param_name;
            auto assign_arg_stmt = std::make_unique<LetStmt>(
                                       std::make_unique<VariableExpr>(arg_name, proc_call_expr->loc),
                                       std::move(lowered_arg.rewritten), proc_call_expr->loc);
            lowered.preamble.push_back(std::move(assign_arg_stmt));
        }

        // create GOSUB @<PROC>
        auto label_ref = std::make_unique<LabelLineRefExpr>(proc_call_expr->name,
                         proc_call_expr->loc);
        auto gosub_stmt = std::make_unique<GosubStmt>(std::move(label_ref),
                          proc_call_expr->loc);
        lowered.preamble.push_back(std::move(gosub_stmt));

        // rewritten expression is proc name
        auto var_ref = std::make_unique<VariableExpr>(proc_call_expr->name,
                       proc_call_expr->loc);
        lowered.rewritten = std::move(var_ref);
        return lowered;
    }
    else if (auto fn_call_expr = dynamic_cast<FnCallExpr*>(&expr)) {
        LoweredExpr lowered;

        // get function definition from symbol table
        auto it = symtab.fns.find(fn_call_expr->name);
        release_assert(it != symtab.fns.end());
        auto def_fn = it->second;
        release_assert(def_fn->params.size() == fn_call_expr->args.size());

        // lower each argument
        for (size_t i = 0; i < def_fn->params.size(); i++) {
            std::string param_name = def_fn->params[i];
            auto lowered_arg = lower_expr(*fn_call_expr->args[i], symtab);
            append_stmts(lowered.preamble, lowered_arg.preamble);

            // create LET <FN><PARAM>=lowered_arg
            std::string arg_name = fn_call_expr->name + param_name;
            auto assign_arg_stmt = std::make_unique<LetStmt>(
                                       std::make_unique<VariableExpr>(arg_name, fn_call_expr->loc),
                                       std::move(lowered_arg.rewritten), fn_call_expr->loc);
            lowered.preamble.push_back(std::move(assign_arg_stmt));
        }

        // lower the function expression
        auto lowered_fn_expr = lower_expr(*def_fn->expr, symtab);
        append_stmts(lowered.preamble, lowered_fn_expr.preamble);
        lowered.rewritten = std::move(lowered_fn_expr.rewritten);
        return lowered;
    }
    else {
        error(expr.loc, "Unknown expression type");
        return { {}, std::make_unique<NumberExpr>(0, expr.loc) };
    }
}

static void lower(const std::vector<std::unique_ptr<Stmt>>& stmts,
                  Symtab& symtab,
                  std::vector<ControlStackEntry>& control_stack,
                  Prog& out_prog) {
    for (auto& stmt : stmts) {
        if (auto label_stmt = dynamic_cast<LabelStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<LabelStmt>(label_stmt->label, label_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto line_num_stmt = dynamic_cast<LineNumStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<LineNumStmt>(line_num_stmt->line_num,
                            line_num_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto let_stmt = dynamic_cast<LetStmt*>(stmt.get())) {
            auto lowered_lhs = lower_expr(*let_stmt->lhs, symtab);
            append_stmts(out_prog.stmts, lowered_lhs.preamble);
            auto lowered_rhs = lower_expr(*let_stmt->rhs, symtab);
            append_stmts(out_prog.stmts, lowered_rhs.preamble);
            auto new_stmt = std::make_unique<LetStmt>(std::move(lowered_lhs.rewritten),
                            std::move(lowered_rhs.rewritten), let_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto dim_stmt = dynamic_cast<DimStmt*>(stmt.get())) {
            // lowered has only one item per DIM
            for (auto& dim_item : dim_stmt->items) {
                std::vector<std::unique_ptr<Expr>> lowered_dims;
                for (auto& dim : dim_item.dims) {
                    auto lowered_dim = lower_expr(*dim, symtab);
                    append_stmts(out_prog.stmts, lowered_dim.preamble);
                    lowered_dims.push_back(std::move(lowered_dim.rewritten));
                }
                DimItem new_item;
                new_item.name = dim_item.name;
                new_item.dims = std::move(lowered_dims);
                auto new_stmt = std::make_unique<DimStmt>(dim_stmt->loc);
                new_stmt->items.push_back(std::move(new_item));
                out_prog.stmts.push_back(std::move(new_stmt));
            }
        }
        else if (auto if_stmt = dynamic_cast<IfStmt*>(stmt.get())) {
            // first lower then and else branches
            Prog lowered_then;
            lower(if_stmt->then_stmts, symtab, control_stack, lowered_then);
            Prog lowered_else;
            lower(if_stmt->then_stmts, symtab, control_stack, lowered_else);

            // if both branches are empty, skip this instruction
            if (lowered_then.stmts.empty() && lowered_else.stmts.empty()) {
                continue;
            }

            // if THEN is empty, negate the condition and swap
            bool swap = false;
            if (lowered_then.stmts.empty() && !lowered_else.stmts.empty()) {
                swap = true;
                lowered_then.stmts = std::move(lowered_else.stmts);
                lowered_else.stmts.clear();
            }

            // if THEN is only one stament and ELSE is empty, do the simple form
            // IF cond THEN stmt
            if (lowered_then.stmts.size() == 1 && lowered_else.stmts.empty()) {
                auto lowered_condition = lower_expr(*if_stmt->condition, symtab);
                append_stmts(out_prog.stmts, lowered_condition.preamble);
                if (swap) {
                    std::unique_ptr<Expr> operand =
                        std::move(lowered_condition.rewritten);
                    SourceLoc loc = operand->loc;
                    lowered_condition.rewritten =
                        std::make_unique<UnaryExpr>(TokenType::NOT,
                                                    std::move(operand), loc);
                }

                auto new_stmt = std::make_unique<IfStmt>(std::move(lowered_condition.rewritten),
                                if_stmt->loc);
                append_stmts(new_stmt->then_stmts, lowered_then.stmts);
                continue;
            }

            // if ELSE is empty, do the simple form
            // IF NOT cond THEN GOTO @end_label
            //     true_stmts
            // @end_label:
            if (lowered_else.stmts.empty()) {
                std::string end_label = gen_label("end");
                auto lowered_condition = lower_expr(*if_stmt->condition, symtab);
                append_stmts(out_prog.stmts, lowered_condition.preamble);

                // Add NOT unless swapped
                if (!swap) {
                    std::unique_ptr<Expr> operand =
                        std::move(lowered_condition.rewritten);
                    SourceLoc loc = operand->loc;
                    lowered_condition.rewritten =
                        std::make_unique<UnaryExpr>(TokenType::NOT,
                                                    std::move(operand), loc);
                }

                // IF NOT cond THEN GOTO @end_label
                auto new_if_stmt = std::make_unique<IfStmt>(std::move(
                                       lowered_condition.rewritten), if_stmt->loc);
                auto goto_stmt = std::make_unique<GotoStmt>(std::make_unique<LabelLineRefExpr>
                                 (end_label, if_stmt->loc), if_stmt->loc);
                new_if_stmt->then_stmts.push_back(std::move(goto_stmt));
                out_prog.stmts.push_back(std::move(new_if_stmt));

                //     true_stmts
                append_stmts(out_prog.stmts, lowered_then.stmts);

                // @end_label:
                auto target_stmt = std::make_unique<LabelStmt>(end_label, if_stmt->loc);
                out_prog.stmts.push_back(std::move(target_stmt));

                continue;
            }

            // generic IF form:
            // IF NOT cond THEN GOTO @else_label
            //     true_stmts
            //     GOTO @end_label
            // @else_label:
            //     else_stms
            // @end_label:
            std::string else_label = gen_label("else");
            std::string end_label = gen_label("end");
            auto lowered_condition = lower_expr(*if_stmt->condition, symtab);
            append_stmts(out_prog.stmts, lowered_condition.preamble);

            // Add NOT unless swapped
            if (!swap) {
                std::unique_ptr<Expr> operand =
                    std::move(lowered_condition.rewritten);
                SourceLoc loc = operand->loc;
                lowered_condition.rewritten =
                    std::make_unique<UnaryExpr>(TokenType::NOT,
                                                std::move(operand), loc);
            }

            // IF NOT cond THEN GOTO @else_label
            auto new_if_stmt = std::make_unique<IfStmt>(std::move(
                                   lowered_condition.rewritten), if_stmt->loc);
            auto goto_stmt = std::make_unique<GotoStmt>(std::make_unique<LabelLineRefExpr>
                             (else_label, if_stmt->loc), if_stmt->loc);
            new_if_stmt->then_stmts.push_back(std::move(goto_stmt));
            out_prog.stmts.push_back(std::move(new_if_stmt));

            //     true_stmts
            append_stmts(out_prog.stmts, lowered_then.stmts);

            //     GOTO @end_label
            goto_stmt = std::make_unique<GotoStmt>(std::make_unique<LabelLineRefExpr>
                                                   (end_label, if_stmt->loc), if_stmt->loc);
            out_prog.stmts.push_back(std::move(goto_stmt));

            // @else_label:
            auto target_stmt = std::make_unique<LabelStmt>(else_label, if_stmt->loc);
            out_prog.stmts.push_back(std::move(target_stmt));

            //     else_stms
            append_stmts(out_prog.stmts, lowered_else.stmts);

            // @end_label:
            target_stmt = std::make_unique<LabelStmt>(end_label, if_stmt->loc);
            out_prog.stmts.push_back(std::move(target_stmt));
        }
        else if (auto repeat_stmt = dynamic_cast<RepeatStmt*>(stmt.get())) {
            // enter a new loop for EXIT
            std::string start_label = gen_label("start");
            std::string end_label = gen_label("end");
            control_stack.push_back({ ControlStackEntry::Type::Loop, end_label });

            // lower into:
            // @start:
            //     body
            //     IF NOT condition THEN GOTO @start
            // @end:

            // @start:
            auto target_stmt = std::make_unique<LabelStmt>(start_label, repeat_stmt->loc);
            out_prog.stmts.push_back(std::move(target_stmt));

            // body
            lower(repeat_stmt->body, symtab, control_stack, out_prog);

            //     IF NOT condition THEN GOTO @start
            ;
            auto lowered_condition = lower_expr(*repeat_stmt->condition, symtab);
            append_stmts(out_prog.stmts, lowered_condition.preamble);
            std::unique_ptr<Expr> operand = std::move(lowered_condition.rewritten);
            SourceLoc loc = operand->loc;
            lowered_condition.rewritten = std::make_unique<UnaryExpr>(TokenType::NOT,
                                          std::move(operand), loc);

            auto new_if_stmt = std::make_unique<IfStmt>(std::move(
                                   lowered_condition.rewritten), repeat_stmt->loc);
            auto goto_stmt = std::make_unique<GotoStmt>(std::make_unique<LabelLineRefExpr>
                             (start_label, repeat_stmt->loc), repeat_stmt->loc);
            new_if_stmt->then_stmts.push_back(std::move(goto_stmt));
            out_prog.stmts.push_back(std::move(new_if_stmt));

            // @end:
            target_stmt = std::make_unique<LabelStmt>(end_label, repeat_stmt->loc);
            out_prog.stmts.push_back(std::move(target_stmt));

            // drop the loop for EXIT
            control_stack.pop_back();
        }
        else if (auto while_stmt = dynamic_cast<WhileStmt*>(stmt.get())) {
            // enter a new loop for EXIT
            std::string start_label = gen_label("start");
            std::string end_label = gen_label("end");
            control_stack.push_back({ ControlStackEntry::Type::Loop, end_label });

            // lower into:
            // @start:
            //     IF NOT condition THEN GOTO @end
            //     body
            //     GOTO @start
            // @end:

            // @start:
            auto target_stmt = std::make_unique<LabelStmt>(start_label, while_stmt->loc);
            out_prog.stmts.push_back(std::move(target_stmt));

            //     IF NOT condition THEN GOTO @end
            ;
            auto lowered_condition = lower_expr(*while_stmt->condition, symtab);
            append_stmts(out_prog.stmts, lowered_condition.preamble);
            std::unique_ptr<Expr> operand = std::move(lowered_condition.rewritten);
            SourceLoc loc = operand->loc;
            lowered_condition.rewritten = std::make_unique<UnaryExpr>(TokenType::NOT,
                                          std::move(operand), loc);

            auto new_if_stmt = std::make_unique<IfStmt>(std::move(
                                   lowered_condition.rewritten), while_stmt->loc);
            auto goto_stmt = std::make_unique<GotoStmt>(std::make_unique<LabelLineRefExpr>
                             (end_label, while_stmt->loc), while_stmt->loc);
            new_if_stmt->then_stmts.push_back(std::move(goto_stmt));
            out_prog.stmts.push_back(std::move(new_if_stmt));

            // body
            lower(while_stmt->body, symtab, control_stack, out_prog);

            //     GOTO @start
            goto_stmt = std::make_unique<GotoStmt>(std::make_unique<LabelLineRefExpr>
                                                   (start_label, while_stmt->loc), while_stmt->loc);
            out_prog.stmts.push_back(std::move(goto_stmt));

            // @end:
            target_stmt = std::make_unique<LabelStmt>(end_label, while_stmt->loc);
            out_prog.stmts.push_back(std::move(target_stmt));

            // drop the loop for EXIT
            control_stack.pop_back();
        }
        else if (auto for_stmt = dynamic_cast<ForStmt*>(stmt.get())) {
            // enter a new loop for EXIT
            std::string end_label = gen_label("end");
            control_stack.push_back({ ControlStackEntry::Type::Loop, end_label });

            // lower into:
            // FOR var=start TO end STEP step
            //     body
            // NEXT var
            // @end:

            // FOR var=start TO end STEP step
            auto lowered_start = lower_expr(*for_stmt->start_expr, symtab);
            append_stmts(out_prog.stmts, lowered_start.preamble);
            auto lowered_end = lower_expr(*for_stmt->end_expr, symtab);
            append_stmts(out_prog.stmts, lowered_end.preamble);
            auto lowered_step = lower_expr(*for_stmt->step_expr, symtab);
            append_stmts(out_prog.stmts, lowered_step.preamble);

            auto new_for_stmt = std::make_unique<ForStmt>(for_stmt->name,
                                std::move(lowered_start.rewritten),
                                std::move(lowered_end.rewritten),
                                std::move(lowered_step.rewritten),
                                for_stmt->loc);
            out_prog.stmts.push_back(std::move(new_for_stmt));

            // body
            lower(for_stmt->body, symtab, control_stack, out_prog);

            // NEXT var
            auto next_stmt = std::make_unique<NextStmt>(for_stmt->name, for_stmt->loc);
            out_prog.stmts.push_back(std::move(next_stmt));

            // @end:
            auto target_stmt = std::make_unique<LabelStmt>(end_label, for_stmt->loc);
            out_prog.stmts.push_back(std::move(target_stmt));

            // drop the loop for EXIT
            control_stack.pop_back();
        }
        else if (auto proc_call_stmt = dynamic_cast<ProcCallStmt*>(stmt.get())) {
            // get procedure definition from symbol table
            auto it = symtab.procs.find(proc_call_stmt->name);
            release_assert(it != symtab.procs.end());
            auto def_proc = it->second;
            release_assert(def_proc->params.size() == proc_call_stmt->args.size());
            def_proc->called = true;

            // lower each argument
            for (size_t i = 0; i < def_proc->params.size(); i++) {
                std::string param_name = def_proc->params[i];
                auto lowered_arg = lower_expr(*proc_call_stmt->args[i], symtab);
                append_stmts(out_prog.stmts, lowered_arg.preamble);

                // create LET <PROC><PARAM>=lowered_arg
                std::string arg_name = proc_call_stmt->name + param_name;
                auto assign_arg_stmt = std::make_unique<LetStmt>(
                                           std::make_unique<VariableExpr>(arg_name, proc_call_stmt->loc),
                                           std::move(lowered_arg.rewritten), proc_call_stmt->loc);
                out_prog.stmts.push_back(std::move(assign_arg_stmt));
            }

            // create GOSUB @<PROC>
            auto label_ref = std::make_unique<LabelLineRefExpr>(proc_call_stmt->name,
                             proc_call_stmt->loc);
            auto gosub_stmt = std::make_unique<GosubStmt>(std::move(label_ref),
                              proc_call_stmt->loc);
            out_prog.stmts.push_back(std::move(gosub_stmt));
        }
        else if (auto exit_stmt = dynamic_cast<ExitStmt*>(stmt.get())) {
            if (control_stack.empty()) {
                error(exit_stmt->loc, "EXIT outside of loop of DEF PROC not allowed");
            }
            else if (control_stack.back().type == ControlStackEntry::Type::Loop) {
                // GOTO @end_label
                auto label_ref = std::make_unique<LabelLineRefExpr>
                                 (control_stack.back().end_label,
                                  exit_stmt->loc);
                auto goto_stmt = std::make_unique<GotoStmt>(std::move(label_ref),
                                 exit_stmt->loc);
                out_prog.stmts.push_back(std::move(goto_stmt));
            }
            else if (control_stack.back().type == ControlStackEntry::Type::Proc) {
                // RETURN
                auto return_stmt = std::make_unique<ReturnStmt>(exit_stmt->loc);
                out_prog.stmts.push_back(std::move(return_stmt));
            }
            else {
                release_assert(0);
            }
        }
        else if (auto goto_stmt = dynamic_cast<GotoStmt*>(stmt.get())) {
            auto lowered_target = lower_expr(*goto_stmt->target_expr, symtab);
            append_stmts(out_prog.stmts, lowered_target.preamble);
            auto new_stmt = std::make_unique<GotoStmt>(std::move(lowered_target.rewritten),
                            goto_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto gosub_stmt = dynamic_cast<GosubStmt*>(stmt.get())) {
            auto lowered_target = lower_expr(*gosub_stmt->target_expr, symtab);
            append_stmts(out_prog.stmts, lowered_target.preamble);
            auto new_stmt = std::make_unique<GosubStmt>(std::move(lowered_target.rewritten),
                            gosub_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto return_stmt = dynamic_cast<ReturnStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<ReturnStmt>(return_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto stop_stmt = dynamic_cast<StopStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<StopStmt>(stop_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto end_stmt = dynamic_cast<EndStmt*>(stmt.get())) {
            // GOTO @END_OF_PROGRAM
            auto goto_stmt = std::make_unique<GotoStmt>(std::make_unique<LabelLineRefExpr>
                             (END_OF_PROGRAM, end_stmt->loc), end_stmt->loc);
            out_prog.stmts.push_back(std::move(goto_stmt));
        }
        else if (auto print_stmt = dynamic_cast<PrintStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<PrintStmt>(print_stmt->loc);
            for (auto& item : print_stmt->items) {
                switch (item.type) {
                case PrintItem::Type::Expr: {
                    auto lowered_expr = lower_expr(*item.expr, symtab);
                    append_stmts(out_prog.stmts, lowered_expr.preamble);
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
                    auto lowered_line = lower_expr(*item.line_expr, symtab);
                    append_stmts(out_prog.stmts, lowered_line.preamble);
                    auto lowered_col = lower_expr(*item.col_expr, symtab);
                    append_stmts(out_prog.stmts, lowered_line.preamble);
                    PrintItem new_item;
                    new_item.type = item.type;
                    new_item.line_expr = std::move(lowered_line.rewritten);
                    new_item.col_expr = std::move(lowered_col.rewritten);
                    new_stmt->items.push_back(std::move(new_item));
                    break;
                }
                case PrintItem::Type::Tab: {
                    auto lowered_tab = lower_expr(*item.tab_expr, symtab);
                    append_stmts(out_prog.stmts, lowered_tab.preamble);
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
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto input_stmt = dynamic_cast<InputStmt*>(stmt.get())) {
            // lowered has only one item per INPUT
            for (auto& var : input_stmt->vars) {
                auto new_stmt = std::make_unique<InputStmt>(input_stmt->loc);
                new_stmt->vars.push_back(std::move(var));
                out_prog.stmts.push_back(std::move(new_stmt));
            }
        }
        else if (auto rem_stmt = dynamic_cast<RemStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<RemStmt>(rem_stmt->text, rem_stmt->loc);
            new_stmt->asm_lines = rem_stmt->asm_lines;
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto run_stmt = dynamic_cast<RunStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<RunStmt>(run_stmt->loc);
            if (run_stmt->target_expr) {
                auto lowered_target = lower_expr(*run_stmt->target_expr, symtab);
                append_stmts(out_prog.stmts, lowered_target.preamble);
                new_stmt->target_expr = std::move(lowered_target.rewritten);
            }
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto list_stmt = dynamic_cast<ListStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<ListStmt>(list_stmt->loc);
            if (list_stmt->target_expr) {
                auto lowered_target = lower_expr(*list_stmt->target_expr, symtab);
                append_stmts(out_prog.stmts, lowered_target.preamble);
                new_stmt->target_expr = std::move(lowered_target.rewritten);
            }
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto new_stmt = dynamic_cast<NewStmt*>(stmt.get())) {
            auto new_new_stmt = std::make_unique<NewStmt>(new_stmt->loc);
            out_prog.stmts.push_back(std::move(new_new_stmt));
        }
        else if (auto cls_stmt = dynamic_cast<ClsStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<ClsStmt>(cls_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto load_stmt = dynamic_cast<LoadStmt*>(stmt.get())) {
            auto lowered_filename = lower_expr(*load_stmt->filename_expr, symtab);
            append_stmts(out_prog.stmts, lowered_filename.preamble);
            auto new_stmt = std::make_unique<LoadStmt>(std::move(
                                lowered_filename.rewritten), load_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto save_stmt = dynamic_cast<SaveStmt*>(stmt.get())) {
            auto lowered_filename = lower_expr(*save_stmt->filename_expr, symtab);
            append_stmts(out_prog.stmts, lowered_filename.preamble);
            auto new_stmt = std::make_unique<SaveStmt>(std::move(
                                lowered_filename.rewritten), save_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto poke_stmt = dynamic_cast<PokeStmt*>(stmt.get())) {
            auto lowered_address = lower_expr(*poke_stmt->address_expr, symtab);
            append_stmts(out_prog.stmts, lowered_address.preamble);

            auto lowered_value = lower_expr(*poke_stmt->value_expr, symtab);
            append_stmts(out_prog.stmts, lowered_value.preamble);

            auto new_stmt = std::make_unique<PokeStmt>(std::move(lowered_address.rewritten),
                            std::move(lowered_value.rewritten), poke_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto pokew_stmt = dynamic_cast<PokewStmt*>(stmt.get())) {
            // POKE address, value-256*int(value/256) : POKE address+1, int(value/256)
            auto lowered_address = lower_expr(*pokew_stmt->address_expr, symtab);
            append_stmts(out_prog.stmts, lowered_address.preamble);

            auto lowered_value = lower_expr(*pokew_stmt->value_expr, symtab);
            append_stmts(out_prog.stmts, lowered_value.preamble);

            // value/256
            auto val1 = lowered_value.rewritten->clone();
            auto _256 = std::make_unique<NumberExpr>(256, pokew_stmt->loc);
            auto val_div_256 = std::make_unique<BinaryExpr>(TokenType::Divide,
                               std::move(val1),
                               std::move(_256),
                               pokew_stmt->loc);

            // INT(value/256)
            auto int_val_div_256 = std::make_unique<BasicFuncCallExpr>(Keyword::INT,
                                   pokew_stmt->loc);
            int_val_div_256->args.push_back(val_div_256->clone());  // will be reused below

            // 256*INT(value/256)
            auto _256_2 = std::make_unique<NumberExpr>(256, pokew_stmt->loc);
            auto val_mul_256 = std::make_unique<BinaryExpr>(TokenType::Multiply,
                               std::move(_256_2),
                               std::move(int_val_div_256),
                               pokew_stmt->loc);

            // value-256*INT(value/256)
            auto val2 = lowered_value.rewritten->clone();
            auto val_mod_256 = std::make_unique<BinaryExpr>(TokenType::Minus,
                               std::move(val2),
                               std::move(val_mul_256),
                               pokew_stmt->loc);

            // POKE address, value-256*INT(value/256)
            auto new_stmt1 = std::make_unique<PokeStmt>(lowered_address.rewritten->clone(),
                             std::move(val_mod_256), pokew_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt1));

            // address+1
            auto _1 = std::make_unique<NumberExpr>(1, pokew_stmt->loc);
            auto addr_plus_1 = std::make_unique<BinaryExpr>(TokenType::Plus,
                               lowered_address.rewritten->clone(),
                               std::move(_1),
                               pokew_stmt->loc);

            // POKE address+1, INT(value/256)
            auto new_stmt2 = std::make_unique<PokeStmt>(std::move(addr_plus_1),
                             std::move(int_val_div_256), pokew_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt2));
        }
        else if (auto plot_stmt = dynamic_cast<PlotStmt*>(stmt.get())) {
            auto lowered_x = lower_expr(*plot_stmt->x_expr, symtab);
            append_stmts(out_prog.stmts, lowered_x.preamble);

            auto lowered_y = lower_expr(*plot_stmt->y_expr, symtab);
            append_stmts(out_prog.stmts, lowered_y.preamble);

            auto new_stmt = std::make_unique<PlotStmt>(std::move(lowered_x.rewritten),
                            std::move(lowered_y.rewritten), plot_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto unplot_stmt = dynamic_cast<UnplotStmt*>(stmt.get())) {
            auto lowered_x = lower_expr(*unplot_stmt->x_expr, symtab);
            append_stmts(out_prog.stmts, lowered_x.preamble);

            auto lowered_y = lower_expr(*unplot_stmt->y_expr, symtab);
            append_stmts(out_prog.stmts, lowered_y.preamble);

            auto new_stmt = std::make_unique<UnplotStmt>(std::move(lowered_x.rewritten),
                            std::move(lowered_y.rewritten), unplot_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto rand_stmt = dynamic_cast<RandStmt*>(stmt.get())) {
            auto lowered_seed = lower_expr(*rand_stmt->seed_expr, symtab);
            append_stmts(out_prog.stmts, lowered_seed.preamble);

            auto new_stmt = std::make_unique<RandStmt>(std::move(lowered_seed.rewritten),
                            rand_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto pause_stmt = dynamic_cast<PauseStmt*>(stmt.get())) {
            auto lowered_duration = lower_expr(*pause_stmt->duration_expr, symtab);
            append_stmts(out_prog.stmts, lowered_duration.preamble);

            auto new_stmt = std::make_unique<PauseStmt>
                            (std::move(lowered_duration.rewritten), pause_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto fast_stmt = dynamic_cast<FastStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<FastStmt>(fast_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto slow_stmt = dynamic_cast<SlowStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<SlowStmt>(slow_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto scroll_stmt = dynamic_cast<ScrollStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<ScrollStmt>(scroll_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto cont_stmt = dynamic_cast<ContStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<ContStmt>(cont_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else if (auto clear_stmt = dynamic_cast<ClearStmt*>(stmt.get())) {
            auto new_stmt = std::make_unique<ClearStmt>(clear_stmt->loc);
            out_prog.stmts.push_back(std::move(new_stmt));
        }
        else {
            // other statements are not lowered
        }
    }
}

static void lower(Prog& prog, Symtab& symtab, std::unique_ptr<Prog>& out_prog) {
    out_prog = std::make_unique<Prog>();

    out_prog->auto_start = prog.auto_start;
    out_prog->auto_start_line = prog.auto_start_line;
    out_prog->auto_start_label = prog.auto_start_label;
    out_prog->increment = prog.increment;
    out_prog->rem_invert = prog.rem_invert;
    out_prog->fast_mode = prog.fast_mode;
    out_prog->dfile_lines = prog.dfile_lines;
    out_prog->dfile_colapsed = prog.dfile_colapsed;
    out_prog->sysvars_data = prog.sysvars_data;
    out_prog->stmts.reserve(prog.stmts.size());

    // program
    std::vector<ControlStackEntry> control_stack;
    lower(prog.stmts, symtab, control_stack, *out_prog);

    // check if PROCS are called
    int num_procs_called = 0;
    for (auto& [name, def_proc] : symtab.procs) {
        if (def_proc->called) {
            num_procs_called++;
        }
    }

    // location of end of program, used for GOTO @END_OF_PROGRAM
    SourceLoc end_of_program_loc = prog.stmts.empty() ? SourceLoc{} :
                                   prog.stmts.back()->loc;

    if (num_procs_called > 0) {
        // if any PROCs are called, add a GOTO @END_OF_PROGRAM at the end of the program
        auto goto_stmt = std::make_unique<GotoStmt>(std::make_unique<LabelLineRefExpr>
                         (END_OF_PROGRAM, end_of_program_loc), end_of_program_loc);
        out_prog->stmts.push_back(std::move(goto_stmt));

        // now add all procs definitions ordered by name
        std::vector<std::string> proc_names;
        for (auto& [name, def_proc] : symtab.procs) {
            proc_names.push_back(name);
        }
        std::sort(proc_names.begin(), proc_names.end());
        for (auto& name : proc_names) {
            auto& def_proc = symtab.procs[name];

            if (def_proc->called) {
                // add target label for the proc
                auto target_stmt = std::make_unique<LabelStmt>(def_proc->name, def_proc->loc);
                out_prog->stmts.push_back(std::move(target_stmt));

                // add stack entry for the proc
                control_stack.push_back({ ControlStackEntry::Type::Proc, "" });

                // add the proc definition
                lower(def_proc->body, symtab, control_stack, *out_prog);

                // add RETURN at the end of the proc
                auto return_stmt = std::make_unique<ReturnStmt>(def_proc->loc);
                out_prog->stmts.push_back(std::move(return_stmt));

                control_stack.pop_back();
            }
        }
    }

    // Add end label for END statement
    auto target_stmt = std::make_unique<LabelStmt>(END_OF_PROGRAM,
                       end_of_program_loc);
    out_prog->stmts.push_back(std::move(target_stmt));
}

bool lower_prog(Prog& prog, Symtab& symtab, std::unique_ptr<Prog>& out_prog) {
    lower(prog, symtab, out_prog);

#ifdef _DEBUG
    if (g_dump_step == 9) {
        if (get_error_count() == 0) {
            DumpContext ctx(std::cout);
            out_prog->dump(ctx);
        }
        exit_error_status();
    }
#endif

    return get_error_count() == 0;
}
