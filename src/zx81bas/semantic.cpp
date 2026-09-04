//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "ast_stmt.h"
#include "errors.h"
#include "semantic.h"
#include <algorithm>
#include <unordered_set>

struct RecursionDetector : ASTWalker {
    using ASTWalker::visit; // so that base class visit methods are visible

    Prog& prog;
    std::string cur_func;
    std::unordered_map<std::string, std::vector<std::string>> call_tree;
    std::unordered_map<std::string, SourceLoc> defined_loc;

    explicit RecursionDetector(Prog& p) : prog(p) {}

    void enter(DefProcStmt& stmt) override {
        cur_func = stmt.name;
        defined_loc[stmt.name] = stmt.loc;
    }

    void leave(DefProcStmt&) override {
        cur_func.clear();
    }

    void enter(DefFnStmt& stmt) override {
        cur_func = stmt.name;
        defined_loc[stmt.name] = stmt.loc;
    }

    void leave(DefFnStmt&) override {
        cur_func.clear();
    }

    void visit(ProcCallStmt& stmt) {
        if (!cur_func.empty()) {
            auto called = call_tree[cur_func];
            if (std::find(called.begin(), called.end(), stmt.name)
                    == called.end()) {
                called.push_back(stmt.name);
            }
        }
    }

    void visit(ProcCallExpr& expr) {
        if (!cur_func.empty()) {
            auto called = call_tree[cur_func];
            if (std::find(called.begin(), called.end(), expr.name)
                    == called.end()) {
                called.push_back(expr.name);
            }
        }
    }

    void visit(FnCallExpr& expr) {
        if (!cur_func.empty()) {
            auto called = call_tree[cur_func];
            if (std::find(called.begin(), called.end(), expr.name)
                    == called.end()) {
                called.push_back(expr.name);
            }
        }
    }

    // detect recursion
    bool reaches_self(const std::string& start,
                      const std::string& current,
                      std::unordered_set<std::string> visited) {
        if (!visited.insert(current).second) {
            return false;
        }

        auto it = call_tree.find(current);
        if (it == call_tree.end()) {
            return false;
        }

        for (const auto& callee : it->second) {
            if (callee == start) {
                return true;
            }

            if (reaches_self(start, callee, visited)) {
                return true;
            }
        }

        return false;
    }

    void check_recursion() {
        for (const auto& [func, called] : call_tree) {
            std::unordered_set<std::string> visited;

            for (const auto& callee : called) {
                if (callee == func ||
                        reaches_self(func, callee, visited)) {
                    SourceLoc loc;
                    auto it = defined_loc.find(func);
                    if (it != defined_loc.end()) {
                        loc = it->second;
                    }
                    error(loc, "Recursion not allowed");
                    break;
                }
            }
        }
    }
};

bool semantic_check(Prog& prog) {
    // check for recursion in procedures and functions
    RecursionDetector detector(prog);
    prog.accept(detector);
    detector.check_recursion();
    if (get_error_count() > 0) {
        return false;
    }

    return get_error_count() == 0;
}

#if 0
static void collect_decl_symbols(Prog& prog) {
    create_symtab(prog, prog.decl_symbols);

#ifdef _DEBUG
    if (g_dump_step == 6) {
        if (get_error_count() == 0) {
            DumpContext ctx(std::cout);
            prog.dump(ctx);
        }
        exit_error_status();
    }
#endif
}

static void semantic_check_ast_rewrite(Prog& prog) {
    (void)prog;

#ifdef _DEBUG
    if (g_dump_step == 7) {
        if (get_error_count() == 0) {
            DumpContext ctx(std::cout);
            prog.dump(ctx);
        }
        exit_error_status();
    }
#endif
}

static void collect_def_symbols(Prog& prog) {
    create_symtab(prog, prog.def_symbols);

#ifdef _DEBUG
    if (g_dump_step == 8) {
        if (get_error_count() == 0) {
            DumpContext ctx(std::cout);
            prog.dump(ctx);
        }
        exit_error_status();
    }
#endif
}

bool semantic_check(Prog& prog) {
    collect_decl_symbols(prog);
    if (get_error_count() > 0) {
        return false;
    }

    semantic_check_ast_rewrite(prog);
    if (get_error_count() > 0) {
        return false;
    }

    collect_def_symbols(prog);
    return get_error_count() == 0;
}

#if 0

#include "ast.h"
#include "ast_expr.h"
#include "ast_stmt.h"
#include "dump_context.h"
#include "errors.h"
#include <algorithm>
#include <cstdlib>
#include <memory>
#include <string>
#include <unordered_set>
#include <utility>
#include <vector>

