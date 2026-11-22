
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_append_n(b_array_t *a, size_t n, int c)
;
; Append n copies of char c to the end of the array, return
; index of new block.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_append_n

EXTERN asm_b_array_append_block, asm_memset, error_mc

asm_b_array_append_n:

   ; enter : hl = array *
   ;         de = n
   ;         bc = int c
   ;
   ; exit  : success
   ;
   ;            hl = idx of bytes appended
   ;            de = & array.data[idx]
   ;            carry reset
   ;
   ;         fail if array too small
   ;
   ;            hl = -1
   ;            de = n
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   push bc                     ; save char
   
   call asm_b_array_append_block
   jp c, error_mc - 1

   ; append successful, now fill appended area
   
   ; bc = n
   ; de = idx = old array.size
   ; hl = & array.data[idx]
   ; stack = char

   ex de,hl
   ex (sp),hl
   ex de,hl
   
   ; bc = n
   ; de = int c
   ; hl = & array.data[idx]
   ; stack = idx
   
   call asm_memset
   
   pop de
   ex de,hl
   
   ret
