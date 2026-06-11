//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_keywords.h"
#include "source_loc.h"
#include <string>
#include <string_view>
#include <utility>
#include <vector>

enum class CPU {
#define X(code, id, name, defines)   id = code,
#include "cpu.def"
};

CPU cpu_lookup(std::string_view name);
std::string cpu_name(CPU cpu_id);
std::vector<std::string> cpu_names();
std::vector<std::string> cpu_all_defines();
std::vector<std::string> cpu_defines(CPU cpu_id);
bool cpu_set_adl_mode(CPU& in_out_cpu_id, bool adl);

Keyword cpu_invert_flag_condition(Keyword kw);
void swap_ix_iy(std::string& inout_text, Keyword& inout_kw);

// Spectrum Next copper unit
bool compute_cu_wait_value(int& out_value,
                           CPU cpu_id,
                           int ver, int hor,
                           const SourceLoc& kw_loc,
                           const SourceLoc& ver_loc,
                           const SourceLoc& hor_loc);
bool compute_cu_move_value(int& out_value,
                           CPU cpu_id,
                           int reg, int val,
                           const SourceLoc& kw_loc,
                           const SourceLoc& reg_loc,
                           const SourceLoc& val_loc);
bool compute_cu_stop_value(int& out_value, CPU cpu_id, const SourceLoc& kw_loc);
bool compute_cu_nop_value(int& out_value, CPU cpu_id, const SourceLoc& kw_loc);

// Spectrum Next DMA unit
bool compute_dma_data(std::vector<std::pair<int, int>>& out_size_val_data,
                      CPU cpu_id,
                      const std::vector<std::pair<int, SourceLoc>>& val_loc_data,
                      Keyword kw, 
                      const SourceLoc& kw_loc, const SourceLoc& eol_loc);
