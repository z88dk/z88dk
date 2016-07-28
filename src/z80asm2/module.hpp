//-----------------------------------------------------------------------------
// Store one compiled module
// Copyright (c) Paulo Custodio, 2015-2016
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#ifndef MODULE_HPP
#define MODULE_HPP

#include <string>
#include <vector>
#include <memory>

#if 0
#include "ntree.hpp"
#include "smart_ptr.hpp"

struct expr_node_t {
	const char*	type;			// operand char ("+", "-", "?:", ...), "N" for number, "V" for variable
	int			value;			// value for type 'N'
	std::string	name;			// name for type 'V'

	explicit expr_node_t(const char *type_) : type(type_), value(0), name("") {}
	explicit expr_node_t(int value_) : type("N"), value(value_), name("") {}
	explicit expr_node_t(const std::string& name_) : type("V"), value(0), name(name_) {}
};

typedef stlplus::smart_ptr< stlplus::ntree< expr_node_t > > expr_t;

enum instr_type_t {
	opc_void, opc_nn
};

struct instr_t
{
	instr_t(unsigned file_id_ = 0, unsigned line_nr_ = 0, instr_type_t	type_ = opc_void, unsigned opcode_ = 0, unsigned t_states_ = 0)
		: file_id(file_id_), line_nr(line_nr_), type(type_), opcode(opcode_), t_states(t_states_) {}

	unsigned		file_id;
	unsigned		line_nr;
	instr_type_t	type;
	unsigned		opcode;
	unsigned		t_states;
};
#endif

class Module
{
public:
	// init with source or object file nanme
	Module(const std::string& filename);

	const std::string & folder()		const { return m_folder; }
	const std::string & basename()		const { return m_basename; }
	const std::string & filebase()		const { return m_filebase; }
	const std::string & asm_filename()	const { return m_asm_filename; }
	const std::string & obj_filename()	const { return m_obj_filename; }
	const std::string & source_filename(unsigned file_id) const { return file_id == 0 ? m_asm_filename : m_files[file_id]; }

	bool parse();
	bool parse_include(std::string filename);
#if 0
	void add_instr(instr_t instr) { m_instrs.push_back(instr); }
#endif

private:
	std::string m_folder;			// module folder
	std::string m_basename;			// module basename
	std::string m_filebase;			// module folder and basename without extension
	std::string m_asm_filename;		// assembly source file
	std::string m_obj_filename;		// object file

	std::vector<std::string>	m_files;		// list of read files, to use as an index in instrs list
	std::vector<unsigned>		m_files_stack;	// current input stack, to check for recursive includes

#if 0
	std::vector<instr_t>		m_instrs;
#endif

	bool recursive_include(const std::string& filename);
	bool parse_read_file(unsigned file_id);
};

#endif /* ndef MODULE_HPP */
