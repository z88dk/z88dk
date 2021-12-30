//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2021
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "float.h"
#include "utils.h"
#include <cassert>
#include <cerrno>
#include <cmath>
#include <iostream>
#include <unordered_map>

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

void FloatRepr::set_format(Format format) {
	// ser current format
	c_format = format;

	// set format characterisitics
	switch (format) {
#define X(type, fp_size, fp_exponent_bias, fp_mantissa_bytes, fp_fudge_offset) \
	case Format::type: \
		c_fp_size = fp_size; \
		c_fp_exponent_bias = fp_exponent_bias; \
		c_fp_mantissa_bytes = fp_mantissa_bytes; \
		c_fp_fudge_offset = fp_fudge_offset; \
		break;
#include "float.def"
	default:
		assert(0);
	}
}

bool FloatRepr::set_format(const string& text) {
	// map "genmath" -> Format::genmath, ...
	static unordered_map<string, Format> map = {
#define X(type, fp_size, fp_exponent_bias, fp_mantissa_bytes, fp_fudge_offset)	\
		{ #type, Format::type },
#include "float.def"
	};

	auto found = map.find(text);
	if (found == map.end()) {	// not found
		error_invalid_float_format();
		cerr << "Available float formats:";
#define X(type, fp_size, fp_exponent_bias, fp_mantissa_bytes, fp_fudge_offset)	\
		cerr << " " #type;
#include "float.def"
		cerr << endl;
		return false;
	}
	else {
		set_format(found->second);
		return true;
	}
}

string FloatRepr::format_define() {
	// map Format::genmath -> "genmath", ...
	static unordered_map<Format, string> map = {
#define X(type, fp_size, fp_exponent_bias, fp_mantissa_bytes, fp_fudge_offset)	\
		{ Format::type, #type },
#include "float.def"
	};

	// build "__FLOAT_<TYPE>__"
	auto found = map.find(c_format);
	assert(found != map.end());

	string define_name = str_toupper("__FLOAT_" + found->second + "__");
	return define_name;
}

vector<uint8_t> FloatRepr::convert() {
	// convert into c_fp_size, m_fa
	switch (c_format) {
#define X(type, fp_size, fp_exponent_bias, fp_mantissa_bytes, fp_fudge_offset)	\
	case Format::type: convert__##type(); break;
#include "float.def"
	default:
		assert(0); 
	}

	// move to vector<uint8_t>
	vector<uint8_t> bytes;
	bytes.resize(c_fp_size);
	for (int i = 0; i < c_fp_size; i++)
		bytes[i] = m_fa[i];
	return bytes;
}

// code from sccz80
void FloatRepr::convert__genmath() {
	struct fp_decomposed fs = { 0 };
	int offs = MAX_MANTISSA_SIZE - c_fp_mantissa_bytes;
	int i;

	decompose_float(m_value, &fs);

	for (i = offs; i < MAX_MANTISSA_SIZE; i++) 
		m_fa[i - offs + c_fp_fudge_offset] = fs.mantissa[i];
	
	m_fa[i - offs - 1 + c_fp_fudge_offset] |= fs.sign ? 0x80 : 0;
	m_fa[i - offs + c_fp_fudge_offset] = fs.exponent;
}

void FloatRepr::convert__math48() {
	convert__genmath();		// TODO: remove?
}

#if 0
void FloatRepr::convert__z88() {
	convert__genmath();
}

void FloatRepr::convert__ieee() {
	c_fp_size = 4;
	c_fp_mantissa_bytes = 5;
	c_fp_exponent_bias = 128;
	
	if (isnan(m_value)) {
		// quiet nan: 7FC00000
		// signalling nan: 7F800001
		pack32bit_float(0x7fc00000);
	}
	else if (isinf(m_value) && m_value > 0) {
		// positive infinity: 7F800000
		pack32bit_float(0x7f800000);
	}
	else if (isinf(m_value) && m_value < 0) {
		// negative infinity: FF800000
		pack32bit_float(0xff800000);
	}
	else {
		struct fp_decomposed fs;
		uint32_t fp_value = 0;

		decompose_float(m_value, &fs);

		// Bundle up mantissa
		fp_value = (((uint32_t)fs.mantissa[4]) |
			(((uint32_t)fs.mantissa[5]) << 8) |
			(((uint32_t)fs.mantissa[6]) << 16)) & 0x007fffff;

		// And now the exponent
		fp_value |= (((uint32_t)fs.exponent) << 23);

		// And the sign bit
		fp_value |= fs.sign ? 0x80000000 : 0x00000000;
		pack32bit_float(fp_value);
	}
}

void FloatRepr::convert__mbfs() {
	c_fp_size = 4;
	c_fp_mantissa_bytes = 5;
	c_fp_exponent_bias = 128;

	struct fp_decomposed fs;
	uint32_t fp_value = 0;

	decompose_float(m_value, &fs);

	// Bundle up mantissa
	fp_value = (((uint32_t)fs.mantissa[4]) |
		(((uint32_t)fs.mantissa[5]) << 8) |
		(((uint32_t)fs.mantissa[6]) << 16)) & 0x007fffff;

	// And now the exponent
	fp_value |= (((uint32_t)fs.exponent) << 24);

	// And the sign bit
	fp_value |= fs.sign ? 0x00800000 : 0x00000000;
	pack32bit_float(fp_value);
}

void FloatRepr::convert__mbf40() {
	c_fp_size = 5;
	c_fp_mantissa_bytes = 5;
	c_fp_exponent_bias = 128;

	struct fp_decomposed fs;

	decompose_float(m_value, &fs);

	memcpy(m_fa, fs.mantissa + 3, 4);
	m_fa[3] |= fs.sign ? 0x80 : 00;
	m_fa[4] = fs.exponent;
}

void FloatRepr::convert__mbf64() {
	c_fp_size = 8;
	c_fp_mantissa_bytes = 5;
	c_fp_exponent_bias = 128;

	struct fp_decomposed fs;

	decompose_float(m_value, &fs);

	memcpy(m_fa, fs.mantissa, 7);
	m_fa[6] |= fs.sign ? 0x80 : 00;
	m_fa[7] = fs.exponent;
}

void FloatRepr::convert__ieee16() {
	c_fp_size = 2;
	c_fp_mantissa_bytes = 2;
	c_fp_exponent_bias = 14;

	if (isnan(m_value)) {
		m_fa[0] = 0xff;
		m_fa[1] = 0xff;
	}
	else if (isinf(m_value) && m_value > 0) {
		// positive infinity: 7c00
		m_fa[0] = 0x00;
		m_fa[1] = 0x7c;
	}
	else if (isinf(m_value) && m_value < 0) {
		// positive infinity: 7c00
		m_fa[0] = 0x00;
		m_fa[1] = 0xfc;
	}
	else {
		struct fp_decomposed fs;
		uint32_t fp_value = 0;

		decompose_float(m_value, &fs);

		// Bundle up mantissa - it's only 10 bits
		fp_value = ((((uint32_t)fs.mantissa[6]) << 3) |
			((((uint32_t)fs.mantissa[5]) >> 5) & 0x07)) & 0x3ff;

		// And now the exponent
		fp_value |= (((uint32_t)fs.exponent) << 10) & 0x7fc0;

		// And the sign bit
		fp_value |= fs.sign ? 0x8000 : 0x0000;
		m_fa[0] = fp_value & 0xff;
		m_fa[1] = (fp_value & 0xff00) >> 8;
	}
}

void FloatRepr::convert__am9511() {
	c_fp_size = 4;
	c_fp_mantissa_bytes = 5;
	c_fp_exponent_bias = 128;

	struct fp_decomposed fs;
	uint32_t fp_value = 0;

	if (m_value != 0.0) {
		decompose_float(m_value, &fs);

		// Bundle up mantissa
		fp_value = (((uint32_t)fs.mantissa[4]) |
			(((uint32_t)fs.mantissa[5]) << 8) |
			(((uint32_t)fs.mantissa[6]) << 16)) |
			0x00800000;

		// And now the exponent
		fp_value |= ((((uint32_t)fs.exponent) << 24) & 0x7f000000);

		// And the sign bit
		fp_value |= fs.sign ? 0x80000000 : 0x00000000;
	}
	pack32bit_float(fp_value);
}

void FloatRepr::convert__zx() {
}

void FloatRepr::convert__zx81() {
}
#endif

string FloatRepr::convert_int_list() {
	vector<uint8_t> bytes = convert();
	string out;
	if (bytes.size() > 0) {
		for (auto b : bytes)
			out += std::to_string(b) + ",";
		out.pop_back();
	}
	return out;
}

void FloatRepr::pack32bit_float(uint32_t val) {
	m_fa[0] = val & 0xff;
	m_fa[1] = (val >> 8) & 0xff;
	m_fa[2] = (val >> 16) & 0xff;
	m_fa[3] = (val >> 24) & 0xff;
}

void FloatRepr::decompose_float(double raw, fp_decomposed* fs) {
	double norm;
	double x = fabs(raw);
	double exp = log(x) / log(2);
	int i;
	int mant_bytes = c_fp_mantissa_bytes;
	int exp_bias = c_fp_exponent_bias;

	fs->sign = 0;
	fs->exponent = 0;

	for (i = 0; i < MAX_MANTISSA_SIZE; i++) {
		fs->mantissa[i] = 0;
	}

	if (mant_bytes > MAX_MANTISSA_SIZE) {
		mant_bytes = MAX_MANTISSA_SIZE;
	}

	if (x == 0.0) {
		memset(fs->mantissa, 0, MAX_MANTISSA_SIZE + 1);
		return;
	}

	if (floor(exp) == ceil(exp)) {
		exp = ceil(exp) + 1;
	}
	else {
		exp = ceil(exp);
	}

	norm = x / pow(2, exp);

	fs->exponent = (int)exp + exp_bias;
	for (i = 0; i < (mant_bytes * 2) + 1; i++) {
		double mult = norm * 16.;
		double res = floor(mult);
		unsigned char bit = (unsigned char)res;

		if (i == 0 && raw > 0)
			bit -= 8;
		if (i == mant_bytes * 2) {
			if (bit > 7) {
				int carry = 1;
				for (i = MAX_MANTISSA_SIZE - mant_bytes; i < MAX_MANTISSA_SIZE; i++) {
					int res = fs->mantissa[i] + carry;

					fs->mantissa[i] = res % 256;
					carry = res / 256;
				}
			}
			break;
		}
		if (i % 2 == 0) {
			fs->mantissa[(MAX_MANTISSA_SIZE - 1) - i / 2] = (bit << 4);
		}
		else {
			fs->mantissa[(MAX_MANTISSA_SIZE - 1) - i / 2] |= (bit & 0x0f);
		}
		norm = mult - res;
	}
	if (raw < 0) {
		fs->sign = 1;
	}
}

bool set_float_format(const char* format) {
	return FloatRepr::set_format(format);
}

const char* get_float_format_define(void) {
	static string define;		// need to return c_str() of string
	define = FloatRepr::format_define();
	return define.c_str();
}
