//-----------------------------------------------------------------------------
// z80asm preprocessor unit tests
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../expr.h"
#include "../model.h"
#include "../symbols.h"
#include "catch_amalgamated.hpp"

//-----------------------------------------------------------------------------
// Symbol evaluate tests - UPDATED
//-----------------------------------------------------------------------------

TEST_CASE("Symbol: evaluate constant symbol", "[model][symbol][evaluate]") {
    Location loc("test.asm", 30);
    Symbol sym("MAX", loc, 255, SymbolType::Constant);

    int result = sym.evaluate();
    REQUIRE(result == 255);
}

TEST_CASE("Symbol: evaluate undefined symbol throws",
          "[model][symbol][evaluate]") {
    Location loc("test.asm", 10);
    Symbol sym("undefined", loc);

    REQUIRE_THROWS_AS(sym.evaluate(), UndefinedSymbol);

    try {
        sym.evaluate();
        FAIL("Should have thrown UndefinedSymbol");
    }
    catch (const UndefinedSymbol& e) {
        REQUIRE(e.symbol_name() == "undefined");
    }
}

TEST_CASE("Symbol: evaluate address-relative symbol",
          "[model][symbol][evaluate]") {
    Location loc("test.asm", 40);
    Section sec("CODE");
    sec.set_base_address(0x8000);

    Opcode* opcode = sec.add_opcode(Opcode({ 0x00 }, loc));
    sec.compute_opcodes_addresses();

    Symbol sym("start", loc);
    sym.set_type(SymbolType::AddressRelative);
    sym.set_opcode(opcode);
    sym.set_offset(0);

    int result = sym.evaluate();
    REQUIRE(result == 0x8000);
}

TEST_CASE("Symbol: evaluate address-relative symbol with offset",
          "[model][symbol][evaluate]") {
    Location loc("test.asm", 50);
    Section sec("CODE");
    sec.set_base_address(0x8000);

    Opcode* opcode = sec.add_opcode(Opcode({ 0x00, 0x00, 0x00 }, loc));
    sec.compute_opcodes_addresses();

    Symbol sym("label", loc);
    sym.set_type(SymbolType::AddressRelative);
    sym.set_opcode(opcode);
    sym.set_offset(2);  // +2 offset

    int result = sym.evaluate();
    REQUIRE(result == 0x8002);
}

TEST_CASE("Symbol: evaluate computed symbol", "[model][symbol][evaluate]") {
    Location loc("test.asm", 50);
    Expression expr(make_binary_op(
                        ExprOp::Add,
                        make_integer(10),
                        make_integer(32)
                    ), loc);

    Symbol sym("computed", loc);
    sym.set_type(SymbolType::Computed);
    sym.set_expression(expr);

    int result = sym.evaluate();
    REQUIRE(result == 42);
}

TEST_CASE("Symbol: recursive evaluation detection",
          "[model][symbol][evaluate]") {
    Location loc("test.asm", 60);
    Module module("TEST", loc);

    // Create symbol A that references symbol B
    Symbol* sym_b = module.add_symbol("B", loc);
    Expression expr_a(make_symbol(sym_b), loc);

    Symbol* sym_a = module.add_symbol("A", loc);
    sym_a->set_type(SymbolType::Computed);
    sym_a->set_expression(expr_a);

    // Create symbol B that references symbol A (circular)
    Expression expr_b(make_symbol(sym_a), loc);
    sym_b->set_type(SymbolType::Computed);
    sym_b->set_expression(expr_b);

    // Evaluating A should detect recursion
    REQUIRE_THROWS_AS(sym_a->evaluate(), RecursiveEvaluation);

    try {
        sym_a->evaluate();
        FAIL("Should have thrown RecursiveEvaluation");
    }
    catch (const RecursiveEvaluation& e) {
        REQUIRE((e.symbol_name() == "A" || e.symbol_name() == "B"));
    }
}

TEST_CASE("Symbol: self-referential evaluation detection",
          "[model][symbol][evaluate]") {
    Location loc("test.asm", 70);
    Module module("TEST", loc);

    // Create symbol that references itself
    Symbol* sym = module.add_symbol("SELF", loc);
    Expression expr(make_symbol(sym), loc);
    sym->set_type(SymbolType::Computed);
    sym->set_expression(expr);

    REQUIRE_THROWS_AS(sym->evaluate(), RecursiveEvaluation);
}

TEST_CASE("Symbol: evaluation error for address-relative without opcode",
          "[model][symbol][evaluate]") {
    Location loc("test.asm", 80);
    Symbol sym("bad", loc);
    sym.set_type(SymbolType::AddressRelative);
    // No opcode set

    REQUIRE_THROWS_AS(sym.evaluate(), ExpressionError);
}

TEST_CASE("Symbol: evaluation error for computed without expression",
          "[model][symbol][evaluate]") {
    Location loc("test.asm", 90);
    Symbol sym("bad", loc);
    sym.set_type(SymbolType::Computed);
    // No expression set

    REQUIRE_THROWS_AS(sym.evaluate(), ExpressionError);
}

