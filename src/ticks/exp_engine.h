#ifndef EXPRESSION_H
#define EXPRESSION_H

#include <inttypes.h>
#include <utstring.h>
#include "debug.h"

enum expression_flags_t {
    EXPRESSION_ERROR = 0x01u,
    EXPRESSION_UNKNOWN = 0x02u,
};

struct expression_result_t {
    union {
        int32_t as_int;
        uint32_t as_uint;
        float as_float;
        struct {
            uint16_t ptr;
        } as_pointer;
    };

    char as_error[128];

    uint16_t memory_location;
    type_record type;
    uint8_t flags;
};

struct history_expression_t {
    char                        name[128];
    struct expression_result_t  result;
    UT_hash_handle              hh;
};

extern struct history_expression_t* history_expressions;

extern void exp_engine_init();
extern void evaluate_expression_string(const char* expr);
extern uint8_t is_expression_result_error(struct expression_result_t* result);
extern void set_expression_result_error(struct expression_result_t* result);
extern void set_expression_result_error_str(struct expression_result_t* result, const char* error);

extern void expression_result_free(struct expression_result_t* result);
extern void convert_expression(struct expression_result_t* from, struct expression_result_t* to, type_record* type);
extern UT_string* expression_result_type_to_string(type_record* root, type_chain* type);
extern void expression_dereference_pointer(struct expression_result_t *from, struct expression_result_t *to);
extern void expression_primitive_func_call_1(const char* call, struct expression_result_t *a, struct expression_result_t *to);
extern void expression_resolve_struct_member(struct expression_result_t *struct_, const char *member, struct expression_result_t* result);
extern void expression_resolve_struct_member_ptr(struct expression_result_t *struct_ptr, const char *member, struct expression_result_t* result);
extern void expression_value_to_pointer(struct expression_result_t *from, struct expression_result_t *to, type_record* pointer_type);
extern void expression_math_add(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result);
extern void expression_math_sub(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result);
extern void expression_math_mul(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result);
extern void expression_math_div(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result);
extern void expression_string_get_type(const char* str, type_record* type);
extern void expression_get_struct_members(struct expression_result_t* result, int* count, char** members);
extern int expression_count_members(struct expression_result_t* result);
extern UT_string* expression_result_value_to_string(struct expression_result_t* result);
extern void zero_expression_result(struct expression_result_t* result);
extern struct expression_result_t* get_expression_result();

struct lookup_t {
    const char* symbol_name;
};

extern void debug_lookup_symbol(struct lookup_t* lookup, struct expression_result_t* result);
extern void debug_lookup_history(const char* history, struct expression_result_t* result);


#endif