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
    expression_result_free(result);
}

void reset_expression_result(struct expression_result_t* result) {
    result->flags = EXPRESSION_UNKNOWN;
    expression_result_free(result);
}

void expression_result_free(struct expression_result_t* result)
{
    if (result->type.first) {
        free_type(result->type.first);
        result->type.first = NULL;
    }
}

void expression_value_to_pointer(struct expression_result_t *from, struct expression_result_t *to, type_record* pointer_type) {
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
        case TYPE_SHORT:
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            to->as_pointer.ptr = (uint16_t)from->as_int;
            return;
        }
        default: {
            to->flags |= EXPRESSION_ERROR;
            char tp[128];
            expression_result_type_to_string(&from->type, from->type.first, tp);
            sprintf(to->as_error, "Cannot convert type %s to a pointer", tp);
            return;
        }
    }
}

void expression_dereference_pointer(struct expression_result_t *from, struct expression_result_t *to) {
    extern backend_t bk;
    if (!(is_type_a_pointer(from->type.first))) {
        to->flags = EXPRESSION_ERROR;
        char tp[128];
        expression_result_type_to_string(&from->type, from->type.first, tp);
        sprintf(to->as_error, "Cannot dereference type: %s", tp);
        return;
    }

    if (from->type.first == NULL || from->type.first->next == NULL) {
        to->flags |= EXPRESSION_ERROR;
        sprintf(to->as_error, "Cannot dereference void");
        return;
    }

    to->type = from->type;
    to->type.first = copy_type_chain(to->type.first->next);
    to->memory_location = from->as_pointer.ptr;

    int16_t data = from->as_pointer.ptr;

    switch (from->type.first->next->type_) {
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
            expression_result_type_to_string(&from->type, from->type.first->next, tp);
            sprintf(to->as_error, "Cannot dereference type (not implemented): %s", tp);
            break;
        }
    }
}

void expression_string_get_type(const char* str, type_record* type) {
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
    if (!(are_type_records_same(&a->type, &b->type))) {
        struct expression_result_t local_3 = {};
        convert_expression(b, &local_3, &a->type);
        expression_math_add(a, &local_3, result);
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
        default: {
            result->flags |= EXPRESSION_ERROR;
            char tp[128];
            expression_result_type_to_string(&a->type, a->type.first, tp);
            sprintf(result->as_error, "Cannot perform math '+' on type %s", tp);
            break;
        }
    }
}

void expression_math_sub(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    if (!(are_type_records_same(&a->type, &b->type))) {
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
        default: {
            result->flags |= EXPRESSION_ERROR;
            char tp[128];
            expression_result_type_to_string(&a->type, a->type.first, tp);
            sprintf(result->as_error, "Cannot perform math '+' on type %s", tp);
            break;
        }
    }
}

void expression_math_mul(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
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
            result->flags |= EXPRESSION_ERROR;
            char tp[128];
            expression_result_type_to_string(&a->type, a->type.first, tp);
            sprintf(result->as_error, "Cannot perform math '+' on type %s", tp);
            break;
        }
    }
}

void expression_math_div(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
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
            result->flags |= EXPRESSION_ERROR;
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
        case TYPE_ARRAY: {
            int maxlen = Max(10,Min(10, result->type.size));
            int offs = snprintf(buffer, buffer_len, "%#04x [%d] = { ", result->as_pointer.ptr, result->type.size);
            uint16_t ptr = result->as_pointer.ptr;
            for ( int i = 0; i < maxlen; i++ ) {
                offs += snprintf(buffer + offs, buffer_len - offs, "%s[%d] = ", i != 0 ? ", " : "", i);
                struct expression_result_t elr = {};
                debug_resolve_expression_element(&result->type, RESOLVE_BY_POINTER, ptr, &elr);
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
            return snprintf(buffer, buffer_len, "{%#04x}", result->as_pointer.ptr);
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
            return 0;
        }
    }
    return 0;
}

void convert_expression(struct expression_result_t* from, struct expression_result_t* to, type_record* type) {
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
