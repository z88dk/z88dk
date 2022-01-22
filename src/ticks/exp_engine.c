#include "exp_engine.h"
#include "backend.h"
#include "debug.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

struct expression_result_t expression_result;

struct {
    const char* type_name;
    uint8_t is_signed;
    enum type_record_type type_of;
} primitive_types[] = {
    {"void",            0,              TYPE_VOID},
    {"char",            1,              TYPE_CHAR},
    {"int8_t",          1,              TYPE_CHAR},
    {"uint8_t",         0,              TYPE_CHAR},
    {"unsigned char",   0,              TYPE_CHAR},
    {"int16_t",         1,              TYPE_INT},
    {"int",             1,              TYPE_INT},
    {"short",           1,              TYPE_INT},
    {"uint16_t",        0,              TYPE_INT},
    {"unsigned int",    0,              TYPE_INT},
    {"unsigned short",  0,              TYPE_INT},
    {"int32_t",         1,              TYPE_LONG},
    {"long",            1,              TYPE_LONG},
    {"uint32_t",        0,              TYPE_LONG},
    {"unsigned long",   0,              TYPE_LONG},
    {"float",           0,              TYPE_FLOAT},
    {NULL,              0,              TYPE_UNKNOWN},
};

uint8_t is_expression_result_error(struct expression_result_t* result) {
    return result->flags & EXPRESSION_ERROR;
}

void set_expression_result_error(struct expression_result_t* result) {
    result->flags |= EXPRESSION_ERROR;
    expression_result_free(result);
}

void set_expression_result_error_str(struct expression_result_t* result, const char* error) {
    result->flags |= EXPRESSION_ERROR;
    strcpy(result->as_error, error);
    expression_result_free(result);
}

void reset_expression_result(struct expression_result_t* result) {
    result->flags = EXPRESSION_UNKNOWN;
    expression_result_free(result);
}

void zero_expression_result(struct expression_result_t* result) {
    result->flags = EXPRESSION_UNKNOWN;
    memset(result, 0, sizeof(struct expression_result_t));
}

void expression_result_free(struct expression_result_t* result) {
    if (result->type.first) {
        free_type(result->type.first);
        result->type.first = NULL;
    }
}

void expression_value_to_pointer(struct expression_result_t *from, struct expression_result_t *to, type_record* pointer_type) {
    zero_expression_result(to);
    if (is_type_a_pointer(from->type.first)) {
        *to = *from;
        to->type.first = malloc_type(TYPE_GENERIC_POINTER);
        to->type.first->next = copy_type_chain(pointer_type->first);
        to->type.signed_ = pointer_type->signed_;
        return;
    }

    to->type.signed_ = pointer_type->signed_;
    to->type.first = malloc_type(TYPE_GENERIC_POINTER);
    to->type.first->next = copy_type_chain(pointer_type->first);

    if (pointer_type->first == NULL) {
        return;
    }

    switch (pointer_type->first->type_) {
        case TYPE_FLOAT: {
            to->as_pointer.ptr = (uint16_t)from->as_float;
            return;
        }
        case TYPE_STRUCTURE: {
            to->as_pointer = from->as_pointer;
            return;
        }
        case TYPE_SHORT:
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            to->as_pointer.ptr = (uint16_t)from->as_int;
            return;
        }
        default: {
            set_expression_result_error(to);
            char tp[128];
            expression_result_type_to_string(&from->type, from->type.first, tp);
            sprintf(to->as_error, "Cannot convert type %s to a pointer", tp);
            return;
        }
    }
}

