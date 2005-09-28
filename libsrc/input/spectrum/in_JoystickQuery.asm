; void *in_JoystickQuery(uchar i)
; 09.2005 aralbrec

XLIB in_JoystickQuery
LIB in_JoyKeyboard, in_JoyKempston, in_JoySinclair1
LIB in_JoySinclair2, in_JoyFuller, in_JoyTimex1
LIB in_JoyTimex2

.in_JoystickQuery
   ld a,l
   cp 7
   jr c, inrange
   xor a
.inrange
   add a,a
   ld l,a
   ld h,0
   ld de,table
   add hl,de
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl
   ret

.table
   defw in_JoyKeyboard, in_JoyKempston, in_JoySinclair1
   defw in_JoySinclair2, in_JoyFuller, in_JoyTimex1
   defw in_JoyTimex2