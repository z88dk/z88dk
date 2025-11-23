; subroutine for writing registers to "struct sp1_pss"
; 02.2008 aralbrec
; sinclair spectrum version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC SP1PSPUSH

; enter : hl = & struct sp1_pss to write to
;          e = flags
;          b = current x coordinate (relative to bounds rect IY)
;          c = current y coordinate (relative to bounds rect IY)
;        de' = current struct sp1_update *
;         b' = current attribute mask
;         c' = current colour
;         ix = visit function
;         iy = bounds rectangle

.SP1PSPUSH

   ld a,iyl
   ld (hl),a
   inc hl
   ld a,iyh
   ld (hl),a                 ; write bounds rectangle
   inc hl
   ld (hl),e                 ; write flags
   inc hl
   ld (hl),b                 ; write x coord
   inc hl
   ld (hl),c                 ; write y coord
   inc hl
   push hl
   exx
   pop hl
   ld (hl),b                 ; write attr mask
   inc hl
   ld (hl),c                 ; write attr
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d                 ; write struct sp1_update
   inc hl
   ld a,ixl
   ld (hl),a
   inc hl
   ld a,ixh
   ld (hl),a                 ; write visit function
   
   ret
