//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#define CATCH_CONFIG_MAIN
#include "../library.h"
#include "../unit.h"
#include "catch_amalgamated.hpp"

//-----------------------------------------------------------------------------
// Library tests
//-----------------------------------------------------------------------------

TEST_CASE("Library: constructor with filename", "[model][library]") {
    Library lib("mylib.lib");

    REQUIRE(lib.filename() == "mylib.lib");
    REQUIRE(lib.modules().size() == 0);
    REQUIRE(lib.public_symbols().size() == 0);
    REQUIRE(lib.module_count() == 0);
    REQUIRE(lib.public_symbol_count() == 0);
}

TEST_CASE("Library: add module", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);
    Module* mod_ptr = module.get();

    Module* result = lib.add_module(std::move(module));

    REQUIRE(result == mod_ptr);
    REQUIRE(lib.modules().size() == 1);
    REQUIRE(lib.module_count() == 1);
    REQUIRE(lib.modules()[0].get() == mod_ptr);
}

TEST_CASE("Library: add module with public symbols", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);

    // Add public symbol
    Symbol* sym = module->add_symbol("exported_func", loc, 0x8000,
                                     SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);

    lib.add_module(std::move(module));

    REQUIRE(lib.public_symbol_count() == 1);
    REQUIRE(lib.has_public_symbol("exported_func"));

    Module* found = lib.find_public_symbol("exported_func");
    REQUIRE(found != nullptr);
    REQUIRE(found->name() == "MOD1");
}

TEST_CASE("Library: add module with local symbols", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);

    // Add local symbol (should not be indexed)
    module->add_symbol("local_var", loc, 42, SymbolType::Constant);

    lib.add_module(std::move(module));

    REQUIRE(lib.public_symbol_count() == 0);
    REQUIRE_FALSE(lib.has_public_symbol("local_var"));
    REQUIRE(lib.find_public_symbol("local_var") == nullptr);
}

