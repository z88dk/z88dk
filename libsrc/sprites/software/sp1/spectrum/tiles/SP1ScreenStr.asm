
; SP1ScreenStr
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1ScreenStr
LIB SP1GetUpdateStruct

; Return tile at background coord given.
;
; enter : d = row coord
;         e = col coord
; exit  : e = tile
; uses  : af, de, hl

.SP1ScreenStr

   call SP1GetUpdateStruct

   inc hl
   inc hl
   ld e,(hl)

   ret