void expression_dereference_pointer(struct expression_result_t *from, struct expression_result_t *to) {
    zero_expression_result(to);
    extern backend_t bk;
    if (!(is_type_a_pointer(from->type.first))) {
        to->flags = EXPRESSION_ERROR;
        char tp[128];
        expression_result_type_to_string(&from->type, from->type.first, tp);
        sprintf(to->as_error, "Cannot dereference type <%s>", tp);
        return;
    }

    if (from->type.first == NULL || from->type.first->next == NULL) {
        set_expression_result_error(to);
        sprintf(to->as_error, "Cannot dereference void");
        return;
    }

    to->type = from->type;
    to->type.first = copy_type_chain(to->type.first->next);
    to->memory_location = from->as_pointer.ptr;

    int16_t data = from->as_pointer.ptr;

    switch (from->type.first->next->type_) {
        case TYPE_VOID: {
            set_expression_result_error(to);
            sprintf(to->as_error, "Cannot dereference void");
            return;
        }
        case TYPE_STRUCTURE: {
            to->as_pointer.ptr = data;
            break;
        }
        case TYPE_CHAR: {
            to->as_int = bk.get_memory(data);
            break;
        }
        case TYPE_INT: {
            to->as_int = (bk.get_memory(data + 1) << 8) + bk.get_memory(data);
            break;
        }
        case TYPE_LONG:{
            to->as_int = (bk.get_memory(data + 3) << 24) + (bk.get_memory(data + 2) << 16) + (bk.get_memory(data + 1) << 8) + bk.get_memory(data);
            break;
        }
        case TYPE_FLOAT: {
            set_expression_result_error(to);
            sprintf(to->as_error, "Cannot dereference float (not implemented)");
            break;
        }
        default: {
            set_expression_result_error(to);
            char tp[128];
            expression_result_type_to_string(&from->type, from->type.first->next, tp);
            sprintf(to->as_error, "Cannot dereference type (not implemented) <%s>", tp);
            break;
        }
    }
}

void expression_resolve_struct_member_ptr(struct expression_result_t *struct_ptr, const char *member, struct expression_result_t* result) {
    zero_expression_result(result);
    if (!is_type_a_pointer(struct_ptr->type.first)) {
        set_expression_result_error(result);
        char tp[128];
        expression_result_type_to_string(&struct_ptr->type, struct_ptr->type.first, tp);
        sprintf(result->as_error, "Cannot do arrow (->) on a non-pointer type <%s>", tp);
        return;
    }
    struct expression_result_t dereferenced = {};
    expression_dereference_pointer(struct_ptr, &dereferenced);
    if (is_expression_result_error(&dereferenced)) {
        *result = dereferenced;
        return;
    }

    expression_resolve_struct_member(&dereferenced, member, result);
    expression_result_free(&dereferenced);
}

void expression_resolve_struct_member(struct expression_result_t *struct_, const char *member, struct expression_result_t* result) {
    zero_expression_result(result);
    if (struct_->type.first == NULL || (struct_->type.first->type_ != TYPE_STRUCTURE)) {
        set_expression_result_error(result);
        char tp[128];
        expression_result_type_to_string(&struct_->type, struct_->type.first, tp);
        sprintf(result->as_error, "Child member can only be resolved on a struct, got <%s> instead", tp);
        return;
    }

    debug_sym_type* t = cdb_find_type(struct_->type.first->data);
    if (t == NULL) {
        set_expression_result_error(result);
        char tp[128];
        expression_result_type_to_string(&struct_->type, struct_->type.first, tp);
        sprintf(result->as_error, "Cannot lookup child member on an unknown %s", tp);
        return;
    }

    debug_sym_type_member* child = t->first_child;
    while (child)
    {
        if (strcmp(child->symbol->symbol_name, member) == 0) {
            uint16_t ptr = struct_->as_pointer.ptr + child->offset;
            debug_resolve_expression_element(
                &child->symbol->type_record, child->symbol->type_record.first,
                RESOLVE_BY_POINTER, ptr, result);
            return;
        }

        child = child->next;
    }

    set_expression_result_error(result);
    char tp[128];
    expression_result_type_to_string(&struct_->type, struct_->type.first, tp);
    sprintf(result->as_error, "Cannot find child member '%s' on an type <%s>", member, tp);
}

void expression_string_get_type(const char* str, type_record* type) {
    if (strstr(str, "struct ") == str) {
        str += 7;
        debug_sym_type* t = cdb_find_type(str);
        if (t != NULL) {
            type->signed_ = 0;
            type->first = malloc_type(TYPE_STRUCTURE);
            type->first->data = t->name;
            return;
        }
    }
    for (int i = 0; primitive_types[i].type_name; i++) {
        if (strcmp(str, primitive_types[i].type_name) == 0) {
            type->signed_ = primitive_types[i].is_signed;
            type->first = malloc_type(primitive_types[i].type_of);
            type->size = get_type_memory_size(type->first);
            return;
        }
    }
    type->signed_ = 0;
    type->first = malloc_type(TYPE_UNKNOWN);
}

