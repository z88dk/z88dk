//-----------------------------------------------------------------------------
// z80asm
// utils
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include "xassert.h"
#include <algorithm>
#include <cstdint>
#include <regex>
#include <set>

bool is_ident(const string& ident) {
    if (ident.empty())
        return false;
    else if (!is_ident_start(ident[0]))
        return false;
    else {
        for (auto c : ident) {
            if (!is_ident(c))
                return false;
        }
        return true;
    }
}

int char_digit(char c) {
    return is_digit(c) ? c - '0' : is_xdigit(c) ? 10 + to_upper(c) - 'A' : -1;
}

string str_tolower(string str) {
    std::transform(str.begin(), str.end(), str.begin(), [](char c) {return to_lower(c); });
    return str;
}

string str_toupper(string str) {
    std::transform(str.begin(), str.end(), str.begin(), [](char c) {return to_upper(c); });
    return str;
}

// convert "\xnn" et all to characters
string str_compress_escapes(const string& in) {
	string out;
	int base = 0, max_digits = 0, digit = 0;
	char c;
	const char* num = nullptr;

	for (const char* p = in.c_str(); *p; p++) {
		if (*p == '\\') {
			p++;
			base = 0;
			switch (*p) {
			case '\0':	p--; break;				// trailing backslash - ignore
			case 'a':	out.push_back('\a'); break;
			case 'b':	out.push_back('\b'); break;
			case 'e':	out.push_back('\x1b'); break;
			case 'f':	out.push_back('\f'); break;
			case 'n':	out.push_back('\n'); break;
			case 'r':	out.push_back('\r'); break;
			case 't':	out.push_back('\t'); break;
			case 'v':	out.push_back('\v'); break;
			case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7':
				num = p;						// start of number
				base = 8;
				max_digits = 3;
				// fall through
			case 'x':
				if (base == 0) {				// not octal
					num = ++p;
					base = 16;
					max_digits = 2;
				}
				// convert octal or hex number
				c = 0;
				while (p < num + max_digits &&
					(digit = char_digit(*p)) >= 0 && digit < base) {
					c = c * base + digit;
					p++;
				}
				p--;
				out.push_back(c);
				break;
			default:							// any other char
				out.push_back(*p);
			}
		}
		else
			out.push_back(*p);
	}
	return out;
}

// expand non-ascii chars to "\xnn" et all
string str_expand_escapes(const string& in) {
	string out;
	for (auto c : in) {
		switch (c) {
		case '\a': out += "\\a"; break;
		case '\b': out += "\\b"; break;
		case '\f': out += "\\f"; break;
		case '\n': out += "\\n"; break;
		case '\r': out += "\\r"; break;
		case '\t': out += "\\t"; break;
		case '\v': out += "\\v"; break;
        case '\\': out += "\\\\"; break;
        case '"': out += "\\\""; break;
        default:
			if (c >= 0x20 && c < 0x7f)
				out.push_back(c);
			else if ((c & 0xff) < 8)
				out += "\\" + to_string(c);			// \o
			else {
				std::ostringstream ss;
				ss << "\\x"
					<< std::setfill('0') << std::setw(2)
					<< std::hex << static_cast<unsigned int>(c & 0xff) << std::dec;
				out += ss.str();
			}
		}
	}
	return out;
}

// https://stackoverflow.com/questions/874134/find-out-if-string-ends-with-another-string-in-c
bool str_ends_with(const string& str, const string& ending) {
	if (str.length() >= ending.length())
		return (0 == str.compare(str.length() - ending.length(), ending.length(), ending));
	else
		return false;
}

string str_chomp(const string& str_) {
    string str = str_;
    while (!str.empty() && is_space(str.back()))
        str.pop_back();
    return str;
}

string str_strip(const string& str) {
    const char* p = str.c_str();
    while (*p && is_space(*p))
        p++;
    return str_chomp(p);
}

string str_remove_all_blanks(const string& str) {
    string out;
    for (auto c : str)
        if (!is_space(c))
            out.push_back(c);
    return out;
}

string str_remove_extra_blanks(const string& str) {
	string out;
	for (const char* p = str.c_str(); *p != '\0'; p++) {
        if (!is_space(*p))
			out.push_back(*p);
		else {
			out.push_back(' ');
			while (is_space(p[1]))
				p++;
		}
	}
	return str_strip(out);
}

