
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_GetSprClrAddr(struct sp1_ss *s, uchar **sprdest)

XLIB sp1_GetSprClrAddr
LIB SP1GetSprClrAddr

.sp1_GetSprClrAddr

   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   jp SP1GetSprClrAddr

; enter : hl = & struct sp1_ss
;         de = destination array of sprite colour addresses
; uses  : af, bc, de, hl

