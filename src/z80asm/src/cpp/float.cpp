//-----------------------------------------------------------------------------
// z80asm
// preprocessor
// // Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "float.h"
#include <cassert>
#include <cerrno>
#include <cmath>

FloatExpr::FloatExpr(Lexer& lexer)
	: m_lexer(lexer) {}

bool FloatExpr::parse() {
	m_parse_error = m_eval_error = false;
	errno = 0;
	m_value = parse_expr();
	if (errno != 0)
		m_eval_error = true;
	return !m_parse_error;
}

double FloatExpr::parse_expr() {
	return parse_addition();
}

double FloatExpr::parse_addition() {
	double a = parse_multiplication();
	if (m_parse_error) return 0.0;

	while (m_lexer.peek().is(TType::Plus, TType::Minus)) {
		TType op = m_lexer.peek().ttype;
		m_lexer.next();

		double b = parse_multiplication();
		if (m_parse_error) return 0.0;

		if (op == TType::Plus)
			a += b;
		else
			a -= b;
	}
	return a;
}

double FloatExpr::parse_multiplication() {
	double a = parse_power();
	if (m_parse_error) return 0.0;

	while (m_lexer.peek().is(TType::Mul, TType::Div)) {
		TType op = m_lexer.peek().ttype;
		m_lexer.next();

		double b = parse_power();
		if (m_parse_error) return 0.0;

		if (op == TType::Mul)
			a *= b;
		else if (b == 0.0) {
			m_eval_error = true;		// division by zero
			a = 0.0;
		}
		else
			a /= b;
	}
	return a;
}

double FloatExpr::parse_power() {
	double a = parse_unary();
	if (m_parse_error) return 0.0;

	while (m_lexer.peek().is(TType::Pow)) {
		m_lexer.next();

		double b = parse_power();
		if (m_parse_error) return 0.0;

		a = pow(a, b);
	}
	return a;
}

double FloatExpr::parse_unary() {
	double a;
	switch (m_lexer.peek().ttype) {
	case TType::Minus:
		m_lexer.next();
		a = parse_unary();
		if (m_parse_error) return 0.0;
		return -a;
	case TType::Plus:
		m_lexer.next();
		a = parse_unary();
		if (m_parse_error) return 0.0;
		return a;
	case TType::Lparen:
		m_lexer.next();
		a = parse_expr();
		if (m_parse_error) return 0.0;
		if (!m_lexer.peek().is(TType::Rparen)) {
			m_parse_error = true;
			return 0.0;
		}
		else
			return a;
	default:
		a = parse_primary();
		if (m_parse_error) return 0.0;
		return a;
	}
}

double FloatExpr::parse_primary() {
	double a;
	switch (m_lexer.peek().ttype) {
	case TType::Integer: 
		a = (double)m_lexer.peek().ivalue;
		m_lexer.next();
		return a;
	case TType::Floating: 
		a = m_lexer.peek().fvalue;
		m_lexer.next();
		return a;
	case TType::Ident:
        switch (m_lexer.peek().keyword) {
		case Keyword::SIN: m_lexer.next(); return parse_func(sin);
		case Keyword::COS: m_lexer.next(); return parse_func(cos);
		case Keyword::TAN: m_lexer.next(); return parse_func(tan);
		case Keyword::ASIN: m_lexer.next(); return parse_func(asin);
		case Keyword::ACOS: m_lexer.next(); return parse_func(acos);
		case Keyword::ATAN: m_lexer.next(); return parse_func(atan);
		case Keyword::ATAN2: m_lexer.next(); return parse_func2(atan2);
		case Keyword::SINH: m_lexer.next(); return parse_func(sinh);
		case Keyword::COSH: m_lexer.next(); return parse_func(cosh);
		case Keyword::TANH: m_lexer.next(); return parse_func(tanh);
        case Keyword::ASINH: m_lexer.next(); return parse_func(asinh);
        case Keyword::ACOSH: m_lexer.next(); return parse_func(acosh);
        case Keyword::ATANH: m_lexer.next(); return parse_func(atanh);
        case Keyword::LOG: m_lexer.next(); return parse_func(log);
        case Keyword::LOG10: m_lexer.next(); return parse_func(log10);
        case Keyword::LOG2: m_lexer.next(); return parse_func(log2);
        case Keyword::EXP: m_lexer.next(); return parse_func(exp);
        case Keyword::EXP2: m_lexer.next(); return parse_func(exp2);
        case Keyword::POW: m_lexer.next(); return parse_func2(pow);
        case Keyword::SQRT: m_lexer.next(); return parse_func(sqrt);
        case Keyword::CBRT: m_lexer.next(); return parse_func(cbrt);
        case Keyword::CEIL: m_lexer.next(); return parse_func(ceil);
        case Keyword::FLOOR: m_lexer.next(); return parse_func(floor);
        case Keyword::TRUNC: m_lexer.next(); return parse_func(trunc);
        case Keyword::ABS: m_lexer.next(); return parse_func(abs);
        case Keyword::HYPOT: m_lexer.next(); return parse_func2(hypot);
        case Keyword::FMOD: m_lexer.next(); return parse_func2(fmod);
		default:
			m_parse_error = true;
			return 0.0;
        }
	default:
		m_parse_error = true;
		return 0.0;
	}
}

