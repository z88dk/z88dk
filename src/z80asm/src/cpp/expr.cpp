//-----------------------------------------------------------------------------
// z80asm
// expressions
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm.h"
#include "expr.h"
#include "lex.h"
#include "preproc.h"
#include "symtab.h"
#include "utils.h"
#include <exception>
#include <cstring>
using namespace std;

ExprNode::ExprNode(Type type,
	shared_ptr<ExprNode> arg1,
	shared_ptr<ExprNode> arg2,
	shared_ptr<ExprNode> arg3)
	: m_type(type) {
	if (arg1) m_args.push_back(arg1);
	if (arg2) m_args.push_back(arg2);
	if (arg3) m_args.push_back(arg3);
}

ExprNode::ExprNode(int n)
	: m_type(Type::LeafNumber), m_value(n) {
}

ExprNode::ExprNode(shared_ptr<Symbol> symbol)
	: m_type(Type::LeafSymbol), m_symbol(symbol) {
}

ExprNode::ExprNode(shared_ptr<Icode> instr)
	: m_type(Type::LeafASMPC), m_instr(instr) {
}

shared_ptr<ExprNode> ExprNode::arg(size_t i) {
	Assert(i < m_args.size());
	return m_args[i];
}

Expr::Expr(Lexer& lexer)
	: m_lexer(lexer) {
	clear();
}

void Expr::clear() {
	m_root = nullptr;
	m_value = 0;
	m_result = ErrCode::Ok;
	m_silent = false;
	m_is_const = true;
	m_location = g_preproc.location();
}

class ExprException : public exception {
public:
	ExprException(ErrCode err, const string& text = "")
		: m_err(err), m_text(text) {}
	ErrCode err() const { return m_err; }
	const string& text() const { return m_text; }

private:
	ErrCode m_err{ ErrCode::Ok };
	string	m_text;
};

void Expr::error(ErrCode err, const string& text) {
	m_result = err;
	if (!m_silent)
		g_errors.error(m_result, text);
}

bool Expr::parse() {
	clear();
	m_root = parse_expr();
	return m_result == ErrCode::Ok ? true : false;
}

bool Expr::parse_at_end() {
	if (!parse())
		return false;

	// check for end of statement
	switch (ttype()) {
	case TType::End:
	case TType::Newline:
		return true;
	default:
		error(ErrCode::SyntaxExpr, m_lexer.text_ptr());
		return false;
	}
}

bool Expr::eval_silent() {
	m_silent = true;
	return eval();
}

bool Expr::eval_noisy() {
	m_silent = false;
	return eval();
}

bool Expr::in_parens() {
	return m_root && m_root->type() == ExprNode::Type::Parens;
}

shared_ptr<ExprNode> Expr::parse_expr() {
	shared_ptr<ExprNode> node;
	try {
		node = parse_ternary_condition();
	}
	catch (ExprException& e) {
		error(e.err(), e.text());
	}
	return node;
}

shared_ptr<ExprNode> Expr::parse_ternary_condition() {
	shared_ptr<ExprNode> node = parse_logical_or();
	if (ttype() == TType::Quest) {
		next();
		shared_ptr<ExprNode> t = parse_ternary_condition();
		if (ttype() == TType::Colon) {
			next();
			shared_ptr<ExprNode> f = parse_ternary_condition();
			node = make_shared<ExprNode>(ExprNode::Type::TernCond,
				node, t, f);
		}
		else {
			throw ExprException(ErrCode::ColonExpected, m_lexer.text_ptr());
		}
	}
	return node;
}

shared_ptr<ExprNode> Expr::parse_logical_or() {
	shared_ptr<ExprNode> node = parse_logical_and();
	while (true) {
		switch (ttype()) {
		case TType::LogOr:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::LogOr,
				node, parse_logical_and());
			break;
		case TType::LogXor:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::LogXor,
				node, parse_logical_and());
			break;
		default:
			return node;
		}
	}
}

shared_ptr<ExprNode> Expr::parse_logical_and() {
	shared_ptr<ExprNode> node = parse_binary_or();
	while (true) {
		switch (ttype()) {
		case TType::LogAnd:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::LogAnd,
				node, parse_binary_or());
			break;
		default:
			return node;
		}
	}
}