// rewrite DEF FN expression replacing each paramater by <FNname><parameter>
static std::unique_ptr<Expr> rewrite_expr(Expr& expr,
        const std::string& fn_name,
        const std::unordered_set<std::string>& params) {
    if (auto num_expr = dynamic_cast<NumberExpr*>(&expr)) {
        return std::make_unique<NumberExpr>(num_expr->value, num_expr->loc);
    }
    else if (auto label_ref = dynamic_cast<LabelLineRefExpr*>(&expr)) {
        return std::make_unique<LabelLineRefExpr>(label_ref->name, label_ref->loc);
    }
    else if (auto label_addr_ref = dynamic_cast<LabelAddrRefExpr*>(&expr)) {
        return std::make_unique<LabelAddrRefExpr>(label_addr_ref->name,
                label_addr_ref->loc);
    }
    else if (auto str_expr = dynamic_cast<StringLiteralExpr*>(&expr)) {
        return std::make_unique<StringLiteralExpr>(str_expr->value, str_expr->loc);
    }
    else if (auto var_expr = dynamic_cast<VariableExpr*>(&expr)) {
        std::string new_name = var_expr->name;
        auto it = params.find(new_name);
        if (it != params.end()) {
            new_name = fn_name + var_expr->name;
        }
        return std::make_unique<VariableExpr>(new_name, var_expr->loc);
    }
    else if (auto array_ref_expr = dynamic_cast<ArrayRefExpr*>(&expr)) {
        std::vector<std::unique_ptr<Expr>> rewritten_indices;
        for (auto& index_expr : array_ref_expr->indices) {
            auto rewritten_index = rewrite_expr(*index_expr, fn_name, params);
            rewritten_indices.push_back(std::move(rewritten_index));
        }
        auto rewritten_array_ref = std::make_unique<ArrayRefExpr>(
                                       array_ref_expr->name, array_ref_expr->loc);
        rewritten_array_ref->indices = std::move(rewritten_indices);
        return rewritten_array_ref;
    }
    else if (auto slice_expr = dynamic_cast<SliceExpr*>(&expr)) {
        auto rewritten_base = rewrite_expr(*slice_expr->base, fn_name, params);
        auto rewritten_slice = std::make_unique<SliceExpr>(
                                   std::move(rewritten_base), slice_expr->loc);
        if (slice_expr->from) {
            auto rewritten_from = rewrite_expr(*slice_expr->from, fn_name, params);
            rewritten_slice->from = std::move(rewritten_from);
        }
        if (slice_expr->to) {
            auto rewritten_to = rewrite_expr(*slice_expr->to, fn_name, params);
            rewritten_slice->to = std::move(rewritten_to);
        }
        return rewritten_slice;
    }
    else if (auto un_expr = dynamic_cast<UnaryExpr*>(&expr)) {
        auto rewritten_operand = rewrite_expr(*un_expr->operand, fn_name, params);
        auto rewritten_unary = std::make_unique<UnaryExpr>(un_expr->op,
                               std::move(rewritten_operand), un_expr->loc);
        return rewritten_unary;
    }
    else if (auto bin_expr = dynamic_cast<BinaryExpr*>(&expr)) {
        auto rewritten_lhs = rewrite_expr(*bin_expr->lhs, fn_name, params);
        auto rewritten_rhs = rewrite_expr(*bin_expr->rhs, fn_name, params);
        auto rewritten_binary = std::make_unique<BinaryExpr>(bin_expr->op,
                                std::move(rewritten_lhs),
                                std::move(rewritten_rhs),
                                bin_expr->loc);
        return rewritten_binary;
    }
    else if (auto fn_call_expr = dynamic_cast<BasicFuncCallExpr*>(&expr)) {
        std::vector<std::unique_ptr<Expr>> rewritten_args;
        for (auto& arg_expr : fn_call_expr->args) {
            auto rewritten_arg = rewrite_expr(*arg_expr, fn_name, params);
            rewritten_args.push_back(std::move(rewritten_arg));
        }
        auto rewritten_fn_call = std::make_unique<BasicFuncCallExpr>
                                 (fn_call_expr->keyword, fn_call_expr->loc);
        rewritten_fn_call->args = std::move(rewritten_args);
        return rewritten_fn_call;
    }
    else if (auto proc_call_expr = dynamic_cast<ProcCallExpr*>(&expr)) {
        std::vector<std::unique_ptr<Expr>> rewritten_args;
        for (auto& arg_expr : proc_call_expr->args) {
            auto rewritten_arg = rewrite_expr(*arg_expr, fn_name, params);
            rewritten_args.push_back(std::move(rewritten_arg));
        }
        auto rewritten_proc_call = std::make_unique<ProcCallExpr>
                                   (proc_call_expr->name, proc_call_expr->loc);
        rewritten_proc_call->args = std::move(rewritten_args);
        return rewritten_proc_call;
    }
    else if (auto fn_call_expr = dynamic_cast<FnCallExpr*>(&expr)) {
        std::vector<std::unique_ptr<Expr>> rewritten_args;
        for (auto& arg_expr : fn_call_expr->args) {
            auto rewritten_arg = rewrite_expr(*arg_expr, fn_name, params);
            rewritten_args.push_back(std::move(rewritten_arg));
        }
        auto rewritten_fn_call = std::make_unique<ProcCallExpr>
                                 (fn_call_expr->name, fn_call_expr->loc);
        rewritten_fn_call->args = std::move(rewritten_args);
        return rewritten_fn_call;
    }
    else {
        error(expr.loc, "Unknown expression type");
        return std::make_unique<NumberExpr>(0, expr.loc);
    }
}

