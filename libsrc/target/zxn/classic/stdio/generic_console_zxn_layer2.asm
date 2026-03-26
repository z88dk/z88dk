

IF FORzxn
    MODULE  generic_console_zxn_layer2

    SECTION code_clib

    PUBLIC  generic_console_zxn_layer2_cls
    PUBLIC  generic_console_zxn_layer2_scrollup
    PUBLIC  generic_console_zxn_layer2_printc

    EXTERN  CLIB_BANKING_SEGMENT
    EXTERN  __CLIB_ZXN_LAYER2_BASE
    EXTERN  __IO_NEXTREG_REG
    EXTERN  __zxn_ink_colour
    EXTERN  __zxn_paper_colour
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  generic_console_flags

    defc banking_mmu_low = 80 + CLIB_BANKING_SEGMENT * 2
    defc banking_mmu_high = 81 + CLIB_BANKING_SEGMENT * 2


generic_console_zxn_layer2_cls:
    ; hl = address (0->0xbfff) of the pixel to set
    ld      a,banking_mmu_low
    ld      bc, __IO_NEXTREG_REG 
    out     (c), a                 ; set next register
    inc     b                      ; IO_NEXTREG_DATA
    in      a, (c)                  ; read current memory bank
    push    af
    ld      c,0
    ld      b,3
cls_loop:
    push    bc
    ; Page in the right segment of the screen
    ld      a,c
    add     a
    add     __CLIB_ZXN_LAYER2_BASE
    call    set_mmu
     
    ld      hl, +(CLIB_BANKING_SEGMENT << 14)
    ld      de,hl
    inc     de
    ld      bc,16383
    ld      a,(__zxn_paper_colour)
    ld      (hl),a
    ldir
    pop     bc
    inc     c
    djnz    cls_loop

    ;; Restore paging
    pop     af
    call    set_mmu
    pop     bc
    pop     de
    ret


generic_console_zxn_layer2_scrollup:
    ;; Not going to implement this
    ret


generic_console_zxn_layer2_printc:

    ld      a, d                        ;save character
    exx
    ld      bc, (generic_console_font32)
    dec     b
    bit     7, a
    jr      z, handle_characters
    ld      bc, (generic_console_udg32)
    res     7, a
handle_characters:
    ld      l, a
    ld      h, 0
    add     hl, hl
    add     hl, hl
    add     hl, hl
    add     hl, bc
    ld      a, (generic_console_flags)
    ld      b, a
    rlca
    sbc     a, a                        ; ; c = 0/ c = 255
    ld      c, a
    exx
    ; bc = b = y, c = x, coordinates to print at
    ; hl' = font
    ; c' = inverse flag
    ; b' = flags
    call    layer2_xypos
    ;hl = adddress
    ;a = old bank
    push    af                          ;save bank     


    ld      b, 8                        ;8 rows
printc_1:
    push    bc
    ld      a, b
    exx
    bit     3, b
    jr      z, printc_no_underline
    cp      1
    jr      nz, printc_no_underline
    ld      a, 255
    jr      printc_not_bold
printc_no_underline:
    ld      a, (hl)
    bit     4, b
    jr      z, printc_not_bold
    rrca
    or      (hl)
printc_not_bold:
    xor     c
    inc     hl
    exx
    ex      af, af

    ld      de, (__zxn_ink_colour)      ;e = ink, d = paper
    ld      a, 8
printc_2:
    ex      af, af
    rlca                                ;Do we need ink or paper?
    ld      c, a                        ;Save character
    ld      a, d
    jr      nc, printc_is_paper
    ld      a, e                        ;ink
printc_is_paper:
    ld      (hl), a
    inc     hl
    ld      a, c
    ex      af, af
    dec     a
    jp      nz, printc_2

    ld      de, 256 - 8
    add     hl, de
    pop     bc
    djnz    printc_1

    pop     af
    call    set_mmu
    ret

; Entry: b = y, c = x
; Exit:  hl = address, a = previous bank
;
; Deals with paging as well for us
layer2_xypos:
    push    bc
    ld      a,banking_mmu_low
    ld      bc, __IO_NEXTREG_REG 
    out     (c), a                 ; set next register
    inc     b                      ; IO_NEXTREG_DATA
    in      e, (c)                  ; read current memory bank
    pop     bc

    ld      a,b
    add     a
    add     a
    add     a
    ld      h, a
    ld      a,c
    add     a
    add     a
    add     a
    ld      l, a
    ; ATP: hl = offset within the layer2 screen (0->0xbffff
    ; Now, convert this into 

    ld      a,h
    rlca
    rlca
    rlca
    and     @00000110
    add     __CLIB_ZXN_LAYER2_BASE
    call    set_mmu

    ; Rebase the address to 0->0x3fff
    res     7,h
    res     6,h
    ld      a,+(CLIB_BANKING_SEGMENT<<6)
    or      h
    ld      h,a

    ld      a,e
    ret


set_mmu:
   nextreg banking_mmu_low, a
   inc a
set_mmu_no_rom:
   nextreg banking_mmu_high, a
   ret

ENDIF