; int in_MouseAQPlusInit(void)
; Set the coordinates to (0,0) and ask for the mouse.
; Returns non-zero if the ESP32 has one.  Without one, in_MouseAQPlus leaves the coordinates alone and returns no buttons (it asks again each time, so a
; mouse plugged in later is found), so a program can use the keyboard.

    SECTION code_clib
    PUBLIC  in_MouseAQPlusInit
    PUBLIC  _in_MouseAQPlusInit
    PUBLIC  in_MouseAQPlusPresent
    PUBLIC  _in_MouseAQPlusPresent
    EXTERN  INMouseAQPlus
    EXTERN  _in_AQcoordX, _in_AQcoordY, _in_AQbuttons, _in_AQpresent, _in_AQvalid

in_MouseAQPlusInit:
_in_MouseAQPlusInit:
    ld      hl, 0
    ld      (_in_AQcoordX), hl
    ld      (_in_AQcoordY), hl
    xor     a
    ld      (_in_AQbuttons), a
    ld      (_in_AQvalid), a
    call    INMouseAQPlus               ; (the first answer is where the mouse is, and no movement)

; int in_MouseAQPlusPresent(void)
; Returns non-zero if the last answer was a mouse.
in_MouseAQPlusPresent:
_in_MouseAQPlusPresent:
    ld      a, (_in_AQpresent)
    ld      l, a
    ld      h, 0
    ret
