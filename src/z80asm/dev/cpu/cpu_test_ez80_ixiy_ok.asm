 aci -128                       ; CE 80
 aci 0                          ; CE 00
 aci 127                        ; CE 7F
 aci 255                        ; CE FF
 adc (hl)                       ; 8E
 adc (hl+)                      ; 8E 23
 adc (hl-)                      ; 8E 2B
 adc (ix)                       ; FD 8E 00
 adc (ix+0)                     ; FD 8E 00
 adc (ix+126)                   ; FD 8E 7E
 adc (ix-128)                   ; FD 8E 80
 adc (iy)                       ; DD 8E 00
 adc (iy+0)                     ; DD 8E 00
 adc (iy+126)                   ; DD 8E 7E
 adc (iy-128)                   ; DD 8E 80
 adc -128                       ; CE 80
 adc 0                          ; CE 00
 adc 127                        ; CE 7F
 adc 255                        ; CE FF
 adc a                          ; 8F
 adc a, (hl)                    ; 8E
 adc a, (hl+)                   ; 8E 23
 adc a, (hl-)                   ; 8E 2B
 adc a, (ix)                    ; FD 8E 00
 adc a, (ix+0)                  ; FD 8E 00
 adc a, (ix+126)                ; FD 8E 7E
 adc a, (ix-128)                ; FD 8E 80
 adc a, (iy)                    ; DD 8E 00
 adc a, (iy+0)                  ; DD 8E 00
 adc a, (iy+126)                ; DD 8E 7E
 adc a, (iy-128)                ; DD 8E 80
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
 adc a, ixh                     ; FD 8C
 adc a, ixl                     ; FD 8D
 adc a, iyh                     ; DD 8C
 adc a, iyl                     ; DD 8D
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
 adc ixh                        ; FD 8C
 adc ixl                        ; FD 8D
 adc iyh                        ; DD 8C
 adc iyl                        ; DD 8D
 adc l                          ; 8D
 adc m                          ; 8E
 adc.s (hl)                     ; 52 8E
 adc.s (hl+)                    ; 52 8E 52 23
 adc.s (hl-)                    ; 52 8E 52 2B
 adc.s (ix)                     ; 52 FD 8E 00
 adc.s (ix+0)                   ; 52 FD 8E 00
 adc.s (ix+126)                 ; 52 FD 8E 7E
 adc.s (ix-128)                 ; 52 FD 8E 80
 adc.s (iy)                     ; 52 DD 8E 00
 adc.s (iy+0)                   ; 52 DD 8E 00
 adc.s (iy+126)                 ; 52 DD 8E 7E
 adc.s (iy-128)                 ; 52 DD 8E 80
 adc.s a, (hl)                  ; 52 8E
 adc.s a, (hl+)                 ; 52 8E 52 23
 adc.s a, (hl-)                 ; 52 8E 52 2B
 adc.s a, (ix)                  ; 52 FD 8E 00
 adc.s a, (ix+0)                ; 52 FD 8E 00
 adc.s a, (ix+126)              ; 52 FD 8E 7E
 adc.s a, (ix-128)              ; 52 FD 8E 80
 adc.s a, (iy)                  ; 52 DD 8E 00
 adc.s a, (iy+0)                ; 52 DD 8E 00
 adc.s a, (iy+126)              ; 52 DD 8E 7E
 adc.s a, (iy-128)              ; 52 DD 8E 80
 adc.s hl, bc                   ; 52 ED 4A
 adc.s hl, de                   ; 52 ED 5A
 adc.s hl, hl                   ; 52 ED 6A
 adc.s hl, sp                   ; 52 ED 7A
 adc.sil (hl)                   ; 52 8E
 adc.sil (hl+)                  ; 52 8E 52 23
 adc.sil (hl-)                  ; 52 8E 52 2B
 adc.sil (ix)                   ; 52 FD 8E 00
 adc.sil (ix+0)                 ; 52 FD 8E 00
 adc.sil (ix+126)               ; 52 FD 8E 7E
 adc.sil (ix-128)               ; 52 FD 8E 80
 adc.sil (iy)                   ; 52 DD 8E 00
 adc.sil (iy+0)                 ; 52 DD 8E 00
 adc.sil (iy+126)               ; 52 DD 8E 7E
 adc.sil (iy-128)               ; 52 DD 8E 80
 adc.sil a, (hl)                ; 52 8E
 adc.sil a, (hl+)               ; 52 8E 52 23
 adc.sil a, (hl-)               ; 52 8E 52 2B
 adc.sil a, (ix)                ; 52 FD 8E 00
 adc.sil a, (ix+0)              ; 52 FD 8E 00
 adc.sil a, (ix+126)            ; 52 FD 8E 7E
 adc.sil a, (ix-128)            ; 52 FD 8E 80
 adc.sil a, (iy)                ; 52 DD 8E 00
 adc.sil a, (iy+0)              ; 52 DD 8E 00
 adc.sil a, (iy+126)            ; 52 DD 8E 7E
 adc.sil a, (iy-128)            ; 52 DD 8E 80
 adc.sil hl, bc                 ; 52 ED 4A
 adc.sil hl, de                 ; 52 ED 5A
 adc.sil hl, hl                 ; 52 ED 6A
 adc.sil hl, sp                 ; 52 ED 7A
 add (hl)                       ; 86
 add (hl+)                      ; 86 23
 add (hl-)                      ; 86 2B
 add (ix)                       ; FD 86 00
 add (ix+0)                     ; FD 86 00
 add (ix+126)                   ; FD 86 7E
 add (ix-128)                   ; FD 86 80
 add (iy)                       ; DD 86 00
 add (iy+0)                     ; DD 86 00
 add (iy+126)                   ; DD 86 7E
 add (iy-128)                   ; DD 86 80
 add -128                       ; C6 80
 add 0                          ; C6 00
 add 127                        ; C6 7F
 add 255                        ; C6 FF
 add a                          ; 87
 add a, (hl)                    ; 86
 add a, (hl+)                   ; 86 23
 add a, (hl-)                   ; 86 2B
 add a, (ix)                    ; FD 86 00
 add a, (ix+0)                  ; FD 86 00
 add a, (ix+126)                ; FD 86 7E
 add a, (ix-128)                ; FD 86 80
 add a, (iy)                    ; DD 86 00
 add a, (iy+0)                  ; DD 86 00
 add a, (iy+126)                ; DD 86 7E
 add a, (iy-128)                ; DD 86 80
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
 add a, ixh                     ; FD 84
 add a, ixl                     ; FD 85
 add a, iyh                     ; DD 84
 add a, iyl                     ; DD 85
 add a, l                       ; 85
 add b                          ; 80
 add bc, a                      ; CD @__z80asm__add_bc_a
 add c                          ; 81
 add d                          ; 82
 add de, a                      ; CD @__z80asm__add_de_a
 add e                          ; 83
 add h                          ; 84
 add hl, a                      ; CD @__z80asm__add_hl_a
 add hl, bc                     ; 09
 add hl, de                     ; 19
 add hl, hl                     ; 29
 add hl, sp                     ; 39
 add ix, bc                     ; FD 09
 add ix, de                     ; FD 19
 add ix, ix                     ; FD 29
 add ix, sp                     ; FD 39
 add ixh                        ; FD 84
 add ixl                        ; FD 85
 add iy, bc                     ; DD 09
 add iy, de                     ; DD 19
 add iy, iy                     ; DD 29
 add iy, sp                     ; DD 39
 add iyh                        ; DD 84
 add iyl                        ; DD 85
 add l                          ; 85
 add m                          ; 86
 add sp, -128                   ; CD @__z80asm__add_sp_s 80
 add sp, 0                      ; CD @__z80asm__add_sp_s 00
 add sp, 126                    ; CD @__z80asm__add_sp_s 7E
 add.s (hl)                     ; 52 86
 add.s (hl+)                    ; 52 86 52 23
 add.s (hl-)                    ; 52 86 52 2B
 add.s (ix)                     ; 52 FD 86 00
 add.s (ix+0)                   ; 52 FD 86 00
 add.s (ix+126)                 ; 52 FD 86 7E
 add.s (ix-128)                 ; 52 FD 86 80
 add.s (iy)                     ; 52 DD 86 00
 add.s (iy+0)                   ; 52 DD 86 00
 add.s (iy+126)                 ; 52 DD 86 7E
 add.s (iy-128)                 ; 52 DD 86 80
 add.s a, (hl)                  ; 52 86
 add.s a, (hl+)                 ; 52 86 52 23
 add.s a, (hl-)                 ; 52 86 52 2B
 add.s a, (ix)                  ; 52 FD 86 00
 add.s a, (ix+0)                ; 52 FD 86 00
 add.s a, (ix+126)              ; 52 FD 86 7E
 add.s a, (ix-128)              ; 52 FD 86 80
 add.s a, (iy)                  ; 52 DD 86 00
 add.s a, (iy+0)                ; 52 DD 86 00
 add.s a, (iy+126)              ; 52 DD 86 7E
 add.s a, (iy-128)              ; 52 DD 86 80
 add.s hl, bc                   ; 52 09
 add.s hl, de                   ; 52 19
 add.s hl, hl                   ; 52 29
 add.s hl, sp                   ; 52 39
 add.s ix, bc                   ; 52 FD 09
 add.s ix, de                   ; 52 FD 19
 add.s ix, ix                   ; 52 FD 29
 add.s ix, sp                   ; 52 FD 39
 add.s iy, bc                   ; 52 DD 09
 add.s iy, de                   ; 52 DD 19
 add.s iy, iy                   ; 52 DD 29
 add.s iy, sp                   ; 52 DD 39
 add.sil (hl)                   ; 52 86
 add.sil (hl+)                  ; 52 86 52 23
 add.sil (hl-)                  ; 52 86 52 2B
 add.sil (ix)                   ; 52 FD 86 00
 add.sil (ix+0)                 ; 52 FD 86 00
 add.sil (ix+126)               ; 52 FD 86 7E
 add.sil (ix-128)               ; 52 FD 86 80
 add.sil (iy)                   ; 52 DD 86 00
 add.sil (iy+0)                 ; 52 DD 86 00
 add.sil (iy+126)               ; 52 DD 86 7E
 add.sil (iy-128)               ; 52 DD 86 80
 add.sil a, (hl)                ; 52 86
 add.sil a, (hl+)               ; 52 86 52 23
 add.sil a, (hl-)               ; 52 86 52 2B
 add.sil a, (ix)                ; 52 FD 86 00
 add.sil a, (ix+0)              ; 52 FD 86 00
 add.sil a, (ix+126)            ; 52 FD 86 7E
 add.sil a, (ix-128)            ; 52 FD 86 80
 add.sil a, (iy)                ; 52 DD 86 00
 add.sil a, (iy+0)              ; 52 DD 86 00
 add.sil a, (iy+126)            ; 52 DD 86 7E
 add.sil a, (iy-128)            ; 52 DD 86 80
 add.sil hl, bc                 ; 52 09
 add.sil hl, de                 ; 52 19
 add.sil hl, hl                 ; 52 29
 add.sil hl, sp                 ; 52 39
 add.sil ix, bc                 ; 52 FD 09
 add.sil ix, de                 ; 52 FD 19
 add.sil ix, ix                 ; 52 FD 29
 add.sil ix, sp                 ; 52 FD 39
 add.sil iy, bc                 ; 52 DD 09
 add.sil iy, de                 ; 52 DD 19
 add.sil iy, iy                 ; 52 DD 29
 add.sil iy, sp                 ; 52 DD 39
 adi -128                       ; C6 80
 adi 0                          ; C6 00
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
 and (ix)                       ; FD A6 00
 and (ix+0)                     ; FD A6 00
 and (ix+126)                   ; FD A6 7E
 and (ix-128)                   ; FD A6 80
 and (iy)                       ; DD A6 00
 and (iy+0)                     ; DD A6 00
 and (iy+126)                   ; DD A6 7E
 and (iy-128)                   ; DD A6 80
 and -128                       ; E6 80
 and 0                          ; E6 00
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; A7
 and a, (hl)                    ; A6
 and a, (hl+)                   ; A6 23
 and a, (hl-)                   ; A6 2B
 and a, (ix)                    ; FD A6 00
 and a, (ix+0)                  ; FD A6 00
 and a, (ix+126)                ; FD A6 7E
 and a, (ix-128)                ; FD A6 80
 and a, (iy)                    ; DD A6 00
 and a, (iy+0)                  ; DD A6 00
 and a, (iy+126)                ; DD A6 7E
 and a, (iy-128)                ; DD A6 80
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
 and a, ixh                     ; FD A4
 and a, ixl                     ; FD A5
 and a, iyh                     ; DD A4
 and a, iyl                     ; DD A5
 and a, l                       ; A5
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
 and.s (hl)                     ; 52 A6
 and.s (hl+)                    ; 52 A6 52 23
 and.s (hl-)                    ; 52 A6 52 2B
 and.s (ix)                     ; 52 FD A6 00
 and.s (ix+0)                   ; 52 FD A6 00
 and.s (ix+126)                 ; 52 FD A6 7E
 and.s (ix-128)                 ; 52 FD A6 80
 and.s (iy)                     ; 52 DD A6 00
 and.s (iy+0)                   ; 52 DD A6 00
 and.s (iy+126)                 ; 52 DD A6 7E
 and.s (iy-128)                 ; 52 DD A6 80
 and.s a, (hl)                  ; 52 A6
 and.s a, (hl+)                 ; 52 A6 52 23
 and.s a, (hl-)                 ; 52 A6 52 2B
 and.s a, (ix)                  ; 52 FD A6 00
 and.s a, (ix+0)                ; 52 FD A6 00
 and.s a, (ix+126)              ; 52 FD A6 7E
 and.s a, (ix-128)              ; 52 FD A6 80
 and.s a, (iy)                  ; 52 DD A6 00
 and.s a, (iy+0)                ; 52 DD A6 00
 and.s a, (iy+126)              ; 52 DD A6 7E
 and.s a, (iy-128)              ; 52 DD A6 80
 and.sil (hl)                   ; 52 A6
 and.sil (hl+)                  ; 52 A6 52 23
 and.sil (hl-)                  ; 52 A6 52 2B
 and.sil (ix)                   ; 52 FD A6 00
 and.sil (ix+0)                 ; 52 FD A6 00
 and.sil (ix+126)               ; 52 FD A6 7E
 and.sil (ix-128)               ; 52 FD A6 80
 and.sil (iy)                   ; 52 DD A6 00
 and.sil (iy+0)                 ; 52 DD A6 00
 and.sil (iy+126)               ; 52 DD A6 7E
 and.sil (iy-128)               ; 52 DD A6 80
 and.sil a, (hl)                ; 52 A6
 and.sil a, (hl+)               ; 52 A6 52 23
 and.sil a, (hl-)               ; 52 A6 52 2B
 and.sil a, (ix)                ; 52 FD A6 00
 and.sil a, (ix+0)              ; 52 FD A6 00
 and.sil a, (ix+126)            ; 52 FD A6 7E
 and.sil a, (ix-128)            ; 52 FD A6 80
 and.sil a, (iy)                ; 52 DD A6 00
 and.sil a, (iy+0)              ; 52 DD A6 00
 and.sil a, (iy+126)            ; 52 DD A6 7E
 and.sil a, (iy-128)            ; 52 DD A6 80
 ani -128                       ; E6 80
 ani 0                          ; E6 00
 ani 127                        ; E6 7F
 ani 255                        ; E6 FF
 arhl                           ; CD @__z80asm__sra_hl
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
 bit.s 0, (hl)                  ; 52 CB 46
 bit.s 0, (ix)                  ; 52 FD CB 00 46
 bit.s 0, (ix+0)                ; 52 FD CB 00 46
 bit.s 0, (ix+126)              ; 52 FD CB 7E 46
 bit.s 0, (ix-128)              ; 52 FD CB 80 46
 bit.s 0, (iy)                  ; 52 DD CB 00 46
 bit.s 0, (iy+0)                ; 52 DD CB 00 46
 bit.s 0, (iy+126)              ; 52 DD CB 7E 46
 bit.s 0, (iy-128)              ; 52 DD CB 80 46
 bit.s 1, (hl)                  ; 52 CB 4E
 bit.s 1, (ix)                  ; 52 FD CB 00 4E
 bit.s 1, (ix+0)                ; 52 FD CB 00 4E
 bit.s 1, (ix+126)              ; 52 FD CB 7E 4E
 bit.s 1, (ix-128)              ; 52 FD CB 80 4E
 bit.s 1, (iy)                  ; 52 DD CB 00 4E
 bit.s 1, (iy+0)                ; 52 DD CB 00 4E
 bit.s 1, (iy+126)              ; 52 DD CB 7E 4E
 bit.s 1, (iy-128)              ; 52 DD CB 80 4E
 bit.s 2, (hl)                  ; 52 CB 56
 bit.s 2, (ix)                  ; 52 FD CB 00 56
 bit.s 2, (ix+0)                ; 52 FD CB 00 56
 bit.s 2, (ix+126)              ; 52 FD CB 7E 56
 bit.s 2, (ix-128)              ; 52 FD CB 80 56
 bit.s 2, (iy)                  ; 52 DD CB 00 56
 bit.s 2, (iy+0)                ; 52 DD CB 00 56
 bit.s 2, (iy+126)              ; 52 DD CB 7E 56
 bit.s 2, (iy-128)              ; 52 DD CB 80 56
 bit.s 3, (hl)                  ; 52 CB 5E
 bit.s 3, (ix)                  ; 52 FD CB 00 5E
 bit.s 3, (ix+0)                ; 52 FD CB 00 5E
 bit.s 3, (ix+126)              ; 52 FD CB 7E 5E
 bit.s 3, (ix-128)              ; 52 FD CB 80 5E
 bit.s 3, (iy)                  ; 52 DD CB 00 5E
 bit.s 3, (iy+0)                ; 52 DD CB 00 5E
 bit.s 3, (iy+126)              ; 52 DD CB 7E 5E
 bit.s 3, (iy-128)              ; 52 DD CB 80 5E
 bit.s 4, (hl)                  ; 52 CB 66
 bit.s 4, (ix)                  ; 52 FD CB 00 66
 bit.s 4, (ix+0)                ; 52 FD CB 00 66
 bit.s 4, (ix+126)              ; 52 FD CB 7E 66
 bit.s 4, (ix-128)              ; 52 FD CB 80 66
 bit.s 4, (iy)                  ; 52 DD CB 00 66
 bit.s 4, (iy+0)                ; 52 DD CB 00 66
 bit.s 4, (iy+126)              ; 52 DD CB 7E 66
 bit.s 4, (iy-128)              ; 52 DD CB 80 66
 bit.s 5, (hl)                  ; 52 CB 6E
 bit.s 5, (ix)                  ; 52 FD CB 00 6E
 bit.s 5, (ix+0)                ; 52 FD CB 00 6E
 bit.s 5, (ix+126)              ; 52 FD CB 7E 6E
 bit.s 5, (ix-128)              ; 52 FD CB 80 6E
 bit.s 5, (iy)                  ; 52 DD CB 00 6E
 bit.s 5, (iy+0)                ; 52 DD CB 00 6E
 bit.s 5, (iy+126)              ; 52 DD CB 7E 6E
 bit.s 5, (iy-128)              ; 52 DD CB 80 6E
 bit.s 6, (hl)                  ; 52 CB 76
 bit.s 6, (ix)                  ; 52 FD CB 00 76
 bit.s 6, (ix+0)                ; 52 FD CB 00 76
 bit.s 6, (ix+126)              ; 52 FD CB 7E 76
 bit.s 6, (ix-128)              ; 52 FD CB 80 76
 bit.s 6, (iy)                  ; 52 DD CB 00 76
 bit.s 6, (iy+0)                ; 52 DD CB 00 76
 bit.s 6, (iy+126)              ; 52 DD CB 7E 76
 bit.s 6, (iy-128)              ; 52 DD CB 80 76
 bit.s 7, (hl)                  ; 52 CB 7E
 bit.s 7, (ix)                  ; 52 FD CB 00 7E
 bit.s 7, (ix+0)                ; 52 FD CB 00 7E
 bit.s 7, (ix+126)              ; 52 FD CB 7E 7E
 bit.s 7, (ix-128)              ; 52 FD CB 80 7E
 bit.s 7, (iy)                  ; 52 DD CB 00 7E
 bit.s 7, (iy+0)                ; 52 DD CB 00 7E
 bit.s 7, (iy+126)              ; 52 DD CB 7E 7E
 bit.s 7, (iy-128)              ; 52 DD CB 80 7E
 bit.sil 0, (hl)                ; 52 CB 46
 bit.sil 0, (ix)                ; 52 FD CB 00 46
 bit.sil 0, (ix+0)              ; 52 FD CB 00 46
 bit.sil 0, (ix+126)            ; 52 FD CB 7E 46
 bit.sil 0, (ix-128)            ; 52 FD CB 80 46
 bit.sil 0, (iy)                ; 52 DD CB 00 46
 bit.sil 0, (iy+0)              ; 52 DD CB 00 46
 bit.sil 0, (iy+126)            ; 52 DD CB 7E 46
 bit.sil 0, (iy-128)            ; 52 DD CB 80 46
 bit.sil 1, (hl)                ; 52 CB 4E
 bit.sil 1, (ix)                ; 52 FD CB 00 4E
 bit.sil 1, (ix+0)              ; 52 FD CB 00 4E
 bit.sil 1, (ix+126)            ; 52 FD CB 7E 4E
 bit.sil 1, (ix-128)            ; 52 FD CB 80 4E
 bit.sil 1, (iy)                ; 52 DD CB 00 4E
 bit.sil 1, (iy+0)              ; 52 DD CB 00 4E
 bit.sil 1, (iy+126)            ; 52 DD CB 7E 4E
 bit.sil 1, (iy-128)            ; 52 DD CB 80 4E
 bit.sil 2, (hl)                ; 52 CB 56
 bit.sil 2, (ix)                ; 52 FD CB 00 56
 bit.sil 2, (ix+0)              ; 52 FD CB 00 56
 bit.sil 2, (ix+126)            ; 52 FD CB 7E 56
 bit.sil 2, (ix-128)            ; 52 FD CB 80 56
 bit.sil 2, (iy)                ; 52 DD CB 00 56
 bit.sil 2, (iy+0)              ; 52 DD CB 00 56
 bit.sil 2, (iy+126)            ; 52 DD CB 7E 56
 bit.sil 2, (iy-128)            ; 52 DD CB 80 56
 bit.sil 3, (hl)                ; 52 CB 5E
 bit.sil 3, (ix)                ; 52 FD CB 00 5E
 bit.sil 3, (ix+0)              ; 52 FD CB 00 5E
 bit.sil 3, (ix+126)            ; 52 FD CB 7E 5E
 bit.sil 3, (ix-128)            ; 52 FD CB 80 5E
 bit.sil 3, (iy)                ; 52 DD CB 00 5E
 bit.sil 3, (iy+0)              ; 52 DD CB 00 5E
 bit.sil 3, (iy+126)            ; 52 DD CB 7E 5E
 bit.sil 3, (iy-128)            ; 52 DD CB 80 5E
 bit.sil 4, (hl)                ; 52 CB 66
 bit.sil 4, (ix)                ; 52 FD CB 00 66
 bit.sil 4, (ix+0)              ; 52 FD CB 00 66
 bit.sil 4, (ix+126)            ; 52 FD CB 7E 66
 bit.sil 4, (ix-128)            ; 52 FD CB 80 66
 bit.sil 4, (iy)                ; 52 DD CB 00 66
 bit.sil 4, (iy+0)              ; 52 DD CB 00 66
 bit.sil 4, (iy+126)            ; 52 DD CB 7E 66
 bit.sil 4, (iy-128)            ; 52 DD CB 80 66
 bit.sil 5, (hl)                ; 52 CB 6E
 bit.sil 5, (ix)                ; 52 FD CB 00 6E
 bit.sil 5, (ix+0)              ; 52 FD CB 00 6E
 bit.sil 5, (ix+126)            ; 52 FD CB 7E 6E
 bit.sil 5, (ix-128)            ; 52 FD CB 80 6E
 bit.sil 5, (iy)                ; 52 DD CB 00 6E
 bit.sil 5, (iy+0)              ; 52 DD CB 00 6E
 bit.sil 5, (iy+126)            ; 52 DD CB 7E 6E
 bit.sil 5, (iy-128)            ; 52 DD CB 80 6E
 bit.sil 6, (hl)                ; 52 CB 76
 bit.sil 6, (ix)                ; 52 FD CB 00 76
 bit.sil 6, (ix+0)              ; 52 FD CB 00 76
 bit.sil 6, (ix+126)            ; 52 FD CB 7E 76
 bit.sil 6, (ix-128)            ; 52 FD CB 80 76
 bit.sil 6, (iy)                ; 52 DD CB 00 76
 bit.sil 6, (iy+0)              ; 52 DD CB 00 76
 bit.sil 6, (iy+126)            ; 52 DD CB 7E 76
 bit.sil 6, (iy-128)            ; 52 DD CB 80 76
 bit.sil 7, (hl)                ; 52 CB 7E
 bit.sil 7, (ix)                ; 52 FD CB 00 7E
 bit.sil 7, (ix+0)              ; 52 FD CB 00 7E
 bit.sil 7, (ix+126)            ; 52 FD CB 7E 7E
 bit.sil 7, (ix-128)            ; 52 FD CB 80 7E
 bit.sil 7, (iy)                ; 52 DD CB 00 7E
 bit.sil 7, (iy+0)              ; 52 DD CB 00 7E
 bit.sil 7, (iy+126)            ; 52 DD CB 7E 7E
 bit.sil 7, (iy-128)            ; 52 DD CB 80 7E
 c_c 0x123456                   ; DC 56 34 12
 c_eq 0x123456                  ; CC 56 34 12
 c_geu 0x123456                 ; D4 56 34 12
 c_ltu 0x123456                 ; DC 56 34 12
 c_m 0x123456                   ; FC 56 34 12
 c_nc 0x123456                  ; D4 56 34 12
 c_ne 0x123456                  ; C4 56 34 12
 c_nv 0x123456                  ; E4 56 34 12
 c_nz 0x123456                  ; C4 56 34 12
 c_p 0x123456                   ; F4 56 34 12
 c_pe 0x123456                  ; EC 56 34 12
 c_po 0x123456                  ; E4 56 34 12
 c_v 0x123456                   ; EC 56 34 12
 c_z 0x123456                   ; CC 56 34 12
 call (hl)                      ; CD @__z80asm__call_hl
 call 0x123456                  ; CD 56 34 12
 call c, 0x123456               ; DC 56 34 12
 call eq, 0x123456              ; CC 56 34 12
 call geu, 0x123456             ; D4 56 34 12
 call ltu, 0x123456             ; DC 56 34 12
 call m, 0x123456               ; FC 56 34 12
 call nc, 0x123456              ; D4 56 34 12
 call ne, 0x123456              ; C4 56 34 12
 call nv, 0x123456              ; E4 56 34 12
 call nz, 0x123456              ; C4 56 34 12
 call p, 0x123456               ; F4 56 34 12
 call pe, 0x123456              ; EC 56 34 12
 call po, 0x123456              ; E4 56 34 12
 call v, 0x123456               ; EC 56 34 12
 call z, 0x123456               ; CC 56 34 12
 call.il 0x123456               ; 5B CD 56 34 12
 call.il c, 0x123456            ; 5B DC 56 34 12
 call.il eq, 0x123456           ; 5B CC 56 34 12
 call.il geu, 0x123456          ; 5B D4 56 34 12
 call.il ltu, 0x123456          ; 5B DC 56 34 12
 call.il m, 0x123456            ; 5B FC 56 34 12
 call.il nc, 0x123456           ; 5B D4 56 34 12
 call.il ne, 0x123456           ; 5B C4 56 34 12
 call.il nv, 0x123456           ; 5B E4 56 34 12
 call.il nz, 0x123456           ; 5B C4 56 34 12
 call.il p, 0x123456            ; 5B F4 56 34 12
 call.il pe, 0x123456           ; 5B EC 56 34 12
 call.il po, 0x123456           ; 5B E4 56 34 12
 call.il v, 0x123456            ; 5B EC 56 34 12
 call.il z, 0x123456            ; 5B CC 56 34 12
 call.is 0x1234                 ; 49 CD 34 12
 call.is c, 0x1234              ; 49 DC 34 12
 call.is eq, 0x1234             ; 49 CC 34 12
 call.is geu, 0x1234            ; 49 D4 34 12
 call.is ltu, 0x1234            ; 49 DC 34 12
 call.is m, 0x1234              ; 49 FC 34 12
 call.is nc, 0x1234             ; 49 D4 34 12
 call.is ne, 0x1234             ; 49 C4 34 12
 call.is nv, 0x1234             ; 49 E4 34 12
 call.is nz, 0x1234             ; 49 C4 34 12
 call.is p, 0x1234              ; 49 F4 34 12
 call.is pe, 0x1234             ; 49 EC 34 12
 call.is po, 0x1234             ; 49 E4 34 12
 call.is v, 0x1234              ; 49 EC 34 12
 call.is z, 0x1234              ; 49 CC 34 12
 call.lil 0x123456              ; 5B CD 56 34 12
 call.lil c, 0x123456           ; 5B DC 56 34 12
 call.lil eq, 0x123456          ; 5B CC 56 34 12
 call.lil geu, 0x123456         ; 5B D4 56 34 12
 call.lil ltu, 0x123456         ; 5B DC 56 34 12
 call.lil m, 0x123456           ; 5B FC 56 34 12
 call.lil nc, 0x123456          ; 5B D4 56 34 12
 call.lil ne, 0x123456          ; 5B C4 56 34 12
 call.lil nv, 0x123456          ; 5B E4 56 34 12
 call.lil nz, 0x123456          ; 5B C4 56 34 12
 call.lil p, 0x123456           ; 5B F4 56 34 12
 call.lil pe, 0x123456          ; 5B EC 56 34 12
 call.lil po, 0x123456          ; 5B E4 56 34 12
 call.lil v, 0x123456           ; 5B EC 56 34 12
 call.lil z, 0x123456           ; 5B CC 56 34 12
 call.lis 0x1234                ; 49 CD 34 12
 call.lis c, 0x1234             ; 49 DC 34 12
 call.lis eq, 0x1234            ; 49 CC 34 12
 call.lis geu, 0x1234           ; 49 D4 34 12
 call.lis ltu, 0x1234           ; 49 DC 34 12
 call.lis m, 0x1234             ; 49 FC 34 12
 call.lis nc, 0x1234            ; 49 D4 34 12
 call.lis ne, 0x1234            ; 49 C4 34 12
 call.lis nv, 0x1234            ; 49 E4 34 12
 call.lis nz, 0x1234            ; 49 C4 34 12
 call.lis p, 0x1234             ; 49 F4 34 12
 call.lis pe, 0x1234            ; 49 EC 34 12
 call.lis po, 0x1234            ; 49 E4 34 12
 call.lis v, 0x1234             ; 49 EC 34 12
 call.lis z, 0x1234             ; 49 CC 34 12
 cc 0x123456                    ; DC 56 34 12
 ccf                            ; 3F
 ceq 0x123456                   ; CC 56 34 12
 cgeu 0x123456                  ; D4 56 34 12
 cltu 0x123456                  ; DC 56 34 12
 cm 0x123456                    ; FC 56 34 12
 cma                            ; 2F
 cmc                            ; 3F
 cmp (hl)                       ; BE
 cmp (hl+)                      ; BE 23
 cmp (hl-)                      ; BE 2B
 cmp (ix)                       ; FD BE 00
 cmp (ix+0)                     ; FD BE 00
 cmp (ix+126)                   ; FD BE 7E
 cmp (ix-128)                   ; FD BE 80
 cmp (iy)                       ; DD BE 00
 cmp (iy+0)                     ; DD BE 00
 cmp (iy+126)                   ; DD BE 7E
 cmp (iy-128)                   ; DD BE 80
 cmp -128                       ; FE 80
 cmp 0                          ; FE 00
 cmp 127                        ; FE 7F
 cmp 255                        ; FE FF
 cmp a                          ; BF
 cmp a, (hl)                    ; BE
 cmp a, (hl+)                   ; BE 23
 cmp a, (hl-)                   ; BE 2B
 cmp a, (ix)                    ; FD BE 00
 cmp a, (ix+0)                  ; FD BE 00
 cmp a, (ix+126)                ; FD BE 7E
 cmp a, (ix-128)                ; FD BE 80
 cmp a, (iy)                    ; DD BE 00
 cmp a, (iy+0)                  ; DD BE 00
 cmp a, (iy+126)                ; DD BE 7E
 cmp a, (iy-128)                ; DD BE 80
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
 cmp a, ixh                     ; FD BC
 cmp a, ixl                     ; FD BD
 cmp a, iyh                     ; DD BC
 cmp a, iyl                     ; DD BD
 cmp a, l                       ; BD
 cmp b                          ; B8
 cmp c                          ; B9
 cmp d                          ; BA
 cmp e                          ; BB
 cmp h                          ; BC
 cmp ixh                        ; FD BC
 cmp ixl                        ; FD BD
 cmp iyh                        ; DD BC
 cmp iyl                        ; DD BD
 cmp l                          ; BD
 cmp m                          ; BE
 cmp.s (hl)                     ; 52 BE
 cmp.s (hl+)                    ; 52 BE 52 23
 cmp.s (hl-)                    ; 52 BE 52 2B
 cmp.s (ix)                     ; 52 FD BE 00
 cmp.s (ix+0)                   ; 52 FD BE 00
 cmp.s (ix+126)                 ; 52 FD BE 7E
 cmp.s (ix-128)                 ; 52 FD BE 80
 cmp.s (iy)                     ; 52 DD BE 00
 cmp.s (iy+0)                   ; 52 DD BE 00
 cmp.s (iy+126)                 ; 52 DD BE 7E
 cmp.s (iy-128)                 ; 52 DD BE 80
 cmp.s a, (hl)                  ; 52 BE
 cmp.s a, (hl+)                 ; 52 BE 52 23
 cmp.s a, (hl-)                 ; 52 BE 52 2B
 cmp.s a, (ix)                  ; 52 FD BE 00
 cmp.s a, (ix+0)                ; 52 FD BE 00
 cmp.s a, (ix+126)              ; 52 FD BE 7E
 cmp.s a, (ix-128)              ; 52 FD BE 80
 cmp.s a, (iy)                  ; 52 DD BE 00
 cmp.s a, (iy+0)                ; 52 DD BE 00
 cmp.s a, (iy+126)              ; 52 DD BE 7E
 cmp.s a, (iy-128)              ; 52 DD BE 80
 cmp.sil (hl)                   ; 52 BE
 cmp.sil (hl+)                  ; 52 BE 52 23
 cmp.sil (hl-)                  ; 52 BE 52 2B
 cmp.sil (ix)                   ; 52 FD BE 00
 cmp.sil (ix+0)                 ; 52 FD BE 00
 cmp.sil (ix+126)               ; 52 FD BE 7E
 cmp.sil (ix-128)               ; 52 FD BE 80
 cmp.sil (iy)                   ; 52 DD BE 00
 cmp.sil (iy+0)                 ; 52 DD BE 00
 cmp.sil (iy+126)               ; 52 DD BE 7E
 cmp.sil (iy-128)               ; 52 DD BE 80
 cmp.sil a, (hl)                ; 52 BE
 cmp.sil a, (hl+)               ; 52 BE 52 23
 cmp.sil a, (hl-)               ; 52 BE 52 2B
 cmp.sil a, (ix)                ; 52 FD BE 00
 cmp.sil a, (ix+0)              ; 52 FD BE 00
 cmp.sil a, (ix+126)            ; 52 FD BE 7E
 cmp.sil a, (ix-128)            ; 52 FD BE 80
 cmp.sil a, (iy)                ; 52 DD BE 00
 cmp.sil a, (iy+0)              ; 52 DD BE 00
 cmp.sil a, (iy+126)            ; 52 DD BE 7E
 cmp.sil a, (iy-128)            ; 52 DD BE 80
 cnc 0x123456                   ; D4 56 34 12
 cne 0x123456                   ; C4 56 34 12
 cnv 0x123456                   ; E4 56 34 12
 cnz 0x123456                   ; C4 56 34 12
 cp (hl)                        ; BE
 cp (hl+)                       ; BE 23
 cp (hl-)                       ; BE 2B
 cp (ix)                        ; FD BE 00
 cp (ix+0)                      ; FD BE 00
 cp (ix+126)                    ; FD BE 7E
 cp (ix-128)                    ; FD BE 80
 cp (iy)                        ; DD BE 00
 cp (iy+0)                      ; DD BE 00
 cp (iy+126)                    ; DD BE 7E
 cp (iy-128)                    ; DD BE 80
 cp -128                        ; FE 80
 cp 0                           ; FE 00
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; BF
 cp a, (hl)                     ; BE
 cp a, (hl+)                    ; BE 23
 cp a, (hl-)                    ; BE 2B
 cp a, (ix)                     ; FD BE 00
 cp a, (ix+0)                   ; FD BE 00
 cp a, (ix+126)                 ; FD BE 7E
 cp a, (ix-128)                 ; FD BE 80
 cp a, (iy)                     ; DD BE 00
 cp a, (iy+0)                   ; DD BE 00
 cp a, (iy+126)                 ; DD BE 7E
 cp a, (iy-128)                 ; DD BE 80
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
 cp a, ixh                      ; FD BC
 cp a, ixl                      ; FD BD
 cp a, iyh                      ; DD BC
 cp a, iyl                      ; DD BD
 cp a, l                        ; BD
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
 cp.s (hl)                      ; 52 BE
 cp.s (hl+)                     ; 52 BE 52 23
 cp.s (hl-)                     ; 52 BE 52 2B
 cp.s (ix)                      ; 52 FD BE 00
 cp.s (ix+0)                    ; 52 FD BE 00
 cp.s (ix+126)                  ; 52 FD BE 7E
 cp.s (ix-128)                  ; 52 FD BE 80
 cp.s (iy)                      ; 52 DD BE 00
 cp.s (iy+0)                    ; 52 DD BE 00
 cp.s (iy+126)                  ; 52 DD BE 7E
 cp.s (iy-128)                  ; 52 DD BE 80
 cp.s a, (hl)                   ; 52 BE
 cp.s a, (hl+)                  ; 52 BE 52 23
 cp.s a, (hl-)                  ; 52 BE 52 2B
 cp.s a, (ix)                   ; 52 FD BE 00
 cp.s a, (ix+0)                 ; 52 FD BE 00
 cp.s a, (ix+126)               ; 52 FD BE 7E
 cp.s a, (ix-128)               ; 52 FD BE 80
 cp.s a, (iy)                   ; 52 DD BE 00
 cp.s a, (iy+0)                 ; 52 DD BE 00
 cp.s a, (iy+126)               ; 52 DD BE 7E
 cp.s a, (iy-128)               ; 52 DD BE 80
 cp.sil (hl)                    ; 52 BE
 cp.sil (hl+)                   ; 52 BE 52 23
 cp.sil (hl-)                   ; 52 BE 52 2B
 cp.sil (ix)                    ; 52 FD BE 00
 cp.sil (ix+0)                  ; 52 FD BE 00
 cp.sil (ix+126)                ; 52 FD BE 7E
 cp.sil (ix-128)                ; 52 FD BE 80
 cp.sil (iy)                    ; 52 DD BE 00
 cp.sil (iy+0)                  ; 52 DD BE 00
 cp.sil (iy+126)                ; 52 DD BE 7E
 cp.sil (iy-128)                ; 52 DD BE 80
 cp.sil a, (hl)                 ; 52 BE
 cp.sil a, (hl+)                ; 52 BE 52 23
 cp.sil a, (hl-)                ; 52 BE 52 2B
 cp.sil a, (ix)                 ; 52 FD BE 00
 cp.sil a, (ix+0)               ; 52 FD BE 00
 cp.sil a, (ix+126)             ; 52 FD BE 7E
 cp.sil a, (ix-128)             ; 52 FD BE 80
 cp.sil a, (iy)                 ; 52 DD BE 00
 cp.sil a, (iy+0)               ; 52 DD BE 00
 cp.sil a, (iy+126)             ; 52 DD BE 7E
 cp.sil a, (iy-128)             ; 52 DD BE 80
 cpd                            ; ED A9
 cpd.s                          ; 52 ED A9
 cpd.sil                        ; 52 ED A9
 cpdr                           ; ED B9
 cpdr.s                         ; 52 ED B9
 cpdr.sil                       ; 52 ED B9
 cpe 0x123456                   ; EC 56 34 12
 cpi                            ; ED A1
 cpi -128                       ; FE 80
 cpi 0                          ; FE 00
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpi.s                          ; 52 ED A1
 cpi.sil                        ; 52 ED A1
 cpir                           ; ED B1
 cpir.s                         ; 52 ED B1
 cpir.sil                       ; 52 ED B1
 cpl                            ; 2F
 cpl a                          ; 2F
 cpo 0x123456                   ; E4 56 34 12
 cv 0x123456                    ; EC 56 34 12
 cz 0x123456                    ; CC 56 34 12
 daa                            ; 27
 dad b                          ; 09
 dad bc                         ; 09
 dad d                          ; 19
 dad de                         ; 19
 dad h                          ; 29
 dad hl                         ; 29
 dad sp                         ; 39
 dec bc                         ; 0B
 dec de                         ; 1B
 dec hl                         ; 2B
 dec sp                         ; 3B
 dec.s bc                       ; 52 0B
 dec.s de                       ; 52 1B
 dec.s hl                       ; 52 2B
 dec.s sp                       ; 52 3B
 dec.sil bc                     ; 52 0B
 dec.sil de                     ; 52 1B
 dec.sil hl                     ; 52 2B
 dec.sil sp                     ; 52 3B
 dsub                           ; CD @__z80asm__sub_hl_bc
 ex (sp), hl                    ; CD @__z80asm__ex_sp_hl
 inc bc                         ; 03
 inc de                         ; 13
 inc hl                         ; 23
 inc sp                         ; 33
 inc.s bc                       ; 52 03
 inc.s de                       ; 52 13
 inc.s hl                       ; 52 23
 inc.s sp                       ; 52 33
 inc.sil bc                     ; 52 03
 inc.sil de                     ; 52 13
 inc.sil hl                     ; 52 23
 inc.sil sp                     ; 52 33
 ldd                            ; CD @__z80asm__ldd
 lddr                           ; CD @__z80asm__lddr
 ldi                            ; CD @__z80asm__ldi
 ldir                           ; CD @__z80asm__ldir
 or (hl)                        ; B6
 or (hl+)                       ; B6 23
 or (hl-)                       ; B6 2B
 or (ix)                        ; FD B6 00
 or (ix+0)                      ; FD B6 00
 or (ix+126)                    ; FD B6 7E
 or (ix-128)                    ; FD B6 80
 or (iy)                        ; DD B6 00
 or (iy+0)                      ; DD B6 00
 or (iy+126)                    ; DD B6 7E
 or (iy-128)                    ; DD B6 80
 or -128                        ; F6 80
 or 0                           ; F6 00
 or 127                         ; F6 7F
 or 255                         ; F6 FF
 or a                           ; B7
 or a, (hl)                     ; B6
 or a, (hl+)                    ; B6 23
 or a, (hl-)                    ; B6 2B
 or a, (ix)                     ; FD B6 00
 or a, (ix+0)                   ; FD B6 00
 or a, (ix+126)                 ; FD B6 7E
 or a, (ix-128)                 ; FD B6 80
 or a, (iy)                     ; DD B6 00
 or a, (iy+0)                   ; DD B6 00
 or a, (iy+126)                 ; DD B6 7E
 or a, (iy-128)                 ; DD B6 80
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
 or a, ixh                      ; FD B4
 or a, ixl                      ; FD B5
 or a, iyh                      ; DD B4
 or a, iyl                      ; DD B5
 or a, l                        ; B5
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
 or.s (hl)                      ; 52 B6
 or.s (hl+)                     ; 52 B6 52 23
 or.s (hl-)                     ; 52 B6 52 2B
 or.s (ix)                      ; 52 FD B6 00
 or.s (ix+0)                    ; 52 FD B6 00
 or.s (ix+126)                  ; 52 FD B6 7E
 or.s (ix-128)                  ; 52 FD B6 80
 or.s (iy)                      ; 52 DD B6 00
 or.s (iy+0)                    ; 52 DD B6 00
 or.s (iy+126)                  ; 52 DD B6 7E
 or.s (iy-128)                  ; 52 DD B6 80
 or.s a, (hl)                   ; 52 B6
 or.s a, (hl+)                  ; 52 B6 52 23
 or.s a, (hl-)                  ; 52 B6 52 2B
 or.s a, (ix)                   ; 52 FD B6 00
 or.s a, (ix+0)                 ; 52 FD B6 00
 or.s a, (ix+126)               ; 52 FD B6 7E
 or.s a, (ix-128)               ; 52 FD B6 80
 or.s a, (iy)                   ; 52 DD B6 00
 or.s a, (iy+0)                 ; 52 DD B6 00
 or.s a, (iy+126)               ; 52 DD B6 7E
 or.s a, (iy-128)               ; 52 DD B6 80
 or.sil (hl)                    ; 52 B6
 or.sil (hl+)                   ; 52 B6 52 23
 or.sil (hl-)                   ; 52 B6 52 2B
 or.sil (ix)                    ; 52 FD B6 00
 or.sil (ix+0)                  ; 52 FD B6 00
 or.sil (ix+126)                ; 52 FD B6 7E
 or.sil (ix-128)                ; 52 FD B6 80
 or.sil (iy)                    ; 52 DD B6 00
 or.sil (iy+0)                  ; 52 DD B6 00
 or.sil (iy+126)                ; 52 DD B6 7E
 or.sil (iy-128)                ; 52 DD B6 80
 or.sil a, (hl)                 ; 52 B6
 or.sil a, (hl+)                ; 52 B6 52 23
 or.sil a, (hl-)                ; 52 B6 52 2B
 or.sil a, (ix)                 ; 52 FD B6 00
 or.sil a, (ix+0)               ; 52 FD B6 00
 or.sil a, (ix+126)             ; 52 FD B6 7E
 or.sil a, (ix-128)             ; 52 FD B6 80
 or.sil a, (iy)                 ; 52 DD B6 00
 or.sil a, (iy+0)               ; 52 DD B6 00
 or.sil a, (iy+126)             ; 52 DD B6 7E
 or.sil a, (iy-128)             ; 52 DD B6 80
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
 rdel                           ; CD @__z80asm__rl_de
 res 0, (hl)                    ; CB 86
 res 0, (ix)                    ; FD CB 00 86
 res 0, (ix+0)                  ; FD CB 00 86
 res 0, (ix+126)                ; FD CB 7E 86
 res 0, (ix-128)                ; FD CB 80 86
 res 0, (iy)                    ; DD CB 00 86
 res 0, (iy+0)                  ; DD CB 00 86
 res 0, (iy+126)                ; DD CB 7E 86
 res 0, (iy-128)                ; DD CB 80 86
 res 0, a                       ; CB 87
 res 0, b                       ; CB 80
 res 0, c                       ; CB 81
 res 0, d                       ; CB 82
 res 0, e                       ; CB 83
 res 0, h                       ; CB 84
 res 0, l                       ; CB 85
 res 1, (hl)                    ; CB 8E
 res 1, (ix)                    ; FD CB 00 8E
 res 1, (ix+0)                  ; FD CB 00 8E
 res 1, (ix+126)                ; FD CB 7E 8E
 res 1, (ix-128)                ; FD CB 80 8E
 res 1, (iy)                    ; DD CB 00 8E
 res 1, (iy+0)                  ; DD CB 00 8E
 res 1, (iy+126)                ; DD CB 7E 8E
 res 1, (iy-128)                ; DD CB 80 8E
 res 1, a                       ; CB 8F
 res 1, b                       ; CB 88
 res 1, c                       ; CB 89
 res 1, d                       ; CB 8A
 res 1, e                       ; CB 8B
 res 1, h                       ; CB 8C
 res 1, l                       ; CB 8D
 res 2, (hl)                    ; CB 96
 res 2, (ix)                    ; FD CB 00 96
 res 2, (ix+0)                  ; FD CB 00 96
 res 2, (ix+126)                ; FD CB 7E 96
 res 2, (ix-128)                ; FD CB 80 96
 res 2, (iy)                    ; DD CB 00 96
 res 2, (iy+0)                  ; DD CB 00 96
 res 2, (iy+126)                ; DD CB 7E 96
 res 2, (iy-128)                ; DD CB 80 96
 res 2, a                       ; CB 97
 res 2, b                       ; CB 90
 res 2, c                       ; CB 91
 res 2, d                       ; CB 92
 res 2, e                       ; CB 93
 res 2, h                       ; CB 94
 res 2, l                       ; CB 95
 res 3, (hl)                    ; CB 9E
 res 3, (ix)                    ; FD CB 00 9E
 res 3, (ix+0)                  ; FD CB 00 9E
 res 3, (ix+126)                ; FD CB 7E 9E
 res 3, (ix-128)                ; FD CB 80 9E
 res 3, (iy)                    ; DD CB 00 9E
 res 3, (iy+0)                  ; DD CB 00 9E
 res 3, (iy+126)                ; DD CB 7E 9E
 res 3, (iy-128)                ; DD CB 80 9E
 res 3, a                       ; CB 9F
 res 3, b                       ; CB 98
 res 3, c                       ; CB 99
 res 3, d                       ; CB 9A
 res 3, e                       ; CB 9B
 res 3, h                       ; CB 9C
 res 3, l                       ; CB 9D
 res 4, (hl)                    ; CB A6
 res 4, (ix)                    ; FD CB 00 A6
 res 4, (ix+0)                  ; FD CB 00 A6
 res 4, (ix+126)                ; FD CB 7E A6
 res 4, (ix-128)                ; FD CB 80 A6
 res 4, (iy)                    ; DD CB 00 A6
 res 4, (iy+0)                  ; DD CB 00 A6
 res 4, (iy+126)                ; DD CB 7E A6
 res 4, (iy-128)                ; DD CB 80 A6
 res 4, a                       ; CB A7
 res 4, b                       ; CB A0
 res 4, c                       ; CB A1
 res 4, d                       ; CB A2
 res 4, e                       ; CB A3
 res 4, h                       ; CB A4
 res 4, l                       ; CB A5
 res 5, (hl)                    ; CB AE
 res 5, (ix)                    ; FD CB 00 AE
 res 5, (ix+0)                  ; FD CB 00 AE
 res 5, (ix+126)                ; FD CB 7E AE
 res 5, (ix-128)                ; FD CB 80 AE
 res 5, (iy)                    ; DD CB 00 AE
 res 5, (iy+0)                  ; DD CB 00 AE
 res 5, (iy+126)                ; DD CB 7E AE
 res 5, (iy-128)                ; DD CB 80 AE
 res 5, a                       ; CB AF
 res 5, b                       ; CB A8
 res 5, c                       ; CB A9
 res 5, d                       ; CB AA
 res 5, e                       ; CB AB
 res 5, h                       ; CB AC
 res 5, l                       ; CB AD
 res 6, (hl)                    ; CB B6
 res 6, (ix)                    ; FD CB 00 B6
 res 6, (ix+0)                  ; FD CB 00 B6
 res 6, (ix+126)                ; FD CB 7E B6
 res 6, (ix-128)                ; FD CB 80 B6
 res 6, (iy)                    ; DD CB 00 B6
 res 6, (iy+0)                  ; DD CB 00 B6
 res 6, (iy+126)                ; DD CB 7E B6
 res 6, (iy-128)                ; DD CB 80 B6
 res 6, a                       ; CB B7
 res 6, b                       ; CB B0
 res 6, c                       ; CB B1
 res 6, d                       ; CB B2
 res 6, e                       ; CB B3
 res 6, h                       ; CB B4
 res 6, l                       ; CB B5
 res 7, (hl)                    ; CB BE
 res 7, (ix)                    ; FD CB 00 BE
 res 7, (ix+0)                  ; FD CB 00 BE
 res 7, (ix+126)                ; FD CB 7E BE
 res 7, (ix-128)                ; FD CB 80 BE
 res 7, (iy)                    ; DD CB 00 BE
 res 7, (iy+0)                  ; DD CB 00 BE
 res 7, (iy+126)                ; DD CB 7E BE
 res 7, (iy-128)                ; DD CB 80 BE
 res 7, a                       ; CB BF
 res 7, b                       ; CB B8
 res 7, c                       ; CB B9
 res 7, d                       ; CB BA
 res 7, e                       ; CB BB
 res 7, h                       ; CB BC
 res 7, l                       ; CB BD
 res.s 0, (hl)                  ; 52 CB 86
 res.s 0, (ix)                  ; 52 FD CB 00 86
 res.s 0, (ix+0)                ; 52 FD CB 00 86
 res.s 0, (ix+126)              ; 52 FD CB 7E 86
 res.s 0, (ix-128)              ; 52 FD CB 80 86
 res.s 0, (iy)                  ; 52 DD CB 00 86
 res.s 0, (iy+0)                ; 52 DD CB 00 86
 res.s 0, (iy+126)              ; 52 DD CB 7E 86
 res.s 0, (iy-128)              ; 52 DD CB 80 86
 res.s 1, (hl)                  ; 52 CB 8E
 res.s 1, (ix)                  ; 52 FD CB 00 8E
 res.s 1, (ix+0)                ; 52 FD CB 00 8E
 res.s 1, (ix+126)              ; 52 FD CB 7E 8E
 res.s 1, (ix-128)              ; 52 FD CB 80 8E
 res.s 1, (iy)                  ; 52 DD CB 00 8E
 res.s 1, (iy+0)                ; 52 DD CB 00 8E
 res.s 1, (iy+126)              ; 52 DD CB 7E 8E
 res.s 1, (iy-128)              ; 52 DD CB 80 8E
 res.s 2, (hl)                  ; 52 CB 96
 res.s 2, (ix)                  ; 52 FD CB 00 96
 res.s 2, (ix+0)                ; 52 FD CB 00 96
 res.s 2, (ix+126)              ; 52 FD CB 7E 96
 res.s 2, (ix-128)              ; 52 FD CB 80 96
 res.s 2, (iy)                  ; 52 DD CB 00 96
 res.s 2, (iy+0)                ; 52 DD CB 00 96
 res.s 2, (iy+126)              ; 52 DD CB 7E 96
 res.s 2, (iy-128)              ; 52 DD CB 80 96
 res.s 3, (hl)                  ; 52 CB 9E
 res.s 3, (ix)                  ; 52 FD CB 00 9E
 res.s 3, (ix+0)                ; 52 FD CB 00 9E
 res.s 3, (ix+126)              ; 52 FD CB 7E 9E
 res.s 3, (ix-128)              ; 52 FD CB 80 9E
 res.s 3, (iy)                  ; 52 DD CB 00 9E
 res.s 3, (iy+0)                ; 52 DD CB 00 9E
 res.s 3, (iy+126)              ; 52 DD CB 7E 9E
 res.s 3, (iy-128)              ; 52 DD CB 80 9E
 res.s 4, (hl)                  ; 52 CB A6
 res.s 4, (ix)                  ; 52 FD CB 00 A6
 res.s 4, (ix+0)                ; 52 FD CB 00 A6
 res.s 4, (ix+126)              ; 52 FD CB 7E A6
 res.s 4, (ix-128)              ; 52 FD CB 80 A6
 res.s 4, (iy)                  ; 52 DD CB 00 A6
 res.s 4, (iy+0)                ; 52 DD CB 00 A6
 res.s 4, (iy+126)              ; 52 DD CB 7E A6
 res.s 4, (iy-128)              ; 52 DD CB 80 A6
 res.s 5, (hl)                  ; 52 CB AE
 res.s 5, (ix)                  ; 52 FD CB 00 AE
 res.s 5, (ix+0)                ; 52 FD CB 00 AE
 res.s 5, (ix+126)              ; 52 FD CB 7E AE
 res.s 5, (ix-128)              ; 52 FD CB 80 AE
 res.s 5, (iy)                  ; 52 DD CB 00 AE
 res.s 5, (iy+0)                ; 52 DD CB 00 AE
 res.s 5, (iy+126)              ; 52 DD CB 7E AE
 res.s 5, (iy-128)              ; 52 DD CB 80 AE
 res.s 6, (hl)                  ; 52 CB B6
 res.s 6, (ix)                  ; 52 FD CB 00 B6
 res.s 6, (ix+0)                ; 52 FD CB 00 B6
 res.s 6, (ix+126)              ; 52 FD CB 7E B6
 res.s 6, (ix-128)              ; 52 FD CB 80 B6
 res.s 6, (iy)                  ; 52 DD CB 00 B6
 res.s 6, (iy+0)                ; 52 DD CB 00 B6
 res.s 6, (iy+126)              ; 52 DD CB 7E B6
 res.s 6, (iy-128)              ; 52 DD CB 80 B6
 res.s 7, (hl)                  ; 52 CB BE
 res.s 7, (ix)                  ; 52 FD CB 00 BE
 res.s 7, (ix+0)                ; 52 FD CB 00 BE
 res.s 7, (ix+126)              ; 52 FD CB 7E BE
 res.s 7, (ix-128)              ; 52 FD CB 80 BE
 res.s 7, (iy)                  ; 52 DD CB 00 BE
 res.s 7, (iy+0)                ; 52 DD CB 00 BE
 res.s 7, (iy+126)              ; 52 DD CB 7E BE
 res.s 7, (iy-128)              ; 52 DD CB 80 BE
 res.sil 0, (hl)                ; 52 CB 86
 res.sil 0, (ix)                ; 52 FD CB 00 86
 res.sil 0, (ix+0)              ; 52 FD CB 00 86
 res.sil 0, (ix+126)            ; 52 FD CB 7E 86
 res.sil 0, (ix-128)            ; 52 FD CB 80 86
 res.sil 0, (iy)                ; 52 DD CB 00 86
 res.sil 0, (iy+0)              ; 52 DD CB 00 86
 res.sil 0, (iy+126)            ; 52 DD CB 7E 86
 res.sil 0, (iy-128)            ; 52 DD CB 80 86
 res.sil 1, (hl)                ; 52 CB 8E
 res.sil 1, (ix)                ; 52 FD CB 00 8E
 res.sil 1, (ix+0)              ; 52 FD CB 00 8E
 res.sil 1, (ix+126)            ; 52 FD CB 7E 8E
 res.sil 1, (ix-128)            ; 52 FD CB 80 8E
 res.sil 1, (iy)                ; 52 DD CB 00 8E
 res.sil 1, (iy+0)              ; 52 DD CB 00 8E
 res.sil 1, (iy+126)            ; 52 DD CB 7E 8E
 res.sil 1, (iy-128)            ; 52 DD CB 80 8E
 res.sil 2, (hl)                ; 52 CB 96
 res.sil 2, (ix)                ; 52 FD CB 00 96
 res.sil 2, (ix+0)              ; 52 FD CB 00 96
 res.sil 2, (ix+126)            ; 52 FD CB 7E 96
 res.sil 2, (ix-128)            ; 52 FD CB 80 96
 res.sil 2, (iy)                ; 52 DD CB 00 96
 res.sil 2, (iy+0)              ; 52 DD CB 00 96
 res.sil 2, (iy+126)            ; 52 DD CB 7E 96
 res.sil 2, (iy-128)            ; 52 DD CB 80 96
 res.sil 3, (hl)                ; 52 CB 9E
 res.sil 3, (ix)                ; 52 FD CB 00 9E
 res.sil 3, (ix+0)              ; 52 FD CB 00 9E
 res.sil 3, (ix+126)            ; 52 FD CB 7E 9E
 res.sil 3, (ix-128)            ; 52 FD CB 80 9E
 res.sil 3, (iy)                ; 52 DD CB 00 9E
 res.sil 3, (iy+0)              ; 52 DD CB 00 9E
 res.sil 3, (iy+126)            ; 52 DD CB 7E 9E
 res.sil 3, (iy-128)            ; 52 DD CB 80 9E
 res.sil 4, (hl)                ; 52 CB A6
 res.sil 4, (ix)                ; 52 FD CB 00 A6
 res.sil 4, (ix+0)              ; 52 FD CB 00 A6
 res.sil 4, (ix+126)            ; 52 FD CB 7E A6
 res.sil 4, (ix-128)            ; 52 FD CB 80 A6
 res.sil 4, (iy)                ; 52 DD CB 00 A6
 res.sil 4, (iy+0)              ; 52 DD CB 00 A6
 res.sil 4, (iy+126)            ; 52 DD CB 7E A6
 res.sil 4, (iy-128)            ; 52 DD CB 80 A6
 res.sil 5, (hl)                ; 52 CB AE
 res.sil 5, (ix)                ; 52 FD CB 00 AE
 res.sil 5, (ix+0)              ; 52 FD CB 00 AE
 res.sil 5, (ix+126)            ; 52 FD CB 7E AE
 res.sil 5, (ix-128)            ; 52 FD CB 80 AE
 res.sil 5, (iy)                ; 52 DD CB 00 AE
 res.sil 5, (iy+0)              ; 52 DD CB 00 AE
 res.sil 5, (iy+126)            ; 52 DD CB 7E AE
 res.sil 5, (iy-128)            ; 52 DD CB 80 AE
 res.sil 6, (hl)                ; 52 CB B6
 res.sil 6, (ix)                ; 52 FD CB 00 B6
 res.sil 6, (ix+0)              ; 52 FD CB 00 B6
 res.sil 6, (ix+126)            ; 52 FD CB 7E B6
 res.sil 6, (ix-128)            ; 52 FD CB 80 B6
 res.sil 6, (iy)                ; 52 DD CB 00 B6
 res.sil 6, (iy+0)              ; 52 DD CB 00 B6
 res.sil 6, (iy+126)            ; 52 DD CB 7E B6
 res.sil 6, (iy-128)            ; 52 DD CB 80 B6
 res.sil 7, (hl)                ; 52 CB BE
 res.sil 7, (ix)                ; 52 FD CB 00 BE
 res.sil 7, (ix+0)              ; 52 FD CB 00 BE
 res.sil 7, (ix+126)            ; 52 FD CB 7E BE
 res.sil 7, (ix-128)            ; 52 FD CB 80 BE
 res.sil 7, (iy)                ; 52 DD CB 00 BE
 res.sil 7, (iy+0)              ; 52 DD CB 00 BE
 res.sil 7, (iy+126)            ; 52 DD CB 7E BE
 res.sil 7, (iy-128)            ; 52 DD CB 80 BE
 rl bc                          ; CD @__z80asm__rl_bc
 rl de                          ; CD @__z80asm__rl_de
 rl hl                          ; CD @__z80asm__rl_hl
 rld                            ; CD @__z80asm__rld
 rlde                           ; CD @__z80asm__rl_de
 rr bc                          ; CD @__z80asm__rr_bc
 rr de                          ; CD @__z80asm__rr_de
 rr hl                          ; CD @__z80asm__rr_hl
 rrd                            ; CD @__z80asm__rrd
 rrhl                           ; CD @__z80asm__sra_hl
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
 sbc (ix)                       ; FD 9E 00
 sbc (ix+0)                     ; FD 9E 00
 sbc (ix+126)                   ; FD 9E 7E
 sbc (ix-128)                   ; FD 9E 80
 sbc (iy)                       ; DD 9E 00
 sbc (iy+0)                     ; DD 9E 00
 sbc (iy+126)                   ; DD 9E 7E
 sbc (iy-128)                   ; DD 9E 80
 sbc -128                       ; DE 80
 sbc 0                          ; DE 00
 sbc 127                        ; DE 7F
 sbc 255                        ; DE FF
 sbc a                          ; 9F
 sbc a, (hl)                    ; 9E
 sbc a, (hl+)                   ; 9E 23
 sbc a, (hl-)                   ; 9E 2B
 sbc a, (ix)                    ; FD 9E 00
 sbc a, (ix+0)                  ; FD 9E 00
 sbc a, (ix+126)                ; FD 9E 7E
 sbc a, (ix-128)                ; FD 9E 80
 sbc a, (iy)                    ; DD 9E 00
 sbc a, (iy+0)                  ; DD 9E 00
 sbc a, (iy+126)                ; DD 9E 7E
 sbc a, (iy-128)                ; DD 9E 80
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
 sbc a, ixh                     ; FD 9C
 sbc a, ixl                     ; FD 9D
 sbc a, iyh                     ; DD 9C
 sbc a, iyl                     ; DD 9D
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
 sbc ixh                        ; FD 9C
 sbc ixl                        ; FD 9D
 sbc iyh                        ; DD 9C
 sbc iyl                        ; DD 9D
 sbc l                          ; 9D
 sbc.s (hl)                     ; 52 9E
 sbc.s (hl+)                    ; 52 9E 52 23
 sbc.s (hl-)                    ; 52 9E 52 2B
 sbc.s (ix)                     ; 52 FD 9E 00
 sbc.s (ix+0)                   ; 52 FD 9E 00
 sbc.s (ix+126)                 ; 52 FD 9E 7E
 sbc.s (ix-128)                 ; 52 FD 9E 80
 sbc.s (iy)                     ; 52 DD 9E 00
 sbc.s (iy+0)                   ; 52 DD 9E 00
 sbc.s (iy+126)                 ; 52 DD 9E 7E
 sbc.s (iy-128)                 ; 52 DD 9E 80
 sbc.s a, (hl)                  ; 52 9E
 sbc.s a, (hl+)                 ; 52 9E 52 23
 sbc.s a, (hl-)                 ; 52 9E 52 2B
 sbc.s a, (ix)                  ; 52 FD 9E 00
 sbc.s a, (ix+0)                ; 52 FD 9E 00
 sbc.s a, (ix+126)              ; 52 FD 9E 7E
 sbc.s a, (ix-128)              ; 52 FD 9E 80
 sbc.s a, (iy)                  ; 52 DD 9E 00
 sbc.s a, (iy+0)                ; 52 DD 9E 00
 sbc.s a, (iy+126)              ; 52 DD 9E 7E
 sbc.s a, (iy-128)              ; 52 DD 9E 80
 sbc.s hl, bc                   ; 52 ED 42
 sbc.s hl, de                   ; 52 ED 52
 sbc.s hl, hl                   ; 52 ED 62
 sbc.s hl, sp                   ; 52 ED 72
 sbc.sil (hl)                   ; 52 9E
 sbc.sil (hl+)                  ; 52 9E 52 23
 sbc.sil (hl-)                  ; 52 9E 52 2B
 sbc.sil (ix)                   ; 52 FD 9E 00
 sbc.sil (ix+0)                 ; 52 FD 9E 00
 sbc.sil (ix+126)               ; 52 FD 9E 7E
 sbc.sil (ix-128)               ; 52 FD 9E 80
 sbc.sil (iy)                   ; 52 DD 9E 00
 sbc.sil (iy+0)                 ; 52 DD 9E 00
 sbc.sil (iy+126)               ; 52 DD 9E 7E
 sbc.sil (iy-128)               ; 52 DD 9E 80
 sbc.sil a, (hl)                ; 52 9E
 sbc.sil a, (hl+)               ; 52 9E 52 23
 sbc.sil a, (hl-)               ; 52 9E 52 2B
 sbc.sil a, (ix)                ; 52 FD 9E 00
 sbc.sil a, (ix+0)              ; 52 FD 9E 00
 sbc.sil a, (ix+126)            ; 52 FD 9E 7E
 sbc.sil a, (ix-128)            ; 52 FD 9E 80
 sbc.sil a, (iy)                ; 52 DD 9E 00
 sbc.sil a, (iy+0)              ; 52 DD 9E 00
 sbc.sil a, (iy+126)            ; 52 DD 9E 7E
 sbc.sil a, (iy-128)            ; 52 DD 9E 80
 sbc.sil hl, bc                 ; 52 ED 42
 sbc.sil hl, de                 ; 52 ED 52
 sbc.sil hl, hl                 ; 52 ED 62
 sbc.sil hl, sp                 ; 52 ED 72
 sbi -128                       ; DE 80
 sbi 0                          ; DE 00
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 set 0, (hl)                    ; CB C6
 set 0, (ix)                    ; FD CB 00 C6
 set 0, (ix+0)                  ; FD CB 00 C6
 set 0, (ix+126)                ; FD CB 7E C6
 set 0, (ix-128)                ; FD CB 80 C6
 set 0, (iy)                    ; DD CB 00 C6
 set 0, (iy+0)                  ; DD CB 00 C6
 set 0, (iy+126)                ; DD CB 7E C6
 set 0, (iy-128)                ; DD CB 80 C6
 set 0, a                       ; CB C7
 set 0, b                       ; CB C0
 set 0, c                       ; CB C1
 set 0, d                       ; CB C2
 set 0, e                       ; CB C3
 set 0, h                       ; CB C4
 set 0, l                       ; CB C5
 set 1, (hl)                    ; CB CE
 set 1, (ix)                    ; FD CB 00 CE
 set 1, (ix+0)                  ; FD CB 00 CE
 set 1, (ix+126)                ; FD CB 7E CE
 set 1, (ix-128)                ; FD CB 80 CE
 set 1, (iy)                    ; DD CB 00 CE
 set 1, (iy+0)                  ; DD CB 00 CE
 set 1, (iy+126)                ; DD CB 7E CE
 set 1, (iy-128)                ; DD CB 80 CE
 set 1, a                       ; CB CF
 set 1, b                       ; CB C8
 set 1, c                       ; CB C9
 set 1, d                       ; CB CA
 set 1, e                       ; CB CB
 set 1, h                       ; CB CC
 set 1, l                       ; CB CD
 set 2, (hl)                    ; CB D6
 set 2, (ix)                    ; FD CB 00 D6
 set 2, (ix+0)                  ; FD CB 00 D6
 set 2, (ix+126)                ; FD CB 7E D6
 set 2, (ix-128)                ; FD CB 80 D6
 set 2, (iy)                    ; DD CB 00 D6
 set 2, (iy+0)                  ; DD CB 00 D6
 set 2, (iy+126)                ; DD CB 7E D6
 set 2, (iy-128)                ; DD CB 80 D6
 set 2, a                       ; CB D7
 set 2, b                       ; CB D0
 set 2, c                       ; CB D1
 set 2, d                       ; CB D2
 set 2, e                       ; CB D3
 set 2, h                       ; CB D4
 set 2, l                       ; CB D5
 set 3, (hl)                    ; CB DE
 set 3, (ix)                    ; FD CB 00 DE
 set 3, (ix+0)                  ; FD CB 00 DE
 set 3, (ix+126)                ; FD CB 7E DE
 set 3, (ix-128)                ; FD CB 80 DE
 set 3, (iy)                    ; DD CB 00 DE
 set 3, (iy+0)                  ; DD CB 00 DE
 set 3, (iy+126)                ; DD CB 7E DE
 set 3, (iy-128)                ; DD CB 80 DE
 set 3, a                       ; CB DF
 set 3, b                       ; CB D8
 set 3, c                       ; CB D9
 set 3, d                       ; CB DA
 set 3, e                       ; CB DB
 set 3, h                       ; CB DC
 set 3, l                       ; CB DD
 set 4, (hl)                    ; CB E6
 set 4, (ix)                    ; FD CB 00 E6
 set 4, (ix+0)                  ; FD CB 00 E6
 set 4, (ix+126)                ; FD CB 7E E6
 set 4, (ix-128)                ; FD CB 80 E6
 set 4, (iy)                    ; DD CB 00 E6
 set 4, (iy+0)                  ; DD CB 00 E6
 set 4, (iy+126)                ; DD CB 7E E6
 set 4, (iy-128)                ; DD CB 80 E6
 set 4, a                       ; CB E7
 set 4, b                       ; CB E0
 set 4, c                       ; CB E1
 set 4, d                       ; CB E2
 set 4, e                       ; CB E3
 set 4, h                       ; CB E4
 set 4, l                       ; CB E5
 set 5, (hl)                    ; CB EE
 set 5, (ix)                    ; FD CB 00 EE
 set 5, (ix+0)                  ; FD CB 00 EE
 set 5, (ix+126)                ; FD CB 7E EE
 set 5, (ix-128)                ; FD CB 80 EE
 set 5, (iy)                    ; DD CB 00 EE
 set 5, (iy+0)                  ; DD CB 00 EE
 set 5, (iy+126)                ; DD CB 7E EE
 set 5, (iy-128)                ; DD CB 80 EE
 set 5, a                       ; CB EF
 set 5, b                       ; CB E8
 set 5, c                       ; CB E9
 set 5, d                       ; CB EA
 set 5, e                       ; CB EB
 set 5, h                       ; CB EC
 set 5, l                       ; CB ED
 set 6, (hl)                    ; CB F6
 set 6, (ix)                    ; FD CB 00 F6
 set 6, (ix+0)                  ; FD CB 00 F6
 set 6, (ix+126)                ; FD CB 7E F6
 set 6, (ix-128)                ; FD CB 80 F6
 set 6, (iy)                    ; DD CB 00 F6
 set 6, (iy+0)                  ; DD CB 00 F6
 set 6, (iy+126)                ; DD CB 7E F6
 set 6, (iy-128)                ; DD CB 80 F6
 set 6, a                       ; CB F7
 set 6, b                       ; CB F0
 set 6, c                       ; CB F1
 set 6, d                       ; CB F2
 set 6, e                       ; CB F3
 set 6, h                       ; CB F4
 set 6, l                       ; CB F5
 set 7, (hl)                    ; CB FE
 set 7, (ix)                    ; FD CB 00 FE
 set 7, (ix+0)                  ; FD CB 00 FE
 set 7, (ix+126)                ; FD CB 7E FE
 set 7, (ix-128)                ; FD CB 80 FE
 set 7, (iy)                    ; DD CB 00 FE
 set 7, (iy+0)                  ; DD CB 00 FE
 set 7, (iy+126)                ; DD CB 7E FE
 set 7, (iy-128)                ; DD CB 80 FE
 set 7, a                       ; CB FF
 set 7, b                       ; CB F8
 set 7, c                       ; CB F9
 set 7, d                       ; CB FA
 set 7, e                       ; CB FB
 set 7, h                       ; CB FC
 set 7, l                       ; CB FD
 set.s 0, (hl)                  ; 52 CB C6
 set.s 0, (ix)                  ; 52 FD CB 00 C6
 set.s 0, (ix+0)                ; 52 FD CB 00 C6
 set.s 0, (ix+126)              ; 52 FD CB 7E C6
 set.s 0, (ix-128)              ; 52 FD CB 80 C6
 set.s 0, (iy)                  ; 52 DD CB 00 C6
 set.s 0, (iy+0)                ; 52 DD CB 00 C6
 set.s 0, (iy+126)              ; 52 DD CB 7E C6
 set.s 0, (iy-128)              ; 52 DD CB 80 C6
 set.s 1, (hl)                  ; 52 CB CE
 set.s 1, (ix)                  ; 52 FD CB 00 CE
 set.s 1, (ix+0)                ; 52 FD CB 00 CE
 set.s 1, (ix+126)              ; 52 FD CB 7E CE
 set.s 1, (ix-128)              ; 52 FD CB 80 CE
 set.s 1, (iy)                  ; 52 DD CB 00 CE
 set.s 1, (iy+0)                ; 52 DD CB 00 CE
 set.s 1, (iy+126)              ; 52 DD CB 7E CE
 set.s 1, (iy-128)              ; 52 DD CB 80 CE
 set.s 2, (hl)                  ; 52 CB D6
 set.s 2, (ix)                  ; 52 FD CB 00 D6
 set.s 2, (ix+0)                ; 52 FD CB 00 D6
 set.s 2, (ix+126)              ; 52 FD CB 7E D6
 set.s 2, (ix-128)              ; 52 FD CB 80 D6
 set.s 2, (iy)                  ; 52 DD CB 00 D6
 set.s 2, (iy+0)                ; 52 DD CB 00 D6
 set.s 2, (iy+126)              ; 52 DD CB 7E D6
 set.s 2, (iy-128)              ; 52 DD CB 80 D6
 set.s 3, (hl)                  ; 52 CB DE
 set.s 3, (ix)                  ; 52 FD CB 00 DE
 set.s 3, (ix+0)                ; 52 FD CB 00 DE
 set.s 3, (ix+126)              ; 52 FD CB 7E DE
 set.s 3, (ix-128)              ; 52 FD CB 80 DE
 set.s 3, (iy)                  ; 52 DD CB 00 DE
 set.s 3, (iy+0)                ; 52 DD CB 00 DE
 set.s 3, (iy+126)              ; 52 DD CB 7E DE
 set.s 3, (iy-128)              ; 52 DD CB 80 DE
 set.s 4, (hl)                  ; 52 CB E6
 set.s 4, (ix)                  ; 52 FD CB 00 E6
 set.s 4, (ix+0)                ; 52 FD CB 00 E6
 set.s 4, (ix+126)              ; 52 FD CB 7E E6
 set.s 4, (ix-128)              ; 52 FD CB 80 E6
 set.s 4, (iy)                  ; 52 DD CB 00 E6
 set.s 4, (iy+0)                ; 52 DD CB 00 E6
 set.s 4, (iy+126)              ; 52 DD CB 7E E6
 set.s 4, (iy-128)              ; 52 DD CB 80 E6
 set.s 5, (hl)                  ; 52 CB EE
 set.s 5, (ix)                  ; 52 FD CB 00 EE
 set.s 5, (ix+0)                ; 52 FD CB 00 EE
 set.s 5, (ix+126)              ; 52 FD CB 7E EE
 set.s 5, (ix-128)              ; 52 FD CB 80 EE
 set.s 5, (iy)                  ; 52 DD CB 00 EE
 set.s 5, (iy+0)                ; 52 DD CB 00 EE
 set.s 5, (iy+126)              ; 52 DD CB 7E EE
 set.s 5, (iy-128)              ; 52 DD CB 80 EE
 set.s 6, (hl)                  ; 52 CB F6
 set.s 6, (ix)                  ; 52 FD CB 00 F6
 set.s 6, (ix+0)                ; 52 FD CB 00 F6
 set.s 6, (ix+126)              ; 52 FD CB 7E F6
 set.s 6, (ix-128)              ; 52 FD CB 80 F6
 set.s 6, (iy)                  ; 52 DD CB 00 F6
 set.s 6, (iy+0)                ; 52 DD CB 00 F6
 set.s 6, (iy+126)              ; 52 DD CB 7E F6
 set.s 6, (iy-128)              ; 52 DD CB 80 F6
 set.s 7, (hl)                  ; 52 CB FE
 set.s 7, (ix)                  ; 52 FD CB 00 FE
 set.s 7, (ix+0)                ; 52 FD CB 00 FE
 set.s 7, (ix+126)              ; 52 FD CB 7E FE
 set.s 7, (ix-128)              ; 52 FD CB 80 FE
 set.s 7, (iy)                  ; 52 DD CB 00 FE
 set.s 7, (iy+0)                ; 52 DD CB 00 FE
 set.s 7, (iy+126)              ; 52 DD CB 7E FE
 set.s 7, (iy-128)              ; 52 DD CB 80 FE
 set.sil 0, (hl)                ; 52 CB C6
 set.sil 0, (ix)                ; 52 FD CB 00 C6
 set.sil 0, (ix+0)              ; 52 FD CB 00 C6
 set.sil 0, (ix+126)            ; 52 FD CB 7E C6
 set.sil 0, (ix-128)            ; 52 FD CB 80 C6
 set.sil 0, (iy)                ; 52 DD CB 00 C6
 set.sil 0, (iy+0)              ; 52 DD CB 00 C6
 set.sil 0, (iy+126)            ; 52 DD CB 7E C6
 set.sil 0, (iy-128)            ; 52 DD CB 80 C6
 set.sil 1, (hl)                ; 52 CB CE
 set.sil 1, (ix)                ; 52 FD CB 00 CE
 set.sil 1, (ix+0)              ; 52 FD CB 00 CE
 set.sil 1, (ix+126)            ; 52 FD CB 7E CE
 set.sil 1, (ix-128)            ; 52 FD CB 80 CE
 set.sil 1, (iy)                ; 52 DD CB 00 CE
 set.sil 1, (iy+0)              ; 52 DD CB 00 CE
 set.sil 1, (iy+126)            ; 52 DD CB 7E CE
 set.sil 1, (iy-128)            ; 52 DD CB 80 CE
 set.sil 2, (hl)                ; 52 CB D6
 set.sil 2, (ix)                ; 52 FD CB 00 D6
 set.sil 2, (ix+0)              ; 52 FD CB 00 D6
 set.sil 2, (ix+126)            ; 52 FD CB 7E D6
 set.sil 2, (ix-128)            ; 52 FD CB 80 D6
 set.sil 2, (iy)                ; 52 DD CB 00 D6
 set.sil 2, (iy+0)              ; 52 DD CB 00 D6
 set.sil 2, (iy+126)            ; 52 DD CB 7E D6
 set.sil 2, (iy-128)            ; 52 DD CB 80 D6
 set.sil 3, (hl)                ; 52 CB DE
 set.sil 3, (ix)                ; 52 FD CB 00 DE
 set.sil 3, (ix+0)              ; 52 FD CB 00 DE
 set.sil 3, (ix+126)            ; 52 FD CB 7E DE
 set.sil 3, (ix-128)            ; 52 FD CB 80 DE
 set.sil 3, (iy)                ; 52 DD CB 00 DE
 set.sil 3, (iy+0)              ; 52 DD CB 00 DE
 set.sil 3, (iy+126)            ; 52 DD CB 7E DE
 set.sil 3, (iy-128)            ; 52 DD CB 80 DE
 set.sil 4, (hl)                ; 52 CB E6
 set.sil 4, (ix)                ; 52 FD CB 00 E6
 set.sil 4, (ix+0)              ; 52 FD CB 00 E6
 set.sil 4, (ix+126)            ; 52 FD CB 7E E6
 set.sil 4, (ix-128)            ; 52 FD CB 80 E6
 set.sil 4, (iy)                ; 52 DD CB 00 E6
 set.sil 4, (iy+0)              ; 52 DD CB 00 E6
 set.sil 4, (iy+126)            ; 52 DD CB 7E E6
 set.sil 4, (iy-128)            ; 52 DD CB 80 E6
 set.sil 5, (hl)                ; 52 CB EE
 set.sil 5, (ix)                ; 52 FD CB 00 EE
 set.sil 5, (ix+0)              ; 52 FD CB 00 EE
 set.sil 5, (ix+126)            ; 52 FD CB 7E EE
 set.sil 5, (ix-128)            ; 52 FD CB 80 EE
 set.sil 5, (iy)                ; 52 DD CB 00 EE
 set.sil 5, (iy+0)              ; 52 DD CB 00 EE
 set.sil 5, (iy+126)            ; 52 DD CB 7E EE
 set.sil 5, (iy-128)            ; 52 DD CB 80 EE
 set.sil 6, (hl)                ; 52 CB F6
 set.sil 6, (ix)                ; 52 FD CB 00 F6
 set.sil 6, (ix+0)              ; 52 FD CB 00 F6
 set.sil 6, (ix+126)            ; 52 FD CB 7E F6
 set.sil 6, (ix-128)            ; 52 FD CB 80 F6
 set.sil 6, (iy)                ; 52 DD CB 00 F6
 set.sil 6, (iy+0)              ; 52 DD CB 00 F6
 set.sil 6, (iy+126)            ; 52 DD CB 7E F6
 set.sil 6, (iy-128)            ; 52 DD CB 80 F6
 set.sil 7, (hl)                ; 52 CB FE
 set.sil 7, (ix)                ; 52 FD CB 00 FE
 set.sil 7, (ix+0)              ; 52 FD CB 00 FE
 set.sil 7, (ix+126)            ; 52 FD CB 7E FE
 set.sil 7, (ix-128)            ; 52 FD CB 80 FE
 set.sil 7, (iy)                ; 52 DD CB 00 FE
 set.sil 7, (iy+0)              ; 52 DD CB 00 FE
 set.sil 7, (iy+126)            ; 52 DD CB 7E FE
 set.sil 7, (iy-128)            ; 52 DD CB 80 FE
 sra bc                         ; CD @__z80asm__sra_bc
 sra de                         ; CD @__z80asm__sra_de
 sra hl                         ; CD @__z80asm__sra_hl
 sub (hl)                       ; 96
 sub (hl+)                      ; 96 23
 sub (hl-)                      ; 96 2B
 sub (ix)                       ; FD 96 00
 sub (ix+0)                     ; FD 96 00
 sub (ix+126)                   ; FD 96 7E
 sub (ix-128)                   ; FD 96 80
 sub (iy)                       ; DD 96 00
 sub (iy+0)                     ; DD 96 00
 sub (iy+126)                   ; DD 96 7E
 sub (iy-128)                   ; DD 96 80
 sub -128                       ; D6 80
 sub 0                          ; D6 00
 sub 127                        ; D6 7F
 sub 255                        ; D6 FF
 sub a                          ; 97
 sub a, (hl)                    ; 96
 sub a, (hl+)                   ; 96 23
 sub a, (hl-)                   ; 96 2B
 sub a, (ix)                    ; FD 96 00
 sub a, (ix+0)                  ; FD 96 00
 sub a, (ix+126)                ; FD 96 7E
 sub a, (ix-128)                ; FD 96 80
 sub a, (iy)                    ; DD 96 00
 sub a, (iy+0)                  ; DD 96 00
 sub a, (iy+126)                ; DD 96 7E
 sub a, (iy-128)                ; DD 96 80
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
 sub a, ixh                     ; FD 94
 sub a, ixl                     ; FD 95
 sub a, iyh                     ; DD 94
 sub a, iyl                     ; DD 95
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
 sub ixh                        ; FD 94
 sub ixl                        ; FD 95
 sub iyh                        ; DD 94
 sub iyl                        ; DD 95
 sub l                          ; 95
 sub m                          ; 96
 sub.s (hl)                     ; 52 96
 sub.s (hl+)                    ; 52 96 52 23
 sub.s (hl-)                    ; 52 96 52 2B
 sub.s (ix)                     ; 52 FD 96 00
 sub.s (ix+0)                   ; 52 FD 96 00
 sub.s (ix+126)                 ; 52 FD 96 7E
 sub.s (ix-128)                 ; 52 FD 96 80
 sub.s (iy)                     ; 52 DD 96 00
 sub.s (iy+0)                   ; 52 DD 96 00
 sub.s (iy+126)                 ; 52 DD 96 7E
 sub.s (iy-128)                 ; 52 DD 96 80
 sub.s a, (hl)                  ; 52 96
 sub.s a, (hl+)                 ; 52 96 52 23
 sub.s a, (hl-)                 ; 52 96 52 2B
 sub.s a, (ix)                  ; 52 FD 96 00
 sub.s a, (ix+0)                ; 52 FD 96 00
 sub.s a, (ix+126)              ; 52 FD 96 7E
 sub.s a, (ix-128)              ; 52 FD 96 80
 sub.s a, (iy)                  ; 52 DD 96 00
 sub.s a, (iy+0)                ; 52 DD 96 00
 sub.s a, (iy+126)              ; 52 DD 96 7E
 sub.s a, (iy-128)              ; 52 DD 96 80
 sub.sil (hl)                   ; 52 96
 sub.sil (hl+)                  ; 52 96 52 23
 sub.sil (hl-)                  ; 52 96 52 2B
 sub.sil (ix)                   ; 52 FD 96 00
 sub.sil (ix+0)                 ; 52 FD 96 00
 sub.sil (ix+126)               ; 52 FD 96 7E
 sub.sil (ix-128)               ; 52 FD 96 80
 sub.sil (iy)                   ; 52 DD 96 00
 sub.sil (iy+0)                 ; 52 DD 96 00
 sub.sil (iy+126)               ; 52 DD 96 7E
 sub.sil (iy-128)               ; 52 DD 96 80
 sub.sil a, (hl)                ; 52 96
 sub.sil a, (hl+)               ; 52 96 52 23
 sub.sil a, (hl-)               ; 52 96 52 2B
 sub.sil a, (ix)                ; 52 FD 96 00
 sub.sil a, (ix+0)              ; 52 FD 96 00
 sub.sil a, (ix+126)            ; 52 FD 96 7E
 sub.sil a, (ix-128)            ; 52 FD 96 80
 sub.sil a, (iy)                ; 52 DD 96 00
 sub.sil a, (iy+0)              ; 52 DD 96 00
 sub.sil a, (iy+126)            ; 52 DD 96 7E
 sub.sil a, (iy-128)            ; 52 DD 96 80
 sui -128                       ; D6 80
 sui 0                          ; D6 00
 sui 127                        ; D6 7F
 sui 255                        ; D6 FF
 xor (hl)                       ; AE
 xor (hl+)                      ; AE 23
 xor (hl-)                      ; AE 2B
 xor (ix)                       ; FD AE 00
 xor (ix+0)                     ; FD AE 00
 xor (ix+126)                   ; FD AE 7E
 xor (ix-128)                   ; FD AE 80
 xor (iy)                       ; DD AE 00
 xor (iy+0)                     ; DD AE 00
 xor (iy+126)                   ; DD AE 7E
 xor (iy-128)                   ; DD AE 80
 xor -128                       ; EE 80
 xor 0                          ; EE 00
 xor 127                        ; EE 7F
 xor 255                        ; EE FF
 xor a                          ; AF
 xor a, (hl)                    ; AE
 xor a, (hl+)                   ; AE 23
 xor a, (hl-)                   ; AE 2B
 xor a, (ix)                    ; FD AE 00
 xor a, (ix+0)                  ; FD AE 00
 xor a, (ix+126)                ; FD AE 7E
 xor a, (ix-128)                ; FD AE 80
 xor a, (iy)                    ; DD AE 00
 xor a, (iy+0)                  ; DD AE 00
 xor a, (iy+126)                ; DD AE 7E
 xor a, (iy-128)                ; DD AE 80
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
 xor a, ixh                     ; FD AC
 xor a, ixl                     ; FD AD
 xor a, iyh                     ; DD AC
 xor a, iyl                     ; DD AD
 xor a, l                       ; AD
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
 xor.s (hl)                     ; 52 AE
 xor.s (hl+)                    ; 52 AE 52 23
 xor.s (hl-)                    ; 52 AE 52 2B
 xor.s (ix)                     ; 52 FD AE 00
 xor.s (ix+0)                   ; 52 FD AE 00
 xor.s (ix+126)                 ; 52 FD AE 7E
 xor.s (ix-128)                 ; 52 FD AE 80
 xor.s (iy)                     ; 52 DD AE 00
 xor.s (iy+0)                   ; 52 DD AE 00
 xor.s (iy+126)                 ; 52 DD AE 7E
 xor.s (iy-128)                 ; 52 DD AE 80
 xor.s a, (hl)                  ; 52 AE
 xor.s a, (hl+)                 ; 52 AE 52 23
 xor.s a, (hl-)                 ; 52 AE 52 2B
 xor.s a, (ix)                  ; 52 FD AE 00
 xor.s a, (ix+0)                ; 52 FD AE 00
 xor.s a, (ix+126)              ; 52 FD AE 7E
 xor.s a, (ix-128)              ; 52 FD AE 80
 xor.s a, (iy)                  ; 52 DD AE 00
 xor.s a, (iy+0)                ; 52 DD AE 00
 xor.s a, (iy+126)              ; 52 DD AE 7E
 xor.s a, (iy-128)              ; 52 DD AE 80
 xor.sil (hl)                   ; 52 AE
 xor.sil (hl+)                  ; 52 AE 52 23
 xor.sil (hl-)                  ; 52 AE 52 2B
 xor.sil (ix)                   ; 52 FD AE 00
 xor.sil (ix+0)                 ; 52 FD AE 00
 xor.sil (ix+126)               ; 52 FD AE 7E
 xor.sil (ix-128)               ; 52 FD AE 80
 xor.sil (iy)                   ; 52 DD AE 00
 xor.sil (iy+0)                 ; 52 DD AE 00
 xor.sil (iy+126)               ; 52 DD AE 7E
 xor.sil (iy-128)               ; 52 DD AE 80
 xor.sil a, (hl)                ; 52 AE
 xor.sil a, (hl+)               ; 52 AE 52 23
 xor.sil a, (hl-)               ; 52 AE 52 2B
 xor.sil a, (ix)                ; 52 FD AE 00
 xor.sil a, (ix+0)              ; 52 FD AE 00
 xor.sil a, (ix+126)            ; 52 FD AE 7E
 xor.sil a, (ix-128)            ; 52 FD AE 80
 xor.sil a, (iy)                ; 52 DD AE 00
 xor.sil a, (iy+0)              ; 52 DD AE 00
 xor.sil a, (iy+126)            ; 52 DD AE 7E
 xor.sil a, (iy-128)            ; 52 DD AE 80
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
 xthl                           ; CD @__z80asm__ex_sp_hl
