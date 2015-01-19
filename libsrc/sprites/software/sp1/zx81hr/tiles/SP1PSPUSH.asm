; subroutine for writing registers to "struct sp1_pss"
; 02.2008 aralbrec
; zx81 hi-res version

PUBLIC SP1PSPUSH
EXTERN SP1V_TEMP_IX

; enter : hl  = & struct sp1_pss to write to
;         de' = & struct sp1_update
;          e  = flags
;          c  = y coordinate
;          b  = x coordinate
;         ix  = & bounds rectangle
; (SP1V_TEMP_IX) = & visit function

.SP1PSPUSH

   ld a,ixl                  ; write bounds rectangle
   ld (hl),a
   inc hl
   ld a,ixh
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
   ld a,(SP1V_TEMP_IX)       ; write visit function
   ld (hl),a
   inc hl
   ld a,(SP1V_TEMP_IX + 1)
   ld (hl),a

   ret
