//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2024
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

//@@.h

#include <algorithm>
#include <cassert>
#include <cctype>
#include <cstring>
#include <deque>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <list>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

//-----------------------------------------------------------------------------
// Utilities
//-----------------------------------------------------------------------------

string str_to_lower(string input);
bool str_ends_with(const string& str, const string& ending);
string binary_to_c_string(const unsigned char* data, size_t length);
bool is_ident(char c);
bool read_custom_line(ifstream& stream, string& line);

//@@.cpp

//-----------------------------------------------------------------------------
// Utilities
//-----------------------------------------------------------------------------

string str_to_lower(string input) {
	std::transform(input.begin(), input.end(), input.begin(),
		[](unsigned char c) { return std::tolower(c); });
	return input;
}

bool str_ends_with(const string& str, const string& ending) {
	if (str.length() >= ending.length())
		return (0 == str.compare(str.length() - ending.length(), ending.length(), ending));
	else
		return false;
}

string binary_to_c_string(const unsigned char* data, size_t length) {
	ostringstream out;
	out << '"';  // Start of C string literal

	for (size_t i = 0; i < length; ++i) {
		unsigned char c = data[i];

		switch (c) {
		case '\n': out << "\\n"; break;
		case '\r': out << "\\r"; break;
		case '\t': out << "\\t"; break;
		case '\v': out << "\\v"; break;
		case '\b': out << "\\b"; break;
		case '\f': out << "\\f"; break;
		case '\a': out << "\\a"; break;
		case '\\': out << "\\\\"; break;
		case '\"': out << "\\\""; break;
		default:
			if (isprint(c)) {
				out << c;
			}
			else {
				out << "\\x"
					<< hex << setw(2) << setfill('0')
					<< static_cast<int>(c);
			}
		}
	}

	out << '"';  // End of C string literal
	return out.str();
}

bool is_ident(char c) {
	return c == '_' || isalnum(c);
}

bool read_custom_line(ifstream& stream, string& line) {
    line.clear();
    char ch;
    while (stream.get(ch)) {
        if (ch == '\n') {
            // Unix-style \n or part of \r\n (Windows)
            break;
        }
        else if (ch == '\r') {
            // Could be Mac-style \r or Windows-style \r\n
            if (stream.peek() == '\n') {
                stream.get(); // consume the \n
            }
            break;
        }
        else {
            line += ch;
        }
    }
    return !line.empty() || !stream.eof();
}


//@@.h

//-----------------------------------------------------------------------------
// Location of an input line
//-----------------------------------------------------------------------------

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

//@@.cpp

//-----------------------------------------------------------------------------
// Location of an input line
//-----------------------------------------------------------------------------

Location g_location;

Location::Location(const string& filename, int line_num)
	: m_filename(filename), m_line_num(line_num) {
	clear_text();
}

void Location::clear() {
	m_filename.clear();
	m_line_num = 0;
	clear_text();
}

void Location::clear_text() {
	m_text.clear();
	m_expanded_text.clear();
}

bool Location::empty() const {
	return m_filename.empty() && m_line_num == 0;
}

void Location::set_filename(const string& filename) {
	m_filename = filename; 
	m_line_num = 0; 
	m_text.clear(); 
	m_expanded_text.clear();
}

void Location::set_line_num(int line_num) {
	m_line_num = line_num; 
	m_text.clear(); 
	m_expanded_text.clear();
}

void Location::set_text(const string& text) { 
	m_text = text; 
	m_expanded_text.clear();
}

void Location::set_expanded_text(const string& expanded_text) {
	if (expanded_text == m_text)
		m_expanded_text.clear();
	else
		m_expanded_text = expanded_text;
}

//@@.h

//-----------------------------------------------------------------------------
// Error message output and counting
//-----------------------------------------------------------------------------

