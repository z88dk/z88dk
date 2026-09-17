//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "errors.h"
#include "release_assert.h"
#include "walker.h"
#include <memory>
#include <vector>

void ASTVisitor::walk_stmts(std::vector<StmtPtr>& list) {
    std::vector<StmtPtr> new_list;

    for (auto& stmt : list) {
        // Visit the node
        stmt_stack.push_back(stmt.get());
        stmt->accept(*this);
        stmt_stack.pop_back();

        // Prepend nodes requested by visitor
        for (auto& n : stmt->rewrite.prepend) {
            new_list.push_back(std::move(n));
        }
        stmt->rewrite.prepend.clear();

        // if marked for removal, skip adding the node to the new list
        if (stmt->rewrite.remove) {
            release_assert(stmt->rewrite.append.empty());
            continue;
        }
        new_list.push_back(std::move(stmt));

        // Append nodes requested by visitor, only if not marked for removal
        for (auto& n : new_list.back()->rewrite.append) {
            new_list.push_back(std::move(n));
        }
        new_list.back()->rewrite.append.clear();
    }

    list = std::move(new_list);
}

void ASTVisitor::walk_expr(ExprPtr& expr) {
    if (expr) {
        expr->accept(*this);
        if (expr->rewrite.replace_expr) {
            expr = std::move(expr->rewrite.replace_expr);
            expr->rewrite.replace_expr = nullptr;
        }
    }
}

bool ASTVisitor::enter(NumberExpr&) {
    return true;
}

bool ASTVisitor::enter(LabelLineRefExpr&) {
    return true;
}

bool ASTVisitor::enter(LabelAddrRefExpr&) {
    return true;
}

bool ASTVisitor::enter(StringLiteralExpr&) {
    return true;
}

bool ASTVisitor::enter(VariableExpr&) {
    return true;
}

bool ASTVisitor::enter(ArrayRefExpr&) {
    return true;
}

bool ASTVisitor::enter(SliceExpr&) {
    return true;
}

bool ASTVisitor::enter(UnaryExpr&) {
    return true;
}

bool ASTVisitor::enter(BinaryExpr&) {
    return true;
}

bool ASTVisitor::enter(BasicFuncCallExpr&) {
    return true;
}

bool ASTVisitor::enter(ProcCallExpr&) {
    return true;
}

bool ASTVisitor::enter(FnCallExpr&) {
    return true;
}

bool ASTVisitor::enter(LabelStmt&) {
    return true;
}

bool ASTVisitor::enter(LineNumStmt&) {
    return true;
}

bool ASTVisitor::enter(LetStmt&) {
    return true;
}

bool ASTVisitor::enter(DimStmt&) {
    return true;
}

bool ASTVisitor::enter(IfStmt&) {
    return true;
}

bool ASTVisitor::enter(RepeatStmt&) {
    return true;
}

bool ASTVisitor::enter(WhileStmt&) {
    return true;
}

bool ASTVisitor::enter(ForStmt&) {
    return true;
}

bool ASTVisitor::enter(NextStmt&) {
    return true;
}

bool ASTVisitor::enter(DefProcStmt&) {
    return true;
}

bool ASTVisitor::enter(ProcCallStmt&) {
    return true;
}

bool ASTVisitor::enter(LocalStmt&) {
    return true;
}

bool ASTVisitor::enter(DefFnStmt&) {
    return true;
}

bool ASTVisitor::enter(ExitStmt&) {
    return true;
}

bool ASTVisitor::enter(GotoStmt&) {
    return true;
}

bool ASTVisitor::enter(GosubStmt&) {
    return true;
}

bool ASTVisitor::enter(ReturnStmt&) {
    return true;
}

bool ASTVisitor::enter(StopStmt&) {
    return true;
}

bool ASTVisitor::enter(EndStmt&) {
    return true;
}

bool ASTVisitor::enter(PrintStmt&) {
    return true;
}

bool ASTVisitor::enter(LPrintStmt&) {
    return true;
}

bool ASTVisitor::enter(InputStmt&) {
    return true;
}

bool ASTVisitor::enter(RemStmt&) {
    return true;
}

bool ASTVisitor::enter(RunStmt&) {
    return true;
}

bool ASTVisitor::enter(ListStmt&) {
    return true;
}

bool ASTVisitor::enter(LListStmt&) {
    return true;
}

bool ASTVisitor::enter(NewStmt&) {
    return true;
}

bool ASTVisitor::enter(ClsStmt&) {
    return true;
}

bool ASTVisitor::enter(LoadStmt&) {
    return true;
}

