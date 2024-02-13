//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "args.h"
#include "errors.h"
#include "float.h"
#include "if.h"
#include "strpool.h"
#include "utils.h"
#include "xassert.h"
#include "z80asm_defs.h"
#include <iostream>
#include <string>
using namespace std;

// global data
Errors g_errors;

static const char* err_messages[] = {
#	define X(code, message)		message,
#	include "errors.def"
};

Location::Location(const string& filename, int line_num,
	const string& source_line, const string& expanded_line)
	: m_filename(filename), m_line_num(line_num)
	, m_source_line(source_line), m_expanded_line(expanded_line) {
}

void Location::clear() {
	m_filename.clear();
	m_line_num = 0;
	m_line_inc = 1;
	m_source_line.clear();
	m_expanded_line.clear();
    m_is_c_source = false;
}

//-----------------------------------------------------------------------------

Errors::Errors()
	: m_count(0) {
	m_locations.emplace_back();		// keep always one element in vector
}

void Errors::clear() {
	xassert(!m_locations.empty());
	Location& location = m_locations.back();

	location.clear();
}

void Errors::set_location(const Location& location) {
	xassert(!m_locations.empty());
	m_locations.back() = location;
}

void Errors::set_file_location(const string& filename, int line_num) {
	xassert(!m_locations.empty());
	Location& location = m_locations.back();

    location.set_filename(filename);
	location.set_line_num(line_num);
    location.set_source_line("");
}

void Errors::set_source_line(const string& line) {
	xassert(!m_locations.empty());
	Location& location = m_locations.back();

    location.set_source_line(line);
}

void Errors::set_expanded_line(const string& line) {
	xassert(!m_locations.empty());
	Location& location = m_locations.back();

    location.set_expanded_line(line);
}

void Errors::error(ErrCode code, const string& arg) {
	m_count++;
	show_error("error", code, arg);
}

void Errors::warning(ErrCode code, const string& arg) {
	show_error("warning", code, arg);
}

void Errors::push_location(const Location& location) {
	m_locations.push_back(location);
}

void Errors::pop_location() {
	if (m_locations.size() > 1)
		m_locations.pop_back();
	else
		clear();
}

void Errors::show_error(const string& prefix, ErrCode code, const string& arg_) {
	xassert(!m_locations.empty());
	Location& location = m_locations.back();

    string arg = str_chomp(arg_);

	// error message
	if (!location.filename().empty()) {
		cerr << location.filename() << ":";
		if (location.line_num())
			cerr << location.line_num() << ":";
		cerr << " ";
	}
	cerr << prefix << ": " << err_messages[static_cast<int>(code)];
	if (!arg.empty())
		cerr << ": " << arg;
	cerr << endl;

	// source line - remove extra spaces
	string striped_source_line = str_remove_extra_blanks(location.source_line());
	string striped_expanded_line = str_remove_extra_blanks(location.expanded_line());

	if (!striped_source_line.empty()) {
		cerr << "  ^---- " << striped_source_line << endl;

		// only show expanded line if it differs from source, ignoring blanks
		if (!striped_expanded_line.empty())
			if (str_remove_all_blanks(striped_source_line)
				!= str_remove_all_blanks(striped_expanded_line))
				cerr << "      ^---- " << striped_expanded_line << endl;
	}
}

//-----------------------------------------------------------------------------
// global functions to interface to C
//-----------------------------------------------------------------------------
int get_num_errors() {
	return g_errors.count();
}

void clear_error_location() {
	g_errors.clear();
}

void set_error_location(const char* filename, int line_num) {
	if (filename)
		g_errors.set_file_location(filename, line_num);
	else
		g_errors.clear();
}

const char* get_error_filename() {
	string filename = g_errors.location().filename();
	return spool_add(filename.c_str());
}

int get_error_line_num() {
	return g_errors.location().line_num();
}

void set_error_source_line(const char* line) {
	g_errors.set_source_line(line);
}

void set_error_expanded_line(const char* line) {
	g_errors.set_expanded_line(line);
}

//-----------------------------------------------------------------------------
void error_file_not_found(const char* filename) {
	g_errors.error(ErrCode::FileNotFound, filename);
}

void error_file_open(const char* filename) {
	g_errors.error(ErrCode::FileOpen, filename);
	perror(filename);
}

void error_file_rename(const char* filename) {
	g_errors.error(ErrCode::FileRename, filename);
	perror(filename);
}

void error_duplicate_definition(const char* name) {
	g_errors.error(ErrCode::DuplicateDefinition, name);
}

void error_duplicate_definition_module(const char* modulename, const char* name) {
	g_errors.error(ErrCode::DuplicateDefinition,
		string(modulename) + "::" + string(name));
}

void error_missing_quote() {
	g_errors.error(ErrCode::MissingQuote);
}

void error_invalid_char_const() {
	g_errors.error(ErrCode::InvalidCharConst);
}

void error_syntax_error() {
	g_errors.error(ErrCode::Syntax);
}

void error_syntax_error_in_expression() {
	g_errors.error(ErrCode::SyntaxExpr);
}

void error_segment_overflow() {
	g_errors.error(ErrCode::SegmentOverflow);
}

void warning_org_ignored(const char* filename, const char* section) {
	g_errors.warning(ErrCode::OrgIgnored,
		string("file ") + string(filename) + ", section " + string(section));
}

void error_org_redefined() {
	g_errors.error(ErrCode::OrgRedefined);
}

void error_integer_range(int value) {
	g_errors.error(ErrCode::IntRange, int_to_hex(value, 2));
}

void warning_integer_range(int value) {
	g_errors.warning(ErrCode::IntRange, int_to_hex(value, 2));
}