class Error {
public:
	int get_count() const { return m_count; }
	void error_expected_eol() { error("expected end of line"); }
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

//@@.cpp

//-----------------------------------------------------------------------------
// error message output and counting
//-----------------------------------------------------------------------------

Error g_error;

void Error::error(const string& message, const string& arg) {
	m_count++;
	output_message("error", message, arg);
}

void Error::warning(const string& message, const string& arg) {
	output_message("warning", message, arg);
}

void Error::output_message(const string& prefix, const string& message, const string& arg) {
	if (!g_location.empty()) 
		cerr << g_location.get_filename() << ":" << g_location.get_line_num() << ": ";
	cerr << prefix << ": " << message;
	if (!arg.empty())
		cerr << ": " << arg;
	cerr << endl;
	if (!g_location.get_text().empty()) {
		cerr << "  ^---- " << g_location.get_text() << endl;
		if (!g_location.get_expanded_text().empty())
			cerr << "    ^---- " << g_location.get_expanded_text() << endl;
	}		
}

//@@.h

//-----------------------------------------------------------------------------
// Stack of input files
//-----------------------------------------------------------------------------

class InputFiles {
public:
	InputFiles() {}
	InputFiles(const InputFiles& other) = delete;
	virtual ~InputFiles();
	InputFiles& operator=(const InputFiles& other) = delete;

	void push_file(const string& filename);
	bool getline(string& line);

private:
	struct File {
		string filename;
		int line_num{ 0 };
		int line_inc{ 1 };
		ifstream ifs;
	};
	list<File*> m_files; // stack of input files

	void pop_file();
	bool already_included(const string& filename);
};

extern InputFiles g_input_files;

//@@.cpp

//-----------------------------------------------------------------------------
// Stack of input files
//-----------------------------------------------------------------------------

InputFiles g_input_files;

InputFiles::~InputFiles() {
	while (!m_files.empty())
		pop_file();
}

void InputFiles::push_file(const string& filename) {
	File* file = new File;
	file->filename = filename;
	if (already_included(filename)) {
		g_error.error_recursive_include(filename);
	}
	else {
		file->ifs.open(filename, ios::binary);
		if (!file->ifs.is_open())
			g_error.error_open_file(filename);
		else
			g_location = Location(filename);
	}
	m_files.push_back(file);
}

void InputFiles::pop_file() {
	assert(!m_files.empty());
	File* file = m_files.back();
	if (file->ifs.is_open())
		file->ifs.close();
	m_files.pop_back();
	delete file;
	if (m_files.empty()) {
		g_location.clear();
	}
	else {
		file = m_files.back();
		g_location = Location(file->filename, file->line_num);
	}
}

bool InputFiles::already_included(const string& filename) {
	for (auto& file : m_files)
		if (file->filename == filename)
			return true;
	return false;
}

bool InputFiles::getline(string& line) {
	line.clear();
	while (!m_files.empty()) {
		File* file = m_files.back();
		if (file->ifs.is_open() && read_custom_line(file->ifs, line)) {
			file->line_num += file->line_inc;
			while (!line.empty() && line[line.size() - 1] == '\\') {	// read continuation line
				line[line.size() - 1] = ' ';
				string cont;
				if (file->ifs.is_open() && read_custom_line(file->ifs, cont)) {
					file->line_num += file->line_inc;
					line += cont;
				}
			}
			g_location = Location(file->filename, file->line_num);
			g_location.set_text(line);
			return true;
		}
		else {
			pop_file();
		}
	}
	return false;
}

//@@.h

//-----------------------------------------------------------------------------
// Tokens returned from Scanner
//-----------------------------------------------------------------------------

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
		CONST_EXPR,
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
		NEWLINE,
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
		KW_B,
		KW_BINARY,
		KW_C,
		KW_C_LINE,
		KW_EQU,
		KW_INCBIN,
		KW_INCLUDE,
		KW_JR,
		KW_LD,
		KW_LINE,
		KW_NC,
		KW_NOP,
		KW_NZ,
		KW_Z,
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
	static string concat(const string& s1, const string& s2);

private:
	Type m_type{ END };
	bool m_blank_before{ false };
	Keyword m_keyword{ NONE };
	int m_ivalue{ 0 };
	double m_fvalue{ 0.0 };
	string m_svalue;

