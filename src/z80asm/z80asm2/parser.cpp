
// Utilities

string strtolower(string input) {
	std::transform(input.begin(), input.end(), input.begin(),
		[](unsigned char c) { return std::tolower(c); });
	return input;
}


// Location of an input line
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


// error message output and counting
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


// Stack of input files
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

static bool read_custom_line(ifstream& stream, string& line) {
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

bool InputFiles::getline(string& line) {
	line.clear();
	if (m_files.empty())
		return false;
	File* file = m_files.back();
	if (!file->ifs.good())
		return false;
	if (read_custom_line(file->ifs, line)) {
		file->line_num += file->line_inc;
		while (line[line.size() - 1] == '\\') {		// read continuation line
			line[line.size() - 1] = ' ';
			string cont;
			if (read_custom_line(file->ifs, cont)) {
				file->line_num += file->line_inc;
				line += cont;
			}
		}
		g_location = Location(file->filename, file->line_num);
		g_location.set_text(line);
		return true;
	}
	else {
		g_location.clear_text();
		return false;
	}
}


// Tokens returned from Scanner
Token::Token(Type type, bool blank_before)
	: m_type(type), m_blank_before(blank_before) {
}

void Token::set_keyword(const string& text) {
	m_keyword = lookup_keyword(text);
	m_svalue = text;
}

string Token::lookup_type(Type type) {
	auto it = types.find(type);
	if (it == types.end())
		return"";
	else
		return it->second;
}

Token::Keyword Token::lookup_keyword(const string& text) {
	auto it = keywords.find(strtolower(text));
	if (it == keywords.end())
		return NONE;
	else
		return it->second;
}


// Scanner
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
			while (isalnum(*p) || *p == '_')
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

			if (keyword == Token::ASMPC) {
				m_tokens.emplace_back(Token::ASMPC, blank_before);
			}
			else if (keyword == Token::KW_ASSUME) {		// remove preceedig dot
				if (!m_tokens.empty() && m_tokens.back().is(Token::DOT))
					m_tokens.pop_back();
				m_tokens.emplace_back(Token::IDENT, blank_before);
				m_tokens.back().set_keyword(arg);
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

			// White space
		case ' ': case '\t': case '\v': case '\f': case '\r': case '\n':
			blank_before = true;
			break;

			// Comments
		case ';':
			p += strlen(p);
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
	static Token empty;
	int pos = m_pos + offset;
	if (pos >= 0 && pos < static_cast<int>(m_tokens.size()))
		return m_tokens[pos];
	else
		return empty;
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

//@@test
void parse_file(const string& filename) {
	g_input_files.push_file(filename);
	string line;
	while (g_input_files.getline(line)) {
		string expanded_line = g_preproc.expand(line);
		g_location.set_expanded_text(expanded_line);
		cout << g_location.get_filename() << ":" << g_location.get_line_num() << ": " << line << endl << expanded_line << endl;
	}
	g_input_files.pop_file();
}

int main(int argc, char* argv[]) {
	for (int i = 1; i < argc; i++) {
		g_preproc.clear();
		parse_file(argv[i]);
	}
}
