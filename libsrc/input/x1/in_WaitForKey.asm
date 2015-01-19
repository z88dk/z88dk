;
;       Sharp X1 - Keyboard Input
; 
;       void in_WaitForKey(void)
;       2013, Karl Von Dyson (X1s.org)
;

        PUBLIC in_WaitForKey
        EXTERN _x1_keyboard_io

; uses : AF, HL

.in_WaitForKey
        ld hl, _x1_keyboard_io+1
	ld a, 0xF7
	ld (hl), a
.i_wfkl ld a, (hl)
        and $40
        jp nz, i_wfkl      
        ret
