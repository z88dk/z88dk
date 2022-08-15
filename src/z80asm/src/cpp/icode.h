//-----------------------------------------------------------------------------
// z80asm
// intermediate code
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <cinttypes>
#include <list>
#include <memory>
#include <string>
#include <vector>
using namespace std;

class PatchExpr;
class Section;
class Group;

class Icode {
public:
	enum class Type {
		Label,
	};

	Icode(shared_ptr<Section> parent);
	shared_ptr<Icode> make_label(const string& name);

	shared_ptr<Section> parent() { return m_parent.lock(); }

	size_t asmpc() const { return m_asmpc; }
	void set_asmpc(size_t n);
	bool asmpc_changed() const { return m_asmpc != m_prev_asmpc; }

	size_t size() const { return m_size; }

	const vector<uint8_t>& bytes() const { return m_bytes; }
	const vector<shared_ptr<PatchExpr>> patches() const { return m_patches; }

	const string& filename() const { return m_filename; }
	int line_num() const { return m_line_num; }

private:
	static inline const size_t UndefinedAsmpc = static_cast<size_t>(-1);

	weak_ptr<Section>	m_parent;
	size_t	m_asmpc{ UndefinedAsmpc };
	size_t	m_prev_asmpc{ UndefinedAsmpc };
	size_t	m_size{ 0 };
	vector<uint8_t> m_bytes;
	vector<shared_ptr<PatchExpr>> m_patches;
	string	m_filename;
	int		m_line_num{ 0 };
};

class Section {
public:
	Section(const string& name, shared_ptr<Group> parent);

	void push_back(shared_ptr<Icode> node);

	shared_ptr<Group> parent() { return m_parent.lock(); }
	const list<shared_ptr<Icode>>& nodes() const { return m_nodes; }

	size_t asmpc() const;

private:
	string	m_name;
	weak_ptr<Group>	m_parent;
	list<shared_ptr<Icode>> m_nodes;

};
