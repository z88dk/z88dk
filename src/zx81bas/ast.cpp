//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "ast_expr.h"
#include "ast_stmt.h"
#include <algorithm>
#include <memory>
#include <vector>

bool is_string_variable(const std::string& name) {
    return !name.empty() && name.back() == '$';
}

template<typename T>
void erase_marked(std::vector<std::unique_ptr<T>>& vec) {
    vec.erase(
        std::remove_if(vec.begin(), vec.end(),
    [](auto & ptr) {
        return ptr->mark_for_removal;
    }),
    vec.end()
    );
}

void ASTWalker::visit(LetStmt& s) {
    s.lhs->accept(*this);
    s.rhs->accept(*this);
}

void ASTWalker::visit(DimStmt& s) {
    for (auto& item : s.items) {
        for (auto& dim : item.dims) {
            dim->accept(*this);
        }
    }
}

void ASTWalker::visit(IfStmt& s) {
    enter(s);

    s.condition->accept(*this);

    for (auto& st : s.then_stmts) {
        st->accept(*this);
    }
    erase_marked(s.then_stmts);

    for (auto& st : s.else_stmts) {
        st->accept(*this);
    }
    erase_marked(s.else_stmts);

    leave(s);
}

void ASTWalker::visit(RepeatStmt& s) {
    enter(s);

    for (auto& st : s.body) {
        st->accept(*this);
    }
    erase_marked(s.body);

    s.condition->accept(*this);

    leave(s);
}

void ASTWalker::visit(WhileStmt& s) {
    enter(s);

    s.condition->accept(*this);

    for (auto& st : s.body) {
        st->accept(*this);
    }
    erase_marked(s.body);

    leave(s);
}

void ASTWalker::visit(ForStmt& s) {
    enter(s);

    s.start_expr->accept(*this);
    s.end_expr->accept(*this);
    s.step_expr->accept(*this);

    for (auto& st : s.body) {
        st->accept(*this);
    }
    erase_marked(s.body);

    leave(s);
}

void ASTWalker::visit(DefProcStmt& s) {
    enter(s);
    for (auto& st : s.body) {
        st->accept(*this);
    }
    erase_marked(s.body);
    leave(s);
}

void ASTWalker::visit(ProcCallStmt& s) {
    for (auto& arg : s.args) {
        arg->accept(*this);
    }
}

void ASTWalker::visit(DefFnStmt& s) {
    enter(s);
    s.expr->accept(*this);
    leave(s);
}

void ASTWalker::visit(GotoStmt& s) {
    s.target_expr->accept(*this);
}

void ASTWalker::visit(GosubStmt& s) {
    s.target_expr->accept(*this);
}

void ASTWalker::visit(PrintStmt& s) {
    for (auto& item : s.items) {
        switch (item.type) {
        case PrintItem::Type::Expr:
            item.expr->accept(*this);
            break;
        case PrintItem::Type::At:
            item.line_expr->accept(*this);
            item.col_expr->accept(*this);
            break;
        case PrintItem::Type::Tab:
            item.tab_expr->accept(*this);
            break;
        default:
            ;
        }
    }
}

void ASTWalker::visit(InputStmt& s) {
    for (auto& var : s.vars) {
        var->accept(*this);
    }
}

void ASTWalker::visit(RunStmt& s) {
    if (s.target_expr) {
        s.target_expr->accept(*this);
    }
}

void ASTWalker::visit(ListStmt& s) {
    if (s.target_expr) {
        s.target_expr->accept(*this);
    }
}

void ASTWalker::visit(LoadStmt& s) {
    s.filename_expr->accept(*this);
}

void ASTWalker::visit(SaveStmt& s) {
    s.filename_expr->accept(*this);
}

void ASTWalker::visit(PokeStmt& s) {
    s.address_expr->accept(*this);
    s.value_expr->accept(*this);
}

void ASTWalker::visit(PokewStmt& s) {
    s.address_expr->accept(*this);
    s.value_expr->accept(*this);
}

void ASTWalker::visit(PlotStmt& s) {
    s.x_expr->accept(*this);
    s.y_expr->accept(*this);
}

void ASTWalker::visit(UnplotStmt& s) {
    s.x_expr->accept(*this);
    s.y_expr->accept(*this);
}

void ASTWalker::visit(RandStmt& s) {
    s.seed_expr->accept(*this);
}

void ASTWalker::visit(PauseStmt& s) {
    s.duration_expr->accept(*this);
}

void ASTWalker::visit(ArrayRefExpr& e) {
    enter(e);
    for (auto& i : e.indices) {
        i->accept(*this);
    }
    leave(e);
}

void ASTWalker::visit(SliceExpr& e) {
    enter(e);
    e.base->accept(*this);
    if (e.from) {
        e.from->accept(*this);
    }
    if (e.to) {
        e.to->accept(*this);
    }
    leave(e);
}

void ASTWalker::visit(UnaryExpr& e) {
    enter(e);
    e.operand->accept(*this);
    leave(e);
}

void ASTWalker::visit(BinaryExpr& e) {
    enter(e);
    e.lhs->accept(*this);
    e.rhs->accept(*this);
    leave(e);
}

void ASTWalker::visit(BasicFuncCallExpr& e) {
    enter(e);
    for (auto& arg : e.args) {
        arg->accept(*this);
    }
    leave(e);
}

void ASTWalker::visit(ProcCallExpr& e) {
    enter(e);
    for (auto& arg : e.args) {
        arg->accept(*this);
    }
    leave(e);
}

void ASTWalker::visit(FnCallExpr& e) {
    enter(e);
    for (auto& arg : e.args) {
        arg->accept(*this);
    }
    leave(e);
}

void Prog::accept(ASTVisitor& v) {
    for (auto& st : stmts) {
        st->accept(v);
    }
    erase_marked(stmts);
}
