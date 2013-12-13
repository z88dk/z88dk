
XLIB __malloc_block_size

__malloc_block_size:

   ; Return available memory in block
   ;
   ; enter : hl = & block
   ;         carry reset
   ;
   ; exit  : de = & block
   ;         hl = raw available memory in bytes
   ;         carry reset
   ;
   ; uses  : af, de, hl
   
   push hl                     ; save & block
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = & next_block
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