bool ASTVisitor::enter(SaveStmt&) {
    return true;
}

bool ASTVisitor::enter(PokeStmt&) {
    return true;
}

bool ASTVisitor::enter(PokewStmt&) {
    return true;
}

bool ASTVisitor::enter(PlotStmt&) {
    return true;
}

bool ASTVisitor::enter(UnplotStmt&) {
    return true;
}

bool ASTVisitor::enter(RandStmt&) {
    return true;
}

bool ASTVisitor::enter(PauseStmt&) {
    return true;
}

bool ASTVisitor::enter(FastStmt&) {
    return true;
}

bool ASTVisitor::enter(SlowStmt&) {
    return true;
}

bool ASTVisitor::enter(ScrollStmt&) {
    return true;
}

bool ASTVisitor::enter(ContStmt&) {
    return true;
}

bool ASTVisitor::enter(ClearStmt&) {
    return true;
}

bool ASTVisitor::enter(CopyStmt&) {
    return false;
}

bool ASTVisitor::enter(PragmaNumVarStmt&) {
    return true;
}

bool ASTVisitor::enter(PragmaStrVarStmt&) {
    return true;
}

bool ASTVisitor::enter(PragmaNumVarArrayStmt&) {
    return true;
}

bool ASTVisitor::enter(PragmaStrVarArrayStmt&) {
    return true;
}

bool ASTVisitor::enter(Prog&) {
    return true;
}

// Replace all variables A by expression arg_values[A]
struct ReplaceArgValuesVisitor : ASTVisitor {
    const std::unordered_map<std::string, Expr*> arg_values;

    explicit ReplaceArgValuesVisitor(
        const std::unordered_map<std::string, Expr*>& av)
        : arg_values(av) {}
    virtual ~ReplaceArgValuesVisitor() = default;

    void visit(VariableExpr& expr) {
        auto it = arg_values.find(expr.name);
        if (it != arg_values.end()) {
            expr.rewrite.replace_expr = it->second->clone();
        }
    }
};

static void replace_arg_values(ExprPtr& expr,
                               const std::unordered_map<std::string, Expr*>& arg_values) {
    ReplaceArgValuesVisitor visitor(arg_values);
    visitor.walk_expr(expr);
}

// expand PEEKW, POKEW
struct LowerPeekwPokewVisitor : ASTVisitor {
    virtual ~LowerPeekwPokewVisitor() = default;

    // expand PEEKW
    void visit(BasicFuncCallExpr& expr) override {
        if (expr.keyword == Keyword::PEEKW) {
            // PEEKW(a) -> PEEK(a) + 256 * PEEK(a + 1)
            release_assert(expr.args.size() == 1);

            // PEEK(a)
            auto& arg = expr.args[0];
            auto peek_a = make_node<BasicFuncCallExpr>(Keyword::PEEK, expr.loc);
            peek_a->args.push_back(arg->clone());

            // PEEK(a + 1)
            auto arg_plus_1 = make_node<BinaryExpr>(TokenType::Plus,
                                                    arg->clone(),
                                                    make_node<NumberExpr>(1, expr.loc),
                                                    expr.loc);
            auto peek_a_plus_1 = make_node<BasicFuncCallExpr>(Keyword::PEEK,
                                 expr.loc);
            peek_a_plus_1->args.push_back(std::move(arg_plus_1));

            // 256 * PEEK(a + 1)
            auto mult_expr = make_node<BinaryExpr>(TokenType::Multiply,
                                                   make_node<NumberExpr>(256, expr.loc),
                                                   std::move(peek_a_plus_1),
                                                   expr.loc);

            // PEEK(a) + 256 * PEEK(a + 1)
            auto add_expr = make_node<BinaryExpr>(TokenType::Plus,
                                                  std::move(peek_a),
                                                  std::move(mult_expr),
                                                  expr.loc);

            // replace the original expression with the new expression
            expr.rewrite.replace_expr = std::move(add_expr);
        }
    }

