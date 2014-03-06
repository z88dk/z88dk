
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int p_forward_list_empty(p_forward_list_t *list)
;
; Return true (non-zero) if list is empty.
;
; ===============================================================

XLIB asm_p_forward_list_empty
XDEF asm_p_forward_list_alt_empty, asm_p_list_empty
XDEF asm_p_stack_empty, asm_p_queue_empty, asm_b_vector_empty

asm_p_forward_list_empty:
asm_p_forward_list_alt_empty:
asm_p_list_empty:
asm_p_stack_empty:
asm_p_queue_empty:

   ; enter : hl = p_forward_list_t *
   ;
   ; exit  : if list is empty
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if list is not empty
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl
   
   ld a,(hl)
   inc hl
   or (hl)

   ld hl,0
   ret nz
   
   inc l
   ret
