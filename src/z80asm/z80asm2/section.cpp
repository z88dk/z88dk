//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2025
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "errors.h"
#include "section.h"
#include "utils.h"
#include <cassert>
#include <cassert>
#include <memory>

//-----------------------------------------------------------------------------
// Patch implementation
//-----------------------------------------------------------------------------

Patch::Patch(Opcode* parent)
    : parent_(parent) {
}

Patch::Patch(Opcode* parent, int offset, PatchRange range, const Expression& expr)
    : parent_(parent), offset_(offset), range_(range), expression_(expr) {
}

Opcode* Patch::parent() const {
    return parent_;
}

void Patch::set_parent(Opcode* parent) {
    parent_ = parent;
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

bool Patch::resolve() {
    assert(parent_);

    try {
        int value = evaluate_expression();
        patch_bytes(parent_->bytes(), value);
        return true;
    }
    catch (const ExpressionError&) {
        // Error already reported by expression evaluation
        return false;
    }
}

int Patch::evaluate_expression() {
    // For JR_OFFSET and JRE_OFFSET, need to compute relative offset
    int value = expression_.evaluate();

    if (range_ == PatchRange::JrOffset || range_ == PatchRange::JreOffset) {
        int asmpc = parent_ ? parent_->address() : 0;
        int opcode_size = parent_ ? static_cast<int>(parent_->size()) : 0;

        // Compute relative offset: target - (asmpc + opcode_size)
        value = value - (asmpc + opcode_size);
    }

    return value;
}

void Patch::patch_bytes(std::vector<uint8_t>& bytes, int value) {
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

Opcode::Opcode(Section* parent, const Location& location)
    : parent_(parent), location_(location) {}

Opcode::Opcode(Section* parent, const std::vector<uint8_t>& bytes, const Location& location)
    : parent_(parent), bytes_(bytes), location_(location) {
}

Opcode::Opcode(Section* parent, int address, const std::vector<uint8_t>& bytes, const Location& location)
    : parent_(parent), address_(address), bytes_(bytes), location_(location) {
}

Section* Opcode::parent() const {
    return parent_;
}

void Opcode::set_parent(Section* parent) {
    parent_ = parent;
    // Rebind patches to this opcode
    for (auto& p : patches_) {
        p.set_parent(this);
    }
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

void Opcode::add_bytes(uint64_t value) {
    // Emit a minimal big-endian byte sequence for `value`.
    // Behaviour kept compatible with the previous implementation:
    // - emit the smallest number of bytes that represent `value` (except zero -> emit one zero byte)
    // - bytes are emitted MSB first (big-endian order)
    uint8_t parts[8];
    // parts[0] = most significant byte, parts[7] = least significant byte
    for (int i = 0; i < 8; ++i) {
        parts[i] = static_cast<uint8_t>((value >> ((7 - i) * 8)) & 0xFF);
    }

    // find first non-zero byte (from MSB to LSB)
    int first_nonzero = -1;
    for (int i = 0; i < 8; ++i) {
        if (parts[i] != 0) {
            first_nonzero = i;
            break;
        }
    }

    if (first_nonzero == -1) {
        // value == 0 -> emit a single zero byte (preserve old behavior)
        bytes_.push_back(parts[7]);
    }
    else {
        // emit from first_nonzero .. 7 (MSB..LSB)
        for (int i = first_nonzero; i < 8; ++i) {
            bytes_.push_back(parts[i]);
        }
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

bool Opcode::resolve() {
    bool ok = true;
    for (auto& p : patches_) {
        if (p.parent() != this) {
            p.set_parent(this);
        }
        ok = p.resolve() && ok;
    }
    return ok;
}

bool Opcode::has_patches() const {
    return !patches_.empty();
}

const Location& Opcode::location() const {
    return location_;
}

// NEW: deep clone bound to new_parent
std::unique_ptr<Opcode> Opcode::clone(Section* new_parent) const {
    auto cloned = std::make_unique<Opcode>(new_parent, address_, bytes_, location_);
    // copy patches and rebind to cloned opcode
    for (const auto& p : patches_) {
        Patch copy(cloned.get(), p.offset(), p.range(), p.expression());
        cloned->add_patch(copy);
    }
    return cloned;
}

//-----------------------------------------------------------------------------
// Section implementation
//-----------------------------------------------------------------------------

Section::Section(const std::string& name) : name_(name) {
    // Always start with an empty opcode so last_opcode() never returns nullptr
    opcodes_.push_back(std::make_unique<Opcode>(this, Location()));
    // Initialize the sentinel opcode address to the current base
    opcodes_.back()->set_address(base_address_);
}

Opcode* Section::add_opcode(const Opcode& opcode) {
    // Clone opcode (deep copy, patches rebound) and bind to this Section
    auto created = opcode.clone(this);

    // Set address based on previous opcode to provide immediate stability
    if (opcodes_.empty()) {
        created->set_address(base_address_);
    }
    else {
        const Opcode* prev = opcodes_.back().get();
        int prev_addr = prev->address();
        int next_addr = prev_addr + static_cast<int>(prev->size());
        if (opcodes_.size() == 1) {
            opcodes_.back()->set_address(base_address_);
            next_addr = base_address_ + static_cast<int>(prev->size());
        }
        created->set_address(next_addr);
    }

    opcodes_.push_back(std::move(created));
    return opcodes_.back().get();
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
    set_base_address(align_address(base_address_, alignment_));
}

int Section::base_address() const {
    return base_address_;
}

void Section::set_base_address(int addr) {
    // Align and set base address
    base_address_ = align_address(addr, alignment_);
    // Recompute all opcode addresses after base change
    compute_opcodes_addresses();
}

const std::vector<std::unique_ptr<Opcode>>& Section::opcodes() const {
    return opcodes_;
}

Opcode* Section::last_opcode() {
    assert(!opcodes_.empty());
    return opcodes_.back().get();
}

const Opcode* Section::last_opcode() const {
    assert(!opcodes_.empty());
    return opcodes_.back().get();
}

void Section::clear_opcodes() {
    opcodes_.clear();
    // Always maintain at least one empty opcode so last_opcode() never returns nullptr
    opcodes_.push_back(std::make_unique<Opcode>(this, Location()));
    // Reset sentinel address to current base
    opcodes_.back()->set_address(base_address_);
}

size_t Section::size() const {
    size_t total = 0;
    for (const auto& opcode : opcodes_) {
        total += opcode->size();
    }
    return total;
}

int Section::pc() const {
    const Opcode* last = last_opcode();
    assert(last);
    return last->address() + static_cast<int>(last->size());
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
    int remainder = addr % alignment;
    if (remainder == 0) {
        return addr;    // Already aligned
    }

    return addr + (alignment - remainder);
}


