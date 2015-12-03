
SECTION code_clib
SECTION code_alloc_malloc

PUBLIC __heap_place_block

EXTERN l_ltu_de_hl

__heap_place_block:

   ; Determine if block_new fits into block's spare space
   ;
   ; enter : bc = gross request size
   ;         hl = & block
   ;         de = & block_new
   ;
   ; exit  : bc = gross request size
   ;         hl = & block
   ;         de = & block_new
   ;
   ;         success
   ;
   ;            carry reset
   ;
   ;         fail
   ;
   ;            carry set
   ;
   ; uses  : af

   call l_ltu_de_hl
   ret c                       ; if block_new < block

   push hl                     ; save & block
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = block->next = & block_next
   
   or h
   jr z, fail                  ; if block is end of heap marker

   ; bc = gross request size
   ; de = & block_new
   ; hl = & block_next
   ; stack = & block
   
   sbc hl,de                   ; hl = avail bytes to next block
   jr c, fail                  ; if block_next < block_new

   sbc hl,bc
   jr c, fail                  ; if avail bytes < gross request size

   ; block_new will fit before block_next

   pop hl                      ; hl = & block
   
   push hl                     ; save & block
   push bc                     ; save gross request size
   
   ld c,l
   ld b,h                      ; bc = & block
   
   inc hl
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = block->committed
   
   ld a,h
   or l
   jr nz, committed_nonzero    ; if committed != 0
   
   ; committed == 0 so either block_new sits exactly on
   ; top of this header or it is at least six bytes ahead
   
   ld hl,6
   
   call committed_nonzero
   ret nc

   ; bc = gross request size
   ; de = & block_new
   ; hl = & block
   
   ld a,e
   cp l
   
   scf
   ret nz
   
   ld a,d
   cp h
   
   ret z                       ; if block == block_new
   
   scf
   ret
   
committed_nonzero:
  
   add hl,bc                   ; hl = & first avail byte in block
   pop bc
   
   ; bc = gross request size
   ; de = & block_new
   ; hl = & first avail byte in block
   ; stack = & block
   
   call l_ltu_de_hl            ; carry reset if de >= hl
   
   pop hl
   ret

fail:

   pop hl
   
   scf
   ret
