
XLIB __vector_make_room
XDEF __vector_make_room_extra

LIB __vector_resize_extra, l_neg_bc, asm_memset
LIB error_einval_zc, error_enomem_zc

__vector_make_room:

   exx
   ld de,0
   exx

__vector_make_room_extra:

   ; Make room for n bytes at index idx.
   ; If idx > vector.size, zero the resulting hole.
   ;
   ; enter : de = n
   ;         bc = idx
   ;         hl = vector *
   ;         de'= extra
   ;
   ; exit  : de'= extra
   ;
   ;         success
   ;
   ;            bc = num bytes available at idx
   ;            hl = & vector.array[idx]
   ;             a = realloc_status
   ;               = 0 if realloc was performed
   ;               =-1 if num bytes available is < n
   ;               > 0 otherwise
   ;            carry reset
   ;
   ;         fail if idx + n > 64k
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ;         fail if idx >= vector.capacity and vector could not grow
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save n
   push bc                     ; save idx
   
   ex de,hl                    ; hl = n
   
   add hl,bc                   ; hl = new_size = idx + n
   jp c, error_einval_zc - 2   ; if new_size > 64k
   
   ld c,l
   ld b,h                      ; bc = new_size
   
   ex de,hl                    ; hl = vector *
   
   inc hl
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = old_size = vector.size
   
   push de                     ; save old_size
   
   ; bc = new_size
   ; hl = & vector.size + 1b
   ; de'= extra
   ; stack = n, idx, old_size
   
   exx
   push de
   exx
   pop de                      ; de = extra
   
   call __vector_resize_extra  ; make room
   jr c, resize_failed         ; if resize failed

   inc l
   inc l
   
   ld a,l

rejoin:

   ; de = & vector.size + 1b
   ;  a = realloc_status = 0 if realloc performed
   ; stack = n, idx, old_size

   ex de,hl                    ; hl = & vector.size + 1b
   
   dec hl
   dec hl
   
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = vector.array
   
   pop hl                      ; hl = old_size
   pop bc                      ; bc = idx
   push af                     ; save realloc_status
   
   ; de = vector.array
   ; hl = old_size
   ; bc = idx
   ; stack = n, realloc_status
   
   sbc hl,bc                   ; hl = old_size - idx
   jr c, hole_present          ; if old_size < idx there is a hole

hole_absent:

   ; de = vector.array
   ; bc = idx
   ; stack = n, realloc_status

   ex de,hl
   add hl,bc

return_params:

   ; hl = & vector.array[idx]
   ; stack = n, realloc_status
   
   pop af                      ; a = realloc_status, carry reset
   pop bc                      ; bc = n
   
   ret

hole_present:

   ; initial idx is past end of the original vector
   ; this creates a hole that needs to be zeroed

   ; de = vector.array
   ; hl = old_size - idx
   ; bc = idx
   ; stack = n, realloc_status
   
   push hl                     ; save old_size - idx
   
   add hl,bc                   ; hl = old_size
   add hl,de                   ; hl = & vector.array[old_size]
   
   pop bc
   call l_neg_bc               ; bc = hole_size = idx - old_size
   
   ; hl = & vector.array[old_size]
   ; bc = hole_size = idx - old_size
   ; stack = n, realloc_status
   
   ld e,0
   call asm_memset
   
   ex de,hl
   
   ; hl = & vector.array[idx]
   ; stack = n, realloc_status
   
   jr return_params

resize_failed:

   ; vector is unable to grow so return the maximum num bytes at idx

   ; de = & vector.size + 1b
   ; stack = n, idx, old_size

   ; need to replace n in the stack with (vector.capacity - idx)
   
   pop af
   pop bc                      ; bc = idx
   push bc
   push af
   
   ex de,hl                    ; hl = & vector.size + 1b
   
   inc hl
   inc hl
   
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = vector.capacity
   dec hl

   ex de,hl
   
   ; de = & vector.size + 1b
   ; hl = vector.capacity
   ; bc = idx
   ; stack = n, idx, old_size
   
   or a
   sbc hl,bc                   ; hl = vector.capacity - idx
   
   jp c, error_enomem_zc - 3   ; if vector.capacity < idx
   jp z, error_enomem_zc - 3   ; if vector.capacity == idx
   
   ; de = & vector.size + 1b
   ; hl = new_n
   ; stack = n, idx, old_size
   
   ld c,l
   ld b,h                      ; bc = new_n
   
   ld hl,4
   add hl,sp
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; replace n with new_n
   
   ; de = & vector.size + 1b
   ; stack = new_n, idx, old_size
   
   ld a,-1
   jr rejoin
