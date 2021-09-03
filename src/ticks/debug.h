#ifndef DEBUG_H
#define DEBUG_H

#include "uthash.h"
#include "utlist.h"


typedef struct cfile_s cfile;
typedef struct type_record_s type_record;
typedef struct type_chain_s type_chain;
typedef struct address_space_s address_space;
typedef struct debug_sym_function_s debug_sym_function;
typedef struct debug_sym_symbol_s debug_sym_symbol;
typedef struct debug_sym_function_argument_s debug_sym_function_argument;

typedef struct {
    int             line;
    int             address;
    cfile          *file;
    int             level;
    int             scope_block;
    UT_hash_handle  hh;
} cline;

struct cfile_s {
    char          *file;
    cline         *lines;
    UT_hash_handle hh;
};

enum function_scope_t {
    FUNCTION_SCOPE_GLOBAL = 0,
    FUNCTION_SCOPE_FILE,
    FUNCTION_SCOPE_FUNCTION,
    };

enum symbol_scope_t {
    SYMBOL_SCOPE_GLOBAL = 0,
    SYMBOL_SCOPE_FILE,
    SYMBOL_SCOPE_LOCAL
};

enum type_record_type {
    TYPE_UNKNOWN = 0,
    TYPE_FUNCTION,
    TYPE_GENERIC_POINTER,
    TYPE_CODE_POINTER,
    TYPE_EXTERNAL_RAM_POINTER,
    TYPE_INTERNAL_RAM_POINTER,
    TYPE_PAGED_POINTER,
    TYPE_UPPER_128B_POINTER,
    TYPE_LONG,
    TYPE_INT,
    TYPE_CHAR,
    TYPE_SHORT,
    TYPE_VOID,
    TYPE_FLOAT,
    TYPE_STRUCTURE,
    };

struct type_chain_s {
    enum type_record_type type_;
    char* data;
    type_chain* next;
};

struct type_record_s {
    size_t size;
    type_chain* first;
    uint8_t signed_;
};

struct address_space_s {
    char address_space;
    int a;
    int b;
};

struct debug_sym_function_argument_s {
    debug_sym_symbol*                   symbol;
    debug_sym_function_argument*        next;
};

struct debug_sym_function_s {
    char                            name[128];
    const char*                     function_name;
    enum function_scope_t           scope;
    const char*                     scope_value;
    type_record                     type_record;
    address_space                   address_space;
    debug_sym_function_argument*    arguments;
    UT_hash_handle                  hh;
};

struct debug_sym_symbol_s {
    char                    name[128];
    const char*             symbol_name;
    enum symbol_scope_t     scope;
    const char*             scope_value;
    type_record             type_record;;
    address_space           address_space;
    debug_sym_function*     belongs_to_function;
    UT_hash_handle          hh;
};


// debug
extern void debug_add_info_encoded(char *encoded);
extern int debug_find_source_location(int address, const char **filename, int *lineno);
extern void debug_add_cline(const char *filename, int lineno, int level, int scope, const char *address);
extern int debug_resolve_source(char *name);

extern debug_sym_function* debug_find_function(const char* function_name, const char* file_name);
extern uint8_t debug_get_symbol_value(debug_sym_symbol* sym, uint16_t stack, char* target);

#endif