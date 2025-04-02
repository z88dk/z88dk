 aci -128                       ; CE 80
 aci 0                          ; CE 00
 aci 127                        ; CE 7F
 aci 255                        ; CE FF
 adc (hl)                       ; 8E
 adc (hl+)                      ; 8E 23
 adc (hl-)                      ; 8E 2B
 adc (ix)                       ; DD 8E 00
 adc (ix+0)                     ; DD 8E 00
 adc (ix+126)                   ; DD 8E 7E
 adc (ix-128)                   ; DD 8E 80
 adc (iy)                       ; FD 8E 00
 adc (iy+0)                     ; FD 8E 00
 adc (iy+126)                   ; FD 8E 7E
 adc (iy-128)                   ; FD 8E 80
 adc -128                       ; CE 80
 adc 0                          ; CE 00
 adc 127                        ; CE 7F
 adc 255                        ; CE FF
 adc a                          ; 8F
 adc a, (hl)                    ; 8E
 adc a, (hl+)                   ; 8E 23
 adc a, (hl-)                   ; 8E 2B
 adc a, (ix)                    ; DD 8E 00
 adc a, (ix+0)                  ; DD 8E 00
 adc a, (ix+126)                ; DD 8E 7E
 adc a, (ix-128)                ; DD 8E 80
 adc a, (iy)                    ; FD 8E 00
 adc a, (iy+0)                  ; FD 8E 00
 adc a, (iy+126)                ; FD 8E 7E
 adc a, (iy-128)                ; FD 8E 80
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
 adc.l (hl)                     ; 49 8E
 adc.l (hl+)                    ; 49 8E 49 23
 adc.l (hl-)                    ; 49 8E 49 2B
 adc.l (ix)                     ; 49 DD 8E 00
 adc.l (ix+0)                   ; 49 DD 8E 00
 adc.l (ix+126)                 ; 49 DD 8E 7E
 adc.l (ix-128)                 ; 49 DD 8E 80
 adc.l (iy)                     ; 49 FD 8E 00
 adc.l (iy+0)                   ; 49 FD 8E 00
 adc.l (iy+126)                 ; 49 FD 8E 7E
 adc.l (iy-128)                 ; 49 FD 8E 80
 adc.l a, (hl)                  ; 49 8E
 adc.l a, (hl+)                 ; 49 8E 49 23
 adc.l a, (hl-)                 ; 49 8E 49 2B
 adc.l a, (ix)                  ; 49 DD 8E 00
 adc.l a, (ix+0)                ; 49 DD 8E 00
 adc.l a, (ix+126)              ; 49 DD 8E 7E
 adc.l a, (ix-128)              ; 49 DD 8E 80
 adc.l a, (iy)                  ; 49 FD 8E 00
 adc.l a, (iy+0)                ; 49 FD 8E 00
 adc.l a, (iy+126)              ; 49 FD 8E 7E
 adc.l a, (iy-128)              ; 49 FD 8E 80
 adc.l hl, bc                   ; 49 ED 4A
 adc.l hl, de                   ; 49 ED 5A
 adc.l hl, hl                   ; 49 ED 6A
 adc.l hl, sp                   ; 49 ED 7A
 adc.lis (hl)                   ; 49 8E
 adc.lis (hl+)                  ; 49 8E 49 23
 adc.lis (hl-)                  ; 49 8E 49 2B
 adc.lis (ix)                   ; 49 DD 8E 00
 adc.lis (ix+0)                 ; 49 DD 8E 00
 adc.lis (ix+126)               ; 49 DD 8E 7E
 adc.lis (ix-128)               ; 49 DD 8E 80
 adc.lis (iy)                   ; 49 FD 8E 00
 adc.lis (iy+0)                 ; 49 FD 8E 00
 adc.lis (iy+126)               ; 49 FD 8E 7E
 adc.lis (iy-128)               ; 49 FD 8E 80
 adc.lis a, (hl)                ; 49 8E
 adc.lis a, (hl+)               ; 49 8E 49 23
 adc.lis a, (hl-)               ; 49 8E 49 2B
 adc.lis a, (ix)                ; 49 DD 8E 00
 adc.lis a, (ix+0)              ; 49 DD 8E 00
 adc.lis a, (ix+126)            ; 49 DD 8E 7E
 adc.lis a, (ix-128)            ; 49 DD 8E 80
 adc.lis a, (iy)                ; 49 FD 8E 00
 adc.lis a, (iy+0)              ; 49 FD 8E 00
 adc.lis a, (iy+126)            ; 49 FD 8E 7E
 adc.lis a, (iy-128)            ; 49 FD 8E 80
 adc.lis hl, bc                 ; 49 ED 4A
 adc.lis hl, de                 ; 49 ED 5A
 adc.lis hl, hl                 ; 49 ED 6A
 adc.lis hl, sp                 ; 49 ED 7A
 add (hl)                       ; 86
 add (hl+)                      ; 86 23
 add (hl-)                      ; 86 2B
 add (ix)                       ; DD 86 00
 add (ix+0)                     ; DD 86 00
 add (ix+126)                   ; DD 86 7E
 add (ix-128)                   ; DD 86 80
 add (iy)                       ; FD 86 00
 add (iy+0)                     ; FD 86 00
 add (iy+126)                   ; FD 86 7E
 add (iy-128)                   ; FD 86 80
 add -128                       ; C6 80
 add 0                          ; C6 00
 add 127                        ; C6 7F
 add 255                        ; C6 FF
 add a                          ; 87
 add a, (hl)                    ; 86
 add a, (hl+)                   ; 86 23
 add a, (hl-)                   ; 86 2B
 add a, (ix)                    ; DD 86 00
 add a, (ix+0)                  ; DD 86 00
 add a, (ix+126)                ; DD 86 7E
 add a, (ix-128)                ; DD 86 80
 add a, (iy)                    ; FD 86 00
 add a, (iy+0)                  ; FD 86 00
 add a, (iy+126)                ; FD 86 7E
 add a, (iy-128)                ; FD 86 80
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
 add a, ixh                     ; DD 84
 add a, ixl                     ; DD 85
 add a, iyh                     ; FD 84
 add a, iyl                     ; FD 85
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
 add sp, -128                   ; CD @__z80asm__add_sp_s 80
 add sp, 0                      ; CD @__z80asm__add_sp_s 00
 add sp, 126                    ; CD @__z80asm__add_sp_s 7E
 add.l (hl)                     ; 49 86
 add.l (hl+)                    ; 49 86 49 23
 add.l (hl-)                    ; 49 86 49 2B
 add.l (ix)                     ; 49 DD 86 00
 add.l (ix+0)                   ; 49 DD 86 00
 add.l (ix+126)                 ; 49 DD 86 7E
 add.l (ix-128)                 ; 49 DD 86 80
 add.l (iy)                     ; 49 FD 86 00
 add.l (iy+0)                   ; 49 FD 86 00
 add.l (iy+126)                 ; 49 FD 86 7E
 add.l (iy-128)                 ; 49 FD 86 80
 add.l a, (hl)                  ; 49 86
 add.l a, (hl+)                 ; 49 86 49 23
 add.l a, (hl-)                 ; 49 86 49 2B
 add.l a, (ix)                  ; 49 DD 86 00
 add.l a, (ix+0)                ; 49 DD 86 00
 add.l a, (ix+126)              ; 49 DD 86 7E
 add.l a, (ix-128)              ; 49 DD 86 80
 add.l a, (iy)                  ; 49 FD 86 00
 add.l a, (iy+0)                ; 49 FD 86 00
 add.l a, (iy+126)              ; 49 FD 86 7E
 add.l a, (iy-128)              ; 49 FD 86 80
 add.l hl, bc                   ; 49 09
 add.l hl, de                   ; 49 19
 add.l hl, hl                   ; 49 29
 add.l hl, sp                   ; 49 39
 add.l ix, bc                   ; 49 DD 09
 add.l ix, de                   ; 49 DD 19
 add.l ix, ix                   ; 49 DD 29
 add.l ix, sp                   ; 49 DD 39
 add.l iy, bc                   ; 49 FD 09
 add.l iy, de                   ; 49 FD 19
 add.l iy, iy                   ; 49 FD 29
 add.l iy, sp                   ; 49 FD 39
 add.lis (hl)                   ; 49 86
 add.lis (hl+)                  ; 49 86 49 23
 add.lis (hl-)                  ; 49 86 49 2B
 add.lis (ix)                   ; 49 DD 86 00
 add.lis (ix+0)                 ; 49 DD 86 00
 add.lis (ix+126)               ; 49 DD 86 7E
 add.lis (ix-128)               ; 49 DD 86 80
 add.lis (iy)                   ; 49 FD 86 00
 add.lis (iy+0)                 ; 49 FD 86 00
 add.lis (iy+126)               ; 49 FD 86 7E
 add.lis (iy-128)               ; 49 FD 86 80
 add.lis a, (hl)                ; 49 86
 add.lis a, (hl+)               ; 49 86 49 23
 add.lis a, (hl-)               ; 49 86 49 2B
 add.lis a, (ix)                ; 49 DD 86 00
 add.lis a, (ix+0)              ; 49 DD 86 00
 add.lis a, (ix+126)            ; 49 DD 86 7E
 add.lis a, (ix-128)            ; 49 DD 86 80
 add.lis a, (iy)                ; 49 FD 86 00
 add.lis a, (iy+0)              ; 49 FD 86 00
 add.lis a, (iy+126)            ; 49 FD 86 7E
 add.lis a, (iy-128)            ; 49 FD 86 80
 add.lis hl, bc                 ; 49 09
 add.lis hl, de                 ; 49 19
 add.lis hl, hl                 ; 49 29
 add.lis hl, sp                 ; 49 39
 add.lis ix, bc                 ; 49 DD 09
 add.lis ix, de                 ; 49 DD 19
 add.lis ix, ix                 ; 49 DD 29
 add.lis ix, sp                 ; 49 DD 39
 add.lis iy, bc                 ; 49 FD 09
 add.lis iy, de                 ; 49 FD 19
 add.lis iy, iy                 ; 49 FD 29
 add.lis iy, sp                 ; 49 FD 39
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
 and (ix)                       ; DD A6 00
 and (ix+0)                     ; DD A6 00
 and (ix+126)                   ; DD A6 7E
 and (ix-128)                   ; DD A6 80
 and (iy)                       ; FD A6 00
 and (iy+0)                     ; FD A6 00
 and (iy+126)                   ; FD A6 7E
 and (iy-128)                   ; FD A6 80
 and -128                       ; E6 80
 and 0                          ; E6 00
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; A7
 and a, (hl)                    ; A6
 and a, (hl+)                   ; A6 23
 and a, (hl-)                   ; A6 2B
 and a, (ix)                    ; DD A6 00
 and a, (ix+0)                  ; DD A6 00
 and a, (ix+126)                ; DD A6 7E
 and a, (ix-128)                ; DD A6 80
 and a, (iy)                    ; FD A6 00
 and a, (iy+0)                  ; FD A6 00
 and a, (iy+126)                ; FD A6 7E
 and a, (iy-128)                ; FD A6 80
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
 and.l (hl)                     ; 49 A6
 and.l (hl+)                    ; 49 A6 49 23
 and.l (hl-)                    ; 49 A6 49 2B
 and.l (ix)                     ; 49 DD A6 00
 and.l (ix+0)                   ; 49 DD A6 00
 and.l (ix+126)                 ; 49 DD A6 7E
 and.l (ix-128)                 ; 49 DD A6 80
 and.l (iy)                     ; 49 FD A6 00
 and.l (iy+0)                   ; 49 FD A6 00
 and.l (iy+126)                 ; 49 FD A6 7E
 and.l (iy-128)                 ; 49 FD A6 80
 and.l a, (hl)                  ; 49 A6
 and.l a, (hl+)                 ; 49 A6 49 23
 and.l a, (hl-)                 ; 49 A6 49 2B
 and.l a, (ix)                  ; 49 DD A6 00
 and.l a, (ix+0)                ; 49 DD A6 00
 and.l a, (ix+126)              ; 49 DD A6 7E
 and.l a, (ix-128)              ; 49 DD A6 80
 and.l a, (iy)                  ; 49 FD A6 00
 and.l a, (iy+0)                ; 49 FD A6 00
 and.l a, (iy+126)              ; 49 FD A6 7E
 and.l a, (iy-128)              ; 49 FD A6 80
 and.lis (hl)                   ; 49 A6
 and.lis (hl+)                  ; 49 A6 49 23
 and.lis (hl-)                  ; 49 A6 49 2B
 and.lis (ix)                   ; 49 DD A6 00
 and.lis (ix+0)                 ; 49 DD A6 00
 and.lis (ix+126)               ; 49 DD A6 7E
 and.lis (ix-128)               ; 49 DD A6 80
 and.lis (iy)                   ; 49 FD A6 00
 and.lis (iy+0)                 ; 49 FD A6 00
 and.lis (iy+126)               ; 49 FD A6 7E
 and.lis (iy-128)               ; 49 FD A6 80
 and.lis a, (hl)                ; 49 A6
 and.lis a, (hl+)               ; 49 A6 49 23
 and.lis a, (hl-)               ; 49 A6 49 2B
 and.lis a, (ix)                ; 49 DD A6 00
 and.lis a, (ix+0)              ; 49 DD A6 00
 and.lis a, (ix+126)            ; 49 DD A6 7E
 and.lis a, (ix-128)            ; 49 DD A6 80
 and.lis a, (iy)                ; 49 FD A6 00
 and.lis a, (iy+0)              ; 49 FD A6 00
 and.lis a, (iy+126)            ; 49 FD A6 7E
 and.lis a, (iy-128)            ; 49 FD A6 80
 ani -128                       ; E6 80
 ani 0                          ; E6 00
 ani 127                        ; E6 7F
 ani 255                        ; E6 FF
 arhl                           ; CD @__z80asm__sra_hl
 bit 0, (hl)                    ; CB 46
 bit 0, (ix)                    ; DD CB 00 46
 bit 0, (ix+0)                  ; DD CB 00 46
 bit 0, (ix+126)                ; DD CB 7E 46
 bit 0, (ix-128)                ; DD CB 80 46
 bit 0, (iy)                    ; FD CB 00 46
 bit 0, (iy+0)                  ; FD CB 00 46
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
 bit 1, (ix+0)                  ; DD CB 00 4E
 bit 1, (ix+126)                ; DD CB 7E 4E
 bit 1, (ix-128)                ; DD CB 80 4E
 bit 1, (iy)                    ; FD CB 00 4E
 bit 1, (iy+0)                  ; FD CB 00 4E
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
 bit 2, (ix+0)                  ; DD CB 00 56
 bit 2, (ix+126)                ; DD CB 7E 56
 bit 2, (ix-128)                ; DD CB 80 56
 bit 2, (iy)                    ; FD CB 00 56
 bit 2, (iy+0)                  ; FD CB 00 56
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
 bit 3, (ix+0)                  ; DD CB 00 5E
 bit 3, (ix+126)                ; DD CB 7E 5E
 bit 3, (ix-128)                ; DD CB 80 5E
 bit 3, (iy)                    ; FD CB 00 5E
 bit 3, (iy+0)                  ; FD CB 00 5E
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
 bit 4, (ix+0)                  ; DD CB 00 66
 bit 4, (ix+126)                ; DD CB 7E 66
 bit 4, (ix-128)                ; DD CB 80 66
 bit 4, (iy)                    ; FD CB 00 66
 bit 4, (iy+0)                  ; FD CB 00 66
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
 bit 5, (ix+0)                  ; DD CB 00 6E
 bit 5, (ix+126)                ; DD CB 7E 6E
 bit 5, (ix-128)                ; DD CB 80 6E
 bit 5, (iy)                    ; FD CB 00 6E
 bit 5, (iy+0)                  ; FD CB 00 6E
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
 bit 6, (ix+0)                  ; DD CB 00 76
 bit 6, (ix+126)                ; DD CB 7E 76
 bit 6, (ix-128)                ; DD CB 80 76
 bit 6, (iy)                    ; FD CB 00 76
 bit 6, (iy+0)                  ; FD CB 00 76
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
 bit 7, (ix+0)                  ; DD CB 00 7E
 bit 7, (ix+126)                ; DD CB 7E 7E
 bit 7, (ix-128)                ; DD CB 80 7E
 bit 7, (iy)                    ; FD CB 00 7E
 bit 7, (iy+0)                  ; FD CB 00 7E
 bit 7, (iy+126)                ; FD CB 7E 7E
 bit 7, (iy-128)                ; FD CB 80 7E
 bit 7, a                       ; CB 7F
 bit 7, b                       ; CB 78
 bit 7, c                       ; CB 79
 bit 7, d                       ; CB 7A
 bit 7, e                       ; CB 7B
 bit 7, h                       ; CB 7C
 bit 7, l                       ; CB 7D
 bit.l 0, (hl)                  ; 49 CB 46
 bit.l 0, (ix)                  ; 49 DD CB 00 46
 bit.l 0, (ix+0)                ; 49 DD CB 00 46
 bit.l 0, (ix+126)              ; 49 DD CB 7E 46
 bit.l 0, (ix-128)              ; 49 DD CB 80 46
 bit.l 0, (iy)                  ; 49 FD CB 00 46
 bit.l 0, (iy+0)                ; 49 FD CB 00 46
 bit.l 0, (iy+126)              ; 49 FD CB 7E 46
 bit.l 0, (iy-128)              ; 49 FD CB 80 46
 bit.l 1, (hl)                  ; 49 CB 4E
 bit.l 1, (ix)                  ; 49 DD CB 00 4E
 bit.l 1, (ix+0)                ; 49 DD CB 00 4E
 bit.l 1, (ix+126)              ; 49 DD CB 7E 4E
 bit.l 1, (ix-128)              ; 49 DD CB 80 4E
 bit.l 1, (iy)                  ; 49 FD CB 00 4E
 bit.l 1, (iy+0)                ; 49 FD CB 00 4E
 bit.l 1, (iy+126)              ; 49 FD CB 7E 4E
 bit.l 1, (iy-128)              ; 49 FD CB 80 4E
 bit.l 2, (hl)                  ; 49 CB 56
 bit.l 2, (ix)                  ; 49 DD CB 00 56
 bit.l 2, (ix+0)                ; 49 DD CB 00 56
 bit.l 2, (ix+126)              ; 49 DD CB 7E 56
 bit.l 2, (ix-128)              ; 49 DD CB 80 56
 bit.l 2, (iy)                  ; 49 FD CB 00 56
 bit.l 2, (iy+0)                ; 49 FD CB 00 56
 bit.l 2, (iy+126)              ; 49 FD CB 7E 56
 bit.l 2, (iy-128)              ; 49 FD CB 80 56
 bit.l 3, (hl)                  ; 49 CB 5E
 bit.l 3, (ix)                  ; 49 DD CB 00 5E
 bit.l 3, (ix+0)                ; 49 DD CB 00 5E
 bit.l 3, (ix+126)              ; 49 DD CB 7E 5E
 bit.l 3, (ix-128)              ; 49 DD CB 80 5E
 bit.l 3, (iy)                  ; 49 FD CB 00 5E
 bit.l 3, (iy+0)                ; 49 FD CB 00 5E
 bit.l 3, (iy+126)              ; 49 FD CB 7E 5E
 bit.l 3, (iy-128)              ; 49 FD CB 80 5E
 bit.l 4, (hl)                  ; 49 CB 66
 bit.l 4, (ix)                  ; 49 DD CB 00 66
 bit.l 4, (ix+0)                ; 49 DD CB 00 66
 bit.l 4, (ix+126)              ; 49 DD CB 7E 66
 bit.l 4, (ix-128)              ; 49 DD CB 80 66
 bit.l 4, (iy)                  ; 49 FD CB 00 66
 bit.l 4, (iy+0)                ; 49 FD CB 00 66
 bit.l 4, (iy+126)              ; 49 FD CB 7E 66
 bit.l 4, (iy-128)              ; 49 FD CB 80 66
 bit.l 5, (hl)                  ; 49 CB 6E
 bit.l 5, (ix)                  ; 49 DD CB 00 6E
 bit.l 5, (ix+0)                ; 49 DD CB 00 6E
 bit.l 5, (ix+126)              ; 49 DD CB 7E 6E
 bit.l 5, (ix-128)              ; 49 DD CB 80 6E
 bit.l 5, (iy)                  ; 49 FD CB 00 6E
 bit.l 5, (iy+0)                ; 49 FD CB 00 6E
 bit.l 5, (iy+126)              ; 49 FD CB 7E 6E
 bit.l 5, (iy-128)              ; 49 FD CB 80 6E
 bit.l 6, (hl)                  ; 49 CB 76
 bit.l 6, (ix)                  ; 49 DD CB 00 76
 bit.l 6, (ix+0)                ; 49 DD CB 00 76
 bit.l 6, (ix+126)              ; 49 DD CB 7E 76
 bit.l 6, (ix-128)              ; 49 DD CB 80 76
 bit.l 6, (iy)                  ; 49 FD CB 00 76
 bit.l 6, (iy+0)                ; 49 FD CB 00 76
 bit.l 6, (iy+126)              ; 49 FD CB 7E 76
 bit.l 6, (iy-128)              ; 49 FD CB 80 76
 bit.l 7, (hl)                  ; 49 CB 7E
 bit.l 7, (ix)                  ; 49 DD CB 00 7E
 bit.l 7, (ix+0)                ; 49 DD CB 00 7E
 bit.l 7, (ix+126)              ; 49 DD CB 7E 7E
 bit.l 7, (ix-128)              ; 49 DD CB 80 7E
 bit.l 7, (iy)                  ; 49 FD CB 00 7E
 bit.l 7, (iy+0)                ; 49 FD CB 00 7E
 bit.l 7, (iy+126)              ; 49 FD CB 7E 7E
 bit.l 7, (iy-128)              ; 49 FD CB 80 7E
 bit.lis 0, (hl)                ; 49 CB 46
 bit.lis 0, (ix)                ; 49 DD CB 00 46
 bit.lis 0, (ix+0)              ; 49 DD CB 00 46
 bit.lis 0, (ix+126)            ; 49 DD CB 7E 46
 bit.lis 0, (ix-128)            ; 49 DD CB 80 46
 bit.lis 0, (iy)                ; 49 FD CB 00 46
 bit.lis 0, (iy+0)              ; 49 FD CB 00 46
 bit.lis 0, (iy+126)            ; 49 FD CB 7E 46
 bit.lis 0, (iy-128)            ; 49 FD CB 80 46
 bit.lis 1, (hl)                ; 49 CB 4E
 bit.lis 1, (ix)                ; 49 DD CB 00 4E
 bit.lis 1, (ix+0)              ; 49 DD CB 00 4E
 bit.lis 1, (ix+126)            ; 49 DD CB 7E 4E
 bit.lis 1, (ix-128)            ; 49 DD CB 80 4E
 bit.lis 1, (iy)                ; 49 FD CB 00 4E
 bit.lis 1, (iy+0)              ; 49 FD CB 00 4E
 bit.lis 1, (iy+126)            ; 49 FD CB 7E 4E
 bit.lis 1, (iy-128)            ; 49 FD CB 80 4E
 bit.lis 2, (hl)                ; 49 CB 56
 bit.lis 2, (ix)                ; 49 DD CB 00 56
 bit.lis 2, (ix+0)              ; 49 DD CB 00 56
 bit.lis 2, (ix+126)            ; 49 DD CB 7E 56
 bit.lis 2, (ix-128)            ; 49 DD CB 80 56
 bit.lis 2, (iy)                ; 49 FD CB 00 56
 bit.lis 2, (iy+0)              ; 49 FD CB 00 56
 bit.lis 2, (iy+126)            ; 49 FD CB 7E 56
 bit.lis 2, (iy-128)            ; 49 FD CB 80 56
 bit.lis 3, (hl)                ; 49 CB 5E
 bit.lis 3, (ix)                ; 49 DD CB 00 5E
 bit.lis 3, (ix+0)              ; 49 DD CB 00 5E
 bit.lis 3, (ix+126)            ; 49 DD CB 7E 5E
 bit.lis 3, (ix-128)            ; 49 DD CB 80 5E
 bit.lis 3, (iy)                ; 49 FD CB 00 5E
 bit.lis 3, (iy+0)              ; 49 FD CB 00 5E
 bit.lis 3, (iy+126)            ; 49 FD CB 7E 5E
 bit.lis 3, (iy-128)            ; 49 FD CB 80 5E
 bit.lis 4, (hl)                ; 49 CB 66
 bit.lis 4, (ix)                ; 49 DD CB 00 66
 bit.lis 4, (ix+0)              ; 49 DD CB 00 66
 bit.lis 4, (ix+126)            ; 49 DD CB 7E 66
 bit.lis 4, (ix-128)            ; 49 DD CB 80 66
 bit.lis 4, (iy)                ; 49 FD CB 00 66
 bit.lis 4, (iy+0)              ; 49 FD CB 00 66
 bit.lis 4, (iy+126)            ; 49 FD CB 7E 66
 bit.lis 4, (iy-128)            ; 49 FD CB 80 66
 bit.lis 5, (hl)                ; 49 CB 6E
 bit.lis 5, (ix)                ; 49 DD CB 00 6E
 bit.lis 5, (ix+0)              ; 49 DD CB 00 6E
 bit.lis 5, (ix+126)            ; 49 DD CB 7E 6E
 bit.lis 5, (ix-128)            ; 49 DD CB 80 6E
 bit.lis 5, (iy)                ; 49 FD CB 00 6E
 bit.lis 5, (iy+0)              ; 49 FD CB 00 6E
 bit.lis 5, (iy+126)            ; 49 FD CB 7E 6E
 bit.lis 5, (iy-128)            ; 49 FD CB 80 6E
 bit.lis 6, (hl)                ; 49 CB 76
 bit.lis 6, (ix)                ; 49 DD CB 00 76
 bit.lis 6, (ix+0)              ; 49 DD CB 00 76
 bit.lis 6, (ix+126)            ; 49 DD CB 7E 76
 bit.lis 6, (ix-128)            ; 49 DD CB 80 76
 bit.lis 6, (iy)                ; 49 FD CB 00 76
 bit.lis 6, (iy+0)              ; 49 FD CB 00 76
 bit.lis 6, (iy+126)            ; 49 FD CB 7E 76
 bit.lis 6, (iy-128)            ; 49 FD CB 80 76
 bit.lis 7, (hl)                ; 49 CB 7E
 bit.lis 7, (ix)                ; 49 DD CB 00 7E
 bit.lis 7, (ix+0)              ; 49 DD CB 00 7E
 bit.lis 7, (ix+126)            ; 49 DD CB 7E 7E
 bit.lis 7, (ix-128)            ; 49 DD CB 80 7E
 bit.lis 7, (iy)                ; 49 FD CB 00 7E
 bit.lis 7, (iy+0)              ; 49 FD CB 00 7E
 bit.lis 7, (iy+126)            ; 49 FD CB 7E 7E
 bit.lis 7, (iy-128)            ; 49 FD CB 80 7E
 c_c 0x1234                     ; DC 34 12
 c_eq 0x1234                    ; CC 34 12
 c_geu 0x1234                   ; D4 34 12
 c_gtu 0x1234                   ; 28 03 D4 34 12
 c_leu 0x1234                   ; 28 02 30 03 CD 34 12
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
 call (hl)                      ; CD @__z80asm__call_hl
 call 0x1234                    ; CD 34 12
 call c, 0x1234                 ; DC 34 12
 call eq, 0x1234                ; CC 34 12
 call geu, 0x1234               ; D4 34 12
 call gtu, 0x1234               ; 28 03 D4 34 12
 call leu, 0x1234               ; 28 02 30 03 CD 34 12
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
 call.il 0x123456               ; 52 CD 56 34 12
 call.il c, 0x123456            ; 52 DC 56 34 12
 call.il eq, 0x123456           ; 52 CC 56 34 12
 call.il geu, 0x123456          ; 52 D4 56 34 12
 call.il gtu, 0x123456          ; 28 05 52 D4 56 34 12
 call.il leu, 0x123456          ; 28 02 30 05 52 CD 56 34 12
 call.il ltu, 0x123456          ; 52 DC 56 34 12
 call.il m, 0x123456            ; 52 FC 56 34 12
 call.il nc, 0x123456           ; 52 D4 56 34 12
 call.il ne, 0x123456           ; 52 C4 56 34 12
 call.il nv, 0x123456           ; 52 E4 56 34 12
 call.il nz, 0x123456           ; 52 C4 56 34 12
 call.il p, 0x123456            ; 52 F4 56 34 12
 call.il pe, 0x123456           ; 52 EC 56 34 12
 call.il po, 0x123456           ; 52 E4 56 34 12
 call.il v, 0x123456            ; 52 EC 56 34 12
 call.il z, 0x123456            ; 52 CC 56 34 12
 call.is 0x1234                 ; 40 CD 34 12
 call.is c, 0x1234              ; 40 DC 34 12
 call.is eq, 0x1234             ; 40 CC 34 12
 call.is geu, 0x1234            ; 40 D4 34 12
 call.is gtu, 0x1234            ; 28 04 40 D4 34 12
 call.is leu, 0x1234            ; 28 02 30 04 40 CD 34 12
 call.is ltu, 0x1234            ; 40 DC 34 12
 call.is m, 0x1234              ; 40 FC 34 12
 call.is nc, 0x1234             ; 40 D4 34 12
 call.is ne, 0x1234             ; 40 C4 34 12
 call.is nv, 0x1234             ; 40 E4 34 12
 call.is nz, 0x1234             ; 40 C4 34 12
 call.is p, 0x1234              ; 40 F4 34 12
 call.is pe, 0x1234             ; 40 EC 34 12
 call.is po, 0x1234             ; 40 E4 34 12
 call.is v, 0x1234              ; 40 EC 34 12
 call.is z, 0x1234              ; 40 CC 34 12
 call.sil 0x123456              ; 52 CD 56 34 12
 call.sil c, 0x123456           ; 52 DC 56 34 12
 call.sil eq, 0x123456          ; 52 CC 56 34 12
 call.sil geu, 0x123456         ; 52 D4 56 34 12
 call.sil gtu, 0x123456         ; 28 05 52 D4 56 34 12
 call.sil leu, 0x123456         ; 28 02 30 05 52 CD 56 34 12
 call.sil ltu, 0x123456         ; 52 DC 56 34 12
 call.sil m, 0x123456           ; 52 FC 56 34 12
 call.sil nc, 0x123456          ; 52 D4 56 34 12
 call.sil ne, 0x123456          ; 52 C4 56 34 12
 call.sil nv, 0x123456          ; 52 E4 56 34 12
 call.sil nz, 0x123456          ; 52 C4 56 34 12
 call.sil p, 0x123456           ; 52 F4 56 34 12
 call.sil pe, 0x123456          ; 52 EC 56 34 12
 call.sil po, 0x123456          ; 52 E4 56 34 12
 call.sil v, 0x123456           ; 52 EC 56 34 12
 call.sil z, 0x123456           ; 52 CC 56 34 12
 call.sis 0x1234                ; 40 CD 34 12
 call.sis c, 0x1234             ; 40 DC 34 12
 call.sis eq, 0x1234            ; 40 CC 34 12
 call.sis geu, 0x1234           ; 40 D4 34 12
 call.sis gtu, 0x1234           ; 28 04 40 D4 34 12
 call.sis leu, 0x1234           ; 28 02 30 04 40 CD 34 12
 call.sis ltu, 0x1234           ; 40 DC 34 12
 call.sis m, 0x1234             ; 40 FC 34 12
 call.sis nc, 0x1234            ; 40 D4 34 12
 call.sis ne, 0x1234            ; 40 C4 34 12
 call.sis nv, 0x1234            ; 40 E4 34 12
 call.sis nz, 0x1234            ; 40 C4 34 12
 call.sis p, 0x1234             ; 40 F4 34 12
 call.sis pe, 0x1234            ; 40 EC 34 12
 call.sis po, 0x1234            ; 40 E4 34 12
 call.sis v, 0x1234             ; 40 EC 34 12
 call.sis z, 0x1234             ; 40 CC 34 12
 cc 0x1234                      ; DC 34 12
 ccf                            ; 3F
 ceq 0x1234                     ; CC 34 12
 cgeu 0x1234                    ; D4 34 12
 cgtu 0x1234                    ; 28 03 D4 34 12
 cleu 0x1234                    ; 28 02 30 03 CD 34 12
 cltu 0x1234                    ; DC 34 12
 cm 0x1234                      ; FC 34 12
 cma                            ; 2F
 cmc                            ; 3F
 cmp (hl)                       ; BE
 cmp (hl+)                      ; BE 23
 cmp (hl-)                      ; BE 2B
 cmp (ix)                       ; DD BE 00
 cmp (ix+0)                     ; DD BE 00
 cmp (ix+126)                   ; DD BE 7E
 cmp (ix-128)                   ; DD BE 80
 cmp (iy)                       ; FD BE 00
 cmp (iy+0)                     ; FD BE 00
 cmp (iy+126)                   ; FD BE 7E
 cmp (iy-128)                   ; FD BE 80
 cmp -128                       ; FE 80
 cmp 0                          ; FE 00
 cmp 127                        ; FE 7F
 cmp 255                        ; FE FF
 cmp a                          ; BF
 cmp a, (hl)                    ; BE
 cmp a, (hl+)                   ; BE 23
 cmp a, (hl-)                   ; BE 2B
 cmp a, (ix)                    ; DD BE 00
 cmp a, (ix+0)                  ; DD BE 00
 cmp a, (ix+126)                ; DD BE 7E
 cmp a, (ix-128)                ; DD BE 80
 cmp a, (iy)                    ; FD BE 00
 cmp a, (iy+0)                  ; FD BE 00
 cmp a, (iy+126)                ; FD BE 7E
 cmp a, (iy-128)                ; FD BE 80
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
 cmp.l (hl)                     ; 49 BE
 cmp.l (hl+)                    ; 49 BE 49 23
 cmp.l (hl-)                    ; 49 BE 49 2B
 cmp.l (ix)                     ; 49 DD BE 00
 cmp.l (ix+0)                   ; 49 DD BE 00
 cmp.l (ix+126)                 ; 49 DD BE 7E
 cmp.l (ix-128)                 ; 49 DD BE 80
 cmp.l (iy)                     ; 49 FD BE 00
 cmp.l (iy+0)                   ; 49 FD BE 00
 cmp.l (iy+126)                 ; 49 FD BE 7E
 cmp.l (iy-128)                 ; 49 FD BE 80
 cmp.l a, (hl)                  ; 49 BE
 cmp.l a, (hl+)                 ; 49 BE 49 23
 cmp.l a, (hl-)                 ; 49 BE 49 2B
 cmp.l a, (ix)                  ; 49 DD BE 00
 cmp.l a, (ix+0)                ; 49 DD BE 00
 cmp.l a, (ix+126)              ; 49 DD BE 7E
 cmp.l a, (ix-128)              ; 49 DD BE 80
 cmp.l a, (iy)                  ; 49 FD BE 00
 cmp.l a, (iy+0)                ; 49 FD BE 00
 cmp.l a, (iy+126)              ; 49 FD BE 7E
 cmp.l a, (iy-128)              ; 49 FD BE 80
 cmp.lis (hl)                   ; 49 BE
 cmp.lis (hl+)                  ; 49 BE 49 23
 cmp.lis (hl-)                  ; 49 BE 49 2B
 cmp.lis (ix)                   ; 49 DD BE 00
 cmp.lis (ix+0)                 ; 49 DD BE 00
 cmp.lis (ix+126)               ; 49 DD BE 7E
 cmp.lis (ix-128)               ; 49 DD BE 80
 cmp.lis (iy)                   ; 49 FD BE 00
 cmp.lis (iy+0)                 ; 49 FD BE 00
 cmp.lis (iy+126)               ; 49 FD BE 7E
 cmp.lis (iy-128)               ; 49 FD BE 80
 cmp.lis a, (hl)                ; 49 BE
 cmp.lis a, (hl+)               ; 49 BE 49 23
 cmp.lis a, (hl-)               ; 49 BE 49 2B
 cmp.lis a, (ix)                ; 49 DD BE 00
 cmp.lis a, (ix+0)              ; 49 DD BE 00
 cmp.lis a, (ix+126)            ; 49 DD BE 7E
 cmp.lis a, (ix-128)            ; 49 DD BE 80
 cmp.lis a, (iy)                ; 49 FD BE 00
 cmp.lis a, (iy+0)              ; 49 FD BE 00
 cmp.lis a, (iy+126)            ; 49 FD BE 7E
 cmp.lis a, (iy-128)            ; 49 FD BE 80
 cnc 0x1234                     ; D4 34 12
 cne 0x1234                     ; C4 34 12
 cnv 0x1234                     ; E4 34 12
 cnz 0x1234                     ; C4 34 12
 cp (hl)                        ; BE
 cp (hl+)                       ; BE 23
 cp (hl-)                       ; BE 2B
 cp (ix)                        ; DD BE 00
 cp (ix+0)                      ; DD BE 00
 cp (ix+126)                    ; DD BE 7E
 cp (ix-128)                    ; DD BE 80
 cp (iy)                        ; FD BE 00
 cp (iy+0)                      ; FD BE 00
 cp (iy+126)                    ; FD BE 7E
 cp (iy-128)                    ; FD BE 80
 cp -128                        ; FE 80
 cp 0                           ; FE 00
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; BF
 cp a, (hl)                     ; BE
 cp a, (hl+)                    ; BE 23
 cp a, (hl-)                    ; BE 2B
 cp a, (ix)                     ; DD BE 00
 cp a, (ix+0)                   ; DD BE 00
 cp a, (ix+126)                 ; DD BE 7E
 cp a, (ix-128)                 ; DD BE 80
 cp a, (iy)                     ; FD BE 00
 cp a, (iy+0)                   ; FD BE 00
 cp a, (iy+126)                 ; FD BE 7E
 cp a, (iy-128)                 ; FD BE 80
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
 cp.l (hl)                      ; 49 BE
 cp.l (hl+)                     ; 49 BE 49 23
 cp.l (hl-)                     ; 49 BE 49 2B
 cp.l (ix)                      ; 49 DD BE 00
 cp.l (ix+0)                    ; 49 DD BE 00
 cp.l (ix+126)                  ; 49 DD BE 7E
 cp.l (ix-128)                  ; 49 DD BE 80
 cp.l (iy)                      ; 49 FD BE 00
 cp.l (iy+0)                    ; 49 FD BE 00
 cp.l (iy+126)                  ; 49 FD BE 7E
 cp.l (iy-128)                  ; 49 FD BE 80
 cp.l a, (hl)                   ; 49 BE
 cp.l a, (hl+)                  ; 49 BE 49 23
 cp.l a, (hl-)                  ; 49 BE 49 2B
 cp.l a, (ix)                   ; 49 DD BE 00
 cp.l a, (ix+0)                 ; 49 DD BE 00
 cp.l a, (ix+126)               ; 49 DD BE 7E
 cp.l a, (ix-128)               ; 49 DD BE 80
 cp.l a, (iy)                   ; 49 FD BE 00
 cp.l a, (iy+0)                 ; 49 FD BE 00
 cp.l a, (iy+126)               ; 49 FD BE 7E
 cp.l a, (iy-128)               ; 49 FD BE 80
 cp.lis (hl)                    ; 49 BE
 cp.lis (hl+)                   ; 49 BE 49 23
 cp.lis (hl-)                   ; 49 BE 49 2B
 cp.lis (ix)                    ; 49 DD BE 00
 cp.lis (ix+0)                  ; 49 DD BE 00
 cp.lis (ix+126)                ; 49 DD BE 7E
 cp.lis (ix-128)                ; 49 DD BE 80
 cp.lis (iy)                    ; 49 FD BE 00
 cp.lis (iy+0)                  ; 49 FD BE 00
 cp.lis (iy+126)                ; 49 FD BE 7E
 cp.lis (iy-128)                ; 49 FD BE 80
 cp.lis a, (hl)                 ; 49 BE
 cp.lis a, (hl+)                ; 49 BE 49 23
 cp.lis a, (hl-)                ; 49 BE 49 2B
 cp.lis a, (ix)                 ; 49 DD BE 00
 cp.lis a, (ix+0)               ; 49 DD BE 00
 cp.lis a, (ix+126)             ; 49 DD BE 7E
 cp.lis a, (ix-128)             ; 49 DD BE 80
 cp.lis a, (iy)                 ; 49 FD BE 00
 cp.lis a, (iy+0)               ; 49 FD BE 00
 cp.lis a, (iy+126)             ; 49 FD BE 7E
 cp.lis a, (iy-128)             ; 49 FD BE 80
 cpd                            ; ED A9
 cpd.l                          ; 49 ED A9
 cpd.lis                        ; 49 ED A9
 cpdr                           ; ED B9
 cpdr.l                         ; 49 ED B9
 cpdr.lis                       ; 49 ED B9
 cpe 0x1234                     ; EC 34 12
 cpi                            ; ED A1
 cpi -128                       ; FE 80
 cpi 0                          ; FE 00
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpi.l                          ; 49 ED A1
 cpi.lis                        ; 49 ED A1
 cpir                           ; ED B1
 cpir.l                         ; 49 ED B1
 cpir.lis                       ; 49 ED B1
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
 dec (ix+0)                     ; DD 35 00
 dec (ix+126)                   ; DD 35 7E
 dec (ix-128)                   ; DD 35 80
 dec (iy)                       ; FD 35 00
 dec (iy+0)                     ; FD 35 00
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
 dec.l (hl)                     ; 49 35
 dec.l (hl+)                    ; 49 35 49 23
 dec.l (hl-)                    ; 49 35 49 2B
 dec.l (ix)                     ; 49 DD 35 00
 dec.l (ix+0)                   ; 49 DD 35 00
 dec.l (ix+126)                 ; 49 DD 35 7E
 dec.l (ix-128)                 ; 49 DD 35 80
 dec.l (iy)                     ; 49 FD 35 00
 dec.l (iy+0)                   ; 49 FD 35 00
 dec.l (iy+126)                 ; 49 FD 35 7E
 dec.l (iy-128)                 ; 49 FD 35 80
 dec.l bc                       ; 49 0B
 dec.l de                       ; 49 1B
 dec.l hl                       ; 49 2B
 dec.l ix                       ; 49 DD 2B
 dec.l iy                       ; 49 FD 2B
 dec.l sp                       ; 49 3B
 dec.lis (hl)                   ; 49 35
 dec.lis (hl+)                  ; 49 35 49 23
 dec.lis (hl-)                  ; 49 35 49 2B
 dec.lis (ix)                   ; 49 DD 35 00
 dec.lis (ix+0)                 ; 49 DD 35 00
 dec.lis (ix+126)               ; 49 DD 35 7E
 dec.lis (ix-128)               ; 49 DD 35 80
 dec.lis (iy)                   ; 49 FD 35 00
 dec.lis (iy+0)                 ; 49 FD 35 00
 dec.lis (iy+126)               ; 49 FD 35 7E
 dec.lis (iy-128)               ; 49 FD 35 80
 dec.lis bc                     ; 49 0B
 dec.lis de                     ; 49 1B
 dec.lis hl                     ; 49 2B
 dec.lis ix                     ; 49 DD 2B
 dec.lis iy                     ; 49 FD 2B
 dec.lis sp                     ; 49 3B
 di                             ; F3
 djnz ASMPC                     ; 10 FE
 djnz b, ASMPC                  ; 10 FE
 dsub                           ; CD @__z80asm__sub_hl_bc
 ei                             ; FB
 ex (sp), hl                    ; E3
 ex (sp), ix                    ; DD E3
 ex (sp), iy                    ; FD E3
 ex af', af                     ; 08
 ex af, af                      ; 08
 ex af, af'                     ; 08
 ex de, hl                      ; EB
 ex hl, de                      ; EB
 ex.l (sp), hl                  ; 49 E3
 ex.l (sp), ix                  ; 49 DD E3
 ex.l (sp), iy                  ; 49 FD E3
 ex.lis (sp), hl                ; 49 E3
 ex.lis (sp), ix                ; 49 DD E3
 ex.lis (sp), iy                ; 49 FD E3
 exx                            ; D9
 halt                           ; 76
 hlt                            ; 76
 im 0                           ; ED 46
 im 1                           ; ED 56
 im 2                           ; ED 5E
 in -128                        ; DB 80
 in 0                           ; DB 00
 in 127                         ; DB 7F
 in 255                         ; DB FF
 in a, (-128)                   ; DB 80
 in a, (0)                      ; DB 00
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
 in0 a, (0)                     ; ED 38 00
 in0 a, (127)                   ; ED 38 7F
 in0 a, (255)                   ; ED 38 FF
 in0 b, (-128)                  ; ED 00 80
 in0 b, (0)                     ; ED 00 00
 in0 b, (127)                   ; ED 00 7F
 in0 b, (255)                   ; ED 00 FF
 in0 c, (-128)                  ; ED 08 80
 in0 c, (0)                     ; ED 08 00
 in0 c, (127)                   ; ED 08 7F
 in0 c, (255)                   ; ED 08 FF
 in0 d, (-128)                  ; ED 10 80
 in0 d, (0)                     ; ED 10 00
 in0 d, (127)                   ; ED 10 7F
 in0 d, (255)                   ; ED 10 FF
 in0 e, (-128)                  ; ED 18 80
 in0 e, (0)                     ; ED 18 00
 in0 e, (127)                   ; ED 18 7F
 in0 e, (255)                   ; ED 18 FF
 in0 h, (-128)                  ; ED 20 80
 in0 h, (0)                     ; ED 20 00
 in0 h, (127)                   ; ED 20 7F
 in0 h, (255)                   ; ED 20 FF
 in0 l, (-128)                  ; ED 28 80
 in0 l, (0)                     ; ED 28 00
 in0 l, (127)                   ; ED 28 7F
 in0 l, (255)                   ; ED 28 FF
 inc (hl)                       ; 34
 inc (hl+)                      ; 34 23
 inc (hl-)                      ; 34 2B
 inc (ix)                       ; DD 34 00
 inc (ix+0)                     ; DD 34 00
 inc (ix+126)                   ; DD 34 7E
 inc (ix-128)                   ; DD 34 80
 inc (iy)                       ; FD 34 00
 inc (iy+0)                     ; FD 34 00
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
 inc.l (hl)                     ; 49 34
 inc.l (hl+)                    ; 49 34 49 23
 inc.l (hl-)                    ; 49 34 49 2B
 inc.l (ix)                     ; 49 DD 34 00
 inc.l (ix+0)                   ; 49 DD 34 00
 inc.l (ix+126)                 ; 49 DD 34 7E
 inc.l (ix-128)                 ; 49 DD 34 80
 inc.l (iy)                     ; 49 FD 34 00
 inc.l (iy+0)                   ; 49 FD 34 00
 inc.l (iy+126)                 ; 49 FD 34 7E
 inc.l (iy-128)                 ; 49 FD 34 80
 inc.l bc                       ; 49 03
 inc.l de                       ; 49 13
 inc.l hl                       ; 49 23
 inc.l ix                       ; 49 DD 23
 inc.l iy                       ; 49 FD 23
 inc.l sp                       ; 49 33
 inc.lis (hl)                   ; 49 34
 inc.lis (hl+)                  ; 49 34 49 23
 inc.lis (hl-)                  ; 49 34 49 2B
 inc.lis (ix)                   ; 49 DD 34 00
 inc.lis (ix+0)                 ; 49 DD 34 00
 inc.lis (ix+126)               ; 49 DD 34 7E
 inc.lis (ix-128)               ; 49 DD 34 80
 inc.lis (iy)                   ; 49 FD 34 00
 inc.lis (iy+0)                 ; 49 FD 34 00
 inc.lis (iy+126)               ; 49 FD 34 7E
 inc.lis (iy-128)               ; 49 FD 34 80
 inc.lis bc                     ; 49 03
 inc.lis de                     ; 49 13
 inc.lis hl                     ; 49 23
 inc.lis ix                     ; 49 DD 23
 inc.lis iy                     ; 49 FD 23
 inc.lis sp                     ; 49 33
 ind                            ; ED AA
 ind.l                          ; 49 ED AA
 ind.lis                        ; 49 ED AA
 ind2                           ; ED 8C
 ind2.l                         ; 49 ED 8C
 ind2.lis                       ; 49 ED 8C
 ind2r                          ; ED 9C
 ind2r.l                        ; 49 ED 9C
 ind2r.lis                      ; 49 ED 9C
 indm                           ; ED 8A
 indm.l                         ; 49 ED 8A
 indm.lis                       ; 49 ED 8A
 indmr                          ; ED 9A
 indmr.l                        ; 49 ED 9A
 indmr.lis                      ; 49 ED 9A
 indr                           ; ED BA
 indr.l                         ; 49 ED BA
 indr.lis                       ; 49 ED BA
 indrx                          ; ED CA
 indrx.l                        ; 49 ED CA
 indrx.lis                      ; 49 ED CA
 ini                            ; ED A2
 ini.l                          ; 49 ED A2
 ini.lis                        ; 49 ED A2
 ini2                           ; ED 84
 ini2.l                         ; 49 ED 84
 ini2.lis                       ; 49 ED 84
 ini2r                          ; ED 94
 ini2r.l                        ; 49 ED 94
 ini2r.lis                      ; 49 ED 94
 inim                           ; ED 82
 inim.l                         ; 49 ED 82
 inim.lis                       ; 49 ED 82
 inimr                          ; ED 92
 inimr.l                        ; 49 ED 92
 inimr.lis                      ; 49 ED 92
 inir                           ; ED B2
 inir.l                         ; 49 ED B2
 inir.lis                       ; 49 ED B2
 inirx                          ; ED C2
 inirx.l                        ; 49 ED C2
 inirx.lis                      ; 49 ED C2
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
 j_c 0x1234                     ; DA 34 12
 j_eq 0x1234                    ; CA 34 12
 j_geu 0x1234                   ; D2 34 12
 j_gtu 0x1234                   ; CA E4 0E D2 34 12
 j_leu 0x1234                   ; CA 34 12 DA 34 12
 j_ltu 0x1234                   ; DA 34 12
 j_m 0x1234                     ; FA 34 12
 j_nc 0x1234                    ; D2 34 12
 j_ne 0x1234                    ; C2 34 12
 j_nv 0x1234                    ; E2 34 12
 j_nz 0x1234                    ; C2 34 12
 j_p 0x1234                     ; F2 34 12
 j_pe 0x1234                    ; EA 34 12
 j_po 0x1234                    ; E2 34 12
 j_v 0x1234                     ; EA 34 12
 j_z 0x1234                     ; CA 34 12
 jc 0x1234                      ; DA 34 12
 jeq 0x1234                     ; CA 34 12
 jgeu 0x1234                    ; D2 34 12
 jgtu 0x1234                    ; CA 1A 0F D2 34 12
 jleu 0x1234                    ; CA 34 12 DA 34 12
 jltu 0x1234                    ; DA 34 12
 jm 0x1234                      ; FA 34 12
 jmp c, 0x1234                  ; DA 34 12
 jmp eq, 0x1234                 ; CA 34 12
 jmp geu, 0x1234                ; D2 34 12
 jmp gtu, 0x1234                ; 28 03 D2 34 12
 jmp leu, 0x1234                ; CA 34 12 DA 34 12
 jmp ltu, 0x1234                ; DA 34 12
 jmp m, 0x1234                  ; FA 34 12
 jmp nc, 0x1234                 ; D2 34 12
 jmp ne, 0x1234                 ; C2 34 12
 jmp nv, 0x1234                 ; E2 34 12
 jmp nz, 0x1234                 ; C2 34 12
 jmp p, 0x1234                  ; F2 34 12
 jmp pe, 0x1234                 ; EA 34 12
 jmp po, 0x1234                 ; E2 34 12
 jmp v, 0x1234                  ; EA 34 12
 jmp z, 0x1234                  ; CA 34 12
 jnc 0x1234                     ; D2 34 12
 jne 0x1234                     ; C2 34 12
 jnv 0x1234                     ; E2 34 12
 jnz 0x1234                     ; C2 34 12
 jp c, 0x1234                   ; DA 34 12
 jp eq, 0x1234                  ; CA 34 12
 jp geu, 0x1234                 ; D2 34 12
 jp gtu, 0x1234                 ; 28 03 D2 34 12
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
 jp.lil c, 0x1234               ; 5B DA 34 12
 jp.lil m, 0x1234               ; 5B FA 34 12
 jp.lil nc, 0x1234              ; 5B D2 34 12
 jp.lil nz, 0x1234              ; 5B C2 34 12
 jp.lil p, 0x1234               ; 5B F2 34 12
 jp.lil pe, 0x1234              ; 5B EA 34 12
 jp.lil po, 0x1234              ; 5B E2 34 12
 jp.lil z, 0x1234               ; 5B CA 34 12
 jp.sis c, 0x1234               ; 40 DA 34 12
 jp.sis m, 0x1234               ; 40 FA 34 12
 jp.sis nc, 0x1234              ; 40 D2 34 12
 jp.sis nz, 0x1234              ; 40 C2 34 12
 jp.sis p, 0x1234               ; 40 F2 34 12
 jp.sis pe, 0x1234              ; 40 EA 34 12
 jp.sis po, 0x1234              ; 40 E2 34 12
 jp.sis z, 0x1234               ; 40 CA 34 12
 jpe 0x1234                     ; EA 34 12
 jpo 0x1234                     ; E2 34 12
 jr ASMPC                       ; 18 FE
 jr c, ASMPC                    ; 38 FE
 jr eq, ASMPC                   ; 28 FE
 jr geu, ASMPC                  ; 30 FE
 jr gtu, ASMPC                  ; 28 02 30 FC
 jr leu, ASMPC                  ; 28 FE 38 FC
 jr ltu, ASMPC                  ; 38 FE
 jr nc, ASMPC                   ; 30 FE
 jr ne, ASMPC                   ; 20 FE
 jr nz, ASMPC                   ; 20 FE
 jr z, ASMPC                    ; 28 FE
 jv 0x1234                      ; EA 34 12
 jz 0x1234                      ; CA 34 12
 ldd                            ; CD @__z80asm__ldd
 lddr                           ; CD @__z80asm__lddr
 ldi                            ; CD @__z80asm__ldi
 ldir                           ; CD @__z80asm__ldir
 neg                            ; 2F 3C
 neg a                          ; 2F 3C
 or (hl)                        ; B6
 or (hl+)                       ; B6 23
 or (hl-)                       ; B6 2B
 or (ix)                        ; DD B6 00
 or (ix+0)                      ; DD B6 00
 or (ix+126)                    ; DD B6 7E
 or (ix-128)                    ; DD B6 80
 or (iy)                        ; FD B6 00
 or (iy+0)                      ; FD B6 00
 or (iy+126)                    ; FD B6 7E
 or (iy-128)                    ; FD B6 80
 or -128                        ; F6 80
 or 0                           ; F6 00
 or 127                         ; F6 7F
 or 255                         ; F6 FF
 or a                           ; B7
 or a, (hl)                     ; B6
 or a, (hl+)                    ; B6 23
 or a, (hl-)                    ; B6 2B
 or a, (ix)                     ; DD B6 00
 or a, (ix+0)                   ; DD B6 00
 or a, (ix+126)                 ; DD B6 7E
 or a, (ix-128)                 ; DD B6 80
 or a, (iy)                     ; FD B6 00
 or a, (iy+0)                   ; FD B6 00
 or a, (iy+126)                 ; FD B6 7E
 or a, (iy-128)                 ; FD B6 80
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
 or.l (hl)                      ; 49 B6
 or.l (hl+)                     ; 49 B6 49 23
 or.l (hl-)                     ; 49 B6 49 2B
 or.l (ix)                      ; 49 DD B6 00
 or.l (ix+0)                    ; 49 DD B6 00
 or.l (ix+126)                  ; 49 DD B6 7E
 or.l (ix-128)                  ; 49 DD B6 80
 or.l (iy)                      ; 49 FD B6 00
 or.l (iy+0)                    ; 49 FD B6 00
 or.l (iy+126)                  ; 49 FD B6 7E
 or.l (iy-128)                  ; 49 FD B6 80
 or.l a, (hl)                   ; 49 B6
 or.l a, (hl+)                  ; 49 B6 49 23
 or.l a, (hl-)                  ; 49 B6 49 2B
 or.l a, (ix)                   ; 49 DD B6 00
 or.l a, (ix+0)                 ; 49 DD B6 00
 or.l a, (ix+126)               ; 49 DD B6 7E
 or.l a, (ix-128)               ; 49 DD B6 80
 or.l a, (iy)                   ; 49 FD B6 00
 or.l a, (iy+0)                 ; 49 FD B6 00
 or.l a, (iy+126)               ; 49 FD B6 7E
 or.l a, (iy-128)               ; 49 FD B6 80
 or.lis (hl)                    ; 49 B6
 or.lis (hl+)                   ; 49 B6 49 23
 or.lis (hl-)                   ; 49 B6 49 2B
 or.lis (ix)                    ; 49 DD B6 00
 or.lis (ix+0)                  ; 49 DD B6 00
 or.lis (ix+126)                ; 49 DD B6 7E
 or.lis (ix-128)                ; 49 DD B6 80
 or.lis (iy)                    ; 49 FD B6 00
 or.lis (iy+0)                  ; 49 FD B6 00
 or.lis (iy+126)                ; 49 FD B6 7E
 or.lis (iy-128)                ; 49 FD B6 80
 or.lis a, (hl)                 ; 49 B6
 or.lis a, (hl+)                ; 49 B6 49 23
 or.lis a, (hl-)                ; 49 B6 49 2B
 or.lis a, (ix)                 ; 49 DD B6 00
 or.lis a, (ix+0)               ; 49 DD B6 00
 or.lis a, (ix+126)             ; 49 DD B6 7E
 or.lis a, (ix-128)             ; 49 DD B6 80
 or.lis a, (iy)                 ; 49 FD B6 00
 or.lis a, (iy+0)               ; 49 FD B6 00
 or.lis a, (iy+126)             ; 49 FD B6 7E
 or.lis a, (iy-128)             ; 49 FD B6 80
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
 otdr                           ; ED BB
 otdr.l                         ; 49 ED BB
 otdr.lis                       ; 49 ED BB
 otir                           ; ED B3
 otir.l                         ; 49 ED B3
 otir.lis                       ; 49 ED B3
 out (-128), a                  ; D3 80
 out (0), a                     ; D3 00
 out (127), a                   ; D3 7F
 out (255), a                   ; D3 FF
 out (bc), a                    ; ED 79
 out (bc), b                    ; ED 41
 out (bc), c                    ; ED 49
 out (bc), d                    ; ED 51
 out (bc), e                    ; ED 59
 out (bc), h                    ; ED 61
 out (bc), l                    ; ED 69
 out (c), a                     ; ED 79
 out (c), b                     ; ED 41
 out (c), c                     ; ED 49
 out (c), d                     ; ED 51
 out (c), e                     ; ED 59
 out (c), h                     ; ED 61
 out (c), l                     ; ED 69
 out -128                       ; D3 80
 out 0                          ; D3 00
 out 127                        ; D3 7F
 out 255                        ; D3 FF
 out0 (-128), a                 ; ED 39 80
 out0 (-128), b                 ; ED 01 80
 out0 (-128), c                 ; ED 09 80
 out0 (-128), d                 ; ED 11 80
 out0 (-128), e                 ; ED 19 80
 out0 (-128), h                 ; ED 21 80
 out0 (-128), l                 ; ED 29 80
 out0 (0), a                    ; ED 39 00
 out0 (0), b                    ; ED 01 00
 out0 (0), c                    ; ED 09 00
 out0 (0), d                    ; ED 11 00
 out0 (0), e                    ; ED 19 00
 out0 (0), h                    ; ED 21 00
 out0 (0), l                    ; ED 29 00
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
 outd.l                         ; 49 ED AB
 outd.lis                       ; 49 ED AB
 outi                           ; ED A3
 outi.l                         ; 49 ED A3
 outi.lis                       ; 49 ED A3
 rdel                           ; CD @__z80asm__rl_de
 res 0, (hl)                    ; CB 86
 res 0, (ix)                    ; DD CB 00 86
 res 0, (ix+0)                  ; DD CB 00 86
 res 0, (ix+126)                ; DD CB 7E 86
 res 0, (ix-128)                ; DD CB 80 86
 res 0, (iy)                    ; FD CB 00 86
 res 0, (iy+0)                  ; FD CB 00 86
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
 res 1, (ix+0)                  ; DD CB 00 8E
 res 1, (ix+126)                ; DD CB 7E 8E
 res 1, (ix-128)                ; DD CB 80 8E
 res 1, (iy)                    ; FD CB 00 8E
 res 1, (iy+0)                  ; FD CB 00 8E
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
 res 2, (ix+0)                  ; DD CB 00 96
 res 2, (ix+126)                ; DD CB 7E 96
 res 2, (ix-128)                ; DD CB 80 96
 res 2, (iy)                    ; FD CB 00 96
 res 2, (iy+0)                  ; FD CB 00 96
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
 res 3, (ix+0)                  ; DD CB 00 9E
 res 3, (ix+126)                ; DD CB 7E 9E
 res 3, (ix-128)                ; DD CB 80 9E
 res 3, (iy)                    ; FD CB 00 9E
 res 3, (iy+0)                  ; FD CB 00 9E
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
 res 4, (ix+0)                  ; DD CB 00 A6
 res 4, (ix+126)                ; DD CB 7E A6
 res 4, (ix-128)                ; DD CB 80 A6
 res 4, (iy)                    ; FD CB 00 A6
 res 4, (iy+0)                  ; FD CB 00 A6
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
 res 5, (ix+0)                  ; DD CB 00 AE
 res 5, (ix+126)                ; DD CB 7E AE
 res 5, (ix-128)                ; DD CB 80 AE
 res 5, (iy)                    ; FD CB 00 AE
 res 5, (iy+0)                  ; FD CB 00 AE
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
 res 6, (ix+0)                  ; DD CB 00 B6
 res 6, (ix+126)                ; DD CB 7E B6
 res 6, (ix-128)                ; DD CB 80 B6
 res 6, (iy)                    ; FD CB 00 B6
 res 6, (iy+0)                  ; FD CB 00 B6
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
 res 7, (ix+0)                  ; DD CB 00 BE
 res 7, (ix+126)                ; DD CB 7E BE
 res 7, (ix-128)                ; DD CB 80 BE
 res 7, (iy)                    ; FD CB 00 BE
 res 7, (iy+0)                  ; FD CB 00 BE
 res 7, (iy+126)                ; FD CB 7E BE
 res 7, (iy-128)                ; FD CB 80 BE
 res 7, a                       ; CB BF
 res 7, b                       ; CB B8
 res 7, c                       ; CB B9
 res 7, d                       ; CB BA
 res 7, e                       ; CB BB
 res 7, h                       ; CB BC
 res 7, l                       ; CB BD
 res.l 0, (hl)                  ; 49 CB 86
 res.l 0, (ix)                  ; 49 DD CB 00 86
 res.l 0, (ix+0)                ; 49 DD CB 00 86
 res.l 0, (ix+126)              ; 49 DD CB 7E 86
 res.l 0, (ix-128)              ; 49 DD CB 80 86
 res.l 0, (iy)                  ; 49 FD CB 00 86
 res.l 0, (iy+0)                ; 49 FD CB 00 86
 res.l 0, (iy+126)              ; 49 FD CB 7E 86
 res.l 0, (iy-128)              ; 49 FD CB 80 86
 res.l 1, (hl)                  ; 49 CB 8E
 res.l 1, (ix)                  ; 49 DD CB 00 8E
 res.l 1, (ix+0)                ; 49 DD CB 00 8E
 res.l 1, (ix+126)              ; 49 DD CB 7E 8E
 res.l 1, (ix-128)              ; 49 DD CB 80 8E
 res.l 1, (iy)                  ; 49 FD CB 00 8E
 res.l 1, (iy+0)                ; 49 FD CB 00 8E
 res.l 1, (iy+126)              ; 49 FD CB 7E 8E
 res.l 1, (iy-128)              ; 49 FD CB 80 8E
 res.l 2, (hl)                  ; 49 CB 96
 res.l 2, (ix)                  ; 49 DD CB 00 96
 res.l 2, (ix+0)                ; 49 DD CB 00 96
 res.l 2, (ix+126)              ; 49 DD CB 7E 96
 res.l 2, (ix-128)              ; 49 DD CB 80 96
 res.l 2, (iy)                  ; 49 FD CB 00 96
 res.l 2, (iy+0)                ; 49 FD CB 00 96
 res.l 2, (iy+126)              ; 49 FD CB 7E 96
 res.l 2, (iy-128)              ; 49 FD CB 80 96
 res.l 3, (hl)                  ; 49 CB 9E
 res.l 3, (ix)                  ; 49 DD CB 00 9E
 res.l 3, (ix+0)                ; 49 DD CB 00 9E
 res.l 3, (ix+126)              ; 49 DD CB 7E 9E
 res.l 3, (ix-128)              ; 49 DD CB 80 9E
 res.l 3, (iy)                  ; 49 FD CB 00 9E
 res.l 3, (iy+0)                ; 49 FD CB 00 9E
 res.l 3, (iy+126)              ; 49 FD CB 7E 9E
 res.l 3, (iy-128)              ; 49 FD CB 80 9E
 res.l 4, (hl)                  ; 49 CB A6
 res.l 4, (ix)                  ; 49 DD CB 00 A6
 res.l 4, (ix+0)                ; 49 DD CB 00 A6
 res.l 4, (ix+126)              ; 49 DD CB 7E A6
 res.l 4, (ix-128)              ; 49 DD CB 80 A6
 res.l 4, (iy)                  ; 49 FD CB 00 A6
 res.l 4, (iy+0)                ; 49 FD CB 00 A6
 res.l 4, (iy+126)              ; 49 FD CB 7E A6
 res.l 4, (iy-128)              ; 49 FD CB 80 A6
 res.l 5, (hl)                  ; 49 CB AE
 res.l 5, (ix)                  ; 49 DD CB 00 AE
 res.l 5, (ix+0)                ; 49 DD CB 00 AE
 res.l 5, (ix+126)              ; 49 DD CB 7E AE
 res.l 5, (ix-128)              ; 49 DD CB 80 AE
 res.l 5, (iy)                  ; 49 FD CB 00 AE
 res.l 5, (iy+0)                ; 49 FD CB 00 AE
 res.l 5, (iy+126)              ; 49 FD CB 7E AE
 res.l 5, (iy-128)              ; 49 FD CB 80 AE
 res.l 6, (hl)                  ; 49 CB B6
 res.l 6, (ix)                  ; 49 DD CB 00 B6
 res.l 6, (ix+0)                ; 49 DD CB 00 B6
 res.l 6, (ix+126)              ; 49 DD CB 7E B6
 res.l 6, (ix-128)              ; 49 DD CB 80 B6
 res.l 6, (iy)                  ; 49 FD CB 00 B6
 res.l 6, (iy+0)                ; 49 FD CB 00 B6
 res.l 6, (iy+126)              ; 49 FD CB 7E B6
 res.l 6, (iy-128)              ; 49 FD CB 80 B6
 res.l 7, (hl)                  ; 49 CB BE
 res.l 7, (ix)                  ; 49 DD CB 00 BE
 res.l 7, (ix+0)                ; 49 DD CB 00 BE
 res.l 7, (ix+126)              ; 49 DD CB 7E BE
 res.l 7, (ix-128)              ; 49 DD CB 80 BE
 res.l 7, (iy)                  ; 49 FD CB 00 BE
 res.l 7, (iy+0)                ; 49 FD CB 00 BE
 res.l 7, (iy+126)              ; 49 FD CB 7E BE
 res.l 7, (iy-128)              ; 49 FD CB 80 BE
 res.lis 0, (hl)                ; 49 CB 86
 res.lis 0, (ix)                ; 49 DD CB 00 86
 res.lis 0, (ix+0)              ; 49 DD CB 00 86
 res.lis 0, (ix+126)            ; 49 DD CB 7E 86
 res.lis 0, (ix-128)            ; 49 DD CB 80 86
 res.lis 0, (iy)                ; 49 FD CB 00 86
 res.lis 0, (iy+0)              ; 49 FD CB 00 86
 res.lis 0, (iy+126)            ; 49 FD CB 7E 86
 res.lis 0, (iy-128)            ; 49 FD CB 80 86
 res.lis 1, (hl)                ; 49 CB 8E
 res.lis 1, (ix)                ; 49 DD CB 00 8E
 res.lis 1, (ix+0)              ; 49 DD CB 00 8E
 res.lis 1, (ix+126)            ; 49 DD CB 7E 8E
 res.lis 1, (ix-128)            ; 49 DD CB 80 8E
 res.lis 1, (iy)                ; 49 FD CB 00 8E
 res.lis 1, (iy+0)              ; 49 FD CB 00 8E
 res.lis 1, (iy+126)            ; 49 FD CB 7E 8E
 res.lis 1, (iy-128)            ; 49 FD CB 80 8E
 res.lis 2, (hl)                ; 49 CB 96
 res.lis 2, (ix)                ; 49 DD CB 00 96
 res.lis 2, (ix+0)              ; 49 DD CB 00 96
 res.lis 2, (ix+126)            ; 49 DD CB 7E 96
 res.lis 2, (ix-128)            ; 49 DD CB 80 96
 res.lis 2, (iy)                ; 49 FD CB 00 96
 res.lis 2, (iy+0)              ; 49 FD CB 00 96
 res.lis 2, (iy+126)            ; 49 FD CB 7E 96
 res.lis 2, (iy-128)            ; 49 FD CB 80 96
 res.lis 3, (hl)                ; 49 CB 9E
 res.lis 3, (ix)                ; 49 DD CB 00 9E
 res.lis 3, (ix+0)              ; 49 DD CB 00 9E
 res.lis 3, (ix+126)            ; 49 DD CB 7E 9E
 res.lis 3, (ix-128)            ; 49 DD CB 80 9E
 res.lis 3, (iy)                ; 49 FD CB 00 9E
 res.lis 3, (iy+0)              ; 49 FD CB 00 9E
 res.lis 3, (iy+126)            ; 49 FD CB 7E 9E
 res.lis 3, (iy-128)            ; 49 FD CB 80 9E
 res.lis 4, (hl)                ; 49 CB A6
 res.lis 4, (ix)                ; 49 DD CB 00 A6
 res.lis 4, (ix+0)              ; 49 DD CB 00 A6
 res.lis 4, (ix+126)            ; 49 DD CB 7E A6
 res.lis 4, (ix-128)            ; 49 DD CB 80 A6
 res.lis 4, (iy)                ; 49 FD CB 00 A6
 res.lis 4, (iy+0)              ; 49 FD CB 00 A6
 res.lis 4, (iy+126)            ; 49 FD CB 7E A6
 res.lis 4, (iy-128)            ; 49 FD CB 80 A6
 res.lis 5, (hl)                ; 49 CB AE
 res.lis 5, (ix)                ; 49 DD CB 00 AE
 res.lis 5, (ix+0)              ; 49 DD CB 00 AE
 res.lis 5, (ix+126)            ; 49 DD CB 7E AE
 res.lis 5, (ix-128)            ; 49 DD CB 80 AE
 res.lis 5, (iy)                ; 49 FD CB 00 AE
 res.lis 5, (iy+0)              ; 49 FD CB 00 AE
 res.lis 5, (iy+126)            ; 49 FD CB 7E AE
 res.lis 5, (iy-128)            ; 49 FD CB 80 AE
 res.lis 6, (hl)                ; 49 CB B6
 res.lis 6, (ix)                ; 49 DD CB 00 B6
 res.lis 6, (ix+0)              ; 49 DD CB 00 B6
 res.lis 6, (ix+126)            ; 49 DD CB 7E B6
 res.lis 6, (ix-128)            ; 49 DD CB 80 B6
 res.lis 6, (iy)                ; 49 FD CB 00 B6
 res.lis 6, (iy+0)              ; 49 FD CB 00 B6
 res.lis 6, (iy+126)            ; 49 FD CB 7E B6
 res.lis 6, (iy-128)            ; 49 FD CB 80 B6
 res.lis 7, (hl)                ; 49 CB BE
 res.lis 7, (ix)                ; 49 DD CB 00 BE
 res.lis 7, (ix+0)              ; 49 DD CB 00 BE
 res.lis 7, (ix+126)            ; 49 DD CB 7E BE
 res.lis 7, (ix-128)            ; 49 DD CB 80 BE
 res.lis 7, (iy)                ; 49 FD CB 00 BE
 res.lis 7, (iy+0)              ; 49 FD CB 00 BE
 res.lis 7, (iy+126)            ; 49 FD CB 7E BE
 res.lis 7, (iy-128)            ; 49 FD CB 80 BE
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
 sbc (ix)                       ; DD 9E 00
 sbc (ix+0)                     ; DD 9E 00
 sbc (ix+126)                   ; DD 9E 7E
 sbc (ix-128)                   ; DD 9E 80
 sbc (iy)                       ; FD 9E 00
 sbc (iy+0)                     ; FD 9E 00
 sbc (iy+126)                   ; FD 9E 7E
 sbc (iy-128)                   ; FD 9E 80
 sbc -128                       ; DE 80
 sbc 0                          ; DE 00
 sbc 127                        ; DE 7F
 sbc 255                        ; DE FF
 sbc a                          ; 9F
 sbc a, (hl)                    ; 9E
 sbc a, (hl+)                   ; 9E 23
 sbc a, (hl-)                   ; 9E 2B
 sbc a, (ix)                    ; DD 9E 00
 sbc a, (ix+0)                  ; DD 9E 00
 sbc a, (ix+126)                ; DD 9E 7E
 sbc a, (ix-128)                ; DD 9E 80
 sbc a, (iy)                    ; FD 9E 00
 sbc a, (iy+0)                  ; FD 9E 00
 sbc a, (iy+126)                ; FD 9E 7E
 sbc a, (iy-128)                ; FD 9E 80
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
 sbc.l (hl)                     ; 49 9E
 sbc.l (hl+)                    ; 49 9E 49 23
 sbc.l (hl-)                    ; 49 9E 49 2B
 sbc.l (ix)                     ; 49 DD 9E 00
 sbc.l (ix+0)                   ; 49 DD 9E 00
 sbc.l (ix+126)                 ; 49 DD 9E 7E
 sbc.l (ix-128)                 ; 49 DD 9E 80
 sbc.l (iy)                     ; 49 FD 9E 00
 sbc.l (iy+0)                   ; 49 FD 9E 00
 sbc.l (iy+126)                 ; 49 FD 9E 7E
 sbc.l (iy-128)                 ; 49 FD 9E 80
 sbc.l a, (hl)                  ; 49 9E
 sbc.l a, (hl+)                 ; 49 9E 49 23
 sbc.l a, (hl-)                 ; 49 9E 49 2B
 sbc.l a, (ix)                  ; 49 DD 9E 00
 sbc.l a, (ix+0)                ; 49 DD 9E 00
 sbc.l a, (ix+126)              ; 49 DD 9E 7E
 sbc.l a, (ix-128)              ; 49 DD 9E 80
 sbc.l a, (iy)                  ; 49 FD 9E 00
 sbc.l a, (iy+0)                ; 49 FD 9E 00
 sbc.l a, (iy+126)              ; 49 FD 9E 7E
 sbc.l a, (iy-128)              ; 49 FD 9E 80
 sbc.l hl, bc                   ; 49 ED 42
 sbc.l hl, de                   ; 49 ED 52
 sbc.l hl, hl                   ; 49 ED 62
 sbc.l hl, sp                   ; 49 ED 72
 sbc.lis (hl)                   ; 49 9E
 sbc.lis (hl+)                  ; 49 9E 49 23
 sbc.lis (hl-)                  ; 49 9E 49 2B
 sbc.lis (ix)                   ; 49 DD 9E 00
 sbc.lis (ix+0)                 ; 49 DD 9E 00
 sbc.lis (ix+126)               ; 49 DD 9E 7E
 sbc.lis (ix-128)               ; 49 DD 9E 80
 sbc.lis (iy)                   ; 49 FD 9E 00
 sbc.lis (iy+0)                 ; 49 FD 9E 00
 sbc.lis (iy+126)               ; 49 FD 9E 7E
 sbc.lis (iy-128)               ; 49 FD 9E 80
 sbc.lis a, (hl)                ; 49 9E
 sbc.lis a, (hl+)               ; 49 9E 49 23
 sbc.lis a, (hl-)               ; 49 9E 49 2B
 sbc.lis a, (ix)                ; 49 DD 9E 00
 sbc.lis a, (ix+0)              ; 49 DD 9E 00
 sbc.lis a, (ix+126)            ; 49 DD 9E 7E
 sbc.lis a, (ix-128)            ; 49 DD 9E 80
 sbc.lis a, (iy)                ; 49 FD 9E 00
 sbc.lis a, (iy+0)              ; 49 FD 9E 00
 sbc.lis a, (iy+126)            ; 49 FD 9E 7E
 sbc.lis a, (iy-128)            ; 49 FD 9E 80
 sbc.lis hl, bc                 ; 49 ED 42
 sbc.lis hl, de                 ; 49 ED 52
 sbc.lis hl, hl                 ; 49 ED 62
 sbc.lis hl, sp                 ; 49 ED 72
 sbi -128                       ; DE 80
 sbi 0                          ; DE 00
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 set 0, (hl)                    ; CB C6
 set 0, (ix)                    ; DD CB 00 C6
 set 0, (ix+0)                  ; DD CB 00 C6
 set 0, (ix+126)                ; DD CB 7E C6
 set 0, (ix-128)                ; DD CB 80 C6
 set 0, (iy)                    ; FD CB 00 C6
 set 0, (iy+0)                  ; FD CB 00 C6
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
 set 1, (ix+0)                  ; DD CB 00 CE
 set 1, (ix+126)                ; DD CB 7E CE
 set 1, (ix-128)                ; DD CB 80 CE
 set 1, (iy)                    ; FD CB 00 CE
 set 1, (iy+0)                  ; FD CB 00 CE
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
 set 2, (ix+0)                  ; DD CB 00 D6
 set 2, (ix+126)                ; DD CB 7E D6
 set 2, (ix-128)                ; DD CB 80 D6
 set 2, (iy)                    ; FD CB 00 D6
 set 2, (iy+0)                  ; FD CB 00 D6
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
 set 3, (ix+0)                  ; DD CB 00 DE
 set 3, (ix+126)                ; DD CB 7E DE
 set 3, (ix-128)                ; DD CB 80 DE
 set 3, (iy)                    ; FD CB 00 DE
 set 3, (iy+0)                  ; FD CB 00 DE
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
 set 4, (ix+0)                  ; DD CB 00 E6
 set 4, (ix+126)                ; DD CB 7E E6
 set 4, (ix-128)                ; DD CB 80 E6
 set 4, (iy)                    ; FD CB 00 E6
 set 4, (iy+0)                  ; FD CB 00 E6
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
 set 5, (ix+0)                  ; DD CB 00 EE
 set 5, (ix+126)                ; DD CB 7E EE
 set 5, (ix-128)                ; DD CB 80 EE
 set 5, (iy)                    ; FD CB 00 EE
 set 5, (iy+0)                  ; FD CB 00 EE
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
 set 6, (ix+0)                  ; DD CB 00 F6
 set 6, (ix+126)                ; DD CB 7E F6
 set 6, (ix-128)                ; DD CB 80 F6
 set 6, (iy)                    ; FD CB 00 F6
 set 6, (iy+0)                  ; FD CB 00 F6
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
 set 7, (ix+0)                  ; DD CB 00 FE
 set 7, (ix+126)                ; DD CB 7E FE
 set 7, (ix-128)                ; DD CB 80 FE
 set 7, (iy)                    ; FD CB 00 FE
 set 7, (iy+0)                  ; FD CB 00 FE
 set 7, (iy+126)                ; FD CB 7E FE
 set 7, (iy-128)                ; FD CB 80 FE
 set 7, a                       ; CB FF
 set 7, b                       ; CB F8
 set 7, c                       ; CB F9
 set 7, d                       ; CB FA
 set 7, e                       ; CB FB
 set 7, h                       ; CB FC
 set 7, l                       ; CB FD
 set.l 0, (hl)                  ; 49 CB C6
 set.l 0, (ix)                  ; 49 DD CB 00 C6
 set.l 0, (ix+0)                ; 49 DD CB 00 C6
 set.l 0, (ix+126)              ; 49 DD CB 7E C6
 set.l 0, (ix-128)              ; 49 DD CB 80 C6
 set.l 0, (iy)                  ; 49 FD CB 00 C6
 set.l 0, (iy+0)                ; 49 FD CB 00 C6
 set.l 0, (iy+126)              ; 49 FD CB 7E C6
 set.l 0, (iy-128)              ; 49 FD CB 80 C6
 set.l 1, (hl)                  ; 49 CB CE
 set.l 1, (ix)                  ; 49 DD CB 00 CE
 set.l 1, (ix+0)                ; 49 DD CB 00 CE
 set.l 1, (ix+126)              ; 49 DD CB 7E CE
 set.l 1, (ix-128)              ; 49 DD CB 80 CE
 set.l 1, (iy)                  ; 49 FD CB 00 CE
 set.l 1, (iy+0)                ; 49 FD CB 00 CE
 set.l 1, (iy+126)              ; 49 FD CB 7E CE
 set.l 1, (iy-128)              ; 49 FD CB 80 CE
 set.l 2, (hl)                  ; 49 CB D6
 set.l 2, (ix)                  ; 49 DD CB 00 D6
 set.l 2, (ix+0)                ; 49 DD CB 00 D6
 set.l 2, (ix+126)              ; 49 DD CB 7E D6
 set.l 2, (ix-128)              ; 49 DD CB 80 D6
 set.l 2, (iy)                  ; 49 FD CB 00 D6
 set.l 2, (iy+0)                ; 49 FD CB 00 D6
 set.l 2, (iy+126)              ; 49 FD CB 7E D6
 set.l 2, (iy-128)              ; 49 FD CB 80 D6
 set.l 3, (hl)                  ; 49 CB DE
 set.l 3, (ix)                  ; 49 DD CB 00 DE
 set.l 3, (ix+0)                ; 49 DD CB 00 DE
 set.l 3, (ix+126)              ; 49 DD CB 7E DE
 set.l 3, (ix-128)              ; 49 DD CB 80 DE
 set.l 3, (iy)                  ; 49 FD CB 00 DE
 set.l 3, (iy+0)                ; 49 FD CB 00 DE
 set.l 3, (iy+126)              ; 49 FD CB 7E DE
 set.l 3, (iy-128)              ; 49 FD CB 80 DE
 set.l 4, (hl)                  ; 49 CB E6
 set.l 4, (ix)                  ; 49 DD CB 00 E6
 set.l 4, (ix+0)                ; 49 DD CB 00 E6
 set.l 4, (ix+126)              ; 49 DD CB 7E E6
 set.l 4, (ix-128)              ; 49 DD CB 80 E6
 set.l 4, (iy)                  ; 49 FD CB 00 E6
 set.l 4, (iy+0)                ; 49 FD CB 00 E6
 set.l 4, (iy+126)              ; 49 FD CB 7E E6
 set.l 4, (iy-128)              ; 49 FD CB 80 E6
 set.l 5, (hl)                  ; 49 CB EE
 set.l 5, (ix)                  ; 49 DD CB 00 EE
 set.l 5, (ix+0)                ; 49 DD CB 00 EE
 set.l 5, (ix+126)              ; 49 DD CB 7E EE
 set.l 5, (ix-128)              ; 49 DD CB 80 EE
 set.l 5, (iy)                  ; 49 FD CB 00 EE
 set.l 5, (iy+0)                ; 49 FD CB 00 EE
 set.l 5, (iy+126)              ; 49 FD CB 7E EE
 set.l 5, (iy-128)              ; 49 FD CB 80 EE
 set.l 6, (hl)                  ; 49 CB F6
 set.l 6, (ix)                  ; 49 DD CB 00 F6
 set.l 6, (ix+0)                ; 49 DD CB 00 F6
 set.l 6, (ix+126)              ; 49 DD CB 7E F6
 set.l 6, (ix-128)              ; 49 DD CB 80 F6
 set.l 6, (iy)                  ; 49 FD CB 00 F6
 set.l 6, (iy+0)                ; 49 FD CB 00 F6
 set.l 6, (iy+126)              ; 49 FD CB 7E F6
 set.l 6, (iy-128)              ; 49 FD CB 80 F6
 set.l 7, (hl)                  ; 49 CB FE
 set.l 7, (ix)                  ; 49 DD CB 00 FE
 set.l 7, (ix+0)                ; 49 DD CB 00 FE
 set.l 7, (ix+126)              ; 49 DD CB 7E FE
 set.l 7, (ix-128)              ; 49 DD CB 80 FE
 set.l 7, (iy)                  ; 49 FD CB 00 FE
 set.l 7, (iy+0)                ; 49 FD CB 00 FE
 set.l 7, (iy+126)              ; 49 FD CB 7E FE
 set.l 7, (iy-128)              ; 49 FD CB 80 FE
 set.lis 0, (hl)                ; 49 CB C6
 set.lis 0, (ix)                ; 49 DD CB 00 C6
 set.lis 0, (ix+0)              ; 49 DD CB 00 C6
 set.lis 0, (ix+126)            ; 49 DD CB 7E C6
 set.lis 0, (ix-128)            ; 49 DD CB 80 C6
 set.lis 0, (iy)                ; 49 FD CB 00 C6
 set.lis 0, (iy+0)              ; 49 FD CB 00 C6
 set.lis 0, (iy+126)            ; 49 FD CB 7E C6
 set.lis 0, (iy-128)            ; 49 FD CB 80 C6
 set.lis 1, (hl)                ; 49 CB CE
 set.lis 1, (ix)                ; 49 DD CB 00 CE
 set.lis 1, (ix+0)              ; 49 DD CB 00 CE
 set.lis 1, (ix+126)            ; 49 DD CB 7E CE
 set.lis 1, (ix-128)            ; 49 DD CB 80 CE
 set.lis 1, (iy)                ; 49 FD CB 00 CE
 set.lis 1, (iy+0)              ; 49 FD CB 00 CE
 set.lis 1, (iy+126)            ; 49 FD CB 7E CE
 set.lis 1, (iy-128)            ; 49 FD CB 80 CE
 set.lis 2, (hl)                ; 49 CB D6
 set.lis 2, (ix)                ; 49 DD CB 00 D6
 set.lis 2, (ix+0)              ; 49 DD CB 00 D6
 set.lis 2, (ix+126)            ; 49 DD CB 7E D6
 set.lis 2, (ix-128)            ; 49 DD CB 80 D6
 set.lis 2, (iy)                ; 49 FD CB 00 D6
 set.lis 2, (iy+0)              ; 49 FD CB 00 D6
 set.lis 2, (iy+126)            ; 49 FD CB 7E D6
 set.lis 2, (iy-128)            ; 49 FD CB 80 D6
 set.lis 3, (hl)                ; 49 CB DE
 set.lis 3, (ix)                ; 49 DD CB 00 DE
 set.lis 3, (ix+0)              ; 49 DD CB 00 DE
 set.lis 3, (ix+126)            ; 49 DD CB 7E DE
 set.lis 3, (ix-128)            ; 49 DD CB 80 DE
 set.lis 3, (iy)                ; 49 FD CB 00 DE
 set.lis 3, (iy+0)              ; 49 FD CB 00 DE
 set.lis 3, (iy+126)            ; 49 FD CB 7E DE
 set.lis 3, (iy-128)            ; 49 FD CB 80 DE
 set.lis 4, (hl)                ; 49 CB E6
 set.lis 4, (ix)                ; 49 DD CB 00 E6
 set.lis 4, (ix+0)              ; 49 DD CB 00 E6
 set.lis 4, (ix+126)            ; 49 DD CB 7E E6
 set.lis 4, (ix-128)            ; 49 DD CB 80 E6
 set.lis 4, (iy)                ; 49 FD CB 00 E6
 set.lis 4, (iy+0)              ; 49 FD CB 00 E6
 set.lis 4, (iy+126)            ; 49 FD CB 7E E6
 set.lis 4, (iy-128)            ; 49 FD CB 80 E6
 set.lis 5, (hl)                ; 49 CB EE
 set.lis 5, (ix)                ; 49 DD CB 00 EE
 set.lis 5, (ix+0)              ; 49 DD CB 00 EE
 set.lis 5, (ix+126)            ; 49 DD CB 7E EE
 set.lis 5, (ix-128)            ; 49 DD CB 80 EE
 set.lis 5, (iy)                ; 49 FD CB 00 EE
 set.lis 5, (iy+0)              ; 49 FD CB 00 EE
 set.lis 5, (iy+126)            ; 49 FD CB 7E EE
 set.lis 5, (iy-128)            ; 49 FD CB 80 EE
 set.lis 6, (hl)                ; 49 CB F6
 set.lis 6, (ix)                ; 49 DD CB 00 F6
 set.lis 6, (ix+0)              ; 49 DD CB 00 F6
 set.lis 6, (ix+126)            ; 49 DD CB 7E F6
 set.lis 6, (ix-128)            ; 49 DD CB 80 F6
 set.lis 6, (iy)                ; 49 FD CB 00 F6
 set.lis 6, (iy+0)              ; 49 FD CB 00 F6
 set.lis 6, (iy+126)            ; 49 FD CB 7E F6
 set.lis 6, (iy-128)            ; 49 FD CB 80 F6
 set.lis 7, (hl)                ; 49 CB FE
 set.lis 7, (ix)                ; 49 DD CB 00 FE
 set.lis 7, (ix+0)              ; 49 DD CB 00 FE
 set.lis 7, (ix+126)            ; 49 DD CB 7E FE
 set.lis 7, (ix-128)            ; 49 DD CB 80 FE
 set.lis 7, (iy)                ; 49 FD CB 00 FE
 set.lis 7, (iy+0)              ; 49 FD CB 00 FE
 set.lis 7, (iy+126)            ; 49 FD CB 7E FE
 set.lis 7, (iy-128)            ; 49 FD CB 80 FE
 sra bc                         ; CD @__z80asm__sra_bc
 sra de                         ; CD @__z80asm__sra_de
 sra hl                         ; CD @__z80asm__sra_hl
 sub (hl)                       ; 96
 sub (hl+)                      ; 96 23
 sub (hl-)                      ; 96 2B
 sub (ix)                       ; DD 96 00
 sub (ix+0)                     ; DD 96 00
 sub (ix+126)                   ; DD 96 7E
 sub (ix-128)                   ; DD 96 80
 sub (iy)                       ; FD 96 00
 sub (iy+0)                     ; FD 96 00
 sub (iy+126)                   ; FD 96 7E
 sub (iy-128)                   ; FD 96 80
 sub -128                       ; D6 80
 sub 0                          ; D6 00
 sub 127                        ; D6 7F
 sub 255                        ; D6 FF
 sub a                          ; 97
 sub a, (hl)                    ; 96
 sub a, (hl+)                   ; 96 23
 sub a, (hl-)                   ; 96 2B
 sub a, (ix)                    ; DD 96 00
 sub a, (ix+0)                  ; DD 96 00
 sub a, (ix+126)                ; DD 96 7E
 sub a, (ix-128)                ; DD 96 80
 sub a, (iy)                    ; FD 96 00
 sub a, (iy+0)                  ; FD 96 00
 sub a, (iy+126)                ; FD 96 7E
 sub a, (iy-128)                ; FD 96 80
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
 sub.l (hl)                     ; 49 96
 sub.l (hl+)                    ; 49 96 49 23
 sub.l (hl-)                    ; 49 96 49 2B
 sub.l (ix)                     ; 49 DD 96 00
 sub.l (ix+0)                   ; 49 DD 96 00
 sub.l (ix+126)                 ; 49 DD 96 7E
 sub.l (ix-128)                 ; 49 DD 96 80
 sub.l (iy)                     ; 49 FD 96 00
 sub.l (iy+0)                   ; 49 FD 96 00
 sub.l (iy+126)                 ; 49 FD 96 7E
 sub.l (iy-128)                 ; 49 FD 96 80
 sub.l a, (hl)                  ; 49 96
 sub.l a, (hl+)                 ; 49 96 49 23
 sub.l a, (hl-)                 ; 49 96 49 2B
 sub.l a, (ix)                  ; 49 DD 96 00
 sub.l a, (ix+0)                ; 49 DD 96 00
 sub.l a, (ix+126)              ; 49 DD 96 7E
 sub.l a, (ix-128)              ; 49 DD 96 80
 sub.l a, (iy)                  ; 49 FD 96 00
 sub.l a, (iy+0)                ; 49 FD 96 00
 sub.l a, (iy+126)              ; 49 FD 96 7E
 sub.l a, (iy-128)              ; 49 FD 96 80
 sub.lis (hl)                   ; 49 96
 sub.lis (hl+)                  ; 49 96 49 23
 sub.lis (hl-)                  ; 49 96 49 2B
 sub.lis (ix)                   ; 49 DD 96 00
 sub.lis (ix+0)                 ; 49 DD 96 00
 sub.lis (ix+126)               ; 49 DD 96 7E
 sub.lis (ix-128)               ; 49 DD 96 80
 sub.lis (iy)                   ; 49 FD 96 00
 sub.lis (iy+0)                 ; 49 FD 96 00
 sub.lis (iy+126)               ; 49 FD 96 7E
 sub.lis (iy-128)               ; 49 FD 96 80
 sub.lis a, (hl)                ; 49 96
 sub.lis a, (hl+)               ; 49 96 49 23
 sub.lis a, (hl-)               ; 49 96 49 2B
 sub.lis a, (ix)                ; 49 DD 96 00
 sub.lis a, (ix+0)              ; 49 DD 96 00
 sub.lis a, (ix+126)            ; 49 DD 96 7E
 sub.lis a, (ix-128)            ; 49 DD 96 80
 sub.lis a, (iy)                ; 49 FD 96 00
 sub.lis a, (iy+0)              ; 49 FD 96 00
 sub.lis a, (iy+126)            ; 49 FD 96 7E
 sub.lis a, (iy-128)            ; 49 FD 96 80
 sui -128                       ; D6 80
 sui 0                          ; D6 00
 sui 127                        ; D6 7F
 sui 255                        ; D6 FF
 xchg                           ; EB
 xor (hl)                       ; AE
 xor (hl+)                      ; AE 23
 xor (hl-)                      ; AE 2B
 xor (ix)                       ; DD AE 00
 xor (ix+0)                     ; DD AE 00
 xor (ix+126)                   ; DD AE 7E
 xor (ix-128)                   ; DD AE 80
 xor (iy)                       ; FD AE 00
 xor (iy+0)                     ; FD AE 00
 xor (iy+126)                   ; FD AE 7E
 xor (iy-128)                   ; FD AE 80
 xor -128                       ; EE 80
 xor 0                          ; EE 00
 xor 127                        ; EE 7F
 xor 255                        ; EE FF
 xor a                          ; AF
 xor a, (hl)                    ; AE
 xor a, (hl+)                   ; AE 23
 xor a, (hl-)                   ; AE 2B
 xor a, (ix)                    ; DD AE 00
 xor a, (ix+0)                  ; DD AE 00
 xor a, (ix+126)                ; DD AE 7E
 xor a, (ix-128)                ; DD AE 80
 xor a, (iy)                    ; FD AE 00
 xor a, (iy+0)                  ; FD AE 00
 xor a, (iy+126)                ; FD AE 7E
 xor a, (iy-128)                ; FD AE 80
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
 xor.l (hl)                     ; 49 AE
 xor.l (hl+)                    ; 49 AE 49 23
 xor.l (hl-)                    ; 49 AE 49 2B
 xor.l (ix)                     ; 49 DD AE 00
 xor.l (ix+0)                   ; 49 DD AE 00
 xor.l (ix+126)                 ; 49 DD AE 7E
 xor.l (ix-128)                 ; 49 DD AE 80
 xor.l (iy)                     ; 49 FD AE 00
 xor.l (iy+0)                   ; 49 FD AE 00
 xor.l (iy+126)                 ; 49 FD AE 7E
 xor.l (iy-128)                 ; 49 FD AE 80
 xor.l a, (hl)                  ; 49 AE
 xor.l a, (hl+)                 ; 49 AE 49 23
 xor.l a, (hl-)                 ; 49 AE 49 2B
 xor.l a, (ix)                  ; 49 DD AE 00
 xor.l a, (ix+0)                ; 49 DD AE 00
 xor.l a, (ix+126)              ; 49 DD AE 7E
 xor.l a, (ix-128)              ; 49 DD AE 80
 xor.l a, (iy)                  ; 49 FD AE 00
 xor.l a, (iy+0)                ; 49 FD AE 00
 xor.l a, (iy+126)              ; 49 FD AE 7E
 xor.l a, (iy-128)              ; 49 FD AE 80
 xor.lis (hl)                   ; 49 AE
 xor.lis (hl+)                  ; 49 AE 49 23
 xor.lis (hl-)                  ; 49 AE 49 2B
 xor.lis (ix)                   ; 49 DD AE 00
 xor.lis (ix+0)                 ; 49 DD AE 00
 xor.lis (ix+126)               ; 49 DD AE 7E
 xor.lis (ix-128)               ; 49 DD AE 80
 xor.lis (iy)                   ; 49 FD AE 00
 xor.lis (iy+0)                 ; 49 FD AE 00
 xor.lis (iy+126)               ; 49 FD AE 7E
 xor.lis (iy-128)               ; 49 FD AE 80
 xor.lis a, (hl)                ; 49 AE
 xor.lis a, (hl+)               ; 49 AE 49 23
 xor.lis a, (hl-)               ; 49 AE 49 2B
 xor.lis a, (ix)                ; 49 DD AE 00
 xor.lis a, (ix+0)              ; 49 DD AE 00
 xor.lis a, (ix+126)            ; 49 DD AE 7E
 xor.lis a, (ix-128)            ; 49 DD AE 80
 xor.lis a, (iy)                ; 49 FD AE 00
 xor.lis a, (iy+0)              ; 49 FD AE 00
 xor.lis a, (iy+126)            ; 49 FD AE 7E
 xor.lis a, (iy-128)            ; 49 FD AE 80
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
