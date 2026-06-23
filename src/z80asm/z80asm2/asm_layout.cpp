//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asm_expr.h"
#include "asm_layout.h"
#include "diag.h"
#include "ir.h"
#include "release_assert.h"
#include "source_loc.h"
#include "string_utils.h"
#include <string_view>

bool compute_layout(Program& prog, bool& changed) {
    bool in_phase = false;
    uint real_pc = 0;
    uint phase_pc = 0;
    SourceLoc phase_loc;

    // update the address set changed to true if any address is updated
    auto update = [&](uint & old_address, uint new_address) {
        if (old_address != new_address) {
            old_address = new_address;
            changed = true;
        }
    };

    // layout either with real_pc or phased_pc depending on in_phase
    auto layout = [&](uint & old_address, uint size) {
        if (in_phase) {
            update(old_address, phase_pc);
            real_pc += size;
            phase_pc += size;
        }
        else {
            update(old_address, real_pc);
            real_pc += size;
        }
    };

    // validate ALIGN value is a power of two
    auto validate_align = [](uint align_value, const SourceLoc & loc) -> bool {
        if (align_value == 0 || (align_value & (align_value - 1)) != 0) {
            g_diag.error(loc, "ALIGN value must be a power of two");
            return false;
        }
        return true;
    };

    bool failed = false;
    for (auto& mod : prog.modules) {
        for (auto& sec : mod->sections) {
            in_phase = false;
            real_pc = 0;
            phase_pc = 0;
            phase_loc = SourceLoc();

            // section level ORG
            sec->base_address = 0;
            if (sec->org_stmt) {
                int value = 0;  // int to be able to read ORG -1
                if (!get_const_expr_value(sec->org_stmt->expr.get(),
                                          value, "ORG")) {
                    failed = true;
                }
                else if (value == -1) {
                    sec->section_split = true;
                    sec->base_address = 0;
                    sec->org_defined = false;
                }
                else if (value >= 0) {
                    sec->section_split = false;
                    sec->base_address = value;
                    sec->org_defined = true;
                }
                else {
                    g_diag.error(sec->org_stmt->expr->loc,
                                 "Interger range: " + int_to_hex(value));
                    failed = true;
                }
            }

            // section level ALIGN
            uint align_value = 1;
            if (sec->align_stmt) {
                if (!get_const_expr_value(sec->align_stmt->align_expr.get(),
                                          align_value, "ALIGN")) {
                    failed = true;
                }
                else if (!validate_align(align_value, sec->align_stmt->align_expr->loc)) {
                    failed = true;
                }
                else {
                    sec->align = align_value;
                }
            }

            // section statements
            for (auto& stmt : sec->stmts) {
                if (auto opc_stmt = dynamic_cast<OpcodeStmt*>(stmt)) {
                    opc_stmt->section = sec.get();
                    layout(opc_stmt->address,
                           static_cast<uint>(opc_stmt->bytes.size()));
                    continue;
                }

                if (auto lbl_stmt = dynamic_cast<LabelStmt*>(stmt)) {
                    lbl_stmt->section = sec.get();
                    layout(lbl_stmt->address, 0);
                    continue;
                }

                if (auto org_stmt = dynamic_cast<OrgStmt*>(stmt)) {
                    org_stmt->section = sec.get();
                    layout(org_stmt->address, 0);

                    uint new_address = org_stmt->address;
                    if (!get_const_expr_value(org_stmt->expr.get(),
                                              new_address, "ORG")) {
                        failed = true;
                    }
                    uint new_offset = new_address - sec->base_address;

                    if (new_address < sec->base_address ||
                            new_offset < org_stmt->address) {
                        g_diag.error(org_stmt->expr->loc,
                                     "ORG address cannot be less "
                                     "than previously allocated");
                        failed = true;
                    }
                    else {
                        org_stmt->padding_size = new_offset - org_stmt->address;
                        layout(org_stmt->address, org_stmt->padding_size);
                    }

                    continue;
                }

                if (auto defc_stmt = dynamic_cast<DefcStmt*>(stmt)) {
                    defc_stmt->section = sec.get();
                    layout(defc_stmt->address, 0);
                    continue;
                }

                if (auto align_stmt = dynamic_cast<AlignStmt*>(stmt)) {
                    align_stmt->section = sec.get();
                    layout(align_stmt->address, 0);

                    align_value = 1;
                    if (!get_const_expr_value(align_stmt->align_expr.get(),
                                              align_value, "ALIGN")) {
                        failed = true;
                    }

                    if (!validate_align(align_value, align_stmt->align_expr->loc)) {
                        failed = true;
                    }

                    uint new_address =
                        (align_stmt->address + (align_value - 1)) & ~(align_value - 1);
                    align_stmt->padding_size = new_address - align_stmt->address;
                    layout(align_stmt->address, align_stmt->padding_size);
                    continue;
                }

                if (auto defs_stmt = dynamic_cast<DefsNumericStmt*>(stmt)) {
                    defs_stmt->section = sec.get();
                    layout(defs_stmt->address, 0);

                    uint size_value = 0;
                    if (!get_const_expr_value(defs_stmt->size_expr.get(),
                                              size_value, "DEFS")) {
                        failed = true;
                    }

                    defs_stmt->padding_size = size_value;
                    layout(defs_stmt->address, defs_stmt->padding_size);
                    continue;
                }

                if (auto defs_stmt = dynamic_cast<DefsStringStmt*>(stmt)) {
                    defs_stmt->section = sec.get();
                    layout(defs_stmt->address, 0);

                    std::string_view str_value = g_strings.view(defs_stmt->string_id);
                    uint size_value = static_cast<uint>(str_value.size());
                    if (!get_const_expr_value(defs_stmt->size_expr.get(),
                                              size_value, "DEFS")) {
                        failed = true;
                    }

                    if (size_value < str_value.size()) {
                        g_diag.error(defs_stmt->size_expr->loc,
                                     "DEFS size cannot be less than the string length");
                        failed = true;

                        // use string length to avoid negative padding
                        size_value = static_cast<uint>(str_value.size());
                    }

                    defs_stmt->padding_size = size_value;
                    layout(defs_stmt->address, defs_stmt->padding_size);
                    continue;
                }

                if (auto phase_stmt = dynamic_cast<PhaseStmt*>(stmt)) {
                    if (in_phase) {
                        g_diag.error(phase_stmt->loc,
                                     "Nested PHASE not allowed");
                        g_diag.note(phase_loc, "Previous PHASE here");
                        failed = true;
                    }
                    else {
                        in_phase = true;
                        phase_loc = phase_stmt->loc;
                        phase_stmt->section = sec.get();

                        uint phase_value = 0;
                        if (!get_const_expr_value(phase_stmt->expr.get(),
                                                  phase_value, "PHASE")) {
                            failed = true;
                            break;
                        }

                        phase_pc = phase_value;
                        layout(phase_stmt->address, 0);
                    }
                    continue;
                }

                if (auto dephase_stmt = dynamic_cast<DephaseStmt*>(stmt)) {
                    if (!in_phase) {
                        g_diag.error(dephase_stmt->loc,
                                     "DEPHASE without PHASE");
                        failed = true;
                    }
                    else {
                        in_phase = false;
                        dephase_stmt->section = sec.get();
                        layout(dephase_stmt->address, 0);
                    }
                    continue;
                }
            }

            // Update section size after processing all statements
            sec->size = real_pc;
        }
    }

    return !failed;
}

