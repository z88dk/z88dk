//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "expr.h"
#include "location.h"
#include <cstdint>
#include <memory>
#include <set>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <vector>

//-----------------------------------------------------------------------------
// Forward declarations
//-----------------------------------------------------------------------------
class Expression;
class Expression;
class ExprNode;
class Library;
class Module;
class Opcode;
class Patch;
class Section;
class Symbol;
class TokenLine;

//-----------------------------------------------------------------------------
// Symbol types
//-----------------------------------------------------------------------------
enum class SymbolType {
    Undefined,          // Symbol not yet defined (e.g., EXTERN, resolved at link time)
    Constant,           // Constant value (EQU/DEFC)
    AddressRelative,    // Address in code plus offset (labels)
    Computed            // Expression computed at link time
};

//-----------------------------------------------------------------------------
// Symbol scope
//-----------------------------------------------------------------------------
enum class SymbolScope {
    Local,              // Local to module (default)
    Public,             // Exported from module (PUBLIC directive)
    Extern,             // Imported from another module (EXTERN directive)
    Global              // PUBLIC if defined, EXTERN if undefined (GLOBAL directive)
};

//-----------------------------------------------------------------------------
// Symbol - represents an assembly symbol
//-----------------------------------------------------------------------------
class Symbol {
public:
    // All constructors require name and location (name first as primary identifier)
    Symbol(const std::string& name, const Location& location);
    Symbol(const std::string& name, const Location& location, int value,
           SymbolType type = SymbolType::Constant);

    // Constructor for labels (address-relative symbols)
    Symbol(const std::string& name, const Location& location,
           Opcode* opcode, int offset,
           SymbolType type = SymbolType::AddressRelative);

    // Symbol identification (name is immutable - it's the key in symbol table)
    const std::string& name() const;

    // Symbol value
    int value() const;
    void set_value(int value);

    // Symbol type
    SymbolType type() const;
    void set_type(SymbolType type);

    // Symbol scope
    SymbolScope scope() const;
    void set_scope(SymbolScope scope);

    // Source location
    const Location& location() const;
    void set_location(const Location& location);

    // Opcode (for address-relative symbols - used to compute final address)
    Opcode* opcode() const;
    void set_opcode(Opcode* opcode);

    // Offset (for address-relative symbols)
    int offset() const;
    void set_offset(int offset);

    // Expression (for computed symbols)
    const Expression& expression() const;
    void set_expression(const Expression& expr);
    bool has_expression() const;

    // Type checks
    bool is_undefined() const;
    bool is_constant() const;
    bool is_address_relative() const;
    bool is_computed() const;

    // Scope checks
    bool is_local() const;
    bool is_public() const;
    bool is_extern() const;
    bool is_global() const;

    // Effective scope (accounts for Global + defined/undefined)
    bool is_exported() const;  // PUBLIC or (GLOBAL && defined)
    bool is_imported() const;  // EXTERN or (GLOBAL && undefined)

    // Definition check
    bool is_defined() const;

    // Evaluate symbol value
    // Throws UndefinedSymbol if symbol is undefined
    // Throws RecursiveEvaluation if evaluation is recursive
    // Throws ExpressionError on other evaluation failures
    int evaluate() const;

private:
    std::string name_;
    int value_ = 0;                     // Value for constants and computed results
    SymbolType type_ = SymbolType::Undefined;
    SymbolScope scope_ = SymbolScope::Local;
    Location location_;
    Opcode* opcode_ =
        nullptr;          // Opcode for address-relative symbols (to compute address)
    int offset_ = 0;                    // Offset for address-relative symbols
    Expression expression_;             // Expression for computed symbols
    mutable bool evaluating_ =
        false;   // Flag to detect recursive evaluation (mutable for const evaluate)
};

