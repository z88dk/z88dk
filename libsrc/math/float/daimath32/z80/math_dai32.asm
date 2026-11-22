; Floating point package extract from the DAI machine
;
; Labels taken from the DAI firmware disassembly
;
;


        MODULE  math_dai32

        GLOBAL  xget
        GLOBAL  xfmul
        GLOBAL  xfdiv
        GLOBAL  xload
        GLOBAL  xsave
        GLOBAL  xfabs
        GLOBAL  xfchs
        GLOBAL  xfrac
        GLOBAL  xiadd
        GLOBAL  xisub
        GLOBAL  ximul
        GLOBAL  xidiv
        GLOBAL  xirem
        GLOBAL  xflt
        GLOBAL  xfix
        GLOBAL  xfint
        GLOBAL  xsqrt
        GLOBAL  xexp
        GLOBAL  xln
        GLOBAL  xsin
        GLOBAL  xcos
        GLOBAL  xpwr
        GLOBAL  xlog10
        GLOBAL  xtan
        GLOBAL  xatan
        GLOBAL  xasin
        GLOBAL  xacos
        GLOBAL  xfadd
        GLOBAL  xfsub
        GLOBAL  fpcomp



        GLOBAL fpexit
        GLOBAL fperr_overflow
        GLOBAL fperr_div0
        GLOBAL fperr_underflow
        GLOBAL fperr_argerror
        GLOBAL fppop
        GLOBAL fppush
        GLOBAL sext
        GLOBAL fp_half
        GLOBAL addexp

        GLOBAL ___dai32_fpac

        SECTION code_fp_dai32


; Floating point compare
;
; Compare FPT number in MACC and that starting at (hl)
;
; Exit: ABCDEHL preserved
;       Flags:  cy=1,S=0,Z=1 -> both numbers 0
;               cy=0,S=0,Z=1 -> both numbers identical
;               cy=0,S=0,Z=0 -> MACC > (hl)  (jp P,)
;               cy=0,S=1,Z=0 -> MACC < (hl)  (jp M,)
fpcomp:
                    push    bc                              ;[c079] c5
                    push    af                              ;[c07a] f5
                    push    de                              ;[c07b] d5
                    push    hl                              ;[c07c] e5
                    call    xget
                    ld      e,a                             ;[c07f] 5f
                    xor     (hl)                            ;[c080] ae
                    ; Jump if signs different
                    jp      m,lc0b7                         ;[c081] fa b7 c0
                    ld      a,b                             ;[d1e8] 78
                    inc     hl                              ;[d1e9] 23
                    and     (hl)                            ;[d1ea] a6
                    ld      a,(hl)                          ;[d1eb] 7e
                    dec     hl                              ;[d1ec] 2b
                    jp      m,ld1f5                         ;[d1ed] fa f5 d1
                    cp      b                               ;[d1f0] b8
                    ccf                                     ;[d1f1] 3f
                    jp      lc09f                           ;[d1f2] c3 9f c0
ld1f5:
                    ld      a,e                             ;[d1f5] 7b
                    xor     (hl)                            ;[d1f6] ae
                    and     $40                             ;[d1f7] e6 40
                    ld      a,e                             ;[d1f9] 7b
                    rla                                     ;[c087] 17
                    jp      nz,lc0a3                        ;[c088] c2 a3 c0
                    ld      a,e                             ;[c08b] 7b
                    sub     (hl)                            ;[c08c] 96
                    jp      nz,lc0a2                        ;[c08d] c2 a2 c0
                    inc     hl                              ;[c090] 23
                    ld      a,b                             ;[c091] 78
                    sub     (hl)                            ;[c092] 96
                    jp      nz,lc0a2                        ;[c093] c2 a2 c0
                    inc     hl                              ;[c096] 23
                    ld      a,c                             ;[c097] 79
                    sub     (hl)                            ;[c098] 96
                    jp      nz,lc0a6                        ;[c099] c2 a2 c0
                    inc     hl                              ;[c09c] 23
                    ld      a,d                             ;[c09d] 7a
                    ld      a,d                             ;[c09d] 7a
                    sub     (hl)                            ;[c09e] 96
lc09f:
                    jp      z,lc0a6                         ;[c09f] ca a6 c0
lc0a2:
                    rra                                     ;[c0a2] 1f
lc0a3:
                    xor     e                               ;[c0a3] ab
lc0a4:
                    or      $01                             ;[c0a4] f6 01
lc0a6:
                    pop     hl                              ;[c0a6] e1
                    pop     de                              ;[c0a7] d1
                    pop     bc                              ;[c0a8] c1
                    ld      a,b                             ;[c0a9] 78
                    pop     bc                              ;[c0aa] c1
                    ret                                     ;[c0ab] c9


lc0b7:
                    xor     (hl)                            ;[c0b7] ae
                    jp      lc0a4                           ;[c0b8] c3 a4 c0



sext:
                    rlca                                    ;[c1e9] 07
                    rlca                                    ;[c1ea] 07
                    rrca                                    ;[c1eb] 0f
                    rra                                     ;[c1ec] 1f
                    ret                                     ;[c1ed] c9


lc1b7:
                    ld      hl,fpac
addexp:
                    push    hl                              ;[c1ba] e5
                    push    de                              ;[c1bb] d5
                    push    bc                              ;[c1bc] c5
                    ld      c,a                             ;[c1bd] 4f
                    ld      a,(hl)                          ;[c1be] 7e
                    and     $80                             ;[c1bf] e6 80
                    ld      b,a                             ;[c1c1] 47
                    ld      a,(hl)                          ;[c1c2] 7e
                    call    sext                            ;[c1c3] cd e9 c1
                    push    af                              ;[c1c6] f5
                    xor     c                               ;[c1c7] a9
                    cpl                                     ;[c1c8] 2f
                    ld      d,a                             ;[c1c9] 57
                    pop     af                              ;[c1ca] f1
                    add     c                               ;[c1cb] 81
                    ld      c,a                             ;[c1cc] 4f
                    rra                                     ;[c1cd] 1f
                    xor     c                               ;[c1ce] a9
                    and     d                               ;[c1cf] a2
                    jp      m,lc1e2                         ;[c1d0] fa e2 c1
                    ld      a,c                             ;[c1d3] 79
                    rla                                     ;[c1d4] 17
                    xor     c                               ;[c1d5] a9
                    jp      m,lc1e2                         ;[c1d6] fa e2 c1
                    ld      a,c                             ;[c1d9] 79
                    and     $7f                             ;[c1da] e6 7f
                    or      b                               ;[c1dc] b0
                    ld      (hl),a                          ;[c1dd] 77
lc1de:
                    pop     bc                              ;[c1de] c1
                    pop     de                              ;[c1df] d1
                    pop     hl                              ;[c1e0] e1
                    ret                                     ;[c1e1] c9                                        


lc1e2:
                    ld      a,c                             ;[c1e2] 79
                    rla                                     ;[c1e3] 17
                    or      a                               ;[c1e4] b7
                    scf                                     ;[c1e5] 37
                    jp      lc1de                           ;[c1e6] c3 de c1


fppush:
                    ld      (xphls),hl                      ;[c21e] 22 e1 00
                    ex      (sp),hl                         ;[c221] e3
                    ld      (fwork),hl                      ;[c222] 22 df 00
                    push    hl                              ;[c225] e5
                    ld      hl,$0000                        ;[c226] 21 00 00
                    add     hl,sp                           ;[c229] 39
                    call    xsave
                    ld      hl,(fwork)                      ;[c22c] 2a df 00
                    push    hl                              ;[c22f] e5
lc230:
                    ld      hl,(xphls)                      ;[c230] 2a e1 00
                    ret

fppop:
                    ld      (xphls),hl                      ;[c234] 22 e1 00
                    pop     hl                              ;[c237] e1
                    ld      (fwork),hl                      ;[c238] 22 df 00
                    ld      hl,$0000                        ;[c23b] 21 00 00
                    add     hl,sp                           ;[c23e] 39
                    call    xload
                    pop     hl                              ;[c241] e1
                    ld      hl,(fwork)                      ;[c242] 2a df 00
                    ex      (sp),hl                         ;[c245] e3
                    jp      lc230                           ;[c246] c3 30 c2
                 

fperr_overflow:
                    push    hl                              ;[c04b] e5
                    ld      hl,$0000                        ;[c04c] 21 00 00
handle_error:
                    pop     hl
                    ret         ; TODO
                    push    af                              ;[c04f] f5
                    push    de                              ;[c050] d5
                    ex      de,hl                           ;[c051] eb
                    ld      hl,(error_vector)               ;[c052] 2a d0 00
                    add     hl,de                           ;[c055] 19
                    ld      a,(hl)                          ;[c056] 7e
                    inc     hl                              ;[c057] 23
                    ld      h,(hl)                          ;[c058] 66
                    ld      l,a                             ;[c059] 6f
                    pop     de                              ;[c05a] d1
                    pop     af                              ;[c05b] f1
                    ex      (sp),hl                         ;[c05c] e3
                    ret                                     ;[c05d] c9

fperr_argerror:
                    push    hl                              ;[c05e] e5
                    ld      hl,$0002                        ;[c05f] 21 02 00
                    jp      handle_error                    ;[c062] c3 4f c0
fperr_underflow:
                    push    hl                              ;[c065] e5
                    ld      hl,fp_zero                      ;[c066] 21 5e c4
                    call    xload
                    ; Copy to MACC
                    ld      hl,$0004
                    jp      handle_error


fperr_div0:
                    push    hl                              ;[c06c] e5
                    ld      hl,$0006                        ;[c06d] 21 06 00
                    jp      handle_error                    ;[c070] c3 4f c0


fpexit:
                    pop     hl                              ;[c14d] e1
                    pop     de                              ;[c14e] d1
                    pop     bc                              ;[c14f] c1
                    pop     af                              ;[c150] f1
                    ret                                     ;[c151] c9


; FPT Multiplication
;
; MACC = MACC * MEM
;
; Entry: HL: Points to multiplier
; Exit: All registers preserved
xfmul:
                    push    af                              ;[e0fe] f5
                    push    bc                              ;[e0ff] c5
                    push    de                              ;[e100] d5
                    push    hl                              ;[e101] e5
                    call    amul                            ;[e102] cd 59 ea
                    jp      fpexit                          ;[e105] c3 4d c1

; FPT Division
;
; MACC = MACC / MEM
;
; Entry: HL: Points to divisor
; Exit: All registers preserved
xfdiv:
                    push    af                              ;[e108] f5
                    push    bc                              ;[e109] c5
                    push    de                              ;[e10a] d5
                    push    hl                              ;[e10b] e5
                    call    adiv                            ;[e10c] cd 20 ea
                    jp      fpexit                          ;[e10f] c3 4d c1

; Copy operand into MACC
;
; Entry: HL: Points to operand
; Exit: All registers preserved
xload:
                    push    af                              ;[e112] f5
                    push    bc                              ;[e113] c5
                    push    de                              ;[e114] d5
                    push    hl                              ;[e115] e5
                    call    loadfphl                          ;[e116] cd fb e9
                    jp      fpexit                          ;[e119] c3 4d c1

; Copy MACC to operand
;
; Entry: HL: Points to operand
; Exit: All registers preserved
xsave:
                    push    af                              ;[e11c] f5
                    push    bc                              ;[e11d] c5
                    push    de                              ;[e11e] d5
                    push    hl                              ;[e11f] e5
                    call    asave                           ;[e120] cd d6 e9
                    jp      fpexit                          ;[e123] c3 4d c1

; Copy registers a,b,c,d into MACC
;
; Entry: None
; Exit: All registers preserved
xput:
                    push    hl                              ;[e126] e5
                    ld      h,d                             ;[e127] 62
                    ld      l,c                             ;[e128] 69
                    ld      (fpac+2),hl                      ;[e129] 22 d7 00
                    ld      h,b                             ;[e12c] 60
                    ld      l,a                             ;[e12d] 6f
                    ld      (fpac),hl                      ;[e12e] 22 d5 00
                    pop     hl                              ;[e131] e1
                    ret                                     ;[e132] c9

; Copy MACC into registers a,b,c,d 
;
; Entry: None
; Exit: e hl f preserved
xget:
                    push    hl                              ;[e133] e5
                    ld      hl,(fpac+2)                      ;[e134] 2a d7 00
                    ld      c,l                             ;[e137] 4d
                    ld      d,h                             ;[e138] 54
                    ld      hl,(fpac)                      ;[e139] 2a d5 00
                    ld      a,l                             ;[e13c] 7d
                    ld      b,h                             ;[e13d] 44
                    pop     hl                              ;[e13e] e1
                    ret                                     ;[e13f] c9

; FPT Abs
;
; For FPT values MACC = absolute value of MACC
;
; Entry: None
; Exit: All registers preserved
xfabs:
                    push    af                              ;[e140] f5
                    push    bc                              ;[e141] c5
                    push    de                              ;[e142] d5
                    push    hl                              ;[e143] e5
                    call    abs_MACC                        ;[e144] cd ee e9
                    jp      fpexit                          ;[e147] c3 4d c1


; FPT Change sign of MACC
;
; MACC = -MACC
;
; Entry; None
; Exit: All registers preserved
xfchs:
                    push    af                              ;[e14a] f5
                    push    bc                              ;[e14b] c5
                    push    de                              ;[e14c] d5
                    push    hl                              ;[e14d] e5
                    call    achgs                           ;[e14e] cd e4 e9
                    jp      fpexit                          ;[e151] c3 4d c1

; FPT Frac
;
; The FPT number in MACC is replaced by its fractional part
;
; Entry; None
; Exit: All registers preserved
xfrac:
                    push    af                              ;[e154] f5
                    push    hl                              ;[e155] e5
                    call    fppush                          ;[e156] cd 1e c2
                    call    xfint                           ;[e159] cd 43 e4
                    ld      hl,$0000                        ;[e15c] 21 00 00
                    add     hl,sp                           ;[e15f] 39
                    call    xfsub                           ;[e160] cd b4 ed
                    call    xfchs                           ;[e163] cd 4a e1
                    inc     sp                              ;[e166] 33
                    inc     sp                              ;[e167] 33
                    inc     sp                              ;[e168] 33
                    inc     sp                              ;[e169] 33
                    pop     hl                              ;[e16a] e1
                    pop     af                              ;[e16b] f1
                    ret                                     ;[e16c] c9

