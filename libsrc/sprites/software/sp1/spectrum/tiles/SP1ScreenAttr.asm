
; SP1ScreenAttr
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1ScreenAttr
LIB SP1GetUpdateStruct

; Return colour at background coord given.
;
; enter : d = row coord
;         e = col coord
; exit  : e = attr
; uses  : af, de, hl

.SP1ScreenAttr

   call SP1GetUpdateStruct

   inc hl
   ld e,(hl)

   ret
