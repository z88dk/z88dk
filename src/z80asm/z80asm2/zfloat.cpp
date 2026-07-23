//-----------------------------------------------------------------------------
// Z80 assembler
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "diag.h"
#include "lexer_tokens.h"
#include "release_assert.h"
#include "string_utils.h"
#include "strings.h"
#include "zfloat.h"
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <iterator>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>

//-----------------------------------------------------------------------------
// FloatFormat
//-----------------------------------------------------------------------------

static constexpr std::string_view float_formats_lu_table[] = {
#define X(type)		# type,
#include "zfloat.def"
#undef X
};

std::string to_string(FloatFormat fmt) {
    return std::string(float_formats_lu_table[static_cast<size_t>(fmt)]);
}

std::string_view to_view(FloatFormat fmt) {
    return float_formats_lu_table[static_cast<size_t>(fmt)];
}

bool float_format_lookup(std::string_view str, FloatFormat& out_fmt) {
    static const std::unordered_map<std::string_view, FloatFormat> lu_table = {
#define X(type)		{ # type, FloatFormat::type },
#include "zfloat.def"
#undef X
    };

    auto it = lu_table.find(str);
    if (it == lu_table.end()) {
        return false;
    }
    else {
        out_fmt = it->second;
        return true;
    }
}

std::vector<std::string_view> float_formats() {
    static const std::vector<std::string_view> formats = []() {
        std::vector<std::string_view> v;
        v.reserve(std::size(float_formats_lu_table));
        for (auto s : float_formats_lu_table) {
            v.push_back(s);
        }
        std::sort(v.begin(), v.end());
        return v;
    }
    ();
    return formats;
}

std::string float_formats_message() {
    std::string valid_formats;
    for (const auto& name : float_formats()) {
        if (!valid_formats.empty()) {
            valid_formats += ", ";
        }
        valid_formats += std::string(name);
    }

    std::string message = "Valid float formats are: " + valid_formats;
    return message;
}

std::vector<std::string> float_format_all_defines() {
    std::vector<std::string> defines;
    defines.reserve(std::size(float_formats_lu_table));

    for (const auto& fmt : float_formats_lu_table) {
        FloatFormat float_id = static_cast<FloatFormat>(
                                   std::distance(float_formats_lu_table, &fmt));
        std::string define_name = float_format_define(float_id);
        defines.push_back(define_name);
    }
    return defines;
}

std::string float_format_define(FloatFormat float_id) {
    std::string define_name = to_upper("__FLOAT_" + to_string(float_id) + "__");
    return define_name;
}

//-----------------------------------------------------------------------------
// Parser and expression evaluation
//-----------------------------------------------------------------------------

struct ParseState {
    ParseLine& pline;
    bool error = false;

    ParseState(ParseLine& pline_)
        : pline(pline_) {}
};

static double parse_expr(ParseState& ps);
static double parse_addition(ParseState& ps);
static double parse_multiplication(ParseState& ps);
static double parse_power(ParseState& ps);
static double parse_unary(ParseState& ps);
static double parse_primary(ParseState& ps);
static double parse_func(ParseState& ps, double(*f)(double));
static double parse_func2(ParseState& ps, double(*f)(double, double));

static double parse_expr(ParseState& ps) {
    // For now, just support a single float literal token
    if (ps.pline.eol()) {
        ps.pline.error("Expected float expression");
        ps.error = true;
        return 0.0;
    }

    return parse_addition(ps);
}

static double parse_addition(ParseState& ps) {
    double a = parse_multiplication(ps);
    if (ps.error) {
        return 0.0;
    }

    while (ps.pline.peek().type == TokenType::Plus
            || ps.pline.peek().type == TokenType::Minus) {
        TokenType op = ps.pline.peek().type;
        ps.pline.advance();

        double b = parse_multiplication(ps);
        if (ps.error) {
            return 0.0;
        }

        if (op == TokenType::Plus) {
            a += b;
        }
        else {
            a -= b;
        }
    }
    return a;
}

