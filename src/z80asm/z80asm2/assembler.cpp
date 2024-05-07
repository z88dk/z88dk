//-----------------------------------------------------------------------------
// z80asm - assembler
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "assembler.h"
#include "common.h"
#include "object.h"
#include "parser.h"
#include "xassert.h"
#include <iomanip>
#include <iostream>
#include <sstream>
using namespace std;

Assembler::Assembler() {
    locations_.emplace_back();          // stack always has at least one element
}

Assembler::~Assembler() {
}

void Assembler::clear() {
    locations_.clear();
    locations_.emplace_back();          // stack always has at least one element
    errors_.clear();
    filename_.clear();
    object_ = nullptr;
    parser_ = nullptr;
    defines_.clear();
    global_symbols_.clear();
    asmpc_ = nullptr;
    start_errors_ = 0;
}

bool Assembler::assemble(const string& filename) {
    if (options_.verbose())
        cout << "Assembling '" << filename << "'" << endl;

    start_errors_ = errors_.count();

    // create object and parser
    filename_ = filename;
    object_ = new Object(filename);
    parser_ = new Parser();

    // clear globals
    global_symbols_.clear();

    // assemble
    assemble1();

    if (options_.verbose())
        cout << endl;

    filename_.clear();
    delete object_; object_ = nullptr;
    delete parser_; parser_ = nullptr;

    // exit true if no more errors
    return !got_errors();
}

Options& Assembler::options() {
    return options_;
}

void Assembler::push_location(const Location& location) {
    locations_.push_back(location);
    errors_.set_location(location);
}

void Assembler::pop_location() {
    if (locations_.size() > 1)
        locations_.pop_back();
    else
        locations_.back().clear();
    errors_.set_location(locations_.back());
}

const Location& Assembler::location() const {
    return locations_.back();
}

void Assembler::set_location(const Location& location) {
    locations_.back() = location;
    errors_.set_location(location);
}

void Assembler::clear_location() {
    locations_.back().clear();
    errors_.clear_location();
}

void Assembler::set_source_line(const string& line) {
    errors_.set_source_line(line);
}

void Assembler::set_expanded_line(const string& line) {
    errors_.set_expanded_line(line);
}

string Assembler::source_line() {
    return errors_.source_line();
}

string Assembler::expanded_line() {
    return errors_.expanded_line();
}

int Assembler::error_count() const {
    return errors_.count();
}

void Assembler::set_error_output(ostream& os) {
    errors_.set_output(os);
}

void Assembler::error(ErrCode err_code, const string& argument) {
    errors_.error(err_code, argument);
}

void Assembler::error(ErrCode err_code, int argument) {
    errors_.error(err_code, argument);
}

void Assembler::warning(ErrCode err_code, const string& argument) {
    errors_.warning(err_code, argument);
}

void Assembler::warning(ErrCode err_code, int argument) {
    errors_.warning(err_code, argument);
}

string Assembler::autolabel() {
    static int n = 0;
    ostringstream oss;
    oss << "z80asm$" << setw(4) << setfill('0') << n++;
    return oss.str();
}

Symbol* Assembler::add_asmpc_instr() {
    string asmpc_name = autolabel();
    asmpc_ = add_label(asmpc_name);
    return asmpc_;
}

Symbol* Assembler::add_label(const string& name) {
    Instr* instr = add_instr();
    Symbol* label = add_symbol(name);
    if (label) {
        label->set_type(TYPE_ADDRESS);
        instr->set_label(label);
        return label;
    }
    else
        return nullptr;
}

Symbol* Assembler::asmpc() const {
    xassert(asmpc_);
    return asmpc_;
}

Instr* Assembler::add_instr() {
    Instr* instr = cur_module()->cur_section()->add_instr();
    return instr;
}

Instr* Assembler::add_instr(int opcode) {
    Instr* instr = add_instr();
    instr->set_bytes(opcode);
    return instr;
}

Symbol* Assembler::find_symbol(const string& name) {
    Symbol* symbol = find_local_symbol(name);
    if (!symbol)
        symbol = find_global_symbol(name);
    if (!symbol)
        symbol = find_global_define(name);
    return symbol;
}

Symbol* Assembler::add_symbol(const string& name) {
    Module* module1 = cur_module();
    xassert(module1);

    // check if already defined
    Symbol* symbol = find_symbol(name);
    if (!symbol) {                              // new symbol
        symbol = new Symbol(name, SCOPE_LOCAL, TYPE_CONSTANT, module1->cur_section());
        bool ok = module1->local_symbols()->insert(symbol);
        xassert(ok);
        return symbol;
    }
    else if (symbol->is_global_def()) {         // global define, make a copy
        ExprResult res = symbol->eval();
        xassert(res.ok());
        int value = res.value();
        symbol = new Symbol(name, SCOPE_LOCAL, TYPE_CONSTANT, module1->cur_section());
        symbol->set_value(value);
        bool ok = module1->local_symbols()->insert(symbol);
        xassert(ok);
        return symbol;
    }
    else if (symbol->type() == TYPE_UNDEFINED) {// already declared
        symbol->set_type(TYPE_CONSTANT);
        symbol->set_location(location());
        return symbol;
    }
    else {                                      // already defined
        error(ErrDuplicateDefinition, name);
        return nullptr;
    }
}

