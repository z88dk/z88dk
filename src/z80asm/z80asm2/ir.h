//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_keywords.h"
#include "lexer_tokens.h"
#include "source_loc.h"
#include "string_interner.h"
#include <cstdint>
#include <iostream>
#include <memory>
#include <string>
#include <string_view>
#include <unordered_map>
#include <utility>
#include <vector>

using uint = unsigned int;

struct Section;
struct Stmt;
struct SymbolInfo;

//-----------------------------------------------------------------------------
// helper for dumping AST in a readable format
//-----------------------------------------------------------------------------
struct DumpContext {
    std::ostream& os;
    int indent{0};

    DumpContext(std::ostream& os_, int indent_ = 0);
    void line(std::string_view text);
    DumpContext child() const;
};

//-----------------------------------------------------------------------------
// class for evaluated expressions
//-----------------------------------------------------------------------------
enum class ExprType {
    Unknown,         // not evaluated yet
    Constant,        // fully resolved integer
    AddressRelative, // symbol + offset
    Computed,        // arbitrary expression involving symbols
};

struct ExprValue {
    ExprType type = ExprType::Unknown;

    // valid when Constant
    int const_value = 0;

    // valid when AddressRelative
    Section* section = nullptr;
    uint offset = 0;

    // valid when Computed
    std::vector<Token> tokens;
};

//-----------------------------------------------------------------------------
// base class for all tree nodes
//-----------------------------------------------------------------------------
struct TreeNode {
    virtual ~TreeNode() = default;
    virtual void dump(DumpContext ctx) const = 0;
};

//-----------------------------------------------------------------------------
// base class for all expressions
//-----------------------------------------------------------------------------
struct Expr : public TreeNode {
    SourceLoc loc;
    ExprValue value;                // evaluated value, if available
    std::vector<Token> tokens;      // original expression

    Expr(const SourceLoc& loc_) : loc(loc_) {}
};

struct ExprLiteralInt : public Expr {
    int int_value = 0;

    ExprLiteralInt(int v, const SourceLoc& loc) : Expr(loc), int_value(v) {}
    void dump(DumpContext ctx) const override;
};

struct ExprLiteralFloat : public Expr {
    double float_value = 0.0;

    ExprLiteralFloat(double v, const SourceLoc& loc) : Expr(loc), float_value(v) {}
    void dump(DumpContext ctx) const override;
};

struct ExprLiteralAsmpc : public Expr {
    ExprLiteralAsmpc(const SourceLoc& loc) : Expr(loc) {}
    Stmt* stmt = nullptr;  // pointer to the statement that generated this asmpc

    void dump(DumpContext ctx) const override;
};

struct ExprSymbol : public Expr {
    StringInterner::Id name_id;
    SymbolInfo* symbol = nullptr;  // pointer to the symbol info

    ExprSymbol(StringInterner::Id name_id_, const SourceLoc& loc) : Expr(loc),
        name_id(name_id_) {}
    void dump(DumpContext ctx) const override;
};

struct ExprLocalLabel : public Expr {
    StringInterner::Id name_id;
    size_t at_pos;  // position of '@' in the original identifier
    SymbolInfo* symbol = nullptr;  // pointer to the symbol info

    ExprLocalLabel(StringInterner::Id name_id_, size_t at_pos_,
                   const SourceLoc& loc)
        : Expr(loc), name_id(name_id_), at_pos(at_pos_) {}
    void dump(DumpContext ctx) const override;
};

struct ExprUnary : public Expr {
    TokenType op;
    std::unique_ptr<Expr> rhs;

    ExprUnary(TokenType op_, std::unique_ptr<Expr> rhs_, const SourceLoc& loc)
        : Expr(loc), op(op_), rhs(std::move(rhs_)) {}
    void dump(DumpContext ctx) const override;
};

struct ExprBinary : public Expr {
    TokenType op;
    std::unique_ptr<Expr> lhs, rhs;

    ExprBinary(TokenType op_, std::unique_ptr<Expr> lhs_,
               std::unique_ptr<Expr> rhs_,
               const SourceLoc& loc)
        : Expr(loc), op(op_), lhs(std::move(lhs_)), rhs(std::move(rhs_)) {}
    void dump(DumpContext ctx) const override;
};

struct ExprTernary : public Expr {
    std::unique_ptr<Expr> cond, then_expr, else_expr;

    ExprTernary(std::unique_ptr<Expr> c, std::unique_ptr<Expr> t,
                std::unique_ptr<Expr> e,
                const SourceLoc& loc)
        : Expr(loc), cond(std::move(c)), then_expr(std::move(t)),
          else_expr(std::move(e)) {}
    void dump(DumpContext ctx) const override;
};

struct ExprCallUnary : public Expr {
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
    None,                   // no patching needed
    ScaleBelowThreshold,    // A+(%c<8?%c*8:%c), followed by A
    AddScaled,              // A+B*%c, followed by A, B
    SelectOrAdd,            // %c==A?B:C+%c, followed by A, B, C
    Select2,                // %c==A?B:%c==C?D:E, followed by A, B, C, D, E
    Select3,                // %c==A?B:%c==C?D:%c==E?F:G, followed by A, B, C, D, E, F, G
};

