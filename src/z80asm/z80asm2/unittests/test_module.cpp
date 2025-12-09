//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../module.h"
#include "../errors.h"
#include "../section.h"
#include "catch_amalgamated.hpp"

//-----------------------------------------------------------------------------
// Module and Symbol declaration/definition tests
//-----------------------------------------------------------------------------

TEST_CASE("Module: declare_symbol creates new undefined symbol with scope",
          "[model][module][declare]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    Symbol* sym = module.declare_symbol("FOO", loc, SymbolScope::Public);

    REQUIRE(sym != nullptr);
    REQUIRE(sym->name() == "FOO");
    REQUIRE(sym->is_undefined());
    REQUIRE(sym->scope() == SymbolScope::Public);
    REQUIRE(sym->location().filename() == "test.asm");
    REQUIRE(sym->location().line_num() == 10);

    REQUIRE(module.has_symbol("FOO"));
}

TEST_CASE("Module: declare_symbol allows scope update from Local",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 10);
    Location loc2("test.asm", 20);
    Module module("TEST", loc1);

    // First declare as Local (default)
    Symbol* sym1 = module.declare_symbol("BAR", loc1, SymbolScope::Local);
    REQUIRE(sym1->scope() == SymbolScope::Local);

    // Update to Public - should succeed
    Symbol* sym2 = module.declare_symbol("BAR", loc2, SymbolScope::Public);
    REQUIRE(sym2 == sym1);  // Same symbol
    REQUIRE(sym2->scope() == SymbolScope::Public);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Module: declare_symbol allows same scope redeclaration",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 30);
    Location loc2("test.asm", 40);
    Module module("TEST", loc1);

    // Declare as Public
    Symbol* sym1 = module.declare_symbol("EXPORT", loc1, SymbolScope::Public);
    REQUIRE(sym1->scope() == SymbolScope::Public);

    // Redeclare as Public - should succeed without error
    Symbol* sym2 = module.declare_symbol("EXPORT", loc2, SymbolScope::Public);
    REQUIRE(sym2 == sym1);  // Same symbol
    REQUIRE(sym2->scope() == SymbolScope::Public);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Module: declare_symbol errors on scope conflict (Public to Extern)",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 50);
    Location loc2("test.asm", 60);
    Module module("TEST", loc1);

    // Declare as Public
    Symbol* sym1 = module.declare_symbol("CONFLICT", loc1, SymbolScope::Public);
    REQUIRE(sym1->scope() == SymbolScope::Public);

    // Try to change to Extern - should error
    Symbol* sym2 = module.declare_symbol("CONFLICT", loc2, SymbolScope::Extern);
    REQUIRE(sym2 == sym1);  // Returns same symbol despite error
    REQUIRE(sym1->scope() == SymbolScope::Public);  // Scope unchanged

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:60:") != std::string::npos);
    REQUIRE(msg.find("Symbol redefined") != std::string::npos);
    REQUIRE(msg.find("CONFLICT") != std::string::npos);
}

TEST_CASE("Module: declare_symbol errors on scope conflict (Extern to Public)",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 70);
    Location loc2("test.asm", 80);
    Module module("TEST", loc1);

    // Declare as Extern
    Symbol* sym1 = module.declare_symbol("IMPORT", loc1, SymbolScope::Extern);
    REQUIRE(sym1->scope() == SymbolScope::Extern);

    // Try to change to Public - should error
    Symbol* sym2 = module.declare_symbol("IMPORT", loc2, SymbolScope::Public);
    REQUIRE(sym2 == sym1);  // Returns same symbol despite error
    REQUIRE(sym1->scope() == SymbolScope::Extern);  // Scope unchanged

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:80:") != std::string::npos);
    REQUIRE(msg.find("Symbol redefined") != std::string::npos);
}

TEST_CASE("Module: declare_symbol errors declaring defined symbol as Extern",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 90);
    Location loc2("test.asm", 100);
    Module module("TEST", loc1);

    // Define symbol
    Symbol* sym1 = module.add_symbol("DEFINED", loc1, 42, SymbolType::Constant);
    REQUIRE(sym1->is_defined());
    REQUIRE(sym1->value() == 42);

    // Try to declare as Extern - should error
    Symbol* sym2 = module.declare_symbol("DEFINED", loc2, SymbolScope::Extern);
    REQUIRE(sym2 == sym1);  // Returns same symbol despite error
    REQUIRE(sym1->is_defined());  // Still defined

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:100:") != std::string::npos);
    REQUIRE(msg.find("Symbol redefined") != std::string::npos);
    REQUIRE(msg.find("cannot declare defined symbol as EXTERN") !=
            std::string::npos);
}

