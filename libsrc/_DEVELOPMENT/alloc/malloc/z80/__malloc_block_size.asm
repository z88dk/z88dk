
XLIB __malloc_block_size
LIB error_zc

__malloc_block_size:

   ; Return available memory in block
   ;
   ; enter : hl = & block
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           de = & block
   ;           hl = raw available memory in bytes
   ;
   ;         fail, this block is a region terminator
   ;
   ;           carry set
   ;           de = hl = 0
   ;
   ; uses  : af, de, hl
   
   push hl                     ; save & block
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = & next_block
   
   ld a,d
   or e
   jp z, error_zc - 1          ; if this is a region terminator
   
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = block->committed
   
   ex de,hl
   sbc hl,de                   ; hl = & next_block - committed
   
   pop de                      ; de = & block

   sbc hl,de                   ; hl = memory available in block
   ret
