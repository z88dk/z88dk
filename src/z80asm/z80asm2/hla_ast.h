//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "source_loc.h"
#include <memory>
#include <string>
#include <vector>

class HLA_Label {
public:
    HLA_Label();
    HLA_Label(int id_);
    std::string to_string() const;
    bool is_valid() const;

private:
    int id;
    static int count;
};

static const HLA_Label NoLabel{ -1 };

struct HLA_Node {
    Keyword kw = Keyword::None; // HLA keyword
    SourceLoc loc;              // location of the HLA keyword

    virtual ~HLA_Node() = default;

    virtual bool is_loop() const {
        return false;
    }
    virtual bool is_if() const {
        return false;
    }
    virtual bool is_while() const {
        return false;
    }
    virtual bool is_repeat() const {
        return false;
    }
};

struct HLA_Expr {
    SourceLoc loc;
    virtual ~HLA_Expr() = default;
};

// Comparison: A < B, A >= 5, etc.
struct HLA_CompareExpr : HLA_Expr {
    enum class Type {
        UnsignedLT,     // <
        UnsignedLE,     // <=
        UnsignedGT,     // >
        UnsignedGE,     // >=
        SignedLT,       // s<
        SignedLE,       // s<=
        SignedGT,       // s>
        SignedGE,       // s>=
        EQ,             // == | =
        NE,             // != | <>
    };
    std::vector<Token> left;    // expression
    Type op;                    // operation
    std::vector<Token> right;   // expression
};

// Direct flag tests: Z, NZ, C, NC, etc.
struct HLA_FlagExpr : HLA_Expr {
    Token flag_token;
};

// Forever expressions
struct HLA_True : HLA_Expr {};
struct HLA_False : HLA_Expr {};

// Boolean NOT
struct HLA_NotExpr : HLA_Expr {
    std::unique_ptr<HLA_Expr> child;
};

// Boolean AND
struct HLA_AndExpr : HLA_Expr {
    std::unique_ptr<HLA_Expr> left;
    std::unique_ptr<HLA_Expr> right;
};

// Boolean OR
struct HLA_OrExpr : HLA_Expr {
    std::unique_ptr<HLA_Expr> left;
    std::unique_ptr<HLA_Expr> right;
};

struct HLA_Asm : HLA_Node {
    LogicalLine line;   // original line from preprocessor
};

struct HLA_If : HLA_Node {
    struct Branch {
        SourceLoc loc;
        std::unique_ptr<HLA_Expr> condition;   // null for ELSE
        bool is_always_true = false;  // true if condition is always true (after folding)
        bool is_always_false = false; // true if condition is always false (after folding)
        std::vector<std::unique_ptr<HLA_Node>> body;
        HLA_Label next_label;
    };

    std::vector<Branch> branches;  // IF + zero or more ELSEIFs
    std::vector<std::unique_ptr<HLA_Node>> else_body; // empty if no ELSE
    bool found_else = false;  // true if ELSE branch is present
    SourceLoc else_loc;
    HLA_Label end_label;

    bool is_if() const override {
        return true;
    }
};

struct HLA_Loop : HLA_Node {
    HLA_Label top_label;
    HLA_Label break_label;
    bool is_forever = false; // true if loop runs forever (after folding)
    std::vector<std::unique_ptr<HLA_Node>> body;

    bool is_loop() const override {
        return true;
    }
};

struct HLA_While : HLA_Loop {
    std::unique_ptr<HLA_Expr> condition;
    bool never_runs = false; // true if condition is always false (after folding)

    bool is_while() const override {
        return true;
    }
};

enum class RepeatType {
    UntilExpr,   // REPEAT ... UNTIL <expr>
    DjnzReg      // REPEAT ... DJNZ <reg>
};

struct HLA_Repeat : HLA_Loop {
    RepeatType type = RepeatType::UntilExpr;  // default
    std::unique_ptr<HLA_Expr> condition;      // only for UntilExpr
    bool runs_only_once = false; // true if condition is always true (after folding)
    Keyword reg_kw = Keyword::None;           // only for DjnzReg

    bool is_repeat() const override {
        return true;
    }
};

struct HLA_Break : HLA_Node {
    std::unique_ptr<HLA_Expr> condition;  // nullptr for unconditional break
};

struct HLA_Continue : HLA_Node {
    std::unique_ptr<HLA_Expr> condition;  // nullptr for unconditional continue
};

struct HLA_Program {
    std::vector<std::unique_ptr<HLA_Node>> nodes;
};

