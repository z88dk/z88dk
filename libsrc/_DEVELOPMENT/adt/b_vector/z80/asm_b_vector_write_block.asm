
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_vector_write_block(void *src, size_t n, b_vector_t *v, size_t idx)
;
; Write at most n bytes from the src to the vector at index idx.
; Returns number of bytes actually written, which may be less
; than n if the vector could not accommodate all bytes.
;
; ===============================================================

XLIB asm_b_vector_write_block
XDEF asm_b_vector_write_block_extra

LIB __vector_make_room_extra, l_inc_sp
LIB asm1_b_array_write_block, asm2_b_array_write_block

asm_b_vector_write_block:

   exx
   ld de,0
   exx

asm_b_vector_write_block_extra:

   ; enter : hl'= void *src
   ;         de'= extra
   ;         bc = idx
   ;         de = n
   ;         hl = vector *
   ;
   ; exit  : success
   ;
   ;            hl = num_bytes written
   ;            de = & vector.data[idx]
   ;            hl'= src + num_bytes
   ;            de'= & vector.data[idx + num_bytes]
   ;             a = realloc_status
   ;               = 0 if realloc was performed
   ;               =-1 if not all n bytes could be written
   ;               > 0 otherwise
   ;
   ;         fail if idx >= vector.capacity and vector could not grow
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ex de,hl                    ; hl = n
   
   inc de
   inc de                      ; de = & vector.size
   
   push de                     ; save & vector.size
   push bc                     ; save idx
   
   call __vector_make_room_extra
   jr c, room_unavailable      ; if room for the write is not available

room_available:

   ; hl = & vector.data[idx]
   ; bc = n
   ; hl'= void *src
   ; a = 0 if realloc performed
   ; stack = two items

   push af                     ; save realloc_status
   
   call asm1_b_array_write_block
   
   pop af                      ; a = realloc_status
   jp l_inc_sp - 4             ; remove two items on stack

room_unavailable:

   ; hl'= void *src
   ; stack = & vector.size, idx

   pop bc                      ; bc = idx
   pop hl                      ; hl = & vector.size
   
   jp asm2_b_array_write_block
