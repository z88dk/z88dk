
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_stack_init(void *p)
;
; Create an empty stack in the two bytes of memory provided.
;
; ===============================================================

PUBLIC asm_p_stack_init

EXTERN asm_p_forward_list_init

asm_p_stack_init:

   jp asm_p_forward_list_init

;defc asm_p_stack_init = asm_p_forward_list_init

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 2
   ;         de = void *p = p_stack_t *list
   ;
   ; uses  : af, de, hl
