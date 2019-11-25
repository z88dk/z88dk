;
;       Sharp X1 - Keyboard Input
; 
;       void in_Wait(void)
;       2013, Karl Von Dyson (X1s.org)
;

	SECTION code_clib
        PUBLIC in_Wait
        PUBLIC _in_Wait
        EXTERN t_delay

; Waits a period of time measured in milliseconds.
;
; enter : HL = time to wait in ms
; used  : AF,BC,DE,HL

.in_Wait
._in_Wait
        ; wait 1ms in loop controlled by HL
        ; at 3.5MHz, 1ms = 3500 T states
        ld e,l
        ld d,h
.loop   ld hl,3500 - 36
        call t_delay
        dec de
        ld a,d
        or e
        jr nz, loop
        ret