	static string lookup_type(Type type);

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
		{ CONST_EXPR, "" },
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
		{ NEWLINE, "\n" },
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
		{ "b", KW_B },
		{ "binary", KW_BINARY },
		{ "c", KW_C },
		{ "c_line", KW_C_LINE },
		{ "equ", KW_EQU },
		{ "incbin", KW_INCBIN },
		{ "include", KW_INCLUDE },
		{ "jr", KW_JR },
		{ "ld", KW_LD },
		{ "line", KW_LINE },
		{ "nc", KW_NC },
		{ "nop", KW_NOP },
		{ "nz", KW_NZ },
		{ "z", KW_Z },
		{ "", NONE },
		//@@END
	};
};

//@@.cpp

//-----------------------------------------------------------------------------
// Tokens returned from Scanner
//-----------------------------------------------------------------------------

Token::Token(Type type, bool blank_before)
	: m_type(type), m_blank_before(blank_before) {
}

void Token::set_keyword(const string& text) {
	m_keyword = lookup_keyword(text);
	m_svalue = text;
}

string Token::to_string() const {
	switch (m_type) {
	case IDENT:
		return m_svalue;
	case INT:
		return std::to_string(m_ivalue);
	case FLOAT:
		return std::to_string(m_fvalue);
	case STR:
		return binary_to_c_string(reinterpret_cast<const unsigned char*>(m_svalue.c_str()), m_svalue.size());
	case RAW_STR:
		return "\"" + m_svalue + "\"";		// syntax error in a later stage if string contains '"'
	default:
		return lookup_type(m_type);
	}
}

string Token::concat(const string& s1, const string& s2) {
	if (s1.empty() || s2.empty())
		return s1 + s2;
	else if (str_ends_with(s1, "##"))   // cpp-style concatenation
		return s1.substr(0, s1.length() - 2) + s2;
	else if (isspace(s1.back()) || isspace(s2.front()))
		return s1 + s2;
	else if (is_ident(s1.back()) && is_ident(s2.front()))
		return s1 + " " + s2;
	else if (s1.back() == '$' && isxdigit(s2.front()))
		return s1 + " " + s2;
	else if ((s1.back() == '%' || s1.back() == '@') &&
		(isdigit(s2.front()) || s2.front() == '"'))
		return s1 + " " + s2;
	else if ((s1.back() == '&' && s2.front() == '&') ||
		(s1.back() == '|' && s2.front() == '|') ||
		(s1.back() == '^' && s2.front() == '^') ||
		(s1.back() == '*' && s2.front() == '*') ||
		(s1.back() == '<' && (s2.front() == '=' || s2.front() == '<' || s2.front() == '>')) ||
		(s1.back() == '>' && (s2.front() == '=' || s2.front() == '>')) ||
		(s1.back() == '=' && s2.front() == '=') ||
		(s1.back() == '!' && s2.front() == '=') ||
		(s1.back() == '#' && s2.front() == '#'))
		return s1 + " " + s2;
	else
		return s1 + s2;
}

string Token::lookup_type(Type type) {
	auto it = types.find(type);
	if (it == types.end())
		return"";
	else
		return it->second;
}

Token::Keyword Token::lookup_keyword(const string& text) {
	auto it = keywords.find(str_to_lower(text));
	if (it == keywords.end())
		return NONE;
	else
		return it->second;
}

//@@.h

//-----------------------------------------------------------------------------
// Scanner
//-----------------------------------------------------------------------------

class Scanner {
public:
	Scanner() {}
	Scanner(std::initializer_list<Token> tokens);
	bool scan(const string& text);
	void clear();
	void rewind();
	void next(int num = 1);
	Token& peek(int offset = 0);
	void push_back(const Token& token) { m_tokens.push_back(token); } // copy
	void push_back(Token&& token) { m_tokens.push_back(std::move(token)); } // move
	int get_pos() const { return m_pos; }
	void set_pos(int pos) { m_pos = pos; }
	size_t size() const { return m_tokens.size(); }
	string to_string() const;

private:
	vector<Token> m_tokens;
	int m_pos{ 0 };

	bool parse_raw_string(const char*& p, string& result);
	bool parse_c_string(const char*& p, string& result);
	bool parse_escape_char(char c, char& result);
	char parse_octal(const char*& p);
	char parse_hex(const char*& p);
};

