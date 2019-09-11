 nop                            ; 00
 lxi b, -32768                  ; 01 00 80
 ld bc, -32768                  ; 01 00 80
 lxi bc, -32768                 ; 01 00 80
 lxi b, 32767                   ; 01 FF 7F
 lxi bc, 65535                  ; 01 FF FF
 ld bc, 32767                   ; 01 FF 7F
 ld bc, 65535                   ; 01 FF FF
 lxi b, 65535                   ; 01 FF FF
 lxi bc, 32767                  ; 01 FF 7F
 ld (bc), a                     ; 02
 stax bc                        ; 02
 stax b                         ; 02
 inx bc                         ; 03
 inx b                          ; 03
 inc bc                         ; 03
 inr b                          ; 04
 inc b                          ; 04
 dcr b                          ; 05
 dec b                          ; 05
 djnz ASMPC                     ; 05 20 FE
 djnz b, ASMPC                  ; 05 20 FE
 ld b, 127                      ; 06 7F
 mvi b, 127                     ; 06 7F
 ld b, -128                     ; 06 80
 mvi b, -128                    ; 06 80
 ld b, 255                      ; 06 FF
 mvi b, 255                     ; 06 FF
 rlc                            ; 07
 rlca                           ; 07
 ld (-32768), sp                ; 08 00 80
 ld (65535), sp                 ; 08 FF FF
 ld (32767), sp                 ; 08 FF 7F
 dad b                          ; 09
 dad bc                         ; 09
 add hl, bc                     ; 09
 ldax b                         ; 0A
 ld a, (bc)                     ; 0A
 ldax bc                        ; 0A
 dcx b                          ; 0B
 dcx bc                         ; 0B
 dec bc                         ; 0B
 inr c                          ; 0C
 inc c                          ; 0C
 dcr c                          ; 0D
 dec c                          ; 0D
 ld c, 127                      ; 0E 7F
 mvi c, 127                     ; 0E 7F
 ld c, -128                     ; 0E 80
 mvi c, -128                    ; 0E 80
 ld c, 255                      ; 0E FF
 mvi c, 255                     ; 0E FF
 rrca                           ; 0F
 rrc                            ; 0F
 stop                           ; 10 00
 ld de, -32768                  ; 11 00 80
 lxi de, -32768                 ; 11 00 80
 lxi d, -32768                  ; 11 00 80
 lxi de, 65535                  ; 11 FF FF
 ld de, 32767                   ; 11 FF 7F
 lxi d, 32767                   ; 11 FF 7F
 lxi d, 65535                   ; 11 FF FF
 lxi de, 32767                  ; 11 FF 7F
 ld de, 65535                   ; 11 FF FF
 ld (de), a                     ; 12
 stax de                        ; 12
 stax d                         ; 12
 inx de                         ; 13
 inx d                          ; 13
 inc de                         ; 13
 inr d                          ; 14
 inc d                          ; 14
 dec d                          ; 15
 dcr d                          ; 15
 ld d, 127                      ; 16 7F
 mvi d, 127                     ; 16 7F
 ld d, -128                     ; 16 80
 mvi d, -128                    ; 16 80
 mvi d, 255                     ; 16 FF
 ld d, 255                      ; 16 FF
 rla                            ; 17
 ral                            ; 17
 jr ASMPC                       ; 18 FE
 add hl, de                     ; 19
 dad d                          ; 19
 dad de                         ; 19
 ld a, (de)                     ; 1A
 ldax d                         ; 1A
 ldax de                        ; 1A
 dcx de                         ; 1B
 dec de                         ; 1B
 dcx d                          ; 1B
 inr e                          ; 1C
 inc e                          ; 1C
 dec e                          ; 1D
 dcr e                          ; 1D
 mvi e, 127                     ; 1E 7F
 ld e, 127                      ; 1E 7F
 mvi e, -128                    ; 1E 80
 ld e, -128                     ; 1E 80
 mvi e, 255                     ; 1E FF
 ld e, 255                      ; 1E FF
 rra                            ; 1F
 rar                            ; 1F
 jr nz, ASMPC                   ; 20 FE
 lxi h, -32768                  ; 21 00 80
 lxi hl, -32768                 ; 21 00 80
 ld hl, -32768                  ; 21 00 80
 lxi hl, 32767                  ; 21 FF 7F
 lxi h, 32767                   ; 21 FF 7F
 ld hl, 32767                   ; 21 FF 7F
 ld hl, 65535                   ; 21 FF FF
 lxi h, 65535                   ; 21 FF FF
 lxi hl, 65535                  ; 21 FF FF
 ld (hli), a                    ; 22
 ld (hl+), a                    ; 22
 ldi (hl), a                    ; 22
 inc hl                         ; 23
 inx hl                         ; 23
 inx h                          ; 23
 inc h                          ; 24
 inr h                          ; 24
 dcr h                          ; 25
 dec h                          ; 25
 ld h, 127                      ; 26 7F
 mvi h, 127                     ; 26 7F
 ld h, -128                     ; 26 80
 mvi h, -128                    ; 26 80
 ld h, 255                      ; 26 FF
 mvi h, 255                     ; 26 FF
 daa                            ; 27
 jr z, ASMPC                    ; 28 FE
 add hl, hl                     ; 29
 dad h                          ; 29
 dad hl                         ; 29
 ldi a, (hl)                    ; 2A
 ld a, (hl+)                    ; 2A
 ld a, (hli)                    ; 2A
 dcx h                          ; 2B
 dcx hl                         ; 2B
 dec hl                         ; 2B
 inr l                          ; 2C
 inc l                          ; 2C
 dcr l                          ; 2D
 dec l                          ; 2D
 ld l, 127                      ; 2E 7F
 mvi l, 127                     ; 2E 7F
 ld l, -128                     ; 2E 80
 mvi l, -128                    ; 2E 80
 ld l, 255                      ; 2E FF
 mvi l, 255                     ; 2E FF
 cma                            ; 2F
 cpl                            ; 2F
 cpl a                          ; 2F
 jr nc, ASMPC                   ; 30 FE
 ld sp, -32768                  ; 31 00 80
 lxi sp, -32768                 ; 31 00 80
 ld sp, 32767                   ; 31 FF 7F
 ld sp, 65535                   ; 31 FF FF
 lxi sp, 65535                  ; 31 FF FF
 lxi sp, 32767                  ; 31 FF 7F
 ld (hld), a                    ; 32
 ld (hl-), a                    ; 32
 ldd (hl), a                    ; 32
 inx sp                         ; 33
 inc sp                         ; 33
 inr m                          ; 34
 inc (hl)                       ; 34
 dcr m                          ; 35
 dec (hl)                       ; 35
 ld (hl), 127                   ; 36 7F
 mvi m, 127                     ; 36 7F
 ld (hl), -128                  ; 36 80
 mvi m, -128                    ; 36 80
 ld (hl), 255                   ; 36 FF
 mvi m, 255                     ; 36 FF
 scf f                          ; 37
 stc                            ; 37
 scf                            ; 37
 jr c, ASMPC                    ; 38 FE
 dad sp                         ; 39
 add hl, sp                     ; 39
 ld a, (hl-)                    ; 3A
 ld a, (hld)                    ; 3A
 ldd a, (hl)                    ; 3A
 dec sp                         ; 3B
 dcx sp                         ; 3B
 inc a                          ; 3C
 inr a                          ; 3C
 dec a                          ; 3D
 dcr a                          ; 3D
 mvi a, 127                     ; 3E 7F
 ld a, 127                      ; 3E 7F
 mvi a, -128                    ; 3E 80
 ld a, -128                     ; 3E 80
 mvi a, 255                     ; 3E FF
 ld a, 255                      ; 3E FF
 ccf                            ; 3F
 cmc                            ; 3F
 ccf f                          ; 3F
 mov b, b                       ; 40
 ld b, b                        ; 40
 mov b, c                       ; 41
 ld b, c                        ; 41
 mov b, d                       ; 42
 ld b, d                        ; 42
 ld b, e                        ; 43
 mov b, e                       ; 43
 mov b, h                       ; 44
 ld b, h                        ; 44
 mov b, l                       ; 45
 ld b, l                        ; 45
 ld b, (hl)                     ; 46
 mov b, m                       ; 46
 mov b, a                       ; 47
 ld b, a                        ; 47
 ld c, b                        ; 48
 mov c, b                       ; 48
 ld c, c                        ; 49
 mov c, c                       ; 49
 ld c, d                        ; 4A
 mov c, d                       ; 4A
 ld c, e                        ; 4B
 mov c, e                       ; 4B
 ld c, h                        ; 4C
 mov c, h                       ; 4C
 mov c, l                       ; 4D
 ld c, l                        ; 4D
 ld c, (hl)                     ; 4E
 mov c, m                       ; 4E
 ld c, a                        ; 4F
 mov c, a                       ; 4F
 mov d, b                       ; 50
 ld d, b                        ; 50
 mov d, c                       ; 51
 ld d, c                        ; 51
 ld d, d                        ; 52
 mov d, d                       ; 52
 ld d, e                        ; 53
 mov d, e                       ; 53
 mov d, h                       ; 54
 ld d, h                        ; 54
 ld d, l                        ; 55
 mov d, l                       ; 55
 mov d, m                       ; 56
 ld d, (hl)                     ; 56
 ld d, a                        ; 57
 mov d, a                       ; 57
 ld e, b                        ; 58
 mov e, b                       ; 58
 ld e, c                        ; 59
 mov e, c                       ; 59
 ld e, d                        ; 5A
 mov e, d                       ; 5A
 mov e, e                       ; 5B
 ld e, e                        ; 5B
 mov e, h                       ; 5C
 ld e, h                        ; 5C
 ld e, l                        ; 5D
 mov e, l                       ; 5D
 mov e, m                       ; 5E
 ld e, (hl)                     ; 5E
 mov e, a                       ; 5F
 ld e, a                        ; 5F
 ld h, b                        ; 60
 mov h, b                       ; 60
 mov h, c                       ; 61
 ld h, c                        ; 61
 mov h, d                       ; 62
 ld h, d                        ; 62
 mov h, e                       ; 63
 ld h, e                        ; 63
 mov h, h                       ; 64
 ld h, h                        ; 64
 ld h, l                        ; 65
 mov h, l                       ; 65
 mov h, m                       ; 66
 ld h, (hl)                     ; 66
 ld h, a                        ; 67
 mov h, a                       ; 67
 mov l, b                       ; 68
 ld l, b                        ; 68
 mov l, c                       ; 69
 ld l, c                        ; 69
 mov l, d                       ; 6A
 ld l, d                        ; 6A
 mov l, e                       ; 6B
 ld l, e                        ; 6B
 ld l, h                        ; 6C
 mov l, h                       ; 6C
 ld l, l                        ; 6D
 mov l, l                       ; 6D
 mov l, m                       ; 6E
 ld l, (hl)                     ; 6E
 ld l, a                        ; 6F
 mov l, a                       ; 6F
 mov m, b                       ; 70
 ld (hl), b                     ; 70
 mov m, c                       ; 71
 ld (hl), c                     ; 71
 mov m, d                       ; 72
 ld (hl), d                     ; 72
 mov m, e                       ; 73
 ld (hl), e                     ; 73
 mov m, h                       ; 74
 ld (hl), h                     ; 74
 mov m, l                       ; 75
 ld (hl), l                     ; 75
 halt                           ; 76
 hlt                            ; 76
 ld (hl), a                     ; 77
 mov m, a                       ; 77
 ld a, b                        ; 78
 mov a, b                       ; 78
 ld a, c                        ; 79
 mov a, c                       ; 79
 mov a, d                       ; 7A
 ld a, d                        ; 7A
 mov a, e                       ; 7B
 ld a, e                        ; 7B
 mov a, h                       ; 7C
 ld a, h                        ; 7C
 mov a, l                       ; 7D
 ld a, l                        ; 7D
 mov a, m                       ; 7E
 ld a, (hl)                     ; 7E
 ld a, a                        ; 7F
 mov a, a                       ; 7F
 add a, b                       ; 80
 add b                          ; 80
 add a, c                       ; 81
 add c                          ; 81
 add a, d                       ; 82
 add d                          ; 82
 add a, e                       ; 83
 add e                          ; 83
 add a, h                       ; 84
 add h                          ; 84
 add l                          ; 85
 add a, l                       ; 85
 add a, (hl)                    ; 86
 add m                          ; 86
 add (hl)                       ; 86
 add a                          ; 87
 add a, a                       ; 87
 adc a, b                       ; 88
 adc b                          ; 88
 adc a, c                       ; 89
 adc c                          ; 89
 adc a, d                       ; 8A
 adc d                          ; 8A
 adc e                          ; 8B
 adc a, e                       ; 8B
 adc a, h                       ; 8C
 adc h                          ; 8C
 adc a, l                       ; 8D
 adc l                          ; 8D
 adc (hl)                       ; 8E
 adc a, (hl)                    ; 8E
 adc m                          ; 8E
 adc a                          ; 8F
 adc a, a                       ; 8F
 sub a, b                       ; 90
 sub b                          ; 90
 sub a, c                       ; 91
 sub c                          ; 91
 sub a, d                       ; 92
 sub d                          ; 92
 sub a, e                       ; 93
 sub e                          ; 93
 sub h                          ; 94
 sub a, h                       ; 94
 sub a, l                       ; 95
 sub l                          ; 95
 sub a, (hl)                    ; 96
 sub m                          ; 96
 sub (hl)                       ; 96
 sub a, a                       ; 97
 sub a                          ; 97
 sbc b                          ; 98
 sbc a, b                       ; 98
 sbb b                          ; 98
 sbc a, c                       ; 99
 sbb c                          ; 99
 sbc c                          ; 99
 sbb d                          ; 9A
 sbc a, d                       ; 9A
 sbc d                          ; 9A
 sbc a, e                       ; 9B
 sbb e                          ; 9B
 sbc e                          ; 9B
 sbc a, h                       ; 9C
 sbb h                          ; 9C
 sbc h                          ; 9C
 sbb l                          ; 9D
 sbc l                          ; 9D
 sbc a, l                       ; 9D
 sbc a, (hl)                    ; 9E
 sbb m                          ; 9E
 sbc (hl)                       ; 9E
 sbc a                          ; 9F
 sbb a                          ; 9F
 sbc a, a                       ; 9F
 and b                          ; A0
 ana b                          ; A0
 and a, b                       ; A0
 ana c                          ; A1
 and a, c                       ; A1
 and c                          ; A1
 and d                          ; A2
 and a, d                       ; A2
 ana d                          ; A2
 and e                          ; A3
 ana e                          ; A3
 and a, e                       ; A3
 and a, h                       ; A4
 and h                          ; A4
 ana h                          ; A4
 and l                          ; A5
 ana l                          ; A5
 and a, l                       ; A5
 and (hl)                       ; A6
 and a, (hl)                    ; A6
 ana m                          ; A6
 and a                          ; A7
 and a, a                       ; A7
 ana a                          ; A7
 xor a, b                       ; A8
 xor b                          ; A8
 xra b                          ; A8
 xor a, c                       ; A9
 xor c                          ; A9
 xra c                          ; A9
 xor a, d                       ; AA
 xor d                          ; AA
 xra d                          ; AA
 xor a, e                       ; AB
 xor e                          ; AB
 xra e                          ; AB
 xor a, h                       ; AC
 xor h                          ; AC
 xra h                          ; AC
 xor l                          ; AD
 xor a, l                       ; AD
 xra l                          ; AD
 xor (hl)                       ; AE
 xra m                          ; AE
 xor a, (hl)                    ; AE
 xor a                          ; AF
 xor a, a                       ; AF
 xra a                          ; AF
 or b                           ; B0
 ora b                          ; B0
 or a, b                        ; B0
 or c                           ; B1
 or a, c                        ; B1
 ora c                          ; B1
 ora d                          ; B2
 or d                           ; B2
 or a, d                        ; B2
 or e                           ; B3
 ora e                          ; B3
 or a, e                        ; B3
 or h                           ; B4
 ora h                          ; B4
 or a, h                        ; B4
 ora l                          ; B5
 or l                           ; B5
 or a, l                        ; B5
 or (hl)                        ; B6
 ora m                          ; B6
 or a, (hl)                     ; B6
 or a, a                        ; B7
 or a                           ; B7
 ora a                          ; B7
 cp b                           ; B8
 cmp b                          ; B8
 cp a, b                        ; B8
 cp c                           ; B9
 cp a, c                        ; B9
 cmp c                          ; B9
 cp d                           ; BA
 cp a, d                        ; BA
 cmp d                          ; BA
 cp e                           ; BB
 cmp e                          ; BB
 cp a, e                        ; BB
 cp h                           ; BC
 cmp h                          ; BC
 cp a, h                        ; BC
 cp a, l                        ; BD
 cp l                           ; BD
 cmp l                          ; BD
 cmp m                          ; BE
 cp a, (hl)                     ; BE
 cp (hl)                        ; BE
 cmp a                          ; BF
 cp a, a                        ; BF
 cp a                           ; BF
 r_nz                           ; C0
 rnz                            ; C0
 ret nz                         ; C0
 pop bc                         ; C1
 pop b                          ; C1
 j_nz -32768                    ; C2 00 80
 jnz -32768                     ; C2 00 80
 jp nz, -32768                  ; C2 00 80
 jp nz, 65535                   ; C2 FF FF
 j_nz 32767                     ; C2 FF 7F
 j_nz 65535                     ; C2 FF FF
 jnz 65535                      ; C2 FF FF
 jp nz, 32767                   ; C2 FF 7F
 jnz 32767                      ; C2 FF 7F
 jmp -32768                     ; C3 00 80
 jp -32768                      ; C3 00 80
 jmp 32767                      ; C3 FF 7F
 jmp 65535                      ; C3 FF FF
 jp 32767                       ; C3 FF 7F
 jp 65535                       ; C3 FF FF
 c_nz -32768                    ; C4 00 80
 cnz -32768                     ; C4 00 80
 call nz, -32768                ; C4 00 80
 c_nz 32767                     ; C4 FF 7F
 cnz 65535                      ; C4 FF FF
 c_nz 65535                     ; C4 FF FF
 cnz 32767                      ; C4 FF 7F
 call nz, 65535                 ; C4 FF FF
 call nz, 32767                 ; C4 FF 7F
 push b                         ; C5
 push bc                        ; C5
 add 127                        ; C6 7F
 add a, 127                     ; C6 7F
 adi 127                        ; C6 7F
 add a, -128                    ; C6 80
 adi -128                       ; C6 80
 add -128                       ; C6 80
 adi 255                        ; C6 FF
 add a, 255                     ; C6 FF
 add 255                        ; C6 FF
 rst 0                          ; C7
 ret z                          ; C8
 r_z                            ; C8
 rz                             ; C8
 ret                            ; C9
 jp z, -32768                   ; CA 00 80
 jz -32768                      ; CA 00 80
 j_z -32768                     ; CA 00 80
 jp z, 32767                    ; CA FF 7F
 jz 32767                       ; CA FF 7F
 j_z 32767                      ; CA FF 7F
 jp z, 65535                    ; CA FF FF
 j_z 65535                      ; CA FF FF
 jz 65535                       ; CA FF FF
 rlc b                          ; CB 00
 rlc c                          ; CB 01
 rlc d                          ; CB 02
 rlc e                          ; CB 03
 rlc h                          ; CB 04
 rlc l                          ; CB 05
 rlc (hl)                       ; CB 06
 rlc a                          ; CB 07
 rrc b                          ; CB 08
 rrc c                          ; CB 09
 rrc d                          ; CB 0A
 rrc e                          ; CB 0B
 rrc h                          ; CB 0C
 rrc l                          ; CB 0D
 rrc (hl)                       ; CB 0E
 rrc a                          ; CB 0F
 rl b                           ; CB 10
 rl c                           ; CB 11
 rl d                           ; CB 12
 rl e                           ; CB 13
 rl h                           ; CB 14
 rl l                           ; CB 15
 rl (hl)                        ; CB 16
 rl a                           ; CB 17
 rr b                           ; CB 18
 rr c                           ; CB 19
 rr d                           ; CB 1A
 rr e                           ; CB 1B
 rr h                           ; CB 1C
 rr l                           ; CB 1D
 rr (hl)                        ; CB 1E
 rr a                           ; CB 1F
 sla b                          ; CB 20
 sla c                          ; CB 21
 sla d                          ; CB 22
 sla e                          ; CB 23
 sla h                          ; CB 24
 sla l                          ; CB 25
 sla (hl)                       ; CB 26
 sla a                          ; CB 27
 sra b                          ; CB 28
 sra c                          ; CB 29
 sra d                          ; CB 2A
 sra e                          ; CB 2B
 sra h                          ; CB 2C
 sra l                          ; CB 2D
 sra (hl)                       ; CB 2E
 sra a                          ; CB 2F
 swap b                         ; CB 30
 swap c                         ; CB 31
 swap d                         ; CB 32
 swap e                         ; CB 33
 swap h                         ; CB 34
 swap l                         ; CB 35
 swap (hl)                      ; CB 36
 swap a                         ; CB 37
 srl b                          ; CB 38
 srl c                          ; CB 39
 srl d                          ; CB 3A
 srl e                          ; CB 3B
 srl h                          ; CB 3C
 srl l                          ; CB 3D
 srl (hl)                       ; CB 3E
 srl a                          ; CB 3F
 bit 0, b                       ; CB 40
 bit 0, c                       ; CB 41
 bit 0, d                       ; CB 42
 bit 0, e                       ; CB 43
 bit 0, h                       ; CB 44
 bit 0, l                       ; CB 45
 bit 0, (hl)                    ; CB 46
 bit 0, a                       ; CB 47
 bit 1, b                       ; CB 48
 bit 1, c                       ; CB 49
 bit 1, d                       ; CB 4A
 bit 1, e                       ; CB 4B
 bit 1, h                       ; CB 4C
 bit 1, l                       ; CB 4D
 bit 1, (hl)                    ; CB 4E
 bit 1, a                       ; CB 4F
 bit 2, b                       ; CB 50
 bit 2, c                       ; CB 51
 bit 2, d                       ; CB 52
 bit 2, e                       ; CB 53
 bit 2, h                       ; CB 54
 bit 2, l                       ; CB 55
 bit 2, (hl)                    ; CB 56
 bit 2, a                       ; CB 57
 bit 3, b                       ; CB 58
 bit 3, c                       ; CB 59
 bit 3, d                       ; CB 5A
 bit 3, e                       ; CB 5B
 bit 3, h                       ; CB 5C
 bit 3, l                       ; CB 5D
 bit 3, (hl)                    ; CB 5E
 bit 3, a                       ; CB 5F
 bit 4, b                       ; CB 60
 bit 4, c                       ; CB 61
 bit 4, d                       ; CB 62
 bit 4, e                       ; CB 63
 bit 4, h                       ; CB 64
 bit 4, l                       ; CB 65
 bit 4, (hl)                    ; CB 66
 bit 4, a                       ; CB 67
 bit 5, b                       ; CB 68
 bit 5, c                       ; CB 69
 bit 5, d                       ; CB 6A
 bit 5, e                       ; CB 6B
 bit 5, h                       ; CB 6C
 bit 5, l                       ; CB 6D
 bit 5, (hl)                    ; CB 6E
 bit 5, a                       ; CB 6F
 bit 6, b                       ; CB 70
 bit 6, c                       ; CB 71
 bit 6, d                       ; CB 72
 bit 6, e                       ; CB 73
 bit 6, h                       ; CB 74
 bit 6, l                       ; CB 75
 bit 6, (hl)                    ; CB 76
 bit 6, a                       ; CB 77
 bit 7, b                       ; CB 78
 bit 7, c                       ; CB 79
 bit 7, d                       ; CB 7A
 bit 7, e                       ; CB 7B
 bit 7, h                       ; CB 7C
 bit 7, l                       ; CB 7D
 bit 7, (hl)                    ; CB 7E
 bit 7, a                       ; CB 7F
 res 0, b                       ; CB 80
 res 0, c                       ; CB 81
 res 0, d                       ; CB 82
 res 0, e                       ; CB 83
 res 0, h                       ; CB 84
 res 0, l                       ; CB 85
 res 0, (hl)                    ; CB 86
 res 0, a                       ; CB 87
 res 1, b                       ; CB 88
 res 1, c                       ; CB 89
 res 1, d                       ; CB 8A
 res 1, e                       ; CB 8B
 res 1, h                       ; CB 8C
 res 1, l                       ; CB 8D
 res 1, (hl)                    ; CB 8E
 res 1, a                       ; CB 8F
 res 2, b                       ; CB 90
 res 2, c                       ; CB 91
 res 2, d                       ; CB 92
 res 2, e                       ; CB 93
 res 2, h                       ; CB 94
 res 2, l                       ; CB 95
 res 2, (hl)                    ; CB 96
 res 2, a                       ; CB 97
 res 3, b                       ; CB 98
 res 3, c                       ; CB 99
 res 3, d                       ; CB 9A
 res 3, e                       ; CB 9B
 res 3, h                       ; CB 9C
 res 3, l                       ; CB 9D
 res 3, (hl)                    ; CB 9E
 res 3, a                       ; CB 9F
 res 4, b                       ; CB A0
 res 4, c                       ; CB A1
 res 4, d                       ; CB A2
 res 4, e                       ; CB A3
 res 4, h                       ; CB A4
 res 4, l                       ; CB A5
 res 4, (hl)                    ; CB A6
 res 4, a                       ; CB A7
 res 5, b                       ; CB A8
 res 5, c                       ; CB A9
 res 5, d                       ; CB AA
 res 5, e                       ; CB AB
 res 5, h                       ; CB AC
 res 5, l                       ; CB AD
 res 5, (hl)                    ; CB AE
 res 5, a                       ; CB AF
 res 6, b                       ; CB B0
 res 6, c                       ; CB B1
 res 6, d                       ; CB B2
 res 6, e                       ; CB B3
 res 6, h                       ; CB B4
 res 6, l                       ; CB B5
 res 6, (hl)                    ; CB B6
 res 6, a                       ; CB B7
 res 7, b                       ; CB B8
 res 7, c                       ; CB B9
 res 7, d                       ; CB BA
 res 7, e                       ; CB BB
 res 7, h                       ; CB BC
 res 7, l                       ; CB BD
 res 7, (hl)                    ; CB BE
 res 7, a                       ; CB BF
 set 0, b                       ; CB C0
 set 0, c                       ; CB C1
 set 0, d                       ; CB C2
 set 0, e                       ; CB C3
 set 0, h                       ; CB C4
 set 0, l                       ; CB C5
 set 0, (hl)                    ; CB C6
 set 0, a                       ; CB C7
 set 1, b                       ; CB C8
 set 1, c                       ; CB C9
 set 1, d                       ; CB CA
 set 1, e                       ; CB CB
 set 1, h                       ; CB CC
 set 1, l                       ; CB CD
 set 1, (hl)                    ; CB CE
 set 1, a                       ; CB CF
 set 2, b                       ; CB D0
 set 2, c                       ; CB D1
 set 2, d                       ; CB D2
 set 2, e                       ; CB D3
 set 2, h                       ; CB D4
 set 2, l                       ; CB D5
 set 2, (hl)                    ; CB D6
 set 2, a                       ; CB D7
 set 3, b                       ; CB D8
 set 3, c                       ; CB D9
 set 3, d                       ; CB DA
 set 3, e                       ; CB DB
 set 3, h                       ; CB DC
 set 3, l                       ; CB DD
 set 3, (hl)                    ; CB DE
 set 3, a                       ; CB DF
 set 4, b                       ; CB E0
 set 4, c                       ; CB E1
 set 4, d                       ; CB E2
 set 4, e                       ; CB E3
 set 4, h                       ; CB E4
 set 4, l                       ; CB E5
 set 4, (hl)                    ; CB E6
 set 4, a                       ; CB E7
 set 5, b                       ; CB E8
 set 5, c                       ; CB E9
 set 5, d                       ; CB EA
 set 5, e                       ; CB EB
 set 5, h                       ; CB EC
 set 5, l                       ; CB ED
 set 5, (hl)                    ; CB EE
 set 5, a                       ; CB EF
 set 6, b                       ; CB F0
 set 6, c                       ; CB F1
 set 6, d                       ; CB F2
 set 6, e                       ; CB F3
 set 6, h                       ; CB F4
 set 6, l                       ; CB F5
 set 6, (hl)                    ; CB F6
 set 6, a                       ; CB F7
 set 7, b                       ; CB F8
 set 7, c                       ; CB F9
 set 7, d                       ; CB FA
 set 7, e                       ; CB FB
 set 7, h                       ; CB FC
 set 7, l                       ; CB FD
 set 7, (hl)                    ; CB FE
 set 7, a                       ; CB FF
 call z, -32768                 ; CC 00 80
 c_z -32768                     ; CC 00 80
 cz -32768                      ; CC 00 80
 call z, 32767                  ; CC FF 7F
 call z, 65535                  ; CC FF FF
 c_z 32767                      ; CC FF 7F
 c_z 65535                      ; CC FF FF
 cz 32767                       ; CC FF 7F
 cz 65535                       ; CC FF FF
 call -32768                    ; CD 00 80
 call 32767                     ; CD FF 7F
 call 65535                     ; CD FF FF
 adc a, 127                     ; CE 7F
 adc 127                        ; CE 7F
 aci 127                        ; CE 7F
 aci -128                       ; CE 80
 adc a, -128                    ; CE 80
 adc -128                       ; CE 80
 adc a, 255                     ; CE FF
 adc 255                        ; CE FF
 aci 255                        ; CE FF
 rst 8                          ; CF
 rst 1                          ; CF
 ret nc                         ; D0
 rnc                            ; D0
 r_nc                           ; D0
 pop de                         ; D1
 pop d                          ; D1
 jp nc, -32768                  ; D2 00 80
 j_nc -32768                    ; D2 00 80
 jnc -32768                     ; D2 00 80
 j_nc 65535                     ; D2 FF FF
 jnc 32767                      ; D2 FF 7F
 jnc 65535                      ; D2 FF FF
 jp nc, 65535                   ; D2 FF FF
 jp nc, 32767                   ; D2 FF 7F
 j_nc 32767                     ; D2 FF 7F
 c_nc -32768                    ; D4 00 80
 call nc, -32768                ; D4 00 80
 cnc -32768                     ; D4 00 80
 c_nc 32767                     ; D4 FF 7F
 cnc 32767                      ; D4 FF 7F
 cnc 65535                      ; D4 FF FF
 call nc, 32767                 ; D4 FF 7F
 call nc, 65535                 ; D4 FF FF
 c_nc 65535                     ; D4 FF FF
 push de                        ; D5
 push d                         ; D5
 sui 127                        ; D6 7F
 sub 127                        ; D6 7F
 sub a, 127                     ; D6 7F
 sub a, -128                    ; D6 80
 sui -128                       ; D6 80
 sub -128                       ; D6 80
 sub 255                        ; D6 FF
 sui 255                        ; D6 FF
 sub a, 255                     ; D6 FF
 rst 2                          ; D7
 rst 16                         ; D7
 ret c                          ; D8
 r_c                            ; D8
 rc                             ; D8
 reti                           ; D9
 jp c, -32768                   ; DA 00 80
 j_c -32768                     ; DA 00 80
 jc -32768                      ; DA 00 80
 jp c, 32767                    ; DA FF 7F
 jp c, 65535                    ; DA FF FF
 jc 65535                       ; DA FF FF
 jc 32767                       ; DA FF 7F
 j_c 32767                      ; DA FF 7F
 j_c 65535                      ; DA FF FF
 cc -32768                      ; DC 00 80
 c_c -32768                     ; DC 00 80
 call c, -32768                 ; DC 00 80
 call c, 65535                  ; DC FF FF
 cc 32767                       ; DC FF 7F
 c_c 65535                      ; DC FF FF
 c_c 32767                      ; DC FF 7F
 cc 65535                       ; DC FF FF
 call c, 32767                  ; DC FF 7F
 sbc 127                        ; DE 7F
 sbc a, 127                     ; DE 7F
 sbi 127                        ; DE 7F
 sbc a, -128                    ; DE 80
 sbc -128                       ; DE 80
 sbi -128                       ; DE 80
 sbc a, 255                     ; DE FF
 sbc 255                        ; DE FF
 sbi 255                        ; DE FF
 rst 3                          ; DF
 rst 24                         ; DF
 ldh (127), a                   ; E0 7F
 ldh (-128), a                  ; E0 80
 ldh (255), a                   ; E0 FF
 pop h                          ; E1
 pop hl                         ; E1
 ld (c), a                      ; E2
 ldh (c), a                     ; E2
 push hl                        ; E5
 push h                         ; E5
 and a, 127                     ; E6 7F
 ani 127                        ; E6 7F
 and 127                        ; E6 7F
 and a, -128                    ; E6 80
 and -128                       ; E6 80
 ani -128                       ; E6 80
 ani 255                        ; E6 FF
 and 255                        ; E6 FF
 and a, 255                     ; E6 FF
 rst 32                         ; E7
 rst 4                          ; E7
 add sp, 127                    ; E8 7F
 add sp, -128                   ; E8 80
 jp (hl)                        ; E9
 pchl                           ; E9
 ld (-32768), a                 ; EA 00 80
 ld (65535), a                  ; EA FF FF
 ld (32767), a                  ; EA FF 7F
 xor 127                        ; EE 7F
 xor a, 127                     ; EE 7F
 xri 127                        ; EE 7F
 xor -128                       ; EE 80
 xor a, -128                    ; EE 80
 xri -128                       ; EE 80
 xri 255                        ; EE FF
 xor a, 255                     ; EE FF
 xor 255                        ; EE FF
 rst 5                          ; EF
 rst 40                         ; EF
 ldh a, (127)                   ; F0 7F
 ldh a, (-128)                  ; F0 80
 ldh a, (255)                   ; F0 FF
 pop af                         ; F1
 pop psw                        ; F1
 ld a, (c)                      ; F2
 ldh a, (c)                     ; F2
 di                             ; F3
 push psw                       ; F5
 push af                        ; F5
 ori 127                        ; F6 7F
 or 127                         ; F6 7F
 or a, 127                      ; F6 7F
 or -128                        ; F6 80
 ori -128                       ; F6 80
 or a, -128                     ; F6 80
 ori 255                        ; F6 FF
 or 255                         ; F6 FF
 or a, 255                      ; F6 FF
 rst 6                          ; F7
 rst 48                         ; F7
 ld hl, sp+127                  ; F8 7F
 ldhl sp, 127                   ; F8 7F
 ld hl, sp+-128                 ; F8 80
 ldhl sp, -128                  ; F8 80
 ld sp, hl                      ; F9
 ld a, (-32768)                 ; FA 00 80
 ld a, (32767)                  ; FA FF 7F
 ld a, (65535)                  ; FA FF FF
 ei                             ; FB
 cp 127                         ; FE 7F
 cpi 127                        ; FE 7F
 cp a, 127                      ; FE 7F
 cp -128                        ; FE 80
 cp a, -128                     ; FE 80
 cpi -128                       ; FE 80
 cp 255                         ; FE FF
 cp a, 255                      ; FE FF
 cpi 255                        ; FE FF
 rst 56                         ; FF
 rst 7                          ; FF
