
; void *p_list_remove(p_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_remove_callee

EXTERN asm_p_list_remove

p_list_remove_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_p_list_remove

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_list_remove_callee
defc _p_list_remove_callee = p_list_remove_callee
ENDIF

