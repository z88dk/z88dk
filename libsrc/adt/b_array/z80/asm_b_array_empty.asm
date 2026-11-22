
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_array_empty(b_array_t *a)
;
; Return non-zero if the array is empty.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_empty

EXTERN l_testword_hl

defc asm_b_array_empty = l_testword_hl - 2

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
