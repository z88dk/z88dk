
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_write_block(void *src, size_t n, b_array_t *a, size_t idx)
;
; Write at most n bytes from the src to the array at index idx.
; Returns number of bytes actually written, which may be less
; than n if the array could not accommodate all bytes.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_write_block
PUBLIC asm1_b_array_write_block

EXTERN __array_make_room_best_effort, error_zc

asm_b_array_write_block:

   ; enter : hl'= void *src
   ;         bc = idx
   ;         de = n
   ;         hl = array *
   ;
   ; exit  : success
   ;
   ;            hl = num_bytes written
   ;            de = & array.data[idx]
   ;            hl'= src + num_bytes
   ;            de'= & array.data[idx + num_bytes]
   ;             a =  0 if all n bytes were written (hl == n)
   ;                 -1 if not all n bytes were written (hl < n)
   ;
   ;         fail if idx > array.capacity
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ex de,hl                   ; hl = n
   
   inc de
   inc de                     ; de = & array.size

   call __array_make_room_best_effort
   jp c, error_zc

room_available:
asm1_b_array_write_block:

   ; hl = & array.data[idx]
   ; bc = n_max
   ; hl'= void *src
   ;  a = 0 if room for all bytes, -1 otherwise

   push af                     ; save flag

   push hl
   push bc
   
   exx
   
   pop bc                      ; bc = n
   pop de                      ; de = & array.data[idx]
   
   ld a,b
   or c
   jr z, degenerate_case

   ldir

degenerate_case:

   exx
   
   ; hl = & array.data[idx]
   ; bc = n
   ; hl'= void *src + n
   ; de'= & array.data[idx + n]
   
   ex de,hl                    ; de = & array.data[idx]
   
   ld l,c
   ld h,b                      ; hl = n
   
   pop af                      ; a = 0 indicates all bytes written
   ret
