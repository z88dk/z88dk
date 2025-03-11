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
 cpd                            ; CD @__z80asm__cpd
 cpdr                           ; CD @__z80asm__cpdr
 cpi                            ; CD @__z80asm__cpi
 cpir                           ; CD @__z80asm__cpir
 daa                            ; CD @__z80asm__daa
 dsub                           ; CD @__z80asm__sub_hl_bc
 lda 0x1234                     ; 3A 34 12
 ldax b                         ; 0A
 ldax d                         ; 1A
 ldd                            ; CD @__z80asm__ldd
 lddr                           ; CD @__z80asm__lddr
 ldi                            ; CD @__z80asm__ldi
 ldir                           ; CD @__z80asm__ldir
 lhld 0x1234                    ; 2A 34 12
 lxi b, 0x1234                  ; 01 34 12
 lxi d, 0x1234                  ; 11 34 12
 lxi h, 0x1234                  ; 21 34 12
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
 pop b                          ; C1
 pop d                          ; D1
 pop h                          ; E1
 pop psw                        ; F1
 push b                         ; C5
 push d                         ; D5
 push h                         ; E5
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
 stax d                         ; 12
 sub hl, bc                     ; CD @__z80asm__sub_hl_bc
 sub hl, de                     ; CD @__z80asm__sub_hl_de
 sub hl, hl                     ; CD @__z80asm__sub_hl_hl
 sub hl, sp                     ; CD @__z80asm__sub_hl_sp
 xchg                           ; EB
