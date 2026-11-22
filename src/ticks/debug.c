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
/* The width of a float, from the last record that gave one. A record does not
   give it for a float behind a pointer or a function, nor does a cast. */
static int cdb_float_size = 4;
static int cdb_float_size_known = 0;      // a record has given the width

static debug_sym_enum* cdb_enums = NULL;

// The module of the record being read, which a type_record keeps; one copy of each name
typedef struct {
    char*           name;
    UT_hash_handle  hh;
} cdb_module;
static cdb_module* cdb_modules = NULL;
static const char* cdb_record_module = NULL;

/* An E: record gives the S: record of the same name (G$gc$0_0$0) its enum's
   tag. They can come in either order, so each one waits here for the other. */
typedef struct {
    char*               record_name;
    char*               tag;
    debug_sym_symbol*   symbol;
    UT_hash_handle      hh;
} enum_object;
static enum_object* cdb_enum_objects = NULL;
static cline *clines[65536] = {0};
/* Source lines of banked code, indexed by bank (address >> 16) then by the
   address in the bank window. The arrays are allocated when a bank has lines. */
static cline **bank_clines[4096] = {0};

static cline **cline_slot(int address, int create)
{
    int bank = (address >> 16) & 0xffff;

    if ( address < 0 )
        return NULL;
    if ( bank == 0 )
        return &clines[address];
    if ( bank > 4095 )
        return NULL;
    if ( bank_clines[bank] == NULL ) {
        if ( !create )
            return NULL;
        bank_clines[bank] = calloc(65536, sizeof(cline *));
    }
    return &bank_clines[bank][address & 0xffff];
}


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
            bk.debug("Warning: unsupported address space: %s\n", encoded);
            *result = NULL;
            return 1;
        }
    }

    *result = encoded;
    return 0;
}

static char* dup_n(const char* s, size_t n)
{
    char* r = malloc(n + 1);

    memcpy(r, s, n);
    r[n] = 0;
    return r;
}

/* The scope of a record, up to the '$' that ends it, on the heap: a file name
   or <file>.<function>, as long as the source path. *encoded moves past the
   '$'. NULL if the scope is empty or has no '$'. */
