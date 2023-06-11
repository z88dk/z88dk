 .assume adl=0
 aci -128                       ; CE 80
 aci 127                        ; CE 7F
 aci 255                        ; CE FF
 adc (hl)                       ; 8E
 adc (hl+)                      ; 8E 23
 adc (hl-)                      ; 8E 2B
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
 adc a, (hl+)                   ; 8E 23
 adc a, (hl-)                   ; 8E 2B
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
 adc m                          ; 8E
 adc.l (hl)                     ; 49 8E
 adc.l (hl+)                    ; 49 8E 23
 adc.l (hl-)                    ; 49 8E 2B
 adc.l (ix)                     ; 49 DD 8E 00
 adc.l (ix+127)                 ; 49 DD 8E 7F
 adc.l (ix-128)                 ; 49 DD 8E 80
 adc.l (iy)                     ; 49 FD 8E 00
 adc.l (iy+127)                 ; 49 FD 8E 7F
 adc.l (iy-128)                 ; 49 FD 8E 80
 adc.l a, (hl)                  ; 49 8E
 adc.l a, (hl+)                 ; 49 8E 23
 adc.l a, (hl-)                 ; 49 8E 2B
 adc.l a, (ix)                  ; 49 DD 8E 00
 adc.l a, (ix+127)              ; 49 DD 8E 7F
 adc.l a, (ix-128)              ; 49 DD 8E 80
 adc.l a, (iy)                  ; 49 FD 8E 00
 adc.l a, (iy+127)              ; 49 FD 8E 7F
 adc.l a, (iy-128)              ; 49 FD 8E 80
 adc.l hl, bc                   ; 49 ED 4A
 adc.l hl, de                   ; 49 ED 5A
 adc.l hl, hl                   ; 49 ED 6A
 adc.l hl, sp                   ; 49 ED 7A
 add (hl)                       ; 86
 add (hl+)                      ; 86 23
 add (hl-)                      ; 86 2B
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
 add a, (hl+)                   ; 86 23
 add a, (hl-)                   ; 86 2B
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
 add.l (hl)                     ; 49 86
 add.l (hl+)                    ; 49 86 23
 add.l (hl-)                    ; 49 86 2B
 add.l (ix)                     ; 49 DD 86 00
 add.l (ix+127)                 ; 49 DD 86 7F
 add.l (ix-128)                 ; 49 DD 86 80
 add.l (iy)                     ; 49 FD 86 00
 add.l (iy+127)                 ; 49 FD 86 7F
 add.l (iy-128)                 ; 49 FD 86 80
 add.l a, (hl)                  ; 49 86
 add.l a, (hl+)                 ; 49 86 23
 add.l a, (hl-)                 ; 49 86 2B
 add.l a, (ix)                  ; 49 DD 86 00
 add.l a, (ix+127)              ; 49 DD 86 7F
 add.l a, (ix-128)              ; 49 DD 86 80
 add.l a, (iy)                  ; 49 FD 86 00
 add.l a, (iy+127)              ; 49 FD 86 7F
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
 and a, (hl+)                   ; A6 23
 and a, (hl-)                   ; A6 2B
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
 and.l (hl)                     ; 49 A6
 and.l (hl+)                    ; 49 A6 23
 and.l (hl-)                    ; 49 A6 2B
 and.l (ix)                     ; 49 DD A6 00
 and.l (ix+127)                 ; 49 DD A6 7F
 and.l (ix-128)                 ; 49 DD A6 80
 and.l (iy)                     ; 49 FD A6 00
 and.l (iy+127)                 ; 49 FD A6 7F
 and.l (iy-128)                 ; 49 FD A6 80
 and.l a, (hl)                  ; 49 A6
 and.l a, (hl+)                 ; 49 A6 23
 and.l a, (hl-)                 ; 49 A6 2B
 and.l a, (ix)                  ; 49 DD A6 00
 and.l a, (ix+127)              ; 49 DD A6 7F
 and.l a, (ix-128)              ; 49 DD A6 80
 and.l a, (iy)                  ; 49 FD A6 00
 and.l a, (iy+127)              ; 49 FD A6 7F
 and.l a, (iy-128)              ; 49 FD A6 80
 ani -128                       ; E6 80
 ani 127                        ; E6 7F
 ani 255                        ; E6 FF
 arhl                           ; CB 2C CB 1D
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
 bit 7, l                       ; CB 7D
 bit.l 0, (hl)                  ; 49 CB 46
 bit.l 0, (ix)                  ; 49 DD CB 00 46
 bit.l 0, (ix+127)              ; 49 DD CB 7F 46
 bit.l 0, (ix-128)              ; 49 DD CB 80 46
 bit.l 0, (iy)                  ; 49 FD CB 00 46
 bit.l 0, (iy+127)              ; 49 FD CB 7F 46
 bit.l 0, (iy-128)              ; 49 FD CB 80 46
 bit.l 1, (hl)                  ; 49 CB 4E
 bit.l 1, (ix)                  ; 49 DD CB 00 4E
 bit.l 1, (ix+127)              ; 49 DD CB 7F 4E
 bit.l 1, (ix-128)              ; 49 DD CB 80 4E
 bit.l 1, (iy)                  ; 49 FD CB 00 4E
 bit.l 1, (iy+127)              ; 49 FD CB 7F 4E
 bit.l 1, (iy-128)              ; 49 FD CB 80 4E
 bit.l 2, (hl)                  ; 49 CB 56
 bit.l 2, (ix)                  ; 49 DD CB 00 56
 bit.l 2, (ix+127)              ; 49 DD CB 7F 56
 bit.l 2, (ix-128)              ; 49 DD CB 80 56
 bit.l 2, (iy)                  ; 49 FD CB 00 56
 bit.l 2, (iy+127)              ; 49 FD CB 7F 56
 bit.l 2, (iy-128)              ; 49 FD CB 80 56
 bit.l 3, (hl)                  ; 49 CB 5E
 bit.l 3, (ix)                  ; 49 DD CB 00 5E
 bit.l 3, (ix+127)              ; 49 DD CB 7F 5E
 bit.l 3, (ix-128)              ; 49 DD CB 80 5E
 bit.l 3, (iy)                  ; 49 FD CB 00 5E
 bit.l 3, (iy+127)              ; 49 FD CB 7F 5E
 bit.l 3, (iy-128)              ; 49 FD CB 80 5E
 bit.l 4, (hl)                  ; 49 CB 66
 bit.l 4, (ix)                  ; 49 DD CB 00 66
 bit.l 4, (ix+127)              ; 49 DD CB 7F 66
 bit.l 4, (ix-128)              ; 49 DD CB 80 66
 bit.l 4, (iy)                  ; 49 FD CB 00 66
 bit.l 4, (iy+127)              ; 49 FD CB 7F 66
 bit.l 4, (iy-128)              ; 49 FD CB 80 66
 bit.l 5, (hl)                  ; 49 CB 6E
 bit.l 5, (ix)                  ; 49 DD CB 00 6E
 bit.l 5, (ix+127)              ; 49 DD CB 7F 6E
 bit.l 5, (ix-128)              ; 49 DD CB 80 6E
 bit.l 5, (iy)                  ; 49 FD CB 00 6E
 bit.l 5, (iy+127)              ; 49 FD CB 7F 6E
 bit.l 5, (iy-128)              ; 49 FD CB 80 6E
 bit.l 6, (hl)                  ; 49 CB 76
 bit.l 6, (ix)                  ; 49 DD CB 00 76
 bit.l 6, (ix+127)              ; 49 DD CB 7F 76
 bit.l 6, (ix-128)              ; 49 DD CB 80 76
 bit.l 6, (iy)                  ; 49 FD CB 00 76
 bit.l 6, (iy+127)              ; 49 FD CB 7F 76
 bit.l 6, (iy-128)              ; 49 FD CB 80 76
 bit.l 7, (hl)                  ; 49 CB 7E
 bit.l 7, (ix)                  ; 49 DD CB 00 7E
 bit.l 7, (ix+127)              ; 49 DD CB 7F 7E
 bit.l 7, (ix-128)              ; 49 DD CB 80 7E
 bit.l 7, (iy)                  ; 49 FD CB 00 7E
 bit.l 7, (iy+127)              ; 49 FD CB 7F 7E
 bit.l 7, (iy-128)              ; 49 FD CB 80 7E
 c_c -32768                     ; DC 00 80
 c_c 32767                      ; DC FF 7F
 c_c 65535                      ; DC FF FF
 c_m -32768                     ; FC 00 80
 c_m 32767                      ; FC FF 7F
 c_m 65535                      ; FC FF FF
 c_nc -32768                    ; D4 00 80
 c_nc 32767                     ; D4 FF 7F
 c_nc 65535                     ; D4 FF FF
 c_nv -32768                    ; E4 00 80
 c_nv 32767                     ; E4 FF 7F
 c_nv 65535                     ; E4 FF FF
 c_nz -32768                    ; C4 00 80
 c_nz 32767                     ; C4 FF 7F
 c_nz 65535                     ; C4 FF FF
 c_p -32768                     ; F4 00 80
 c_p 32767                      ; F4 FF 7F
 c_p 65535                      ; F4 FF FF
 c_pe -32768                    ; EC 00 80
 c_pe 32767                     ; EC FF 7F
 c_pe 65535                     ; EC FF FF
 c_po -32768                    ; E4 00 80
 c_po 32767                     ; E4 FF 7F
 c_po 65535                     ; E4 FF FF
 c_v -32768                     ; EC 00 80
 c_v 32767                      ; EC FF 7F
 c_v 65535                      ; EC FF FF
 c_z -32768                     ; CC 00 80
 c_z 32767                      ; CC FF 7F
 c_z 65535                      ; CC FF FF
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
 call.il 0x123456               ; 52 CD 56 34 12
 call.il c, 0x123456            ; 52 DC 56 34 12
 call.il m, 0x123456            ; 52 FC 56 34 12
 call.il nc, 0x123456           ; 52 D4 56 34 12
 call.il nv, 0x123456           ; 52 E4 56 34 12
 call.il nz, 0x123456           ; 52 C4 56 34 12
 call.il p, 0x123456            ; 52 F4 56 34 12
 call.il pe, 0x123456           ; 52 EC 56 34 12
 call.il po, 0x123456           ; 52 E4 56 34 12
 call.il v, 0x123456            ; 52 EC 56 34 12
 call.il z, 0x123456            ; 52 CC 56 34 12
 call.is -32768                 ; 40 CD 00 80
 call.is 32767                  ; 40 CD FF 7F
 call.is 65535                  ; 40 CD FF FF
 call.is c, -32768              ; 40 DC 00 80
 call.is c, 32767               ; 40 DC FF 7F
 call.is c, 65535               ; 40 DC FF FF
 call.is m, -32768              ; 40 FC 00 80
 call.is m, 32767               ; 40 FC FF 7F
 call.is m, 65535               ; 40 FC FF FF
 call.is nc, -32768             ; 40 D4 00 80
 call.is nc, 32767              ; 40 D4 FF 7F
 call.is nc, 65535              ; 40 D4 FF FF
 call.is nv, -32768             ; 40 E4 00 80
 call.is nv, 32767              ; 40 E4 FF 7F
 call.is nv, 65535              ; 40 E4 FF FF
 call.is nz, -32768             ; 40 C4 00 80
 call.is nz, 32767              ; 40 C4 FF 7F
 call.is nz, 65535              ; 40 C4 FF FF
 call.is p, -32768              ; 40 F4 00 80
 call.is p, 32767               ; 40 F4 FF 7F
 call.is p, 65535               ; 40 F4 FF FF
 call.is pe, -32768             ; 40 EC 00 80
 call.is pe, 32767              ; 40 EC FF 7F
 call.is pe, 65535              ; 40 EC FF FF
 call.is po, -32768             ; 40 E4 00 80
 call.is po, 32767              ; 40 E4 FF 7F
 call.is po, 65535              ; 40 E4 FF FF
 call.is v, -32768              ; 40 EC 00 80
 call.is v, 32767               ; 40 EC FF 7F
 call.is v, 65535               ; 40 EC FF FF
 call.is z, -32768              ; 40 CC 00 80
 call.is z, 32767               ; 40 CC FF 7F
 call.is z, 65535               ; 40 CC FF FF
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
 cmp (hl+)                      ; BE 23
 cmp (hl-)                      ; BE 2B
 cmp (ix)                       ; DD BE 00
 cmp (ix+127)                   ; DD BE 7F
 cmp (ix-128)                   ; DD BE 80
 cmp (iy)                       ; FD BE 00
 cmp (iy+127)                   ; FD BE 7F
 cmp (iy-128)                   ; FD BE 80
 cmp -128                       ; FE 80
 cmp 127                        ; FE 7F
 cmp 255                        ; FE FF
 cmp a                          ; BF
 cmp a, (hl)                    ; BE
 cmp a, (hl+)                   ; BE 23
 cmp a, (hl-)                   ; BE 2B
 cmp a, (ix)                    ; DD BE 00
 cmp a, (ix+127)                ; DD BE 7F
 cmp a, (ix-128)                ; DD BE 80
 cmp a, (iy)                    ; FD BE 00
 cmp a, (iy+127)                ; FD BE 7F
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
 cmp.l (hl)                     ; 49 BE
 cmp.l (hl+)                    ; 49 BE 23
 cmp.l (hl-)                    ; 49 BE 2B
 cmp.l (ix)                     ; 49 DD BE 00
 cmp.l (ix+127)                 ; 49 DD BE 7F
 cmp.l (ix-128)                 ; 49 DD BE 80
 cmp.l (iy)                     ; 49 FD BE 00
 cmp.l (iy+127)                 ; 49 FD BE 7F
 cmp.l (iy-128)                 ; 49 FD BE 80
 cmp.l a, (hl)                  ; 49 BE
 cmp.l a, (hl+)                 ; 49 BE 23
 cmp.l a, (hl-)                 ; 49 BE 2B
 cmp.l a, (ix)                  ; 49 DD BE 00
 cmp.l a, (ix+127)              ; 49 DD BE 7F
 cmp.l a, (ix-128)              ; 49 DD BE 80
 cmp.l a, (iy)                  ; 49 FD BE 00
 cmp.l a, (iy+127)              ; 49 FD BE 7F
 cmp.l a, (iy-128)              ; 49 FD BE 80
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
 cp (hl+)                       ; BE 23
 cp (hl-)                       ; BE 2B
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
 cp a, (hl+)                    ; BE 23
 cp a, (hl-)                    ; BE 2B
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
 cp.l (hl)                      ; 49 BE
 cp.l (hl+)                     ; 49 BE 23
 cp.l (hl-)                     ; 49 BE 2B
 cp.l (ix)                      ; 49 DD BE 00
 cp.l (ix+127)                  ; 49 DD BE 7F
 cp.l (ix-128)                  ; 49 DD BE 80
 cp.l (iy)                      ; 49 FD BE 00
 cp.l (iy+127)                  ; 49 FD BE 7F
 cp.l (iy-128)                  ; 49 FD BE 80
 cp.l a, (hl)                   ; 49 BE
 cp.l a, (hl+)                  ; 49 BE 23
 cp.l a, (hl-)                  ; 49 BE 2B
 cp.l a, (ix)                   ; 49 DD BE 00
 cp.l a, (ix+127)               ; 49 DD BE 7F
 cp.l a, (ix-128)               ; 49 DD BE 80
 cp.l a, (iy)                   ; 49 FD BE 00
 cp.l a, (iy+127)               ; 49 FD BE 7F
 cp.l a, (iy-128)               ; 49 FD BE 80
 cpd                            ; ED A9
 cpd.l                          ; 49 ED A9
 cpdr                           ; ED B9
 cpdr.l                         ; 49 ED B9
 cpe -32768                     ; EC 00 80
 cpe 32767                      ; EC FF 7F
 cpe 65535                      ; EC FF FF
 cpi                            ; ED A1
 cpi -128                       ; FE 80
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpi.l                          ; 49 ED A1
 cpir                           ; ED B1
 cpir.l                         ; 49 ED B1
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
 dec (hl+)                      ; 35 23
 dec (hl-)                      ; 35 2B
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
 dec.l (hl)                     ; 49 35
 dec.l (hl+)                    ; 49 35 23
 dec.l (hl-)                    ; 49 35 2B
 dec.l (ix)                     ; 49 DD 35 00
 dec.l (ix+127)                 ; 49 DD 35 7F
 dec.l (ix-128)                 ; 49 DD 35 80
 dec.l (iy)                     ; 49 FD 35 00
 dec.l (iy+127)                 ; 49 FD 35 7F
 dec.l (iy-128)                 ; 49 FD 35 80
 dec.l bc                       ; 49 0B
 dec.l de                       ; 49 1B
 dec.l hl                       ; 49 2B
 dec.l ix                       ; 49 DD 2B
 dec.l iy                       ; 49 FD 2B
 dec.l sp                       ; 49 3B
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
 ex.l (sp), hl                  ; 49 E3
 ex.l (sp), ix                  ; 49 DD E3
 ex.l (sp), iy                  ; 49 FD E3
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
 in f, (bc)                     ; ED 70
 in f, (c)                      ; ED 70
 in h, (bc)                     ; ED 60
 in h, (c)                      ; ED 60
 in l, (bc)                     ; ED 68
 in l, (c)                      ; ED 68
 in0 (-128)                     ; ED 30 80
 in0 (127)                      ; ED 30 7F
 in0 (255)                      ; ED 30 FF
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
 in0 f, (-128)                  ; ED 30 80
 in0 f, (127)                   ; ED 30 7F
 in0 f, (255)                   ; ED 30 FF
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
 inc.l (hl)                     ; 49 34
 inc.l (hl+)                    ; 49 34 23
 inc.l (hl-)                    ; 49 34 2B
 inc.l (ix)                     ; 49 DD 34 00
 inc.l (ix+127)                 ; 49 DD 34 7F
 inc.l (ix-128)                 ; 49 DD 34 80
 inc.l (iy)                     ; 49 FD 34 00
 inc.l (iy+127)                 ; 49 FD 34 7F
 inc.l (iy-128)                 ; 49 FD 34 80
 inc.l bc                       ; 49 03
 inc.l de                       ; 49 13
 inc.l hl                       ; 49 23
 inc.l ix                       ; 49 DD 23
 inc.l iy                       ; 49 FD 23
 inc.l sp                       ; 49 33
 ind                            ; ED AA
 ind.l                          ; 49 ED AA
 ind2                           ; ED 8C
 ind2.l                         ; 49 ED 8C
 ind2r                          ; ED 9C
 ind2r.l                        ; 49 ED 9C
 indm                           ; ED 8A
 indm.l                         ; 49 ED 8A
 indmr                          ; ED 9A
 indmr.l                        ; 49 ED 9A
 indr                           ; ED BA
 indr.l                         ; 49 ED BA
 indrx                          ; ED CA
 indrx.l                        ; 49 ED CA
 ini                            ; ED A2
 ini.l                          ; 49 ED A2
 ini2                           ; ED 84
 ini2.l                         ; 49 ED 84
 ini2r                          ; ED 94
 ini2r.l                        ; 49 ED 94
 inim                           ; ED 82
 inim.l                         ; 49 ED 82
 inimr                          ; ED 92
 inimr.l                        ; 49 ED 92
 inir                           ; ED B2
 inir.l                         ; 49 ED B2
 inirx                          ; ED C2
 inirx.l                        ; 49 ED C2
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
 j_c 32767                      ; DA FF 7F
 j_c 65535                      ; DA FF FF
 j_m -32768                     ; FA 00 80
 j_m 32767                      ; FA FF 7F
 j_m 65535                      ; FA FF FF
 j_nc -32768                    ; D2 00 80
 j_nc 32767                     ; D2 FF 7F
 j_nc 65535                     ; D2 FF FF
 j_nv -32768                    ; E2 00 80
 j_nv 32767                     ; E2 FF 7F
 j_nv 65535                     ; E2 FF FF
 j_nz -32768                    ; C2 00 80
 j_nz 32767                     ; C2 FF 7F
 j_nz 65535                     ; C2 FF FF
 j_p -32768                     ; F2 00 80
 j_p 32767                      ; F2 FF 7F
 j_p 65535                      ; F2 FF FF
 j_pe -32768                    ; EA 00 80
 j_pe 32767                     ; EA FF 7F
 j_pe 65535                     ; EA FF FF
 j_po -32768                    ; E2 00 80
 j_po 32767                     ; E2 FF 7F
 j_po 65535                     ; E2 FF FF
 j_v -32768                     ; EA 00 80
 j_v 32767                      ; EA FF 7F
 j_v 65535                      ; EA FF FF
 j_z -32768                     ; CA 00 80
 j_z 32767                      ; CA FF 7F
 j_z 65535                      ; CA FF FF
 jc -32768                      ; DA 00 80
 jc 32767                       ; DA FF 7F
 jc 65535                       ; DA FF FF
 jm -32768                      ; FA 00 80
 jm 32767                       ; FA FF 7F
 jm 65535                       ; FA FF FF
 jmp (bc)                       ; C5 C9
 jmp (de)                       ; D5 C9
 jmp (hl)                       ; E9
 jmp (ix)                       ; DD E9
 jmp (iy)                       ; FD E9
 jmp -32768                     ; C3 00 80
 jmp 32767                      ; C3 FF 7F
 jmp 65535                      ; C3 FF FF
 jmp c, -32768                  ; DA 00 80
 jmp c, 32767                   ; DA FF 7F
 jmp c, 65535                   ; DA FF FF
 jmp m, -32768                  ; FA 00 80
 jmp m, 32767                   ; FA FF 7F
 jmp m, 65535                   ; FA FF FF
 jmp nc, -32768                 ; D2 00 80
 jmp nc, 32767                  ; D2 FF 7F
 jmp nc, 65535                  ; D2 FF FF
 jmp nv, -32768                 ; E2 00 80
 jmp nv, 32767                  ; E2 FF 7F
 jmp nv, 65535                  ; E2 FF FF
 jmp nz, -32768                 ; C2 00 80
 jmp nz, 32767                  ; C2 FF 7F
 jmp nz, 65535                  ; C2 FF FF
 jmp p, -32768                  ; F2 00 80
 jmp p, 32767                   ; F2 FF 7F
 jmp p, 65535                   ; F2 FF FF
 jmp pe, -32768                 ; EA 00 80
 jmp pe, 32767                  ; EA FF 7F
 jmp pe, 65535                  ; EA FF FF
 jmp po, -32768                 ; E2 00 80
 jmp po, 32767                  ; E2 FF 7F
 jmp po, 65535                  ; E2 FF FF
 jmp v, -32768                  ; EA 00 80
 jmp v, 32767                   ; EA FF 7F
 jmp v, 65535                   ; EA FF FF
 jmp z, -32768                  ; CA 00 80
 jmp z, 32767                   ; CA FF 7F
 jmp z, 65535                   ; CA FF FF
 jmp.l (hl)                     ; 49 E9
 jmp.l (ix)                     ; 49 DD E9
 jmp.l (iy)                     ; 49 FD E9
 jmp.lil 0x123456               ; 5B C3 56 34 12
 jmp.lil c, 0x123456            ; 5B DA 56 34 12
 jmp.lil m, 0x123456            ; 5B FA 56 34 12
 jmp.lil nc, 0x123456           ; 5B D2 56 34 12
 jmp.lil nv, 0x123456           ; 5B E2 56 34 12
 jmp.lil nz, 0x123456           ; 5B C2 56 34 12
 jmp.lil p, 0x123456            ; 5B F2 56 34 12
 jmp.lil pe, 0x123456           ; 5B EA 56 34 12
 jmp.lil po, 0x123456           ; 5B E2 56 34 12
 jmp.lil v, 0x123456            ; 5B EA 56 34 12
 jmp.lil z, 0x123456            ; 5B CA 56 34 12
 jmp.sis -32768                 ; 40 C3 00 80
 jmp.sis 32767                  ; 40 C3 FF 7F
 jmp.sis 65535                  ; 40 C3 FF FF
 jmp.sis c, -32768              ; 40 DA 00 80
 jmp.sis c, 32767               ; 40 DA FF 7F
 jmp.sis c, 65535               ; 40 DA FF FF
 jmp.sis m, -32768              ; 40 FA 00 80
 jmp.sis m, 32767               ; 40 FA FF 7F
 jmp.sis m, 65535               ; 40 FA FF FF
 jmp.sis nc, -32768             ; 40 D2 00 80
 jmp.sis nc, 32767              ; 40 D2 FF 7F
 jmp.sis nc, 65535              ; 40 D2 FF FF
 jmp.sis nv, -32768             ; 40 E2 00 80
 jmp.sis nv, 32767              ; 40 E2 FF 7F
 jmp.sis nv, 65535              ; 40 E2 FF FF
 jmp.sis nz, -32768             ; 40 C2 00 80
 jmp.sis nz, 32767              ; 40 C2 FF 7F
 jmp.sis nz, 65535              ; 40 C2 FF FF
 jmp.sis p, -32768              ; 40 F2 00 80
 jmp.sis p, 32767               ; 40 F2 FF 7F
 jmp.sis p, 65535               ; 40 F2 FF FF
 jmp.sis pe, -32768             ; 40 EA 00 80
 jmp.sis pe, 32767              ; 40 EA FF 7F
 jmp.sis pe, 65535              ; 40 EA FF FF
 jmp.sis po, -32768             ; 40 E2 00 80
 jmp.sis po, 32767              ; 40 E2 FF 7F
 jmp.sis po, 65535              ; 40 E2 FF FF
 jmp.sis v, -32768              ; 40 EA 00 80
 jmp.sis v, 32767               ; 40 EA FF 7F
 jmp.sis v, 65535               ; 40 EA FF FF
 jmp.sis z, -32768              ; 40 CA 00 80
 jmp.sis z, 32767               ; 40 CA FF 7F
 jmp.sis z, 65535               ; 40 CA FF FF
 jnc -32768                     ; D2 00 80
 jnc 32767                      ; D2 FF 7F
 jnc 65535                      ; D2 FF FF
 jnv -32768                     ; E2 00 80
 jnv 32767                      ; E2 FF 7F
 jnv 65535                      ; E2 FF FF
 jnz -32768                     ; C2 00 80
 jnz 32767                      ; C2 FF 7F
 jnz 65535                      ; C2 FF FF
 jp (bc)                        ; C5 C9
 jp (de)                        ; D5 C9
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
 jp.l (hl)                      ; 49 E9
 jp.l (ix)                      ; 49 DD E9
 jp.l (iy)                      ; 49 FD E9
 jp.lil 0x123456                ; 5B C3 56 34 12
 jp.lil c, 0x123456             ; 5B DA 56 34 12
 jp.lil m, 0x123456             ; 5B FA 56 34 12
 jp.lil nc, 0x123456            ; 5B D2 56 34 12
 jp.lil nv, 0x123456            ; 5B E2 56 34 12
 jp.lil nz, 0x123456            ; 5B C2 56 34 12
 jp.lil p, 0x123456             ; 5B F2 56 34 12
 jp.lil pe, 0x123456            ; 5B EA 56 34 12
 jp.lil po, 0x123456            ; 5B E2 56 34 12
 jp.lil v, 0x123456             ; 5B EA 56 34 12
 jp.lil z, 0x123456             ; 5B CA 56 34 12
 jp.sis -32768                  ; 40 C3 00 80
 jp.sis 32767                   ; 40 C3 FF 7F
 jp.sis 65535                   ; 40 C3 FF FF
 jp.sis c, -32768               ; 40 DA 00 80
 jp.sis c, 32767                ; 40 DA FF 7F
 jp.sis c, 65535                ; 40 DA FF FF
 jp.sis m, -32768               ; 40 FA 00 80
 jp.sis m, 32767                ; 40 FA FF 7F
 jp.sis m, 65535                ; 40 FA FF FF
 jp.sis nc, -32768              ; 40 D2 00 80
 jp.sis nc, 32767               ; 40 D2 FF 7F
 jp.sis nc, 65535               ; 40 D2 FF FF
 jp.sis nv, -32768              ; 40 E2 00 80
 jp.sis nv, 32767               ; 40 E2 FF 7F
 jp.sis nv, 65535               ; 40 E2 FF FF
 jp.sis nz, -32768              ; 40 C2 00 80
 jp.sis nz, 32767               ; 40 C2 FF 7F
 jp.sis nz, 65535               ; 40 C2 FF FF
 jp.sis p, -32768               ; 40 F2 00 80
 jp.sis p, 32767                ; 40 F2 FF 7F
 jp.sis p, 65535                ; 40 F2 FF FF
 jp.sis pe, -32768              ; 40 EA 00 80
 jp.sis pe, 32767               ; 40 EA FF 7F
 jp.sis pe, 65535               ; 40 EA FF FF
 jp.sis po, -32768              ; 40 E2 00 80
 jp.sis po, 32767               ; 40 E2 FF 7F
 jp.sis po, 65535               ; 40 E2 FF FF
 jp.sis v, -32768               ; 40 EA 00 80
 jp.sis v, 32767                ; 40 EA FF 7F
 jp.sis v, 65535                ; 40 EA FF FF
 jp.sis z, -32768               ; 40 CA 00 80
 jp.sis z, 32767                ; 40 CA FF 7F
 jp.sis z, 65535                ; 40 CA FF FF
 jpe -32768                     ; EA 00 80
 jpe 32767                      ; EA FF 7F
 jpe 65535                      ; EA FF FF
 jpo -32768                     ; E2 00 80
 jpo 32767                      ; E2 FF 7F
 jpo 65535                      ; E2 FF FF
 jr ASMPC                       ; 18 FE
 jr c, ASMPC                    ; 38 FE
 jr nc, ASMPC                   ; 30 FE
 jr nz, ASMPC                   ; 20 FE
 jr z, ASMPC                    ; 28 FE
 jv -32768                      ; EA 00 80
 jv 32767                       ; EA FF 7F
 jv 65535                       ; EA FF FF
 jz -32768                      ; CA 00 80
 jz 32767                       ; CA FF 7F
 jz 65535                       ; CA FF FF
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
 ld (ix+127), -128              ; DD 36 7F 80
 ld (ix+127), 127               ; DD 36 7F 7F
 ld (ix+127), 255               ; DD 36 7F FF
 ld (ix+127), a                 ; DD 77 7F
 ld (ix+127), b                 ; DD 70 7F
 ld (ix+127), bc                ; DD 0F 7F
 ld (ix+127), c                 ; DD 71 7F
 ld (ix+127), d                 ; DD 72 7F
 ld (ix+127), de                ; DD 1F 7F
 ld (ix+127), e                 ; DD 73 7F
 ld (ix+127), h                 ; DD 74 7F
 ld (ix+127), hl                ; DD 2F 7F
 ld (ix+127), ix                ; DD 3F 7F
 ld (ix+127), iy                ; DD 3E 7F
 ld (ix+127), l                 ; DD 75 7F
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
 ld (iy+127), -128              ; FD 36 7F 80
 ld (iy+127), 127               ; FD 36 7F 7F
 ld (iy+127), 255               ; FD 36 7F FF
 ld (iy+127), a                 ; FD 77 7F
 ld (iy+127), b                 ; FD 70 7F
 ld (iy+127), bc                ; FD 0F 7F
 ld (iy+127), c                 ; FD 71 7F
 ld (iy+127), d                 ; FD 72 7F
 ld (iy+127), de                ; FD 1F 7F
 ld (iy+127), e                 ; FD 73 7F
 ld (iy+127), h                 ; FD 74 7F
 ld (iy+127), hl                ; FD 2F 7F
 ld (iy+127), ix                ; FD 3E 7F
 ld (iy+127), iy                ; FD 3F 7F
 ld (iy+127), l                 ; FD 75 7F
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
 ld b, (ix+127)                 ; DD 46 7F
 ld b, (ix-128)                 ; DD 46 80
 ld b, (iy)                     ; FD 46 00
 ld b, (iy+127)                 ; FD 46 7F
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
 ld bc, (-32768)                ; ED 4B 00 80
 ld bc, (32767)                 ; ED 4B FF 7F
 ld bc, (65535)                 ; ED 4B FF FF
 ld bc, (hl)                    ; ED 07
 ld bc, (hl+)                   ; ED 07 23 23
 ld bc, (ix)                    ; DD 07 00
 ld bc, (ix+127)                ; DD 07 7F
 ld bc, (ix-128)                ; DD 07 80
 ld bc, (iy)                    ; FD 07 00
 ld bc, (iy+127)                ; FD 07 7F
 ld bc, (iy-128)                ; FD 07 80
 ld bc, -32768                  ; 01 00 80
 ld bc, 32767                   ; 01 FF 7F
 ld bc, 65535                   ; 01 FF FF
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
 ld de, (hl)                    ; ED 17
 ld de, (hl+)                   ; ED 17 23 23
 ld de, (ix)                    ; DD 17 00
 ld de, (ix+127)                ; DD 17 7F
 ld de, (ix-128)                ; DD 17 80
 ld de, (iy)                    ; FD 17 00
 ld de, (iy+127)                ; FD 17 7F
 ld de, (iy-128)                ; FD 17 80
 ld de, -32768                  ; 11 00 80
 ld de, 32767                   ; 11 FF 7F
 ld de, 65535                   ; 11 FF FF
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
 ld hl, (hl)                    ; ED 27
 ld hl, (hl+)                   ; ED 27 23 23
 ld hl, (ix)                    ; DD 27 00
 ld hl, (ix+127)                ; DD 27 7F
 ld hl, (ix-128)                ; DD 27 80
 ld hl, (iy)                    ; FD 27 00
 ld hl, (iy+127)                ; FD 27 7F
 ld hl, (iy-128)                ; FD 27 80
 ld hl, -32768                  ; 21 00 80
 ld hl, 32767                   ; 21 FF 7F
 ld hl, 65535                   ; 21 FF FF
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
 ld ix, (-32768)                ; DD 2A 00 80
 ld ix, (32767)                 ; DD 2A FF 7F
 ld ix, (65535)                 ; DD 2A FF FF
 ld ix, (hl)                    ; ED 37
 ld ix, (hl+)                   ; ED 37 23 23
 ld ix, (ix)                    ; DD 37 00
 ld ix, (ix+127)                ; DD 37 7F
 ld ix, (ix-128)                ; DD 37 80
 ld ix, (iy)                    ; FD 31 00
 ld ix, (iy+127)                ; FD 31 7F
 ld ix, (iy-128)                ; FD 31 80
 ld ix, -32768                  ; DD 21 00 80
 ld ix, 32767                   ; DD 21 FF 7F
 ld ix, 65535                   ; DD 21 FF FF
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
 ld iy, (-32768)                ; FD 2A 00 80
 ld iy, (32767)                 ; FD 2A FF 7F
 ld iy, (65535)                 ; FD 2A FF FF
 ld iy, (hl)                    ; ED 31
 ld iy, (hl+)                   ; ED 31 23 23
 ld iy, (ix)                    ; DD 31 00
 ld iy, (ix+127)                ; DD 31 7F
 ld iy, (ix-128)                ; DD 31 80
 ld iy, (iy)                    ; FD 37 00
 ld iy, (iy+127)                ; FD 37 7F
 ld iy, (iy-128)                ; FD 37 80
 ld iy, -32768                  ; FD 21 00 80
 ld iy, 32767                   ; FD 21 FF 7F
 ld iy, 65535                   ; FD 21 FF FF
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
 ld mb, a                       ; ED 6D
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
 ld.il (0x123456), a            ; 5B 32 56 34 12
 ld.il a, (0x123456)            ; 5B 3A 56 34 12
 ld.is (-32768), a              ; 40 32 00 80
 ld.is (32767), a               ; 40 32 FF 7F
 ld.is (65535), a               ; 40 32 FF FF
 ld.is a, (-32768)              ; 40 3A 00 80
 ld.is a, (32767)               ; 40 3A FF 7F
 ld.is a, (65535)               ; 40 3A FF FF
 ld.l (bc), a                   ; 49 02
 ld.l (bc+), a                  ; 49 02 03
 ld.l (bc-), a                  ; 49 02 0B
 ld.l (de), a                   ; 49 12
 ld.l (de+), a                  ; 49 12 13
 ld.l (de-), a                  ; 49 12 1B
 ld.l (hl), -128                ; 49 36 80
 ld.l (hl), 127                 ; 49 36 7F
 ld.l (hl), 255                 ; 49 36 FF
 ld.l (hl), a                   ; 49 77
 ld.l (hl), b                   ; 49 70
 ld.l (hl), bc                  ; 49 ED 0F
 ld.l (hl), c                   ; 49 71
 ld.l (hl), d                   ; 49 72
 ld.l (hl), de                  ; 49 ED 1F
 ld.l (hl), e                   ; 49 73
 ld.l (hl), h                   ; 49 74
 ld.l (hl), hl                  ; 49 ED 2F
 ld.l (hl), ix                  ; 49 ED 3F
 ld.l (hl), iy                  ; 49 ED 3E
 ld.l (hl), l                   ; 49 75
 ld.l (hl+), -128               ; 49 36 80 23
 ld.l (hl+), 127                ; 49 36 7F 23
 ld.l (hl+), 255                ; 49 36 FF 23
 ld.l (hl+), a                  ; 49 77 23
 ld.l (hl+), b                  ; 49 70 23
 ld.l (hl+), bc                 ; 49 ED 0F 23 23
 ld.l (hl+), c                  ; 49 71 23
 ld.l (hl+), d                  ; 49 72 23
 ld.l (hl+), de                 ; 49 ED 1F 23 23
 ld.l (hl+), e                  ; 49 73 23
 ld.l (hl+), h                  ; 49 74 23
 ld.l (hl+), hl                 ; 49 ED 2F 23 23
 ld.l (hl+), ix                 ; 49 ED 3F 23 23
 ld.l (hl+), iy                 ; 49 ED 3E 23 23
 ld.l (hl+), l                  ; 49 75 23
 ld.l (hl-), -128               ; 49 36 80 2B
 ld.l (hl-), 127                ; 49 36 7F 2B
 ld.l (hl-), 255                ; 49 36 FF 2B
 ld.l (hl-), a                  ; 49 77 2B
 ld.l (hl-), b                  ; 49 70 2B
 ld.l (hl-), c                  ; 49 71 2B
 ld.l (hl-), d                  ; 49 72 2B
 ld.l (hl-), e                  ; 49 73 2B
 ld.l (hl-), h                  ; 49 74 2B
 ld.l (hl-), l                  ; 49 75 2B
 ld.l (hld), a                  ; 49 77 2B
 ld.l (hld), b                  ; 49 70 2B
 ld.l (hld), c                  ; 49 71 2B
 ld.l (hld), d                  ; 49 72 2B
 ld.l (hld), e                  ; 49 73 2B
 ld.l (hld), h                  ; 49 74 2B
 ld.l (hld), l                  ; 49 75 2B
 ld.l (hli), a                  ; 49 77 23
 ld.l (hli), b                  ; 49 70 23
 ld.l (hli), c                  ; 49 71 23
 ld.l (hli), d                  ; 49 72 23
 ld.l (hli), e                  ; 49 73 23
 ld.l (hli), h                  ; 49 74 23
 ld.l (hli), l                  ; 49 75 23
 ld.l (ix), -128                ; 49 DD 36 00 80
 ld.l (ix), 127                 ; 49 DD 36 00 7F
 ld.l (ix), 255                 ; 49 DD 36 00 FF
 ld.l (ix), a                   ; 49 DD 77 00
 ld.l (ix), b                   ; 49 DD 70 00
 ld.l (ix), bc                  ; 49 DD 0F 00
 ld.l (ix), c                   ; 49 DD 71 00
 ld.l (ix), d                   ; 49 DD 72 00
 ld.l (ix), de                  ; 49 DD 1F 00
 ld.l (ix), e                   ; 49 DD 73 00
 ld.l (ix), h                   ; 49 DD 74 00
 ld.l (ix), hl                  ; 49 DD 2F 00
 ld.l (ix), ix                  ; 49 DD 3F 00
 ld.l (ix), iy                  ; 49 DD 3E 00
 ld.l (ix), l                   ; 49 DD 75 00
 ld.l (ix+127), -128            ; 49 DD 36 7F 80
 ld.l (ix+127), 127             ; 49 DD 36 7F 7F
 ld.l (ix+127), 255             ; 49 DD 36 7F FF
 ld.l (ix+127), a               ; 49 DD 77 7F
 ld.l (ix+127), b               ; 49 DD 70 7F
 ld.l (ix+127), bc              ; 49 DD 0F 7F
 ld.l (ix+127), c               ; 49 DD 71 7F
 ld.l (ix+127), d               ; 49 DD 72 7F
 ld.l (ix+127), de              ; 49 DD 1F 7F
 ld.l (ix+127), e               ; 49 DD 73 7F
 ld.l (ix+127), h               ; 49 DD 74 7F
 ld.l (ix+127), hl              ; 49 DD 2F 7F
 ld.l (ix+127), ix              ; 49 DD 3F 7F
 ld.l (ix+127), iy              ; 49 DD 3E 7F
 ld.l (ix+127), l               ; 49 DD 75 7F
 ld.l (ix-128), -128            ; 49 DD 36 80 80
 ld.l (ix-128), 127             ; 49 DD 36 80 7F
 ld.l (ix-128), 255             ; 49 DD 36 80 FF
 ld.l (ix-128), a               ; 49 DD 77 80
 ld.l (ix-128), b               ; 49 DD 70 80
 ld.l (ix-128), bc              ; 49 DD 0F 80
 ld.l (ix-128), c               ; 49 DD 71 80
 ld.l (ix-128), d               ; 49 DD 72 80
 ld.l (ix-128), de              ; 49 DD 1F 80
 ld.l (ix-128), e               ; 49 DD 73 80
 ld.l (ix-128), h               ; 49 DD 74 80
 ld.l (ix-128), hl              ; 49 DD 2F 80
 ld.l (ix-128), ix              ; 49 DD 3F 80
 ld.l (ix-128), iy              ; 49 DD 3E 80
 ld.l (ix-128), l               ; 49 DD 75 80
 ld.l (iy), -128                ; 49 FD 36 00 80
 ld.l (iy), 127                 ; 49 FD 36 00 7F
 ld.l (iy), 255                 ; 49 FD 36 00 FF
 ld.l (iy), a                   ; 49 FD 77 00
 ld.l (iy), b                   ; 49 FD 70 00
 ld.l (iy), bc                  ; 49 FD 0F 00
 ld.l (iy), c                   ; 49 FD 71 00
 ld.l (iy), d                   ; 49 FD 72 00
 ld.l (iy), de                  ; 49 FD 1F 00
 ld.l (iy), e                   ; 49 FD 73 00
 ld.l (iy), h                   ; 49 FD 74 00
 ld.l (iy), hl                  ; 49 FD 2F 00
 ld.l (iy), ix                  ; 49 FD 3E 00
 ld.l (iy), iy                  ; 49 FD 3F 00
 ld.l (iy), l                   ; 49 FD 75 00
 ld.l (iy+127), -128            ; 49 FD 36 7F 80
 ld.l (iy+127), 127             ; 49 FD 36 7F 7F
 ld.l (iy+127), 255             ; 49 FD 36 7F FF
 ld.l (iy+127), a               ; 49 FD 77 7F
 ld.l (iy+127), b               ; 49 FD 70 7F
 ld.l (iy+127), bc              ; 49 FD 0F 7F
 ld.l (iy+127), c               ; 49 FD 71 7F
 ld.l (iy+127), d               ; 49 FD 72 7F
 ld.l (iy+127), de              ; 49 FD 1F 7F
 ld.l (iy+127), e               ; 49 FD 73 7F
 ld.l (iy+127), h               ; 49 FD 74 7F
 ld.l (iy+127), hl              ; 49 FD 2F 7F
 ld.l (iy+127), ix              ; 49 FD 3E 7F
 ld.l (iy+127), iy              ; 49 FD 3F 7F
 ld.l (iy+127), l               ; 49 FD 75 7F
 ld.l (iy-128), -128            ; 49 FD 36 80 80
 ld.l (iy-128), 127             ; 49 FD 36 80 7F
 ld.l (iy-128), 255             ; 49 FD 36 80 FF
 ld.l (iy-128), a               ; 49 FD 77 80
 ld.l (iy-128), b               ; 49 FD 70 80
 ld.l (iy-128), bc              ; 49 FD 0F 80
 ld.l (iy-128), c               ; 49 FD 71 80
 ld.l (iy-128), d               ; 49 FD 72 80
 ld.l (iy-128), de              ; 49 FD 1F 80
 ld.l (iy-128), e               ; 49 FD 73 80
 ld.l (iy-128), h               ; 49 FD 74 80
 ld.l (iy-128), hl              ; 49 FD 2F 80
 ld.l (iy-128), ix              ; 49 FD 3E 80
 ld.l (iy-128), iy              ; 49 FD 3F 80
 ld.l (iy-128), l               ; 49 FD 75 80
 ld.l a, (bc)                   ; 49 0A
 ld.l a, (bc+)                  ; 49 0A 03
 ld.l a, (bc-)                  ; 49 0A 0B
 ld.l a, (de)                   ; 49 1A
 ld.l a, (de+)                  ; 49 1A 13
 ld.l a, (de-)                  ; 49 1A 1B
 ld.l a, (hl)                   ; 49 7E
 ld.l a, (hl+)                  ; 49 7E 23
 ld.l a, (hl-)                  ; 49 7E 2B
 ld.l a, (hld)                  ; 49 7E 2B
 ld.l a, (hli)                  ; 49 7E 23
 ld.l a, (ix)                   ; 49 DD 7E 00
 ld.l a, (ix+127)               ; 49 DD 7E 7F
 ld.l a, (ix-128)               ; 49 DD 7E 80
 ld.l a, (iy)                   ; 49 FD 7E 00
 ld.l a, (iy+127)               ; 49 FD 7E 7F
 ld.l a, (iy-128)               ; 49 FD 7E 80
 ld.l b, (hl)                   ; 49 46
 ld.l b, (hl+)                  ; 49 46 23
 ld.l b, (hl-)                  ; 49 46 2B
 ld.l b, (hld)                  ; 49 46 2B
 ld.l b, (hli)                  ; 49 46 23
 ld.l b, (ix)                   ; 49 DD 46 00
 ld.l b, (ix+127)               ; 49 DD 46 7F
 ld.l b, (ix-128)               ; 49 DD 46 80
 ld.l b, (iy)                   ; 49 FD 46 00
 ld.l b, (iy+127)               ; 49 FD 46 7F
 ld.l b, (iy-128)               ; 49 FD 46 80
 ld.l bc, (hl)                  ; 49 ED 07
 ld.l bc, (hl+)                 ; 49 ED 07 23 23
 ld.l bc, (ix)                  ; 49 DD 07 00
 ld.l bc, (ix+127)              ; 49 DD 07 7F
 ld.l bc, (ix-128)              ; 49 DD 07 80
 ld.l bc, (iy)                  ; 49 FD 07 00
 ld.l bc, (iy+127)              ; 49 FD 07 7F
 ld.l bc, (iy-128)              ; 49 FD 07 80
 ld.l c, (hl)                   ; 49 4E
 ld.l c, (hl+)                  ; 49 4E 23
 ld.l c, (hl-)                  ; 49 4E 2B
 ld.l c, (hld)                  ; 49 4E 2B
 ld.l c, (hli)                  ; 49 4E 23
 ld.l c, (ix)                   ; 49 DD 4E 00
 ld.l c, (ix+127)               ; 49 DD 4E 7F
 ld.l c, (ix-128)               ; 49 DD 4E 80
 ld.l c, (iy)                   ; 49 FD 4E 00
 ld.l c, (iy+127)               ; 49 FD 4E 7F
 ld.l c, (iy-128)               ; 49 FD 4E 80
 ld.l d, (hl)                   ; 49 56
 ld.l d, (hl+)                  ; 49 56 23
 ld.l d, (hl-)                  ; 49 56 2B
 ld.l d, (hld)                  ; 49 56 2B
 ld.l d, (hli)                  ; 49 56 23
 ld.l d, (ix)                   ; 49 DD 56 00
 ld.l d, (ix+127)               ; 49 DD 56 7F
 ld.l d, (ix-128)               ; 49 DD 56 80
 ld.l d, (iy)                   ; 49 FD 56 00
 ld.l d, (iy+127)               ; 49 FD 56 7F
 ld.l d, (iy-128)               ; 49 FD 56 80
 ld.l de, (hl)                  ; 49 ED 17
 ld.l de, (hl+)                 ; 49 ED 17 23 23
 ld.l de, (ix)                  ; 49 DD 17 00
 ld.l de, (ix+127)              ; 49 DD 17 7F
 ld.l de, (ix-128)              ; 49 DD 17 80
 ld.l de, (iy)                  ; 49 FD 17 00
 ld.l de, (iy+127)              ; 49 FD 17 7F
 ld.l de, (iy-128)              ; 49 FD 17 80
 ld.l e, (hl)                   ; 49 5E
 ld.l e, (hl+)                  ; 49 5E 23
 ld.l e, (hl-)                  ; 49 5E 2B
 ld.l e, (hld)                  ; 49 5E 2B
 ld.l e, (hli)                  ; 49 5E 23
 ld.l e, (ix)                   ; 49 DD 5E 00
 ld.l e, (ix+127)               ; 49 DD 5E 7F
 ld.l e, (ix-128)               ; 49 DD 5E 80
 ld.l e, (iy)                   ; 49 FD 5E 00
 ld.l e, (iy+127)               ; 49 FD 5E 7F
 ld.l e, (iy-128)               ; 49 FD 5E 80
 ld.l h, (hl)                   ; 49 66
 ld.l h, (hl+)                  ; 49 66 23
 ld.l h, (hl-)                  ; 49 66 2B
 ld.l h, (hld)                  ; 49 66 2B
 ld.l h, (hli)                  ; 49 66 23
 ld.l h, (ix)                   ; 49 DD 66 00
 ld.l h, (ix+127)               ; 49 DD 66 7F
 ld.l h, (ix-128)               ; 49 DD 66 80
 ld.l h, (iy)                   ; 49 FD 66 00
 ld.l h, (iy+127)               ; 49 FD 66 7F
 ld.l h, (iy-128)               ; 49 FD 66 80
 ld.l hl, (hl)                  ; 49 ED 27
 ld.l hl, (hl+)                 ; 49 ED 27 23 23
 ld.l hl, (ix)                  ; 49 DD 27 00
 ld.l hl, (ix+127)              ; 49 DD 27 7F
 ld.l hl, (ix-128)              ; 49 DD 27 80
 ld.l hl, (iy)                  ; 49 FD 27 00
 ld.l hl, (iy+127)              ; 49 FD 27 7F
 ld.l hl, (iy-128)              ; 49 FD 27 80
 ld.l ix, (hl)                  ; 49 ED 37
 ld.l ix, (hl+)                 ; 49 ED 37 23 23
 ld.l ix, (ix)                  ; 49 DD 37 00
 ld.l ix, (ix+127)              ; 49 DD 37 7F
 ld.l ix, (ix-128)              ; 49 DD 37 80
 ld.l ix, (iy)                  ; 49 FD 31 00
 ld.l ix, (iy+127)              ; 49 FD 31 7F
 ld.l ix, (iy-128)              ; 49 FD 31 80
 ld.l iy, (hl)                  ; 49 ED 31
 ld.l iy, (hl+)                 ; 49 ED 31 23 23
 ld.l iy, (ix)                  ; 49 DD 31 00
 ld.l iy, (ix+127)              ; 49 DD 31 7F
 ld.l iy, (ix-128)              ; 49 DD 31 80
 ld.l iy, (iy)                  ; 49 FD 37 00
 ld.l iy, (iy+127)              ; 49 FD 37 7F
 ld.l iy, (iy-128)              ; 49 FD 37 80
 ld.l l, (hl)                   ; 49 6E
 ld.l l, (hl+)                  ; 49 6E 23
 ld.l l, (hl-)                  ; 49 6E 2B
 ld.l l, (hld)                  ; 49 6E 2B
 ld.l l, (hli)                  ; 49 6E 23
 ld.l l, (ix)                   ; 49 DD 6E 00
 ld.l l, (ix+127)               ; 49 DD 6E 7F
 ld.l l, (ix-128)               ; 49 DD 6E 80
 ld.l l, (iy)                   ; 49 FD 6E 00
 ld.l l, (iy+127)               ; 49 FD 6E 7F
 ld.l l, (iy-128)               ; 49 FD 6E 80
 ld.l sp, hl                    ; 49 F9
 ld.l sp, ix                    ; 49 DD F9
 ld.l sp, iy                    ; 49 FD F9
 ld.lil (0x123456), bc          ; 5B ED 43 56 34 12
 ld.lil (0x123456), de          ; 5B ED 53 56 34 12
 ld.lil (0x123456), hl          ; 5B 22 56 34 12
 ld.lil (0x123456), ix          ; 5B DD 22 56 34 12
 ld.lil (0x123456), iy          ; 5B FD 22 56 34 12
 ld.lil (0x123456), sp          ; 5B ED 73 56 34 12
 ld.lil bc, (0x123456)          ; 5B ED 4B 56 34 12
 ld.lil bc, 0x123456            ; 5B 01 56 34 12
 ld.lil de, (0x123456)          ; 5B ED 5B 56 34 12
 ld.lil de, 0x123456            ; 5B 11 56 34 12
 ld.lil hl, (0x123456)          ; 5B 2A 56 34 12
 ld.lil hl, 0x123456            ; 5B 21 56 34 12
 ld.lil ix, (0x123456)          ; 5B DD 2A 56 34 12
 ld.lil ix, 0x123456            ; 5B DD 21 56 34 12
 ld.lil iy, (0x123456)          ; 5B FD 2A 56 34 12
 ld.lil iy, 0x123456            ; 5B FD 21 56 34 12
 ld.lil sp, (0x123456)          ; 5B ED 7B 56 34 12
 ld.lil sp, 0x123456            ; 5B 31 56 34 12
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
 ldd.l                          ; 49 ED A8
 ldd.l (bc), a                  ; 49 02 0B
 ldd.l (de), a                  ; 49 12 1B
 ldd.l (hl), -128               ; 49 36 80 2B
 ldd.l (hl), 127                ; 49 36 7F 2B
 ldd.l (hl), 255                ; 49 36 FF 2B
 ldd.l (hl), a                  ; 49 77 2B
 ldd.l (hl), b                  ; 49 70 2B
 ldd.l (hl), c                  ; 49 71 2B
 ldd.l (hl), d                  ; 49 72 2B
 ldd.l (hl), e                  ; 49 73 2B
 ldd.l (hl), h                  ; 49 74 2B
 ldd.l (hl), l                  ; 49 75 2B
 ldd.l a, (bc)                  ; 49 0A 0B
 ldd.l a, (de)                  ; 49 1A 1B
 ldd.l a, (hl)                  ; 49 7E 2B
 ldd.l b, (hl)                  ; 49 46 2B
 ldd.l c, (hl)                  ; 49 4E 2B
 ldd.l d, (hl)                  ; 49 56 2B
 ldd.l e, (hl)                  ; 49 5E 2B
 ldd.l h, (hl)                  ; 49 66 2B
 ldd.l l, (hl)                  ; 49 6E 2B
 lddr                           ; ED B8
 lddr.l                         ; 49 ED B8
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
 ldi.l                          ; 49 ED A0
 ldi.l (bc), a                  ; 49 02 03
 ldi.l (de), a                  ; 49 12 13
 ldi.l (hl), -128               ; 49 36 80 23
 ldi.l (hl), 127                ; 49 36 7F 23
 ldi.l (hl), 255                ; 49 36 FF 23
 ldi.l (hl), a                  ; 49 77 23
 ldi.l (hl), b                  ; 49 70 23
 ldi.l (hl), bc                 ; 49 ED 0F 23 23
 ldi.l (hl), c                  ; 49 71 23
 ldi.l (hl), d                  ; 49 72 23
 ldi.l (hl), de                 ; 49 ED 1F 23 23
 ldi.l (hl), e                  ; 49 73 23
 ldi.l (hl), h                  ; 49 74 23
 ldi.l (hl), hl                 ; 49 ED 2F 23 23
 ldi.l (hl), ix                 ; 49 ED 3F 23 23
 ldi.l (hl), iy                 ; 49 ED 3E 23 23
 ldi.l (hl), l                  ; 49 75 23
 ldi.l a, (bc)                  ; 49 0A 03
 ldi.l a, (de)                  ; 49 1A 13
 ldi.l a, (hl)                  ; 49 7E 23
 ldi.l b, (hl)                  ; 49 46 23
 ldi.l bc, (hl)                 ; 49 ED 07 23 23
 ldi.l c, (hl)                  ; 49 4E 23
 ldi.l d, (hl)                  ; 49 56 23
 ldi.l de, (hl)                 ; 49 ED 17 23 23
 ldi.l e, (hl)                  ; 49 5E 23
 ldi.l h, (hl)                  ; 49 66 23
 ldi.l hl, (hl)                 ; 49 ED 27 23 23
 ldi.l ix, (hl)                 ; 49 ED 37 23 23
 ldi.l iy, (hl)                 ; 49 ED 31 23 23
 ldi.l l, (hl)                  ; 49 6E 23
 ldir                           ; ED B0
 ldir.l                         ; 49 ED B0
 lea bc, ix                     ; ED 02 00
 lea bc, ix+127                 ; ED 02 7F
 lea bc, ix-128                 ; ED 02 80
 lea bc, iy                     ; ED 03 00
 lea bc, iy+127                 ; ED 03 7F
 lea bc, iy-128                 ; ED 03 80
 lea de, ix                     ; ED 12 00
 lea de, ix+127                 ; ED 12 7F
 lea de, ix-128                 ; ED 12 80
 lea de, iy                     ; ED 13 00
 lea de, iy+127                 ; ED 13 7F
 lea de, iy-128                 ; ED 13 80
 lea hl, ix                     ; ED 22 00
 lea hl, ix+127                 ; ED 22 7F
 lea hl, ix-128                 ; ED 22 80
 lea hl, iy                     ; ED 23 00
 lea hl, iy+127                 ; ED 23 7F
 lea hl, iy-128                 ; ED 23 80
 lea ix, ix                     ; ED 32 00
 lea ix, ix+127                 ; ED 32 7F
 lea ix, ix-128                 ; ED 32 80
 lea ix, iy                     ; ED 54 00
 lea ix, iy+127                 ; ED 54 7F
 lea ix, iy-128                 ; ED 54 80
 lea iy, ix                     ; ED 55 00
 lea iy, ix+127                 ; ED 55 7F
 lea iy, ix-128                 ; ED 55 80
 lea iy, iy                     ; ED 33 00
 lea iy, iy+127                 ; ED 33 7F
 lea iy, iy-128                 ; ED 33 80
 lea.l bc, ix                   ; 49 ED 02 00
 lea.l bc, ix+127               ; 49 ED 02 7F
 lea.l bc, ix-128               ; 49 ED 02 80
 lea.l bc, iy                   ; 49 ED 03 00
 lea.l bc, iy+127               ; 49 ED 03 7F
 lea.l bc, iy-128               ; 49 ED 03 80
 lea.l de, ix                   ; 49 ED 12 00
 lea.l de, ix+127               ; 49 ED 12 7F
 lea.l de, ix-128               ; 49 ED 12 80
 lea.l de, iy                   ; 49 ED 13 00
 lea.l de, iy+127               ; 49 ED 13 7F
 lea.l de, iy-128               ; 49 ED 13 80
 lea.l hl, ix                   ; 49 ED 22 00
 lea.l hl, ix+127               ; 49 ED 22 7F
 lea.l hl, ix-128               ; 49 ED 22 80
 lea.l hl, iy                   ; 49 ED 23 00
 lea.l hl, iy+127               ; 49 ED 23 7F
 lea.l hl, iy-128               ; 49 ED 23 80
 lea.l ix, ix                   ; 49 ED 32 00
 lea.l ix, ix+127               ; 49 ED 32 7F
 lea.l ix, ix-128               ; 49 ED 32 80
 lea.l ix, iy                   ; 49 ED 54 00
 lea.l ix, iy+127               ; 49 ED 54 7F
 lea.l ix, iy-128               ; 49 ED 54 80
 lea.l iy, ix                   ; 49 ED 55 00
 lea.l iy, ix+127               ; 49 ED 55 7F
 lea.l iy, ix-128               ; 49 ED 55 80
 lea.l iy, iy                   ; 49 ED 33 00
 lea.l iy, iy+127               ; 49 ED 33 7F
 lea.l iy, iy-128               ; 49 ED 33 80
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
 mlt bc                         ; ED 4C
 mlt de                         ; ED 5C
 mlt hl                         ; ED 6C
 mlt sp                         ; ED 7C
 mlt.l sp                       ; 49 ED 7C
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
 or a, (hl+)                    ; B6 23
 or a, (hl-)                    ; B6 2B
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
 or.l (hl)                      ; 49 B6
 or.l (hl+)                     ; 49 B6 23
 or.l (hl-)                     ; 49 B6 2B
 or.l (ix)                      ; 49 DD B6 00
 or.l (ix+127)                  ; 49 DD B6 7F
 or.l (ix-128)                  ; 49 DD B6 80
 or.l (iy)                      ; 49 FD B6 00
 or.l (iy+127)                  ; 49 FD B6 7F
 or.l (iy-128)                  ; 49 FD B6 80
 or.l a, (hl)                   ; 49 B6
 or.l a, (hl+)                  ; 49 B6 23
 or.l a, (hl-)                  ; 49 B6 2B
 or.l a, (ix)                   ; 49 DD B6 00
 or.l a, (ix+127)               ; 49 DD B6 7F
 or.l a, (ix-128)               ; 49 DD B6 80
 or.l a, (iy)                   ; 49 FD B6 00
 or.l a, (iy+127)               ; 49 FD B6 7F
 or.l a, (iy-128)               ; 49 FD B6 80
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
 otd2r.l                        ; 49 ED BC
 otdm                           ; ED 8B
 otdm.l                         ; 49 ED 8B
 otdmr                          ; ED 9B
 otdmr.l                        ; 49 ED 9B
 otdr                           ; ED BB
 otdr.l                         ; 49 ED BB
 otdrx                          ; ED CB
 otdrx.l                        ; 49 ED CB
 oti2r                          ; ED B4
 oti2r.l                        ; 49 ED B4
 otim                           ; ED 83
 otim.l                         ; 49 ED 83
 otimr                          ; ED 93
 otimr.l                        ; 49 ED 93
 otir                           ; ED B3
 otir.l                         ; 49 ED B3
 otirx                          ; ED C3
 otirx.l                        ; 49 ED C3
 out (-128), a                  ; D3 80
 out (127), a                   ; D3 7F
 out (255), a                   ; D3 FF
 out (bc), 0                    ; ED 71
 out (bc), a                    ; ED 79
 out (bc), b                    ; ED 41
 out (bc), c                    ; ED 49
 out (bc), d                    ; ED 51
 out (bc), e                    ; ED 59
 out (bc), f                    ; ED 71
 out (bc), h                    ; ED 61
 out (bc), l                    ; ED 69
 out (c), 0                     ; ED 71
 out (c), a                     ; ED 79
 out (c), b                     ; ED 41
 out (c), c                     ; ED 49
 out (c), d                     ; ED 51
 out (c), e                     ; ED 59
 out (c), f                     ; ED 71
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
 out0 (-128), f                 ; ED 31 80
 out0 (-128), h                 ; ED 21 80
 out0 (-128), l                 ; ED 29 80
 out0 (127), a                  ; ED 39 7F
 out0 (127), b                  ; ED 01 7F
 out0 (127), c                  ; ED 09 7F
 out0 (127), d                  ; ED 11 7F
 out0 (127), e                  ; ED 19 7F
 out0 (127), f                  ; ED 31 7F
 out0 (127), h                  ; ED 21 7F
 out0 (127), l                  ; ED 29 7F
 out0 (255), a                  ; ED 39 FF
 out0 (255), b                  ; ED 01 FF
 out0 (255), c                  ; ED 09 FF
 out0 (255), d                  ; ED 11 FF
 out0 (255), e                  ; ED 19 FF
 out0 (255), f                  ; ED 31 FF
 out0 (255), h                  ; ED 21 FF
 out0 (255), l                  ; ED 29 FF
 outd                           ; ED AB
 outd.l                         ; 49 ED AB
 outd2                          ; ED AC
 outd2.l                        ; 49 ED AC
 outi                           ; ED A3
 outi.l                         ; 49 ED A3
 outi2                          ; ED A4
 outi2.l                        ; 49 ED A4
 pchl                           ; E9
 pea ix                         ; ED 65 00
 pea ix+127                     ; ED 65 7F
 pea ix-128                     ; ED 65 80
 pea iy                         ; ED 66 00
 pea iy+127                     ; ED 66 7F
 pea iy-128                     ; ED 66 80
 pea.l ix                       ; 49 ED 65 00
 pea.l ix+127                   ; 49 ED 65 7F
 pea.l ix-128                   ; 49 ED 65 80
 pea.l iy                       ; 49 ED 66 00
 pea.l iy+127                   ; 49 ED 66 7F
 pea.l iy-128                   ; 49 ED 66 80
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
 pop.l af                       ; 49 F1
 pop.l bc                       ; 49 C1
 pop.l de                       ; 49 D1
 pop.l hl                       ; 49 E1
 pop.l ix                       ; 49 DD E1
 pop.l iy                       ; 49 FD E1
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
 push.l af                      ; 49 F5
 push.l bc                      ; 49 C5
 push.l de                      ; 49 D5
 push.l hl                      ; 49 E5
 push.l ix                      ; 49 DD E5
 push.l iy                      ; 49 FD E5
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
 res 7, l                       ; CB BD
 res.l 0, (hl)                  ; 49 CB 86
 res.l 0, (ix)                  ; 49 DD CB 00 86
 res.l 0, (ix+127)              ; 49 DD CB 7F 86
 res.l 0, (ix-128)              ; 49 DD CB 80 86
 res.l 0, (iy)                  ; 49 FD CB 00 86
 res.l 0, (iy+127)              ; 49 FD CB 7F 86
 res.l 0, (iy-128)              ; 49 FD CB 80 86
 res.l 1, (hl)                  ; 49 CB 8E
 res.l 1, (ix)                  ; 49 DD CB 00 8E
 res.l 1, (ix+127)              ; 49 DD CB 7F 8E
 res.l 1, (ix-128)              ; 49 DD CB 80 8E
 res.l 1, (iy)                  ; 49 FD CB 00 8E
 res.l 1, (iy+127)              ; 49 FD CB 7F 8E
 res.l 1, (iy-128)              ; 49 FD CB 80 8E
 res.l 2, (hl)                  ; 49 CB 96
 res.l 2, (ix)                  ; 49 DD CB 00 96
 res.l 2, (ix+127)              ; 49 DD CB 7F 96
 res.l 2, (ix-128)              ; 49 DD CB 80 96
 res.l 2, (iy)                  ; 49 FD CB 00 96
 res.l 2, (iy+127)              ; 49 FD CB 7F 96
 res.l 2, (iy-128)              ; 49 FD CB 80 96
 res.l 3, (hl)                  ; 49 CB 9E
 res.l 3, (ix)                  ; 49 DD CB 00 9E
 res.l 3, (ix+127)              ; 49 DD CB 7F 9E
 res.l 3, (ix-128)              ; 49 DD CB 80 9E
 res.l 3, (iy)                  ; 49 FD CB 00 9E
 res.l 3, (iy+127)              ; 49 FD CB 7F 9E
 res.l 3, (iy-128)              ; 49 FD CB 80 9E
 res.l 4, (hl)                  ; 49 CB A6
 res.l 4, (ix)                  ; 49 DD CB 00 A6
 res.l 4, (ix+127)              ; 49 DD CB 7F A6
 res.l 4, (ix-128)              ; 49 DD CB 80 A6
 res.l 4, (iy)                  ; 49 FD CB 00 A6
 res.l 4, (iy+127)              ; 49 FD CB 7F A6
 res.l 4, (iy-128)              ; 49 FD CB 80 A6
 res.l 5, (hl)                  ; 49 CB AE
 res.l 5, (ix)                  ; 49 DD CB 00 AE
 res.l 5, (ix+127)              ; 49 DD CB 7F AE
 res.l 5, (ix-128)              ; 49 DD CB 80 AE
 res.l 5, (iy)                  ; 49 FD CB 00 AE
 res.l 5, (iy+127)              ; 49 FD CB 7F AE
 res.l 5, (iy-128)              ; 49 FD CB 80 AE
 res.l 6, (hl)                  ; 49 CB B6
 res.l 6, (ix)                  ; 49 DD CB 00 B6
 res.l 6, (ix+127)              ; 49 DD CB 7F B6
 res.l 6, (ix-128)              ; 49 DD CB 80 B6
 res.l 6, (iy)                  ; 49 FD CB 00 B6
 res.l 6, (iy+127)              ; 49 FD CB 7F B6
 res.l 6, (iy-128)              ; 49 FD CB 80 B6
 res.l 7, (hl)                  ; 49 CB BE
 res.l 7, (ix)                  ; 49 DD CB 00 BE
 res.l 7, (ix+127)              ; 49 DD CB 7F BE
 res.l 7, (ix-128)              ; 49 DD CB 80 BE
 res.l 7, (iy)                  ; 49 FD CB 00 BE
 res.l 7, (iy+127)              ; 49 FD CB 7F BE
 res.l 7, (iy-128)              ; 49 FD CB 80 BE
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
 ret.l                          ; 49 C9
 ret.l c                        ; 49 D8
 ret.l m                        ; 49 F8
 ret.l nc                       ; 49 D0
 ret.l nv                       ; 49 E0
 ret.l nz                       ; 49 C0
 ret.l p                        ; 49 F0
 ret.l pe                       ; 49 E8
 ret.l po                       ; 49 E0
 ret.l v                        ; 49 E8
 ret.l z                        ; 49 C8
 reti                           ; ED 4D
 reti.l                         ; 49 ED 4D
 retn                           ; ED 45
 retn.l                         ; 49 ED 45
 rl (hl)                        ; CB 16
 rl (ix)                        ; DD CB 00 16
 rl (ix+127)                    ; DD CB 7F 16
 rl (ix-128)                    ; DD CB 80 16
 rl (iy)                        ; FD CB 00 16
 rl (iy+127)                    ; FD CB 7F 16
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
 rl.l (hl)                      ; 49 CB 16
 rl.l (ix)                      ; 49 DD CB 00 16
 rl.l (ix+127)                  ; 49 DD CB 7F 16
 rl.l (ix-128)                  ; 49 DD CB 80 16
 rl.l (iy)                      ; 49 FD CB 00 16
 rl.l (iy+127)                  ; 49 FD CB 7F 16
 rl.l (iy-128)                  ; 49 FD CB 80 16
 rla                            ; 17
 rlc                            ; 07
 rlc (hl)                       ; CB 06
 rlc (ix)                       ; DD CB 00 06
 rlc (ix+127)                   ; DD CB 7F 06
 rlc (ix-128)                   ; DD CB 80 06
 rlc (iy)                       ; FD CB 00 06
 rlc (iy+127)                   ; FD CB 7F 06
 rlc (iy-128)                   ; FD CB 80 06
 rlc a                          ; CB 07
 rlc b                          ; CB 00
 rlc c                          ; CB 01
 rlc d                          ; CB 02
 rlc e                          ; CB 03
 rlc h                          ; CB 04
 rlc l                          ; CB 05
 rlc.l (hl)                     ; 49 CB 06
 rlc.l (ix)                     ; 49 DD CB 00 06
 rlc.l (ix+127)                 ; 49 DD CB 7F 06
 rlc.l (ix-128)                 ; 49 DD CB 80 06
 rlc.l (iy)                     ; 49 FD CB 00 06
 rlc.l (iy+127)                 ; 49 FD CB 7F 06
 rlc.l (iy-128)                 ; 49 FD CB 80 06
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
 rr (ix+127)                    ; DD CB 7F 1E
 rr (ix-128)                    ; DD CB 80 1E
 rr (iy)                        ; FD CB 00 1E
 rr (iy+127)                    ; FD CB 7F 1E
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
 rr.l (hl)                      ; 49 CB 1E
 rr.l (ix)                      ; 49 DD CB 00 1E
 rr.l (ix+127)                  ; 49 DD CB 7F 1E
 rr.l (ix-128)                  ; 49 DD CB 80 1E
 rr.l (iy)                      ; 49 FD CB 00 1E
 rr.l (iy+127)                  ; 49 FD CB 7F 1E
 rr.l (iy-128)                  ; 49 FD CB 80 1E
 rra                            ; 1F
 rrc                            ; 0F
 rrc (hl)                       ; CB 0E
 rrc (ix)                       ; DD CB 00 0E
 rrc (ix+127)                   ; DD CB 7F 0E
 rrc (ix-128)                   ; DD CB 80 0E
 rrc (iy)                       ; FD CB 00 0E
 rrc (iy+127)                   ; FD CB 7F 0E
 rrc (iy-128)                   ; FD CB 80 0E
 rrc a                          ; CB 0F
 rrc b                          ; CB 08
 rrc c                          ; CB 09
 rrc d                          ; CB 0A
 rrc e                          ; CB 0B
 rrc h                          ; CB 0C
 rrc l                          ; CB 0D
 rrc.l (hl)                     ; 49 CB 0E
 rrc.l (ix)                     ; 49 DD CB 00 0E
 rrc.l (ix+127)                 ; 49 DD CB 7F 0E
 rrc.l (ix-128)                 ; 49 DD CB 80 0E
 rrc.l (iy)                     ; 49 FD CB 00 0E
 rrc.l (iy+127)                 ; 49 FD CB 7F 0E
 rrc.l (iy-128)                 ; 49 FD CB 80 0E
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
 rst.l 0                        ; 49 C7
 rst.l 1                        ; 49 CF
 rst.l 16                       ; 49 D7
 rst.l 2                        ; 49 D7
 rst.l 24                       ; 49 DF
 rst.l 3                        ; 49 DF
 rst.l 32                       ; 49 E7
 rst.l 4                        ; 49 E7
 rst.l 40                       ; 49 EF
 rst.l 48                       ; 49 F7
 rst.l 5                        ; 49 EF
 rst.l 56                       ; 49 FF
 rst.l 6                        ; 49 F7
 rst.l 7                        ; 49 FF
 rst.l 8                        ; 49 CF
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
 sbc a, (hl+)                   ; 9E 23
 sbc a, (hl-)                   ; 9E 2B
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
 sbc.l (hl)                     ; 49 9E
 sbc.l (hl+)                    ; 49 9E 23
 sbc.l (hl-)                    ; 49 9E 2B
 sbc.l (ix)                     ; 49 DD 9E 00
 sbc.l (ix+127)                 ; 49 DD 9E 7F
 sbc.l (ix-128)                 ; 49 DD 9E 80
 sbc.l (iy)                     ; 49 FD 9E 00
 sbc.l (iy+127)                 ; 49 FD 9E 7F
 sbc.l (iy-128)                 ; 49 FD 9E 80
 sbc.l a, (hl)                  ; 49 9E
 sbc.l a, (hl+)                 ; 49 9E 23
 sbc.l a, (hl-)                 ; 49 9E 2B
 sbc.l a, (ix)                  ; 49 DD 9E 00
 sbc.l a, (ix+127)              ; 49 DD 9E 7F
 sbc.l a, (ix-128)              ; 49 DD 9E 80
 sbc.l a, (iy)                  ; 49 FD 9E 00
 sbc.l a, (iy+127)              ; 49 FD 9E 7F
 sbc.l a, (iy-128)              ; 49 FD 9E 80
 sbc.l hl, bc                   ; 49 ED 42
 sbc.l hl, de                   ; 49 ED 52
 sbc.l hl, hl                   ; 49 ED 62
 sbc.l hl, sp                   ; 49 ED 72
 sbi -128                       ; DE 80
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 scf                            ; 37
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
 set 7, l                       ; CB FD
 set.l 0, (hl)                  ; 49 CB C6
 set.l 0, (ix)                  ; 49 DD CB 00 C6
 set.l 0, (ix+127)              ; 49 DD CB 7F C6
 set.l 0, (ix-128)              ; 49 DD CB 80 C6
 set.l 0, (iy)                  ; 49 FD CB 00 C6
 set.l 0, (iy+127)              ; 49 FD CB 7F C6
 set.l 0, (iy-128)              ; 49 FD CB 80 C6
 set.l 1, (hl)                  ; 49 CB CE
 set.l 1, (ix)                  ; 49 DD CB 00 CE
 set.l 1, (ix+127)              ; 49 DD CB 7F CE
 set.l 1, (ix-128)              ; 49 DD CB 80 CE
 set.l 1, (iy)                  ; 49 FD CB 00 CE
 set.l 1, (iy+127)              ; 49 FD CB 7F CE
 set.l 1, (iy-128)              ; 49 FD CB 80 CE
 set.l 2, (hl)                  ; 49 CB D6
 set.l 2, (ix)                  ; 49 DD CB 00 D6
 set.l 2, (ix+127)              ; 49 DD CB 7F D6
 set.l 2, (ix-128)              ; 49 DD CB 80 D6
 set.l 2, (iy)                  ; 49 FD CB 00 D6
 set.l 2, (iy+127)              ; 49 FD CB 7F D6
 set.l 2, (iy-128)              ; 49 FD CB 80 D6
 set.l 3, (hl)                  ; 49 CB DE
 set.l 3, (ix)                  ; 49 DD CB 00 DE
 set.l 3, (ix+127)              ; 49 DD CB 7F DE
 set.l 3, (ix-128)              ; 49 DD CB 80 DE
 set.l 3, (iy)                  ; 49 FD CB 00 DE
 set.l 3, (iy+127)              ; 49 FD CB 7F DE
 set.l 3, (iy-128)              ; 49 FD CB 80 DE
 set.l 4, (hl)                  ; 49 CB E6
 set.l 4, (ix)                  ; 49 DD CB 00 E6
 set.l 4, (ix+127)              ; 49 DD CB 7F E6
 set.l 4, (ix-128)              ; 49 DD CB 80 E6
 set.l 4, (iy)                  ; 49 FD CB 00 E6
 set.l 4, (iy+127)              ; 49 FD CB 7F E6
 set.l 4, (iy-128)              ; 49 FD CB 80 E6
 set.l 5, (hl)                  ; 49 CB EE
 set.l 5, (ix)                  ; 49 DD CB 00 EE
 set.l 5, (ix+127)              ; 49 DD CB 7F EE
 set.l 5, (ix-128)              ; 49 DD CB 80 EE
 set.l 5, (iy)                  ; 49 FD CB 00 EE
 set.l 5, (iy+127)              ; 49 FD CB 7F EE
 set.l 5, (iy-128)              ; 49 FD CB 80 EE
 set.l 6, (hl)                  ; 49 CB F6
 set.l 6, (ix)                  ; 49 DD CB 00 F6
 set.l 6, (ix+127)              ; 49 DD CB 7F F6
 set.l 6, (ix-128)              ; 49 DD CB 80 F6
 set.l 6, (iy)                  ; 49 FD CB 00 F6
 set.l 6, (iy+127)              ; 49 FD CB 7F F6
 set.l 6, (iy-128)              ; 49 FD CB 80 F6
 set.l 7, (hl)                  ; 49 CB FE
 set.l 7, (ix)                  ; 49 DD CB 00 FE
 set.l 7, (ix+127)              ; 49 DD CB 7F FE
 set.l 7, (ix-128)              ; 49 DD CB 80 FE
 set.l 7, (iy)                  ; 49 FD CB 00 FE
 set.l 7, (iy+127)              ; 49 FD CB 7F FE
 set.l 7, (iy-128)              ; 49 FD CB 80 FE
 shld -32768                    ; 22 00 80
 shld 32767                     ; 22 FF 7F
 shld 65535                     ; 22 FF FF
 sla (hl)                       ; CB 26
 sla (ix)                       ; DD CB 00 26
 sla (ix+127)                   ; DD CB 7F 26
 sla (ix-128)                   ; DD CB 80 26
 sla (iy)                       ; FD CB 00 26
 sla (iy+127)                   ; FD CB 7F 26
 sla (iy-128)                   ; FD CB 80 26
 sla a                          ; CB 27
 sla b                          ; CB 20
 sla c                          ; CB 21
 sla d                          ; CB 22
 sla e                          ; CB 23
 sla h                          ; CB 24
 sla l                          ; CB 25
 sla.l (hl)                     ; 49 CB 26
 sla.l (ix)                     ; 49 DD CB 00 26
 sla.l (ix+127)                 ; 49 DD CB 7F 26
 sla.l (ix-128)                 ; 49 DD CB 80 26
 sla.l (iy)                     ; 49 FD CB 00 26
 sla.l (iy+127)                 ; 49 FD CB 7F 26
 sla.l (iy-128)                 ; 49 FD CB 80 26
 slp                            ; ED 76
 sphl                           ; F9
 sra (hl)                       ; CB 2E
 sra (ix)                       ; DD CB 00 2E
 sra (ix+127)                   ; DD CB 7F 2E
 sra (ix-128)                   ; DD CB 80 2E
 sra (iy)                       ; FD CB 00 2E
 sra (iy+127)                   ; FD CB 7F 2E
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
 sra.l (hl)                     ; 49 CB 2E
 sra.l (ix)                     ; 49 DD CB 00 2E
 sra.l (ix+127)                 ; 49 DD CB 7F 2E
 sra.l (ix-128)                 ; 49 DD CB 80 2E
 sra.l (iy)                     ; 49 FD CB 00 2E
 sra.l (iy+127)                 ; 49 FD CB 7F 2E
 sra.l (iy-128)                 ; 49 FD CB 80 2E
 srl (hl)                       ; CB 3E
 srl (ix)                       ; DD CB 00 3E
 srl (ix+127)                   ; DD CB 7F 3E
 srl (ix-128)                   ; DD CB 80 3E
 srl (iy)                       ; FD CB 00 3E
 srl (iy+127)                   ; FD CB 7F 3E
 srl (iy-128)                   ; FD CB 80 3E
 srl a                          ; CB 3F
 srl b                          ; CB 38
 srl c                          ; CB 39
 srl d                          ; CB 3A
 srl e                          ; CB 3B
 srl h                          ; CB 3C
 srl l                          ; CB 3D
 srl.l (hl)                     ; 49 CB 3E
 srl.l (ix)                     ; 49 DD CB 00 3E
 srl.l (ix+127)                 ; 49 DD CB 7F 3E
 srl.l (ix-128)                 ; 49 DD CB 80 3E
 srl.l (iy)                     ; 49 FD CB 00 3E
 srl.l (iy+127)                 ; 49 FD CB 7F 3E
 srl.l (iy-128)                 ; 49 FD CB 80 3E
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
 sub a, (hl+)                   ; 96 23
 sub a, (hl-)                   ; 96 2B
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
 sub.l (hl+)                    ; 49 96 23
 sub.l (hl-)                    ; 49 96 2B
 sub.l (ix)                     ; 49 DD 96 00
 sub.l (ix+127)                 ; 49 DD 96 7F
 sub.l (ix-128)                 ; 49 DD 96 80
 sub.l (iy)                     ; 49 FD 96 00
 sub.l (iy+127)                 ; 49 FD 96 7F
 sub.l (iy-128)                 ; 49 FD 96 80
 sub.l a, (hl)                  ; 49 96
 sub.l a, (hl+)                 ; 49 96 23
 sub.l a, (hl-)                 ; 49 96 2B
 sub.l a, (ix)                  ; 49 DD 96 00
 sub.l a, (ix+127)              ; 49 DD 96 7F
 sub.l a, (ix-128)              ; 49 DD 96 80
 sub.l a, (iy)                  ; 49 FD 96 00
 sub.l a, (iy+127)              ; 49 FD 96 7F
 sub.l a, (iy-128)              ; 49 FD 96 80
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
 test.l (hl)                    ; 49 ED 34
 test.l a, (hl)                 ; 49 ED 34
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
 tst.l (hl)                     ; 49 ED 34
 tst.l a, (hl)                  ; 49 ED 34
 tstio -128                     ; ED 74 80
 tstio 127                      ; ED 74 7F
 tstio 255                      ; ED 74 FF
 xchg                           ; EB
 xor (hl)                       ; AE
 xor (hl+)                      ; AE 23
 xor (hl-)                      ; AE 2B
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
 xor a, (hl+)                   ; AE 23
 xor a, (hl-)                   ; AE 2B
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
 xor.l (hl)                     ; 49 AE
 xor.l (hl+)                    ; 49 AE 23
 xor.l (hl-)                    ; 49 AE 2B
 xor.l (ix)                     ; 49 DD AE 00
 xor.l (ix+127)                 ; 49 DD AE 7F
 xor.l (ix-128)                 ; 49 DD AE 80
 xor.l (iy)                     ; 49 FD AE 00
 xor.l (iy+127)                 ; 49 FD AE 7F
 xor.l (iy-128)                 ; 49 FD AE 80
 xor.l a, (hl)                  ; 49 AE
 xor.l a, (hl+)                 ; 49 AE 23
 xor.l a, (hl-)                 ; 49 AE 2B
 xor.l a, (ix)                  ; 49 DD AE 00
 xor.l a, (ix+127)              ; 49 DD AE 7F
 xor.l a, (ix-128)              ; 49 DD AE 80
 xor.l a, (iy)                  ; 49 FD AE 00
 xor.l a, (iy+127)              ; 49 FD AE 7F
 xor.l a, (iy-128)              ; 49 FD AE 80
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
