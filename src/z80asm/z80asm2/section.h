//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
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

class Opcode; // forward

//-----------------------------------------------------------------------------
// Patch - represents a value to be patched into an opcode at link time
//-----------------------------------------------------------------------------
class Patch {
public:
    Patch(Opcode* parent = nullptr);
    Patch(Opcode* parent, int offset, PatchRange range, const Expression& expr);

    Opcode* parent() const;
    void set_parent(Opcode* parent);

    int offset() const;
    void set_offset(int offset);

    PatchRange range() const;
    void set_range(PatchRange range);

    const Expression& expression() const;
    void set_expression(const Expression& expr);

    const Location& location() const;

    bool resolve();

private:
    int evaluate_expression();
    void patch_bytes(std::vector<uint8_t>& bytes, int value);

    Opcode* parent_ = nullptr;
    int offset_ = 0;
    PatchRange range_ = PatchRange::Undefined;
    Expression expression_;
};

class Section; // forward

class Opcode {
public:
    explicit Opcode(Section* parent, const Location& location);
    Opcode(Section* parent, const std::vector<uint8_t>& bytes, const Location& location);
    Opcode(Section* parent, int address, const std::vector<uint8_t>& bytes, const Location& location);
    std::unique_ptr<Opcode> clone(Section* new_parent) const;

    Section* parent() const;
    void set_parent(Section* parent);                 // NEW

    int address() const;
    void set_address(int address);

    const std::vector<uint8_t>& bytes() const;
    std::vector<uint8_t>& bytes();
    void set_bytes(const std::vector<uint8_t>& bytes);

    size_t size() const;

    void clear_bytes();
    void add_byte(uint8_t byte);
    void add_bytes(uint64_t value);

    const std::vector<Patch>& patches() const;
    void add_patch(const Patch& patch);
    void clear_patches();

    // Resolve all patches for this opcode
    // Patches will modify this opcode's bytes in place
    bool resolve();

    // Check if opcode has patches
    bool has_patches() const;

    // Source location (immutable - required for error messages and list file)
    const Location& location() const;

private:
    Section* parent_ = nullptr;          // Non-owning reference to parent section
    int address_ = 0;                    // Address in section (computed at link time)
    std::vector<uint8_t> bytes_;         // Opcode bytes
    std::vector<Patch> patches_;         // Patches to apply
    Location location_;                  // Source location (immutable)
};

//-----------------------------------------------------------------------------
// Section - represents a contiguous block of code or data
//-----------------------------------------------------------------------------
class Section {
public:
    explicit Section(const std::string& name = "");

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
    int alignment_ = 1;                   // Alignment requirement (1 = no constraint)
    int base_address_ = 0;                // Base address of section (aligned)
    std::vector<std::unique_ptr<Opcode>> opcodes_; // Opcodes in this section
};


