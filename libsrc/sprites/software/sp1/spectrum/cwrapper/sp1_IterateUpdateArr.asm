
; C Wrapper
; 04.2006 aralbrec, Sprite Pack v3.0
; Sinclair Spectrum version

; void sp1_IterateUpdateArr(struct sp1_update **ua, void *hook)  // zero terminated array

XLIB sp1_IterateUpdateArr
LIB SP1IterateUpdateArr

.sp1_IterateUpdateArr

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
   ld ixl,e
   ld ixh,d
   jp SP1IterateUpdateArr

; enter : hl = zero terminated array of struct sp1_update *
;         ix = function to call for each stuct sp1_update in array (stack, hl = parameter)
; uses  : af, de, hl + whatever user function uses
