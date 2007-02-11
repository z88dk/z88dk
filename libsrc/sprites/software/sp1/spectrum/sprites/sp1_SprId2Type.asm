; uchar __FASTCALL__ sp1_SprId2Type(uchar id)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB sp1_SprId2Type
XREF SP1V_IDTYPEASSOC

.sp1_SprId2Type

   ld e,l
   
; Return sprite type associated with id. Sprite
; Ids are invariants defined in the header file
; but sprite types are defined in each project.
; Each unique sprite type attaches sprite draw
; code from the library.
;
; enter : e = sprite id
; exit  : hl = sprite type
; used  : af, hl

.SP1SprId2Type

   ld hl,(SP1V_IDTYPEASSOC)
   dec hl

.loop

   inc hl
   ld a,(hl)
   or a
   jr z, fail

   cp e
   inc hl
   jp nz, loop

   ld l,(hl)
   ld h,0
   ret

.fail

   ld hl,0
   ret
   