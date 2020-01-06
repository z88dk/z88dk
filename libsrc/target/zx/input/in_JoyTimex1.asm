; uint in_JoyTimex1(void)
; 2002 aralbrec

SECTION code_clib
PUBLIC in_JoyTimex1
PUBLIC _in_JoyTimex1

; exit : A = HL = F000RLDU active high
; uses : AF,HL

; WARNING: farts around with the AY registers -- might
;   conflict with an AY sound routine in an interrupt -
;   haven't decided what to do about this yet.  If you
;   have an AY player in an interrupt you can either
;   disable interrupts while reading Timex joysticks
;   (and risk missing a beat) or sync joystick reads
;   with interrupts, eg by putting joystick reads
;   into the interrupt routine.

.in_JoyTimex1
._in_JoyTimex1
   ld a,7
   out ($f5),a         ; select R7 on AY chip
   in a,($f6)          ; read R7
   and $bf             ; bit 6 = 0 selects i/o port A read
   out ($f6),a
   ld a,14
   out ($f5),a         ; select R14, attached to i/o port A

   ld a,2              ; left joystick
   in a,($f6)
   cpl
   and $8f
   ld l,a
   ld h,0
   ret
