//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "release_assert.h"
#include "semantic.h"
#include "walker.h"
#include <algorithm>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

// check for recursion in FN and PROC
struct RecursionDetector : ASTVisitor {
    virtual ~RecursionDetector() = default;

    std::string cur_func;
    std::unordered_map<std::string, std::vector<std::string>> call_tree;
    std::unordered_map<std::string, SourceLoc> defined_loc;

    bool enter(DefProcStmt& stmt) override {
        cur_func = stmt.name;
        defined_loc[stmt.name] = stmt.loc;
        return true;
    }

    void leave(DefProcStmt&) override {
        cur_func.clear();
    }

    bool enter(DefFnStmt& stmt) override {
        cur_func = stmt.name;
        defined_loc[stmt.name] = stmt.loc;
        return true;
    }

    void leave(DefFnStmt&) override {
        cur_func.clear();
    }

    void visit(ProcCallStmt& stmt) override {
        if (!cur_func.empty()) {
            auto& called = call_tree[cur_func];
            if (std::find(called.begin(), called.end(), stmt.name)
                    == called.end()) {
                called.push_back(stmt.name);
            }
        }
    }

    void visit(ProcCallExpr& expr) override {
        if (!cur_func.empty()) {
            auto& called = call_tree[cur_func];
            if (std::find(called.begin(), called.end(), expr.name)
                    == called.end()) {
                called.push_back(expr.name);
            }
        }
    }

    void visit(FnCallExpr& expr) override {
        if (!cur_func.empty()) {
            auto& called = call_tree[cur_func];
            if (std::find(called.begin(), called.end(), expr.name)
                    == called.end()) {
                called.push_back(expr.name);
            }
        }
    }

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

    void leave(Prog&) override {
        std::vector<std::string> funcs;
        for (const auto& [func, called] : call_tree) {
            funcs.push_back(func);
        }
        std::sort(funcs.begin(), funcs.end());

        for (const auto& func : funcs) {
            std::unordered_set<std::string> visited;

            auto called = call_tree.at(func);
            std::sort(called.begin(), called.end());

            for (const auto& callee : called) {
                if (callee == func ||
                        reaches_self(func, callee, visited)) {
                    SourceLoc loc;
                    auto it = defined_loc.find(func);
                    if (it != defined_loc.end()) {
                        loc = it->second;
                    }
                    error(loc, "Recursive function: " + func);
                    break;
                }
            }
        }
    }
};

// check expression type of all expressions
struct ExprTypeChecker : ASTVisitor {
    void visit(NumberExpr& expr) override {
        expr.type = ExprType::Number;
    }

    void visit(LabelLineRefExpr& expr) override {
        expr.type = ExprType::Number;
    }

    void visit(LabelAddrRefExpr& expr) override {
        expr.type = ExprType::Number;
    }

    void visit(StringLiteralExpr& expr) override {
        expr.type = ExprType::String;
    }

    void visit(VariableExpr& expr) override {
        expr.type = is_string_variable(expr.name) ?
                    ExprType::String : ExprType::Number;
    }

    void leave(ArrayRefExpr& expr) override {
        for (auto& index_expr : expr.indices) {
            if (index_expr->type != ExprType::Number) {
                error(index_expr->loc, "Array index expression must be a number");
            }
        }
    }

    void leave(SliceExpr& expr) override {
        if (expr.base->type != ExprType::String) {
            error(expr.loc, "Slice base expression must be a string");
        }
        if (expr.from && expr.from->type != ExprType::Number) {
            error(expr.loc, "Slice 'from' expression must be a number");
        }
        if (expr.to && expr.to->type != ExprType::Number) {
            error(expr.loc, "Slice 'to' expression must be a number");
        }
    }

    void leave(UnaryExpr& expr) override {
        switch (expr.op) {
        case TokenType::Minus:
        case TokenType::NOT:
            if (expr.operand->type != ExprType::Number) {
                error(expr.loc, "Unary operator requires a number operand");
            }
            break;
        default:
            release_assert(0);  // error already reported in parser
            break;
        }
        expr.type = expr.operand->type;
    }

