;
;       Sharp X1 Stdio
;
;       getk() - Read key status
;
;       Karl Von Dyson (for X1s.org) - 24/10/2013
;

        XLIB getk
        XREF _x1_keyboard_io

getk:
        ld hl, _x1_keyboard_io
        ld a, (hl)
        ld h, 0
        ld l, a
	ret
