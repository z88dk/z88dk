; void in_GetKeyReset(void)
; 09.2005 aralbrec

PUBLIC in_GetKeyReset
EXTERN _in_KeyDebounce, _in_KbdState

.in_GetKeyReset
   ld a,(_in_KeyDebounce)
   ld e,a
   ld d,0
   ld (_in_KbdState),de
   ret