    void leave(BinaryExpr& expr) override {
        if (expr.lhs->type != expr.rhs->type) {
            error(expr.loc, "Binary expression operands must have the same type");
        }
        switch (expr.op) {
        case TokenType::Plus:
            // Plus operator can be used for both numbers and strings
            break;
        case TokenType::Minus:
        case TokenType::Multiply:
        case TokenType::Divide:
        case TokenType::Power:
        case TokenType::IntDivide:
        case TokenType::MOD:
            if (expr.lhs->type != ExprType::Number) {
                error(expr.loc, "Binary arithmetic operators require number operands");
            }
            break;
        case TokenType::AND:
        case TokenType::OR:
            if (expr.lhs->type != ExprType::Number) {
                error(expr.loc, "Binary logical operators require number operands");
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
            release_assert(0);  // error already reported in parser
            break;
        }
        expr.type = expr.lhs->type;
    }

    void leave(BasicFuncCallExpr& expr) override {
        // number of arguments check
        switch (expr.keyword) {
        case Keyword::RND:
        case Keyword::PI:
        case Keyword::INKEY_DLR:
            release_assert(expr.args.size() == 0);  // error already reported in parser
            break;
        default:
            release_assert(expr.args.size() == 1);  // error already reported in parser
            break;
        }

        // type of arguments check
        switch (expr.keyword) {
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
            if (expr.args.size() == 1) {
                if (expr.args[0]->type != ExprType::String) {
                    error(expr.loc, "Function argument must be a string");
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
            if (expr.args.size() == 1) {
                if (expr.args[0]->type != ExprType::Number) {
                    error(expr.loc, "Function argument must be a number");
                }
            }
            expr.type = ExprType::Number;
            break;
        case Keyword::STR_DLR:
        case Keyword::CHR_DLR:
            if (expr.args.size() == 1) {
                if (expr.args[0]->type != ExprType::Number) {
                    error(expr.loc, "Function argument must be a number");
                }
            }
            expr.type = ExprType::String;
            break;
        default:
            release_assert(0);  // error already reported in parser
            break;
        }
    }

    void leave(ProcCallExpr& expr) override {
        for (auto& arg_expr : expr.args) {
            if (arg_expr->type != ExprType::Number) {
                error(arg_expr->loc, "PROC call argument must be a number");
            }
        }
        expr.type = ExprType::Number;  // PROC calls return a number
    }

    void leave(FnCallExpr& expr) override {
        for (auto& arg_expr : expr.args) {
            if (arg_expr->type != ExprType::Number) {
                error(arg_expr->loc, "FN call argument must be a number");
            }
        }
        expr.type = ExprType::Number;  // FN calls return a number
    }

    void leave(LetStmt& stmt) override {
        if (stmt.lhs->type != stmt.rhs->type) {
            error(stmt.loc, "Type mismatch in LET statement");
        }
    }

    void leave(DimStmt& stmt) override {
        for (const auto& item : stmt.items) {
            for (const auto& dim_expr : item.dims) {
                if (dim_expr->type != ExprType::Number) {
                    error(dim_expr->loc, "Array dimension expression must be a number");
                }
            }
        }
    }

    void leave(IfStmt& stmt) override {
        if (stmt.condition->type != ExprType::Number) {
            error(stmt.condition->loc, "IF condition must be a number");
        }
    }

    void leave(RepeatStmt& stmt) override {
        if (stmt.condition->type != ExprType::Number) {
            error(stmt.condition->loc, "UNTIL condition must be a number");
        }
    }

    void leave(WhileStmt& stmt) override {
        if (stmt.condition->type != ExprType::Number) {
            error(stmt.condition->loc, "WHILE condition must be a number");
        }
    }

    void leave(ForStmt& stmt) override {
        if (stmt.start_expr->type != ExprType::Number) {
            error(stmt.start_expr->loc, "FOR start expression must be a number");
        }
        if (stmt.end_expr->type != ExprType::Number) {
            error(stmt.end_expr->loc, "FOR end expression must be a number");
        }
        if (stmt.step_expr->type != ExprType::Number) {
            error(stmt.step_expr->loc, "FOR step expression must be a number");
        }
    }

    void leave(ProcCallStmt& stmt) override {
        for (const auto& arg : stmt.args) {
            if (arg->type != ExprType::Number) {
                error(stmt.loc, "PROC call argument must be a number");
            }
        }
    }

    void leave(DefFnStmt& stmt) override {
        if (stmt.expr->type != ExprType::Number) {
            error(stmt.loc, "DEF FN expression must return a number");
        }
    }

    void leave(GotoStmt& stmt) override {
        if (stmt.target_expr->type != ExprType::Number) {
            error(stmt.loc, "GOTO expression must be a number");
        }
    }

    void leave(GosubStmt& stmt) override {
        if (stmt.target_expr->type != ExprType::Number) {
            error(stmt.loc, "GOSUB expression must be a number");
        }
    }

    void leave(PrintStmt& stmt) override {
        for (const auto& item : stmt.items) {
            if (item.type == PrintItem::Type::At) {
                if (item.line_expr->type != ExprType::Number) {
                    error(stmt.loc, "AT argument must be a number");
                }
                if (item.col_expr->type != ExprType::Number) {
                    error(stmt.loc, "AT argument must be a number");
                }
            }
            else if (item.type == PrintItem::Type::Tab) {
                if (item.tab_expr->type != ExprType::Number) {
                    error(stmt.loc, "TAB argument must be a number");
                }
            }
        }
    }

    void leave(RunStmt& stmt) override {
        if (stmt.target_expr) {
            if (stmt.target_expr->type != ExprType::Number) {
                error(stmt.loc, "RUN expression must be a number");
            }
        }
    }

    void leave(ListStmt& stmt) override {
        if (stmt.target_expr) {
            if (stmt.target_expr->type != ExprType::Number) {
                error(stmt.loc, "LIST expression must be a number");
            }
        }
    }

    void leave(LoadStmt& stmt) override {
        if (stmt.filename_expr->type != ExprType::String) {
            error(stmt.loc, "LOAD expression must be a string");
        }
    }

    void leave(SaveStmt& stmt) override {
        if (stmt.filename_expr->type != ExprType::String) {
            error(stmt.loc, "SAVE expression must be a string");
        }
    }

    void leave(PokeStmt& stmt) override {
        if (stmt.address_expr->type != ExprType::Number) {
            error(stmt.loc, "POKE expression must be a number");
        }
        if (stmt.value_expr->type != ExprType::Number) {
            error(stmt.loc, "POKE expression must be a number");
        }
    }

    void leave(PokewStmt& stmt) override {
        if (stmt.address_expr->type != ExprType::Number) {
            error(stmt.loc, "POKEW expression must be a number");
        }
        if (stmt.value_expr->type != ExprType::Number) {
            error(stmt.loc, "POKEW expression must be a number");
        }
    }

    void leave(PlotStmt& stmt) override {
        if (stmt.x_expr->type != ExprType::Number) {
            error(stmt.loc, "PLOT expression must be a number");
        }
        if (stmt.y_expr->type != ExprType::Number) {
            error(stmt.loc, "PLOT expression must be a number");
        }
    }

    void leave(UnplotStmt& stmt) override {
        if (stmt.x_expr->type != ExprType::Number) {
            error(stmt.loc, "UNPLOT expression must be a number");
        }
        if (stmt.y_expr->type != ExprType::Number) {
            error(stmt.loc, "UNPLOT expression must be a number");
        }
    }

    void leave(RandStmt& stmt) override {
        if (stmt.seed_expr->type != ExprType::Number) {
            error(stmt.loc, "RAND expression must be a number");
        }
    }

    void leave(PauseStmt& stmt) override {
        if (stmt.duration_expr->type != ExprType::Number) {
            error(stmt.loc, "PAUSE expression must be a number");
        }
    }
};

bool semantic_check(Prog& prog) {
    // check for recursion in FN and PROC
    RecursionDetector detector;
    prog.accept(detector);

    // check expression type of all expressions and statements
    ExprTypeChecker checker;
    prog.accept(checker);

    return get_error_count() == 0;
}