TEST_CASE("Module: declare_symbol allows Global scope transitions",
          "[model][module][declare]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 110);
    Location loc2("test.asm", 120);
    Module module("TEST", loc1);

    // Declare as Global
    Symbol* sym1 = module.declare_symbol("GLOBAL_SYM", loc1, SymbolScope::Global);
    REQUIRE(sym1->scope() == SymbolScope::Global);

    // Change to Public - should succeed (Global can transition)
    Symbol* sym2 = module.declare_symbol("GLOBAL_SYM", loc2, SymbolScope::Public);
    REQUIRE(sym2 == sym1);
    REQUIRE(sym2->scope() == SymbolScope::Public);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Module: add_symbol creates new undefined symbol",
          "[model][module][add]") {
    Location loc("test.asm", 130);
    Module module("TEST", loc);

    Symbol* sym = module.add_symbol("NEW_SYM", loc);

    REQUIRE(sym != nullptr);
    REQUIRE(sym->name() == "NEW_SYM");
    REQUIRE(sym->is_undefined());
    REQUIRE(sym->scope() == SymbolScope::Local);
    REQUIRE(sym->location().filename() == "test.asm");
    REQUIRE(sym->location().line_num() == 130);
}

TEST_CASE("Module: add_symbol creates new defined symbol",
          "[model][module][add]") {
    Location loc("test.asm", 140);
    Module module("TEST", loc);

    Symbol* sym = module.add_symbol("CONST", loc, 100, SymbolType::Constant);

    REQUIRE(sym != nullptr);
    REQUIRE(sym->name() == "CONST");
    REQUIRE(sym->is_constant());
    REQUIRE(sym->is_defined());
    REQUIRE(sym->value() == 100);
    REQUIRE(sym->location().filename() == "test.asm");
    REQUIRE(sym->location().line_num() == 140);
}

TEST_CASE("Module: add_symbol updates undefined symbol",
          "[model][module][add]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 150);
    Location loc2("test.asm", 160);
    Module module("TEST", loc1);

    // Create undefined symbol
    Symbol* sym1 = module.add_symbol("FORWARD", loc1);
    REQUIRE(sym1->is_undefined());

    // Define it later
    Symbol* sym2 = module.add_symbol("FORWARD", loc2, 200, SymbolType::Constant);
    REQUIRE(sym2 == sym1);  // Same symbol
    REQUIRE(sym2->is_constant());
    REQUIRE(sym2->is_defined());
    REQUIRE(sym2->value() == 200);
    REQUIRE(sym2->location().line_num() == 160);  // Location updated
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Module: add_symbol errors on redefinition", "[model][module][add]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 170);
    Location loc2("test.asm", 180);
    Module module("TEST", loc1);

    // Define symbol
    Symbol* sym1 = module.add_symbol("LABEL", loc1, 0x8000,
                                     SymbolType::AddressRelative);
    REQUIRE(sym1->is_defined());
    REQUIRE(sym1->value() == 0x8000);

    // Try to redefine - should error
    Symbol* sym2 = module.add_symbol("LABEL", loc2, 0x9000,
                                     SymbolType::AddressRelative);
    REQUIRE(sym2 == sym1);  // Returns same symbol despite error
    REQUIRE(sym1->value() == 0x8000);  // Value unchanged

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:180:") != std::string::npos);
    REQUIRE(msg.find("Symbol redefined") != std::string::npos);
    REQUIRE(msg.find("LABEL") != std::string::npos);
}

TEST_CASE("Module: add_symbol errors defining Extern symbol",
          "[model][module][add]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 190);
    Location loc2("test.asm", 200);
    Module module("TEST", loc1);

    // Declare as Extern
    Symbol* sym1 = module.declare_symbol("EXTERNAL", loc1, SymbolScope::Extern);
    REQUIRE(sym1->is_extern());
    REQUIRE(sym1->is_undefined());

    // Try to define - should error
    Symbol* sym2 = module.add_symbol("EXTERNAL", loc2, 100, SymbolType::Constant);
    REQUIRE(sym2 == sym1);  // Returns same symbol despite error

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:200:") != std::string::npos);
    REQUIRE(msg.find("Symbol redefined") != std::string::npos);
    REQUIRE(msg.find("cannot define EXTERN symbol") != std::string::npos);
}

TEST_CASE("Module: add_symbol updates location only when defining",
          "[model][module][add]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 210);
    Location loc2("test.asm", 220);
    Module module("TEST", loc1);

    // Create undefined symbol
    Symbol* sym1 = module.add_symbol("TEST_SYM", loc1);
    REQUIRE(sym1->location().line_num() == 210);

    // Define it - location should update
    Symbol* sym2 = module.add_symbol("TEST_SYM", loc2, 50, SymbolType::Constant);
    REQUIRE(sym2->location().line_num() == 220);
    REQUIRE_FALSE(g_errors.has_errors());
}

//-----------------------------------------------------------------------------
// Integration tests: declare and define workflow
//-----------------------------------------------------------------------------

TEST_CASE("Integration: PUBLIC declaration followed by definition",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("module.asm", 10);
    Location loc2("module.asm", 50);
    Module module("MYMODULE", loc1);

    // Declare PUBLIC first
    Symbol* sym1 = module.declare_symbol("API_FUNC", loc1, SymbolScope::Public);
    REQUIRE(sym1->is_public());
    REQUIRE(sym1->is_undefined());

    // Define it later
    Symbol* sym2 = module.add_symbol("API_FUNC", loc2, 0x8000,
                                     SymbolType::AddressRelative);
    REQUIRE(sym2 == sym1);
    REQUIRE(sym2->is_defined());
    REQUIRE(sym2->is_public());
    REQUIRE(sym2->is_exported());
    REQUIRE(sym2 == sym1);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: EXTERN declaration stays undefined",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("main.asm", 10);
    Module module("MAIN", loc1);

    // Declare EXTERN
    Symbol* sym = module.declare_symbol("LIBRARY_FUNC", loc1, SymbolScope::Extern);
    REQUIRE(sym->is_extern());
    REQUIRE(sym->is_undefined());
    REQUIRE(sym->is_imported());
    REQUIRE_FALSE(g_errors.has_errors());

    // Cannot define EXTERN symbols
    Location loc2("main.asm", 50);
    module.add_symbol("LIBRARY_FUNC", loc2, 0x9000, SymbolType::AddressRelative);
    REQUIRE(g_errors.has_errors());
}

