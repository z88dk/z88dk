
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_push_back(w_array_t *a, void *item)
;
; Append item to end of array, return index of appended word.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_push_back

EXTERN asm_w_array_append

defc asm_w_array_push_back = asm_w_array_append

   ; enter : hl = array *
   ;         bc = item
   ;
   ; exit  : bc = item
   ;
   ;         success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx of appended word
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl
