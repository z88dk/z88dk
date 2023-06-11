#ifndef DEBUG_H
#define DEBUG_H

#include "uthash.h"
#include "utlist.h"
#include "syms.h"


typedef struct cfile_s cfile;
typedef struct type_record_s type_record;
typedef struct type_chain_s type_chain;
typedef struct address_space_s address_space;
typedef struct debug_sym_function_s debug_sym_function;
typedef struct debug_sym_symbol_s debug_sym_symbol;
typedef struct debug_sym_file_s debug_sym_file;
typedef struct debug_sym_type_s debug_sym_type;
typedef struct debug_sym_type_member_s debug_sym_type_member;
typedef struct debug_sym_function_argument_s debug_sym_function_argument;
typedef struct debug_frame_pointer_s debug_frame_pointer;

typedef struct {
    int             line;
    int             address;
    const char     *function_name;
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
    SYMBOL_SCOPE_LOCAL,
    SYMBOL_SCOPE_SYMBOL
};

enum type_record_type {
    TYPE_UNKNOWN = 0,
    TYPE_ARRAY,
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
    int   size;
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
    type_record             type_record;
    address_space           address_space;
    debug_sym_function*     belongs_to_function;
    UT_hash_handle          hh;
};

struct debug_sym_file_s {
    char                    name[128];
    debug_sym_symbol*       file_local_symbols;
    UT_hash_handle          hh;
};

struct debug_sym_type_member_s {
    uint16_t                    offset;
    debug_sym_symbol*           symbol;
    debug_sym_type_member*      next;
};

struct debug_sym_type_s {
    char                        name[128];
    enum symbol_scope_t         scope;
    const char*                 scope_value;
    debug_sym_type_member*      first_child;
    UT_hash_handle              hh;
};

struct debug_frame_pointer_s {
    symbol*                 symbol;
    debug_sym_function*     function;
    uint16_t                offset;
    uint16_t                address;
    uint16_t                return_address;
    uint32_t                frame_pointer;
    const char*             filename;
    int                     lineno;
    debug_frame_pointer*    next;
};

enum resolve_chain_value_kind {
    RESOLVE_BY_POINTER,
    RESOLVE_BY_VALUE
};

struct debugger_regs_t {
    uint16_t pc, sp;
    unsigned char a,b,c,d,e,h,l;
    unsigned char a_,b_,c_,d_,e_,h_,l_;
    unsigned char f, f_;
    unsigned char xh, xl, yh, yl;

    /*
     * Some emulators would report this 16bit register pair, which could be used
     * to track ticks for profiling purposes
     */
    uint16_t clockl;
    uint16_t clockh;
};

// debug
extern void debug_add_info_encoded(char *encoded);
extern int debug_find_source_location(int address, const char **filename, int *lineno);
extern void debug_add_cline(const char *filename, const char *function, int lineno, int level, int scope, const char *address);
extern int debug_resolve_source(char *name, const char** corrected_name);
extern int debug_resolve_source_forward(const char *filename, const char* within_function, int lineno);

extern type_chain* copy_type_chain(type_chain* from);
extern type_chain* malloc_type(enum type_record_type type);
extern void free_type(type_chain* type);
extern uint8_t is_primitive_integer_type(type_chain* type);
extern uint8_t is_type_a_pointer(type_chain* type);
extern uint8_t are_type_chains_same(type_chain* a, type_chain* b);
extern uint8_t are_type_records_same(type_record* a, type_record* b);
extern int get_type_memory_size(type_chain* chain);
struct expression_result_t;

extern debug_sym_function* debug_find_function(const char* function_name, const char* file_name);
extern void debug_resolve_expression_element(type_record* record, type_chain* chain, enum resolve_chain_value_kind resolve_by, uint32_t data, struct expression_result_t* into);
extern void debug_get_symbol_value_expression(debug_sym_symbol* sym, debug_frame_pointer* frame_pointer, struct expression_result_t* into);
extern uint8_t debug_symbol_valid(debug_sym_symbol* sym, uint16_t stack, debug_frame_pointer* frame_pointer);
extern debug_sym_symbol* cdb_get_first_global_symbol();
extern debug_sym_symbol* cdb_get_first_local_symbol(const char* filename);
extern debug_sym_symbol* cdb_find_symbol(const char* cname, const char* filename);
extern debug_sym_type* cdb_find_type(const char* tname);

extern debug_frame_pointer* debug_stack_frames_construct(uint16_t pc, uint16_t sp, struct debugger_regs_t* regs, uint16_t limit);
extern debug_frame_pointer* debug_stack_frames_at(debug_frame_pointer* first, size_t frame);
extern size_t debug_stack_frames_count(debug_frame_pointer* first);
extern void debug_stack_frames_free(debug_frame_pointer* stack_frames);

#endif