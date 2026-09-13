//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "dump_context.h"
#include "errors.h"
#include "lexer.h"
#include <cstdint>
#include <memory>
#include <string>
#include <utility>
#include <vector>

struct ASTVisitor;
struct LoweringPass;
struct LoweredExpr;
struct Expr;
struct Stmt;

using ExprPtr = std::unique_ptr<Expr>;
using StmtPtr = std::unique_ptr<Stmt>;

template<typename T, typename... Args>
std::unique_ptr<T> make_node(Args&& ... args) {
    return std::make_unique<T>(std::forward<Args>(args)...);
}

bool is_string_variable(const std::string& name);

//-----------------------------------------------------------------------------
// Rewrite info
//-----------------------------------------------------------------------------

struct RewriteInfo {
    std::vector<StmtPtr> prepend;
    std::vector<StmtPtr> append;
    bool remove = false;
    ExprPtr replace_expr;
};

//-----------------------------------------------------------------------------
// Expression tree
//-----------------------------------------------------------------------------

enum class ExprType {
    Number,
    String,
};

struct Expr : TreeNode {
    ExprType type = ExprType::Number;
    SourceLoc loc;			// source location

    // for AST transformations, not cloned and not dumped
    RewriteInfo rewrite;

    explicit Expr(ExprType type_, const SourceLoc& loc_);
    virtual ~Expr() = default;

    virtual ExprPtr clone() const = 0;
    virtual void accept(ASTVisitor& v) = 0;
    virtual LoweredExpr lower(LoweringPass& pass) = 0;
};

int precedence(const Expr& e);

struct NumberExpr : Expr {
    double value = 0.0;

