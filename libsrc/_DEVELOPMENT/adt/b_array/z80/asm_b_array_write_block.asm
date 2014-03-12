
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

XLIB asm_b_array_write_block
XDEF asm1_b_array_write_block, asm2_b_array_write_block

LIB __array_make_room, error_enomem_zc

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
   ;         fail if idx >= array.capacity
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   ex de,hl                   ; hl = n
   
   inc de
   inc de                     ; de = & array.size

   call __array_make_room
   jr c, room_unavailable     ; if room for the write is not available

room_available:
asm1_b_array_write_block:

   ; hl = & array.data[idx]
   ; bc = n
   ; hl'= void *src

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
   
   xor a                       ; a = 0 indicates all bytes written
   ret

room_unavailable:

   ; write as many bytes as possible
   
   ex de,hl

asm2_b_array_write_block:

   ; hl = & array.size
   ; bc = idx
   ; hl' = void *src

   dec hl
   dec hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = array.data
   
   ex de,hl
   add hl,bc
   ex de,hl                    ; de = & array.data[idx]
   
   ; hl = & array.data + 1b
   ; de = & array.data[idx]
   ; bc = idx
   ; hl'= void *src

   push de                     ; save & array.data[idx]
   
   inc hl
   inc hl
   inc hl                      ; hl = & array.capacity
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = array.capacity

   ex de,hl                    ; hl = array.capacity

   scf
   sbc hl,bc                   ; hl = array.capacity - idx - 1
   jp c, error_enomem_zc - 1   ; if array.capacity <= idx

   inc hl
   
   ld c,l
   ld b,h                      ; bc = avail_bytes = array.capacity - idx
   
   ; de = & array.capacity + 1b
   ; bc = avail_bytes
   ; hl'= void *src
   ; stack = & array.data[idx]

   ld l,e
   ld h,d                      ; hl = & array.capacity + 1b
   
   dec de
   dec de                      ; de = & array.size + 1b
   
   ldd
   inc bc                      ; undo bc--
   
   ld a,(hl)
   ld (de),a                   ; array.size = array.capacity
   
   pop hl

   ; hl = & array.data[idx]
   ; bc = avail_bytes = n
   ; hl'= void *src

   call room_available         ; write src bytes into array

   dec a                       ; indicate not all bytes written
   ret