; Integer addition
;
; Signed 32-bit addition: MACC = MACC + MEM
; 
; Entry: hl = points to operand
; Exit: All registers preserved
xiadd:
                    push    af                              ;[e16d] f5
                    push    bc                              ;[e16e] c5
                    push    de                              ;[e16f] d5
                    push    hl                              ;[e170] e5
                    call    l1e51                           ;[e171] cd 8c e3
                    push    de                              ;[e174] d5
                    add     (hl)                            ;[e175] 86
                    ld      d,a                             ;[e176] 57
                    dec     hl                              ;[e177] 2b
                    ld      a,c                             ;[e178] 79
                    adc     (hl)                            ;[e179] 8e
                    ld      c,a                             ;[e17a] 4f
                    dec     hl                              ;[e17b] 2b
                    ld      a,b                             ;[e17c] 78
                    adc     (hl)                            ;[e17d] 8e
                    ld      b,a                             ;[e17e] 47
                    dec     hl                              ;[e17f] 2b
                    ld      a,e                             ;[e180] 7b
                    adc     (hl)                            ;[e181] 8e
                    ld      e,a                             ;[e182] 5f
                    rra                                     ;[e183] 1f
                    xor     e                               ;[e184] ab
                    pop     hl                              ;[e185] e1
                    and     h                               ;[e186] a4
l1e11:
                    call    m,fperr_overflow                         ;[e187] fc 4b c0
                    jp      l1e48                           ;[e18a] c3 84 e3


; Integer subtraction
;
; Signed 32-bit addition: MACC = MACC - MEM
; 
; Entry: hl = points to operand
; Exit: All registers preserved
xisub:
                    push    af                              ;[e18d] f5
                    push    bc                              ;[e18e] c5
                    push    de                              ;[e18f] d5
                    push    hl                              ;[e190] e5
                    call    l1e51                           ;[e191] cd 8c e3
                    push    de                              ;[e194] d5
                    sub     (hl)                            ;[e195] 96
                    ld      d,a                             ;[e196] 57
                    dec     hl                              ;[e197] 2b
                    ld      a,c                             ;[e198] 79
                    sbc     (hl)                            ;[e199] 9e
                    ld      c,a                             ;[e19a] 4f
                    dec     hl                              ;[e19b] 2b
                    ld      a,b                             ;[e19c] 78
                    sbc     (hl)                            ;[e19d] 9e
                    ld      b,a                             ;[e19e] 47
                    dec     hl                              ;[e19f] 2b
                    ld      a,e                             ;[e1a0] 7b
                    sbc     (hl)                            ;[e1a1] 9e
                    ld      e,a                             ;[e1a2] 5f
                    rra                                     ;[e1a3] 1f
                    xor     e                               ;[e1a4] ab
                    pop     hl                              ;[e1a5] e1
                    or      h                               ;[e1a6] b4
                    cpl                                     ;[e1a7] 2f
                    or      a                               ;[e1a8] b7
                    jp      l1e11                           ;[e1a9] c3 87 e1

; Integer multiplication
;
; Signed 32-bit multiplication: MACC = MACC * MEM
; 
; Entry: hl = points to multiplier
; Exit: All registers preserved
ximul:
                    push    af                              ;[e1ac] f5
                    push    bc                              ;[e1ad] c5
                    push    de                              ;[e1ae] d5
                    push    hl                              ;[e1af] e5
                    ld      a,(fpac)                       ;[e1b0] 3a d5 00
                    or      a                               ;[e1b3] b7
                    call    m,x1chs                         ;[e1b4] fc 15 e3
                    jp      c,l1e21                         ;[e1b7] da 25 e2
                    xor     (hl)                            ;[e1ba] ae
                    push    af                              ;[e1bb] f5
                    ld      a,(hl)                          ;[e1bc] 7e
                    inc     hl                              ;[e1bd] 23
                    or      a                               ;[e1be] b7
                    ld      b,a                             ;[e1bf] 47
                    ld      c,(hl)                          ;[e1c0] 4e
                    inc     hl                              ;[e1c1] 23
                    ld      d,(hl)                          ;[e1c2] 56
                    inc     hl                              ;[e1c3] 23
                    ld      e,(hl)                          ;[e1c4] 5e
                    call    m,l1e57                         ;[e1c5] fc c9 e3
                    jp      c,l1e21                         ;[e1c8] da 25 e2
                    or      c                               ;[e1cb] b1
                    jp      z,l1e14                         ;[e1cc] ca df e1
                    ld      hl,(fpac)                      ;[e1cf] 2a d5 00
                    ld      a,h                             ;[e1d2] 7c
                    or      l                               ;[e1d3] b5
                    jp      nz,l1e21                        ;[e1d4] c2 25 e2
                    ld      hl,(fpac+2)                      ;[e1d7] 2a d7 00
                    call    l1e58                           ;[e1da] cd cf e3
                    ld      d,l                             ;[e1dd] 55
                    ld      e,h                             ;[e1de] 5c
l1e14:
                    ld      hl,$0000                        ;[e1df] 21 00 00
                    push    hl                              ;[e1e2] e5
                    ld      hl,fpac+3                        ;[e1e3] 21 d8 00
                    ld      c,(hl)                          ;[e1e6] 4e
l1e15:
                    ex      (sp),hl                         ;[e1e7] e3
                    ld      a,c                             ;[e1e8] 79
                    or      a                               ;[e1e9] b7
                    jp      z,l1e20                         ;[e1ea] ca 1e e2
                    ld      b,$80                           ;[e1ed] 06 80
l1e16:
                    ld      a,c                             ;[e1ef] 79
                    rra                                     ;[e1f0] 1f
                    ld      c,a                             ;[e1f1] 4f
                    jp      nc,l1e17                        ;[e1f2] d2 f6 e1
                    add     hl,de                           ;[e1f5] 19
l1e17:
                    ld      a,h                             ;[e1f6] 7c
                    rra                                     ;[e1f7] 1f
                    ld      h,a                             ;[e1f8] 67
                    ld      a,l                             ;[e1f9] 7d
                    rra                                     ;[e1fa] 1f
                    ld      l,a                             ;[e1fb] 6f
                    ld      a,b                             ;[e1fc] 78
                    rra                                     ;[e1fd] 1f
                    ld      b,a                             ;[e1fe] 47
                    jp      nc,l1e16                        ;[e1ff] d2 ef e1
l1e18:
                    ex      (sp),hl                         ;[e202] e3
                    ld      (hl),b                          ;[e203] 70
                    dec     hl                              ;[e204] 2b
                    ld      a,l                             ;[e205] 7d
                    cp      $d4                             ;[e206] fe d4
                    ld      c,(hl)                          ;[e208] 4e
                    jp      nz,l1e15                        ;[e209] c2 e7 e1
                    pop     hl                              ;[e20c] e1
                    ld      a,b                             ;[e20d] 78
                    or      a                               ;[e20e] b7
                    jp      m,l1e21                         ;[e20f] fa 25 e2
                    ld      a,h                             ;[e212] 7c
                    or      l                               ;[e213] b5
                    jp      nz,l1e21                        ;[e214] c2 25 e2
l1e19:
                    pop     af                              ;[e217] f1
                    call    m,x1chs                         ;[e218] fc 15 e3
                    jp      fpexit                          ;[e21b] c3 4d c1
l1e20:
                    ld      b,l                             ;[e21e] 45
                    ld      l,h                             ;[e21f] 6c
                    ld      h,$00                           ;[e220] 26 00
                    jp      l1e18                           ;[e222] c3 02 e2
l1e21:
                    call    fperr_overflow                           ;[e225] cd 4b c0
                    jp      l1e19                           ;[e228] c3 17 e2

; Signed integer division
;
; MACC = MACC / MEM
;
; Entry:   hl = points to divisor
;        MACC = dividend
; Exit:  MACC = quotient
;        All registers preserved
xidiv:
                    push    af                              ;[e22b] f5
                    push    bc                              ;[e22c] c5
                    push    de                              ;[e22d] d5
                    push    hl                              ;[e22e] e5
                    call    lie24                           ;[e22f] cd 42 e2
                    call    l1e58                           ;[e232] cd cf e3
                    jp      fpexit                          ;[e235] c3 4d c1
xirem:
                    push    af                              ;[e238] f5
                    push    bc                              ;[e239] c5
                    push    de                              ;[e23a] d5
                    push    hl                              ;[e23b] e5
                    call    lie24                           ;[e23c] cd 42 e2
                    jp      fpexit                          ;[e23f] c3 4d c1

; Signed integer division
;
; Entry:   hl = points to divisor
;         MACC  = divident
; Exit:  bcde = quotient
;        MACC = remainder
lie24:
                    call    l1e234                          ;[e242] cd 8f ed
                    ld      a,b                             ;[e245] 78
                    push    af                              ;[e246] f5
                    call    ldbcde                          ;[e247] cd 0e ea
                    ld      a,b                             ;[e24a] 78
                    or      c                               ;[e24b] b1
                    or      d                               ;[e24c] b2
                    or      e                               ;[e24d] b3
                    jp      z,l1e31                         ;[e24e] ca e4 e2
                    ld      a,b                             ;[e251] 78
                    or      a                               ;[e252] b7
                    call    m,l1e57                         ;[e253] fc c9 e3
                    jp      c,l1e31                         ;[e256] da e4 e2
                    push    bc                              ;[e259] c5
                    push    de                              ;[e25a] d5
                    call    normbcde                           ;[e25b] cd ec e2
                    cpl                                     ;[e25e] 2f
                    inc     a                               ;[e25f] 3c
                    ld      h,a                             ;[e260] 67
                    ld      a,(fpac)                        ;[e261] 3a d5 00
                    or      a                               ;[e264] b7
                    call    m,x1chs                         ;[e265] fc 15 e3
                    call    l1e59                           ;[e268] cd d6 e3
                    or      c                               ;[e26b] b1
                    or      d                               ;[e26c] b2
                    or      e                               ;[e26d] b3
                    jp      z,l1e30                         ;[e26e] ca e0 e2
                    call    normbcde                           ;[e271] cd ec e2
                    pop     de                              ;[e274] d1
                    pop     bc                              ;[e275] c1
                    add     h                               ;[e276] 84
                    jp      m,l1e27                         ;[e277] fa c9 e2
                    call    lshn                            ;[e27a] cd 39 eb
                    push    de                              ;[e27d] d5
                    push    bc                              ;[e27e] c5
                    ld      bc,$8000                        ;[e27f] 01 00 80
                    ld      de,$0000                        ;[e282] 11 00 00
                    call    rshn                            ;[e285] cd 55 eb
                    ld      h,b                             ;[e288] 60
                    ld      l,c                             ;[e289] 69
                    pop     bc                              ;[e28a] c1
                    ex      (sp),hl                         ;[e28b] e3
                    ex      de,hl                           ;[e28c] eb
                    push    hl                              ;[e28d] e5
l1e25:
                    ld      hl,(fpac+2)                      ;[e28e] 2a d7 00
                    ld      a,h                             ;[e291] 7c
                    sub     e                               ;[e292] 93
                    ld      h,a                             ;[e293] 67
                    ld      a,l                             ;[e294] 7d
                    sbc     d                               ;[e295] 9a
                    ld      l,a                             ;[e296] 6f
                    ld      (fpac+2),hl                      ;[e297] 22 d7 00
                    ld      hl,(fpac)                      ;[e29a] 2a d5 00
                    ld      a,h                             ;[e29d] 7c
                    sbc     c                               ;[e29e] 99
                    ld      h,a                             ;[e29f] 67
                    ld      a,l                             ;[e2a0] 7d
                    sbc     b                               ;[e2a1] 98
                    ld      l,a                             ;[e2a2] 6f
                    ld      (fpac),hl                      ;[e2a3] 22 d5 00
l1e26:
                    pop     hl                              ;[e2a6] e1
                    rla                                     ;[e2a7] 17
                    ccf                                     ;[e2a8] 3f
                    ld      a,l                             ;[e2a9] 7d
                    rla                                     ;[e2aa] 17
                    ld      l,a                             ;[e2ab] 6f
                    ld      a,h                             ;[e2ac] 7c
                    rla                                     ;[e2ad] 17
                    ld      h,a                             ;[e2ae] 67
                    ex      (sp),hl                         ;[e2af] e3
                    ld      a,l                             ;[e2b0] 7d
                    rla                                     ;[e2b1] 17
                    ld      l,a                             ;[e2b2] 6f
                    ld      a,h                             ;[e2b3] 7c
                    rla                                     ;[e2b4] 17
                    ld      h,a                             ;[e2b5] 67
                    ex      (sp),hl                         ;[e2b6] e3
                    jp      c,l1e28                         ;[e2b7] da d0 e2
                    call    l1e188                          ;[e2ba] cd 70 eb
                    ld      a,l                             ;[e2bd] 7d
                    rra                                     ;[e2be] 1f
                    push    hl                              ;[e2bf] e5
                    jp      c,l1e25                         ;[e2c0] da 8e e2
                    call    l1e33                           ;[e2c3] cd f2 e2
                    jp      l1e26                           ;[e2c6] c3 a6 e2
l1e27:
                    ld      de,$0000                        ;[e2c9] 11 00 00
                    push    de                              ;[e2cc] d5
                    jp      l1e29                           ;[e2cd] c3 d7 e2
l1e28:
                    ld      a,l                             ;[e2d0] 7d
                    rra                                     ;[e2d1] 1f
                    push    hl                              ;[e2d2] e5
                    call    nc,l1e33                        ;[e2d3] d4 f2 e2
                    pop     de                              ;[e2d6] d1
l1e29:
                    pop     bc                              ;[e2d7] c1
                    pop     af                              ;[e2d8] f1
                    call    l1e233                          ;[e2d9] cd 88 ed
                    call    m,x1chs                         ;[e2dc] fc 15 e3
                    ret                                     ;[e2df] c9

l1e30:
                    pop     hl                              ;[e2e0] e1
                    pop     hl                              ;[e2e1] e1
                    pop     af                              ;[e2e2] f1
                    ret                                     ;[e2e3] c9

l1e31:
                    call    c,fperr_overflow                         ;[e2e4] dc 4b c0
                    call    z,fperr_div0                         ;[e2e7] cc 6c c0
                    pop     af                              ;[e2ea] f1
                    ret                                     ;[e2eb] c9

; INTEGER: Normalise bcde
normbcde:
                    push    hl                              ;[e2ec] e5
                    call    l1e192                          ;[e2ed] cd a0 eb
                    pop     hl                              ;[e2f0] e1
                    ret                                     ;[e2f1] c9

l1e33:
                    ld      hl,(fpac+2)                      ;[e2f2] 2a d7 00
                    ld      a,h                             ;[e2f5] 7c
                    add     e                               ;[e2f6] 83
                    ld      h,a                             ;[e2f7] 67
                    ld      a,l                             ;[e2f8] 7d
                    adc     d                               ;[e2f9] 8a
                    ld      l,a                             ;[e2fa] 6f
                    ld      (fpac+2),hl                      ;[e2fb] 22 d7 00
                    ld      hl,(fpac)                      ;[e2fe] 2a d5 00
                    ld      a,h                             ;[e301] 7c
                    adc     c                               ;[e302] 89
                    ld      h,a                             ;[e303] 67
                    ld      a,l                             ;[e304] 7d
                    adc     b                               ;[e305] 88
                    ld      l,a                             ;[e306] 6f
                    ld      (fpac),hl                      ;[e307] 22 d5 00
                    ret                                     ;[e30a] c9

