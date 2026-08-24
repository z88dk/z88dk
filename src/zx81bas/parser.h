//-----------------------------------------------------------------------------
// zx81bas
// Copyright (C) Paulo Custodio, 2023-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

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

    bool parse_stmt_block(const std::unordered_set<Keyword>& stop_keywords,
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
    std::unique_ptr<Stmt> parse_stmt_rem();

};

