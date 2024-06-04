//-----------------------------------------------------------------------------
// z80asm - scanner
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "common.h"
#include "scan.h"
#include "t/test.h"
using namespace std;

void test_keyword_lookup() {
    IS(keyword_lookup(""), KW_NONE);
    IS(keyword_lookup("nop"), KW_NOP);
    IS(keyword_lookup("nope"), KW_NONE);
    IS(keyword_lookup("Nop"), KW_NOP);
    IS(keyword_lookup("NOP"), KW_NOP);
}

void test_lexer_empty() {
    Lexer l;
    OK(l.at_end());
    IS(l.peek(0).code(), TK_END);
    IS(l.peek(1).code(), TK_END);
    IS(l.peek(-1).code(), TK_END);
    IS(l.text(), "");
    IS(l.peek_text(), "");

    l.next();
    IS(l.peek(0).code(), TK_END);
    IS(l.peek(1).code(), TK_END);

    l.flush();
    IS(l.peek(0).code(), TK_END);
    IS(l.peek(1).code(), TK_END);
}

void test_lexer_symbols() {
    Lexer l("\\$~!&&&|||^^^+-***/%===<>!=< <=> >=<<>>?:.,###()[]{};comment");
    IS(l.peek(0).code(), TK_BACKSLASH);
    IS(l.peek(1).code(), TK_ASMPC);
    IS(l.peek(2).code(), TK_BINNOT);
    IS(l.peek(3).code(), TK_LOGNOT);
    IS(l.peek(4).code(), TK_LOGAND);
    IS(l.peek(5).code(), TK_BINAND);
    IS(l.peek(6).code(), TK_LOGOR);
    IS(l.peek(7).code(), TK_BINOR);
    IS(l.peek(8).code(), TK_LOGXOR);
    IS(l.peek(9).code(), TK_BINXOR);
    IS(l.peek(10).code(), TK_PLUS);
    IS(l.peek(11).code(), TK_MINUS);
    IS(l.peek(12).code(), TK_POWER);
    IS(l.peek(13).code(), TK_MULT);
    IS(l.peek(14).code(), TK_DIV);
    IS(l.peek(15).code(), TK_MOD);
    IS(l.peek(16).code(), TK_EQ);
    IS(l.peek(17).code(), TK_EQ);
    IS(l.peek(18).code(), TK_NE);
    IS(l.peek(19).code(), TK_NE);
    IS(l.peek(20).code(), TK_LT);
    IS(l.peek(21).code(), TK_LE);
    IS(l.peek(22).code(), TK_GT);
    IS(l.peek(23).code(), TK_GE);
    IS(l.peek(24).code(), TK_LSHIFT);
    IS(l.peek(25).code(), TK_RSHIFT);
    IS(l.peek(26).code(), TK_QUEST);
    IS(l.peek(27).code(), TK_COLON);
    IS(l.peek(28).code(), TK_DOT);
    IS(l.peek(29).code(), TK_COMMA);
    IS(l.peek(30).code(), TK_DBLHASH);
    IS(l.peek(31).code(), TK_HASH);
    IS(l.peek(32).code(), TK_LPAREN);
    IS(l.peek(33).code(), TK_RPAREN);
    IS(l.peek(34).code(), TK_LSQUARE);
    IS(l.peek(35).code(), TK_RSQUARE);
    IS(l.peek(36).code(), TK_LBRACE);
    IS(l.peek(37).code(), TK_RBRACE);
    IS(l.peek(38).code(), TK_END);
}

void test_lexer_ident() {
    Lexer l;
    OK(l.set_text("af af'start _abc$123"));

    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_AF);
    IS(l.peek(0).svalue(), "af");

    l.next();
    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_AF1);
    IS(l.peek(0).svalue(), "af'");

    l.next();
    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_NONE);
    IS(l.peek(0).svalue(), "start");

    l.next();
    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_NONE);
    IS(l.peek(0).svalue(), "_abc$123");

    l.next();
    IS(l.peek(0).code(), TK_END);
    OK(l.at_end());
}

