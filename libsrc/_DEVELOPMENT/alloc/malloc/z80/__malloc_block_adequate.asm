
XLIB __malloc_block_adequate

__malloc_block_adequate:

   ; Can block_p of size given be created inside existing block?
   ;
   ; enter : hl = & block_p
   ;         de = & block
   ;         bc = request size (includes space for header)
   ;
   ; exit  : de = & block_p
   
   ;         success
   ;
   ;           carry reset
   ;
   ;         fail
   ;
   ;           carry set
   ;
   ; uses  : af, de, hl

   ; (1) Will block_p begin in an unoccupied portion of block?
   
   push hl                     ; save & block_p
   
   or a
   sbc hl,de
   jr c, fail_1                ; if block_p < block

   ex de,hl
   push bc
   
   ; hl = & block
   ; de = block_p - block
   ; stack = & block_p, request size
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = block->next = & block_next
   inc hl
   
   push bc                     ; save & block_next

   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = block->committed
   
   ex de,hl
   
   ; hl = block_p - block
   ; bc = block->committed
   ; stack = & block_p, request size, & block_next
   
   jr z, overlay               ; if block == block_p

   sbc hl,bc
   jr c, fail_0                ; block_p begins in part of block already in use

   ; (2) Is there sufficient free space inside block to accommodate block_p ?
   ; 
   ; stack = & block_p, request size, & block_next

cond_2:

   pop hl                      ; hl = & block_next
   pop bc                      ; bc = request size
   pop de                      ; de = & block_p
   
   sbc hl,de
   jp c, error_zc
   
   sbc hl,bc
   ret                         ; carry set if insufficient space

overlay:
   
   ; (3) We can place block_p on top of block but only if block->committed == 0
   ;
   ; bc = block->committed
   ; stack = & block_p, request size, & block_next

   ld a,b
   or c
   jp z, cond_2

fail_0:

   ; stack = & block_p, request size, & block_next
   
   pop bc
   pop bc                      ; bc = request size

fail_1:

   pop de                      ; de = & block_p
   
   scf
   ret
