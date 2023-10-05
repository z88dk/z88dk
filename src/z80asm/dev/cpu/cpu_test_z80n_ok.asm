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
 add bc, 0x1234                 ; ED 36 34 12
 add bc, a                      ; ED 33
 add c                          ; 81
 add d                          ; 82
 add de, 0x1234                 ; ED 35 34 12
 add de, a                      ; ED 32
 add e                          ; 83
 add h                          ; 84
 add hl, 0x1234                 ; ED 34 34 12
 add hl, a                      ; ED 31
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
 and hl, bc                     ; F5 7C A0 67 7D A1 6F F1
 and hl, de                     ; F5 7C A2 67 7D A3 6F F1
 and ix, bc                     ; F5 DD 7C A0 DD 67 DD 7D A1 DD 6F F1
 and ix, de                     ; F5 DD 7C A2 DD 67 DD 7D A3 DD 6F F1
 and ixh                        ; DD A4
 and ixl                        ; DD A5
 and iy, bc                     ; F5 FD 7C A0 FD 67 FD 7D A1 FD 6F F1
 and iy, de                     ; F5 FD 7C A2 FD 67 FD 7D A3 FD 6F F1
 and iyh                        ; FD A4
 and iyl                        ; FD A5
 and l                          ; A5
 ani -128                       ; E6 80
 ani 0                          ; E6 00
 ani 127                        ; E6 7F
 ani 255                        ; E6 FF
 arhl                           ; CB 2C CB 1D
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
 bool hl                        ; F5 7C B5 28 03 21 01 00 F1
 bool ix                        ; F5 DD 7C DD B5 28 04 DD 21 01 00 F1
 bool iy                        ; F5 FD 7C FD B5 28 04 FD 21 01 00 F1
 brlc de, b                     ; ED 2C
 bsla de, b                     ; ED 28
 bsra de, b                     ; ED 29
 bsrf de, b                     ; ED 2B
 bsrl de, b                     ; ED 2A
 c_c 0x1234                     ; DC 34 12
 c_eq 0x1234                    ; CC 34 12
 c_geu 0x1234                   ; D4 34 12
 c_gtu 0x1234                   ; 28 05 38 03 CD 34 12
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
 call (ix)                      ; CD @__z80asm__call_ix
 call (iy)                      ; CD @__z80asm__call_iy
 call 0x1234                    ; CD 34 12
 call c, 0x1234                 ; DC 34 12
 call eq, 0x1234                ; CC 34 12
 call geu, 0x1234               ; D4 34 12
 call gtu, 0x1234               ; 28 05 38 03 CD 34 12
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
 cc 0x1234                      ; DC 34 12
 ccf                            ; 3F
 ceq 0x1234                     ; CC 34 12
 cgeu 0x1234                    ; D4 34 12
 cgtu 0x1234                    ; 28 05 38 03 CD 34 12
 cleu 0x1234                    ; 28 02 30 03 CD 34 12
 clr (hl)                       ; 36 00
 clr (ix)                       ; DD 36 00 00
 clr (ix+0)                     ; DD 36 00 00
 clr (ix+126)                   ; DD 36 7E 00
 clr (ix-128)                   ; DD 36 80 00
 clr (iy)                       ; FD 36 00 00
 clr (iy+0)                     ; FD 36 00 00
 clr (iy+126)                   ; FD 36 7E 00
 clr (iy-128)                   ; FD 36 80 00
 clr a                          ; 3E 00
 clr b                          ; 06 00
 clr bc                         ; 01 00 00
 clr c                          ; 0E 00
 clr d                          ; 16 00
 clr de                         ; 11 00 00
 clr e                          ; 1E 00
 clr h                          ; 26 00
 clr hl                         ; 21 00 00
 clr ix                         ; DD 21 00 00
 clr ixh                        ; DD 26 00
 clr ixl                        ; DD 2E 00
 clr iy                         ; FD 21 00 00
 clr iyh                        ; FD 26 00
 clr iyl                        ; FD 2E 00
 clr l                          ; 2E 00
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
 cpd                            ; ED A9
 cpdr                           ; ED B9
 cpe 0x1234                     ; EC 34 12
 cpi                            ; ED A1
 cpi -128                       ; FE 80
 cpi 0                          ; FE 00
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpir                           ; ED B1
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
 ex bc, hl                      ; E5 C5 E1 C1
 ex de, hl                      ; EB
 ex hl, bc                      ; E5 C5 E1 C1
 ex hl, de                      ; EB
 exx                            ; D9
 halt                           ; 76
 hlt                            ; 76
 im 0                           ; ED 46
 im 1                           ; ED 56
 im 2                           ; ED 5E
 in (bc)                        ; ED 70
 in (c)                         ; ED 70
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
 in f, (bc)                     ; ED 70
 in f, (c)                      ; ED 70
 in h, (bc)                     ; ED 60
 in h, (c)                      ; ED 60
 in l, (bc)                     ; ED 68
 in l, (c)                      ; ED 68
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
 ind                            ; ED AA
 indr                           ; ED BA
 ini                            ; ED A2
 inir                           ; ED B2
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
 j_gtu 0x1234                   ; CA 64 06 D2 34 12
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
 jgtu 0x1234                    ; CA 9A 06 D2 34 12
 jleu 0x1234                    ; CA 34 12 DA 34 12
 jltu 0x1234                    ; DA 34 12
 jm 0x1234                      ; FA 34 12
 jmp (bc)                       ; C5 C9
 jmp (c)                        ; ED 98
 jmp (de)                       ; D5 C9
 jmp (hl)                       ; E9
 jmp (ix)                       ; DD E9
 jmp (iy)                       ; FD E9
 jmp 0x1234                     ; C3 34 12
 jmp c, 0x1234                  ; DA 34 12
 jmp eq, 0x1234                 ; CA 34 12
 jmp geu, 0x1234                ; D2 34 12
 jmp gtu, 0x1234                ; CA C3 06 D2 34 12
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
 jp (bc)                        ; C5 C9
 jp (c)                         ; ED 98
 jp (de)                        ; D5 C9
 jp (hl)                        ; E9
 jp (ix)                        ; DD E9
 jp (iy)                        ; FD E9
 jp 0x1234                      ; C3 34 12
 jp c, 0x1234                   ; DA 34 12
 jp eq, 0x1234                  ; CA 34 12
 jp geu, 0x1234                 ; D2 34 12
 jp gtu, 0x1234                 ; CA 13 07 D2 34 12
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
 ld (0x1234), a                 ; 32 34 12
 ld (0x1234), bc                ; ED 43 34 12
 ld (0x1234), de                ; ED 53 34 12
 ld (0x1234), hl                ; 22 34 12
 ld (0x1234), ix                ; DD 22 34 12
 ld (0x1234), iy                ; FD 22 34 12
 ld (0x1234), sp                ; ED 73 34 12
 ld (bc), a                     ; 02
 ld (bc+), a                    ; 02 03
 ld (bc-), a                    ; 02 0B
 ld (de), -128                  ; EB 36 80 EB
 ld (de), 0                     ; EB 36 00 EB
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
 ld (de-), -128                 ; EB 36 80 EB 1B
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
 ld (hl), -128                  ; 36 80
 ld (hl), 0                     ; 36 00
 ld (hl), 127                   ; 36 7F
 ld (hl), 255                   ; 36 FF
 ld (hl), a                     ; 77
 ld (hl), b                     ; 70
 ld (hl), bc                    ; 71 23 70 2B
 ld (hl), c                     ; 71
 ld (hl), d                     ; 72
 ld (hl), de                    ; 73 23 72 2B
 ld (hl), e                     ; 73
 ld (hl), h                     ; 74
 ld (hl), hl                    ; F5 7C 75 23 77 F1 2B
 ld (hl), ix                    ; D5 DD E5 D1 73 23 72 2B D1
 ld (hl), iy                    ; D5 FD E5 D1 73 23 72 2B D1
 ld (hl), l                     ; 75
 ld (hl+), -128                 ; 36 80 23
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
 ld (hl+), ix                   ; D5 DD E5 D1 73 23 72 23 D1
 ld (hl+), iy                   ; D5 FD E5 D1 73 23 72 23 D1
 ld (hl+), l                    ; 75 23
 ld (hl-), -128                 ; 36 80 2B
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
 ld (ix), -128                  ; DD 36 00 80
 ld (ix), 0                     ; DD 36 00 00
 ld (ix), 127                   ; DD 36 00 7F
 ld (ix), 255                   ; DD 36 00 FF
 ld (ix), a                     ; DD 77 00
 ld (ix), b                     ; DD 70 00
 ld (ix), bc                    ; DD 71 00 DD 70 01
 ld (ix), c                     ; DD 71 00
 ld (ix), d                     ; DD 72 00
 ld (ix), de                    ; DD 73 00 DD 72 01
 ld (ix), e                     ; DD 73 00
 ld (ix), h                     ; DD 74 00
 ld (ix), hl                    ; DD 75 00 DD 74 01
 ld (ix), ix                    ; DD E5 E3 DD 75 00 DD 74 01 E3 DD E1
 ld (ix), iy                    ; FD E5 E3 DD 75 00 DD 74 01 E3 FD E1
 ld (ix), l                     ; DD 75 00
 ld (ix+0), -128                ; DD 36 00 80
 ld (ix+0), 0                   ; DD 36 00 00
 ld (ix+0), 127                 ; DD 36 00 7F
 ld (ix+0), 255                 ; DD 36 00 FF
 ld (ix+0), a                   ; DD 77 00
 ld (ix+0), b                   ; DD 70 00
 ld (ix+0), bc                  ; DD 71 00 DD 70 01
 ld (ix+0), c                   ; DD 71 00
 ld (ix+0), d                   ; DD 72 00
 ld (ix+0), de                  ; DD 73 00 DD 72 01
 ld (ix+0), e                   ; DD 73 00
 ld (ix+0), h                   ; DD 74 00
 ld (ix+0), hl                  ; DD 75 00 DD 74 01
 ld (ix+0), ix                  ; DD E5 E3 DD 75 00 DD 74 01 E3 DD E1
 ld (ix+0), iy                  ; FD E5 E3 DD 75 00 DD 74 01 E3 FD E1
 ld (ix+0), l                   ; DD 75 00
 ld (ix+126), -128              ; DD 36 7E 80
 ld (ix+126), 0                 ; DD 36 7E 00
 ld (ix+126), 127               ; DD 36 7E 7F
 ld (ix+126), 255               ; DD 36 7E FF
 ld (ix+126), a                 ; DD 77 7E
 ld (ix+126), b                 ; DD 70 7E
 ld (ix+126), bc                ; DD 71 7E DD 70 7F
 ld (ix+126), c                 ; DD 71 7E
 ld (ix+126), d                 ; DD 72 7E
 ld (ix+126), de                ; DD 73 7E DD 72 7F
 ld (ix+126), e                 ; DD 73 7E
 ld (ix+126), h                 ; DD 74 7E
 ld (ix+126), hl                ; DD 75 7E DD 74 7F
 ld (ix+126), ix                ; DD E5 E3 DD 75 7E DD 74 7F E3 DD E1
 ld (ix+126), iy                ; FD E5 E3 DD 75 7E DD 74 7F E3 FD E1
 ld (ix+126), l                 ; DD 75 7E
 ld (ix-128), -128              ; DD 36 80 80
 ld (ix-128), 0                 ; DD 36 80 00
 ld (ix-128), 127               ; DD 36 80 7F
 ld (ix-128), 255               ; DD 36 80 FF
 ld (ix-128), a                 ; DD 77 80
 ld (ix-128), b                 ; DD 70 80
 ld (ix-128), bc                ; DD 71 80 DD 70 81
 ld (ix-128), c                 ; DD 71 80
 ld (ix-128), d                 ; DD 72 80
 ld (ix-128), de                ; DD 73 80 DD 72 81
 ld (ix-128), e                 ; DD 73 80
 ld (ix-128), h                 ; DD 74 80
 ld (ix-128), hl                ; DD 75 80 DD 74 81
 ld (ix-128), ix                ; DD E5 E3 DD 75 80 DD 74 81 E3 DD E1
 ld (ix-128), iy                ; FD E5 E3 DD 75 80 DD 74 81 E3 FD E1
 ld (ix-128), l                 ; DD 75 80
 ld (iy), -128                  ; FD 36 00 80
 ld (iy), 0                     ; FD 36 00 00
 ld (iy), 127                   ; FD 36 00 7F
 ld (iy), 255                   ; FD 36 00 FF
 ld (iy), a                     ; FD 77 00
 ld (iy), b                     ; FD 70 00
 ld (iy), bc                    ; FD 71 00 FD 70 01
 ld (iy), c                     ; FD 71 00
 ld (iy), d                     ; FD 72 00
 ld (iy), de                    ; FD 73 00 FD 72 01
 ld (iy), e                     ; FD 73 00
 ld (iy), h                     ; FD 74 00
 ld (iy), hl                    ; FD 75 00 FD 74 01
 ld (iy), ix                    ; DD E5 E3 FD 75 00 FD 74 01 E3 DD E1
 ld (iy), iy                    ; FD E5 E3 FD 75 00 FD 74 01 E3 FD E1
 ld (iy), l                     ; FD 75 00
 ld (iy+0), -128                ; FD 36 00 80
 ld (iy+0), 0                   ; FD 36 00 00
 ld (iy+0), 127                 ; FD 36 00 7F
 ld (iy+0), 255                 ; FD 36 00 FF
 ld (iy+0), a                   ; FD 77 00
 ld (iy+0), b                   ; FD 70 00
 ld (iy+0), bc                  ; FD 71 00 FD 70 01
 ld (iy+0), c                   ; FD 71 00
 ld (iy+0), d                   ; FD 72 00
 ld (iy+0), de                  ; FD 73 00 FD 72 01
 ld (iy+0), e                   ; FD 73 00
 ld (iy+0), h                   ; FD 74 00
 ld (iy+0), hl                  ; FD 75 00 FD 74 01
 ld (iy+0), ix                  ; DD E5 E3 FD 75 00 FD 74 01 E3 DD E1
 ld (iy+0), iy                  ; FD E5 E3 FD 75 00 FD 74 01 E3 FD E1
 ld (iy+0), l                   ; FD 75 00
 ld (iy+126), -128              ; FD 36 7E 80
 ld (iy+126), 0                 ; FD 36 7E 00
 ld (iy+126), 127               ; FD 36 7E 7F
 ld (iy+126), 255               ; FD 36 7E FF
 ld (iy+126), a                 ; FD 77 7E
 ld (iy+126), b                 ; FD 70 7E
 ld (iy+126), bc                ; FD 71 7E FD 70 7F
 ld (iy+126), c                 ; FD 71 7E
 ld (iy+126), d                 ; FD 72 7E
 ld (iy+126), de                ; FD 73 7E FD 72 7F
 ld (iy+126), e                 ; FD 73 7E
 ld (iy+126), h                 ; FD 74 7E
 ld (iy+126), hl                ; FD 75 7E FD 74 7F
 ld (iy+126), ix                ; DD E5 E3 FD 75 7E FD 74 7F E3 DD E1
 ld (iy+126), iy                ; FD E5 E3 FD 75 7E FD 74 7F E3 FD E1
 ld (iy+126), l                 ; FD 75 7E
 ld (iy-128), -128              ; FD 36 80 80
 ld (iy-128), 0                 ; FD 36 80 00
 ld (iy-128), 127               ; FD 36 80 7F
 ld (iy-128), 255               ; FD 36 80 FF
 ld (iy-128), a                 ; FD 77 80
 ld (iy-128), b                 ; FD 70 80
 ld (iy-128), bc                ; FD 71 80 FD 70 81
 ld (iy-128), c                 ; FD 71 80
 ld (iy-128), d                 ; FD 72 80
 ld (iy-128), de                ; FD 73 80 FD 72 81
 ld (iy-128), e                 ; FD 73 80
 ld (iy-128), h                 ; FD 74 80
 ld (iy-128), hl                ; FD 75 80 FD 74 81
 ld (iy-128), ix                ; DD E5 E3 FD 75 80 FD 74 81 E3 DD E1
 ld (iy-128), iy                ; FD E5 E3 FD 75 80 FD 74 81 E3 FD E1
 ld (iy-128), l                 ; FD 75 80
 ld a, (0x1234)                 ; 3A 34 12
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
 ld a, (ix+0)                   ; DD 7E 00
 ld a, (ix+126)                 ; DD 7E 7E
 ld a, (ix-128)                 ; DD 7E 80
 ld a, (iy)                     ; FD 7E 00
 ld a, (iy+0)                   ; FD 7E 00
 ld a, (iy+126)                 ; FD 7E 7E
 ld a, (iy-128)                 ; FD 7E 80
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
 ld a, i                        ; ED 57
 ld a, ixh                      ; DD 7C
 ld a, ixl                      ; DD 7D
 ld a, iyh                      ; FD 7C
 ld a, iyl                      ; FD 7D
 ld a, l                        ; 7D
 ld a, r                        ; ED 5F
 ld a, res 0, (ix)              ; DD CB 00 87
 ld a, res 0, (ix+0)            ; DD CB 00 87
 ld a, res 0, (ix+126)          ; DD CB 7E 87
 ld a, res 0, (ix-128)          ; DD CB 80 87
 ld a, res 0, (iy)              ; FD CB 00 87
 ld a, res 0, (iy+0)            ; FD CB 00 87
 ld a, res 0, (iy+126)          ; FD CB 7E 87
 ld a, res 0, (iy-128)          ; FD CB 80 87
 ld a, res 1, (ix)              ; DD CB 00 8F
 ld a, res 1, (ix+0)            ; DD CB 00 8F
 ld a, res 1, (ix+126)          ; DD CB 7E 8F
 ld a, res 1, (ix-128)          ; DD CB 80 8F
 ld a, res 1, (iy)              ; FD CB 00 8F
 ld a, res 1, (iy+0)            ; FD CB 00 8F
 ld a, res 1, (iy+126)          ; FD CB 7E 8F
 ld a, res 1, (iy-128)          ; FD CB 80 8F
 ld a, res 2, (ix)              ; DD CB 00 97
 ld a, res 2, (ix+0)            ; DD CB 00 97
 ld a, res 2, (ix+126)          ; DD CB 7E 97
 ld a, res 2, (ix-128)          ; DD CB 80 97
 ld a, res 2, (iy)              ; FD CB 00 97
 ld a, res 2, (iy+0)            ; FD CB 00 97
 ld a, res 2, (iy+126)          ; FD CB 7E 97
 ld a, res 2, (iy-128)          ; FD CB 80 97
 ld a, res 3, (ix)              ; DD CB 00 9F
 ld a, res 3, (ix+0)            ; DD CB 00 9F
 ld a, res 3, (ix+126)          ; DD CB 7E 9F
 ld a, res 3, (ix-128)          ; DD CB 80 9F
 ld a, res 3, (iy)              ; FD CB 00 9F
 ld a, res 3, (iy+0)            ; FD CB 00 9F
 ld a, res 3, (iy+126)          ; FD CB 7E 9F
 ld a, res 3, (iy-128)          ; FD CB 80 9F
 ld a, res 4, (ix)              ; DD CB 00 A7
 ld a, res 4, (ix+0)            ; DD CB 00 A7
 ld a, res 4, (ix+126)          ; DD CB 7E A7
 ld a, res 4, (ix-128)          ; DD CB 80 A7
 ld a, res 4, (iy)              ; FD CB 00 A7
 ld a, res 4, (iy+0)            ; FD CB 00 A7
 ld a, res 4, (iy+126)          ; FD CB 7E A7
 ld a, res 4, (iy-128)          ; FD CB 80 A7
 ld a, res 5, (ix)              ; DD CB 00 AF
 ld a, res 5, (ix+0)            ; DD CB 00 AF
 ld a, res 5, (ix+126)          ; DD CB 7E AF
 ld a, res 5, (ix-128)          ; DD CB 80 AF
 ld a, res 5, (iy)              ; FD CB 00 AF
 ld a, res 5, (iy+0)            ; FD CB 00 AF
 ld a, res 5, (iy+126)          ; FD CB 7E AF
 ld a, res 5, (iy-128)          ; FD CB 80 AF
 ld a, res 6, (ix)              ; DD CB 00 B7
 ld a, res 6, (ix+0)            ; DD CB 00 B7
 ld a, res 6, (ix+126)          ; DD CB 7E B7
 ld a, res 6, (ix-128)          ; DD CB 80 B7
 ld a, res 6, (iy)              ; FD CB 00 B7
 ld a, res 6, (iy+0)            ; FD CB 00 B7
 ld a, res 6, (iy+126)          ; FD CB 7E B7
 ld a, res 6, (iy-128)          ; FD CB 80 B7
 ld a, res 7, (ix)              ; DD CB 00 BF
 ld a, res 7, (ix+0)            ; DD CB 00 BF
 ld a, res 7, (ix+126)          ; DD CB 7E BF
 ld a, res 7, (ix-128)          ; DD CB 80 BF
 ld a, res 7, (iy)              ; FD CB 00 BF
 ld a, res 7, (iy+0)            ; FD CB 00 BF
 ld a, res 7, (iy+126)          ; FD CB 7E BF
 ld a, res 7, (iy-128)          ; FD CB 80 BF
 ld a, rl (ix)                  ; DD CB 00 17
 ld a, rl (ix+0)                ; DD CB 00 17
 ld a, rl (ix+126)              ; DD CB 7E 17
 ld a, rl (ix-128)              ; DD CB 80 17
 ld a, rl (iy)                  ; FD CB 00 17
 ld a, rl (iy+0)                ; FD CB 00 17
 ld a, rl (iy+126)              ; FD CB 7E 17
 ld a, rl (iy-128)              ; FD CB 80 17
 ld a, rlc (ix)                 ; DD CB 00 07
 ld a, rlc (ix+0)               ; DD CB 00 07
 ld a, rlc (ix+126)             ; DD CB 7E 07
 ld a, rlc (ix-128)             ; DD CB 80 07
 ld a, rlc (iy)                 ; FD CB 00 07
 ld a, rlc (iy+0)               ; FD CB 00 07
 ld a, rlc (iy+126)             ; FD CB 7E 07
 ld a, rlc (iy-128)             ; FD CB 80 07
 ld a, rr (ix)                  ; DD CB 00 1F
 ld a, rr (ix+0)                ; DD CB 00 1F
 ld a, rr (ix+126)              ; DD CB 7E 1F
 ld a, rr (ix-128)              ; DD CB 80 1F
 ld a, rr (iy)                  ; FD CB 00 1F
 ld a, rr (iy+0)                ; FD CB 00 1F
 ld a, rr (iy+126)              ; FD CB 7E 1F
 ld a, rr (iy-128)              ; FD CB 80 1F
 ld a, rrc (ix)                 ; DD CB 00 0F
 ld a, rrc (ix+0)               ; DD CB 00 0F
 ld a, rrc (ix+126)             ; DD CB 7E 0F
 ld a, rrc (ix-128)             ; DD CB 80 0F
 ld a, rrc (iy)                 ; FD CB 00 0F
 ld a, rrc (iy+0)               ; FD CB 00 0F
 ld a, rrc (iy+126)             ; FD CB 7E 0F
 ld a, rrc (iy-128)             ; FD CB 80 0F
 ld a, set 0, (ix)              ; DD CB 00 C7
 ld a, set 0, (ix+0)            ; DD CB 00 C7
 ld a, set 0, (ix+126)          ; DD CB 7E C7
 ld a, set 0, (ix-128)          ; DD CB 80 C7
 ld a, set 0, (iy)              ; FD CB 00 C7
 ld a, set 0, (iy+0)            ; FD CB 00 C7
 ld a, set 0, (iy+126)          ; FD CB 7E C7
 ld a, set 0, (iy-128)          ; FD CB 80 C7
 ld a, set 1, (ix)              ; DD CB 00 CF
 ld a, set 1, (ix+0)            ; DD CB 00 CF
 ld a, set 1, (ix+126)          ; DD CB 7E CF
 ld a, set 1, (ix-128)          ; DD CB 80 CF
 ld a, set 1, (iy)              ; FD CB 00 CF
 ld a, set 1, (iy+0)            ; FD CB 00 CF
 ld a, set 1, (iy+126)          ; FD CB 7E CF
 ld a, set 1, (iy-128)          ; FD CB 80 CF
 ld a, set 2, (ix)              ; DD CB 00 D7
 ld a, set 2, (ix+0)            ; DD CB 00 D7
 ld a, set 2, (ix+126)          ; DD CB 7E D7
 ld a, set 2, (ix-128)          ; DD CB 80 D7
 ld a, set 2, (iy)              ; FD CB 00 D7
 ld a, set 2, (iy+0)            ; FD CB 00 D7
 ld a, set 2, (iy+126)          ; FD CB 7E D7
 ld a, set 2, (iy-128)          ; FD CB 80 D7
 ld a, set 3, (ix)              ; DD CB 00 DF
 ld a, set 3, (ix+0)            ; DD CB 00 DF
 ld a, set 3, (ix+126)          ; DD CB 7E DF
 ld a, set 3, (ix-128)          ; DD CB 80 DF
 ld a, set 3, (iy)              ; FD CB 00 DF
 ld a, set 3, (iy+0)            ; FD CB 00 DF
 ld a, set 3, (iy+126)          ; FD CB 7E DF
 ld a, set 3, (iy-128)          ; FD CB 80 DF
 ld a, set 4, (ix)              ; DD CB 00 E7
 ld a, set 4, (ix+0)            ; DD CB 00 E7
 ld a, set 4, (ix+126)          ; DD CB 7E E7
 ld a, set 4, (ix-128)          ; DD CB 80 E7
 ld a, set 4, (iy)              ; FD CB 00 E7
 ld a, set 4, (iy+0)            ; FD CB 00 E7
 ld a, set 4, (iy+126)          ; FD CB 7E E7
 ld a, set 4, (iy-128)          ; FD CB 80 E7
 ld a, set 5, (ix)              ; DD CB 00 EF
 ld a, set 5, (ix+0)            ; DD CB 00 EF
 ld a, set 5, (ix+126)          ; DD CB 7E EF
 ld a, set 5, (ix-128)          ; DD CB 80 EF
 ld a, set 5, (iy)              ; FD CB 00 EF
 ld a, set 5, (iy+0)            ; FD CB 00 EF
 ld a, set 5, (iy+126)          ; FD CB 7E EF
 ld a, set 5, (iy-128)          ; FD CB 80 EF
 ld a, set 6, (ix)              ; DD CB 00 F7
 ld a, set 6, (ix+0)            ; DD CB 00 F7
 ld a, set 6, (ix+126)          ; DD CB 7E F7
 ld a, set 6, (ix-128)          ; DD CB 80 F7
 ld a, set 6, (iy)              ; FD CB 00 F7
 ld a, set 6, (iy+0)            ; FD CB 00 F7
 ld a, set 6, (iy+126)          ; FD CB 7E F7
 ld a, set 6, (iy-128)          ; FD CB 80 F7
 ld a, set 7, (ix)              ; DD CB 00 FF
 ld a, set 7, (ix+0)            ; DD CB 00 FF
 ld a, set 7, (ix+126)          ; DD CB 7E FF
 ld a, set 7, (ix-128)          ; DD CB 80 FF
 ld a, set 7, (iy)              ; FD CB 00 FF
 ld a, set 7, (iy+0)            ; FD CB 00 FF
 ld a, set 7, (iy+126)          ; FD CB 7E FF
 ld a, set 7, (iy-128)          ; FD CB 80 FF
 ld a, sla (ix)                 ; DD CB 00 27
 ld a, sla (ix+0)               ; DD CB 00 27
 ld a, sla (ix+126)             ; DD CB 7E 27
 ld a, sla (ix-128)             ; DD CB 80 27
 ld a, sla (iy)                 ; FD CB 00 27
 ld a, sla (iy+0)               ; FD CB 00 27
 ld a, sla (iy+126)             ; FD CB 7E 27
 ld a, sla (iy-128)             ; FD CB 80 27
 ld a, sli (ix)                 ; DD CB 00 37
 ld a, sli (ix+0)               ; DD CB 00 37
 ld a, sli (ix+126)             ; DD CB 7E 37
 ld a, sli (ix-128)             ; DD CB 80 37
 ld a, sli (iy)                 ; FD CB 00 37
 ld a, sli (iy+0)               ; FD CB 00 37
 ld a, sli (iy+126)             ; FD CB 7E 37
 ld a, sli (iy-128)             ; FD CB 80 37
 ld a, sll (ix)                 ; DD CB 00 37
 ld a, sll (ix+0)               ; DD CB 00 37
 ld a, sll (ix+126)             ; DD CB 7E 37
 ld a, sll (ix-128)             ; DD CB 80 37
 ld a, sll (iy)                 ; FD CB 00 37
 ld a, sll (iy+0)               ; FD CB 00 37
 ld a, sll (iy+126)             ; FD CB 7E 37
 ld a, sll (iy-128)             ; FD CB 80 37
 ld a, sls (ix)                 ; DD CB 00 37
 ld a, sls (ix+0)               ; DD CB 00 37
 ld a, sls (ix+126)             ; DD CB 7E 37
 ld a, sls (ix-128)             ; DD CB 80 37
 ld a, sls (iy)                 ; FD CB 00 37
 ld a, sls (iy+0)               ; FD CB 00 37
 ld a, sls (iy+126)             ; FD CB 7E 37
 ld a, sls (iy-128)             ; FD CB 80 37
 ld a, sra (ix)                 ; DD CB 00 2F
 ld a, sra (ix+0)               ; DD CB 00 2F
 ld a, sra (ix+126)             ; DD CB 7E 2F
 ld a, sra (ix-128)             ; DD CB 80 2F
 ld a, sra (iy)                 ; FD CB 00 2F
 ld a, sra (iy+0)               ; FD CB 00 2F
 ld a, sra (iy+126)             ; FD CB 7E 2F
 ld a, sra (iy-128)             ; FD CB 80 2F
 ld a, srl (ix)                 ; DD CB 00 3F
 ld a, srl (ix+0)               ; DD CB 00 3F
 ld a, srl (ix+126)             ; DD CB 7E 3F
 ld a, srl (ix-128)             ; DD CB 80 3F
 ld a, srl (iy)                 ; FD CB 00 3F
 ld a, srl (iy+0)               ; FD CB 00 3F
 ld a, srl (iy+126)             ; FD CB 7E 3F
 ld a, srl (iy-128)             ; FD CB 80 3F
 ld b, (de)                     ; EB 46 EB
 ld b, (de+)                    ; EB 46 EB 13
 ld b, (de-)                    ; EB 46 EB 1B
 ld b, (hl)                     ; 46
 ld b, (hl+)                    ; 46 23
 ld b, (hl-)                    ; 46 2B
 ld b, (hld)                    ; 46 2B
 ld b, (hli)                    ; 46 23
 ld b, (ix)                     ; DD 46 00
 ld b, (ix+0)                   ; DD 46 00
 ld b, (ix+126)                 ; DD 46 7E
 ld b, (ix-128)                 ; DD 46 80
 ld b, (iy)                     ; FD 46 00
 ld b, (iy+0)                   ; FD 46 00
 ld b, (iy+126)                 ; FD 46 7E
 ld b, (iy-128)                 ; FD 46 80
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
 ld b, ixh                      ; DD 44
 ld b, ixl                      ; DD 45
 ld b, iyh                      ; FD 44
 ld b, iyl                      ; FD 45
 ld b, l                        ; 45
 ld b, res 0, (ix)              ; DD CB 00 80
 ld b, res 0, (ix+0)            ; DD CB 00 80
 ld b, res 0, (ix+126)          ; DD CB 7E 80
 ld b, res 0, (ix-128)          ; DD CB 80 80
 ld b, res 0, (iy)              ; FD CB 00 80
 ld b, res 0, (iy+0)            ; FD CB 00 80
 ld b, res 0, (iy+126)          ; FD CB 7E 80
 ld b, res 0, (iy-128)          ; FD CB 80 80
 ld b, res 1, (ix)              ; DD CB 00 88
 ld b, res 1, (ix+0)            ; DD CB 00 88
 ld b, res 1, (ix+126)          ; DD CB 7E 88
 ld b, res 1, (ix-128)          ; DD CB 80 88
 ld b, res 1, (iy)              ; FD CB 00 88
 ld b, res 1, (iy+0)            ; FD CB 00 88
 ld b, res 1, (iy+126)          ; FD CB 7E 88
 ld b, res 1, (iy-128)          ; FD CB 80 88
 ld b, res 2, (ix)              ; DD CB 00 90
 ld b, res 2, (ix+0)            ; DD CB 00 90
 ld b, res 2, (ix+126)          ; DD CB 7E 90
 ld b, res 2, (ix-128)          ; DD CB 80 90
 ld b, res 2, (iy)              ; FD CB 00 90
 ld b, res 2, (iy+0)            ; FD CB 00 90
 ld b, res 2, (iy+126)          ; FD CB 7E 90
 ld b, res 2, (iy-128)          ; FD CB 80 90
 ld b, res 3, (ix)              ; DD CB 00 98
 ld b, res 3, (ix+0)            ; DD CB 00 98
 ld b, res 3, (ix+126)          ; DD CB 7E 98
 ld b, res 3, (ix-128)          ; DD CB 80 98
 ld b, res 3, (iy)              ; FD CB 00 98
 ld b, res 3, (iy+0)            ; FD CB 00 98
 ld b, res 3, (iy+126)          ; FD CB 7E 98
 ld b, res 3, (iy-128)          ; FD CB 80 98
 ld b, res 4, (ix)              ; DD CB 00 A0
 ld b, res 4, (ix+0)            ; DD CB 00 A0
 ld b, res 4, (ix+126)          ; DD CB 7E A0
 ld b, res 4, (ix-128)          ; DD CB 80 A0
 ld b, res 4, (iy)              ; FD CB 00 A0
 ld b, res 4, (iy+0)            ; FD CB 00 A0
 ld b, res 4, (iy+126)          ; FD CB 7E A0
 ld b, res 4, (iy-128)          ; FD CB 80 A0
 ld b, res 5, (ix)              ; DD CB 00 A8
 ld b, res 5, (ix+0)            ; DD CB 00 A8
 ld b, res 5, (ix+126)          ; DD CB 7E A8
 ld b, res 5, (ix-128)          ; DD CB 80 A8
 ld b, res 5, (iy)              ; FD CB 00 A8
 ld b, res 5, (iy+0)            ; FD CB 00 A8
 ld b, res 5, (iy+126)          ; FD CB 7E A8
 ld b, res 5, (iy-128)          ; FD CB 80 A8
 ld b, res 6, (ix)              ; DD CB 00 B0
 ld b, res 6, (ix+0)            ; DD CB 00 B0
 ld b, res 6, (ix+126)          ; DD CB 7E B0
 ld b, res 6, (ix-128)          ; DD CB 80 B0
 ld b, res 6, (iy)              ; FD CB 00 B0
 ld b, res 6, (iy+0)            ; FD CB 00 B0
 ld b, res 6, (iy+126)          ; FD CB 7E B0
 ld b, res 6, (iy-128)          ; FD CB 80 B0
 ld b, res 7, (ix)              ; DD CB 00 B8
 ld b, res 7, (ix+0)            ; DD CB 00 B8
 ld b, res 7, (ix+126)          ; DD CB 7E B8
 ld b, res 7, (ix-128)          ; DD CB 80 B8
 ld b, res 7, (iy)              ; FD CB 00 B8
 ld b, res 7, (iy+0)            ; FD CB 00 B8
 ld b, res 7, (iy+126)          ; FD CB 7E B8
 ld b, res 7, (iy-128)          ; FD CB 80 B8
 ld b, rl (ix)                  ; DD CB 00 10
 ld b, rl (ix+0)                ; DD CB 00 10
 ld b, rl (ix+126)              ; DD CB 7E 10
 ld b, rl (ix-128)              ; DD CB 80 10
 ld b, rl (iy)                  ; FD CB 00 10
 ld b, rl (iy+0)                ; FD CB 00 10
 ld b, rl (iy+126)              ; FD CB 7E 10
 ld b, rl (iy-128)              ; FD CB 80 10
 ld b, rlc (ix)                 ; DD CB 00 00
 ld b, rlc (ix+0)               ; DD CB 00 00
 ld b, rlc (ix+126)             ; DD CB 7E 00
 ld b, rlc (ix-128)             ; DD CB 80 00
 ld b, rlc (iy)                 ; FD CB 00 00
 ld b, rlc (iy+0)               ; FD CB 00 00
 ld b, rlc (iy+126)             ; FD CB 7E 00
 ld b, rlc (iy-128)             ; FD CB 80 00
 ld b, rr (ix)                  ; DD CB 00 18
 ld b, rr (ix+0)                ; DD CB 00 18
 ld b, rr (ix+126)              ; DD CB 7E 18
 ld b, rr (ix-128)              ; DD CB 80 18
 ld b, rr (iy)                  ; FD CB 00 18
 ld b, rr (iy+0)                ; FD CB 00 18
 ld b, rr (iy+126)              ; FD CB 7E 18
 ld b, rr (iy-128)              ; FD CB 80 18
 ld b, rrc (ix)                 ; DD CB 00 08
 ld b, rrc (ix+0)               ; DD CB 00 08
 ld b, rrc (ix+126)             ; DD CB 7E 08
 ld b, rrc (ix-128)             ; DD CB 80 08
 ld b, rrc (iy)                 ; FD CB 00 08
 ld b, rrc (iy+0)               ; FD CB 00 08
 ld b, rrc (iy+126)             ; FD CB 7E 08
 ld b, rrc (iy-128)             ; FD CB 80 08
 ld b, set 0, (ix)              ; DD CB 00 C0
 ld b, set 0, (ix+0)            ; DD CB 00 C0
 ld b, set 0, (ix+126)          ; DD CB 7E C0
 ld b, set 0, (ix-128)          ; DD CB 80 C0
 ld b, set 0, (iy)              ; FD CB 00 C0
 ld b, set 0, (iy+0)            ; FD CB 00 C0
 ld b, set 0, (iy+126)          ; FD CB 7E C0
 ld b, set 0, (iy-128)          ; FD CB 80 C0
 ld b, set 1, (ix)              ; DD CB 00 C8
 ld b, set 1, (ix+0)            ; DD CB 00 C8
 ld b, set 1, (ix+126)          ; DD CB 7E C8
 ld b, set 1, (ix-128)          ; DD CB 80 C8
 ld b, set 1, (iy)              ; FD CB 00 C8
 ld b, set 1, (iy+0)            ; FD CB 00 C8
 ld b, set 1, (iy+126)          ; FD CB 7E C8
 ld b, set 1, (iy-128)          ; FD CB 80 C8
 ld b, set 2, (ix)              ; DD CB 00 D0
 ld b, set 2, (ix+0)            ; DD CB 00 D0
 ld b, set 2, (ix+126)          ; DD CB 7E D0
 ld b, set 2, (ix-128)          ; DD CB 80 D0
 ld b, set 2, (iy)              ; FD CB 00 D0
 ld b, set 2, (iy+0)            ; FD CB 00 D0
 ld b, set 2, (iy+126)          ; FD CB 7E D0
 ld b, set 2, (iy-128)          ; FD CB 80 D0
 ld b, set 3, (ix)              ; DD CB 00 D8
 ld b, set 3, (ix+0)            ; DD CB 00 D8
 ld b, set 3, (ix+126)          ; DD CB 7E D8
 ld b, set 3, (ix-128)          ; DD CB 80 D8
 ld b, set 3, (iy)              ; FD CB 00 D8
 ld b, set 3, (iy+0)            ; FD CB 00 D8
 ld b, set 3, (iy+126)          ; FD CB 7E D8
 ld b, set 3, (iy-128)          ; FD CB 80 D8
 ld b, set 4, (ix)              ; DD CB 00 E0
 ld b, set 4, (ix+0)            ; DD CB 00 E0
 ld b, set 4, (ix+126)          ; DD CB 7E E0
 ld b, set 4, (ix-128)          ; DD CB 80 E0
 ld b, set 4, (iy)              ; FD CB 00 E0
 ld b, set 4, (iy+0)            ; FD CB 00 E0
 ld b, set 4, (iy+126)          ; FD CB 7E E0
 ld b, set 4, (iy-128)          ; FD CB 80 E0
 ld b, set 5, (ix)              ; DD CB 00 E8
 ld b, set 5, (ix+0)            ; DD CB 00 E8
 ld b, set 5, (ix+126)          ; DD CB 7E E8
 ld b, set 5, (ix-128)          ; DD CB 80 E8
 ld b, set 5, (iy)              ; FD CB 00 E8
 ld b, set 5, (iy+0)            ; FD CB 00 E8
 ld b, set 5, (iy+126)          ; FD CB 7E E8
 ld b, set 5, (iy-128)          ; FD CB 80 E8
 ld b, set 6, (ix)              ; DD CB 00 F0
 ld b, set 6, (ix+0)            ; DD CB 00 F0
 ld b, set 6, (ix+126)          ; DD CB 7E F0
 ld b, set 6, (ix-128)          ; DD CB 80 F0
 ld b, set 6, (iy)              ; FD CB 00 F0
 ld b, set 6, (iy+0)            ; FD CB 00 F0
 ld b, set 6, (iy+126)          ; FD CB 7E F0
 ld b, set 6, (iy-128)          ; FD CB 80 F0
 ld b, set 7, (ix)              ; DD CB 00 F8
 ld b, set 7, (ix+0)            ; DD CB 00 F8
 ld b, set 7, (ix+126)          ; DD CB 7E F8
 ld b, set 7, (ix-128)          ; DD CB 80 F8
 ld b, set 7, (iy)              ; FD CB 00 F8
 ld b, set 7, (iy+0)            ; FD CB 00 F8
 ld b, set 7, (iy+126)          ; FD CB 7E F8
 ld b, set 7, (iy-128)          ; FD CB 80 F8
 ld b, sla (ix)                 ; DD CB 00 20
 ld b, sla (ix+0)               ; DD CB 00 20
 ld b, sla (ix+126)             ; DD CB 7E 20
 ld b, sla (ix-128)             ; DD CB 80 20
 ld b, sla (iy)                 ; FD CB 00 20
 ld b, sla (iy+0)               ; FD CB 00 20
 ld b, sla (iy+126)             ; FD CB 7E 20
 ld b, sla (iy-128)             ; FD CB 80 20
 ld b, sli (ix)                 ; DD CB 00 30
 ld b, sli (ix+0)               ; DD CB 00 30
 ld b, sli (ix+126)             ; DD CB 7E 30
 ld b, sli (ix-128)             ; DD CB 80 30
 ld b, sli (iy)                 ; FD CB 00 30
 ld b, sli (iy+0)               ; FD CB 00 30
 ld b, sli (iy+126)             ; FD CB 7E 30
 ld b, sli (iy-128)             ; FD CB 80 30
 ld b, sll (ix)                 ; DD CB 00 30
 ld b, sll (ix+0)               ; DD CB 00 30
 ld b, sll (ix+126)             ; DD CB 7E 30
 ld b, sll (ix-128)             ; DD CB 80 30
 ld b, sll (iy)                 ; FD CB 00 30
 ld b, sll (iy+0)               ; FD CB 00 30
 ld b, sll (iy+126)             ; FD CB 7E 30
 ld b, sll (iy-128)             ; FD CB 80 30
 ld b, sls (ix)                 ; DD CB 00 30
 ld b, sls (ix+0)               ; DD CB 00 30
 ld b, sls (ix+126)             ; DD CB 7E 30
 ld b, sls (ix-128)             ; DD CB 80 30
 ld b, sls (iy)                 ; FD CB 00 30
 ld b, sls (iy+0)               ; FD CB 00 30
 ld b, sls (iy+126)             ; FD CB 7E 30
 ld b, sls (iy-128)             ; FD CB 80 30
 ld b, sra (ix)                 ; DD CB 00 28
 ld b, sra (ix+0)               ; DD CB 00 28
 ld b, sra (ix+126)             ; DD CB 7E 28
 ld b, sra (ix-128)             ; DD CB 80 28
 ld b, sra (iy)                 ; FD CB 00 28
 ld b, sra (iy+0)               ; FD CB 00 28
 ld b, sra (iy+126)             ; FD CB 7E 28
 ld b, sra (iy-128)             ; FD CB 80 28
 ld b, srl (ix)                 ; DD CB 00 38
 ld b, srl (ix+0)               ; DD CB 00 38
 ld b, srl (ix+126)             ; DD CB 7E 38
 ld b, srl (ix-128)             ; DD CB 80 38
 ld b, srl (iy)                 ; FD CB 00 38
 ld b, srl (iy+0)               ; FD CB 00 38
 ld b, srl (iy+126)             ; FD CB 7E 38
 ld b, srl (iy-128)             ; FD CB 80 38
 ld bc, (0x1234)                ; ED 4B 34 12
 ld bc, (hl)                    ; 4E 23 46 2B
 ld bc, (hl+)                   ; 4E 23 46 23
 ld bc, (ix)                    ; DD 4E 00 DD 46 01
 ld bc, (ix+0)                  ; DD 4E 00 DD 46 01
 ld bc, (ix+126)                ; DD 4E 7E DD 46 7F
 ld bc, (ix-128)                ; DD 4E 80 DD 46 81
 ld bc, (iy)                    ; FD 4E 00 FD 46 01
 ld bc, (iy+0)                  ; FD 4E 00 FD 46 01
 ld bc, (iy+126)                ; FD 4E 7E FD 46 7F
 ld bc, (iy-128)                ; FD 4E 80 FD 46 81
 ld bc, 0x1234                  ; 01 34 12
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
 ld c, (ix+0)                   ; DD 4E 00
 ld c, (ix+126)                 ; DD 4E 7E
 ld c, (ix-128)                 ; DD 4E 80
 ld c, (iy)                     ; FD 4E 00
 ld c, (iy+0)                   ; FD 4E 00
 ld c, (iy+126)                 ; FD 4E 7E
 ld c, (iy-128)                 ; FD 4E 80
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
 ld c, ixh                      ; DD 4C
 ld c, ixl                      ; DD 4D
 ld c, iyh                      ; FD 4C
 ld c, iyl                      ; FD 4D
 ld c, l                        ; 4D
 ld c, res 0, (ix)              ; DD CB 00 81
 ld c, res 0, (ix+0)            ; DD CB 00 81
 ld c, res 0, (ix+126)          ; DD CB 7E 81
 ld c, res 0, (ix-128)          ; DD CB 80 81
 ld c, res 0, (iy)              ; FD CB 00 81
 ld c, res 0, (iy+0)            ; FD CB 00 81
 ld c, res 0, (iy+126)          ; FD CB 7E 81
 ld c, res 0, (iy-128)          ; FD CB 80 81
 ld c, res 1, (ix)              ; DD CB 00 89
 ld c, res 1, (ix+0)            ; DD CB 00 89
 ld c, res 1, (ix+126)          ; DD CB 7E 89
 ld c, res 1, (ix-128)          ; DD CB 80 89
 ld c, res 1, (iy)              ; FD CB 00 89
 ld c, res 1, (iy+0)            ; FD CB 00 89
 ld c, res 1, (iy+126)          ; FD CB 7E 89
 ld c, res 1, (iy-128)          ; FD CB 80 89
 ld c, res 2, (ix)              ; DD CB 00 91
 ld c, res 2, (ix+0)            ; DD CB 00 91
 ld c, res 2, (ix+126)          ; DD CB 7E 91
 ld c, res 2, (ix-128)          ; DD CB 80 91
 ld c, res 2, (iy)              ; FD CB 00 91
 ld c, res 2, (iy+0)            ; FD CB 00 91
 ld c, res 2, (iy+126)          ; FD CB 7E 91
 ld c, res 2, (iy-128)          ; FD CB 80 91
 ld c, res 3, (ix)              ; DD CB 00 99
 ld c, res 3, (ix+0)            ; DD CB 00 99
 ld c, res 3, (ix+126)          ; DD CB 7E 99
 ld c, res 3, (ix-128)          ; DD CB 80 99
 ld c, res 3, (iy)              ; FD CB 00 99
 ld c, res 3, (iy+0)            ; FD CB 00 99
 ld c, res 3, (iy+126)          ; FD CB 7E 99
 ld c, res 3, (iy-128)          ; FD CB 80 99
 ld c, res 4, (ix)              ; DD CB 00 A1
 ld c, res 4, (ix+0)            ; DD CB 00 A1
 ld c, res 4, (ix+126)          ; DD CB 7E A1
 ld c, res 4, (ix-128)          ; DD CB 80 A1
 ld c, res 4, (iy)              ; FD CB 00 A1
 ld c, res 4, (iy+0)            ; FD CB 00 A1
 ld c, res 4, (iy+126)          ; FD CB 7E A1
 ld c, res 4, (iy-128)          ; FD CB 80 A1
 ld c, res 5, (ix)              ; DD CB 00 A9
 ld c, res 5, (ix+0)            ; DD CB 00 A9
 ld c, res 5, (ix+126)          ; DD CB 7E A9
 ld c, res 5, (ix-128)          ; DD CB 80 A9
 ld c, res 5, (iy)              ; FD CB 00 A9
 ld c, res 5, (iy+0)            ; FD CB 00 A9
 ld c, res 5, (iy+126)          ; FD CB 7E A9
 ld c, res 5, (iy-128)          ; FD CB 80 A9
 ld c, res 6, (ix)              ; DD CB 00 B1
 ld c, res 6, (ix+0)            ; DD CB 00 B1
 ld c, res 6, (ix+126)          ; DD CB 7E B1
 ld c, res 6, (ix-128)          ; DD CB 80 B1
 ld c, res 6, (iy)              ; FD CB 00 B1
 ld c, res 6, (iy+0)            ; FD CB 00 B1
 ld c, res 6, (iy+126)          ; FD CB 7E B1
 ld c, res 6, (iy-128)          ; FD CB 80 B1
 ld c, res 7, (ix)              ; DD CB 00 B9
 ld c, res 7, (ix+0)            ; DD CB 00 B9
 ld c, res 7, (ix+126)          ; DD CB 7E B9
 ld c, res 7, (ix-128)          ; DD CB 80 B9
 ld c, res 7, (iy)              ; FD CB 00 B9
 ld c, res 7, (iy+0)            ; FD CB 00 B9
 ld c, res 7, (iy+126)          ; FD CB 7E B9
 ld c, res 7, (iy-128)          ; FD CB 80 B9
 ld c, rl (ix)                  ; DD CB 00 11
 ld c, rl (ix+0)                ; DD CB 00 11
 ld c, rl (ix+126)              ; DD CB 7E 11
 ld c, rl (ix-128)              ; DD CB 80 11
 ld c, rl (iy)                  ; FD CB 00 11
 ld c, rl (iy+0)                ; FD CB 00 11
 ld c, rl (iy+126)              ; FD CB 7E 11
 ld c, rl (iy-128)              ; FD CB 80 11
 ld c, rlc (ix)                 ; DD CB 00 01
 ld c, rlc (ix+0)               ; DD CB 00 01
 ld c, rlc (ix+126)             ; DD CB 7E 01
 ld c, rlc (ix-128)             ; DD CB 80 01
 ld c, rlc (iy)                 ; FD CB 00 01
 ld c, rlc (iy+0)               ; FD CB 00 01
 ld c, rlc (iy+126)             ; FD CB 7E 01
 ld c, rlc (iy-128)             ; FD CB 80 01
 ld c, rr (ix)                  ; DD CB 00 19
 ld c, rr (ix+0)                ; DD CB 00 19
 ld c, rr (ix+126)              ; DD CB 7E 19
 ld c, rr (ix-128)              ; DD CB 80 19
 ld c, rr (iy)                  ; FD CB 00 19
 ld c, rr (iy+0)                ; FD CB 00 19
 ld c, rr (iy+126)              ; FD CB 7E 19
 ld c, rr (iy-128)              ; FD CB 80 19
 ld c, rrc (ix)                 ; DD CB 00 09
 ld c, rrc (ix+0)               ; DD CB 00 09
 ld c, rrc (ix+126)             ; DD CB 7E 09
 ld c, rrc (ix-128)             ; DD CB 80 09
 ld c, rrc (iy)                 ; FD CB 00 09
 ld c, rrc (iy+0)               ; FD CB 00 09
 ld c, rrc (iy+126)             ; FD CB 7E 09
 ld c, rrc (iy-128)             ; FD CB 80 09
 ld c, set 0, (ix)              ; DD CB 00 C1
 ld c, set 0, (ix+0)            ; DD CB 00 C1
 ld c, set 0, (ix+126)          ; DD CB 7E C1
 ld c, set 0, (ix-128)          ; DD CB 80 C1
 ld c, set 0, (iy)              ; FD CB 00 C1
 ld c, set 0, (iy+0)            ; FD CB 00 C1
 ld c, set 0, (iy+126)          ; FD CB 7E C1
 ld c, set 0, (iy-128)          ; FD CB 80 C1
 ld c, set 1, (ix)              ; DD CB 00 C9
 ld c, set 1, (ix+0)            ; DD CB 00 C9
 ld c, set 1, (ix+126)          ; DD CB 7E C9
 ld c, set 1, (ix-128)          ; DD CB 80 C9
 ld c, set 1, (iy)              ; FD CB 00 C9
 ld c, set 1, (iy+0)            ; FD CB 00 C9
 ld c, set 1, (iy+126)          ; FD CB 7E C9
 ld c, set 1, (iy-128)          ; FD CB 80 C9
 ld c, set 2, (ix)              ; DD CB 00 D1
 ld c, set 2, (ix+0)            ; DD CB 00 D1
 ld c, set 2, (ix+126)          ; DD CB 7E D1
 ld c, set 2, (ix-128)          ; DD CB 80 D1
 ld c, set 2, (iy)              ; FD CB 00 D1
 ld c, set 2, (iy+0)            ; FD CB 00 D1
 ld c, set 2, (iy+126)          ; FD CB 7E D1
 ld c, set 2, (iy-128)          ; FD CB 80 D1
 ld c, set 3, (ix)              ; DD CB 00 D9
 ld c, set 3, (ix+0)            ; DD CB 00 D9
 ld c, set 3, (ix+126)          ; DD CB 7E D9
 ld c, set 3, (ix-128)          ; DD CB 80 D9
 ld c, set 3, (iy)              ; FD CB 00 D9
 ld c, set 3, (iy+0)            ; FD CB 00 D9
 ld c, set 3, (iy+126)          ; FD CB 7E D9
 ld c, set 3, (iy-128)          ; FD CB 80 D9
 ld c, set 4, (ix)              ; DD CB 00 E1
 ld c, set 4, (ix+0)            ; DD CB 00 E1
 ld c, set 4, (ix+126)          ; DD CB 7E E1
 ld c, set 4, (ix-128)          ; DD CB 80 E1
 ld c, set 4, (iy)              ; FD CB 00 E1
 ld c, set 4, (iy+0)            ; FD CB 00 E1
 ld c, set 4, (iy+126)          ; FD CB 7E E1
 ld c, set 4, (iy-128)          ; FD CB 80 E1
 ld c, set 5, (ix)              ; DD CB 00 E9
 ld c, set 5, (ix+0)            ; DD CB 00 E9
 ld c, set 5, (ix+126)          ; DD CB 7E E9
 ld c, set 5, (ix-128)          ; DD CB 80 E9
 ld c, set 5, (iy)              ; FD CB 00 E9
 ld c, set 5, (iy+0)            ; FD CB 00 E9
 ld c, set 5, (iy+126)          ; FD CB 7E E9
 ld c, set 5, (iy-128)          ; FD CB 80 E9
 ld c, set 6, (ix)              ; DD CB 00 F1
 ld c, set 6, (ix+0)            ; DD CB 00 F1
 ld c, set 6, (ix+126)          ; DD CB 7E F1
 ld c, set 6, (ix-128)          ; DD CB 80 F1
 ld c, set 6, (iy)              ; FD CB 00 F1
 ld c, set 6, (iy+0)            ; FD CB 00 F1
 ld c, set 6, (iy+126)          ; FD CB 7E F1
 ld c, set 6, (iy-128)          ; FD CB 80 F1
 ld c, set 7, (ix)              ; DD CB 00 F9
 ld c, set 7, (ix+0)            ; DD CB 00 F9
 ld c, set 7, (ix+126)          ; DD CB 7E F9
 ld c, set 7, (ix-128)          ; DD CB 80 F9
 ld c, set 7, (iy)              ; FD CB 00 F9
 ld c, set 7, (iy+0)            ; FD CB 00 F9
 ld c, set 7, (iy+126)          ; FD CB 7E F9
 ld c, set 7, (iy-128)          ; FD CB 80 F9
 ld c, sla (ix)                 ; DD CB 00 21
 ld c, sla (ix+0)               ; DD CB 00 21
 ld c, sla (ix+126)             ; DD CB 7E 21
 ld c, sla (ix-128)             ; DD CB 80 21
 ld c, sla (iy)                 ; FD CB 00 21
 ld c, sla (iy+0)               ; FD CB 00 21
 ld c, sla (iy+126)             ; FD CB 7E 21
 ld c, sla (iy-128)             ; FD CB 80 21
 ld c, sli (ix)                 ; DD CB 00 31
 ld c, sli (ix+0)               ; DD CB 00 31
 ld c, sli (ix+126)             ; DD CB 7E 31
 ld c, sli (ix-128)             ; DD CB 80 31
 ld c, sli (iy)                 ; FD CB 00 31
 ld c, sli (iy+0)               ; FD CB 00 31
 ld c, sli (iy+126)             ; FD CB 7E 31
 ld c, sli (iy-128)             ; FD CB 80 31
 ld c, sll (ix)                 ; DD CB 00 31
 ld c, sll (ix+0)               ; DD CB 00 31
 ld c, sll (ix+126)             ; DD CB 7E 31
 ld c, sll (ix-128)             ; DD CB 80 31
 ld c, sll (iy)                 ; FD CB 00 31
 ld c, sll (iy+0)               ; FD CB 00 31
 ld c, sll (iy+126)             ; FD CB 7E 31
 ld c, sll (iy-128)             ; FD CB 80 31
 ld c, sls (ix)                 ; DD CB 00 31
 ld c, sls (ix+0)               ; DD CB 00 31
 ld c, sls (ix+126)             ; DD CB 7E 31
 ld c, sls (ix-128)             ; DD CB 80 31
 ld c, sls (iy)                 ; FD CB 00 31
 ld c, sls (iy+0)               ; FD CB 00 31
 ld c, sls (iy+126)             ; FD CB 7E 31
 ld c, sls (iy-128)             ; FD CB 80 31
 ld c, sra (ix)                 ; DD CB 00 29
 ld c, sra (ix+0)               ; DD CB 00 29
 ld c, sra (ix+126)             ; DD CB 7E 29
 ld c, sra (ix-128)             ; DD CB 80 29
 ld c, sra (iy)                 ; FD CB 00 29
 ld c, sra (iy+0)               ; FD CB 00 29
 ld c, sra (iy+126)             ; FD CB 7E 29
 ld c, sra (iy-128)             ; FD CB 80 29
 ld c, srl (ix)                 ; DD CB 00 39
 ld c, srl (ix+0)               ; DD CB 00 39
 ld c, srl (ix+126)             ; DD CB 7E 39
 ld c, srl (ix-128)             ; DD CB 80 39
 ld c, srl (iy)                 ; FD CB 00 39
 ld c, srl (iy+0)               ; FD CB 00 39
 ld c, srl (iy+126)             ; FD CB 7E 39
 ld c, srl (iy-128)             ; FD CB 80 39
 ld d, (de)                     ; EB 66 EB
 ld d, (de+)                    ; EB 66 EB 13
 ld d, (de-)                    ; EB 66 EB 1B
 ld d, (hl)                     ; 56
 ld d, (hl+)                    ; 56 23
 ld d, (hl-)                    ; 56 2B
 ld d, (hld)                    ; 56 2B
 ld d, (hli)                    ; 56 23
 ld d, (ix)                     ; DD 56 00
 ld d, (ix+0)                   ; DD 56 00
 ld d, (ix+126)                 ; DD 56 7E
 ld d, (ix-128)                 ; DD 56 80
 ld d, (iy)                     ; FD 56 00
 ld d, (iy+0)                   ; FD 56 00
 ld d, (iy+126)                 ; FD 56 7E
 ld d, (iy-128)                 ; FD 56 80
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
 ld d, ixh                      ; DD 54
 ld d, ixl                      ; DD 55
 ld d, iyh                      ; FD 54
 ld d, iyl                      ; FD 55
 ld d, l                        ; 55
 ld d, res 0, (ix)              ; DD CB 00 82
 ld d, res 0, (ix+0)            ; DD CB 00 82
 ld d, res 0, (ix+126)          ; DD CB 7E 82
 ld d, res 0, (ix-128)          ; DD CB 80 82
 ld d, res 0, (iy)              ; FD CB 00 82
 ld d, res 0, (iy+0)            ; FD CB 00 82
 ld d, res 0, (iy+126)          ; FD CB 7E 82
 ld d, res 0, (iy-128)          ; FD CB 80 82
 ld d, res 1, (ix)              ; DD CB 00 8A
 ld d, res 1, (ix+0)            ; DD CB 00 8A
 ld d, res 1, (ix+126)          ; DD CB 7E 8A
 ld d, res 1, (ix-128)          ; DD CB 80 8A
 ld d, res 1, (iy)              ; FD CB 00 8A
 ld d, res 1, (iy+0)            ; FD CB 00 8A
 ld d, res 1, (iy+126)          ; FD CB 7E 8A
 ld d, res 1, (iy-128)          ; FD CB 80 8A
 ld d, res 2, (ix)              ; DD CB 00 92
 ld d, res 2, (ix+0)            ; DD CB 00 92
 ld d, res 2, (ix+126)          ; DD CB 7E 92
 ld d, res 2, (ix-128)          ; DD CB 80 92
 ld d, res 2, (iy)              ; FD CB 00 92
 ld d, res 2, (iy+0)            ; FD CB 00 92
 ld d, res 2, (iy+126)          ; FD CB 7E 92
 ld d, res 2, (iy-128)          ; FD CB 80 92
 ld d, res 3, (ix)              ; DD CB 00 9A
 ld d, res 3, (ix+0)            ; DD CB 00 9A
 ld d, res 3, (ix+126)          ; DD CB 7E 9A
 ld d, res 3, (ix-128)          ; DD CB 80 9A
 ld d, res 3, (iy)              ; FD CB 00 9A
 ld d, res 3, (iy+0)            ; FD CB 00 9A
 ld d, res 3, (iy+126)          ; FD CB 7E 9A
 ld d, res 3, (iy-128)          ; FD CB 80 9A
 ld d, res 4, (ix)              ; DD CB 00 A2
 ld d, res 4, (ix+0)            ; DD CB 00 A2
 ld d, res 4, (ix+126)          ; DD CB 7E A2
 ld d, res 4, (ix-128)          ; DD CB 80 A2
 ld d, res 4, (iy)              ; FD CB 00 A2
 ld d, res 4, (iy+0)            ; FD CB 00 A2
 ld d, res 4, (iy+126)          ; FD CB 7E A2
 ld d, res 4, (iy-128)          ; FD CB 80 A2
 ld d, res 5, (ix)              ; DD CB 00 AA
 ld d, res 5, (ix+0)            ; DD CB 00 AA
 ld d, res 5, (ix+126)          ; DD CB 7E AA
 ld d, res 5, (ix-128)          ; DD CB 80 AA
 ld d, res 5, (iy)              ; FD CB 00 AA
 ld d, res 5, (iy+0)            ; FD CB 00 AA
 ld d, res 5, (iy+126)          ; FD CB 7E AA
 ld d, res 5, (iy-128)          ; FD CB 80 AA
 ld d, res 6, (ix)              ; DD CB 00 B2
 ld d, res 6, (ix+0)            ; DD CB 00 B2
 ld d, res 6, (ix+126)          ; DD CB 7E B2
 ld d, res 6, (ix-128)          ; DD CB 80 B2
 ld d, res 6, (iy)              ; FD CB 00 B2
 ld d, res 6, (iy+0)            ; FD CB 00 B2
 ld d, res 6, (iy+126)          ; FD CB 7E B2
 ld d, res 6, (iy-128)          ; FD CB 80 B2
 ld d, res 7, (ix)              ; DD CB 00 BA
 ld d, res 7, (ix+0)            ; DD CB 00 BA
 ld d, res 7, (ix+126)          ; DD CB 7E BA
 ld d, res 7, (ix-128)          ; DD CB 80 BA
 ld d, res 7, (iy)              ; FD CB 00 BA
 ld d, res 7, (iy+0)            ; FD CB 00 BA
 ld d, res 7, (iy+126)          ; FD CB 7E BA
 ld d, res 7, (iy-128)          ; FD CB 80 BA
 ld d, rl (ix)                  ; DD CB 00 12
 ld d, rl (ix+0)                ; DD CB 00 12
 ld d, rl (ix+126)              ; DD CB 7E 12
 ld d, rl (ix-128)              ; DD CB 80 12
 ld d, rl (iy)                  ; FD CB 00 12
 ld d, rl (iy+0)                ; FD CB 00 12
 ld d, rl (iy+126)              ; FD CB 7E 12
 ld d, rl (iy-128)              ; FD CB 80 12
 ld d, rlc (ix)                 ; DD CB 00 02
 ld d, rlc (ix+0)               ; DD CB 00 02
 ld d, rlc (ix+126)             ; DD CB 7E 02
 ld d, rlc (ix-128)             ; DD CB 80 02
 ld d, rlc (iy)                 ; FD CB 00 02
 ld d, rlc (iy+0)               ; FD CB 00 02
 ld d, rlc (iy+126)             ; FD CB 7E 02
 ld d, rlc (iy-128)             ; FD CB 80 02
 ld d, rr (ix)                  ; DD CB 00 1A
 ld d, rr (ix+0)                ; DD CB 00 1A
 ld d, rr (ix+126)              ; DD CB 7E 1A
 ld d, rr (ix-128)              ; DD CB 80 1A
 ld d, rr (iy)                  ; FD CB 00 1A
 ld d, rr (iy+0)                ; FD CB 00 1A
 ld d, rr (iy+126)              ; FD CB 7E 1A
 ld d, rr (iy-128)              ; FD CB 80 1A
 ld d, rrc (ix)                 ; DD CB 00 0A
 ld d, rrc (ix+0)               ; DD CB 00 0A
 ld d, rrc (ix+126)             ; DD CB 7E 0A
 ld d, rrc (ix-128)             ; DD CB 80 0A
 ld d, rrc (iy)                 ; FD CB 00 0A
 ld d, rrc (iy+0)               ; FD CB 00 0A
 ld d, rrc (iy+126)             ; FD CB 7E 0A
 ld d, rrc (iy-128)             ; FD CB 80 0A
 ld d, set 0, (ix)              ; DD CB 00 C2
 ld d, set 0, (ix+0)            ; DD CB 00 C2
 ld d, set 0, (ix+126)          ; DD CB 7E C2
 ld d, set 0, (ix-128)          ; DD CB 80 C2
 ld d, set 0, (iy)              ; FD CB 00 C2
 ld d, set 0, (iy+0)            ; FD CB 00 C2
 ld d, set 0, (iy+126)          ; FD CB 7E C2
 ld d, set 0, (iy-128)          ; FD CB 80 C2
 ld d, set 1, (ix)              ; DD CB 00 CA
 ld d, set 1, (ix+0)            ; DD CB 00 CA
 ld d, set 1, (ix+126)          ; DD CB 7E CA
 ld d, set 1, (ix-128)          ; DD CB 80 CA
 ld d, set 1, (iy)              ; FD CB 00 CA
 ld d, set 1, (iy+0)            ; FD CB 00 CA
 ld d, set 1, (iy+126)          ; FD CB 7E CA
 ld d, set 1, (iy-128)          ; FD CB 80 CA
 ld d, set 2, (ix)              ; DD CB 00 D2
 ld d, set 2, (ix+0)            ; DD CB 00 D2
 ld d, set 2, (ix+126)          ; DD CB 7E D2
 ld d, set 2, (ix-128)          ; DD CB 80 D2
 ld d, set 2, (iy)              ; FD CB 00 D2
 ld d, set 2, (iy+0)            ; FD CB 00 D2
 ld d, set 2, (iy+126)          ; FD CB 7E D2
 ld d, set 2, (iy-128)          ; FD CB 80 D2
 ld d, set 3, (ix)              ; DD CB 00 DA
 ld d, set 3, (ix+0)            ; DD CB 00 DA
 ld d, set 3, (ix+126)          ; DD CB 7E DA
 ld d, set 3, (ix-128)          ; DD CB 80 DA
 ld d, set 3, (iy)              ; FD CB 00 DA
 ld d, set 3, (iy+0)            ; FD CB 00 DA
 ld d, set 3, (iy+126)          ; FD CB 7E DA
 ld d, set 3, (iy-128)          ; FD CB 80 DA
 ld d, set 4, (ix)              ; DD CB 00 E2
 ld d, set 4, (ix+0)            ; DD CB 00 E2
 ld d, set 4, (ix+126)          ; DD CB 7E E2
 ld d, set 4, (ix-128)          ; DD CB 80 E2
 ld d, set 4, (iy)              ; FD CB 00 E2
 ld d, set 4, (iy+0)            ; FD CB 00 E2
 ld d, set 4, (iy+126)          ; FD CB 7E E2
 ld d, set 4, (iy-128)          ; FD CB 80 E2
 ld d, set 5, (ix)              ; DD CB 00 EA
 ld d, set 5, (ix+0)            ; DD CB 00 EA
 ld d, set 5, (ix+126)          ; DD CB 7E EA
 ld d, set 5, (ix-128)          ; DD CB 80 EA
 ld d, set 5, (iy)              ; FD CB 00 EA
 ld d, set 5, (iy+0)            ; FD CB 00 EA
 ld d, set 5, (iy+126)          ; FD CB 7E EA
 ld d, set 5, (iy-128)          ; FD CB 80 EA
 ld d, set 6, (ix)              ; DD CB 00 F2
 ld d, set 6, (ix+0)            ; DD CB 00 F2
 ld d, set 6, (ix+126)          ; DD CB 7E F2
 ld d, set 6, (ix-128)          ; DD CB 80 F2
 ld d, set 6, (iy)              ; FD CB 00 F2
 ld d, set 6, (iy+0)            ; FD CB 00 F2
 ld d, set 6, (iy+126)          ; FD CB 7E F2
 ld d, set 6, (iy-128)          ; FD CB 80 F2
 ld d, set 7, (ix)              ; DD CB 00 FA
 ld d, set 7, (ix+0)            ; DD CB 00 FA
 ld d, set 7, (ix+126)          ; DD CB 7E FA
 ld d, set 7, (ix-128)          ; DD CB 80 FA
 ld d, set 7, (iy)              ; FD CB 00 FA
 ld d, set 7, (iy+0)            ; FD CB 00 FA
 ld d, set 7, (iy+126)          ; FD CB 7E FA
 ld d, set 7, (iy-128)          ; FD CB 80 FA
 ld d, sla (ix)                 ; DD CB 00 22
 ld d, sla (ix+0)               ; DD CB 00 22
 ld d, sla (ix+126)             ; DD CB 7E 22
 ld d, sla (ix-128)             ; DD CB 80 22
 ld d, sla (iy)                 ; FD CB 00 22
 ld d, sla (iy+0)               ; FD CB 00 22
 ld d, sla (iy+126)             ; FD CB 7E 22
 ld d, sla (iy-128)             ; FD CB 80 22
 ld d, sli (ix)                 ; DD CB 00 32
 ld d, sli (ix+0)               ; DD CB 00 32
 ld d, sli (ix+126)             ; DD CB 7E 32
 ld d, sli (ix-128)             ; DD CB 80 32
 ld d, sli (iy)                 ; FD CB 00 32
 ld d, sli (iy+0)               ; FD CB 00 32
 ld d, sli (iy+126)             ; FD CB 7E 32
 ld d, sli (iy-128)             ; FD CB 80 32
 ld d, sll (ix)                 ; DD CB 00 32
 ld d, sll (ix+0)               ; DD CB 00 32
 ld d, sll (ix+126)             ; DD CB 7E 32
 ld d, sll (ix-128)             ; DD CB 80 32
 ld d, sll (iy)                 ; FD CB 00 32
 ld d, sll (iy+0)               ; FD CB 00 32
 ld d, sll (iy+126)             ; FD CB 7E 32
 ld d, sll (iy-128)             ; FD CB 80 32
 ld d, sls (ix)                 ; DD CB 00 32
 ld d, sls (ix+0)               ; DD CB 00 32
 ld d, sls (ix+126)             ; DD CB 7E 32
 ld d, sls (ix-128)             ; DD CB 80 32
 ld d, sls (iy)                 ; FD CB 00 32
 ld d, sls (iy+0)               ; FD CB 00 32
 ld d, sls (iy+126)             ; FD CB 7E 32
 ld d, sls (iy-128)             ; FD CB 80 32
 ld d, sra (ix)                 ; DD CB 00 2A
 ld d, sra (ix+0)               ; DD CB 00 2A
 ld d, sra (ix+126)             ; DD CB 7E 2A
 ld d, sra (ix-128)             ; DD CB 80 2A
 ld d, sra (iy)                 ; FD CB 00 2A
 ld d, sra (iy+0)               ; FD CB 00 2A
 ld d, sra (iy+126)             ; FD CB 7E 2A
 ld d, sra (iy-128)             ; FD CB 80 2A
 ld d, srl (ix)                 ; DD CB 00 3A
 ld d, srl (ix+0)               ; DD CB 00 3A
 ld d, srl (ix+126)             ; DD CB 7E 3A
 ld d, srl (ix-128)             ; DD CB 80 3A
 ld d, srl (iy)                 ; FD CB 00 3A
 ld d, srl (iy+0)               ; FD CB 00 3A
 ld d, srl (iy+126)             ; FD CB 7E 3A
 ld d, srl (iy-128)             ; FD CB 80 3A
 ld de, (0x1234)                ; ED 5B 34 12
 ld de, (hl)                    ; 5E 23 56 2B
 ld de, (hl+)                   ; 5E 23 56 23
 ld de, (ix)                    ; DD 5E 00 DD 56 01
 ld de, (ix+0)                  ; DD 5E 00 DD 56 01
 ld de, (ix+126)                ; DD 5E 7E DD 56 7F
 ld de, (ix-128)                ; DD 5E 80 DD 56 81
 ld de, (iy)                    ; FD 5E 00 FD 56 01
 ld de, (iy+0)                  ; FD 5E 00 FD 56 01
 ld de, (iy+126)                ; FD 5E 7E FD 56 7F
 ld de, (iy-128)                ; FD 5E 80 FD 56 81
 ld de, 0x1234                  ; 11 34 12
 ld de, bc                      ; 50 59
 ld de, hl                      ; 54 5D
 ld de, hl+0                    ; E5 11 00 00 19 EB E1
 ld de, hl+128                  ; E5 11 80 00 19 EB E1
 ld de, hl+255                  ; E5 11 FF 00 19 EB E1
 ld de, ix                      ; DD 54 DD 5D
 ld de, iy                      ; FD 54 FD 5D
 ld de, sp                      ; EB 21 00 00 39 EB
 ld de, sp+0                    ; EB 21 00 00 39 EB
 ld de, sp+128                  ; EB 21 80 00 39 EB
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
 ld e, (ix+0)                   ; DD 5E 00
 ld e, (ix+126)                 ; DD 5E 7E
 ld e, (ix-128)                 ; DD 5E 80
 ld e, (iy)                     ; FD 5E 00
 ld e, (iy+0)                   ; FD 5E 00
 ld e, (iy+126)                 ; FD 5E 7E
 ld e, (iy-128)                 ; FD 5E 80
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
 ld e, ixh                      ; DD 5C
 ld e, ixl                      ; DD 5D
 ld e, iyh                      ; FD 5C
 ld e, iyl                      ; FD 5D
 ld e, l                        ; 5D
 ld e, res 0, (ix)              ; DD CB 00 83
 ld e, res 0, (ix+0)            ; DD CB 00 83
 ld e, res 0, (ix+126)          ; DD CB 7E 83
 ld e, res 0, (ix-128)          ; DD CB 80 83
 ld e, res 0, (iy)              ; FD CB 00 83
 ld e, res 0, (iy+0)            ; FD CB 00 83
 ld e, res 0, (iy+126)          ; FD CB 7E 83
 ld e, res 0, (iy-128)          ; FD CB 80 83
 ld e, res 1, (ix)              ; DD CB 00 8B
 ld e, res 1, (ix+0)            ; DD CB 00 8B
 ld e, res 1, (ix+126)          ; DD CB 7E 8B
 ld e, res 1, (ix-128)          ; DD CB 80 8B
 ld e, res 1, (iy)              ; FD CB 00 8B
 ld e, res 1, (iy+0)            ; FD CB 00 8B
 ld e, res 1, (iy+126)          ; FD CB 7E 8B
 ld e, res 1, (iy-128)          ; FD CB 80 8B
 ld e, res 2, (ix)              ; DD CB 00 93
 ld e, res 2, (ix+0)            ; DD CB 00 93
 ld e, res 2, (ix+126)          ; DD CB 7E 93
 ld e, res 2, (ix-128)          ; DD CB 80 93
 ld e, res 2, (iy)              ; FD CB 00 93
 ld e, res 2, (iy+0)            ; FD CB 00 93
 ld e, res 2, (iy+126)          ; FD CB 7E 93
 ld e, res 2, (iy-128)          ; FD CB 80 93
 ld e, res 3, (ix)              ; DD CB 00 9B
 ld e, res 3, (ix+0)            ; DD CB 00 9B
 ld e, res 3, (ix+126)          ; DD CB 7E 9B
 ld e, res 3, (ix-128)          ; DD CB 80 9B
 ld e, res 3, (iy)              ; FD CB 00 9B
 ld e, res 3, (iy+0)            ; FD CB 00 9B
 ld e, res 3, (iy+126)          ; FD CB 7E 9B
 ld e, res 3, (iy-128)          ; FD CB 80 9B
 ld e, res 4, (ix)              ; DD CB 00 A3
 ld e, res 4, (ix+0)            ; DD CB 00 A3
 ld e, res 4, (ix+126)          ; DD CB 7E A3
 ld e, res 4, (ix-128)          ; DD CB 80 A3
 ld e, res 4, (iy)              ; FD CB 00 A3
 ld e, res 4, (iy+0)            ; FD CB 00 A3
 ld e, res 4, (iy+126)          ; FD CB 7E A3
 ld e, res 4, (iy-128)          ; FD CB 80 A3
 ld e, res 5, (ix)              ; DD CB 00 AB
 ld e, res 5, (ix+0)            ; DD CB 00 AB
 ld e, res 5, (ix+126)          ; DD CB 7E AB
 ld e, res 5, (ix-128)          ; DD CB 80 AB
 ld e, res 5, (iy)              ; FD CB 00 AB
 ld e, res 5, (iy+0)            ; FD CB 00 AB
 ld e, res 5, (iy+126)          ; FD CB 7E AB
 ld e, res 5, (iy-128)          ; FD CB 80 AB
 ld e, res 6, (ix)              ; DD CB 00 B3
 ld e, res 6, (ix+0)            ; DD CB 00 B3
 ld e, res 6, (ix+126)          ; DD CB 7E B3
 ld e, res 6, (ix-128)          ; DD CB 80 B3
 ld e, res 6, (iy)              ; FD CB 00 B3
 ld e, res 6, (iy+0)            ; FD CB 00 B3
 ld e, res 6, (iy+126)          ; FD CB 7E B3
 ld e, res 6, (iy-128)          ; FD CB 80 B3
 ld e, res 7, (ix)              ; DD CB 00 BB
 ld e, res 7, (ix+0)            ; DD CB 00 BB
 ld e, res 7, (ix+126)          ; DD CB 7E BB
 ld e, res 7, (ix-128)          ; DD CB 80 BB
 ld e, res 7, (iy)              ; FD CB 00 BB
 ld e, res 7, (iy+0)            ; FD CB 00 BB
 ld e, res 7, (iy+126)          ; FD CB 7E BB
 ld e, res 7, (iy-128)          ; FD CB 80 BB
 ld e, rl (ix)                  ; DD CB 00 13
 ld e, rl (ix+0)                ; DD CB 00 13
 ld e, rl (ix+126)              ; DD CB 7E 13
 ld e, rl (ix-128)              ; DD CB 80 13
 ld e, rl (iy)                  ; FD CB 00 13
 ld e, rl (iy+0)                ; FD CB 00 13
 ld e, rl (iy+126)              ; FD CB 7E 13
 ld e, rl (iy-128)              ; FD CB 80 13
 ld e, rlc (ix)                 ; DD CB 00 03
 ld e, rlc (ix+0)               ; DD CB 00 03
 ld e, rlc (ix+126)             ; DD CB 7E 03
 ld e, rlc (ix-128)             ; DD CB 80 03
 ld e, rlc (iy)                 ; FD CB 00 03
 ld e, rlc (iy+0)               ; FD CB 00 03
 ld e, rlc (iy+126)             ; FD CB 7E 03
 ld e, rlc (iy-128)             ; FD CB 80 03
 ld e, rr (ix)                  ; DD CB 00 1B
 ld e, rr (ix+0)                ; DD CB 00 1B
 ld e, rr (ix+126)              ; DD CB 7E 1B
 ld e, rr (ix-128)              ; DD CB 80 1B
 ld e, rr (iy)                  ; FD CB 00 1B
 ld e, rr (iy+0)                ; FD CB 00 1B
 ld e, rr (iy+126)              ; FD CB 7E 1B
 ld e, rr (iy-128)              ; FD CB 80 1B
 ld e, rrc (ix)                 ; DD CB 00 0B
 ld e, rrc (ix+0)               ; DD CB 00 0B
 ld e, rrc (ix+126)             ; DD CB 7E 0B
 ld e, rrc (ix-128)             ; DD CB 80 0B
 ld e, rrc (iy)                 ; FD CB 00 0B
 ld e, rrc (iy+0)               ; FD CB 00 0B
 ld e, rrc (iy+126)             ; FD CB 7E 0B
 ld e, rrc (iy-128)             ; FD CB 80 0B
 ld e, set 0, (ix)              ; DD CB 00 C3
 ld e, set 0, (ix+0)            ; DD CB 00 C3
 ld e, set 0, (ix+126)          ; DD CB 7E C3
 ld e, set 0, (ix-128)          ; DD CB 80 C3
 ld e, set 0, (iy)              ; FD CB 00 C3
 ld e, set 0, (iy+0)            ; FD CB 00 C3
 ld e, set 0, (iy+126)          ; FD CB 7E C3
 ld e, set 0, (iy-128)          ; FD CB 80 C3
 ld e, set 1, (ix)              ; DD CB 00 CB
 ld e, set 1, (ix+0)            ; DD CB 00 CB
 ld e, set 1, (ix+126)          ; DD CB 7E CB
 ld e, set 1, (ix-128)          ; DD CB 80 CB
 ld e, set 1, (iy)              ; FD CB 00 CB
 ld e, set 1, (iy+0)            ; FD CB 00 CB
 ld e, set 1, (iy+126)          ; FD CB 7E CB
 ld e, set 1, (iy-128)          ; FD CB 80 CB
 ld e, set 2, (ix)              ; DD CB 00 D3
 ld e, set 2, (ix+0)            ; DD CB 00 D3
 ld e, set 2, (ix+126)          ; DD CB 7E D3
 ld e, set 2, (ix-128)          ; DD CB 80 D3
 ld e, set 2, (iy)              ; FD CB 00 D3
 ld e, set 2, (iy+0)            ; FD CB 00 D3
 ld e, set 2, (iy+126)          ; FD CB 7E D3
 ld e, set 2, (iy-128)          ; FD CB 80 D3
 ld e, set 3, (ix)              ; DD CB 00 DB
 ld e, set 3, (ix+0)            ; DD CB 00 DB
 ld e, set 3, (ix+126)          ; DD CB 7E DB
 ld e, set 3, (ix-128)          ; DD CB 80 DB
 ld e, set 3, (iy)              ; FD CB 00 DB
 ld e, set 3, (iy+0)            ; FD CB 00 DB
 ld e, set 3, (iy+126)          ; FD CB 7E DB
 ld e, set 3, (iy-128)          ; FD CB 80 DB
 ld e, set 4, (ix)              ; DD CB 00 E3
 ld e, set 4, (ix+0)            ; DD CB 00 E3
 ld e, set 4, (ix+126)          ; DD CB 7E E3
 ld e, set 4, (ix-128)          ; DD CB 80 E3
 ld e, set 4, (iy)              ; FD CB 00 E3
 ld e, set 4, (iy+0)            ; FD CB 00 E3
 ld e, set 4, (iy+126)          ; FD CB 7E E3
 ld e, set 4, (iy-128)          ; FD CB 80 E3
 ld e, set 5, (ix)              ; DD CB 00 EB
 ld e, set 5, (ix+0)            ; DD CB 00 EB
 ld e, set 5, (ix+126)          ; DD CB 7E EB
 ld e, set 5, (ix-128)          ; DD CB 80 EB
 ld e, set 5, (iy)              ; FD CB 00 EB
 ld e, set 5, (iy+0)            ; FD CB 00 EB
 ld e, set 5, (iy+126)          ; FD CB 7E EB
 ld e, set 5, (iy-128)          ; FD CB 80 EB
 ld e, set 6, (ix)              ; DD CB 00 F3
 ld e, set 6, (ix+0)            ; DD CB 00 F3
 ld e, set 6, (ix+126)          ; DD CB 7E F3
 ld e, set 6, (ix-128)          ; DD CB 80 F3
 ld e, set 6, (iy)              ; FD CB 00 F3
 ld e, set 6, (iy+0)            ; FD CB 00 F3
 ld e, set 6, (iy+126)          ; FD CB 7E F3
 ld e, set 6, (iy-128)          ; FD CB 80 F3
 ld e, set 7, (ix)              ; DD CB 00 FB
 ld e, set 7, (ix+0)            ; DD CB 00 FB
 ld e, set 7, (ix+126)          ; DD CB 7E FB
 ld e, set 7, (ix-128)          ; DD CB 80 FB
 ld e, set 7, (iy)              ; FD CB 00 FB
 ld e, set 7, (iy+0)            ; FD CB 00 FB
 ld e, set 7, (iy+126)          ; FD CB 7E FB
 ld e, set 7, (iy-128)          ; FD CB 80 FB
 ld e, sla (ix)                 ; DD CB 00 23
 ld e, sla (ix+0)               ; DD CB 00 23
 ld e, sla (ix+126)             ; DD CB 7E 23
 ld e, sla (ix-128)             ; DD CB 80 23
 ld e, sla (iy)                 ; FD CB 00 23
 ld e, sla (iy+0)               ; FD CB 00 23
 ld e, sla (iy+126)             ; FD CB 7E 23
 ld e, sla (iy-128)             ; FD CB 80 23
 ld e, sli (ix)                 ; DD CB 00 33
 ld e, sli (ix+0)               ; DD CB 00 33
 ld e, sli (ix+126)             ; DD CB 7E 33
 ld e, sli (ix-128)             ; DD CB 80 33
 ld e, sli (iy)                 ; FD CB 00 33
 ld e, sli (iy+0)               ; FD CB 00 33
 ld e, sli (iy+126)             ; FD CB 7E 33
 ld e, sli (iy-128)             ; FD CB 80 33
 ld e, sll (ix)                 ; DD CB 00 33
 ld e, sll (ix+0)               ; DD CB 00 33
 ld e, sll (ix+126)             ; DD CB 7E 33
 ld e, sll (ix-128)             ; DD CB 80 33
 ld e, sll (iy)                 ; FD CB 00 33
 ld e, sll (iy+0)               ; FD CB 00 33
 ld e, sll (iy+126)             ; FD CB 7E 33
 ld e, sll (iy-128)             ; FD CB 80 33
 ld e, sls (ix)                 ; DD CB 00 33
 ld e, sls (ix+0)               ; DD CB 00 33
 ld e, sls (ix+126)             ; DD CB 7E 33
 ld e, sls (ix-128)             ; DD CB 80 33
 ld e, sls (iy)                 ; FD CB 00 33
 ld e, sls (iy+0)               ; FD CB 00 33
 ld e, sls (iy+126)             ; FD CB 7E 33
 ld e, sls (iy-128)             ; FD CB 80 33
 ld e, sra (ix)                 ; DD CB 00 2B
 ld e, sra (ix+0)               ; DD CB 00 2B
 ld e, sra (ix+126)             ; DD CB 7E 2B
 ld e, sra (ix-128)             ; DD CB 80 2B
 ld e, sra (iy)                 ; FD CB 00 2B
 ld e, sra (iy+0)               ; FD CB 00 2B
 ld e, sra (iy+126)             ; FD CB 7E 2B
 ld e, sra (iy-128)             ; FD CB 80 2B
 ld e, srl (ix)                 ; DD CB 00 3B
 ld e, srl (ix+0)               ; DD CB 00 3B
 ld e, srl (ix+126)             ; DD CB 7E 3B
 ld e, srl (ix-128)             ; DD CB 80 3B
 ld e, srl (iy)                 ; FD CB 00 3B
 ld e, srl (iy+0)               ; FD CB 00 3B
 ld e, srl (iy+126)             ; FD CB 7E 3B
 ld e, srl (iy-128)             ; FD CB 80 3B
 ld h, (de)                     ; EB 56 EB
 ld h, (de+)                    ; EB 56 EB 13
 ld h, (de-)                    ; EB 56 EB 1B
 ld h, (hl)                     ; 66
 ld h, (hl+)                    ; 66 23
 ld h, (hl-)                    ; 66 2B
 ld h, (hld)                    ; 66 2B
 ld h, (hli)                    ; 66 23
 ld h, (ix)                     ; DD 66 00
 ld h, (ix+0)                   ; DD 66 00
 ld h, (ix+126)                 ; DD 66 7E
 ld h, (ix-128)                 ; DD 66 80
 ld h, (iy)                     ; FD 66 00
 ld h, (iy+0)                   ; FD 66 00
 ld h, (iy+126)                 ; FD 66 7E
 ld h, (iy-128)                 ; FD 66 80
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
 ld h, res 0, (ix)              ; DD CB 00 84
 ld h, res 0, (ix+0)            ; DD CB 00 84
 ld h, res 0, (ix+126)          ; DD CB 7E 84
 ld h, res 0, (ix-128)          ; DD CB 80 84
 ld h, res 0, (iy)              ; FD CB 00 84
 ld h, res 0, (iy+0)            ; FD CB 00 84
 ld h, res 0, (iy+126)          ; FD CB 7E 84
 ld h, res 0, (iy-128)          ; FD CB 80 84
 ld h, res 1, (ix)              ; DD CB 00 8C
 ld h, res 1, (ix+0)            ; DD CB 00 8C
 ld h, res 1, (ix+126)          ; DD CB 7E 8C
 ld h, res 1, (ix-128)          ; DD CB 80 8C
 ld h, res 1, (iy)              ; FD CB 00 8C
 ld h, res 1, (iy+0)            ; FD CB 00 8C
 ld h, res 1, (iy+126)          ; FD CB 7E 8C
 ld h, res 1, (iy-128)          ; FD CB 80 8C
 ld h, res 2, (ix)              ; DD CB 00 94
 ld h, res 2, (ix+0)            ; DD CB 00 94
 ld h, res 2, (ix+126)          ; DD CB 7E 94
 ld h, res 2, (ix-128)          ; DD CB 80 94
 ld h, res 2, (iy)              ; FD CB 00 94
 ld h, res 2, (iy+0)            ; FD CB 00 94
 ld h, res 2, (iy+126)          ; FD CB 7E 94
 ld h, res 2, (iy-128)          ; FD CB 80 94
 ld h, res 3, (ix)              ; DD CB 00 9C
 ld h, res 3, (ix+0)            ; DD CB 00 9C
 ld h, res 3, (ix+126)          ; DD CB 7E 9C
 ld h, res 3, (ix-128)          ; DD CB 80 9C
 ld h, res 3, (iy)              ; FD CB 00 9C
 ld h, res 3, (iy+0)            ; FD CB 00 9C
 ld h, res 3, (iy+126)          ; FD CB 7E 9C
 ld h, res 3, (iy-128)          ; FD CB 80 9C
 ld h, res 4, (ix)              ; DD CB 00 A4
 ld h, res 4, (ix+0)            ; DD CB 00 A4
 ld h, res 4, (ix+126)          ; DD CB 7E A4
 ld h, res 4, (ix-128)          ; DD CB 80 A4
 ld h, res 4, (iy)              ; FD CB 00 A4
 ld h, res 4, (iy+0)            ; FD CB 00 A4
 ld h, res 4, (iy+126)          ; FD CB 7E A4
 ld h, res 4, (iy-128)          ; FD CB 80 A4
 ld h, res 5, (ix)              ; DD CB 00 AC
 ld h, res 5, (ix+0)            ; DD CB 00 AC
 ld h, res 5, (ix+126)          ; DD CB 7E AC
 ld h, res 5, (ix-128)          ; DD CB 80 AC
 ld h, res 5, (iy)              ; FD CB 00 AC
 ld h, res 5, (iy+0)            ; FD CB 00 AC
 ld h, res 5, (iy+126)          ; FD CB 7E AC
 ld h, res 5, (iy-128)          ; FD CB 80 AC
 ld h, res 6, (ix)              ; DD CB 00 B4
 ld h, res 6, (ix+0)            ; DD CB 00 B4
 ld h, res 6, (ix+126)          ; DD CB 7E B4
 ld h, res 6, (ix-128)          ; DD CB 80 B4
 ld h, res 6, (iy)              ; FD CB 00 B4
 ld h, res 6, (iy+0)            ; FD CB 00 B4
 ld h, res 6, (iy+126)          ; FD CB 7E B4
 ld h, res 6, (iy-128)          ; FD CB 80 B4
 ld h, res 7, (ix)              ; DD CB 00 BC
 ld h, res 7, (ix+0)            ; DD CB 00 BC
 ld h, res 7, (ix+126)          ; DD CB 7E BC
 ld h, res 7, (ix-128)          ; DD CB 80 BC
 ld h, res 7, (iy)              ; FD CB 00 BC
 ld h, res 7, (iy+0)            ; FD CB 00 BC
 ld h, res 7, (iy+126)          ; FD CB 7E BC
 ld h, res 7, (iy-128)          ; FD CB 80 BC
 ld h, rl (ix)                  ; DD CB 00 14
 ld h, rl (ix+0)                ; DD CB 00 14
 ld h, rl (ix+126)              ; DD CB 7E 14
 ld h, rl (ix-128)              ; DD CB 80 14
 ld h, rl (iy)                  ; FD CB 00 14
 ld h, rl (iy+0)                ; FD CB 00 14
 ld h, rl (iy+126)              ; FD CB 7E 14
 ld h, rl (iy-128)              ; FD CB 80 14
 ld h, rlc (ix)                 ; DD CB 00 04
 ld h, rlc (ix+0)               ; DD CB 00 04
 ld h, rlc (ix+126)             ; DD CB 7E 04
 ld h, rlc (ix-128)             ; DD CB 80 04
 ld h, rlc (iy)                 ; FD CB 00 04
 ld h, rlc (iy+0)               ; FD CB 00 04
 ld h, rlc (iy+126)             ; FD CB 7E 04
 ld h, rlc (iy-128)             ; FD CB 80 04
 ld h, rr (ix)                  ; DD CB 00 1C
 ld h, rr (ix+0)                ; DD CB 00 1C
 ld h, rr (ix+126)              ; DD CB 7E 1C
 ld h, rr (ix-128)              ; DD CB 80 1C
 ld h, rr (iy)                  ; FD CB 00 1C
 ld h, rr (iy+0)                ; FD CB 00 1C
 ld h, rr (iy+126)              ; FD CB 7E 1C
 ld h, rr (iy-128)              ; FD CB 80 1C
 ld h, rrc (ix)                 ; DD CB 00 0C
 ld h, rrc (ix+0)               ; DD CB 00 0C
 ld h, rrc (ix+126)             ; DD CB 7E 0C
 ld h, rrc (ix-128)             ; DD CB 80 0C
 ld h, rrc (iy)                 ; FD CB 00 0C
 ld h, rrc (iy+0)               ; FD CB 00 0C
 ld h, rrc (iy+126)             ; FD CB 7E 0C
 ld h, rrc (iy-128)             ; FD CB 80 0C
 ld h, set 0, (ix)              ; DD CB 00 C4
 ld h, set 0, (ix+0)            ; DD CB 00 C4
 ld h, set 0, (ix+126)          ; DD CB 7E C4
 ld h, set 0, (ix-128)          ; DD CB 80 C4
 ld h, set 0, (iy)              ; FD CB 00 C4
 ld h, set 0, (iy+0)            ; FD CB 00 C4
 ld h, set 0, (iy+126)          ; FD CB 7E C4
 ld h, set 0, (iy-128)          ; FD CB 80 C4
 ld h, set 1, (ix)              ; DD CB 00 CC
 ld h, set 1, (ix+0)            ; DD CB 00 CC
 ld h, set 1, (ix+126)          ; DD CB 7E CC
 ld h, set 1, (ix-128)          ; DD CB 80 CC
 ld h, set 1, (iy)              ; FD CB 00 CC
 ld h, set 1, (iy+0)            ; FD CB 00 CC
 ld h, set 1, (iy+126)          ; FD CB 7E CC
 ld h, set 1, (iy-128)          ; FD CB 80 CC
 ld h, set 2, (ix)              ; DD CB 00 D4
 ld h, set 2, (ix+0)            ; DD CB 00 D4
 ld h, set 2, (ix+126)          ; DD CB 7E D4
 ld h, set 2, (ix-128)          ; DD CB 80 D4
 ld h, set 2, (iy)              ; FD CB 00 D4
 ld h, set 2, (iy+0)            ; FD CB 00 D4
 ld h, set 2, (iy+126)          ; FD CB 7E D4
 ld h, set 2, (iy-128)          ; FD CB 80 D4
 ld h, set 3, (ix)              ; DD CB 00 DC
 ld h, set 3, (ix+0)            ; DD CB 00 DC
 ld h, set 3, (ix+126)          ; DD CB 7E DC
 ld h, set 3, (ix-128)          ; DD CB 80 DC
 ld h, set 3, (iy)              ; FD CB 00 DC
 ld h, set 3, (iy+0)            ; FD CB 00 DC
 ld h, set 3, (iy+126)          ; FD CB 7E DC
 ld h, set 3, (iy-128)          ; FD CB 80 DC
 ld h, set 4, (ix)              ; DD CB 00 E4
 ld h, set 4, (ix+0)            ; DD CB 00 E4
 ld h, set 4, (ix+126)          ; DD CB 7E E4
 ld h, set 4, (ix-128)          ; DD CB 80 E4
 ld h, set 4, (iy)              ; FD CB 00 E4
 ld h, set 4, (iy+0)            ; FD CB 00 E4
 ld h, set 4, (iy+126)          ; FD CB 7E E4
 ld h, set 4, (iy-128)          ; FD CB 80 E4
 ld h, set 5, (ix)              ; DD CB 00 EC
 ld h, set 5, (ix+0)            ; DD CB 00 EC
 ld h, set 5, (ix+126)          ; DD CB 7E EC
 ld h, set 5, (ix-128)          ; DD CB 80 EC
 ld h, set 5, (iy)              ; FD CB 00 EC
 ld h, set 5, (iy+0)            ; FD CB 00 EC
 ld h, set 5, (iy+126)          ; FD CB 7E EC
 ld h, set 5, (iy-128)          ; FD CB 80 EC
 ld h, set 6, (ix)              ; DD CB 00 F4
 ld h, set 6, (ix+0)            ; DD CB 00 F4
 ld h, set 6, (ix+126)          ; DD CB 7E F4
 ld h, set 6, (ix-128)          ; DD CB 80 F4
 ld h, set 6, (iy)              ; FD CB 00 F4
 ld h, set 6, (iy+0)            ; FD CB 00 F4
 ld h, set 6, (iy+126)          ; FD CB 7E F4
 ld h, set 6, (iy-128)          ; FD CB 80 F4
 ld h, set 7, (ix)              ; DD CB 00 FC
 ld h, set 7, (ix+0)            ; DD CB 00 FC
 ld h, set 7, (ix+126)          ; DD CB 7E FC
 ld h, set 7, (ix-128)          ; DD CB 80 FC
 ld h, set 7, (iy)              ; FD CB 00 FC
 ld h, set 7, (iy+0)            ; FD CB 00 FC
 ld h, set 7, (iy+126)          ; FD CB 7E FC
 ld h, set 7, (iy-128)          ; FD CB 80 FC
 ld h, sla (ix)                 ; DD CB 00 24
 ld h, sla (ix+0)               ; DD CB 00 24
 ld h, sla (ix+126)             ; DD CB 7E 24
 ld h, sla (ix-128)             ; DD CB 80 24
 ld h, sla (iy)                 ; FD CB 00 24
 ld h, sla (iy+0)               ; FD CB 00 24
 ld h, sla (iy+126)             ; FD CB 7E 24
 ld h, sla (iy-128)             ; FD CB 80 24
 ld h, sli (ix)                 ; DD CB 00 34
 ld h, sli (ix+0)               ; DD CB 00 34
 ld h, sli (ix+126)             ; DD CB 7E 34
 ld h, sli (ix-128)             ; DD CB 80 34
 ld h, sli (iy)                 ; FD CB 00 34
 ld h, sli (iy+0)               ; FD CB 00 34
 ld h, sli (iy+126)             ; FD CB 7E 34
 ld h, sli (iy-128)             ; FD CB 80 34
 ld h, sll (ix)                 ; DD CB 00 34
 ld h, sll (ix+0)               ; DD CB 00 34
 ld h, sll (ix+126)             ; DD CB 7E 34
 ld h, sll (ix-128)             ; DD CB 80 34
 ld h, sll (iy)                 ; FD CB 00 34
 ld h, sll (iy+0)               ; FD CB 00 34
 ld h, sll (iy+126)             ; FD CB 7E 34
 ld h, sll (iy-128)             ; FD CB 80 34
 ld h, sls (ix)                 ; DD CB 00 34
 ld h, sls (ix+0)               ; DD CB 00 34
 ld h, sls (ix+126)             ; DD CB 7E 34
 ld h, sls (ix-128)             ; DD CB 80 34
 ld h, sls (iy)                 ; FD CB 00 34
 ld h, sls (iy+0)               ; FD CB 00 34
 ld h, sls (iy+126)             ; FD CB 7E 34
 ld h, sls (iy-128)             ; FD CB 80 34
 ld h, sra (ix)                 ; DD CB 00 2C
 ld h, sra (ix+0)               ; DD CB 00 2C
 ld h, sra (ix+126)             ; DD CB 7E 2C
 ld h, sra (ix-128)             ; DD CB 80 2C
 ld h, sra (iy)                 ; FD CB 00 2C
 ld h, sra (iy+0)               ; FD CB 00 2C
 ld h, sra (iy+126)             ; FD CB 7E 2C
 ld h, sra (iy-128)             ; FD CB 80 2C
 ld h, srl (ix)                 ; DD CB 00 3C
 ld h, srl (ix+0)               ; DD CB 00 3C
 ld h, srl (ix+126)             ; DD CB 7E 3C
 ld h, srl (ix-128)             ; DD CB 80 3C
 ld h, srl (iy)                 ; FD CB 00 3C
 ld h, srl (iy+0)               ; FD CB 00 3C
 ld h, srl (iy+126)             ; FD CB 7E 3C
 ld h, srl (iy-128)             ; FD CB 80 3C
 ld hl, (0x1234)                ; 2A 34 12
 ld hl, (hl)                    ; F5 7E 23 66 6F F1
 ld hl, (hl+)                   ; F5 7E 23 66 6F F1
 ld hl, (ix)                    ; DD 6E 00 DD 66 01
 ld hl, (ix+0)                  ; DD 6E 00 DD 66 01
 ld hl, (ix+126)                ; DD 6E 7E DD 66 7F
 ld hl, (ix-128)                ; DD 6E 80 DD 66 81
 ld hl, (iy)                    ; FD 6E 00 FD 66 01
 ld hl, (iy+0)                  ; FD 6E 00 FD 66 01
 ld hl, (iy+126)                ; FD 6E 7E FD 66 7F
 ld hl, (iy-128)                ; FD 6E 80 FD 66 81
 ld hl, 0x1234                  ; 21 34 12
 ld hl, bc                      ; 60 69
 ld hl, de                      ; 62 6B
 ld hl, ix                      ; DD E5 E1
 ld hl, iy                      ; FD E5 E1
 ld hl, sp                      ; 21 00 00 39
 ld hl, sp+0                    ; 21 00 00 39
 ld hl, sp+126                  ; 21 7E 00 39
 ld hl, sp-128                  ; 21 80 FF 39
 ld i, a                        ; ED 47
 ld ix, (0x1234)                ; DD 2A 34 12
 ld ix, (hl)                    ; D5 5E 23 56 2B D5 DD E1 D1
 ld ix, (hl+)                   ; D5 5E 23 56 23 D5 DD E1 D1
 ld ix, (ix)                    ; DD E5 E3 DD 6E 00 DD 66 01 E3 DD E1
 ld ix, (ix+0)                  ; DD E5 E3 DD 6E 00 DD 66 01 E3 DD E1
 ld ix, (ix+126)                ; DD E5 E3 DD 6E 7E DD 66 7F E3 DD E1
 ld ix, (ix-128)                ; DD E5 E3 DD 6E 80 DD 66 81 E3 DD E1
 ld ix, (iy)                    ; DD E5 E3 FD 6E 00 FD 66 01 E3 DD E1
 ld ix, (iy+0)                  ; DD E5 E3 FD 6E 00 FD 66 01 E3 DD E1
 ld ix, (iy+126)                ; DD E5 E3 FD 6E 7E FD 66 7F E3 DD E1
 ld ix, (iy-128)                ; DD E5 E3 FD 6E 80 FD 66 81 E3 DD E1
 ld ix, 0x1234                  ; DD 21 34 12
 ld ix, bc                      ; DD 60 DD 69
 ld ix, de                      ; DD 62 DD 6B
 ld ix, hl                      ; E5 DD E1
 ld ix, iy                      ; FD E5 DD E1
 ld ixh, -128                   ; DD 26 80
 ld ixh, 0                      ; DD 26 00
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
 ld ixl, 0                      ; DD 2E 00
 ld ixl, 127                    ; DD 2E 7F
 ld ixl, 255                    ; DD 2E FF
 ld ixl, a                      ; DD 6F
 ld ixl, b                      ; DD 68
 ld ixl, c                      ; DD 69
 ld ixl, d                      ; DD 6A
 ld ixl, e                      ; DD 6B
 ld ixl, ixh                    ; DD 6C
 ld ixl, ixl                    ; DD 6D
 ld iy, (0x1234)                ; FD 2A 34 12
 ld iy, (hl)                    ; D5 5E 23 56 2B D5 FD E1 D1
 ld iy, (hl+)                   ; D5 5E 23 56 23 D5 FD E1 D1
 ld iy, (ix)                    ; FD E5 E3 DD 6E 00 DD 66 01 E3 FD E1
 ld iy, (ix+0)                  ; FD E5 E3 DD 6E 00 DD 66 01 E3 FD E1
 ld iy, (ix+126)                ; FD E5 E3 DD 6E 7E DD 66 7F E3 FD E1
 ld iy, (ix-128)                ; FD E5 E3 DD 6E 80 DD 66 81 E3 FD E1
 ld iy, (iy)                    ; FD E5 E3 FD 6E 00 FD 66 01 E3 FD E1
 ld iy, (iy+0)                  ; FD E5 E3 FD 6E 00 FD 66 01 E3 FD E1
 ld iy, (iy+126)                ; FD E5 E3 FD 6E 7E FD 66 7F E3 FD E1
 ld iy, (iy-128)                ; FD E5 E3 FD 6E 80 FD 66 81 E3 FD E1
 ld iy, 0x1234                  ; FD 21 34 12
 ld iy, bc                      ; FD 60 FD 69
 ld iy, de                      ; FD 62 FD 6B
 ld iy, hl                      ; E5 FD E1
 ld iy, ix                      ; DD E5 FD E1
 ld iyh, -128                   ; FD 26 80
 ld iyh, 0                      ; FD 26 00
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
 ld iyl, 0                      ; FD 2E 00
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
 ld l, (ix+0)                   ; DD 6E 00
 ld l, (ix+126)                 ; DD 6E 7E
 ld l, (ix-128)                 ; DD 6E 80
 ld l, (iy)                     ; FD 6E 00
 ld l, (iy+0)                   ; FD 6E 00
 ld l, (iy+126)                 ; FD 6E 7E
 ld l, (iy-128)                 ; FD 6E 80
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
 ld l, res 0, (ix)              ; DD CB 00 85
 ld l, res 0, (ix+0)            ; DD CB 00 85
 ld l, res 0, (ix+126)          ; DD CB 7E 85
 ld l, res 0, (ix-128)          ; DD CB 80 85
 ld l, res 0, (iy)              ; FD CB 00 85
 ld l, res 0, (iy+0)            ; FD CB 00 85
 ld l, res 0, (iy+126)          ; FD CB 7E 85
 ld l, res 0, (iy-128)          ; FD CB 80 85
 ld l, res 1, (ix)              ; DD CB 00 8D
 ld l, res 1, (ix+0)            ; DD CB 00 8D
 ld l, res 1, (ix+126)          ; DD CB 7E 8D
 ld l, res 1, (ix-128)          ; DD CB 80 8D
 ld l, res 1, (iy)              ; FD CB 00 8D
 ld l, res 1, (iy+0)            ; FD CB 00 8D
 ld l, res 1, (iy+126)          ; FD CB 7E 8D
 ld l, res 1, (iy-128)          ; FD CB 80 8D
 ld l, res 2, (ix)              ; DD CB 00 95
 ld l, res 2, (ix+0)            ; DD CB 00 95
 ld l, res 2, (ix+126)          ; DD CB 7E 95
 ld l, res 2, (ix-128)          ; DD CB 80 95
 ld l, res 2, (iy)              ; FD CB 00 95
 ld l, res 2, (iy+0)            ; FD CB 00 95
 ld l, res 2, (iy+126)          ; FD CB 7E 95
 ld l, res 2, (iy-128)          ; FD CB 80 95
 ld l, res 3, (ix)              ; DD CB 00 9D
 ld l, res 3, (ix+0)            ; DD CB 00 9D
 ld l, res 3, (ix+126)          ; DD CB 7E 9D
 ld l, res 3, (ix-128)          ; DD CB 80 9D
 ld l, res 3, (iy)              ; FD CB 00 9D
 ld l, res 3, (iy+0)            ; FD CB 00 9D
 ld l, res 3, (iy+126)          ; FD CB 7E 9D
 ld l, res 3, (iy-128)          ; FD CB 80 9D
 ld l, res 4, (ix)              ; DD CB 00 A5
 ld l, res 4, (ix+0)            ; DD CB 00 A5
 ld l, res 4, (ix+126)          ; DD CB 7E A5
 ld l, res 4, (ix-128)          ; DD CB 80 A5
 ld l, res 4, (iy)              ; FD CB 00 A5
 ld l, res 4, (iy+0)            ; FD CB 00 A5
 ld l, res 4, (iy+126)          ; FD CB 7E A5
 ld l, res 4, (iy-128)          ; FD CB 80 A5
 ld l, res 5, (ix)              ; DD CB 00 AD
 ld l, res 5, (ix+0)            ; DD CB 00 AD
 ld l, res 5, (ix+126)          ; DD CB 7E AD
 ld l, res 5, (ix-128)          ; DD CB 80 AD
 ld l, res 5, (iy)              ; FD CB 00 AD
 ld l, res 5, (iy+0)            ; FD CB 00 AD
 ld l, res 5, (iy+126)          ; FD CB 7E AD
 ld l, res 5, (iy-128)          ; FD CB 80 AD
 ld l, res 6, (ix)              ; DD CB 00 B5
 ld l, res 6, (ix+0)            ; DD CB 00 B5
 ld l, res 6, (ix+126)          ; DD CB 7E B5
 ld l, res 6, (ix-128)          ; DD CB 80 B5
 ld l, res 6, (iy)              ; FD CB 00 B5
 ld l, res 6, (iy+0)            ; FD CB 00 B5
 ld l, res 6, (iy+126)          ; FD CB 7E B5
 ld l, res 6, (iy-128)          ; FD CB 80 B5
 ld l, res 7, (ix)              ; DD CB 00 BD
 ld l, res 7, (ix+0)            ; DD CB 00 BD
 ld l, res 7, (ix+126)          ; DD CB 7E BD
 ld l, res 7, (ix-128)          ; DD CB 80 BD
 ld l, res 7, (iy)              ; FD CB 00 BD
 ld l, res 7, (iy+0)            ; FD CB 00 BD
 ld l, res 7, (iy+126)          ; FD CB 7E BD
 ld l, res 7, (iy-128)          ; FD CB 80 BD
 ld l, rl (ix)                  ; DD CB 00 15
 ld l, rl (ix+0)                ; DD CB 00 15
 ld l, rl (ix+126)              ; DD CB 7E 15
 ld l, rl (ix-128)              ; DD CB 80 15
 ld l, rl (iy)                  ; FD CB 00 15
 ld l, rl (iy+0)                ; FD CB 00 15
 ld l, rl (iy+126)              ; FD CB 7E 15
 ld l, rl (iy-128)              ; FD CB 80 15
 ld l, rlc (ix)                 ; DD CB 00 05
 ld l, rlc (ix+0)               ; DD CB 00 05
 ld l, rlc (ix+126)             ; DD CB 7E 05
 ld l, rlc (ix-128)             ; DD CB 80 05
 ld l, rlc (iy)                 ; FD CB 00 05
 ld l, rlc (iy+0)               ; FD CB 00 05
 ld l, rlc (iy+126)             ; FD CB 7E 05
 ld l, rlc (iy-128)             ; FD CB 80 05
 ld l, rr (ix)                  ; DD CB 00 1D
 ld l, rr (ix+0)                ; DD CB 00 1D
 ld l, rr (ix+126)              ; DD CB 7E 1D
 ld l, rr (ix-128)              ; DD CB 80 1D
 ld l, rr (iy)                  ; FD CB 00 1D
 ld l, rr (iy+0)                ; FD CB 00 1D
 ld l, rr (iy+126)              ; FD CB 7E 1D
 ld l, rr (iy-128)              ; FD CB 80 1D
 ld l, rrc (ix)                 ; DD CB 00 0D
 ld l, rrc (ix+0)               ; DD CB 00 0D
 ld l, rrc (ix+126)             ; DD CB 7E 0D
 ld l, rrc (ix-128)             ; DD CB 80 0D
 ld l, rrc (iy)                 ; FD CB 00 0D
 ld l, rrc (iy+0)               ; FD CB 00 0D
 ld l, rrc (iy+126)             ; FD CB 7E 0D
 ld l, rrc (iy-128)             ; FD CB 80 0D
 ld l, set 0, (ix)              ; DD CB 00 C5
 ld l, set 0, (ix+0)            ; DD CB 00 C5
 ld l, set 0, (ix+126)          ; DD CB 7E C5
 ld l, set 0, (ix-128)          ; DD CB 80 C5
 ld l, set 0, (iy)              ; FD CB 00 C5
 ld l, set 0, (iy+0)            ; FD CB 00 C5
 ld l, set 0, (iy+126)          ; FD CB 7E C5
 ld l, set 0, (iy-128)          ; FD CB 80 C5
 ld l, set 1, (ix)              ; DD CB 00 CD
 ld l, set 1, (ix+0)            ; DD CB 00 CD
 ld l, set 1, (ix+126)          ; DD CB 7E CD
 ld l, set 1, (ix-128)          ; DD CB 80 CD
 ld l, set 1, (iy)              ; FD CB 00 CD
 ld l, set 1, (iy+0)            ; FD CB 00 CD
 ld l, set 1, (iy+126)          ; FD CB 7E CD
 ld l, set 1, (iy-128)          ; FD CB 80 CD
 ld l, set 2, (ix)              ; DD CB 00 D5
 ld l, set 2, (ix+0)            ; DD CB 00 D5
 ld l, set 2, (ix+126)          ; DD CB 7E D5
 ld l, set 2, (ix-128)          ; DD CB 80 D5
 ld l, set 2, (iy)              ; FD CB 00 D5
 ld l, set 2, (iy+0)            ; FD CB 00 D5
 ld l, set 2, (iy+126)          ; FD CB 7E D5
 ld l, set 2, (iy-128)          ; FD CB 80 D5
 ld l, set 3, (ix)              ; DD CB 00 DD
 ld l, set 3, (ix+0)            ; DD CB 00 DD
 ld l, set 3, (ix+126)          ; DD CB 7E DD
 ld l, set 3, (ix-128)          ; DD CB 80 DD
 ld l, set 3, (iy)              ; FD CB 00 DD
 ld l, set 3, (iy+0)            ; FD CB 00 DD
 ld l, set 3, (iy+126)          ; FD CB 7E DD
 ld l, set 3, (iy-128)          ; FD CB 80 DD
 ld l, set 4, (ix)              ; DD CB 00 E5
 ld l, set 4, (ix+0)            ; DD CB 00 E5
 ld l, set 4, (ix+126)          ; DD CB 7E E5
 ld l, set 4, (ix-128)          ; DD CB 80 E5
 ld l, set 4, (iy)              ; FD CB 00 E5
 ld l, set 4, (iy+0)            ; FD CB 00 E5
 ld l, set 4, (iy+126)          ; FD CB 7E E5
 ld l, set 4, (iy-128)          ; FD CB 80 E5
 ld l, set 5, (ix)              ; DD CB 00 ED
 ld l, set 5, (ix+0)            ; DD CB 00 ED
 ld l, set 5, (ix+126)          ; DD CB 7E ED
 ld l, set 5, (ix-128)          ; DD CB 80 ED
 ld l, set 5, (iy)              ; FD CB 00 ED
 ld l, set 5, (iy+0)            ; FD CB 00 ED
 ld l, set 5, (iy+126)          ; FD CB 7E ED
 ld l, set 5, (iy-128)          ; FD CB 80 ED
 ld l, set 6, (ix)              ; DD CB 00 F5
 ld l, set 6, (ix+0)            ; DD CB 00 F5
 ld l, set 6, (ix+126)          ; DD CB 7E F5
 ld l, set 6, (ix-128)          ; DD CB 80 F5
 ld l, set 6, (iy)              ; FD CB 00 F5
 ld l, set 6, (iy+0)            ; FD CB 00 F5
 ld l, set 6, (iy+126)          ; FD CB 7E F5
 ld l, set 6, (iy-128)          ; FD CB 80 F5
 ld l, set 7, (ix)              ; DD CB 00 FD
 ld l, set 7, (ix+0)            ; DD CB 00 FD
 ld l, set 7, (ix+126)          ; DD CB 7E FD
 ld l, set 7, (ix-128)          ; DD CB 80 FD
 ld l, set 7, (iy)              ; FD CB 00 FD
 ld l, set 7, (iy+0)            ; FD CB 00 FD
 ld l, set 7, (iy+126)          ; FD CB 7E FD
 ld l, set 7, (iy-128)          ; FD CB 80 FD
 ld l, sla (ix)                 ; DD CB 00 25
 ld l, sla (ix+0)               ; DD CB 00 25
 ld l, sla (ix+126)             ; DD CB 7E 25
 ld l, sla (ix-128)             ; DD CB 80 25
 ld l, sla (iy)                 ; FD CB 00 25
 ld l, sla (iy+0)               ; FD CB 00 25
 ld l, sla (iy+126)             ; FD CB 7E 25
 ld l, sla (iy-128)             ; FD CB 80 25
 ld l, sli (ix)                 ; DD CB 00 35
 ld l, sli (ix+0)               ; DD CB 00 35
 ld l, sli (ix+126)             ; DD CB 7E 35
 ld l, sli (ix-128)             ; DD CB 80 35
 ld l, sli (iy)                 ; FD CB 00 35
 ld l, sli (iy+0)               ; FD CB 00 35
 ld l, sli (iy+126)             ; FD CB 7E 35
 ld l, sli (iy-128)             ; FD CB 80 35
 ld l, sll (ix)                 ; DD CB 00 35
 ld l, sll (ix+0)               ; DD CB 00 35
 ld l, sll (ix+126)             ; DD CB 7E 35
 ld l, sll (ix-128)             ; DD CB 80 35
 ld l, sll (iy)                 ; FD CB 00 35
 ld l, sll (iy+0)               ; FD CB 00 35
 ld l, sll (iy+126)             ; FD CB 7E 35
 ld l, sll (iy-128)             ; FD CB 80 35
 ld l, sls (ix)                 ; DD CB 00 35
 ld l, sls (ix+0)               ; DD CB 00 35
 ld l, sls (ix+126)             ; DD CB 7E 35
 ld l, sls (ix-128)             ; DD CB 80 35
 ld l, sls (iy)                 ; FD CB 00 35
 ld l, sls (iy+0)               ; FD CB 00 35
 ld l, sls (iy+126)             ; FD CB 7E 35
 ld l, sls (iy-128)             ; FD CB 80 35
 ld l, sra (ix)                 ; DD CB 00 2D
 ld l, sra (ix+0)               ; DD CB 00 2D
 ld l, sra (ix+126)             ; DD CB 7E 2D
 ld l, sra (ix-128)             ; DD CB 80 2D
 ld l, sra (iy)                 ; FD CB 00 2D
 ld l, sra (iy+0)               ; FD CB 00 2D
 ld l, sra (iy+126)             ; FD CB 7E 2D
 ld l, sra (iy-128)             ; FD CB 80 2D
 ld l, srl (ix)                 ; DD CB 00 3D
 ld l, srl (ix+0)               ; DD CB 00 3D
 ld l, srl (ix+126)             ; DD CB 7E 3D
 ld l, srl (ix-128)             ; DD CB 80 3D
 ld l, srl (iy)                 ; FD CB 00 3D
 ld l, srl (iy+0)               ; FD CB 00 3D
 ld l, srl (iy+126)             ; FD CB 7E 3D
 ld l, srl (iy-128)             ; FD CB 80 3D
 ld r, a                        ; ED 4F
 ld sp, (0x1234)                ; ED 7B 34 12
 ld sp, 0x1234                  ; 31 34 12
 ld sp, hl                      ; F9
 ld sp, ix                      ; DD F9
 ld sp, iy                      ; FD F9
 lda 0x1234                     ; 3A 34 12
 ldax b                         ; 0A
 ldax bc                        ; 0A
 ldax d                         ; 1A
 ldax de                        ; 1A
 ldd                            ; ED A8
 ldd (bc), a                    ; 02 0B
 ldd (de), -128                 ; EB 36 80 EB 1B
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
 ldd (hl), -128                 ; 36 80 2B
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
 lddr                           ; ED B8
 lddrx                          ; ED BC
 lddx                           ; ED AC
 ldi                            ; ED A0
 ldi (bc), a                    ; 02 03
 ldi (de), -128                 ; EB 36 80 EB 13
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
 ldi (hl), -128                 ; 36 80 23
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
 ldi (hl), ix                   ; D5 DD E5 D1 73 23 72 23 D1
 ldi (hl), iy                   ; D5 FD E5 D1 73 23 72 23 D1
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
 ldi hl, (hl)                   ; F5 7E 23 66 6F F1
 ldi ix, (hl)                   ; D5 5E 23 56 23 D5 DD E1 D1
 ldi iy, (hl)                   ; D5 5E 23 56 23 D5 FD E1 D1
 ldi l, (de)                    ; EB 5E EB 13
 ldi l, (hl)                    ; 6E 23
 ldir                           ; ED B0
 ldirx                          ; ED B4
 ldix                           ; ED A4
 ldpirx                         ; ED B7
 ldrx                           ; ED BC
 ldws                           ; ED A5
 lhld 0x1234                    ; 2A 34 12
 lirx                           ; ED B4
 lprx                           ; ED B7
 lxi b, 0x1234                  ; 01 34 12
 lxi bc, 0x1234                 ; 01 34 12
 lxi d, 0x1234                  ; 11 34 12
 lxi de, 0x1234                 ; 11 34 12
 lxi h, 0x1234                  ; 21 34 12
 lxi hl, 0x1234                 ; 21 34 12
 lxi sp, 0x1234                 ; 31 34 12
 mirr a                         ; ED 24
 mirror a                       ; ED 24
 mlt de                         ; ED 30
 mmu 0, -128                    ; ED 91 50 80
 mmu 0, 0                       ; ED 91 50 00
 mmu 0, 127                     ; ED 91 50 7F
 mmu 0, 255                     ; ED 91 50 FF
 mmu 0, a                       ; ED 92 50
 mmu 1, -128                    ; ED 91 51 80
 mmu 1, 0                       ; ED 91 51 00
 mmu 1, 127                     ; ED 91 51 7F
 mmu 1, 255                     ; ED 91 51 FF
 mmu 1, a                       ; ED 92 51
 mmu 2, -128                    ; ED 91 52 80
 mmu 2, 0                       ; ED 91 52 00
 mmu 2, 127                     ; ED 91 52 7F
 mmu 2, 255                     ; ED 91 52 FF
 mmu 2, a                       ; ED 92 52
 mmu 3, -128                    ; ED 91 53 80
 mmu 3, 0                       ; ED 91 53 00
 mmu 3, 127                     ; ED 91 53 7F
 mmu 3, 255                     ; ED 91 53 FF
 mmu 3, a                       ; ED 92 53
 mmu 4, -128                    ; ED 91 54 80
 mmu 4, 0                       ; ED 91 54 00
 mmu 4, 127                     ; ED 91 54 7F
 mmu 4, 255                     ; ED 91 54 FF
 mmu 4, a                       ; ED 92 54
 mmu 5, -128                    ; ED 91 55 80
 mmu 5, 0                       ; ED 91 55 00
 mmu 5, 127                     ; ED 91 55 7F
 mmu 5, 255                     ; ED 91 55 FF
 mmu 5, a                       ; ED 92 55
 mmu 6, -128                    ; ED 91 56 80
 mmu 6, 0                       ; ED 91 56 00
 mmu 6, 127                     ; ED 91 56 7F
 mmu 6, 255                     ; ED 91 56 FF
 mmu 6, a                       ; ED 92 56
 mmu 7, -128                    ; ED 91 57 80
 mmu 7, 0                       ; ED 91 57 00
 mmu 7, 127                     ; ED 91 57 7F
 mmu 7, 255                     ; ED 91 57 FF
 mmu 7, a                       ; ED 92 57
 mmu0 -128                      ; ED 91 50 80
 mmu0 0                         ; ED 91 50 00
 mmu0 127                       ; ED 91 50 7F
 mmu0 255                       ; ED 91 50 FF
 mmu0 a                         ; ED 92 50
 mmu1 -128                      ; ED 91 51 80
 mmu1 0                         ; ED 91 51 00
 mmu1 127                       ; ED 91 51 7F
 mmu1 255                       ; ED 91 51 FF
 mmu1 a                         ; ED 92 51
 mmu2 -128                      ; ED 91 52 80
 mmu2 0                         ; ED 91 52 00
 mmu2 127                       ; ED 91 52 7F
 mmu2 255                       ; ED 91 52 FF
 mmu2 a                         ; ED 92 52
 mmu3 -128                      ; ED 91 53 80
 mmu3 0                         ; ED 91 53 00
 mmu3 127                       ; ED 91 53 7F
 mmu3 255                       ; ED 91 53 FF
 mmu3 a                         ; ED 92 53
 mmu4 -128                      ; ED 91 54 80
 mmu4 0                         ; ED 91 54 00
 mmu4 127                       ; ED 91 54 7F
 mmu4 255                       ; ED 91 54 FF
 mmu4 a                         ; ED 92 54
 mmu5 -128                      ; ED 91 55 80
 mmu5 0                         ; ED 91 55 00
 mmu5 127                       ; ED 91 55 7F
 mmu5 255                       ; ED 91 55 FF
 mmu5 a                         ; ED 92 55
 mmu6 -128                      ; ED 91 56 80
 mmu6 0                         ; ED 91 56 00
 mmu6 127                       ; ED 91 56 7F
 mmu6 255                       ; ED 91 56 FF
 mmu6 a                         ; ED 92 56
 mmu7 -128                      ; ED 91 57 80
 mmu7 0                         ; ED 91 57 00
 mmu7 127                       ; ED 91 57 7F
 mmu7 255                       ; ED 91 57 FF
 mmu7 a                         ; ED 92 57
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
 mul d, e                       ; ED 30
 mul de                         ; ED 30
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
 neg                            ; ED 44
 neg a                          ; ED 44
 nextreg -128, -128             ; ED 91 80 80
 nextreg -128, a                ; ED 92 80
 nextreg 0, 0                   ; ED 91 00 00
 nextreg 0, a                   ; ED 92 00
 nextreg 127, 127               ; ED 91 7F 7F
 nextreg 127, a                 ; ED 92 7F
 nextreg 255, 255               ; ED 91 FF FF
 nextreg 255, a                 ; ED 92 FF
 nop                            ; 00
 nreg -128, -128                ; ED 91 80 80
 nreg -128, a                   ; ED 92 80
 nreg 0, 0                      ; ED 91 00 00
 nreg 0, a                      ; ED 92 00
 nreg 127, 127                  ; ED 91 7F 7F
 nreg 127, a                    ; ED 92 7F
 nreg 255, 255                  ; ED 91 FF FF
 nreg 255, a                    ; ED 92 FF
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
 or hl, bc                      ; F5 7C B0 67 7D B1 6F F1
 or hl, de                      ; F5 7C B2 67 7D B3 6F F1
 or ix, bc                      ; F5 DD 7C B0 DD 67 DD 7D B1 DD 6F F1
 or ix, de                      ; F5 DD 7C B2 DD 67 DD 7D B3 DD 6F F1
 or ixh                         ; DD B4
 or ixl                         ; DD B5
 or iy, bc                      ; F5 FD 7C B0 FD 67 FD 7D B1 FD 6F F1
 or iy, de                      ; F5 FD 7C B2 FD 67 FD 7D B3 FD 6F F1
 or iyh                         ; FD B4
 or iyl                         ; FD B5
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
 otdr                           ; ED BB
 otib                           ; ED 90
 otir                           ; ED B3
 out (-128), a                  ; D3 80
 out (0), a                     ; D3 00
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
 out 0                          ; D3 00
 out 127                        ; D3 7F
 out 255                        ; D3 FF
 outd                           ; ED AB
 outi                           ; ED A3
 outinb                         ; ED 90
 pchl                           ; E9
 pixelad                        ; ED 94
 pixeldn                        ; ED 93
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
 push 0x1234                    ; ED 8A 12 34
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
 pxad                           ; ED 94
 pxdn                           ; ED 93
 r_c                            ; D8
 r_eq                           ; C8
 r_geu                          ; D0
 r_gtu                          ; 28 03 38 01 C9
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
 rdel                           ; CB 13 CB 12
 req                            ; C8
 res 0, (hl)                    ; CB 86
 res 0, (ix)                    ; DD CB 00 86
 res 0, (ix), a                 ; DD CB 00 87
 res 0, (ix), b                 ; DD CB 00 80
 res 0, (ix), c                 ; DD CB 00 81
 res 0, (ix), d                 ; DD CB 00 82
 res 0, (ix), e                 ; DD CB 00 83
 res 0, (ix), h                 ; DD CB 00 84
 res 0, (ix), l                 ; DD CB 00 85
 res 0, (ix+0)                  ; DD CB 00 86
 res 0, (ix+0), a               ; DD CB 00 87
 res 0, (ix+0), b               ; DD CB 00 80
 res 0, (ix+0), c               ; DD CB 00 81
 res 0, (ix+0), d               ; DD CB 00 82
 res 0, (ix+0), e               ; DD CB 00 83
 res 0, (ix+0), h               ; DD CB 00 84
 res 0, (ix+0), l               ; DD CB 00 85
 res 0, (ix+126)                ; DD CB 7E 86
 res 0, (ix+126), a             ; DD CB 7E 87
 res 0, (ix+126), b             ; DD CB 7E 80
 res 0, (ix+126), c             ; DD CB 7E 81
 res 0, (ix+126), d             ; DD CB 7E 82
 res 0, (ix+126), e             ; DD CB 7E 83
 res 0, (ix+126), h             ; DD CB 7E 84
 res 0, (ix+126), l             ; DD CB 7E 85
 res 0, (ix-128)                ; DD CB 80 86
 res 0, (ix-128), a             ; DD CB 80 87
 res 0, (ix-128), b             ; DD CB 80 80
 res 0, (ix-128), c             ; DD CB 80 81
 res 0, (ix-128), d             ; DD CB 80 82
 res 0, (ix-128), e             ; DD CB 80 83
 res 0, (ix-128), h             ; DD CB 80 84
 res 0, (ix-128), l             ; DD CB 80 85
 res 0, (iy)                    ; FD CB 00 86
 res 0, (iy), a                 ; FD CB 00 87
 res 0, (iy), b                 ; FD CB 00 80
 res 0, (iy), c                 ; FD CB 00 81
 res 0, (iy), d                 ; FD CB 00 82
 res 0, (iy), e                 ; FD CB 00 83
 res 0, (iy), h                 ; FD CB 00 84
 res 0, (iy), l                 ; FD CB 00 85
 res 0, (iy+0)                  ; FD CB 00 86
 res 0, (iy+0), a               ; FD CB 00 87
 res 0, (iy+0), b               ; FD CB 00 80
 res 0, (iy+0), c               ; FD CB 00 81
 res 0, (iy+0), d               ; FD CB 00 82
 res 0, (iy+0), e               ; FD CB 00 83
 res 0, (iy+0), h               ; FD CB 00 84
 res 0, (iy+0), l               ; FD CB 00 85
 res 0, (iy+126)                ; FD CB 7E 86
 res 0, (iy+126), a             ; FD CB 7E 87
 res 0, (iy+126), b             ; FD CB 7E 80
 res 0, (iy+126), c             ; FD CB 7E 81
 res 0, (iy+126), d             ; FD CB 7E 82
 res 0, (iy+126), e             ; FD CB 7E 83
 res 0, (iy+126), h             ; FD CB 7E 84
 res 0, (iy+126), l             ; FD CB 7E 85
 res 0, (iy-128)                ; FD CB 80 86
 res 0, (iy-128), a             ; FD CB 80 87
 res 0, (iy-128), b             ; FD CB 80 80
 res 0, (iy-128), c             ; FD CB 80 81
 res 0, (iy-128), d             ; FD CB 80 82
 res 0, (iy-128), e             ; FD CB 80 83
 res 0, (iy-128), h             ; FD CB 80 84
 res 0, (iy-128), l             ; FD CB 80 85
 res 0, a                       ; CB 87
 res 0, b                       ; CB 80
 res 0, c                       ; CB 81
 res 0, d                       ; CB 82
 res 0, e                       ; CB 83
 res 0, h                       ; CB 84
 res 0, l                       ; CB 85
 res 1, (hl)                    ; CB 8E
 res 1, (ix)                    ; DD CB 00 8E
 res 1, (ix), a                 ; DD CB 00 8F
 res 1, (ix), b                 ; DD CB 00 88
 res 1, (ix), c                 ; DD CB 00 89
 res 1, (ix), d                 ; DD CB 00 8A
 res 1, (ix), e                 ; DD CB 00 8B
 res 1, (ix), h                 ; DD CB 00 8C
 res 1, (ix), l                 ; DD CB 00 8D
 res 1, (ix+0)                  ; DD CB 00 8E
 res 1, (ix+0), a               ; DD CB 00 8F
 res 1, (ix+0), b               ; DD CB 00 88
 res 1, (ix+0), c               ; DD CB 00 89
 res 1, (ix+0), d               ; DD CB 00 8A
 res 1, (ix+0), e               ; DD CB 00 8B
 res 1, (ix+0), h               ; DD CB 00 8C
 res 1, (ix+0), l               ; DD CB 00 8D
 res 1, (ix+126)                ; DD CB 7E 8E
 res 1, (ix+126), a             ; DD CB 7E 8F
 res 1, (ix+126), b             ; DD CB 7E 88
 res 1, (ix+126), c             ; DD CB 7E 89
 res 1, (ix+126), d             ; DD CB 7E 8A
 res 1, (ix+126), e             ; DD CB 7E 8B
 res 1, (ix+126), h             ; DD CB 7E 8C
 res 1, (ix+126), l             ; DD CB 7E 8D
 res 1, (ix-128)                ; DD CB 80 8E
 res 1, (ix-128), a             ; DD CB 80 8F
 res 1, (ix-128), b             ; DD CB 80 88
 res 1, (ix-128), c             ; DD CB 80 89
 res 1, (ix-128), d             ; DD CB 80 8A
 res 1, (ix-128), e             ; DD CB 80 8B
 res 1, (ix-128), h             ; DD CB 80 8C
 res 1, (ix-128), l             ; DD CB 80 8D
 res 1, (iy)                    ; FD CB 00 8E
 res 1, (iy), a                 ; FD CB 00 8F
 res 1, (iy), b                 ; FD CB 00 88
 res 1, (iy), c                 ; FD CB 00 89
 res 1, (iy), d                 ; FD CB 00 8A
 res 1, (iy), e                 ; FD CB 00 8B
 res 1, (iy), h                 ; FD CB 00 8C
 res 1, (iy), l                 ; FD CB 00 8D
 res 1, (iy+0)                  ; FD CB 00 8E
 res 1, (iy+0), a               ; FD CB 00 8F
 res 1, (iy+0), b               ; FD CB 00 88
 res 1, (iy+0), c               ; FD CB 00 89
 res 1, (iy+0), d               ; FD CB 00 8A
 res 1, (iy+0), e               ; FD CB 00 8B
 res 1, (iy+0), h               ; FD CB 00 8C
 res 1, (iy+0), l               ; FD CB 00 8D
 res 1, (iy+126)                ; FD CB 7E 8E
 res 1, (iy+126), a             ; FD CB 7E 8F
 res 1, (iy+126), b             ; FD CB 7E 88
 res 1, (iy+126), c             ; FD CB 7E 89
 res 1, (iy+126), d             ; FD CB 7E 8A
 res 1, (iy+126), e             ; FD CB 7E 8B
 res 1, (iy+126), h             ; FD CB 7E 8C
 res 1, (iy+126), l             ; FD CB 7E 8D
 res 1, (iy-128)                ; FD CB 80 8E
 res 1, (iy-128), a             ; FD CB 80 8F
 res 1, (iy-128), b             ; FD CB 80 88
 res 1, (iy-128), c             ; FD CB 80 89
 res 1, (iy-128), d             ; FD CB 80 8A
 res 1, (iy-128), e             ; FD CB 80 8B
 res 1, (iy-128), h             ; FD CB 80 8C
 res 1, (iy-128), l             ; FD CB 80 8D
 res 1, a                       ; CB 8F
 res 1, b                       ; CB 88
 res 1, c                       ; CB 89
 res 1, d                       ; CB 8A
 res 1, e                       ; CB 8B
 res 1, h                       ; CB 8C
 res 1, l                       ; CB 8D
 res 2, (hl)                    ; CB 96
 res 2, (ix)                    ; DD CB 00 96
 res 2, (ix), a                 ; DD CB 00 97
 res 2, (ix), b                 ; DD CB 00 90
 res 2, (ix), c                 ; DD CB 00 91
 res 2, (ix), d                 ; DD CB 00 92
 res 2, (ix), e                 ; DD CB 00 93
 res 2, (ix), h                 ; DD CB 00 94
 res 2, (ix), l                 ; DD CB 00 95
 res 2, (ix+0)                  ; DD CB 00 96
 res 2, (ix+0), a               ; DD CB 00 97
 res 2, (ix+0), b               ; DD CB 00 90
 res 2, (ix+0), c               ; DD CB 00 91
 res 2, (ix+0), d               ; DD CB 00 92
 res 2, (ix+0), e               ; DD CB 00 93
 res 2, (ix+0), h               ; DD CB 00 94
 res 2, (ix+0), l               ; DD CB 00 95
 res 2, (ix+126)                ; DD CB 7E 96
 res 2, (ix+126), a             ; DD CB 7E 97
 res 2, (ix+126), b             ; DD CB 7E 90
 res 2, (ix+126), c             ; DD CB 7E 91
 res 2, (ix+126), d             ; DD CB 7E 92
 res 2, (ix+126), e             ; DD CB 7E 93
 res 2, (ix+126), h             ; DD CB 7E 94
 res 2, (ix+126), l             ; DD CB 7E 95
 res 2, (ix-128)                ; DD CB 80 96
 res 2, (ix-128), a             ; DD CB 80 97
 res 2, (ix-128), b             ; DD CB 80 90
 res 2, (ix-128), c             ; DD CB 80 91
 res 2, (ix-128), d             ; DD CB 80 92
 res 2, (ix-128), e             ; DD CB 80 93
 res 2, (ix-128), h             ; DD CB 80 94
 res 2, (ix-128), l             ; DD CB 80 95
 res 2, (iy)                    ; FD CB 00 96
 res 2, (iy), a                 ; FD CB 00 97
 res 2, (iy), b                 ; FD CB 00 90
 res 2, (iy), c                 ; FD CB 00 91
 res 2, (iy), d                 ; FD CB 00 92
 res 2, (iy), e                 ; FD CB 00 93
 res 2, (iy), h                 ; FD CB 00 94
 res 2, (iy), l                 ; FD CB 00 95
 res 2, (iy+0)                  ; FD CB 00 96
 res 2, (iy+0), a               ; FD CB 00 97
 res 2, (iy+0), b               ; FD CB 00 90
 res 2, (iy+0), c               ; FD CB 00 91
 res 2, (iy+0), d               ; FD CB 00 92
 res 2, (iy+0), e               ; FD CB 00 93
 res 2, (iy+0), h               ; FD CB 00 94
 res 2, (iy+0), l               ; FD CB 00 95
 res 2, (iy+126)                ; FD CB 7E 96
 res 2, (iy+126), a             ; FD CB 7E 97
 res 2, (iy+126), b             ; FD CB 7E 90
 res 2, (iy+126), c             ; FD CB 7E 91
 res 2, (iy+126), d             ; FD CB 7E 92
 res 2, (iy+126), e             ; FD CB 7E 93
 res 2, (iy+126), h             ; FD CB 7E 94
 res 2, (iy+126), l             ; FD CB 7E 95
 res 2, (iy-128)                ; FD CB 80 96
 res 2, (iy-128), a             ; FD CB 80 97
 res 2, (iy-128), b             ; FD CB 80 90
 res 2, (iy-128), c             ; FD CB 80 91
 res 2, (iy-128), d             ; FD CB 80 92
 res 2, (iy-128), e             ; FD CB 80 93
 res 2, (iy-128), h             ; FD CB 80 94
 res 2, (iy-128), l             ; FD CB 80 95
 res 2, a                       ; CB 97
 res 2, b                       ; CB 90
 res 2, c                       ; CB 91
 res 2, d                       ; CB 92
 res 2, e                       ; CB 93
 res 2, h                       ; CB 94
 res 2, l                       ; CB 95
 res 3, (hl)                    ; CB 9E
 res 3, (ix)                    ; DD CB 00 9E
 res 3, (ix), a                 ; DD CB 00 9F
 res 3, (ix), b                 ; DD CB 00 98
 res 3, (ix), c                 ; DD CB 00 99
 res 3, (ix), d                 ; DD CB 00 9A
 res 3, (ix), e                 ; DD CB 00 9B
 res 3, (ix), h                 ; DD CB 00 9C
 res 3, (ix), l                 ; DD CB 00 9D
 res 3, (ix+0)                  ; DD CB 00 9E
 res 3, (ix+0), a               ; DD CB 00 9F
 res 3, (ix+0), b               ; DD CB 00 98
 res 3, (ix+0), c               ; DD CB 00 99
 res 3, (ix+0), d               ; DD CB 00 9A
 res 3, (ix+0), e               ; DD CB 00 9B
 res 3, (ix+0), h               ; DD CB 00 9C
 res 3, (ix+0), l               ; DD CB 00 9D
 res 3, (ix+126)                ; DD CB 7E 9E
 res 3, (ix+126), a             ; DD CB 7E 9F
 res 3, (ix+126), b             ; DD CB 7E 98
 res 3, (ix+126), c             ; DD CB 7E 99
 res 3, (ix+126), d             ; DD CB 7E 9A
 res 3, (ix+126), e             ; DD CB 7E 9B
 res 3, (ix+126), h             ; DD CB 7E 9C
 res 3, (ix+126), l             ; DD CB 7E 9D
 res 3, (ix-128)                ; DD CB 80 9E
 res 3, (ix-128), a             ; DD CB 80 9F
 res 3, (ix-128), b             ; DD CB 80 98
 res 3, (ix-128), c             ; DD CB 80 99
 res 3, (ix-128), d             ; DD CB 80 9A
 res 3, (ix-128), e             ; DD CB 80 9B
 res 3, (ix-128), h             ; DD CB 80 9C
 res 3, (ix-128), l             ; DD CB 80 9D
 res 3, (iy)                    ; FD CB 00 9E
 res 3, (iy), a                 ; FD CB 00 9F
 res 3, (iy), b                 ; FD CB 00 98
 res 3, (iy), c                 ; FD CB 00 99
 res 3, (iy), d                 ; FD CB 00 9A
 res 3, (iy), e                 ; FD CB 00 9B
 res 3, (iy), h                 ; FD CB 00 9C
 res 3, (iy), l                 ; FD CB 00 9D
 res 3, (iy+0)                  ; FD CB 00 9E
 res 3, (iy+0), a               ; FD CB 00 9F
 res 3, (iy+0), b               ; FD CB 00 98
 res 3, (iy+0), c               ; FD CB 00 99
 res 3, (iy+0), d               ; FD CB 00 9A
 res 3, (iy+0), e               ; FD CB 00 9B
 res 3, (iy+0), h               ; FD CB 00 9C
 res 3, (iy+0), l               ; FD CB 00 9D
 res 3, (iy+126)                ; FD CB 7E 9E
 res 3, (iy+126), a             ; FD CB 7E 9F
 res 3, (iy+126), b             ; FD CB 7E 98
 res 3, (iy+126), c             ; FD CB 7E 99
 res 3, (iy+126), d             ; FD CB 7E 9A
 res 3, (iy+126), e             ; FD CB 7E 9B
 res 3, (iy+126), h             ; FD CB 7E 9C
 res 3, (iy+126), l             ; FD CB 7E 9D
 res 3, (iy-128)                ; FD CB 80 9E
 res 3, (iy-128), a             ; FD CB 80 9F
 res 3, (iy-128), b             ; FD CB 80 98
 res 3, (iy-128), c             ; FD CB 80 99
 res 3, (iy-128), d             ; FD CB 80 9A
 res 3, (iy-128), e             ; FD CB 80 9B
 res 3, (iy-128), h             ; FD CB 80 9C
 res 3, (iy-128), l             ; FD CB 80 9D
 res 3, a                       ; CB 9F
 res 3, b                       ; CB 98
 res 3, c                       ; CB 99
 res 3, d                       ; CB 9A
 res 3, e                       ; CB 9B
 res 3, h                       ; CB 9C
 res 3, l                       ; CB 9D
 res 4, (hl)                    ; CB A6
 res 4, (ix)                    ; DD CB 00 A6
 res 4, (ix), a                 ; DD CB 00 A7
 res 4, (ix), b                 ; DD CB 00 A0
 res 4, (ix), c                 ; DD CB 00 A1
 res 4, (ix), d                 ; DD CB 00 A2
 res 4, (ix), e                 ; DD CB 00 A3
 res 4, (ix), h                 ; DD CB 00 A4
 res 4, (ix), l                 ; DD CB 00 A5
 res 4, (ix+0)                  ; DD CB 00 A6
 res 4, (ix+0), a               ; DD CB 00 A7
 res 4, (ix+0), b               ; DD CB 00 A0
 res 4, (ix+0), c               ; DD CB 00 A1
 res 4, (ix+0), d               ; DD CB 00 A2
 res 4, (ix+0), e               ; DD CB 00 A3
 res 4, (ix+0), h               ; DD CB 00 A4
 res 4, (ix+0), l               ; DD CB 00 A5
 res 4, (ix+126)                ; DD CB 7E A6
 res 4, (ix+126), a             ; DD CB 7E A7
 res 4, (ix+126), b             ; DD CB 7E A0
 res 4, (ix+126), c             ; DD CB 7E A1
 res 4, (ix+126), d             ; DD CB 7E A2
 res 4, (ix+126), e             ; DD CB 7E A3
 res 4, (ix+126), h             ; DD CB 7E A4
 res 4, (ix+126), l             ; DD CB 7E A5
 res 4, (ix-128)                ; DD CB 80 A6
 res 4, (ix-128), a             ; DD CB 80 A7
 res 4, (ix-128), b             ; DD CB 80 A0
 res 4, (ix-128), c             ; DD CB 80 A1
 res 4, (ix-128), d             ; DD CB 80 A2
 res 4, (ix-128), e             ; DD CB 80 A3
 res 4, (ix-128), h             ; DD CB 80 A4
 res 4, (ix-128), l             ; DD CB 80 A5
 res 4, (iy)                    ; FD CB 00 A6
 res 4, (iy), a                 ; FD CB 00 A7
 res 4, (iy), b                 ; FD CB 00 A0
 res 4, (iy), c                 ; FD CB 00 A1
 res 4, (iy), d                 ; FD CB 00 A2
 res 4, (iy), e                 ; FD CB 00 A3
 res 4, (iy), h                 ; FD CB 00 A4
 res 4, (iy), l                 ; FD CB 00 A5
 res 4, (iy+0)                  ; FD CB 00 A6
 res 4, (iy+0), a               ; FD CB 00 A7
 res 4, (iy+0), b               ; FD CB 00 A0
 res 4, (iy+0), c               ; FD CB 00 A1
 res 4, (iy+0), d               ; FD CB 00 A2
 res 4, (iy+0), e               ; FD CB 00 A3
 res 4, (iy+0), h               ; FD CB 00 A4
 res 4, (iy+0), l               ; FD CB 00 A5
 res 4, (iy+126)                ; FD CB 7E A6
 res 4, (iy+126), a             ; FD CB 7E A7
 res 4, (iy+126), b             ; FD CB 7E A0
 res 4, (iy+126), c             ; FD CB 7E A1
 res 4, (iy+126), d             ; FD CB 7E A2
 res 4, (iy+126), e             ; FD CB 7E A3
 res 4, (iy+126), h             ; FD CB 7E A4
 res 4, (iy+126), l             ; FD CB 7E A5
 res 4, (iy-128)                ; FD CB 80 A6
 res 4, (iy-128), a             ; FD CB 80 A7
 res 4, (iy-128), b             ; FD CB 80 A0
 res 4, (iy-128), c             ; FD CB 80 A1
 res 4, (iy-128), d             ; FD CB 80 A2
 res 4, (iy-128), e             ; FD CB 80 A3
 res 4, (iy-128), h             ; FD CB 80 A4
 res 4, (iy-128), l             ; FD CB 80 A5
 res 4, a                       ; CB A7
 res 4, b                       ; CB A0
 res 4, c                       ; CB A1
 res 4, d                       ; CB A2
 res 4, e                       ; CB A3
 res 4, h                       ; CB A4
 res 4, l                       ; CB A5
 res 5, (hl)                    ; CB AE
 res 5, (ix)                    ; DD CB 00 AE
 res 5, (ix), a                 ; DD CB 00 AF
 res 5, (ix), b                 ; DD CB 00 A8
 res 5, (ix), c                 ; DD CB 00 A9
 res 5, (ix), d                 ; DD CB 00 AA
 res 5, (ix), e                 ; DD CB 00 AB
 res 5, (ix), h                 ; DD CB 00 AC
 res 5, (ix), l                 ; DD CB 00 AD
 res 5, (ix+0)                  ; DD CB 00 AE
 res 5, (ix+0), a               ; DD CB 00 AF
 res 5, (ix+0), b               ; DD CB 00 A8
 res 5, (ix+0), c               ; DD CB 00 A9
 res 5, (ix+0), d               ; DD CB 00 AA
 res 5, (ix+0), e               ; DD CB 00 AB
 res 5, (ix+0), h               ; DD CB 00 AC
 res 5, (ix+0), l               ; DD CB 00 AD
 res 5, (ix+126)                ; DD CB 7E AE
 res 5, (ix+126), a             ; DD CB 7E AF
 res 5, (ix+126), b             ; DD CB 7E A8
 res 5, (ix+126), c             ; DD CB 7E A9
 res 5, (ix+126), d             ; DD CB 7E AA
 res 5, (ix+126), e             ; DD CB 7E AB
 res 5, (ix+126), h             ; DD CB 7E AC
 res 5, (ix+126), l             ; DD CB 7E AD
 res 5, (ix-128)                ; DD CB 80 AE
 res 5, (ix-128), a             ; DD CB 80 AF
 res 5, (ix-128), b             ; DD CB 80 A8
 res 5, (ix-128), c             ; DD CB 80 A9
 res 5, (ix-128), d             ; DD CB 80 AA
 res 5, (ix-128), e             ; DD CB 80 AB
 res 5, (ix-128), h             ; DD CB 80 AC
 res 5, (ix-128), l             ; DD CB 80 AD
 res 5, (iy)                    ; FD CB 00 AE
 res 5, (iy), a                 ; FD CB 00 AF
 res 5, (iy), b                 ; FD CB 00 A8
 res 5, (iy), c                 ; FD CB 00 A9
 res 5, (iy), d                 ; FD CB 00 AA
 res 5, (iy), e                 ; FD CB 00 AB
 res 5, (iy), h                 ; FD CB 00 AC
 res 5, (iy), l                 ; FD CB 00 AD
 res 5, (iy+0)                  ; FD CB 00 AE
 res 5, (iy+0), a               ; FD CB 00 AF
 res 5, (iy+0), b               ; FD CB 00 A8
 res 5, (iy+0), c               ; FD CB 00 A9
 res 5, (iy+0), d               ; FD CB 00 AA
 res 5, (iy+0), e               ; FD CB 00 AB
 res 5, (iy+0), h               ; FD CB 00 AC
 res 5, (iy+0), l               ; FD CB 00 AD
 res 5, (iy+126)                ; FD CB 7E AE
 res 5, (iy+126), a             ; FD CB 7E AF
 res 5, (iy+126), b             ; FD CB 7E A8
 res 5, (iy+126), c             ; FD CB 7E A9
 res 5, (iy+126), d             ; FD CB 7E AA
 res 5, (iy+126), e             ; FD CB 7E AB
 res 5, (iy+126), h             ; FD CB 7E AC
 res 5, (iy+126), l             ; FD CB 7E AD
 res 5, (iy-128)                ; FD CB 80 AE
 res 5, (iy-128), a             ; FD CB 80 AF
 res 5, (iy-128), b             ; FD CB 80 A8
 res 5, (iy-128), c             ; FD CB 80 A9
 res 5, (iy-128), d             ; FD CB 80 AA
 res 5, (iy-128), e             ; FD CB 80 AB
 res 5, (iy-128), h             ; FD CB 80 AC
 res 5, (iy-128), l             ; FD CB 80 AD
 res 5, a                       ; CB AF
 res 5, b                       ; CB A8
 res 5, c                       ; CB A9
 res 5, d                       ; CB AA
 res 5, e                       ; CB AB
 res 5, h                       ; CB AC
 res 5, l                       ; CB AD
 res 6, (hl)                    ; CB B6
 res 6, (ix)                    ; DD CB 00 B6
 res 6, (ix), a                 ; DD CB 00 B7
 res 6, (ix), b                 ; DD CB 00 B0
 res 6, (ix), c                 ; DD CB 00 B1
 res 6, (ix), d                 ; DD CB 00 B2
 res 6, (ix), e                 ; DD CB 00 B3
 res 6, (ix), h                 ; DD CB 00 B4
 res 6, (ix), l                 ; DD CB 00 B5
 res 6, (ix+0)                  ; DD CB 00 B6
 res 6, (ix+0), a               ; DD CB 00 B7
 res 6, (ix+0), b               ; DD CB 00 B0
 res 6, (ix+0), c               ; DD CB 00 B1
 res 6, (ix+0), d               ; DD CB 00 B2
 res 6, (ix+0), e               ; DD CB 00 B3
 res 6, (ix+0), h               ; DD CB 00 B4
 res 6, (ix+0), l               ; DD CB 00 B5
 res 6, (ix+126)                ; DD CB 7E B6
 res 6, (ix+126), a             ; DD CB 7E B7
 res 6, (ix+126), b             ; DD CB 7E B0
 res 6, (ix+126), c             ; DD CB 7E B1
 res 6, (ix+126), d             ; DD CB 7E B2
 res 6, (ix+126), e             ; DD CB 7E B3
 res 6, (ix+126), h             ; DD CB 7E B4
 res 6, (ix+126), l             ; DD CB 7E B5
 res 6, (ix-128)                ; DD CB 80 B6
 res 6, (ix-128), a             ; DD CB 80 B7
 res 6, (ix-128), b             ; DD CB 80 B0
 res 6, (ix-128), c             ; DD CB 80 B1
 res 6, (ix-128), d             ; DD CB 80 B2
 res 6, (ix-128), e             ; DD CB 80 B3
 res 6, (ix-128), h             ; DD CB 80 B4
 res 6, (ix-128), l             ; DD CB 80 B5
 res 6, (iy)                    ; FD CB 00 B6
 res 6, (iy), a                 ; FD CB 00 B7
 res 6, (iy), b                 ; FD CB 00 B0
 res 6, (iy), c                 ; FD CB 00 B1
 res 6, (iy), d                 ; FD CB 00 B2
 res 6, (iy), e                 ; FD CB 00 B3
 res 6, (iy), h                 ; FD CB 00 B4
 res 6, (iy), l                 ; FD CB 00 B5
 res 6, (iy+0)                  ; FD CB 00 B6
 res 6, (iy+0), a               ; FD CB 00 B7
 res 6, (iy+0), b               ; FD CB 00 B0
 res 6, (iy+0), c               ; FD CB 00 B1
 res 6, (iy+0), d               ; FD CB 00 B2
 res 6, (iy+0), e               ; FD CB 00 B3
 res 6, (iy+0), h               ; FD CB 00 B4
 res 6, (iy+0), l               ; FD CB 00 B5
 res 6, (iy+126)                ; FD CB 7E B6
 res 6, (iy+126), a             ; FD CB 7E B7
 res 6, (iy+126), b             ; FD CB 7E B0
 res 6, (iy+126), c             ; FD CB 7E B1
 res 6, (iy+126), d             ; FD CB 7E B2
 res 6, (iy+126), e             ; FD CB 7E B3
 res 6, (iy+126), h             ; FD CB 7E B4
 res 6, (iy+126), l             ; FD CB 7E B5
 res 6, (iy-128)                ; FD CB 80 B6
 res 6, (iy-128), a             ; FD CB 80 B7
 res 6, (iy-128), b             ; FD CB 80 B0
 res 6, (iy-128), c             ; FD CB 80 B1
 res 6, (iy-128), d             ; FD CB 80 B2
 res 6, (iy-128), e             ; FD CB 80 B3
 res 6, (iy-128), h             ; FD CB 80 B4
 res 6, (iy-128), l             ; FD CB 80 B5
 res 6, a                       ; CB B7
 res 6, b                       ; CB B0
 res 6, c                       ; CB B1
 res 6, d                       ; CB B2
 res 6, e                       ; CB B3
 res 6, h                       ; CB B4
 res 6, l                       ; CB B5
 res 7, (hl)                    ; CB BE
 res 7, (ix)                    ; DD CB 00 BE
 res 7, (ix), a                 ; DD CB 00 BF
 res 7, (ix), b                 ; DD CB 00 B8
 res 7, (ix), c                 ; DD CB 00 B9
 res 7, (ix), d                 ; DD CB 00 BA
 res 7, (ix), e                 ; DD CB 00 BB
 res 7, (ix), h                 ; DD CB 00 BC
 res 7, (ix), l                 ; DD CB 00 BD
 res 7, (ix+0)                  ; DD CB 00 BE
 res 7, (ix+0), a               ; DD CB 00 BF
 res 7, (ix+0), b               ; DD CB 00 B8
 res 7, (ix+0), c               ; DD CB 00 B9
 res 7, (ix+0), d               ; DD CB 00 BA
 res 7, (ix+0), e               ; DD CB 00 BB
 res 7, (ix+0), h               ; DD CB 00 BC
 res 7, (ix+0), l               ; DD CB 00 BD
 res 7, (ix+126)                ; DD CB 7E BE
 res 7, (ix+126), a             ; DD CB 7E BF
 res 7, (ix+126), b             ; DD CB 7E B8
 res 7, (ix+126), c             ; DD CB 7E B9
 res 7, (ix+126), d             ; DD CB 7E BA
 res 7, (ix+126), e             ; DD CB 7E BB
 res 7, (ix+126), h             ; DD CB 7E BC
 res 7, (ix+126), l             ; DD CB 7E BD
 res 7, (ix-128)                ; DD CB 80 BE
 res 7, (ix-128), a             ; DD CB 80 BF
 res 7, (ix-128), b             ; DD CB 80 B8
 res 7, (ix-128), c             ; DD CB 80 B9
 res 7, (ix-128), d             ; DD CB 80 BA
 res 7, (ix-128), e             ; DD CB 80 BB
 res 7, (ix-128), h             ; DD CB 80 BC
 res 7, (ix-128), l             ; DD CB 80 BD
 res 7, (iy)                    ; FD CB 00 BE
 res 7, (iy), a                 ; FD CB 00 BF
 res 7, (iy), b                 ; FD CB 00 B8
 res 7, (iy), c                 ; FD CB 00 B9
 res 7, (iy), d                 ; FD CB 00 BA
 res 7, (iy), e                 ; FD CB 00 BB
 res 7, (iy), h                 ; FD CB 00 BC
 res 7, (iy), l                 ; FD CB 00 BD
 res 7, (iy+0)                  ; FD CB 00 BE
 res 7, (iy+0), a               ; FD CB 00 BF
 res 7, (iy+0), b               ; FD CB 00 B8
 res 7, (iy+0), c               ; FD CB 00 B9
 res 7, (iy+0), d               ; FD CB 00 BA
 res 7, (iy+0), e               ; FD CB 00 BB
 res 7, (iy+0), h               ; FD CB 00 BC
 res 7, (iy+0), l               ; FD CB 00 BD
 res 7, (iy+126)                ; FD CB 7E BE
 res 7, (iy+126), a             ; FD CB 7E BF
 res 7, (iy+126), b             ; FD CB 7E B8
 res 7, (iy+126), c             ; FD CB 7E B9
 res 7, (iy+126), d             ; FD CB 7E BA
 res 7, (iy+126), e             ; FD CB 7E BB
 res 7, (iy+126), h             ; FD CB 7E BC
 res 7, (iy+126), l             ; FD CB 7E BD
 res 7, (iy-128)                ; FD CB 80 BE
 res 7, (iy-128), a             ; FD CB 80 BF
 res 7, (iy-128), b             ; FD CB 80 B8
 res 7, (iy-128), c             ; FD CB 80 B9
 res 7, (iy-128), d             ; FD CB 80 BA
 res 7, (iy-128), e             ; FD CB 80 BB
 res 7, (iy-128), h             ; FD CB 80 BC
 res 7, (iy-128), l             ; FD CB 80 BD
 res 7, a                       ; CB BF
 res 7, b                       ; CB B8
 res 7, c                       ; CB B9
 res 7, d                       ; CB BA
 res 7, e                       ; CB BB
 res 7, h                       ; CB BC
 res 7, l                       ; CB BD
 ret                            ; C9
 ret c                          ; D8
 ret eq                         ; C8
 ret geu                        ; D0
 ret gtu                        ; 28 03 38 01 C9
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
 reti                           ; ED 4D
 retn                           ; ED 45
 rgeu                           ; D0
 rgtu                           ; 28 03 38 01 C9
 rl (hl)                        ; CB 16
 rl (ix)                        ; DD CB 00 16
 rl (ix), a                     ; DD CB 00 17
 rl (ix), b                     ; DD CB 00 10
 rl (ix), c                     ; DD CB 00 11
 rl (ix), d                     ; DD CB 00 12
 rl (ix), e                     ; DD CB 00 13
 rl (ix), h                     ; DD CB 00 14
 rl (ix), l                     ; DD CB 00 15
 rl (ix+0)                      ; DD CB 00 16
 rl (ix+0), a                   ; DD CB 00 17
 rl (ix+0), b                   ; DD CB 00 10
 rl (ix+0), c                   ; DD CB 00 11
 rl (ix+0), d                   ; DD CB 00 12
 rl (ix+0), e                   ; DD CB 00 13
 rl (ix+0), h                   ; DD CB 00 14
 rl (ix+0), l                   ; DD CB 00 15
 rl (ix+126)                    ; DD CB 7E 16
 rl (ix+126), a                 ; DD CB 7E 17
 rl (ix+126), b                 ; DD CB 7E 10
 rl (ix+126), c                 ; DD CB 7E 11
 rl (ix+126), d                 ; DD CB 7E 12
 rl (ix+126), e                 ; DD CB 7E 13
 rl (ix+126), h                 ; DD CB 7E 14
 rl (ix+126), l                 ; DD CB 7E 15
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
 rl (iy+0)                      ; FD CB 00 16
 rl (iy+0), a                   ; FD CB 00 17
 rl (iy+0), b                   ; FD CB 00 10
 rl (iy+0), c                   ; FD CB 00 11
 rl (iy+0), d                   ; FD CB 00 12
 rl (iy+0), e                   ; FD CB 00 13
 rl (iy+0), h                   ; FD CB 00 14
 rl (iy+0), l                   ; FD CB 00 15
 rl (iy+126)                    ; FD CB 7E 16
 rl (iy+126), a                 ; FD CB 7E 17
 rl (iy+126), b                 ; FD CB 7E 10
 rl (iy+126), c                 ; FD CB 7E 11
 rl (iy+126), d                 ; FD CB 7E 12
 rl (iy+126), e                 ; FD CB 7E 13
 rl (iy+126), h                 ; FD CB 7E 14
 rl (iy+126), l                 ; FD CB 7E 15
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
 rl bc                          ; CB 11 CB 10
 rl c                           ; CB 11
 rl d                           ; CB 12
 rl de                          ; CB 13 CB 12
 rl e                           ; CB 13
 rl h                           ; CB 14
 rl hl                          ; CB 15 CB 14
 rl l                           ; CB 15
 rla                            ; 17
 rlc                            ; 07
 rlc (hl)                       ; CB 06
 rlc (ix)                       ; DD CB 00 06
 rlc (ix), a                    ; DD CB 00 07
 rlc (ix), b                    ; DD CB 00 00
 rlc (ix), c                    ; DD CB 00 01
 rlc (ix), d                    ; DD CB 00 02
 rlc (ix), e                    ; DD CB 00 03
 rlc (ix), h                    ; DD CB 00 04
 rlc (ix), l                    ; DD CB 00 05
 rlc (ix+0)                     ; DD CB 00 06
 rlc (ix+0), a                  ; DD CB 00 07
 rlc (ix+0), b                  ; DD CB 00 00
 rlc (ix+0), c                  ; DD CB 00 01
 rlc (ix+0), d                  ; DD CB 00 02
 rlc (ix+0), e                  ; DD CB 00 03
 rlc (ix+0), h                  ; DD CB 00 04
 rlc (ix+0), l                  ; DD CB 00 05
 rlc (ix+126)                   ; DD CB 7E 06
 rlc (ix+126), a                ; DD CB 7E 07
 rlc (ix+126), b                ; DD CB 7E 00
 rlc (ix+126), c                ; DD CB 7E 01
 rlc (ix+126), d                ; DD CB 7E 02
 rlc (ix+126), e                ; DD CB 7E 03
 rlc (ix+126), h                ; DD CB 7E 04
 rlc (ix+126), l                ; DD CB 7E 05
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
 rlc (iy+0)                     ; FD CB 00 06
 rlc (iy+0), a                  ; FD CB 00 07
 rlc (iy+0), b                  ; FD CB 00 00
 rlc (iy+0), c                  ; FD CB 00 01
 rlc (iy+0), d                  ; FD CB 00 02
 rlc (iy+0), e                  ; FD CB 00 03
 rlc (iy+0), h                  ; FD CB 00 04
 rlc (iy+0), l                  ; FD CB 00 05
 rlc (iy+126)                   ; FD CB 7E 06
 rlc (iy+126), a                ; FD CB 7E 07
 rlc (iy+126), b                ; FD CB 7E 00
 rlc (iy+126), c                ; FD CB 7E 01
 rlc (iy+126), d                ; FD CB 7E 02
 rlc (iy+126), e                ; FD CB 7E 03
 rlc (iy+126), h                ; FD CB 7E 04
 rlc (iy+126), l                ; FD CB 7E 05
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
 rlc l                          ; CB 05
 rlca                           ; 07
 rld                            ; ED 6F
 rlde                           ; CB 13 CB 12
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
 rr (hl)                        ; CB 1E
 rr (ix)                        ; DD CB 00 1E
 rr (ix), a                     ; DD CB 00 1F
 rr (ix), b                     ; DD CB 00 18
 rr (ix), c                     ; DD CB 00 19
 rr (ix), d                     ; DD CB 00 1A
 rr (ix), e                     ; DD CB 00 1B
 rr (ix), h                     ; DD CB 00 1C
 rr (ix), l                     ; DD CB 00 1D
 rr (ix+0)                      ; DD CB 00 1E
 rr (ix+0), a                   ; DD CB 00 1F
 rr (ix+0), b                   ; DD CB 00 18
 rr (ix+0), c                   ; DD CB 00 19
 rr (ix+0), d                   ; DD CB 00 1A
 rr (ix+0), e                   ; DD CB 00 1B
 rr (ix+0), h                   ; DD CB 00 1C
 rr (ix+0), l                   ; DD CB 00 1D
 rr (ix+126)                    ; DD CB 7E 1E
 rr (ix+126), a                 ; DD CB 7E 1F
 rr (ix+126), b                 ; DD CB 7E 18
 rr (ix+126), c                 ; DD CB 7E 19
 rr (ix+126), d                 ; DD CB 7E 1A
 rr (ix+126), e                 ; DD CB 7E 1B
 rr (ix+126), h                 ; DD CB 7E 1C
 rr (ix+126), l                 ; DD CB 7E 1D
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
 rr (iy+0)                      ; FD CB 00 1E
 rr (iy+0), a                   ; FD CB 00 1F
 rr (iy+0), b                   ; FD CB 00 18
 rr (iy+0), c                   ; FD CB 00 19
 rr (iy+0), d                   ; FD CB 00 1A
 rr (iy+0), e                   ; FD CB 00 1B
 rr (iy+0), h                   ; FD CB 00 1C
 rr (iy+0), l                   ; FD CB 00 1D
 rr (iy+126)                    ; FD CB 7E 1E
 rr (iy+126), a                 ; FD CB 7E 1F
 rr (iy+126), b                 ; FD CB 7E 18
 rr (iy+126), c                 ; FD CB 7E 19
 rr (iy+126), d                 ; FD CB 7E 1A
 rr (iy+126), e                 ; FD CB 7E 1B
 rr (iy+126), h                 ; FD CB 7E 1C
 rr (iy+126), l                 ; FD CB 7E 1D
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
 rr bc                          ; CB 18 CB 19
 rr c                           ; CB 19
 rr d                           ; CB 1A
 rr de                          ; CB 1A CB 1B
 rr e                           ; CB 1B
 rr h                           ; CB 1C
 rr hl                          ; CB 1C CB 1D
 rr l                           ; CB 1D
 rra                            ; 1F
 rrc                            ; 0F
 rrc (hl)                       ; CB 0E
 rrc (ix)                       ; DD CB 00 0E
 rrc (ix), a                    ; DD CB 00 0F
 rrc (ix), b                    ; DD CB 00 08
 rrc (ix), c                    ; DD CB 00 09
 rrc (ix), d                    ; DD CB 00 0A
 rrc (ix), e                    ; DD CB 00 0B
 rrc (ix), h                    ; DD CB 00 0C
 rrc (ix), l                    ; DD CB 00 0D
 rrc (ix+0)                     ; DD CB 00 0E
 rrc (ix+0), a                  ; DD CB 00 0F
 rrc (ix+0), b                  ; DD CB 00 08
 rrc (ix+0), c                  ; DD CB 00 09
 rrc (ix+0), d                  ; DD CB 00 0A
 rrc (ix+0), e                  ; DD CB 00 0B
 rrc (ix+0), h                  ; DD CB 00 0C
 rrc (ix+0), l                  ; DD CB 00 0D
 rrc (ix+126)                   ; DD CB 7E 0E
 rrc (ix+126), a                ; DD CB 7E 0F
 rrc (ix+126), b                ; DD CB 7E 08
 rrc (ix+126), c                ; DD CB 7E 09
 rrc (ix+126), d                ; DD CB 7E 0A
 rrc (ix+126), e                ; DD CB 7E 0B
 rrc (ix+126), h                ; DD CB 7E 0C
 rrc (ix+126), l                ; DD CB 7E 0D
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
 rrc (iy+0)                     ; FD CB 00 0E
 rrc (iy+0), a                  ; FD CB 00 0F
 rrc (iy+0), b                  ; FD CB 00 08
 rrc (iy+0), c                  ; FD CB 00 09
 rrc (iy+0), d                  ; FD CB 00 0A
 rrc (iy+0), e                  ; FD CB 00 0B
 rrc (iy+0), h                  ; FD CB 00 0C
 rrc (iy+0), l                  ; FD CB 00 0D
 rrc (iy+126)                   ; FD CB 7E 0E
 rrc (iy+126), a                ; FD CB 7E 0F
 rrc (iy+126), b                ; FD CB 7E 08
 rrc (iy+126), c                ; FD CB 7E 09
 rrc (iy+126), d                ; FD CB 7E 0A
 rrc (iy+126), e                ; FD CB 7E 0B
 rrc (iy+126), h                ; FD CB 7E 0C
 rrc (iy+126), l                ; FD CB 7E 0D
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
 rrc l                          ; CB 0D
 rrca                           ; 0F
 rrd                            ; ED 67
 rrhl                           ; CB 2C CB 1D
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
 sbi -128                       ; DE 80
 sbi 0                          ; DE 00
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 scf                            ; 37
 set 0, (hl)                    ; CB C6
 set 0, (ix)                    ; DD CB 00 C6
 set 0, (ix), a                 ; DD CB 00 C7
 set 0, (ix), b                 ; DD CB 00 C0
 set 0, (ix), c                 ; DD CB 00 C1
 set 0, (ix), d                 ; DD CB 00 C2
 set 0, (ix), e                 ; DD CB 00 C3
 set 0, (ix), h                 ; DD CB 00 C4
 set 0, (ix), l                 ; DD CB 00 C5
 set 0, (ix+0)                  ; DD CB 00 C6
 set 0, (ix+0), a               ; DD CB 00 C7
 set 0, (ix+0), b               ; DD CB 00 C0
 set 0, (ix+0), c               ; DD CB 00 C1
 set 0, (ix+0), d               ; DD CB 00 C2
 set 0, (ix+0), e               ; DD CB 00 C3
 set 0, (ix+0), h               ; DD CB 00 C4
 set 0, (ix+0), l               ; DD CB 00 C5
 set 0, (ix+126)                ; DD CB 7E C6
 set 0, (ix+126), a             ; DD CB 7E C7
 set 0, (ix+126), b             ; DD CB 7E C0
 set 0, (ix+126), c             ; DD CB 7E C1
 set 0, (ix+126), d             ; DD CB 7E C2
 set 0, (ix+126), e             ; DD CB 7E C3
 set 0, (ix+126), h             ; DD CB 7E C4
 set 0, (ix+126), l             ; DD CB 7E C5
 set 0, (ix-128)                ; DD CB 80 C6
 set 0, (ix-128), a             ; DD CB 80 C7
 set 0, (ix-128), b             ; DD CB 80 C0
 set 0, (ix-128), c             ; DD CB 80 C1
 set 0, (ix-128), d             ; DD CB 80 C2
 set 0, (ix-128), e             ; DD CB 80 C3
 set 0, (ix-128), h             ; DD CB 80 C4
 set 0, (ix-128), l             ; DD CB 80 C5
 set 0, (iy)                    ; FD CB 00 C6
 set 0, (iy), a                 ; FD CB 00 C7
 set 0, (iy), b                 ; FD CB 00 C0
 set 0, (iy), c                 ; FD CB 00 C1
 set 0, (iy), d                 ; FD CB 00 C2
 set 0, (iy), e                 ; FD CB 00 C3
 set 0, (iy), h                 ; FD CB 00 C4
 set 0, (iy), l                 ; FD CB 00 C5
 set 0, (iy+0)                  ; FD CB 00 C6
 set 0, (iy+0), a               ; FD CB 00 C7
 set 0, (iy+0), b               ; FD CB 00 C0
 set 0, (iy+0), c               ; FD CB 00 C1
 set 0, (iy+0), d               ; FD CB 00 C2
 set 0, (iy+0), e               ; FD CB 00 C3
 set 0, (iy+0), h               ; FD CB 00 C4
 set 0, (iy+0), l               ; FD CB 00 C5
 set 0, (iy+126)                ; FD CB 7E C6
 set 0, (iy+126), a             ; FD CB 7E C7
 set 0, (iy+126), b             ; FD CB 7E C0
 set 0, (iy+126), c             ; FD CB 7E C1
 set 0, (iy+126), d             ; FD CB 7E C2
 set 0, (iy+126), e             ; FD CB 7E C3
 set 0, (iy+126), h             ; FD CB 7E C4
 set 0, (iy+126), l             ; FD CB 7E C5
 set 0, (iy-128)                ; FD CB 80 C6
 set 0, (iy-128), a             ; FD CB 80 C7
 set 0, (iy-128), b             ; FD CB 80 C0
 set 0, (iy-128), c             ; FD CB 80 C1
 set 0, (iy-128), d             ; FD CB 80 C2
 set 0, (iy-128), e             ; FD CB 80 C3
 set 0, (iy-128), h             ; FD CB 80 C4
 set 0, (iy-128), l             ; FD CB 80 C5
 set 0, a                       ; CB C7
 set 0, b                       ; CB C0
 set 0, c                       ; CB C1
 set 0, d                       ; CB C2
 set 0, e                       ; CB C3
 set 0, h                       ; CB C4
 set 0, l                       ; CB C5
 set 1, (hl)                    ; CB CE
 set 1, (ix)                    ; DD CB 00 CE
 set 1, (ix), a                 ; DD CB 00 CF
 set 1, (ix), b                 ; DD CB 00 C8
 set 1, (ix), c                 ; DD CB 00 C9
 set 1, (ix), d                 ; DD CB 00 CA
 set 1, (ix), e                 ; DD CB 00 CB
 set 1, (ix), h                 ; DD CB 00 CC
 set 1, (ix), l                 ; DD CB 00 CD
 set 1, (ix+0)                  ; DD CB 00 CE
 set 1, (ix+0), a               ; DD CB 00 CF
 set 1, (ix+0), b               ; DD CB 00 C8
 set 1, (ix+0), c               ; DD CB 00 C9
 set 1, (ix+0), d               ; DD CB 00 CA
 set 1, (ix+0), e               ; DD CB 00 CB
 set 1, (ix+0), h               ; DD CB 00 CC
 set 1, (ix+0), l               ; DD CB 00 CD
 set 1, (ix+126)                ; DD CB 7E CE
 set 1, (ix+126), a             ; DD CB 7E CF
 set 1, (ix+126), b             ; DD CB 7E C8
 set 1, (ix+126), c             ; DD CB 7E C9
 set 1, (ix+126), d             ; DD CB 7E CA
 set 1, (ix+126), e             ; DD CB 7E CB
 set 1, (ix+126), h             ; DD CB 7E CC
 set 1, (ix+126), l             ; DD CB 7E CD
 set 1, (ix-128)                ; DD CB 80 CE
 set 1, (ix-128), a             ; DD CB 80 CF
 set 1, (ix-128), b             ; DD CB 80 C8
 set 1, (ix-128), c             ; DD CB 80 C9
 set 1, (ix-128), d             ; DD CB 80 CA
 set 1, (ix-128), e             ; DD CB 80 CB
 set 1, (ix-128), h             ; DD CB 80 CC
 set 1, (ix-128), l             ; DD CB 80 CD
 set 1, (iy)                    ; FD CB 00 CE
 set 1, (iy), a                 ; FD CB 00 CF
 set 1, (iy), b                 ; FD CB 00 C8
 set 1, (iy), c                 ; FD CB 00 C9
 set 1, (iy), d                 ; FD CB 00 CA
 set 1, (iy), e                 ; FD CB 00 CB
 set 1, (iy), h                 ; FD CB 00 CC
 set 1, (iy), l                 ; FD CB 00 CD
 set 1, (iy+0)                  ; FD CB 00 CE
 set 1, (iy+0), a               ; FD CB 00 CF
 set 1, (iy+0), b               ; FD CB 00 C8
 set 1, (iy+0), c               ; FD CB 00 C9
 set 1, (iy+0), d               ; FD CB 00 CA
 set 1, (iy+0), e               ; FD CB 00 CB
 set 1, (iy+0), h               ; FD CB 00 CC
 set 1, (iy+0), l               ; FD CB 00 CD
 set 1, (iy+126)                ; FD CB 7E CE
 set 1, (iy+126), a             ; FD CB 7E CF
 set 1, (iy+126), b             ; FD CB 7E C8
 set 1, (iy+126), c             ; FD CB 7E C9
 set 1, (iy+126), d             ; FD CB 7E CA
 set 1, (iy+126), e             ; FD CB 7E CB
 set 1, (iy+126), h             ; FD CB 7E CC
 set 1, (iy+126), l             ; FD CB 7E CD
 set 1, (iy-128)                ; FD CB 80 CE
 set 1, (iy-128), a             ; FD CB 80 CF
 set 1, (iy-128), b             ; FD CB 80 C8
 set 1, (iy-128), c             ; FD CB 80 C9
 set 1, (iy-128), d             ; FD CB 80 CA
 set 1, (iy-128), e             ; FD CB 80 CB
 set 1, (iy-128), h             ; FD CB 80 CC
 set 1, (iy-128), l             ; FD CB 80 CD
 set 1, a                       ; CB CF
 set 1, b                       ; CB C8
 set 1, c                       ; CB C9
 set 1, d                       ; CB CA
 set 1, e                       ; CB CB
 set 1, h                       ; CB CC
 set 1, l                       ; CB CD
 set 2, (hl)                    ; CB D6
 set 2, (ix)                    ; DD CB 00 D6
 set 2, (ix), a                 ; DD CB 00 D7
 set 2, (ix), b                 ; DD CB 00 D0
 set 2, (ix), c                 ; DD CB 00 D1
 set 2, (ix), d                 ; DD CB 00 D2
 set 2, (ix), e                 ; DD CB 00 D3
 set 2, (ix), h                 ; DD CB 00 D4
 set 2, (ix), l                 ; DD CB 00 D5
 set 2, (ix+0)                  ; DD CB 00 D6
 set 2, (ix+0), a               ; DD CB 00 D7
 set 2, (ix+0), b               ; DD CB 00 D0
 set 2, (ix+0), c               ; DD CB 00 D1
 set 2, (ix+0), d               ; DD CB 00 D2
 set 2, (ix+0), e               ; DD CB 00 D3
 set 2, (ix+0), h               ; DD CB 00 D4
 set 2, (ix+0), l               ; DD CB 00 D5
 set 2, (ix+126)                ; DD CB 7E D6
 set 2, (ix+126), a             ; DD CB 7E D7
 set 2, (ix+126), b             ; DD CB 7E D0
 set 2, (ix+126), c             ; DD CB 7E D1
 set 2, (ix+126), d             ; DD CB 7E D2
 set 2, (ix+126), e             ; DD CB 7E D3
 set 2, (ix+126), h             ; DD CB 7E D4
 set 2, (ix+126), l             ; DD CB 7E D5
 set 2, (ix-128)                ; DD CB 80 D6
 set 2, (ix-128), a             ; DD CB 80 D7
 set 2, (ix-128), b             ; DD CB 80 D0
 set 2, (ix-128), c             ; DD CB 80 D1
 set 2, (ix-128), d             ; DD CB 80 D2
 set 2, (ix-128), e             ; DD CB 80 D3
 set 2, (ix-128), h             ; DD CB 80 D4
 set 2, (ix-128), l             ; DD CB 80 D5
 set 2, (iy)                    ; FD CB 00 D6
 set 2, (iy), a                 ; FD CB 00 D7
 set 2, (iy), b                 ; FD CB 00 D0
 set 2, (iy), c                 ; FD CB 00 D1
 set 2, (iy), d                 ; FD CB 00 D2
 set 2, (iy), e                 ; FD CB 00 D3
 set 2, (iy), h                 ; FD CB 00 D4
 set 2, (iy), l                 ; FD CB 00 D5
 set 2, (iy+0)                  ; FD CB 00 D6
 set 2, (iy+0), a               ; FD CB 00 D7
 set 2, (iy+0), b               ; FD CB 00 D0
 set 2, (iy+0), c               ; FD CB 00 D1
 set 2, (iy+0), d               ; FD CB 00 D2
 set 2, (iy+0), e               ; FD CB 00 D3
 set 2, (iy+0), h               ; FD CB 00 D4
 set 2, (iy+0), l               ; FD CB 00 D5
 set 2, (iy+126)                ; FD CB 7E D6
 set 2, (iy+126), a             ; FD CB 7E D7
 set 2, (iy+126), b             ; FD CB 7E D0
 set 2, (iy+126), c             ; FD CB 7E D1
 set 2, (iy+126), d             ; FD CB 7E D2
 set 2, (iy+126), e             ; FD CB 7E D3
 set 2, (iy+126), h             ; FD CB 7E D4
 set 2, (iy+126), l             ; FD CB 7E D5
 set 2, (iy-128)                ; FD CB 80 D6
 set 2, (iy-128), a             ; FD CB 80 D7
 set 2, (iy-128), b             ; FD CB 80 D0
 set 2, (iy-128), c             ; FD CB 80 D1
 set 2, (iy-128), d             ; FD CB 80 D2
 set 2, (iy-128), e             ; FD CB 80 D3
 set 2, (iy-128), h             ; FD CB 80 D4
 set 2, (iy-128), l             ; FD CB 80 D5
 set 2, a                       ; CB D7
 set 2, b                       ; CB D0
 set 2, c                       ; CB D1
 set 2, d                       ; CB D2
 set 2, e                       ; CB D3
 set 2, h                       ; CB D4
 set 2, l                       ; CB D5
 set 3, (hl)                    ; CB DE
 set 3, (ix)                    ; DD CB 00 DE
 set 3, (ix), a                 ; DD CB 00 DF
 set 3, (ix), b                 ; DD CB 00 D8
 set 3, (ix), c                 ; DD CB 00 D9
 set 3, (ix), d                 ; DD CB 00 DA
 set 3, (ix), e                 ; DD CB 00 DB
 set 3, (ix), h                 ; DD CB 00 DC
 set 3, (ix), l                 ; DD CB 00 DD
 set 3, (ix+0)                  ; DD CB 00 DE
 set 3, (ix+0), a               ; DD CB 00 DF
 set 3, (ix+0), b               ; DD CB 00 D8
 set 3, (ix+0), c               ; DD CB 00 D9
 set 3, (ix+0), d               ; DD CB 00 DA
 set 3, (ix+0), e               ; DD CB 00 DB
 set 3, (ix+0), h               ; DD CB 00 DC
 set 3, (ix+0), l               ; DD CB 00 DD
 set 3, (ix+126)                ; DD CB 7E DE
 set 3, (ix+126), a             ; DD CB 7E DF
 set 3, (ix+126), b             ; DD CB 7E D8
 set 3, (ix+126), c             ; DD CB 7E D9
 set 3, (ix+126), d             ; DD CB 7E DA
 set 3, (ix+126), e             ; DD CB 7E DB
 set 3, (ix+126), h             ; DD CB 7E DC
 set 3, (ix+126), l             ; DD CB 7E DD
 set 3, (ix-128)                ; DD CB 80 DE
 set 3, (ix-128), a             ; DD CB 80 DF
 set 3, (ix-128), b             ; DD CB 80 D8
 set 3, (ix-128), c             ; DD CB 80 D9
 set 3, (ix-128), d             ; DD CB 80 DA
 set 3, (ix-128), e             ; DD CB 80 DB
 set 3, (ix-128), h             ; DD CB 80 DC
 set 3, (ix-128), l             ; DD CB 80 DD
 set 3, (iy)                    ; FD CB 00 DE
 set 3, (iy), a                 ; FD CB 00 DF
 set 3, (iy), b                 ; FD CB 00 D8
 set 3, (iy), c                 ; FD CB 00 D9
 set 3, (iy), d                 ; FD CB 00 DA
 set 3, (iy), e                 ; FD CB 00 DB
 set 3, (iy), h                 ; FD CB 00 DC
 set 3, (iy), l                 ; FD CB 00 DD
 set 3, (iy+0)                  ; FD CB 00 DE
 set 3, (iy+0), a               ; FD CB 00 DF
 set 3, (iy+0), b               ; FD CB 00 D8
 set 3, (iy+0), c               ; FD CB 00 D9
 set 3, (iy+0), d               ; FD CB 00 DA
 set 3, (iy+0), e               ; FD CB 00 DB
 set 3, (iy+0), h               ; FD CB 00 DC
 set 3, (iy+0), l               ; FD CB 00 DD
 set 3, (iy+126)                ; FD CB 7E DE
 set 3, (iy+126), a             ; FD CB 7E DF
 set 3, (iy+126), b             ; FD CB 7E D8
 set 3, (iy+126), c             ; FD CB 7E D9
 set 3, (iy+126), d             ; FD CB 7E DA
 set 3, (iy+126), e             ; FD CB 7E DB
 set 3, (iy+126), h             ; FD CB 7E DC
 set 3, (iy+126), l             ; FD CB 7E DD
 set 3, (iy-128)                ; FD CB 80 DE
 set 3, (iy-128), a             ; FD CB 80 DF
 set 3, (iy-128), b             ; FD CB 80 D8
 set 3, (iy-128), c             ; FD CB 80 D9
 set 3, (iy-128), d             ; FD CB 80 DA
 set 3, (iy-128), e             ; FD CB 80 DB
 set 3, (iy-128), h             ; FD CB 80 DC
 set 3, (iy-128), l             ; FD CB 80 DD
 set 3, a                       ; CB DF
 set 3, b                       ; CB D8
 set 3, c                       ; CB D9
 set 3, d                       ; CB DA
 set 3, e                       ; CB DB
 set 3, h                       ; CB DC
 set 3, l                       ; CB DD
 set 4, (hl)                    ; CB E6
 set 4, (ix)                    ; DD CB 00 E6
 set 4, (ix), a                 ; DD CB 00 E7
 set 4, (ix), b                 ; DD CB 00 E0
 set 4, (ix), c                 ; DD CB 00 E1
 set 4, (ix), d                 ; DD CB 00 E2
 set 4, (ix), e                 ; DD CB 00 E3
 set 4, (ix), h                 ; DD CB 00 E4
 set 4, (ix), l                 ; DD CB 00 E5
 set 4, (ix+0)                  ; DD CB 00 E6
 set 4, (ix+0), a               ; DD CB 00 E7
 set 4, (ix+0), b               ; DD CB 00 E0
 set 4, (ix+0), c               ; DD CB 00 E1
 set 4, (ix+0), d               ; DD CB 00 E2
 set 4, (ix+0), e               ; DD CB 00 E3
 set 4, (ix+0), h               ; DD CB 00 E4
 set 4, (ix+0), l               ; DD CB 00 E5
 set 4, (ix+126)                ; DD CB 7E E6
 set 4, (ix+126), a             ; DD CB 7E E7
 set 4, (ix+126), b             ; DD CB 7E E0
 set 4, (ix+126), c             ; DD CB 7E E1
 set 4, (ix+126), d             ; DD CB 7E E2
 set 4, (ix+126), e             ; DD CB 7E E3
 set 4, (ix+126), h             ; DD CB 7E E4
 set 4, (ix+126), l             ; DD CB 7E E5
 set 4, (ix-128)                ; DD CB 80 E6
 set 4, (ix-128), a             ; DD CB 80 E7
 set 4, (ix-128), b             ; DD CB 80 E0
 set 4, (ix-128), c             ; DD CB 80 E1
 set 4, (ix-128), d             ; DD CB 80 E2
 set 4, (ix-128), e             ; DD CB 80 E3
 set 4, (ix-128), h             ; DD CB 80 E4
 set 4, (ix-128), l             ; DD CB 80 E5
 set 4, (iy)                    ; FD CB 00 E6
 set 4, (iy), a                 ; FD CB 00 E7
 set 4, (iy), b                 ; FD CB 00 E0
 set 4, (iy), c                 ; FD CB 00 E1
 set 4, (iy), d                 ; FD CB 00 E2
 set 4, (iy), e                 ; FD CB 00 E3
 set 4, (iy), h                 ; FD CB 00 E4
 set 4, (iy), l                 ; FD CB 00 E5
 set 4, (iy+0)                  ; FD CB 00 E6
 set 4, (iy+0), a               ; FD CB 00 E7
 set 4, (iy+0), b               ; FD CB 00 E0
 set 4, (iy+0), c               ; FD CB 00 E1
 set 4, (iy+0), d               ; FD CB 00 E2
 set 4, (iy+0), e               ; FD CB 00 E3
 set 4, (iy+0), h               ; FD CB 00 E4
 set 4, (iy+0), l               ; FD CB 00 E5
 set 4, (iy+126)                ; FD CB 7E E6
 set 4, (iy+126), a             ; FD CB 7E E7
 set 4, (iy+126), b             ; FD CB 7E E0
 set 4, (iy+126), c             ; FD CB 7E E1
 set 4, (iy+126), d             ; FD CB 7E E2
 set 4, (iy+126), e             ; FD CB 7E E3
 set 4, (iy+126), h             ; FD CB 7E E4
 set 4, (iy+126), l             ; FD CB 7E E5
 set 4, (iy-128)                ; FD CB 80 E6
 set 4, (iy-128), a             ; FD CB 80 E7
 set 4, (iy-128), b             ; FD CB 80 E0
 set 4, (iy-128), c             ; FD CB 80 E1
 set 4, (iy-128), d             ; FD CB 80 E2
 set 4, (iy-128), e             ; FD CB 80 E3
 set 4, (iy-128), h             ; FD CB 80 E4
 set 4, (iy-128), l             ; FD CB 80 E5
 set 4, a                       ; CB E7
 set 4, b                       ; CB E0
 set 4, c                       ; CB E1
 set 4, d                       ; CB E2
 set 4, e                       ; CB E3
 set 4, h                       ; CB E4
 set 4, l                       ; CB E5
 set 5, (hl)                    ; CB EE
 set 5, (ix)                    ; DD CB 00 EE
 set 5, (ix), a                 ; DD CB 00 EF
 set 5, (ix), b                 ; DD CB 00 E8
 set 5, (ix), c                 ; DD CB 00 E9
 set 5, (ix), d                 ; DD CB 00 EA
 set 5, (ix), e                 ; DD CB 00 EB
 set 5, (ix), h                 ; DD CB 00 EC
 set 5, (ix), l                 ; DD CB 00 ED
 set 5, (ix+0)                  ; DD CB 00 EE
 set 5, (ix+0), a               ; DD CB 00 EF
 set 5, (ix+0), b               ; DD CB 00 E8
 set 5, (ix+0), c               ; DD CB 00 E9
 set 5, (ix+0), d               ; DD CB 00 EA
 set 5, (ix+0), e               ; DD CB 00 EB
 set 5, (ix+0), h               ; DD CB 00 EC
 set 5, (ix+0), l               ; DD CB 00 ED
 set 5, (ix+126)                ; DD CB 7E EE
 set 5, (ix+126), a             ; DD CB 7E EF
 set 5, (ix+126), b             ; DD CB 7E E8
 set 5, (ix+126), c             ; DD CB 7E E9
 set 5, (ix+126), d             ; DD CB 7E EA
 set 5, (ix+126), e             ; DD CB 7E EB
 set 5, (ix+126), h             ; DD CB 7E EC
 set 5, (ix+126), l             ; DD CB 7E ED
 set 5, (ix-128)                ; DD CB 80 EE
 set 5, (ix-128), a             ; DD CB 80 EF
 set 5, (ix-128), b             ; DD CB 80 E8
 set 5, (ix-128), c             ; DD CB 80 E9
 set 5, (ix-128), d             ; DD CB 80 EA
 set 5, (ix-128), e             ; DD CB 80 EB
 set 5, (ix-128), h             ; DD CB 80 EC
 set 5, (ix-128), l             ; DD CB 80 ED
 set 5, (iy)                    ; FD CB 00 EE
 set 5, (iy), a                 ; FD CB 00 EF
 set 5, (iy), b                 ; FD CB 00 E8
 set 5, (iy), c                 ; FD CB 00 E9
 set 5, (iy), d                 ; FD CB 00 EA
 set 5, (iy), e                 ; FD CB 00 EB
 set 5, (iy), h                 ; FD CB 00 EC
 set 5, (iy), l                 ; FD CB 00 ED
 set 5, (iy+0)                  ; FD CB 00 EE
 set 5, (iy+0), a               ; FD CB 00 EF
 set 5, (iy+0), b               ; FD CB 00 E8
 set 5, (iy+0), c               ; FD CB 00 E9
 set 5, (iy+0), d               ; FD CB 00 EA
 set 5, (iy+0), e               ; FD CB 00 EB
 set 5, (iy+0), h               ; FD CB 00 EC
 set 5, (iy+0), l               ; FD CB 00 ED
 set 5, (iy+126)                ; FD CB 7E EE
 set 5, (iy+126), a             ; FD CB 7E EF
 set 5, (iy+126), b             ; FD CB 7E E8
 set 5, (iy+126), c             ; FD CB 7E E9
 set 5, (iy+126), d             ; FD CB 7E EA
 set 5, (iy+126), e             ; FD CB 7E EB
 set 5, (iy+126), h             ; FD CB 7E EC
 set 5, (iy+126), l             ; FD CB 7E ED
 set 5, (iy-128)                ; FD CB 80 EE
 set 5, (iy-128), a             ; FD CB 80 EF
 set 5, (iy-128), b             ; FD CB 80 E8
 set 5, (iy-128), c             ; FD CB 80 E9
 set 5, (iy-128), d             ; FD CB 80 EA
 set 5, (iy-128), e             ; FD CB 80 EB
 set 5, (iy-128), h             ; FD CB 80 EC
 set 5, (iy-128), l             ; FD CB 80 ED
 set 5, a                       ; CB EF
 set 5, b                       ; CB E8
 set 5, c                       ; CB E9
 set 5, d                       ; CB EA
 set 5, e                       ; CB EB
 set 5, h                       ; CB EC
 set 5, l                       ; CB ED
 set 6, (hl)                    ; CB F6
 set 6, (ix)                    ; DD CB 00 F6
 set 6, (ix), a                 ; DD CB 00 F7
 set 6, (ix), b                 ; DD CB 00 F0
 set 6, (ix), c                 ; DD CB 00 F1
 set 6, (ix), d                 ; DD CB 00 F2
 set 6, (ix), e                 ; DD CB 00 F3
 set 6, (ix), h                 ; DD CB 00 F4
 set 6, (ix), l                 ; DD CB 00 F5
 set 6, (ix+0)                  ; DD CB 00 F6
 set 6, (ix+0), a               ; DD CB 00 F7
 set 6, (ix+0), b               ; DD CB 00 F0
 set 6, (ix+0), c               ; DD CB 00 F1
 set 6, (ix+0), d               ; DD CB 00 F2
 set 6, (ix+0), e               ; DD CB 00 F3
 set 6, (ix+0), h               ; DD CB 00 F4
 set 6, (ix+0), l               ; DD CB 00 F5
 set 6, (ix+126)                ; DD CB 7E F6
 set 6, (ix+126), a             ; DD CB 7E F7
 set 6, (ix+126), b             ; DD CB 7E F0
 set 6, (ix+126), c             ; DD CB 7E F1
 set 6, (ix+126), d             ; DD CB 7E F2
 set 6, (ix+126), e             ; DD CB 7E F3
 set 6, (ix+126), h             ; DD CB 7E F4
 set 6, (ix+126), l             ; DD CB 7E F5
 set 6, (ix-128)                ; DD CB 80 F6
 set 6, (ix-128), a             ; DD CB 80 F7
 set 6, (ix-128), b             ; DD CB 80 F0
 set 6, (ix-128), c             ; DD CB 80 F1
 set 6, (ix-128), d             ; DD CB 80 F2
 set 6, (ix-128), e             ; DD CB 80 F3
 set 6, (ix-128), h             ; DD CB 80 F4
 set 6, (ix-128), l             ; DD CB 80 F5
 set 6, (iy)                    ; FD CB 00 F6
 set 6, (iy), a                 ; FD CB 00 F7
 set 6, (iy), b                 ; FD CB 00 F0
 set 6, (iy), c                 ; FD CB 00 F1
 set 6, (iy), d                 ; FD CB 00 F2
 set 6, (iy), e                 ; FD CB 00 F3
 set 6, (iy), h                 ; FD CB 00 F4
 set 6, (iy), l                 ; FD CB 00 F5
 set 6, (iy+0)                  ; FD CB 00 F6
 set 6, (iy+0), a               ; FD CB 00 F7
 set 6, (iy+0), b               ; FD CB 00 F0
 set 6, (iy+0), c               ; FD CB 00 F1
 set 6, (iy+0), d               ; FD CB 00 F2
 set 6, (iy+0), e               ; FD CB 00 F3
 set 6, (iy+0), h               ; FD CB 00 F4
 set 6, (iy+0), l               ; FD CB 00 F5
 set 6, (iy+126)                ; FD CB 7E F6
 set 6, (iy+126), a             ; FD CB 7E F7
 set 6, (iy+126), b             ; FD CB 7E F0
 set 6, (iy+126), c             ; FD CB 7E F1
 set 6, (iy+126), d             ; FD CB 7E F2
 set 6, (iy+126), e             ; FD CB 7E F3
 set 6, (iy+126), h             ; FD CB 7E F4
 set 6, (iy+126), l             ; FD CB 7E F5
 set 6, (iy-128)                ; FD CB 80 F6
 set 6, (iy-128), a             ; FD CB 80 F7
 set 6, (iy-128), b             ; FD CB 80 F0
 set 6, (iy-128), c             ; FD CB 80 F1
 set 6, (iy-128), d             ; FD CB 80 F2
 set 6, (iy-128), e             ; FD CB 80 F3
 set 6, (iy-128), h             ; FD CB 80 F4
 set 6, (iy-128), l             ; FD CB 80 F5
 set 6, a                       ; CB F7
 set 6, b                       ; CB F0
 set 6, c                       ; CB F1
 set 6, d                       ; CB F2
 set 6, e                       ; CB F3
 set 6, h                       ; CB F4
 set 6, l                       ; CB F5
 set 7, (hl)                    ; CB FE
 set 7, (ix)                    ; DD CB 00 FE
 set 7, (ix), a                 ; DD CB 00 FF
 set 7, (ix), b                 ; DD CB 00 F8
 set 7, (ix), c                 ; DD CB 00 F9
 set 7, (ix), d                 ; DD CB 00 FA
 set 7, (ix), e                 ; DD CB 00 FB
 set 7, (ix), h                 ; DD CB 00 FC
 set 7, (ix), l                 ; DD CB 00 FD
 set 7, (ix+0)                  ; DD CB 00 FE
 set 7, (ix+0), a               ; DD CB 00 FF
 set 7, (ix+0), b               ; DD CB 00 F8
 set 7, (ix+0), c               ; DD CB 00 F9
 set 7, (ix+0), d               ; DD CB 00 FA
 set 7, (ix+0), e               ; DD CB 00 FB
 set 7, (ix+0), h               ; DD CB 00 FC
 set 7, (ix+0), l               ; DD CB 00 FD
 set 7, (ix+126)                ; DD CB 7E FE
 set 7, (ix+126), a             ; DD CB 7E FF
 set 7, (ix+126), b             ; DD CB 7E F8
 set 7, (ix+126), c             ; DD CB 7E F9
 set 7, (ix+126), d             ; DD CB 7E FA
 set 7, (ix+126), e             ; DD CB 7E FB
 set 7, (ix+126), h             ; DD CB 7E FC
 set 7, (ix+126), l             ; DD CB 7E FD
 set 7, (ix-128)                ; DD CB 80 FE
 set 7, (ix-128), a             ; DD CB 80 FF
 set 7, (ix-128), b             ; DD CB 80 F8
 set 7, (ix-128), c             ; DD CB 80 F9
 set 7, (ix-128), d             ; DD CB 80 FA
 set 7, (ix-128), e             ; DD CB 80 FB
 set 7, (ix-128), h             ; DD CB 80 FC
 set 7, (ix-128), l             ; DD CB 80 FD
 set 7, (iy)                    ; FD CB 00 FE
 set 7, (iy), a                 ; FD CB 00 FF
 set 7, (iy), b                 ; FD CB 00 F8
 set 7, (iy), c                 ; FD CB 00 F9
 set 7, (iy), d                 ; FD CB 00 FA
 set 7, (iy), e                 ; FD CB 00 FB
 set 7, (iy), h                 ; FD CB 00 FC
 set 7, (iy), l                 ; FD CB 00 FD
 set 7, (iy+0)                  ; FD CB 00 FE
 set 7, (iy+0), a               ; FD CB 00 FF
 set 7, (iy+0), b               ; FD CB 00 F8
 set 7, (iy+0), c               ; FD CB 00 F9
 set 7, (iy+0), d               ; FD CB 00 FA
 set 7, (iy+0), e               ; FD CB 00 FB
 set 7, (iy+0), h               ; FD CB 00 FC
 set 7, (iy+0), l               ; FD CB 00 FD
 set 7, (iy+126)                ; FD CB 7E FE
 set 7, (iy+126), a             ; FD CB 7E FF
 set 7, (iy+126), b             ; FD CB 7E F8
 set 7, (iy+126), c             ; FD CB 7E F9
 set 7, (iy+126), d             ; FD CB 7E FA
 set 7, (iy+126), e             ; FD CB 7E FB
 set 7, (iy+126), h             ; FD CB 7E FC
 set 7, (iy+126), l             ; FD CB 7E FD
 set 7, (iy-128)                ; FD CB 80 FE
 set 7, (iy-128), a             ; FD CB 80 FF
 set 7, (iy-128), b             ; FD CB 80 F8
 set 7, (iy-128), c             ; FD CB 80 F9
 set 7, (iy-128), d             ; FD CB 80 FA
 set 7, (iy-128), e             ; FD CB 80 FB
 set 7, (iy-128), h             ; FD CB 80 FC
 set 7, (iy-128), l             ; FD CB 80 FD
 set 7, a                       ; CB FF
 set 7, b                       ; CB F8
 set 7, c                       ; CB F9
 set 7, d                       ; CB FA
 set 7, e                       ; CB FB
 set 7, h                       ; CB FC
 set 7, l                       ; CB FD
 setae                          ; ED 95
 shld 0x1234                    ; 22 34 12
 sla (hl)                       ; CB 26
 sla (ix)                       ; DD CB 00 26
 sla (ix), a                    ; DD CB 00 27
 sla (ix), b                    ; DD CB 00 20
 sla (ix), c                    ; DD CB 00 21
 sla (ix), d                    ; DD CB 00 22
 sla (ix), e                    ; DD CB 00 23
 sla (ix), h                    ; DD CB 00 24
 sla (ix), l                    ; DD CB 00 25
 sla (ix+0)                     ; DD CB 00 26
 sla (ix+0), a                  ; DD CB 00 27
 sla (ix+0), b                  ; DD CB 00 20
 sla (ix+0), c                  ; DD CB 00 21
 sla (ix+0), d                  ; DD CB 00 22
 sla (ix+0), e                  ; DD CB 00 23
 sla (ix+0), h                  ; DD CB 00 24
 sla (ix+0), l                  ; DD CB 00 25
 sla (ix+126)                   ; DD CB 7E 26
 sla (ix+126), a                ; DD CB 7E 27
 sla (ix+126), b                ; DD CB 7E 20
 sla (ix+126), c                ; DD CB 7E 21
 sla (ix+126), d                ; DD CB 7E 22
 sla (ix+126), e                ; DD CB 7E 23
 sla (ix+126), h                ; DD CB 7E 24
 sla (ix+126), l                ; DD CB 7E 25
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
 sla (iy+0)                     ; FD CB 00 26
 sla (iy+0), a                  ; FD CB 00 27
 sla (iy+0), b                  ; FD CB 00 20
 sla (iy+0), c                  ; FD CB 00 21
 sla (iy+0), d                  ; FD CB 00 22
 sla (iy+0), e                  ; FD CB 00 23
 sla (iy+0), h                  ; FD CB 00 24
 sla (iy+0), l                  ; FD CB 00 25
 sla (iy+126)                   ; FD CB 7E 26
 sla (iy+126), a                ; FD CB 7E 27
 sla (iy+126), b                ; FD CB 7E 20
 sla (iy+126), c                ; FD CB 7E 21
 sla (iy+126), d                ; FD CB 7E 22
 sla (iy+126), e                ; FD CB 7E 23
 sla (iy+126), h                ; FD CB 7E 24
 sla (iy+126), l                ; FD CB 7E 25
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
 sli (ix+0)                     ; DD CB 00 36
 sli (ix+0), a                  ; DD CB 00 37
 sli (ix+0), b                  ; DD CB 00 30
 sli (ix+0), c                  ; DD CB 00 31
 sli (ix+0), d                  ; DD CB 00 32
 sli (ix+0), e                  ; DD CB 00 33
 sli (ix+0), h                  ; DD CB 00 34
 sli (ix+0), l                  ; DD CB 00 35
 sli (ix+126)                   ; DD CB 7E 36
 sli (ix+126), a                ; DD CB 7E 37
 sli (ix+126), b                ; DD CB 7E 30
 sli (ix+126), c                ; DD CB 7E 31
 sli (ix+126), d                ; DD CB 7E 32
 sli (ix+126), e                ; DD CB 7E 33
 sli (ix+126), h                ; DD CB 7E 34
 sli (ix+126), l                ; DD CB 7E 35
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
 sli (iy+0)                     ; FD CB 00 36
 sli (iy+0), a                  ; FD CB 00 37
 sli (iy+0), b                  ; FD CB 00 30
 sli (iy+0), c                  ; FD CB 00 31
 sli (iy+0), d                  ; FD CB 00 32
 sli (iy+0), e                  ; FD CB 00 33
 sli (iy+0), h                  ; FD CB 00 34
 sli (iy+0), l                  ; FD CB 00 35
 sli (iy+126)                   ; FD CB 7E 36
 sli (iy+126), a                ; FD CB 7E 37
 sli (iy+126), b                ; FD CB 7E 30
 sli (iy+126), c                ; FD CB 7E 31
 sli (iy+126), d                ; FD CB 7E 32
 sli (iy+126), e                ; FD CB 7E 33
 sli (iy+126), h                ; FD CB 7E 34
 sli (iy+126), l                ; FD CB 7E 35
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
 sll (ix+0)                     ; DD CB 00 36
 sll (ix+0), a                  ; DD CB 00 37
 sll (ix+0), b                  ; DD CB 00 30
 sll (ix+0), c                  ; DD CB 00 31
 sll (ix+0), d                  ; DD CB 00 32
 sll (ix+0), e                  ; DD CB 00 33
 sll (ix+0), h                  ; DD CB 00 34
 sll (ix+0), l                  ; DD CB 00 35
 sll (ix+126)                   ; DD CB 7E 36
 sll (ix+126), a                ; DD CB 7E 37
 sll (ix+126), b                ; DD CB 7E 30
 sll (ix+126), c                ; DD CB 7E 31
 sll (ix+126), d                ; DD CB 7E 32
 sll (ix+126), e                ; DD CB 7E 33
 sll (ix+126), h                ; DD CB 7E 34
 sll (ix+126), l                ; DD CB 7E 35
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
 sll (iy+0)                     ; FD CB 00 36
 sll (iy+0), a                  ; FD CB 00 37
 sll (iy+0), b                  ; FD CB 00 30
 sll (iy+0), c                  ; FD CB 00 31
 sll (iy+0), d                  ; FD CB 00 32
 sll (iy+0), e                  ; FD CB 00 33
 sll (iy+0), h                  ; FD CB 00 34
 sll (iy+0), l                  ; FD CB 00 35
 sll (iy+126)                   ; FD CB 7E 36
 sll (iy+126), a                ; FD CB 7E 37
 sll (iy+126), b                ; FD CB 7E 30
 sll (iy+126), c                ; FD CB 7E 31
 sll (iy+126), d                ; FD CB 7E 32
 sll (iy+126), e                ; FD CB 7E 33
 sll (iy+126), h                ; FD CB 7E 34
 sll (iy+126), l                ; FD CB 7E 35
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
 sll l                          ; CB 35
 sls (hl)                       ; CB 36
 sls (ix)                       ; DD CB 00 36
 sls (ix), a                    ; DD CB 00 37
 sls (ix), b                    ; DD CB 00 30
 sls (ix), c                    ; DD CB 00 31
 sls (ix), d                    ; DD CB 00 32
 sls (ix), e                    ; DD CB 00 33
 sls (ix), h                    ; DD CB 00 34
 sls (ix), l                    ; DD CB 00 35
 sls (ix+0)                     ; DD CB 00 36
 sls (ix+0), a                  ; DD CB 00 37
 sls (ix+0), b                  ; DD CB 00 30
 sls (ix+0), c                  ; DD CB 00 31
 sls (ix+0), d                  ; DD CB 00 32
 sls (ix+0), e                  ; DD CB 00 33
 sls (ix+0), h                  ; DD CB 00 34
 sls (ix+0), l                  ; DD CB 00 35
 sls (ix+126)                   ; DD CB 7E 36
 sls (ix+126), a                ; DD CB 7E 37
 sls (ix+126), b                ; DD CB 7E 30
 sls (ix+126), c                ; DD CB 7E 31
 sls (ix+126), d                ; DD CB 7E 32
 sls (ix+126), e                ; DD CB 7E 33
 sls (ix+126), h                ; DD CB 7E 34
 sls (ix+126), l                ; DD CB 7E 35
 sls (ix-128)                   ; DD CB 80 36
 sls (ix-128), a                ; DD CB 80 37
 sls (ix-128), b                ; DD CB 80 30
 sls (ix-128), c                ; DD CB 80 31
 sls (ix-128), d                ; DD CB 80 32
 sls (ix-128), e                ; DD CB 80 33
 sls (ix-128), h                ; DD CB 80 34
 sls (ix-128), l                ; DD CB 80 35
 sls (iy)                       ; FD CB 00 36
 sls (iy), a                    ; FD CB 00 37
 sls (iy), b                    ; FD CB 00 30
 sls (iy), c                    ; FD CB 00 31
 sls (iy), d                    ; FD CB 00 32
 sls (iy), e                    ; FD CB 00 33
 sls (iy), h                    ; FD CB 00 34
 sls (iy), l                    ; FD CB 00 35
 sls (iy+0)                     ; FD CB 00 36
 sls (iy+0), a                  ; FD CB 00 37
 sls (iy+0), b                  ; FD CB 00 30
 sls (iy+0), c                  ; FD CB 00 31
 sls (iy+0), d                  ; FD CB 00 32
 sls (iy+0), e                  ; FD CB 00 33
 sls (iy+0), h                  ; FD CB 00 34
 sls (iy+0), l                  ; FD CB 00 35
 sls (iy+126)                   ; FD CB 7E 36
 sls (iy+126), a                ; FD CB 7E 37
 sls (iy+126), b                ; FD CB 7E 30
 sls (iy+126), c                ; FD CB 7E 31
 sls (iy+126), d                ; FD CB 7E 32
 sls (iy+126), e                ; FD CB 7E 33
 sls (iy+126), h                ; FD CB 7E 34
 sls (iy+126), l                ; FD CB 7E 35
 sls (iy-128)                   ; FD CB 80 36
 sls (iy-128), a                ; FD CB 80 37
 sls (iy-128), b                ; FD CB 80 30
 sls (iy-128), c                ; FD CB 80 31
 sls (iy-128), d                ; FD CB 80 32
 sls (iy-128), e                ; FD CB 80 33
 sls (iy-128), h                ; FD CB 80 34
 sls (iy-128), l                ; FD CB 80 35
 sls a                          ; CB 37
 sls b                          ; CB 30
 sls c                          ; CB 31
 sls d                          ; CB 32
 sls e                          ; CB 33
 sls h                          ; CB 34
 sls l                          ; CB 35
 sphl                           ; F9
 sra (hl)                       ; CB 2E
 sra (ix)                       ; DD CB 00 2E
 sra (ix), a                    ; DD CB 00 2F
 sra (ix), b                    ; DD CB 00 28
 sra (ix), c                    ; DD CB 00 29
 sra (ix), d                    ; DD CB 00 2A
 sra (ix), e                    ; DD CB 00 2B
 sra (ix), h                    ; DD CB 00 2C
 sra (ix), l                    ; DD CB 00 2D
 sra (ix+0)                     ; DD CB 00 2E
 sra (ix+0), a                  ; DD CB 00 2F
 sra (ix+0), b                  ; DD CB 00 28
 sra (ix+0), c                  ; DD CB 00 29
 sra (ix+0), d                  ; DD CB 00 2A
 sra (ix+0), e                  ; DD CB 00 2B
 sra (ix+0), h                  ; DD CB 00 2C
 sra (ix+0), l                  ; DD CB 00 2D
 sra (ix+126)                   ; DD CB 7E 2E
 sra (ix+126), a                ; DD CB 7E 2F
 sra (ix+126), b                ; DD CB 7E 28
 sra (ix+126), c                ; DD CB 7E 29
 sra (ix+126), d                ; DD CB 7E 2A
 sra (ix+126), e                ; DD CB 7E 2B
 sra (ix+126), h                ; DD CB 7E 2C
 sra (ix+126), l                ; DD CB 7E 2D
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
 sra (iy+0)                     ; FD CB 00 2E
 sra (iy+0), a                  ; FD CB 00 2F
 sra (iy+0), b                  ; FD CB 00 28
 sra (iy+0), c                  ; FD CB 00 29
 sra (iy+0), d                  ; FD CB 00 2A
 sra (iy+0), e                  ; FD CB 00 2B
 sra (iy+0), h                  ; FD CB 00 2C
 sra (iy+0), l                  ; FD CB 00 2D
 sra (iy+126)                   ; FD CB 7E 2E
 sra (iy+126), a                ; FD CB 7E 2F
 sra (iy+126), b                ; FD CB 7E 28
 sra (iy+126), c                ; FD CB 7E 29
 sra (iy+126), d                ; FD CB 7E 2A
 sra (iy+126), e                ; FD CB 7E 2B
 sra (iy+126), h                ; FD CB 7E 2C
 sra (iy+126), l                ; FD CB 7E 2D
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
 sra bc                         ; CB 28 CB 19
 sra c                          ; CB 29
 sra d                          ; CB 2A
 sra de                         ; CB 2A CB 1B
 sra e                          ; CB 2B
 sra h                          ; CB 2C
 sra hl                         ; CB 2C CB 1D
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
 srl (ix+0)                     ; DD CB 00 3E
 srl (ix+0), a                  ; DD CB 00 3F
 srl (ix+0), b                  ; DD CB 00 38
 srl (ix+0), c                  ; DD CB 00 39
 srl (ix+0), d                  ; DD CB 00 3A
 srl (ix+0), e                  ; DD CB 00 3B
 srl (ix+0), h                  ; DD CB 00 3C
 srl (ix+0), l                  ; DD CB 00 3D
 srl (ix+126)                   ; DD CB 7E 3E
 srl (ix+126), a                ; DD CB 7E 3F
 srl (ix+126), b                ; DD CB 7E 38
 srl (ix+126), c                ; DD CB 7E 39
 srl (ix+126), d                ; DD CB 7E 3A
 srl (ix+126), e                ; DD CB 7E 3B
 srl (ix+126), h                ; DD CB 7E 3C
 srl (ix+126), l                ; DD CB 7E 3D
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
 srl (iy+0)                     ; FD CB 00 3E
 srl (iy+0), a                  ; FD CB 00 3F
 srl (iy+0), b                  ; FD CB 00 38
 srl (iy+0), c                  ; FD CB 00 39
 srl (iy+0), d                  ; FD CB 00 3A
 srl (iy+0), e                  ; FD CB 00 3B
 srl (iy+0), h                  ; FD CB 00 3C
 srl (iy+0), l                  ; FD CB 00 3D
 srl (iy+126)                   ; FD CB 7E 3E
 srl (iy+126), a                ; FD CB 7E 3F
 srl (iy+126), b                ; FD CB 7E 38
 srl (iy+126), c                ; FD CB 7E 39
 srl (iy+126), d                ; FD CB 7E 3A
 srl (iy+126), e                ; FD CB 7E 3B
 srl (iy+126), h                ; FD CB 7E 3C
 srl (iy+126), l                ; FD CB 7E 3D
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
 srl l                          ; CB 3D
 sta 0x1234                     ; 32 34 12
 stae                           ; ED 95
 stax b                         ; 02
 stax bc                        ; 02
 stax d                         ; 12
 stax de                        ; 12
 stc                            ; 37
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
 sui -128                       ; D6 80
 sui 0                          ; D6 00
 sui 127                        ; D6 7F
 sui 255                        ; D6 FF
 swap                           ; ED 23
 swap a                         ; ED 23
 swapnib                        ; ED 23
 test -128                      ; ED 27 80
 test 0                         ; ED 27 00
 test 127                       ; ED 27 7F
 test 255                       ; ED 27 FF
 test a, -128                   ; ED 27 80
 test a, 0                      ; ED 27 00
 test a, 127                    ; ED 27 7F
 test a, 255                    ; ED 27 FF
 tst -128                       ; ED 27 80
 tst 0                          ; ED 27 00
 tst 127                        ; ED 27 7F
 tst 255                        ; ED 27 FF
 tst a, -128                    ; ED 27 80
 tst a, 0                       ; ED 27 00
 tst a, 127                     ; ED 27 7F
 tst a, 255                     ; ED 27 FF
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
 xor hl, bc                     ; F5 7C A8 67 7D A9 6F F1
 xor hl, de                     ; F5 7C AA 67 7D AB 6F F1
 xor ix, bc                     ; F5 DD 7C A8 DD 67 DD 7D A9 DD 6F F1
 xor ix, de                     ; F5 DD 7C AA DD 67 DD 7D AB DD 6F F1
 xor ixh                        ; DD AC
 xor ixl                        ; DD AD
 xor iy, bc                     ; F5 FD 7C A8 FD 67 FD 7D A9 FD 6F F1
 xor iy, de                     ; F5 FD 7C AA FD 67 FD 7D AB FD 6F F1
 xor iyh                        ; FD AC
 xor iyl                        ; FD AD
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
