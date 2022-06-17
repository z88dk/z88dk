// Handle parsing debug information from C files
// In this case it's adb information as per sdcc


#include "debug.h"
#include "backend.h"
#include "exp_engine.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

static cfile* cfiles = NULL;
static debug_sym_function* cfunctions = NULL;

// Global symbols only
static debug_sym_symbol* cdb_global_symbols = NULL;

// Files that might contain static symbols
static debug_sym_file* cdb_files = NULL;

static debug_sym_type* cdb_ctypes = NULL;
static cline *clines[65536] = {0};


// Crude dehexer....
static int dehex(char c)
{
    if ( isdigit(c) ) {
        return c - '0';
    } 
    return toupper(c) - 'A' + 10;
}

enum record_partning_mode {
    RECORD_PARSING_MODE_BEGIN = 0,
    RECORD_PARSING_MODE_D,
    RECORD_PARSING_MODE_S,
    RECORD_PARSING_MODE_STRUCTURE,
    RECORD_PARSING_MODE_MAYBE_NEXT,
    RECORD_PARSING_MODE_SIGN,
    RECORD_PARSING_MODE_DONE,
};

static uint8_t parse_address_space(const char* encoded, const char** result, address_space *address_space)
{
    address_space->address_space = *encoded++;

    switch (address_space->address_space) {
        case 'C':
        case 'B':
        case 'Z':
        case 'E': {
            int end;
            if (sscanf(encoded, ",%d,%d%n", &address_space->a, &address_space->b, &end) != 2) {
                *result = NULL;
                return 1;
            }
            encoded += end;
            break;
        }
        default: {
            printf("Warning: unsupported address space: %s\n", encoded);
            *result = NULL;
            return 1;
        }
    }

    *result = encoded;
    return 0;
}

static uint8_t parse_record_type(const char *rt, type_record *record)
{
    int end;
    int size;
    if (sscanf(rt, "{%d}%n", &size, &end) != 1)
    {
        return 1;
    }

    record->size = size;
    record->first = NULL;
    rt += end;

    enum record_partning_mode mode = RECORD_PARSING_MODE_BEGIN;
    char structure[128];
    uint8_t structure_size = 0;

    type_chain* last = NULL;

    char c;
    while ((c = *rt++)) {

        switch (mode) {
            case RECORD_PARSING_MODE_BEGIN: {
                // new chain entry

                {
                    type_chain* next = malloc(sizeof(*next));
                    if (last != NULL) {
                        last->next = next;
                    } else {
                        record->first = next;
                    }
                    next->type_ = TYPE_UNKNOWN;
                    next->size = 1;
                    next->data = NULL;
                    next->next = NULL;
                    last = next;
                }

                switch (c) {
                    case 'D': {
                        mode = RECORD_PARSING_MODE_D;
                        break;
                    }
                    case 'S': {
                        mode = RECORD_PARSING_MODE_S;
                        break;
                    }
                    default: {
                        printf("Warning: unknown type starting with %c.\n", c);
                        goto err;
                    }
                }

                break;
            }
            case RECORD_PARSING_MODE_D: {
                /*
                    DA<n> - Array
                    DF	Function
                    DG	Generic pointer
                    DC	Code pointer
                    DX	External ram pointer
                    DD	Internal ram pointer
                    DP	Paged pointer
                    DI	Upper 128 byte pointer
                 */

                mode = RECORD_PARSING_MODE_MAYBE_NEXT;

                switch (c) {
                    case 'A': {
                        char *end;
                        last->type_ = TYPE_ARRAY;
                        last->size = strtol(rt, &end, 0);
                        rt = end;
                        if (*rt == 'x') rt++;
                        break;
                    }
                    case 'F': {
                        last->type_ = TYPE_FUNCTION;
                        break;
                    }
                    case 'G': {
                        last->type_ = TYPE_GENERIC_POINTER;
                        break;
                    }
                    case 'C': {
                        last->type_ = TYPE_CODE_POINTER;
                        break;
                    }
                    case 'X': {
                        last->type_ = TYPE_EXTERNAL_RAM_POINTER;
                        break;
                    }
                    case 'D': {
                        last->type_ = TYPE_INTERNAL_RAM_POINTER;
                        break;
                    }
                    case 'P': {
                        last->type_ = TYPE_PAGED_POINTER;
                        break;
                    }
                    case 'V': {
                        last->type_ = TYPE_VOID;
                        break;
                    }
                    case 'I': {
                        last->type_ = TYPE_UPPER_128B_POINTER;
                        break;
                    }
                    default: {
                        bk.debug("Warning: unknown type D%c.\n", c);
                        goto err;
                    }
                }

                break;
            }
            case RECORD_PARSING_MODE_S: {
                /*
                    SL	long
                    SI	int
                    SC	char
                    SS	short
                    SV	void
                    SF	float
                    ST<name> Structure of name <name>
                 */

                mode = RECORD_PARSING_MODE_MAYBE_NEXT;

                switch (c) {
                    case 'L': {
                        last->type_ = TYPE_LONG;
                        break;
                    }
                    case 'I': {
                        last->type_ = TYPE_INT;
                        break;
                    }
                    case 'C': {
                        last->type_ = TYPE_CHAR;
                        break;
                    }
                    case 'S': {
                        last->type_ = TYPE_SHORT;
                        break;
                    }
                    case 'V': {
                        last->type_ = TYPE_VOID;
                        break;
                    }
                    case 'F': {
                        last->type_ = TYPE_FLOAT;
                        break;
                    }
                    case 'T': {
                        last->type_ = TYPE_STRUCTURE;
                        mode = RECORD_PARSING_MODE_STRUCTURE;
                        break;
                    }
                    default: {
                        bk.debug("Warning: unknown type F%c.\n", c);
                        goto err;
                    }
                }

                break;
            }
            case RECORD_PARSING_MODE_MAYBE_NEXT: {
                switch (c) {
                    case ',': {
                        mode = RECORD_PARSING_MODE_BEGIN;
                        break;
                    }
                    case ':': {
                        mode = RECORD_PARSING_MODE_SIGN;
                        break;
                    }
                    default: {
                        goto err;
                    }
                }
                break;
            }
            case RECORD_PARSING_MODE_STRUCTURE: {
                switch (c) {
                    case ',': {
                        structure[structure_size] = 0;
                        last->data = strdup(structure);
                        mode = RECORD_PARSING_MODE_BEGIN;
                        break;
                    }
                    case ':': {
                        structure[structure_size] = 0;
                        last->data = strdup(structure);
                        structure[structure_size] = 0;
                        mode = RECORD_PARSING_MODE_SIGN;
                        break;
                    }
                    default: {
                        structure[structure_size++] = c;
                    }
                }
                break;
            }
            case RECORD_PARSING_MODE_SIGN: {
                if (c == 'S') {
                    record->signed_ = 1;
                }
                mode = RECORD_PARSING_MODE_DONE;
                break;
            }
            case RECORD_PARSING_MODE_DONE: {
                bk.debug("Warning: data after sign.\n");
                goto err;
            }
        }
    }

    return 0;

err:
    {
        type_chain* c = record->first;

        while (c)
        {
            type_chain* next = c->next;
            free(c);
            c = next;
        }

        record->first = NULL;
    };

    return 1;
}