TEST_CASE("Integration: GLOBAL declaration then definition acts as PUBLIC",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("module.asm", 10);
    Location loc2("module.asm", 50);
    Module module("TEST", loc1);

    // Declare GLOBAL (undefined)
    Symbol* sym1 = module.declare_symbol("GLOBAL_VAR", loc1, SymbolScope::Global);
    REQUIRE(sym1->is_global());
    REQUIRE(sym1->is_undefined());
    REQUIRE(sym1->is_extern());  // Acts as EXTERN when undefined
    REQUIRE(sym1->is_imported());

    // Define it
    Symbol* sym2 = module.add_symbol("GLOBAL_VAR", loc2, 42, SymbolType::Constant);
    REQUIRE(sym2->is_global());
    REQUIRE(sym2->is_defined());
    REQUIRE(sym2->is_public());  // Acts as PUBLIC when defined
    REQUIRE(sym2->is_exported());
    REQUIRE(sym2 == sym1);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: definition before PUBLIC declaration",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("module.asm", 10);
    Location loc2("module.asm", 50);
    Module module("TEST", loc1);

    // Define first (as Local)
    Symbol* sym1 = module.add_symbol("FUNC", loc1, 0x8000,
                                     SymbolType::AddressRelative);
    REQUIRE(sym1->is_defined());
    REQUIRE(sym1->is_local());

    // Declare PUBLIC later - should update scope
    Symbol* sym2 = module.declare_symbol("FUNC", loc2, SymbolScope::Public);
    REQUIRE(sym2 == sym1);
    REQUIRE(sym2->is_public());
    REQUIRE(sym2->is_defined());
    REQUIRE(sym2 == sym1);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: multiple forward references", "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("program.asm", 10);
    Location loc2("program.asm", 20);
    Location loc3("program.asm", 30);
    Location loc4("program.asm", 100);
    Module module("TEST", loc1);

    // Multiple forward references (undefined)
    Symbol* sym1 = module.add_symbol("LOOP", loc1);
    Symbol* sym2 = module.add_symbol("LOOP", loc2);
    Symbol* sym3 = module.add_symbol("LOOP", loc3);

    REQUIRE(sym1 == sym2);
    REQUIRE(sym2 == sym3);
    REQUIRE(sym1->is_undefined());

    // Finally define it
    Symbol* sym4 = module.add_symbol("LOOP", loc4, 0x8050,
                                     SymbolType::AddressRelative);
    REQUIRE(sym4 == sym1);
    REQUIRE(sym4->is_defined());
    REQUIRE(sym4->value() == 0x8050);
    REQUIRE(sym1 == sym4);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: scope conflict detection", "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("conflict.asm", 10);
    Location loc2("conflict.asm", 20);
    Location loc3("conflict.asm", 30);
    Module module("TEST", loc1);

    // Declare as PUBLIC
    module.declare_symbol("SYMBOL", loc1, SymbolScope::Public);
    REQUIRE_FALSE(g_errors.has_errors());

    // Try to redeclare as EXTERN - should error
    module.declare_symbol("SYMBOL", loc2, SymbolScope::Extern);
    REQUIRE(g_errors.has_errors());
    SuppressErrors suppress2;

    // PUBLIC to PUBLIC is fine
    module.declare_symbol("SYMBOL", loc3, SymbolScope::Public);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: typical assembly workflow", "[model][integration]") {
    SuppressErrors suppress;
    Location loc("test.asm", 1);
    Module module("MAIN", loc);

    // Line 10: PUBLIC start
    loc.set_line_num(10);
    module.declare_symbol("start", loc, SymbolScope::Public);

    // Line 20: EXTERN printf
    loc.set_line_num(20);
    module.declare_symbol("printf", loc, SymbolScope::Extern);

    // Line 30: start: (label definition)
    loc.set_line_num(30);
    Symbol* start = module.add_symbol("start", loc, 0x8000,
                                      SymbolType::AddressRelative);

    // Line 40: MAX_SIZE EQU 100
    loc.set_line_num(40);
    Symbol* max_size = module.add_symbol("MAX_SIZE", loc, 100,
                                         SymbolType::Constant);

    // Line 50: loop: (local label)
    loc.set_line_num(50);
    Symbol* loop = module.add_symbol("loop", loc, 0x8010,
                                     SymbolType::AddressRelative);

    REQUIRE_FALSE(g_errors.has_errors());

    // Verify symbols
    REQUIRE(start->is_public());
    REQUIRE(start->is_defined());
    REQUIRE(start->is_exported());
    REQUIRE(start->value() == 0x8000);

    REQUIRE(module.find_symbol("printf")->is_extern());
    REQUIRE(module.find_symbol("printf")->is_undefined());
    REQUIRE(module.find_symbol("printf")->is_imported());

    REQUIRE(max_size->is_constant());
    REQUIRE(max_size->is_local());
    REQUIRE(max_size->value() == 100);

    REQUIRE(loop->is_address_relative());
    REQUIRE(loop->is_local());
    REQUIRE(loop->value() == 0x8010);
}

