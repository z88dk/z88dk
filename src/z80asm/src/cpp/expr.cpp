//-----------------------------------------------------------------------------
// z80asm
// expressions
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm.h"
#include "icode.h"
#include "preproc.h"
#include "symtab.h"
#include "utils.h"
using namespace std;

ExprResult::ExprResult(int value)
	: m_value(value) {}

bool ExprResult::is_const() const {
	if (m_depends_on_asmpc || undefined_symbol())
		return false;
	else
		return true;
}

ExprResult ExprResult::merge(const ExprResult& a, const ExprResult& b) {
	ExprResult r;

	if (a.m_depends_on_asmpc || b.m_depends_on_asmpc)
		r.m_depends_on_asmpc = true;

	if (a.m_division_by_zero || b.m_division_by_zero)
		r.m_division_by_zero = true;

	if (a.m_recursive_expr || b.m_recursive_expr)
		r.m_recursive_expr = true;

	if (a.undefined_symbol() && b.undefined_symbol())
		r.m_undefined_symbols = a.m_undefined_symbols + "," + b.m_undefined_symbols;
	else if (a.undefined_symbol())
		r.m_undefined_symbols = a.m_undefined_symbols;
	else if (b.undefined_symbol())
		r.m_undefined_symbols = b.m_undefined_symbols;
	else {
	}

	return r;
}

//-----------------------------------------------------------------------------

ConstNode::ConstNode(int value)
	: m_value(value) {}

ExprResult ConstNode::value() {
	return ExprResult(m_value);
}

string ConstNode::text() const {
	return int_to_hex(m_value, 2);
}

//-----------------------------------------------------------------------------

SymbolNode::SymbolNode(shared_ptr<Symbol> symbol)
	: m_symbol(symbol) {}

ExprResult SymbolNode::value() {
	ExprResult r;

	if (m_in_eval) {		// recursive expression
		r.set_recursive_expr();
	}
	else {
		m_in_eval = true;
		r = m_symbol.lock()->value();
		m_in_eval = false;
	}
	return r;
}

string SymbolNode::text() const {
	return m_symbol.lock()->name();
}

//-----------------------------------------------------------------------------

AsmpcNode::AsmpcNode(shared_ptr<Instr> instr)
	: m_instr(instr) {}

ExprResult AsmpcNode::value() {
	auto instr = m_instr.lock();
	ExprResult r(instr->pc());
	if (instr->is_phased())
		return r;		// is constant
	else {
		r.set_depends_on_asmpc();
		return r;
	}
}

string AsmpcNode::text() const {
	return "$";
}

//-----------------------------------------------------------------------------

TernCondNode::TernCondNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b, shared_ptr<ExprNode> c) {
	m_args.push_back(a);
	m_args.push_back(b);
	m_args.push_back(c);
}

ExprResult TernCondNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult rc = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, ExprResult::merge(rb, rc));
	r.set_value(ra.value() ? rb.value() : rc.value());
	return r;
}

string TernCondNode::text() const {
	return m_args[0]->text() + "?" + m_args[1]->text() + ":" + m_args[2]->text();
}

//-----------------------------------------------------------------------------

LogOrNode::LogOrNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult LogOrNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(!!ra.value() || !!rb.value());
	return r;
}

string LogOrNode::text() const {
	return m_args[0]->text() + "||" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

LogXorNode::LogXorNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult LogXorNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(!!ra.value() != !!rb.value());
	return r;
}

string LogXorNode::text() const {
	return m_args[0]->text() + "^^" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

LogAndNode::LogAndNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult LogAndNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(!!ra.value() && !!rb.value());
	return r;
}

string LogAndNode::text() const {
	return m_args[0]->text() + "&&" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

BinOrNode::BinOrNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult BinOrNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() | rb.value());
	return r;
}

string BinOrNode::text() const {
	return m_args[0]->text() + "|" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

BinXorNode::BinXorNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult BinXorNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() ^ rb.value());
	return r;
}

string BinXorNode::text() const {
	return m_args[0]->text() + "^" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

BinAndNode::BinAndNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult BinAndNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() & rb.value());
	return r;
}

string BinAndNode::text() const {
	return m_args[0]->text() + "&" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

LtNode::LtNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult LtNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() < rb.value());
	return r;
}

string LtNode::text() const {
	return m_args[0]->text() + "<" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

LeNode::LeNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult LeNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() <= rb.value());
	return r;
}

string LeNode::text() const {
	return m_args[0]->text() + "<=" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

GtNode::GtNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult GtNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() > rb.value());
	return r;
}

string GtNode::text() const {
	return m_args[0]->text() + ">" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

GeNode::GeNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult GeNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() >= rb.value());
	return r;
}

string GeNode::text() const {
	return m_args[0]->text() + ">=" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

EqNode::EqNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult EqNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() == rb.value());
	return r;
}

