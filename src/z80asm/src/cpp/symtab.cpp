//-----------------------------------------------------------------------------
// z80asm
// symbol tables
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "asm.h"
#include "expr.h"
#include "icode.h"
#include "if.h"
#include "preproc.h"
#include "symtab.h"
#include "utils.h"
using namespace std;

Symbols g_symbols;

extern "C" {
    struct Symbol1;
    struct Symbol1* define_static_def_sym(const char* name, long value);
    void undefine_static_def_sym(const char* name);
}

//-----------------------------------------------------------------------------

Symbol::Symbol(MakeUndef /*tag*/, const string& name, Symbol::Scope scope)
	: m_name(name)
	, m_type(Type::Undef), m_scope(scope)
	, m_location(g_preproc.location()) {
}

Symbol::Symbol(MakeConstant /*tag*/, const string& name, int value, Symbol::Scope scope)
	: m_name(name)
	, m_value(value)
	, m_type(Type::Constant), m_scope(scope)
	, m_location(g_preproc.location()) {
}

Symbol::Symbol(MakeAsmpc /*tag*/, const string& name, shared_ptr<Instr> instr, Symbol::Scope scope)
	: m_name(name)
	, m_instr(instr)
	, m_type(Type::Asmpc), m_scope(scope)
	, m_location(g_preproc.location()) {
}

Symbol::Symbol(MakeAsmpcPhased /*tag*/, const string& name, shared_ptr<Instr> instr, Symbol::Scope scope)
	: m_name(name)
	, m_instr(instr)
	, m_type(Type::AsmpcPhased), m_scope(scope)
	, m_location(g_preproc.location()) {
}

Symbol::Symbol(MakeComputed /*tag*/, const string& name, shared_ptr<Expr> expr, Symbol::Scope scope)
	: m_name(name)
	, m_expr(expr)
	, m_type(Type::Computed), m_scope(scope)
	, m_location(g_preproc.location()) {
}

void Symbol::update(const Symbol& other) {
	m_value = other.m_value;
	m_instr = other.m_instr;
	m_expr = other.m_expr;
	m_type = other.m_type;
	m_scope = other.m_scope;
	m_is_touched = other.m_is_touched;
	m_is_global_def = other.m_is_global_def;
	m_section = other.m_section;
	m_location = other.m_location;
}

void Symbol::update(MakeConstant /*tag*/, int value) {
	m_type = Type::Constant;
	m_value = value;
	m_instr.reset();
	m_expr.reset();
}

void Symbol::update(MakeAsmpc /*tag*/, shared_ptr<Instr> instr) {
	m_type = Type::Asmpc;
	m_value = 0;
	m_instr = instr;
	m_expr.reset();
}

void Symbol::update(MakeAsmpcPhased /*tag*/, shared_ptr<Instr> instr) {
	m_type = Type::AsmpcPhased;
	m_value = 0;
	m_instr = instr;
	m_expr.reset();
}

void Symbol::update(MakeComputed /*tag*/, shared_ptr<Expr> expr) {
	m_type = Type::Computed;
	m_value = 0;
	m_instr.reset();
	m_expr = expr;
}

ExprResult Symbol::value() const {
	ExprResult r;

	switch (m_type) {
	case Type::Undef:
		r.set_undefined_symbol(m_name);
		break;
	case Type::Constant:
		r.set_value(m_value);
		break;
	case Type::Asmpc:
		r.set_value(m_instr.lock()->asmpc());
		r.set_depends_on_asmpc();
		break;
	case Type::AsmpcPhased:
		r.set_value(m_instr.lock()->asmpc_phased());
		break;
	case Type::Computed:
		r = m_expr->eval_silent();
		break;
	default:
		Assert(0);
		break;
	}

	if (g_asm.is_active() && g_asm.cur_section() != m_section.lock())
		r.set_cross_section();

	return r;
}

//-----------------------------------------------------------------------------

bool Symtab::insert(shared_ptr<Symbol> symbol) {
	const string& name = symbol->name();
	if (find(name) != nullptr) {
		if (name.substr(0, 11) == "__CDBINFO__")
			return true;	// ignore duplicates of these
		else
			return false;
	}
	else {
		m_table[name] = symbol;
		return true;
	}
}

