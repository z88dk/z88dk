
; SP1PrintAt
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1PrintAt
LIB SP1GetUpdateStruct

; Print tile and colour to given coordinate.
;
; enter : d = row coord
;         e = col coord
;         b = attr
;         c = tile
; uses  : af, de, hl

.SP1PrintAt

   call SP1GetUpdateStruct
   inc hl
   ld (hl),b
   inc hl
   ld (hl),c

   ret
