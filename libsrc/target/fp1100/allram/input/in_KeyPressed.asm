; uint in_KeyPressed(uint scancode) __z88dk_fastcall: carry and HL = 1 if the key of the scancode (in_LookupKey's: L = row, bit 7 shift, H = mask) is down,
; else NC and HL = 0.  The shift key has to be as the scancode says.  Asks the sub program every time.  Uses af, bc, de, hl.

    SECTION code_clib
    PUBLIC  in_KeyPressed
    PUBLIC  _in_KeyPressed
    EXTERN  fp1100_keys
    EXTERN  fp1100_keybuf

in_KeyPressed:
_in_KeyPressed:
    push    hl
    call    fp1100_keys
    pop     de                          ; e = the row (and shift), d = the mask
    ld      hl, fp1100_keybuf
    ld      a, (hl)
    inc     hl
    ld      b, a                        ; rows with a key down
    ld      c, 0                        ; shift down: 1
    and     a
    jr      z, nokey
    push    hl
    push    bc
kp1:
    ld      a, (hl)
    and     $3F
    cp      1
    jr      nz, kp2
    inc     hl
    ld      a, (hl)
    and     1
    ld      c, a
    inc     hl
    jr      kp3
kp2:
    inc     hl
    inc     hl
kp3:
    djnz    kp1
    ld      a, c
    pop     bc
    ld      c, a                        ; the shift state
    pop     hl
    ld      a, e
    rlca
    and     1                           ; 1 if the scancode wants shift
    cp      c
    jr      nz, nokey
    ld      a, e
    and     $3F
    ld      e, a                        ; the row
kp4:
    ld      a, (hl)
    inc     hl
    and     $3F
    cp      e
    jr      nz, kp5
    ld      a, (hl)                     ; its keys (bits 0 to 6)
    and     d
    jr      nz, down
kp5:
    inc     hl
    djnz    kp4
nokey:
    ld      hl, 0
    and     a
    ret
down:
    ld      hl, 1
    scf
    ret