static void debug_add_function_info(const char *encoded)
{
    // F:G$main$0_0$0({0}DF,SI:S),C,0,0,0,0,0
    // F:Fother.c$haha2$0_0$0({0}DF,DV),C,0,0

    debug_sym_function* f = malloc(sizeof(debug_sym_function));

    char function_scope = *encoded++;
    switch (function_scope)
    {
        case 'F':
        {
            // file scope
            char file_name[FILENAME_MAX];
            if (sscanf(encoded, "%[^$]$", file_name) != 1) {
                goto err;
            }
            encoded += strlen(file_name) + 1;
            f->scope = FUNCTION_SCOPE_FILE;
            f->scope_value = strdup(file_name);
            break;
        }
        case 'G':
        {
            // global scope
            f->scope = FUNCTION_SCOPE_GLOBAL;
            f->scope_value = NULL;

            if (*encoded != '$') {
                goto err;
            }
            encoded++;
            break;
        }
        case 'L':
        {
            // function scope
            char function_name[255];
            if (sscanf(encoded, "%[^$]$", function_name) != 1) {
                goto err;
            }
            encoded += strlen(function_name) + 1;
            f->scope = FUNCTION_SCOPE_FUNCTION;
            f->scope_value = strdup(function_name);
            break;
        }
        default:
        {
            bk.debug("Warning: unknown function scope: %c\n", function_scope);
            return;
        }
    }

    char function_name[255];
    char level[32];
    char block[32];
    char type_record[128];
    int end;

    if (sscanf(encoded, "%[^$]$%[^$]$%[^(](%[^)]),%n", function_name, level, block, type_record, &end) != 4) {
        goto err;
    }
    f->function_name = strdup(function_name);
    f->arguments = NULL;
    encoded += end;

    if (f->scope == FUNCTION_SCOPE_GLOBAL) {
        strcpy(f->name, f->function_name);
    } else {
        sprintf(f->name, "%s.%s", f->scope_value, f->function_name);
    }

    if (parse_record_type(type_record, &f->type_record)) {
        bk.debug("Warning cannot parse type record.\n");
        goto err;
    }

    if (parse_address_space(encoded, &encoded, &f->address_space)) {
        bk.debug("Warning cannot parse address space.\n");
        goto err;
    }

    HASH_ADD_STR(cfunctions, name, f);

    return;

err:
    free(f);
    bk.debug("Warning: could not add debug info on function.\n");
}