x1abs:
                    push    af                              ;[e30b] f5
                    ld      a,(fpac)                       ;[e30c] 3a d5 00
                    or      a                               ;[e30f] b7
                    call    m,x1chs                         ;[e310] fc 15 e3
                    pop     af                              ;[e313] f1
                    ret                                     ;[e314] c9

x1chs:
                    push    af                              ;[e315] f5
                    push    bc                              ;[e316] c5
                    push    de                              ;[e317] d5
                    push    hl                              ;[e318] e5
                    call    l1e59                           ;[e319] cd d6 e3
                    call    l1e57                           ;[e31c] cd c9 e3
                    jp      nc,l1e37                        ;[e31f] d2 28 e3
l1e36:
                    call    fperr_overflow                           ;[e322] cd 4b c0
                    jp      fpexit                          ;[e325] c3 4d c1
l1e37:
                    call    l1e58                           ;[e328] cd cf e3
                    jp      fpexit                          ;[e32b] c3 4d c1
xiand:
                    push    af                              ;[e32e] f5
                    push    bc                              ;[e32f] c5
                    push    de                              ;[e330] d5
                    push    hl                              ;[e331] e5
                    jp      l1e213                          ;[e332] c3 e1 ec
siand:
                    and     (hl)                            ;[e335] a6
                    ld      d,a                             ;[e336] 57
                    dec     hl                              ;[e337] 2b
                    ld      a,c                             ;[e338] 79
                    and     (hl)                            ;[e339] a6
                    ld      c,a                             ;[e33a] 4f
                    dec     hl                              ;[e33b] 2b
                    ld      a,b                             ;[e33c] 78
                    and     (hl)                            ;[e33d] a6
                    ld      b,a                             ;[e33e] 47
                    dec     hl                              ;[e33f] 2b
                    ld      a,e                             ;[e340] 7b
                    and     (hl)                            ;[e341] a6
                    ret                                     ;[e342] c9

l1e40:
                    add     l                               ;[e343] 85
                    ex      (sp),hl                         ;[e344] e3
xior:
                    push    af                              ;[e345] f5
                    push    bc                              ;[e346] c5
                    push    de                              ;[e347] d5
                    push    hl                              ;[e348] e5
                    jp      l1e214                          ;[e349] c3 ea ec
sior:
                    or      (hl)                            ;[e34c] b6
                    ld      d,a                             ;[e34d] 57
                    dec     hl                              ;[e34e] 2b
                    ld      a,c                             ;[e34f] 79
                    or      (hl)                            ;[e350] b6
                    ld      c,a                             ;[e351] 4f
                    dec     hl                              ;[e352] 2b
                    ld      a,b                             ;[e353] 78
                    or      (hl)                            ;[e354] b6
                    ld      b,a                             ;[e355] 47
                    dec     hl                              ;[e356] 2b
                    ld      a,e                             ;[e357] 7b
                    or      (hl)                            ;[e358] b6
                    ret                                     ;[e359] c9

l1e43:
                    add     l                               ;[e35a] 85
                    ex      (sp),hl                         ;[e35b] e3
xixor:
                    push    af                              ;[e35c] f5
                    push    bc                              ;[e35d] c5
                    push    de                              ;[e35e] d5
                    push    hl                              ;[e35f] e5
                    jp      l1e215                          ;[e360] c3 f3 ec
sixor:
                    xor     (hl)                            ;[e363] ae
                    ld      d,a                             ;[e364] 57
                    dec     hl                              ;[e365] 2b
                    ld      a,c                             ;[e366] 79
                    xor     (hl)                            ;[e367] ae
                    ld      c,a                             ;[e368] 4f
                    dec     hl                              ;[e369] 2b
                    ld      a,b                             ;[e36a] 78
                    xor     (hl)                            ;[e36b] ae
                    ld      b,a                             ;[e36c] 47
                    dec     hl                              ;[e36d] 2b
                    ld      a,e                             ;[e36e] 7b
                    xor     (hl)                            ;[e36f] ae
                    ret                                     ;[e370] c9

l1e46:
                    add     l                               ;[e371] 85
                    ex      (sp),hl                         ;[e372] e3
x1not:
                    push    af                              ;[e373] f5
                    push    bc                              ;[e374] c5
                    push    de                              ;[e375] d5
                    push    hl                              ;[e376] e5
                    call    l1e216                          ;[e377] cd fc ec
                    ld      e,a                             ;[e37a] 5f
                    ld      a,d                             ;[e37b] 7a
                    cpl                                     ;[e37c] 2f
                    ld      d,a                             ;[e37d] 57
                    ld      a,c                             ;[e37e] 79
                    cpl                                     ;[e37f] 2f
                    ld      c,a                             ;[e380] 4f
                    ld      a,b                             ;[e381] 78
                    cpl                                     ;[e382] 2f
                    ld      b,a                             ;[e383] 47
l1e48:
                    ld      a,e                             ;[e384] 7b
l1e49:
                    call    xput                            ;[e385] cd 26 e1
                    jp      fpexit                          ;[e388] c3 4d c1
l1e50:
                    ret                                     ;[e38b] c9

l1e51:
                    jp      l1e217                          ;[e38c] c3 01 ed
l1e52:
                    xor     (hl)                            ;[e38f] ae
                    cpl                                     ;[e390] 2f
                    inc     hl                              ;[e391] 23
                    inc     hl                              ;[e392] 23
                    inc     hl                              ;[e393] 23
                    push    de                              ;[e394] d5
                    ld      d,a                             ;[e395] 57
                    pop     af                              ;[e396] f1
                    ret                                     ;[e397] c9

xshr:
                    push    af                              ;[e398] f5
                    push    bc                              ;[e399] c5
                    push    de                              ;[e39a] d5
                    push    hl                              ;[e39b] e5
                    call    l1e219                          ;[e39c] cd 08 ed
                    call    rshn                            ;[e39f] cd 55 eb
                    jp      l1e37                           ;[e3a2] c3 28 e3
xshl:
                    push    af                              ;[e3a5] f5
                    push    bc                              ;[e3a6] c5
                    push    de                              ;[e3a7] d5
                    push    hl                              ;[e3a8] e5
                    call    l1e219                          ;[e3a9] cd 08 ed
                    call    lshn                            ;[e3ac] cd 39 eb
                    jp      l1e37                           ;[e3af] c3 28 e3
xstst:
                    ld      a,(hl)                          ;[e3b2] 7e
                    inc     hl                              ;[e3b3] 23
                    or      (hl)                            ;[e3b4] b6
                    inc     hl                              ;[e3b5] 23
                    or      (hl)                            ;[e3b6] b6
                    inc     hl                              ;[e3b7] 23
                    jp      nz,l1e56                        ;[e3b8] c2 c2 e3
                    ld      a,(hl)                          ;[e3bb] 7e
                    and     $e0                             ;[e3bc] e6 e0
                    nop                                     ;[e3be] 00
                    nop                                     ;[e3bf] 00
                    ld      a,(hl)                          ;[e3c0] 7e
                    ret     z                               ;[e3c1] c8
l1e56:
                    ld      a,$00                           ;[e3c2] 3e 00
                    ld      b,a                             ;[e3c4] 47
                    ld      c,a                             ;[e3c5] 4f
                    ld      d,a                             ;[e3c6] 57
                    ld      e,a                             ;[e3c7] 5f
                    ret                                     ;[e3c8] c9

l1e57:
                    push    hl                              ;[e3c9] e5
                    call    l1e190                          ;[e3ca] cd 82 eb
                    pop     hl                              ;[e3cd] e1
                    ret                                     ;[e3ce] c9

l1e58:
                    ld      a,b                             ;[e3cf] 78
                    ld      b,c                             ;[e3d0] 41
                    ld      c,d                             ;[e3d1] 4a
                    ld      d,e                             ;[e3d2] 53
                    jp      xput                            ;[e3d3] c3 26 e1
l1e59:
                    push    af                              ;[e3d6] f5
                    call    xget                            ;[e3d7] cd 33 e1
                    jp      gbc10                           ;[e3da] c3 13 ed
l1e60:
                    ret                                     ;[e3dd] c9

; Change contents of MACC to FLT
;
; Entry: none
; Exit: All registers preservied
xflt:
                    push    af                              ;[e3de] f5
                    push    bc                              ;[e3df] c5
                    push    de                              ;[e3e0] d5
                    push    hl                              ;[e3e1] e5
                    call    l1e59                           ;[e3e2] cd d6 e3
                    call    l1e232                          ;[e3e5] cd 83 ed
                    jp      z,l1e63                         ;[e3e8] ca 0e e4
                    ld      h,$20                           ;[e3eb] 26 20
                    ld      a,b                             ;[e3ed] 78
                    or      a                               ;[e3ee] b7
                    jp      p,l1e62                         ;[e3ef] f2 fd e3
                    ld      h,$a0                           ;[e3f2] 26 a0
                    call    l1e57                           ;[e3f4] cd c9 e3
                    jp      nc,l1e62                        ;[e3f7] d2 fd e3
                    ld      b,$80                           ;[e3fa] 06 80
                    ; Bug fix to handle bug
                    ;inc     h                               ;[e3fc] 24
l1e62:
                    ld      a,h                             ;[e3fd] 7c
                    ld      hl,fpac                        ;[e3fe] 21 d5 00
                    ld      (hl),a                          ;[e401] 77
                    push    hl                              ;[e402] e5
                    call    l1e191                          ;[e403] cd 96 eb
                    pop     hl                              ;[e406] e1
                    ld      a,(hl)                          ;[e407] 7e
                    call    astore                          ;[e408] cd db e9
                    jp      fpexit                          ;[e40b] c3 4d c1
l1e63:
                    call    zero                            ;[e40e] cd 16 ea
                    jp      fpexit                          ;[e411] c3 4d c1

; Change contents of MACC to integer
;
; Entry: none
; Exit: All registers preservied
xfix:
                    push    af                              ;[e414] f5
                    push    bc                              ;[e415] c5
                    push    de                              ;[e416] d5
                    push    hl                              ;[e417] e5
                    call    xget                            ;[e418] cd 33 e1
                    push    af                              ;[e41b] f5
                    and     $7f                             ;[e41c] e6 7f
                    jp      z,l1e65                         ;[e41e] ca 3b e4
                    cp      $40                             ;[e421] fe 40
                    jp      nc,l1e65                        ;[e423] d2 3b e4
                    sub     $20                             ;[e426] d6 20
                    jp      nc,l1e66                        ;[e428] d2 3f e4
                    cpl                                     ;[e42b] 2f
                    inc     a                               ;[e42c] 3c
                    call    rshn                            ;[e42d] cd 55 eb
                    pop     af                              ;[e430] f1
                    or      a                               ;[e431] b7
                    call    m,l1e57                         ;[e432] fc c9 e3
                    jp      c,l1e36                         ;[e435] da 22 e3
                    jp      l1e37                           ;[e438] c3 28 e3
l1e65:
                    pop     af                              ;[e43b] f1
                    jp      l1e63                           ;[e43c] c3 0e e4
l1e66:
                    pop     af                              ;[e43f] f1
                    jp      l1e36                           ;[e440] c3 22 e3

; FPT INT(x)
;
; The contents of the MACC are replaced by the FPT integer
; The fractional bits of mantissa are masked off
;
; Exit: All registers preserved
xfint:
                    push    af                              ;[e443] f5
                    push    bc                              ;[e444] c5
                    push    de                              ;[e445] d5
                    push    hl                              ;[e446] e5
                    ld      hl,fpac                        ;[e447] 21 d5 00
                    ld      a,(hl)                          ;[e44a] 7e
                    and     $7f                             ;[e44b] e6 7f
                    jp      z,l1e63                         ;[e44d] ca 0e e4
                    cp      $40                             ;[e450] fe 40
                    jp      nc,l1e63                        ;[e452] d2 0e e4
                    sub     $19                             ;[e455] d6 19
                    ld      hl,fpac+3                        ;[e457] 21 d8 00
                    ld      e,$03                           ;[e45a] 1e 03
                    ld      d,a                             ;[e45c] 57
l1e68:
                    ld      c,$08                           ;[e45d] 0e 08
l1e69:
                    inc     d                               ;[e45f] 14
                    scf                                     ;[e460] 37
                    jp      p,l1e70                         ;[e461] f2 65 e4
                    ccf                                     ;[e464] 3f
l1e70:
                    rra                                     ;[e465] 1f
                    dec     c                               ;[e466] 0d
                    jp      nz,l1e69                        ;[e467] c2 5f e4
                    and     (hl)                            ;[e46a] a6
                    ld      (hl),a                          ;[e46b] 77
                    dec     hl                              ;[e46c] 2b
                    dec     e                               ;[e46d] 1d
                    jp      nz,l1e68                        ;[e46e] c2 5d e4
                    jp      fpexit                          ;[e471] c3 4d c1

IF MATH_AM9511

; AMD: FPT addition
;
; MTOS = MTOS + MEM
;
; Entry: hl = points to operand
; Exit: All registers preserved
zfadd:
                    call    wlopi                           ;[e474] cd 27 e5
                    defb    $10
                    ret
                    
; AMD: FPT subtraction
;
; MTOS = MTOS - MEM
;
; Entry: hl = points to operand
; Exit: All registers preserved
zfsub:
                    call    wlopi                           ;[e479] cd 27 e5
                    defb    $11
                    ret

; AMD: FPT multiplication
;
; MTOS = MTOS * MEM
;
; Entry: hl = points to multiplier
; Exit: All registers preserved
zfmul:              call    wlopi
                    defb    $12
                    ret


; AMD: FPT division
;
; MTOS = MTOS / MEM
;
; Entry: hl = points to divisor
; Exit: All registers preserved
zfdiv:
                    call    wlopi                           ;[e483] cd 27 e5
                    inc     de                              ;[e486] 13
                    ret                                     ;[e487] c9

; AMD: FPT abs
;
; MTOS = abs(MTOS)

; Entry: none
; Exit: All registers preserved
zfabs:
                    push    af                              ;[e488] f5
                    call    mfstat                          ;[e489] cd 95 ed
                    nop                                     ;[e48c] 00
                    add     a                               ;[e48d] 87
                    call    m,zfchs                         ;[e48e] fc 93 e4
                    pop     af                              ;[e491] f1
                    ret                                     ;[e492] c9

; AMD: Change sign
;
; MTOS = -MTOS
;
; Entry: none
; Exit: All registers preserved
zfchs:
                    call    wopi                            ;[e493] cd 35 e5
                    defb    $15
                    ret                                     ;[e497] c9

zfint:
                    call    zfix                            ;[e498] cd ef e4
zflt:
                    call    wopi                            ;[e49b] cd 35 e5
                    defb    $1c 
                    ret                                     ;[e49f] c9

zfrac:
                    call    wopi                            ;[e4a0] cd 35 e5
                    defb    $37
                    call    zfint                           ;[e4a4] cd 98 e4
                    call    wopi                            ;[e4a7] cd 35 e5
                    defb    $11
                    ret

