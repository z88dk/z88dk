;
; Scroll the console up a line (8 lines of pixels), a plane at a time (the write format and the read format name the plane), and clear the bottom line to the paper pen
; (one replace write: the planes of the pen get 1s, the others 0)
;
    SECTION code_driver
    PUBLIC  generic_console_scrollup
    EXTERN  __mz800_con_paper
    EXTERN  l_push_di
    EXTERN  l_pop_ei

generic_console_scrollup:
    push    de
    push    bc
    ld      a, (__mz800_con_paper)
    and     3
    or      $80
    exx
    ld      e, a                        ; e' = the write format of the clear
    exx
    call    l_push_di
    in      a, ($e0)                    ; the video RAM in
    ld      a, 1                        ; the plane
scroll_plane:
    push    af
    out     ($cc), a                    ; write plane a only (single write)
    out     ($cd), a                    ; read plane a
    ld      hl, $8000 + 320
    ld      de, $8000
    ld      bc, 24 * 320
    ldir
    pop     af
    add     a, a
    cp      4
    jr      nz, scroll_plane
    exx
    ld      a, e
    exx
    out     ($cc), a
    ld      hl, $8000 + 24 * 320
    ld      bc, 320
    ld      a, $ff
clear_line:
    ld      (hl), a
    inc     hl
    dec     bc
    ld      d, a
    ld      a, b
    or      c
    ld      a, d
    jr      nz, clear_line
    in      a, ($e1)
    call    l_pop_ei
    pop     bc
    pop     de
    ret