static debug_sym_symbol* debug_parse_symbol_info(const char* encoded, const char** result)
{
    // S:G$VALUE_0$0_0$0({0}),E,0,0
    // S:Lother.c.haha2$c$0_0$0({2}SI:S),B,1,4

    debug_sym_symbol* s = malloc(sizeof(debug_sym_symbol));

    char symbol_scope = *encoded++;
    switch (symbol_scope)
    {
        case 'F':
        {
            // file scope
            char file_name[FILENAME_MAX];
            if (sscanf(encoded, "%[^$]$", file_name) != 1) {
                goto err;
            }
            encoded += strlen(file_name) + 1;
            s->scope = SYMBOL_SCOPE_FILE;
            s->scope_value = strdup(file_name);
            break;
        }
        case 'G':
        {
            // global scope
            s->scope = SYMBOL_SCOPE_GLOBAL;
            s->scope_value = NULL;

            if (*encoded != '$') {
                goto err;
            }
            encoded++;
            break;
        }
        case 'S':
        {
            // symbol scope
            s->scope = SYMBOL_SCOPE_SYMBOL;
            s->scope_value = NULL;

            if (*encoded != '$') {
                goto err;
            }
            encoded++;
            break;
        }
        case 'L':
        {
            // file scope
            char localiry_name[FILENAME_MAX];
            if (sscanf(encoded, "%[^$]$", localiry_name) != 1) {
                goto err;
            }
            encoded += strlen(localiry_name) + 1;
            s->scope = SYMBOL_SCOPE_LOCAL;
            s->scope_value = strdup(localiry_name);
            break;
        }
        default:
        {
            bk.debug("Warning: unknown symbol scope: %c\n", symbol_scope);
        }
    }

    char symbol_name[255];
    char level[32];
    char block[32];
    char type_record[128];
    int end;

    if (sscanf(encoded, "%[^$]$%[^$]$%[^(](%[^)]),%n", symbol_name, level, block, type_record, &end) != 4) {
        if (sscanf(encoded, "$%[^$]$%[^(](%[^)]),%n", level, block, type_record, &end) == 3) {
            static int anon_id = 1;
            // we've got anonymous type, so come up with something
            sprintf(symbol_name, "anon_%d", anon_id++);
        } else {
            goto err;
        }
    }
    s->symbol_name = strdup(symbol_name);
    encoded += end;

    if ((s->scope == SYMBOL_SCOPE_GLOBAL) || (s->scope == SYMBOL_SCOPE_SYMBOL)) {
        strcpy(s->name, s->symbol_name);
    } else {
        if (s->scope == SYMBOL_SCOPE_LOCAL) {
            const char* dot = strrchr(s->scope_value, '.');
            if (dot != NULL) {
                size_t l = dot - s->scope_value;
                char file_name[FILENAME_MAX] = {0};
                char function_name[128] = {0};
                memcpy(file_name, s->scope_value, l);
                strcpy(function_name, dot + 1);

                s->belongs_to_function = debug_find_function(function_name, file_name);
                if (s->belongs_to_function) {
                    debug_sym_function_argument* arg = malloc(sizeof(debug_sym_function_argument));
                    arg->symbol = s;
                    arg->next = NULL;

                    debug_sym_function_argument* last = s->belongs_to_function->arguments;

                    arg->next = last;
                    s->belongs_to_function->arguments = arg;
                } else {
                    bk.debug("Warning: could not find function %s.%s for argument %s.\n",
                        file_name, function_name, s->symbol_name);
                }

            }
        }

        sprintf(s->name, "%s.%s", s->scope_value, s->symbol_name);
    }

    if (parse_record_type(type_record, &s->type_record)) {
        bk.debug("Warning cannot parse type record.\n");
        goto err;
    }

    if (parse_address_space(encoded, &encoded, &s->address_space)) {
        bk.debug("Warning cannot parse address space.\n");
        goto err;
    }

    *result = encoded;
    return s;

err:
    *result = NULL;
    free(s);
    bk.debug("Warning: could not add debug info on symbol.\n");
    return NULL;
}

static debug_sym_type* debug_parse_type_info(const char* encoded)
{
    // T:Fsrc/server.c$test_t[({0}S:S$a$0_0$0({2}SI:S),Z,0,0)({2}S:S$b$0_0$0({2}SI:S),Z,0,0)]

    debug_sym_type* t = malloc(sizeof(debug_sym_type));

    char symbol_scope = *encoded++;
    switch (symbol_scope)
    {
        case 'F':
        {
            // file scope
            char file_name[FILENAME_MAX];
            if (sscanf(encoded, "%[^$]$", file_name) != 1) {
                goto err;
            }
            encoded += strlen(file_name) + 1;
            t->scope = SYMBOL_SCOPE_FILE;
            t->scope_value = strdup(file_name);
            break;
        }
        case 'G':
        {
            // global scope
            t->scope = SYMBOL_SCOPE_GLOBAL;
            t->scope_value = NULL;

            if (*encoded != '$') {
                goto err;
            }
            encoded++;
            break;
        }
        case 'L':
        {
            // file scope
            char localiry_name[FILENAME_MAX];
            if (sscanf(encoded, "%[^$]$", localiry_name) != 1) {
                goto err;
            }
            encoded += strlen(localiry_name) + 1;
            t->scope = SYMBOL_SCOPE_LOCAL;
            t->scope_value = strdup(localiry_name);
            break;
        }
        default:
        {
            bk.debug("Warning: unknown symbol scope: %c\n", symbol_scope);
            break;
        }
    }

    char* type_info = malloc(strlen(encoded));
    if (sscanf(encoded, "%[^[][%[^]]]", t->name, type_info) != 2) {
        goto err_type_info;
    }

    const char* encoded_type_info = type_info;
    struct debug_sym_type_member_s* last = NULL;

    while (*encoded_type_info) {
        int offset;
        int end;
        if (sscanf(encoded_type_info, "({%d}S:%n", &offset, &end) != 1) {
            goto err_type_info;
        }
        encoded_type_info += end;

        struct debug_sym_type_member_s* new_member = calloc(1, sizeof(struct debug_sym_type_member_s));
        new_member->offset = offset;
        if (last == NULL) {
            t->first_child = new_member;
        } else {
            last->next = new_member;
        }

        const char* updated_encoded_type_info;
        debug_sym_symbol* s = debug_parse_symbol_info(encoded_type_info, &updated_encoded_type_info);
        if (s) {
            encoded_type_info = updated_encoded_type_info;
            new_member->symbol = s;
        } else {
            goto err_type_info;
        }
        if (*encoded_type_info == ')') {
            encoded_type_info++;
        }

        last = new_member;
    }

    free(type_info);

    return t;

err_type_info:
    free(type_info);
err:
    free(t);
    bk.debug("Warning: could not add debug info on type.\n");
    return NULL;
}

