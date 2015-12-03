
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int p_stack_empty(p_stack_t *s)
;
; Return true (non-zero) if stack is empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC asm_p_stack_empty

EXTERN l_testword_hl

defc asm_p_stack_empty = l_testword_hl

   ; enter : hl = p_stack_t *
   ;
   ; exit  : if stack is empty
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if stack is not empty
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl
