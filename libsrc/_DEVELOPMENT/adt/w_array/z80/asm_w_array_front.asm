
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *w_array_front(w_array_t *a)
;
; Return word stored at front of array.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_front

EXTERN __array_info, error_mc

asm_w_array_front:

   ; enter : hl = array *
   ;
   ; exit  : de = array.data
   ;         bc = array.size in bytes
   ;
   ;         success
   ;
   ;            hl = word at front of array
   ;            carry reset
   ;
   ;         fail if array is empty
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   call __array_info
   jp z, error_mc              ; if array is empty
   
   ; de = array.data
   ; bc = array.size in bytes

   ld a,(de)
   ld l,a
   inc de
   ld a,(de)
   ld h,a
   dec de
   
   ret
