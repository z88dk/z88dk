
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_ARRAY_APPEND

; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_push_back(b_array_t *a, int c)
;
; Append char to end of array, return index of appended char.
;
; ===============================================================

asm_b_array_push_back:

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
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, de, hl
