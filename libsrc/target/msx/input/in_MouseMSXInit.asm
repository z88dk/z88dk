; int in_MouseMSXInit(int port) __z88dk_fastcall
; Set the coordinates to (0,0) and look for the mouse: port is 1 or 2 for that connector, 0 to look at both (port 1 first).
; Returns the connector the mouse answered in (1 or 2), or 0 if there is none.  Without one, in_MouseMSX leaves the coordinates alone and returns no buttons
; (it looks each time, so a mouse plugged in later is found if the port is the one it is plugged into), so a program can use the keyboard.

    SECTION code_clib
    PUBLIC  in_MouseMSXInit
    PUBLIC  _in_MouseMSXInit
    PUBLIC  in_MouseMSXPresent
    PUBLIC  _in_MouseMSXPresent
    EXTERN  INMouseMSX
    EXTERN  _in_MSXcoordX, _in_MSXcoordY, _in_MSXbuttons, _in_MSXpresent, _in_MSXport

in_MouseMSXInit:
_in_MouseMSXInit:
    ld      a, l
    push    af
    ld      hl, 0
    ld      (_in_MSXcoordX), hl
    ld      (_in_MSXcoordY), hl
    xor     a
    ld      (_in_MSXbuttons), a
    pop     af
    and     a
    jr      nz, one_port
    inc     a                           ; both: port 1 first
    ld      (_in_MSXport), a
    call    INMouseMSX                  ; (the first read drops what the mouse has counted)
    call    INMouseMSX
    ld      a, (_in_MSXpresent)
    and     a
    jr      nz, found
    ld      a, 2
    jr      try
one_port:
    cp      2
    jr      z, try
    ld      a, 1
try:
    ld      (_in_MSXport), a
    call    INMouseMSX
    call    INMouseMSX
    ld      a, (_in_MSXpresent)
    and     a
    jr      nz, found
    ld      hl, 0
    ld      (_in_MSXcoordX), hl
    ld      (_in_MSXcoordY), hl
    ld      l, a
    ld      h, 0
    ret
found:
    ld      hl, 0                       ; (what the reads moved is not wanted)
    ld      (_in_MSXcoordX), hl
    ld      (_in_MSXcoordY), hl
    ld      a, (_in_MSXport)
    ld      l, a
    ld      h, 0
    ret

; int in_MouseMSXPresent(void)
; Returns non-zero if the last read found a mouse.
in_MouseMSXPresent:
_in_MouseMSXPresent:
    ld      a, (_in_MSXpresent)
    ld      l, a
    ld      h, 0
    ret
