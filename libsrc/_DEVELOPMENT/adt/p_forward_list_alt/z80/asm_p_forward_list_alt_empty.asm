
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int p_forward_list_alt_empty(p_forward_list_alt_t *list)
;
; Return true (non-zero) if list is empty.
;
; ===============================================================

XLIB asm_p_forward_list_alt_empty

LIB l_testword_hl

asm_p_forward_list_alt_empty:

   jp l_testword_hl

;defc asm_p_forward_list_alt_empty = l_testword_hl

   ; enter : hl = p_forward_list_alt_t *
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
