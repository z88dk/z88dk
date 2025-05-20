; Handle the VBL interrupt
int_VBL:
    ld      hl, timer
    ld      a, (hl)
    inc     a
    ld      (hl), a
    inc     hl
    ld      a, (hl)
    adc     a, 1
    ld      (hl), a         ;Increments the timer

    ld      hl, raster_procs
    call    int_handler
    pop     hl
    pop     af
    ei
    reti

; Handler for the user interrupt code

int_handler:
    push    bc
    push    de
int_loop:
    ld      a, (hl)
    inc     hl
    or      (hl)
    jr      z, int_done
    push    hl
    ld      a, (hl)
    dec     hl
    ld      l, (hl)
    ld      h, a
    call    l_dcal
    pop     hl
    inc     hl
    jr      int_loop
int_done:
    pop     de
    pop     bc
    ret
