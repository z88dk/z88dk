
; void p_forward_list_init(void *p)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_init

EXTERN asm_p_forward_list_init

defc p_forward_list_init = asm_p_forward_list_init

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_init
defc _p_forward_list_init = p_forward_list_init
ENDIF

