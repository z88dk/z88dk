
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int p_list_empty(p_list_t *list)
;
; Return true (non-zero) if list is empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_list

PUBLIC asm_p_list_empty

EXTERN l_testword_hl

defc asm_p_list_empty = l_testword_hl

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
