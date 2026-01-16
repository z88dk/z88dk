; uint in_Inkey(void)
; 07.2025 suborb

; Read current state of keyboard but only return
; keypress if a single key is pressed.

    SECTION code_clib
    PUBLIC  in_Inkey
    PUBLIC  _in_Inkey
    EXTERN  in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL
;

in_Inkey:
_in_Inkey:
    ld      e,0
    in      a,($b0) ;row 0, we have to exclude shift keys
    and     @00011100
    jr      nz,gotkey
    ld      e,8
    in      a,($b1) ;row 1, exclude alt, ctrl
    and     @11001100
    jr      nz,gotkey
    ld      e,16
    ld      b,8
    ld      c,$b2
read_loop:
    in      a,(c)
    and     a
    jr      nz,gotkey
    ld      a,e
    add     8
    ld      e,a
    inc     c
    djnz    read_loop
nokey:
    ld      hl, 0
    scf
    ret

gotkey:
    ; a = key pressed
    ; e = offset
    ld      c, 8
hitkey_loop:
    rlca
    jr      c, doneinc
    inc     e
    dec     c
    jr      nz, hitkey_loop
doneinc:

	; Check for shift and control
    ld      d,0
    in      a,($b0)
    and     @00000011
    ld      bc,80
    jr      nz,got_modifier
    in      a,($b1)
    and     @00000010
    ld      bc,160
    jr      nz,got_modifier
    ld      c, 0
got_modifier:
    ld      hl, in_keytranstbl
    add     hl, bc
    add     hl, de
    ld      a, (hl)
    cp      255
    jr      z, nokey
    ld      l, a
    ld      h, 0
    and     a
    ret


