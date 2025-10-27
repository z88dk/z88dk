
; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *w_array_at(w_array_t *a, size_t idx)
;
; Return word stored in array at index idx.
; If idx is outside the array's range, return -1.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_at

EXTERN __array_at, error_mc

asm_w_array_at:

   ; enter : hl = array *
   ;         bc = idx
   ;
   ; exit  : bc = idx
   ;         de = array.size
   ;
   ;         success
   ;
   ;            de = & array.data[idx]
   ;            hl = array.data[idx]
   ;            carry reset
   ;
   ;         fail if idx out of range
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl

   sla c
   rl b
   jp c, error_mc

   call __array_at
   jp c, error_mc

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = array.data[idx]
   dec hl
   
   ex de,hl
   ret
