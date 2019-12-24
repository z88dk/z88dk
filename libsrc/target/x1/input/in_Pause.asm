;
;       Sharp X1 - Keyboard Input
; 
;       uint in_Pause(uint ticks)
;       2013, Karl Von Dyson (X1s.org)
;

	SECTION code_clib
        PUBLIC in_Pause
        PUBLIC _in_Pause
        EXTERN in_WaitForKey, t_delay
        EXTERN _x1_keyboard_io

; Waits a period of time measured in milliseconds and exits
; early if a key is pressed

; enter: HL = time to wait in ms, if 0 waits forever until key pressed
; exit : carry = exit early because of keypress with HL = time remaining
;        no carry = exit after time passed
; uses : AF,BC,DE,HL

.in_Pause
._in_Pause
        ld a, h
        or l
	ld bc, _x1_keyboard_io+1
	ld a, 0xF7
	ld (bc), a
        jp z, in_WaitForKey
.loop
        ex de,hl
   	ld hl,3500 - 78
   	call t_delay                  ; wait exactly HL t-states
   	ex de,hl
   	dec hl
   	ld a,h
   	or l
   	ret z

        ld bc, _x1_keyboard_io+1	
	ld a, (bc)
        and $40
        jp nz, loop

        ret
