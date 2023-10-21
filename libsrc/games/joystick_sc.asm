;
;
; uint8_t joystick_sc(uint16_t keys[...]) __z88dk_fastcall

; Keys are ordered: RIGHT, LEFT, DOWN, UP, FIRE1, FIRE2, FIRE3, FIRE4
; Terminated by \0
;
; Uses scancodes

        MODULE  joystick_sc

        SECTION code_clib
        PUBLIC  joystick_sc
        PUBLIC  _joystick_sc

        EXTERN  in_LookupKey
        EXTERN  in_KeyPressed


joystick_sc:
_joystick_sc:
        ld      b, 8
        ld      de, $0001
loop:
        push    bc
        ld      c, (hl)
        inc     hl
        ld      b, (hl)
        inc     hl
        ld      a, c
        or      b
        jr      z, finished
        push    hl
        ld      l, c
        ld      h, b
        push    de
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
        ld      l, d
        ld      h, 0
        ret
finished:
        pop     bc
        ld      l, d
        ld      h, 0
        ret
