#include <algorithm>
#include <cassert>
#include <cctype>
#include <cstring>
#include <fstream>
#include <iostream>
#include <list>
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

// Utilities

string strtolower(string input);


// Location of an input line
class Location {
public:
	Location(const string& filename = "", int line_num = 0);
	void clear();
	void clear_text();
	bool empty() const;

	const string& get_filename() const { return m_filename; }
	int get_line_num() const { return m_line_num; }
	const string& get_text() const { return m_text; }
	const string& get_expanded_text() const { return m_expanded_text; }

	void set_filename(const string& filename);
	void set_line_num(int line_num);
	void set_text(const string& text);
	void set_expanded_text(const string& expanded_text);

private:
	string m_filename;
	int m_line_num;
	string m_text;
	string m_expanded_text;
};

extern Location g_location;


// error message output and counting
class Error {
public:
	int get_count() const { return m_count; }
	void error_invalid_char(char c) { error("invalid character", std::to_string(static_cast<int>(c))); }
	void error_invalid_escape_char(char c) { error("invalid escape character", string(1, c)); }
	void error_invalid_quoted_char() { error("invalid quoted character"); }
	void error_open_file(const string& filename) { error("file open", filename); }
	void error_recursive_include(const string& filename) { error("recursive include", filename); }
	void error_unterminated_string() { error("unterminated string"); }

private:
	int m_count{ 0 };
	void error(const string& message, const string& arg = "");
	void warning(const string& message, const string& arg = "");
	void output_message(const string& prefix, const string& message, const string& arg = "");
};

extern Error g_error;


// Stack of input files
class InputFiles {
public:
	InputFiles() {}
	InputFiles(const InputFiles& other) = delete;
	virtual ~InputFiles();
	InputFiles& operator=(const InputFiles& other) = delete;

	void push_file(const string& filename);
	void pop_file();
	bool getline(string& line);

private:
	struct File {
		string filename;
		int line_num{ 0 };
		int line_inc{ 1 };
		ifstream ifs;
	};
	list<File*> m_files; // stack of input files

	bool already_included(const string& filename);
};

extern InputFiles g_input_files;


// Tokens returned from Scanner
class Token {
public:
	enum Type {
		//@@BEGIN: type
		END,
		ASMPC,
		BACKSLASH,
		BIN_AND,
		BIN_NOT,
		BIN_OR,
		BIN_XOR,
		COLON,
		COMMA,
		DHASH,
		DIV,
		DOT,
		EQ,
		EXPR,
		FLOAT,
		GE,
		GT,
		HASH,
		IDENT,
		INT,
		LBRACE,
		LE,
		LOG_AND,
		LOG_NOT,
		LOG_OR,
		LOG_XOR,
		LPAREN,
		LSHIFT,
		LSQUARE,
		LT,
		MINUS,
		MOD,
		MULT,
		NE,
		PLUS,
		POWER,
		QUEST,
		RAW_STR,
		RBRACE,
		RPAREN,
		RSHIFT,
		RSQUARE,
		STR,
		//@@END
	};
	enum Keyword {
		//@@BEGIN: keyword
		NONE,
		KW_A,
		KW_ASMPC,
		KW_ASSUME,
		KW_BINARY,
		KW_C,
		KW_C_LINE,
		KW_DEFB,
		KW_DEFDW,
		KW_DEFP,
		KW_DEFW,
		KW_EQU,
		KW_INCBIN,
		KW_INCLUDE,
		KW_JR,
		KW_LD,
		KW_LINE,
		KW_MACRO,
		KW_NC,
		KW_NOP,
		KW_NZ,
		KW_Z,
		NODE,
		//@@END
	};

	Token() {}
	Token(Type type, bool blank_before);
	Type get_type() const { return m_type; }
	bool has_blank_before() const { return m_blank_before; }
	
	int get_ivalue() const { return m_ivalue; }
	double get_fvalue() const { return m_fvalue; }
	const string& get_svalue() const { return m_svalue; }
	Keyword get_keyword() const { return m_keyword; }

