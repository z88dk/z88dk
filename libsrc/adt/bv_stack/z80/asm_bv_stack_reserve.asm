
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int bv_stack_reserve(bv_stack_t *s, size_t n)
;
; Allocate at least n bytes for the stack.
;
; If the stack is already larger, do nothing.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_bv_stack

PUBLIC asm_bv_stack_reserve

EXTERN asm_b_vector_reserve

defc asm_bv_stack_reserve = asm_b_vector_reserve

   ; enter : hl = stack *
   ;         bc = n
   ;
   ; exit  : bc = n
   ;         de = & stack.capacity + 1b
   ;
   ;         success
   ;
   ;            hl = -1
   ;            carry reset
   ;
   ;         fail if max_size exceeded
   ;
   ;            hl = 0
   ;            carry set
   ;
   ;         fail if realloc failed
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, de, hl
