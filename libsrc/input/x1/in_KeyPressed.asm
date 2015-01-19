;
;       Sharp X1 - Keyboard Input
; 
;       uint in_KeyPressed(uint scancode)
;       2013, Karl Von Dyson (X1s.org)
;

        PUBLIC in_KeyPressed
        EXTERN _x1_keyboard_io

;       Determines if a key is pressed using the key data
;       returned by in_LookupKey (or similar).

;       enter : l - ASCII key code
;               h - key data
;       exit  : carry = key is pressed & HL = 1
;               no carry = key is not pressed & HL = 0
;       uses: : AF, BC, HL

.in_KeyPressed
        ld bc, _x1_keyboard_io
        ld a, (bc)
        cp l
        jp nz, nkey
        inc bc
        ld a, (bc)
        cp h
        jp nz, nkey
        scf
        ld hl, 1
        ret
.nkey   cp a
        ld hl, 0
        ret
