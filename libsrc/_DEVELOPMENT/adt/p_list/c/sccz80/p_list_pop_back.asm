
; void *p_list_pop_back(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_pop_back

EXTERN asm_p_list_pop_back

defc p_list_pop_back = asm_p_list_pop_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_list_pop_back
defc _p_list_pop_back = p_list_pop_back
ENDIF

