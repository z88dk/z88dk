 adc (hl)                       ; 8E
 adc (ix)                       ; DD 8E 00
 adc (ix+127)                   ; DD 8E 7F
 adc (ix-128)                   ; DD 8E 80
 adc (iy)                       ; FD 8E 00
 adc (iy+127)                   ; FD 8E 7F
 adc (iy-128)                   ; FD 8E 80
 adc -128                       ; CE 80
 adc 127                        ; CE 7F
 adc 255                        ; CE FF
 adc a                          ; 8F
 adc a, (hl)                    ; 8E
 adc a, (ix)                    ; DD 8E 00
 adc a, (ix+127)                ; DD 8E 7F
 adc a, (ix-128)                ; DD 8E 80
 adc a, (iy)                    ; FD 8E 00
 adc a, (iy+127)                ; FD 8E 7F
 adc a, (iy-128)                ; FD 8E 80
 adc a, -128                    ; CE 80
 adc a, 127                     ; CE 7F
 adc a, 255                     ; CE FF
 adc a, a                       ; 8F
 adc a, b                       ; 88
 adc a, c                       ; 89
 adc a, d                       ; 8A
 adc a, e                       ; 8B
 adc a, h                       ; 8C
 adc a, ixh                     ; DD 8C
 adc a, ixl                     ; DD 8D
 adc a, iyh                     ; FD 8C
 adc a, iyl                     ; FD 8D
 adc a, l                       ; 8D
 adc b                          ; 88
 adc c                          ; 89
 adc d                          ; 8A
 adc e                          ; 8B
 adc h                          ; 8C
 adc hl, bc                     ; ED 4A
 adc hl, de                     ; ED 5A
 adc hl, hl                     ; ED 6A
 adc hl, sp                     ; ED 7A
 adc ixh                        ; DD 8C
 adc ixl                        ; DD 8D
 adc iyh                        ; FD 8C
 adc iyl                        ; FD 8D
 adc l                          ; 8D
 add (hl)                       ; 86
 add (ix)                       ; DD 86 00
 add (ix+127)                   ; DD 86 7F
 add (ix-128)                   ; DD 86 80
 add (iy)                       ; FD 86 00
 add (iy+127)                   ; FD 86 7F
 add (iy-128)                   ; FD 86 80
 add -128                       ; C6 80
 add 127                        ; C6 7F
 add 255                        ; C6 FF
 add a                          ; 87
 add a, (hl)                    ; 86
 add a, (ix)                    ; DD 86 00
 add a, (ix+127)                ; DD 86 7F
 add a, (ix-128)                ; DD 86 80
 add a, (iy)                    ; FD 86 00
 add a, (iy+127)                ; FD 86 7F
 add a, (iy-128)                ; FD 86 80
 add a, -128                    ; C6 80
 add a, 127                     ; C6 7F
 add a, 255                     ; C6 FF
 add a, a                       ; 87
 add a, b                       ; 80
 add a, c                       ; 81
 add a, d                       ; 82
 add a, e                       ; 83
 add a, h                       ; 84
 add a, ixh                     ; DD 84
 add a, ixl                     ; DD 85
 add a, iyh                     ; FD 84
 add a, iyl                     ; FD 85
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
 add ix, bc                     ; DD 09
 add ix, de                     ; DD 19
 add ix, ix                     ; DD 29
 add ix, sp                     ; DD 39
 add ixh                        ; DD 84
 add ixl                        ; DD 85
 add iy, bc                     ; FD 09
 add iy, de                     ; FD 19
 add iy, iy                     ; FD 29
 add iy, sp                     ; FD 39
 add iyh                        ; FD 84
 add iyl                        ; FD 85
 add l                          ; 85
 and (hl)                       ; A6
 and (ix)                       ; DD A6 00
 and (ix+127)                   ; DD A6 7F
 and (ix-128)                   ; DD A6 80
 and (iy)                       ; FD A6 00
 and (iy+127)                   ; FD A6 7F
 and (iy-128)                   ; FD A6 80
 and -128                       ; E6 80
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; A7
 and a, (hl)                    ; A6
 and a, (ix)                    ; DD A6 00
 and a, (ix+127)                ; DD A6 7F
 and a, (ix-128)                ; DD A6 80
 and a, (iy)                    ; FD A6 00
 and a, (iy+127)                ; FD A6 7F
 and a, (iy-128)                ; FD A6 80
 and a, -128                    ; E6 80
 and a, 127                     ; E6 7F
 and a, 255                     ; E6 FF
 and a, a                       ; A7
 and a, b                       ; A0
 and a, c                       ; A1
 and a, d                       ; A2
 and a, e                       ; A3
 and a, h                       ; A4
 and a, ixh                     ; DD A4
 and a, ixl                     ; DD A5
 and a, iyh                     ; FD A4
 and a, iyl                     ; FD A5
 and a, l                       ; A5
 and b                          ; A0
 and c                          ; A1
 and d                          ; A2
 and e                          ; A3
 and h                          ; A4
 and ixh                        ; DD A4
 and ixl                        ; DD A5
 and iyh                        ; FD A4
 and iyl                        ; FD A5
 and l                          ; A5
 bit 0, (hl)                    ; CB 46
 bit 0, (ix)                    ; DD CB 00 46
 bit 0, (ix+127)                ; DD CB 7F 46
 bit 0, (ix-128)                ; DD CB 80 46
 bit 0, (iy)                    ; FD CB 00 46
 bit 0, (iy+127)                ; FD CB 7F 46
 bit 0, (iy-128)                ; FD CB 80 46
 bit 0, a                       ; CB 47
 bit 0, b                       ; CB 40
 bit 0, c                       ; CB 41
 bit 0, d                       ; CB 42
 bit 0, e                       ; CB 43
 bit 0, h                       ; CB 44
 bit 0, ixh                     ; DD CB 44
 bit 0, ixl                     ; DD CB 45
 bit 0, iyh                     ; FD CB 44
 bit 0, iyl                     ; FD CB 45
 bit 0, l                       ; CB 45
 bit 1, (hl)                    ; CB 4E
 bit 1, (ix)                    ; DD CB 00 4E
 bit 1, (ix+127)                ; DD CB 7F 4E
 bit 1, (ix-128)                ; DD CB 80 4E
 bit 1, (iy)                    ; FD CB 00 4E
 bit 1, (iy+127)                ; FD CB 7F 4E
 bit 1, (iy-128)                ; FD CB 80 4E
 bit 1, a                       ; CB 4F
 bit 1, b                       ; CB 48
 bit 1, c                       ; CB 49
 bit 1, d                       ; CB 4A
 bit 1, e                       ; CB 4B
 bit 1, h                       ; CB 4C
 bit 1, ixh                     ; DD CB 4C
 bit 1, ixl                     ; DD CB 4D
 bit 1, iyh                     ; FD CB 4C
 bit 1, iyl                     ; FD CB 4D
 bit 1, l                       ; CB 4D
 bit 2, (hl)                    ; CB 56
 bit 2, (ix)                    ; DD CB 00 56
 bit 2, (ix+127)                ; DD CB 7F 56
 bit 2, (ix-128)                ; DD CB 80 56
 bit 2, (iy)                    ; FD CB 00 56
 bit 2, (iy+127)                ; FD CB 7F 56
 bit 2, (iy-128)                ; FD CB 80 56
 bit 2, a                       ; CB 57
 bit 2, b                       ; CB 50
 bit 2, c                       ; CB 51
 bit 2, d                       ; CB 52
 bit 2, e                       ; CB 53
 bit 2, h                       ; CB 54
 bit 2, ixh                     ; DD CB 54
 bit 2, ixl                     ; DD CB 55
 bit 2, iyh                     ; FD CB 54
 bit 2, iyl                     ; FD CB 55
 bit 2, l                       ; CB 55
 bit 3, (hl)                    ; CB 5E
 bit 3, (ix)                    ; DD CB 00 5E
 bit 3, (ix+127)                ; DD CB 7F 5E
 bit 3, (ix-128)                ; DD CB 80 5E
 bit 3, (iy)                    ; FD CB 00 5E
 bit 3, (iy+127)                ; FD CB 7F 5E
 bit 3, (iy-128)                ; FD CB 80 5E
 bit 3, a                       ; CB 5F
 bit 3, b                       ; CB 58
 bit 3, c                       ; CB 59
 bit 3, d                       ; CB 5A
 bit 3, e                       ; CB 5B
 bit 3, h                       ; CB 5C
 bit 3, ixh                     ; DD CB 5C
 bit 3, ixl                     ; DD CB 5D
 bit 3, iyh                     ; FD CB 5C
 bit 3, iyl                     ; FD CB 5D
 bit 3, l                       ; CB 5D
 bit 4, (hl)                    ; CB 66
 bit 4, (ix)                    ; DD CB 00 66
 bit 4, (ix+127)                ; DD CB 7F 66
 bit 4, (ix-128)                ; DD CB 80 66
 bit 4, (iy)                    ; FD CB 00 66
 bit 4, (iy+127)                ; FD CB 7F 66
 bit 4, (iy-128)                ; FD CB 80 66
 bit 4, a                       ; CB 67
 bit 4, b                       ; CB 60
 bit 4, c                       ; CB 61
 bit 4, d                       ; CB 62
 bit 4, e                       ; CB 63
 bit 4, h                       ; CB 64
 bit 4, ixh                     ; DD CB 64
 bit 4, ixl                     ; DD CB 65
 bit 4, iyh                     ; FD CB 64
 bit 4, iyl                     ; FD CB 65
 bit 4, l                       ; CB 65
 bit 5, (hl)                    ; CB 6E
 bit 5, (ix)                    ; DD CB 00 6E
 bit 5, (ix+127)                ; DD CB 7F 6E
 bit 5, (ix-128)                ; DD CB 80 6E
 bit 5, (iy)                    ; FD CB 00 6E
 bit 5, (iy+127)                ; FD CB 7F 6E
 bit 5, (iy-128)                ; FD CB 80 6E
 bit 5, a                       ; CB 6F
 bit 5, b                       ; CB 68
 bit 5, c                       ; CB 69
 bit 5, d                       ; CB 6A
 bit 5, e                       ; CB 6B
 bit 5, h                       ; CB 6C
 bit 5, ixh                     ; DD CB 6C
 bit 5, ixl                     ; DD CB 6D
 bit 5, iyh                     ; FD CB 6C
 bit 5, iyl                     ; FD CB 6D
 bit 5, l                       ; CB 6D
 bit 6, (hl)                    ; CB 76
 bit 6, (ix)                    ; DD CB 00 76
 bit 6, (ix+127)                ; DD CB 7F 76
 bit 6, (ix-128)                ; DD CB 80 76
 bit 6, (iy)                    ; FD CB 00 76
 bit 6, (iy+127)                ; FD CB 7F 76
 bit 6, (iy-128)                ; FD CB 80 76
 bit 6, a                       ; CB 77
 bit 6, b                       ; CB 70
 bit 6, c                       ; CB 71
 bit 6, d                       ; CB 72
 bit 6, e                       ; CB 73
 bit 6, h                       ; CB 74
 bit 6, ixh                     ; DD CB 74
 bit 6, ixl                     ; DD CB 75
 bit 6, iyh                     ; FD CB 74
 bit 6, iyl                     ; FD CB 75
 bit 6, l                       ; CB 75
 bit 7, (hl)                    ; CB 7E
 bit 7, (ix)                    ; DD CB 00 7E
 bit 7, (ix+127)                ; DD CB 7F 7E
 bit 7, (ix-128)                ; DD CB 80 7E
 bit 7, (iy)                    ; FD CB 00 7E
 bit 7, (iy+127)                ; FD CB 7F 7E
 bit 7, (iy-128)                ; FD CB 80 7E
 bit 7, a                       ; CB 7F
 bit 7, b                       ; CB 78
 bit 7, c                       ; CB 79
 bit 7, d                       ; CB 7A
 bit 7, e                       ; CB 7B
 bit 7, h                       ; CB 7C
 bit 7, ixh                     ; DD CB 7C
 bit 7, ixl                     ; DD CB 7D
 bit 7, iyh                     ; FD CB 7C
 bit 7, iyl                     ; FD CB 7D
 bit 7, l                       ; CB 7D
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
 cp (ix)                        ; DD BE 00
 cp (ix+127)                    ; DD BE 7F
 cp (ix-128)                    ; DD BE 80
 cp (iy)                        ; FD BE 00
 cp (iy+127)                    ; FD BE 7F
 cp (iy-128)                    ; FD BE 80
 cp -128                        ; FE 80
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; BF
 cp a, (hl)                     ; BE
 cp a, (ix)                     ; DD BE 00
 cp a, (ix+127)                 ; DD BE 7F
 cp a, (ix-128)                 ; DD BE 80
 cp a, (iy)                     ; FD BE 00
 cp a, (iy+127)                 ; FD BE 7F
 cp a, (iy-128)                 ; FD BE 80
 cp a, -128                     ; FE 80
 cp a, 127                      ; FE 7F
 cp a, 255                      ; FE FF
 cp a, a                        ; BF
 cp a, b                        ; B8
 cp a, c                        ; B9
 cp a, d                        ; BA
 cp a, e                        ; BB
 cp a, h                        ; BC
 cp a, ixh                      ; DD BC
 cp a, ixl                      ; DD BD
 cp a, iyh                      ; FD BC
 cp a, iyl                      ; FD BD
 cp a, l                        ; BD
 cp b                           ; B8
 cp c                           ; B9
 cp d                           ; BA
 cp e                           ; BB
 cp h                           ; BC
 cp ixh                         ; DD BC
 cp ixl                         ; DD BD
 cp iyh                         ; FD BC
 cp iyl                         ; FD BD
 cp l                           ; BD
 cpd                            ; ED A9
 cpdr                           ; ED B9
 cpi                            ; ED A1
 cpir                           ; ED B1
 cpl                            ; 2F
 cpl a                          ; 2F
 daa                            ; 27
 dec (hl)                       ; 35
 dec (ix)                       ; DD 35 00
 dec (ix+127)                   ; DD 35 7F
 dec (ix-128)                   ; DD 35 80
 dec (iy)                       ; FD 35 00
 dec (iy+127)                   ; FD 35 7F
 dec (iy-128)                   ; FD 35 80
 dec a                          ; 3D
 dec b                          ; 05
 dec bc                         ; 0B
 dec c                          ; 0D
 dec d                          ; 15
 dec de                         ; 1B
 dec e                          ; 1D
 dec h                          ; 25
 dec hl                         ; 2B
 dec ix                         ; DD 2B
 dec ixh                        ; DD 25
 dec ixl                        ; DD 2D
 dec iy                         ; FD 2B
 dec iyh                        ; FD 25
 dec iyl                        ; FD 2D
 dec l                          ; 2D
 dec sp                         ; 3B
 di                             ; F3
 djnz ASMPC                     ; 10 FE
 djnz b, ASMPC                  ; 10 FE
 ei                             ; FB
 ex (sp), hl                    ; E3
 ex (sp), ix                    ; DD E3
 ex (sp), iy                    ; FD E3
 ex af, af                      ; 08
 ex af, af'                     ; 08
 ex de, hl                      ; EB
 exx                            ; D9
 halt                           ; 76
 im 0                           ; ED 46
 im 1                           ; ED 56
 im 2                           ; ED 5E
 in (c)                         ; ED 70
 in a, (-128)                   ; DB 80
 in a, (127)                    ; DB 7F
 in a, (255)                    ; DB FF
 in a, (c)                      ; ED 78
 in b, (c)                      ; ED 40
 in c, (c)                      ; ED 48
 in d, (c)                      ; ED 50
 in e, (c)                      ; ED 58
 in f, (c)                      ; ED 70
 in h, (c)                      ; ED 60
 in l, (c)                      ; ED 68
 inc (hl)                       ; 34
 inc (ix)                       ; DD 34 00
 inc (ix+127)                   ; DD 34 7F
 inc (ix-128)                   ; DD 34 80
 inc (iy)                       ; FD 34 00
 inc (iy+127)                   ; FD 34 7F
 inc (iy-128)                   ; FD 34 80
 inc a                          ; 3C
 inc b                          ; 04
 inc bc                         ; 03
 inc c                          ; 0C
 inc d                          ; 14
 inc de                         ; 13
 inc e                          ; 1C
 inc h                          ; 24
 inc hl                         ; 23
 inc ix                         ; DD 23
 inc ixh                        ; DD 24
 inc ixl                        ; DD 2C
 inc iy                         ; FD 23
 inc iyh                        ; FD 24
 inc iyl                        ; FD 2C
 inc l                          ; 2C
 inc sp                         ; 33
 ind                            ; ED AA
 indr                           ; ED BA
 ini                            ; ED A2
 inir                           ; ED B2
 jp (hl)                        ; E9
 jp (ix)                        ; DD E9
 jp (iy)                        ; FD E9
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
 jr ASMPC                       ; 18 FE
 jr c, ASMPC                    ; 38 FE
 jr nc, ASMPC                   ; 30 FE
 jr nz, ASMPC                   ; 20 FE
 jr z, ASMPC                    ; 28 FE
 ld (-32768), a                 ; 32 00 80
 ld (-32768), bc                ; ED 43 00 80
 ld (-32768), de                ; ED 53 00 80
 ld (-32768), hl                ; 22 00 80
 ld (-32768), ix                ; DD 22 00 80
 ld (-32768), iy                ; FD 22 00 80
 ld (-32768), sp                ; ED 73 00 80
 ld (32767), a                  ; 32 FF 7F
 ld (32767), bc                 ; ED 43 FF 7F
 ld (32767), de                 ; ED 53 FF 7F
 ld (32767), hl                 ; 22 FF 7F
 ld (32767), ix                 ; DD 22 FF 7F
 ld (32767), iy                 ; FD 22 FF 7F
 ld (32767), sp                 ; ED 73 FF 7F
 ld (65535), a                  ; 32 FF FF
 ld (65535), bc                 ; ED 43 FF FF
 ld (65535), de                 ; ED 53 FF FF
 ld (65535), hl                 ; 22 FF FF
 ld (65535), ix                 ; DD 22 FF FF
 ld (65535), iy                 ; FD 22 FF FF
 ld (65535), sp                 ; ED 73 FF FF
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
 ld (ix), -128                  ; DD 36 00 80
 ld (ix), 127                   ; DD 36 00 7F
 ld (ix), 255                   ; DD 36 00 FF
 ld (ix), a                     ; DD 77 00
 ld (ix), b                     ; DD 70 00
 ld (ix), c                     ; DD 71 00
 ld (ix), d                     ; DD 72 00
 ld (ix), e                     ; DD 73 00
 ld (ix), h                     ; DD 74 00
 ld (ix), l                     ; DD 75 00
 ld (ix+127), -128              ; DD 36 7F 80
 ld (ix+127), 127               ; DD 36 7F 7F
 ld (ix+127), 255               ; DD 36 7F FF
 ld (ix+127), a                 ; DD 77 7F
 ld (ix+127), b                 ; DD 70 7F
 ld (ix+127), c                 ; DD 71 7F
 ld (ix+127), d                 ; DD 72 7F
 ld (ix+127), e                 ; DD 73 7F
 ld (ix+127), h                 ; DD 74 7F
 ld (ix+127), l                 ; DD 75 7F
 ld (ix-128), -128              ; DD 36 80 80
 ld (ix-128), 127               ; DD 36 80 7F
 ld (ix-128), 255               ; DD 36 80 FF
 ld (ix-128), a                 ; DD 77 80
 ld (ix-128), b                 ; DD 70 80
 ld (ix-128), c                 ; DD 71 80
 ld (ix-128), d                 ; DD 72 80
 ld (ix-128), e                 ; DD 73 80
 ld (ix-128), h                 ; DD 74 80
 ld (ix-128), l                 ; DD 75 80
 ld (iy), -128                  ; FD 36 00 80
 ld (iy), 127                   ; FD 36 00 7F
 ld (iy), 255                   ; FD 36 00 FF
 ld (iy), a                     ; FD 77 00
 ld (iy), b                     ; FD 70 00
 ld (iy), c                     ; FD 71 00
 ld (iy), d                     ; FD 72 00
 ld (iy), e                     ; FD 73 00
 ld (iy), h                     ; FD 74 00
 ld (iy), l                     ; FD 75 00
 ld (iy+127), -128              ; FD 36 7F 80
 ld (iy+127), 127               ; FD 36 7F 7F
 ld (iy+127), 255               ; FD 36 7F FF
 ld (iy+127), a                 ; FD 77 7F
 ld (iy+127), b                 ; FD 70 7F
 ld (iy+127), c                 ; FD 71 7F
 ld (iy+127), d                 ; FD 72 7F
 ld (iy+127), e                 ; FD 73 7F
 ld (iy+127), h                 ; FD 74 7F
 ld (iy+127), l                 ; FD 75 7F
 ld (iy-128), -128              ; FD 36 80 80
 ld (iy-128), 127               ; FD 36 80 7F
 ld (iy-128), 255               ; FD 36 80 FF
 ld (iy-128), a                 ; FD 77 80
 ld (iy-128), b                 ; FD 70 80
 ld (iy-128), c                 ; FD 71 80
 ld (iy-128), d                 ; FD 72 80
 ld (iy-128), e                 ; FD 73 80
 ld (iy-128), h                 ; FD 74 80
 ld (iy-128), l                 ; FD 75 80
 ld a, (-32768)                 ; 3A 00 80
 ld a, (32767)                  ; 3A FF 7F
 ld a, (65535)                  ; 3A FF FF
 ld a, (bc)                     ; 0A
 ld a, (de)                     ; 1A
 ld a, (hl)                     ; 7E
 ld a, (ix)                     ; DD 7E 00
 ld a, (ix+127)                 ; DD 7E 7F
 ld a, (ix-128)                 ; DD 7E 80
 ld a, (iy)                     ; FD 7E 00
 ld a, (iy+127)                 ; FD 7E 7F
 ld a, (iy-128)                 ; FD 7E 80
 ld a, -128                     ; 3E 80
 ld a, 127                      ; 3E 7F
 ld a, 255                      ; 3E FF
 ld a, a                        ; 7F
 ld a, b                        ; 78
 ld a, c                        ; 79
 ld a, d                        ; 7A
 ld a, e                        ; 7B
 ld a, h                        ; 7C
 ld a, i                        ; ED 57
 ld a, ixh                      ; DD 7C
 ld a, ixl                      ; DD 7D
 ld a, iyh                      ; FD 7C
 ld a, iyl                      ; FD 7D
 ld a, l                        ; 7D
 ld a, r                        ; ED 5F
 ld b, (hl)                     ; 46
 ld b, (ix)                     ; DD 46 00
 ld b, (ix+127)                 ; DD 46 7F
 ld b, (ix-128)                 ; DD 46 80
 ld b, (iy)                     ; FD 46 00
 ld b, (iy+127)                 ; FD 46 7F
 ld b, (iy-128)                 ; FD 46 80
 ld b, -128                     ; 06 80
 ld b, 127                      ; 06 7F
 ld b, 255                      ; 06 FF
 ld b, a                        ; 47
 ld b, b                        ; 40
 ld b, c                        ; 41
 ld b, d                        ; 42
 ld b, e                        ; 43
 ld b, h                        ; 44
 ld b, ixh                      ; DD 44
 ld b, ixl                      ; DD 45
 ld b, iyh                      ; FD 44
 ld b, iyl                      ; FD 45
 ld b, l                        ; 45
 ld bc, (-32768)                ; ED 4B 00 80
 ld bc, (32767)                 ; ED 4B FF 7F
 ld bc, (65535)                 ; ED 4B FF FF
 ld bc, -32768                  ; 01 00 80
 ld bc, 32767                   ; 01 FF 7F
 ld bc, 65535                   ; 01 FF FF
 ld c, (hl)                     ; 4E
 ld c, (ix)                     ; DD 4E 00
 ld c, (ix+127)                 ; DD 4E 7F
 ld c, (ix-128)                 ; DD 4E 80
 ld c, (iy)                     ; FD 4E 00
 ld c, (iy+127)                 ; FD 4E 7F
 ld c, (iy-128)                 ; FD 4E 80
 ld c, -128                     ; 0E 80
 ld c, 127                      ; 0E 7F
 ld c, 255                      ; 0E FF
 ld c, a                        ; 4F
 ld c, b                        ; 48
 ld c, c                        ; 49
 ld c, d                        ; 4A
 ld c, e                        ; 4B
 ld c, h                        ; 4C
 ld c, ixh                      ; DD 4C
 ld c, ixl                      ; DD 4D
 ld c, iyh                      ; FD 4C
 ld c, iyl                      ; FD 4D
 ld c, l                        ; 4D
 ld d, (hl)                     ; 56
 ld d, (ix)                     ; DD 56 00
 ld d, (ix+127)                 ; DD 56 7F
 ld d, (ix-128)                 ; DD 56 80
 ld d, (iy)                     ; FD 56 00
 ld d, (iy+127)                 ; FD 56 7F
 ld d, (iy-128)                 ; FD 56 80
 ld d, -128                     ; 16 80
 ld d, 127                      ; 16 7F
 ld d, 255                      ; 16 FF
 ld d, a                        ; 57
 ld d, b                        ; 50
 ld d, c                        ; 51
 ld d, d                        ; 52
 ld d, e                        ; 53
 ld d, h                        ; 54
 ld d, ixh                      ; DD 54
 ld d, ixl                      ; DD 55
 ld d, iyh                      ; FD 54
 ld d, iyl                      ; FD 55
 ld d, l                        ; 55
 ld de, (-32768)                ; ED 5B 00 80
 ld de, (32767)                 ; ED 5B FF 7F
 ld de, (65535)                 ; ED 5B FF FF
 ld de, -32768                  ; 11 00 80
 ld de, 32767                   ; 11 FF 7F
 ld de, 65535                   ; 11 FF FF
 ld e, (hl)                     ; 5E
 ld e, (ix)                     ; DD 5E 00
 ld e, (ix+127)                 ; DD 5E 7F
 ld e, (ix-128)                 ; DD 5E 80
 ld e, (iy)                     ; FD 5E 00
 ld e, (iy+127)                 ; FD 5E 7F
 ld e, (iy-128)                 ; FD 5E 80
 ld e, -128                     ; 1E 80
 ld e, 127                      ; 1E 7F
 ld e, 255                      ; 1E FF
 ld e, a                        ; 5F
 ld e, b                        ; 58
 ld e, c                        ; 59
 ld e, d                        ; 5A
 ld e, e                        ; 5B
 ld e, h                        ; 5C
 ld e, ixh                      ; DD 5C
 ld e, ixl                      ; DD 5D
 ld e, iyh                      ; FD 5C
 ld e, iyl                      ; FD 5D
 ld e, l                        ; 5D
 ld h, (hl)                     ; 66
 ld h, (ix)                     ; DD 66 00
 ld h, (ix+127)                 ; DD 66 7F
 ld h, (ix-128)                 ; DD 66 80
 ld h, (iy)                     ; FD 66 00
 ld h, (iy+127)                 ; FD 66 7F
 ld h, (iy-128)                 ; FD 66 80
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
 ld i, a                        ; ED 47
 ld ix, (-32768)                ; DD 2A 00 80
 ld ix, (32767)                 ; DD 2A FF 7F
 ld ix, (65535)                 ; DD 2A FF FF
 ld ix, -32768                  ; DD 21 00 80
 ld ix, 32767                   ; DD 21 FF 7F
 ld ix, 65535                   ; DD 21 FF FF
 ld ixh, -128                   ; DD 26 80
 ld ixh, 127                    ; DD 26 7F
 ld ixh, 255                    ; DD 26 FF
 ld ixh, a                      ; DD 67
 ld ixh, b                      ; DD 60
 ld ixh, c                      ; DD 61
 ld ixh, d                      ; DD 62
 ld ixh, e                      ; DD 63
 ld ixh, ixh                    ; DD 64
 ld ixh, ixl                    ; DD 65
 ld ixl, -128                   ; DD 2E 80
 ld ixl, 127                    ; DD 2E 7F
 ld ixl, 255                    ; DD 2E FF
 ld ixl, a                      ; DD 6F
 ld ixl, b                      ; DD 68
 ld ixl, c                      ; DD 69
 ld ixl, d                      ; DD 6A
 ld ixl, e                      ; DD 6B
 ld ixl, ixh                    ; DD 6C
 ld ixl, ixl                    ; DD 6D
 ld iy, (-32768)                ; FD 2A 00 80
 ld iy, (32767)                 ; FD 2A FF 7F
 ld iy, (65535)                 ; FD 2A FF FF
 ld iy, -32768                  ; FD 21 00 80
 ld iy, 32767                   ; FD 21 FF 7F
 ld iy, 65535                   ; FD 21 FF FF
 ld iyh, -128                   ; FD 26 80
 ld iyh, 127                    ; FD 26 7F
 ld iyh, 255                    ; FD 26 FF
 ld iyh, a                      ; FD 67
 ld iyh, b                      ; FD 60
 ld iyh, c                      ; FD 61
 ld iyh, d                      ; FD 62
 ld iyh, e                      ; FD 63
 ld iyh, iyh                    ; FD 64
 ld iyh, iyl                    ; FD 65
 ld iyl, -128                   ; FD 2E 80
 ld iyl, 127                    ; FD 2E 7F
 ld iyl, 255                    ; FD 2E FF
 ld iyl, a                      ; FD 6F
 ld iyl, b                      ; FD 68
 ld iyl, c                      ; FD 69
 ld iyl, d                      ; FD 6A
 ld iyl, e                      ; FD 6B
 ld iyl, iyh                    ; FD 6C
 ld iyl, iyl                    ; FD 6D
 ld l, (hl)                     ; 6E
 ld l, (ix)                     ; DD 6E 00
 ld l, (ix+127)                 ; DD 6E 7F
 ld l, (ix-128)                 ; DD 6E 80
 ld l, (iy)                     ; FD 6E 00
 ld l, (iy+127)                 ; FD 6E 7F
 ld l, (iy-128)                 ; FD 6E 80
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
 ld r, a                        ; ED 4F
 ld sp, (-32768)                ; ED 7B 00 80
 ld sp, (32767)                 ; ED 7B FF 7F
 ld sp, (65535)                 ; ED 7B FF FF
 ld sp, -32768                  ; 31 00 80
 ld sp, 32767                   ; 31 FF 7F
 ld sp, 65535                   ; 31 FF FF
 ld sp, hl                      ; F9
 ld sp, ix                      ; DD F9
 ld sp, iy                      ; FD F9
 ldd                            ; ED A8
 lddr                           ; ED B8
 ldi                            ; ED A0
 ldir                           ; ED B0
 neg                            ; ED 44
 neg a                          ; ED 44
 nop                            ; 00
 or (hl)                        ; B6
 or (ix)                        ; DD B6 00
 or (ix+127)                    ; DD B6 7F
 or (ix-128)                    ; DD B6 80
 or (iy)                        ; FD B6 00
 or (iy+127)                    ; FD B6 7F
 or (iy-128)                    ; FD B6 80
 or -128                        ; F6 80
 or 127                         ; F6 7F
 or 255                         ; F6 FF
 or a                           ; B7
 or a, (hl)                     ; B6
 or a, (ix)                     ; DD B6 00
 or a, (ix+127)                 ; DD B6 7F
 or a, (ix-128)                 ; DD B6 80
 or a, (iy)                     ; FD B6 00
 or a, (iy+127)                 ; FD B6 7F
 or a, (iy-128)                 ; FD B6 80
 or a, -128                     ; F6 80
 or a, 127                      ; F6 7F
 or a, 255                      ; F6 FF
 or a, a                        ; B7
 or a, b                        ; B0
 or a, c                        ; B1
 or a, d                        ; B2
 or a, e                        ; B3
 or a, h                        ; B4
 or a, ixh                      ; DD B4
 or a, ixl                      ; DD B5
 or a, iyh                      ; FD B4
 or a, iyl                      ; FD B5
 or a, l                        ; B5
 or b                           ; B0
 or c                           ; B1
 or d                           ; B2
 or e                           ; B3
 or h                           ; B4
 or ixh                         ; DD B4
 or ixl                         ; DD B5
 or iyh                         ; FD B4
 or iyl                         ; FD B5
 or l                           ; B5
 otdr                           ; ED BB
 otir                           ; ED B3
 out (-128), a                  ; D3 80
 out (127), a                   ; D3 7F
 out (255), a                   ; D3 FF
 out (c), 0                     ; ED 71
 out (c), a                     ; ED 79
 out (c), b                     ; ED 41
 out (c), c                     ; ED 49
 out (c), d                     ; ED 51
 out (c), e                     ; ED 59
 out (c), h                     ; ED 61
 out (c), l                     ; ED 69
 outd                           ; ED AB
 outi                           ; ED A3
 pop af                         ; F1
 pop bc                         ; C1
 pop de                         ; D1
 pop hl                         ; E1
 pop ix                         ; DD E1
 pop iy                         ; FD E1
 push af                        ; F5
 push bc                        ; C5
 push de                        ; D5
 push hl                        ; E5
 push ix                        ; DD E5
 push iy                        ; FD E5
 res 0, (hl)                    ; CB 86
 res 0, (ix)                    ; DD CB 00 86
 res 0, (ix+127)                ; DD CB 7F 86
 res 0, (ix-128)                ; DD CB 80 86
 res 0, (iy)                    ; FD CB 00 86
 res 0, (iy+127)                ; FD CB 7F 86
 res 0, (iy-128)                ; FD CB 80 86
 res 0, a                       ; CB 87
 res 0, b                       ; CB 80
 res 0, c                       ; CB 81
 res 0, d                       ; CB 82
 res 0, e                       ; CB 83
 res 0, h                       ; CB 84
 res 0, ixh                     ; DD CB 84
 res 0, ixl                     ; DD CB 85
 res 0, iyh                     ; FD CB 84
 res 0, iyl                     ; FD CB 85
 res 0, l                       ; CB 85
 res 1, (hl)                    ; CB 8E
 res 1, (ix)                    ; DD CB 00 8E
 res 1, (ix+127)                ; DD CB 7F 8E
 res 1, (ix-128)                ; DD CB 80 8E
 res 1, (iy)                    ; FD CB 00 8E
 res 1, (iy+127)                ; FD CB 7F 8E
 res 1, (iy-128)                ; FD CB 80 8E
 res 1, a                       ; CB 8F
 res 1, b                       ; CB 88
 res 1, c                       ; CB 89
 res 1, d                       ; CB 8A
 res 1, e                       ; CB 8B
 res 1, h                       ; CB 8C
 res 1, ixh                     ; DD CB 8C
 res 1, ixl                     ; DD CB 8D
 res 1, iyh                     ; FD CB 8C
 res 1, iyl                     ; FD CB 8D
 res 1, l                       ; CB 8D
 res 2, (hl)                    ; CB 96
 res 2, (ix)                    ; DD CB 00 96
 res 2, (ix+127)                ; DD CB 7F 96
 res 2, (ix-128)                ; DD CB 80 96
 res 2, (iy)                    ; FD CB 00 96
 res 2, (iy+127)                ; FD CB 7F 96
 res 2, (iy-128)                ; FD CB 80 96
 res 2, a                       ; CB 97
 res 2, b                       ; CB 90
 res 2, c                       ; CB 91
 res 2, d                       ; CB 92
 res 2, e                       ; CB 93
 res 2, h                       ; CB 94
 res 2, ixh                     ; DD CB 94
 res 2, ixl                     ; DD CB 95
 res 2, iyh                     ; FD CB 94
 res 2, iyl                     ; FD CB 95
 res 2, l                       ; CB 95
 res 3, (hl)                    ; CB 9E
 res 3, (ix)                    ; DD CB 00 9E
 res 3, (ix+127)                ; DD CB 7F 9E
 res 3, (ix-128)                ; DD CB 80 9E
 res 3, (iy)                    ; FD CB 00 9E
 res 3, (iy+127)                ; FD CB 7F 9E
 res 3, (iy-128)                ; FD CB 80 9E
 res 3, a                       ; CB 9F
 res 3, b                       ; CB 98
 res 3, c                       ; CB 99
 res 3, d                       ; CB 9A
 res 3, e                       ; CB 9B
 res 3, h                       ; CB 9C
 res 3, ixh                     ; DD CB 9C
 res 3, ixl                     ; DD CB 9D
 res 3, iyh                     ; FD CB 9C
 res 3, iyl                     ; FD CB 9D
 res 3, l                       ; CB 9D
 res 4, (hl)                    ; CB A6
 res 4, (ix)                    ; DD CB 00 A6
 res 4, (ix+127)                ; DD CB 7F A6
 res 4, (ix-128)                ; DD CB 80 A6
 res 4, (iy)                    ; FD CB 00 A6
 res 4, (iy+127)                ; FD CB 7F A6
 res 4, (iy-128)                ; FD CB 80 A6
 res 4, a                       ; CB A7
 res 4, b                       ; CB A0
 res 4, c                       ; CB A1
 res 4, d                       ; CB A2
 res 4, e                       ; CB A3
 res 4, h                       ; CB A4
 res 4, ixh                     ; DD CB A4
 res 4, ixl                     ; DD CB A5
 res 4, iyh                     ; FD CB A4
 res 4, iyl                     ; FD CB A5
 res 4, l                       ; CB A5
 res 5, (hl)                    ; CB AE
 res 5, (ix)                    ; DD CB 00 AE
 res 5, (ix+127)                ; DD CB 7F AE
 res 5, (ix-128)                ; DD CB 80 AE
 res 5, (iy)                    ; FD CB 00 AE
 res 5, (iy+127)                ; FD CB 7F AE
 res 5, (iy-128)                ; FD CB 80 AE
 res 5, a                       ; CB AF
 res 5, b                       ; CB A8
 res 5, c                       ; CB A9
 res 5, d                       ; CB AA
 res 5, e                       ; CB AB
 res 5, h                       ; CB AC
 res 5, ixh                     ; DD CB AC
 res 5, ixl                     ; DD CB AD
 res 5, iyh                     ; FD CB AC
 res 5, iyl                     ; FD CB AD
 res 5, l                       ; CB AD
 res 6, (hl)                    ; CB B6
 res 6, (ix)                    ; DD CB 00 B6
 res 6, (ix+127)                ; DD CB 7F B6
 res 6, (ix-128)                ; DD CB 80 B6
 res 6, (iy)                    ; FD CB 00 B6
 res 6, (iy+127)                ; FD CB 7F B6
 res 6, (iy-128)                ; FD CB 80 B6
 res 6, a                       ; CB B7
 res 6, b                       ; CB B0
 res 6, c                       ; CB B1
 res 6, d                       ; CB B2
 res 6, e                       ; CB B3
 res 6, h                       ; CB B4
 res 6, ixh                     ; DD CB B4
 res 6, ixl                     ; DD CB B5
 res 6, iyh                     ; FD CB B4
 res 6, iyl                     ; FD CB B5
 res 6, l                       ; CB B5
 res 7, (hl)                    ; CB BE
 res 7, (ix)                    ; DD CB 00 BE
 res 7, (ix+127)                ; DD CB 7F BE
 res 7, (ix-128)                ; DD CB 80 BE
 res 7, (iy)                    ; FD CB 00 BE
 res 7, (iy+127)                ; FD CB 7F BE
 res 7, (iy-128)                ; FD CB 80 BE
 res 7, a                       ; CB BF
 res 7, b                       ; CB B8
 res 7, c                       ; CB B9
 res 7, d                       ; CB BA
 res 7, e                       ; CB BB
 res 7, h                       ; CB BC
 res 7, ixh                     ; DD CB BC
 res 7, ixl                     ; DD CB BD
 res 7, iyh                     ; FD CB BC
 res 7, iyl                     ; FD CB BD
 res 7, l                       ; CB BD
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
 reti                           ; ED 4D
 retn                           ; ED 45
 rl (hl)                        ; CB 16
 rl (ix)                        ; DD CB 00 16
 rl (ix), a                     ; DD CB 00 17
 rl (ix), b                     ; DD CB 00 10
 rl (ix), c                     ; DD CB 00 11
 rl (ix), d                     ; DD CB 00 12
 rl (ix), e                     ; DD CB 00 13
 rl (ix), h                     ; DD CB 00 14
 rl (ix), l                     ; DD CB 00 15
 rl (ix+127)                    ; DD CB 7F 16
 rl (ix+127), a                 ; DD CB 7F 17
 rl (ix+127), b                 ; DD CB 7F 10
 rl (ix+127), c                 ; DD CB 7F 11
 rl (ix+127), d                 ; DD CB 7F 12
 rl (ix+127), e                 ; DD CB 7F 13
 rl (ix+127), h                 ; DD CB 7F 14
 rl (ix+127), l                 ; DD CB 7F 15
 rl (ix-128)                    ; DD CB 80 16
 rl (ix-128), a                 ; DD CB 80 17
 rl (ix-128), b                 ; DD CB 80 10
 rl (ix-128), c                 ; DD CB 80 11
 rl (ix-128), d                 ; DD CB 80 12
 rl (ix-128), e                 ; DD CB 80 13
 rl (ix-128), h                 ; DD CB 80 14
 rl (ix-128), l                 ; DD CB 80 15
 rl (iy)                        ; FD CB 00 16
 rl (iy), a                     ; FD CB 00 17
 rl (iy), b                     ; FD CB 00 10
 rl (iy), c                     ; FD CB 00 11
 rl (iy), d                     ; FD CB 00 12
 rl (iy), e                     ; FD CB 00 13
 rl (iy), h                     ; FD CB 00 14
 rl (iy), l                     ; FD CB 00 15
 rl (iy+127)                    ; FD CB 7F 16
 rl (iy+127), a                 ; FD CB 7F 17
 rl (iy+127), b                 ; FD CB 7F 10
 rl (iy+127), c                 ; FD CB 7F 11
 rl (iy+127), d                 ; FD CB 7F 12
 rl (iy+127), e                 ; FD CB 7F 13
 rl (iy+127), h                 ; FD CB 7F 14
 rl (iy+127), l                 ; FD CB 7F 15
 rl (iy-128)                    ; FD CB 80 16
 rl (iy-128), a                 ; FD CB 80 17
 rl (iy-128), b                 ; FD CB 80 10
 rl (iy-128), c                 ; FD CB 80 11
 rl (iy-128), d                 ; FD CB 80 12
 rl (iy-128), e                 ; FD CB 80 13
 rl (iy-128), h                 ; FD CB 80 14
 rl (iy-128), l                 ; FD CB 80 15
 rl a                           ; CB 17
 rl b                           ; CB 10
 rl c                           ; CB 11
 rl d                           ; CB 12
 rl e                           ; CB 13
 rl h                           ; CB 14
 rl ixh                         ; DD CB 14
 rl ixl                         ; DD CB 15
 rl iyh                         ; FD CB 14
 rl iyl                         ; FD CB 15
 rl l                           ; CB 15
 rla                            ; 17
 rlc (hl)                       ; CB 06
 rlc (ix)                       ; DD CB 00 06
 rlc (ix), a                    ; DD CB 00 07
 rlc (ix), b                    ; DD CB 00 00
 rlc (ix), c                    ; DD CB 00 01
 rlc (ix), d                    ; DD CB 00 02
 rlc (ix), e                    ; DD CB 00 03
 rlc (ix), h                    ; DD CB 00 04
 rlc (ix), l                    ; DD CB 00 05
 rlc (ix+127)                   ; DD CB 7F 06
 rlc (ix+127), a                ; DD CB 7F 07
 rlc (ix+127), b                ; DD CB 7F 00
 rlc (ix+127), c                ; DD CB 7F 01
 rlc (ix+127), d                ; DD CB 7F 02
 rlc (ix+127), e                ; DD CB 7F 03
 rlc (ix+127), h                ; DD CB 7F 04
 rlc (ix+127), l                ; DD CB 7F 05
 rlc (ix-128)                   ; DD CB 80 06
 rlc (ix-128), a                ; DD CB 80 07
 rlc (ix-128), b                ; DD CB 80 00
 rlc (ix-128), c                ; DD CB 80 01
 rlc (ix-128), d                ; DD CB 80 02
 rlc (ix-128), e                ; DD CB 80 03
 rlc (ix-128), h                ; DD CB 80 04
 rlc (ix-128), l                ; DD CB 80 05
 rlc (iy)                       ; FD CB 00 06
 rlc (iy), a                    ; FD CB 00 07
 rlc (iy), b                    ; FD CB 00 00
 rlc (iy), c                    ; FD CB 00 01
 rlc (iy), d                    ; FD CB 00 02
 rlc (iy), e                    ; FD CB 00 03
 rlc (iy), h                    ; FD CB 00 04
 rlc (iy), l                    ; FD CB 00 05
 rlc (iy+127)                   ; FD CB 7F 06
 rlc (iy+127), a                ; FD CB 7F 07
 rlc (iy+127), b                ; FD CB 7F 00
 rlc (iy+127), c                ; FD CB 7F 01
 rlc (iy+127), d                ; FD CB 7F 02
 rlc (iy+127), e                ; FD CB 7F 03
 rlc (iy+127), h                ; FD CB 7F 04
 rlc (iy+127), l                ; FD CB 7F 05
 rlc (iy-128)                   ; FD CB 80 06
 rlc (iy-128), a                ; FD CB 80 07
 rlc (iy-128), b                ; FD CB 80 00
 rlc (iy-128), c                ; FD CB 80 01
 rlc (iy-128), d                ; FD CB 80 02
 rlc (iy-128), e                ; FD CB 80 03
 rlc (iy-128), h                ; FD CB 80 04
 rlc (iy-128), l                ; FD CB 80 05
 rlc a                          ; CB 07
 rlc b                          ; CB 00
 rlc c                          ; CB 01
 rlc d                          ; CB 02
 rlc e                          ; CB 03
 rlc h                          ; CB 04
 rlc ixh                        ; DD CB 04
 rlc ixl                        ; DD CB 05
 rlc iyh                        ; FD CB 04
 rlc iyl                        ; FD CB 05
 rlc l                          ; CB 05
 rlca                           ; 07
 rld                            ; ED 6F
 rr (hl)                        ; CB 1E
 rr (ix)                        ; DD CB 00 1E
 rr (ix), a                     ; DD CB 00 1F
 rr (ix), b                     ; DD CB 00 18
 rr (ix), c                     ; DD CB 00 19
 rr (ix), d                     ; DD CB 00 1A
 rr (ix), e                     ; DD CB 00 1B
 rr (ix), h                     ; DD CB 00 1C
 rr (ix), l                     ; DD CB 00 1D
 rr (ix+127)                    ; DD CB 7F 1E
 rr (ix+127), a                 ; DD CB 7F 1F
 rr (ix+127), b                 ; DD CB 7F 18
 rr (ix+127), c                 ; DD CB 7F 19
 rr (ix+127), d                 ; DD CB 7F 1A
 rr (ix+127), e                 ; DD CB 7F 1B
 rr (ix+127), h                 ; DD CB 7F 1C
 rr (ix+127), l                 ; DD CB 7F 1D
 rr (ix-128)                    ; DD CB 80 1E
 rr (ix-128), a                 ; DD CB 80 1F
 rr (ix-128), b                 ; DD CB 80 18
 rr (ix-128), c                 ; DD CB 80 19
 rr (ix-128), d                 ; DD CB 80 1A
 rr (ix-128), e                 ; DD CB 80 1B
 rr (ix-128), h                 ; DD CB 80 1C
 rr (ix-128), l                 ; DD CB 80 1D
 rr (iy)                        ; FD CB 00 1E
 rr (iy), a                     ; FD CB 00 1F
 rr (iy), b                     ; FD CB 00 18
 rr (iy), c                     ; FD CB 00 19
 rr (iy), d                     ; FD CB 00 1A
 rr (iy), e                     ; FD CB 00 1B
 rr (iy), h                     ; FD CB 00 1C
 rr (iy), l                     ; FD CB 00 1D
 rr (iy+127)                    ; FD CB 7F 1E
 rr (iy+127), a                 ; FD CB 7F 1F
 rr (iy+127), b                 ; FD CB 7F 18
 rr (iy+127), c                 ; FD CB 7F 19
 rr (iy+127), d                 ; FD CB 7F 1A
 rr (iy+127), e                 ; FD CB 7F 1B
 rr (iy+127), h                 ; FD CB 7F 1C
 rr (iy+127), l                 ; FD CB 7F 1D
 rr (iy-128)                    ; FD CB 80 1E
 rr (iy-128), a                 ; FD CB 80 1F
 rr (iy-128), b                 ; FD CB 80 18
 rr (iy-128), c                 ; FD CB 80 19
 rr (iy-128), d                 ; FD CB 80 1A
 rr (iy-128), e                 ; FD CB 80 1B
 rr (iy-128), h                 ; FD CB 80 1C
 rr (iy-128), l                 ; FD CB 80 1D
 rr a                           ; CB 1F
 rr b                           ; CB 18
 rr c                           ; CB 19
 rr d                           ; CB 1A
 rr e                           ; CB 1B
 rr h                           ; CB 1C
 rr ixh                         ; DD CB 1C
 rr ixl                         ; DD CB 1D
 rr iyh                         ; FD CB 1C
 rr iyl                         ; FD CB 1D
 rr l                           ; CB 1D
 rra                            ; 1F
 rrc (hl)                       ; CB 0E
 rrc (ix)                       ; DD CB 00 0E
 rrc (ix), a                    ; DD CB 00 0F
 rrc (ix), b                    ; DD CB 00 08
 rrc (ix), c                    ; DD CB 00 09
 rrc (ix), d                    ; DD CB 00 0A
 rrc (ix), e                    ; DD CB 00 0B
 rrc (ix), h                    ; DD CB 00 0C
 rrc (ix), l                    ; DD CB 00 0D
 rrc (ix+127)                   ; DD CB 7F 0E
 rrc (ix+127), a                ; DD CB 7F 0F
 rrc (ix+127), b                ; DD CB 7F 08
 rrc (ix+127), c                ; DD CB 7F 09
 rrc (ix+127), d                ; DD CB 7F 0A
 rrc (ix+127), e                ; DD CB 7F 0B
 rrc (ix+127), h                ; DD CB 7F 0C
 rrc (ix+127), l                ; DD CB 7F 0D
 rrc (ix-128)                   ; DD CB 80 0E
 rrc (ix-128), a                ; DD CB 80 0F
 rrc (ix-128), b                ; DD CB 80 08
 rrc (ix-128), c                ; DD CB 80 09
 rrc (ix-128), d                ; DD CB 80 0A
 rrc (ix-128), e                ; DD CB 80 0B
 rrc (ix-128), h                ; DD CB 80 0C
 rrc (ix-128), l                ; DD CB 80 0D
 rrc (iy)                       ; FD CB 00 0E
 rrc (iy), a                    ; FD CB 00 0F
 rrc (iy), b                    ; FD CB 00 08
 rrc (iy), c                    ; FD CB 00 09
 rrc (iy), d                    ; FD CB 00 0A
 rrc (iy), e                    ; FD CB 00 0B
 rrc (iy), h                    ; FD CB 00 0C
 rrc (iy), l                    ; FD CB 00 0D
 rrc (iy+127)                   ; FD CB 7F 0E
 rrc (iy+127), a                ; FD CB 7F 0F
 rrc (iy+127), b                ; FD CB 7F 08
 rrc (iy+127), c                ; FD CB 7F 09
 rrc (iy+127), d                ; FD CB 7F 0A
 rrc (iy+127), e                ; FD CB 7F 0B
 rrc (iy+127), h                ; FD CB 7F 0C
 rrc (iy+127), l                ; FD CB 7F 0D
 rrc (iy-128)                   ; FD CB 80 0E
 rrc (iy-128), a                ; FD CB 80 0F
 rrc (iy-128), b                ; FD CB 80 08
 rrc (iy-128), c                ; FD CB 80 09
 rrc (iy-128), d                ; FD CB 80 0A
 rrc (iy-128), e                ; FD CB 80 0B
 rrc (iy-128), h                ; FD CB 80 0C
 rrc (iy-128), l                ; FD CB 80 0D
 rrc a                          ; CB 0F
 rrc b                          ; CB 08
 rrc c                          ; CB 09
 rrc d                          ; CB 0A
 rrc e                          ; CB 0B
 rrc h                          ; CB 0C
 rrc ixh                        ; DD CB 0C
 rrc ixl                        ; DD CB 0D
 rrc iyh                        ; FD CB 0C
 rrc iyl                        ; FD CB 0D
 rrc l                          ; CB 0D
 rrca                           ; 0F
 rrd                            ; ED 67
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
 sbc (ix)                       ; DD 9E 00
 sbc (ix+127)                   ; DD 9E 7F
 sbc (ix-128)                   ; DD 9E 80
 sbc (iy)                       ; FD 9E 00
 sbc (iy+127)                   ; FD 9E 7F
 sbc (iy-128)                   ; FD 9E 80
 sbc -128                       ; DE 80
 sbc 127                        ; DE 7F
 sbc 255                        ; DE FF
 sbc a                          ; 9F
 sbc a, (hl)                    ; 9E
 sbc a, (ix)                    ; DD 9E 00
 sbc a, (ix+127)                ; DD 9E 7F
 sbc a, (ix-128)                ; DD 9E 80
 sbc a, (iy)                    ; FD 9E 00
 sbc a, (iy+127)                ; FD 9E 7F
 sbc a, (iy-128)                ; FD 9E 80
 sbc a, -128                    ; DE 80
 sbc a, 127                     ; DE 7F
 sbc a, 255                     ; DE FF
 sbc a, a                       ; 9F
 sbc a, b                       ; 98
 sbc a, c                       ; 99
 sbc a, d                       ; 9A
 sbc a, e                       ; 9B
 sbc a, h                       ; 9C
 sbc a, ixh                     ; DD 9C
 sbc a, ixl                     ; DD 9D
 sbc a, iyh                     ; FD 9C
 sbc a, iyl                     ; FD 9D
 sbc a, l                       ; 9D
 sbc b                          ; 98
 sbc c                          ; 99
 sbc d                          ; 9A
 sbc e                          ; 9B
 sbc h                          ; 9C
 sbc hl, bc                     ; ED 42
 sbc hl, de                     ; ED 52
 sbc hl, hl                     ; ED 62
 sbc hl, sp                     ; ED 72
 sbc ixh                        ; DD 9C
 sbc ixl                        ; DD 9D
 sbc iyh                        ; FD 9C
 sbc iyl                        ; FD 9D
 sbc l                          ; 9D
 scf                            ; 37
 scf f                          ; 37
 set 0, (hl)                    ; CB C6
 set 0, (ix)                    ; DD CB 00 C6
 set 0, (ix+127)                ; DD CB 7F C6
 set 0, (ix-128)                ; DD CB 80 C6
 set 0, (iy)                    ; FD CB 00 C6
 set 0, (iy+127)                ; FD CB 7F C6
 set 0, (iy-128)                ; FD CB 80 C6
 set 0, a                       ; CB C7
 set 0, b                       ; CB C0
 set 0, c                       ; CB C1
 set 0, d                       ; CB C2
 set 0, e                       ; CB C3
 set 0, h                       ; CB C4
 set 0, ixh                     ; DD CB C4
 set 0, ixl                     ; DD CB C5
 set 0, iyh                     ; FD CB C4
 set 0, iyl                     ; FD CB C5
 set 0, l                       ; CB C5
 set 1, (hl)                    ; CB CE
 set 1, (ix)                    ; DD CB 00 CE
 set 1, (ix+127)                ; DD CB 7F CE
 set 1, (ix-128)                ; DD CB 80 CE
 set 1, (iy)                    ; FD CB 00 CE
 set 1, (iy+127)                ; FD CB 7F CE
 set 1, (iy-128)                ; FD CB 80 CE
 set 1, a                       ; CB CF
 set 1, b                       ; CB C8
 set 1, c                       ; CB C9
 set 1, d                       ; CB CA
 set 1, e                       ; CB CB
 set 1, h                       ; CB CC
 set 1, ixh                     ; DD CB CC
 set 1, ixl                     ; DD CB CD
 set 1, iyh                     ; FD CB CC
 set 1, iyl                     ; FD CB CD
 set 1, l                       ; CB CD
 set 2, (hl)                    ; CB D6
 set 2, (ix)                    ; DD CB 00 D6
 set 2, (ix+127)                ; DD CB 7F D6
 set 2, (ix-128)                ; DD CB 80 D6
 set 2, (iy)                    ; FD CB 00 D6
 set 2, (iy+127)                ; FD CB 7F D6
 set 2, (iy-128)                ; FD CB 80 D6
 set 2, a                       ; CB D7
 set 2, b                       ; CB D0
 set 2, c                       ; CB D1
 set 2, d                       ; CB D2
 set 2, e                       ; CB D3
 set 2, h                       ; CB D4
 set 2, ixh                     ; DD CB D4
 set 2, ixl                     ; DD CB D5
 set 2, iyh                     ; FD CB D4
 set 2, iyl                     ; FD CB D5
 set 2, l                       ; CB D5
 set 3, (hl)                    ; CB DE
 set 3, (ix)                    ; DD CB 00 DE
 set 3, (ix+127)                ; DD CB 7F DE
 set 3, (ix-128)                ; DD CB 80 DE
 set 3, (iy)                    ; FD CB 00 DE
 set 3, (iy+127)                ; FD CB 7F DE
 set 3, (iy-128)                ; FD CB 80 DE
 set 3, a                       ; CB DF
 set 3, b                       ; CB D8
 set 3, c                       ; CB D9
 set 3, d                       ; CB DA
 set 3, e                       ; CB DB
 set 3, h                       ; CB DC
 set 3, ixh                     ; DD CB DC
 set 3, ixl                     ; DD CB DD
 set 3, iyh                     ; FD CB DC
 set 3, iyl                     ; FD CB DD
 set 3, l                       ; CB DD
 set 4, (hl)                    ; CB E6
 set 4, (ix)                    ; DD CB 00 E6
 set 4, (ix+127)                ; DD CB 7F E6
 set 4, (ix-128)                ; DD CB 80 E6
 set 4, (iy)                    ; FD CB 00 E6
 set 4, (iy+127)                ; FD CB 7F E6
 set 4, (iy-128)                ; FD CB 80 E6
 set 4, a                       ; CB E7
 set 4, b                       ; CB E0
 set 4, c                       ; CB E1
 set 4, d                       ; CB E2
 set 4, e                       ; CB E3
 set 4, h                       ; CB E4
 set 4, ixh                     ; DD CB E4
 set 4, ixl                     ; DD CB E5
 set 4, iyh                     ; FD CB E4
 set 4, iyl                     ; FD CB E5
 set 4, l                       ; CB E5
 set 5, (hl)                    ; CB EE
 set 5, (ix)                    ; DD CB 00 EE
 set 5, (ix+127)                ; DD CB 7F EE
 set 5, (ix-128)                ; DD CB 80 EE
 set 5, (iy)                    ; FD CB 00 EE
 set 5, (iy+127)                ; FD CB 7F EE
 set 5, (iy-128)                ; FD CB 80 EE
 set 5, a                       ; CB EF
 set 5, b                       ; CB E8
 set 5, c                       ; CB E9
 set 5, d                       ; CB EA
 set 5, e                       ; CB EB
 set 5, h                       ; CB EC
 set 5, ixh                     ; DD CB EC
 set 5, ixl                     ; DD CB ED
 set 5, iyh                     ; FD CB EC
 set 5, iyl                     ; FD CB ED
 set 5, l                       ; CB ED
 set 6, (hl)                    ; CB F6
 set 6, (ix)                    ; DD CB 00 F6
 set 6, (ix+127)                ; DD CB 7F F6
 set 6, (ix-128)                ; DD CB 80 F6
 set 6, (iy)                    ; FD CB 00 F6
 set 6, (iy+127)                ; FD CB 7F F6
 set 6, (iy-128)                ; FD CB 80 F6
 set 6, a                       ; CB F7
 set 6, b                       ; CB F0
 set 6, c                       ; CB F1
 set 6, d                       ; CB F2
 set 6, e                       ; CB F3
 set 6, h                       ; CB F4
 set 6, ixh                     ; DD CB F4
 set 6, ixl                     ; DD CB F5
 set 6, iyh                     ; FD CB F4
 set 6, iyl                     ; FD CB F5
 set 6, l                       ; CB F5
 set 7, (hl)                    ; CB FE
 set 7, (ix)                    ; DD CB 00 FE
 set 7, (ix+127)                ; DD CB 7F FE
 set 7, (ix-128)                ; DD CB 80 FE
 set 7, (iy)                    ; FD CB 00 FE
 set 7, (iy+127)                ; FD CB 7F FE
 set 7, (iy-128)                ; FD CB 80 FE
 set 7, a                       ; CB FF
 set 7, b                       ; CB F8
 set 7, c                       ; CB F9
 set 7, d                       ; CB FA
 set 7, e                       ; CB FB
 set 7, h                       ; CB FC
 set 7, ixh                     ; DD CB FC
 set 7, ixl                     ; DD CB FD
 set 7, iyh                     ; FD CB FC
 set 7, iyl                     ; FD CB FD
 set 7, l                       ; CB FD
 sla (hl)                       ; CB 26
 sla (ix)                       ; DD CB 00 26
 sla (ix), a                    ; DD CB 00 27
 sla (ix), b                    ; DD CB 00 20
 sla (ix), c                    ; DD CB 00 21
 sla (ix), d                    ; DD CB 00 22
 sla (ix), e                    ; DD CB 00 23
 sla (ix), h                    ; DD CB 00 24
 sla (ix), l                    ; DD CB 00 25
 sla (ix+127)                   ; DD CB 7F 26
 sla (ix+127), a                ; DD CB 7F 27
 sla (ix+127), b                ; DD CB 7F 20
 sla (ix+127), c                ; DD CB 7F 21
 sla (ix+127), d                ; DD CB 7F 22
 sla (ix+127), e                ; DD CB 7F 23
 sla (ix+127), h                ; DD CB 7F 24
 sla (ix+127), l                ; DD CB 7F 25
 sla (ix-128)                   ; DD CB 80 26
 sla (ix-128), a                ; DD CB 80 27
 sla (ix-128), b                ; DD CB 80 20
 sla (ix-128), c                ; DD CB 80 21
 sla (ix-128), d                ; DD CB 80 22
 sla (ix-128), e                ; DD CB 80 23
 sla (ix-128), h                ; DD CB 80 24
 sla (ix-128), l                ; DD CB 80 25
 sla (iy)                       ; FD CB 00 26
 sla (iy), a                    ; FD CB 00 27
 sla (iy), b                    ; FD CB 00 20
 sla (iy), c                    ; FD CB 00 21
 sla (iy), d                    ; FD CB 00 22
 sla (iy), e                    ; FD CB 00 23
 sla (iy), h                    ; FD CB 00 24
 sla (iy), l                    ; FD CB 00 25
 sla (iy+127)                   ; FD CB 7F 26
 sla (iy+127), a                ; FD CB 7F 27
 sla (iy+127), b                ; FD CB 7F 20
 sla (iy+127), c                ; FD CB 7F 21
 sla (iy+127), d                ; FD CB 7F 22
 sla (iy+127), e                ; FD CB 7F 23
 sla (iy+127), h                ; FD CB 7F 24
 sla (iy+127), l                ; FD CB 7F 25
 sla (iy-128)                   ; FD CB 80 26
 sla (iy-128), a                ; FD CB 80 27
 sla (iy-128), b                ; FD CB 80 20
 sla (iy-128), c                ; FD CB 80 21
 sla (iy-128), d                ; FD CB 80 22
 sla (iy-128), e                ; FD CB 80 23
 sla (iy-128), h                ; FD CB 80 24
 sla (iy-128), l                ; FD CB 80 25
 sla a                          ; CB 27
 sla b                          ; CB 20
 sla c                          ; CB 21
 sla d                          ; CB 22
 sla e                          ; CB 23
 sla h                          ; CB 24
 sla ixh                        ; DD CB 24
 sla ixl                        ; DD CB 25
 sla iyh                        ; FD CB 24
 sla iyl                        ; FD CB 25
 sla l                          ; CB 25
 sli (hl)                       ; CB 36
 sli (ix)                       ; DD CB 00 36
 sli (ix), a                    ; DD CB 00 37
 sli (ix), b                    ; DD CB 00 30
 sli (ix), c                    ; DD CB 00 31
 sli (ix), d                    ; DD CB 00 32
 sli (ix), e                    ; DD CB 00 33
 sli (ix), h                    ; DD CB 00 34
 sli (ix), l                    ; DD CB 00 35
 sli (ix+127)                   ; DD CB 7F 36
 sli (ix+127), a                ; DD CB 7F 37
 sli (ix+127), b                ; DD CB 7F 30
 sli (ix+127), c                ; DD CB 7F 31
 sli (ix+127), d                ; DD CB 7F 32
 sli (ix+127), e                ; DD CB 7F 33
 sli (ix+127), h                ; DD CB 7F 34
 sli (ix+127), l                ; DD CB 7F 35
 sli (ix-128)                   ; DD CB 80 36
 sli (ix-128), a                ; DD CB 80 37
 sli (ix-128), b                ; DD CB 80 30
 sli (ix-128), c                ; DD CB 80 31
 sli (ix-128), d                ; DD CB 80 32
 sli (ix-128), e                ; DD CB 80 33
 sli (ix-128), h                ; DD CB 80 34
 sli (ix-128), l                ; DD CB 80 35
 sli (iy)                       ; FD CB 00 36
 sli (iy), a                    ; FD CB 00 37
 sli (iy), b                    ; FD CB 00 30
 sli (iy), c                    ; FD CB 00 31
 sli (iy), d                    ; FD CB 00 32
 sli (iy), e                    ; FD CB 00 33
 sli (iy), h                    ; FD CB 00 34
 sli (iy), l                    ; FD CB 00 35
 sli (iy+127)                   ; FD CB 7F 36
 sli (iy+127), a                ; FD CB 7F 37
 sli (iy+127), b                ; FD CB 7F 30
 sli (iy+127), c                ; FD CB 7F 31
 sli (iy+127), d                ; FD CB 7F 32
 sli (iy+127), e                ; FD CB 7F 33
 sli (iy+127), h                ; FD CB 7F 34
 sli (iy+127), l                ; FD CB 7F 35
 sli (iy-128)                   ; FD CB 80 36
 sli (iy-128), a                ; FD CB 80 37
 sli (iy-128), b                ; FD CB 80 30
 sli (iy-128), c                ; FD CB 80 31
 sli (iy-128), d                ; FD CB 80 32
 sli (iy-128), e                ; FD CB 80 33
 sli (iy-128), h                ; FD CB 80 34
 sli (iy-128), l                ; FD CB 80 35
 sli a                          ; CB 37
 sli b                          ; CB 30
 sli c                          ; CB 31
 sli d                          ; CB 32
 sli e                          ; CB 33
 sli h                          ; CB 34
 sli ixh                        ; DD CB 34
 sli ixl                        ; DD CB 35
 sli iyh                        ; FD CB 34
 sli iyl                        ; FD CB 35
 sli l                          ; CB 35
 sll (hl)                       ; CB 36
 sll (ix)                       ; DD CB 00 36
 sll (ix), a                    ; DD CB 00 37
 sll (ix), b                    ; DD CB 00 30
 sll (ix), c                    ; DD CB 00 31
 sll (ix), d                    ; DD CB 00 32
 sll (ix), e                    ; DD CB 00 33
 sll (ix), h                    ; DD CB 00 34
 sll (ix), l                    ; DD CB 00 35
 sll (ix+127)                   ; DD CB 7F 36
 sll (ix+127), a                ; DD CB 7F 37
 sll (ix+127), b                ; DD CB 7F 30
 sll (ix+127), c                ; DD CB 7F 31
 sll (ix+127), d                ; DD CB 7F 32
 sll (ix+127), e                ; DD CB 7F 33
 sll (ix+127), h                ; DD CB 7F 34
 sll (ix+127), l                ; DD CB 7F 35
 sll (ix-128)                   ; DD CB 80 36
 sll (ix-128), a                ; DD CB 80 37
 sll (ix-128), b                ; DD CB 80 30
 sll (ix-128), c                ; DD CB 80 31
 sll (ix-128), d                ; DD CB 80 32
 sll (ix-128), e                ; DD CB 80 33
 sll (ix-128), h                ; DD CB 80 34
 sll (ix-128), l                ; DD CB 80 35
 sll (iy)                       ; FD CB 00 36
 sll (iy), a                    ; FD CB 00 37
 sll (iy), b                    ; FD CB 00 30
 sll (iy), c                    ; FD CB 00 31
 sll (iy), d                    ; FD CB 00 32
 sll (iy), e                    ; FD CB 00 33
 sll (iy), h                    ; FD CB 00 34
 sll (iy), l                    ; FD CB 00 35
 sll (iy+127)                   ; FD CB 7F 36
 sll (iy+127), a                ; FD CB 7F 37
 sll (iy+127), b                ; FD CB 7F 30
 sll (iy+127), c                ; FD CB 7F 31
 sll (iy+127), d                ; FD CB 7F 32
 sll (iy+127), e                ; FD CB 7F 33
 sll (iy+127), h                ; FD CB 7F 34
 sll (iy+127), l                ; FD CB 7F 35
 sll (iy-128)                   ; FD CB 80 36
 sll (iy-128), a                ; FD CB 80 37
 sll (iy-128), b                ; FD CB 80 30
 sll (iy-128), c                ; FD CB 80 31
 sll (iy-128), d                ; FD CB 80 32
 sll (iy-128), e                ; FD CB 80 33
 sll (iy-128), h                ; FD CB 80 34
 sll (iy-128), l                ; FD CB 80 35
 sll a                          ; CB 37
 sll b                          ; CB 30
 sll c                          ; CB 31
 sll d                          ; CB 32
 sll e                          ; CB 33
 sll h                          ; CB 34
 sll ixh                        ; DD CB 34
 sll ixl                        ; DD CB 35
 sll iyh                        ; FD CB 34
 sll iyl                        ; FD CB 35
 sll l                          ; CB 35
 sra (hl)                       ; CB 2E
 sra (ix)                       ; DD CB 00 2E
 sra (ix), a                    ; DD CB 00 2F
 sra (ix), b                    ; DD CB 00 28
 sra (ix), c                    ; DD CB 00 29
 sra (ix), d                    ; DD CB 00 2A
 sra (ix), e                    ; DD CB 00 2B
 sra (ix), h                    ; DD CB 00 2C
 sra (ix), l                    ; DD CB 00 2D
 sra (ix+127)                   ; DD CB 7F 2E
 sra (ix+127), a                ; DD CB 7F 2F
 sra (ix+127), b                ; DD CB 7F 28
 sra (ix+127), c                ; DD CB 7F 29
 sra (ix+127), d                ; DD CB 7F 2A
 sra (ix+127), e                ; DD CB 7F 2B
 sra (ix+127), h                ; DD CB 7F 2C
 sra (ix+127), l                ; DD CB 7F 2D
 sra (ix-128)                   ; DD CB 80 2E
 sra (ix-128), a                ; DD CB 80 2F
 sra (ix-128), b                ; DD CB 80 28
 sra (ix-128), c                ; DD CB 80 29
 sra (ix-128), d                ; DD CB 80 2A
 sra (ix-128), e                ; DD CB 80 2B
 sra (ix-128), h                ; DD CB 80 2C
 sra (ix-128), l                ; DD CB 80 2D
 sra (iy)                       ; FD CB 00 2E
 sra (iy), a                    ; FD CB 00 2F
 sra (iy), b                    ; FD CB 00 28
 sra (iy), c                    ; FD CB 00 29
 sra (iy), d                    ; FD CB 00 2A
 sra (iy), e                    ; FD CB 00 2B
 sra (iy), h                    ; FD CB 00 2C
 sra (iy), l                    ; FD CB 00 2D
 sra (iy+127)                   ; FD CB 7F 2E
 sra (iy+127), a                ; FD CB 7F 2F
 sra (iy+127), b                ; FD CB 7F 28
 sra (iy+127), c                ; FD CB 7F 29
 sra (iy+127), d                ; FD CB 7F 2A
 sra (iy+127), e                ; FD CB 7F 2B
 sra (iy+127), h                ; FD CB 7F 2C
 sra (iy+127), l                ; FD CB 7F 2D
 sra (iy-128)                   ; FD CB 80 2E
 sra (iy-128), a                ; FD CB 80 2F
 sra (iy-128), b                ; FD CB 80 28
 sra (iy-128), c                ; FD CB 80 29
 sra (iy-128), d                ; FD CB 80 2A
 sra (iy-128), e                ; FD CB 80 2B
 sra (iy-128), h                ; FD CB 80 2C
 sra (iy-128), l                ; FD CB 80 2D
 sra a                          ; CB 2F
 sra b                          ; CB 28
 sra c                          ; CB 29
 sra d                          ; CB 2A
 sra e                          ; CB 2B
 sra h                          ; CB 2C
 sra ixh                        ; DD CB 2C
 sra ixl                        ; DD CB 2D
 sra iyh                        ; FD CB 2C
 sra iyl                        ; FD CB 2D
 sra l                          ; CB 2D
 srl (hl)                       ; CB 3E
 srl (ix)                       ; DD CB 00 3E
 srl (ix), a                    ; DD CB 00 3F
 srl (ix), b                    ; DD CB 00 38
 srl (ix), c                    ; DD CB 00 39
 srl (ix), d                    ; DD CB 00 3A
 srl (ix), e                    ; DD CB 00 3B
 srl (ix), h                    ; DD CB 00 3C
 srl (ix), l                    ; DD CB 00 3D
 srl (ix+127)                   ; DD CB 7F 3E
 srl (ix+127), a                ; DD CB 7F 3F
 srl (ix+127), b                ; DD CB 7F 38
 srl (ix+127), c                ; DD CB 7F 39
 srl (ix+127), d                ; DD CB 7F 3A
 srl (ix+127), e                ; DD CB 7F 3B
 srl (ix+127), h                ; DD CB 7F 3C
 srl (ix+127), l                ; DD CB 7F 3D
 srl (ix-128)                   ; DD CB 80 3E
 srl (ix-128), a                ; DD CB 80 3F
 srl (ix-128), b                ; DD CB 80 38
 srl (ix-128), c                ; DD CB 80 39
 srl (ix-128), d                ; DD CB 80 3A
 srl (ix-128), e                ; DD CB 80 3B
 srl (ix-128), h                ; DD CB 80 3C
 srl (ix-128), l                ; DD CB 80 3D
 srl (iy)                       ; FD CB 00 3E
 srl (iy), a                    ; FD CB 00 3F
 srl (iy), b                    ; FD CB 00 38
 srl (iy), c                    ; FD CB 00 39
 srl (iy), d                    ; FD CB 00 3A
 srl (iy), e                    ; FD CB 00 3B
 srl (iy), h                    ; FD CB 00 3C
 srl (iy), l                    ; FD CB 00 3D
 srl (iy+127)                   ; FD CB 7F 3E
 srl (iy+127), a                ; FD CB 7F 3F
 srl (iy+127), b                ; FD CB 7F 38
 srl (iy+127), c                ; FD CB 7F 39
 srl (iy+127), d                ; FD CB 7F 3A
 srl (iy+127), e                ; FD CB 7F 3B
 srl (iy+127), h                ; FD CB 7F 3C
 srl (iy+127), l                ; FD CB 7F 3D
 srl (iy-128)                   ; FD CB 80 3E
 srl (iy-128), a                ; FD CB 80 3F
 srl (iy-128), b                ; FD CB 80 38
 srl (iy-128), c                ; FD CB 80 39
 srl (iy-128), d                ; FD CB 80 3A
 srl (iy-128), e                ; FD CB 80 3B
 srl (iy-128), h                ; FD CB 80 3C
 srl (iy-128), l                ; FD CB 80 3D
 srl a                          ; CB 3F
 srl b                          ; CB 38
 srl c                          ; CB 39
 srl d                          ; CB 3A
 srl e                          ; CB 3B
 srl h                          ; CB 3C
 srl ixh                        ; DD CB 3C
 srl ixl                        ; DD CB 3D
 srl iyh                        ; FD CB 3C
 srl iyl                        ; FD CB 3D
 srl l                          ; CB 3D
 sub (hl)                       ; 96
 sub (ix)                       ; DD 96 00
 sub (ix+127)                   ; DD 96 7F
 sub (ix-128)                   ; DD 96 80
 sub (iy)                       ; FD 96 00
 sub (iy+127)                   ; FD 96 7F
 sub (iy-128)                   ; FD 96 80
 sub -128                       ; D6 80
 sub 127                        ; D6 7F
 sub 255                        ; D6 FF
 sub a                          ; 97
 sub a, (hl)                    ; 96
 sub a, (ix)                    ; DD 96 00
 sub a, (ix+127)                ; DD 96 7F
 sub a, (ix-128)                ; DD 96 80
 sub a, (iy)                    ; FD 96 00
 sub a, (iy+127)                ; FD 96 7F
 sub a, (iy-128)                ; FD 96 80
 sub a, -128                    ; D6 80
 sub a, 127                     ; D6 7F
 sub a, 255                     ; D6 FF
 sub a, a                       ; 97
 sub a, b                       ; 90
 sub a, c                       ; 91
 sub a, d                       ; 92
 sub a, e                       ; 93
 sub a, h                       ; 94
 sub a, ixh                     ; DD 94
 sub a, ixl                     ; DD 95
 sub a, iyh                     ; FD 94
 sub a, iyl                     ; FD 95
 sub a, l                       ; 95
 sub b                          ; 90
 sub c                          ; 91
 sub d                          ; 92
 sub e                          ; 93
 sub h                          ; 94
 sub ixh                        ; DD 94
 sub ixl                        ; DD 95
 sub iyh                        ; FD 94
 sub iyl                        ; FD 95
 sub l                          ; 95
 xor (hl)                       ; AE
 xor (ix)                       ; DD AE 00
 xor (ix+127)                   ; DD AE 7F
 xor (ix-128)                   ; DD AE 80
 xor (iy)                       ; FD AE 00
 xor (iy+127)                   ; FD AE 7F
 xor (iy-128)                   ; FD AE 80
 xor -128                       ; EE 80
 xor 127                        ; EE 7F
 xor 255                        ; EE FF
 xor a                          ; AF
 xor a, (hl)                    ; AE
 xor a, (ix)                    ; DD AE 00
 xor a, (ix+127)                ; DD AE 7F
 xor a, (ix-128)                ; DD AE 80
 xor a, (iy)                    ; FD AE 00
 xor a, (iy+127)                ; FD AE 7F
 xor a, (iy-128)                ; FD AE 80
 xor a, -128                    ; EE 80
 xor a, 127                     ; EE 7F
 xor a, 255                     ; EE FF
 xor a, a                       ; AF
 xor a, b                       ; A8
 xor a, c                       ; A9
 xor a, d                       ; AA
 xor a, e                       ; AB
 xor a, h                       ; AC
 xor a, ixh                     ; DD AC
 xor a, ixl                     ; DD AD
 xor a, iyh                     ; FD AC
 xor a, iyl                     ; FD AD
 xor a, l                       ; AD
 xor b                          ; A8
 xor c                          ; A9
 xor d                          ; AA
 xor e                          ; AB
 xor h                          ; AC
 xor ixh                        ; DD AC
 xor ixl                        ; DD AD
 xor iyh                        ; FD AC
 xor iyl                        ; FD AD
 xor l                          ; AD