void test_lexer_uppercase() {
    g_options.set_upper_case(true);

    Lexer l;
    OK(l.set_text("af af'start _abc$123"));

    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_AF);
    IS(l.peek(0).svalue(), "AF");

    l.next();
    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_AF1);
    IS(l.peek(0).svalue(), "AF'");

    l.next();
    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_NONE);
    IS(l.peek(0).svalue(), "START");

    l.next();
    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_NONE);
    IS(l.peek(0).svalue(), "_ABC$123");

    l.next();
    IS(l.peek(0).code(), TK_END);
    OK(l.at_end());

    g_options.set_upper_case(false);
}

void test_lexer_swap_ixiy() {
    Lexer l;
    g_options.set_swap_ixiy(IXIY_NO_SWAP);
    OK(l.set_text("hl ix iy h ixh iyh l ixl iyl"));

    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_HL);
    IS(l.peek(0).svalue(), "hl");

    IS(l.peek(1).code(), TK_IDENT);
    IS(l.peek(1).keyword(), KW_IX);
    IS(l.peek(1).svalue(), "ix");

    IS(l.peek(2).code(), TK_IDENT);
    IS(l.peek(2).keyword(), KW_IY);
    IS(l.peek(2).svalue(), "iy");

    IS(l.peek(3).code(), TK_IDENT);
    IS(l.peek(3).keyword(), KW_H);
    IS(l.peek(3).svalue(), "h");

    IS(l.peek(4).code(), TK_IDENT);
    IS(l.peek(4).keyword(), KW_IXH);
    IS(l.peek(4).svalue(), "ixh");

    IS(l.peek(5).code(), TK_IDENT);
    IS(l.peek(5).keyword(), KW_IYH);
    IS(l.peek(5).svalue(), "iyh");

    IS(l.peek(6).code(), TK_IDENT);
    IS(l.peek(6).keyword(), KW_L);
    IS(l.peek(6).svalue(), "l");

    IS(l.peek(7).code(), TK_IDENT);
    IS(l.peek(7).keyword(), KW_IXL);
    IS(l.peek(7).svalue(), "ixl");

    IS(l.peek(8).code(), TK_IDENT);
    IS(l.peek(8).keyword(), KW_IYL);
    IS(l.peek(8).svalue(), "iyl");

    IS(l.peek(9).code(), TK_END);


    g_options.set_swap_ixiy(IXIY_SWAP);
    OK(l.set_text("hl ix iy h ixh iyh l ixl iyl"));

    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_HL);
    IS(l.peek(0).svalue(), "hl");

    IS(l.peek(1).code(), TK_IDENT);
    IS(l.peek(1).keyword(), KW_IY);
    IS(l.peek(1).svalue(), "iy");

    IS(l.peek(2).code(), TK_IDENT);
    IS(l.peek(2).keyword(), KW_IX);
    IS(l.peek(2).svalue(), "ix");

    IS(l.peek(3).code(), TK_IDENT);
    IS(l.peek(3).keyword(), KW_H);
    IS(l.peek(3).svalue(), "h");

    IS(l.peek(4).code(), TK_IDENT);
    IS(l.peek(4).keyword(), KW_IYH);
    IS(l.peek(4).svalue(), "iyh");

    IS(l.peek(5).code(), TK_IDENT);
    IS(l.peek(5).keyword(), KW_IXH);
    IS(l.peek(5).svalue(), "ixh");

    IS(l.peek(6).code(), TK_IDENT);
    IS(l.peek(6).keyword(), KW_L);
    IS(l.peek(6).svalue(), "l");

    IS(l.peek(7).code(), TK_IDENT);
    IS(l.peek(7).keyword(), KW_IYL);
    IS(l.peek(7).svalue(), "iyl");

    IS(l.peek(8).code(), TK_IDENT);
    IS(l.peek(8).keyword(), KW_IXL);
    IS(l.peek(8).svalue(), "ixl");

    IS(l.peek(9).code(), TK_END);

    g_options.set_swap_ixiy(IXIY_SOFT_SWAP);
    OK(l.set_text("hl ix iy h ixh iyh l ixl iyl"));

    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_HL);
    IS(l.peek(0).svalue(), "hl");

    IS(l.peek(1).code(), TK_IDENT);
    IS(l.peek(1).keyword(), KW_IY);
    IS(l.peek(1).svalue(), "iy");

    IS(l.peek(2).code(), TK_IDENT);
    IS(l.peek(2).keyword(), KW_IX);
    IS(l.peek(2).svalue(), "ix");

    IS(l.peek(3).code(), TK_IDENT);
    IS(l.peek(3).keyword(), KW_H);
    IS(l.peek(3).svalue(), "h");

    IS(l.peek(4).code(), TK_IDENT);
    IS(l.peek(4).keyword(), KW_IYH);
    IS(l.peek(4).svalue(), "iyh");

    IS(l.peek(5).code(), TK_IDENT);
    IS(l.peek(5).keyword(), KW_IXH);
    IS(l.peek(5).svalue(), "ixh");

    IS(l.peek(6).code(), TK_IDENT);
    IS(l.peek(6).keyword(), KW_L);
    IS(l.peek(6).svalue(), "l");

    IS(l.peek(7).code(), TK_IDENT);
    IS(l.peek(7).keyword(), KW_IYL);
    IS(l.peek(7).svalue(), "iyl");

    IS(l.peek(8).code(), TK_IDENT);
    IS(l.peek(8).keyword(), KW_IXL);
    IS(l.peek(8).svalue(), "ixl");

    IS(l.peek(9).code(), TK_END);

    g_options.set_swap_ixiy(IXIY_NO_SWAP);
}

