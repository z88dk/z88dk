//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../unit.h"
#include "catch_amalgamated.hpp"

//-----------------------------------------------------------------------------
// CompilationUnit tests
//-----------------------------------------------------------------------------

TEST_CASE("CompilationUnit: constructor creates default empty module",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    REQUIRE(unit.name() == "test");
    REQUIRE(unit.location().filename() == "test.asm");
    REQUIRE(unit.location().line_num() == 1);
    REQUIRE(unit.modules().size() == 1);
    REQUIRE(unit.modules()[0]->name() == "");
    REQUIRE(unit.current_module() != nullptr);
    REQUIRE(unit.current_module()->name() == "");
}

TEST_CASE("CompilationUnit: default module is current after construction",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    const Module* default_module = unit.modules()[0].get();
    REQUIRE(unit.current_module() == default_module);
}

TEST_CASE("CompilationUnit: add_module creates new module and makes it current",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    Module* main_module = unit.add_module("MAIN");

    REQUIRE(main_module != nullptr);
    REQUIRE(main_module->name() == "MAIN");
    REQUIRE(unit.modules().size() == 2);
    REQUIRE(unit.current_module() == main_module);
}

TEST_CASE("CompilationUnit: add_module with existing name returns existing",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    Module* main1 = unit.add_module("MAIN");
    Module* lib = unit.add_module("LIB");
    Module* main2 = unit.add_module("MAIN");

    REQUIRE(main2 == main1);  // Same module returned
    REQUIRE(main1 != lib);
    REQUIRE(main2 != lib);
    REQUIRE(unit.modules().size() == 3);  // Empty + MAIN + LIB
    REQUIRE(unit.current_module() == main1);  // MAIN is now current again
}

TEST_CASE("CompilationUnit: module pointer stability across additions",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    // Get pointer to default module
    Module* default_module = unit.current_module();

    // Add many modules
    Module* main = unit.add_module("MAIN");
    Module* lib1 = unit.add_module("LIB1");
    Module* lib2 = unit.add_module("LIB2");
    Module* lib3 = unit.add_module("LIB3");

    // Original pointers should still be valid
    REQUIRE(default_module->name() == "");
    REQUIRE(main->name() == "MAIN");
    REQUIRE(lib1->name() == "LIB1");
    REQUIRE(lib2->name() == "LIB2");
    REQUIRE(lib3->name() == "LIB3");

    // All modules should be in the list
    REQUIRE(unit.modules().size() == 5);
}

TEST_CASE("CompilationUnit: module pointers remain stable when switching modules",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    Module* main = unit.add_module("MAIN");
    Module* lib = unit.add_module("LIB");

    // Switch back to MAIN
    Module* main2 = unit.add_module("MAIN");
    REQUIRE(main2 == main);
    REQUIRE(unit.current_module() == main);

    // Switch back to LIB
    Module* lib2 = unit.add_module("LIB");
    REQUIRE(lib2 == lib);
    REQUIRE(unit.current_module() == lib);
}

TEST_CASE("CompilationUnit: find_module returns correct module",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    unit.add_module("MAIN");
    unit.add_module("LIB");

    REQUIRE(unit.find_module("")->name() == "");
    REQUIRE(unit.find_module("MAIN")->name() == "MAIN");
    REQUIRE(unit.find_module("LIB")->name() == "LIB");
    REQUIRE(unit.find_module("NONEXISTENT") == nullptr);
}

TEST_CASE("CompilationUnit: clear_modules recreates default module",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    // Add several modules
    unit.add_module("MAIN");
    unit.add_module("LIB1");
    unit.add_module("LIB2");
    REQUIRE(unit.modules().size() == 4);  // Empty + 3

    // Clear all modules
    unit.clear_modules();

    // Should have recreated default empty module
    REQUIRE(unit.modules().size() == 1);
    REQUIRE(unit.modules()[0]->name() == "");
    REQUIRE(unit.current_module() != nullptr);
    REQUIRE(unit.current_module()->name() == "");
}

