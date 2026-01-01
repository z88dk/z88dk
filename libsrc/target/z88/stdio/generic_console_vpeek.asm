
    SECTION code_clib

    PUBLIC  generic_console_vpeek

    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_xypos
    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  __console_x
    EXTERN  __console_y
    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out


    INCLUDE "syspar.def"
    INCLUDE "stdio.def"

generic_console_vpeek:
    ld      hl,(generic_console_font32)
    ld      a,h
    or      l
    jr      nz,vpeek_graphics

    ;; Text mode - this doesn't work unfortunatley

    ; Move cursor
    ld      a,1
    call_oz (os_out)
    ld      a,'@'
    call_oz (os_out)
    ld      a,c
    add     32
    call_oz (os_out)
    ld      a,b
    add     32
    call_oz (os_out)

    push    af
    ld      hl,0
    add     hl,sp
    ex      de,hl
    ld      hl,1        ;read 1 character
    ld      bc,nq_rds
    xor     a           ;current window
    call_oz (os_nq)

    ;; Move cursor back
    ld      a,1
    call_oz (os_out)
    ld      a,'@'
    call_oz (os_out)
    ld      a,(__console_x)
    add     32
    call_oz (os_out)
    ld      a,(__console_y)
    add     32
    call_oz (os_out)

    pop     hl
    ld      a,l
    ret


vpeek_graphics:
    call    generic_console_xypos
    ex      de,hl
    ld      hl, -8
    add     hl, sp
    ld      sp, hl
    push    hl                          ;save buffer
    ; de = screen address
    ; hl = buffer
    call    __gfx_vram_page_in
    ex      de, hl
    ld      bc, 8
    ldir
    call    __gfx_vram_page_out
    pop     de                          ;buffer
    ld      hl, (generic_console_font32)
    call    screendollar
    jr      nc, gotit
    ld      hl, (generic_console_udg32)
    ld      b, 128
    call    screendollar_with_count
    jr      c, gotit
    add     128
gotit:
    ex      af, af
    ld      hl, 8
    add     hl, sp
    ld      sp, hl
    ex      af, af
    ret