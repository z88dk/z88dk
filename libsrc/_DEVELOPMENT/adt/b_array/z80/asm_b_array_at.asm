
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

XLIB asm_b_array_at

LIB __array_at, error_einval_mc

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
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, de, hl
   
   call __array_at
   jp c, error_einval_mc

   ld e,(hl)
   ld d,0                      ; de = array.data[idx]
   
   ex de,hl
   ret