shared_ptr<ExprNode> Expr::parse_binary_or() {
	shared_ptr<ExprNode> node = parse_binary_and();
	while (true) {
		switch (ttype()) {
		case TType::BinOr:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::BinOr,
				node, parse_binary_and());
			break;
		case TType::BinXor:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::BinXor,
				node, parse_binary_and());
			break;
		default:
			return node;
		}
	}
}

shared_ptr<ExprNode> Expr::parse_binary_and() {
	shared_ptr<ExprNode> node = parse_condition();
	while (true) {
		switch (ttype()) {
		case TType::BinAnd:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::BinAnd,
				node, parse_condition());
			break;
		default:
			return node;
		}
	}
}

shared_ptr<ExprNode> Expr::parse_condition() {
	shared_ptr<ExprNode> node = parse_shift();
	while (true) {
		switch (ttype()) {
		case TType::Lt:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::Lt,
				node, parse_shift());
			break;
		case TType::Le:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::Le,
				node, parse_shift());
			break;
		case TType::Gt:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::Gt,
				node, parse_shift());
			break;
		case TType::Ge:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::Ge,
				node, parse_shift());
			break;
		case TType::Eq:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::Eq,
				node, parse_shift());
			break;
		case TType::Ne:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::Ne,
				node, parse_shift());
			break;
		default:
			return node;
		}
	}
}

shared_ptr<ExprNode> Expr::parse_shift() {
	shared_ptr<ExprNode> node = parse_addition();
	while (true) {
		switch (ttype()) {
		case TType::LShift:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::LShift,
				node, parse_addition());
			break;
		case TType::RShift:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::RShift,
				node, parse_addition());
			break;
		default:
			return node;
		}
	}
}

shared_ptr<ExprNode> Expr::parse_addition() {
	shared_ptr<ExprNode> node = parse_multiplication();
	while (true) {
		switch (ttype()) {
		case TType::Plus:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::Plus,
				node, parse_multiplication());
			break;
		case TType::Minus:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::Minus,
				node, parse_multiplication());
			break;
		default:
			return node;
		}
	}
}

shared_ptr<ExprNode> Expr::parse_multiplication() {
	shared_ptr<ExprNode> node = parse_power();
	while (true) {
		switch (ttype()) {
		case TType::Mult:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::Mult,
				node, parse_power());
			break;
		case TType::Div:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::Div,
				node, parse_power());
			break;
		case TType::Mod:
			next();
			node = make_shared<ExprNode>(ExprNode::Type::Mod,
				node, parse_power());
			break;
		default:
			return node;
		}
	}
}

shared_ptr<ExprNode> Expr::parse_power() {
	shared_ptr<ExprNode> node = parse_unary();
	if (ttype() == TType::Power) {
		next();
		node = make_shared<ExprNode>(ExprNode::Type::Power,
			node, parse_power());
	}
	return node;
}

shared_ptr<ExprNode> Expr::parse_unary() {
	shared_ptr<ExprNode> node{ nullptr };
	switch (ttype()) {
	case TType::Minus:
		next();
		return make_shared<ExprNode>(ExprNode::Type::UnaryMinus,
			parse_unary());
	case TType::Plus:
		next();
		return make_shared<ExprNode>(ExprNode::Type::UnaryPlus,
			parse_unary());
	case TType::LogNot:
		next();
		return make_shared<ExprNode>(ExprNode::Type::LogNot,
			parse_unary());
	case TType::BinNot:
		next();
		return make_shared<ExprNode>(ExprNode::Type::BinNot,
			parse_unary());
	case TType::LParen:
		next();
		node = parse_expr();
		if (ttype() != TType::RParen)
			throw ExprException(ErrCode::UnbalancedParens,
				m_lexer.text_ptr());
		next();
		return make_shared<ExprNode>(ExprNode::Type::Parens, node);
	case TType::LSquare:
		next();
		node = parse_expr();
		throw ExprException(ErrCode::UnbalancedParens,
			m_lexer.text_ptr());
		next();
		return make_shared<ExprNode>(ExprNode::Type::Parens, node);
	default:
		return parse_primary();
	}
}