void test_lexer_integer() {
    Lexer l;
    OK(l.set_text("0 1 255 255d 255D"));

    IS(l.peek(0).code(), TK_INTEGER);
    IS(l.peek(0).ivalue(), 0);

    IS(l.peek(1).code(), TK_INTEGER);
    IS(l.peek(1).ivalue(), 1);

    IS(l.peek(2).code(), TK_INTEGER);
    IS(l.peek(2).ivalue(), 255);

    IS(l.peek(3).code(), TK_INTEGER);
    IS(l.peek(3).ivalue(), 255);

    IS(l.peek(4).code(), TK_INTEGER);
    IS(l.peek(4).ivalue(), 255);

    IS(l.peek(5).code(), TK_END);

    OK(l.set_text("$ff 0xff 0XFF 0ffh 0FFH"));

    IS(l.peek(0).code(), TK_INTEGER);
    IS(l.peek(0).ivalue(), 255);

    IS(l.peek(1).code(), TK_INTEGER);
    IS(l.peek(1).ivalue(), 255);

    IS(l.peek(2).code(), TK_INTEGER);
    IS(l.peek(2).ivalue(), 255);

    IS(l.peek(3).code(), TK_INTEGER);
    IS(l.peek(3).ivalue(), 255);

    IS(l.peek(4).code(), TK_INTEGER);
    IS(l.peek(4).ivalue(), 255);

    IS(l.peek(5).code(), TK_END);

    OK(l.set_text("%1010 @1010 0b1010 0B1010 1010b 1010B"));

    IS(l.peek(0).code(), TK_INTEGER);
    IS(l.peek(0).ivalue(), 10);

    IS(l.peek(1).code(), TK_INTEGER);
    IS(l.peek(1).ivalue(), 10);

    IS(l.peek(2).code(), TK_INTEGER);
    IS(l.peek(2).ivalue(), 10);

    IS(l.peek(3).code(), TK_INTEGER);
    IS(l.peek(3).ivalue(), 10);

    IS(l.peek(4).code(), TK_INTEGER);
    IS(l.peek(4).ivalue(), 10);

    IS(l.peek(5).code(), TK_INTEGER);
    IS(l.peek(5).ivalue(), 10);

    IS(l.peek(6).code(), TK_END);
}