    explicit NumberExpr(double value_, SourceLoc loc_);
    virtual ~NumberExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LabelLineRefExpr : Expr {
    std::string name;   // @label

    explicit LabelLineRefExpr(const std::string& name_, SourceLoc loc_);
    virtual ~LabelLineRefExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LabelAddrRefExpr : Expr {
    std::string name;   // &var

    explicit LabelAddrRefExpr(const std::string& name_, SourceLoc loc_);
    virtual ~LabelAddrRefExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct StringLiteralExpr : Expr {
    std::string value;      // ASCII string literal

    explicit StringLiteralExpr(std::string val, SourceLoc loc_);
    virtual ~StringLiteralExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct VariableExpr : Expr {
    std::string name;       // includes $ if present

    explicit VariableExpr(const std::string& name_, SourceLoc loc_);
    virtual ~VariableExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ArrayRefExpr : Expr {
    std::string name;  // A or A$
    std::vector<ExprPtr> indices;  // one or more expressions

    explicit ArrayRefExpr(const std::string& name_, SourceLoc loc_);
    virtual ~ArrayRefExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct SliceExpr : Expr {
    ExprPtr base;   // A$, A$(I), or any string expression
    ExprPtr from;   // may be nullptr
    ExprPtr to;     // may be nullptr

    explicit SliceExpr(ExprPtr base_, SourceLoc loc_);
    virtual ~SliceExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct UnaryExpr : Expr {
    TokenType op;        // '-', NOT
    ExprPtr operand;

    explicit UnaryExpr(TokenType op_, ExprPtr operand_,
                       SourceLoc loc_);
    virtual ~UnaryExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct BinaryExpr : Expr {
    TokenType op;        // + - * / ** AND OR NOT = < > <= >= <>
    ExprPtr lhs;
    ExprPtr rhs;

    explicit BinaryExpr(TokenType op_,
                        ExprPtr lhs_,
                        ExprPtr rhs_, SourceLoc loc_);
    virtual ~BinaryExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct BasicFuncCallExpr : Expr {
    Keyword keyword;    // SIN, COS, LEN, VAL, STR$, etc.
    std::vector<ExprPtr> args;

    explicit BasicFuncCallExpr(Keyword keyword_, SourceLoc loc_);
    virtual ~BasicFuncCallExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ProcCallExpr : Expr {
    std::string name;                         // PROCname
    std::vector<ExprPtr> args;  // (10, 20)

    explicit ProcCallExpr(const std::string& name_, SourceLoc loc_);
    virtual ~ProcCallExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct FnCallExpr : Expr {
    std::string name;                         // FNname
    std::vector<ExprPtr> args;  // (10, 20)

    explicit FnCallExpr(const std::string& name_, SourceLoc loc_);
    virtual ~FnCallExpr() = default;

    virtual ExprPtr clone() const override;
    virtual void accept(ASTVisitor& v) override;
    virtual LoweredExpr lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

//-----------------------------------------------------------------------------
// Statement tree
//-----------------------------------------------------------------------------

struct Stmt : TreeNode {
    SourceLoc loc;			// source location

    // for AST transformations, not cloned and not dumped
    RewriteInfo rewrite;

    explicit Stmt(const SourceLoc& loc_);
    virtual ~Stmt() = default;

    virtual StmtPtr clone() const = 0;
    virtual void accept(ASTVisitor& v) = 0;
    virtual std::vector<StmtPtr> lower(LoweringPass& pass) = 0;
};

struct LabelStmt : Stmt {
    std::string label;

    explicit LabelStmt(const std::string& label_, const SourceLoc& loc_);
    virtual ~LabelStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LineNumStmt : Stmt {
    int line_num = -1;    // line number in the source file

    explicit LineNumStmt(int line_num_, const SourceLoc& loc_);
    virtual ~LineNumStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LetStmt : Stmt {
    ExprPtr lhs;     // variable, array ref, slice
    ExprPtr rhs;     // expression

    explicit LetStmt(ExprPtr lhs_,
                     ExprPtr rhs_,
                     const SourceLoc& loc_);
    virtual ~LetStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct DimItem {
    std::string name;             // A or A$
    std::vector<ExprPtr> dims;    // dimensions

#ifdef _DEBUG
    void dump(DumpContext ctx) const;
#endif
};

struct DimStmt : Stmt {
    std::vector<DimItem> items;

    using Stmt::Stmt;
    virtual ~DimStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct IfStmt : Stmt {
    ExprPtr condition;
    std::vector<StmtPtr> then_stmts;
    std::vector<StmtPtr> else_stmts;

    explicit IfStmt(ExprPtr condition_,
                    const SourceLoc& loc_);
    virtual ~IfStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RepeatStmt : Stmt {
    std::vector<StmtPtr> body;
    ExprPtr condition;

    explicit RepeatStmt(ExprPtr condition_,
                        const SourceLoc& loc_);
    virtual ~RepeatStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct WhileStmt : Stmt {
    ExprPtr condition;
    std::vector<StmtPtr> body;

    explicit WhileStmt(ExprPtr condition_,
                       const SourceLoc& loc_);
    virtual ~WhileStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ForStmt : Stmt {
    std::string name;               // loop variable
    ExprPtr start_expr;
    ExprPtr end_expr;
    ExprPtr step_expr;
    std::vector<StmtPtr> body;

    explicit ForStmt(const std::string& name_,
                     ExprPtr start_expr_,
                     ExprPtr end_expr_,
                     ExprPtr step_expr_,
                     const SourceLoc& loc_);
    virtual ~ForStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct NextStmt : Stmt {
    std::string name;               // loop variable

    explicit NextStmt(const std::string& name_, const SourceLoc& loc_);
    virtual ~NextStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct DefProcStmt : Stmt {
    std::string name;                         // PROCname
    std::vector<std::string> params;          // A, B
    std::vector<std::string> locals;          // L
    std::vector<StmtPtr> body;  // statements inside PROC
    bool called = false;

    explicit DefProcStmt(const std::string& name_, const SourceLoc& loc_);
    virtual ~DefProcStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ProcCallStmt : Stmt {
    std::string name;           // PROCname
    std::vector<ExprPtr> args;  // 10, 20

    explicit ProcCallStmt(const std::string& name_, const SourceLoc& loc_);
    virtual ~ProcCallStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LocalStmt : Stmt {
    std::vector<std::string> locals;          // L

    using Stmt::Stmt;
    virtual ~LocalStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct DefFnStmt : Stmt {
    std::string name;                         // FNname
    std::vector<std::string> params;          // A, B
    ExprPtr expr;               // A+B

    explicit DefFnStmt(const std::string& name_, const SourceLoc& loc_);
    virtual ~DefFnStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ExitStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ExitStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct GotoStmt : Stmt {
    ExprPtr target_expr;

    explicit GotoStmt(ExprPtr target_expr_, const SourceLoc& loc_);
    virtual ~GotoStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct GosubStmt : Stmt {
    ExprPtr target_expr;

    explicit GosubStmt(ExprPtr target_expr_, const SourceLoc& loc_);
    virtual ~GosubStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ReturnStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ReturnStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct StopStmt : Stmt {
    using Stmt::Stmt;
    virtual ~StopStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct EndStmt : Stmt {
    using Stmt::Stmt;
    virtual ~EndStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PrintItem {
    enum class Type {
        Expr,
        Comma,
        Semicolon,
        At,
        Tab
    };

    Type type;

    // For Expr
    ExprPtr expr;

    // For AT line,col
    ExprPtr line_expr;
    ExprPtr col_expr;

    // For TAB col
    ExprPtr tab_expr;
};

struct PrintStmt : Stmt {
    std::vector<PrintItem> items;

    using Stmt::Stmt;
    virtual ~PrintStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct InputStmt : Stmt {
    std::vector<ExprPtr> vars;      // variables, array refs, slices

    using Stmt::Stmt;
    virtual ~InputStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RemStmt : Stmt {
    std::string text;   			// comment text
    std::vector<TokLine> asm_lines;	// ASM statements

    explicit RemStmt(const std::string& text_, const SourceLoc& loc_);
    virtual ~RemStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RunStmt : Stmt {
    ExprPtr target_expr;   // optional expression

    using Stmt::Stmt;
    virtual ~RunStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ListStmt : Stmt {
    ExprPtr target_expr;   // optional expression

    using Stmt::Stmt;
    virtual ~ListStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct NewStmt : Stmt {
    using Stmt::Stmt;
    virtual ~NewStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ClsStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ClsStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LoadStmt : Stmt {
    ExprPtr filename_expr;

    explicit LoadStmt(ExprPtr filename_expr_, const SourceLoc& loc_);
    virtual ~LoadStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct SaveStmt : Stmt {
    ExprPtr filename_expr;

    explicit SaveStmt(ExprPtr filename_expr_, const SourceLoc& loc_);
    virtual ~SaveStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PokeStmt : Stmt {
    ExprPtr address_expr;
    ExprPtr value_expr;

    explicit PokeStmt(ExprPtr address_expr_,
                      ExprPtr value_expr_, const SourceLoc& loc_);
    virtual ~PokeStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PokewStmt : Stmt {
    ExprPtr address_expr;
    ExprPtr value_expr;

    explicit PokewStmt(ExprPtr address_expr_,
                       ExprPtr value_expr_, const SourceLoc& loc_);
    virtual ~PokewStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PlotStmt : Stmt {
    ExprPtr x_expr;
    ExprPtr y_expr;

    explicit PlotStmt(ExprPtr x_expr_, ExprPtr y_expr_,
                      const SourceLoc& loc_);
    virtual ~PlotStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct UnplotStmt : Stmt {
    ExprPtr x_expr;
    ExprPtr y_expr;

    explicit UnplotStmt(ExprPtr x_expr_,
                        ExprPtr y_expr_, const SourceLoc& loc_);
    virtual ~UnplotStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RandStmt : Stmt {
    ExprPtr seed_expr;

    explicit RandStmt(ExprPtr seed_expr_, const SourceLoc& loc_);
    virtual ~RandStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PauseStmt : Stmt {
    ExprPtr duration_expr;

    explicit PauseStmt(ExprPtr duration_expr_, const SourceLoc& loc_);
    virtual ~PauseStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct FastStmt : Stmt {
    using Stmt::Stmt;
    virtual ~FastStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct SlowStmt : Stmt {
    using Stmt::Stmt;
    virtual ~SlowStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ScrollStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ScrollStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ContStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ContStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ClearStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ClearStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PragmaNumVarStmt : Stmt {
    std::string name;
    double value;

    explicit PragmaNumVarStmt(std::string name_, double value_,
                              const SourceLoc& loc_);
    virtual ~PragmaNumVarStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PragmaStrVarStmt : Stmt {
    std::string name;
    std::string value;
    std::vector<TokLine> asm_lines;	// ASM statements

    explicit PragmaStrVarStmt(std::string name_, std::string value_,
                              const SourceLoc& loc_);
    virtual ~PragmaStrVarStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PragmaNumVarArrayStmt : Stmt {
    std::string name;
    std::vector<int> dims;			// dimensions
    std::vector<double> values;

    explicit PragmaNumVarArrayStmt(std::string name_, const SourceLoc& loc_);
    virtual ~PragmaNumVarArrayStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PragmaStrVarArrayStmt : Stmt {
    std::string name;
    std::vector<int> dims;			// dimensions
    std::vector<std::string> values;

    explicit PragmaStrVarArrayStmt(std::string name_, const SourceLoc& loc_);
    virtual ~PragmaStrVarArrayStmt() = default;

    StmtPtr clone() const override;
    void accept(ASTVisitor& v) override;
    std::vector<StmtPtr> lower(LoweringPass& pass) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct Prog : TreeNode {
    bool auto_start = false;        // true if program starts on load
    int auto_start_line = 0;        // line number to start on load
    std::string auto_start_label;   // label to start on load
    int increment = 10;             // auto-increment for line numbers
    bool rem_invert = false;        // true if REM comments are inverted
    bool fast_mode = false;         // true if fast mode is enabled
    std::vector<std::string> dfile_lines;   // lines for the display file
    bool dfile_colapsed = false;    // true if display file is collapsed
    std::vector<uint8_t> sysvars_data;   // raw SYSVAR data

    std::vector<StmtPtr> stmts;
    std::vector<StmtPtr> pragma_vars;

    void accept(ASTVisitor& v);

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};
