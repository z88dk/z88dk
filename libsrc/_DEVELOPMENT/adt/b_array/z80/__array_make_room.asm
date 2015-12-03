SECTION code_clib
SECTION code_adt_b_array

PUBLIC __array_make_room
PUBLIC __0_array_make_room

EXTERN __array_expand, asm_memset

__array_make_room:

   ; Make room for n bytes at index idx (overwrite not insert)
   ; If idx > array.size, zero the resulting hole.
   ;
   ; enter : de = & array.size
   ;         hl = n
   ;         bc = idx
   ;
   ; exit  : success
   ;
   ;            hl = & array.data[idx]
   ;            bc = n
   ;             a = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            de = & array.size
   ;            hl = n
   ;            bc = idx
   ;             a = 0 if idx + n > 64k
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   push hl                     ; save n
   push bc                     ; save idx
   
   add hl,bc                   ; hl = new_size = idx + n
   jr c, error_64k             ; if new_size > 64k
   
   ex de,hl
   call __array_expand
   
   jr c, error_small           ; if array too small

__0_array_make_room:

   ; array is adequately sized, check for hole
   
   ; hl = & array.size + 1b
   ; bc = old_size = old array.size
   ; stack = n, idx
   
   dec hl
   dec hl
   
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = array.data
   
   pop hl
   
   ; de = array.data
   ; hl = idx
   ; bc = old_size
   ; stack = n
      
   scf
   sbc hl,bc                   ; hl = idx - old_size - 1
   jr nc, hole_present         ; if idx > old_size

hole_absent:

;;;   add hl,bc
;;;   inc hl

   adc hl,bc

   ; de = array.data
   ; hl = idx
   ; stack = n
   
   add hl,de                   ; hl = & array.data[idx]
   pop bc
   
   xor a
   ret

hole_present:

   inc hl
   
   ; hl = hole_size = idx - old_size
   ; de = array.data
   ; bc = old_size
   ; stack = n

   ex de,hl                    ; hl = array.data
   add hl,bc                   ; hl = & array.data[old_size]
   
   ld c,e
   ld b,d                      ; bc = hole_size

   ld e,0
   call asm_memset             ; zero the hole
   
   ex de,hl
   
   ; hl = & array.data[idx]
   ; stack = n

   pop bc
   
   xor a
   ret

error_small:

   ; hl = & array.size + 1b
   ; carry set
   ; stack = n, idx

   dec hl
   ex de,hl                    ; de = & array.size

   pop bc
   pop hl
   
   ld a,1
   ret

error_64k:

   ; de = & array.size
   ; carry set
   ; stack = n, idx

   pop bc                      ; bc = idx
   pop hl                      ; hl = n
   
   ld a,0
   ret                         ; carry set