//@@.cpp

//-----------------------------------------------------------------------------
// Scanner
//-----------------------------------------------------------------------------

Scanner::Scanner(std::initializer_list<Token> tokens) {
	m_tokens = tokens;
}

void Scanner::clear() {
	m_tokens.clear();
	m_pos = 0;
}

bool Scanner::scan(const string& text) {
	clear();
	const char* p = text.c_str();
	while (*p != '\0') {
		const char* p0 = p;
		bool blank_before = false;
		string arg;
		Token::Keyword keyword = Token::NONE;

		switch (*p++) {
			// Uppercase A-Z
		case 'A': case 'B': case 'C': case 'D': case 'E':
		case 'F': case 'G': case 'H': case 'I': case 'J':
		case 'K': case 'L': case 'M': case 'N': case 'O':
		case 'P': case 'Q': case 'R': case 'S': case 'T':
		case 'U': case 'V': case 'W': case 'X': case 'Y': case 'Z':

			// Lowercase a-z
		case 'a': case 'b': case 'c': case 'd': case 'e':
		case 'f': case 'g': case 'h': case 'i': case 'j':
		case 'k': case 'l': case 'm': case 'n': case 'o':
		case 'p': case 'q': case 'r': case 's': case 't':
		case 'u': case 'v': case 'w': case 'x': case 'y': case 'z':

			// Underscore
		case '_':
			while (is_ident(*p))
				++p;
			if (*p == '\'')
				++p;

			// handle alternate registers
			arg = string(p0, p);
			keyword = Token::lookup_keyword(arg);
			if (keyword == Token::NONE && arg.back() == '\'') {	// not alternate register
				--p;
				arg.pop_back();
				keyword = Token::lookup_keyword(arg);
			}

			if (keyword == Token::KW_ASMPC) {
				m_tokens.emplace_back(Token::ASMPC, blank_before);
			}
			else {
				m_tokens.emplace_back(Token::IDENT, blank_before);
				m_tokens.back().set_keyword(arg);
			}
			break;

			// Digits
		case '0': case '1': case '2': case '3': case '4':
		case '5': case '6': case '7': case '8': case '9':
			while (isdigit(*p))
				++p;
			arg = string(p0, p);
			m_tokens.emplace_back(Token::INT, blank_before);
			m_tokens.back().set_ivalue(std::stoi(arg));
			break;

			// Symbols
		case '+': m_tokens.emplace_back(Token::PLUS, blank_before); break;
		case '-': m_tokens.emplace_back(Token::MINUS, blank_before); break;
		case '/': m_tokens.emplace_back(Token::DIV, blank_before); break;
		case '%': m_tokens.emplace_back(Token::MOD, blank_before); break;
		case '$': m_tokens.emplace_back(Token::ASMPC, blank_before); break;
		case '(': m_tokens.emplace_back(Token::LPAREN, blank_before); break;
		case ')': m_tokens.emplace_back(Token::RPAREN, blank_before); break;
		case ',': m_tokens.emplace_back(Token::COMMA, blank_before); break;
		case '.': m_tokens.emplace_back(Token::DOT, blank_before); break;
		case ':': m_tokens.emplace_back(Token::COLON, blank_before); break;
		case '?': m_tokens.emplace_back(Token::QUEST, blank_before); break;
		case ']': m_tokens.emplace_back(Token::RSQUARE, blank_before); break;
		case '[': m_tokens.emplace_back(Token::LSQUARE, blank_before); break;
		case '{': m_tokens.emplace_back(Token::LBRACE, blank_before); break;
		case '}': m_tokens.emplace_back(Token::RBRACE, blank_before); break;
		case '~': m_tokens.emplace_back(Token::BIN_NOT, blank_before); break;
		case '\\': m_tokens.emplace_back(Token::BACKSLASH, blank_before); break;

		case '!':
			if (*p == '=') {
				++p;
				m_tokens.emplace_back(Token::NE, blank_before);
			}
			else {
				m_tokens.emplace_back(Token::LOG_NOT, blank_before);
			}
			break;

		case '#':
			if (*p == '#') {
				++p;
				m_tokens.emplace_back(Token::DHASH, blank_before);
			}
			else {
				m_tokens.emplace_back(Token::HASH, blank_before);
			}
			break;

		case '&':
			if (*p == '&') {
				++p;
				m_tokens.emplace_back(Token::LOG_AND, blank_before);
			}
			else {
				m_tokens.emplace_back(Token::BIN_AND, blank_before);
			}
			break;

		case '*':
			if (*p == '*') {
				++p;
				m_tokens.emplace_back(Token::POWER, blank_before);
			}
			else {
				m_tokens.emplace_back(Token::MULT, blank_before);
			}
			break;

		case '<':
			if (*p == '=') {
				++p;
				m_tokens.emplace_back(Token::LE, blank_before);
			}
			else if (*p == '<') {
				++p;
				m_tokens.emplace_back(Token::LSHIFT, blank_before);
			}
			else if (*p == '>') {
				++p;
				m_tokens.emplace_back(Token::NE, blank_before);
			}
			else {
				m_tokens.emplace_back(Token::LT, blank_before);
			}
			break;

		case '=':
			if (*p == '=') {
				++p;
				m_tokens.emplace_back(Token::EQ, blank_before);
			}
			else {
				m_tokens.emplace_back(Token::EQ, blank_before);
			}
			break;

		case '>':
			if (*p == '=') {
				++p;
				m_tokens.emplace_back(Token::GE, blank_before);
			}
			else if (*p == '>') {
				++p;
				m_tokens.emplace_back(Token::RSHIFT, blank_before);
			}
			else {
				m_tokens.emplace_back(Token::GT, blank_before);
			}
			break;

		case '^':
			if (*p == '^') {
				++p;
				m_tokens.emplace_back(Token::LOG_XOR, blank_before);
			}
			else {
				m_tokens.emplace_back(Token::BIN_XOR, blank_before);
			}
			break;

		case '|':
			if (*p == '|') {
				++p;
				m_tokens.emplace_back(Token::LOG_OR, blank_before);
			}
			else {
				m_tokens.emplace_back(Token::BIN_OR, blank_before);
			}
			break;

			// String
		case '"':
			--p;
			if (!m_tokens.empty() && 
				(m_tokens.back().is(Token::KW_INCLUDE) ||
				m_tokens.back().is(Token::KW_BINARY) ||
				m_tokens.back().is(Token::KW_INCBIN) ||
				m_tokens.back().is(Token::KW_LINE) ||
				m_tokens.back().is(Token::KW_C_LINE))) {
				if (parse_raw_string(p, arg)) {
					m_tokens.emplace_back(Token::RAW_STR, blank_before);
					m_tokens.back().set_svalue(arg);
				}
				else {
					clear();
					return false;
				}
			}
			else {
				if (parse_c_string(p, arg)) {
					m_tokens.emplace_back(Token::STR, blank_before);
					m_tokens.back().set_svalue(arg);
				}
				else {
					clear();
					return false;
				}
			}
			break;

			// Quoted character
		case '\'':
			--p;
			if (!m_tokens.empty() &&
				(m_tokens.back().is(Token::KW_INCLUDE) ||
					m_tokens.back().is(Token::KW_BINARY) ||
					m_tokens.back().is(Token::KW_INCBIN) ||
					m_tokens.back().is(Token::KW_LINE) ||
					m_tokens.back().is(Token::KW_C_LINE))) {
				if (parse_raw_string(p, arg)) {
					m_tokens.emplace_back(Token::RAW_STR, blank_before);
					m_tokens.back().set_svalue(arg);
				}
				else {
					clear();
					return false;
				}
			}
			else {
				if (parse_c_string(p, arg)) {
					if (arg.size() == 1) {
						m_tokens.emplace_back(Token::INT, blank_before);
						m_tokens.back().set_ivalue(static_cast<int>(arg[0]));
					}
					else {
						g_error.error_invalid_quoted_char();
						clear();
						return false;
					}
				}
				else {
					clear();
					return false;
				}
			}
			break;

            // White space
        case '\n':
            m_tokens.emplace_back(Token::NEWLINE, blank_before);
            break;

        case ' ': case '\t': case '\v': case '\f': case '\r':
            blank_before = true;
            break;

            // Comments
        case ';':
            p += strlen(p);
            break;

        default:
			g_error.error_invalid_char(*p);
			clear();
			return false;
		}
	}

	return true;
}

