 aci -128                       ; CE 80
 aci 0                          ; CE 00
 aci 127                        ; CE 7F
 aci 255                        ; CE FF
 adc (hl)                       ; 8E
 adc -128                       ; CE 80
 adc 0                          ; CE 00
 adc 127                        ; CE 7F
 adc 255                        ; CE FF
 adc a                          ; 8F
 adc a, (hl)                    ; 8E
 adc a, -128                    ; CE 80
 adc a, 0                       ; CE 00
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
 adc m                          ; 8E
 add (hl)                       ; 86
 add -128                       ; C6 80
 add 0                          ; C6 00
 add 127                        ; C6 7F
 add 255                        ; C6 FF
 add a                          ; 87
 add a, (hl)                    ; 86
 add a, -128                    ; C6 80
 add a, 0                       ; C6 00
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
 add m                          ; 86
 adi -128                       ; C6 80
 adi 0                          ; C6 00
 adi 127                        ; C6 7F
 adi 255                        ; C6 FF
 adi hl, -128                   ; E5 11 80 00 19 EB E1
 adi hl, 0                      ; E5 11 00 00 19 EB E1
 adi hl, 127                    ; E5 11 7F 00 19 EB E1
 adi hl, 255                    ; E5 11 FF 00 19 EB E1
 adi sp, -128                   ; EB 21 80 00 39 EB
 adi sp, 0                      ; EB 21 00 00 39 EB
 adi sp, 127                    ; EB 21 7F 00 39 EB
 adi sp, 255                    ; EB 21 FF 00 39 EB
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
 and 0                          ; E6 00
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; A7
 and a, (hl)                    ; A6
 and a, -128                    ; E6 80
 and a, 0                       ; E6 00
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
 ani -128                       ; E6 80
 ani 0                          ; E6 00
 ani 127                        ; E6 7F
 ani 255                        ; E6 FF
 arhl                           ; CD @__z80asm__sra_hl
 call 0x1234                    ; CD 34 12
 call c, 0x1234                 ; DC 34 12
 call eq, 0x1234                ; CC 34 12
 call geu, 0x1234               ; D4 34 12
 call gtu, 0x1234               ; CA CF 00 D4 34 12
 call leu, 0x1234               ; CA D5 00 D2 D8 00 CD 34 12
 call ltu, 0x1234               ; DC 34 12
 call m, 0x1234                 ; FC 34 12
 call nc, 0x1234                ; D4 34 12
 call ne, 0x1234                ; C4 34 12
 call nv, 0x1234                ; E4 34 12
 call nz, 0x1234                ; C4 34 12
 call p, 0x1234                 ; F4 34 12
 call pe, 0x1234                ; EC 34 12
 call po, 0x1234                ; E4 34 12
 call v, 0x1234                 ; EC 34 12
 call z, 0x1234                 ; CC 34 12
 cc 0x1234                      ; DC 34 12
 ccf                            ; 3F
 ceq 0x1234                     ; CC 34 12
 cgeu 0x1234                    ; D4 34 12
 cgtu 0x1234                    ; CA 09 01 D4 34 12
 cleu 0x1234                    ; CA 0F 01 D2 12 01 CD 34 12
 cltu 0x1234                    ; DC 34 12
 cm 0x1234                      ; FC 34 12
 cma                            ; 2F
 cmc                            ; 3F
 cmp (hl)                       ; BE
 cmp -128                       ; FE 80
 cmp 0                          ; FE 00
 cmp 127                        ; FE 7F
 cmp 255                        ; FE FF
 cmp a                          ; BF
 cmp a, (hl)                    ; BE
 cmp a, -128                    ; FE 80
 cmp a, 0                       ; FE 00
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
 cnc 0x1234                     ; D4 34 12
 cne 0x1234                     ; C4 34 12
 cnv 0x1234                     ; E4 34 12
 cnz 0x1234                     ; C4 34 12
 cp (hl)                        ; BE
 cp -128                        ; FE 80
 cp 0                           ; FE 00
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; BF
 cp a, (hl)                     ; BE
 cp a, -128                     ; FE 80
 cp a, 0                        ; FE 00
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
 cpe 0x1234                     ; EC 34 12
 cpi -128                       ; FE 80
 cpi 0                          ; FE 00
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpl                            ; 2F
 cpl a                          ; 2F
 cpo 0x1234                     ; E4 34 12
 cv 0x1234                      ; EC 34 12
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
 dsub                           ; CD @__z80asm__sub_hl_bc
 ei                             ; FB
 ex (sp), hl                    ; E3
 ex de, hl                      ; EB
 halt                           ; 76
 hlt                            ; 76
 in -128                        ; DB 80
 in 0                           ; DB 00
 in 127                         ; DB 7F
 in 255                         ; DB FF
 in a, (-128)                   ; DB 80
 in a, (0)                      ; DB 00
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
 inx d                          ; 13
 inx h                          ; 23
 inx sp                         ; 33
 jc 0x1234                      ; DA 34 12
 jeq 0x1234                     ; CA 34 12
 jgeu 0x1234                    ; D2 34 12
 jgtu 0x1234                    ; CA DA 01 D2 34 12
 jleu 0x1234                    ; CA 34 12 DA 34 12
 jltu 0x1234                    ; DA 34 12
 jm 0x1234                      ; FA 34 12
 jmp 0x1234                     ; C3 34 12
 jnc 0x1234                     ; D2 34 12
 jne 0x1234                     ; C2 34 12
 jnv 0x1234                     ; E2 34 12
 jnz 0x1234                     ; C2 34 12
 jp (hl)                        ; E9
 jp 0x1234                      ; C3 34 12
 jp c, 0x1234                   ; DA 34 12
 jp eq, 0x1234                  ; CA 34 12
 jp geu, 0x1234                 ; D2 34 12
 jp gtu, 0x1234                 ; CA 08 02 D2 34 12
 jp leu, 0x1234                 ; CA 34 12 DA 34 12
 jp ltu, 0x1234                 ; DA 34 12
 jp m, 0x1234                   ; FA 34 12
 jp nc, 0x1234                  ; D2 34 12
 jp ne, 0x1234                  ; C2 34 12
 jp nv, 0x1234                  ; E2 34 12
 jp nz, 0x1234                  ; C2 34 12
 jp p, 0x1234                   ; F2 34 12
 jp pe, 0x1234                  ; EA 34 12
 jp po, 0x1234                  ; E2 34 12
 jp v, 0x1234                   ; EA 34 12
 jp z, 0x1234                   ; CA 34 12
 jpe 0x1234                     ; EA 34 12
 jpo 0x1234                     ; E2 34 12
 jr 0x1234                      ; C3 34 12
 jr c, 0x1234                   ; DA 34 12
 jr eq, 0x1234                  ; CA 34 12
 jr geu, 0x1234                 ; D2 34 12
 jr gtu, 0x1234                 ; CA 47 02 D2 34 12
 jr leu, 0x1234                 ; CA 34 12 DA 34 12
 jr ltu, 0x1234                 ; DA 34 12
 jr nc, 0x1234                  ; D2 34 12
 jr ne, 0x1234                  ; C2 34 12
 jr nz, 0x1234                  ; C2 34 12
 jr z, 0x1234                   ; CA 34 12
 jv 0x1234                      ; EA 34 12
 jz 0x1234                      ; CA 34 12
 ld (0x1234), a                 ; 32 34 12
 ld (0x1234), hl                ; 22 34 12
 ld (bc), a                     ; 02
 ld (de), a                     ; 12
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
 ld bc, 0x1234                  ; 01 34 12
 ld bc, de                      ; 42 4B
 ld bc, hl                      ; 44 4D
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
 ld de, 0x1234                  ; 11 34 12
 ld de, bc                      ; 50 59
 ld de, hl                      ; 54 5D
 ld de, hl+0                    ; E5 11 00 00 19 EB E1
 ld de, hl+128                  ; E5 11 80 00 19 EB E1
 ld de, hl+255                  ; E5 11 FF 00 19 EB E1
 ld de, sp                      ; EB 21 00 00 39 EB
 ld de, sp+0                    ; EB 21 00 00 39 EB
 ld de, sp+128                  ; EB 21 80 00 39 EB
 ld de, sp+255                  ; EB 21 FF 00 39 EB
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
 ld hl, sp                      ; 21 00 00 39
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
 ld sp, hl                      ; F9
 lda 0x1234                     ; 3A 34 12
 ldax b                         ; 0A
 ldax d                         ; 1A
 ldhi -128                      ; E5 11 80 00 19 EB E1
 ldhi 0                         ; E5 11 00 00 19 EB E1
 ldhi 127                       ; E5 11 7F 00 19 EB E1
 ldhi 255                       ; E5 11 FF 00 19 EB E1
 ldsi -128                      ; EB 21 80 00 39 EB
 ldsi 0                         ; EB 21 00 00 39 EB
 ldsi 127                       ; EB 21 7F 00 39 EB
 ldsi 255                       ; EB 21 FF 00 39 EB
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
 nop                            ; 00
 or (hl)                        ; B6
 or -128                        ; F6 80
 or 0                           ; F6 00
 or 127                         ; F6 7F
 or 255                         ; F6 FF
 or a                           ; B7
 or a, (hl)                     ; B6
 or a, -128                     ; F6 80
 or a, 0                        ; F6 00
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
 ori 0                          ; F6 00
 ori 127                        ; F6 7F
 ori 255                        ; F6 FF
 out (-128), a                  ; D3 80
 out (0), a                     ; D3 00
 out (127), a                   ; D3 7F
 out (255), a                   ; D3 FF
 out -128                       ; D3 80
 out 0                          ; D3 00
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
 rdel                           ; CD @__z80asm__rl_de
 req                            ; C8
 ret                            ; C9
 ret c                          ; D8
 ret eq                         ; C8
 ret geu                        ; D0
 ret gtu                        ; CA 63 04 D0
 ret leu                        ; C8 D8
 ret ltu                        ; D8
 ret m                          ; F8
 ret nc                         ; D0
 ret ne                         ; C0
 ret nv                         ; E0
 ret nz                         ; C0
 ret p                          ; F0
 ret pe                         ; E8
 ret po                         ; E0
 ret v                          ; E8
 ret z                          ; C8
 rgeu                           ; D0
 rgtu                           ; CA 75 04 D0
 rl bc                          ; CD @__z80asm__rl_bc
 rl de                          ; CD @__z80asm__rl_de
 rl hl                          ; CD @__z80asm__rl_hl
 rla                            ; 17
 rlc                            ; 07
 rlca                           ; 07
 rlde                           ; CD @__z80asm__rl_de
 rleu                           ; C8 D8
 rltu                           ; D8
 rm                             ; F8
 rnc                            ; D0
 rne                            ; C0
 rnv                            ; E0
 rnz                            ; C0
 rp                             ; F0
 rpe                            ; E8
 rpo                            ; E0
 rr bc                          ; CD @__z80asm__rr_bc
 rr de                          ; CD @__z80asm__rr_de
 rr hl                          ; CD @__z80asm__rr_hl
 rra                            ; 1F
 rrc                            ; 0F
 rrca                           ; 0F
 rrhl                           ; CD @__z80asm__sra_hl
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
 sbc 0                          ; DE 00
 sbc 127                        ; DE 7F
 sbc 255                        ; DE FF
 sbc a                          ; 9F
 sbc a, (hl)                    ; 9E
 sbc a, -128                    ; DE 80
 sbc a, 0                       ; DE 00
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
 sbc hl, bc                     ; CD @__z80asm__sbc_hl_bc
 sbc hl, de                     ; CD @__z80asm__sbc_hl_de
 sbc hl, hl                     ; CD @__z80asm__sbc_hl_hl
 sbc hl, sp                     ; CD @__z80asm__sbc_hl_sp
 sbc l                          ; 9D
 sbi -128                       ; DE 80
 sbi 0                          ; DE 00
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 scf                            ; 37
 shld 0x1234                    ; 22 34 12
 sphl                           ; F9
 sra bc                         ; CD @__z80asm__sra_bc
 sra de                         ; CD @__z80asm__sra_de
 sra hl                         ; CD @__z80asm__sra_hl
 sta 0x1234                     ; 32 34 12
 stax b                         ; 02
 stax d                         ; 12
 stc                            ; 37
 sub (hl)                       ; 96
 sub -128                       ; D6 80
 sub 0                          ; D6 00
 sub 127                        ; D6 7F
 sub 255                        ; D6 FF
 sub a                          ; 97
 sub a, (hl)                    ; 96
 sub a, -128                    ; D6 80
 sub a, 0                       ; D6 00
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
 sub hl, bc                     ; CD @__z80asm__sub_hl_bc
 sub hl, de                     ; CD @__z80asm__sub_hl_de
 sub hl, hl                     ; CD @__z80asm__sub_hl_hl
 sub hl, sp                     ; CD @__z80asm__sub_hl_sp
 sub l                          ; 95
 sub m                          ; 96
 sui -128                       ; D6 80
 sui 0                          ; D6 00
 sui 127                        ; D6 7F
 sui 255                        ; D6 FF
 xchg                           ; EB
 xor (hl)                       ; AE
 xor -128                       ; EE 80
 xor 0                          ; EE 00
 xor 127                        ; EE 7F
 xor 255                        ; EE FF
 xor a                          ; AF
 xor a, (hl)                    ; AE
 xor a, -128                    ; EE 80
 xor a, 0                       ; EE 00
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
 xri 0                          ; EE 00
 xri 127                        ; EE 7F
 xri 255                        ; EE FF
 xthl                           ; E3
