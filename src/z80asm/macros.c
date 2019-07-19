/*
Z88DK Z80 Macro Assembler

Copyright (C) Paulo Custodio, 2011-2019
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk/

Assembly macros.
*/

#include "macros.h"
#include "alloc.h"
#include "errors.h"
#include "str.h"
#include "strutil.h"
#include "uthash.h"
#include "types.h"
#include "die.h"
#include <ctype.h>

#define Is_ident_prefix(x)	((x)=='.' || (x)=='#' || (x)=='$' || (x)=='%' || (x)=='@')
#define Is_ident_start(x)	(isalpha(x) || (x)=='_')
#define Is_ident_cont(x)	(isalnum(x) || (x)=='_')

//-----------------------------------------------------------------------------
//	#define macros
//-----------------------------------------------------------------------------
typedef struct DefMacro
{
	const char	*name;					// string kept in strpool.h
	argv_t		*params;				// list of formal parameters
	str_t		*text;					// replacement text
	UT_hash_handle hh;      			// hash table
} DefMacro;

static DefMacro *def_macros = NULL;		// global list of #define macros
static argv_t *in_lines = NULL;			// line stream from input
static argv_t *out_lines = NULL;		// line stream to ouput
static str_t *current_line = NULL;		// current returned line
static bool in_defgroup;				// no EQU transformation in defgroup

static DefMacro *DefMacro_add(char *name)
{
	DefMacro *elem;
	HASH_FIND(hh, def_macros, name, strlen(name), elem);
	if (elem) 
		return NULL;		// duplicate

	elem = m_new(DefMacro);
	elem->name = spool_add(name);
	elem->params = argv_new();
	elem->text = str_new();
	HASH_ADD_KEYPTR(hh, def_macros, elem->name, strlen(name), elem);

	return elem;
}

static void DefMacro_delete_elem(DefMacro *elem)
{
	if (elem) {
		argv_free(elem->params);
		str_free(elem->text);
		HASH_DEL(def_macros, elem);
		m_free(elem);
	}
}

static void DefMacro_delete(char *name)
{
	DefMacro *elem;
	HASH_FIND(hh, def_macros, name, strlen(name), elem);
	DefMacro_delete_elem(elem);		// it is OK to undef a non-existing macro
}

static DefMacro *DefMacro_lookup(char *name)
{
	DefMacro *elem;
	HASH_FIND(hh, def_macros, name, strlen(name), elem);
	return elem;
}

void init_macros()
{
	def_macros = NULL;
	in_defgroup = false;
	in_lines = argv_new();
	out_lines = argv_new();
	current_line = str_new();
}

void clear_macros()
{
	DefMacro *elem, *tmp;
	HASH_ITER(hh, def_macros, elem, tmp) {
		DefMacro_delete_elem(elem);
	}
	def_macros = NULL;
	in_defgroup = false;

	argv_clear(in_lines);
	argv_clear(out_lines);
	str_clear(current_line);
}

void free_macros()
{
	clear_macros();

	argv_free(in_lines);
	argv_free(out_lines);
	str_free(current_line);
}

// fill input stream
static void fill_input(getline_t getline_func)
{
	if (argv_len(in_lines) == 0) {
		char *line = getline_func();
		if (line)
			argv_push(in_lines, line);
	}
}

// extract first line from input_stream to current_line
static bool shift_lines(argv_t *lines)
{
	str_clear(current_line);
	if (argv_len(lines) > 0) {
		// copy first from stream
		char *line = *argv_front(lines);
		str_set(current_line, line);
		argv_shift(lines);
		return true;
	}
	else
		return false;
}

// collect a macro or argument name [\.\#]?[a-z_][a-z_0-9]*
static bool collect_name(char **in, UT_string *out)
{
	char *p = *in;

	str_clear(out);
	while (isspace(*p)) p++;

	if (Is_ident_prefix(p[0]) && Is_ident_start(p[1])) {
		str_append_n(out, p, 2); p += 2;
		while (Is_ident_cont(*p)) { str_append_n(out, p, 1); p++; }
		*in = p;
		return true;
	}
	else if (Is_ident_start(p[0])) {
		while (Is_ident_cont(*p)) { str_append_n(out, p, 1); p++; }
		*in = p;
		return true;
	}
	else {
		return false;
	}
}

