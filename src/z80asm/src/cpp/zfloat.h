//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "if.h"
#include "scan2.h"
#include <cstdint>
#include <vector>
using namespace std;

// expression parser
class FloatExpr {
public:
	bool parse(ScannedLine& line);
	bool eval_error() const { return m_eval_error; }
	double value() const { return m_value; }

private:
    ScannedLine* m_line{ nullptr };
	double m_value{ 0.0 };
	bool   m_parse_error{ false };	// expression could not be parsed
	bool   m_eval_error{ false };	// expression could not be evaluated

	double parse_expr();
	double parse_addition();
	double parse_multiplication();
	double parse_power();
	double parse_unary();
	double parse_primary();
	double parse_func(double(*f)(double));
	double parse_func2(double(*f)(double, double));
};

// current Float format
class FloatFormat {
public:
	enum class Format {
#define X(type)		type,
#include "zfloat.def"
	};

	Format get() const { return m_format; }
	string get_type() const;
	string get_define() const;
	void set(Format format) { m_format = format; }
	bool set_text(const string& text);

	vector<uint8_t> float_to_bytes(double value);

    static string get_all_formats();
    static vector<string> get_all_defines();

private:
	Format m_format{ Format::genmath };
};

extern FloatFormat g_float_format;

vector<uint8_t> float_to_genmath(double value);
vector<uint8_t> float_to_math48(double value);
vector<uint8_t> float_to_z80(double value);
vector<uint8_t> float_to_ieee16(double value);
vector<uint8_t> float_to_ieee32(double value);
vector<uint8_t> float_to_ieee64(double value);
vector<uint8_t> float_to_zx(double value);
vector<uint8_t> float_to_zx81(double value);
vector<uint8_t> float_to_z88(double value);
vector<uint8_t> float_to_mbfs(double value);
vector<uint8_t> float_to_mbf40(double value);
vector<uint8_t> float_to_mbf64(double value);
vector<uint8_t> float_to_am9511(double value);
