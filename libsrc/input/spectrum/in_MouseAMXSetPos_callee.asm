; void __CALLEE__ in_MouseAMXSetPos_callee(uint xcoord, uint ycoord)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_MouseAMXSetPos_callee
PUBLIC _in_MouseAMXSetPos_callee
PUBLIC ASMDISP_IN_MOUSEAMXSETPOS_CALLEE
PUBLIC CDISP_IN_MOUSEAMXSETPOS_CALLEE

EXTERN _in_AMXcoordX, _in_AMXcoordY

.in_MouseAMXSetPos_callee
._in_MouseAMXSetPos_callee

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

   ld a,c
   ld (_in_AMXcoordX + 1),a
   ld a,b
   ld (_in_AMXcoordY + 1),a
   ret

DEFC ASMDISP_IN_MOUSEAMXSETPOS_CALLEE = # asmentry - in_MouseAMXSetPos_callee
DEFC CDISP_IN_MOUSEAMXSETPOS_CALLEE = # centry - in_MouseAMXSetPos_callee