string EqNode::text() const {
	return m_args[0]->text() + "==" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

NeNode::NeNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult NeNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() != rb.value());
	return r;
}

string NeNode::text() const {
	return m_args[0]->text() + "!=" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

LShiftNode::LShiftNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult LShiftNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() << rb.value());
	return r;
}

string LShiftNode::text() const {
	return m_args[0]->text() + "<<" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

RShiftNode::RShiftNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult RShiftNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() >> rb.value());
	return r;
}

string RShiftNode::text() const {
	return m_args[0]->text() + ">>" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

PlusNode::PlusNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult PlusNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() + rb.value());
	return r;
}

string PlusNode::text() const {
	return m_args[0]->text() + "+" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

MinusNode::MinusNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult MinusNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() - rb.value());
	return r;
}

string MinusNode::text() const {
	return m_args[0]->text() + "-" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

MultNode::MultNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult MultNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ra.value() * rb.value());
	return r;
}

string MultNode::text() const {
	return m_args[0]->text() + "*" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

DivNode::DivNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult DivNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	if (rb.value() == 0) 
		r.set_division_by_zero();
	else 
		r.set_value(ra.value() / rb.value());
	return r;
}

string DivNode::text() const {
	return m_args[0]->text() + "/" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

ModNode::ModNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult ModNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	if (rb.value() == 0) 
		r.set_division_by_zero();
	else 
		r.set_value(ra.value() % rb.value());
	return r;
}

