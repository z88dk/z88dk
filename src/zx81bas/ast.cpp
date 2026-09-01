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

void ASTWalker::visit(IfStmt& s) {
    enter(s);
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
    leave(s);
}

void ASTWalker::visit(WhileStmt& s) {
    enter(s);
    for (auto& st : s.body) {
        st->accept(*this);
    }
    erase_marked(s.body);
    leave(s);
}

void ASTWalker::visit(ForStmt& s) {
    enter(s);
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

std::unique_ptr<Prog> Prog::clone() const {
    auto p = std::make_unique<Prog>();
    p->auto_start = auto_start;
    p->auto_start_line = auto_start_line;
    p->auto_start_label = auto_start_label;
    p->increment = increment;
    p->rem_invert = rem_invert;
    p->fast_mode = fast_mode;
    p->dfile_lines = dfile_lines;
    p->dfile_colapsed = dfile_colapsed;
    p->sysvars_data = sysvars_data;

    for (auto& st : stmts) {
        p->stmts.push_back(st->clone());
    }
    for (auto& st : vars) {
        p->vars.push_back(st->clone());
    }
    for (auto& [name, proc] : procs) {
        auto cloned = proc->clone();
        p->procs[name] = std::unique_ptr<DefProcStmt>(
                             static_cast<DefProcStmt*>(cloned.release()));
    }
    for (auto& [name, fn] : fns) {
        auto cloned = fn->clone();
        p->fns[name] = std::unique_ptr<DefFnStmt>(
                           static_cast<DefFnStmt*>(cloned.release()));
    }
    return p;
}

void Prog::accept(ASTVisitor& v) {
    for (auto& st : stmts) {
        st->accept(v);
    }
    erase_marked(stmts);
}
