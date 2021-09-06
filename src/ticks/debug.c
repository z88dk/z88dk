// Handle parsing debug information from C files
// In this case it's adb information as per sdcc


#include "debug.h"
#include "backend.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

static cfile *cfiles = NULL;
static debug_sym_function *cfunctions = NULL;
static debug_sym_symbol *csymbols = NULL;
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

static uint8_t parse_address_space(const char *encoded, address_space *address_space)
{
    address_space->address_space = *encoded++;

    switch (address_space->address_space) {
        case 'C':
        case 'B':
        case 'E': {
            if (sscanf(encoded, ",%d,%d", &address_space->a, &address_space->b) != 2) {
                return 1;
            }
            break;
        }
        default: {
            printf("Warning: unsupported address space: %s\n", encoded);
            return 1;
        }
    }

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
                        printf("Warning: unknown type D%c.\n", c);
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
                        printf("Warning: unknown type F%c.\n", c);
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
                printf("Warning: data after sign.\n");
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
            printf("Warning: unknown function scope: %c\n", function_scope);
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
        printf("Warning cannot parse type record.\n");
        goto err;
    }

    if (parse_address_space(encoded, &f->address_space)) {
        printf("Warning cannot parse address space.\n");
        goto err;
    }

    HASH_ADD_STR(cfunctions, name, f);

    return;

err:
    free(f);
    printf("Warning: could not add debug info on function.\n");
}

static void debug_add_symbol_info(const char* encoded)
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
            printf("Warning: unknown symbol scope: %c\n", symbol_scope);
            return;
        }
    }

    char symbol_name[255];
    char level[32];
    char block[32];
    char type_record[128];
    int end;

    if (sscanf(encoded, "%[^$]$%[^$]$%[^(](%[^)]),%n", symbol_name, level, block, type_record, &end) != 4) {
        goto err;
    }
    s->symbol_name = strdup(symbol_name);
    encoded += end;

    if (s->scope == SYMBOL_SCOPE_GLOBAL) {
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
                    printf("Warning: could not find function %s.%s for argument %s.\n",
                        file_name, function_name, s->symbol_name);
                }

            }
        }

        sprintf(s->name, "%s.%s", s->scope_value, s->symbol_name);
    }

    if (parse_record_type(type_record, &s->type_record)) {
        printf("Warning cannot parse type record.\n");
        goto err;
    }

    if (parse_address_space(encoded, &s->address_space)) {
        printf("Warning cannot parse address space.\n");
        goto err;
    }

    HASH_ADD_STR(csymbols, name, s);

    return;

err:
    free(s);
    printf("Warning: could not add debug info on symbol.\n");
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
            debug_add_symbol_info(subtype);
            break;
        }
        default:
        {
            printf("Warning: unknown record type: %c\n", record_type);
            break;
        }
    }

    printf("Decoded cdb: <%s>\n",encoded);
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
    while ( clines[address] == NULL && address > 0 ) {
        address--;
    }
    if ( clines[address] == NULL) return -1;
    *filename = clines[address]->file->file;
    *lineno = clines[address]->line;

    return 0;
}

int debug_resolve_source(char *name)
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

static int min(int a, int b) { if (a < b ) return a; else return b;}
static int max(int a, int b) { if (a > b ) return a; else return b;}


