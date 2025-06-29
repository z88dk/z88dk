//-----------------------------------------------------------------------------
// z80asm
// Options
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "cpu.h"
#include "obj_module.h"
#include <string>
#include <vector>
using namespace std;

class Options {
public:
    const string& progname() const { return m_progname; }
    void set_progname(const string& progname) { m_progname = progname; }

    void add_input_file(const string& filename);
    const vector<string>& input_files() const { return m_input_files; }

    bool verbose() const { return m_verbose; }
    void set_verbose(bool f = true) { m_verbose = f; }

    bool preproc_only() const { return m_preproc_only; }
    void set_preproc_only(bool f = true) { m_preproc_only = f; }

    Cpu cpu_id() const { return m_cpu_id; }
    void set_cpu_id(Cpu id) { m_cpu_id = id; }

    SwapIXIY swap_ixiy() const { return m_swap_ixiy; }
    void set_swap_ixiy(SwapIXIY swap_ixiy) { m_swap_ixiy = swap_ixiy; }

    int origin() const { return m_origin; }
    void set_origin(int origin);

    int filler() const { return m_filler; }
    void set_filler(int filler) { m_filler = filler; }

    bool parsing_command_line() const { return m_parsing_command_line; }
    void set_parsing_command_line(bool f = true) { m_parsing_command_line = f; }

private:
    string m_progname;
    vector<string> m_input_files;
    bool m_verbose{ false };
    bool m_preproc_only{ false };
    Cpu m_cpu_id{ Cpu::Z80 };
    SwapIXIY m_swap_ixiy{ SwapIXIY::NO_SWAP };
    int m_origin{ Section::ORG_NOT_DEFINED };
    int m_filler{ Section::DEFAULT_FILLER };
    bool m_parsing_command_line{ true };
};

extern Options* g_options;