static void debug_add_module_info(const char* encoded)
{

}

/* Add debug information, in this case it's encoded */
void debug_add_info_encoded(char *encoded)
{
    char *ptr = encoded;
    char *drop = encoded;

    while ( *ptr ) {
        if (*ptr == '_') {
            int c = 0;

            c = dehex(ptr[1]) << 4;
            c += dehex(ptr[2]);
            *drop++ = c;
            ptr += 3;
        } else {
            *drop++ = *ptr++;
        }
    }
    *drop = 0;
    if ( encoded[1] != ':')
        return;

    uint8_t record_type = encoded[0];
    const char* subtype = &encoded[2];

    switch (record_type)
    {
        case 'F':
        {
            debug_add_function_info(subtype);
            break;
        }
        case 'M':
        {
            debug_add_module_info(subtype);
            break;
        }
        case 'S':
        {
            const char* res;
            debug_sym_symbol* s = debug_parse_symbol_info(subtype, &res);
            if (s) {
                if (s->scope == SYMBOL_SCOPE_FILE) {
                    debug_sym_file* f = NULL;
                    HASH_FIND_STR(cdb_files, s->scope_value, f);
                    if (f == NULL) {
                        f = calloc(1, sizeof(debug_sym_file));
                        strcpy(f->name, s->scope_value);
                        HASH_ADD_STR(cdb_files, name, f);
                    }
                    HASH_ADD_STR(f->file_local_symbols, symbol_name, s);
                } else {
                    HASH_ADD_STR(cdb_global_symbols, symbol_name, s);
                }
            }
            break;
        }
        case 'T':
        {
            debug_sym_type* t = debug_parse_type_info(subtype);
            if (t) {
                HASH_ADD_STR(cdb_ctypes, name, t);
            }
            break;
        }
        default:
        {
            bk.debug("Warning: unknown record type: %c\n", record_type);
            break;
        }
    }

    if (bk.is_verbose()) {
        bk.debug("Decoded cdb: <%s>\n",encoded);
    }
}


void debug_add_cline(const char *filename, const char *function, int lineno, int level, int scope_block, const char *address)
{
    cfile *cf;
    HASH_FIND_STR(cfiles, filename, cf);
    if ( cf == NULL ) {
        cf = calloc(1,sizeof(*cf));
        cf->file = strdup(filename);
        cf->lines = NULL;
        HASH_ADD_KEYPTR(hh, cfiles, cf->file, strlen(cf->file), cf);
    }

    int maddress = strtol(address + 1, NULL, 16);

    cline *cl = calloc(1,sizeof(*cl));
    cl->line = lineno;
    cl->file = cf;
    cl->function_name = strdup(function);
    cl->address = maddress;
    cl->level = level;
    cl->scope_block = scope_block;
    HASH_ADD_INT(cf->lines, line, cl);

    clines[cl->address] = cl;  // TODO Banking
}

int debug_find_source_location(int address, const char **filename, int *lineno)
{
    uint16_t offset;
    symbol *original_sym = symbol_find_lower(address, SYM_ADDRESS, &offset);
    if (original_sym == NULL) {
        // no symbol - no address!
        return -1;
    }
    int topmost_address = original_sym->address;

    while ( clines[address] == NULL && address > 0 ) {
        if (address < topmost_address) {
            return -1;
        }
        address--;
    }
    if ( clines[address] == NULL) return -1;
    *filename = clines[address]->file->file;
    *lineno = clines[address]->line;

    return 0;
}

int debug_resolve_source(char *name, const char** corrected_name)
{
    char *ptr;

    if ( ( ptr = strrchr(name, ':') ) != NULL ) {
        char filename[FILENAME_MAX+1];
        int  line;
        cfile *cf;

        snprintf(filename, sizeof(filename),"%.*s", (int)(ptr - name), name);
        line = atoi(ptr+1);

        HASH_FIND_STR(cfiles, filename, cf);

        if ( cf != NULL ) {
            cline *cl;

            HASH_FIND_INT(cf->lines, &line, cl);

            if ( cl != NULL ) {
                return cl->address;
            }
        } else {
            // try and do partial match
            cfile *elem, *tmp;
            uint32_t filename_len = strlen(filename);
            HASH_ITER(hh, cfiles, elem, tmp) {
                uint32_t elem_file_len = strlen(elem->file);

                if (elem_file_len < filename_len)
                    continue;

                if (memcmp(filename, elem->file + elem_file_len - filename_len, filename_len) != 0)
                    continue;

                cline *cl;
                HASH_FIND_INT(elem->lines, &line, cl);

                if ( cl != NULL ) {
                    if (corrected_name) {
                        *corrected_name = elem->file;
                    }
                    return cl->address;
                }

                break;
            }
        }
    }
    return -1;
}