void error_invalid_object_file(const char* filename) {
	g_errors.error(ErrCode::NotObjFile, filename);
}

void error_invalid_library_file(const char* filename) {
	g_errors.error(ErrCode::NotLibFile, filename);
}

void warning_expr_in_parens() {
	g_errors.warning(ErrCode::ExprInParens);
}

void error_string_longer_than_reserved_space() {
	g_errors.error(ErrCode::StrTooLong);
}

void error_division_by_zero() {
	g_errors.error(ErrCode::DivisionByZero);
}

void error_missing_bracket_block() {
	g_errors.error(ErrCode::MissingBlock);
}

void error_bracket_block_not_closed() {
	g_errors.error(ErrCode::MissingCloseBlock);
}

void error_undefined_symbol(const char* name) {
	g_errors.error(ErrCode::UndefinedSymbol, name);
}

void error_illegal_identifier() {
	g_errors.error(ErrCode::IllegalIdent);
}

void error_constant_expression_expected() {
	g_errors.error(ErrCode::ConstExprExpected);
}

void error_symbol_redeclaration(const char* name) {
	g_errors.error(ErrCode::SymbolRedeclaration, name);
}

void error_recursive_expression() {
	g_errors.error(ErrCode::ExprRecursion);
}

void error_align_redefined() {
	g_errors.error(ErrCode::AlignRedefined);
}

void error_org_not_aligned(int origin, int align) {
	g_errors.error(ErrCode::OrgNotAligned,
		"origin=" + int_to_hex(origin, 4) + ", align=" + int_to_hex(align, 2));
}

void error_invalid_org(int origin) {
	g_errors.error(ErrCode::InvalidOrg, int_to_hex(origin, 4));
}

void error_invalid_object_file_version(const char* filename, int found_version, int expected_version) {
	g_errors.error(ErrCode::ObjFileVersion,
		"file=" + string(filename) +
		", found=" + to_string(found_version) +
		", expected=" + to_string(expected_version));
}

void error_invalid_library_file_version(const char* filename, int found_version, int expected_version) {
	g_errors.error(ErrCode::LibFileVersion,
		"file=" + string(filename) +
		", found=" + to_string(found_version) +
		", expected=" + to_string(expected_version));
}

void error_dma_base_register_byte_illegal(int value) {
	g_errors.error(ErrCode::DMABaseRegisterIllegal, int_to_hex(value, 2));
}

void error_dma_missing_register_group_members() {
	g_errors.error(ErrCode::DMAMissingArgs);
}

void error_dma_too_many_arguments() {
	g_errors.error(ErrCode::DMAExtraArgs);
}

void error_dma_illegal_port_a_timing() {
	g_errors.error(ErrCode::DMAIllegalPortATiming);
}

void error_dma_illegal_port_b_timing() {
	g_errors.error(ErrCode::DMAIllegalPortBTiming);
}

void error_dma_does_not_support_interrupts() {
	g_errors.error(ErrCode::DMAUnsupportedInterrupts);
}

void warning_dma_does_not_support_some_features() {
	g_errors.warning(ErrCode::DMAUnsupportedFeatures);
}

void warning_dma_does_not_implement_this_command() {
	g_errors.warning(ErrCode::DMAUnsupportedCommand);
}

void error_dma_illegal_mode() {
	g_errors.error(ErrCode::DMAIllegalMode);
}

void error_dma_illegal_command() {
	g_errors.error(ErrCode::DMAIllegalCommand);
}

void error_dma_illegal_read_mask() {
	g_errors.error(ErrCode::DMAIllegalReadMask);
}

void warning_dma_does_not_support_half_cycle_timing() {
	g_errors.warning(ErrCode::DMAHalfCycleTiming);
}

void warning_dma_does_not_support_ready_signals() {
	g_errors.warning(ErrCode::DMAUnsupportedReadySignal);
}

void error_command_failed(const char* cmd) {
	g_errors.error(ErrCode::CmdFailed, cmd);
}

void error_assertion_failed() {
	g_errors.error(ErrCode::AssertFailed);
}

void error_incompatible_cpu(const char* filename, cpu_t got_cpu_id) {
    ostringstream error;
    const char* cpu_str = cpu_name(got_cpu_id);
    if (cpu_str == NULL)
        error_illegal_cpu(filename, got_cpu_id);
    else {
        error << "file " << filename << " compiled for " << cpu_str
            << ", incompatible with " << cpu_name(option_cpu());
        g_errors.error(ErrCode::CPUIncompatible, error.str());
    }
}

void error_illegal_cpu(const char* filename, cpu_t got_cpu_id) {
    ostringstream error;
    error << "file " << filename << ", cpu_id = " << got_cpu_id;
    g_errors.error(ErrCode::CPUInvalid, error.str());
}

static const char* ixiy_to_string(swap_ixiy_t swap_ixiy) {
    switch (swap_ixiy) {
    case IXIY_NO_SWAP: return "(no option)"; 
    case IXIY_SWAP: return "-IXIY";
    case IXIY_SOFT_SWAP: return "-IXIY-soft";
    default: xassert(0); return "";
    }
}

void error_incompatible_ixiy(const char* filename, swap_ixiy_t swap_ixiy) {
    ostringstream error;
    error << "file " << filename << " compiled with " << ixiy_to_string(swap_ixiy)
        << ", incompatible with " << ixiy_to_string(g_args.swap_ixiy());
    g_errors.error(ErrCode::IXIYIncompatible, error.str());
}

void error_date_and_mstar_incompatible() {
    g_errors.error(ErrCode::DateAndMstarIncompatible);
}
