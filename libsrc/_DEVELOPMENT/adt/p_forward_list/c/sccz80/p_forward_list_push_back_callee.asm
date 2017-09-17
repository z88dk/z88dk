
; void p_forward_list_push_back(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_push_back_callee

EXTERN asm_p_forward_list_push_back

p_forward_list_push_back_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_p_forward_list_push_back

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_push_back_callee
defc _p_forward_list_push_back_callee = p_forward_list_push_back_callee
ENDIF