//-----------------------------------------------------------------------------
// Symbol tests
//-----------------------------------------------------------------------------

TEST_CASE("Symbol: basic constructor with name", "[model][symbol]") {
    Location loc("test.asm", 10);
    Symbol sym("label", loc);

    REQUIRE(sym.name() == "label");
    REQUIRE(sym.value() == 0);
    REQUIRE(sym.is_undefined());
    REQUIRE(sym.is_local());
    REQUIRE_FALSE(sym.is_defined());
    REQUIRE(sym.location().filename() == "test.asm");
    REQUIRE(sym.location().line_num() == 10);
}

TEST_CASE("Symbol: constant symbol", "[model][symbol]") {
    Location loc("test.asm", 30);
    Symbol sym("MAX", loc, 255, SymbolType::Constant);

    REQUIRE(sym.name() == "MAX");
    REQUIRE(sym.value() == 255);
    REQUIRE(sym.is_constant());
    REQUIRE(sym.is_defined());
    REQUIRE_FALSE(sym.is_undefined());
    REQUIRE(sym.location().filename() == "test.asm");
    REQUIRE(sym.location().line_num() == 30);
}

TEST_CASE("Symbol: address-relative symbol", "[model][symbol]") {
    Location loc("test.asm", 40);
    Section sec("CODE");
    Symbol sym("start", loc);
    sym.set_type(SymbolType::AddressRelative);
    sym.set_opcode(sec.last_opcode());
    sym.set_offset(100);

    REQUIRE(sym.name() == "start");
    REQUIRE(sym.is_address_relative());
    REQUIRE(sym.is_defined());
    REQUIRE(sym.opcode() == sec.last_opcode());
    REQUIRE(sym.offset() == 100);
    REQUIRE(sym.location().filename() == "test.asm");
    REQUIRE(sym.location().line_num() == 40);
}

TEST_CASE("Symbol: computed symbol with expression", "[model][symbol]") {
    Location loc("test.asm", 50);
    Expression expr(make_integer(42), loc);

    Symbol sym("computed", loc);
    sym.set_type(SymbolType::Computed);
    sym.set_expression(expr);

    REQUIRE(sym.name() == "computed");
    REQUIRE(sym.is_computed());
    REQUIRE(sym.is_defined());
    REQUIRE(sym.has_expression());

    REQUIRE(sym.expression().evaluate() == 42);
}

TEST_CASE("Symbol: local scope (default)", "[model][symbol]") {
    Location loc("test.asm", 60);
    Symbol sym("local_var", loc);

    REQUIRE(sym.name() == "local_var");
    REQUIRE(sym.is_local());
    REQUIRE_FALSE(sym.is_public());
    REQUIRE_FALSE(sym.is_extern());
    REQUIRE_FALSE(sym.is_exported());
    REQUIRE_FALSE(sym.is_imported());
}

TEST_CASE("Symbol: public scope", "[model][symbol]") {
    Location loc("test.asm", 70);
    Symbol sym("exported", loc, 100, SymbolType::Constant);
    sym.set_scope(SymbolScope::Public);

    REQUIRE(sym.name() == "exported");
    REQUIRE(sym.is_public());
    REQUIRE(sym.is_exported());
    REQUIRE_FALSE(sym.is_local());
    REQUIRE_FALSE(sym.is_extern());
    REQUIRE_FALSE(sym.is_imported());
}

TEST_CASE("Symbol: extern scope", "[model][symbol]") {
    Location loc("test.asm", 80);
    Symbol sym("imported", loc);
    sym.set_scope(SymbolScope::Extern);

    REQUIRE(sym.name() == "imported");
    REQUIRE(sym.is_extern());
    REQUIRE(sym.is_imported());
    REQUIRE_FALSE(sym.is_defined());
    REQUIRE_FALSE(sym.is_public());
    REQUIRE_FALSE(sym.is_exported());
}

TEST_CASE("Symbol: global scope with defined symbol acts as public",
          "[model][symbol]") {
    Location loc("test.asm", 90);
    Symbol sym("global_defined", loc, 200, SymbolType::Constant);
    sym.set_scope(SymbolScope::Global);

    REQUIRE(sym.name() == "global_defined");
    REQUIRE(sym.is_global());
    REQUIRE(sym.is_defined());
    REQUIRE(sym.is_public());
    REQUIRE(sym.is_exported());
    REQUIRE_FALSE(sym.is_extern());
    REQUIRE_FALSE(sym.is_imported());
}

TEST_CASE("Symbol: global scope with undefined symbol acts as extern",
          "[model][symbol]") {
    Location loc("test.asm", 100);
    Symbol sym("global_undefined", loc);
    sym.set_scope(SymbolScope::Global);

    REQUIRE(sym.name() == "global_undefined");
    REQUIRE(sym.is_global());
    REQUIRE_FALSE(sym.is_defined());
    REQUIRE(sym.is_extern());
    REQUIRE(sym.is_imported());
    REQUIRE_FALSE(sym.is_public());
    REQUIRE_FALSE(sym.is_exported());
}

