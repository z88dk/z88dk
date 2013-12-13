
XLIB __malloc_largest_fit
LIB __malloc_region_info, __malloc_largest_block

__malloc_largest_fit:

   ; Return the largest block in the heap
   ;
   ; enter : hl = & region
   ;
   ; exit  : bc = largest block size
   ;         hl = & block_largest
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl
   
   ld bc,0
   push bc

region_loop:

   ; hl = & region
   ; bc = block_largest size
   ; stack = & block_largest
   
   push hl                     ; save region
   
   call __malloc_region_info
   jr z, done                  ; no more regions

   sbc hl,bc                   ; region size - block_largest size
   
   pop hl
   ex de,hl                    ; hl = & next_region, de = & region
   
   jr c, region_loop           ; region is too small to have bigger block
   
   push hl                     ; save & region_next

search_region:

   ld hl,4
   add hl,de
   
   ; bc = block_largest size
   ; hl = & first block in region
   ; stack = & block_largest, & region_next
   
   push bc                     ; save block_largest size
   
   call __malloc_largest_block ; bc = block_largest_size_local
   ex de,hl                    ; de = & block_largest_local
   
   pop hl                      ; hl = block_largest size

   sbc hl,bc                   ; is this new one bigger?
   jp nc, block_smaller

block_larger:
   
   pop hl                      ; hl = & region_next
   
   pop af                      ; junk former block_largest
   push de                     ; stack = & block_largest
   
   jp region_loop

block_smaller:

   add hl,bc
   
   ld c,l
   ld b,h                      ; restore block_largest size
   
   pop hl                      ; hl = & region_next
   jp region_loop

done:

   ; bc = block_largest size
   ; stack = & block_largest, & region

   pop hl
   pop hl
   
   ret
