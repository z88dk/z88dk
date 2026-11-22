;
;  feilipu, 2019 May
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; REPLICATION for Z80 of:
; Z180 MLT DE and Z80-ZXN MUL DE
;
;------------------------------------------------------------------------------

SECTION code_clib
SECTION code_math

PUBLIC l_fast_mulu_de

.l_fast_mulu_de

    ; Fast mulu_16_8x8 using a 512 byte table
    ;
    ; x*y = ((x+y)/2)2 - ((x-y)/2)2           <- if x+y is even 
    ;     = ((x+y-1)/2)2 - ((x-y-1)/2)2 + y   <- if x+y is odd and x>=y
    ;
    ; enter : d = 8-bit multiplicand
    ;         e = 8-bit multiplicand
    ;
    ; exit  : de = 16-bit product

    push af

    ld a,d                  ; put largest in d
    cp e
    jr NC,lnc
    ld d,e
    ld e,a

.lnc                        ; with largest in d
    xor a
    or e
    jr Z,lzeroe             ; multiply by 0

    push bc

    ld b,d                  ; keep larger -> b
    ld c,e                  ; keep smaller -> c

    ld a,d
    sub e
    rra
    ld d,a                  ; (x-y)/2 -> d

    ld a,b
    add a,c
    rra                     ; check for odd/even

    push hl                 ; preserve hl

    ld l,a                  ; (x+y)/2 -> l
    ld h,sqrlo/$100         ; loads sqrlo page
    ld a,(hl)               ; LSB ((x+y)/2)2 -> a
    ld e,l                  ; (x+y)/2 -> e
    ld l,d                  ; (x-y)/2 -> l (for index)
    jr NC,leven
                            ; odd tail
    sub (hl)                ; LSB ((x+y)/2)2 - ((x-y)/2)2
    ld l,e                  ; (x+y)/2 -> l
    ld e,a                  ; LSB ((x+y)/2)2 - ((x-y)/2)2 -> e
    inc h                   ; loads sqrhi page
    ld a,(hl)               ; MSB ((x+y)/2)2 -> a
    ld l,d                  ; (x-y)/2 -> l
    sbc a,(hl)              ; MSB ((x+y)/2)2 - ((x-y)/2)2 -> a
    ld d,a                  ; MSB ((x+y)/2)2 - ((x-y)/2)2 -> d

    ld a,e
    add a,c                 ; add smaller y
    ld e,a
    ld a,d
    adc a,0
    ld d,a

    pop hl
    pop bc
    pop af
    ret

.leven                      ; even tail
    sub (hl)                ; LSB ((x+y)/2)2 - ((x-y)/2)2
    ld l,e                  ; (x+y)/2 -> l
    ld e,a                  ; LSB ((x+y)/2)2 - ((x-y)/2)2 -> e
    inc h                   ; loads sqrhi page
    ld a,(hl)               ; MSB ((x+y)/2)2 -> a
    ld l,d                  ; (x-y)/2 -> l
    sbc a,(hl)              ; MSB ((x+y)/2)2 - ((x-y)/2)2 -> a
    ld d,a                  ; MSB ((x+y)/2)2 - ((x-y)/2)2 -> d

    pop hl
    pop bc
    pop af
    ret

.lzeroe
    pop af
    ld d,e
    ret


SECTION rodata_align_256

ALIGN $100

.sqrlo ;low(x*x) should located on the page border
    defb $00,$01,$04,$09,$10,$19,$24,$31,$40,$51,$64,$79,$90,$a9,$c4,$e1
    defb $00,$21,$44,$69,$90,$b9,$e4,$11,$40,$71,$a4,$d9,$10,$49,$84,$c1
    defb $00,$41,$84,$c9,$10,$59,$a4,$f1,$40,$91,$e4,$39,$90,$e9,$44,$a1
    defb $00,$61,$c4,$29,$90,$f9,$64,$d1,$40,$b1,$24,$99,$10,$89,$04,$81
    defb $00,$81,$04,$89,$10,$99,$24,$b1,$40,$d1,$64,$f9,$90,$29,$c4,$61
    defb $00,$a1,$44,$e9,$90,$39,$e4,$91,$40,$f1,$a4,$59,$10,$c9,$84,$41
    defb $00,$c1,$84,$49,$10,$d9,$a4,$71,$40,$11,$e4,$b9,$90,$69,$44,$21
    defb $00,$e1,$c4,$a9,$90,$79,$64,$51,$40,$31,$24,$19,$10,$09,$04,$01
    defb $00,$01,$04,$09,$10,$19,$24,$31,$40,$51,$64,$79,$90,$a9,$c4,$e1
    defb $00,$21,$44,$69,$90,$b9,$e4,$11,$40,$71,$a4,$d9,$10,$49,$84,$c1
    defb $00,$41,$84,$c9,$10,$59,$a4,$f1,$40,$91,$e4,$39,$90,$e9,$44,$a1
    defb $00,$61,$c4,$29,$90,$f9,$64,$d1,$40,$b1,$24,$99,$10,$89,$04,$81
    defb $00,$81,$04,$89,$10,$99,$24,$b1,$40,$d1,$64,$f9,$90,$29,$c4,$61
    defb $00,$a1,$44,$e9,$90,$39,$e4,$91,$40,$f1,$a4,$59,$10,$c9,$84,$41
    defb $00,$c1,$84,$49,$10,$d9,$a4,$71,$40,$11,$e4,$b9,$90,$69,$44,$21
    defb $00,$e1,$c4,$a9,$90,$79,$64,$51,$40,$31,$24,$19,$10,$09,$04,$01
.sqrhi ;high(x*x) located on next page (automatically)
    defb $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
    defb $01,$01,$01,$01,$01,$01,$01,$02,$02,$02,$02,$02,$03,$03,$03,$03
    defb $04,$04,$04,$04,$05,$05,$05,$05,$06,$06,$06,$07,$07,$07,$08,$08
    defb $09,$09,$09,$0a,$0a,$0a,$0b,$0b,$0c,$0c,$0d,$0d,$0e,$0e,$0f,$0f
    defb $10,$10,$11,$11,$12,$12,$13,$13,$14,$14,$15,$15,$16,$17,$17,$18
    defb $19,$19,$1a,$1a,$1b,$1c,$1c,$1d,$1e,$1e,$1f,$20,$21,$21,$22,$23
    defb $24,$24,$25,$26,$27,$27,$28,$29,$2a,$2b,$2b,$2c,$2d,$2e,$2f,$30
    defb $31,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f
    defb $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f
    defb $51,$52,$53,$54,$55,$56,$57,$59,$5a,$5b,$5c,$5d,$5f,$60,$61,$62
    defb $64,$65,$66,$67,$69,$6a,$6b,$6c,$6e,$6f,$70,$72,$73,$74,$76,$77
    defb $79,$7a,$7b,$7d,$7e,$7f,$81,$82,$84,$85,$87,$88,$8a,$8b,$8d,$8e
    defb $90,$91,$93,$94,$96,$97,$99,$9a,$9c,$9d,$9f,$a0,$a2,$a4,$a5,$a7
    defb $a9,$aa,$ac,$ad,$af,$b1,$b2,$b4,$b6,$b7,$b9,$bb,$bd,$be,$c0,$c2
    defb $c4,$c5,$c7,$c9,$cb,$cc,$ce,$d0,$d2,$d4,$d5,$d7,$d9,$db,$dd,$df
    defb $e1,$e2,$e4,$e6,$e8,$ea,$ec,$ee,$f0,$f2,$f4,$f6,$f8,$fa,$fc,$fe
