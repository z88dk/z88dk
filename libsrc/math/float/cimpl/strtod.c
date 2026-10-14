/*
 *	strtod (C90 decimal form)
 *
 *	Public domain parser by Yasuhiro Matsumoto, tidied for soft
 *	float by Paul Humphreys. Hexadecimal floating values are C99
 *	and are not accepted here.
 */


#include <ctype.h>

/* 1e400 overflows every float format built from cimpl. */
static double strtod_pow10(int exp)
{
	double ten;
	double result;
	int neg;
	int i;

	ten = 10.0;
	neg = 0;
	if (exp < 0) {
		neg = 1;
		exp = -exp;
	}
	if (exp > 400)
		exp = 400;
	result = 1.0;
	for (i = 0; i < exp; ++i)
		result = result * ten;
	if (neg) {
		if (exp == 400)
			return 0.0;
		result = 1.0 / result;
	}
	return result;
}

double strtod(const char *nptr, char **endptr)
{
	const char *p;
	const char *end;
	double value;
	double frac;
	double base;
	double ten;
	int negative;
	int saw_digit;

	ten = 10.0;
	p = nptr;
	end = nptr;
	value = 0.0;
	negative = 0;
	saw_digit = 0;

	while (isspace((unsigned char)*p))
		++p;

	// A run of signs is accepted. "--1" is +1.
	while (*p == '+' || *p == '-') {
		if (*p == '-')
			negative = !negative;
		++p;
	}

	if (isdigit((unsigned char)*p)) {
		saw_digit = 1;
		value = (double)(*p - '0');
		++p;
		while (isdigit((unsigned char)*p)) {
			value = value * ten + (double)(*p - '0');
			++p;
		}
		end = p;
	} else if (*p != '.') {
		if (endptr != 0)
			*endptr = (char *)nptr;
		return 0.0;
	}

	if (negative)
		value = -value;

	if (*p == '.') {
		++p;
		frac = 0.0;
		base = 1.0 / ten;
		while (isdigit((unsigned char)*p)) {
			frac = frac + base * (double)(*p - '0');
			base = base / ten;
			saw_digit = 1;
			++p;
		}
		if (negative)
			value = value - frac;
		else
			value = value + frac;
		if (saw_digit)
			end = p;
	}

	if (saw_digit && (*p == 'e' || *p == 'E')) {
		const char *exp_p;
		int exp_sign;
		int exponent;

		exp_p = p + 1;
		exp_sign = 1;
		if (*exp_p == '+') {
			++exp_p;
		} else if (*exp_p == '-') {
			exp_sign = -1;
			++exp_p;
		}
		if (isdigit((unsigned char)*exp_p)) {
			exponent = 0;
			while (isdigit((unsigned char)*exp_p)) {
				// Keep the product inside a 16-bit int.
				if (exponent < 1000)
					exponent = exponent * 10 + (*exp_p - '0');
				++exp_p;
			}
			value = value * strtod_pow10(exp_sign * exponent);
			end = exp_p;
		}
	}

	if (!saw_digit)
		end = nptr;
	if (endptr != 0)
		*endptr = (char *)end;
	return value;
}
