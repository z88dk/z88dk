
; ===============================================================
; Mar 2014
; ===============================================================
; 
; int b_array_resize(b_array_t *a, size_t n)
;
; Attempt to resize the array to n bytes.
;
; If n <= array.size, array.size = n and any elements in
; array.data at positions >= n are ignored.
;
; If n > array.size and n <= array.capacity, new elements
; are zeroed. 
;
; Carry set on failure.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_resize
PUBLIC asm0_b_array_resize

EXTERN __array_expand, asm_memset, error_zc

asm_b_array_resize:

   ; enter : hl = array *
   ;         de = n = desired size in bytes
   ;
   ; exit  : success
   ;
   ;            hl = non-zero
   ;            carry reset
   ;
   ;         fail if array is too small
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   inc hl
   inc hl                      ; hl = & array.size

   call __array_expand
   jp c, error_zc

asm0_b_array_resize:

   ; hl = & array.size + 1b
   ; de = n
   ; bc = old array.size
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; array.size = n
   
   or a
   ret z                       ; if n <= array.size
   
   ; array size expanded, must zero new bytes
   
   ; de = n
   ; hl = & array.size
   ; bc = old array.size
   
   dec hl
   ld a,(hl)
   dec hl
   ld l,(hl)
   ld h,a                      ; hl = array.data
   
   add hl,bc                   ; hl = & array.data[old_size]
   
   ex de,hl                    ; hl = n
   
   sbc hl,bc                   ; hl = num_new = n - old_size
   
   ld c,l
   ld b,h                      ; bc = num_new

   ex de,hl
      
   ; hl = & array.data[old_size]
   ; bc = num_new
   
   ld e,0
   jp asm_memset
