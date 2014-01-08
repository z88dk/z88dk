
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int forward_list_empty(forward_list *list)
;
; Return true (non-zero) if list is empty.
;
; ===============================================================

XLIB asm_forward_list_empty
XDEF asm_forward_list_alt_empty, asm_list_empty

asm_forward_list_empty:
asm_forward_list_alt_empty:
asm_list_empty:

   ; enter : hl = forward_list *
   ;
   ; exit  : if list is empty
   ;
   ;           hl = 1
   ;           carry set
   ;
   ;         if list is not empty
   ;
   ;           hl = 0
   ;           carry reset
   ;
   ; uses  : af, hl
   
   ld a,(hl)
   inc hl
   or (hl)
   
   ld hl,0
   ret nz
   
   inc l

   scf
   ret
