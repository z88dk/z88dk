
; ===============================================================
; Feb 2014
; ===============================================================
; 
; void *p_stack_top(p_stack_t *s)
;
; Return item at top of stack without removing it.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC asm_p_stack_top

EXTERN asm_p_forward_list_front

defc asm_p_stack_top = asm_p_forward_list_front

   ; enter : hl = stack *
   ;
   ; exit  : success
   ;
   ;            hl = void *item (item at top)
   ;            nz flag set
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            z flag set
   ;
   ; uses  : af, hl
