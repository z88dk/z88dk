//-----------------------------------------------------------------------------
// z80asm - parser
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "files.h"
#include "scan.h"
#include <deque>
#include <vector>
#include <string>
#include <object.h>
using namespace std;

class Assembler;
class Expr;

// parse source
class Parser {
public:
    Parser(Assembler& assembler);
    virtual ~Parser();
    Parser(const Parser& other) = delete;
    Parser& operator=(const Parser& other) = delete;

    bool parse(const string& filename);

private:
    enum State { ST_MAIN };

    State state_{ ST_MAIN };        // state of parser
    Assembler* assembler_;          // assembler instance
    int start_error_count_{ 0 };    // errors found before parse
    SourceReader source_reader_;    // source file reader
    Lexer lexer_;                   // scanner
    deque<Expr*> exprs_;           // list of expressions parsed
    deque<int> const_exprs_;       // list of const expressions parsed

    void error(ErrCode err_code);   // syntax error and flush lexer
    bool parse();                   // parse full input
    void parse_line();              // switch to each state-parser
    void parse_main();              // main state
    void parse_label();             // label, if any
    bool parse_directive();         // directive
    bool parse_opcode();            // opcode
    bool match_eos();               // match and consume ':', '\\', END
    void parse_action(int action);  // execute opcode parser action
    bool parse_expr();              // parse expression in input
    bool parse_const_expr();        // parse expression in input

    bool expr_in_parens();          // check if first expression is ()
    void warn_if_expr_in_parens();  // warning if expression in () and considered immediate
    void error_if_expr_not_in_parens(); // error if () expected
    void error_illegal_ident();     // issue error
    void error_int_range(int value);// issue error
    Instr* add_opcode(int opcode);  // add opcode without arguments

    // add opcode with one patch of the given range, adn with fixed delta added to expression
    Instr* add_opcode(int opcode, range_t range, int delta = 0); 
    Instr* add_opcode_n(int opcode, int delta = 0);     // RANGE_BYTE_UNSIGNED
    Instr* add_opcode_s(int opcode, int delta = 0);     // RANGE_BYTE_SIGNED
    Instr* add_opcode_h(int opcode, int delta = 0);     // RANGE_HIGH_OFFSET
    Instr* add_opcode_n_0(int opcode, int delta = 0);   // RANGE_BYTE_TO_WORD_UNSIGNED
    Instr* add_opcode_s_0(int opcode, int delta = 0);   // RANGE_BYTE_TO_WORD_SIGNED
    Instr* add_opcode_n_n(int opcode);                  // RANGE_BYTE_UNSIGNED, RANGE_BYTE_UNSIGNED
    Instr* add_opcode_nn(int opcode, int delta = 0);    // RANGE_WORD + fixed delta
    Instr* add_opcode_NN(int opcode, int delta = 0);    // RANGE_WORD_BE + fixed delta
    Instr* add_opcode_nnn(int opcode, int delta = 0);   // RANGE_PTR24 + fixed delta
    Instr* add_opcode_nnnn(int opcode, int delta = 0);  // RANGE_DWORD + fixed delta
    Instr* add_opcode_idx(int opcode, int delta = 0);   // RANGE_BYTE_SIGNED at third address
    void add_opcode_idx_idx1(int opcode1, int opcode2); // RANGE_BYTE_SIGNED, RANGE_BYTE_SIGNED+1
    Instr* add_opcode_idx_n(int opcode);                // RANGE_BYTE_SIGNED, RANGE_BYTE_UNSIGNED
    Instr* add_opcode_jr(int opcode);                   // RANGE_JR_OFFSET
    Instr* add_opcode_jre(int opcode);                  // RANGE_JRE_OFFSET

    Instr* add_call_function(const string& name);       // call to a library function
    Instr* add_call_function_n(const string& name);     // same with a byte argument
    void add_restart(int arg);

    Symbol* add_label(const string& name);
    string autolabel();
};