TEST_CASE("CompilationUnit: current_module const accessor",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    const Module* mod = unit.current_module();
    REQUIRE(mod != nullptr);
    REQUIRE(mod->name() == "");
}

TEST_CASE("CompilationUnit: module iteration", "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    unit.add_module("MAIN");
    unit.add_module("LIB1");
    unit.add_module("LIB2");

    std::vector<std::string> names;
    for (const auto& module : unit.modules()) {
        names.push_back(module->name());
    }

    REQUIRE(names.size() == 4);
    REQUIRE(names[0] == "");
    REQUIRE(names[1] == "MAIN");
    REQUIRE(names[2] == "LIB1");
    REQUIRE(names[3] == "LIB2");
}

//-----------------------------------------------------------------------------
// Integration tests: CompilationUnit with modules and symbols
//-----------------------------------------------------------------------------

TEST_CASE("Integration: compilation unit with multiple modules",
          "[model][integration]") {
    Location loc("program.asm", 1);
    CompilationUnit unit("program", loc);

    // MAIN module with public symbol
    Module* main = unit.add_module("MAIN");
    loc.set_line_num(10);
    Symbol* start = main->add_symbol("start", loc, 0x8000, SymbolType::Constant);
    start->set_scope(SymbolScope::Public);

    // LIB module with exported function
    Module* lib = unit.add_module("LIB");
    loc.set_line_num(20);
    Symbol* func = lib->add_symbol("lib_init", loc, 0x9000, SymbolType::Constant);
    func->set_scope(SymbolScope::Public);

    // Verify structure
    REQUIRE(unit.modules().size() == 3);  // Empty + MAIN + LIB

    REQUIRE(main->symbols().size() == 1);
    REQUIRE(lib->symbols().size() == 1);

    REQUIRE(start->is_public());
    REQUIRE(func->is_public());
}

TEST_CASE("Integration: module switching workflow", "[model][integration]") {
    Location loc("multi.asm", 1);
    CompilationUnit unit("multi", loc);

    // Start in MAIN module
    loc.set_line_num(10);
    Module* main = unit.add_module("MAIN");
    main->add_symbol("var1", loc, 10, SymbolType::Constant);

    // Switch to LIB module
    loc.set_line_num(20);
    Module* lib = unit.add_module("LIB");
    lib->add_symbol("var2", loc, 20, SymbolType::Constant);

    // Back to MAIN
    loc.set_line_num(30);
    unit.add_module("MAIN");
    REQUIRE(unit.current_module() == main);
    main->add_symbol("var3", loc, 30, SymbolType::Constant);

    // Back to LIB
    loc.set_line_num(40);
    unit.add_module("LIB");
    REQUIRE(unit.current_module() == lib);
    lib->add_symbol("var4", loc, 40, SymbolType::Constant);

    // Verify final state
    REQUIRE(main->symbols().size() == 2);  // var1, var3
    REQUIRE(lib->symbols().size() == 2);   // var2, var4
}

TEST_CASE("Integration: default module behavior", "[model][integration]") {
    Location loc("default.asm", 1);
    CompilationUnit unit("default", loc);

    // Add symbols to default module without explicit module directive
    Module* default_mod = unit.current_module();
    REQUIRE(default_mod->name() == "");

    loc.set_line_num(10);
    default_mod->add_symbol("label1", loc, 0x8000, SymbolType::Constant);

    loc.set_line_num(20);
    default_mod->add_symbol("label2", loc, 0x8010, SymbolType::Constant);

    // Add named module
    Module* main = unit.add_module("MAIN");
    loc.set_line_num(30);
    main->add_symbol("label3", loc, 0x9000, SymbolType::Constant);

    // Verify both modules exist and have correct symbols
    REQUIRE(unit.modules().size() == 2);
    REQUIRE(default_mod->symbols().size() == 2);
    REQUIRE(main->symbols().size() == 1);
}