shared_ptr<Symbol> Symtab::find(const string& name) {
	auto it = m_table.find(name);
	if (it == m_table.end())
		return nullptr;
	else {
		shared_ptr<Symbol> symbol = it->second;
		symbol->set_touched();
		return symbol;
	}
}

void Symtab::check_undefined_symbols() {
	for (auto& it : m_table) {
		shared_ptr<Symbol> symbol = it.second;
		if (symbol->type() == Symbol::Type::Undef &&
			symbol->scope() != Symbol::Scope::Extern) {
			g_errors.push_location(symbol->location());
			g_errors.error(ErrCode::UndefinedSymbol, symbol->name());
			g_errors.pop_location();
		}
	}
}

//-----------------------------------------------------------------------------

shared_ptr<Symbol> Symbols::find_local(const string& name) {
	return g_asm.cur_module()->symtab().find(name);
}

shared_ptr<Symbol> Symbols::find_global(const string& name) {
	return m_globals.find(name);
}

void Symbols::copy_defines_to_cur_module() {
	for (auto& it : m_defines) {
		shared_ptr<Symbol> symbol = it.second;
		add_local_def(symbol->name(), symbol->value().value());
	}
}

shared_ptr<Symbol> Symbols::create_or_update(Symtab& symtab, shared_ptr<Symbol> new_symbol) {
	const string& name = new_symbol->name();
	shared_ptr<Symbol> old_symbol = symtab.find(name);
	if (!old_symbol) {						// does not exist
		Assert(symtab.insert(new_symbol));
		return new_symbol;
	}
	else if (old_symbol->type() == Symbol::Type::Undef) {	// declared but not defined
		old_symbol->update(*new_symbol);
		return old_symbol;
	}
	else {								// already defined
		if (name.substr(0, 11) == "__CDBINFO__") {
			return old_symbol;			// ignore duplicates of these
		}
		else if (old_symbol->section() != nullptr &&
			old_symbol->section()->module() != new_symbol->section()->module()) {
			g_errors.error(ErrCode::DuplicateDefinition,
				old_symbol->section()->module()->name() + "::" + name);
			return nullptr;
		}
		else {
			g_errors.error(ErrCode::DuplicateDefinition, name);
			return nullptr;
		}
	}
}

// refer to a symbol in an expression
// search for symbol in either local tree or global table,
// create undefined symbol if not found, return symbol
shared_ptr<Symbol> Symbols::get_used(const string& name) {
	// search in local table
	auto symbol = find_local(name);
	if (symbol)
		return symbol;

	// search in global table
	symbol = find_global(name);
	if (symbol)
		return symbol;

	// create undefined symbol
	symbol = make_shared<Symbol>(Symbol::MakeUndef(), name, Symbol::Scope::Local);
	symbol->set_section(g_asm.cur_section());
	symbol->set_touched();
	Assert(g_asm.cur_module()->symtab().insert(symbol));
	return symbol;
}

// refer to a symbol in an expression from an IF statement
// search for symbol in either local tree or global table,
// return nullptr if not found
shared_ptr<Symbol> Symbols::get_used_if_exists(const string& name) {
    // search in local table
    auto symbol = find_local(name);
    if (symbol)
        return symbol;

    // search in global table
    symbol = find_global(name);
    if (symbol)
        return symbol;
    else
        return nullptr;
}

// define a static symbol(from - D command line)
shared_ptr<Symbol> Symbols::add_define(const string& name, int value) {
	auto old = m_defines.find(name);
	if (old != nullptr && old->value().is_const() && old->value().value() == value) {
		// redefined with the same value, ignore
		return old;
	}
	else {
        auto new_symbol = make_shared<Symbol>(Symbol::MakeConstant(), name, value, Symbol::Scope::Local);
		auto symbol = create_or_update(m_defines, new_symbol);
		if (g_args.verbose())
			cout << "Predefined constant: "
			<< name << " = " << int_to_hex(value, 4) << endl;
		return symbol;
	}
}

// undefine a static symbol (for pre-defined constants)
void Symbols::erase_define(const string& name) {
	m_defines.erase(name);
}
	