// type of patch
enum class PatchType : uint8_t {
    Unsigned,               // unsigned, default
    Signed,                 // signed
    HighByte,               // ldh a, (%h) of gbz80
    BigEndian,              // push %M of z80n
    PCrelative,             // JR or JRE
};

// class for patches
struct Patch : public Expr {
    virtual ~Patch();

    std::unique_ptr<Expr> inner;    // expression
    size_t offset = 0;              // offset into opcode
    size_t size = 0;                // byte width of expression

    bool is_constant = false;       // true for %c patches, e.g. IM %c or BIT %c, r

    PatchType type = PatchType::Unsigned;       // type of patch

    // validation rule for constant expressions
    CheckRange validation = CheckRange::Is_any;

    // formula constant expressions
    ExprFormula formula = ExprFormula::None;

    // coeficients for formula A..G
    std::vector<uint8_t> coefs;

    size_t alt_offset = 0;         // alternative offset of long jump
    size_t alt_size = 0;           // alternative size of long jump
    std::vector<uint8_t> alt_bytes; // alternative opcode of long jump

    Patch(std::unique_ptr<Expr> expr, const SourceLoc& loc)
        : Expr(loc), inner(std::move(expr)) {}
    void dump(DumpContext ctx) const override;
};

//-----------------------------------------------------------------------------
// base class for all statements
//-----------------------------------------------------------------------------
struct Stmt : public TreeNode {
    SourceLoc loc;
    Section* section = nullptr;     // section where located
    uint address = 0;               // address of statement

    Stmt(const SourceLoc& loc_) : loc(loc_) {}
    virtual ~Stmt() = default;
    void dump(DumpContext ctx) const override;
};

struct OpcodeStmt : Stmt {
    bool is_short_jump = false;     // true if patches has a short jump

    // opcode bytes, including placeholders for expressions
    std::vector<uint8_t> bytes;
    std::vector<std::unique_ptr<Patch>> patches;    // instruction patches

    OpcodeStmt(const SourceLoc& loc) : Stmt(loc) {}
    void dump(DumpContext ctx) const override;
};

struct LabelStmt : Stmt {
    StringInterner::Id name_id;
    bool is_local = false;  // whether this is a local label (has '@')
    size_t at_pos = 0;      // position of '@' in the original identifier, if local
    SymbolInfo* symbol = nullptr; // symbol info for this label