TEST_CASE("Integration: error recovery continues after redefinition",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 10);
    Location loc2("test.asm", 20);
    Location loc3("test.asm", 30);
    Module module("TEST", loc1);

    // Define a symbol
    module.add_symbol("DUP", loc1, 100, SymbolType::Constant);
    REQUIRE_FALSE(g_errors.has_errors());

    // Try to redefine (error)
    module.add_symbol("DUP", loc2, 200, SymbolType::Constant);
    REQUIRE(g_errors.has_errors());
    SuppressErrors suppress2;

    // Can still define new symbols after error
    Symbol* new_sym = module.add_symbol("NEW", loc3, 300, SymbolType::Constant);
    REQUIRE(new_sym->value() == 300);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: all scope types with definitions",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc("scopes.asm", 1);
    Module module("TEST", loc);

    // Local symbol (default)
    loc.set_line_num(10);
    Symbol* local_sym = module.add_symbol("local_var", loc, 10,
                                          SymbolType::Constant);
    REQUIRE(local_sym->is_local());
    REQUIRE_FALSE(local_sym->is_exported());
    REQUIRE_FALSE(local_sym->is_imported());

    // Public symbol (exported)
    loc.set_line_num(20);
    module.declare_symbol("public_func", loc, SymbolScope::Public);
    Symbol* public_sym = module.add_symbol("public_func", loc, 0x8000,
                                           SymbolType::AddressRelative);
    REQUIRE(public_sym->is_public());
    REQUIRE(public_sym->is_exported());

    // Extern symbol (imported, stays undefined)
    loc.set_line_num(30);
    Symbol* extern_sym = module.declare_symbol("extern_func", loc,
                         SymbolScope::Extern);
    REQUIRE(extern_sym->is_extern());
    REQUIRE(extern_sym->is_imported());
    REQUIRE(extern_sym->is_undefined());

    // Global symbol (acts as PUBLIC when defined)
    loc.set_line_num(40);
    module.declare_symbol("global_var", loc, SymbolScope::Global);
    Symbol* global_sym = module.add_symbol("global_var", loc, 42,
                                           SymbolType::Constant);
    REQUIRE(global_sym->is_global());
    REQUIRE(global_sym->is_public());  // Acts as PUBLIC when defined
    REQUIRE(global_sym->is_exported());

    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: cannot redefine after error", "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 10);
    Location loc2("test.asm", 20);
    Module module("TEST", loc1);

    // Define symbol
    Symbol* sym1 = module.add_symbol("TWICE", loc1, 100, SymbolType::Constant);
    REQUIRE(sym1->value() == 100);

    // Try to redefine (error)
    Symbol* sym2 = module.add_symbol("TWICE", loc2, 200, SymbolType::Constant);
    REQUIRE(g_errors.has_errors());

    // Symbol unchanged despite error
    REQUIRE(sym2 == sym1);
    REQUIRE(sym1->value() == 100);  // Original value preserved
}

TEST_CASE("Integration: declare Extern then try to define (error)",
          "[model][integration]") {
    SuppressErrors suppress;
    Location loc1("test.asm", 10);
    Location loc2("test.asm", 50);
    Module module("TEST", loc1);

    // Declare EXTERN
    Symbol* sym1 = module.declare_symbol("LIB_FUNC", loc1, SymbolScope::Extern);
    REQUIRE(sym1->is_extern());
    REQUIRE(sym1->is_undefined());

    // Try to define (should error)
    Symbol* sym2 = module.add_symbol("LIB_FUNC", loc2, 0x9000,
                                     SymbolType::AddressRelative);
    REQUIRE(sym2 == sym1);
    REQUIRE(g_errors.has_errors());

    // Symbol remains EXTERN and undefined
    REQUIRE(sym1->is_extern());
    REQUIRE(sym1->is_undefined());
}

//-----------------------------------------------------------------------------
// Module section management tests
//-----------------------------------------------------------------------------

TEST_CASE("Module: constructor creates default empty section",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    REQUIRE(module.sections().size() == 1);
    REQUIRE(module.sections()[0]->name() == "");
    REQUIRE(module.current_section() != nullptr);
    REQUIRE(module.current_section()->name() == "");
}

TEST_CASE("Module: default section is current after construction",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    Section* default_section = module.sections()[0].get();
    REQUIRE(module.current_section() == default_section);
}

TEST_CASE("Module: add_section creates new section and makes it current",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    Section* code_section = module.add_section("CODE");

    REQUIRE(code_section != nullptr);
    REQUIRE(code_section->name() == "CODE");
    REQUIRE(module.sections().size() == 2);
    REQUIRE(module.current_section() == code_section);
}