// define a global define (head, tail, ...)
shared_ptr<Symbol> Symbols::add_global_def(const string& name, int value) {
	auto new_symbol = make_shared<Symbol>(Symbol::MakeConstant(), name, value, Symbol::Scope::Public);
	auto symbol = create_or_update(m_globals, new_symbol);
	if (symbol)
		symbol->set_global_def();
	return symbol;
}

// define a local define (DEFINE)
shared_ptr<Symbol> Symbols::add_local_def(const string& name, int value) {
	auto symbol = make_shared<Symbol>(Symbol::MakeConstant(), name, value);
	return add_local_symbol(symbol);
}

// local symbol
shared_ptr<Symbol> Symbols::add_local_symbol(shared_ptr<Symbol> new_symbol) {
	auto symbol = create_or_update(g_asm.cur_module()->symtab(), new_symbol);
	if (symbol) {
		symbol->set_scope(Symbol::Scope::Local);
		symbol->set_section(g_asm.cur_section());
	}
	return symbol;
}

// global symbol
shared_ptr<Symbol> Symbols::add_global_symbol(shared_ptr<Symbol> new_symbol) {
	auto symbol = create_or_update(m_globals, new_symbol);
	if (symbol) {
		symbol->set_scope(Symbol::Scope::Public);
		symbol->set_section(g_asm.cur_section());
	}
	return symbol;
}

// create a symbol in the local or global tree:
// a) if not already global/extern, create in the local symbol table
// b) if declared global/extern and not defined, define now
// c) if declared global/extern and defined -> error REDEFINED
// d) if in global table and not global/extern -> define a new local symbol
shared_ptr<Symbol> Symbols::add(shared_ptr<Symbol> new_symbol) {
	const string& name = new_symbol->name();
	auto found = find_global(name);
	if (!found) 						// not declared as global/extern
		// create/update local
		return add_local_symbol(new_symbol);
	else 
		// create/update global
		return add_global_symbol(new_symbol);
}

void Symbols::declare(const string& name, Symbol::Scope scope) {
	switch (scope) {
	case Symbol::Scope::Global: declare_global(name); return;
	case Symbol::Scope::Public: declare_public(name); return;
	case Symbol::Scope::Extern: declare_extern(name); return;
	case Symbol::Scope::Local: Assert(0); return;
	default: Assert(0); return;
	}
}

void Symbols::check_undefined_symbols() {
	m_globals.check_undefined_symbols();
}

void Symbols::declare_global(const string& name) {
	auto symbol = find_local(name);
	if (!symbol) {						// not local
		symbol = find_global(name);
		if (!symbol) {					// not local, not global -> declare as global
			symbol = make_shared<Symbol>(Symbol::MakeUndef(), name, Symbol::Scope::Global);
			symbol->set_section(g_asm.cur_section());
			Assert(m_globals.insert(symbol));
		}
		else if (symbol->section()->module() == g_asm.cur_module().get() &&
			(symbol->scope() == Symbol::Scope::Public ||
				symbol->scope() == Symbol::Scope::Extern)) {
			// already declared public or extern in same module, ignore global
		}
		else if (symbol->section()->module() != g_asm.cur_module().get() ||
			symbol->scope() != Symbol::Scope::Global) {
			g_errors.error(ErrCode::SymbolRedeclaration, name);
		}
		else {
			symbol->set_scope(Symbol::Scope::Global);
		}
	}
	else {								// local
		auto global_symbol = find_global(name);
		if (!global_symbol) {			// local, not global -> redeclare as global
			symbol->set_scope(Symbol::Scope::Global);
			g_asm.cur_module()->symtab().erase(name);
			Assert(m_globals.insert(symbol));
		}
		else {							// local, global not possible
			Assert(0);
		}
	}
}

