//-----------------------------------------------------------------------------
// z80asm
// Floating point support
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "scanner.h"
#include "token.h"
#include <set>
#include <vector>
using namespace std;

class FloatExpr {
public:
	FloatExpr() = default;
	FloatExpr(const FloatExpr& other);
	FloatExpr& operator=(const FloatExpr& other);
	void clear();
	bool empty() const;
	bool parse(const string& line);
	bool parse(Scanner& in);
	double eval() const;
	string to_string() const;
	string rpn_to_string() const;

#ifdef UNIT_TESTS
	static void test();
#endif

private:
	vector<Token> m_infix;
	vector<Token> m_postfix;
	int m_pos0{ 0 };

	static inline set<Keyword> math_functions = {
		// one argument functions
		Keyword::SIN,
		Keyword::COS,
		Keyword::TAN,
		Keyword::ASIN, 
		Keyword::ACOS, 
		Keyword::ATAN, 
		Keyword::SINH,
		Keyword::COSH,
		Keyword::TANH,
		Keyword::EXP, 
		Keyword::LOG, 
		Keyword::LOG10, 
		Keyword::SQRT, 
		Keyword::CEIL, 
		Keyword::FLOOR,
		Keyword::FABS, 
		Keyword::ROUND,
		Keyword::TRUNC,

		// two argument functions
		Keyword::POW, 
		Keyword::ATAN2,
		Keyword::FMOD,
	};

    bool is_unary(Scanner& in) const;
	bool to_rpn(Scanner& in);
    bool check_RPN_syntax();
	static int precedence(Operator op);
	static bool is_right_associative(Operator op);
};