static double parse_multiplication(ParseState& ps) {
    double a = parse_power(ps);
    if (ps.error) {
        return 0.0;
    }

    while (ps.pline.peek().type == TokenType::Multiply
            || ps.pline.peek().type == TokenType::Divide) {
        TokenType op = ps.pline.peek().type;
        ps.pline.advance();

        SourceLoc b_loc = ps.pline.peek().loc;
        double b = parse_power(ps);
        if (ps.error) {
            return 0.0;
        }

        if (op == TokenType::Multiply) {
            a *= b;
        }
        else if (b == 0.0) {
            g_diag.error(b_loc, "Division by zero in float expression");
            ps.error = true;		// division by zero
            a = 0.0;
        }
        else {
            a /= b;
        }
    }
    return a;
}

static double parse_power(ParseState& ps) {
    double a = parse_unary(ps);
    if (ps.error) {
        return 0.0;
    }

    while (ps.pline.peek().type == TokenType::Power) {
        ps.pline.advance();

        double b = parse_power(ps);
        if (ps.error) {
            return 0.0;
        }

        a = pow(a, b);
    }
    return a;
}

static double parse_unary(ParseState& ps) {
    double a;
    switch (ps.pline.peek().type) {
    case TokenType::Minus:
        ps.pline.advance();
        a = parse_unary(ps);
        if (ps.error) {
            return 0.0;
        }
        return -a;

    case TokenType::Plus:
        ps.pline.advance();
        a = parse_unary(ps);
        if (ps.error) {
            return 0.0;
        }
        return a;

    case TokenType::LeftParen:
        ps.pline.advance();
        a = parse_expr(ps);
        if (ps.error) {
            return 0.0;
        }
        if (ps.pline.peek().type != TokenType::RightParen) {
            g_diag.error(ps.pline.peek().loc,
                         "')' expected to match '(' in float expression");
            ps.error = true;
            return 0.0;
        }
        else {
            ps.pline.advance();
            return a;
        }

    default:
        a = parse_primary(ps);
        if (ps.error) {
            return 0.0;
        }
        return a;
    }
}

static double parse_primary(ParseState& ps) {
    double a;
    switch (ps.pline.peek().type) {
    case TokenType::Integer:
        a = static_cast<double>(ps.pline.peek().value.int_value);
        ps.pline.advance();
        return a;

    case TokenType::Float:
        a = ps.pline.peek().value.float_value;
        ps.pline.advance();
        return a;

    case TokenType::Identifier:
        switch (ps.pline.peek().keyword) {
        case Keyword::SIN:
            ps.pline.advance();
            return parse_func(ps, sin);
        case Keyword::COS:
            ps.pline.advance();
            return parse_func(ps, cos);
        case Keyword::TAN:
            ps.pline.advance();
            return parse_func(ps, tan);
        case Keyword::ASIN:
            ps.pline.advance();
            return parse_func(ps, asin);
        case Keyword::ACOS:
            ps.pline.advance();
            return parse_func(ps, acos);
        case Keyword::ATAN:
            ps.pline.advance();
            return parse_func(ps, atan);
        case Keyword::ATAN2:
            ps.pline.advance();
            return parse_func2(ps, atan2);
        case Keyword::SINH:
            ps.pline.advance();
            return parse_func(ps, sinh);
        case Keyword::COSH:
            ps.pline.advance();
            return parse_func(ps, cosh);
        case Keyword::TANH:
            ps.pline.advance();
            return parse_func(ps, tanh);
        case Keyword::ASINH:
            ps.pline.advance();
            return parse_func(ps, asinh);
        case Keyword::ACOSH:
            ps.pline.advance();
            return parse_func(ps, acosh);
        case Keyword::ATANH:
            ps.pline.advance();
            return parse_func(ps, atanh);
        case Keyword::LOG:
            ps.pline.advance();
            return parse_func(ps, log);
        case Keyword::LOG10:
            ps.pline.advance();
            return parse_func(ps, log10);
        case Keyword::LOG2:
            ps.pline.advance();
            return parse_func(ps, log2);
        case Keyword::EXP:
            ps.pline.advance();
            return parse_func(ps, exp);
        case Keyword::EXP2:
            ps.pline.advance();
            return parse_func(ps, exp2);
        case Keyword::POW:
            ps.pline.advance();
            return parse_func2(ps, pow);
        case Keyword::SQRT:
            ps.pline.advance();
            return parse_func(ps, sqrt);
        case Keyword::CBRT:
            ps.pline.advance();
            return parse_func(ps, cbrt);
        case Keyword::CEIL:
            ps.pline.advance();
            return parse_func(ps, ceil);
        case Keyword::FLOOR:
            ps.pline.advance();
            return parse_func(ps, floor);
        case Keyword::TRUNC:
            ps.pline.advance();
            return parse_func(ps, trunc);
        case Keyword::ABS:
            ps.pline.advance();
            return parse_func(ps, fabs);
        case Keyword::HYPOT:
            ps.pline.advance();
            return parse_func2(ps, hypot);
        case Keyword::FMOD:
            ps.pline.advance();
            return parse_func2(ps, fmod);
        case Keyword::PI:
            ps.pline.advance();
            return atan(1) * 4;
        case Keyword::E:
            ps.pline.advance();
            return exp(1);
        default:
            g_diag.error(ps.pline.peek().loc,
                         "Unknown identifier in float expression: " +
                         g_strings.string(ps.pline.peek().text_id));
            ps.error = true;
            return 0.0;
        }
    default:
        g_diag.error(ps.pline.peek().loc,
                     "Unexpected token in float expression: " +
                     escape_string(g_strings.view(ps.pline.peek().text_id)));
        ps.error = true;
        return 0.0;
    }
}

