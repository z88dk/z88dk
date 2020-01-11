; void in_GetKeyReset(void)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_GetKeyReset
PUBLIC _in_GetKeyReset
EXTERN _in_KeyDebounce, _in_KbdState

.in_GetKeyReset
._in_GetKeyReset
   ld a,(_in_KeyDebounce)
   ld e,a
   ld d,0
IF __CPU_INTEL__
   ex de,hl
   ld (_in_KbdState),hl
   ex de,hl
ELSE
   ld (_in_KbdState),de
ENDIF
   ret
