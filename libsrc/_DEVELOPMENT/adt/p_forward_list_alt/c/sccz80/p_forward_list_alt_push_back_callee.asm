
; void p_forward_list_alt_push_back(p_forward_list_alt_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_push_back_callee

EXTERN asm_p_forward_list_alt_push_back

p_forward_list_alt_push_back_callee:

   pop af
   pop de
   pop bc
   push af
   
   jp asm_p_forward_list_alt_push_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_alt_push_back_callee
defc _p_forward_list_alt_push_back_callee = p_forward_list_alt_push_back_callee
ENDIF

