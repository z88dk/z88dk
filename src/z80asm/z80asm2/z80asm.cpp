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
		COLON,
		COMMA,
		CONST_EXPR,
		DHASH,
		DOT,
		EXPR,
		FLOAT,
		HASH,
		IDENT,
		INT,
		LBRACE,
		LPAREN,
		LSQUARE,
		NEWLINE,
		OPERAT,
		QUEST,
		RAW_STR,
		RBRACE,
		RPAREN,
		RSQUARE,
		STR,
		//@@END
	};

    enum Operat {
        //@@BEGIN: operator
        OP_NONE,
        OP_BIN_AND,
        OP_BIN_NOT,
        OP_BIN_OR,
        OP_BIN_XOR,
        OP_DIV,
        OP_EQ,
        OP_GE,
        OP_GT,
        OP_LE,
        OP_LOG_AND,
        OP_LOG_NOT,
        OP_LOG_OR,
        OP_LOG_XOR,
        OP_LSHIFT,
        OP_LT,
        OP_MINUS,
        OP_MOD,
        OP_MULT,
        OP_NE,
        OP_PLUS,
        OP_POWER,
        OP_RSHIFT,
        OP_TERNARY,
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
    Operat get_operat() const { return m_operat; }

	void set_ivalue(int ivalue) { m_ivalue = ivalue; }
	void set_fvalue(double fvalue) { m_fvalue = fvalue; }
	void set_svalue(const string& svalue) { m_svalue = svalue; }
	void set_keyword(const string& text);
    void set_operat(Operat operat) { m_operat = operat; }

	bool is(Type type) const { return m_type == type; }
	bool is(Keyword keyword) const { return m_keyword == keyword; }
    bool is_end() const;

	string to_string() const;

    static string lookup_operat(Operat operat);
    static Keyword lookup_keyword(const string& text);
	static string concat(const string& s1, const string& s2);

private:
	Type m_type{ END };
	bool m_blank_before{ false };
	Keyword m_keyword{ NONE };
    Operat m_operat{ OP_NONE };
	int m_ivalue{ 0 };
	double m_fvalue{ 0.0 };
	string m_svalue;

	static string lookup_type(Type type);

	static inline unordered_map<Type, string> types = {
		//@@BEGIN: type_map
		{ ASMPC, "$" },
		{ BACKSLASH, "\\" },
		{ COLON, ":" },
		{ COMMA, "," },
		{ CONST_EXPR, "" },
		{ DHASH, "##" },
		{ DOT, "." },
		{ END, "" },
		{ EXPR, "" },
		{ FLOAT, "" },
		{ HASH, "#" },
		{ IDENT, "" },
		{ INT, "" },
		{ LBRACE, "{" },
		{ LPAREN, "(" },
		{ LSQUARE, "[" },
		{ NEWLINE, "\n" },
		{ OPERAT, "" },
		{ QUEST, "?" },
		{ RAW_STR, "" },
		{ RBRACE, "}" },
		{ RPAREN, ")" },
		{ RSQUARE, "]" },
		{ STR, "" },
		//@@END
	};

	static inline unordered_map<Operat, string> operators = {
		//@@BEGIN: operator_map
		{ OP_BIN_AND, "&" },
		{ OP_BIN_NOT, "~" },
		{ OP_BIN_OR, "|" },
		{ OP_BIN_XOR, "^" },
		{ OP_DIV, "/" },
		{ OP_EQ, "=" },
		{ OP_GE, ">=" },
		{ OP_GT, ">" },
		{ OP_LE, "<=" },
		{ OP_LOG_AND, "&&" },
		{ OP_LOG_NOT, "!" },
		{ OP_LOG_OR, "||" },
		{ OP_LOG_XOR, "^^" },
		{ OP_LSHIFT, "<<" },
		{ OP_LT, "<" },
		{ OP_MINUS, "-" },
		{ OP_MOD, "%" },
		{ OP_MULT, "*" },
		{ OP_NE, "<>" },
		{ OP_NONE, "" },
		{ OP_PLUS, "+" },
		{ OP_POWER, "**" },
		{ OP_RSHIFT, ">>" },
		{ OP_TERNARY, "?:" },
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

bool Token::is_end() const {
    return is(Token::NEWLINE) || is(Token::COLON) || is(Token::BACKSLASH);
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
    case OPERAT:
        return lookup_operat(m_operat);
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
		return "";
	else
		return it->second;
}

string Token::lookup_operat(Operat operat) {
    auto it = operators.find(operat);
    if (it == operators.end())
        return "";
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
	Scanner(vector<Token>& tokens);
	bool scan(const string& text);
	void clear();
	void rewind();
	void next(int num = 1);
	Token& peek(int offset = 0);
    Token& operator[](int pos);
    Token& front();
    Token& back();
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

Scanner::Scanner(vector<Token>& tokens) {
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

            // Operatos
        case '+': m_tokens.emplace_back(Token::OPERAT, blank_before); m_tokens.back().set_operat(Token::OP_PLUS); break;
        case '-': m_tokens.emplace_back(Token::OPERAT, blank_before); m_tokens.back().set_operat(Token::OP_MINUS); break;
        case '/': m_tokens.emplace_back(Token::OPERAT, blank_before); m_tokens.back().set_operat(Token::OP_DIV); break;
        case '%': m_tokens.emplace_back(Token::OPERAT, blank_before); m_tokens.back().set_operat(Token::OP_MOD); break;
        case '~': m_tokens.emplace_back(Token::OPERAT, blank_before); m_tokens.back().set_operat(Token::OP_BIN_NOT); break;

        case '*':
            if (*p == '*') {
                ++p;
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_POWER);
            }
            else {
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_MULT);
            }
            break;

        case '=':
            if (*p == '=') {
                ++p;
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_EQ);
            }
            else {
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_EQ);
            }
            break;

        case '!':
            if (*p == '=') {
                ++p;
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_NE);
            }
            else {
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_LOG_NOT);
            }
            break;

        case '&':
            if (*p == '&') {
                ++p;
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_LOG_AND);
            }
            else {
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_BIN_AND);
            }
            break;

        case '<':
            if (*p == '=') {
                ++p;
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_LE);
            }
            else if (*p == '<') {
                ++p;
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_LSHIFT);
            }
            else if (*p == '>') {
                ++p;
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_NE);
            }
            else {
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_LT);
            }
            break;

        case '>':
            if (*p == '=') {
                ++p;
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_GE);
            }
            else if (*p == '>') {
                ++p;
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_RSHIFT);
            }
            else {
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_GT);
            }
            break;

        case '^':
            if (*p == '^') {
                ++p;
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_LOG_XOR);
            }
            else {
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_BIN_XOR);
            }
            break;

        case '|':
            if (*p == '|') {
                ++p;
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_LOG_OR);
            }
            else {
                m_tokens.emplace_back(Token::OPERAT, blank_before);
                m_tokens.back().set_operat(Token::OP_BIN_OR);
            }
            break;

            // Symbols
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
		case '\\': m_tokens.emplace_back(Token::BACKSLASH, blank_before); break;

		case '#':
			if (*p == '#') {
				++p;
				m_tokens.emplace_back(Token::DHASH, blank_before);
			}
			else {
				m_tokens.emplace_back(Token::HASH, blank_before);
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

Token& Scanner::operator[](int pos) {
    static Token end;
    if (pos >= 0 && pos < static_cast<int>(m_tokens.size()))
        return m_tokens[pos];
    else
        return end;
}

Token& Scanner::front() {
    static Token end;
    if (m_tokens.empty())
        return end;
    else
        return m_tokens.front();
}

Token& Scanner::back() {
    static Token end;
    if (m_tokens.empty())
        return end;
    else
        return m_tokens.back();
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
    string autolabel();

private:
	deque<string> m_expanded_lines;
	Scanner m_in;
	Scanner m_out;
    int m_autolabel_id{ 1 };

    void define_asmpc(const string& asmpc);
    bool has_asmpc();
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
    m_autolabel_id = 1;
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
        // ASMPC - needs to be after label:
        else if (has_asmpc()) {
            string asmpc = autolabel();
            
            // output label
            m_out.push_back(Token(Token::IDENT, false));
            m_out.back().set_svalue(asmpc);
            m_out.push_back(Token(Token::COLON, false)); // :

            // replace ASMPC by label in next statement
            define_asmpc(asmpc);
        }
		// #INCLUDE
		else if (m_in.peek(0).is(Token::HASH) && m_in.peek(1).is(Token::KW_INCLUDE) && m_in.peek(2).is(Token::RAW_STR)) {
			string filename = m_in.peek(2).get_svalue();
			m_in.next(3);
			check_end();
			g_input_files.push_file(filename);
		}
		// INCLUDE
		else if (m_in.peek(0).is(Token::KW_INCLUDE) && m_in.peek(1).is(Token::RAW_STR)) {
			string filename = m_in.peek(1).get_svalue();
			m_in.next(2);
			check_end();
			g_input_files.push_file(filename);
		}
		// Handle one statement, possibly empty
		else {
			collect_statement();
			push_out();
		}
	}
}

