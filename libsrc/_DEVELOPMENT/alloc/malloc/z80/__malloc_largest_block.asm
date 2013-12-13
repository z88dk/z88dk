
XLIB __malloc_largest_block
LIB __malloc_block_size

__malloc_largest_block:

   ; Return the largest block in the region.
   ;
   ; enter : hl = & first block in region
   ;
   ; exit  : hl = & block_largest
   ;         bc = block_largest size
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl
   
   ld bc,0
   push bc
      
block_loop:

   ; hl = & block
   ; bc = block_largest size
   ; stack = & block_largest

   or a
   call __malloc_block_size    ; hl = block size, de = & block

   sbc hl,bc
   jr c, not_bigger
   
bigger:

   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = new block_largest size
   
   pop hl
   push de                     ; new & block_largest

not_bigger:

   ex de,hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = & block_next
   
   or h
   jp nz, block_loop
   
   pop hl
   ret
