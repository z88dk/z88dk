
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_W_ARRAY_APPEND

; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_push_back(w_array_t *a, void *item)
;
; Append item to end of array, return index of appended word.
;
; ===============================================================

asm_w_array_push_back:

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
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, de, hl
