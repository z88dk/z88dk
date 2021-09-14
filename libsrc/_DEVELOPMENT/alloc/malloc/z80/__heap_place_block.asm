
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
   ret C                       ; if block_new < block

   push hl                     ; save & block
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = block->next = & block_next
   
   or h
IF __CPU_INTEL__
   jp Z, fail                  ; if block is end of heap marker
ELSE
   jr Z, fail                  ; if block is end of heap marker
ENDIF

   ; bc = gross request size
   ; de = & block_new
   ; hl = & block_next
   ; stack = & block
   
IF __CPU_INTEL__ || __CPU_GBZ80__
   ld a,l
   sub e
   ld l,a
   ld a,h
   sub d
   ld h,a                      ; hl = avail bytes to next block
   jp C, fail                  ; if block_next < block_new
ELSE
   sbc hl,de                   ; hl = avail bytes to next block
   jr C, fail                  ; if block_next < block_new
ENDIF

IF __CPU_INTEL__ || __CPU_GBZ80__
IF __CPU_8085__
   sub hl,bc
ELSE
   ld a,l
   sub c
   ld l,a
   ld a,h
   sub b
   ld h,a
ENDIF
   jp C, fail                  ; if avail bytes < gross request size
ELSE
   sbc hl,bc
   jr C, fail                  ; if avail bytes < gross request size
ENDIF

   ; block_new will fit before block_next

   pop hl                      ; hl = & block
   
   push hl                     ; save & block
   push bc                     ; save gross request size
   
   ld bc,hl                    ; bc = & block
   
   inc hl
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = block->committed
   
   ld a,h
   or l
IF __CPU_INTEL__
   jp NZ, committed_nonzero    ; if committed != 0
ELSE
   jr NZ, committed_nonzero    ; if committed != 0
ENDIF
   
   ; committed == 0 so either block_new sits exactly on
   ; top of this header or it is at least six bytes ahead
   
   ld hl,6
   
   call committed_nonzero
   ret NC

   ; bc = gross request size
   ; de = & block_new
   ; hl = & block
   
   ld a,e
   cp l
   
   scf
   ret NZ
   
   ld a,d
   cp h
   
   ret Z                       ; if block == block_new
   
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
