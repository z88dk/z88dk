//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "lexer_tokens.h"
#include "string_interner.h"
#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

// float format
enum class FloatFormat : uint8_t {
#define X(type)		type,
#include "zfloat.def"
#undef X
};

std::string to_string(FloatFormat fmt);
bool float_format_lookup(std::string_view str, FloatFormat& out_fmt);
std::vector<StringInterner::Id> float_formats();
std::string float_formats_message();

std::vector<StringInterner::Id> float_format_all_defines();
StringInterner::Id float_format_define(FloatFormat float_id);

bool parse_float_expr(double& out_value, ParseLine& pline);
bool parse_float_expr_list(std::vector<double>& out_list, ParseLine& pline);

std::vector<uint8_t> encode_float(double value, FloatFormat fmt);
std::vector<uint8_t> encode_float_list(const std::vector<double>& values,
                                       FloatFormat fmt);

std::vector<uint8_t> float_to_genmath(double value);
std::vector<uint8_t> float_to_math48(double value);
std::vector<uint8_t> float_to_z80(double value);
std::vector<uint8_t> float_to_ieee16(double value);
std::vector<uint8_t> float_to_ieee32(double value);
std::vector<uint8_t> float_to_ieee64(double value);
std::vector<uint8_t> float_to_zx(double value);
std::vector<uint8_t> float_to_zx81(double value);
std::vector<uint8_t> float_to_z88(double value);
std::vector<uint8_t> float_to_mbfs(double value);
std::vector<uint8_t> float_to_mbf40(double value);
std::vector<uint8_t> float_to_mbf64(double value);
std::vector<uint8_t> float_to_am9511(double value);
