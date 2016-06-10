;
;       Sharp X1 - Keyboard Input
; 
;       uint in_LookupKey(unsigned char c)
;       2013, Karl Von Dyson (X1s.org)
;
;       Note 1:
;       This function is not usually needed since the X1's keyboard returns an
;       ASCII code for key presses. It has been provided as a placeholder, and in
;       case we do end up wanting to use it for some reason.
;
;       Note 2:
;       This routine does not differentiate between keys and their numeric keypad
;       equivalents. 

	SECTION code_clib
        PUBLIC in_LookupKey
        PUBLIC _in_LookupKey

.in_LookupKey
._in_LookupKey
        ld a, l

        cp 128
        jp c, nxt1
        ld h, 0xBB
        ret

.nxt1   cp 123
	jp c, nxt2
        cp 127
        jp nc, nxt2
        ld h, 0xBD
	ret

.nxt2   cp 96
        jp nz, nxt3
        ld h, 0xBD
        ret

.nxt3   cp 65
        jp c, nxt4
        cp 91
        jp nc, nxt4
        ld h, 0xB7
        ret

.nxt4   cp 60
        jp c, nxt5
        cp 64
        jp nc, nxt5
        ld h, 0xBD
        ret

.nxt5   cp 33
        jp c, nxt6
        cp 44
        jp nc, nxt6
        ld h, 0xBD
        ret

.nxt6   ld h, 0xBF
        ret