    // expand POKEW
    void visit(PokewStmt& stmt) override {
        // POKEW(a, v) -> POKE(a, v MOD 256) : POKE(a + 1, v DIV 256)

        // POKE(a, v MOD 256)
        auto v_mod_256 = make_node<BinaryExpr>(TokenType::MOD,
                                               stmt.value_expr->clone(),
                                               make_node<NumberExpr>(256, stmt.loc),
                                               stmt.loc);
        auto poke_a = std::make_unique<PokeStmt>(stmt.address_expr->clone(),
                      std::move(v_mod_256),
                      stmt.loc);
        stmt.rewrite.prepend.push_back(std::move(poke_a));

        // POKE(a + 1, v DIV 256)
        auto a_plus_1 = make_node<BinaryExpr>(TokenType::Plus,
                                              stmt.address_expr->clone(),
                                              make_node<NumberExpr>(1, stmt.loc),
                                              stmt.loc);
        auto v_div_256 = make_node<BinaryExpr>(TokenType::IntDivide,
                                               stmt.value_expr->clone(),
                                               make_node<NumberExpr>(256, stmt.loc),
                                               stmt.loc);
        auto poke_a_plus_1 = std::make_unique<PokeStmt>(std::move(a_plus_1),
                             std::move(v_div_256),
                             stmt.loc);
        stmt.rewrite.prepend.push_back(std::move(poke_a_plus_1));

        stmt.rewrite.remove = true;
    }
};

static void transform_peekw_pokew(Prog& prog, Symtab&) {
    LowerPeekwPokewVisitor visitor;
    prog.accept(visitor);
}

// expand MOD/DIV
struct LowerDivModVisitor : ASTVisitor {
    virtual ~LowerDivModVisitor() = default;

    // expand IntDivide
    // expand MOD
    void visit(BinaryExpr& expr) override {
        if (expr.op == TokenType::IntDivide) {
            // a DIV b -> INT(a / b)
            auto div_expr = make_node<BinaryExpr>(TokenType::Divide,
                                                  expr.lhs->clone(),
                                                  expr.rhs->clone(),
                                                  expr.loc);
            auto int_expr = make_node<BasicFuncCallExpr>(Keyword::INT,
                            expr.loc);
            int_expr->args.push_back(std::move(div_expr));
            expr.rewrite.replace_expr = std::move(int_expr);
        }
        else if (expr.op == TokenType::MOD) {
            // a MOD b -> a - b * INT(a / b)
            auto div_expr = make_node<BinaryExpr>(TokenType::Divide,
                                                  expr.lhs->clone(),
                                                  expr.rhs->clone(),
                                                  expr.loc);
            auto int_expr = make_node<BasicFuncCallExpr>(Keyword::INT,
                            expr.loc);
            int_expr->args.push_back(std::move(div_expr));
            auto mult_expr = make_node<BinaryExpr>(TokenType::Multiply,
                                                   expr.rhs->clone(),
                                                   std::move(int_expr),
                                                   expr.loc);
            auto sub_expr = make_node<BinaryExpr>(TokenType::Minus,
                                                  expr.lhs->clone(),
                                                  std::move(mult_expr),
                                                  expr.loc);
            expr.rewrite.replace_expr = std::move(sub_expr);
        }
    }
};

static void transform_div_mod(Prog& prog, Symtab&) {
    LowerDivModVisitor visitor;
    prog.accept(visitor);
}

// expand DEF FN calls - replace call expression by FN defintion
struct LowerDefFnCallVisitor : ASTVisitor {
    Symtab& symtab;

    explicit LowerDefFnCallVisitor(Symtab& s) : symtab(s) {}
    virtual ~LowerDefFnCallVisitor() = default;

    void visit(FnCallExpr& expr) override {
        // get function definition; already checked existence in semantic phase
        auto it = symtab.fns.find(expr.name);
        release_assert(it != symtab.fns.end());
        auto& deffn = it->second;

        // parameter and argument count already checked in semantic phase
        release_assert(expr.args.size() == deffn->params.size());

        // define map of parameter name to replacement expression
        // duplicate parameters already checked in semantic pass
        std::unordered_map<std::string, Expr*> arg_values;
        for (size_t i = 0; i < expr.args.size(); i++) {
            std::string& param_name = deffn->params[i];
            Expr* param_value = expr.args[i].get();
            arg_values[param_name] = param_value;
        }

        // get deffn replacement expression
        auto replacement = deffn->expr->clone();

        // rewrite expression replacing arg_values
        replace_arg_values(replacement, arg_values);

        // replace the DEF FN call by the changed replacement expression
        expr.rewrite.replace_expr = std::move(replacement);
    }
};

static void transform_def_fn_calls(Prog& prog, Symtab& symtab) {
    LowerDefFnCallVisitor visitor(symtab);
    prog.accept(visitor);
}

bool semantic_transform(Prog& prog, Symtab& symtab) {
    transform_peekw_pokew(prog, symtab);
    transform_div_mod(prog, symtab);
    transform_def_fn_calls(prog, symtab);
    return get_error_count() == 0;
}