void test_lexer_bitmap() {
    Lexer l;
    OK(l.set_text("%\"#-#-\" @\"#-#-\""));

    IS(l.peek(0).code(), TK_INTEGER);
    IS(l.peek(0).ivalue(), 10);

    IS(l.peek(1).code(), TK_INTEGER);
    IS(l.peek(1).ivalue(), 10);

    IS(l.peek(2).code(), TK_END);
}

void test_lexer_floating() {
    Lexer l;
    OK(l.set_text("1. 1.1 .1 1.e+1 .1e-1 1.1E+2 1.1E-2"));

    IS(l.peek(0).code(), TK_FLOATING);
    IS(l.peek(0).fvalue(), 1.0);

    IS(l.peek(1).code(), TK_FLOATING);
    IS(l.peek(1).fvalue(), 1.1);

    IS(l.peek(2).code(), TK_FLOATING);
    IS(l.peek(2).fvalue(), 0.1);

    IS(l.peek(3).code(), TK_FLOATING);
    IS(l.peek(3).fvalue(), 10.0);

    IS(l.peek(4).code(), TK_FLOATING);
    IS(l.peek(4).fvalue(), 0.01);

    IS(l.peek(5).code(), TK_FLOATING);
    IS(l.peek(5).fvalue(), 110.0);

    IS(l.peek(6).code(), TK_FLOATING);
    IS(l.peek(6).fvalue(), 0.011);

    IS(l.peek(7).code(), TK_END);
}

void test_lexer_string() {
    Lexer l;

    g_options.set_raw_strings(false);
    OK(l.set_text("\"\\1\\x02\\a\\b\\e\\f\\n\\r\\t\\v\\\\hello\""));

    IS(l.peek(0).code(), TK_STRING);
    IS(l.peek(0).svalue(), "\1\2\a\b\x1b\f\n\r\t\v\\hello");

    IS(l.peek(1).code(), TK_END);

    g_options.set_raw_strings(true);
    OK(l.set_text("\"\\1\\x02\\a\\b\\e\\f\\n\\r\\t\\v\\\\hello\""));

    IS(l.peek(0).code(), TK_STRING);
    IS(l.peek(0).svalue(), "\\1\\x02\\a\\b\\e\\f\\n\\r\\t\\v\\\\hello");

    IS(l.peek(1).code(), TK_END);

    g_options.set_raw_strings(false);
}

void test_lexer_file_string() {
    Lexer l;

    g_options.set_raw_strings(false);
    OK(l.set_text("include \"dir\\tab\\newline\""));

    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_INCLUDE);
    IS(l.peek(0).svalue(), "include");

    IS(l.peek(1).code(), TK_STRING);
    IS(l.peek(1).svalue(), "dir\\tab\\newline");

    IS(l.peek(2).code(), TK_END);

    OK(l.set_text("binary \"dir\\tab\\newline\""));

    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_BINARY);
    IS(l.peek(0).svalue(), "binary");

    IS(l.peek(1).code(), TK_STRING);
    IS(l.peek(1).svalue(), "dir\\tab\\newline");

    IS(l.peek(2).code(), TK_END);

    OK(l.set_text("incbin \"dir\\tab\\newline\""));

    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_INCBIN);
    IS(l.peek(0).svalue(), "incbin");

    IS(l.peek(1).code(), TK_STRING);
    IS(l.peek(1).svalue(), "dir\\tab\\newline");

    IS(l.peek(2).code(), TK_END);

    OK(l.set_text("line \"dir\\tab\\newline\""));

    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_LINE);
    IS(l.peek(0).svalue(), "line");

    IS(l.peek(1).code(), TK_STRING);
    IS(l.peek(1).svalue(), "dir\\tab\\newline");

    IS(l.peek(2).code(), TK_END);

    OK(l.set_text("c_line \"dir\\tab\\newline\""));

    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_C_LINE);
    IS(l.peek(0).svalue(), "c_line");

    IS(l.peek(1).code(), TK_STRING);
    IS(l.peek(1).svalue(), "dir\\tab\\newline");

    IS(l.peek(2).code(), TK_END);
}

