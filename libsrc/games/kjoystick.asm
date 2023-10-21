;
;
; uint8_t kjoystick(uint8_t keys[6]) __z88dk_fastcall

; Keys are ordered: RIGHT, LEFT, DOWN, UP, FIRE1, FIRE2, FIRE3, FIRE4
; Terminated by \0

        MODULE  kjoystick

        SECTION code_clib
        PUBLIC  kjoystick
        PUBLIC  _kjoystick

        EXTERN  in_LookupKey
        EXTERN  in_KeyPressed


kjoystick:
_kjoystick:
        ld      b, 8
        ld      de, $0001
loop:
        ld      a, (hl)
        and     a
        jr      z, finished
        push    bc
        inc     hl
        push    hl
	; Map to a keycode
        ld      l, a
        push    de                      ;Save result + masks
        call    in_LookupKey            ;This is inefficient, we should do better
        jr      c, nokeys
        call    in_KeyPressed
        pop     de
        jr      nc, continue
        ld      a, d
        or      e
        ld      d, a
continue:
  IF    __CPU_INTEL__
        ld      a, e
        and     a
        rla
        ld      e, a
  ELSE
        sla     e                       ;Shift mask across
  ENDIF
        pop     hl
        pop     bc
        djnz    loop
finished:
        ld      l, d
        ld      h, 0
        ret
nokeys:
        pop     de
        jr      continue