// rewrite DEF FN replacing all parameters by <FNname><param>
static void rewrite_def_fn(DefFnStmt& def_fn_stmt) {
    // collect set of parameters
    std::unordered_set<std::string> params;
    for (auto& param : def_fn_stmt.params) {
        if (params.count(param) > 0) {
            error(def_fn_stmt.loc, "Duplicate parameter '" + param + "'");
        }
        params.insert(param);
    }

    auto rewritten = rewrite_expr(*def_fn_stmt.expr, def_fn_stmt.name, params);
    def_fn_stmt.expr = std::move(rewritten);
}

static void rewrite_def_fn(std::vector<std::unique_ptr<Stmt>>& stmts,
                           int level) {
    for (auto& stmt : stmts) {
        if (auto if_stmt = dynamic_cast<IfStmt*>(stmt.get())) {
            rewrite_def_fn(if_stmt->then_stmts, level + 1);
            rewrite_def_fn(if_stmt->else_stmts, level + 1);
        }
        else if (auto repeat_stmt = dynamic_cast<RepeatStmt*>(stmt.get())) {
            rewrite_def_fn(repeat_stmt->body, level + 1);
        }
        else if (auto while_stmt = dynamic_cast<WhileStmt*>(stmt.get())) {
            rewrite_def_fn(while_stmt->body, level + 1);
        }
        else if (auto for_stmt = dynamic_cast<ForStmt*>(stmt.get())) {
            rewrite_def_fn(for_stmt->body, level + 1);
        }
        else if (auto def_proc_stmt = dynamic_cast<DefProcStmt*>(stmt.get())) {
            rewrite_def_fn(def_proc_stmt->body, level + 1);
        }
        else if (auto def_fn_stmt = dynamic_cast<DefFnStmt*>(stmt.get())) {
            if (level > 0) {
                error(def_fn_stmt->loc,
                      "DEF FN statement is not allowed inside another statement block");
            }
            else {
                rewrite_def_fn(*def_fn_stmt);
            }
        }
    }
}

static void rewrite_def_fn(Prog& prog) {
    rewrite_def_fn(prog.stmts, 0);
}

// verify that DefProcStmt, DefFnStmt and Pragma nodes only appear at the top level of the program
static void check_lower_level(const std::vector<std::unique_ptr<Stmt>>& stmts) {
    for (const auto& stmt : stmts) {
        if (auto if_stmt = dynamic_cast<IfStmt*>(stmt.get())) {
            check_lower_level(if_stmt->then_stmts);
            check_lower_level(if_stmt->else_stmts);
        }
        else if (auto repeat_stmt = dynamic_cast<RepeatStmt*>(stmt.get())) {
            check_lower_level(repeat_stmt->body);
        }
        else if (auto while_stmt = dynamic_cast<WhileStmt*>(stmt.get())) {
            check_lower_level(while_stmt->body);
        }
        else if (auto for_stmt = dynamic_cast<ForStmt*>(stmt.get())) {
            check_lower_level(for_stmt->body);
        }
        else if (auto def_proc_stmt = dynamic_cast<DefProcStmt*>(stmt.get())) {
            error(stmt->loc,
                  "DEF PROC statement is not allowed inside another statement block");
            check_lower_level(def_proc_stmt->body);
        }
        else if (dynamic_cast<DefFnStmt*>(stmt.get())) {
            error(stmt->loc,
                  "DEF FN statement is not allowed inside another statement block");
        }
        else if (dynamic_cast<PragmaNumVarStmt*>(stmt.get())) {
            error(stmt->loc,
                  "#VARS statement is not allowed inside another statement block");
        }
        else if (dynamic_cast<PragmaStrVarStmt*>(stmt.get())) {
            error(stmt->loc,
                  "#VARS statement is not allowed inside another statement block");
        }
        else if (dynamic_cast<PragmaNumVarArrayStmt*>(stmt.get())) {
            error(stmt->loc,
                  "#VARS statement is not allowed inside another statement block");
        }
        else if (dynamic_cast<PragmaStrVarArrayStmt*>(stmt.get())) {
            error(stmt->loc,
                  "#VARS statement is not allowed inside another statement block");
        }
        else {
            // ok
        }
    }
}