void test_lexer_invalid_char() {
    ostringstream oss;
    g_errors.set_output(oss);
    Lexer l;
    NOK(l.set_text("` hello world"));
    IS(oss.str(), "error: invalid character: ` hello world\n");
    OK(l.at_end());
    g_errors.clear();
}

void test_lexer_invalid_double_quoted_string() {
    ostringstream oss;
    g_errors.set_output(oss);
    Lexer l;
    NOK(l.set_text("\"hello world"));
    IS(oss.str(), "error: missing quote: \"hello world\n");
    OK(l.at_end());
    g_errors.clear();
}

void test_lexer_invalid_single_quoted_string() {
    ostringstream oss;
    g_errors.set_output(oss);
    Lexer l;
    NOK(l.set_text("'hello world"));
    IS(oss.str(), "error: missing quote: 'hello world\n");
    OK(l.at_end());
    g_errors.clear();
}

void test_lexer_invalid_character_constant1() {
    ostringstream oss;
    g_errors.set_output(oss);
    Lexer l;
    NOK(l.set_text("''"));
    IS(oss.str(), "error: invalid character constant: ''\n");
    OK(l.at_end());
    g_errors.clear();
}

void test_lexer_invalid_character_constant2() {
    ostringstream oss;
    g_errors.set_output(oss);
    Lexer l;
    NOK(l.set_text("'ab'"));
    IS(oss.str(), "error: invalid character constant: 'ab'\n");
    OK(l.at_end());
    g_errors.clear();
}

void test_character_constant() {
    Lexer l;
    OK(l.set_text("' ' '\\1' '\\x02' '\\a' '\\b' '\\e' '\\f' '\\n' '\\r' '\\t' '\\v' '\\\\'"));

    IS(l.peek(0).code(), TK_INTEGER);
    IS(l.peek(0).ivalue(), ' ');

    IS(l.peek(1).code(), TK_INTEGER);
    IS(l.peek(1).ivalue(), 1);

    IS(l.peek(2).code(), TK_INTEGER);
    IS(l.peek(2).ivalue(), 2);

    IS(l.peek(3).code(), TK_INTEGER);
    IS(l.peek(3).ivalue(), '\a');

    IS(l.peek(4).code(), TK_INTEGER);
    IS(l.peek(4).ivalue(), '\b');

    IS(l.peek(5).code(), TK_INTEGER);
    IS(l.peek(5).ivalue(), 27);

    IS(l.peek(6).code(), TK_INTEGER);
    IS(l.peek(6).ivalue(), '\f');

    IS(l.peek(7).code(), TK_INTEGER);
    IS(l.peek(7).ivalue(), '\n');

    IS(l.peek(8).code(), TK_INTEGER);
    IS(l.peek(8).ivalue(), '\r');

    IS(l.peek(9).code(), TK_INTEGER);
    IS(l.peek(9).ivalue(), '\t');

    IS(l.peek(10).code(), TK_INTEGER);
    IS(l.peek(10).ivalue(), '\v');

    IS(l.peek(11).code(), TK_INTEGER);
    IS(l.peek(11).ivalue(), '\\');

    IS(l.peek(12).code(), TK_END);
}

void test_lexer_assume() {
    Lexer l;
    OK(l.set_text(". assume "));

    IS(l.peek(0).code(), TK_IDENT);
    IS(l.peek(0).keyword(), KW_ASSUME);
    IS(l.peek(0).svalue(), "assume");

    IS(l.peek(1).code(), TK_END);

    OK(l.set_text(". start "));

    IS(l.peek(0).code(), TK_DOT);

    IS(l.peek(1).code(), TK_IDENT);
    IS(l.peek(1).keyword(), KW_NONE);
    IS(l.peek(1).svalue(), "start");

    IS(l.peek(2).code(), TK_END);
}
