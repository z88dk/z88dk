//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_keywords.h"
#include "source_loc.h"
#include "string_interner.h"
#include <string>
#include <string_view>
#include <utility>
#include <vector>

enum class CPU {
#define X(code, id, name, defines)   id = code,
#include "cpu.def"
};

std::string to_string(CPU cpu_id);
bool cpu_lookup(std::string_view name, CPU& out_cpu_id);
std::vector<StringInterner::Id> cpu_names();

std::vector<StringInterner::Id> cpu_all_defines();
std::vector<StringInterner::Id> cpu_defines(CPU cpu_id);

bool cpu_set_adl_mode(CPU& in_out_cpu_id, bool adl);

Keyword cpu_invert_flag_condition(Keyword kw);
void swap_ix_iy(std::string& inout_text, Keyword& inout_kw);

// Z88
bool compute_z88_call_oz(std::vector<std::pair<Keyword, int>>& out_def_val_data,
                         const std::vector<std::pair<int, SourceLoc>>& val_loc_data);
bool compute_z88_call_pkg(std::vector<std::pair<Keyword, int>>&
                          out_def_val_data,
                          const std::vector<std::pair<int, SourceLoc>>& val_loc_data,
                          CPU cpu_id, Keyword kw, const SourceLoc& kw_loc);
bool compute_z88_fpp(std::vector<std::pair<Keyword, int>>& out_def_val_data,
                     const std::vector<std::pair<int, SourceLoc>>& val_loc_data);

// TI83
bool compute_ti83_invoke_prefix(std::string& out_instr_prefix,
                                CPU cpu_id, Keyword kw, const SourceLoc& kw_loc);

// Spectrum Next copper unit
bool compute_z80n_cu_wait(std::vector<std::pair<Keyword, int>>& def_val_data,
                          CPU cpu_id,
                          int ver, int hor,
                          const SourceLoc& kw_loc,
                          const SourceLoc& ver_loc,
                          const SourceLoc& hor_loc);
bool compute_z80n_cu_move(std::vector<std::pair<Keyword, int>>& def_val_data,
                          CPU cpu_id,
                          int reg, int val,
                          const SourceLoc& kw_loc,
                          const SourceLoc& reg_loc,
                          const SourceLoc& val_loc);
bool compute_z80n_cu_stop(std::vector<std::pair<Keyword, int>>& def_val_data,
                          CPU cpu_id, const SourceLoc& kw_loc);
bool compute_z80n_cu_nop(std::vector<std::pair<Keyword, int>>& def_val_data,
                         CPU cpu_id, const SourceLoc& kw_loc);

// Spectrum Next DMA unit
bool compute_z80n_dma(std::vector<std::pair<Keyword, int>>& out_def_val_data,
                      CPU cpu_id,
                      const std::vector<std::pair<int, SourceLoc>>& val_loc_data,
                      Keyword kw,
                      const SourceLoc& kw_loc, const SourceLoc& eol_loc);

// Spectrum Next MMU unit
bool compute_z80n_mmu_N(std::vector<std::pair<Keyword, int>>& out_def_val_data,
                        CPU cpu_id, int slot, int page,
                        Keyword kw, const SourceLoc& kw_loc,
                        const SourceLoc& slot_loc, const SourceLoc& page_loc);
bool compute_z80n_mmu_A(std::vector<std::pair<Keyword, int>>& out_def_val_data,
                        CPU cpu_id, int slot,
                        Keyword kw, const SourceLoc& kw_loc,
                        const SourceLoc& slot_loc);
