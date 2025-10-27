
; void p_forward_list_alt_init(void *p)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_init

EXTERN asm_p_forward_list_alt_init

defc p_forward_list_alt_init = asm_p_forward_list_alt_init

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_alt_init
defc _p_forward_list_alt_init = p_forward_list_alt_init
ENDIF

