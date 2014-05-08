
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int p_list_empty(p_list_t *list)
;
; Return true (non-zero) if list is empty.
;
; ===============================================================

PUBLIC asm_p_list_empty

EXTERN l_testword_hl

asm_p_list_empty:

   jp l_testword_hl

;defc asm_p_list_empty = l_testword_hl

   ; enter : hl = p_list_t *
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
