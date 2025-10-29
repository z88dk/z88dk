
; void *p_forward_list_remove_after(void *list_item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_remove_after

EXTERN asm_p_forward_list_remove_after

defc p_forward_list_remove_after = asm_p_forward_list_remove_after

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_remove_after
defc _p_forward_list_remove_after = p_forward_list_remove_after
ENDIF