	void set_ivalue(int ivalue) { m_ivalue = ivalue; }
	void set_fvalue(double fvalue) { m_fvalue = fvalue; }
	void set_svalue(const string& svalue) { m_svalue = svalue; }
	void set_keyword(const string& text);

	bool is(Type type) const { return m_type == type; }
	bool is(Keyword keyword) { return m_keyword == keyword; }

	string to_string() const;

	static Keyword lookup_keyword(const string& text);

private:
	Type m_type{ END };
	bool m_blank_before{ false };
	Keyword m_keyword{ NONE };
	int m_ivalue{ 0 };
	double m_fvalue{ 0.0 };
	string m_svalue;

	string lookup_type(Type type);

	static inline unordered_map<Type, string> types = {
		//@@BEGIN: type_map
		{ ASMPC, "$" },
		{ BACKSLASH, "\\" },
		{ BIN_AND, "&" },
		{ BIN_NOT, "~" },
		{ BIN_OR, "|" },
		{ BIN_XOR, "^" },
		{ COLON, ":" },
		{ COMMA, "," },
		{ DHASH, "##" },
		{ DIV, "/" },
		{ DOT, "." },
		{ END, "" },
		{ EQ, "=" },
		{ EXPR, "" },
		{ FLOAT, "" },
		{ GE, ">=" },
		{ GT, ">" },
		{ HASH, "#" },
		{ IDENT, "" },
		{ INT, "" },
		{ LBRACE, "{" },
		{ LE, "<=" },
		{ LOG_AND, "&&" },
		{ LOG_NOT, "!" },
		{ LOG_OR, "||" },
		{ LOG_XOR, "^^" },
		{ LPAREN, "(" },
		{ LSHIFT, "<<" },
		{ LSQUARE, "[" },
		{ LT, "<" },
		{ MINUS, "-" },
		{ MOD, "%" },
		{ MULT, "*" },
		{ NE, "<>" },
		{ PLUS, "+" },
		{ POWER, "**" },
		{ QUEST, "?" },
		{ RAW_STR, "" },
		{ RBRACE, "}" },
		{ RPAREN, ")" },
		{ RSHIFT, ">>" },
		{ RSQUARE, "]" },
		{ STR, "" },
		//@@END
	};

	static inline unordered_map<string, Token::Keyword> keywords = {
		//@@BEGIN: keyword_map
		{ "a", KW_A },
		{ "asmpc", KW_ASMPC },
		{ "assume", KW_ASSUME },
		{ "binary", KW_BINARY },
		{ "c", KW_C },
		{ "c_line", KW_C_LINE },
		{ "defb", KW_DEFB },
		{ "defdw", KW_DEFDW },
		{ "defp", KW_DEFP },
		{ "defw", KW_DEFW },
		{ "equ", KW_EQU },
		{ "incbin", KW_INCBIN },
		{ "include", KW_INCLUDE },
		{ "jr", KW_JR },
		{ "ld", KW_LD },
		{ "line", KW_LINE },
		{ "macro", KW_MACRO },
		{ "nc", KW_NC },
		{ "nop", KW_NOP },
		{ "nz", KW_NZ },
		{ "z", KW_Z },
		{ "", NODE },
		//@@END
	};
};


// Scanner
class Scanner {
public:
	Scanner() {}
	bool scan(const string& text);
	void clear();
	void rewind();
	void next(int num = 1);
	Token& peek(int offset = 0);
	int get_pos() const { return m_pos; }
	void set_pos(int pos) { m_pos = pos; }
	size_t size() const { return m_tokens.size(); }
	void push_back(Token&& token) { m_tokens.push_back(std::move(token)); }

private:
	vector<Token> m_tokens;
	int m_pos{ 0 };

	bool parse_raw_string(const char*& p, string& result);
	bool parse_c_string(const char*& p, string& result);
	bool parse_escape_char(char c, char& result);
	char parse_octal(const char*& p);
	char parse_hex(const char*& p);
};

