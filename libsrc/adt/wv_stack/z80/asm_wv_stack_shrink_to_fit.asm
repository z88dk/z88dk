
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int wv_stack_shrink_to_fit(wv_stack_t *s)
;
; Release any excess memory allocated for the stack.
;
; After calling, stack.capacity == stack.size
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC asm_wv_stack_shrink_to_fit

EXTERN asm_b_vector_shrink_to_fit

defc asm_wv_stack_shrink_to_fit = asm_b_vector_shrink_to_fit

   ; enter : hl = stack *
   ;
   ; exit  : success
   ;
   ;            hl = -1
   ;            carry reset
   ;
   ;         fail on realloc not getting lock
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl
