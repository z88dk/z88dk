
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; struct sp1_update *sp1_GetUpdateStruct(uchar row, uchar col)

XLIB sp1_GetUpdateStruct
LIB SP1GetUpdateStruct

.sp1_GetUpdateStruct

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   inc hl
   ld d,(hl)
   jp SP1GetUpdateStruct

; enter :  d = row coord
;          e = col coord
; exit  : hl = struct update *
; uses  : af, de, hl
