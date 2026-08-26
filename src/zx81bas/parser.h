//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast_expr.h"
#include "ast_stmt.h"
#include "lexer.h"
#include <memory>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

bool parse_basic_program(const TokFile& tok_file,
                         std::unique_ptr<Prog>& out_prog);

// Thrown by Parser::syntax_error() to abort parsing of the current
// statement/line; caught by Parser::parse() so parsing can resume at
// the next line.
struct ParseError : std::runtime_error {
    using std::runtime_error::runtime_error;
};

struct Parser {
    Prog& prog;                 // reference to the program being built
    const TokFile& tok_file;	// input lines to parse
    size_t cur_line = 0;        // current line index
    size_t pos = 0;             // current token index

    // entry point: parse all lines into prog.
    // returns false if any syntax errors were encountered.
    bool parse();

private:
    using StmtParser = std::unique_ptr<Stmt> (Parser::*)();
    static std::unordered_map<Keyword, StmtParser> pragma_parsers_lut;
    static std::unordered_map<Keyword, StmtParser> stmt_parsers_lut;

    [[noreturn]] void syntax_error(const std::string& msg) const;

    bool at_end() const;
    bool at_end_of_stmt() const;
    void check_end_of_stmt();
    bool match(TokenType type);
    bool match(Keyword keyword);
    const Token& expect(TokenType type);
    const Token& expect(Keyword keyword);
    const Token& peek(size_t offset = 0) const;
    const TokLine& line() const;
    const SourceLoc& loc() const;

    static bool is_string_variable(const std::string& name);
    static bool is_func_one_arg(Keyword keyword);
    static bool is_func_zero_arg(Keyword keyword);
    static bool has_TO(const std::vector<Token>& tokens, size_t pos);

    // expression parsers
    std::unique_ptr<Expr> parse_primary();
    std::unique_ptr<Expr> parse_unary_expr();
    std::unique_ptr<Expr> parse_pow_expr();
    std::unique_ptr<Expr> parse_mul_expr();
    std::unique_ptr<Expr> parse_add_expr();
    std::unique_ptr<Expr> parse_rel_expr();
    std::unique_ptr<Expr> parse_and_expr();
    std::unique_ptr<Expr> parse_or_expr();
    std::unique_ptr<Expr> parse_expr();
    std::unique_ptr<Expr> parse_assignable();

    // statement parsers
    void parse_stmt_block(const std::unordered_set<Keyword>& stop_keywords,
                          Keyword& out_stop_keyword,
                          std::vector<std::unique_ptr<Stmt>>& out_stmts);
    void parse_stmt_line(const std::unordered_set<Keyword>& stop_keywords,
                         Keyword& out_stop_keyword,
                         std::vector<std::unique_ptr<Stmt>>& out_stmts);
    void parse_stmt_list(const std::unordered_set<Keyword>& stop_keywords,
                         Keyword& out_stop_keyword,
                         std::vector<std::unique_ptr<Stmt>>& out_stmts);
    std::unique_ptr<Stmt> parse_stmt();
    bool parse_label_line_num(std::string& out_label, int& out_basic_line_num);

    std::unique_ptr<Stmt> create_rem_stmt();
    void collect_asm_lines(size_t start_line, std::vector<TokLine>& out_asm_lines);

    // pragma parsers
    std::unique_ptr<Stmt> parse_pragma_autostart();
    std::unique_ptr<Stmt> parse_pragma_autostart_line();
    std::unique_ptr<Stmt> parse_pragma_increment();
    std::unique_ptr<Stmt> parse_pragma_reminvert();
    std::unique_ptr<Stmt> parse_pragma_fast();
    std::unique_ptr<Stmt> parse_pragma_verbose();
    std::unique_ptr<Stmt> parse_pragma_vars();
    void parse_vars_def(std::string& out_var_name, std::vector<int>& out_dims);
    std::unique_ptr<Stmt> parse_pragma_dfile();
    std::unique_ptr<Stmt> parse_pragma_dfile_colapsed();
    std::unique_ptr<Stmt> parse_pragma_sysvars();

    // statement parsers
    std::unique_ptr<Stmt> parse_stmt_let();
    std::unique_ptr<Stmt> parse_stmt_dim();
    std::unique_ptr<Stmt> parse_stmt_if();
    std::unique_ptr<Stmt> parse_stmt_repeat();
    std::unique_ptr<Stmt> parse_stmt_while();
    std::unique_ptr<Stmt> parse_stmt_for();
    std::unique_ptr<Stmt> parse_stmt_def();
    std::unique_ptr<Stmt> parse_stmt_def_proc(const std::string& name);
    std::unique_ptr<Stmt> parse_stmt_def_fn(const std::string& name);
    std::unique_ptr<Stmt> parse_stmt_proc_call();
    std::unique_ptr<Stmt> parse_stmt_local();
    std::unique_ptr<Stmt> parse_stmt_exit();
    std::unique_ptr<Stmt> parse_stmt_goto();
    std::unique_ptr<Stmt> parse_stmt_gosub();
    std::unique_ptr<Stmt> parse_stmt_return();
    std::unique_ptr<Stmt> parse_stmt_stop();
    std::unique_ptr<Stmt> parse_stmt_end();
    std::unique_ptr<Stmt> parse_stmt_print();
    std::unique_ptr<Stmt> parse_stmt_input();
    std::unique_ptr<Stmt> parse_stmt_rem();
    std::unique_ptr<Stmt> parse_stmt_run();
    std::unique_ptr<Stmt> parse_stmt_new();
    std::unique_ptr<Stmt> parse_stmt_cls();
    std::unique_ptr<Stmt> parse_stmt_load();
    std::unique_ptr<Stmt> parse_stmt_save();
    std::unique_ptr<Stmt> parse_stmt_poke();
    std::unique_ptr<Stmt> parse_stmt_pokew();
    std::unique_ptr<Stmt> parse_stmt_rand();
    std::unique_ptr<Stmt> parse_stmt_pause();
    std::unique_ptr<Stmt> parse_stmt_fast();
    std::unique_ptr<Stmt> parse_stmt_slow();
    std::unique_ptr<Stmt> parse_stmt_list();
    std::unique_ptr<Stmt> parse_stmt_plot();
    std::unique_ptr<Stmt> parse_stmt_unplot();
    std::unique_ptr<Stmt> parse_stmt_scroll();
    std::unique_ptr<Stmt> parse_stmt_cont();
    std::unique_ptr<Stmt> parse_stmt_clear();

    std::unique_ptr<DimItem> parse_dim_item();

};

