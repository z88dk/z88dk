 aci -128                       ; CE 80
 aci 0                          ; CE 00
 aci 127                        ; CE 7F
 aci 255                        ; CE FF
 adc a                          ; 8F
 adc b                          ; 88
 adc c                          ; 89
 adc d                          ; 8A
 adc e                          ; 8B
 adc h                          ; 8C
 adc l                          ; 8D
 adc m                          ; 8E
 add a                          ; 87
 add b                          ; 80
 add c                          ; 81
 add d                          ; 82
 add e                          ; 83
 add h                          ; 84
 add l                          ; 85
 add m                          ; 86
 adi -128                       ; C6 80
 adi 0                          ; C6 00
 adi 127                        ; C6 7F
 adi 255                        ; C6 FF
 adi hl, -128                   ; 28 80
 adi hl, 0                      ; 28 00
 adi hl, 127                    ; 28 7F
 adi hl, 255                    ; 28 FF
 adi sp, -128                   ; 38 80
 adi sp, 0                      ; 38 00
 adi sp, 127                    ; 38 7F
 adi sp, 255                    ; 38 FF
 ana a                          ; A7
 ana b                          ; A0
 ana c                          ; A1
 ana d                          ; A2
 ana e                          ; A3
 ana h                          ; A4
 ana l                          ; A5
 ana m                          ; A6
 ani -128                       ; E6 80
 ani 0                          ; E6 00
 ani 127                        ; E6 7F
 ani 255                        ; E6 FF
 arhl                           ; 10
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
 cmp l                          ; BD
 cmp m                          ; BE
 cnc 0x1234                     ; D4 34 12
 cnz 0x1234                     ; C4 34 12
 cp 0x1234                      ; F4 34 12
 cpe 0x1234                     ; EC 34 12
 cpi -128                       ; FE 80
 cpi 0                          ; FE 00
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpo 0x1234                     ; E4 34 12
 cz 0x1234                      ; CC 34 12
 daa                            ; 27
 dad b                          ; 09
 dad d                          ; 19
 dad h                          ; 29
 dad sp                         ; 39
 dcr a                          ; 3D
 dcr b                          ; 05
 dcr c                          ; 0D
 dcr d                          ; 15
 dcr e                          ; 1D
 dcr h                          ; 25
 dcr l                          ; 2D
 dcr m                          ; 35
 dcx b                          ; 0B
 dcx d                          ; 1B
 dcx h                          ; 2B
 dcx sp                         ; 3B
 di                             ; F3
 dsub                           ; 08
 ei                             ; FB
 hlt                            ; 76
 in -128                        ; DB 80
 in 0                           ; DB 00
 in 127                         ; DB 7F
 in 255                         ; DB FF
 inr a                          ; 3C
 inr b                          ; 04
 inr c                          ; 0C
 inr d                          ; 14
 inr e                          ; 1C
 inr h                          ; 24
 inr l                          ; 2C
 inr m                          ; 34
 inx b                          ; 03
 inx d                          ; 13
 inx h                          ; 23
 inx sp                         ; 33
 jc 0x1234                      ; DA 34 12
 jk 0x1234                      ; FD 34 12
 jm 0x1234                      ; FA 34 12
 jmp 0x1234                     ; C3 34 12
 jmp k, 0x1234                  ; FD 34 12
 jmp nk, 0x1234                 ; DD 34 12
 jmp nx5, 0x1234                ; DD 34 12
 jmp x5, 0x1234                 ; FD 34 12
 jnc 0x1234                     ; D2 34 12
 jnk 0x1234                     ; DD 34 12
 jnx5 0x1234                    ; DD 34 12
 jnz 0x1234                     ; C2 34 12
 jp 0x1234                      ; F2 34 12
 jp k, 0x1234                   ; FD 34 12
 jp nk, 0x1234                  ; DD 34 12
 jp nx5, 0x1234                 ; DD 34 12
 jp x5, 0x1234                  ; FD 34 12
 jpe 0x1234                     ; EA 34 12
 jpo 0x1234                     ; E2 34 12
 jx5 0x1234                     ; FD 34 12
 jz 0x1234                      ; CA 34 12
 ld (de), hl                    ; D9
 ld de, hl+0                    ; 28 00
 ld de, hl+128                  ; 28 80
 ld de, hl+255                  ; 28 FF
 ld de, sp                      ; 38 00
 ld de, sp+0                    ; 38 00
 ld de, sp+128                  ; 38 80
 ld de, sp+255                  ; 38 FF
 ld hl, (de)                    ; ED
 lda 0x1234                     ; 3A 34 12
 ldax b                         ; 0A
 ldax d                         ; 1A
 ldhi -128                      ; 28 80
 ldhi 0                         ; 28 00
 ldhi 127                       ; 28 7F
 ldhi 255                       ; 28 FF
 ldsi -128                      ; 38 80
 ldsi 0                         ; 38 00
 ldsi 127                       ; 38 7F
 ldsi 255                       ; 38 FF
 lhld 0x1234                    ; 2A 34 12
 lhlde                          ; ED
 lhlx                           ; ED
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
 nop                            ; 00
 ora a                          ; B7
 ora b                          ; B0
 ora c                          ; B1
 ora d                          ; B2
 ora e                          ; B3
 ora h                          ; B4
 ora l                          ; B5
 ora m                          ; B6
 ori -128                       ; F6 80
 ori 0                          ; F6 00
 ori 127                        ; F6 7F
 ori 255                        ; F6 FF
 out -128                       ; D3 80
 out 0                          ; D3 00
 out 127                        ; D3 7F
 out 255                        ; D3 FF
 ovrst8                         ; CB
 pchl                           ; E9
 pop b                          ; C1
 pop d                          ; D1
 pop h                          ; E1
 pop psw                        ; F1
 push b                         ; C5
 push d                         ; D5
 push h                         ; E5
 push psw                       ; F5
 ral                            ; 17
 rar                            ; 1F
 rc                             ; D8
 rdel                           ; 18
 ret                            ; C9
 rim                            ; 20
 rl de                          ; 18
 rlc                            ; 07
 rlde                           ; 18
 rm                             ; F8
 rnc                            ; D0
 rnz                            ; C0
 rp                             ; F0
 rpe                            ; E8
 rpo                            ; E0
 rrc                            ; 0F
 rrhl                           ; 10
 rst 0                          ; C7
 rst 16                         ; D7
 rst 24                         ; DF
 rst 32                         ; E7
 rst 40                         ; EF
 rst 48                         ; F7
 rst 56                         ; FF
 rst 8                          ; CF
 rst v, 64                      ; CB
 rstv                           ; CB
 rz                             ; C8
 sbb a                          ; 9F
 sbb b                          ; 98
 sbb c                          ; 99
 sbb d                          ; 9A
 sbb e                          ; 9B
 sbb h                          ; 9C
 sbb l                          ; 9D
 sbb m                          ; 9E
 sbi -128                       ; DE 80
 sbi 0                          ; DE 00
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 shld 0x1234                    ; 22 34 12
 shlde                          ; D9
 shlx                           ; D9
 sim                            ; 30
 sphl                           ; F9
 sra hl                         ; 10
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
 sub hl, bc                     ; 08
 sub l                          ; 95
 sub m                          ; 96
 sui -128                       ; D6 80
 sui 0                          ; D6 00
 sui 127                        ; D6 7F
 sui 255                        ; D6 FF
 xchg                           ; EB
 xra a                          ; AF
 xra b                          ; A8
 xra c                          ; A9
 xra d                          ; AA
 xra e                          ; AB
 xra h                          ; AC
 xra l                          ; AD
 xra m                          ; AE
 xri -128                       ; EE 80
 xri 0                          ; EE 00
 xri 127                        ; EE 7F
 xri 255                        ; EE FF
 xthl                           ; E3