    LabelStmt(StringInterner::Id name_id_, const SourceLoc& loc_);
    virtual ~LabelStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct OrgStmt : Stmt {
    std::unique_ptr<Expr> expr;
    uint padding_size = 0;      // number of bytes to pad to reach new address

    OrgStmt(std::unique_ptr<Expr> e, const SourceLoc& loc)
        : Stmt(loc), expr(std::move(e)) {}
    virtual ~OrgStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct DefcStmt : Stmt {
    StringInterner::Id name_id;
    std::unique_ptr<Expr> expr;
    SymbolInfo* symbol = nullptr;   // symbol info for this defc

    DefcStmt(StringInterner::Id name_id_,
             std::unique_ptr<Expr> e, const SourceLoc& loc)
        : Stmt(loc), name_id(name_id_), expr(std::move(e)) {}
    virtual ~DefcStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct ModuleStmt : Stmt {
    StringInterner::Id name_id;

    ModuleStmt(StringInterner::Id name_id_, const SourceLoc& loc)
        : Stmt(loc), name_id(name_id_) {}
    virtual ~ModuleStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct SectionStmt : Stmt {
    StringInterner::Id name_id;

    SectionStmt(StringInterner::Id name_id_, const SourceLoc& loc)
        : Stmt(loc), name_id(name_id_) {}
    virtual ~SectionStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct AlignStmt : Stmt {
    std::unique_ptr<Expr> align_expr;
    std::unique_ptr<Expr> filler_expr;
    uint padding_size = 0;          // number of bytes to pad to reach new address

    AlignStmt(std::unique_ptr<Expr> align_expr_,
              std::unique_ptr<Expr> filler_expr_, const SourceLoc& loc)
        : Stmt(loc), align_expr(std::move(align_expr_)),
          filler_expr(std::move(filler_expr_)) {}
    virtual ~AlignStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct DefsNumericStmt : Stmt {
    std::unique_ptr<Expr> size_expr;
    std::unique_ptr<Expr> filler_expr;
    uint padding_size = 0;          // number of bytes to pad to reach new address

    DefsNumericStmt(std::unique_ptr<Expr> size_expr_,
                    std::unique_ptr<Expr> filler_expr_, const SourceLoc& loc)
        : Stmt(loc), size_expr(std::move(size_expr_)),
          filler_expr(std::move(filler_expr_)) {}
    virtual ~DefsNumericStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct DefsStringStmt : Stmt {
    std::unique_ptr<Expr> size_expr;
    StringInterner::Id string_id;    // string literal to fill with
    uint8_t filler_byte;
    uint padding_size = 0;          // number of bytes to pad to reach new address

    DefsStringStmt(std::unique_ptr<Expr> size_expr_,
                   StringInterner::Id string_id_, uint8_t filler_byte_, const SourceLoc& loc)
        : Stmt(loc), size_expr(std::move(size_expr_)), string_id(string_id_),
          filler_byte(filler_byte_) {}
    virtual ~DefsStringStmt() = default;
    void dump(DumpContext ctx) const override;
};

enum class SymbolDeclareType : uint8_t {
    Extern, Public, Global,
};

struct SymbolRef {
    StringInterner::Id id;
    SourceLoc loc;
};

struct SymbolDeclareStmt : Stmt {
    SymbolDeclareType type;
    std::vector<SymbolRef> names;

    SymbolDeclareStmt(SymbolDeclareType type_,
                      const std::vector<SymbolRef>& names_,
                      const SourceLoc& loc)
        : Stmt(loc), type(type_), names(names_) {}
    virtual ~SymbolDeclareStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct ListStmt : Stmt {
    bool enable;

    ListStmt(bool enable_, const SourceLoc& loc)
        : Stmt(loc), enable(enable_) {}
    virtual ~ListStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct PhaseStmt : Stmt {
    std::unique_ptr<Expr> expr;

    PhaseStmt(std::unique_ptr<Expr> e, const SourceLoc& loc)
        : Stmt(loc), expr(std::move(e)) {}
    virtual ~PhaseStmt() = default;
    void dump(DumpContext ctx) const override;
};

struct DephaseStmt : Stmt {
    DephaseStmt(const SourceLoc& loc)
        : Stmt(loc) {}
    virtual ~DephaseStmt() = default;
    void dump(DumpContext ctx) const override;
};

//-----------------------------------------------------------------------------
// symbols
//-----------------------------------------------------------------------------
struct SymbolDeclare {
    StringInterner::Id name_id = 0;         // name of symbol
    SymbolDeclareType type = SymbolDeclareType::Extern; // type of declaration
    SourceLoc loc;                          // location where declared
    bool saw_extern = false;
    bool saw_public = false;
    bool saw_global = false;

    SymbolDeclare() = default;
    SymbolDeclare(StringInterner::Id name_id_, SymbolDeclareType type_,
                  const SourceLoc& loc_) :
        name_id(name_id_), type(type_), loc(loc_) {}
};

struct SymbolInfo : public TreeNode {
    enum class DefType : uint8_t {
        Undefined, Label, Defc,
    };

    StringInterner::Id name_id = 0;         // name of symbol
    DefType def_type = DefType::Undefined;  // type of definition
    SourceLoc loc;                          // location where defined
    Stmt* stmt = nullptr;                   // for Label
    Expr* defc_expr = nullptr;              // for Defc

    SymbolInfo(StringInterner::Id name_id_, DefType def_type_,
               const SourceLoc& loc_)
        : name_id(name_id_), def_type(def_type_), loc(loc_) {}
    virtual ~SymbolInfo() = default;
    void dump(DumpContext ctx) const override;
};

//-----------------------------------------------------------------------------
// sections
//-----------------------------------------------------------------------------
static const std::string_view DEFAULT_SECTION = "";

struct Section : public TreeNode {
    StringInterner::Id name_id = 0;         // name of section
    std::vector<Stmt*> stmts;               // point to statemens of section
    uint size = 0;                          // total size of section
    bool has_opcodes = false;               // to signal if a section has code
    OrgStmt* org_stmt = nullptr;            // set if section has ORG
    AlignStmt* align_stmt = nullptr;        // set if section has ALIGN

    Section(StringInterner::Id name_id_);
    virtual ~Section() = default;
    void dump(DumpContext ctx) const override;
    void dump(DumpContext ctx, const Section* current) const;
};

//-----------------------------------------------------------------------------
// modules
//-----------------------------------------------------------------------------
struct Module : public TreeNode {
    StringInterner::Id name_id = 0;         // name of module

    std::unordered_map<StringInterner::Id, std::unique_ptr<SymbolInfo>>
            symbols;                            // symbol table
    std::vector<std::unique_ptr<Section>> sections;
    Section* cur_section = nullptr;

    Module(StringInterner::Id name_id_);
    Section* set_section(StringInterner::Id sec_name_id);
    virtual ~Module() = default;
    void dump(DumpContext ctx) const override;
    void dump(DumpContext ctx, const Module* current) const;
};

//-----------------------------------------------------------------------------
// root of the AST and Intermediate Representation
//-----------------------------------------------------------------------------
struct Program : public TreeNode {
    StringInterner::Id name_id = 0;         // name of program
    std::vector<std::unique_ptr<Stmt>> stmts;

    std::unordered_map<StringInterner::Id, std::unique_ptr<SymbolDeclare>>
            declarations;
    std::vector<std::unique_ptr<Module>> modules;
    Module* cur_module = nullptr;

    Program(StringInterner::Id name_id_);
    Module* set_module(StringInterner::Id mod_name_id);
    virtual ~Program() = default;
    void dump(DumpContext ctx) const override;
};

[[noreturn]] void dump_ast_and_exit(const std::unique_ptr<Program>& prog);
