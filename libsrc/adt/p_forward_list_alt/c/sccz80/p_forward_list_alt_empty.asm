
; int p_forward_list_alt_empty(p_forward_list_alt_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_empty

EXTERN asm_p_forward_list_alt_empty

defc p_forward_list_alt_empty = asm_p_forward_list_alt_empty

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_alt_empty
defc _p_forward_list_alt_empty = p_forward_list_alt_empty
ENDIF