TEST_CASE("Integration: compilation unit with sections and modules",
          "[model][integration]") {
    Location loc("complete.asm", 1);
    CompilationUnit unit("complete", loc);

    // MAIN module with CODE section
    Module* main = unit.add_module("MAIN");
    Section* code = main->add_section("CODE");
    code->set_base_address(0x8000);

    loc.set_line_num(10);
    Symbol* start = main->add_symbol("start", loc, 0x8000,
                                     SymbolType::AddressRelative);
    Opcode* start_opcode = code->last_opcode();
    start->set_opcode(start_opcode);
    start->set_scope(SymbolScope::Public);

    code->add_opcode(Opcode(code, { 0x00 }, loc));

    // LIB module with DATA section
    Module* lib = unit.add_module("LIB");
    Section* data = lib->add_section("DATA");
    data->set_base_address(0x9000);

    loc.set_line_num(20);
    Symbol* buffer = lib->add_symbol("buffer", loc, 0x9000,
                                     SymbolType::AddressRelative);
    Opcode* buffer_opcode = data->last_opcode();
    buffer->set_opcode(buffer_opcode);
    buffer->set_scope(SymbolScope::Public);

    data->add_opcode(Opcode(data, { 0x42 }, loc));

    // Verify structure
    REQUIRE(unit.modules().size() == 3);  // Empty + MAIN + LIB
    REQUIRE(main->sections().size() == 2);  // Default + CODE
    REQUIRE(lib->sections().size() == 2);   // Default + DATA

    REQUIRE(start->opcode() == start_opcode);
    REQUIRE(buffer->opcode() == buffer_opcode);
}

TEST_CASE("CompilationUnit: modules accessor provides const reference",
          "[model][compilation_unit]") {
    Location loc("test.asm", 1);
    CompilationUnit unit("test", loc);

    unit.add_module("MAIN");

    // Access via const reference - accessor returns const
    const auto& modules = unit.modules();
    REQUIRE(modules.size() == 2);
    REQUIRE(modules[0]->name() == "");
    REQUIRE(modules[1]->name() == "MAIN");
}

TEST_CASE("Integration: parse and check constant expression",
          "[model][integration][constant]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();

    // Define constants
    module.add_symbol("MAX", loc, 255, SymbolType::Constant);
    module.add_symbol("MIN", loc, 0, SymbolType::Constant);

    // Parse: MAX + MIN * 2
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "MAX", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", false));
    line.tokens().push_back(Token(TokenType::Identifier, "MIN", false));
    line.tokens().push_back(Token(TokenType::Multiply, "*", false));
    line.tokens().push_back(Token(TokenType::Integer, "2", 2, false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE(expr.is_constant());

    int result = expr.evaluate();
    REQUIRE(result == 255);
}

TEST_CASE("Integration: parse and check non-constant expression",
          "[model][integration][constant]") {
    Location loc("test.asm", 1);
    Module module("TEST", loc);
    Section* section = module.current_section();
    section->set_base_address(0x8000);

    // Define constant and label
    module.add_symbol("OFFSET", loc, 10, SymbolType::Constant);

    Opcode* opcode = section->add_opcode(Opcode(section, { 0x00 }, loc));
    Symbol* label = module.add_symbol("start", loc);
    label->set_type(SymbolType::AddressRelative);
    label->set_opcode(opcode);

    // Parse: start + OFFSET (not constant because of label)
    TokenLine line(loc);
    line.tokens().push_back(Token(TokenType::Identifier, "start", false));
    line.tokens().push_back(Token(TokenType::Plus, "+", false));
    line.tokens().push_back(Token(TokenType::Identifier, "OFFSET", false));

    Expression expr;
    size_t i = 0;
    REQUIRE(expr.parse(line, i, &module, section));
    REQUIRE_FALSE(expr.is_constant());  // Contains label
}

