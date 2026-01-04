; Generic console/vt52 driver for the z88
;
; If generic_console_font32 == 0 then use the OZ screen driver
; 


    MODULE  generic_console

    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_flags

    PUBLIC  generic_console_printc
    PUBLIC  generic_console_cls
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper    
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_xypos

    EXTERN  base_graphics
    EXTERN  __z88_gfxmode

    EXTERN  CONSOLE_ROWS
    EXTERN  __console_h
    EXTERN  __console_w
    EXTERN  clg

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

    INCLUDE "syspar.def"
    INCLUDE "stdio.def"

generic_console_set_ink:
generic_console_set_paper:
    ret

generic_console_set_attribute:
    ld      hl,(generic_console_font32)
    ld      a,h
    or      l
    ret     nz
    call    query_window
    ld      a,(generic_console_flags)
    ld      hl,boldon
    ld      de,boldoff
    bit     4,a
    call    doattr
    ld      hl,underon
    ld      de,underoff
    bit     3,a
    call    doattr
    ld      hl,inverseon
    ld      de,inverseoff
    bit     7,a
doattr:
    jr      z,turnoff
    call_oz (gn_sop)
    ret
turnoff:
    ex      de,hl
    call_oz (gn_sop)
    ret


generic_console_cls:
    ld      hl,(generic_console_font32)
    ld      a,h
    or      l
    jp      nz,clg
    ld      a,$0c
    call_oz (os_out)
    ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
    ld      hl,(generic_console_font32)
    ld      a,h
    or      l
    jp      nz,printc_graphics
    ld      hl, start
    call_oz (gn_sop)
    ld      a,c
    add     a, 32
    call_oz (os_out)
    ld      a,b
    add     a, 32
    call_oz (os_out)
    ld      a,d
    call_oz (os_out)
    ret


generic_console_scrollup:
    ld      hl,(generic_console_font32)
    ld      a,h
    or      l
    jp      nz,scrollup_graphics
    ld      hl,scroll
    call_oz (gn_sop)
    ret


printc_graphics:
    call    __gfx_vram_page_in
    push    de
    call    generic_console_xypos
    pop     de
    ld      a,d
    ex      de,hl                   ;de = screen
    ld      bc, (generic_console_font32)
    bit     7, a
    jr      z, not_udg
    ld      bc, (generic_console_udg32)
    res     7, a
    inc     b
not_udg:
    ld      l, a
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, bc
    dec     h
    ex      de, hl                      ;hl = screen, de = font
    ld      a, (generic_console_flags)
    rlca
    sbc     a
    ld      c, a                        ;c = 0 / c = 255
    ld      b, 8
printc_hires_loop:
    push    bc
    ld      a, (generic_console_flags)
    bit     4, a
    ld      a, (de)
    ld      b, a
    jr      z, not_bold
    rrca
    or      b
not_bold:
    xor     c
    ld      (hl), a
    inc     de
    inc     hl
    pop     bc
    djnz    printc_hires_loop
    ld      a, (generic_console_flags)
    bit     3, a
    jr      z,printc_return
    dec     hl
    ld      (hl), 255
printc_return:
    call    __gfx_vram_page_out
    ret
    
scrollup_graphics:
    push    bc
    push    de
    call    __gfx_vram_page_in
    ld      bc,256
    ld      a,(__z88_gfxmode)
    and     a
    jr      z,not_512_scrollup
    ld      bc,512
not_512_scrollup:
    ld      hl,(base_graphics)
    ld      de,hl
    add     hl,bc
    ld      a,CONSOLE_ROWS - 1
scrollup_loop:
    push    bc
    ldir
    pop     bc
    dec     a
    jr      nz,scrollup_loop
    ; de now points to the. bottom row
    ex      de,hl
    ld      de,hl
    inc     de
    ld      (hl),0
    dec     bc
    ldir
    call    __gfx_vram_page_out
    pop     de
    pop     bc
    ret


; b = y
; c = x
; exit: hl = character
generic_console_xypos:
    ld      l,c
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    ex      de,hl
    ld      h,b     ;* 256
    ld      l,0
    ld      a,(__z88_gfxmode)
    and     a
    jr      z,not_512_screen
    add     hl,hl
not_512_screen:
    add     hl,de
    ld      de,(base_graphics)
    add     hl,de
    ret



; Query the size of the window and keep sizes updated
;
; The user might select a different window beyond our control
query_window:
    ld      hl,(generic_console_font32)
    ld      a,h
    or      l
    ret     nz
    ld      bc,nq_wbox
    call_oz (os_nq)
    ld      a,c
    ld      (__console_w),a
    ld      a,b
    ld      (__console_h),a
    ret



    SECTION rodata_clib
start:
    defb    1, '3', '@', 0

scroll:
    defb    1,SD_DWN,0

boldon:
    defb    1, '2', '+', 'B', 0

boldoff:
    defb    1, '2', '-', 'B', 0

underon:
    defb    1, '2', '+', 'U', 0

underoff:
    defb    1, '2', '-', 'U', 0

inverseon:
    defb    1, '2', '+', 'R', 0
inverseoff:
    defb    1, '2', '-', 'R', 0