static void check_top_level(const Prog& prog) {
    for (const auto& stmt : prog.stmts) {
        if (auto if_stmt = dynamic_cast<IfStmt*>(stmt.get())) {
            check_lower_level(if_stmt->then_stmts);
            check_lower_level(if_stmt->else_stmts);
        }
        else if (auto repeat_stmt = dynamic_cast<RepeatStmt*>(stmt.get())) {
            check_lower_level(repeat_stmt->body);
        }
        else if (auto while_stmt = dynamic_cast<WhileStmt*>(stmt.get())) {
            check_lower_level(while_stmt->body);
        }
        else if (auto for_stmt = dynamic_cast<ForStmt*>(stmt.get())) {
            check_lower_level(for_stmt->body);
        }
        else if (auto def_proc_stmt = dynamic_cast<DefProcStmt*>(stmt.get())) {
            check_lower_level(def_proc_stmt->body);
        }
        else {
            // ok
        }
    }
}

// verify that all expressions have a valid type
static void compute_expr_type(Expr& expr) {
    if (dynamic_cast<NumberExpr*>(&expr)) {
        expr.type = ExprType::Number;
    }
    else if (dynamic_cast<LabelLineRefExpr*>(&expr)) {
        expr.type = ExprType::Number;
    }
    else if (dynamic_cast<LabelAddrRefExpr*>(&expr)) {
        expr.type = ExprType::Number;
    }
    else if (dynamic_cast<StringLiteralExpr*>(&expr)) {
        expr.type = ExprType::String;
    }
    else if (auto var_expr = dynamic_cast<VariableExpr*>(&expr)) {
        expr.type = is_string_variable(var_expr->name) ?
                    ExprType::String : ExprType::Number;
    }
    else if (auto array_ref_expr = dynamic_cast<ArrayRefExpr*>(&expr)) {
        for (auto& index_expr : array_ref_expr->indices) {
            compute_expr_type(*index_expr);
            if (index_expr->type != ExprType::Number) {
                error(index_expr->loc, "Array index expression must be a number");
            }
        }
    }
    else if (auto slice_expr = dynamic_cast<SliceExpr*>(&expr)) {
        compute_expr_type(*slice_expr->base);
        if (slice_expr->from) {
            compute_expr_type(*slice_expr->from);
        }
        if (slice_expr->to) {
            compute_expr_type(*slice_expr->to);
        }
        if (slice_expr->base->type != ExprType::String) {
            error(slice_expr->loc, "Slice base expression must be a string");
        }
        if (slice_expr->from && slice_expr->from->type != ExprType::Number) {
            error(slice_expr->loc, "Slice 'from' expression must be a number");
        }
        if (slice_expr->to && slice_expr->to->type != ExprType::Number) {
            error(slice_expr->loc, "Slice 'to' expression must be a number");
        }
    }
    else if (auto un_expr = dynamic_cast<UnaryExpr*>(&expr)) {
        compute_expr_type(*un_expr->operand);
        switch (un_expr->op) {
        case TokenType::Minus:
        case TokenType::NOT:
            if (un_expr->operand->type != ExprType::Number) {
                error(un_expr->loc, "Unary operator requires a number operand");
            }
            break;
        default:
            error(un_expr->loc, "Unknown unary operator");
            break;
        }
        expr.type = un_expr->operand->type;
    }
    else if (auto bin_expr = dynamic_cast<BinaryExpr*>(&expr)) {
        compute_expr_type(*bin_expr->lhs);
        compute_expr_type(*bin_expr->rhs);
        if (bin_expr->lhs->type != bin_expr->rhs->type) {
            error(bin_expr->loc, "Binary expression operands must have the same type");
        }
        switch (bin_expr->op) {
        case TokenType::Plus:
            // Plus operator can be used for both numbers and strings
            break;
        case TokenType::Minus:
        case TokenType::Multiply:
        case TokenType::Divide:
        case TokenType::Power:
        case TokenType::IntDivide:
        case TokenType::MOD:
            if (bin_expr->lhs->type != ExprType::Number) {
                error(bin_expr->loc, "Binary arithmetic operators require number operands");
            }
            break;
        case TokenType::AND:
        case TokenType::OR:
            if (bin_expr->lhs->type != ExprType::Number) {
                error(bin_expr->loc, "Binary logical operators require number operands");
            }
            break;
        case TokenType::Equal:
        case TokenType::NotEqual:
        case TokenType::Less:
        case TokenType::LessEqual:
        case TokenType::Greater:
        case TokenType::GreaterEqual:
            // Comparison operators can be used for both numbers and strings
            break;
        default:
            error(bin_expr->loc, "Unknown binary operator");
            break;
        }
        expr.type = bin_expr->lhs->type;
    }
    else if (auto fn_call_expr = dynamic_cast<BasicFuncCallExpr*>(&expr)) {
        for (auto& arg_expr : fn_call_expr->args) {
            compute_expr_type(*arg_expr);
        }

        // number of arguments check
        switch (fn_call_expr->keyword) {
        case Keyword::RND:
        case Keyword::PI:
        case Keyword::INKEY_DLR:
            if (fn_call_expr->args.size() != 0) {
                error(fn_call_expr->loc, "Function call requires exactly zero arguments");
            }
            break;
        default:
            if (fn_call_expr->args.size() != 1) {
                error(fn_call_expr->loc, "Function call requires exactly one argument");
            }
            break;
        }

        // type of arguments check
        switch (fn_call_expr->keyword) {
        case Keyword::RND:
        case Keyword::PI:
            expr.type = ExprType::Number;
            break;
        case Keyword::INKEY_DLR:
            expr.type = ExprType::String;
            break;
        case Keyword::CODE:
        case Keyword::VAL:
        case Keyword::LEN:
            if (fn_call_expr->args.size() == 1) {
                if (fn_call_expr->args[0]->type != ExprType::String) {
                    error(fn_call_expr->loc, "Function argument must be a string");
                }
            }
            expr.type = ExprType::Number;
            break;
        case Keyword::SIN:
        case Keyword::COS:
        case Keyword::TAN:
        case Keyword::ASN:
        case Keyword::ACS:
        case Keyword::ATN:
        case Keyword::LN:
        case Keyword::EXP:
        case Keyword::INT:
        case Keyword::SQR:
        case Keyword::SGN:
        case Keyword::ABS:
        case Keyword::PEEK:
        case Keyword::USR:
        case Keyword::PEEKW:
            if (fn_call_expr->args.size() == 1) {
                if (fn_call_expr->args[0]->type != ExprType::Number) {
                    error(fn_call_expr->loc, "Function argument must be a number");
                }
            }
            expr.type = ExprType::Number;
            break;
            expr.type = ExprType::Number;
            break;
            expr.type = ExprType::Number;
            break;
        case Keyword::STR_DLR:
        case Keyword::CHR_DLR:
            if (fn_call_expr->args.size() == 1) {
                if (fn_call_expr->args[0]->type != ExprType::Number) {
                    error(fn_call_expr->loc, "Function argument must be a number");
                }
            }
            expr.type = ExprType::String;
            break;
        default:
            error(fn_call_expr->loc, "Unknown function call");
            break;
        }
    }
    else if (auto proc_call_expr = dynamic_cast<ProcCallExpr*>(&expr)) {
        for (auto& arg_expr : proc_call_expr->args) {
            compute_expr_type(*arg_expr);
            if (arg_expr->type != ExprType::Number) {
                error(arg_expr->loc, "PROC call argument must be a number");
            }
        }
        expr.type = ExprType::Number;  // PROC calls return a number
    }
    else if (auto fn_call_expr = dynamic_cast<FnCallExpr*>(&expr)) {
        for (auto& arg_expr : fn_call_expr->args) {
            compute_expr_type(*arg_expr);
            if (arg_expr->type != ExprType::Number) {
                error(arg_expr->loc, "FN call arguments must be numbers");
            }
        }
        expr.type = ExprType::Number;  // FN calls return a number
    }
    else {
        error(expr.loc, "Unknown expression type");
    }
}