Symbol* Assembler::use_symbol(const string& name) {
    Module* module1 = cur_module();
    xassert(module1);

    // check if already defined
    Symbol* symbol = find_symbol(name);
    if (!symbol) {                               // new symbol
        symbol = new Symbol(name, SCOPE_LOCAL, TYPE_UNDEFINED, module1->cur_section());
        bool ok = module1->local_symbols()->insert(symbol);
        xassert(ok);
    }
    else if (symbol->is_global_def()) {         // global define, make a copy
        ExprResult res = symbol->eval();
        xassert(res.ok());
        int value = res.value();
        symbol = new Symbol(name, SCOPE_LOCAL, TYPE_CONSTANT, module1->cur_section());
        symbol->set_value(value);
        bool ok = module1->local_symbols()->insert(symbol);
        xassert(ok);
    }
    symbol->set_touched();
    return symbol;
}

Symbol* Assembler::add_define(const string& name, int value) {
    Symbol* symbol = defines_.find(name);
    if (symbol) {                   // already defined
        ExprResult res = symbol->eval();
        if (!res.ok()) {
            res.error();
            return nullptr;
        }
        else if (res.value() != value) {
            error(ErrDuplicateDefinition, name);
            return nullptr;
        }
        else {
            return symbol;          // OK, already defined but same value
        }
    }
    else {
        symbol = new Symbol(name, SCOPE_LOCAL, TYPE_CONSTANT, nullptr);
        symbol->set_global_def();
        bool ok = defines_.insert(symbol);
        xassert(ok);
        return symbol;
    }
}

void Assembler::erase_define(const string& name) {
    Symbol* symbol = defines_.erase(name);
    if (symbol)
        delete symbol;
}

Symbol* Assembler::declare_extern(const string& name) {
    Module* module1 = cur_module();
    xassert(module1);

    // check if already defined
    Symbol* symbol = find_symbol(name);
    if (!symbol) {                               // new symbol
        symbol = new Symbol(name, SCOPE_EXTERN, TYPE_UNDEFINED, module1->cur_section());
        bool ok = global_symbols_.insert(symbol);
        xassert(ok);
    }
    else if (symbol->is_global_def()) {         // global define, make a copy
        ExprResult res = symbol->eval();
        xassert(res.ok());
        int value = res.value();
        symbol = new Symbol(name, SCOPE_LOCAL, TYPE_CONSTANT, module1->cur_section());
        symbol->set_value(value);
        bool ok = module1->local_symbols()->insert(symbol);
        xassert(ok);
    }
    symbol->set_touched();
    return symbol;
}

Symbol* Assembler::declare_public(const string& name) {
    Module* module1 = cur_module();
    xassert(module1);

    // check if already defined
    Symbol* symbol = find_symbol(name);
    if (!symbol) {                               // new symbol
        symbol = new Symbol(name, SCOPE_PUBLIC, TYPE_UNDEFINED, module1->cur_section());
        bool ok = global_symbols_.insert(symbol);
        xassert(ok);
    }
    else if (symbol->is_global_def()) {         // global define, make a copy
        ExprResult res = symbol->eval();
        xassert(res.ok());
        int value = res.value();
        symbol = new Symbol(name, SCOPE_LOCAL, TYPE_CONSTANT, module1->cur_section());
        symbol->set_value(value);
        bool ok = module1->local_symbols()->insert(symbol);
        xassert(ok);
    }
    symbol->set_touched();
    return symbol;
}

Symbol* Assembler::declare_global(const string& name) {
    Module* module1 = cur_module();
    xassert(module1);

    // check if already defined
    Symbol* symbol = find_symbol(name);
    if (!symbol) {                               // new symbol
        symbol = new Symbol(name, SCOPE_GLOBAL, TYPE_UNDEFINED, module1->cur_section());
        bool ok = global_symbols_.insert(symbol);
        xassert(ok);
    }
    else if (symbol->is_global_def()) {         // global define, make a copy
        ExprResult res = symbol->eval();
        xassert(res.ok());
        int value = res.value();
        symbol = new Symbol(name, SCOPE_LOCAL, TYPE_CONSTANT, module1->cur_section());
        symbol->set_value(value);
        bool ok = module1->local_symbols()->insert(symbol);
        xassert(ok);
    }
    symbol->set_touched();
    return symbol;
}

Module* Assembler::cur_module() {
    if (!object_)
        return nullptr;
    Module* module1 = object_->cur_module();
    return module1;         
}

Symbol* Assembler::find_local_symbol(const string& name) {
    Module* module1 = cur_module();
    if (module1)
        return module1->local_symbols()->find(name);
    else
        return nullptr;
}

Symbol* Assembler::find_global_symbol(const string& name) {
    return global_symbols_.find(name);
}

Symbol* Assembler::find_global_define(const string& name) {
    return defines_.find(name);
}

bool Assembler::got_errors() const {
    return start_errors_ != errors_.count();
}

void Assembler::assemble1() {
    // create parent directory of object file
    string o_filename = file_o_filename(filename_);
    string parent_dir = file_parent_path(o_filename);
    if (!file_is_directory(parent_dir)) {
        if (!file_create_directories(parent_dir)) {
            error(ErrDirCreate, parent_dir);
            perror(parent_dir.c_str());
            return;
        }
    }

    parser_->parse(filename_);
    if (got_errors())
        return;

    check_relative_jumps();
    if (got_errors())
        return;

    patch_local_exprs();
    if (got_errors())
        return;

    check_undefined_symbols();
    if (got_errors())
        return;

    write_obj_file(o_filename);
    if (got_errors())
        return;

}

void Assembler::check_relative_jumps() {
    // TODO
}

void Assembler::patch_local_exprs() {
    // TODO
}

void Assembler::check_undefined_symbols() {
    // TODO
}

void Assembler::write_obj_file(const string& /*filename*/) {
    // TODO
}