TEST_CASE("Module: add_section with existing name returns existing and makes it current",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    Section* code1 = module.add_section("CODE");
    Section* data = module.add_section("DATA");
    Section* code2 = module.add_section("CODE");

    REQUIRE(code2 == code1);  // Same section returned
    REQUIRE(code1 != data);
    REQUIRE(code2 != data);
    REQUIRE(module.sections().size() == 3);  // Empty + CODE + DATA
    REQUIRE(module.current_section() == code1);  // CODE is now current again
}

TEST_CASE("Module: section pointer stability across additions",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    // Get pointer to default section
    Section* default_section = module.current_section();

    // Add many sections
    Section* code = module.add_section("CODE");
    Section* data = module.add_section("DATA");
    Section* bss = module.add_section("BSS");
    Section* rodata = module.add_section("RODATA");

    // Original pointers should still be valid
    REQUIRE(default_section->name() == "");
    REQUIRE(code->name() == "CODE");
    REQUIRE(data->name() == "DATA");
    REQUIRE(bss->name() == "BSS");
    REQUIRE(rodata->name() == "RODATA");

    // All sections should be in the list
    REQUIRE(module.sections().size() == 5);
}

TEST_CASE("Module: section pointers remain stable when switching sections",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    Section* code = module.add_section("CODE");
    Section* data = module.add_section("DATA");

    // Switch back to CODE
    Section* code2 = module.add_section("CODE");
    REQUIRE(code2 == code);
    REQUIRE(module.current_section() == code);

    // Switch back to DATA
    Section* data2 = module.add_section("DATA");
    REQUIRE(data2 == data);
    REQUIRE(module.current_section() == data);
}

TEST_CASE("Module: can add opcodes to current section",
          "[model][module][section]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    module.add_section("CODE");
    Section* code = module.current_section();

    code->add_opcode(Opcode({ 0x00 }, loc));  // NOP
    code->add_opcode(Opcode({ 0x3E, 0x42 }, loc));  // LD A, 42

    REQUIRE(code->opcodes().size() == 3); // section starts with empty opcode
    REQUIRE(code->size() == 3);
}

TEST_CASE("Module: opcodes remain accessible after section switch",
          "[model][module][section]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    // Add opcodes to CODE section
    Section* code = module.add_section("CODE");
    code->add_opcode(Opcode({ 0x00 }, loc));
    code->add_opcode(Opcode({ 0x00 }, loc));

    // Switch to DATA section
    Section* data = module.add_section("DATA");
    data->add_opcode(Opcode({ 0x42 }, loc));

    // Switch back to CODE
    module.add_section("CODE");
    REQUIRE(module.current_section() == code);
    code->add_opcode(Opcode({ 0x3E, 0x00 }, loc));

    // Back to DATA
    module.add_section("DATA");
    data->add_opcode(Opcode({ 0xFF }, loc));

    // All pointers should still be valid
    REQUIRE(code->opcodes().size() == 4);
    REQUIRE(data->opcodes().size() == 3);
}

TEST_CASE("Module: find_section returns correct section",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    module.add_section("CODE");
    module.add_section("DATA");

    REQUIRE(module.find_section("")->name() == "");
    REQUIRE(module.find_section("CODE")->name() == "CODE");
    REQUIRE(module.find_section("DATA")->name() == "DATA");
    REQUIRE(module.find_section("NONEXISTENT") == nullptr);
}

TEST_CASE("Module: clear_sections recreates default section",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    // Add several sections
    module.add_section("CODE");
    module.add_section("DATA");
    module.add_section("BSS");
    REQUIRE(module.sections().size() == 4);  // Empty + 3

    // Clear all sections
    module.clear_sections();

    // Should have recreated default empty section
    REQUIRE(module.sections().size() == 1);
    REQUIRE(module.sections()[0]->name() == "");
    REQUIRE(module.current_section() != nullptr);
    REQUIRE(module.current_section()->name() == "");
}

TEST_CASE("Module: section pointer stability with symbols",
          "[model][module][section]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    Section* code = module.add_section("CODE");
    code->set_base_address(0x8000);

    // Add symbol referencing section
    Symbol* label = module.add_symbol("start", loc, 0x8000,
                                      SymbolType::AddressRelative);
    label->set_opcode(code->last_opcode());
    label->set_offset(0);

    // Add more sections
    module.add_section("DATA");
    module.add_section("BSS");
    module.add_section("RODATA");

    // Symbol's section pointer should still be valid
    REQUIRE(label->opcode() == code->last_opcode());
}

TEST_CASE("Module: multiple symbols referencing different sections",
          "[model][module][section]") {
    Location loc("test.asm", 10);
    Module module("TEST", loc);

    Section* code = module.add_section("CODE");
    code->set_base_address(0x8000);

    Section* data = module.add_section("DATA");
    data->set_base_address(0x9000);

    // Add symbols to different sections
    Symbol* code_label = module.add_symbol("start", loc, 0x8000,
                                           SymbolType::AddressRelative);
    code_label->set_opcode(code->last_opcode());
    code_label->set_offset(0);

    Symbol* data_label = module.add_symbol("buffer", loc, 0x9000,
                                           SymbolType::AddressRelative);
    data_label->set_opcode(data->last_opcode());
    data_label->set_offset(0);

    // Verify both symbols retain correct section pointers
    REQUIRE(code_label->opcode() == code->last_opcode());
    REQUIRE(data_label->opcode() == data->last_opcode());
}