static double parse_func(ParseState& ps, double(*f)(double)) {
    if (ps.pline.peek().type != TokenType::LeftParen) {
        g_diag.error(ps.pline.peek().loc,
                     "'(' expected after function name in float expression");
        ps.error = true;
        return 0.0;
    }
    else {
        // include () in expression
        double a = parse_expr(ps);
        if (ps.error) {
            return 0.0;
        }
        return f(a);
    }
}

static double parse_func2(ParseState& ps, double(*f)(double, double)) {
    if (ps.pline.peek().type != TokenType::LeftParen) {
        g_diag.error(ps.pline.peek().loc,
                     "'(' expected after function name in float expression");
        ps.error = true;
        return 0.0;
    }
    else {
        ps.pline.advance(); // skip '('
        double a = parse_expr(ps);
        if (ps.error) {
            return 0.0;
        }

        if (ps.pline.peek().type != TokenType::Comma) {
            g_diag.error(ps.pline.peek().loc,
                         "',' expected between arguments in float expression");
            ps.error = true;
            return 0.0;
        }
        ps.pline.advance(); // skip ','

        double b = parse_expr(ps);
        if (ps.error) {
            return 0.0;
        }

        if (ps.pline.peek().type != TokenType::RightParen) {
            g_diag.error(ps.pline.peek().loc,
                         "')' expected after arguments in float expression");
            ps.error = true;
            return 0.0;
        }
        ps.pline.advance();

        return f(a, b);
    }
}

bool parse_float_expr(double& out_value, ParseLine& pline) {
    ParseState ps(pline);
    out_value = parse_expr(ps);
    return !ps.error;
}

bool parse_float_expr_list(std::vector<double>& out_list, ParseLine& pline) {
    while (true) {
        double value;
        if (!parse_float_expr(value, pline)) {
            return false; // error already issued
        }
        out_list.push_back(value);

        if (pline.peek().type == TokenType::Comma) {
            pline.advance(); // skip ','
        }
        else if (pline.eol()) {
            break;
        }
        else {
            g_diag.error(pline.peek().loc,
                         "Expected ',' or end of line in float expression list");
            return false;
        }
    }

    return true;
}

//-----------------------------------------------------------------------------
// Convertion of double to sequence of bytes depending on FloatFormat
//-----------------------------------------------------------------------------