; Part of AMD: POWER
;
; Entry: hl = points to operand
; Exit: All registers preserved
mpr14:
                    call    wlopi
                    defb    $0b
                    ret
                    
zln:
                    call    wopi                            ;[e4b1] cd 35 e5
                    defb    $09
                    ret                                     ;[e4b5] c9

zexp:
                    call    wopi                            ;[e4b6] cd 35 e5
                    defb    $0a
                    ret                                     ;[e4ba] c9

zlog:
                    call    wopi                            ;[e4bb] cd 35 e5
                    defb    $08
                    ret                                     ;[e4bf] c9

zalog:
                    push    hl                              ;[e4c0] e5
                    ld      hl,fp_invln10                        ;[e4c1] 21 90 e8
                    call    zfdiv                           ;[e4c4] cd 83 e4
                    pop     hl                              ;[e4c7] e1
                    call    zexp                            ;[e4c8] cd b6 e4
                    ret                                     ;[e4cb] c9

zsqrt:
                    call    wopi                            ;[e4cc] cd 35 e5
                    defb    $01
                    ret


zsin:               call    wopi
                    defb    $02
                    ret
                    
zcos:
                    call    wopi                            ;[e4d6] cd 35 e5
                    defb    $03
                    ret                                     ;[e4da] c9

ztan:
                    call    wopi                            ;[e4db] cd 35 e5
                    defb    $04
                    ret                                     ;[e4df] c9

zasin:
                    call    wopi                            ;[e4e0] cd 35 e5
                    defb    $05
                    ret                                     ;[e4e4] c9

zacos:
                    call    wopi                            ;[e4e5] cd 35 e5
                    defb    $06
                    ret

zatan:
                    call    wopi                            ;[e4ea] cd 35 e5
                    defb    $07
                    ret                                     ;[e4ee] c9

zfix:
                    call    wopi                            ;[e4ef] cd 35 e5
                    defb    $1e
                    ret

ziadd:
                    call    wlopi                           ;[e4f4] cd 27 e5
                    defb    $2c
                    ret                                     ;[e4f8] c9

zisub:
                    call    wlopi                           ;[e4f9] cd 27 e5
                    defb    $2d
                    ret                                     ;[e4fd] c9

zimul:
                    call    wlopi                           ;[e4fe] cd 27 e5
                    defb    $2e
                    ret

zidiv:
                    call    wlopi                           ;[e503] cd 27 e5
                    defb    $2f
                    ret                                     ;[e507] c9

zirem:
                    call    wopi                            ;[e508] cd 35 e5
                    defb    $37
                    call    zidiv                           ;[e50c] cd 03 e5
                    call    zimul                           ;[e50f] cd fe e4
                    call    wopi                            ;[e512] cd 35 e5
                    defb    $2d
                    ret                                     ;[e516] c9

z1abs:
                    push    af                              ;[e517] f5
                    call    mfstat                          ;[e518] cd 95 ed
                    nop                                     ;[e51b] 00
                    add     a                               ;[e51c] 87
                    call    m,zichs                         ;[e51d] fc 22 e5
                    pop     af                              ;[e520] f1
                    ret                                     ;[e521] c9

zichs:
                    call    wopi                            ;[e522] cd 35 e5
                    defb    $34
                    ret                                     ;[e526] c9

wlopi:
                    call    wmath                           ;[e527] cd 3b e5
                    call    zload                           ;[e52a] cd 88 e5
opi:
                    ex      (sp),hl                         ;[e52d] e3
                    push    af                              ;[e52e] f5
                    call    mpt15                           ;[e52f] cd cc ec
                    pop     af                              ;[e532] f1
                    ex      (sp),hl                         ;[e533] e3
                    ret                                     ;[e534] c9

wopi:
                    call    wmath                           ;[e535] cd 3b e5
                    jp      opi                             ;[e538] c3 2d e5

; Wait for AMD chip ready
wmath:
                    push    af                              ;[e53b] f5
wmt10:
                    ld      a,($fb02)                       ;[e53c] 3a 02 fb
                    or      a                               ;[e53f] b7
                    jp      m,wmt10                         ;[e540] fa 3c e5
                    and     $1e                             ;[e543] e6 1e
                    jp      z,wmt20                         ;[e545] ca 5d e5
                    nop                                     ;[e548] 00
                    call    mpt16                           ;[e549] cd d2 ec
                    rra                                     ;[e54c] 1f
                    rra                                     ;[e54d] 1f
                    call    c,fperr_overflow                         ;[e54e] dc 4b c0
                    rra                                     ;[e551] 1f
                    call    c,fperr_underflow                         ;[e552] dc 65 c0
                    rra                                     ;[e555] 1f
                    call    c,fperr_argerror                         ;[e556] dc 5e c0
                    rra                                     ;[e559] 1f
                    call    c,fperr_div0                         ;[e55a] dc 6c c0
wmt20:
                    pop     af                              ;[e55d] f1
                    ret                                     ;[e55e] c9

; AMD: Copy registers a,b,c,d into MTOS
zput:
                    push    af                              ;[e55f] f5
                    ld      a,d                             ;[e560] 7a
                    call    wmath                           ;[e561] cd 3b e5
zpt10:              ld      ($fb00),a                       ;[e564] 32 00 fb
                    ld      a,c                             ;[e567] 79
                    ld      ($fb00),a                       ;[e568] 32 00 fb
                    ld      a,b                             ;[e56b] 78
                    jp      mpt17                           ;[e56c] c3 d9 ec
zget:
                    call    wmath                           ;[e56f] cd 3b e5
                    ld      a,($fb00)                       ;[e572] 3a 00 fb
                    push    af                              ;[e575] f5
                    ld      a,($fb00)                       ;[e576] 3a 00 fb
                    ld      b,a                             ;[e579] 47
                    ld      a,($fb00)                       ;[e57a] 3a 00 fb
                    ld      c,a                             ;[e57d] 4f
                    ld      a,($fb00)                       ;[e57e] 3a 00 fb
                    ld      d,a                             ;[e581] 57
                    jp      zpt10                           ;[e582] c3 64 e5

; Unused
l1e109:
                    ld      d,l                             ;[e585] 55
                    pop     hl                              ;[e586] e1
                    ret                                     ;[e587] c9

; AMD: Copy operand into MTOS
;
; Entry: hl = points to operand
; Exit: All registers preserved
zload:
                    push    af                              ;[e588] f5
                    push    bc                              ;[e589] c5
                    push    de                              ;[e58a] d5
                    push    hl                              ;[e58b] e5
                    ld      a,(hl)                          ;[e58c] 7e
                    inc     hl                              ;[e58d] 23
                    ld      b,(hl)                          ;[e58e] 46
                    inc     hl                              ;[e58f] 23
                    ld      c,(hl)                          ;[e590] 4e
                    inc     hl                              ;[e591] 23
                    ld      d,(hl)                          ;[e592] 56
                    call    zput                            ;[e593] cd 5f e5
                    jp      fpexit                          ;[e596] c3 4d c1

; AMD: Copy MTOS to operand
;
; Entry: hl points to operand
; Exit: All registers preserved                    
zsave:
                    push    af                              ;[e599] f5
                    push    bc                              ;[e59a] c5
                    push    de                              ;[e59b] d5
                    push    hl                              ;[e59c] e5
                    call    zget                            ;[e59d] cd 6f e5
                    ld      (hl),a                          ;[e5a0] 77
                    inc     hl                              ;[e5a1] 23
                    ld      (hl),b                          ;[e5a2] 70
                    inc     hl                              ;[e5a3] 23
                    ld      (hl),c                          ;[e5a4] 71
                    inc     hl                              ;[e5a5] 23
                    ld      (hl),d                          ;[e5a6] 72
                    jp      fpexit                          ;[e5a7] c3 4d c1
ENDIF

; Calculate taylor sum
;
; Entry: hl = points to a list of FPT constants (M0, M1, M2)
;        MACC: Constant term of Taylor series (S0)
;        00e3-e6: Initial power of argument (P)
;        00e7-ea: Argument X
;
; Routine computes:
; Sum = S0 + M0 * P + M1*P*X + M2*P*X^2...
;
; Exit: sum-ee: Sum of series
;       00e3-e6: Last P*X^i added in
;       00e7-ea: Preserved
;       MACC + abcd: Sum of series
;       fehl corrupted
poly:
                    push    hl                              ;[e5aa] e5
                    ld      hl,sum                        ;[e5ab] 21 eb 00
                    call    asave                           ;[e5ae] cd d6 e9
                    ld      hl,icbwk                        ;[e5b1] 21 e3 00
                    call    loadfphl                          ;[e5b4] cd fb e9
l1e113:
                    pop     hl                              ;[e5b7] e1
                    push    hl                              ;[e5b8] e5
                    call    amul                            ;[e5b9] cd 59 ea
                    ld      hl,sum                        ;[e5bc] 21 eb 00
                    push    hl                              ;[e5bf] e5
                    call    aadd                            ;[e5c0] cd 72 ea
                    pop     hl                              ;[e5c3] e1
                    call    astore                          ;[e5c4] cd db e9
                    ld      a,(expdf)                       ;[e5c7] 3a de 00
                    or      a                               ;[e5ca] b7
                    jp      p,l1e114                        ;[e5cb] f2 d3 e5
                    cp      $e8                             ;[e5ce] fe e8
                    jp      c,l1e115                        ;[e5d0] da f3 e5
l1e114:
                    pop     hl                              ;[e5d3] e1
                    inc     hl                              ;[e5d4] 23
                    inc     hl                              ;[e5d5] 23
                    inc     hl                              ;[e5d6] 23
                    inc     hl                              ;[e5d7] 23
                    push    hl                              ;[e5d8] e5
                    inc     hl                              ;[e5d9] 23
                    ld      a,(hl)                          ;[e5da] 7e
                    or      a                               ;[e5db] b7
                    jp      p,l1e115                        ;[e5dc] f2 f3 e5
                    ld      hl,icbwk                        ;[e5df] 21 e3 00
                    push    hl                              ;[e5e2] e5
                    call    loadfphl                          ;[e5e3] cd fb e9
                    ld      hl,xk                        ;[e5e6] 21 e7 00
                    call    amul                            ;[e5e9] cd 59 ea
                    pop     hl                              ;[e5ec] e1
                    call    astore                          ;[e5ed] cd db e9
                    jp      l1e113                          ;[e5f0] c3 b7 e5
l1e115:
                    pop     hl                              ;[e5f3] e1
                    call    atest                           ;[e5f4] cd f8 e9
                    ret                                     ;[e5f7] c9

; FPT Sqrt
;
; MACC = SQRT(MACC)
;
; Method: approximation followed by Newton iterations
;
; Let X = 2^(2K)*F then 2^(2K) is exponent and F is matnissa
;
; Then SQRT(X) = 2^K*SQRT(F) 2^K is exp/2
;      SQRT(F) = P(i):
;           1st approx: P(1)= a*F+b
;                       0.5 <= F < 1: values a1 and b1
;                         1 <= F < 2: values a2 and b2
;           Iterations: P(i+1)= P(i)+F/P(i))/2
;      Final SQRT(F): P(3)
;
; Exit: All registers preserved
xsqrt:
                    push    af                              ;[e5f8] f5
                    push    bc                              ;[e5f9] c5
                    push    de                              ;[e5fa] d5
                    push    hl                              ;[e5fb] e5
                    call    tstza                           ;[e5fc] cd f1 eb
                    jp      z,l1e118                        ;[e5ff] ca 3a e6
                    rlca                                    ;[e602] 07
                    jp      c,faser                         ;[e603] da d0 e9
                    rlca                                    ;[e606] 07
                    rrca                                    ;[e607] 0f
                    rra                                     ;[e608] 1f
                    or      a                               ;[e609] b7
                    rra                                     ;[e60a] 1f
                    push    af                              ;[e60b] f5
                    ld      a,$00                           ;[e60c] 3e 00
                    ld      de,l1e277                       ;[e60e] 11 5f e6
                    jp      nc,l1e117                       ;[e611] d2 18 e6
                    inc     a                               ;[e614] 3c
                    ld      de,l1e275                       ;[e615] 11 57 e6
l1e117:
                    ld      (hl),a                          ;[e618] 77
                    push    hl                              ;[e619] e5
                    ld      hl,icbwk                        ;[e61a] 21 e3 00
                    call    xsave                           ;[e61d] cd 1c e1
                    ex      de,hl                           ;[e620] eb
                    push    hl                              ;[e621] e5
                    call    amul                            ;[e622] cd 59 ea
                    pop     hl                              ;[e625] e1
                    inc     hl                              ;[e626] 23
                    inc     hl                              ;[e627] 23
                    inc     hl                              ;[e628] 23
                    inc     hl                              ;[e629] 23
                    call    aadd                            ;[e62a] cd 72 ea
                    call    l1e119                          ;[e62d] cd 3d e6
                    call    l1e119                          ;[e630] cd 3d e6
                    pop     hl                              ;[e633] e1
                    pop     bc                              ;[e634] c1
                    add     b                               ;[e635] 80
                    and     $7f                             ;[e636] e6 7f
                    ld      (hl),a                          ;[e638] 77
                    nop                                     ;[e639] 00
l1e118:
                    jp      fpexit                          ;[e63a] c3 4d c1
; Calculate P(i+1)
l1e119:
                    ld      hl,xk                        ;[e63d] 21 e7 00
                    push    hl                              ;[e640] e5
                    call    astore                          ;[e641] cd db e9
                    ld      hl,icbwk                        ;[e644] 21 e3 00
                    call    loadfphl                          ;[e647] cd fb e9
                    pop     hl                              ;[e64a] e1
                    push    hl                              ;[e64b] e5
                    call    adiv                            ;[e64c] cd 20 ea
                    pop     hl                              ;[e64f] e1
                    call    aadd                            ;[e650] cd 72 ea
                    dec     a                               ;[e653] 3d
                    and     $7f                             ;[e654] e6 7f
                    ret                                     ;[e656] c9



; FPT EXP
;
; MACC = e ^ MACC
;
; Method: Polynomial approximation
xexp:
                    push    af                              ;[e667] f5
                    push    bc                              ;[e668] c5
                    push    de                              ;[e669] d5
                    push    hl                              ;[e66a] e5
                    ld      a,(fpac)                       ;[e66b] 3a d5 00
                    ld      (fatzx),a                       ;[e66e] 32 ef 00
                    call    abs_MACC                          ;[e671] cd ee e9
                    ld      hl,l1e291                       ;[e674] 21 2b e7
                    call    amul                            ;[e677] cd 59 ea
                    call    fppush                          ;[e67a] cd 1e c2
                    call    xfix                            ;[e67d] cd 14 e4
                    call    xget                            ;[e680] cd 33 e1
                    call    fppop                           ;[e683] cd 34 c2
                    or      b                               ;[e686] b0
                    or      c                               ;[e687] b1
                    jp      z,exp_part2                     ;[e688] ca c9 ef