static void verify_expr_types(const std::vector<std::unique_ptr<Stmt>>& stmts) {
    for (const auto& stmt : stmts) {
        if (auto let_stmt = dynamic_cast<const LetStmt*>(stmt.get())) {
            compute_expr_type(*let_stmt->lhs.get());
            compute_expr_type(*let_stmt->rhs.get());
            if (let_stmt->lhs->type != let_stmt->rhs->type) {
                error(let_stmt->loc, "Type mismatch in LET statement");
            }
        }
        else if (auto dim_stmt = dynamic_cast<const DimStmt*>(stmt.get())) {
            for (const auto& item : dim_stmt->items) {
                for (const auto& dim_expr : item.dims) {
                    compute_expr_type(*dim_expr);
                    if (dim_expr->type != ExprType::Number) {
                        error(dim_expr->loc, "Array dimension expression must be a number");
                    }
                }
            }
        }
        else if (auto if_stmt = dynamic_cast<const IfStmt*>(stmt.get())) {
            compute_expr_type(*if_stmt->condition);
            if (if_stmt->condition->type != ExprType::Number) {
                error(if_stmt->condition->loc, "IF condition must be a number");
            }
            verify_expr_types(if_stmt->then_stmts);
            verify_expr_types(if_stmt->else_stmts);
        }
        else if (auto repeat_stmt = dynamic_cast<const RepeatStmt*>(stmt.get())) {
            compute_expr_type(*repeat_stmt->condition);
            if (repeat_stmt->condition->type != ExprType::Number) {
                error(repeat_stmt->condition->loc, "UNTIL condition must be a number");
            }
            verify_expr_types(repeat_stmt->body);
        }
        else if (auto while_stmt = dynamic_cast<const WhileStmt*>(stmt.get())) {
            compute_expr_type(*while_stmt->condition);
            if (while_stmt->condition->type != ExprType::Number) {
                error(while_stmt->condition->loc, "WHILE condition must be a number");
            }
            verify_expr_types(while_stmt->body);
        }
        else if (auto for_stmt = dynamic_cast<const ForStmt*>(stmt.get())) {
            compute_expr_type(*for_stmt->start_expr);
            if (for_stmt->start_expr->type != ExprType::Number) {
                error(for_stmt->start_expr->loc, "FOR start expression must be a number");
            }
            compute_expr_type(*for_stmt->end_expr);
            if (for_stmt->end_expr->type != ExprType::Number) {
                error(for_stmt->end_expr->loc, "FOR end expression must be a number");
            }
            compute_expr_type(*for_stmt->step_expr);
            if (for_stmt->step_expr->type != ExprType::Number) {
                error(for_stmt->step_expr->loc, "FOR step expression must be a number");
            }
            verify_expr_types(for_stmt->body);
        }
        else if (auto def_proc_stmt = dynamic_cast<const DefProcStmt*>(stmt.get())) {
            verify_expr_types(def_proc_stmt->body);
        }
        else if (auto proc_call_stmt = dynamic_cast<const ProcCallStmt*>(stmt.get())) {
            for (const auto& arg : proc_call_stmt->args) {
                compute_expr_type(*arg);
                if (arg->type != ExprType::Number) {
                    error(proc_call_stmt->loc, "PROC call argument must be a number");
                }
            }
        }
        else if (dynamic_cast<LocalStmt*>(stmt.get())) {
            error(stmt->loc, "internal error, LOCAL not expected");
        }
        else if (auto def_fn_stmt = dynamic_cast<const DefFnStmt*>(stmt.get())) {
            compute_expr_type(*def_fn_stmt->expr);
            if (def_fn_stmt->expr->type != ExprType::Number) {
                error(def_fn_stmt->loc, "DEF FN expression must return a number");
            }
        }
        else if (auto goto_stmt = dynamic_cast<const GotoStmt*>(stmt.get())) {
            compute_expr_type(*goto_stmt->target_expr);
            if (goto_stmt->target_expr->type != ExprType::Number) {
                error(goto_stmt->loc, "GOTO expression must be a number");
            }
        }
        else if (auto gosub_stmt = dynamic_cast<const GosubStmt*>(stmt.get())) {
            compute_expr_type(*gosub_stmt->target_expr);
            if (gosub_stmt->target_expr->type != ExprType::Number) {
                error(gosub_stmt->loc, "GOTO expression must be a number");
            }
        }
        else if (auto print_stmt = dynamic_cast<const PrintStmt*>(stmt.get())) {
            for (const auto& item : print_stmt->items) {
                if (item.type == PrintItem::Type::Expr) {
                    compute_expr_type(*item.expr);
                }
                else if (item.type == PrintItem::Type::At) {
                    compute_expr_type(*item.line_expr);
                    if (item.line_expr->type != ExprType::Number) {
                        error(print_stmt->loc, "AT argument must be a number");
                    }
                    compute_expr_type(*item.col_expr);
                    if (item.col_expr->type != ExprType::Number) {
                        error(print_stmt->loc, "AT argument must be a number");
                    }
                }
                else if (item.type == PrintItem::Type::Tab) {
                    compute_expr_type(*item.tab_expr);
                    if (item.tab_expr->type != ExprType::Number) {
                        error(print_stmt->loc, "AT argument must be a number");
                    }
                }
            }
        }
        else if (auto input_stmt = dynamic_cast<const InputStmt*>(stmt.get())) {
            for (const auto& item : input_stmt->vars) {
                compute_expr_type(*item);
            }
        }
        else if (dynamic_cast<const RemStmt*>(stmt.get())) {
            // nothing to do
        }
        else if (auto run_stmt = dynamic_cast<const RunStmt*>(stmt.get())) {
            if (run_stmt->target_expr) {
                compute_expr_type(*run_stmt->target_expr);
                if (run_stmt->target_expr->type != ExprType::Number) {
                    error(run_stmt->loc, "RUN expression must be a number");
                }
            }
        }
        else if (auto list_stmt = dynamic_cast<const ListStmt*>(stmt.get())) {
            if (list_stmt->target_expr) {
                compute_expr_type(*list_stmt->target_expr);
                if (list_stmt->target_expr->type != ExprType::Number) {
                    error(list_stmt->loc, "LIST expression must be a number");
                }
            }
        }
        else if (dynamic_cast<const NewStmt*>(stmt.get())) {
            // nothing to do
        }
        else if (dynamic_cast<const ClsStmt*>(stmt.get())) {
            // nothing to do
        }
        else if (auto load_stmt = dynamic_cast<const LoadStmt*>(stmt.get())) {
            compute_expr_type(*load_stmt->filename_expr);
            if (load_stmt->filename_expr->type != ExprType::String) {
                error(load_stmt->loc, "LOAD expression must be a string");
            }
        }
        else if (auto save_stmt = dynamic_cast<const SaveStmt*>(stmt.get())) {
            compute_expr_type(*save_stmt->filename_expr);
            if (save_stmt->filename_expr->type != ExprType::String) {
                error(save_stmt->loc, "SAVE expression must be a string");
            }
        }
        else if (auto poke_stmt = dynamic_cast<const PokeStmt*>(stmt.get())) {
            compute_expr_type(*poke_stmt->address_expr);
            if (poke_stmt->address_expr->type != ExprType::Number) {
                error(poke_stmt->loc, "POKE expression must be a number");
            }
            compute_expr_type(*poke_stmt->value_expr);
            if (poke_stmt->value_expr->type != ExprType::Number) {
                error(poke_stmt->loc, "POKE expression must be a number");
            }
        }
        else if (auto pokew_stmt = dynamic_cast<const PokewStmt*>(stmt.get())) {
            compute_expr_type(*pokew_stmt->address_expr);
            if (pokew_stmt->address_expr->type != ExprType::Number) {
                error(pokew_stmt->loc, "POKEW expression must be a number");
            }
            compute_expr_type(*pokew_stmt->value_expr);
            if (pokew_stmt->value_expr->type != ExprType::Number) {
                error(pokew_stmt->loc, "POKEW expression must be a number");
            }
        }
        else if (auto plot_stmt = dynamic_cast<const PlotStmt*>(stmt.get())) {
            compute_expr_type(*plot_stmt->x_expr);
            if (plot_stmt->x_expr->type != ExprType::Number) {
                error(plot_stmt->loc, "PLOT expression must be a number");
            }
            compute_expr_type(*plot_stmt->y_expr);
            if (plot_stmt->y_expr->type != ExprType::Number) {
                error(plot_stmt->loc, "PLOT expression must be a number");
            }
        }
        else if (auto unplot_stmt = dynamic_cast<const UnplotStmt*>(stmt.get())) {
            compute_expr_type(*unplot_stmt->x_expr);
            if (unplot_stmt->x_expr->type != ExprType::Number) {
                error(unplot_stmt->loc, "UNPLOT expression must be a number");
            }
            compute_expr_type(*unplot_stmt->y_expr);
            if (unplot_stmt->y_expr->type != ExprType::Number) {
                error(unplot_stmt->loc, "UNPLOT expression must be a number");
            }
        }
        else if (auto rand_stmt = dynamic_cast<const RandStmt*>(stmt.get())) {
            compute_expr_type(*rand_stmt->seed_expr);
            if (rand_stmt->seed_expr->type != ExprType::Number) {
                error(rand_stmt->loc, "RAND expression must be a number");
            }
        }
        else if (auto pause_stmt = dynamic_cast<const PauseStmt*>(stmt.get())) {
            compute_expr_type(*pause_stmt->duration_expr);
            if (pause_stmt->duration_expr->type != ExprType::Number) {
                error(pause_stmt->loc, "PAUSE expression must be a number");
            }
        }
        else if (dynamic_cast<const FastStmt*>(stmt.get())) {
            // nothing to do
        }
        else if (dynamic_cast<const SlowStmt*>(stmt.get())) {
            // nothing to do
        }
        else if (dynamic_cast<const ScrollStmt*>(stmt.get())) {
            // nothing to do
        }
        else if (dynamic_cast<const ContStmt*>(stmt.get())) {
            // nothing to do
        }
        else if (dynamic_cast<const ClearStmt*>(stmt.get())) {
            // nothing to do
        }
        else if (dynamic_cast<const PragmaNumVarStmt*>(stmt.get())) {
            // nothing to do
        }
        else if (dynamic_cast<const PragmaStrVarStmt*>(stmt.get())) {
            // nothing to do
        }
        else if (dynamic_cast<const PragmaNumVarArrayStmt*>(stmt.get())) {
            // nothing to do
        }
        else if (dynamic_cast<const PragmaStrVarArrayStmt*>(stmt.get())) {
            // nothing to do
        }
    }
}


