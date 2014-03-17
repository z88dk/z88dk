
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int bv_stack_shrink_to_fit(bv_stack_t *s)
;
; Release any excess memory allocated for the stack.
;
; After calling, stack.capacity == stack.size
;
; ===============================================================

XLIB asm_bv_stack_shrink_to_fit

LIB asm_b_vector_shrink_to_fit

defc asm_bv_stack_shrink_to_fit = asm_b_vector_shrink_to_fit

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
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
