
; void *p_forward_list_alt_pop_front(p_forward_list_alt_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_pop_front

EXTERN asm_p_forward_list_alt_pop_front

defc p_forward_list_alt_pop_front = asm_p_forward_list_alt_pop_front

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_alt_pop_front
defc _p_forward_list_alt_pop_front = p_forward_list_alt_pop_front
ENDIF

