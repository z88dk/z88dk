
; size_t p_list_size(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_size

EXTERN asm_p_list_size

defc p_list_size = asm_p_list_size

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_list_size
defc _p_list_size = p_list_size
ENDIF

