
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_push_back(b_array_t *a, int c)
;
; Append char to end of array, return index of appended char.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_push_back

EXTERN asm_b_array_append

defc asm_b_array_push_back = asm_b_array_append

   ; enter : hl = array *
   ;         bc = int c
   ;
   ; exit  : bc = int c
   ;
   ;         success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx of appended char
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl
