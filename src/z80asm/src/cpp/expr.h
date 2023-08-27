//-----------------------------------------------------------------------------
// z80asm
// expressions
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include "scan.h"
#include <memory>
#include <set>
using namespace std;

class Section;
class Asm;
class ScannedLine;
class Symbol;
class Instr;

class ExprResult {
public:
	ExprResult(int value = 0);

	int value() const { return m_value; }
	void set_value(int n) { m_value = n; }

	bool is_const() const;

	bool depends_on_asmpc() const { return m_depends_on_asmpc; }
	void set_depends_on_asmpc(bool f = true) { m_depends_on_asmpc = f; }

	bool division_by_zero() const { return m_division_by_zero; }
	void set_division_by_zero(bool f = true) { m_division_by_zero = f; }

	bool recursive_expr() const { return m_recursive_expr; }
	void set_recursive_expr(bool f = true) { m_recursive_expr = f; }

	bool cross_section() const { return m_cross_section; }
	void set_cross_section(bool f = true) { m_cross_section = f; }

	bool undefined_symbol() const { return !m_undefined_symbols.empty(); }
    void set_undefined_symbol(const string& name) { m_undefined_symbols.insert(name); }
    string undefined_symbol_names() const;

	static ExprResult merge(const ExprResult& a, const ExprResult& b);

private:
	int m_value{ 0 };
	bool m_depends_on_asmpc{ false };
	bool m_cross_section{ false };
	bool m_division_by_zero{ false };
	bool m_recursive_expr{ false };
    set<string> m_undefined_symbols;			
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
	virtual ExprResult value() = 0;
	virtual string text() const = 0;

protected:
	vector<shared_ptr<ExprNode>> m_args;
};

class ConstNode : public ExprNode {
public:
	ConstNode(int value);
	Type type() const override { return Type::Const; }
	ExprResult value() override;
	string text() const override;
private:
	int m_value;
};

class SymbolNode : public ExprNode {
public:
	SymbolNode(shared_ptr<Symbol> symbol);
	Type type() const override { return Type::Symbol; }
	ExprResult value() override;
	string text() const override;
private:
	weak_ptr<Symbol> m_symbol;
	bool m_in_eval{ false };		// detect recursion
};

class AsmpcNode : public ExprNode {
public:
	AsmpcNode(shared_ptr<Instr> instr);
	Type type() const override { return Type::Asmpc; }
	ExprResult value() override;
	string text() const override;
private:
	weak_ptr<Instr> m_instr;
};

class TernCondNode : public ExprNode {
public:
	TernCondNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b, shared_ptr<ExprNode> c);
	Type type() const override { return Type::TernCond; }
	ExprResult value() override;
	string text() const override;
};

class LogOrNode : public ExprNode {
public:
	LogOrNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::LogOr; }
	ExprResult value() override;
	string text() const override;
};

class LogXorNode : public ExprNode {
public:
	LogXorNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::LogXor; }
	ExprResult value() override;
	string text() const override;
};

class LogAndNode : public ExprNode {
public:
	LogAndNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::LogAnd; }
	ExprResult value() override;
	string text() const override;
};

class BinOrNode : public ExprNode {
public:
	BinOrNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::BinOr; }
	ExprResult value() override;
	string text() const override;
};

class BinXorNode : public ExprNode {
public:
	BinXorNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::BinXor; }
	ExprResult value() override;
	string text() const override;
};

class BinAndNode : public ExprNode {
public:
	BinAndNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::BinAnd; }
	ExprResult value() override;
	string text() const override;
};

class LtNode : public ExprNode {
public:
	LtNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Lt; }
	ExprResult value() override;
	string text() const override;
};

class LeNode : public ExprNode {
public:
	LeNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Le; }
	ExprResult value() override;
	string text() const override;
};

class GtNode : public ExprNode {
public:
	GtNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Gt; }
	ExprResult value() override;
	string text() const override;
};

class GeNode : public ExprNode {
public:
	GeNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Ge; }
	ExprResult value() override;
	string text() const override;
};

class EqNode : public ExprNode {
public:
	EqNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Eq; }
	ExprResult value() override;
	string text() const override;
};

class NeNode : public ExprNode {
public:
	NeNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Ne; }
	ExprResult value() override;
	string text() const override;
};

class LShiftNode : public ExprNode {
public:
	LShiftNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::LShift; }
	ExprResult value() override;
	string text() const override;
};

class RShiftNode : public ExprNode {
public:
	RShiftNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::RShift; }
	ExprResult value() override;
	string text() const override;
};

class PlusNode : public ExprNode {
public:
	PlusNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Plus; }
	ExprResult value() override;
	string text() const override;
};

class MinusNode : public ExprNode {
public:
	MinusNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Minus; }
	ExprResult value() override;
	string text() const override;
};

class MultNode : public ExprNode {
public:
	MultNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Mult; }
	ExprResult value() override;
	string text() const override;
};

class DivNode : public ExprNode {
public:
	DivNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Div; }
	ExprResult value() override;
	string text() const override;
};

class ModNode : public ExprNode {
public:
	ModNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Mod; }
	ExprResult value() override;
	string text() const override;
};

class PowerNode : public ExprNode {
public:
	PowerNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b);
	Type type() const override { return Type::Power; }
	ExprResult value() override;
	string text() const override;
};

class UnaryPlusNode : public ExprNode {
public:
	UnaryPlusNode(shared_ptr<ExprNode> a);
	Type type() const override { return Type::UnaryPlus; }
	ExprResult value() override;
	string text() const override;
};

class UnaryMinusNode : public ExprNode {
public:
	UnaryMinusNode(shared_ptr<ExprNode> a);
	Type type() const override { return Type::UnaryMinus; }
	ExprResult value() override;
	string text() const override;
};

class LogNotNode : public ExprNode {
public:
	LogNotNode(shared_ptr<ExprNode> a);
	Type type() const override { return Type::LogNot; }
	ExprResult value() override;
	string text() const override;
};

class BinNotNode : public ExprNode {
public:
	BinNotNode(shared_ptr<ExprNode> a);
	Type type() const override { return Type::BinNot; }
	ExprResult value() override;
	string text() const override;
};

class ParensNode : public ExprNode {
public:
	ParensNode(shared_ptr<ExprNode> a);
	Type type() const override { return Type::Parens; }
	ExprResult value() override;
	string text() const override;
};

//-----------------------------------------------------------------------------

class Expr {
public:
	Expr();
	void clear();
	string text() const;
    const Location& location() const { return m_location; }
    shared_ptr<Section> section() { return m_section.lock(); }

	bool parse(ScannedLine& line);          // parse expression, leave lexer after expression
    bool parse_if_statement(ScannedLine& line); // parse expression after IF
    bool can_parse(ScannedLine& line);      // check if expression can be parsed, leves lexer at start if not

	ExprResult eval_silent() const;
	ExprResult eval_noisy() const;

	bool in_parens() const;
	bool is_const() const;

private:
	shared_ptr<ExprNode> m_root;			// root node of expression
	Location			m_location;			// location where defined
	weak_ptr<Section>	m_section;			// section where defined
    ScannedLine*        m_line{nullptr};    // point at expression to parse during parse
    bool                m_parsing_if_statement{ false };    // if true does not add new symbols
    bool                m_in_can_parse{ false };            // if true does not issue errors

	TType ttype() const { return m_line->peek().type(); }
	const Token& token() const { return m_line->peek(); }
	void next() { m_line->next(); }

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

//-----------------------------------------------------------------------------

class Patch {
public:
    // NOTE: keep in sync with objfile.c range_t!
	enum class Type {
        UNKNOWN,                    // 0  
        JR_OFFSET,                  // 1  "J"
        BYTE_UNSIGNED,              // 2  "U"
        BYTE_SIGNED,                // 3  "S"
        WORD,						// 4  "W"  // 16-bit value little-endian
        WORD_BE,					// 5  "B"  // 16-bit value big-endian
        DWORD,                      // 6  "L"  // 32-bit signed
        BYTE_TO_WORD_UNSIGNED,      // 7  "u"  // unsigned byte extended to 16 bits
        BYTE_TO_WORD_SIGNED,        // 8  "s"  // signed byte sign-extended to 16 bits
        PTR24,					    // 9  "P"  // 24-bit pointer
        HIGH_OFFSET,				// 10 "H"  // byte offset to 0xFF00
        ASSIGNMENT,                 // 11 "="  // DEFC expression assigning a symbol
        JRE_OFFSET,                 // 12 "j"  // 16-bit relative offset for JRE
    };

	Patch(shared_ptr<Expr> expr, int offset = 0);
	virtual Type type() const = 0;
	virtual int size() const = 0;
	virtual void do_patch(vector<uint8_t>& bytes, int asmpc) = 0;

	shared_ptr<Expr> expr() const { return m_expr; }
	int offset() const { return m_offset; }
	void set_offset(int n) { m_offset = n; }

protected:
	shared_ptr<Expr> m_expr;			// expression to compute
	int		m_offset{ 0 };				// offset to start of instruction to patch
};

class UBytePatch : public Patch {
public:
	UBytePatch(shared_ptr<Expr> expr, int offset = 0) : Patch(expr, offset) {}
	Type type() const override { return Type::BYTE_UNSIGNED; }
	int size() const override { return 1; }
	void do_patch(vector<uint8_t>& bytes, int asmpc) override;
};

class SBytePatch : public Patch {
public:
	SBytePatch(shared_ptr<Expr> expr, int offset = 0) : Patch(expr, offset) {}
	Type type() const override { return Type::BYTE_SIGNED; }
	int size() const override { return 1; }
	void do_patch(vector<uint8_t>& bytes, int asmpc) override;
};

class WordPatch : public Patch {
public:
	WordPatch(shared_ptr<Expr> expr, int offset = 0) : Patch(expr, offset) {}
	Type type() const override { return Type::WORD; }
	int size() const override { return 2; }
	void do_patch(vector<uint8_t>& bytes, int asmpc) override;
};

class BEWordPatch : public Patch {
public:
	BEWordPatch(shared_ptr<Expr> expr, int offset = 0) : Patch(expr, offset) {}
	Type type() const override { return Type::WORD_BE; }
	int size() const override { return 2; }
	void do_patch(vector<uint8_t>& bytes, int asmpc) override;
};

class Ptr24Patch : public Patch {
public:
	Ptr24Patch(shared_ptr<Expr> expr, int offset = 0) : Patch(expr, offset) {}
	Type type() const override { return Type::PTR24; }
	int size() const override { return 3; }
	void do_patch(vector<uint8_t>& bytes, int asmpc) override;
};

class DWordPatch : public Patch {
public:
	DWordPatch(shared_ptr<Expr> expr, int offset = 0) : Patch(expr, offset) {}
	Type type() const override { return Type::DWORD; }
	int size() const override { return 4; }
	void do_patch(vector<uint8_t>& bytes, int asmpc) override;
};

class JrOffsetPatch : public Patch {
public:
	JrOffsetPatch(shared_ptr<Expr> expr, int offset = 0) : Patch(expr, offset) {}
	Type type() const override { return Type::JR_OFFSET; }
	int size() const override { return 1; }
	void do_patch(vector<uint8_t>& bytes, int asmpc) override;
};

class JreOffsetPatch : public Patch {
public:
	JreOffsetPatch(shared_ptr<Expr> expr, int offset = 0) : Patch(expr, offset) {}
	Type type() const override { return Type::JRE_OFFSET; }
	int size() const override { return 2; }
	void do_patch(vector<uint8_t>& bytes, int asmpc) override;
};

class UByte2WordPatch : public Patch {
public:
	UByte2WordPatch(shared_ptr<Expr> expr, int offset = 0) : Patch(expr, offset) {}
	Type type() const override { return Type::BYTE_TO_WORD_UNSIGNED; }
	int size() const override { return 2; }
	void do_patch(vector<uint8_t>& bytes, int asmpc) override;
};

class SByte2WordPatch : public Patch {
public:
	SByte2WordPatch(shared_ptr<Expr> expr, int offset = 0) : Patch(expr, offset) {}
	Type type() const override { return Type::BYTE_TO_WORD_SIGNED; }
	int size() const override { return 2; }
	void do_patch(vector<uint8_t>& bytes, int asmpc) override;
};

class HighOffsetPatch : public Patch {
public:
	HighOffsetPatch(shared_ptr<Expr> expr, int offset = 0) : Patch(expr, offset) {}
	Type type() const override { return Type::HIGH_OFFSET; }
	int size() const override { return 1; }
	void do_patch(vector<uint8_t>& bytes, int asmpc) override;
};
