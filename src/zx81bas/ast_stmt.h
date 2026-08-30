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
#include <vector>

struct Expr;

struct Stmt : TreeNode {
    SourceLoc loc;			// source location

    explicit Stmt(const SourceLoc& loc_)
        : loc(loc_) {
    }

#ifdef _DEBUG
    void dump(DumpContext ctx) const override = 0;
#endif
};

struct JumpTargetStmt : Stmt {
    std::string label;          // label, if any
    int basic_line_num = -1;    // line number in the source file, if any

    explicit JumpTargetStmt(const SourceLoc& loc_,
                            const std::string& label_,
                            int basic_line_num_)
        : Stmt(loc_), label(label_), basic_line_num(basic_line_num_) {
    }

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LetStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> lhs;     // variable, array ref, slice
    std::unique_ptr<Expr> rhs;     // expression

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
    using Stmt::Stmt;

    std::vector<DimItem> items;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct IfStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> condition;
    std::vector<std::unique_ptr<Stmt>> then_stmts;
    std::vector<std::unique_ptr<Stmt>> else_stmts;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RepeatStmt : Stmt {
    using Stmt::Stmt;

    std::vector<std::unique_ptr<Stmt>> body;   // full body, including EXIT
    std::unique_ptr<Expr> condition;     // condition2

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct WhileStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> condition;               // condition1
    std::vector<std::unique_ptr<Stmt>> body;       // full body, including EXIT

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ForStmt : Stmt {
    using Stmt::Stmt;

    std::string name;               // loop variable
    std::unique_ptr<Expr> start_expr;
    std::unique_ptr<Expr> end_expr;
    std::unique_ptr<Expr> step_expr;    // may be null (default = 1)
    std::vector<std::unique_ptr<Stmt>> body;       // full body, including EXIT

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct DefProcStmt : Stmt {
    using Stmt::Stmt;

    std::string name;                         // PROCname
    std::vector<std::string> params;          // A, B
    std::vector<std::string> locals;          // L
    std::vector<std::unique_ptr<Stmt>> body;  // statements inside PROC

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ProcCallStmt : Stmt {
    using Stmt::Stmt;

    std::string name;                         // PROCname
    std::vector<std::unique_ptr<Expr>> args;  // 10, 20

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LocalStmt : Stmt {
    using Stmt::Stmt;

    std::vector<std::string> locals;          // L

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct DefFnStmt : Stmt {
    using Stmt::Stmt;

    std::string name;                         // FNname
    std::vector<std::string> params;          // A, B
    std::unique_ptr<Expr> expr;               // A+B

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ExitStmt : Stmt {
    using Stmt::Stmt;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct GotoStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> target_expr;   // numeric expression or LabelLineRefExpr

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct GosubStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> target_expr;   // numeric expression or LabelLineRefExpr

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ReturnStmt : Stmt {
    using Stmt::Stmt;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct StopStmt : Stmt {
    using Stmt::Stmt;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct EndStmt : Stmt {
    using Stmt::Stmt;

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
    using Stmt::Stmt;

    std::vector<PrintItem> items;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct InputStmt : Stmt {
    using Stmt::Stmt;

    std::vector<std::unique_ptr<Expr>> vars;      // variables, array refs, slices

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RemStmt : Stmt {
    using Stmt::Stmt;

    std::string text;   // raw comment text

    // ASM statement if any
    std::vector<TokLine> asm_lines;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RunStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> target_expr;   // optional expression

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ListStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> target_expr;   // optional expression

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct NewStmt : Stmt {
    using Stmt::Stmt;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ClsStmt : Stmt {
    using Stmt::Stmt;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct LoadStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> filename_expr;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct SaveStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> filename_expr;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PokeStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> address;
    std::unique_ptr<Expr> value;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PokewStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> address;
    std::unique_ptr<Expr> value;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PlotStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> x_expr;
    std::unique_ptr<Expr> y_expr;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct UnplotStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> x_expr;
    std::unique_ptr<Expr> y_expr;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct RandStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> seed_expr;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PauseStmt : Stmt {
    using Stmt::Stmt;

    std::unique_ptr<Expr> duration_expr;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct FastStmt : Stmt {
    using Stmt::Stmt;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct SlowStmt : Stmt {
    using Stmt::Stmt;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ScrollStmt : Stmt {
    using Stmt::Stmt;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ContStmt : Stmt {
    using Stmt::Stmt;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct ClearStmt : Stmt {
    using Stmt::Stmt;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PragmaNumVarStmt : Stmt {
    using Stmt::Stmt;

    std::string name;
    double value;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PragmaStrVarStmt : Stmt {
    using Stmt::Stmt;

    std::string name;
    std::string value;

    // ASM statement if any
    std::vector<TokLine> asm_lines;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PragmaNumVarArrayStmt : Stmt {
    using Stmt::Stmt;

    std::string name;
    std::vector<int> dims;			// dimensions
    std::vector<double> values;

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

struct PragmaStrVarArrayStmt : Stmt {
    using Stmt::Stmt;

    std::string name;
    std::vector<int> dims;			// dimensions
    std::vector<std::string> values;

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

#ifdef _DEBUG
    void dump(DumpContext ctx) const override;
#endif
};

