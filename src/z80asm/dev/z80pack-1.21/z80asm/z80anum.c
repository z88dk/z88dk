/*
 *	Z80 - Assembler
 *	Copyright (C) 1987-2014 by Udo Munk
 *
 *	History:
 *	17-SEP-1987 Development under Digital Research CP/M 2.2
 *	28-JUN-1988 Switched to Unix System V.3
 *	21-OCT-2006 changed to ANSI C for modern POSIX OS's
 *	03-FEB-2007 more ANSI C conformance and reduced compiler warnings
 *	18-MAR-2007 use default output file extension dependend on format
 *	04-OCT-2008 fixed comment bug, ';' string argument now working
 *	22-FEB-2014 fixed is...() compiler warnings
 */

/*
 *	modul with numercial computation and conversion
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "z80a.h"
#include "z80aglb.h"

#ifndef isxdigit
#define isxdigit(c) (isdigit(c) || (c>='a' && c<='f') || (c>='A' && c<='F'))
#endif

/*
 *	definitions of operator symbols for expression parser
 */
#define OPEDEC		1	/* decimal number */
#define OPEHEX		2	/* hexadecimal number */
#define OPEOCT		3	/* octal number */
#define OPEBIN		4	/* binary number */
#define OPESUB		5	/* arithmetical - */
#define OPEADD		6	/* arithmetical + */
#define OPEMUL		7	/* arithmetical * */
#define OPEDIV		8	/* arithmetical / */
#define OPEMOD		9	/* arithmetical modulo */
#define OPESHL		10	/* logical shift left */
#define OPESHR		11	/* logical shift right */
#define OPELOR		12	/* logical OR */
#define OPELAN		13	/* logical AND */
#define OPEXOR		14	/* logical XOR */
#define OPECOM		15	/* logical complement */
#define OPESYM		99	/* symbol */

int strval(char *);
int isari(int);
int get_type(char *);
int axtoi(char *);
int abtoi(char *);
int aotoi(char *);

extern struct sym *get_sym(char *);
extern void asmerr(int);

/*
 *	recursive expression parser
 *
 *	Input: pointer to argument rest string
 *
 *	Output: computed value
 */
int eval(char *s)
{
	register char *p;
	register int val;
	char word[MAXLINE];
	struct sym *sp;

	val = 0;
	while (*s) {
		p = word;
		if (*s == '(') {
			s++;
			while (*s != ')') {
				if (*s == '\0') {
					asmerr(E_MISPAR);
					goto eval_break;
				}
				*p++ = *s++;
			}
			*p = '\0';
			s++;
			val = eval(word);
			continue;
		}
		if (*s == STRSEP) {
			s++;
			while (*s != STRSEP) {
				if (*s == '\n' || *s == '\0') {
					asmerr(E_MISHYP);
					goto hyp_error;
				}
				*p++ = *s++;
			}
			s++;
hyp_error:
			*p = '\0';
			val = strval(word);
			continue;
		}
		if (isari(*s))
			*p++ = *s++;
		else
			while (!isspace((int)*s) && !isari(*s) && (*s != '\0'))
				*p++ = *s++;
		*p = '\0';
		switch (get_type(word)) {
		case OPESYM:			/* symbol */
			if (strcmp(word, "$") == 0) {
				val = pc;
				break;
			}
			if (strlen(word) > SYMSIZE)
				word[SYMSIZE] = '\0';
			if ((sp = get_sym(word)) != NULL)
				val = sp->sym_val;
			else
				asmerr(E_UNDSYM);
			break;
		case OPEDEC:			/* decimal number */
			val = atoi(word);
			break;
		case OPEHEX:			/* hexadecimal number */
			val = axtoi(word);
			break;
		case OPEBIN:			/* binary number */
			val = abtoi(word);
			break;
		case OPEOCT:			/* octal number */
			val = aotoi(word);
			break;
		case OPESUB:			/* arithmetical - */
			val -= eval(s);
			goto eval_break;
		case OPEADD:			/* arithmetical + */
			val += eval(s);
			goto eval_break;
		case OPEMUL:			/* arithmetical * */
			val *= eval(s);
			goto eval_break;
		case OPEDIV:			/* arithmetical / */
			val /= eval(s);
			goto eval_break;
		case OPEMOD:			/* arithmetical modulo */
			val %= eval(s);
			goto eval_break;
		case OPESHL:			/* logical shift left */
			val <<= eval(s);
			goto eval_break;
		case OPESHR:			/* logical shift right */
			val >>= eval(s);
			goto eval_break;
		case OPELOR:			/* logical OR */
			val |= eval(s);
			goto eval_break;
		case OPELAN:			/* logical AND */
			val &= eval(s);
			goto eval_break;
		case OPEXOR:			/* logical XOR */
			val ^= eval(s);
			goto eval_break;
		case OPECOM:			/* logical complement */
			val = ~(eval(s));
			goto eval_break;
		}
	}
	eval_break:
	return(val);
}