int debug_print_element(type_chain* chain, char issigned, enum resolve_chain_value_kind resolve_by, uint32_t data, char *target, size_t targetlen) {
    int offs = 0;

    switch ( chain->type_ ) {
    case TYPE_CHAR: {
        char ch;
        switch (resolve_by) {
            case RESOLVE_BY_POINTER: {
                ch = bk.get_memory((uint16_t)data);
                break;
            }
            case RESOLVE_BY_VALUE:
            default: {
                ch = (uint8_t)data;
                break;
            }
        }
        if ( issigned ) {
            if ( isprint(ch)) {
                offs = snprintf(target, targetlen, "\'%c\'", ch);
            } else {
                offs = snprintf(target, targetlen, "x%02x", (unsigned char)ch);
            }
        } else {
            offs = snprintf(target, targetlen, "x%02x", (unsigned char)ch);
        }
        break;
    }
    case TYPE_INT:
    case TYPE_SHORT:
        if ( issigned ) {
            int16_t v;
            switch (resolve_by) {
                case RESOLVE_BY_POINTER: {
                    v = (bk.get_memory((uint16_t)data + 1) << 8) + bk.get_memory((uint16_t)data);
                    break;
                }
                case RESOLVE_BY_VALUE:
                default: {
                    v = (int16_t)data;
                    break;
                }
            }
            offs += snprintf(target, targetlen, "%d", v);
        } else {
            uint16_t v;
            switch (resolve_by) {
                case RESOLVE_BY_POINTER: {
                    v = (bk.get_memory((uint16_t)data + 1) << 8) + bk.get_memory((uint16_t)data);
                    break;
                }
                case RESOLVE_BY_VALUE:
                default: {
                    v = (uint16_t)data;
                    break;
                }
            }
            offs += snprintf(target, targetlen, "%u", v);
        }
        break;
    case TYPE_LONG:
        if ( issigned ) {
            int32_t v;
            switch (resolve_by) {
                case RESOLVE_BY_POINTER: {
                    v = (bk.get_memory(data + 3) << 24) + (bk.get_memory(data + 2) << 16) + (bk.get_memory(data + 1) << 8) + bk.get_memory(data);
                    break;
                }
                case RESOLVE_BY_VALUE:
                default: {
                    v = (int32_t)data;
                    break;
                }
            }
            offs = snprintf(target, targetlen, "%d", v);
        } else {
            uint32_t v;
            switch (resolve_by) {
                case RESOLVE_BY_POINTER: {
                    v = (bk.get_memory(data + 3) << 24) + (bk.get_memory(data + 2) << 16) + (bk.get_memory(data + 1) << 8) + bk.get_memory(data);
                    break;
                }
                case RESOLVE_BY_VALUE:
                default: {
                    v = (uint32_t)data;
                    break;
                }
            }
            offs = snprintf(target, targetlen, "%u", v);
        }
        break;

    case TYPE_GENERIC_POINTER:
    case TYPE_CODE_POINTER: {
        uint16_t v;
        switch (resolve_by) {
            case RESOLVE_BY_POINTER: {
                v = (bk.get_memory((uint16_t)data + 1) << 8) + bk.get_memory((uint16_t)data);
                break;
            }
            case RESOLVE_BY_VALUE:
                default: {
                    v = (uint16_t)data;
                    break;
                }
        }
        if ( chain->next && chain->next->type_ == TYPE_CHAR ) {
            int maxlen = targetlen - 2;

            offs = snprintf(target + offs, targetlen - offs,"%#04x \"", v);

            while ( offs < maxlen ) {
                char ch = bk.get_memory(v++);
                if ( ch == 0 ) break;
                if ( isprint(ch)) {
                    offs += snprintf(target+offs, targetlen - offs, "%c", ch);
                } else {
                    offs += snprintf(target+offs, targetlen - offs, "\\%02x", (unsigned char)ch);
                }
            }
            snprintf(target+offs, targetlen - offs, "\"");
            return 0;
        }
        snprintf(target, targetlen, "%#04x", v);
        return 0;
    }
    default:
        break;
    }

    return offs;
}