TEST_CASE("Module: current_section const accessor",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    const Section* sec = module.current_section();
    REQUIRE(sec != nullptr);
    REQUIRE(sec->name() == "");
}

TEST_CASE("Module: sections accessor provides access to unique_ptr elements",
          "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    module.add_section("CODE");
    module.add_section("DATA");

    // Access via const reference
    const auto& sections = module.sections();
    REQUIRE(sections.size() == 3);
    REQUIRE(sections[0]->name() == "");
    REQUIRE(sections[1]->name() == "CODE");
    REQUIRE(sections[2]->name() == "DATA");
}

TEST_CASE("Module: section iteration", "[model][module][section]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);

    module.add_section("CODE");
    module.add_section("DATA");
    module.add_section("BSS");

    std::vector<std::string> names;
    for (const auto& section : module.sections()) {
        names.push_back(section->name());
    }

    REQUIRE(names.size() == 4);
    REQUIRE(names[0] == "");
    REQUIRE(names[1] == "CODE");
    REQUIRE(names[2] == "DATA");
    REQUIRE(names[3] == "BSS");
}

//-----------------------------------------------------------------------------
// Integration tests: Module with sections, symbols, and opcodes
//-----------------------------------------------------------------------------

TEST_CASE("Integration: complete module with sections and symbols",
          "[model][integration]") {
    Location loc("program.asm", 1);
    Module module("MAIN", loc);

    // CODE section
    Section* code = module.add_section("CODE");
    code->set_base_address(0x8000);

    loc.set_line_num(10);
    Symbol* start = module.add_symbol("start", loc, 0x8000,
                                      SymbolType::AddressRelative);
    Opcode* start_opcode = code->last_opcode();
    start->set_opcode(start_opcode);
    start->set_offset(0);
    start->set_scope(SymbolScope::Public);

    loc.set_line_num(15);
    code->add_opcode(Opcode({ 0x3E, 0x42 }, loc));  // LD A, 42

    loc.set_line_num(20);
    Symbol* loop = module.add_symbol("loop", loc, 0x8002,
                                     SymbolType::AddressRelative);
    Opcode* loop_opcode = code->last_opcode();
    loop->set_opcode(loop_opcode);
    loop->set_offset(2);

    loc.set_line_num(25);
    code->add_opcode(Opcode({ 0x18, 0xFE }, loc));  // JR loop

    // DATA section
    Section* data = module.add_section("DATA");
    data->set_base_address(0x9000);

    loc.set_line_num(30);
    Symbol* buffer = module.add_symbol("buffer", loc, 0x9000,
                                       SymbolType::AddressRelative);
    Opcode* buffer_opcode = data->last_opcode();
    buffer->set_opcode(buffer_opcode);
    buffer->set_offset(0);

    loc.set_line_num(35);
    data->add_opcode(Opcode({ 0x00, 0x00, 0x00, 0x00 }, loc));  // DEFS 4

    // Verify structure
    REQUIRE(module.sections().size() == 3);  // Empty + CODE + DATA
    REQUIRE(module.symbols().size() == 3);   // start, loop, buffer

    REQUIRE(start->opcode() == start_opcode);
    REQUIRE(loop->opcode() == loop_opcode);
    REQUIRE(buffer->opcode() == buffer_opcode);

    REQUIRE(code->opcodes().size() == 3); // section starts with empty opcode
    REQUIRE(code->size() == 4);
    REQUIRE(data->opcodes().size() == 2); // section starts with empty opcode
    REQUIRE(data->size() == 4);
}

TEST_CASE("Integration: section switching workflow", "[model][integration]") {
    Location loc("multi.asm", 1);
    Module module("TEST", loc);

    // Start in CODE section
    loc.set_line_num(10);
    Section* code = module.add_section("CODE");
    code->add_opcode(Opcode({ 0x00 }, loc));

    // Switch to DATA section
    loc.set_line_num(20);
    Section* data = module.add_section("DATA");
    data->add_opcode(Opcode({ 0x42 }, loc));

    // Back to CODE
    loc.set_line_num(30);
    module.add_section("CODE");
    REQUIRE(module.current_section() == code);
    code->add_opcode(Opcode({ 0x00 }, loc));

    // Back to DATA
    loc.set_line_num(40);
    module.add_section("DATA");
    REQUIRE(module.current_section() == data);
    data->add_opcode(Opcode({ 0xFF }, loc));

    // Verify final state
    REQUIRE(code->opcodes().size() == 3); // section starts with empty opcode
    REQUIRE(data->opcodes().size() == 3); // section starts with empty opcode
}

TEST_CASE("Integration: default section behavior", "[model][integration]") {
    Location loc("default.asm", 1);
    Module module("TEST", loc);

    // Add opcodes to default section without explicit section directive
    Section* default_sec = module.current_section();
    REQUIRE(default_sec->name() == "");

    loc.set_line_num(10);
    default_sec->add_opcode(Opcode({ 0x00 }, loc));
    loc.set_line_num(20);
    default_sec->add_opcode(Opcode({ 0x3E, 0x42 }, loc));

    // Add named section
    Section* code = module.add_section("CODE");
    loc.set_line_num(30);
    code->add_opcode(Opcode({ 0xC3, 0x00, 0x80 }, loc));

    // Verify both sections exist and have correct opcodes
    REQUIRE(module.sections().size() == 2);
    REQUIRE(default_sec->opcodes().size() == 3); // section starts with empty opcode
    REQUIRE(code->opcodes().size() == 2);
}

