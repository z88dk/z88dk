//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "../z80asm.h"
#include "test.h"

void test_lookup_keyword() {
    IS(keyword_lookup(""), Keyword::None);
    IS(keyword_lookup("oddword"), Keyword::None);
    IS(keyword_lookup("a"), Keyword::A);
    IS(keyword_lookup("a'"), Keyword::A1);
    IS(keyword_lookup("A"), Keyword::A);
    IS(keyword_lookup("A'"), Keyword::A1);
}

void test_tokens1() {
#if 0
    Tokens tokens;
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(0));
    STR_IS(tokens.to_string(), "");
    STR_IS(to_string(tokens), "");

    g_args.opt_ucase = true;
    tokens = Tokens("hello world");
    g_args.opt_ucase = false;
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(2));

    IS(tokens[0].ttype, TType::Ident);
    IS(tokens[0].blank_before, false);
    STR_IS(tokens[0].s_value, "HELLO");
    IS(tokens[0].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Ident);
    IS(tokens[1].blank_before, true);
    STR_IS(tokens[1].s_value, "WORLD");
    IS(tokens[1].keyword, Keyword::None);

    STR_IS(tokens.to_string(), "HELLO WORLD");
    STR_IS(to_string(tokens), "HELLO WORLD");

    tokens = Tokens("_abc$123 abc$123");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(2));

    IS(tokens[0].ttype, TType::Ident);
    IS(tokens[0].blank_before, false);
    STR_IS(tokens[0].s_value, "_abc$123");
    IS(tokens[0].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Ident);
    IS(tokens[1].blank_before, true);
    STR_IS(tokens[1].s_value, "abc$123");
    IS(tokens[1].keyword, Keyword::None);

    STR_IS(tokens.to_string(), "_abc$123 abc$123");
    STR_IS(to_string(tokens), "_abc$123 abc$123");

    tokens = Tokens("a'a");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(2));

    IS(tokens[0].ttype, TType::Ident);
    IS(tokens[0].blank_before, false);
    STR_IS(tokens[0].s_value, "a'");
    IS(tokens[0].keyword, Keyword::A1);

    IS(tokens[1].ttype, TType::Ident);
    IS(tokens[1].blank_before, false);
    STR_IS(tokens[1].s_value, "a");
    IS(tokens[1].keyword, Keyword::A);

    STR_IS(tokens.to_string(), "a'a");
    STR_IS(to_string(tokens), "a'a");

    g_args.opt_swap_ixiy = SwapIXIY::swap;
    tokens = Tokens("ix ixh ixl iy iyh iyl");
    g_args.opt_swap_ixiy = SwapIXIY::no_swap;
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(6));

    IS(tokens[0].ttype, TType::Ident);
    IS(tokens[0].blank_before, false);
    STR_IS(tokens[0].s_value, "iy");
    IS(tokens[0].keyword, Keyword::IY);

    IS(tokens[1].ttype, TType::Ident);
    IS(tokens[1].blank_before, true);
    STR_IS(tokens[1].s_value, "iyh");
    IS(tokens[1].keyword, Keyword::IYH);

    IS(tokens[2].ttype, TType::Ident);
    IS(tokens[2].blank_before, true);
    STR_IS(tokens[2].s_value, "iyl");
    IS(tokens[2].keyword, Keyword::IYL);

    IS(tokens[3].ttype, TType::Ident);
    IS(tokens[3].blank_before, true);
    STR_IS(tokens[3].s_value, "ix");
    IS(tokens[3].keyword, Keyword::IX);

    IS(tokens[4].ttype, TType::Ident);
    IS(tokens[4].blank_before, true);
    STR_IS(tokens[4].s_value, "ixh");
    IS(tokens[4].keyword, Keyword::IXH);

    IS(tokens[5].ttype, TType::Ident);
    IS(tokens[5].blank_before, true);
    STR_IS(tokens[5].s_value, "ixl");
    IS(tokens[5].keyword, Keyword::IXL);

    STR_IS(tokens.to_string(), "iy iyh iyl ix ixh ixl");
    STR_IS(to_string(tokens), "iy iyh iyl ix ixh ixl");

    tokens = Tokens(".assume asmpc $");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(3));

    IS(tokens[0].ttype, TType::Ident);
    IS(tokens[0].blank_before, false);
    STR_IS(tokens[0].s_value, "assume");
    IS(tokens[0].keyword, Keyword::ASSUME);

    IS(tokens[1].ttype, TType::Dollar);
    IS(tokens[1].blank_before, true);

    IS(tokens[2].ttype, TType::Dollar);
    IS(tokens[2].blank_before, true);

    STR_IS(tokens.to_string(), "assume $ $");
    STR_IS(to_string(tokens), "assume $ $");

    tokens = Tokens("1. .1 1.e+3 1.E-3");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(4));

    IS(tokens[0].ttype, TType::Floating);
    IS(tokens[0].f_value, 1.0);
    IS(tokens[0].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Floating);
    IS(tokens[1].f_value, 0.1);
    IS(tokens[1].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Floating);
    IS(tokens[2].f_value, 1000.0);
    IS(tokens[1].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Floating);
    IS(tokens[3].f_value, 0.001);
    IS(tokens[1].keyword, Keyword::None);

    STR_IS(tokens.to_string(), "1.000000 0.100000 1000.000000 0.001000");
    STR_IS(to_string(tokens),  "1.000000 0.100000 1000.000000 0.001000");

    tokens = Tokens("123 123d 123D");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(3));

    IS(tokens[0].ttype, TType::Integer);
    IS(tokens[0].i_value, 123);
    IS(tokens[0].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[1].i_value, 123);
    IS(tokens[1].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[2].i_value, 123);
    IS(tokens[1].keyword, Keyword::None);

    STR_IS(tokens.to_string(), "123 123 123");
    STR_IS(to_string(tokens),  "123 123 123");

    tokens = Tokens("0ffh 0FFH 123h");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(3));

    IS(tokens[0].ttype, TType::Integer);
    IS(tokens[0].i_value, 0xff);
    IS(tokens[0].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[1].i_value, 0xff);
    IS(tokens[1].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[2].i_value, 0x123);
    IS(tokens[1].keyword, Keyword::None);

    STR_IS(tokens.to_string(), "255 255 291");
    STR_IS(to_string(tokens),  "255 255 291");

    tokens = Tokens("$ff $FF $123");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(3));

    IS(tokens[0].ttype, TType::Integer);
    IS(tokens[0].i_value, 0xff);
    IS(tokens[0].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[1].i_value, 0xff);
    IS(tokens[1].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[2].i_value, 0x123);
    IS(tokens[1].keyword, Keyword::None);

    STR_IS(tokens.to_string(), "255 255 291");
    STR_IS(to_string(tokens),  "255 255 291");

    tokens = Tokens("0xff 0XFF 0x123");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(3));

    IS(tokens[0].ttype, TType::Integer);
    IS(tokens[0].i_value, 0xff);
    IS(tokens[0].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[1].i_value, 0xff);
    IS(tokens[1].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[2].i_value, 0x123);
    IS(tokens[1].keyword, Keyword::None);

    STR_IS(tokens.to_string(), "255 255 291");
    STR_IS(to_string(tokens),  "255 255 291");

    tokens = Tokens("0101b 1010B 1b");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(3));

    IS(tokens[0].ttype, TType::Integer);
    IS(tokens[0].i_value, 0x05);
    IS(tokens[0].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[1].i_value, 0x0a);
    IS(tokens[1].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[2].i_value, 0x01);
    IS(tokens[1].keyword, Keyword::None);

    STR_IS(tokens.to_string(), "5 10 1");
    STR_IS(to_string(tokens),  "5 10 1");

    tokens = Tokens("@0101 %1010 @1");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(3));

    IS(tokens[0].ttype, TType::Integer);
    IS(tokens[0].i_value, 0x05);
    IS(tokens[0].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[1].i_value, 0x0a);
    IS(tokens[1].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[2].i_value, 0x01);
    IS(tokens[1].keyword, Keyword::None);

    STR_IS(tokens.to_string(), "5 10 1");
    STR_IS(to_string(tokens),  "5 10 1");

    tokens = Tokens("0b0101 0B1010 0b1");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(3));

    IS(tokens[0].ttype, TType::Integer);
    IS(tokens[0].i_value, 0x05);
    IS(tokens[0].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[1].i_value, 0x0a);
    IS(tokens[1].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[2].i_value, 0x01);
    IS(tokens[1].keyword, Keyword::None);

    STR_IS(tokens.to_string(), "5 10 1");
    STR_IS(to_string(tokens),  "5 10 1");

    tokens = Tokens("@\"-#-#\" %\"#-#-\" @\"---#\"");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(3));

    IS(tokens[0].ttype, TType::Integer);
    IS(tokens[0].i_value, 0x05);
    IS(tokens[0].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[1].i_value, 0x0a);
    IS(tokens[1].keyword, Keyword::None);

    IS(tokens[1].ttype, TType::Integer);
    IS(tokens[2].i_value, 0x01);
    IS(tokens[1].keyword, Keyword::None);

    STR_IS(tokens.to_string(), "5 10 1");
    STR_IS(to_string(tokens),  "5 10 1");

    tokens = Tokens("\"hello \\\"world\\\"\"");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(1));

    IS(tokens[0].ttype, TType::String);
    STR_IS(tokens[0].s_value, "hello \"world\"");

    STR_IS(tokens.to_string(), "\"hello \\\"world\\\"\"");
    STR_IS(to_string(tokens), "\"hello \\\"world\\\"\"");

    g_args.opt_raw_strings = true;
    tokens = Tokens("\"\\\"");
    g_args.opt_raw_strings = false;
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(1));

    IS(tokens[0].ttype, TType::String);
    STR_IS(tokens[0].s_value, "\\");

    STR_IS(tokens.to_string(), "\"\\\\\"");
    STR_IS(to_string(tokens), "\"\\\\\"");

    tokens = Tokens("\t\n\v\f\r !## # hello ## world $ % &&&()***+,-./:<<<=>>>=>< <>===!=?[\\]^^^{|||}~;comment");
    IS(tokens.pos, 0);
    IS(tokens.is_ok, true);
    IS(tokens.size(), static_cast<size_t>(41));

    IS(tokens[-1].ttype, TType::End);
    IS(tokens[0].ttype, TType::LogNot); tokens.pos++;
    IS(tokens[0].ttype, TType::DblHash); tokens.pos++;
    IS(tokens[0].ttype, TType::Hash); tokens.pos++;
    IS(tokens[0].ttype, TType::Ident); tokens.pos++;
    IS(tokens[0].ttype, TType::DblHash); tokens.pos++;
    IS(tokens[0].ttype, TType::Ident); tokens.pos++;
    IS(tokens[0].ttype, TType::Dollar); tokens.pos++;
    IS(tokens[0].ttype, TType::Mod); tokens.pos++;
    IS(tokens[0].ttype, TType::LogAnd); tokens.pos++;
    IS(tokens[0].ttype, TType::BinAnd); tokens.pos++;
    IS(tokens[0].ttype, TType::LParen); tokens.pos++;
    IS(tokens[0].ttype, TType::RParen); tokens.pos++;
    IS(tokens[0].ttype, TType::Power); tokens.pos++;
    IS(tokens[0].ttype, TType::Mult); tokens.pos++;
    IS(tokens[0].ttype, TType::Plus); tokens.pos++;
    IS(tokens[0].ttype, TType::Comma); tokens.pos++;
    IS(tokens[0].ttype, TType::Minus); tokens.pos++;
    IS(tokens[0].ttype, TType::Dot); tokens.pos++;
    IS(tokens[0].ttype, TType::Div); tokens.pos++;
    IS(tokens[0].ttype, TType::Colon); tokens.pos++;
    IS(tokens[0].ttype, TType::LShift); tokens.pos++;
    IS(tokens[0].ttype, TType::Le); tokens.pos++;
    IS(tokens[0].ttype, TType::RShift); tokens.pos++;
    IS(tokens[0].ttype, TType::Ge); tokens.pos++;
    IS(tokens[0].ttype, TType::Gt); tokens.pos++;
    IS(tokens[0].ttype, TType::Lt); tokens.pos++;
    IS(tokens[0].ttype, TType::Ne); tokens.pos++;
    IS(tokens[0].ttype, TType::Eq); tokens.pos++;
    IS(tokens[0].ttype, TType::Eq); tokens.pos++;
    IS(tokens[0].ttype, TType::Ne); tokens.pos++;
    IS(tokens[0].ttype, TType::Quest); tokens.pos++;
    IS(tokens[0].ttype, TType::LSquare); tokens.pos++;
    IS(tokens[0].ttype, TType::Backslash); tokens.pos++;
    IS(tokens[0].ttype, TType::RSquare); tokens.pos++;
    IS(tokens[0].ttype, TType::LogXor); tokens.pos++;
    IS(tokens[0].ttype, TType::BinXor); tokens.pos++;
    IS(tokens[0].ttype, TType::LBrace); tokens.pos++;
    IS(tokens[0].ttype, TType::LogOr); tokens.pos++;
    IS(tokens[0].ttype, TType::BinOr); tokens.pos++;
    IS(tokens[0].ttype, TType::RBrace); tokens.pos++;
    IS(tokens[0].ttype, TType::BinNot); tokens.pos++;
    IS(tokens[0].ttype, TType::End); tokens.pos++;

    tokens.pos = 36;
    STR_IS(tokens.peek_tokens().to_string(), "{|| |}~");