static char* dup_scope(const char** encoded)
{
    const char* end = strchr(*encoded, '$');
    char* r;

    if (end == NULL || end == *encoded) {
        return NULL;
    }
    r = dup_n(*encoded, end - *encoded);
    *encoded = end + 1;
    return r;
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
    record->signed_ = 0;
    record->module = cdb_record_module;
    rt += end;

    enum record_partning_mode mode = RECORD_PARSING_MODE_BEGIN;
    const char* structure = NULL;

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
                    next->bit_start = 0;
                    next->bit_width = 0;
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
                        bk.debug("Warning: unknown type starting with %c.\n", c);
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
                        if (*rt == 'x' || *rt == 'd') rt++;     // sccz80 DA<n>x, sdcc DA<n>d
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
                    SB<start>$<width> Bitfield
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
                        last->size = 0;     // its width, set below when the record gives it
                        break;
                    }
                    case 'T': {
                        last->type_ = TYPE_STRUCTURE;
                        mode = RECORD_PARSING_MODE_STRUCTURE;
                        structure = rt;
                        break;
                    }
                    case 'B': {
                        char *end;
                        last->bit_start = strtol(rt, &end, 10);
                        if (*end != '$') goto err;
                        last->bit_width = strtol(end + 1, &end, 10);
                        rt = end;
                        if (last->bit_width <= 0 || last->bit_start + last->bit_width > 16) goto err;
                        last->type_ = last->bit_start + last->bit_width > 8 ? TYPE_INT : TYPE_CHAR;
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
                        last->data = dup_n(structure, rt - 1 - structure);
                        mode = RECORD_PARSING_MODE_BEGIN;
                        break;
                    }
                    case ':': {
                        last->data = dup_n(structure, rt - 1 - structure);
                        mode = RECORD_PARSING_MODE_SIGN;
                        break;
                    }
                    default: {
                        break;
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

    /* A float's width is the record's size, divided by the element count of
       each array in front of it */
    {
        int width = (int)record->size;
        type_chain* c;
        for (c = record->first; c != NULL && c->type_ == TYPE_ARRAY; c = c->next) {
            width = c->size > 0 ? width / c->size : 0;
        }
        if (c != NULL && c->type_ == TYPE_FLOAT && width > 0) {
            c->size = width;
            cdb_float_size = width;
            cdb_float_size_known = 1;
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
    char* fields = NULL;

    char function_scope = *encoded++;
    switch (function_scope)
    {
        case 'F':
        {
            // file scope
            char* file_name = dup_scope(&encoded);
            if (file_name == NULL) {
                goto err;
            }
            f->scope = FUNCTION_SCOPE_FILE;
            f->scope_value = file_name;
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
            char* function_name = dup_scope(&encoded);
            if (function_name == NULL) {
                goto err;
            }
            f->scope = FUNCTION_SCOPE_FUNCTION;
            f->scope_value = function_name;
            break;
        }
        default:
        {
            bk.debug("Warning: unknown function scope: %c\n", function_scope);
            return;
        }
    }

    /* Each field is a part of the record, so a buffer of its length fits any of them */
    size_t n = strlen(encoded) + 1;
    fields = malloc(4 * n);
    char* function_name = fields;
    char* level = fields + n;
    char* block = fields + 2 * n;
    char* type_record = fields + 3 * n;
    int end;

    if (sscanf(encoded, "%[^$]$%[^$]$%[^(](%[^)]),%n", function_name, level, block, type_record, &end) != 4) {
        goto err;
    }
    f->function_name = strdup(function_name);
    f->arguments = NULL;
    encoded += end;

    if (f->scope == FUNCTION_SCOPE_GLOBAL) {
        f->name = strdup(f->function_name);
    } else {
        f->name = malloc(strlen(f->scope_value) + strlen(f->function_name) + 2);
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
    free(fields);

    return;

err:
    free(fields);
    free(f);
    bk.debug("Warning: could not add debug info on function.\n");
}

static debug_sym_symbol* debug_parse_symbol_info(const char* encoded, const char** result)
{
    // S:G$VALUE_0$0_0$0({0}),E,0,0
    // S:Lother.c.haha2$c$0_0$0({2}SI:S),B,1,4

    debug_sym_symbol* s = malloc(sizeof(debug_sym_symbol));
    char* fields = NULL;

    s->belongs_to_function = NULL;

    char symbol_scope = *encoded++;
    switch (symbol_scope)
    {
        case 'F':
        {
            // file scope
            char* file_name = dup_scope(&encoded);
            if (file_name == NULL) {
                goto err;
            }
            s->scope = SYMBOL_SCOPE_FILE;
            s->scope_value = file_name;
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
            char* localiry_name = dup_scope(&encoded);
            if (localiry_name == NULL) {
                goto err;
            }
            s->scope = SYMBOL_SCOPE_LOCAL;
            s->scope_value = localiry_name;
            break;
        }
        default:
        {
            bk.debug("Warning: unknown symbol scope: %c\n", symbol_scope);
        }
    }

    /* Each field is a part of the record, so a buffer of its length fits any of
       them; 16 more for the anon_<n> name */
    size_t n = strlen(encoded) + 16;
    fields = malloc(4 * n);
    char* symbol_name = fields;
    char* level = fields + n;
    char* block = fields + 2 * n;
    char* type_record = fields + 3 * n;
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
        s->name = strdup(s->symbol_name);
    } else {
        if (s->scope == SYMBOL_SCOPE_LOCAL) {
            const char* dot = strrchr(s->scope_value, '.');
            if (dot != NULL) {
                char* file_name = dup_n(s->scope_value, dot - s->scope_value);
                const char* function_name = dot + 1;

                s->belongs_to_function = debug_find_function(function_name, file_name);
                if (s->belongs_to_function) {
                    /* Linked into the argument list once the whole record has
                       parsed - see below. */
                } else {
                    bk.debug("Warning: could not find function %s.%s for argument %s.\n",
                        file_name, function_name, s->symbol_name);
                }
                free(file_name);
            }
        }

        s->name = malloc(strlen(s->scope_value) + strlen(s->symbol_name) + 2);
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

    /* Only now that the record has parsed in full is it safe to publish the
       symbol into its function's argument list: the err path below frees s,
       and an entry linked earlier would leave the list holding freed memory
       for every later walk of it (info locals, backtrace, print ...). */
    if (s->belongs_to_function) {
        debug_sym_function_argument* arg = malloc(sizeof(debug_sym_function_argument));
        arg->symbol = s;
        arg->next = s->belongs_to_function->arguments;
        s->belongs_to_function->arguments = arg;
    }

    free(fields);
    *result = encoded;
    return s;

err:
    free(fields);
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
            char* file_name = dup_scope(&encoded);
            if (file_name == NULL) {
                goto err;
            }
            t->scope = SYMBOL_SCOPE_FILE;
            t->scope_value = file_name;
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
            char* localiry_name = dup_scope(&encoded);
            if (localiry_name == NULL) {
                goto err;
            }
            t->scope = SYMBOL_SCOPE_LOCAL;
            t->scope_value = localiry_name;
            break;
        }
        default:
        {
            bk.debug("Warning: unknown symbol scope: %c\n", symbol_scope);
            break;
        }
    }

    char* type_info = malloc(strlen(encoded));
    if (sscanf(encoded, "%127[^[][%[^]]]", t->name, type_info) != 2) {
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

// N:Fu3.c$colour({2}SI:S)[(RED$0)(GREEN$5)(BLUE$6)]
// An enum is known by its F<file>$<tag> (the text before the "({"): tags are
// only unique within one file. A key that is already known keeps its first
// record, and is marked ambiguous (its values print as numbers) when a later
// record for it differs.
static void free_enum(debug_sym_enum* e)
{
    debug_sym_enumerator* en = e->first_enumerator;

    while (en != NULL) {
        debug_sym_enumerator* next = en->next;
        free(en->name);
        free(en);
        en = next;
    }
    free(e->name);
    free(e->body);
    free(e);
}

static void debug_add_enum_info(const char* encoded)
{
    char name[128];
    int32_t value;
    int end;
    debug_sym_enumerator** last;
    const char* open = strstr(encoded, "({");
    const char* close = open == NULL ? NULL : strchr(open, ')');

    if (encoded[0] != 'F' || open == NULL || open == encoded || close == NULL || close[1] != '[') {
        bk.debug("Warning: could not add debug info on enum.\n");
        return;
    }
    char* key = dup_n(encoded, open - encoded);
    const char* list = close + 2;
    debug_sym_enum* e;
    HASH_FIND_STR(cdb_enums, key, e);
    if (e != NULL) {
        if (strcmp(e->body, list) != 0) {
            e->ambiguous = 1;
        }
        free(key);
        return;
    }

    e = calloc(1, sizeof(debug_sym_enum));
    e->name = key;
    e->body = strdup(list);
    last = &e->first_enumerator;
    const char* p = list;
    for (;;) {
        // %n is only reached when the whole item matched: end stays 0 on a record cut short
        end = 0;
        if (sscanf(p, "(%127[^$]$%d)%n", name, &value, &end) != 2 || end == 0) {
            break;
        }
        debug_sym_enumerator* en = calloc(1, sizeof(debug_sym_enumerator));
        en->name = strdup(name);
        en->value = value;
        *last = en;
        last = &en->next;
        p += end;
    }
    if (*p != ']') {
        bk.debug("Warning: could not add debug info on enum.\n");
        free_enum(e);
        return;
    }
    HASH_ADD_KEYPTR(hh, cdb_enums, e->name, strlen(e->name), e);
}

static enum_object* find_enum_object(const char* record_name)
{
    enum_object* o;

    HASH_FIND_STR(cdb_enum_objects, record_name, o);
    if (o == NULL) {
        o = calloc(1, sizeof(enum_object));
        o->record_name = strdup(record_name);
        HASH_ADD_KEYPTR(hh, cdb_enum_objects, o->record_name, strlen(o->record_name), o);
    }
    return o;
}

static void apply_enum_tag(enum_object* o)
{
    type_chain* c;

    if (o->tag == NULL || o->symbol == NULL || (c = o->symbol->type_record.first) == NULL) {
        return;
    }
    while (c->next) {
        c = c->next;
    }
    if (c->type_ == TYPE_INT || c->type_ == TYPE_CHAR) {
        c->data = o->tag;
    }
}

// E:G$gc$0_0$0({2}SEFu3.c$colour:S),E,0,0 - the S: record of the same name is an enum
// The element is SE<F<file>$<tag>>:<sign>: the key ends at the last ':' of the element
static void debug_add_enum_object_info(const char* encoded)
{
    char* record_name = dup_n(encoded, strcspn(encoded, "("));
    const char* p;
    const char* end;
    const char* colon;
    enum_object* o;

    if (*record_name == 0) {
        goto err;
    }
    // The type element that starts with SE, after the {size}
    for (p = strchr(encoded, '}'); p != NULL && strncmp(p + 1, "SE", 2) != 0; p = strchr(p + 1, ',')) {
    }
    if (p == NULL) {
        goto err;
    }
    p += 3;
    end = strpbrk(p, ",)");
    if (end == NULL) {
        end = p + strlen(p);
    }
    for (colon = end; colon > p && *colon != ':'; colon--) {
    }
    if (colon == p || *colon != ':') {
        goto err;
    }
    o = find_enum_object(record_name);
    if (o->tag == NULL) {
        o->tag = dup_n(p, colon - p);
        apply_enum_tag(o);
    }
    free(record_name);
    return;

err:
    free(record_name);
    bk.debug("Warning: could not add debug info on enum object.\n");
}

// The S: record of an E: record, once both are read: its integer gets the enum's tag
static void debug_add_enum_tag(const char* encoded, debug_sym_symbol* s)
{
    char* record_name = dup_n(encoded, strcspn(encoded, "("));
    enum_object* o;

    if (*record_name == 0) {
        free(record_name);
        return;
    }
    o = find_enum_object(record_name);
    if (o->symbol == NULL) {
        o->symbol = s;
        apply_enum_tag(o);
    }
    free(record_name);
}

/* Add debug information, in this case it's encoded */
void debug_add_info_encoded(char *encoded, const char *module)
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
    cdb_record_module = NULL;
    if (module != NULL && module[0] != 0) {
        cdb_module* m = NULL;
        HASH_FIND_STR(cdb_modules, module, m);
        if (m == NULL) {
            m = calloc(1, sizeof(cdb_module));
            m->name = strdup(module);
            HASH_ADD_KEYPTR(hh, cdb_modules, m->name, strlen(m->name), m);
        }
        cdb_record_module = m->name;
    }

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
        case 'N':
        {
            debug_add_enum_info(subtype);
            break;
        }
        case 'E':
        {
            debug_add_enum_object_info(subtype);
            break;
        }
        case 'S':
        {
            const char* res;
            debug_sym_symbol* s = debug_parse_symbol_info(subtype, &res);
            if (s) {
                debug_add_enum_tag(subtype, s);
                if (s->scope == SYMBOL_SCOPE_FILE) {
                    debug_sym_file* f = NULL;
                    HASH_FIND_STR(cdb_files, s->scope_value, f);
                    if (f == NULL) {
                        f = calloc(1, sizeof(debug_sym_file));
                        f->name = strdup(s->scope_value);
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

    if (bk.is_verbose && bk.is_verbose()) {
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

    /* A line can have several C_LINE symbols (one per function or block whose
       code it holds, and a file-scope one): a breakpoint on the line goes to
       the first of its code in a function, or to the file-scope one if there
       is nothing else */
    cline *old;
    HASH_FIND_INT(cf->lines, &lineno, old);
    if ( old == NULL ) {
        HASH_ADD_INT(cf->lines, line, cl);
    } else {
        int old_fn = old->function_name[0] != 0, cl_fn = cl->function_name[0] != 0;
        if ( cl_fn > old_fn || (cl_fn == old_fn && cl->address < old->address) )
            HASH_REPLACE_INT(cf->lines, line, cl, old);
    }

    cline **slot = cline_slot(cl->address, 1);
    if ( slot != NULL )
        *slot = cl;
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

    cline **slot;
    while ( ((slot = cline_slot(address, 0)) == NULL || *slot == NULL) && address > 0 ) {
        if (address < topmost_address) {
            return -1;
        }
        address--;
    }
    if ( (slot = cline_slot(address, 0)) == NULL || *slot == NULL ) return -1;
    *filename = (*slot)->file->file;
    *lineno = (*slot)->line;

    return 0;
}

int debug_resolve_source(char *name, const char** corrected_name)
{
    char *ptr;

    if ( ( ptr = strrchr(name, ':') ) != NULL ) {
        char *filename = dup_n(name, ptr - name);
        int  line;
        int  address = -1;
        cfile *cf;

        line = atoi(ptr+1);

        HASH_FIND_STR(cfiles, filename, cf);

        if ( cf != NULL ) {
            cline *cl;

            HASH_FIND_INT(cf->lines, &line, cl);

            if ( cl != NULL ) {
                address = cl->address;
            }
        } else {
            // try and do partial match
            cfile *elem, *tmp;
            uint32_t filename_len = (int)strlen(filename);
            HASH_ITER(hh, cfiles, elem, tmp) {
                uint32_t elem_file_len = (int)strlen(elem->file);

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
                    address = cl->address;
                }

                break;
            }
        }
        free(filename);
        return address;
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
        char* name = malloc(strlen(file_name) + strlen(function_name) + 2);
        sprintf(name, "%s.%s", file_name, function_name);
        HASH_FIND_STR(cfunctions, name, f);
        free(name);
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
        // recalculate size since malloc_type had NULL data; an array's size
        // is its element count, and a float's its width, which only the record carries
        if (copy_ptr->type_ != TYPE_ARRAY && copy_ptr->type_ != TYPE_FLOAT) {
            copy_ptr->size = get_type_memory_size(copy_ptr);
        }
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
    result->bit_start = 0;
    result->bit_width = 0;
    result->size = 0;
    if (type != TYPE_FLOAT) {
        result->size = get_type_memory_size(result);    // a float's width is its record's, 0 if none
    }
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
                return max_child->offset + (int)max_child->symbol->type_record.size;
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
        case TYPE_FLOAT: {
            return chain->size > 0 ? chain->size : cdb_float_size;
        }
        case TYPE_LONG: {
            return 4;
        }
        case TYPE_ARRAY: {
            return chain->size * get_type_memory_size(chain->next);
        }
        default: {
            return 0;
        }
    }
}

/* The values of __fp_mode, which sccz80 and 80cc write with __fp_exponent_bias and
   __fp_mantissa_size into each module, as locals. They are the names of their -fp-mode */
static const char* fp_mode_names[] = { "z80", "ieee", "mbf32", "mbf40", "mbf64", "z88", "am9511" };
static const int fp_mode_sizes[] = { 6, 4, 4, 6, 8, 6, 4 };     // a float's width in each
#define FP_MODE_Z80     0
#define FP_MODE_IEEE    1
#define FP_MODE_Z88     5
#define FP_MODE_AM9511  6
/* Where the mantissa starts: z88 leaves the first byte (sccz80's c_fp_fudge_offset) */
#define FP_MODE_OFFSET(mode)    ((mode) == FP_MODE_Z88 ? 1 : 0)

/* Read a float of size bytes in the format of module, the module of the record that
   describes it (through a pointer or a struct, of the pointer's or the struct's object):
   0 and the format in mode, exponent_bias and mantissa_size, or -1 and the reason in
   into's error. A float of no record, which only a cast of an integer to a pointer
   makes, takes the program's format if its modules agree. A module without __fp_mode
   (zsdcc, older compilers) is IEEE. A float whose record gives no width (*size 0:
   behind a pointer, or a cast) gets its format's width in *size, or without __fp_mode,
   the width the records give. */
static int debug_float_format(const char* module, int* size_ptr, int* mode, int* exponent_bias, int* mantissa_size, struct expression_result_t* into)
{
    symbol *m, *e, *s;
    int size = *size_ptr;

    if (module != NULL) {
        m = find_symbol_in_module("__fp_mode", module);
        e = find_symbol_in_module("__fp_exponent_bias", module);
        s = find_symbol_in_module("__fp_mantissa_size", module);
    } else {
        m = find_symbol_byname("__fp_mode", NULL);
        e = find_symbol_byname("__fp_exponent_bias", NULL);
        s = find_symbol_byname("__fp_mantissa_size", NULL);
        if ((m != NULL && m->differs) || (e != NULL && e->differs) || (s != NULL && s->differs)) {
            snprintf(into->as_error, sizeof(into->as_error), "Unsupported float format (the modules disagree)");
            return -1;
        }
    }

    if (m == NULL) {
        *mode = FP_MODE_IEEE;
        if (size == 0) {
            if (!cdb_float_size_known) {
                snprintf(into->as_error, sizeof(into->as_error), "Unsupported float format (no width, and no __fp_mode)");
                return -1;
            }
            size = *size_ptr = cdb_float_size;      // the width of the floats that records give
        }
        if (size != 4) {
            snprintf(into->as_error, sizeof(into->as_error), "Unsupported float format (%d bytes, and no __fp_mode)", size);
            return -1;
        }
        return 0;
    }
    if (e == NULL || s == NULL) {
        snprintf(into->as_error, sizeof(into->as_error), "Unsupported float format (no __fp_exponent_bias or __fp_mantissa_size)");
        return -1;
    }
    *mode = (int)m->address;
    *exponent_bias = (int)e->address;
    *mantissa_size = (int)s->address;
    if (size == 0 && *mode >= 0 && *mode < (int)(sizeof(fp_mode_sizes) / sizeof(fp_mode_sizes[0]))) {
        size = *size_ptr = fp_mode_sizes[*mode];
    }
    if ((*mode == FP_MODE_IEEE && size == 4) ||
        (*mode == FP_MODE_AM9511 && size == 4 && *mantissa_size == 3)) {
        return 0;
    }
    /* z80, mbf32, mbf40, mbf64 and z88: the mantissa, then the exponent */
    if (*mode >= 0 && *mode <= FP_MODE_Z88 && *mode != FP_MODE_IEEE && *mantissa_size > 0 &&
        FP_MODE_OFFSET(*mode) + *mantissa_size < size && size <= 8) {
        return 0;
    }
    if (*mode < (int)(sizeof(fp_mode_names) / sizeof(fp_mode_names[0]))) {
        snprintf(into->as_error, sizeof(into->as_error), "Unsupported float format (%d bytes, %s)", size, fp_mode_names[*mode]);
    } else {
        snprintf(into->as_error, sizeof(into->as_error), "Unsupported float format (%d bytes, __fp_mode %d)", size, *mode);
    }
    return -1;
}

/* The AM9511's own format (--math-dai32): a 24-bit mantissa, little-endian, with its
   leading 1 stored, then a byte of the sign (bit 7) and a 7-bit two's complement
   exponent, biased by exponent_bias; a mantissa without its leading 1 is zero */
static float debug_float_from_am9511(const uint8_t* b, int exponent_bias)
{
    uint32_t mantissa = b[0] | ((uint32_t)b[1] << 8) | ((uint32_t)b[2] << 16);
    double v = mantissa;
    int exponent = b[3] & 0x7f;

    if ((mantissa & 0x800000) == 0) {
        return 0;
    }
    if (exponent & 0x40) {
        exponent -= 0x80;
    }
    for (exponent = exponent - exponent_bias - 24; exponent > 0; exponent--) {
        v *= 2;
    }
    for (; exponent < 0; exponent++) {
        v /= 2;
    }
    return (float)((b[3] & 0x80) ? -v : v);
}

/* The z80 format (math48, genmath, the ROM maths), which the Microsoft formats
   (mbf32, mbf40, mbf64) and z88's (after its first byte) share: a mantissa of
   mantissa_size bytes, little-endian, with its leading 1 implied and the sign in
   its top bit, then the exponent, biased by exponent_bias, 0 for zero. Scaled
   without ldexp(): z88dk-dis links without -lm. */
static float debug_float_from_z80(const uint8_t* b, int exponent_bias, int mantissa_size)
{
    uint64_t mantissa = 0;
    double v;
    int exponent;
    int i;

    if (b[mantissa_size] == 0) {
        return 0;
    }
    for (i = mantissa_size - 1; i >= 0; i--) {
        mantissa = mantissa << 8 | b[i];
    }
    v = (double)(mantissa | (uint64_t)1 << (8 * mantissa_size - 1));
    for (exponent = b[mantissa_size] - exponent_bias - 8 * mantissa_size; exponent > 0; exponent--) {
        v *= 2;
    }
    for (; exponent < 0; exponent++) {
        v /= 2;
    }
    return (float)((b[mantissa_size - 1] & 0x80) ? -v : v);
}

/* The width of the floats of module: its format's, 4 (IEEE) without __fp_mode, 0 for
   no module */
static int debug_module_float_width(const char* module)
{
    symbol* m;

    if (module == NULL) {
        return 0;
    }
    m = find_symbol_in_module("__fp_mode", module);
    if (m == NULL) {
        return 4;
    }
    if ((int)m->address >= 0 && (int)m->address < (int)(sizeof(fp_mode_sizes) / sizeof(fp_mode_sizes[0]))) {
        return fp_mode_sizes[m->address];
    }
    return 0;
}

/* Whether a struct of type t holds a float, in itself or in a struct member */
static int debug_struct_has_float(debug_sym_type* t, int depth)
{
    debug_sym_type_member* child;

    if (t == NULL || depth > 8) {
        return 0;
    }
    for (child = t->first_child; child != NULL; child = child->next) {
        type_chain* c = child->symbol->type_record.first;
        while (c != NULL && c->type_ == TYPE_ARRAY) {
            c = c->next;
        }
        if (c != NULL && c->type_ == TYPE_FLOAT) {
            return 1;
        }
        if (c != NULL && c->type_ == TYPE_STRUCTURE && debug_struct_has_float(cdb_find_type(c->data), depth + 1)) {
            return 1;
        }
    }
    return 0;
}

/* ticks keeps one T: record per struct key, so a struct that modules of two formats
   share has the layout of one of them. 0 and the reason in error when an object of
   module cannot use the kept layout: the struct holds a float, and the record's module
   has floats of another width */
static int debug_struct_layout_fits(const char* module, debug_sym_type* t, char* error, size_t error_size)
{
    int kept, own;

    if (t == NULL || t->first_child == NULL || module == NULL) {
        return 1;
    }
    kept = debug_module_float_width(t->first_child->symbol->type_record.module);
    own = debug_module_float_width(module);
    if (kept == 0 || own == 0 || kept == own || !debug_struct_has_float(t, 0)) {
        return 1;
    }
    snprintf(error, error_size, "Unsupported float format (struct %s is laid out with %d-byte floats)", t->name, kept);
    return 0;
}

/* The size of an object of chain in record's module, as for strides and sizeof: a float
   that its record gives no width has its module's format's; -1 and the reason in error
   when it cannot be known (a struct laid out for another format) */
int debug_type_size(type_record* record, type_chain* chain, char* error, size_t error_size)
{
    if (chain == NULL) {
        return get_type_memory_size(chain);
    }
    switch (chain->type_) {
        case TYPE_FLOAT: {
            int width = chain->size > 0 ? chain->size : debug_module_float_width(record->module);
            return width > 0 ? width : get_type_memory_size(chain);
        }
        case TYPE_ARRAY: {
            int size = debug_type_size(record, chain->next, error, error_size);
            return size < 0 ? size : chain->size * size;
        }
        case TYPE_STRUCTURE: {
            if (!debug_struct_layout_fits(record->module, cdb_find_type(chain->data), error, error_size)) {
                return -1;
            }
            return get_type_memory_size(chain);
        }
        default: {
            return get_type_memory_size(chain);
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
                    ch = bk.get_memory(data, MEM_TYPE_DATA);
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
                        v = (bk.get_memory(data + 1, MEM_TYPE_DATA) << 8) + bk.get_memory(data, MEM_TYPE_DATA);
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
                        v = (bk.get_memory(data + 1, MEM_TYPE_DATA) << 8) + bk.get_memory(data, MEM_TYPE_DATA);
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
                        v = (bk.get_memory(data + 3, MEM_TYPE_DATA) << 24) + (bk.get_memory(data + 2, MEM_TYPE_DATA) << 16) + (bk.get_memory(data + 1, MEM_TYPE_DATA) << 8) + bk.get_memory(data, MEM_TYPE_DATA);
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
                        v = (bk.get_memory(data + 3, MEM_TYPE_DATA) << 24) + (bk.get_memory(data + 2, MEM_TYPE_DATA) << 16) + (bk.get_memory(data + 1, MEM_TYPE_DATA) << 8) + bk.get_memory(data, MEM_TYPE_DATA);
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

        case TYPE_FLOAT: {
            int size = chain->size;     // 0 when no record gives it: a cast
            int mode, exponent_bias, mantissa_size;
            uint8_t b[8];
            int i;

            if (resolve_by != RESOLVE_BY_POINTER) {
                snprintf(into->as_error, sizeof(into->as_error), "Cannot read a float returned by value (not implemented)");
                set_expression_result_error(into);
                break;
            }
            if (debug_float_format(record->module, &size, &mode, &exponent_bias, &mantissa_size, into) < 0) {
                set_expression_result_error(into);
                break;
            }
            for (i = 0; i < size; i++) {
                b[i] = bk.get_memory(data + i, MEM_TYPE_DATA);
            }
            into->memory_location = data;
            if (mode == FP_MODE_IEEE) {
                uint32_t v = b[0] | ((uint32_t)b[1] << 8) | ((uint32_t)b[2] << 16) | ((uint32_t)b[3] << 24);
                memcpy(&into->as_float, &v, sizeof(v));
            } else if (mode == FP_MODE_AM9511) {
                into->as_float = debug_float_from_am9511(b, exponent_bias);
            } else if (mode == FP_MODE_Z88 && b[FP_MODE_OFFSET(mode) + mantissa_size] == 0) {
                /* z88 (BBC BASIC): exponent 0 marks a 32-bit two's complement integer
                   in the four mantissa bytes, which floor() and ceil() store */
                if (mantissa_size != 4) {
                    snprintf(into->as_error, sizeof(into->as_error), "Unsupported float format (a z88 integer with a %d-byte mantissa)", mantissa_size);
                    set_expression_result_error(into);
                    break;
                }
                into->as_float = (float)(int32_t)(b[1] | ((uint32_t)b[2] << 8) | ((uint32_t)b[3] << 16) | ((uint32_t)b[4] << 24));
            } else {
                into->as_float = debug_float_from_z80(b + FP_MODE_OFFSET(mode), exponent_bias, mantissa_size);
            }
            break;
        }
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
                    v = (bk.get_memory(data + 1, MEM_TYPE_DATA) << 8) + bk.get_memory(data, MEM_TYPE_DATA);
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

    if (chain->bit_width && resolve_by == RESOLVE_BY_POINTER) {
        // A bitfield: keep its bits and extend its sign
        uint32_t v = (into->as_uint >> chain->bit_start) & ((1u << chain->bit_width) - 1);
        if (record->signed_ && (v & (1u << (chain->bit_width - 1)))) {
            into->as_int = (int32_t)v - (int32_t)(1u << chain->bit_width);
        } else {
            into->as_uint = v;
        }
    }
}

/* A member of a struct of type t at data, read in the format of the module of the
   struct's object (the type's own record may come from another module) */
void debug_resolve_struct_member(type_record* holder, debug_sym_type* t, debug_sym_symbol* member, uint32_t data, struct expression_result_t* into) {
    type_record record = member->type_record;

    if (!debug_struct_layout_fits(holder->module, t, into->as_error, sizeof(into->as_error))) {
        set_expression_result_error(into);
        return;
    }

    if (holder->module != NULL) {
        record.module = holder->module;
    }
    debug_resolve_expression_element(&record, record.first, RESOLVE_BY_POINTER, data, into);
}

static int debug_get_symbol_address(debug_sym_symbol *s) {
    int address = symbol_resolve((char*)s->symbol_name, (s->scope == SYMBOL_SCOPE_FILE) ? s->scope_value : NULL);
    if (address >= 0) {
        return address;
    }

    char* underscored_name = malloc(strlen(s->symbol_name) + 2);
    sprintf(underscored_name, "_%s", s->symbol_name);

    address = symbol_resolve(underscored_name, (s->scope == SYMBOL_SCOPE_FILE) ? s->scope_value : NULL);
    free(underscored_name);
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

// The enumerator of an enum (its F<file>$<tag> key) that has this value, NULL if none has
const char* cdb_enumerator_name(const char* key, int32_t value) {
    debug_sym_enum* e;
    debug_sym_enumerator* en;

    HASH_FIND_STR(cdb_enums, key, e);
    if (e == NULL || e->ambiguous) {
        return NULL;
    }
    for (en = e->first_enumerator; en != NULL; en = en->next) {
        if (en->value == value) {
            return en->name;
        }
    }
    return NULL;
}

/* An enumerator by name. The enums of the file being debugged win; otherwise
   the enum with the smallest F<file>$<tag> key that has it, so the answer does
   not depend on the order the records were read in. */
uint8_t cdb_find_enumerator(const char* name, const char* filename, int32_t* value) {
    debug_sym_enum* e;
    debug_sym_enum* tmp;
    debug_sym_enum* best = NULL;
    debug_sym_enumerator* best_en = NULL;
    int best_in_file = 0;
    size_t filename_len = filename != NULL ? strlen(filename) : 0;

    HASH_ITER(hh, cdb_enums, e, tmp) {
        debug_sym_enumerator* en;
        for (en = e->first_enumerator; en != NULL; en = en->next) {
            if (strcmp(en->name, name) == 0) {
                break;
            }
        }
        if (en == NULL) {
            continue;
        }
        /* the key starts F<filename>$ */
        int in_file = filename != NULL && e->name[0] == 'F' &&
            strncmp(e->name + 1, filename, filename_len) == 0 && e->name[1 + filename_len] == '$';
        if (best == NULL || (in_file && !best_in_file) || (in_file == best_in_file && strcmp(e->name, best->name) < 0)) {
            best = e;
            best_en = en;
            best_in_file = in_file;
        }
    }
    if (best == NULL) {
        return 0;
    }
    *value = best_en->value;
    return 1;
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
        uint16_t ret = bk.get_memory(where, MEM_TYPE_DATA) + (bk.get_memory(where+1, MEM_TYPE_DATA)*256);
        return ret;
    }

    // push	ix; ld ix,0; add ix,sp
    *invalidate_stack_offset = 8;
    return wrap_reg(regs->xh, regs->xl);
}

static uint8_t recover_from_frame_pointer(symbol* sym, uint16_t frame_pointer,
                                          uint8_t* unreliable_offset, int* at, uint16_t* stack,
                                          debug_frame_pointer** first, debug_frame_pointer** last)
{
    // we have no idea where we are but, but somebody called us, and it's return address
    // should be right before frame pointer
    uint16_t caller = wrap_reg(bk.get_memory(frame_pointer - 1, MEM_TYPE_DATA), bk.get_memory(frame_pointer - 2, MEM_TYPE_DATA));
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

/* pc is a banked address (bank << 16 | pc) when the code is in a bank. The
   callers' addresses, from the stack, have 16 bits. */
debug_frame_pointer* debug_stack_frames_construct(uint32_t pc, uint16_t sp, struct debugger_regs_t* regs, uint16_t limit)
{
    size_t invalidate_stack_after;
    uint16_t frame_pointer = get_current_framepointer(regs, &invalidate_stack_after);

    debug_frame_pointer* first = NULL;
    debug_frame_pointer* last = NULL;

    uint8_t unreliable_offset = 0;
    uint8_t entry_num = 0;
    uint16_t stack = sp;
    int      at = pc;

    unsigned banked_depth = 0;

    do {
        entry_num++;
        uint16_t offset;
        symbol* sym = symbol_find_lower(at, SYM_ADDRESS, &offset);

        /* A banked function returns into banked_call. The real caller, with
           its bank, is on the bank stack, so carry on from there. */
        if (entry_num > 1 && sym != NULL && bk.banked_caller != NULL &&
            (strcmp(sym->name, "banked_call") == 0 || strcmp(sym->name, "_banked_call") == 0)) {
            uint32_t banked_caller;

            if (bk.banked_caller(banked_depth, &banked_caller)) {
                banked_depth++;
                at = banked_caller;
                if (last) {
                    last->return_address = banked_caller;
                }
                continue;
            }
        }

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

                uint16_t caller = wrap_reg(bk.get_memory(stack + 1, MEM_TYPE_STACK), bk.get_memory(stack, MEM_TYPE_STACK));

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

            uint16_t caller = wrap_reg(bk.get_memory(new_frame_pointer + 3, MEM_TYPE_STACK), bk.get_memory(new_frame_pointer + 2, MEM_TYPE_STACK));
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
            uint16_t caller = wrap_reg(bk.get_memory(stack + 1, MEM_TYPE_STACK), bk.get_memory(stack, MEM_TYPE_STACK));
            at = caller;
            // unwind ret
            stack += 2;
        } else if (offset < invalidate_stack_after) {
            if (fn->address_space.b) {
                stack += fn->address_space.b;
            }
            // we've pushed old ix but haven't inited old one
            uint16_t caller = wrap_reg(bk.get_memory(stack + 3, MEM_TYPE_STACK), bk.get_memory(stack + 2, MEM_TYPE_STACK));
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
            frame_pointer = wrap_reg(bk.get_memory(frame_pointer + 1,MEM_TYPE_STACK), bk.get_memory(frame_pointer, MEM_TYPE_STACK));
            // then goes ret
            stack += 2;
            uint16_t caller = wrap_reg(bk.get_memory(stack + 1, MEM_TYPE_STACK), bk.get_memory(stack, MEM_TYPE_STACK));
            at = caller;
        }

        new_frame->return_address = at;

        /* Returning into banked_call: the real caller is on the bank stack */
        if (bk.banked_caller != NULL) {
            uint16_t ret_offset;
            symbol* ret_sym = symbol_find_lower(at, SYM_ADDRESS, &ret_offset);
            uint32_t real_caller;

            if (ret_sym != NULL &&
                (strcmp(ret_sym->name, "banked_call") == 0 || strcmp(ret_sym->name, "_banked_call") == 0) &&
                bk.banked_caller(banked_depth, &real_caller)) {
                new_frame->return_address = real_caller;
            }
        }

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