TEST_CASE("Integration: section with alignment and symbols",
          "[model][integration]") {
    Location loc("aligned.asm", 10);
    Module module("TEST", loc);

    // Create page-aligned section
    Section* page = module.add_section("PAGE_DATA");
    page->set_alignment(256);
    page->set_base_address(0x7F80);  // Will align to 0x8000

    REQUIRE(page->base_address() == 0x8000);

    // Add symbol at start of page
    Symbol* page_start = module.add_symbol("page_start", loc, 0x8000,
                                           SymbolType::AddressRelative);
    Opcode* page_start_opcode = page->last_opcode();
    page_start->set_opcode(page_start_opcode);
    page_start->set_offset(0);

    // Add data
    for (int i = 0; i < 256; ++i) {
        page->add_opcode(Opcode({ static_cast<uint8_t>(i) }, loc));
    }

    REQUIRE(page->size() == 256);
    REQUIRE(page->pc() == 0x8100);
    REQUIRE(page_start->opcode() == page_start_opcode);
}

//-----------------------------------------------------------------------------
// Integration test: Complete label workflow with new constructor
//-----------------------------------------------------------------------------

TEST_CASE("Integration: label creation workflow with new constructor",
          "[model][integration]") {
    Location loc("program.asm", 1);
    Module module("MAIN", loc);

    Section* section = module.add_section("CODE");
    section->set_base_address(0x8000);

    // Simulate assembly workflow
    loc.set_line_num(10);
    section->add_opcode(Opcode({ 0x00 }, loc));  // NOP

    // Label at current position
    loc.set_line_num(11);
    Opcode* start_opcode = section->add_opcode(Opcode({ 0x3E, 0x00 },
                           loc));  // LD A, 0

    // Create label using new constructor
    Symbol start_label("start", loc, start_opcode, 1);

    // Manually add to module's symbol table (in real code, Module would do this)
    // For this test, just verify the Symbol object is correct
    REQUIRE(start_label.name() == "start");
    REQUIRE(start_label.is_address_relative());
    REQUIRE(start_label.is_defined());
    REQUIRE(start_label.opcode() == start_opcode);
    REQUIRE(start_label.offset() == 1);
    REQUIRE(start_label.scope() == SymbolScope::Local);

    // Add more code
    loc.set_line_num(12);
    section->add_opcode(Opcode({ 0x3C }, loc));  // INC A

    loc.set_line_num(13);
    Opcode* loop_opcode = section->add_opcode(Opcode({ 0x00 },
                          loc));  // NOP (placeholder)
    Symbol loop_label("loop", loc, loop_opcode, 3);

    loc.set_line_num(14);
    section->add_opcode(Opcode({ 0x18, 0xFE }, loc));  // JR loop

    // Verify both labels
    REQUIRE(start_label.opcode() == start_opcode);
    REQUIRE(loop_label.opcode() == loop_opcode);
    REQUIRE(section->opcodes().size() == 6); // section starts with empty opcode
}

TEST_CASE("Integration: public label with new constructor",
          "[model][integration]") {
    Location loc("module.asm", 10);
    Module module("MYLIB", loc);

    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Add entry point
    Opcode* entry_opcode = section->add_opcode(Opcode({ 0xC3, 0x00, 0x00 }, loc));

    // Create public label
    Symbol api_func("api_func", loc, entry_opcode, 0);

    // Would normally be added via module.add_symbol() and then declared public
    REQUIRE(api_func.name() == "api_func");
    REQUIRE(api_func.is_address_relative());
    REQUIRE(api_func.opcode() == entry_opcode);

    // Simulate PUBLIC declaration
    api_func.set_scope(SymbolScope::Public);
    REQUIRE(api_func.is_public());
    REQUIRE(api_func.is_exported());
}

//-----------------------------------------------------------------------------
// Integration tests: Expression with label symbols
//-----------------------------------------------------------------------------