shared_ptr<ExprNode> Expr::parse_primary() {
	shared_ptr<ExprNode> node;
	shared_ptr<Symbol> symbol;
	shared_ptr<Icode> instr;

	switch (ttype()) {
	case TType::Ident:
		symbol = g_symbols.get_used(token().svalue);
		node = make_shared<ExprNode>(symbol);
		next();
		return node;
	case TType::ASMPC:
		instr = g_asm.cur_section()->add_asmpc();
		node = make_shared<ExprNode>(instr);
		next();
		return node;
	case TType::Integer:
		node = make_shared<ExprNode>(token().ivalue);
		next();
		return node;
	default:
		throw ExprException(ErrCode::IntOrIdentExpected,
			m_lexer.token_text());
	}
}

bool Expr::eval() {
	m_value = 0;
	m_result = ErrCode::Ok;
	m_is_const = true;

	try {
		m_value = eval_node(m_root);
	}
	catch (ExprException& e) {
		g_errors.push_location(m_location);
		error(e.err(), e.text());
		g_errors.pop_location();
	}

	return m_result == ErrCode::Ok ? true : false;
}

int Expr::eval_node(shared_ptr<ExprNode> node) {
	if (!node)				// empty expression
		return 0;

	// nodes without arguments
	switch (node->type()) {
	case ExprNode::Type::LeafNumber:
		return node->value();

	case ExprNode::Type::LeafSymbol:
		return eval_symbol(node->symbol());

	case ExprNode::Type::LeafASMPC:
		m_is_const = false;
		return node->instr()->pc();

	default:;
	}

	// nodes with one argument and ternary condition
	int a = eval_node(node->arg(0));
	switch (node->type()) {
	case ExprNode::Type::TernCond:
		return a ? eval_node(node->arg(1)) : eval_node(node->arg(2));

	case ExprNode::Type::UnaryPlus:	return a;
	case ExprNode::Type::UnaryMinus: return -a;
	case ExprNode::Type::LogNot: return !a;
	case ExprNode::Type::BinNot: return ~a;
	case ExprNode::Type::Parens: return a;
	default:;
	}

	// nodes with two arguments
	int b = eval_node(node->arg(1));
	switch (node->type()) {
	case ExprNode::Type::LogOr: return a || b;
	case ExprNode::Type::LogXor: return a != b;
	case ExprNode::Type::LogAnd: return a && b;
	case ExprNode::Type::BinOr: return a | b;
	case ExprNode::Type::BinXor: return a ^ b;
	case ExprNode::Type::BinAnd: return a & b;
	case ExprNode::Type::Lt: return a < b;
	case ExprNode::Type::Le: return a <= b;
	case ExprNode::Type::Gt: return a > b;
	case ExprNode::Type::Ge: return a >= b;
	case ExprNode::Type::Eq: return a == b;
	case ExprNode::Type::Ne: return a != b;
	case ExprNode::Type::LShift: return a << b;
	case ExprNode::Type::RShift: return a >> b;
	case ExprNode::Type::Plus: return a + b;
	case ExprNode::Type::Minus: return a - b;
	case ExprNode::Type::Mult: return a * b;
	case ExprNode::Type::Div:
		if (b == 0)
			throw(ExprException(ErrCode::DivisionByZero, text()));
		return a / b;

	case ExprNode::Type::Mod:
		if (b == 0)
			throw(ExprException(ErrCode::DivisionByZero, text()));
		return a % b;

	case ExprNode::Type::Power: return ipow(a, b);
	default:;
	}

	Assert(0); // not reached
	return 0;
}

int Expr::eval_symbol(shared_ptr<Symbol> symbol) {
	switch (symbol->type()) {
	case Symbol::Type::Unknown:
		throw(ExprException(ErrCode::UndefinedSymbol, symbol->name()));

	case Symbol::Type::Constant:
		return symbol->value();

	case Symbol::Type::Label:
		m_is_const = false;
		return symbol->instr()->pc();

	case Symbol::Type::Address:
		m_is_const = false;
		return symbol->value();

	case Symbol::Type::Computed:
		if (m_evaluating)
			throw(ExprException(ErrCode::RecursiveExpression, text()));
		else {
			// recurse to eval symbol expression
			m_evaluating = true;
			{
				auto subexpr = symbol->expr();

				if (m_silent)
					subexpr->eval_silent();
				else
					subexpr->eval_noisy();

				if (subexpr->result() != ErrCode::Ok)
					m_result = subexpr->result();

				if (!subexpr->is_const())
					m_is_const = false;
			}
			m_evaluating = false;
			return symbol->expr()->value();
		}
	}

	Assert(0);	// not reached
	return 0;
}

