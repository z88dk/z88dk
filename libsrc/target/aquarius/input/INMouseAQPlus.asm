; Aquarius+ mouse (the ESP32's GETMOUSE command)
;
; Shared code for in_MouseAQPlusInit, in_MouseAQPlus and in_MouseAQPlusSetPos.
;
; The ESP32 answers with the mouse's own position (0..319 by 0..199), or an error if there is no mouse.  What it reports is the mouse's: a program that
; moves the position itself (in_MouseAQPlusSetPos, or keys that move a pointer) would be fought by it, so this keeps its own position and adds the
; mouse's movement since the last answer to it, limited to the screen.
;
; The state is in bss_clib.

    SECTION code_clib
    PUBLIC  INMouseAQPlus
    PUBLIC  _INMouseAQPlus
    PUBLIC  asm_in_MouseAQPlusClamp
    PUBLIC  _in_AQcoordX
    PUBLIC  _in_AQcoordY
    PUBLIC  _in_AQbuttons
    PUBLIC  _in_AQpresent
    PUBLIC  _in_AQvalid
    EXTERN  __esp_send_cmd
    EXTERN  __esp_read_byte

DEFC ESPCMD_GETMOUSE = $0c

; Ask the ESP32 for the mouse once.
; exit : C = buttons 00000MRL (active high; none if there is no mouse)
;        HL = x coordinate (0..319)
;        DE = y coordinate (0..199)
; uses : AF,BC,DE,HL

INMouseAQPlus:
_INMouseAQPlus:
    ld      a, ESPCMD_GETMOUSE
    call    __esp_send_cmd
    call    __esp_read_byte
    and     a
    jr      nz, no_mouse
    call    __esp_read_byte             ; x, low
    ld      e, a
    call    __esp_read_byte             ; x, high
    ld      d, a
    call    __esp_read_byte             ; y
    ld      c, a
    call    __esp_read_byte             ; buttons: left, right, middle
    and     7
    ld      (_in_AQbuttons), a
    call    __esp_read_byte             ; the wheel
    ld      a, 1
    ld      (_in_AQpresent), a
    ld      a, (_in_AQvalid)
    and     a
    jr      nz, moved
    inc     a                           ; the first answer (or the first after none): where the mouse is, not a movement
    ld      (_in_AQvalid), a
    ld      (lastX), de
    ld      a, c
    ld      (lastY), a
    jr      done
moved:
    ld      hl, (lastX)
    ld      (lastX), de
    ex      de, hl                      ; de = the last x, hl = the new
    and     a
    sbc     hl, de
    ld      de, (_in_AQcoordX)
    add     hl, de
    ld      de, 319
    call    asm_in_MouseAQPlusClamp
    ld      (_in_AQcoordX), hl
    ld      a, (lastY)
    ld      e, a
    ld      d, 0
    ld      a, c
    ld      (lastY), a
    ld      l, a
    ld      h, 0
    and     a
    sbc     hl, de
    ld      de, (_in_AQcoordY)
    add     hl, de
    ld      de, 199
    call    asm_in_MouseAQPlusClamp
    ld      (_in_AQcoordY), hl
done:
    ld      a, (_in_AQbuttons)
    ld      c, a
    ld      hl, (_in_AQcoordX)
    ld      de, (_in_AQcoordY)
    ret

no_mouse:
    xor     a
    ld      (_in_AQbuttons), a
    ld      (_in_AQpresent), a
    ld      (_in_AQvalid), a
    jr      done

; Limit hl to 0..de.
; enter : hl = value (signed), de = the limit
; exit  : hl limited
; uses  : AF,HL

asm_in_MouseAQPlusClamp:
    bit     7, h
    jr      z, positive
    ld      hl, 0
    ret
positive:
    ld      a, e
    sub     l
    ld      a, d
    sbc     a, h
    ret     nc
    ex      de, hl
    ret

    SECTION bss_clib
lastX:          defw 0
lastY:          defb 0
_in_AQcoordX:   defw 0
_in_AQcoordY:   defw 0
_in_AQbuttons:  defb 0
_in_AQpresent:  defb 0
_in_AQvalid:    defb 0
