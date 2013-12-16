
XLIB __malloc_first_fit_aligned, l_andc_hlbc, l_inc_sp
LIB __malloc_block_adequate, __malloc_block_allocate_fixed

__malloc_first_fit_aligned:

   ; Return the first block found to have enough
   ; free bytes at an aligned address
   ;
   ; enter : de = request size
   ;         hl = & first block in region
   ;         bc = alignment - 1
   ; 
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = & block
   ;           de = & block_p = p_aligned - 6
   ;           bc = request size
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
   
   push bc                     ; save alignment - 1
   push de                     ; save request size
   push hl                     ; save & block
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
   ; de = & block_next
   ; hl = block->committed
   ; stack = alignment - 1, request size, & block, & block
   
   ex de,hl
   ex (sp),hl
   
   ; bc = alignment - 1
   ; hl = & block
   ; de = block->committed
   ; stack = alignment - 1, request size, & block, & block_next

   add hl,de

   ld a,d
   or e
   
   ld de,6                     ;de = sizeof(header)

   jr z, test_overlay          ; if block->committed == 0

   add hl,de                   ; hl = & block + block->committed + sizeof(header)
   jr c, block_fail

cond_1:

   ; hl = proposed p
   ; bc = alignment - 1
   ; de = sizeof(header) = 6
   ; stack = alignment - 1, request size, & block, & block_next
   
   add hl,bc
   call l_andc_hlbc            ; hl = proposed p_aligned

cond_0:

   sbc hl,de                   ; hl = p_aligned - 6 = & block_p

   ; hl = & block_p
   ; stack = alignment - 1, request size, & block, & block_next

   pop af
   pop de
   pop bc
   push af

   ; hl = & block_p
   ; de = & block
   ; bc = request size
   ; stack = alignment - 1, & block_next
   
   push de                       ; save & block
   call __malloc_block_adequate  ; can we place block_p ?
   pop hl                        ; hl = & block
   
   ; hl = & block
   ; de = & block_p
   ; bc = request size
   ; stack = alignment - 1, & block_next
   
   jp nc, l_inc_sp - 4         ; found block, return after popping two items

   ; better luck with next block
   
   ld e,c
   ld d,b                      ; de = request size
   pop hl                      ; hl = & block_next
   pop bc                      ; bc = alignment - 1
   
   ; bc = alignment - 1
   ; hl = & block_next
   ; de = request size
  
   jp block_loop

test_overlay:

   ; bc = alignment - 1
   ; hl = & block
   ; de = sizeof(header) = 6
   ; stack = alignment - 1, request size, & block, & block_next

   ; block->committed == 0 so try to place on top of block
   
   add hl,de                   ; hl = & block + header = proposed p

   ld a,l
   and c
   jr nz, not_aligned
   
   ld a,h
   and b
   jr z, cond_0                ; if block supports an aligned address

not_aligned:

   ; block is not at an aligned address so move
   ; proposed p past header

   add hl,de
   jp cond_1

block_fail:

   ; stack = alignment - 1, request size, & block, & block_next

   pop hl
   pop de
   pop de
   pop bc

   ; bc = alignment - 1
   ; hl = & block_next
   ; de = request size
  
   jp block_loop

fail_exit:

   ; stack = alignment - 1, request size, ?, ?

   pop de
   pop de
   pop de
   pop bc
   scf
   
   ; carry set
   ; de = request size
   ; bc = alignment - 1

   ret