// unions to access to float and double raw bytes
union myfloat {
    float   value;
    uint8_t bytes[4];
};
static_assert(sizeof(float) == 4, "expected 4 bytes");
static_assert(sizeof(myfloat) == 4, "expected 4 bytes");

union mydouble {
    double	 value;
    uint8_t  bytes[8];
    uint64_t raw;	// 1 bit sign, 11 bits exponent, 52 bits mantissa, bias 1023
};
static constexpr int mydouble_exp_bias = 1023;
static_assert(sizeof(double) == 8, "expected 8 bytes");
static_assert(sizeof(mydouble) == 8, "expected 8 bytes");

// check for endianness
static bool is_big_endian() {
    unsigned x = 0x76543210;
    char* c = (char*)&x;
    if (*c == 0x76) {
        return true;
    }
    else if (*c == 0x10) {
        return false;
    }
    else {
        release_assert(0);
        return false;	// not reached
    }
}

// copy bytes to vector<>, reversing order if big endian
static std::vector<uint8_t> get_bytes(uint8_t bytes[], int size) {
    std::vector<uint8_t> out;
    if (is_big_endian()) {	// invert byte order
        for (int i = size - 1; i >= 0; i--) {
            out.push_back(bytes[i]);
        }
    }
    else {
        for (int i = 0; i < size; i++) {
            out.push_back(bytes[i]);
        }
    }
    return out;
}

//-----------------------------------------------------------------------------
// code from sccz80
//-----------------------------------------------------------------------------
static inline const int MAX_MANTISSA_SIZE = 7;

struct fp_decomposed {
    uint8_t   exponent{ 0 };
    uint8_t   sign{ 0 };
    uint8_t   mantissa[MAX_MANTISSA_SIZE + 1] { 0 };
};

static void decompose_float(double raw, fp_decomposed* fs, int mant_bytes,
                            int exp_bias) {
    double norm;
    double x = fabs(raw);
    double exp = log(x) / log(2);
    int i;

    if (mant_bytes > MAX_MANTISSA_SIZE) {
        mant_bytes = MAX_MANTISSA_SIZE;
    }

    fs->exponent = fs->sign = 0;
    memset(fs->mantissa, 0, sizeof(uint8_t) * (MAX_MANTISSA_SIZE + 1));
    if (x == 0.0) {
        return;
    }

    if (floor(exp) == ceil(exp)) {
        exp = ceil(exp) + 1;
    }
    else {
        exp = ceil(exp);
    }

    norm = x / pow(2, exp);

    fs->exponent = static_cast<uint8_t>(static_cast<int>(exp) + exp_bias);
    for (i = 0; i < (mant_bytes * 2) + 1; i++) {
        double mult = norm * 16.;
        double res = floor(mult);
        uint8_t bit = static_cast<uint8_t>(res);

        if (i == 0 && raw > 0) {
            bit -= 8;
        }
        if (i == mant_bytes * 2) {
            if (bit > 7) {
                int carry = 1;
                for (i = MAX_MANTISSA_SIZE - mant_bytes; i < MAX_MANTISSA_SIZE; i++) {
                    int ires = fs->mantissa[i] + carry;

                    fs->mantissa[i] = ires % 256;
                    carry = ires / 256;
                }
            }
            break;
        }
        if (i % 2 == 0) {
            fs->mantissa[(MAX_MANTISSA_SIZE - 1) - i / 2] = (bit << 4);
        }
        else {
            fs->mantissa[(MAX_MANTISSA_SIZE - 1) - i / 2] |= (bit & 0x0f);
        }

        norm = mult - res;
    }
    if (raw < 0) {
        fs->sign = 1;
    }
}

static std::vector<uint8_t> pack32bit_float(uint32_t val) {
    std::vector<uint8_t> fa;
    fa.resize(4);

    fa[0] = val & 0xff;
    fa[1] = (val >> 8) & 0xff;
    fa[2] = (val >> 16) & 0xff;
    fa[3] = (val >> 24) & 0xff;

    return fa;
}

