
XLIB __malloc_first_fit
LIB __malloc_block_size

__malloc_first_fit:

   ; Return the first block found to have enough
   ; free bytes to accommodate the request
   ;
   ; enter : bc = request size
   ;         hl = & first block in region
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = & block containing sufficient free bytes
   ;
   ;         fail
   ;
   ;           carry set
   ;
   ; uses  : af, de, hl
   
block_loop:

   call __malloc_block_size    ; hl = block size, de = & block
   ret c                       ; if no more blocks
   
   sbc hl,bc                   ; can satisfy request?
   
   ex de,hl                    ; hl = current block
   ret nc
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = & next_block

   jp block_loop
