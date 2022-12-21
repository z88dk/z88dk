
#ifndef SYMS_H
#define SYMS_H

#include "uthash.h"

typedef enum {
    SYM_ANY = 0,
    SYM_CONST = 1,
    SYM_ADDRESS = 2,
} symboltype;

typedef struct symbol_file_s symbol_file;
typedef struct symbol_s symbol;

struct symbol_s {
    const char    *name;
    const char    *file;
    const char    *module;
    unsigned int   address;
    symboltype     symtype;
    char           islocal;
    const char    *section;
    symbol        *next;
    int            unique;
    const char    *name_module;
    UT_hash_handle hh;
};

struct symbol_file_s {
    const char    *name;
    symbol        *symbols;
    UT_hash_handle hh;
};

extern symbol* symbol_find_lower(int addr, symboltype preferred_type, uint16_t* offset);
extern void      read_symbol_file(char *filename);
extern const char     *find_symbol(int addr, symboltype preferred_symtype);
extern symbol   *find_symbol_byname(const char *name, const char *filename);
extern int symbol_resolve(char *name, const char *filename);
extern char **parse_words(char *line, int *argc);
extern void symbol_add_autolabel(int addr, char *label);
extern int address_is_code(int addr);
extern void add_data_section(int addr, int end);
#endif