static std::vector<uint8_t> dofloat_z80(double value,
                                        int fp_size = 6, int mant_bytes = 5, int exp_bias = 128, int fudge_offset = 0) {

    std::vector<uint8_t> fa;
    fa.resize(fp_size);

    struct fp_decomposed fs = { 0 };
    int offs = MAX_MANTISSA_SIZE - mant_bytes;
    int i;

    decompose_float(value, &fs, mant_bytes, exp_bias);

    for (i = offs; i < MAX_MANTISSA_SIZE; i++) {
        fa[i - offs + fudge_offset] = fs.mantissa[i];
    }

    fa[i - offs - 1 + fudge_offset] |= fs.sign ? 0x80 : 0;
    fa[i - offs + fudge_offset] = fs.exponent;

    return fa;
}

std::vector<uint8_t> float_to_genmath(double value) {
    return dofloat_z80(value, 6, 5, 128, 0);
}

std::vector<uint8_t> float_to_math48(double value) {
    return float_to_genmath(value);		// same format as genmath
}

std::vector<uint8_t> float_to_z80(double value) {
    return float_to_genmath(value);		// same format as genmath
}

// convert to ieee-754 16 bits
std::vector<uint8_t> float_to_ieee16(double value) {
    int fp_size = 2;
    int mant_bytes = 2;
    int exp_bias = 14;

    std::vector<uint8_t> fa;
    fa.resize(fp_size);

    if (std::isnan(value)) {
        fa[0] = 0xff;
        fa[1] = 0xff;
    }
    else if (std::isinf(value) && value > 0) {
        // positive infinity: 7c00
        fa[0] = 0x00;
        fa[1] = 0x7c;
    }
    else if (std::isinf(value) && value < 0) {
        // negative infinity: fc00
        fa[0] = 0x00;
        fa[1] = 0xfc;
    }
    else {
        struct fp_decomposed fs;
        uint32_t fp_value = 0;

        decompose_float(value, &fs, mant_bytes, exp_bias);

        // Bundle up mantissa - it's only 10 bits
        fp_value = ((((uint32_t)fs.mantissa[6]) << 3) |
                    ((((uint32_t)fs.mantissa[5]) >> 5) & 0x07)) & 0x3ff;

        // And now the exponent
        fp_value |= (((uint32_t)fs.exponent) << 10) & 0x7fc0;

        // And the sign bit
        fp_value |= fs.sign ? 0x8000 : 0x0000;
        fa[0] = fp_value & 0xff;
        fa[1] = (fp_value & 0xff00) >> 8;
    }

    return fa;
}

// convert to ieee-754 32 bits
std::vector<uint8_t> float_to_ieee32(double value) {
    myfloat f;
    f.value = static_cast<float>(value);
    return get_bytes(f.bytes, static_cast<int>(sizeof(f)));
}

// convert to ieee-754 64 bits
std::vector<uint8_t> float_to_ieee64(double value) {
    mydouble f;
    f.value = value;
    return get_bytes(f.bytes, static_cast<int>(sizeof(f)));
}

// if integer: 0, 0, low, high, 0 (positive) | 0, 255, low, high, 0 (negative)
// else: same as zx81
std::vector<uint8_t> float_to_zx(double value) {
    if (floor(value) == value && fabs(value) <= 65535.0) {
        int ivalue = static_cast<int>(floor(value));
        std::vector<uint8_t>	out;

        out.push_back(0);
        if (value >= 0.0) {
            out.push_back(0);
        }
        else {
            out.push_back(255);
        }
        out.push_back(ivalue & 0xff);
        out.push_back((ivalue >> 8) & 0xff);
        out.push_back(0);

        return out;
    }
    else {
        return float_to_zx81(value);
    }
}

