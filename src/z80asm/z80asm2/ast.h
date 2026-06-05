//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_tokens.h"
#include "source_loc.h"
#include "string_interner.h"
#include <cstdint>
#include <iostream>
#include <memory>
#include <string_view>
#include <utility>
#include <vector>

// helper for dumping AST in a readable format
struct DumpContext {
    std::ostream& os;
    int indent{0};

    DumpContext(std::ostream& os_, int indent_ = 0);
    void line(std::string_view text);
    DumpContext child() const;
};

// base class for all AST nodes
struct AstNode {
    virtual ~AstNode() = default;
    virtual void dump(DumpContext ctx) const = 0;
};

// base class for all expressions
struct Expr : AstNode {
    SourceLoc loc;
    explicit Expr(const SourceLoc& loc_) : loc(loc_) {}
};

struct ExprLiteralInt : Expr {
    int value;
    ExprLiteralInt(int v, const SourceLoc& loc) : Expr(loc), value(v) {}
    void dump(DumpContext ctx) const override;
};

struct ExprLiteralFloat : Expr {
    double value;
    ExprLiteralFloat(double v, const SourceLoc& loc) : Expr(loc), value(v) {}
    void dump(DumpContext ctx) const override;
};

struct ExprLiteralAsmpc : Expr {
    ExprLiteralAsmpc(const SourceLoc& loc) : Expr(loc) {}
    void dump(DumpContext ctx) const override;
};

struct ExprSymbol : Expr {
    StringInterner::Id name_id;
    ExprSymbol(StringInterner::Id name_id_, const SourceLoc& loc) : Expr(loc),
        name_id(name_id_) {}
    void dump(DumpContext ctx) const override;
};

struct ExprLocalLabel : Expr {
    StringInterner::Id name_id;
    size_t at_pos;  // position of '@' in the original identifier
    ExprLocalLabel(StringInterner::Id name_id_, size_t at_pos_,
                   const SourceLoc& loc)
        : Expr(loc), name_id(name_id_), at_pos(at_pos_) {}
    void dump(DumpContext ctx) const override;
};

struct ExprUnary : Expr {
    TokenType op;
    std::unique_ptr<Expr> rhs;
    ExprUnary(TokenType op_, std::unique_ptr<Expr> rhs_, const SourceLoc& loc)
        : Expr(loc), op(op_), rhs(std::move(rhs_)) {}
    void dump(DumpContext ctx) const override;
};

struct ExprBinary : Expr {
    TokenType op;
    std::unique_ptr<Expr> lhs, rhs;
    ExprBinary(TokenType op_, std::unique_ptr<Expr> lhs_,
               std::unique_ptr<Expr> rhs_,
               const SourceLoc& loc)
        : Expr(loc), op(op_), lhs(std::move(lhs_)), rhs(std::move(rhs_)) {}
    void dump(DumpContext ctx) const override;
};

struct ExprTernary : Expr {
    std::unique_ptr<Expr> cond, then_expr, else_expr;
    ExprTernary(std::unique_ptr<Expr> c, std::unique_ptr<Expr> t,
                std::unique_ptr<Expr> e,
                const SourceLoc& loc)
        : Expr(loc), cond(std::move(c)), then_expr(std::move(t)),
          else_expr(std::move(e)) {}
    void dump(DumpContext ctx) const override;
};

struct ExprCallUnary : Expr {
    Keyword keyword;
    std::unique_ptr<Expr> arg;
    ExprCallUnary(Keyword keyword_, std::unique_ptr<Expr> arg_,
                  const SourceLoc& loc)
        : Expr(loc), keyword(keyword_), arg(std::move(arg_)) {}
    void dump(DumpContext ctx) const override;
};

// check range of contant expression
enum class CheckRange : uint8_t {
    Is_any,
    Is_0,
    Is_0_1_2,
    Is_0_1_2_3,
    Is_0_1_2_3_4_5_6_7,
    Is_1_2_3_4_5_6_7_0_8_10_18_20_28_30_38,
    Is_2_3_4_5_7_10_18_20_28_38,
    Is_1_2_4,
    Is_1_2_4_8,
    Is_40,
    Is_8,
};

// formula for constant expression patching in opcodes
enum class ExprFormula : uint8_t {
    None,                           // no patching needed
    ScaleBelowThreshold,            // A+(%c<8?%c*8:%c), followed by A
    AddScaled,                      // A+B*%c, followed by A, B
    SelectOrAdd,                    // %c==A?B:C+%c, followed by A, B, C
    Select2,                        // %c==A?B:%c==C?D:E, followed by A, B, C, D, E
    Select3,                        // %c==A?B:%c==C?D:%c==E?F:G, followed by A, B, C, D, E, F, G
};