int debug_resolve_source_forward(const char *filename, const char* within_function, int lineno)
{
    cfile *cf;
    HASH_FIND_STR(cfiles, filename, cf);

    if ( cf != NULL ) {
        cline *cl;

        // look a bit forward if we need to
        for (int forward = 0; forward < 64; forward++) {
            int f = lineno + forward;
            HASH_FIND_INT(cf->lines, &f, cl);
            if ( cl != NULL && (strcmp(cl->function_name, within_function) == 0) ) {
                return cl->address;
            }
        }

    }

    return -1;
}

debug_sym_function* debug_find_function(const char* function_name, const char* file_name) {
    debug_sym_function* f = NULL;

    if (file_name != NULL)
    {
        char name[FILENAME_MAX];
        sprintf(name, "%s.%s", file_name, function_name);
        HASH_FIND_STR(cfunctions, name, f);
    }

    if (f == NULL)
    {
        // we cannot find it by "file.c.function", now let's look by "function"
        HASH_FIND_STR(cfunctions, function_name, f);
    }

    return f;
}

static int Min(int a, int b) { if (a < b ) return a; else return b;}
static int Max(int a, int b) { if (a > b ) return a; else return b;}

type_chain* copy_type_chain(type_chain* from) {
    if (from == NULL) {
        return NULL;
    }
    type_chain* result = NULL;
    type_chain* ptr = NULL;
    while (from) {
        type_chain* copy_ptr = malloc_type(from->type_);
        if (ptr == NULL) {
            result = copy_ptr;
        } else {
            ptr->next = copy_ptr;
        }
        *copy_ptr = *from;
        // recalculate size since malloc_type had NULL data
        copy_ptr->size = get_type_memory_size(copy_ptr);
        ptr = copy_ptr;
        ptr->next = NULL;
        from = from->next;
    }
    return result;
}

type_chain* malloc_type(enum type_record_type type) {
    type_chain* result = malloc(sizeof(type_chain));
    result->next = NULL;
    result->data = NULL;
    result->type_ = type;
    result->size = get_type_memory_size(result);
    return result;
}

void free_type(type_chain* type) {
    while (type) {
        type_chain* next_next = type->next;
        free(type);
        type = next_next;
    }
}

uint8_t is_type_a_pointer(type_chain* type) {
    if (type == NULL) {
        return 0;
    }
    return type->type_ == TYPE_GENERIC_POINTER || type->type_ == TYPE_CODE_POINTER || type->type_ == TYPE_ARRAY;
}

uint8_t are_type_chains_same(type_chain* a, type_chain* b)
{
    if (a->type_ != b->type_) {
        return 0;
    }
    if (is_type_a_pointer(a)) {
        if (a == NULL || b == NULL) {
            return 0;
        }
        return are_type_chains_same(a->next, b->next);
    }
    return 1;
}

uint8_t is_primitive_integer_type(type_chain* type) {
    if (type == NULL) {
        return 0;
    }
    switch (type->type_) {
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            return 1;
        }
        default: {
            return 0;
        }
    }
}

uint8_t are_type_records_same(type_record* a, type_record* b)
{
    if (a->signed_ != b->signed_) {
        return 0;
    }
    if ((a->first == NULL) != (b->first == NULL)) {
        return 0;
    }
    if ((a->first == NULL) && (b->first == NULL)) {
        return 1;
    }
    if (a->first->type_ != b->first->type_) {
        return 0;
    }
    if (is_type_a_pointer(a->first)) {
        if (a->first->next == NULL || a->first->next == NULL) {
            return 0;
        }
        return are_type_chains_same(a->first, b->first);
    }
    return 1;
}

int get_type_memory_size(type_chain* chain) {
    if (chain == NULL) {
        return 1;
    }
    switch (chain->type_) {
        case TYPE_STRUCTURE: {
            debug_sym_type* t = cdb_find_type(chain->data);
            if (t == NULL) {
                return 0;
            }
            debug_sym_type_member* child = t->first_child;
            int max_offset = 0;
            debug_sym_type_member* max_child = NULL;
            while (child) {
                if (child->offset >= max_offset) {
                    max_offset = child->offset;
                    max_child = child;
                }
                child = child->next;
            }
            if (max_child) {
                return max_child->offset + max_child->symbol->type_record.size;
            }
            return 0;
        }
        case TYPE_CHAR: {
            return 1;
        }
        case TYPE_INT:
        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER:
        case TYPE_SHORT: {
            return 2;
        }
        case TYPE_FLOAT:
        case TYPE_LONG: {
            return 4;
        }
        default: {
            return 0;
        }
    }
}