le68b:
                    ld      a,(fatzx)                       ;[e68b] 3a ef 00
                    cpl                                     ;[e68e] 2f
                    or      a                               ;[e68f] b7
                    scf                                     ;[e690] 37
                    jp      l1e126                          ;[e691] c3 f5 e6
l1e121:
                    push    de                              ;[e694] d5
                    call    xfrac                           ;[e695] cd 54 e1
                    ld      de,l1e279                       ;[e698] 11 fb e6
                    ld      hl,(fpac)                      ;[e69b] 2a d5 00
                    or      l                               ;[e69e] b5
                    jp      z,l1e272                         ;[e69f] ca f9 ef
                    cp      $7f                             ;[e6a2] fe 7f
                    jp      c,l1e123                        ;[e6a4] da b8 e6
                    ld      de,l1e280                       ;[e6a7] 11 ff e6
                    jp      l1e123                          ;[e6aa] c3 b8 e6
l1e122:
                    rlca                                    ;[e6ad] 07
                    rlca                                    ;[e6ae] 07
                    ld      de,l1e281                       ;[e6af] 11 03 e7
                    jp      nc,l1e123                       ;[e6b2] d2 b8 e6
                    ld      de,l1e282                       ;[e6b5] 11 07 e7
l1e123:
                    ex      de,hl                           ;[e6b8] eb
                    push    hl                              ;[e6b9] e5
                    call    asub                            ;[e6ba] cd 6d ea
                    ld      e,a                             ;[e6bd] 5f
                    ld      a,(fatzx)                       ;[e6be] 3a ef 00
                    rlca                                    ;[e6c1] 07
                    push    af                              ;[e6c2] f5
                    ld      a,e                             ;[e6c3] 7b
                    call    c,achgs                         ;[e6c4] dc e4 e9
                    ld      hl,icbwk                        ;[e6c7] 21 e3 00
                    call    astore                          ;[e6ca] cd db e9
                    call    astore                          ;[e6cd] cd db e9
                    ld      hl,fp_one                        ;[e6d0] 21 62 c4
                    call    loadfphl                          ;[e6d3] cd fb e9
                    ld      hl,l1e292                       ;[e6d6] 21 2f e7
                    call    poly                            ;[e6d9] cd aa e5
                    pop     af                              ;[e6dc] f1
                    pop     de                              ;[e6dd] d1
                    push    af                              ;[e6de] f5
                    ld      hl,$0010                        ;[e6df] 21 10 00
                    jp      nc,l1e124                       ;[e6e2] d2 e6 e6
                    add     hl,hl                           ;[e6e5] 29
l1e124:
                    add     hl,de                           ;[e6e6] 19
                    call    amul                            ;[e6e7] cd 59 ea
                    pop     af                              ;[e6ea] f1
                    pop     hl                              ;[e6eb] e1
                    ld      a,h                             ;[e6ec] 7c
                    jp      nc,l1e125                       ;[e6ed] d2 f2 e6
                    cpl                                     ;[e6f0] 2f
                    inc     a                               ;[e6f1] 3c
l1e125:
                    call    lc1b7                           ;[e6f2] cd b7 c1
l1e126:
                    call    c,ovunf                         ;[e6f5] dc 4b ea
l1e127:
                    jp      fpexit                          ;[e6f8] c3 4d c1


; FPT LOG
;
; MACC = LN(MACC)
;
; Method: Polynomial expansion
;
; Exit: icbwk-e6: Last significant summand
;       xk-ea: v^2
;       sum-ee: Entry MACC (X)
;       MACC:  Result
; All registers preserved
xln:
                    push    af                              ;[e745] f5
                    push    bc                              ;[e746] c5
                    push    de                              ;[e747] d5
                    push    hl                              ;[e748] e5
                    call    tstza                           ;[e749] cd f1 eb
                    jp      z,faser                         ;[e74c] ca d0 e9
                    or      a                               ;[e74f] b7
                    jp      m,faser                         ;[e750] fa d0 e9
                    call    sext                            ;[e753] cd e9 c1
                    push    af                              ;[e756] f5
                    ld      (hl),$00                        ;[e757] 36 00
                    ld      a,(fpac+1)                       ;[e759] 3a d6 00
                    cp      $b5                             ;[e75c] fe b5
                    jp      nc,flna                         ;[e75e] d2 6a e7
                    ld      hl,fp_two                        ;[e761] 21 66 c4
                    call    amul                            ;[e764] cd 59 ea
                    pop     af                              ;[e767] f1
                    dec     a                               ;[e768] 3d
                    push    af                              ;[e769] f5
flna:
                    ld      hl,fp_one                        ;[e76a] 21 62 c4
                    call    aadd                            ;[e76d] cd 72 ea
                    call    fppush                          ;[e770] cd 1e c2
                    ld      hl,fp_two                        ;[e773] 21 66 c4
                    call    asub                            ;[e776] cd 6d ea
                    ld      hl,$0000                        ;[e779] 21 00 00
                    add     hl,sp                           ;[e77c] 39
                    call    adiv                            ;[e77d] cd 20 ea
                    inc     sp                              ;[e780] 33
                    inc     sp                              ;[e781] 33
                    inc     sp                              ;[e782] 33
                    inc     sp                              ;[e783] 33
                    ld      hl,icbwk                        ;[e784] 21 e3 00
                    call    astore                          ;[e787] cd db e9
                    push    hl                              ;[e78a] e5
                    call    fppush                          ;[e78b] cd 1e c2
                    ld      hl,$0000                        ;[e78e] 21 00 00
l1e273:
                    add     hl,sp                           ;[e791] 39
                    call    amul                            ;[e792] cd 59 ea
                    inc     sp                              ;[e795] 33
                    inc     sp                              ;[e796] 33
                    inc     sp                              ;[e797] 33
                    inc     sp                              ;[e798] 33
                    pop     hl                              ;[e799] e1
                    call    astore                          ;[e79a] cd db e9
                    pop     de                              ;[e79d] d1
                    ld      a,d                             ;[e79e] 7a
                    rla                                     ;[e79f] 17
                    sbc     a                               ;[e7a0] 9f
                    ld      b,a                             ;[e7a1] 47
                    ld      c,a                             ;[e7a2] 4f
                    call    xput                            ;[e7a3] cd 26 e1
                    call    xflt                            ;[e7a6] cd de e3
                    ld      hl,fp_ln2                       ;[e7a9] 21 b8 e7
                    call    amul                            ;[e7ac] cd 59 ea
                    ld      hl,l1e299                       ;[e7af] 21 bc e7
                    call    poly                            ;[e7b2] cd aa e5
                    jp      fpexit                          ;[e7b5] c3 4d c1




; MACC = SIN(MACC)
xsin:
                    push    af                              ;[e7d2] f5
                    push    bc                              ;[e7d3] c5
                    push    de                              ;[e7d4] d5
                    push    hl                              ;[e7d5] e5
                    jp      l1e132                          ;[e7d6] c3 e3 e7

; MACC = COS(MACC)
;
; Method: Polynomial expansion
xcos:
                    push    af                              ;[e7d9] f5
                    push    bc                              ;[e7da] c5
                    push    de                              ;[e7db] d5
                    push    hl                              ;[e7dc] e5
                    ld      hl,fp_halfpi                    ;[e7dd] 21 33 e8
                    call    aadd                            ;[e7e0] cd 72 ea
l1e132:
                    ld      hl,l1e306                       ;[e7e3] 21 3f e8
                    call    adiv                            ;[e7e6] cd 20 ea
                    call    xfrac                           ;[e7e9] cd 54 e1
                    ld      hl,fpac                        ;[e7ec] 21 d5 00
                    ld      a,(hl)                          ;[e7ef] 7e
                    and     $7f                             ;[e7f0] e6 7f
                    jp      z,l1e133                        ;[e7f2] ca fa e7
                    cp      $7e                             ;[e7f5] fe 7e
                    jp      c,l1e134                        ;[e7f7] da 18 e8
l1e133:
                    cp      (hl)                            ;[e7fa] be
                    ld      hl,fp_one                      ;[e7fb] 21 62 c4
                    call    nz,aadd                         ;[e7fe] c4 72 ea
                    ld      hl,fp_quarter                   ;[e801] 21 37 e8
                    push    hl                              ;[e804] e5
                    call    asub                            ;[e805] cd 6d ea
                    call    abs_MACC                          ;[e808] cd ee e9
                    ld      hl,fp_half                      ;[e80b] 21 3b e8
                    call    asub                            ;[e80e] cd 6d ea
                    call    abs_MACC                          ;[e811] cd ee e9
                    pop     hl                              ;[e814] e1
                    call    asub                            ;[e815] cd 6d ea
l1e134:
                    ld      hl,icbwk                        ;[e818] 21 e3 00
                    push    hl                              ;[e81b] e5
                    call    asave                           ;[e81c] cd d6 e9
                    ex      (sp),hl                         ;[e81f] e3
                    call    amul                            ;[e820] cd 59 ea
                    pop     hl                              ;[e823] e1
                    call    astore                          ;[e824] cd db e9
                    call    zero                            ;[e827] cd 16 ea
                    ld      hl,l1e306                       ;[e82a] 21 3f e8
                    call    poly                            ;[e82d] cd aa e5
                    jp      fpexit                          ;[e830] c3 4d c1



xpwr:
                    push    af                              ;[e855] f5
                    push    bc                              ;[e856] c5
                    push    de                              ;[e857] d5
                    push    hl                              ;[e858] e5
                    push    hl                              ;[e859] e5
                    call    atest                           ;[e85a] cd f8 e9
                    pop     hl                              ;[e85d] e1
                    jp      z,xpw10                         ;[e85e] ca 6d e8
                    jp      m,faser                         ;[e861] fa d0 e9
                    call    xln                             ;[e864] cd 45 e7
                    call    amul                            ;[e867] cd 59 ea
                    call    xexp                            ;[e86a] cd 67 e6
xpw10:
                    jp      fpexit                          ;[e86d] c3 4d c1
xlog10:
                    push    af                              ;[e870] f5
                    push    bc                              ;[e871] c5
                    push    de                              ;[e872] d5
                    push    hl                              ;[e873] e5
                    call    xln                             ;[e874] cd 45 e7
                    ld      hl,fp_invln10                   ;[e877] 21 90 e8
                    call    amul                            ;[e87a] cd 59 ea
                    jp      fpexit                          ;[e87d] c3 4d c1

; FLT ALOC
;
; MACC = ALOC(MACC)
;
; Method: 10^x = e^(X*ln10)
;
; Exit: All registers preserved
xalog:
                    push    af                              ;[e880] f5
                    push    bc                              ;[e881] c5
                    push    de                              ;[e882] d5
                    push    hl                              ;[e883] e5
                    ld      hl,fp_invln10                        ;[e884] 21 90 e8
                    call    adiv                            ;[e887] cd 20 ea
                    call    xexp                            ;[e88a] cd 67 e6
                    jp      fpexit                          ;[e88d] c3 4d c1




xtan:
                    push    hl                              ;[e894] e5
                    call    fppush                          ;[e895] cd 1e c2
                    call    xcos                            ;[e898] cd d9 e7
                    ld      hl,fatzx                        ;[e89b] 21 ef 00
                    call    xsave                           ;[e89e] cd 1c e1
                    call    fppop                           ;[e8a1] cd 34 c2
                    call    xsin                            ;[e8a4] cd d2 e7
                    call    xfdiv                           ;[e8a7] cd 08 e1
                    pop     hl                              ;[e8aa] e1
                    ret                                     ;[e8ab] c9

xatan:
                    push    af                              ;[e8ac] f5
                    push    bc                              ;[e8ad] c5
                    push    de                              ;[e8ae] d5
                    push    hl                              ;[e8af] e5
                    call    tstza                           ;[e8b0] cd f1 eb
                    jp      z,l1e145                        ;[e8b3] ca 43 e9
                    push    af                              ;[e8b6] f5
                    call    abs_MACC                          ;[e8b7] cd ee e9
                    ld      hl,fatzx                        ;[e8ba] 21 ef 00
                    call    astore                          ;[e8bd] cd db e9
                    cp      $40                             ;[e8c0] fe 40
                    jp      c,l1e141                        ;[e8c2] da d3 e8
                    cp      $7f                             ;[e8c5] fe 7f
                    ld      a,$01                           ;[e8c7] 3e 01
                    jp      z,l1e143                        ;[e8c9] ca e6 e8
                    ld      hl,fp_zero                      ;[e8cc] 21 5e c4
                    push    hl                              ;[e8cf] e5
                    jp      l1e144                          ;[e8d0] c3 15 e9
l1e141:
                    cp      $01                             ;[e8d3] fe 01
                    ld      a,$02                           ;[e8d5] 3e 02
                    jp      z,l1e143                        ;[e8d7] ca e6 e8
                    jp      nc,l1e142                       ;[e8da] d2 e3 e8
                    ld      a,b                             ;[e8dd] 78
                    rlca                                    ;[e8de] 07
                    rlca                                    ;[e8df] 07
                    ld      a,$01                           ;[e8e0] 3e 01
                    ccf                                     ;[e8e2] 3f
l1e142:
                    ccf                                     ;[e8e3] 3f
                    adc     $00                             ;[e8e4] ce 00
l1e143:
                    add     a                               ;[e8e6] 87
                    add     a                               ;[e8e7] 87
                    add     a                               ;[e8e8] 87
                    ld      hl,fatc1-8                      ;[e8e9] 21 3e e9
                    ld      e,a                             ;[e8ec] 5f
                    ld      d,$00                           ;[e8ed] 16 00
                    add     hl,de                           ;[e8ef] 19
                    push    hl                              ;[e8f0] e5
                    ld      de,$0004                        ;[e8f1] 11 04 00
                    add     hl,de                           ;[e8f4] 19
                    push    hl                              ;[e8f5] e5
                    call    amul                            ;[e8f6] cd 59 ea
                    ld      hl,fp_one                        ;[e8f9] 21 62 c4
                    call    aadd                            ;[e8fc] cd 72 ea
                    ld      hl,fwork                        ;[e8ff] 21 df 00
                    call    astore                          ;[e902] cd db e9
                    ld      hl,fatzx                        ;[e905] 21 ef 00
                    call    loadfphl                          ;[e908] cd fb e9
                    pop     hl                              ;[e90b] e1
                    call    asub                            ;[e90c] cd 6d ea
                    ld      hl,fwork                        ;[e90f] 21 df 00
                    call    adiv                            ;[e912] cd 20 ea
l1e144:
                    ld      hl,fatzx                        ;[e915] 21 ef 00
                    push    hl                              ;[e918] e5
                    push    hl                              ;[e919] e5
                    call    asave                           ;[e91a] cd d6 e9
                    pop     hl                              ;[e91d] e1
                    call    amul                            ;[e91e] cd 59 ea
                    ld      hl,icbwk                        ;[e921] 21 e3 00
                    call    astore                          ;[e924] cd db e9
                    call    astore                          ;[e927] cd db e9
                    ld      hl,fp_one                        ;[e92a] 21 62 c4
                    call    loadfphl                          ;[e92d] cd fb e9
                    ld      hl,fatpl                        ;[e930] 21 5e e9
                    call    poly                            ;[e933] cd aa e5
                    pop     hl                              ;[e936] e1
                    call    amul                            ;[e937] cd 59 ea
                    pop     hl                              ;[e93a] e1
                    call    aadd                            ;[e93b] cd 72 ea
                    pop     af                              ;[e93e] f1
                    or      a                               ;[e93f] b7
                    call    m,achgs                         ;[e940] fc e4 e9