void Preproc::collect_statement() {
	while (!m_in.peek().is(Token::END)) {
		if (m_in.peek().is_end()) {
			m_in.next();
			return;
		}
		else {
			m_out.push_back(m_in.peek());
			m_in.next();
		}
	}
}

void Preproc::define_asmpc(const string& asmpc) {
    for (int i = 0; i < static_cast<int>(m_in.size()); ++i) {
        if (m_in[i].is(Token::ASMPC)) {
            m_in[i] = Token(Token::IDENT, false);
            m_in[i].set_svalue(asmpc);
        }
    }
}

bool Preproc::has_asmpc() {
    for (int i = 0; i < static_cast<int>(m_in.size()); ++i) {
        if (m_in[i].is_end())
            return false;
        else if (m_in[i].is(Token::ASMPC))
            return true;
    }
    return false;
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

string Preproc::autolabel() {
    return string("__") + std::to_string(m_autolabel_id++);
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
// Expression
//-----------------------------------------------------------------------------

class Expr {
public:
    bool parse(const string& line);
    bool parse(const Scanner& in) { (void)in; return false; }

private:
    Scanner m_tokens;

    enum class Associativity {
        Left,
        Right
    };

    enum class Arity {
        Unary,
        Binary,
        Ternary
    };

    struct OperatorInfo {
        int precedence;
        Associativity associativity;
        Arity arity;
    };

    class OperatorTable {
    public:
        static const OperatorInfo& get_info(Token::Operat operat);

    private:
        static inline const unordered_map<Token::Operat, OperatorInfo> table = {
            // Precedence levels based on standard C precedence

            // power
            {Token::OP_POWER,   {14, Associativity::Right, Arity::Binary}},

            // Unary (prefix): + - ! ~ ++ -- (not * or & here)
            {Token::OP_PLUS,    {13, Associativity::Right, Arity::Unary}},
            {Token::OP_MINUS,   {13, Associativity::Right, Arity::Unary}},
            {Token::OP_LOG_NOT, {13, Associativity::Right, Arity::Unary}},
            {Token::OP_BIN_NOT, {13, Associativity::Right, Arity::Unary}},

            // Multiplicative
            {Token::OP_MULT,    {12, Associativity::Left, Arity::Binary}},
            {Token::OP_DIV,     {12, Associativity::Left, Arity::Binary}},
            {Token::OP_MOD,     {12, Associativity::Left, Arity::Binary}},

            // Additive
            {Token::OP_PLUS,    {11, Associativity::Left, Arity::Binary}},
            {Token::OP_MINUS,   {11, Associativity::Left, Arity::Binary}},

            // Shift
            {Token::OP_LSHIFT,  {10, Associativity::Left, Arity::Binary}},
            {Token::OP_RSHIFT,  {10, Associativity::Left, Arity::Binary}},

            // Relational
            {Token::OP_LT,      {9, Associativity::Left, Arity::Binary}},
            {Token::OP_LE,      {9, Associativity::Left, Arity::Binary}},
            {Token::OP_GT,      {9, Associativity::Left, Arity::Binary}},
            {Token::OP_GE,      {9, Associativity::Left, Arity::Binary}},

            // Equality
            {Token::OP_EQ,      {8, Associativity::Left, Arity::Binary}},
            {Token::OP_NE,      {8, Associativity::Left, Arity::Binary}},

            // Bitwise AND, XOR, OR
            {Token::OP_BIN_AND, {7, Associativity::Left, Arity::Binary}},
            {Token::OP_BIN_XOR, {6, Associativity::Left, Arity::Binary}},
            {Token::OP_BIN_OR,  {5, Associativity::Left, Arity::Binary}},

            // Logical AND/OR
            {Token::OP_LOG_AND, {4, Associativity::Left, Arity::Binary}},
            {Token::OP_LOG_XOR, {3, Associativity::Left, Arity::Binary}},
            {Token::OP_LOG_OR,  {2, Associativity::Left, Arity::Binary}},

            // Ternary
            {Token::OP_TERNARY, {1, Associativity::Right, Arity::Ternary}},
        };
    };
};

//@@.cpp

//-----------------------------------------------------------------------------
// Expression
//-----------------------------------------------------------------------------

const Expr::OperatorInfo & Expr::OperatorTable::get_info(Token::Operat operat) {
    auto it = table.find(operat);
    if (it == table.end()) throw std::runtime_error("Unknown operator: " + Token::lookup_operat(operat));
    return it->second;
}


bool Expr::parse(const string& line) {
    Scanner in;
    if (!in.scan(line))
        return false;   // scan failed
    else if (!parse(in))
        return false;   // parse failed
    else if (!in.peek().is_end())
        return false;   // extra input
    else
        return true;
}

//@@.h

//-----------------------------------------------------------------------------
// Object Module
//-----------------------------------------------------------------------------

class ObjectModule {
public:
    void clear();
    void add_constant(const string& name, int value) { m_symbols[name] = value; }
    void add_label(const string& name) { m_symbols[name] = 0; }
    void set_assume(int value) { m_assume = value; }
    void add_opcode_void(long long opcode) { (void)opcode; }
    void add_opcode_jr(long long opcode, int value) { (void)opcode; (void)value; }
    void add_opcode_n(long long opcode, int value) { (void)opcode; (void)value; }
    void add_opcode_nn(long long opcode, int value) { (void)opcode; (void)value; }

private:
    unordered_map<string, int> m_symbols;
    int m_assume{ 0 };
};

extern ObjectModule g_object_module;

//@@.cpp

//-----------------------------------------------------------------------------
// Object Module
//-----------------------------------------------------------------------------

ObjectModule g_object_module;

void ObjectModule::clear() {
    m_symbols.clear();
    m_assume = 0;
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

    //@@BEGIN:actions_decl
    void action_ident_colon();
    void action_ident_kw_equ_expr();
    void action_kw_assume_expr();
    void action_kw_nop();
    void action_kw_jr_expr();
    void action_kw_jr_kw_nz_comma_expr();
    void action_kw_jr_kw_z_comma_expr();
    void action_kw_jr_kw_nc_comma_expr();
    void action_kw_jr_kw_c_comma_expr();
    void action_kw_ld_kw_a_comma_expr();
    void action_kw_ld_kw_a_comma_lparen_expr_rparen();
    void action_kw_ld_kw_a_comma_kw_a();
    void action_kw_ld_kw_a_comma_kw_b();
    //@@END

    // state in the parsing state machine
	struct State {
		unordered_map<Token::Keyword, int>	keyword_next;
		unordered_map<Token::Type, int>		type_next;
		void(LineParser::*action)();
	};

	static inline State m_states[] = {
		//@@BEGIN: states
		{ /* 0:  */
		  { {Token::KW_ASSUME, 7}, {Token::KW_JR, 10}, {Token::KW_LD, 29}, {Token::KW_NOP, 42}, },
		  { {Token::IDENT, 1}, },
		  nullptr,
		},
		{ /* 1: IDENT */
		  { {Token::KW_EQU, 4}, },
		  { {Token::COLON, 2}, },
		  nullptr,
		},
		{ /* 2: IDENT COLON */
		  { },
		  { {Token::END, 3}, },
		  nullptr,
		},
		{ /* 3: IDENT COLON END */
		  { },
		  { },
		  &LineParser::action_ident_colon,
		},
		{ /* 4: IDENT KW_EQU */
		  { },
		  { {Token::EXPR, 5}, },
		  nullptr,
		},
		{ /* 5: IDENT KW_EQU EXPR */
		  { },
		  { {Token::END, 6}, },
		  nullptr,
		},
		{ /* 6: IDENT KW_EQU EXPR END */
		  { },
		  { },
		  &LineParser::action_ident_kw_equ_expr,
		},
		{ /* 7: KW_ASSUME */
		  { },
		  { {Token::EXPR, 8}, },
		  nullptr,
		},
		{ /* 8: KW_ASSUME EXPR */
		  { },
		  { {Token::END, 9}, },
		  nullptr,
		},
		{ /* 9: KW_ASSUME EXPR END */
		  { },
		  { },
		  &LineParser::action_kw_assume_expr,
		},
		{ /* 10: KW_JR */
		  { {Token::KW_C, 13}, {Token::KW_NC, 17}, {Token::KW_NZ, 21}, {Token::KW_Z, 25}, },
		  { {Token::EXPR, 11}, },
		  nullptr,
		},
		{ /* 11: KW_JR EXPR */
		  { },
		  { {Token::END, 12}, },
		  nullptr,
		},
		{ /* 12: KW_JR EXPR END */
		  { },
		  { },
		  &LineParser::action_kw_jr_expr,
		},
		{ /* 13: KW_JR KW_C */
		  { },
		  { {Token::COMMA, 14}, },
		  nullptr,
		},
		{ /* 14: KW_JR KW_C COMMA */
		  { },
		  { {Token::EXPR, 15}, },
		  nullptr,
		},
		{ /* 15: KW_JR KW_C COMMA EXPR */
		  { },
		  { {Token::END, 16}, },
		  nullptr,
		},
		{ /* 16: KW_JR KW_C COMMA EXPR END */
		  { },
		  { },
		  &LineParser::action_kw_jr_kw_c_comma_expr,
		},
		{ /* 17: KW_JR KW_NC */
		  { },
		  { {Token::COMMA, 18}, },
		  nullptr,
		},
		{ /* 18: KW_JR KW_NC COMMA */
		  { },
		  { {Token::EXPR, 19}, },
		  nullptr,
		},
		{ /* 19: KW_JR KW_NC COMMA EXPR */
		  { },
		  { {Token::END, 20}, },
		  nullptr,
		},
		{ /* 20: KW_JR KW_NC COMMA EXPR END */
		  { },
		  { },
		  &LineParser::action_kw_jr_kw_nc_comma_expr,
		},
		{ /* 21: KW_JR KW_NZ */
		  { },
		  { {Token::COMMA, 22}, },
		  nullptr,
		},
		{ /* 22: KW_JR KW_NZ COMMA */
		  { },
		  { {Token::EXPR, 23}, },
		  nullptr,
		},
		{ /* 23: KW_JR KW_NZ COMMA EXPR */
		  { },
		  { {Token::END, 24}, },
		  nullptr,
		},
		{ /* 24: KW_JR KW_NZ COMMA EXPR END */
		  { },
		  { },
		  &LineParser::action_kw_jr_kw_nz_comma_expr,
		},
		{ /* 25: KW_JR KW_Z */
		  { },
		  { {Token::COMMA, 26}, },
		  nullptr,
		},
		{ /* 26: KW_JR KW_Z COMMA */
		  { },
		  { {Token::EXPR, 27}, },
		  nullptr,
		},
		{ /* 27: KW_JR KW_Z COMMA EXPR */
		  { },
		  { {Token::END, 28}, },
		  nullptr,
		},
		{ /* 28: KW_JR KW_Z COMMA EXPR END */
		  { },
		  { },
		  &LineParser::action_kw_jr_kw_z_comma_expr,
		},
		{ /* 29: KW_LD */
		  { {Token::KW_A, 30}, },
		  { },
		  nullptr,
		},
		{ /* 30: KW_LD KW_A */
		  { },
		  { {Token::COMMA, 31}, },
		  nullptr,
		},
		{ /* 31: KW_LD KW_A COMMA */
		  { {Token::KW_A, 34}, {Token::KW_B, 36}, },
		  { {Token::EXPR, 32}, {Token::LPAREN, 38}, },
		  nullptr,
		},
		{ /* 32: KW_LD KW_A COMMA EXPR */
		  { },
		  { {Token::END, 33}, },
		  nullptr,
		},
		{ /* 33: KW_LD KW_A COMMA EXPR END */
		  { },
		  { },
		  &LineParser::action_kw_ld_kw_a_comma_expr,
		},
		{ /* 34: KW_LD KW_A COMMA KW_A */
		  { },
		  { {Token::END, 35}, },
		  nullptr,
		},
		{ /* 35: KW_LD KW_A COMMA KW_A END */
		  { },
		  { },
		  &LineParser::action_kw_ld_kw_a_comma_kw_a,
		},
		{ /* 36: KW_LD KW_A COMMA KW_B */
		  { },
		  { {Token::END, 37}, },
		  nullptr,
		},
		{ /* 37: KW_LD KW_A COMMA KW_B END */
		  { },
		  { },
		  &LineParser::action_kw_ld_kw_a_comma_kw_b,
		},
		{ /* 38: KW_LD KW_A COMMA LPAREN */
		  { },
		  { {Token::EXPR, 39}, },
		  nullptr,
		},
		{ /* 39: KW_LD KW_A COMMA LPAREN EXPR */
		  { },
		  { {Token::RPAREN, 40}, },
		  nullptr,
		},
		{ /* 40: KW_LD KW_A COMMA LPAREN EXPR RPAREN */
		  { },
		  { {Token::END, 41}, },
		  nullptr,
		},
		{ /* 41: KW_LD KW_A COMMA LPAREN EXPR RPAREN END */
		  { },
		  { },
		  &LineParser::action_kw_ld_kw_a_comma_lparen_expr_rparen,
		},
		{ /* 42: KW_NOP */
		  { },
		  { {Token::END, 43}, },
		  nullptr,
		},
		{ /* 43: KW_NOP END */
		  { },
		  { },
		  &LineParser::action_kw_nop,
		},
		//@@END
	};
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


    int state = 0;
    while (true) {
        Token& token = m_line.peek();
        if (token.is(Token::END)) {
            break;  // end of line
        }
        if (state < 0 || state >= static_cast<int>(std::size(m_states))) {
            //g_error.error_invalid_state(state);
            return false;
        }
        auto& current_state = m_states[state];
        if (current_state.keyword_next.count(token.get_keyword()) > 0) {
            state = current_state.keyword_next[token.get_keyword()];
        }
        else if (current_state.type_next.count(token.get_type()) > 0) {
            state = current_state.type_next[token.get_type()];
        }
        else {
            //g_error.error_invalid_token(token.to_string());
            return false;
        }
        if (current_state.action) {
            (this->*current_state.action)();
        }
    }

    return true;
}

//@@BEGIN:actions_impl
void LineParser::action_ident_colon() {
	g_object_module.add_label(m_line[1].get_svalue());


}

void LineParser::action_ident_kw_equ_expr() {
	g_object_module.add_constant(m_line[1].get_svalue(), m_line[3].get_ivalue());


}

void LineParser::action_kw_assume_expr() {
	g_object_module.set_assume(m_line[2].get_ivalue());


}

void LineParser::action_kw_nop() {
	g_object_module.add_opcode_void(0x00);


}

void LineParser::action_kw_jr_expr() {
	g_object_module.add_opcode_jr(0x18, m_line[4].get_ivalue());


}

void LineParser::action_kw_jr_kw_nz_comma_expr() {
	g_object_module.add_opcode_jr(0x20, m_line[4].get_ivalue());


}

void LineParser::action_kw_jr_kw_z_comma_expr() {
	g_object_module.add_opcode_jr(0x28, m_line[4].get_ivalue());


}

void LineParser::action_kw_jr_kw_nc_comma_expr() {
	g_object_module.add_opcode_jr(0x30, m_line[4].get_ivalue());


}

void LineParser::action_kw_jr_kw_c_comma_expr() {
	g_object_module.add_opcode_jr(0x38, m_line[4].get_ivalue());


}

void LineParser::action_kw_ld_kw_a_comma_expr() {
	g_object_module.add_opcode_n(0x3E, m_line[4].get_ivalue());


}

void LineParser::action_kw_ld_kw_a_comma_lparen_expr_rparen() {
	g_object_module.add_opcode_nn(0x3A, m_line[4].get_ivalue());


}

void LineParser::action_kw_ld_kw_a_comma_kw_a() {
	g_object_module.add_opcode_void(0x7F);


}

void LineParser::action_kw_ld_kw_a_comma_kw_b() {
	g_object_module.add_opcode_void(0x78);

}

//@@END

//@@test

//-----------------------------------------------------------------------------
// Test
//-----------------------------------------------------------------------------

void parse_file(const string& filename) {
    g_preproc.clear();
    g_object_module.clear();

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
		parse_file(argv[i]);
	}
}

