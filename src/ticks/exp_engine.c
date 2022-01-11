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

void set_expression_result_error(struct expression_result_t* result, const char* error) {
    result->flags |= EXPRESSION_ERROR;
    strcpy(result->as_error, error);
}

void reset_expression_result(struct expression_result_t* result) {
    result->flags = EXPRESSION_UNKNOWN;
}

void expression_result_free_typechain(struct expression_result_t* result)
{
    type_chain* next = result->type.next;
    while (next) {
        type_chain* next_next = next->next;
        free(next);
        next = next_next;
    }
}

static uint8_t is_expression_a_pointer(struct expression_result_t *exp) {
    return exp->type.type_ == TYPE_GENERIC_POINTER ||  exp->type.type_ == TYPE_CODE_POINTER;
}

uint8_t is_expression_signed(struct expression_result_t *exp) {
    return exp->flags & EXPRESSION_TYPE_SIGNED;
}

void set_expression_signed(struct expression_result_t *exp, uint8_t is_signed) {
    if (is_signed) {
        exp->flags |= EXPRESSION_TYPE_SIGNED;
    } else {
        exp->flags &= ~EXPRESSION_TYPE_SIGNED;
    }
}

void expression_value_to_pointer(struct expression_result_t *from, struct expression_result_t *to, type_chain* pointer_type, uint8_t is_signed) {
    if (is_expression_a_pointer(from)) {
        *to = *from;
        to->type.type_ = TYPE_GENERIC_POINTER;
        to->type.next = copy_type_chain(pointer_type);
        set_expression_signed(to, is_signed);
        return;
    }

    type_chain* type_of = copy_type_chain(pointer_type);
    set_expression_signed(to, is_signed);
    to->type.type_ = TYPE_GENERIC_POINTER;
    to->type.next = type_of;

    switch (from->type.type_) {
        case TYPE_FLOAT: {
            to->as_pointer.ptr = (uint16_t)from->as_float;
            to->as_pointer.element_size = from->memory_size;
            return;
        }
        case TYPE_SHORT:
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            to->as_pointer.ptr = (uint16_t)from->as_int;
            to->as_pointer.element_size = from->memory_size;
            return;
        }
        default: {
            to->flags |= EXPRESSION_ERROR;
            char tp[128];
            expression_result_type_to_string(&from->type, is_expression_signed(from), tp);
            sprintf(to->as_error, "Cannot convert type %s to a pointer", tp);
            return;
        }
    }
}

void expression_dereference_pointer(struct expression_result_t *from, struct expression_result_t *to) {
    extern backend_t bk;
    if (!(is_expression_a_pointer(from))) {
        to->flags = EXPRESSION_ERROR;
        char tp[128];
        expression_result_type_to_string(&from->type, is_expression_signed(from), tp);
        sprintf(to->as_error, "Cannot dereference type: %s", tp);
        return;
    }

    if (from->type.next == NULL) {
        to->flags |= EXPRESSION_ERROR;
        sprintf(to->as_error, "Cannot dereference void");
        return;
    }

    to->type = *from->type.next;
    to->type.next = copy_type_chain(to->type.next);
    to->memory_location = from->as_pointer.ptr;
    to->memory_size = from->as_pointer.element_size;

    int16_t data = from->as_pointer.ptr;

    switch (to->type.type_) {
        case TYPE_VOID: {
            to->flags |= EXPRESSION_ERROR;
            sprintf(to->as_error, "Cannot dereference void");
            return;
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
            to->flags |= EXPRESSION_ERROR;
            sprintf(to->as_error, "Cannot dereference float (not implemented)");
            break;
        }
        default: {
            to->flags |= EXPRESSION_ERROR;
            char tp[128];
            expression_result_type_to_string(&from->type, is_expression_signed(from), tp);
            sprintf(to->as_error, "Cannot dereference type (not implemented): %s", tp);
            break;
        }
    }
}

