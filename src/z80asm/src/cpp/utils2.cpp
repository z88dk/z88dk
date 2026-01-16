//-----------------------------------------------------------------------------
// z80asm
// utils
// Copyright (C) Paulo Custodio, 2011-2026
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#include "utils.h"
#include "utils2.h"
#include "xassert.h"
#include <algorithm>
#include <cstdint>
#include <iterator>
#include <regex>
#include <set>

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

// https://www.bing.com/search?q=c%2B%2B+split+blank+delimited+string+into+vector+of+stringsd&showconv=1&sendquery=1&form=WSBQFC&qs=SW&cvid=286798d5917e488fb05cbeda30b71104&pq=c%2B%2B+split+blank+delimited+string+into+vector+of+stringsd&cc=PT&setlang=en-US&nclid=9310176510014EEEAB71B45D62C6D720&ts=1703540528160&wsso=Moderate
vector<string> split(const string& s) {
    istringstream iss(s);
    vector<string> tokens{ istream_iterator<string>{iss},
                           istream_iterator<string>{} };
    return tokens;
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
