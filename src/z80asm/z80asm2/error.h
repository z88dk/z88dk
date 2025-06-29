//-----------------------------------------------------------------------------
// z80asm
// Error message output and counting
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include <string>
using namespace std;

class Error {
public:
    int count() const { return m_count; }

    void error_align_redefined() { error("align redefined"); }
    void error_assembly_failed(const string& filename) { error("assembly failed for file", filename); }
    void error_assertion_failed(const string& message) { error("assertion failed", message); }
    void error_constant_expression_expected() { error("constant expression expected"); }
    void error_division_by_zero() { error("division by zero"); }
    void error_duplicate_definition(const string& name) { error("duplicate definition", name); }
    void error_expected_comma() { error("expected ','"); }
    void error_expected_eol() { error("expected end of line"); }
    void error_expected_equal() { error("expected '='"); }
    void error_expected_ident() { error("expected identifier"); }
    void error_extra_operands(const string& op) { error("extra operands", op); }
    void error_insufficient_operands(const string& op) { error("insufficient operands", op); }
    void error_int_range(const string& hex_value) { error("integer out of range", hex_value); }
    void error_invalid_char(char c) { error("invalid character", std::to_string(static_cast<int>(c))); }
    void error_invalid_cpu(const string& cpu_name) { error("invalid CPU specified", cpu_name); }
    void error_invalid_escape_char(char c) { error("invalid escape character", string(1, c)); }
    void error_invalid_option(const string& option) { error("invalid option", option); }
    void error_invalid_quoted_char() { error("invalid quoted character"); }
    void error_mismatched_ternary() { error("mismatched ternary operator"); }
    void error_no_input_files() { error("no input files specified"); }
    void error_open_file(const string& filename) { error("file open", filename); }
    void error_org_not_aligned() { error("origin not aligned"); }
    void error_origin_redefined() { error("origin redefined"); }
    void error_recursive_evaluation(const string& name) { error("recursive evaluation", name); }
    void error_recursive_include(const string& filename) { error("recursive include", filename); }
    void error_syntax() { error("syntax error"); }
    void error_unbalanced_parens() { error("unbalanced parentheses"); }
    void error_undefined_symbol(const string& name) { error("undefined symbol", name); }
    void error_unterminated_string() { error("unterminated string"); }
    void warning_int_range(const string& hex_value) { error("integer out of range", hex_value); }

private:
    int m_count{ 0 };
    void error(const string& message, const string& arg = "");
    void warning(const string& message, const string& arg = "");
    void output_message(const string& prefix, const string& message, const string& arg = "");
};

extern Error* g_error;