// collect LocalStmt variables and store them in DefProcStmt
// report duplicate parameters and locals
// report nested DEF PROC
struct LocalCollector : ASTWalker {
    using ASTWalker::visit; // so that base class visit methods are visible

    Prog& prog;
    DefProcStmt* cur_proc = nullptr;
    std::unordered_set<std::string> local_vars;
    LocalCollector(Prog& p) : prog(p) {}

    void enter(DefProcStmt& stmt) override {
        if (cur_proc != nullptr) {
            error(stmt.loc, "Nested DEF PROC not allowed");
            stmt.mark_for_removal = true;
        }
        else {
            cur_proc = &stmt;
            for (auto& var : stmt.params) {
                if (local_vars.count(var) > 0) {
                    error(stmt.loc, "Duplicate variable: '" + var + "'");
                }
                else {
                    local_vars.insert(var);
                }
            }
        }
    }
    void leave(DefProcStmt&) override {
        cur_proc = nullptr;
        local_vars.clear();
    }
    void visit(LocalStmt& stmt) override {
        if (cur_proc == nullptr) {
            error(stmt.loc, "LOCAL outside DEF PROC not allowed");
        }
        else {
            for (auto& var : stmt.locals) {
                if (local_vars.count(var) > 0) {
                    error(stmt.loc, "Duplicate variable: '" + var + "'");
                }
                else {
                    local_vars.insert(var);
                    cur_proc->locals.push_back(var);
                }
            }
        }
        stmt.mark_for_removal = true;
    }
};

