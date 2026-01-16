
; void *p_forward_list_alt_pop_back(p_forward_list_alt_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_pop_back

EXTERN asm_p_forward_list_alt_pop_back

defc p_forward_list_alt_pop_back = asm_p_forward_list_alt_pop_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_alt_pop_back
defc _p_forward_list_alt_pop_back = p_forward_list_alt_pop_back
ENDIF