TEST_CASE("Library: multiple modules with public symbols", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    // Module 1 with public symbol
    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* sym1 = mod1->add_symbol("func1", loc, 0x8000, SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    Module* mod1_ptr = lib.add_module(std::move(mod1));

    // Module 2 with different public symbol
    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Symbol* sym2 = mod2->add_symbol("func2", loc, 0x9000, SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    Module* mod2_ptr = lib.add_module(std::move(mod2));

    REQUIRE(lib.module_count() == 2);
    REQUIRE(lib.public_symbol_count() == 2);

    REQUIRE(lib.find_public_symbol("func1") == mod1_ptr);
    REQUIRE(lib.find_public_symbol("func2") == mod2_ptr);
}

TEST_CASE("Library: duplicate public symbol keeps first", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    // Module 1 with public symbol
    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* sym1 = mod1->add_symbol("duplicate", loc, 0x8000, SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    Module* mod1_ptr = lib.add_module(std::move(mod1));

    // Module 2 with same public symbol
    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Symbol* sym2 = mod2->add_symbol("duplicate", loc, 0x9000, SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    lib.add_module(std::move(mod2));

    REQUIRE(lib.public_symbol_count() == 1);
    REQUIRE(lib.find_public_symbol("duplicate") == mod1_ptr);  // First wins
}

TEST_CASE("Library: find module by name", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Module* mod1_ptr = lib.add_module(std::move(mod1));

    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Module* mod2_ptr = lib.add_module(std::move(mod2));

    REQUIRE(lib.find_module("MOD1") == mod1_ptr);
    REQUIRE(lib.find_module("MOD2") == mod2_ptr);
    REQUIRE(lib.find_module("NONEXISTENT") == nullptr);
}

TEST_CASE("Library: clear modules", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);
    Symbol* sym = module->add_symbol("func", loc, 0x8000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);
    lib.add_module(std::move(module));

    REQUIRE(lib.module_count() == 1);
    REQUIRE(lib.public_symbol_count() == 1);

    lib.clear_modules();

    REQUIRE(lib.module_count() == 0);
    REQUIRE(lib.public_symbol_count() == 0);
    REQUIRE(lib.modules().empty());
    REQUIRE(lib.public_symbols().empty());
}

TEST_CASE("Library: rebuild public symbol index", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);
    Symbol* sym = module->add_symbol("func", loc, 0x8000, SymbolType::Constant);
    Module* mod_ptr = lib.add_module(std::move(module));

    REQUIRE(lib.public_symbol_count() == 0);

    // Make symbol public after adding to library
    sym->set_scope(SymbolScope::Public);

    // Rebuild index
    lib.rebuild_public_symbol_index();

    REQUIRE(lib.public_symbol_count() == 1);
    REQUIRE(lib.find_public_symbol("func") == mod_ptr);
}

TEST_CASE("Library: const accessors", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto module = std::make_unique<Module>("MOD1", loc);
    Symbol* sym = module->add_symbol("func", loc, 0x8000, SymbolType::Constant);
    sym->set_scope(SymbolScope::Public);
    Module* mod_ptr = lib.add_module(std::move(module));

    const Library& const_lib = lib;

    REQUIRE(const_lib.filename() == "test.lib");
    REQUIRE(const_lib.module_count() == 1);
    REQUIRE(const_lib.public_symbol_count() == 1);
    REQUIRE(const_lib.has_public_symbol("func"));

    const Module* found = const_lib.find_public_symbol("func");
    REQUIRE(found == mod_ptr);
}

TEST_CASE("Library: iteration over modules", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    lib.add_module(std::make_unique<Module>("MOD1", loc));
    lib.add_module(std::make_unique<Module>("MOD2", loc));
    lib.add_module(std::make_unique<Module>("MOD3", loc));

    std::vector<std::string> names;
    for (const auto& module : lib.modules()) {
        names.push_back(module->name());
    }

    REQUIRE(names.size() == 3);
    REQUIRE(names[0] == "MOD1");
    REQUIRE(names[1] == "MOD2");
    REQUIRE(names[2] == "MOD3");
}

TEST_CASE("Library: public symbol index iteration", "[model][library]") {
    Library lib("test.lib");
    Location loc("test.asm", 1);

    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* sym1 = mod1->add_symbol("func1", loc, 0x8000, SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    lib.add_module(std::move(mod1));

    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Symbol* sym2 = mod2->add_symbol("func2", loc, 0x9000, SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    lib.add_module(std::move(mod2));

    std::set<std::string> symbol_names;
    for (const auto& [name, module] : lib.public_symbols()) {
        symbol_names.insert(name);
    }

    REQUIRE(symbol_names.size() == 2);
    REQUIRE(symbol_names.count("func1") == 1);
    REQUIRE(symbol_names.count("func2") == 1);
}

//-----------------------------------------------------------------------------
// Integration tests: Library with complete modules
//-----------------------------------------------------------------------------

TEST_CASE("Integration: library with code modules",
          "[model][integration][library]") {
    Library lib("math.lib");
    Location loc("math.asm", 1);

    // Create module with function
    auto module = std::make_unique<Module>("MATH", loc);

    // Add CODE section
    Section* code = module->add_section("CODE");
    code->set_base_address(0x8000);

    // Add public function
    loc.set_line_num(10);
    Opcode* func_opcode = code->add_opcode(Opcode(module->current_section(), { 0xC9 }, loc));  // RET
    Symbol* func = module->add_symbol("add", loc);
    func->set_type(SymbolType::AddressRelative);
    func->set_opcode(func_opcode);
    func->set_scope(SymbolScope::Public);

    lib.add_module(std::move(module));

    // Verify library structure
    REQUIRE(lib.module_count() == 1);
    REQUIRE(lib.public_symbol_count() == 1);
    REQUIRE(lib.has_public_symbol("add"));

    Module* found_module = lib.find_public_symbol("add");
    REQUIRE(found_module != nullptr);
    REQUIRE(found_module->name() == "MATH");

    const Symbol* found_symbol = found_module->find_symbol("add");
    REQUIRE(found_symbol != nullptr);
    REQUIRE(found_symbol->is_public());
}

TEST_CASE("Integration: library linking scenario",
          "[model][integration][library]") {
    // Simulate linking scenario:
    // Main program calls library function

    Library lib("stdio.lib");
    Location loc("stdio.asm", 1);

    // Library module with print function
    auto lib_module = std::make_unique<Module>("STDIO", loc);
    Section* lib_code = lib_module->add_section("CODE");
    lib_code->set_base_address(0xC000);

    loc.set_line_num(10);
    Opcode* print_opcode = lib_code->add_opcode(Opcode(lib_code, { 0xC9 }, loc));
    Symbol* print_func = lib_module->add_symbol("print", loc);
    print_func->set_type(SymbolType::AddressRelative);
    print_func->set_opcode(print_opcode);
    print_func->set_scope(SymbolScope::Public);

    lib.add_module(std::move(lib_module));

    // Main program that calls print
    CompilationUnit main_unit("main.asm", loc);
    Module* main_module = main_unit.current_module();
    Section* main_code = main_module->add_section("CODE");
    main_code->set_base_address(0x8000);

    // Declare external reference to print
    loc.set_line_num(20);
    Symbol* print_ref = main_module->declare_symbol("print", loc,
                        SymbolScope::Extern);
    REQUIRE(print_ref->is_extern());

    // Add CALL instruction with patch
    loc.set_line_num(21);
    Opcode* call_opcode = main_code->add_opcode(Opcode(main_code, { 0xCD, 0x00, 0x00 }, loc));
    Expression call_target(make_symbol(print_ref), loc);
    Patch call_patch(call_opcode, 1, PatchRange::Word, call_target);
    call_opcode->add_patch(call_patch);

    // Link step: resolve external reference
    REQUIRE(lib.has_public_symbol("print"));
    Module* defining_module = lib.find_public_symbol("print");
    REQUIRE(defining_module != nullptr);

    const Symbol* print_def = defining_module->find_symbol("print");
    REQUIRE(print_def != nullptr);
    REQUIRE(print_def->is_public());

    // In real linker, would copy print_def's value to print_ref
    // For this test, just verify structure is correct
    REQUIRE(call_opcode->has_patches());
    REQUIRE(call_opcode->patches()[0].range() == PatchRange::Word);
}

TEST_CASE("Integration: library search order",
          "[model][integration][library]") {
    // Multiple libraries with duplicate symbols - first library wins

    Location loc("test.asm", 1);

    Library lib1("lib1.lib");
    auto mod1 = std::make_unique<Module>("MOD1", loc);
    Symbol* sym1 = mod1->add_symbol("common_func", loc, 0x8000,
                                    SymbolType::Constant);
    sym1->set_scope(SymbolScope::Public);
    lib1.add_module(std::move(mod1));

    Library lib2("lib2.lib");
    auto mod2 = std::make_unique<Module>("MOD2", loc);
    Symbol* sym2 = mod2->add_symbol("common_func", loc, 0x9000,
                                    SymbolType::Constant);
    sym2->set_scope(SymbolScope::Public);
    lib2.add_module(std::move(mod2));

    // In linking, search order matters
    std::vector<Library*> search_path = { &lib1, &lib2 };

    Module* found = nullptr;
    for (Library* lib : search_path) {
        found = lib->find_public_symbol("common_func");
        if (found) {
            break;
        }
    }

    REQUIRE(found != nullptr);
    REQUIRE(found->name() == "MOD1");  // First library wins
}