// collect formal parameters
static bool collect_params(char **p, DefMacro *macro, UT_string *param)
{
#define P (*p)

	if (*P == '(') P++; else return true;
	while (isspace(*P)) P++;
	if (*P == ')') { P++; return true; }

	for (;;) {
		if (!collect_name(p, param)) return false;
		argv_push(macro->params, str_data(param));

		while (isspace(*P)) P++;
		if (*P == ')') { P++; return true; }
		else if (*P == ',') P++;
		else return false;
	}

#undef P
}

// collect macro text
static bool collect_text(char **p, DefMacro *macro, str_t *text)
{
#define P (*p)

	str_clear(text);

	while (isspace(*P)) P++;
	while (*P) {
		if (*P == ';' || *P == '\n') 
			break;
		else if (*P == '\'' || *P == '"') {
			char q = *P; str_append_n(text, P, 1); P++;
			while (*P != q && *P != '\0') {
				if (*P == '\\') {
					str_append_n(text, P, 1); P++;
					if (*P != '\0') {
						str_append_n(text, P, 1); P++;
					}
				}
				else {
					str_append_n(text, P, 1); P++;
				}
			}
			if (*P != '\0') {
				str_append_n(text, P, 1); P++;
			}
		}
		else {
			str_append_n(text, P, 1); P++;
		}
	}

	while (str_len(text) > 0 && isspace(str_data(text)[str_len(text) - 1])) {
		str_len(text)--;
		str_data(text)[str_len(text)] = '\0';
	}

	str_set_str(macro->text, text);

	return true;

#undef P
}

// collect white space up to end of line or comment
static bool collect_eol(char **p)
{
#define P (*p)

	while (isspace(*P)) P++; // consumes also \n and \r
	if (*P == ';' || *P == '\0')
		return true;
	else
		return false;

#undef P
}

// is this an identifier?
static bool collect_ident(char **in, char *ident)
{
	char *p = *in;

	size_t idlen = strlen(ident);
	if (cstr_case_ncmp(p, ident, idlen) == 0 && !Is_ident_cont(p[idlen])) {
		*in = p + idlen;
		return true;
	}
	return false;
}

// is this a "NAME EQU xxx" or "NAME = xxx"?
static bool collect_equ(char **in, UT_string *name)
{
	char *p = *in;

	while (isspace(*p)) p++;

	if (in_defgroup) {
		while (*p != '\0' && *p != ';') {
			if (*p == '}') {
				in_defgroup = false;
				return false;
			}
			p++;
		}
	}
	else if (collect_name(&p, name)) {
		if (cstr_case_cmp(str_data(name), "defgroup") == 0) {
			in_defgroup = true;
			while (*p != '\0' && *p != ';') {
				if (*p == '}') {
					in_defgroup = false;
					return false;
				}
				p++;
			}
			return false;
		}
		
		if (utstring_body(name)[0] == '.') {			// old-style label
			// remove starting dot from name
			UT_string *temp;
			utstring_new(temp);
			utstring_printf(temp, "%s", &utstring_body(name)[1]);
			utstring_clear(name);
			utstring_concat(name, temp);
			utstring_free(temp);
		}
		else if (*p == ':') {							// colon after name
			p++;
		}

		while (isspace(*p)) p++;

		if (*p == '=') {
			*in = p + 1;
			return true;
		}
		else if (Is_ident_start(*p) && collect_ident(&p, "equ")) {
			*in = p;
			return true;
		}
	}
	return false;
}

// collect arguments and expand macro
static void macro_expand(DefMacro *macro, char **p, str_t *out)
{
	if (utarray_len(macro->params) > 0) {
		// collect arguments
		xassert(0);
	}

	str_append(out, str_data(macro->text));
}

