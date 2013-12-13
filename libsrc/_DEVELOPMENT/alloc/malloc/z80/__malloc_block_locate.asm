
XLIB __malloc_block_locate
XDEF __0_malloc_block_locate

LIB error_zc

__malloc_block_locate:

   ; Within the region, search for the block corresponding to ptr p
   ; Return the block as well as the lagging block (block prior)
   ;
   ; enter : de = & region
   ;         bc = void *p
   ;
   ; exit  : bc = & block_p = p - 6
   ;
   ;         success:
   ;
   ;           carry reset
   ;           de = & block_lagger
   ;           hl = & block_p
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
   
   ld de,0                     ; de = & block_lagger = 0

block_loop:

   ; de = & block_lagger
   ; hl = & block_current
   ; bc = & block_p

   ; found block_p ?
   
   ld a,l
   cp c
   jr nz, not_found
   
   ld a,h
   cp b
   ret z                       ; block found !
   
not_found:

   jr c, try_next_block
   jp nz, error_zc
   
   ld a,l
   cp c
   jp nc, error_zc

try_next_block:

   ld e,l
   ld d,h                      ; de = & block_lagger = & block_current
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   or h
   jp nz, block_loop
   
   jp error_zc