/*
 *	get typ of operand
 *
 *	Input: pointer to string with operand
 *
 *	Output: operand typ
 */
int get_type(char *s)
{
	if (isdigit((int)*s)) {		/* numerical operand */
		if (isdigit((int)*(s + strlen(s) - 1)))	/* decimal number */
			return(OPEDEC);
		else if (*(s + strlen(s) - 1) == 'H')	/* hexadecimal number */
			return(OPEHEX);
		else if (*(s + strlen(s) - 1) == 'B')	/* binary number */
			return(OPEBIN);
		else if (*(s + strlen(s) - 1) == 'O')	/* octal number */
			return(OPEOCT);
	} else if (*s == '-')		/* arithmetical operand - */
		return(OPESUB);
	else if (*s == '+')		/* arithmetical operand + */
		return(OPEADD);
	else if (*s == '*')		/* arithmetical operand * */
		return(OPEMUL);
	else if (*s == '/')		/* arithmetical operand / */
		return(OPEDIV);
	else if (*s == '%')		/* arithmetical modulo */
		return(OPEMOD);
	else if (*s == '<')		/* logical shift left */
		return(OPESHL);
	else if (*s == '>')		/* logical shift rigth */
		return(OPESHR);
	else if (*s == '|')		/* logical OR */
		return(OPELOR);
	else if (*s == '&')		/* logical AND */
		return(OPELAN);
	else if (*s == '^')		/* logical XOR */
		return(OPEXOR);
	else if (*s == '~')		/* logical complement */
		return(OPECOM);
	return(OPESYM);			/* operand is symbol */
}

/*
 *	check a character for arithmetical operators
 *	+, -, *, /, %, <, >, |, &, ~ and ^
 */
int isari(int c)
{
	return((c) == '+' || (c) == '-' || (c) == '*' ||
	       (c) == '/' || (c) == '%' || (c) == '<' ||
	       (c) == '>' || (c) == '|' || (c) == '&' ||
	       (c) == '~' || (c) == '^');
}

/*
 *	conversion of string with hexadecimal number to integer
 *	format: nnnnH or 0nnnnH if 1st digit > 9
 */
int axtoi(char *str)
{
	register int num;

	num = 0;
	while (isxdigit((int)*str)) {
		num *= 16;
		num += *str - ((*str <= '9') ? '0' : '7');
		str++;
	}
	return(num);
}

/*
 *	conversion of string with octal number to integer
 *	format: nnnnO
 */
int aotoi(char *str)
{
	register int num;

	num = 0;
	while ('0' <= *str && *str <= '7') {
		num *= 8;
		num += (*str++) - '0';
	}
	return(num);
}

/*
 *	conversion of string with binary number to integer
 *	format: nnnnnnnnnnnnnnnnB
 */
int abtoi(char *str)
{
	register int num;

	num = 0;
	while ('0' <= *str && *str <= '1') {
		num *= 2;
		num += (*str++) - '0';
	}
	return(num);
}

/*
 *	convert ASCII string to integer
 */
int strval(char *str)
{
	register int num;

	num = 0;
	while (*str) {
		num <<= 8;
		num += (int) *str++;
	}
	return(num);
}

/*
 *	check value for range -256 < value < 256
 *	Output: value if in range, otherwise 0 and error message
 */
int chk_v1(int i)
{
	if (i >= -255 && i <= 255)
		return(i);
	else {
		asmerr(E_VALOUT);
		return(0);
	}
}

/*
 *	check value for range -128 < value < 128
 *	Output: value if in range, otherwise 0 and error message
 */
int chk_v2(int i)
{
	if (i >= -127 && i <= 127)
		return(i);
	else {
		asmerr(E_VALOUT);
		return(0);
	}
}