TEST_CASE("Integration: label reference in expression",
          "[model][integration][expr]") {
    Location loc("program.asm", 1);
    Module module("MAIN", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Add code
    loc.set_line_num(10);
    section->add_opcode(Opcode({ 0x00 }, loc));  // 0x8000: NOP

    loc.set_line_num(11);
    Opcode* loop_opcode = section->add_opcode(Opcode({ 0x3E, 0x00 },
                          loc));  // 0x8001: LD A, 0
    Symbol* loop = module.add_symbol("loop", loc);
    loop->set_type(SymbolType::AddressRelative);
    loop->set_opcode(loop_opcode);
    loop->set_offset(0);

    loc.set_line_num(12);
    section->add_opcode(Opcode({ 0x3C }, loc));  // 0x8003: INC A

    loc.set_line_num(13);
    section->add_opcode(Opcode({ 0x18, 0x00 },
                               loc));  // 0x8004: JR loop (offset to be calculated)

    // Calculate JR offset: loop - ($ + 2)
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "loop", true));
    line.tokens().push_back(Token(TokenType::Minus, "-", true));
    line.tokens().push_back(Token(TokenType::LeftParen, "(", true));
    line.tokens().push_back(Token(TokenType::Dollar, "$", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, true));
    line.tokens().push_back(Token(TokenType::RightParen, ")", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    section->compute_opcodes_addresses();
    REQUIRE(expr.evaluate() == -5);  // 0x8001 - 0x8006 = -5 (correct JR offset)
}

TEST_CASE("Integration: forward reference in expression",
          "[model][integration][expr]") {
    Location loc("program.asm", 10);
    Module module("MAIN", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Parse expression with forward reference (symbol defined later)
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "end_label", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    // Symbol should be created but undefined
    Symbol* sym = module.find_symbol("end_label");
    REQUIRE(sym != nullptr);
    REQUIRE(sym->is_undefined());

    // Evaluation should fail at this point
    REQUIRE_THROWS_AS(expr.evaluate(), UndefinedSymbol);

    // Now define the symbol
    sym->set_value(0x8100);
    sym->set_type(SymbolType::Constant);

    // Evaluation should now succeed
    REQUIRE(expr.evaluate() == 0x8100);
}

TEST_CASE("Integration: expression in patch", "[model][integration][expr]") {
    Location loc("program.asm", 10);
    Module module("MAIN", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Create target label
    Opcode* target_opcode = section->add_opcode(Opcode({ 0x00 }, loc));
    Symbol* target = module.add_symbol("target", loc);
    target->set_type(SymbolType::AddressRelative);
    target->set_opcode(target_opcode);
    target->set_offset(0);

    // Add JP instruction with patch
    Opcode* jp_opcode = section->add_opcode(Opcode({ 0xC3, 0x00, 0x00 }, loc));

    // Create expression for patch: target
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "target", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    // Add patch to opcode
    Patch patch(1, PatchRange::Word, expr);
    jp_opcode->add_patch(patch);

    // Verify patch
    REQUIRE(jp_opcode->has_patches());
    REQUIRE(jp_opcode->patches().size() == 1);

    // Evaluate patch expression
    section->compute_opcodes_addresses();
    REQUIRE(jp_opcode->patches()[0].expression().evaluate() == 0x8000);
}

TEST_CASE("Integration: $ in different sections",
          "[model][integration][expr]") {
    Location loc("multi.asm", 10);
    Module module("TEST", loc);

    // CODE section
    Section* code = module.add_section("CODE");
    code->set_base_address(0x8000);
    code->add_opcode(Opcode({ 0x00 }, loc));
    code->add_opcode(Opcode({ 0x00 }, loc));

    // Parse $ in CODE section
    TokenLine line1(loc);
    line1.tokens().push_back(Token(TokenType::Dollar, "$", false));

    Expression expr1;
    size_t i1 = 0;
    REQUIRE(expr1.parse(line1, i1, &module, code));

    REQUIRE(expr1.evaluate() == 0x8001);  // Last opcode in CODE

    // DATA section
    Section* data = module.add_section("DATA");
    data->set_base_address(0x9000);
    data->add_opcode(Opcode({ 0x42 }, loc));

    // Parse $ in DATA section
    TokenLine line2(loc);
    line2.tokens().push_back(Token(TokenType::Dollar, "$", false));

    Expression expr2;
    size_t i2 = 0;
    REQUIRE(expr2.parse(line2, i2, &module, data));

    REQUIRE(expr2.evaluate() == 0x9000);  // Last opcode in DATA
}

TEST_CASE("Integration: expression with PUBLIC symbol",
          "[model][integration][expr]") {
    Location loc("lib.asm", 10);
    Module module("LIB", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Create and export symbol
    Opcode* api_opcode = section->add_opcode(Opcode({ 0xC9 }, loc));  // RET
    Symbol* api_func = module.add_symbol("api_init", loc);
    api_func->set_type(SymbolType::AddressRelative);
    api_func->set_opcode(api_opcode);
    api_func->set_offset(0);
    module.declare_symbol("api_init", loc, SymbolScope::Public);

    // Use in expression
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "api_init", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    section->compute_opcodes_addresses();
    REQUIRE(expr.evaluate() == 0x8000);
    REQUIRE(api_func->is_public());
}

TEST_CASE("Integration: complex offset calculation",
          "[model][integration][expr]") {
    Location loc("calc.asm", 10);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Create structure offsets
    module.add_symbol("struct_size", loc, 16, SymbolType::Constant);
    module.add_symbol("index", loc, 3, SymbolType::Constant);
    module.add_symbol("base_addr", loc, 0x9000, SymbolType::Constant);

    section->add_opcode(Opcode({ 0x00 }, loc));

    // Calculate: base_addr + (index * struct_size) + 4
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "base_addr", true));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::LeftParen, "(", true));
    line.tokens().push_back(Token(TokenType::Identifier, "index", false));
    line.tokens().push_back(Token(TokenType::Multiply, "*", true));
    line.tokens().push_back(Token(TokenType::Identifier, "struct_size", true));
    line.tokens().push_back(Token(TokenType::RightParen, ")", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", true));
    line.tokens().push_back(Token(TokenType::Integer, "4", 4, true));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));

    REQUIRE(expr.evaluate() == 0x9034);  // 0x9000 + (3 * 16) + 4
}

