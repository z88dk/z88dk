
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int wa_stack_push(wa_stack_t *s, void *item)
;
; Push item onto stack.
;
; ===============================================================

XLIB asm_wa_stack_push

LIB asm_w_array_append

defc asm_wa_stack_push = asm_w_array_append

   ; enter : hl = stack *
   ;         bc = item
   ;
   ; exit  : bc = item
   ;
   ;         success
   ;
   ;            de = & stack.data[idx]
   ;            hl = idx of appended word
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, de, hl
