 adc a, (hl)                    ; 8E
 adc a, (ix)                    ; FD 8E 00
 adc a, (ix+0)                  ; FD 8E 00
 adc a, (ix+126)                ; FD 8E 7E
 adc a, (ix-128)                ; FD 8E 80
 adc a, (iy)                    ; DD 8E 00
 adc a, (iy+0)                  ; DD 8E 00
 adc a, (iy+126)                ; DD 8E 7E
 adc a, (iy-128)                ; DD 8E 80
 adc a, 0                       ; CE 00
 adc a, 127                     ; CE 7F
 adc a, 255                     ; CE FF
 adc a, a                       ; 8F
 adc a, b                       ; 88
 adc a, c                       ; 89
 adc a, d                       ; 8A
 adc a, e                       ; 8B
 adc a, h                       ; 8C
 adc a, ixh                     ; FD 8C
 adc a, ixl                     ; FD 8D
 adc a, iyh                     ; DD 8C
 adc a, iyl                     ; DD 8D
 adc a, l                       ; 8D
 adc hl, bc                     ; ED 4A
 adc hl, de                     ; ED 5A
 adc hl, hl                     ; ED 6A
 adc hl, sp                     ; ED 7A
 add a, (hl)                    ; 86
 add a, (ix)                    ; FD 86 00
 add a, (ix+0)                  ; FD 86 00
 add a, (ix+126)                ; FD 86 7E
 add a, (ix-128)                ; FD 86 80
 add a, (iy)                    ; DD 86 00
 add a, (iy+0)                  ; DD 86 00
 add a, (iy+126)                ; DD 86 7E
 add a, (iy-128)                ; DD 86 80
 add a, 0                       ; C6 00
 add a, 127                     ; C6 7F
 add a, 255                     ; C6 FF
 add a, a                       ; 87
 add a, b                       ; 80
 add a, c                       ; 81
 add a, d                       ; 82
 add a, e                       ; 83
 add a, h                       ; 84
 add a, ixh                     ; FD 84
 add a, ixl                     ; FD 85
 add a, iyh                     ; DD 84
 add a, iyl                     ; DD 85
 add a, l                       ; 85
 add bc, 0x1234                 ; ED 36 34 12
 add bc, a                      ; ED 33
 add de, 0x1234                 ; ED 35 34 12
 add de, a                      ; ED 32
 add hl, 0x1234                 ; ED 34 34 12
 add hl, a                      ; ED 31
 add hl, bc                     ; 09
 add hl, de                     ; 19
 add hl, hl                     ; 29
 add hl, sp                     ; 39
 add ix, bc                     ; FD 09
 add ix, de                     ; FD 19
 add ix, ix                     ; FD 29
 add ix, sp                     ; FD 39
 add iy, bc                     ; DD 09
 add iy, de                     ; DD 19
 add iy, iy                     ; DD 29
 add iy, sp                     ; DD 39
 and (hl)                       ; A6
 and (ix)                       ; FD A6 00
 and (ix+0)                     ; FD A6 00
 and (ix+126)                   ; FD A6 7E
 and (ix-128)                   ; FD A6 80
 and (iy)                       ; DD A6 00
 and (iy+0)                     ; DD A6 00
 and (iy+126)                   ; DD A6 7E
 and (iy-128)                   ; DD A6 80
 and 0                          ; E6 00
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; A7
 and b                          ; A0
 and c                          ; A1
 and d                          ; A2
 and e                          ; A3
 and h                          ; A4
 and ixh                        ; FD A4
 and ixl                        ; FD A5
 and iyh                        ; DD A4
 and iyl                        ; DD A5
 and l                          ; A5
 bit 0, (hl)                    ; CB 46
 bit 0, (ix)                    ; FD CB 00 46
 bit 0, (ix+0)                  ; FD CB 00 46
 bit 0, (ix+126)                ; FD CB 7E 46
 bit 0, (ix-128)                ; FD CB 80 46
 bit 0, (iy)                    ; DD CB 00 46
 bit 0, (iy+0)                  ; DD CB 00 46
 bit 0, (iy+126)                ; DD CB 7E 46
 bit 0, (iy-128)                ; DD CB 80 46
 bit 0, a                       ; CB 47
 bit 0, b                       ; CB 40
 bit 0, c                       ; CB 41
 bit 0, d                       ; CB 42
 bit 0, e                       ; CB 43
 bit 0, h                       ; CB 44
 bit 0, l                       ; CB 45
 bit 1, (hl)                    ; CB 4E
 bit 1, (ix)                    ; FD CB 00 4E
 bit 1, (ix+0)                  ; FD CB 00 4E
 bit 1, (ix+126)                ; FD CB 7E 4E
 bit 1, (ix-128)                ; FD CB 80 4E
 bit 1, (iy)                    ; DD CB 00 4E
 bit 1, (iy+0)                  ; DD CB 00 4E
 bit 1, (iy+126)                ; DD CB 7E 4E
 bit 1, (iy-128)                ; DD CB 80 4E
 bit 1, a                       ; CB 4F
 bit 1, b                       ; CB 48
 bit 1, c                       ; CB 49
 bit 1, d                       ; CB 4A
 bit 1, e                       ; CB 4B
 bit 1, h                       ; CB 4C
 bit 1, l                       ; CB 4D
 bit 2, (hl)                    ; CB 56
 bit 2, (ix)                    ; FD CB 00 56
 bit 2, (ix+0)                  ; FD CB 00 56
 bit 2, (ix+126)                ; FD CB 7E 56
 bit 2, (ix-128)                ; FD CB 80 56
 bit 2, (iy)                    ; DD CB 00 56
 bit 2, (iy+0)                  ; DD CB 00 56
 bit 2, (iy+126)                ; DD CB 7E 56
 bit 2, (iy-128)                ; DD CB 80 56
 bit 2, a                       ; CB 57
 bit 2, b                       ; CB 50
 bit 2, c                       ; CB 51
 bit 2, d                       ; CB 52
 bit 2, e                       ; CB 53
 bit 2, h                       ; CB 54
 bit 2, l                       ; CB 55
 bit 3, (hl)                    ; CB 5E
 bit 3, (ix)                    ; FD CB 00 5E
 bit 3, (ix+0)                  ; FD CB 00 5E
 bit 3, (ix+126)                ; FD CB 7E 5E
 bit 3, (ix-128)                ; FD CB 80 5E
 bit 3, (iy)                    ; DD CB 00 5E
 bit 3, (iy+0)                  ; DD CB 00 5E
 bit 3, (iy+126)                ; DD CB 7E 5E
 bit 3, (iy-128)                ; DD CB 80 5E
 bit 3, a                       ; CB 5F
 bit 3, b                       ; CB 58
 bit 3, c                       ; CB 59
 bit 3, d                       ; CB 5A
 bit 3, e                       ; CB 5B
 bit 3, h                       ; CB 5C
 bit 3, l                       ; CB 5D
 bit 4, (hl)                    ; CB 66
 bit 4, (ix)                    ; FD CB 00 66
 bit 4, (ix+0)                  ; FD CB 00 66
 bit 4, (ix+126)                ; FD CB 7E 66
 bit 4, (ix-128)                ; FD CB 80 66
 bit 4, (iy)                    ; DD CB 00 66
 bit 4, (iy+0)                  ; DD CB 00 66
 bit 4, (iy+126)                ; DD CB 7E 66
 bit 4, (iy-128)                ; DD CB 80 66
 bit 4, a                       ; CB 67
 bit 4, b                       ; CB 60
 bit 4, c                       ; CB 61
 bit 4, d                       ; CB 62
 bit 4, e                       ; CB 63
 bit 4, h                       ; CB 64
 bit 4, l                       ; CB 65
 bit 5, (hl)                    ; CB 6E
 bit 5, (ix)                    ; FD CB 00 6E
 bit 5, (ix+0)                  ; FD CB 00 6E
 bit 5, (ix+126)                ; FD CB 7E 6E
 bit 5, (ix-128)                ; FD CB 80 6E
 bit 5, (iy)                    ; DD CB 00 6E
 bit 5, (iy+0)                  ; DD CB 00 6E
 bit 5, (iy+126)                ; DD CB 7E 6E
 bit 5, (iy-128)                ; DD CB 80 6E
 bit 5, a                       ; CB 6F
 bit 5, b                       ; CB 68
 bit 5, c                       ; CB 69
 bit 5, d                       ; CB 6A
 bit 5, e                       ; CB 6B
 bit 5, h                       ; CB 6C
 bit 5, l                       ; CB 6D
 bit 6, (hl)                    ; CB 76
 bit 6, (ix)                    ; FD CB 00 76
 bit 6, (ix+0)                  ; FD CB 00 76
 bit 6, (ix+126)                ; FD CB 7E 76
 bit 6, (ix-128)                ; FD CB 80 76
 bit 6, (iy)                    ; DD CB 00 76
 bit 6, (iy+0)                  ; DD CB 00 76
 bit 6, (iy+126)                ; DD CB 7E 76
 bit 6, (iy-128)                ; DD CB 80 76
 bit 6, a                       ; CB 77
 bit 6, b                       ; CB 70
 bit 6, c                       ; CB 71
 bit 6, d                       ; CB 72
 bit 6, e                       ; CB 73
 bit 6, h                       ; CB 74
 bit 6, l                       ; CB 75
 bit 7, (hl)                    ; CB 7E
 bit 7, (ix)                    ; FD CB 00 7E
 bit 7, (ix+0)                  ; FD CB 00 7E
 bit 7, (ix+126)                ; FD CB 7E 7E
 bit 7, (ix-128)                ; FD CB 80 7E
 bit 7, (iy)                    ; DD CB 00 7E
 bit 7, (iy+0)                  ; DD CB 00 7E
 bit 7, (iy+126)                ; DD CB 7E 7E
 bit 7, (iy-128)                ; DD CB 80 7E
 bit 7, a                       ; CB 7F
 bit 7, b                       ; CB 78
 bit 7, c                       ; CB 79
 bit 7, d                       ; CB 7A
 bit 7, e                       ; CB 7B
 bit 7, h                       ; CB 7C
 bit 7, l                       ; CB 7D
 brlc de, b                     ; ED 2C
 bsla de, b                     ; ED 28
 bsra de, b                     ; ED 29
 bsrf de, b                     ; ED 2B
 bsrl de, b                     ; ED 2A
 call 0x1234                    ; CD 34 12
 call c, 0x1234                 ; DC 34 12
 call m, 0x1234                 ; FC 34 12
 call nc, 0x1234                ; D4 34 12
 call nz, 0x1234                ; C4 34 12
 call p, 0x1234                 ; F4 34 12
 call pe, 0x1234                ; EC 34 12
 call po, 0x1234                ; E4 34 12
 call z, 0x1234                 ; CC 34 12
 ccf                            ; 3F
 cp (hl)                        ; BE
 cp (ix)                        ; FD BE 00
 cp (ix+0)                      ; FD BE 00
 cp (ix+126)                    ; FD BE 7E
 cp (ix-128)                    ; FD BE 80
 cp (iy)                        ; DD BE 00
 cp (iy+0)                      ; DD BE 00
 cp (iy+126)                    ; DD BE 7E
 cp (iy-128)                    ; DD BE 80
 cp 0                           ; FE 00
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; BF
 cp b                           ; B8
 cp c                           ; B9
 cp d                           ; BA
 cp e                           ; BB
 cp h                           ; BC
 cp ixh                         ; FD BC
 cp ixl                         ; FD BD
 cp iyh                         ; DD BC
 cp iyl                         ; DD BD
 cp l                           ; BD
 cpd                            ; ED A9
 cpdr                           ; ED B9
 cpi                            ; ED A1
 cpir                           ; ED B1
 cpl                            ; 2F
 daa                            ; 27
 dec (hl)                       ; 35
 dec (ix)                       ; FD 35 00
 dec (ix+0)                     ; FD 35 00
 dec (ix+126)                   ; FD 35 7E
 dec (ix-128)                   ; FD 35 80
 dec (iy)                       ; DD 35 00
 dec (iy+0)                     ; DD 35 00
 dec (iy+126)                   ; DD 35 7E
 dec (iy-128)                   ; DD 35 80
 dec a                          ; 3D
 dec b                          ; 05
 dec bc                         ; 0B
 dec c                          ; 0D
 dec d                          ; 15
 dec de                         ; 1B
 dec e                          ; 1D
 dec h                          ; 25
 dec hl                         ; 2B
 dec ix                         ; FD 2B
 dec ixh                        ; FD 25
 dec ixl                        ; FD 2D
 dec iy                         ; DD 2B
 dec iyh                        ; DD 25
 dec iyl                        ; DD 2D
 dec l                          ; 2D
 dec sp                         ; 3B
 di                             ; F3
 djnz ASMPC                     ; 10 FE
 ei                             ; FB
 ex (sp), hl                    ; E3
 ex (sp), ix                    ; FD E3
 ex (sp), iy                    ; DD E3
 ex af, af'                     ; 08
 ex de, hl                      ; EB
 exx                            ; D9
 halt                           ; 76
 im 0                           ; ED 46
 im 1                           ; ED 56
 im 2                           ; ED 5E
 in (bc)                        ; ED 70
 in (c)                         ; ED 70
 in a, (0)                      ; DB 00
 in a, (127)                    ; DB 7F
 in a, (255)                    ; DB FF
 in a, (c)                      ; ED 78
 in b, (c)                      ; ED 40
 in c, (c)                      ; ED 48
 in d, (c)                      ; ED 50
 in e, (c)                      ; ED 58
 in f, (bc)                     ; ED 70
 in f, (c)                      ; ED 70
 in h, (c)                      ; ED 60
 in l, (c)                      ; ED 68
 inc (hl)                       ; 34
 inc (ix)                       ; FD 34 00
 inc (ix+0)                     ; FD 34 00
 inc (ix+126)                   ; FD 34 7E
 inc (ix-128)                   ; FD 34 80
 inc (iy)                       ; DD 34 00
 inc (iy+0)                     ; DD 34 00
 inc (iy+126)                   ; DD 34 7E
 inc (iy-128)                   ; DD 34 80
 inc a                          ; 3C
 inc b                          ; 04
 inc bc                         ; 03
 inc c                          ; 0C
 inc d                          ; 14
 inc de                         ; 13
 inc e                          ; 1C
 inc h                          ; 24
 inc hl                         ; 23
 inc ix                         ; FD 23
 inc ixh                        ; FD 24
 inc ixl                        ; FD 2C
 inc iy                         ; DD 23
 inc iyh                        ; DD 24
 inc iyl                        ; DD 2C
 inc l                          ; 2C
 inc sp                         ; 33
 ind                            ; ED AA
 indr                           ; ED BA
 ini                            ; ED A2
 inir                           ; ED B2
 jp (c)                         ; ED 98
 jp (hl)                        ; E9
 jp (ix)                        ; FD E9
 jp (iy)                        ; DD E9
 jp 0x1234                      ; C3 34 12
 jp c, 0x1234                   ; DA 34 12
 jp m, 0x1234                   ; FA 34 12
 jp nc, 0x1234                  ; D2 34 12
 jp nz, 0x1234                  ; C2 34 12
 jp p, 0x1234                   ; F2 34 12
 jp pe, 0x1234                  ; EA 34 12
 jp po, 0x1234                  ; E2 34 12
 jp z, 0x1234                   ; CA 34 12
 jr ASMPC                       ; 18 FE
 jr c, ASMPC                    ; 38 FE
 jr nc, ASMPC                   ; 30 FE
 jr nz, ASMPC                   ; 20 FE
 jr z, ASMPC                    ; 28 FE
 ld (0x1234), a                 ; 32 34 12
 ld (0x1234), bc                ; ED 43 34 12
 ld (0x1234), de                ; ED 53 34 12
 ld (0x1234), hl                ; 22 34 12
 ld (0x1234), ix                ; FD 22 34 12
 ld (0x1234), iy                ; DD 22 34 12
 ld (0x1234), sp                ; ED 73 34 12
 ld (bc), a                     ; 02
 ld (de), a                     ; 12
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
 ld (ix), 0                     ; FD 36 00 00
 ld (ix), 127                   ; FD 36 00 7F
 ld (ix), 255                   ; FD 36 00 FF
 ld (ix), a                     ; FD 77 00
 ld (ix), b                     ; FD 70 00
 ld (ix), c                     ; FD 71 00
 ld (ix), d                     ; FD 72 00
 ld (ix), e                     ; FD 73 00
 ld (ix), h                     ; FD 74 00
 ld (ix), l                     ; FD 75 00
 ld (ix+0), 0                   ; FD 36 00 00
 ld (ix+0), 127                 ; FD 36 00 7F
 ld (ix+0), 255                 ; FD 36 00 FF
 ld (ix+0), a                   ; FD 77 00
 ld (ix+0), b                   ; FD 70 00
 ld (ix+0), c                   ; FD 71 00
 ld (ix+0), d                   ; FD 72 00
 ld (ix+0), e                   ; FD 73 00
 ld (ix+0), h                   ; FD 74 00
 ld (ix+0), l                   ; FD 75 00
 ld (ix+126), 0                 ; FD 36 7E 00
 ld (ix+126), 127               ; FD 36 7E 7F
 ld (ix+126), 255               ; FD 36 7E FF
 ld (ix+126), a                 ; FD 77 7E
 ld (ix+126), b                 ; FD 70 7E
 ld (ix+126), c                 ; FD 71 7E
 ld (ix+126), d                 ; FD 72 7E
 ld (ix+126), e                 ; FD 73 7E
 ld (ix+126), h                 ; FD 74 7E
 ld (ix+126), l                 ; FD 75 7E
 ld (ix-128), 0                 ; FD 36 80 00
 ld (ix-128), 127               ; FD 36 80 7F
 ld (ix-128), 255               ; FD 36 80 FF
 ld (ix-128), a                 ; FD 77 80
 ld (ix-128), b                 ; FD 70 80
 ld (ix-128), c                 ; FD 71 80
 ld (ix-128), d                 ; FD 72 80
 ld (ix-128), e                 ; FD 73 80
 ld (ix-128), h                 ; FD 74 80
 ld (ix-128), l                 ; FD 75 80
 ld (iy), 0                     ; DD 36 00 00
 ld (iy), 127                   ; DD 36 00 7F
 ld (iy), 255                   ; DD 36 00 FF
 ld (iy), a                     ; DD 77 00
 ld (iy), b                     ; DD 70 00
 ld (iy), c                     ; DD 71 00
 ld (iy), d                     ; DD 72 00
 ld (iy), e                     ; DD 73 00
 ld (iy), h                     ; DD 74 00
 ld (iy), l                     ; DD 75 00
 ld (iy+0), 0                   ; DD 36 00 00
 ld (iy+0), 127                 ; DD 36 00 7F
 ld (iy+0), 255                 ; DD 36 00 FF
 ld (iy+0), a                   ; DD 77 00
 ld (iy+0), b                   ; DD 70 00
 ld (iy+0), c                   ; DD 71 00
 ld (iy+0), d                   ; DD 72 00
 ld (iy+0), e                   ; DD 73 00
 ld (iy+0), h                   ; DD 74 00
 ld (iy+0), l                   ; DD 75 00
 ld (iy+126), 0                 ; DD 36 7E 00
 ld (iy+126), 127               ; DD 36 7E 7F
 ld (iy+126), 255               ; DD 36 7E FF
 ld (iy+126), a                 ; DD 77 7E
 ld (iy+126), b                 ; DD 70 7E
 ld (iy+126), c                 ; DD 71 7E
 ld (iy+126), d                 ; DD 72 7E
 ld (iy+126), e                 ; DD 73 7E
 ld (iy+126), h                 ; DD 74 7E
 ld (iy+126), l                 ; DD 75 7E
 ld (iy-128), 0                 ; DD 36 80 00
 ld (iy-128), 127               ; DD 36 80 7F
 ld (iy-128), 255               ; DD 36 80 FF
 ld (iy-128), a                 ; DD 77 80
 ld (iy-128), b                 ; DD 70 80
 ld (iy-128), c                 ; DD 71 80
 ld (iy-128), d                 ; DD 72 80
 ld (iy-128), e                 ; DD 73 80
 ld (iy-128), h                 ; DD 74 80
 ld (iy-128), l                 ; DD 75 80
 ld a, (0x1234)                 ; 3A 34 12
 ld a, (bc)                     ; 0A
 ld a, (de)                     ; 1A
 ld a, (hl)                     ; 7E
 ld a, (ix)                     ; FD 7E 00
 ld a, (ix+0)                   ; FD 7E 00
 ld a, (ix+126)                 ; FD 7E 7E
 ld a, (ix-128)                 ; FD 7E 80
 ld a, (iy)                     ; DD 7E 00
 ld a, (iy+0)                   ; DD 7E 00
 ld a, (iy+126)                 ; DD 7E 7E
 ld a, (iy-128)                 ; DD 7E 80
 ld a, 0                        ; 3E 00
 ld a, 127                      ; 3E 7F
 ld a, 255                      ; 3E FF
 ld a, a                        ; 7F
 ld a, b                        ; 78
 ld a, c                        ; 79
 ld a, d                        ; 7A
 ld a, e                        ; 7B
 ld a, h                        ; 7C
 ld a, i                        ; ED 57
 ld a, ixh                      ; FD 7C
 ld a, ixl                      ; FD 7D
 ld a, iyh                      ; DD 7C
 ld a, iyl                      ; DD 7D
 ld a, l                        ; 7D
 ld a, r                        ; ED 5F
 ld a, res 0, (ix)              ; FD CB 00 87
 ld a, res 0, (ix+0)            ; FD CB 00 87
 ld a, res 0, (ix+126)          ; FD CB 7E 87
 ld a, res 0, (ix-128)          ; FD CB 80 87
 ld a, res 0, (iy)              ; DD CB 00 87
 ld a, res 0, (iy+0)            ; DD CB 00 87
 ld a, res 0, (iy+126)          ; DD CB 7E 87
 ld a, res 0, (iy-128)          ; DD CB 80 87
 ld a, res 1, (ix)              ; FD CB 00 8F
 ld a, res 1, (ix+0)            ; FD CB 00 8F
 ld a, res 1, (ix+126)          ; FD CB 7E 8F
 ld a, res 1, (ix-128)          ; FD CB 80 8F
 ld a, res 1, (iy)              ; DD CB 00 8F
 ld a, res 1, (iy+0)            ; DD CB 00 8F
 ld a, res 1, (iy+126)          ; DD CB 7E 8F
 ld a, res 1, (iy-128)          ; DD CB 80 8F
 ld a, res 2, (ix)              ; FD CB 00 97
 ld a, res 2, (ix+0)            ; FD CB 00 97
 ld a, res 2, (ix+126)          ; FD CB 7E 97
 ld a, res 2, (ix-128)          ; FD CB 80 97
 ld a, res 2, (iy)              ; DD CB 00 97
 ld a, res 2, (iy+0)            ; DD CB 00 97
 ld a, res 2, (iy+126)          ; DD CB 7E 97
 ld a, res 2, (iy-128)          ; DD CB 80 97
 ld a, res 3, (ix)              ; FD CB 00 9F
 ld a, res 3, (ix+0)            ; FD CB 00 9F
 ld a, res 3, (ix+126)          ; FD CB 7E 9F
 ld a, res 3, (ix-128)          ; FD CB 80 9F
 ld a, res 3, (iy)              ; DD CB 00 9F
 ld a, res 3, (iy+0)            ; DD CB 00 9F
 ld a, res 3, (iy+126)          ; DD CB 7E 9F
 ld a, res 3, (iy-128)          ; DD CB 80 9F
 ld a, res 4, (ix)              ; FD CB 00 A7
 ld a, res 4, (ix+0)            ; FD CB 00 A7
 ld a, res 4, (ix+126)          ; FD CB 7E A7
 ld a, res 4, (ix-128)          ; FD CB 80 A7
 ld a, res 4, (iy)              ; DD CB 00 A7
 ld a, res 4, (iy+0)            ; DD CB 00 A7
 ld a, res 4, (iy+126)          ; DD CB 7E A7
 ld a, res 4, (iy-128)          ; DD CB 80 A7
 ld a, res 5, (ix)              ; FD CB 00 AF
 ld a, res 5, (ix+0)            ; FD CB 00 AF
 ld a, res 5, (ix+126)          ; FD CB 7E AF
 ld a, res 5, (ix-128)          ; FD CB 80 AF
 ld a, res 5, (iy)              ; DD CB 00 AF
 ld a, res 5, (iy+0)            ; DD CB 00 AF
 ld a, res 5, (iy+126)          ; DD CB 7E AF
 ld a, res 5, (iy-128)          ; DD CB 80 AF
 ld a, res 6, (ix)              ; FD CB 00 B7
 ld a, res 6, (ix+0)            ; FD CB 00 B7
 ld a, res 6, (ix+126)          ; FD CB 7E B7
 ld a, res 6, (ix-128)          ; FD CB 80 B7
 ld a, res 6, (iy)              ; DD CB 00 B7
 ld a, res 6, (iy+0)            ; DD CB 00 B7
 ld a, res 6, (iy+126)          ; DD CB 7E B7
 ld a, res 6, (iy-128)          ; DD CB 80 B7
 ld a, res 7, (ix)              ; FD CB 00 BF
 ld a, res 7, (ix+0)            ; FD CB 00 BF
 ld a, res 7, (ix+126)          ; FD CB 7E BF
 ld a, res 7, (ix-128)          ; FD CB 80 BF
 ld a, res 7, (iy)              ; DD CB 00 BF
 ld a, res 7, (iy+0)            ; DD CB 00 BF
 ld a, res 7, (iy+126)          ; DD CB 7E BF
 ld a, res 7, (iy-128)          ; DD CB 80 BF
 ld a, rl (ix)                  ; FD CB 00 17
 ld a, rl (ix+0)                ; FD CB 00 17
 ld a, rl (ix+126)              ; FD CB 7E 17
 ld a, rl (ix-128)              ; FD CB 80 17
 ld a, rl (iy)                  ; DD CB 00 17
 ld a, rl (iy+0)                ; DD CB 00 17
 ld a, rl (iy+126)              ; DD CB 7E 17
 ld a, rl (iy-128)              ; DD CB 80 17
 ld a, rlc (ix)                 ; FD CB 00 07
 ld a, rlc (ix+0)               ; FD CB 00 07
 ld a, rlc (ix+126)             ; FD CB 7E 07
 ld a, rlc (ix-128)             ; FD CB 80 07
 ld a, rlc (iy)                 ; DD CB 00 07
 ld a, rlc (iy+0)               ; DD CB 00 07
 ld a, rlc (iy+126)             ; DD CB 7E 07
 ld a, rlc (iy-128)             ; DD CB 80 07
 ld a, rr (ix)                  ; FD CB 00 1F
 ld a, rr (ix+0)                ; FD CB 00 1F
 ld a, rr (ix+126)              ; FD CB 7E 1F
 ld a, rr (ix-128)              ; FD CB 80 1F
 ld a, rr (iy)                  ; DD CB 00 1F
 ld a, rr (iy+0)                ; DD CB 00 1F
 ld a, rr (iy+126)              ; DD CB 7E 1F
 ld a, rr (iy-128)              ; DD CB 80 1F
 ld a, rrc (ix)                 ; FD CB 00 0F
 ld a, rrc (ix+0)               ; FD CB 00 0F
 ld a, rrc (ix+126)             ; FD CB 7E 0F
 ld a, rrc (ix-128)             ; FD CB 80 0F
 ld a, rrc (iy)                 ; DD CB 00 0F
 ld a, rrc (iy+0)               ; DD CB 00 0F
 ld a, rrc (iy+126)             ; DD CB 7E 0F
 ld a, rrc (iy-128)             ; DD CB 80 0F
 ld a, set 0, (ix)              ; FD CB 00 C7
 ld a, set 0, (ix+0)            ; FD CB 00 C7
 ld a, set 0, (ix+126)          ; FD CB 7E C7
 ld a, set 0, (ix-128)          ; FD CB 80 C7
 ld a, set 0, (iy)              ; DD CB 00 C7
 ld a, set 0, (iy+0)            ; DD CB 00 C7
 ld a, set 0, (iy+126)          ; DD CB 7E C7
 ld a, set 0, (iy-128)          ; DD CB 80 C7
 ld a, set 1, (ix)              ; FD CB 00 CF
 ld a, set 1, (ix+0)            ; FD CB 00 CF
 ld a, set 1, (ix+126)          ; FD CB 7E CF
 ld a, set 1, (ix-128)          ; FD CB 80 CF
 ld a, set 1, (iy)              ; DD CB 00 CF
 ld a, set 1, (iy+0)            ; DD CB 00 CF
 ld a, set 1, (iy+126)          ; DD CB 7E CF
 ld a, set 1, (iy-128)          ; DD CB 80 CF
 ld a, set 2, (ix)              ; FD CB 00 D7
 ld a, set 2, (ix+0)            ; FD CB 00 D7
 ld a, set 2, (ix+126)          ; FD CB 7E D7
 ld a, set 2, (ix-128)          ; FD CB 80 D7
 ld a, set 2, (iy)              ; DD CB 00 D7
 ld a, set 2, (iy+0)            ; DD CB 00 D7
 ld a, set 2, (iy+126)          ; DD CB 7E D7
 ld a, set 2, (iy-128)          ; DD CB 80 D7
 ld a, set 3, (ix)              ; FD CB 00 DF
 ld a, set 3, (ix+0)            ; FD CB 00 DF
 ld a, set 3, (ix+126)          ; FD CB 7E DF
 ld a, set 3, (ix-128)          ; FD CB 80 DF
 ld a, set 3, (iy)              ; DD CB 00 DF
 ld a, set 3, (iy+0)            ; DD CB 00 DF
 ld a, set 3, (iy+126)          ; DD CB 7E DF
 ld a, set 3, (iy-128)          ; DD CB 80 DF
 ld a, set 4, (ix)              ; FD CB 00 E7
 ld a, set 4, (ix+0)            ; FD CB 00 E7
 ld a, set 4, (ix+126)          ; FD CB 7E E7
 ld a, set 4, (ix-128)          ; FD CB 80 E7
 ld a, set 4, (iy)              ; DD CB 00 E7
 ld a, set 4, (iy+0)            ; DD CB 00 E7
 ld a, set 4, (iy+126)          ; DD CB 7E E7
 ld a, set 4, (iy-128)          ; DD CB 80 E7
 ld a, set 5, (ix)              ; FD CB 00 EF
 ld a, set 5, (ix+0)            ; FD CB 00 EF
 ld a, set 5, (ix+126)          ; FD CB 7E EF
 ld a, set 5, (ix-128)          ; FD CB 80 EF
 ld a, set 5, (iy)              ; DD CB 00 EF
 ld a, set 5, (iy+0)            ; DD CB 00 EF
 ld a, set 5, (iy+126)          ; DD CB 7E EF
 ld a, set 5, (iy-128)          ; DD CB 80 EF
 ld a, set 6, (ix)              ; FD CB 00 F7
 ld a, set 6, (ix+0)            ; FD CB 00 F7
 ld a, set 6, (ix+126)          ; FD CB 7E F7
 ld a, set 6, (ix-128)          ; FD CB 80 F7
 ld a, set 6, (iy)              ; DD CB 00 F7
 ld a, set 6, (iy+0)            ; DD CB 00 F7
 ld a, set 6, (iy+126)          ; DD CB 7E F7
 ld a, set 6, (iy-128)          ; DD CB 80 F7
 ld a, set 7, (ix)              ; FD CB 00 FF
 ld a, set 7, (ix+0)            ; FD CB 00 FF
 ld a, set 7, (ix+126)          ; FD CB 7E FF
 ld a, set 7, (ix-128)          ; FD CB 80 FF
 ld a, set 7, (iy)              ; DD CB 00 FF
 ld a, set 7, (iy+0)            ; DD CB 00 FF
 ld a, set 7, (iy+126)          ; DD CB 7E FF
 ld a, set 7, (iy-128)          ; DD CB 80 FF
 ld a, sla (ix)                 ; FD CB 00 27
 ld a, sla (ix+0)               ; FD CB 00 27
 ld a, sla (ix+126)             ; FD CB 7E 27
 ld a, sla (ix-128)             ; FD CB 80 27
 ld a, sla (iy)                 ; DD CB 00 27
 ld a, sla (iy+0)               ; DD CB 00 27
 ld a, sla (iy+126)             ; DD CB 7E 27
 ld a, sla (iy-128)             ; DD CB 80 27
 ld a, sli (ix)                 ; FD CB 00 37
 ld a, sli (ix+0)               ; FD CB 00 37
 ld a, sli (ix+126)             ; FD CB 7E 37
 ld a, sli (ix-128)             ; FD CB 80 37
 ld a, sli (iy)                 ; DD CB 00 37
 ld a, sli (iy+0)               ; DD CB 00 37
 ld a, sli (iy+126)             ; DD CB 7E 37
 ld a, sli (iy-128)             ; DD CB 80 37
 ld a, sll (ix)                 ; FD CB 00 37
 ld a, sll (ix+0)               ; FD CB 00 37
 ld a, sll (ix+126)             ; FD CB 7E 37
 ld a, sll (ix-128)             ; FD CB 80 37
 ld a, sll (iy)                 ; DD CB 00 37
 ld a, sll (iy+0)               ; DD CB 00 37
 ld a, sll (iy+126)             ; DD CB 7E 37
 ld a, sll (iy-128)             ; DD CB 80 37
 ld a, sls (ix)                 ; FD CB 00 37
 ld a, sls (ix+0)               ; FD CB 00 37
 ld a, sls (ix+126)             ; FD CB 7E 37
 ld a, sls (ix-128)             ; FD CB 80 37
 ld a, sls (iy)                 ; DD CB 00 37
 ld a, sls (iy+0)               ; DD CB 00 37
 ld a, sls (iy+126)             ; DD CB 7E 37
 ld a, sls (iy-128)             ; DD CB 80 37
 ld a, sra (ix)                 ; FD CB 00 2F
 ld a, sra (ix+0)               ; FD CB 00 2F
 ld a, sra (ix+126)             ; FD CB 7E 2F
 ld a, sra (ix-128)             ; FD CB 80 2F
 ld a, sra (iy)                 ; DD CB 00 2F
 ld a, sra (iy+0)               ; DD CB 00 2F
 ld a, sra (iy+126)             ; DD CB 7E 2F
 ld a, sra (iy-128)             ; DD CB 80 2F
 ld a, srl (ix)                 ; FD CB 00 3F
 ld a, srl (ix+0)               ; FD CB 00 3F
 ld a, srl (ix+126)             ; FD CB 7E 3F
 ld a, srl (ix-128)             ; FD CB 80 3F
 ld a, srl (iy)                 ; DD CB 00 3F
 ld a, srl (iy+0)               ; DD CB 00 3F
 ld a, srl (iy+126)             ; DD CB 7E 3F
 ld a, srl (iy-128)             ; DD CB 80 3F
 ld b, (hl)                     ; 46
 ld b, (ix)                     ; FD 46 00
 ld b, (ix+0)                   ; FD 46 00
 ld b, (ix+126)                 ; FD 46 7E
 ld b, (ix-128)                 ; FD 46 80
 ld b, (iy)                     ; DD 46 00
 ld b, (iy+0)                   ; DD 46 00
 ld b, (iy+126)                 ; DD 46 7E
 ld b, (iy-128)                 ; DD 46 80
 ld b, 0                        ; 06 00
 ld b, 127                      ; 06 7F
 ld b, 255                      ; 06 FF
 ld b, a                        ; 47
 ld b, b                        ; 40
 ld b, c                        ; 41
 ld b, d                        ; 42
 ld b, e                        ; 43
 ld b, h                        ; 44
 ld b, ixh                      ; FD 44
 ld b, ixl                      ; FD 45
 ld b, iyh                      ; DD 44
 ld b, iyl                      ; DD 45
 ld b, l                        ; 45
 ld b, res 0, (ix)              ; FD CB 00 80
 ld b, res 0, (ix+0)            ; FD CB 00 80
 ld b, res 0, (ix+126)          ; FD CB 7E 80
 ld b, res 0, (ix-128)          ; FD CB 80 80
 ld b, res 0, (iy)              ; DD CB 00 80
 ld b, res 0, (iy+0)            ; DD CB 00 80
 ld b, res 0, (iy+126)          ; DD CB 7E 80
 ld b, res 0, (iy-128)          ; DD CB 80 80
 ld b, res 1, (ix)              ; FD CB 00 88
 ld b, res 1, (ix+0)            ; FD CB 00 88
 ld b, res 1, (ix+126)          ; FD CB 7E 88
 ld b, res 1, (ix-128)          ; FD CB 80 88
 ld b, res 1, (iy)              ; DD CB 00 88
 ld b, res 1, (iy+0)            ; DD CB 00 88
 ld b, res 1, (iy+126)          ; DD CB 7E 88
 ld b, res 1, (iy-128)          ; DD CB 80 88
 ld b, res 2, (ix)              ; FD CB 00 90
 ld b, res 2, (ix+0)            ; FD CB 00 90
 ld b, res 2, (ix+126)          ; FD CB 7E 90
 ld b, res 2, (ix-128)          ; FD CB 80 90
 ld b, res 2, (iy)              ; DD CB 00 90
 ld b, res 2, (iy+0)            ; DD CB 00 90
 ld b, res 2, (iy+126)          ; DD CB 7E 90
 ld b, res 2, (iy-128)          ; DD CB 80 90
 ld b, res 3, (ix)              ; FD CB 00 98
 ld b, res 3, (ix+0)            ; FD CB 00 98
 ld b, res 3, (ix+126)          ; FD CB 7E 98
 ld b, res 3, (ix-128)          ; FD CB 80 98
 ld b, res 3, (iy)              ; DD CB 00 98
 ld b, res 3, (iy+0)            ; DD CB 00 98
 ld b, res 3, (iy+126)          ; DD CB 7E 98
 ld b, res 3, (iy-128)          ; DD CB 80 98
 ld b, res 4, (ix)              ; FD CB 00 A0
 ld b, res 4, (ix+0)            ; FD CB 00 A0
 ld b, res 4, (ix+126)          ; FD CB 7E A0
 ld b, res 4, (ix-128)          ; FD CB 80 A0
 ld b, res 4, (iy)              ; DD CB 00 A0
 ld b, res 4, (iy+0)            ; DD CB 00 A0
 ld b, res 4, (iy+126)          ; DD CB 7E A0
 ld b, res 4, (iy-128)          ; DD CB 80 A0
 ld b, res 5, (ix)              ; FD CB 00 A8
 ld b, res 5, (ix+0)            ; FD CB 00 A8
 ld b, res 5, (ix+126)          ; FD CB 7E A8
 ld b, res 5, (ix-128)          ; FD CB 80 A8
 ld b, res 5, (iy)              ; DD CB 00 A8
 ld b, res 5, (iy+0)            ; DD CB 00 A8
 ld b, res 5, (iy+126)          ; DD CB 7E A8
 ld b, res 5, (iy-128)          ; DD CB 80 A8
 ld b, res 6, (ix)              ; FD CB 00 B0
 ld b, res 6, (ix+0)            ; FD CB 00 B0
 ld b, res 6, (ix+126)          ; FD CB 7E B0
 ld b, res 6, (ix-128)          ; FD CB 80 B0
 ld b, res 6, (iy)              ; DD CB 00 B0
 ld b, res 6, (iy+0)            ; DD CB 00 B0
 ld b, res 6, (iy+126)          ; DD CB 7E B0
 ld b, res 6, (iy-128)          ; DD CB 80 B0
 ld b, res 7, (ix)              ; FD CB 00 B8
 ld b, res 7, (ix+0)            ; FD CB 00 B8
 ld b, res 7, (ix+126)          ; FD CB 7E B8
 ld b, res 7, (ix-128)          ; FD CB 80 B8
 ld b, res 7, (iy)              ; DD CB 00 B8
 ld b, res 7, (iy+0)            ; DD CB 00 B8
 ld b, res 7, (iy+126)          ; DD CB 7E B8
 ld b, res 7, (iy-128)          ; DD CB 80 B8
 ld b, rl (ix)                  ; FD CB 00 10
 ld b, rl (ix+0)                ; FD CB 00 10
 ld b, rl (ix+126)              ; FD CB 7E 10
 ld b, rl (ix-128)              ; FD CB 80 10
 ld b, rl (iy)                  ; DD CB 00 10
 ld b, rl (iy+0)                ; DD CB 00 10
 ld b, rl (iy+126)              ; DD CB 7E 10
 ld b, rl (iy-128)              ; DD CB 80 10
 ld b, rlc (ix)                 ; FD CB 00 00
 ld b, rlc (ix+0)               ; FD CB 00 00
 ld b, rlc (ix+126)             ; FD CB 7E 00
 ld b, rlc (ix-128)             ; FD CB 80 00
 ld b, rlc (iy)                 ; DD CB 00 00
 ld b, rlc (iy+0)               ; DD CB 00 00
 ld b, rlc (iy+126)             ; DD CB 7E 00
 ld b, rlc (iy-128)             ; DD CB 80 00
 ld b, rr (ix)                  ; FD CB 00 18
 ld b, rr (ix+0)                ; FD CB 00 18
 ld b, rr (ix+126)              ; FD CB 7E 18
 ld b, rr (ix-128)              ; FD CB 80 18
 ld b, rr (iy)                  ; DD CB 00 18
 ld b, rr (iy+0)                ; DD CB 00 18
 ld b, rr (iy+126)              ; DD CB 7E 18
 ld b, rr (iy-128)              ; DD CB 80 18
 ld b, rrc (ix)                 ; FD CB 00 08
 ld b, rrc (ix+0)               ; FD CB 00 08
 ld b, rrc (ix+126)             ; FD CB 7E 08
 ld b, rrc (ix-128)             ; FD CB 80 08
 ld b, rrc (iy)                 ; DD CB 00 08
 ld b, rrc (iy+0)               ; DD CB 00 08
 ld b, rrc (iy+126)             ; DD CB 7E 08
 ld b, rrc (iy-128)             ; DD CB 80 08
 ld b, set 0, (ix)              ; FD CB 00 C0
 ld b, set 0, (ix+0)            ; FD CB 00 C0
 ld b, set 0, (ix+126)          ; FD CB 7E C0
 ld b, set 0, (ix-128)          ; FD CB 80 C0
 ld b, set 0, (iy)              ; DD CB 00 C0
 ld b, set 0, (iy+0)            ; DD CB 00 C0
 ld b, set 0, (iy+126)          ; DD CB 7E C0
 ld b, set 0, (iy-128)          ; DD CB 80 C0
 ld b, set 1, (ix)              ; FD CB 00 C8
 ld b, set 1, (ix+0)            ; FD CB 00 C8
 ld b, set 1, (ix+126)          ; FD CB 7E C8
 ld b, set 1, (ix-128)          ; FD CB 80 C8
 ld b, set 1, (iy)              ; DD CB 00 C8
 ld b, set 1, (iy+0)            ; DD CB 00 C8
 ld b, set 1, (iy+126)          ; DD CB 7E C8
 ld b, set 1, (iy-128)          ; DD CB 80 C8
 ld b, set 2, (ix)              ; FD CB 00 D0
 ld b, set 2, (ix+0)            ; FD CB 00 D0
 ld b, set 2, (ix+126)          ; FD CB 7E D0
 ld b, set 2, (ix-128)          ; FD CB 80 D0
 ld b, set 2, (iy)              ; DD CB 00 D0
 ld b, set 2, (iy+0)            ; DD CB 00 D0
 ld b, set 2, (iy+126)          ; DD CB 7E D0
 ld b, set 2, (iy-128)          ; DD CB 80 D0
 ld b, set 3, (ix)              ; FD CB 00 D8
 ld b, set 3, (ix+0)            ; FD CB 00 D8
 ld b, set 3, (ix+126)          ; FD CB 7E D8
 ld b, set 3, (ix-128)          ; FD CB 80 D8
 ld b, set 3, (iy)              ; DD CB 00 D8
 ld b, set 3, (iy+0)            ; DD CB 00 D8
 ld b, set 3, (iy+126)          ; DD CB 7E D8
 ld b, set 3, (iy-128)          ; DD CB 80 D8
 ld b, set 4, (ix)              ; FD CB 00 E0
 ld b, set 4, (ix+0)            ; FD CB 00 E0
 ld b, set 4, (ix+126)          ; FD CB 7E E0
 ld b, set 4, (ix-128)          ; FD CB 80 E0
 ld b, set 4, (iy)              ; DD CB 00 E0
 ld b, set 4, (iy+0)            ; DD CB 00 E0
 ld b, set 4, (iy+126)          ; DD CB 7E E0
 ld b, set 4, (iy-128)          ; DD CB 80 E0
 ld b, set 5, (ix)              ; FD CB 00 E8
 ld b, set 5, (ix+0)            ; FD CB 00 E8
 ld b, set 5, (ix+126)          ; FD CB 7E E8
 ld b, set 5, (ix-128)          ; FD CB 80 E8
 ld b, set 5, (iy)              ; DD CB 00 E8
 ld b, set 5, (iy+0)            ; DD CB 00 E8
 ld b, set 5, (iy+126)          ; DD CB 7E E8
 ld b, set 5, (iy-128)          ; DD CB 80 E8
 ld b, set 6, (ix)              ; FD CB 00 F0
 ld b, set 6, (ix+0)            ; FD CB 00 F0
 ld b, set 6, (ix+126)          ; FD CB 7E F0
 ld b, set 6, (ix-128)          ; FD CB 80 F0
 ld b, set 6, (iy)              ; DD CB 00 F0
 ld b, set 6, (iy+0)            ; DD CB 00 F0
 ld b, set 6, (iy+126)          ; DD CB 7E F0
 ld b, set 6, (iy-128)          ; DD CB 80 F0
 ld b, set 7, (ix)              ; FD CB 00 F8
 ld b, set 7, (ix+0)            ; FD CB 00 F8
 ld b, set 7, (ix+126)          ; FD CB 7E F8
 ld b, set 7, (ix-128)          ; FD CB 80 F8
 ld b, set 7, (iy)              ; DD CB 00 F8
 ld b, set 7, (iy+0)            ; DD CB 00 F8
 ld b, set 7, (iy+126)          ; DD CB 7E F8
 ld b, set 7, (iy-128)          ; DD CB 80 F8
 ld b, sla (ix)                 ; FD CB 00 20
 ld b, sla (ix+0)               ; FD CB 00 20
 ld b, sla (ix+126)             ; FD CB 7E 20
 ld b, sla (ix-128)             ; FD CB 80 20
 ld b, sla (iy)                 ; DD CB 00 20
 ld b, sla (iy+0)               ; DD CB 00 20
 ld b, sla (iy+126)             ; DD CB 7E 20
 ld b, sla (iy-128)             ; DD CB 80 20
 ld b, sli (ix)                 ; FD CB 00 30
 ld b, sli (ix+0)               ; FD CB 00 30
 ld b, sli (ix+126)             ; FD CB 7E 30
 ld b, sli (ix-128)             ; FD CB 80 30
 ld b, sli (iy)                 ; DD CB 00 30
 ld b, sli (iy+0)               ; DD CB 00 30
 ld b, sli (iy+126)             ; DD CB 7E 30
 ld b, sli (iy-128)             ; DD CB 80 30
 ld b, sll (ix)                 ; FD CB 00 30
 ld b, sll (ix+0)               ; FD CB 00 30
 ld b, sll (ix+126)             ; FD CB 7E 30
 ld b, sll (ix-128)             ; FD CB 80 30
 ld b, sll (iy)                 ; DD CB 00 30
 ld b, sll (iy+0)               ; DD CB 00 30
 ld b, sll (iy+126)             ; DD CB 7E 30
 ld b, sll (iy-128)             ; DD CB 80 30
 ld b, sls (ix)                 ; FD CB 00 30
 ld b, sls (ix+0)               ; FD CB 00 30
 ld b, sls (ix+126)             ; FD CB 7E 30
 ld b, sls (ix-128)             ; FD CB 80 30
 ld b, sls (iy)                 ; DD CB 00 30
 ld b, sls (iy+0)               ; DD CB 00 30
 ld b, sls (iy+126)             ; DD CB 7E 30
 ld b, sls (iy-128)             ; DD CB 80 30
 ld b, sra (ix)                 ; FD CB 00 28
 ld b, sra (ix+0)               ; FD CB 00 28
 ld b, sra (ix+126)             ; FD CB 7E 28
 ld b, sra (ix-128)             ; FD CB 80 28
 ld b, sra (iy)                 ; DD CB 00 28
 ld b, sra (iy+0)               ; DD CB 00 28
 ld b, sra (iy+126)             ; DD CB 7E 28
 ld b, sra (iy-128)             ; DD CB 80 28
 ld b, srl (ix)                 ; FD CB 00 38
 ld b, srl (ix+0)               ; FD CB 00 38
 ld b, srl (ix+126)             ; FD CB 7E 38
 ld b, srl (ix-128)             ; FD CB 80 38
 ld b, srl (iy)                 ; DD CB 00 38
 ld b, srl (iy+0)               ; DD CB 00 38
 ld b, srl (iy+126)             ; DD CB 7E 38
 ld b, srl (iy-128)             ; DD CB 80 38
 ld bc, (0x1234)                ; ED 4B 34 12
 ld bc, 0x1234                  ; 01 34 12
 ld c, (hl)                     ; 4E
 ld c, (ix)                     ; FD 4E 00
 ld c, (ix+0)                   ; FD 4E 00
 ld c, (ix+126)                 ; FD 4E 7E
 ld c, (ix-128)                 ; FD 4E 80
 ld c, (iy)                     ; DD 4E 00
 ld c, (iy+0)                   ; DD 4E 00
 ld c, (iy+126)                 ; DD 4E 7E
 ld c, (iy-128)                 ; DD 4E 80
 ld c, 0                        ; 0E 00
 ld c, 127                      ; 0E 7F
 ld c, 255                      ; 0E FF
 ld c, a                        ; 4F
 ld c, b                        ; 48
 ld c, c                        ; 49
 ld c, d                        ; 4A
 ld c, e                        ; 4B
 ld c, h                        ; 4C
 ld c, ixh                      ; FD 4C
 ld c, ixl                      ; FD 4D
 ld c, iyh                      ; DD 4C
 ld c, iyl                      ; DD 4D
 ld c, l                        ; 4D
 ld c, res 0, (ix)              ; FD CB 00 81
 ld c, res 0, (ix+0)            ; FD CB 00 81
 ld c, res 0, (ix+126)          ; FD CB 7E 81
 ld c, res 0, (ix-128)          ; FD CB 80 81
 ld c, res 0, (iy)              ; DD CB 00 81
 ld c, res 0, (iy+0)            ; DD CB 00 81
 ld c, res 0, (iy+126)          ; DD CB 7E 81
 ld c, res 0, (iy-128)          ; DD CB 80 81
 ld c, res 1, (ix)              ; FD CB 00 89
 ld c, res 1, (ix+0)            ; FD CB 00 89
 ld c, res 1, (ix+126)          ; FD CB 7E 89
 ld c, res 1, (ix-128)          ; FD CB 80 89
 ld c, res 1, (iy)              ; DD CB 00 89
 ld c, res 1, (iy+0)            ; DD CB 00 89
 ld c, res 1, (iy+126)          ; DD CB 7E 89
 ld c, res 1, (iy-128)          ; DD CB 80 89
 ld c, res 2, (ix)              ; FD CB 00 91
 ld c, res 2, (ix+0)            ; FD CB 00 91
 ld c, res 2, (ix+126)          ; FD CB 7E 91
 ld c, res 2, (ix-128)          ; FD CB 80 91
 ld c, res 2, (iy)              ; DD CB 00 91
 ld c, res 2, (iy+0)            ; DD CB 00 91
 ld c, res 2, (iy+126)          ; DD CB 7E 91
 ld c, res 2, (iy-128)          ; DD CB 80 91
 ld c, res 3, (ix)              ; FD CB 00 99
 ld c, res 3, (ix+0)            ; FD CB 00 99
 ld c, res 3, (ix+126)          ; FD CB 7E 99
 ld c, res 3, (ix-128)          ; FD CB 80 99
 ld c, res 3, (iy)              ; DD CB 00 99
 ld c, res 3, (iy+0)            ; DD CB 00 99
 ld c, res 3, (iy+126)          ; DD CB 7E 99
 ld c, res 3, (iy-128)          ; DD CB 80 99
 ld c, res 4, (ix)              ; FD CB 00 A1
 ld c, res 4, (ix+0)            ; FD CB 00 A1
 ld c, res 4, (ix+126)          ; FD CB 7E A1
 ld c, res 4, (ix-128)          ; FD CB 80 A1
 ld c, res 4, (iy)              ; DD CB 00 A1
 ld c, res 4, (iy+0)            ; DD CB 00 A1
 ld c, res 4, (iy+126)          ; DD CB 7E A1
 ld c, res 4, (iy-128)          ; DD CB 80 A1
 ld c, res 5, (ix)              ; FD CB 00 A9
 ld c, res 5, (ix+0)            ; FD CB 00 A9
 ld c, res 5, (ix+126)          ; FD CB 7E A9
 ld c, res 5, (ix-128)          ; FD CB 80 A9
 ld c, res 5, (iy)              ; DD CB 00 A9
 ld c, res 5, (iy+0)            ; DD CB 00 A9
 ld c, res 5, (iy+126)          ; DD CB 7E A9
 ld c, res 5, (iy-128)          ; DD CB 80 A9
 ld c, res 6, (ix)              ; FD CB 00 B1
 ld c, res 6, (ix+0)            ; FD CB 00 B1
 ld c, res 6, (ix+126)          ; FD CB 7E B1
 ld c, res 6, (ix-128)          ; FD CB 80 B1
 ld c, res 6, (iy)              ; DD CB 00 B1
 ld c, res 6, (iy+0)            ; DD CB 00 B1
 ld c, res 6, (iy+126)          ; DD CB 7E B1
 ld c, res 6, (iy-128)          ; DD CB 80 B1
 ld c, res 7, (ix)              ; FD CB 00 B9
 ld c, res 7, (ix+0)            ; FD CB 00 B9
 ld c, res 7, (ix+126)          ; FD CB 7E B9
 ld c, res 7, (ix-128)          ; FD CB 80 B9
 ld c, res 7, (iy)              ; DD CB 00 B9
 ld c, res 7, (iy+0)            ; DD CB 00 B9
 ld c, res 7, (iy+126)          ; DD CB 7E B9
 ld c, res 7, (iy-128)          ; DD CB 80 B9
 ld c, rl (ix)                  ; FD CB 00 11
 ld c, rl (ix+0)                ; FD CB 00 11
 ld c, rl (ix+126)              ; FD CB 7E 11
 ld c, rl (ix-128)              ; FD CB 80 11
 ld c, rl (iy)                  ; DD CB 00 11
 ld c, rl (iy+0)                ; DD CB 00 11
 ld c, rl (iy+126)              ; DD CB 7E 11
 ld c, rl (iy-128)              ; DD CB 80 11
 ld c, rlc (ix)                 ; FD CB 00 01
 ld c, rlc (ix+0)               ; FD CB 00 01
 ld c, rlc (ix+126)             ; FD CB 7E 01
 ld c, rlc (ix-128)             ; FD CB 80 01
 ld c, rlc (iy)                 ; DD CB 00 01
 ld c, rlc (iy+0)               ; DD CB 00 01
 ld c, rlc (iy+126)             ; DD CB 7E 01
 ld c, rlc (iy-128)             ; DD CB 80 01
 ld c, rr (ix)                  ; FD CB 00 19
 ld c, rr (ix+0)                ; FD CB 00 19
 ld c, rr (ix+126)              ; FD CB 7E 19
 ld c, rr (ix-128)              ; FD CB 80 19
 ld c, rr (iy)                  ; DD CB 00 19
 ld c, rr (iy+0)                ; DD CB 00 19
 ld c, rr (iy+126)              ; DD CB 7E 19
 ld c, rr (iy-128)              ; DD CB 80 19
 ld c, rrc (ix)                 ; FD CB 00 09
 ld c, rrc (ix+0)               ; FD CB 00 09
 ld c, rrc (ix+126)             ; FD CB 7E 09
 ld c, rrc (ix-128)             ; FD CB 80 09
 ld c, rrc (iy)                 ; DD CB 00 09
 ld c, rrc (iy+0)               ; DD CB 00 09
 ld c, rrc (iy+126)             ; DD CB 7E 09
 ld c, rrc (iy-128)             ; DD CB 80 09
 ld c, set 0, (ix)              ; FD CB 00 C1
 ld c, set 0, (ix+0)            ; FD CB 00 C1
 ld c, set 0, (ix+126)          ; FD CB 7E C1
 ld c, set 0, (ix-128)          ; FD CB 80 C1
 ld c, set 0, (iy)              ; DD CB 00 C1
 ld c, set 0, (iy+0)            ; DD CB 00 C1
 ld c, set 0, (iy+126)          ; DD CB 7E C1
 ld c, set 0, (iy-128)          ; DD CB 80 C1
 ld c, set 1, (ix)              ; FD CB 00 C9
 ld c, set 1, (ix+0)            ; FD CB 00 C9
 ld c, set 1, (ix+126)          ; FD CB 7E C9
 ld c, set 1, (ix-128)          ; FD CB 80 C9
 ld c, set 1, (iy)              ; DD CB 00 C9
 ld c, set 1, (iy+0)            ; DD CB 00 C9
 ld c, set 1, (iy+126)          ; DD CB 7E C9
 ld c, set 1, (iy-128)          ; DD CB 80 C9
 ld c, set 2, (ix)              ; FD CB 00 D1
 ld c, set 2, (ix+0)            ; FD CB 00 D1
 ld c, set 2, (ix+126)          ; FD CB 7E D1
 ld c, set 2, (ix-128)          ; FD CB 80 D1
 ld c, set 2, (iy)              ; DD CB 00 D1
 ld c, set 2, (iy+0)            ; DD CB 00 D1
 ld c, set 2, (iy+126)          ; DD CB 7E D1
 ld c, set 2, (iy-128)          ; DD CB 80 D1
 ld c, set 3, (ix)              ; FD CB 00 D9
 ld c, set 3, (ix+0)            ; FD CB 00 D9
 ld c, set 3, (ix+126)          ; FD CB 7E D9
 ld c, set 3, (ix-128)          ; FD CB 80 D9
 ld c, set 3, (iy)              ; DD CB 00 D9
 ld c, set 3, (iy+0)            ; DD CB 00 D9
 ld c, set 3, (iy+126)          ; DD CB 7E D9
 ld c, set 3, (iy-128)          ; DD CB 80 D9
 ld c, set 4, (ix)              ; FD CB 00 E1
 ld c, set 4, (ix+0)            ; FD CB 00 E1
 ld c, set 4, (ix+126)          ; FD CB 7E E1
 ld c, set 4, (ix-128)          ; FD CB 80 E1
 ld c, set 4, (iy)              ; DD CB 00 E1
 ld c, set 4, (iy+0)            ; DD CB 00 E1
 ld c, set 4, (iy+126)          ; DD CB 7E E1
 ld c, set 4, (iy-128)          ; DD CB 80 E1
 ld c, set 5, (ix)              ; FD CB 00 E9
 ld c, set 5, (ix+0)            ; FD CB 00 E9
 ld c, set 5, (ix+126)          ; FD CB 7E E9
 ld c, set 5, (ix-128)          ; FD CB 80 E9
 ld c, set 5, (iy)              ; DD CB 00 E9
 ld c, set 5, (iy+0)            ; DD CB 00 E9
 ld c, set 5, (iy+126)          ; DD CB 7E E9
 ld c, set 5, (iy-128)          ; DD CB 80 E9
 ld c, set 6, (ix)              ; FD CB 00 F1
 ld c, set 6, (ix+0)            ; FD CB 00 F1
 ld c, set 6, (ix+126)          ; FD CB 7E F1
 ld c, set 6, (ix-128)          ; FD CB 80 F1
 ld c, set 6, (iy)              ; DD CB 00 F1
 ld c, set 6, (iy+0)            ; DD CB 00 F1
 ld c, set 6, (iy+126)          ; DD CB 7E F1
 ld c, set 6, (iy-128)          ; DD CB 80 F1
 ld c, set 7, (ix)              ; FD CB 00 F9
 ld c, set 7, (ix+0)            ; FD CB 00 F9
 ld c, set 7, (ix+126)          ; FD CB 7E F9
 ld c, set 7, (ix-128)          ; FD CB 80 F9
 ld c, set 7, (iy)              ; DD CB 00 F9
 ld c, set 7, (iy+0)            ; DD CB 00 F9
 ld c, set 7, (iy+126)          ; DD CB 7E F9
 ld c, set 7, (iy-128)          ; DD CB 80 F9
 ld c, sla (ix)                 ; FD CB 00 21
 ld c, sla (ix+0)               ; FD CB 00 21
 ld c, sla (ix+126)             ; FD CB 7E 21
 ld c, sla (ix-128)             ; FD CB 80 21
 ld c, sla (iy)                 ; DD CB 00 21
 ld c, sla (iy+0)               ; DD CB 00 21
 ld c, sla (iy+126)             ; DD CB 7E 21
 ld c, sla (iy-128)             ; DD CB 80 21
 ld c, sli (ix)                 ; FD CB 00 31
 ld c, sli (ix+0)               ; FD CB 00 31
 ld c, sli (ix+126)             ; FD CB 7E 31
 ld c, sli (ix-128)             ; FD CB 80 31
 ld c, sli (iy)                 ; DD CB 00 31
 ld c, sli (iy+0)               ; DD CB 00 31
 ld c, sli (iy+126)             ; DD CB 7E 31
 ld c, sli (iy-128)             ; DD CB 80 31
 ld c, sll (ix)                 ; FD CB 00 31
 ld c, sll (ix+0)               ; FD CB 00 31
 ld c, sll (ix+126)             ; FD CB 7E 31
 ld c, sll (ix-128)             ; FD CB 80 31
 ld c, sll (iy)                 ; DD CB 00 31
 ld c, sll (iy+0)               ; DD CB 00 31
 ld c, sll (iy+126)             ; DD CB 7E 31
 ld c, sll (iy-128)             ; DD CB 80 31
 ld c, sls (ix)                 ; FD CB 00 31
 ld c, sls (ix+0)               ; FD CB 00 31
 ld c, sls (ix+126)             ; FD CB 7E 31
 ld c, sls (ix-128)             ; FD CB 80 31
 ld c, sls (iy)                 ; DD CB 00 31
 ld c, sls (iy+0)               ; DD CB 00 31
 ld c, sls (iy+126)             ; DD CB 7E 31
 ld c, sls (iy-128)             ; DD CB 80 31
 ld c, sra (ix)                 ; FD CB 00 29
 ld c, sra (ix+0)               ; FD CB 00 29
 ld c, sra (ix+126)             ; FD CB 7E 29
 ld c, sra (ix-128)             ; FD CB 80 29
 ld c, sra (iy)                 ; DD CB 00 29
 ld c, sra (iy+0)               ; DD CB 00 29
 ld c, sra (iy+126)             ; DD CB 7E 29
 ld c, sra (iy-128)             ; DD CB 80 29
 ld c, srl (ix)                 ; FD CB 00 39
 ld c, srl (ix+0)               ; FD CB 00 39
 ld c, srl (ix+126)             ; FD CB 7E 39
 ld c, srl (ix-128)             ; FD CB 80 39
 ld c, srl (iy)                 ; DD CB 00 39
 ld c, srl (iy+0)               ; DD CB 00 39
 ld c, srl (iy+126)             ; DD CB 7E 39
 ld c, srl (iy-128)             ; DD CB 80 39
 ld d, (hl)                     ; 56
 ld d, (ix)                     ; FD 56 00
 ld d, (ix+0)                   ; FD 56 00
 ld d, (ix+126)                 ; FD 56 7E
 ld d, (ix-128)                 ; FD 56 80
 ld d, (iy)                     ; DD 56 00
 ld d, (iy+0)                   ; DD 56 00
 ld d, (iy+126)                 ; DD 56 7E
 ld d, (iy-128)                 ; DD 56 80
 ld d, 0                        ; 16 00
 ld d, 127                      ; 16 7F
 ld d, 255                      ; 16 FF
 ld d, a                        ; 57
 ld d, b                        ; 50
 ld d, c                        ; 51
 ld d, d                        ; 52
 ld d, e                        ; 53
 ld d, h                        ; 54
 ld d, ixh                      ; FD 54
 ld d, ixl                      ; FD 55
 ld d, iyh                      ; DD 54
 ld d, iyl                      ; DD 55
 ld d, l                        ; 55
 ld d, res 0, (ix)              ; FD CB 00 82
 ld d, res 0, (ix+0)            ; FD CB 00 82
 ld d, res 0, (ix+126)          ; FD CB 7E 82
 ld d, res 0, (ix-128)          ; FD CB 80 82
 ld d, res 0, (iy)              ; DD CB 00 82
 ld d, res 0, (iy+0)            ; DD CB 00 82
 ld d, res 0, (iy+126)          ; DD CB 7E 82
 ld d, res 0, (iy-128)          ; DD CB 80 82
 ld d, res 1, (ix)              ; FD CB 00 8A
 ld d, res 1, (ix+0)            ; FD CB 00 8A
 ld d, res 1, (ix+126)          ; FD CB 7E 8A
 ld d, res 1, (ix-128)          ; FD CB 80 8A
 ld d, res 1, (iy)              ; DD CB 00 8A
 ld d, res 1, (iy+0)            ; DD CB 00 8A
 ld d, res 1, (iy+126)          ; DD CB 7E 8A
 ld d, res 1, (iy-128)          ; DD CB 80 8A
 ld d, res 2, (ix)              ; FD CB 00 92
 ld d, res 2, (ix+0)            ; FD CB 00 92
 ld d, res 2, (ix+126)          ; FD CB 7E 92
 ld d, res 2, (ix-128)          ; FD CB 80 92
 ld d, res 2, (iy)              ; DD CB 00 92
 ld d, res 2, (iy+0)            ; DD CB 00 92
 ld d, res 2, (iy+126)          ; DD CB 7E 92
 ld d, res 2, (iy-128)          ; DD CB 80 92
 ld d, res 3, (ix)              ; FD CB 00 9A
 ld d, res 3, (ix+0)            ; FD CB 00 9A
 ld d, res 3, (ix+126)          ; FD CB 7E 9A
 ld d, res 3, (ix-128)          ; FD CB 80 9A
 ld d, res 3, (iy)              ; DD CB 00 9A
 ld d, res 3, (iy+0)            ; DD CB 00 9A
 ld d, res 3, (iy+126)          ; DD CB 7E 9A
 ld d, res 3, (iy-128)          ; DD CB 80 9A
 ld d, res 4, (ix)              ; FD CB 00 A2
 ld d, res 4, (ix+0)            ; FD CB 00 A2
 ld d, res 4, (ix+126)          ; FD CB 7E A2
 ld d, res 4, (ix-128)          ; FD CB 80 A2
 ld d, res 4, (iy)              ; DD CB 00 A2
 ld d, res 4, (iy+0)            ; DD CB 00 A2
 ld d, res 4, (iy+126)          ; DD CB 7E A2
 ld d, res 4, (iy-128)          ; DD CB 80 A2
 ld d, res 5, (ix)              ; FD CB 00 AA
 ld d, res 5, (ix+0)            ; FD CB 00 AA
 ld d, res 5, (ix+126)          ; FD CB 7E AA
 ld d, res 5, (ix-128)          ; FD CB 80 AA
 ld d, res 5, (iy)              ; DD CB 00 AA
 ld d, res 5, (iy+0)            ; DD CB 00 AA
 ld d, res 5, (iy+126)          ; DD CB 7E AA
 ld d, res 5, (iy-128)          ; DD CB 80 AA
 ld d, res 6, (ix)              ; FD CB 00 B2
 ld d, res 6, (ix+0)            ; FD CB 00 B2
 ld d, res 6, (ix+126)          ; FD CB 7E B2
 ld d, res 6, (ix-128)          ; FD CB 80 B2
 ld d, res 6, (iy)              ; DD CB 00 B2
 ld d, res 6, (iy+0)            ; DD CB 00 B2
 ld d, res 6, (iy+126)          ; DD CB 7E B2
 ld d, res 6, (iy-128)          ; DD CB 80 B2
 ld d, res 7, (ix)              ; FD CB 00 BA
 ld d, res 7, (ix+0)            ; FD CB 00 BA
 ld d, res 7, (ix+126)          ; FD CB 7E BA
 ld d, res 7, (ix-128)          ; FD CB 80 BA
 ld d, res 7, (iy)              ; DD CB 00 BA
 ld d, res 7, (iy+0)            ; DD CB 00 BA
 ld d, res 7, (iy+126)          ; DD CB 7E BA
 ld d, res 7, (iy-128)          ; DD CB 80 BA
 ld d, rl (ix)                  ; FD CB 00 12
 ld d, rl (ix+0)                ; FD CB 00 12
 ld d, rl (ix+126)              ; FD CB 7E 12
 ld d, rl (ix-128)              ; FD CB 80 12
 ld d, rl (iy)                  ; DD CB 00 12
 ld d, rl (iy+0)                ; DD CB 00 12
 ld d, rl (iy+126)              ; DD CB 7E 12
 ld d, rl (iy-128)              ; DD CB 80 12
 ld d, rlc (ix)                 ; FD CB 00 02
 ld d, rlc (ix+0)               ; FD CB 00 02
 ld d, rlc (ix+126)             ; FD CB 7E 02
 ld d, rlc (ix-128)             ; FD CB 80 02
 ld d, rlc (iy)                 ; DD CB 00 02
 ld d, rlc (iy+0)               ; DD CB 00 02
 ld d, rlc (iy+126)             ; DD CB 7E 02
 ld d, rlc (iy-128)             ; DD CB 80 02
 ld d, rr (ix)                  ; FD CB 00 1A
 ld d, rr (ix+0)                ; FD CB 00 1A
 ld d, rr (ix+126)              ; FD CB 7E 1A
 ld d, rr (ix-128)              ; FD CB 80 1A
 ld d, rr (iy)                  ; DD CB 00 1A
 ld d, rr (iy+0)                ; DD CB 00 1A
 ld d, rr (iy+126)              ; DD CB 7E 1A
 ld d, rr (iy-128)              ; DD CB 80 1A
 ld d, rrc (ix)                 ; FD CB 00 0A
 ld d, rrc (ix+0)               ; FD CB 00 0A
 ld d, rrc (ix+126)             ; FD CB 7E 0A
 ld d, rrc (ix-128)             ; FD CB 80 0A
 ld d, rrc (iy)                 ; DD CB 00 0A
 ld d, rrc (iy+0)               ; DD CB 00 0A
 ld d, rrc (iy+126)             ; DD CB 7E 0A
 ld d, rrc (iy-128)             ; DD CB 80 0A
 ld d, set 0, (ix)              ; FD CB 00 C2
 ld d, set 0, (ix+0)            ; FD CB 00 C2
 ld d, set 0, (ix+126)          ; FD CB 7E C2
 ld d, set 0, (ix-128)          ; FD CB 80 C2
 ld d, set 0, (iy)              ; DD CB 00 C2
 ld d, set 0, (iy+0)            ; DD CB 00 C2
 ld d, set 0, (iy+126)          ; DD CB 7E C2
 ld d, set 0, (iy-128)          ; DD CB 80 C2
 ld d, set 1, (ix)              ; FD CB 00 CA
 ld d, set 1, (ix+0)            ; FD CB 00 CA
 ld d, set 1, (ix+126)          ; FD CB 7E CA
 ld d, set 1, (ix-128)          ; FD CB 80 CA
 ld d, set 1, (iy)              ; DD CB 00 CA
 ld d, set 1, (iy+0)            ; DD CB 00 CA
 ld d, set 1, (iy+126)          ; DD CB 7E CA
 ld d, set 1, (iy-128)          ; DD CB 80 CA
 ld d, set 2, (ix)              ; FD CB 00 D2
 ld d, set 2, (ix+0)            ; FD CB 00 D2
 ld d, set 2, (ix+126)          ; FD CB 7E D2
 ld d, set 2, (ix-128)          ; FD CB 80 D2
 ld d, set 2, (iy)              ; DD CB 00 D2
 ld d, set 2, (iy+0)            ; DD CB 00 D2
 ld d, set 2, (iy+126)          ; DD CB 7E D2
 ld d, set 2, (iy-128)          ; DD CB 80 D2
 ld d, set 3, (ix)              ; FD CB 00 DA
 ld d, set 3, (ix+0)            ; FD CB 00 DA
 ld d, set 3, (ix+126)          ; FD CB 7E DA
 ld d, set 3, (ix-128)          ; FD CB 80 DA
 ld d, set 3, (iy)              ; DD CB 00 DA
 ld d, set 3, (iy+0)            ; DD CB 00 DA
 ld d, set 3, (iy+126)          ; DD CB 7E DA
 ld d, set 3, (iy-128)          ; DD CB 80 DA
 ld d, set 4, (ix)              ; FD CB 00 E2
 ld d, set 4, (ix+0)            ; FD CB 00 E2
 ld d, set 4, (ix+126)          ; FD CB 7E E2
 ld d, set 4, (ix-128)          ; FD CB 80 E2
 ld d, set 4, (iy)              ; DD CB 00 E2
 ld d, set 4, (iy+0)            ; DD CB 00 E2
 ld d, set 4, (iy+126)          ; DD CB 7E E2
 ld d, set 4, (iy-128)          ; DD CB 80 E2
 ld d, set 5, (ix)              ; FD CB 00 EA
 ld d, set 5, (ix+0)            ; FD CB 00 EA
 ld d, set 5, (ix+126)          ; FD CB 7E EA
 ld d, set 5, (ix-128)          ; FD CB 80 EA
 ld d, set 5, (iy)              ; DD CB 00 EA
 ld d, set 5, (iy+0)            ; DD CB 00 EA
 ld d, set 5, (iy+126)          ; DD CB 7E EA
 ld d, set 5, (iy-128)          ; DD CB 80 EA
 ld d, set 6, (ix)              ; FD CB 00 F2
 ld d, set 6, (ix+0)            ; FD CB 00 F2
 ld d, set 6, (ix+126)          ; FD CB 7E F2
 ld d, set 6, (ix-128)          ; FD CB 80 F2
 ld d, set 6, (iy)              ; DD CB 00 F2
 ld d, set 6, (iy+0)            ; DD CB 00 F2
 ld d, set 6, (iy+126)          ; DD CB 7E F2
 ld d, set 6, (iy-128)          ; DD CB 80 F2
 ld d, set 7, (ix)              ; FD CB 00 FA
 ld d, set 7, (ix+0)            ; FD CB 00 FA
 ld d, set 7, (ix+126)          ; FD CB 7E FA
 ld d, set 7, (ix-128)          ; FD CB 80 FA
 ld d, set 7, (iy)              ; DD CB 00 FA
 ld d, set 7, (iy+0)            ; DD CB 00 FA
 ld d, set 7, (iy+126)          ; DD CB 7E FA
 ld d, set 7, (iy-128)          ; DD CB 80 FA
 ld d, sla (ix)                 ; FD CB 00 22
 ld d, sla (ix+0)               ; FD CB 00 22
 ld d, sla (ix+126)             ; FD CB 7E 22
 ld d, sla (ix-128)             ; FD CB 80 22
 ld d, sla (iy)                 ; DD CB 00 22
 ld d, sla (iy+0)               ; DD CB 00 22
 ld d, sla (iy+126)             ; DD CB 7E 22
 ld d, sla (iy-128)             ; DD CB 80 22
 ld d, sli (ix)                 ; FD CB 00 32
 ld d, sli (ix+0)               ; FD CB 00 32
 ld d, sli (ix+126)             ; FD CB 7E 32
 ld d, sli (ix-128)             ; FD CB 80 32
 ld d, sli (iy)                 ; DD CB 00 32
 ld d, sli (iy+0)               ; DD CB 00 32
 ld d, sli (iy+126)             ; DD CB 7E 32
 ld d, sli (iy-128)             ; DD CB 80 32
 ld d, sll (ix)                 ; FD CB 00 32
 ld d, sll (ix+0)               ; FD CB 00 32
 ld d, sll (ix+126)             ; FD CB 7E 32
 ld d, sll (ix-128)             ; FD CB 80 32
 ld d, sll (iy)                 ; DD CB 00 32
 ld d, sll (iy+0)               ; DD CB 00 32
 ld d, sll (iy+126)             ; DD CB 7E 32
 ld d, sll (iy-128)             ; DD CB 80 32
 ld d, sls (ix)                 ; FD CB 00 32
 ld d, sls (ix+0)               ; FD CB 00 32
 ld d, sls (ix+126)             ; FD CB 7E 32
 ld d, sls (ix-128)             ; FD CB 80 32
 ld d, sls (iy)                 ; DD CB 00 32
 ld d, sls (iy+0)               ; DD CB 00 32
 ld d, sls (iy+126)             ; DD CB 7E 32
 ld d, sls (iy-128)             ; DD CB 80 32
 ld d, sra (ix)                 ; FD CB 00 2A
 ld d, sra (ix+0)               ; FD CB 00 2A
 ld d, sra (ix+126)             ; FD CB 7E 2A
 ld d, sra (ix-128)             ; FD CB 80 2A
 ld d, sra (iy)                 ; DD CB 00 2A
 ld d, sra (iy+0)               ; DD CB 00 2A
 ld d, sra (iy+126)             ; DD CB 7E 2A
 ld d, sra (iy-128)             ; DD CB 80 2A
 ld d, srl (ix)                 ; FD CB 00 3A
 ld d, srl (ix+0)               ; FD CB 00 3A
 ld d, srl (ix+126)             ; FD CB 7E 3A
 ld d, srl (ix-128)             ; FD CB 80 3A
 ld d, srl (iy)                 ; DD CB 00 3A
 ld d, srl (iy+0)               ; DD CB 00 3A
 ld d, srl (iy+126)             ; DD CB 7E 3A
 ld d, srl (iy-128)             ; DD CB 80 3A
 ld de, (0x1234)                ; ED 5B 34 12
 ld de, 0x1234                  ; 11 34 12
 ld e, (hl)                     ; 5E
 ld e, (ix)                     ; FD 5E 00
 ld e, (ix+0)                   ; FD 5E 00
 ld e, (ix+126)                 ; FD 5E 7E
 ld e, (ix-128)                 ; FD 5E 80
 ld e, (iy)                     ; DD 5E 00
 ld e, (iy+0)                   ; DD 5E 00
 ld e, (iy+126)                 ; DD 5E 7E
 ld e, (iy-128)                 ; DD 5E 80
 ld e, 0                        ; 1E 00
 ld e, 127                      ; 1E 7F
 ld e, 255                      ; 1E FF
 ld e, a                        ; 5F
 ld e, b                        ; 58
 ld e, c                        ; 59
 ld e, d                        ; 5A
 ld e, e                        ; 5B
 ld e, h                        ; 5C
 ld e, ixh                      ; FD 5C
 ld e, ixl                      ; FD 5D
 ld e, iyh                      ; DD 5C
 ld e, iyl                      ; DD 5D
 ld e, l                        ; 5D
 ld e, res 0, (ix)              ; FD CB 00 83
 ld e, res 0, (ix+0)            ; FD CB 00 83
 ld e, res 0, (ix+126)          ; FD CB 7E 83
 ld e, res 0, (ix-128)          ; FD CB 80 83
 ld e, res 0, (iy)              ; DD CB 00 83
 ld e, res 0, (iy+0)            ; DD CB 00 83
 ld e, res 0, (iy+126)          ; DD CB 7E 83
 ld e, res 0, (iy-128)          ; DD CB 80 83
 ld e, res 1, (ix)              ; FD CB 00 8B
 ld e, res 1, (ix+0)            ; FD CB 00 8B
 ld e, res 1, (ix+126)          ; FD CB 7E 8B
 ld e, res 1, (ix-128)          ; FD CB 80 8B
 ld e, res 1, (iy)              ; DD CB 00 8B
 ld e, res 1, (iy+0)            ; DD CB 00 8B
 ld e, res 1, (iy+126)          ; DD CB 7E 8B
 ld e, res 1, (iy-128)          ; DD CB 80 8B
 ld e, res 2, (ix)              ; FD CB 00 93
 ld e, res 2, (ix+0)            ; FD CB 00 93
 ld e, res 2, (ix+126)          ; FD CB 7E 93
 ld e, res 2, (ix-128)          ; FD CB 80 93
 ld e, res 2, (iy)              ; DD CB 00 93
 ld e, res 2, (iy+0)            ; DD CB 00 93
 ld e, res 2, (iy+126)          ; DD CB 7E 93
 ld e, res 2, (iy-128)          ; DD CB 80 93
 ld e, res 3, (ix)              ; FD CB 00 9B
 ld e, res 3, (ix+0)            ; FD CB 00 9B
 ld e, res 3, (ix+126)          ; FD CB 7E 9B
 ld e, res 3, (ix-128)          ; FD CB 80 9B
 ld e, res 3, (iy)              ; DD CB 00 9B
 ld e, res 3, (iy+0)            ; DD CB 00 9B
 ld e, res 3, (iy+126)          ; DD CB 7E 9B
 ld e, res 3, (iy-128)          ; DD CB 80 9B
 ld e, res 4, (ix)              ; FD CB 00 A3
 ld e, res 4, (ix+0)            ; FD CB 00 A3
 ld e, res 4, (ix+126)          ; FD CB 7E A3
 ld e, res 4, (ix-128)          ; FD CB 80 A3
 ld e, res 4, (iy)              ; DD CB 00 A3
 ld e, res 4, (iy+0)            ; DD CB 00 A3
 ld e, res 4, (iy+126)          ; DD CB 7E A3
 ld e, res 4, (iy-128)          ; DD CB 80 A3
 ld e, res 5, (ix)              ; FD CB 00 AB
 ld e, res 5, (ix+0)            ; FD CB 00 AB
 ld e, res 5, (ix+126)          ; FD CB 7E AB
 ld e, res 5, (ix-128)          ; FD CB 80 AB
 ld e, res 5, (iy)              ; DD CB 00 AB
 ld e, res 5, (iy+0)            ; DD CB 00 AB
 ld e, res 5, (iy+126)          ; DD CB 7E AB
 ld e, res 5, (iy-128)          ; DD CB 80 AB
 ld e, res 6, (ix)              ; FD CB 00 B3
 ld e, res 6, (ix+0)            ; FD CB 00 B3
 ld e, res 6, (ix+126)          ; FD CB 7E B3
 ld e, res 6, (ix-128)          ; FD CB 80 B3
 ld e, res 6, (iy)              ; DD CB 00 B3
 ld e, res 6, (iy+0)            ; DD CB 00 B3
 ld e, res 6, (iy+126)          ; DD CB 7E B3
 ld e, res 6, (iy-128)          ; DD CB 80 B3
 ld e, res 7, (ix)              ; FD CB 00 BB
 ld e, res 7, (ix+0)            ; FD CB 00 BB
 ld e, res 7, (ix+126)          ; FD CB 7E BB
 ld e, res 7, (ix-128)          ; FD CB 80 BB
 ld e, res 7, (iy)              ; DD CB 00 BB
 ld e, res 7, (iy+0)            ; DD CB 00 BB
 ld e, res 7, (iy+126)          ; DD CB 7E BB
 ld e, res 7, (iy-128)          ; DD CB 80 BB
 ld e, rl (ix)                  ; FD CB 00 13
 ld e, rl (ix+0)                ; FD CB 00 13
 ld e, rl (ix+126)              ; FD CB 7E 13
 ld e, rl (ix-128)              ; FD CB 80 13
 ld e, rl (iy)                  ; DD CB 00 13
 ld e, rl (iy+0)                ; DD CB 00 13
 ld e, rl (iy+126)              ; DD CB 7E 13
 ld e, rl (iy-128)              ; DD CB 80 13
 ld e, rlc (ix)                 ; FD CB 00 03
 ld e, rlc (ix+0)               ; FD CB 00 03
 ld e, rlc (ix+126)             ; FD CB 7E 03
 ld e, rlc (ix-128)             ; FD CB 80 03
 ld e, rlc (iy)                 ; DD CB 00 03
 ld e, rlc (iy+0)               ; DD CB 00 03
 ld e, rlc (iy+126)             ; DD CB 7E 03
 ld e, rlc (iy-128)             ; DD CB 80 03
 ld e, rr (ix)                  ; FD CB 00 1B
 ld e, rr (ix+0)                ; FD CB 00 1B
 ld e, rr (ix+126)              ; FD CB 7E 1B
 ld e, rr (ix-128)              ; FD CB 80 1B
 ld e, rr (iy)                  ; DD CB 00 1B
 ld e, rr (iy+0)                ; DD CB 00 1B
 ld e, rr (iy+126)              ; DD CB 7E 1B
 ld e, rr (iy-128)              ; DD CB 80 1B
 ld e, rrc (ix)                 ; FD CB 00 0B
 ld e, rrc (ix+0)               ; FD CB 00 0B
 ld e, rrc (ix+126)             ; FD CB 7E 0B
 ld e, rrc (ix-128)             ; FD CB 80 0B
 ld e, rrc (iy)                 ; DD CB 00 0B
 ld e, rrc (iy+0)               ; DD CB 00 0B
 ld e, rrc (iy+126)             ; DD CB 7E 0B
 ld e, rrc (iy-128)             ; DD CB 80 0B
 ld e, set 0, (ix)              ; FD CB 00 C3
 ld e, set 0, (ix+0)            ; FD CB 00 C3
 ld e, set 0, (ix+126)          ; FD CB 7E C3
 ld e, set 0, (ix-128)          ; FD CB 80 C3
 ld e, set 0, (iy)              ; DD CB 00 C3
 ld e, set 0, (iy+0)            ; DD CB 00 C3
 ld e, set 0, (iy+126)          ; DD CB 7E C3
 ld e, set 0, (iy-128)          ; DD CB 80 C3
 ld e, set 1, (ix)              ; FD CB 00 CB
 ld e, set 1, (ix+0)            ; FD CB 00 CB
 ld e, set 1, (ix+126)          ; FD CB 7E CB
 ld e, set 1, (ix-128)          ; FD CB 80 CB
 ld e, set 1, (iy)              ; DD CB 00 CB
 ld e, set 1, (iy+0)            ; DD CB 00 CB
 ld e, set 1, (iy+126)          ; DD CB 7E CB
 ld e, set 1, (iy-128)          ; DD CB 80 CB
 ld e, set 2, (ix)              ; FD CB 00 D3
 ld e, set 2, (ix+0)            ; FD CB 00 D3
 ld e, set 2, (ix+126)          ; FD CB 7E D3
 ld e, set 2, (ix-128)          ; FD CB 80 D3
 ld e, set 2, (iy)              ; DD CB 00 D3
 ld e, set 2, (iy+0)            ; DD CB 00 D3
 ld e, set 2, (iy+126)          ; DD CB 7E D3
 ld e, set 2, (iy-128)          ; DD CB 80 D3
 ld e, set 3, (ix)              ; FD CB 00 DB
 ld e, set 3, (ix+0)            ; FD CB 00 DB
 ld e, set 3, (ix+126)          ; FD CB 7E DB
 ld e, set 3, (ix-128)          ; FD CB 80 DB
 ld e, set 3, (iy)              ; DD CB 00 DB
 ld e, set 3, (iy+0)            ; DD CB 00 DB
 ld e, set 3, (iy+126)          ; DD CB 7E DB
 ld e, set 3, (iy-128)          ; DD CB 80 DB
 ld e, set 4, (ix)              ; FD CB 00 E3
 ld e, set 4, (ix+0)            ; FD CB 00 E3
 ld e, set 4, (ix+126)          ; FD CB 7E E3
 ld e, set 4, (ix-128)          ; FD CB 80 E3
 ld e, set 4, (iy)              ; DD CB 00 E3
 ld e, set 4, (iy+0)            ; DD CB 00 E3
 ld e, set 4, (iy+126)          ; DD CB 7E E3
 ld e, set 4, (iy-128)          ; DD CB 80 E3
 ld e, set 5, (ix)              ; FD CB 00 EB
 ld e, set 5, (ix+0)            ; FD CB 00 EB
 ld e, set 5, (ix+126)          ; FD CB 7E EB
 ld e, set 5, (ix-128)          ; FD CB 80 EB
 ld e, set 5, (iy)              ; DD CB 00 EB
 ld e, set 5, (iy+0)            ; DD CB 00 EB
 ld e, set 5, (iy+126)          ; DD CB 7E EB
 ld e, set 5, (iy-128)          ; DD CB 80 EB
 ld e, set 6, (ix)              ; FD CB 00 F3
 ld e, set 6, (ix+0)            ; FD CB 00 F3
 ld e, set 6, (ix+126)          ; FD CB 7E F3
 ld e, set 6, (ix-128)          ; FD CB 80 F3
 ld e, set 6, (iy)              ; DD CB 00 F3
 ld e, set 6, (iy+0)            ; DD CB 00 F3
 ld e, set 6, (iy+126)          ; DD CB 7E F3
 ld e, set 6, (iy-128)          ; DD CB 80 F3
 ld e, set 7, (ix)              ; FD CB 00 FB
 ld e, set 7, (ix+0)            ; FD CB 00 FB
 ld e, set 7, (ix+126)          ; FD CB 7E FB
 ld e, set 7, (ix-128)          ; FD CB 80 FB
 ld e, set 7, (iy)              ; DD CB 00 FB
 ld e, set 7, (iy+0)            ; DD CB 00 FB
 ld e, set 7, (iy+126)          ; DD CB 7E FB
 ld e, set 7, (iy-128)          ; DD CB 80 FB
 ld e, sla (ix)                 ; FD CB 00 23
 ld e, sla (ix+0)               ; FD CB 00 23
 ld e, sla (ix+126)             ; FD CB 7E 23
 ld e, sla (ix-128)             ; FD CB 80 23
 ld e, sla (iy)                 ; DD CB 00 23
 ld e, sla (iy+0)               ; DD CB 00 23
 ld e, sla (iy+126)             ; DD CB 7E 23
 ld e, sla (iy-128)             ; DD CB 80 23
 ld e, sli (ix)                 ; FD CB 00 33
 ld e, sli (ix+0)               ; FD CB 00 33
 ld e, sli (ix+126)             ; FD CB 7E 33
 ld e, sli (ix-128)             ; FD CB 80 33
 ld e, sli (iy)                 ; DD CB 00 33
 ld e, sli (iy+0)               ; DD CB 00 33
 ld e, sli (iy+126)             ; DD CB 7E 33
 ld e, sli (iy-128)             ; DD CB 80 33
 ld e, sll (ix)                 ; FD CB 00 33
 ld e, sll (ix+0)               ; FD CB 00 33
 ld e, sll (ix+126)             ; FD CB 7E 33
 ld e, sll (ix-128)             ; FD CB 80 33
 ld e, sll (iy)                 ; DD CB 00 33
 ld e, sll (iy+0)               ; DD CB 00 33
 ld e, sll (iy+126)             ; DD CB 7E 33
 ld e, sll (iy-128)             ; DD CB 80 33
 ld e, sls (ix)                 ; FD CB 00 33
 ld e, sls (ix+0)               ; FD CB 00 33
 ld e, sls (ix+126)             ; FD CB 7E 33
 ld e, sls (ix-128)             ; FD CB 80 33
 ld e, sls (iy)                 ; DD CB 00 33
 ld e, sls (iy+0)               ; DD CB 00 33
 ld e, sls (iy+126)             ; DD CB 7E 33
 ld e, sls (iy-128)             ; DD CB 80 33
 ld e, sra (ix)                 ; FD CB 00 2B
 ld e, sra (ix+0)               ; FD CB 00 2B
 ld e, sra (ix+126)             ; FD CB 7E 2B
 ld e, sra (ix-128)             ; FD CB 80 2B
 ld e, sra (iy)                 ; DD CB 00 2B
 ld e, sra (iy+0)               ; DD CB 00 2B
 ld e, sra (iy+126)             ; DD CB 7E 2B
 ld e, sra (iy-128)             ; DD CB 80 2B
 ld e, srl (ix)                 ; FD CB 00 3B
 ld e, srl (ix+0)               ; FD CB 00 3B
 ld e, srl (ix+126)             ; FD CB 7E 3B
 ld e, srl (ix-128)             ; FD CB 80 3B
 ld e, srl (iy)                 ; DD CB 00 3B
 ld e, srl (iy+0)               ; DD CB 00 3B
 ld e, srl (iy+126)             ; DD CB 7E 3B
 ld e, srl (iy-128)             ; DD CB 80 3B
 ld h, (hl)                     ; 66
 ld h, (ix)                     ; FD 66 00
 ld h, (ix+0)                   ; FD 66 00
 ld h, (ix+126)                 ; FD 66 7E
 ld h, (ix-128)                 ; FD 66 80
 ld h, (iy)                     ; DD 66 00
 ld h, (iy+0)                   ; DD 66 00
 ld h, (iy+126)                 ; DD 66 7E
 ld h, (iy-128)                 ; DD 66 80
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
 ld h, res 0, (ix)              ; FD CB 00 84
 ld h, res 0, (ix+0)            ; FD CB 00 84
 ld h, res 0, (ix+126)          ; FD CB 7E 84
 ld h, res 0, (ix-128)          ; FD CB 80 84
 ld h, res 0, (iy)              ; DD CB 00 84
 ld h, res 0, (iy+0)            ; DD CB 00 84
 ld h, res 0, (iy+126)          ; DD CB 7E 84
 ld h, res 0, (iy-128)          ; DD CB 80 84
 ld h, res 1, (ix)              ; FD CB 00 8C
 ld h, res 1, (ix+0)            ; FD CB 00 8C
 ld h, res 1, (ix+126)          ; FD CB 7E 8C
 ld h, res 1, (ix-128)          ; FD CB 80 8C
 ld h, res 1, (iy)              ; DD CB 00 8C
 ld h, res 1, (iy+0)            ; DD CB 00 8C
 ld h, res 1, (iy+126)          ; DD CB 7E 8C
 ld h, res 1, (iy-128)          ; DD CB 80 8C
 ld h, res 2, (ix)              ; FD CB 00 94
 ld h, res 2, (ix+0)            ; FD CB 00 94
 ld h, res 2, (ix+126)          ; FD CB 7E 94
 ld h, res 2, (ix-128)          ; FD CB 80 94
 ld h, res 2, (iy)              ; DD CB 00 94
 ld h, res 2, (iy+0)            ; DD CB 00 94
 ld h, res 2, (iy+126)          ; DD CB 7E 94
 ld h, res 2, (iy-128)          ; DD CB 80 94
 ld h, res 3, (ix)              ; FD CB 00 9C
 ld h, res 3, (ix+0)            ; FD CB 00 9C
 ld h, res 3, (ix+126)          ; FD CB 7E 9C
 ld h, res 3, (ix-128)          ; FD CB 80 9C
 ld h, res 3, (iy)              ; DD CB 00 9C
 ld h, res 3, (iy+0)            ; DD CB 00 9C
 ld h, res 3, (iy+126)          ; DD CB 7E 9C
 ld h, res 3, (iy-128)          ; DD CB 80 9C
 ld h, res 4, (ix)              ; FD CB 00 A4
 ld h, res 4, (ix+0)            ; FD CB 00 A4
 ld h, res 4, (ix+126)          ; FD CB 7E A4
 ld h, res 4, (ix-128)          ; FD CB 80 A4
 ld h, res 4, (iy)              ; DD CB 00 A4
 ld h, res 4, (iy+0)            ; DD CB 00 A4
 ld h, res 4, (iy+126)          ; DD CB 7E A4
 ld h, res 4, (iy-128)          ; DD CB 80 A4
 ld h, res 5, (ix)              ; FD CB 00 AC
 ld h, res 5, (ix+0)            ; FD CB 00 AC
 ld h, res 5, (ix+126)          ; FD CB 7E AC
 ld h, res 5, (ix-128)          ; FD CB 80 AC
 ld h, res 5, (iy)              ; DD CB 00 AC
 ld h, res 5, (iy+0)            ; DD CB 00 AC
 ld h, res 5, (iy+126)          ; DD CB 7E AC
 ld h, res 5, (iy-128)          ; DD CB 80 AC
 ld h, res 6, (ix)              ; FD CB 00 B4
 ld h, res 6, (ix+0)            ; FD CB 00 B4
 ld h, res 6, (ix+126)          ; FD CB 7E B4
 ld h, res 6, (ix-128)          ; FD CB 80 B4
 ld h, res 6, (iy)              ; DD CB 00 B4
 ld h, res 6, (iy+0)            ; DD CB 00 B4
 ld h, res 6, (iy+126)          ; DD CB 7E B4
 ld h, res 6, (iy-128)          ; DD CB 80 B4
 ld h, res 7, (ix)              ; FD CB 00 BC
 ld h, res 7, (ix+0)            ; FD CB 00 BC
 ld h, res 7, (ix+126)          ; FD CB 7E BC
 ld h, res 7, (ix-128)          ; FD CB 80 BC
 ld h, res 7, (iy)              ; DD CB 00 BC
 ld h, res 7, (iy+0)            ; DD CB 00 BC
 ld h, res 7, (iy+126)          ; DD CB 7E BC
 ld h, res 7, (iy-128)          ; DD CB 80 BC
 ld h, rl (ix)                  ; FD CB 00 14
 ld h, rl (ix+0)                ; FD CB 00 14
 ld h, rl (ix+126)              ; FD CB 7E 14
 ld h, rl (ix-128)              ; FD CB 80 14
 ld h, rl (iy)                  ; DD CB 00 14
 ld h, rl (iy+0)                ; DD CB 00 14
 ld h, rl (iy+126)              ; DD CB 7E 14
 ld h, rl (iy-128)              ; DD CB 80 14
 ld h, rlc (ix)                 ; FD CB 00 04
 ld h, rlc (ix+0)               ; FD CB 00 04
 ld h, rlc (ix+126)             ; FD CB 7E 04
 ld h, rlc (ix-128)             ; FD CB 80 04
 ld h, rlc (iy)                 ; DD CB 00 04
 ld h, rlc (iy+0)               ; DD CB 00 04
 ld h, rlc (iy+126)             ; DD CB 7E 04
 ld h, rlc (iy-128)             ; DD CB 80 04
 ld h, rr (ix)                  ; FD CB 00 1C
 ld h, rr (ix+0)                ; FD CB 00 1C
 ld h, rr (ix+126)              ; FD CB 7E 1C
 ld h, rr (ix-128)              ; FD CB 80 1C
 ld h, rr (iy)                  ; DD CB 00 1C
 ld h, rr (iy+0)                ; DD CB 00 1C
 ld h, rr (iy+126)              ; DD CB 7E 1C
 ld h, rr (iy-128)              ; DD CB 80 1C
 ld h, rrc (ix)                 ; FD CB 00 0C
 ld h, rrc (ix+0)               ; FD CB 00 0C
 ld h, rrc (ix+126)             ; FD CB 7E 0C
 ld h, rrc (ix-128)             ; FD CB 80 0C
 ld h, rrc (iy)                 ; DD CB 00 0C
 ld h, rrc (iy+0)               ; DD CB 00 0C
 ld h, rrc (iy+126)             ; DD CB 7E 0C
 ld h, rrc (iy-128)             ; DD CB 80 0C
 ld h, set 0, (ix)              ; FD CB 00 C4
 ld h, set 0, (ix+0)            ; FD CB 00 C4
 ld h, set 0, (ix+126)          ; FD CB 7E C4
 ld h, set 0, (ix-128)          ; FD CB 80 C4
 ld h, set 0, (iy)              ; DD CB 00 C4
 ld h, set 0, (iy+0)            ; DD CB 00 C4
 ld h, set 0, (iy+126)          ; DD CB 7E C4
 ld h, set 0, (iy-128)          ; DD CB 80 C4
 ld h, set 1, (ix)              ; FD CB 00 CC
 ld h, set 1, (ix+0)            ; FD CB 00 CC
 ld h, set 1, (ix+126)          ; FD CB 7E CC
 ld h, set 1, (ix-128)          ; FD CB 80 CC
 ld h, set 1, (iy)              ; DD CB 00 CC
 ld h, set 1, (iy+0)            ; DD CB 00 CC
 ld h, set 1, (iy+126)          ; DD CB 7E CC
 ld h, set 1, (iy-128)          ; DD CB 80 CC
 ld h, set 2, (ix)              ; FD CB 00 D4
 ld h, set 2, (ix+0)            ; FD CB 00 D4
 ld h, set 2, (ix+126)          ; FD CB 7E D4
 ld h, set 2, (ix-128)          ; FD CB 80 D4
 ld h, set 2, (iy)              ; DD CB 00 D4
 ld h, set 2, (iy+0)            ; DD CB 00 D4
 ld h, set 2, (iy+126)          ; DD CB 7E D4
 ld h, set 2, (iy-128)          ; DD CB 80 D4
 ld h, set 3, (ix)              ; FD CB 00 DC
 ld h, set 3, (ix+0)            ; FD CB 00 DC
 ld h, set 3, (ix+126)          ; FD CB 7E DC
 ld h, set 3, (ix-128)          ; FD CB 80 DC
 ld h, set 3, (iy)              ; DD CB 00 DC
 ld h, set 3, (iy+0)            ; DD CB 00 DC
 ld h, set 3, (iy+126)          ; DD CB 7E DC
 ld h, set 3, (iy-128)          ; DD CB 80 DC
 ld h, set 4, (ix)              ; FD CB 00 E4
 ld h, set 4, (ix+0)            ; FD CB 00 E4
 ld h, set 4, (ix+126)          ; FD CB 7E E4
 ld h, set 4, (ix-128)          ; FD CB 80 E4
 ld h, set 4, (iy)              ; DD CB 00 E4
 ld h, set 4, (iy+0)            ; DD CB 00 E4
 ld h, set 4, (iy+126)          ; DD CB 7E E4
 ld h, set 4, (iy-128)          ; DD CB 80 E4
 ld h, set 5, (ix)              ; FD CB 00 EC
 ld h, set 5, (ix+0)            ; FD CB 00 EC
 ld h, set 5, (ix+126)          ; FD CB 7E EC
 ld h, set 5, (ix-128)          ; FD CB 80 EC
 ld h, set 5, (iy)              ; DD CB 00 EC
 ld h, set 5, (iy+0)            ; DD CB 00 EC
 ld h, set 5, (iy+126)          ; DD CB 7E EC
 ld h, set 5, (iy-128)          ; DD CB 80 EC
 ld h, set 6, (ix)              ; FD CB 00 F4
 ld h, set 6, (ix+0)            ; FD CB 00 F4
 ld h, set 6, (ix+126)          ; FD CB 7E F4
 ld h, set 6, (ix-128)          ; FD CB 80 F4
 ld h, set 6, (iy)              ; DD CB 00 F4
 ld h, set 6, (iy+0)            ; DD CB 00 F4
 ld h, set 6, (iy+126)          ; DD CB 7E F4
 ld h, set 6, (iy-128)          ; DD CB 80 F4
 ld h, set 7, (ix)              ; FD CB 00 FC
 ld h, set 7, (ix+0)            ; FD CB 00 FC
 ld h, set 7, (ix+126)          ; FD CB 7E FC
 ld h, set 7, (ix-128)          ; FD CB 80 FC
 ld h, set 7, (iy)              ; DD CB 00 FC
 ld h, set 7, (iy+0)            ; DD CB 00 FC
 ld h, set 7, (iy+126)          ; DD CB 7E FC
 ld h, set 7, (iy-128)          ; DD CB 80 FC
 ld h, sla (ix)                 ; FD CB 00 24
 ld h, sla (ix+0)               ; FD CB 00 24
 ld h, sla (ix+126)             ; FD CB 7E 24
 ld h, sla (ix-128)             ; FD CB 80 24
 ld h, sla (iy)                 ; DD CB 00 24
 ld h, sla (iy+0)               ; DD CB 00 24
 ld h, sla (iy+126)             ; DD CB 7E 24
 ld h, sla (iy-128)             ; DD CB 80 24
 ld h, sli (ix)                 ; FD CB 00 34
 ld h, sli (ix+0)               ; FD CB 00 34
 ld h, sli (ix+126)             ; FD CB 7E 34
 ld h, sli (ix-128)             ; FD CB 80 34
 ld h, sli (iy)                 ; DD CB 00 34
 ld h, sli (iy+0)               ; DD CB 00 34
 ld h, sli (iy+126)             ; DD CB 7E 34
 ld h, sli (iy-128)             ; DD CB 80 34
 ld h, sll (ix)                 ; FD CB 00 34
 ld h, sll (ix+0)               ; FD CB 00 34
 ld h, sll (ix+126)             ; FD CB 7E 34
 ld h, sll (ix-128)             ; FD CB 80 34
 ld h, sll (iy)                 ; DD CB 00 34
 ld h, sll (iy+0)               ; DD CB 00 34
 ld h, sll (iy+126)             ; DD CB 7E 34
 ld h, sll (iy-128)             ; DD CB 80 34
 ld h, sls (ix)                 ; FD CB 00 34
 ld h, sls (ix+0)               ; FD CB 00 34
 ld h, sls (ix+126)             ; FD CB 7E 34
 ld h, sls (ix-128)             ; FD CB 80 34
 ld h, sls (iy)                 ; DD CB 00 34
 ld h, sls (iy+0)               ; DD CB 00 34
 ld h, sls (iy+126)             ; DD CB 7E 34
 ld h, sls (iy-128)             ; DD CB 80 34
 ld h, sra (ix)                 ; FD CB 00 2C
 ld h, sra (ix+0)               ; FD CB 00 2C
 ld h, sra (ix+126)             ; FD CB 7E 2C
 ld h, sra (ix-128)             ; FD CB 80 2C
 ld h, sra (iy)                 ; DD CB 00 2C
 ld h, sra (iy+0)               ; DD CB 00 2C
 ld h, sra (iy+126)             ; DD CB 7E 2C
 ld h, sra (iy-128)             ; DD CB 80 2C
 ld h, srl (ix)                 ; FD CB 00 3C
 ld h, srl (ix+0)               ; FD CB 00 3C
 ld h, srl (ix+126)             ; FD CB 7E 3C
 ld h, srl (ix-128)             ; FD CB 80 3C
 ld h, srl (iy)                 ; DD CB 00 3C
 ld h, srl (iy+0)               ; DD CB 00 3C
 ld h, srl (iy+126)             ; DD CB 7E 3C
 ld h, srl (iy-128)             ; DD CB 80 3C
 ld hl, (0x1234)                ; 2A 34 12
 ld hl, 0x1234                  ; 21 34 12
 ld i, a                        ; ED 47
 ld ix, (0x1234)                ; FD 2A 34 12
 ld ix, 0x1234                  ; FD 21 34 12
 ld ixh, 0                      ; FD 26 00
 ld ixh, 127                    ; FD 26 7F
 ld ixh, 255                    ; FD 26 FF
 ld ixh, a                      ; FD 67
 ld ixh, b                      ; FD 60
 ld ixh, c                      ; FD 61
 ld ixh, d                      ; FD 62
 ld ixh, e                      ; FD 63
 ld ixh, ixh                    ; FD 64
 ld ixh, ixl                    ; FD 65
 ld ixl, 0                      ; FD 2E 00
 ld ixl, 127                    ; FD 2E 7F
 ld ixl, 255                    ; FD 2E FF
 ld ixl, a                      ; FD 6F
 ld ixl, b                      ; FD 68
 ld ixl, c                      ; FD 69
 ld ixl, d                      ; FD 6A
 ld ixl, e                      ; FD 6B
 ld ixl, ixh                    ; FD 6C
 ld ixl, ixl                    ; FD 6D
 ld iy, (0x1234)                ; DD 2A 34 12
 ld iy, 0x1234                  ; DD 21 34 12
 ld iyh, 0                      ; DD 26 00
 ld iyh, 127                    ; DD 26 7F
 ld iyh, 255                    ; DD 26 FF
 ld iyh, a                      ; DD 67
 ld iyh, b                      ; DD 60
 ld iyh, c                      ; DD 61
 ld iyh, d                      ; DD 62
 ld iyh, e                      ; DD 63
 ld iyh, iyh                    ; DD 64
 ld iyh, iyl                    ; DD 65
 ld iyl, 0                      ; DD 2E 00
 ld iyl, 127                    ; DD 2E 7F
 ld iyl, 255                    ; DD 2E FF
 ld iyl, a                      ; DD 6F
 ld iyl, b                      ; DD 68
 ld iyl, c                      ; DD 69
 ld iyl, d                      ; DD 6A
 ld iyl, e                      ; DD 6B
 ld iyl, iyh                    ; DD 6C
 ld iyl, iyl                    ; DD 6D
 ld l, (hl)                     ; 6E
 ld l, (ix)                     ; FD 6E 00
 ld l, (ix+0)                   ; FD 6E 00
 ld l, (ix+126)                 ; FD 6E 7E
 ld l, (ix-128)                 ; FD 6E 80
 ld l, (iy)                     ; DD 6E 00
 ld l, (iy+0)                   ; DD 6E 00
 ld l, (iy+126)                 ; DD 6E 7E
 ld l, (iy-128)                 ; DD 6E 80
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
 ld l, res 0, (ix)              ; FD CB 00 85
 ld l, res 0, (ix+0)            ; FD CB 00 85
 ld l, res 0, (ix+126)          ; FD CB 7E 85
 ld l, res 0, (ix-128)          ; FD CB 80 85
 ld l, res 0, (iy)              ; DD CB 00 85
 ld l, res 0, (iy+0)            ; DD CB 00 85
 ld l, res 0, (iy+126)          ; DD CB 7E 85
 ld l, res 0, (iy-128)          ; DD CB 80 85
 ld l, res 1, (ix)              ; FD CB 00 8D
 ld l, res 1, (ix+0)            ; FD CB 00 8D
 ld l, res 1, (ix+126)          ; FD CB 7E 8D
 ld l, res 1, (ix-128)          ; FD CB 80 8D
 ld l, res 1, (iy)              ; DD CB 00 8D
 ld l, res 1, (iy+0)            ; DD CB 00 8D
 ld l, res 1, (iy+126)          ; DD CB 7E 8D
 ld l, res 1, (iy-128)          ; DD CB 80 8D
 ld l, res 2, (ix)              ; FD CB 00 95
 ld l, res 2, (ix+0)            ; FD CB 00 95
 ld l, res 2, (ix+126)          ; FD CB 7E 95
 ld l, res 2, (ix-128)          ; FD CB 80 95
 ld l, res 2, (iy)              ; DD CB 00 95
 ld l, res 2, (iy+0)            ; DD CB 00 95
 ld l, res 2, (iy+126)          ; DD CB 7E 95
 ld l, res 2, (iy-128)          ; DD CB 80 95
 ld l, res 3, (ix)              ; FD CB 00 9D
 ld l, res 3, (ix+0)            ; FD CB 00 9D
 ld l, res 3, (ix+126)          ; FD CB 7E 9D
 ld l, res 3, (ix-128)          ; FD CB 80 9D
 ld l, res 3, (iy)              ; DD CB 00 9D
 ld l, res 3, (iy+0)            ; DD CB 00 9D
 ld l, res 3, (iy+126)          ; DD CB 7E 9D
 ld l, res 3, (iy-128)          ; DD CB 80 9D
 ld l, res 4, (ix)              ; FD CB 00 A5
 ld l, res 4, (ix+0)            ; FD CB 00 A5
 ld l, res 4, (ix+126)          ; FD CB 7E A5
 ld l, res 4, (ix-128)          ; FD CB 80 A5
 ld l, res 4, (iy)              ; DD CB 00 A5
 ld l, res 4, (iy+0)            ; DD CB 00 A5
 ld l, res 4, (iy+126)          ; DD CB 7E A5
 ld l, res 4, (iy-128)          ; DD CB 80 A5
 ld l, res 5, (ix)              ; FD CB 00 AD
 ld l, res 5, (ix+0)            ; FD CB 00 AD
 ld l, res 5, (ix+126)          ; FD CB 7E AD
 ld l, res 5, (ix-128)          ; FD CB 80 AD
 ld l, res 5, (iy)              ; DD CB 00 AD
 ld l, res 5, (iy+0)            ; DD CB 00 AD
 ld l, res 5, (iy+126)          ; DD CB 7E AD
 ld l, res 5, (iy-128)          ; DD CB 80 AD
 ld l, res 6, (ix)              ; FD CB 00 B5
 ld l, res 6, (ix+0)            ; FD CB 00 B5
 ld l, res 6, (ix+126)          ; FD CB 7E B5
 ld l, res 6, (ix-128)          ; FD CB 80 B5
 ld l, res 6, (iy)              ; DD CB 00 B5
 ld l, res 6, (iy+0)            ; DD CB 00 B5
 ld l, res 6, (iy+126)          ; DD CB 7E B5
 ld l, res 6, (iy-128)          ; DD CB 80 B5
 ld l, res 7, (ix)              ; FD CB 00 BD
 ld l, res 7, (ix+0)            ; FD CB 00 BD
 ld l, res 7, (ix+126)          ; FD CB 7E BD
 ld l, res 7, (ix-128)          ; FD CB 80 BD
 ld l, res 7, (iy)              ; DD CB 00 BD
 ld l, res 7, (iy+0)            ; DD CB 00 BD
 ld l, res 7, (iy+126)          ; DD CB 7E BD
 ld l, res 7, (iy-128)          ; DD CB 80 BD
 ld l, rl (ix)                  ; FD CB 00 15
 ld l, rl (ix+0)                ; FD CB 00 15
 ld l, rl (ix+126)              ; FD CB 7E 15
 ld l, rl (ix-128)              ; FD CB 80 15
 ld l, rl (iy)                  ; DD CB 00 15
 ld l, rl (iy+0)                ; DD CB 00 15
 ld l, rl (iy+126)              ; DD CB 7E 15
 ld l, rl (iy-128)              ; DD CB 80 15
 ld l, rlc (ix)                 ; FD CB 00 05
 ld l, rlc (ix+0)               ; FD CB 00 05
 ld l, rlc (ix+126)             ; FD CB 7E 05
 ld l, rlc (ix-128)             ; FD CB 80 05
 ld l, rlc (iy)                 ; DD CB 00 05
 ld l, rlc (iy+0)               ; DD CB 00 05
 ld l, rlc (iy+126)             ; DD CB 7E 05
 ld l, rlc (iy-128)             ; DD CB 80 05
 ld l, rr (ix)                  ; FD CB 00 1D
 ld l, rr (ix+0)                ; FD CB 00 1D
 ld l, rr (ix+126)              ; FD CB 7E 1D
 ld l, rr (ix-128)              ; FD CB 80 1D
 ld l, rr (iy)                  ; DD CB 00 1D
 ld l, rr (iy+0)                ; DD CB 00 1D
 ld l, rr (iy+126)              ; DD CB 7E 1D
 ld l, rr (iy-128)              ; DD CB 80 1D
 ld l, rrc (ix)                 ; FD CB 00 0D
 ld l, rrc (ix+0)               ; FD CB 00 0D
 ld l, rrc (ix+126)             ; FD CB 7E 0D
 ld l, rrc (ix-128)             ; FD CB 80 0D
 ld l, rrc (iy)                 ; DD CB 00 0D
 ld l, rrc (iy+0)               ; DD CB 00 0D
 ld l, rrc (iy+126)             ; DD CB 7E 0D
 ld l, rrc (iy-128)             ; DD CB 80 0D
 ld l, set 0, (ix)              ; FD CB 00 C5
 ld l, set 0, (ix+0)            ; FD CB 00 C5
 ld l, set 0, (ix+126)          ; FD CB 7E C5
 ld l, set 0, (ix-128)          ; FD CB 80 C5
 ld l, set 0, (iy)              ; DD CB 00 C5
 ld l, set 0, (iy+0)            ; DD CB 00 C5
 ld l, set 0, (iy+126)          ; DD CB 7E C5
 ld l, set 0, (iy-128)          ; DD CB 80 C5
 ld l, set 1, (ix)              ; FD CB 00 CD
 ld l, set 1, (ix+0)            ; FD CB 00 CD
 ld l, set 1, (ix+126)          ; FD CB 7E CD
 ld l, set 1, (ix-128)          ; FD CB 80 CD
 ld l, set 1, (iy)              ; DD CB 00 CD
 ld l, set 1, (iy+0)            ; DD CB 00 CD
 ld l, set 1, (iy+126)          ; DD CB 7E CD
 ld l, set 1, (iy-128)          ; DD CB 80 CD
 ld l, set 2, (ix)              ; FD CB 00 D5
 ld l, set 2, (ix+0)            ; FD CB 00 D5
 ld l, set 2, (ix+126)          ; FD CB 7E D5
 ld l, set 2, (ix-128)          ; FD CB 80 D5
 ld l, set 2, (iy)              ; DD CB 00 D5
 ld l, set 2, (iy+0)            ; DD CB 00 D5
 ld l, set 2, (iy+126)          ; DD CB 7E D5
 ld l, set 2, (iy-128)          ; DD CB 80 D5
 ld l, set 3, (ix)              ; FD CB 00 DD
 ld l, set 3, (ix+0)            ; FD CB 00 DD
 ld l, set 3, (ix+126)          ; FD CB 7E DD
 ld l, set 3, (ix-128)          ; FD CB 80 DD
 ld l, set 3, (iy)              ; DD CB 00 DD
 ld l, set 3, (iy+0)            ; DD CB 00 DD
 ld l, set 3, (iy+126)          ; DD CB 7E DD
 ld l, set 3, (iy-128)          ; DD CB 80 DD
 ld l, set 4, (ix)              ; FD CB 00 E5
 ld l, set 4, (ix+0)            ; FD CB 00 E5
 ld l, set 4, (ix+126)          ; FD CB 7E E5
 ld l, set 4, (ix-128)          ; FD CB 80 E5
 ld l, set 4, (iy)              ; DD CB 00 E5
 ld l, set 4, (iy+0)            ; DD CB 00 E5
 ld l, set 4, (iy+126)          ; DD CB 7E E5
 ld l, set 4, (iy-128)          ; DD CB 80 E5
 ld l, set 5, (ix)              ; FD CB 00 ED
 ld l, set 5, (ix+0)            ; FD CB 00 ED
 ld l, set 5, (ix+126)          ; FD CB 7E ED
 ld l, set 5, (ix-128)          ; FD CB 80 ED
 ld l, set 5, (iy)              ; DD CB 00 ED
 ld l, set 5, (iy+0)            ; DD CB 00 ED
 ld l, set 5, (iy+126)          ; DD CB 7E ED
 ld l, set 5, (iy-128)          ; DD CB 80 ED
 ld l, set 6, (ix)              ; FD CB 00 F5
 ld l, set 6, (ix+0)            ; FD CB 00 F5
 ld l, set 6, (ix+126)          ; FD CB 7E F5
 ld l, set 6, (ix-128)          ; FD CB 80 F5
 ld l, set 6, (iy)              ; DD CB 00 F5
 ld l, set 6, (iy+0)            ; DD CB 00 F5
 ld l, set 6, (iy+126)          ; DD CB 7E F5
 ld l, set 6, (iy-128)          ; DD CB 80 F5
 ld l, set 7, (ix)              ; FD CB 00 FD
 ld l, set 7, (ix+0)            ; FD CB 00 FD
 ld l, set 7, (ix+126)          ; FD CB 7E FD
 ld l, set 7, (ix-128)          ; FD CB 80 FD
 ld l, set 7, (iy)              ; DD CB 00 FD
 ld l, set 7, (iy+0)            ; DD CB 00 FD
 ld l, set 7, (iy+126)          ; DD CB 7E FD
 ld l, set 7, (iy-128)          ; DD CB 80 FD
 ld l, sla (ix)                 ; FD CB 00 25
 ld l, sla (ix+0)               ; FD CB 00 25
 ld l, sla (ix+126)             ; FD CB 7E 25
 ld l, sla (ix-128)             ; FD CB 80 25
 ld l, sla (iy)                 ; DD CB 00 25
 ld l, sla (iy+0)               ; DD CB 00 25
 ld l, sla (iy+126)             ; DD CB 7E 25
 ld l, sla (iy-128)             ; DD CB 80 25
 ld l, sli (ix)                 ; FD CB 00 35
 ld l, sli (ix+0)               ; FD CB 00 35
 ld l, sli (ix+126)             ; FD CB 7E 35
 ld l, sli (ix-128)             ; FD CB 80 35
 ld l, sli (iy)                 ; DD CB 00 35
 ld l, sli (iy+0)               ; DD CB 00 35
 ld l, sli (iy+126)             ; DD CB 7E 35
 ld l, sli (iy-128)             ; DD CB 80 35
 ld l, sll (ix)                 ; FD CB 00 35
 ld l, sll (ix+0)               ; FD CB 00 35
 ld l, sll (ix+126)             ; FD CB 7E 35
 ld l, sll (ix-128)             ; FD CB 80 35
 ld l, sll (iy)                 ; DD CB 00 35
 ld l, sll (iy+0)               ; DD CB 00 35
 ld l, sll (iy+126)             ; DD CB 7E 35
 ld l, sll (iy-128)             ; DD CB 80 35
 ld l, sls (ix)                 ; FD CB 00 35
 ld l, sls (ix+0)               ; FD CB 00 35
 ld l, sls (ix+126)             ; FD CB 7E 35
 ld l, sls (ix-128)             ; FD CB 80 35
 ld l, sls (iy)                 ; DD CB 00 35
 ld l, sls (iy+0)               ; DD CB 00 35
 ld l, sls (iy+126)             ; DD CB 7E 35
 ld l, sls (iy-128)             ; DD CB 80 35
 ld l, sra (ix)                 ; FD CB 00 2D
 ld l, sra (ix+0)               ; FD CB 00 2D
 ld l, sra (ix+126)             ; FD CB 7E 2D
 ld l, sra (ix-128)             ; FD CB 80 2D
 ld l, sra (iy)                 ; DD CB 00 2D
 ld l, sra (iy+0)               ; DD CB 00 2D
 ld l, sra (iy+126)             ; DD CB 7E 2D
 ld l, sra (iy-128)             ; DD CB 80 2D
 ld l, srl (ix)                 ; FD CB 00 3D
 ld l, srl (ix+0)               ; FD CB 00 3D
 ld l, srl (ix+126)             ; FD CB 7E 3D
 ld l, srl (ix-128)             ; FD CB 80 3D
 ld l, srl (iy)                 ; DD CB 00 3D
 ld l, srl (iy+0)               ; DD CB 00 3D
 ld l, srl (iy+126)             ; DD CB 7E 3D
 ld l, srl (iy-128)             ; DD CB 80 3D
 ld r, a                        ; ED 4F
 ld sp, (0x1234)                ; ED 7B 34 12
 ld sp, 0x1234                  ; 31 34 12
 ld sp, hl                      ; F9
 ld sp, ix                      ; FD F9
 ld sp, iy                      ; DD F9
 ldd                            ; ED A8
 lddr                           ; ED B8
 lddrx                          ; ED BC
 lddx                           ; ED AC
 ldi                            ; ED A0
 ldir                           ; ED B0
 ldirx                          ; ED B4
 ldix                           ; ED A4
 ldpirx                         ; ED B7
 ldrx                           ; ED BC
 ldws                           ; ED A5
 lirx                           ; ED B4
 lprx                           ; ED B7
 mirr                           ; ED 24
 mirror a                       ; ED 24
 mlt de                         ; ED 30
 mmu 0, 0                       ; ED 91 50 00
 mmu 0, 127                     ; ED 91 50 7F
 mmu 0, 255                     ; ED 91 50 FF
 mmu 0, a                       ; ED 92 50
 mmu 1, 0                       ; ED 91 51 00
 mmu 1, 127                     ; ED 91 51 7F
 mmu 1, 255                     ; ED 91 51 FF
 mmu 1, a                       ; ED 92 51
 mmu 2, 0                       ; ED 91 52 00
 mmu 2, 127                     ; ED 91 52 7F
 mmu 2, 255                     ; ED 91 52 FF
 mmu 2, a                       ; ED 92 52
 mmu 3, 0                       ; ED 91 53 00
 mmu 3, 127                     ; ED 91 53 7F
 mmu 3, 255                     ; ED 91 53 FF
 mmu 3, a                       ; ED 92 53
 mmu 4, 0                       ; ED 91 54 00
 mmu 4, 127                     ; ED 91 54 7F
 mmu 4, 255                     ; ED 91 54 FF
 mmu 4, a                       ; ED 92 54
 mmu 5, 0                       ; ED 91 55 00
 mmu 5, 127                     ; ED 91 55 7F
 mmu 5, 255                     ; ED 91 55 FF
 mmu 5, a                       ; ED 92 55
 mmu 6, 0                       ; ED 91 56 00
 mmu 6, 127                     ; ED 91 56 7F
 mmu 6, 255                     ; ED 91 56 FF
 mmu 6, a                       ; ED 92 56
 mmu 7, 0                       ; ED 91 57 00
 mmu 7, 127                     ; ED 91 57 7F
 mmu 7, 255                     ; ED 91 57 FF
 mmu 7, a                       ; ED 92 57
 mul d, e                       ; ED 30
 mul de                         ; ED 30
 neg                            ; ED 44
 nextreg 0, 0                   ; ED 91 00 00
 nextreg 0, 127                 ; ED 91 00 7F
 nextreg 0, 255                 ; ED 91 00 FF
 nextreg 0, a                   ; ED 92 00
 nextreg 127, 0                 ; ED 91 7F 00
 nextreg 127, 127               ; ED 91 7F 7F
 nextreg 127, 255               ; ED 91 7F FF
 nextreg 127, a                 ; ED 92 7F
 nextreg 255, 0                 ; ED 91 FF 00
 nextreg 255, 127               ; ED 91 FF 7F
 nextreg 255, 255               ; ED 91 FF FF
 nextreg 255, a                 ; ED 92 FF
 nop                            ; 00
 nreg 0, 0                      ; ED 91 00 00
 nreg 0, 127                    ; ED 91 00 7F
 nreg 0, 255                    ; ED 91 00 FF
 nreg 0, a                      ; ED 92 00
 nreg 127, 0                    ; ED 91 7F 00
 nreg 127, 127                  ; ED 91 7F 7F
 nreg 127, 255                  ; ED 91 7F FF
 nreg 127, a                    ; ED 92 7F
 nreg 255, 0                    ; ED 91 FF 00
 nreg 255, 127                  ; ED 91 FF 7F
 nreg 255, 255                  ; ED 91 FF FF
 nreg 255, a                    ; ED 92 FF
 or (hl)                        ; B6
 or (ix)                        ; FD B6 00
 or (ix+0)                      ; FD B6 00
 or (ix+126)                    ; FD B6 7E
 or (ix-128)                    ; FD B6 80
 or (iy)                        ; DD B6 00
 or (iy+0)                      ; DD B6 00
 or (iy+126)                    ; DD B6 7E
 or (iy-128)                    ; DD B6 80
 or 0                           ; F6 00
 or 127                         ; F6 7F
 or 255                         ; F6 FF
 or a                           ; B7
 or b                           ; B0
 or c                           ; B1
 or d                           ; B2
 or e                           ; B3
 or h                           ; B4
 or ixh                         ; FD B4
 or ixl                         ; FD B5
 or iyh                         ; DD B4
 or iyl                         ; DD B5
 or l                           ; B5
 otdr                           ; ED BB
 otib                           ; ED 90
 otir                           ; ED B3
 out (0), a                     ; D3 00
 out (127), a                   ; D3 7F
 out (255), a                   ; D3 FF
 out (bc), 0                    ; ED 71
 out (bc), f                    ; ED 71
 out (c), 0                     ; ED 71
 out (c), a                     ; ED 79
 out (c), b                     ; ED 41
 out (c), c                     ; ED 49
 out (c), d                     ; ED 51
 out (c), e                     ; ED 59
 out (c), f                     ; ED 71
 out (c), h                     ; ED 61
 out (c), l                     ; ED 69
 outd                           ; ED AB
 outi                           ; ED A3
 outinb                         ; ED 90
 pixelad                        ; ED 94
 pixeldn                        ; ED 93
 pop af                         ; F1
 pop bc                         ; C1
 pop de                         ; D1
 pop hl                         ; E1
 pop ix                         ; FD E1
 pop iy                         ; DD E1
 push 0x1234                    ; ED 8A 12 34
 push af                        ; F5
 push bc                        ; C5
 push de                        ; D5
 push hl                        ; E5
 push ix                        ; FD E5
 push iy                        ; DD E5
 pxad                           ; ED 94
 pxdn                           ; ED 93
 res 0, (hl)                    ; CB 86
 res 0, (ix)                    ; FD CB 00 86
 res 0, (ix), a                 ; FD CB 00 87
 res 0, (ix), b                 ; FD CB 00 80
 res 0, (ix), c                 ; FD CB 00 81
 res 0, (ix), d                 ; FD CB 00 82
 res 0, (ix), e                 ; FD CB 00 83
 res 0, (ix), h                 ; FD CB 00 84
 res 0, (ix), l                 ; FD CB 00 85
 res 0, (ix+0)                  ; FD CB 00 86
 res 0, (ix+0), a               ; FD CB 00 87
 res 0, (ix+0), b               ; FD CB 00 80
 res 0, (ix+0), c               ; FD CB 00 81
 res 0, (ix+0), d               ; FD CB 00 82
 res 0, (ix+0), e               ; FD CB 00 83
 res 0, (ix+0), h               ; FD CB 00 84
 res 0, (ix+0), l               ; FD CB 00 85
 res 0, (ix+126)                ; FD CB 7E 86
 res 0, (ix+126), a             ; FD CB 7E 87
 res 0, (ix+126), b             ; FD CB 7E 80
 res 0, (ix+126), c             ; FD CB 7E 81
 res 0, (ix+126), d             ; FD CB 7E 82
 res 0, (ix+126), e             ; FD CB 7E 83
 res 0, (ix+126), h             ; FD CB 7E 84
 res 0, (ix+126), l             ; FD CB 7E 85
 res 0, (ix-128)                ; FD CB 80 86
 res 0, (ix-128), a             ; FD CB 80 87
 res 0, (ix-128), b             ; FD CB 80 80
 res 0, (ix-128), c             ; FD CB 80 81
 res 0, (ix-128), d             ; FD CB 80 82
 res 0, (ix-128), e             ; FD CB 80 83
 res 0, (ix-128), h             ; FD CB 80 84
 res 0, (ix-128), l             ; FD CB 80 85
 res 0, (iy)                    ; DD CB 00 86
 res 0, (iy), a                 ; DD CB 00 87
 res 0, (iy), b                 ; DD CB 00 80
 res 0, (iy), c                 ; DD CB 00 81
 res 0, (iy), d                 ; DD CB 00 82
 res 0, (iy), e                 ; DD CB 00 83
 res 0, (iy), h                 ; DD CB 00 84
 res 0, (iy), l                 ; DD CB 00 85
 res 0, (iy+0)                  ; DD CB 00 86
 res 0, (iy+0), a               ; DD CB 00 87
 res 0, (iy+0), b               ; DD CB 00 80
 res 0, (iy+0), c               ; DD CB 00 81
 res 0, (iy+0), d               ; DD CB 00 82
 res 0, (iy+0), e               ; DD CB 00 83
 res 0, (iy+0), h               ; DD CB 00 84
 res 0, (iy+0), l               ; DD CB 00 85
 res 0, (iy+126)                ; DD CB 7E 86
 res 0, (iy+126), a             ; DD CB 7E 87
 res 0, (iy+126), b             ; DD CB 7E 80
 res 0, (iy+126), c             ; DD CB 7E 81
 res 0, (iy+126), d             ; DD CB 7E 82
 res 0, (iy+126), e             ; DD CB 7E 83
 res 0, (iy+126), h             ; DD CB 7E 84
 res 0, (iy+126), l             ; DD CB 7E 85
 res 0, (iy-128)                ; DD CB 80 86
 res 0, (iy-128), a             ; DD CB 80 87
 res 0, (iy-128), b             ; DD CB 80 80
 res 0, (iy-128), c             ; DD CB 80 81
 res 0, (iy-128), d             ; DD CB 80 82
 res 0, (iy-128), e             ; DD CB 80 83
 res 0, (iy-128), h             ; DD CB 80 84
 res 0, (iy-128), l             ; DD CB 80 85
 res 0, a                       ; CB 87
 res 0, b                       ; CB 80
 res 0, c                       ; CB 81
 res 0, d                       ; CB 82
 res 0, e                       ; CB 83
 res 0, h                       ; CB 84
 res 0, l                       ; CB 85
 res 1, (hl)                    ; CB 8E
 res 1, (ix)                    ; FD CB 00 8E
 res 1, (ix), a                 ; FD CB 00 8F
 res 1, (ix), b                 ; FD CB 00 88
 res 1, (ix), c                 ; FD CB 00 89
 res 1, (ix), d                 ; FD CB 00 8A
 res 1, (ix), e                 ; FD CB 00 8B
 res 1, (ix), h                 ; FD CB 00 8C
 res 1, (ix), l                 ; FD CB 00 8D
 res 1, (ix+0)                  ; FD CB 00 8E
 res 1, (ix+0), a               ; FD CB 00 8F
 res 1, (ix+0), b               ; FD CB 00 88
 res 1, (ix+0), c               ; FD CB 00 89
 res 1, (ix+0), d               ; FD CB 00 8A
 res 1, (ix+0), e               ; FD CB 00 8B
 res 1, (ix+0), h               ; FD CB 00 8C
 res 1, (ix+0), l               ; FD CB 00 8D
 res 1, (ix+126)                ; FD CB 7E 8E
 res 1, (ix+126), a             ; FD CB 7E 8F
 res 1, (ix+126), b             ; FD CB 7E 88
 res 1, (ix+126), c             ; FD CB 7E 89
 res 1, (ix+126), d             ; FD CB 7E 8A
 res 1, (ix+126), e             ; FD CB 7E 8B
 res 1, (ix+126), h             ; FD CB 7E 8C
 res 1, (ix+126), l             ; FD CB 7E 8D
 res 1, (ix-128)                ; FD CB 80 8E
 res 1, (ix-128), a             ; FD CB 80 8F
 res 1, (ix-128), b             ; FD CB 80 88
 res 1, (ix-128), c             ; FD CB 80 89
 res 1, (ix-128), d             ; FD CB 80 8A
 res 1, (ix-128), e             ; FD CB 80 8B
 res 1, (ix-128), h             ; FD CB 80 8C
 res 1, (ix-128), l             ; FD CB 80 8D
 res 1, (iy)                    ; DD CB 00 8E
 res 1, (iy), a                 ; DD CB 00 8F
 res 1, (iy), b                 ; DD CB 00 88
 res 1, (iy), c                 ; DD CB 00 89
 res 1, (iy), d                 ; DD CB 00 8A
 res 1, (iy), e                 ; DD CB 00 8B
 res 1, (iy), h                 ; DD CB 00 8C
 res 1, (iy), l                 ; DD CB 00 8D
 res 1, (iy+0)                  ; DD CB 00 8E
 res 1, (iy+0), a               ; DD CB 00 8F
 res 1, (iy+0), b               ; DD CB 00 88
 res 1, (iy+0), c               ; DD CB 00 89
 res 1, (iy+0), d               ; DD CB 00 8A
 res 1, (iy+0), e               ; DD CB 00 8B
 res 1, (iy+0), h               ; DD CB 00 8C
 res 1, (iy+0), l               ; DD CB 00 8D
 res 1, (iy+126)                ; DD CB 7E 8E
 res 1, (iy+126), a             ; DD CB 7E 8F
 res 1, (iy+126), b             ; DD CB 7E 88
 res 1, (iy+126), c             ; DD CB 7E 89
 res 1, (iy+126), d             ; DD CB 7E 8A
 res 1, (iy+126), e             ; DD CB 7E 8B
 res 1, (iy+126), h             ; DD CB 7E 8C
 res 1, (iy+126), l             ; DD CB 7E 8D
 res 1, (iy-128)                ; DD CB 80 8E
 res 1, (iy-128), a             ; DD CB 80 8F
 res 1, (iy-128), b             ; DD CB 80 88
 res 1, (iy-128), c             ; DD CB 80 89
 res 1, (iy-128), d             ; DD CB 80 8A
 res 1, (iy-128), e             ; DD CB 80 8B
 res 1, (iy-128), h             ; DD CB 80 8C
 res 1, (iy-128), l             ; DD CB 80 8D
 res 1, a                       ; CB 8F
 res 1, b                       ; CB 88
 res 1, c                       ; CB 89
 res 1, d                       ; CB 8A
 res 1, e                       ; CB 8B
 res 1, h                       ; CB 8C
 res 1, l                       ; CB 8D
 res 2, (hl)                    ; CB 96
 res 2, (ix)                    ; FD CB 00 96
 res 2, (ix), a                 ; FD CB 00 97
 res 2, (ix), b                 ; FD CB 00 90
 res 2, (ix), c                 ; FD CB 00 91
 res 2, (ix), d                 ; FD CB 00 92
 res 2, (ix), e                 ; FD CB 00 93
 res 2, (ix), h                 ; FD CB 00 94
 res 2, (ix), l                 ; FD CB 00 95
 res 2, (ix+0)                  ; FD CB 00 96
 res 2, (ix+0), a               ; FD CB 00 97
 res 2, (ix+0), b               ; FD CB 00 90
 res 2, (ix+0), c               ; FD CB 00 91
 res 2, (ix+0), d               ; FD CB 00 92
 res 2, (ix+0), e               ; FD CB 00 93
 res 2, (ix+0), h               ; FD CB 00 94
 res 2, (ix+0), l               ; FD CB 00 95
 res 2, (ix+126)                ; FD CB 7E 96
 res 2, (ix+126), a             ; FD CB 7E 97
 res 2, (ix+126), b             ; FD CB 7E 90
 res 2, (ix+126), c             ; FD CB 7E 91
 res 2, (ix+126), d             ; FD CB 7E 92
 res 2, (ix+126), e             ; FD CB 7E 93
 res 2, (ix+126), h             ; FD CB 7E 94
 res 2, (ix+126), l             ; FD CB 7E 95
 res 2, (ix-128)                ; FD CB 80 96
 res 2, (ix-128), a             ; FD CB 80 97
 res 2, (ix-128), b             ; FD CB 80 90
 res 2, (ix-128), c             ; FD CB 80 91
 res 2, (ix-128), d             ; FD CB 80 92
 res 2, (ix-128), e             ; FD CB 80 93
 res 2, (ix-128), h             ; FD CB 80 94
 res 2, (ix-128), l             ; FD CB 80 95
 res 2, (iy)                    ; DD CB 00 96
 res 2, (iy), a                 ; DD CB 00 97
 res 2, (iy), b                 ; DD CB 00 90
 res 2, (iy), c                 ; DD CB 00 91
 res 2, (iy), d                 ; DD CB 00 92
 res 2, (iy), e                 ; DD CB 00 93
 res 2, (iy), h                 ; DD CB 00 94
 res 2, (iy), l                 ; DD CB 00 95
 res 2, (iy+0)                  ; DD CB 00 96
 res 2, (iy+0), a               ; DD CB 00 97
 res 2, (iy+0), b               ; DD CB 00 90
 res 2, (iy+0), c               ; DD CB 00 91
 res 2, (iy+0), d               ; DD CB 00 92
 res 2, (iy+0), e               ; DD CB 00 93
 res 2, (iy+0), h               ; DD CB 00 94
 res 2, (iy+0), l               ; DD CB 00 95
 res 2, (iy+126)                ; DD CB 7E 96
 res 2, (iy+126), a             ; DD CB 7E 97
 res 2, (iy+126), b             ; DD CB 7E 90
 res 2, (iy+126), c             ; DD CB 7E 91
 res 2, (iy+126), d             ; DD CB 7E 92
 res 2, (iy+126), e             ; DD CB 7E 93
 res 2, (iy+126), h             ; DD CB 7E 94
 res 2, (iy+126), l             ; DD CB 7E 95
 res 2, (iy-128)                ; DD CB 80 96
 res 2, (iy-128), a             ; DD CB 80 97
 res 2, (iy-128), b             ; DD CB 80 90
 res 2, (iy-128), c             ; DD CB 80 91
 res 2, (iy-128), d             ; DD CB 80 92
 res 2, (iy-128), e             ; DD CB 80 93
 res 2, (iy-128), h             ; DD CB 80 94
 res 2, (iy-128), l             ; DD CB 80 95
 res 2, a                       ; CB 97
 res 2, b                       ; CB 90
 res 2, c                       ; CB 91
 res 2, d                       ; CB 92
 res 2, e                       ; CB 93
 res 2, h                       ; CB 94
 res 2, l                       ; CB 95
 res 3, (hl)                    ; CB 9E
 res 3, (ix)                    ; FD CB 00 9E
 res 3, (ix), a                 ; FD CB 00 9F
 res 3, (ix), b                 ; FD CB 00 98
 res 3, (ix), c                 ; FD CB 00 99
 res 3, (ix), d                 ; FD CB 00 9A
 res 3, (ix), e                 ; FD CB 00 9B
 res 3, (ix), h                 ; FD CB 00 9C
 res 3, (ix), l                 ; FD CB 00 9D
 res 3, (ix+0)                  ; FD CB 00 9E
 res 3, (ix+0), a               ; FD CB 00 9F
 res 3, (ix+0), b               ; FD CB 00 98
 res 3, (ix+0), c               ; FD CB 00 99
 res 3, (ix+0), d               ; FD CB 00 9A
 res 3, (ix+0), e               ; FD CB 00 9B
 res 3, (ix+0), h               ; FD CB 00 9C
 res 3, (ix+0), l               ; FD CB 00 9D
 res 3, (ix+126)                ; FD CB 7E 9E
 res 3, (ix+126), a             ; FD CB 7E 9F
 res 3, (ix+126), b             ; FD CB 7E 98
 res 3, (ix+126), c             ; FD CB 7E 99
 res 3, (ix+126), d             ; FD CB 7E 9A
 res 3, (ix+126), e             ; FD CB 7E 9B
 res 3, (ix+126), h             ; FD CB 7E 9C
 res 3, (ix+126), l             ; FD CB 7E 9D
 res 3, (ix-128)                ; FD CB 80 9E
 res 3, (ix-128), a             ; FD CB 80 9F
 res 3, (ix-128), b             ; FD CB 80 98
 res 3, (ix-128), c             ; FD CB 80 99
 res 3, (ix-128), d             ; FD CB 80 9A
 res 3, (ix-128), e             ; FD CB 80 9B
 res 3, (ix-128), h             ; FD CB 80 9C
 res 3, (ix-128), l             ; FD CB 80 9D
 res 3, (iy)                    ; DD CB 00 9E
 res 3, (iy), a                 ; DD CB 00 9F
 res 3, (iy), b                 ; DD CB 00 98
 res 3, (iy), c                 ; DD CB 00 99
 res 3, (iy), d                 ; DD CB 00 9A
 res 3, (iy), e                 ; DD CB 00 9B
 res 3, (iy), h                 ; DD CB 00 9C
 res 3, (iy), l                 ; DD CB 00 9D
 res 3, (iy+0)                  ; DD CB 00 9E
 res 3, (iy+0), a               ; DD CB 00 9F
 res 3, (iy+0), b               ; DD CB 00 98
 res 3, (iy+0), c               ; DD CB 00 99
 res 3, (iy+0), d               ; DD CB 00 9A
 res 3, (iy+0), e               ; DD CB 00 9B
 res 3, (iy+0), h               ; DD CB 00 9C
 res 3, (iy+0), l               ; DD CB 00 9D
 res 3, (iy+126)                ; DD CB 7E 9E
 res 3, (iy+126), a             ; DD CB 7E 9F
 res 3, (iy+126), b             ; DD CB 7E 98
 res 3, (iy+126), c             ; DD CB 7E 99
 res 3, (iy+126), d             ; DD CB 7E 9A
 res 3, (iy+126), e             ; DD CB 7E 9B
 res 3, (iy+126), h             ; DD CB 7E 9C
 res 3, (iy+126), l             ; DD CB 7E 9D
 res 3, (iy-128)                ; DD CB 80 9E
 res 3, (iy-128), a             ; DD CB 80 9F
 res 3, (iy-128), b             ; DD CB 80 98
 res 3, (iy-128), c             ; DD CB 80 99
 res 3, (iy-128), d             ; DD CB 80 9A
 res 3, (iy-128), e             ; DD CB 80 9B
 res 3, (iy-128), h             ; DD CB 80 9C
 res 3, (iy-128), l             ; DD CB 80 9D
 res 3, a                       ; CB 9F
 res 3, b                       ; CB 98
 res 3, c                       ; CB 99
 res 3, d                       ; CB 9A
 res 3, e                       ; CB 9B
 res 3, h                       ; CB 9C
 res 3, l                       ; CB 9D
 res 4, (hl)                    ; CB A6
 res 4, (ix)                    ; FD CB 00 A6
 res 4, (ix), a                 ; FD CB 00 A7
 res 4, (ix), b                 ; FD CB 00 A0
 res 4, (ix), c                 ; FD CB 00 A1
 res 4, (ix), d                 ; FD CB 00 A2
 res 4, (ix), e                 ; FD CB 00 A3
 res 4, (ix), h                 ; FD CB 00 A4
 res 4, (ix), l                 ; FD CB 00 A5
 res 4, (ix+0)                  ; FD CB 00 A6
 res 4, (ix+0), a               ; FD CB 00 A7
 res 4, (ix+0), b               ; FD CB 00 A0
 res 4, (ix+0), c               ; FD CB 00 A1
 res 4, (ix+0), d               ; FD CB 00 A2
 res 4, (ix+0), e               ; FD CB 00 A3
 res 4, (ix+0), h               ; FD CB 00 A4
 res 4, (ix+0), l               ; FD CB 00 A5
 res 4, (ix+126)                ; FD CB 7E A6
 res 4, (ix+126), a             ; FD CB 7E A7
 res 4, (ix+126), b             ; FD CB 7E A0
 res 4, (ix+126), c             ; FD CB 7E A1
 res 4, (ix+126), d             ; FD CB 7E A2
 res 4, (ix+126), e             ; FD CB 7E A3
 res 4, (ix+126), h             ; FD CB 7E A4
 res 4, (ix+126), l             ; FD CB 7E A5
 res 4, (ix-128)                ; FD CB 80 A6
 res 4, (ix-128), a             ; FD CB 80 A7
 res 4, (ix-128), b             ; FD CB 80 A0
 res 4, (ix-128), c             ; FD CB 80 A1
 res 4, (ix-128), d             ; FD CB 80 A2
 res 4, (ix-128), e             ; FD CB 80 A3
 res 4, (ix-128), h             ; FD CB 80 A4
 res 4, (ix-128), l             ; FD CB 80 A5
 res 4, (iy)                    ; DD CB 00 A6
 res 4, (iy), a                 ; DD CB 00 A7
 res 4, (iy), b                 ; DD CB 00 A0
 res 4, (iy), c                 ; DD CB 00 A1
 res 4, (iy), d                 ; DD CB 00 A2
 res 4, (iy), e                 ; DD CB 00 A3
 res 4, (iy), h                 ; DD CB 00 A4
 res 4, (iy), l                 ; DD CB 00 A5
 res 4, (iy+0)                  ; DD CB 00 A6
 res 4, (iy+0), a               ; DD CB 00 A7
 res 4, (iy+0), b               ; DD CB 00 A0
 res 4, (iy+0), c               ; DD CB 00 A1
 res 4, (iy+0), d               ; DD CB 00 A2
 res 4, (iy+0), e               ; DD CB 00 A3
 res 4, (iy+0), h               ; DD CB 00 A4
 res 4, (iy+0), l               ; DD CB 00 A5
 res 4, (iy+126)                ; DD CB 7E A6
 res 4, (iy+126), a             ; DD CB 7E A7
 res 4, (iy+126), b             ; DD CB 7E A0
 res 4, (iy+126), c             ; DD CB 7E A1
 res 4, (iy+126), d             ; DD CB 7E A2
 res 4, (iy+126), e             ; DD CB 7E A3
 res 4, (iy+126), h             ; DD CB 7E A4
 res 4, (iy+126), l             ; DD CB 7E A5
 res 4, (iy-128)                ; DD CB 80 A6
 res 4, (iy-128), a             ; DD CB 80 A7
 res 4, (iy-128), b             ; DD CB 80 A0
 res 4, (iy-128), c             ; DD CB 80 A1
 res 4, (iy-128), d             ; DD CB 80 A2
 res 4, (iy-128), e             ; DD CB 80 A3
 res 4, (iy-128), h             ; DD CB 80 A4
 res 4, (iy-128), l             ; DD CB 80 A5
 res 4, a                       ; CB A7
 res 4, b                       ; CB A0
 res 4, c                       ; CB A1
 res 4, d                       ; CB A2
 res 4, e                       ; CB A3
 res 4, h                       ; CB A4
 res 4, l                       ; CB A5
 res 5, (hl)                    ; CB AE
 res 5, (ix)                    ; FD CB 00 AE
 res 5, (ix), a                 ; FD CB 00 AF
 res 5, (ix), b                 ; FD CB 00 A8
 res 5, (ix), c                 ; FD CB 00 A9
 res 5, (ix), d                 ; FD CB 00 AA
 res 5, (ix), e                 ; FD CB 00 AB
 res 5, (ix), h                 ; FD CB 00 AC
 res 5, (ix), l                 ; FD CB 00 AD
 res 5, (ix+0)                  ; FD CB 00 AE
 res 5, (ix+0), a               ; FD CB 00 AF
 res 5, (ix+0), b               ; FD CB 00 A8
 res 5, (ix+0), c               ; FD CB 00 A9
 res 5, (ix+0), d               ; FD CB 00 AA
 res 5, (ix+0), e               ; FD CB 00 AB
 res 5, (ix+0), h               ; FD CB 00 AC
 res 5, (ix+0), l               ; FD CB 00 AD
 res 5, (ix+126)                ; FD CB 7E AE
 res 5, (ix+126), a             ; FD CB 7E AF
 res 5, (ix+126), b             ; FD CB 7E A8
 res 5, (ix+126), c             ; FD CB 7E A9
 res 5, (ix+126), d             ; FD CB 7E AA
 res 5, (ix+126), e             ; FD CB 7E AB
 res 5, (ix+126), h             ; FD CB 7E AC
 res 5, (ix+126), l             ; FD CB 7E AD
 res 5, (ix-128)                ; FD CB 80 AE
 res 5, (ix-128), a             ; FD CB 80 AF
 res 5, (ix-128), b             ; FD CB 80 A8
 res 5, (ix-128), c             ; FD CB 80 A9
 res 5, (ix-128), d             ; FD CB 80 AA
 res 5, (ix-128), e             ; FD CB 80 AB
 res 5, (ix-128), h             ; FD CB 80 AC
 res 5, (ix-128), l             ; FD CB 80 AD
 res 5, (iy)                    ; DD CB 00 AE
 res 5, (iy), a                 ; DD CB 00 AF
 res 5, (iy), b                 ; DD CB 00 A8
 res 5, (iy), c                 ; DD CB 00 A9
 res 5, (iy), d                 ; DD CB 00 AA
 res 5, (iy), e                 ; DD CB 00 AB
 res 5, (iy), h                 ; DD CB 00 AC
 res 5, (iy), l                 ; DD CB 00 AD
 res 5, (iy+0)                  ; DD CB 00 AE
 res 5, (iy+0), a               ; DD CB 00 AF
 res 5, (iy+0), b               ; DD CB 00 A8
 res 5, (iy+0), c               ; DD CB 00 A9
 res 5, (iy+0), d               ; DD CB 00 AA
 res 5, (iy+0), e               ; DD CB 00 AB
 res 5, (iy+0), h               ; DD CB 00 AC
 res 5, (iy+0), l               ; DD CB 00 AD
 res 5, (iy+126)                ; DD CB 7E AE
 res 5, (iy+126), a             ; DD CB 7E AF
 res 5, (iy+126), b             ; DD CB 7E A8
 res 5, (iy+126), c             ; DD CB 7E A9
 res 5, (iy+126), d             ; DD CB 7E AA
 res 5, (iy+126), e             ; DD CB 7E AB
 res 5, (iy+126), h             ; DD CB 7E AC
 res 5, (iy+126), l             ; DD CB 7E AD
 res 5, (iy-128)                ; DD CB 80 AE
 res 5, (iy-128), a             ; DD CB 80 AF
 res 5, (iy-128), b             ; DD CB 80 A8
 res 5, (iy-128), c             ; DD CB 80 A9
 res 5, (iy-128), d             ; DD CB 80 AA
 res 5, (iy-128), e             ; DD CB 80 AB
 res 5, (iy-128), h             ; DD CB 80 AC
 res 5, (iy-128), l             ; DD CB 80 AD
 res 5, a                       ; CB AF
 res 5, b                       ; CB A8
 res 5, c                       ; CB A9
 res 5, d                       ; CB AA
 res 5, e                       ; CB AB
 res 5, h                       ; CB AC
 res 5, l                       ; CB AD
 res 6, (hl)                    ; CB B6
 res 6, (ix)                    ; FD CB 00 B6
 res 6, (ix), a                 ; FD CB 00 B7
 res 6, (ix), b                 ; FD CB 00 B0
 res 6, (ix), c                 ; FD CB 00 B1
 res 6, (ix), d                 ; FD CB 00 B2
 res 6, (ix), e                 ; FD CB 00 B3
 res 6, (ix), h                 ; FD CB 00 B4
 res 6, (ix), l                 ; FD CB 00 B5
 res 6, (ix+0)                  ; FD CB 00 B6
 res 6, (ix+0), a               ; FD CB 00 B7
 res 6, (ix+0), b               ; FD CB 00 B0
 res 6, (ix+0), c               ; FD CB 00 B1
 res 6, (ix+0), d               ; FD CB 00 B2
 res 6, (ix+0), e               ; FD CB 00 B3
 res 6, (ix+0), h               ; FD CB 00 B4
 res 6, (ix+0), l               ; FD CB 00 B5
 res 6, (ix+126)                ; FD CB 7E B6
 res 6, (ix+126), a             ; FD CB 7E B7
 res 6, (ix+126), b             ; FD CB 7E B0
 res 6, (ix+126), c             ; FD CB 7E B1
 res 6, (ix+126), d             ; FD CB 7E B2
 res 6, (ix+126), e             ; FD CB 7E B3
 res 6, (ix+126), h             ; FD CB 7E B4
 res 6, (ix+126), l             ; FD CB 7E B5
 res 6, (ix-128)                ; FD CB 80 B6
 res 6, (ix-128), a             ; FD CB 80 B7
 res 6, (ix-128), b             ; FD CB 80 B0
 res 6, (ix-128), c             ; FD CB 80 B1
 res 6, (ix-128), d             ; FD CB 80 B2
 res 6, (ix-128), e             ; FD CB 80 B3
 res 6, (ix-128), h             ; FD CB 80 B4
 res 6, (ix-128), l             ; FD CB 80 B5
 res 6, (iy)                    ; DD CB 00 B6
 res 6, (iy), a                 ; DD CB 00 B7
 res 6, (iy), b                 ; DD CB 00 B0
 res 6, (iy), c                 ; DD CB 00 B1
 res 6, (iy), d                 ; DD CB 00 B2
 res 6, (iy), e                 ; DD CB 00 B3
 res 6, (iy), h                 ; DD CB 00 B4
 res 6, (iy), l                 ; DD CB 00 B5
 res 6, (iy+0)                  ; DD CB 00 B6
 res 6, (iy+0), a               ; DD CB 00 B7
 res 6, (iy+0), b               ; DD CB 00 B0
 res 6, (iy+0), c               ; DD CB 00 B1
 res 6, (iy+0), d               ; DD CB 00 B2
 res 6, (iy+0), e               ; DD CB 00 B3
 res 6, (iy+0), h               ; DD CB 00 B4
 res 6, (iy+0), l               ; DD CB 00 B5
 res 6, (iy+126)                ; DD CB 7E B6
 res 6, (iy+126), a             ; DD CB 7E B7
 res 6, (iy+126), b             ; DD CB 7E B0
 res 6, (iy+126), c             ; DD CB 7E B1
 res 6, (iy+126), d             ; DD CB 7E B2
 res 6, (iy+126), e             ; DD CB 7E B3
 res 6, (iy+126), h             ; DD CB 7E B4
 res 6, (iy+126), l             ; DD CB 7E B5
 res 6, (iy-128)                ; DD CB 80 B6
 res 6, (iy-128), a             ; DD CB 80 B7
 res 6, (iy-128), b             ; DD CB 80 B0
 res 6, (iy-128), c             ; DD CB 80 B1
 res 6, (iy-128), d             ; DD CB 80 B2
 res 6, (iy-128), e             ; DD CB 80 B3
 res 6, (iy-128), h             ; DD CB 80 B4
 res 6, (iy-128), l             ; DD CB 80 B5
 res 6, a                       ; CB B7
 res 6, b                       ; CB B0
 res 6, c                       ; CB B1
 res 6, d                       ; CB B2
 res 6, e                       ; CB B3
 res 6, h                       ; CB B4
 res 6, l                       ; CB B5
 res 7, (hl)                    ; CB BE
 res 7, (ix)                    ; FD CB 00 BE
 res 7, (ix), a                 ; FD CB 00 BF
 res 7, (ix), b                 ; FD CB 00 B8
 res 7, (ix), c                 ; FD CB 00 B9
 res 7, (ix), d                 ; FD CB 00 BA
 res 7, (ix), e                 ; FD CB 00 BB
 res 7, (ix), h                 ; FD CB 00 BC
 res 7, (ix), l                 ; FD CB 00 BD
 res 7, (ix+0)                  ; FD CB 00 BE
 res 7, (ix+0), a               ; FD CB 00 BF
 res 7, (ix+0), b               ; FD CB 00 B8
 res 7, (ix+0), c               ; FD CB 00 B9
 res 7, (ix+0), d               ; FD CB 00 BA
 res 7, (ix+0), e               ; FD CB 00 BB
 res 7, (ix+0), h               ; FD CB 00 BC
 res 7, (ix+0), l               ; FD CB 00 BD
 res 7, (ix+126)                ; FD CB 7E BE
 res 7, (ix+126), a             ; FD CB 7E BF
 res 7, (ix+126), b             ; FD CB 7E B8
 res 7, (ix+126), c             ; FD CB 7E B9
 res 7, (ix+126), d             ; FD CB 7E BA
 res 7, (ix+126), e             ; FD CB 7E BB
 res 7, (ix+126), h             ; FD CB 7E BC
 res 7, (ix+126), l             ; FD CB 7E BD
 res 7, (ix-128)                ; FD CB 80 BE
 res 7, (ix-128), a             ; FD CB 80 BF
 res 7, (ix-128), b             ; FD CB 80 B8
 res 7, (ix-128), c             ; FD CB 80 B9
 res 7, (ix-128), d             ; FD CB 80 BA
 res 7, (ix-128), e             ; FD CB 80 BB
 res 7, (ix-128), h             ; FD CB 80 BC
 res 7, (ix-128), l             ; FD CB 80 BD
 res 7, (iy)                    ; DD CB 00 BE
 res 7, (iy), a                 ; DD CB 00 BF
 res 7, (iy), b                 ; DD CB 00 B8
 res 7, (iy), c                 ; DD CB 00 B9
 res 7, (iy), d                 ; DD CB 00 BA
 res 7, (iy), e                 ; DD CB 00 BB
 res 7, (iy), h                 ; DD CB 00 BC
 res 7, (iy), l                 ; DD CB 00 BD
 res 7, (iy+0)                  ; DD CB 00 BE
 res 7, (iy+0), a               ; DD CB 00 BF
 res 7, (iy+0), b               ; DD CB 00 B8
 res 7, (iy+0), c               ; DD CB 00 B9
 res 7, (iy+0), d               ; DD CB 00 BA
 res 7, (iy+0), e               ; DD CB 00 BB
 res 7, (iy+0), h               ; DD CB 00 BC
 res 7, (iy+0), l               ; DD CB 00 BD
 res 7, (iy+126)                ; DD CB 7E BE
 res 7, (iy+126), a             ; DD CB 7E BF
 res 7, (iy+126), b             ; DD CB 7E B8
 res 7, (iy+126), c             ; DD CB 7E B9
 res 7, (iy+126), d             ; DD CB 7E BA
 res 7, (iy+126), e             ; DD CB 7E BB
 res 7, (iy+126), h             ; DD CB 7E BC
 res 7, (iy+126), l             ; DD CB 7E BD
 res 7, (iy-128)                ; DD CB 80 BE
 res 7, (iy-128), a             ; DD CB 80 BF
 res 7, (iy-128), b             ; DD CB 80 B8
 res 7, (iy-128), c             ; DD CB 80 B9
 res 7, (iy-128), d             ; DD CB 80 BA
 res 7, (iy-128), e             ; DD CB 80 BB
 res 7, (iy-128), h             ; DD CB 80 BC
 res 7, (iy-128), l             ; DD CB 80 BD
 res 7, a                       ; CB BF
 res 7, b                       ; CB B8
 res 7, c                       ; CB B9
 res 7, d                       ; CB BA
 res 7, e                       ; CB BB
 res 7, h                       ; CB BC
 res 7, l                       ; CB BD
 ret                            ; C9
 ret c                          ; D8
 ret m                          ; F8
 ret nc                         ; D0
 ret nz                         ; C0
 ret p                          ; F0
 ret pe                         ; E8
 ret po                         ; E0
 ret z                          ; C8
 reti                           ; ED 4D
 retn                           ; ED 45
 rl (hl)                        ; CB 16
 rl (ix)                        ; FD CB 00 16
 rl (ix), a                     ; FD CB 00 17
 rl (ix), b                     ; FD CB 00 10
 rl (ix), c                     ; FD CB 00 11
 rl (ix), d                     ; FD CB 00 12
 rl (ix), e                     ; FD CB 00 13
 rl (ix), h                     ; FD CB 00 14
 rl (ix), l                     ; FD CB 00 15
 rl (ix+0)                      ; FD CB 00 16
 rl (ix+0), a                   ; FD CB 00 17
 rl (ix+0), b                   ; FD CB 00 10
 rl (ix+0), c                   ; FD CB 00 11
 rl (ix+0), d                   ; FD CB 00 12
 rl (ix+0), e                   ; FD CB 00 13
 rl (ix+0), h                   ; FD CB 00 14
 rl (ix+0), l                   ; FD CB 00 15
 rl (ix+126)                    ; FD CB 7E 16
 rl (ix+126), a                 ; FD CB 7E 17
 rl (ix+126), b                 ; FD CB 7E 10
 rl (ix+126), c                 ; FD CB 7E 11
 rl (ix+126), d                 ; FD CB 7E 12
 rl (ix+126), e                 ; FD CB 7E 13
 rl (ix+126), h                 ; FD CB 7E 14
 rl (ix+126), l                 ; FD CB 7E 15
 rl (ix-128)                    ; FD CB 80 16
 rl (ix-128), a                 ; FD CB 80 17
 rl (ix-128), b                 ; FD CB 80 10
 rl (ix-128), c                 ; FD CB 80 11
 rl (ix-128), d                 ; FD CB 80 12
 rl (ix-128), e                 ; FD CB 80 13
 rl (ix-128), h                 ; FD CB 80 14
 rl (ix-128), l                 ; FD CB 80 15
 rl (iy)                        ; DD CB 00 16
 rl (iy), a                     ; DD CB 00 17
 rl (iy), b                     ; DD CB 00 10
 rl (iy), c                     ; DD CB 00 11
 rl (iy), d                     ; DD CB 00 12
 rl (iy), e                     ; DD CB 00 13
 rl (iy), h                     ; DD CB 00 14
 rl (iy), l                     ; DD CB 00 15
 rl (iy+0)                      ; DD CB 00 16
 rl (iy+0), a                   ; DD CB 00 17
 rl (iy+0), b                   ; DD CB 00 10
 rl (iy+0), c                   ; DD CB 00 11
 rl (iy+0), d                   ; DD CB 00 12
 rl (iy+0), e                   ; DD CB 00 13
 rl (iy+0), h                   ; DD CB 00 14
 rl (iy+0), l                   ; DD CB 00 15
 rl (iy+126)                    ; DD CB 7E 16
 rl (iy+126), a                 ; DD CB 7E 17
 rl (iy+126), b                 ; DD CB 7E 10
 rl (iy+126), c                 ; DD CB 7E 11
 rl (iy+126), d                 ; DD CB 7E 12
 rl (iy+126), e                 ; DD CB 7E 13
 rl (iy+126), h                 ; DD CB 7E 14
 rl (iy+126), l                 ; DD CB 7E 15
 rl (iy-128)                    ; DD CB 80 16
 rl (iy-128), a                 ; DD CB 80 17
 rl (iy-128), b                 ; DD CB 80 10
 rl (iy-128), c                 ; DD CB 80 11
 rl (iy-128), d                 ; DD CB 80 12
 rl (iy-128), e                 ; DD CB 80 13
 rl (iy-128), h                 ; DD CB 80 14
 rl (iy-128), l                 ; DD CB 80 15
 rl a                           ; CB 17
 rl b                           ; CB 10
 rl c                           ; CB 11
 rl d                           ; CB 12
 rl e                           ; CB 13
 rl h                           ; CB 14
 rl l                           ; CB 15
 rla                            ; 17
 rlc (hl)                       ; CB 06
 rlc (ix)                       ; FD CB 00 06
 rlc (ix), a                    ; FD CB 00 07
 rlc (ix), b                    ; FD CB 00 00
 rlc (ix), c                    ; FD CB 00 01
 rlc (ix), d                    ; FD CB 00 02
 rlc (ix), e                    ; FD CB 00 03
 rlc (ix), h                    ; FD CB 00 04
 rlc (ix), l                    ; FD CB 00 05
 rlc (ix+0)                     ; FD CB 00 06
 rlc (ix+0), a                  ; FD CB 00 07
 rlc (ix+0), b                  ; FD CB 00 00
 rlc (ix+0), c                  ; FD CB 00 01
 rlc (ix+0), d                  ; FD CB 00 02
 rlc (ix+0), e                  ; FD CB 00 03
 rlc (ix+0), h                  ; FD CB 00 04
 rlc (ix+0), l                  ; FD CB 00 05
 rlc (ix+126)                   ; FD CB 7E 06
 rlc (ix+126), a                ; FD CB 7E 07
 rlc (ix+126), b                ; FD CB 7E 00
 rlc (ix+126), c                ; FD CB 7E 01
 rlc (ix+126), d                ; FD CB 7E 02
 rlc (ix+126), e                ; FD CB 7E 03
 rlc (ix+126), h                ; FD CB 7E 04
 rlc (ix+126), l                ; FD CB 7E 05
 rlc (ix-128)                   ; FD CB 80 06
 rlc (ix-128), a                ; FD CB 80 07
 rlc (ix-128), b                ; FD CB 80 00
 rlc (ix-128), c                ; FD CB 80 01
 rlc (ix-128), d                ; FD CB 80 02
 rlc (ix-128), e                ; FD CB 80 03
 rlc (ix-128), h                ; FD CB 80 04
 rlc (ix-128), l                ; FD CB 80 05
 rlc (iy)                       ; DD CB 00 06
 rlc (iy), a                    ; DD CB 00 07
 rlc (iy), b                    ; DD CB 00 00
 rlc (iy), c                    ; DD CB 00 01
 rlc (iy), d                    ; DD CB 00 02
 rlc (iy), e                    ; DD CB 00 03
 rlc (iy), h                    ; DD CB 00 04
 rlc (iy), l                    ; DD CB 00 05
 rlc (iy+0)                     ; DD CB 00 06
 rlc (iy+0), a                  ; DD CB 00 07
 rlc (iy+0), b                  ; DD CB 00 00
 rlc (iy+0), c                  ; DD CB 00 01
 rlc (iy+0), d                  ; DD CB 00 02
 rlc (iy+0), e                  ; DD CB 00 03
 rlc (iy+0), h                  ; DD CB 00 04
 rlc (iy+0), l                  ; DD CB 00 05
 rlc (iy+126)                   ; DD CB 7E 06
 rlc (iy+126), a                ; DD CB 7E 07
 rlc (iy+126), b                ; DD CB 7E 00
 rlc (iy+126), c                ; DD CB 7E 01
 rlc (iy+126), d                ; DD CB 7E 02
 rlc (iy+126), e                ; DD CB 7E 03
 rlc (iy+126), h                ; DD CB 7E 04
 rlc (iy+126), l                ; DD CB 7E 05
 rlc (iy-128)                   ; DD CB 80 06
 rlc (iy-128), a                ; DD CB 80 07
 rlc (iy-128), b                ; DD CB 80 00
 rlc (iy-128), c                ; DD CB 80 01
 rlc (iy-128), d                ; DD CB 80 02
 rlc (iy-128), e                ; DD CB 80 03
 rlc (iy-128), h                ; DD CB 80 04
 rlc (iy-128), l                ; DD CB 80 05
 rlc a                          ; CB 07
 rlc b                          ; CB 00
 rlc c                          ; CB 01
 rlc d                          ; CB 02
 rlc e                          ; CB 03
 rlc h                          ; CB 04
 rlc l                          ; CB 05
 rlca                           ; 07
 rld                            ; ED 6F
 rr (hl)                        ; CB 1E
 rr (ix)                        ; FD CB 00 1E
 rr (ix), a                     ; FD CB 00 1F
 rr (ix), b                     ; FD CB 00 18
 rr (ix), c                     ; FD CB 00 19
 rr (ix), d                     ; FD CB 00 1A
 rr (ix), e                     ; FD CB 00 1B
 rr (ix), h                     ; FD CB 00 1C
 rr (ix), l                     ; FD CB 00 1D
 rr (ix+0)                      ; FD CB 00 1E
 rr (ix+0), a                   ; FD CB 00 1F
 rr (ix+0), b                   ; FD CB 00 18
 rr (ix+0), c                   ; FD CB 00 19
 rr (ix+0), d                   ; FD CB 00 1A
 rr (ix+0), e                   ; FD CB 00 1B
 rr (ix+0), h                   ; FD CB 00 1C
 rr (ix+0), l                   ; FD CB 00 1D
 rr (ix+126)                    ; FD CB 7E 1E
 rr (ix+126), a                 ; FD CB 7E 1F
 rr (ix+126), b                 ; FD CB 7E 18
 rr (ix+126), c                 ; FD CB 7E 19
 rr (ix+126), d                 ; FD CB 7E 1A
 rr (ix+126), e                 ; FD CB 7E 1B
 rr (ix+126), h                 ; FD CB 7E 1C
 rr (ix+126), l                 ; FD CB 7E 1D
 rr (ix-128)                    ; FD CB 80 1E
 rr (ix-128), a                 ; FD CB 80 1F
 rr (ix-128), b                 ; FD CB 80 18
 rr (ix-128), c                 ; FD CB 80 19
 rr (ix-128), d                 ; FD CB 80 1A
 rr (ix-128), e                 ; FD CB 80 1B
 rr (ix-128), h                 ; FD CB 80 1C
 rr (ix-128), l                 ; FD CB 80 1D
 rr (iy)                        ; DD CB 00 1E
 rr (iy), a                     ; DD CB 00 1F
 rr (iy), b                     ; DD CB 00 18
 rr (iy), c                     ; DD CB 00 19
 rr (iy), d                     ; DD CB 00 1A
 rr (iy), e                     ; DD CB 00 1B
 rr (iy), h                     ; DD CB 00 1C
 rr (iy), l                     ; DD CB 00 1D
 rr (iy+0)                      ; DD CB 00 1E
 rr (iy+0), a                   ; DD CB 00 1F
 rr (iy+0), b                   ; DD CB 00 18
 rr (iy+0), c                   ; DD CB 00 19
 rr (iy+0), d                   ; DD CB 00 1A
 rr (iy+0), e                   ; DD CB 00 1B
 rr (iy+0), h                   ; DD CB 00 1C
 rr (iy+0), l                   ; DD CB 00 1D
 rr (iy+126)                    ; DD CB 7E 1E
 rr (iy+126), a                 ; DD CB 7E 1F
 rr (iy+126), b                 ; DD CB 7E 18
 rr (iy+126), c                 ; DD CB 7E 19
 rr (iy+126), d                 ; DD CB 7E 1A
 rr (iy+126), e                 ; DD CB 7E 1B
 rr (iy+126), h                 ; DD CB 7E 1C
 rr (iy+126), l                 ; DD CB 7E 1D
 rr (iy-128)                    ; DD CB 80 1E
 rr (iy-128), a                 ; DD CB 80 1F
 rr (iy-128), b                 ; DD CB 80 18
 rr (iy-128), c                 ; DD CB 80 19
 rr (iy-128), d                 ; DD CB 80 1A
 rr (iy-128), e                 ; DD CB 80 1B
 rr (iy-128), h                 ; DD CB 80 1C
 rr (iy-128), l                 ; DD CB 80 1D
 rr a                           ; CB 1F
 rr b                           ; CB 18
 rr c                           ; CB 19
 rr d                           ; CB 1A
 rr e                           ; CB 1B
 rr h                           ; CB 1C
 rr l                           ; CB 1D
 rra                            ; 1F
 rrc (hl)                       ; CB 0E
 rrc (ix)                       ; FD CB 00 0E
 rrc (ix), a                    ; FD CB 00 0F
 rrc (ix), b                    ; FD CB 00 08
 rrc (ix), c                    ; FD CB 00 09
 rrc (ix), d                    ; FD CB 00 0A
 rrc (ix), e                    ; FD CB 00 0B
 rrc (ix), h                    ; FD CB 00 0C
 rrc (ix), l                    ; FD CB 00 0D
 rrc (ix+0)                     ; FD CB 00 0E
 rrc (ix+0), a                  ; FD CB 00 0F
 rrc (ix+0), b                  ; FD CB 00 08
 rrc (ix+0), c                  ; FD CB 00 09
 rrc (ix+0), d                  ; FD CB 00 0A
 rrc (ix+0), e                  ; FD CB 00 0B
 rrc (ix+0), h                  ; FD CB 00 0C
 rrc (ix+0), l                  ; FD CB 00 0D
 rrc (ix+126)                   ; FD CB 7E 0E
 rrc (ix+126), a                ; FD CB 7E 0F
 rrc (ix+126), b                ; FD CB 7E 08
 rrc (ix+126), c                ; FD CB 7E 09
 rrc (ix+126), d                ; FD CB 7E 0A
 rrc (ix+126), e                ; FD CB 7E 0B
 rrc (ix+126), h                ; FD CB 7E 0C
 rrc (ix+126), l                ; FD CB 7E 0D
 rrc (ix-128)                   ; FD CB 80 0E
 rrc (ix-128), a                ; FD CB 80 0F
 rrc (ix-128), b                ; FD CB 80 08
 rrc (ix-128), c                ; FD CB 80 09
 rrc (ix-128), d                ; FD CB 80 0A
 rrc (ix-128), e                ; FD CB 80 0B
 rrc (ix-128), h                ; FD CB 80 0C
 rrc (ix-128), l                ; FD CB 80 0D
 rrc (iy)                       ; DD CB 00 0E
 rrc (iy), a                    ; DD CB 00 0F
 rrc (iy), b                    ; DD CB 00 08
 rrc (iy), c                    ; DD CB 00 09
 rrc (iy), d                    ; DD CB 00 0A
 rrc (iy), e                    ; DD CB 00 0B
 rrc (iy), h                    ; DD CB 00 0C
 rrc (iy), l                    ; DD CB 00 0D
 rrc (iy+0)                     ; DD CB 00 0E
 rrc (iy+0), a                  ; DD CB 00 0F
 rrc (iy+0), b                  ; DD CB 00 08
 rrc (iy+0), c                  ; DD CB 00 09
 rrc (iy+0), d                  ; DD CB 00 0A
 rrc (iy+0), e                  ; DD CB 00 0B
 rrc (iy+0), h                  ; DD CB 00 0C
 rrc (iy+0), l                  ; DD CB 00 0D
 rrc (iy+126)                   ; DD CB 7E 0E
 rrc (iy+126), a                ; DD CB 7E 0F
 rrc (iy+126), b                ; DD CB 7E 08
 rrc (iy+126), c                ; DD CB 7E 09
 rrc (iy+126), d                ; DD CB 7E 0A
 rrc (iy+126), e                ; DD CB 7E 0B
 rrc (iy+126), h                ; DD CB 7E 0C
 rrc (iy+126), l                ; DD CB 7E 0D
 rrc (iy-128)                   ; DD CB 80 0E
 rrc (iy-128), a                ; DD CB 80 0F
 rrc (iy-128), b                ; DD CB 80 08
 rrc (iy-128), c                ; DD CB 80 09
 rrc (iy-128), d                ; DD CB 80 0A
 rrc (iy-128), e                ; DD CB 80 0B
 rrc (iy-128), h                ; DD CB 80 0C
 rrc (iy-128), l                ; DD CB 80 0D
 rrc a                          ; CB 0F
 rrc b                          ; CB 08
 rrc c                          ; CB 09
 rrc d                          ; CB 0A
 rrc e                          ; CB 0B
 rrc h                          ; CB 0C
 rrc l                          ; CB 0D
 rrca                           ; 0F
 rrd                            ; ED 67
 rst 0                          ; C7
 rst 16                         ; D7
 rst 24                         ; DF
 rst 32                         ; E7
 rst 40                         ; EF
 rst 48                         ; F7
 rst 56                         ; FF
 rst 8                          ; CF
 sbc a, (hl)                    ; 9E
 sbc a, (ix)                    ; FD 9E 00
 sbc a, (ix+0)                  ; FD 9E 00
 sbc a, (ix+126)                ; FD 9E 7E
 sbc a, (ix-128)                ; FD 9E 80
 sbc a, (iy)                    ; DD 9E 00
 sbc a, (iy+0)                  ; DD 9E 00
 sbc a, (iy+126)                ; DD 9E 7E
 sbc a, (iy-128)                ; DD 9E 80
 sbc a, 0                       ; DE 00
 sbc a, 127                     ; DE 7F
 sbc a, 255                     ; DE FF
 sbc a, a                       ; 9F
 sbc a, b                       ; 98
 sbc a, c                       ; 99
 sbc a, d                       ; 9A
 sbc a, e                       ; 9B
 sbc a, h                       ; 9C
 sbc a, ixh                     ; FD 9C
 sbc a, ixl                     ; FD 9D
 sbc a, iyh                     ; DD 9C
 sbc a, iyl                     ; DD 9D
 sbc a, l                       ; 9D
 sbc hl, bc                     ; ED 42
 sbc hl, de                     ; ED 52
 sbc hl, hl                     ; ED 62
 sbc hl, sp                     ; ED 72
 scf                            ; 37
 set 0, (hl)                    ; CB C6
 set 0, (ix)                    ; FD CB 00 C6
 set 0, (ix), a                 ; FD CB 00 C7
 set 0, (ix), b                 ; FD CB 00 C0
 set 0, (ix), c                 ; FD CB 00 C1
 set 0, (ix), d                 ; FD CB 00 C2
 set 0, (ix), e                 ; FD CB 00 C3
 set 0, (ix), h                 ; FD CB 00 C4
 set 0, (ix), l                 ; FD CB 00 C5
 set 0, (ix+0)                  ; FD CB 00 C6
 set 0, (ix+0), a               ; FD CB 00 C7
 set 0, (ix+0), b               ; FD CB 00 C0
 set 0, (ix+0), c               ; FD CB 00 C1
 set 0, (ix+0), d               ; FD CB 00 C2
 set 0, (ix+0), e               ; FD CB 00 C3
 set 0, (ix+0), h               ; FD CB 00 C4
 set 0, (ix+0), l               ; FD CB 00 C5
 set 0, (ix+126)                ; FD CB 7E C6
 set 0, (ix+126), a             ; FD CB 7E C7
 set 0, (ix+126), b             ; FD CB 7E C0
 set 0, (ix+126), c             ; FD CB 7E C1
 set 0, (ix+126), d             ; FD CB 7E C2
 set 0, (ix+126), e             ; FD CB 7E C3
 set 0, (ix+126), h             ; FD CB 7E C4
 set 0, (ix+126), l             ; FD CB 7E C5
 set 0, (ix-128)                ; FD CB 80 C6
 set 0, (ix-128), a             ; FD CB 80 C7
 set 0, (ix-128), b             ; FD CB 80 C0
 set 0, (ix-128), c             ; FD CB 80 C1
 set 0, (ix-128), d             ; FD CB 80 C2
 set 0, (ix-128), e             ; FD CB 80 C3
 set 0, (ix-128), h             ; FD CB 80 C4
 set 0, (ix-128), l             ; FD CB 80 C5
 set 0, (iy)                    ; DD CB 00 C6
 set 0, (iy), a                 ; DD CB 00 C7
 set 0, (iy), b                 ; DD CB 00 C0
 set 0, (iy), c                 ; DD CB 00 C1
 set 0, (iy), d                 ; DD CB 00 C2
 set 0, (iy), e                 ; DD CB 00 C3
 set 0, (iy), h                 ; DD CB 00 C4
 set 0, (iy), l                 ; DD CB 00 C5
 set 0, (iy+0)                  ; DD CB 00 C6
 set 0, (iy+0), a               ; DD CB 00 C7
 set 0, (iy+0), b               ; DD CB 00 C0
 set 0, (iy+0), c               ; DD CB 00 C1
 set 0, (iy+0), d               ; DD CB 00 C2
 set 0, (iy+0), e               ; DD CB 00 C3
 set 0, (iy+0), h               ; DD CB 00 C4
 set 0, (iy+0), l               ; DD CB 00 C5
 set 0, (iy+126)                ; DD CB 7E C6
 set 0, (iy+126), a             ; DD CB 7E C7
 set 0, (iy+126), b             ; DD CB 7E C0
 set 0, (iy+126), c             ; DD CB 7E C1
 set 0, (iy+126), d             ; DD CB 7E C2
 set 0, (iy+126), e             ; DD CB 7E C3
 set 0, (iy+126), h             ; DD CB 7E C4
 set 0, (iy+126), l             ; DD CB 7E C5
 set 0, (iy-128)                ; DD CB 80 C6
 set 0, (iy-128), a             ; DD CB 80 C7
 set 0, (iy-128), b             ; DD CB 80 C0
 set 0, (iy-128), c             ; DD CB 80 C1
 set 0, (iy-128), d             ; DD CB 80 C2
 set 0, (iy-128), e             ; DD CB 80 C3
 set 0, (iy-128), h             ; DD CB 80 C4
 set 0, (iy-128), l             ; DD CB 80 C5
 set 0, a                       ; CB C7
 set 0, b                       ; CB C0
 set 0, c                       ; CB C1
 set 0, d                       ; CB C2
 set 0, e                       ; CB C3
 set 0, h                       ; CB C4
 set 0, l                       ; CB C5
 set 1, (hl)                    ; CB CE
 set 1, (ix)                    ; FD CB 00 CE
 set 1, (ix), a                 ; FD CB 00 CF
 set 1, (ix), b                 ; FD CB 00 C8
 set 1, (ix), c                 ; FD CB 00 C9
 set 1, (ix), d                 ; FD CB 00 CA
 set 1, (ix), e                 ; FD CB 00 CB
 set 1, (ix), h                 ; FD CB 00 CC
 set 1, (ix), l                 ; FD CB 00 CD
 set 1, (ix+0)                  ; FD CB 00 CE
 set 1, (ix+0), a               ; FD CB 00 CF
 set 1, (ix+0), b               ; FD CB 00 C8
 set 1, (ix+0), c               ; FD CB 00 C9
 set 1, (ix+0), d               ; FD CB 00 CA
 set 1, (ix+0), e               ; FD CB 00 CB
 set 1, (ix+0), h               ; FD CB 00 CC
 set 1, (ix+0), l               ; FD CB 00 CD
 set 1, (ix+126)                ; FD CB 7E CE
 set 1, (ix+126), a             ; FD CB 7E CF
 set 1, (ix+126), b             ; FD CB 7E C8
 set 1, (ix+126), c             ; FD CB 7E C9
 set 1, (ix+126), d             ; FD CB 7E CA
 set 1, (ix+126), e             ; FD CB 7E CB
 set 1, (ix+126), h             ; FD CB 7E CC
 set 1, (ix+126), l             ; FD CB 7E CD
 set 1, (ix-128)                ; FD CB 80 CE
 set 1, (ix-128), a             ; FD CB 80 CF
 set 1, (ix-128), b             ; FD CB 80 C8
 set 1, (ix-128), c             ; FD CB 80 C9
 set 1, (ix-128), d             ; FD CB 80 CA
 set 1, (ix-128), e             ; FD CB 80 CB
 set 1, (ix-128), h             ; FD CB 80 CC
 set 1, (ix-128), l             ; FD CB 80 CD
 set 1, (iy)                    ; DD CB 00 CE
 set 1, (iy), a                 ; DD CB 00 CF
 set 1, (iy), b                 ; DD CB 00 C8
 set 1, (iy), c                 ; DD CB 00 C9
 set 1, (iy), d                 ; DD CB 00 CA
 set 1, (iy), e                 ; DD CB 00 CB
 set 1, (iy), h                 ; DD CB 00 CC
 set 1, (iy), l                 ; DD CB 00 CD
 set 1, (iy+0)                  ; DD CB 00 CE
 set 1, (iy+0), a               ; DD CB 00 CF
 set 1, (iy+0), b               ; DD CB 00 C8
 set 1, (iy+0), c               ; DD CB 00 C9
 set 1, (iy+0), d               ; DD CB 00 CA
 set 1, (iy+0), e               ; DD CB 00 CB
 set 1, (iy+0), h               ; DD CB 00 CC
 set 1, (iy+0), l               ; DD CB 00 CD
 set 1, (iy+126)                ; DD CB 7E CE
 set 1, (iy+126), a             ; DD CB 7E CF
 set 1, (iy+126), b             ; DD CB 7E C8
 set 1, (iy+126), c             ; DD CB 7E C9
 set 1, (iy+126), d             ; DD CB 7E CA
 set 1, (iy+126), e             ; DD CB 7E CB
 set 1, (iy+126), h             ; DD CB 7E CC
 set 1, (iy+126), l             ; DD CB 7E CD
 set 1, (iy-128)                ; DD CB 80 CE
 set 1, (iy-128), a             ; DD CB 80 CF
 set 1, (iy-128), b             ; DD CB 80 C8
 set 1, (iy-128), c             ; DD CB 80 C9
 set 1, (iy-128), d             ; DD CB 80 CA
 set 1, (iy-128), e             ; DD CB 80 CB
 set 1, (iy-128), h             ; DD CB 80 CC
 set 1, (iy-128), l             ; DD CB 80 CD
 set 1, a                       ; CB CF
 set 1, b                       ; CB C8
 set 1, c                       ; CB C9
 set 1, d                       ; CB CA
 set 1, e                       ; CB CB
 set 1, h                       ; CB CC
 set 1, l                       ; CB CD
 set 2, (hl)                    ; CB D6
 set 2, (ix)                    ; FD CB 00 D6
 set 2, (ix), a                 ; FD CB 00 D7
 set 2, (ix), b                 ; FD CB 00 D0
 set 2, (ix), c                 ; FD CB 00 D1
 set 2, (ix), d                 ; FD CB 00 D2
 set 2, (ix), e                 ; FD CB 00 D3
 set 2, (ix), h                 ; FD CB 00 D4
 set 2, (ix), l                 ; FD CB 00 D5
 set 2, (ix+0)                  ; FD CB 00 D6
 set 2, (ix+0), a               ; FD CB 00 D7
 set 2, (ix+0), b               ; FD CB 00 D0
 set 2, (ix+0), c               ; FD CB 00 D1
 set 2, (ix+0), d               ; FD CB 00 D2
 set 2, (ix+0), e               ; FD CB 00 D3
 set 2, (ix+0), h               ; FD CB 00 D4
 set 2, (ix+0), l               ; FD CB 00 D5
 set 2, (ix+126)                ; FD CB 7E D6
 set 2, (ix+126), a             ; FD CB 7E D7
 set 2, (ix+126), b             ; FD CB 7E D0
 set 2, (ix+126), c             ; FD CB 7E D1
 set 2, (ix+126), d             ; FD CB 7E D2
 set 2, (ix+126), e             ; FD CB 7E D3
 set 2, (ix+126), h             ; FD CB 7E D4
 set 2, (ix+126), l             ; FD CB 7E D5
 set 2, (ix-128)                ; FD CB 80 D6
 set 2, (ix-128), a             ; FD CB 80 D7
 set 2, (ix-128), b             ; FD CB 80 D0
 set 2, (ix-128), c             ; FD CB 80 D1
 set 2, (ix-128), d             ; FD CB 80 D2
 set 2, (ix-128), e             ; FD CB 80 D3
 set 2, (ix-128), h             ; FD CB 80 D4
 set 2, (ix-128), l             ; FD CB 80 D5
 set 2, (iy)                    ; DD CB 00 D6
 set 2, (iy), a                 ; DD CB 00 D7
 set 2, (iy), b                 ; DD CB 00 D0
 set 2, (iy), c                 ; DD CB 00 D1
 set 2, (iy), d                 ; DD CB 00 D2
 set 2, (iy), e                 ; DD CB 00 D3
 set 2, (iy), h                 ; DD CB 00 D4
 set 2, (iy), l                 ; DD CB 00 D5
 set 2, (iy+0)                  ; DD CB 00 D6
 set 2, (iy+0), a               ; DD CB 00 D7
 set 2, (iy+0), b               ; DD CB 00 D0
 set 2, (iy+0), c               ; DD CB 00 D1
 set 2, (iy+0), d               ; DD CB 00 D2
 set 2, (iy+0), e               ; DD CB 00 D3
 set 2, (iy+0), h               ; DD CB 00 D4
 set 2, (iy+0), l               ; DD CB 00 D5
 set 2, (iy+126)                ; DD CB 7E D6
 set 2, (iy+126), a             ; DD CB 7E D7
 set 2, (iy+126), b             ; DD CB 7E D0
 set 2, (iy+126), c             ; DD CB 7E D1
 set 2, (iy+126), d             ; DD CB 7E D2
 set 2, (iy+126), e             ; DD CB 7E D3
 set 2, (iy+126), h             ; DD CB 7E D4
 set 2, (iy+126), l             ; DD CB 7E D5
 set 2, (iy-128)                ; DD CB 80 D6
 set 2, (iy-128), a             ; DD CB 80 D7
 set 2, (iy-128), b             ; DD CB 80 D0
 set 2, (iy-128), c             ; DD CB 80 D1
 set 2, (iy-128), d             ; DD CB 80 D2
 set 2, (iy-128), e             ; DD CB 80 D3
 set 2, (iy-128), h             ; DD CB 80 D4
 set 2, (iy-128), l             ; DD CB 80 D5
 set 2, a                       ; CB D7
 set 2, b                       ; CB D0
 set 2, c                       ; CB D1
 set 2, d                       ; CB D2
 set 2, e                       ; CB D3
 set 2, h                       ; CB D4
 set 2, l                       ; CB D5
 set 3, (hl)                    ; CB DE
 set 3, (ix)                    ; FD CB 00 DE
 set 3, (ix), a                 ; FD CB 00 DF
 set 3, (ix), b                 ; FD CB 00 D8
 set 3, (ix), c                 ; FD CB 00 D9
 set 3, (ix), d                 ; FD CB 00 DA
 set 3, (ix), e                 ; FD CB 00 DB
 set 3, (ix), h                 ; FD CB 00 DC
 set 3, (ix), l                 ; FD CB 00 DD
 set 3, (ix+0)                  ; FD CB 00 DE
 set 3, (ix+0), a               ; FD CB 00 DF
 set 3, (ix+0), b               ; FD CB 00 D8
 set 3, (ix+0), c               ; FD CB 00 D9
 set 3, (ix+0), d               ; FD CB 00 DA
 set 3, (ix+0), e               ; FD CB 00 DB
 set 3, (ix+0), h               ; FD CB 00 DC
 set 3, (ix+0), l               ; FD CB 00 DD
 set 3, (ix+126)                ; FD CB 7E DE
 set 3, (ix+126), a             ; FD CB 7E DF
 set 3, (ix+126), b             ; FD CB 7E D8
 set 3, (ix+126), c             ; FD CB 7E D9
 set 3, (ix+126), d             ; FD CB 7E DA
 set 3, (ix+126), e             ; FD CB 7E DB
 set 3, (ix+126), h             ; FD CB 7E DC
 set 3, (ix+126), l             ; FD CB 7E DD
 set 3, (ix-128)                ; FD CB 80 DE
 set 3, (ix-128), a             ; FD CB 80 DF
 set 3, (ix-128), b             ; FD CB 80 D8
 set 3, (ix-128), c             ; FD CB 80 D9
 set 3, (ix-128), d             ; FD CB 80 DA
 set 3, (ix-128), e             ; FD CB 80 DB
 set 3, (ix-128), h             ; FD CB 80 DC
 set 3, (ix-128), l             ; FD CB 80 DD
 set 3, (iy)                    ; DD CB 00 DE
 set 3, (iy), a                 ; DD CB 00 DF
 set 3, (iy), b                 ; DD CB 00 D8
 set 3, (iy), c                 ; DD CB 00 D9
 set 3, (iy), d                 ; DD CB 00 DA
 set 3, (iy), e                 ; DD CB 00 DB
 set 3, (iy), h                 ; DD CB 00 DC
 set 3, (iy), l                 ; DD CB 00 DD
 set 3, (iy+0)                  ; DD CB 00 DE
 set 3, (iy+0), a               ; DD CB 00 DF
 set 3, (iy+0), b               ; DD CB 00 D8
 set 3, (iy+0), c               ; DD CB 00 D9
 set 3, (iy+0), d               ; DD CB 00 DA
 set 3, (iy+0), e               ; DD CB 00 DB
 set 3, (iy+0), h               ; DD CB 00 DC
 set 3, (iy+0), l               ; DD CB 00 DD
 set 3, (iy+126)                ; DD CB 7E DE
 set 3, (iy+126), a             ; DD CB 7E DF
 set 3, (iy+126), b             ; DD CB 7E D8
 set 3, (iy+126), c             ; DD CB 7E D9
 set 3, (iy+126), d             ; DD CB 7E DA
 set 3, (iy+126), e             ; DD CB 7E DB
 set 3, (iy+126), h             ; DD CB 7E DC
 set 3, (iy+126), l             ; DD CB 7E DD
 set 3, (iy-128)                ; DD CB 80 DE
 set 3, (iy-128), a             ; DD CB 80 DF
 set 3, (iy-128), b             ; DD CB 80 D8
 set 3, (iy-128), c             ; DD CB 80 D9
 set 3, (iy-128), d             ; DD CB 80 DA
 set 3, (iy-128), e             ; DD CB 80 DB
 set 3, (iy-128), h             ; DD CB 80 DC
 set 3, (iy-128), l             ; DD CB 80 DD
 set 3, a                       ; CB DF
 set 3, b                       ; CB D8
 set 3, c                       ; CB D9
 set 3, d                       ; CB DA
 set 3, e                       ; CB DB
 set 3, h                       ; CB DC
 set 3, l                       ; CB DD
 set 4, (hl)                    ; CB E6
 set 4, (ix)                    ; FD CB 00 E6
 set 4, (ix), a                 ; FD CB 00 E7
 set 4, (ix), b                 ; FD CB 00 E0
 set 4, (ix), c                 ; FD CB 00 E1
 set 4, (ix), d                 ; FD CB 00 E2
 set 4, (ix), e                 ; FD CB 00 E3
 set 4, (ix), h                 ; FD CB 00 E4
 set 4, (ix), l                 ; FD CB 00 E5
 set 4, (ix+0)                  ; FD CB 00 E6
 set 4, (ix+0), a               ; FD CB 00 E7
 set 4, (ix+0), b               ; FD CB 00 E0
 set 4, (ix+0), c               ; FD CB 00 E1
 set 4, (ix+0), d               ; FD CB 00 E2
 set 4, (ix+0), e               ; FD CB 00 E3
 set 4, (ix+0), h               ; FD CB 00 E4
 set 4, (ix+0), l               ; FD CB 00 E5
 set 4, (ix+126)                ; FD CB 7E E6
 set 4, (ix+126), a             ; FD CB 7E E7
 set 4, (ix+126), b             ; FD CB 7E E0
 set 4, (ix+126), c             ; FD CB 7E E1
 set 4, (ix+126), d             ; FD CB 7E E2
 set 4, (ix+126), e             ; FD CB 7E E3
 set 4, (ix+126), h             ; FD CB 7E E4
 set 4, (ix+126), l             ; FD CB 7E E5
 set 4, (ix-128)                ; FD CB 80 E6
 set 4, (ix-128), a             ; FD CB 80 E7
 set 4, (ix-128), b             ; FD CB 80 E0
 set 4, (ix-128), c             ; FD CB 80 E1
 set 4, (ix-128), d             ; FD CB 80 E2
 set 4, (ix-128), e             ; FD CB 80 E3
 set 4, (ix-128), h             ; FD CB 80 E4
 set 4, (ix-128), l             ; FD CB 80 E5
 set 4, (iy)                    ; DD CB 00 E6
 set 4, (iy), a                 ; DD CB 00 E7
 set 4, (iy), b                 ; DD CB 00 E0
 set 4, (iy), c                 ; DD CB 00 E1
 set 4, (iy), d                 ; DD CB 00 E2
 set 4, (iy), e                 ; DD CB 00 E3
 set 4, (iy), h                 ; DD CB 00 E4
 set 4, (iy), l                 ; DD CB 00 E5
 set 4, (iy+0)                  ; DD CB 00 E6
 set 4, (iy+0), a               ; DD CB 00 E7
 set 4, (iy+0), b               ; DD CB 00 E0
 set 4, (iy+0), c               ; DD CB 00 E1
 set 4, (iy+0), d               ; DD CB 00 E2
 set 4, (iy+0), e               ; DD CB 00 E3
 set 4, (iy+0), h               ; DD CB 00 E4
 set 4, (iy+0), l               ; DD CB 00 E5
 set 4, (iy+126)                ; DD CB 7E E6
 set 4, (iy+126), a             ; DD CB 7E E7
 set 4, (iy+126), b             ; DD CB 7E E0
 set 4, (iy+126), c             ; DD CB 7E E1
 set 4, (iy+126), d             ; DD CB 7E E2
 set 4, (iy+126), e             ; DD CB 7E E3
 set 4, (iy+126), h             ; DD CB 7E E4
 set 4, (iy+126), l             ; DD CB 7E E5
 set 4, (iy-128)                ; DD CB 80 E6
 set 4, (iy-128), a             ; DD CB 80 E7
 set 4, (iy-128), b             ; DD CB 80 E0
 set 4, (iy-128), c             ; DD CB 80 E1
 set 4, (iy-128), d             ; DD CB 80 E2
 set 4, (iy-128), e             ; DD CB 80 E3
 set 4, (iy-128), h             ; DD CB 80 E4
 set 4, (iy-128), l             ; DD CB 80 E5
 set 4, a                       ; CB E7
 set 4, b                       ; CB E0
 set 4, c                       ; CB E1
 set 4, d                       ; CB E2
 set 4, e                       ; CB E3
 set 4, h                       ; CB E4
 set 4, l                       ; CB E5
 set 5, (hl)                    ; CB EE
 set 5, (ix)                    ; FD CB 00 EE
 set 5, (ix), a                 ; FD CB 00 EF
 set 5, (ix), b                 ; FD CB 00 E8
 set 5, (ix), c                 ; FD CB 00 E9
 set 5, (ix), d                 ; FD CB 00 EA
 set 5, (ix), e                 ; FD CB 00 EB
 set 5, (ix), h                 ; FD CB 00 EC
 set 5, (ix), l                 ; FD CB 00 ED
 set 5, (ix+0)                  ; FD CB 00 EE
 set 5, (ix+0), a               ; FD CB 00 EF
 set 5, (ix+0), b               ; FD CB 00 E8
 set 5, (ix+0), c               ; FD CB 00 E9
 set 5, (ix+0), d               ; FD CB 00 EA
 set 5, (ix+0), e               ; FD CB 00 EB
 set 5, (ix+0), h               ; FD CB 00 EC
 set 5, (ix+0), l               ; FD CB 00 ED
 set 5, (ix+126)                ; FD CB 7E EE
 set 5, (ix+126), a             ; FD CB 7E EF
 set 5, (ix+126), b             ; FD CB 7E E8
 set 5, (ix+126), c             ; FD CB 7E E9
 set 5, (ix+126), d             ; FD CB 7E EA
 set 5, (ix+126), e             ; FD CB 7E EB
 set 5, (ix+126), h             ; FD CB 7E EC
 set 5, (ix+126), l             ; FD CB 7E ED
 set 5, (ix-128)                ; FD CB 80 EE
 set 5, (ix-128), a             ; FD CB 80 EF
 set 5, (ix-128), b             ; FD CB 80 E8
 set 5, (ix-128), c             ; FD CB 80 E9
 set 5, (ix-128), d             ; FD CB 80 EA
 set 5, (ix-128), e             ; FD CB 80 EB
 set 5, (ix-128), h             ; FD CB 80 EC
 set 5, (ix-128), l             ; FD CB 80 ED
 set 5, (iy)                    ; DD CB 00 EE
 set 5, (iy), a                 ; DD CB 00 EF
 set 5, (iy), b                 ; DD CB 00 E8
 set 5, (iy), c                 ; DD CB 00 E9
 set 5, (iy), d                 ; DD CB 00 EA
 set 5, (iy), e                 ; DD CB 00 EB
 set 5, (iy), h                 ; DD CB 00 EC
 set 5, (iy), l                 ; DD CB 00 ED
 set 5, (iy+0)                  ; DD CB 00 EE
 set 5, (iy+0), a               ; DD CB 00 EF
 set 5, (iy+0), b               ; DD CB 00 E8
 set 5, (iy+0), c               ; DD CB 00 E9
 set 5, (iy+0), d               ; DD CB 00 EA
 set 5, (iy+0), e               ; DD CB 00 EB
 set 5, (iy+0), h               ; DD CB 00 EC
 set 5, (iy+0), l               ; DD CB 00 ED
 set 5, (iy+126)                ; DD CB 7E EE
 set 5, (iy+126), a             ; DD CB 7E EF
 set 5, (iy+126), b             ; DD CB 7E E8
 set 5, (iy+126), c             ; DD CB 7E E9
 set 5, (iy+126), d             ; DD CB 7E EA
 set 5, (iy+126), e             ; DD CB 7E EB
 set 5, (iy+126), h             ; DD CB 7E EC
 set 5, (iy+126), l             ; DD CB 7E ED
 set 5, (iy-128)                ; DD CB 80 EE
 set 5, (iy-128), a             ; DD CB 80 EF
 set 5, (iy-128), b             ; DD CB 80 E8
 set 5, (iy-128), c             ; DD CB 80 E9
 set 5, (iy-128), d             ; DD CB 80 EA
 set 5, (iy-128), e             ; DD CB 80 EB
 set 5, (iy-128), h             ; DD CB 80 EC
 set 5, (iy-128), l             ; DD CB 80 ED
 set 5, a                       ; CB EF
 set 5, b                       ; CB E8
 set 5, c                       ; CB E9
 set 5, d                       ; CB EA
 set 5, e                       ; CB EB
 set 5, h                       ; CB EC
 set 5, l                       ; CB ED
 set 6, (hl)                    ; CB F6
 set 6, (ix)                    ; FD CB 00 F6
 set 6, (ix), a                 ; FD CB 00 F7
 set 6, (ix), b                 ; FD CB 00 F0
 set 6, (ix), c                 ; FD CB 00 F1
 set 6, (ix), d                 ; FD CB 00 F2
 set 6, (ix), e                 ; FD CB 00 F3
 set 6, (ix), h                 ; FD CB 00 F4
 set 6, (ix), l                 ; FD CB 00 F5
 set 6, (ix+0)                  ; FD CB 00 F6
 set 6, (ix+0), a               ; FD CB 00 F7
 set 6, (ix+0), b               ; FD CB 00 F0
 set 6, (ix+0), c               ; FD CB 00 F1
 set 6, (ix+0), d               ; FD CB 00 F2
 set 6, (ix+0), e               ; FD CB 00 F3
 set 6, (ix+0), h               ; FD CB 00 F4
 set 6, (ix+0), l               ; FD CB 00 F5
 set 6, (ix+126)                ; FD CB 7E F6
 set 6, (ix+126), a             ; FD CB 7E F7
 set 6, (ix+126), b             ; FD CB 7E F0
 set 6, (ix+126), c             ; FD CB 7E F1
 set 6, (ix+126), d             ; FD CB 7E F2
 set 6, (ix+126), e             ; FD CB 7E F3
 set 6, (ix+126), h             ; FD CB 7E F4
 set 6, (ix+126), l             ; FD CB 7E F5
 set 6, (ix-128)                ; FD CB 80 F6
 set 6, (ix-128), a             ; FD CB 80 F7
 set 6, (ix-128), b             ; FD CB 80 F0
 set 6, (ix-128), c             ; FD CB 80 F1
 set 6, (ix-128), d             ; FD CB 80 F2
 set 6, (ix-128), e             ; FD CB 80 F3
 set 6, (ix-128), h             ; FD CB 80 F4
 set 6, (ix-128), l             ; FD CB 80 F5
 set 6, (iy)                    ; DD CB 00 F6
 set 6, (iy), a                 ; DD CB 00 F7
 set 6, (iy), b                 ; DD CB 00 F0
 set 6, (iy), c                 ; DD CB 00 F1
 set 6, (iy), d                 ; DD CB 00 F2
 set 6, (iy), e                 ; DD CB 00 F3
 set 6, (iy), h                 ; DD CB 00 F4
 set 6, (iy), l                 ; DD CB 00 F5
 set 6, (iy+0)                  ; DD CB 00 F6
 set 6, (iy+0), a               ; DD CB 00 F7
 set 6, (iy+0), b               ; DD CB 00 F0
 set 6, (iy+0), c               ; DD CB 00 F1
 set 6, (iy+0), d               ; DD CB 00 F2
 set 6, (iy+0), e               ; DD CB 00 F3
 set 6, (iy+0), h               ; DD CB 00 F4
 set 6, (iy+0), l               ; DD CB 00 F5
 set 6, (iy+126)                ; DD CB 7E F6
 set 6, (iy+126), a             ; DD CB 7E F7
 set 6, (iy+126), b             ; DD CB 7E F0
 set 6, (iy+126), c             ; DD CB 7E F1
 set 6, (iy+126), d             ; DD CB 7E F2
 set 6, (iy+126), e             ; DD CB 7E F3
 set 6, (iy+126), h             ; DD CB 7E F4
 set 6, (iy+126), l             ; DD CB 7E F5
 set 6, (iy-128)                ; DD CB 80 F6
 set 6, (iy-128), a             ; DD CB 80 F7
 set 6, (iy-128), b             ; DD CB 80 F0
 set 6, (iy-128), c             ; DD CB 80 F1
 set 6, (iy-128), d             ; DD CB 80 F2
 set 6, (iy-128), e             ; DD CB 80 F3
 set 6, (iy-128), h             ; DD CB 80 F4
 set 6, (iy-128), l             ; DD CB 80 F5
 set 6, a                       ; CB F7
 set 6, b                       ; CB F0
 set 6, c                       ; CB F1
 set 6, d                       ; CB F2
 set 6, e                       ; CB F3
 set 6, h                       ; CB F4
 set 6, l                       ; CB F5
 set 7, (hl)                    ; CB FE
 set 7, (ix)                    ; FD CB 00 FE
 set 7, (ix), a                 ; FD CB 00 FF
 set 7, (ix), b                 ; FD CB 00 F8
 set 7, (ix), c                 ; FD CB 00 F9
 set 7, (ix), d                 ; FD CB 00 FA
 set 7, (ix), e                 ; FD CB 00 FB
 set 7, (ix), h                 ; FD CB 00 FC
 set 7, (ix), l                 ; FD CB 00 FD
 set 7, (ix+0)                  ; FD CB 00 FE
 set 7, (ix+0), a               ; FD CB 00 FF
 set 7, (ix+0), b               ; FD CB 00 F8
 set 7, (ix+0), c               ; FD CB 00 F9
 set 7, (ix+0), d               ; FD CB 00 FA
 set 7, (ix+0), e               ; FD CB 00 FB
 set 7, (ix+0), h               ; FD CB 00 FC
 set 7, (ix+0), l               ; FD CB 00 FD
 set 7, (ix+126)                ; FD CB 7E FE
 set 7, (ix+126), a             ; FD CB 7E FF
 set 7, (ix+126), b             ; FD CB 7E F8
 set 7, (ix+126), c             ; FD CB 7E F9
 set 7, (ix+126), d             ; FD CB 7E FA
 set 7, (ix+126), e             ; FD CB 7E FB
 set 7, (ix+126), h             ; FD CB 7E FC
 set 7, (ix+126), l             ; FD CB 7E FD
 set 7, (ix-128)                ; FD CB 80 FE
 set 7, (ix-128), a             ; FD CB 80 FF
 set 7, (ix-128), b             ; FD CB 80 F8
 set 7, (ix-128), c             ; FD CB 80 F9
 set 7, (ix-128), d             ; FD CB 80 FA
 set 7, (ix-128), e             ; FD CB 80 FB
 set 7, (ix-128), h             ; FD CB 80 FC
 set 7, (ix-128), l             ; FD CB 80 FD
 set 7, (iy)                    ; DD CB 00 FE
 set 7, (iy), a                 ; DD CB 00 FF
 set 7, (iy), b                 ; DD CB 00 F8
 set 7, (iy), c                 ; DD CB 00 F9
 set 7, (iy), d                 ; DD CB 00 FA
 set 7, (iy), e                 ; DD CB 00 FB
 set 7, (iy), h                 ; DD CB 00 FC
 set 7, (iy), l                 ; DD CB 00 FD
 set 7, (iy+0)                  ; DD CB 00 FE
 set 7, (iy+0), a               ; DD CB 00 FF
 set 7, (iy+0), b               ; DD CB 00 F8
 set 7, (iy+0), c               ; DD CB 00 F9
 set 7, (iy+0), d               ; DD CB 00 FA
 set 7, (iy+0), e               ; DD CB 00 FB
 set 7, (iy+0), h               ; DD CB 00 FC
 set 7, (iy+0), l               ; DD CB 00 FD
 set 7, (iy+126)                ; DD CB 7E FE
 set 7, (iy+126), a             ; DD CB 7E FF
 set 7, (iy+126), b             ; DD CB 7E F8
 set 7, (iy+126), c             ; DD CB 7E F9
 set 7, (iy+126), d             ; DD CB 7E FA
 set 7, (iy+126), e             ; DD CB 7E FB
 set 7, (iy+126), h             ; DD CB 7E FC
 set 7, (iy+126), l             ; DD CB 7E FD
 set 7, (iy-128)                ; DD CB 80 FE
 set 7, (iy-128), a             ; DD CB 80 FF
 set 7, (iy-128), b             ; DD CB 80 F8
 set 7, (iy-128), c             ; DD CB 80 F9
 set 7, (iy-128), d             ; DD CB 80 FA
 set 7, (iy-128), e             ; DD CB 80 FB
 set 7, (iy-128), h             ; DD CB 80 FC
 set 7, (iy-128), l             ; DD CB 80 FD
 set 7, a                       ; CB FF
 set 7, b                       ; CB F8
 set 7, c                       ; CB F9
 set 7, d                       ; CB FA
 set 7, e                       ; CB FB
 set 7, h                       ; CB FC
 set 7, l                       ; CB FD
 setae                          ; ED 95
 sla (hl)                       ; CB 26
 sla (ix)                       ; FD CB 00 26
 sla (ix), a                    ; FD CB 00 27
 sla (ix), b                    ; FD CB 00 20
 sla (ix), c                    ; FD CB 00 21
 sla (ix), d                    ; FD CB 00 22
 sla (ix), e                    ; FD CB 00 23
 sla (ix), h                    ; FD CB 00 24
 sla (ix), l                    ; FD CB 00 25
 sla (ix+0)                     ; FD CB 00 26
 sla (ix+0), a                  ; FD CB 00 27
 sla (ix+0), b                  ; FD CB 00 20
 sla (ix+0), c                  ; FD CB 00 21
 sla (ix+0), d                  ; FD CB 00 22
 sla (ix+0), e                  ; FD CB 00 23
 sla (ix+0), h                  ; FD CB 00 24
 sla (ix+0), l                  ; FD CB 00 25
 sla (ix+126)                   ; FD CB 7E 26
 sla (ix+126), a                ; FD CB 7E 27
 sla (ix+126), b                ; FD CB 7E 20
 sla (ix+126), c                ; FD CB 7E 21
 sla (ix+126), d                ; FD CB 7E 22
 sla (ix+126), e                ; FD CB 7E 23
 sla (ix+126), h                ; FD CB 7E 24
 sla (ix+126), l                ; FD CB 7E 25
 sla (ix-128)                   ; FD CB 80 26
 sla (ix-128), a                ; FD CB 80 27
 sla (ix-128), b                ; FD CB 80 20
 sla (ix-128), c                ; FD CB 80 21
 sla (ix-128), d                ; FD CB 80 22
 sla (ix-128), e                ; FD CB 80 23
 sla (ix-128), h                ; FD CB 80 24
 sla (ix-128), l                ; FD CB 80 25
 sla (iy)                       ; DD CB 00 26
 sla (iy), a                    ; DD CB 00 27
 sla (iy), b                    ; DD CB 00 20
 sla (iy), c                    ; DD CB 00 21
 sla (iy), d                    ; DD CB 00 22
 sla (iy), e                    ; DD CB 00 23
 sla (iy), h                    ; DD CB 00 24
 sla (iy), l                    ; DD CB 00 25
 sla (iy+0)                     ; DD CB 00 26
 sla (iy+0), a                  ; DD CB 00 27
 sla (iy+0), b                  ; DD CB 00 20
 sla (iy+0), c                  ; DD CB 00 21
 sla (iy+0), d                  ; DD CB 00 22
 sla (iy+0), e                  ; DD CB 00 23
 sla (iy+0), h                  ; DD CB 00 24
 sla (iy+0), l                  ; DD CB 00 25
 sla (iy+126)                   ; DD CB 7E 26
 sla (iy+126), a                ; DD CB 7E 27
 sla (iy+126), b                ; DD CB 7E 20
 sla (iy+126), c                ; DD CB 7E 21
 sla (iy+126), d                ; DD CB 7E 22
 sla (iy+126), e                ; DD CB 7E 23
 sla (iy+126), h                ; DD CB 7E 24
 sla (iy+126), l                ; DD CB 7E 25
 sla (iy-128)                   ; DD CB 80 26
 sla (iy-128), a                ; DD CB 80 27
 sla (iy-128), b                ; DD CB 80 20
 sla (iy-128), c                ; DD CB 80 21
 sla (iy-128), d                ; DD CB 80 22
 sla (iy-128), e                ; DD CB 80 23
 sla (iy-128), h                ; DD CB 80 24
 sla (iy-128), l                ; DD CB 80 25
 sla a                          ; CB 27
 sla b                          ; CB 20
 sla c                          ; CB 21
 sla d                          ; CB 22
 sla e                          ; CB 23
 sla h                          ; CB 24
 sla l                          ; CB 25
 sli (ix), a                    ; FD CB 00 37
 sli (ix), b                    ; FD CB 00 30
 sli (ix), c                    ; FD CB 00 31
 sli (ix), d                    ; FD CB 00 32
 sli (ix), e                    ; FD CB 00 33
 sli (ix), h                    ; FD CB 00 34
 sli (ix), l                    ; FD CB 00 35
 sli (ix+0), a                  ; FD CB 00 37
 sli (ix+0), b                  ; FD CB 00 30
 sli (ix+0), c                  ; FD CB 00 31
 sli (ix+0), d                  ; FD CB 00 32
 sli (ix+0), e                  ; FD CB 00 33
 sli (ix+0), h                  ; FD CB 00 34
 sli (ix+0), l                  ; FD CB 00 35
 sli (ix+126), a                ; FD CB 7E 37
 sli (ix+126), b                ; FD CB 7E 30
 sli (ix+126), c                ; FD CB 7E 31
 sli (ix+126), d                ; FD CB 7E 32
 sli (ix+126), e                ; FD CB 7E 33
 sli (ix+126), h                ; FD CB 7E 34
 sli (ix+126), l                ; FD CB 7E 35
 sli (ix-128), a                ; FD CB 80 37
 sli (ix-128), b                ; FD CB 80 30
 sli (ix-128), c                ; FD CB 80 31
 sli (ix-128), d                ; FD CB 80 32
 sli (ix-128), e                ; FD CB 80 33
 sli (ix-128), h                ; FD CB 80 34
 sli (ix-128), l                ; FD CB 80 35
 sli (iy), a                    ; DD CB 00 37
 sli (iy), b                    ; DD CB 00 30
 sli (iy), c                    ; DD CB 00 31
 sli (iy), d                    ; DD CB 00 32
 sli (iy), e                    ; DD CB 00 33
 sli (iy), h                    ; DD CB 00 34
 sli (iy), l                    ; DD CB 00 35
 sli (iy+0), a                  ; DD CB 00 37
 sli (iy+0), b                  ; DD CB 00 30
 sli (iy+0), c                  ; DD CB 00 31
 sli (iy+0), d                  ; DD CB 00 32
 sli (iy+0), e                  ; DD CB 00 33
 sli (iy+0), h                  ; DD CB 00 34
 sli (iy+0), l                  ; DD CB 00 35
 sli (iy+126), a                ; DD CB 7E 37
 sli (iy+126), b                ; DD CB 7E 30
 sli (iy+126), c                ; DD CB 7E 31
 sli (iy+126), d                ; DD CB 7E 32
 sli (iy+126), e                ; DD CB 7E 33
 sli (iy+126), h                ; DD CB 7E 34
 sli (iy+126), l                ; DD CB 7E 35
 sli (iy-128), a                ; DD CB 80 37
 sli (iy-128), b                ; DD CB 80 30
 sli (iy-128), c                ; DD CB 80 31
 sli (iy-128), d                ; DD CB 80 32
 sli (iy-128), e                ; DD CB 80 33
 sli (iy-128), h                ; DD CB 80 34
 sli (iy-128), l                ; DD CB 80 35
 sll (ix), a                    ; FD CB 00 37
 sll (ix), b                    ; FD CB 00 30
 sll (ix), c                    ; FD CB 00 31
 sll (ix), d                    ; FD CB 00 32
 sll (ix), e                    ; FD CB 00 33
 sll (ix), h                    ; FD CB 00 34
 sll (ix), l                    ; FD CB 00 35
 sll (ix+0), a                  ; FD CB 00 37
 sll (ix+0), b                  ; FD CB 00 30
 sll (ix+0), c                  ; FD CB 00 31
 sll (ix+0), d                  ; FD CB 00 32
 sll (ix+0), e                  ; FD CB 00 33
 sll (ix+0), h                  ; FD CB 00 34
 sll (ix+0), l                  ; FD CB 00 35
 sll (ix+126), a                ; FD CB 7E 37
 sll (ix+126), b                ; FD CB 7E 30
 sll (ix+126), c                ; FD CB 7E 31
 sll (ix+126), d                ; FD CB 7E 32
 sll (ix+126), e                ; FD CB 7E 33
 sll (ix+126), h                ; FD CB 7E 34
 sll (ix+126), l                ; FD CB 7E 35
 sll (ix-128), a                ; FD CB 80 37
 sll (ix-128), b                ; FD CB 80 30
 sll (ix-128), c                ; FD CB 80 31
 sll (ix-128), d                ; FD CB 80 32
 sll (ix-128), e                ; FD CB 80 33
 sll (ix-128), h                ; FD CB 80 34
 sll (ix-128), l                ; FD CB 80 35
 sll (iy), a                    ; DD CB 00 37
 sll (iy), b                    ; DD CB 00 30
 sll (iy), c                    ; DD CB 00 31
 sll (iy), d                    ; DD CB 00 32
 sll (iy), e                    ; DD CB 00 33
 sll (iy), h                    ; DD CB 00 34
 sll (iy), l                    ; DD CB 00 35
 sll (iy+0), a                  ; DD CB 00 37
 sll (iy+0), b                  ; DD CB 00 30
 sll (iy+0), c                  ; DD CB 00 31
 sll (iy+0), d                  ; DD CB 00 32
 sll (iy+0), e                  ; DD CB 00 33
 sll (iy+0), h                  ; DD CB 00 34
 sll (iy+0), l                  ; DD CB 00 35
 sll (iy+126), a                ; DD CB 7E 37
 sll (iy+126), b                ; DD CB 7E 30
 sll (iy+126), c                ; DD CB 7E 31
 sll (iy+126), d                ; DD CB 7E 32
 sll (iy+126), e                ; DD CB 7E 33
 sll (iy+126), h                ; DD CB 7E 34
 sll (iy+126), l                ; DD CB 7E 35
 sll (iy-128), a                ; DD CB 80 37
 sll (iy-128), b                ; DD CB 80 30
 sll (iy-128), c                ; DD CB 80 31
 sll (iy-128), d                ; DD CB 80 32
 sll (iy-128), e                ; DD CB 80 33
 sll (iy-128), h                ; DD CB 80 34
 sll (iy-128), l                ; DD CB 80 35
 sls (ix), a                    ; FD CB 00 37
 sls (ix), b                    ; FD CB 00 30
 sls (ix), c                    ; FD CB 00 31
 sls (ix), d                    ; FD CB 00 32
 sls (ix), e                    ; FD CB 00 33
 sls (ix), h                    ; FD CB 00 34
 sls (ix), l                    ; FD CB 00 35
 sls (ix+0), a                  ; FD CB 00 37
 sls (ix+0), b                  ; FD CB 00 30
 sls (ix+0), c                  ; FD CB 00 31
 sls (ix+0), d                  ; FD CB 00 32
 sls (ix+0), e                  ; FD CB 00 33
 sls (ix+0), h                  ; FD CB 00 34
 sls (ix+0), l                  ; FD CB 00 35
 sls (ix+126), a                ; FD CB 7E 37
 sls (ix+126), b                ; FD CB 7E 30
 sls (ix+126), c                ; FD CB 7E 31
 sls (ix+126), d                ; FD CB 7E 32
 sls (ix+126), e                ; FD CB 7E 33
 sls (ix+126), h                ; FD CB 7E 34
 sls (ix+126), l                ; FD CB 7E 35
 sls (ix-128), a                ; FD CB 80 37
 sls (ix-128), b                ; FD CB 80 30
 sls (ix-128), c                ; FD CB 80 31
 sls (ix-128), d                ; FD CB 80 32
 sls (ix-128), e                ; FD CB 80 33
 sls (ix-128), h                ; FD CB 80 34
 sls (ix-128), l                ; FD CB 80 35
 sls (iy), a                    ; DD CB 00 37
 sls (iy), b                    ; DD CB 00 30
 sls (iy), c                    ; DD CB 00 31
 sls (iy), d                    ; DD CB 00 32
 sls (iy), e                    ; DD CB 00 33
 sls (iy), h                    ; DD CB 00 34
 sls (iy), l                    ; DD CB 00 35
 sls (iy+0), a                  ; DD CB 00 37
 sls (iy+0), b                  ; DD CB 00 30
 sls (iy+0), c                  ; DD CB 00 31
 sls (iy+0), d                  ; DD CB 00 32
 sls (iy+0), e                  ; DD CB 00 33
 sls (iy+0), h                  ; DD CB 00 34
 sls (iy+0), l                  ; DD CB 00 35
 sls (iy+126), a                ; DD CB 7E 37
 sls (iy+126), b                ; DD CB 7E 30
 sls (iy+126), c                ; DD CB 7E 31
 sls (iy+126), d                ; DD CB 7E 32
 sls (iy+126), e                ; DD CB 7E 33
 sls (iy+126), h                ; DD CB 7E 34
 sls (iy+126), l                ; DD CB 7E 35
 sls (iy-128), a                ; DD CB 80 37
 sls (iy-128), b                ; DD CB 80 30
 sls (iy-128), c                ; DD CB 80 31
 sls (iy-128), d                ; DD CB 80 32
 sls (iy-128), e                ; DD CB 80 33
 sls (iy-128), h                ; DD CB 80 34
 sls (iy-128), l                ; DD CB 80 35
 sra (hl)                       ; CB 2E
 sra (ix)                       ; FD CB 00 2E
 sra (ix), a                    ; FD CB 00 2F
 sra (ix), b                    ; FD CB 00 28
 sra (ix), c                    ; FD CB 00 29
 sra (ix), d                    ; FD CB 00 2A
 sra (ix), e                    ; FD CB 00 2B
 sra (ix), h                    ; FD CB 00 2C
 sra (ix), l                    ; FD CB 00 2D
 sra (ix+0)                     ; FD CB 00 2E
 sra (ix+0), a                  ; FD CB 00 2F
 sra (ix+0), b                  ; FD CB 00 28
 sra (ix+0), c                  ; FD CB 00 29
 sra (ix+0), d                  ; FD CB 00 2A
 sra (ix+0), e                  ; FD CB 00 2B
 sra (ix+0), h                  ; FD CB 00 2C
 sra (ix+0), l                  ; FD CB 00 2D
 sra (ix+126)                   ; FD CB 7E 2E
 sra (ix+126), a                ; FD CB 7E 2F
 sra (ix+126), b                ; FD CB 7E 28
 sra (ix+126), c                ; FD CB 7E 29
 sra (ix+126), d                ; FD CB 7E 2A
 sra (ix+126), e                ; FD CB 7E 2B
 sra (ix+126), h                ; FD CB 7E 2C
 sra (ix+126), l                ; FD CB 7E 2D
 sra (ix-128)                   ; FD CB 80 2E
 sra (ix-128), a                ; FD CB 80 2F
 sra (ix-128), b                ; FD CB 80 28
 sra (ix-128), c                ; FD CB 80 29
 sra (ix-128), d                ; FD CB 80 2A
 sra (ix-128), e                ; FD CB 80 2B
 sra (ix-128), h                ; FD CB 80 2C
 sra (ix-128), l                ; FD CB 80 2D
 sra (iy)                       ; DD CB 00 2E
 sra (iy), a                    ; DD CB 00 2F
 sra (iy), b                    ; DD CB 00 28
 sra (iy), c                    ; DD CB 00 29
 sra (iy), d                    ; DD CB 00 2A
 sra (iy), e                    ; DD CB 00 2B
 sra (iy), h                    ; DD CB 00 2C
 sra (iy), l                    ; DD CB 00 2D
 sra (iy+0)                     ; DD CB 00 2E
 sra (iy+0), a                  ; DD CB 00 2F
 sra (iy+0), b                  ; DD CB 00 28
 sra (iy+0), c                  ; DD CB 00 29
 sra (iy+0), d                  ; DD CB 00 2A
 sra (iy+0), e                  ; DD CB 00 2B
 sra (iy+0), h                  ; DD CB 00 2C
 sra (iy+0), l                  ; DD CB 00 2D
 sra (iy+126)                   ; DD CB 7E 2E
 sra (iy+126), a                ; DD CB 7E 2F
 sra (iy+126), b                ; DD CB 7E 28
 sra (iy+126), c                ; DD CB 7E 29
 sra (iy+126), d                ; DD CB 7E 2A
 sra (iy+126), e                ; DD CB 7E 2B
 sra (iy+126), h                ; DD CB 7E 2C
 sra (iy+126), l                ; DD CB 7E 2D
 sra (iy-128)                   ; DD CB 80 2E
 sra (iy-128), a                ; DD CB 80 2F
 sra (iy-128), b                ; DD CB 80 28
 sra (iy-128), c                ; DD CB 80 29
 sra (iy-128), d                ; DD CB 80 2A
 sra (iy-128), e                ; DD CB 80 2B
 sra (iy-128), h                ; DD CB 80 2C
 sra (iy-128), l                ; DD CB 80 2D
 sra a                          ; CB 2F
 sra b                          ; CB 28
 sra c                          ; CB 29
 sra d                          ; CB 2A
 sra e                          ; CB 2B
 sra h                          ; CB 2C
 sra l                          ; CB 2D
 srl (hl)                       ; CB 3E
 srl (ix)                       ; FD CB 00 3E
 srl (ix), a                    ; FD CB 00 3F
 srl (ix), b                    ; FD CB 00 38
 srl (ix), c                    ; FD CB 00 39
 srl (ix), d                    ; FD CB 00 3A
 srl (ix), e                    ; FD CB 00 3B
 srl (ix), h                    ; FD CB 00 3C
 srl (ix), l                    ; FD CB 00 3D
 srl (ix+0)                     ; FD CB 00 3E
 srl (ix+0), a                  ; FD CB 00 3F
 srl (ix+0), b                  ; FD CB 00 38
 srl (ix+0), c                  ; FD CB 00 39
 srl (ix+0), d                  ; FD CB 00 3A
 srl (ix+0), e                  ; FD CB 00 3B
 srl (ix+0), h                  ; FD CB 00 3C
 srl (ix+0), l                  ; FD CB 00 3D
 srl (ix+126)                   ; FD CB 7E 3E
 srl (ix+126), a                ; FD CB 7E 3F
 srl (ix+126), b                ; FD CB 7E 38
 srl (ix+126), c                ; FD CB 7E 39
 srl (ix+126), d                ; FD CB 7E 3A
 srl (ix+126), e                ; FD CB 7E 3B
 srl (ix+126), h                ; FD CB 7E 3C
 srl (ix+126), l                ; FD CB 7E 3D
 srl (ix-128)                   ; FD CB 80 3E
 srl (ix-128), a                ; FD CB 80 3F
 srl (ix-128), b                ; FD CB 80 38
 srl (ix-128), c                ; FD CB 80 39
 srl (ix-128), d                ; FD CB 80 3A
 srl (ix-128), e                ; FD CB 80 3B
 srl (ix-128), h                ; FD CB 80 3C
 srl (ix-128), l                ; FD CB 80 3D
 srl (iy)                       ; DD CB 00 3E
 srl (iy), a                    ; DD CB 00 3F
 srl (iy), b                    ; DD CB 00 38
 srl (iy), c                    ; DD CB 00 39
 srl (iy), d                    ; DD CB 00 3A
 srl (iy), e                    ; DD CB 00 3B
 srl (iy), h                    ; DD CB 00 3C
 srl (iy), l                    ; DD CB 00 3D
 srl (iy+0)                     ; DD CB 00 3E
 srl (iy+0), a                  ; DD CB 00 3F
 srl (iy+0), b                  ; DD CB 00 38
 srl (iy+0), c                  ; DD CB 00 39
 srl (iy+0), d                  ; DD CB 00 3A
 srl (iy+0), e                  ; DD CB 00 3B
 srl (iy+0), h                  ; DD CB 00 3C
 srl (iy+0), l                  ; DD CB 00 3D
 srl (iy+126)                   ; DD CB 7E 3E
 srl (iy+126), a                ; DD CB 7E 3F
 srl (iy+126), b                ; DD CB 7E 38
 srl (iy+126), c                ; DD CB 7E 39
 srl (iy+126), d                ; DD CB 7E 3A
 srl (iy+126), e                ; DD CB 7E 3B
 srl (iy+126), h                ; DD CB 7E 3C
 srl (iy+126), l                ; DD CB 7E 3D
 srl (iy-128)                   ; DD CB 80 3E
 srl (iy-128), a                ; DD CB 80 3F
 srl (iy-128), b                ; DD CB 80 38
 srl (iy-128), c                ; DD CB 80 39
 srl (iy-128), d                ; DD CB 80 3A
 srl (iy-128), e                ; DD CB 80 3B
 srl (iy-128), h                ; DD CB 80 3C
 srl (iy-128), l                ; DD CB 80 3D
 srl a                          ; CB 3F
 srl b                          ; CB 38
 srl c                          ; CB 39
 srl d                          ; CB 3A
 srl e                          ; CB 3B
 srl h                          ; CB 3C
 srl l                          ; CB 3D
 stae                           ; ED 95
 sub (hl)                       ; 96
 sub (ix)                       ; FD 96 00
 sub (ix+0)                     ; FD 96 00
 sub (ix+126)                   ; FD 96 7E
 sub (ix-128)                   ; FD 96 80
 sub (iy)                       ; DD 96 00
 sub (iy+0)                     ; DD 96 00
 sub (iy+126)                   ; DD 96 7E
 sub (iy-128)                   ; DD 96 80
 sub 0                          ; D6 00
 sub 127                        ; D6 7F
 sub 255                        ; D6 FF
 sub a                          ; 97
 sub b                          ; 90
 sub c                          ; 91
 sub d                          ; 92
 sub e                          ; 93
 sub h                          ; 94
 sub ixh                        ; FD 94
 sub ixl                        ; FD 95
 sub iyh                        ; DD 94
 sub iyl                        ; DD 95
 sub l                          ; 95
 swap                           ; ED 23
 swapnib                        ; ED 23
 test 0                         ; ED 27 00
 test 127                       ; ED 27 7F
 test 255                       ; ED 27 FF
 xor (hl)                       ; AE
 xor (ix)                       ; FD AE 00
 xor (ix+0)                     ; FD AE 00
 xor (ix+126)                   ; FD AE 7E
 xor (ix-128)                   ; FD AE 80
 xor (iy)                       ; DD AE 00
 xor (iy+0)                     ; DD AE 00
 xor (iy+126)                   ; DD AE 7E
 xor (iy-128)                   ; DD AE 80
 xor 0                          ; EE 00
 xor 127                        ; EE 7F
 xor 255                        ; EE FF
 xor a                          ; AF
 xor b                          ; A8
 xor c                          ; A9
 xor d                          ; AA
 xor e                          ; AB
 xor h                          ; AC
 xor ixh                        ; FD AC
 xor ixl                        ; FD AD
 xor iyh                        ; DD AC
 xor iyl                        ; DD AD
 xor l                          ; AD