type_chain expression_string_get_type(const char* str, uint8_t* is_signed) {
    type_chain result = {};
    for (int i = 0; primitive_types[i].type_name; i++) {
        if (strcmp(str, primitive_types[i].type_name) == 0) {
            *is_signed = primitive_types[i].is_signed;
            result.type_ = primitive_types[i].type_of;
            return result;
        }
    }
    *is_signed = 0;
    result.type_ = TYPE_UNKNOWN;
    return result;
}

void expression_result_type_to_string(type_chain* type, uint8_t is_signed, char* buffer) {
    for (int i = 0; primitive_types[i].type_name; i++) {
        if (primitive_types[i].is_signed == is_signed && primitive_types[i].type_of == type->type_) {
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
                expression_result_type_to_string(type->next, is_signed, pointer_type);
                sprintf(buffer, "%s*", pointer_type);
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

static uint8_t are_exp_same_type(struct expression_result_t* a, type_chain* ta,
    struct expression_result_t* b, type_chain* tb)
{
    if (is_expression_signed(a) != is_expression_signed(b)) {
        return 0;
    }
    if (ta->type_ != tb->type_) {
        return 0;
    }
    if (is_expression_a_pointer(a)) {
        if (ta->next == NULL || tb->next == NULL) {
            return 0;
        }
        return are_exp_same_type(a, ta->next, b, tb->next);
    }
    return 1;
}

void expression_math_add(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    if (!(are_exp_same_type(a, &a->type, b, &b->type))) {
        struct expression_result_t local_3 = {};
        convert_expression(b, &local_3, a->type.type_, is_expression_signed(b));
        expression_math_add(a, &local_3, result);
        return;
    }

    switch (a->type.type_) {
        case TYPE_FLOAT: {
            result->as_float = a->as_float + b->as_float;
            return;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            if (is_expression_signed(a)) {
                result->as_int = a->as_int + b->as_int;
            } else {
                result->as_uint = (uint32_t)((uint32_t)a->as_int + (uint32_t)b->as_int);
            }
            return;
        }
        default: {
            result->flags |= EXPRESSION_ERROR;
            char tp[128];
            expression_result_type_to_string(&a->type, is_expression_signed(a), tp);
            sprintf(result->as_error, "Cannot perform math '+' on type %s", tp);
            break;
        }
    }
}

void expression_math_sub(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    if (!(are_exp_same_type(a, &a->type, b, &b->type))) {
        struct expression_result_t local_3 = {};
        convert_expression(b, &local_3, a->type.type_, is_expression_signed(b));
        expression_math_sub(a, &local_3, result);
        return;
    }

    switch (a->type.type_) {
        case TYPE_FLOAT: {
            result->as_float = a->as_float - b->as_float;
            return;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            if (is_expression_signed(a)) {
                result->as_int = a->as_int - b->as_int;
            } else {
                result->as_uint = (uint32_t)((uint32_t)a->as_int - (uint32_t)b->as_int);
            }
            return;
        }
        default: {
            result->flags |= EXPRESSION_ERROR;
            char tp[128];
            expression_result_type_to_string(&a->type, is_expression_signed(a), tp);
            sprintf(result->as_error, "Cannot perform math '+' on type %s", tp);
            break;
        }
    }
}

void expression_math_mul(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    if (!(are_exp_same_type(a, &a->type, b, &b->type))) {
        struct expression_result_t local_3 = {};
        convert_expression(b, &local_3, a->type.type_, is_expression_signed(b));
        expression_math_mul(a, &local_3, result);
        return;
    }

    switch (a->type.type_) {
        case TYPE_FLOAT: {
            result->as_float = a->as_float * b->as_float;
            return;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            if (is_expression_signed(a)) {
                result->as_int = a->as_int * b->as_int;
            } else {
                result->as_uint = (uint32_t)((uint32_t)a->as_int * (uint32_t)b->as_int);
            }
            return;
        }
        default: {
            result->flags |= EXPRESSION_ERROR;
            char tp[128];
            expression_result_type_to_string(&a->type, is_expression_signed(a), tp);
            sprintf(result->as_error, "Cannot perform math '+' on type %s", tp);
            break;
        }
    }
}

void expression_math_div(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    if (!(are_exp_same_type(a, &a->type, b, &b->type))) {
        struct expression_result_t local_3 = {};
        convert_expression(b, &local_3, a->type.type_, is_expression_signed(b));
        expression_math_div(a, &local_3, result);
        return;
    }

    switch (a->type.type_) {
        case TYPE_FLOAT: {
            result->as_float = a->as_float / b->as_float;
            return;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            if (is_expression_signed(a)) {
                result->as_int = a->as_int / b->as_int;
            } else {
                result->as_uint = (uint32_t)((uint32_t)a->as_int / (uint32_t)b->as_int);
            }
            return;
        }
        default: {
            result->flags |= EXPRESSION_ERROR;
            char tp[128];
            expression_result_type_to_string(&a->type, is_expression_signed(a), tp);
            sprintf(result->as_error, "Cannot perform math '+' on type %s", tp);
            break;
        }
    }
}

uint8_t is_primitive_integer_type(struct expression_result_t* exp) {
    switch (exp->type.type_) {
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

static int Min(int a, int b) { if (a < b ) return a; else return b;}
static int Max(int a, int b) { if (a > b ) return a; else return b;}

int expression_result_value_to_string(struct expression_result_t* result, char* buffer, int buffer_len) {
    switch (result->type.type_) {
        case TYPE_UNKNOWN: {
            return snprintf(buffer, buffer_len, "<unknown>");
        }
        case TYPE_ARRAY: {
            int maxlen = Max(10,Min(10, result->type.size));
            int offs = snprintf(buffer, buffer_len, "%#04x [%d] = { ", result->as_pointer.ptr, result->type.size);
            uint16_t ptr = result->as_pointer.ptr;
            for ( int i = 0; i < maxlen; i++ ) {
                offs += snprintf(buffer + offs, buffer_len - offs, "%s[%d] = ", i != 0 ? ", " : "", i);
                struct expression_result_t elr = {};
                debug_resolve_expression_element(result->type.next, is_expression_signed(result), RESOLVE_BY_POINTER, ptr, &elr);
                if (is_expression_result_error(&elr)) {
                    offs += snprintf(buffer + offs, buffer_len - offs, "<error:%s>", elr.as_error);
                    break;
                } else {
                    offs += expression_result_value_to_string(&elr, buffer + offs, buffer_len - offs);
                    ptr += elr.memory_size;
                }
            }
            offs += snprintf(buffer + offs, buffer_len - offs,"%s }", maxlen != result->type.size ? " ..." : "");
            return offs;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            if (is_expression_signed(result)) {
                return snprintf(buffer, buffer_len, "%i", result->as_int);
            } else {
                return snprintf(buffer, buffer_len, "%u", result->as_uint);
            }
        }
        case TYPE_FLOAT: {
            return snprintf(buffer, buffer_len, "%f", result->as_float);
        }
        case TYPE_STRUCTURE: {
            return snprintf(buffer, buffer_len, "{%#04x}", result->as_pointer.ptr);
        }
        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER: {
            if (result->type.next == NULL) {
                return snprintf(buffer, buffer_len, "%#04x", result->as_pointer.ptr);
            }
            switch (result->type.next->type_) {
                case TYPE_INT:
                case TYPE_LONG:
                {
                    struct expression_result_t local = {};
                    expression_dereference_pointer(result, &local);
                    char buff[128];
                    expression_result_value_to_string(&local, buff, 128);
                    return snprintf(buffer, buffer_len, "%#04x(%s)", result->as_pointer.ptr, buff);
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
            return 0;
        }
    }
    return 0;
}

void convert_expression(struct expression_result_t* from, struct expression_result_t* to,
    enum type_record_type type, uint8_t is_signed
) {
    to->type.type_ = type;
    to->type.next = NULL;
    set_expression_signed(to, is_signed);
    to->memory_location = from->memory_location;
    switch (from->type.type_) {
        case TYPE_FLOAT: {
            switch (type) {
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
            switch (type) {
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
                    to->as_pointer.element_size = from->memory_size;
                    to->type.next = NULL;
                }
                default: {
                    break;
                }
            }
            break;
        }

        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER: {
            switch (type) {
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