double FloatExpr::parse_func(double(*f)(double)) {
	if (!m_lexer.peek().is(TType::Lparen)) {
		m_parse_error = true;
		return 0.0;
	}
	else {
		double a = parse_expr();
		if (m_parse_error) return 0.0;
		return f(a);
	}
}

double FloatExpr::parse_func2(double(*f)(double, double)) {
	if (!m_lexer.peek().is(TType::Lparen)) {
		m_parse_error = true;
		return 0.0;
	}
	else {
		m_lexer.next();
		double a = parse_expr();
		if (m_parse_error) return 0.0;

		if (!m_lexer.peek().is(TType::Comma)) {
			m_parse_error = true;
			return 0.0;
		}
		else {
			m_lexer.next();
			double b = parse_expr();
			if (m_parse_error) return 0.0;

			if (!m_lexer.peek().is(TType::Rparen)) {
				m_parse_error = true;
				return 0.0;
			}
			else {
				m_lexer.next();
				return f(a, b);
			}
		}
	}
}

FloatRepr::FloatRepr(double value)
	: m_value(value) {}

bool FloatRepr::set_format(const string& text) {
	if (text == "genmath") { set_format(Format::genmath); return true; }
	else if (text == "math48") { set_format(Format::math48); return true; }
	else if (text == "z80") { set_format(Format::z80); return true; }
	else if (text == "sdcc") { set_format(Format::sdcc); return true; }
	else if (text == "am9511") { set_format(Format::am9511); return true; }
	else if (text == "ieee754") { set_format(Format::ieee754); return true; }
	else if (text == "ieee754double") { set_format(Format::ieee754double); return true; }
	else if (text == "zx") { set_format(Format::zx); return true; }
	else if (text == "zx81") { set_format(Format::zx81); return true; }
	else return false;
}

string FloatRepr::format_define() {
	switch (m_format) {
	case Format::genmath: return "__FLOAT_GENMATH__";
	case Format::math48: return "__FLOAT_MATH48__";
	case Format::z80: return "__FLOAT_Z80__";
	case Format::sdcc: return "__FLOAT_SDCC__";
	case Format::am9511: return "__FLOAT_AM9511__";
	case Format::ieee754: return "__FLOAT_IEEE754__";
	case Format::ieee754double: return "__FLOAT_IEEE754DOUBLE__";
	case Format::zx: return "__FLOAT_ZX__";
	case Format::zx81: return "__FLOAT_ZX81__";
	default: assert(0); return "";
	}
}

vector<uint8_t> FloatRepr::get_bytes() {
	vector<uint8_t> bytes{ 0,0,0,0 };
	return bytes;
}

string FloatRepr::get_int_list() {
	vector<uint8_t> bytes = get_bytes();
	string out;
	if (bytes.size() > 0) {
		for (auto b : bytes)
			out += std::to_string(b) + ",";
		out.pop_back();
	}
	return out;
}

bool set_float_format(const char* format) {
	return FloatRepr::set_format(format);
}

const char* get_float_format_define(void) {
	static string define;		// need to return c_str() of string
	define = FloatRepr::format_define();
	return define.c_str();
}
