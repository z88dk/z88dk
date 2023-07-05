//-----------------------------------------------------------------------------
// z80asm
// macro symbols
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "scan.h"
#include <memory>
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

class Macro {
public:
    Macro(const string& name, const ScannedLine& body = ScannedLine());

	const string& name() const { return m_name; }
	const vector<string>& args() const { return m_args; }
	const ScannedLine& body() const { return m_body; }
	bool is_expanding() const { return m_is_expanding; }
	void set_expanding(bool f) { m_is_expanding = f; }

	void push_arg(const string& arg);
    void push_body(const ScannedLine& other) { m_body.append(other); }

private:
	string			m_name;
	vector<string>	m_args;
    ScannedLine		m_body;
	bool			m_is_expanding{ false };
};

class Macros {
public:
	Macros(Macros* parent = nullptr);

	void add(shared_ptr<Macro> macro);
	void remove(const string& name);
	void clear();

	shared_ptr<Macro> find(const string& name) const;
	shared_ptr<Macro> find_all(const string& name) const;

	auto begin() { return m_table.begin(); }
	auto end() { return m_table.end(); }

private:
	Macros* m_parent;
	unordered_map<string, shared_ptr<Macro>> m_table;
};