void debug_resolve_expression_element(type_record* record, type_chain* chain, enum resolve_chain_value_kind resolve_by, uint32_t data, struct expression_result_t* into) {
    int offs = 0;
    if (record == NULL) {
        return;
    }
    into->type = *record;
    into->type.first = copy_type_chain(chain);
    if (chain == NULL) {
        return;
    }
    switch ( chain->type_ ) {
        case TYPE_CHAR: {
            char ch;
            switch (resolve_by) {
                case RESOLVE_BY_POINTER: {
                    ch = bk.get_memory((uint16_t)data);
                    into->memory_location = data;
                    break;
                }
                case RESOLVE_BY_VALUE:
                default: {
                    ch = (uint8_t)data;
                    into->memory_location = 0;
                    break;
                }
            }
            if ( record->signed_ ) {
                into->as_int = (char)ch;
            } else {
                into->as_uint = (unsigned char)ch;
            }
            break;
        }
        case TYPE_INT:
        case TYPE_SHORT:
            if ( record->signed_ ) {
                int16_t v;
                switch (resolve_by) {
                    case RESOLVE_BY_POINTER: {
                        v = (bk.get_memory((uint16_t)data + 1) << 8) + bk.get_memory((uint16_t)data);
                        into->memory_location = data;
                        break;
                    }
                    case RESOLVE_BY_VALUE:
                    default: {;
                        v = (int16_t)data;
                        into->memory_location = 0;
                        break;
                    }
                }
                into->as_int = v;
            } else {
                uint16_t v;
                switch (resolve_by) {
                    case RESOLVE_BY_POINTER: {
                        v = (bk.get_memory((uint16_t)data + 1) << 8) + bk.get_memory((uint16_t)data);
                        into->memory_location = data;
                        break;
                    }
                    case RESOLVE_BY_VALUE:
                    default: {
                        v = (uint16_t)data;
                        into->memory_location = 0;
                        break;
                    }
                }
                into->as_uint = v;
            }
            break;
        case TYPE_LONG:
            if ( record->signed_ ) {
                int32_t v;
                switch (resolve_by) {
                    case RESOLVE_BY_POINTER: {
                        v = (bk.get_memory(data + 3) << 24) + (bk.get_memory(data + 2) << 16) + (bk.get_memory(data + 1) << 8) + bk.get_memory(data);
                        into->memory_location = data;
                        break;
                    }
                    case RESOLVE_BY_VALUE:
                    default: {
                        v = (int32_t)data;
                        into->memory_location = 0;
                        break;
                    }
                }
                into->as_int = v;
            } else {
                uint32_t v;
                switch (resolve_by) {
                    case RESOLVE_BY_POINTER: {
                        v = (bk.get_memory(data + 3) << 24) + (bk.get_memory(data + 2) << 16) + (bk.get_memory(data + 1) << 8) + bk.get_memory(data);
                        into->memory_location = data;
                        break;
                    }
                    case RESOLVE_BY_VALUE:
                    default: {
                        v = (uint32_t)data;
                        into->memory_location = 0;
                        break;
                    }
                }
                into->as_uint = v;
            }
            break;

        case TYPE_STRUCTURE: {
            into->memory_location = data;
            into->as_pointer.ptr = data;
            break;
        }
        case TYPE_ARRAY: {
            into->memory_location = data;
            into->as_pointer.ptr = data;
            break;
        }
        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER: {
            uint16_t v;
            switch (resolve_by) {
                case RESOLVE_BY_POINTER: {
                    v = (bk.get_memory((uint16_t)data + 1) << 8) + bk.get_memory((uint16_t)data);
                    into->memory_location = data;
                    break;
                }
                case RESOLVE_BY_VALUE:
                default: {
                    v = (uint16_t)data;
                    into->memory_location = 0;
                    break;
                }
            }

            into->as_pointer.ptr = v;
            break;
        }

        default: {
            break;
        }
    }
}

static int debug_get_symbol_address(debug_sym_symbol *s) {
    int address = symbol_resolve((char*)s->symbol_name, (s->scope == SYMBOL_SCOPE_FILE) ? s->scope_value : NULL);
    if (address >= 0) {
        return address;
    }

    char underscored_name[255];
    sprintf(underscored_name, "_%s", s->symbol_name);

    address = symbol_resolve(underscored_name, (s->scope == SYMBOL_SCOPE_FILE) ? s->scope_value : NULL);
    if (address >= 0) {
        return address;
    }

    return -1;
}

void debug_get_symbol_value_expression(debug_sym_symbol* sym, debug_frame_pointer* frame_pointer, struct expression_result_t* into) {
    switch (sym->address_space.address_space) {
        case 'B': {
            debug_resolve_expression_element(&sym->type_record, sym->type_record.first, RESOLVE_BY_POINTER, frame_pointer->frame_pointer + sym->address_space.b, into);
			return;
        }
        case 'E': {
            int addr = debug_get_symbol_address(sym);
            if (addr < 0) {
                into->type.first = malloc_type(TYPE_UNKNOWN);
                return;
            }
            debug_resolve_expression_element(&sym->type_record, sym->type_record.first, RESOLVE_BY_POINTER, addr, into);
			return;
        }
        default: {
            sprintf(into->as_error, "Incorrect address space (not implemented)");
            set_expression_result_error(into);
        }
    }
}

uint8_t debug_symbol_valid(debug_sym_symbol *sym, uint16_t stack, debug_frame_pointer *frame_pointer) {
    if (sym->address_space.address_space == 'B') {
        if (frame_pointer->frame_pointer + sym->address_space.b >= stack) {
            return 1;
        }
        return 0;
    }
    return 1;
}

