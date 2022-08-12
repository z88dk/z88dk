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
	Expr();
	void clear();

	int value() const { return m_value; }
	ErrCode result() const { return m_result; }
	const string& text() const { return m_text; }
	bool is_const() const { return m_is_const; }
	const string& filename() const { return m_filename; }
	int line_num() const { return m_line_num; }

	bool parse(const string& text, shared_ptr<Symtab> symtab);
	bool parse(shared_ptr<Lexer> lexer, shared_ptr<Symtab> symtab);

	bool eval_silent(int asmpc);
	bool eval_noisy(int asmpc);

private:
	shared_ptr<ExprNode> m_root;			// root node of expression
	int					m_value{ 0 };		// value computed during eval
	ErrCode				m_result{ ErrCode::Ok };// result computed during eval
	shared_ptr<Lexer>	m_lexer;			// used while parsing
	shared_ptr<Symtab>	m_symtab;			// used while parsing
	string				m_text;				// expression text
	int					m_asmpc{ 0 };		// ASMPC value
	bool				m_silent{ false };	// silence errors
	bool				m_is_const{ true };	// is a contant expression
	string				m_filename;			// filename where defined
	int					m_line_num{ 0 };	// line number where defined

	void error(ErrCode err, const string& text);

	TType ttype() const { return m_lexer->peek().ttype; }
	const Token& token() const { return m_lexer->peek(); }
	void next() { m_lexer->next(); }

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
