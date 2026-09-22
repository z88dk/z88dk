//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "ast.h"
#include "errors.h"
#include "lexer.h"
#include <memory>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

bool parse_basic(const TokFile& tok_file,
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

    ExprPtr parse_expr();
    ExprPtr parse_assignable();

private:
    using StmtParser = StmtPtr (Parser::*)();
    static std::unordered_map<Keyword, StmtParser> pragma_parsers_lut;
    static std::unordered_map<Keyword, StmtParser> stmt_parsers_lut;

    [[noreturn]] void syntax_error(const std::string& msg) const;

    static bool is_func_one_arg(Keyword keyword);
    static bool is_func_zero_arg(Keyword keyword);
    static bool has_TO(const std::vector<Token>& tokens, size_t pos);

    // numbers
    double expect_int_or_float();

    // expression parsers
    ExprPtr parse_primary();
    ExprPtr parse_unary_expr();
    ExprPtr parse_pow_expr();
    ExprPtr parse_mul_expr();
    ExprPtr parse_add_expr();
    ExprPtr parse_rel_expr();
    ExprPtr parse_and_expr();
    ExprPtr parse_or_expr();

    // statement parsers
    void parse_stmt_block(const std::unordered_set<Keyword>& stop_keywords,
                          Keyword& out_stop_keyword,
                          std::vector<StmtPtr>& out_stmts);
    void parse_stmt_line(const std::unordered_set<Keyword>& stop_keywords,
                         Keyword& out_stop_keyword,
                         std::vector<StmtPtr>& out_stmts);
    void parse_stmt_list(const std::unordered_set<Keyword>& stop_keywords,
                         Keyword& out_stop_keyword,
                         std::vector<StmtPtr>& out_stmts);
    StmtPtr parse_stmt();
    bool parse_label_line_num(std::string& out_label, int& out_basic_line_num);

    StmtPtr create_rem_stmt();
    void collect_asm_lines(size_t start_line, std::vector<TokLine>& out_asm_lines);

    // pragma parsers
    StmtPtr parse_pragma_autostart();
    StmtPtr parse_pragma_autostart_line();
    StmtPtr parse_pragma_increment();
    StmtPtr parse_pragma_reminvert();
    StmtPtr parse_pragma_fast();
    StmtPtr parse_pragma_verbose();
    StmtPtr parse_pragma_vars();
    void parse_vars_def(std::string& out_var_name, std::vector<int>& out_dims);
    StmtPtr parse_pragma_dfile();
    StmtPtr parse_pragma_dfile_colapsed();
    StmtPtr parse_pragma_sysvars();

    // statement parsers
    StmtPtr parse_stmt_let();
    StmtPtr parse_stmt_dim();
    StmtPtr parse_stmt_if();
    StmtPtr parse_stmt_repeat();
    StmtPtr parse_stmt_while();
    StmtPtr parse_stmt_for();
    StmtPtr parse_stmt_def();
    StmtPtr parse_stmt_def_proc(const std::string& name);
    StmtPtr parse_stmt_def_fn(const std::string& name);
    StmtPtr parse_stmt_proc_call();
    StmtPtr parse_stmt_local();
    StmtPtr parse_stmt_exit();
    StmtPtr parse_stmt_goto();
    StmtPtr parse_stmt_gosub();
    StmtPtr parse_stmt_return();
    StmtPtr parse_stmt_stop();
    StmtPtr parse_stmt_end();
    StmtPtr parse_stmt_print();
    StmtPtr parse_stmt_lprint();
    StmtPtr parse_stmt_input();
    StmtPtr parse_stmt_rem();
    StmtPtr parse_stmt_run();
    StmtPtr parse_stmt_new();
    StmtPtr parse_stmt_cls();
    StmtPtr parse_stmt_load();
    StmtPtr parse_stmt_save();
    StmtPtr parse_stmt_poke();
    StmtPtr parse_stmt_pokew();
    StmtPtr parse_stmt_rand();
    StmtPtr parse_stmt_pause();
    StmtPtr parse_stmt_fast();
    StmtPtr parse_stmt_slow();
    StmtPtr parse_stmt_list();
    StmtPtr parse_stmt_llist();
    StmtPtr parse_stmt_plot();
    StmtPtr parse_stmt_unplot();
    StmtPtr parse_stmt_scroll();
    StmtPtr parse_stmt_cont();
    StmtPtr parse_stmt_clear();
    StmtPtr parse_stmt_copy();

    std::unique_ptr<DimItem> parse_dim_item();
};