//-----------------------------------------------------------------------------
// Patch range types - value size and interpretation for patching
//-----------------------------------------------------------------------------
enum class PatchRange {
    Undefined,              // No patch needed
    JrOffset,               // 8-bit signed relative offset for JR (-128 to +127)
    ByteUnsigned,           // 8-bit unsigned value (0 to 255)
    ByteSigned,             // 8-bit signed value (-128 to +127)
    Word,                   // 16-bit value, little-endian
    WordBigEndian,          // 16-bit value, big-endian
    Dword,                  // 32-bit signed value, little-endian
    ByteToWordUnsigned,     // 8-bit unsigned extended to 16 bits
    ByteToWordSigned,       // 8-bit signed sign-extended to 16 bits
    Ptr24,                  // 24-bit pointer (address), little-endian
    HighOffset,             // 8-bit offset to 0xFF00 (for LDH, etc.)
    Assignment,             // DEFC expression assigning a symbol
    JreOffset,              // 16-bit relative offset for JRE
    ByteToPtr24Unsigned,    // 8-bit unsigned extended to 24 bits
    ByteToPtr24Signed       // 8-bit signed sign-extended to 24 bits
};

//-----------------------------------------------------------------------------
// Patch - represents a value to be patched into an opcode at link time
//-----------------------------------------------------------------------------
class Patch {
public:
    Patch() = default;
    Patch(int offset, PatchRange range, const Expression& expr);

    int offset() const;
    void set_offset(int offset);

    PatchRange range() const;
    void set_range(PatchRange range);

    const Expression& expression() const;
    void set_expression(const Expression& expr);

    const Location& location() const;

    // Resolve patch: evaluate expression and patch bytes
    bool resolve(std::vector<uint8_t>& bytes, int asmpc, int opcode_size);

private:
    // Helper: evaluate expression and return value
    int evaluate_expression(int asmpc, int opcode_size);

    // Helper: patch bytes with value according to range
    void patch_bytes(std::vector<uint8_t>& bytes, int value);

    int offset_ = 0;
    PatchRange range_ = PatchRange::Undefined;
    Expression expression_;
};

//-----------------------------------------------------------------------------
// Opcode - represents a single assembled instruction or data
//-----------------------------------------------------------------------------
class Opcode {
public:
    // All constructors require a location (as last parameter)
    explicit Opcode(const Location& location);
    Opcode(const std::vector<uint8_t>& bytes, const Location& location);
    Opcode(int address, const std::vector<uint8_t>& bytes,
           const Location& location);

    // Address (initialized to 0, computed at link time)
    int address() const;
    void set_address(int address);

    // Opcode bytes
    const std::vector<uint8_t>& bytes() const;
    std::vector<uint8_t>& bytes();
    void set_bytes(const std::vector<uint8_t>& bytes);

    // Opcode size
    size_t size() const;

    // Byte manipulation
    void clear_bytes();
    void add_byte(uint8_t byte);
    // Add 1-4 bytes from value (first non-zero byte and all lower)
    void add_bytes(unsigned int value);

    // Patches to apply
    const std::vector<Patch>& patches() const;
    void add_patch(const Patch& patch);
    void clear_patches();

    // Check if opcode has patches
    bool has_patches() const;

    // Source location (immutable - required for error messages and list file)
    const Location& location() const;

private:
    int address_ =
        0;                   // Address in section (computed at link time)
    std::vector<uint8_t> bytes_;        // Opcode bytes
    std::vector<Patch> patches_;        // Patches to apply
    Location location_;                 // Source location (immutable)
};

//-----------------------------------------------------------------------------
// Section - represents a contiguous block of code or data
//-----------------------------------------------------------------------------
class Section {
public:
    Section() = default;
    explicit Section(const std::string& name);

    // Section identification
    const std::string& name() const;
    void set_name(const std::string& name);

    // Alignment (default 1 = no alignment constraint)
    // Base address will be adjusted to be a multiple of alignment
    int alignment() const;
    void set_alignment(int align);

    // Base address (computed at link time, adjusted for alignment)
    int base_address() const;
    void set_base_address(int addr);

    // Opcodes in this section (heap-allocated for pointer stability)
    const std::vector<std::unique_ptr<Opcode>>& opcodes() const;
    Opcode* add_opcode(const Opcode& opcode);  // Returns pointer to added opcode
    Opcode* last_opcode();                     // Returns pointer to last opcode (nullptr if empty)
    const Opcode* last_opcode() const;         // Const version
    void clear_opcodes();

