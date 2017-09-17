
; void *p_forward_list_alt_remove_after(p_forward_list_alt_t *list, void *list_item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_remove_after_callee

EXTERN asm_p_forward_list_alt_remove_after

p_forward_list_alt_remove_after_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_p_forward_list_alt_remove_after

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_alt_remove_after_callee
defc _p_forward_list_alt_remove_after_callee = p_forward_list_alt_remove_after_callee
ENDIF

