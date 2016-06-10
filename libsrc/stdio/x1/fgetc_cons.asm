;
;       Sharp X1 Stdio
;
;       fgetc_cons() - Wait for a keypress
;
;       Karl Von Dyson (for X1s.org) - 24/10/2013
;

	SECTION code_clib
        PUBLIC fgetc_cons
        PUBLIC _fgetc_cons
        EXTERN _x1_keyboard_io

fgetc_cons:      
_fgetc_cons:      
        ld hl, _x1_keyboard_io+1
        ld a, (hl)
        and $40
        jp nz, fgetc_cons
        dec hl
        ld a, (hl)
        and a
        jp z, fgetc_cons
        ld (hl), 0
        ld h, 0
        ld l, a
        ret

