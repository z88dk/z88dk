 aci -128                       ; CE 80
 aci 127                        ; CE 7F
 aci 255                        ; CE FF
 adc (hl)                       ; 8E
 adc (ix)                       ; FD 8E 00
 adc (ix+127)                   ; FD 8E 7F
 adc (ix-128)                   ; FD 8E 80
 adc (iy)                       ; DD 8E 00
 adc (iy+127)                   ; DD 8E 7F
 adc (iy-128)                   ; DD 8E 80
 adc -128                       ; CE 80
 adc 127                        ; CE 7F
 adc 255                        ; CE FF
 adc a                          ; 8F
 adc a, (hl)                    ; 8E
 adc a, (ix)                    ; FD 8E 00
 adc a, (ix+127)                ; FD 8E 7F
 adc a, (ix-128)                ; FD 8E 80
 adc a, (iy)                    ; DD 8E 00
 adc a, (iy+127)                ; DD 8E 7F
 adc a, (iy-128)                ; DD 8E 80
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
 adc hl, bc                     ; ED 4A
 adc hl, de                     ; ED 5A
 adc hl, hl                     ; ED 6A
 adc hl, sp                     ; ED 7A
 adc l                          ; 8D
 adc m                          ; 8E
 add (hl)                       ; 86
 add (ix)                       ; FD 86 00
 add (ix+127)                   ; FD 86 7F
 add (ix-128)                   ; FD 86 80
 add (iy)                       ; DD 86 00
 add (iy+127)                   ; DD 86 7F
 add (iy-128)                   ; DD 86 80
 add -128                       ; C6 80
 add 127                        ; C6 7F
 add 255                        ; C6 FF
 add a                          ; 87
 add a, (hl)                    ; 86
 add a, (ix)                    ; FD 86 00
 add a, (ix+127)                ; FD 86 7F
 add a, (ix-128)                ; FD 86 80
 add a, (iy)                    ; DD 86 00
 add a, (iy+127)                ; DD 86 7F
 add a, (iy-128)                ; DD 86 80
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
 add ix, bc                     ; FD 09
 add ix, de                     ; FD 19
 add ix, ix                     ; FD 29
 add ix, sp                     ; FD 39
 add iy, bc                     ; DD 09
 add iy, de                     ; DD 19
 add iy, iy                     ; DD 29
 add iy, sp                     ; DD 39
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
 and (ix)                       ; FD A6 00
 and (ix+127)                   ; FD A6 7F
 and (ix-128)                   ; FD A6 80
 and (iy)                       ; DD A6 00
 and (iy+127)                   ; DD A6 7F
 and (iy-128)                   ; DD A6 80
 and -128                       ; E6 80
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; A7
 and a, (hl)                    ; A6
 and a, (ix)                    ; FD A6 00
 and a, (ix+127)                ; FD A6 7F
 and a, (ix-128)                ; FD A6 80
 and a, (iy)                    ; DD A6 00
 and a, (iy+127)                ; DD A6 7F
 and a, (iy-128)                ; DD A6 80
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
 arhl                           ; CB 2C CB 1D
 bit 0, (hl)                    ; CB 46
 bit 0, (ix)                    ; FD CB 00 46
 bit 0, (ix+127)                ; FD CB 7F 46
 bit 0, (ix-128)                ; FD CB 80 46
 bit 0, (iy)                    ; DD CB 00 46
 bit 0, (iy+127)                ; DD CB 7F 46
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
 bit 1, (ix+127)                ; FD CB 7F 4E
 bit 1, (ix-128)                ; FD CB 80 4E
 bit 1, (iy)                    ; DD CB 00 4E
 bit 1, (iy+127)                ; DD CB 7F 4E
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
 bit 2, (ix+127)                ; FD CB 7F 56
 bit 2, (ix-128)                ; FD CB 80 56
 bit 2, (iy)                    ; DD CB 00 56
 bit 2, (iy+127)                ; DD CB 7F 56
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
 bit 3, (ix+127)                ; FD CB 7F 5E
 bit 3, (ix-128)                ; FD CB 80 5E
 bit 3, (iy)                    ; DD CB 00 5E
 bit 3, (iy+127)                ; DD CB 7F 5E
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
 bit 4, (ix+127)                ; FD CB 7F 66
 bit 4, (ix-128)                ; FD CB 80 66
 bit 4, (iy)                    ; DD CB 00 66
 bit 4, (iy+127)                ; DD CB 7F 66
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
 bit 5, (ix+127)                ; FD CB 7F 6E
 bit 5, (ix-128)                ; FD CB 80 6E
 bit 5, (iy)                    ; DD CB 00 6E
 bit 5, (iy+127)                ; DD CB 7F 6E
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
 bit 6, (ix+127)                ; FD CB 7F 76
 bit 6, (ix-128)                ; FD CB 80 76
 bit 6, (iy)                    ; DD CB 00 76
 bit 6, (iy+127)                ; DD CB 7F 76
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
 bit 7, (ix+127)                ; FD CB 7F 7E
 bit 7, (ix-128)                ; FD CB 80 7E
 bit 7, (iy)                    ; DD CB 00 7E
 bit 7, (iy+127)                ; DD CB 7F 7E
 bit 7, (iy-128)                ; DD CB 80 7E
 bit 7, a                       ; CB 7F
 bit 7, b                       ; CB 78
 bit 7, c                       ; CB 79
 bit 7, d                       ; CB 7A
 bit 7, e                       ; CB 7B
 bit 7, h                       ; CB 7C
 bit 7, l                       ; CB 7D
 bit.a 0, (hl)                  ; CB 46
 bit.a 0, (ix)                  ; FD CB 00 46
 bit.a 0, (ix+127)              ; FD CB 7F 46
 bit.a 0, (ix-128)              ; FD CB 80 46
 bit.a 0, (iy)                  ; DD CB 00 46
 bit.a 0, (iy+127)              ; DD CB 7F 46
 bit.a 0, (iy-128)              ; DD CB 80 46
 bit.a 0, a                     ; CB 47
 bit.a 0, b                     ; CB 40
 bit.a 0, c                     ; CB 41
 bit.a 0, d                     ; CB 42
 bit.a 0, e                     ; CB 43
 bit.a 0, h                     ; CB 44
 bit.a 0, l                     ; CB 45
 bit.a 1, (hl)                  ; CB 4E
 bit.a 1, (ix)                  ; FD CB 00 4E
 bit.a 1, (ix+127)              ; FD CB 7F 4E
 bit.a 1, (ix-128)              ; FD CB 80 4E
 bit.a 1, (iy)                  ; DD CB 00 4E
 bit.a 1, (iy+127)              ; DD CB 7F 4E
 bit.a 1, (iy-128)              ; DD CB 80 4E
 bit.a 1, a                     ; CB 4F
 bit.a 1, b                     ; CB 48
 bit.a 1, c                     ; CB 49
 bit.a 1, d                     ; CB 4A
 bit.a 1, e                     ; CB 4B
 bit.a 1, h                     ; CB 4C
 bit.a 1, l                     ; CB 4D
 bit.a 2, (hl)                  ; CB 56
 bit.a 2, (ix)                  ; FD CB 00 56
 bit.a 2, (ix+127)              ; FD CB 7F 56
 bit.a 2, (ix-128)              ; FD CB 80 56
 bit.a 2, (iy)                  ; DD CB 00 56
 bit.a 2, (iy+127)              ; DD CB 7F 56
 bit.a 2, (iy-128)              ; DD CB 80 56
 bit.a 2, a                     ; CB 57
 bit.a 2, b                     ; CB 50
 bit.a 2, c                     ; CB 51
 bit.a 2, d                     ; CB 52
 bit.a 2, e                     ; CB 53
 bit.a 2, h                     ; CB 54
 bit.a 2, l                     ; CB 55
 bit.a 3, (hl)                  ; CB 5E
 bit.a 3, (ix)                  ; FD CB 00 5E
 bit.a 3, (ix+127)              ; FD CB 7F 5E
 bit.a 3, (ix-128)              ; FD CB 80 5E
 bit.a 3, (iy)                  ; DD CB 00 5E
 bit.a 3, (iy+127)              ; DD CB 7F 5E
 bit.a 3, (iy-128)              ; DD CB 80 5E
 bit.a 3, a                     ; CB 5F
 bit.a 3, b                     ; CB 58
 bit.a 3, c                     ; CB 59
 bit.a 3, d                     ; CB 5A
 bit.a 3, e                     ; CB 5B
 bit.a 3, h                     ; CB 5C
 bit.a 3, l                     ; CB 5D
 bit.a 4, (hl)                  ; CB 66
 bit.a 4, (ix)                  ; FD CB 00 66
 bit.a 4, (ix+127)              ; FD CB 7F 66
 bit.a 4, (ix-128)              ; FD CB 80 66
 bit.a 4, (iy)                  ; DD CB 00 66
 bit.a 4, (iy+127)              ; DD CB 7F 66
 bit.a 4, (iy-128)              ; DD CB 80 66
 bit.a 4, a                     ; CB 67
 bit.a 4, b                     ; CB 60
 bit.a 4, c                     ; CB 61
 bit.a 4, d                     ; CB 62
 bit.a 4, e                     ; CB 63
 bit.a 4, h                     ; CB 64
 bit.a 4, l                     ; CB 65
 bit.a 5, (hl)                  ; CB 6E
 bit.a 5, (ix)                  ; FD CB 00 6E
 bit.a 5, (ix+127)              ; FD CB 7F 6E
 bit.a 5, (ix-128)              ; FD CB 80 6E
 bit.a 5, (iy)                  ; DD CB 00 6E
 bit.a 5, (iy+127)              ; DD CB 7F 6E
 bit.a 5, (iy-128)              ; DD CB 80 6E
 bit.a 5, a                     ; CB 6F
 bit.a 5, b                     ; CB 68
 bit.a 5, c                     ; CB 69
 bit.a 5, d                     ; CB 6A
 bit.a 5, e                     ; CB 6B
 bit.a 5, h                     ; CB 6C
 bit.a 5, l                     ; CB 6D
 bit.a 6, (hl)                  ; CB 76
 bit.a 6, (ix)                  ; FD CB 00 76
 bit.a 6, (ix+127)              ; FD CB 7F 76
 bit.a 6, (ix-128)              ; FD CB 80 76
 bit.a 6, (iy)                  ; DD CB 00 76
 bit.a 6, (iy+127)              ; DD CB 7F 76
 bit.a 6, (iy-128)              ; DD CB 80 76
 bit.a 6, a                     ; CB 77
 bit.a 6, b                     ; CB 70
 bit.a 6, c                     ; CB 71
 bit.a 6, d                     ; CB 72
 bit.a 6, e                     ; CB 73
 bit.a 6, h                     ; CB 74
 bit.a 6, l                     ; CB 75
 bit.a 7, (hl)                  ; CB 7E
 bit.a 7, (ix)                  ; FD CB 00 7E
 bit.a 7, (ix+127)              ; FD CB 7F 7E
 bit.a 7, (ix-128)              ; FD CB 80 7E
 bit.a 7, (iy)                  ; DD CB 00 7E
 bit.a 7, (iy+127)              ; DD CB 7F 7E
 bit.a 7, (iy-128)              ; DD CB 80 7E
 bit.a 7, a                     ; CB 7F
 bit.a 7, b                     ; CB 78
 bit.a 7, c                     ; CB 79
 bit.a 7, d                     ; CB 7A
 bit.a 7, e                     ; CB 7B
 bit.a 7, h                     ; CB 7C
 bit.a 7, l                     ; CB 7D
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
 cmp (ix)                       ; FD BE 00
 cmp (ix+127)                   ; FD BE 7F
 cmp (ix-128)                   ; FD BE 80
 cmp (iy)                       ; DD BE 00
 cmp (iy+127)                   ; DD BE 7F
 cmp (iy-128)                   ; DD BE 80
 cmp -128                       ; FE 80
 cmp 127                        ; FE 7F
 cmp 255                        ; FE FF
 cmp a                          ; BF
 cmp a, (hl)                    ; BE
 cmp a, (ix)                    ; FD BE 00
 cmp a, (ix+127)                ; FD BE 7F
 cmp a, (ix-128)                ; FD BE 80
 cmp a, (iy)                    ; DD BE 00
 cmp a, (iy+127)                ; DD BE 7F
 cmp a, (iy-128)                ; DD BE 80
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
 cp (ix)                        ; FD BE 00
 cp (ix+127)                    ; FD BE 7F
 cp (ix-128)                    ; FD BE 80
 cp (iy)                        ; DD BE 00
 cp (iy+127)                    ; DD BE 7F
 cp (iy-128)                    ; DD BE 80
 cp -128                        ; FE 80
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; BF
 cp a, (hl)                     ; BE
 cp a, (ix)                     ; FD BE 00
 cp a, (ix+127)                 ; FD BE 7F
 cp a, (ix-128)                 ; FD BE 80
 cp a, (iy)                     ; DD BE 00
 cp a, (iy+127)                 ; DD BE 7F
 cp a, (iy-128)                 ; DD BE 80
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
 cpd                            ; ED A9
 cpdr                           ; ED B9
 cpe -32768                     ; EC 00 80
 cpe 32767                      ; EC FF 7F
 cpe 65535                      ; EC FF FF
 cpi                            ; ED A1
 cpi -128                       ; FE 80
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpir                           ; ED B1
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
 dec (ix)                       ; FD 35 00
 dec (ix+127)                   ; FD 35 7F
 dec (ix-128)                   ; FD 35 80
 dec (iy)                       ; DD 35 00
 dec (iy+127)                   ; DD 35 7F
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
 dec iy                         ; DD 2B
 dec l                          ; 2D
 dec sp                         ; 3B
 di                             ; F3
 djnz ASMPC                     ; 10 FE
 djnz b, ASMPC                  ; 10 FE
 dsub                           ; CD @__z80asm__sub_hl_bc
 ei                             ; FB
 ex (sp), hl                    ; E3
 ex (sp), ix                    ; FD E3
 ex (sp), iy                    ; DD E3
 ex af, af                      ; 08
 ex af, af'                     ; 08
 ex de, hl                      ; EB
 exx                            ; D9
 halt                           ; 76
 hlt                            ; 76
 im 0                           ; ED 46
 im 1                           ; ED 56
 im 2                           ; ED 5E
 in (c)                         ; ED 70
 in -128                        ; DB 80
 in 127                         ; DB 7F
 in 255                         ; DB FF
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
 inc (ix)                       ; FD 34 00
 inc (ix+127)                   ; FD 34 7F
 inc (ix-128)                   ; FD 34 80
 inc (iy)                       ; DD 34 00
 inc (iy+127)                   ; DD 34 7F
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
 inc iy                         ; DD 23
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
 jp (bc)                        ; C5 C9
 jp (de)                        ; D5 C9
 jp (hl)                        ; E9
 jp (ix)                        ; FD E9
 jp (iy)                        ; DD E9
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
 ld (-32768), ix                ; FD 22 00 80
 ld (-32768), iy                ; DD 22 00 80
 ld (-32768), sp                ; ED 73 00 80
 ld (32767), a                  ; 32 FF 7F
 ld (32767), bc                 ; ED 43 FF 7F
 ld (32767), de                 ; ED 53 FF 7F
 ld (32767), hl                 ; 22 FF 7F
 ld (32767), ix                 ; FD 22 FF 7F
 ld (32767), iy                 ; DD 22 FF 7F
 ld (32767), sp                 ; ED 73 FF 7F
 ld (65535), a                  ; 32 FF FF
 ld (65535), bc                 ; ED 43 FF FF
 ld (65535), de                 ; ED 53 FF FF
 ld (65535), hl                 ; 22 FF FF
 ld (65535), ix                 ; FD 22 FF FF
 ld (65535), iy                 ; DD 22 FF FF
 ld (65535), sp                 ; ED 73 FF FF
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
 ld (ix), -128                  ; FD 36 00 80
 ld (ix), 127                   ; FD 36 00 7F
 ld (ix), 255                   ; FD 36 00 FF
 ld (ix), a                     ; FD 77 00
 ld (ix), b                     ; FD 70 00
 ld (ix), c                     ; FD 71 00
 ld (ix), d                     ; FD 72 00
 ld (ix), e                     ; FD 73 00
 ld (ix), h                     ; FD 74 00
 ld (ix), l                     ; FD 75 00
 ld (ix+127), -128              ; FD 36 7F 80
 ld (ix+127), 127               ; FD 36 7F 7F
 ld (ix+127), 255               ; FD 36 7F FF
 ld (ix+127), a                 ; FD 77 7F
 ld (ix+127), b                 ; FD 70 7F
 ld (ix+127), c                 ; FD 71 7F
 ld (ix+127), d                 ; FD 72 7F
 ld (ix+127), e                 ; FD 73 7F
 ld (ix+127), h                 ; FD 74 7F
 ld (ix+127), l                 ; FD 75 7F
 ld (ix-128), -128              ; FD 36 80 80
 ld (ix-128), 127               ; FD 36 80 7F
 ld (ix-128), 255               ; FD 36 80 FF
 ld (ix-128), a                 ; FD 77 80
 ld (ix-128), b                 ; FD 70 80
 ld (ix-128), c                 ; FD 71 80
 ld (ix-128), d                 ; FD 72 80
 ld (ix-128), e                 ; FD 73 80
 ld (ix-128), h                 ; FD 74 80
 ld (ix-128), l                 ; FD 75 80
 ld (iy), -128                  ; DD 36 00 80
 ld (iy), 127                   ; DD 36 00 7F
 ld (iy), 255                   ; DD 36 00 FF
 ld (iy), a                     ; DD 77 00
 ld (iy), b                     ; DD 70 00
 ld (iy), c                     ; DD 71 00
 ld (iy), d                     ; DD 72 00
 ld (iy), e                     ; DD 73 00
 ld (iy), h                     ; DD 74 00
 ld (iy), l                     ; DD 75 00
 ld (iy+127), -128              ; DD 36 7F 80
 ld (iy+127), 127               ; DD 36 7F 7F
 ld (iy+127), 255               ; DD 36 7F FF
 ld (iy+127), a                 ; DD 77 7F
 ld (iy+127), b                 ; DD 70 7F
 ld (iy+127), c                 ; DD 71 7F
 ld (iy+127), d                 ; DD 72 7F
 ld (iy+127), e                 ; DD 73 7F
 ld (iy+127), h                 ; DD 74 7F
 ld (iy+127), l                 ; DD 75 7F
 ld (iy-128), -128              ; DD 36 80 80
 ld (iy-128), 127               ; DD 36 80 7F
 ld (iy-128), 255               ; DD 36 80 FF
 ld (iy-128), a                 ; DD 77 80
 ld (iy-128), b                 ; DD 70 80
 ld (iy-128), c                 ; DD 71 80
 ld (iy-128), d                 ; DD 72 80
 ld (iy-128), e                 ; DD 73 80
 ld (iy-128), h                 ; DD 74 80
 ld (iy-128), l                 ; DD 75 80
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
 ld a, (ix)                     ; FD 7E 00
 ld a, (ix+127)                 ; FD 7E 7F
 ld a, (ix-128)                 ; FD 7E 80
 ld a, (iy)                     ; DD 7E 00
 ld a, (iy+127)                 ; DD 7E 7F
 ld a, (iy-128)                 ; DD 7E 80
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
 ld a, l                        ; 7D
 ld a, r                        ; ED 5F
 ld b, (hl)                     ; 46
 ld b, (ix)                     ; FD 46 00
 ld b, (ix+127)                 ; FD 46 7F
 ld b, (ix-128)                 ; FD 46 80
 ld b, (iy)                     ; DD 46 00
 ld b, (iy+127)                 ; DD 46 7F
 ld b, (iy-128)                 ; DD 46 80
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
 ld bc, (-32768)                ; ED 4B 00 80
 ld bc, (32767)                 ; ED 4B FF 7F
 ld bc, (65535)                 ; ED 4B FF FF
 ld bc, -32768                  ; 01 00 80
 ld bc, 32767                   ; 01 FF 7F
 ld bc, 65535                   ; 01 FF FF
 ld bc, de                      ; 42 4B
 ld bc, hl                      ; 44 4D
 ld c, (hl)                     ; 4E
 ld c, (ix)                     ; FD 4E 00
 ld c, (ix+127)                 ; FD 4E 7F
 ld c, (ix-128)                 ; FD 4E 80
 ld c, (iy)                     ; DD 4E 00
 ld c, (iy+127)                 ; DD 4E 7F
 ld c, (iy-128)                 ; DD 4E 80
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
 ld d, (ix)                     ; FD 56 00
 ld d, (ix+127)                 ; FD 56 7F
 ld d, (ix-128)                 ; FD 56 80
 ld d, (iy)                     ; DD 56 00
 ld d, (iy+127)                 ; DD 56 7F
 ld d, (iy-128)                 ; DD 56 80
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
 ld de, (-32768)                ; ED 5B 00 80
 ld de, (32767)                 ; ED 5B FF 7F
 ld de, (65535)                 ; ED 5B FF FF
 ld de, -32768                  ; 11 00 80
 ld de, 32767                   ; 11 FF 7F
 ld de, 65535                   ; 11 FF FF
 ld de, bc                      ; 50 59
 ld de, hl                      ; 54 5D
 ld de, sp                      ; EB 21 00 00 39 EB
