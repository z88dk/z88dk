//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "section.h"
#include "utils.h"
#include <cassert>

//-----------------------------------------------------------------------------
// Patch implementation
//-----------------------------------------------------------------------------

Patch::Patch(int offset, PatchRange range, const Expression& expr)
    : offset_(offset), range_(range), expression_(expr) {
}

int Patch::offset() const {
    return offset_;
}

void Patch::set_offset(int offset) {
    offset_ = offset;
}

PatchRange Patch::range() const {
    return range_;
}

void Patch::set_range(PatchRange range) {
    range_ = range;
}

const Expression& Patch::expression() const {
    return expression_;
}

void Patch::set_expression(const Expression& expr) {
    expression_ = expr;
}

const Location& Patch::location() const {
    return expression_.location();
}

bool Patch::resolve(std::vector<uint8_t>& bytes, int asmpc, int opcode_size) {
    try {
        int value = evaluate_expression(asmpc, opcode_size);
        patch_bytes(bytes, value);
        return true;
    }
    catch (const ExpressionError&) {
        // Error already reported by expression evaluation
        return false;
    }
}

int Patch::evaluate_expression(int asmpc, int opcode_size) {
    // For JR_OFFSET and JRE_OFFSET, need to compute relative offset
    int value = expression_.evaluate();

    if (range_ == PatchRange::JrOffset || range_ == PatchRange::JreOffset) {
        // Compute relative offset: target - (asmpc + opcode_size)
        value = value - (asmpc + opcode_size);
    }

    return value;
}

void Patch::patch_bytes(std::vector<uint8_t>& bytes, int value) {
    // Helper lambda to patch a byte at offset
    auto patch_byte = [&](int pos, uint8_t byte_value) {
        if (pos >= 0 && static_cast<size_t>(offset_ + pos) < bytes.size()) {
            bytes[offset_ + pos] = byte_value;
        }
    };

    switch (range_) {
    case PatchRange::ByteUnsigned:
        if (value < -128 || value > 255) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) + " out of range for unsigned byte");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        break;

    case PatchRange::ByteSigned:
        if (value < -128 || value > 127) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) + " out of range for signed byte");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        break;

    case PatchRange::HighOffset:
        if ((value & 0xff00) != 0) {
            if ((value & 0xff00) != 0xff00) {
                g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                                 "Value " + int_to_hex(value) + " out of range for high offset");
            }
        }
        patch_byte(0, static_cast<uint8_t>(value & 0xff));
        break;

    case PatchRange::ByteToWordUnsigned:
        if (value < 0 || value > 255) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) + " out of range for unsigned byte to word");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        patch_byte(1, 0);
        break;

    case PatchRange::ByteToWordSigned:
        if (value < -128 || value > 127) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) + " out of range for signed byte to word");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        patch_byte(1, (value < 0 || value > 127) ? 0xff : 0);
        break;

    case PatchRange::ByteToPtr24Unsigned:
        if (value < 0 || value > 255) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) +
                             " out of range for unsigned byte to 24-bit pointer");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        patch_byte(1, 0);
        patch_byte(2, 0);
        break;

    case PatchRange::ByteToPtr24Signed:
        if (value < -128 || value > 127) {
            g_errors.warning(expression_.location(), ErrorCode::IntegerRange,
                             "Value " + int_to_hex(value) +
                             " out of range for signed byte to 24-bit pointer");
        }
        patch_byte(0, static_cast<uint8_t>(value));
        patch_byte(1, (value < 0 || value > 127) ? 0xff : 0);
        patch_byte(2, (value < 0 || value > 127) ? 0xff : 0);
        break;

    case PatchRange::Ptr24:
        patch_byte(0, static_cast<uint8_t>((value >> 0) & 0xff));
        patch_byte(1, static_cast<uint8_t>((value >> 8) & 0xff));
        patch_byte(2, static_cast<uint8_t>((value >> 16) & 0xff));
        break;

    case PatchRange::Word:
        // Little-endian word
        patch_byte(0, static_cast<uint8_t>((value >> 0) & 0xff));
        patch_byte(1, static_cast<uint8_t>((value >> 8) & 0xff));
        break;

    case PatchRange::WordBigEndian:
        // Big-endian word
        patch_byte(0, static_cast<uint8_t>((value >> 8) & 0xff));
        patch_byte(1, static_cast<uint8_t>((value >> 0) & 0xff));
        break;

    case PatchRange::Dword:
        // Little-endian dword
        patch_byte(0, static_cast<uint8_t>((value >> 0) & 0xff));
        patch_byte(1, static_cast<uint8_t>((value >> 8) & 0xff));
        patch_byte(2, static_cast<uint8_t>((value >> 16) & 0xff));
        patch_byte(3, static_cast<uint8_t>((value >> 24) & 0xff));
        break;

    case PatchRange::JrOffset:
        // Value already adjusted by evaluate_expression()
        if (value < -128 || value > 127) {
            g_errors.error(expression_.location(), ErrorCode::IntegerRange,
                           "JR offset " + int_to_hex(value) + " out of range (-128 to 127)");
        }
        else {
            patch_byte(0, static_cast<uint8_t>(value));
        }
        break;

    case PatchRange::JreOffset:
        // Value already adjusted by evaluate_expression()
        if (value < -0x8000 || value > 0x7FFF) {
            g_errors.error(expression_.location(), ErrorCode::IntegerRange,
                           "JR extended offset " + int_to_hex(value) + " out of range (-32768 to 32767)");
        }
        else {
            // Little-endian word
            patch_byte(0, static_cast<uint8_t>((value >> 0) & 0xff));
            patch_byte(1, static_cast<uint8_t>((value >> 8) & 0xff));
        }
        break;

    case PatchRange::Assignment:
        // Assignment patches don't modify bytes
        break;

    case PatchRange::Undefined:
    default:
        assert(0); // Should not reach here
        break;
    }
}

