
;
; Pixel operation for MODE0,1,2
;

IF FORzxn

    EXTERN  __gfx_coords
    EXTERN  CLIB_BANKING_SEGMENT
    EXTERN  __CLIB_ZXN_LAYER2_BASE
    EXTERN  __IO_NEXTREG_REG
    EXTERN  __zxn_ink_colour
    EXTERN  __zxn_paper_colour

    defc banking_mmu_low = 80 + CLIB_BANKING_SEGMENT * 2
    defc banking_mmu_high = 81 + CLIB_BANKING_SEGMENT * 2


; We enter here with: hl = x, de = y
    ld      a, h
    or      d
    ret     nz
    ld      a, e
    cp      192
    ret     nc
    ld      (__gfx_coords), hl
    ld      (__gfx_coords+2), de
    push    bc              ;Save callers

    ; Now get them into 8 bit parameters
    ld      h, e

    ; hl = address (0->0xbfff) of the pixel to set
    ld      a,banking_mmu_low
    ld      bc, __IO_NEXTREG_REG 
    out     (c), a                 ; set next register
    inc     b                      ; IO_NEXTREG_DATA
    in      e, (c)                  ; read current memory bank
    ; e = previous bank

    ; Page in the right segment of the screen
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

    ; So here we have hl=screen location
IF  NEEDplot
    ld      a,(__zxn_ink_colour)
    ld      (hl),a
ENDIF
IF  NEEDunplot
    ld      a,(__zxn_paper_colour)
    ld      (hl),a
ENDIF
IF  NEEDxor
    ld      a,(__zxn_ink_colour)
    xor     (hl)
    ld      (hl), a
ENDIF
IF  NEEDpoint
    ld      a,(hl)
    and     a
    push    af
ENDIF

    ld      a,e
    call    set_mmu

IF NEEDpoint
    pop     af
ENDIF

    pop     bc                          ;Restore callers
    ret


set_mmu:
   nextreg banking_mmu_low, a
   inc a
   nextreg banking_mmu_high, a
   ret


ENDIF