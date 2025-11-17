//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// HLA code generation: emit branch-if-false (BIF) for boolean expressions
// Supports nested boolean expressions composed of:
//   - Comparisons (operand relop operand)
//   - Flag tests (Z, NZ, C, NC, PO, PE, P, M)
//   - Logical NOT / AND / OR with short-circuit semantics
// Generates code that jumps to false_label when the expression evaluates false.
//-----------------------------------------------------------------------------

#include "hla_codegen.h"
#include "keywords.h"
#include <stdexcept>
#include <functional>

namespace hla {

// Helper: create a keyword token
static Token kw(Keyword k) {
    return Token(TokenType::Identifier, keyword_to_string(k), k);
}

// Helper: create integer token
static Token int_tok(int v) {
    return Token(TokenType::Integer, std::to_string(v), v);
}

// Helper: simple comma token
static Token comma_tok() {
    return Token(TokenType::Comma, ",");
}

// Make a new instruction line
static TokensLine make_line(const Location& loc,
                            const std::vector<Token>& toks) {
    TokensLine line(loc);
    line.reserve(toks.size());
    for (const auto& t : toks) {
        line.push_back(t);
    }
    return line;
}

// Emit operand tokens (for CP / LD source operand)
static void emit_operand_tokens(const Operand& op, std::vector<Token>& out) {
    switch (op.kind) {
    case Operand::Kind::Reg8:
        out.push_back(kw(op.reg));
        break;
    case Operand::Kind::Imm8:
        out.push_back(int_tok(op.imm));
        break;
    case Operand::Kind::MemHL:
        out.push_back(Token(TokenType::LeftParen, "("));
        out.push_back(kw(Keyword::HL));
        out.push_back(Token(TokenType::RightParen, ")"));
        break;
    case Operand::Kind::MemAbs:
        out.push_back(Token(TokenType::LeftParen, "("));
        out.push_back(int_tok(op.addr));
        out.push_back(Token(TokenType::RightParen, ")"));
        break;
    default:
        throw std::runtime_error("Unsupported operand kind");
    }
}

// Ensure A has lhs value (if not already)
static void emit_load_a(const Operand& lhs, const Location& loc,
                        std::deque<TokensLine>& out) {
    if (lhs.kind == Operand::Kind::Reg8 && lhs.reg == Keyword::A) {
        return; // already A
    }
    std::vector<Token> toks;
    toks.push_back(kw(Keyword::LD));
    toks.push_back(kw(Keyword::A));
    toks.push_back(comma_tok());
    emit_operand_tokens(lhs, toks);
    out.push_back(make_line(loc, toks));
}

// Emit CP rhs
static void emit_cp(const Operand& rhs, const Location& loc,
                    std::deque<TokensLine>& out) {
    std::vector<Token> toks;
    toks.push_back(kw(Keyword::CP));
    emit_operand_tokens(rhs, toks);
    out.push_back(make_line(loc, toks));
}

// Emit JP <cond>, label
static void emit_jp_cond(const Location& loc, Keyword cond,
                         const std::string& label, std::deque<TokensLine>& out) {
    TokensLine line(loc);
    line.push_back(kw(Keyword::JP));
    line.push_back(kw(cond));
    line.push_back(comma_tok());
    line.push_back(Token(TokenType::Identifier, label)); // label
    out.push_back(std::move(line));
}

// Invert a single-condition keyword (for flag tests)
static Keyword invert_cond(Keyword k) {
    switch (k) {
    case Keyword::Z:
        return Keyword::NZ;
    case Keyword::NZ:
        return Keyword::Z;
    case Keyword::C:
        return Keyword::NC;
    case Keyword::NC:
        return Keyword::C;
    case Keyword::PE:
        return Keyword::PO;
    case Keyword::PO:
        return Keyword::PE;
    case Keyword::P:
        return Keyword::M;
    case Keyword::M:
        return Keyword::P;
    default:
        throw std::runtime_error("Invalid condition keyword for inversion");
    }
}

// RelOp condition mapping.
// Returns list of condition codes that should cause a jump when (want_true).
static std::vector<Keyword> relop_conditions(RelOp op, bool want_true) {
    switch (op) {
    case RelOp::Eq:
        return { want_true ? Keyword::Z  : Keyword::NZ };
    case RelOp::Ne:
        return { want_true ? Keyword::NZ : Keyword::Z  };
    case RelOp::Lt:
        return { want_true ? Keyword::C  : Keyword::NC };
    case RelOp::Le:
        return want_true ? std::vector<Keyword> { Keyword::Z, Keyword::C }
               :
               std::vector<Keyword> { Keyword::NZ, Keyword::NC };
    case RelOp::Gt:
        return want_true ? std::vector<Keyword> { Keyword::NZ, Keyword::NC }
               :
               std::vector<Keyword> { Keyword::Z,  Keyword::C  };
    case RelOp::Ge:
        return { want_true ? Keyword::NC : Keyword::C };
    default:
        throw std::runtime_error("Unsupported relational operator");
    }
}

// Emit comparison branching (single evaluation of lhs/rhs)
static void emit_compare_branch(const Compare& cmp, bool branch_on_true,
                                const std::string& target_label,
                                const Location& loc,
                                std::deque<TokensLine>& out) {
    emit_load_a(cmp.lhs, loc, out);
    emit_cp(cmp.rhs, loc, out);
    for (Keyword cond : relop_conditions(cmp.op, branch_on_true)) {
        emit_jp_cond(loc, cond, target_label, out);
    }
}

// Public helper to emit a dot label definition.
void CodeGen::emit_label(const std::string& label, const Location& loc,
                         std::deque<TokensLine>& out) {
    TokensLine lbl(loc);
    lbl.push_back(Token(TokenType::Dot, "."));
    lbl.push_back(Token(TokenType::Identifier, label));
    out.push_back(std::move(lbl));
}

void CodeGen::emit_bif(const Expr& e, const std::string& false_label,
                       const Location& loc,
                       std::deque<TokensLine>& out) {
    // Recursive lambdas for branch-if-false (gen_false) and branch-if-true (gen_true)
    std::function<void(const Expr&, const std::string&)> gen_false;
    std::function<void(const Expr&, const std::string&)> gen_true;

    gen_true = [&](const Expr & ex, const std::string & tgt) {
        if (const Compare* cmp = dynamic_cast<const Compare*>(&ex)) {
            emit_compare_branch(*cmp, true, tgt, loc, out);
            return;
        }
        if (const FlagTest* ft = dynamic_cast<const FlagTest*>(&ex)) {
            // Jump when flag condition is true
            emit_jp_cond(loc, ft->cond, tgt, out);
            return;
        }
        if (const Not* n = dynamic_cast<const Not*>(&ex)) {
            // TRUE of !E == FALSE of E
            gen_false(*n->e, tgt);
            return;
        }
        if (const And* a = dynamic_cast<const And*>(&ex)) {
            // (L && R) true only if both true
            // If L false -> skip; if L true -> test R
            const std::string skip_label = "HLA_BOOL_" + std::to_string(
                                               counter_++) + "_AFTER_AND";
            gen_false(*a->l,
                      skip_label);      // if L false -> jump to skip_label (no true jump)
            gen_true(*a->r, tgt);              // if R true -> jump to target
            emit_label(skip_label, loc, out);
            return;
        }
        if (const Or* o = dynamic_cast<const Or*>(&ex)) {
            // (L || R) true if L true OR (L false and R true)
            gen_true(*o->l, tgt);              // if L true -> jump
            gen_true(*o->r, tgt);              // only executed if L false
            return;
        }
        throw std::runtime_error("Unsupported expression node in boolean (true branch)");
    };

    gen_false = [&](const Expr & ex, const std::string & tgt) {
        if (const Compare* cmp = dynamic_cast<const Compare*>(&ex)) {
            emit_compare_branch(*cmp, false, tgt, loc, out);
            return;
        }
        if (const FlagTest* ft = dynamic_cast<const FlagTest*>(&ex)) {
            // Jump when flag condition is false: invert the condition
            emit_jp_cond(loc, invert_cond(ft->cond), tgt, out);
            return;
        }
        if (const Not* n = dynamic_cast<const Not*>(&ex)) {
            // FALSE of !E == TRUE of E
            gen_true(*n->e, tgt);
            return;
        }
        if (const And* a = dynamic_cast<const And*>(&ex)) {
            // (L && R) false if L false OR (L true and R false)
            gen_false(*a->l, tgt);             // if L false -> jump
            gen_false(*a->r, tgt);             // executed only if L true
            return;
        }
        if (const Or* o = dynamic_cast<const Or*>(&ex)) {
            // (L || R) false only if both false
            // Need short-circuit: if L true skip evaluating R
            const std::string skip_label = "HLA_BOOL_" + std::to_string(
                                               counter_++) + "_OR_SKIP";
            gen_true(*o->l,
                     skip_label);       // if L true -> skip second operand (cannot be false)
            gen_false(*o->r, tgt);             // if R false -> jump (L was false)
            emit_label(skip_label, loc, out);
            return;
        }
        throw std::runtime_error("Unsupported expression node in boolean (false branch)");
    };

    // Entry: branch-if-false for full expression
    gen_false(e, false_label);
}

} // namespace hla
