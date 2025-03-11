 adc hl, bc                     ; CD @__z80asm__adc_hl_bc
 adc hl, de                     ; CD @__z80asm__adc_hl_de
 adc hl, hl                     ; CD @__z80asm__adc_hl_hl
 adc hl, sp                     ; CD @__z80asm__adc_hl_sp
 add bc, a                      ; CD @__z80asm__add_bc_a
 add de, a                      ; CD @__z80asm__add_de_a
 add hl, a                      ; CD @__z80asm__add_hl_a
 add sp, -128                   ; CD @__z80asm__add_sp_s 80
 add sp, 0                      ; CD @__z80asm__add_sp_s 00
 add sp, 126                    ; CD @__z80asm__add_sp_s 7E
 arhl                           ; CD @__z80asm__sra_hl
 call (hl)                      ; CD @__z80asm__call_hl
 call (ix)                      ; CD @__z80asm__call_iy
 call (iy)                      ; CD @__z80asm__call_ix
 clr (hl)                       ; 36 00
 clr a                          ; 3E 00
 clr b                          ; 06 00
 clr bc                         ; 01 00 00
 clr c                          ; 0E 00
 clr d                          ; 16 00
 clr de                         ; 11 00 00
 clr e                          ; 1E 00
 clr h                          ; 26 00
 clr hl                         ; 21 00 00
 clr ix                         ; FD 21 00 00
 clr ixh                        ; FD 26 00
 clr ixl                        ; FD 2E 00
 clr iy                         ; DD 21 00 00
 clr iyh                        ; DD 26 00
 clr iyl                        ; DD 2E 00
 clr l                          ; 2E 00
 cpd                            ; CD @__z80asm__cpd
 cpdr                           ; CD @__z80asm__cpdr
 cpi                            ; CD @__z80asm__cpi
 cpir                           ; CD @__z80asm__cpir
 daa                            ; CD @__z80asm__daa
 dsub                           ; CD @__z80asm__sub_hl_bc
 ex (sp), hl                    ; CD @__z80asm__ex_sp_hl
 ex bc, hl                      ; E5 C5 E1 C1
 ex de, hl                      ; EB
 ex hl, bc                      ; E5 C5 E1 C1
 ex hl, de                      ; EB
 jp (hl)                        ; E9
 jp (ix)                        ; FD E9
 jp (iy)                        ; DD E9
 ld (0x1234), a                 ; 32 34 12
 ld (0x1234), bc                ; E5 60 69 22 34 12 E1
 ld (0x1234), de                ; EB 22 34 12 EB
 ld (0x1234), hl                ; 22 34 12
 ld (0x1234), ix                ; FD 22 34 12
 ld (0x1234), iy                ; DD 22 34 12
 ld (bc), a                     ; 02
 ld (de), -128                  ; EB 36 80 EB
 ld (de), 0                     ; EB 36 00 EB
 ld (de), 127                   ; EB 36 7F EB
 ld (de), 255                   ; EB 36 FF EB
 ld (de), a                     ; 12
 ld (de), b                     ; EB 70 EB
 ld (de), c                     ; EB 71 EB
 ld (de), d                     ; EB 74 EB
 ld (de), e                     ; EB 75 EB
 ld (de), h                     ; EB 72 EB
 ld (de), l                     ; EB 73 EB
 ld (hl), -128                  ; 36 80
 ld (hl), 0                     ; 36 00
 ld (hl), 127                   ; 36 7F
 ld (hl), 255                   ; 36 FF
 ld (hl), a                     ; 77
 ld (hl), b                     ; 70
 ld (hl), c                     ; 71
 ld (hl), d                     ; 72
 ld (hl), e                     ; 73
 ld (hl), h                     ; 74
 ld (hl), l                     ; 75
 ld (ix), a                     ; FD 77 00
 ld (ix), b                     ; FD 70 00
 ld (ix), c                     ; FD 71 00
 ld (ix), d                     ; FD 72 00
 ld (ix), e                     ; FD 73 00
 ld (ix), h                     ; FD 74 00
 ld (ix), l                     ; FD 75 00
 ld (ix+0), a                   ; FD 77 00
 ld (ix+0), b                   ; FD 70 00
 ld (ix+0), c                   ; FD 71 00
 ld (ix+0), d                   ; FD 72 00
 ld (ix+0), e                   ; FD 73 00
 ld (ix+0), h                   ; FD 74 00
 ld (ix+0), l                   ; FD 75 00
 ld (ix+126), a                 ; FD 77 7E
 ld (ix+126), b                 ; FD 70 7E
 ld (ix+126), c                 ; FD 71 7E
 ld (ix+126), d                 ; FD 72 7E
 ld (ix+126), e                 ; FD 73 7E
 ld (ix+126), h                 ; FD 74 7E
 ld (ix+126), l                 ; FD 75 7E
 ld (ix-128), a                 ; FD 77 80
 ld (ix-128), b                 ; FD 70 80
 ld (ix-128), c                 ; FD 71 80
 ld (ix-128), d                 ; FD 72 80
 ld (ix-128), e                 ; FD 73 80
 ld (ix-128), h                 ; FD 74 80
 ld (ix-128), l                 ; FD 75 80
 ld (iy), a                     ; DD 77 00
 ld (iy), b                     ; DD 70 00
 ld (iy), c                     ; DD 71 00
 ld (iy), d                     ; DD 72 00
 ld (iy), e                     ; DD 73 00
 ld (iy), h                     ; DD 74 00
 ld (iy), l                     ; DD 75 00
 ld (iy+0), a                   ; DD 77 00
 ld (iy+0), b                   ; DD 70 00
 ld (iy+0), c                   ; DD 71 00
 ld (iy+0), d                   ; DD 72 00
 ld (iy+0), e                   ; DD 73 00
 ld (iy+0), h                   ; DD 74 00
 ld (iy+0), l                   ; DD 75 00
 ld (iy+126), a                 ; DD 77 7E
 ld (iy+126), b                 ; DD 70 7E
 ld (iy+126), c                 ; DD 71 7E
 ld (iy+126), d                 ; DD 72 7E
 ld (iy+126), e                 ; DD 73 7E
 ld (iy+126), h                 ; DD 74 7E
 ld (iy+126), l                 ; DD 75 7E
 ld (iy-128), a                 ; DD 77 80
 ld (iy-128), b                 ; DD 70 80
 ld (iy-128), c                 ; DD 71 80
 ld (iy-128), d                 ; DD 72 80
 ld (iy-128), e                 ; DD 73 80
 ld (iy-128), h                 ; DD 74 80
 ld (iy-128), l                 ; DD 75 80
 ld a, (0x1234)                 ; 3A 34 12
 ld a, (bc)                     ; 0A
 ld a, (de)                     ; 1A
 ld a, (hl)                     ; 7E
 ld a, (ix)                     ; FD 7E 00
 ld a, (ix+0)                   ; FD 7E 00
 ld a, (ix+126)                 ; FD 7E 7E
 ld a, (ix-128)                 ; FD 7E 80
 ld a, (iy)                     ; DD 7E 00
 ld a, (iy+0)                   ; DD 7E 00
 ld a, (iy+126)                 ; DD 7E 7E
 ld a, (iy-128)                 ; DD 7E 80
 ld a, -128                     ; 3E 80
 ld a, 0                        ; 3E 00
 ld a, 127                      ; 3E 7F
 ld a, 255                      ; 3E FF
 ld a, a                        ; 7F
 ld a, b                        ; 78
 ld a, c                        ; 79
 ld a, d                        ; 7A
 ld a, e                        ; 7B
 ld a, h                        ; 7C
 ld a, ixh                      ; FD 7C
 ld a, ixl                      ; FD 7D
 ld a, iyh                      ; DD 7C
 ld a, iyl                      ; DD 7D
 ld a, l                        ; 7D
 ld b, (de)                     ; EB 46 EB
 ld b, (hl)                     ; 46
 ld b, (ix)                     ; FD 46 00
 ld b, (ix+0)                   ; FD 46 00
 ld b, (ix+126)                 ; FD 46 7E
 ld b, (ix-128)                 ; FD 46 80
 ld b, (iy)                     ; DD 46 00
 ld b, (iy+0)                   ; DD 46 00
 ld b, (iy+126)                 ; DD 46 7E
 ld b, (iy-128)                 ; DD 46 80
 ld b, -128                     ; 06 80
 ld b, 0                        ; 06 00
 ld b, 127                      ; 06 7F
 ld b, 255                      ; 06 FF
 ld b, a                        ; 47
 ld b, b                        ; 40
 ld b, c                        ; 41
 ld b, d                        ; 42
 ld b, e                        ; 43
 ld b, h                        ; 44
 ld b, ixh                      ; FD 44
 ld b, ixl                      ; FD 45
 ld b, iyh                      ; DD 44
 ld b, iyl                      ; DD 45
 ld b, l                        ; 45
 ld bc, (0x1234)                ; E5 2A 34 12 44 4D E1
 ld bc, 0x1234                  ; 01 34 12
 ld bc, de                      ; 42 4B
 ld bc, hl                      ; 44 4D
 ld c, (de)                     ; EB 4E EB
 ld c, (hl)                     ; 4E
 ld c, (ix)                     ; FD 4E 00
 ld c, (ix+0)                   ; FD 4E 00
 ld c, (ix+126)                 ; FD 4E 7E
 ld c, (ix-128)                 ; FD 4E 80
 ld c, (iy)                     ; DD 4E 00
 ld c, (iy+0)                   ; DD 4E 00
 ld c, (iy+126)                 ; DD 4E 7E
 ld c, (iy-128)                 ; DD 4E 80
 ld c, -128                     ; 0E 80
 ld c, 0                        ; 0E 00
 ld c, 127                      ; 0E 7F
 ld c, 255                      ; 0E FF
 ld c, a                        ; 4F
 ld c, b                        ; 48
 ld c, c                        ; 49
 ld c, d                        ; 4A
 ld c, e                        ; 4B
 ld c, h                        ; 4C
 ld c, ixh                      ; FD 4C
 ld c, ixl                      ; FD 4D
 ld c, iyh                      ; DD 4C
 ld c, iyl                      ; DD 4D
 ld c, l                        ; 4D
 ld d, (de)                     ; EB 66 EB
 ld d, (hl)                     ; 56
 ld d, (ix)                     ; FD 56 00
 ld d, (ix+0)                   ; FD 56 00
 ld d, (ix+126)                 ; FD 56 7E
 ld d, (ix-128)                 ; FD 56 80
 ld d, (iy)                     ; DD 56 00
 ld d, (iy+0)                   ; DD 56 00
 ld d, (iy+126)                 ; DD 56 7E
 ld d, (iy-128)                 ; DD 56 80
 ld d, -128                     ; 16 80
 ld d, 0                        ; 16 00
 ld d, 127                      ; 16 7F
 ld d, 255                      ; 16 FF
 ld d, a                        ; 57
 ld d, b                        ; 50
 ld d, c                        ; 51
 ld d, d                        ; 52
 ld d, e                        ; 53
 ld d, h                        ; 54
 ld d, ixh                      ; FD 54
 ld d, ixl                      ; FD 55
 ld d, iyh                      ; DD 54
 ld d, iyl                      ; DD 55
 ld d, l                        ; 55
 ld de, (0x1234)                ; EB 2A 34 12 EB
 ld de, 0x1234                  ; 11 34 12
 ld de, bc                      ; 50 59
 ld de, hl                      ; 54 5D
 ld e, (de)                     ; EB 6E EB
 ld e, (hl)                     ; 5E
 ld e, (ix)                     ; FD 5E 00
 ld e, (ix+0)                   ; FD 5E 00
 ld e, (ix+126)                 ; FD 5E 7E
 ld e, (ix-128)                 ; FD 5E 80
 ld e, (iy)                     ; DD 5E 00
 ld e, (iy+0)                   ; DD 5E 00
 ld e, (iy+126)                 ; DD 5E 7E
 ld e, (iy-128)                 ; DD 5E 80
 ld e, -128                     ; 1E 80
 ld e, 0                        ; 1E 00
 ld e, 127                      ; 1E 7F
 ld e, 255                      ; 1E FF
 ld e, a                        ; 5F
 ld e, b                        ; 58
 ld e, c                        ; 59
 ld e, d                        ; 5A
 ld e, e                        ; 5B
 ld e, h                        ; 5C
 ld e, ixh                      ; FD 5C
 ld e, ixl                      ; FD 5D
 ld e, iyh                      ; DD 5C
 ld e, iyl                      ; DD 5D
 ld e, l                        ; 5D
 ld h, (de)                     ; EB 56 EB
 ld h, (hl)                     ; 66
 ld h, (ix)                     ; FD 66 00
 ld h, (ix+0)                   ; FD 66 00
 ld h, (ix+126)                 ; FD 66 7E
 ld h, (ix-128)                 ; FD 66 80
 ld h, (iy)                     ; DD 66 00
 ld h, (iy+0)                   ; DD 66 00
 ld h, (iy+126)                 ; DD 66 7E
 ld h, (iy-128)                 ; DD 66 80
 ld h, -128                     ; 26 80
 ld h, 0                        ; 26 00
 ld h, 127                      ; 26 7F
 ld h, 255                      ; 26 FF
 ld h, a                        ; 67
 ld h, b                        ; 60
 ld h, c                        ; 61
 ld h, d                        ; 62
 ld h, e                        ; 63
 ld h, h                        ; 64
 ld h, l                        ; 65
 ld hl, (0x1234)                ; 2A 34 12
 ld hl, 0x1234                  ; 21 34 12
 ld hl, bc                      ; 60 69
 ld hl, de                      ; 62 6B
 ld ix, (0x1234)                ; FD 2A 34 12
 ld ix, 0x1234                  ; FD 21 34 12
 ld ixh, -128                   ; FD 26 80
 ld ixh, 0                      ; FD 26 00
 ld ixh, 127                    ; FD 26 7F
 ld ixh, 255                    ; FD 26 FF
 ld ixh, a                      ; FD 67
 ld ixh, b                      ; FD 60
 ld ixh, c                      ; FD 61
 ld ixh, d                      ; FD 62
 ld ixh, e                      ; FD 63
 ld ixh, ixh                    ; FD 64
 ld ixh, ixl                    ; FD 65
 ld ixl, -128                   ; FD 2E 80
 ld ixl, 0                      ; FD 2E 00
 ld ixl, 127                    ; FD 2E 7F
 ld ixl, 255                    ; FD 2E FF
 ld ixl, a                      ; FD 6F
 ld ixl, b                      ; FD 68
 ld ixl, c                      ; FD 69
 ld ixl, d                      ; FD 6A
 ld ixl, e                      ; FD 6B
 ld ixl, ixh                    ; FD 6C
 ld ixl, ixl                    ; FD 6D
 ld iy, (0x1234)                ; DD 2A 34 12
 ld iy, 0x1234                  ; DD 21 34 12
 ld iyh, -128                   ; DD 26 80
 ld iyh, 0                      ; DD 26 00
 ld iyh, 127                    ; DD 26 7F
 ld iyh, 255                    ; DD 26 FF
 ld iyh, a                      ; DD 67
 ld iyh, b                      ; DD 60
 ld iyh, c                      ; DD 61
 ld iyh, d                      ; DD 62
 ld iyh, e                      ; DD 63
 ld iyh, iyh                    ; DD 64
 ld iyh, iyl                    ; DD 65
 ld iyl, -128                   ; DD 2E 80
 ld iyl, 0                      ; DD 2E 00
 ld iyl, 127                    ; DD 2E 7F
 ld iyl, 255                    ; DD 2E FF
 ld iyl, a                      ; DD 6F
 ld iyl, b                      ; DD 68
 ld iyl, c                      ; DD 69
 ld iyl, d                      ; DD 6A
 ld iyl, e                      ; DD 6B
 ld iyl, iyh                    ; DD 6C
 ld iyl, iyl                    ; DD 6D
 ld l, (de)                     ; EB 5E EB
 ld l, (hl)                     ; 6E
 ld l, (ix)                     ; FD 6E 00
 ld l, (ix+0)                   ; FD 6E 00
 ld l, (ix+126)                 ; FD 6E 7E
 ld l, (ix-128)                 ; FD 6E 80
 ld l, (iy)                     ; DD 6E 00
 ld l, (iy+0)                   ; DD 6E 00
 ld l, (iy+126)                 ; DD 6E 7E
 ld l, (iy-128)                 ; DD 6E 80
 ld l, -128                     ; 2E 80
 ld l, 0                        ; 2E 00
 ld l, 127                      ; 2E 7F
 ld l, 255                      ; 2E FF
 ld l, a                        ; 6F
 ld l, b                        ; 68
 ld l, c                        ; 69
 ld l, d                        ; 6A
 ld l, e                        ; 6B
 ld l, h                        ; 6C
 ld l, l                        ; 6D
 ld sp, 0x1234                  ; 31 34 12
 lda 0x1234                     ; 3A 34 12
 ldax b                         ; 0A
 ldax bc                        ; 0A
 ldax d                         ; 1A
 ldax de                        ; 1A
 ldd                            ; CD @__z80asm__ldd
 lddr                           ; CD @__z80asm__lddr
 ldi                            ; CD @__z80asm__ldi
 ldir                           ; CD @__z80asm__ldir
 lhld 0x1234                    ; 2A 34 12
 lxi b, 0x1234                  ; 01 34 12
 lxi bc, 0x1234                 ; 01 34 12
 lxi d, 0x1234                  ; 11 34 12
 lxi de, 0x1234                 ; 11 34 12
 lxi h, 0x1234                  ; 21 34 12
 lxi hl, 0x1234                 ; 21 34 12
 lxi sp, 0x1234                 ; 31 34 12
 mov a, a                       ; 7F
 mov a, b                       ; 78
 mov a, c                       ; 79
 mov a, d                       ; 7A
 mov a, e                       ; 7B
 mov a, h                       ; 7C
 mov a, l                       ; 7D
 mov a, m                       ; 7E
 mov b, a                       ; 47
 mov b, b                       ; 40
 mov b, c                       ; 41
 mov b, d                       ; 42
 mov b, e                       ; 43
 mov b, h                       ; 44
 mov b, l                       ; 45
 mov b, m                       ; 46
 mov c, a                       ; 4F
 mov c, b                       ; 48
 mov c, c                       ; 49
 mov c, d                       ; 4A
 mov c, e                       ; 4B
 mov c, h                       ; 4C
 mov c, l                       ; 4D
 mov c, m                       ; 4E
 mov d, a                       ; 57
 mov d, b                       ; 50
 mov d, c                       ; 51
 mov d, d                       ; 52
 mov d, e                       ; 53
 mov d, h                       ; 54
 mov d, l                       ; 55
 mov d, m                       ; 56
 mov e, a                       ; 5F
 mov e, b                       ; 58
 mov e, c                       ; 59
 mov e, d                       ; 5A
 mov e, e                       ; 5B
 mov e, h                       ; 5C
 mov e, l                       ; 5D
 mov e, m                       ; 5E
 mov h, a                       ; 67
 mov h, b                       ; 60
 mov h, c                       ; 61
 mov h, d                       ; 62
 mov h, e                       ; 63
 mov h, h                       ; 64
 mov h, l                       ; 65
 mov h, m                       ; 66
 mov l, a                       ; 6F
 mov l, b                       ; 68
 mov l, c                       ; 69
 mov l, d                       ; 6A
 mov l, e                       ; 6B
 mov l, h                       ; 6C
 mov l, l                       ; 6D
 mov l, m                       ; 6E
 mov m, a                       ; 77
 mov m, b                       ; 70
 mov m, c                       ; 71
 mov m, d                       ; 72
 mov m, e                       ; 73
 mov m, h                       ; 74
 mov m, l                       ; 75
 mvi a, -128                    ; 3E 80
 mvi a, 0                       ; 3E 00
 mvi a, 127                     ; 3E 7F
 mvi a, 255                     ; 3E FF
 mvi b, -128                    ; 06 80
 mvi b, 0                       ; 06 00
 mvi b, 127                     ; 06 7F
 mvi b, 255                     ; 06 FF
 mvi c, -128                    ; 0E 80
 mvi c, 0                       ; 0E 00
 mvi c, 127                     ; 0E 7F
 mvi c, 255                     ; 0E FF
 mvi d, -128                    ; 16 80
 mvi d, 0                       ; 16 00
 mvi d, 127                     ; 16 7F
 mvi d, 255                     ; 16 FF
 mvi e, -128                    ; 1E 80
 mvi e, 0                       ; 1E 00
 mvi e, 127                     ; 1E 7F
 mvi e, 255                     ; 1E FF
 mvi h, -128                    ; 26 80
 mvi h, 0                       ; 26 00
 mvi h, 127                     ; 26 7F
 mvi h, 255                     ; 26 FF
 mvi l, -128                    ; 2E 80
 mvi l, 0                       ; 2E 00
 mvi l, 127                     ; 2E 7F
 mvi l, 255                     ; 2E FF
 mvi m, -128                    ; 36 80
 mvi m, 0                       ; 36 00
 mvi m, 127                     ; 36 7F
 mvi m, 255                     ; 36 FF
 pchl                           ; E9
 pop af                         ; F1
 pop b                          ; C1
 pop bc                         ; C1
 pop d                          ; D1
 pop de                         ; D1
 pop h                          ; E1
 pop hl                         ; E1
 pop ix                         ; FD E1
 pop iy                         ; DD E1
 pop psw                        ; F1
 push af                        ; F5
 push b                         ; C5
 push bc                        ; C5
 push d                         ; D5
 push de                        ; D5
 push h                         ; E5
 push hl                        ; E5
 push ix                        ; FD E5
 push iy                        ; DD E5
 push psw                       ; F5
 rdel                           ; CD @__z80asm__rl_de
 rl bc                          ; CD @__z80asm__rl_bc
 rl de                          ; CD @__z80asm__rl_de
 rl hl                          ; CD @__z80asm__rl_hl
 rld                            ; CD @__z80asm__rld
 rlde                           ; CD @__z80asm__rl_de
 rr bc                          ; CD @__z80asm__rr_bc
 rr de                          ; CD @__z80asm__rr_de
 rr hl                          ; CD @__z80asm__rr_hl
 rrd                            ; CD @__z80asm__rrd
 rrhl                           ; CD @__z80asm__sra_hl
 sbc hl, bc                     ; CD @__z80asm__sbc_hl_bc
 sbc hl, de                     ; CD @__z80asm__sbc_hl_de
 sbc hl, hl                     ; CD @__z80asm__sbc_hl_hl
 sbc hl, sp                     ; CD @__z80asm__sbc_hl_sp
 shld 0x1234                    ; 22 34 12
 sra bc                         ; CD @__z80asm__sra_bc
 sra de                         ; CD @__z80asm__sra_de
 sra hl                         ; CD @__z80asm__sra_hl
 sta 0x1234                     ; 32 34 12
 stax b                         ; 02
 stax bc                        ; 02
 stax d                         ; 12
 stax de                        ; 12
 sub hl, bc                     ; CD @__z80asm__sub_hl_bc
 sub hl, de                     ; CD @__z80asm__sub_hl_de
 sub hl, hl                     ; CD @__z80asm__sub_hl_hl
 sub hl, sp                     ; CD @__z80asm__sub_hl_sp
 xchg                           ; EB
 xthl                           ; CD @__z80asm__ex_sp_hl
