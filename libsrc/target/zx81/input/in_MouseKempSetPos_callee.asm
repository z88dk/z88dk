; void __CALLEE__ in_MouseKempSetPos_callee(uint xcoord, uint ycoord)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_MouseKempSetPos_callee
PUBLIC _in_MouseKempSetPos_callee
PUBLIC asm_in_MouseKempSetPos
PUBLIC centry_in_MouseKempSetPos

EXTERN INMouseKemp
EXTERN _in_KempcoordX, _in_KempcoordY

.in_MouseKempSetPos_callee
._in_MouseKempSetPos_callee

   pop hl
   pop bc
   ex (sp),hl

.centry_in_MouseKempSetPos

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
   
.asm_in_MouseKempSetPos

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

