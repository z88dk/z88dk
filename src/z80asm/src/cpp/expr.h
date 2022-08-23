//-----------------------------------------------------------------------------
// z80asm
// expressions
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "lex.h"
#include <memory>
#include <string>
#include <vector>
using namespace std;

class Asm;
class Lexer;
class Symbol;
class Symtab;

class ExprNode {
public:
	enum class Type {
		LeafNumber, LeafSymbol, LeafASMPC,
		TernCond, LogOr, LogXor, LogAnd, BinOr, BinXor, BinAnd,
		Lt, Le, Gt, Ge, Eq, Ne,
		LShift, RShift, Plus, Minus, Mult, Div, Mod, Power,
		UnaryPlus, UnaryMinus, LogNot, BinNot,
		Parens,
	};

	ExprNode(Type type = Type::LeafNumber,
		shared_ptr<ExprNode> arg1 = nullptr,
		shared_ptr<ExprNode> arg2 = nullptr,
		shared_ptr<ExprNode> arg3 = nullptr);

	ExprNode(int n);
	ExprNode(shared_ptr<Symbol> symbol);

	Type type() const { return m_type; }
	int value() const { return m_value; }
	shared_ptr<Symbol> symbol() const { return m_symbol; };
	shared_ptr<ExprNode> arg(size_t i);

private:
	Type		m_type{ Type::LeafNumber };	// type of node
	int			m_value{ 0 };				// for LeafNumber
	shared_ptr<Symbol> m_symbol;			// for LeafSymbol
	vector<shared_ptr<ExprNode>> m_args;	// for other operators
};

class Expr {
public:
	Expr(Lexer& lexer);
	void clear();

	int value() const { return m_value; }
	ErrCode result() const { return m_result; }
	const string& text() const { return m_text; }
	bool is_const() const { return m_is_const; }
	const Location& location() const { return m_location; }

	bool parse();				// parse expression, leave lexer after expression
	bool parse_at_end();		// parse expression, issue error if not end of statement

	bool eval_silent(int asmpc);
	bool eval_noisy(int asmpc);

	bool in_parens();

private:
	Lexer&				m_lexer;			// point at expression to parse
	shared_ptr<ExprNode> m_root;			// root node of expression
	int					m_value{ 0 };		// value computed during eval
	ErrCode				m_result{ ErrCode::Ok };// result computed during eval
	string				m_text;				// expression text
	int					m_asmpc{ 0 };		// ASMPC value
	bool				m_silent{ false };	// silence errors
	bool				m_is_const{ true };	// is a contant expression
	bool				m_evaluating{ false };	// detect recursive evals
	Location			m_location;			// location where defined

	void error(ErrCode err, const string& text);

	TType ttype() const { return m_lexer.peek().ttype; }
	const Token& token() const { return m_lexer.peek(); }
	void next() { m_lexer.next(); }

	shared_ptr<ExprNode> parse_expr();
	shared_ptr<ExprNode> parse_ternary_condition();
	shared_ptr<ExprNode> parse_logical_or();
	shared_ptr<ExprNode> parse_logical_and();
	shared_ptr<ExprNode> parse_binary_or();
	shared_ptr<ExprNode> parse_binary_and();
	shared_ptr<ExprNode> parse_condition();
	shared_ptr<ExprNode> parse_shift();
	shared_ptr<ExprNode> parse_addition();
	shared_ptr<ExprNode> parse_multiplication();
	shared_ptr<ExprNode> parse_power();
	shared_ptr<ExprNode> parse_unary();
	shared_ptr<ExprNode> parse_primary();

	bool eval();
	int eval_node(shared_ptr<ExprNode> node);
	int eval_symbol(shared_ptr<Symbol> symbol);
};

class PatchExpr {
public:
	enum class Type {
		UByte, SByte,					// unsigned and signed bytes
		Word, BEWord,					// word and big-endian word (2 bytes)
		Ptr24,							// poiter (3 bytes)
		Dword,							// double word (4 bytes)
		JrOffset,						// jump relative offset
		UByte2Word,						// unsigned byte extended to 16 bits
		SByte2Word,						// signed byte extended to 16 bits
		HighOffset,						// byte offset to 0xFF00 
	};

	PatchExpr(shared_ptr<Expr> expr, Type type = Type::UByte, size_t offset = 0);

	Type type() const { return m_type; }
	size_t offset() const { return m_offset; }
	shared_ptr<Expr> expr() { return m_expr; }

private:
	Type	m_type;						// type of patch
	size_t	m_offset;					// offset to start of instruction to patch
	shared_ptr<Expr>	m_expr;			// expression to compute
};
