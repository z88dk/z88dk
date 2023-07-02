 aci -128                       ; CE 80
 aci 127                        ; CE 7F
 aci 255                        ; CE FF
 adc (hl)                       ; 8E
 adc (hl+)                      ; 8E 23
 adc (hl-)                      ; 8E 2B
 adc (ix)                       ; DD 8E 00
 adc (ix+126)                   ; DD 8E 7E
 adc (ix-128)                   ; DD 8E 80
 adc (iy)                       ; FD 8E 00
 adc (iy+126)                   ; FD 8E 7E
 adc (iy-128)                   ; FD 8E 80
 adc -128                       ; CE 80
 adc 127                        ; CE 7F
 adc 255                        ; CE FF
 adc a                          ; 8F
 adc a, (hl)                    ; 8E
 adc a, (hl+)                   ; 8E 23
 adc a, (hl-)                   ; 8E 2B
 adc a, (ix)                    ; DD 8E 00
 adc a, (ix+126)                ; DD 8E 7E
 adc a, (ix-128)                ; DD 8E 80
 adc a, (iy)                    ; FD 8E 00
 adc a, (iy+126)                ; FD 8E 7E
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
 adc m                          ; 8E
 adc.s (hl)                     ; 52 8E
 adc.s (hl+)                    ; 52 8E 23
 adc.s (hl-)                    ; 52 8E 2B
 adc.s (ix)                     ; 52 DD 8E 00
 adc.s (ix+126)                 ; 52 DD 8E 7E
 adc.s (ix-128)                 ; 52 DD 8E 80
 adc.s (iy)                     ; 52 FD 8E 00
 adc.s (iy+126)                 ; 52 FD 8E 7E
 adc.s (iy-128)                 ; 52 FD 8E 80
 adc.s a, (hl)                  ; 52 8E
 adc.s a, (hl+)                 ; 52 8E 23
 adc.s a, (hl-)                 ; 52 8E 2B
 adc.s a, (ix)                  ; 52 DD 8E 00
 adc.s a, (ix+126)              ; 52 DD 8E 7E
 adc.s a, (ix-128)              ; 52 DD 8E 80
 adc.s a, (iy)                  ; 52 FD 8E 00
 adc.s a, (iy+126)              ; 52 FD 8E 7E
 adc.s a, (iy-128)              ; 52 FD 8E 80
 adc.s hl, bc                   ; 52 ED 4A
 adc.s hl, de                   ; 52 ED 5A
 adc.s hl, hl                   ; 52 ED 6A
 adc.s hl, sp                   ; 52 ED 7A
 adc.sil (hl)                   ; 52 8E
 adc.sil (hl+)                  ; 52 8E 23
 adc.sil (hl-)                  ; 52 8E 2B
 adc.sil (ix)                   ; 52 DD 8E 00
 adc.sil (ix+126)               ; 52 DD 8E 7E
 adc.sil (ix-128)               ; 52 DD 8E 80
 adc.sil (iy)                   ; 52 FD 8E 00
 adc.sil (iy+126)               ; 52 FD 8E 7E
 adc.sil (iy-128)               ; 52 FD 8E 80
 adc.sil a, (hl)                ; 52 8E
 adc.sil a, (hl+)               ; 52 8E 23
 adc.sil a, (hl-)               ; 52 8E 2B
 adc.sil a, (ix)                ; 52 DD 8E 00
 adc.sil a, (ix+126)            ; 52 DD 8E 7E
 adc.sil a, (ix-128)            ; 52 DD 8E 80
 adc.sil a, (iy)                ; 52 FD 8E 00
 adc.sil a, (iy+126)            ; 52 FD 8E 7E
 adc.sil a, (iy-128)            ; 52 FD 8E 80
 adc.sil hl, bc                 ; 52 ED 4A
 adc.sil hl, de                 ; 52 ED 5A
 adc.sil hl, hl                 ; 52 ED 6A
 adc.sil hl, sp                 ; 52 ED 7A
 add (hl)                       ; 86
 add (hl+)                      ; 86 23
 add (hl-)                      ; 86 2B
 add (ix)                       ; DD 86 00
 add (ix+126)                   ; DD 86 7E
 add (ix-128)                   ; DD 86 80
 add (iy)                       ; FD 86 00
 add (iy+126)                   ; FD 86 7E
 add (iy-128)                   ; FD 86 80
 add -128                       ; C6 80
 add 127                        ; C6 7F
 add 255                        ; C6 FF
 add a                          ; 87
 add a, (hl)                    ; 86
 add a, (hl+)                   ; 86 23
 add a, (hl-)                   ; 86 2B
 add a, (ix)                    ; DD 86 00
 add a, (ix+126)                ; DD 86 7E
 add a, (ix-128)                ; DD 86 80
 add a, (iy)                    ; FD 86 00
 add a, (iy+126)                ; FD 86 7E
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
 add bc, -32768                 ; E5 21 00 80 09 44 4D E1
 add bc, 0x123456               ; E5 21 56 34 09 44 4D E1
 add bc, 32767                  ; E5 21 FF 7F 09 44 4D E1
 add bc, 65535                  ; E5 21 FF FF 09 44 4D E1
 add bc, a                      ; CD @__z80asm__add_bc_a
 add c                          ; 81
 add d                          ; 82
 add de, -32768                 ; E5 21 00 80 19 54 5D E1
 add de, 0x123456               ; E5 21 56 34 19 54 5D E1
 add de, 32767                  ; E5 21 FF 7F 19 54 5D E1
 add de, 65535                  ; E5 21 FF FF 19 54 5D E1
 add de, a                      ; CD @__z80asm__add_de_a
 add e                          ; 83
 add h                          ; 84
 add hl, -32768                 ; D5 11 00 80 19 D1
 add hl, 0x123456               ; D5 11 56 34 19 D1
 add hl, 32767                  ; D5 11 FF 7F 19 D1
 add hl, 65535                  ; D5 11 FF FF 19 D1
 add hl, a                      ; CD @__z80asm__add_hl_a
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
 add m                          ; 86
 add.s (hl)                     ; 52 86
 add.s (hl+)                    ; 52 86 23
 add.s (hl-)                    ; 52 86 2B
 add.s (ix)                     ; 52 DD 86 00
 add.s (ix+126)                 ; 52 DD 86 7E
 add.s (ix-128)                 ; 52 DD 86 80
 add.s (iy)                     ; 52 FD 86 00
 add.s (iy+126)                 ; 52 FD 86 7E
 add.s (iy-128)                 ; 52 FD 86 80
 add.s a, (hl)                  ; 52 86
 add.s a, (hl+)                 ; 52 86 23
 add.s a, (hl-)                 ; 52 86 2B
 add.s a, (ix)                  ; 52 DD 86 00
 add.s a, (ix+126)              ; 52 DD 86 7E
 add.s a, (ix-128)              ; 52 DD 86 80
 add.s a, (iy)                  ; 52 FD 86 00
 add.s a, (iy+126)              ; 52 FD 86 7E
 add.s a, (iy-128)              ; 52 FD 86 80
 add.s hl, bc                   ; 52 09
 add.s hl, de                   ; 52 19
 add.s hl, hl                   ; 52 29
 add.s hl, sp                   ; 52 39
 add.s ix, bc                   ; 52 DD 09
 add.s ix, de                   ; 52 DD 19
 add.s ix, ix                   ; 52 DD 29
 add.s ix, sp                   ; 52 DD 39
 add.s iy, bc                   ; 52 FD 09
 add.s iy, de                   ; 52 FD 19
 add.s iy, iy                   ; 52 FD 29
 add.s iy, sp                   ; 52 FD 39
 add.sil (hl)                   ; 52 86
 add.sil (hl+)                  ; 52 86 23
 add.sil (hl-)                  ; 52 86 2B
 add.sil (ix)                   ; 52 DD 86 00
 add.sil (ix+126)               ; 52 DD 86 7E
 add.sil (ix-128)               ; 52 DD 86 80
 add.sil (iy)                   ; 52 FD 86 00
 add.sil (iy+126)               ; 52 FD 86 7E
 add.sil (iy-128)               ; 52 FD 86 80
 add.sil a, (hl)                ; 52 86
 add.sil a, (hl+)               ; 52 86 23
 add.sil a, (hl-)               ; 52 86 2B
 add.sil a, (ix)                ; 52 DD 86 00
 add.sil a, (ix+126)            ; 52 DD 86 7E
 add.sil a, (ix-128)            ; 52 DD 86 80
 add.sil a, (iy)                ; 52 FD 86 00
 add.sil a, (iy+126)            ; 52 FD 86 7E
 add.sil a, (iy-128)            ; 52 FD 86 80
 add.sil hl, bc                 ; 52 09
 add.sil hl, de                 ; 52 19
 add.sil hl, hl                 ; 52 29
 add.sil hl, sp                 ; 52 39
 add.sil ix, bc                 ; 52 DD 09
 add.sil ix, de                 ; 52 DD 19
 add.sil ix, ix                 ; 52 DD 29
 add.sil ix, sp                 ; 52 DD 39
 add.sil iy, bc                 ; 52 FD 09
 add.sil iy, de                 ; 52 FD 19
 add.sil iy, iy                 ; 52 FD 29
 add.sil iy, sp                 ; 52 FD 39
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
 and (hl+)                      ; A6 23
 and (hl-)                      ; A6 2B
 and (ix)                       ; DD A6 00
 and (ix+126)                   ; DD A6 7E
 and (ix-128)                   ; DD A6 80
 and (iy)                       ; FD A6 00
 and (iy+126)                   ; FD A6 7E
 and (iy-128)                   ; FD A6 80
 and -128                       ; E6 80
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; A7
 and a, (hl)                    ; A6
 and a, (hl+)                   ; A6 23
 and a, (hl-)                   ; A6 2B
 and a, (ix)                    ; DD A6 00
 and a, (ix+126)                ; DD A6 7E
 and a, (ix-128)                ; DD A6 80
 and a, (iy)                    ; FD A6 00
 and a, (iy+126)                ; FD A6 7E
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
 and.s (hl)                     ; 52 A6
 and.s (hl+)                    ; 52 A6 23
 and.s (hl-)                    ; 52 A6 2B
 and.s (ix)                     ; 52 DD A6 00
 and.s (ix+126)                 ; 52 DD A6 7E
 and.s (ix-128)                 ; 52 DD A6 80
 and.s (iy)                     ; 52 FD A6 00
 and.s (iy+126)                 ; 52 FD A6 7E
 and.s (iy-128)                 ; 52 FD A6 80
 and.s a, (hl)                  ; 52 A6
 and.s a, (hl+)                 ; 52 A6 23
 and.s a, (hl-)                 ; 52 A6 2B
 and.s a, (ix)                  ; 52 DD A6 00
 and.s a, (ix+126)              ; 52 DD A6 7E
 and.s a, (ix-128)              ; 52 DD A6 80
 and.s a, (iy)                  ; 52 FD A6 00
 and.s a, (iy+126)              ; 52 FD A6 7E
 and.s a, (iy-128)              ; 52 FD A6 80
 and.sil (hl)                   ; 52 A6
 and.sil (hl+)                  ; 52 A6 23
 and.sil (hl-)                  ; 52 A6 2B
 and.sil (ix)                   ; 52 DD A6 00
 and.sil (ix+126)               ; 52 DD A6 7E
 and.sil (ix-128)               ; 52 DD A6 80
 and.sil (iy)                   ; 52 FD A6 00
 and.sil (iy+126)               ; 52 FD A6 7E
 and.sil (iy-128)               ; 52 FD A6 80
 and.sil a, (hl)                ; 52 A6
 and.sil a, (hl+)               ; 52 A6 23
 and.sil a, (hl-)               ; 52 A6 2B
 and.sil a, (ix)                ; 52 DD A6 00
 and.sil a, (ix+126)            ; 52 DD A6 7E
 and.sil a, (ix-128)            ; 52 DD A6 80
 and.sil a, (iy)                ; 52 FD A6 00
 and.sil a, (iy+126)            ; 52 FD A6 7E
 and.sil a, (iy-128)            ; 52 FD A6 80
 ani -128                       ; E6 80
 ani 127                        ; E6 7F
 ani 255                        ; E6 FF
 arhl                           ; CB 2C CB 1D
 bit 0, (hl)                    ; CB 46
 bit 0, (ix)                    ; DD CB 00 46
 bit 0, (ix+126)                ; DD CB 7E 46
 bit 0, (ix-128)                ; DD CB 80 46
 bit 0, (iy)                    ; FD CB 00 46
 bit 0, (iy+126)                ; FD CB 7E 46
 bit 0, (iy-128)                ; FD CB 80 46
 bit 0, a                       ; CB 47
 bit 0, b                       ; CB 40
 bit 0, c                       ; CB 41
 bit 0, d                       ; CB 42
 bit 0, e                       ; CB 43
 bit 0, h                       ; CB 44
 bit 0, l                       ; CB 45
 bit 1, (hl)                    ; CB 4E
 bit 1, (ix)                    ; DD CB 00 4E
 bit 1, (ix+126)                ; DD CB 7E 4E
 bit 1, (ix-128)                ; DD CB 80 4E
 bit 1, (iy)                    ; FD CB 00 4E
 bit 1, (iy+126)                ; FD CB 7E 4E
 bit 1, (iy-128)                ; FD CB 80 4E
 bit 1, a                       ; CB 4F
 bit 1, b                       ; CB 48
 bit 1, c                       ; CB 49
 bit 1, d                       ; CB 4A
 bit 1, e                       ; CB 4B
 bit 1, h                       ; CB 4C
 bit 1, l                       ; CB 4D
 bit 2, (hl)                    ; CB 56
 bit 2, (ix)                    ; DD CB 00 56
 bit 2, (ix+126)                ; DD CB 7E 56
 bit 2, (ix-128)                ; DD CB 80 56
 bit 2, (iy)                    ; FD CB 00 56
 bit 2, (iy+126)                ; FD CB 7E 56
 bit 2, (iy-128)                ; FD CB 80 56
 bit 2, a                       ; CB 57
 bit 2, b                       ; CB 50
 bit 2, c                       ; CB 51
 bit 2, d                       ; CB 52
 bit 2, e                       ; CB 53
 bit 2, h                       ; CB 54
 bit 2, l                       ; CB 55
 bit 3, (hl)                    ; CB 5E
 bit 3, (ix)                    ; DD CB 00 5E
 bit 3, (ix+126)                ; DD CB 7E 5E
 bit 3, (ix-128)                ; DD CB 80 5E
 bit 3, (iy)                    ; FD CB 00 5E
 bit 3, (iy+126)                ; FD CB 7E 5E
 bit 3, (iy-128)                ; FD CB 80 5E
 bit 3, a                       ; CB 5F
 bit 3, b                       ; CB 58
 bit 3, c                       ; CB 59
 bit 3, d                       ; CB 5A
 bit 3, e                       ; CB 5B
 bit 3, h                       ; CB 5C
 bit 3, l                       ; CB 5D
 bit 4, (hl)                    ; CB 66
 bit 4, (ix)                    ; DD CB 00 66
 bit 4, (ix+126)                ; DD CB 7E 66
 bit 4, (ix-128)                ; DD CB 80 66
 bit 4, (iy)                    ; FD CB 00 66
 bit 4, (iy+126)                ; FD CB 7E 66
 bit 4, (iy-128)                ; FD CB 80 66
 bit 4, a                       ; CB 67
 bit 4, b                       ; CB 60
 bit 4, c                       ; CB 61
 bit 4, d                       ; CB 62
 bit 4, e                       ; CB 63
 bit 4, h                       ; CB 64
 bit 4, l                       ; CB 65
 bit 5, (hl)                    ; CB 6E
 bit 5, (ix)                    ; DD CB 00 6E
 bit 5, (ix+126)                ; DD CB 7E 6E
 bit 5, (ix-128)                ; DD CB 80 6E
 bit 5, (iy)                    ; FD CB 00 6E
 bit 5, (iy+126)                ; FD CB 7E 6E
 bit 5, (iy-128)                ; FD CB 80 6E
 bit 5, a                       ; CB 6F
 bit 5, b                       ; CB 68
 bit 5, c                       ; CB 69
 bit 5, d                       ; CB 6A
 bit 5, e                       ; CB 6B
 bit 5, h                       ; CB 6C
 bit 5, l                       ; CB 6D
 bit 6, (hl)                    ; CB 76
 bit 6, (ix)                    ; DD CB 00 76
 bit 6, (ix+126)                ; DD CB 7E 76
 bit 6, (ix-128)                ; DD CB 80 76
 bit 6, (iy)                    ; FD CB 00 76
 bit 6, (iy+126)                ; FD CB 7E 76
 bit 6, (iy-128)                ; FD CB 80 76
 bit 6, a                       ; CB 77
 bit 6, b                       ; CB 70
 bit 6, c                       ; CB 71
 bit 6, d                       ; CB 72
 bit 6, e                       ; CB 73
 bit 6, h                       ; CB 74
 bit 6, l                       ; CB 75
 bit 7, (hl)                    ; CB 7E
 bit 7, (ix)                    ; DD CB 00 7E
 bit 7, (ix+126)                ; DD CB 7E 7E
 bit 7, (ix-128)                ; DD CB 80 7E
 bit 7, (iy)                    ; FD CB 00 7E
 bit 7, (iy+126)                ; FD CB 7E 7E
 bit 7, (iy-128)                ; FD CB 80 7E
 bit 7, a                       ; CB 7F
 bit 7, b                       ; CB 78
 bit 7, c                       ; CB 79
 bit 7, d                       ; CB 7A
 bit 7, e                       ; CB 7B
 bit 7, h                       ; CB 7C
 bit 7, l                       ; CB 7D
 bit.s 0, (hl)                  ; 52 CB 46
 bit.s 0, (ix)                  ; 52 DD CB 00 46
 bit.s 0, (ix+126)              ; 52 DD CB 7E 46
 bit.s 0, (ix-128)              ; 52 DD CB 80 46
 bit.s 0, (iy)                  ; 52 FD CB 00 46
 bit.s 0, (iy+126)              ; 52 FD CB 7E 46
 bit.s 0, (iy-128)              ; 52 FD CB 80 46
 bit.s 1, (hl)                  ; 52 CB 4E
 bit.s 1, (ix)                  ; 52 DD CB 00 4E
 bit.s 1, (ix+126)              ; 52 DD CB 7E 4E
 bit.s 1, (ix-128)              ; 52 DD CB 80 4E
 bit.s 1, (iy)                  ; 52 FD CB 00 4E
 bit.s 1, (iy+126)              ; 52 FD CB 7E 4E
 bit.s 1, (iy-128)              ; 52 FD CB 80 4E
 bit.s 2, (hl)                  ; 52 CB 56
 bit.s 2, (ix)                  ; 52 DD CB 00 56
 bit.s 2, (ix+126)              ; 52 DD CB 7E 56
 bit.s 2, (ix-128)              ; 52 DD CB 80 56
 bit.s 2, (iy)                  ; 52 FD CB 00 56
 bit.s 2, (iy+126)              ; 52 FD CB 7E 56
 bit.s 2, (iy-128)              ; 52 FD CB 80 56
 bit.s 3, (hl)                  ; 52 CB 5E
 bit.s 3, (ix)                  ; 52 DD CB 00 5E
 bit.s 3, (ix+126)              ; 52 DD CB 7E 5E
 bit.s 3, (ix-128)              ; 52 DD CB 80 5E
 bit.s 3, (iy)                  ; 52 FD CB 00 5E
 bit.s 3, (iy+126)              ; 52 FD CB 7E 5E
 bit.s 3, (iy-128)              ; 52 FD CB 80 5E
 bit.s 4, (hl)                  ; 52 CB 66
 bit.s 4, (ix)                  ; 52 DD CB 00 66
 bit.s 4, (ix+126)              ; 52 DD CB 7E 66
 bit.s 4, (ix-128)              ; 52 DD CB 80 66
 bit.s 4, (iy)                  ; 52 FD CB 00 66
 bit.s 4, (iy+126)              ; 52 FD CB 7E 66
 bit.s 4, (iy-128)              ; 52 FD CB 80 66
 bit.s 5, (hl)                  ; 52 CB 6E
 bit.s 5, (ix)                  ; 52 DD CB 00 6E
 bit.s 5, (ix+126)              ; 52 DD CB 7E 6E
 bit.s 5, (ix-128)              ; 52 DD CB 80 6E
 bit.s 5, (iy)                  ; 52 FD CB 00 6E
 bit.s 5, (iy+126)              ; 52 FD CB 7E 6E
 bit.s 5, (iy-128)              ; 52 FD CB 80 6E
 bit.s 6, (hl)                  ; 52 CB 76
 bit.s 6, (ix)                  ; 52 DD CB 00 76
 bit.s 6, (ix+126)              ; 52 DD CB 7E 76
 bit.s 6, (ix-128)              ; 52 DD CB 80 76
 bit.s 6, (iy)                  ; 52 FD CB 00 76
 bit.s 6, (iy+126)              ; 52 FD CB 7E 76
 bit.s 6, (iy-128)              ; 52 FD CB 80 76
 bit.s 7, (hl)                  ; 52 CB 7E
 bit.s 7, (ix)                  ; 52 DD CB 00 7E
 bit.s 7, (ix+126)              ; 52 DD CB 7E 7E
 bit.s 7, (ix-128)              ; 52 DD CB 80 7E
 bit.s 7, (iy)                  ; 52 FD CB 00 7E
 bit.s 7, (iy+126)              ; 52 FD CB 7E 7E
 bit.s 7, (iy-128)              ; 52 FD CB 80 7E
 bit.sil 0, (hl)                ; 52 CB 46
 bit.sil 0, (ix)                ; 52 DD CB 00 46
 bit.sil 0, (ix+126)            ; 52 DD CB 7E 46
 bit.sil 0, (ix-128)            ; 52 DD CB 80 46
 bit.sil 0, (iy)                ; 52 FD CB 00 46
 bit.sil 0, (iy+126)            ; 52 FD CB 7E 46
 bit.sil 0, (iy-128)            ; 52 FD CB 80 46
 bit.sil 1, (hl)                ; 52 CB 4E
 bit.sil 1, (ix)                ; 52 DD CB 00 4E
 bit.sil 1, (ix+126)            ; 52 DD CB 7E 4E
 bit.sil 1, (ix-128)            ; 52 DD CB 80 4E
 bit.sil 1, (iy)                ; 52 FD CB 00 4E
 bit.sil 1, (iy+126)            ; 52 FD CB 7E 4E
 bit.sil 1, (iy-128)            ; 52 FD CB 80 4E
 bit.sil 2, (hl)                ; 52 CB 56
 bit.sil 2, (ix)                ; 52 DD CB 00 56
 bit.sil 2, (ix+126)            ; 52 DD CB 7E 56
 bit.sil 2, (ix-128)            ; 52 DD CB 80 56
 bit.sil 2, (iy)                ; 52 FD CB 00 56
 bit.sil 2, (iy+126)            ; 52 FD CB 7E 56
 bit.sil 2, (iy-128)            ; 52 FD CB 80 56
 bit.sil 3, (hl)                ; 52 CB 5E
 bit.sil 3, (ix)                ; 52 DD CB 00 5E
 bit.sil 3, (ix+126)            ; 52 DD CB 7E 5E
 bit.sil 3, (ix-128)            ; 52 DD CB 80 5E
 bit.sil 3, (iy)                ; 52 FD CB 00 5E
 bit.sil 3, (iy+126)            ; 52 FD CB 7E 5E
 bit.sil 3, (iy-128)            ; 52 FD CB 80 5E
 bit.sil 4, (hl)                ; 52 CB 66
 bit.sil 4, (ix)                ; 52 DD CB 00 66
 bit.sil 4, (ix+126)            ; 52 DD CB 7E 66
 bit.sil 4, (ix-128)            ; 52 DD CB 80 66
 bit.sil 4, (iy)                ; 52 FD CB 00 66
 bit.sil 4, (iy+126)            ; 52 FD CB 7E 66
 bit.sil 4, (iy-128)            ; 52 FD CB 80 66
 bit.sil 5, (hl)                ; 52 CB 6E
 bit.sil 5, (ix)                ; 52 DD CB 00 6E
 bit.sil 5, (ix+126)            ; 52 DD CB 7E 6E
 bit.sil 5, (ix-128)            ; 52 DD CB 80 6E
 bit.sil 5, (iy)                ; 52 FD CB 00 6E
 bit.sil 5, (iy+126)            ; 52 FD CB 7E 6E
 bit.sil 5, (iy-128)            ; 52 FD CB 80 6E
 bit.sil 6, (hl)                ; 52 CB 76
 bit.sil 6, (ix)                ; 52 DD CB 00 76
 bit.sil 6, (ix+126)            ; 52 DD CB 7E 76
 bit.sil 6, (ix-128)            ; 52 DD CB 80 76
 bit.sil 6, (iy)                ; 52 FD CB 00 76
 bit.sil 6, (iy+126)            ; 52 FD CB 7E 76
 bit.sil 6, (iy-128)            ; 52 FD CB 80 76
 bit.sil 7, (hl)                ; 52 CB 7E
 bit.sil 7, (ix)                ; 52 DD CB 00 7E
 bit.sil 7, (ix+126)            ; 52 DD CB 7E 7E
 bit.sil 7, (ix-128)            ; 52 DD CB 80 7E
 bit.sil 7, (iy)                ; 52 FD CB 00 7E
 bit.sil 7, (iy+126)            ; 52 FD CB 7E 7E
 bit.sil 7, (iy-128)            ; 52 FD CB 80 7E
 c_c -32768                     ; DC 00 80 FF
 c_c 0x123456                   ; DC 56 34 12
 c_c 32767                      ; DC FF 7F 00
 c_c 65535                      ; DC FF FF 00
 c_m -32768                     ; FC 00 80 FF
 c_m 0x123456                   ; FC 56 34 12
 c_m 32767                      ; FC FF 7F 00
 c_m 65535                      ; FC FF FF 00
 c_nc -32768                    ; D4 00 80 FF
 c_nc 0x123456                  ; D4 56 34 12
 c_nc 32767                     ; D4 FF 7F 00
 c_nc 65535                     ; D4 FF FF 00
 c_nv -32768                    ; E4 00 80 FF
 c_nv 0x123456                  ; E4 56 34 12
 c_nv 32767                     ; E4 FF 7F 00
 c_nv 65535                     ; E4 FF FF 00
 c_nz -32768                    ; C4 00 80 FF
 c_nz 0x123456                  ; C4 56 34 12
 c_nz 32767                     ; C4 FF 7F 00
 c_nz 65535                     ; C4 FF FF 00
 c_p -32768                     ; F4 00 80 FF
 c_p 0x123456                   ; F4 56 34 12
 c_p 32767                      ; F4 FF 7F 00
 c_p 65535                      ; F4 FF FF 00
 c_pe -32768                    ; EC 00 80 FF
 c_pe 0x123456                  ; EC 56 34 12
 c_pe 32767                     ; EC FF 7F 00
 c_pe 65535                     ; EC FF FF 00
 c_po -32768                    ; E4 00 80 FF
 c_po 0x123456                  ; E4 56 34 12
 c_po 32767                     ; E4 FF 7F 00
 c_po 65535                     ; E4 FF FF 00
 c_v -32768                     ; EC 00 80 FF
 c_v 0x123456                   ; EC 56 34 12
 c_v 32767                      ; EC FF 7F 00
 c_v 65535                      ; EC FF FF 00
 c_z -32768                     ; CC 00 80 FF
 c_z 0x123456                   ; CC 56 34 12
 c_z 32767                      ; CC FF 7F 00
 c_z 65535                      ; CC FF FF 00
 call -32768                    ; CD 00 80 FF
 call 0x123456                  ; CD 56 34 12
 call 32767                     ; CD FF 7F 00
 call 65535                     ; CD FF FF 00
 call c, -32768                 ; DC 00 80 FF
 call c, 0x123456               ; DC 56 34 12
 call c, 32767                  ; DC FF 7F 00
 call c, 65535                  ; DC FF FF 00
 call m, -32768                 ; FC 00 80 FF
 call m, 0x123456               ; FC 56 34 12
 call m, 32767                  ; FC FF 7F 00
 call m, 65535                  ; FC FF FF 00
 call nc, -32768                ; D4 00 80 FF
 call nc, 0x123456              ; D4 56 34 12
 call nc, 32767                 ; D4 FF 7F 00
 call nc, 65535                 ; D4 FF FF 00
 call nv, -32768                ; E4 00 80 FF
 call nv, 0x123456              ; E4 56 34 12
 call nv, 32767                 ; E4 FF 7F 00
 call nv, 65535                 ; E4 FF FF 00
 call nz, -32768                ; C4 00 80 FF
 call nz, 0x123456              ; C4 56 34 12
 call nz, 32767                 ; C4 FF 7F 00
 call nz, 65535                 ; C4 FF FF 00
 call p, -32768                 ; F4 00 80 FF
 call p, 0x123456               ; F4 56 34 12
 call p, 32767                  ; F4 FF 7F 00
 call p, 65535                  ; F4 FF FF 00
 call pe, -32768                ; EC 00 80 FF
 call pe, 0x123456              ; EC 56 34 12
 call pe, 32767                 ; EC FF 7F 00
 call pe, 65535                 ; EC FF FF 00
 call po, -32768                ; E4 00 80 FF
 call po, 0x123456              ; E4 56 34 12
 call po, 32767                 ; E4 FF 7F 00
 call po, 65535                 ; E4 FF FF 00
 call v, -32768                 ; EC 00 80 FF
 call v, 0x123456               ; EC 56 34 12
 call v, 32767                  ; EC FF 7F 00
 call v, 65535                  ; EC FF FF 00
 call z, -32768                 ; CC 00 80 FF
 call z, 0x123456               ; CC 56 34 12
 call z, 32767                  ; CC FF 7F 00
 call z, 65535                  ; CC FF FF 00
 call.il -32768                 ; 5B CD 00 80 FF
 call.il 0x123456               ; 5B CD 56 34 12
 call.il 32767                  ; 5B CD FF 7F 00
 call.il 65535                  ; 5B CD FF FF 00
 call.il c, -32768              ; 5B DC 00 80 FF
 call.il c, 0x123456            ; 5B DC 56 34 12
 call.il c, 32767               ; 5B DC FF 7F 00
 call.il c, 65535               ; 5B DC FF FF 00
 call.il m, -32768              ; 5B FC 00 80 FF
 call.il m, 0x123456            ; 5B FC 56 34 12
 call.il m, 32767               ; 5B FC FF 7F 00
 call.il m, 65535               ; 5B FC FF FF 00
 call.il nc, -32768             ; 5B D4 00 80 FF
 call.il nc, 0x123456           ; 5B D4 56 34 12
 call.il nc, 32767              ; 5B D4 FF 7F 00
 call.il nc, 65535              ; 5B D4 FF FF 00
 call.il nv, -32768             ; 5B E4 00 80 FF
 call.il nv, 0x123456           ; 5B E4 56 34 12
 call.il nv, 32767              ; 5B E4 FF 7F 00
 call.il nv, 65535              ; 5B E4 FF FF 00
 call.il nz, -32768             ; 5B C4 00 80 FF
 call.il nz, 0x123456           ; 5B C4 56 34 12
 call.il nz, 32767              ; 5B C4 FF 7F 00
 call.il nz, 65535              ; 5B C4 FF FF 00
 call.il p, -32768              ; 5B F4 00 80 FF
 call.il p, 0x123456            ; 5B F4 56 34 12
 call.il p, 32767               ; 5B F4 FF 7F 00
 call.il p, 65535               ; 5B F4 FF FF 00
 call.il pe, -32768             ; 5B EC 00 80 FF
 call.il pe, 0x123456           ; 5B EC 56 34 12
 call.il pe, 32767              ; 5B EC FF 7F 00
 call.il pe, 65535              ; 5B EC FF FF 00
 call.il po, -32768             ; 5B E4 00 80 FF
 call.il po, 0x123456           ; 5B E4 56 34 12
 call.il po, 32767              ; 5B E4 FF 7F 00
 call.il po, 65535              ; 5B E4 FF FF 00
 call.il v, -32768              ; 5B EC 00 80 FF
 call.il v, 0x123456            ; 5B EC 56 34 12
 call.il v, 32767               ; 5B EC FF 7F 00
 call.il v, 65535               ; 5B EC FF FF 00
 call.il z, -32768              ; 5B CC 00 80 FF
 call.il z, 0x123456            ; 5B CC 56 34 12
 call.il z, 32767               ; 5B CC FF 7F 00
 call.il z, 65535               ; 5B CC FF FF 00
 call.is -32768                 ; 49 CD 00 80
 call.is 0x123456               ; 49 CD 56 34
 call.is 32767                  ; 49 CD FF 7F
 call.is 65535                  ; 49 CD FF FF
 call.is c, -32768              ; 49 DC 00 80
 call.is c, 0x123456            ; 49 DC 56 34
 call.is c, 32767               ; 49 DC FF 7F
 call.is c, 65535               ; 49 DC FF FF
 call.is m, -32768              ; 49 FC 00 80
 call.is m, 0x123456            ; 49 FC 56 34
 call.is m, 32767               ; 49 FC FF 7F
 call.is m, 65535               ; 49 FC FF FF
 call.is nc, -32768             ; 49 D4 00 80
 call.is nc, 0x123456           ; 49 D4 56 34
 call.is nc, 32767              ; 49 D4 FF 7F
 call.is nc, 65535              ; 49 D4 FF FF
 call.is nv, -32768             ; 49 E4 00 80
 call.is nv, 0x123456           ; 49 E4 56 34
 call.is nv, 32767              ; 49 E4 FF 7F
 call.is nv, 65535              ; 49 E4 FF FF
 call.is nz, -32768             ; 49 C4 00 80
 call.is nz, 0x123456           ; 49 C4 56 34
 call.is nz, 32767              ; 49 C4 FF 7F
 call.is nz, 65535              ; 49 C4 FF FF
 call.is p, -32768              ; 49 F4 00 80
 call.is p, 0x123456            ; 49 F4 56 34
 call.is p, 32767               ; 49 F4 FF 7F
 call.is p, 65535               ; 49 F4 FF FF
 call.is pe, -32768             ; 49 EC 00 80
 call.is pe, 0x123456           ; 49 EC 56 34
 call.is pe, 32767              ; 49 EC FF 7F
 call.is pe, 65535              ; 49 EC FF FF
 call.is po, -32768             ; 49 E4 00 80
 call.is po, 0x123456           ; 49 E4 56 34
 call.is po, 32767              ; 49 E4 FF 7F
 call.is po, 65535              ; 49 E4 FF FF
 call.is v, -32768              ; 49 EC 00 80
 call.is v, 0x123456            ; 49 EC 56 34
 call.is v, 32767               ; 49 EC FF 7F
 call.is v, 65535               ; 49 EC FF FF
 call.is z, -32768              ; 49 CC 00 80
 call.is z, 0x123456            ; 49 CC 56 34
 call.is z, 32767               ; 49 CC FF 7F
 call.is z, 65535               ; 49 CC FF FF
 call.lil -32768                ; 5B CD 00 80 FF
 call.lil 0x123456              ; 5B CD 56 34 12
 call.lil 32767                 ; 5B CD FF 7F 00
 call.lil 65535                 ; 5B CD FF FF 00
 call.lil c, -32768             ; 5B DC 00 80 FF
 call.lil c, 0x123456           ; 5B DC 56 34 12
 call.lil c, 32767              ; 5B DC FF 7F 00
 call.lil c, 65535              ; 5B DC FF FF 00
 call.lil m, -32768             ; 5B FC 00 80 FF
 call.lil m, 0x123456           ; 5B FC 56 34 12
 call.lil m, 32767              ; 5B FC FF 7F 00
 call.lil m, 65535              ; 5B FC FF FF 00
 call.lil nc, -32768            ; 5B D4 00 80 FF
 call.lil nc, 0x123456          ; 5B D4 56 34 12
 call.lil nc, 32767             ; 5B D4 FF 7F 00
 call.lil nc, 65535             ; 5B D4 FF FF 00
 call.lil nv, -32768            ; 5B E4 00 80 FF
 call.lil nv, 0x123456          ; 5B E4 56 34 12
 call.lil nv, 32767             ; 5B E4 FF 7F 00
 call.lil nv, 65535             ; 5B E4 FF FF 00
 call.lil nz, -32768            ; 5B C4 00 80 FF
 call.lil nz, 0x123456          ; 5B C4 56 34 12
 call.lil nz, 32767             ; 5B C4 FF 7F 00
 call.lil nz, 65535             ; 5B C4 FF FF 00
 call.lil p, -32768             ; 5B F4 00 80 FF
 call.lil p, 0x123456           ; 5B F4 56 34 12
 call.lil p, 32767              ; 5B F4 FF 7F 00
 call.lil p, 65535              ; 5B F4 FF FF 00
 call.lil pe, -32768            ; 5B EC 00 80 FF
 call.lil pe, 0x123456          ; 5B EC 56 34 12
 call.lil pe, 32767             ; 5B EC FF 7F 00
 call.lil pe, 65535             ; 5B EC FF FF 00
 call.lil po, -32768            ; 5B E4 00 80 FF
 call.lil po, 0x123456          ; 5B E4 56 34 12
 call.lil po, 32767             ; 5B E4 FF 7F 00
 call.lil po, 65535             ; 5B E4 FF FF 00
 call.lil v, -32768             ; 5B EC 00 80 FF
 call.lil v, 0x123456           ; 5B EC 56 34 12
 call.lil v, 32767              ; 5B EC FF 7F 00
 call.lil v, 65535              ; 5B EC FF FF 00
 call.lil z, -32768             ; 5B CC 00 80 FF
 call.lil z, 0x123456           ; 5B CC 56 34 12
 call.lil z, 32767              ; 5B CC FF 7F 00
 call.lil z, 65535              ; 5B CC FF FF 00
 call.lis -32768                ; 49 CD 00 80
 call.lis 0x123456              ; 49 CD 56 34
 call.lis 32767                 ; 49 CD FF 7F
 call.lis 65535                 ; 49 CD FF FF
 call.lis c, -32768             ; 49 DC 00 80
 call.lis c, 0x123456           ; 49 DC 56 34
 call.lis c, 32767              ; 49 DC FF 7F
 call.lis c, 65535              ; 49 DC FF FF
 call.lis m, -32768             ; 49 FC 00 80
 call.lis m, 0x123456           ; 49 FC 56 34
 call.lis m, 32767              ; 49 FC FF 7F
 call.lis m, 65535              ; 49 FC FF FF
 call.lis nc, -32768            ; 49 D4 00 80
 call.lis nc, 0x123456          ; 49 D4 56 34
 call.lis nc, 32767             ; 49 D4 FF 7F
 call.lis nc, 65535             ; 49 D4 FF FF
 call.lis nv, -32768            ; 49 E4 00 80
 call.lis nv, 0x123456          ; 49 E4 56 34
 call.lis nv, 32767             ; 49 E4 FF 7F
 call.lis nv, 65535             ; 49 E4 FF FF
 call.lis nz, -32768            ; 49 C4 00 80
 call.lis nz, 0x123456          ; 49 C4 56 34
 call.lis nz, 32767             ; 49 C4 FF 7F
 call.lis nz, 65535             ; 49 C4 FF FF
 call.lis p, -32768             ; 49 F4 00 80
 call.lis p, 0x123456           ; 49 F4 56 34
 call.lis p, 32767              ; 49 F4 FF 7F
 call.lis p, 65535              ; 49 F4 FF FF
 call.lis pe, -32768            ; 49 EC 00 80
 call.lis pe, 0x123456          ; 49 EC 56 34
 call.lis pe, 32767             ; 49 EC FF 7F
 call.lis pe, 65535             ; 49 EC FF FF
 call.lis po, -32768            ; 49 E4 00 80
 call.lis po, 0x123456          ; 49 E4 56 34
 call.lis po, 32767             ; 49 E4 FF 7F
 call.lis po, 65535             ; 49 E4 FF FF
 call.lis v, -32768             ; 49 EC 00 80
 call.lis v, 0x123456           ; 49 EC 56 34
 call.lis v, 32767              ; 49 EC FF 7F
 call.lis v, 65535              ; 49 EC FF FF
 call.lis z, -32768             ; 49 CC 00 80
 call.lis z, 0x123456           ; 49 CC 56 34
 call.lis z, 32767              ; 49 CC FF 7F
 call.lis z, 65535              ; 49 CC FF FF
 cc -32768                      ; DC 00 80 FF
 cc 0x123456                    ; DC 56 34 12
 cc 32767                       ; DC FF 7F 00
 cc 65535                       ; DC FF FF 00
 ccf                            ; 3F
 cm -32768                      ; FC 00 80 FF
 cm 0x123456                    ; FC 56 34 12
 cm 32767                       ; FC FF 7F 00
 cm 65535                       ; FC FF FF 00
 cma                            ; 2F
 cmc                            ; 3F
 cmp (hl)                       ; BE
 cmp (hl+)                      ; BE 23
 cmp (hl-)                      ; BE 2B
 cmp (ix)                       ; DD BE 00
 cmp (ix+126)                   ; DD BE 7E
 cmp (ix-128)                   ; DD BE 80
 cmp (iy)                       ; FD BE 00
 cmp (iy+126)                   ; FD BE 7E
 cmp (iy-128)                   ; FD BE 80
 cmp -128                       ; FE 80
 cmp 127                        ; FE 7F
 cmp 255                        ; FE FF
 cmp a                          ; BF
 cmp a, (hl)                    ; BE
 cmp a, (hl+)                   ; BE 23
 cmp a, (hl-)                   ; BE 2B
 cmp a, (ix)                    ; DD BE 00
 cmp a, (ix+126)                ; DD BE 7E
 cmp a, (ix-128)                ; DD BE 80
 cmp a, (iy)                    ; FD BE 00
 cmp a, (iy+126)                ; FD BE 7E
 cmp a, (iy-128)                ; FD BE 80
 cmp a, -128                    ; FE 80
 cmp a, 127                     ; FE 7F
 cmp a, 255                     ; FE FF
 cmp a, a                       ; BF
 cmp a, b                       ; B8
 cmp a, c                       ; B9
 cmp a, d                       ; BA
 cmp a, e                       ; BB
 cmp a, h                       ; BC
 cmp a, ixh                     ; DD BC
 cmp a, ixl                     ; DD BD
 cmp a, iyh                     ; FD BC
 cmp a, iyl                     ; FD BD
 cmp a, l                       ; BD
 cmp b                          ; B8
 cmp c                          ; B9
 cmp d                          ; BA
 cmp e                          ; BB
 cmp h                          ; BC
 cmp ixh                        ; DD BC
 cmp ixl                        ; DD BD
 cmp iyh                        ; FD BC
 cmp iyl                        ; FD BD
 cmp l                          ; BD
 cmp m                          ; BE
 cmp.s (hl)                     ; 52 BE
 cmp.s (hl+)                    ; 52 BE 23
 cmp.s (hl-)                    ; 52 BE 2B
 cmp.s (ix)                     ; 52 DD BE 00
 cmp.s (ix+126)                 ; 52 DD BE 7E
 cmp.s (ix-128)                 ; 52 DD BE 80
 cmp.s (iy)                     ; 52 FD BE 00
 cmp.s (iy+126)                 ; 52 FD BE 7E
 cmp.s (iy-128)                 ; 52 FD BE 80
 cmp.s a, (hl)                  ; 52 BE
 cmp.s a, (hl+)                 ; 52 BE 23
 cmp.s a, (hl-)                 ; 52 BE 2B
 cmp.s a, (ix)                  ; 52 DD BE 00
 cmp.s a, (ix+126)              ; 52 DD BE 7E
 cmp.s a, (ix-128)              ; 52 DD BE 80
 cmp.s a, (iy)                  ; 52 FD BE 00
 cmp.s a, (iy+126)              ; 52 FD BE 7E
 cmp.s a, (iy-128)              ; 52 FD BE 80
 cmp.sil (hl)                   ; 52 BE
 cmp.sil (hl+)                  ; 52 BE 23
 cmp.sil (hl-)                  ; 52 BE 2B
 cmp.sil (ix)                   ; 52 DD BE 00
 cmp.sil (ix+126)               ; 52 DD BE 7E
 cmp.sil (ix-128)               ; 52 DD BE 80
 cmp.sil (iy)                   ; 52 FD BE 00
 cmp.sil (iy+126)               ; 52 FD BE 7E
 cmp.sil (iy-128)               ; 52 FD BE 80
 cmp.sil a, (hl)                ; 52 BE
 cmp.sil a, (hl+)               ; 52 BE 23
 cmp.sil a, (hl-)               ; 52 BE 2B
 cmp.sil a, (ix)                ; 52 DD BE 00
 cmp.sil a, (ix+126)            ; 52 DD BE 7E
 cmp.sil a, (ix-128)            ; 52 DD BE 80
 cmp.sil a, (iy)                ; 52 FD BE 00
 cmp.sil a, (iy+126)            ; 52 FD BE 7E
 cmp.sil a, (iy-128)            ; 52 FD BE 80
 cnc -32768                     ; D4 00 80 FF
 cnc 0x123456                   ; D4 56 34 12
 cnc 32767                      ; D4 FF 7F 00
 cnc 65535                      ; D4 FF FF 00
 cnv -32768                     ; E4 00 80 FF
 cnv 0x123456                   ; E4 56 34 12
 cnv 32767                      ; E4 FF 7F 00
 cnv 65535                      ; E4 FF FF 00
 cnz -32768                     ; C4 00 80 FF
 cnz 0x123456                   ; C4 56 34 12
 cnz 32767                      ; C4 FF 7F 00
 cnz 65535                      ; C4 FF FF 00
 cp (hl)                        ; BE
 cp (hl+)                       ; BE 23
 cp (hl-)                       ; BE 2B
 cp (ix)                        ; DD BE 00
 cp (ix+126)                    ; DD BE 7E
 cp (ix-128)                    ; DD BE 80
 cp (iy)                        ; FD BE 00
 cp (iy+126)                    ; FD BE 7E
 cp (iy-128)                    ; FD BE 80
 cp -128                        ; FE 80
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; BF
 cp a, (hl)                     ; BE
 cp a, (hl+)                    ; BE 23
 cp a, (hl-)                    ; BE 2B
 cp a, (ix)                     ; DD BE 00
 cp a, (ix+126)                 ; DD BE 7E
 cp a, (ix-128)                 ; DD BE 80
 cp a, (iy)                     ; FD BE 00
 cp a, (iy+126)                 ; FD BE 7E
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
 cp.s (hl)                      ; 52 BE
 cp.s (hl+)                     ; 52 BE 23
 cp.s (hl-)                     ; 52 BE 2B
 cp.s (ix)                      ; 52 DD BE 00
 cp.s (ix+126)                  ; 52 DD BE 7E
 cp.s (ix-128)                  ; 52 DD BE 80
 cp.s (iy)                      ; 52 FD BE 00
 cp.s (iy+126)                  ; 52 FD BE 7E
 cp.s (iy-128)                  ; 52 FD BE 80
 cp.s a, (hl)                   ; 52 BE
 cp.s a, (hl+)                  ; 52 BE 23
 cp.s a, (hl-)                  ; 52 BE 2B
 cp.s a, (ix)                   ; 52 DD BE 00
 cp.s a, (ix+126)               ; 52 DD BE 7E
 cp.s a, (ix-128)               ; 52 DD BE 80
 cp.s a, (iy)                   ; 52 FD BE 00
 cp.s a, (iy+126)               ; 52 FD BE 7E
 cp.s a, (iy-128)               ; 52 FD BE 80
 cp.sil (hl)                    ; 52 BE
 cp.sil (hl+)                   ; 52 BE 23
 cp.sil (hl-)                   ; 52 BE 2B
 cp.sil (ix)                    ; 52 DD BE 00
 cp.sil (ix+126)                ; 52 DD BE 7E
 cp.sil (ix-128)                ; 52 DD BE 80
 cp.sil (iy)                    ; 52 FD BE 00
 cp.sil (iy+126)                ; 52 FD BE 7E
 cp.sil (iy-128)                ; 52 FD BE 80
 cp.sil a, (hl)                 ; 52 BE
 cp.sil a, (hl+)                ; 52 BE 23
 cp.sil a, (hl-)                ; 52 BE 2B
 cp.sil a, (ix)                 ; 52 DD BE 00
 cp.sil a, (ix+126)             ; 52 DD BE 7E
 cp.sil a, (ix-128)             ; 52 DD BE 80
 cp.sil a, (iy)                 ; 52 FD BE 00
 cp.sil a, (iy+126)             ; 52 FD BE 7E
 cp.sil a, (iy-128)             ; 52 FD BE 80
 cpd                            ; ED A9
 cpd.s                          ; 52 ED A9
 cpd.sil                        ; 52 ED A9
 cpdr                           ; ED B9
 cpdr.s                         ; 52 ED B9
 cpdr.sil                       ; 52 ED B9
 cpe -32768                     ; EC 00 80 FF
 cpe 0x123456                   ; EC 56 34 12
 cpe 32767                      ; EC FF 7F 00
 cpe 65535                      ; EC FF FF 00
 cpi                            ; ED A1
 cpi -128                       ; FE 80
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpi.s                          ; 52 ED A1
 cpi.sil                        ; 52 ED A1
 cpir                           ; ED B1
 cpir.s                         ; 52 ED B1
 cpir.sil                       ; 52 ED B1
 cpl                            ; 2F
 cpl a                          ; 2F
 cpo -32768                     ; E4 00 80 FF
 cpo 0x123456                   ; E4 56 34 12
 cpo 32767                      ; E4 FF 7F 00
 cpo 65535                      ; E4 FF FF 00
 cv -32768                      ; EC 00 80 FF
 cv 0x123456                    ; EC 56 34 12
 cv 32767                       ; EC FF 7F 00
 cv 65535                       ; EC FF FF 00
 cz -32768                      ; CC 00 80 FF
 cz 0x123456                    ; CC 56 34 12
 cz 32767                       ; CC FF 7F 00
 cz 65535                       ; CC FF FF 00
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
 dec (hl+)                      ; 35 23
 dec (hl-)                      ; 35 2B
 dec (ix)                       ; DD 35 00
 dec (ix+126)                   ; DD 35 7E
 dec (ix-128)                   ; DD 35 80
 dec (iy)                       ; FD 35 00
 dec (iy+126)                   ; FD 35 7E
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
 dec.s (hl)                     ; 52 35
 dec.s (hl+)                    ; 52 35 23
 dec.s (hl-)                    ; 52 35 2B
 dec.s (ix)                     ; 52 DD 35 00
 dec.s (ix+126)                 ; 52 DD 35 7E
 dec.s (ix-128)                 ; 52 DD 35 80
 dec.s (iy)                     ; 52 FD 35 00
 dec.s (iy+126)                 ; 52 FD 35 7E
 dec.s (iy-128)                 ; 52 FD 35 80
 dec.s bc                       ; 52 0B
 dec.s de                       ; 52 1B
 dec.s hl                       ; 52 2B
 dec.s ix                       ; 52 DD 2B
 dec.s iy                       ; 52 FD 2B
 dec.s sp                       ; 52 3B
 dec.sil (hl)                   ; 52 35
 dec.sil (hl+)                  ; 52 35 23
 dec.sil (hl-)                  ; 52 35 2B
 dec.sil (ix)                   ; 52 DD 35 00
 dec.sil (ix+126)               ; 52 DD 35 7E
 dec.sil (ix-128)               ; 52 DD 35 80
 dec.sil (iy)                   ; 52 FD 35 00
 dec.sil (iy+126)               ; 52 FD 35 7E
 dec.sil (iy-128)               ; 52 FD 35 80
 dec.sil bc                     ; 52 0B
 dec.sil de                     ; 52 1B
 dec.sil hl                     ; 52 2B
 dec.sil ix                     ; 52 DD 2B
 dec.sil iy                     ; 52 FD 2B
 dec.sil sp                     ; 52 3B
 di                             ; F3
 djnz ASMPC                     ; 10 FE
 djnz b, ASMPC                  ; 10 FE
 dsub                           ; CD @__z80asm__sub_hl_bc
 ei                             ; FB
 ex (sp), hl                    ; E3
 ex (sp), ix                    ; DD E3
 ex (sp), iy                    ; FD E3
 ex af, af                      ; 08
 ex af, af'                     ; 08
 ex de, hl                      ; EB
 ex.s (sp), hl                  ; 52 E3
 ex.s (sp), ix                  ; 52 DD E3
 ex.s (sp), iy                  ; 52 FD E3
 ex.sil (sp), hl                ; 52 E3
 ex.sil (sp), ix                ; 52 DD E3
 ex.sil (sp), iy                ; 52 FD E3
 exx                            ; D9
 halt                           ; 76
 hlt                            ; 76
 im 0                           ; ED 46
 im 1                           ; ED 56
 im 2                           ; ED 5E
 in (bc)                        ; ED 70
 in (c)                         ; ED 70
 in -128                        ; DB 80
 in 127                         ; DB 7F
 in 255                         ; DB FF
 in a, (-128)                   ; DB 80
 in a, (127)                    ; DB 7F
 in a, (255)                    ; DB FF
 in a, (bc)                     ; ED 78
 in a, (c)                      ; ED 78
 in b, (bc)                     ; ED 40
 in b, (c)                      ; ED 40
 in c, (bc)                     ; ED 48
 in c, (c)                      ; ED 48
 in d, (bc)                     ; ED 50
 in d, (c)                      ; ED 50
 in e, (bc)                     ; ED 58
 in e, (c)                      ; ED 58
 in h, (bc)                     ; ED 60
 in h, (c)                      ; ED 60
 in l, (bc)                     ; ED 68
 in l, (c)                      ; ED 68
 in0 a, (-128)                  ; ED 38 80
 in0 a, (127)                   ; ED 38 7F
 in0 a, (255)                   ; ED 38 FF
 in0 b, (-128)                  ; ED 00 80
 in0 b, (127)                   ; ED 00 7F
 in0 b, (255)                   ; ED 00 FF
 in0 c, (-128)                  ; ED 08 80
 in0 c, (127)                   ; ED 08 7F
 in0 c, (255)                   ; ED 08 FF
 in0 d, (-128)                  ; ED 10 80
 in0 d, (127)                   ; ED 10 7F
 in0 d, (255)                   ; ED 10 FF
 in0 e, (-128)                  ; ED 18 80
 in0 e, (127)                   ; ED 18 7F
 in0 e, (255)                   ; ED 18 FF
 in0 h, (-128)                  ; ED 20 80
 in0 h, (127)                   ; ED 20 7F
 in0 h, (255)                   ; ED 20 FF
 in0 l, (-128)                  ; ED 28 80
 in0 l, (127)                   ; ED 28 7F
 in0 l, (255)                   ; ED 28 FF
 inc (hl)                       ; 34
 inc (hl+)                      ; 34 23
 inc (hl-)                      ; 34 2B
 inc (ix)                       ; DD 34 00
 inc (ix+126)                   ; DD 34 7E
 inc (ix-128)                   ; DD 34 80
 inc (iy)                       ; FD 34 00
 inc (iy+126)                   ; FD 34 7E
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
 inc.s (hl)                     ; 52 34
 inc.s (hl+)                    ; 52 34 23
 inc.s (hl-)                    ; 52 34 2B
 inc.s (ix)                     ; 52 DD 34 00
 inc.s (ix+126)                 ; 52 DD 34 7E
 inc.s (ix-128)                 ; 52 DD 34 80
 inc.s (iy)                     ; 52 FD 34 00
 inc.s (iy+126)                 ; 52 FD 34 7E
 inc.s (iy-128)                 ; 52 FD 34 80
 inc.s bc                       ; 52 03
 inc.s de                       ; 52 13
 inc.s hl                       ; 52 23
 inc.s ix                       ; 52 DD 23
 inc.s iy                       ; 52 FD 23
 inc.s sp                       ; 52 33
 inc.sil (hl)                   ; 52 34
 inc.sil (hl+)                  ; 52 34 23
 inc.sil (hl-)                  ; 52 34 2B
 inc.sil (ix)                   ; 52 DD 34 00
 inc.sil (ix+126)               ; 52 DD 34 7E
 inc.sil (ix-128)               ; 52 DD 34 80
 inc.sil (iy)                   ; 52 FD 34 00
 inc.sil (iy+126)               ; 52 FD 34 7E
 inc.sil (iy-128)               ; 52 FD 34 80
 inc.sil bc                     ; 52 03
 inc.sil de                     ; 52 13
 inc.sil hl                     ; 52 23
 inc.sil ix                     ; 52 DD 23
 inc.sil iy                     ; 52 FD 23
 inc.sil sp                     ; 52 33
 ind                            ; ED AA
 ind.s                          ; 52 ED AA
 ind.sil                        ; 52 ED AA
 ind2                           ; ED 8C
 ind2.s                         ; 52 ED 8C
 ind2.sil                       ; 52 ED 8C
 ind2r                          ; ED 9C
 ind2r.s                        ; 52 ED 9C
 ind2r.sil                      ; 52 ED 9C
 indm                           ; ED 8A
 indm.s                         ; 52 ED 8A
 indm.sil                       ; 52 ED 8A
 indmr                          ; ED 9A
 indmr.s                        ; 52 ED 9A
 indmr.sil                      ; 52 ED 9A
 indr                           ; ED BA
 indr.s                         ; 52 ED BA
 indr.sil                       ; 52 ED BA
 indrx                          ; ED CA
 indrx.s                        ; 52 ED CA
 indrx.sil                      ; 52 ED CA
 ini                            ; ED A2
 ini.s                          ; 52 ED A2
 ini.sil                        ; 52 ED A2
 ini2                           ; ED 84
 ini2.s                         ; 52 ED 84
 ini2.sil                       ; 52 ED 84
 ini2r                          ; ED 94
 ini2r.s                        ; 52 ED 94
 ini2r.sil                      ; 52 ED 94
 inim                           ; ED 82
 inim.s                         ; 52 ED 82
 inim.sil                       ; 52 ED 82
 inimr                          ; ED 92
 inimr.s                        ; 52 ED 92
 inimr.sil                      ; 52 ED 92
 inir                           ; ED B2
 inir.s                         ; 52 ED B2
 inir.sil                       ; 52 ED B2
 inirx                          ; ED C2
 inirx.s                        ; 52 ED C2
 inirx.sil                      ; 52 ED C2
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
 j_c -32768                     ; DA 00 80
 j_c 0x123456                   ; DA 56 34
 j_c 32767                      ; DA FF 7F
 j_c 65535                      ; DA FF FF
 j_m -32768                     ; FA 00 80
 j_m 0x123456                   ; FA 56 34
 j_m 32767                      ; FA FF 7F
 j_m 65535                      ; FA FF FF
 j_nc -32768                    ; D2 00 80
 j_nc 0x123456                  ; D2 56 34
 j_nc 32767                     ; D2 FF 7F
 j_nc 65535                     ; D2 FF FF
 j_nv -32768                    ; E2 00 80
 j_nv 0x123456                  ; E2 56 34
 j_nv 32767                     ; E2 FF 7F
 j_nv 65535                     ; E2 FF FF
 j_nz -32768                    ; C2 00 80
 j_nz 0x123456                  ; C2 56 34
 j_nz 32767                     ; C2 FF 7F
 j_nz 65535                     ; C2 FF FF
 j_p -32768                     ; F2 00 80
 j_p 0x123456                   ; F2 56 34
 j_p 32767                      ; F2 FF 7F
 j_p 65535                      ; F2 FF FF
 j_pe -32768                    ; EA 00 80
 j_pe 0x123456                  ; EA 56 34
 j_pe 32767                     ; EA FF 7F
 j_pe 65535                     ; EA FF FF
 j_po -32768                    ; E2 00 80
 j_po 0x123456                  ; E2 56 34
 j_po 32767                     ; E2 FF 7F
 j_po 65535                     ; E2 FF FF
 j_v -32768                     ; EA 00 80
 j_v 0x123456                   ; EA 56 34
 j_v 32767                      ; EA FF 7F
 j_v 65535                      ; EA FF FF
 j_z -32768                     ; CA 00 80
 j_z 0x123456                   ; CA 56 34
 j_z 32767                      ; CA FF 7F
 j_z 65535                      ; CA FF FF
 jc -32768                      ; DA 00 80
 jc 0x123456                    ; DA 56 34
 jc 32767                       ; DA FF 7F
 jc 65535                       ; DA FF FF
 jm -32768                      ; FA 00 80
 jm 0x123456                    ; FA 56 34
 jm 32767                       ; FA FF 7F
 jm 65535                       ; FA FF FF
 jmp (bc)                       ; C5 C9
 jmp (de)                       ; D5 C9
 jmp (hl)                       ; E9
 jmp (ix)                       ; DD E9
 jmp (iy)                       ; FD E9
 jmp -32768                     ; C3 00 80 FF
 jmp 0x123456                   ; C3 56 34 12
 jmp 32767                      ; C3 FF 7F 00
 jmp 65535                      ; C3 FF FF 00
 jmp c, -32768                  ; DA 00 80 FF
 jmp c, 0x123456                ; DA 56 34 12
 jmp c, 32767                   ; DA FF 7F 00
 jmp c, 65535                   ; DA FF FF 00
 jmp m, -32768                  ; FA 00 80 FF
 jmp m, 0x123456                ; FA 56 34 12
 jmp m, 32767                   ; FA FF 7F 00
 jmp m, 65535                   ; FA FF FF 00
 jmp nc, -32768                 ; D2 00 80 FF
 jmp nc, 0x123456               ; D2 56 34 12
 jmp nc, 32767                  ; D2 FF 7F 00
 jmp nc, 65535                  ; D2 FF FF 00
 jmp nv, -32768                 ; E2 00 80 FF
 jmp nv, 0x123456               ; E2 56 34 12
 jmp nv, 32767                  ; E2 FF 7F 00
 jmp nv, 65535                  ; E2 FF FF 00
 jmp nz, -32768                 ; C2 00 80 FF
 jmp nz, 0x123456               ; C2 56 34 12
 jmp nz, 32767                  ; C2 FF 7F 00
 jmp nz, 65535                  ; C2 FF FF 00
 jmp p, -32768                  ; F2 00 80 FF
 jmp p, 0x123456                ; F2 56 34 12
 jmp p, 32767                   ; F2 FF 7F 00
 jmp p, 65535                   ; F2 FF FF 00
 jmp pe, -32768                 ; EA 00 80 FF
 jmp pe, 0x123456               ; EA 56 34 12
 jmp pe, 32767                  ; EA FF 7F 00
 jmp pe, 65535                  ; EA FF FF 00
 jmp po, -32768                 ; E2 00 80 FF
 jmp po, 0x123456               ; E2 56 34 12
 jmp po, 32767                  ; E2 FF 7F 00
 jmp po, 65535                  ; E2 FF FF 00
 jmp v, -32768                  ; EA 00 80 FF
 jmp v, 0x123456                ; EA 56 34 12
 jmp v, 32767                   ; EA FF 7F 00
 jmp v, 65535                   ; EA FF FF 00
 jmp z, -32768                  ; CA 00 80 FF
 jmp z, 0x123456                ; CA 56 34 12
 jmp z, 32767                   ; CA FF 7F 00
 jmp z, 65535                   ; CA FF FF 00
 jmp.lil -32768                 ; 5B C3 00 80 FF
 jmp.lil 0x123456               ; 5B C3 56 34 12
 jmp.lil 32767                  ; 5B C3 FF 7F 00
 jmp.lil 65535                  ; 5B C3 FF FF 00
 jmp.lil c, -32768              ; 5B DA 00 80 FF
 jmp.lil c, 0x123456            ; 5B DA 56 34 12
 jmp.lil c, 32767               ; 5B DA FF 7F 00
 jmp.lil c, 65535               ; 5B DA FF FF 00
 jmp.lil m, -32768              ; 5B FA 00 80 FF
 jmp.lil m, 0x123456            ; 5B FA 56 34 12
 jmp.lil m, 32767               ; 5B FA FF 7F 00
 jmp.lil m, 65535               ; 5B FA FF FF 00
 jmp.lil nc, -32768             ; 5B D2 00 80 FF
 jmp.lil nc, 0x123456           ; 5B D2 56 34 12
 jmp.lil nc, 32767              ; 5B D2 FF 7F 00
 jmp.lil nc, 65535              ; 5B D2 FF FF 00
 jmp.lil nv, -32768             ; 5B E2 00 80 FF
 jmp.lil nv, 0x123456           ; 5B E2 56 34 12
 jmp.lil nv, 32767              ; 5B E2 FF 7F 00
 jmp.lil nv, 65535              ; 5B E2 FF FF 00
 jmp.lil nz, -32768             ; 5B C2 00 80 FF
 jmp.lil nz, 0x123456           ; 5B C2 56 34 12
 jmp.lil nz, 32767              ; 5B C2 FF 7F 00
 jmp.lil nz, 65535              ; 5B C2 FF FF 00
 jmp.lil p, -32768              ; 5B F2 00 80 FF
 jmp.lil p, 0x123456            ; 5B F2 56 34 12
 jmp.lil p, 32767               ; 5B F2 FF 7F 00
 jmp.lil p, 65535               ; 5B F2 FF FF 00
 jmp.lil pe, -32768             ; 5B EA 00 80 FF
 jmp.lil pe, 0x123456           ; 5B EA 56 34 12
 jmp.lil pe, 32767              ; 5B EA FF 7F 00
 jmp.lil pe, 65535              ; 5B EA FF FF 00
 jmp.lil po, -32768             ; 5B E2 00 80 FF
 jmp.lil po, 0x123456           ; 5B E2 56 34 12
 jmp.lil po, 32767              ; 5B E2 FF 7F 00
 jmp.lil po, 65535              ; 5B E2 FF FF 00
 jmp.lil v, -32768              ; 5B EA 00 80 FF
 jmp.lil v, 0x123456            ; 5B EA 56 34 12
 jmp.lil v, 32767               ; 5B EA FF 7F 00
 jmp.lil v, 65535               ; 5B EA FF FF 00
 jmp.lil z, -32768              ; 5B CA 00 80 FF
 jmp.lil z, 0x123456            ; 5B CA 56 34 12
 jmp.lil z, 32767               ; 5B CA FF 7F 00
 jmp.lil z, 65535               ; 5B CA FF FF 00
 jmp.s (hl)                     ; 52 E9
 jmp.s (ix)                     ; 52 DD E9
 jmp.s (iy)                     ; 52 FD E9
 jmp.sil (hl)                   ; 52 E9
 jmp.sil (ix)                   ; 52 DD E9
 jmp.sil (iy)                   ; 52 FD E9
 jmp.sis -32768                 ; 40 C3 00 80
 jmp.sis 0x123456               ; 40 C3 56 34
 jmp.sis 32767                  ; 40 C3 FF 7F
 jmp.sis 65535                  ; 40 C3 FF FF
 jmp.sis c, -32768              ; 40 DA 00 80
 jmp.sis c, 0x123456            ; 40 DA 56 34
 jmp.sis c, 32767               ; 40 DA FF 7F
 jmp.sis c, 65535               ; 40 DA FF FF
 jmp.sis m, -32768              ; 40 FA 00 80
 jmp.sis m, 0x123456            ; 40 FA 56 34
 jmp.sis m, 32767               ; 40 FA FF 7F
 jmp.sis m, 65535               ; 40 FA FF FF
 jmp.sis nc, -32768             ; 40 D2 00 80
 jmp.sis nc, 0x123456           ; 40 D2 56 34
 jmp.sis nc, 32767              ; 40 D2 FF 7F
 jmp.sis nc, 65535              ; 40 D2 FF FF
 jmp.sis nv, -32768             ; 40 E2 00 80
 jmp.sis nv, 0x123456           ; 40 E2 56 34
 jmp.sis nv, 32767              ; 40 E2 FF 7F
 jmp.sis nv, 65535              ; 40 E2 FF FF
 jmp.sis nz, -32768             ; 40 C2 00 80
 jmp.sis nz, 0x123456           ; 40 C2 56 34
 jmp.sis nz, 32767              ; 40 C2 FF 7F
 jmp.sis nz, 65535              ; 40 C2 FF FF
 jmp.sis p, -32768              ; 40 F2 00 80
 jmp.sis p, 0x123456            ; 40 F2 56 34
 jmp.sis p, 32767               ; 40 F2 FF 7F
 jmp.sis p, 65535               ; 40 F2 FF FF
 jmp.sis pe, -32768             ; 40 EA 00 80
 jmp.sis pe, 0x123456           ; 40 EA 56 34
 jmp.sis pe, 32767              ; 40 EA FF 7F
 jmp.sis pe, 65535              ; 40 EA FF FF
 jmp.sis po, -32768             ; 40 E2 00 80
 jmp.sis po, 0x123456           ; 40 E2 56 34
 jmp.sis po, 32767              ; 40 E2 FF 7F
 jmp.sis po, 65535              ; 40 E2 FF FF
 jmp.sis v, -32768              ; 40 EA 00 80
 jmp.sis v, 0x123456            ; 40 EA 56 34
 jmp.sis v, 32767               ; 40 EA FF 7F
 jmp.sis v, 65535               ; 40 EA FF FF
 jmp.sis z, -32768              ; 40 CA 00 80
 jmp.sis z, 0x123456            ; 40 CA 56 34
 jmp.sis z, 32767               ; 40 CA FF 7F
 jmp.sis z, 65535               ; 40 CA FF FF
 jnc -32768                     ; D2 00 80
 jnc 0x123456                   ; D2 56 34
 jnc 32767                      ; D2 FF 7F
 jnc 65535                      ; D2 FF FF
 jnv -32768                     ; E2 00 80
 jnv 0x123456                   ; E2 56 34
 jnv 32767                      ; E2 FF 7F
 jnv 65535                      ; E2 FF FF
 jnz -32768                     ; C2 00 80
 jnz 0x123456                   ; C2 56 34
 jnz 32767                      ; C2 FF 7F
 jnz 65535                      ; C2 FF FF
 jp (bc)                        ; C5 C9
 jp (de)                        ; D5 C9
 jp (hl)                        ; E9
 jp (ix)                        ; DD E9
 jp (iy)                        ; FD E9
 jp -32768                      ; C3 00 80 FF
 jp 0x123456                    ; C3 56 34 12
 jp 32767                       ; C3 FF 7F 00
 jp 65535                       ; C3 FF FF 00
 jp c, -32768                   ; DA 00 80 FF
 jp c, 0x123456                 ; DA 56 34 12
 jp c, 32767                    ; DA FF 7F 00
 jp c, 65535                    ; DA FF FF 00
 jp m, -32768                   ; FA 00 80 FF
 jp m, 0x123456                 ; FA 56 34 12
 jp m, 32767                    ; FA FF 7F 00
 jp m, 65535                    ; FA FF FF 00
 jp nc, -32768                  ; D2 00 80 FF
 jp nc, 0x123456                ; D2 56 34 12
 jp nc, 32767                   ; D2 FF 7F 00
 jp nc, 65535                   ; D2 FF FF 00
 jp nv, -32768                  ; E2 00 80 FF
 jp nv, 0x123456                ; E2 56 34 12
 jp nv, 32767                   ; E2 FF 7F 00
 jp nv, 65535                   ; E2 FF FF 00
 jp nz, -32768                  ; C2 00 80 FF
 jp nz, 0x123456                ; C2 56 34 12
 jp nz, 32767                   ; C2 FF 7F 00
 jp nz, 65535                   ; C2 FF FF 00
 jp p, -32768                   ; F2 00 80 FF
 jp p, 0x123456                 ; F2 56 34 12
 jp p, 32767                    ; F2 FF 7F 00
 jp p, 65535                    ; F2 FF FF 00
 jp pe, -32768                  ; EA 00 80 FF
 jp pe, 0x123456                ; EA 56 34 12
 jp pe, 32767                   ; EA FF 7F 00
 jp pe, 65535                   ; EA FF FF 00
 jp po, -32768                  ; E2 00 80 FF
 jp po, 0x123456                ; E2 56 34 12
 jp po, 32767                   ; E2 FF 7F 00
 jp po, 65535                   ; E2 FF FF 00
 jp v, -32768                   ; EA 00 80 FF
 jp v, 0x123456                 ; EA 56 34 12
 jp v, 32767                    ; EA FF 7F 00
 jp v, 65535                    ; EA FF FF 00
 jp z, -32768                   ; CA 00 80 FF
 jp z, 0x123456                 ; CA 56 34 12
 jp z, 32767                    ; CA FF 7F 00
 jp z, 65535                    ; CA FF FF 00
 jp.lil -32768                  ; 5B C3 00 80 FF
 jp.lil 0x123456                ; 5B C3 56 34 12
 jp.lil 32767                   ; 5B C3 FF 7F 00
 jp.lil 65535                   ; 5B C3 FF FF 00
 jp.lil c, -32768               ; 5B DA 00 80 FF
 jp.lil c, 0x123456             ; 5B DA 56 34 12
 jp.lil c, 32767                ; 5B DA FF 7F 00
 jp.lil c, 65535                ; 5B DA FF FF 00
 jp.lil m, -32768               ; 5B FA 00 80 FF
 jp.lil m, 0x123456             ; 5B FA 56 34 12
 jp.lil m, 32767                ; 5B FA FF 7F 00
 jp.lil m, 65535                ; 5B FA FF FF 00
 jp.lil nc, -32768              ; 5B D2 00 80 FF
 jp.lil nc, 0x123456            ; 5B D2 56 34 12
 jp.lil nc, 32767               ; 5B D2 FF 7F 00
 jp.lil nc, 65535               ; 5B D2 FF FF 00
 jp.lil nv, -32768              ; 5B E2 00 80 FF
 jp.lil nv, 0x123456            ; 5B E2 56 34 12
 jp.lil nv, 32767               ; 5B E2 FF 7F 00
 jp.lil nv, 65535               ; 5B E2 FF FF 00
 jp.lil nz, -32768              ; 5B C2 00 80 FF
 jp.lil nz, 0x123456            ; 5B C2 56 34 12
 jp.lil nz, 32767               ; 5B C2 FF 7F 00
 jp.lil nz, 65535               ; 5B C2 FF FF 00
 jp.lil p, -32768               ; 5B F2 00 80 FF
 jp.lil p, 0x123456             ; 5B F2 56 34 12
 jp.lil p, 32767                ; 5B F2 FF 7F 00
 jp.lil p, 65535                ; 5B F2 FF FF 00
 jp.lil pe, -32768              ; 5B EA 00 80 FF
 jp.lil pe, 0x123456            ; 5B EA 56 34 12
 jp.lil pe, 32767               ; 5B EA FF 7F 00
 jp.lil pe, 65535               ; 5B EA FF FF 00
 jp.lil po, -32768              ; 5B E2 00 80 FF
 jp.lil po, 0x123456            ; 5B E2 56 34 12
 jp.lil po, 32767               ; 5B E2 FF 7F 00
 jp.lil po, 65535               ; 5B E2 FF FF 00
 jp.lil v, -32768               ; 5B EA 00 80 FF
 jp.lil v, 0x123456             ; 5B EA 56 34 12
 jp.lil v, 32767                ; 5B EA FF 7F 00
 jp.lil v, 65535                ; 5B EA FF FF 00
 jp.lil z, -32768               ; 5B CA 00 80 FF
 jp.lil z, 0x123456             ; 5B CA 56 34 12
 jp.lil z, 32767                ; 5B CA FF 7F 00
 jp.lil z, 65535                ; 5B CA FF FF 00
 jp.s (hl)                      ; 52 E9
 jp.s (ix)                      ; 52 DD E9
 jp.s (iy)                      ; 52 FD E9
 jp.sil (hl)                    ; 52 E9
 jp.sil (ix)                    ; 52 DD E9
 jp.sil (iy)                    ; 52 FD E9
 jp.sis -32768                  ; 40 C3 00 80
 jp.sis 0x123456                ; 40 C3 56 34
 jp.sis 32767                   ; 40 C3 FF 7F
 jp.sis 65535                   ; 40 C3 FF FF
 jp.sis c, -32768               ; 40 DA 00 80
 jp.sis c, 0x123456             ; 40 DA 56 34
 jp.sis c, 32767                ; 40 DA FF 7F
 jp.sis c, 65535                ; 40 DA FF FF
 jp.sis m, -32768               ; 40 FA 00 80
 jp.sis m, 0x123456             ; 40 FA 56 34
 jp.sis m, 32767                ; 40 FA FF 7F
 jp.sis m, 65535                ; 40 FA FF FF
 jp.sis nc, -32768              ; 40 D2 00 80
 jp.sis nc, 0x123456            ; 40 D2 56 34
 jp.sis nc, 32767               ; 40 D2 FF 7F
 jp.sis nc, 65535               ; 40 D2 FF FF
 jp.sis nv, -32768              ; 40 E2 00 80
 jp.sis nv, 0x123456            ; 40 E2 56 34
 jp.sis nv, 32767               ; 40 E2 FF 7F
 jp.sis nv, 65535               ; 40 E2 FF FF
 jp.sis nz, -32768              ; 40 C2 00 80
 jp.sis nz, 0x123456            ; 40 C2 56 34
 jp.sis nz, 32767               ; 40 C2 FF 7F
 jp.sis nz, 65535               ; 40 C2 FF FF
 jp.sis p, -32768               ; 40 F2 00 80
 jp.sis p, 0x123456             ; 40 F2 56 34
 jp.sis p, 32767                ; 40 F2 FF 7F
 jp.sis p, 65535                ; 40 F2 FF FF
 jp.sis pe, -32768              ; 40 EA 00 80
 jp.sis pe, 0x123456            ; 40 EA 56 34
 jp.sis pe, 32767               ; 40 EA FF 7F
 jp.sis pe, 65535               ; 40 EA FF FF
 jp.sis po, -32768              ; 40 E2 00 80
 jp.sis po, 0x123456            ; 40 E2 56 34
 jp.sis po, 32767               ; 40 E2 FF 7F
 jp.sis po, 65535               ; 40 E2 FF FF
 jp.sis v, -32768               ; 40 EA 00 80
 jp.sis v, 0x123456             ; 40 EA 56 34
 jp.sis v, 32767                ; 40 EA FF 7F
 jp.sis v, 65535                ; 40 EA FF FF
 jp.sis z, -32768               ; 40 CA 00 80
 jp.sis z, 0x123456             ; 40 CA 56 34
 jp.sis z, 32767                ; 40 CA FF 7F
 jp.sis z, 65535                ; 40 CA FF FF
 jpe -32768                     ; EA 00 80
 jpe 0x123456                   ; EA 56 34
 jpe 32767                      ; EA FF 7F
 jpe 65535                      ; EA FF FF
 jpo -32768                     ; E2 00 80
 jpo 0x123456                   ; E2 56 34
 jpo 32767                      ; E2 FF 7F
 jpo 65535                      ; E2 FF FF
 jr ASMPC                       ; 18 FE
 jr c, ASMPC                    ; 38 FE
 jr nc, ASMPC                   ; 30 FE
 jr nz, ASMPC                   ; 20 FE
 jr z, ASMPC                    ; 28 FE
 jv -32768                      ; EA 00 80
 jv 0x123456                    ; EA 56 34
 jv 32767                       ; EA FF 7F
 jv 65535                       ; EA FF FF
 jz -32768                      ; CA 00 80
 jz 0x123456                    ; CA 56 34
 jz 32767                       ; CA FF 7F
 jz 65535                       ; CA FF FF
 ld (-32768), a                 ; 32 00 80 FF
 ld (-32768), bc                ; ED 43 00 80 FF
 ld (-32768), de                ; ED 53 00 80 FF
 ld (-32768), hl                ; 22 00 80 FF
 ld (-32768), ix                ; DD 22 00 80 FF
 ld (-32768), iy                ; FD 22 00 80 FF
 ld (-32768), sp                ; ED 73 00 80 FF
 ld (0x123456), a               ; 32 56 34 12
 ld (0x123456), bc              ; ED 43 56 34 12
 ld (0x123456), de              ; ED 53 56 34 12
 ld (0x123456), hl              ; 22 56 34 12
 ld (0x123456), ix              ; DD 22 56 34 12
 ld (0x123456), iy              ; FD 22 56 34 12
 ld (0x123456), sp              ; ED 73 56 34 12
 ld (32767), a                  ; 32 FF 7F 00
 ld (32767), bc                 ; ED 43 FF 7F 00
 ld (32767), de                 ; ED 53 FF 7F 00
 ld (32767), hl                 ; 22 FF 7F 00
 ld (32767), ix                 ; DD 22 FF 7F 00
 ld (32767), iy                 ; FD 22 FF 7F 00
 ld (32767), sp                 ; ED 73 FF 7F 00
 ld (65535), a                  ; 32 FF FF 00
 ld (65535), bc                 ; ED 43 FF FF 00
 ld (65535), de                 ; ED 53 FF FF 00
 ld (65535), hl                 ; 22 FF FF 00
 ld (65535), ix                 ; DD 22 FF FF 00
 ld (65535), iy                 ; FD 22 FF FF 00
 ld (65535), sp                 ; ED 73 FF FF 00
 ld (bc), a                     ; 02
 ld (bc+), a                    ; 02 03
 ld (bc-), a                    ; 02 0B
 ld (de), -128                  ; EB 36 80 EB
 ld (de), 127                   ; EB 36 7F EB
 ld (de), 255                   ; EB 36 FF EB
 ld (de), a                     ; 12
 ld (de), b                     ; EB 70 EB
 ld (de), c                     ; EB 71 EB
 ld (de), d                     ; EB 74 EB
 ld (de), e                     ; EB 75 EB
 ld (de), h                     ; EB 72 EB
 ld (de), l                     ; EB 73 EB
 ld (de+), -128                 ; EB 36 80 EB 13
 ld (de+), 127                  ; EB 36 7F EB 13
 ld (de+), 255                  ; EB 36 FF EB 13
 ld (de+), a                    ; 12 13
 ld (de+), b                    ; EB 70 EB 13
 ld (de+), c                    ; EB 71 EB 13
 ld (de+), d                    ; EB 74 EB 13
 ld (de+), e                    ; EB 75 EB 13
 ld (de+), h                    ; EB 72 EB 13
 ld (de+), l                    ; EB 73 EB 13
 ld (de-), -128                 ; EB 36 80 EB 1B
 ld (de-), 127                  ; EB 36 7F EB 1B
 ld (de-), 255                  ; EB 36 FF EB 1B
 ld (de-), a                    ; 12 1B
 ld (de-), b                    ; EB 70 EB 1B
 ld (de-), c                    ; EB 71 EB 1B
 ld (de-), d                    ; EB 74 EB 1B
 ld (de-), e                    ; EB 75 EB 1B
 ld (de-), h                    ; EB 72 EB 1B
 ld (de-), l                    ; EB 73 EB 1B
 ld (hl), -128                  ; 36 80
 ld (hl), 127                   ; 36 7F
 ld (hl), 255                   ; 36 FF
 ld (hl), a                     ; 77
 ld (hl), b                     ; 70
 ld (hl), bc                    ; ED 0F
 ld (hl), c                     ; 71
 ld (hl), d                     ; 72
 ld (hl), de                    ; ED 1F
 ld (hl), e                     ; 73
 ld (hl), h                     ; 74
 ld (hl), hl                    ; ED 2F
 ld (hl), ix                    ; ED 3F
 ld (hl), iy                    ; ED 3E
 ld (hl), l                     ; 75
 ld (hl+), -128                 ; 36 80 23
 ld (hl+), 127                  ; 36 7F 23
 ld (hl+), 255                  ; 36 FF 23
 ld (hl+), a                    ; 77 23
 ld (hl+), b                    ; 70 23
 ld (hl+), bc                   ; ED 0F 23 23
 ld (hl+), c                    ; 71 23
 ld (hl+), d                    ; 72 23
 ld (hl+), de                   ; ED 1F 23 23
 ld (hl+), e                    ; 73 23
 ld (hl+), h                    ; 74 23
 ld (hl+), hl                   ; ED 2F 23 23
 ld (hl+), ix                   ; ED 3F 23 23
 ld (hl+), iy                   ; ED 3E 23 23
 ld (hl+), l                    ; 75 23
 ld (hl-), -128                 ; 36 80 2B
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
 ld (ix), -128                  ; DD 36 00 80
 ld (ix), 127                   ; DD 36 00 7F
 ld (ix), 255                   ; DD 36 00 FF
 ld (ix), a                     ; DD 77 00
 ld (ix), b                     ; DD 70 00
 ld (ix), bc                    ; DD 0F 00
 ld (ix), c                     ; DD 71 00
 ld (ix), d                     ; DD 72 00
 ld (ix), de                    ; DD 1F 00
 ld (ix), e                     ; DD 73 00
 ld (ix), h                     ; DD 74 00
 ld (ix), hl                    ; DD 2F 00
 ld (ix), ix                    ; DD 3F 00
 ld (ix), iy                    ; DD 3E 00
 ld (ix), l                     ; DD 75 00
 ld (ix+126), -128              ; DD 36 7E 80
 ld (ix+126), 127               ; DD 36 7E 7F
 ld (ix+126), 255               ; DD 36 7E FF
 ld (ix+126), a                 ; DD 77 7E
 ld (ix+126), b                 ; DD 70 7E
 ld (ix+126), bc                ; DD 0F 7E
 ld (ix+126), c                 ; DD 71 7E
 ld (ix+126), d                 ; DD 72 7E
 ld (ix+126), de                ; DD 1F 7E
 ld (ix+126), e                 ; DD 73 7E
 ld (ix+126), h                 ; DD 74 7E
 ld (ix+126), hl                ; DD 2F 7E
 ld (ix+126), ix                ; DD 3F 7E
 ld (ix+126), iy                ; DD 3E 7E
 ld (ix+126), l                 ; DD 75 7E
 ld (ix-128), -128              ; DD 36 80 80
 ld (ix-128), 127               ; DD 36 80 7F
 ld (ix-128), 255               ; DD 36 80 FF
 ld (ix-128), a                 ; DD 77 80
 ld (ix-128), b                 ; DD 70 80
 ld (ix-128), bc                ; DD 0F 80
 ld (ix-128), c                 ; DD 71 80
 ld (ix-128), d                 ; DD 72 80
 ld (ix-128), de                ; DD 1F 80
 ld (ix-128), e                 ; DD 73 80
 ld (ix-128), h                 ; DD 74 80
 ld (ix-128), hl                ; DD 2F 80
 ld (ix-128), ix                ; DD 3F 80
 ld (ix-128), iy                ; DD 3E 80
 ld (ix-128), l                 ; DD 75 80
 ld (iy), -128                  ; FD 36 00 80
 ld (iy), 127                   ; FD 36 00 7F
 ld (iy), 255                   ; FD 36 00 FF
 ld (iy), a                     ; FD 77 00
 ld (iy), b                     ; FD 70 00
 ld (iy), bc                    ; FD 0F 00
 ld (iy), c                     ; FD 71 00
 ld (iy), d                     ; FD 72 00
 ld (iy), de                    ; FD 1F 00
 ld (iy), e                     ; FD 73 00
 ld (iy), h                     ; FD 74 00
 ld (iy), hl                    ; FD 2F 00
 ld (iy), ix                    ; FD 3E 00
 ld (iy), iy                    ; FD 3F 00
 ld (iy), l                     ; FD 75 00
 ld (iy+126), -128              ; FD 36 7E 80
 ld (iy+126), 127               ; FD 36 7E 7F
 ld (iy+126), 255               ; FD 36 7E FF
 ld (iy+126), a                 ; FD 77 7E
 ld (iy+126), b                 ; FD 70 7E
 ld (iy+126), bc                ; FD 0F 7E
 ld (iy+126), c                 ; FD 71 7E
 ld (iy+126), d                 ; FD 72 7E
 ld (iy+126), de                ; FD 1F 7E
 ld (iy+126), e                 ; FD 73 7E
 ld (iy+126), h                 ; FD 74 7E
 ld (iy+126), hl                ; FD 2F 7E
 ld (iy+126), ix                ; FD 3E 7E
 ld (iy+126), iy                ; FD 3F 7E
 ld (iy+126), l                 ; FD 75 7E
 ld (iy-128), -128              ; FD 36 80 80
 ld (iy-128), 127               ; FD 36 80 7F
 ld (iy-128), 255               ; FD 36 80 FF
 ld (iy-128), a                 ; FD 77 80
 ld (iy-128), b                 ; FD 70 80
 ld (iy-128), bc                ; FD 0F 80
 ld (iy-128), c                 ; FD 71 80
 ld (iy-128), d                 ; FD 72 80
 ld (iy-128), de                ; FD 1F 80
 ld (iy-128), e                 ; FD 73 80
 ld (iy-128), h                 ; FD 74 80
 ld (iy-128), hl                ; FD 2F 80
 ld (iy-128), ix                ; FD 3E 80
 ld (iy-128), iy                ; FD 3F 80
 ld (iy-128), l                 ; FD 75 80
 ld a, (-32768)                 ; 3A 00 80 FF
 ld a, (0x123456)               ; 3A 56 34 12
 ld a, (32767)                  ; 3A FF 7F 00
 ld a, (65535)                  ; 3A FF FF 00
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
 ld a, (ix)                     ; DD 7E 00
 ld a, (ix+126)                 ; DD 7E 7E
 ld a, (ix-128)                 ; DD 7E 80
 ld a, (iy)                     ; FD 7E 00
 ld a, (iy+126)                 ; FD 7E 7E
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
 ld a, mb                       ; ED 6E
 ld a, r                        ; ED 5F
 ld b, (de)                     ; EB 46 EB
 ld b, (de+)                    ; EB 46 EB 13
 ld b, (de-)                    ; EB 46 EB 1B
 ld b, (hl)                     ; 46
 ld b, (hl+)                    ; 46 23
 ld b, (hl-)                    ; 46 2B
 ld b, (hld)                    ; 46 2B
 ld b, (hli)                    ; 46 23
 ld b, (ix)                     ; DD 46 00
 ld b, (ix+126)                 ; DD 46 7E
 ld b, (ix-128)                 ; DD 46 80
 ld b, (iy)                     ; FD 46 00
 ld b, (iy+126)                 ; FD 46 7E
 ld b, (iy-128)                 ; FD 46 80
 ld b, -128                     ; 06 80
 ld b, 127                      ; 06 7F
 ld b, 255                      ; 06 FF
 ld b, a                        ; 47
 ld b, c                        ; 41
 ld b, d                        ; 42
 ld b, e                        ; 43
 ld b, h                        ; 44
 ld b, ixh                      ; DD 44
 ld b, ixl                      ; DD 45
 ld b, iyh                      ; FD 44
 ld b, iyl                      ; FD 45
 ld b, l                        ; 45
 ld bc, (-32768)                ; ED 4B 00 80 FF
 ld bc, (0x123456)              ; ED 4B 56 34 12
 ld bc, (32767)                 ; ED 4B FF 7F 00
 ld bc, (65535)                 ; ED 4B FF FF 00
 ld bc, (hl)                    ; ED 07
 ld bc, (hl+)                   ; ED 07 23 23
 ld bc, (ix)                    ; DD 07 00
 ld bc, (ix+126)                ; DD 07 7E
 ld bc, (ix-128)                ; DD 07 80
 ld bc, (iy)                    ; FD 07 00
 ld bc, (iy+126)                ; FD 07 7E
 ld bc, (iy-128)                ; FD 07 80
 ld bc, -32768                  ; 01 00 80 FF
 ld bc, 0x123456                ; 01 56 34 12
 ld bc, 32767                   ; 01 FF 7F 00
 ld bc, 65535                   ; 01 FF FF 00
 ld bc, de                      ; 42 4B
 ld bc, hl                      ; 44 4D
 ld bc, ix                      ; DD 44 DD 4D
 ld bc, iy                      ; FD 44 FD 4D
 ld c, (de)                     ; EB 4E EB
 ld c, (de+)                    ; EB 4E EB 13
 ld c, (de-)                    ; EB 4E EB 1B
 ld c, (hl)                     ; 4E
 ld c, (hl+)                    ; 4E 23
 ld c, (hl-)                    ; 4E 2B
 ld c, (hld)                    ; 4E 2B
 ld c, (hli)                    ; 4E 23
 ld c, (ix)                     ; DD 4E 00
 ld c, (ix+126)                 ; DD 4E 7E
 ld c, (ix-128)                 ; DD 4E 80
 ld c, (iy)                     ; FD 4E 00
 ld c, (iy+126)                 ; FD 4E 7E
 ld c, (iy-128)                 ; FD 4E 80
 ld c, -128                     ; 0E 80
 ld c, 127                      ; 0E 7F
 ld c, 255                      ; 0E FF
 ld c, a                        ; 4F
 ld c, b                        ; 48
 ld c, d                        ; 4A
 ld c, e                        ; 4B
 ld c, h                        ; 4C
 ld c, ixh                      ; DD 4C
 ld c, ixl                      ; DD 4D
 ld c, iyh                      ; FD 4C
 ld c, iyl                      ; FD 4D
 ld c, l                        ; 4D
 ld d, (de)                     ; EB 66 EB
 ld d, (de+)                    ; EB 66 EB 13
 ld d, (de-)                    ; EB 66 EB 1B
 ld d, (hl)                     ; 56
 ld d, (hl+)                    ; 56 23
 ld d, (hl-)                    ; 56 2B
 ld d, (hld)                    ; 56 2B
 ld d, (hli)                    ; 56 23
 ld d, (ix)                     ; DD 56 00
 ld d, (ix+126)                 ; DD 56 7E
 ld d, (ix-128)                 ; DD 56 80
 ld d, (iy)                     ; FD 56 00
 ld d, (iy+126)                 ; FD 56 7E
 ld d, (iy-128)                 ; FD 56 80
 ld d, -128                     ; 16 80
 ld d, 127                      ; 16 7F
 ld d, 255                      ; 16 FF
 ld d, a                        ; 57
 ld d, b                        ; 50
 ld d, c                        ; 51
 ld d, e                        ; 53
 ld d, h                        ; 54
 ld d, ixh                      ; DD 54
 ld d, ixl                      ; DD 55
 ld d, iyh                      ; FD 54
 ld d, iyl                      ; FD 55
 ld d, l                        ; 55
 ld de, (-32768)                ; ED 5B 00 80 FF
 ld de, (0x123456)              ; ED 5B 56 34 12
 ld de, (32767)                 ; ED 5B FF 7F 00
 ld de, (65535)                 ; ED 5B FF FF 00
 ld de, (hl)                    ; ED 17
 ld de, (hl+)                   ; ED 17 23 23
 ld de, (ix)                    ; DD 17 00
 ld de, (ix+126)                ; DD 17 7E
 ld de, (ix-128)                ; DD 17 80
 ld de, (iy)                    ; FD 17 00
 ld de, (iy+126)                ; FD 17 7E
 ld de, (iy-128)                ; FD 17 80
 ld de, -32768                  ; 11 00 80 FF
 ld de, 0x123456                ; 11 56 34 12
 ld de, 32767                   ; 11 FF 7F 00
 ld de, 65535                   ; 11 FF FF 00
 ld de, bc                      ; 50 59
 ld de, hl                      ; 54 5D
 ld de, ix                      ; DD 54 DD 5D
 ld de, iy                      ; FD 54 FD 5D
 ld de, sp                      ; EB 21 00 00 39 EB
 ld de, sp+0                    ; EB 21 00 00 39 EB
 ld de, sp+255                  ; EB 21 FF 00 39 EB
 ld e, (de)                     ; EB 6E EB
 ld e, (de+)                    ; EB 6E EB 13
 ld e, (de-)                    ; EB 6E EB 1B
 ld e, (hl)                     ; 5E
 ld e, (hl+)                    ; 5E 23
 ld e, (hl-)                    ; 5E 2B
 ld e, (hld)                    ; 5E 2B
 ld e, (hli)                    ; 5E 23
 ld e, (ix)                     ; DD 5E 00
 ld e, (ix+126)                 ; DD 5E 7E
 ld e, (ix-128)                 ; DD 5E 80
 ld e, (iy)                     ; FD 5E 00
 ld e, (iy+126)                 ; FD 5E 7E
 ld e, (iy-128)                 ; FD 5E 80
 ld e, -128                     ; 1E 80
 ld e, 127                      ; 1E 7F
 ld e, 255                      ; 1E FF
 ld e, a                        ; 5F
 ld e, b                        ; 58
 ld e, c                        ; 59
 ld e, d                        ; 5A
 ld e, h                        ; 5C
 ld e, ixh                      ; DD 5C
 ld e, ixl                      ; DD 5D
 ld e, iyh                      ; FD 5C
 ld e, iyl                      ; FD 5D
 ld e, l                        ; 5D
 ld h, (de)                     ; EB 56 EB
 ld h, (de+)                    ; EB 56 EB 13
 ld h, (de-)                    ; EB 56 EB 1B
 ld h, (hl)                     ; 66
 ld h, (hl+)                    ; 66 23
 ld h, (hl-)                    ; 66 2B
 ld h, (hld)                    ; 66 2B
 ld h, (hli)                    ; 66 23
 ld h, (ix)                     ; DD 66 00
 ld h, (ix+126)                 ; DD 66 7E
 ld h, (ix-128)                 ; DD 66 80
 ld h, (iy)                     ; FD 66 00
 ld h, (iy+126)                 ; FD 66 7E
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
 ld hl, (-32768)                ; 2A 00 80 FF
 ld hl, (0x123456)              ; 2A 56 34 12
 ld hl, (32767)                 ; 2A FF 7F 00
 ld hl, (65535)                 ; 2A FF FF 00
 ld hl, (hl)                    ; ED 27
 ld hl, (hl+)                   ; ED 27 23 23
 ld hl, (ix)                    ; DD 27 00
 ld hl, (ix+126)                ; DD 27 7E
 ld hl, (ix-128)                ; DD 27 80
 ld hl, (iy)                    ; FD 27 00
 ld hl, (iy+126)                ; FD 27 7E
 ld hl, (iy-128)                ; FD 27 80
 ld hl, -32768                  ; 21 00 80 FF
 ld hl, 0x123456                ; 21 56 34 12
 ld hl, 32767                   ; 21 FF 7F 00
 ld hl, 65535                   ; 21 FF FF 00
 ld hl, bc                      ; 60 69
 ld hl, de                      ; 62 6B
 ld hl, i                       ; ED D7
 ld hl, ix                      ; DD E5 E1
 ld hl, iy                      ; FD E5 E1
 ld hl, sp                      ; 21 00 00 39
 ld hl, sp+127                  ; 21 7F 00 39
 ld hl, sp-128                  ; 21 80 FF 39
 ld i, a                        ; ED 47
 ld i, hl                       ; ED C7
 ld ix, (-32768)                ; DD 2A 00 80 FF
 ld ix, (0x123456)              ; DD 2A 56 34 12
 ld ix, (32767)                 ; DD 2A FF 7F 00
 ld ix, (65535)                 ; DD 2A FF FF 00
 ld ix, (hl)                    ; ED 37
 ld ix, (hl+)                   ; ED 37 23 23
 ld ix, (ix)                    ; DD 37 00
 ld ix, (ix+126)                ; DD 37 7E
 ld ix, (ix-128)                ; DD 37 80
 ld ix, (iy)                    ; FD 31 00
 ld ix, (iy+126)                ; FD 31 7E
 ld ix, (iy-128)                ; FD 31 80
 ld ix, -32768                  ; DD 21 00 80 FF
 ld ix, 0x123456                ; DD 21 56 34 12
 ld ix, 32767                   ; DD 21 FF 7F 00
 ld ix, 65535                   ; DD 21 FF FF 00
 ld ix, bc                      ; DD 60 DD 69
 ld ix, de                      ; DD 62 DD 6B
 ld ix, hl                      ; E5 DD E1
 ld ix, iy                      ; FD E5 DD E1
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
 ld iy, (-32768)                ; FD 2A 00 80 FF
 ld iy, (0x123456)              ; FD 2A 56 34 12
 ld iy, (32767)                 ; FD 2A FF 7F 00
 ld iy, (65535)                 ; FD 2A FF FF 00
 ld iy, (hl)                    ; ED 31
 ld iy, (hl+)                   ; ED 31 23 23
 ld iy, (ix)                    ; DD 31 00
 ld iy, (ix+126)                ; DD 31 7E
 ld iy, (ix-128)                ; DD 31 80
 ld iy, (iy)                    ; FD 37 00
 ld iy, (iy+126)                ; FD 37 7E
 ld iy, (iy-128)                ; FD 37 80
 ld iy, -32768                  ; FD 21 00 80 FF
 ld iy, 0x123456                ; FD 21 56 34 12
 ld iy, 32767                   ; FD 21 FF 7F 00
 ld iy, 65535                   ; FD 21 FF FF 00
 ld iy, bc                      ; FD 60 FD 69
 ld iy, de                      ; FD 62 FD 6B
 ld iy, hl                      ; E5 FD E1
 ld iy, ix                      ; DD E5 FD E1
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
 ld l, (de)                     ; EB 5E EB
 ld l, (de+)                    ; EB 5E EB 13
 ld l, (de-)                    ; EB 5E EB 1B
 ld l, (hl)                     ; 6E
 ld l, (hl+)                    ; 6E 23
 ld l, (hl-)                    ; 6E 2B
 ld l, (hld)                    ; 6E 2B
 ld l, (hli)                    ; 6E 23
 ld l, (ix)                     ; DD 6E 00
 ld l, (ix+126)                 ; DD 6E 7E
 ld l, (ix-128)                 ; DD 6E 80
 ld l, (iy)                     ; FD 6E 00
 ld l, (iy+126)                 ; FD 6E 7E
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
 ld mb, a                       ; ED 6D
 ld r, a                        ; ED 4F
 ld sp, (-32768)                ; ED 7B 00 80 FF
 ld sp, (0x123456)              ; ED 7B 56 34 12
 ld sp, (32767)                 ; ED 7B FF 7F 00
 ld sp, (65535)                 ; ED 7B FF FF 00
 ld sp, -32768                  ; 31 00 80 FF
 ld sp, 0x123456                ; 31 56 34 12
 ld sp, 32767                   ; 31 FF 7F 00
 ld sp, 65535                   ; 31 FF FF 00
 ld sp, hl                      ; F9
 ld sp, ix                      ; DD F9
 ld sp, iy                      ; FD F9
 ld.il (-32768), a              ; 5B 32 00 80 FF
 ld.il (0x123456), a            ; 5B 32 56 34 12
 ld.il (32767), a               ; 5B 32 FF 7F 00
 ld.il (65535), a               ; 5B 32 FF FF 00
 ld.il a, (-32768)              ; 5B 3A 00 80 FF
 ld.il a, (0x123456)            ; 5B 3A 56 34 12
 ld.il a, (32767)               ; 5B 3A FF 7F 00
 ld.il a, (65535)               ; 5B 3A FF FF 00
 ld.is (-32768), a              ; 40 32 00 80
 ld.is (0x123456), a            ; 40 32 56 34
 ld.is (32767), a               ; 40 32 FF 7F
 ld.is (65535), a               ; 40 32 FF FF
 ld.is a, (-32768)              ; 40 3A 00 80
 ld.is a, (0x123456)            ; 40 3A 56 34
 ld.is a, (32767)               ; 40 3A FF 7F
 ld.is a, (65535)               ; 40 3A FF FF
 ld.s (bc), a                   ; 52 02
 ld.s (bc+), a                  ; 52 02 03
 ld.s (bc-), a                  ; 52 02 0B
 ld.s (de), a                   ; 52 12
 ld.s (de+), a                  ; 52 12 13
 ld.s (de-), a                  ; 52 12 1B
 ld.s (hl), -128                ; 52 36 80
 ld.s (hl), 127                 ; 52 36 7F
 ld.s (hl), 255                 ; 52 36 FF
 ld.s (hl), a                   ; 52 77
 ld.s (hl), b                   ; 52 70
 ld.s (hl), bc                  ; 52 ED 0F
 ld.s (hl), c                   ; 52 71
 ld.s (hl), d                   ; 52 72
 ld.s (hl), de                  ; 52 ED 1F
 ld.s (hl), e                   ; 52 73
 ld.s (hl), h                   ; 52 74
 ld.s (hl), hl                  ; 52 ED 2F
 ld.s (hl), ix                  ; 52 ED 3F
 ld.s (hl), iy                  ; 52 ED 3E
 ld.s (hl), l                   ; 52 75
 ld.s (hl+), -128               ; 52 36 80 23
 ld.s (hl+), 127                ; 52 36 7F 23
 ld.s (hl+), 255                ; 52 36 FF 23
 ld.s (hl+), a                  ; 52 77 23
 ld.s (hl+), b                  ; 52 70 23
 ld.s (hl+), bc                 ; 52 ED 0F 23 23
 ld.s (hl+), c                  ; 52 71 23
 ld.s (hl+), d                  ; 52 72 23
 ld.s (hl+), de                 ; 52 ED 1F 23 23
 ld.s (hl+), e                  ; 52 73 23
 ld.s (hl+), h                  ; 52 74 23
 ld.s (hl+), hl                 ; 52 ED 2F 23 23
 ld.s (hl+), ix                 ; 52 ED 3F 23 23
 ld.s (hl+), iy                 ; 52 ED 3E 23 23
 ld.s (hl+), l                  ; 52 75 23
 ld.s (hl-), -128               ; 52 36 80 2B
 ld.s (hl-), 127                ; 52 36 7F 2B
 ld.s (hl-), 255                ; 52 36 FF 2B
 ld.s (hl-), a                  ; 52 77 2B
 ld.s (hl-), b                  ; 52 70 2B
 ld.s (hl-), c                  ; 52 71 2B
 ld.s (hl-), d                  ; 52 72 2B
 ld.s (hl-), e                  ; 52 73 2B
 ld.s (hl-), h                  ; 52 74 2B
 ld.s (hl-), l                  ; 52 75 2B
 ld.s (hld), a                  ; 52 77 2B
 ld.s (hld), b                  ; 52 70 2B
 ld.s (hld), c                  ; 52 71 2B
 ld.s (hld), d                  ; 52 72 2B
 ld.s (hld), e                  ; 52 73 2B
 ld.s (hld), h                  ; 52 74 2B
 ld.s (hld), l                  ; 52 75 2B
 ld.s (hli), a                  ; 52 77 23
 ld.s (hli), b                  ; 52 70 23
 ld.s (hli), c                  ; 52 71 23
 ld.s (hli), d                  ; 52 72 23
 ld.s (hli), e                  ; 52 73 23
 ld.s (hli), h                  ; 52 74 23
 ld.s (hli), l                  ; 52 75 23
 ld.s (ix), -128                ; 52 DD 36 00 80
 ld.s (ix), 127                 ; 52 DD 36 00 7F
 ld.s (ix), 255                 ; 52 DD 36 00 FF
 ld.s (ix), a                   ; 52 DD 77 00
 ld.s (ix), b                   ; 52 DD 70 00
 ld.s (ix), bc                  ; 52 DD 0F 00
 ld.s (ix), c                   ; 52 DD 71 00
 ld.s (ix), d                   ; 52 DD 72 00
 ld.s (ix), de                  ; 52 DD 1F 00
 ld.s (ix), e                   ; 52 DD 73 00
 ld.s (ix), h                   ; 52 DD 74 00
 ld.s (ix), hl                  ; 52 DD 2F 00
 ld.s (ix), ix                  ; 52 DD 3F 00
 ld.s (ix), iy                  ; 52 DD 3E 00
 ld.s (ix), l                   ; 52 DD 75 00
 ld.s (ix+126), -128            ; 52 DD 36 7E 80
 ld.s (ix+126), 127             ; 52 DD 36 7E 7F
 ld.s (ix+126), 255             ; 52 DD 36 7E FF
 ld.s (ix+126), a               ; 52 DD 77 7E
 ld.s (ix+126), b               ; 52 DD 70 7E
 ld.s (ix+126), bc              ; 52 DD 0F 7E
 ld.s (ix+126), c               ; 52 DD 71 7E
 ld.s (ix+126), d               ; 52 DD 72 7E
 ld.s (ix+126), de              ; 52 DD 1F 7E
 ld.s (ix+126), e               ; 52 DD 73 7E
 ld.s (ix+126), h               ; 52 DD 74 7E
 ld.s (ix+126), hl              ; 52 DD 2F 7E
 ld.s (ix+126), ix              ; 52 DD 3F 7E
 ld.s (ix+126), iy              ; 52 DD 3E 7E
 ld.s (ix+126), l               ; 52 DD 75 7E
 ld.s (ix-128), -128            ; 52 DD 36 80 80
 ld.s (ix-128), 127             ; 52 DD 36 80 7F
 ld.s (ix-128), 255             ; 52 DD 36 80 FF
 ld.s (ix-128), a               ; 52 DD 77 80
 ld.s (ix-128), b               ; 52 DD 70 80
 ld.s (ix-128), bc              ; 52 DD 0F 80
 ld.s (ix-128), c               ; 52 DD 71 80
 ld.s (ix-128), d               ; 52 DD 72 80
 ld.s (ix-128), de              ; 52 DD 1F 80
 ld.s (ix-128), e               ; 52 DD 73 80
 ld.s (ix-128), h               ; 52 DD 74 80
 ld.s (ix-128), hl              ; 52 DD 2F 80
 ld.s (ix-128), ix              ; 52 DD 3F 80
 ld.s (ix-128), iy              ; 52 DD 3E 80
 ld.s (ix-128), l               ; 52 DD 75 80
 ld.s (iy), -128                ; 52 FD 36 00 80
 ld.s (iy), 127                 ; 52 FD 36 00 7F
 ld.s (iy), 255                 ; 52 FD 36 00 FF
 ld.s (iy), a                   ; 52 FD 77 00
 ld.s (iy), b                   ; 52 FD 70 00
 ld.s (iy), bc                  ; 52 FD 0F 00
 ld.s (iy), c                   ; 52 FD 71 00
 ld.s (iy), d                   ; 52 FD 72 00
 ld.s (iy), de                  ; 52 FD 1F 00
 ld.s (iy), e                   ; 52 FD 73 00
 ld.s (iy), h                   ; 52 FD 74 00
 ld.s (iy), hl                  ; 52 FD 2F 00
 ld.s (iy), ix                  ; 52 FD 3E 00
 ld.s (iy), iy                  ; 52 FD 3F 00
 ld.s (iy), l                   ; 52 FD 75 00
 ld.s (iy+126), -128            ; 52 FD 36 7E 80
 ld.s (iy+126), 127             ; 52 FD 36 7E 7F
 ld.s (iy+126), 255             ; 52 FD 36 7E FF
 ld.s (iy+126), a               ; 52 FD 77 7E
 ld.s (iy+126), b               ; 52 FD 70 7E
 ld.s (iy+126), bc              ; 52 FD 0F 7E
 ld.s (iy+126), c               ; 52 FD 71 7E
 ld.s (iy+126), d               ; 52 FD 72 7E
 ld.s (iy+126), de              ; 52 FD 1F 7E
 ld.s (iy+126), e               ; 52 FD 73 7E
 ld.s (iy+126), h               ; 52 FD 74 7E
 ld.s (iy+126), hl              ; 52 FD 2F 7E
 ld.s (iy+126), ix              ; 52 FD 3E 7E
 ld.s (iy+126), iy              ; 52 FD 3F 7E
 ld.s (iy+126), l               ; 52 FD 75 7E
 ld.s (iy-128), -128            ; 52 FD 36 80 80
 ld.s (iy-128), 127             ; 52 FD 36 80 7F
 ld.s (iy-128), 255             ; 52 FD 36 80 FF
 ld.s (iy-128), a               ; 52 FD 77 80
 ld.s (iy-128), b               ; 52 FD 70 80
 ld.s (iy-128), bc              ; 52 FD 0F 80
 ld.s (iy-128), c               ; 52 FD 71 80
 ld.s (iy-128), d               ; 52 FD 72 80
 ld.s (iy-128), de              ; 52 FD 1F 80
 ld.s (iy-128), e               ; 52 FD 73 80
 ld.s (iy-128), h               ; 52 FD 74 80
 ld.s (iy-128), hl              ; 52 FD 2F 80
 ld.s (iy-128), ix              ; 52 FD 3E 80
 ld.s (iy-128), iy              ; 52 FD 3F 80
 ld.s (iy-128), l               ; 52 FD 75 80
 ld.s a, (bc)                   ; 52 0A
 ld.s a, (bc+)                  ; 52 0A 03
 ld.s a, (bc-)                  ; 52 0A 0B
 ld.s a, (de)                   ; 52 1A
 ld.s a, (de+)                  ; 52 1A 13
 ld.s a, (de-)                  ; 52 1A 1B
 ld.s a, (hl)                   ; 52 7E
 ld.s a, (hl+)                  ; 52 7E 23
 ld.s a, (hl-)                  ; 52 7E 2B
 ld.s a, (hld)                  ; 52 7E 2B
 ld.s a, (hli)                  ; 52 7E 23
 ld.s a, (ix)                   ; 52 DD 7E 00
 ld.s a, (ix+126)               ; 52 DD 7E 7E
 ld.s a, (ix-128)               ; 52 DD 7E 80
 ld.s a, (iy)                   ; 52 FD 7E 00
 ld.s a, (iy+126)               ; 52 FD 7E 7E
 ld.s a, (iy-128)               ; 52 FD 7E 80
 ld.s b, (hl)                   ; 52 46
 ld.s b, (hl+)                  ; 52 46 23
 ld.s b, (hl-)                  ; 52 46 2B
 ld.s b, (hld)                  ; 52 46 2B
 ld.s b, (hli)                  ; 52 46 23
 ld.s b, (ix)                   ; 52 DD 46 00
 ld.s b, (ix+126)               ; 52 DD 46 7E
 ld.s b, (ix-128)               ; 52 DD 46 80
 ld.s b, (iy)                   ; 52 FD 46 00
 ld.s b, (iy+126)               ; 52 FD 46 7E
 ld.s b, (iy-128)               ; 52 FD 46 80
 ld.s bc, (hl)                  ; 52 ED 07
 ld.s bc, (hl+)                 ; 52 ED 07 23 23
 ld.s bc, (ix)                  ; 52 DD 07 00
 ld.s bc, (ix+126)              ; 52 DD 07 7E
 ld.s bc, (ix-128)              ; 52 DD 07 80
 ld.s bc, (iy)                  ; 52 FD 07 00
 ld.s bc, (iy+126)              ; 52 FD 07 7E
 ld.s bc, (iy-128)              ; 52 FD 07 80
 ld.s c, (hl)                   ; 52 4E
 ld.s c, (hl+)                  ; 52 4E 23
 ld.s c, (hl-)                  ; 52 4E 2B
 ld.s c, (hld)                  ; 52 4E 2B
 ld.s c, (hli)                  ; 52 4E 23
 ld.s c, (ix)                   ; 52 DD 4E 00
 ld.s c, (ix+126)               ; 52 DD 4E 7E
 ld.s c, (ix-128)               ; 52 DD 4E 80
 ld.s c, (iy)                   ; 52 FD 4E 00
 ld.s c, (iy+126)               ; 52 FD 4E 7E
 ld.s c, (iy-128)               ; 52 FD 4E 80
 ld.s d, (hl)                   ; 52 56
 ld.s d, (hl+)                  ; 52 56 23
 ld.s d, (hl-)                  ; 52 56 2B
 ld.s d, (hld)                  ; 52 56 2B
 ld.s d, (hli)                  ; 52 56 23
 ld.s d, (ix)                   ; 52 DD 56 00
 ld.s d, (ix+126)               ; 52 DD 56 7E
 ld.s d, (ix-128)               ; 52 DD 56 80
 ld.s d, (iy)                   ; 52 FD 56 00
 ld.s d, (iy+126)               ; 52 FD 56 7E
 ld.s d, (iy-128)               ; 52 FD 56 80
 ld.s de, (hl)                  ; 52 ED 17
 ld.s de, (hl+)                 ; 52 ED 17 23 23
 ld.s de, (ix)                  ; 52 DD 17 00
 ld.s de, (ix+126)              ; 52 DD 17 7E
 ld.s de, (ix-128)              ; 52 DD 17 80
 ld.s de, (iy)                  ; 52 FD 17 00
 ld.s de, (iy+126)              ; 52 FD 17 7E
 ld.s de, (iy-128)              ; 52 FD 17 80
 ld.s e, (hl)                   ; 52 5E
 ld.s e, (hl+)                  ; 52 5E 23
 ld.s e, (hl-)                  ; 52 5E 2B
 ld.s e, (hld)                  ; 52 5E 2B
 ld.s e, (hli)                  ; 52 5E 23
 ld.s e, (ix)                   ; 52 DD 5E 00
 ld.s e, (ix+126)               ; 52 DD 5E 7E
 ld.s e, (ix-128)               ; 52 DD 5E 80
 ld.s e, (iy)                   ; 52 FD 5E 00
 ld.s e, (iy+126)               ; 52 FD 5E 7E
 ld.s e, (iy-128)               ; 52 FD 5E 80
 ld.s h, (hl)                   ; 52 66
 ld.s h, (hl+)                  ; 52 66 23
 ld.s h, (hl-)                  ; 52 66 2B
 ld.s h, (hld)                  ; 52 66 2B
 ld.s h, (hli)                  ; 52 66 23
 ld.s h, (ix)                   ; 52 DD 66 00
 ld.s h, (ix+126)               ; 52 DD 66 7E
 ld.s h, (ix-128)               ; 52 DD 66 80
 ld.s h, (iy)                   ; 52 FD 66 00
 ld.s h, (iy+126)               ; 52 FD 66 7E
 ld.s h, (iy-128)               ; 52 FD 66 80
 ld.s hl, (hl)                  ; 52 ED 27
 ld.s hl, (hl+)                 ; 52 ED 27 23 23
 ld.s hl, (ix)                  ; 52 DD 27 00
 ld.s hl, (ix+126)              ; 52 DD 27 7E
 ld.s hl, (ix-128)              ; 52 DD 27 80
 ld.s hl, (iy)                  ; 52 FD 27 00
 ld.s hl, (iy+126)              ; 52 FD 27 7E
 ld.s hl, (iy-128)              ; 52 FD 27 80
 ld.s ix, (hl)                  ; 52 ED 37
 ld.s ix, (hl+)                 ; 52 ED 37 23 23
 ld.s ix, (ix)                  ; 52 DD 37 00
 ld.s ix, (ix+126)              ; 52 DD 37 7E
 ld.s ix, (ix-128)              ; 52 DD 37 80
 ld.s ix, (iy)                  ; 52 FD 31 00
 ld.s ix, (iy+126)              ; 52 FD 31 7E
 ld.s ix, (iy-128)              ; 52 FD 31 80
 ld.s iy, (hl)                  ; 52 ED 31
 ld.s iy, (hl+)                 ; 52 ED 31 23 23
 ld.s iy, (ix)                  ; 52 DD 31 00
 ld.s iy, (ix+126)              ; 52 DD 31 7E
 ld.s iy, (ix-128)              ; 52 DD 31 80
 ld.s iy, (iy)                  ; 52 FD 37 00
 ld.s iy, (iy+126)              ; 52 FD 37 7E
 ld.s iy, (iy-128)              ; 52 FD 37 80
 ld.s l, (hl)                   ; 52 6E
 ld.s l, (hl+)                  ; 52 6E 23
 ld.s l, (hl-)                  ; 52 6E 2B
 ld.s l, (hld)                  ; 52 6E 2B
 ld.s l, (hli)                  ; 52 6E 23
 ld.s l, (ix)                   ; 52 DD 6E 00
 ld.s l, (ix+126)               ; 52 DD 6E 7E
 ld.s l, (ix-128)               ; 52 DD 6E 80
 ld.s l, (iy)                   ; 52 FD 6E 00
 ld.s l, (iy+126)               ; 52 FD 6E 7E
 ld.s l, (iy-128)               ; 52 FD 6E 80
 ld.s sp, hl                    ; 52 F9
 ld.s sp, ix                    ; 52 DD F9
 ld.s sp, iy                    ; 52 FD F9
 ld.sil (bc), a                 ; 52 02
 ld.sil (bc+), a                ; 52 02 03
 ld.sil (bc-), a                ; 52 02 0B
 ld.sil (de), a                 ; 52 12
 ld.sil (de+), a                ; 52 12 13
 ld.sil (de-), a                ; 52 12 1B
 ld.sil (hl), -128              ; 52 36 80
 ld.sil (hl), 127               ; 52 36 7F
 ld.sil (hl), 255               ; 52 36 FF
 ld.sil (hl), a                 ; 52 77
 ld.sil (hl), b                 ; 52 70
 ld.sil (hl), bc                ; 52 ED 0F
 ld.sil (hl), c                 ; 52 71
 ld.sil (hl), d                 ; 52 72
 ld.sil (hl), de                ; 52 ED 1F
 ld.sil (hl), e                 ; 52 73
 ld.sil (hl), h                 ; 52 74
 ld.sil (hl), hl                ; 52 ED 2F
 ld.sil (hl), ix                ; 52 ED 3F
 ld.sil (hl), iy                ; 52 ED 3E
 ld.sil (hl), l                 ; 52 75
 ld.sil (hl+), -128             ; 52 36 80 23
 ld.sil (hl+), 127              ; 52 36 7F 23
 ld.sil (hl+), 255              ; 52 36 FF 23
 ld.sil (hl+), a                ; 52 77 23
 ld.sil (hl+), b                ; 52 70 23
 ld.sil (hl+), bc               ; 52 ED 0F 23 23
 ld.sil (hl+), c                ; 52 71 23
 ld.sil (hl+), d                ; 52 72 23
 ld.sil (hl+), de               ; 52 ED 1F 23 23
 ld.sil (hl+), e                ; 52 73 23
 ld.sil (hl+), h                ; 52 74 23
 ld.sil (hl+), hl               ; 52 ED 2F 23 23
 ld.sil (hl+), ix               ; 52 ED 3F 23 23
 ld.sil (hl+), iy               ; 52 ED 3E 23 23
 ld.sil (hl+), l                ; 52 75 23
 ld.sil (hl-), -128             ; 52 36 80 2B
 ld.sil (hl-), 127              ; 52 36 7F 2B
 ld.sil (hl-), 255              ; 52 36 FF 2B
 ld.sil (hl-), a                ; 52 77 2B
 ld.sil (hl-), b                ; 52 70 2B
 ld.sil (hl-), c                ; 52 71 2B
 ld.sil (hl-), d                ; 52 72 2B
 ld.sil (hl-), e                ; 52 73 2B
 ld.sil (hl-), h                ; 52 74 2B
 ld.sil (hl-), l                ; 52 75 2B
 ld.sil (hld), a                ; 52 77 2B
 ld.sil (hld), b                ; 52 70 2B
 ld.sil (hld), c                ; 52 71 2B
 ld.sil (hld), d                ; 52 72 2B
 ld.sil (hld), e                ; 52 73 2B
 ld.sil (hld), h                ; 52 74 2B
 ld.sil (hld), l                ; 52 75 2B
 ld.sil (hli), a                ; 52 77 23
 ld.sil (hli), b                ; 52 70 23
 ld.sil (hli), c                ; 52 71 23
 ld.sil (hli), d                ; 52 72 23
 ld.sil (hli), e                ; 52 73 23
 ld.sil (hli), h                ; 52 74 23
 ld.sil (hli), l                ; 52 75 23
 ld.sil (ix), -128              ; 52 DD 36 00 80
 ld.sil (ix), 127               ; 52 DD 36 00 7F
 ld.sil (ix), 255               ; 52 DD 36 00 FF
 ld.sil (ix), a                 ; 52 DD 77 00
 ld.sil (ix), b                 ; 52 DD 70 00
 ld.sil (ix), bc                ; 52 DD 0F 00
 ld.sil (ix), c                 ; 52 DD 71 00
 ld.sil (ix), d                 ; 52 DD 72 00
 ld.sil (ix), de                ; 52 DD 1F 00
 ld.sil (ix), e                 ; 52 DD 73 00
 ld.sil (ix), h                 ; 52 DD 74 00
 ld.sil (ix), hl                ; 52 DD 2F 00
 ld.sil (ix), ix                ; 52 DD 3F 00
 ld.sil (ix), iy                ; 52 DD 3E 00
 ld.sil (ix), l                 ; 52 DD 75 00
 ld.sil (ix+126), -128          ; 52 DD 36 7E 80
 ld.sil (ix+126), 127           ; 52 DD 36 7E 7F
 ld.sil (ix+126), 255           ; 52 DD 36 7E FF
 ld.sil (ix+126), a             ; 52 DD 77 7E
 ld.sil (ix+126), b             ; 52 DD 70 7E
 ld.sil (ix+126), bc            ; 52 DD 0F 7E
 ld.sil (ix+126), c             ; 52 DD 71 7E
 ld.sil (ix+126), d             ; 52 DD 72 7E
 ld.sil (ix+126), de            ; 52 DD 1F 7E
 ld.sil (ix+126), e             ; 52 DD 73 7E
 ld.sil (ix+126), h             ; 52 DD 74 7E
 ld.sil (ix+126), hl            ; 52 DD 2F 7E
 ld.sil (ix+126), ix            ; 52 DD 3F 7E
 ld.sil (ix+126), iy            ; 52 DD 3E 7E
 ld.sil (ix+126), l             ; 52 DD 75 7E
 ld.sil (ix-128), -128          ; 52 DD 36 80 80
 ld.sil (ix-128), 127           ; 52 DD 36 80 7F
 ld.sil (ix-128), 255           ; 52 DD 36 80 FF
 ld.sil (ix-128), a             ; 52 DD 77 80
 ld.sil (ix-128), b             ; 52 DD 70 80
 ld.sil (ix-128), bc            ; 52 DD 0F 80
 ld.sil (ix-128), c             ; 52 DD 71 80
 ld.sil (ix-128), d             ; 52 DD 72 80
 ld.sil (ix-128), de            ; 52 DD 1F 80
 ld.sil (ix-128), e             ; 52 DD 73 80
 ld.sil (ix-128), h             ; 52 DD 74 80
 ld.sil (ix-128), hl            ; 52 DD 2F 80
 ld.sil (ix-128), ix            ; 52 DD 3F 80
 ld.sil (ix-128), iy            ; 52 DD 3E 80
 ld.sil (ix-128), l             ; 52 DD 75 80
 ld.sil (iy), -128              ; 52 FD 36 00 80
 ld.sil (iy), 127               ; 52 FD 36 00 7F
 ld.sil (iy), 255               ; 52 FD 36 00 FF
 ld.sil (iy), a                 ; 52 FD 77 00
 ld.sil (iy), b                 ; 52 FD 70 00
 ld.sil (iy), bc                ; 52 FD 0F 00
 ld.sil (iy), c                 ; 52 FD 71 00
 ld.sil (iy), d                 ; 52 FD 72 00
 ld.sil (iy), de                ; 52 FD 1F 00
 ld.sil (iy), e                 ; 52 FD 73 00
 ld.sil (iy), h                 ; 52 FD 74 00
 ld.sil (iy), hl                ; 52 FD 2F 00
 ld.sil (iy), ix                ; 52 FD 3E 00
 ld.sil (iy), iy                ; 52 FD 3F 00
 ld.sil (iy), l                 ; 52 FD 75 00
 ld.sil (iy+126), -128          ; 52 FD 36 7E 80
 ld.sil (iy+126), 127           ; 52 FD 36 7E 7F
 ld.sil (iy+126), 255           ; 52 FD 36 7E FF
 ld.sil (iy+126), a             ; 52 FD 77 7E
 ld.sil (iy+126), b             ; 52 FD 70 7E
 ld.sil (iy+126), bc            ; 52 FD 0F 7E
 ld.sil (iy+126), c             ; 52 FD 71 7E
 ld.sil (iy+126), d             ; 52 FD 72 7E
 ld.sil (iy+126), de            ; 52 FD 1F 7E
 ld.sil (iy+126), e             ; 52 FD 73 7E
 ld.sil (iy+126), h             ; 52 FD 74 7E
 ld.sil (iy+126), hl            ; 52 FD 2F 7E
 ld.sil (iy+126), ix            ; 52 FD 3E 7E
 ld.sil (iy+126), iy            ; 52 FD 3F 7E
 ld.sil (iy+126), l             ; 52 FD 75 7E
 ld.sil (iy-128), -128          ; 52 FD 36 80 80
 ld.sil (iy-128), 127           ; 52 FD 36 80 7F
 ld.sil (iy-128), 255           ; 52 FD 36 80 FF
 ld.sil (iy-128), a             ; 52 FD 77 80
 ld.sil (iy-128), b             ; 52 FD 70 80
 ld.sil (iy-128), bc            ; 52 FD 0F 80
 ld.sil (iy-128), c             ; 52 FD 71 80
 ld.sil (iy-128), d             ; 52 FD 72 80
 ld.sil (iy-128), de            ; 52 FD 1F 80
 ld.sil (iy-128), e             ; 52 FD 73 80
 ld.sil (iy-128), h             ; 52 FD 74 80
 ld.sil (iy-128), hl            ; 52 FD 2F 80
 ld.sil (iy-128), ix            ; 52 FD 3E 80
 ld.sil (iy-128), iy            ; 52 FD 3F 80
 ld.sil (iy-128), l             ; 52 FD 75 80
 ld.sil a, (bc)                 ; 52 0A
 ld.sil a, (bc+)                ; 52 0A 03
 ld.sil a, (bc-)                ; 52 0A 0B
 ld.sil a, (de)                 ; 52 1A
 ld.sil a, (de+)                ; 52 1A 13
 ld.sil a, (de-)                ; 52 1A 1B
 ld.sil a, (hl)                 ; 52 7E
 ld.sil a, (hl+)                ; 52 7E 23
 ld.sil a, (hl-)                ; 52 7E 2B
 ld.sil a, (hld)                ; 52 7E 2B
 ld.sil a, (hli)                ; 52 7E 23
 ld.sil a, (ix)                 ; 52 DD 7E 00
 ld.sil a, (ix+126)             ; 52 DD 7E 7E
 ld.sil a, (ix-128)             ; 52 DD 7E 80
 ld.sil a, (iy)                 ; 52 FD 7E 00
 ld.sil a, (iy+126)             ; 52 FD 7E 7E
 ld.sil a, (iy-128)             ; 52 FD 7E 80
 ld.sil b, (hl)                 ; 52 46
 ld.sil b, (hl+)                ; 52 46 23
 ld.sil b, (hl-)                ; 52 46 2B
 ld.sil b, (hld)                ; 52 46 2B
 ld.sil b, (hli)                ; 52 46 23
 ld.sil b, (ix)                 ; 52 DD 46 00
 ld.sil b, (ix+126)             ; 52 DD 46 7E
 ld.sil b, (ix-128)             ; 52 DD 46 80
 ld.sil b, (iy)                 ; 52 FD 46 00
 ld.sil b, (iy+126)             ; 52 FD 46 7E
 ld.sil b, (iy-128)             ; 52 FD 46 80
 ld.sil bc, (hl)                ; 52 ED 07
 ld.sil bc, (hl+)               ; 52 ED 07 23 23
 ld.sil bc, (ix)                ; 52 DD 07 00
 ld.sil bc, (ix+126)            ; 52 DD 07 7E
 ld.sil bc, (ix-128)            ; 52 DD 07 80
 ld.sil bc, (iy)                ; 52 FD 07 00
 ld.sil bc, (iy+126)            ; 52 FD 07 7E
 ld.sil bc, (iy-128)            ; 52 FD 07 80
 ld.sil c, (hl)                 ; 52 4E
 ld.sil c, (hl+)                ; 52 4E 23
 ld.sil c, (hl-)                ; 52 4E 2B
 ld.sil c, (hld)                ; 52 4E 2B
 ld.sil c, (hli)                ; 52 4E 23
 ld.sil c, (ix)                 ; 52 DD 4E 00
 ld.sil c, (ix+126)             ; 52 DD 4E 7E
 ld.sil c, (ix-128)             ; 52 DD 4E 80
 ld.sil c, (iy)                 ; 52 FD 4E 00
 ld.sil c, (iy+126)             ; 52 FD 4E 7E
 ld.sil c, (iy-128)             ; 52 FD 4E 80
 ld.sil d, (hl)                 ; 52 56
 ld.sil d, (hl+)                ; 52 56 23
 ld.sil d, (hl-)                ; 52 56 2B
 ld.sil d, (hld)                ; 52 56 2B
 ld.sil d, (hli)                ; 52 56 23
 ld.sil d, (ix)                 ; 52 DD 56 00
 ld.sil d, (ix+126)             ; 52 DD 56 7E
 ld.sil d, (ix-128)             ; 52 DD 56 80
 ld.sil d, (iy)                 ; 52 FD 56 00
 ld.sil d, (iy+126)             ; 52 FD 56 7E
 ld.sil d, (iy-128)             ; 52 FD 56 80
 ld.sil de, (hl)                ; 52 ED 17
 ld.sil de, (hl+)               ; 52 ED 17 23 23
 ld.sil de, (ix)                ; 52 DD 17 00
 ld.sil de, (ix+126)            ; 52 DD 17 7E
 ld.sil de, (ix-128)            ; 52 DD 17 80
 ld.sil de, (iy)                ; 52 FD 17 00
 ld.sil de, (iy+126)            ; 52 FD 17 7E
 ld.sil de, (iy-128)            ; 52 FD 17 80
 ld.sil e, (hl)                 ; 52 5E
 ld.sil e, (hl+)                ; 52 5E 23
 ld.sil e, (hl-)                ; 52 5E 2B
 ld.sil e, (hld)                ; 52 5E 2B
 ld.sil e, (hli)                ; 52 5E 23
 ld.sil e, (ix)                 ; 52 DD 5E 00
 ld.sil e, (ix+126)             ; 52 DD 5E 7E
 ld.sil e, (ix-128)             ; 52 DD 5E 80
 ld.sil e, (iy)                 ; 52 FD 5E 00
 ld.sil e, (iy+126)             ; 52 FD 5E 7E
 ld.sil e, (iy-128)             ; 52 FD 5E 80
 ld.sil h, (hl)                 ; 52 66
 ld.sil h, (hl+)                ; 52 66 23
 ld.sil h, (hl-)                ; 52 66 2B
 ld.sil h, (hld)                ; 52 66 2B
 ld.sil h, (hli)                ; 52 66 23
 ld.sil h, (ix)                 ; 52 DD 66 00
 ld.sil h, (ix+126)             ; 52 DD 66 7E
 ld.sil h, (ix-128)             ; 52 DD 66 80
 ld.sil h, (iy)                 ; 52 FD 66 00
 ld.sil h, (iy+126)             ; 52 FD 66 7E
 ld.sil h, (iy-128)             ; 52 FD 66 80
 ld.sil hl, (hl)                ; 52 ED 27
 ld.sil hl, (hl+)               ; 52 ED 27 23 23
 ld.sil hl, (ix)                ; 52 DD 27 00
 ld.sil hl, (ix+126)            ; 52 DD 27 7E
 ld.sil hl, (ix-128)            ; 52 DD 27 80
 ld.sil hl, (iy)                ; 52 FD 27 00
 ld.sil hl, (iy+126)            ; 52 FD 27 7E
 ld.sil hl, (iy-128)            ; 52 FD 27 80
 ld.sil ix, (hl)                ; 52 ED 37
 ld.sil ix, (hl+)               ; 52 ED 37 23 23
 ld.sil ix, (ix)                ; 52 DD 37 00
 ld.sil ix, (ix+126)            ; 52 DD 37 7E
 ld.sil ix, (ix-128)            ; 52 DD 37 80
 ld.sil ix, (iy)                ; 52 FD 31 00
 ld.sil ix, (iy+126)            ; 52 FD 31 7E
 ld.sil ix, (iy-128)            ; 52 FD 31 80
 ld.sil iy, (hl)                ; 52 ED 31
 ld.sil iy, (hl+)               ; 52 ED 31 23 23
 ld.sil iy, (ix)                ; 52 DD 31 00
 ld.sil iy, (ix+126)            ; 52 DD 31 7E
 ld.sil iy, (ix-128)            ; 52 DD 31 80
 ld.sil iy, (iy)                ; 52 FD 37 00
 ld.sil iy, (iy+126)            ; 52 FD 37 7E
 ld.sil iy, (iy-128)            ; 52 FD 37 80
 ld.sil l, (hl)                 ; 52 6E
 ld.sil l, (hl+)                ; 52 6E 23
 ld.sil l, (hl-)                ; 52 6E 2B
 ld.sil l, (hld)                ; 52 6E 2B
 ld.sil l, (hli)                ; 52 6E 23
 ld.sil l, (ix)                 ; 52 DD 6E 00
 ld.sil l, (ix+126)             ; 52 DD 6E 7E
 ld.sil l, (ix-128)             ; 52 DD 6E 80
 ld.sil l, (iy)                 ; 52 FD 6E 00
 ld.sil l, (iy+126)             ; 52 FD 6E 7E
 ld.sil l, (iy-128)             ; 52 FD 6E 80
 ld.sil sp, hl                  ; 52 F9
 ld.sil sp, ix                  ; 52 DD F9
 ld.sil sp, iy                  ; 52 FD F9
 ld.sis (-32768), a             ; 40 32 00 80
 ld.sis (-32768), bc            ; 40 ED 43 00 80
 ld.sis (-32768), de            ; 40 ED 53 00 80
 ld.sis (-32768), hl            ; 40 22 00 80
 ld.sis (-32768), ix            ; 40 DD 22 00 80
 ld.sis (-32768), iy            ; 40 FD 22 00 80
 ld.sis (-32768), sp            ; 40 ED 73 00 80
 ld.sis (0x123456), a           ; 40 32 56 34
 ld.sis (0x123456), bc          ; 40 ED 43 56 34
 ld.sis (0x123456), de          ; 40 ED 53 56 34
 ld.sis (0x123456), hl          ; 40 22 56 34
 ld.sis (0x123456), ix          ; 40 DD 22 56 34
 ld.sis (0x123456), iy          ; 40 FD 22 56 34
 ld.sis (0x123456), sp          ; 40 ED 73 56 34
 ld.sis (32767), a              ; 40 32 FF 7F
 ld.sis (32767), bc             ; 40 ED 43 FF 7F
 ld.sis (32767), de             ; 40 ED 53 FF 7F
 ld.sis (32767), hl             ; 40 22 FF 7F
 ld.sis (32767), ix             ; 40 DD 22 FF 7F
 ld.sis (32767), iy             ; 40 FD 22 FF 7F
 ld.sis (32767), sp             ; 40 ED 73 FF 7F
 ld.sis (65535), a              ; 40 32 FF FF
 ld.sis (65535), bc             ; 40 ED 43 FF FF
 ld.sis (65535), de             ; 40 ED 53 FF FF
 ld.sis (65535), hl             ; 40 22 FF FF
 ld.sis (65535), ix             ; 40 DD 22 FF FF
 ld.sis (65535), iy             ; 40 FD 22 FF FF
 ld.sis (65535), sp             ; 40 ED 73 FF FF
 ld.sis a, (-32768)             ; 40 3A 00 80
 ld.sis a, (0x123456)           ; 40 3A 56 34
 ld.sis a, (32767)              ; 40 3A FF 7F
 ld.sis a, (65535)              ; 40 3A FF FF
 ld.sis bc, (-32768)            ; 40 ED 4B 00 80
 ld.sis bc, (0x123456)          ; 40 ED 4B 56 34
 ld.sis bc, (32767)             ; 40 ED 4B FF 7F
 ld.sis bc, (65535)             ; 40 ED 4B FF FF
 ld.sis bc, -32768              ; 40 01 00 80
 ld.sis bc, 0x123456            ; 40 01 56 34
 ld.sis bc, 32767               ; 40 01 FF 7F
 ld.sis bc, 65535               ; 40 01 FF FF
 ld.sis de, (-32768)            ; 40 ED 5B 00 80
 ld.sis de, (0x123456)          ; 40 ED 5B 56 34
 ld.sis de, (32767)             ; 40 ED 5B FF 7F
 ld.sis de, (65535)             ; 40 ED 5B FF FF
 ld.sis de, -32768              ; 40 11 00 80
 ld.sis de, 0x123456            ; 40 11 56 34
 ld.sis de, 32767               ; 40 11 FF 7F
 ld.sis de, 65535               ; 40 11 FF FF
 ld.sis hl, (-32768)            ; 40 2A 00 80
 ld.sis hl, (0x123456)          ; 40 2A 56 34
 ld.sis hl, (32767)             ; 40 2A FF 7F
 ld.sis hl, (65535)             ; 40 2A FF FF
 ld.sis hl, -32768              ; 40 21 00 80
 ld.sis hl, 0x123456            ; 40 21 56 34
 ld.sis hl, 32767               ; 40 21 FF 7F
 ld.sis hl, 65535               ; 40 21 FF FF
 ld.sis ix, (-32768)            ; 40 DD 2A 00 80
 ld.sis ix, (0x123456)          ; 40 DD 2A 56 34
 ld.sis ix, (32767)             ; 40 DD 2A FF 7F
 ld.sis ix, (65535)             ; 40 DD 2A FF FF
 ld.sis ix, -32768              ; 40 DD 21 00 80
 ld.sis ix, 0x123456            ; 40 DD 21 56 34
 ld.sis ix, 32767               ; 40 DD 21 FF 7F
 ld.sis ix, 65535               ; 40 DD 21 FF FF
 ld.sis iy, (-32768)            ; 40 FD 2A 00 80
 ld.sis iy, (0x123456)          ; 40 FD 2A 56 34
 ld.sis iy, (32767)             ; 40 FD 2A FF 7F
 ld.sis iy, (65535)             ; 40 FD 2A FF FF
 ld.sis iy, -32768              ; 40 FD 21 00 80
 ld.sis iy, 0x123456            ; 40 FD 21 56 34
 ld.sis iy, 32767               ; 40 FD 21 FF 7F
 ld.sis iy, 65535               ; 40 FD 21 FF FF
 ld.sis sp, (-32768)            ; 40 ED 7B 00 80
 ld.sis sp, (0x123456)          ; 40 ED 7B 56 34
 ld.sis sp, (32767)             ; 40 ED 7B FF 7F
 ld.sis sp, (65535)             ; 40 ED 7B FF FF
 ld.sis sp, -32768              ; 40 31 00 80
 ld.sis sp, 0x123456            ; 40 31 56 34
 ld.sis sp, 32767               ; 40 31 FF 7F
 ld.sis sp, 65535               ; 40 31 FF FF
 ldax b                         ; 0A
 ldax bc                        ; 0A
 ldax d                         ; 1A
 ldax de                        ; 1A
 ldd                            ; ED A8
 ldd (bc), a                    ; 02 0B
 ldd (de), -128                 ; EB 36 80 EB 1B
 ldd (de), 127                  ; EB 36 7F EB 1B
 ldd (de), 255                  ; EB 36 FF EB 1B
 ldd (de), a                    ; 12 1B
 ldd (de), b                    ; EB 70 EB 1B
 ldd (de), c                    ; EB 71 EB 1B
 ldd (de), d                    ; EB 74 EB 1B
 ldd (de), e                    ; EB 75 EB 1B
 ldd (de), h                    ; EB 72 EB 1B
 ldd (de), l                    ; EB 73 EB 1B
 ldd (hl), -128                 ; 36 80 2B
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
 ldd.s                          ; 52 ED A8
 ldd.s (bc), a                  ; 52 02 0B
 ldd.s (de), a                  ; 52 12 1B
 ldd.s (hl), -128               ; 52 36 80 2B
 ldd.s (hl), 127                ; 52 36 7F 2B
 ldd.s (hl), 255                ; 52 36 FF 2B
 ldd.s (hl), a                  ; 52 77 2B
 ldd.s (hl), b                  ; 52 70 2B
 ldd.s (hl), c                  ; 52 71 2B
 ldd.s (hl), d                  ; 52 72 2B
 ldd.s (hl), e                  ; 52 73 2B
 ldd.s (hl), h                  ; 52 74 2B
 ldd.s (hl), l                  ; 52 75 2B
 ldd.s a, (bc)                  ; 52 0A 0B
 ldd.s a, (de)                  ; 52 1A 1B
 ldd.s a, (hl)                  ; 52 7E 2B
 ldd.s b, (hl)                  ; 52 46 2B
 ldd.s c, (hl)                  ; 52 4E 2B
 ldd.s d, (hl)                  ; 52 56 2B
 ldd.s e, (hl)                  ; 52 5E 2B
 ldd.s h, (hl)                  ; 52 66 2B
 ldd.s l, (hl)                  ; 52 6E 2B
 ldd.sil                        ; 52 ED A8
 ldd.sil (bc), a                ; 52 02 0B
 ldd.sil (de), a                ; 52 12 1B
 ldd.sil (hl), -128             ; 52 36 80 2B
 ldd.sil (hl), 127              ; 52 36 7F 2B
 ldd.sil (hl), 255              ; 52 36 FF 2B
 ldd.sil (hl), a                ; 52 77 2B
 ldd.sil (hl), b                ; 52 70 2B
 ldd.sil (hl), c                ; 52 71 2B
 ldd.sil (hl), d                ; 52 72 2B
 ldd.sil (hl), e                ; 52 73 2B
 ldd.sil (hl), h                ; 52 74 2B
 ldd.sil (hl), l                ; 52 75 2B
 ldd.sil a, (bc)                ; 52 0A 0B
 ldd.sil a, (de)                ; 52 1A 1B
 ldd.sil a, (hl)                ; 52 7E 2B
 ldd.sil b, (hl)                ; 52 46 2B
 ldd.sil c, (hl)                ; 52 4E 2B
 ldd.sil d, (hl)                ; 52 56 2B
 ldd.sil e, (hl)                ; 52 5E 2B
 ldd.sil h, (hl)                ; 52 66 2B
 ldd.sil l, (hl)                ; 52 6E 2B
 lddr                           ; ED B8
 lddr.s                         ; 52 ED B8
 lddr.sil                       ; 52 ED B8
 ldi                            ; ED A0
 ldi (bc), a                    ; 02 03
 ldi (de), -128                 ; EB 36 80 EB 13
 ldi (de), 127                  ; EB 36 7F EB 13
 ldi (de), 255                  ; EB 36 FF EB 13
 ldi (de), a                    ; 12 13
 ldi (de), b                    ; EB 70 EB 13
 ldi (de), c                    ; EB 71 EB 13
 ldi (de), d                    ; EB 74 EB 13
 ldi (de), e                    ; EB 75 EB 13
 ldi (de), h                    ; EB 72 EB 13
 ldi (de), l                    ; EB 73 EB 13
 ldi (hl), -128                 ; 36 80 23
 ldi (hl), 127                  ; 36 7F 23
 ldi (hl), 255                  ; 36 FF 23
 ldi (hl), a                    ; 77 23
 ldi (hl), b                    ; 70 23
 ldi (hl), bc                   ; ED 0F 23 23
 ldi (hl), c                    ; 71 23
 ldi (hl), d                    ; 72 23
 ldi (hl), de                   ; ED 1F 23 23
 ldi (hl), e                    ; 73 23
 ldi (hl), h                    ; 74 23
 ldi (hl), hl                   ; ED 2F 23 23
 ldi (hl), ix                   ; ED 3F 23 23
 ldi (hl), iy                   ; ED 3E 23 23
 ldi (hl), l                    ; 75 23
 ldi a, (bc)                    ; 0A 03
 ldi a, (de)                    ; 1A 13
 ldi a, (hl)                    ; 7E 23
 ldi b, (de)                    ; EB 46 EB 13
 ldi b, (hl)                    ; 46 23
 ldi bc, (hl)                   ; ED 07 23 23
 ldi c, (de)                    ; EB 4E EB 13
 ldi c, (hl)                    ; 4E 23
 ldi d, (de)                    ; EB 66 EB 13
 ldi d, (hl)                    ; 56 23
 ldi de, (hl)                   ; ED 17 23 23
 ldi e, (de)                    ; EB 6E EB 13
 ldi e, (hl)                    ; 5E 23
 ldi h, (de)                    ; EB 56 EB 13
 ldi h, (hl)                    ; 66 23
 ldi hl, (hl)                   ; ED 27 23 23
 ldi ix, (hl)                   ; ED 37 23 23
 ldi iy, (hl)                   ; ED 31 23 23
 ldi l, (de)                    ; EB 5E EB 13
 ldi l, (hl)                    ; 6E 23
 ldi.s                          ; 52 ED A0
 ldi.s (bc), a                  ; 52 02 03
 ldi.s (de), a                  ; 52 12 13
 ldi.s (hl), -128               ; 52 36 80 23
 ldi.s (hl), 127                ; 52 36 7F 23
 ldi.s (hl), 255                ; 52 36 FF 23
 ldi.s (hl), a                  ; 52 77 23
 ldi.s (hl), b                  ; 52 70 23
 ldi.s (hl), bc                 ; 52 ED 0F 23 23
 ldi.s (hl), c                  ; 52 71 23
 ldi.s (hl), d                  ; 52 72 23
 ldi.s (hl), de                 ; 52 ED 1F 23 23
 ldi.s (hl), e                  ; 52 73 23
 ldi.s (hl), h                  ; 52 74 23
 ldi.s (hl), hl                 ; 52 ED 2F 23 23
 ldi.s (hl), ix                 ; 52 ED 3F 23 23
 ldi.s (hl), iy                 ; 52 ED 3E 23 23
 ldi.s (hl), l                  ; 52 75 23
 ldi.s a, (bc)                  ; 52 0A 03
 ldi.s a, (de)                  ; 52 1A 13
 ldi.s a, (hl)                  ; 52 7E 23
 ldi.s b, (hl)                  ; 52 46 23
 ldi.s bc, (hl)                 ; 52 ED 07 23 23
 ldi.s c, (hl)                  ; 52 4E 23
 ldi.s d, (hl)                  ; 52 56 23
 ldi.s de, (hl)                 ; 52 ED 17 23 23
 ldi.s e, (hl)                  ; 52 5E 23
 ldi.s h, (hl)                  ; 52 66 23
 ldi.s hl, (hl)                 ; 52 ED 27 23 23
 ldi.s ix, (hl)                 ; 52 ED 37 23 23
 ldi.s iy, (hl)                 ; 52 ED 31 23 23
 ldi.s l, (hl)                  ; 52 6E 23
 ldi.sil                        ; 52 ED A0
 ldi.sil (bc), a                ; 52 02 03
 ldi.sil (de), a                ; 52 12 13
 ldi.sil (hl), -128             ; 52 36 80 23
 ldi.sil (hl), 127              ; 52 36 7F 23
 ldi.sil (hl), 255              ; 52 36 FF 23
 ldi.sil (hl), a                ; 52 77 23
 ldi.sil (hl), b                ; 52 70 23
 ldi.sil (hl), bc               ; 52 ED 0F 23 23
 ldi.sil (hl), c                ; 52 71 23
 ldi.sil (hl), d                ; 52 72 23
 ldi.sil (hl), de               ; 52 ED 1F 23 23
 ldi.sil (hl), e                ; 52 73 23
 ldi.sil (hl), h                ; 52 74 23
 ldi.sil (hl), hl               ; 52 ED 2F 23 23
 ldi.sil (hl), ix               ; 52 ED 3F 23 23
 ldi.sil (hl), iy               ; 52 ED 3E 23 23
 ldi.sil (hl), l                ; 52 75 23
 ldi.sil a, (bc)                ; 52 0A 03
 ldi.sil a, (de)                ; 52 1A 13
 ldi.sil a, (hl)                ; 52 7E 23
 ldi.sil b, (hl)                ; 52 46 23
 ldi.sil bc, (hl)               ; 52 ED 07 23 23
 ldi.sil c, (hl)                ; 52 4E 23
 ldi.sil d, (hl)                ; 52 56 23
 ldi.sil de, (hl)               ; 52 ED 17 23 23
 ldi.sil e, (hl)                ; 52 5E 23
 ldi.sil h, (hl)                ; 52 66 23
 ldi.sil hl, (hl)               ; 52 ED 27 23 23
 ldi.sil ix, (hl)               ; 52 ED 37 23 23
 ldi.sil iy, (hl)               ; 52 ED 31 23 23
 ldi.sil l, (hl)                ; 52 6E 23
 ldir                           ; ED B0
 ldir.s                         ; 52 ED B0
 ldir.sil                       ; 52 ED B0
 lea bc, ix                     ; ED 02 00
 lea bc, ix+126                 ; ED 02 7E
 lea bc, ix-128                 ; ED 02 80
 lea bc, iy                     ; ED 03 00
 lea bc, iy+126                 ; ED 03 7E
 lea bc, iy-128                 ; ED 03 80
 lea de, ix                     ; ED 12 00
 lea de, ix+126                 ; ED 12 7E
 lea de, ix-128                 ; ED 12 80
 lea de, iy                     ; ED 13 00
 lea de, iy+126                 ; ED 13 7E
 lea de, iy-128                 ; ED 13 80
 lea hl, ix                     ; ED 22 00
 lea hl, ix+126                 ; ED 22 7E
 lea hl, ix-128                 ; ED 22 80
 lea hl, iy                     ; ED 23 00
 lea hl, iy+126                 ; ED 23 7E
 lea hl, iy-128                 ; ED 23 80
 lea ix, ix                     ; ED 32 00
 lea ix, ix+126                 ; ED 32 7E
 lea ix, ix-128                 ; ED 32 80
 lea ix, iy                     ; ED 54 00
 lea ix, iy+126                 ; ED 54 7E
 lea ix, iy-128                 ; ED 54 80
 lea iy, ix                     ; ED 55 00
 lea iy, ix+126                 ; ED 55 7E
 lea iy, ix-128                 ; ED 55 80
 lea iy, iy                     ; ED 33 00
 lea iy, iy+126                 ; ED 33 7E
 lea iy, iy-128                 ; ED 33 80
 lea.s bc, ix                   ; 52 ED 02 00
 lea.s bc, ix+126               ; 52 ED 02 7E
 lea.s bc, ix-128               ; 52 ED 02 80
 lea.s bc, iy                   ; 52 ED 03 00
 lea.s bc, iy+126               ; 52 ED 03 7E
 lea.s bc, iy-128               ; 52 ED 03 80
 lea.s de, ix                   ; 52 ED 12 00
 lea.s de, ix+126               ; 52 ED 12 7E
 lea.s de, ix-128               ; 52 ED 12 80
 lea.s de, iy                   ; 52 ED 13 00
 lea.s de, iy+126               ; 52 ED 13 7E
 lea.s de, iy-128               ; 52 ED 13 80
 lea.s hl, ix                   ; 52 ED 22 00
 lea.s hl, ix+126               ; 52 ED 22 7E
 lea.s hl, ix-128               ; 52 ED 22 80
 lea.s hl, iy                   ; 52 ED 23 00
 lea.s hl, iy+126               ; 52 ED 23 7E
 lea.s hl, iy-128               ; 52 ED 23 80
 lea.s ix, ix                   ; 52 ED 32 00
 lea.s ix, ix+126               ; 52 ED 32 7E
 lea.s ix, ix-128               ; 52 ED 32 80
 lea.s ix, iy                   ; 52 ED 54 00
 lea.s ix, iy+126               ; 52 ED 54 7E
 lea.s ix, iy-128               ; 52 ED 54 80
 lea.s iy, ix                   ; 52 ED 55 00
 lea.s iy, ix+126               ; 52 ED 55 7E
 lea.s iy, ix-128               ; 52 ED 55 80
 lea.s iy, iy                   ; 52 ED 33 00
 lea.s iy, iy+126               ; 52 ED 33 7E
 lea.s iy, iy-128               ; 52 ED 33 80
 lea.sil bc, ix                 ; 52 ED 02 00
 lea.sil bc, ix+126             ; 52 ED 02 7E
 lea.sil bc, ix-128             ; 52 ED 02 80
 lea.sil bc, iy                 ; 52 ED 03 00
 lea.sil bc, iy+126             ; 52 ED 03 7E
 lea.sil bc, iy-128             ; 52 ED 03 80
 lea.sil de, ix                 ; 52 ED 12 00
 lea.sil de, ix+126             ; 52 ED 12 7E
 lea.sil de, ix-128             ; 52 ED 12 80
 lea.sil de, iy                 ; 52 ED 13 00
 lea.sil de, iy+126             ; 52 ED 13 7E
 lea.sil de, iy-128             ; 52 ED 13 80
 lea.sil hl, ix                 ; 52 ED 22 00
 lea.sil hl, ix+126             ; 52 ED 22 7E
 lea.sil hl, ix-128             ; 52 ED 22 80
 lea.sil hl, iy                 ; 52 ED 23 00
 lea.sil hl, iy+126             ; 52 ED 23 7E
 lea.sil hl, iy-128             ; 52 ED 23 80
 lea.sil ix, ix                 ; 52 ED 32 00
 lea.sil ix, ix+126             ; 52 ED 32 7E
 lea.sil ix, ix-128             ; 52 ED 32 80
 lea.sil ix, iy                 ; 52 ED 54 00
 lea.sil ix, iy+126             ; 52 ED 54 7E
 lea.sil ix, iy-128             ; 52 ED 54 80
 lea.sil iy, ix                 ; 52 ED 55 00
 lea.sil iy, ix+126             ; 52 ED 55 7E
 lea.sil iy, ix-128             ; 52 ED 55 80
 lea.sil iy, iy                 ; 52 ED 33 00
 lea.sil iy, iy+126             ; 52 ED 33 7E
 lea.sil iy, iy-128             ; 52 ED 33 80
 lhld -32768                    ; 2A 00 80
 lhld 0x123456                  ; 2A 56 34
 lhld 32767                     ; 2A FF 7F
 lhld 65535                     ; 2A FF FF
 lxi b, -32768                  ; 01 00 80
 lxi b, 0x123456                ; 01 56 34
 lxi b, 32767                   ; 01 FF 7F
 lxi b, 65535                   ; 01 FF FF
 lxi bc, -32768                 ; 01 00 80
 lxi bc, 0x123456               ; 01 56 34
 lxi bc, 32767                  ; 01 FF 7F
 lxi bc, 65535                  ; 01 FF FF
 lxi d, -32768                  ; 11 00 80
 lxi d, 0x123456                ; 11 56 34
 lxi d, 32767                   ; 11 FF 7F
 lxi d, 65535                   ; 11 FF FF
 lxi de, -32768                 ; 11 00 80
 lxi de, 0x123456               ; 11 56 34
 lxi de, 32767                  ; 11 FF 7F
 lxi de, 65535                  ; 11 FF FF
 lxi h, -32768                  ; 21 00 80
 lxi h, 0x123456                ; 21 56 34
 lxi h, 32767                   ; 21 FF 7F
 lxi h, 65535                   ; 21 FF FF
 lxi hl, -32768                 ; 21 00 80
 lxi hl, 0x123456               ; 21 56 34
 lxi hl, 32767                  ; 21 FF 7F
 lxi hl, 65535                  ; 21 FF FF
 lxi sp, -32768                 ; 31 00 80
 lxi sp, 0x123456               ; 31 56 34
 lxi sp, 32767                  ; 31 FF 7F
 lxi sp, 65535                  ; 31 FF FF
 mlt bc                         ; ED 4C
 mlt de                         ; ED 5C
 mlt hl                         ; ED 6C
 mlt sp                         ; ED 7C
 mlt.s sp                       ; 52 ED 7C
 mlt.sil sp                     ; 52 ED 7C
 mov a, a                       ; 7F
 mov a, b                       ; 78
 mov a, c                       ; 79
 mov a, d                       ; 7A
 mov a, e                       ; 7B
 mov a, h                       ; 7C
 mov a, l                       ; 7D
 mov a, m                       ; 7E
 mov b, a                       ; 47
 mov b, c                       ; 41
 mov b, d                       ; 42
 mov b, e                       ; 43
 mov b, h                       ; 44
 mov b, l                       ; 45
 mov b, m                       ; 46
 mov c, a                       ; 4F
 mov c, b                       ; 48
 mov c, d                       ; 4A
 mov c, e                       ; 4B
 mov c, h                       ; 4C
 mov c, l                       ; 4D
 mov c, m                       ; 4E
 mov d, a                       ; 57
 mov d, b                       ; 50
 mov d, c                       ; 51
 mov d, e                       ; 53
 mov d, h                       ; 54
 mov d, l                       ; 55
 mov d, m                       ; 56
 mov e, a                       ; 5F
 mov e, b                       ; 58
 mov e, c                       ; 59
 mov e, d                       ; 5A
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
 neg                            ; ED 44
 neg a                          ; ED 44
 nop                            ; 00
 or (hl)                        ; B6
 or (hl+)                       ; B6 23
 or (hl-)                       ; B6 2B
 or (ix)                        ; DD B6 00
 or (ix+126)                    ; DD B6 7E
 or (ix-128)                    ; DD B6 80
 or (iy)                        ; FD B6 00
 or (iy+126)                    ; FD B6 7E
 or (iy-128)                    ; FD B6 80
 or -128                        ; F6 80
 or 127                         ; F6 7F
 or 255                         ; F6 FF
 or a                           ; B7
 or a, (hl)                     ; B6
 or a, (hl+)                    ; B6 23
 or a, (hl-)                    ; B6 2B
 or a, (ix)                     ; DD B6 00
 or a, (ix+126)                 ; DD B6 7E
 or a, (ix-128)                 ; DD B6 80
 or a, (iy)                     ; FD B6 00
 or a, (iy+126)                 ; FD B6 7E
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
 or.s (hl)                      ; 52 B6
 or.s (hl+)                     ; 52 B6 23
 or.s (hl-)                     ; 52 B6 2B
 or.s (ix)                      ; 52 DD B6 00
 or.s (ix+126)                  ; 52 DD B6 7E
 or.s (ix-128)                  ; 52 DD B6 80
 or.s (iy)                      ; 52 FD B6 00
 or.s (iy+126)                  ; 52 FD B6 7E
 or.s (iy-128)                  ; 52 FD B6 80
 or.s a, (hl)                   ; 52 B6
 or.s a, (hl+)                  ; 52 B6 23
 or.s a, (hl-)                  ; 52 B6 2B
 or.s a, (ix)                   ; 52 DD B6 00
 or.s a, (ix+126)               ; 52 DD B6 7E
 or.s a, (ix-128)               ; 52 DD B6 80
 or.s a, (iy)                   ; 52 FD B6 00
 or.s a, (iy+126)               ; 52 FD B6 7E
 or.s a, (iy-128)               ; 52 FD B6 80
 or.sil (hl)                    ; 52 B6
 or.sil (hl+)                   ; 52 B6 23
 or.sil (hl-)                   ; 52 B6 2B
 or.sil (ix)                    ; 52 DD B6 00
 or.sil (ix+126)                ; 52 DD B6 7E
 or.sil (ix-128)                ; 52 DD B6 80
 or.sil (iy)                    ; 52 FD B6 00
 or.sil (iy+126)                ; 52 FD B6 7E
 or.sil (iy-128)                ; 52 FD B6 80
 or.sil a, (hl)                 ; 52 B6
 or.sil a, (hl+)                ; 52 B6 23
 or.sil a, (hl-)                ; 52 B6 2B
 or.sil a, (ix)                 ; 52 DD B6 00
 or.sil a, (ix+126)             ; 52 DD B6 7E
 or.sil a, (ix-128)             ; 52 DD B6 80
 or.sil a, (iy)                 ; 52 FD B6 00
 or.sil a, (iy+126)             ; 52 FD B6 7E
 or.sil a, (iy-128)             ; 52 FD B6 80
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
 otd2r                          ; ED BC
 otd2r.s                        ; 52 ED BC
 otd2r.sil                      ; 52 ED BC
 otdm                           ; ED 8B
 otdm.s                         ; 52 ED 8B
 otdm.sil                       ; 52 ED 8B
 otdmr                          ; ED 9B
 otdmr.s                        ; 52 ED 9B
 otdmr.sil                      ; 52 ED 9B
 otdr                           ; ED BB
 otdr.s                         ; 52 ED BB
 otdr.sil                       ; 52 ED BB
 otdrx                          ; ED CB
 otdrx.s                        ; 52 ED CB
 otdrx.sil                      ; 52 ED CB
 oti2r                          ; ED B4
 oti2r.s                        ; 52 ED B4
 oti2r.sil                      ; 52 ED B4
 otim                           ; ED 83
 otim.s                         ; 52 ED 83
 otim.sil                       ; 52 ED 83
 otimr                          ; ED 93
 otimr.s                        ; 52 ED 93
 otimr.sil                      ; 52 ED 93
 otir                           ; ED B3
 otir.s                         ; 52 ED B3
 otir.sil                       ; 52 ED B3
 otirx                          ; ED C3
 otirx.s                        ; 52 ED C3
 otirx.sil                      ; 52 ED C3
 out (-128), a                  ; D3 80
 out (127), a                   ; D3 7F
 out (255), a                   ; D3 FF
 out (bc), 0                    ; ED 71
 out (bc), a                    ; ED 79
 out (bc), b                    ; ED 41
 out (bc), c                    ; ED 49
 out (bc), d                    ; ED 51
 out (bc), e                    ; ED 59
 out (bc), h                    ; ED 61
 out (bc), l                    ; ED 69
 out (c), 0                     ; ED 71
 out (c), a                     ; ED 79
 out (c), b                     ; ED 41
 out (c), c                     ; ED 49
 out (c), d                     ; ED 51
 out (c), e                     ; ED 59
 out (c), h                     ; ED 61
 out (c), l                     ; ED 69
 out -128                       ; D3 80
 out 127                        ; D3 7F
 out 255                        ; D3 FF
 out0 (-128), a                 ; ED 39 80
 out0 (-128), b                 ; ED 01 80
 out0 (-128), c                 ; ED 09 80
 out0 (-128), d                 ; ED 11 80
 out0 (-128), e                 ; ED 19 80
 out0 (-128), h                 ; ED 21 80
 out0 (-128), l                 ; ED 29 80
 out0 (127), a                  ; ED 39 7F
 out0 (127), b                  ; ED 01 7F
 out0 (127), c                  ; ED 09 7F
 out0 (127), d                  ; ED 11 7F
 out0 (127), e                  ; ED 19 7F
 out0 (127), h                  ; ED 21 7F
 out0 (127), l                  ; ED 29 7F
 out0 (255), a                  ; ED 39 FF
 out0 (255), b                  ; ED 01 FF
 out0 (255), c                  ; ED 09 FF
 out0 (255), d                  ; ED 11 FF
 out0 (255), e                  ; ED 19 FF
 out0 (255), h                  ; ED 21 FF
 out0 (255), l                  ; ED 29 FF
 outd                           ; ED AB
 outd.s                         ; 52 ED AB
 outd.sil                       ; 52 ED AB
 outd2                          ; ED AC
 outd2.s                        ; 52 ED AC
 outd2.sil                      ; 52 ED AC
 outi                           ; ED A3
 outi.s                         ; 52 ED A3
 outi.sil                       ; 52 ED A3
 outi2                          ; ED A4
 outi2.s                        ; 52 ED A4
 outi2.sil                      ; 52 ED A4
 pchl                           ; E9
 pea ix                         ; ED 65 00
 pea ix+126                     ; ED 65 7E
 pea ix-128                     ; ED 65 80
 pea iy                         ; ED 66 00
 pea iy+126                     ; ED 66 7E
 pea iy-128                     ; ED 66 80
 pea.s ix                       ; 52 ED 65 00
 pea.s ix+126                   ; 52 ED 65 7E
 pea.s ix-128                   ; 52 ED 65 80
 pea.s iy                       ; 52 ED 66 00
 pea.s iy+126                   ; 52 ED 66 7E
 pea.s iy-128                   ; 52 ED 66 80
 pea.sil ix                     ; 52 ED 65 00
 pea.sil ix+126                 ; 52 ED 65 7E
 pea.sil ix-128                 ; 52 ED 65 80
 pea.sil iy                     ; 52 ED 66 00
 pea.sil iy+126                 ; 52 ED 66 7E
 pea.sil iy-128                 ; 52 ED 66 80
 pop af                         ; F1
 pop b                          ; C1
 pop bc                         ; C1
 pop d                          ; D1
 pop de                         ; D1
 pop h                          ; E1
 pop hl                         ; E1
 pop ix                         ; DD E1
 pop iy                         ; FD E1
 pop psw                        ; F1
 pop.s af                       ; 52 F1
 pop.s bc                       ; 52 C1
 pop.s de                       ; 52 D1
 pop.s hl                       ; 52 E1
 pop.s ix                       ; 52 DD E1
 pop.s iy                       ; 52 FD E1
 pop.sil af                     ; 52 F1
 pop.sil bc                     ; 52 C1
 pop.sil de                     ; 52 D1
 pop.sil hl                     ; 52 E1
 pop.sil ix                     ; 52 DD E1
 pop.sil iy                     ; 52 FD E1
 push af                        ; F5
 push b                         ; C5
 push bc                        ; C5
 push d                         ; D5
 push de                        ; D5
 push h                         ; E5
 push hl                        ; E5
 push ix                        ; DD E5
 push iy                        ; FD E5
 push psw                       ; F5
 push.s af                      ; 52 F5
 push.s bc                      ; 52 C5
 push.s de                      ; 52 D5
 push.s hl                      ; 52 E5
 push.s ix                      ; 52 DD E5
 push.s iy                      ; 52 FD E5
 push.sil af                    ; 52 F5
 push.sil bc                    ; 52 C5
 push.sil de                    ; 52 D5
 push.sil hl                    ; 52 E5
 push.sil ix                    ; 52 DD E5
 push.sil iy                    ; 52 FD E5
 r_c                            ; D8
 r_m                            ; F8
 r_nc                           ; D0
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
 rdel                           ; CB 13 CB 12
 res 0, (hl)                    ; CB 86
 res 0, (ix)                    ; DD CB 00 86
 res 0, (ix+126)                ; DD CB 7E 86
 res 0, (ix-128)                ; DD CB 80 86
 res 0, (iy)                    ; FD CB 00 86
 res 0, (iy+126)                ; FD CB 7E 86
 res 0, (iy-128)                ; FD CB 80 86
 res 0, a                       ; CB 87
 res 0, b                       ; CB 80
 res 0, c                       ; CB 81
 res 0, d                       ; CB 82
 res 0, e                       ; CB 83
 res 0, h                       ; CB 84
 res 0, l                       ; CB 85
 res 1, (hl)                    ; CB 8E
 res 1, (ix)                    ; DD CB 00 8E
 res 1, (ix+126)                ; DD CB 7E 8E
 res 1, (ix-128)                ; DD CB 80 8E
 res 1, (iy)                    ; FD CB 00 8E
 res 1, (iy+126)                ; FD CB 7E 8E
 res 1, (iy-128)                ; FD CB 80 8E
 res 1, a                       ; CB 8F
 res 1, b                       ; CB 88
 res 1, c                       ; CB 89
 res 1, d                       ; CB 8A
 res 1, e                       ; CB 8B
 res 1, h                       ; CB 8C
 res 1, l                       ; CB 8D
 res 2, (hl)                    ; CB 96
 res 2, (ix)                    ; DD CB 00 96
 res 2, (ix+126)                ; DD CB 7E 96
 res 2, (ix-128)                ; DD CB 80 96
 res 2, (iy)                    ; FD CB 00 96
 res 2, (iy+126)                ; FD CB 7E 96
 res 2, (iy-128)                ; FD CB 80 96
 res 2, a                       ; CB 97
 res 2, b                       ; CB 90
 res 2, c                       ; CB 91
 res 2, d                       ; CB 92
 res 2, e                       ; CB 93
 res 2, h                       ; CB 94
 res 2, l                       ; CB 95
 res 3, (hl)                    ; CB 9E
 res 3, (ix)                    ; DD CB 00 9E
 res 3, (ix+126)                ; DD CB 7E 9E
 res 3, (ix-128)                ; DD CB 80 9E
 res 3, (iy)                    ; FD CB 00 9E
 res 3, (iy+126)                ; FD CB 7E 9E
 res 3, (iy-128)                ; FD CB 80 9E
 res 3, a                       ; CB 9F
 res 3, b                       ; CB 98
 res 3, c                       ; CB 99
 res 3, d                       ; CB 9A
 res 3, e                       ; CB 9B
 res 3, h                       ; CB 9C
 res 3, l                       ; CB 9D
 res 4, (hl)                    ; CB A6
 res 4, (ix)                    ; DD CB 00 A6
 res 4, (ix+126)                ; DD CB 7E A6
 res 4, (ix-128)                ; DD CB 80 A6
 res 4, (iy)                    ; FD CB 00 A6
 res 4, (iy+126)                ; FD CB 7E A6
 res 4, (iy-128)                ; FD CB 80 A6
 res 4, a                       ; CB A7
 res 4, b                       ; CB A0
 res 4, c                       ; CB A1
 res 4, d                       ; CB A2
 res 4, e                       ; CB A3
 res 4, h                       ; CB A4
 res 4, l                       ; CB A5
 res 5, (hl)                    ; CB AE
 res 5, (ix)                    ; DD CB 00 AE
 res 5, (ix+126)                ; DD CB 7E AE
 res 5, (ix-128)                ; DD CB 80 AE
 res 5, (iy)                    ; FD CB 00 AE
 res 5, (iy+126)                ; FD CB 7E AE
 res 5, (iy-128)                ; FD CB 80 AE
 res 5, a                       ; CB AF
 res 5, b                       ; CB A8
 res 5, c                       ; CB A9
 res 5, d                       ; CB AA
 res 5, e                       ; CB AB
 res 5, h                       ; CB AC
 res 5, l                       ; CB AD
 res 6, (hl)                    ; CB B6
 res 6, (ix)                    ; DD CB 00 B6
 res 6, (ix+126)                ; DD CB 7E B6
 res 6, (ix-128)                ; DD CB 80 B6
 res 6, (iy)                    ; FD CB 00 B6
 res 6, (iy+126)                ; FD CB 7E B6
 res 6, (iy-128)                ; FD CB 80 B6
 res 6, a                       ; CB B7
 res 6, b                       ; CB B0
 res 6, c                       ; CB B1
 res 6, d                       ; CB B2
 res 6, e                       ; CB B3
 res 6, h                       ; CB B4
 res 6, l                       ; CB B5
 res 7, (hl)                    ; CB BE
 res 7, (ix)                    ; DD CB 00 BE
 res 7, (ix+126)                ; DD CB 7E BE
 res 7, (ix-128)                ; DD CB 80 BE
 res 7, (iy)                    ; FD CB 00 BE
 res 7, (iy+126)                ; FD CB 7E BE
 res 7, (iy-128)                ; FD CB 80 BE
 res 7, a                       ; CB BF
 res 7, b                       ; CB B8
 res 7, c                       ; CB B9
 res 7, d                       ; CB BA
 res 7, e                       ; CB BB
 res 7, h                       ; CB BC
 res 7, l                       ; CB BD
 res.s 0, (hl)                  ; 52 CB 86
 res.s 0, (ix)                  ; 52 DD CB 00 86
 res.s 0, (ix+126)              ; 52 DD CB 7E 86
 res.s 0, (ix-128)              ; 52 DD CB 80 86
 res.s 0, (iy)                  ; 52 FD CB 00 86
 res.s 0, (iy+126)              ; 52 FD CB 7E 86
 res.s 0, (iy-128)              ; 52 FD CB 80 86
 res.s 1, (hl)                  ; 52 CB 8E
 res.s 1, (ix)                  ; 52 DD CB 00 8E
 res.s 1, (ix+126)              ; 52 DD CB 7E 8E
 res.s 1, (ix-128)              ; 52 DD CB 80 8E
 res.s 1, (iy)                  ; 52 FD CB 00 8E
 res.s 1, (iy+126)              ; 52 FD CB 7E 8E
 res.s 1, (iy-128)              ; 52 FD CB 80 8E
 res.s 2, (hl)                  ; 52 CB 96
 res.s 2, (ix)                  ; 52 DD CB 00 96
 res.s 2, (ix+126)              ; 52 DD CB 7E 96
 res.s 2, (ix-128)              ; 52 DD CB 80 96
 res.s 2, (iy)                  ; 52 FD CB 00 96
 res.s 2, (iy+126)              ; 52 FD CB 7E 96
 res.s 2, (iy-128)              ; 52 FD CB 80 96
 res.s 3, (hl)                  ; 52 CB 9E
 res.s 3, (ix)                  ; 52 DD CB 00 9E
 res.s 3, (ix+126)              ; 52 DD CB 7E 9E
 res.s 3, (ix-128)              ; 52 DD CB 80 9E
 res.s 3, (iy)                  ; 52 FD CB 00 9E
 res.s 3, (iy+126)              ; 52 FD CB 7E 9E
 res.s 3, (iy-128)              ; 52 FD CB 80 9E
 res.s 4, (hl)                  ; 52 CB A6
 res.s 4, (ix)                  ; 52 DD CB 00 A6
 res.s 4, (ix+126)              ; 52 DD CB 7E A6
 res.s 4, (ix-128)              ; 52 DD CB 80 A6
 res.s 4, (iy)                  ; 52 FD CB 00 A6
 res.s 4, (iy+126)              ; 52 FD CB 7E A6
 res.s 4, (iy-128)              ; 52 FD CB 80 A6
 res.s 5, (hl)                  ; 52 CB AE
 res.s 5, (ix)                  ; 52 DD CB 00 AE
 res.s 5, (ix+126)              ; 52 DD CB 7E AE
 res.s 5, (ix-128)              ; 52 DD CB 80 AE
 res.s 5, (iy)                  ; 52 FD CB 00 AE
 res.s 5, (iy+126)              ; 52 FD CB 7E AE
 res.s 5, (iy-128)              ; 52 FD CB 80 AE
 res.s 6, (hl)                  ; 52 CB B6
 res.s 6, (ix)                  ; 52 DD CB 00 B6
 res.s 6, (ix+126)              ; 52 DD CB 7E B6
 res.s 6, (ix-128)              ; 52 DD CB 80 B6
 res.s 6, (iy)                  ; 52 FD CB 00 B6
 res.s 6, (iy+126)              ; 52 FD CB 7E B6
 res.s 6, (iy-128)              ; 52 FD CB 80 B6
 res.s 7, (hl)                  ; 52 CB BE
 res.s 7, (ix)                  ; 52 DD CB 00 BE
 res.s 7, (ix+126)              ; 52 DD CB 7E BE
 res.s 7, (ix-128)              ; 52 DD CB 80 BE
 res.s 7, (iy)                  ; 52 FD CB 00 BE
 res.s 7, (iy+126)              ; 52 FD CB 7E BE
 res.s 7, (iy-128)              ; 52 FD CB 80 BE
 res.sil 0, (hl)                ; 52 CB 86
 res.sil 0, (ix)                ; 52 DD CB 00 86
 res.sil 0, (ix+126)            ; 52 DD CB 7E 86
 res.sil 0, (ix-128)            ; 52 DD CB 80 86
 res.sil 0, (iy)                ; 52 FD CB 00 86
 res.sil 0, (iy+126)            ; 52 FD CB 7E 86
 res.sil 0, (iy-128)            ; 52 FD CB 80 86
 res.sil 1, (hl)                ; 52 CB 8E
 res.sil 1, (ix)                ; 52 DD CB 00 8E
 res.sil 1, (ix+126)            ; 52 DD CB 7E 8E
 res.sil 1, (ix-128)            ; 52 DD CB 80 8E
 res.sil 1, (iy)                ; 52 FD CB 00 8E
 res.sil 1, (iy+126)            ; 52 FD CB 7E 8E
 res.sil 1, (iy-128)            ; 52 FD CB 80 8E
 res.sil 2, (hl)                ; 52 CB 96
 res.sil 2, (ix)                ; 52 DD CB 00 96
 res.sil 2, (ix+126)            ; 52 DD CB 7E 96
 res.sil 2, (ix-128)            ; 52 DD CB 80 96
 res.sil 2, (iy)                ; 52 FD CB 00 96
 res.sil 2, (iy+126)            ; 52 FD CB 7E 96
 res.sil 2, (iy-128)            ; 52 FD CB 80 96
 res.sil 3, (hl)                ; 52 CB 9E
 res.sil 3, (ix)                ; 52 DD CB 00 9E
 res.sil 3, (ix+126)            ; 52 DD CB 7E 9E
 res.sil 3, (ix-128)            ; 52 DD CB 80 9E
 res.sil 3, (iy)                ; 52 FD CB 00 9E
 res.sil 3, (iy+126)            ; 52 FD CB 7E 9E
 res.sil 3, (iy-128)            ; 52 FD CB 80 9E
 res.sil 4, (hl)                ; 52 CB A6
 res.sil 4, (ix)                ; 52 DD CB 00 A6
 res.sil 4, (ix+126)            ; 52 DD CB 7E A6
 res.sil 4, (ix-128)            ; 52 DD CB 80 A6
 res.sil 4, (iy)                ; 52 FD CB 00 A6
 res.sil 4, (iy+126)            ; 52 FD CB 7E A6
 res.sil 4, (iy-128)            ; 52 FD CB 80 A6
 res.sil 5, (hl)                ; 52 CB AE
 res.sil 5, (ix)                ; 52 DD CB 00 AE
 res.sil 5, (ix+126)            ; 52 DD CB 7E AE
 res.sil 5, (ix-128)            ; 52 DD CB 80 AE
 res.sil 5, (iy)                ; 52 FD CB 00 AE
 res.sil 5, (iy+126)            ; 52 FD CB 7E AE
 res.sil 5, (iy-128)            ; 52 FD CB 80 AE
 res.sil 6, (hl)                ; 52 CB B6
 res.sil 6, (ix)                ; 52 DD CB 00 B6
 res.sil 6, (ix+126)            ; 52 DD CB 7E B6
 res.sil 6, (ix-128)            ; 52 DD CB 80 B6
 res.sil 6, (iy)                ; 52 FD CB 00 B6
 res.sil 6, (iy+126)            ; 52 FD CB 7E B6
 res.sil 6, (iy-128)            ; 52 FD CB 80 B6
 res.sil 7, (hl)                ; 52 CB BE
 res.sil 7, (ix)                ; 52 DD CB 00 BE
 res.sil 7, (ix+126)            ; 52 DD CB 7E BE
 res.sil 7, (ix-128)            ; 52 DD CB 80 BE
 res.sil 7, (iy)                ; 52 FD CB 00 BE
 res.sil 7, (iy+126)            ; 52 FD CB 7E BE
 res.sil 7, (iy-128)            ; 52 FD CB 80 BE
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
 ret.l                          ; 5B C9
 ret.l c                        ; 5B D8
 ret.l m                        ; 5B F8
 ret.l nc                       ; 5B D0
 ret.l nv                       ; 5B E0
 ret.l nz                       ; 5B C0
 ret.l p                        ; 5B F0
 ret.l pe                       ; 5B E8
 ret.l po                       ; 5B E0
 ret.l v                        ; 5B E8
 ret.l z                        ; 5B C8
 reti                           ; ED 4D
 reti.l                         ; 5B ED 4D
 retn                           ; ED 45
 retn.l                         ; 5B ED 45
 rl (hl)                        ; CB 16
 rl (ix)                        ; DD CB 00 16
 rl (ix+126)                    ; DD CB 7E 16
 rl (ix-128)                    ; DD CB 80 16
 rl (iy)                        ; FD CB 00 16
 rl (iy+126)                    ; FD CB 7E 16
 rl (iy-128)                    ; FD CB 80 16
 rl a                           ; CB 17
 rl b                           ; CB 10
 rl bc                          ; CB 11 CB 10
 rl c                           ; CB 11
 rl d                           ; CB 12
 rl de                          ; CB 13 CB 12
 rl e                           ; CB 13
 rl h                           ; CB 14
 rl hl                          ; CB 15 CB 14
 rl l                           ; CB 15
 rl.s (hl)                      ; 52 CB 16
 rl.s (ix)                      ; 52 DD CB 00 16
 rl.s (ix+126)                  ; 52 DD CB 7E 16
 rl.s (ix-128)                  ; 52 DD CB 80 16
 rl.s (iy)                      ; 52 FD CB 00 16
 rl.s (iy+126)                  ; 52 FD CB 7E 16
 rl.s (iy-128)                  ; 52 FD CB 80 16
 rl.sil (hl)                    ; 52 CB 16
 rl.sil (ix)                    ; 52 DD CB 00 16
 rl.sil (ix+126)                ; 52 DD CB 7E 16
 rl.sil (ix-128)                ; 52 DD CB 80 16
 rl.sil (iy)                    ; 52 FD CB 00 16
 rl.sil (iy+126)                ; 52 FD CB 7E 16
 rl.sil (iy-128)                ; 52 FD CB 80 16
 rla                            ; 17
 rlc                            ; 07
 rlc (hl)                       ; CB 06
 rlc (ix)                       ; DD CB 00 06
 rlc (ix+126)                   ; DD CB 7E 06
 rlc (ix-128)                   ; DD CB 80 06
 rlc (iy)                       ; FD CB 00 06
 rlc (iy+126)                   ; FD CB 7E 06
 rlc (iy-128)                   ; FD CB 80 06
 rlc a                          ; CB 07
 rlc b                          ; CB 00
 rlc c                          ; CB 01
 rlc d                          ; CB 02
 rlc e                          ; CB 03
 rlc h                          ; CB 04
 rlc l                          ; CB 05
 rlc.s (hl)                     ; 52 CB 06
 rlc.s (ix)                     ; 52 DD CB 00 06
 rlc.s (ix+126)                 ; 52 DD CB 7E 06
 rlc.s (ix-128)                 ; 52 DD CB 80 06
 rlc.s (iy)                     ; 52 FD CB 00 06
 rlc.s (iy+126)                 ; 52 FD CB 7E 06
 rlc.s (iy-128)                 ; 52 FD CB 80 06
 rlc.sil (hl)                   ; 52 CB 06
 rlc.sil (ix)                   ; 52 DD CB 00 06
 rlc.sil (ix+126)               ; 52 DD CB 7E 06
 rlc.sil (ix-128)               ; 52 DD CB 80 06
 rlc.sil (iy)                   ; 52 FD CB 00 06
 rlc.sil (iy+126)               ; 52 FD CB 7E 06
 rlc.sil (iy-128)               ; 52 FD CB 80 06
 rlca                           ; 07
 rld                            ; ED 6F
 rlde                           ; CB 13 CB 12
 rm                             ; F8
 rnc                            ; D0
 rnv                            ; E0
 rnz                            ; C0
 rp                             ; F0
 rpe                            ; E8
 rpo                            ; E0
 rr (hl)                        ; CB 1E
 rr (ix)                        ; DD CB 00 1E
 rr (ix+126)                    ; DD CB 7E 1E
 rr (ix-128)                    ; DD CB 80 1E
 rr (iy)                        ; FD CB 00 1E
 rr (iy+126)                    ; FD CB 7E 1E
 rr (iy-128)                    ; FD CB 80 1E
 rr a                           ; CB 1F
 rr b                           ; CB 18
 rr bc                          ; CB 18 CB 19
 rr c                           ; CB 19
 rr d                           ; CB 1A
 rr de                          ; CB 1A CB 1B
 rr e                           ; CB 1B
 rr h                           ; CB 1C
 rr hl                          ; CB 1C CB 1D
 rr l                           ; CB 1D
 rr.s (hl)                      ; 52 CB 1E
 rr.s (ix)                      ; 52 DD CB 00 1E
 rr.s (ix+126)                  ; 52 DD CB 7E 1E
 rr.s (ix-128)                  ; 52 DD CB 80 1E
 rr.s (iy)                      ; 52 FD CB 00 1E
 rr.s (iy+126)                  ; 52 FD CB 7E 1E
 rr.s (iy-128)                  ; 52 FD CB 80 1E
 rr.sil (hl)                    ; 52 CB 1E
 rr.sil (ix)                    ; 52 DD CB 00 1E
 rr.sil (ix+126)                ; 52 DD CB 7E 1E
 rr.sil (ix-128)                ; 52 DD CB 80 1E
 rr.sil (iy)                    ; 52 FD CB 00 1E
 rr.sil (iy+126)                ; 52 FD CB 7E 1E
 rr.sil (iy-128)                ; 52 FD CB 80 1E
 rra                            ; 1F
 rrc                            ; 0F
 rrc (hl)                       ; CB 0E
 rrc (ix)                       ; DD CB 00 0E
 rrc (ix+126)                   ; DD CB 7E 0E
 rrc (ix-128)                   ; DD CB 80 0E
 rrc (iy)                       ; FD CB 00 0E
 rrc (iy+126)                   ; FD CB 7E 0E
 rrc (iy-128)                   ; FD CB 80 0E
 rrc a                          ; CB 0F
 rrc b                          ; CB 08
 rrc c                          ; CB 09
 rrc d                          ; CB 0A
 rrc e                          ; CB 0B
 rrc h                          ; CB 0C
 rrc l                          ; CB 0D
 rrc.s (hl)                     ; 52 CB 0E
 rrc.s (ix)                     ; 52 DD CB 00 0E
 rrc.s (ix+126)                 ; 52 DD CB 7E 0E
 rrc.s (ix-128)                 ; 52 DD CB 80 0E
 rrc.s (iy)                     ; 52 FD CB 00 0E
 rrc.s (iy+126)                 ; 52 FD CB 7E 0E
 rrc.s (iy-128)                 ; 52 FD CB 80 0E
 rrc.sil (hl)                   ; 52 CB 0E
 rrc.sil (ix)                   ; 52 DD CB 00 0E
 rrc.sil (ix+126)               ; 52 DD CB 7E 0E
 rrc.sil (ix-128)               ; 52 DD CB 80 0E
 rrc.sil (iy)                   ; 52 FD CB 00 0E
 rrc.sil (iy+126)               ; 52 FD CB 7E 0E
 rrc.sil (iy-128)               ; 52 FD CB 80 0E
 rrca                           ; 0F
 rrd                            ; ED 67
 rrhl                           ; CB 2C CB 1D
 rsmix                          ; ED 7E
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
 rst.s 0                        ; 52 C7
 rst.s 1                        ; 52 CF
 rst.s 16                       ; 52 D7
 rst.s 2                        ; 52 D7
 rst.s 24                       ; 52 DF
 rst.s 3                        ; 52 DF
 rst.s 32                       ; 52 E7
 rst.s 4                        ; 52 E7
 rst.s 40                       ; 52 EF
 rst.s 48                       ; 52 F7
 rst.s 5                        ; 52 EF
 rst.s 56                       ; 52 FF
 rst.s 6                        ; 52 F7
 rst.s 7                        ; 52 FF
 rst.s 8                        ; 52 CF
 rst.sil 0                      ; 52 C7
 rst.sil 1                      ; 52 CF
 rst.sil 16                     ; 52 D7
 rst.sil 2                      ; 52 D7
 rst.sil 24                     ; 52 DF
 rst.sil 3                      ; 52 DF
 rst.sil 32                     ; 52 E7
 rst.sil 4                      ; 52 E7
 rst.sil 40                     ; 52 EF
 rst.sil 48                     ; 52 F7
 rst.sil 5                      ; 52 EF
 rst.sil 56                     ; 52 FF
 rst.sil 6                      ; 52 F7
 rst.sil 7                      ; 52 FF
 rst.sil 8                      ; 52 CF
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
 sbc (hl+)                      ; 9E 23
 sbc (hl-)                      ; 9E 2B
 sbc (ix)                       ; DD 9E 00
 sbc (ix+126)                   ; DD 9E 7E
 sbc (ix-128)                   ; DD 9E 80
 sbc (iy)                       ; FD 9E 00
 sbc (iy+126)                   ; FD 9E 7E
 sbc (iy-128)                   ; FD 9E 80
 sbc -128                       ; DE 80
 sbc 127                        ; DE 7F
 sbc 255                        ; DE FF
 sbc a                          ; 9F
 sbc a, (hl)                    ; 9E
 sbc a, (hl+)                   ; 9E 23
 sbc a, (hl-)                   ; 9E 2B
 sbc a, (ix)                    ; DD 9E 00
 sbc a, (ix+126)                ; DD 9E 7E
 sbc a, (ix-128)                ; DD 9E 80
 sbc a, (iy)                    ; FD 9E 00
 sbc a, (iy+126)                ; FD 9E 7E
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
 sbc.s (hl)                     ; 52 9E
 sbc.s (hl+)                    ; 52 9E 23
 sbc.s (hl-)                    ; 52 9E 2B
 sbc.s (ix)                     ; 52 DD 9E 00
 sbc.s (ix+126)                 ; 52 DD 9E 7E
 sbc.s (ix-128)                 ; 52 DD 9E 80
 sbc.s (iy)                     ; 52 FD 9E 00
 sbc.s (iy+126)                 ; 52 FD 9E 7E
 sbc.s (iy-128)                 ; 52 FD 9E 80
 sbc.s a, (hl)                  ; 52 9E
 sbc.s a, (hl+)                 ; 52 9E 23
 sbc.s a, (hl-)                 ; 52 9E 2B
 sbc.s a, (ix)                  ; 52 DD 9E 00
 sbc.s a, (ix+126)              ; 52 DD 9E 7E
 sbc.s a, (ix-128)              ; 52 DD 9E 80
 sbc.s a, (iy)                  ; 52 FD 9E 00
 sbc.s a, (iy+126)              ; 52 FD 9E 7E
 sbc.s a, (iy-128)              ; 52 FD 9E 80
 sbc.s hl, bc                   ; 52 ED 42
 sbc.s hl, de                   ; 52 ED 52
 sbc.s hl, hl                   ; 52 ED 62
 sbc.s hl, sp                   ; 52 ED 72
 sbc.sil (hl)                   ; 52 9E
 sbc.sil (hl+)                  ; 52 9E 23
 sbc.sil (hl-)                  ; 52 9E 2B
 sbc.sil (ix)                   ; 52 DD 9E 00
 sbc.sil (ix+126)               ; 52 DD 9E 7E
 sbc.sil (ix-128)               ; 52 DD 9E 80
 sbc.sil (iy)                   ; 52 FD 9E 00
 sbc.sil (iy+126)               ; 52 FD 9E 7E
 sbc.sil (iy-128)               ; 52 FD 9E 80
 sbc.sil a, (hl)                ; 52 9E
 sbc.sil a, (hl+)               ; 52 9E 23
 sbc.sil a, (hl-)               ; 52 9E 2B
 sbc.sil a, (ix)                ; 52 DD 9E 00
 sbc.sil a, (ix+126)            ; 52 DD 9E 7E
 sbc.sil a, (ix-128)            ; 52 DD 9E 80
 sbc.sil a, (iy)                ; 52 FD 9E 00
 sbc.sil a, (iy+126)            ; 52 FD 9E 7E
 sbc.sil a, (iy-128)            ; 52 FD 9E 80
 sbc.sil hl, bc                 ; 52 ED 42
 sbc.sil hl, de                 ; 52 ED 52
 sbc.sil hl, hl                 ; 52 ED 62
 sbc.sil hl, sp                 ; 52 ED 72
 sbi -128                       ; DE 80
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 scf                            ; 37
 set 0, (hl)                    ; CB C6
 set 0, (ix)                    ; DD CB 00 C6
 set 0, (ix+126)                ; DD CB 7E C6
 set 0, (ix-128)                ; DD CB 80 C6
 set 0, (iy)                    ; FD CB 00 C6
 set 0, (iy+126)                ; FD CB 7E C6
 set 0, (iy-128)                ; FD CB 80 C6
 set 0, a                       ; CB C7
 set 0, b                       ; CB C0
 set 0, c                       ; CB C1
 set 0, d                       ; CB C2
 set 0, e                       ; CB C3
 set 0, h                       ; CB C4
 set 0, l                       ; CB C5
 set 1, (hl)                    ; CB CE
 set 1, (ix)                    ; DD CB 00 CE
 set 1, (ix+126)                ; DD CB 7E CE
 set 1, (ix-128)                ; DD CB 80 CE
 set 1, (iy)                    ; FD CB 00 CE
 set 1, (iy+126)                ; FD CB 7E CE
 set 1, (iy-128)                ; FD CB 80 CE
 set 1, a                       ; CB CF
 set 1, b                       ; CB C8
 set 1, c                       ; CB C9
 set 1, d                       ; CB CA
 set 1, e                       ; CB CB
 set 1, h                       ; CB CC
 set 1, l                       ; CB CD
 set 2, (hl)                    ; CB D6
 set 2, (ix)                    ; DD CB 00 D6
 set 2, (ix+126)                ; DD CB 7E D6
 set 2, (ix-128)                ; DD CB 80 D6
 set 2, (iy)                    ; FD CB 00 D6
 set 2, (iy+126)                ; FD CB 7E D6
 set 2, (iy-128)                ; FD CB 80 D6
 set 2, a                       ; CB D7
 set 2, b                       ; CB D0
 set 2, c                       ; CB D1
 set 2, d                       ; CB D2
 set 2, e                       ; CB D3
 set 2, h                       ; CB D4
 set 2, l                       ; CB D5
 set 3, (hl)                    ; CB DE
 set 3, (ix)                    ; DD CB 00 DE
 set 3, (ix+126)                ; DD CB 7E DE
 set 3, (ix-128)                ; DD CB 80 DE
 set 3, (iy)                    ; FD CB 00 DE
 set 3, (iy+126)                ; FD CB 7E DE
 set 3, (iy-128)                ; FD CB 80 DE
 set 3, a                       ; CB DF
 set 3, b                       ; CB D8
 set 3, c                       ; CB D9
 set 3, d                       ; CB DA
 set 3, e                       ; CB DB
 set 3, h                       ; CB DC
 set 3, l                       ; CB DD
 set 4, (hl)                    ; CB E6
 set 4, (ix)                    ; DD CB 00 E6
 set 4, (ix+126)                ; DD CB 7E E6
 set 4, (ix-128)                ; DD CB 80 E6
 set 4, (iy)                    ; FD CB 00 E6
 set 4, (iy+126)                ; FD CB 7E E6
 set 4, (iy-128)                ; FD CB 80 E6
 set 4, a                       ; CB E7
 set 4, b                       ; CB E0
 set 4, c                       ; CB E1
 set 4, d                       ; CB E2
 set 4, e                       ; CB E3
 set 4, h                       ; CB E4
 set 4, l                       ; CB E5
 set 5, (hl)                    ; CB EE
 set 5, (ix)                    ; DD CB 00 EE
 set 5, (ix+126)                ; DD CB 7E EE
 set 5, (ix-128)                ; DD CB 80 EE
 set 5, (iy)                    ; FD CB 00 EE
 set 5, (iy+126)                ; FD CB 7E EE
 set 5, (iy-128)                ; FD CB 80 EE
 set 5, a                       ; CB EF
 set 5, b                       ; CB E8
 set 5, c                       ; CB E9
 set 5, d                       ; CB EA
 set 5, e                       ; CB EB
 set 5, h                       ; CB EC
 set 5, l                       ; CB ED
 set 6, (hl)                    ; CB F6
 set 6, (ix)                    ; DD CB 00 F6
 set 6, (ix+126)                ; DD CB 7E F6
 set 6, (ix-128)                ; DD CB 80 F6
 set 6, (iy)                    ; FD CB 00 F6
 set 6, (iy+126)                ; FD CB 7E F6
 set 6, (iy-128)                ; FD CB 80 F6
 set 6, a                       ; CB F7
 set 6, b                       ; CB F0
 set 6, c                       ; CB F1
 set 6, d                       ; CB F2
 set 6, e                       ; CB F3
 set 6, h                       ; CB F4
 set 6, l                       ; CB F5
 set 7, (hl)                    ; CB FE
 set 7, (ix)                    ; DD CB 00 FE
 set 7, (ix+126)                ; DD CB 7E FE
 set 7, (ix-128)                ; DD CB 80 FE
 set 7, (iy)                    ; FD CB 00 FE
 set 7, (iy+126)                ; FD CB 7E FE
 set 7, (iy-128)                ; FD CB 80 FE
 set 7, a                       ; CB FF
 set 7, b                       ; CB F8
 set 7, c                       ; CB F9
 set 7, d                       ; CB FA
 set 7, e                       ; CB FB
 set 7, h                       ; CB FC
 set 7, l                       ; CB FD
 set.s 0, (hl)                  ; 52 CB C6
 set.s 0, (ix)                  ; 52 DD CB 00 C6
 set.s 0, (ix+126)              ; 52 DD CB 7E C6
 set.s 0, (ix-128)              ; 52 DD CB 80 C6
 set.s 0, (iy)                  ; 52 FD CB 00 C6
 set.s 0, (iy+126)              ; 52 FD CB 7E C6
 set.s 0, (iy-128)              ; 52 FD CB 80 C6
 set.s 1, (hl)                  ; 52 CB CE
 set.s 1, (ix)                  ; 52 DD CB 00 CE
 set.s 1, (ix+126)              ; 52 DD CB 7E CE
 set.s 1, (ix-128)              ; 52 DD CB 80 CE
 set.s 1, (iy)                  ; 52 FD CB 00 CE
 set.s 1, (iy+126)              ; 52 FD CB 7E CE
 set.s 1, (iy-128)              ; 52 FD CB 80 CE
 set.s 2, (hl)                  ; 52 CB D6
 set.s 2, (ix)                  ; 52 DD CB 00 D6
 set.s 2, (ix+126)              ; 52 DD CB 7E D6
 set.s 2, (ix-128)              ; 52 DD CB 80 D6
 set.s 2, (iy)                  ; 52 FD CB 00 D6
 set.s 2, (iy+126)              ; 52 FD CB 7E D6
 set.s 2, (iy-128)              ; 52 FD CB 80 D6
 set.s 3, (hl)                  ; 52 CB DE
 set.s 3, (ix)                  ; 52 DD CB 00 DE
 set.s 3, (ix+126)              ; 52 DD CB 7E DE
 set.s 3, (ix-128)              ; 52 DD CB 80 DE
 set.s 3, (iy)                  ; 52 FD CB 00 DE
 set.s 3, (iy+126)              ; 52 FD CB 7E DE
 set.s 3, (iy-128)              ; 52 FD CB 80 DE
 set.s 4, (hl)                  ; 52 CB E6
 set.s 4, (ix)                  ; 52 DD CB 00 E6
 set.s 4, (ix+126)              ; 52 DD CB 7E E6
 set.s 4, (ix-128)              ; 52 DD CB 80 E6
 set.s 4, (iy)                  ; 52 FD CB 00 E6
 set.s 4, (iy+126)              ; 52 FD CB 7E E6
 set.s 4, (iy-128)              ; 52 FD CB 80 E6
 set.s 5, (hl)                  ; 52 CB EE
 set.s 5, (ix)                  ; 52 DD CB 00 EE
 set.s 5, (ix+126)              ; 52 DD CB 7E EE
 set.s 5, (ix-128)              ; 52 DD CB 80 EE
 set.s 5, (iy)                  ; 52 FD CB 00 EE
 set.s 5, (iy+126)              ; 52 FD CB 7E EE
 set.s 5, (iy-128)              ; 52 FD CB 80 EE
 set.s 6, (hl)                  ; 52 CB F6
 set.s 6, (ix)                  ; 52 DD CB 00 F6
 set.s 6, (ix+126)              ; 52 DD CB 7E F6
 set.s 6, (ix-128)              ; 52 DD CB 80 F6
 set.s 6, (iy)                  ; 52 FD CB 00 F6
 set.s 6, (iy+126)              ; 52 FD CB 7E F6
 set.s 6, (iy-128)              ; 52 FD CB 80 F6
 set.s 7, (hl)                  ; 52 CB FE
 set.s 7, (ix)                  ; 52 DD CB 00 FE
 set.s 7, (ix+126)              ; 52 DD CB 7E FE
 set.s 7, (ix-128)              ; 52 DD CB 80 FE
 set.s 7, (iy)                  ; 52 FD CB 00 FE
 set.s 7, (iy+126)              ; 52 FD CB 7E FE
 set.s 7, (iy-128)              ; 52 FD CB 80 FE
 set.sil 0, (hl)                ; 52 CB C6
 set.sil 0, (ix)                ; 52 DD CB 00 C6
 set.sil 0, (ix+126)            ; 52 DD CB 7E C6
 set.sil 0, (ix-128)            ; 52 DD CB 80 C6
 set.sil 0, (iy)                ; 52 FD CB 00 C6
 set.sil 0, (iy+126)            ; 52 FD CB 7E C6
 set.sil 0, (iy-128)            ; 52 FD CB 80 C6
 set.sil 1, (hl)                ; 52 CB CE
 set.sil 1, (ix)                ; 52 DD CB 00 CE
 set.sil 1, (ix+126)            ; 52 DD CB 7E CE
 set.sil 1, (ix-128)            ; 52 DD CB 80 CE
 set.sil 1, (iy)                ; 52 FD CB 00 CE
 set.sil 1, (iy+126)            ; 52 FD CB 7E CE
 set.sil 1, (iy-128)            ; 52 FD CB 80 CE
 set.sil 2, (hl)                ; 52 CB D6
 set.sil 2, (ix)                ; 52 DD CB 00 D6
 set.sil 2, (ix+126)            ; 52 DD CB 7E D6
 set.sil 2, (ix-128)            ; 52 DD CB 80 D6
 set.sil 2, (iy)                ; 52 FD CB 00 D6
 set.sil 2, (iy+126)            ; 52 FD CB 7E D6
 set.sil 2, (iy-128)            ; 52 FD CB 80 D6
 set.sil 3, (hl)                ; 52 CB DE
 set.sil 3, (ix)                ; 52 DD CB 00 DE
 set.sil 3, (ix+126)            ; 52 DD CB 7E DE
 set.sil 3, (ix-128)            ; 52 DD CB 80 DE
 set.sil 3, (iy)                ; 52 FD CB 00 DE
 set.sil 3, (iy+126)            ; 52 FD CB 7E DE
 set.sil 3, (iy-128)            ; 52 FD CB 80 DE
 set.sil 4, (hl)                ; 52 CB E6
 set.sil 4, (ix)                ; 52 DD CB 00 E6
 set.sil 4, (ix+126)            ; 52 DD CB 7E E6
 set.sil 4, (ix-128)            ; 52 DD CB 80 E6
 set.sil 4, (iy)                ; 52 FD CB 00 E6
 set.sil 4, (iy+126)            ; 52 FD CB 7E E6
 set.sil 4, (iy-128)            ; 52 FD CB 80 E6
 set.sil 5, (hl)                ; 52 CB EE
 set.sil 5, (ix)                ; 52 DD CB 00 EE
 set.sil 5, (ix+126)            ; 52 DD CB 7E EE
 set.sil 5, (ix-128)            ; 52 DD CB 80 EE
 set.sil 5, (iy)                ; 52 FD CB 00 EE
 set.sil 5, (iy+126)            ; 52 FD CB 7E EE
 set.sil 5, (iy-128)            ; 52 FD CB 80 EE
 set.sil 6, (hl)                ; 52 CB F6
 set.sil 6, (ix)                ; 52 DD CB 00 F6
 set.sil 6, (ix+126)            ; 52 DD CB 7E F6
 set.sil 6, (ix-128)            ; 52 DD CB 80 F6
 set.sil 6, (iy)                ; 52 FD CB 00 F6
 set.sil 6, (iy+126)            ; 52 FD CB 7E F6
 set.sil 6, (iy-128)            ; 52 FD CB 80 F6
 set.sil 7, (hl)                ; 52 CB FE
 set.sil 7, (ix)                ; 52 DD CB 00 FE
 set.sil 7, (ix+126)            ; 52 DD CB 7E FE
 set.sil 7, (ix-128)            ; 52 DD CB 80 FE
 set.sil 7, (iy)                ; 52 FD CB 00 FE
 set.sil 7, (iy+126)            ; 52 FD CB 7E FE
 set.sil 7, (iy-128)            ; 52 FD CB 80 FE
 shld -32768                    ; 22 00 80
 shld 0x123456                  ; 22 56 34
 shld 32767                     ; 22 FF 7F
 shld 65535                     ; 22 FF FF
 sla (hl)                       ; CB 26
 sla (ix)                       ; DD CB 00 26
 sla (ix+126)                   ; DD CB 7E 26
 sla (ix-128)                   ; DD CB 80 26
 sla (iy)                       ; FD CB 00 26
 sla (iy+126)                   ; FD CB 7E 26
 sla (iy-128)                   ; FD CB 80 26
 sla a                          ; CB 27
 sla b                          ; CB 20
 sla c                          ; CB 21
 sla d                          ; CB 22
 sla e                          ; CB 23
 sla h                          ; CB 24
 sla l                          ; CB 25
 sla.s (hl)                     ; 52 CB 26
 sla.s (ix)                     ; 52 DD CB 00 26
 sla.s (ix+126)                 ; 52 DD CB 7E 26
 sla.s (ix-128)                 ; 52 DD CB 80 26
 sla.s (iy)                     ; 52 FD CB 00 26
 sla.s (iy+126)                 ; 52 FD CB 7E 26
 sla.s (iy-128)                 ; 52 FD CB 80 26
 sla.sil (hl)                   ; 52 CB 26
 sla.sil (ix)                   ; 52 DD CB 00 26
 sla.sil (ix+126)               ; 52 DD CB 7E 26
 sla.sil (ix-128)               ; 52 DD CB 80 26
 sla.sil (iy)                   ; 52 FD CB 00 26
 sla.sil (iy+126)               ; 52 FD CB 7E 26
 sla.sil (iy-128)               ; 52 FD CB 80 26
 slp                            ; ED 76
 sphl                           ; F9
 sra (hl)                       ; CB 2E
 sra (ix)                       ; DD CB 00 2E
 sra (ix+126)                   ; DD CB 7E 2E
 sra (ix-128)                   ; DD CB 80 2E
 sra (iy)                       ; FD CB 00 2E
 sra (iy+126)                   ; FD CB 7E 2E
 sra (iy-128)                   ; FD CB 80 2E
 sra a                          ; CB 2F
 sra b                          ; CB 28
 sra bc                         ; CB 28 CB 19
 sra c                          ; CB 29
 sra d                          ; CB 2A
 sra de                         ; CB 2A CB 1B
 sra e                          ; CB 2B
 sra h                          ; CB 2C
 sra hl                         ; CB 2C CB 1D
 sra l                          ; CB 2D
 sra.s (hl)                     ; 52 CB 2E
 sra.s (ix)                     ; 52 DD CB 00 2E
 sra.s (ix+126)                 ; 52 DD CB 7E 2E
 sra.s (ix-128)                 ; 52 DD CB 80 2E
 sra.s (iy)                     ; 52 FD CB 00 2E
 sra.s (iy+126)                 ; 52 FD CB 7E 2E
 sra.s (iy-128)                 ; 52 FD CB 80 2E
 sra.sil (hl)                   ; 52 CB 2E
 sra.sil (ix)                   ; 52 DD CB 00 2E
 sra.sil (ix+126)               ; 52 DD CB 7E 2E
 sra.sil (ix-128)               ; 52 DD CB 80 2E
 sra.sil (iy)                   ; 52 FD CB 00 2E
 sra.sil (iy+126)               ; 52 FD CB 7E 2E
 sra.sil (iy-128)               ; 52 FD CB 80 2E
 srl (hl)                       ; CB 3E
 srl (ix)                       ; DD CB 00 3E
 srl (ix+126)                   ; DD CB 7E 3E
 srl (ix-128)                   ; DD CB 80 3E
 srl (iy)                       ; FD CB 00 3E
 srl (iy+126)                   ; FD CB 7E 3E
 srl (iy-128)                   ; FD CB 80 3E
 srl a                          ; CB 3F
 srl b                          ; CB 38
 srl c                          ; CB 39
 srl d                          ; CB 3A
 srl e                          ; CB 3B
 srl h                          ; CB 3C
 srl l                          ; CB 3D
 srl.s (hl)                     ; 52 CB 3E
 srl.s (ix)                     ; 52 DD CB 00 3E
 srl.s (ix+126)                 ; 52 DD CB 7E 3E
 srl.s (ix-128)                 ; 52 DD CB 80 3E
 srl.s (iy)                     ; 52 FD CB 00 3E
 srl.s (iy+126)                 ; 52 FD CB 7E 3E
 srl.s (iy-128)                 ; 52 FD CB 80 3E
 srl.sil (hl)                   ; 52 CB 3E
 srl.sil (ix)                   ; 52 DD CB 00 3E
 srl.sil (ix+126)               ; 52 DD CB 7E 3E
 srl.sil (ix-128)               ; 52 DD CB 80 3E
 srl.sil (iy)                   ; 52 FD CB 00 3E
 srl.sil (iy+126)               ; 52 FD CB 7E 3E
 srl.sil (iy-128)               ; 52 FD CB 80 3E
 stax b                         ; 02
 stax bc                        ; 02
 stax d                         ; 12
 stax de                        ; 12
 stc                            ; 37
 stmix                          ; ED 7D
 sub (hl)                       ; 96
 sub (hl+)                      ; 96 23
 sub (hl-)                      ; 96 2B
 sub (ix)                       ; DD 96 00
 sub (ix+126)                   ; DD 96 7E
 sub (ix-128)                   ; DD 96 80
 sub (iy)                       ; FD 96 00
 sub (iy+126)                   ; FD 96 7E
 sub (iy-128)                   ; FD 96 80
 sub -128                       ; D6 80
 sub 127                        ; D6 7F
 sub 255                        ; D6 FF
 sub a                          ; 97
 sub a, (hl)                    ; 96
 sub a, (hl+)                   ; 96 23
 sub a, (hl-)                   ; 96 2B
 sub a, (ix)                    ; DD 96 00
 sub a, (ix+126)                ; DD 96 7E
 sub a, (ix-128)                ; DD 96 80
 sub a, (iy)                    ; FD 96 00
 sub a, (iy+126)                ; FD 96 7E
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
 sub hl, bc                     ; CD @__z80asm__sub_hl_bc
 sub hl, de                     ; CD @__z80asm__sub_hl_de
 sub hl, hl                     ; CD @__z80asm__sub_hl_hl
 sub hl, sp                     ; CD @__z80asm__sub_hl_sp
 sub ixh                        ; DD 94
 sub ixl                        ; DD 95
 sub iyh                        ; FD 94
 sub iyl                        ; FD 95
 sub l                          ; 95
 sub m                          ; 96
 sub.s (hl)                     ; 52 96
 sub.s (hl+)                    ; 52 96 23
 sub.s (hl-)                    ; 52 96 2B
 sub.s (ix)                     ; 52 DD 96 00
 sub.s (ix+126)                 ; 52 DD 96 7E
 sub.s (ix-128)                 ; 52 DD 96 80
 sub.s (iy)                     ; 52 FD 96 00
 sub.s (iy+126)                 ; 52 FD 96 7E
 sub.s (iy-128)                 ; 52 FD 96 80
 sub.s a, (hl)                  ; 52 96
 sub.s a, (hl+)                 ; 52 96 23
 sub.s a, (hl-)                 ; 52 96 2B
 sub.s a, (ix)                  ; 52 DD 96 00
 sub.s a, (ix+126)              ; 52 DD 96 7E
 sub.s a, (ix-128)              ; 52 DD 96 80
 sub.s a, (iy)                  ; 52 FD 96 00
 sub.s a, (iy+126)              ; 52 FD 96 7E
 sub.s a, (iy-128)              ; 52 FD 96 80
 sub.sil (hl)                   ; 52 96
 sub.sil (hl+)                  ; 52 96 23
 sub.sil (hl-)                  ; 52 96 2B
 sub.sil (ix)                   ; 52 DD 96 00
 sub.sil (ix+126)               ; 52 DD 96 7E
 sub.sil (ix-128)               ; 52 DD 96 80
 sub.sil (iy)                   ; 52 FD 96 00
 sub.sil (iy+126)               ; 52 FD 96 7E
 sub.sil (iy-128)               ; 52 FD 96 80
 sub.sil a, (hl)                ; 52 96
 sub.sil a, (hl+)               ; 52 96 23
 sub.sil a, (hl-)               ; 52 96 2B
 sub.sil a, (ix)                ; 52 DD 96 00
 sub.sil a, (ix+126)            ; 52 DD 96 7E
 sub.sil a, (ix-128)            ; 52 DD 96 80
 sub.sil a, (iy)                ; 52 FD 96 00
 sub.sil a, (iy+126)            ; 52 FD 96 7E
 sub.sil a, (iy-128)            ; 52 FD 96 80
 sui -128                       ; D6 80
 sui 127                        ; D6 7F
 sui 255                        ; D6 FF
 test (hl)                      ; ED 34
 test -128                      ; ED 64 80
 test 127                       ; ED 64 7F
 test 255                       ; ED 64 FF
 test a                         ; ED 3C
 test a, (hl)                   ; ED 34
 test a, -128                   ; ED 64 80
 test a, 127                    ; ED 64 7F
 test a, 255                    ; ED 64 FF
 test a, a                      ; ED 3C
 test a, b                      ; ED 04
 test a, c                      ; ED 0C
 test a, d                      ; ED 14
 test a, e                      ; ED 1C
 test a, h                      ; ED 24
 test a, l                      ; ED 2C
 test b                         ; ED 04
 test c                         ; ED 0C
 test d                         ; ED 14
 test e                         ; ED 1C
 test h                         ; ED 24
 test l                         ; ED 2C
 test.s (hl)                    ; 52 ED 34
 test.s a, (hl)                 ; 52 ED 34
 test.sil (hl)                  ; 52 ED 34
 test.sil a, (hl)               ; 52 ED 34
 tst (hl)                       ; ED 34
 tst -128                       ; ED 64 80
 tst 127                        ; ED 64 7F
 tst 255                        ; ED 64 FF
 tst a                          ; ED 3C
 tst a, (hl)                    ; ED 34
 tst a, -128                    ; ED 64 80
 tst a, 127                     ; ED 64 7F
 tst a, 255                     ; ED 64 FF
 tst a, a                       ; ED 3C
 tst a, b                       ; ED 04
 tst a, c                       ; ED 0C
 tst a, d                       ; ED 14
 tst a, e                       ; ED 1C
 tst a, h                       ; ED 24
 tst a, l                       ; ED 2C
 tst b                          ; ED 04
 tst c                          ; ED 0C
 tst d                          ; ED 14
 tst e                          ; ED 1C
 tst h                          ; ED 24
 tst l                          ; ED 2C
 tst.s (hl)                     ; 52 ED 34
 tst.s a, (hl)                  ; 52 ED 34
 tst.sil (hl)                   ; 52 ED 34
 tst.sil a, (hl)                ; 52 ED 34
 tstio -128                     ; ED 74 80
 tstio 127                      ; ED 74 7F
 tstio 255                      ; ED 74 FF
 xchg                           ; EB
 xor (hl)                       ; AE
 xor (hl+)                      ; AE 23
 xor (hl-)                      ; AE 2B
 xor (ix)                       ; DD AE 00
 xor (ix+126)                   ; DD AE 7E
 xor (ix-128)                   ; DD AE 80
 xor (iy)                       ; FD AE 00
 xor (iy+126)                   ; FD AE 7E
 xor (iy-128)                   ; FD AE 80
 xor -128                       ; EE 80
 xor 127                        ; EE 7F
 xor 255                        ; EE FF
 xor a                          ; AF
 xor a, (hl)                    ; AE
 xor a, (hl+)                   ; AE 23
 xor a, (hl-)                   ; AE 2B
 xor a, (ix)                    ; DD AE 00
 xor a, (ix+126)                ; DD AE 7E
 xor a, (ix-128)                ; DD AE 80
 xor a, (iy)                    ; FD AE 00
 xor a, (iy+126)                ; FD AE 7E
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
 xor.s (hl)                     ; 52 AE
 xor.s (hl+)                    ; 52 AE 23
 xor.s (hl-)                    ; 52 AE 2B
 xor.s (ix)                     ; 52 DD AE 00
 xor.s (ix+126)                 ; 52 DD AE 7E
 xor.s (ix-128)                 ; 52 DD AE 80
 xor.s (iy)                     ; 52 FD AE 00
 xor.s (iy+126)                 ; 52 FD AE 7E
 xor.s (iy-128)                 ; 52 FD AE 80
 xor.s a, (hl)                  ; 52 AE
 xor.s a, (hl+)                 ; 52 AE 23
 xor.s a, (hl-)                 ; 52 AE 2B
 xor.s a, (ix)                  ; 52 DD AE 00
 xor.s a, (ix+126)              ; 52 DD AE 7E
 xor.s a, (ix-128)              ; 52 DD AE 80
 xor.s a, (iy)                  ; 52 FD AE 00
 xor.s a, (iy+126)              ; 52 FD AE 7E
 xor.s a, (iy-128)              ; 52 FD AE 80
 xor.sil (hl)                   ; 52 AE
 xor.sil (hl+)                  ; 52 AE 23
 xor.sil (hl-)                  ; 52 AE 2B
 xor.sil (ix)                   ; 52 DD AE 00
 xor.sil (ix+126)               ; 52 DD AE 7E
 xor.sil (ix-128)               ; 52 DD AE 80
 xor.sil (iy)                   ; 52 FD AE 00
 xor.sil (iy+126)               ; 52 FD AE 7E
 xor.sil (iy-128)               ; 52 FD AE 80
 xor.sil a, (hl)                ; 52 AE
 xor.sil a, (hl+)               ; 52 AE 23
 xor.sil a, (hl-)               ; 52 AE 2B
 xor.sil a, (ix)                ; 52 DD AE 00
 xor.sil a, (ix+126)            ; 52 DD AE 7E
 xor.sil a, (ix-128)            ; 52 DD AE 80
 xor.sil a, (iy)                ; 52 FD AE 00
 xor.sil a, (iy+126)            ; 52 FD AE 7E
 xor.sil a, (iy-128)            ; 52 FD AE 80
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
