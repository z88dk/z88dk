; uint in_GetKey(void)
; 09.2005 aralbrec

; Scans the keyboard and returns an ascii code representing a
; single keypress.  Operates as a state machine.  First
; it debounces a key by ignoring it until a minimum time
; "_in_KeyDebounce" (byte) has passed.  The key will be registered
; and then it will wait until the key has been pressed for a period
; "_in_KeyStartRepeat" (byte).  The key will again be registered and
; then repeated thereafter with period "_in_KeyRepeatPeriod" (byte).
; If more than one key is pressed, no key is registered and the
; state machine returns to the debounce state.  Time intervals
; depend on how often GetKey is called.

SECTION code_clib
PUBLIC in_GetKey
PUBLIC _in_GetKey
EXTERN in_Inkey, in_GetKeyReset
EXTERN _in_KeyDebounce, _in_KeyStartRepeat, _in_KeyRepeatPeriod
EXTERN _in_KbdState

; exit : carry = no key registered (and HL=0)
;        else HL = ascii code of key pressed
; uses : AF,BC,DE,HL

.in_GetKey
._in_GetKey

   call in_Inkey              ; hl = ascii code & carry if no key
   jp c, in_GetKeyReset

   ld a,(_in_KbdState)
   dec a
   jr nz, nokey

   ld a,(_in_KbdState + 1)
   dec a
   jp m, debounce
   jp z, startrepeat

.repeat

   ld a,(_in_KeyRepeatPeriod)
   ld (_in_KbdState),a
   ret

.debounce

   ld a,(_in_KeyStartRepeat)
   ld e,a
   ld d,1
   ld (_in_KbdState),de
   ret

.startrepeat

   ld a,(_in_KeyRepeatPeriod)
   ld e,a
   ld d,2
   ld (_in_KbdState),de
   ret

.nokey

   ld (_in_KbdState),a
   ld hl,0
   scf
   ret
