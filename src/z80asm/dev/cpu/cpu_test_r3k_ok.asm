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
 adc a', (hl)                   ; 76 8E
 adc a', (hl+)                  ; 76 8E 23
 adc a', (hl-)                  ; 76 8E 2B
 adc a', (ix)                   ; 76 DD 8E 00
 adc a', (ix+127)               ; 76 DD 8E 7F
 adc a', (ix-128)               ; 76 DD 8E 80
 adc a', (iy)                   ; 76 FD 8E 00
 adc a', (iy+127)               ; 76 FD 8E 7F
 adc a', (iy-128)               ; 76 FD 8E 80
 adc a', -128                   ; 76 CE 80
 adc a', 127                    ; 76 CE 7F
 adc a', 255                    ; 76 CE FF
 adc a', a                      ; 76 8F
 adc a', b                      ; 76 88
 adc a', c                      ; 76 89
 adc a', d                      ; 76 8A
 adc a', e                      ; 76 8B
 adc a', h                      ; 76 8C
 adc a', l                      ; 76 8D
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
 adc a, l                       ; 8D
 adc b                          ; 88
 adc c                          ; 89
 adc d                          ; 8A
 adc e                          ; 8B
 adc h                          ; 8C
 adc hl', bc                    ; 76 ED 4A
 adc hl', de                    ; 76 ED 5A
 adc hl', hl                    ; 76 ED 6A
 adc hl', sp                    ; 76 ED 7A
 adc hl, bc                     ; ED 4A
 adc hl, de                     ; ED 5A
 adc hl, hl                     ; ED 6A
 adc hl, sp                     ; ED 7A
 adc l                          ; 8D
 adc m                          ; 8E
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
 add a', (hl)                   ; 76 86
 add a', (hl+)                  ; 76 86 23
 add a', (hl-)                  ; 76 86 2B
 add a', (ix)                   ; 76 DD 86 00
 add a', (ix+127)               ; 76 DD 86 7F
 add a', (ix-128)               ; 76 DD 86 80
 add a', (iy)                   ; 76 FD 86 00
 add a', (iy+127)               ; 76 FD 86 7F
 add a', (iy-128)               ; 76 FD 86 80
 add a', -128                   ; 76 C6 80
 add a', 127                    ; 76 C6 7F
 add a', 255                    ; 76 C6 FF
 add a', a                      ; 76 87
 add a', b                      ; 76 80
 add a', c                      ; 76 81
 add a', d                      ; 76 82
 add a', e                      ; 76 83
 add a', h                      ; 76 84
 add a', l                      ; 76 85
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
 add hl', bc                    ; 76 09
 add hl', de                    ; 76 19
 add hl', hl                    ; 76 29
 add hl', sp                    ; 76 39
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
 add iy, bc                     ; FD 09
 add iy, de                     ; FD 19
 add iy, iy                     ; FD 29
 add iy, sp                     ; FD 39
 add l                          ; 85
 add m                          ; 86
 add sp, -128                   ; 27 80
 add sp, 127                    ; 27 7F
 adi -128                       ; C6 80
 adi 127                        ; C6 7F
 adi 255                        ; C6 FF
 altd adc (hl)                  ; 76 8E
 altd adc (hl+)                 ; 76 8E 23
 altd adc (hl-)                 ; 76 8E 2B
 altd adc (ix)                  ; 76 DD 8E 00
 altd adc (ix+127)              ; 76 DD 8E 7F
 altd adc (ix-128)              ; 76 DD 8E 80
 altd adc (iy)                  ; 76 FD 8E 00
 altd adc (iy+127)              ; 76 FD 8E 7F
 altd adc (iy-128)              ; 76 FD 8E 80
 altd adc -128                  ; 76 CE 80
 altd adc 127                   ; 76 CE 7F
 altd adc 255                   ; 76 CE FF
 altd adc a                     ; 76 8F
 altd adc a, (hl)               ; 76 8E
 altd adc a, (hl+)              ; 76 8E 23
 altd adc a, (hl-)              ; 76 8E 2B
 altd adc a, (ix)               ; 76 DD 8E 00
 altd adc a, (ix+127)           ; 76 DD 8E 7F
 altd adc a, (ix-128)           ; 76 DD 8E 80
 altd adc a, (iy)               ; 76 FD 8E 00
 altd adc a, (iy+127)           ; 76 FD 8E 7F
 altd adc a, (iy-128)           ; 76 FD 8E 80
 altd adc a, -128               ; 76 CE 80
 altd adc a, 127                ; 76 CE 7F
 altd adc a, 255                ; 76 CE FF
 altd adc a, a                  ; 76 8F
 altd adc a, b                  ; 76 88
 altd adc a, c                  ; 76 89
 altd adc a, d                  ; 76 8A
 altd adc a, e                  ; 76 8B
 altd adc a, h                  ; 76 8C
 altd adc a, l                  ; 76 8D
 altd adc b                     ; 76 88
 altd adc c                     ; 76 89
 altd adc d                     ; 76 8A
 altd adc e                     ; 76 8B
 altd adc h                     ; 76 8C
 altd adc hl, bc                ; 76 ED 4A
 altd adc hl, de                ; 76 ED 5A
 altd adc hl, hl                ; 76 ED 6A
 altd adc hl, sp                ; 76 ED 7A
 altd adc l                     ; 76 8D
 altd add (hl)                  ; 76 86
 altd add (hl+)                 ; 76 86 23
 altd add (hl-)                 ; 76 86 2B
 altd add (ix)                  ; 76 DD 86 00
 altd add (ix+127)              ; 76 DD 86 7F
 altd add (ix-128)              ; 76 DD 86 80
 altd add (iy)                  ; 76 FD 86 00
 altd add (iy+127)              ; 76 FD 86 7F
 altd add (iy-128)              ; 76 FD 86 80
 altd add -128                  ; 76 C6 80
 altd add 127                   ; 76 C6 7F
 altd add 255                   ; 76 C6 FF
 altd add a                     ; 76 87
 altd add a, (hl)               ; 76 86
 altd add a, (hl+)              ; 76 86 23
 altd add a, (hl-)              ; 76 86 2B
 altd add a, (ix)               ; 76 DD 86 00
 altd add a, (ix+127)           ; 76 DD 86 7F
 altd add a, (ix-128)           ; 76 DD 86 80
 altd add a, (iy)               ; 76 FD 86 00
 altd add a, (iy+127)           ; 76 FD 86 7F
 altd add a, (iy-128)           ; 76 FD 86 80
 altd add a, -128               ; 76 C6 80
 altd add a, 127                ; 76 C6 7F
 altd add a, 255                ; 76 C6 FF
 altd add a, a                  ; 76 87
 altd add a, b                  ; 76 80
 altd add a, c                  ; 76 81
 altd add a, d                  ; 76 82
 altd add a, e                  ; 76 83
 altd add a, h                  ; 76 84
 altd add a, l                  ; 76 85
 altd add b                     ; 76 80
 altd add c                     ; 76 81
 altd add d                     ; 76 82
 altd add e                     ; 76 83
 altd add h                     ; 76 84
 altd add hl, bc                ; 76 09
 altd add hl, de                ; 76 19
 altd add hl, hl                ; 76 29
 altd add hl, sp                ; 76 39
 altd add l                     ; 76 85
 altd and (hl)                  ; 76 A6
 altd and (hl+)                 ; 76 A6 23
 altd and (hl-)                 ; 76 A6 2B
 altd and (ix)                  ; 76 DD A6 00
 altd and (ix+127)              ; 76 DD A6 7F
 altd and (ix-128)              ; 76 DD A6 80
 altd and (iy)                  ; 76 FD A6 00
 altd and (iy+127)              ; 76 FD A6 7F
 altd and (iy-128)              ; 76 FD A6 80
 altd and -128                  ; 76 E6 80
 altd and 127                   ; 76 E6 7F
 altd and 255                   ; 76 E6 FF
 altd and a                     ; 76 A7
 altd and a, (hl)               ; 76 A6
 altd and a, (hl+)              ; 76 A6 23
 altd and a, (hl-)              ; 76 A6 2B
 altd and a, (ix)               ; 76 DD A6 00
 altd and a, (ix+127)           ; 76 DD A6 7F
 altd and a, (ix-128)           ; 76 DD A6 80
 altd and a, (iy)               ; 76 FD A6 00
 altd and a, (iy+127)           ; 76 FD A6 7F
 altd and a, (iy-128)           ; 76 FD A6 80
 altd and a, -128               ; 76 E6 80
 altd and a, 127                ; 76 E6 7F
 altd and a, 255                ; 76 E6 FF
 altd and a, a                  ; 76 A7
 altd and a, b                  ; 76 A0
 altd and a, c                  ; 76 A1
 altd and a, d                  ; 76 A2
 altd and a, e                  ; 76 A3
 altd and a, h                  ; 76 A4
 altd and a, l                  ; 76 A5
 altd and b                     ; 76 A0
 altd and c                     ; 76 A1
 altd and d                     ; 76 A2
 altd and e                     ; 76 A3
 altd and h                     ; 76 A4
 altd and hl, de                ; 76 DC
 altd and l                     ; 76 A5
 altd bit 0, (hl)               ; 76 CB 46
 altd bit 0, (ix)               ; 76 DD CB 00 46
 altd bit 0, (ix+127)           ; 76 DD CB 7F 46
 altd bit 0, (ix-128)           ; 76 DD CB 80 46
 altd bit 0, (iy)               ; 76 FD CB 00 46
 altd bit 0, (iy+127)           ; 76 FD CB 7F 46
 altd bit 0, (iy-128)           ; 76 FD CB 80 46
 altd bit 0, a                  ; 76 CB 47
 altd bit 0, b                  ; 76 CB 40
 altd bit 0, c                  ; 76 CB 41
 altd bit 0, d                  ; 76 CB 42
 altd bit 0, e                  ; 76 CB 43
 altd bit 0, h                  ; 76 CB 44
 altd bit 0, l                  ; 76 CB 45
 altd bit 1, (hl)               ; 76 CB 4E
 altd bit 1, (ix)               ; 76 DD CB 00 4E
 altd bit 1, (ix+127)           ; 76 DD CB 7F 4E
 altd bit 1, (ix-128)           ; 76 DD CB 80 4E
 altd bit 1, (iy)               ; 76 FD CB 00 4E
 altd bit 1, (iy+127)           ; 76 FD CB 7F 4E
 altd bit 1, (iy-128)           ; 76 FD CB 80 4E
 altd bit 1, a                  ; 76 CB 4F
 altd bit 1, b                  ; 76 CB 48
 altd bit 1, c                  ; 76 CB 49
 altd bit 1, d                  ; 76 CB 4A
 altd bit 1, e                  ; 76 CB 4B
 altd bit 1, h                  ; 76 CB 4C
 altd bit 1, l                  ; 76 CB 4D
 altd bit 2, (hl)               ; 76 CB 56
 altd bit 2, (ix)               ; 76 DD CB 00 56
 altd bit 2, (ix+127)           ; 76 DD CB 7F 56
 altd bit 2, (ix-128)           ; 76 DD CB 80 56
 altd bit 2, (iy)               ; 76 FD CB 00 56
 altd bit 2, (iy+127)           ; 76 FD CB 7F 56
 altd bit 2, (iy-128)           ; 76 FD CB 80 56
 altd bit 2, a                  ; 76 CB 57
 altd bit 2, b                  ; 76 CB 50
 altd bit 2, c                  ; 76 CB 51
 altd bit 2, d                  ; 76 CB 52
 altd bit 2, e                  ; 76 CB 53
 altd bit 2, h                  ; 76 CB 54
 altd bit 2, l                  ; 76 CB 55
 altd bit 3, (hl)               ; 76 CB 5E
 altd bit 3, (ix)               ; 76 DD CB 00 5E
 altd bit 3, (ix+127)           ; 76 DD CB 7F 5E
 altd bit 3, (ix-128)           ; 76 DD CB 80 5E
 altd bit 3, (iy)               ; 76 FD CB 00 5E
 altd bit 3, (iy+127)           ; 76 FD CB 7F 5E
 altd bit 3, (iy-128)           ; 76 FD CB 80 5E
 altd bit 3, a                  ; 76 CB 5F
 altd bit 3, b                  ; 76 CB 58
 altd bit 3, c                  ; 76 CB 59
 altd bit 3, d                  ; 76 CB 5A
 altd bit 3, e                  ; 76 CB 5B
 altd bit 3, h                  ; 76 CB 5C
 altd bit 3, l                  ; 76 CB 5D
 altd bit 4, (hl)               ; 76 CB 66
 altd bit 4, (ix)               ; 76 DD CB 00 66
 altd bit 4, (ix+127)           ; 76 DD CB 7F 66
 altd bit 4, (ix-128)           ; 76 DD CB 80 66
 altd bit 4, (iy)               ; 76 FD CB 00 66
 altd bit 4, (iy+127)           ; 76 FD CB 7F 66
 altd bit 4, (iy-128)           ; 76 FD CB 80 66
 altd bit 4, a                  ; 76 CB 67
 altd bit 4, b                  ; 76 CB 60
 altd bit 4, c                  ; 76 CB 61
 altd bit 4, d                  ; 76 CB 62
 altd bit 4, e                  ; 76 CB 63
 altd bit 4, h                  ; 76 CB 64
 altd bit 4, l                  ; 76 CB 65
 altd bit 5, (hl)               ; 76 CB 6E
 altd bit 5, (ix)               ; 76 DD CB 00 6E
 altd bit 5, (ix+127)           ; 76 DD CB 7F 6E
 altd bit 5, (ix-128)           ; 76 DD CB 80 6E
 altd bit 5, (iy)               ; 76 FD CB 00 6E
 altd bit 5, (iy+127)           ; 76 FD CB 7F 6E
 altd bit 5, (iy-128)           ; 76 FD CB 80 6E
 altd bit 5, a                  ; 76 CB 6F
 altd bit 5, b                  ; 76 CB 68
 altd bit 5, c                  ; 76 CB 69
 altd bit 5, d                  ; 76 CB 6A
 altd bit 5, e                  ; 76 CB 6B
 altd bit 5, h                  ; 76 CB 6C
 altd bit 5, l                  ; 76 CB 6D
 altd bit 6, (hl)               ; 76 CB 76
 altd bit 6, (ix)               ; 76 DD CB 00 76
 altd bit 6, (ix+127)           ; 76 DD CB 7F 76
 altd bit 6, (ix-128)           ; 76 DD CB 80 76
 altd bit 6, (iy)               ; 76 FD CB 00 76
 altd bit 6, (iy+127)           ; 76 FD CB 7F 76
 altd bit 6, (iy-128)           ; 76 FD CB 80 76
 altd bit 6, a                  ; 76 CB 77
 altd bit 6, b                  ; 76 CB 70
 altd bit 6, c                  ; 76 CB 71
 altd bit 6, d                  ; 76 CB 72
 altd bit 6, e                  ; 76 CB 73
 altd bit 6, h                  ; 76 CB 74
 altd bit 6, l                  ; 76 CB 75
 altd bit 7, (hl)               ; 76 CB 7E
 altd bit 7, (ix)               ; 76 DD CB 00 7E
 altd bit 7, (ix+127)           ; 76 DD CB 7F 7E
 altd bit 7, (ix-128)           ; 76 DD CB 80 7E
 altd bit 7, (iy)               ; 76 FD CB 00 7E
 altd bit 7, (iy+127)           ; 76 FD CB 7F 7E
 altd bit 7, (iy-128)           ; 76 FD CB 80 7E
 altd bit 7, a                  ; 76 CB 7F
 altd bit 7, b                  ; 76 CB 78
 altd bit 7, c                  ; 76 CB 79
 altd bit 7, d                  ; 76 CB 7A
 altd bit 7, e                  ; 76 CB 7B
 altd bit 7, h                  ; 76 CB 7C
 altd bit 7, l                  ; 76 CB 7D
 altd bool hl                   ; 76 CC
 altd ccf                       ; 76 3F
 altd cp (hl)                   ; 76 BE
 altd cp (hl+)                  ; 76 BE 23
 altd cp (hl-)                  ; 76 BE 2B
 altd cp (ix)                   ; 76 DD BE 00
 altd cp (ix+127)               ; 76 DD BE 7F
 altd cp (ix-128)               ; 76 DD BE 80
 altd cp (iy)                   ; 76 FD BE 00
 altd cp (iy+127)               ; 76 FD BE 7F
 altd cp (iy-128)               ; 76 FD BE 80
 altd cp -128                   ; 76 FE 80
 altd cp 127                    ; 76 FE 7F
 altd cp 255                    ; 76 FE FF
 altd cp a                      ; 76 BF
 altd cp a, (hl)                ; 76 BE
 altd cp a, (hl+)               ; 76 BE 23
 altd cp a, (hl-)               ; 76 BE 2B
 altd cp a, (ix)                ; 76 DD BE 00
 altd cp a, (ix+127)            ; 76 DD BE 7F
 altd cp a, (ix-128)            ; 76 DD BE 80
 altd cp a, (iy)                ; 76 FD BE 00
 altd cp a, (iy+127)            ; 76 FD BE 7F
 altd cp a, (iy-128)            ; 76 FD BE 80
 altd cp a, -128                ; 76 FE 80
 altd cp a, 127                 ; 76 FE 7F
 altd cp a, 255                 ; 76 FE FF
 altd cp a, a                   ; 76 BF
 altd cp a, b                   ; 76 B8
 altd cp a, c                   ; 76 B9
 altd cp a, d                   ; 76 BA
 altd cp a, e                   ; 76 BB
 altd cp a, h                   ; 76 BC
 altd cp a, l                   ; 76 BD
 altd cp b                      ; 76 B8
 altd cp c                      ; 76 B9
 altd cp d                      ; 76 BA
 altd cp e                      ; 76 BB
 altd cp h                      ; 76 BC
 altd cp l                      ; 76 BD
 altd cpl                       ; 76 2F
 altd cpl a                     ; 76 2F
 altd dec (hl)                  ; 76 35
 altd dec (hl+)                 ; 76 35 23
 altd dec (hl-)                 ; 76 35 2B
 altd dec (ix)                  ; 76 DD 35 00
 altd dec (ix+127)              ; 76 DD 35 7F
 altd dec (ix-128)              ; 76 DD 35 80
 altd dec (iy)                  ; 76 FD 35 00
 altd dec (iy+127)              ; 76 FD 35 7F
 altd dec (iy-128)              ; 76 FD 35 80
 altd dec a                     ; 76 3D
 altd dec b                     ; 76 05
 altd dec bc                    ; 76 0B
 altd dec c                     ; 76 0D
 altd dec d                     ; 76 15
 altd dec de                    ; 76 1B
 altd dec e                     ; 76 1D
 altd dec h                     ; 76 25
 altd dec hl                    ; 76 2B
 altd dec l                     ; 76 2D
 altd djnz ASMPC                ; 76 10 FE
 altd djnz b, ASMPC             ; 76 10 FE
 altd ex (sp), hl               ; 76 ED 54
 altd ex de', hl                ; 76 E3
 altd ex de, hl                 ; 76 EB
 altd inc (hl)                  ; 76 34
 altd inc (hl+)                 ; 76 34 23
 altd inc (hl-)                 ; 76 34 2B
 altd inc (ix)                  ; 76 DD 34 00
 altd inc (ix+127)              ; 76 DD 34 7F
 altd inc (ix-128)              ; 76 DD 34 80
 altd inc (iy)                  ; 76 FD 34 00
 altd inc (iy+127)              ; 76 FD 34 7F
 altd inc (iy-128)              ; 76 FD 34 80
 altd inc a                     ; 76 3C
 altd inc b                     ; 76 04
 altd inc bc                    ; 76 03
 altd inc c                     ; 76 0C
 altd inc d                     ; 76 14
 altd inc de                    ; 76 13
 altd inc e                     ; 76 1C
 altd inc h                     ; 76 24
 altd inc hl                    ; 76 23
 altd inc l                     ; 76 2C
 altd ioe adc (hl)              ; 76 DB 8E
 altd ioe adc (hl+)             ; 76 DB 8E 23
 altd ioe adc (hl-)             ; 76 DB 8E 2B
 altd ioe adc (ix)              ; 76 DB DD 8E 00
 altd ioe adc (ix+127)          ; 76 DB DD 8E 7F
 altd ioe adc (ix-128)          ; 76 DB DD 8E 80
 altd ioe adc (iy)              ; 76 DB FD 8E 00
 altd ioe adc (iy+127)          ; 76 DB FD 8E 7F
 altd ioe adc (iy-128)          ; 76 DB FD 8E 80
 altd ioe adc a, (hl)           ; 76 DB 8E
 altd ioe adc a, (hl+)          ; 76 DB 8E 23
 altd ioe adc a, (hl-)          ; 76 DB 8E 2B
 altd ioe adc a, (ix)           ; 76 DB DD 8E 00
 altd ioe adc a, (ix+127)       ; 76 DB DD 8E 7F
 altd ioe adc a, (ix-128)       ; 76 DB DD 8E 80
 altd ioe adc a, (iy)           ; 76 DB FD 8E 00
 altd ioe adc a, (iy+127)       ; 76 DB FD 8E 7F
 altd ioe adc a, (iy-128)       ; 76 DB FD 8E 80
 altd ioe add (hl)              ; 76 DB 86
 altd ioe add (hl+)             ; 76 DB 86 23
 altd ioe add (hl-)             ; 76 DB 86 2B
 altd ioe add (ix)              ; 76 DB DD 86 00
 altd ioe add (ix+127)          ; 76 DB DD 86 7F
 altd ioe add (ix-128)          ; 76 DB DD 86 80
 altd ioe add (iy)              ; 76 DB FD 86 00
 altd ioe add (iy+127)          ; 76 DB FD 86 7F
 altd ioe add (iy-128)          ; 76 DB FD 86 80
 altd ioe add a, (hl)           ; 76 DB 86
 altd ioe add a, (hl+)          ; 76 DB 86 23
 altd ioe add a, (hl-)          ; 76 DB 86 2B
 altd ioe add a, (ix)           ; 76 DB DD 86 00
 altd ioe add a, (ix+127)       ; 76 DB DD 86 7F
 altd ioe add a, (ix-128)       ; 76 DB DD 86 80
 altd ioe add a, (iy)           ; 76 DB FD 86 00
 altd ioe add a, (iy+127)       ; 76 DB FD 86 7F
 altd ioe add a, (iy-128)       ; 76 DB FD 86 80
 altd ioe and (hl)              ; 76 DB A6
 altd ioe and (hl+)             ; 76 DB A6 23
 altd ioe and (hl-)             ; 76 DB A6 2B
 altd ioe and (ix)              ; 76 DB DD A6 00
 altd ioe and (ix+127)          ; 76 DB DD A6 7F
 altd ioe and (ix-128)          ; 76 DB DD A6 80
 altd ioe and (iy)              ; 76 DB FD A6 00
 altd ioe and (iy+127)          ; 76 DB FD A6 7F
 altd ioe and (iy-128)          ; 76 DB FD A6 80
 altd ioe and a, (hl)           ; 76 DB A6
 altd ioe and a, (hl+)          ; 76 DB A6 23
 altd ioe and a, (hl-)          ; 76 DB A6 2B
 altd ioe and a, (ix)           ; 76 DB DD A6 00
 altd ioe and a, (ix+127)       ; 76 DB DD A6 7F
 altd ioe and a, (ix-128)       ; 76 DB DD A6 80
 altd ioe and a, (iy)           ; 76 DB FD A6 00
 altd ioe and a, (iy+127)       ; 76 DB FD A6 7F
 altd ioe and a, (iy-128)       ; 76 DB FD A6 80
 altd ioe bit 0, (hl)           ; 76 DB CB 46
 altd ioe bit 0, (ix)           ; 76 DB DD CB 00 46
 altd ioe bit 0, (ix+127)       ; 76 DB DD CB 7F 46
 altd ioe bit 0, (ix-128)       ; 76 DB DD CB 80 46
 altd ioe bit 0, (iy)           ; 76 DB FD CB 00 46
 altd ioe bit 0, (iy+127)       ; 76 DB FD CB 7F 46
 altd ioe bit 0, (iy-128)       ; 76 DB FD CB 80 46
 altd ioe bit 1, (hl)           ; 76 DB CB 4E
 altd ioe bit 1, (ix)           ; 76 DB DD CB 00 4E
 altd ioe bit 1, (ix+127)       ; 76 DB DD CB 7F 4E
 altd ioe bit 1, (ix-128)       ; 76 DB DD CB 80 4E
 altd ioe bit 1, (iy)           ; 76 DB FD CB 00 4E
 altd ioe bit 1, (iy+127)       ; 76 DB FD CB 7F 4E
 altd ioe bit 1, (iy-128)       ; 76 DB FD CB 80 4E
 altd ioe bit 2, (hl)           ; 76 DB CB 56
 altd ioe bit 2, (ix)           ; 76 DB DD CB 00 56
 altd ioe bit 2, (ix+127)       ; 76 DB DD CB 7F 56
 altd ioe bit 2, (ix-128)       ; 76 DB DD CB 80 56
 altd ioe bit 2, (iy)           ; 76 DB FD CB 00 56
 altd ioe bit 2, (iy+127)       ; 76 DB FD CB 7F 56
 altd ioe bit 2, (iy-128)       ; 76 DB FD CB 80 56
 altd ioe bit 3, (hl)           ; 76 DB CB 5E
 altd ioe bit 3, (ix)           ; 76 DB DD CB 00 5E
 altd ioe bit 3, (ix+127)       ; 76 DB DD CB 7F 5E
 altd ioe bit 3, (ix-128)       ; 76 DB DD CB 80 5E
 altd ioe bit 3, (iy)           ; 76 DB FD CB 00 5E
 altd ioe bit 3, (iy+127)       ; 76 DB FD CB 7F 5E
 altd ioe bit 3, (iy-128)       ; 76 DB FD CB 80 5E
 altd ioe bit 4, (hl)           ; 76 DB CB 66
 altd ioe bit 4, (ix)           ; 76 DB DD CB 00 66
 altd ioe bit 4, (ix+127)       ; 76 DB DD CB 7F 66
 altd ioe bit 4, (ix-128)       ; 76 DB DD CB 80 66
 altd ioe bit 4, (iy)           ; 76 DB FD CB 00 66
 altd ioe bit 4, (iy+127)       ; 76 DB FD CB 7F 66
 altd ioe bit 4, (iy-128)       ; 76 DB FD CB 80 66
 altd ioe bit 5, (hl)           ; 76 DB CB 6E
 altd ioe bit 5, (ix)           ; 76 DB DD CB 00 6E
 altd ioe bit 5, (ix+127)       ; 76 DB DD CB 7F 6E
 altd ioe bit 5, (ix-128)       ; 76 DB DD CB 80 6E
 altd ioe bit 5, (iy)           ; 76 DB FD CB 00 6E
 altd ioe bit 5, (iy+127)       ; 76 DB FD CB 7F 6E
 altd ioe bit 5, (iy-128)       ; 76 DB FD CB 80 6E
 altd ioe bit 6, (hl)           ; 76 DB CB 76
 altd ioe bit 6, (ix)           ; 76 DB DD CB 00 76
 altd ioe bit 6, (ix+127)       ; 76 DB DD CB 7F 76
 altd ioe bit 6, (ix-128)       ; 76 DB DD CB 80 76
 altd ioe bit 6, (iy)           ; 76 DB FD CB 00 76
 altd ioe bit 6, (iy+127)       ; 76 DB FD CB 7F 76
 altd ioe bit 6, (iy-128)       ; 76 DB FD CB 80 76
 altd ioe bit 7, (hl)           ; 76 DB CB 7E
 altd ioe bit 7, (ix)           ; 76 DB DD CB 00 7E
 altd ioe bit 7, (ix+127)       ; 76 DB DD CB 7F 7E
 altd ioe bit 7, (ix-128)       ; 76 DB DD CB 80 7E
 altd ioe bit 7, (iy)           ; 76 DB FD CB 00 7E
 altd ioe bit 7, (iy+127)       ; 76 DB FD CB 7F 7E
 altd ioe bit 7, (iy-128)       ; 76 DB FD CB 80 7E
 altd ioe cp (hl)               ; 76 DB BE
 altd ioe cp (hl+)              ; 76 DB BE 23
 altd ioe cp (hl-)              ; 76 DB BE 2B
 altd ioe cp (ix)               ; 76 DB DD BE 00
 altd ioe cp (ix+127)           ; 76 DB DD BE 7F
 altd ioe cp (ix-128)           ; 76 DB DD BE 80
 altd ioe cp (iy)               ; 76 DB FD BE 00
 altd ioe cp (iy+127)           ; 76 DB FD BE 7F
 altd ioe cp (iy-128)           ; 76 DB FD BE 80
 altd ioe cp a, (hl)            ; 76 DB BE
 altd ioe cp a, (hl+)           ; 76 DB BE 23
 altd ioe cp a, (hl-)           ; 76 DB BE 2B
 altd ioe cp a, (ix)            ; 76 DB DD BE 00
 altd ioe cp a, (ix+127)        ; 76 DB DD BE 7F
 altd ioe cp a, (ix-128)        ; 76 DB DD BE 80
 altd ioe cp a, (iy)            ; 76 DB FD BE 00
 altd ioe cp a, (iy+127)        ; 76 DB FD BE 7F
 altd ioe cp a, (iy-128)        ; 76 DB FD BE 80
 altd ioe dec (hl)              ; 76 DB 35
 altd ioe dec (hl+)             ; 76 DB 35 23
 altd ioe dec (hl-)             ; 76 DB 35 2B
 altd ioe dec (ix)              ; 76 DB DD 35 00
 altd ioe dec (ix+127)          ; 76 DB DD 35 7F
 altd ioe dec (ix-128)          ; 76 DB DD 35 80
 altd ioe dec (iy)              ; 76 DB FD 35 00
 altd ioe dec (iy+127)          ; 76 DB FD 35 7F
 altd ioe dec (iy-128)          ; 76 DB FD 35 80
 altd ioe inc (hl)              ; 76 DB 34
 altd ioe inc (hl+)             ; 76 DB 34 23
 altd ioe inc (hl-)             ; 76 DB 34 2B
 altd ioe inc (ix)              ; 76 DB DD 34 00
 altd ioe inc (ix+127)          ; 76 DB DD 34 7F
 altd ioe inc (ix-128)          ; 76 DB DD 34 80
 altd ioe inc (iy)              ; 76 DB FD 34 00
 altd ioe inc (iy+127)          ; 76 DB FD 34 7F
 altd ioe inc (iy-128)          ; 76 DB FD 34 80
 altd ioe ld a, (-32768)        ; 76 DB 3A 00 80
 altd ioe ld a, (32767)         ; 76 DB 3A FF 7F
 altd ioe ld a, (65535)         ; 76 DB 3A FF FF
 altd ioe ld a, (bc)            ; 76 DB 0A
 altd ioe ld a, (bc+)           ; 76 DB 0A 03
 altd ioe ld a, (bc-)           ; 76 DB 0A 0B
 altd ioe ld a, (de)            ; 76 DB 1A
 altd ioe ld a, (de+)           ; 76 DB 1A 13
 altd ioe ld a, (de-)           ; 76 DB 1A 1B
 altd ioe ld a, (hl)            ; 76 DB 7E
 altd ioe ld a, (hl+)           ; 76 DB 7E 23
 altd ioe ld a, (hl-)           ; 76 DB 7E 2B
 altd ioe ld a, (hld)           ; 76 DB 7E 2B
 altd ioe ld a, (hli)           ; 76 DB 7E 23
 altd ioe ld a, (ix)            ; 76 DB DD 7E 00
 altd ioe ld a, (ix+127)        ; 76 DB DD 7E 7F
 altd ioe ld a, (ix-128)        ; 76 DB DD 7E 80
 altd ioe ld a, (iy)            ; 76 DB FD 7E 00
 altd ioe ld a, (iy+127)        ; 76 DB FD 7E 7F
 altd ioe ld a, (iy-128)        ; 76 DB FD 7E 80
 altd ioe ld b, (hl)            ; 76 DB 46
 altd ioe ld b, (hl+)           ; 76 DB 46 23
 altd ioe ld b, (hl-)           ; 76 DB 46 2B
 altd ioe ld b, (hld)           ; 76 DB 46 2B
 altd ioe ld b, (hli)           ; 76 DB 46 23
 altd ioe ld b, (ix)            ; 76 DB DD 46 00
 altd ioe ld b, (ix+127)        ; 76 DB DD 46 7F
 altd ioe ld b, (ix-128)        ; 76 DB DD 46 80
 altd ioe ld b, (iy)            ; 76 DB FD 46 00
 altd ioe ld b, (iy+127)        ; 76 DB FD 46 7F
 altd ioe ld b, (iy-128)        ; 76 DB FD 46 80
 altd ioe ld bc, (-32768)       ; 76 DB ED 4B 00 80
 altd ioe ld bc, (32767)        ; 76 DB ED 4B FF 7F
 altd ioe ld bc, (65535)        ; 76 DB ED 4B FF FF
 altd ioe ld c, (hl)            ; 76 DB 4E
 altd ioe ld c, (hl+)           ; 76 DB 4E 23
 altd ioe ld c, (hl-)           ; 76 DB 4E 2B
 altd ioe ld c, (hld)           ; 76 DB 4E 2B
 altd ioe ld c, (hli)           ; 76 DB 4E 23
 altd ioe ld c, (ix)            ; 76 DB DD 4E 00
 altd ioe ld c, (ix+127)        ; 76 DB DD 4E 7F
 altd ioe ld c, (ix-128)        ; 76 DB DD 4E 80
 altd ioe ld c, (iy)            ; 76 DB FD 4E 00
 altd ioe ld c, (iy+127)        ; 76 DB FD 4E 7F
 altd ioe ld c, (iy-128)        ; 76 DB FD 4E 80
 altd ioe ld d, (hl)            ; 76 DB 56
 altd ioe ld d, (hl+)           ; 76 DB 56 23
 altd ioe ld d, (hl-)           ; 76 DB 56 2B
 altd ioe ld d, (hld)           ; 76 DB 56 2B
 altd ioe ld d, (hli)           ; 76 DB 56 23
 altd ioe ld d, (ix)            ; 76 DB DD 56 00
 altd ioe ld d, (ix+127)        ; 76 DB DD 56 7F
 altd ioe ld d, (ix-128)        ; 76 DB DD 56 80
 altd ioe ld d, (iy)            ; 76 DB FD 56 00
 altd ioe ld d, (iy+127)        ; 76 DB FD 56 7F
 altd ioe ld d, (iy-128)        ; 76 DB FD 56 80
 altd ioe ld de, (-32768)       ; 76 DB ED 5B 00 80
 altd ioe ld de, (32767)        ; 76 DB ED 5B FF 7F
 altd ioe ld de, (65535)        ; 76 DB ED 5B FF FF
 altd ioe ld e, (hl)            ; 76 DB 5E
 altd ioe ld e, (hl+)           ; 76 DB 5E 23
 altd ioe ld e, (hl-)           ; 76 DB 5E 2B
 altd ioe ld e, (hld)           ; 76 DB 5E 2B
 altd ioe ld e, (hli)           ; 76 DB 5E 23
 altd ioe ld e, (ix)            ; 76 DB DD 5E 00
 altd ioe ld e, (ix+127)        ; 76 DB DD 5E 7F
 altd ioe ld e, (ix-128)        ; 76 DB DD 5E 80
 altd ioe ld e, (iy)            ; 76 DB FD 5E 00
 altd ioe ld e, (iy+127)        ; 76 DB FD 5E 7F
 altd ioe ld e, (iy-128)        ; 76 DB FD 5E 80
 altd ioe ld h, (hl)            ; 76 DB 66
 altd ioe ld h, (hl+)           ; 76 DB 66 23
 altd ioe ld h, (hl-)           ; 76 DB 66 2B
 altd ioe ld h, (hld)           ; 76 DB 66 2B
 altd ioe ld h, (hli)           ; 76 DB 66 23
 altd ioe ld h, (ix)            ; 76 DB DD 66 00
 altd ioe ld h, (ix+127)        ; 76 DB DD 66 7F
 altd ioe ld h, (ix-128)        ; 76 DB DD 66 80
 altd ioe ld h, (iy)            ; 76 DB FD 66 00
 altd ioe ld h, (iy+127)        ; 76 DB FD 66 7F
 altd ioe ld h, (iy-128)        ; 76 DB FD 66 80
 altd ioe ld hl, (-32768)       ; 76 DB 2A 00 80
 altd ioe ld hl, (32767)        ; 76 DB 2A FF 7F
 altd ioe ld hl, (65535)        ; 76 DB 2A FF FF
 altd ioe ld hl, (hl)           ; 76 DB DD E4 00
 altd ioe ld hl, (hl+127)       ; 76 DB DD E4 7F
 altd ioe ld hl, (hl-128)       ; 76 DB DD E4 80
 altd ioe ld hl, (ix)           ; 76 DB E4 00
 altd ioe ld hl, (ix+127)       ; 76 DB E4 7F
 altd ioe ld hl, (ix-128)       ; 76 DB E4 80
 altd ioe ld hl, (iy)           ; 76 DB FD E4 00
 altd ioe ld hl, (iy+127)       ; 76 DB FD E4 7F
 altd ioe ld hl, (iy-128)       ; 76 DB FD E4 80
 altd ioe ld l, (hl)            ; 76 DB 6E
 altd ioe ld l, (hl+)           ; 76 DB 6E 23
 altd ioe ld l, (hl-)           ; 76 DB 6E 2B
 altd ioe ld l, (hld)           ; 76 DB 6E 2B
 altd ioe ld l, (hli)           ; 76 DB 6E 23
 altd ioe ld l, (ix)            ; 76 DB DD 6E 00
 altd ioe ld l, (ix+127)        ; 76 DB DD 6E 7F
 altd ioe ld l, (ix-128)        ; 76 DB DD 6E 80
 altd ioe ld l, (iy)            ; 76 DB FD 6E 00
 altd ioe ld l, (iy+127)        ; 76 DB FD 6E 7F
 altd ioe ld l, (iy-128)        ; 76 DB FD 6E 80
 altd ioe or (hl)               ; 76 DB B6
 altd ioe or (hl+)              ; 76 DB B6 23
 altd ioe or (hl-)              ; 76 DB B6 2B
 altd ioe or (ix)               ; 76 DB DD B6 00
 altd ioe or (ix+127)           ; 76 DB DD B6 7F
 altd ioe or (ix-128)           ; 76 DB DD B6 80
 altd ioe or (iy)               ; 76 DB FD B6 00
 altd ioe or (iy+127)           ; 76 DB FD B6 7F
 altd ioe or (iy-128)           ; 76 DB FD B6 80
 altd ioe or a, (hl)            ; 76 DB B6
 altd ioe or a, (hl+)           ; 76 DB B6 23
 altd ioe or a, (hl-)           ; 76 DB B6 2B
 altd ioe or a, (ix)            ; 76 DB DD B6 00
 altd ioe or a, (ix+127)        ; 76 DB DD B6 7F
 altd ioe or a, (ix-128)        ; 76 DB DD B6 80
 altd ioe or a, (iy)            ; 76 DB FD B6 00
 altd ioe or a, (iy+127)        ; 76 DB FD B6 7F
 altd ioe or a, (iy-128)        ; 76 DB FD B6 80
 altd ioe rl (hl)               ; 76 DB CB 16
 altd ioe rl (ix)               ; 76 DB DD CB 00 16
 altd ioe rl (ix+127)           ; 76 DB DD CB 7F 16
 altd ioe rl (ix-128)           ; 76 DB DD CB 80 16
 altd ioe rl (iy)               ; 76 DB FD CB 00 16
 altd ioe rl (iy+127)           ; 76 DB FD CB 7F 16
 altd ioe rl (iy-128)           ; 76 DB FD CB 80 16
 altd ioe rlc (hl)              ; 76 DB CB 06
 altd ioe rlc (ix)              ; 76 DB DD CB 00 06
 altd ioe rlc (ix+127)          ; 76 DB DD CB 7F 06
 altd ioe rlc (ix-128)          ; 76 DB DD CB 80 06
 altd ioe rlc (iy)              ; 76 DB FD CB 00 06
 altd ioe rlc (iy+127)          ; 76 DB FD CB 7F 06
 altd ioe rlc (iy-128)          ; 76 DB FD CB 80 06
 altd ioe rr (hl)               ; 76 DB CB 1E
 altd ioe rr (ix)               ; 76 DB DD CB 00 1E
 altd ioe rr (ix+127)           ; 76 DB DD CB 7F 1E
 altd ioe rr (ix-128)           ; 76 DB DD CB 80 1E
 altd ioe rr (iy)               ; 76 DB FD CB 00 1E
 altd ioe rr (iy+127)           ; 76 DB FD CB 7F 1E
 altd ioe rr (iy-128)           ; 76 DB FD CB 80 1E
 altd ioe rrc (hl)              ; 76 DB CB 0E
 altd ioe rrc (ix)              ; 76 DB DD CB 00 0E
 altd ioe rrc (ix+127)          ; 76 DB DD CB 7F 0E
 altd ioe rrc (ix-128)          ; 76 DB DD CB 80 0E
 altd ioe rrc (iy)              ; 76 DB FD CB 00 0E
 altd ioe rrc (iy+127)          ; 76 DB FD CB 7F 0E
 altd ioe rrc (iy-128)          ; 76 DB FD CB 80 0E
 altd ioe sbc (hl)              ; 76 DB 9E
 altd ioe sbc (hl+)             ; 76 DB 9E 23
 altd ioe sbc (hl-)             ; 76 DB 9E 2B
 altd ioe sbc (ix)              ; 76 DB DD 9E 00
 altd ioe sbc (ix+127)          ; 76 DB DD 9E 7F
 altd ioe sbc (ix-128)          ; 76 DB DD 9E 80
 altd ioe sbc (iy)              ; 76 DB FD 9E 00
 altd ioe sbc (iy+127)          ; 76 DB FD 9E 7F
 altd ioe sbc (iy-128)          ; 76 DB FD 9E 80
 altd ioe sbc a, (hl)           ; 76 DB 9E
 altd ioe sbc a, (hl+)          ; 76 DB 9E 23
 altd ioe sbc a, (hl-)          ; 76 DB 9E 2B
 altd ioe sbc a, (ix)           ; 76 DB DD 9E 00
 altd ioe sbc a, (ix+127)       ; 76 DB DD 9E 7F
 altd ioe sbc a, (ix-128)       ; 76 DB DD 9E 80
 altd ioe sbc a, (iy)           ; 76 DB FD 9E 00
 altd ioe sbc a, (iy+127)       ; 76 DB FD 9E 7F
 altd ioe sbc a, (iy-128)       ; 76 DB FD 9E 80
 altd ioe sla (hl)              ; 76 DB CB 26
 altd ioe sla (ix)              ; 76 DB DD CB 00 26
 altd ioe sla (ix+127)          ; 76 DB DD CB 7F 26
 altd ioe sla (ix-128)          ; 76 DB DD CB 80 26
 altd ioe sla (iy)              ; 76 DB FD CB 00 26
 altd ioe sla (iy+127)          ; 76 DB FD CB 7F 26
 altd ioe sla (iy-128)          ; 76 DB FD CB 80 26
 altd ioe sra (hl)              ; 76 DB CB 2E
 altd ioe sra (ix)              ; 76 DB DD CB 00 2E
 altd ioe sra (ix+127)          ; 76 DB DD CB 7F 2E
 altd ioe sra (ix-128)          ; 76 DB DD CB 80 2E
 altd ioe sra (iy)              ; 76 DB FD CB 00 2E
 altd ioe sra (iy+127)          ; 76 DB FD CB 7F 2E
 altd ioe sra (iy-128)          ; 76 DB FD CB 80 2E
 altd ioe srl (hl)              ; 76 DB CB 3E
 altd ioe srl (ix)              ; 76 DB DD CB 00 3E
 altd ioe srl (ix+127)          ; 76 DB DD CB 7F 3E
 altd ioe srl (ix-128)          ; 76 DB DD CB 80 3E
 altd ioe srl (iy)              ; 76 DB FD CB 00 3E
 altd ioe srl (iy+127)          ; 76 DB FD CB 7F 3E
 altd ioe srl (iy-128)          ; 76 DB FD CB 80 3E
 altd ioe sub (hl)              ; 76 DB 96
 altd ioe sub (hl+)             ; 76 DB 96 23
 altd ioe sub (hl-)             ; 76 DB 96 2B
 altd ioe sub (ix)              ; 76 DB DD 96 00
 altd ioe sub (ix+127)          ; 76 DB DD 96 7F
 altd ioe sub (ix-128)          ; 76 DB DD 96 80
 altd ioe sub (iy)              ; 76 DB FD 96 00
 altd ioe sub (iy+127)          ; 76 DB FD 96 7F
 altd ioe sub (iy-128)          ; 76 DB FD 96 80
 altd ioe sub a, (hl)           ; 76 DB 96
 altd ioe sub a, (hl+)          ; 76 DB 96 23
 altd ioe sub a, (hl-)          ; 76 DB 96 2B
 altd ioe sub a, (ix)           ; 76 DB DD 96 00
 altd ioe sub a, (ix+127)       ; 76 DB DD 96 7F
 altd ioe sub a, (ix-128)       ; 76 DB DD 96 80
 altd ioe sub a, (iy)           ; 76 DB FD 96 00
 altd ioe sub a, (iy+127)       ; 76 DB FD 96 7F
 altd ioe sub a, (iy-128)       ; 76 DB FD 96 80
 altd ioe xor (hl)              ; 76 DB AE
 altd ioe xor (hl+)             ; 76 DB AE 23
 altd ioe xor (hl-)             ; 76 DB AE 2B
 altd ioe xor (ix)              ; 76 DB DD AE 00
 altd ioe xor (ix+127)          ; 76 DB DD AE 7F
 altd ioe xor (ix-128)          ; 76 DB DD AE 80
 altd ioe xor (iy)              ; 76 DB FD AE 00
 altd ioe xor (iy+127)          ; 76 DB FD AE 7F
 altd ioe xor (iy-128)          ; 76 DB FD AE 80
 altd ioe xor a, (hl)           ; 76 DB AE
 altd ioe xor a, (hl+)          ; 76 DB AE 23
 altd ioe xor a, (hl-)          ; 76 DB AE 2B
 altd ioe xor a, (ix)           ; 76 DB DD AE 00
 altd ioe xor a, (ix+127)       ; 76 DB DD AE 7F
 altd ioe xor a, (ix-128)       ; 76 DB DD AE 80
 altd ioe xor a, (iy)           ; 76 DB FD AE 00
 altd ioe xor a, (iy+127)       ; 76 DB FD AE 7F
 altd ioe xor a, (iy-128)       ; 76 DB FD AE 80
 altd ioi adc (hl)              ; 76 D3 8E
 altd ioi adc (hl+)             ; 76 D3 8E 23
 altd ioi adc (hl-)             ; 76 D3 8E 2B
 altd ioi adc (ix)              ; 76 D3 DD 8E 00
 altd ioi adc (ix+127)          ; 76 D3 DD 8E 7F
 altd ioi adc (ix-128)          ; 76 D3 DD 8E 80
 altd ioi adc (iy)              ; 76 D3 FD 8E 00
 altd ioi adc (iy+127)          ; 76 D3 FD 8E 7F
 altd ioi adc (iy-128)          ; 76 D3 FD 8E 80
 altd ioi adc a, (hl)           ; 76 D3 8E
 altd ioi adc a, (hl+)          ; 76 D3 8E 23
 altd ioi adc a, (hl-)          ; 76 D3 8E 2B
 altd ioi adc a, (ix)           ; 76 D3 DD 8E 00
 altd ioi adc a, (ix+127)       ; 76 D3 DD 8E 7F
 altd ioi adc a, (ix-128)       ; 76 D3 DD 8E 80
 altd ioi adc a, (iy)           ; 76 D3 FD 8E 00
 altd ioi adc a, (iy+127)       ; 76 D3 FD 8E 7F
 altd ioi adc a, (iy-128)       ; 76 D3 FD 8E 80
 altd ioi add (hl)              ; 76 D3 86
 altd ioi add (hl+)             ; 76 D3 86 23
 altd ioi add (hl-)             ; 76 D3 86 2B
 altd ioi add (ix)              ; 76 D3 DD 86 00
 altd ioi add (ix+127)          ; 76 D3 DD 86 7F
 altd ioi add (ix-128)          ; 76 D3 DD 86 80
 altd ioi add (iy)              ; 76 D3 FD 86 00
 altd ioi add (iy+127)          ; 76 D3 FD 86 7F
 altd ioi add (iy-128)          ; 76 D3 FD 86 80
 altd ioi add a, (hl)           ; 76 D3 86
 altd ioi add a, (hl+)          ; 76 D3 86 23
 altd ioi add a, (hl-)          ; 76 D3 86 2B
 altd ioi add a, (ix)           ; 76 D3 DD 86 00
 altd ioi add a, (ix+127)       ; 76 D3 DD 86 7F
 altd ioi add a, (ix-128)       ; 76 D3 DD 86 80
 altd ioi add a, (iy)           ; 76 D3 FD 86 00
 altd ioi add a, (iy+127)       ; 76 D3 FD 86 7F
 altd ioi add a, (iy-128)       ; 76 D3 FD 86 80
 altd ioi and (hl)              ; 76 D3 A6
 altd ioi and (hl+)             ; 76 D3 A6 23
 altd ioi and (hl-)             ; 76 D3 A6 2B
 altd ioi and (ix)              ; 76 D3 DD A6 00
 altd ioi and (ix+127)          ; 76 D3 DD A6 7F
 altd ioi and (ix-128)          ; 76 D3 DD A6 80
 altd ioi and (iy)              ; 76 D3 FD A6 00
 altd ioi and (iy+127)          ; 76 D3 FD A6 7F
 altd ioi and (iy-128)          ; 76 D3 FD A6 80
 altd ioi and a, (hl)           ; 76 D3 A6
 altd ioi and a, (hl+)          ; 76 D3 A6 23
 altd ioi and a, (hl-)          ; 76 D3 A6 2B
 altd ioi and a, (ix)           ; 76 D3 DD A6 00
 altd ioi and a, (ix+127)       ; 76 D3 DD A6 7F
 altd ioi and a, (ix-128)       ; 76 D3 DD A6 80
 altd ioi and a, (iy)           ; 76 D3 FD A6 00
 altd ioi and a, (iy+127)       ; 76 D3 FD A6 7F
 altd ioi and a, (iy-128)       ; 76 D3 FD A6 80
 altd ioi bit 0, (hl)           ; 76 D3 CB 46
 altd ioi bit 0, (ix)           ; 76 D3 DD CB 00 46
 altd ioi bit 0, (ix+127)       ; 76 D3 DD CB 7F 46
 altd ioi bit 0, (ix-128)       ; 76 D3 DD CB 80 46
 altd ioi bit 0, (iy)           ; 76 D3 FD CB 00 46
 altd ioi bit 0, (iy+127)       ; 76 D3 FD CB 7F 46
 altd ioi bit 0, (iy-128)       ; 76 D3 FD CB 80 46
 altd ioi bit 1, (hl)           ; 76 D3 CB 4E
 altd ioi bit 1, (ix)           ; 76 D3 DD CB 00 4E
 altd ioi bit 1, (ix+127)       ; 76 D3 DD CB 7F 4E
 altd ioi bit 1, (ix-128)       ; 76 D3 DD CB 80 4E
 altd ioi bit 1, (iy)           ; 76 D3 FD CB 00 4E
 altd ioi bit 1, (iy+127)       ; 76 D3 FD CB 7F 4E
 altd ioi bit 1, (iy-128)       ; 76 D3 FD CB 80 4E
 altd ioi bit 2, (hl)           ; 76 D3 CB 56
 altd ioi bit 2, (ix)           ; 76 D3 DD CB 00 56
 altd ioi bit 2, (ix+127)       ; 76 D3 DD CB 7F 56
 altd ioi bit 2, (ix-128)       ; 76 D3 DD CB 80 56
 altd ioi bit 2, (iy)           ; 76 D3 FD CB 00 56
 altd ioi bit 2, (iy+127)       ; 76 D3 FD CB 7F 56
 altd ioi bit 2, (iy-128)       ; 76 D3 FD CB 80 56
 altd ioi bit 3, (hl)           ; 76 D3 CB 5E
 altd ioi bit 3, (ix)           ; 76 D3 DD CB 00 5E
 altd ioi bit 3, (ix+127)       ; 76 D3 DD CB 7F 5E
 altd ioi bit 3, (ix-128)       ; 76 D3 DD CB 80 5E
 altd ioi bit 3, (iy)           ; 76 D3 FD CB 00 5E
 altd ioi bit 3, (iy+127)       ; 76 D3 FD CB 7F 5E
 altd ioi bit 3, (iy-128)       ; 76 D3 FD CB 80 5E
 altd ioi bit 4, (hl)           ; 76 D3 CB 66
 altd ioi bit 4, (ix)           ; 76 D3 DD CB 00 66
 altd ioi bit 4, (ix+127)       ; 76 D3 DD CB 7F 66
 altd ioi bit 4, (ix-128)       ; 76 D3 DD CB 80 66
 altd ioi bit 4, (iy)           ; 76 D3 FD CB 00 66
 altd ioi bit 4, (iy+127)       ; 76 D3 FD CB 7F 66
 altd ioi bit 4, (iy-128)       ; 76 D3 FD CB 80 66
 altd ioi bit 5, (hl)           ; 76 D3 CB 6E
 altd ioi bit 5, (ix)           ; 76 D3 DD CB 00 6E
 altd ioi bit 5, (ix+127)       ; 76 D3 DD CB 7F 6E
 altd ioi bit 5, (ix-128)       ; 76 D3 DD CB 80 6E
 altd ioi bit 5, (iy)           ; 76 D3 FD CB 00 6E
 altd ioi bit 5, (iy+127)       ; 76 D3 FD CB 7F 6E
 altd ioi bit 5, (iy-128)       ; 76 D3 FD CB 80 6E
 altd ioi bit 6, (hl)           ; 76 D3 CB 76
 altd ioi bit 6, (ix)           ; 76 D3 DD CB 00 76
 altd ioi bit 6, (ix+127)       ; 76 D3 DD CB 7F 76
 altd ioi bit 6, (ix-128)       ; 76 D3 DD CB 80 76
 altd ioi bit 6, (iy)           ; 76 D3 FD CB 00 76
 altd ioi bit 6, (iy+127)       ; 76 D3 FD CB 7F 76
 altd ioi bit 6, (iy-128)       ; 76 D3 FD CB 80 76
 altd ioi bit 7, (hl)           ; 76 D3 CB 7E
 altd ioi bit 7, (ix)           ; 76 D3 DD CB 00 7E
 altd ioi bit 7, (ix+127)       ; 76 D3 DD CB 7F 7E
 altd ioi bit 7, (ix-128)       ; 76 D3 DD CB 80 7E
 altd ioi bit 7, (iy)           ; 76 D3 FD CB 00 7E
 altd ioi bit 7, (iy+127)       ; 76 D3 FD CB 7F 7E
 altd ioi bit 7, (iy-128)       ; 76 D3 FD CB 80 7E
 altd ioi cp (hl)               ; 76 D3 BE
 altd ioi cp (hl+)              ; 76 D3 BE 23
 altd ioi cp (hl-)              ; 76 D3 BE 2B
 altd ioi cp (ix)               ; 76 D3 DD BE 00
 altd ioi cp (ix+127)           ; 76 D3 DD BE 7F
 altd ioi cp (ix-128)           ; 76 D3 DD BE 80
 altd ioi cp (iy)               ; 76 D3 FD BE 00
 altd ioi cp (iy+127)           ; 76 D3 FD BE 7F
 altd ioi cp (iy-128)           ; 76 D3 FD BE 80
 altd ioi cp a, (hl)            ; 76 D3 BE
 altd ioi cp a, (hl+)           ; 76 D3 BE 23
 altd ioi cp a, (hl-)           ; 76 D3 BE 2B
 altd ioi cp a, (ix)            ; 76 D3 DD BE 00
 altd ioi cp a, (ix+127)        ; 76 D3 DD BE 7F
 altd ioi cp a, (ix-128)        ; 76 D3 DD BE 80
 altd ioi cp a, (iy)            ; 76 D3 FD BE 00
 altd ioi cp a, (iy+127)        ; 76 D3 FD BE 7F
 altd ioi cp a, (iy-128)        ; 76 D3 FD BE 80
 altd ioi dec (hl)              ; 76 D3 35
 altd ioi dec (hl+)             ; 76 D3 35 23
 altd ioi dec (hl-)             ; 76 D3 35 2B
 altd ioi dec (ix)              ; 76 D3 DD 35 00
 altd ioi dec (ix+127)          ; 76 D3 DD 35 7F
 altd ioi dec (ix-128)          ; 76 D3 DD 35 80
 altd ioi dec (iy)              ; 76 D3 FD 35 00
 altd ioi dec (iy+127)          ; 76 D3 FD 35 7F
 altd ioi dec (iy-128)          ; 76 D3 FD 35 80
 altd ioi inc (hl)              ; 76 D3 34
 altd ioi inc (hl+)             ; 76 D3 34 23
 altd ioi inc (hl-)             ; 76 D3 34 2B
 altd ioi inc (ix)              ; 76 D3 DD 34 00
 altd ioi inc (ix+127)          ; 76 D3 DD 34 7F
 altd ioi inc (ix-128)          ; 76 D3 DD 34 80
 altd ioi inc (iy)              ; 76 D3 FD 34 00
 altd ioi inc (iy+127)          ; 76 D3 FD 34 7F
 altd ioi inc (iy-128)          ; 76 D3 FD 34 80
 altd ioi ld a, (-32768)        ; 76 D3 3A 00 80
 altd ioi ld a, (32767)         ; 76 D3 3A FF 7F
 altd ioi ld a, (65535)         ; 76 D3 3A FF FF
 altd ioi ld a, (bc)            ; 76 D3 0A
 altd ioi ld a, (bc+)           ; 76 D3 0A 03
 altd ioi ld a, (bc-)           ; 76 D3 0A 0B
 altd ioi ld a, (de)            ; 76 D3 1A
 altd ioi ld a, (de+)           ; 76 D3 1A 13
 altd ioi ld a, (de-)           ; 76 D3 1A 1B
 altd ioi ld a, (hl)            ; 76 D3 7E
 altd ioi ld a, (hl+)           ; 76 D3 7E 23
 altd ioi ld a, (hl-)           ; 76 D3 7E 2B
 altd ioi ld a, (hld)           ; 76 D3 7E 2B
 altd ioi ld a, (hli)           ; 76 D3 7E 23
 altd ioi ld a, (ix)            ; 76 D3 DD 7E 00
 altd ioi ld a, (ix+127)        ; 76 D3 DD 7E 7F
 altd ioi ld a, (ix-128)        ; 76 D3 DD 7E 80
 altd ioi ld a, (iy)            ; 76 D3 FD 7E 00
 altd ioi ld a, (iy+127)        ; 76 D3 FD 7E 7F
 altd ioi ld a, (iy-128)        ; 76 D3 FD 7E 80
 altd ioi ld b, (hl)            ; 76 D3 46
 altd ioi ld b, (hl+)           ; 76 D3 46 23
 altd ioi ld b, (hl-)           ; 76 D3 46 2B
 altd ioi ld b, (hld)           ; 76 D3 46 2B
 altd ioi ld b, (hli)           ; 76 D3 46 23
 altd ioi ld b, (ix)            ; 76 D3 DD 46 00
 altd ioi ld b, (ix+127)        ; 76 D3 DD 46 7F
 altd ioi ld b, (ix-128)        ; 76 D3 DD 46 80
 altd ioi ld b, (iy)            ; 76 D3 FD 46 00
 altd ioi ld b, (iy+127)        ; 76 D3 FD 46 7F
 altd ioi ld b, (iy-128)        ; 76 D3 FD 46 80
 altd ioi ld bc, (-32768)       ; 76 D3 ED 4B 00 80
 altd ioi ld bc, (32767)        ; 76 D3 ED 4B FF 7F
 altd ioi ld bc, (65535)        ; 76 D3 ED 4B FF FF
 altd ioi ld c, (hl)            ; 76 D3 4E
 altd ioi ld c, (hl+)           ; 76 D3 4E 23
 altd ioi ld c, (hl-)           ; 76 D3 4E 2B
 altd ioi ld c, (hld)           ; 76 D3 4E 2B
 altd ioi ld c, (hli)           ; 76 D3 4E 23
 altd ioi ld c, (ix)            ; 76 D3 DD 4E 00
 altd ioi ld c, (ix+127)        ; 76 D3 DD 4E 7F
 altd ioi ld c, (ix-128)        ; 76 D3 DD 4E 80
 altd ioi ld c, (iy)            ; 76 D3 FD 4E 00
 altd ioi ld c, (iy+127)        ; 76 D3 FD 4E 7F
 altd ioi ld c, (iy-128)        ; 76 D3 FD 4E 80
 altd ioi ld d, (hl)            ; 76 D3 56
 altd ioi ld d, (hl+)           ; 76 D3 56 23
 altd ioi ld d, (hl-)           ; 76 D3 56 2B
 altd ioi ld d, (hld)           ; 76 D3 56 2B
 altd ioi ld d, (hli)           ; 76 D3 56 23
 altd ioi ld d, (ix)            ; 76 D3 DD 56 00
 altd ioi ld d, (ix+127)        ; 76 D3 DD 56 7F
 altd ioi ld d, (ix-128)        ; 76 D3 DD 56 80
 altd ioi ld d, (iy)            ; 76 D3 FD 56 00
 altd ioi ld d, (iy+127)        ; 76 D3 FD 56 7F
 altd ioi ld d, (iy-128)        ; 76 D3 FD 56 80
 altd ioi ld de, (-32768)       ; 76 D3 ED 5B 00 80
 altd ioi ld de, (32767)        ; 76 D3 ED 5B FF 7F
 altd ioi ld de, (65535)        ; 76 D3 ED 5B FF FF
 altd ioi ld e, (hl)            ; 76 D3 5E
 altd ioi ld e, (hl+)           ; 76 D3 5E 23
 altd ioi ld e, (hl-)           ; 76 D3 5E 2B
 altd ioi ld e, (hld)           ; 76 D3 5E 2B
 altd ioi ld e, (hli)           ; 76 D3 5E 23
 altd ioi ld e, (ix)            ; 76 D3 DD 5E 00
 altd ioi ld e, (ix+127)        ; 76 D3 DD 5E 7F
 altd ioi ld e, (ix-128)        ; 76 D3 DD 5E 80
 altd ioi ld e, (iy)            ; 76 D3 FD 5E 00
 altd ioi ld e, (iy+127)        ; 76 D3 FD 5E 7F
 altd ioi ld e, (iy-128)        ; 76 D3 FD 5E 80
 altd ioi ld h, (hl)            ; 76 D3 66
 altd ioi ld h, (hl+)           ; 76 D3 66 23
 altd ioi ld h, (hl-)           ; 76 D3 66 2B
 altd ioi ld h, (hld)           ; 76 D3 66 2B
 altd ioi ld h, (hli)           ; 76 D3 66 23
 altd ioi ld h, (ix)            ; 76 D3 DD 66 00
 altd ioi ld h, (ix+127)        ; 76 D3 DD 66 7F
 altd ioi ld h, (ix-128)        ; 76 D3 DD 66 80
 altd ioi ld h, (iy)            ; 76 D3 FD 66 00
 altd ioi ld h, (iy+127)        ; 76 D3 FD 66 7F
 altd ioi ld h, (iy-128)        ; 76 D3 FD 66 80
 altd ioi ld hl, (-32768)       ; 76 D3 2A 00 80
 altd ioi ld hl, (32767)        ; 76 D3 2A FF 7F
 altd ioi ld hl, (65535)        ; 76 D3 2A FF FF
 altd ioi ld hl, (hl)           ; 76 D3 DD E4 00
 altd ioi ld hl, (hl+127)       ; 76 D3 DD E4 7F
 altd ioi ld hl, (hl-128)       ; 76 D3 DD E4 80
 altd ioi ld hl, (ix)           ; 76 D3 E4 00
 altd ioi ld hl, (ix+127)       ; 76 D3 E4 7F
 altd ioi ld hl, (ix-128)       ; 76 D3 E4 80
 altd ioi ld hl, (iy)           ; 76 D3 FD E4 00
 altd ioi ld hl, (iy+127)       ; 76 D3 FD E4 7F
 altd ioi ld hl, (iy-128)       ; 76 D3 FD E4 80
 altd ioi ld l, (hl)            ; 76 D3 6E
 altd ioi ld l, (hl+)           ; 76 D3 6E 23
 altd ioi ld l, (hl-)           ; 76 D3 6E 2B
 altd ioi ld l, (hld)           ; 76 D3 6E 2B
 altd ioi ld l, (hli)           ; 76 D3 6E 23
 altd ioi ld l, (ix)            ; 76 D3 DD 6E 00
 altd ioi ld l, (ix+127)        ; 76 D3 DD 6E 7F
 altd ioi ld l, (ix-128)        ; 76 D3 DD 6E 80
 altd ioi ld l, (iy)            ; 76 D3 FD 6E 00
 altd ioi ld l, (iy+127)        ; 76 D3 FD 6E 7F
 altd ioi ld l, (iy-128)        ; 76 D3 FD 6E 80
 altd ioi or (hl)               ; 76 D3 B6
 altd ioi or (hl+)              ; 76 D3 B6 23
 altd ioi or (hl-)              ; 76 D3 B6 2B
 altd ioi or (ix)               ; 76 D3 DD B6 00
 altd ioi or (ix+127)           ; 76 D3 DD B6 7F
 altd ioi or (ix-128)           ; 76 D3 DD B6 80
 altd ioi or (iy)               ; 76 D3 FD B6 00
 altd ioi or (iy+127)           ; 76 D3 FD B6 7F
 altd ioi or (iy-128)           ; 76 D3 FD B6 80
 altd ioi or a, (hl)            ; 76 D3 B6
 altd ioi or a, (hl+)           ; 76 D3 B6 23
 altd ioi or a, (hl-)           ; 76 D3 B6 2B
 altd ioi or a, (ix)            ; 76 D3 DD B6 00
 altd ioi or a, (ix+127)        ; 76 D3 DD B6 7F
 altd ioi or a, (ix-128)        ; 76 D3 DD B6 80
 altd ioi or a, (iy)            ; 76 D3 FD B6 00
 altd ioi or a, (iy+127)        ; 76 D3 FD B6 7F
 altd ioi or a, (iy-128)        ; 76 D3 FD B6 80
 altd ioi rl (hl)               ; 76 D3 CB 16
 altd ioi rl (ix)               ; 76 D3 DD CB 00 16
 altd ioi rl (ix+127)           ; 76 D3 DD CB 7F 16
 altd ioi rl (ix-128)           ; 76 D3 DD CB 80 16
 altd ioi rl (iy)               ; 76 D3 FD CB 00 16
 altd ioi rl (iy+127)           ; 76 D3 FD CB 7F 16
 altd ioi rl (iy-128)           ; 76 D3 FD CB 80 16
 altd ioi rlc (hl)              ; 76 D3 CB 06
 altd ioi rlc (ix)              ; 76 D3 DD CB 00 06
 altd ioi rlc (ix+127)          ; 76 D3 DD CB 7F 06
 altd ioi rlc (ix-128)          ; 76 D3 DD CB 80 06
 altd ioi rlc (iy)              ; 76 D3 FD CB 00 06
 altd ioi rlc (iy+127)          ; 76 D3 FD CB 7F 06
 altd ioi rlc (iy-128)          ; 76 D3 FD CB 80 06
 altd ioi rr (hl)               ; 76 D3 CB 1E
 altd ioi rr (ix)               ; 76 D3 DD CB 00 1E
 altd ioi rr (ix+127)           ; 76 D3 DD CB 7F 1E
 altd ioi rr (ix-128)           ; 76 D3 DD CB 80 1E
 altd ioi rr (iy)               ; 76 D3 FD CB 00 1E
 altd ioi rr (iy+127)           ; 76 D3 FD CB 7F 1E
 altd ioi rr (iy-128)           ; 76 D3 FD CB 80 1E
 altd ioi rrc (hl)              ; 76 D3 CB 0E
 altd ioi rrc (ix)              ; 76 D3 DD CB 00 0E
 altd ioi rrc (ix+127)          ; 76 D3 DD CB 7F 0E
 altd ioi rrc (ix-128)          ; 76 D3 DD CB 80 0E
 altd ioi rrc (iy)              ; 76 D3 FD CB 00 0E
 altd ioi rrc (iy+127)          ; 76 D3 FD CB 7F 0E
 altd ioi rrc (iy-128)          ; 76 D3 FD CB 80 0E
 altd ioi sbc (hl)              ; 76 D3 9E
 altd ioi sbc (hl+)             ; 76 D3 9E 23
 altd ioi sbc (hl-)             ; 76 D3 9E 2B
 altd ioi sbc (ix)              ; 76 D3 DD 9E 00
 altd ioi sbc (ix+127)          ; 76 D3 DD 9E 7F
 altd ioi sbc (ix-128)          ; 76 D3 DD 9E 80
 altd ioi sbc (iy)              ; 76 D3 FD 9E 00
 altd ioi sbc (iy+127)          ; 76 D3 FD 9E 7F
 altd ioi sbc (iy-128)          ; 76 D3 FD 9E 80
 altd ioi sbc a, (hl)           ; 76 D3 9E
 altd ioi sbc a, (hl+)          ; 76 D3 9E 23
 altd ioi sbc a, (hl-)          ; 76 D3 9E 2B
 altd ioi sbc a, (ix)           ; 76 D3 DD 9E 00
 altd ioi sbc a, (ix+127)       ; 76 D3 DD 9E 7F
 altd ioi sbc a, (ix-128)       ; 76 D3 DD 9E 80
 altd ioi sbc a, (iy)           ; 76 D3 FD 9E 00
 altd ioi sbc a, (iy+127)       ; 76 D3 FD 9E 7F
 altd ioi sbc a, (iy-128)       ; 76 D3 FD 9E 80
 altd ioi sla (hl)              ; 76 D3 CB 26
 altd ioi sla (ix)              ; 76 D3 DD CB 00 26
 altd ioi sla (ix+127)          ; 76 D3 DD CB 7F 26
 altd ioi sla (ix-128)          ; 76 D3 DD CB 80 26
 altd ioi sla (iy)              ; 76 D3 FD CB 00 26
 altd ioi sla (iy+127)          ; 76 D3 FD CB 7F 26
 altd ioi sla (iy-128)          ; 76 D3 FD CB 80 26
 altd ioi sra (hl)              ; 76 D3 CB 2E
 altd ioi sra (ix)              ; 76 D3 DD CB 00 2E
 altd ioi sra (ix+127)          ; 76 D3 DD CB 7F 2E
 altd ioi sra (ix-128)          ; 76 D3 DD CB 80 2E
 altd ioi sra (iy)              ; 76 D3 FD CB 00 2E
 altd ioi sra (iy+127)          ; 76 D3 FD CB 7F 2E
 altd ioi sra (iy-128)          ; 76 D3 FD CB 80 2E
 altd ioi srl (hl)              ; 76 D3 CB 3E
 altd ioi srl (ix)              ; 76 D3 DD CB 00 3E
 altd ioi srl (ix+127)          ; 76 D3 DD CB 7F 3E
 altd ioi srl (ix-128)          ; 76 D3 DD CB 80 3E
 altd ioi srl (iy)              ; 76 D3 FD CB 00 3E
 altd ioi srl (iy+127)          ; 76 D3 FD CB 7F 3E
 altd ioi srl (iy-128)          ; 76 D3 FD CB 80 3E
 altd ioi sub (hl)              ; 76 D3 96
 altd ioi sub (hl+)             ; 76 D3 96 23
 altd ioi sub (hl-)             ; 76 D3 96 2B
 altd ioi sub (ix)              ; 76 D3 DD 96 00
 altd ioi sub (ix+127)          ; 76 D3 DD 96 7F
 altd ioi sub (ix-128)          ; 76 D3 DD 96 80
 altd ioi sub (iy)              ; 76 D3 FD 96 00
 altd ioi sub (iy+127)          ; 76 D3 FD 96 7F
 altd ioi sub (iy-128)          ; 76 D3 FD 96 80
 altd ioi sub a, (hl)           ; 76 D3 96
 altd ioi sub a, (hl+)          ; 76 D3 96 23
 altd ioi sub a, (hl-)          ; 76 D3 96 2B
 altd ioi sub a, (ix)           ; 76 D3 DD 96 00
 altd ioi sub a, (ix+127)       ; 76 D3 DD 96 7F
 altd ioi sub a, (ix-128)       ; 76 D3 DD 96 80
 altd ioi sub a, (iy)           ; 76 D3 FD 96 00
 altd ioi sub a, (iy+127)       ; 76 D3 FD 96 7F
 altd ioi sub a, (iy-128)       ; 76 D3 FD 96 80
 altd ioi xor (hl)              ; 76 D3 AE
 altd ioi xor (hl+)             ; 76 D3 AE 23
 altd ioi xor (hl-)             ; 76 D3 AE 2B
 altd ioi xor (ix)              ; 76 D3 DD AE 00
 altd ioi xor (ix+127)          ; 76 D3 DD AE 7F
 altd ioi xor (ix-128)          ; 76 D3 DD AE 80
 altd ioi xor (iy)              ; 76 D3 FD AE 00
 altd ioi xor (iy+127)          ; 76 D3 FD AE 7F
 altd ioi xor (iy-128)          ; 76 D3 FD AE 80
 altd ioi xor a, (hl)           ; 76 D3 AE
 altd ioi xor a, (hl+)          ; 76 D3 AE 23
 altd ioi xor a, (hl-)          ; 76 D3 AE 2B
 altd ioi xor a, (ix)           ; 76 D3 DD AE 00
 altd ioi xor a, (ix+127)       ; 76 D3 DD AE 7F
 altd ioi xor a, (ix-128)       ; 76 D3 DD AE 80
 altd ioi xor a, (iy)           ; 76 D3 FD AE 00
 altd ioi xor a, (iy+127)       ; 76 D3 FD AE 7F
 altd ioi xor a, (iy-128)       ; 76 D3 FD AE 80
 altd ld a, (-32768)            ; 76 3A 00 80
 altd ld a, (32767)             ; 76 3A FF 7F
 altd ld a, (65535)             ; 76 3A FF FF
 altd ld a, (bc)                ; 76 0A
 altd ld a, (bc+)               ; 76 0A 03
 altd ld a, (bc-)               ; 76 0A 0B
 altd ld a, (de)                ; 76 1A
 altd ld a, (de+)               ; 76 1A 13
 altd ld a, (de-)               ; 76 1A 1B
 altd ld a, (hl)                ; 76 7E
 altd ld a, (hl+)               ; 76 7E 23
 altd ld a, (hl-)               ; 76 7E 2B
 altd ld a, (hld)               ; 76 7E 2B
 altd ld a, (hli)               ; 76 7E 23
 altd ld a, (ix)                ; 76 DD 7E 00
 altd ld a, (ix+127)            ; 76 DD 7E 7F
 altd ld a, (ix-128)            ; 76 DD 7E 80
 altd ld a, (iy)                ; 76 FD 7E 00
 altd ld a, (iy+127)            ; 76 FD 7E 7F
 altd ld a, (iy-128)            ; 76 FD 7E 80
 altd ld a, -128                ; 76 3E 80
 altd ld a, 127                 ; 76 3E 7F
 altd ld a, 255                 ; 76 3E FF
 altd ld a, a                   ; 76 7F
 altd ld a, b                   ; 76 78
 altd ld a, c                   ; 76 79
 altd ld a, d                   ; 76 7A
 altd ld a, e                   ; 76 7B
 altd ld a, eir                 ; 76 ED 57
 altd ld a, h                   ; 76 7C
 altd ld a, iir                 ; 76 ED 5F
 altd ld a, l                   ; 76 7D
 altd ld a, xpc                 ; 76 ED 77
 altd ld b, (hl)                ; 76 46
 altd ld b, (hl+)               ; 76 46 23
 altd ld b, (hl-)               ; 76 46 2B
 altd ld b, (hld)               ; 76 46 2B
 altd ld b, (hli)               ; 76 46 23
 altd ld b, (ix)                ; 76 DD 46 00
 altd ld b, (ix+127)            ; 76 DD 46 7F
 altd ld b, (ix-128)            ; 76 DD 46 80
 altd ld b, (iy)                ; 76 FD 46 00
 altd ld b, (iy+127)            ; 76 FD 46 7F
 altd ld b, (iy-128)            ; 76 FD 46 80
 altd ld b, -128                ; 76 06 80
 altd ld b, 127                 ; 76 06 7F
 altd ld b, 255                 ; 76 06 FF
 altd ld b, a                   ; 76 47
 altd ld b, b                   ; 76 40
 altd ld b, c                   ; 76 41
 altd ld b, d                   ; 76 42
 altd ld b, e                   ; 76 43
 altd ld b, h                   ; 76 44
 altd ld b, l                   ; 76 45
 altd ld bc, (-32768)           ; 76 ED 4B 00 80
 altd ld bc, (32767)            ; 76 ED 4B FF 7F
 altd ld bc, (65535)            ; 76 ED 4B FF FF
 altd ld bc, -32768             ; 76 01 00 80
 altd ld bc, 32767              ; 76 01 FF 7F
 altd ld bc, 65535              ; 76 01 FF FF
 altd ld bc, bc                 ; ED 49
 altd ld bc, de                 ; ED 41
 altd ld c, (hl)                ; 76 4E
 altd ld c, (hl+)               ; 76 4E 23
 altd ld c, (hl-)               ; 76 4E 2B
 altd ld c, (hld)               ; 76 4E 2B
 altd ld c, (hli)               ; 76 4E 23
 altd ld c, (ix)                ; 76 DD 4E 00
 altd ld c, (ix+127)            ; 76 DD 4E 7F
 altd ld c, (ix-128)            ; 76 DD 4E 80
 altd ld c, (iy)                ; 76 FD 4E 00
 altd ld c, (iy+127)            ; 76 FD 4E 7F
 altd ld c, (iy-128)            ; 76 FD 4E 80
 altd ld c, -128                ; 76 0E 80
 altd ld c, 127                 ; 76 0E 7F
 altd ld c, 255                 ; 76 0E FF
 altd ld c, a                   ; 76 4F
 altd ld c, b                   ; 76 48
 altd ld c, c                   ; 76 49
 altd ld c, d                   ; 76 4A
 altd ld c, e                   ; 76 4B
 altd ld c, h                   ; 76 4C
 altd ld c, l                   ; 76 4D
 altd ld d, (hl)                ; 76 56
 altd ld d, (hl+)               ; 76 56 23
 altd ld d, (hl-)               ; 76 56 2B
 altd ld d, (hld)               ; 76 56 2B
 altd ld d, (hli)               ; 76 56 23
 altd ld d, (ix)                ; 76 DD 56 00
 altd ld d, (ix+127)            ; 76 DD 56 7F
 altd ld d, (ix-128)            ; 76 DD 56 80
 altd ld d, (iy)                ; 76 FD 56 00
 altd ld d, (iy+127)            ; 76 FD 56 7F
 altd ld d, (iy-128)            ; 76 FD 56 80
 altd ld d, -128                ; 76 16 80
 altd ld d, 127                 ; 76 16 7F
 altd ld d, 255                 ; 76 16 FF
 altd ld d, a                   ; 76 57
 altd ld d, b                   ; 76 50
 altd ld d, c                   ; 76 51
 altd ld d, d                   ; 76 52
 altd ld d, e                   ; 76 53
 altd ld d, h                   ; 76 54
 altd ld d, l                   ; 76 55
 altd ld de, (-32768)           ; 76 ED 5B 00 80
 altd ld de, (32767)            ; 76 ED 5B FF 7F
 altd ld de, (65535)            ; 76 ED 5B FF FF
 altd ld de, -32768             ; 76 11 00 80
 altd ld de, 32767              ; 76 11 FF 7F
 altd ld de, 65535              ; 76 11 FF FF
 altd ld de, bc                 ; ED 59
 altd ld de, de                 ; ED 51
 altd ld e, (hl)                ; 76 5E
 altd ld e, (hl+)               ; 76 5E 23
 altd ld e, (hl-)               ; 76 5E 2B
 altd ld e, (hld)               ; 76 5E 2B
 altd ld e, (hli)               ; 76 5E 23
 altd ld e, (ix)                ; 76 DD 5E 00
 altd ld e, (ix+127)            ; 76 DD 5E 7F
 altd ld e, (ix-128)            ; 76 DD 5E 80
 altd ld e, (iy)                ; 76 FD 5E 00
 altd ld e, (iy+127)            ; 76 FD 5E 7F
 altd ld e, (iy-128)            ; 76 FD 5E 80
 altd ld e, -128                ; 76 1E 80
 altd ld e, 127                 ; 76 1E 7F
 altd ld e, 255                 ; 76 1E FF
 altd ld e, a                   ; 76 5F
 altd ld e, b                   ; 76 58
 altd ld e, c                   ; 76 59
 altd ld e, d                   ; 76 5A
 altd ld e, e                   ; 76 5B
 altd ld e, h                   ; 76 5C
 altd ld e, l                   ; 76 5D
 altd ld h, (hl)                ; 76 66
 altd ld h, (hl+)               ; 76 66 23
 altd ld h, (hl-)               ; 76 66 2B
 altd ld h, (hld)               ; 76 66 2B
 altd ld h, (hli)               ; 76 66 23
 altd ld h, (ix)                ; 76 DD 66 00
 altd ld h, (ix+127)            ; 76 DD 66 7F
 altd ld h, (ix-128)            ; 76 DD 66 80
 altd ld h, (iy)                ; 76 FD 66 00
 altd ld h, (iy+127)            ; 76 FD 66 7F
 altd ld h, (iy-128)            ; 76 FD 66 80
 altd ld h, -128                ; 76 26 80
 altd ld h, 127                 ; 76 26 7F
 altd ld h, 255                 ; 76 26 FF
 altd ld h, a                   ; 76 67
 altd ld h, b                   ; 76 60
 altd ld h, c                   ; 76 61
 altd ld h, d                   ; 76 62
 altd ld h, e                   ; 76 63
 altd ld h, h                   ; 76 64
 altd ld h, l                   ; 76 65
 altd ld hl, (-32768)           ; 76 2A 00 80
 altd ld hl, (32767)            ; 76 2A FF 7F
 altd ld hl, (65535)            ; 76 2A FF FF
 altd ld hl, (hl)               ; 76 DD E4 00
 altd ld hl, (hl+127)           ; 76 DD E4 7F
 altd ld hl, (hl-128)           ; 76 DD E4 80
 altd ld hl, (ix)               ; 76 E4 00
 altd ld hl, (ix+127)           ; 76 E4 7F
 altd ld hl, (ix-128)           ; 76 E4 80
 altd ld hl, (iy)               ; 76 FD E4 00
 altd ld hl, (iy+127)           ; 76 FD E4 7F
 altd ld hl, (iy-128)           ; 76 FD E4 80
 altd ld hl, (sp)               ; 76 C4 00
 altd ld hl, (sp+0)             ; 76 C4 00
 altd ld hl, (sp+255)           ; 76 C4 FF
 altd ld hl, -32768             ; 76 21 00 80
 altd ld hl, 32767              ; 76 21 FF 7F
 altd ld hl, 65535              ; 76 21 FF FF
 altd ld hl, bc                 ; ED 69
 altd ld hl, de                 ; ED 61
 altd ld hl, ix                 ; 76 DD 7C
 altd ld hl, iy                 ; 76 FD 7C
 altd ld l, (hl)                ; 76 6E
 altd ld l, (hl+)               ; 76 6E 23
 altd ld l, (hl-)               ; 76 6E 2B
 altd ld l, (hld)               ; 76 6E 2B
 altd ld l, (hli)               ; 76 6E 23
 altd ld l, (ix)                ; 76 DD 6E 00
 altd ld l, (ix+127)            ; 76 DD 6E 7F
 altd ld l, (ix-128)            ; 76 DD 6E 80
 altd ld l, (iy)                ; 76 FD 6E 00
 altd ld l, (iy+127)            ; 76 FD 6E 7F
 altd ld l, (iy-128)            ; 76 FD 6E 80
 altd ld l, -128                ; 76 2E 80
 altd ld l, 127                 ; 76 2E 7F
 altd ld l, 255                 ; 76 2E FF
 altd ld l, a                   ; 76 6F
 altd ld l, b                   ; 76 68
 altd ld l, c                   ; 76 69
 altd ld l, d                   ; 76 6A
 altd ld l, e                   ; 76 6B
 altd ld l, h                   ; 76 6C
 altd ld l, l                   ; 76 6D
 altd neg                       ; 76 ED 44
 altd neg a                     ; 76 ED 44
 altd or (hl)                   ; 76 B6
 altd or (hl+)                  ; 76 B6 23
 altd or (hl-)                  ; 76 B6 2B
 altd or (ix)                   ; 76 DD B6 00
 altd or (ix+127)               ; 76 DD B6 7F
 altd or (ix-128)               ; 76 DD B6 80
 altd or (iy)                   ; 76 FD B6 00
 altd or (iy+127)               ; 76 FD B6 7F
 altd or (iy-128)               ; 76 FD B6 80
 altd or -128                   ; 76 F6 80
 altd or 127                    ; 76 F6 7F
 altd or 255                    ; 76 F6 FF
 altd or a                      ; 76 B7
 altd or a, (hl)                ; 76 B6
 altd or a, (hl+)               ; 76 B6 23
 altd or a, (hl-)               ; 76 B6 2B
 altd or a, (ix)                ; 76 DD B6 00
 altd or a, (ix+127)            ; 76 DD B6 7F
 altd or a, (ix-128)            ; 76 DD B6 80
 altd or a, (iy)                ; 76 FD B6 00
 altd or a, (iy+127)            ; 76 FD B6 7F
 altd or a, (iy-128)            ; 76 FD B6 80
 altd or a, -128                ; 76 F6 80
 altd or a, 127                 ; 76 F6 7F
 altd or a, 255                 ; 76 F6 FF
 altd or a, a                   ; 76 B7
 altd or a, b                   ; 76 B0
 altd or a, c                   ; 76 B1
 altd or a, d                   ; 76 B2
 altd or a, e                   ; 76 B3
 altd or a, h                   ; 76 B4
 altd or a, l                   ; 76 B5
 altd or b                      ; 76 B0
 altd or c                      ; 76 B1
 altd or d                      ; 76 B2
 altd or e                      ; 76 B3
 altd or h                      ; 76 B4
 altd or hl, de                 ; 76 EC
 altd or l                      ; 76 B5
 altd pop af                    ; 76 F1
 altd pop bc                    ; 76 C1
 altd pop de                    ; 76 D1
 altd pop hl                    ; 76 E1
 altd res 0, a                  ; 76 CB 87
 altd res 0, b                  ; 76 CB 80
 altd res 0, c                  ; 76 CB 81
 altd res 0, d                  ; 76 CB 82
 altd res 0, e                  ; 76 CB 83
 altd res 0, h                  ; 76 CB 84
 altd res 0, l                  ; 76 CB 85
 altd res 1, a                  ; 76 CB 8F
 altd res 1, b                  ; 76 CB 88
 altd res 1, c                  ; 76 CB 89
 altd res 1, d                  ; 76 CB 8A
 altd res 1, e                  ; 76 CB 8B
 altd res 1, h                  ; 76 CB 8C
 altd res 1, l                  ; 76 CB 8D
 altd res 2, a                  ; 76 CB 97
 altd res 2, b                  ; 76 CB 90
 altd res 2, c                  ; 76 CB 91
 altd res 2, d                  ; 76 CB 92
 altd res 2, e                  ; 76 CB 93
 altd res 2, h                  ; 76 CB 94
 altd res 2, l                  ; 76 CB 95
 altd res 3, a                  ; 76 CB 9F
 altd res 3, b                  ; 76 CB 98
 altd res 3, c                  ; 76 CB 99
 altd res 3, d                  ; 76 CB 9A
 altd res 3, e                  ; 76 CB 9B
 altd res 3, h                  ; 76 CB 9C
 altd res 3, l                  ; 76 CB 9D
 altd res 4, a                  ; 76 CB A7
 altd res 4, b                  ; 76 CB A0
 altd res 4, c                  ; 76 CB A1
 altd res 4, d                  ; 76 CB A2
 altd res 4, e                  ; 76 CB A3
 altd res 4, h                  ; 76 CB A4
 altd res 4, l                  ; 76 CB A5
 altd res 5, a                  ; 76 CB AF
 altd res 5, b                  ; 76 CB A8
 altd res 5, c                  ; 76 CB A9
 altd res 5, d                  ; 76 CB AA
 altd res 5, e                  ; 76 CB AB
 altd res 5, h                  ; 76 CB AC
 altd res 5, l                  ; 76 CB AD
 altd res 6, a                  ; 76 CB B7
 altd res 6, b                  ; 76 CB B0
 altd res 6, c                  ; 76 CB B1
 altd res 6, d                  ; 76 CB B2
 altd res 6, e                  ; 76 CB B3
 altd res 6, h                  ; 76 CB B4
 altd res 6, l                  ; 76 CB B5
 altd res 7, a                  ; 76 CB BF
 altd res 7, b                  ; 76 CB B8
 altd res 7, c                  ; 76 CB B9
 altd res 7, d                  ; 76 CB BA
 altd res 7, e                  ; 76 CB BB
 altd res 7, h                  ; 76 CB BC
 altd res 7, l                  ; 76 CB BD
 altd rl (hl)                   ; 76 CB 16
 altd rl (ix)                   ; 76 DD CB 00 16
 altd rl (ix+127)               ; 76 DD CB 7F 16
 altd rl (ix-128)               ; 76 DD CB 80 16
 altd rl (iy)                   ; 76 FD CB 00 16
 altd rl (iy+127)               ; 76 FD CB 7F 16
 altd rl (iy-128)               ; 76 FD CB 80 16
 altd rl a                      ; 76 CB 17
 altd rl b                      ; 76 CB 10
 altd rl c                      ; 76 CB 11
 altd rl d                      ; 76 CB 12
 altd rl de                     ; 76 F3
 altd rl e                      ; 76 CB 13
 altd rl h                      ; 76 CB 14
 altd rl l                      ; 76 CB 15
 altd rla                       ; 76 17
 altd rlc (hl)                  ; 76 CB 06
 altd rlc (ix)                  ; 76 DD CB 00 06
 altd rlc (ix+127)              ; 76 DD CB 7F 06
 altd rlc (ix-128)              ; 76 DD CB 80 06
 altd rlc (iy)                  ; 76 FD CB 00 06
 altd rlc (iy+127)              ; 76 FD CB 7F 06
 altd rlc (iy-128)              ; 76 FD CB 80 06
 altd rlc a                     ; 76 CB 07
 altd rlc b                     ; 76 CB 00
 altd rlc c                     ; 76 CB 01
 altd rlc d                     ; 76 CB 02
 altd rlc e                     ; 76 CB 03
 altd rlc h                     ; 76 CB 04
 altd rlc l                     ; 76 CB 05
 altd rlca                      ; 76 07
 altd rr (hl)                   ; 76 CB 1E
 altd rr (ix)                   ; 76 DD CB 00 1E
 altd rr (ix+127)               ; 76 DD CB 7F 1E
 altd rr (ix-128)               ; 76 DD CB 80 1E
 altd rr (iy)                   ; 76 FD CB 00 1E
 altd rr (iy+127)               ; 76 FD CB 7F 1E
 altd rr (iy-128)               ; 76 FD CB 80 1E
 altd rr a                      ; 76 CB 1F
 altd rr b                      ; 76 CB 18
 altd rr c                      ; 76 CB 19
 altd rr d                      ; 76 CB 1A
 altd rr de                     ; 76 FB
 altd rr e                      ; 76 CB 1B
 altd rr h                      ; 76 CB 1C
 altd rr hl                     ; 76 FC
 altd rr l                      ; 76 CB 1D
 altd rra                       ; 76 1F
 altd rrc (hl)                  ; 76 CB 0E
 altd rrc (ix)                  ; 76 DD CB 00 0E
 altd rrc (ix+127)              ; 76 DD CB 7F 0E
 altd rrc (ix-128)              ; 76 DD CB 80 0E
 altd rrc (iy)                  ; 76 FD CB 00 0E
 altd rrc (iy+127)              ; 76 FD CB 7F 0E
 altd rrc (iy-128)              ; 76 FD CB 80 0E
 altd rrc a                     ; 76 CB 0F
 altd rrc b                     ; 76 CB 08
 altd rrc c                     ; 76 CB 09
 altd rrc d                     ; 76 CB 0A
 altd rrc e                     ; 76 CB 0B
 altd rrc h                     ; 76 CB 0C
 altd rrc l                     ; 76 CB 0D
 altd rrca                      ; 76 0F
 altd sbc (hl)                  ; 76 9E
 altd sbc (hl+)                 ; 76 9E 23
 altd sbc (hl-)                 ; 76 9E 2B
 altd sbc (ix)                  ; 76 DD 9E 00
 altd sbc (ix+127)              ; 76 DD 9E 7F
 altd sbc (ix-128)              ; 76 DD 9E 80
 altd sbc (iy)                  ; 76 FD 9E 00
 altd sbc (iy+127)              ; 76 FD 9E 7F
 altd sbc (iy-128)              ; 76 FD 9E 80
 altd sbc -128                  ; 76 DE 80
 altd sbc 127                   ; 76 DE 7F
 altd sbc 255                   ; 76 DE FF
 altd sbc a                     ; 76 9F
 altd sbc a, (hl)               ; 76 9E
 altd sbc a, (hl+)              ; 76 9E 23
 altd sbc a, (hl-)              ; 76 9E 2B
 altd sbc a, (ix)               ; 76 DD 9E 00
 altd sbc a, (ix+127)           ; 76 DD 9E 7F
 altd sbc a, (ix-128)           ; 76 DD 9E 80
 altd sbc a, (iy)               ; 76 FD 9E 00
 altd sbc a, (iy+127)           ; 76 FD 9E 7F
 altd sbc a, (iy-128)           ; 76 FD 9E 80
 altd sbc a, -128               ; 76 DE 80
 altd sbc a, 127                ; 76 DE 7F
 altd sbc a, 255                ; 76 DE FF
 altd sbc a, a                  ; 76 9F
 altd sbc a, b                  ; 76 98
 altd sbc a, c                  ; 76 99
 altd sbc a, d                  ; 76 9A
 altd sbc a, e                  ; 76 9B
 altd sbc a, h                  ; 76 9C
 altd sbc a, l                  ; 76 9D
 altd sbc b                     ; 76 98
 altd sbc c                     ; 76 99
 altd sbc d                     ; 76 9A
 altd sbc e                     ; 76 9B
 altd sbc h                     ; 76 9C
 altd sbc hl, bc                ; 76 ED 42
 altd sbc hl, de                ; 76 ED 52
 altd sbc hl, hl                ; 76 ED 62
 altd sbc hl, sp                ; 76 ED 72
 altd sbc l                     ; 76 9D
 altd scf                       ; 76 37
 altd set 0, a                  ; 76 CB C7
 altd set 0, b                  ; 76 CB C0
 altd set 0, c                  ; 76 CB C1
 altd set 0, d                  ; 76 CB C2
 altd set 0, e                  ; 76 CB C3
 altd set 0, h                  ; 76 CB C4
 altd set 0, l                  ; 76 CB C5
 altd set 1, a                  ; 76 CB CF
 altd set 1, b                  ; 76 CB C8
 altd set 1, c                  ; 76 CB C9
 altd set 1, d                  ; 76 CB CA
 altd set 1, e                  ; 76 CB CB
 altd set 1, h                  ; 76 CB CC
 altd set 1, l                  ; 76 CB CD
 altd set 2, a                  ; 76 CB D7
 altd set 2, b                  ; 76 CB D0
 altd set 2, c                  ; 76 CB D1
 altd set 2, d                  ; 76 CB D2
 altd set 2, e                  ; 76 CB D3
 altd set 2, h                  ; 76 CB D4
 altd set 2, l                  ; 76 CB D5
 altd set 3, a                  ; 76 CB DF
 altd set 3, b                  ; 76 CB D8
 altd set 3, c                  ; 76 CB D9
 altd set 3, d                  ; 76 CB DA
 altd set 3, e                  ; 76 CB DB
 altd set 3, h                  ; 76 CB DC
 altd set 3, l                  ; 76 CB DD
 altd set 4, a                  ; 76 CB E7
 altd set 4, b                  ; 76 CB E0
 altd set 4, c                  ; 76 CB E1
 altd set 4, d                  ; 76 CB E2
 altd set 4, e                  ; 76 CB E3
 altd set 4, h                  ; 76 CB E4
 altd set 4, l                  ; 76 CB E5
 altd set 5, a                  ; 76 CB EF
 altd set 5, b                  ; 76 CB E8
 altd set 5, c                  ; 76 CB E9
 altd set 5, d                  ; 76 CB EA
 altd set 5, e                  ; 76 CB EB
 altd set 5, h                  ; 76 CB EC
 altd set 5, l                  ; 76 CB ED
 altd set 6, a                  ; 76 CB F7
 altd set 6, b                  ; 76 CB F0
 altd set 6, c                  ; 76 CB F1
 altd set 6, d                  ; 76 CB F2
 altd set 6, e                  ; 76 CB F3
 altd set 6, h                  ; 76 CB F4
 altd set 6, l                  ; 76 CB F5
 altd set 7, a                  ; 76 CB FF
 altd set 7, b                  ; 76 CB F8
 altd set 7, c                  ; 76 CB F9
 altd set 7, d                  ; 76 CB FA
 altd set 7, e                  ; 76 CB FB
 altd set 7, h                  ; 76 CB FC
 altd set 7, l                  ; 76 CB FD
 altd sla (hl)                  ; 76 CB 26
 altd sla (ix)                  ; 76 DD CB 00 26
 altd sla (ix+127)              ; 76 DD CB 7F 26
 altd sla (ix-128)              ; 76 DD CB 80 26
 altd sla (iy)                  ; 76 FD CB 00 26
 altd sla (iy+127)              ; 76 FD CB 7F 26
 altd sla (iy-128)              ; 76 FD CB 80 26
 altd sla a                     ; 76 CB 27
 altd sla b                     ; 76 CB 20
 altd sla c                     ; 76 CB 21
 altd sla d                     ; 76 CB 22
 altd sla e                     ; 76 CB 23
 altd sla h                     ; 76 CB 24
 altd sla l                     ; 76 CB 25
 altd sra (hl)                  ; 76 CB 2E
 altd sra (ix)                  ; 76 DD CB 00 2E
 altd sra (ix+127)              ; 76 DD CB 7F 2E
 altd sra (ix-128)              ; 76 DD CB 80 2E
 altd sra (iy)                  ; 76 FD CB 00 2E
 altd sra (iy+127)              ; 76 FD CB 7F 2E
 altd sra (iy-128)              ; 76 FD CB 80 2E
 altd sra a                     ; 76 CB 2F
 altd sra b                     ; 76 CB 28
 altd sra c                     ; 76 CB 29
 altd sra d                     ; 76 CB 2A
 altd sra e                     ; 76 CB 2B
 altd sra h                     ; 76 CB 2C
 altd sra l                     ; 76 CB 2D
 altd srl (hl)                  ; 76 CB 3E
 altd srl (ix)                  ; 76 DD CB 00 3E
 altd srl (ix+127)              ; 76 DD CB 7F 3E
 altd srl (ix-128)              ; 76 DD CB 80 3E
 altd srl (iy)                  ; 76 FD CB 00 3E
 altd srl (iy+127)              ; 76 FD CB 7F 3E
 altd srl (iy-128)              ; 76 FD CB 80 3E
 altd srl a                     ; 76 CB 3F
 altd srl b                     ; 76 CB 38
 altd srl c                     ; 76 CB 39
 altd srl d                     ; 76 CB 3A
 altd srl e                     ; 76 CB 3B
 altd srl h                     ; 76 CB 3C
 altd srl l                     ; 76 CB 3D
 altd sub (hl)                  ; 76 96
 altd sub (hl+)                 ; 76 96 23
 altd sub (hl-)                 ; 76 96 2B
 altd sub (ix)                  ; 76 DD 96 00
 altd sub (ix+127)              ; 76 DD 96 7F
 altd sub (ix-128)              ; 76 DD 96 80
 altd sub (iy)                  ; 76 FD 96 00
 altd sub (iy+127)              ; 76 FD 96 7F
 altd sub (iy-128)              ; 76 FD 96 80
 altd sub -128                  ; 76 D6 80
 altd sub 127                   ; 76 D6 7F
 altd sub 255                   ; 76 D6 FF
 altd sub a                     ; 76 97
 altd sub a, (hl)               ; 76 96
 altd sub a, (hl+)              ; 76 96 23
 altd sub a, (hl-)              ; 76 96 2B
 altd sub a, (ix)               ; 76 DD 96 00
 altd sub a, (ix+127)           ; 76 DD 96 7F
 altd sub a, (ix-128)           ; 76 DD 96 80
 altd sub a, (iy)               ; 76 FD 96 00
 altd sub a, (iy+127)           ; 76 FD 96 7F
 altd sub a, (iy-128)           ; 76 FD 96 80
 altd sub a, -128               ; 76 D6 80
 altd sub a, 127                ; 76 D6 7F
 altd sub a, 255                ; 76 D6 FF
 altd sub a, a                  ; 76 97
 altd sub a, b                  ; 76 90
 altd sub a, c                  ; 76 91
 altd sub a, d                  ; 76 92
 altd sub a, e                  ; 76 93
 altd sub a, h                  ; 76 94
 altd sub a, l                  ; 76 95
 altd sub b                     ; 76 90
 altd sub c                     ; 76 91
 altd sub d                     ; 76 92
 altd sub e                     ; 76 93
 altd sub h                     ; 76 94
 altd sub l                     ; 76 95
 altd xor (hl)                  ; 76 AE
 altd xor (hl+)                 ; 76 AE 23
 altd xor (hl-)                 ; 76 AE 2B
 altd xor (ix)                  ; 76 DD AE 00
 altd xor (ix+127)              ; 76 DD AE 7F
 altd xor (ix-128)              ; 76 DD AE 80
 altd xor (iy)                  ; 76 FD AE 00
 altd xor (iy+127)              ; 76 FD AE 7F
 altd xor (iy-128)              ; 76 FD AE 80
 altd xor -128                  ; 76 EE 80
 altd xor 127                   ; 76 EE 7F
 altd xor 255                   ; 76 EE FF
 altd xor a                     ; 76 AF
 altd xor a, (hl)               ; 76 AE
 altd xor a, (hl+)              ; 76 AE 23
 altd xor a, (hl-)              ; 76 AE 2B
 altd xor a, (ix)               ; 76 DD AE 00
 altd xor a, (ix+127)           ; 76 DD AE 7F
 altd xor a, (ix-128)           ; 76 DD AE 80
 altd xor a, (iy)               ; 76 FD AE 00
 altd xor a, (iy+127)           ; 76 FD AE 7F
 altd xor a, (iy-128)           ; 76 FD AE 80
 altd xor a, -128               ; 76 EE 80
 altd xor a, 127                ; 76 EE 7F
 altd xor a, 255                ; 76 EE FF
 altd xor a, a                  ; 76 AF
 altd xor a, b                  ; 76 A8
 altd xor a, c                  ; 76 A9
 altd xor a, d                  ; 76 AA
 altd xor a, e                  ; 76 AB
 altd xor a, h                  ; 76 AC
 altd xor a, l                  ; 76 AD
 altd xor b                     ; 76 A8
 altd xor c                     ; 76 A9
 altd xor d                     ; 76 AA
 altd xor e                     ; 76 AB
 altd xor h                     ; 76 AC
 altd xor l                     ; 76 AD
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
 and a', (hl)                   ; 76 A6
 and a', (hl+)                  ; 76 A6 23
 and a', (hl-)                  ; 76 A6 2B
 and a', (ix)                   ; 76 DD A6 00
 and a', (ix+127)               ; 76 DD A6 7F
 and a', (ix-128)               ; 76 DD A6 80
 and a', (iy)                   ; 76 FD A6 00
 and a', (iy+127)               ; 76 FD A6 7F
 and a', (iy-128)               ; 76 FD A6 80
 and a', -128                   ; 76 E6 80
 and a', 127                    ; 76 E6 7F
 and a', 255                    ; 76 E6 FF
 and a', a                      ; 76 A7
 and a', b                      ; 76 A0
 and a', c                      ; 76 A1
 and a', d                      ; 76 A2
 and a', e                      ; 76 A3
 and a', h                      ; 76 A4
 and a', l                      ; 76 A5
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
 and a, l                       ; A5
 and b                          ; A0
 and c                          ; A1
 and d                          ; A2
 and e                          ; A3
 and h                          ; A4
 and hl', de                    ; 76 DC
 and hl, de                     ; DC
 and ix, de                     ; DD DC
 and iy, de                     ; FD DC
 and l                          ; A5
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
 bool hl                        ; CC
 bool hl'                       ; 76 CC
 bool ix                        ; DD CC
 bool iy                        ; FD CC
 c_c -32768                     ; 30 03 CD 00 80
 c_c 32767                      ; 30 03 CD FF 7F
 c_c 65535                      ; 30 03 CD FF FF
 c_lo -32768                    ; E2 A8 1C CD 00 80
 c_lo 32767                     ; E2 AE 1C CD FF 7F
 c_lo 65535                     ; E2 B4 1C CD FF FF
 c_lz -32768                    ; EA BA 1C CD 00 80
 c_lz 32767                     ; EA C0 1C CD FF 7F
 c_lz 65535                     ; EA C6 1C CD FF FF
 c_m -32768                     ; F2 CC 1C CD 00 80
 c_m 32767                      ; F2 D2 1C CD FF 7F
 c_m 65535                      ; F2 D8 1C CD FF FF
 c_nc -32768                    ; 38 03 CD 00 80
 c_nc 32767                     ; 38 03 CD FF 7F
 c_nc 65535                     ; 38 03 CD FF FF
 c_nv -32768                    ; EA ED 1C CD 00 80
 c_nv 32767                     ; EA F3 1C CD FF 7F
 c_nv 65535                     ; EA F9 1C CD FF FF
 c_nz -32768                    ; 28 03 CD 00 80
 c_nz 32767                     ; 28 03 CD FF 7F
 c_nz 65535                     ; 28 03 CD FF FF
 c_p -32768                     ; FA 0E 1D CD 00 80
 c_p 32767                      ; FA 14 1D CD FF 7F
 c_p 65535                      ; FA 1A 1D CD FF FF
 c_pe -32768                    ; E2 20 1D CD 00 80
 c_pe 32767                     ; E2 26 1D CD FF 7F
 c_pe 65535                     ; E2 2C 1D CD FF FF
 c_po -32768                    ; EA 32 1D CD 00 80
 c_po 32767                     ; EA 38 1D CD FF 7F
 c_po 65535                     ; EA 3E 1D CD FF FF
 c_v -32768                     ; E2 44 1D CD 00 80
 c_v 32767                      ; E2 4A 1D CD FF 7F
 c_v 65535                      ; E2 50 1D CD FF FF
 c_z -32768                     ; 20 03 CD 00 80
 c_z 32767                      ; 20 03 CD FF 7F
 c_z 65535                      ; 20 03 CD FF FF
 call -32768                    ; CD 00 80
 call 32767                     ; CD FF 7F
 call 65535                     ; CD FF FF
 call c, -32768                 ; 30 03 CD 00 80
 call c, 32767                  ; 30 03 CD FF 7F
 call c, 65535                  ; 30 03 CD FF FF
 call lo, -32768                ; E2 7D 1D CD 00 80
 call lo, 32767                 ; E2 83 1D CD FF 7F
 call lo, 65535                 ; E2 89 1D CD FF FF
 call lz, -32768                ; EA 8F 1D CD 00 80
 call lz, 32767                 ; EA 95 1D CD FF 7F
 call lz, 65535                 ; EA 9B 1D CD FF FF
 call m, -32768                 ; F2 A1 1D CD 00 80
 call m, 32767                  ; F2 A7 1D CD FF 7F
 call m, 65535                  ; F2 AD 1D CD FF FF
 call nc, -32768                ; 38 03 CD 00 80
 call nc, 32767                 ; 38 03 CD FF 7F
 call nc, 65535                 ; 38 03 CD FF FF
 call nv, -32768                ; EA C2 1D CD 00 80
 call nv, 32767                 ; EA C8 1D CD FF 7F
 call nv, 65535                 ; EA CE 1D CD FF FF
 call nz, -32768                ; 28 03 CD 00 80
 call nz, 32767                 ; 28 03 CD FF 7F
 call nz, 65535                 ; 28 03 CD FF FF
 call p, -32768                 ; FA E3 1D CD 00 80
 call p, 32767                  ; FA E9 1D CD FF 7F
 call p, 65535                  ; FA EF 1D CD FF FF
 call pe, -32768                ; E2 F5 1D CD 00 80
 call pe, 32767                 ; E2 FB 1D CD FF 7F
 call pe, 65535                 ; E2 01 1E CD FF FF
 call po, -32768                ; EA 07 1E CD 00 80
 call po, 32767                 ; EA 0D 1E CD FF 7F
 call po, 65535                 ; EA 13 1E CD FF FF
 call v, -32768                 ; E2 19 1E CD 00 80
 call v, 32767                  ; E2 1F 1E CD FF 7F
 call v, 65535                  ; E2 25 1E CD FF FF
 call z, -32768                 ; 20 03 CD 00 80
 call z, 32767                  ; 20 03 CD FF 7F
 call z, 65535                  ; 20 03 CD FF FF
 cc -32768                      ; 30 03 CD 00 80
 cc 32767                       ; 30 03 CD FF 7F
 cc 65535                       ; 30 03 CD FF FF
 ccf                            ; 3F
 ccf'                           ; 76 3F
 clo -32768                     ; E2 4C 1E CD 00 80
 clo 32767                      ; E2 52 1E CD FF 7F
 clo 65535                      ; E2 58 1E CD FF FF
 clz -32768                     ; EA 5E 1E CD 00 80
 clz 32767                      ; EA 64 1E CD FF 7F
 clz 65535                      ; EA 6A 1E CD FF FF
 cm -32768                      ; F2 70 1E CD 00 80
 cm 32767                       ; F2 76 1E CD FF 7F
 cm 65535                       ; F2 7C 1E CD FF FF
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
 cmp a, l                       ; BD
 cmp b                          ; B8
 cmp c                          ; B9
 cmp d                          ; BA
 cmp e                          ; BB
 cmp h                          ; BC
 cmp l                          ; BD
 cmp m                          ; BE
 cnc -32768                     ; 38 03 CD 00 80
 cnc 32767                      ; 38 03 CD FF 7F
 cnc 65535                      ; 38 03 CD FF FF
 cnv -32768                     ; EA DC 1E CD 00 80
 cnv 32767                      ; EA E2 1E CD FF 7F
 cnv 65535                      ; EA E8 1E CD FF FF
 cnz -32768                     ; 28 03 CD 00 80
 cnz 32767                      ; 28 03 CD FF 7F
 cnz 65535                      ; 28 03 CD FF FF
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
 cp a, l                        ; BD
 cp b                           ; B8
 cp c                           ; B9
 cp d                           ; BA
 cp e                           ; BB
 cp h                           ; BC
 cp l                           ; BD
 cpd                            ; CD @__z80asm__cpd
 cpdr                           ; CD @__z80asm__cpdr
 cpe -32768                     ; E2 4B 1F CD 00 80
 cpe 32767                      ; E2 51 1F CD FF 7F
 cpe 65535                      ; E2 57 1F CD FF FF
 cpi                            ; CD @__z80asm__cpi
 cpi -128                       ; FE 80
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpir                           ; CD @__z80asm__cpir
 cpl                            ; 2F
 cpl a                          ; 2F
 cpl a'                         ; 76 2F
 cpo -32768                     ; EA 6D 1F CD 00 80
 cpo 32767                      ; EA 73 1F CD FF 7F
 cpo 65535                      ; EA 79 1F CD FF FF
 cv -32768                      ; E2 7F 1F CD 00 80
 cv 32767                       ; E2 85 1F CD FF 7F
 cv 65535                       ; E2 8B 1F CD FF FF
 cz -32768                      ; 20 03 CD 00 80
 cz 32767                       ; 20 03 CD FF 7F
 cz 65535                       ; 20 03 CD FF FF
 daa                            ; CD @__z80asm__daa
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
 dec a'                         ; 76 3D
 dec b                          ; 05
 dec b'                         ; 76 05
 dec bc                         ; 0B
 dec bc'                        ; 76 0B
 dec c                          ; 0D
 dec c'                         ; 76 0D
 dec d                          ; 15
 dec d'                         ; 76 15
 dec de                         ; 1B
 dec de'                        ; 76 1B
 dec e                          ; 1D
 dec e'                         ; 76 1D
 dec h                          ; 25
 dec h'                         ; 76 25
 dec hl                         ; 2B
 dec hl'                        ; 76 2B
 dec ix                         ; DD 2B
 dec iy                         ; FD 2B
 dec l                          ; 2D
 dec l'                         ; 76 2D
 dec sp                         ; 3B
 djnz ASMPC                     ; 10 FE
 djnz b', ASMPC                 ; 76 10 FE
 djnz b, ASMPC                  ; 10 FE
 dsub                           ; CD @__z80asm__sub_hl_bc
 ex (sp), hl                    ; ED 54
 ex (sp), hl'                   ; 76 ED 54
 ex (sp), ix                    ; DD E3
 ex (sp), iy                    ; FD E3
 ex af, af                      ; 08
 ex af, af'                     ; 08
 ex de', hl                     ; E3
 ex de', hl'                    ; 76 E3
 ex de, hl                      ; EB
 ex de, hl'                     ; 76 EB
 exx                            ; D9
 idet                           ; 5B
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
 inc a'                         ; 76 3C
 inc b                          ; 04
 inc b'                         ; 76 04
 inc bc                         ; 03
 inc bc'                        ; 76 03
 inc c                          ; 0C
 inc c'                         ; 76 0C
 inc d                          ; 14
 inc d'                         ; 76 14
 inc de                         ; 13
 inc de'                        ; 76 13
 inc e                          ; 1C
 inc e'                         ; 76 1C
 inc h                          ; 24
 inc h'                         ; 76 24
 inc hl                         ; 23
 inc hl'                        ; 76 23
 inc ix                         ; DD 23
 inc iy                         ; FD 23
 inc l                          ; 2C
 inc l'                         ; 76 2C
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
 inx bc                         ; 03
 inx d                          ; 13
 inx de                         ; 13
 inx h                          ; 23
 inx hl                         ; 23
 inx sp                         ; 33
 ioe adc (hl)                   ; DB 8E
 ioe adc (hl+)                  ; DB 8E 23
 ioe adc (hl-)                  ; DB 8E 2B
 ioe adc (ix)                   ; DB DD 8E 00
 ioe adc (ix+127)               ; DB DD 8E 7F
 ioe adc (ix-128)               ; DB DD 8E 80
 ioe adc (iy)                   ; DB FD 8E 00
 ioe adc (iy+127)               ; DB FD 8E 7F
 ioe adc (iy-128)               ; DB FD 8E 80
 ioe adc a', (hl)               ; DB 76 8E
 ioe adc a', (hl+)              ; DB 76 8E 23
 ioe adc a', (hl-)              ; DB 76 8E 2B
 ioe adc a', (ix)               ; DB 76 DD 8E 00
 ioe adc a', (ix+127)           ; DB 76 DD 8E 7F
 ioe adc a', (ix-128)           ; DB 76 DD 8E 80
 ioe adc a', (iy)               ; DB 76 FD 8E 00
 ioe adc a', (iy+127)           ; DB 76 FD 8E 7F
 ioe adc a', (iy-128)           ; DB 76 FD 8E 80
 ioe adc a, (hl)                ; DB 8E
 ioe adc a, (hl+)               ; DB 8E 23
 ioe adc a, (hl-)               ; DB 8E 2B
 ioe adc a, (ix)                ; DB DD 8E 00
 ioe adc a, (ix+127)            ; DB DD 8E 7F
 ioe adc a, (ix-128)            ; DB DD 8E 80
 ioe adc a, (iy)                ; DB FD 8E 00
 ioe adc a, (iy+127)            ; DB FD 8E 7F
 ioe adc a, (iy-128)            ; DB FD 8E 80
 ioe add (hl)                   ; DB 86
 ioe add (hl+)                  ; DB 86 23
 ioe add (hl-)                  ; DB 86 2B
 ioe add (ix)                   ; DB DD 86 00
 ioe add (ix+127)               ; DB DD 86 7F
 ioe add (ix-128)               ; DB DD 86 80
 ioe add (iy)                   ; DB FD 86 00
 ioe add (iy+127)               ; DB FD 86 7F
 ioe add (iy-128)               ; DB FD 86 80
 ioe add a', (hl)               ; DB 76 86
 ioe add a', (hl+)              ; DB 76 86 23
 ioe add a', (hl-)              ; DB 76 86 2B
 ioe add a', (ix)               ; DB 76 DD 86 00
 ioe add a', (ix+127)           ; DB 76 DD 86 7F
 ioe add a', (ix-128)           ; DB 76 DD 86 80
 ioe add a', (iy)               ; DB 76 FD 86 00
 ioe add a', (iy+127)           ; DB 76 FD 86 7F
 ioe add a', (iy-128)           ; DB 76 FD 86 80
 ioe add a, (hl)                ; DB 86
 ioe add a, (hl+)               ; DB 86 23
 ioe add a, (hl-)               ; DB 86 2B
 ioe add a, (ix)                ; DB DD 86 00
 ioe add a, (ix+127)            ; DB DD 86 7F
 ioe add a, (ix-128)            ; DB DD 86 80
 ioe add a, (iy)                ; DB FD 86 00
 ioe add a, (iy+127)            ; DB FD 86 7F
 ioe add a, (iy-128)            ; DB FD 86 80
 ioe altd adc (hl)              ; DB 76 8E
 ioe altd adc (hl+)             ; DB 76 8E 23
 ioe altd adc (hl-)             ; DB 76 8E 2B
 ioe altd adc (ix)              ; DB 76 DD 8E 00
 ioe altd adc (ix+127)          ; DB 76 DD 8E 7F
 ioe altd adc (ix-128)          ; DB 76 DD 8E 80
 ioe altd adc (iy)              ; DB 76 FD 8E 00
 ioe altd adc (iy+127)          ; DB 76 FD 8E 7F
 ioe altd adc (iy-128)          ; DB 76 FD 8E 80
 ioe altd adc a, (hl)           ; DB 76 8E
 ioe altd adc a, (hl+)          ; DB 76 8E 23
 ioe altd adc a, (hl-)          ; DB 76 8E 2B
 ioe altd adc a, (ix)           ; DB 76 DD 8E 00
 ioe altd adc a, (ix+127)       ; DB 76 DD 8E 7F
 ioe altd adc a, (ix-128)       ; DB 76 DD 8E 80
 ioe altd adc a, (iy)           ; DB 76 FD 8E 00
 ioe altd adc a, (iy+127)       ; DB 76 FD 8E 7F
 ioe altd adc a, (iy-128)       ; DB 76 FD 8E 80
 ioe altd add (hl)              ; DB 76 86
 ioe altd add (hl+)             ; DB 76 86 23
 ioe altd add (hl-)             ; DB 76 86 2B
 ioe altd add (ix)              ; DB 76 DD 86 00
 ioe altd add (ix+127)          ; DB 76 DD 86 7F
 ioe altd add (ix-128)          ; DB 76 DD 86 80
 ioe altd add (iy)              ; DB 76 FD 86 00
 ioe altd add (iy+127)          ; DB 76 FD 86 7F
 ioe altd add (iy-128)          ; DB 76 FD 86 80
 ioe altd add a, (hl)           ; DB 76 86
 ioe altd add a, (hl+)          ; DB 76 86 23
 ioe altd add a, (hl-)          ; DB 76 86 2B
 ioe altd add a, (ix)           ; DB 76 DD 86 00
 ioe altd add a, (ix+127)       ; DB 76 DD 86 7F
 ioe altd add a, (ix-128)       ; DB 76 DD 86 80
 ioe altd add a, (iy)           ; DB 76 FD 86 00
 ioe altd add a, (iy+127)       ; DB 76 FD 86 7F
 ioe altd add a, (iy-128)       ; DB 76 FD 86 80
 ioe altd and (hl)              ; DB 76 A6
 ioe altd and (hl+)             ; DB 76 A6 23
 ioe altd and (hl-)             ; DB 76 A6 2B
 ioe altd and (ix)              ; DB 76 DD A6 00
 ioe altd and (ix+127)          ; DB 76 DD A6 7F
 ioe altd and (ix-128)          ; DB 76 DD A6 80
 ioe altd and (iy)              ; DB 76 FD A6 00
 ioe altd and (iy+127)          ; DB 76 FD A6 7F
 ioe altd and (iy-128)          ; DB 76 FD A6 80
 ioe altd and a, (hl)           ; DB 76 A6
 ioe altd and a, (hl+)          ; DB 76 A6 23
 ioe altd and a, (hl-)          ; DB 76 A6 2B
 ioe altd and a, (ix)           ; DB 76 DD A6 00
 ioe altd and a, (ix+127)       ; DB 76 DD A6 7F
 ioe altd and a, (ix-128)       ; DB 76 DD A6 80
 ioe altd and a, (iy)           ; DB 76 FD A6 00
 ioe altd and a, (iy+127)       ; DB 76 FD A6 7F
 ioe altd and a, (iy-128)       ; DB 76 FD A6 80
 ioe altd bit 0, (hl)           ; DB 76 CB 46
 ioe altd bit 0, (ix)           ; DB 76 DD CB 00 46
 ioe altd bit 0, (ix+127)       ; DB 76 DD CB 7F 46
 ioe altd bit 0, (ix-128)       ; DB 76 DD CB 80 46
 ioe altd bit 0, (iy)           ; DB 76 FD CB 00 46
 ioe altd bit 0, (iy+127)       ; DB 76 FD CB 7F 46
 ioe altd bit 0, (iy-128)       ; DB 76 FD CB 80 46
 ioe altd bit 1, (hl)           ; DB 76 CB 4E
 ioe altd bit 1, (ix)           ; DB 76 DD CB 00 4E
 ioe altd bit 1, (ix+127)       ; DB 76 DD CB 7F 4E
 ioe altd bit 1, (ix-128)       ; DB 76 DD CB 80 4E
 ioe altd bit 1, (iy)           ; DB 76 FD CB 00 4E
 ioe altd bit 1, (iy+127)       ; DB 76 FD CB 7F 4E
 ioe altd bit 1, (iy-128)       ; DB 76 FD CB 80 4E
 ioe altd bit 2, (hl)           ; DB 76 CB 56
 ioe altd bit 2, (ix)           ; DB 76 DD CB 00 56
 ioe altd bit 2, (ix+127)       ; DB 76 DD CB 7F 56
 ioe altd bit 2, (ix-128)       ; DB 76 DD CB 80 56
 ioe altd bit 2, (iy)           ; DB 76 FD CB 00 56
 ioe altd bit 2, (iy+127)       ; DB 76 FD CB 7F 56
 ioe altd bit 2, (iy-128)       ; DB 76 FD CB 80 56
 ioe altd bit 3, (hl)           ; DB 76 CB 5E
 ioe altd bit 3, (ix)           ; DB 76 DD CB 00 5E
 ioe altd bit 3, (ix+127)       ; DB 76 DD CB 7F 5E
 ioe altd bit 3, (ix-128)       ; DB 76 DD CB 80 5E
 ioe altd bit 3, (iy)           ; DB 76 FD CB 00 5E
 ioe altd bit 3, (iy+127)       ; DB 76 FD CB 7F 5E
 ioe altd bit 3, (iy-128)       ; DB 76 FD CB 80 5E
 ioe altd bit 4, (hl)           ; DB 76 CB 66
 ioe altd bit 4, (ix)           ; DB 76 DD CB 00 66
 ioe altd bit 4, (ix+127)       ; DB 76 DD CB 7F 66
 ioe altd bit 4, (ix-128)       ; DB 76 DD CB 80 66
 ioe altd bit 4, (iy)           ; DB 76 FD CB 00 66
 ioe altd bit 4, (iy+127)       ; DB 76 FD CB 7F 66
 ioe altd bit 4, (iy-128)       ; DB 76 FD CB 80 66
 ioe altd bit 5, (hl)           ; DB 76 CB 6E
 ioe altd bit 5, (ix)           ; DB 76 DD CB 00 6E
 ioe altd bit 5, (ix+127)       ; DB 76 DD CB 7F 6E
 ioe altd bit 5, (ix-128)       ; DB 76 DD CB 80 6E
 ioe altd bit 5, (iy)           ; DB 76 FD CB 00 6E
 ioe altd bit 5, (iy+127)       ; DB 76 FD CB 7F 6E
 ioe altd bit 5, (iy-128)       ; DB 76 FD CB 80 6E
 ioe altd bit 6, (hl)           ; DB 76 CB 76
 ioe altd bit 6, (ix)           ; DB 76 DD CB 00 76
 ioe altd bit 6, (ix+127)       ; DB 76 DD CB 7F 76
 ioe altd bit 6, (ix-128)       ; DB 76 DD CB 80 76
 ioe altd bit 6, (iy)           ; DB 76 FD CB 00 76
 ioe altd bit 6, (iy+127)       ; DB 76 FD CB 7F 76
 ioe altd bit 6, (iy-128)       ; DB 76 FD CB 80 76
 ioe altd bit 7, (hl)           ; DB 76 CB 7E
 ioe altd bit 7, (ix)           ; DB 76 DD CB 00 7E
 ioe altd bit 7, (ix+127)       ; DB 76 DD CB 7F 7E
 ioe altd bit 7, (ix-128)       ; DB 76 DD CB 80 7E
 ioe altd bit 7, (iy)           ; DB 76 FD CB 00 7E
 ioe altd bit 7, (iy+127)       ; DB 76 FD CB 7F 7E
 ioe altd bit 7, (iy-128)       ; DB 76 FD CB 80 7E
 ioe altd cp (hl)               ; DB 76 BE
 ioe altd cp (hl+)              ; DB 76 BE 23
 ioe altd cp (hl-)              ; DB 76 BE 2B
 ioe altd cp (ix)               ; DB 76 DD BE 00
 ioe altd cp (ix+127)           ; DB 76 DD BE 7F
 ioe altd cp (ix-128)           ; DB 76 DD BE 80
 ioe altd cp (iy)               ; DB 76 FD BE 00
 ioe altd cp (iy+127)           ; DB 76 FD BE 7F
 ioe altd cp (iy-128)           ; DB 76 FD BE 80
 ioe altd cp a, (hl)            ; DB 76 BE
 ioe altd cp a, (hl+)           ; DB 76 BE 23
 ioe altd cp a, (hl-)           ; DB 76 BE 2B
 ioe altd cp a, (ix)            ; DB 76 DD BE 00
 ioe altd cp a, (ix+127)        ; DB 76 DD BE 7F
 ioe altd cp a, (ix-128)        ; DB 76 DD BE 80
 ioe altd cp a, (iy)            ; DB 76 FD BE 00
 ioe altd cp a, (iy+127)        ; DB 76 FD BE 7F
 ioe altd cp a, (iy-128)        ; DB 76 FD BE 80
 ioe altd dec (hl)              ; DB 76 35
 ioe altd dec (hl+)             ; DB 76 35 23
 ioe altd dec (hl-)             ; DB 76 35 2B
 ioe altd dec (ix)              ; DB 76 DD 35 00
 ioe altd dec (ix+127)          ; DB 76 DD 35 7F
 ioe altd dec (ix-128)          ; DB 76 DD 35 80
 ioe altd dec (iy)              ; DB 76 FD 35 00
 ioe altd dec (iy+127)          ; DB 76 FD 35 7F
 ioe altd dec (iy-128)          ; DB 76 FD 35 80
 ioe altd inc (hl)              ; DB 76 34
 ioe altd inc (hl+)             ; DB 76 34 23
 ioe altd inc (hl-)             ; DB 76 34 2B
 ioe altd inc (ix)              ; DB 76 DD 34 00
 ioe altd inc (ix+127)          ; DB 76 DD 34 7F
 ioe altd inc (ix-128)          ; DB 76 DD 34 80
 ioe altd inc (iy)              ; DB 76 FD 34 00
 ioe altd inc (iy+127)          ; DB 76 FD 34 7F
 ioe altd inc (iy-128)          ; DB 76 FD 34 80
 ioe altd ld a, (-32768)        ; DB 76 3A 00 80
 ioe altd ld a, (32767)         ; DB 76 3A FF 7F
 ioe altd ld a, (65535)         ; DB 76 3A FF FF
 ioe altd ld a, (bc)            ; DB 76 0A
 ioe altd ld a, (bc+)           ; DB 76 0A 03
 ioe altd ld a, (bc-)           ; DB 76 0A 0B
 ioe altd ld a, (de)            ; DB 76 1A
 ioe altd ld a, (de+)           ; DB 76 1A 13
 ioe altd ld a, (de-)           ; DB 76 1A 1B
 ioe altd ld a, (hl)            ; DB 76 7E
 ioe altd ld a, (hl+)           ; DB 76 7E 23
 ioe altd ld a, (hl-)           ; DB 76 7E 2B
 ioe altd ld a, (hld)           ; DB 76 7E 2B
 ioe altd ld a, (hli)           ; DB 76 7E 23
 ioe altd ld a, (ix)            ; DB 76 DD 7E 00
 ioe altd ld a, (ix+127)        ; DB 76 DD 7E 7F
 ioe altd ld a, (ix-128)        ; DB 76 DD 7E 80
 ioe altd ld a, (iy)            ; DB 76 FD 7E 00
 ioe altd ld a, (iy+127)        ; DB 76 FD 7E 7F
 ioe altd ld a, (iy-128)        ; DB 76 FD 7E 80
 ioe altd ld b, (hl)            ; DB 76 46
 ioe altd ld b, (hl+)           ; DB 76 46 23
 ioe altd ld b, (hl-)           ; DB 76 46 2B
 ioe altd ld b, (hld)           ; DB 76 46 2B
 ioe altd ld b, (hli)           ; DB 76 46 23
 ioe altd ld b, (ix)            ; DB 76 DD 46 00
 ioe altd ld b, (ix+127)        ; DB 76 DD 46 7F
 ioe altd ld b, (ix-128)        ; DB 76 DD 46 80
 ioe altd ld b, (iy)            ; DB 76 FD 46 00
 ioe altd ld b, (iy+127)        ; DB 76 FD 46 7F
 ioe altd ld b, (iy-128)        ; DB 76 FD 46 80
 ioe altd ld bc, (-32768)       ; DB 76 ED 4B 00 80
 ioe altd ld bc, (32767)        ; DB 76 ED 4B FF 7F
 ioe altd ld bc, (65535)        ; DB 76 ED 4B FF FF
 ioe altd ld c, (hl)            ; DB 76 4E
 ioe altd ld c, (hl+)           ; DB 76 4E 23
 ioe altd ld c, (hl-)           ; DB 76 4E 2B
 ioe altd ld c, (hld)           ; DB 76 4E 2B
 ioe altd ld c, (hli)           ; DB 76 4E 23
 ioe altd ld c, (ix)            ; DB 76 DD 4E 00
 ioe altd ld c, (ix+127)        ; DB 76 DD 4E 7F
 ioe altd ld c, (ix-128)        ; DB 76 DD 4E 80
 ioe altd ld c, (iy)            ; DB 76 FD 4E 00
 ioe altd ld c, (iy+127)        ; DB 76 FD 4E 7F
 ioe altd ld c, (iy-128)        ; DB 76 FD 4E 80
 ioe altd ld d, (hl)            ; DB 76 56
 ioe altd ld d, (hl+)           ; DB 76 56 23
 ioe altd ld d, (hl-)           ; DB 76 56 2B
 ioe altd ld d, (hld)           ; DB 76 56 2B
 ioe altd ld d, (hli)           ; DB 76 56 23
 ioe altd ld d, (ix)            ; DB 76 DD 56 00
 ioe altd ld d, (ix+127)        ; DB 76 DD 56 7F
 ioe altd ld d, (ix-128)        ; DB 76 DD 56 80
 ioe altd ld d, (iy)            ; DB 76 FD 56 00
 ioe altd ld d, (iy+127)        ; DB 76 FD 56 7F
 ioe altd ld d, (iy-128)        ; DB 76 FD 56 80
 ioe altd ld de, (-32768)       ; DB 76 ED 5B 00 80
 ioe altd ld de, (32767)        ; DB 76 ED 5B FF 7F
 ioe altd ld de, (65535)        ; DB 76 ED 5B FF FF
 ioe altd ld e, (hl)            ; DB 76 5E
 ioe altd ld e, (hl+)           ; DB 76 5E 23
 ioe altd ld e, (hl-)           ; DB 76 5E 2B
 ioe altd ld e, (hld)           ; DB 76 5E 2B
 ioe altd ld e, (hli)           ; DB 76 5E 23
 ioe altd ld e, (ix)            ; DB 76 DD 5E 00
 ioe altd ld e, (ix+127)        ; DB 76 DD 5E 7F
 ioe altd ld e, (ix-128)        ; DB 76 DD 5E 80
 ioe altd ld e, (iy)            ; DB 76 FD 5E 00
 ioe altd ld e, (iy+127)        ; DB 76 FD 5E 7F
 ioe altd ld e, (iy-128)        ; DB 76 FD 5E 80
 ioe altd ld h, (hl)            ; DB 76 66
 ioe altd ld h, (hl+)           ; DB 76 66 23
 ioe altd ld h, (hl-)           ; DB 76 66 2B
 ioe altd ld h, (hld)           ; DB 76 66 2B
 ioe altd ld h, (hli)           ; DB 76 66 23
 ioe altd ld h, (ix)            ; DB 76 DD 66 00
 ioe altd ld h, (ix+127)        ; DB 76 DD 66 7F
 ioe altd ld h, (ix-128)        ; DB 76 DD 66 80
 ioe altd ld h, (iy)            ; DB 76 FD 66 00
 ioe altd ld h, (iy+127)        ; DB 76 FD 66 7F
 ioe altd ld h, (iy-128)        ; DB 76 FD 66 80
 ioe altd ld hl, (-32768)       ; DB 76 2A 00 80
 ioe altd ld hl, (32767)        ; DB 76 2A FF 7F
 ioe altd ld hl, (65535)        ; DB 76 2A FF FF
 ioe altd ld hl, (hl)           ; DB 76 DD E4 00
 ioe altd ld hl, (hl+127)       ; DB 76 DD E4 7F
 ioe altd ld hl, (hl-128)       ; DB 76 DD E4 80
 ioe altd ld hl, (ix)           ; DB 76 E4 00
 ioe altd ld hl, (ix+127)       ; DB 76 E4 7F
 ioe altd ld hl, (ix-128)       ; DB 76 E4 80
 ioe altd ld hl, (iy)           ; DB 76 FD E4 00
 ioe altd ld hl, (iy+127)       ; DB 76 FD E4 7F
 ioe altd ld hl, (iy-128)       ; DB 76 FD E4 80
 ioe altd ld l, (hl)            ; DB 76 6E
 ioe altd ld l, (hl+)           ; DB 76 6E 23
 ioe altd ld l, (hl-)           ; DB 76 6E 2B
 ioe altd ld l, (hld)           ; DB 76 6E 2B
 ioe altd ld l, (hli)           ; DB 76 6E 23
 ioe altd ld l, (ix)            ; DB 76 DD 6E 00
 ioe altd ld l, (ix+127)        ; DB 76 DD 6E 7F
 ioe altd ld l, (ix-128)        ; DB 76 DD 6E 80
 ioe altd ld l, (iy)            ; DB 76 FD 6E 00
 ioe altd ld l, (iy+127)        ; DB 76 FD 6E 7F
 ioe altd ld l, (iy-128)        ; DB 76 FD 6E 80
 ioe altd or (hl)               ; DB 76 B6
 ioe altd or (hl+)              ; DB 76 B6 23
 ioe altd or (hl-)              ; DB 76 B6 2B
 ioe altd or (ix)               ; DB 76 DD B6 00
 ioe altd or (ix+127)           ; DB 76 DD B6 7F
 ioe altd or (ix-128)           ; DB 76 DD B6 80
 ioe altd or (iy)               ; DB 76 FD B6 00
 ioe altd or (iy+127)           ; DB 76 FD B6 7F
 ioe altd or (iy-128)           ; DB 76 FD B6 80
 ioe altd or a, (hl)            ; DB 76 B6
 ioe altd or a, (hl+)           ; DB 76 B6 23
 ioe altd or a, (hl-)           ; DB 76 B6 2B
 ioe altd or a, (ix)            ; DB 76 DD B6 00
 ioe altd or a, (ix+127)        ; DB 76 DD B6 7F
 ioe altd or a, (ix-128)        ; DB 76 DD B6 80
 ioe altd or a, (iy)            ; DB 76 FD B6 00
 ioe altd or a, (iy+127)        ; DB 76 FD B6 7F
 ioe altd or a, (iy-128)        ; DB 76 FD B6 80
 ioe altd rl (hl)               ; DB 76 CB 16
 ioe altd rl (ix)               ; DB 76 DD CB 00 16
 ioe altd rl (ix+127)           ; DB 76 DD CB 7F 16
 ioe altd rl (ix-128)           ; DB 76 DD CB 80 16
 ioe altd rl (iy)               ; DB 76 FD CB 00 16
 ioe altd rl (iy+127)           ; DB 76 FD CB 7F 16
 ioe altd rl (iy-128)           ; DB 76 FD CB 80 16
 ioe altd rlc (hl)              ; DB 76 CB 06
 ioe altd rlc (ix)              ; DB 76 DD CB 00 06
 ioe altd rlc (ix+127)          ; DB 76 DD CB 7F 06
 ioe altd rlc (ix-128)          ; DB 76 DD CB 80 06
 ioe altd rlc (iy)              ; DB 76 FD CB 00 06
 ioe altd rlc (iy+127)          ; DB 76 FD CB 7F 06
 ioe altd rlc (iy-128)          ; DB 76 FD CB 80 06
 ioe altd rr (hl)               ; DB 76 CB 1E
 ioe altd rr (ix)               ; DB 76 DD CB 00 1E
 ioe altd rr (ix+127)           ; DB 76 DD CB 7F 1E
 ioe altd rr (ix-128)           ; DB 76 DD CB 80 1E
 ioe altd rr (iy)               ; DB 76 FD CB 00 1E
 ioe altd rr (iy+127)           ; DB 76 FD CB 7F 1E
 ioe altd rr (iy-128)           ; DB 76 FD CB 80 1E
 ioe altd rrc (hl)              ; DB 76 CB 0E
 ioe altd rrc (ix)              ; DB 76 DD CB 00 0E
 ioe altd rrc (ix+127)          ; DB 76 DD CB 7F 0E
 ioe altd rrc (ix-128)          ; DB 76 DD CB 80 0E
 ioe altd rrc (iy)              ; DB 76 FD CB 00 0E
 ioe altd rrc (iy+127)          ; DB 76 FD CB 7F 0E
 ioe altd rrc (iy-128)          ; DB 76 FD CB 80 0E
 ioe altd sbc (hl)              ; DB 76 9E
 ioe altd sbc (hl+)             ; DB 76 9E 23
 ioe altd sbc (hl-)             ; DB 76 9E 2B
 ioe altd sbc (ix)              ; DB 76 DD 9E 00
 ioe altd sbc (ix+127)          ; DB 76 DD 9E 7F
 ioe altd sbc (ix-128)          ; DB 76 DD 9E 80
 ioe altd sbc (iy)              ; DB 76 FD 9E 00
 ioe altd sbc (iy+127)          ; DB 76 FD 9E 7F
 ioe altd sbc (iy-128)          ; DB 76 FD 9E 80
 ioe altd sbc a, (hl)           ; DB 76 9E
 ioe altd sbc a, (hl+)          ; DB 76 9E 23
 ioe altd sbc a, (hl-)          ; DB 76 9E 2B
 ioe altd sbc a, (ix)           ; DB 76 DD 9E 00
 ioe altd sbc a, (ix+127)       ; DB 76 DD 9E 7F
 ioe altd sbc a, (ix-128)       ; DB 76 DD 9E 80
 ioe altd sbc a, (iy)           ; DB 76 FD 9E 00
 ioe altd sbc a, (iy+127)       ; DB 76 FD 9E 7F
 ioe altd sbc a, (iy-128)       ; DB 76 FD 9E 80
 ioe altd sla (hl)              ; DB 76 CB 26
 ioe altd sla (ix)              ; DB 76 DD CB 00 26
 ioe altd sla (ix+127)          ; DB 76 DD CB 7F 26
 ioe altd sla (ix-128)          ; DB 76 DD CB 80 26
 ioe altd sla (iy)              ; DB 76 FD CB 00 26
 ioe altd sla (iy+127)          ; DB 76 FD CB 7F 26
 ioe altd sla (iy-128)          ; DB 76 FD CB 80 26
 ioe altd sra (hl)              ; DB 76 CB 2E
 ioe altd sra (ix)              ; DB 76 DD CB 00 2E
 ioe altd sra (ix+127)          ; DB 76 DD CB 7F 2E
 ioe altd sra (ix-128)          ; DB 76 DD CB 80 2E
 ioe altd sra (iy)              ; DB 76 FD CB 00 2E
 ioe altd sra (iy+127)          ; DB 76 FD CB 7F 2E
 ioe altd sra (iy-128)          ; DB 76 FD CB 80 2E
 ioe altd srl (hl)              ; DB 76 CB 3E
 ioe altd srl (ix)              ; DB 76 DD CB 00 3E
 ioe altd srl (ix+127)          ; DB 76 DD CB 7F 3E
 ioe altd srl (ix-128)          ; DB 76 DD CB 80 3E
 ioe altd srl (iy)              ; DB 76 FD CB 00 3E
 ioe altd srl (iy+127)          ; DB 76 FD CB 7F 3E
 ioe altd srl (iy-128)          ; DB 76 FD CB 80 3E
 ioe altd sub (hl)              ; DB 76 96
 ioe altd sub (hl+)             ; DB 76 96 23
 ioe altd sub (hl-)             ; DB 76 96 2B
 ioe altd sub (ix)              ; DB 76 DD 96 00
 ioe altd sub (ix+127)          ; DB 76 DD 96 7F
 ioe altd sub (ix-128)          ; DB 76 DD 96 80
 ioe altd sub (iy)              ; DB 76 FD 96 00
 ioe altd sub (iy+127)          ; DB 76 FD 96 7F
 ioe altd sub (iy-128)          ; DB 76 FD 96 80
 ioe altd sub a, (hl)           ; DB 76 96
 ioe altd sub a, (hl+)          ; DB 76 96 23
 ioe altd sub a, (hl-)          ; DB 76 96 2B
 ioe altd sub a, (ix)           ; DB 76 DD 96 00
 ioe altd sub a, (ix+127)       ; DB 76 DD 96 7F
 ioe altd sub a, (ix-128)       ; DB 76 DD 96 80
 ioe altd sub a, (iy)           ; DB 76 FD 96 00
 ioe altd sub a, (iy+127)       ; DB 76 FD 96 7F
 ioe altd sub a, (iy-128)       ; DB 76 FD 96 80
 ioe altd xor (hl)              ; DB 76 AE
 ioe altd xor (hl+)             ; DB 76 AE 23
 ioe altd xor (hl-)             ; DB 76 AE 2B
 ioe altd xor (ix)              ; DB 76 DD AE 00
 ioe altd xor (ix+127)          ; DB 76 DD AE 7F
 ioe altd xor (ix-128)          ; DB 76 DD AE 80
 ioe altd xor (iy)              ; DB 76 FD AE 00
 ioe altd xor (iy+127)          ; DB 76 FD AE 7F
 ioe altd xor (iy-128)          ; DB 76 FD AE 80
 ioe altd xor a, (hl)           ; DB 76 AE
 ioe altd xor a, (hl+)          ; DB 76 AE 23
 ioe altd xor a, (hl-)          ; DB 76 AE 2B
 ioe altd xor a, (ix)           ; DB 76 DD AE 00
 ioe altd xor a, (ix+127)       ; DB 76 DD AE 7F
 ioe altd xor a, (ix-128)       ; DB 76 DD AE 80
 ioe altd xor a, (iy)           ; DB 76 FD AE 00
 ioe altd xor a, (iy+127)       ; DB 76 FD AE 7F
 ioe altd xor a, (iy-128)       ; DB 76 FD AE 80
 ioe and (hl)                   ; DB A6
 ioe and (hl+)                  ; DB A6 23
 ioe and (hl-)                  ; DB A6 2B
 ioe and (ix)                   ; DB DD A6 00
 ioe and (ix+127)               ; DB DD A6 7F
 ioe and (ix-128)               ; DB DD A6 80
 ioe and (iy)                   ; DB FD A6 00
 ioe and (iy+127)               ; DB FD A6 7F
 ioe and (iy-128)               ; DB FD A6 80
 ioe and a', (hl)               ; DB 76 A6
 ioe and a', (hl+)              ; DB 76 A6 23
 ioe and a', (hl-)              ; DB 76 A6 2B
 ioe and a', (ix)               ; DB 76 DD A6 00
 ioe and a', (ix+127)           ; DB 76 DD A6 7F
 ioe and a', (ix-128)           ; DB 76 DD A6 80
 ioe and a', (iy)               ; DB 76 FD A6 00
 ioe and a', (iy+127)           ; DB 76 FD A6 7F
 ioe and a', (iy-128)           ; DB 76 FD A6 80
 ioe and a, (hl)                ; DB A6
 ioe and a, (hl+)               ; DB A6 23
 ioe and a, (hl-)               ; DB A6 2B
 ioe and a, (ix)                ; DB DD A6 00
 ioe and a, (ix+127)            ; DB DD A6 7F
 ioe and a, (ix-128)            ; DB DD A6 80
 ioe and a, (iy)                ; DB FD A6 00
 ioe and a, (iy+127)            ; DB FD A6 7F
 ioe and a, (iy-128)            ; DB FD A6 80
 ioe bit 0, (hl)                ; DB CB 46
 ioe bit 0, (ix)                ; DB DD CB 00 46
 ioe bit 0, (ix+127)            ; DB DD CB 7F 46
 ioe bit 0, (ix-128)            ; DB DD CB 80 46
 ioe bit 0, (iy)                ; DB FD CB 00 46
 ioe bit 0, (iy+127)            ; DB FD CB 7F 46
 ioe bit 0, (iy-128)            ; DB FD CB 80 46
 ioe bit 1, (hl)                ; DB CB 4E
 ioe bit 1, (ix)                ; DB DD CB 00 4E
 ioe bit 1, (ix+127)            ; DB DD CB 7F 4E
 ioe bit 1, (ix-128)            ; DB DD CB 80 4E
 ioe bit 1, (iy)                ; DB FD CB 00 4E
 ioe bit 1, (iy+127)            ; DB FD CB 7F 4E
 ioe bit 1, (iy-128)            ; DB FD CB 80 4E
 ioe bit 2, (hl)                ; DB CB 56
 ioe bit 2, (ix)                ; DB DD CB 00 56
 ioe bit 2, (ix+127)            ; DB DD CB 7F 56
 ioe bit 2, (ix-128)            ; DB DD CB 80 56
 ioe bit 2, (iy)                ; DB FD CB 00 56
 ioe bit 2, (iy+127)            ; DB FD CB 7F 56
 ioe bit 2, (iy-128)            ; DB FD CB 80 56
 ioe bit 3, (hl)                ; DB CB 5E
 ioe bit 3, (ix)                ; DB DD CB 00 5E
 ioe bit 3, (ix+127)            ; DB DD CB 7F 5E
 ioe bit 3, (ix-128)            ; DB DD CB 80 5E
 ioe bit 3, (iy)                ; DB FD CB 00 5E
 ioe bit 3, (iy+127)            ; DB FD CB 7F 5E
 ioe bit 3, (iy-128)            ; DB FD CB 80 5E
 ioe bit 4, (hl)                ; DB CB 66
 ioe bit 4, (ix)                ; DB DD CB 00 66
 ioe bit 4, (ix+127)            ; DB DD CB 7F 66
 ioe bit 4, (ix-128)            ; DB DD CB 80 66
 ioe bit 4, (iy)                ; DB FD CB 00 66
 ioe bit 4, (iy+127)            ; DB FD CB 7F 66
 ioe bit 4, (iy-128)            ; DB FD CB 80 66
 ioe bit 5, (hl)                ; DB CB 6E
 ioe bit 5, (ix)                ; DB DD CB 00 6E
 ioe bit 5, (ix+127)            ; DB DD CB 7F 6E
 ioe bit 5, (ix-128)            ; DB DD CB 80 6E
 ioe bit 5, (iy)                ; DB FD CB 00 6E
 ioe bit 5, (iy+127)            ; DB FD CB 7F 6E
 ioe bit 5, (iy-128)            ; DB FD CB 80 6E
 ioe bit 6, (hl)                ; DB CB 76
 ioe bit 6, (ix)                ; DB DD CB 00 76
 ioe bit 6, (ix+127)            ; DB DD CB 7F 76
 ioe bit 6, (ix-128)            ; DB DD CB 80 76
 ioe bit 6, (iy)                ; DB FD CB 00 76
 ioe bit 6, (iy+127)            ; DB FD CB 7F 76
 ioe bit 6, (iy-128)            ; DB FD CB 80 76
 ioe bit 7, (hl)                ; DB CB 7E
 ioe bit 7, (ix)                ; DB DD CB 00 7E
 ioe bit 7, (ix+127)            ; DB DD CB 7F 7E
 ioe bit 7, (ix-128)            ; DB DD CB 80 7E
 ioe bit 7, (iy)                ; DB FD CB 00 7E
 ioe bit 7, (iy+127)            ; DB FD CB 7F 7E
 ioe bit 7, (iy-128)            ; DB FD CB 80 7E
 ioe cmp (hl)                   ; DB BE
 ioe cmp (hl+)                  ; DB BE 23
 ioe cmp (hl-)                  ; DB BE 2B
 ioe cmp (ix)                   ; DB DD BE 00
 ioe cmp (ix+127)               ; DB DD BE 7F
 ioe cmp (ix-128)               ; DB DD BE 80
 ioe cmp (iy)                   ; DB FD BE 00
 ioe cmp (iy+127)               ; DB FD BE 7F
 ioe cmp (iy-128)               ; DB FD BE 80
 ioe cmp a, (hl)                ; DB BE
 ioe cmp a, (hl+)               ; DB BE 23
 ioe cmp a, (hl-)               ; DB BE 2B
 ioe cmp a, (ix)                ; DB DD BE 00
 ioe cmp a, (ix+127)            ; DB DD BE 7F
 ioe cmp a, (ix-128)            ; DB DD BE 80
 ioe cmp a, (iy)                ; DB FD BE 00
 ioe cmp a, (iy+127)            ; DB FD BE 7F
 ioe cmp a, (iy-128)            ; DB FD BE 80
 ioe cp (hl)                    ; DB BE
 ioe cp (hl+)                   ; DB BE 23
 ioe cp (hl-)                   ; DB BE 2B
 ioe cp (ix)                    ; DB DD BE 00
 ioe cp (ix+127)                ; DB DD BE 7F
 ioe cp (ix-128)                ; DB DD BE 80
 ioe cp (iy)                    ; DB FD BE 00
 ioe cp (iy+127)                ; DB FD BE 7F
 ioe cp (iy-128)                ; DB FD BE 80
 ioe cp a, (hl)                 ; DB BE
 ioe cp a, (hl+)                ; DB BE 23
 ioe cp a, (hl-)                ; DB BE 2B
 ioe cp a, (ix)                 ; DB DD BE 00
 ioe cp a, (ix+127)             ; DB DD BE 7F
 ioe cp a, (ix-128)             ; DB DD BE 80
 ioe cp a, (iy)                 ; DB FD BE 00
 ioe cp a, (iy+127)             ; DB FD BE 7F
 ioe cp a, (iy-128)             ; DB FD BE 80
 ioe dec (hl)                   ; DB 35
 ioe dec (hl+)                  ; DB 35 23
 ioe dec (hl-)                  ; DB 35 2B
 ioe dec (ix)                   ; DB DD 35 00
 ioe dec (ix+127)               ; DB DD 35 7F
 ioe dec (ix-128)               ; DB DD 35 80
 ioe dec (iy)                   ; DB FD 35 00
 ioe dec (iy+127)               ; DB FD 35 7F
 ioe dec (iy-128)               ; DB FD 35 80
 ioe inc (hl)                   ; DB 34
 ioe inc (hl+)                  ; DB 34 23
 ioe inc (hl-)                  ; DB 34 2B
 ioe inc (ix)                   ; DB DD 34 00
 ioe inc (ix+127)               ; DB DD 34 7F
 ioe inc (ix-128)               ; DB DD 34 80
 ioe inc (iy)                   ; DB FD 34 00
 ioe inc (iy+127)               ; DB FD 34 7F
 ioe inc (iy-128)               ; DB FD 34 80
 ioe ld (-32768), a             ; DB 32 00 80
 ioe ld (-32768), bc            ; DB ED 43 00 80
 ioe ld (-32768), de            ; DB ED 53 00 80
 ioe ld (-32768), hl            ; DB 22 00 80
 ioe ld (-32768), ix            ; DB DD 22 00 80
 ioe ld (-32768), iy            ; DB FD 22 00 80
 ioe ld (-32768), sp            ; DB ED 73 00 80
 ioe ld (32767), a              ; DB 32 FF 7F
 ioe ld (32767), bc             ; DB ED 43 FF 7F
 ioe ld (32767), de             ; DB ED 53 FF 7F
 ioe ld (32767), hl             ; DB 22 FF 7F
 ioe ld (32767), ix             ; DB DD 22 FF 7F
 ioe ld (32767), iy             ; DB FD 22 FF 7F
 ioe ld (32767), sp             ; DB ED 73 FF 7F
 ioe ld (65535), a              ; DB 32 FF FF
 ioe ld (65535), bc             ; DB ED 43 FF FF
 ioe ld (65535), de             ; DB ED 53 FF FF
 ioe ld (65535), hl             ; DB 22 FF FF
 ioe ld (65535), ix             ; DB DD 22 FF FF
 ioe ld (65535), iy             ; DB FD 22 FF FF
 ioe ld (65535), sp             ; DB ED 73 FF FF
 ioe ld (bc), a                 ; DB 02
 ioe ld (bc+), a                ; DB 02 03
 ioe ld (bc-), a                ; DB 02 0B
 ioe ld (de), a                 ; DB 12
 ioe ld (de+), a                ; DB 12 13
 ioe ld (de-), a                ; DB 12 1B
 ioe ld (hl), -128              ; DB 36 80
 ioe ld (hl), 127               ; DB 36 7F
 ioe ld (hl), 255               ; DB 36 FF
 ioe ld (hl), a                 ; DB 77
 ioe ld (hl), b                 ; DB 70
 ioe ld (hl), c                 ; DB 71
 ioe ld (hl), d                 ; DB 72
 ioe ld (hl), e                 ; DB 73
 ioe ld (hl), h                 ; DB 74
 ioe ld (hl), hl                ; DB DD F4 00
 ioe ld (hl), l                 ; DB 75
 ioe ld (hl+), -128             ; DB 36 80 23
 ioe ld (hl+), 127              ; DB 36 7F 23
 ioe ld (hl+), 255              ; DB 36 FF 23
 ioe ld (hl+), a                ; DB 77 23
 ioe ld (hl+), b                ; DB 70 23
 ioe ld (hl+), c                ; DB 71 23
 ioe ld (hl+), d                ; DB 72 23
 ioe ld (hl+), e                ; DB 73 23
 ioe ld (hl+), h                ; DB 74 23
 ioe ld (hl+), l                ; DB 75 23
 ioe ld (hl+127), hl            ; DB DD F4 7F
 ioe ld (hl-), -128             ; DB 36 80 2B
 ioe ld (hl-), 127              ; DB 36 7F 2B
 ioe ld (hl-), 255              ; DB 36 FF 2B
 ioe ld (hl-), a                ; DB 77 2B
 ioe ld (hl-), b                ; DB 70 2B
 ioe ld (hl-), c                ; DB 71 2B
 ioe ld (hl-), d                ; DB 72 2B
 ioe ld (hl-), e                ; DB 73 2B
 ioe ld (hl-), h                ; DB 74 2B
 ioe ld (hl-), l                ; DB 75 2B
 ioe ld (hl-128), hl            ; DB DD F4 80
 ioe ld (hld), a                ; DB 77 2B
 ioe ld (hld), b                ; DB 70 2B
 ioe ld (hld), c                ; DB 71 2B
 ioe ld (hld), d                ; DB 72 2B
 ioe ld (hld), e                ; DB 73 2B
 ioe ld (hld), h                ; DB 74 2B
 ioe ld (hld), l                ; DB 75 2B
 ioe ld (hli), a                ; DB 77 23
 ioe ld (hli), b                ; DB 70 23
 ioe ld (hli), c                ; DB 71 23
 ioe ld (hli), d                ; DB 72 23
 ioe ld (hli), e                ; DB 73 23
 ioe ld (hli), h                ; DB 74 23
 ioe ld (hli), l                ; DB 75 23
 ioe ld (ix), -128              ; DB DD 36 00 80
 ioe ld (ix), 127               ; DB DD 36 00 7F
 ioe ld (ix), 255               ; DB DD 36 00 FF
 ioe ld (ix), a                 ; DB DD 77 00
 ioe ld (ix), b                 ; DB DD 70 00
 ioe ld (ix), c                 ; DB DD 71 00
 ioe ld (ix), d                 ; DB DD 72 00
 ioe ld (ix), e                 ; DB DD 73 00
 ioe ld (ix), h                 ; DB DD 74 00
 ioe ld (ix), hl                ; DB F4 00
 ioe ld (ix), l                 ; DB DD 75 00
 ioe ld (ix+127), -128          ; DB DD 36 7F 80
 ioe ld (ix+127), 127           ; DB DD 36 7F 7F
 ioe ld (ix+127), 255           ; DB DD 36 7F FF
 ioe ld (ix+127), a             ; DB DD 77 7F
 ioe ld (ix+127), b             ; DB DD 70 7F
 ioe ld (ix+127), c             ; DB DD 71 7F
 ioe ld (ix+127), d             ; DB DD 72 7F
 ioe ld (ix+127), e             ; DB DD 73 7F
 ioe ld (ix+127), h             ; DB DD 74 7F
 ioe ld (ix+127), hl            ; DB F4 7F
 ioe ld (ix+127), l             ; DB DD 75 7F
 ioe ld (ix-128), -128          ; DB DD 36 80 80
 ioe ld (ix-128), 127           ; DB DD 36 80 7F
 ioe ld (ix-128), 255           ; DB DD 36 80 FF
 ioe ld (ix-128), a             ; DB DD 77 80
 ioe ld (ix-128), b             ; DB DD 70 80
 ioe ld (ix-128), c             ; DB DD 71 80
 ioe ld (ix-128), d             ; DB DD 72 80
 ioe ld (ix-128), e             ; DB DD 73 80
 ioe ld (ix-128), h             ; DB DD 74 80
 ioe ld (ix-128), hl            ; DB F4 80
 ioe ld (ix-128), l             ; DB DD 75 80
 ioe ld (iy), -128              ; DB FD 36 00 80
 ioe ld (iy), 127               ; DB FD 36 00 7F
 ioe ld (iy), 255               ; DB FD 36 00 FF
 ioe ld (iy), a                 ; DB FD 77 00
 ioe ld (iy), b                 ; DB FD 70 00
 ioe ld (iy), c                 ; DB FD 71 00
 ioe ld (iy), d                 ; DB FD 72 00
 ioe ld (iy), e                 ; DB FD 73 00
 ioe ld (iy), h                 ; DB FD 74 00
 ioe ld (iy), hl                ; DB FD F4 00
 ioe ld (iy), l                 ; DB FD 75 00
 ioe ld (iy+127), -128          ; DB FD 36 7F 80
 ioe ld (iy+127), 127           ; DB FD 36 7F 7F
 ioe ld (iy+127), 255           ; DB FD 36 7F FF
 ioe ld (iy+127), a             ; DB FD 77 7F
 ioe ld (iy+127), b             ; DB FD 70 7F
 ioe ld (iy+127), c             ; DB FD 71 7F
 ioe ld (iy+127), d             ; DB FD 72 7F
 ioe ld (iy+127), e             ; DB FD 73 7F
 ioe ld (iy+127), h             ; DB FD 74 7F
 ioe ld (iy+127), hl            ; DB FD F4 7F
 ioe ld (iy+127), l             ; DB FD 75 7F
 ioe ld (iy-128), -128          ; DB FD 36 80 80
 ioe ld (iy-128), 127           ; DB FD 36 80 7F
 ioe ld (iy-128), 255           ; DB FD 36 80 FF
 ioe ld (iy-128), a             ; DB FD 77 80
 ioe ld (iy-128), b             ; DB FD 70 80
 ioe ld (iy-128), c             ; DB FD 71 80
 ioe ld (iy-128), d             ; DB FD 72 80
 ioe ld (iy-128), e             ; DB FD 73 80
 ioe ld (iy-128), h             ; DB FD 74 80
 ioe ld (iy-128), hl            ; DB FD F4 80
 ioe ld (iy-128), l             ; DB FD 75 80
 ioe ld a', (-32768)            ; DB 76 3A 00 80
 ioe ld a', (32767)             ; DB 76 3A FF 7F
 ioe ld a', (65535)             ; DB 76 3A FF FF
 ioe ld a', (bc)                ; DB 76 0A
 ioe ld a', (bc+)               ; DB 76 0A 03
 ioe ld a', (bc-)               ; DB 76 0A 0B
 ioe ld a', (de)                ; DB 76 1A
 ioe ld a', (de+)               ; DB 76 1A 13
 ioe ld a', (de-)               ; DB 76 1A 1B
 ioe ld a', (hl)                ; DB 76 7E
 ioe ld a', (hl+)               ; DB 76 7E 23
 ioe ld a', (hl-)               ; DB 76 7E 2B
 ioe ld a', (hld)               ; DB 76 7E 2B
 ioe ld a', (hli)               ; DB 76 7E 23
 ioe ld a', (ix)                ; DB 76 DD 7E 00
 ioe ld a', (ix+127)            ; DB 76 DD 7E 7F
 ioe ld a', (ix-128)            ; DB 76 DD 7E 80
 ioe ld a', (iy)                ; DB 76 FD 7E 00
 ioe ld a', (iy+127)            ; DB 76 FD 7E 7F
 ioe ld a', (iy-128)            ; DB 76 FD 7E 80
 ioe ld a, (-32768)             ; DB 3A 00 80
 ioe ld a, (32767)              ; DB 3A FF 7F
 ioe ld a, (65535)              ; DB 3A FF FF
 ioe ld a, (bc)                 ; DB 0A
 ioe ld a, (bc+)                ; DB 0A 03
 ioe ld a, (bc-)                ; DB 0A 0B
 ioe ld a, (de)                 ; DB 1A
 ioe ld a, (de+)                ; DB 1A 13
 ioe ld a, (de-)                ; DB 1A 1B
 ioe ld a, (hl)                 ; DB 7E
 ioe ld a, (hl+)                ; DB 7E 23
 ioe ld a, (hl-)                ; DB 7E 2B
 ioe ld a, (hld)                ; DB 7E 2B
 ioe ld a, (hli)                ; DB 7E 23
 ioe ld a, (ix)                 ; DB DD 7E 00
 ioe ld a, (ix+127)             ; DB DD 7E 7F
 ioe ld a, (ix-128)             ; DB DD 7E 80
 ioe ld a, (iy)                 ; DB FD 7E 00
 ioe ld a, (iy+127)             ; DB FD 7E 7F
 ioe ld a, (iy-128)             ; DB FD 7E 80
 ioe ld b', (hl)                ; DB 76 46
 ioe ld b', (hl+)               ; DB 76 46 23
 ioe ld b', (hl-)               ; DB 76 46 2B
 ioe ld b', (hld)               ; DB 76 46 2B
 ioe ld b', (hli)               ; DB 76 46 23
 ioe ld b', (ix)                ; DB 76 DD 46 00
 ioe ld b', (ix+127)            ; DB 76 DD 46 7F
 ioe ld b', (ix-128)            ; DB 76 DD 46 80
 ioe ld b', (iy)                ; DB 76 FD 46 00
 ioe ld b', (iy+127)            ; DB 76 FD 46 7F
 ioe ld b', (iy-128)            ; DB 76 FD 46 80
 ioe ld b, (hl)                 ; DB 46
 ioe ld b, (hl+)                ; DB 46 23
 ioe ld b, (hl-)                ; DB 46 2B
 ioe ld b, (hld)                ; DB 46 2B
 ioe ld b, (hli)                ; DB 46 23
 ioe ld b, (ix)                 ; DB DD 46 00
 ioe ld b, (ix+127)             ; DB DD 46 7F
 ioe ld b, (ix-128)             ; DB DD 46 80
 ioe ld b, (iy)                 ; DB FD 46 00
 ioe ld b, (iy+127)             ; DB FD 46 7F
 ioe ld b, (iy-128)             ; DB FD 46 80
 ioe ld bc', (-32768)           ; DB 76 ED 4B 00 80
 ioe ld bc', (32767)            ; DB 76 ED 4B FF 7F
 ioe ld bc', (65535)            ; DB 76 ED 4B FF FF
 ioe ld bc, (-32768)            ; DB ED 4B 00 80
 ioe ld bc, (32767)             ; DB ED 4B FF 7F
 ioe ld bc, (65535)             ; DB ED 4B FF FF
 ioe ld c', (hl)                ; DB 76 4E
 ioe ld c', (hl+)               ; DB 76 4E 23
 ioe ld c', (hl-)               ; DB 76 4E 2B
 ioe ld c', (hld)               ; DB 76 4E 2B
 ioe ld c', (hli)               ; DB 76 4E 23
 ioe ld c', (ix)                ; DB 76 DD 4E 00
 ioe ld c', (ix+127)            ; DB 76 DD 4E 7F
 ioe ld c', (ix-128)            ; DB 76 DD 4E 80
 ioe ld c', (iy)                ; DB 76 FD 4E 00
 ioe ld c', (iy+127)            ; DB 76 FD 4E 7F
 ioe ld c', (iy-128)            ; DB 76 FD 4E 80
 ioe ld c, (hl)                 ; DB 4E
 ioe ld c, (hl+)                ; DB 4E 23
 ioe ld c, (hl-)                ; DB 4E 2B
 ioe ld c, (hld)                ; DB 4E 2B
 ioe ld c, (hli)                ; DB 4E 23
 ioe ld c, (ix)                 ; DB DD 4E 00
 ioe ld c, (ix+127)             ; DB DD 4E 7F
 ioe ld c, (ix-128)             ; DB DD 4E 80
 ioe ld c, (iy)                 ; DB FD 4E 00
 ioe ld c, (iy+127)             ; DB FD 4E 7F
 ioe ld c, (iy-128)             ; DB FD 4E 80
 ioe ld d', (hl)                ; DB 76 56
 ioe ld d', (hl+)               ; DB 76 56 23
 ioe ld d', (hl-)               ; DB 76 56 2B
 ioe ld d', (hld)               ; DB 76 56 2B
 ioe ld d', (hli)               ; DB 76 56 23
 ioe ld d', (ix)                ; DB 76 DD 56 00
 ioe ld d', (ix+127)            ; DB 76 DD 56 7F
 ioe ld d', (ix-128)            ; DB 76 DD 56 80
 ioe ld d', (iy)                ; DB 76 FD 56 00
 ioe ld d', (iy+127)            ; DB 76 FD 56 7F
 ioe ld d', (iy-128)            ; DB 76 FD 56 80
 ioe ld d, (hl)                 ; DB 56
 ioe ld d, (hl+)                ; DB 56 23
 ioe ld d, (hl-)                ; DB 56 2B
 ioe ld d, (hld)                ; DB 56 2B
 ioe ld d, (hli)                ; DB 56 23
 ioe ld d, (ix)                 ; DB DD 56 00
 ioe ld d, (ix+127)             ; DB DD 56 7F
 ioe ld d, (ix-128)             ; DB DD 56 80
 ioe ld d, (iy)                 ; DB FD 56 00
 ioe ld d, (iy+127)             ; DB FD 56 7F
 ioe ld d, (iy-128)             ; DB FD 56 80
 ioe ld de', (-32768)           ; DB 76 ED 5B 00 80
 ioe ld de', (32767)            ; DB 76 ED 5B FF 7F
 ioe ld de', (65535)            ; DB 76 ED 5B FF FF
 ioe ld de, (-32768)            ; DB ED 5B 00 80
 ioe ld de, (32767)             ; DB ED 5B FF 7F
 ioe ld de, (65535)             ; DB ED 5B FF FF
 ioe ld e', (hl)                ; DB 76 5E
 ioe ld e', (hl+)               ; DB 76 5E 23
 ioe ld e', (hl-)               ; DB 76 5E 2B
 ioe ld e', (hld)               ; DB 76 5E 2B
 ioe ld e', (hli)               ; DB 76 5E 23
 ioe ld e', (ix)                ; DB 76 DD 5E 00
 ioe ld e', (ix+127)            ; DB 76 DD 5E 7F
 ioe ld e', (ix-128)            ; DB 76 DD 5E 80
 ioe ld e', (iy)                ; DB 76 FD 5E 00
 ioe ld e', (iy+127)            ; DB 76 FD 5E 7F
 ioe ld e', (iy-128)            ; DB 76 FD 5E 80
 ioe ld e, (hl)                 ; DB 5E
 ioe ld e, (hl+)                ; DB 5E 23
 ioe ld e, (hl-)                ; DB 5E 2B
 ioe ld e, (hld)                ; DB 5E 2B
 ioe ld e, (hli)                ; DB 5E 23
 ioe ld e, (ix)                 ; DB DD 5E 00
 ioe ld e, (ix+127)             ; DB DD 5E 7F
 ioe ld e, (ix-128)             ; DB DD 5E 80
 ioe ld e, (iy)                 ; DB FD 5E 00
 ioe ld e, (iy+127)             ; DB FD 5E 7F
 ioe ld e, (iy-128)             ; DB FD 5E 80
 ioe ld h', (hl)                ; DB 76 66
 ioe ld h', (hl+)               ; DB 76 66 23
 ioe ld h', (hl-)               ; DB 76 66 2B
 ioe ld h', (hld)               ; DB 76 66 2B
 ioe ld h', (hli)               ; DB 76 66 23
 ioe ld h', (ix)                ; DB 76 DD 66 00
 ioe ld h', (ix+127)            ; DB 76 DD 66 7F
 ioe ld h', (ix-128)            ; DB 76 DD 66 80
 ioe ld h', (iy)                ; DB 76 FD 66 00
 ioe ld h', (iy+127)            ; DB 76 FD 66 7F
 ioe ld h', (iy-128)            ; DB 76 FD 66 80
 ioe ld h, (hl)                 ; DB 66
 ioe ld h, (hl+)                ; DB 66 23
 ioe ld h, (hl-)                ; DB 66 2B
 ioe ld h, (hld)                ; DB 66 2B
 ioe ld h, (hli)                ; DB 66 23
 ioe ld h, (ix)                 ; DB DD 66 00
 ioe ld h, (ix+127)             ; DB DD 66 7F
 ioe ld h, (ix-128)             ; DB DD 66 80
 ioe ld h, (iy)                 ; DB FD 66 00
 ioe ld h, (iy+127)             ; DB FD 66 7F
 ioe ld h, (iy-128)             ; DB FD 66 80
 ioe ld hl', (-32768)           ; DB 76 2A 00 80
 ioe ld hl', (32767)            ; DB 76 2A FF 7F
 ioe ld hl', (65535)            ; DB 76 2A FF FF
 ioe ld hl', (hl)               ; DB 76 DD E4 00
 ioe ld hl', (hl+127)           ; DB 76 DD E4 7F
 ioe ld hl', (hl-128)           ; DB 76 DD E4 80
 ioe ld hl', (ix)               ; DB 76 E4 00
 ioe ld hl', (ix+127)           ; DB 76 E4 7F
 ioe ld hl', (ix-128)           ; DB 76 E4 80
 ioe ld hl', (iy)               ; DB 76 FD E4 00
 ioe ld hl', (iy+127)           ; DB 76 FD E4 7F
 ioe ld hl', (iy-128)           ; DB 76 FD E4 80
 ioe ld hl, (-32768)            ; DB 2A 00 80
 ioe ld hl, (32767)             ; DB 2A FF 7F
 ioe ld hl, (65535)             ; DB 2A FF FF
 ioe ld hl, (hl)                ; DB DD E4 00
 ioe ld hl, (hl+127)            ; DB DD E4 7F
 ioe ld hl, (hl-128)            ; DB DD E4 80
 ioe ld hl, (ix)                ; DB E4 00
 ioe ld hl, (ix+127)            ; DB E4 7F
 ioe ld hl, (ix-128)            ; DB E4 80
 ioe ld hl, (iy)                ; DB FD E4 00
 ioe ld hl, (iy+127)            ; DB FD E4 7F
 ioe ld hl, (iy-128)            ; DB FD E4 80
 ioe ld ix, (-32768)            ; DB DD 2A 00 80
 ioe ld ix, (32767)             ; DB DD 2A FF 7F
 ioe ld ix, (65535)             ; DB DD 2A FF FF
 ioe ld iy, (-32768)            ; DB FD 2A 00 80
 ioe ld iy, (32767)             ; DB FD 2A FF 7F
 ioe ld iy, (65535)             ; DB FD 2A FF FF
 ioe ld l', (hl)                ; DB 76 6E
 ioe ld l', (hl+)               ; DB 76 6E 23
 ioe ld l', (hl-)               ; DB 76 6E 2B
 ioe ld l', (hld)               ; DB 76 6E 2B
 ioe ld l', (hli)               ; DB 76 6E 23
 ioe ld l', (ix)                ; DB 76 DD 6E 00
 ioe ld l', (ix+127)            ; DB 76 DD 6E 7F
 ioe ld l', (ix-128)            ; DB 76 DD 6E 80
 ioe ld l', (iy)                ; DB 76 FD 6E 00
 ioe ld l', (iy+127)            ; DB 76 FD 6E 7F
 ioe ld l', (iy-128)            ; DB 76 FD 6E 80
 ioe ld l, (hl)                 ; DB 6E
 ioe ld l, (hl+)                ; DB 6E 23
 ioe ld l, (hl-)                ; DB 6E 2B
 ioe ld l, (hld)                ; DB 6E 2B
 ioe ld l, (hli)                ; DB 6E 23
 ioe ld l, (ix)                 ; DB DD 6E 00
 ioe ld l, (ix+127)             ; DB DD 6E 7F
 ioe ld l, (ix-128)             ; DB DD 6E 80
 ioe ld l, (iy)                 ; DB FD 6E 00
 ioe ld l, (iy+127)             ; DB FD 6E 7F
 ioe ld l, (iy-128)             ; DB FD 6E 80
 ioe ld sp, (-32768)            ; DB ED 7B 00 80
 ioe ld sp, (32767)             ; DB ED 7B FF 7F
 ioe ld sp, (65535)             ; DB ED 7B FF FF
 ioe ldd                        ; DB ED A8
 ioe ldd (bc), a                ; DB 02 0B
 ioe ldd (de), a                ; DB 12 1B
 ioe ldd (hl), -128             ; DB 36 80 2B
 ioe ldd (hl), 127              ; DB 36 7F 2B
 ioe ldd (hl), 255              ; DB 36 FF 2B
 ioe ldd (hl), a                ; DB 77 2B
 ioe ldd (hl), b                ; DB 70 2B
 ioe ldd (hl), c                ; DB 71 2B
 ioe ldd (hl), d                ; DB 72 2B
 ioe ldd (hl), e                ; DB 73 2B
 ioe ldd (hl), h                ; DB 74 2B
 ioe ldd (hl), l                ; DB 75 2B
 ioe ldd a, (bc)                ; DB 0A 0B
 ioe ldd a, (de)                ; DB 1A 1B
 ioe ldd a, (hl)                ; DB 7E 2B
 ioe ldd b, (hl)                ; DB 46 2B
 ioe ldd c, (hl)                ; DB 4E 2B
 ioe ldd d, (hl)                ; DB 56 2B
 ioe ldd e, (hl)                ; DB 5E 2B
 ioe ldd h, (hl)                ; DB 66 2B
 ioe ldd l, (hl)                ; DB 6E 2B
 ioe lddr                       ; DB ED B8
 ioe lddsr                      ; DB ED 98
 ioe ldi                        ; DB ED A0
 ioe ldi (bc), a                ; DB 02 03
 ioe ldi (de), a                ; DB 12 13
 ioe ldi (hl), -128             ; DB 36 80 23
 ioe ldi (hl), 127              ; DB 36 7F 23
 ioe ldi (hl), 255              ; DB 36 FF 23
 ioe ldi (hl), a                ; DB 77 23
 ioe ldi (hl), b                ; DB 70 23
 ioe ldi (hl), c                ; DB 71 23
 ioe ldi (hl), d                ; DB 72 23
 ioe ldi (hl), e                ; DB 73 23
 ioe ldi (hl), h                ; DB 74 23
 ioe ldi (hl), l                ; DB 75 23
 ioe ldi a, (bc)                ; DB 0A 03
 ioe ldi a, (de)                ; DB 1A 13
 ioe ldi a, (hl)                ; DB 7E 23
 ioe ldi b, (hl)                ; DB 46 23
 ioe ldi c, (hl)                ; DB 4E 23
 ioe ldi d, (hl)                ; DB 56 23
 ioe ldi e, (hl)                ; DB 5E 23
 ioe ldi h, (hl)                ; DB 66 23
 ioe ldi l, (hl)                ; DB 6E 23
 ioe ldir                       ; DB ED B0
 ioe ldisr                      ; DB ED 90
 ioe lsddr                      ; DB ED D8
 ioe lsdr                       ; DB ED F8
 ioe lsidr                      ; DB ED D0
 ioe lsir                       ; DB ED F0
 ioe or (hl)                    ; DB B6
 ioe or (hl+)                   ; DB B6 23
 ioe or (hl-)                   ; DB B6 2B
 ioe or (ix)                    ; DB DD B6 00
 ioe or (ix+127)                ; DB DD B6 7F
 ioe or (ix-128)                ; DB DD B6 80
 ioe or (iy)                    ; DB FD B6 00
 ioe or (iy+127)                ; DB FD B6 7F
 ioe or (iy-128)                ; DB FD B6 80
 ioe or a', (hl)                ; DB 76 B6
 ioe or a', (hl+)               ; DB 76 B6 23
 ioe or a', (hl-)               ; DB 76 B6 2B
 ioe or a', (ix)                ; DB 76 DD B6 00
 ioe or a', (ix+127)            ; DB 76 DD B6 7F
 ioe or a', (ix-128)            ; DB 76 DD B6 80
 ioe or a', (iy)                ; DB 76 FD B6 00
 ioe or a', (iy+127)            ; DB 76 FD B6 7F
 ioe or a', (iy-128)            ; DB 76 FD B6 80
 ioe or a, (hl)                 ; DB B6
 ioe or a, (hl+)                ; DB B6 23
 ioe or a, (hl-)                ; DB B6 2B
 ioe or a, (ix)                 ; DB DD B6 00
 ioe or a, (ix+127)             ; DB DD B6 7F
 ioe or a, (ix-128)             ; DB DD B6 80
 ioe or a, (iy)                 ; DB FD B6 00
 ioe or a, (iy+127)             ; DB FD B6 7F
 ioe or a, (iy-128)             ; DB FD B6 80
 ioe res 0, (hl)                ; DB CB 86
 ioe res 0, (ix)                ; DB DD CB 00 86
 ioe res 0, (ix+127)            ; DB DD CB 7F 86
 ioe res 0, (ix-128)            ; DB DD CB 80 86
 ioe res 0, (iy)                ; DB FD CB 00 86
 ioe res 0, (iy+127)            ; DB FD CB 7F 86
 ioe res 0, (iy-128)            ; DB FD CB 80 86
 ioe res 1, (hl)                ; DB CB 8E
 ioe res 1, (ix)                ; DB DD CB 00 8E
 ioe res 1, (ix+127)            ; DB DD CB 7F 8E
 ioe res 1, (ix-128)            ; DB DD CB 80 8E
 ioe res 1, (iy)                ; DB FD CB 00 8E
 ioe res 1, (iy+127)            ; DB FD CB 7F 8E
 ioe res 1, (iy-128)            ; DB FD CB 80 8E
 ioe res 2, (hl)                ; DB CB 96
 ioe res 2, (ix)                ; DB DD CB 00 96
 ioe res 2, (ix+127)            ; DB DD CB 7F 96
 ioe res 2, (ix-128)            ; DB DD CB 80 96
 ioe res 2, (iy)                ; DB FD CB 00 96
 ioe res 2, (iy+127)            ; DB FD CB 7F 96
 ioe res 2, (iy-128)            ; DB FD CB 80 96
 ioe res 3, (hl)                ; DB CB 9E
 ioe res 3, (ix)                ; DB DD CB 00 9E
 ioe res 3, (ix+127)            ; DB DD CB 7F 9E
 ioe res 3, (ix-128)            ; DB DD CB 80 9E
 ioe res 3, (iy)                ; DB FD CB 00 9E
 ioe res 3, (iy+127)            ; DB FD CB 7F 9E
 ioe res 3, (iy-128)            ; DB FD CB 80 9E
 ioe res 4, (hl)                ; DB CB A6
 ioe res 4, (ix)                ; DB DD CB 00 A6
 ioe res 4, (ix+127)            ; DB DD CB 7F A6
 ioe res 4, (ix-128)            ; DB DD CB 80 A6
 ioe res 4, (iy)                ; DB FD CB 00 A6
 ioe res 4, (iy+127)            ; DB FD CB 7F A6
 ioe res 4, (iy-128)            ; DB FD CB 80 A6
 ioe res 5, (hl)                ; DB CB AE
 ioe res 5, (ix)                ; DB DD CB 00 AE
 ioe res 5, (ix+127)            ; DB DD CB 7F AE
 ioe res 5, (ix-128)            ; DB DD CB 80 AE
 ioe res 5, (iy)                ; DB FD CB 00 AE
 ioe res 5, (iy+127)            ; DB FD CB 7F AE
 ioe res 5, (iy-128)            ; DB FD CB 80 AE
 ioe res 6, (hl)                ; DB CB B6
 ioe res 6, (ix)                ; DB DD CB 00 B6
 ioe res 6, (ix+127)            ; DB DD CB 7F B6
 ioe res 6, (ix-128)            ; DB DD CB 80 B6
 ioe res 6, (iy)                ; DB FD CB 00 B6
 ioe res 6, (iy+127)            ; DB FD CB 7F B6
 ioe res 6, (iy-128)            ; DB FD CB 80 B6
 ioe res 7, (hl)                ; DB CB BE
 ioe res 7, (ix)                ; DB DD CB 00 BE
 ioe res 7, (ix+127)            ; DB DD CB 7F BE
 ioe res 7, (ix-128)            ; DB DD CB 80 BE
 ioe res 7, (iy)                ; DB FD CB 00 BE
 ioe res 7, (iy+127)            ; DB FD CB 7F BE
 ioe res 7, (iy-128)            ; DB FD CB 80 BE
 ioe rl (hl)                    ; DB CB 16
 ioe rl (ix)                    ; DB DD CB 00 16
 ioe rl (ix+127)                ; DB DD CB 7F 16
 ioe rl (ix-128)                ; DB DD CB 80 16
 ioe rl (iy)                    ; DB FD CB 00 16
 ioe rl (iy+127)                ; DB FD CB 7F 16
 ioe rl (iy-128)                ; DB FD CB 80 16
 ioe rlc (hl)                   ; DB CB 06
 ioe rlc (ix)                   ; DB DD CB 00 06
 ioe rlc (ix+127)               ; DB DD CB 7F 06
 ioe rlc (ix-128)               ; DB DD CB 80 06
 ioe rlc (iy)                   ; DB FD CB 00 06
 ioe rlc (iy+127)               ; DB FD CB 7F 06
 ioe rlc (iy-128)               ; DB FD CB 80 06
 ioe rr (hl)                    ; DB CB 1E
 ioe rr (ix)                    ; DB DD CB 00 1E
 ioe rr (ix+127)                ; DB DD CB 7F 1E
 ioe rr (ix-128)                ; DB DD CB 80 1E
 ioe rr (iy)                    ; DB FD CB 00 1E
 ioe rr (iy+127)                ; DB FD CB 7F 1E
 ioe rr (iy-128)                ; DB FD CB 80 1E
 ioe rrc (hl)                   ; DB CB 0E
 ioe rrc (ix)                   ; DB DD CB 00 0E
 ioe rrc (ix+127)               ; DB DD CB 7F 0E
 ioe rrc (ix-128)               ; DB DD CB 80 0E
 ioe rrc (iy)                   ; DB FD CB 00 0E
 ioe rrc (iy+127)               ; DB FD CB 7F 0E
 ioe rrc (iy-128)               ; DB FD CB 80 0E
 ioe sbc (hl)                   ; DB 9E
 ioe sbc (hl+)                  ; DB 9E 23
 ioe sbc (hl-)                  ; DB 9E 2B
 ioe sbc (ix)                   ; DB DD 9E 00
 ioe sbc (ix+127)               ; DB DD 9E 7F
 ioe sbc (ix-128)               ; DB DD 9E 80
 ioe sbc (iy)                   ; DB FD 9E 00
 ioe sbc (iy+127)               ; DB FD 9E 7F
 ioe sbc (iy-128)               ; DB FD 9E 80
 ioe sbc a', (hl)               ; DB 76 9E
 ioe sbc a', (hl+)              ; DB 76 9E 23
 ioe sbc a', (hl-)              ; DB 76 9E 2B
 ioe sbc a', (ix)               ; DB 76 DD 9E 00
 ioe sbc a', (ix+127)           ; DB 76 DD 9E 7F
 ioe sbc a', (ix-128)           ; DB 76 DD 9E 80
 ioe sbc a', (iy)               ; DB 76 FD 9E 00
 ioe sbc a', (iy+127)           ; DB 76 FD 9E 7F
 ioe sbc a', (iy-128)           ; DB 76 FD 9E 80
 ioe sbc a, (hl)                ; DB 9E
 ioe sbc a, (hl+)               ; DB 9E 23
 ioe sbc a, (hl-)               ; DB 9E 2B
 ioe sbc a, (ix)                ; DB DD 9E 00
 ioe sbc a, (ix+127)            ; DB DD 9E 7F
 ioe sbc a, (ix-128)            ; DB DD 9E 80
 ioe sbc a, (iy)                ; DB FD 9E 00
 ioe sbc a, (iy+127)            ; DB FD 9E 7F
 ioe sbc a, (iy-128)            ; DB FD 9E 80
 ioe set 0, (hl)                ; DB CB C6
 ioe set 0, (ix)                ; DB DD CB 00 C6
 ioe set 0, (ix+127)            ; DB DD CB 7F C6
 ioe set 0, (ix-128)            ; DB DD CB 80 C6
 ioe set 0, (iy)                ; DB FD CB 00 C6
 ioe set 0, (iy+127)            ; DB FD CB 7F C6
 ioe set 0, (iy-128)            ; DB FD CB 80 C6
 ioe set 1, (hl)                ; DB CB CE
 ioe set 1, (ix)                ; DB DD CB 00 CE
 ioe set 1, (ix+127)            ; DB DD CB 7F CE
 ioe set 1, (ix-128)            ; DB DD CB 80 CE
 ioe set 1, (iy)                ; DB FD CB 00 CE
 ioe set 1, (iy+127)            ; DB FD CB 7F CE
 ioe set 1, (iy-128)            ; DB FD CB 80 CE
 ioe set 2, (hl)                ; DB CB D6
 ioe set 2, (ix)                ; DB DD CB 00 D6
 ioe set 2, (ix+127)            ; DB DD CB 7F D6
 ioe set 2, (ix-128)            ; DB DD CB 80 D6
 ioe set 2, (iy)                ; DB FD CB 00 D6
 ioe set 2, (iy+127)            ; DB FD CB 7F D6
 ioe set 2, (iy-128)            ; DB FD CB 80 D6
 ioe set 3, (hl)                ; DB CB DE
 ioe set 3, (ix)                ; DB DD CB 00 DE
 ioe set 3, (ix+127)            ; DB DD CB 7F DE
 ioe set 3, (ix-128)            ; DB DD CB 80 DE
 ioe set 3, (iy)                ; DB FD CB 00 DE
 ioe set 3, (iy+127)            ; DB FD CB 7F DE
 ioe set 3, (iy-128)            ; DB FD CB 80 DE
 ioe set 4, (hl)                ; DB CB E6
 ioe set 4, (ix)                ; DB DD CB 00 E6
 ioe set 4, (ix+127)            ; DB DD CB 7F E6
 ioe set 4, (ix-128)            ; DB DD CB 80 E6
 ioe set 4, (iy)                ; DB FD CB 00 E6
 ioe set 4, (iy+127)            ; DB FD CB 7F E6
 ioe set 4, (iy-128)            ; DB FD CB 80 E6
 ioe set 5, (hl)                ; DB CB EE
 ioe set 5, (ix)                ; DB DD CB 00 EE
 ioe set 5, (ix+127)            ; DB DD CB 7F EE
 ioe set 5, (ix-128)            ; DB DD CB 80 EE
 ioe set 5, (iy)                ; DB FD CB 00 EE
 ioe set 5, (iy+127)            ; DB FD CB 7F EE
 ioe set 5, (iy-128)            ; DB FD CB 80 EE
 ioe set 6, (hl)                ; DB CB F6
 ioe set 6, (ix)                ; DB DD CB 00 F6
 ioe set 6, (ix+127)            ; DB DD CB 7F F6
 ioe set 6, (ix-128)            ; DB DD CB 80 F6
 ioe set 6, (iy)                ; DB FD CB 00 F6
 ioe set 6, (iy+127)            ; DB FD CB 7F F6
 ioe set 6, (iy-128)            ; DB FD CB 80 F6
 ioe set 7, (hl)                ; DB CB FE
 ioe set 7, (ix)                ; DB DD CB 00 FE
 ioe set 7, (ix+127)            ; DB DD CB 7F FE
 ioe set 7, (ix-128)            ; DB DD CB 80 FE
 ioe set 7, (iy)                ; DB FD CB 00 FE
 ioe set 7, (iy+127)            ; DB FD CB 7F FE
 ioe set 7, (iy-128)            ; DB FD CB 80 FE
 ioe sla (hl)                   ; DB CB 26
 ioe sla (ix)                   ; DB DD CB 00 26
 ioe sla (ix+127)               ; DB DD CB 7F 26
 ioe sla (ix-128)               ; DB DD CB 80 26
 ioe sla (iy)                   ; DB FD CB 00 26
 ioe sla (iy+127)               ; DB FD CB 7F 26
 ioe sla (iy-128)               ; DB FD CB 80 26
 ioe sra (hl)                   ; DB CB 2E
 ioe sra (ix)                   ; DB DD CB 00 2E
 ioe sra (ix+127)               ; DB DD CB 7F 2E
 ioe sra (ix-128)               ; DB DD CB 80 2E
 ioe sra (iy)                   ; DB FD CB 00 2E
 ioe sra (iy+127)               ; DB FD CB 7F 2E
 ioe sra (iy-128)               ; DB FD CB 80 2E
 ioe srl (hl)                   ; DB CB 3E
 ioe srl (ix)                   ; DB DD CB 00 3E
 ioe srl (ix+127)               ; DB DD CB 7F 3E
 ioe srl (ix-128)               ; DB DD CB 80 3E
 ioe srl (iy)                   ; DB FD CB 00 3E
 ioe srl (iy+127)               ; DB FD CB 7F 3E
 ioe srl (iy-128)               ; DB FD CB 80 3E
 ioe sub (hl)                   ; DB 96
 ioe sub (hl+)                  ; DB 96 23
 ioe sub (hl-)                  ; DB 96 2B
 ioe sub (ix)                   ; DB DD 96 00
 ioe sub (ix+127)               ; DB DD 96 7F
 ioe sub (ix-128)               ; DB DD 96 80
 ioe sub (iy)                   ; DB FD 96 00
 ioe sub (iy+127)               ; DB FD 96 7F
 ioe sub (iy-128)               ; DB FD 96 80
 ioe sub a', (hl)               ; DB 76 96
 ioe sub a', (hl+)              ; DB 76 96 23
 ioe sub a', (hl-)              ; DB 76 96 2B
 ioe sub a', (ix)               ; DB 76 DD 96 00
 ioe sub a', (ix+127)           ; DB 76 DD 96 7F
 ioe sub a', (ix-128)           ; DB 76 DD 96 80
 ioe sub a', (iy)               ; DB 76 FD 96 00
 ioe sub a', (iy+127)           ; DB 76 FD 96 7F
 ioe sub a', (iy-128)           ; DB 76 FD 96 80
 ioe sub a, (hl)                ; DB 96
 ioe sub a, (hl+)               ; DB 96 23
 ioe sub a, (hl-)               ; DB 96 2B
 ioe sub a, (ix)                ; DB DD 96 00
 ioe sub a, (ix+127)            ; DB DD 96 7F
 ioe sub a, (ix-128)            ; DB DD 96 80
 ioe sub a, (iy)                ; DB FD 96 00
 ioe sub a, (iy+127)            ; DB FD 96 7F
 ioe sub a, (iy-128)            ; DB FD 96 80
 ioe xor (hl)                   ; DB AE
 ioe xor (hl+)                  ; DB AE 23
 ioe xor (hl-)                  ; DB AE 2B
 ioe xor (ix)                   ; DB DD AE 00
 ioe xor (ix+127)               ; DB DD AE 7F
 ioe xor (ix-128)               ; DB DD AE 80
 ioe xor (iy)                   ; DB FD AE 00
 ioe xor (iy+127)               ; DB FD AE 7F
 ioe xor (iy-128)               ; DB FD AE 80
 ioe xor a', (hl)               ; DB 76 AE
 ioe xor a', (hl+)              ; DB 76 AE 23
 ioe xor a', (hl-)              ; DB 76 AE 2B
 ioe xor a', (ix)               ; DB 76 DD AE 00
 ioe xor a', (ix+127)           ; DB 76 DD AE 7F
 ioe xor a', (ix-128)           ; DB 76 DD AE 80
 ioe xor a', (iy)               ; DB 76 FD AE 00
 ioe xor a', (iy+127)           ; DB 76 FD AE 7F
 ioe xor a', (iy-128)           ; DB 76 FD AE 80
 ioe xor a, (hl)                ; DB AE
 ioe xor a, (hl+)               ; DB AE 23
 ioe xor a, (hl-)               ; DB AE 2B
 ioe xor a, (ix)                ; DB DD AE 00
 ioe xor a, (ix+127)            ; DB DD AE 7F
 ioe xor a, (ix-128)            ; DB DD AE 80
 ioe xor a, (iy)                ; DB FD AE 00
 ioe xor a, (iy+127)            ; DB FD AE 7F
 ioe xor a, (iy-128)            ; DB FD AE 80
 ioi adc (hl)                   ; D3 8E
 ioi adc (hl+)                  ; D3 8E 23
 ioi adc (hl-)                  ; D3 8E 2B
 ioi adc (ix)                   ; D3 DD 8E 00
 ioi adc (ix+127)               ; D3 DD 8E 7F
 ioi adc (ix-128)               ; D3 DD 8E 80
 ioi adc (iy)                   ; D3 FD 8E 00
 ioi adc (iy+127)               ; D3 FD 8E 7F
 ioi adc (iy-128)               ; D3 FD 8E 80
 ioi adc a', (hl)               ; D3 76 8E
 ioi adc a', (hl+)              ; D3 76 8E 23
 ioi adc a', (hl-)              ; D3 76 8E 2B
 ioi adc a', (ix)               ; D3 76 DD 8E 00
 ioi adc a', (ix+127)           ; D3 76 DD 8E 7F
 ioi adc a', (ix-128)           ; D3 76 DD 8E 80
 ioi adc a', (iy)               ; D3 76 FD 8E 00
 ioi adc a', (iy+127)           ; D3 76 FD 8E 7F
 ioi adc a', (iy-128)           ; D3 76 FD 8E 80
 ioi adc a, (hl)                ; D3 8E
 ioi adc a, (hl+)               ; D3 8E 23
 ioi adc a, (hl-)               ; D3 8E 2B
 ioi adc a, (ix)                ; D3 DD 8E 00
 ioi adc a, (ix+127)            ; D3 DD 8E 7F
 ioi adc a, (ix-128)            ; D3 DD 8E 80
 ioi adc a, (iy)                ; D3 FD 8E 00
 ioi adc a, (iy+127)            ; D3 FD 8E 7F
 ioi adc a, (iy-128)            ; D3 FD 8E 80
 ioi add (hl)                   ; D3 86
 ioi add (hl+)                  ; D3 86 23
 ioi add (hl-)                  ; D3 86 2B
 ioi add (ix)                   ; D3 DD 86 00
 ioi add (ix+127)               ; D3 DD 86 7F
 ioi add (ix-128)               ; D3 DD 86 80
 ioi add (iy)                   ; D3 FD 86 00
 ioi add (iy+127)               ; D3 FD 86 7F
 ioi add (iy-128)               ; D3 FD 86 80
 ioi add a', (hl)               ; D3 76 86
 ioi add a', (hl+)              ; D3 76 86 23
 ioi add a', (hl-)              ; D3 76 86 2B
 ioi add a', (ix)               ; D3 76 DD 86 00
 ioi add a', (ix+127)           ; D3 76 DD 86 7F
 ioi add a', (ix-128)           ; D3 76 DD 86 80
 ioi add a', (iy)               ; D3 76 FD 86 00
 ioi add a', (iy+127)           ; D3 76 FD 86 7F
 ioi add a', (iy-128)           ; D3 76 FD 86 80
 ioi add a, (hl)                ; D3 86
 ioi add a, (hl+)               ; D3 86 23
 ioi add a, (hl-)               ; D3 86 2B
 ioi add a, (ix)                ; D3 DD 86 00
 ioi add a, (ix+127)            ; D3 DD 86 7F
 ioi add a, (ix-128)            ; D3 DD 86 80
 ioi add a, (iy)                ; D3 FD 86 00
 ioi add a, (iy+127)            ; D3 FD 86 7F
 ioi add a, (iy-128)            ; D3 FD 86 80
 ioi altd adc (hl)              ; D3 76 8E
 ioi altd adc (hl+)             ; D3 76 8E 23
 ioi altd adc (hl-)             ; D3 76 8E 2B
 ioi altd adc (ix)              ; D3 76 DD 8E 00
 ioi altd adc (ix+127)          ; D3 76 DD 8E 7F
 ioi altd adc (ix-128)          ; D3 76 DD 8E 80
 ioi altd adc (iy)              ; D3 76 FD 8E 00
 ioi altd adc (iy+127)          ; D3 76 FD 8E 7F
 ioi altd adc (iy-128)          ; D3 76 FD 8E 80
 ioi altd adc a, (hl)           ; D3 76 8E
 ioi altd adc a, (hl+)          ; D3 76 8E 23
 ioi altd adc a, (hl-)          ; D3 76 8E 2B
 ioi altd adc a, (ix)           ; D3 76 DD 8E 00
 ioi altd adc a, (ix+127)       ; D3 76 DD 8E 7F
 ioi altd adc a, (ix-128)       ; D3 76 DD 8E 80
 ioi altd adc a, (iy)           ; D3 76 FD 8E 00
 ioi altd adc a, (iy+127)       ; D3 76 FD 8E 7F
 ioi altd adc a, (iy-128)       ; D3 76 FD 8E 80
 ioi altd add (hl)              ; D3 76 86
 ioi altd add (hl+)             ; D3 76 86 23
 ioi altd add (hl-)             ; D3 76 86 2B
 ioi altd add (ix)              ; D3 76 DD 86 00
 ioi altd add (ix+127)          ; D3 76 DD 86 7F
 ioi altd add (ix-128)          ; D3 76 DD 86 80
 ioi altd add (iy)              ; D3 76 FD 86 00
 ioi altd add (iy+127)          ; D3 76 FD 86 7F
 ioi altd add (iy-128)          ; D3 76 FD 86 80
 ioi altd add a, (hl)           ; D3 76 86
 ioi altd add a, (hl+)          ; D3 76 86 23
 ioi altd add a, (hl-)          ; D3 76 86 2B
 ioi altd add a, (ix)           ; D3 76 DD 86 00
 ioi altd add a, (ix+127)       ; D3 76 DD 86 7F
 ioi altd add a, (ix-128)       ; D3 76 DD 86 80
 ioi altd add a, (iy)           ; D3 76 FD 86 00
 ioi altd add a, (iy+127)       ; D3 76 FD 86 7F
 ioi altd add a, (iy-128)       ; D3 76 FD 86 80
 ioi altd and (hl)              ; D3 76 A6
 ioi altd and (hl+)             ; D3 76 A6 23
 ioi altd and (hl-)             ; D3 76 A6 2B
 ioi altd and (ix)              ; D3 76 DD A6 00
 ioi altd and (ix+127)          ; D3 76 DD A6 7F
 ioi altd and (ix-128)          ; D3 76 DD A6 80
 ioi altd and (iy)              ; D3 76 FD A6 00
 ioi altd and (iy+127)          ; D3 76 FD A6 7F
 ioi altd and (iy-128)          ; D3 76 FD A6 80
 ioi altd and a, (hl)           ; D3 76 A6
 ioi altd and a, (hl+)          ; D3 76 A6 23
 ioi altd and a, (hl-)          ; D3 76 A6 2B
 ioi altd and a, (ix)           ; D3 76 DD A6 00
 ioi altd and a, (ix+127)       ; D3 76 DD A6 7F
 ioi altd and a, (ix-128)       ; D3 76 DD A6 80
 ioi altd and a, (iy)           ; D3 76 FD A6 00
 ioi altd and a, (iy+127)       ; D3 76 FD A6 7F
 ioi altd and a, (iy-128)       ; D3 76 FD A6 80
 ioi altd bit 0, (hl)           ; D3 76 CB 46
 ioi altd bit 0, (ix)           ; D3 76 DD CB 00 46
 ioi altd bit 0, (ix+127)       ; D3 76 DD CB 7F 46
 ioi altd bit 0, (ix-128)       ; D3 76 DD CB 80 46
 ioi altd bit 0, (iy)           ; D3 76 FD CB 00 46
 ioi altd bit 0, (iy+127)       ; D3 76 FD CB 7F 46
 ioi altd bit 0, (iy-128)       ; D3 76 FD CB 80 46
 ioi altd bit 1, (hl)           ; D3 76 CB 4E
 ioi altd bit 1, (ix)           ; D3 76 DD CB 00 4E
 ioi altd bit 1, (ix+127)       ; D3 76 DD CB 7F 4E
 ioi altd bit 1, (ix-128)       ; D3 76 DD CB 80 4E
 ioi altd bit 1, (iy)           ; D3 76 FD CB 00 4E
 ioi altd bit 1, (iy+127)       ; D3 76 FD CB 7F 4E
 ioi altd bit 1, (iy-128)       ; D3 76 FD CB 80 4E
 ioi altd bit 2, (hl)           ; D3 76 CB 56
 ioi altd bit 2, (ix)           ; D3 76 DD CB 00 56
 ioi altd bit 2, (ix+127)       ; D3 76 DD CB 7F 56
 ioi altd bit 2, (ix-128)       ; D3 76 DD CB 80 56
 ioi altd bit 2, (iy)           ; D3 76 FD CB 00 56
 ioi altd bit 2, (iy+127)       ; D3 76 FD CB 7F 56
 ioi altd bit 2, (iy-128)       ; D3 76 FD CB 80 56
 ioi altd bit 3, (hl)           ; D3 76 CB 5E
 ioi altd bit 3, (ix)           ; D3 76 DD CB 00 5E
 ioi altd bit 3, (ix+127)       ; D3 76 DD CB 7F 5E
 ioi altd bit 3, (ix-128)       ; D3 76 DD CB 80 5E
 ioi altd bit 3, (iy)           ; D3 76 FD CB 00 5E
 ioi altd bit 3, (iy+127)       ; D3 76 FD CB 7F 5E
 ioi altd bit 3, (iy-128)       ; D3 76 FD CB 80 5E
 ioi altd bit 4, (hl)           ; D3 76 CB 66
 ioi altd bit 4, (ix)           ; D3 76 DD CB 00 66
 ioi altd bit 4, (ix+127)       ; D3 76 DD CB 7F 66
 ioi altd bit 4, (ix-128)       ; D3 76 DD CB 80 66
 ioi altd bit 4, (iy)           ; D3 76 FD CB 00 66
 ioi altd bit 4, (iy+127)       ; D3 76 FD CB 7F 66
 ioi altd bit 4, (iy-128)       ; D3 76 FD CB 80 66
 ioi altd bit 5, (hl)           ; D3 76 CB 6E
 ioi altd bit 5, (ix)           ; D3 76 DD CB 00 6E
 ioi altd bit 5, (ix+127)       ; D3 76 DD CB 7F 6E
 ioi altd bit 5, (ix-128)       ; D3 76 DD CB 80 6E
 ioi altd bit 5, (iy)           ; D3 76 FD CB 00 6E
 ioi altd bit 5, (iy+127)       ; D3 76 FD CB 7F 6E
 ioi altd bit 5, (iy-128)       ; D3 76 FD CB 80 6E
 ioi altd bit 6, (hl)           ; D3 76 CB 76
 ioi altd bit 6, (ix)           ; D3 76 DD CB 00 76
 ioi altd bit 6, (ix+127)       ; D3 76 DD CB 7F 76
 ioi altd bit 6, (ix-128)       ; D3 76 DD CB 80 76
 ioi altd bit 6, (iy)           ; D3 76 FD CB 00 76
 ioi altd bit 6, (iy+127)       ; D3 76 FD CB 7F 76
 ioi altd bit 6, (iy-128)       ; D3 76 FD CB 80 76
 ioi altd bit 7, (hl)           ; D3 76 CB 7E
 ioi altd bit 7, (ix)           ; D3 76 DD CB 00 7E
 ioi altd bit 7, (ix+127)       ; D3 76 DD CB 7F 7E
 ioi altd bit 7, (ix-128)       ; D3 76 DD CB 80 7E
 ioi altd bit 7, (iy)           ; D3 76 FD CB 00 7E
 ioi altd bit 7, (iy+127)       ; D3 76 FD CB 7F 7E
 ioi altd bit 7, (iy-128)       ; D3 76 FD CB 80 7E
 ioi altd cp (hl)               ; D3 76 BE
 ioi altd cp (hl+)              ; D3 76 BE 23
 ioi altd cp (hl-)              ; D3 76 BE 2B
 ioi altd cp (ix)               ; D3 76 DD BE 00
 ioi altd cp (ix+127)           ; D3 76 DD BE 7F
 ioi altd cp (ix-128)           ; D3 76 DD BE 80
 ioi altd cp (iy)               ; D3 76 FD BE 00
 ioi altd cp (iy+127)           ; D3 76 FD BE 7F
 ioi altd cp (iy-128)           ; D3 76 FD BE 80
 ioi altd cp a, (hl)            ; D3 76 BE
 ioi altd cp a, (hl+)           ; D3 76 BE 23
 ioi altd cp a, (hl-)           ; D3 76 BE 2B
 ioi altd cp a, (ix)            ; D3 76 DD BE 00
 ioi altd cp a, (ix+127)        ; D3 76 DD BE 7F
 ioi altd cp a, (ix-128)        ; D3 76 DD BE 80
 ioi altd cp a, (iy)            ; D3 76 FD BE 00
 ioi altd cp a, (iy+127)        ; D3 76 FD BE 7F
 ioi altd cp a, (iy-128)        ; D3 76 FD BE 80
 ioi altd dec (hl)              ; D3 76 35
 ioi altd dec (hl+)             ; D3 76 35 23
 ioi altd dec (hl-)             ; D3 76 35 2B
 ioi altd dec (ix)              ; D3 76 DD 35 00
 ioi altd dec (ix+127)          ; D3 76 DD 35 7F
 ioi altd dec (ix-128)          ; D3 76 DD 35 80
 ioi altd dec (iy)              ; D3 76 FD 35 00
 ioi altd dec (iy+127)          ; D3 76 FD 35 7F
 ioi altd dec (iy-128)          ; D3 76 FD 35 80
 ioi altd inc (hl)              ; D3 76 34
 ioi altd inc (hl+)             ; D3 76 34 23
 ioi altd inc (hl-)             ; D3 76 34 2B
 ioi altd inc (ix)              ; D3 76 DD 34 00
 ioi altd inc (ix+127)          ; D3 76 DD 34 7F
 ioi altd inc (ix-128)          ; D3 76 DD 34 80
 ioi altd inc (iy)              ; D3 76 FD 34 00
 ioi altd inc (iy+127)          ; D3 76 FD 34 7F
 ioi altd inc (iy-128)          ; D3 76 FD 34 80
 ioi altd ld a, (-32768)        ; D3 76 3A 00 80
 ioi altd ld a, (32767)         ; D3 76 3A FF 7F
 ioi altd ld a, (65535)         ; D3 76 3A FF FF
 ioi altd ld a, (bc)            ; D3 76 0A
 ioi altd ld a, (bc+)           ; D3 76 0A 03
 ioi altd ld a, (bc-)           ; D3 76 0A 0B
 ioi altd ld a, (de)            ; D3 76 1A
 ioi altd ld a, (de+)           ; D3 76 1A 13
 ioi altd ld a, (de-)           ; D3 76 1A 1B
 ioi altd ld a, (hl)            ; D3 76 7E
 ioi altd ld a, (hl+)           ; D3 76 7E 23
 ioi altd ld a, (hl-)           ; D3 76 7E 2B
 ioi altd ld a, (hld)           ; D3 76 7E 2B
 ioi altd ld a, (hli)           ; D3 76 7E 23
 ioi altd ld a, (ix)            ; D3 76 DD 7E 00
 ioi altd ld a, (ix+127)        ; D3 76 DD 7E 7F
 ioi altd ld a, (ix-128)        ; D3 76 DD 7E 80
 ioi altd ld a, (iy)            ; D3 76 FD 7E 00
 ioi altd ld a, (iy+127)        ; D3 76 FD 7E 7F
 ioi altd ld a, (iy-128)        ; D3 76 FD 7E 80
 ioi altd ld b, (hl)            ; D3 76 46
 ioi altd ld b, (hl+)           ; D3 76 46 23
 ioi altd ld b, (hl-)           ; D3 76 46 2B
 ioi altd ld b, (hld)           ; D3 76 46 2B
 ioi altd ld b, (hli)           ; D3 76 46 23
 ioi altd ld b, (ix)            ; D3 76 DD 46 00
 ioi altd ld b, (ix+127)        ; D3 76 DD 46 7F
 ioi altd ld b, (ix-128)        ; D3 76 DD 46 80
 ioi altd ld b, (iy)            ; D3 76 FD 46 00
 ioi altd ld b, (iy+127)        ; D3 76 FD 46 7F
 ioi altd ld b, (iy-128)        ; D3 76 FD 46 80
 ioi altd ld bc, (-32768)       ; D3 76 ED 4B 00 80
 ioi altd ld bc, (32767)        ; D3 76 ED 4B FF 7F
 ioi altd ld bc, (65535)        ; D3 76 ED 4B FF FF
 ioi altd ld c, (hl)            ; D3 76 4E
 ioi altd ld c, (hl+)           ; D3 76 4E 23
 ioi altd ld c, (hl-)           ; D3 76 4E 2B
 ioi altd ld c, (hld)           ; D3 76 4E 2B
 ioi altd ld c, (hli)           ; D3 76 4E 23
 ioi altd ld c, (ix)            ; D3 76 DD 4E 00
 ioi altd ld c, (ix+127)        ; D3 76 DD 4E 7F
 ioi altd ld c, (ix-128)        ; D3 76 DD 4E 80
 ioi altd ld c, (iy)            ; D3 76 FD 4E 00
 ioi altd ld c, (iy+127)        ; D3 76 FD 4E 7F
 ioi altd ld c, (iy-128)        ; D3 76 FD 4E 80
 ioi altd ld d, (hl)            ; D3 76 56
 ioi altd ld d, (hl+)           ; D3 76 56 23
 ioi altd ld d, (hl-)           ; D3 76 56 2B
 ioi altd ld d, (hld)           ; D3 76 56 2B
 ioi altd ld d, (hli)           ; D3 76 56 23
 ioi altd ld d, (ix)            ; D3 76 DD 56 00
 ioi altd ld d, (ix+127)        ; D3 76 DD 56 7F
 ioi altd ld d, (ix-128)        ; D3 76 DD 56 80
 ioi altd ld d, (iy)            ; D3 76 FD 56 00
 ioi altd ld d, (iy+127)        ; D3 76 FD 56 7F
 ioi altd ld d, (iy-128)        ; D3 76 FD 56 80
 ioi altd ld de, (-32768)       ; D3 76 ED 5B 00 80
 ioi altd ld de, (32767)        ; D3 76 ED 5B FF 7F
 ioi altd ld de, (65535)        ; D3 76 ED 5B FF FF
 ioi altd ld e, (hl)            ; D3 76 5E
 ioi altd ld e, (hl+)           ; D3 76 5E 23
 ioi altd ld e, (hl-)           ; D3 76 5E 2B
 ioi altd ld e, (hld)           ; D3 76 5E 2B
 ioi altd ld e, (hli)           ; D3 76 5E 23
 ioi altd ld e, (ix)            ; D3 76 DD 5E 00
 ioi altd ld e, (ix+127)        ; D3 76 DD 5E 7F
 ioi altd ld e, (ix-128)        ; D3 76 DD 5E 80
 ioi altd ld e, (iy)            ; D3 76 FD 5E 00
 ioi altd ld e, (iy+127)        ; D3 76 FD 5E 7F
 ioi altd ld e, (iy-128)        ; D3 76 FD 5E 80
 ioi altd ld h, (hl)            ; D3 76 66
 ioi altd ld h, (hl+)           ; D3 76 66 23
 ioi altd ld h, (hl-)           ; D3 76 66 2B
 ioi altd ld h, (hld)           ; D3 76 66 2B
 ioi altd ld h, (hli)           ; D3 76 66 23
 ioi altd ld h, (ix)            ; D3 76 DD 66 00
 ioi altd ld h, (ix+127)        ; D3 76 DD 66 7F
 ioi altd ld h, (ix-128)        ; D3 76 DD 66 80
 ioi altd ld h, (iy)            ; D3 76 FD 66 00
 ioi altd ld h, (iy+127)        ; D3 76 FD 66 7F
 ioi altd ld h, (iy-128)        ; D3 76 FD 66 80
 ioi altd ld hl, (-32768)       ; D3 76 2A 00 80
 ioi altd ld hl, (32767)        ; D3 76 2A FF 7F
 ioi altd ld hl, (65535)        ; D3 76 2A FF FF
 ioi altd ld hl, (hl)           ; D3 76 DD E4 00
 ioi altd ld hl, (hl+127)       ; D3 76 DD E4 7F
 ioi altd ld hl, (hl-128)       ; D3 76 DD E4 80
 ioi altd ld hl, (ix)           ; D3 76 E4 00
 ioi altd ld hl, (ix+127)       ; D3 76 E4 7F
 ioi altd ld hl, (ix-128)       ; D3 76 E4 80
 ioi altd ld hl, (iy)           ; D3 76 FD E4 00
 ioi altd ld hl, (iy+127)       ; D3 76 FD E4 7F
 ioi altd ld hl, (iy-128)       ; D3 76 FD E4 80
 ioi altd ld l, (hl)            ; D3 76 6E
 ioi altd ld l, (hl+)           ; D3 76 6E 23
 ioi altd ld l, (hl-)           ; D3 76 6E 2B
 ioi altd ld l, (hld)           ; D3 76 6E 2B
 ioi altd ld l, (hli)           ; D3 76 6E 23
 ioi altd ld l, (ix)            ; D3 76 DD 6E 00
 ioi altd ld l, (ix+127)        ; D3 76 DD 6E 7F
 ioi altd ld l, (ix-128)        ; D3 76 DD 6E 80
 ioi altd ld l, (iy)            ; D3 76 FD 6E 00
 ioi altd ld l, (iy+127)        ; D3 76 FD 6E 7F
 ioi altd ld l, (iy-128)        ; D3 76 FD 6E 80
 ioi altd or (hl)               ; D3 76 B6
 ioi altd or (hl+)              ; D3 76 B6 23
 ioi altd or (hl-)              ; D3 76 B6 2B
 ioi altd or (ix)               ; D3 76 DD B6 00
 ioi altd or (ix+127)           ; D3 76 DD B6 7F
 ioi altd or (ix-128)           ; D3 76 DD B6 80
 ioi altd or (iy)               ; D3 76 FD B6 00
 ioi altd or (iy+127)           ; D3 76 FD B6 7F
 ioi altd or (iy-128)           ; D3 76 FD B6 80
 ioi altd or a, (hl)            ; D3 76 B6
 ioi altd or a, (hl+)           ; D3 76 B6 23
 ioi altd or a, (hl-)           ; D3 76 B6 2B
 ioi altd or a, (ix)            ; D3 76 DD B6 00
 ioi altd or a, (ix+127)        ; D3 76 DD B6 7F
 ioi altd or a, (ix-128)        ; D3 76 DD B6 80
 ioi altd or a, (iy)            ; D3 76 FD B6 00
 ioi altd or a, (iy+127)        ; D3 76 FD B6 7F
 ioi altd or a, (iy-128)        ; D3 76 FD B6 80
 ioi altd rl (hl)               ; D3 76 CB 16
 ioi altd rl (ix)               ; D3 76 DD CB 00 16
 ioi altd rl (ix+127)           ; D3 76 DD CB 7F 16
 ioi altd rl (ix-128)           ; D3 76 DD CB 80 16
 ioi altd rl (iy)               ; D3 76 FD CB 00 16
 ioi altd rl (iy+127)           ; D3 76 FD CB 7F 16
 ioi altd rl (iy-128)           ; D3 76 FD CB 80 16
 ioi altd rlc (hl)              ; D3 76 CB 06
 ioi altd rlc (ix)              ; D3 76 DD CB 00 06
 ioi altd rlc (ix+127)          ; D3 76 DD CB 7F 06
 ioi altd rlc (ix-128)          ; D3 76 DD CB 80 06
 ioi altd rlc (iy)              ; D3 76 FD CB 00 06
 ioi altd rlc (iy+127)          ; D3 76 FD CB 7F 06
 ioi altd rlc (iy-128)          ; D3 76 FD CB 80 06
 ioi altd rr (hl)               ; D3 76 CB 1E
 ioi altd rr (ix)               ; D3 76 DD CB 00 1E
 ioi altd rr (ix+127)           ; D3 76 DD CB 7F 1E
 ioi altd rr (ix-128)           ; D3 76 DD CB 80 1E
 ioi altd rr (iy)               ; D3 76 FD CB 00 1E
 ioi altd rr (iy+127)           ; D3 76 FD CB 7F 1E
 ioi altd rr (iy-128)           ; D3 76 FD CB 80 1E
 ioi altd rrc (hl)              ; D3 76 CB 0E
 ioi altd rrc (ix)              ; D3 76 DD CB 00 0E
 ioi altd rrc (ix+127)          ; D3 76 DD CB 7F 0E
 ioi altd rrc (ix-128)          ; D3 76 DD CB 80 0E
 ioi altd rrc (iy)              ; D3 76 FD CB 00 0E
 ioi altd rrc (iy+127)          ; D3 76 FD CB 7F 0E
 ioi altd rrc (iy-128)          ; D3 76 FD CB 80 0E
 ioi altd sbc (hl)              ; D3 76 9E
 ioi altd sbc (hl+)             ; D3 76 9E 23
 ioi altd sbc (hl-)             ; D3 76 9E 2B
 ioi altd sbc (ix)              ; D3 76 DD 9E 00
 ioi altd sbc (ix+127)          ; D3 76 DD 9E 7F
 ioi altd sbc (ix-128)          ; D3 76 DD 9E 80
 ioi altd sbc (iy)              ; D3 76 FD 9E 00
 ioi altd sbc (iy+127)          ; D3 76 FD 9E 7F
 ioi altd sbc (iy-128)          ; D3 76 FD 9E 80
 ioi altd sbc a, (hl)           ; D3 76 9E
 ioi altd sbc a, (hl+)          ; D3 76 9E 23
 ioi altd sbc a, (hl-)          ; D3 76 9E 2B
 ioi altd sbc a, (ix)           ; D3 76 DD 9E 00
 ioi altd sbc a, (ix+127)       ; D3 76 DD 9E 7F
 ioi altd sbc a, (ix-128)       ; D3 76 DD 9E 80
 ioi altd sbc a, (iy)           ; D3 76 FD 9E 00
 ioi altd sbc a, (iy+127)       ; D3 76 FD 9E 7F
 ioi altd sbc a, (iy-128)       ; D3 76 FD 9E 80
 ioi altd sla (hl)              ; D3 76 CB 26
 ioi altd sla (ix)              ; D3 76 DD CB 00 26
 ioi altd sla (ix+127)          ; D3 76 DD CB 7F 26
 ioi altd sla (ix-128)          ; D3 76 DD CB 80 26
 ioi altd sla (iy)              ; D3 76 FD CB 00 26
 ioi altd sla (iy+127)          ; D3 76 FD CB 7F 26
 ioi altd sla (iy-128)          ; D3 76 FD CB 80 26
 ioi altd sra (hl)              ; D3 76 CB 2E
 ioi altd sra (ix)              ; D3 76 DD CB 00 2E
 ioi altd sra (ix+127)          ; D3 76 DD CB 7F 2E
 ioi altd sra (ix-128)          ; D3 76 DD CB 80 2E
 ioi altd sra (iy)              ; D3 76 FD CB 00 2E
 ioi altd sra (iy+127)          ; D3 76 FD CB 7F 2E
 ioi altd sra (iy-128)          ; D3 76 FD CB 80 2E
 ioi altd srl (hl)              ; D3 76 CB 3E
 ioi altd srl (ix)              ; D3 76 DD CB 00 3E
 ioi altd srl (ix+127)          ; D3 76 DD CB 7F 3E
 ioi altd srl (ix-128)          ; D3 76 DD CB 80 3E
 ioi altd srl (iy)              ; D3 76 FD CB 00 3E
 ioi altd srl (iy+127)          ; D3 76 FD CB 7F 3E
 ioi altd srl (iy-128)          ; D3 76 FD CB 80 3E
 ioi altd sub (hl)              ; D3 76 96
 ioi altd sub (hl+)             ; D3 76 96 23
 ioi altd sub (hl-)             ; D3 76 96 2B
 ioi altd sub (ix)              ; D3 76 DD 96 00
 ioi altd sub (ix+127)          ; D3 76 DD 96 7F
 ioi altd sub (ix-128)          ; D3 76 DD 96 80
 ioi altd sub (iy)              ; D3 76 FD 96 00
 ioi altd sub (iy+127)          ; D3 76 FD 96 7F
 ioi altd sub (iy-128)          ; D3 76 FD 96 80
 ioi altd sub a, (hl)           ; D3 76 96
 ioi altd sub a, (hl+)          ; D3 76 96 23
 ioi altd sub a, (hl-)          ; D3 76 96 2B
 ioi altd sub a, (ix)           ; D3 76 DD 96 00
 ioi altd sub a, (ix+127)       ; D3 76 DD 96 7F
 ioi altd sub a, (ix-128)       ; D3 76 DD 96 80
 ioi altd sub a, (iy)           ; D3 76 FD 96 00
 ioi altd sub a, (iy+127)       ; D3 76 FD 96 7F
 ioi altd sub a, (iy-128)       ; D3 76 FD 96 80
 ioi altd xor (hl)              ; D3 76 AE
 ioi altd xor (hl+)             ; D3 76 AE 23
 ioi altd xor (hl-)             ; D3 76 AE 2B
 ioi altd xor (ix)              ; D3 76 DD AE 00
 ioi altd xor (ix+127)          ; D3 76 DD AE 7F
 ioi altd xor (ix-128)          ; D3 76 DD AE 80
 ioi altd xor (iy)              ; D3 76 FD AE 00
 ioi altd xor (iy+127)          ; D3 76 FD AE 7F
 ioi altd xor (iy-128)          ; D3 76 FD AE 80
 ioi altd xor a, (hl)           ; D3 76 AE
 ioi altd xor a, (hl+)          ; D3 76 AE 23
 ioi altd xor a, (hl-)          ; D3 76 AE 2B
 ioi altd xor a, (ix)           ; D3 76 DD AE 00
 ioi altd xor a, (ix+127)       ; D3 76 DD AE 7F
 ioi altd xor a, (ix-128)       ; D3 76 DD AE 80
 ioi altd xor a, (iy)           ; D3 76 FD AE 00
 ioi altd xor a, (iy+127)       ; D3 76 FD AE 7F
 ioi altd xor a, (iy-128)       ; D3 76 FD AE 80
 ioi and (hl)                   ; D3 A6
 ioi and (hl+)                  ; D3 A6 23
 ioi and (hl-)                  ; D3 A6 2B
 ioi and (ix)                   ; D3 DD A6 00
 ioi and (ix+127)               ; D3 DD A6 7F
 ioi and (ix-128)               ; D3 DD A6 80
 ioi and (iy)                   ; D3 FD A6 00
 ioi and (iy+127)               ; D3 FD A6 7F
 ioi and (iy-128)               ; D3 FD A6 80
 ioi and a', (hl)               ; D3 76 A6
 ioi and a', (hl+)              ; D3 76 A6 23
 ioi and a', (hl-)              ; D3 76 A6 2B
 ioi and a', (ix)               ; D3 76 DD A6 00
 ioi and a', (ix+127)           ; D3 76 DD A6 7F
 ioi and a', (ix-128)           ; D3 76 DD A6 80
 ioi and a', (iy)               ; D3 76 FD A6 00
 ioi and a', (iy+127)           ; D3 76 FD A6 7F
 ioi and a', (iy-128)           ; D3 76 FD A6 80
 ioi and a, (hl)                ; D3 A6
 ioi and a, (hl+)               ; D3 A6 23
 ioi and a, (hl-)               ; D3 A6 2B
 ioi and a, (ix)                ; D3 DD A6 00
 ioi and a, (ix+127)            ; D3 DD A6 7F
 ioi and a, (ix-128)            ; D3 DD A6 80
 ioi and a, (iy)                ; D3 FD A6 00
 ioi and a, (iy+127)            ; D3 FD A6 7F
 ioi and a, (iy-128)            ; D3 FD A6 80
 ioi bit 0, (hl)                ; D3 CB 46
 ioi bit 0, (ix)                ; D3 DD CB 00 46
 ioi bit 0, (ix+127)            ; D3 DD CB 7F 46
 ioi bit 0, (ix-128)            ; D3 DD CB 80 46
 ioi bit 0, (iy)                ; D3 FD CB 00 46
 ioi bit 0, (iy+127)            ; D3 FD CB 7F 46
 ioi bit 0, (iy-128)            ; D3 FD CB 80 46
 ioi bit 1, (hl)                ; D3 CB 4E
 ioi bit 1, (ix)                ; D3 DD CB 00 4E
 ioi bit 1, (ix+127)            ; D3 DD CB 7F 4E
 ioi bit 1, (ix-128)            ; D3 DD CB 80 4E
 ioi bit 1, (iy)                ; D3 FD CB 00 4E
 ioi bit 1, (iy+127)            ; D3 FD CB 7F 4E
 ioi bit 1, (iy-128)            ; D3 FD CB 80 4E
 ioi bit 2, (hl)                ; D3 CB 56
 ioi bit 2, (ix)                ; D3 DD CB 00 56
 ioi bit 2, (ix+127)            ; D3 DD CB 7F 56
 ioi bit 2, (ix-128)            ; D3 DD CB 80 56
 ioi bit 2, (iy)                ; D3 FD CB 00 56
 ioi bit 2, (iy+127)            ; D3 FD CB 7F 56
 ioi bit 2, (iy-128)            ; D3 FD CB 80 56
 ioi bit 3, (hl)                ; D3 CB 5E
 ioi bit 3, (ix)                ; D3 DD CB 00 5E
 ioi bit 3, (ix+127)            ; D3 DD CB 7F 5E
 ioi bit 3, (ix-128)            ; D3 DD CB 80 5E
 ioi bit 3, (iy)                ; D3 FD CB 00 5E
 ioi bit 3, (iy+127)            ; D3 FD CB 7F 5E
 ioi bit 3, (iy-128)            ; D3 FD CB 80 5E
 ioi bit 4, (hl)                ; D3 CB 66
 ioi bit 4, (ix)                ; D3 DD CB 00 66
 ioi bit 4, (ix+127)            ; D3 DD CB 7F 66
 ioi bit 4, (ix-128)            ; D3 DD CB 80 66
 ioi bit 4, (iy)                ; D3 FD CB 00 66
 ioi bit 4, (iy+127)            ; D3 FD CB 7F 66
 ioi bit 4, (iy-128)            ; D3 FD CB 80 66
 ioi bit 5, (hl)                ; D3 CB 6E
 ioi bit 5, (ix)                ; D3 DD CB 00 6E
 ioi bit 5, (ix+127)            ; D3 DD CB 7F 6E
 ioi bit 5, (ix-128)            ; D3 DD CB 80 6E
 ioi bit 5, (iy)                ; D3 FD CB 00 6E
 ioi bit 5, (iy+127)            ; D3 FD CB 7F 6E
 ioi bit 5, (iy-128)            ; D3 FD CB 80 6E
 ioi bit 6, (hl)                ; D3 CB 76
 ioi bit 6, (ix)                ; D3 DD CB 00 76
 ioi bit 6, (ix+127)            ; D3 DD CB 7F 76
 ioi bit 6, (ix-128)            ; D3 DD CB 80 76
 ioi bit 6, (iy)                ; D3 FD CB 00 76
 ioi bit 6, (iy+127)            ; D3 FD CB 7F 76
 ioi bit 6, (iy-128)            ; D3 FD CB 80 76
 ioi bit 7, (hl)                ; D3 CB 7E
 ioi bit 7, (ix)                ; D3 DD CB 00 7E
 ioi bit 7, (ix+127)            ; D3 DD CB 7F 7E
 ioi bit 7, (ix-128)            ; D3 DD CB 80 7E
 ioi bit 7, (iy)                ; D3 FD CB 00 7E
 ioi bit 7, (iy+127)            ; D3 FD CB 7F 7E
 ioi bit 7, (iy-128)            ; D3 FD CB 80 7E
 ioi cmp (hl)                   ; D3 BE
 ioi cmp (hl+)                  ; D3 BE 23
 ioi cmp (hl-)                  ; D3 BE 2B
 ioi cmp (ix)                   ; D3 DD BE 00
 ioi cmp (ix+127)               ; D3 DD BE 7F
 ioi cmp (ix-128)               ; D3 DD BE 80
 ioi cmp (iy)                   ; D3 FD BE 00
 ioi cmp (iy+127)               ; D3 FD BE 7F
 ioi cmp (iy-128)               ; D3 FD BE 80
 ioi cmp a, (hl)                ; D3 BE
 ioi cmp a, (hl+)               ; D3 BE 23
 ioi cmp a, (hl-)               ; D3 BE 2B
 ioi cmp a, (ix)                ; D3 DD BE 00
 ioi cmp a, (ix+127)            ; D3 DD BE 7F
 ioi cmp a, (ix-128)            ; D3 DD BE 80
 ioi cmp a, (iy)                ; D3 FD BE 00
 ioi cmp a, (iy+127)            ; D3 FD BE 7F
 ioi cmp a, (iy-128)            ; D3 FD BE 80
 ioi cp (hl)                    ; D3 BE
 ioi cp (hl+)                   ; D3 BE 23
 ioi cp (hl-)                   ; D3 BE 2B
 ioi cp (ix)                    ; D3 DD BE 00
 ioi cp (ix+127)                ; D3 DD BE 7F
 ioi cp (ix-128)                ; D3 DD BE 80
 ioi cp (iy)                    ; D3 FD BE 00
 ioi cp (iy+127)                ; D3 FD BE 7F
 ioi cp (iy-128)                ; D3 FD BE 80
 ioi cp a, (hl)                 ; D3 BE
 ioi cp a, (hl+)                ; D3 BE 23
 ioi cp a, (hl-)                ; D3 BE 2B
 ioi cp a, (ix)                 ; D3 DD BE 00
 ioi cp a, (ix+127)             ; D3 DD BE 7F
 ioi cp a, (ix-128)             ; D3 DD BE 80
 ioi cp a, (iy)                 ; D3 FD BE 00
 ioi cp a, (iy+127)             ; D3 FD BE 7F
 ioi cp a, (iy-128)             ; D3 FD BE 80
 ioi dec (hl)                   ; D3 35
 ioi dec (hl+)                  ; D3 35 23
 ioi dec (hl-)                  ; D3 35 2B
 ioi dec (ix)                   ; D3 DD 35 00
 ioi dec (ix+127)               ; D3 DD 35 7F
 ioi dec (ix-128)               ; D3 DD 35 80
 ioi dec (iy)                   ; D3 FD 35 00
 ioi dec (iy+127)               ; D3 FD 35 7F
 ioi dec (iy-128)               ; D3 FD 35 80
 ioi inc (hl)                   ; D3 34
 ioi inc (hl+)                  ; D3 34 23
 ioi inc (hl-)                  ; D3 34 2B
 ioi inc (ix)                   ; D3 DD 34 00
 ioi inc (ix+127)               ; D3 DD 34 7F
 ioi inc (ix-128)               ; D3 DD 34 80
 ioi inc (iy)                   ; D3 FD 34 00
 ioi inc (iy+127)               ; D3 FD 34 7F
 ioi inc (iy-128)               ; D3 FD 34 80
 ioi ld (-32768), a             ; D3 32 00 80
 ioi ld (-32768), bc            ; D3 ED 43 00 80
 ioi ld (-32768), de            ; D3 ED 53 00 80
 ioi ld (-32768), hl            ; D3 22 00 80
 ioi ld (-32768), ix            ; D3 DD 22 00 80
 ioi ld (-32768), iy            ; D3 FD 22 00 80
 ioi ld (-32768), sp            ; D3 ED 73 00 80
 ioi ld (32767), a              ; D3 32 FF 7F
 ioi ld (32767), bc             ; D3 ED 43 FF 7F
 ioi ld (32767), de             ; D3 ED 53 FF 7F
 ioi ld (32767), hl             ; D3 22 FF 7F
 ioi ld (32767), ix             ; D3 DD 22 FF 7F
 ioi ld (32767), iy             ; D3 FD 22 FF 7F
 ioi ld (32767), sp             ; D3 ED 73 FF 7F
 ioi ld (65535), a              ; D3 32 FF FF
 ioi ld (65535), bc             ; D3 ED 43 FF FF
 ioi ld (65535), de             ; D3 ED 53 FF FF
 ioi ld (65535), hl             ; D3 22 FF FF
 ioi ld (65535), ix             ; D3 DD 22 FF FF
 ioi ld (65535), iy             ; D3 FD 22 FF FF
 ioi ld (65535), sp             ; D3 ED 73 FF FF
 ioi ld (bc), a                 ; D3 02
 ioi ld (bc+), a                ; D3 02 03
 ioi ld (bc-), a                ; D3 02 0B
 ioi ld (de), a                 ; D3 12
 ioi ld (de+), a                ; D3 12 13
 ioi ld (de-), a                ; D3 12 1B
 ioi ld (hl), -128              ; D3 36 80
 ioi ld (hl), 127               ; D3 36 7F
 ioi ld (hl), 255               ; D3 36 FF
 ioi ld (hl), a                 ; D3 77
 ioi ld (hl), b                 ; D3 70
 ioi ld (hl), c                 ; D3 71
 ioi ld (hl), d                 ; D3 72
 ioi ld (hl), e                 ; D3 73
 ioi ld (hl), h                 ; D3 74
 ioi ld (hl), hl                ; D3 DD F4 00
 ioi ld (hl), l                 ; D3 75
 ioi ld (hl+), -128             ; D3 36 80 23
 ioi ld (hl+), 127              ; D3 36 7F 23
 ioi ld (hl+), 255              ; D3 36 FF 23
 ioi ld (hl+), a                ; D3 77 23
 ioi ld (hl+), b                ; D3 70 23
 ioi ld (hl+), c                ; D3 71 23
 ioi ld (hl+), d                ; D3 72 23
 ioi ld (hl+), e                ; D3 73 23
 ioi ld (hl+), h                ; D3 74 23
 ioi ld (hl+), l                ; D3 75 23
 ioi ld (hl+127), hl            ; D3 DD F4 7F
 ioi ld (hl-), -128             ; D3 36 80 2B
 ioi ld (hl-), 127              ; D3 36 7F 2B
 ioi ld (hl-), 255              ; D3 36 FF 2B
 ioi ld (hl-), a                ; D3 77 2B
 ioi ld (hl-), b                ; D3 70 2B
 ioi ld (hl-), c                ; D3 71 2B
 ioi ld (hl-), d                ; D3 72 2B
 ioi ld (hl-), e                ; D3 73 2B
 ioi ld (hl-), h                ; D3 74 2B
 ioi ld (hl-), l                ; D3 75 2B
 ioi ld (hl-128), hl            ; D3 DD F4 80
 ioi ld (hld), a                ; D3 77 2B
 ioi ld (hld), b                ; D3 70 2B
 ioi ld (hld), c                ; D3 71 2B
 ioi ld (hld), d                ; D3 72 2B
 ioi ld (hld), e                ; D3 73 2B
 ioi ld (hld), h                ; D3 74 2B
 ioi ld (hld), l                ; D3 75 2B
 ioi ld (hli), a                ; D3 77 23
 ioi ld (hli), b                ; D3 70 23
 ioi ld (hli), c                ; D3 71 23
 ioi ld (hli), d                ; D3 72 23
 ioi ld (hli), e                ; D3 73 23
 ioi ld (hli), h                ; D3 74 23
 ioi ld (hli), l                ; D3 75 23
 ioi ld (ix), -128              ; D3 DD 36 00 80
 ioi ld (ix), 127               ; D3 DD 36 00 7F
 ioi ld (ix), 255               ; D3 DD 36 00 FF
 ioi ld (ix), a                 ; D3 DD 77 00
 ioi ld (ix), b                 ; D3 DD 70 00
 ioi ld (ix), c                 ; D3 DD 71 00
 ioi ld (ix), d                 ; D3 DD 72 00
 ioi ld (ix), e                 ; D3 DD 73 00
 ioi ld (ix), h                 ; D3 DD 74 00
 ioi ld (ix), hl                ; D3 F4 00
 ioi ld (ix), l                 ; D3 DD 75 00
 ioi ld (ix+127), -128          ; D3 DD 36 7F 80
 ioi ld (ix+127), 127           ; D3 DD 36 7F 7F
 ioi ld (ix+127), 255           ; D3 DD 36 7F FF
 ioi ld (ix+127), a             ; D3 DD 77 7F
 ioi ld (ix+127), b             ; D3 DD 70 7F
 ioi ld (ix+127), c             ; D3 DD 71 7F
 ioi ld (ix+127), d             ; D3 DD 72 7F
 ioi ld (ix+127), e             ; D3 DD 73 7F
 ioi ld (ix+127), h             ; D3 DD 74 7F
 ioi ld (ix+127), hl            ; D3 F4 7F
 ioi ld (ix+127), l             ; D3 DD 75 7F
 ioi ld (ix-128), -128          ; D3 DD 36 80 80
 ioi ld (ix-128), 127           ; D3 DD 36 80 7F
 ioi ld (ix-128), 255           ; D3 DD 36 80 FF
 ioi ld (ix-128), a             ; D3 DD 77 80
 ioi ld (ix-128), b             ; D3 DD 70 80
 ioi ld (ix-128), c             ; D3 DD 71 80
 ioi ld (ix-128), d             ; D3 DD 72 80
 ioi ld (ix-128), e             ; D3 DD 73 80
 ioi ld (ix-128), h             ; D3 DD 74 80
 ioi ld (ix-128), hl            ; D3 F4 80
 ioi ld (ix-128), l             ; D3 DD 75 80
 ioi ld (iy), -128              ; D3 FD 36 00 80
 ioi ld (iy), 127               ; D3 FD 36 00 7F
 ioi ld (iy), 255               ; D3 FD 36 00 FF
 ioi ld (iy), a                 ; D3 FD 77 00
 ioi ld (iy), b                 ; D3 FD 70 00
 ioi ld (iy), c                 ; D3 FD 71 00
 ioi ld (iy), d                 ; D3 FD 72 00
 ioi ld (iy), e                 ; D3 FD 73 00
 ioi ld (iy), h                 ; D3 FD 74 00
 ioi ld (iy), hl                ; D3 FD F4 00
 ioi ld (iy), l                 ; D3 FD 75 00
 ioi ld (iy+127), -128          ; D3 FD 36 7F 80
 ioi ld (iy+127), 127           ; D3 FD 36 7F 7F
 ioi ld (iy+127), 255           ; D3 FD 36 7F FF
 ioi ld (iy+127), a             ; D3 FD 77 7F
 ioi ld (iy+127), b             ; D3 FD 70 7F
 ioi ld (iy+127), c             ; D3 FD 71 7F
 ioi ld (iy+127), d             ; D3 FD 72 7F
 ioi ld (iy+127), e             ; D3 FD 73 7F
 ioi ld (iy+127), h             ; D3 FD 74 7F
 ioi ld (iy+127), hl            ; D3 FD F4 7F
 ioi ld (iy+127), l             ; D3 FD 75 7F
 ioi ld (iy-128), -128          ; D3 FD 36 80 80
 ioi ld (iy-128), 127           ; D3 FD 36 80 7F
 ioi ld (iy-128), 255           ; D3 FD 36 80 FF
 ioi ld (iy-128), a             ; D3 FD 77 80
 ioi ld (iy-128), b             ; D3 FD 70 80
 ioi ld (iy-128), c             ; D3 FD 71 80
 ioi ld (iy-128), d             ; D3 FD 72 80
 ioi ld (iy-128), e             ; D3 FD 73 80
 ioi ld (iy-128), h             ; D3 FD 74 80
 ioi ld (iy-128), hl            ; D3 FD F4 80
 ioi ld (iy-128), l             ; D3 FD 75 80
 ioi ld a', (-32768)            ; D3 76 3A 00 80
 ioi ld a', (32767)             ; D3 76 3A FF 7F
 ioi ld a', (65535)             ; D3 76 3A FF FF
 ioi ld a', (bc)                ; D3 76 0A
 ioi ld a', (bc+)               ; D3 76 0A 03
 ioi ld a', (bc-)               ; D3 76 0A 0B
 ioi ld a', (de)                ; D3 76 1A
 ioi ld a', (de+)               ; D3 76 1A 13
 ioi ld a', (de-)               ; D3 76 1A 1B
 ioi ld a', (hl)                ; D3 76 7E
 ioi ld a', (hl+)               ; D3 76 7E 23
 ioi ld a', (hl-)               ; D3 76 7E 2B
 ioi ld a', (hld)               ; D3 76 7E 2B
 ioi ld a', (hli)               ; D3 76 7E 23
 ioi ld a', (ix)                ; D3 76 DD 7E 00
 ioi ld a', (ix+127)            ; D3 76 DD 7E 7F
 ioi ld a', (ix-128)            ; D3 76 DD 7E 80
 ioi ld a', (iy)                ; D3 76 FD 7E 00
 ioi ld a', (iy+127)            ; D3 76 FD 7E 7F
 ioi ld a', (iy-128)            ; D3 76 FD 7E 80
 ioi ld a, (-32768)             ; D3 3A 00 80
 ioi ld a, (32767)              ; D3 3A FF 7F
 ioi ld a, (65535)              ; D3 3A FF FF
 ioi ld a, (bc)                 ; D3 0A
 ioi ld a, (bc+)                ; D3 0A 03
 ioi ld a, (bc-)                ; D3 0A 0B
 ioi ld a, (de)                 ; D3 1A
 ioi ld a, (de+)                ; D3 1A 13
 ioi ld a, (de-)                ; D3 1A 1B
 ioi ld a, (hl)                 ; D3 7E
 ioi ld a, (hl+)                ; D3 7E 23
 ioi ld a, (hl-)                ; D3 7E 2B
 ioi ld a, (hld)                ; D3 7E 2B
 ioi ld a, (hli)                ; D3 7E 23
 ioi ld a, (ix)                 ; D3 DD 7E 00
 ioi ld a, (ix+127)             ; D3 DD 7E 7F
 ioi ld a, (ix-128)             ; D3 DD 7E 80
 ioi ld a, (iy)                 ; D3 FD 7E 00
 ioi ld a, (iy+127)             ; D3 FD 7E 7F
 ioi ld a, (iy-128)             ; D3 FD 7E 80
 ioi ld b', (hl)                ; D3 76 46
 ioi ld b', (hl+)               ; D3 76 46 23
 ioi ld b', (hl-)               ; D3 76 46 2B
 ioi ld b', (hld)               ; D3 76 46 2B
 ioi ld b', (hli)               ; D3 76 46 23
 ioi ld b', (ix)                ; D3 76 DD 46 00
 ioi ld b', (ix+127)            ; D3 76 DD 46 7F
 ioi ld b', (ix-128)            ; D3 76 DD 46 80
 ioi ld b', (iy)                ; D3 76 FD 46 00
 ioi ld b', (iy+127)            ; D3 76 FD 46 7F
 ioi ld b', (iy-128)            ; D3 76 FD 46 80
 ioi ld b, (hl)                 ; D3 46
 ioi ld b, (hl+)                ; D3 46 23
 ioi ld b, (hl-)                ; D3 46 2B
 ioi ld b, (hld)                ; D3 46 2B
 ioi ld b, (hli)                ; D3 46 23
 ioi ld b, (ix)                 ; D3 DD 46 00
 ioi ld b, (ix+127)             ; D3 DD 46 7F
 ioi ld b, (ix-128)             ; D3 DD 46 80
 ioi ld b, (iy)                 ; D3 FD 46 00
 ioi ld b, (iy+127)             ; D3 FD 46 7F
 ioi ld b, (iy-128)             ; D3 FD 46 80
 ioi ld bc', (-32768)           ; D3 76 ED 4B 00 80
 ioi ld bc', (32767)            ; D3 76 ED 4B FF 7F
 ioi ld bc', (65535)            ; D3 76 ED 4B FF FF
 ioi ld bc, (-32768)            ; D3 ED 4B 00 80
 ioi ld bc, (32767)             ; D3 ED 4B FF 7F
 ioi ld bc, (65535)             ; D3 ED 4B FF FF
 ioi ld c', (hl)                ; D3 76 4E
 ioi ld c', (hl+)               ; D3 76 4E 23
 ioi ld c', (hl-)               ; D3 76 4E 2B
 ioi ld c', (hld)               ; D3 76 4E 2B
 ioi ld c', (hli)               ; D3 76 4E 23
 ioi ld c', (ix)                ; D3 76 DD 4E 00
 ioi ld c', (ix+127)            ; D3 76 DD 4E 7F
 ioi ld c', (ix-128)            ; D3 76 DD 4E 80
 ioi ld c', (iy)                ; D3 76 FD 4E 00
 ioi ld c', (iy+127)            ; D3 76 FD 4E 7F
 ioi ld c', (iy-128)            ; D3 76 FD 4E 80
 ioi ld c, (hl)                 ; D3 4E
 ioi ld c, (hl+)                ; D3 4E 23
 ioi ld c, (hl-)                ; D3 4E 2B
 ioi ld c, (hld)                ; D3 4E 2B
 ioi ld c, (hli)                ; D3 4E 23
 ioi ld c, (ix)                 ; D3 DD 4E 00
 ioi ld c, (ix+127)             ; D3 DD 4E 7F
 ioi ld c, (ix-128)             ; D3 DD 4E 80
 ioi ld c, (iy)                 ; D3 FD 4E 00
 ioi ld c, (iy+127)             ; D3 FD 4E 7F
 ioi ld c, (iy-128)             ; D3 FD 4E 80
 ioi ld d', (hl)                ; D3 76 56
 ioi ld d', (hl+)               ; D3 76 56 23
 ioi ld d', (hl-)               ; D3 76 56 2B
 ioi ld d', (hld)               ; D3 76 56 2B
 ioi ld d', (hli)               ; D3 76 56 23
 ioi ld d', (ix)                ; D3 76 DD 56 00
 ioi ld d', (ix+127)            ; D3 76 DD 56 7F
 ioi ld d', (ix-128)            ; D3 76 DD 56 80
 ioi ld d', (iy)                ; D3 76 FD 56 00
 ioi ld d', (iy+127)            ; D3 76 FD 56 7F
 ioi ld d', (iy-128)            ; D3 76 FD 56 80
 ioi ld d, (hl)                 ; D3 56
 ioi ld d, (hl+)                ; D3 56 23
 ioi ld d, (hl-)                ; D3 56 2B
 ioi ld d, (hld)                ; D3 56 2B
 ioi ld d, (hli)                ; D3 56 23
 ioi ld d, (ix)                 ; D3 DD 56 00
 ioi ld d, (ix+127)             ; D3 DD 56 7F
 ioi ld d, (ix-128)             ; D3 DD 56 80
 ioi ld d, (iy)                 ; D3 FD 56 00
 ioi ld d, (iy+127)             ; D3 FD 56 7F
 ioi ld d, (iy-128)             ; D3 FD 56 80
 ioi ld de', (-32768)           ; D3 76 ED 5B 00 80
 ioi ld de', (32767)            ; D3 76 ED 5B FF 7F
 ioi ld de', (65535)            ; D3 76 ED 5B FF FF
 ioi ld de, (-32768)            ; D3 ED 5B 00 80
 ioi ld de, (32767)             ; D3 ED 5B FF 7F
 ioi ld de, (65535)             ; D3 ED 5B FF FF
 ioi ld e', (hl)                ; D3 76 5E
 ioi ld e', (hl+)               ; D3 76 5E 23
 ioi ld e', (hl-)               ; D3 76 5E 2B
 ioi ld e', (hld)               ; D3 76 5E 2B
 ioi ld e', (hli)               ; D3 76 5E 23
 ioi ld e', (ix)                ; D3 76 DD 5E 00
 ioi ld e', (ix+127)            ; D3 76 DD 5E 7F
 ioi ld e', (ix-128)            ; D3 76 DD 5E 80
 ioi ld e', (iy)                ; D3 76 FD 5E 00
 ioi ld e', (iy+127)            ; D3 76 FD 5E 7F
 ioi ld e', (iy-128)            ; D3 76 FD 5E 80
 ioi ld e, (hl)                 ; D3 5E
 ioi ld e, (hl+)                ; D3 5E 23
 ioi ld e, (hl-)                ; D3 5E 2B
 ioi ld e, (hld)                ; D3 5E 2B
 ioi ld e, (hli)                ; D3 5E 23
 ioi ld e, (ix)                 ; D3 DD 5E 00
 ioi ld e, (ix+127)             ; D3 DD 5E 7F
 ioi ld e, (ix-128)             ; D3 DD 5E 80
 ioi ld e, (iy)                 ; D3 FD 5E 00
 ioi ld e, (iy+127)             ; D3 FD 5E 7F
 ioi ld e, (iy-128)             ; D3 FD 5E 80
 ioi ld h', (hl)                ; D3 76 66
 ioi ld h', (hl+)               ; D3 76 66 23
 ioi ld h', (hl-)               ; D3 76 66 2B
 ioi ld h', (hld)               ; D3 76 66 2B
 ioi ld h', (hli)               ; D3 76 66 23
 ioi ld h', (ix)                ; D3 76 DD 66 00
 ioi ld h', (ix+127)            ; D3 76 DD 66 7F
 ioi ld h', (ix-128)            ; D3 76 DD 66 80
 ioi ld h', (iy)                ; D3 76 FD 66 00
 ioi ld h', (iy+127)            ; D3 76 FD 66 7F
 ioi ld h', (iy-128)            ; D3 76 FD 66 80
 ioi ld h, (hl)                 ; D3 66
 ioi ld h, (hl+)                ; D3 66 23
 ioi ld h, (hl-)                ; D3 66 2B
 ioi ld h, (hld)                ; D3 66 2B
 ioi ld h, (hli)                ; D3 66 23
 ioi ld h, (ix)                 ; D3 DD 66 00
 ioi ld h, (ix+127)             ; D3 DD 66 7F
 ioi ld h, (ix-128)             ; D3 DD 66 80
 ioi ld h, (iy)                 ; D3 FD 66 00
 ioi ld h, (iy+127)             ; D3 FD 66 7F
 ioi ld h, (iy-128)             ; D3 FD 66 80
 ioi ld hl', (-32768)           ; D3 76 2A 00 80
 ioi ld hl', (32767)            ; D3 76 2A FF 7F
 ioi ld hl', (65535)            ; D3 76 2A FF FF
 ioi ld hl', (hl)               ; D3 76 DD E4 00
 ioi ld hl', (hl+127)           ; D3 76 DD E4 7F
 ioi ld hl', (hl-128)           ; D3 76 DD E4 80
 ioi ld hl', (ix)               ; D3 76 E4 00
 ioi ld hl', (ix+127)           ; D3 76 E4 7F
 ioi ld hl', (ix-128)           ; D3 76 E4 80
 ioi ld hl', (iy)               ; D3 76 FD E4 00
 ioi ld hl', (iy+127)           ; D3 76 FD E4 7F
 ioi ld hl', (iy-128)           ; D3 76 FD E4 80
 ioi ld hl, (-32768)            ; D3 2A 00 80
 ioi ld hl, (32767)             ; D3 2A FF 7F
 ioi ld hl, (65535)             ; D3 2A FF FF
 ioi ld hl, (hl)                ; D3 DD E4 00
 ioi ld hl, (hl+127)            ; D3 DD E4 7F
 ioi ld hl, (hl-128)            ; D3 DD E4 80
 ioi ld hl, (ix)                ; D3 E4 00
 ioi ld hl, (ix+127)            ; D3 E4 7F
 ioi ld hl, (ix-128)            ; D3 E4 80
 ioi ld hl, (iy)                ; D3 FD E4 00
 ioi ld hl, (iy+127)            ; D3 FD E4 7F
 ioi ld hl, (iy-128)            ; D3 FD E4 80
 ioi ld ix, (-32768)            ; D3 DD 2A 00 80
 ioi ld ix, (32767)             ; D3 DD 2A FF 7F
 ioi ld ix, (65535)             ; D3 DD 2A FF FF
 ioi ld iy, (-32768)            ; D3 FD 2A 00 80
 ioi ld iy, (32767)             ; D3 FD 2A FF 7F
 ioi ld iy, (65535)             ; D3 FD 2A FF FF
 ioi ld l', (hl)                ; D3 76 6E
 ioi ld l', (hl+)               ; D3 76 6E 23
 ioi ld l', (hl-)               ; D3 76 6E 2B
 ioi ld l', (hld)               ; D3 76 6E 2B
 ioi ld l', (hli)               ; D3 76 6E 23
 ioi ld l', (ix)                ; D3 76 DD 6E 00
 ioi ld l', (ix+127)            ; D3 76 DD 6E 7F
 ioi ld l', (ix-128)            ; D3 76 DD 6E 80
 ioi ld l', (iy)                ; D3 76 FD 6E 00
 ioi ld l', (iy+127)            ; D3 76 FD 6E 7F
 ioi ld l', (iy-128)            ; D3 76 FD 6E 80
 ioi ld l, (hl)                 ; D3 6E
 ioi ld l, (hl+)                ; D3 6E 23
 ioi ld l, (hl-)                ; D3 6E 2B
 ioi ld l, (hld)                ; D3 6E 2B
 ioi ld l, (hli)                ; D3 6E 23
 ioi ld l, (ix)                 ; D3 DD 6E 00
 ioi ld l, (ix+127)             ; D3 DD 6E 7F
 ioi ld l, (ix-128)             ; D3 DD 6E 80
 ioi ld l, (iy)                 ; D3 FD 6E 00
 ioi ld l, (iy+127)             ; D3 FD 6E 7F
 ioi ld l, (iy-128)             ; D3 FD 6E 80
 ioi ld sp, (-32768)            ; D3 ED 7B 00 80
 ioi ld sp, (32767)             ; D3 ED 7B FF 7F
 ioi ld sp, (65535)             ; D3 ED 7B FF FF
 ioi ldd                        ; D3 ED A8
 ioi ldd (bc), a                ; D3 02 0B
 ioi ldd (de), a                ; D3 12 1B
 ioi ldd (hl), -128             ; D3 36 80 2B
 ioi ldd (hl), 127              ; D3 36 7F 2B
 ioi ldd (hl), 255              ; D3 36 FF 2B
 ioi ldd (hl), a                ; D3 77 2B
 ioi ldd (hl), b                ; D3 70 2B
 ioi ldd (hl), c                ; D3 71 2B
 ioi ldd (hl), d                ; D3 72 2B
 ioi ldd (hl), e                ; D3 73 2B
 ioi ldd (hl), h                ; D3 74 2B
 ioi ldd (hl), l                ; D3 75 2B
 ioi ldd a, (bc)                ; D3 0A 0B
 ioi ldd a, (de)                ; D3 1A 1B
 ioi ldd a, (hl)                ; D3 7E 2B
 ioi ldd b, (hl)                ; D3 46 2B
 ioi ldd c, (hl)                ; D3 4E 2B
 ioi ldd d, (hl)                ; D3 56 2B
 ioi ldd e, (hl)                ; D3 5E 2B
 ioi ldd h, (hl)                ; D3 66 2B
 ioi ldd l, (hl)                ; D3 6E 2B
 ioi lddr                       ; D3 ED B8
 ioi lddsr                      ; D3 ED 98
 ioi ldi                        ; D3 ED A0
 ioi ldi (bc), a                ; D3 02 03
 ioi ldi (de), a                ; D3 12 13
 ioi ldi (hl), -128             ; D3 36 80 23
 ioi ldi (hl), 127              ; D3 36 7F 23
 ioi ldi (hl), 255              ; D3 36 FF 23
 ioi ldi (hl), a                ; D3 77 23
 ioi ldi (hl), b                ; D3 70 23
 ioi ldi (hl), c                ; D3 71 23
 ioi ldi (hl), d                ; D3 72 23
 ioi ldi (hl), e                ; D3 73 23
 ioi ldi (hl), h                ; D3 74 23
 ioi ldi (hl), l                ; D3 75 23
 ioi ldi a, (bc)                ; D3 0A 03
 ioi ldi a, (de)                ; D3 1A 13
 ioi ldi a, (hl)                ; D3 7E 23
 ioi ldi b, (hl)                ; D3 46 23
 ioi ldi c, (hl)                ; D3 4E 23
 ioi ldi d, (hl)                ; D3 56 23
 ioi ldi e, (hl)                ; D3 5E 23
 ioi ldi h, (hl)                ; D3 66 23
 ioi ldi l, (hl)                ; D3 6E 23
 ioi ldir                       ; D3 ED B0
 ioi ldisr                      ; D3 ED 90
 ioi lsddr                      ; D3 ED D8
 ioi lsdr                       ; D3 ED F8
 ioi lsidr                      ; D3 ED D0
 ioi lsir                       ; D3 ED F0
 ioi or (hl)                    ; D3 B6
 ioi or (hl+)                   ; D3 B6 23
 ioi or (hl-)                   ; D3 B6 2B
 ioi or (ix)                    ; D3 DD B6 00
 ioi or (ix+127)                ; D3 DD B6 7F
 ioi or (ix-128)                ; D3 DD B6 80
 ioi or (iy)                    ; D3 FD B6 00
 ioi or (iy+127)                ; D3 FD B6 7F
 ioi or (iy-128)                ; D3 FD B6 80
 ioi or a', (hl)                ; D3 76 B6
 ioi or a', (hl+)               ; D3 76 B6 23
 ioi or a', (hl-)               ; D3 76 B6 2B
 ioi or a', (ix)                ; D3 76 DD B6 00
 ioi or a', (ix+127)            ; D3 76 DD B6 7F
 ioi or a', (ix-128)            ; D3 76 DD B6 80
 ioi or a', (iy)                ; D3 76 FD B6 00
 ioi or a', (iy+127)            ; D3 76 FD B6 7F
 ioi or a', (iy-128)            ; D3 76 FD B6 80
 ioi or a, (hl)                 ; D3 B6
 ioi or a, (hl+)                ; D3 B6 23
 ioi or a, (hl-)                ; D3 B6 2B
 ioi or a, (ix)                 ; D3 DD B6 00
 ioi or a, (ix+127)             ; D3 DD B6 7F
 ioi or a, (ix-128)             ; D3 DD B6 80
 ioi or a, (iy)                 ; D3 FD B6 00
 ioi or a, (iy+127)             ; D3 FD B6 7F
 ioi or a, (iy-128)             ; D3 FD B6 80
 ioi res 0, (hl)                ; D3 CB 86
 ioi res 0, (ix)                ; D3 DD CB 00 86
 ioi res 0, (ix+127)            ; D3 DD CB 7F 86
 ioi res 0, (ix-128)            ; D3 DD CB 80 86
 ioi res 0, (iy)                ; D3 FD CB 00 86
 ioi res 0, (iy+127)            ; D3 FD CB 7F 86
 ioi res 0, (iy-128)            ; D3 FD CB 80 86
 ioi res 1, (hl)                ; D3 CB 8E
 ioi res 1, (ix)                ; D3 DD CB 00 8E
 ioi res 1, (ix+127)            ; D3 DD CB 7F 8E
 ioi res 1, (ix-128)            ; D3 DD CB 80 8E
 ioi res 1, (iy)                ; D3 FD CB 00 8E
 ioi res 1, (iy+127)            ; D3 FD CB 7F 8E
 ioi res 1, (iy-128)            ; D3 FD CB 80 8E
 ioi res 2, (hl)                ; D3 CB 96
 ioi res 2, (ix)                ; D3 DD CB 00 96
 ioi res 2, (ix+127)            ; D3 DD CB 7F 96
 ioi res 2, (ix-128)            ; D3 DD CB 80 96
 ioi res 2, (iy)                ; D3 FD CB 00 96
 ioi res 2, (iy+127)            ; D3 FD CB 7F 96
 ioi res 2, (iy-128)            ; D3 FD CB 80 96
 ioi res 3, (hl)                ; D3 CB 9E
 ioi res 3, (ix)                ; D3 DD CB 00 9E
 ioi res 3, (ix+127)            ; D3 DD CB 7F 9E
 ioi res 3, (ix-128)            ; D3 DD CB 80 9E
 ioi res 3, (iy)                ; D3 FD CB 00 9E
 ioi res 3, (iy+127)            ; D3 FD CB 7F 9E
 ioi res 3, (iy-128)            ; D3 FD CB 80 9E
 ioi res 4, (hl)                ; D3 CB A6
 ioi res 4, (ix)                ; D3 DD CB 00 A6
 ioi res 4, (ix+127)            ; D3 DD CB 7F A6
 ioi res 4, (ix-128)            ; D3 DD CB 80 A6
 ioi res 4, (iy)                ; D3 FD CB 00 A6
 ioi res 4, (iy+127)            ; D3 FD CB 7F A6
 ioi res 4, (iy-128)            ; D3 FD CB 80 A6
 ioi res 5, (hl)                ; D3 CB AE
 ioi res 5, (ix)                ; D3 DD CB 00 AE
 ioi res 5, (ix+127)            ; D3 DD CB 7F AE
 ioi res 5, (ix-128)            ; D3 DD CB 80 AE
 ioi res 5, (iy)                ; D3 FD CB 00 AE
 ioi res 5, (iy+127)            ; D3 FD CB 7F AE
 ioi res 5, (iy-128)            ; D3 FD CB 80 AE
 ioi res 6, (hl)                ; D3 CB B6
 ioi res 6, (ix)                ; D3 DD CB 00 B6
 ioi res 6, (ix+127)            ; D3 DD CB 7F B6
 ioi res 6, (ix-128)            ; D3 DD CB 80 B6
 ioi res 6, (iy)                ; D3 FD CB 00 B6
 ioi res 6, (iy+127)            ; D3 FD CB 7F B6
 ioi res 6, (iy-128)            ; D3 FD CB 80 B6
 ioi res 7, (hl)                ; D3 CB BE
 ioi res 7, (ix)                ; D3 DD CB 00 BE
 ioi res 7, (ix+127)            ; D3 DD CB 7F BE
 ioi res 7, (ix-128)            ; D3 DD CB 80 BE
 ioi res 7, (iy)                ; D3 FD CB 00 BE
 ioi res 7, (iy+127)            ; D3 FD CB 7F BE
 ioi res 7, (iy-128)            ; D3 FD CB 80 BE
 ioi rl (hl)                    ; D3 CB 16
 ioi rl (ix)                    ; D3 DD CB 00 16
 ioi rl (ix+127)                ; D3 DD CB 7F 16
 ioi rl (ix-128)                ; D3 DD CB 80 16
 ioi rl (iy)                    ; D3 FD CB 00 16
 ioi rl (iy+127)                ; D3 FD CB 7F 16
 ioi rl (iy-128)                ; D3 FD CB 80 16
 ioi rlc (hl)                   ; D3 CB 06
 ioi rlc (ix)                   ; D3 DD CB 00 06
 ioi rlc (ix+127)               ; D3 DD CB 7F 06
 ioi rlc (ix-128)               ; D3 DD CB 80 06
 ioi rlc (iy)                   ; D3 FD CB 00 06
 ioi rlc (iy+127)               ; D3 FD CB 7F 06
 ioi rlc (iy-128)               ; D3 FD CB 80 06
 ioi rr (hl)                    ; D3 CB 1E
 ioi rr (ix)                    ; D3 DD CB 00 1E
 ioi rr (ix+127)                ; D3 DD CB 7F 1E
 ioi rr (ix-128)                ; D3 DD CB 80 1E
 ioi rr (iy)                    ; D3 FD CB 00 1E
 ioi rr (iy+127)                ; D3 FD CB 7F 1E
 ioi rr (iy-128)                ; D3 FD CB 80 1E
 ioi rrc (hl)                   ; D3 CB 0E
 ioi rrc (ix)                   ; D3 DD CB 00 0E
 ioi rrc (ix+127)               ; D3 DD CB 7F 0E
 ioi rrc (ix-128)               ; D3 DD CB 80 0E
 ioi rrc (iy)                   ; D3 FD CB 00 0E
 ioi rrc (iy+127)               ; D3 FD CB 7F 0E
 ioi rrc (iy-128)               ; D3 FD CB 80 0E
 ioi sbc (hl)                   ; D3 9E
 ioi sbc (hl+)                  ; D3 9E 23
 ioi sbc (hl-)                  ; D3 9E 2B
 ioi sbc (ix)                   ; D3 DD 9E 00
 ioi sbc (ix+127)               ; D3 DD 9E 7F
 ioi sbc (ix-128)               ; D3 DD 9E 80
 ioi sbc (iy)                   ; D3 FD 9E 00
 ioi sbc (iy+127)               ; D3 FD 9E 7F
 ioi sbc (iy-128)               ; D3 FD 9E 80
 ioi sbc a', (hl)               ; D3 76 9E
 ioi sbc a', (hl+)              ; D3 76 9E 23
 ioi sbc a', (hl-)              ; D3 76 9E 2B
 ioi sbc a', (ix)               ; D3 76 DD 9E 00
 ioi sbc a', (ix+127)           ; D3 76 DD 9E 7F
 ioi sbc a', (ix-128)           ; D3 76 DD 9E 80
 ioi sbc a', (iy)               ; D3 76 FD 9E 00
 ioi sbc a', (iy+127)           ; D3 76 FD 9E 7F
 ioi sbc a', (iy-128)           ; D3 76 FD 9E 80
 ioi sbc a, (hl)                ; D3 9E
 ioi sbc a, (hl+)               ; D3 9E 23
 ioi sbc a, (hl-)               ; D3 9E 2B
 ioi sbc a, (ix)                ; D3 DD 9E 00
 ioi sbc a, (ix+127)            ; D3 DD 9E 7F
 ioi sbc a, (ix-128)            ; D3 DD 9E 80
 ioi sbc a, (iy)                ; D3 FD 9E 00
 ioi sbc a, (iy+127)            ; D3 FD 9E 7F
 ioi sbc a, (iy-128)            ; D3 FD 9E 80
 ioi set 0, (hl)                ; D3 CB C6
 ioi set 0, (ix)                ; D3 DD CB 00 C6
 ioi set 0, (ix+127)            ; D3 DD CB 7F C6
 ioi set 0, (ix-128)            ; D3 DD CB 80 C6
 ioi set 0, (iy)                ; D3 FD CB 00 C6
 ioi set 0, (iy+127)            ; D3 FD CB 7F C6
 ioi set 0, (iy-128)            ; D3 FD CB 80 C6
 ioi set 1, (hl)                ; D3 CB CE
 ioi set 1, (ix)                ; D3 DD CB 00 CE
 ioi set 1, (ix+127)            ; D3 DD CB 7F CE
 ioi set 1, (ix-128)            ; D3 DD CB 80 CE
 ioi set 1, (iy)                ; D3 FD CB 00 CE
 ioi set 1, (iy+127)            ; D3 FD CB 7F CE
 ioi set 1, (iy-128)            ; D3 FD CB 80 CE
 ioi set 2, (hl)                ; D3 CB D6
 ioi set 2, (ix)                ; D3 DD CB 00 D6
 ioi set 2, (ix+127)            ; D3 DD CB 7F D6
 ioi set 2, (ix-128)            ; D3 DD CB 80 D6
 ioi set 2, (iy)                ; D3 FD CB 00 D6
 ioi set 2, (iy+127)            ; D3 FD CB 7F D6
 ioi set 2, (iy-128)            ; D3 FD CB 80 D6
 ioi set 3, (hl)                ; D3 CB DE
 ioi set 3, (ix)                ; D3 DD CB 00 DE
 ioi set 3, (ix+127)            ; D3 DD CB 7F DE
 ioi set 3, (ix-128)            ; D3 DD CB 80 DE
 ioi set 3, (iy)                ; D3 FD CB 00 DE
 ioi set 3, (iy+127)            ; D3 FD CB 7F DE
 ioi set 3, (iy-128)            ; D3 FD CB 80 DE
 ioi set 4, (hl)                ; D3 CB E6
 ioi set 4, (ix)                ; D3 DD CB 00 E6
 ioi set 4, (ix+127)            ; D3 DD CB 7F E6
 ioi set 4, (ix-128)            ; D3 DD CB 80 E6
 ioi set 4, (iy)                ; D3 FD CB 00 E6
 ioi set 4, (iy+127)            ; D3 FD CB 7F E6
 ioi set 4, (iy-128)            ; D3 FD CB 80 E6
 ioi set 5, (hl)                ; D3 CB EE
 ioi set 5, (ix)                ; D3 DD CB 00 EE
 ioi set 5, (ix+127)            ; D3 DD CB 7F EE
 ioi set 5, (ix-128)            ; D3 DD CB 80 EE
 ioi set 5, (iy)                ; D3 FD CB 00 EE
 ioi set 5, (iy+127)            ; D3 FD CB 7F EE
 ioi set 5, (iy-128)            ; D3 FD CB 80 EE
 ioi set 6, (hl)                ; D3 CB F6
 ioi set 6, (ix)                ; D3 DD CB 00 F6
 ioi set 6, (ix+127)            ; D3 DD CB 7F F6
 ioi set 6, (ix-128)            ; D3 DD CB 80 F6
 ioi set 6, (iy)                ; D3 FD CB 00 F6
 ioi set 6, (iy+127)            ; D3 FD CB 7F F6
 ioi set 6, (iy-128)            ; D3 FD CB 80 F6
 ioi set 7, (hl)                ; D3 CB FE
 ioi set 7, (ix)                ; D3 DD CB 00 FE
 ioi set 7, (ix+127)            ; D3 DD CB 7F FE
 ioi set 7, (ix-128)            ; D3 DD CB 80 FE
 ioi set 7, (iy)                ; D3 FD CB 00 FE
 ioi set 7, (iy+127)            ; D3 FD CB 7F FE
 ioi set 7, (iy-128)            ; D3 FD CB 80 FE
 ioi sla (hl)                   ; D3 CB 26
 ioi sla (ix)                   ; D3 DD CB 00 26
 ioi sla (ix+127)               ; D3 DD CB 7F 26
 ioi sla (ix-128)               ; D3 DD CB 80 26
 ioi sla (iy)                   ; D3 FD CB 00 26
 ioi sla (iy+127)               ; D3 FD CB 7F 26
 ioi sla (iy-128)               ; D3 FD CB 80 26
 ioi sra (hl)                   ; D3 CB 2E
 ioi sra (ix)                   ; D3 DD CB 00 2E
 ioi sra (ix+127)               ; D3 DD CB 7F 2E
 ioi sra (ix-128)               ; D3 DD CB 80 2E
 ioi sra (iy)                   ; D3 FD CB 00 2E
 ioi sra (iy+127)               ; D3 FD CB 7F 2E
 ioi sra (iy-128)               ; D3 FD CB 80 2E
 ioi srl (hl)                   ; D3 CB 3E
 ioi srl (ix)                   ; D3 DD CB 00 3E
 ioi srl (ix+127)               ; D3 DD CB 7F 3E
 ioi srl (ix-128)               ; D3 DD CB 80 3E
 ioi srl (iy)                   ; D3 FD CB 00 3E
 ioi srl (iy+127)               ; D3 FD CB 7F 3E
 ioi srl (iy-128)               ; D3 FD CB 80 3E
 ioi sub (hl)                   ; D3 96
 ioi sub (hl+)                  ; D3 96 23
 ioi sub (hl-)                  ; D3 96 2B
 ioi sub (ix)                   ; D3 DD 96 00
 ioi sub (ix+127)               ; D3 DD 96 7F
 ioi sub (ix-128)               ; D3 DD 96 80
 ioi sub (iy)                   ; D3 FD 96 00
 ioi sub (iy+127)               ; D3 FD 96 7F
 ioi sub (iy-128)               ; D3 FD 96 80
 ioi sub a', (hl)               ; D3 76 96
 ioi sub a', (hl+)              ; D3 76 96 23
 ioi sub a', (hl-)              ; D3 76 96 2B
 ioi sub a', (ix)               ; D3 76 DD 96 00
 ioi sub a', (ix+127)           ; D3 76 DD 96 7F
 ioi sub a', (ix-128)           ; D3 76 DD 96 80
 ioi sub a', (iy)               ; D3 76 FD 96 00
 ioi sub a', (iy+127)           ; D3 76 FD 96 7F
 ioi sub a', (iy-128)           ; D3 76 FD 96 80
 ioi sub a, (hl)                ; D3 96
 ioi sub a, (hl+)               ; D3 96 23
 ioi sub a, (hl-)               ; D3 96 2B
 ioi sub a, (ix)                ; D3 DD 96 00
 ioi sub a, (ix+127)            ; D3 DD 96 7F
 ioi sub a, (ix-128)            ; D3 DD 96 80
 ioi sub a, (iy)                ; D3 FD 96 00
 ioi sub a, (iy+127)            ; D3 FD 96 7F
 ioi sub a, (iy-128)            ; D3 FD 96 80
 ioi xor (hl)                   ; D3 AE
 ioi xor (hl+)                  ; D3 AE 23
 ioi xor (hl-)                  ; D3 AE 2B
 ioi xor (ix)                   ; D3 DD AE 00
 ioi xor (ix+127)               ; D3 DD AE 7F
 ioi xor (ix-128)               ; D3 DD AE 80
 ioi xor (iy)                   ; D3 FD AE 00
 ioi xor (iy+127)               ; D3 FD AE 7F
 ioi xor (iy-128)               ; D3 FD AE 80
 ioi xor a', (hl)               ; D3 76 AE
 ioi xor a', (hl+)              ; D3 76 AE 23
 ioi xor a', (hl-)              ; D3 76 AE 2B
 ioi xor a', (ix)               ; D3 76 DD AE 00
 ioi xor a', (ix+127)           ; D3 76 DD AE 7F
 ioi xor a', (ix-128)           ; D3 76 DD AE 80
 ioi xor a', (iy)               ; D3 76 FD AE 00
 ioi xor a', (iy+127)           ; D3 76 FD AE 7F
 ioi xor a', (iy-128)           ; D3 76 FD AE 80
 ioi xor a, (hl)                ; D3 AE
 ioi xor a, (hl+)               ; D3 AE 23
 ioi xor a, (hl-)               ; D3 AE 2B
 ioi xor a, (ix)                ; D3 DD AE 00
 ioi xor a, (ix+127)            ; D3 DD AE 7F
 ioi xor a, (ix-128)            ; D3 DD AE 80
 ioi xor a, (iy)                ; D3 FD AE 00
 ioi xor a, (iy+127)            ; D3 FD AE 7F
 ioi xor a, (iy-128)            ; D3 FD AE 80
 ipres                          ; ED 5D
 ipset 0                        ; ED 46
 ipset 1                        ; ED 56
 ipset 2                        ; ED 4E
 ipset 3                        ; ED 5E
 j_c -32768                     ; DA 00 80
 j_c 32767                      ; DA FF 7F
 j_c 65535                      ; DA FF FF
 j_lo -32768                    ; EA 00 80
 j_lo 32767                     ; EA FF 7F
 j_lo 65535                     ; EA FF FF
 j_lz -32768                    ; E2 00 80
 j_lz 32767                     ; E2 FF 7F
 j_lz 65535                     ; E2 FF FF
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
 jlo -32768                     ; EA 00 80
 jlo 32767                      ; EA FF 7F
 jlo 65535                      ; EA FF FF
 jlz -32768                     ; E2 00 80
 jlz 32767                      ; E2 FF 7F
 jlz 65535                      ; E2 FF FF
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
 jp (ix)                        ; DD E9
 jp (iy)                        ; FD E9
 jp -32768                      ; C3 00 80
 jp 32767                       ; C3 FF 7F
 jp 65535                       ; C3 FF FF
 jp c, -32768                   ; DA 00 80
 jp c, 32767                    ; DA FF 7F
 jp c, 65535                    ; DA FF FF
 jp lo, -32768                  ; EA 00 80
 jp lo, 32767                   ; EA FF 7F
 jp lo, 65535                   ; EA FF FF
 jp lz, -32768                  ; E2 00 80
 jp lz, 32767                   ; E2 FF 7F
 jp lz, 65535                   ; E2 FF FF
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
 ld (hl), bc                    ; 71 23 70 2B
 ld (hl), c                     ; 71
 ld (hl), d                     ; 72
 ld (hl), de                    ; 73 23 72 2B
 ld (hl), e                     ; 73
 ld (hl), h                     ; 74
 ld (hl), hl                    ; DD F4 00
 ld (hl), l                     ; 75
 ld (hl+), -128                 ; 36 80 23
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
 ld (hl+), l                    ; 75 23
 ld (hl+127), hl                ; DD F4 7F
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
 ld (hl-128), hl                ; DD F4 80
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
 ld (ix), c                     ; DD 71 00
 ld (ix), d                     ; DD 72 00
 ld (ix), e                     ; DD 73 00
 ld (ix), h                     ; DD 74 00
 ld (ix), hl                    ; F4 00
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
 ld (ix+127), hl                ; F4 7F
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
 ld (ix-128), hl                ; F4 80
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
 ld (iy), hl                    ; FD F4 00
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
 ld (iy+127), hl                ; FD F4 7F
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
 ld (iy-128), hl                ; FD F4 80
 ld (iy-128), l                 ; FD 75 80
 ld (sp), hl                    ; D4 00
 ld (sp), ix                    ; DD D4 00
 ld (sp), iy                    ; FD D4 00
 ld (sp+0), hl                  ; D4 00
 ld (sp+0), ix                  ; DD D4 00
 ld (sp+0), iy                  ; FD D4 00
 ld (sp+255), hl                ; D4 FF
 ld (sp+255), ix                ; DD D4 FF
 ld (sp+255), iy                ; FD D4 FF
 ld a', (-32768)                ; 76 3A 00 80
 ld a', (32767)                 ; 76 3A FF 7F
 ld a', (65535)                 ; 76 3A FF FF
 ld a', (bc)                    ; 76 0A
 ld a', (bc+)                   ; 76 0A 03
 ld a', (bc-)                   ; 76 0A 0B
 ld a', (de)                    ; 76 1A
 ld a', (de+)                   ; 76 1A 13
 ld a', (de-)                   ; 76 1A 1B
 ld a', (hl)                    ; 76 7E
 ld a', (hl+)                   ; 76 7E 23
 ld a', (hl-)                   ; 76 7E 2B
 ld a', (hld)                   ; 76 7E 2B
 ld a', (hli)                   ; 76 7E 23
 ld a', (ix)                    ; 76 DD 7E 00
 ld a', (ix+127)                ; 76 DD 7E 7F
 ld a', (ix-128)                ; 76 DD 7E 80
 ld a', (iy)                    ; 76 FD 7E 00
 ld a', (iy+127)                ; 76 FD 7E 7F
 ld a', (iy-128)                ; 76 FD 7E 80
 ld a', -128                    ; 76 3E 80
 ld a', 127                     ; 76 3E 7F
 ld a', 255                     ; 76 3E FF
 ld a', a                       ; 76 7F
 ld a', b                       ; 76 78
 ld a', c                       ; 76 79
 ld a', d                       ; 76 7A
 ld a', e                       ; 76 7B
 ld a', eir                     ; 76 ED 57
 ld a', h                       ; 76 7C
 ld a', iir                     ; 76 ED 5F
 ld a', l                       ; 76 7D
 ld a', xpc                     ; 76 ED 77
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
 ld a, eir                      ; ED 57
 ld a, h                        ; 7C
 ld a, iir                      ; ED 5F
 ld a, l                        ; 7D
 ld a, xpc                      ; ED 77
 ld b', (hl)                    ; 76 46
 ld b', (hl+)                   ; 76 46 23
 ld b', (hl-)                   ; 76 46 2B
 ld b', (hld)                   ; 76 46 2B
 ld b', (hli)                   ; 76 46 23
 ld b', (ix)                    ; 76 DD 46 00
 ld b', (ix+127)                ; 76 DD 46 7F
 ld b', (ix-128)                ; 76 DD 46 80
 ld b', (iy)                    ; 76 FD 46 00
 ld b', (iy+127)                ; 76 FD 46 7F
 ld b', (iy-128)                ; 76 FD 46 80
 ld b', -128                    ; 76 06 80
 ld b', 127                     ; 76 06 7F
 ld b', 255                     ; 76 06 FF
 ld b', a                       ; 76 47
 ld b', b                       ; 76 40
 ld b', c                       ; 76 41
 ld b', d                       ; 76 42
 ld b', e                       ; 76 43
 ld b', h                       ; 76 44
 ld b', l                       ; 76 45
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
 ld b, b                        ; 40
 ld b, c                        ; 41
 ld b, d                        ; 42
 ld b, e                        ; 43
 ld b, h                        ; 44
 ld b, l                        ; 45
 ld bc', (-32768)               ; 76 ED 4B 00 80
 ld bc', (32767)                ; 76 ED 4B FF 7F
 ld bc', (65535)                ; 76 ED 4B FF FF
 ld bc', -32768                 ; 76 01 00 80
 ld bc', 32767                  ; 76 01 FF 7F
 ld bc', 65535                  ; 76 01 FF FF
 ld bc', bc                     ; ED 49
 ld bc', de                     ; ED 41
 ld bc, (-32768)                ; ED 4B 00 80
 ld bc, (32767)                 ; ED 4B FF 7F
 ld bc, (65535)                 ; ED 4B FF FF
 ld bc, -32768                  ; 01 00 80
 ld bc, 32767                   ; 01 FF 7F
 ld bc, 65535                   ; 01 FF FF
 ld bc, de                      ; 42 4B
 ld bc, hl                      ; 44 4D
 ld c', (hl)                    ; 76 4E
 ld c', (hl+)                   ; 76 4E 23
 ld c', (hl-)                   ; 76 4E 2B
 ld c', (hld)                   ; 76 4E 2B
 ld c', (hli)                   ; 76 4E 23
 ld c', (ix)                    ; 76 DD 4E 00
 ld c', (ix+127)                ; 76 DD 4E 7F
 ld c', (ix-128)                ; 76 DD 4E 80
 ld c', (iy)                    ; 76 FD 4E 00
 ld c', (iy+127)                ; 76 FD 4E 7F
 ld c', (iy-128)                ; 76 FD 4E 80
 ld c', -128                    ; 76 0E 80
 ld c', 127                     ; 76 0E 7F
 ld c', 255                     ; 76 0E FF
 ld c', a                       ; 76 4F
 ld c', b                       ; 76 48
 ld c', c                       ; 76 49
 ld c', d                       ; 76 4A
 ld c', e                       ; 76 4B
 ld c', h                       ; 76 4C
 ld c', l                       ; 76 4D
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
 ld c, c                        ; 49
 ld c, d                        ; 4A
 ld c, e                        ; 4B
 ld c, h                        ; 4C
 ld c, l                        ; 4D
 ld d', (hl)                    ; 76 56
 ld d', (hl+)                   ; 76 56 23
 ld d', (hl-)                   ; 76 56 2B
 ld d', (hld)                   ; 76 56 2B
 ld d', (hli)                   ; 76 56 23
 ld d', (ix)                    ; 76 DD 56 00
 ld d', (ix+127)                ; 76 DD 56 7F
 ld d', (ix-128)                ; 76 DD 56 80
 ld d', (iy)                    ; 76 FD 56 00
 ld d', (iy+127)                ; 76 FD 56 7F
 ld d', (iy-128)                ; 76 FD 56 80
 ld d', -128                    ; 76 16 80
 ld d', 127                     ; 76 16 7F
 ld d', 255                     ; 76 16 FF
 ld d', a                       ; 76 57
 ld d', b                       ; 76 50
 ld d', c                       ; 76 51
 ld d', d                       ; 76 52
 ld d', e                       ; 76 53
 ld d', h                       ; 76 54
 ld d', l                       ; 76 55
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
 ld d, d                        ; 52
 ld d, e                        ; 53
 ld d, h                        ; 54
 ld d, l                        ; 55
 ld de', (-32768)               ; 76 ED 5B 00 80
 ld de', (32767)                ; 76 ED 5B FF 7F
 ld de', (65535)                ; 76 ED 5B FF FF
 ld de', -32768                 ; 76 11 00 80
 ld de', 32767                  ; 76 11 FF 7F
 ld de', 65535                  ; 76 11 FF FF
 ld de', bc                     ; ED 59
 ld de', de                     ; ED 51
 ld de, (-32768)                ; ED 5B 00 80
 ld de, (32767)                 ; ED 5B FF 7F
 ld de, (65535)                 ; ED 5B FF FF
 ld de, -32768                  ; 11 00 80
 ld de, 32767                   ; 11 FF 7F
 ld de, 65535                   ; 11 FF FF
 ld de, bc                      ; 50 59
 ld de, hl                      ; 54 5D
 ld de, sp                      ; EB 21 00 00 39 EB
 ld de, sp+0                    ; EB 21 00 00 39 EB
 ld de, sp+255                  ; EB 21 FF 00 39 EB
 ld e', (hl)                    ; 76 5E
 ld e', (hl+)                   ; 76 5E 23
 ld e', (hl-)                   ; 76 5E 2B
 ld e', (hld)                   ; 76 5E 2B
 ld e', (hli)                   ; 76 5E 23
 ld e', (ix)                    ; 76 DD 5E 00
 ld e', (ix+127)                ; 76 DD 5E 7F
 ld e', (ix-128)                ; 76 DD 5E 80
 ld e', (iy)                    ; 76 FD 5E 00
 ld e', (iy+127)                ; 76 FD 5E 7F
 ld e', (iy-128)                ; 76 FD 5E 80
 ld e', -128                    ; 76 1E 80
 ld e', 127                     ; 76 1E 7F
 ld e', 255                     ; 76 1E FF
 ld e', a                       ; 76 5F
 ld e', b                       ; 76 58
 ld e', c                       ; 76 59
 ld e', d                       ; 76 5A
 ld e', e                       ; 76 5B
 ld e', h                       ; 76 5C
 ld e', l                       ; 76 5D
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
 ld e, e                        ; 5B
 ld e, h                        ; 5C
 ld e, l                        ; 5D
 ld eir, a                      ; ED 47
 ld h', (hl)                    ; 76 66
 ld h', (hl+)                   ; 76 66 23
 ld h', (hl-)                   ; 76 66 2B
 ld h', (hld)                   ; 76 66 2B
 ld h', (hli)                   ; 76 66 23
 ld h', (ix)                    ; 76 DD 66 00
 ld h', (ix+127)                ; 76 DD 66 7F
 ld h', (ix-128)                ; 76 DD 66 80
 ld h', (iy)                    ; 76 FD 66 00
 ld h', (iy+127)                ; 76 FD 66 7F
 ld h', (iy-128)                ; 76 FD 66 80
 ld h', -128                    ; 76 26 80
 ld h', 127                     ; 76 26 7F
 ld h', 255                     ; 76 26 FF
 ld h', a                       ; 76 67
 ld h', b                       ; 76 60
 ld h', c                       ; 76 61
 ld h', d                       ; 76 62
 ld h', e                       ; 76 63
 ld h', h                       ; 76 64
 ld h', l                       ; 76 65
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
 ld hl', (-32768)               ; 76 2A 00 80
 ld hl', (32767)                ; 76 2A FF 7F
 ld hl', (65535)                ; 76 2A FF FF
 ld hl', (hl)                   ; 76 DD E4 00
 ld hl', (hl+127)               ; 76 DD E4 7F
 ld hl', (hl-128)               ; 76 DD E4 80
 ld hl', (ix)                   ; 76 E4 00
 ld hl', (ix+127)               ; 76 E4 7F
 ld hl', (ix-128)               ; 76 E4 80
 ld hl', (iy)                   ; 76 FD E4 00
 ld hl', (iy+127)               ; 76 FD E4 7F
 ld hl', (iy-128)               ; 76 FD E4 80
 ld hl', (sp)                   ; 76 C4 00
 ld hl', (sp+0)                 ; 76 C4 00
 ld hl', (sp+255)               ; 76 C4 FF
 ld hl', -32768                 ; 76 21 00 80
 ld hl', 32767                  ; 76 21 FF 7F
 ld hl', 65535                  ; 76 21 FF FF
 ld hl', bc                     ; ED 69
 ld hl', de                     ; ED 61
 ld hl', ix                     ; 76 DD 7C
 ld hl', iy                     ; 76 FD 7C
 ld hl, (-32768)                ; 2A 00 80
 ld hl, (32767)                 ; 2A FF 7F
 ld hl, (65535)                 ; 2A FF FF
 ld hl, (hl)                    ; DD E4 00
 ld hl, (hl+127)                ; DD E4 7F
 ld hl, (hl-128)                ; DD E4 80
 ld hl, (ix)                    ; E4 00
 ld hl, (ix+127)                ; E4 7F
 ld hl, (ix-128)                ; E4 80
 ld hl, (iy)                    ; FD E4 00
 ld hl, (iy+127)                ; FD E4 7F
 ld hl, (iy-128)                ; FD E4 80
 ld hl, (sp)                    ; C4 00
 ld hl, (sp+0)                  ; C4 00
 ld hl, (sp+255)                ; C4 FF
 ld hl, -32768                  ; 21 00 80
 ld hl, 32767                   ; 21 FF 7F
 ld hl, 65535                   ; 21 FF FF
 ld hl, bc                      ; 60 69
 ld hl, de                      ; 62 6B
 ld hl, ix                      ; DD 7C
 ld hl, iy                      ; FD 7C
 ld hl, sp                      ; 21 00 00 39
 ld hl, sp+127                  ; 21 7F 00 39
 ld hl, sp-128                  ; 21 80 FF 39
 ld iir, a                      ; ED 4F
 ld ix, (-32768)                ; DD 2A 00 80
 ld ix, (32767)                 ; DD 2A FF 7F
 ld ix, (65535)                 ; DD 2A FF FF
 ld ix, (sp)                    ; DD C4 00
 ld ix, (sp+0)                  ; DD C4 00
 ld ix, (sp+255)                ; DD C4 FF
 ld ix, -32768                  ; DD 21 00 80
 ld ix, 32767                   ; DD 21 FF 7F
 ld ix, 65535                   ; DD 21 FF FF
 ld ix, hl                      ; DD 7D
 ld iy, (-32768)                ; FD 2A 00 80
 ld iy, (32767)                 ; FD 2A FF 7F
 ld iy, (65535)                 ; FD 2A FF FF
 ld iy, (sp)                    ; FD C4 00
 ld iy, (sp+0)                  ; FD C4 00
 ld iy, (sp+255)                ; FD C4 FF
 ld iy, -32768                  ; FD 21 00 80
 ld iy, 32767                   ; FD 21 FF 7F
 ld iy, 65535                   ; FD 21 FF FF
 ld iy, hl                      ; FD 7D
 ld l', (hl)                    ; 76 6E
 ld l', (hl+)                   ; 76 6E 23
 ld l', (hl-)                   ; 76 6E 2B
 ld l', (hld)                   ; 76 6E 2B
 ld l', (hli)                   ; 76 6E 23
 ld l', (ix)                    ; 76 DD 6E 00
 ld l', (ix+127)                ; 76 DD 6E 7F
 ld l', (ix-128)                ; 76 DD 6E 80
 ld l', (iy)                    ; 76 FD 6E 00
 ld l', (iy+127)                ; 76 FD 6E 7F
 ld l', (iy-128)                ; 76 FD 6E 80
 ld l', -128                    ; 76 2E 80
 ld l', 127                     ; 76 2E 7F
 ld l', 255                     ; 76 2E FF
 ld l', a                       ; 76 6F
 ld l', b                       ; 76 68
 ld l', c                       ; 76 69
 ld l', d                       ; 76 6A
 ld l', e                       ; 76 6B
 ld l', h                       ; 76 6C
 ld l', l                       ; 76 6D
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
 ld sp, (-32768)                ; ED 7B 00 80
 ld sp, (32767)                 ; ED 7B FF 7F
 ld sp, (65535)                 ; ED 7B FF FF
 ld sp, -32768                  ; 31 00 80
 ld sp, 32767                   ; 31 FF 7F
 ld sp, 65535                   ; 31 FF FF
 ld sp, hl                      ; F9
 ld sp, ix                      ; DD F9
 ld sp, iy                      ; FD F9
 ld xpc, a                      ; ED 67
 lda -32768                     ; 3A 00 80
 lda 32767                      ; 3A FF 7F
 lda 65535                      ; 3A FF FF
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
 lddr                           ; ED B8
 lddsr                          ; ED 98
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
 ldi (hl), bc                   ; 71 23 70 23
 ldi (hl), c                    ; 71 23
 ldi (hl), d                    ; 72 23
 ldi (hl), de                   ; 73 23 72 23
 ldi (hl), e                    ; 73 23
 ldi (hl), h                    ; 74 23
 ldi (hl), l                    ; 75 23
 ldi a, (bc)                    ; 0A 03
 ldi a, (de)                    ; 1A 13
 ldi a, (hl)                    ; 7E 23
 ldi b, (de)                    ; EB 46 EB 13
 ldi b, (hl)                    ; 46 23
 ldi c, (de)                    ; EB 4E EB 13
 ldi c, (hl)                    ; 4E 23
 ldi d, (de)                    ; EB 66 EB 13
 ldi d, (hl)                    ; 56 23
 ldi e, (de)                    ; EB 6E EB 13
 ldi e, (hl)                    ; 5E 23
 ldi h, (de)                    ; EB 56 EB 13
 ldi h, (hl)                    ; 66 23
 ldi l, (de)                    ; EB 5E EB 13
 ldi l, (hl)                    ; 6E 23
 ldir                           ; ED B0
 ldisr                          ; ED 90
 ldp (-32768), hl               ; ED 65 00 80
 ldp (-32768), ix               ; DD 65 00 80
 ldp (-32768), iy               ; FD 65 00 80
 ldp (32767), hl                ; ED 65 FF 7F
 ldp (32767), ix                ; DD 65 FF 7F
 ldp (32767), iy                ; FD 65 FF 7F
 ldp (65535), hl                ; ED 65 FF FF
 ldp (65535), ix                ; DD 65 FF FF
 ldp (65535), iy                ; FD 65 FF FF
 ldp (hl), hl                   ; ED 64
 ldp (ix), hl                   ; DD 64
 ldp (iy), hl                   ; FD 64
 ldp hl, (-32768)               ; ED 6D 00 80
 ldp hl, (32767)                ; ED 6D FF 7F
 ldp hl, (65535)                ; ED 6D FF FF
 ldp hl, (hl)                   ; ED 6C
 ldp hl, (ix)                   ; DD 6C
 ldp hl, (iy)                   ; FD 6C
 ldp ix, (-32768)               ; DD 6D 00 80
 ldp ix, (32767)                ; DD 6D FF 7F
 ldp ix, (65535)                ; DD 6D FF FF
 ldp iy, (-32768)               ; FD 6D 00 80
 ldp iy, (32767)                ; FD 6D FF 7F
 ldp iy, (65535)                ; FD 6D FF FF
 lhld -32768                    ; 2A 00 80
 lhld 32767                     ; 2A FF 7F
 lhld 65535                     ; 2A FF FF
 lsddr                          ; ED D8
 lsdr                           ; ED F8
 lsidr                          ; ED D0
 lsir                           ; ED F0
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
 mul                            ; F7
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
 neg a'                         ; 76 ED 44
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
 or a', (hl)                    ; 76 B6
 or a', (hl+)                   ; 76 B6 23
 or a', (hl-)                   ; 76 B6 2B
 or a', (ix)                    ; 76 DD B6 00
 or a', (ix+127)                ; 76 DD B6 7F
 or a', (ix-128)                ; 76 DD B6 80
 or a', (iy)                    ; 76 FD B6 00
 or a', (iy+127)                ; 76 FD B6 7F
 or a', (iy-128)                ; 76 FD B6 80
 or a', -128                    ; 76 F6 80
 or a', 127                     ; 76 F6 7F
 or a', 255                     ; 76 F6 FF
 or a', a                       ; 76 B7
 or a', b                       ; 76 B0
 or a', c                       ; 76 B1
 or a', d                       ; 76 B2
 or a', e                       ; 76 B3
 or a', h                       ; 76 B4
 or a', l                       ; 76 B5
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
 or a, l                        ; B5
 or b                           ; B0
 or c                           ; B1
 or d                           ; B2
 or e                           ; B3
 or h                           ; B4
 or hl', de                     ; 76 EC
 or hl, de                      ; EC
 or ix, de                      ; DD EC
 or iy, de                      ; FD EC
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
 ori 127                        ; F6 7F
 ori 255                        ; F6 FF
 pchl                           ; E9
 pop af                         ; F1
 pop af'                        ; 76 F1
 pop b                          ; C1
 pop bc                         ; C1
 pop bc'                        ; 76 C1
 pop d                          ; D1
 pop de                         ; D1
 pop de'                        ; 76 D1
 pop h                          ; E1
 pop hl                         ; E1
 pop hl'                        ; 76 E1
 pop ip                         ; ED 7E
 pop ix                         ; DD E1
 pop iy                         ; FD E1
 pop psw                        ; F1
 pop su                         ; ED 6E
 push af                        ; F5
 push b                         ; C5
 push bc                        ; C5
 push d                         ; D5
 push de                        ; D5
 push h                         ; E5
 push hl                        ; E5
 push ip                        ; ED 76
 push ix                        ; DD E5
 push iy                        ; FD E5
 push psw                       ; F5
 push su                        ; ED 66
 r_c                            ; D8
 r_lo                           ; E8
 r_lz                           ; E0
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
 rdel                           ; F3
 rdmode                         ; ED 7F
 res 0, (hl)                    ; CB 86
 res 0, (ix)                    ; DD CB 00 86
 res 0, (ix+127)                ; DD CB 7F 86
 res 0, (ix-128)                ; DD CB 80 86
 res 0, (iy)                    ; FD CB 00 86
 res 0, (iy+127)                ; FD CB 7F 86
 res 0, (iy-128)                ; FD CB 80 86
 res 0, a                       ; CB 87
 res 0, a'                      ; 76 CB 87
 res 0, b                       ; CB 80
 res 0, b'                      ; 76 CB 80
 res 0, c                       ; CB 81
 res 0, c'                      ; 76 CB 81
 res 0, d                       ; CB 82
 res 0, d'                      ; 76 CB 82
 res 0, e                       ; CB 83
 res 0, e'                      ; 76 CB 83
 res 0, h                       ; CB 84
 res 0, h'                      ; 76 CB 84
 res 0, l                       ; CB 85
 res 0, l'                      ; 76 CB 85
 res 1, (hl)                    ; CB 8E
 res 1, (ix)                    ; DD CB 00 8E
 res 1, (ix+127)                ; DD CB 7F 8E
 res 1, (ix-128)                ; DD CB 80 8E
 res 1, (iy)                    ; FD CB 00 8E
 res 1, (iy+127)                ; FD CB 7F 8E
 res 1, (iy-128)                ; FD CB 80 8E
 res 1, a                       ; CB 8F
 res 1, a'                      ; 76 CB 8F
 res 1, b                       ; CB 88
 res 1, b'                      ; 76 CB 88
 res 1, c                       ; CB 89
 res 1, c'                      ; 76 CB 89
 res 1, d                       ; CB 8A
 res 1, d'                      ; 76 CB 8A
 res 1, e                       ; CB 8B
 res 1, e'                      ; 76 CB 8B
 res 1, h                       ; CB 8C
 res 1, h'                      ; 76 CB 8C
 res 1, l                       ; CB 8D
 res 1, l'                      ; 76 CB 8D
 res 2, (hl)                    ; CB 96
 res 2, (ix)                    ; DD CB 00 96
 res 2, (ix+127)                ; DD CB 7F 96
 res 2, (ix-128)                ; DD CB 80 96
 res 2, (iy)                    ; FD CB 00 96
 res 2, (iy+127)                ; FD CB 7F 96
 res 2, (iy-128)                ; FD CB 80 96
 res 2, a                       ; CB 97
 res 2, a'                      ; 76 CB 97
 res 2, b                       ; CB 90
 res 2, b'                      ; 76 CB 90
 res 2, c                       ; CB 91
 res 2, c'                      ; 76 CB 91
 res 2, d                       ; CB 92
 res 2, d'                      ; 76 CB 92
 res 2, e                       ; CB 93
 res 2, e'                      ; 76 CB 93
 res 2, h                       ; CB 94
 res 2, h'                      ; 76 CB 94
 res 2, l                       ; CB 95
 res 2, l'                      ; 76 CB 95
 res 3, (hl)                    ; CB 9E
 res 3, (ix)                    ; DD CB 00 9E
 res 3, (ix+127)                ; DD CB 7F 9E
 res 3, (ix-128)                ; DD CB 80 9E
 res 3, (iy)                    ; FD CB 00 9E
 res 3, (iy+127)                ; FD CB 7F 9E
 res 3, (iy-128)                ; FD CB 80 9E
 res 3, a                       ; CB 9F
 res 3, a'                      ; 76 CB 9F
 res 3, b                       ; CB 98
 res 3, b'                      ; 76 CB 98
 res 3, c                       ; CB 99
 res 3, c'                      ; 76 CB 99
 res 3, d                       ; CB 9A
 res 3, d'                      ; 76 CB 9A
 res 3, e                       ; CB 9B
 res 3, e'                      ; 76 CB 9B
 res 3, h                       ; CB 9C
 res 3, h'                      ; 76 CB 9C
 res 3, l                       ; CB 9D
 res 3, l'                      ; 76 CB 9D
 res 4, (hl)                    ; CB A6
 res 4, (ix)                    ; DD CB 00 A6
 res 4, (ix+127)                ; DD CB 7F A6
 res 4, (ix-128)                ; DD CB 80 A6
 res 4, (iy)                    ; FD CB 00 A6
 res 4, (iy+127)                ; FD CB 7F A6
 res 4, (iy-128)                ; FD CB 80 A6
 res 4, a                       ; CB A7
 res 4, a'                      ; 76 CB A7
 res 4, b                       ; CB A0
 res 4, b'                      ; 76 CB A0
 res 4, c                       ; CB A1
 res 4, c'                      ; 76 CB A1
 res 4, d                       ; CB A2
 res 4, d'                      ; 76 CB A2
 res 4, e                       ; CB A3
 res 4, e'                      ; 76 CB A3
 res 4, h                       ; CB A4
 res 4, h'                      ; 76 CB A4
 res 4, l                       ; CB A5
 res 4, l'                      ; 76 CB A5
 res 5, (hl)                    ; CB AE
 res 5, (ix)                    ; DD CB 00 AE
 res 5, (ix+127)                ; DD CB 7F AE
 res 5, (ix-128)                ; DD CB 80 AE
 res 5, (iy)                    ; FD CB 00 AE
 res 5, (iy+127)                ; FD CB 7F AE
 res 5, (iy-128)                ; FD CB 80 AE
 res 5, a                       ; CB AF
 res 5, a'                      ; 76 CB AF
 res 5, b                       ; CB A8
 res 5, b'                      ; 76 CB A8
 res 5, c                       ; CB A9
 res 5, c'                      ; 76 CB A9
 res 5, d                       ; CB AA
 res 5, d'                      ; 76 CB AA
 res 5, e                       ; CB AB
 res 5, e'                      ; 76 CB AB
 res 5, h                       ; CB AC
 res 5, h'                      ; 76 CB AC
 res 5, l                       ; CB AD
 res 5, l'                      ; 76 CB AD
 res 6, (hl)                    ; CB B6
 res 6, (ix)                    ; DD CB 00 B6
 res 6, (ix+127)                ; DD CB 7F B6
 res 6, (ix-128)                ; DD CB 80 B6
 res 6, (iy)                    ; FD CB 00 B6
 res 6, (iy+127)                ; FD CB 7F B6
 res 6, (iy-128)                ; FD CB 80 B6
 res 6, a                       ; CB B7
 res 6, a'                      ; 76 CB B7
 res 6, b                       ; CB B0
 res 6, b'                      ; 76 CB B0
 res 6, c                       ; CB B1
 res 6, c'                      ; 76 CB B1
 res 6, d                       ; CB B2
 res 6, d'                      ; 76 CB B2
 res 6, e                       ; CB B3
 res 6, e'                      ; 76 CB B3
 res 6, h                       ; CB B4
 res 6, h'                      ; 76 CB B4
 res 6, l                       ; CB B5
 res 6, l'                      ; 76 CB B5
 res 7, (hl)                    ; CB BE
 res 7, (ix)                    ; DD CB 00 BE
 res 7, (ix+127)                ; DD CB 7F BE
 res 7, (ix-128)                ; DD CB 80 BE
 res 7, (iy)                    ; FD CB 00 BE
 res 7, (iy+127)                ; FD CB 7F BE
 res 7, (iy-128)                ; FD CB 80 BE
 res 7, a                       ; CB BF
 res 7, a'                      ; 76 CB BF
 res 7, b                       ; CB B8
 res 7, b'                      ; 76 CB B8
 res 7, c                       ; CB B9
 res 7, c'                      ; 76 CB B9
 res 7, d                       ; CB BA
 res 7, d'                      ; 76 CB BA
 res 7, e                       ; CB BB
 res 7, e'                      ; 76 CB BB
 res 7, h                       ; CB BC
 res 7, h'                      ; 76 CB BC
 res 7, l                       ; CB BD
 res 7, l'                      ; 76 CB BD
 ret                            ; C9
 ret c                          ; D8
 ret lo                         ; E8
 ret lz                         ; E0
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
 rl (hl)                        ; CB 16
 rl (ix)                        ; DD CB 00 16
 rl (ix+127)                    ; DD CB 7F 16
 rl (ix-128)                    ; DD CB 80 16
 rl (iy)                        ; FD CB 00 16
 rl (iy+127)                    ; FD CB 7F 16
 rl (iy-128)                    ; FD CB 80 16
 rl a                           ; CB 17
 rl a'                          ; 76 CB 17
 rl b                           ; CB 10
 rl b'                          ; 76 CB 10
 rl bc                          ; CB 11 CB 10
 rl c                           ; CB 11
 rl c'                          ; 76 CB 11
 rl d                           ; CB 12
 rl d'                          ; 76 CB 12
 rl de                          ; F3
 rl de'                         ; 76 F3
 rl e                           ; CB 13
 rl e'                          ; 76 CB 13
 rl h                           ; CB 14
 rl h'                          ; 76 CB 14
 rl hl                          ; CB 15 CB 14
 rl l                           ; CB 15
 rl l'                          ; 76 CB 15
 rla                            ; 17
 rla'                           ; 76 17
 rlc                            ; 07
 rlc (hl)                       ; CB 06
 rlc (ix)                       ; DD CB 00 06
 rlc (ix+127)                   ; DD CB 7F 06
 rlc (ix-128)                   ; DD CB 80 06
 rlc (iy)                       ; FD CB 00 06
 rlc (iy+127)                   ; FD CB 7F 06
 rlc (iy-128)                   ; FD CB 80 06
 rlc a                          ; CB 07
 rlc a'                         ; 76 CB 07
 rlc b                          ; CB 00
 rlc b'                         ; 76 CB 00
 rlc c                          ; CB 01
 rlc c'                         ; 76 CB 01
 rlc d                          ; CB 02
 rlc d'                         ; 76 CB 02
 rlc e                          ; CB 03
 rlc e'                         ; 76 CB 03
 rlc h                          ; CB 04
 rlc h'                         ; 76 CB 04
 rlc l                          ; CB 05
 rlc l'                         ; 76 CB 05
 rlca                           ; 07
 rlca'                          ; 76 07
 rld                            ; CD @__z80asm__rld
 rlde                           ; F3
 rlo                            ; E8
 rlz                            ; E0
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
 rr a'                          ; 76 CB 1F
 rr b                           ; CB 18
 rr b'                          ; 76 CB 18
 rr bc                          ; CB 18 CB 19
 rr c                           ; CB 19
 rr c'                          ; 76 CB 19
 rr d                           ; CB 1A
 rr d'                          ; 76 CB 1A
 rr de                          ; FB
 rr de'                         ; 76 FB
 rr e                           ; CB 1B
 rr e'                          ; 76 CB 1B
 rr h                           ; CB 1C
 rr h'                          ; 76 CB 1C
 rr hl                          ; FC
 rr hl'                         ; 76 FC
 rr ix                          ; DD FC
 rr iy                          ; FD FC
 rr l                           ; CB 1D
 rr l'                          ; 76 CB 1D
 rra                            ; 1F
 rra'                           ; 76 1F
 rrc                            ; 0F
 rrc (hl)                       ; CB 0E
 rrc (ix)                       ; DD CB 00 0E
 rrc (ix+127)                   ; DD CB 7F 0E
 rrc (ix-128)                   ; DD CB 80 0E
 rrc (iy)                       ; FD CB 00 0E
 rrc (iy+127)                   ; FD CB 7F 0E
 rrc (iy-128)                   ; FD CB 80 0E
 rrc a                          ; CB 0F
 rrc a'                         ; 76 CB 0F
 rrc b                          ; CB 08
 rrc b'                         ; 76 CB 08
 rrc c                          ; CB 09
 rrc c'                         ; 76 CB 09
 rrc d                          ; CB 0A
 rrc d'                         ; 76 CB 0A
 rrc e                          ; CB 0B
 rrc e'                         ; 76 CB 0B
 rrc h                          ; CB 0C
 rrc h'                         ; 76 CB 0C
 rrc l                          ; CB 0D
 rrc l'                         ; 76 CB 0D
 rrca                           ; 0F
 rrca'                          ; 76 0F
 rrd                            ; CD @__z80asm__rrd
 rrhl                           ; CB 2C CB 1D
 rst 0                          ; CD 00 00
 rst 1                          ; CD 08 00
 rst 16                         ; D7
 rst 2                          ; D7
 rst 24                         ; DF
 rst 3                          ; DF
 rst 32                         ; E7
 rst 4                          ; E7
 rst 40                         ; EF
 rst 48                         ; CD 30 00
 rst 5                          ; EF
 rst 56                         ; FF
 rst 6                          ; CD 30 00
 rst 7                          ; FF
 rst 8                          ; CD 08 00
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
 sbc a', (hl)                   ; 76 9E
 sbc a', (hl+)                  ; 76 9E 23
 sbc a', (hl-)                  ; 76 9E 2B
 sbc a', (ix)                   ; 76 DD 9E 00
 sbc a', (ix+127)               ; 76 DD 9E 7F
 sbc a', (ix-128)               ; 76 DD 9E 80
 sbc a', (iy)                   ; 76 FD 9E 00
 sbc a', (iy+127)               ; 76 FD 9E 7F
 sbc a', (iy-128)               ; 76 FD 9E 80
 sbc a', -128                   ; 76 DE 80
 sbc a', 127                    ; 76 DE 7F
 sbc a', 255                    ; 76 DE FF
 sbc a', a                      ; 76 9F
 sbc a', b                      ; 76 98
 sbc a', c                      ; 76 99
 sbc a', d                      ; 76 9A
 sbc a', e                      ; 76 9B
 sbc a', h                      ; 76 9C
 sbc a', l                      ; 76 9D
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
 sbc a, l                       ; 9D
 sbc b                          ; 98
 sbc c                          ; 99
 sbc d                          ; 9A
 sbc e                          ; 9B
 sbc h                          ; 9C
 sbc hl', bc                    ; 76 ED 42
 sbc hl', de                    ; 76 ED 52
 sbc hl', hl                    ; 76 ED 62
 sbc hl', sp                    ; 76 ED 72
 sbc hl, bc                     ; ED 42
 sbc hl, de                     ; ED 52
 sbc hl, hl                     ; ED 62
 sbc hl, sp                     ; ED 72
 sbc l                          ; 9D
 sbi -128                       ; DE 80
 sbi 127                        ; DE 7F
 sbi 255                        ; DE FF
 scf                            ; 37
 scf'                           ; 76 37
 set 0, (hl)                    ; CB C6
 set 0, (ix)                    ; DD CB 00 C6
 set 0, (ix+127)                ; DD CB 7F C6
 set 0, (ix-128)                ; DD CB 80 C6
 set 0, (iy)                    ; FD CB 00 C6
 set 0, (iy+127)                ; FD CB 7F C6
 set 0, (iy-128)                ; FD CB 80 C6
 set 0, a                       ; CB C7
 set 0, a'                      ; 76 CB C7
 set 0, b                       ; CB C0
 set 0, b'                      ; 76 CB C0
 set 0, c                       ; CB C1
 set 0, c'                      ; 76 CB C1
 set 0, d                       ; CB C2
 set 0, d'                      ; 76 CB C2
 set 0, e                       ; CB C3
 set 0, e'                      ; 76 CB C3
 set 0, h                       ; CB C4
 set 0, h'                      ; 76 CB C4
 set 0, l                       ; CB C5
 set 0, l'                      ; 76 CB C5
 set 1, (hl)                    ; CB CE
 set 1, (ix)                    ; DD CB 00 CE
 set 1, (ix+127)                ; DD CB 7F CE
 set 1, (ix-128)                ; DD CB 80 CE
 set 1, (iy)                    ; FD CB 00 CE
 set 1, (iy+127)                ; FD CB 7F CE
 set 1, (iy-128)                ; FD CB 80 CE
 set 1, a                       ; CB CF
 set 1, a'                      ; 76 CB CF
 set 1, b                       ; CB C8
 set 1, b'                      ; 76 CB C8
 set 1, c                       ; CB C9
 set 1, c'                      ; 76 CB C9
 set 1, d                       ; CB CA
 set 1, d'                      ; 76 CB CA
 set 1, e                       ; CB CB
 set 1, e'                      ; 76 CB CB
 set 1, h                       ; CB CC
 set 1, h'                      ; 76 CB CC
 set 1, l                       ; CB CD
 set 1, l'                      ; 76 CB CD
 set 2, (hl)                    ; CB D6
 set 2, (ix)                    ; DD CB 00 D6
 set 2, (ix+127)                ; DD CB 7F D6
 set 2, (ix-128)                ; DD CB 80 D6
 set 2, (iy)                    ; FD CB 00 D6
 set 2, (iy+127)                ; FD CB 7F D6
 set 2, (iy-128)                ; FD CB 80 D6
 set 2, a                       ; CB D7
 set 2, a'                      ; 76 CB D7
 set 2, b                       ; CB D0
 set 2, b'                      ; 76 CB D0
 set 2, c                       ; CB D1
 set 2, c'                      ; 76 CB D1
 set 2, d                       ; CB D2
 set 2, d'                      ; 76 CB D2
 set 2, e                       ; CB D3
 set 2, e'                      ; 76 CB D3
 set 2, h                       ; CB D4
 set 2, h'                      ; 76 CB D4
 set 2, l                       ; CB D5
 set 2, l'                      ; 76 CB D5
 set 3, (hl)                    ; CB DE
 set 3, (ix)                    ; DD CB 00 DE
 set 3, (ix+127)                ; DD CB 7F DE
 set 3, (ix-128)                ; DD CB 80 DE
 set 3, (iy)                    ; FD CB 00 DE
 set 3, (iy+127)                ; FD CB 7F DE
 set 3, (iy-128)                ; FD CB 80 DE
 set 3, a                       ; CB DF
 set 3, a'                      ; 76 CB DF
 set 3, b                       ; CB D8
 set 3, b'                      ; 76 CB D8
 set 3, c                       ; CB D9
 set 3, c'                      ; 76 CB D9
 set 3, d                       ; CB DA
 set 3, d'                      ; 76 CB DA
 set 3, e                       ; CB DB
 set 3, e'                      ; 76 CB DB
 set 3, h                       ; CB DC
 set 3, h'                      ; 76 CB DC
 set 3, l                       ; CB DD
 set 3, l'                      ; 76 CB DD
 set 4, (hl)                    ; CB E6
 set 4, (ix)                    ; DD CB 00 E6
 set 4, (ix+127)                ; DD CB 7F E6
 set 4, (ix-128)                ; DD CB 80 E6
 set 4, (iy)                    ; FD CB 00 E6
 set 4, (iy+127)                ; FD CB 7F E6
 set 4, (iy-128)                ; FD CB 80 E6
 set 4, a                       ; CB E7
 set 4, a'                      ; 76 CB E7
 set 4, b                       ; CB E0
 set 4, b'                      ; 76 CB E0
 set 4, c                       ; CB E1
 set 4, c'                      ; 76 CB E1
 set 4, d                       ; CB E2
 set 4, d'                      ; 76 CB E2
 set 4, e                       ; CB E3
 set 4, e'                      ; 76 CB E3
 set 4, h                       ; CB E4
 set 4, h'                      ; 76 CB E4
 set 4, l                       ; CB E5
 set 4, l'                      ; 76 CB E5
 set 5, (hl)                    ; CB EE
 set 5, (ix)                    ; DD CB 00 EE
 set 5, (ix+127)                ; DD CB 7F EE
 set 5, (ix-128)                ; DD CB 80 EE
 set 5, (iy)                    ; FD CB 00 EE
 set 5, (iy+127)                ; FD CB 7F EE
 set 5, (iy-128)                ; FD CB 80 EE
 set 5, a                       ; CB EF
 set 5, a'                      ; 76 CB EF
 set 5, b                       ; CB E8
 set 5, b'                      ; 76 CB E8
 set 5, c                       ; CB E9
 set 5, c'                      ; 76 CB E9
 set 5, d                       ; CB EA
 set 5, d'                      ; 76 CB EA
 set 5, e                       ; CB EB
 set 5, e'                      ; 76 CB EB
 set 5, h                       ; CB EC
 set 5, h'                      ; 76 CB EC
 set 5, l                       ; CB ED
 set 5, l'                      ; 76 CB ED
 set 6, (hl)                    ; CB F6
 set 6, (ix)                    ; DD CB 00 F6
 set 6, (ix+127)                ; DD CB 7F F6
 set 6, (ix-128)                ; DD CB 80 F6
 set 6, (iy)                    ; FD CB 00 F6
 set 6, (iy+127)                ; FD CB 7F F6
 set 6, (iy-128)                ; FD CB 80 F6
 set 6, a                       ; CB F7
 set 6, a'                      ; 76 CB F7
 set 6, b                       ; CB F0
 set 6, b'                      ; 76 CB F0
 set 6, c                       ; CB F1
 set 6, c'                      ; 76 CB F1
 set 6, d                       ; CB F2
 set 6, d'                      ; 76 CB F2
 set 6, e                       ; CB F3
 set 6, e'                      ; 76 CB F3
 set 6, h                       ; CB F4
 set 6, h'                      ; 76 CB F4
 set 6, l                       ; CB F5
 set 6, l'                      ; 76 CB F5
 set 7, (hl)                    ; CB FE
 set 7, (ix)                    ; DD CB 00 FE
 set 7, (ix+127)                ; DD CB 7F FE
 set 7, (ix-128)                ; DD CB 80 FE
 set 7, (iy)                    ; FD CB 00 FE
 set 7, (iy+127)                ; FD CB 7F FE
 set 7, (iy-128)                ; FD CB 80 FE
 set 7, a                       ; CB FF
 set 7, a'                      ; 76 CB FF
 set 7, b                       ; CB F8
 set 7, b'                      ; 76 CB F8
 set 7, c                       ; CB F9
 set 7, c'                      ; 76 CB F9
 set 7, d                       ; CB FA
 set 7, d'                      ; 76 CB FA
 set 7, e                       ; CB FB
 set 7, e'                      ; 76 CB FB
 set 7, h                       ; CB FC
 set 7, h'                      ; 76 CB FC
 set 7, l                       ; CB FD
 set 7, l'                      ; 76 CB FD
 setusr                         ; ED 6F
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
 sla a'                         ; 76 CB 27
 sla b                          ; CB 20
 sla b'                         ; 76 CB 20
 sla c                          ; CB 21
 sla c'                         ; 76 CB 21
 sla d                          ; CB 22
 sla d'                         ; 76 CB 22
 sla e                          ; CB 23
 sla e'                         ; 76 CB 23
 sla h                          ; CB 24
 sla h'                         ; 76 CB 24
 sla l                          ; CB 25
 sla l'                         ; 76 CB 25
 sphl                           ; F9
 sra (hl)                       ; CB 2E
 sra (ix)                       ; DD CB 00 2E
 sra (ix+127)                   ; DD CB 7F 2E
 sra (ix-128)                   ; DD CB 80 2E
 sra (iy)                       ; FD CB 00 2E
 sra (iy+127)                   ; FD CB 7F 2E
 sra (iy-128)                   ; FD CB 80 2E
 sra a                          ; CB 2F
 sra a'                         ; 76 CB 2F
 sra b                          ; CB 28
 sra b'                         ; 76 CB 28
 sra bc                         ; CB 28 CB 19
 sra c                          ; CB 29
 sra c'                         ; 76 CB 29
 sra d                          ; CB 2A
 sra d'                         ; 76 CB 2A
 sra de                         ; CB 2A CB 1B
 sra e                          ; CB 2B
 sra e'                         ; 76 CB 2B
 sra h                          ; CB 2C
 sra h'                         ; 76 CB 2C
 sra hl                         ; CB 2C CB 1D
 sra l                          ; CB 2D
 sra l'                         ; 76 CB 2D
 srl (hl)                       ; CB 3E
 srl (ix)                       ; DD CB 00 3E
 srl (ix+127)                   ; DD CB 7F 3E
 srl (ix-128)                   ; DD CB 80 3E
 srl (iy)                       ; FD CB 00 3E
 srl (iy+127)                   ; FD CB 7F 3E
 srl (iy-128)                   ; FD CB 80 3E
 srl a                          ; CB 3F
 srl a'                         ; 76 CB 3F
 srl b                          ; CB 38
 srl b'                         ; 76 CB 38
 srl c                          ; CB 39
 srl c'                         ; 76 CB 39
 srl d                          ; CB 3A
 srl d'                         ; 76 CB 3A
 srl e                          ; CB 3B
 srl e'                         ; 76 CB 3B
 srl h                          ; CB 3C
 srl h'                         ; 76 CB 3C
 srl l                          ; CB 3D
 srl l'                         ; 76 CB 3D
 sta -32768                     ; 32 00 80
 sta 32767                      ; 32 FF 7F
 sta 65535                      ; 32 FF FF
 stax b                         ; 02
 stax bc                        ; 02
 stax d                         ; 12
 stax de                        ; 12
 stc                            ; 37
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
 sub a', (hl)                   ; 76 96
 sub a', (hl+)                  ; 76 96 23
 sub a', (hl-)                  ; 76 96 2B
 sub a', (ix)                   ; 76 DD 96 00
 sub a', (ix+127)               ; 76 DD 96 7F
 sub a', (ix-128)               ; 76 DD 96 80
 sub a', (iy)                   ; 76 FD 96 00
 sub a', (iy+127)               ; 76 FD 96 7F
 sub a', (iy-128)               ; 76 FD 96 80
 sub a', -128                   ; 76 D6 80
 sub a', 127                    ; 76 D6 7F
 sub a', 255                    ; 76 D6 FF
 sub a', a                      ; 76 97
 sub a', b                      ; 76 90
 sub a', c                      ; 76 91
 sub a', d                      ; 76 92
 sub a', e                      ; 76 93
 sub a', h                      ; 76 94
 sub a', l                      ; 76 95
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
 sui 127                        ; D6 7F
 sui 255                        ; D6 FF
 sures                          ; ED 7D
 syscall                        ; ED 75
 uma                            ; ED C0
 ums                            ; ED C8
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
 xor a', (hl)                   ; 76 AE
 xor a', (hl+)                  ; 76 AE 23
 xor a', (hl-)                  ; 76 AE 2B
 xor a', (ix)                   ; 76 DD AE 00
 xor a', (ix+127)               ; 76 DD AE 7F
 xor a', (ix-128)               ; 76 DD AE 80
 xor a', (iy)                   ; 76 FD AE 00
 xor a', (iy+127)               ; 76 FD AE 7F
 xor a', (iy-128)               ; 76 FD AE 80
 xor a', -128                   ; 76 EE 80
 xor a', 127                    ; 76 EE 7F
 xor a', 255                    ; 76 EE FF
 xor a', a                      ; 76 AF
 xor a', b                      ; 76 A8
 xor a', c                      ; 76 A9
 xor a', d                      ; 76 AA
 xor a', e                      ; 76 AB
 xor a', h                      ; 76 AC
 xor a', l                      ; 76 AD
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
 xri 127                        ; EE 7F
 xri 255                        ; EE FF
