
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_array_at(b_array_t *a, size_t idx)
;
; Return char stored in array at index idx.
; If idx is outside the array's range, return -1.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_at

EXTERN __array_at, error_mc

asm_b_array_at:

   ; enter : hl = array *
   ;         bc = idx
   ;
   ; exit  : bc = idx
   ;
   ;         success
   ;
   ;            de = & array.data[idx]
   ;            hl = array.data[idx]
   ;            carry reset
   ;
   ;         fail if idx out of range
   ;
   ;            de = array.size
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl
   
   call __array_at
   jp c, error_mc

   ld e,(hl)
   ld d,0                      ; de = array.data[idx]
   
   ex de,hl
   ret
