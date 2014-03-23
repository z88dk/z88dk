
; ===============================================================
; Mar 2014
; ===============================================================
; 
; wa_stack_t *wa_stack_init(void *p, void *data, size_t capacity)
;
; Initialize a word array stack structure at address p and set the
; stack's initial data and capacity members.  stack.size = 0
;
; ===============================================================

XLIB asm_wa_stack_init

LIB asm_w_array_init

asm_wa_stack_init:

   jp asm_w_array_init

;defc asm_wa_stack_init = asm_w_array_init

   ; enter : hl = p
   ;         de = data
   ;         bc = capacity in words
   ;
   ; exit  : success
   ;
   ;            hl = stack *
   ;            carry reset
   ;
   ;         fail if capacity too large
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc
