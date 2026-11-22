
; ===============================================================
; Dec 2013
; ===============================================================
; 
; size_t p_stack_size(p_stack_t *s)
;
; Return number of items in stack.  O(n).
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC asm_p_stack_size

EXTERN asm_p_forward_list_size

defc asm_p_stack_size = asm_p_forward_list_size

   ; enter : hl = p_stack_t *s
   ;
   ; exit  : hl = number of items in list
   ;
   ; uses  : af, de, hl