static void check_jump(OpcodeStmt* opc_stmt, Patch* patch, bool& changed) {
    release_assert(patch->type == PatchType::PCrelative);
    release_assert(patch->size == 1);
    release_assert(!opc_stmt->bytes.empty());

    // check the target address is known
    if (patch->inner->value.type == ExprType::AddressRelative &&
            patch->inner->value.section == opc_stmt->section) {
        // JR to a label in the same section
        int offset = static_cast<int>(patch->inner->value.offset) -
                     static_cast<int>(opc_stmt->address + opc_stmt->bytes.size());

        if (offset >= -128 && offset <= 127) {
            // offset fits in a short jump, no change needed
            return;
        }

        // transform into a long jump
        patch->type = PatchType::Unsigned;
        patch->offset = patch->alt_offset;
        patch->size = patch->alt_size;
        opc_stmt->bytes = patch->alt_bytes;
        opc_stmt->is_short_jump = false;
        changed = true;
    }
    else {
        // either Unnown, Constant, Computed or AddressRelative to a different section
        // must be handled by the linker
    }
}

void check_jumps(Program& prog, bool& changed) {
    for (auto& mod : prog.modules) {
        for (auto& sec : mod->sections) {
            for (auto& stmt : sec->stmts) {
                // only look into opcodes
                if (auto opc_stmt = dynamic_cast<OpcodeStmt*>(stmt)) {
                    if (opc_stmt->is_short_jump) {
                        // patches if opcode is a short jump
                        for (auto& patch : opc_stmt->patches) {
                            if (patch->type == PatchType::PCrelative &&
                                    patch->size == 1) {
                                // only JR jumps (size 1), not JRE (size 2)
                                check_jump(opc_stmt, patch.get(), changed);
                            }
                        }
                    }
                }
            }
        }
    }
}
