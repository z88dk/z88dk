
; ===============================================================
; Mar 2014
; ===============================================================
; 
; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)
;
; Initialize a byte array stack structure at address p and set the
; stack's initial data and capacity members.  stack.size = 0
;
; ===============================================================

SECTION code_clib
SECTION code_adt_ba_stack

PUBLIC asm_ba_stack_init

EXTERN asm_b_array_init

defc asm_ba_stack_init = asm_b_array_init

   ; enter : hl = p
   ;         de = data
   ;         bc = capacity
   ;
   ; exit  : hl = stack * = p
   ;
   ; uses  : af
