
; SP1PrintAt
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1PrintAt
LIB SP1GetUpdateStruct

; Print tile and colour to given coordinate.
;
; enter :  d = row coord
;          e = col coord
;         bc = tile code
;          a = attr
; uses  : af, de, hl, af'

.SP1PrintAt

   ex af,af
   call SP1GetUpdateStruct
   ex af,af
   inc hl
   ld (hl),a
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b
   ret
