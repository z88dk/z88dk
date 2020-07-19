
    MODULE  fpcomp
    GLOBAL  fpcomp
    GLOBAL  xget



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

 