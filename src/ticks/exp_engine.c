#include "exp_engine.h"
#include "backend.h"
#include "debug.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

struct expression_result_t expression_result = {0};
struct history_expression_t* history_expressions = NULL;

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
            UT_string* tp = expression_result_type_to_string(&from->type, from->type.first);
            snprintf(to->as_error, sizeof(to->as_error),
                "Cannot convert type %s to a pointer", utstring_body(tp));
            utstring_free(tp);
            return;
        }
    }
}

void expression_primitive_func_call_1(const char* call, struct expression_result_t* a, struct expression_result_t* to) {
    if (is_expression_result_error(a)) {
        set_expression_result_error(to);
        snprintf(to->as_error, sizeof(to->as_error), "Can not obtain sizeof: %s", a->as_error);
        return;
    }
    if (strcmp(call, "sizeof") == 0) {
        if (a->type.first != NULL) {
            to->type.first = malloc_type(TYPE_INT);
            to->as_int = a->type.first->size;
        } else {
            to->type.first = malloc_type(TYPE_INT);
            to->as_int = (int)a->type.size;
        }
        return;
    }

    set_expression_result_error(to);
    sprintf(to->as_error, "Unknown function call: %s", call);
}

void expression_dereference_pointer(struct expression_result_t *from, struct expression_result_t *to) {
    zero_expression_result(to);

    if (!(is_type_a_pointer(from->type.first))) {
        to->flags = EXPRESSION_ERROR;
        UT_string* tp = expression_result_type_to_string(&from->type, from->type.first);
        snprintf(to->as_error, sizeof(to->as_error), "Cannot dereference type <%s>", utstring_body(tp));
        utstring_free(tp);
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

    int16_t data = (int16_t)from->as_pointer.ptr;

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
            to->as_int = bk.get_memory(data, MEM_TYPE_DATA);
            break;
        }
        case TYPE_INT: {
            to->as_int = (bk.get_memory(data + 1, MEM_TYPE_DATA) << 8) + bk.get_memory(data, MEM_TYPE_DATA);
            break;
        }
        case TYPE_LONG:{
            to->as_int = (bk.get_memory(data + 3, MEM_TYPE_DATA) << 24) + (bk.get_memory(data + 2, MEM_TYPE_DATA) << 16) + (bk.get_memory(data + 1, MEM_TYPE_DATA) << 8) + bk.get_memory(data, MEM_TYPE_DATA);
            break;
        }
        case TYPE_FLOAT: {
            set_expression_result_error(to);
            sprintf(to->as_error, "Cannot dereference float (not implemented)");
            break;
        }
        default: {
            set_expression_result_error(to);
            UT_string* tp = expression_result_type_to_string(&from->type, from->type.first->next);
            snprintf(to->as_error, sizeof(to->as_error),
                "Cannot dereference type (not implemented) <%s>", utstring_body(tp));
            utstring_free(tp);
            break;
        }
    }
}

void expression_resolve_struct_member_ptr(struct expression_result_t *struct_ptr, const char *member, struct expression_result_t* result) {
    zero_expression_result(result);
    if (!is_type_a_pointer(struct_ptr->type.first)) {
        set_expression_result_error(result);
        UT_string* tp = expression_result_type_to_string(&struct_ptr->type, struct_ptr->type.first);
        snprintf(result->as_error, sizeof(result->as_error),
            "Cannot do arrow (->) on a non-pointer type <%s>", utstring_body(tp));
        utstring_free(tp);
        return;
    }
    struct expression_result_t dereferenced = {0};
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
        UT_string* tp = expression_result_type_to_string(&struct_->type, struct_->type.first);
        snprintf(result->as_error, sizeof(result->as_error),
            "Child member can only be resolved on a struct, got <%s> instead", utstring_body(tp));
        utstring_free(tp);
        return;
    }

    debug_sym_type* t = cdb_find_type(struct_->type.first->data);
    if (t == NULL) {
        set_expression_result_error(result);
        UT_string* tp = expression_result_type_to_string(&struct_->type, struct_->type.first);
        snprintf(result->as_error, sizeof(result->as_error),
            "Cannot lookup child member on an unknown %s", utstring_body(tp));
        utstring_free(tp);
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
    UT_string* tp = expression_result_type_to_string(&struct_->type, struct_->type.first);
    snprintf(result->as_error, sizeof(result->as_error),
        "Cannot find child member '%s' on an type <%s>", member, utstring_body(tp));
    utstring_free(tp);
}

void expression_get_struct_members(struct expression_result_t* result, int* count, char** members)
{
    *count = 0;

    if (result->type.first->type_ == TYPE_GENERIC_POINTER ||
        result->type.first->type_ == TYPE_CODE_POINTER) {

        struct expression_result_t dereferenced = {0};
        expression_dereference_pointer(result, &dereferenced);
        expression_get_struct_members(&dereferenced, count, members);
        expression_result_free(&dereferenced);

        return;
    }

    if (result->type.first->type_ != TYPE_STRUCTURE) {
        return;
    }

    const char* struct_name = result->type.first->data;
    if (struct_name == NULL) {
        return;
    }
    debug_sym_type* t = cdb_find_type(struct_name);
    if (t == NULL) {
        bk.debug("No debug information on struct %s\n", struct_name);
        return;
    }
    debug_sym_type_member* child = t->first_child;
    while (child) {
        if (members == NULL) {
            (*count)++;
        } else {
            members[(*count)++] = (char*)child->symbol->symbol_name;
        }
        child = child->next;
    }
}

