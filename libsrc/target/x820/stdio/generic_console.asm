
;
; Page in to 0x3000
; Each row is 128 bytes
; Port $14 = scroll register


    ; code_driver is low memory - we need to be below 0x3000
    SECTION code_graphics

    PUBLIC  generic_console_cls
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_ioctl

    EXTERN  CONSOLE_COLUMNS
    EXTERN  CONSOLE_ROWS
    EXTERN  l_push_di
    EXTERN  l_pop_ei

    defc    DISPLAY = 0x3000

    PUBLIC  CLIB_GENCON_CAPS
    defc    CLIB_GENCON_CAPS = 0x00

generic_console_ioctl:
    scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
    ret

generic_console_cls:
    call    l_push_di
    call    vram_enable
    ld      hl,DISPLAY
    ld      de,DISPLAY+1
    ld      bc,32 * 128
    ld      (hl),32
    ldir
    call    vram_disable
    call    l_pop_ei
    ret

generic_console_printc:
    ld      e,a
    call    xypos
    call    l_push_di
    call    vram_enable
    ld      (hl),e
    call    vram_disable
    call    l_pop_ei
    ret

generic_console_vpeek:
    call    xypos
    call    l_push_di
    call    vram_enable
    ld      e,(hl)
    call    vram_disable
    call    l_pop_ei
    ld      a,e
    and     a
    ret

generic_console_scrollup:
    push	bc
    push	de
    call    l_push_di
    call    vram_enable
    ld      c,CONSOLE_ROWS
    ld      hl,$3080    ;Row1
    ld      de,128  ;Characters in row
row_loop:
    ld      b,128
char_loop:
    push    hl
    ld      a,(hl)
    and     a
    sbc     hl,de
    ld      (hl),a
    pop     hl
    inc     hl
    djnz    char_loop
    dec     c
    jr      nz,row_loop
    and     a
    sbc     hl,de       ;hl = start of last row
    ld      b,CONSOLE_COLUMNS
    ld      a,' '
clear_loop:
    ld      (hl),a
    inc     hl
    djnz    clear_loop
    call    vram_disable
    call    l_pop_ei
    pop     de
    pop     bc
    ret


; b = y
; c  = x
; Exit: hl = address
xypos:
    ld      h,b     ;row *128
    ld      l,0
    srl     h
    rr      l
    ld      b, +(DISPLAY / 256)
    add     hl,bc
    ret


vram_enable:
    in a,($1C)    ; syspio: get pio status
    set 7,a       ; set crt bank enable
    out ($1C),a   ; syspio
    ret


vram_disable:
    in a,($1C)    ; syspio: get pio status
    res 7,a       ; reset crt bank enable
    out ($1C),a   ; syspio
    ret

    SECTION code_crt_init

    ; Reset the scroll register
    ld      a,0xff
    out     ($14),a

    EXTERN          __BSS_END_tail
    EXTERN          __HIMEM_head
    EXTERN          __HIMEM_END_tail

    ld      hl,__BSS_END_tail
    ld      de,__HIMEM_head
    ld      bc,__HIMEM_END_tail - __HIMEM_head
    ldir

