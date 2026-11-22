 aci 0                          ; CE 00
 aci 127                        ; CE 7F
 aci 255                        ; CE FF
 adc (hl')                      ; 38 8E
 adc (hl)                       ; 8E
 adc (hl+)                      ; 8E 23
 adc (hl-)                      ; 8E 2B
 adc 0                          ; CE 00
 adc 127                        ; CE 7F
 adc 255                        ; CE FF
 adc a                          ; 8F
 adc a, (hl')                   ; 38 8E
 adc a, (hl)                    ; 8E
 adc a, (hl+)                   ; 8E 23
 adc a, (hl-)                   ; 8E 2B
 adc a, 0                       ; CE 00
 adc a, 127                     ; CE 7F
 adc a, 255                     ; CE FF
 adc a, a                       ; 8F
 adc a, b                       ; 88
 adc a, c                       ; 89
 adc a, d                       ; 8A
 adc a, e                       ; 8B
 adc a, h                       ; 8C
 adc a, h'                      ; 38 8C
 adc a, l                       ; 8D
 adc a, l'                      ; 38 8D
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
 add (hl')                      ; 38 86
 add (hl)                       ; 86
 add (hl+)                      ; 86 23
 add (hl-)                      ; 86 2B
 add 0                          ; C6 00
 add 127                        ; C6 7F
 add 255                        ; C6 FF
 add a                          ; 87
 add a, (hl')                   ; 38 86
 add a, (hl)                    ; 86
 add a, (hl+)                   ; 86 23
 add a, (hl-)                   ; 86 2B
 add a, 0                       ; C6 00
 add a, 127                     ; C6 7F
 add a, 255                     ; C6 FF
 add a, a                       ; 87
 add a, b                       ; 80
 add a, c                       ; 81
 add a, d                       ; 82
 add a, e                       ; 83
 add a, h                       ; 84
 add a, h'                      ; 38 84
 add a, l                       ; 85
 add a, l'                      ; 38 85
 add b                          ; 80
 add bc, 0x1234                 ; E5 21 34 12 09 44 4D E1
 add bc, a                      ; CD @__z80asm__add_bc_a x
 add c                          ; 81
 add d                          ; 82
 add de, 0x1234                 ; E5 21 34 12 19 54 5D E1
 add de, a                      ; CD @__z80asm__add_de_a x
 add e                          ; 83
 add h                          ; 84
 add h'                         ; 38 84
 add hl', bc                    ; 38 09
 add hl', de                    ; 38 19
 add hl', hl'                   ; 38 29
 add hl', sp                    ; 38 39
 add hl, 0x1234                 ; D5 11 34 12 19 D1
 add hl, a                      ; CD @__z80asm__add_hl_a x
 add hl, bc                     ; 09
 add hl, de                     ; 19
 add hl, hl                     ; 29
 add hl, sp                     ; 39
 add l                          ; 85
 add l'                         ; 38 85
 add m                          ; 86
 add sp, -128                   ; CD @__z80asm__add_sp_d x 80
 add sp, 0                      ; CD @__z80asm__add_sp_d x 00
 add sp, 126                    ; CD @__z80asm__add_sp_d x 7E
 adi 0                          ; C6 00
 adi 127                        ; C6 7F
 adi 255                        ; C6 FF
 adi hl, 0                      ; E5 11 00 00 19 EB E1
 adi hl, 127                    ; E5 11 7F 00 19 EB E1
 adi hl, 255                    ; E5 11 FF 00 19 EB E1
 adi sp, 0                      ; EB 21 00 00 39 EB
 adi sp, 127                    ; EB 21 7F 00 39 EB
 adi sp, 255                    ; EB 21 FF 00 39 EB
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
 and (hl')                      ; 38 A6
 and (hl)                       ; A6
 and (hl+)                      ; A6 23
 and (hl-)                      ; A6 2B
 and 0                          ; E6 00
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; A7
 and a, (hl')                   ; 38 A6
 and a, (hl)                    ; A6
 and a, (hl+)                   ; A6 23
 and a, (hl-)                   ; A6 2B
 and a, 0                       ; E6 00
 and a, 127                     ; E6 7F
 and a, 255                     ; E6 FF
 and a, a                       ; A7
 and a, b                       ; A0
 and a, c                       ; A1
 and a, d                       ; A2
 and a, e                       ; A3
 and a, h                       ; A4
 and a, h'                      ; 38 A4
 and a, l                       ; A5
 and a, l'                      ; 38 A5
 and b                          ; A0
 and c                          ; A1
 and d                          ; A2
 and e                          ; A3
 and h                          ; A4
 and h'                         ; 38 A4
 and hl, bc                     ; F5 7C A0 67 7D A1 6F F1
 and hl, de                     ; F5 7C A2 67 7D A3 6F F1
 and l                          ; A5
 and l'                         ; 38 A5
 andl (hl')                     ; 38 10
 andl (hl)                      ; 10
 andm                           ; 10
 ani 0                          ; E6 00
 ani 127                        ; E6 7F
 ani 255                        ; E6 FF
 anx                            ; 10
 arhl                           ; CD @__z80asm__sra_hl x
 bool hl                        ; F5 7C B5 CA 43 01 21 01 00 F1
 c_c 0x1234                     ; DC 34 12
 c_eq 0x1234                    ; CC 34 12
 c_geu 0x1234                   ; D4 34 12
 c_gtu 0x1234                   ; CA 53 01 D4 34 12
 c_leu 0x1234                   ; CA 59 01 D2 5C 01 CD 34 12
 c_ltu 0x1234                   ; DC 34 12
 c_m 0x1234                     ; FC 34 12
 c_nc 0x1234                    ; D4 34 12
 c_ne 0x1234                    ; C4 34 12
 c_nv 0x1234                    ; E4 34 12
 c_nz 0x1234                    ; C4 34 12
 c_p 0x1234                     ; F4 34 12
 c_pe 0x1234                    ; EC 34 12
 c_po 0x1234                    ; E4 34 12
 c_v 0x1234                     ; EC 34 12
 c_z 0x1234                     ; CC 34 12
 call (hl)                      ; CD @__z80asm__call_hl x
 call 0x1234                    ; CD 34 12
 call c, 0x1234                 ; DC 34 12
 call eq, 0x1234                ; CC 34 12
 call geu, 0x1234               ; D4 34 12
 call gtu, 0x1234               ; CA 92 01 D4 34 12
 call leu, 0x1234               ; CA 98 01 D2 9B 01 CD 34 12
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
 cgtu 0x1234                    ; CA CC 01 D4 34 12
 cleu 0x1234                    ; CA D2 01 D2 D5 01 CD 34 12
 clr (hl)                       ; 36 00
 clr a                          ; 3E 00
 clr b                          ; 06 00
 clr bc                         ; 01 00 00
 clr c                          ; 0E 00
 clr d                          ; 16 00
 clr de                         ; 11 00 00
 clr e                          ; 1E 00
 clr h                          ; 26 00
 clr h'                         ; 38 26 00
 clr hl                         ; 21 00 00
 clr hl'                        ; 38 21 00 00
 clr l                          ; 2E 00
 clr l'                         ; 38 2E 00
 cltu 0x1234                    ; DC 34 12
 cm 0x1234                      ; FC 34 12
 cma                            ; 2F
 cmc                            ; 3F
 cmp (hl')                      ; 38 BE
 cmp (hl)                       ; BE
 cmp (hl+)                      ; BE 23
 cmp (hl-)                      ; BE 2B
 cmp 0                          ; FE 00
 cmp 127                        ; FE 7F
 cmp 255                        ; FE FF
 cmp a                          ; BF
 cmp a, (hl')                   ; 38 BE
 cmp a, (hl)                    ; BE
 cmp a, (hl+)                   ; BE 23
 cmp a, (hl-)                   ; BE 2B
 cmp a, 0                       ; FE 00
 cmp a, 127                     ; FE 7F
 cmp a, 255                     ; FE FF
 cmp a, a                       ; BF
 cmp a, b                       ; B8
 cmp a, c                       ; B9
 cmp a, d                       ; BA
 cmp a, e                       ; BB
 cmp a, h                       ; BC
 cmp a, h'                      ; 38 BC
 cmp a, l                       ; BD
 cmp a, l'                      ; 38 BD
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
 cne 0x1234                     ; C4 34 12
 cnv 0x1234                     ; E4 34 12
 cnz 0x1234                     ; C4 34 12
 cp (hl')                       ; 38 BE
 cp (hl)                        ; BE
 cp (hl+)                       ; BE 23
 cp (hl-)                       ; BE 2B
 cp 0                           ; FE 00
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; BF
 cp a, (hl')                    ; 38 BE
 cp a, (hl)                     ; BE
 cp a, (hl+)                    ; BE 23
 cp a, (hl-)                    ; BE 2B
 cp a, 0                        ; FE 00
 cp a, 127                      ; FE 7F
 cp a, 255                      ; FE FF
 cp a, a                        ; BF
 cp a, b                        ; B8
 cp a, c                        ; B9
 cp a, d                        ; BA
 cp a, e                        ; BB
 cp a, h                        ; BC
 cp a, h'                       ; 38 BC
 cp a, l                        ; BD
 cp a, l'                       ; 38 BD
 cp b                           ; B8
 cp c                           ; B9
 cp d                           ; BA
 cp e                           ; BB
 cp h                           ; BC
 cp h'                          ; 38 BC
 cp hl', bc                     ; 38 CB
 cp hl', de                     ; 38 DD
 cp hl, bc                      ; CB
 cp hl, de                      ; DD
 cp l                           ; BD
 cp l'                          ; 38 BD
 cpc hl', bc                    ; 38 28 CB
 cpc hl', de                    ; 38 28 DD
 cpc hl, bc                     ; 28 CB
 cpc hl, de                     ; 28 DD
 cpd                            ; CD @__z80asm__cpd x
 cpdr                           ; CD @__z80asm__cpdr x
 cpe 0x1234                     ; EC 34 12
 cpi                            ; CD @__z80asm__cpi x
 cpi 0                          ; FE 00
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpir                           ; CD @__z80asm__cpir x
 cpl                            ; 2F
 cpl a                          ; 2F
 cpo 0x1234                     ; E4 34 12
 cv 0x1234                      ; EC 34 12
 cz 0x1234                      ; CC 34 12
 daa                            ; 27
 dad b                          ; 09
 dad bc                         ; 09
 dad d                          ; 19
 dad de                         ; 19
 dad h                          ; 29
 dad h'                         ; 38 29
 dad hl                         ; 29
 dad hl'                        ; 38 29
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
 dcx bc                         ; 0B
 dcx d                          ; 1B
 dcx de                         ; 1B
 dcx h                          ; 2B
 dcx h'                         ; 38 2B
 dcx hl                         ; 2B
 dcx hl'                        ; 38 2B
 dcx sp                         ; 3B
 dec (hl')                      ; 38 35
 dec (hl)                       ; 35
 dec (hl+)                      ; 35 23
 dec (hl-)                      ; 35 2B
 dec a                          ; 3D
 dec b                          ; 05
 dec bc                         ; 0B
 dec c                          ; 0D
 dec d                          ; 15
 dec de                         ; 1B
 dec e                          ; 1D
 dec h                          ; 25
 dec h'                         ; 38 25
 dec hl                         ; 2B
 dec hl'                        ; 38 2B
 dec l                          ; 2D
 dec l'                         ; 38 2D
 dec sp                         ; 3B
 di                             ; F3
 djnz 0x1234                    ; 05 C2 34 12
 djnz b, 0x1234                 ; 05 C2 34 12
 dsub                           ; CD @__z80asm__sub_hl_bc x
 dsub b                         ; 08
 dsub bc                        ; 08
 dsub d                         ; 18
 dsub de                        ; 18
 ei                             ; FB
 ex (sp), hl                    ; E3
 ex (sp), hl'                   ; 38 E3
 ex bc, hl                      ; E5 C5 E1 C1
 ex de, hl                      ; EB
 ex hl, bc                      ; E5 C5 E1 C1
 ex hl, de                      ; EB
 halt                           ; 76
 hlt                            ; 76
 in 0                           ; DB 00
 in 127                         ; DB 7F
 in 255                         ; DB FF
 in a, (0)                      ; DB 00
 in a, (127)                    ; DB 7F
 in a, (255)                    ; DB FF
 inc (hl')                      ; 38 34
 inc (hl)                       ; 34
 inc (hl+)                      ; 34 23
 inc (hl-)                      ; 34 2B
 inc a                          ; 3C
 inc b                          ; 04
 inc bc                         ; 03
 inc c                          ; 0C
 inc d                          ; 14
 inc de                         ; 13
 inc e                          ; 1C
 inc h                          ; 24
 inc h'                         ; 38 24
 inc hl                         ; 23
 inc hl'                        ; 38 23
 inc l                          ; 2C
 inc l'                         ; 38 2C
 inc sp                         ; 33
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
 inx bc                         ; 03
 inx d                          ; 13
 inx de                         ; 13
 inx h                          ; 23
 inx h'                         ; 38 23
 inx hl                         ; 23
 inx hl'                        ; 38 23
 inx sp                         ; 33
 j_c 0x1234                     ; DA 34 12
 j_eq 0x1234                    ; CA 34 12
 j_geu 0x1234                   ; D2 34 12
 j_gtu 0x1234                   ; CA 46 03 D2 34 12
 j_leu 0x1234                   ; CA 34 12 DA 34 12
 j_ltu 0x1234                   ; DA 34 12
 j_m 0x1234                     ; FA 34 12
 j_nc 0x1234                    ; D2 34 12
 j_ne 0x1234                    ; C2 34 12
 j_nv 0x1234                    ; E2 34 12
 j_nz 0x1234                    ; C2 34 12
 j_of 0x1234                    ; FD 34 12
 j_p 0x1234                     ; F2 34 12
 j_pe 0x1234                    ; EA 34 12
 j_po 0x1234                    ; E2 34 12
 j_v 0x1234                     ; EA 34 12
 j_z 0x1234                     ; CA 34 12
 jc 0x1234                      ; DA 34 12
 jeq 0x1234                     ; CA 34 12
 jgeu 0x1234                    ; D2 34 12
 jgtu 0x1234                    ; CA 7F 03 D2 34 12
 jleu 0x1234                    ; CA 34 12 DA 34 12
 jltu 0x1234                    ; DA 34 12
 jm 0x1234                      ; FA 34 12
 jmp (bc)                       ; C5 C9
 jmp (de)                       ; D5 C9
 jmp (hl')                      ; 38 E9
 jmp (hl)                       ; E9
 jmp 0x1234                     ; C3 34 12
 jmp c, 0x1234                  ; DA 34 12
 jmp eq, 0x1234                 ; CA 34 12
 jmp geu, 0x1234                ; D2 34 12
 jmp gtu, 0x1234                ; CA A4 03 D2 34 12
 jmp leu, 0x1234                ; CA 34 12 DA 34 12
 jmp ltu, 0x1234                ; DA 34 12
 jmp m, 0x1234                  ; FA 34 12
 jmp nc, 0x1234                 ; D2 34 12
 jmp ne, 0x1234                 ; C2 34 12
 jmp nv, 0x1234                 ; E2 34 12
 jmp nz, 0x1234                 ; C2 34 12
 jmp of, 0x1234                 ; FD 34 12
 jmp p, 0x1234                  ; F2 34 12
 jmp pe, 0x1234                 ; EA 34 12
 jmp po, 0x1234                 ; E2 34 12
 jmp v, 0x1234                  ; EA 34 12
 jmp z, 0x1234                  ; CA 34 12
 jnc 0x1234                     ; D2 34 12
 jne 0x1234                     ; C2 34 12
 jnv 0x1234                     ; E2 34 12
 jnz 0x1234                     ; C2 34 12
 jof 0x1234                     ; FD 34 12
 jp (bc)                        ; C5 C9
 jp (de)                        ; D5 C9
 jp (hl')                       ; 38 E9
 jp (hl)                        ; E9
 jp 0x1234                      ; C3 34 12
 jp c, 0x1234                   ; DA 34 12
 jp eq, 0x1234                  ; CA 34 12
 jp geu, 0x1234                 ; D2 34 12
 jp gtu, 0x1234                 ; CA F6 03 D2 34 12
 jp leu, 0x1234                 ; CA 34 12 DA 34 12
 jp ltu, 0x1234                 ; DA 34 12
 jp m, 0x1234                   ; FA 34 12
 jp nc, 0x1234                  ; D2 34 12
 jp ne, 0x1234                  ; C2 34 12
 jp nv, 0x1234                  ; E2 34 12
 jp nz, 0x1234                  ; C2 34 12
 jp of, 0x1234                  ; FD 34 12
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
 jr gtu, 0x1234                 ; CA 38 04 D2 34 12
 jr leu, 0x1234                 ; CA 34 12 DA 34 12
 jr ltu, 0x1234                 ; DA 34 12
 jr nc, 0x1234                  ; D2 34 12
 jr ne, 0x1234                  ; C2 34 12
 jr nz, 0x1234                  ; C2 34 12
 jr z, 0x1234                   ; CA 34 12
 jv 0x1234                      ; EA 34 12
 jz 0x1234                      ; CA 34 12
 ld (0x1234), a                 ; 32 34 12
 ld (0x1234), bc                ; E5 60 69 22 34 12 E1
 ld (0x1234), de                ; EB 22 34 12 EB
 ld (0x1234), hl                ; 22 34 12
 ld (0x1234), hl'               ; 38 22 34 12
 ld (0x1234), sp                ; E5 21 02 00 39 22 34 12 E1
 ld (bc), a                     ; 02
 ld (bc+), a                    ; 02 03
 ld (bc-), a                    ; 02 0B
 ld (de), 0                     ; EB 36 00 EB
 ld (de), 127                   ; EB 36 7F EB
 ld (de), 255                   ; EB 36 FF EB
 ld (de), a                     ; 12
 ld (de), b                     ; EB 70 EB
 ld (de), c                     ; EB 71 EB
 ld (de), d                     ; EB 74 EB
 ld (de), e                     ; EB 75 EB
 ld (de), h                     ; EB 72 EB
 ld (de), hl                    ; D9
 ld (de), hl'                   ; 38 D9
 ld (de), l                     ; EB 73 EB
 ld (de+), 0                    ; EB 36 00 EB 13
 ld (de+), 127                  ; EB 36 7F EB 13
 ld (de+), 255                  ; EB 36 FF EB 13
 ld (de+), a                    ; 12 13
 ld (de+), b                    ; EB 70 EB 13
 ld (de+), c                    ; EB 71 EB 13
 ld (de+), d                    ; EB 74 EB 13
 ld (de+), e                    ; EB 75 EB 13
 ld (de+), h                    ; EB 72 EB 13
 ld (de+), l                    ; EB 73 EB 13
 ld (de-), 0                    ; EB 36 00 EB 1B
 ld (de-), 127                  ; EB 36 7F EB 1B
 ld (de-), 255                  ; EB 36 FF EB 1B
 ld (de-), a                    ; 12 1B
 ld (de-), b                    ; EB 70 EB 1B
 ld (de-), c                    ; EB 71 EB 1B
 ld (de-), d                    ; EB 74 EB 1B
 ld (de-), e                    ; EB 75 EB 1B
 ld (de-), h                    ; EB 72 EB 1B
 ld (de-), l                    ; EB 73 EB 1B
 ld (hl'), 0                    ; 38 36 00
 ld (hl'), 127                  ; 38 36 7F
 ld (hl'), 255                  ; 38 36 FF
 ld (hl'), a                    ; 38 77
 ld (hl'), and (hl')            ; 38 10
 ld (hl'), b                    ; 38 70
 ld (hl'), c                    ; 38 71
 ld (hl'), d                    ; 38 72
 ld (hl'), e                    ; 38 73
 ld (hl'), h'                   ; 38 74
 ld (hl'), l'                   ; 38 75
 ld (hl'), or (hl')             ; 38 20
 ld (hl'), xor (hl')            ; 38 30
 ld (hl), 0                     ; 36 00
 ld (hl), 127                   ; 36 7F
 ld (hl), 255                   ; 36 FF
 ld (hl), a                     ; 77
 ld (hl), and (hl)              ; 10
 ld (hl), b                     ; 70
 ld (hl), bc                    ; 71 23 70 2B
 ld (hl), c                     ; 71
 ld (hl), d                     ; 72
 ld (hl), de                    ; 73 23 72 2B
 ld (hl), e                     ; 73
 ld (hl), h                     ; 74
 ld (hl), hl                    ; F5 7C 75 23 77 F1 2B
 ld (hl), l                     ; 75
 ld (hl), or (hl)               ; 20
 ld (hl), xor (hl)              ; 30
 ld (hl+), 0                    ; 36 00 23
 ld (hl+), 127                  ; 36 7F 23
 ld (hl+), 255                  ; 36 FF 23
 ld (hl+), a                    ; 77 23
 ld (hl+), b                    ; 70 23
 ld (hl+), bc                   ; 71 23 70 23
 ld (hl+), c                    ; 71 23
 ld (hl+), d                    ; 72 23
 ld (hl+), de                   ; 73 23 72 23
 ld (hl+), e                    ; 73 23
 ld (hl+), h                    ; 74 23
 ld (hl+), hl                   ; F5 7C 75 23 77 F1 23
 ld (hl+), l                    ; 75 23
 ld (hl-), 0                    ; 36 00 2B
 ld (hl-), 127                  ; 36 7F 2B
 ld (hl-), 255                  ; 36 FF 2B
 ld (hl-), a                    ; 77 2B
 ld (hl-), b                    ; 70 2B
 ld (hl-), c                    ; 71 2B
 ld (hl-), d                    ; 72 2B
 ld (hl-), e                    ; 73 2B
 ld (hl-), h                    ; 74 2B
 ld (hl-), l                    ; 75 2B
 ld (hld), a                    ; 77 2B
 ld (hld), b                    ; 70 2B
 ld (hld), c                    ; 71 2B
 ld (hld), d                    ; 72 2B
 ld (hld), e                    ; 73 2B
 ld (hld), h                    ; 74 2B
 ld (hld), l                    ; 75 2B
 ld (hli), a                    ; 77 23
 ld (hli), b                    ; 70 23
 ld (hli), c                    ; 71 23
 ld (hli), d                    ; 72 23
 ld (hli), e                    ; 73 23
 ld (hli), h                    ; 74 23
 ld (hli), l                    ; 75 23
 ld a, (0x1234)                 ; 3A 34 12
 ld a, (bc)                     ; 0A
 ld a, (bc+)                    ; 0A 03
 ld a, (bc-)                    ; 0A 0B
 ld a, (de)                     ; 1A
 ld a, (de+)                    ; 1A 13
 ld a, (de-)                    ; 1A 1B
 ld a, (hl')                    ; 38 7E
 ld a, (hl)                     ; 7E
 ld a, (hl+)                    ; 7E 23
 ld a, (hl-)                    ; 7E 2B
 ld a, (hld)                    ; 7E 2B
 ld a, (hli)                    ; 7E 23
 ld a, 0                        ; 3E 00
 ld a, 127                      ; 3E 7F
 ld a, 255                      ; 3E FF
 ld a, a                        ; 7F
 ld a, b                        ; 78
 ld a, c                        ; 79
 ld a, d                        ; 7A
 ld a, e                        ; 7B
 ld a, h                        ; 7C
 ld a, h'                       ; 38 7C
 ld a, l                        ; 7D
 ld a, l'                       ; 38 7D
 ld b, (de)                     ; EB 46 EB
 ld b, (de+)                    ; EB 46 EB 13
 ld b, (de-)                    ; EB 46 EB 1B
 ld b, (hl')                    ; 38 46
 ld b, (hl)                     ; 46
 ld b, (hl+)                    ; 46 23
 ld b, (hl-)                    ; 46 2B
 ld b, (hld)                    ; 46 2B
 ld b, (hli)                    ; 46 23
 ld b, 0                        ; 06 00
 ld b, 127                      ; 06 7F
 ld b, 255                      ; 06 FF
 ld b, a                        ; 47
 ld b, b                        ; 40
 ld b, c                        ; 41
 ld b, d                        ; 42
 ld b, e                        ; 43
 ld b, h                        ; 44
 ld b, h'                       ; 38 44
 ld b, l                        ; 45
 ld b, l'                       ; 38 45
 ld bc, (0x1234)                ; E5 2A 34 12 44 4D E1
 ld bc, (hl)                    ; 4E 23 46 2B
 ld bc, (hl+)                   ; 4E 23 46 23
 ld bc, 0x1234                  ; 01 34 12
 ld bc, de                      ; 42 4B
 ld bc, hl                      ; 44 4D
 ld bc, hl'                     ; 38 44 38 4D
 ld c, (de)                     ; EB 4E EB
 ld c, (de+)                    ; EB 4E EB 13
 ld c, (de-)                    ; EB 4E EB 1B
 ld c, (hl')                    ; 38 4E
 ld c, (hl)                     ; 4E
 ld c, (hl+)                    ; 4E 23
 ld c, (hl-)                    ; 4E 2B
 ld c, (hld)                    ; 4E 2B
 ld c, (hli)                    ; 4E 23
 ld c, 0                        ; 0E 00
 ld c, 127                      ; 0E 7F
 ld c, 255                      ; 0E FF
 ld c, a                        ; 4F
 ld c, b                        ; 48
 ld c, c                        ; 49
 ld c, d                        ; 4A
 ld c, e                        ; 4B
 ld c, h                        ; 4C
 ld c, h'                       ; 38 4C
 ld c, l                        ; 4D
 ld c, l'                       ; 38 4D
 ld d, (de)                     ; EB 66 EB
 ld d, (de+)                    ; EB 66 EB 13
 ld d, (de-)                    ; EB 66 EB 1B
 ld d, (hl')                    ; 38 56
 ld d, (hl)                     ; 56
 ld d, (hl+)                    ; 56 23
 ld d, (hl-)                    ; 56 2B
 ld d, (hld)                    ; 56 2B
 ld d, (hli)                    ; 56 23
 ld d, 0                        ; 16 00
 ld d, 127                      ; 16 7F
 ld d, 255                      ; 16 FF
 ld d, a                        ; 57
 ld d, b                        ; 50
 ld d, c                        ; 51
 ld d, d                        ; 52
 ld d, e                        ; 53
 ld d, h                        ; 54
 ld d, h'                       ; 38 54
 ld d, l                        ; 55
 ld d, l'                       ; 38 55
 ld de, (0x1234)                ; EB 2A 34 12 EB
 ld de, (hl)                    ; 5E 23 56 2B
 ld de, (hl+)                   ; 5E 23 56 23
 ld de, 0x1234                  ; 11 34 12
 ld de, bc                      ; 50 59
 ld de, hl                      ; 54 5D
 ld de, hl'                     ; 38 54 38 5D
 ld de, hl+0                    ; E5 11 00 00 19 EB E1
 ld de, hl+127                  ; E5 11 7F 00 19 EB E1
 ld de, hl+255                  ; E5 11 FF 00 19 EB E1
 ld de, sp                      ; EB 21 00 00 39 EB
 ld de, sp+0                    ; EB 21 00 00 39 EB
 ld de, sp+127                  ; EB 21 7F 00 39 EB
 ld de, sp+255                  ; EB 21 FF 00 39 EB
 ld e, (de)                     ; EB 6E EB
 ld e, (de+)                    ; EB 6E EB 13
 ld e, (de-)                    ; EB 6E EB 1B
 ld e, (hl')                    ; 38 5E
 ld e, (hl)                     ; 5E
 ld e, (hl+)                    ; 5E 23
 ld e, (hl-)                    ; 5E 2B
 ld e, (hld)                    ; 5E 2B
 ld e, (hli)                    ; 5E 23
 ld e, 0                        ; 1E 00
 ld e, 127                      ; 1E 7F
 ld e, 255                      ; 1E FF
 ld e, a                        ; 5F
 ld e, b                        ; 58
 ld e, c                        ; 59
 ld e, d                        ; 5A
 ld e, e                        ; 5B
 ld e, h                        ; 5C
 ld e, h'                       ; 38 5C
 ld e, l                        ; 5D
 ld e, l'                       ; 38 5D
 ld h', (hl')                   ; 38 66
 ld h', 0                       ; 38 26 00
 ld h', 127                     ; 38 26 7F
 ld h', 255                     ; 38 26 FF
 ld h', a                       ; 38 67
 ld h', b                       ; 38 60
 ld h', c                       ; 38 61
 ld h', d                       ; 38 62
 ld h', e                       ; 38 63
 ld h', h'                      ; 38 64
 ld h', l'                      ; 38 65
 ld h, (de)                     ; EB 56 EB
 ld h, (de+)                    ; EB 56 EB 13
 ld h, (de-)                    ; EB 56 EB 1B
 ld h, (hl)                     ; 66
 ld h, (hl+)                    ; 66 23
 ld h, (hl-)                    ; 66 2B
 ld h, (hld)                    ; 66 2B
 ld h, (hli)                    ; 66 23
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
 ld hl', (0x1234)               ; 38 2A 34 12
 ld hl', (de)                   ; 38 ED
 ld hl', 0x1234                 ; 38 21 34 12
 ld hl', bc                     ; 38 60 38 69
 ld hl', de                     ; 38 62 38 6B
 ld hl', hl                     ; E5 38 E1
 ld hl, (0x1234)                ; 2A 34 12
 ld hl, (de)                    ; ED
 ld hl, (hl)                    ; F5 7E 23 66 6F F1
 ld hl, 0x1234                  ; 21 34 12
 ld hl, bc                      ; 60 69
 ld hl, de                      ; 62 6B
 ld hl, hl'                     ; 38 E5 E1
 ld hl, sp                      ; 21 00 00 39
 ld hl, sp+0                    ; 21 00 00 39
 ld hl, sp+126                  ; 21 7E 00 39
 ld hl, sp-128                  ; 21 80 FF 39
 ld l', (hl')                   ; 38 6E
 ld l', 0                       ; 38 2E 00
 ld l', 127                     ; 38 2E 7F
 ld l', 255                     ; 38 2E FF
 ld l', a                       ; 38 6F
 ld l', b                       ; 38 68
 ld l', c                       ; 38 69
 ld l', d                       ; 38 6A
 ld l', e                       ; 38 6B
 ld l', h'                      ; 38 6C
 ld l', l'                      ; 38 6D
 ld l, (de)                     ; EB 5E EB
 ld l, (de+)                    ; EB 5E EB 13
 ld l, (de-)                    ; EB 5E EB 1B
 ld l, (hl)                     ; 6E
 ld l, (hl+)                    ; 6E 23
 ld l, (hl-)                    ; 6E 2B
 ld l, (hld)                    ; 6E 2B
 ld l, (hli)                    ; 6E 23
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
 ld sp, hl'                     ; 38 F9
 lda 0x1234                     ; 3A 34 12
 ldax b                         ; 0A
 ldax bc                        ; 0A
 ldax d                         ; 1A
 ldax de                        ; 1A
 ldd                            ; CD @__z80asm__ldd x
 ldd (bc), a                    ; 02 0B
 ldd (de), 0                    ; EB 36 00 EB 1B
 ldd (de), 127                  ; EB 36 7F EB 1B
 ldd (de), 255                  ; EB 36 FF EB 1B
 ldd (de), a                    ; 12 1B
 ldd (de), b                    ; EB 70 EB 1B
 ldd (de), c                    ; EB 71 EB 1B
 ldd (de), d                    ; EB 74 EB 1B
 ldd (de), e                    ; EB 75 EB 1B
 ldd (de), h                    ; EB 72 EB 1B
 ldd (de), l                    ; EB 73 EB 1B
 ldd (hl), 0                    ; 36 00 2B
 ldd (hl), 127                  ; 36 7F 2B
 ldd (hl), 255                  ; 36 FF 2B
 ldd (hl), a                    ; 77 2B
 ldd (hl), b                    ; 70 2B
 ldd (hl), c                    ; 71 2B
 ldd (hl), d                    ; 72 2B
 ldd (hl), e                    ; 73 2B
 ldd (hl), h                    ; 74 2B
 ldd (hl), l                    ; 75 2B
 ldd a, (bc)                    ; 0A 0B
 ldd a, (de)                    ; 1A 1B
 ldd a, (hl)                    ; 7E 2B
 ldd b, (de)                    ; EB 46 EB 1B
 ldd b, (hl)                    ; 46 2B
 ldd c, (de)                    ; EB 4E EB 1B
 ldd c, (hl)                    ; 4E 2B
 ldd d, (de)                    ; EB 66 EB 1B
 ldd d, (hl)                    ; 56 2B
 ldd e, (de)                    ; EB 6E EB 1B
 ldd e, (hl)                    ; 5E 2B
 ldd h, (de)                    ; EB 56 EB 1B
 ldd h, (hl)                    ; 66 2B
 ldd l, (de)                    ; EB 5E EB 1B
 ldd l, (hl)                    ; 6E 2B
 lddr                           ; CD @__z80asm__lddr x
 ldhi 0                         ; E5 11 00 00 19 EB E1
 ldhi 127                       ; E5 11 7F 00 19 EB E1
 ldhi 255                       ; E5 11 FF 00 19 EB E1
 ldi                            ; CD @__z80asm__ldi x
 ldi (bc), a                    ; 02 03
 ldi (de), 0                    ; EB 36 00 EB 13
 ldi (de), 127                  ; EB 36 7F EB 13
 ldi (de), 255                  ; EB 36 FF EB 13
 ldi (de), a                    ; 12 13
 ldi (de), b                    ; EB 70 EB 13
 ldi (de), c                    ; EB 71 EB 13
 ldi (de), d                    ; EB 74 EB 13
 ldi (de), e                    ; EB 75 EB 13
 ldi (de), h                    ; EB 72 EB 13
 ldi (de), l                    ; EB 73 EB 13
 ldi (hl), 0                    ; 36 00 23
 ldi (hl), 127                  ; 36 7F 23
 ldi (hl), 255                  ; 36 FF 23
 ldi (hl), a                    ; 77 23
 ldi (hl), b                    ; 70 23
 ldi (hl), bc                   ; 71 23 70 23
 ldi (hl), c                    ; 71 23
 ldi (hl), d                    ; 72 23
 ldi (hl), de                   ; 73 23 72 23
 ldi (hl), e                    ; 73 23
 ldi (hl), h                    ; 74 23
 ldi (hl), hl                   ; F5 7C 75 23 77 F1 23
 ldi (hl), l                    ; 75 23
 ldi a, (bc)                    ; 0A 03
 ldi a, (de)                    ; 1A 13
 ldi a, (hl)                    ; 7E 23
 ldi b, (de)                    ; EB 46 EB 13
 ldi b, (hl)                    ; 46 23
 ldi bc, (hl)                   ; 4E 23 46 23
 ldi c, (de)                    ; EB 4E EB 13
 ldi c, (hl)                    ; 4E 23
 ldi d, (de)                    ; EB 66 EB 13
 ldi d, (hl)                    ; 56 23
 ldi de, (hl)                   ; 5E 23 56 23
 ldi e, (de)                    ; EB 6E EB 13
 ldi e, (hl)                    ; 5E 23
 ldi h, (de)                    ; EB 56 EB 13
 ldi h, (hl)                    ; 66 23
 ldi l, (de)                    ; EB 5E EB 13
 ldi l, (hl)                    ; 6E 23
 ldir                           ; CD @__z80asm__ldir x
 ldsi 0                         ; EB 21 00 00 39 EB
 ldsi 127                       ; EB 21 7F 00 39 EB
 ldsi 255                       ; EB 21 FF 00 39 EB
 lhld 0x1234                    ; 2A 34 12
 lhlde                          ; ED
 lhlx                           ; ED
 lxi b, 0x1234                  ; 01 34 12
 lxi bc, 0x1234                 ; 01 34 12
 lxi d, 0x1234                  ; 11 34 12
 lxi de, 0x1234                 ; 11 34 12
 lxi h', 0x1234                 ; 38 21 34 12
 lxi h, 0x1234                  ; 21 34 12
 lxi hl', 0x1234                ; 38 21 34 12
 lxi hl, 0x1234                 ; 21 34 12
 lxi sp, 0x1234                 ; 31 34 12
 mb adc (hl')                   ; 28 38 8E
 mb adc (hl)                    ; 28 8E
 mb adc a, (hl')                ; 28 38 8E
 mb adc a, (hl)                 ; 28 8E
 mb adc m                       ; 28 8E
 mb add (hl')                   ; 28 38 86
 mb add (hl)                    ; 28 86
 mb add a, (hl')                ; 28 38 86
 mb add a, (hl)                 ; 28 86
 mb add m                       ; 28 86
 mb ana m                       ; 28 A6
 mb and (hl')                   ; 28 38 A6
 mb and (hl)                    ; 28 A6
 mb and a, (hl')                ; 28 38 A6
 mb and a, (hl)                 ; 28 A6
 mb andl (hl')                  ; 28 38 10
 mb andl (hl)                   ; 28 10
 mb c_c 0x1234                  ; 28 DC 34 12
 mb c_m 0x1234                  ; 28 FC 34 12
 mb c_nc 0x1234                 ; 28 D4 34 12
 mb c_nz 0x1234                 ; 28 C4 34 12
 mb c_p 0x1234                  ; 28 F4 34 12
 mb c_pe 0x1234                 ; 28 EC 34 12
 mb c_po 0x1234                 ; 28 E4 34 12
 mb c_z 0x1234                  ; 28 CC 34 12
 mb call 0x1234                 ; 28 CD 34 12
 mb call c, 0x1234              ; 28 DC 34 12
 mb call m, 0x1234              ; 28 FC 34 12
 mb call nc, 0x1234             ; 28 D4 34 12
 mb call nz, 0x1234             ; 28 C4 34 12
 mb call p, 0x1234              ; 28 F4 34 12
 mb call pe, 0x1234             ; 28 EC 34 12
 mb call po, 0x1234             ; 28 E4 34 12
 mb call z, 0x1234              ; 28 CC 34 12
 mb cc 0x1234                   ; 28 DC 34 12
 mb cm 0x1234                   ; 28 FC 34 12
 mb cmp (hl')                   ; 28 38 BE
 mb cmp (hl)                    ; 28 BE
 mb cmp a, (hl')                ; 28 38 BE
 mb cmp a, (hl)                 ; 28 BE
 mb cmp m                       ; 28 BE
 mb cnc 0x1234                  ; 28 D4 34 12
 mb cnz 0x1234                  ; 28 C4 34 12
 mb cp (hl')                    ; 28 38 BE
 mb cp (hl)                     ; 28 BE
 mb cp a, (hl')                 ; 28 38 BE
 mb cp a, (hl)                  ; 28 BE
 mb cpe 0x1234                  ; 28 EC 34 12
 mb cpo 0x1234                  ; 28 E4 34 12
 mb cz 0x1234                   ; 28 CC 34 12
 mb dcr m                       ; 28 35
 mb dec (hl')                   ; 28 38 35
 mb dec (hl)                    ; 28 35
 mb ex (sp), hl                 ; 28 E3
 mb ex (sp), hl'                ; 28 38 E3
 mb inc (hl')                   ; 28 38 34
 mb inc (hl)                    ; 28 34
 mb inr m                       ; 28 34
 mb ld (0x1234), a              ; 28 32 34 12
 mb ld (0x1234), hl             ; 28 22 34 12
 mb ld (0x1234), hl'            ; 28 38 22 34 12
 mb ld (bc), a                  ; 28 02
 mb ld (de), a                  ; 28 12
 mb ld (de), hl                 ; 28 D9
 mb ld (de), hl'                ; 28 38 D9
 mb ld (hl'), 0                 ; 28 38 36 00
 mb ld (hl'), 127               ; 28 38 36 7F
 mb ld (hl'), 255               ; 28 38 36 FF
 mb ld (hl'), a                 ; 28 38 77
 mb ld (hl'), and (hl')         ; 28 38 10
 mb ld (hl'), b                 ; 28 38 70
 mb ld (hl'), c                 ; 28 38 71
 mb ld (hl'), d                 ; 28 38 72
 mb ld (hl'), e                 ; 28 38 73
 mb ld (hl'), h'                ; 28 38 74
 mb ld (hl'), l'                ; 28 38 75
 mb ld (hl'), or (hl')          ; 28 38 20
 mb ld (hl'), xor (hl')         ; 28 38 30
 mb ld (hl), 0                  ; 28 36 00
 mb ld (hl), 127                ; 28 36 7F
 mb ld (hl), 255                ; 28 36 FF
 mb ld (hl), a                  ; 28 77
 mb ld (hl), and (hl)           ; 28 10
 mb ld (hl), b                  ; 28 70
 mb ld (hl), c                  ; 28 71
 mb ld (hl), d                  ; 28 72
 mb ld (hl), e                  ; 28 73
 mb ld (hl), h                  ; 28 74
 mb ld (hl), l                  ; 28 75
 mb ld (hl), or (hl)            ; 28 20
 mb ld (hl), xor (hl)           ; 28 30
 mb ld a, (0x1234)              ; 28 3A 34 12
 mb ld a, (bc)                  ; 28 0A
 mb ld a, (de)                  ; 28 1A
 mb ld a, (hl')                 ; 28 38 7E
 mb ld a, (hl)                  ; 28 7E
 mb ld b, (hl')                 ; 28 38 46
 mb ld b, (hl)                  ; 28 46
 mb ld c, (hl')                 ; 28 38 4E
 mb ld c, (hl)                  ; 28 4E
 mb ld d, (hl')                 ; 28 38 56
 mb ld d, (hl)                  ; 28 56
 mb ld e, (hl')                 ; 28 38 5E
 mb ld e, (hl)                  ; 28 5E
 mb ld h', (hl')                ; 28 38 66
 mb ld h, (hl)                  ; 28 66
 mb ld hl', (0x1234)            ; 28 38 2A 34 12
 mb ld hl', (de)                ; 28 38 ED
 mb ld hl, (0x1234)             ; 28 2A 34 12
 mb ld hl, (de)                 ; 28 ED
 mb ld l', (hl')                ; 28 38 6E
 mb ld l, (hl)                  ; 28 6E
 mb lda 0x1234                  ; 28 3A 34 12
 mb ldax b                      ; 28 0A
 mb ldax bc                     ; 28 0A
 mb ldax d                      ; 28 1A
 mb ldax de                     ; 28 1A
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
 mb or (hl')                    ; 28 38 B6
 mb or (hl)                     ; 28 B6
 mb or a, (hl')                 ; 28 38 B6
 mb or a, (hl)                  ; 28 B6
 mb ora m                       ; 28 B6
 mb orl (hl')                   ; 28 38 20
 mb orl (hl)                    ; 28 20
 mb pop af                      ; 28 F1
 mb pop b                       ; 28 C1
 mb pop bc                      ; 28 C1
 mb pop d                       ; 28 D1
 mb pop de                      ; 28 D1
 mb pop h                       ; 28 E1
 mb pop h'                      ; 28 38 E1
 mb pop hl                      ; 28 E1
 mb pop hl'                     ; 28 38 E1
 mb pop psw                     ; 28 F1
 mb push af                     ; 28 F5
 mb push b                      ; 28 C5
 mb push bc                     ; 28 C5
 mb push d                      ; 28 D5
 mb push de                     ; 28 D5
 mb push h                      ; 28 E5
 mb push h'                     ; 28 38 E5
 mb push hl                     ; 28 E5
 mb push hl'                    ; 28 38 E5
 mb push psw                    ; 28 F5
 mb r_c                         ; 28 D8
 mb r_m                         ; 28 F8
 mb r_nc                        ; 28 D0
 mb r_nz                        ; 28 C0
 mb r_p                         ; 28 F0
 mb r_pe                        ; 28 E8
 mb r_po                        ; 28 E0
 mb r_z                         ; 28 C8
 mb rc                          ; 28 D8
 mb ret                         ; 28 C9
 mb ret c                       ; 28 D8
 mb ret m                       ; 28 F8
 mb ret nc                      ; 28 D0
 mb ret nz                      ; 28 C0
 mb ret p                       ; 28 F0
 mb ret pe                      ; 28 E8
 mb ret po                      ; 28 E0
 mb ret z                       ; 28 C8
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
 mb sbc (hl')                   ; 28 38 9E
 mb sbc (hl)                    ; 28 9E
 mb sbc a, (hl')                ; 28 38 9E
 mb sbc a, (hl)                 ; 28 9E
 mb shld 0x1234                 ; 28 22 34 12
 mb shlde                       ; 28 D9
 mb shlx                        ; 28 D9
 mb sta 0x1234                  ; 28 32 34 12
 mb stax b                      ; 28 02
 mb stax bc                     ; 28 02
 mb stax d                      ; 28 12
 mb stax de                     ; 28 12
 mb sub (hl')                   ; 28 38 96
 mb sub (hl)                    ; 28 96
 mb sub a, (hl')                ; 28 38 96
 mb sub a, (hl)                 ; 28 96
 mb sub m                       ; 28 96
 mb xor (hl')                   ; 28 38 AE
 mb xor (hl)                    ; 28 AE
 mb xor a, (hl')                ; 28 38 AE
 mb xor a, (hl)                 ; 28 AE
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
 neg                            ; 2F 3C
 neg a                          ; 2F 3C
 neg b                          ; F5 78 2F 47 04 F1
 neg bc                         ; F5 78 2F 47 79 2F 4F 03 F1
 neg c                          ; F5 79 2F 4F 0C F1
 neg d                          ; F5 7A 2F 57 14 F1
 neg de                         ; F5 7A 2F 57 7B 2F 5F 13 F1
 neg e                          ; F5 7B 2F 5F 1C F1
 neg h                          ; F5 7C 2F 67 24 F1
 neg h'                         ; F5 38 7C 2F 38 67 38 24 F1
 neg hl                         ; F5 7C 2F 67 7D 2F 6F 23 F1
 neg hl'                        ; F5 38 7C 2F 38 67 38 7D 2F 38 6F 38 23 F1
 neg l                          ; F5 7D 2F 6F 2C F1
 neg l'                         ; F5 38 7D 2F 38 6F 38 2C F1
 nop                            ; 00
 or (hl')                       ; 38 B6
 or (hl)                        ; B6
 or (hl+)                       ; B6 23
 or (hl-)                       ; B6 2B
 or 0                           ; F6 00
 or 127                         ; F6 7F
 or 255                         ; F6 FF
 or a                           ; B7
 or a, (hl')                    ; 38 B6
 or a, (hl)                     ; B6
 or a, (hl+)                    ; B6 23
 or a, (hl-)                    ; B6 2B
 or a, 0                        ; F6 00
 or a, 127                      ; F6 7F
 or a, 255                      ; F6 FF
 or a, a                        ; B7
 or a, b                        ; B0
 or a, c                        ; B1
 or a, d                        ; B2
 or a, e                        ; B3
 or a, h                        ; B4
 or a, h'                       ; 38 B4
 or a, l                        ; B5
 or a, l'                       ; 38 B5
 or b                           ; B0
 or c                           ; B1
 or d                           ; B2
 or e                           ; B3
 or h                           ; B4
 or h'                          ; 38 B4
 or hl, bc                      ; F5 7C B0 67 7D B1 6F F1
 or hl, de                      ; F5 7C B2 67 7D B3 6F F1
 or l                           ; B5
 or l'                          ; 38 B5
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
 out (0), a                     ; D3 00
 out (127), a                   ; D3 7F
 out (255), a                   ; D3 FF
 out 0                          ; D3 00
 out 127                        ; D3 7F
 out 255                        ; D3 FF
 pchl                           ; E9
 pchl'                          ; 38 E9
 pop af                         ; F1
 pop b                          ; C1
 pop bc                         ; C1
 pop d                          ; D1
 pop de                         ; D1
 pop h                          ; E1
 pop h'                         ; 38 E1
 pop hl                         ; E1
 pop hl'                        ; 38 E1
 pop psw                        ; F1
 push af                        ; F5
 push b                         ; C5
 push bc                        ; C5
 push d                         ; D5
 push de                        ; D5
 push h                         ; E5
 push h'                        ; 38 E5
 push hl                        ; E5
 push hl'                       ; 38 E5
 push psw                       ; F5
 r_c                            ; D8
 r_eq                           ; C8
 r_geu                          ; D0
 r_gtu                          ; CA 9B 0C D0
 r_leu                          ; C8 D8
 r_ltu                          ; D8
 r_m                            ; F8
 r_nc                           ; D0
 r_ne                           ; C0
 r_nv                           ; E0
 r_nz                           ; C0
 r_p                            ; F0
 r_pe                           ; E8
 r_po                           ; E0
 r_v                            ; E8
 r_z                            ; C8
 ral                            ; 17
 rar                            ; 1F
 rc                             ; D8
 rdel                           ; CD @__z80asm__rl_de x
 req                            ; C8
 ret                            ; C9
 ret c                          ; D8
 ret eq                         ; C8
 ret geu                        ; D0
 ret gtu                        ; CA B7 0C D0
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
 rgtu                           ; CA C9 0C D0
 rl bc                          ; CD @__z80asm__rl_bc x
 rl de                          ; CD @__z80asm__rl_de x
 rl hl                          ; CD @__z80asm__rl_hl x
 rla                            ; 17
 rlc                            ; 07
 rlca                           ; 07
 rld                            ; CD @__z80asm__rld x
 rlde                           ; CD @__z80asm__rl_de x
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
 rr bc                          ; CD @__z80asm__rr_bc x
 rr de                          ; CD @__z80asm__rr_de x
 rr hl                          ; CD @__z80asm__rr_hl x
 rra                            ; 1F
 rrc                            ; 0F
 rrca                           ; 0F
 rrd                            ; CD @__z80asm__rrd x
 rrhl                           ; CD @__z80asm__sra_hl x
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
 sbb h'                         ; 38 9C
 sbb l                          ; 9D
 sbb l'                         ; 38 9D
 sbb m                          ; 9E
 sbc (hl')                      ; 38 9E
 sbc (hl)                       ; 9E
 sbc (hl+)                      ; 9E 23
 sbc (hl-)                      ; 9E 2B
 sbc 0                          ; DE 00
 sbc 127                        ; DE 7F
 sbc 255                        ; DE FF
 sbc a                          ; 9F
 sbc a, (hl')                   ; 38 9E
 sbc a, (hl)                    ; 9E
 sbc a, (hl+)                   ; 9E 23
 sbc a, (hl-)                   ; 9E 2B
 sbc a, 0                       ; DE 00
 sbc a, 127                     ; DE 7F
 sbc a, 255                     ; DE FF
 sbc a, a                       ; 9F
 sbc a, b                       ; 98
 sbc a, c                       ; 99
 sbc a, d                       ; 9A
 sbc a, e                       ; 9B
 sbc a, h                       ; 9C
 sbc a, h'                      ; 38 9C
 sbc a, l                       ; 9D
 sbc a, l'                      ; 38 9D
 sbc b                          ; 98
 sbc c                          ; 99
 sbc d                          ; 9A
 sbc e                          ; 9B
 sbc h                          ; 9C
 sbc h'                         ; 38 9C
 sbc hl', bc                    ; 38 28 08
 sbc hl', de                    ; 38 28 18
 sbc hl, bc                     ; 28 08
 sbc hl, de                     ; 28 18
 sbc hl, hl                     ; CD @__z80asm__sbc_hl_hl x
 sbc hl, sp                     ; CD @__z80asm__sbc_hl_sp x
 sbc l                          ; 9D
 sbc l'                         ; 38 9D
 sbi 0                          ; DE 00
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 scf                            ; 37
 shld 0x1234                    ; 22 34 12
 shlde                          ; D9
 shlx                           ; D9
 smf0                           ; 28 00
 smf1                           ; 28 7F
 sphl                           ; F9
 sphl'                          ; 38 F9
 sra bc                         ; CD @__z80asm__sra_bc x
 sra de                         ; CD @__z80asm__sra_de x
 sra hl                         ; CD @__z80asm__sra_hl x
 sta 0x1234                     ; 32 34 12
 stax b                         ; 02
 stax bc                        ; 02
 stax d                         ; 12
 stax de                        ; 12
 stc                            ; 37
 sub (hl')                      ; 38 96
 sub (hl)                       ; 96
 sub (hl+)                      ; 96 23
 sub (hl-)                      ; 96 2B
 sub 0                          ; D6 00
 sub 127                        ; D6 7F
 sub 255                        ; D6 FF
 sub a                          ; 97
 sub a, (hl')                   ; 38 96
 sub a, (hl)                    ; 96
 sub a, (hl+)                   ; 96 23
 sub a, (hl-)                   ; 96 2B
 sub a, 0                       ; D6 00
 sub a, 127                     ; D6 7F
 sub a, 255                     ; D6 FF
 sub a, a                       ; 97
 sub a, b                       ; 90
 sub a, c                       ; 91
 sub a, d                       ; 92
 sub a, e                       ; 93
 sub a, h                       ; 94
 sub a, h'                      ; 38 94
 sub a, l                       ; 95
 sub a, l'                      ; 38 95
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
 sub hl, hl                     ; CD @__z80asm__sub_hl_hl x
 sub hl, sp                     ; CD @__z80asm__sub_hl_sp x
 sub l                          ; 95
 sub l'                         ; 38 95
 sub m                          ; 96
 sui 0                          ; D6 00
 sui 127                        ; D6 7F
 sui 255                        ; D6 FF
 xchg                           ; EB
 xor (hl')                      ; 38 AE
 xor (hl)                       ; AE
 xor (hl+)                      ; AE 23
 xor (hl-)                      ; AE 2B
 xor 0                          ; EE 00
 xor 127                        ; EE 7F
 xor 255                        ; EE FF
 xor a                          ; AF
 xor a, (hl')                   ; 38 AE
 xor a, (hl)                    ; AE
 xor a, (hl+)                   ; AE 23
 xor a, (hl-)                   ; AE 2B
 xor a, 0                       ; EE 00
 xor a, 127                     ; EE 7F
 xor a, 255                     ; EE FF
 xor a, a                       ; AF
 xor a, b                       ; A8
 xor a, c                       ; A9
 xor a, d                       ; AA
 xor a, e                       ; AB
 xor a, h                       ; AC
 xor a, h'                      ; 38 AC
 xor a, l                       ; AD
 xor a, l'                      ; 38 AD
 xor b                          ; A8
 xor c                          ; A9
 xor d                          ; AA
 xor e                          ; AB
 xor h                          ; AC
 xor h'                         ; 38 AC
 xor hl, bc                     ; F5 7C A8 67 7D A9 6F F1
 xor hl, de                     ; F5 7C AA 67 7D AB 6F F1
 xor l                          ; AD
 xor l'                         ; 38 AD
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
