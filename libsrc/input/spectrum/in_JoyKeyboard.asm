; uint in_JoyKeyboard(struct in_UDK *)
; CALLER linkage for function pointers

XLIB in_JoyKeyboard
LIB in_JoyKeyboard_fastcall

.in_JoyKeyboard

   pop de
   pop hl
   push hl
   push de
   
   jp in_JoyKeyboard_fastcall
