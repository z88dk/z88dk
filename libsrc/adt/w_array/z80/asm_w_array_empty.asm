
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int w_array_empty(w_array_t *a)
;
; Return non-zero if the array is empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_empty

EXTERN l_testword_hl

defc asm_w_array_empty = l_testword_hl - 2

   ; enter : hl = array *
   ;
   ; exit  : if array is empty
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if array is not empty
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl
