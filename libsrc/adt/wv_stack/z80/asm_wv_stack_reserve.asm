
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int wv_stack_reserve(wv_stack_t *s, size_t n)
;
; Allocate at least n words for the stack.
;
; If the stack is already larger, do nothing.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_wv_stack

PUBLIC asm_wv_stack_reserve

EXTERN asm_w_vector_reserve

defc asm_wv_stack_reserve = asm_w_vector_reserve

   ; enter : hl = stack *
   ;         bc = n words
   ;
   ; exit  : bc = n * 2 bytes
   ;         de = & stack.capacity + 1b
   ;
   ;         success
   ;
   ;            hl = 0
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
   ; uses  : af, bc, de, hl