    // Current size (sum of all opcode sizes)
    size_t size() const;

    // Get current program counter (base_address + size)
    int pc() const;

    // compute opcodes addresses after assembling
    void compute_opcodes_addresses();

private:
    // Adjust address to meet alignment requirement
    static int align_address(int addr, int alignment);

    std::string name_;
    int alignment_ =
        1;                                 // Alignment requirement (1 = no constraint)
    int base_address_ =
        0;                              // Base address of section (aligned)
    std::vector<std::unique_ptr<Opcode>>
                                      opcodes_;     // Opcodes in this section (heap-allocated for pointer stability)
};


//-----------------------------------------------------------------------------
// Module - represents a object file/module with sections and symbols
//-----------------------------------------------------------------------------
class Module {
public:
    // Constructor requires name and location of MODULE directive
    Module(const std::string& name, const Location& location);

    // Module identification (name is immutable - it's the key in module collection)
    const std::string& name() const;

    // Location of MODULE directive
    const Location& location() const;

    // Current section (last added, or default empty section if none added)
    Section* current_section();
    const Section* current_section() const;

    // Sections in this module
    const std::vector<std::unique_ptr<Section>>& sections() const;
    Section* add_section(const std::string& name);
    Section* find_section(const std::string& name);
    void clear_sections();

    // Symbol table for all symbols defined in this module
    const std::unordered_map<std::string, Symbol>& symbols() const;

    // Declare a symbol (for PUBLIC, EXTERN, GLOBAL directives)
    // Creates symbol with Undefined type if it doesn't exist
    // Updates scope if symbol exists and scope change is valid
    // Errors:
    //   - Changing scope from non-Local to different scope
    //   - Declaring a defined symbol as Extern
    Symbol* declare_symbol(const std::string& name, const Location& location,
                           SymbolScope scope);

    // Define a symbol (for source code definitions like labels, EQU, etc.)
    // Creates symbol if it doesn't exist
    // Updates undefined symbol if it exists
    // Errors:
    //   - Symbol is already defined
    //   - Symbol is declared as Extern
    Symbol* add_symbol(const std::string& name, const Location& location);
    Symbol* add_symbol(const std::string& name, const Location& location,
                       int value, SymbolType type = SymbolType::Constant);

    Symbol* find_symbol(const std::string& name);
    const Symbol* find_symbol(const std::string& name) const;
    bool has_symbol(const std::string& name) const;
    void clear_symbols();

    const std::vector<Location>& get_extern_declarations(const std::string& name)
    const;

private:
    std::string
    name_;                                          // Module name (immutable)
    Location location_;                                         // Location of MODULE directive
    std::vector<std::unique_ptr<Section>>
                                       sections_;           // All sections in this module (heap-allocated for pointer stability)
    Section* current_section_ =
        nullptr;                        // Pointer to last added section (or default empty section)
    std::unordered_map<std::string, Symbol>
    symbols_;          // Symbol table (name -> Symbol)

    // Track all declaration locations for error reporting
    std::unordered_map<std::string, std::vector<Location>> extern_declarations_;
};

//-----------------------------------------------------------------------------
// CompilationUnit - represents the result of assembling one source file
//-----------------------------------------------------------------------------

class CompilationUnit {
public:
    // Constructor requires name and location
    CompilationUnit(const std::string& name, const Location& location);

    // Name and location
    const std::string& name() const;
    const Location& location() const;

    // Module management
    const std::vector<std::unique_ptr<Module>>& modules() const;

    // Add module by name - returns existing module or creates new one
    Module* add_module(const std::string& name);

    // Find module by name - returns nullptr if not found
    Module* find_module(const std::string& name);
    const Module* find_module(const std::string& name) const;

    // Current module (last added)
    Module* current_module();
    const Module* current_module() const;

    // Clear all modules and recreate default empty-named module
    void clear_modules();

private:
    std::string name_;
    Location location_;
    std::vector<std::unique_ptr<Module>> modules_;
    Module* current_module_ = nullptr;  // Non-owning pointer to last added module
};

