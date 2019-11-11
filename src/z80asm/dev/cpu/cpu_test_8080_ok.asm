 aci -128                       ; CE 80
 aci 127                        ; CE 7F
 aci 255                        ; CE FF
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
 adc hl, bc                     ; CD @__z80asm__adc_hl_bc
 adc hl, de                     ; CD @__z80asm__adc_hl_de
 adc hl, hl                     ; CD @__z80asm__adc_hl_hl
 adc l                          ; 8D
 adc m                          ; 8E
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
 add bc, -32768                 ; E5 21 00 80 09 44 4D E1
 add bc, 32767                  ; E5 21 FF 7F 09 44 4D E1
 add bc, 65535                  ; E5 21 FF FF 09 44 4D E1
 add bc, a                      ; CD @__z80asm__add_bc_a
 add c                          ; 81
 add d                          ; 82
 add de, -32768                 ; E5 21 00 80 19 54 5D E1
 add de, 32767                  ; E5 21 FF 7F 19 54 5D E1
 add de, 65535                  ; E5 21 FF FF 19 54 5D E1
 add de, a                      ; CD @__z80asm__add_de_a
 add e                          ; 83
 add h                          ; 84
 add hl, -32768                 ; D5 11 00 80 19 D1
 add hl, 32767                  ; D5 11 FF 7F 19 D1
 add hl, 65535                  ; D5 11 FF FF 19 D1
 add hl, a                      ; CD @__z80asm__add_hl_a
 add hl, bc                     ; 09
 add hl, de                     ; 19
 add hl, hl                     ; 29
 add hl, sp                     ; 39
 add l                          ; 85
 add m                          ; 86
 add.a sp, -128                 ; E5 3E 80 6F 17 9F 67 39 F9 E1
 add.a sp, 127                  ; E5 3E 7F 6F 17 9F 67 39 F9 E1
 adi -128                       ; C6 80
 adi 127                        ; C6 7F
 adi 255                        ; C6 FF
 ana a                          ; A7
 ana b                          ; A0
 ana c                          ; A1
 ana d                          ; A2
 ana e                          ; A3
 ana h                          ; A4
 ana l                          ; A5
 ana m                          ; A6
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
 and.a hl, bc                   ; 7C A0 67 7D A1 6F
 and.a hl, de                   ; 7C A2 67 7D A3 6F
 ani -128                       ; E6 80
 ani 127                        ; E6 7F
 ani 255                        ; E6 FF
 bit.a 0, (hl)                  ; 7E E6 01
 bit.a 0, a                     ; E6 01
 bit.a 0, b                     ; 78 E6 01
 bit.a 0, c                     ; 79 E6 01
 bit.a 0, d                     ; 7A E6 01
 bit.a 0, e                     ; 7B E6 01
 bit.a 0, h                     ; 7C E6 01
 bit.a 0, l                     ; 7D E6 01
 bit.a 1, (hl)                  ; 7E E6 02
 bit.a 1, a                     ; E6 02
 bit.a 1, b                     ; 78 E6 02
 bit.a 1, c                     ; 79 E6 02
 bit.a 1, d                     ; 7A E6 02
 bit.a 1, e                     ; 7B E6 02
 bit.a 1, h                     ; 7C E6 02
 bit.a 1, l                     ; 7D E6 02
 bit.a 2, (hl)                  ; 7E E6 04
 bit.a 2, a                     ; E6 04
 bit.a 2, b                     ; 78 E6 04
 bit.a 2, c                     ; 79 E6 04
 bit.a 2, d                     ; 7A E6 04
 bit.a 2, e                     ; 7B E6 04
 bit.a 2, h                     ; 7C E6 04
 bit.a 2, l                     ; 7D E6 04
 bit.a 3, (hl)                  ; 7E E6 08
 bit.a 3, a                     ; E6 08
 bit.a 3, b                     ; 78 E6 08
 bit.a 3, c                     ; 79 E6 08
 bit.a 3, d                     ; 7A E6 08
 bit.a 3, e                     ; 7B E6 08
 bit.a 3, h                     ; 7C E6 08
 bit.a 3, l                     ; 7D E6 08
 bit.a 4, (hl)                  ; 7E E6 10
 bit.a 4, a                     ; E6 10
 bit.a 4, b                     ; 78 E6 10
 bit.a 4, c                     ; 79 E6 10
 bit.a 4, d                     ; 7A E6 10
 bit.a 4, e                     ; 7B E6 10
 bit.a 4, h                     ; 7C E6 10
 bit.a 4, l                     ; 7D E6 10
 bit.a 5, (hl)                  ; 7E E6 20
 bit.a 5, a                     ; E6 20
 bit.a 5, b                     ; 78 E6 20
 bit.a 5, c                     ; 79 E6 20
 bit.a 5, d                     ; 7A E6 20
 bit.a 5, e                     ; 7B E6 20
 bit.a 5, h                     ; 7C E6 20
 bit.a 5, l                     ; 7D E6 20
 bit.a 6, (hl)                  ; 7E E6 40
 bit.a 6, a                     ; E6 40
 bit.a 6, b                     ; 78 E6 40
 bit.a 6, c                     ; 79 E6 40
 bit.a 6, d                     ; 7A E6 40
 bit.a 6, e                     ; 7B E6 40
 bit.a 6, h                     ; 7C E6 40
 bit.a 6, l                     ; 7D E6 40
 bit.a 7, (hl)                  ; 7E E6 80
 bit.a 7, a                     ; E6 80
 bit.a 7, b                     ; 78 E6 80
 bit.a 7, c                     ; 79 E6 80
 bit.a 7, d                     ; 7A E6 80
 bit.a 7, e                     ; 7B E6 80
 bit.a 7, h                     ; 7C E6 80
 bit.a 7, l                     ; 7D E6 80
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
 cc -32768                      ; DC 00 80
 cc 32767                       ; DC FF 7F
 cc 65535                       ; DC FF FF
 ccf                            ; 3F
 cm -32768                      ; FC 00 80
 cm 32767                       ; FC FF 7F
 cm 65535                       ; FC FF FF
 cma                            ; 2F
 cmc                            ; 3F
 cmp (hl)                       ; BE
 cmp -128                       ; FE 80
 cmp 127                        ; FE 7F
 cmp 255                        ; FE FF
 cmp a                          ; BF
 cmp a, (hl)                    ; BE
 cmp a, -128                    ; FE 80
 cmp a, 127                     ; FE 7F
 cmp a, 255                     ; FE FF
 cmp a, a                       ; BF
 cmp a, b                       ; B8
 cmp a, c                       ; B9
 cmp a, d                       ; BA
 cmp a, e                       ; BB
 cmp a, h                       ; BC
 cmp a, l                       ; BD
 cmp b                          ; B8
 cmp c                          ; B9
 cmp d                          ; BA
 cmp e                          ; BB
 cmp h                          ; BC
 cmp l                          ; BD
 cmp m                          ; BE
 cnc -32768                     ; D4 00 80
 cnc 32767                      ; D4 FF 7F
 cnc 65535                      ; D4 FF FF
 cnv -32768                     ; E4 00 80
 cnv 32767                      ; E4 FF 7F
 cnv 65535                      ; E4 FF FF
 cnz -32768                     ; C4 00 80
 cnz 32767                      ; C4 FF 7F
 cnz 65535                      ; C4 FF FF
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
 cpe -32768                     ; EC 00 80
 cpe 32767                      ; EC FF 7F
 cpe 65535                      ; EC FF FF
 cpi                            ; CD @__z80asm__cpi
 cpi -128                       ; FE 80
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpir                           ; CD @__z80asm__cpir
 cpl                            ; 2F
 cpl a                          ; 2F
 cpo -32768                     ; E4 00 80
 cpo 32767                      ; E4 FF 7F
 cpo 65535                      ; E4 FF FF
 cv -32768                      ; EC 00 80
 cv 32767                       ; EC FF 7F
 cv 65535                       ; EC FF FF
 cz -32768                      ; CC 00 80
 cz 32767                       ; CC FF 7F
 cz 65535                       ; CC FF FF
 daa                            ; 27
 dad b                          ; 09
 dad bc                         ; 09
 dad d                          ; 19
 dad de                         ; 19
 dad h                          ; 29
 dad hl                         ; 29
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
 dcx bc                         ; 0B
 dcx d                          ; 1B
 dcx de                         ; 1B
 dcx h                          ; 2B
 dcx hl                         ; 2B
 dcx sp                         ; 3B
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
 djnz -32768                    ; 05 C2 00 80
 djnz 32767                     ; 05 C2 FF 7F
 djnz 65535                     ; 05 C2 FF FF
 djnz b, -32768                 ; 05 C2 00 80
 djnz b, 32767                  ; 05 C2 FF 7F
 djnz b, 65535                  ; 05 C2 FF FF
 ei                             ; FB
 ex (sp), hl                    ; E3
 ex de, hl                      ; EB
 halt                           ; 76
 hlt                            ; 76
 in -128                        ; DB 80
 in 127                         ; DB 7F
 in 255                         ; DB FF
 in a, (-128)                   ; DB 80
 in a, (127)                    ; DB 7F
 in a, (255)                    ; DB FF
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
 inr a                          ; 3C
 inr b                          ; 04
 inr c                          ; 0C
 inr d                          ; 14
 inr e                          ; 1C
 inr h                          ; 24
 inr l                          ; 2C
 inr m                          ; 34
 inx b                          ; 03
 inx bc                         ; 03
 inx d                          ; 13
 inx de                         ; 13
 inx h                          ; 23
 inx hl                         ; 23
 inx sp                         ; 33
 jc -32768                      ; DA 00 80
 jc 32767                       ; DA FF 7F
 jc 65535                       ; DA FF FF
 jm -32768                      ; FA 00 80
 jm 32767                       ; FA FF 7F
 jm 65535                       ; FA FF FF
 jmp -32768                     ; C3 00 80
 jmp 32767                      ; C3 FF 7F
 jmp 65535                      ; C3 FF FF
 jnc -32768                     ; D2 00 80
 jnc 32767                      ; D2 FF 7F
 jnc 65535                      ; D2 FF FF
 jnv -32768                     ; E2 00 80
 jnv 32767                      ; E2 FF 7F
 jnv 65535                      ; E2 FF FF
 jnz -32768                     ; C2 00 80
 jnz 32767                      ; C2 FF 7F
 jnz 65535                      ; C2 FF FF
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
 jpe -32768                     ; EA 00 80
 jpe 32767                      ; EA FF 7F
 jpe 65535                      ; EA FF FF
 jpo -32768                     ; E2 00 80
 jpo 32767                      ; E2 FF 7F
 jpo 65535                      ; E2 FF FF
 jr -32768                      ; C3 00 80
 jr 32767                       ; C3 FF 7F
 jr 65535                       ; C3 FF FF
 jr c, -32768                   ; DA 00 80
 jr c, 32767                    ; DA FF 7F
 jr c, 65535                    ; DA FF FF
 jr nc, -32768                  ; D2 00 80
 jr nc, 32767                   ; D2 FF 7F
 jr nc, 65535                   ; D2 FF FF
 jr nz, -32768                  ; C2 00 80
 jr nz, 32767                   ; C2 FF 7F
 jr nz, 65535                   ; C2 FF FF
 jr z, -32768                   ; CA 00 80
 jr z, 32767                    ; CA FF 7F
 jr z, 65535                    ; CA FF FF
 jv -32768                      ; EA 00 80
 jv 32767                       ; EA FF 7F
 jv 65535                       ; EA FF FF
 jz -32768                      ; CA 00 80
 jz 32767                       ; CA FF 7F
 jz 65535                       ; CA FF FF
 ld (-32768), a                 ; 32 00 80
 ld (-32768), hl                ; 22 00 80
 ld (32767), a                  ; 32 FF 7F
 ld (32767), hl                 ; 22 FF 7F
 ld (65535), a                  ; 32 FF FF
 ld (65535), hl                 ; 22 FF FF
 ld (bc), a                     ; 02
 ld (bc+), a                    ; 02 03
 ld (bc-), a                    ; 02 0B
 ld (de), a                     ; 12
 ld (de+), a                    ; 12 13
 ld (de-), a                    ; 12 1B
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
 ld (hl+), a                    ; 77 23
 ld (hl-), a                    ; 77 2B
 ld (hld), a                    ; 77 2B
 ld (hli), a                    ; 77 23
 ld a, (-32768)                 ; 3A 00 80
 ld a, (32767)                  ; 3A FF 7F
 ld a, (65535)                  ; 3A FF FF
 ld a, (bc)                     ; 0A
 ld a, (bc+)                    ; 0A 03
 ld a, (bc-)                    ; 0A 0B
 ld a, (de)                     ; 1A
 ld a, (de+)                    ; 1A 13
 ld a, (de-)                    ; 1A 1B
 ld a, (hl)                     ; 7E
 ld a, (hl+)                    ; 7E 23
 ld a, (hl-)                    ; 7E 2B
 ld a, (hld)                    ; 7E 2B
 ld a, (hli)                    ; 7E 23
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
 ld bc, de                      ; 42 4B
 ld bc, hl                      ; 44 4D
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
 ld de, bc                      ; 50 59
 ld de, hl                      ; 54 5D
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
 ld hl, bc                      ; 60 69
 ld hl, de                      ; 62 6B
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
 lda -32768                     ; 3A 00 80
 lda 32767                      ; 3A FF 7F
 lda 65535                      ; 3A FF FF
 ldax b                         ; 0A
 ldax bc                        ; 0A
 ldax d                         ; 1A
 ldax de                        ; 1A
 ldd                            ; CD @__z80asm__ldd
 ldd (bc), a                    ; 02 0B
 ldd (de), a                    ; 12 1B
 ldd (hl), a                    ; 77 2B
 ldd a, (bc)                    ; 0A 0B
 ldd a, (de)                    ; 1A 1B
 ldd a, (hl)                    ; 7E 2B
 lddr                           ; CD @__z80asm__lddr
 ldi                            ; CD @__z80asm__ldi
 ldi (bc), a                    ; 02 03
 ldi (de), a                    ; 12 13
 ldi (hl), a                    ; 77 23
 ldi a, (bc)                    ; 0A 03
 ldi a, (de)                    ; 1A 13
 ldi a, (hl)                    ; 7E 23
 ldir                           ; CD @__z80asm__ldir
 lhld -32768                    ; 2A 00 80
 lhld 32767                     ; 2A FF 7F
 lhld 65535                     ; 2A FF FF
 lxi b, -32768                  ; 01 00 80
 lxi b, 32767                   ; 01 FF 7F
 lxi b, 65535                   ; 01 FF FF
 lxi bc, -32768                 ; 01 00 80
 lxi bc, 32767                  ; 01 FF 7F
 lxi bc, 65535                  ; 01 FF FF
 lxi d, -32768                  ; 11 00 80
 lxi d, 32767                   ; 11 FF 7F
 lxi d, 65535                   ; 11 FF FF
 lxi de, -32768                 ; 11 00 80
 lxi de, 32767                  ; 11 FF 7F
 lxi de, 65535                  ; 11 FF FF
 lxi h, -32768                  ; 21 00 80
 lxi h, 32767                   ; 21 FF 7F
 lxi h, 65535                   ; 21 FF FF
 lxi hl, -32768                 ; 21 00 80
 lxi hl, 32767                  ; 21 FF 7F
 lxi hl, 65535                  ; 21 FF FF
 lxi sp, -32768                 ; 31 00 80
 lxi sp, 32767                  ; 31 FF 7F
 lxi sp, 65535                  ; 31 FF FF
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
 mvi a, 127                     ; 3E 7F
 mvi a, 255                     ; 3E FF
 mvi b, -128                    ; 06 80
 mvi b, 127                     ; 06 7F
 mvi b, 255                     ; 06 FF
 mvi c, -128                    ; 0E 80
 mvi c, 127                     ; 0E 7F
 mvi c, 255                     ; 0E FF
 mvi d, -128                    ; 16 80
 mvi d, 127                     ; 16 7F
 mvi d, 255                     ; 16 FF
 mvi e, -128                    ; 1E 80
 mvi e, 127                     ; 1E 7F
 mvi e, 255                     ; 1E FF
 mvi h, -128                    ; 26 80
 mvi h, 127                     ; 26 7F
 mvi h, 255                     ; 26 FF
 mvi l, -128                    ; 2E 80
 mvi l, 127                     ; 2E 7F
 mvi l, 255                     ; 2E FF
 mvi m, -128                    ; 36 80
 mvi m, 127                     ; 36 7F
 mvi m, 255                     ; 36 FF
 neg                            ; 2F 3C
 neg a                          ; 2F 3C
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
 ora a                          ; B7
 ora b                          ; B0
 ora c                          ; B1
 ora d                          ; B2
 ora e                          ; B3
 ora h                          ; B4
 ora l                          ; B5
 ora m                          ; B6
 ori -128                       ; F6 80
 ori 127                        ; F6 7F
 ori 255                        ; F6 FF
 out (-128), a                  ; D3 80
 out (127), a                   ; D3 7F
 out (255), a                   ; D3 FF
 out -128                       ; D3 80
 out 127                        ; D3 7F
 out 255                        ; D3 FF
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
 ral                            ; 17
 rar                            ; 1F
 rc                             ; D8
 res.a 0, (hl)                  ; 7E E6 FE 77
 res.a 0, a                     ; E6 FE
 res.a 0, b                     ; 78 E6 FE 47
 res.a 0, c                     ; 79 E6 FE 4F
 res.a 0, d                     ; 7A E6 FE 57
 res.a 0, e                     ; 7B E6 FE 5F
 res.a 0, h                     ; 7C E6 FE 67
 res.a 0, l                     ; 7D E6 FE 6F
 res.a 1, (hl)                  ; 7E E6 FD 77
 res.a 1, a                     ; E6 FD
 res.a 1, b                     ; 78 E6 FD 47
 res.a 1, c                     ; 79 E6 FD 4F
 res.a 1, d                     ; 7A E6 FD 57
 res.a 1, e                     ; 7B E6 FD 5F
 res.a 1, h                     ; 7C E6 FD 67
 res.a 1, l                     ; 7D E6 FD 6F
 res.a 2, (hl)                  ; 7E E6 FB 77
 res.a 2, a                     ; E6 FB
 res.a 2, b                     ; 78 E6 FB 47
 res.a 2, c                     ; 79 E6 FB 4F
 res.a 2, d                     ; 7A E6 FB 57
 res.a 2, e                     ; 7B E6 FB 5F
 res.a 2, h                     ; 7C E6 FB 67
 res.a 2, l                     ; 7D E6 FB 6F
 res.a 3, (hl)                  ; 7E E6 F7 77
 res.a 3, a                     ; E6 F7
 res.a 3, b                     ; 78 E6 F7 47
 res.a 3, c                     ; 79 E6 F7 4F
 res.a 3, d                     ; 7A E6 F7 57
 res.a 3, e                     ; 7B E6 F7 5F
 res.a 3, h                     ; 7C E6 F7 67
 res.a 3, l                     ; 7D E6 F7 6F
 res.a 4, (hl)                  ; 7E E6 EF 77
 res.a 4, a                     ; E6 EF
 res.a 4, b                     ; 78 E6 EF 47
 res.a 4, c                     ; 79 E6 EF 4F
 res.a 4, d                     ; 7A E6 EF 57
 res.a 4, e                     ; 7B E6 EF 5F
 res.a 4, h                     ; 7C E6 EF 67
 res.a 4, l                     ; 7D E6 EF 6F
 res.a 5, (hl)                  ; 7E E6 DF 77
 res.a 5, a                     ; E6 DF
 res.a 5, b                     ; 78 E6 DF 47
 res.a 5, c                     ; 79 E6 DF 4F
 res.a 5, d                     ; 7A E6 DF 57
 res.a 5, e                     ; 7B E6 DF 5F
 res.a 5, h                     ; 7C E6 DF 67
 res.a 5, l                     ; 7D E6 DF 6F
 res.a 6, (hl)                  ; 7E E6 BF 77
 res.a 6, a                     ; E6 BF
 res.a 6, b                     ; 78 E6 BF 47
 res.a 6, c                     ; 79 E6 BF 4F
 res.a 6, d                     ; 7A E6 BF 57
 res.a 6, e                     ; 7B E6 BF 5F
 res.a 6, h                     ; 7C E6 BF 67
 res.a 6, l                     ; 7D E6 BF 6F
 res.a 7, (hl)                  ; 7E E6 7F 77
 res.a 7, a                     ; E6 7F
 res.a 7, b                     ; 78 E6 7F 47
 res.a 7, c                     ; 79 E6 7F 4F
 res.a 7, d                     ; 7A E6 7F 57
 res.a 7, e                     ; 7B E6 7F 5F
 res.a 7, h                     ; 7C E6 7F 67
 res.a 7, l                     ; 7D E6 7F 6F
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
 rlc                            ; 07
 rlca                           ; 07
 rm                             ; F8
 rnc                            ; D0
 rnv                            ; E0
 rnz                            ; C0
 rp                             ; F0
 rpe                            ; E8
 rpo                            ; E0
 rra                            ; 1F
 rrc                            ; 0F
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
 rv                             ; E8
 rz                             ; C8
 sbb a                          ; 9F
 sbb b                          ; 98
 sbb c                          ; 99
 sbb d                          ; 9A
 sbb e                          ; 9B
 sbb h                          ; 9C
 sbb l                          ; 9D
 sbb m                          ; 9E
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
 sbi -128                       ; DE 80
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 scf                            ; 37
 set.a 0, (hl)                  ; 7E F6 01 77
 set.a 0, a                     ; F6 01
 set.a 0, b                     ; 78 F6 01 47
 set.a 0, c                     ; 79 F6 01 4F
 set.a 0, d                     ; 7A F6 01 57
 set.a 0, e                     ; 7B F6 01 5F
 set.a 0, h                     ; 7C F6 01 67
 set.a 0, l                     ; 7D F6 01 6F
 set.a 1, (hl)                  ; 7E F6 02 77
 set.a 1, a                     ; F6 02
 set.a 1, b                     ; 78 F6 02 47
 set.a 1, c                     ; 79 F6 02 4F
 set.a 1, d                     ; 7A F6 02 57
 set.a 1, e                     ; 7B F6 02 5F
 set.a 1, h                     ; 7C F6 02 67
 set.a 1, l                     ; 7D F6 02 6F
 set.a 2, (hl)                  ; 7E F6 04 77
 set.a 2, a                     ; F6 04
 set.a 2, b                     ; 78 F6 04 47
 set.a 2, c                     ; 79 F6 04 4F
 set.a 2, d                     ; 7A F6 04 57
 set.a 2, e                     ; 7B F6 04 5F
 set.a 2, h                     ; 7C F6 04 67
 set.a 2, l                     ; 7D F6 04 6F
 set.a 3, (hl)                  ; 7E F6 08 77
 set.a 3, a                     ; F6 08
 set.a 3, b                     ; 78 F6 08 47
 set.a 3, c                     ; 79 F6 08 4F
 set.a 3, d                     ; 7A F6 08 57
 set.a 3, e                     ; 7B F6 08 5F
 set.a 3, h                     ; 7C F6 08 67
 set.a 3, l                     ; 7D F6 08 6F
 set.a 4, (hl)                  ; 7E F6 10 77
 set.a 4, a                     ; F6 10
 set.a 4, b                     ; 78 F6 10 47
 set.a 4, c                     ; 79 F6 10 4F
 set.a 4, d                     ; 7A F6 10 57
 set.a 4, e                     ; 7B F6 10 5F
 set.a 4, h                     ; 7C F6 10 67
 set.a 4, l                     ; 7D F6 10 6F
 set.a 5, (hl)                  ; 7E F6 20 77
 set.a 5, a                     ; F6 20
 set.a 5, b                     ; 78 F6 20 47
 set.a 5, c                     ; 79 F6 20 4F
 set.a 5, d                     ; 7A F6 20 57
 set.a 5, e                     ; 7B F6 20 5F
 set.a 5, h                     ; 7C F6 20 67
 set.a 5, l                     ; 7D F6 20 6F
 set.a 6, (hl)                  ; 7E F6 40 77
 set.a 6, a                     ; F6 40
 set.a 6, b                     ; 78 F6 40 47
 set.a 6, c                     ; 79 F6 40 4F
 set.a 6, d                     ; 7A F6 40 57
 set.a 6, e                     ; 7B F6 40 5F
 set.a 6, h                     ; 7C F6 40 67
 set.a 6, l                     ; 7D F6 40 6F
 set.a 7, (hl)                  ; 7E F6 80 77
 set.a 7, a                     ; F6 80
 set.a 7, b                     ; 78 F6 80 47
 set.a 7, c                     ; 79 F6 80 4F
 set.a 7, d                     ; 7A F6 80 57
 set.a 7, e                     ; 7B F6 80 5F
 set.a 7, h                     ; 7C F6 80 67
 set.a 7, l                     ; 7D F6 80 6F
 shld -32768                    ; 22 00 80
 shld 32767                     ; 22 FF 7F
 shld 65535                     ; 22 FF FF
 sphl                           ; F9
 sta -32768                     ; 32 00 80
 sta 32767                      ; 32 FF 7F
 sta 65535                      ; 32 FF FF
 stax b                         ; 02
 stax bc                        ; 02
 stax d                         ; 12
 stax de                        ; 12
 stc                            ; 37
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
 sub m                          ; 96
 sui -128                       ; D6 80
 sui 127                        ; D6 7F
 sui 255                        ; D6 FF
 xchg                           ; EB
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
 xra a                          ; AF
 xra b                          ; A8
 xra c                          ; A9
 xra d                          ; AA
 xra e                          ; AB
 xra h                          ; AC
 xra l                          ; AD
 xra m                          ; AE
 xri -128                       ; EE 80
 xri 127                        ; EE 7F
 xri 255                        ; EE FF
 xthl                           ; E3