void Scanner::rewind() {
	m_pos = 0;
}

void Scanner::next(int num) {
	m_pos += num;
}

Token& Scanner::peek(int offset) {
	static Token end;
	int pos = m_pos + offset;
	if (pos >= 0 && pos < static_cast<int>(m_tokens.size()))
		return m_tokens[pos];
	else
		return end;
}

bool Scanner::parse_raw_string(const char*& p, string& result) {
	char quote = *p++;
	result.clear();
	while (*p != quote && *p != '\0') {
		result += *p++;
	}
	if (*p != quote) {
		g_error.error_unterminated_string();
		result.clear();
		return false;
	}
	else {
		++p;
	}

	return true;
}

bool Scanner::parse_c_string(const char*& p, string& result) {
	char quote = *p++;
	result.clear();
	while (*p != quote && *p != '\0') {
		if (*p == '\\') {
			++p;
			if (*p == '\0') {
				g_error.error_unterminated_string();
				result.clear();
				return false;
			}
			else if (*p >= '0' && *p <= '7') {
				result += parse_octal(p);
			}
			else if (*p == 'x' && isxdigit(p[1])) {
				++p; // skip 'x'
				result += parse_hex(p);
			}
			else {
				char result_char = '\0';
				if (parse_escape_char(*p++, result_char)) {
					result += result_char;
				}
				else {
					result.clear();
					return false;
				}
			}
		}
		else {
			result += *p++;
		}
	}
	if (*p != quote) {
		g_error.error_unterminated_string();
		result.clear();
		return false;
	}
	else {
		++p;
	}

	return true;
}

