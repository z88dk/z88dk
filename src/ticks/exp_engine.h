#ifndef EXPRESSION_H
#define EXPRESSION_H

#include <inttypes.h>
#include "debug.h"

enum expression_flags_t {
    EXPRESSION_TYPE_SIGNED = 0x01u,
    EXPRESSION_ERROR = 0x02u,
    EXPRESSION_UNKNOWN = 0x04u,
};

struct expression_result_t {
    union {
        int32_t as_int;
        uint32_t as_uint;
        float as_float;
        struct {
            uint16_t element_size;
            uint16_t ptr;
        } as_pointer;
    };

    char as_error[128];

    uint16_t memory_location;
    uint16_t memory_size;

    type_chain type;
    uint8_t flags;
};

extern void evaluate_expression_string(const char* expr);
extern uint8_t is_expression_result_error(struct expression_result_t* result);
extern void set_expression_result_error(struct expression_result_t* result, const char* error);

extern void expression_result_free_typechain(struct expression_result_t* result);
extern void convert_expression(struct expression_result_t* from, struct expression_result_t* to, enum type_record_type type, uint8_t is_signed);
extern void expression_result_type_to_string(type_chain* type, uint8_t is_signed, char* buffer);
extern void expression_dereference_pointer(struct expression_result_t *from, struct expression_result_t *to);
extern void expression_value_to_pointer(struct expression_result_t *from, struct expression_result_t *to, type_chain* pointer_type, uint8_t is_signed);
extern void expression_math_add(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result);
extern void expression_math_sub(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result);
extern void expression_math_mul(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result);
extern void expression_math_div(struct expression_result_t* a, struct expression_result_t* b, struct expression_result_t* result);
extern type_chain expression_string_get_type(const char* str, uint8_t* is_signed);
extern uint8_t is_primitive_integer_type(struct expression_result_t* exp);
extern int expression_result_value_to_string(struct expression_result_t* result, char* buffer, int buffer_len);
extern void reset_expression_result(struct expression_result_t* result);
extern struct expression_result_t* get_expression_result();
extern uint8_t is_expression_signed(struct expression_result_t *exp);
extern void set_expression_signed(struct expression_result_t *exp, uint8_t is_signed);

    struct lookup_t {
    const char* symbol_name;
};

extern void debug_lookup_symbol(struct lookup_t* lookup, struct expression_result_t* result);


#endif