void expression_result_type_to_string(type_record* root, type_chain* type, char* buffer) {
    if (type == NULL) {
        sprintf(buffer, "void");
        return;
    }

    for (int i = 0; primitive_types[i].type_name; i++) {
        if (primitive_types[i].is_signed == root->signed_ && primitive_types[i].type_of == type->type_) {
            strcpy(buffer, primitive_types[i].type_name);
            return;
        }
    }

    switch (type->type_) {
        case TYPE_GENERIC_POINTER: {
            if (type->next == NULL) {
                sprintf(buffer, "void*");
            } else {
                char pointer_type[128];
                expression_result_type_to_string(root, type->next, pointer_type);
                sprintf(buffer, "%s*", pointer_type);
            }
            break;
        }
        case TYPE_ARRAY: {
            if (type->next == NULL) {
                sprintf(buffer, "void*");
            } else {
                char array_type[128];
                expression_result_type_to_string(root, type->next, array_type);
                sprintf(buffer, "%s[]", array_type);
            }
            break;
        }
        case TYPE_STRUCTURE: {
            sprintf(buffer, "struct %s", type->data);
            break;
        }
        default: {
            break;
        }
    }
}

void expression_math_add(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    zero_expression_result(result);
    if (a->type.first == NULL) {
        return;
    }
    if (!is_type_a_pointer(a->type.first) && !(are_type_records_same(&a->type, &b->type))) {
        struct expression_result_t local_3 = {};
        convert_expression(b, &local_3, &a->type);
        expression_math_add(a, &local_3, result);
        expression_result_free(&local_3);
        return;
    }
    result->type = a->type;
    result->type.first = copy_type_chain(a->type.first);
    switch (a->type.first->type_) {
        case TYPE_FLOAT: {
            result->as_float = a->as_float + b->as_float;
            break;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            if (a->type.signed_) {
                result->as_int = a->as_int + b->as_int;
            } else {
                result->as_uint = (uint32_t)((uint32_t)a->as_int + (uint32_t)b->as_int);
            }
            break;
        }
        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER:
        {
            if (a->type.first->next == NULL) {
                set_expression_result_error(result);
                sprintf(result->as_error, "Cannot do void pointer math");
                break;
            }
            if (is_primitive_integer_type(b->type.first)) {
                result->as_pointer.ptr = a->as_pointer.ptr + b->as_int * get_type_memory_size(a->type.first->next);
            } else {
                set_expression_result_error(result);
                sprintf(result->as_error, "Cannot do pointer math with non-integers");
                break;
            }
            break;
        }
        default: {
            set_expression_result_error(result);
            char tp[128];
            expression_result_type_to_string(&a->type, a->type.first, tp);
            sprintf(result->as_error, "Cannot perform math '+' on type %s", tp);
            break;
        }
    }
}

void expression_math_sub(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    zero_expression_result(result);
    if (a->type.first == NULL) {
        return;
    }
    if (!is_type_a_pointer(a->type.first) && !(are_type_records_same(&a->type, &b->type))) {
        struct expression_result_t local_3 = {};
        convert_expression(b, &local_3, &a->type);
        expression_math_sub(a, &local_3, result);
        expression_result_free(&local_3);
        return;
    }
    if (a->type.first == NULL) {
        return;
    }
    result->type = a->type;
    result->type.first = copy_type_chain(a->type.first);
    switch (a->type.first->type_) {
        case TYPE_FLOAT: {
            result->as_float = a->as_float - b->as_float;
            break;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            if (a->type.signed_) {
                result->as_int = a->as_int - b->as_int;
            } else {
                result->as_uint = (uint32_t)((uint32_t)a->as_int - (uint32_t)b->as_int);
            }
            break;
        }
        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER:
        {
            if (a->type.first->next == NULL) {
                set_expression_result_error(result);
                sprintf(result->as_error, "Cannot do void pointer math");
                break;
            }
            if (is_primitive_integer_type(b->type.first)) {
                result->as_pointer.ptr = a->as_pointer.ptr - b->as_int * get_type_memory_size(a->type.first->next);
            } else {
                set_expression_result_error(result);
                sprintf(result->as_error, "Cannot do pointer math with non-integers");
                break;
            }
            break;
        }
        default: {
            set_expression_result_error(result);
            char tp[128];
            expression_result_type_to_string(&a->type, a->type.first, tp);
            sprintf(result->as_error, "Cannot perform math '+' on type %s", tp);
            break;
        }
    }
}

