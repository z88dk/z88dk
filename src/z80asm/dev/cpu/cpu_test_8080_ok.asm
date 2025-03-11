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
 clr l                          ; 2E 00
 cpd                            ; CD @__z80asm__cpd
 cpdr                           ; CD @__z80asm__cpdr
 cpi                            ; CD @__z80asm__cpi
 cpir                           ; CD @__z80asm__cpir
 daa                            ; CD @__z80asm__daa
 dsub                           ; CD @__z80asm__sub_hl_bc
 ex bc, hl                      ; E5 C5 E1 C1
 ex de, hl                      ; EB
 ex hl, bc                      ; E5 C5 E1 C1
 ex hl, de                      ; EB
 jp (hl)                        ; E9
 ld (0x1234), a                 ; 32 34 12
 ld (0x1234), bc                ; E5 60 69 22 34 12 E1
 ld (0x1234), de                ; EB 22 34 12 EB
 ld (0x1234), hl                ; 22 34 12
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
 ld a, (0x1234)                 ; 3A 34 12
 ld a, (bc)                     ; 0A
 ld a, (de)                     ; 1A
 ld a, (hl)                     ; 7E
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
 ld a, l                        ; 7D
 ld b, (de)                     ; EB 46 EB
 ld b, (hl)                     ; 46
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
 ld b, l                        ; 45
 ld bc, (0x1234)                ; E5 2A 34 12 44 4D E1
 ld bc, 0x1234                  ; 01 34 12
 ld bc, de                      ; 42 4B
 ld bc, hl                      ; 44 4D
 ld c, (de)                     ; EB 4E EB
 ld c, (hl)                     ; 4E
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
 ld c, l                        ; 4D
 ld d, (de)                     ; EB 66 EB
 ld d, (hl)                     ; 56
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
 ld d, l                        ; 55
 ld de, (0x1234)                ; EB 2A 34 12 EB
 ld de, 0x1234                  ; 11 34 12
 ld de, bc                      ; 50 59
 ld de, hl                      ; 54 5D
 ld e, (de)                     ; EB 6E EB
 ld e, (hl)                     ; 5E
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
 ld e, l                        ; 5D
 ld h, (de)                     ; EB 56 EB
 ld h, (hl)                     ; 66
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
 ld l, (de)                     ; EB 5E EB
 ld l, (hl)                     ; 6E
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
 pop psw                        ; F1
 push af                        ; F5
 push b                         ; C5
 push bc                        ; C5
 push d                         ; D5
 push de                        ; D5
 push h                         ; E5
 push hl                        ; E5
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
