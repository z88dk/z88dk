
    MODULE in_Inkey
    PUBLIC in_Inkey
    PUBLIC _in_Inkey
    EXTERN in_keytranstbl


; write line to port 0x40
; read first 8 rows form 0x41
; read second 8 rows form 0x42
;
; We have 128 characters per set...


in_Inkey:
_in_Inkey:
    ld      hl,ignore_keys
    ld      c,@11111110
    ld      b,8
    ld      de,0
loop1:
    ld      a,c
    out     ($40),a
    in      a,($41)
    or      (hl)
    cp      255
    jr      nz,got_key
    ; Now look at the second set of keys
    inc     hl
    ld      a,64
    add     e
    ld      e,a
    in      a,($42)
    or      (hl)
    cp      255
    jr      nz,got_key
    inc     hl
    ld      a,-56
    add     e
    ld      e,a
    scf
    rlc     c
    djnz    loop1
nokey:
    ld      hl,0
    scf
    ret

got_key:
    rrca
    jr      nc,rotate_complete
    inc     e
    jr      got_key
    ; e = offset within table
rotate_complete:
    ; TODO: Check for modifiers
    ld      bc,0
    ld      a,@11111110
    out     ($40),a
    in      a,($41)
    bit     6,a
    jr      nz,check_rshift
    ld      bc,128
check_rshift:
    ld      a,@11101111
    out     ($40),a
    in      a,($41)
    rlca
    jr      c,check_ctrl
    ld      bc,128
check_ctrl:
    ld      a,@11111101
    out     ($40),a
    in      a,($42)
    rrca
    jr      c,getkey
    ld      bc,256
getkey:
    ld      hl,in_keytranstbl
    add     hl,bc
    add     hl,de
    ld      a,(hl)
    cp      255
    jr      z,nokey
    ld      l,a
    ld      h,0
    and     a
    ret

    SECTION rodata_clib

; Keys that we should ignore when scanning 
; initially. This is typically modifiers that we ignore
ignore_keys:
    defb    @01000000       ;Row 0
    defb    @11111000       ;Row 8
    defb    @00000000       ;Row 1
    defb    @11111001       ;Row 9
    defb    @00000000       ;Row 2
    defb    @11111000       ;Row 10
    defb    @00000000       ;Row 3
    defb    @11111000       ;Row 11
    defb    @10000000       ;Row 4
    defb    @11111110       ;Row 12
    defb    @00000000       ;Row 5
    defb    @11111110       ;Row 13
    defb    @00000000       ;Row 6
    defb    @11111110       ;Row 14
    defb    @10000000       ;Row 7
    defb    @11111110       ;Row 15