int expression_count_members(struct expression_result_t* result)
{
    int num_child = 0;

    if (result->type.first == NULL) {
        return 0;
    }

    switch (result->type.first->type_)
    {
        case TYPE_CODE_POINTER:
        case TYPE_GENERIC_POINTER:
        {
            struct expression_result_t dereferenced = {0};
            expression_dereference_pointer(result, &dereferenced);
            num_child = expression_count_members(&dereferenced);
            expression_result_free(&dereferenced);
            break;
        }
        case TYPE_STRUCTURE:
        {
            expression_get_struct_members(result, &num_child, NULL);
            break;
        }
        default:
        {
            return 0;
        }
    }

    return num_child;
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

UT_string* expression_result_type_to_string(type_record* root, type_chain* type) {
    UT_string* buffer;
    utstring_new(buffer);

    if (type == NULL) {
        utstring_printf(buffer, "void");
        return buffer;
    }

    for (int i = 0; primitive_types[i].type_name; i++) {
        if (primitive_types[i].is_signed == root->signed_ && primitive_types[i].type_of == type->type_) {
            utstring_printf(buffer, "%s", primitive_types[i].type_name);
            return buffer;
        }
    }

    switch (type->type_) {
        case TYPE_GENERIC_POINTER: {
            if (type->next == NULL) {
                utstring_printf(buffer, "void*");
            } else {
                UT_string* pointer_type = expression_result_type_to_string(root, type->next);
                utstring_printf(buffer, "%s*", utstring_body(pointer_type));
                utstring_free(pointer_type);
            }
            break;
        }
        case TYPE_ARRAY: {
            if (type->next == NULL) {
                utstring_printf(buffer, "void*");
            } else {
                UT_string* array_type = expression_result_type_to_string(root, type->next);
                utstring_printf(buffer, "%s[]", utstring_body(array_type));
                utstring_free(array_type);
            }
            break;
        }
        case TYPE_STRUCTURE: {
            utstring_printf(buffer, "struct %s", type->data);
            break;
        }
        case TYPE_FUNCTION: {
            utstring_printf(buffer, "function");
            break;
        }
        default: {
            break;
        }
    }

    return buffer;
}

void expression_math_add(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    zero_expression_result(result);
    if (a->type.first == NULL) {
        return;
    }
    if (!is_type_a_pointer(a->type.first) && !(are_type_records_same(&a->type, &b->type))) {
        struct expression_result_t local_3 = {0};
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
            UT_string* tp = expression_result_type_to_string(&a->type, a->type.first);
            snprintf(result->as_error, sizeof(result->as_error),
                "Cannot perform math '+' on type %s", utstring_body(tp));
            utstring_free(tp);
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
        struct expression_result_t local_3 = {0};
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
            UT_string* tp = expression_result_type_to_string(&a->type, a->type.first);
            snprintf(result->as_error, sizeof(result->as_error),
                "Cannot perform math '+' on type %s", utstring_body(tp));
            utstring_free(tp);
            break;
        }
    }
}

void expression_math_mul(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    zero_expression_result(result);
    if (!(are_type_records_same(&a->type, &b->type))) {
        struct expression_result_t local_3 = {0};
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
            UT_string* tp = expression_result_type_to_string(&a->type, a->type.first);
            snprintf(result->as_error, sizeof(result->as_error),
                "Cannot perform math '+' on type %s", utstring_body(tp));
            utstring_free(tp);
            break;
        }
    }
}

void expression_math_div(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result) {
    zero_expression_result(result);
    if (!(are_type_records_same(&a->type, &b->type))) {
        struct expression_result_t local_3 = {0};
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
            UT_string* tp = expression_result_type_to_string(&a->type, a->type.first);
            snprintf(result->as_error, sizeof(result->as_error),
                "Cannot perform math '+' on type %s", utstring_body(tp));
            utstring_free(tp);
            break;
        }
    }
}

static int Min(int a, int b) { if (a < b ) return a; else return b;}
static int Max(int a, int b) { if (a > b ) return a; else return b;}