debug_sym_symbol* cdb_find_symbol(const char* cname, const char* filename) {
    if (filename) {
        // look for a file local first
        debug_sym_file* f = NULL;
        HASH_FIND_STR(cdb_files, filename, f);
        if (f) {
            debug_sym_symbol* local_symbol = NULL;
            HASH_FIND_STR(f->file_local_symbols, cname, local_symbol);
            if (local_symbol) {
                return local_symbol;
            }
        }
    }

    debug_sym_symbol* result = NULL;
    HASH_FIND_STR(cdb_global_symbols, cname, result);
    return result;
}

debug_sym_type* cdb_find_type(const char* tname) {
    if (tname == NULL) {
        return NULL;
    }
    debug_sym_type* result;
    HASH_FIND_STR(cdb_ctypes, tname, result);
    return result;
}

debug_sym_symbol* cdb_get_first_global_symbol() {
    return cdb_global_symbols;
}

debug_sym_symbol* cdb_get_first_local_symbol(const char* filename) {
    debug_sym_file* f = NULL;
    HASH_FIND_STR(cdb_files, filename, f);
    if (f) {
        return f->file_local_symbols;
    }
    return NULL;
}

static uint16_t wrap_reg(uint8_t h, uint8_t l)
{
    uint16_t data;
#ifdef __BIG_ENDIAN__
    *(((uint8_t *)&data) + 1) = l;
    *((uint8_t *)&data) = h;
#else
    *(((uint8_t *)&data) + 1) = h;
    *((uint8_t *)&data) = l;
#endif
    return data;
}

debug_frame_pointer* debug_stack_frames_at(debug_frame_pointer *first, size_t frame)
{
    while (frame && first) {
        frame--;
        first = first->next;
    }
    return first;
}

size_t debug_stack_frames_count(debug_frame_pointer *first)
{
    size_t count = 0;
    while (first) {
        count++;
        first = first->next;
    }
    return count;
}

static uint16_t get_current_framepointer(struct debugger_regs_t *regs, size_t* invalidate_stack_offset)
{
    // If the symbol __debug_framepointer is defined, then extract the value from there
    // The rest of the stack can be walked as normal since the value is pushed onto
    // the stack as usual
    int where = symbol_resolve("__debug_framepointer", NULL);

    if ( where != -1 ) {
        // call l_debug_push_frame
        *invalidate_stack_offset = 3;
        uint16_t ret = bk.get_memory(where) + (bk.get_memory(where+1)*256);
        return ret;
    }

    // push	ix; ld ix,0; add ix,sp
    *invalidate_stack_offset = 8;
    return wrap_reg(regs->xh, regs->xl);
}

static uint8_t recover_from_frame_pointer(symbol* sym, uint16_t frame_pointer,
                                          uint8_t* unreliable_offset, uint16_t* at, uint16_t* stack,
                                          debug_frame_pointer** first, debug_frame_pointer** last)
{
    // we have no idea where we are but, but somebody called us, and it's return address
    // should be right before frame pointer
    uint16_t caller = wrap_reg(bk.get_memory(frame_pointer - 1), bk.get_memory(frame_pointer - 2));
    uint16_t offset;
    sym = symbol_find_lower(caller, SYM_ADDRESS, &offset);
    if (sym != NULL && sym->file != NULL) {
        // report <system call>
        debug_frame_pointer* system_call = malloc(sizeof(debug_frame_pointer));
        system_call->next = NULL;
        system_call->frame_pointer = 0xFFFFFFFF;
        system_call->symbol = NULL;
        system_call->offset = 0;
        system_call->address = *at;
        system_call->return_address = caller;
        system_call->function = NULL;
        system_call->filename = "<system call>";
        system_call->lineno = 0;

        // because the original PC is unreliable, but we're restoring from frame_pointer
        // we cannot assume the offset is reliable, so let's report is as beginning of system caller
        *unreliable_offset = 1;
        *at = caller - offset;
        *stack = frame_pointer;

        *first = system_call;
        *last = system_call;

        // keep the loop going from the probable caller
        return 1;
    }

    return 0;
}

