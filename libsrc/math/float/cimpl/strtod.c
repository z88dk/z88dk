/*
 *	strtod (C90 decimal form and C99 hexadecimal form)
 *
 *	Public domain parser by Yasuhiro Matsumoto, tidied for soft
 *	float by Paul Humphreys. A C99 hexadecimal value is a 0x prefix,
 *	hexadecimal digits with an optional point, then an optional
 *	power-of-two exponent. The exponent is p or P, an optional sign,
 *	and decimal digits. inf and nan are left unrecognized.
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

/* 2^400 overflows every float format built from cimpl. */
static double strtod_pow2(int exp)
{
	double result;
	int neg;
	int i;

	neg = 0;
	if (exp < -400)
		return 0.0;
	if (exp < 0) {
		neg = 1;
		exp = -exp;
	}
	if (exp > 400)
		exp = 400;
	result = 1.0;
	i = exp;
	while (i >= 8) {
		result = result * 256.0;
		i -= 8;
	}
	while (i > 0) {
		result = result * 2.0;
		--i;
	}
	if (neg) {
		if (exp == 400)
			return 0.0;
		result = 1.0 / result;
	}
	return result;
}

static int strtod_hex_value(int c)
{
	if (c >= '0' && c <= '9')
		return c - '0';
	if (c >= 'a' && c <= 'f')
		return c - 'a' + 10;
	if (c >= 'A' && c <= 'F')
		return c - 'A' + 10;
	return -1;
}

/* p points at the leading 0. Return 0 when the text is not a hex float. */
static const char *strtod_hex(const char *p, double *number)
{
	const char *exp_p;
	double value;
	double frac;
	double base;
	double sixteen;
	int digit;
	int saw_digit;
	int exp_sign;
	int exponent;

	sixteen = 16.0;
	if (*p != '0')
		return 0;
	++p;
	if (*p != 'x' && *p != 'X')
		return 0;
	++p;

	value = 0.0;
	saw_digit = 0;
	digit = strtod_hex_value((unsigned char)*p);
	while (digit >= 0) {
		value = value * sixteen + (double)digit;
		saw_digit = 1;
		++p;
		digit = strtod_hex_value((unsigned char)*p);
	}

	if (*p == '.') {
		++p;
		frac = 0.0;
		base = 1.0 / sixteen;
		digit = strtod_hex_value((unsigned char)*p);
		while (digit >= 0) {
			frac = frac + base * (double)digit;
			base = base / sixteen;
			saw_digit = 1;
			++p;
			digit = strtod_hex_value((unsigned char)*p);
		}
		value = value + frac;
	}

	if (!saw_digit)
		return 0;

	if (*p == 'p' || *p == 'P') {
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
			// A zero mantissa stays zero. 0 * 2^n would be a NaN
			// once the power overflows.
			if (value != 0.0)
				value = value * strtod_pow2(exp_sign * exponent);
			p = exp_p;
		}
	}

	*number = value;
	return p;
}

double strtod(const char *nptr, char **endptr)
{
	const char *p;
	const char *end;
	double value;
	double frac;
	double base;
	double ten;
	const char *hex_end;
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

	// "0x" with no hex digits stays a decimal zero ending on the x.
	if (*p == '0' && (*(p + 1) == 'x' || *(p + 1) == 'X')) {
		hex_end = strtod_hex(p, &value);
		if (hex_end != 0) {
			if (negative)
				value = -value;
			if (endptr != 0)
				*endptr = (char *)hex_end;
			return value;
		}
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
