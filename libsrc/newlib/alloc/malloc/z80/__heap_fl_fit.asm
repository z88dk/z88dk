
SECTION code_clib
SECTION code_alloc_malloc

PUBLIC __heap_fl_fit

; First-fit test against one block. The bytes available are
; block->next - (block + block->committed), the same quantity the
; original walk used.

__heap_fl_fit:

   ; enter : hl = & block
   ;         bc = gross request (header + user bytes)
   ;
   ; exit  : success
   ;
   ;            hl = & block
   ;            de = & block_new (overlay or insert address)
   ;            bc = gross request
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = & block
   ;            bc = gross request
   ;            carry set
   ;
   ; uses  : af, de

   push hl
   push bc

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->next

   ld a,d
   or e
   jr z, fit_none

   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = block->committed

   dec hl
   dec hl
   dec hl                      ; hl = & block

   add hl,bc                   ; hl = allocation address

   ex de,hl                    ; de = allocation address, hl = block->next

   pop bc                      ; bc = gross request

   or a
   sbc hl,de                   ; hl = free bytes
   sbc hl,bc                   ; free bytes - gross request

   pop hl                      ; hl = & block

   ret c                       ; free bytes < gross request

   or a
   ret

fit_none:

   pop bc
   pop hl
   scf
   ret