debug_frame_pointer* debug_stack_frames_construct(uint16_t pc, uint16_t sp, struct debugger_regs_t* regs, uint16_t limit)
{
    size_t invalidate_stack_after;
    uint16_t frame_pointer = get_current_framepointer(regs, &invalidate_stack_after);

    debug_frame_pointer* first = NULL;
    debug_frame_pointer* last = NULL;

    uint8_t unreliable_offset = 0;
    uint8_t entry_num = 0;
    uint16_t stack = sp;
    uint16_t at = pc;

    do {
        entry_num++;
        uint16_t offset;
        symbol* sym = symbol_find_lower(at, SYM_ADDRESS, &offset);
        if (sym == NULL || sym->file == NULL) {
            if (entry_num == 1 && frame_pointer &&
                recover_from_frame_pointer(sym, frame_pointer,
                    &unreliable_offset, &at, &stack, &first, &last)) {
                continue;
            }
            break;
        }

        const char *nm;
        if (*sym->name == '_') {
            nm = sym->name + 1;
        } else {
            nm = sym->name;
        }

        debug_sym_function* fn = debug_find_function(nm, sym->file);
        if (fn == NULL) {
            if (offset == 0 && entry_num == 1) {
                // we might save the situation here
                debug_frame_pointer* unknown_entry = malloc(sizeof(debug_frame_pointer));

                uint16_t caller = wrap_reg(bk.get_memory(stack + 1), bk.get_memory(stack));

                uint16_t unknown_offset;
                symbol* s = symbol_find_lower(at, SYM_ADDRESS, &unknown_offset);

                unknown_entry->next = NULL;
                unknown_entry->frame_pointer = 0xFFFFFFFF;
                unknown_entry->symbol = s;
                unknown_entry->offset = unknown_offset;
                unknown_entry->address = at;
                unknown_entry->return_address = caller;
                unknown_entry->function = NULL;

                const char *filename;
                int   lineno;
                if (debug_find_source_location(at, &filename, &lineno) < 0) {
                    unknown_entry->filename = NULL;
                    unknown_entry->lineno = 0;
                } else {
                    unknown_entry->filename = filename;
                    unknown_entry->lineno = lineno;
                }

                at = caller;
                stack += 2;

                if (last) {
                    last->next = unknown_entry;
                } else {
                    first = unknown_entry;
                }
                last = unknown_entry;
                continue;
            } else if (entry_num == 1 && frame_pointer) {
                if (recover_from_frame_pointer(sym, frame_pointer,
                    &unreliable_offset, &at, &stack, &first, &last)) {
                    continue;
                }
            }
            break;
        }

        if (unreliable_offset) {
            unreliable_offset = 0;
            offset = 0xFFFF;
        }

        debug_frame_pointer* new_frame = malloc(sizeof(debug_frame_pointer));

        if (last) {
            last->next = new_frame;
        } else {
            first = new_frame;
        }
        last = new_frame;

        uint16_t new_frame_pointer;
        if (offset == 0) {
            // fp of this function hasn't been pushed yet, so we pretend it did,
            // cause variables offset off frame pointer, even if it doesn't exist yet
            new_frame_pointer = stack - 2;
        } else if (offset < invalidate_stack_after) {
            // we've pushed old ix but haven't inited old one
            new_frame_pointer = stack;
        } else {
            new_frame_pointer = frame_pointer;
        }

        const char *filename;
        int   lineno;

        new_frame->next = NULL;
        new_frame->frame_pointer = new_frame_pointer;
        new_frame->offset = offset;
        new_frame->address = at;
        new_frame->function = fn;
        new_frame->symbol = sym;

        if (debug_find_source_location(at, &filename, &lineno) < 0) {
            new_frame->filename = NULL;
            new_frame->lineno = 0;
        } else {
            new_frame->filename = filename;
            new_frame->lineno = lineno;
        }

        if (fn->address_space.b) {
            debug_frame_pointer* unknown_entry = malloc(sizeof(debug_frame_pointer));
            new_frame->next = unknown_entry;

            uint16_t caller = wrap_reg(bk.get_memory(new_frame_pointer + 3), bk.get_memory(new_frame_pointer + 2));
            uint16_t unknown_offset;
            symbol* s = symbol_find_lower(caller, SYM_ADDRESS, &unknown_offset);

            unknown_entry->next = NULL;
            unknown_entry->frame_pointer = 0xFFFFFFFF;
            unknown_entry->symbol = s;
            unknown_entry->offset = unknown_offset;
            unknown_entry->address = caller;
            unknown_entry->function = NULL;

            if (debug_find_source_location(caller, &filename, &lineno) < 0) {
                unknown_entry->filename = NULL;
                unknown_entry->lineno = 0;
            } else {
                unknown_entry->filename = filename;
                unknown_entry->lineno = lineno;
            }

            last = unknown_entry;
        }

        if (offset == 0) {
            if (fn->address_space.b) {
                stack += fn->address_space.b;
            }
            // we're exactly at beginning of the function
            uint16_t caller = wrap_reg(bk.get_memory(stack + 1), bk.get_memory(stack));
            at = caller;
            // unwind ret
            stack += 2;
        } else if (offset < invalidate_stack_after) {
            if (fn->address_space.b) {
                stack += fn->address_space.b;
            }
            // we've pushed old ix but haven't inited old one
            uint16_t caller = wrap_reg(bk.get_memory(stack + 3), bk.get_memory(stack + 2));
            at = caller;
            // unwind ret and ix
            stack += 4;
        } else {
            // fp should point to sp at beginning of the function
            stack = frame_pointer;
            if (fn->address_space.b) {
                stack += fn->address_space.b;
            }
            // last thing pushed is frame pointer of the caller (its fp)
            frame_pointer = wrap_reg(bk.get_memory(frame_pointer + 1), bk.get_memory(frame_pointer));
            // then goes ret
            stack += 2;
            uint16_t caller = wrap_reg(bk.get_memory(stack + 1), bk.get_memory(stack));
            at = caller;
        }

        new_frame->return_address = at;

        if (strcmp(sym->name, "main") == 0 || strcmp(sym->name, "_main") == 0) {
            break;
        }

        if (limit && (--limit == 0)) {
            break;
        }

    } while (1);

    return first;
}

void debug_stack_frames_free(debug_frame_pointer* stack_frames)
{
    while (stack_frames)
    {
        debug_frame_pointer* next = stack_frames->next;
        free (stack_frames);
        stack_frames = next;
    }
}