// 1 byte exponent
// 4 bytes mantissa, with first bit replaced by sign bit
std::vector<uint8_t> float_to_zx81(double value) {

    if (value == 0.0) {
        return std::vector<uint8_t> {0, 0, 0, 0, 0};
    }
    else {
        std::vector<uint8_t>	out;
        mydouble f;
        f.value = value;

        // convert to zx81 format
        uint64_t exponent = ((f.raw >> 52) & 0x7ff) - mydouble_exp_bias + 129;
        uint64_t mantissa = (f.raw >> (52 - 32 +
                                       1));	// align first bit to bit30, bit31 is sign
        if (value < 0.0) {
            mantissa |= 1LL << 31;
        }
        else {
            mantissa &= ~(1LL << 31);
        }

        // return
        out.push_back(exponent & 0xff);
        for (size_t i = 0; i < 4; i++) {
            out.push_back((mantissa >> 24) & 0xff);
            mantissa <<= 8;
        }
        return out;
    }
}

std::vector<uint8_t> float_to_z88(double value) {
    return dofloat_z80(value, 6, 4, 127, 1);	// leading zero + 5 bytes
}

std::vector<uint8_t> float_to_mbfs(double value) {
    int fp_size = 4;

    std::vector<uint8_t> fa;
    fa.resize(fp_size);

    struct fp_decomposed fs = { 0 };
    uint32_t fp_value = 0;

    decompose_float(value, &fs, 3, 128);

    // Bundle up mantissa
    fp_value = (((uint32_t)fs.mantissa[4]) |
                (((uint32_t)fs.mantissa[5]) << 8) |
                (((uint32_t)fs.mantissa[6]) << 16)) & 0x007fffff;

    // And now the exponent
    fp_value |= (((uint32_t)fs.exponent) << 24);

    // And the sign bit
    fp_value |= fs.sign ? 0x00800000 : 0x00000000;
    return pack32bit_float(fp_value);
}

std::vector<uint8_t> float_to_mbf40(double value) {
    int fp_size = 6;			// 5 bytes + trailing zero

    std::vector<uint8_t> fa;
    fa.resize(fp_size);

    struct fp_decomposed fs = { 0 };

    decompose_float(value, &fs, 4, 128);

    memcpy(&fa[0], fs.mantissa + 3, 4);
    fa[3] |= fs.sign ? 0x80 : 00;
    fa[4] = fs.exponent;

    return fa;
}

std::vector<uint8_t> float_to_mbf64(double value) {
    int fp_size = 8;

    std::vector<uint8_t> fa;
    fa.resize(fp_size);

    struct fp_decomposed fs = { 0 };

    decompose_float(value, &fs, 7, 128);

    memcpy(&fa[0], fs.mantissa, 7);
    fa[6] |= fs.sign ? 0x80 : 00;
    fa[7] = fs.exponent;

    return fa;
}

std::vector<uint8_t> float_to_am9511(double value) {
    int fp_size = 4;

    std::vector<uint8_t> fa;
    fa.resize(fp_size);

    struct fp_decomposed fs = { 0 };
    uint32_t fp_value = 0;

    if (value != 0.0) {
        decompose_float(value, &fs, 3, 0);

        // Bundle up mantissa
        fp_value = (((uint32_t)fs.mantissa[4]) |
                    (((uint32_t)fs.mantissa[5]) << 8) |
                    (((uint32_t)fs.mantissa[6]) << 16)) | 0x00800000;

        // And now the exponent
        fp_value |= ((((uint32_t)fs.exponent) << 24) & 0x7f000000);

        // And the sign bit
        fp_value |= fs.sign ? 0x80000000 : 0x00000000;
    }

    return pack32bit_float(fp_value);
}

std::vector<uint8_t> encode_float(double value, FloatFormat fmt) {
    switch (fmt) {
#define X(type)	case FloatFormat::type: return float_to_##type(value);
#include "zfloat.def"
#undef X
    default:
        release_assert(0);
        return std::vector<uint8_t>();
    }
}

std::vector<uint8_t> encode_float_list(const std::vector<double>& values,
                                       FloatFormat fmt) {
    std::vector<uint8_t> result;
    for (auto value : values) {
        std::vector<uint8_t> encoded = encode_float(value, fmt);
        result.insert(result.end(), encoded.begin(), encoded.end());
    }
    return result;
}