UT_string* expression_result_value_to_string(struct expression_result_t* result) {
    UT_string* buffer;
    utstring_new(buffer);
    if (result->type.first == NULL) {
        utstring_printf(buffer, "<none>");
        return buffer;
    }
    switch (result->type.first->type_) {
        case TYPE_UNKNOWN: {
            utstring_printf(buffer, "<unknown>");
            return buffer;
        }
        case TYPE_FUNCTION: {
            utstring_printf(buffer, "<function>");
            return buffer;
        }
        case TYPE_ARRAY: {
            int maxlen = Max(0, Min(10, (int)result->type.size));
            utstring_printf(buffer, "%#04x [%d] = { ", result->as_pointer.ptr, (int)result->type.size);
            uint16_t ptr = result->as_pointer.ptr;
            for ( int i = 0; i < maxlen; i++ ) {
                utstring_printf(buffer, "%s[%d] = ", i != 0 ? ", " : "", i);
                struct expression_result_t elr = {0};
                debug_resolve_expression_element(&result->type, result->type.first->next, RESOLVE_BY_POINTER, ptr, &elr);
                if (is_expression_result_error(&elr)) {
                    utstring_printf(buffer, "<error:%s>", elr.as_error);
                    break;
                } else {
                    UT_string* sub_value = expression_result_value_to_string(&elr);
                    utstring_printf(buffer, "%s", utstring_body(sub_value));
                    utstring_free(sub_value);
                    ptr += get_type_memory_size(result->type.first->next);
                }
                expression_result_free(&elr);
            }
            utstring_printf(buffer, "%s }", maxlen != result->type.size ? " ..." : "");
            return buffer;
        }
        case TYPE_CHAR:
        case TYPE_INT:
        case TYPE_LONG: {
            if (result->type.signed_) {
                utstring_printf(buffer, "%i", result->as_int);
                return buffer;
            } else {
                utstring_printf(buffer, "%u", result->as_uint);
                return buffer;
            }
        }
        case TYPE_FLOAT: {
            utstring_printf(buffer, "%f", result->as_float);
            return buffer;
        }
        case TYPE_STRUCTURE: {
            const char* struct_name = result->type.first->data;
            if (struct_name == NULL) {
                utstring_printf(buffer, "{%#04x}", result->as_pointer.ptr);
                return buffer;
            }
            debug_sym_type* t = cdb_find_type(struct_name);
            if (t == NULL) {
                utstring_printf(buffer, "{%#04x}", result->as_pointer.ptr);
                return buffer;
            }
            debug_sym_type_member* child = t->first_child;
            uint16_t ptr = result->as_pointer.ptr;
            utstring_printf(buffer, "{");
            uint8_t first = 1;
            while (child) {
                if (first) {
                    first = 0;
                    utstring_printf(buffer, "%s=", child->symbol->symbol_name);
                } else {
                    utstring_printf(buffer, ", %s=", child->symbol->symbol_name);
                }
                struct expression_result_t child_result = {0};
                debug_resolve_expression_element(&child->symbol->type_record, child->symbol->type_record.first,
                    RESOLVE_BY_POINTER, ptr + child->offset, &child_result);
                if (is_expression_result_error(&child_result)) {
                    utstring_printf(buffer, "<error:%s>", child_result.as_error);
                    expression_result_free(&child_result);
                    break;
                } else {
                    UT_string* sub_value = expression_result_value_to_string(&child_result);
                    utstring_printf(buffer, "%s", utstring_body(sub_value));
                    utstring_free(sub_value);
                    expression_result_free(&child_result);
                }
                child = child->next;
            }
            utstring_printf(buffer, "}");
            return buffer;
        }
        case TYPE_GENERIC_POINTER:
        case TYPE_CODE_POINTER: {
            if (result->type.first->next == NULL) {
                utstring_printf(buffer, "%#04x", result->as_pointer.ptr);
                return buffer;
            }
            switch (result->type.first->next->type_) {
                case TYPE_INT:
                case TYPE_LONG:
                {
                    struct expression_result_t local = {0};
                    expression_dereference_pointer(result, &local);
                    if (local.flags & EXPRESSION_ERROR) {
                        utstring_printf(buffer, "%#04x(error:%s)", result->as_pointer.ptr, local.as_error);
                    } else {
                        UT_string* resolved_int = expression_result_value_to_string(&local);
                        utstring_printf(buffer, "%#04x(%s)", result->as_pointer.ptr, utstring_body(resolved_int));
                        utstring_free(resolved_int);
                    }
                    expression_result_free(&local);
                    return buffer;
                }
                case TYPE_CHAR: {
                    char buff [128];

                    int i = 0;
                    while (i < 128) {
                        uint8_t c = bk.get_memory(result->as_pointer.ptr + i, MEM_TYPE_DATA);
                        if (c == 0) {
                            break;
                        }
                        if (isprint(c)) {
                            buff[i++] = (char)c;
                        } else {
                            buff[i++] = '.';
                        }
                    }
                    buff[i] = 0;
                    utstring_printf(buffer, "%#04x('%s')", result->as_pointer.ptr, buff);
                    return buffer;
                }
                default: {
                    utstring_printf(buffer, "%#04x", result->as_pointer.ptr);
                    return buffer;
                }
            }
        }
        default: {
            utstring_printf(buffer, "<unknown:%d>", result->type.first->type_);
            return buffer;
        }
    }
    return buffer;
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
                    to->as_float = (float)(int32_t)from->as_int;
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

void exp_engine_init()
{
    {
        struct history_expression_t* he = calloc(1, sizeof(struct history_expression_t));
        strcpy(he->name, "$fp");

        he->result.type.first = malloc_type(TYPE_INT);
        he->result.as_int = 0;

        HASH_ADD_STR(history_expressions, name, he);
    }

}
