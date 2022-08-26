//-----------------------------------------------------------------------------
// z80asm
// data model
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "lex.h"
#include <memory>
#include <set>
using namespace std;

class Section;
class Symbol;
class Instr;

class ExprResult {
public:
	ExprResult(int value = 0);

	int value() const { return m_value; }
	void set_value(int n) { m_value = n; }

	bool depends_on_asmpc() const { return m_depends_on_asmpc; }
	void set_depends_on_asmpc(bool f = true) { m_depends_on_asmpc = f; }

	bool depends_on_section() const { return m_depends_on_sections.size() == 1; }
	bool depends_on_cross_sections() const { return m_depends_on_sections.size() > 1; }
	void set_section_dependent(shared_ptr<Section> s) { m_depends_on_sections.insert(s); }

	bool depends_on_extern() const { return m_depends_on_extern; }
	void set_depends_on_extern(bool f = true) { m_depends_on_extern = f; }

	bool division_by_zero() const { return m_division_by_zero; }
	void set_division_by_zero(bool f = true) { m_division_by_zero = f; }

	static ExprResult merge(const ExprResult& a, const ExprResult& b);

private:
	int m_value{ 0 };
	bool m_depends_on_asmpc{ false };
	set<shared_ptr<Section>> m_depends_on_sections;
	bool m_depends_on_extern{ false };
	bool m_division_by_zero{ false };
};

//-----------------------------------------------------------------------------

class ExprNode {
public:
	enum class Type {
		Const, Symbol, Asmpc,
		TernCond, LogOr, LogXor, LogAnd, BinOr, BinXor, BinAnd,
		Lt, Le, Gt, Ge, Eq, Ne,
		LShift, RShift, Plus, Minus, Mult, Div, Mod, Power,
		UnaryPlus, UnaryMinus, LogNot, BinNot,
		Parens,
	};

	virtual Type type() const = 0;
	virtual ExprResult value() const = 0;

protected:
	vector<shared_ptr<ExprNode>> m_args;
};

class ConstNode : public ExprNode {
public:
	ConstNode(int value);
	Type type() const override { return Type::Const; }
	ExprResult value() const override;
private:
	int m_value;
};

class SymbolNode : public ExprNode {
public:
	SymbolNode(shared_ptr<Symbol> symbol);
	Type type() const override { return Type::Symbol; }
	ExprResult value() const override;
private:
	weak_ptr<Symbol> m_symbol;
};

class AsmpcNode : public ExprNode {
public:
	AsmpcNode(shared_ptr<Instr> instr);
	Type type() const override { return Type::Asmpc; }
	ExprResult value() const override;
private:
	weak_ptr<Instr> m_instr;
};

class TernCondNode : public ExprNode {
public:
	TernCondNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b, shared_ptr<ExprNode> c);
	Type type() const override { return Type::TernCond; }
	ExprResult value() const override;
};

class LogOrNode : public ExprNode {
public:
	LogOrNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::LogOr; }
	ExprResult value() const override;
};

class LogXorNode : public ExprNode {
public:
	LogXorNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::LogXor; }
	ExprResult value() const override;
};

class LogAndNode : public ExprNode {
public:
	LogAndNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::LogAnd; }
	ExprResult value() const override;
};

class BinOrNode : public ExprNode {
public:
	BinOrNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::BinOr; }
	ExprResult value() const override;
};

class BinXorNode : public ExprNode {
public:
	BinXorNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::BinXor; }
	ExprResult value() const override;
};

class BinAndNode : public ExprNode {
public:
	BinAndNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::BinAnd; }
	ExprResult value() const override;
};

class LtNode : public ExprNode {
public:
	LtNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Lt; }
	ExprResult value() const override;
};

class LeNode : public ExprNode {
public:
	LeNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Le; }
	ExprResult value() const override;
};

class GtNode : public ExprNode {
public:
	GtNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Gt; }
	ExprResult value() const override;
};

class GeNode : public ExprNode {
public:
	GeNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Ge; }
	ExprResult value() const override;
};

class EqNode : public ExprNode {
public:
	EqNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Eq; }
	ExprResult value() const override;
};

class NeNode : public ExprNode {
public:
	NeNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Ne; }
	ExprResult value() const override;
};

class LShiftNode : public ExprNode {
public:
	LShiftNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::LShift; }
	ExprResult value() const override;
};

class RShiftNode : public ExprNode {
public:
	RShiftNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::RShift; }
	ExprResult value() const override;
};

class PlusNode : public ExprNode {
public:
	PlusNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Plus; }
	ExprResult value() const override;
};

class MinusNode : public ExprNode {
public:
	MinusNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Minus; }
	ExprResult value() const override;
};

class MultNode : public ExprNode {
public:
	MultNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Mult; }
	ExprResult value() const override;
};

class DivNode : public ExprNode {
public:
	DivNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Div; }
	ExprResult value() const override;
};

class ModNode : public ExprNode {
public:
	ModNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Mod; }
	ExprResult value() const override;
};

class PowerNode : public ExprNode {
public:
	PowerNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Power; }
	ExprResult value() const override;
};

class UnaryPlusNode : public ExprNode {
public:
	UnaryPlusNode(shared_ptr<ExprNode> a);
	Type type() const override { return Type::UnaryPlus; }
	ExprResult value() const override;
};

class UnaryMinusNode : public ExprNode {
public:
	UnaryMinusNode(shared_ptr<ExprNode> a);
	Type type() const override { return Type::UnaryMinus; }
	ExprResult value() const override;
};

class LogNotNode : public ExprNode {
public:
	LogNotNode(shared_ptr<ExprNode> a);
	Type type() const override { return Type::LogNot; }
	ExprResult value() const override;
};

class BinNotNode : public ExprNode {
public:
	BinNotNode(shared_ptr<ExprNode> a);
	Type type() const override { return Type::BinNot; }
	ExprResult value() const override;
};

class ParensNode : public ExprNode {
public:
	ParensNode(shared_ptr<ExprNode> a);
	Type type() const override { return Type::Parens; }
	ExprResult value() const override;
};

//-----------------------------------------------------------------------------

class Expr {
public:
	Expr(Lexer& lexer);
	void clear();

	bool parse();				// parse expression, leave lexer after expression

	ExprResult eval_silent();
	ExprResult eval_noisy();

	bool in_parens();

private:
	Lexer&				m_lexer;			// point at expression to parse
	shared_ptr<ExprNode> m_root;			// root node of expression
	Location			m_location;			// location where defined

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

};

