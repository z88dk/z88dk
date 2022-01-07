//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "asmerrors.h"
#include "if.h"
#include "utils.h"
#include "float.h"
#include <iostream>
#include <string>
using namespace std;

// global data
Errors g_errors;

static const char* err_messages[] = {
#	define X(code, message)		message,
#	include "asmerrors.def"
};

Errors::Errors()
	: m_count(0) {
	clear();
}

void Errors::clear() {
	m_filename.clear();
	m_line_num = 0;
	m_source_line.clear();
	m_expanded_line.clear();
}

void Errors::set_location(const string& filename, int line_num) {
	m_filename = filename;
	m_line_num = line_num;
	m_source_line.clear();
	m_expanded_line.clear();
}

void Errors::set_source_line(const string& line) {
	m_source_line = line;
	m_expanded_line.clear();
}

void Errors::set_expanded_line(const string& line) {
	m_expanded_line = line;
}

void Errors::error(ErrCode code, const string& arg) {
	m_count++;
	show_error("error", code, arg);
}

void Errors::warning(ErrCode code, const string& arg) {
	show_error("warning", code, arg);
}

void Errors::show_error(const string& prefix, ErrCode code, const string& arg) {
	// error message
	if (!m_filename.empty()) {
		cerr << m_filename << ":";
		if (m_line_num)
			cerr << m_line_num << ":";
		cerr << " ";
	}
	cerr << prefix << ": " << err_messages[static_cast<int>(code)];
	if (!arg.empty())
		cerr << ": " << arg;
	cerr << endl;

	// source line - remove extra spaces
	m_source_line = str_remove_extra_blanks(m_source_line);
	m_expanded_line = str_remove_extra_blanks(m_expanded_line);

	if (!m_source_line.empty()) {
		cerr << "  ^---- " << m_source_line << endl;

		// only show expanded line if it differs from source, ignoring blanks
		if (!m_expanded_line.empty())
			if (str_remove_all_blanks(m_source_line) != str_remove_all_blanks(m_expanded_line))
				cerr << "      ^---- " << m_expanded_line << endl;
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
		g_errors.set_location(filename, line_num);
	else
		g_errors.clear();
}

const char* get_error_filename() {
	string filename = g_errors.filename();
	return spool_add(filename.c_str());
}

int get_error_line_num() {
	return g_errors.line_num();
}

void set_error_source_line(const char* line) {
	g_errors.set_source_line(line);
}

void set_error_expanded_line(const char* line) {
	g_errors.set_expanded_line(line);
}

//-----------------------------------------------------------------------------
void error_file_open(const char* filename) {
	g_errors.error(ErrCode::FileOpen, filename);
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

void error_syntax() {
	g_errors.error(ErrCode::Syntax);
}

void error_syntax_expr() {
	g_errors.error(ErrCode::SyntaxExpr);
}

void error_invalid_float_format() {
	g_errors.error(ErrCode::InvalidFloatFormat, FloatFormat::get_formats());
}

void error_segment_overflow() {
	g_errors.error(ErrCode::SegmentOverflow);
}

void warn_org_ignored(const char* filename, const char* section) {
	g_errors.warning(ErrCode::OrgIgnored,
		string("file ") + string(filename) + ", section " + string(section));
}

void error_org_redefined() {
	g_errors.error(ErrCode::OrgRedefined);
}

void error_int_range(int value) {
	g_errors.error(ErrCode::IntRange, int_to_hex(value));
}

void warn_int_range(int value) {
	g_errors.warning(ErrCode::IntRange, int_to_hex(value));
}

void error_not_obj_file(const char* filename) {
	g_errors.error(ErrCode::NotObjFile, filename);
}

void error_not_lib_file(const char* filename) {
	g_errors.error(ErrCode::NotLibFile, filename);
}

void error_no_src_file() {
	g_errors.error(ErrCode::NoSrcFile);
}

void error_illegal_option(const char* option) {
	g_errors.error(ErrCode::IllegalOption, option);
}

void error_glob_no_files(const char* pattern) {
	g_errors.error(ErrCode::GlobNoFiles, pattern);
}

void warn_expr_in_parens() {
	g_errors.warning(ErrCode::ExprInParens);
}

void error_string_too_long() {
	g_errors.error(ErrCode::StrTooLong);
}

void error_division_by_zero() {
	g_errors.error(ErrCode::DivisionByZero);
}

void error_missing_block() {
	g_errors.error(ErrCode::MissingBlock);
}

void error_missing_close_block() {
	g_errors.error(ErrCode::MissingCloseBlock);
}

void error_undefined_symbol(const char* name) {
	g_errors.error(ErrCode::UndefinedSymbol, name);
}

void error_illegal_ident() {
	g_errors.error(ErrCode::IllegalIdent);
}

void error_jr_not_local() {
	g_errors.error(ErrCode::JrNoLocal);
}

void error_expected_const_expr() {
	g_errors.error(ErrCode::ConstExprExpected);
}

void error_symbol_redecl(const char* name) {
	g_errors.error(ErrCode::SymbolRedecl, name);
}

void error_expr_recursion() {
	g_errors.error(ErrCode::ExprRecursion);
}

void error_align_redefined() {
	g_errors.error(ErrCode::AlignRedefined);
}

void error_org_not_aligned(int origin, int align) {
	g_errors.error(ErrCode::OrgNotAligned,
		"origin=" + int_to_hex(origin) + ", align=" + int_to_hex(align));
}

void error_invalid_org_option(const char* origin_text) {
	g_errors.error(ErrCode::InvalidOrgOption, origin_text);
}

void error_invalid_define_option(const char* define_text) {
	g_errors.error(ErrCode::InvalidDefineOption, define_text);
}

void error_invalid_org(int origin) {
	g_errors.error(ErrCode::InvalidOrg, int_to_hex(origin));
}

void error_invalid_filler_option(const char* filler_text) {
	g_errors.error(ErrCode::InvalidFillerOption, filler_text);
}

void error_obj_file_version(const char* filename, int found_version, int expected_version) {
	g_errors.error(ErrCode::ObjFileVersion,
		"file=" + string(filename) +
		", found=" + to_string(found_version) +
		", expected=" + to_string(expected_version));
}

void error_lib_file_version(const char* filename, int found_version, int expected_version) {
	g_errors.error(ErrCode::LibFileVersion,
		"file=" + string(filename) +
		", found=" + to_string(found_version) +
		", expected=" + to_string(expected_version));
}

void error_dma_base_register_illegal(int value) {
	g_errors.error(ErrCode::DMABaseRegisterIllegal, int_to_hex(value));
}

void error_dma_missing_args() {
	g_errors.error(ErrCode::DMAMissingArgs);
}

void error_dma_extra_args() {
	g_errors.error(ErrCode::DMAExtraArgs);
}

void error_dma_illegal_port_A_timing() {
	g_errors.error(ErrCode::DMAIllegalPortATiming);
}

void error_dma_illegal_port_B_timing() {
	g_errors.error(ErrCode::DMAIllegalPortBTiming);
}

void error_dma_unsupported_interrupts() {
	g_errors.error(ErrCode::DMAUnsupportedInterrupts);
}

void warn_dma_unsupported_features() {
	g_errors.warning(ErrCode::DMAUnsupportedFeatures);
}

void warn_dma_unsupported_command() {
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

void warn_dma_half_cycle_timing() {
	g_errors.warning(ErrCode::DMAHalfCycleTiming);
}

void warn_dma_ready_signal_unsupported() {
	g_errors.warning(ErrCode::DMAUnsupportedReadySignal);
}

void error_cmd_failed(const char* cmd) {
	g_errors.error(ErrCode::CmdFailed, cmd);
}

void error_assert_failed() {
	g_errors.error(ErrCode::AssertFailed);
}