bool Scanner::parse_escape_char(char c, char& result) {
	result = '\0';
	switch (c) {
	case 'n':  result = '\n'; return true;
	case 't':  result= '\t'; return true;
	case 'r':  result= '\r'; return true;
	case 'b':  result= '\b'; return true;
	case 'f':  result= '\f'; return true;
	case 'a':  result= '\a'; return true;
	case 'v':  result= '\v'; return true;
	case 'e':  result= '\x1b'; return true;
	case '\\': result= '\\'; return true;
	case '\'': result= '\''; return true;
	case '\"': result= '\"'; return true;
	case '?':  result= '\?'; return true;
	default:
		g_error.error_invalid_escape_char(c);
		return false;
	}
}

char Scanner::parse_octal(const char*& p) {
	int value = 0;
	int count = 0;
	while (count < 3 && *p >= '0' && *p <= '7') {
		value = (value * 8) + (*p - '0');
		++p;
		++count;
	}
	return static_cast<char>(value);
}

char Scanner::parse_hex(const char*& p) {
	int value = 0;
	while (isxdigit(*p)) {
		value *= 16;
		if (*p >= '0' && *p <= '9') {
			value += (*p - '0');
		}
		else if (*p >= 'a' && *p <= 'f') {
			value += (*p - 'a' + 10);
		}
		else if (*p >= 'A' && *p <= 'F') {
			value += (*p - 'A' + 10);
		}
		++p;
	}
	return static_cast<char>(value);
}

string Scanner::to_string() const {
	string result;
	for (auto& token : m_tokens) {
		result = Token::concat(result, token.to_string());
	}
	return result;
}

//@@.h

//-----------------------------------------------------------------------------
// Macro preprocessor
//-----------------------------------------------------------------------------

class Preproc {
public:
	void clear();
	void expand(const string& input_line);
	bool getline(string& line);

private:
	deque<string> m_expanded_lines;
	Scanner m_in;
	Scanner m_out;

	void expand_macros();
	void collect_statement();
	void push_out();
	void check_end();
};

extern Preproc g_preproc;

//@@.cpp

//-----------------------------------------------------------------------------
// Macro preprocessor
//-----------------------------------------------------------------------------

Preproc g_preproc;

void Preproc::clear() {
	m_expanded_lines.clear();
	m_in.clear();
	m_out.clear();
}

