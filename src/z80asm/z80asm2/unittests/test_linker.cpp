//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../errors.h"
#include "../library.h"
#include "../linker.h"
#include "../location.h"
#include "../module.h"
#include "../section.h"
#include "../symbols.h"
#include "catch_amalgamated.hpp"

//-----------------------------------------------------------------------------
// Linker tests
//-----------------------------------------------------------------------------

TEST_CASE("Linker: constructor creates empty state", "[model][linker]") {
    Linker linker;

    REQUIRE(linker.module_count() == 0);
    REQUIRE(linker.public_symbol_count() == 0);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(linker.has_unresolved_symbols());
    REQUIRE(linker.modules().empty());
    REQUIRE(linker.public_symbols().empty());
    REQUIRE(linker.unresolved_externs().empty());
    REQUIRE(linker.libraries().empty());
}

TEST_CASE("Linker: add module with public symbols", "[model][linker]") {
    Linker linker;
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MAIN", loc);
    Symbol* sym = module->add_symbol("main", loc, 0x8000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);

    Module* module_ptr = linker.add_module(std::move(module));

    REQUIRE(module_ptr != nullptr);
    REQUIRE(linker.module_count() == 1);
    REQUIRE(linker.public_symbol_count() == 1);
    REQUIRE(linker.public_symbols().count("main") == 1);
    REQUIRE(linker.public_symbols().at("main") == module_ptr);
}

TEST_CASE("Linker: add module with extern symbols", "[model][linker]") {
    Linker linker;
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MAIN", loc);
    module->declare_symbol("printf", loc, SymbolScope::Extern);

    linker.add_module(std::move(module));

    REQUIRE(linker.module_count() == 1);
    REQUIRE(linker.unresolved_symbol_count() == 1);
    REQUIRE(linker.has_unresolved_symbols());
    REQUIRE(linker.unresolved_externs().count("printf") == 1);
}