//-----------------------------------------------------------------------------
// Opcode implementation
//-----------------------------------------------------------------------------

Opcode::Opcode(const Location& location) : location_(location) {}

Opcode::Opcode(const std::vector<uint8_t>& bytes, const Location& location)
    : bytes_(bytes), location_(location) {
}

Opcode::Opcode(int address, const std::vector<uint8_t>& bytes,
               const Location& location)
    : address_(address), bytes_(bytes), location_(location) {
}

int Opcode::address() const {
    return address_;
}

void Opcode::set_address(int address) {
    address_ = address;
}

const std::vector<uint8_t>& Opcode::bytes() const {
    return bytes_;
}

std::vector<uint8_t>& Opcode::bytes() {
    return bytes_;
}

void Opcode::set_bytes(const std::vector<uint8_t>& bytes) {
    bytes_ = bytes;
}

size_t Opcode::size() const {
    return bytes_.size();
}

void Opcode::clear_bytes() {
    bytes_.clear();
}

void Opcode::add_byte(uint8_t byte) {
    bytes_.push_back(byte);
}

void Opcode::add_bytes(unsigned int value) {
    // Extract bytes from value (up to 4 bytes)
    // Find the first non-zero byte from high to low order
    // Then add that byte and all lower order bytes

    // Break into bytes
    uint8_t byte3 = static_cast<uint8_t>((value >> 24) & 0xFF);
    uint8_t byte2 = static_cast<uint8_t>((value >> 16) & 0xFF);
    uint8_t byte1 = static_cast<uint8_t>((value >> 8) & 0xFF);
    uint8_t byte0 = static_cast<uint8_t>(value & 0xFF);

    // Find first non-zero byte (or start at byte 0 if all are zero)
    if (byte3 != 0) {
        bytes_.push_back(byte3);
        bytes_.push_back(byte2);
        bytes_.push_back(byte1);
        bytes_.push_back(byte0);
    }
    else if (byte2 != 0) {
        bytes_.push_back(byte2);
        bytes_.push_back(byte1);
        bytes_.push_back(byte0);
    }
    else if (byte1 != 0) {
        bytes_.push_back(byte1);
        bytes_.push_back(byte0);
    }
    else {
        bytes_.push_back(byte0);
    }
}

const std::vector<Patch>& Opcode::patches() const {
    return patches_;
}

void Opcode::add_patch(const Patch& patch) {
    patches_.push_back(patch);
}

void Opcode::clear_patches() {
    patches_.clear();
}

bool Opcode::has_patches() const {
    return !patches_.empty();
}

const Location& Opcode::location() const {
    return location_;
}

//-----------------------------------------------------------------------------
// Section implementation
//-----------------------------------------------------------------------------

Section::Section(const std::string& name) : name_(name) {
    // Always start with an empty opcode so last_opcode() never returns nullptr
    opcodes_.push_back(std::make_unique<Opcode>(Location()));
}

const std::string& Section::name() const {
    return name_;
}

void Section::set_name(const std::string& name) {
    name_ = name;
}

int Section::alignment() const {
    return alignment_;
}

void Section::set_alignment(int align) {
    if (align <= 0) {
        align = 1;    // Minimum alignment is 1 (no constraint)
    }
    alignment_ = align;

    // Re-adjust base address to meet new alignment requirement
    base_address_ = align_address(base_address_, alignment_);
}

int Section::base_address() const {
    return base_address_;
}

void Section::set_base_address(int addr) {
    base_address_ = align_address(addr, alignment_);
}

const std::vector<std::unique_ptr<Opcode>>& Section::opcodes() const {
    return opcodes_;
}

Opcode* Section::add_opcode(const Opcode& opcode) {
    opcodes_.push_back(std::make_unique<Opcode>(opcode));
    return opcodes_.back().get();
}

Opcode* Section::last_opcode() {
    // Never returns nullptr - there's always at least one empty opcode
    return opcodes_.back().get();
}

const Opcode* Section::last_opcode() const {
    // Never returns nullptr - there's always at least one empty opcode
    return opcodes_.back().get();
}

void Section::clear_opcodes() {
    opcodes_.clear();
    // Always maintain at least one empty opcode so last_opcode() never returns nullptr
    opcodes_.push_back(std::make_unique<Opcode>(Location()));
}

size_t Section::size() const {
    size_t total = 0;
    for (const auto& opcode : opcodes_) {
        total += opcode->size();
    }
    return total;
}

int Section::pc() const {
    return base_address_ + static_cast<int>(size());
}

void Section::compute_opcodes_addresses() {
    int addr = base_address_;
    for (auto& opcode : opcodes_) {
        opcode->set_address(addr);
        addr += static_cast<int>(opcode->size());
    }
}

int Section::align_address(int addr, int alignment) {
    if (alignment <= 1) {
        return addr;    // No alignment needed
    }

    // Calculate aligned address
    // Formula: ((addr + alignment - 1) / alignment) * alignment
    int remainder = addr % alignment;
    if (remainder == 0) {
        return addr;    // Already aligned
    }

    return addr + (alignment - remainder);
}


