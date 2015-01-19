; subroutine for writing registers to "struct sp1_pss"
; 02.2008 aralbrec
; ts2068 hi-res version

PUBLIC SP1PSPUSH

; exit  : hl = & struct sp1_pss to write to
;          e = flags (bit 0 = invalidate?, bit 1 = xwrap?, bit 2 = yinc?, bit3 = ywrap?)
;          b = current x coordinate (relative to bounds rect IY)
;          c = current y coordinate (relative to bounds rect IY)
;        de' = current struct sp1_update *
;         ix = visit function
;         iy = bounds rectangle

.SP1PSPUSH

   ld a,iyl                  ; write bounds rectangle
   ld (hl),a
   inc hl
   ld a,iyh
   ld (hl),a
   inc hl
   ld (hl),e                 ; write flags
   inc hl
   ld (hl),b                 ; write x coordinate
   inc hl
   ld (hl),c                 ; write y coordinate
   inc hl
   push hl
   exx
   pop hl
   ld (hl),e                 ; write sp1_update
   inc hl
   ld (hl),d
   inc hl
   ld a,ixl                  ; write visit function
   ld (hl),a
   inc hl
   ld a,ixh
   ld (hl),a

   ret
