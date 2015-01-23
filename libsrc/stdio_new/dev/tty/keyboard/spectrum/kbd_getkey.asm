; uint kbd_getkey(struct kbd_state *ks)
; void kbd_getkeyreset(struct kbd_state *ks)
; 08.2009 aralbrec

PUBLIC kbd_getkey
PUBLIC kbd_getkeyreset

EXTERN kbd_inkey

; kbd_getkey() implements typewriter-like keyboard scanning
;
; struct kbd_state
; {
;     uchar last_key    // reserved
;     uchar count       // reserved
;     uchar repeatbeg   // period until key repeat begins
;     uchar repeatprd   // rate at which key repeats
; }
;
; enter : hl = struct kbd_state *ks
; exit  : a = hl = ascii code of keypress and carry flag is reset
;         a = hl = 0 and carry flag set if no keypress
; uses  : af, bc, de, hl

.kbd_getkey

   push hl                     ; save struct kbd_state *
   call kbd_inkey
   ld a,l                      ; a = ascii code of keypress
   pop hl                      ; hl = struct kbd_state *
   jr c, kbd_getkeyreset       ; if no key was pressed
   
   cp (hl)                     ; compare to last recorded keypress
   jr nz, state_newkey         ; if different register a new keypress

   ; user is holding down the same key
   
   inc hl
   dec (hl)                    ; reduce repeat count
   jr nz, return_nokey         ; if count not zero key is not reported
   
.state_repeatperiod

   inc hl
   inc hl
   ld e,(hl)                   ; e = repeat period
   dec hl
   dec hl
   ld (hl),e                   ; count = repeat period
   jp return_key

.state_newkey

   ld (hl),a                   ; last key recorded = this one
   inc hl
   inc hl
   ld e,(hl)                   ; e = repeat begin period
   dec hl
   ld (hl),e                   ; count = repeat begin period

.return_key

   ld l,a
   ld h,0
   or a
   ret
   
   
; kbd_getkeyreset() resets the getkey state machine
;
; enter : hl = struct kbd_state *ks
; exit  : a = hl = 0 and carry flag set
; uses  : af, hl
   
.kbd_getkeyreset

   ld (hl),0                   ; last key = no key

.return_nokey

   xor a
   ld l,a
   ld h,a
   scf
   ret