string Expr::node_text(shared_ptr<ExprNode> node) const {
	if (!node)
		return string();

	switch (node->type()) {
	case ExprNode::Type::LeafNumber: return int_to_hex(node->value(), 2); break;
	case ExprNode::Type::LeafSymbol: return node->symbol()->name(); break;
	case ExprNode::Type::LeafASMPC: return "$"; break;
	case ExprNode::Type::TernCond: return node_text(node->arg(0)) + "?"
		+ node_text(node->arg(1)) + ":" + node_text(node->arg(2)); break;
	case ExprNode::Type::LogOr: return node_text(node->arg(0)) + "||" + node_text(node->arg(1)); break;
	case ExprNode::Type::LogXor: return node_text(node->arg(0)) + "^^" + node_text(node->arg(1)); break;
	case ExprNode::Type::LogAnd: return node_text(node->arg(0)) + "&&" + node_text(node->arg(1)); break;
	case ExprNode::Type::BinOr: return node_text(node->arg(0)) + "|" + node_text(node->arg(1)); break;
	case ExprNode::Type::BinXor: return node_text(node->arg(0)) + "^" + node_text(node->arg(1)); break;
	case ExprNode::Type::BinAnd: return node_text(node->arg(0)) + "&" + node_text(node->arg(1)); break;
	case ExprNode::Type::Lt: return node_text(node->arg(0)) + "<" + node_text(node->arg(1)); break;
	case ExprNode::Type::Le: return node_text(node->arg(0)) + "<=" + node_text(node->arg(1)); break;
	case ExprNode::Type::Gt: return node_text(node->arg(0)) + ">" + node_text(node->arg(1)); break;
	case ExprNode::Type::Ge: return node_text(node->arg(0)) + ">=" + node_text(node->arg(1)); break;
	case ExprNode::Type::Eq: return node_text(node->arg(0)) + "=" + node_text(node->arg(1)); break;
	case ExprNode::Type::Ne: return node_text(node->arg(0)) + "<>" + node_text(node->arg(1)); break;
	case ExprNode::Type::LShift: return node_text(node->arg(0)) + "<<" + node_text(node->arg(1)); break;
	case ExprNode::Type::RShift: return node_text(node->arg(0)) + ">>" + node_text(node->arg(1)); break;
	case ExprNode::Type::Plus: return node_text(node->arg(0)) + "+" + node_text(node->arg(1)); break;
	case ExprNode::Type::Minus: return node_text(node->arg(0)) + "-" + node_text(node->arg(1)); break;
	case ExprNode::Type::Mult: return node_text(node->arg(0)) + "*" + node_text(node->arg(1)); break;
	case ExprNode::Type::Div: return node_text(node->arg(0)) + "/" + node_text(node->arg(1)); break;
	case ExprNode::Type::Mod: return node_text(node->arg(0)) + "%" + node_text(node->arg(1)); break;
	case ExprNode::Type::Power: return node_text(node->arg(0)) + "**" + node_text(node->arg(1)); break;
	case ExprNode::Type::UnaryPlus: return string("+") + node_text(node->arg(0)); break;
	case ExprNode::Type::UnaryMinus: return string("-") + node_text(node->arg(0)); break;
	case ExprNode::Type::LogNot: return string("!") + node_text(node->arg(0)); break;
	case ExprNode::Type::BinNot: return string("~") + node_text(node->arg(0)); break;
	case ExprNode::Type::Parens: return string("(") + node_text(node->arg(0)) + ")"; break;
	default: Assert(0); return string(); // not reached
	}
}

PatchExpr::PatchExpr(shared_ptr<Expr> expr, Type type, size_t offset)
	: m_type(type), m_offset(offset), m_expr(expr) {
}
