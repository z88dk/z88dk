
; SP1Screen
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1Screen
LIB SP1GetUpdateStruct

; Return tile and colour of background at coords given.
;
; enter : d = row coord
;         e = col coord
; exit  : d = attr
;         e = tile
; uses  : af, de, hl

.SP1Screen

   call SP1GetUpdateStruct

   inc hl
   ld d,(hl)
   inc hl
   ld e,(hl)

   ret
