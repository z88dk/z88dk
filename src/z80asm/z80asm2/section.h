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
#include <vector>

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
    // Address in section (computed at link time)
    int address_ = 0;
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


