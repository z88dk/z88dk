//-----------------------------------------------------------------------------
// z80asm
// scanner
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

#include "errors.h"
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <cstring>
#include <cctype>
using namespace std;

// token types
enum class TType {
#define X(id, text)     id,
#include "scan.def"
};

// keywords
enum KeywordFlags {
    KW_REG_8 = 1 << 1,
    KW_REG_IX_IY = 1 << 2,
    KW_Z80_LD_BIT = 1 << 3,
};

enum class Keyword {
#define X(id, text, flags)		id,
#include "keyword.def"
};

Keyword keyword_lookup(const string& text);
bool keyword_is_reg_8(Keyword keyword);
bool keyword_is_reg_ix_iy(Keyword keyword);
bool keyword_is_z80_ld_bit(Keyword keyword);

// token
class Token {
public:
    Token(TType type, bool blank_before, int ivalue = 0);
    Token(TType type, bool blank_before, double fvalue);
    Token(TType type, bool blank_before, const string& svalue);

    TType type() const { return m_type; }
    bool blank_before() const { return m_blank_before; }
    int ivalue() const { return m_ivalue; }
    double fvalue() const { return m_fvalue; }
    const string& svalue() const { return m_svalue; }
    Keyword keyword() const { return m_keyword; }

    string to_string() const;

    bool is(TType type) { return this->m_type == type; }
    bool is(Keyword keyword) { return this->m_keyword == keyword; }
    template <typename T, typename... Types>
    bool is(T var1, Types... var2) {
        if (is(var1))
            return true;
        else if (is(var2...))
            return true;
        else
            return false;
    }

    static string to_string(const vector<Token>& tokens);
    static string concat(const string& s1, const string& s2);

private:
    TType m_type{ TType::End };             // token type
    bool m_blank_before{ false };           // has a blank before
    int m_ivalue{ 0 };                      // integer value, if any
    double m_fvalue{ 0.0 };                 // floating point value, if any
    string m_svalue;                        // string value, if any
    Keyword m_keyword{ Keyword::None };     // keyword value, if any

    static string string_bytes(const string& text);
};

// scanned line
class ScannedLine {
public:
    ScannedLine(const string& text = "", const vector<Token>& tokens = {});
    void append(const ScannedLine& other);
    void append(const vector<Token>& tokens);
    void clear();

    const string& text() const { return m_text; }
    void set_text(const string& text) { m_text = text; }

    vector<Token>& tokens() { return m_tokens; }
    const vector<Token>& tokens() const { return m_tokens; }

    bool empty() const { return m_text.empty() && m_tokens.empty(); }
    string to_string() const { return Token::to_string(m_tokens); }

    void rewind() { m_pos = 0; }
    bool at_end() const { return m_pos >= m_tokens.size(); }
    unsigned pos() const { return m_pos; }
    void set_pos(unsigned pos) { m_pos = pos; }

    Token& peek(int offset = 0);			// 0: current; 1: next; -1: previous
    void next(int n = 1);
    vector<Token> peek_tokens(int offset = 0);
    string peek_text(int offset = 0);

private:
    string  m_text;                         // read text
    vector<Token> m_tokens;                 // scanned tokens
    unsigned m_pos{ 0 };                    // current token
};

// file scanner
class FileScanner {
public:
    FileScanner();

    bool open(const string& filename);
    void scan_text(Location location, const string& text);
    bool get_text_line(ScannedLine& line);  // read line, do not split into tokens
    bool get_token_line(ScannedLine& line); // read statemement from line, split into tokens
    Location& location() { return m_location; }
    const string& filename() const { return m_filename; }
    const Location& location() const { return m_location; }

private:
    string m_filename;                      // original file name, not changed by LINE
    Location m_location;                    // source location
    ifstream m_ifs;                         // open file handle
    string m_buffer;                        // scan buffer
    const char* line_start{ nullptr };      // lexer pointers
    const char* line_end{ nullptr };        // lexer pointers
    const char* p{ nullptr };
    const char* p0{ nullptr };
    const char* marker{ nullptr };
    const char* limit{ nullptr };

    bool m_got_error{ false };              // signal errors scanning
    bool m_blank_before{ false };           // blank before current token while scanning
    bool m_got_eof{ false };                // true after end of file reached

    bool peek_text_line(ScannedLine& line); // read line, setup line number for errors

    void scan_error(ErrCode code, const string& arg = "");

    bool fill();                            // fill buffer from file
    int yyfill() { return fill() ? 0 : 1; } // interface to re2c
    void notify_new_line(const string& text);
};