l1e145:
                    jp      fpexit                          ;[e943] c3 4d c1




xasin:
                    push    af                              ;[e96c] f5
                    push    bc                              ;[e96d] c5
                    push    de                              ;[e96e] d5
                    push    hl                              ;[e96f] e5
                    call    atest                           ;[e970] cd f8 e9
                    ld      e,a                             ;[e973] 5f
                    and     $7f                             ;[e974] e6 7f
                    cp      $01                             ;[e976] fe 01
                    jp      c,fas20                         ;[e978] da 99 e9
                    jp      nz,fas10                        ;[e97b] c2 94 e9
                    ld      a,b                             ;[e97e] 78
                    and     $7f                             ;[e97f] e6 7f
                    or      c                               ;[e981] b1
                    or      d                               ;[e982] b2
                    jp      nz,faser                        ;[e983] c2 d0 e9
                    ld      a,e                             ;[e986] 7b
                    or      a                               ;[e987] b7
                    ld      hl,fp_halfpi                    ;[e988] 21 33 e8
                    call    xload                           ;[e98b] cd 12 e1
                    call    m,achgs                         ;[e98e] fc e4 e9
fasret:
                    jp      fpexit                          ;[e991] c3 4d c1
fas10:
                    cp      $40                             ;[e994] fe 40
                    jp      c,faser                         ;[e996] da d0 e9
fas20:
                    call    fppush                          ;[e999] cd 1e c2
                    ld      hl,$0000                        ;[e99c] 21 00 00
                    add     hl,sp                           ;[e99f] 39
                    call    amul                            ;[e9a0] cd 59 ea
                    call    achgs                           ;[e9a3] cd e4 e9
                    ld      hl,fp_one                       ;[e9a6] 21 62 c4
                    call    aadd                            ;[e9a9] cd 72 ea
                    call    xsqrt                           ;[e9ac] cd f8 e5
                    ld      hl,fatzx                        ;[e9af] 21 ef 00
                    call    xsave                           ;[e9b2] cd 1c e1
                    call    fppop                           ;[e9b5] cd 34 c2
                    call    xfdiv                           ;[e9b8] cd 08 e1
                    call    xatan                           ;[e9bb] cd ac e8
                    jp      fasret                          ;[e9be] c3 91 e9
xacos:
                    call    xasin                           ;[e9c1] cd 6c e9
                    call    xfchs                           ;[e9c4] cd 4a e1
                    push    hl                              ;[e9c7] e5
                    ld      hl,fp_halfpi                    ;[e9c8] 21 33 e8
                    call    xfadd                           ;[e9cb] cd aa ed
                    pop     hl                              ;[e9ce] e1
                    ret                                     ;[e9cf] c9

faser:
                    call    fperr_argerror                           ;[e9d0] cd 5e c0
                    jp      fasret                          ;[e9d3] c3 91 e9
asave:
                    push    hl                              ;[e9d6] e5
                    call    atest                           ;[e9d7] cd f8 e9
                    pop     hl                              ;[e9da] e1
astore:
                    ld      (hl),a                          ;[e9db] 77
                    inc     hl                              ;[e9dc] 23
                    ld      (hl),b                          ;[e9dd] 70
                    inc     hl                              ;[e9de] 23
                    ld      (hl),c                          ;[e9df] 71
                    inc     hl                              ;[e9e0] 23
                    ld      (hl),d                          ;[e9e1] 72
                    inc     hl                              ;[e9e2] 23
                    ret                                     ;[e9e3] c9

achgs:
                    call    tstza                           ;[e9e4] cd f1 eb
                    ret     z                               ;[e9e7] c8
                    ld      bc,$ff80                        ;[e9e8] 01 80 ff
                    ; Change sign bit
                    jp      l1e156                          ;[e9eb] c3 f1 e9
abs_MACC:
                    ld      bc,$7f00                        ;[e9ee] 01 00 7f
l1e156:
                    ld      hl,fpac                        ;[e9f1] 21 d5 00
                    ld      a,b                             ;[e9f4] 78
                    and     (hl)                            ;[e9f5] a6
                    xor     c                               ;[e9f6] a9
                    ld      (hl),a                          ;[e9f7] 77
atest:
                    ld      hl,fpac                        ;[e9f8] 21 d5 00
loadfphl:
                    call    tstz                            ;[e9fb] cd f4 eb
                    jp      z,zero                          ;[e9fe] ca 16 ea
                    ld      e,a                             ;[ea01] 5f
                    inc     hl                              ;[ea02] 23
                    ld      b,(hl)                          ;[ea03] 46
                    inc     hl                              ;[ea04] 23
                    ld      c,(hl)                          ;[ea05] 4e
                    inc     hl                              ;[ea06] 23
                    ld      d,(hl)                          ;[ea07] 56
                    ld      hl,fpac                        ;[ea08] 21 d5 00
                    jp      l1e177                          ;[ea0b] c3 17 eb
ldbcde:
                    ld      b,(hl)                          ;[ea0e] 46
                    inc     hl                              ;[ea0f] 23
                    ld      c,(hl)                          ;[ea10] 4e
                    inc     hl                              ;[ea11] 23
                    ld      d,(hl)                          ;[ea12] 56
                    inc     hl                              ;[ea13] 23
                    ld      e,(hl)                          ;[ea14] 5e
                    ret                                     ;[ea15] c9

zero:
                    ld      hl,fpac                        ;[ea16] 21 d5 00
                    xor     a                               ;[ea19] af
                    ld      b,a                             ;[ea1a] 47
                    ld      c,a                             ;[ea1b] 4f
                    ld      d,a                             ;[ea1c] 57
                    jp      astore                          ;[ea1d] c3 db e9
adiv:
                    call    tstz                            ;[ea20] cd f4 eb
                    jp      z,div0                          ;[ea23] ca 54 ea
                    push    af                              ;[ea26] f5
                    and     $80                             ;[ea27] e6 80
                    ld      b,a                             ;[ea29] 47
                    pop     af                              ;[ea2a] f1
                    and     $7f                             ;[ea2b] e6 7f
                    cpl                                     ;[ea2d] 2f
                    inc     a                               ;[ea2e] 3c
                    cp      $c0                             ;[ea2f] fe c0
                    jp      z,overf                         ;[ea31] ca 46 ea
                    and     $7f                             ;[ea34] e6 7f
                    or      b                               ;[ea36] b0
                    call    mdex                            ;[ea37] cd 1d eb
                    jp      c,ovunf                         ;[ea3a] da 4b ea
                    jp      z,zero                          ;[ea3d] ca 16 ea
                    call    divx                            ;[ea40] cd 4a ec
                    jp      nc,add11                        ;[ea43] d2 06 eb
overf:
                    call    fperr_overflow                           ;[ea46] cd 4b c0
                    scf                                     ;[ea49] 37
                    ret                                     ;[ea4a] c9

ovunf:
                    jp      m,overf                         ;[ea4b] fa 46 ea
                    call    fperr_underflow                           ;[ea4e] cd 65 c0
                    jp      zero                            ;[ea51] c3 16 ea
div0:
                    call    fperr_div0                           ;[ea54] cd 6c c0
                    scf                                     ;[ea57] 37
                    ret                                     ;[ea58] c9

amul:
                    call    tstz                            ;[ea59] cd f4 eb
                    call    nz,mdex                         ;[ea5c] c4 1d eb
                    jp      c,ovunf                         ;[ea5f] da 4b ea
                    jp      z,zero                          ;[ea62] ca 16 ea
                    call    mulx                            ;[ea65] cd 00 ec
                    ld      a,b                             ;[ea68] 78
                    or      a                               ;[ea69] b7
                    jp      ad10a                           ;[ea6a] c3 00 eb
asub:
                    ld      b,$80                           ;[ea6d] 06 80
                    jp      ad10                            ;[ea6f] c3 74 ea
aadd:
                    ld      b,$00                           ;[ea72] 06 00
ad10:
                    ld      a,$7f                           ;[ea74] 3e 7f
                    ld      (expdf),a                       ;[ea76] 32 de 00
                    call    tstz                            ;[ea79] cd f4 eb
                    jp      z,atest                         ;[ea7c] ca f8 e9
                    ld      a,b                             ;[ea7f] 78
                    xor     (hl)                            ;[ea80] ae
                    inc     hl                              ;[ea81] 23
                    ld      b,(hl)                          ;[ea82] 46
                    inc     hl                              ;[ea83] 23
                    ld      c,(hl)                          ;[ea84] 4e
                    inc     hl                              ;[ea85] 23
                    ld      d,(hl)                          ;[ea86] 56
                    ld      e,a                             ;[ea87] 5f
                    ld      hl,fpac                        ;[ea88] 21 d5 00
                    ld      a,(hl)                          ;[ea8b] 7e
                    xor     e                               ;[ea8c] ab
                    and     $80                             ;[ea8d] e6 80
                    ld      (sf),a                       ;[ea8f] 32 d9 00
                    call    tstz                            ;[ea92] cd f4 eb
                    jp      z,l1e175                        ;[ea95] ca 11 eb
                    push    de                              ;[ea98] d5
                    ld      a,e                             ;[ea99] 7b
                    call    sext                            ;[ea9a] cd e9 c1
                    ld      e,a                             ;[ea9d] 5f
                    ld      a,(hl)                          ;[ea9e] 7e
                    call    sext                            ;[ea9f] cd e9 c1
                    sub     e                               ;[eaa2] 93
                    pop     de                              ;[eaa3] d1
                    ld      (expdf),a                       ;[eaa4] 32 de 00
                    jp      m,l1e169                        ;[eaa7] fa b2 ea
                    cp      $19                             ;[eaaa] fe 19
                    jp      c,l1e170                        ;[eaac] da c6 ea
                    jp      atest                           ;[eaaf] c3 f8 e9
l1e169:
                    cp      $e7                             ;[eab2] fe e7
                    jp      c,l1e176                        ;[eab4] da 16 eb
                    ld      (hl),e                          ;[eab7] 73
                    cpl                                     ;[eab8] 2f
                    inc     a                               ;[eab9] 3c
                    inc     hl                              ;[eaba] 23
                    ld      e,(hl)                          ;[eabb] 5e
                    ld      (hl),b                          ;[eabc] 70
                    ld      b,e                             ;[eabd] 43
                    inc     hl                              ;[eabe] 23
                    ld      e,(hl)                          ;[eabf] 5e
                    ld      (hl),c                          ;[eac0] 71
                    ld      c,e                             ;[eac1] 4b
                    inc     hl                              ;[eac2] 23
                    ld      e,(hl)                          ;[eac3] 5e
                    ld      (hl),d                          ;[eac4] 72
                    ld      d,e                             ;[eac5] 53
l1e170:
                    ld      e,$00                           ;[eac6] 1e 00
                    call    rshn                            ;[eac8] cd 55 eb
                    ld      a,(sf)                       ;[eacb] 3a d9 00
                    or      a                               ;[eace] b7
                    ld      hl,fpac+3                        ;[eacf] 21 d8 00
                    jp      m,l1e171                        ;[ead2] fa ef ea
                    ld      a,(hl)                          ;[ead5] 7e
                    add     d                               ;[ead6] 82
                    ld      d,a                             ;[ead7] 57
                    dec     hl                              ;[ead8] 2b
                    ld      a,(hl)                          ;[ead9] 7e
                    adc     c                               ;[eada] 89
                    ld      c,a                             ;[eadb] 4f
                    dec     hl                              ;[eadc] 2b
                    ld      a,(hl)                          ;[eadd] 7e
                    adc     b                               ;[eade] 88
                    ld      b,a                             ;[eadf] 47
                    jp      nc,add11                        ;[eae0] d2 06 eb
                    call    l1e188                          ;[eae3] cd 70 eb
                    call    l1e198                          ;[eae6] cd d9 eb
                    jp      c,overf                         ;[eae9] da 46 ea
                    jp      add11                           ;[eaec] c3 06 eb
l1e171:
                    xor     a                               ;[eaef] af
                    sub     e                               ;[eaf0] 93
                    ld      e,a                             ;[eaf1] 5f
                    ld      a,(hl)                          ;[eaf2] 7e
                    sbc     d                               ;[eaf3] 9a
                    ld      d,a                             ;[eaf4] 57
                    dec     hl                              ;[eaf5] 2b
                    ld      a,(hl)                          ;[eaf6] 7e
                    sbc     c                               ;[eaf7] 99
                    ld      c,a                             ;[eaf8] 4f
                    dec     hl                              ;[eaf9] 2b
                    ld      a,(hl)                          ;[eafa] 7e
                    sbc     b                               ;[eafb] 98
                    ld      b,a                             ;[eafc] 47
                    call    c,l1e189                        ;[eafd] dc 7d eb
ad10a:
                    call    p,l1e191                        ;[eb00] f4 96 eb
                    jp      p,zero                          ;[eb03] f2 16 ea
add11:
                    call    l1e196                          ;[eb06] cd c3 eb
                    jp      c,overf                         ;[eb09] da 46 ea
l1e174:
                    ld      a,e                             ;[eb0c] 7b
                    or      $01                             ;[eb0d] f6 01
                    ld      a,e                             ;[eb0f] 7b
                    ret                                     ;[eb10] c9

l1e175:
                    ld      a,$80                           ;[eb11] 3e 80
                    ld      (expdf),a                       ;[eb13] 32 de 00
l1e176:
                    ld      a,e                             ;[eb16] 7b
l1e177:
                    call    astore                          ;[eb17] cd db e9
                    jp      l1e174                          ;[eb1a] c3 0c eb
mdex:
                    ld      b,a                             ;[eb1d] 47
                    inc     hl                              ;[eb1e] 23
                    ld      c,(hl)                          ;[eb1f] 4e
                    inc     hl                              ;[eb20] 23
                    ld      d,(hl)                          ;[eb21] 56
                    inc     hl                              ;[eb22] 23
                    ld      e,(hl)                          ;[eb23] 5e
                    call    tstza                           ;[eb24] cd f1 eb
                    ret     z                               ;[eb27] c8
                    ld      a,b                             ;[eb28] 78
                    call    sext                            ;[eb29] cd e9 c1
                    call    addexp                          ;[eb2c] cd ba c1
                    ret     c                               ;[eb2f] d8
                    ld      a,b                             ;[eb30] 78
                    and     $80                             ;[eb31] e6 80
                    xor     (hl)                            ;[eb33] ae
                    ld      (hl),a                          ;[eb34] 77
                    ld      a,$01                           ;[eb35] 3e 01
                    or      a                               ;[eb37] b7
                    ret                                     ;[eb38] c9