// type of patch
enum class PatchType : uint8_t {
    Unsigned,                       // unsigned, default
    Signed,                         // signed
    HighByte,                       // ldh a, (%h) of gbz80
    BigEndian,                      // push %M of z80n
    PCrelative,                     // JR or JRE
};

// class for patches
struct Patch : Expr {
    virtual ~Patch();

    std::unique_ptr<Expr> inner;    // inner expression
    uint8_t offset = 0;             // offset into opcode
    uint8_t size = 0;               // byte width of expression

    bool is_constant = false;       // true for %c patches, e.g. IM %c or BIT %c, r

    PatchType type = PatchType::Unsigned;       // type of patch
    CheckRange validation =
        CheckRange::Is_any; // validation rule for constant expressions
    ExprFormula formula = ExprFormula::None;    // formula constant expressions
    std::vector<uint8_t> coefs;                 // coeficients for formula A..G

    uint8_t alt_offset = 0;         // alternative offset of long jump
    uint8_t alt_size = 0;           // alternative size of long jump
    std::vector<uint8_t> alt_bytes; // alternative opcode of long jump

    Patch(std::unique_ptr<Expr> expr, const SourceLoc& loc)
        : Expr(loc), inner(std::move(expr)) {}
    void dump(DumpContext ctx) const override;
};

// base class for all statements
struct Stmt : AstNode {
    SourceLoc loc;

    explicit Stmt(const SourceLoc& loc_) : loc(loc_) {}
    virtual ~Stmt() = default;
    void dump(DumpContext ctx) const override;
};

struct OpcodeStmt : Stmt {
    uint32_t address = 0;           // defined after layout
    bool is_short_jump = false;     // true if patches has a short jump

    std::vector<uint8_t>
    bytes;     // opcode bytes, including placeholders for expressions
    std::vector<std::unique_ptr<Patch>> patches;    // instruction patches

    OpcodeStmt(const SourceLoc& loc) : Stmt(loc) {}
    void dump(DumpContext ctx) const override;
};

struct LabelStmt : Stmt {
    StringInterner::Id text_id;
    bool is_local = false;  // whether this is a local label (has '@')
    size_t at_pos = 0;      // position of '@' in the original identifier, if local

    LabelStmt(StringInterner::Id text_id_, const SourceLoc& loc_);
    virtual ~LabelStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct OrgStmt : Stmt {
    std::unique_ptr<Expr> expr;

    OrgStmt(const SourceLoc& loc, std::unique_ptr<Expr> e)
        : Stmt(loc), expr(std::move(e)) {}
    virtual ~OrgStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct DefcStmt : Stmt {
    StringInterner::Id name_id;
    std::unique_ptr<Expr> expr;

    DefcStmt(const SourceLoc& loc, StringInterner::Id name_id_,
             std::unique_ptr<Expr> e)
        : Stmt(loc), name_id(name_id_), expr(std::move(e)) {}
    virtual ~DefcStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct ExternStmt : Stmt {
    std::vector<StringInterner::Id> name_ids;
    ExternStmt(const SourceLoc& loc, std::vector<StringInterner::Id> n)
        : Stmt(loc), name_ids(std::move(n)) {}

    virtual ~ExternStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct PublicStmt : Stmt {
    std::vector<StringInterner::Id> name_ids;
    PublicStmt(const SourceLoc& loc, std::vector<StringInterner::Id> n)
        : Stmt(loc), name_ids(std::move(n)) {}

    virtual ~PublicStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct GlobalStmt : Stmt {
    std::vector<StringInterner::Id> name_ids;
    GlobalStmt(const SourceLoc& loc, std::vector<StringInterner::Id> n)
        : Stmt(loc), name_ids(std::move(n)) {}

    virtual ~GlobalStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct ModuleStmt : Stmt {
    StringInterner::Id name_id;

    ModuleStmt(const SourceLoc& loc, StringInterner::Id name_id_)
        : Stmt(loc), name_id(name_id_) {}
    virtual ~ModuleStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct SectionStmt : Stmt {
    StringInterner::Id name_id;

    SectionStmt(const SourceLoc& loc, StringInterner::Id name_id_)
        : Stmt(loc), name_id(name_id_) {}
    virtual ~SectionStmt() = default;
    void dump(DumpContext ctx) const override;
};

// root of the AST
struct Program : AstNode {
    std::vector<std::unique_ptr<Stmt>> stmts;

    virtual ~Program() = default;
    void dump(DumpContext ctx) const override;
};

[[noreturn]] void dump_ast_and_exit(const std::unique_ptr<Program>& prog);
