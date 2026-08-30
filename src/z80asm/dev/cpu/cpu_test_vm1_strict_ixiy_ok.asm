 aci 0                          ; CE 00
 aci 127                        ; CE 7F
 aci 255                        ; CE FF
 adc a                          ; 8F
 adc b                          ; 88
 adc c                          ; 89
 adc d                          ; 8A
 adc e                          ; 8B
 adc h                          ; 8C
 adc h'                         ; 38 8C
 adc hl', bc                    ; 38 28 09
 adc hl', de                    ; 38 28 19
 adc hl', hl'                   ; 38 28 29
 adc hl', sp                    ; 38 28 39
 adc hl, bc                     ; 28 09
 adc hl, de                     ; 28 19
 adc hl, hl                     ; 28 29
 adc hl, sp                     ; 28 39
 adc l                          ; 8D
 adc l'                         ; 38 8D
 adc m                          ; 8E
 add a                          ; 87
 add b                          ; 80
 add c                          ; 81
 add d                          ; 82
 add e                          ; 83
 add h                          ; 84
 add h'                         ; 38 84
 add l                          ; 85
 add l'                         ; 38 85
 add m                          ; 86
 adi 0                          ; C6 00
 adi 127                        ; C6 7F
 adi 255                        ; C6 FF
 ana a                          ; A7
 ana b                          ; A0
 ana c                          ; A1
 ana d                          ; A2
 ana e                          ; A3
 ana h                          ; A4
 ana h'                         ; 38 A4
 ana l                          ; A5
 ana l'                         ; 38 A5
 ana m                          ; A6
 andl (hl')                     ; 38 10
 andl (hl)                      ; 10
 andm                           ; 10
 ani 0                          ; E6 00
 ani 127                        ; E6 7F
 ani 255                        ; E6 FF
 anx                            ; 10
 call 0x1234                    ; CD 34 12
 cc 0x1234                      ; DC 34 12
 cm 0x1234                      ; FC 34 12
 cma                            ; 2F
 cmc                            ; 3F
 cmp a                          ; BF
 cmp b                          ; B8
 cmp c                          ; B9
 cmp d                          ; BA
 cmp e                          ; BB
 cmp h                          ; BC
 cmp h'                         ; 38 BC
 cmp l                          ; BD
 cmp l'                         ; 38 BD
 cmp m                          ; BE
 cnc 0x1234                     ; D4 34 12
 cnz 0x1234                     ; C4 34 12
 cp 0x1234                      ; F4 34 12
 cp hl', bc                     ; 38 CB
 cp hl', de                     ; 38 DD
 cp hl, bc                      ; CB
 cp hl, de                      ; DD
 cpc hl', bc                    ; 38 28 CB
 cpc hl', de                    ; 38 28 DD
 cpc hl, bc                     ; 28 CB
 cpc hl, de                     ; 28 DD
 cpe 0x1234                     ; EC 34 12
 cpi 0                          ; FE 00
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpo 0x1234                     ; E4 34 12
 cz 0x1234                      ; CC 34 12
 daa                            ; 27
 dad b                          ; 09
 dad d                          ; 19
 dad h                          ; 29
 dad h'                         ; 38 29
 dad sp                         ; 39
 dcmp b                         ; CB
 dcmp bc                        ; CB
 dcmp d                         ; DD
 dcmp de                        ; DD
 dcr a                          ; 3D
 dcr b                          ; 05
 dcr c                          ; 0D
 dcr d                          ; 15
 dcr e                          ; 1D
 dcr h                          ; 25
 dcr h'                         ; 38 25
 dcr l                          ; 2D
 dcr l'                         ; 38 2D
 dcr m                          ; 35
 dcx b                          ; 0B
 dcx d                          ; 1B
 dcx h                          ; 2B
 dcx h'                         ; 38 2B
 dcx sp                         ; 3B
 di                             ; F3
 dsub b                         ; 08
 dsub bc                        ; 08
 dsub d                         ; 18
 dsub de                        ; 18
 ei                             ; FB
 hlt                            ; 76
 in 0                           ; DB 00
 in 127                         ; DB 7F
 in 255                         ; DB FF
 inr a                          ; 3C
 inr b                          ; 04
 inr c                          ; 0C
 inr d                          ; 14
 inr e                          ; 1C
 inr h                          ; 24
 inr h'                         ; 38 24
 inr l                          ; 2C
 inr l'                         ; 38 2C
 inr m                          ; 34
 inx b                          ; 03
 inx d                          ; 13
 inx h                          ; 23
 inx h'                         ; 38 23
 inx sp                         ; 33
 j_of 0x1234                    ; FD 34 12
 jc 0x1234                      ; DA 34 12
 jm 0x1234                      ; FA 34 12
 jmp 0x1234                     ; C3 34 12
 jmp of, 0x1234                 ; FD 34 12
 jnc 0x1234                     ; D2 34 12
 jnz 0x1234                     ; C2 34 12
 jof 0x1234                     ; FD 34 12
 jp 0x1234                      ; F2 34 12
 jp of, 0x1234                  ; FD 34 12
 jpe 0x1234                     ; EA 34 12
 jpo 0x1234                     ; E2 34 12
 jz 0x1234                      ; CA 34 12
 ld (de), hl                    ; D9
 ld (de), hl'                   ; 38 D9
 ld (hl'), and (hl')            ; 38 10
 ld (hl'), or (hl')             ; 38 20
 ld (hl'), xor (hl')            ; 38 30
 ld (hl), and (hl)              ; 10
 ld (hl), or (hl)               ; 20
 ld (hl), xor (hl)              ; 30
 ld hl', (de)                   ; 38 ED
 ld hl, (de)                    ; ED
 lda 0x1234                     ; 3A 34 12
 ldax b                         ; 0A
 ldax d                         ; 1A
 lhld 0x1234                    ; 2A 34 12
 lhlde                          ; ED
 lhlx                           ; ED
 lxi b, 0x1234                  ; 01 34 12
 lxi d, 0x1234                  ; 11 34 12
 lxi h', 0x1234                 ; 38 21 34 12
 lxi h, 0x1234                  ; 21 34 12
 lxi sp, 0x1234                 ; 31 34 12
 mb adc m                       ; 28 8E
 mb add m                       ; 28 86
 mb ana m                       ; 28 A6
 mb andl (hl')                  ; 28 38 10
 mb andl (hl)                   ; 28 10
 mb call 0x1234                 ; 28 CD 34 12
 mb cc 0x1234                   ; 28 DC 34 12
 mb cm 0x1234                   ; 28 FC 34 12
 mb cmp m                       ; 28 BE
 mb cnc 0x1234                  ; 28 D4 34 12
 mb cnz 0x1234                  ; 28 C4 34 12
 mb cpe 0x1234                  ; 28 EC 34 12
 mb cpo 0x1234                  ; 28 E4 34 12
 mb cz 0x1234                   ; 28 CC 34 12
 mb dcr m                       ; 28 35
 mb inr m                       ; 28 34
 mb ld (de), hl                 ; 28 D9
 mb ld (de), hl'                ; 28 38 D9
 mb ld (hl'), and (hl')         ; 28 38 10
 mb ld (hl'), or (hl')          ; 28 38 20
 mb ld (hl'), xor (hl')         ; 28 38 30
 mb ld (hl), and (hl)           ; 28 10
 mb ld (hl), or (hl)            ; 28 20
 mb ld (hl), xor (hl)           ; 28 30
 mb ld hl', (de)                ; 28 38 ED
 mb ld hl, (de)                 ; 28 ED
 mb lda 0x1234                  ; 28 3A 34 12
 mb ldax b                      ; 28 0A
 mb ldax d                      ; 28 1A
 mb lhld 0x1234                 ; 28 2A 34 12
 mb lhlde                       ; 28 ED
 mb lhlx                        ; 28 ED
 mb mov a, m                    ; 28 7E
 mb mov b, m                    ; 28 46
 mb mov c, m                    ; 28 4E
 mb mov d, m                    ; 28 56
 mb mov e, m                    ; 28 5E
 mb mov h', m                   ; 28 38 66
 mb mov h, m                    ; 28 66
 mb mov l', m                   ; 28 38 6E
 mb mov l, m                    ; 28 6E
 mb mov m, a                    ; 28 77
 mb mov m, b                    ; 28 70
 mb mov m, c                    ; 28 71
 mb mov m, d                    ; 28 72
 mb mov m, e                    ; 28 73
 mb mov m, h                    ; 28 74
 mb mov m, h'                   ; 28 38 74
 mb mov m, l                    ; 28 75
 mb mov m, l'                   ; 28 38 75
 mb mvi m, 0                    ; 28 36 00
 mb mvi m, 127                  ; 28 36 7F
 mb mvi m, 255                  ; 28 36 FF
 mb ora m                       ; 28 B6
 mb orl (hl')                   ; 28 38 20
 mb orl (hl)                    ; 28 20
 mb pop b                       ; 28 C1
 mb pop d                       ; 28 D1
 mb pop h                       ; 28 E1
 mb pop h'                      ; 28 38 E1
 mb pop psw                     ; 28 F1
 mb push b                      ; 28 C5
 mb push d                      ; 28 D5
 mb push h                      ; 28 E5
 mb push h'                     ; 28 38 E5
 mb push psw                    ; 28 F5
 mb rc                          ; 28 D8
 mb ret                         ; 28 C9
 mb rm                          ; 28 F8
 mb rnc                         ; 28 D0
 mb rnz                         ; 28 C0
 mb rp                          ; 28 F0
 mb rpe                         ; 28 E8
 mb rpo                         ; 28 E0
 mb rst 0                       ; 28 C7
 mb rst 1                       ; 28 CF
 mb rst 16                      ; 28 D7
 mb rst 2                       ; 28 D7
 mb rst 24                      ; 28 DF
 mb rst 3                       ; 28 DF
 mb rst 32                      ; 28 E7
 mb rst 4                       ; 28 E7
 mb rst 40                      ; 28 EF
 mb rst 48                      ; 28 F7
 mb rst 5                       ; 28 EF
 mb rst 56                      ; 28 FF
 mb rst 6                       ; 28 F7
 mb rst 7                       ; 28 FF
 mb rst 8                       ; 28 CF
 mb rz                          ; 28 C8
 mb sbb m                       ; 28 9E
 mb shld 0x1234                 ; 28 22 34 12
 mb shlde                       ; 28 D9
 mb shlx                        ; 28 D9
 mb sta 0x1234                  ; 28 32 34 12
 mb stax b                      ; 28 02
 mb stax d                      ; 28 12
 mb sub m                       ; 28 96
 mb xorl (hl')                  ; 28 38 30
 mb xorl (hl)                   ; 28 30
 mb xra m                       ; 28 AE
 mov a, a                       ; 7F
 mov a, b                       ; 78
 mov a, c                       ; 79
 mov a, d                       ; 7A
 mov a, e                       ; 7B
 mov a, h                       ; 7C
 mov a, h'                      ; 38 7C
 mov a, l                       ; 7D
 mov a, l'                      ; 38 7D
 mov a, m                       ; 7E
 mov b, a                       ; 47
 mov b, b                       ; 40
 mov b, c                       ; 41
 mov b, d                       ; 42
 mov b, e                       ; 43
 mov b, h                       ; 44
 mov b, h'                      ; 38 44
 mov b, l                       ; 45
 mov b, l'                      ; 38 45
 mov b, m                       ; 46
 mov c, a                       ; 4F
 mov c, b                       ; 48
 mov c, c                       ; 49
 mov c, d                       ; 4A
 mov c, e                       ; 4B
 mov c, h                       ; 4C
 mov c, h'                      ; 38 4C
 mov c, l                       ; 4D
 mov c, l'                      ; 38 4D
 mov c, m                       ; 4E
 mov d, a                       ; 57
 mov d, b                       ; 50
 mov d, c                       ; 51
 mov d, d                       ; 52
 mov d, e                       ; 53
 mov d, h                       ; 54
 mov d, h'                      ; 38 54
 mov d, l                       ; 55
 mov d, l'                      ; 38 55
 mov d, m                       ; 56
 mov e, a                       ; 5F
 mov e, b                       ; 58
 mov e, c                       ; 59
 mov e, d                       ; 5A
 mov e, e                       ; 5B
 mov e, h                       ; 5C
 mov e, h'                      ; 38 5C
 mov e, l                       ; 5D
 mov e, l'                      ; 38 5D
 mov e, m                       ; 5E
 mov h', a                      ; 38 67
 mov h', b                      ; 38 60
 mov h', c                      ; 38 61
 mov h', d                      ; 38 62
 mov h', e                      ; 38 63
 mov h', h'                     ; 38 64
 mov h', l'                     ; 38 65
 mov h', m                      ; 38 66
 mov h, a                       ; 67
 mov h, b                       ; 60
 mov h, c                       ; 61
 mov h, d                       ; 62
 mov h, e                       ; 63
 mov h, h                       ; 64
 mov h, l                       ; 65
 mov h, m                       ; 66
 mov l', a                      ; 38 6F
 mov l', b                      ; 38 68
 mov l', c                      ; 38 69
 mov l', d                      ; 38 6A
 mov l', e                      ; 38 6B
 mov l', h'                     ; 38 6C
 mov l', l'                     ; 38 6D
 mov l', m                      ; 38 6E
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
 mov m, h'                      ; 38 74
 mov m, l                       ; 75
 mov m, l'                      ; 38 75
 mvi a, 0                       ; 3E 00
 mvi a, 127                     ; 3E 7F
 mvi a, 255                     ; 3E FF
 mvi b, 0                       ; 06 00
 mvi b, 127                     ; 06 7F
 mvi b, 255                     ; 06 FF
 mvi c, 0                       ; 0E 00
 mvi c, 127                     ; 0E 7F
 mvi c, 255                     ; 0E FF
 mvi d, 0                       ; 16 00
 mvi d, 127                     ; 16 7F
 mvi d, 255                     ; 16 FF
 mvi e, 0                       ; 1E 00
 mvi e, 127                     ; 1E 7F
 mvi e, 255                     ; 1E FF
 mvi h', 0                      ; 38 26 00
 mvi h', 127                    ; 38 26 7F
 mvi h', 255                    ; 38 26 FF
 mvi h, 0                       ; 26 00
 mvi h, 127                     ; 26 7F
 mvi h, 255                     ; 26 FF
 mvi l', 0                      ; 38 2E 00
 mvi l', 127                    ; 38 2E 7F
 mvi l', 255                    ; 38 2E FF
 mvi l, 0                       ; 2E 00
 mvi l, 127                     ; 2E 7F
 mvi l, 255                     ; 2E FF
 mvi m, 0                       ; 36 00
 mvi m, 127                     ; 36 7F
 mvi m, 255                     ; 36 FF
 nop                            ; 00
 ora a                          ; B7
 ora b                          ; B0
 ora c                          ; B1
 ora d                          ; B2
 ora e                          ; B3
 ora h                          ; B4
 ora h'                         ; 38 B4
 ora l                          ; B5
 ora l'                         ; 38 B5
 ora m                          ; B6
 ori 0                          ; F6 00
 ori 127                        ; F6 7F
 ori 255                        ; F6 FF
 orl (hl')                      ; 38 20
 orl (hl)                       ; 20
 orm                            ; 20
 orx                            ; 20
 out 0                          ; D3 00
 out 127                        ; D3 7F
 out 255                        ; D3 FF
 pchl                           ; E9
 pchl'                          ; 38 E9
 pop b                          ; C1
 pop d                          ; D1
 pop h                          ; E1
 pop h'                         ; 38 E1
 pop psw                        ; F1
 push b                         ; C5
 push d                         ; D5
 push h                         ; E5
 push h'                        ; 38 E5
 push psw                       ; F5
 ral                            ; 17
 rar                            ; 1F
 rc                             ; D8
 ret                            ; C9
 rlc                            ; 07
 rm                             ; F8
 rnc                            ; D0
 rnz                            ; C0
 rp                             ; F0
 rpe                            ; E8
 rpo                            ; E0
 rrc                            ; 0F
 rst 0                          ; C7
 rst 1                          ; CF
 rst 16                         ; D7
 rst 2                          ; D7
 rst 24                         ; DF
 rst 3                          ; DF
 rst 32                         ; E7
 rst 4                          ; E7
 rst 40                         ; EF
 rst 48                         ; F7
 rst 5                          ; EF
 rst 56                         ; FF
 rst 6                          ; F7
 rst 7                          ; FF
 rst 8                          ; CF
 rz                             ; C8
 sbb a                          ; 9F
 sbb b                          ; 98
 sbb c                          ; 99
 sbb d                          ; 9A
 sbb e                          ; 9B
 sbb h                          ; 9C
 sbb h'                         ; 38 9C
 sbb l                          ; 9D
 sbb l'                         ; 38 9D
 sbb m                          ; 9E
 sbc hl', bc                    ; 38 28 08
 sbc hl', de                    ; 38 28 18
 sbc hl, bc                     ; 28 08
 sbc hl, de                     ; 28 18
 sbi 0                          ; DE 00
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 shld 0x1234                    ; 22 34 12
 shlde                          ; D9
 shlx                           ; D9
 smf0                           ; 28 00
 smf1                           ; 28 7F
 sphl                           ; F9
 sphl'                          ; 38 F9
 sta 0x1234                     ; 32 34 12
 stax b                         ; 02
 stax d                         ; 12
 stc                            ; 37
 sub a                          ; 97
 sub b                          ; 90
 sub c                          ; 91
 sub d                          ; 92
 sub e                          ; 93
 sub h                          ; 94
 sub h'                         ; 38 94
 sub hl', bc                    ; 38 08
 sub hl', de                    ; 38 18
 sub hl, bc                     ; 08
 sub hl, de                     ; 18
 sub l                          ; 95
 sub l'                         ; 38 95
 sub m                          ; 96
 sui 0                          ; D6 00
 sui 127                        ; D6 7F
 sui 255                        ; D6 FF
 xchg                           ; EB
 xorl (hl')                     ; 38 30
 xorl (hl)                      ; 30
 xorm                           ; 30
 xra a                          ; AF
 xra b                          ; A8
 xra c                          ; A9
 xra d                          ; AA
 xra e                          ; AB
 xra h                          ; AC
 xra h'                         ; 38 AC
 xra l                          ; AD
 xra l'                         ; 38 AD
 xra m                          ; AE
 xri 0                          ; EE 00
 xri 127                        ; EE 7F
 xri 255                        ; EE FF
 xrx                            ; 30
 xthl                           ; E3
 xthl'                          ; 38 E3
