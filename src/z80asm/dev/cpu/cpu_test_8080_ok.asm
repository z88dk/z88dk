 adc (hl)                       ; 8E
 adc -128                       ; CE 80
 adc 127                        ; CE 7F
 adc 255                        ; CE FF
 adc a                          ; 8F
 adc a, (hl)                    ; 8E
 adc a, -128                    ; CE 80
 adc a, 127                     ; CE 7F
 adc a, 255                     ; CE FF
 adc a, a                       ; 8F
 adc a, b                       ; 88
 adc a, c                       ; 89
 adc a, d                       ; 8A
 adc a, e                       ; 8B
 adc a, h                       ; 8C
 adc a, l                       ; 8D
 adc b                          ; 88
 adc c                          ; 89
 adc d                          ; 8A
 adc e                          ; 8B
 adc h                          ; 8C
 adc l                          ; 8D
 add (hl)                       ; 86
 add -128                       ; C6 80
 add 127                        ; C6 7F
 add 255                        ; C6 FF
 add a                          ; 87
 add a, (hl)                    ; 86
 add a, -128                    ; C6 80
 add a, 127                     ; C6 7F
 add a, 255                     ; C6 FF
 add a, a                       ; 87
 add a, b                       ; 80
 add a, c                       ; 81
 add a, d                       ; 82
 add a, e                       ; 83
 add a, h                       ; 84
 add a, l                       ; 85
 add b                          ; 80
 add c                          ; 81
 add d                          ; 82
 add e                          ; 83
 add h                          ; 84
 add hl, bc                     ; 09
 add hl, de                     ; 19
 add hl, hl                     ; 29
 add hl, sp                     ; 39
 add l                          ; 85
 and (hl)                       ; A6
 and -128                       ; E6 80
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; A7
 and a, (hl)                    ; A6
 and a, -128                    ; E6 80
 and a, 127                     ; E6 7F
 and a, 255                     ; E6 FF
 and a, a                       ; A7
 and a, b                       ; A0
 and a, c                       ; A1
 and a, d                       ; A2
 and a, e                       ; A3
 and a, h                       ; A4
 and a, l                       ; A5
 and b                          ; A0
 and c                          ; A1
 and d                          ; A2
 and e                          ; A3
 and h                          ; A4
 and l                          ; A5
 call -32768                    ; CD 00 80
 call 32767                     ; CD FF 7F
 call 65535                     ; CD FF FF
 call c, -32768                 ; DC 00 80
 call c, 32767                  ; DC FF 7F
 call c, 65535                  ; DC FF FF
 call m, -32768                 ; FC 00 80
 call m, 32767                  ; FC FF 7F
 call m, 65535                  ; FC FF FF
 call nc, -32768                ; D4 00 80
 call nc, 32767                 ; D4 FF 7F
 call nc, 65535                 ; D4 FF FF
 call nv, -32768                ; E4 00 80
 call nv, 32767                 ; E4 FF 7F
 call nv, 65535                 ; E4 FF FF
 call nz, -32768                ; C4 00 80
 call nz, 32767                 ; C4 FF 7F
 call nz, 65535                 ; C4 FF FF
 call p, -32768                 ; F4 00 80
 call p, 32767                  ; F4 FF 7F
 call p, 65535                  ; F4 FF FF
 call pe, -32768                ; EC 00 80
 call pe, 32767                 ; EC FF 7F
 call pe, 65535                 ; EC FF FF
 call po, -32768                ; E4 00 80
 call po, 32767                 ; E4 FF 7F
 call po, 65535                 ; E4 FF FF
 call v, -32768                 ; EC 00 80
 call v, 32767                  ; EC FF 7F
 call v, 65535                  ; EC FF FF
 call z, -32768                 ; CC 00 80
 call z, 32767                  ; CC FF 7F
 call z, 65535                  ; CC FF FF
 ccf                            ; 3F
 ccf f                          ; 3F
 cp (hl)                        ; BE
 cp -128                        ; FE 80
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; BF
 cp a, (hl)                     ; BE
 cp a, -128                     ; FE 80
 cp a, 127                      ; FE 7F
 cp a, 255                      ; FE FF
 cp a, a                        ; BF
 cp a, b                        ; B8
 cp a, c                        ; B9
 cp a, d                        ; BA
 cp a, e                        ; BB
 cp a, h                        ; BC
 cp a, l                        ; BD
 cp b                           ; B8
 cp c                           ; B9
 cp d                           ; BA
 cp e                           ; BB
 cp h                           ; BC
 cp l                           ; BD
 cpd                            ; CD @__z80asm__cpd
 cpdr                           ; CD @__z80asm__cpdr
 cpi                            ; CD @__z80asm__cpi
 cpir                           ; CD @__z80asm__cpir
 cpl                            ; 2F
 cpl a                          ; 2F
 dec (hl)                       ; 35
 dec a                          ; 3D
 dec b                          ; 05
 dec bc                         ; 0B
 dec c                          ; 0D
 dec d                          ; 15
 dec de                         ; 1B
 dec e                          ; 1D
 dec h                          ; 25
 dec hl                         ; 2B
 dec l                          ; 2D
 dec sp                         ; 3B
 di                             ; F3
 djnz ASMPC                     ; 05 C2 %m %m
 djnz b, ASMPC                  ; 05 C2 %m %m
 ei                             ; FB
 ex (sp), hl                    ; E3
 ex de, hl                      ; EB
 inc (hl)                       ; 34
 inc a                          ; 3C
 inc b                          ; 04
 inc bc                         ; 03
 inc c                          ; 0C
 inc d                          ; 14
 inc de                         ; 13
 inc e                          ; 1C
 inc h                          ; 24
 inc hl                         ; 23
 inc l                          ; 2C
 inc sp                         ; 33
 jp (hl)                        ; E9
 jp -32768                      ; C3 00 80
 jp 32767                       ; C3 FF 7F
 jp 65535                       ; C3 FF FF
 jp c, -32768                   ; DA 00 80
 jp c, 32767                    ; DA FF 7F
 jp c, 65535                    ; DA FF FF
 jp m, -32768                   ; FA 00 80
 jp m, 32767                    ; FA FF 7F
 jp m, 65535                    ; FA FF FF
 jp nc, -32768                  ; D2 00 80
 jp nc, 32767                   ; D2 FF 7F
 jp nc, 65535                   ; D2 FF FF
 jp nv, -32768                  ; E2 00 80
 jp nv, 32767                   ; E2 FF 7F
 jp nv, 65535                   ; E2 FF FF
 jp nz, -32768                  ; C2 00 80
 jp nz, 32767                   ; C2 FF 7F
 jp nz, 65535                   ; C2 FF FF
 jp p, -32768                   ; F2 00 80
 jp p, 32767                    ; F2 FF 7F
 jp p, 65535                    ; F2 FF FF
 jp pe, -32768                  ; EA 00 80
 jp pe, 32767                   ; EA FF 7F
 jp pe, 65535                   ; EA FF FF
 jp po, -32768                  ; E2 00 80
 jp po, 32767                   ; E2 FF 7F
 jp po, 65535                   ; E2 FF FF
 jp v, -32768                   ; EA 00 80
 jp v, 32767                    ; EA FF 7F
 jp v, 65535                    ; EA FF FF
 jp z, -32768                   ; CA 00 80
 jp z, 32767                    ; CA FF 7F
 jp z, 65535                    ; CA FF FF
 jr ASMPC                       ; C3 %m %m
 jr c, ASMPC                    ; DA %m %m
 jr nc, ASMPC                   ; D2 %m %m
 jr nz, ASMPC                   ; C2 %m %m
 jr z, ASMPC                    ; CA %m %m
 ld (-32768), a                 ; 32 00 80
 ld (-32768), hl                ; 22 00 80
 ld (32767), a                  ; 32 FF 7F
 ld (32767), hl                 ; 22 FF 7F
 ld (65535), a                  ; 32 FF FF
 ld (65535), hl                 ; 22 FF FF
 ld (bc), a                     ; 02
 ld (de), a                     ; 12
 ld (hl), -128                  ; 36 80
 ld (hl), 127                   ; 36 7F
 ld (hl), 255                   ; 36 FF
 ld (hl), a                     ; 77
 ld (hl), b                     ; 70
 ld (hl), c                     ; 71
 ld (hl), d                     ; 72
 ld (hl), e                     ; 73
 ld (hl), h                     ; 74
 ld (hl), l                     ; 75
 ld a, (-32768)                 ; 3A 00 80
 ld a, (32767)                  ; 3A FF 7F
 ld a, (65535)                  ; 3A FF FF
 ld a, (bc)                     ; 0A
 ld a, (de)                     ; 1A
 ld a, (hl)                     ; 7E
 ld a, -128                     ; 3E 80
 ld a, 127                      ; 3E 7F
 ld a, 255                      ; 3E FF
 ld a, a                        ; 7F
 ld a, b                        ; 78
 ld a, c                        ; 79
 ld a, d                        ; 7A
 ld a, e                        ; 7B
 ld a, h                        ; 7C
 ld a, l                        ; 7D
 ld b, (hl)                     ; 46
 ld b, -128                     ; 06 80
 ld b, 127                      ; 06 7F
 ld b, 255                      ; 06 FF
 ld b, a                        ; 47
 ld b, b                        ; 40
 ld b, c                        ; 41
 ld b, d                        ; 42
 ld b, e                        ; 43
 ld b, h                        ; 44
 ld b, l                        ; 45
 ld bc, -32768                  ; 01 00 80
 ld bc, 32767                   ; 01 FF 7F
 ld bc, 65535                   ; 01 FF FF
 ld c, (hl)                     ; 4E
 ld c, -128                     ; 0E 80
 ld c, 127                      ; 0E 7F
 ld c, 255                      ; 0E FF
 ld c, a                        ; 4F
 ld c, b                        ; 48
 ld c, c                        ; 49
 ld c, d                        ; 4A
 ld c, e                        ; 4B
 ld c, h                        ; 4C
 ld c, l                        ; 4D
 ld d, (hl)                     ; 56
 ld d, -128                     ; 16 80
 ld d, 127                      ; 16 7F
 ld d, 255                      ; 16 FF
 ld d, a                        ; 57
 ld d, b                        ; 50
 ld d, c                        ; 51
 ld d, d                        ; 52
 ld d, e                        ; 53
 ld d, h                        ; 54
 ld d, l                        ; 55
 ld de, -32768                  ; 11 00 80
 ld de, 32767                   ; 11 FF 7F
 ld de, 65535                   ; 11 FF FF
 ld e, (hl)                     ; 5E
 ld e, -128                     ; 1E 80
 ld e, 127                      ; 1E 7F
 ld e, 255                      ; 1E FF
 ld e, a                        ; 5F
 ld e, b                        ; 58
 ld e, c                        ; 59
 ld e, d                        ; 5A
 ld e, e                        ; 5B
 ld e, h                        ; 5C
 ld e, l                        ; 5D
 ld h, (hl)                     ; 66
 ld h, -128                     ; 26 80
 ld h, 127                      ; 26 7F
 ld h, 255                      ; 26 FF
 ld h, a                        ; 67
 ld h, b                        ; 60
 ld h, c                        ; 61
 ld h, d                        ; 62
 ld h, e                        ; 63
 ld h, h                        ; 64
 ld h, l                        ; 65
 ld hl, (-32768)                ; 2A 00 80
 ld hl, (32767)                 ; 2A FF 7F
 ld hl, (65535)                 ; 2A FF FF
 ld hl, -32768                  ; 21 00 80
 ld hl, 32767                   ; 21 FF 7F
 ld hl, 65535                   ; 21 FF FF
 ld l, (hl)                     ; 6E
 ld l, -128                     ; 2E 80
 ld l, 127                      ; 2E 7F
 ld l, 255                      ; 2E FF
 ld l, a                        ; 6F
 ld l, b                        ; 68
 ld l, c                        ; 69
 ld l, d                        ; 6A
 ld l, e                        ; 6B
 ld l, h                        ; 6C
 ld l, l                        ; 6D
 ld sp, -32768                  ; 31 00 80
 ld sp, 32767                   ; 31 FF 7F
 ld sp, 65535                   ; 31 FF FF
 ld sp, hl                      ; F9
 ldd                            ; CD @__z80asm__ldd
 lddr                           ; CD @__z80asm__lddr
 ldi                            ; CD @__z80asm__ldi
 ldir                           ; CD @__z80asm__ldir
 neg                            ; ED 44
 neg a                          ; ED 44
 nop                            ; 00
 or (hl)                        ; B6
 or -128                        ; F6 80
 or 127                         ; F6 7F
 or 255                         ; F6 FF
 or a                           ; B7
 or a, (hl)                     ; B6
 or a, -128                     ; F6 80
 or a, 127                      ; F6 7F
 or a, 255                      ; F6 FF
 or a, a                        ; B7
 or a, b                        ; B0
 or a, c                        ; B1
 or a, d                        ; B2
 or a, e                        ; B3
 or a, h                        ; B4
 or a, l                        ; B5
 or b                           ; B0
 or c                           ; B1
 or d                           ; B2
 or e                           ; B3
 or h                           ; B4
 or l                           ; B5
 pop af                         ; F1
 pop bc                         ; C1
 pop de                         ; D1
 pop hl                         ; E1
 push af                        ; F5
 push bc                        ; C5
 push de                        ; D5
 push hl                        ; E5
 ret                            ; C9
 ret c                          ; D8
 ret m                          ; F8
 ret nc                         ; D0
 ret nv                         ; E0
 ret nz                         ; C0
 ret p                          ; F0
 ret pe                         ; E8
 ret po                         ; E0
 ret v                          ; E8
 ret z                          ; C8
 rla                            ; 17
 rlca                           ; 07
 rra                            ; 1F
 rrca                           ; 0F
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
 sbc (hl)                       ; 9E
 sbc -128                       ; DE 80
 sbc 127                        ; DE 7F
 sbc 255                        ; DE FF
 sbc a                          ; 9F
 sbc a, (hl)                    ; 9E
 sbc a, -128                    ; DE 80
 sbc a, 127                     ; DE 7F
 sbc a, 255                     ; DE FF
 sbc a, a                       ; 9F
 sbc a, b                       ; 98
 sbc a, c                       ; 99
 sbc a, d                       ; 9A
 sbc a, e                       ; 9B
 sbc a, h                       ; 9C
 sbc a, l                       ; 9D
 sbc b                          ; 98
 sbc c                          ; 99
 sbc d                          ; 9A
 sbc e                          ; 9B
 sbc h                          ; 9C
 sbc l                          ; 9D
 scf                            ; 37
 scf f                          ; 37
 sub (hl)                       ; 96
 sub -128                       ; D6 80
 sub 127                        ; D6 7F
 sub 255                        ; D6 FF
 sub a                          ; 97
 sub a, (hl)                    ; 96
 sub a, -128                    ; D6 80
 sub a, 127                     ; D6 7F
 sub a, 255                     ; D6 FF
 sub a, a                       ; 97
 sub a, b                       ; 90
 sub a, c                       ; 91
 sub a, d                       ; 92
 sub a, e                       ; 93
 sub a, h                       ; 94
 sub a, l                       ; 95
 sub b                          ; 90
 sub c                          ; 91
 sub d                          ; 92
 sub e                          ; 93
 sub h                          ; 94
 sub l                          ; 95
 xor (hl)                       ; AE
 xor -128                       ; EE 80
 xor 127                        ; EE 7F
 xor 255                        ; EE FF
 xor a                          ; AF
 xor a, (hl)                    ; AE
 xor a, -128                    ; EE 80
 xor a, 127                     ; EE 7F
 xor a, 255                     ; EE FF
 xor a, a                       ; AF
 xor a, b                       ; A8
 xor a, c                       ; A9
 xor a, d                       ; AA
 xor a, e                       ; AB
 xor a, h                       ; AC
 xor a, l                       ; AD
 xor b                          ; A8
 xor c                          ; A9
 xor d                          ; AA
 xor e                          ; AB
 xor h                          ; AC
 xor l                          ; AD
