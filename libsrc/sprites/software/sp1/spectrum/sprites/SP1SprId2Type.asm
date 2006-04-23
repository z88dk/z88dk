
; SP1SprId2Type
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1SprId2Type
XREF SP1V_IDTYPEASSOC

; Return sprite type associated with id. Sprite
; Ids are invariants defined in the header file
; but sprite types are defined in each project.
; Each unique sprite type attaches sprite draw
; code from the library.
;
; enter : e = sprite id
; exit  : a = sprite type
; used  : af, hl

.SP1SprId2Type

   ld hl,(SP1V_IDTYPEASSOC)
   dec hl

.loop

   inc hl
   ld a,(hl)
   or a
   ret z

   cp e
   inc hl
   jp nz, loop

   ld a,(hl)
   ret
