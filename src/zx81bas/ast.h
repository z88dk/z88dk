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

struct ASTVisitor;

bool is_string_variable(const std::string& name);

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

    explicit Expr(ExprType type_, const SourceLoc& loc_);
    virtual ~Expr() = default;

    virtual std::unique_ptr<Expr> clone() const = 0;
    virtual void accept(ASTVisitor& v) = 0;
};

int precedence(const Expr& e);

struct NumberExpr : Expr {
    double value = 0.0;

    explicit NumberExpr(double value_, SourceLoc loc_);
    virtual ~NumberExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LabelLineRefExpr : Expr {
    std::string name;   // @label

    explicit LabelLineRefExpr(const std::string& name_, SourceLoc loc_);
    virtual ~LabelLineRefExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LabelAddrRefExpr : Expr {
    std::string name;   // &var

    explicit LabelAddrRefExpr(const std::string& name_, SourceLoc loc_);
    virtual ~LabelAddrRefExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct StringLiteralExpr : Expr {
    std::string value;      // ASCII string literal

    explicit StringLiteralExpr(std::string val, SourceLoc loc_);
    virtual ~StringLiteralExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct VariableExpr : Expr {
    std::string name;       // includes $ if present

    explicit VariableExpr(const std::string& name_, SourceLoc loc_);
    virtual ~VariableExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ArrayRefExpr : Expr {
    std::string name;  // A or A$
    std::vector<std::unique_ptr<Expr>> indices;  // one or more expressions

    explicit ArrayRefExpr(const std::string& name_, SourceLoc loc_);
    virtual ~ArrayRefExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct SliceExpr : Expr {
    std::unique_ptr<Expr> base;   // A$, A$(I), or any string expression
    std::unique_ptr<Expr> from;   // may be nullptr
    std::unique_ptr<Expr> to;     // may be nullptr

    explicit SliceExpr(std::unique_ptr<Expr> base_, SourceLoc loc_);
    virtual ~SliceExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct UnaryExpr : Expr {
    TokenType op;        // '-', NOT
    std::unique_ptr<Expr> operand;

    explicit UnaryExpr(TokenType op_, std::unique_ptr<Expr> operand_,
                       SourceLoc loc_);
    virtual ~UnaryExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct BinaryExpr : Expr {
    TokenType op;        // + - * / ** AND OR NOT = < > <= >= <>
    std::unique_ptr<Expr> lhs;
    std::unique_ptr<Expr> rhs;

    explicit BinaryExpr(TokenType op_,
                        std::unique_ptr<Expr> lhs_,
                        std::unique_ptr<Expr> rhs_, SourceLoc loc_);
    virtual ~BinaryExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct BasicFuncCallExpr : Expr {
    Keyword keyword;    // SIN, COS, LEN, VAL, STR$, etc.
    std::vector<std::unique_ptr<Expr>> args;

    explicit BasicFuncCallExpr(Keyword keyword_, SourceLoc loc_);
    virtual ~BasicFuncCallExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ProcCallExpr : Expr {
    std::string name;                         // PROCname
    std::vector<std::unique_ptr<Expr>> args;  // (10, 20)

    explicit ProcCallExpr(const std::string& name_, SourceLoc loc_);
    virtual ~ProcCallExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct FnCallExpr : Expr {
    std::string name;                         // FNname
    std::vector<std::unique_ptr<Expr>> args;  // (10, 20)

    explicit FnCallExpr(const std::string& name_, SourceLoc loc_);
    virtual ~FnCallExpr() = default;

    virtual std::unique_ptr<Expr> clone() const override;
    virtual void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

//-----------------------------------------------------------------------------
// Statement tree
//-----------------------------------------------------------------------------

struct Stmt : TreeNode {
    SourceLoc loc;			// source location

    // these are for AST transformations, are not cloned and not dumped
    bool marked_for_removal = false;
    std::vector<std::unique_ptr<Stmt>> prepend_nodes;
    std::vector<std::unique_ptr<Stmt>> append_nodes;

    explicit Stmt(const SourceLoc& loc_);
    virtual ~Stmt() = default;

    virtual std::unique_ptr<Stmt> clone() const = 0;
    virtual void accept(ASTVisitor& v) = 0;
};

struct LabelStmt : Stmt {
    std::string label;

    explicit LabelStmt(const std::string& label_, const SourceLoc& loc_);
    virtual ~LabelStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LineNumStmt : Stmt {
    int line_num = -1;    // line number in the source file

    explicit LineNumStmt(int line_num_, const SourceLoc& loc_);
    virtual ~LineNumStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LetStmt : Stmt {
    std::unique_ptr<Expr> lhs;     // variable, array ref, slice
    std::unique_ptr<Expr> rhs;     // expression

    explicit LetStmt(std::unique_ptr<Expr> lhs_,
                     std::unique_ptr<Expr> rhs_,
                     const SourceLoc& loc_);
    virtual ~LetStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct DimItem {
    std::string name;                           // A or A$
    std::vector<std::unique_ptr<Expr>> dims;    // dimensions

#ifdef _DEBUG
    void dump(DumpContext ctx) const;
#endif
};

struct DimStmt : Stmt {
    std::vector<DimItem> items;

    using Stmt::Stmt;
    virtual ~DimStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct IfStmt : Stmt {
    std::unique_ptr<Expr> condition;
    std::vector<std::unique_ptr<Stmt>> then_stmts;
    std::vector<std::unique_ptr<Stmt>> else_stmts;

    explicit IfStmt(std::unique_ptr<Expr> condition_,
                    const SourceLoc& loc_);
    virtual ~IfStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RepeatStmt : Stmt {
    std::vector<std::unique_ptr<Stmt>> body;
    std::unique_ptr<Expr> condition;
    std::string start_label;
    std::string end_label;

    explicit RepeatStmt(std::unique_ptr<Expr> condition_,
                        const SourceLoc& loc_);
    virtual ~RepeatStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct WhileStmt : Stmt {
    std::unique_ptr<Expr> condition;
    std::vector<std::unique_ptr<Stmt>> body;
    std::string start_label;
    std::string end_label;

    explicit WhileStmt(std::unique_ptr<Expr> condition_,
                       const SourceLoc& loc_);
    virtual ~WhileStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ForStmt : Stmt {
    std::string name;               // loop variable
    std::unique_ptr<Expr> start_expr;
    std::unique_ptr<Expr> end_expr;
    std::unique_ptr<Expr> step_expr;
    std::vector<std::unique_ptr<Stmt>> body;
    std::string end_label;

    explicit ForStmt(const std::string& name_,
                     std::unique_ptr<Expr> start_expr_,
                     std::unique_ptr<Expr> end_expr_,
                     std::unique_ptr<Expr> step_expr_,
                     const SourceLoc& loc_);
    virtual ~ForStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct NextStmt : Stmt {
    std::string name;               // loop variable

    explicit NextStmt(const std::string& name_, const SourceLoc& loc_);
    virtual ~NextStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct DefProcStmt : Stmt {
    std::string name;                         // PROCname
    std::vector<std::string> params;          // A, B
    std::vector<std::string> locals;          // L
    std::vector<std::unique_ptr<Stmt>> body;  // statements inside PROC
    bool called = false;

    explicit DefProcStmt(const std::string& name_, const SourceLoc& loc_);
    virtual ~DefProcStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ProcCallStmt : Stmt {
    std::string name;                         // PROCname
    std::vector<std::unique_ptr<Expr>> args;  // 10, 20

    explicit ProcCallStmt(const std::string& name_, const SourceLoc& loc_);
    virtual ~ProcCallStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LocalStmt : Stmt {
    std::vector<std::string> locals;          // L

    using Stmt::Stmt;
    virtual ~LocalStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct DefFnStmt : Stmt {
    std::string name;                         // FNname
    std::vector<std::string> params;          // A, B
    std::unique_ptr<Expr> expr;               // A+B

    explicit DefFnStmt(const std::string& name_, const SourceLoc& loc_);
    virtual ~DefFnStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ExitStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ExitStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct GotoStmt : Stmt {
    std::unique_ptr<Expr> target_expr;

    explicit GotoStmt(std::unique_ptr<Expr> target_expr_, const SourceLoc& loc_);
    virtual ~GotoStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct GosubStmt : Stmt {
    std::unique_ptr<Expr> target_expr;

    explicit GosubStmt(std::unique_ptr<Expr> target_expr_, const SourceLoc& loc_);
    virtual ~GosubStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ReturnStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ReturnStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct StopStmt : Stmt {
    using Stmt::Stmt;
    virtual ~StopStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct EndStmt : Stmt {
    using Stmt::Stmt;
    virtual ~EndStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

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
    std::unique_ptr<Expr> expr;

    // For AT line,col
    std::unique_ptr<Expr> line_expr;
    std::unique_ptr<Expr> col_expr;

    // For TAB col
    std::unique_ptr<Expr> tab_expr;
};

struct PrintStmt : Stmt {
    std::vector<PrintItem> items;

    using Stmt::Stmt;
    virtual ~PrintStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct InputStmt : Stmt {
    std::vector<std::unique_ptr<Expr>> vars;      // variables, array refs, slices

    using Stmt::Stmt;
    virtual ~InputStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RemStmt : Stmt {
    std::string text;   			// comment text
    std::vector<TokLine> asm_lines;	// ASM statements

    explicit RemStmt(const std::string& text_, const SourceLoc& loc_);
    virtual ~RemStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RunStmt : Stmt {
    std::unique_ptr<Expr> target_expr;   // optional expression

    using Stmt::Stmt;
    virtual ~RunStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ListStmt : Stmt {
    std::unique_ptr<Expr> target_expr;   // optional expression

    using Stmt::Stmt;
    virtual ~ListStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct NewStmt : Stmt {
    using Stmt::Stmt;
    virtual ~NewStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ClsStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ClsStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LoadStmt : Stmt {
    std::unique_ptr<Expr> filename_expr;

    explicit LoadStmt(std::unique_ptr<Expr> filename_expr_, const SourceLoc& loc_);
    virtual ~LoadStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct SaveStmt : Stmt {
    std::unique_ptr<Expr> filename_expr;

    explicit SaveStmt(std::unique_ptr<Expr> filename_expr_, const SourceLoc& loc_);
    virtual ~SaveStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PokeStmt : Stmt {
    std::unique_ptr<Expr> address_expr;
    std::unique_ptr<Expr> value_expr;

    explicit PokeStmt(std::unique_ptr<Expr> address_expr_,
                      std::unique_ptr<Expr> value_expr_, const SourceLoc& loc_);
    virtual ~PokeStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PokewStmt : Stmt {
    std::unique_ptr<Expr> address_expr;
    std::unique_ptr<Expr> value_expr;

    explicit PokewStmt(std::unique_ptr<Expr> address_expr_,
                       std::unique_ptr<Expr> value_expr_, const SourceLoc& loc_);
    virtual ~PokewStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PlotStmt : Stmt {
    std::unique_ptr<Expr> x_expr;
    std::unique_ptr<Expr> y_expr;

    explicit PlotStmt(std::unique_ptr<Expr> x_expr_, std::unique_ptr<Expr> y_expr_,
                      const SourceLoc& loc_);
    virtual ~PlotStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct UnplotStmt : Stmt {
    std::unique_ptr<Expr> x_expr;
    std::unique_ptr<Expr> y_expr;

    explicit UnplotStmt(std::unique_ptr<Expr> x_expr_,
                        std::unique_ptr<Expr> y_expr_, const SourceLoc& loc_);
    virtual ~UnplotStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RandStmt : Stmt {
    std::unique_ptr<Expr> seed_expr;

    explicit RandStmt(std::unique_ptr<Expr> seed_expr_, const SourceLoc& loc_);
    virtual ~RandStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PauseStmt : Stmt {
    std::unique_ptr<Expr> duration_expr;

    explicit PauseStmt(std::unique_ptr<Expr> duration_expr_, const SourceLoc& loc_);
    virtual ~PauseStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct FastStmt : Stmt {
    using Stmt::Stmt;
    virtual ~FastStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct SlowStmt : Stmt {
    using Stmt::Stmt;
    virtual ~SlowStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ScrollStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ScrollStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ContStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ContStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ClearStmt : Stmt {
    using Stmt::Stmt;
    virtual ~ClearStmt() = default;

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

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

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

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

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

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

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

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

    std::unique_ptr<Stmt> clone() const override;
    void accept(ASTVisitor& v) override;

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

    std::vector<std::unique_ptr<Stmt>> stmts;
    std::vector<std::unique_ptr<Stmt>> pragma_vars;

    void accept(ASTVisitor& v);

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

//-----------------------------------------------------------------------------
// Visitor
//-----------------------------------------------------------------------------

struct ASTVisitor {
    virtual ~ASTVisitor() = default;

    void rewrite_stmt_list(std::vector<std::unique_ptr<Stmt>>& list);

    virtual bool enter(NumberExpr&);
    virtual void visit(NumberExpr&) {}
    virtual void leave(NumberExpr&) {}

    virtual bool enter(LabelLineRefExpr&);
    virtual void visit(LabelLineRefExpr&) {}
    virtual void leave(LabelLineRefExpr&) {}

    virtual bool enter(LabelAddrRefExpr&);
    virtual void visit(LabelAddrRefExpr&) {}
    virtual void leave(LabelAddrRefExpr&) {}

    virtual bool enter(StringLiteralExpr&);
    virtual void visit(StringLiteralExpr&) {}
    virtual void leave(StringLiteralExpr&) {}

    virtual bool enter(VariableExpr&);
    virtual void visit(VariableExpr&) {}
    virtual void leave(VariableExpr&) {}

    virtual bool enter(ArrayRefExpr&);
    virtual void visit(ArrayRefExpr&) {}
    virtual void leave(ArrayRefExpr&) {}

    virtual bool enter(SliceExpr&);
    virtual void visit(SliceExpr&) {}
    virtual void leave(SliceExpr&) {}

    virtual bool enter(UnaryExpr&);
    virtual void visit(UnaryExpr&) {}
    virtual void leave(UnaryExpr&) {}

    virtual bool enter(BinaryExpr&);
    virtual void visit(BinaryExpr&) {}
    virtual void leave(BinaryExpr&) {}

    virtual bool enter(BasicFuncCallExpr&);
    virtual void visit(BasicFuncCallExpr&) {}
    virtual void leave(BasicFuncCallExpr&) {}

    virtual bool enter(ProcCallExpr&);
    virtual void visit(ProcCallExpr&) {}
    virtual void leave(ProcCallExpr&) {}

    virtual bool enter(FnCallExpr&);
    virtual void visit(FnCallExpr&) {}
    virtual void leave(FnCallExpr&) {}

    virtual bool enter(LabelStmt&);
    virtual void visit(LabelStmt&) {}
    virtual void leave(LabelStmt&) {}

    virtual bool enter(LineNumStmt&);
    virtual void visit(LineNumStmt&) {}
    virtual void leave(LineNumStmt&) {}

    virtual bool enter(LetStmt&);
    virtual void visit(LetStmt&) {}
    virtual void leave(LetStmt&) {}

    virtual bool enter(DimStmt&);
    virtual void visit(DimStmt&) {}
    virtual void leave(DimStmt&) {}

    virtual bool enter(IfStmt&);
    virtual void visit(IfStmt&) {}
    virtual void leave(IfStmt&) {}

    virtual bool enter(RepeatStmt&);
    virtual void visit(RepeatStmt&) {}
    virtual void leave(RepeatStmt&) {}

    virtual bool enter(WhileStmt&);
    virtual void visit(WhileStmt&) {}
    virtual void leave(WhileStmt&) {}

    virtual bool enter(ForStmt&);
    virtual void visit(ForStmt&) {}
    virtual void leave(ForStmt&) {}

    virtual bool enter(NextStmt&);
    virtual void visit(NextStmt&) {}
    virtual void leave(NextStmt&) {}

    virtual bool enter(DefProcStmt&);
    virtual void visit(DefProcStmt&) {}
    virtual void leave(DefProcStmt&) {}

    virtual bool enter(ProcCallStmt&);
    virtual void visit(ProcCallStmt&) {}
    virtual void leave(ProcCallStmt&) {}

    virtual bool enter(LocalStmt&);
    virtual void visit(LocalStmt&) {}
    virtual void leave(LocalStmt&) {}

    virtual bool enter(DefFnStmt&);
    virtual void visit(DefFnStmt&) {}
    virtual void leave(DefFnStmt&) {}

    virtual bool enter(ExitStmt&);
    virtual void visit(ExitStmt&) {}
    virtual void leave(ExitStmt&) {}

    virtual bool enter(GotoStmt&);
    virtual void visit(GotoStmt&) {}
    virtual void leave(GotoStmt&) {}

    virtual bool enter(GosubStmt&);
    virtual void visit(GosubStmt&) {}
    virtual void leave(GosubStmt&) {}

    virtual bool enter(ReturnStmt&);
    virtual void visit(ReturnStmt&) {}
    virtual void leave(ReturnStmt&) {}

    virtual bool enter(StopStmt&);
    virtual void visit(StopStmt&) {}
    virtual void leave(StopStmt&) {}

    virtual bool enter(EndStmt&);
    virtual void visit(EndStmt&) {}
    virtual void leave(EndStmt&) {}

    virtual bool enter(PrintStmt&);
    virtual void visit(PrintStmt&) {}
    virtual void leave(PrintStmt&) {}

    virtual bool enter(InputStmt&);
    virtual void visit(InputStmt&) {}
    virtual void leave(InputStmt&) {}

    virtual bool enter(RemStmt&);
    virtual void visit(RemStmt&) {}
    virtual void leave(RemStmt&) {}

    virtual bool enter(RunStmt&);
    virtual void visit(RunStmt&) {}
    virtual void leave(RunStmt&) {}

    virtual bool enter(ListStmt&);
    virtual void visit(ListStmt&) {}
    virtual void leave(ListStmt&) {}

    virtual bool enter(NewStmt&);
    virtual void visit(NewStmt&) {}
    virtual void leave(NewStmt&) {}

    virtual bool enter(ClsStmt&);
    virtual void visit(ClsStmt&) {}
    virtual void leave(ClsStmt&) {}

    virtual bool enter(LoadStmt&);
    virtual void visit(LoadStmt&) {}
    virtual void leave(LoadStmt&) {}

    virtual bool enter(SaveStmt&);
    virtual void visit(SaveStmt&) {}
    virtual void leave(SaveStmt&) {}

    virtual bool enter(PokeStmt&);
    virtual void visit(PokeStmt&) {}
    virtual void leave(PokeStmt&) {}

    virtual bool enter(PokewStmt&);
    virtual void visit(PokewStmt&) {}
    virtual void leave(PokewStmt&) {}

    virtual bool enter(PlotStmt&);
    virtual void visit(PlotStmt&) {}
    virtual void leave(PlotStmt&) {}

    virtual bool enter(UnplotStmt&);
    virtual void visit(UnplotStmt&) {}
    virtual void leave(UnplotStmt&) {}

    virtual bool enter(RandStmt&);
    virtual void visit(RandStmt&) {}
    virtual void leave(RandStmt&) {}

    virtual bool enter(PauseStmt&);
    virtual void visit(PauseStmt&) {}
    virtual void leave(PauseStmt&) {}

    virtual bool enter(FastStmt&);
    virtual void visit(FastStmt&) {}
    virtual void leave(FastStmt&) {}

    virtual bool enter(SlowStmt&);
    virtual void visit(SlowStmt&) {}
    virtual void leave(SlowStmt&) {}

    virtual bool enter(ScrollStmt&);
    virtual void visit(ScrollStmt&) {}
    virtual void leave(ScrollStmt&) {}

    virtual bool enter(ContStmt&);
    virtual void visit(ContStmt&) {}
    virtual void leave(ContStmt&) {}

    virtual bool enter(ClearStmt&);
    virtual void visit(ClearStmt&) {}
    virtual void leave(ClearStmt&) {}

    virtual bool enter(PragmaNumVarStmt&);
    virtual void visit(PragmaNumVarStmt&) {}
    virtual void leave(PragmaNumVarStmt&) {}

    virtual bool enter(PragmaStrVarStmt&);
    virtual void visit(PragmaStrVarStmt&) {}
    virtual void leave(PragmaStrVarStmt&) {}

    virtual bool enter(PragmaNumVarArrayStmt&);
    virtual void visit(PragmaNumVarArrayStmt&) {}
    virtual void leave(PragmaNumVarArrayStmt&) {}

    virtual bool enter(PragmaStrVarArrayStmt&);
    virtual void visit(PragmaStrVarArrayStmt&) {}
    virtual void leave(PragmaStrVarArrayStmt&) {}

    virtual bool enter(Prog&);
    virtual void visit(Prog&) {}
    virtual void leave(Prog&) {}
};
