
; void p_list_clear(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_clear

EXTERN asm_p_list_clear

defc p_list_clear = asm_p_list_clear

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_list_clear
defc _p_list_clear = p_list_clear
ENDIF

