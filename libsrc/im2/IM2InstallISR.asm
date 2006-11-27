; 04.2004 aralbrec

XLIB IM2InstallISR

; DISABLE INTERRUPTS PRIOR TO CALLING

; Writes ISR address into interrupt vector table.
;
; enter:  L = vector to install on (even by convention)
;        DE = new ISR address
; exit : DE = old ISR address
; uses : AF,DE,HL

.IM2InstallISR
   ld a,i
   ld h,a
   ld a,(hl)
   ld (hl),e
   ld e,a
   inc hl
   ld a,(hl)
   ld (hl),d
   ld d,a
   ret