lshn:
                    push    af                              ;[eb39] f5
                    ld      l,a                             ;[eb3a] 6f
l1e180:
                    dec     l                               ;[eb3b] 2d
                    jp      m,l1e182                        ;[eb3c] fa 46 eb
                    or      a                               ;[eb3f] b7
                    call    l1e183                          ;[eb40] cd 48 eb
                    jp      l1e180                          ;[eb43] c3 3b eb
l1e182:
                    pop     af                              ;[eb46] f1
                    ret                                     ;[eb47] c9

l1e183:
                    ld      a,e                             ;[eb48] 7b
                    rla                                     ;[eb49] 17
                    ld      e,a                             ;[eb4a] 5f
                    ld      a,d                             ;[eb4b] 7a
                    rla                                     ;[eb4c] 17
                    ld      d,a                             ;[eb4d] 57
                    ld      a,c                             ;[eb4e] 79
                    rla                                     ;[eb4f] 17
                    ld      c,a                             ;[eb50] 4f
                    ld      a,b                             ;[eb51] 78
                    adc     a                               ;[eb52] 8f
                    ld      b,a                             ;[eb53] 47
                    ret                                     ;[eb54] c9

rshn:
                    ld      l,$08                           ;[eb55] 2e 08
l1e185:
                    cp      l                               ;[eb57] bd
                    jp      m,l1e186                        ;[eb58] fa 64 eb
                    ld      e,d                             ;[eb5b] 5a
                    ld      d,c                             ;[eb5c] 51
                    ld      c,b                             ;[eb5d] 48
                    ld      b,$00                           ;[eb5e] 06 00
                    sub     l                               ;[eb60] 95
                    jp      nz,l1e185                       ;[eb61] c2 57 eb
l1e186:
                    or      a                               ;[eb64] b7
                    ret     z                               ;[eb65] c8
                    ld      l,a                             ;[eb66] 6f
l1e187:
                    or      a                               ;[eb67] b7
                    call    l1e188                          ;[eb68] cd 70 eb
                    dec     l                               ;[eb6b] 2d
                    jp      nz,l1e187                       ;[eb6c] c2 67 eb
                    ret                                     ;[eb6f] c9

l1e188:
                    ld      a,b                             ;[eb70] 78
                    rra                                     ;[eb71] 1f
                    ld      b,a                             ;[eb72] 47
                    ld      a,c                             ;[eb73] 79
                    rra                                     ;[eb74] 1f
                    ld      c,a                             ;[eb75] 4f
                    ld      a,d                             ;[eb76] 7a
                    rra                                     ;[eb77] 1f
                    ld      d,a                             ;[eb78] 57
                    ld      a,e                             ;[eb79] 7b
                    rra                                     ;[eb7a] 1f
                    ld      e,a                             ;[eb7b] 5f
                    ret                                     ;[eb7c] c9

l1e189:
                    dec     hl                              ;[eb7d] 2b
                    ld      a,(hl)                          ;[eb7e] 7e
                    xor     $80                             ;[eb7f] ee 80
                    ld      (hl),a                          ;[eb81] 77
l1e190:
                    xor     a                               ;[eb82] af
                    ld      l,a                             ;[eb83] 6f
                    sub     e                               ;[eb84] 93
                    ld      e,a                             ;[eb85] 5f
                    ld      a,l                             ;[eb86] 7d
                    sbc     d                               ;[eb87] 9a
                    ld      d,a                             ;[eb88] 57
                    ld      a,l                             ;[eb89] 7d
                    sbc     c                               ;[eb8a] 99
                    ld      c,a                             ;[eb8b] 4f
                    ld      a,l                             ;[eb8c] 7d
                    sbc     b                               ;[eb8d] 98
                    ld      l,a                             ;[eb8e] 6f
                    and     b                               ;[eb8f] a0
                    rla                                     ;[eb90] 17
                    ld      b,l                             ;[eb91] 45
                    ld      a,l                             ;[eb92] 7d
                    rra                                     ;[eb93] 1f
                    adc     a                               ;[eb94] 8f
                    ret                                     ;[eb95] c9

l1e191:
                    call    l1e192                          ;[eb96] cd a0 eb
                    call    nc,lc1b7                        ;[eb99] d4 b7 c1
                    ccf                                     ;[eb9c] 3f
                    rra                                     ;[eb9d] 1f
                    or      a                               ;[eb9e] b7
                    ret                                     ;[eb9f] c9

l1e192:
                    push    hl                              ;[eba0] e5
                    ld      l,$20                           ;[eba1] 2e 20
l1e193:
                    ld      a,b                             ;[eba3] 78
                    or      a                               ;[eba4] b7
                    jp      nz,l1e195                       ;[eba5] c2 ba eb
                    ld      b,c                             ;[eba8] 41
                    ld      c,d                             ;[eba9] 4a
                    ld      d,e                             ;[ebaa] 53
                    ld      e,a                             ;[ebab] 5f
                    ld      a,l                             ;[ebac] 7d
                    sub     $08                             ;[ebad] d6 08
                    ld      l,a                             ;[ebaf] 6f
                    jp      nz,l1e193                       ;[ebb0] c2 a3 eb
                    pop     hl                              ;[ebb3] e1
                    scf                                     ;[ebb4] 37
                    ret                                     ;[ebb5] c9

l1e194:
                    dec     l                               ;[ebb6] 2d
                    call    l1e183                          ;[ebb7] cd 48 eb
l1e195:
                    jp      p,l1e194                        ;[ebba] f2 b6 eb
                    ld      a,l                             ;[ebbd] 7d
                    sub     $20                             ;[ebbe] d6 20
                    or      a                               ;[ebc0] b7
                    pop     hl                              ;[ebc1] e1
                    ret                                     ;[ebc2] c9

l1e196:
                    ld      a,e                             ;[ebc3] 7b
                    or      a                               ;[ebc4] b7
                    call    m,l1e197                        ;[ebc5] fc d1 eb
                    ret     c                               ;[ebc8] d8
                    ld      hl,fpac                        ;[ebc9] 21 d5 00
                    ld      e,(hl)                          ;[ebcc] 5e
                    ld      a,(hl)                          ;[ebcd] 7e
                    jp      astore                          ;[ebce] c3 db e9
l1e197:
                    inc     d                               ;[ebd1] 14
                    ret     nz                              ;[ebd2] c0
                    inc     c                               ;[ebd3] 0c
                    ret     nz                              ;[ebd4] c0
                    inc     b                               ;[ebd5] 04
                    ret     nz                              ;[ebd6] c0
                    ld      b,$80                           ;[ebd7] 06 80
l1e198:
                    push    bc                              ;[ebd9] c5
                    push    af                              ;[ebda] f5
                    push    hl                              ;[ebdb] e5
                    ld      a,$01                           ;[ebdc] 3e 01
l1e199:
                    ld      hl,fpac                        ;[ebde] 21 d5 00
                    call    addexp                          ;[ebe1] cd ba c1
                    pop     hl                              ;[ebe4] e1
                    pop     bc                              ;[ebe5] c1
                    ld      a,b                             ;[ebe6] 78
                    pop     bc                              ;[ebe7] c1
                    ret                                     ;[ebe8] c9

l1e274:
                    push    bc                              ;[ebe9] c5
                    push    af                              ;[ebea] f5
                    push    hl                              ;[ebeb] e5
                    ld      a,$ff                           ;[ebec] 3e ff
                    jp      l1e199                          ;[ebee] c3 de eb
tstza:
                    ld      hl,fpac                        ;[ebf1] 21 d5 00
tstz:
                    ld      a,(hl)                          ;[ebf4] 7e
                    inc     hl                              ;[ebf5] 23
                    or      (hl)                            ;[ebf6] b6
                    inc     hl                              ;[ebf7] 23
                    or      (hl)                            ;[ebf8] b6
                    inc     hl                              ;[ebf9] 23
                    or      (hl)                            ;[ebfa] b6
                    dec     hl                              ;[ebfb] 2b
                    dec     hl                              ;[ebfc] 2b
                    dec     hl                              ;[ebfd] 2b
                    ld      a,(hl)                          ;[ebfe] 7e
                    ret                                     ;[ebff] c9

mulx:
                    ld      a,c                             ;[ec00] 79
                    ld      (dp1),a                       ;[ec01] 32 dd 00
                    ld      h,d                             ;[ec04] 62
                    ld      l,e                             ;[ec05] 6b
                    ld      (dp3),hl                      ;[ec06] 22 db 00
                    xor     a                               ;[ec09] af
                    ld      d,a                             ;[ec0a] 57
                    ld      c,a                             ;[ec0b] 4f
                    ld      b,a                             ;[ec0c] 47
                    ld      a,(fpac+3)                       ;[ec0d] 3a d8 00
                    call    l1e203                          ;[ec10] cd 1c ec
                    ld      a,(fpac+2)                       ;[ec13] 3a d7 00
                    call    l1e203                          ;[ec16] cd 1c ec
                    ld      a,(fpac+1)                       ;[ec19] 3a d6 00
l1e203:
                    ld      l,d                             ;[ec1c] 6a
                    ld      e,c                             ;[ec1d] 59
                    ld      d,b                             ;[ec1e] 50
                    ld      b,a                             ;[ec1f] 47
                    xor     a                               ;[ec20] af
                    ld      c,a                             ;[ec21] 4f
                    sub     b                               ;[ec22] 90
                    jp      c,l1e204                        ;[ec23] da 29 ec
                    ld      c,d                             ;[ec26] 4a
                    ld      d,e                             ;[ec27] 53
                    ret                                     ;[ec28] c9

l1e204:
                    ld      a,l                             ;[ec29] 7d
                    adc     a                               ;[ec2a] 8f
                    ret     z                               ;[ec2b] c8
                    ld      l,a                             ;[ec2c] 6f
                    call    l1e183                          ;[ec2d] cd 48 eb
                    jp      nc,l1e204                       ;[ec30] d2 29 ec
                    ld      a,(dp3)                       ;[ec33] 3a db 00
                    add     e                               ;[ec36] 83
                    ld      e,a                             ;[ec37] 5f
                    ld      a,(dp2)                       ;[ec38] 3a dc 00
                    adc     d                               ;[ec3b] 8a
                    ld      d,a                             ;[ec3c] 57
                    ld      a,(dp1)                       ;[ec3d] 3a dd 00
                    adc     c                               ;[ec40] 89
                    ld      c,a                             ;[ec41] 4f
                    jp      nc,l1e204                       ;[ec42] d2 29 ec
                    inc     b                               ;[ec45] 04
                    or      a                               ;[ec46] b7
                    jp      l1e204                          ;[ec47] c3 29 ec
divx:
                    ld      hl,fpac+3                        ;[ec4a] 21 d8 00
                    ld      a,(hl)                          ;[ec4d] 7e
                    sub     e                               ;[ec4e] 93
                    ld      (hl),a                          ;[ec4f] 77
                    dec     hl                              ;[ec50] 2b
                    ld      a,(hl)                          ;[ec51] 7e
                    sbc     d                               ;[ec52] 9a
                    ld      (hl),a                          ;[ec53] 77
                    dec     hl                              ;[ec54] 2b
                    ld      a,(hl)                          ;[ec55] 7e
                    sbc     c                               ;[ec56] 99
                    ld      (hl),a                          ;[ec57] 77
                    ld      hl,dp1                        ;[ec58] 21 dd 00
                    scf                                     ;[ec5b] 37
                    ld      a,c                             ;[ec5c] 79
                    rra                                     ;[ec5d] 1f
                    ld      (hl),a                          ;[ec5e] 77
                    dec     hl                              ;[ec5f] 2b
                    ld      a,d                             ;[ec60] 7a
                    rra                                     ;[ec61] 1f
                    ld      (hl),a                          ;[ec62] 77
                    dec     hl                              ;[ec63] 2b
                    ld      a,e                             ;[ec64] 7b
                    rra                                     ;[ec65] 1f
                    ld      (hl),a                          ;[ec66] 77
                    dec     hl                              ;[ec67] 2b
                    ld      b,$00                           ;[ec68] 06 00
                    ld      a,b                             ;[ec6a] 78
                    rra                                     ;[ec6b] 1f
                    ld      (hl),a                          ;[ec6c] 77
                    ld      hl,fpac+1                        ;[ec6d] 21 d6 00
                    ld      a,(hl)                          ;[ec70] 7e
                    inc     hl                              ;[ec71] 23
                    ld      d,(hl)                          ;[ec72] 56
                    inc     hl                              ;[ec73] 23
                    ld      e,(hl)                          ;[ec74] 5e
                    or      a                               ;[ec75] b7
                    jp      m,l1e209                        ;[ec76] fa c4 ec
                    call    l1e198                          ;[ec79] cd d9 eb
                    ret     c                               ;[ec7c] d8
                    ld      l,e                             ;[ec7d] 6b
                    ld      h,d                             ;[ec7e] 62
                    ld      e,a                             ;[ec7f] 5f
                    ld      d,$01                           ;[ec80] 16 01
                    ld      c,b                             ;[ec82] 48
l1e206:
                    push    bc                              ;[ec83] c5
                    ld      b,h                             ;[ec84] 44
                    ld      c,l                             ;[ec85] 4d
                    ld      hl,dp4                        ;[ec86] 21 da 00
                    xor     a                               ;[ec89] af
                    sub     (hl)                            ;[ec8a] 96
                    inc     hl                              ;[ec8b] 23
                    ld      a,c                             ;[ec8c] 79
                    sbc     (hl)                            ;[ec8d] 9e
                    ld      c,a                             ;[ec8e] 4f
                    inc     hl                              ;[ec8f] 23
                    ld      a,b                             ;[ec90] 78
                    sbc     (hl)                            ;[ec91] 9e
                    ld      b,a                             ;[ec92] 47
                    inc     hl                              ;[ec93] 23
                    ld      a,e                             ;[ec94] 7b
                    sbc     (hl)                            ;[ec95] 9e
                    ld      e,a                             ;[ec96] 5f
                    ld      l,c                             ;[ec97] 69
                    ld      h,b                             ;[ec98] 60
                    pop     bc                              ;[ec99] c1
l1e207:
                    ld      a,(dp4)                       ;[ec9a] 3a da 00
lec9d:
                    rlca                                    ;[ec9d] 07
                    ld      a,b                             ;[ec9e] 78
                    rla                                     ;[ec9f] 17
                    ccf                                     ;[eca0] 3f
                    ret     nc                              ;[eca1] d0
                    rra                                     ;[eca2] 1f
                    ld      a,l                             ;[eca3] 7d
                    rla                                     ;[eca4] 17
                    ld      l,a                             ;[eca5] 6f
                    ld      a,h                             ;[eca6] 7c
                    rla                                     ;[eca7] 17
                    ld      h,a                             ;[eca8] 67
                    call    l1e183                          ;[eca9] cd 48 eb
                    ld      a,d                             ;[ecac] 7a
                    rrca                                    ;[ecad] 0f
                    jp      c,l1e206                        ;[ecae] da 83 ec
