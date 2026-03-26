

IF FORzxn
    MODULE  generic_console_zxn_layer2

    SECTION code_clib

    PUBLIC  generic_console_zxn_layer2_cls
    PUBLIC  generic_console_zxn_layer2_scrollup
    PUBLIC  generic_console_zxn_layer2_printc

    EXTERN  CLIB_BANKING_SEGMENT
    EXTERN  CLIB_ZXN_LAYER2_BASE
    EXTERN  __IO_NEXTREG_REG
    EXTERN  __zxn_ink_colour
    EXTERN  __zxn_paper_colour

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
    add     CLIB_ZXN_LAYER2_BASE
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
    ret


set_mmu:
   nextreg banking_mmu_low, a
   inc a
set_mmu_no_rom:
   nextreg banking_mmu_high, a
   ret

ENDIF