string str_replace_all(string text, const string& find, const string& replace) {
	size_t p = 0;
	while ((p = text.find(find, p)) != std::string::npos) {
		text.replace(p, find.length(), replace);
		p += replace.length();
	}
	return text;
}

static void expand_glob_1(set<fs::path>& result, const string& pattern);

static void expand_wildcards(set<fs::path>& result,
	const vector<string>& elems, size_t cur_elem) {
	// build prefix and suffix
	fs::path prefix;
    for (size_t i = 0; i < cur_elem; i++) {
        prefix /= fs::path(elems[i]);
    }
    if (prefix.empty()) {
        prefix = ".";
    }

	fs::path suffix;
    for (size_t i = cur_elem + 1; i < elems.size(); i++) {
		suffix /= elems[i];
    }

	// expand current element
	if (elems[cur_elem] == "**") {
		fs::path new_path{ prefix };
		if (!suffix.empty())
			new_path /= suffix;
		expand_glob_1(result, new_path.generic_string());		// recurse

		for (auto& entry : fs::recursive_directory_iterator(prefix)) {
			if (fs::is_directory(entry)) {
				fs::path new_path{ entry };
				if (!suffix.empty())
					new_path /= suffix;
				expand_glob_1(result, new_path.generic_string());		// recurse
			}
			else if (suffix.empty() && fs::is_regular_file(entry)) {
				expand_glob_1(result, entry.path().generic_string());
			}
		}
	}
	else {
		// make a regex pattern
		string pattern = elems[cur_elem];
		pattern = str_replace_all(pattern, ".", "\\.");
		pattern = str_replace_all(pattern, "*", ".*");
		pattern = str_replace_all(pattern, "?", ".");
		std::regex re{ pattern };

		// iterate through directory and recurse for each match
		if (fs::is_directory(prefix)) {
			for (auto& entry : fs::directory_iterator(prefix)) {
				string entry_basename_str = entry.path().filename().generic_string();
				if (regex_match(entry_basename_str, re)) {
					fs::path new_path{ entry };
					if (!suffix.empty())
						new_path /= suffix;
					expand_glob_1(result, new_path.generic_string());		// recurse
				}
			}
		}
	}
}

static void expand_glob_1(set<fs::path>& result, const string& pattern) {
	// split path in directory/file elements
	fs::path full_path{ pattern };
	vector<string> elems;
	for (auto elem : full_path) {
		elems.push_back(elem.generic_string());
	}

	// iterate through element looking for wildcards
	for (size_t i = 0; i < elems.size(); i++) {
		// check if this element has wildcards
		size_t wc_pos = elems[i].find_first_of("?*");
		if (wc_pos != string::npos) {
			expand_wildcards(result, elems, i);
			return;
		}
	}

	// if we reached here, there are no wildcards
	fs::path path{ pattern };
	if (fs::is_directory(path) || fs::is_regular_file(path))
		result.insert(path);
}

// use set in recursion to eliminate duplicates
void expand_glob(vector<fs::path>& result, const string& pattern) {
    set<fs::path> files;
    expand_glob_1(files, pattern);

    // #2380 - remove ./ prefix if it was added during glob search
    bool pattern_has_dot_slash = (pattern.substr(0, 2) == "./");
    for (auto& file : files) {
        string file_str = file.generic_string();

        if (!pattern_has_dot_slash && file_str.substr(0, 2) == "./") {
            // ./ was added during glob search
            file_str.erase(file_str.begin(), file_str.begin() + 2);
        }

        result.push_back(file_str);
    }
}

int ipow(int base, int exp) {
	int result = 1;
	for (;;) {
		if (exp & 1)
			result *= base;
		exp >>= 1;
		if (!exp)
			break;
		base *= base;
	}
	return result;
}

void swrite_int16(int n, ostream& os) {
	os.put((n >> 0) & 0xff);
	os.put((n >> 8) & 0xff);
}

void swrite_int32(int n, ostream& os) {
	os.put((n >> 0) & 0xff);
	os.put((n >> 8) & 0xff);
	os.put((n >> 16) & 0xff);
	os.put((n >> 24) & 0xff);
}

void swrite_string(const string& s, ostream& os) {
	xassert(s.size() <= INT16_MAX);
	swrite_int16(static_cast<int>(s.size()), os);
	os.write(s.c_str(), s.size());
}
