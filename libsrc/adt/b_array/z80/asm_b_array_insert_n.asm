
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_insert_n(b_array_t *a, size_t idx, size_t n, int c)
;
; Insert n bytes before array.data[idx], fill that area with
; char c and return the index of the first char inserted.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_insert_n

EXTERN asm_b_array_insert_block, asm_memset, error_mc

asm_b_array_insert_n:

   ; enter : hl = array *
   ;         de = n
   ;         bc = idx
   ;          a = char c
   ;
   ; exit  : success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx of first char inserted
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   push bc                     ; save idx
   push af                     ; save char
   push de                     ; save n
   
   call asm_b_array_insert_block

   pop bc                      ; bc = n
   pop de                      ; d = char
   
   jp c, error_mc - 1
   
   ld e,d                      ; e = char
   call asm_memset             ; fill inserted block
   
   pop de                      ; de = idx
   ex de,hl

   ret