void Preproc::expand(const string & input_line) {
	m_in.scan(input_line);
	expand_macros();
	while (!m_in.peek().is(Token::END)) {
		m_out.clear();
		// EQU
		if (m_in.peek(0).is(Token::DOT) && m_in.peek(1).is(Token::IDENT) && m_in.peek(2).is(Token::KW_EQU)) {
			m_out.push_back(m_in.peek(1)); // IDENT
			m_out.push_back(m_in.peek(2)); // equ
			m_in.next(3);
			collect_statement();
			push_out();
		}
		// EQU
		else if (m_in.peek(0).is(Token::IDENT) && m_in.peek(1).is(Token::COLON) && m_in.peek(2).is(Token::KW_EQU)) {
			m_out.push_back(m_in.peek(0)); // IDENT
			m_out.push_back(m_in.peek(2)); // equ
			m_in.next(3);
			collect_statement();
			push_out();
		}
		// EQU
		else if (m_in.peek(0).is(Token::IDENT) && m_in.peek(1).is(Token::KW_EQU)) {
			m_out.push_back(m_in.peek(0)); // IDENT
			m_out.push_back(m_in.peek(1)); // equ
			m_in.next(2);
			collect_statement();
			push_out();
		}
		// .ASSUME
		else if (m_in.peek(0).is(Token::DOT) && m_in.peek(1).is(Token::KW_ASSUME)) {
			m_out.push_back(m_in.peek(1)); // ASSUME
			m_in.next(2);
			collect_statement();
			push_out();
		}
		// .label
		else if (m_in.peek(0).is(Token::DOT) && m_in.peek(1).is(Token::IDENT)) {
			m_out.push_back(m_in.peek(1)); // IDENT
			m_out.push_back(Token(Token::COLON, false)); // :
			m_in.next(2);
			push_out();
		}
		// label:
		else if (m_in.peek(0).is(Token::IDENT) && m_in.peek(1).is(Token::COLON)) {
			m_out.push_back(m_in.peek(0)); // IDENT
			m_out.push_back(Token(Token::COLON, false)); // :
			m_in.next(2);
			push_out();
		}
		// INCLUDE
		else if (m_in.peek(0).is(Token::KW_INCLUDE) && m_in.peek(1).is(Token::RAW_STR)) {
			string filename = m_in.peek(1).get_svalue();
			m_in.next(2);
			check_end();
			g_input_files.push_file(filename);
		}
		else {
			collect_statement();
			push_out();
		}
	}
}

void Preproc::collect_statement() {
	while (!m_in.peek().is(Token::END)) {
		if (m_in.peek().is(Token::COLON) || m_in.peek().is(Token::BACKSLASH)) {
			m_in.next();
			return;
		}
		else {
			m_out.push_back(m_in.peek());
			m_in.next();
		}
	}
}

void Preproc::expand_macros() {
	// TODO
}

bool Preproc::getline(string& line) {
	line.clear();
	while (true) {
		if (m_expanded_lines.empty()) {
			return false;
		}
		else {
			line = m_expanded_lines.front();
			m_expanded_lines.pop_front();
			if (!line.empty())
				return true;
		}
	}
}

void Preproc::push_out() {
	string line = m_out.to_string();
	m_expanded_lines.push_back(line);
	m_out.clear();
}

void Preproc::check_end() {
	if (!m_in.peek().is(Token::END)) {
		g_error.error_expected_eol();
		m_in.clear();
	}
}

//@@.h

//-----------------------------------------------------------------------------
// Line parser
//-----------------------------------------------------------------------------

class LineParser {
public:
    bool parse(const string& line);

private:
    Scanner m_line;         // tokens from the current line

    // each element to match in a rule
    struct RuleElem {
        Token::Type type{ Token::END };
        Token::Keyword keyword{ Token::NONE };

        RuleElem(Token::Type type_) : type(type_) {}
        RuleElem(Token::Keyword keyword_) : keyword(keyword_) {}
    };

    // list of rules

    // Rule 1: NOP
    static inline RuleElem rule_elems_1[] = {
        RuleElem(Token::KW_NOP),
        RuleElem(Token::END)
    };

