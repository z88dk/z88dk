; void in_MouseSimInit(struct in_UDM *u)
; 09.2005 aralbrec

; mainly for symmetry with AMX mouse functions

XLIB in_MouseSimInit

.in_MouseSimInit
   pop de
   pop hl
   push hl
   push de

; just set initial coordinates to (0,0) and reset state machine
; enter: HL = struct in_UDM *
; uses : BC,DE,HL

   ld de,6
   add hl,de
   ld e,l
   ld d,h
   inc de
   ld (hl),0
   ld bc,5
   ldir
   ret
