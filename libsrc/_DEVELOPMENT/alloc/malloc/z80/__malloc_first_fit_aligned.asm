
********* NEED TO REPAIR


XLIB __malloc_first_fit_aligned
LIB l_andc_hlbc

__malloc_first_fit_aligned:

   ; Return the first block found to have enough free
   ; bytes at an aligned address to accommodate the request
   ;
   ; enter : de = request size
   ;         hl = & first block in region
   ;         bc = alignment - 1
   ; 
   ; exit  : success
   ;
   ;           carry reset
   ;           de = p_aligned
   ;           bc = request size
   ;           hl = & block
   ;
   ;         fail, adequate block not found
   ;
   ;           carry set
   ;           de = request size
   ;           bc = alignment - 1
   ;
   ; uses  : af, bc, de, hl
   
block_loop:
   
   ; bc = alignment - 1
   ; hl = & block
   ; de = request size
   
   push hl                     ; save & block
   push de                     ; save request size
   push hl                     ; save & block
   
   ; find first aligned address in block
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->next = & block_next

   ld a,d
   or e
   jr z, fail_exit             ; if this is the region terminator

   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = block->committed

   ; bc = alignment - 1
   ; de = & block->next
   ; hl = block->committed
   ; stack = & block, request size, & block
   
   ex de,hl
   ex (sp),hl
   
   ; bc = alignment - 1
   ; hl = & block
   ; de = block->committed
   ; stack = & block, request size, & block_next
****** special case committed = 0
   add hl,de                   ; hl = p = & first available byte in block
   add hl,bc                   ; hl = p + (alignment - 1)
   jr c, not_this_block        ; if ptr wrapped

   call l_andc_hlbc            ; hl = hl & ~(bc) = p_aligned
   ex de,hl
   
   ; find free bytes from aligned address
   
   ; de = p_aligned
   ; bc = alignment - 1
   ; stack = & block, request size, & block_next

   pop hl
   pop af
   push bc
   push hl
   push af
   pop bc
   
   ; de = p_aligned
   ; bc = request size
   ; hl = & block_next
   ; stack = & block, alignment - 1, & block_next

   scf
   sbc hl,de                   ; hl = available bytes
   jr c, aligned_outside_block

   ; enough room ?
   
   sbc hl,bc                   ; can satisfy request ?
   jr nc, found_block
   
   ; better luck with next block

aligned_outside_block:

   ld e,c
   ld d,b
   
   pop hl
   pop bc
   pop af

   ; bc = alignment - 1
   ; hl = & block_next
   ; de = request size

   jp block_loop

not_this_block:

   ; bc = alignment - 1
   ; stack = & block, request size, & block_next

   pop hl
   pop de
   pop af

   ; bc = alignment - 1
   ; hl = & block_next
   ; de = request size

   jp block_loop

found_block:

   ; de = p_aligned
   ; bc = request size
   ; stack = & block, alignment - 1, & block_next

   pop hl
   pop hl
   pop hl

   ; carry reset
   ; de = p_aligned
   ; bc = request size
   ; hl = & block

   ret

fail_exit:

   ; bc = alignment - 1
   ; stack = X, request size, X
   
   pop de
   pop de
   pop hl
   
   scf
   ret
