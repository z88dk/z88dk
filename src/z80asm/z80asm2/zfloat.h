//-----------------------------------------------------------------------------
// z80asm - floating point values
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "utils.h"
#include "scan.h"
#include <string>
#include <vector>
using namespace std;

// expression parser
class FloatExpr {
public:
    bool parse(Lexer& lexer);
    bool eval_error() const;
    double value() const;

private:
    Lexer* lexer_{ nullptr };
    double value_{ 0.0 };
    bool   parse_error_{ false };	// expression could not be parsed
    bool   eval_error_{ false };	// expression could not be evaluated

    double parse_expr();
    double parse_addition();
    double parse_multiplication();
    double parse_power();
    double parse_unary();
    double parse_primary();
    double parse_func(double(*f)(double));
    double parse_func2(double(*f)(double, double));
};

// float format
enum float_format_t {
#define X(type)         FLOAT_##type,
#include "zfloat.def"
};

class FloatFormat {
public:
    FloatFormat();
    void clear();

    float_format_t get() const;
    string get_type() const;
    string get_define() const;
    void set(float_format_t format);
    bool set_text(const string& text);

    vector<byte_t> float_to_bytes(double value);

    static string get_all_formats();
    static vector<string> get_all_defines();

private:
    float_format_t float_format_;
};

vector<byte_t> float_to_genmath(double value);
vector<byte_t> float_to_math48(double value);
vector<byte_t> float_to_z80(double value);
vector<byte_t> float_to_ieee16(double value);
vector<byte_t> float_to_ieee32(double value);
vector<byte_t> float_to_ieee64(double value);
vector<byte_t> float_to_zx(double value);
vector<byte_t> float_to_zx81(double value);
vector<byte_t> float_to_z88(double value);
vector<byte_t> float_to_mbfs(double value);
vector<byte_t> float_to_mbf40(double value);
vector<byte_t> float_to_mbf64(double value);
vector<byte_t> float_to_am9511(double value);
