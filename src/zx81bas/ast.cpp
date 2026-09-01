//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "ast.h"
#include "ast_stmt.h"

bool is_string_variable(const std::string& name) {
    return !name.empty() && name.back() == '$';
}

void ASTWalker::visit(IfStmt& s) {
    enter(s);
    for (auto& st : s.then_stmts) {
        st->accept(*this);
    }
    for (auto& st : s.else_stmts) {
        st->accept(*this);
    }
    leave(s);
}

void ASTWalker::visit(RepeatStmt& s) {
    enter(s);
    for (auto& st : s.body) {
        st->accept(*this);
    }
    leave(s);
}

void ASTWalker::visit(WhileStmt& s) {
    enter(s);
    for (auto& st : s.body) {
        st->accept(*this);
    }
    leave(s);
}

void ASTWalker::visit(ForStmt& s) {
    enter(s);
    for (auto& st : s.body) {
        st->accept(*this);
    }
    leave(s);
}

void ASTWalker::visit(DefProcStmt& s) {
    enter(s);
    for (auto& st : s.body) {
        st->accept(*this);
    }
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
