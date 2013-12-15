
XLIB __malloc_block_allocate
LIB __0_malloc_block_allocate_fixed, __1_malloc_block_allocate_fixed

__malloc_block_allocate:

   ; Allocates bytes from indicated block.
   ; Assumes there is sufficient space to do so.
   ;
   ; enter : hl = & block
   ;         bc = request size (includes header)
   ;
   ; exit  : carry reset
   ;         hl = & allocated memory (ie past header)
   ;
   ; uses  : af, de, hl
   
   push hl                     ; save block
   
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->committed
   
   pop hl                      ; hl = & block
   
   ld a,d
   or e
   jp z, __1_malloc_block_allocate_fixed  ; placing on top of existing block
   
   ex de,hl
   add hl,de
   ex de,hl

   ; bc = request size
   ; hl = & block
   ; de = & new_block
   ; carry reset

   jp __0_malloc_block_allocate_fixed
