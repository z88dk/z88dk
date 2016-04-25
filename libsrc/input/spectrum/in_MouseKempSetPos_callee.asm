; void __CALLEE__ in_MouseKempSetPos_callee(uint xcoord, uint ycoord)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_MouseKempSetPos_callee
PUBLIC _in_MouseKempSetPos_callee
PUBLIC ASMDISP_IN_MOUSEKEMPSETPOS_CALLEE
PUBLIC CDISP_IN_MOUSEKEMPSETPOS_CALLEE

EXTERN INMouseKemp
EXTERN _in_KempcoordX, _in_KempcoordY

.in_MouseKempSetPos_callee
._in_MouseKempSetPos_callee

   pop hl
   pop bc
   ex (sp),hl

.centry

; bc = ycoord
; hl = xcoord

   ld a,b
   or a
   jr nz, correcty
   ld a,c
   cp 191
   jp c, yok

.correcty

   ld a,191

.yok

   ld b,a
   ld a,h
   or a
   jp z, xok
   ld l,255

.xok

   ld c,l
   
.asmentry

; enter: C = x coord 0..255
;        B = y coord 0..191

   push bc
   call INMouseKemp            ; zero out any existing delta
   pop bc
   
   ld a,c
   ld (_in_KempcoordX),a
   ld a,b
   ld (_in_KempcoordY),a

   ret

DEFC ASMDISP_IN_MOUSEKEMPSETPOS_CALLEE = # asmentry - in_MouseKempSetPos_callee
DEFC CDISP_IN_MOUSEKEMPSETPOS_CALLEE = # centry - in_MouseKempSetPos_callee