string ModNode::text() const {
	return m_args[0]->text() + "%" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

PowerNode::PowerNode(shared_ptr<ExprNode> a, shared_ptr<ExprNode> b) {
	m_args.push_back(a);
	m_args.push_back(b);
}

ExprResult PowerNode::value() {
	ExprResult ra = m_args[0]->value();
	ExprResult rb = m_args[0]->value();
	ExprResult r = ExprResult::merge(ra, rb);
	r.set_value(ipow(ra.value(), rb.value()));
	return r;
}

string PowerNode::text() const {
	return m_args[0]->text() + "**" + m_args[1]->text();
}

//-----------------------------------------------------------------------------

UnaryPlusNode::UnaryPlusNode(shared_ptr<ExprNode> a) {
	m_args.push_back(a);
}

ExprResult UnaryPlusNode::value() {
	ExprResult r = m_args[0]->value();
	return r;
}

string UnaryPlusNode::text() const {
	return string("+") + m_args[0]->text();
}

//-----------------------------------------------------------------------------

UnaryMinusNode::UnaryMinusNode(shared_ptr<ExprNode> a) {
	m_args.push_back(a);
}

ExprResult UnaryMinusNode::value() {
	ExprResult r = m_args[0]->value();
	r.set_value(-r.value());
	return r;
}

string UnaryMinusNode::text() const {
	return string("-") + m_args[0]->text();
}

//-----------------------------------------------------------------------------

LogNotNode::LogNotNode(shared_ptr<ExprNode> a) {
	m_args.push_back(a);
}

ExprResult LogNotNode::value() {
	ExprResult r = m_args[0]->value();
	r.set_value(!!!r.value());
	return r;
}

string LogNotNode::text() const {
	return string("!") + m_args[0]->text();
}

//-----------------------------------------------------------------------------

BinNotNode::BinNotNode(shared_ptr<ExprNode> a) {
	m_args.push_back(a);
}

ExprResult BinNotNode::value() {
	ExprResult r = m_args[0]->value();
	r.set_value(~r.value());
	return r;
}

string BinNotNode::text() const {
	return string("~") + m_args[0]->text();
}

//-----------------------------------------------------------------------------

ParensNode::ParensNode(shared_ptr<ExprNode> a) {
	m_args.push_back(a);
}

ExprResult ParensNode::value() {
	ExprResult r = m_args[0]->value();
	return r;
}

string ParensNode::text() const {
	return string("(") + m_args[0]->text() + ")";
}

//-----------------------------------------------------------------------------

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

//-----------------------------------------------------------------------------

Expr::Expr(Lexer& lexer)
	: m_lexer(lexer) {
	clear();
}

void Expr::clear() {
	m_root = nullptr;
	m_location = g_preproc.location();
	m_section = g_asm.cur_section();
}

string Expr::text() const {
	if (m_root)
		return m_root->text();
	else
		return string();
}

bool Expr::parse() {
	clear();
	m_root = parse_expr();

	if (m_root)
		return true;
	else
		return false;
}

shared_ptr<ExprNode> Expr::parse_expr() {
	shared_ptr<ExprNode> node;
	bool ok = true;

	try {
		node = parse_ternary_condition();
	}
	catch (ExprException& e) {
		g_errors.error(e.err(), e.text());
		ok = false;
	}

	if (ok)
		return node;
	else
		return nullptr;
}

shared_ptr<ExprNode> Expr::parse_ternary_condition() {
	shared_ptr<ExprNode> node = parse_logical_or();
	if (ttype() == TType::Quest) {
		next();
		shared_ptr<ExprNode> t = parse_ternary_condition();
		if (ttype() == TType::Colon) {
			next();
			shared_ptr<ExprNode> f = parse_ternary_condition();
			node = make_shared<TernCondNode>(node, t, f);
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
			node = make_shared<LogOrNode>(node, parse_logical_and());
			break;
		case TType::LogXor:
			next();
			node = make_shared<LogXorNode>(node, parse_logical_and());
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
			node = make_shared<LogAndNode>(node, parse_binary_or());
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
			node = make_shared<BinOrNode>(node, parse_binary_and());
			break;
		case TType::BinXor:
			next();
			node = make_shared<BinXorNode>(node, parse_binary_and());
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
			node = make_shared<BinAndNode>(node, parse_condition());
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
			node = make_shared<LtNode>(node, parse_shift());
			break;
		case TType::Le:
			next();
			node = make_shared<LeNode>(node, parse_shift());
			break;
		case TType::Gt:
			next();
			node = make_shared<GtNode>(node, parse_shift());
			break;
		case TType::Ge:
			next();
			node = make_shared<GeNode>(node, parse_shift());
			break;
		case TType::Eq:
			next();
			node = make_shared<EqNode>(node, parse_shift());
			break;
		case TType::Ne:
			next();
			node = make_shared<NeNode>(node, parse_shift());
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
			node = make_shared<LShiftNode>(node, parse_addition());
			break;
		case TType::RShift:
			next();
			node = make_shared<RShiftNode>(node, parse_addition());
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
			node = make_shared<PlusNode>(node, parse_multiplication());
			break;
		case TType::Minus:
			next();
			node = make_shared<MinusNode>(node, parse_multiplication());
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
			node = make_shared<MultNode>(node, parse_power());
			break;
		case TType::Div:
			next();
			node = make_shared<DivNode>(node, parse_power());
			break;
		case TType::Mod:
			next();
			node = make_shared<ModNode>(node, parse_power());
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
		node = make_shared<PowerNode>(node, parse_power());
	}
	return node;
}

shared_ptr<ExprNode> Expr::parse_unary() {
	shared_ptr<ExprNode> node{ nullptr };
	switch (ttype()) {
	case TType::Minus:
		next();
		return make_shared<UnaryMinusNode>(parse_unary());
	case TType::Plus:
		next();
		return make_shared<UnaryPlusNode>(parse_unary());
	case TType::LogNot:
		next();
		return make_shared<LogNotNode>(parse_unary());
	case TType::BinNot:
		next();
		return make_shared<BinNotNode>(parse_unary());
	case TType::LParen:
		next();
		node = parse_expr();
		if (ttype() != TType::RParen)
			throw ExprException(ErrCode::UnbalancedParens, m_lexer.text_ptr());
		next();
		return make_shared<ParensNode>(node);
	case TType::LSquare:
		next();
		node = parse_expr();
		if (ttype() != TType::RSquare)
			throw ExprException(ErrCode::UnbalancedParens, m_lexer.text_ptr());
		next();
		return make_shared<ParensNode>(node);
	default:
		return parse_primary();
	}
}

shared_ptr<ExprNode> Expr::parse_primary() {
	shared_ptr<ExprNode> node;
	shared_ptr<Symbol> symbol;
	shared_ptr<Instr> instr;

	switch (ttype()) {
	case TType::Ident:
		symbol = g_symbols.get_used(token().svalue);
		node = make_shared<SymbolNode>(symbol);
		next();
		return node;
	case TType::ASMPC:
		instr = g_asm.cur_section()->add_asmpc();
		node = make_shared<AsmpcNode>(instr);
		next();
		return node;
	case TType::Integer:
		node = make_shared<ConstNode>(token().ivalue);
		next();
		return node;
	default:
		throw ExprException(ErrCode::IntOrIdentExpected, m_lexer.token_text());
	}
}

ExprResult Expr::eval_silent() const {
	if (m_root == nullptr)
		return ExprResult();
	else
		return m_root->value();
}

ExprResult Expr::eval_noisy() const {
	ExprResult r = eval_silent();

	g_errors.push_location(m_location);

	if (r.recursive_expr())
		g_errors.error(ErrCode::RecursiveExpression);

	if (r.division_by_zero())
		g_errors.error(ErrCode::DivisionByZero);

	if (r.undefined_symbol())
		g_errors.error(ErrCode::UndefinedSymbol, r.undefined_symbol_names());

	g_errors.pop_location();

	return r;
}

bool Expr::in_parens() const {
	return m_root && m_root->type() == ExprNode::Type::Parens;
}

bool Expr::is_const() const {
	if (!m_root)
		return true;
	else {
		ExprResult r = eval_silent();
		return r.is_const();
	}
}

//-----------------------------------------------------------------------------

Patch::Patch(shared_ptr<Expr> expr, int offset)
	: m_expr(expr), m_offset(offset) {}

void UBytePatch::do_patch(vector<uint8_t>& bytes, int /*asmpc*/) {
	Assert(m_offset + size() <= static_cast<int>(bytes.size()));
	ExprResult r = m_expr->eval_noisy();
	int value = r.value();
	if (value < -128 || value > 255)
		g_errors.warning(ErrCode::IntRange, int_to_hex(value, 2));
	bytes[m_offset] = value & 0xff;
}

void SBytePatch::do_patch(vector<uint8_t>& bytes, int /*asmpc*/) {
	Assert(m_offset + size() <= static_cast<int>(bytes.size()));
	ExprResult r = m_expr->eval_noisy();
	int value = r.value();
	if (value < -128 || value > 127)
		g_errors.warning(ErrCode::IntRange, int_to_hex(value, 2));
	bytes[m_offset] = value & 0xff;
}

void WordPatch::do_patch(vector<uint8_t>& bytes, int /*asmpc*/) {
	Assert(m_offset + size() <= static_cast<int>(bytes.size()));
	ExprResult r = m_expr->eval_noisy();
	int value = r.value();
	bytes[m_offset + 0] = value & 0xff;
	bytes[m_offset + 1] = (value >> 8) & 0xff;
}

void BEWordPatch::do_patch(vector<uint8_t>& bytes, int /*asmpc*/) {
	Assert(m_offset + size() <= static_cast<int>(bytes.size()));
	ExprResult r = m_expr->eval_noisy();
	int value = r.value();
	bytes[m_offset + 0] = (value >> 8) & 0xff;
	bytes[m_offset + 1] = value & 0xff;
}

void Ptr24Patch::do_patch(vector<uint8_t>& bytes, int /*asmpc*/) {
	Assert(m_offset + size() <= static_cast<int>(bytes.size()));
	ExprResult r = m_expr->eval_noisy();
	int value = r.value();
	bytes[m_offset + 0] = value & 0xff;
	bytes[m_offset + 1] = (value >> 8) & 0xff;
	bytes[m_offset + 2] = (value >> 16) & 0xff;
}

void DWordPatch::do_patch(vector<uint8_t>& bytes, int /*asmpc*/) {
	Assert(m_offset + size() <= static_cast<int>(bytes.size()));
	ExprResult r = m_expr->eval_noisy();
	int value = r.value();
	bytes[m_offset + 0] = value & 0xff;
	bytes[m_offset + 1] = (value >> 8) & 0xff;
	bytes[m_offset + 2] = (value >> 16) & 0xff;
	bytes[m_offset + 3] = (value >> 24) & 0xff;
}

void JrOffsetPatch::do_patch(vector<uint8_t>& bytes, int asmpc) {
	Assert(m_offset + size() <= static_cast<int>(bytes.size()));
	ExprResult r = m_expr->eval_noisy();
	int value = r.value() - asmpc + 2;
	if (value >= -128 && value <= 127) 
		bytes[m_offset] = value & 0xff;
	else
		g_errors.error(ErrCode::IntRange, int_to_hex(value, 2));
}

void UByte2WordPatch::do_patch(vector<uint8_t>& bytes, int /*asmpc*/) {
	Assert(m_offset + size() <= static_cast<int>(bytes.size()));
	ExprResult r = m_expr->eval_noisy();
	int value = r.value();
	if (value < 0 || value > 255)
		g_errors.warning(ErrCode::IntRange, int_to_hex(value, 2));
	bytes[m_offset + 0] = value & 0xff;
	bytes[m_offset + 1] = 0;
}

void SByte2WordPatch::do_patch(vector<uint8_t>& bytes, int /*asmpc*/) {
	Assert(m_offset + size() <= static_cast<int>(bytes.size()));
	ExprResult r = m_expr->eval_noisy();
	int value = r.value();
	if (value < -128 || value > 127)
		g_errors.warning(ErrCode::IntRange, int_to_hex(value, 2));
	bytes[m_offset + 0] = value & 0xff;
	bytes[m_offset + 1] = (value & 0x80) ? 0xff : 0;
}

void HighOffsetPatch::do_patch(vector<uint8_t>& bytes, int /*asmpc*/) {
	Assert(m_offset + size() <= static_cast<int>(bytes.size()));
	ExprResult r = m_expr->eval_noisy();
	int value = r.value();
	if ((value & 0xff00) != 0) {
		if ((value & 0xff00) != 0xff00)
			g_errors.warning(ErrCode::IntRange, int_to_hex(value, 2));
	}
	bytes[m_offset] = value & 0xff;
}
