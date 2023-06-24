
SECTION code_clib

PUBLIC generic_console_vpeek

EXTERN generic_console_xypos
EXTERN generic_console_font32
EXTERN generic_console_udg32
EXTERN screendollar
EXTERN screendollar_with_count


generic_console_vpeek:
    ld      hl,-8
    add     hl,sp        ;de = screen, hl = buffer, bc = coords
    ld      sp,hl
    push    hl          ;Save buffer
    ex      de,hl       ;get it into de
    call    generic_console_xypos
    ld      bc,hl
    ld      l,8
vpeek_row_loop:
    push    hl
    push    de      ;Save buffer
    ld      d,@000000001
    ld      h,0     ;Resultant byte
    ld      a,2     ;We need to do this loop twice
vpeek_loop_2:
    ex      af,af
    ld      e,@11000000
    ld      l,4         ;4 interations
vpeek_loop_3:
    in      a,(c)
    and     e
    jr      z,not_set
    ld      a,h
    or      d
    ld      h,a
not_set:
    sla     d
    srl     e
    srl     e
    dec     l
    jr      nz,vpeek_loop_3
    dec     b       ;decrement x
    ex      af,af
    dec     a
    jr      nz,vpeek_loop_2
    pop     de      ;Buffer
    ld      a,h
    ld      (de),a
    inc     de
    inc     b
    inc     b
    inc     c
    pop     hl
    dec     l
    jr      nz,vpeek_row_loop

do_screendollar:
    pop     de        ;the buffer on the stack
    ld      hl,(generic_console_font32)
    call    screendollar
    jr      nc,gotit
    ld      hl,(generic_console_udg32)
    ld      b,128
    call    screendollar_with_count
    jr      c,gotit
    add     128
gotit:
    ex      af,af        ; Save those flags
    ld      hl,8        ; Dump our temporary buffer
    add     hl,sp
    ld      sp,hl
    ex      af,af        ; Flags and parameter back
    ret
