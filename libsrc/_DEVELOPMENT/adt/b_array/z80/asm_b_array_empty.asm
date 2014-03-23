
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_array_empty(b_array_t *a)
;
; Return non-zero if the array is empty.
;
; ===============================================================

XLIB asm_b_array_empty

LIB l_testword_hl

asm_b_array_empty:

   jp l_testword_hl - 2

;defc asm_b_array_empty = l_testword_hl - 2

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
