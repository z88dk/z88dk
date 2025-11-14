
; size_t p_forward_list_alt_size(p_forward_list_alt_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_size

EXTERN asm_p_forward_list_alt_size

defc p_forward_list_alt_size = asm_p_forward_list_alt_size

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_alt_size
defc _p_forward_list_alt_size = p_forward_list_alt_size
ENDIF