//-----------------------------------------------------------------------------
// Library - represents a library file (.lib) used during linking
//-----------------------------------------------------------------------------
class Library {
public:
    // Constructor requires library filename
    explicit Library(const std::string& filename);

    // Library identification
    const std::string& filename() const;

    // Public symbol index - maps symbol names to modules that define them
    // This allows quick lookup during symbol resolution without scanning all modules
    const std::unordered_map<std::string, Module*>& public_symbols() const;

    // Find which module defines a public symbol
    // Returns nullptr if symbol not found or not public
    Module* find_public_symbol(const std::string& name);
    const Module* find_public_symbol(const std::string& name) const;

    // Check if library exports a symbol
    bool has_public_symbol(const std::string& name) const;

    // Module management
    const std::vector<std::unique_ptr<Module>>& modules() const;

    // Add module to library
    // Automatically indexes public symbols from the module
    Module* add_module(std::unique_ptr<Module> module);

    // Find module by name
    Module* find_module(const std::string& name);
    const Module* find_module(const std::string& name) const;

    // Clear all modules (also clears public symbol index)
    void clear_modules();

    // Rebuild public symbol index from all modules
    // Called automatically by add_module(), but can be called manually
    // if symbol scopes change after modules are added
    void rebuild_public_symbol_index();

    // Statistics
    size_t module_count() const;
    size_t public_symbol_count() const;

private:
    // Index public symbols from a single module
    // Used by add_module() and rebuild_public_symbol_index()
    void index_module_public_symbols(Module* module);

    std::string filename_;                                      // Library filename
    std::vector<std::unique_ptr<Module>>
                                      modules_;             // All modules in this library
    std::unordered_map<std::string, Module*>
    public_symbols_;  // Public symbol name -> defining module
};

//-----------------------------------------------------------------------------
// Linker - manages the linking process
//-----------------------------------------------------------------------------
class Linker {
public:
    Linker();

    // Add a module to the linked program
    // Extracts public symbols and updates unresolved extern list
    // Returns pointer to added module
    Module* add_module(std::unique_ptr<Module> module);

    // Add a library to the search path
    void add_library(Library* library);

    // Link against libraries to resolve remaining extern symbols
    // Pulls in modules from libraries as needed
    // Returns true if all symbols resolved, false if unresolved symbols remain
    bool link_libraries();

    // Get list of modules in link order
    const std::vector<std::unique_ptr<Module>>& modules() const;

    // Get public symbol map (symbol name -> defining module)
    const std::unordered_map<std::string, Module*>& public_symbols() const;

    // Get list of unresolved extern symbols
    const std::unordered_map<std::string, std::vector<Location>>&
            unresolved_externs() const;

    // Check if there are unresolved symbols
    bool has_unresolved_symbols() const;

    // Get library search path
    const std::vector<Library*>& libraries() const;

    // Clear all state
    void clear();

    // Statistics
    size_t module_count() const;
    size_t public_symbol_count() const;
    size_t unresolved_symbol_count() const;

private:
    // Update public symbols from a module
    void index_module_public_symbols(Module* module);

    // Update unresolved externs after adding a module
    void update_unresolved_externs(Module* module);

    // Try to resolve a symbol from libraries
    // Returns the module that defines the symbol, or nullptr if not found
    Module* resolve_from_libraries(const std::string& symbol_name);

    std::vector<std::unique_ptr<Module>>
                                      modules_;                          // Modules in link order
    std::vector<Library*>
    libraries_;                                       // Library search path (non-owning)
    std::unordered_map<std::string, Module*>
    public_symbols_;              // Public symbol -> defining module
    std::unordered_map<std::string, std::vector<Location>>
            unresolved_externs_;  // Unresolved symbol -> locations where referenced
    std::set<Module*> library_modules_pulled_;
    std::set<std::string>
    currently_resolving_; // Track symbols being resolved to detect cycles

    // Helper to resolve with cycle detection
    Module* resolve_with_cycle_detection(const std::string& symbol_name,
                                         int depth = 0);
    static constexpr int MAX_RESOLUTION_DEPTH = 100; // Prevent infinite recursion
};

