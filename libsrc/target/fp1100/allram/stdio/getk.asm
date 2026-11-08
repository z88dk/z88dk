; getk for the all-RAM console: the sub program's Keys command (rows of the key matrix with a key down) turned into ASCII.  No interrupt, no buffer:
; a key is returned while it is down (the caller does its own repeat), the first found if several are.  Returns Enter as 10 (13 without STANDARDESCAPECHARS), the cursor keys as 8 (left), 9, 10 (down) and 11 (up), 12 (BS and DEL: CRT_KEY_DEL) and 32 to 126, 0 for no key, and:
; shift and CAPS: letters take shift xor caps, the others shift; CTRL with a letter or [ \ ] ^ _: 1 to 31; BREAK 27 (with CTRL 3); PF0 to PF9 and STOP/CONT
; 128 to 138;   GRAPH and KANA, INS and HOME give 0.

    MODULE  fp1100_allram_getk
    SECTION code_clib
    PUBLIC  getk
    PUBLIC  _getk
    PUBLIC  fp1100_keys
    PUBLIC  fp1100_keybuf
    EXTERN  in_keytranstbl
    EXTERN  in_keytranstbl_shift
    EXTERN  fp1100_sub_send
    EXTERN  fp1100_sub_read

    INCLUDE "../sub/sub.inc"

; Ask the sub program for the keys: fp1100_keybuf = the count of rows, then a pair for each (row | $40 if bit 7 is set, the keys' bits 0 to 6).
fp1100_keys:
    ld      a, SUB_KEYS
    call    fp1100_sub_send
    call    fp1100_sub_read
    ld      (fp1100_keybuf), a
    add     a, a
    ret     z
    ld      b, a
    ld      hl, fp1100_keybuf + 1
fk1:
    call    fp1100_sub_read
    ld      (hl), a
    inc     hl
    djnz    fk1
    ret

getk:
_getk:
    call    fp1100_keys
    ld      a, (fp1100_keybuf)
    and     a
    jp      z, nokey
    ld      b, a                        ; rows with a key down
    ld      hl, fp1100_keybuf + 1
    ld      c, 0                        ; the modifiers (row 1), bit 7 = BREAK
    ld      de, 0                       ; d = row byte of the first key ($40 if its bit 7 is set), e = its bits 0 to 6
fg1:
    ld      a, (hl)
    inc     hl
    cp      1
    jr      z, fgm
    cp      $41
    jr      nz, fg2
    set     7, c                        ; row 1, bit 7: BREAK
fgm:
    ld      a, (hl)                     ; row 1: shift $01, CTRL $02, GRAPH $04, CAPS $08, KANA $10
    or      c
    ld      c, a
    jr      fg3
fg2:
    ld      a, d
    and     a
    jr      nz, fg3                     ; (the first key found is the one)
    dec     hl
    ld      d, (hl)
    inc     hl
    ld      e, (hl)
fg3:
    inc     hl
    djnz    fg1
    bit     7, c
    jr      z, fg9
    ld      a, 27                       ; BREAK is escape, with CTRL 3
    bit     1, c
    jp      z, done
    ld      a, 3
    jp      done
fg9:
    ld      a, d
    and     a
    jp      z, nokey
    and     $3F
    sub     2                           ; row 2 to 12: 0 to 10
    ld      b, a
    ld      a, e
    and     $7F
    jr      nz, fgk
    bit     6, d                        ; a bit 7 key alone: PF0 to PF9 and STOP/CONT are 128 to 138
    jp      z, nokey
    ld      a, b
    add     a, 128
    jr      done
fgk:
    ld      e, a
    ld      a, b
    add     a, a
    add     a, a
    add     a, a
    sub     b                           ; row * 7
    ld      b, a
    ld      a, e
    ld      d, 0                        ; the lowest bit set in bits 0 to 6
fg4:
    rra
    jr      c, fg5
    inc     d
    jr      fg4
fg5:
    ld      a, b
    add     a, d
    ld      e, a
    ld      d, 0
    ld      hl, in_keytranstbl
    bit     1, c                        ; (CTRL: the plain table)
    jr      nz, fg6
    bit     0, c
    jr      z, fg6
    ld      hl, in_keytranstbl_shift
fg6:
    add     hl, de
    ld      a, (hl)
    and     a
    jp      z, nokey
    cp      127                         ; DEL is a backspace too
    jr      nz, fgd
    ld      a, 12
    jr      done
fgd:
    bit     1, c                        ; CTRL: a letter or [ \ ] ^ _ is a control code
    jr      z, fgc
    ld      b, a
    and     $DF
    sub     $41
    cp      31
    ld      a, b
    jr      nc, fgn
    and     $1F
    jr      done
fgc:
    bit     3, c                        ; CAPS swaps the case of letters
    jr      z, fg7
    ld      b, a
    or      $20
    cp      'a'
    jr      c, fg8
    cp      'z' + 1
    jr      nc, fg8
    ld      a, b
    xor     $20
    jr      fg7
fg8:
    ld      a, b
fg7:
    cp      32
    jr      nc, fgp
    cp      8                           ; the control codes: the cursor keys 8 to 11, BS 12, Enter 13
    jp      c, nokey
    cp      14
    jp      nc, nokey
fgn:
  IF    STANDARDESCAPECHARS
    cp      13                          ; Enter is \n (10) as the library's own character set has it
    jr      nz, done
    ld      a, 10
  ENDIF
    jr      done
fgp:
    cp      127
    jp      nc, nokey
done:
    ld      l, a
    ld      h, 0
    ret
nokey:
    ld      hl, 0
    ret

    SECTION bss_clib
fp1100_keybuf:
    defs    1 + 2 * 12
