//-----------------------------------------------------------------------------
// z80asm
// Object Module
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "cpu.h"
#include "location.h"
#include "memmap.h"
#include "symbol.h"
#include "utils.h"
#include <cstdint>
#include <vector>
using namespace std;

class Expr;
class ObjModule;
class Section;

// Patch Type

enum class PatchType {
    //@@BEGIN: patch_type
    UNDEFINED = 0,
    JR_OFFSET = 1,
    BYTE_UNSIGNED = 2,
    BYTE_SIGNED = 3,
    WORD = 4,
    WORD_BE = 5,
    DWORD = 6,
    BYTE_TO_WORD_UNSIGNED = 7,
    BYTE_TO_WORD_SIGNED = 8,
    PTR24 = 9,
    HIGH_OFFSET = 10,
    ASSIGNMENT = 11,
    JRE_OFFSET = 12,
    BYTE_TO_PTR_UNSIGNED = 13,
    BYTE_TO_PTR_SIGNED = 14,
    //@@END
};

// Patch

class Patch {
public:
    Patch(Instr* parent, PatchType patch_type, Expr* expr, int offset);
    Patch(const Patch& other) = delete;
    virtual ~Patch();
    Patch& operator=(const Patch& other) = delete;

    Instr* parent() const { return m_parent; }

    PatchType patch_type() const { return m_patch_type; }
    void set_patch_type(PatchType patch_type) { m_patch_type = patch_type; }

    Expr* expr() { return m_expr; }

    int offset() const { return m_offset; }
    void set_offset(int offset) { m_offset = offset; }

    const string& target_name() { return m_target_name; }
    void set_target_name(const string& name) { m_target_name = name; }

    int size() const;
    void resolve(int value);

private:
    Instr* m_parent{ nullptr };
    PatchType m_patch_type;
    Expr* m_expr;
    int m_offset;
    string m_target_name;
};

// Instr

class Instr {
public:
    Instr(Section* parent);
    Instr(const Instr& other) = delete;
    virtual ~Instr();
    Instr& operator=(const Instr& other) = delete;

    bool empty() const;

    Section* parent() const { return m_parent; }
    int offset() const { return m_offset; }
    void set_offset(int offset) { m_offset = offset; }
    uint8_t* data() { return m_bytes.data(); }
    int size() const { return static_cast<int>(m_bytes.size()); }
    vector<Patch*>& patches() { return m_patches; }
    const Location& location() const { return m_location; }
    void set_location(const Location& location) { m_location = location; }

    void add_byte(uint8_t byte) { m_bytes.push_back(byte & 0xFF); }
    void add_word(uint16_t word);
    void patch_byte(int index, uint8_t byte);
    void add_opcode(long long opcode);
    void add_patch(Patch* patch);
    void include_binary(const string& filename);
    void expand_jr();
    void resolve_local_exprs();

private:
    Section* m_parent{ nullptr };
    int m_offset{ 0 };
    vector<uint8_t> m_bytes;
    vector<Patch*> m_patches;
    Location m_location;

    bool resolve_local_jrs(Patch* patch);
};

// Section

class Section {
public:
    static inline const int ORG_NOT_DEFINED =
        /*@@CONFIG:ORG_NOT_DEFINED*/ -1 /*@@END*/;
    static inline const int ORG_SECTION_SPLIT =
        /*@@CONFIG:ORG_SECTION_SPLIT*/ -2 /*@@END*/;
    static inline const int DEFAULT_FILLER = 0;

    Section(ObjModule* parent, const string& name);
    Section(const Section& other) = delete;
    virtual ~Section();
    Section& operator=(const Section& other) = delete;
    void clear();

    const string& name() const { return m_name; }

    int origin() const { return m_origin; }
    void set_origin(int origin);

    bool section_split() const { return m_section_split; }
    void set_section_split(bool f) { m_section_split = f; }

    int align() const { return m_align; }
    void set_align(int align, int filler);
    void check_org_align();

    Instr* asmpc() const;
    int size() const;

    Symtab* symtab();

    Instr* add_instr();
    const vector<Instr*>& instrs() const { return m_instrs; }

    void include_binary(const string& filename);

    void expand_jrs();
    void recompute_offsets();
    void resolve_local_exprs();

private:
    ObjModule* m_parent{ nullptr };
    string m_name;
    int m_origin{ ORG_NOT_DEFINED };
    bool m_origin_defined{ false };
    bool m_origin_option{ false };
    bool m_section_split{ false };
    int m_align{ 1 };
    bool m_align_found{ false };
    vector<Instr*> m_instrs;
};

// Object Module

class ObjModule {
public:
    static inline const int OBJ_FILE_VERSION =
        /*@@CONFIG:OBJ_FILE_VERSION*/ 18 /*@@END*/;
    static inline const string OBJ_FILE_SIGNATURE =
        /*@@CONFIG:OBJ_FILE_SIGNATURE*/ "Z80RMF" /*@@END*/;
    static inline const string LIB_FILE_SIGNATURE =
        /*@@CONFIG:LIB_FILE_SIGNATURE*/ "Z80LMF" /*@@END*/;
    static inline const int SIGNATURE_SIZE =
        /*@@CONFIG:SIGNATURE_SIZE*/ 8 /*@@END*/;

    ObjModule();
    ObjModule(const ObjModule& other) = delete;
    virtual ~ObjModule();
    ObjModule& operator=(const ObjModule& other) = delete;
    void clear();

	const string& name() const { return m_name; }
	void set_name(const string& name) { m_name = name; }

    Symtab* symtab() { return &m_symtab; }
    const vector<Section*>& sections() const { return m_sections; }

    Section* cur_section() const;
    void set_cur_section(const string& name);
    Instr* asmpc() const;

    void define_global_defs();
    void define_cpu_defs(Cpu cpu_id);
    void define_arch_defs(Arch arch);
    void expand_jrs();
    void convert_global_to_extern_public();
    bool has_undefined_symbols() const;
    void resolve_local_exprs() const;

    void add_global_def(const string& name, int value = 1);
    void add_label(const string& name);
    void add_equ(const string& name, Expr* expr);
    void declare_extern(const string& name);
    void declare_public(const string& name);
    void declare_global(const string& name);

    void set_origin(int origin);
    void set_align(int align, int filler);
    void assert_(bool ok, const string& message = "");

    void set_assume(int value);
    int assume() const { return m_assume; }
    void include_binary(const string& filename);
    void call_oz(int value);
    void call_pkg(int value);

    void add_opcode_void(long long opcode);
    void add_opcode_jr(long long opcode, Expr* expr);
    void add_opcode_n(long long opcode, Expr* expr);
    void add_opcode_nn(long long opcode, Expr* expr);

    bool write_file(const string& filename) const;

private:
	string m_name;
    Symtab m_symtab;
    vector<Section*> m_sections;
    Section* m_cur_section{ nullptr };
    int m_assume{ 0 };

	class FileWriter {
	public:
		bool write_file(const string& filename);

	private:
		Memmap m_mem;
		StringTable m_str_table;
		
		static string file_signature();
		void write_signature();
		int write_exprs();
		int write_symbols();
		int write_externs();
		int write_modname();
		int write_sections();
	};
};

extern ObjModule* g_obj_module;