// parse #define, #undef and expand macros
static void parse1(str_t *in, str_t *out, str_t *name, str_t *text)
{
	// default output = input
	str_set_str(out, in);

	char *p = str_data(in);

	if (*p == '#') {
		p++;

		if (collect_ident(&p, "define")) {
			str_clear(out);

			// get macro name
			if (!collect_name(&p, name)) {
				error_syntax();
				return;
			}

			// create macro, error if duplicate
			DefMacro *macro = DefMacro_add(str_data(name));
			if (!macro) {
				error_redefined_macro(str_data(name));
				return;
			}

			// get macro params
#if 0
			if (!collect_params(&p, macro, text)) {
				error_syntax();
				return;
			}
#endif

			// get macro text
			if (!collect_text(&p, macro, text)) {
				error_syntax();
				return;
			}
		}
		else if (collect_ident(&p, "undef")) {
			str_clear(out);

			// get macro name
			if (!collect_name(&p, name)) {
				error_syntax();
				return;
			}

			// assert end of line
			if (!collect_eol(&p)) {
				error_syntax();
				return;
			}

			DefMacro_delete(str_data(name));
		}
		else {
		}
	}
	else {	// expand macros
		str_clear(out);
		while (*p != '\0') {
			if ((Is_ident_prefix(p[0]) && Is_ident_start(p[1])) ||
				Is_ident_start(p[0])) {
				// maybe at start of macro call
				collect_name(&p, name);
				DefMacro *macro = DefMacro_lookup(str_data(name));
				if (macro)
					macro_expand(macro, &p, out);
				else {
					// try after prefix
					if (Is_ident_prefix(str_data(name)[0])) {
						str_append_n(out, str_data(name), 1);
						macro = DefMacro_lookup(str_data(name) + 1);
						if (macro)
							macro_expand(macro, &p, out);
						else
							str_append_n(out, str_data(name) + 1, str_len(name) - 1);
					}
					else {
						str_append_n(out, str_data(name), str_len(name));
					}
				}
			}
			else if (*p == '\'' || *p == '"') {
				char q = *p;
				str_append_n(out, p, 1); p++;
				while (*p != q && *p != '\0') {
					if (*p == '\\') {
						str_append_n(out, p, 1); p++;
						if (*p != '\0') {
							str_append_n(out, p, 1); p++;
						}
					}
					else {
						str_append_n(out, p, 1); p++;
					}
				}
				if (*p != '\0') {
					str_append_n(out, p, 1); p++;
				}
			}
			else if (*p == ';') {
				str_append_n(out, "\n", 1); p += strlen(p);		// skip comments
			}
			else {
				str_append_n(out, p, 1); p++;
			}
		}

		// check other commands after macro expansion
		str_set_str(in, out);	// in = out

		p = str_data(in);
		if (collect_equ(&p, name)) {
			str_set_f(out, "defc %s = %s", str_data(name), p);
		}
	}
}

static void parse()
{
	str_t *out, *name, *text;
	out = str_new();
	name = str_new();
	text = str_new();

	parse1(current_line, out, name, text);
	if (str_len(out) > 0) {
		argv_push(out_lines, str_data(out));
	}

	str_free(out);
	str_free(name);
	str_free(text);
}

// get line and call parser
char *macros_getline(getline_t getline_func)
{
	do {
		if (shift_lines(out_lines))
			return str_data(current_line);

		fill_input(getline_func);

		if (!shift_lines(in_lines))
			return NULL;			// end of input

		parse();					// parse current_line, leave output in out_lines
	} while (!shift_lines(out_lines));

	return str_data(current_line);
}


#if 0

extern DefMacro *DefMacro_new();
extern void DefMacro_free(DefMacro **self);
extern DefMacro *DefMacro_add(DefMacro **self, char *name, char *text);
extern void DefMacro_add_param(DefMacro *macro, char *param);
extern DefMacro *DefMacro_parse(DefMacro **self, char *line);

/*-----------------------------------------------------------------------------
*   #define macros
*----------------------------------------------------------------------------*/

void DefMacro_free(DefMacro ** self)
{
}

void DefMacro_add_param(DefMacro *macro, char *param)
{
	argv_push(macro->params, param);
}

// parse #define macro[(arg,arg,...)] text
// return NULL if no #define, or macro pointer if #define found and parsed
DefMacro *DefMacro_parse(DefMacro **self, char *line)
{
	char *p = line;
	while (*p != '\0' && isspace(*p)) p++;			// blanks
	if (*p != '#') return NULL;						// #
	p++; while (*p != '\0' && isspace(*p)) p++;		// blanks
	if (strncmp(p, "define", 6) != 0) return NULL;	// define
	p += 6;


	return NULL;
}


#endif
