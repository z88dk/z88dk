; int in_MouseSAMInit(void)
; Set the coordinates to (0,0) and look for a mouse.
; Returns non-zero if one was found.  Without one, in_MouseSAM leaves the
; coordinates alone and returns no buttons (it looks again now and then), so
; a program can fall back to the keyboard.

    SECTION code_clib
    PUBLIC  in_MouseSAMInit
    PUBLIC  _in_MouseSAMInit
    PUBLIC  in_MouseSAMPresent
    PUBLIC  _in_MouseSAMPresent
    EXTERN  INMouseSAMDetect
    EXTERN  _in_SAMcoordX, _in_SAMcoordY, _in_SAMbuttons, _in_SAMpresent, _in_SAMretry

in_MouseSAMInit:
_in_MouseSAMInit:
    ld      hl, 0
    ld      (_in_SAMcoordX), hl
    ld      (_in_SAMcoordY), hl
    xor     a
    ld      (_in_SAMbuttons), a
    ld      (_in_SAMpresent), a
    ld      a, 30
    ld      (_in_SAMretry), a
    ld      b, 4                        ; (a held cursor key fails a scan: try again)
init_try:
    push    bc
    call    INMouseSAMDetect
    pop     bc
    ld      a, (_in_SAMpresent)
    or      a
    jr      nz, found
    djnz    init_try
found:
    ld      hl, 0                       ; the detecting scans' movement is discarded
    ld      (_in_SAMcoordX), hl
    ld      (_in_SAMcoordY), hl

; int in_MouseSAMPresent(void)
; Returns non-zero once a mouse has been found.
in_MouseSAMPresent:
_in_MouseSAMPresent:
    ld      a, (_in_SAMpresent)
    ld      l, a
    ld      h, 0
    ret