#endif
}

void test_tokens2() {
#if 0
    RUN_OK("exec_tokens1");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: invalid character: `\n");

    RUN_OK("exec_tokens2");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: invalid character: $a0\n");

    RUN_OK("exec_tokens3");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: invalid character: $7f\n");

    RUN_OK("exec_tokens4");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: missing quote\n");

    RUN_OK("exec_tokens5");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: missing quote\n");

    RUN_OK("exec_tokens6");
    STR_IS(test_exec_out, "");
    STR_IS(test_exec_err, "error: invalid character constant\n");
#endif
}

int exec_tokens1() {
#if 0
    Tokens tokens("hello world ` wrong \x7f input");
    xassert(!tokens.is_ok);
    xassert(tokens.size() == 0);
#endif
    return EXIT_SUCCESS;
}

int exec_tokens2() {
#if 0
    Tokens tokens("hello world \xa0 wrong \x7f input");
    xassert(!tokens.is_ok);
    xassert(tokens.size() == 0);
#endif
    return EXIT_SUCCESS;
}

int exec_tokens3() {
#if 0
    Tokens tokens("hello world wrong \x7f input");
    xassert(!tokens.is_ok);
    xassert(tokens.size() == 0);
#endif
    return EXIT_SUCCESS;
}

int exec_tokens4() {
#if 0
    Tokens tokens("\"hello world");
    xassert(!tokens.is_ok);
    xassert(tokens.size() == 0);
#endif
    return EXIT_SUCCESS;
}

int exec_tokens5() {
#if 0
    Tokens tokens("'hello");
    xassert(!tokens.is_ok);
    xassert(tokens.size() == 0);
#endif
    return EXIT_SUCCESS;
}

int exec_tokens6() {
#if 0
    Tokens tokens("'hel'");
    xassert(!tokens.is_ok);
    xassert(tokens.size() == 0);
#endif
    return EXIT_SUCCESS;
}