static void collect_def_proc_locals(Prog& prog) {
    LocalCollector collector(prog);
    prog.accept(collector);
}


// rewrite def proc bodies replacing local variables and parameters
// by <proc-name><param-name>
struct DefProcRewritter : ASTWalker {
    using ASTWalker::visit; // so that base class visit methods are visible

    Prog& prog;
    DefProcStmt* cur_proc = nullptr;
    std::unordered_set<std::string> local_vars;
    DefProcRewritter(Prog& p) : prog(p) {}

    void enter(DefProcStmt& stmt) override {
        if (cur_proc != nullptr) {
            error(stmt.loc, "Nested DEF PROC not allowed");
            stmt.mark_for_removal = true;
        }
        else {
            cur_proc = &stmt;
            for (auto& var : stmt.params) {
                local_vars.insert(var);
            }
            for (auto& var : stmt.locals) {
                local_vars.insert(var);
            }
        }
    }
    void leave(DefProcStmt&) override {
        cur_proc = nullptr;
        local_vars.clear();
    }
    void visit(VariableExpr& expr) {
        if (cur_proc != nullptr) {
            if (local_vars.count(expr.name) > 0) {
                expr.name = cur_proc->name + expr.name;
            }
        }
    }
};

static void rewrite_def_proc_bodies(Prog& prog) {
    DefProcRewritter rewritter(prog);
    prog.accept(rewritter);
}