static uint8_t debug_resolve_chain_value(debug_sym_symbol *sym, uint16_t frame_pointer, char *target, size_t targetlen) {
    type_chain *chain = sym->type_record.first;
    int         offs = 0;

    switch (chain->type_) {
        case TYPE_ARRAY: {
            int maxlen = max(10,min(10, chain->size));
            offs += snprintf(target + offs, targetlen - offs, "%#04x [%d] = { ", frame_pointer, chain->size);
            for ( int i = 0; i < maxlen; i++ ) {
                offs += snprintf(target + offs, targetlen - offs, "%s[%d] = ", i != 0 ? ", " : "", i);
                switch ( chain->next->type_) {
                case TYPE_CHAR:
                    offs += debug_print_element(chain->next, sym->type_record.signed_, RESOLVE_BY_POINTER, frame_pointer, target + offs, targetlen - offs);
                    frame_pointer++;
                    break;
                case TYPE_INT:
                case TYPE_SHORT:
                    offs += debug_print_element(chain->next, sym->type_record.signed_, RESOLVE_BY_POINTER, frame_pointer, target + offs, targetlen - offs);
                    frame_pointer += 2;
                    break;
                case TYPE_LONG:
                    offs += debug_print_element(chain->next, sym->type_record.signed_, RESOLVE_BY_POINTER, frame_pointer, target + offs, targetlen - offs);
                    frame_pointer += 4;
                    break;
                default:
                    break;
                }
            }
            offs += snprintf(target+offs, targetlen - offs,"%s }", maxlen != chain->size ? " ..." : "");
            return 0;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_SHORT: 
        case TYPE_LONG:
        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER:
            debug_print_element(chain, sym->type_record.signed_, RESOLVE_BY_POINTER, frame_pointer, target + offs, targetlen - offs);
            return 0;

        default: {
            return 1;
        }
    }
}

uint8_t debug_get_symbol_value(debug_sym_symbol* sym, debug_frame_pointer* frame_pointer, char *target, size_t targetlen) {
    if (sym->address_space.address_space == 'B') {
        return debug_resolve_chain_value(sym, frame_pointer->frame_pointer + sym->address_space.b, target, targetlen);
    } else {
        return 1;
    }

    return 0;
}

uint8_t debug_symbol_valid(debug_sym_symbol *sym, uint16_t stack, debug_frame_pointer *frame_pointer)
{
    if (sym->address_space.address_space == 'B') {
        return frame_pointer->frame_pointer + sym->address_space.b >= stack;
    }

    return 1;
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

debug_frame_pointer* debug_stack_frames_construct(uint16_t pc, uint16_t sp, uint16_t ix, uint16_t limit)
{
    debug_frame_pointer* first = NULL;
    debug_frame_pointer* last = NULL;

    uint16_t stack = sp;
    uint16_t at = pc;

    do {
        uint16_t offset;
        symbol* sym = symbol_find_lower(at, SYM_ADDRESS, &offset);

        if (sym == NULL || sym->file == NULL) {
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
            break;
        }

        debug_frame_pointer* new_frame = malloc(sizeof(debug_frame_pointer));

        if (last) {
            last->next = new_frame;
        } else {
            first = new_frame;
        }
        last = new_frame;

        uint16_t frame_pointer;
        if (offset == 0) {
            frame_pointer = stack - 2;
        } else if (offset < 8) {
            // we've pushed old ix but haven't inited old one
            frame_pointer = stack;
        } else {
            frame_pointer = ix;
        }

        const char *filename;
        int   lineno;

        new_frame->next = NULL;
        new_frame->frame_pointer = frame_pointer;
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

        if (offset == 0) {
            // we're exactly at beginning of the function
            uint16_t caller = wrap_reg(bk.get_memory(stack + 1), bk.get_memory(stack));
            at = caller;
            // unwind ret
            stack += 2;
        } else if (offset < 8) {
            // we've pushed old ix but haven't inited old one
            uint16_t caller = wrap_reg(bk.get_memory(stack + 3), bk.get_memory(stack + 2));
            at = caller;
            // unwind ret and ix
            stack += 4;
        } else {
            // ix should point to sp at beginning of the function
            stack = ix;
            // last thing pushed is frame pointer of the caller (its ix)
            ix = wrap_reg(bk.get_memory(ix + 1), bk.get_memory(ix));
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