TEST_CASE("Symbol: location is always available", "[model][symbol]") {
    Location loc("main.asm", 42);
    Symbol sym("test", loc);

    REQUIRE(sym.name() == "test");
    REQUIRE(sym.location().filename() == "main.asm");
    REQUIRE(sym.location().line_num() == 42);

    // Symbol location can still be updated (different from Expression)
    Location new_loc("other.asm", 99);
    sym.set_location(new_loc);

    REQUIRE(sym.location().filename() == "other.asm");
    REQUIRE(sym.location().line_num() == 99);
}

TEST_CASE("Symbol: type transitions", "[model][symbol]") {
    Location loc("test.asm", 110);
    Symbol sym("var", loc);

    REQUIRE(sym.name() == "var");
    REQUIRE(sym.is_undefined());

    sym.set_type(SymbolType::Constant);
    sym.set_value(100);
    REQUIRE(sym.is_constant());
    REQUIRE(sym.is_defined());
    REQUIRE(sym.value() == 100);

    sym.set_type(SymbolType::AddressRelative);
    REQUIRE(sym.is_address_relative());
    REQUIRE(sym.is_defined());
}

TEST_CASE("Symbol: scope transitions", "[model][symbol]") {
    Location loc("test.asm", 120);
    Symbol sym("test", loc, 50, SymbolType::Constant);

    REQUIRE(sym.name() == "test");

    // Start as local
    REQUIRE(sym.is_local());

    // Change to public
    sym.set_scope(SymbolScope::Public);
    REQUIRE(sym.is_public());
    REQUIRE(sym.is_exported());

    // Change to global (acts as public since defined)
    sym.set_scope(SymbolScope::Global);
    REQUIRE(sym.is_global());
    REQUIRE(sym.is_public());
    REQUIRE(sym.is_exported());
}

TEST_CASE("Symbol: address-relative with section", "[model][symbol]") {
    Location loc("test.asm", 130);
    Section sec("CODE");
    sec.set_base_address(0x8000);

    Symbol sym("loop", loc);
    sym.set_type(SymbolType::AddressRelative);
    sym.set_opcode(sec.last_opcode());
    sym.set_offset(0x50);

    REQUIRE(sym.name() == "loop");
    REQUIRE(sym.is_address_relative());
    REQUIRE(sym.opcode() == sec.last_opcode());
    REQUIRE(sym.offset() == 0x50);
    REQUIRE(sym.location().filename() == "test.asm");
    REQUIRE(sym.location().line_num() == 130);
}

TEST_CASE("Symbol: computed with complex expression", "[model][symbol]") {
    Location loc("calc.asm", 100);
    auto node = make_binary_op(
                    ExprOp::Add,
                    make_integer(10),
                    make_binary_op(ExprOp::Multiply, make_integer(3), make_integer(4))
                );
    Expression expr(std::move(node), loc);

    Symbol sym("result", loc);
    sym.set_type(SymbolType::Computed);
    sym.set_expression(expr);

    REQUIRE(sym.name() == "result");
    REQUIRE(sym.is_computed());
    REQUIRE(sym.has_expression());

    REQUIRE(sym.expression().evaluate() == 22); // 10 + (3 * 4)
}

TEST_CASE("Symbol: all symbol types", "[model][symbol]") {
    Location loc("test.asm", 140);

    Symbol undef("undef", loc);
    REQUIRE(undef.name() == "undef");
    REQUIRE(undef.is_undefined());
    REQUIRE_FALSE(undef.is_defined());

    Symbol constant("PI", loc, 314, SymbolType::Constant);
    REQUIRE(constant.name() == "PI");
    REQUIRE(constant.is_constant());
    REQUIRE(constant.is_defined());

    Symbol label("start", loc);
    label.set_type(SymbolType::AddressRelative);
    REQUIRE(label.name() == "start");
    REQUIRE(label.is_address_relative());
    REQUIRE(label.is_defined());

    Symbol computed("expr", loc);
    computed.set_type(SymbolType::Computed);
    REQUIRE(computed.name() == "expr");
    REQUIRE(computed.is_computed());
    REQUIRE(computed.is_defined());
}

TEST_CASE("Symbol: empty name is allowed but discouraged", "[model][symbol]") {
    Location loc("test.asm", 150);
    Symbol sym("", loc);

    REQUIRE(sym.name() == "");
    REQUIRE(sym.location().filename() == "test.asm");
    REQUIRE(sym.location().line_num() == 150);
}

TEST_CASE("Symbol: name is immutable", "[model][symbol]") {
    Location loc("test.asm", 160);
    Symbol sym("symbol_name", loc);

    REQUIRE(sym.name() == "symbol_name");

    // Name cannot be changed - it's the key in the symbol table
    // The following would not compile:
    // sym.set_name("new_name");  // ERROR: no member function 'set_name'
}