l1e208:
                    push    bc                              ;[ecb1] c5
                    ld      b,h                             ;[ecb2] 44
                    ld      c,l                             ;[ecb3] 4d
                    ld      hl,(dp3)                      ;[ecb4] 2a db 00
                    add     hl,bc                           ;[ecb7] 09
                    ld      a,(dp1)                       ;[ecb8] 3a dd 00
                    adc     e                               ;[ecbb] 8b
                    ld      e,a                             ;[ecbc] 5f
                    pop     bc                              ;[ecbd] c1
                    ld      a,(dp4)                       ;[ecbe] 3a da 00
                    jp      lec9d                           ;[ecc1] c3 9d ec
l1e209:
                    ld      l,e                             ;[ecc4] 6b
                    ld      h,d                             ;[ecc5] 62
                    ld      e,a                             ;[ecc6] 5f
                    ld      d,b                             ;[ecc7] 50
                    ld      c,b                             ;[ecc8] 48
                    jp      l1e208                          ;[ecc9] c3 b1 ec
mpt15:
                    ld      a,(hl)                          ;[eccc] 7e
                    inc     hl                              ;[eccd] 23
                    ld      ($fb02),a                       ;[ecce] 32 02 fb
                    ret                                     ;[ecd1] c9

mpt16:
                    push    af                              ;[ecd2] f5
                    xor     a                               ;[ecd3] af
                    ld      ($fb02),a                       ;[ecd4] 32 02 fb
                    pop     af                              ;[ecd7] f1
                    ret                                     ;[ecd8] c9

mpt17:
                    ld      ($fb00),a                       ;[ecd9] 32 00 fb
                    pop     af                              ;[ecdc] f1
                    ld      ($fb00),a                       ;[ecdd] 32 00 fb
                    ret                                     ;[ece0] c9

l1e213:
                    call    l1e51                           ;[ece1] cd 8c e3
                    call    siand                           ;[ece4] cd 35 e3
                    jp      l1e49                           ;[ece7] c3 85 e3
l1e214:
                    call    l1e51                           ;[ecea] cd 8c e3
                    call    sior                            ;[eced] cd 4c e3
                    jp      l1e49                           ;[ecf0] c3 85 e3
l1e215:
                    call    l1e51                           ;[ecf3] cd 8c e3
                    call    sixor                           ;[ecf6] cd 63 e3
                    jp      l1e49                           ;[ecf9] c3 85 e3
l1e216:
                    call    xget                            ;[ecfc] cd 33 e1
                    cpl                                     ;[ecff] 2f
                    ret                                     ;[ed00] c9

l1e217:
                    call    xget                            ;[ed01] cd 33 e1
igp10:
                    ld      e,a                             ;[ed04] 5f
                    jp      l1e52                           ;[ed05] c3 8f e3
l1e219:
                    call    xstst                           ;[ed08] cd b2 e3
                    call    z,l1e59                         ;[ed0b] cc d6 e3
                    ret                                     ;[ed0e] c9

IF MATH_AM9511
l1e220:
                    push    af                              ;[ed0f] f5
                    call    zget                            ;[ed10] cd 6f e5
ENDIF

gbc10:
                    ld      e,d                             ;[ed13] 5a
                    ld      d,c                             ;[ed14] 51
                    ld      c,b                             ;[ed15] 48
                    ld      b,a                             ;[ed16] 47
                    pop     af                              ;[ed17] f1
                    ret                                     ;[ed18] c9

IF MATH_AM9511
ziand:
                    push    af                              ;[ed19] f5
                    push    bc                              ;[ed1a] c5
                    push    de                              ;[ed1b] d5
                    push    hl                              ;[ed1c] e5
                    call    zigtp                           ;[ed1d] cd 4f ed
                    call    siand                           ;[ed20] cd 35 e3
                    jp      zort1                           ;[ed23] c3 3d ed
zior:
                    push    af                              ;[ed26] f5
                    push    bc                              ;[ed27] c5
                    push    de                              ;[ed28] d5
                    push    hl                              ;[ed29] e5
                    call    zigtp                           ;[ed2a] cd 4f ed
                    call    sior                            ;[ed2d] cd 4c e3
                    jp      zort1                           ;[ed30] c3 3d ed
zixor:
                    push    af                              ;[ed33] f5
                    push    bc                              ;[ed34] c5
                    push    de                              ;[ed35] d5
                    push    hl                              ;[ed36] e5
                    call    zigtp                           ;[ed37] cd 4f ed
                    call    sixor                           ;[ed3a] cd 63 e3
zort1:
                    call    zput                            ;[ed3d] cd 5f e5
                    jp      fpexit                          ;[ed40] c3 4d c1
zinot:
                    call    zichs                           ;[ed43] cd 22 e5
                    push    hl                              ;[ed46] e5
                    ld      hl,fp_one                       ;[ed47] 21 20 c4
                    call    ziadd                           ;[ed4a] cd f4 e4
                    pop     hl                              ;[ed4d] e1
                    ret                                     ;[ed4e] c9

zigtp:
                    call    zget                            ;[ed4f] cd 6f e5
                    jp      igp10                           ;[ed52] c3 04 ed
zshr:
                    push    af                              ;[ed55] f5
                    push    bc                              ;[ed56] c5
                    push    de                              ;[ed57] d5
                    push    hl                              ;[ed58] e5
                    call    xstst                           ;[ed59] cd b2 e3
                    call    z,zgbcde                        ;[ed5c] cc 7c ed
                    call    rshn                            ;[ed5f] cd 55 eb
zrreg:
                    ld      a,b                             ;[ed62] 78
                    ld      b,c                             ;[ed63] 41
                    ld      c,d                             ;[ed64] 4a
                    ld      d,e                             ;[ed65] 53
                    call    zput                            ;[ed66] cd 5f e5
                    jp      fpexit                          ;[ed69] c3 4d c1
zshl:
                    push    af                              ;[ed6c] f5
                    push    bc                              ;[ed6d] c5
                    push    de                              ;[ed6e] d5
                    push    hl                              ;[ed6f] e5
                    call    xstst                           ;[ed70] cd b2 e3
                    call    z,zgbcde                        ;[ed73] cc 7c ed
                    call    lshn                            ;[ed76] cd 39 eb
                    jp      zrreg                           ;[ed79] c3 62 ed
zgbcde:
                    push    af                              ;[ed7c] f5
                    call    zget                            ;[ed7d] cd 6f e5
                    jp      gbc10                           ;[ed80] c3 13 ed
ENDIF


l1e232:
                    ld      a,b                             ;[ed83] 78
                    or      c                               ;[ed84] b1
                    or      d                               ;[ed85] b2
                    or      e                               ;[ed86] b3
                    ret                                     ;[ed87] c9

l1e233:
                    push    af                              ;[ed88] f5
                    call    m,l1e57                         ;[ed89] fc c9 e3
                    pop     af                              ;[ed8c] f1
                    or      a                               ;[ed8d] b7
                    ret                                     ;[ed8e] c9

l1e234:
                    ld      a,(fpac)                       ;[ed8f] 3a d5 00
                    ld      b,a                             ;[ed92] 47
                    xor     (hl)                            ;[ed93] ae
                    ret                                     ;[ed94] c9

IF MATH_AM9511
mfstat:
                    call    opi                             ;[ed95] cd 2d e5
                    defb    $37
                    call    opi                             ;[ed99] cd 2d e5
                    defb    $38
                    ld      a,($fb02)
                    ret                                     ;[eda0] c9

zpwr:
                    call    mfstat                          ;[eda1] cd 95 ed
                    and     $20                             ;[eda4] e6 20
                    ret     nz                              ;[eda6] c0
                    jp      mpr14                           ;[eda7] c3 ac e4
ENDIF


xfadd:
                    push    af                              ;[edaa] f5
                    push    bc                              ;[edab] c5
                    push    de                              ;[edac] d5
                    push    hl                              ;[edad] e5
                    call    aadd                            ;[edae] cd 72 ea
                    jp      fpexit                          ;[edb1] c3 4d c1
; FPT subtraction
; MACC = MACC - MEM
;
; Entry: hl points to fp number in memory
; Exit: all registers preserved
xfsub:
                    push    af                              ;[edb4] f5
                    push    bc                              ;[edb5] c5
                    push    de                              ;[edb6] d5
                    push    hl                              ;[edb7] e5
                    call    asub                            ;[edb8] cd 6d ea
                    jp      fpexit                          ;[edbb] c3 4d c1




;Part of exp
exp_part2:
                    ld      a,d                             ;[efc9] 7a
                    and     $c0                             ;[efca] e6 c0
                    jp      nz,le68b                        ;[efcc] c2 8b e6
                    jp      l1e121                          ;[efcf] c3 94 e6

;Part of exp
l1e272:
                    or      h                               ;[eff9] b4
                    jp      p,l1e123                        ;[effa] f2 b8 e6
                    jp      l1e122                          ;[effd] c3 ad e6


            SECTION rodata_fp_dai32

; Constants for xexp (RODATA)
l1e279:
                    defb    $7e, $80, $00, $00          ;FPT(1/8)
l1e280:
                    defb    $7f, $c0, $00, $00          ;FPT(3/8)

l1e281:
                    defb    $00, $a0, $00, $00          ;FPT(5/8)

l1e282:
                    defb    $00, $e0, $00, $00          ;FPT(7/8)

l1e283:
                    defb    $01, $8b, $95, $c2          ;2 ^(1/8)
                    defb    $01, $a5, $fe, $d7          ;2 ^(3/8)
                    defb    $01, $c5, $67, $2a          ;2 ^(5/8)
                    defb    $01, $ea, $c0, $c7          ;2 ^(7/8)

l1e287:
                    defb    $00, $ea, $c0, $c7          ;2 ^(-1/8)
                    defb    $00, $c5, $67, $2a          ;2 ^(-3/8)
                    defb    $00, $a5, $fe, $d7          ;2 ^(-5/8)
                    defb    $00, $8b, $95, $c2          ;2 ^(-7/8)

l1e291:
                    defb    $01, $b8, $aa, $3b          ;1 / LN2

l1e292:
                    defb    $00, $b1, $72, $18          ;a1: LN2,         -> 0.69314718057
                    defb    $7e, $f4, $fd, $ef          ;a2: ((LN2)^2)/2! -> 0.24022648580
                    defb    $7c, $e3, $58, $46          ;a3: ((LN2)^3)/3! -> 0.055504105406
                    defb    $7a, $9d, $a4, $b1          ;a4: ((LN2)^4)/4! -> 0.0096217389747
                    defb    $77, $aa, $d1, $fe          ;a5: ((LN2)^5)/5! -> 0.0013337729375
                    defb    $00, $00                    ;end of table


; Constants for xsqrt (RODATA)
l1e275:
                    defb    $7f, $d2, $d0, $1c          ;a1: 0.578125
                    defb    $00, $99, $ee, $14          ;b1: 0.421875

l1e277:
                    defb    $00, $94, $00, $00          ;a2: 0.411744
                    defb    $7f, $d8, $00, $00          ;b2: 0.601289
                   
; Constants for xatn
fatc1:
                    defb    $7f, $e5, $c8, $fa              ;a(1): PI/7      -> 0.4487978506
                    defb    $7f, $f6, $90, $f3              ;b(1): TAN(a(1)) -> 0.4815746188
                    defb    $00, $e5, $c8, $fa              ;a(2): 2* PI/7   -> 0.8975979011
                    defb    $01, $a0, $81, $c6              ;b(2): TAN(a(2)) -> 1.253960337
                    defb    $01, $ac, $56, $bb              ;a(3): 3* PI/7   -> 1.346396852
                    defb    $03, $8c, $33, $7f              ;b(3): TAN(a(3)) -> 4.381286272

fatpl:
                    defb    $ff, $aa, $aa, $2d              ;Q1: ~-1/3   -> -0.333329573
                    defb    $7e, $cc, $6e, $b3              ;Q2 ~1/5     -> 0.199641035
                    defb    $fe, $86, $f1, $4f              ;Q3 ~-1/7    -> -0.131779888
                    defb    $00, $00                        ;end of table

fp_halfpi:
                    defb    $01, $c9, $0f, $db              ; PI / 2

fp_quarter:         defb    $7f, $80, $00, $00              ; 0.25
fp_half:            defb    $00, $80, $00, $00              ; 0.5

l1e306:             defb    $03, $c9, $0f, $db              ;a1: ~PI/2         -> 6.2831853
                    defb    $86, $a5, $5d, $e2              ;a2: ~-(PI*2)^3/3! -> -41.341681
                    defb    $07, $a3, $34, $7b              ;a3: ~(PI*2)^5/5!  -> 81.602481
                    defb    $87, $99, $29, $9e              ;a4: ~-(PI*2)^7/7! -> -76.581285
                    defb    $06, $9f, $0a, $fb              ;a5: ~(PI*2)^9/9!  -> 39.760722
                    defb    $00, $00                        ;End of table


fp_invln10:         defb    $7f, $de, $5b, $d9              ;1/ln(10)

fp_tenth:           defb    $7d, $cc, $cc, $cd              ;0.1

fp_zero:            defb    $00, $00, $00, $00              ;0
fp_one:             defb    $01, $80, $00, $00              ;1.0 (c462)
fp_two:             defb    $02, $80, $00, $00              ;2.0 (c466)

; Data Constants for LN (RODATA)
fp_ln2:
                    defb    $00, $b1, $72, $18              ;LN(2)

l1e299:             defb    $02, $80, $00, $00              ;b1: 2.0
                    defb    $00, $aa, $aa, $a9              ;b2: ~2/3 -> 0.666666564181
                    defb    $7f, $cc, $cf, $45              ;b5: ~2/5 -> 0.400018840613
                    defb    $7f, $91, $ae, $ab              ;b7: ~2/7 -> 0.2845357266
                    defb    $7e, $80, $00, $00              ;b9: ~2/9 -> 0.125
                    defb    $00, $00                        ;End of table



            SECTION bss_fp_dai32

error_vector:   defw    0               ;0xd0

___dai32_fpac:
fpac:       defb    0,0,0,0             ;0xd5-d8
sf:         defb    0                   ;0xd9
dp4:        defb    0                   ;0xda
dp3:        defb    0                   ;0xdb
dp2:        defb    0                   ;0xdc
dp1:        defb    0                   ;0xdd
expdf:      defb    0                   ;0xde
fwork:      defb    0,0                 ;0xdf,e0
xphls:      defb    0,0                 ;0xe1,e2

decbuf:                                 ;0xe3-f1 - number output buffer
icbwk:                                  ;0xe3-e6 - number input buffer
f:
xn:         defb    0,0,0,0             ;0xe3-e6
p:
xk:         defb    0,0,0,0             ;0xe7-ea
sum:        defb    0,0,0,0             ;0xeb-ee
rsign:       
ftwrk:
fatzx:
            defb    0,0,0,0               ;0xef-f2
; TODO: Decimal buffer