void expression_math_mul(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    zero_expression_result(result);
    if (!(are_type_records_same(&a->type, &b->type))) {
        struct expression_result_t local_3 = {};
        convert_expression(b, &local_3, &a->type);
        expression_math_mul(a, &local_3, result);
        expression_result_free(&local_3);
        return;
    }
    if (a->type.first == NULL) {
        return;
    }
    result->type = a->type;
    result->type.first = copy_type_chain(a->type.first);
    switch (a->type.first->type_) {
        case TYPE_FLOAT: {
            result->as_float = a->as_float * b->as_float;
            break;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            if (a->type.signed_) {
                result->as_int = a->as_int * b->as_int;
            } else {
                result->as_uint = (uint32_t)((uint32_t)a->as_int * (uint32_t)b->as_int);
            }
            break;
        }
        default: {
            set_expression_result_error(result);
            char tp[128];
            expression_result_type_to_string(&a->type, a->type.first, tp);
            sprintf(result->as_error, "Cannot perform math '+' on type %s", tp);
            break;
        }
    }
}

void expression_math_div(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    zero_expression_result(result);
    if (!(are_type_records_same(&a->type, &b->type))) {
        struct expression_result_t local_3 = {};
        convert_expression(b, &local_3, &a->type);
        expression_math_div(a, &local_3, result);
        expression_result_free(&local_3);
        return;
    }
    if (a->type.first == NULL) {
        return;
    }
    result->type = a->type;
    result->type.first = copy_type_chain(a->type.first);
    switch (a->type.first->type_) {
        case TYPE_FLOAT: {
            result->as_float = a->as_float / b->as_float;
            break;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            if (a->type.signed_) {
                result->as_int = a->as_int / b->as_int;
            } else {
                result->as_uint = (uint32_t)((uint32_t)a->as_int / (uint32_t)b->as_int);
            }
            break;
        }
        default: {
            set_expression_result_error(result);
            char tp[128];
            expression_result_type_to_string(&a->type, a->type.first, tp);
            sprintf(result->as_error, "Cannot perform math '+' on type %s", tp);
            break;
        }
    }
}

static int Min(int a, int b) { if (a < b ) return a; else return b;}
static int Max(int a, int b) { if (a > b ) return a; else return b;}