    // Rule 2: LD A, A
    static inline RuleElem rule_elems_2[] = {
        RuleElem(Token::KW_LD),
        RuleElem(Token::KW_A),
        RuleElem(Token::COMMA),
        RuleElem(Token::KW_A),
        RuleElem(Token::END)
    };

    // Rule 3: LD A, B
    static inline RuleElem rule_elems_3[] = {
        RuleElem(Token::KW_LD),
        RuleElem(Token::KW_A),
        RuleElem(Token::COMMA),
        RuleElem(Token::KW_B),
        RuleElem(Token::END)
    };


    static inline RuleElem* rules[] = {
        nullptr,
        rule_elems_1, // Rule 1: NOP
        rule_elems_2, // Rule 1: LD A, A
        rule_elems_3, // Rule 1: LD A, B
    };

    static void execute_action(int n);

    static void execute_action_1();     // Action 1: NOP
    static void execute_action_2();     // Action 2: LD A, A
    static void execute_action_3();     // Action 3: LD A, B
};

//@@.cpp

//-----------------------------------------------------------------------------
// Line parser
//-----------------------------------------------------------------------------

bool LineParser::parse(const string& line) {
    if (!m_line.scan(line))
        return false;       // scanning failed

    if (m_line.peek().is(Token::END))
        return true;        // empty line

    // initialize the possible list of rules with the first token
    list<int> possible_rules;
    for (int i = 1; i < static_cast<int>(sizeof(rules) / sizeof(rules[0])); ++i) {
        if (rules[i][0].keyword != Token::NONE && m_line.peek().is(rules[i][0].keyword)) {
            possible_rules.push_back(i);
        }
        else if (m_line.peek().is(rules[i][0].type)) {
            possible_rules.push_back(i);
        }
    }

    // search for a matching rule
    for (int n = 0; true; ++n) {
        if (possible_rules.empty()) {
            return false; // no matching rule found
        }

        for (auto rule : possible_rules) {
            if (rules[rule][n].keyword != Token::NONE && m_line.peek(n).is(rules[rule][n].keyword)) {
                // found a matching rule by keyword
            }
            else if (rules[rule][n].type == Token::END) {
                // end of rule reached, check if all tokens matched
                if (m_line.peek(n).is(rules[rule][n].type)) {
                    // all tokens matched, rule is valid
                }
                else {
                    possible_rules.remove(rule); // remove rule if it doesn't match
                }
            }
            else if (m_line.peek(n).is(rules[rule][n].type)) {
                // found a matching rule by type
            }
            else {
                possible_rules.remove(rule); // remove rule if it doesn't match
            }
        }
    }

    if (possible_rules.size() == 1) {
        // only one rule matched, execute action and return true
        execute_action(possible_rules.front());
        return true;
    }
    else {
        // multiple rules matched, return false
        return false;
    }
}

void LineParser::execute_action(int n) {
    switch (n) {
    case 1: execute_action_1(); break;
    default: assert(0);
    }
}

// Action 1: NOP
void LineParser::execute_action_1() {
    //add_opcode_void(0x00);
}

// Action 2: LD A, A
void LineParser::execute_action_2() {
    //add_opcode_void(0x00);
}

// Action 2: LD A, B
void LineParser::execute_action_3() {
    //add_opcode_void(0x00);
}

//@@test

//-----------------------------------------------------------------------------
// Test
//-----------------------------------------------------------------------------

void parse_file(const string& filename) {
	g_input_files.push_file(filename);
	string line;
	while (g_input_files.getline(line)) {
		g_preproc.expand(line);
		string expanded_line;
		while (g_preproc.getline(expanded_line)) {
			g_location.set_expanded_text(expanded_line);
			cout << g_location.get_filename() << ":" << g_location.get_line_num() << ": " << line << endl << expanded_line << endl;
            LineParser parser;
            if (!parser.parse(expanded_line))
                cout << "parse failed" << endl;
		}
	}
}

int main(int argc, char* argv[]) {
	for (int i = 1; i < argc; i++) {
		g_preproc.clear();
		parse_file(argv[i]);
	}
}
