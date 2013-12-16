
XLIB __malloc_block_locate
XDEF __0_malloc_block_locate

LIB error_zc

__malloc_block_locate:

   ; Within the region, search for the block corresponding to ptr p
   ;
   ; enter : de = & region
   ;         bc = void *p
   ;
   ; exit  : bc = & block_p = p - 6
   ;
   ;         success:
   ;
   ;           carry reset
   ;           de = & block containing address p
   ;
   ;         fail:
   ;
   ;           carry set
   ;           hl = 0
   ;
   ; uses  : af, bc, de, hl
   
   ld hl,-6
   add hl,bc
   ld c,l
   ld b,h                      ; bc = & block_p
   
__0_malloc_block_locate:

   ld hl,4
   add hl,de                   ; hl = & first block in region

block_loop:

   ; hl = & block
   ; bc = & block_p
   
   ; reached end of region ?
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->next = & block_next
   dec hl
   
   ld a,d
   or e
   jp z, error_zc              ; if block is a region terminator
   
   ; can block_p be in this block ? - check lower bound
   
   sbc hl,bc
   jr z, exact_match           ; if block_p == block
   jp nc, error_zc             ; if block_p <  block
   
   add hl,bc
   ex de,hl
   
   ; de = & block
   ; hl = & block_next
   ; bc = & block_p
   
   ; can block_p be in this block ? - check upper bound
   
   scf
   sbc hl,bc
   ret nc                      ; if block_p is inside this block
   
   ; try next block
   
   add hl,bc
   jp block_loop

exact_match:

   add hl,bc
   ex de,hl

   ; carry reset
   ; de = & block
   ; bc = & block_p
   
   ret
