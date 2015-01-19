;
;       Sharp X1 - Keyboard Input
; 
;       void in_WaitForNoKey(void)
;       2013, Karl Von Dyson (X1s.org)
;

        PUBLIC in_WaitForNoKey
        EXTERN _x1_keyboard_io

; uses : AF, HL

.in_WaitForNoKey
        ld hl, _x1_keyboard_io+1
        ld a, (hl)
        and $40
        jp z, in_WaitForNoKey
        ret