#if 0
// move Pragma-Stmt to the vars section
struct PragmaMover : ASTWalker {
    using ASTWalker::visit; // so that base class visit methods are visible

    Prog& prog;
    explicit PragmaMover(Prog& p) : prog(p) {}

    void visit(PragmaNumVarStmt& stmt) override {
        prog.vars.push_back(stmt.clone());
        stmt.mark_for_removal = true;
    }
    void visit(PragmaStrVarStmt& stmt) override {
        prog.vars.push_back(stmt.clone());
        stmt.mark_for_removal = true;
    }
    void visit(PragmaNumVarArrayStmt& stmt) override {
        prog.vars.push_back(stmt.clone());
        stmt.mark_for_removal = true;
    }
    void visit(PragmaStrVarArrayStmt& stmt) override {
        prog.vars.push_back(stmt.clone());
        stmt.mark_for_removal = true;
    }
};

static void move_pragmas_to_vars(Prog& prog) {
    PragmaMover mover(prog);
    prog.accept(mover);
}
#endif


#if 0
// move all DefProcStmt to the prog header, removing from the statement list
struct DefProcMover : ASTWalker {
    using ASTWalker::visit; // so that base class visit methods are visible

    Prog& prog;
    DefProcMover(Prog& p) : prog(p) {}

    void enter(DefProcStmt& stmt) override {
        auto it = prog.procs.find(stmt.name);
        if (it != prog.procs.end()) {
            error(stmt.loc, "Duplicate definition: '" + stmt.name + "'");
            error(it->second->loc, "Previous definition here");
        }
        else {
            prog.procs[stmt.name] = stmt.clone();
        }
        stmt.mark_for_removal = true;
    }
};

static void move_def_proc_to_prog(Prog& prog) {
    DefProcMover mover(prog);
    prog.accept(mover);
}
#endif


bool semantic_check(Prog& prog) {
    // DEF PROC
    collect_def_proc_locals(prog);
    rewrite_def_proc_bodies(prog);


    verify_expr_types(prog.stmts);



#if 0
    // move pragma vars
    move_pragmas_to_vars(prog);

    // move procs to prog header
    move_def_proc_to_prog(prog);
#endif

    // ---- HERE ----

    check_top_level(prog);

    // rewrite DEF FNs
    rewrite_def_fn(prog);

    //detect_recursion(prog);

    return get_error_count() == 0;
}

#endif
#endif