void Symbols::declare_public(const string& name) {
	auto symbol = find_local(name);
	if (!symbol) {						// not local
		symbol = find_global(name);
		if (!symbol) {					// not local, not global -> declare as global
			symbol = make_shared<Symbol>(Symbol::MakeUndef(), name, Symbol::Scope::Public);
			symbol->set_section(g_asm.cur_section());
			Assert(m_globals.insert(symbol));
		}
		else if (symbol->section()->module() == g_asm.cur_module().get() &&
			symbol->scope() == Symbol::Scope::Extern) {
			// Declared already EXTERN in the same module, change to PUBLIC
			symbol->set_scope(Symbol::Scope::Public);
		}
		else if (symbol->section()->module() == g_asm.cur_module().get() &&
			symbol->scope() == Symbol::Scope::Global) {
			// Declared already GLOBAL in the same module, ignore
		}
		else if (symbol->section()->module() != g_asm.cur_module().get() ||
			symbol->scope() != Symbol::Scope::Public) {
			g_errors.error(ErrCode::SymbolRedeclaration, name);
		}
		else {
			symbol->set_scope(Symbol::Scope::Public);
		}
	}
	else {								// local
		auto global_symbol = find_global(name);
		if (!global_symbol) {			// local, not global -> redeclare as global
			symbol->set_scope(Symbol::Scope::Public);
			g_asm.cur_module()->symtab().erase(name);
			Assert(m_globals.insert(symbol));
		}
		else {							// local, global not possible
			Assert(0);
		}
	}
}

void Symbols::declare_extern(const string& name) {
	auto symbol = find_local(name);
	if (!symbol) {						// not local
		symbol = find_global(name);
		if (!symbol) {					// not local, not global -> declare as global
			symbol = make_shared<Symbol>(Symbol::MakeUndef(), name, Symbol::Scope::Extern);
			symbol->set_section(g_asm.cur_section());
			Assert(m_globals.insert(symbol));
		}
		else if (symbol->section()->module() == g_asm.cur_module().get() &&
			(symbol->scope() == Symbol::Scope::Public ||
				symbol->scope() == Symbol::Scope::Global)) {
			// Declared already PUBLIC or GLOBAL in the same module, ignore EXTERN
		}
		else if (symbol->section()->module() != g_asm.cur_module().get() ||
			symbol->scope() != Symbol::Scope::Extern) {
			g_errors.error(ErrCode::SymbolRedeclaration, name);
		}
		else {
			symbol->set_scope(Symbol::Scope::Extern);
		}
	}
	else {								// local
		auto global_symbol = find_global(name);
		if (!global_symbol) {
			// If no external symbol of identical name has been declared, then re-declare local
			// symbol as external symbol, but only if local symbol is not defined yet
			if (symbol->type()!=Symbol::Type::Undef) {
				symbol->set_scope(Symbol::Scope::Extern);
				g_asm.cur_module()->symtab().erase(name);
				Assert(m_globals.insert(symbol));
			}
			else {						// already declared local
				g_errors.error(ErrCode::SymbolRedeclaration, name);
			}
}
		else {							// re-declaration not allowed
			g_errors.error(ErrCode::SymbolRedeclaration, name);
		}
	}
}

shared_ptr<Symbol> Symtab::use(const string& name) {
	shared_ptr<Symbol> symbol = find(name);
	if (!symbol) {
        symbol = make_shared<Symbol>(Symbol::MakeUndef(), name);
		insert(symbol);
	}
	symbol->set_touched(true);
	return symbol;
}

//-----------------------------------------------------------------------------
// C interface
//-----------------------------------------------------------------------------

void symtab_insert_static(const char* name, int value) {
	auto symbol = g_symbols.add_define(name, value);
	if (symbol) {
		if (g_args.verbose())
			cout << "Predefined constant: "
			<< name << " = " << int_to_hex(value, 4) << endl;
		define_static_def_sym(name, value);
	}
}

void symtab_insert_global_def(const char* name, int value) {
    auto old = g_symbols.defines().find(name);
    if (old != nullptr && old->value().is_const() && old->value().value() == value) {
        // ok, -D symbol redefined with same value
    }
    else {
        auto symbol = make_shared<Symbol>(Symbol::MakeConstant(), name, value);
		if (g_symbols.defines().insert(symbol)) {
			if (g_args.verbose())
				cout << "Predefined constant: "
				<< name << " = " << int_to_hex(value, 4) << endl;
			define_static_def_sym(name, value);
		}
		else {
			g_errors.error(ErrCode::DuplicateDefinition, name);
		}	
    }
}

void symtab_erase_global_def(const char* name) {
    g_symbols.defines().erase(name);
    undefine_static_def_sym(name);
}
