
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

LIB error_zc, error_mnc

asm_forward_list_empty:
asm_forward_list_alt_empty:
asm_list_empty:

   ; enter : hl = forward_list *
   ;
   ; exit  : if list is empty
   ;
   ;           hl = -1
   ;           carry reset
   ;
   ;         if list is not empty
   ;
   ;           hl = 0
   ;           carry set
   ;
   ; uses  : af, hl
   
   ld a,(hl)
   inc hl
   or (hl)
   
   jp nz, error_zc             ; if list is not empty
   jp error_mnc