int expression_result_value_to_string(struct expression_result_t* result, char* buffer, int buffer_len) {
    if (result->type.first == NULL) {
        return snprintf(buffer, buffer_len, "<none>");
    }
    switch (result->type.first->type_) {
        case TYPE_UNKNOWN: {
            return snprintf(buffer, buffer_len, "<unknown>");
        }
        case TYPE_FUNCTION: {
            return snprintf(buffer, buffer_len, "<function>");
        }
        case TYPE_ARRAY: {
            int maxlen = Max(10,Min(10, result->type.size));
            int offs = snprintf(buffer, buffer_len, "%#04x [%d] = { ", result->as_pointer.ptr, result->type.size);
            uint16_t ptr = result->as_pointer.ptr;
            for ( int i = 0; i < maxlen; i++ ) {
                offs += snprintf(buffer + offs, buffer_len - offs, "%s[%d] = ", i != 0 ? ", " : "", i);
                struct expression_result_t elr = {};
                debug_resolve_expression_element(&result->type, result->type.first->next, RESOLVE_BY_POINTER, ptr, &elr);
                if (is_expression_result_error(&elr)) {
                    offs += snprintf(buffer + offs, buffer_len - offs, "<error:%s>", elr.as_error);
                    break;
                } else {
                    offs += expression_result_value_to_string(&elr, buffer + offs, buffer_len - offs);
                    ptr += get_type_memory_size(result->type.first->next);
                }
                expression_result_free(&elr);
            }
            offs += snprintf(buffer + offs, buffer_len - offs,"%s }", maxlen != result->type.size ? " ..." : "");
            return offs;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            if (result->type.signed_) {
                return snprintf(buffer, buffer_len, "%i", result->as_int);
            } else {
                return snprintf(buffer, buffer_len, "%u", result->as_uint);
            }
        }
        case TYPE_FLOAT: {
            return snprintf(buffer, buffer_len, "%f", result->as_float);
        }
        case TYPE_STRUCTURE: {
            const char* struct_name = result->type.first->data;
            if (struct_name == NULL) {
                return snprintf(buffer, buffer_len, "{%#04x}", result->as_pointer.ptr);
            }
            debug_sym_type* t = cdb_find_type(struct_name);
            if (t == NULL) {
                return snprintf(buffer, buffer_len, "{%#04x}", result->as_pointer.ptr);
            }
            debug_sym_type_member* child = t->first_child;
            uint16_t ptr = result->as_pointer.ptr;
            int offs = snprintf(buffer, buffer_len, "{");
            uint8_t first = 1;
            while (child) {
                if (first) {
                    first = 0;
                    offs += snprintf(buffer + offs, buffer_len - offs, "%s=", child->symbol->symbol_name);
                } else {
                    offs += snprintf(buffer + offs, buffer_len - offs, ", %s=", child->symbol->symbol_name);
                }
                struct expression_result_t child_result = {};
                debug_resolve_expression_element(&child->symbol->type_record, child->symbol->type_record.first,
                    RESOLVE_BY_POINTER, ptr + child->offset, &child_result);
                if (is_expression_result_error(&child_result)) {
                    offs += snprintf(buffer + offs, buffer_len - offs, "<error:%s>", child_result.as_error);
                    expression_result_free(&child_result);
                    break;
                } else {
                    offs += expression_result_value_to_string(&child_result, buffer + offs, buffer_len - offs);
                    expression_result_free(&child_result);
                }
                child = child->next;
            }
            offs += snprintf(buffer + offs, buffer_len - offs, "}");
            return offs;
        }
        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER: {
            if (result->type.first->next == NULL) {
                return snprintf(buffer, buffer_len, "%#04x", result->as_pointer.ptr);
            }
            switch (result->type.first->next->type_) {
                case TYPE_INT:
                case TYPE_LONG:
                {
                    struct expression_result_t local = {};
                    expression_dereference_pointer(result, &local);
                    int offs;
                    if (local.flags & EXPRESSION_ERROR) {
                        offs = snprintf(buffer, buffer_len, "%#04x(error:%s)", result->as_pointer.ptr, local.as_error);
                    } else {
                        char buff[128];
                        expression_result_value_to_string(&local, buff, 128);
                        offs = snprintf(buffer, buffer_len, "%#04x(%s)", result->as_pointer.ptr, buff);
                    }
                    expression_result_free(&local);
                    return offs;
                }
                case TYPE_CHAR: {
                    char buff [128];

                    int i = 0;
                    while (i < 128) {
                        char c = bk.get_memory(result->as_pointer.ptr + i);
                        if (c == 0) {
                            break;
                        }
                        if (isprint(c)) {
                            buff[i++] = c;
                        } else {
                            buff[i++] = '.';
                        }
                    }
                    return snprintf(buffer, buffer_len, "%#04x(\"%s\")", result->as_pointer.ptr, buff);
                }
                default: {
                    return snprintf(buffer, buffer_len, "%#04x", result->as_pointer.ptr);
                }
            }
        }
        default: {
            return snprintf(buffer, buffer_len, "<unknown:%d>", result->type.first->type_);
        }
    }
    return 0;
}

void convert_expression(struct expression_result_t* from, struct expression_result_t* to, type_record* type) {
    zero_expression_result(to);
    to->type = *type;
    to->type.first = copy_type_chain(type->first);
    to->memory_location = from->memory_location;
    if (type->first == NULL) {
        return;
    }
    switch (from->type.first->type_) {
        case TYPE_FLOAT: {
            switch (type->first->type_) {
                case TYPE_FLOAT: {
                    to->as_float = from->as_float;
                    break;
                }
                case TYPE_CHAR:
                case TYPE_INT:
                case TYPE_LONG: {
                    to->as_int = (int32_t)from->as_float;
                    break;
                }
                default:
                {
                    break;
                }
            }
            break;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            switch (type->first->type_) {
                case TYPE_FLOAT: {
                    to->as_float = (int32_t)from->as_int;
                    break;
                }
                case TYPE_CHAR:
                case TYPE_INT:
                case TYPE_LONG: {
                    to->as_int = from->as_int;
                    break;
                }
                case TYPE_GENERIC_POINTER:
                case TYPE_CODE_POINTER: {
                    to->as_pointer.ptr = (uint16_t)from->as_int;
                }
                default: {
                    break;
                }
            }
            break;
        }

        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER: {
            switch (type->first->type_) {
                case TYPE_FLOAT: {
                    to->as_float = (float)from->as_pointer.ptr;
                    break;
                }
                case TYPE_CHAR:
                case TYPE_INT:
                case TYPE_LONG: {
                    to->as_int = (int32_t)from->as_pointer.ptr;
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        default: {
            break;
        }
    }
}

struct expression_result_t* get_expression_result() {
    return &expression_result;
}