TEST_CASE("Linker: extern resolved by later public", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Module 1: uses external symbol
    auto mod1 = std::make_unique<Module>("MAIN", loc);
    mod1->declare_symbol("helper", loc, SymbolScope::Extern);
    linker.add_module(std::move(mod1));

    REQUIRE(linker.unresolved_symbol_count() == 1);

    // Module 2: defines the symbol
    auto mod2 = std::make_unique<Module>("UTIL", loc);
    Symbol* sym = mod2->add_symbol("helper", loc, 0x9000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);
    linker.add_module(std::move(mod2));

    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(linker.has_unresolved_symbols());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Linker: public resolves existing extern", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Module 1: defines public symbol
    auto mod1 = std::make_unique<Module>("LIB", loc);
    Symbol* sym = mod1->add_symbol("api_func", loc, 0x8000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);
    linker.add_module(std::move(mod1));

    REQUIRE(linker.public_symbol_count() == 1);

    // Module 2: uses the symbol (should not be unresolved)
    auto mod2 = std::make_unique<Module>("MAIN", loc);
    mod2->declare_symbol("api_func", loc, SymbolScope::Extern);
    linker.add_module(std::move(mod2));

    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Linker: duplicate public symbols error", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc1("mod1.asm", 10);
    Location loc2("mod2.asm", 20);

    // Module 1: defines public symbol
    auto mod1 = std::make_unique<Module>("MOD1", loc1);
    Symbol* sym1 = mod1->add_symbol("duplicate", loc1, 0x8000,
                                    SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    linker.add_module(std::move(mod1));

    REQUIRE_FALSE(g_errors.has_errors());

    // Module 2: defines same public symbol (error)
    auto mod2 = std::make_unique<Module>("MOD2", loc2);
    Symbol* sym2 = mod2->add_symbol("duplicate", loc2, 0x9000,
                                    SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    linker.add_module(std::move(mod2));

    REQUIRE(g_errors.has_errors());
    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("Duplicate public symbol") != std::string::npos);
    REQUIRE(msg.find("duplicate") != std::string::npos);
}

TEST_CASE("Linker: add library", "[model][linker]") {
    Linker linker;
    Library lib("test.lib");

    linker.add_library(&lib);

    REQUIRE(linker.libraries().size() == 1);
    REQUIRE(linker.libraries()[0] == &lib);
}

TEST_CASE("Linker: link_libraries resolves symbols", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Create library with public symbol
    Library lib("stdio.lib");
    auto lib_module = std::make_unique<Module>("STDIO", loc);
    Symbol* lib_sym = lib_module->add_symbol("printf", loc, 0xC000,
                      SymbolType::Constant);
    lib_sym->set_scope(SymbolScope::Public);
    lib.add_module(std::move(lib_module));

    linker.add_library(&lib);

    // Add main module with extern reference
    auto main_module = std::make_unique<Module>("MAIN", loc);
    main_module->declare_symbol("printf", loc, SymbolScope::Extern);
    linker.add_module(std::move(main_module));

    REQUIRE(linker.unresolved_symbol_count() == 1);

    // Link libraries
    bool success = linker.link_libraries();

    REQUIRE(success);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Linker: link_libraries reports unresolved", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 10);

    // Add module with unresolved extern
    auto module = std::make_unique<Module>("MAIN", loc);
    module->declare_symbol("undefined", loc, SymbolScope::Extern);
    linker.add_module(std::move(module));

    REQUIRE(linker.unresolved_symbol_count() == 1);

    // Link libraries (no libraries added, so should fail)
    bool success = linker.link_libraries();

    REQUIRE_FALSE(success);
    REQUIRE(linker.unresolved_symbol_count() == 1);
    REQUIRE(g_errors.has_errors());

    std::string msg = g_errors.last_error_message();
    REQUIRE(msg.find("test.asm:10:") != std::string::npos);
    REQUIRE(msg.find("Unresolved external symbol") != std::string::npos);
    REQUIRE(msg.find("undefined") != std::string::npos);
}

TEST_CASE("Linker: library search order", "[model][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Library 1 with symbol
    Library lib1("lib1.lib");
    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* sym1 = mod1->add_symbol("common", loc, 0x8000, SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    lib1.add_module(std::move(mod1));

    // Library 2 with same symbol
    Library lib2("lib2.lib");
    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Symbol* sym2 = mod2->add_symbol("common", loc, 0x9000, SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    lib2.add_module(std::move(mod2));

    // Add libraries in order
    linker.add_library(&lib1);
    linker.add_library(&lib2);

    // Add module with extern
    auto main_module = std::make_unique<Module>("MAIN", loc);
    main_module->declare_symbol("common", loc, SymbolScope::Extern);
    linker.add_module(std::move(main_module));

    // Link - should resolve from first library
    bool success = linker.link_libraries();

    REQUIRE(success);
    REQUIRE_FALSE(g_errors.has_errors());
    // In full implementation, would verify MOD1 was pulled in, not MOD2
}

TEST_CASE("Linker: clear state", "[model][linker]") {
    Linker linker;
    Location loc("test.asm", 1);
    Library lib("test.lib");

    // Add some state
    auto module = std::make_unique<Module>("MAIN", loc);
    Symbol* sym = module->add_symbol("func", loc, 0x8000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);
    linker.add_module(std::move(module));
    linker.add_library(&lib);

    REQUIRE(linker.module_count() > 0);
    REQUIRE(linker.public_symbol_count() > 0);

    // Clear
    linker.clear();

    REQUIRE(linker.module_count() == 0);
    REQUIRE(linker.public_symbol_count() == 0);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE(linker.modules().empty());
    REQUIRE(linker.public_symbols().empty());
    REQUIRE(linker.unresolved_externs().empty());
    REQUIRE(linker.libraries().empty());
}

TEST_CASE("Linker: multiple unresolved locations tracked", "[model][linker]") {
    Linker linker;
    Location loc1("main.asm", 10);
    Location loc2("main.asm", 20);
    Location loc3("util.asm", 15);

    // Module with multiple references to same extern
    auto mod1 = std::make_unique<Module>("MAIN", loc1);
    mod1->declare_symbol("helper", loc1, SymbolScope::Extern);
    mod1->declare_symbol("helper", loc2, SymbolScope::Extern);
    linker.add_module(std::move(mod1));

    auto mod2 = std::make_unique<Module>("UTIL", loc3);
    mod2->declare_symbol("helper", loc3, SymbolScope::Extern);
    linker.add_module(std::move(mod2));

    // Should track all locations
    REQUIRE(linker.unresolved_symbol_count() == 1);
    const auto& externs = linker.unresolved_externs();
    REQUIRE(externs.at("helper").size() == 3);
}

//-----------------------------------------------------------------------------
// Integration tests: Complete linking workflow
//-----------------------------------------------------------------------------

TEST_CASE("Integration: simple program linking",
          "[model][integration][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Main module with entry point
    auto main_mod = std::make_unique<Module>("MAIN", loc);
    Section* main_code = main_mod->add_section("CODE");
    main_code->set_base_address(0x8000);

    Symbol* start = main_mod->add_symbol("_start", loc, 0x8000,
                                         SymbolType::Constant);
    start->set_scope(SymbolScope::Public);

    /*Symbol* helper_ref =*/ main_mod->declare_symbol("helper", loc,
            SymbolScope::Extern);

    linker.add_module(std::move(main_mod));

    // Utility module with helper function
    auto util_mod = std::make_unique<Module>("UTIL", loc);
    Symbol* helper = util_mod->add_symbol("helper", loc, 0x9000,
                                          SymbolType::Constant);
    helper->set_scope(SymbolScope::Public);

    linker.add_module(std::move(util_mod));

    // Should be fully resolved
    REQUIRE(linker.module_count() == 2);
    REQUIRE(linker.public_symbol_count() == 2);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(linker.has_unresolved_symbols());
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: linking with library", "[model][integration][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("main.asm", 1);

    // Create standard library
    Library stdlib("stdlib.lib");

    auto print_mod = std::make_unique<Module>("PRINT", loc);
    Symbol* print = print_mod->add_symbol("print", loc, 0xC000,
                                          SymbolType::Constant);
    print->set_scope(SymbolScope::Public);
    stdlib.add_module(std::move(print_mod));

    auto math_mod = std::make_unique<Module>("MATH", loc);
    Symbol* multiply = math_mod->add_symbol("multiply", loc, 0xC100,
                                            SymbolType::Constant);
    multiply->set_scope(SymbolScope::Public);
    stdlib.add_module(std::move(math_mod));

    linker.add_library(&stdlib);

    // Main program using library functions
    auto main = std::make_unique<Module>("MAIN", loc);
    Symbol* start = main->add_symbol("_start", loc, 0x8000, SymbolType::Constant);
    start->set_scope(SymbolScope::Public);

    main->declare_symbol("print", loc, SymbolScope::Extern);
    main->declare_symbol("multiply", loc, SymbolScope::Extern);

    linker.add_module(std::move(main));

    REQUIRE(linker.unresolved_symbol_count() == 2);

    // Link
    bool success = linker.link_libraries();

    REQUIRE(success);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: complex linking scenario",
          "[model][integration][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 1);

    // Library 1: stdio
    Library stdio("stdio.lib");
    auto printf_mod = std::make_unique<Module>("PRINTF", loc);
    Symbol* printf_sym = printf_mod->add_symbol("printf", loc, 0xC000,
                         SymbolType::Constant);
    printf_sym->set_scope(SymbolScope::Public);
    stdio.add_module(std::move(printf_mod));

    // Library 2: math
    Library math("math.lib");
    auto sqrt_mod = std::make_unique<Module>("SQRT", loc);
    Symbol* sqrt_sym = sqrt_mod->add_symbol("sqrt", loc, 0xD000,
                                            SymbolType::Constant);
    sqrt_sym->set_scope(SymbolScope::Public);
    math.add_module(std::move(sqrt_mod));

    linker.add_library(&stdio);
    linker.add_library(&math);

    // Module 1: main
    auto main = std::make_unique<Module>("MAIN", loc);
    Symbol* start = main->add_symbol("_start", loc, 0x8000, SymbolType::Constant);
    start->set_scope(SymbolScope::Public);
    main->declare_symbol("printf", loc, SymbolScope::Extern);
    main->declare_symbol("calc", loc, SymbolScope::Extern);
    linker.add_module(std::move(main));

    // Module 2: utility (provides calc, uses sqrt)
    auto util = std::make_unique<Module>("UTIL", loc);
    Symbol* calc = util->add_symbol("calc", loc, 0x9000, SymbolType::Constant);
    calc->set_scope(SymbolScope::Public);
    util->declare_symbol("sqrt", loc, SymbolScope::Extern);
    linker.add_module(std::move(util));

    // At this point: printf and sqrt are unresolved
    REQUIRE(linker.unresolved_symbol_count() == 2);

    // Link
    bool success = linker.link_libraries();

    REQUIRE(success);
    REQUIRE(linker.unresolved_symbol_count() == 0);
    REQUIRE(linker.public_symbol_count() ==
            4);  // _start, calc, printf, sqrt (conceptually)
    REQUIRE_FALSE(g_errors.has_errors());
}

TEST_CASE("Integration: partial linking failure",
          "[model][integration][linker]") {
    SuppressErrors suppress;
    Linker linker;
    Location loc("test.asm", 10);

    // Library with one function
    Library lib("partial.lib");
    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* func1 = mod1->add_symbol("func1", loc, 0xC000, SymbolType::Constant);
    func1->set_scope(SymbolScope::Public);
    lib.add_module(std::move(mod1));

    linker.add_library(&lib);

    // Main module with two extern references
    auto main = std::make_unique<Module>("MAIN", loc);
    main->declare_symbol("func1", loc, SymbolScope::Extern);
    main->declare_symbol("func2", loc, SymbolScope::Extern);  // Not in library
    linker.add_module(std::move(main));

    REQUIRE(linker.unresolved_symbol_count() == 2);

    // Link - should partially resolve
    bool success = linker.link_libraries();

    REQUIRE_FALSE(success);
    REQUIRE(linker.unresolved_symbol_count() == 1);
    REQUIRE(linker.unresolved_externs().count("func2") == 1);
    REQUIRE(g_errors.has_errors());
}

