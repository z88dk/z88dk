
; void *p_list_prev(void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_prev

EXTERN asm_p_list_prev

defc p_list_prev = asm_p_list_prev

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_list_prev
defc _p_list_prev = p_list_prev
ENDIF

