
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int wv_stack_push(wv_stack_t *s, void *item)
;
; Push item onto stack.
;
; ===============================================================

XLIB asm_wv_stack_push

LIB asm_w_vector_append

defc asm_wv_stack_push = asm_w_vector_append

   ; enter : hl = stack *
   ;         bc = item
   ;
   ; exit  : bc = item
   ;
   ;         success
   ;
   ;            de = & stack.data[idx]
   ;            hl = idx of appended char
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, de, hl
