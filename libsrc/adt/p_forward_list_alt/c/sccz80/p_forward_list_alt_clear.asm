
; void p_forward_list_alt_clear(p_forward_list_alt_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_clear

EXTERN asm_p_forward_list_alt_clear

defc p_forward_list_alt_clear = asm_p_forward_list_alt_clear

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_alt_clear
defc _p_forward_list_alt_clear = p_forward_list_alt_clear
ENDIF

