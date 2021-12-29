//-----------------------------------------------------------------------------
// z80asm
// preprocessor
// // Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "if.h"
#include "lex.h"
#include <cstdint>
#include <vector>
using namespace std;

class FloatExpr {
public:
	FloatExpr(Lexer& lexer);

	bool parse();
	bool eval_error() const { return m_eval_error; }
	double value() const { return m_value; }

private:
	Lexer& m_lexer;
	double m_value{ 0.0 };
	bool   m_parse_error{ false };	// expression cound not be parsed
	bool   m_eval_error{ false };	// expression cound not be evaluated

	double parse_expr();
	double parse_addition();
	double parse_multiplication();
	double parse_power();
	double parse_unary();
	double parse_primary();
	double parse_func(double(*f)(double));
	double parse_func2(double(*f)(double, double));
};

class FloatRepr {
public:
	enum class Format { genmath, math48, z80, sdcc, am9511, ieee754, ieee754double, zx, zx81 };

	FloatRepr(double value = 0.0);

	double value() const { return m_value; };
	void set_value(double value) { m_value = value; }

	static Format format() { return m_format; }
	static void set_format(Format format) { m_format = format; }
	static bool set_format(const string& text);
	static string format_define();

	vector<uint8_t> get_bytes();
	string get_int_list();

private:
	double m_value;
	static inline Format m_format{ Format::genmath };		// TODO: define appropriate default
};

bool set_float_format(const char* format);
const char* get_float_format_define(void);
