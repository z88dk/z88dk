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
 adc a', (hl)                   ; 76 8E
 adc a', (ix)                   ; 76 FD 8E 00
 adc a', (ix+127)               ; 76 FD 8E 7F
 adc a', (ix-128)               ; 76 FD 8E 80
 adc a', (iy)                   ; 76 DD 8E 00
 adc a', (iy+127)               ; 76 DD 8E 7F
 adc a', (iy-128)               ; 76 DD 8E 80
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
 add a', (hl)                   ; 76 86
 add a', (ix)                   ; 76 FD 86 00
 add a', (ix+127)               ; 76 FD 86 7F
 add a', (ix-128)               ; 76 FD 86 80
 add a', (iy)                   ; 76 DD 86 00
 add a', (iy+127)               ; 76 DD 86 7F
 add a', (iy-128)               ; 76 DD 86 80
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
 add sp, -128                   ; 27 80
 add sp, 127                    ; 27 7F
 add.a sp, -128                 ; 27 80
 add.a sp, 127                  ; 27 7F
 adi -128                       ; C6 80
 adi 127                        ; C6 7F
 adi 255                        ; C6 FF
 altd adc (hl)                  ; 76 8E
 altd adc (ix)                  ; 76 FD 8E 00
 altd adc (ix+127)              ; 76 FD 8E 7F
 altd adc (ix-128)              ; 76 FD 8E 80
 altd adc (iy)                  ; 76 DD 8E 00
 altd adc (iy+127)              ; 76 DD 8E 7F
 altd adc (iy-128)              ; 76 DD 8E 80
 altd adc -128                  ; 76 CE 80
 altd adc 127                   ; 76 CE 7F
 altd adc 255                   ; 76 CE FF
 altd adc a                     ; 76 8F
 altd adc a, (hl)               ; 76 8E
 altd adc a, (ix)               ; 76 FD 8E 00
 altd adc a, (ix+127)           ; 76 FD 8E 7F
 altd adc a, (ix-128)           ; 76 FD 8E 80
 altd adc a, (iy)               ; 76 DD 8E 00
 altd adc a, (iy+127)           ; 76 DD 8E 7F
 altd adc a, (iy-128)           ; 76 DD 8E 80
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
 altd adc m                     ; 76 8E
 altd add (hl)                  ; 76 86
 altd add (ix)                  ; 76 FD 86 00
 altd add (ix+127)              ; 76 FD 86 7F
 altd add (ix-128)              ; 76 FD 86 80
 altd add (iy)                  ; 76 DD 86 00
 altd add (iy+127)              ; 76 DD 86 7F
 altd add (iy-128)              ; 76 DD 86 80
 altd add -128                  ; 76 C6 80
 altd add 127                   ; 76 C6 7F
 altd add 255                   ; 76 C6 FF
 altd add a                     ; 76 87
 altd add a, (hl)               ; 76 86
 altd add a, (ix)               ; 76 FD 86 00
 altd add a, (ix+127)           ; 76 FD 86 7F
 altd add a, (ix-128)           ; 76 FD 86 80
 altd add a, (iy)               ; 76 DD 86 00
 altd add a, (iy+127)           ; 76 DD 86 7F
 altd add a, (iy-128)           ; 76 DD 86 80
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
 altd add m                     ; 76 86
 altd and (hl)                  ; 76 A6
 altd and (ix)                  ; 76 FD A6 00
 altd and (ix+127)              ; 76 FD A6 7F
 altd and (ix-128)              ; 76 FD A6 80
 altd and (iy)                  ; 76 DD A6 00
 altd and (iy+127)              ; 76 DD A6 7F
 altd and (iy-128)              ; 76 DD A6 80
 altd and -128                  ; 76 E6 80
 altd and 127                   ; 76 E6 7F
 altd and 255                   ; 76 E6 FF
 altd and a                     ; 76 A7
 altd and a, (hl)               ; 76 A6
 altd and a, (ix)               ; 76 FD A6 00
 altd and a, (ix+127)           ; 76 FD A6 7F
 altd and a, (ix-128)           ; 76 FD A6 80
 altd and a, (iy)               ; 76 DD A6 00
 altd and a, (iy+127)           ; 76 DD A6 7F
 altd and a, (iy-128)           ; 76 DD A6 80
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
 altd and ix, de                ; 76 FD DC
 altd and iy, de                ; 76 DD DC
 altd and l                     ; 76 A5
 altd bit 0, (hl)               ; 76 CB 46
 altd bit 0, (ix)               ; 76 FD CB 00 46
 altd bit 0, (ix+127)           ; 76 FD CB 7F 46
 altd bit 0, (ix-128)           ; 76 FD CB 80 46
 altd bit 0, (iy)               ; 76 DD CB 00 46
 altd bit 0, (iy+127)           ; 76 DD CB 7F 46
 altd bit 0, (iy-128)           ; 76 DD CB 80 46
 altd bit 0, a                  ; 76 CB 47
 altd bit 0, b                  ; 76 CB 40
 altd bit 0, c                  ; 76 CB 41
 altd bit 0, d                  ; 76 CB 42
 altd bit 0, e                  ; 76 CB 43
 altd bit 0, h                  ; 76 CB 44
 altd bit 0, l                  ; 76 CB 45
 altd bit 1, (hl)               ; 76 CB 4E
 altd bit 1, (ix)               ; 76 FD CB 00 4E
 altd bit 1, (ix+127)           ; 76 FD CB 7F 4E
 altd bit 1, (ix-128)           ; 76 FD CB 80 4E
 altd bit 1, (iy)               ; 76 DD CB 00 4E
 altd bit 1, (iy+127)           ; 76 DD CB 7F 4E
 altd bit 1, (iy-128)           ; 76 DD CB 80 4E
 altd bit 1, a                  ; 76 CB 4F
 altd bit 1, b                  ; 76 CB 48
 altd bit 1, c                  ; 76 CB 49
 altd bit 1, d                  ; 76 CB 4A
 altd bit 1, e                  ; 76 CB 4B
 altd bit 1, h                  ; 76 CB 4C
 altd bit 1, l                  ; 76 CB 4D
 altd bit 2, (hl)               ; 76 CB 56
 altd bit 2, (ix)               ; 76 FD CB 00 56
 altd bit 2, (ix+127)           ; 76 FD CB 7F 56
 altd bit 2, (ix-128)           ; 76 FD CB 80 56
 altd bit 2, (iy)               ; 76 DD CB 00 56
 altd bit 2, (iy+127)           ; 76 DD CB 7F 56
 altd bit 2, (iy-128)           ; 76 DD CB 80 56
 altd bit 2, a                  ; 76 CB 57
 altd bit 2, b                  ; 76 CB 50
 altd bit 2, c                  ; 76 CB 51
 altd bit 2, d                  ; 76 CB 52
 altd bit 2, e                  ; 76 CB 53
 altd bit 2, h                  ; 76 CB 54
 altd bit 2, l                  ; 76 CB 55
 altd bit 3, (hl)               ; 76 CB 5E
 altd bit 3, (ix)               ; 76 FD CB 00 5E
 altd bit 3, (ix+127)           ; 76 FD CB 7F 5E
 altd bit 3, (ix-128)           ; 76 FD CB 80 5E
 altd bit 3, (iy)               ; 76 DD CB 00 5E
 altd bit 3, (iy+127)           ; 76 DD CB 7F 5E
 altd bit 3, (iy-128)           ; 76 DD CB 80 5E
 altd bit 3, a                  ; 76 CB 5F
 altd bit 3, b                  ; 76 CB 58
 altd bit 3, c                  ; 76 CB 59
 altd bit 3, d                  ; 76 CB 5A
 altd bit 3, e                  ; 76 CB 5B
 altd bit 3, h                  ; 76 CB 5C
 altd bit 3, l                  ; 76 CB 5D
 altd bit 4, (hl)               ; 76 CB 66
 altd bit 4, (ix)               ; 76 FD CB 00 66
 altd bit 4, (ix+127)           ; 76 FD CB 7F 66
 altd bit 4, (ix-128)           ; 76 FD CB 80 66
 altd bit 4, (iy)               ; 76 DD CB 00 66
 altd bit 4, (iy+127)           ; 76 DD CB 7F 66
 altd bit 4, (iy-128)           ; 76 DD CB 80 66
 altd bit 4, a                  ; 76 CB 67
 altd bit 4, b                  ; 76 CB 60
 altd bit 4, c                  ; 76 CB 61
 altd bit 4, d                  ; 76 CB 62
 altd bit 4, e                  ; 76 CB 63
 altd bit 4, h                  ; 76 CB 64
 altd bit 4, l                  ; 76 CB 65
 altd bit 5, (hl)               ; 76 CB 6E
 altd bit 5, (ix)               ; 76 FD CB 00 6E
 altd bit 5, (ix+127)           ; 76 FD CB 7F 6E
 altd bit 5, (ix-128)           ; 76 FD CB 80 6E
 altd bit 5, (iy)               ; 76 DD CB 00 6E
 altd bit 5, (iy+127)           ; 76 DD CB 7F 6E
 altd bit 5, (iy-128)           ; 76 DD CB 80 6E
 altd bit 5, a                  ; 76 CB 6F
 altd bit 5, b                  ; 76 CB 68
 altd bit 5, c                  ; 76 CB 69
 altd bit 5, d                  ; 76 CB 6A
 altd bit 5, e                  ; 76 CB 6B
 altd bit 5, h                  ; 76 CB 6C
 altd bit 5, l                  ; 76 CB 6D
 altd bit 6, (hl)               ; 76 CB 76
 altd bit 6, (ix)               ; 76 FD CB 00 76
 altd bit 6, (ix+127)           ; 76 FD CB 7F 76
 altd bit 6, (ix-128)           ; 76 FD CB 80 76
 altd bit 6, (iy)               ; 76 DD CB 00 76
 altd bit 6, (iy+127)           ; 76 DD CB 7F 76
 altd bit 6, (iy-128)           ; 76 DD CB 80 76
 altd bit 6, a                  ; 76 CB 77
 altd bit 6, b                  ; 76 CB 70
 altd bit 6, c                  ; 76 CB 71
 altd bit 6, d                  ; 76 CB 72
 altd bit 6, e                  ; 76 CB 73
 altd bit 6, h                  ; 76 CB 74
 altd bit 6, l                  ; 76 CB 75
 altd bit 7, (hl)               ; 76 CB 7E
 altd bit 7, (ix)               ; 76 FD CB 00 7E
 altd bit 7, (ix+127)           ; 76 FD CB 7F 7E
 altd bit 7, (ix-128)           ; 76 FD CB 80 7E
 altd bit 7, (iy)               ; 76 DD CB 00 7E
 altd bit 7, (iy+127)           ; 76 DD CB 7F 7E
 altd bit 7, (iy-128)           ; 76 DD CB 80 7E
 altd bit 7, a                  ; 76 CB 7F
 altd bit 7, b                  ; 76 CB 78
 altd bit 7, c                  ; 76 CB 79
 altd bit 7, d                  ; 76 CB 7A
 altd bit 7, e                  ; 76 CB 7B
 altd bit 7, h                  ; 76 CB 7C
 altd bit 7, l                  ; 76 CB 7D
 altd bool hl                   ; 76 CC
 altd bool ix                   ; 76 FD CC
 altd bool iy                   ; 76 DD CC
 altd ccf                       ; 76 3F
 altd cp (hl)                   ; 76 BE
 altd cp (ix)                   ; 76 FD BE 00
 altd cp (ix+127)               ; 76 FD BE 7F
 altd cp (ix-128)               ; 76 FD BE 80
 altd cp (iy)                   ; 76 DD BE 00
 altd cp (iy+127)               ; 76 DD BE 7F
 altd cp (iy-128)               ; 76 DD BE 80
 altd cp -128                   ; 76 FE 80
 altd cp 127                    ; 76 FE 7F
 altd cp 255                    ; 76 FE FF
 altd cp a                      ; 76 BF
 altd cp a, (hl)                ; 76 BE
 altd cp a, (ix)                ; 76 FD BE 00
 altd cp a, (ix+127)            ; 76 FD BE 7F
 altd cp a, (ix-128)            ; 76 FD BE 80
 altd cp a, (iy)                ; 76 DD BE 00
 altd cp a, (iy+127)            ; 76 DD BE 7F
 altd cp a, (iy-128)            ; 76 DD BE 80
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
 altd dec (ix)                  ; 76 FD 35 00
 altd dec (ix+127)              ; 76 FD 35 7F
 altd dec (ix-128)              ; 76 FD 35 80
 altd dec (iy)                  ; 76 DD 35 00
 altd dec (iy+127)              ; 76 DD 35 7F
 altd dec (iy-128)              ; 76 DD 35 80
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
 altd inc (ix)                  ; 76 FD 34 00
 altd inc (ix+127)              ; 76 FD 34 7F
 altd inc (ix-128)              ; 76 FD 34 80
 altd inc (iy)                  ; 76 DD 34 00
 altd inc (iy+127)              ; 76 DD 34 7F
 altd inc (iy-128)              ; 76 DD 34 80
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
 altd ioe adc (ix)              ; 76 DB FD 8E 00
 altd ioe adc (ix+127)          ; 76 DB FD 8E 7F
 altd ioe adc (ix-128)          ; 76 DB FD 8E 80
 altd ioe adc (iy)              ; 76 DB DD 8E 00
 altd ioe adc (iy+127)          ; 76 DB DD 8E 7F
 altd ioe adc (iy-128)          ; 76 DB DD 8E 80
 altd ioe adc a, (hl)           ; 76 DB 8E
 altd ioe adc a, (ix)           ; 76 DB FD 8E 00
 altd ioe adc a, (ix+127)       ; 76 DB FD 8E 7F
 altd ioe adc a, (ix-128)       ; 76 DB FD 8E 80
 altd ioe adc a, (iy)           ; 76 DB DD 8E 00
 altd ioe adc a, (iy+127)       ; 76 DB DD 8E 7F
 altd ioe adc a, (iy-128)       ; 76 DB DD 8E 80
 altd ioe add (hl)              ; 76 DB 86
 altd ioe add (ix)              ; 76 DB FD 86 00
 altd ioe add (ix+127)          ; 76 DB FD 86 7F
 altd ioe add (ix-128)          ; 76 DB FD 86 80
 altd ioe add (iy)              ; 76 DB DD 86 00
 altd ioe add (iy+127)          ; 76 DB DD 86 7F
 altd ioe add (iy-128)          ; 76 DB DD 86 80
 altd ioe add a, (hl)           ; 76 DB 86
 altd ioe add a, (ix)           ; 76 DB FD 86 00
 altd ioe add a, (ix+127)       ; 76 DB FD 86 7F
 altd ioe add a, (ix-128)       ; 76 DB FD 86 80
 altd ioe add a, (iy)           ; 76 DB DD 86 00
 altd ioe add a, (iy+127)       ; 76 DB DD 86 7F
 altd ioe add a, (iy-128)       ; 76 DB DD 86 80
 altd ioe and (hl)              ; 76 DB A6
 altd ioe and (ix)              ; 76 DB FD A6 00
 altd ioe and (ix+127)          ; 76 DB FD A6 7F
 altd ioe and (ix-128)          ; 76 DB FD A6 80
 altd ioe and (iy)              ; 76 DB DD A6 00
 altd ioe and (iy+127)          ; 76 DB DD A6 7F
 altd ioe and (iy-128)          ; 76 DB DD A6 80
 altd ioe and a, (hl)           ; 76 DB A6
 altd ioe and a, (ix)           ; 76 DB FD A6 00
 altd ioe and a, (ix+127)       ; 76 DB FD A6 7F
 altd ioe and a, (ix-128)       ; 76 DB FD A6 80
 altd ioe and a, (iy)           ; 76 DB DD A6 00
 altd ioe and a, (iy+127)       ; 76 DB DD A6 7F
 altd ioe and a, (iy-128)       ; 76 DB DD A6 80
 altd ioe bit 0, (hl)           ; 76 DB CB 46
 altd ioe bit 0, (ix)           ; 76 DB FD CB 00 46
 altd ioe bit 0, (ix+127)       ; 76 DB FD CB 7F 46
 altd ioe bit 0, (ix-128)       ; 76 DB FD CB 80 46
 altd ioe bit 0, (iy)           ; 76 DB DD CB 00 46
 altd ioe bit 0, (iy+127)       ; 76 DB DD CB 7F 46
 altd ioe bit 0, (iy-128)       ; 76 DB DD CB 80 46
 altd ioe bit 1, (hl)           ; 76 DB CB 4E
 altd ioe bit 1, (ix)           ; 76 DB FD CB 00 4E
 altd ioe bit 1, (ix+127)       ; 76 DB FD CB 7F 4E
 altd ioe bit 1, (ix-128)       ; 76 DB FD CB 80 4E
 altd ioe bit 1, (iy)           ; 76 DB DD CB 00 4E
 altd ioe bit 1, (iy+127)       ; 76 DB DD CB 7F 4E
 altd ioe bit 1, (iy-128)       ; 76 DB DD CB 80 4E
 altd ioe bit 2, (hl)           ; 76 DB CB 56
 altd ioe bit 2, (ix)           ; 76 DB FD CB 00 56
 altd ioe bit 2, (ix+127)       ; 76 DB FD CB 7F 56
 altd ioe bit 2, (ix-128)       ; 76 DB FD CB 80 56
 altd ioe bit 2, (iy)           ; 76 DB DD CB 00 56
 altd ioe bit 2, (iy+127)       ; 76 DB DD CB 7F 56
 altd ioe bit 2, (iy-128)       ; 76 DB DD CB 80 56
 altd ioe bit 3, (hl)           ; 76 DB CB 5E
 altd ioe bit 3, (ix)           ; 76 DB FD CB 00 5E
 altd ioe bit 3, (ix+127)       ; 76 DB FD CB 7F 5E
 altd ioe bit 3, (ix-128)       ; 76 DB FD CB 80 5E
 altd ioe bit 3, (iy)           ; 76 DB DD CB 00 5E
 altd ioe bit 3, (iy+127)       ; 76 DB DD CB 7F 5E
 altd ioe bit 3, (iy-128)       ; 76 DB DD CB 80 5E
 altd ioe bit 4, (hl)           ; 76 DB CB 66
 altd ioe bit 4, (ix)           ; 76 DB FD CB 00 66
 altd ioe bit 4, (ix+127)       ; 76 DB FD CB 7F 66
 altd ioe bit 4, (ix-128)       ; 76 DB FD CB 80 66
 altd ioe bit 4, (iy)           ; 76 DB DD CB 00 66
 altd ioe bit 4, (iy+127)       ; 76 DB DD CB 7F 66
 altd ioe bit 4, (iy-128)       ; 76 DB DD CB 80 66
 altd ioe bit 5, (hl)           ; 76 DB CB 6E
 altd ioe bit 5, (ix)           ; 76 DB FD CB 00 6E
 altd ioe bit 5, (ix+127)       ; 76 DB FD CB 7F 6E
 altd ioe bit 5, (ix-128)       ; 76 DB FD CB 80 6E
 altd ioe bit 5, (iy)           ; 76 DB DD CB 00 6E
 altd ioe bit 5, (iy+127)       ; 76 DB DD CB 7F 6E
 altd ioe bit 5, (iy-128)       ; 76 DB DD CB 80 6E
 altd ioe bit 6, (hl)           ; 76 DB CB 76
 altd ioe bit 6, (ix)           ; 76 DB FD CB 00 76
 altd ioe bit 6, (ix+127)       ; 76 DB FD CB 7F 76
 altd ioe bit 6, (ix-128)       ; 76 DB FD CB 80 76
 altd ioe bit 6, (iy)           ; 76 DB DD CB 00 76
 altd ioe bit 6, (iy+127)       ; 76 DB DD CB 7F 76
 altd ioe bit 6, (iy-128)       ; 76 DB DD CB 80 76
 altd ioe bit 7, (hl)           ; 76 DB CB 7E
 altd ioe bit 7, (ix)           ; 76 DB FD CB 00 7E
 altd ioe bit 7, (ix+127)       ; 76 DB FD CB 7F 7E
 altd ioe bit 7, (ix-128)       ; 76 DB FD CB 80 7E
 altd ioe bit 7, (iy)           ; 76 DB DD CB 00 7E
 altd ioe bit 7, (iy+127)       ; 76 DB DD CB 7F 7E
 altd ioe bit 7, (iy-128)       ; 76 DB DD CB 80 7E
 altd ioe cp (hl)               ; 76 DB BE
 altd ioe cp (ix)               ; 76 DB FD BE 00
 altd ioe cp (ix+127)           ; 76 DB FD BE 7F
 altd ioe cp (ix-128)           ; 76 DB FD BE 80
 altd ioe cp (iy)               ; 76 DB DD BE 00
 altd ioe cp (iy+127)           ; 76 DB DD BE 7F
 altd ioe cp (iy-128)           ; 76 DB DD BE 80
 altd ioe cp a, (hl)            ; 76 DB BE
 altd ioe cp a, (ix)            ; 76 DB FD BE 00
 altd ioe cp a, (ix+127)        ; 76 DB FD BE 7F
 altd ioe cp a, (ix-128)        ; 76 DB FD BE 80
 altd ioe cp a, (iy)            ; 76 DB DD BE 00
 altd ioe cp a, (iy+127)        ; 76 DB DD BE 7F
 altd ioe cp a, (iy-128)        ; 76 DB DD BE 80
 altd ioe dec (hl)              ; 76 DB 35
 altd ioe dec (ix)              ; 76 DB FD 35 00
 altd ioe dec (ix+127)          ; 76 DB FD 35 7F
 altd ioe dec (ix-128)          ; 76 DB FD 35 80
 altd ioe dec (iy)              ; 76 DB DD 35 00
 altd ioe dec (iy+127)          ; 76 DB DD 35 7F
 altd ioe dec (iy-128)          ; 76 DB DD 35 80
 altd ioe inc (hl)              ; 76 DB 34
 altd ioe inc (ix)              ; 76 DB FD 34 00
 altd ioe inc (ix+127)          ; 76 DB FD 34 7F
 altd ioe inc (ix-128)          ; 76 DB FD 34 80
 altd ioe inc (iy)              ; 76 DB DD 34 00
 altd ioe inc (iy+127)          ; 76 DB DD 34 7F
 altd ioe inc (iy-128)          ; 76 DB DD 34 80
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
 altd ioe ld a, (ix)            ; 76 DB FD 7E 00
 altd ioe ld a, (ix+127)        ; 76 DB FD 7E 7F
 altd ioe ld a, (ix-128)        ; 76 DB FD 7E 80
 altd ioe ld a, (iy)            ; 76 DB DD 7E 00
 altd ioe ld a, (iy+127)        ; 76 DB DD 7E 7F
 altd ioe ld a, (iy-128)        ; 76 DB DD 7E 80
 altd ioe ld b, (hl)            ; 76 DB 46
 altd ioe ld b, (ix)            ; 76 DB FD 46 00
 altd ioe ld b, (ix+127)        ; 76 DB FD 46 7F
 altd ioe ld b, (ix-128)        ; 76 DB FD 46 80
 altd ioe ld b, (iy)            ; 76 DB DD 46 00
 altd ioe ld b, (iy+127)        ; 76 DB DD 46 7F
 altd ioe ld b, (iy-128)        ; 76 DB DD 46 80
 altd ioe ld bc, (-32768)       ; 76 DB ED 4B 00 80
 altd ioe ld bc, (32767)        ; 76 DB ED 4B FF 7F
 altd ioe ld bc, (65535)        ; 76 DB ED 4B FF FF
 altd ioe ld c, (hl)            ; 76 DB 4E
 altd ioe ld c, (ix)            ; 76 DB FD 4E 00
 altd ioe ld c, (ix+127)        ; 76 DB FD 4E 7F
 altd ioe ld c, (ix-128)        ; 76 DB FD 4E 80
 altd ioe ld c, (iy)            ; 76 DB DD 4E 00
 altd ioe ld c, (iy+127)        ; 76 DB DD 4E 7F
 altd ioe ld c, (iy-128)        ; 76 DB DD 4E 80
 altd ioe ld d, (hl)            ; 76 DB 56
 altd ioe ld d, (ix)            ; 76 DB FD 56 00
 altd ioe ld d, (ix+127)        ; 76 DB FD 56 7F
 altd ioe ld d, (ix-128)        ; 76 DB FD 56 80
 altd ioe ld d, (iy)            ; 76 DB DD 56 00
 altd ioe ld d, (iy+127)        ; 76 DB DD 56 7F
 altd ioe ld d, (iy-128)        ; 76 DB DD 56 80
 altd ioe ld de, (-32768)       ; 76 DB ED 5B 00 80
 altd ioe ld de, (32767)        ; 76 DB ED 5B FF 7F
 altd ioe ld de, (65535)        ; 76 DB ED 5B FF FF
 altd ioe ld e, (hl)            ; 76 DB 5E
 altd ioe ld e, (ix)            ; 76 DB FD 5E 00
 altd ioe ld e, (ix+127)        ; 76 DB FD 5E 7F
 altd ioe ld e, (ix-128)        ; 76 DB FD 5E 80
 altd ioe ld e, (iy)            ; 76 DB DD 5E 00
 altd ioe ld e, (iy+127)        ; 76 DB DD 5E 7F
 altd ioe ld e, (iy-128)        ; 76 DB DD 5E 80
 altd ioe ld h, (hl)            ; 76 DB 66
 altd ioe ld h, (ix)            ; 76 DB FD 66 00
 altd ioe ld h, (ix+127)        ; 76 DB FD 66 7F
 altd ioe ld h, (ix-128)        ; 76 DB FD 66 80
 altd ioe ld h, (iy)            ; 76 DB DD 66 00
 altd ioe ld h, (iy+127)        ; 76 DB DD 66 7F
 altd ioe ld h, (iy-128)        ; 76 DB DD 66 80
 altd ioe ld hl, (-32768)       ; 76 DB 2A 00 80
 altd ioe ld hl, (32767)        ; 76 DB 2A FF 7F
 altd ioe ld hl, (65535)        ; 76 DB 2A FF FF
 altd ioe ld hl, (hl)           ; 76 DB DD E4 00
 altd ioe ld hl, (hl+127)       ; 76 DB DD E4 7F
 altd ioe ld hl, (hl-128)       ; 76 DB DD E4 80
 altd ioe ld hl, (ix)           ; 76 DB FD E4 00
 altd ioe ld hl, (ix+127)       ; 76 DB FD E4 7F
 altd ioe ld hl, (ix-128)       ; 76 DB FD E4 80
 altd ioe ld hl, (iy)           ; 76 DB E4 00
 altd ioe ld hl, (iy+127)       ; 76 DB E4 7F
 altd ioe ld hl, (iy-128)       ; 76 DB E4 80
 altd ioe ld l, (hl)            ; 76 DB 6E
 altd ioe ld l, (ix)            ; 76 DB FD 6E 00
 altd ioe ld l, (ix+127)        ; 76 DB FD 6E 7F
 altd ioe ld l, (ix-128)        ; 76 DB FD 6E 80
 altd ioe ld l, (iy)            ; 76 DB DD 6E 00
 altd ioe ld l, (iy+127)        ; 76 DB DD 6E 7F
 altd ioe ld l, (iy-128)        ; 76 DB DD 6E 80
 altd ioe or (hl)               ; 76 DB B6
 altd ioe or (ix)               ; 76 DB FD B6 00
 altd ioe or (ix+127)           ; 76 DB FD B6 7F
 altd ioe or (ix-128)           ; 76 DB FD B6 80
 altd ioe or (iy)               ; 76 DB DD B6 00
 altd ioe or (iy+127)           ; 76 DB DD B6 7F
 altd ioe or (iy-128)           ; 76 DB DD B6 80
 altd ioe or a, (hl)            ; 76 DB B6
 altd ioe or a, (ix)            ; 76 DB FD B6 00
 altd ioe or a, (ix+127)        ; 76 DB FD B6 7F
 altd ioe or a, (ix-128)        ; 76 DB FD B6 80
 altd ioe or a, (iy)            ; 76 DB DD B6 00
 altd ioe or a, (iy+127)        ; 76 DB DD B6 7F
 altd ioe or a, (iy-128)        ; 76 DB DD B6 80
 altd ioe rl (hl)               ; 76 DB CB 16
 altd ioe rl (ix)               ; 76 DB FD CB 00 16
 altd ioe rl (ix+127)           ; 76 DB FD CB 7F 16
 altd ioe rl (ix-128)           ; 76 DB FD CB 80 16
 altd ioe rl (iy)               ; 76 DB DD CB 00 16
 altd ioe rl (iy+127)           ; 76 DB DD CB 7F 16
 altd ioe rl (iy-128)           ; 76 DB DD CB 80 16
 altd ioe rlc (hl)              ; 76 DB CB 06
 altd ioe rlc (ix)              ; 76 DB FD CB 00 06
 altd ioe rlc (ix+127)          ; 76 DB FD CB 7F 06
 altd ioe rlc (ix-128)          ; 76 DB FD CB 80 06
 altd ioe rlc (iy)              ; 76 DB DD CB 00 06
 altd ioe rlc (iy+127)          ; 76 DB DD CB 7F 06
 altd ioe rlc (iy-128)          ; 76 DB DD CB 80 06
 altd ioe rr (hl)               ; 76 DB CB 1E
 altd ioe rr (ix)               ; 76 DB FD CB 00 1E
 altd ioe rr (ix+127)           ; 76 DB FD CB 7F 1E
 altd ioe rr (ix-128)           ; 76 DB FD CB 80 1E
 altd ioe rr (iy)               ; 76 DB DD CB 00 1E
 altd ioe rr (iy+127)           ; 76 DB DD CB 7F 1E
 altd ioe rr (iy-128)           ; 76 DB DD CB 80 1E
 altd ioe rrc (hl)              ; 76 DB CB 0E
 altd ioe rrc (ix)              ; 76 DB FD CB 00 0E
 altd ioe rrc (ix+127)          ; 76 DB FD CB 7F 0E
 altd ioe rrc (ix-128)          ; 76 DB FD CB 80 0E
 altd ioe rrc (iy)              ; 76 DB DD CB 00 0E
 altd ioe rrc (iy+127)          ; 76 DB DD CB 7F 0E
 altd ioe rrc (iy-128)          ; 76 DB DD CB 80 0E
 altd ioe sbc (hl)              ; 76 DB 9E
 altd ioe sbc (ix)              ; 76 DB FD 9E 00
 altd ioe sbc (ix+127)          ; 76 DB FD 9E 7F
 altd ioe sbc (ix-128)          ; 76 DB FD 9E 80
 altd ioe sbc (iy)              ; 76 DB DD 9E 00
 altd ioe sbc (iy+127)          ; 76 DB DD 9E 7F
 altd ioe sbc (iy-128)          ; 76 DB DD 9E 80
 altd ioe sbc a, (hl)           ; 76 DB 9E
 altd ioe sbc a, (ix)           ; 76 DB FD 9E 00
 altd ioe sbc a, (ix+127)       ; 76 DB FD 9E 7F
 altd ioe sbc a, (ix-128)       ; 76 DB FD 9E 80
 altd ioe sbc a, (iy)           ; 76 DB DD 9E 00
 altd ioe sbc a, (iy+127)       ; 76 DB DD 9E 7F
 altd ioe sbc a, (iy-128)       ; 76 DB DD 9E 80
 altd ioe sla (hl)              ; 76 DB CB 26
 altd ioe sla (ix)              ; 76 DB FD CB 00 26
 altd ioe sla (ix+127)          ; 76 DB FD CB 7F 26
 altd ioe sla (ix-128)          ; 76 DB FD CB 80 26
 altd ioe sla (iy)              ; 76 DB DD CB 00 26
 altd ioe sla (iy+127)          ; 76 DB DD CB 7F 26
 altd ioe sla (iy-128)          ; 76 DB DD CB 80 26
 altd ioe sra (hl)              ; 76 DB CB 2E
 altd ioe sra (ix)              ; 76 DB FD CB 00 2E
 altd ioe sra (ix+127)          ; 76 DB FD CB 7F 2E
 altd ioe sra (ix-128)          ; 76 DB FD CB 80 2E
 altd ioe sra (iy)              ; 76 DB DD CB 00 2E
 altd ioe sra (iy+127)          ; 76 DB DD CB 7F 2E
 altd ioe sra (iy-128)          ; 76 DB DD CB 80 2E
 altd ioe srl (hl)              ; 76 DB CB 3E
 altd ioe srl (ix)              ; 76 DB FD CB 00 3E
 altd ioe srl (ix+127)          ; 76 DB FD CB 7F 3E
 altd ioe srl (ix-128)          ; 76 DB FD CB 80 3E
 altd ioe srl (iy)              ; 76 DB DD CB 00 3E
 altd ioe srl (iy+127)          ; 76 DB DD CB 7F 3E
 altd ioe srl (iy-128)          ; 76 DB DD CB 80 3E
 altd ioe sub (hl)              ; 76 DB 96
 altd ioe sub (ix)              ; 76 DB FD 96 00
 altd ioe sub (ix+127)          ; 76 DB FD 96 7F
 altd ioe sub (ix-128)          ; 76 DB FD 96 80
 altd ioe sub (iy)              ; 76 DB DD 96 00
 altd ioe sub (iy+127)          ; 76 DB DD 96 7F
 altd ioe sub (iy-128)          ; 76 DB DD 96 80
 altd ioe sub a, (hl)           ; 76 DB 96
 altd ioe sub a, (ix)           ; 76 DB FD 96 00
 altd ioe sub a, (ix+127)       ; 76 DB FD 96 7F
 altd ioe sub a, (ix-128)       ; 76 DB FD 96 80
 altd ioe sub a, (iy)           ; 76 DB DD 96 00
 altd ioe sub a, (iy+127)       ; 76 DB DD 96 7F
 altd ioe sub a, (iy-128)       ; 76 DB DD 96 80
 altd ioe xor (hl)              ; 76 DB AE
 altd ioe xor (ix)              ; 76 DB FD AE 00
 altd ioe xor (ix+127)          ; 76 DB FD AE 7F
 altd ioe xor (ix-128)          ; 76 DB FD AE 80
 altd ioe xor (iy)              ; 76 DB DD AE 00
 altd ioe xor (iy+127)          ; 76 DB DD AE 7F
 altd ioe xor (iy-128)          ; 76 DB DD AE 80
 altd ioe xor a, (hl)           ; 76 DB AE
 altd ioe xor a, (ix)           ; 76 DB FD AE 00
 altd ioe xor a, (ix+127)       ; 76 DB FD AE 7F
 altd ioe xor a, (ix-128)       ; 76 DB FD AE 80
 altd ioe xor a, (iy)           ; 76 DB DD AE 00
 altd ioe xor a, (iy+127)       ; 76 DB DD AE 7F
 altd ioe xor a, (iy-128)       ; 76 DB DD AE 80
 altd ioi adc (hl)              ; 76 D3 8E
 altd ioi adc (ix)              ; 76 D3 FD 8E 00
 altd ioi adc (ix+127)          ; 76 D3 FD 8E 7F
 altd ioi adc (ix-128)          ; 76 D3 FD 8E 80
 altd ioi adc (iy)              ; 76 D3 DD 8E 00
 altd ioi adc (iy+127)          ; 76 D3 DD 8E 7F
 altd ioi adc (iy-128)          ; 76 D3 DD 8E 80
 altd ioi adc a, (hl)           ; 76 D3 8E
 altd ioi adc a, (ix)           ; 76 D3 FD 8E 00
 altd ioi adc a, (ix+127)       ; 76 D3 FD 8E 7F
 altd ioi adc a, (ix-128)       ; 76 D3 FD 8E 80
 altd ioi adc a, (iy)           ; 76 D3 DD 8E 00
 altd ioi adc a, (iy+127)       ; 76 D3 DD 8E 7F
 altd ioi adc a, (iy-128)       ; 76 D3 DD 8E 80
 altd ioi add (hl)              ; 76 D3 86
 altd ioi add (ix)              ; 76 D3 FD 86 00
 altd ioi add (ix+127)          ; 76 D3 FD 86 7F
 altd ioi add (ix-128)          ; 76 D3 FD 86 80
 altd ioi add (iy)              ; 76 D3 DD 86 00
 altd ioi add (iy+127)          ; 76 D3 DD 86 7F
 altd ioi add (iy-128)          ; 76 D3 DD 86 80
 altd ioi add a, (hl)           ; 76 D3 86
 altd ioi add a, (ix)           ; 76 D3 FD 86 00
 altd ioi add a, (ix+127)       ; 76 D3 FD 86 7F
 altd ioi add a, (ix-128)       ; 76 D3 FD 86 80
 altd ioi add a, (iy)           ; 76 D3 DD 86 00
 altd ioi add a, (iy+127)       ; 76 D3 DD 86 7F
 altd ioi add a, (iy-128)       ; 76 D3 DD 86 80
 altd ioi and (hl)              ; 76 D3 A6
 altd ioi and (ix)              ; 76 D3 FD A6 00
 altd ioi and (ix+127)          ; 76 D3 FD A6 7F
 altd ioi and (ix-128)          ; 76 D3 FD A6 80
 altd ioi and (iy)              ; 76 D3 DD A6 00
 altd ioi and (iy+127)          ; 76 D3 DD A6 7F
 altd ioi and (iy-128)          ; 76 D3 DD A6 80
 altd ioi and a, (hl)           ; 76 D3 A6
 altd ioi and a, (ix)           ; 76 D3 FD A6 00
 altd ioi and a, (ix+127)       ; 76 D3 FD A6 7F
 altd ioi and a, (ix-128)       ; 76 D3 FD A6 80
 altd ioi and a, (iy)           ; 76 D3 DD A6 00
 altd ioi and a, (iy+127)       ; 76 D3 DD A6 7F
 altd ioi and a, (iy-128)       ; 76 D3 DD A6 80
 altd ioi bit 0, (hl)           ; 76 D3 CB 46
 altd ioi bit 0, (ix)           ; 76 D3 FD CB 00 46
 altd ioi bit 0, (ix+127)       ; 76 D3 FD CB 7F 46
 altd ioi bit 0, (ix-128)       ; 76 D3 FD CB 80 46
 altd ioi bit 0, (iy)           ; 76 D3 DD CB 00 46
 altd ioi bit 0, (iy+127)       ; 76 D3 DD CB 7F 46
 altd ioi bit 0, (iy-128)       ; 76 D3 DD CB 80 46
 altd ioi bit 1, (hl)           ; 76 D3 CB 4E
 altd ioi bit 1, (ix)           ; 76 D3 FD CB 00 4E
 altd ioi bit 1, (ix+127)       ; 76 D3 FD CB 7F 4E
 altd ioi bit 1, (ix-128)       ; 76 D3 FD CB 80 4E
 altd ioi bit 1, (iy)           ; 76 D3 DD CB 00 4E
 altd ioi bit 1, (iy+127)       ; 76 D3 DD CB 7F 4E
 altd ioi bit 1, (iy-128)       ; 76 D3 DD CB 80 4E
 altd ioi bit 2, (hl)           ; 76 D3 CB 56
 altd ioi bit 2, (ix)           ; 76 D3 FD CB 00 56
 altd ioi bit 2, (ix+127)       ; 76 D3 FD CB 7F 56
 altd ioi bit 2, (ix-128)       ; 76 D3 FD CB 80 56
 altd ioi bit 2, (iy)           ; 76 D3 DD CB 00 56
 altd ioi bit 2, (iy+127)       ; 76 D3 DD CB 7F 56
 altd ioi bit 2, (iy-128)       ; 76 D3 DD CB 80 56
 altd ioi bit 3, (hl)           ; 76 D3 CB 5E
 altd ioi bit 3, (ix)           ; 76 D3 FD CB 00 5E
 altd ioi bit 3, (ix+127)       ; 76 D3 FD CB 7F 5E
 altd ioi bit 3, (ix-128)       ; 76 D3 FD CB 80 5E
 altd ioi bit 3, (iy)           ; 76 D3 DD CB 00 5E
 altd ioi bit 3, (iy+127)       ; 76 D3 DD CB 7F 5E
 altd ioi bit 3, (iy-128)       ; 76 D3 DD CB 80 5E
 altd ioi bit 4, (hl)           ; 76 D3 CB 66
 altd ioi bit 4, (ix)           ; 76 D3 FD CB 00 66
 altd ioi bit 4, (ix+127)       ; 76 D3 FD CB 7F 66
 altd ioi bit 4, (ix-128)       ; 76 D3 FD CB 80 66
 altd ioi bit 4, (iy)           ; 76 D3 DD CB 00 66
 altd ioi bit 4, (iy+127)       ; 76 D3 DD CB 7F 66
 altd ioi bit 4, (iy-128)       ; 76 D3 DD CB 80 66
 altd ioi bit 5, (hl)           ; 76 D3 CB 6E
 altd ioi bit 5, (ix)           ; 76 D3 FD CB 00 6E
 altd ioi bit 5, (ix+127)       ; 76 D3 FD CB 7F 6E
 altd ioi bit 5, (ix-128)       ; 76 D3 FD CB 80 6E
 altd ioi bit 5, (iy)           ; 76 D3 DD CB 00 6E
 altd ioi bit 5, (iy+127)       ; 76 D3 DD CB 7F 6E
 altd ioi bit 5, (iy-128)       ; 76 D3 DD CB 80 6E
 altd ioi bit 6, (hl)           ; 76 D3 CB 76
 altd ioi bit 6, (ix)           ; 76 D3 FD CB 00 76
 altd ioi bit 6, (ix+127)       ; 76 D3 FD CB 7F 76
 altd ioi bit 6, (ix-128)       ; 76 D3 FD CB 80 76
 altd ioi bit 6, (iy)           ; 76 D3 DD CB 00 76
 altd ioi bit 6, (iy+127)       ; 76 D3 DD CB 7F 76
 altd ioi bit 6, (iy-128)       ; 76 D3 DD CB 80 76
 altd ioi bit 7, (hl)           ; 76 D3 CB 7E
 altd ioi bit 7, (ix)           ; 76 D3 FD CB 00 7E
 altd ioi bit 7, (ix+127)       ; 76 D3 FD CB 7F 7E
 altd ioi bit 7, (ix-128)       ; 76 D3 FD CB 80 7E
 altd ioi bit 7, (iy)           ; 76 D3 DD CB 00 7E
 altd ioi bit 7, (iy+127)       ; 76 D3 DD CB 7F 7E
 altd ioi bit 7, (iy-128)       ; 76 D3 DD CB 80 7E
 altd ioi cp (hl)               ; 76 D3 BE
 altd ioi cp (ix)               ; 76 D3 FD BE 00
 altd ioi cp (ix+127)           ; 76 D3 FD BE 7F
 altd ioi cp (ix-128)           ; 76 D3 FD BE 80
 altd ioi cp (iy)               ; 76 D3 DD BE 00
 altd ioi cp (iy+127)           ; 76 D3 DD BE 7F
 altd ioi cp (iy-128)           ; 76 D3 DD BE 80
 altd ioi cp a, (hl)            ; 76 D3 BE
 altd ioi cp a, (ix)            ; 76 D3 FD BE 00
 altd ioi cp a, (ix+127)        ; 76 D3 FD BE 7F
 altd ioi cp a, (ix-128)        ; 76 D3 FD BE 80
 altd ioi cp a, (iy)            ; 76 D3 DD BE 00
 altd ioi cp a, (iy+127)        ; 76 D3 DD BE 7F
 altd ioi cp a, (iy-128)        ; 76 D3 DD BE 80
 altd ioi dec (hl)              ; 76 D3 35
 altd ioi dec (ix)              ; 76 D3 FD 35 00
 altd ioi dec (ix+127)          ; 76 D3 FD 35 7F
 altd ioi dec (ix-128)          ; 76 D3 FD 35 80
 altd ioi dec (iy)              ; 76 D3 DD 35 00
 altd ioi dec (iy+127)          ; 76 D3 DD 35 7F
 altd ioi dec (iy-128)          ; 76 D3 DD 35 80
 altd ioi inc (hl)              ; 76 D3 34
 altd ioi inc (ix)              ; 76 D3 FD 34 00
 altd ioi inc (ix+127)          ; 76 D3 FD 34 7F
 altd ioi inc (ix-128)          ; 76 D3 FD 34 80
 altd ioi inc (iy)              ; 76 D3 DD 34 00
 altd ioi inc (iy+127)          ; 76 D3 DD 34 7F
 altd ioi inc (iy-128)          ; 76 D3 DD 34 80
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
 altd ioi ld a, (ix)            ; 76 D3 FD 7E 00
 altd ioi ld a, (ix+127)        ; 76 D3 FD 7E 7F
 altd ioi ld a, (ix-128)        ; 76 D3 FD 7E 80
 altd ioi ld a, (iy)            ; 76 D3 DD 7E 00
 altd ioi ld a, (iy+127)        ; 76 D3 DD 7E 7F
 altd ioi ld a, (iy-128)        ; 76 D3 DD 7E 80
 altd ioi ld b, (hl)            ; 76 D3 46
 altd ioi ld b, (ix)            ; 76 D3 FD 46 00
 altd ioi ld b, (ix+127)        ; 76 D3 FD 46 7F
 altd ioi ld b, (ix-128)        ; 76 D3 FD 46 80
 altd ioi ld b, (iy)            ; 76 D3 DD 46 00
 altd ioi ld b, (iy+127)        ; 76 D3 DD 46 7F
 altd ioi ld b, (iy-128)        ; 76 D3 DD 46 80
 altd ioi ld bc, (-32768)       ; 76 D3 ED 4B 00 80
 altd ioi ld bc, (32767)        ; 76 D3 ED 4B FF 7F
 altd ioi ld bc, (65535)        ; 76 D3 ED 4B FF FF
 altd ioi ld c, (hl)            ; 76 D3 4E
 altd ioi ld c, (ix)            ; 76 D3 FD 4E 00
 altd ioi ld c, (ix+127)        ; 76 D3 FD 4E 7F
 altd ioi ld c, (ix-128)        ; 76 D3 FD 4E 80
 altd ioi ld c, (iy)            ; 76 D3 DD 4E 00
 altd ioi ld c, (iy+127)        ; 76 D3 DD 4E 7F
 altd ioi ld c, (iy-128)        ; 76 D3 DD 4E 80
 altd ioi ld d, (hl)            ; 76 D3 56
 altd ioi ld d, (ix)            ; 76 D3 FD 56 00
 altd ioi ld d, (ix+127)        ; 76 D3 FD 56 7F
 altd ioi ld d, (ix-128)        ; 76 D3 FD 56 80
 altd ioi ld d, (iy)            ; 76 D3 DD 56 00
 altd ioi ld d, (iy+127)        ; 76 D3 DD 56 7F
 altd ioi ld d, (iy-128)        ; 76 D3 DD 56 80
 altd ioi ld de, (-32768)       ; 76 D3 ED 5B 00 80
 altd ioi ld de, (32767)        ; 76 D3 ED 5B FF 7F
 altd ioi ld de, (65535)        ; 76 D3 ED 5B FF FF
 altd ioi ld e, (hl)            ; 76 D3 5E
 altd ioi ld e, (ix)            ; 76 D3 FD 5E 00
 altd ioi ld e, (ix+127)        ; 76 D3 FD 5E 7F
 altd ioi ld e, (ix-128)        ; 76 D3 FD 5E 80
 altd ioi ld e, (iy)            ; 76 D3 DD 5E 00
 altd ioi ld e, (iy+127)        ; 76 D3 DD 5E 7F
 altd ioi ld e, (iy-128)        ; 76 D3 DD 5E 80
 altd ioi ld h, (hl)            ; 76 D3 66
 altd ioi ld h, (ix)            ; 76 D3 FD 66 00
 altd ioi ld h, (ix+127)        ; 76 D3 FD 66 7F
 altd ioi ld h, (ix-128)        ; 76 D3 FD 66 80
 altd ioi ld h, (iy)            ; 76 D3 DD 66 00
 altd ioi ld h, (iy+127)        ; 76 D3 DD 66 7F
 altd ioi ld h, (iy-128)        ; 76 D3 DD 66 80
 altd ioi ld hl, (-32768)       ; 76 D3 2A 00 80
 altd ioi ld hl, (32767)        ; 76 D3 2A FF 7F
 altd ioi ld hl, (65535)        ; 76 D3 2A FF FF
 altd ioi ld hl, (hl)           ; 76 D3 DD E4 00
 altd ioi ld hl, (hl+127)       ; 76 D3 DD E4 7F
 altd ioi ld hl, (hl-128)       ; 76 D3 DD E4 80
 altd ioi ld hl, (ix)           ; 76 D3 FD E4 00
 altd ioi ld hl, (ix+127)       ; 76 D3 FD E4 7F
 altd ioi ld hl, (ix-128)       ; 76 D3 FD E4 80
 altd ioi ld hl, (iy)           ; 76 D3 E4 00
 altd ioi ld hl, (iy+127)       ; 76 D3 E4 7F
 altd ioi ld hl, (iy-128)       ; 76 D3 E4 80
 altd ioi ld l, (hl)            ; 76 D3 6E
 altd ioi ld l, (ix)            ; 76 D3 FD 6E 00
 altd ioi ld l, (ix+127)        ; 76 D3 FD 6E 7F
 altd ioi ld l, (ix-128)        ; 76 D3 FD 6E 80
 altd ioi ld l, (iy)            ; 76 D3 DD 6E 00
 altd ioi ld l, (iy+127)        ; 76 D3 DD 6E 7F
 altd ioi ld l, (iy-128)        ; 76 D3 DD 6E 80
 altd ioi or (hl)               ; 76 D3 B6
 altd ioi or (ix)               ; 76 D3 FD B6 00
 altd ioi or (ix+127)           ; 76 D3 FD B6 7F
 altd ioi or (ix-128)           ; 76 D3 FD B6 80
 altd ioi or (iy)               ; 76 D3 DD B6 00
 altd ioi or (iy+127)           ; 76 D3 DD B6 7F
 altd ioi or (iy-128)           ; 76 D3 DD B6 80
 altd ioi or a, (hl)            ; 76 D3 B6
 altd ioi or a, (ix)            ; 76 D3 FD B6 00
 altd ioi or a, (ix+127)        ; 76 D3 FD B6 7F
 altd ioi or a, (ix-128)        ; 76 D3 FD B6 80
 altd ioi or a, (iy)            ; 76 D3 DD B6 00
 altd ioi or a, (iy+127)        ; 76 D3 DD B6 7F
 altd ioi or a, (iy-128)        ; 76 D3 DD B6 80
 altd ioi rl (hl)               ; 76 D3 CB 16
 altd ioi rl (ix)               ; 76 D3 FD CB 00 16
 altd ioi rl (ix+127)           ; 76 D3 FD CB 7F 16
 altd ioi rl (ix-128)           ; 76 D3 FD CB 80 16
 altd ioi rl (iy)               ; 76 D3 DD CB 00 16
 altd ioi rl (iy+127)           ; 76 D3 DD CB 7F 16
 altd ioi rl (iy-128)           ; 76 D3 DD CB 80 16
 altd ioi rlc (hl)              ; 76 D3 CB 06
 altd ioi rlc (ix)              ; 76 D3 FD CB 00 06
 altd ioi rlc (ix+127)          ; 76 D3 FD CB 7F 06
 altd ioi rlc (ix-128)          ; 76 D3 FD CB 80 06
 altd ioi rlc (iy)              ; 76 D3 DD CB 00 06
 altd ioi rlc (iy+127)          ; 76 D3 DD CB 7F 06
 altd ioi rlc (iy-128)          ; 76 D3 DD CB 80 06
 altd ioi rr (hl)               ; 76 D3 CB 1E
 altd ioi rr (ix)               ; 76 D3 FD CB 00 1E
 altd ioi rr (ix+127)           ; 76 D3 FD CB 7F 1E
 altd ioi rr (ix-128)           ; 76 D3 FD CB 80 1E
 altd ioi rr (iy)               ; 76 D3 DD CB 00 1E
 altd ioi rr (iy+127)           ; 76 D3 DD CB 7F 1E
 altd ioi rr (iy-128)           ; 76 D3 DD CB 80 1E
 altd ioi rrc (hl)              ; 76 D3 CB 0E
 altd ioi rrc (ix)              ; 76 D3 FD CB 00 0E
 altd ioi rrc (ix+127)          ; 76 D3 FD CB 7F 0E
 altd ioi rrc (ix-128)          ; 76 D3 FD CB 80 0E
 altd ioi rrc (iy)              ; 76 D3 DD CB 00 0E
 altd ioi rrc (iy+127)          ; 76 D3 DD CB 7F 0E
 altd ioi rrc (iy-128)          ; 76 D3 DD CB 80 0E
 altd ioi sbc (hl)              ; 76 D3 9E
 altd ioi sbc (ix)              ; 76 D3 FD 9E 00
 altd ioi sbc (ix+127)          ; 76 D3 FD 9E 7F
 altd ioi sbc (ix-128)          ; 76 D3 FD 9E 80
 altd ioi sbc (iy)              ; 76 D3 DD 9E 00
 altd ioi sbc (iy+127)          ; 76 D3 DD 9E 7F
 altd ioi sbc (iy-128)          ; 76 D3 DD 9E 80
 altd ioi sbc a, (hl)           ; 76 D3 9E
 altd ioi sbc a, (ix)           ; 76 D3 FD 9E 00
 altd ioi sbc a, (ix+127)       ; 76 D3 FD 9E 7F
 altd ioi sbc a, (ix-128)       ; 76 D3 FD 9E 80
 altd ioi sbc a, (iy)           ; 76 D3 DD 9E 00
 altd ioi sbc a, (iy+127)       ; 76 D3 DD 9E 7F
 altd ioi sbc a, (iy-128)       ; 76 D3 DD 9E 80
 altd ioi sla (hl)              ; 76 D3 CB 26
 altd ioi sla (ix)              ; 76 D3 FD CB 00 26
 altd ioi sla (ix+127)          ; 76 D3 FD CB 7F 26
 altd ioi sla (ix-128)          ; 76 D3 FD CB 80 26
 altd ioi sla (iy)              ; 76 D3 DD CB 00 26
 altd ioi sla (iy+127)          ; 76 D3 DD CB 7F 26
 altd ioi sla (iy-128)          ; 76 D3 DD CB 80 26
 altd ioi sra (hl)              ; 76 D3 CB 2E
 altd ioi sra (ix)              ; 76 D3 FD CB 00 2E
 altd ioi sra (ix+127)          ; 76 D3 FD CB 7F 2E
 altd ioi sra (ix-128)          ; 76 D3 FD CB 80 2E
 altd ioi sra (iy)              ; 76 D3 DD CB 00 2E
 altd ioi sra (iy+127)          ; 76 D3 DD CB 7F 2E
 altd ioi sra (iy-128)          ; 76 D3 DD CB 80 2E
 altd ioi srl (hl)              ; 76 D3 CB 3E
 altd ioi srl (ix)              ; 76 D3 FD CB 00 3E
 altd ioi srl (ix+127)          ; 76 D3 FD CB 7F 3E
 altd ioi srl (ix-128)          ; 76 D3 FD CB 80 3E
 altd ioi srl (iy)              ; 76 D3 DD CB 00 3E
 altd ioi srl (iy+127)          ; 76 D3 DD CB 7F 3E
 altd ioi srl (iy-128)          ; 76 D3 DD CB 80 3E
 altd ioi sub (hl)              ; 76 D3 96
 altd ioi sub (ix)              ; 76 D3 FD 96 00
 altd ioi sub (ix+127)          ; 76 D3 FD 96 7F
 altd ioi sub (ix-128)          ; 76 D3 FD 96 80
 altd ioi sub (iy)              ; 76 D3 DD 96 00
 altd ioi sub (iy+127)          ; 76 D3 DD 96 7F
 altd ioi sub (iy-128)          ; 76 D3 DD 96 80
 altd ioi sub a, (hl)           ; 76 D3 96
 altd ioi sub a, (ix)           ; 76 D3 FD 96 00
 altd ioi sub a, (ix+127)       ; 76 D3 FD 96 7F
 altd ioi sub a, (ix-128)       ; 76 D3 FD 96 80
 altd ioi sub a, (iy)           ; 76 D3 DD 96 00
 altd ioi sub a, (iy+127)       ; 76 D3 DD 96 7F
 altd ioi sub a, (iy-128)       ; 76 D3 DD 96 80
 altd ioi xor (hl)              ; 76 D3 AE
 altd ioi xor (ix)              ; 76 D3 FD AE 00
 altd ioi xor (ix+127)          ; 76 D3 FD AE 7F
 altd ioi xor (ix-128)          ; 76 D3 FD AE 80
 altd ioi xor (iy)              ; 76 D3 DD AE 00
 altd ioi xor (iy+127)          ; 76 D3 DD AE 7F
 altd ioi xor (iy-128)          ; 76 D3 DD AE 80
 altd ioi xor a, (hl)           ; 76 D3 AE
 altd ioi xor a, (ix)           ; 76 D3 FD AE 00
 altd ioi xor a, (ix+127)       ; 76 D3 FD AE 7F
 altd ioi xor a, (ix-128)       ; 76 D3 FD AE 80
 altd ioi xor a, (iy)           ; 76 D3 DD AE 00
 altd ioi xor a, (iy+127)       ; 76 D3 DD AE 7F
 altd ioi xor a, (iy-128)       ; 76 D3 DD AE 80
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
 altd ld a, (ix)                ; 76 FD 7E 00
 altd ld a, (ix+127)            ; 76 FD 7E 7F
 altd ld a, (ix-128)            ; 76 FD 7E 80
 altd ld a, (iy)                ; 76 DD 7E 00
 altd ld a, (iy+127)            ; 76 DD 7E 7F
 altd ld a, (iy-128)            ; 76 DD 7E 80
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
 altd ld b, (ix)                ; 76 FD 46 00
 altd ld b, (ix+127)            ; 76 FD 46 7F
 altd ld b, (ix-128)            ; 76 FD 46 80
 altd ld b, (iy)                ; 76 DD 46 00
 altd ld b, (iy+127)            ; 76 DD 46 7F
 altd ld b, (iy-128)            ; 76 DD 46 80
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
 altd ld c, (ix)                ; 76 FD 4E 00
 altd ld c, (ix+127)            ; 76 FD 4E 7F
 altd ld c, (ix-128)            ; 76 FD 4E 80
 altd ld c, (iy)                ; 76 DD 4E 00
 altd ld c, (iy+127)            ; 76 DD 4E 7F
 altd ld c, (iy-128)            ; 76 DD 4E 80
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
 altd ld d, (ix)                ; 76 FD 56 00
 altd ld d, (ix+127)            ; 76 FD 56 7F
 altd ld d, (ix-128)            ; 76 FD 56 80
 altd ld d, (iy)                ; 76 DD 56 00
 altd ld d, (iy+127)            ; 76 DD 56 7F
 altd ld d, (iy-128)            ; 76 DD 56 80
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
 altd ld e, (ix)                ; 76 FD 5E 00
 altd ld e, (ix+127)            ; 76 FD 5E 7F
 altd ld e, (ix-128)            ; 76 FD 5E 80
 altd ld e, (iy)                ; 76 DD 5E 00
 altd ld e, (iy+127)            ; 76 DD 5E 7F
 altd ld e, (iy-128)            ; 76 DD 5E 80
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
 altd ld h, (ix)                ; 76 FD 66 00
 altd ld h, (ix+127)            ; 76 FD 66 7F
 altd ld h, (ix-128)            ; 76 FD 66 80
 altd ld h, (iy)                ; 76 DD 66 00
 altd ld h, (iy+127)            ; 76 DD 66 7F
 altd ld h, (iy-128)            ; 76 DD 66 80
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
 altd ld hl, (ix)               ; 76 FD E4 00
 altd ld hl, (ix+127)           ; 76 FD E4 7F
 altd ld hl, (ix-128)           ; 76 FD E4 80
 altd ld hl, (iy)               ; 76 E4 00
 altd ld hl, (iy+127)           ; 76 E4 7F
 altd ld hl, (iy-128)           ; 76 E4 80
 altd ld hl, (sp)               ; 76 C4 00
 altd ld hl, (sp+0)             ; 76 C4 00
 altd ld hl, (sp+255)           ; 76 C4 FF
 altd ld hl, -32768             ; 76 21 00 80
 altd ld hl, 32767              ; 76 21 FF 7F
 altd ld hl, 65535              ; 76 21 FF FF
 altd ld hl, bc                 ; ED 69
 altd ld hl, de                 ; ED 61
 altd ld hl, ix                 ; 76 FD 7C
 altd ld hl, iy                 ; 76 DD 7C
 altd ld l, (hl)                ; 76 6E
 altd ld l, (ix)                ; 76 FD 6E 00
 altd ld l, (ix+127)            ; 76 FD 6E 7F
 altd ld l, (ix-128)            ; 76 FD 6E 80
 altd ld l, (iy)                ; 76 DD 6E 00
 altd ld l, (iy+127)            ; 76 DD 6E 7F
 altd ld l, (iy-128)            ; 76 DD 6E 80
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
 altd or (ix)                   ; 76 FD B6 00
 altd or (ix+127)               ; 76 FD B6 7F
 altd or (ix-128)               ; 76 FD B6 80
 altd or (iy)                   ; 76 DD B6 00
 altd or (iy+127)               ; 76 DD B6 7F
 altd or (iy-128)               ; 76 DD B6 80
 altd or -128                   ; 76 F6 80
 altd or 127                    ; 76 F6 7F
 altd or 255                    ; 76 F6 FF
 altd or a                      ; 76 B7
 altd or a, (hl)                ; 76 B6
 altd or a, (ix)                ; 76 FD B6 00
 altd or a, (ix+127)            ; 76 FD B6 7F
 altd or a, (ix-128)            ; 76 FD B6 80
 altd or a, (iy)                ; 76 DD B6 00
 altd or a, (iy+127)            ; 76 DD B6 7F
 altd or a, (iy-128)            ; 76 DD B6 80
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
 altd or ix, de                 ; 76 FD EC
 altd or iy, de                 ; 76 DD EC
 altd or l                      ; 76 B5
 altd pop af                    ; 76 F1
 altd pop b                     ; 76 C1
 altd pop bc                    ; 76 C1
 altd pop d                     ; 76 D1
 altd pop de                    ; 76 D1
 altd pop h                     ; 76 E1
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
 altd rl (ix)                   ; 76 FD CB 00 16
 altd rl (ix+127)               ; 76 FD CB 7F 16
 altd rl (ix-128)               ; 76 FD CB 80 16
 altd rl (iy)                   ; 76 DD CB 00 16
 altd rl (iy+127)               ; 76 DD CB 7F 16
 altd rl (iy-128)               ; 76 DD CB 80 16
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
 altd rlc (ix)                  ; 76 FD CB 00 06
 altd rlc (ix+127)              ; 76 FD CB 7F 06
 altd rlc (ix-128)              ; 76 FD CB 80 06
 altd rlc (iy)                  ; 76 DD CB 00 06
 altd rlc (iy+127)              ; 76 DD CB 7F 06
 altd rlc (iy-128)              ; 76 DD CB 80 06
 altd rlc a                     ; 76 CB 07
 altd rlc b                     ; 76 CB 00
 altd rlc c                     ; 76 CB 01
 altd rlc d                     ; 76 CB 02
 altd rlc e                     ; 76 CB 03
 altd rlc h                     ; 76 CB 04
 altd rlc l                     ; 76 CB 05
 altd rlca                      ; 76 07
 altd rr (hl)                   ; 76 CB 1E
 altd rr (ix)                   ; 76 FD CB 00 1E
 altd rr (ix+127)               ; 76 FD CB 7F 1E
 altd rr (ix-128)               ; 76 FD CB 80 1E
 altd rr (iy)                   ; 76 DD CB 00 1E
 altd rr (iy+127)               ; 76 DD CB 7F 1E
 altd rr (iy-128)               ; 76 DD CB 80 1E
 altd rr a                      ; 76 CB 1F
 altd rr b                      ; 76 CB 18
 altd rr c                      ; 76 CB 19
 altd rr d                      ; 76 CB 1A
 altd rr de                     ; 76 FB
 altd rr e                      ; 76 CB 1B
 altd rr h                      ; 76 CB 1C
 altd rr hl                     ; 76 FC
 altd rr ix                     ; 76 FD FC
 altd rr iy                     ; 76 DD FC
 altd rr l                      ; 76 CB 1D
 altd rra                       ; 76 1F
 altd rrc (hl)                  ; 76 CB 0E
 altd rrc (ix)                  ; 76 FD CB 00 0E
 altd rrc (ix+127)              ; 76 FD CB 7F 0E
 altd rrc (ix-128)              ; 76 FD CB 80 0E
 altd rrc (iy)                  ; 76 DD CB 00 0E
 altd rrc (iy+127)              ; 76 DD CB 7F 0E
 altd rrc (iy-128)              ; 76 DD CB 80 0E
 altd rrc a                     ; 76 CB 0F
 altd rrc b                     ; 76 CB 08
 altd rrc c                     ; 76 CB 09
 altd rrc d                     ; 76 CB 0A
 altd rrc e                     ; 76 CB 0B
 altd rrc h                     ; 76 CB 0C
 altd rrc l                     ; 76 CB 0D
 altd rrca                      ; 76 0F
 altd sbc (hl)                  ; 76 9E
 altd sbc (ix)                  ; 76 FD 9E 00
 altd sbc (ix+127)              ; 76 FD 9E 7F
 altd sbc (ix-128)              ; 76 FD 9E 80
 altd sbc (iy)                  ; 76 DD 9E 00
 altd sbc (iy+127)              ; 76 DD 9E 7F
 altd sbc (iy-128)              ; 76 DD 9E 80
 altd sbc -128                  ; 76 DE 80
 altd sbc 127                   ; 76 DE 7F
 altd sbc 255                   ; 76 DE FF
 altd sbc a                     ; 76 9F
 altd sbc a, (hl)               ; 76 9E
 altd sbc a, (ix)               ; 76 FD 9E 00
 altd sbc a, (ix+127)           ; 76 FD 9E 7F
 altd sbc a, (ix-128)           ; 76 FD 9E 80
 altd sbc a, (iy)               ; 76 DD 9E 00
 altd sbc a, (iy+127)           ; 76 DD 9E 7F
 altd sbc a, (iy-128)           ; 76 DD 9E 80
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
 altd sla (ix)                  ; 76 FD CB 00 26
 altd sla (ix+127)              ; 76 FD CB 7F 26
 altd sla (ix-128)              ; 76 FD CB 80 26
 altd sla (iy)                  ; 76 DD CB 00 26
 altd sla (iy+127)              ; 76 DD CB 7F 26
 altd sla (iy-128)              ; 76 DD CB 80 26
 altd sla a                     ; 76 CB 27
 altd sla b                     ; 76 CB 20
 altd sla c                     ; 76 CB 21
 altd sla d                     ; 76 CB 22
 altd sla e                     ; 76 CB 23
 altd sla h                     ; 76 CB 24
 altd sla l                     ; 76 CB 25
 altd sra (hl)                  ; 76 CB 2E
 altd sra (ix)                  ; 76 FD CB 00 2E
 altd sra (ix+127)              ; 76 FD CB 7F 2E
 altd sra (ix-128)              ; 76 FD CB 80 2E
 altd sra (iy)                  ; 76 DD CB 00 2E
 altd sra (iy+127)              ; 76 DD CB 7F 2E
 altd sra (iy-128)              ; 76 DD CB 80 2E
 altd sra a                     ; 76 CB 2F
 altd sra b                     ; 76 CB 28
 altd sra c                     ; 76 CB 29
 altd sra d                     ; 76 CB 2A
 altd sra e                     ; 76 CB 2B
 altd sra h                     ; 76 CB 2C
 altd sra l                     ; 76 CB 2D
 altd srl (hl)                  ; 76 CB 3E
 altd srl (ix)                  ; 76 FD CB 00 3E
 altd srl (ix+127)              ; 76 FD CB 7F 3E
 altd srl (ix-128)              ; 76 FD CB 80 3E
 altd srl (iy)                  ; 76 DD CB 00 3E
 altd srl (iy+127)              ; 76 DD CB 7F 3E
 altd srl (iy-128)              ; 76 DD CB 80 3E
 altd srl a                     ; 76 CB 3F
 altd srl b                     ; 76 CB 38
 altd srl c                     ; 76 CB 39
 altd srl d                     ; 76 CB 3A
 altd srl e                     ; 76 CB 3B
 altd srl h                     ; 76 CB 3C
 altd srl l                     ; 76 CB 3D
 altd sub (hl)                  ; 76 96
 altd sub (ix)                  ; 76 FD 96 00
 altd sub (ix+127)              ; 76 FD 96 7F
 altd sub (ix-128)              ; 76 FD 96 80
 altd sub (iy)                  ; 76 DD 96 00
 altd sub (iy+127)              ; 76 DD 96 7F
 altd sub (iy-128)              ; 76 DD 96 80
 altd sub -128                  ; 76 D6 80
 altd sub 127                   ; 76 D6 7F
 altd sub 255                   ; 76 D6 FF
 altd sub a                     ; 76 97
 altd sub a, (hl)               ; 76 96
 altd sub a, (ix)               ; 76 FD 96 00
 altd sub a, (ix+127)           ; 76 FD 96 7F
 altd sub a, (ix-128)           ; 76 FD 96 80
 altd sub a, (iy)               ; 76 DD 96 00
 altd sub a, (iy+127)           ; 76 DD 96 7F
 altd sub a, (iy-128)           ; 76 DD 96 80
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
 altd sub m                     ; 76 96
 altd xor (hl)                  ; 76 AE
 altd xor (ix)                  ; 76 FD AE 00
 altd xor (ix+127)              ; 76 FD AE 7F
 altd xor (ix-128)              ; 76 FD AE 80
 altd xor (iy)                  ; 76 DD AE 00
 altd xor (iy+127)              ; 76 DD AE 7F
 altd xor (iy-128)              ; 76 DD AE 80
 altd xor -128                  ; 76 EE 80
 altd xor 127                   ; 76 EE 7F
 altd xor 255                   ; 76 EE FF
 altd xor a                     ; 76 AF
 altd xor a, (hl)               ; 76 AE
 altd xor a, (ix)               ; 76 FD AE 00
 altd xor a, (ix+127)           ; 76 FD AE 7F
 altd xor a, (ix-128)           ; 76 FD AE 80
 altd xor a, (iy)               ; 76 DD AE 00
 altd xor a, (iy+127)           ; 76 DD AE 7F
 altd xor a, (iy-128)           ; 76 DD AE 80
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
 and a', (hl)                   ; 76 A6
 and a', (ix)                   ; 76 FD A6 00
 and a', (ix+127)               ; 76 FD A6 7F
 and a', (ix-128)               ; 76 FD A6 80
 and a', (iy)                   ; 76 DD A6 00
 and a', (iy+127)               ; 76 DD A6 7F
 and a', (iy-128)               ; 76 DD A6 80
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
 and hl', de                    ; 76 DC
 and hl, de                     ; DC
 and ix, de                     ; FD DC
 and iy, de                     ; DD DC
 and l                          ; A5
 and.a hl, bc                   ; 7C A0 67 7D A1 6F
 and.a hl, de                   ; DC
 and.a ix, de                   ; FD DC
 and.a iy, de                   ; DD DC
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
 bool hl                        ; CC
 bool hl'                       ; 76 CC
 bool ix                        ; FD CC
 bool iy                        ; DD CC
 call -32768                    ; CD 00 80
 call 32767                     ; CD FF 7F
 call 65535                     ; CD FF FF
 call c, -32768                 ; 30 03 CD 00 80
 call c, 32767                  ; 30 03 CD FF 7F
 call c, 65535                  ; 30 03 CD FF FF
 call lo, -32768                ; E2 66 1B CD 00 80
 call lo, 32767                 ; E2 6C 1B CD FF 7F
 call lo, 65535                 ; E2 72 1B CD FF FF
 call lz, -32768                ; EA 78 1B CD 00 80
 call lz, 32767                 ; EA 7E 1B CD FF 7F
 call lz, 65535                 ; EA 84 1B CD FF FF
 call m, -32768                 ; F2 8A 1B CD 00 80
 call m, 32767                  ; F2 90 1B CD FF 7F
 call m, 65535                  ; F2 96 1B CD FF FF
 call nc, -32768                ; 38 03 CD 00 80
 call nc, 32767                 ; 38 03 CD FF 7F
 call nc, 65535                 ; 38 03 CD FF FF
 call nv, -32768                ; EA AB 1B CD 00 80
 call nv, 32767                 ; EA B1 1B CD FF 7F
 call nv, 65535                 ; EA B7 1B CD FF FF
 call nz, -32768                ; 28 03 CD 00 80
 call nz, 32767                 ; 28 03 CD FF 7F
 call nz, 65535                 ; 28 03 CD FF FF
 call p, -32768                 ; FA CC 1B CD 00 80
 call p, 32767                  ; FA D2 1B CD FF 7F
 call p, 65535                  ; FA D8 1B CD FF FF
 call pe, -32768                ; E2 DE 1B CD 00 80
 call pe, 32767                 ; E2 E4 1B CD FF 7F
 call pe, 65535                 ; E2 EA 1B CD FF FF
 call po, -32768                ; EA F0 1B CD 00 80
 call po, 32767                 ; EA F6 1B CD FF 7F
 call po, 65535                 ; EA FC 1B CD FF FF
 call v, -32768                 ; E2 02 1C CD 00 80
 call v, 32767                  ; E2 08 1C CD FF 7F
 call v, 65535                  ; E2 0E 1C CD FF FF
 call z, -32768                 ; 20 03 CD 00 80
 call z, 32767                  ; 20 03 CD FF 7F
 call z, 65535                  ; 20 03 CD FF FF
 cc -32768                      ; 30 03 CD 00 80
 cc 32767                       ; 30 03 CD FF 7F
 cc 65535                       ; 30 03 CD FF FF
 ccf                            ; 3F
 ccf'                           ; 76 3F
 clo -32768                     ; E2 35 1C CD 00 80
 clo 32767                      ; E2 3B 1C CD FF 7F
 clo 65535                      ; E2 41 1C CD FF FF
 clz -32768                     ; EA 47 1C CD 00 80
 clz 32767                      ; EA 4D 1C CD FF 7F
 clz 65535                      ; EA 53 1C CD FF FF
 cm -32768                      ; F2 59 1C CD 00 80
 cm 32767                       ; F2 5F 1C CD FF 7F
 cm 65535                       ; F2 65 1C CD FF FF
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
 cnc -32768                     ; 38 03 CD 00 80
 cnc 32767                      ; 38 03 CD FF 7F
 cnc 65535                      ; 38 03 CD FF FF
 cnv -32768                     ; EA BD 1C CD 00 80
 cnv 32767                      ; EA C3 1C CD FF 7F
 cnv 65535                      ; EA C9 1C CD FF FF
 cnz -32768                     ; 28 03 CD 00 80
 cnz 32767                      ; 28 03 CD FF 7F
 cnz 65535                      ; 28 03 CD FF FF
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
 cpd                            ; CD @__z80asm__cpd
 cpdr                           ; CD @__z80asm__cpdr
 cpe -32768                     ; E2 24 1D CD 00 80
 cpe 32767                      ; E2 2A 1D CD FF 7F
 cpe 65535                      ; E2 30 1D CD FF FF
 cpi                            ; CD @__z80asm__cpi
 cpi -128                       ; FE 80
 cpi 127                        ; FE 7F
 cpi 255                        ; FE FF
 cpir                           ; CD @__z80asm__cpir
 cpl                            ; 2F
 cpl a                          ; 2F
 cpl a'                         ; 76 2F
 cpo -32768                     ; EA 46 1D CD 00 80
 cpo 32767                      ; EA 4C 1D CD FF 7F
 cpo 65535                      ; EA 52 1D CD FF FF
 cv -32768                      ; E2 58 1D CD 00 80
 cv 32767                       ; E2 5E 1D CD FF 7F
 cv 65535                       ; E2 64 1D CD FF FF
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
 dec (ix)                       ; FD 35 00
 dec (ix+127)                   ; FD 35 7F
 dec (ix-128)                   ; FD 35 80
 dec (iy)                       ; DD 35 00
 dec (iy+127)                   ; DD 35 7F
 dec (iy-128)                   ; DD 35 80
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
 dec ix                         ; FD 2B
 dec iy                         ; DD 2B
 dec l                          ; 2D
 dec l'                         ; 76 2D
 dec sp                         ; 3B
 djnz ASMPC                     ; 10 FE
 djnz b', ASMPC                 ; 76 10 FE
 djnz b, ASMPC                  ; 10 FE
 dsub                           ; CD @__z80asm__sub_hl_bc
 ex (sp), hl                    ; ED 54
 ex (sp), hl'                   ; 76 ED 54
 ex (sp), ix                    ; FD E3
 ex (sp), iy                    ; DD E3
 ex af, af                      ; 08
 ex af, af'                     ; 08
 ex de', hl                     ; E3
 ex de', hl'                    ; 76 E3
 ex de, hl                      ; EB
 ex de, hl'                     ; 76 EB
 exx                            ; D9
 inc (hl)                       ; 34
 inc (ix)                       ; FD 34 00
 inc (ix+127)                   ; FD 34 7F
 inc (ix-128)                   ; FD 34 80
 inc (iy)                       ; DD 34 00
 inc (iy+127)                   ; DD 34 7F
 inc (iy-128)                   ; DD 34 80
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
 inc ix                         ; FD 23
 inc iy                         ; DD 23
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
 ioe adc (ix)                   ; DB FD 8E 00
 ioe adc (ix+127)               ; DB FD 8E 7F
 ioe adc (ix-128)               ; DB FD 8E 80
 ioe adc (iy)                   ; DB DD 8E 00
 ioe adc (iy+127)               ; DB DD 8E 7F
 ioe adc (iy-128)               ; DB DD 8E 80
 ioe adc a', (hl)               ; DB 76 8E
 ioe adc a', (ix)               ; DB 76 FD 8E 00
 ioe adc a', (ix+127)           ; DB 76 FD 8E 7F
 ioe adc a', (ix-128)           ; DB 76 FD 8E 80
 ioe adc a', (iy)               ; DB 76 DD 8E 00
 ioe adc a', (iy+127)           ; DB 76 DD 8E 7F
 ioe adc a', (iy-128)           ; DB 76 DD 8E 80
 ioe adc a, (hl)                ; DB 8E
 ioe adc a, (ix)                ; DB FD 8E 00
 ioe adc a, (ix+127)            ; DB FD 8E 7F
 ioe adc a, (ix-128)            ; DB FD 8E 80
 ioe adc a, (iy)                ; DB DD 8E 00
 ioe adc a, (iy+127)            ; DB DD 8E 7F
 ioe adc a, (iy-128)            ; DB DD 8E 80
 ioe add (hl)                   ; DB 86
 ioe add (ix)                   ; DB FD 86 00
 ioe add (ix+127)               ; DB FD 86 7F
 ioe add (ix-128)               ; DB FD 86 80
 ioe add (iy)                   ; DB DD 86 00
 ioe add (iy+127)               ; DB DD 86 7F
 ioe add (iy-128)               ; DB DD 86 80
 ioe add a', (hl)               ; DB 76 86
 ioe add a', (ix)               ; DB 76 FD 86 00
 ioe add a', (ix+127)           ; DB 76 FD 86 7F
 ioe add a', (ix-128)           ; DB 76 FD 86 80
 ioe add a', (iy)               ; DB 76 DD 86 00
 ioe add a', (iy+127)           ; DB 76 DD 86 7F
 ioe add a', (iy-128)           ; DB 76 DD 86 80
 ioe add a, (hl)                ; DB 86
 ioe add a, (ix)                ; DB FD 86 00
 ioe add a, (ix+127)            ; DB FD 86 7F
 ioe add a, (ix-128)            ; DB FD 86 80
 ioe add a, (iy)                ; DB DD 86 00
 ioe add a, (iy+127)            ; DB DD 86 7F
 ioe add a, (iy-128)            ; DB DD 86 80
 ioe altd adc (hl)              ; DB 76 8E
 ioe altd adc (ix)              ; DB 76 FD 8E 00
 ioe altd adc (ix+127)          ; DB 76 FD 8E 7F
 ioe altd adc (ix-128)          ; DB 76 FD 8E 80
 ioe altd adc (iy)              ; DB 76 DD 8E 00
 ioe altd adc (iy+127)          ; DB 76 DD 8E 7F
 ioe altd adc (iy-128)          ; DB 76 DD 8E 80
 ioe altd adc a, (hl)           ; DB 76 8E
 ioe altd adc a, (ix)           ; DB 76 FD 8E 00
 ioe altd adc a, (ix+127)       ; DB 76 FD 8E 7F
 ioe altd adc a, (ix-128)       ; DB 76 FD 8E 80
 ioe altd adc a, (iy)           ; DB 76 DD 8E 00
 ioe altd adc a, (iy+127)       ; DB 76 DD 8E 7F
 ioe altd adc a, (iy-128)       ; DB 76 DD 8E 80
 ioe altd add (hl)              ; DB 76 86
 ioe altd add (ix)              ; DB 76 FD 86 00
 ioe altd add (ix+127)          ; DB 76 FD 86 7F
 ioe altd add (ix-128)          ; DB 76 FD 86 80
 ioe altd add (iy)              ; DB 76 DD 86 00
 ioe altd add (iy+127)          ; DB 76 DD 86 7F
 ioe altd add (iy-128)          ; DB 76 DD 86 80
 ioe altd add a, (hl)           ; DB 76 86
 ioe altd add a, (ix)           ; DB 76 FD 86 00
 ioe altd add a, (ix+127)       ; DB 76 FD 86 7F
 ioe altd add a, (ix-128)       ; DB 76 FD 86 80
 ioe altd add a, (iy)           ; DB 76 DD 86 00
 ioe altd add a, (iy+127)       ; DB 76 DD 86 7F
 ioe altd add a, (iy-128)       ; DB 76 DD 86 80
 ioe altd and (hl)              ; DB 76 A6
 ioe altd and (ix)              ; DB 76 FD A6 00
 ioe altd and (ix+127)          ; DB 76 FD A6 7F
 ioe altd and (ix-128)          ; DB 76 FD A6 80
 ioe altd and (iy)              ; DB 76 DD A6 00
 ioe altd and (iy+127)          ; DB 76 DD A6 7F
 ioe altd and (iy-128)          ; DB 76 DD A6 80
 ioe altd and a, (hl)           ; DB 76 A6
 ioe altd and a, (ix)           ; DB 76 FD A6 00
 ioe altd and a, (ix+127)       ; DB 76 FD A6 7F
 ioe altd and a, (ix-128)       ; DB 76 FD A6 80
 ioe altd and a, (iy)           ; DB 76 DD A6 00
 ioe altd and a, (iy+127)       ; DB 76 DD A6 7F
 ioe altd and a, (iy-128)       ; DB 76 DD A6 80
 ioe altd bit 0, (hl)           ; DB 76 CB 46
 ioe altd bit 0, (ix)           ; DB 76 FD CB 00 46
 ioe altd bit 0, (ix+127)       ; DB 76 FD CB 7F 46
 ioe altd bit 0, (ix-128)       ; DB 76 FD CB 80 46
 ioe altd bit 0, (iy)           ; DB 76 DD CB 00 46
 ioe altd bit 0, (iy+127)       ; DB 76 DD CB 7F 46
 ioe altd bit 0, (iy-128)       ; DB 76 DD CB 80 46
 ioe altd bit 1, (hl)           ; DB 76 CB 4E
 ioe altd bit 1, (ix)           ; DB 76 FD CB 00 4E
 ioe altd bit 1, (ix+127)       ; DB 76 FD CB 7F 4E
 ioe altd bit 1, (ix-128)       ; DB 76 FD CB 80 4E
 ioe altd bit 1, (iy)           ; DB 76 DD CB 00 4E
 ioe altd bit 1, (iy+127)       ; DB 76 DD CB 7F 4E
 ioe altd bit 1, (iy-128)       ; DB 76 DD CB 80 4E
 ioe altd bit 2, (hl)           ; DB 76 CB 56
 ioe altd bit 2, (ix)           ; DB 76 FD CB 00 56
 ioe altd bit 2, (ix+127)       ; DB 76 FD CB 7F 56
 ioe altd bit 2, (ix-128)       ; DB 76 FD CB 80 56
 ioe altd bit 2, (iy)           ; DB 76 DD CB 00 56
 ioe altd bit 2, (iy+127)       ; DB 76 DD CB 7F 56
 ioe altd bit 2, (iy-128)       ; DB 76 DD CB 80 56
 ioe altd bit 3, (hl)           ; DB 76 CB 5E
 ioe altd bit 3, (ix)           ; DB 76 FD CB 00 5E
 ioe altd bit 3, (ix+127)       ; DB 76 FD CB 7F 5E
 ioe altd bit 3, (ix-128)       ; DB 76 FD CB 80 5E
 ioe altd bit 3, (iy)           ; DB 76 DD CB 00 5E
 ioe altd bit 3, (iy+127)       ; DB 76 DD CB 7F 5E
 ioe altd bit 3, (iy-128)       ; DB 76 DD CB 80 5E
 ioe altd bit 4, (hl)           ; DB 76 CB 66
 ioe altd bit 4, (ix)           ; DB 76 FD CB 00 66
 ioe altd bit 4, (ix+127)       ; DB 76 FD CB 7F 66
 ioe altd bit 4, (ix-128)       ; DB 76 FD CB 80 66
 ioe altd bit 4, (iy)           ; DB 76 DD CB 00 66
 ioe altd bit 4, (iy+127)       ; DB 76 DD CB 7F 66
 ioe altd bit 4, (iy-128)       ; DB 76 DD CB 80 66
 ioe altd bit 5, (hl)           ; DB 76 CB 6E
 ioe altd bit 5, (ix)           ; DB 76 FD CB 00 6E
 ioe altd bit 5, (ix+127)       ; DB 76 FD CB 7F 6E
 ioe altd bit 5, (ix-128)       ; DB 76 FD CB 80 6E
 ioe altd bit 5, (iy)           ; DB 76 DD CB 00 6E
 ioe altd bit 5, (iy+127)       ; DB 76 DD CB 7F 6E
 ioe altd bit 5, (iy-128)       ; DB 76 DD CB 80 6E
 ioe altd bit 6, (hl)           ; DB 76 CB 76
 ioe altd bit 6, (ix)           ; DB 76 FD CB 00 76
 ioe altd bit 6, (ix+127)       ; DB 76 FD CB 7F 76
 ioe altd bit 6, (ix-128)       ; DB 76 FD CB 80 76
 ioe altd bit 6, (iy)           ; DB 76 DD CB 00 76
 ioe altd bit 6, (iy+127)       ; DB 76 DD CB 7F 76
 ioe altd bit 6, (iy-128)       ; DB 76 DD CB 80 76
 ioe altd bit 7, (hl)           ; DB 76 CB 7E
 ioe altd bit 7, (ix)           ; DB 76 FD CB 00 7E
 ioe altd bit 7, (ix+127)       ; DB 76 FD CB 7F 7E
 ioe altd bit 7, (ix-128)       ; DB 76 FD CB 80 7E
 ioe altd bit 7, (iy)           ; DB 76 DD CB 00 7E
 ioe altd bit 7, (iy+127)       ; DB 76 DD CB 7F 7E
 ioe altd bit 7, (iy-128)       ; DB 76 DD CB 80 7E
 ioe altd cp (hl)               ; DB 76 BE
 ioe altd cp (ix)               ; DB 76 FD BE 00
 ioe altd cp (ix+127)           ; DB 76 FD BE 7F
 ioe altd cp (ix-128)           ; DB 76 FD BE 80
 ioe altd cp (iy)               ; DB 76 DD BE 00
 ioe altd cp (iy+127)           ; DB 76 DD BE 7F
 ioe altd cp (iy-128)           ; DB 76 DD BE 80
 ioe altd cp a, (hl)            ; DB 76 BE
 ioe altd cp a, (ix)            ; DB 76 FD BE 00
 ioe altd cp a, (ix+127)        ; DB 76 FD BE 7F
 ioe altd cp a, (ix-128)        ; DB 76 FD BE 80
 ioe altd cp a, (iy)            ; DB 76 DD BE 00
 ioe altd cp a, (iy+127)        ; DB 76 DD BE 7F
 ioe altd cp a, (iy-128)        ; DB 76 DD BE 80
 ioe altd dec (hl)              ; DB 76 35
 ioe altd dec (ix)              ; DB 76 FD 35 00
 ioe altd dec (ix+127)          ; DB 76 FD 35 7F
 ioe altd dec (ix-128)          ; DB 76 FD 35 80
 ioe altd dec (iy)              ; DB 76 DD 35 00
 ioe altd dec (iy+127)          ; DB 76 DD 35 7F
 ioe altd dec (iy-128)          ; DB 76 DD 35 80
 ioe altd inc (hl)              ; DB 76 34
 ioe altd inc (ix)              ; DB 76 FD 34 00
 ioe altd inc (ix+127)          ; DB 76 FD 34 7F
 ioe altd inc (ix-128)          ; DB 76 FD 34 80
 ioe altd inc (iy)              ; DB 76 DD 34 00
 ioe altd inc (iy+127)          ; DB 76 DD 34 7F
 ioe altd inc (iy-128)          ; DB 76 DD 34 80
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
 ioe altd ld a, (ix)            ; DB 76 FD 7E 00
 ioe altd ld a, (ix+127)        ; DB 76 FD 7E 7F
 ioe altd ld a, (ix-128)        ; DB 76 FD 7E 80
 ioe altd ld a, (iy)            ; DB 76 DD 7E 00
 ioe altd ld a, (iy+127)        ; DB 76 DD 7E 7F
 ioe altd ld a, (iy-128)        ; DB 76 DD 7E 80
 ioe altd ld b, (hl)            ; DB 76 46
 ioe altd ld b, (ix)            ; DB 76 FD 46 00
 ioe altd ld b, (ix+127)        ; DB 76 FD 46 7F
 ioe altd ld b, (ix-128)        ; DB 76 FD 46 80
 ioe altd ld b, (iy)            ; DB 76 DD 46 00
 ioe altd ld b, (iy+127)        ; DB 76 DD 46 7F
 ioe altd ld b, (iy-128)        ; DB 76 DD 46 80
 ioe altd ld bc, (-32768)       ; DB 76 ED 4B 00 80
 ioe altd ld bc, (32767)        ; DB 76 ED 4B FF 7F
 ioe altd ld bc, (65535)        ; DB 76 ED 4B FF FF
 ioe altd ld c, (hl)            ; DB 76 4E
 ioe altd ld c, (ix)            ; DB 76 FD 4E 00
 ioe altd ld c, (ix+127)        ; DB 76 FD 4E 7F
 ioe altd ld c, (ix-128)        ; DB 76 FD 4E 80
 ioe altd ld c, (iy)            ; DB 76 DD 4E 00
 ioe altd ld c, (iy+127)        ; DB 76 DD 4E 7F
 ioe altd ld c, (iy-128)        ; DB 76 DD 4E 80
 ioe altd ld d, (hl)            ; DB 76 56
 ioe altd ld d, (ix)            ; DB 76 FD 56 00
 ioe altd ld d, (ix+127)        ; DB 76 FD 56 7F
 ioe altd ld d, (ix-128)        ; DB 76 FD 56 80
 ioe altd ld d, (iy)            ; DB 76 DD 56 00
 ioe altd ld d, (iy+127)        ; DB 76 DD 56 7F
 ioe altd ld d, (iy-128)        ; DB 76 DD 56 80
 ioe altd ld de, (-32768)       ; DB 76 ED 5B 00 80
 ioe altd ld de, (32767)        ; DB 76 ED 5B FF 7F
 ioe altd ld de, (65535)        ; DB 76 ED 5B FF FF
 ioe altd ld e, (hl)            ; DB 76 5E
 ioe altd ld e, (ix)            ; DB 76 FD 5E 00
 ioe altd ld e, (ix+127)        ; DB 76 FD 5E 7F
 ioe altd ld e, (ix-128)        ; DB 76 FD 5E 80
 ioe altd ld e, (iy)            ; DB 76 DD 5E 00
 ioe altd ld e, (iy+127)        ; DB 76 DD 5E 7F
 ioe altd ld e, (iy-128)        ; DB 76 DD 5E 80
 ioe altd ld h, (hl)            ; DB 76 66
 ioe altd ld h, (ix)            ; DB 76 FD 66 00
 ioe altd ld h, (ix+127)        ; DB 76 FD 66 7F
 ioe altd ld h, (ix-128)        ; DB 76 FD 66 80
 ioe altd ld h, (iy)            ; DB 76 DD 66 00
 ioe altd ld h, (iy+127)        ; DB 76 DD 66 7F
 ioe altd ld h, (iy-128)        ; DB 76 DD 66 80
 ioe altd ld hl, (-32768)       ; DB 76 2A 00 80
 ioe altd ld hl, (32767)        ; DB 76 2A FF 7F
 ioe altd ld hl, (65535)        ; DB 76 2A FF FF
 ioe altd ld hl, (hl)           ; DB 76 DD E4 00
 ioe altd ld hl, (hl+127)       ; DB 76 DD E4 7F
 ioe altd ld hl, (hl-128)       ; DB 76 DD E4 80
 ioe altd ld hl, (ix)           ; DB 76 FD E4 00
 ioe altd ld hl, (ix+127)       ; DB 76 FD E4 7F
 ioe altd ld hl, (ix-128)       ; DB 76 FD E4 80
 ioe altd ld hl, (iy)           ; DB 76 E4 00
 ioe altd ld hl, (iy+127)       ; DB 76 E4 7F
 ioe altd ld hl, (iy-128)       ; DB 76 E4 80
 ioe altd ld l, (hl)            ; DB 76 6E
 ioe altd ld l, (ix)            ; DB 76 FD 6E 00
 ioe altd ld l, (ix+127)        ; DB 76 FD 6E 7F
 ioe altd ld l, (ix-128)        ; DB 76 FD 6E 80
 ioe altd ld l, (iy)            ; DB 76 DD 6E 00
 ioe altd ld l, (iy+127)        ; DB 76 DD 6E 7F
 ioe altd ld l, (iy-128)        ; DB 76 DD 6E 80
 ioe altd or (hl)               ; DB 76 B6
 ioe altd or (ix)               ; DB 76 FD B6 00
 ioe altd or (ix+127)           ; DB 76 FD B6 7F
 ioe altd or (ix-128)           ; DB 76 FD B6 80
 ioe altd or (iy)               ; DB 76 DD B6 00
 ioe altd or (iy+127)           ; DB 76 DD B6 7F
 ioe altd or (iy-128)           ; DB 76 DD B6 80
 ioe altd or a, (hl)            ; DB 76 B6
 ioe altd or a, (ix)            ; DB 76 FD B6 00
 ioe altd or a, (ix+127)        ; DB 76 FD B6 7F
 ioe altd or a, (ix-128)        ; DB 76 FD B6 80
 ioe altd or a, (iy)            ; DB 76 DD B6 00
 ioe altd or a, (iy+127)        ; DB 76 DD B6 7F
 ioe altd or a, (iy-128)        ; DB 76 DD B6 80
 ioe altd rl (hl)               ; DB 76 CB 16
 ioe altd rl (ix)               ; DB 76 FD CB 00 16
 ioe altd rl (ix+127)           ; DB 76 FD CB 7F 16
 ioe altd rl (ix-128)           ; DB 76 FD CB 80 16
 ioe altd rl (iy)               ; DB 76 DD CB 00 16
 ioe altd rl (iy+127)           ; DB 76 DD CB 7F 16
 ioe altd rl (iy-128)           ; DB 76 DD CB 80 16
 ioe altd rlc (hl)              ; DB 76 CB 06
 ioe altd rlc (ix)              ; DB 76 FD CB 00 06
 ioe altd rlc (ix+127)          ; DB 76 FD CB 7F 06
 ioe altd rlc (ix-128)          ; DB 76 FD CB 80 06
 ioe altd rlc (iy)              ; DB 76 DD CB 00 06
 ioe altd rlc (iy+127)          ; DB 76 DD CB 7F 06
 ioe altd rlc (iy-128)          ; DB 76 DD CB 80 06
 ioe altd rr (hl)               ; DB 76 CB 1E
 ioe altd rr (ix)               ; DB 76 FD CB 00 1E
 ioe altd rr (ix+127)           ; DB 76 FD CB 7F 1E
 ioe altd rr (ix-128)           ; DB 76 FD CB 80 1E
 ioe altd rr (iy)               ; DB 76 DD CB 00 1E
 ioe altd rr (iy+127)           ; DB 76 DD CB 7F 1E
 ioe altd rr (iy-128)           ; DB 76 DD CB 80 1E
 ioe altd rrc (hl)              ; DB 76 CB 0E
 ioe altd rrc (ix)              ; DB 76 FD CB 00 0E
 ioe altd rrc (ix+127)          ; DB 76 FD CB 7F 0E
 ioe altd rrc (ix-128)          ; DB 76 FD CB 80 0E
 ioe altd rrc (iy)              ; DB 76 DD CB 00 0E
 ioe altd rrc (iy+127)          ; DB 76 DD CB 7F 0E
 ioe altd rrc (iy-128)          ; DB 76 DD CB 80 0E
 ioe altd sbc (hl)              ; DB 76 9E
 ioe altd sbc (ix)              ; DB 76 FD 9E 00
 ioe altd sbc (ix+127)          ; DB 76 FD 9E 7F
 ioe altd sbc (ix-128)          ; DB 76 FD 9E 80
 ioe altd sbc (iy)              ; DB 76 DD 9E 00
 ioe altd sbc (iy+127)          ; DB 76 DD 9E 7F
 ioe altd sbc (iy-128)          ; DB 76 DD 9E 80
 ioe altd sbc a, (hl)           ; DB 76 9E
 ioe altd sbc a, (ix)           ; DB 76 FD 9E 00
 ioe altd sbc a, (ix+127)       ; DB 76 FD 9E 7F
 ioe altd sbc a, (ix-128)       ; DB 76 FD 9E 80
 ioe altd sbc a, (iy)           ; DB 76 DD 9E 00
 ioe altd sbc a, (iy+127)       ; DB 76 DD 9E 7F
 ioe altd sbc a, (iy-128)       ; DB 76 DD 9E 80
 ioe altd sla (hl)              ; DB 76 CB 26
 ioe altd sla (ix)              ; DB 76 FD CB 00 26
 ioe altd sla (ix+127)          ; DB 76 FD CB 7F 26
 ioe altd sla (ix-128)          ; DB 76 FD CB 80 26
 ioe altd sla (iy)              ; DB 76 DD CB 00 26
 ioe altd sla (iy+127)          ; DB 76 DD CB 7F 26
 ioe altd sla (iy-128)          ; DB 76 DD CB 80 26
 ioe altd sra (hl)              ; DB 76 CB 2E
 ioe altd sra (ix)              ; DB 76 FD CB 00 2E
 ioe altd sra (ix+127)          ; DB 76 FD CB 7F 2E
 ioe altd sra (ix-128)          ; DB 76 FD CB 80 2E
 ioe altd sra (iy)              ; DB 76 DD CB 00 2E
 ioe altd sra (iy+127)          ; DB 76 DD CB 7F 2E
 ioe altd sra (iy-128)          ; DB 76 DD CB 80 2E
 ioe altd srl (hl)              ; DB 76 CB 3E
 ioe altd srl (ix)              ; DB 76 FD CB 00 3E
 ioe altd srl (ix+127)          ; DB 76 FD CB 7F 3E
 ioe altd srl (ix-128)          ; DB 76 FD CB 80 3E
 ioe altd srl (iy)              ; DB 76 DD CB 00 3E
 ioe altd srl (iy+127)          ; DB 76 DD CB 7F 3E
 ioe altd srl (iy-128)          ; DB 76 DD CB 80 3E
 ioe altd sub (hl)              ; DB 76 96
 ioe altd sub (ix)              ; DB 76 FD 96 00
 ioe altd sub (ix+127)          ; DB 76 FD 96 7F
 ioe altd sub (ix-128)          ; DB 76 FD 96 80
 ioe altd sub (iy)              ; DB 76 DD 96 00
 ioe altd sub (iy+127)          ; DB 76 DD 96 7F
 ioe altd sub (iy-128)          ; DB 76 DD 96 80
 ioe altd sub a, (hl)           ; DB 76 96
 ioe altd sub a, (ix)           ; DB 76 FD 96 00
 ioe altd sub a, (ix+127)       ; DB 76 FD 96 7F
 ioe altd sub a, (ix-128)       ; DB 76 FD 96 80
 ioe altd sub a, (iy)           ; DB 76 DD 96 00
 ioe altd sub a, (iy+127)       ; DB 76 DD 96 7F
 ioe altd sub a, (iy-128)       ; DB 76 DD 96 80
 ioe altd xor (hl)              ; DB 76 AE
 ioe altd xor (ix)              ; DB 76 FD AE 00
 ioe altd xor (ix+127)          ; DB 76 FD AE 7F
 ioe altd xor (ix-128)          ; DB 76 FD AE 80
 ioe altd xor (iy)              ; DB 76 DD AE 00
 ioe altd xor (iy+127)          ; DB 76 DD AE 7F
 ioe altd xor (iy-128)          ; DB 76 DD AE 80
 ioe altd xor a, (hl)           ; DB 76 AE
 ioe altd xor a, (ix)           ; DB 76 FD AE 00
 ioe altd xor a, (ix+127)       ; DB 76 FD AE 7F
 ioe altd xor a, (ix-128)       ; DB 76 FD AE 80
 ioe altd xor a, (iy)           ; DB 76 DD AE 00
 ioe altd xor a, (iy+127)       ; DB 76 DD AE 7F
 ioe altd xor a, (iy-128)       ; DB 76 DD AE 80
 ioe and (hl)                   ; DB A6
 ioe and (ix)                   ; DB FD A6 00
 ioe and (ix+127)               ; DB FD A6 7F
 ioe and (ix-128)               ; DB FD A6 80
 ioe and (iy)                   ; DB DD A6 00
 ioe and (iy+127)               ; DB DD A6 7F
 ioe and (iy-128)               ; DB DD A6 80
 ioe and a', (hl)               ; DB 76 A6
 ioe and a', (ix)               ; DB 76 FD A6 00
 ioe and a', (ix+127)           ; DB 76 FD A6 7F
 ioe and a', (ix-128)           ; DB 76 FD A6 80
 ioe and a', (iy)               ; DB 76 DD A6 00
 ioe and a', (iy+127)           ; DB 76 DD A6 7F
 ioe and a', (iy-128)           ; DB 76 DD A6 80
 ioe and a, (hl)                ; DB A6
 ioe and a, (ix)                ; DB FD A6 00
 ioe and a, (ix+127)            ; DB FD A6 7F
 ioe and a, (ix-128)            ; DB FD A6 80
 ioe and a, (iy)                ; DB DD A6 00
 ioe and a, (iy+127)            ; DB DD A6 7F
 ioe and a, (iy-128)            ; DB DD A6 80
 ioe bit 0, (hl)                ; DB CB 46
 ioe bit 0, (ix)                ; DB FD CB 00 46
 ioe bit 0, (ix+127)            ; DB FD CB 7F 46
 ioe bit 0, (ix-128)            ; DB FD CB 80 46
 ioe bit 0, (iy)                ; DB DD CB 00 46
 ioe bit 0, (iy+127)            ; DB DD CB 7F 46
 ioe bit 0, (iy-128)            ; DB DD CB 80 46
 ioe bit 1, (hl)                ; DB CB 4E
 ioe bit 1, (ix)                ; DB FD CB 00 4E
 ioe bit 1, (ix+127)            ; DB FD CB 7F 4E
 ioe bit 1, (ix-128)            ; DB FD CB 80 4E
 ioe bit 1, (iy)                ; DB DD CB 00 4E
 ioe bit 1, (iy+127)            ; DB DD CB 7F 4E
 ioe bit 1, (iy-128)            ; DB DD CB 80 4E
 ioe bit 2, (hl)                ; DB CB 56
 ioe bit 2, (ix)                ; DB FD CB 00 56
 ioe bit 2, (ix+127)            ; DB FD CB 7F 56
 ioe bit 2, (ix-128)            ; DB FD CB 80 56
 ioe bit 2, (iy)                ; DB DD CB 00 56
 ioe bit 2, (iy+127)            ; DB DD CB 7F 56
 ioe bit 2, (iy-128)            ; DB DD CB 80 56
 ioe bit 3, (hl)                ; DB CB 5E
 ioe bit 3, (ix)                ; DB FD CB 00 5E
 ioe bit 3, (ix+127)            ; DB FD CB 7F 5E
 ioe bit 3, (ix-128)            ; DB FD CB 80 5E
 ioe bit 3, (iy)                ; DB DD CB 00 5E
 ioe bit 3, (iy+127)            ; DB DD CB 7F 5E
 ioe bit 3, (iy-128)            ; DB DD CB 80 5E
 ioe bit 4, (hl)                ; DB CB 66
 ioe bit 4, (ix)                ; DB FD CB 00 66
 ioe bit 4, (ix+127)            ; DB FD CB 7F 66
 ioe bit 4, (ix-128)            ; DB FD CB 80 66
 ioe bit 4, (iy)                ; DB DD CB 00 66
 ioe bit 4, (iy+127)            ; DB DD CB 7F 66
 ioe bit 4, (iy-128)            ; DB DD CB 80 66
 ioe bit 5, (hl)                ; DB CB 6E
 ioe bit 5, (ix)                ; DB FD CB 00 6E
 ioe bit 5, (ix+127)            ; DB FD CB 7F 6E
 ioe bit 5, (ix-128)            ; DB FD CB 80 6E
 ioe bit 5, (iy)                ; DB DD CB 00 6E
 ioe bit 5, (iy+127)            ; DB DD CB 7F 6E
 ioe bit 5, (iy-128)            ; DB DD CB 80 6E
 ioe bit 6, (hl)                ; DB CB 76
 ioe bit 6, (ix)                ; DB FD CB 00 76
 ioe bit 6, (ix+127)            ; DB FD CB 7F 76
 ioe bit 6, (ix-128)            ; DB FD CB 80 76
 ioe bit 6, (iy)                ; DB DD CB 00 76
 ioe bit 6, (iy+127)            ; DB DD CB 7F 76
 ioe bit 6, (iy-128)            ; DB DD CB 80 76
 ioe bit 7, (hl)                ; DB CB 7E
 ioe bit 7, (ix)                ; DB FD CB 00 7E
 ioe bit 7, (ix+127)            ; DB FD CB 7F 7E
 ioe bit 7, (ix-128)            ; DB FD CB 80 7E
 ioe bit 7, (iy)                ; DB DD CB 00 7E
 ioe bit 7, (iy+127)            ; DB DD CB 7F 7E
 ioe bit 7, (iy-128)            ; DB DD CB 80 7E
 ioe bit.a 0, (hl)              ; DB CB 46
 ioe bit.a 0, (ix)              ; DB FD CB 00 46
 ioe bit.a 0, (ix+127)          ; DB FD CB 7F 46
 ioe bit.a 0, (ix-128)          ; DB FD CB 80 46
 ioe bit.a 0, (iy)              ; DB DD CB 00 46
 ioe bit.a 0, (iy+127)          ; DB DD CB 7F 46
 ioe bit.a 0, (iy-128)          ; DB DD CB 80 46
 ioe bit.a 1, (hl)              ; DB CB 4E
 ioe bit.a 1, (ix)              ; DB FD CB 00 4E
 ioe bit.a 1, (ix+127)          ; DB FD CB 7F 4E
 ioe bit.a 1, (ix-128)          ; DB FD CB 80 4E
 ioe bit.a 1, (iy)              ; DB DD CB 00 4E
 ioe bit.a 1, (iy+127)          ; DB DD CB 7F 4E
 ioe bit.a 1, (iy-128)          ; DB DD CB 80 4E
 ioe bit.a 2, (hl)              ; DB CB 56
 ioe bit.a 2, (ix)              ; DB FD CB 00 56
 ioe bit.a 2, (ix+127)          ; DB FD CB 7F 56
 ioe bit.a 2, (ix-128)          ; DB FD CB 80 56
 ioe bit.a 2, (iy)              ; DB DD CB 00 56
 ioe bit.a 2, (iy+127)          ; DB DD CB 7F 56
 ioe bit.a 2, (iy-128)          ; DB DD CB 80 56
 ioe bit.a 3, (hl)              ; DB CB 5E
 ioe bit.a 3, (ix)              ; DB FD CB 00 5E
 ioe bit.a 3, (ix+127)          ; DB FD CB 7F 5E
 ioe bit.a 3, (ix-128)          ; DB FD CB 80 5E
 ioe bit.a 3, (iy)              ; DB DD CB 00 5E
 ioe bit.a 3, (iy+127)          ; DB DD CB 7F 5E
 ioe bit.a 3, (iy-128)          ; DB DD CB 80 5E
 ioe bit.a 4, (hl)              ; DB CB 66
 ioe bit.a 4, (ix)              ; DB FD CB 00 66
 ioe bit.a 4, (ix+127)          ; DB FD CB 7F 66
 ioe bit.a 4, (ix-128)          ; DB FD CB 80 66
 ioe bit.a 4, (iy)              ; DB DD CB 00 66
 ioe bit.a 4, (iy+127)          ; DB DD CB 7F 66
 ioe bit.a 4, (iy-128)          ; DB DD CB 80 66
 ioe bit.a 5, (hl)              ; DB CB 6E
 ioe bit.a 5, (ix)              ; DB FD CB 00 6E
 ioe bit.a 5, (ix+127)          ; DB FD CB 7F 6E
 ioe bit.a 5, (ix-128)          ; DB FD CB 80 6E
 ioe bit.a 5, (iy)              ; DB DD CB 00 6E
 ioe bit.a 5, (iy+127)          ; DB DD CB 7F 6E
 ioe bit.a 5, (iy-128)          ; DB DD CB 80 6E
 ioe bit.a 6, (hl)              ; DB CB 76
 ioe bit.a 6, (ix)              ; DB FD CB 00 76
 ioe bit.a 6, (ix+127)          ; DB FD CB 7F 76
 ioe bit.a 6, (ix-128)          ; DB FD CB 80 76
 ioe bit.a 6, (iy)              ; DB DD CB 00 76
 ioe bit.a 6, (iy+127)          ; DB DD CB 7F 76
 ioe bit.a 6, (iy-128)          ; DB DD CB 80 76
 ioe bit.a 7, (hl)              ; DB CB 7E
 ioe bit.a 7, (ix)              ; DB FD CB 00 7E
 ioe bit.a 7, (ix+127)          ; DB FD CB 7F 7E
 ioe bit.a 7, (ix-128)          ; DB FD CB 80 7E
 ioe bit.a 7, (iy)              ; DB DD CB 00 7E
 ioe bit.a 7, (iy+127)          ; DB DD CB 7F 7E
 ioe bit.a 7, (iy-128)          ; DB DD CB 80 7E
 ioe cmp (hl)                   ; DB BE
 ioe cmp (ix)                   ; DB FD BE 00
 ioe cmp (ix+127)               ; DB FD BE 7F
 ioe cmp (ix-128)               ; DB FD BE 80
 ioe cmp (iy)                   ; DB DD BE 00
 ioe cmp (iy+127)               ; DB DD BE 7F
 ioe cmp (iy-128)               ; DB DD BE 80
 ioe cmp a, (hl)                ; DB BE
 ioe cmp a, (ix)                ; DB FD BE 00
 ioe cmp a, (ix+127)            ; DB FD BE 7F
 ioe cmp a, (ix-128)            ; DB FD BE 80
 ioe cmp a, (iy)                ; DB DD BE 00
 ioe cmp a, (iy+127)            ; DB DD BE 7F
 ioe cmp a, (iy-128)            ; DB DD BE 80
 ioe cp (hl)                    ; DB BE
 ioe cp (ix)                    ; DB FD BE 00
 ioe cp (ix+127)                ; DB FD BE 7F
 ioe cp (ix-128)                ; DB FD BE 80
 ioe cp (iy)                    ; DB DD BE 00
 ioe cp (iy+127)                ; DB DD BE 7F
 ioe cp (iy-128)                ; DB DD BE 80
 ioe cp a, (hl)                 ; DB BE
 ioe cp a, (ix)                 ; DB FD BE 00
 ioe cp a, (ix+127)             ; DB FD BE 7F
 ioe cp a, (ix-128)             ; DB FD BE 80
 ioe cp a, (iy)                 ; DB DD BE 00
 ioe cp a, (iy+127)             ; DB DD BE 7F
 ioe cp a, (iy-128)             ; DB DD BE 80
 ioe dec (hl)                   ; DB 35
 ioe dec (ix)                   ; DB FD 35 00
 ioe dec (ix+127)               ; DB FD 35 7F
 ioe dec (ix-128)               ; DB FD 35 80
 ioe dec (iy)                   ; DB DD 35 00
 ioe dec (iy+127)               ; DB DD 35 7F
 ioe dec (iy-128)               ; DB DD 35 80
 ioe inc (hl)                   ; DB 34
 ioe inc (ix)                   ; DB FD 34 00
 ioe inc (ix+127)               ; DB FD 34 7F
 ioe inc (ix-128)               ; DB FD 34 80
 ioe inc (iy)                   ; DB DD 34 00
 ioe inc (iy+127)               ; DB DD 34 7F
 ioe inc (iy-128)               ; DB DD 34 80
 ioe ld (-32768), a             ; DB 32 00 80
 ioe ld (-32768), bc            ; DB ED 43 00 80
 ioe ld (-32768), de            ; DB ED 53 00 80
 ioe ld (-32768), hl            ; DB 22 00 80
 ioe ld (-32768), ix            ; DB FD 22 00 80
 ioe ld (-32768), iy            ; DB DD 22 00 80
 ioe ld (-32768), sp            ; DB ED 73 00 80
 ioe ld (32767), a              ; DB 32 FF 7F
 ioe ld (32767), bc             ; DB ED 43 FF 7F
 ioe ld (32767), de             ; DB ED 53 FF 7F
 ioe ld (32767), hl             ; DB 22 FF 7F
 ioe ld (32767), ix             ; DB FD 22 FF 7F
 ioe ld (32767), iy             ; DB DD 22 FF 7F
 ioe ld (32767), sp             ; DB ED 73 FF 7F
 ioe ld (65535), a              ; DB 32 FF FF
 ioe ld (65535), bc             ; DB ED 43 FF FF
 ioe ld (65535), de             ; DB ED 53 FF FF
 ioe ld (65535), hl             ; DB 22 FF FF
 ioe ld (65535), ix             ; DB FD 22 FF FF
 ioe ld (65535), iy             ; DB DD 22 FF FF
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
 ioe ld (hl+), a                ; DB 77 23
 ioe ld (hl+127), hl            ; DB DD F4 7F
 ioe ld (hl-), a                ; DB 77 2B
 ioe ld (hl-128), hl            ; DB DD F4 80
 ioe ld (hld), a                ; DB 77 2B
 ioe ld (hli), a                ; DB 77 23
 ioe ld (ix), -128              ; DB FD 36 00 80
 ioe ld (ix), 127               ; DB FD 36 00 7F
 ioe ld (ix), 255               ; DB FD 36 00 FF
 ioe ld (ix), a                 ; DB FD 77 00
 ioe ld (ix), b                 ; DB FD 70 00
 ioe ld (ix), c                 ; DB FD 71 00
 ioe ld (ix), d                 ; DB FD 72 00
 ioe ld (ix), e                 ; DB FD 73 00
 ioe ld (ix), h                 ; DB FD 74 00
 ioe ld (ix), hl                ; DB FD F4 00
 ioe ld (ix), l                 ; DB FD 75 00
 ioe ld (ix+127), -128          ; DB FD 36 7F 80
 ioe ld (ix+127), 127           ; DB FD 36 7F 7F
 ioe ld (ix+127), 255           ; DB FD 36 7F FF
 ioe ld (ix+127), a             ; DB FD 77 7F
 ioe ld (ix+127), b             ; DB FD 70 7F
 ioe ld (ix+127), c             ; DB FD 71 7F
 ioe ld (ix+127), d             ; DB FD 72 7F
 ioe ld (ix+127), e             ; DB FD 73 7F
 ioe ld (ix+127), h             ; DB FD 74 7F
 ioe ld (ix+127), hl            ; DB FD F4 7F
 ioe ld (ix+127), l             ; DB FD 75 7F
 ioe ld (ix-128), -128          ; DB FD 36 80 80
 ioe ld (ix-128), 127           ; DB FD 36 80 7F
 ioe ld (ix-128), 255           ; DB FD 36 80 FF
 ioe ld (ix-128), a             ; DB FD 77 80
 ioe ld (ix-128), b             ; DB FD 70 80
 ioe ld (ix-128), c             ; DB FD 71 80
 ioe ld (ix-128), d             ; DB FD 72 80
 ioe ld (ix-128), e             ; DB FD 73 80
 ioe ld (ix-128), h             ; DB FD 74 80
 ioe ld (ix-128), hl            ; DB FD F4 80
 ioe ld (ix-128), l             ; DB FD 75 80
 ioe ld (iy), -128              ; DB DD 36 00 80
 ioe ld (iy), 127               ; DB DD 36 00 7F
 ioe ld (iy), 255               ; DB DD 36 00 FF
 ioe ld (iy), a                 ; DB DD 77 00
 ioe ld (iy), b                 ; DB DD 70 00
 ioe ld (iy), c                 ; DB DD 71 00
 ioe ld (iy), d                 ; DB DD 72 00
 ioe ld (iy), e                 ; DB DD 73 00
 ioe ld (iy), h                 ; DB DD 74 00
 ioe ld (iy), hl                ; DB F4 00
 ioe ld (iy), l                 ; DB DD 75 00
 ioe ld (iy+127), -128          ; DB DD 36 7F 80
 ioe ld (iy+127), 127           ; DB DD 36 7F 7F
 ioe ld (iy+127), 255           ; DB DD 36 7F FF
 ioe ld (iy+127), a             ; DB DD 77 7F
 ioe ld (iy+127), b             ; DB DD 70 7F
 ioe ld (iy+127), c             ; DB DD 71 7F
 ioe ld (iy+127), d             ; DB DD 72 7F
 ioe ld (iy+127), e             ; DB DD 73 7F
 ioe ld (iy+127), h             ; DB DD 74 7F
 ioe ld (iy+127), hl            ; DB F4 7F
 ioe ld (iy+127), l             ; DB DD 75 7F
 ioe ld (iy-128), -128          ; DB DD 36 80 80
 ioe ld (iy-128), 127           ; DB DD 36 80 7F
 ioe ld (iy-128), 255           ; DB DD 36 80 FF
 ioe ld (iy-128), a             ; DB DD 77 80
 ioe ld (iy-128), b             ; DB DD 70 80
 ioe ld (iy-128), c             ; DB DD 71 80
 ioe ld (iy-128), d             ; DB DD 72 80
 ioe ld (iy-128), e             ; DB DD 73 80
 ioe ld (iy-128), h             ; DB DD 74 80
 ioe ld (iy-128), hl            ; DB F4 80
 ioe ld (iy-128), l             ; DB DD 75 80
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
 ioe ld a', (ix)                ; DB 76 FD 7E 00
 ioe ld a', (ix+127)            ; DB 76 FD 7E 7F
 ioe ld a', (ix-128)            ; DB 76 FD 7E 80
 ioe ld a', (iy)                ; DB 76 DD 7E 00
 ioe ld a', (iy+127)            ; DB 76 DD 7E 7F
 ioe ld a', (iy-128)            ; DB 76 DD 7E 80
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
 ioe ld a, (ix)                 ; DB FD 7E 00
 ioe ld a, (ix+127)             ; DB FD 7E 7F
 ioe ld a, (ix-128)             ; DB FD 7E 80
 ioe ld a, (iy)                 ; DB DD 7E 00
 ioe ld a, (iy+127)             ; DB DD 7E 7F
 ioe ld a, (iy-128)             ; DB DD 7E 80
 ioe ld b', (hl)                ; DB 76 46
 ioe ld b', (ix)                ; DB 76 FD 46 00
 ioe ld b', (ix+127)            ; DB 76 FD 46 7F
 ioe ld b', (ix-128)            ; DB 76 FD 46 80
 ioe ld b', (iy)                ; DB 76 DD 46 00
 ioe ld b', (iy+127)            ; DB 76 DD 46 7F
 ioe ld b', (iy-128)            ; DB 76 DD 46 80
 ioe ld b, (hl)                 ; DB 46
 ioe ld b, (ix)                 ; DB FD 46 00
 ioe ld b, (ix+127)             ; DB FD 46 7F
 ioe ld b, (ix-128)             ; DB FD 46 80
 ioe ld b, (iy)                 ; DB DD 46 00
 ioe ld b, (iy+127)             ; DB DD 46 7F
 ioe ld b, (iy-128)             ; DB DD 46 80
 ioe ld bc', (-32768)           ; DB 76 ED 4B 00 80
 ioe ld bc', (32767)            ; DB 76 ED 4B FF 7F
 ioe ld bc', (65535)            ; DB 76 ED 4B FF FF
 ioe ld bc, (-32768)            ; DB ED 4B 00 80
 ioe ld bc, (32767)             ; DB ED 4B FF 7F
 ioe ld bc, (65535)             ; DB ED 4B FF FF
 ioe ld c', (hl)                ; DB 76 4E
 ioe ld c', (ix)                ; DB 76 FD 4E 00
 ioe ld c', (ix+127)            ; DB 76 FD 4E 7F
 ioe ld c', (ix-128)            ; DB 76 FD 4E 80
 ioe ld c', (iy)                ; DB 76 DD 4E 00
 ioe ld c', (iy+127)            ; DB 76 DD 4E 7F
 ioe ld c', (iy-128)            ; DB 76 DD 4E 80
 ioe ld c, (hl)                 ; DB 4E
 ioe ld c, (ix)                 ; DB FD 4E 00
 ioe ld c, (ix+127)             ; DB FD 4E 7F
 ioe ld c, (ix-128)             ; DB FD 4E 80
 ioe ld c, (iy)                 ; DB DD 4E 00
 ioe ld c, (iy+127)             ; DB DD 4E 7F
 ioe ld c, (iy-128)             ; DB DD 4E 80
 ioe ld d', (hl)                ; DB 76 56
 ioe ld d', (ix)                ; DB 76 FD 56 00
 ioe ld d', (ix+127)            ; DB 76 FD 56 7F
 ioe ld d', (ix-128)            ; DB 76 FD 56 80
 ioe ld d', (iy)                ; DB 76 DD 56 00
 ioe ld d', (iy+127)            ; DB 76 DD 56 7F
 ioe ld d', (iy-128)            ; DB 76 DD 56 80
 ioe ld d, (hl)                 ; DB 56
 ioe ld d, (ix)                 ; DB FD 56 00
 ioe ld d, (ix+127)             ; DB FD 56 7F
 ioe ld d, (ix-128)             ; DB FD 56 80
 ioe ld d, (iy)                 ; DB DD 56 00
 ioe ld d, (iy+127)             ; DB DD 56 7F
 ioe ld d, (iy-128)             ; DB DD 56 80
 ioe ld de', (-32768)           ; DB 76 ED 5B 00 80
 ioe ld de', (32767)            ; DB 76 ED 5B FF 7F
 ioe ld de', (65535)            ; DB 76 ED 5B FF FF
 ioe ld de, (-32768)            ; DB ED 5B 00 80
 ioe ld de, (32767)             ; DB ED 5B FF 7F
 ioe ld de, (65535)             ; DB ED 5B FF FF
 ioe ld e', (hl)                ; DB 76 5E
 ioe ld e', (ix)                ; DB 76 FD 5E 00
 ioe ld e', (ix+127)            ; DB 76 FD 5E 7F
 ioe ld e', (ix-128)            ; DB 76 FD 5E 80
 ioe ld e', (iy)                ; DB 76 DD 5E 00
 ioe ld e', (iy+127)            ; DB 76 DD 5E 7F
 ioe ld e', (iy-128)            ; DB 76 DD 5E 80
 ioe ld e, (hl)                 ; DB 5E
 ioe ld e, (ix)                 ; DB FD 5E 00
 ioe ld e, (ix+127)             ; DB FD 5E 7F
 ioe ld e, (ix-128)             ; DB FD 5E 80
 ioe ld e, (iy)                 ; DB DD 5E 00
 ioe ld e, (iy+127)             ; DB DD 5E 7F
 ioe ld e, (iy-128)             ; DB DD 5E 80
 ioe ld h', (hl)                ; DB 76 66
 ioe ld h', (ix)                ; DB 76 FD 66 00
 ioe ld h', (ix+127)            ; DB 76 FD 66 7F
 ioe ld h', (ix-128)            ; DB 76 FD 66 80
 ioe ld h', (iy)                ; DB 76 DD 66 00
 ioe ld h', (iy+127)            ; DB 76 DD 66 7F
 ioe ld h', (iy-128)            ; DB 76 DD 66 80
 ioe ld h, (hl)                 ; DB 66
 ioe ld h, (ix)                 ; DB FD 66 00
 ioe ld h, (ix+127)             ; DB FD 66 7F
 ioe ld h, (ix-128)             ; DB FD 66 80
 ioe ld h, (iy)                 ; DB DD 66 00
 ioe ld h, (iy+127)             ; DB DD 66 7F
 ioe ld h, (iy-128)             ; DB DD 66 80
 ioe ld hl', (-32768)           ; DB 76 2A 00 80
 ioe ld hl', (32767)            ; DB 76 2A FF 7F
 ioe ld hl', (65535)            ; DB 76 2A FF FF
 ioe ld hl', (hl)               ; DB 76 DD E4 00
 ioe ld hl', (hl+127)           ; DB 76 DD E4 7F
 ioe ld hl', (hl-128)           ; DB 76 DD E4 80
 ioe ld hl', (ix)               ; DB 76 FD E4 00
 ioe ld hl', (ix+127)           ; DB 76 FD E4 7F
 ioe ld hl', (ix-128)           ; DB 76 FD E4 80
 ioe ld hl', (iy)               ; DB 76 E4 00
 ioe ld hl', (iy+127)           ; DB 76 E4 7F
 ioe ld hl', (iy-128)           ; DB 76 E4 80
 ioe ld hl, (-32768)            ; DB 2A 00 80
 ioe ld hl, (32767)             ; DB 2A FF 7F
 ioe ld hl, (65535)             ; DB 2A FF FF
 ioe ld hl, (hl)                ; DB DD E4 00
 ioe ld hl, (hl+127)            ; DB DD E4 7F
 ioe ld hl, (hl-128)            ; DB DD E4 80
 ioe ld hl, (ix)                ; DB FD E4 00
 ioe ld hl, (ix+127)            ; DB FD E4 7F
 ioe ld hl, (ix-128)            ; DB FD E4 80
 ioe ld hl, (iy)                ; DB E4 00
 ioe ld hl, (iy+127)            ; DB E4 7F
 ioe ld hl, (iy-128)            ; DB E4 80
 ioe ld ix, (-32768)            ; DB FD 2A 00 80
 ioe ld ix, (32767)             ; DB FD 2A FF 7F
 ioe ld ix, (65535)             ; DB FD 2A FF FF
 ioe ld iy, (-32768)            ; DB DD 2A 00 80
 ioe ld iy, (32767)             ; DB DD 2A FF 7F
 ioe ld iy, (65535)             ; DB DD 2A FF FF
 ioe ld l', (hl)                ; DB 76 6E
 ioe ld l', (ix)                ; DB 76 FD 6E 00
 ioe ld l', (ix+127)            ; DB 76 FD 6E 7F
 ioe ld l', (ix-128)            ; DB 76 FD 6E 80
 ioe ld l', (iy)                ; DB 76 DD 6E 00
 ioe ld l', (iy+127)            ; DB 76 DD 6E 7F
 ioe ld l', (iy-128)            ; DB 76 DD 6E 80
 ioe ld l, (hl)                 ; DB 6E
 ioe ld l, (ix)                 ; DB FD 6E 00
 ioe ld l, (ix+127)             ; DB FD 6E 7F
 ioe ld l, (ix-128)             ; DB FD 6E 80
 ioe ld l, (iy)                 ; DB DD 6E 00
 ioe ld l, (iy+127)             ; DB DD 6E 7F
 ioe ld l, (iy-128)             ; DB DD 6E 80
 ioe ld sp, (-32768)            ; DB ED 7B 00 80
 ioe ld sp, (32767)             ; DB ED 7B FF 7F
 ioe ld sp, (65535)             ; DB ED 7B FF FF
 ioe ldd                        ; DB ED A8
 ioe ldd (bc), a                ; DB 02 0B
 ioe ldd (de), a                ; DB 12 1B
 ioe ldd (hl), a                ; DB 77 2B
 ioe ldd a, (bc)                ; DB 0A 0B
 ioe ldd a, (de)                ; DB 1A 1B
 ioe ldd a, (hl)                ; DB 7E 2B
 ioe lddr                       ; DB ED B8
 ioe ldi                        ; DB ED A0
 ioe ldi (bc), a                ; DB 02 03
 ioe ldi (de), a                ; DB 12 13
 ioe ldi (hl), a                ; DB 77 23
 ioe ldi a, (bc)                ; DB 0A 03
 ioe ldi a, (de)                ; DB 1A 13
 ioe ldi a, (hl)                ; DB 7E 23
 ioe ldir                       ; DB ED B0
 ioe or (hl)                    ; DB B6
 ioe or (ix)                    ; DB FD B6 00
 ioe or (ix+127)                ; DB FD B6 7F
 ioe or (ix-128)                ; DB FD B6 80
 ioe or (iy)                    ; DB DD B6 00
 ioe or (iy+127)                ; DB DD B6 7F
 ioe or (iy-128)                ; DB DD B6 80
 ioe or a', (hl)                ; DB 76 B6
 ioe or a', (ix)                ; DB 76 FD B6 00
 ioe or a', (ix+127)            ; DB 76 FD B6 7F
 ioe or a', (ix-128)            ; DB 76 FD B6 80
 ioe or a', (iy)                ; DB 76 DD B6 00
 ioe or a', (iy+127)            ; DB 76 DD B6 7F
 ioe or a', (iy-128)            ; DB 76 DD B6 80
 ioe or a, (hl)                 ; DB B6
 ioe or a, (ix)                 ; DB FD B6 00
 ioe or a, (ix+127)             ; DB FD B6 7F
 ioe or a, (ix-128)             ; DB FD B6 80
 ioe or a, (iy)                 ; DB DD B6 00
 ioe or a, (iy+127)             ; DB DD B6 7F
 ioe or a, (iy-128)             ; DB DD B6 80
 ioe res 0, (hl)                ; DB CB 86
 ioe res 0, (ix)                ; DB FD CB 00 86
 ioe res 0, (ix+127)            ; DB FD CB 7F 86
 ioe res 0, (ix-128)            ; DB FD CB 80 86
 ioe res 0, (iy)                ; DB DD CB 00 86
 ioe res 0, (iy+127)            ; DB DD CB 7F 86
 ioe res 0, (iy-128)            ; DB DD CB 80 86
 ioe res 1, (hl)                ; DB CB 8E
 ioe res 1, (ix)                ; DB FD CB 00 8E
 ioe res 1, (ix+127)            ; DB FD CB 7F 8E
 ioe res 1, (ix-128)            ; DB FD CB 80 8E
 ioe res 1, (iy)                ; DB DD CB 00 8E
 ioe res 1, (iy+127)            ; DB DD CB 7F 8E
 ioe res 1, (iy-128)            ; DB DD CB 80 8E
 ioe res 2, (hl)                ; DB CB 96
 ioe res 2, (ix)                ; DB FD CB 00 96
 ioe res 2, (ix+127)            ; DB FD CB 7F 96
 ioe res 2, (ix-128)            ; DB FD CB 80 96
 ioe res 2, (iy)                ; DB DD CB 00 96
 ioe res 2, (iy+127)            ; DB DD CB 7F 96
 ioe res 2, (iy-128)            ; DB DD CB 80 96
 ioe res 3, (hl)                ; DB CB 9E
 ioe res 3, (ix)                ; DB FD CB 00 9E
 ioe res 3, (ix+127)            ; DB FD CB 7F 9E
 ioe res 3, (ix-128)            ; DB FD CB 80 9E
 ioe res 3, (iy)                ; DB DD CB 00 9E
 ioe res 3, (iy+127)            ; DB DD CB 7F 9E
 ioe res 3, (iy-128)            ; DB DD CB 80 9E
 ioe res 4, (hl)                ; DB CB A6
 ioe res 4, (ix)                ; DB FD CB 00 A6
 ioe res 4, (ix+127)            ; DB FD CB 7F A6
 ioe res 4, (ix-128)            ; DB FD CB 80 A6
 ioe res 4, (iy)                ; DB DD CB 00 A6
 ioe res 4, (iy+127)            ; DB DD CB 7F A6
 ioe res 4, (iy-128)            ; DB DD CB 80 A6
 ioe res 5, (hl)                ; DB CB AE
 ioe res 5, (ix)                ; DB FD CB 00 AE
 ioe res 5, (ix+127)            ; DB FD CB 7F AE
 ioe res 5, (ix-128)            ; DB FD CB 80 AE
 ioe res 5, (iy)                ; DB DD CB 00 AE
 ioe res 5, (iy+127)            ; DB DD CB 7F AE
 ioe res 5, (iy-128)            ; DB DD CB 80 AE
 ioe res 6, (hl)                ; DB CB B6
 ioe res 6, (ix)                ; DB FD CB 00 B6
 ioe res 6, (ix+127)            ; DB FD CB 7F B6
 ioe res 6, (ix-128)            ; DB FD CB 80 B6
 ioe res 6, (iy)                ; DB DD CB 00 B6
 ioe res 6, (iy+127)            ; DB DD CB 7F B6
 ioe res 6, (iy-128)            ; DB DD CB 80 B6
 ioe res 7, (hl)                ; DB CB BE
 ioe res 7, (ix)                ; DB FD CB 00 BE
 ioe res 7, (ix+127)            ; DB FD CB 7F BE
 ioe res 7, (ix-128)            ; DB FD CB 80 BE
 ioe res 7, (iy)                ; DB DD CB 00 BE
 ioe res 7, (iy+127)            ; DB DD CB 7F BE
 ioe res 7, (iy-128)            ; DB DD CB 80 BE
 ioe res.a 0, (hl)              ; DB CB 86
 ioe res.a 0, (ix)              ; DB FD CB 00 86
 ioe res.a 0, (ix+127)          ; DB FD CB 7F 86
 ioe res.a 0, (ix-128)          ; DB FD CB 80 86
 ioe res.a 0, (iy)              ; DB DD CB 00 86
 ioe res.a 0, (iy+127)          ; DB DD CB 7F 86
 ioe res.a 0, (iy-128)          ; DB DD CB 80 86
 ioe res.a 1, (hl)              ; DB CB 8E
 ioe res.a 1, (ix)              ; DB FD CB 00 8E
 ioe res.a 1, (ix+127)          ; DB FD CB 7F 8E
 ioe res.a 1, (ix-128)          ; DB FD CB 80 8E
 ioe res.a 1, (iy)              ; DB DD CB 00 8E
 ioe res.a 1, (iy+127)          ; DB DD CB 7F 8E
 ioe res.a 1, (iy-128)          ; DB DD CB 80 8E
 ioe res.a 2, (hl)              ; DB CB 96
 ioe res.a 2, (ix)              ; DB FD CB 00 96
 ioe res.a 2, (ix+127)          ; DB FD CB 7F 96
 ioe res.a 2, (ix-128)          ; DB FD CB 80 96
 ioe res.a 2, (iy)              ; DB DD CB 00 96
 ioe res.a 2, (iy+127)          ; DB DD CB 7F 96
 ioe res.a 2, (iy-128)          ; DB DD CB 80 96
 ioe res.a 3, (hl)              ; DB CB 9E
 ioe res.a 3, (ix)              ; DB FD CB 00 9E
 ioe res.a 3, (ix+127)          ; DB FD CB 7F 9E
 ioe res.a 3, (ix-128)          ; DB FD CB 80 9E
 ioe res.a 3, (iy)              ; DB DD CB 00 9E
 ioe res.a 3, (iy+127)          ; DB DD CB 7F 9E
 ioe res.a 3, (iy-128)          ; DB DD CB 80 9E
 ioe res.a 4, (hl)              ; DB CB A6
 ioe res.a 4, (ix)              ; DB FD CB 00 A6
 ioe res.a 4, (ix+127)          ; DB FD CB 7F A6
 ioe res.a 4, (ix-128)          ; DB FD CB 80 A6
 ioe res.a 4, (iy)              ; DB DD CB 00 A6
 ioe res.a 4, (iy+127)          ; DB DD CB 7F A6
 ioe res.a 4, (iy-128)          ; DB DD CB 80 A6
 ioe res.a 5, (hl)              ; DB CB AE
 ioe res.a 5, (ix)              ; DB FD CB 00 AE
 ioe res.a 5, (ix+127)          ; DB FD CB 7F AE
 ioe res.a 5, (ix-128)          ; DB FD CB 80 AE
 ioe res.a 5, (iy)              ; DB DD CB 00 AE
 ioe res.a 5, (iy+127)          ; DB DD CB 7F AE
 ioe res.a 5, (iy-128)          ; DB DD CB 80 AE
 ioe res.a 6, (hl)              ; DB CB B6
 ioe res.a 6, (ix)              ; DB FD CB 00 B6
 ioe res.a 6, (ix+127)          ; DB FD CB 7F B6
 ioe res.a 6, (ix-128)          ; DB FD CB 80 B6
 ioe res.a 6, (iy)              ; DB DD CB 00 B6
 ioe res.a 6, (iy+127)          ; DB DD CB 7F B6
 ioe res.a 6, (iy-128)          ; DB DD CB 80 B6
 ioe res.a 7, (hl)              ; DB CB BE
 ioe res.a 7, (ix)              ; DB FD CB 00 BE
 ioe res.a 7, (ix+127)          ; DB FD CB 7F BE
 ioe res.a 7, (ix-128)          ; DB FD CB 80 BE
 ioe res.a 7, (iy)              ; DB DD CB 00 BE
 ioe res.a 7, (iy+127)          ; DB DD CB 7F BE
 ioe res.a 7, (iy-128)          ; DB DD CB 80 BE
 ioe rl (hl)                    ; DB CB 16
 ioe rl (ix)                    ; DB FD CB 00 16
 ioe rl (ix+127)                ; DB FD CB 7F 16
 ioe rl (ix-128)                ; DB FD CB 80 16
 ioe rl (iy)                    ; DB DD CB 00 16
 ioe rl (iy+127)                ; DB DD CB 7F 16
 ioe rl (iy-128)                ; DB DD CB 80 16
 ioe rlc (hl)                   ; DB CB 06
 ioe rlc (ix)                   ; DB FD CB 00 06
 ioe rlc (ix+127)               ; DB FD CB 7F 06
 ioe rlc (ix-128)               ; DB FD CB 80 06
 ioe rlc (iy)                   ; DB DD CB 00 06
 ioe rlc (iy+127)               ; DB DD CB 7F 06
 ioe rlc (iy-128)               ; DB DD CB 80 06
 ioe rr (hl)                    ; DB CB 1E
 ioe rr (ix)                    ; DB FD CB 00 1E
 ioe rr (ix+127)                ; DB FD CB 7F 1E
 ioe rr (ix-128)                ; DB FD CB 80 1E
 ioe rr (iy)                    ; DB DD CB 00 1E
 ioe rr (iy+127)                ; DB DD CB 7F 1E
 ioe rr (iy-128)                ; DB DD CB 80 1E
 ioe rrc (hl)                   ; DB CB 0E
 ioe rrc (ix)                   ; DB FD CB 00 0E
 ioe rrc (ix+127)               ; DB FD CB 7F 0E
 ioe rrc (ix-128)               ; DB FD CB 80 0E
 ioe rrc (iy)                   ; DB DD CB 00 0E
 ioe rrc (iy+127)               ; DB DD CB 7F 0E
 ioe rrc (iy-128)               ; DB DD CB 80 0E
 ioe sbc (hl)                   ; DB 9E
 ioe sbc (ix)                   ; DB FD 9E 00
 ioe sbc (ix+127)               ; DB FD 9E 7F
 ioe sbc (ix-128)               ; DB FD 9E 80
 ioe sbc (iy)                   ; DB DD 9E 00
 ioe sbc (iy+127)               ; DB DD 9E 7F
 ioe sbc (iy-128)               ; DB DD 9E 80
 ioe sbc a', (hl)               ; DB 76 9E
 ioe sbc a', (ix)               ; DB 76 FD 9E 00
 ioe sbc a', (ix+127)           ; DB 76 FD 9E 7F
 ioe sbc a', (ix-128)           ; DB 76 FD 9E 80
 ioe sbc a', (iy)               ; DB 76 DD 9E 00
 ioe sbc a', (iy+127)           ; DB 76 DD 9E 7F
 ioe sbc a', (iy-128)           ; DB 76 DD 9E 80
 ioe sbc a, (hl)                ; DB 9E
 ioe sbc a, (ix)                ; DB FD 9E 00
 ioe sbc a, (ix+127)            ; DB FD 9E 7F
 ioe sbc a, (ix-128)            ; DB FD 9E 80
 ioe sbc a, (iy)                ; DB DD 9E 00
 ioe sbc a, (iy+127)            ; DB DD 9E 7F
 ioe sbc a, (iy-128)            ; DB DD 9E 80
 ioe set 0, (hl)                ; DB CB C6
 ioe set 0, (ix)                ; DB FD CB 00 C6
 ioe set 0, (ix+127)            ; DB FD CB 7F C6
 ioe set 0, (ix-128)            ; DB FD CB 80 C6
 ioe set 0, (iy)                ; DB DD CB 00 C6
 ioe set 0, (iy+127)            ; DB DD CB 7F C6
 ioe set 0, (iy-128)            ; DB DD CB 80 C6
 ioe set 1, (hl)                ; DB CB CE
 ioe set 1, (ix)                ; DB FD CB 00 CE
 ioe set 1, (ix+127)            ; DB FD CB 7F CE
 ioe set 1, (ix-128)            ; DB FD CB 80 CE
 ioe set 1, (iy)                ; DB DD CB 00 CE
 ioe set 1, (iy+127)            ; DB DD CB 7F CE
 ioe set 1, (iy-128)            ; DB DD CB 80 CE
 ioe set 2, (hl)                ; DB CB D6
 ioe set 2, (ix)                ; DB FD CB 00 D6
 ioe set 2, (ix+127)            ; DB FD CB 7F D6
 ioe set 2, (ix-128)            ; DB FD CB 80 D6
 ioe set 2, (iy)                ; DB DD CB 00 D6
 ioe set 2, (iy+127)            ; DB DD CB 7F D6
 ioe set 2, (iy-128)            ; DB DD CB 80 D6
 ioe set 3, (hl)                ; DB CB DE
 ioe set 3, (ix)                ; DB FD CB 00 DE
 ioe set 3, (ix+127)            ; DB FD CB 7F DE
 ioe set 3, (ix-128)            ; DB FD CB 80 DE
 ioe set 3, (iy)                ; DB DD CB 00 DE
 ioe set 3, (iy+127)            ; DB DD CB 7F DE
 ioe set 3, (iy-128)            ; DB DD CB 80 DE
 ioe set 4, (hl)                ; DB CB E6
 ioe set 4, (ix)                ; DB FD CB 00 E6
 ioe set 4, (ix+127)            ; DB FD CB 7F E6
 ioe set 4, (ix-128)            ; DB FD CB 80 E6
 ioe set 4, (iy)                ; DB DD CB 00 E6
 ioe set 4, (iy+127)            ; DB DD CB 7F E6
 ioe set 4, (iy-128)            ; DB DD CB 80 E6
 ioe set 5, (hl)                ; DB CB EE
 ioe set 5, (ix)                ; DB FD CB 00 EE
 ioe set 5, (ix+127)            ; DB FD CB 7F EE
 ioe set 5, (ix-128)            ; DB FD CB 80 EE
 ioe set 5, (iy)                ; DB DD CB 00 EE
 ioe set 5, (iy+127)            ; DB DD CB 7F EE
 ioe set 5, (iy-128)            ; DB DD CB 80 EE
 ioe set 6, (hl)                ; DB CB F6
 ioe set 6, (ix)                ; DB FD CB 00 F6
 ioe set 6, (ix+127)            ; DB FD CB 7F F6
 ioe set 6, (ix-128)            ; DB FD CB 80 F6
 ioe set 6, (iy)                ; DB DD CB 00 F6
 ioe set 6, (iy+127)            ; DB DD CB 7F F6
 ioe set 6, (iy-128)            ; DB DD CB 80 F6
 ioe set 7, (hl)                ; DB CB FE
 ioe set 7, (ix)                ; DB FD CB 00 FE
 ioe set 7, (ix+127)            ; DB FD CB 7F FE
 ioe set 7, (ix-128)            ; DB FD CB 80 FE
 ioe set 7, (iy)                ; DB DD CB 00 FE
 ioe set 7, (iy+127)            ; DB DD CB 7F FE
 ioe set 7, (iy-128)            ; DB DD CB 80 FE
 ioe set.a 0, (hl)              ; DB CB C6
 ioe set.a 0, (ix)              ; DB FD CB 00 C6
 ioe set.a 0, (ix+127)          ; DB FD CB 7F C6
 ioe set.a 0, (ix-128)          ; DB FD CB 80 C6
 ioe set.a 0, (iy)              ; DB DD CB 00 C6
 ioe set.a 0, (iy+127)          ; DB DD CB 7F C6
 ioe set.a 0, (iy-128)          ; DB DD CB 80 C6
 ioe set.a 1, (hl)              ; DB CB CE
 ioe set.a 1, (ix)              ; DB FD CB 00 CE
 ioe set.a 1, (ix+127)          ; DB FD CB 7F CE
 ioe set.a 1, (ix-128)          ; DB FD CB 80 CE
 ioe set.a 1, (iy)              ; DB DD CB 00 CE
 ioe set.a 1, (iy+127)          ; DB DD CB 7F CE
 ioe set.a 1, (iy-128)          ; DB DD CB 80 CE
 ioe set.a 2, (hl)              ; DB CB D6
 ioe set.a 2, (ix)              ; DB FD CB 00 D6
 ioe set.a 2, (ix+127)          ; DB FD CB 7F D6
 ioe set.a 2, (ix-128)          ; DB FD CB 80 D6
 ioe set.a 2, (iy)              ; DB DD CB 00 D6
 ioe set.a 2, (iy+127)          ; DB DD CB 7F D6
 ioe set.a 2, (iy-128)          ; DB DD CB 80 D6
 ioe set.a 3, (hl)              ; DB CB DE
 ioe set.a 3, (ix)              ; DB FD CB 00 DE
 ioe set.a 3, (ix+127)          ; DB FD CB 7F DE
 ioe set.a 3, (ix-128)          ; DB FD CB 80 DE
 ioe set.a 3, (iy)              ; DB DD CB 00 DE
 ioe set.a 3, (iy+127)          ; DB DD CB 7F DE
 ioe set.a 3, (iy-128)          ; DB DD CB 80 DE
 ioe set.a 4, (hl)              ; DB CB E6
 ioe set.a 4, (ix)              ; DB FD CB 00 E6
 ioe set.a 4, (ix+127)          ; DB FD CB 7F E6
 ioe set.a 4, (ix-128)          ; DB FD CB 80 E6
 ioe set.a 4, (iy)              ; DB DD CB 00 E6
 ioe set.a 4, (iy+127)          ; DB DD CB 7F E6
 ioe set.a 4, (iy-128)          ; DB DD CB 80 E6
 ioe set.a 5, (hl)              ; DB CB EE
 ioe set.a 5, (ix)              ; DB FD CB 00 EE
 ioe set.a 5, (ix+127)          ; DB FD CB 7F EE
 ioe set.a 5, (ix-128)          ; DB FD CB 80 EE
 ioe set.a 5, (iy)              ; DB DD CB 00 EE
 ioe set.a 5, (iy+127)          ; DB DD CB 7F EE
 ioe set.a 5, (iy-128)          ; DB DD CB 80 EE
 ioe set.a 6, (hl)              ; DB CB F6
 ioe set.a 6, (ix)              ; DB FD CB 00 F6
 ioe set.a 6, (ix+127)          ; DB FD CB 7F F6
 ioe set.a 6, (ix-128)          ; DB FD CB 80 F6
 ioe set.a 6, (iy)              ; DB DD CB 00 F6
 ioe set.a 6, (iy+127)          ; DB DD CB 7F F6
 ioe set.a 6, (iy-128)          ; DB DD CB 80 F6
 ioe set.a 7, (hl)              ; DB CB FE
 ioe set.a 7, (ix)              ; DB FD CB 00 FE
 ioe set.a 7, (ix+127)          ; DB FD CB 7F FE
 ioe set.a 7, (ix-128)          ; DB FD CB 80 FE
 ioe set.a 7, (iy)              ; DB DD CB 00 FE
 ioe set.a 7, (iy+127)          ; DB DD CB 7F FE
 ioe set.a 7, (iy-128)          ; DB DD CB 80 FE
 ioe sla (hl)                   ; DB CB 26
 ioe sla (ix)                   ; DB FD CB 00 26
 ioe sla (ix+127)               ; DB FD CB 7F 26
 ioe sla (ix-128)               ; DB FD CB 80 26
 ioe sla (iy)                   ; DB DD CB 00 26
 ioe sla (iy+127)               ; DB DD CB 7F 26
 ioe sla (iy-128)               ; DB DD CB 80 26
 ioe sra (hl)                   ; DB CB 2E
 ioe sra (ix)                   ; DB FD CB 00 2E
 ioe sra (ix+127)               ; DB FD CB 7F 2E
 ioe sra (ix-128)               ; DB FD CB 80 2E
 ioe sra (iy)                   ; DB DD CB 00 2E
 ioe sra (iy+127)               ; DB DD CB 7F 2E
 ioe sra (iy-128)               ; DB DD CB 80 2E
 ioe srl (hl)                   ; DB CB 3E
 ioe srl (ix)                   ; DB FD CB 00 3E
 ioe srl (ix+127)               ; DB FD CB 7F 3E
 ioe srl (ix-128)               ; DB FD CB 80 3E
 ioe srl (iy)                   ; DB DD CB 00 3E
 ioe srl (iy+127)               ; DB DD CB 7F 3E
 ioe srl (iy-128)               ; DB DD CB 80 3E
 ioe sub (hl)                   ; DB 96
 ioe sub (ix)                   ; DB FD 96 00
 ioe sub (ix+127)               ; DB FD 96 7F
 ioe sub (ix-128)               ; DB FD 96 80
 ioe sub (iy)                   ; DB DD 96 00
 ioe sub (iy+127)               ; DB DD 96 7F
 ioe sub (iy-128)               ; DB DD 96 80
 ioe sub a', (hl)               ; DB 76 96
 ioe sub a', (ix)               ; DB 76 FD 96 00
 ioe sub a', (ix+127)           ; DB 76 FD 96 7F
 ioe sub a', (ix-128)           ; DB 76 FD 96 80
 ioe sub a', (iy)               ; DB 76 DD 96 00
 ioe sub a', (iy+127)           ; DB 76 DD 96 7F
 ioe sub a', (iy-128)           ; DB 76 DD 96 80
 ioe sub a, (hl)                ; DB 96
 ioe sub a, (ix)                ; DB FD 96 00
 ioe sub a, (ix+127)            ; DB FD 96 7F
 ioe sub a, (ix-128)            ; DB FD 96 80
 ioe sub a, (iy)                ; DB DD 96 00
 ioe sub a, (iy+127)            ; DB DD 96 7F
 ioe sub a, (iy-128)            ; DB DD 96 80
 ioe xor (hl)                   ; DB AE
 ioe xor (ix)                   ; DB FD AE 00
 ioe xor (ix+127)               ; DB FD AE 7F
 ioe xor (ix-128)               ; DB FD AE 80
 ioe xor (iy)                   ; DB DD AE 00
 ioe xor (iy+127)               ; DB DD AE 7F
 ioe xor (iy-128)               ; DB DD AE 80
 ioe xor a', (hl)               ; DB 76 AE
 ioe xor a', (ix)               ; DB 76 FD AE 00
 ioe xor a', (ix+127)           ; DB 76 FD AE 7F
 ioe xor a', (ix-128)           ; DB 76 FD AE 80
 ioe xor a', (iy)               ; DB 76 DD AE 00
 ioe xor a', (iy+127)           ; DB 76 DD AE 7F
 ioe xor a', (iy-128)           ; DB 76 DD AE 80
 ioe xor a, (hl)                ; DB AE
 ioe xor a, (ix)                ; DB FD AE 00
 ioe xor a, (ix+127)            ; DB FD AE 7F
 ioe xor a, (ix-128)            ; DB FD AE 80
 ioe xor a, (iy)                ; DB DD AE 00
 ioe xor a, (iy+127)            ; DB DD AE 7F
 ioe xor a, (iy-128)            ; DB DD AE 80
 ioi adc (hl)                   ; D3 8E
 ioi adc (ix)                   ; D3 FD 8E 00
 ioi adc (ix+127)               ; D3 FD 8E 7F
 ioi adc (ix-128)               ; D3 FD 8E 80
 ioi adc (iy)                   ; D3 DD 8E 00
 ioi adc (iy+127)               ; D3 DD 8E 7F
 ioi adc (iy-128)               ; D3 DD 8E 80
 ioi adc a', (hl)               ; D3 76 8E
 ioi adc a', (ix)               ; D3 76 FD 8E 00
 ioi adc a', (ix+127)           ; D3 76 FD 8E 7F
 ioi adc a', (ix-128)           ; D3 76 FD 8E 80
 ioi adc a', (iy)               ; D3 76 DD 8E 00
 ioi adc a', (iy+127)           ; D3 76 DD 8E 7F
 ioi adc a', (iy-128)           ; D3 76 DD 8E 80
 ioi adc a, (hl)                ; D3 8E
 ioi adc a, (ix)                ; D3 FD 8E 00
 ioi adc a, (ix+127)            ; D3 FD 8E 7F
 ioi adc a, (ix-128)            ; D3 FD 8E 80
 ioi adc a, (iy)                ; D3 DD 8E 00
 ioi adc a, (iy+127)            ; D3 DD 8E 7F
 ioi adc a, (iy-128)            ; D3 DD 8E 80
 ioi add (hl)                   ; D3 86
 ioi add (ix)                   ; D3 FD 86 00
 ioi add (ix+127)               ; D3 FD 86 7F
 ioi add (ix-128)               ; D3 FD 86 80
 ioi add (iy)                   ; D3 DD 86 00
 ioi add (iy+127)               ; D3 DD 86 7F
 ioi add (iy-128)               ; D3 DD 86 80
 ioi add a', (hl)               ; D3 76 86
 ioi add a', (ix)               ; D3 76 FD 86 00
 ioi add a', (ix+127)           ; D3 76 FD 86 7F
 ioi add a', (ix-128)           ; D3 76 FD 86 80
 ioi add a', (iy)               ; D3 76 DD 86 00
 ioi add a', (iy+127)           ; D3 76 DD 86 7F
 ioi add a', (iy-128)           ; D3 76 DD 86 80
 ioi add a, (hl)                ; D3 86
 ioi add a, (ix)                ; D3 FD 86 00
 ioi add a, (ix+127)            ; D3 FD 86 7F
 ioi add a, (ix-128)            ; D3 FD 86 80
 ioi add a, (iy)                ; D3 DD 86 00
 ioi add a, (iy+127)            ; D3 DD 86 7F
 ioi add a, (iy-128)            ; D3 DD 86 80
 ioi altd adc (hl)              ; D3 76 8E
 ioi altd adc (ix)              ; D3 76 FD 8E 00
 ioi altd adc (ix+127)          ; D3 76 FD 8E 7F
 ioi altd adc (ix-128)          ; D3 76 FD 8E 80
 ioi altd adc (iy)              ; D3 76 DD 8E 00
 ioi altd adc (iy+127)          ; D3 76 DD 8E 7F
 ioi altd adc (iy-128)          ; D3 76 DD 8E 80
 ioi altd adc a, (hl)           ; D3 76 8E
 ioi altd adc a, (ix)           ; D3 76 FD 8E 00
 ioi altd adc a, (ix+127)       ; D3 76 FD 8E 7F
 ioi altd adc a, (ix-128)       ; D3 76 FD 8E 80
 ioi altd adc a, (iy)           ; D3 76 DD 8E 00
 ioi altd adc a, (iy+127)       ; D3 76 DD 8E 7F
 ioi altd adc a, (iy-128)       ; D3 76 DD 8E 80
 ioi altd add (hl)              ; D3 76 86
 ioi altd add (ix)              ; D3 76 FD 86 00
 ioi altd add (ix+127)          ; D3 76 FD 86 7F
 ioi altd add (ix-128)          ; D3 76 FD 86 80
 ioi altd add (iy)              ; D3 76 DD 86 00
 ioi altd add (iy+127)          ; D3 76 DD 86 7F
 ioi altd add (iy-128)          ; D3 76 DD 86 80
 ioi altd add a, (hl)           ; D3 76 86
 ioi altd add a, (ix)           ; D3 76 FD 86 00
 ioi altd add a, (ix+127)       ; D3 76 FD 86 7F
 ioi altd add a, (ix-128)       ; D3 76 FD 86 80
 ioi altd add a, (iy)           ; D3 76 DD 86 00
 ioi altd add a, (iy+127)       ; D3 76 DD 86 7F
 ioi altd add a, (iy-128)       ; D3 76 DD 86 80
 ioi altd and (hl)              ; D3 76 A6
 ioi altd and (ix)              ; D3 76 FD A6 00
 ioi altd and (ix+127)          ; D3 76 FD A6 7F
 ioi altd and (ix-128)          ; D3 76 FD A6 80
 ioi altd and (iy)              ; D3 76 DD A6 00
 ioi altd and (iy+127)          ; D3 76 DD A6 7F
 ioi altd and (iy-128)          ; D3 76 DD A6 80
 ioi altd and a, (hl)           ; D3 76 A6
 ioi altd and a, (ix)           ; D3 76 FD A6 00
 ioi altd and a, (ix+127)       ; D3 76 FD A6 7F
 ioi altd and a, (ix-128)       ; D3 76 FD A6 80
 ioi altd and a, (iy)           ; D3 76 DD A6 00
 ioi altd and a, (iy+127)       ; D3 76 DD A6 7F
 ioi altd and a, (iy-128)       ; D3 76 DD A6 80
 ioi altd bit 0, (hl)           ; D3 76 CB 46
 ioi altd bit 0, (ix)           ; D3 76 FD CB 00 46
 ioi altd bit 0, (ix+127)       ; D3 76 FD CB 7F 46
 ioi altd bit 0, (ix-128)       ; D3 76 FD CB 80 46
 ioi altd bit 0, (iy)           ; D3 76 DD CB 00 46
 ioi altd bit 0, (iy+127)       ; D3 76 DD CB 7F 46
 ioi altd bit 0, (iy-128)       ; D3 76 DD CB 80 46
 ioi altd bit 1, (hl)           ; D3 76 CB 4E
 ioi altd bit 1, (ix)           ; D3 76 FD CB 00 4E
 ioi altd bit 1, (ix+127)       ; D3 76 FD CB 7F 4E
 ioi altd bit 1, (ix-128)       ; D3 76 FD CB 80 4E
 ioi altd bit 1, (iy)           ; D3 76 DD CB 00 4E
 ioi altd bit 1, (iy+127)       ; D3 76 DD CB 7F 4E
 ioi altd bit 1, (iy-128)       ; D3 76 DD CB 80 4E
 ioi altd bit 2, (hl)           ; D3 76 CB 56
 ioi altd bit 2, (ix)           ; D3 76 FD CB 00 56
 ioi altd bit 2, (ix+127)       ; D3 76 FD CB 7F 56
 ioi altd bit 2, (ix-128)       ; D3 76 FD CB 80 56
 ioi altd bit 2, (iy)           ; D3 76 DD CB 00 56
 ioi altd bit 2, (iy+127)       ; D3 76 DD CB 7F 56
 ioi altd bit 2, (iy-128)       ; D3 76 DD CB 80 56
 ioi altd bit 3, (hl)           ; D3 76 CB 5E
 ioi altd bit 3, (ix)           ; D3 76 FD CB 00 5E
 ioi altd bit 3, (ix+127)       ; D3 76 FD CB 7F 5E
 ioi altd bit 3, (ix-128)       ; D3 76 FD CB 80 5E
 ioi altd bit 3, (iy)           ; D3 76 DD CB 00 5E
 ioi altd bit 3, (iy+127)       ; D3 76 DD CB 7F 5E
 ioi altd bit 3, (iy-128)       ; D3 76 DD CB 80 5E
 ioi altd bit 4, (hl)           ; D3 76 CB 66
 ioi altd bit 4, (ix)           ; D3 76 FD CB 00 66
 ioi altd bit 4, (ix+127)       ; D3 76 FD CB 7F 66
 ioi altd bit 4, (ix-128)       ; D3 76 FD CB 80 66
 ioi altd bit 4, (iy)           ; D3 76 DD CB 00 66
 ioi altd bit 4, (iy+127)       ; D3 76 DD CB 7F 66
 ioi altd bit 4, (iy-128)       ; D3 76 DD CB 80 66
 ioi altd bit 5, (hl)           ; D3 76 CB 6E
 ioi altd bit 5, (ix)           ; D3 76 FD CB 00 6E
 ioi altd bit 5, (ix+127)       ; D3 76 FD CB 7F 6E
 ioi altd bit 5, (ix-128)       ; D3 76 FD CB 80 6E
 ioi altd bit 5, (iy)           ; D3 76 DD CB 00 6E
 ioi altd bit 5, (iy+127)       ; D3 76 DD CB 7F 6E
 ioi altd bit 5, (iy-128)       ; D3 76 DD CB 80 6E
 ioi altd bit 6, (hl)           ; D3 76 CB 76
 ioi altd bit 6, (ix)           ; D3 76 FD CB 00 76
 ioi altd bit 6, (ix+127)       ; D3 76 FD CB 7F 76
 ioi altd bit 6, (ix-128)       ; D3 76 FD CB 80 76
 ioi altd bit 6, (iy)           ; D3 76 DD CB 00 76
 ioi altd bit 6, (iy+127)       ; D3 76 DD CB 7F 76
 ioi altd bit 6, (iy-128)       ; D3 76 DD CB 80 76
 ioi altd bit 7, (hl)           ; D3 76 CB 7E
 ioi altd bit 7, (ix)           ; D3 76 FD CB 00 7E
 ioi altd bit 7, (ix+127)       ; D3 76 FD CB 7F 7E
 ioi altd bit 7, (ix-128)       ; D3 76 FD CB 80 7E
 ioi altd bit 7, (iy)           ; D3 76 DD CB 00 7E
 ioi altd bit 7, (iy+127)       ; D3 76 DD CB 7F 7E
 ioi altd bit 7, (iy-128)       ; D3 76 DD CB 80 7E
 ioi altd cp (hl)               ; D3 76 BE
 ioi altd cp (ix)               ; D3 76 FD BE 00
 ioi altd cp (ix+127)           ; D3 76 FD BE 7F
 ioi altd cp (ix-128)           ; D3 76 FD BE 80
 ioi altd cp (iy)               ; D3 76 DD BE 00
 ioi altd cp (iy+127)           ; D3 76 DD BE 7F
 ioi altd cp (iy-128)           ; D3 76 DD BE 80
 ioi altd cp a, (hl)            ; D3 76 BE
 ioi altd cp a, (ix)            ; D3 76 FD BE 00
 ioi altd cp a, (ix+127)        ; D3 76 FD BE 7F
 ioi altd cp a, (ix-128)        ; D3 76 FD BE 80
 ioi altd cp a, (iy)            ; D3 76 DD BE 00
 ioi altd cp a, (iy+127)        ; D3 76 DD BE 7F
 ioi altd cp a, (iy-128)        ; D3 76 DD BE 80
 ioi altd dec (hl)              ; D3 76 35
 ioi altd dec (ix)              ; D3 76 FD 35 00
 ioi altd dec (ix+127)          ; D3 76 FD 35 7F
 ioi altd dec (ix-128)          ; D3 76 FD 35 80
 ioi altd dec (iy)              ; D3 76 DD 35 00
 ioi altd dec (iy+127)          ; D3 76 DD 35 7F
 ioi altd dec (iy-128)          ; D3 76 DD 35 80
 ioi altd inc (hl)              ; D3 76 34
 ioi altd inc (ix)              ; D3 76 FD 34 00
 ioi altd inc (ix+127)          ; D3 76 FD 34 7F
 ioi altd inc (ix-128)          ; D3 76 FD 34 80
 ioi altd inc (iy)              ; D3 76 DD 34 00
 ioi altd inc (iy+127)          ; D3 76 DD 34 7F
 ioi altd inc (iy-128)          ; D3 76 DD 34 80
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
 ioi altd ld a, (ix)            ; D3 76 FD 7E 00
 ioi altd ld a, (ix+127)        ; D3 76 FD 7E 7F
 ioi altd ld a, (ix-128)        ; D3 76 FD 7E 80
 ioi altd ld a, (iy)            ; D3 76 DD 7E 00
 ioi altd ld a, (iy+127)        ; D3 76 DD 7E 7F
 ioi altd ld a, (iy-128)        ; D3 76 DD 7E 80
 ioi altd ld b, (hl)            ; D3 76 46
 ioi altd ld b, (ix)            ; D3 76 FD 46 00
 ioi altd ld b, (ix+127)        ; D3 76 FD 46 7F
 ioi altd ld b, (ix-128)        ; D3 76 FD 46 80
 ioi altd ld b, (iy)            ; D3 76 DD 46 00
 ioi altd ld b, (iy+127)        ; D3 76 DD 46 7F
 ioi altd ld b, (iy-128)        ; D3 76 DD 46 80
 ioi altd ld bc, (-32768)       ; D3 76 ED 4B 00 80
 ioi altd ld bc, (32767)        ; D3 76 ED 4B FF 7F
 ioi altd ld bc, (65535)        ; D3 76 ED 4B FF FF
 ioi altd ld c, (hl)            ; D3 76 4E
 ioi altd ld c, (ix)            ; D3 76 FD 4E 00
 ioi altd ld c, (ix+127)        ; D3 76 FD 4E 7F
 ioi altd ld c, (ix-128)        ; D3 76 FD 4E 80
 ioi altd ld c, (iy)            ; D3 76 DD 4E 00
 ioi altd ld c, (iy+127)        ; D3 76 DD 4E 7F
 ioi altd ld c, (iy-128)        ; D3 76 DD 4E 80
 ioi altd ld d, (hl)            ; D3 76 56
 ioi altd ld d, (ix)            ; D3 76 FD 56 00
 ioi altd ld d, (ix+127)        ; D3 76 FD 56 7F
 ioi altd ld d, (ix-128)        ; D3 76 FD 56 80
 ioi altd ld d, (iy)            ; D3 76 DD 56 00
 ioi altd ld d, (iy+127)        ; D3 76 DD 56 7F
 ioi altd ld d, (iy-128)        ; D3 76 DD 56 80
 ioi altd ld de, (-32768)       ; D3 76 ED 5B 00 80
 ioi altd ld de, (32767)        ; D3 76 ED 5B FF 7F
 ioi altd ld de, (65535)        ; D3 76 ED 5B FF FF
 ioi altd ld e, (hl)            ; D3 76 5E
 ioi altd ld e, (ix)            ; D3 76 FD 5E 00
 ioi altd ld e, (ix+127)        ; D3 76 FD 5E 7F
 ioi altd ld e, (ix-128)        ; D3 76 FD 5E 80
 ioi altd ld e, (iy)            ; D3 76 DD 5E 00
 ioi altd ld e, (iy+127)        ; D3 76 DD 5E 7F
 ioi altd ld e, (iy-128)        ; D3 76 DD 5E 80
 ioi altd ld h, (hl)            ; D3 76 66
 ioi altd ld h, (ix)            ; D3 76 FD 66 00
 ioi altd ld h, (ix+127)        ; D3 76 FD 66 7F
 ioi altd ld h, (ix-128)        ; D3 76 FD 66 80
 ioi altd ld h, (iy)            ; D3 76 DD 66 00
 ioi altd ld h, (iy+127)        ; D3 76 DD 66 7F
 ioi altd ld h, (iy-128)        ; D3 76 DD 66 80
 ioi altd ld hl, (-32768)       ; D3 76 2A 00 80
 ioi altd ld hl, (32767)        ; D3 76 2A FF 7F
 ioi altd ld hl, (65535)        ; D3 76 2A FF FF
 ioi altd ld hl, (hl)           ; D3 76 DD E4 00
 ioi altd ld hl, (hl+127)       ; D3 76 DD E4 7F
 ioi altd ld hl, (hl-128)       ; D3 76 DD E4 80
 ioi altd ld hl, (ix)           ; D3 76 FD E4 00
 ioi altd ld hl, (ix+127)       ; D3 76 FD E4 7F
 ioi altd ld hl, (ix-128)       ; D3 76 FD E4 80
 ioi altd ld hl, (iy)           ; D3 76 E4 00
 ioi altd ld hl, (iy+127)       ; D3 76 E4 7F
 ioi altd ld hl, (iy-128)       ; D3 76 E4 80
 ioi altd ld l, (hl)            ; D3 76 6E
 ioi altd ld l, (ix)            ; D3 76 FD 6E 00
 ioi altd ld l, (ix+127)        ; D3 76 FD 6E 7F
 ioi altd ld l, (ix-128)        ; D3 76 FD 6E 80
 ioi altd ld l, (iy)            ; D3 76 DD 6E 00
 ioi altd ld l, (iy+127)        ; D3 76 DD 6E 7F
 ioi altd ld l, (iy-128)        ; D3 76 DD 6E 80
 ioi altd or (hl)               ; D3 76 B6
 ioi altd or (ix)               ; D3 76 FD B6 00
 ioi altd or (ix+127)           ; D3 76 FD B6 7F
 ioi altd or (ix-128)           ; D3 76 FD B6 80
 ioi altd or (iy)               ; D3 76 DD B6 00
 ioi altd or (iy+127)           ; D3 76 DD B6 7F
 ioi altd or (iy-128)           ; D3 76 DD B6 80
 ioi altd or a, (hl)            ; D3 76 B6
 ioi altd or a, (ix)            ; D3 76 FD B6 00
 ioi altd or a, (ix+127)        ; D3 76 FD B6 7F
 ioi altd or a, (ix-128)        ; D3 76 FD B6 80
 ioi altd or a, (iy)            ; D3 76 DD B6 00
 ioi altd or a, (iy+127)        ; D3 76 DD B6 7F
 ioi altd or a, (iy-128)        ; D3 76 DD B6 80
 ioi altd rl (hl)               ; D3 76 CB 16
 ioi altd rl (ix)               ; D3 76 FD CB 00 16
 ioi altd rl (ix+127)           ; D3 76 FD CB 7F 16
 ioi altd rl (ix-128)           ; D3 76 FD CB 80 16
 ioi altd rl (iy)               ; D3 76 DD CB 00 16
 ioi altd rl (iy+127)           ; D3 76 DD CB 7F 16
 ioi altd rl (iy-128)           ; D3 76 DD CB 80 16
 ioi altd rlc (hl)              ; D3 76 CB 06
 ioi altd rlc (ix)              ; D3 76 FD CB 00 06
 ioi altd rlc (ix+127)          ; D3 76 FD CB 7F 06
 ioi altd rlc (ix-128)          ; D3 76 FD CB 80 06
 ioi altd rlc (iy)              ; D3 76 DD CB 00 06
 ioi altd rlc (iy+127)          ; D3 76 DD CB 7F 06
 ioi altd rlc (iy-128)          ; D3 76 DD CB 80 06
 ioi altd rr (hl)               ; D3 76 CB 1E
 ioi altd rr (ix)               ; D3 76 FD CB 00 1E
 ioi altd rr (ix+127)           ; D3 76 FD CB 7F 1E
 ioi altd rr (ix-128)           ; D3 76 FD CB 80 1E
 ioi altd rr (iy)               ; D3 76 DD CB 00 1E
 ioi altd rr (iy+127)           ; D3 76 DD CB 7F 1E
 ioi altd rr (iy-128)           ; D3 76 DD CB 80 1E
 ioi altd rrc (hl)              ; D3 76 CB 0E
 ioi altd rrc (ix)              ; D3 76 FD CB 00 0E
 ioi altd rrc (ix+127)          ; D3 76 FD CB 7F 0E
 ioi altd rrc (ix-128)          ; D3 76 FD CB 80 0E
 ioi altd rrc (iy)              ; D3 76 DD CB 00 0E
 ioi altd rrc (iy+127)          ; D3 76 DD CB 7F 0E
 ioi altd rrc (iy-128)          ; D3 76 DD CB 80 0E
 ioi altd sbc (hl)              ; D3 76 9E
 ioi altd sbc (ix)              ; D3 76 FD 9E 00
 ioi altd sbc (ix+127)          ; D3 76 FD 9E 7F
 ioi altd sbc (ix-128)          ; D3 76 FD 9E 80
 ioi altd sbc (iy)              ; D3 76 DD 9E 00
 ioi altd sbc (iy+127)          ; D3 76 DD 9E 7F
 ioi altd sbc (iy-128)          ; D3 76 DD 9E 80
 ioi altd sbc a, (hl)           ; D3 76 9E
 ioi altd sbc a, (ix)           ; D3 76 FD 9E 00
 ioi altd sbc a, (ix+127)       ; D3 76 FD 9E 7F
 ioi altd sbc a, (ix-128)       ; D3 76 FD 9E 80
 ioi altd sbc a, (iy)           ; D3 76 DD 9E 00
 ioi altd sbc a, (iy+127)       ; D3 76 DD 9E 7F
 ioi altd sbc a, (iy-128)       ; D3 76 DD 9E 80
 ioi altd sla (hl)              ; D3 76 CB 26
 ioi altd sla (ix)              ; D3 76 FD CB 00 26
 ioi altd sla (ix+127)          ; D3 76 FD CB 7F 26
 ioi altd sla (ix-128)          ; D3 76 FD CB 80 26
 ioi altd sla (iy)              ; D3 76 DD CB 00 26
 ioi altd sla (iy+127)          ; D3 76 DD CB 7F 26
 ioi altd sla (iy-128)          ; D3 76 DD CB 80 26
 ioi altd sra (hl)              ; D3 76 CB 2E
 ioi altd sra (ix)              ; D3 76 FD CB 00 2E
 ioi altd sra (ix+127)          ; D3 76 FD CB 7F 2E
 ioi altd sra (ix-128)          ; D3 76 FD CB 80 2E
 ioi altd sra (iy)              ; D3 76 DD CB 00 2E
 ioi altd sra (iy+127)          ; D3 76 DD CB 7F 2E
 ioi altd sra (iy-128)          ; D3 76 DD CB 80 2E
 ioi altd srl (hl)              ; D3 76 CB 3E
 ioi altd srl (ix)              ; D3 76 FD CB 00 3E
 ioi altd srl (ix+127)          ; D3 76 FD CB 7F 3E
 ioi altd srl (ix-128)          ; D3 76 FD CB 80 3E
 ioi altd srl (iy)              ; D3 76 DD CB 00 3E
 ioi altd srl (iy+127)          ; D3 76 DD CB 7F 3E
 ioi altd srl (iy-128)          ; D3 76 DD CB 80 3E
 ioi altd sub (hl)              ; D3 76 96
 ioi altd sub (ix)              ; D3 76 FD 96 00
 ioi altd sub (ix+127)          ; D3 76 FD 96 7F
 ioi altd sub (ix-128)          ; D3 76 FD 96 80
 ioi altd sub (iy)              ; D3 76 DD 96 00
 ioi altd sub (iy+127)          ; D3 76 DD 96 7F
 ioi altd sub (iy-128)          ; D3 76 DD 96 80
 ioi altd sub a, (hl)           ; D3 76 96
 ioi altd sub a, (ix)           ; D3 76 FD 96 00
 ioi altd sub a, (ix+127)       ; D3 76 FD 96 7F
 ioi altd sub a, (ix-128)       ; D3 76 FD 96 80
 ioi altd sub a, (iy)           ; D3 76 DD 96 00
 ioi altd sub a, (iy+127)       ; D3 76 DD 96 7F
 ioi altd sub a, (iy-128)       ; D3 76 DD 96 80
 ioi altd xor (hl)              ; D3 76 AE
 ioi altd xor (ix)              ; D3 76 FD AE 00
 ioi altd xor (ix+127)          ; D3 76 FD AE 7F
 ioi altd xor (ix-128)          ; D3 76 FD AE 80
 ioi altd xor (iy)              ; D3 76 DD AE 00
 ioi altd xor (iy+127)          ; D3 76 DD AE 7F
 ioi altd xor (iy-128)          ; D3 76 DD AE 80
 ioi altd xor a, (hl)           ; D3 76 AE
 ioi altd xor a, (ix)           ; D3 76 FD AE 00
 ioi altd xor a, (ix+127)       ; D3 76 FD AE 7F
 ioi altd xor a, (ix-128)       ; D3 76 FD AE 80
 ioi altd xor a, (iy)           ; D3 76 DD AE 00
 ioi altd xor a, (iy+127)       ; D3 76 DD AE 7F
 ioi altd xor a, (iy-128)       ; D3 76 DD AE 80
 ioi and (hl)                   ; D3 A6
 ioi and (ix)                   ; D3 FD A6 00
 ioi and (ix+127)               ; D3 FD A6 7F
 ioi and (ix-128)               ; D3 FD A6 80
 ioi and (iy)                   ; D3 DD A6 00
 ioi and (iy+127)               ; D3 DD A6 7F
 ioi and (iy-128)               ; D3 DD A6 80
 ioi and a', (hl)               ; D3 76 A6
 ioi and a', (ix)               ; D3 76 FD A6 00
 ioi and a', (ix+127)           ; D3 76 FD A6 7F
 ioi and a', (ix-128)           ; D3 76 FD A6 80
 ioi and a', (iy)               ; D3 76 DD A6 00
 ioi and a', (iy+127)           ; D3 76 DD A6 7F
 ioi and a', (iy-128)           ; D3 76 DD A6 80
 ioi and a, (hl)                ; D3 A6
 ioi and a, (ix)                ; D3 FD A6 00
 ioi and a, (ix+127)            ; D3 FD A6 7F
 ioi and a, (ix-128)            ; D3 FD A6 80
 ioi and a, (iy)                ; D3 DD A6 00
 ioi and a, (iy+127)            ; D3 DD A6 7F
 ioi and a, (iy-128)            ; D3 DD A6 80
 ioi bit 0, (hl)                ; D3 CB 46
 ioi bit 0, (ix)                ; D3 FD CB 00 46
 ioi bit 0, (ix+127)            ; D3 FD CB 7F 46
 ioi bit 0, (ix-128)            ; D3 FD CB 80 46
 ioi bit 0, (iy)                ; D3 DD CB 00 46
 ioi bit 0, (iy+127)            ; D3 DD CB 7F 46
 ioi bit 0, (iy-128)            ; D3 DD CB 80 46
 ioi bit 1, (hl)                ; D3 CB 4E
 ioi bit 1, (ix)                ; D3 FD CB 00 4E
 ioi bit 1, (ix+127)            ; D3 FD CB 7F 4E
 ioi bit 1, (ix-128)            ; D3 FD CB 80 4E
 ioi bit 1, (iy)                ; D3 DD CB 00 4E
 ioi bit 1, (iy+127)            ; D3 DD CB 7F 4E
 ioi bit 1, (iy-128)            ; D3 DD CB 80 4E
 ioi bit 2, (hl)                ; D3 CB 56
 ioi bit 2, (ix)                ; D3 FD CB 00 56
 ioi bit 2, (ix+127)            ; D3 FD CB 7F 56
 ioi bit 2, (ix-128)            ; D3 FD CB 80 56
 ioi bit 2, (iy)                ; D3 DD CB 00 56
 ioi bit 2, (iy+127)            ; D3 DD CB 7F 56
 ioi bit 2, (iy-128)            ; D3 DD CB 80 56
 ioi bit 3, (hl)                ; D3 CB 5E
 ioi bit 3, (ix)                ; D3 FD CB 00 5E
 ioi bit 3, (ix+127)            ; D3 FD CB 7F 5E
 ioi bit 3, (ix-128)            ; D3 FD CB 80 5E
 ioi bit 3, (iy)                ; D3 DD CB 00 5E
 ioi bit 3, (iy+127)            ; D3 DD CB 7F 5E
 ioi bit 3, (iy-128)            ; D3 DD CB 80 5E
 ioi bit 4, (hl)                ; D3 CB 66
 ioi bit 4, (ix)                ; D3 FD CB 00 66
 ioi bit 4, (ix+127)            ; D3 FD CB 7F 66
 ioi bit 4, (ix-128)            ; D3 FD CB 80 66
 ioi bit 4, (iy)                ; D3 DD CB 00 66
 ioi bit 4, (iy+127)            ; D3 DD CB 7F 66
 ioi bit 4, (iy-128)            ; D3 DD CB 80 66
 ioi bit 5, (hl)                ; D3 CB 6E
 ioi bit 5, (ix)                ; D3 FD CB 00 6E
 ioi bit 5, (ix+127)            ; D3 FD CB 7F 6E
 ioi bit 5, (ix-128)            ; D3 FD CB 80 6E
 ioi bit 5, (iy)                ; D3 DD CB 00 6E
 ioi bit 5, (iy+127)            ; D3 DD CB 7F 6E
 ioi bit 5, (iy-128)            ; D3 DD CB 80 6E
 ioi bit 6, (hl)                ; D3 CB 76
 ioi bit 6, (ix)                ; D3 FD CB 00 76
 ioi bit 6, (ix+127)            ; D3 FD CB 7F 76
 ioi bit 6, (ix-128)            ; D3 FD CB 80 76
 ioi bit 6, (iy)                ; D3 DD CB 00 76
 ioi bit 6, (iy+127)            ; D3 DD CB 7F 76
 ioi bit 6, (iy-128)            ; D3 DD CB 80 76
 ioi bit 7, (hl)                ; D3 CB 7E
 ioi bit 7, (ix)                ; D3 FD CB 00 7E
 ioi bit 7, (ix+127)            ; D3 FD CB 7F 7E
 ioi bit 7, (ix-128)            ; D3 FD CB 80 7E
 ioi bit 7, (iy)                ; D3 DD CB 00 7E
 ioi bit 7, (iy+127)            ; D3 DD CB 7F 7E
 ioi bit 7, (iy-128)            ; D3 DD CB 80 7E
 ioi bit.a 0, (hl)              ; D3 CB 46
 ioi bit.a 0, (ix)              ; D3 FD CB 00 46
 ioi bit.a 0, (ix+127)          ; D3 FD CB 7F 46
 ioi bit.a 0, (ix-128)          ; D3 FD CB 80 46
 ioi bit.a 0, (iy)              ; D3 DD CB 00 46
 ioi bit.a 0, (iy+127)          ; D3 DD CB 7F 46
 ioi bit.a 0, (iy-128)          ; D3 DD CB 80 46
 ioi bit.a 1, (hl)              ; D3 CB 4E
 ioi bit.a 1, (ix)              ; D3 FD CB 00 4E
 ioi bit.a 1, (ix+127)          ; D3 FD CB 7F 4E
 ioi bit.a 1, (ix-128)          ; D3 FD CB 80 4E
 ioi bit.a 1, (iy)              ; D3 DD CB 00 4E
 ioi bit.a 1, (iy+127)          ; D3 DD CB 7F 4E
 ioi bit.a 1, (iy-128)          ; D3 DD CB 80 4E
 ioi bit.a 2, (hl)              ; D3 CB 56
 ioi bit.a 2, (ix)              ; D3 FD CB 00 56
 ioi bit.a 2, (ix+127)          ; D3 FD CB 7F 56
 ioi bit.a 2, (ix-128)          ; D3 FD CB 80 56
 ioi bit.a 2, (iy)              ; D3 DD CB 00 56
 ioi bit.a 2, (iy+127)          ; D3 DD CB 7F 56
 ioi bit.a 2, (iy-128)          ; D3 DD CB 80 56
 ioi bit.a 3, (hl)              ; D3 CB 5E
 ioi bit.a 3, (ix)              ; D3 FD CB 00 5E
 ioi bit.a 3, (ix+127)          ; D3 FD CB 7F 5E
 ioi bit.a 3, (ix-128)          ; D3 FD CB 80 5E
 ioi bit.a 3, (iy)              ; D3 DD CB 00 5E
 ioi bit.a 3, (iy+127)          ; D3 DD CB 7F 5E
 ioi bit.a 3, (iy-128)          ; D3 DD CB 80 5E
 ioi bit.a 4, (hl)              ; D3 CB 66
 ioi bit.a 4, (ix)              ; D3 FD CB 00 66
 ioi bit.a 4, (ix+127)          ; D3 FD CB 7F 66
 ioi bit.a 4, (ix-128)          ; D3 FD CB 80 66
 ioi bit.a 4, (iy)              ; D3 DD CB 00 66
 ioi bit.a 4, (iy+127)          ; D3 DD CB 7F 66
 ioi bit.a 4, (iy-128)          ; D3 DD CB 80 66
 ioi bit.a 5, (hl)              ; D3 CB 6E
 ioi bit.a 5, (ix)              ; D3 FD CB 00 6E
 ioi bit.a 5, (ix+127)          ; D3 FD CB 7F 6E
 ioi bit.a 5, (ix-128)          ; D3 FD CB 80 6E
 ioi bit.a 5, (iy)              ; D3 DD CB 00 6E
 ioi bit.a 5, (iy+127)          ; D3 DD CB 7F 6E
 ioi bit.a 5, (iy-128)          ; D3 DD CB 80 6E
 ioi bit.a 6, (hl)              ; D3 CB 76
 ioi bit.a 6, (ix)              ; D3 FD CB 00 76
 ioi bit.a 6, (ix+127)          ; D3 FD CB 7F 76
 ioi bit.a 6, (ix-128)          ; D3 FD CB 80 76
 ioi bit.a 6, (iy)              ; D3 DD CB 00 76
 ioi bit.a 6, (iy+127)          ; D3 DD CB 7F 76
 ioi bit.a 6, (iy-128)          ; D3 DD CB 80 76
 ioi bit.a 7, (hl)              ; D3 CB 7E
 ioi bit.a 7, (ix)              ; D3 FD CB 00 7E
 ioi bit.a 7, (ix+127)          ; D3 FD CB 7F 7E
 ioi bit.a 7, (ix-128)          ; D3 FD CB 80 7E
 ioi bit.a 7, (iy)              ; D3 DD CB 00 7E
 ioi bit.a 7, (iy+127)          ; D3 DD CB 7F 7E
 ioi bit.a 7, (iy-128)          ; D3 DD CB 80 7E
 ioi cmp (hl)                   ; D3 BE
 ioi cmp (ix)                   ; D3 FD BE 00
 ioi cmp (ix+127)               ; D3 FD BE 7F
 ioi cmp (ix-128)               ; D3 FD BE 80
 ioi cmp (iy)                   ; D3 DD BE 00
 ioi cmp (iy+127)               ; D3 DD BE 7F
 ioi cmp (iy-128)               ; D3 DD BE 80
 ioi cmp a, (hl)                ; D3 BE
 ioi cmp a, (ix)                ; D3 FD BE 00
 ioi cmp a, (ix+127)            ; D3 FD BE 7F
 ioi cmp a, (ix-128)            ; D3 FD BE 80
 ioi cmp a, (iy)                ; D3 DD BE 00
 ioi cmp a, (iy+127)            ; D3 DD BE 7F
 ioi cmp a, (iy-128)            ; D3 DD BE 80
 ioi cp (hl)                    ; D3 BE
 ioi cp (ix)                    ; D3 FD BE 00
 ioi cp (ix+127)                ; D3 FD BE 7F
 ioi cp (ix-128)                ; D3 FD BE 80
 ioi cp (iy)                    ; D3 DD BE 00
 ioi cp (iy+127)                ; D3 DD BE 7F
 ioi cp (iy-128)                ; D3 DD BE 80
 ioi cp a, (hl)                 ; D3 BE
 ioi cp a, (ix)                 ; D3 FD BE 00
 ioi cp a, (ix+127)             ; D3 FD BE 7F
 ioi cp a, (ix-128)             ; D3 FD BE 80
 ioi cp a, (iy)                 ; D3 DD BE 00
 ioi cp a, (iy+127)             ; D3 DD BE 7F
 ioi cp a, (iy-128)             ; D3 DD BE 80
 ioi dec (hl)                   ; D3 35
 ioi dec (ix)                   ; D3 FD 35 00
 ioi dec (ix+127)               ; D3 FD 35 7F
 ioi dec (ix-128)               ; D3 FD 35 80
 ioi dec (iy)                   ; D3 DD 35 00
 ioi dec (iy+127)               ; D3 DD 35 7F
 ioi dec (iy-128)               ; D3 DD 35 80
 ioi inc (hl)                   ; D3 34
 ioi inc (ix)                   ; D3 FD 34 00
 ioi inc (ix+127)               ; D3 FD 34 7F
 ioi inc (ix-128)               ; D3 FD 34 80
 ioi inc (iy)                   ; D3 DD 34 00
 ioi inc (iy+127)               ; D3 DD 34 7F
 ioi inc (iy-128)               ; D3 DD 34 80
 ioi ld (-32768), a             ; D3 32 00 80
 ioi ld (-32768), bc            ; D3 ED 43 00 80
 ioi ld (-32768), de            ; D3 ED 53 00 80
 ioi ld (-32768), hl            ; D3 22 00 80
 ioi ld (-32768), ix            ; D3 FD 22 00 80
 ioi ld (-32768), iy            ; D3 DD 22 00 80
 ioi ld (-32768), sp            ; D3 ED 73 00 80
 ioi ld (32767), a              ; D3 32 FF 7F
 ioi ld (32767), bc             ; D3 ED 43 FF 7F
 ioi ld (32767), de             ; D3 ED 53 FF 7F
 ioi ld (32767), hl             ; D3 22 FF 7F
 ioi ld (32767), ix             ; D3 FD 22 FF 7F
 ioi ld (32767), iy             ; D3 DD 22 FF 7F
 ioi ld (32767), sp             ; D3 ED 73 FF 7F
 ioi ld (65535), a              ; D3 32 FF FF
 ioi ld (65535), bc             ; D3 ED 43 FF FF
 ioi ld (65535), de             ; D3 ED 53 FF FF
 ioi ld (65535), hl             ; D3 22 FF FF
 ioi ld (65535), ix             ; D3 FD 22 FF FF
 ioi ld (65535), iy             ; D3 DD 22 FF FF
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
 ioi ld (hl+), a                ; D3 77 23
 ioi ld (hl+127), hl            ; D3 DD F4 7F
 ioi ld (hl-), a                ; D3 77 2B
 ioi ld (hl-128), hl            ; D3 DD F4 80
 ioi ld (hld), a                ; D3 77 2B
 ioi ld (hli), a                ; D3 77 23
 ioi ld (ix), -128              ; D3 FD 36 00 80
 ioi ld (ix), 127               ; D3 FD 36 00 7F
 ioi ld (ix), 255               ; D3 FD 36 00 FF
 ioi ld (ix), a                 ; D3 FD 77 00
 ioi ld (ix), b                 ; D3 FD 70 00
 ioi ld (ix), c                 ; D3 FD 71 00
 ioi ld (ix), d                 ; D3 FD 72 00
 ioi ld (ix), e                 ; D3 FD 73 00
 ioi ld (ix), h                 ; D3 FD 74 00
 ioi ld (ix), hl                ; D3 FD F4 00
 ioi ld (ix), l                 ; D3 FD 75 00
 ioi ld (ix+127), -128          ; D3 FD 36 7F 80
 ioi ld (ix+127), 127           ; D3 FD 36 7F 7F
 ioi ld (ix+127), 255           ; D3 FD 36 7F FF
 ioi ld (ix+127), a             ; D3 FD 77 7F
 ioi ld (ix+127), b             ; D3 FD 70 7F
 ioi ld (ix+127), c             ; D3 FD 71 7F
 ioi ld (ix+127), d             ; D3 FD 72 7F
 ioi ld (ix+127), e             ; D3 FD 73 7F
 ioi ld (ix+127), h             ; D3 FD 74 7F
 ioi ld (ix+127), hl            ; D3 FD F4 7F
 ioi ld (ix+127), l             ; D3 FD 75 7F
 ioi ld (ix-128), -128          ; D3 FD 36 80 80
 ioi ld (ix-128), 127           ; D3 FD 36 80 7F
 ioi ld (ix-128), 255           ; D3 FD 36 80 FF
 ioi ld (ix-128), a             ; D3 FD 77 80
 ioi ld (ix-128), b             ; D3 FD 70 80
 ioi ld (ix-128), c             ; D3 FD 71 80
 ioi ld (ix-128), d             ; D3 FD 72 80
 ioi ld (ix-128), e             ; D3 FD 73 80
 ioi ld (ix-128), h             ; D3 FD 74 80
 ioi ld (ix-128), hl            ; D3 FD F4 80
 ioi ld (ix-128), l             ; D3 FD 75 80
 ioi ld (iy), -128              ; D3 DD 36 00 80
 ioi ld (iy), 127               ; D3 DD 36 00 7F
 ioi ld (iy), 255               ; D3 DD 36 00 FF
 ioi ld (iy), a                 ; D3 DD 77 00
 ioi ld (iy), b                 ; D3 DD 70 00
 ioi ld (iy), c                 ; D3 DD 71 00
 ioi ld (iy), d                 ; D3 DD 72 00
 ioi ld (iy), e                 ; D3 DD 73 00
 ioi ld (iy), h                 ; D3 DD 74 00
 ioi ld (iy), hl                ; D3 F4 00
 ioi ld (iy), l                 ; D3 DD 75 00
 ioi ld (iy+127), -128          ; D3 DD 36 7F 80
 ioi ld (iy+127), 127           ; D3 DD 36 7F 7F
 ioi ld (iy+127), 255           ; D3 DD 36 7F FF
 ioi ld (iy+127), a             ; D3 DD 77 7F
 ioi ld (iy+127), b             ; D3 DD 70 7F
 ioi ld (iy+127), c             ; D3 DD 71 7F
 ioi ld (iy+127), d             ; D3 DD 72 7F
 ioi ld (iy+127), e             ; D3 DD 73 7F
 ioi ld (iy+127), h             ; D3 DD 74 7F
 ioi ld (iy+127), hl            ; D3 F4 7F
 ioi ld (iy+127), l             ; D3 DD 75 7F
 ioi ld (iy-128), -128          ; D3 DD 36 80 80
 ioi ld (iy-128), 127           ; D3 DD 36 80 7F
 ioi ld (iy-128), 255           ; D3 DD 36 80 FF
 ioi ld (iy-128), a             ; D3 DD 77 80
 ioi ld (iy-128), b             ; D3 DD 70 80
 ioi ld (iy-128), c             ; D3 DD 71 80
 ioi ld (iy-128), d             ; D3 DD 72 80
 ioi ld (iy-128), e             ; D3 DD 73 80
 ioi ld (iy-128), h             ; D3 DD 74 80
 ioi ld (iy-128), hl            ; D3 F4 80
 ioi ld (iy-128), l             ; D3 DD 75 80
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
 ioi ld a', (ix)                ; D3 76 FD 7E 00
 ioi ld a', (ix+127)            ; D3 76 FD 7E 7F
 ioi ld a', (ix-128)            ; D3 76 FD 7E 80
 ioi ld a', (iy)                ; D3 76 DD 7E 00
 ioi ld a', (iy+127)            ; D3 76 DD 7E 7F
 ioi ld a', (iy-128)            ; D3 76 DD 7E 80
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
 ioi ld a, (ix)                 ; D3 FD 7E 00
 ioi ld a, (ix+127)             ; D3 FD 7E 7F
 ioi ld a, (ix-128)             ; D3 FD 7E 80
 ioi ld a, (iy)                 ; D3 DD 7E 00
 ioi ld a, (iy+127)             ; D3 DD 7E 7F
 ioi ld a, (iy-128)             ; D3 DD 7E 80
 ioi ld b', (hl)                ; D3 76 46
 ioi ld b', (ix)                ; D3 76 FD 46 00
 ioi ld b', (ix+127)            ; D3 76 FD 46 7F
 ioi ld b', (ix-128)            ; D3 76 FD 46 80
 ioi ld b', (iy)                ; D3 76 DD 46 00
 ioi ld b', (iy+127)            ; D3 76 DD 46 7F
 ioi ld b', (iy-128)            ; D3 76 DD 46 80
 ioi ld b, (hl)                 ; D3 46
 ioi ld b, (ix)                 ; D3 FD 46 00
 ioi ld b, (ix+127)             ; D3 FD 46 7F
 ioi ld b, (ix-128)             ; D3 FD 46 80
 ioi ld b, (iy)                 ; D3 DD 46 00
 ioi ld b, (iy+127)             ; D3 DD 46 7F
 ioi ld b, (iy-128)             ; D3 DD 46 80
 ioi ld bc', (-32768)           ; D3 76 ED 4B 00 80
 ioi ld bc', (32767)            ; D3 76 ED 4B FF 7F
 ioi ld bc', (65535)            ; D3 76 ED 4B FF FF
 ioi ld bc, (-32768)            ; D3 ED 4B 00 80
 ioi ld bc, (32767)             ; D3 ED 4B FF 7F
 ioi ld bc, (65535)             ; D3 ED 4B FF FF
 ioi ld c', (hl)                ; D3 76 4E
 ioi ld c', (ix)                ; D3 76 FD 4E 00
 ioi ld c', (ix+127)            ; D3 76 FD 4E 7F
 ioi ld c', (ix-128)            ; D3 76 FD 4E 80
 ioi ld c', (iy)                ; D3 76 DD 4E 00
 ioi ld c', (iy+127)            ; D3 76 DD 4E 7F
 ioi ld c', (iy-128)            ; D3 76 DD 4E 80
 ioi ld c, (hl)                 ; D3 4E
 ioi ld c, (ix)                 ; D3 FD 4E 00
 ioi ld c, (ix+127)             ; D3 FD 4E 7F
 ioi ld c, (ix-128)             ; D3 FD 4E 80
 ioi ld c, (iy)                 ; D3 DD 4E 00
 ioi ld c, (iy+127)             ; D3 DD 4E 7F
 ioi ld c, (iy-128)             ; D3 DD 4E 80
 ioi ld d', (hl)                ; D3 76 56
 ioi ld d', (ix)                ; D3 76 FD 56 00
 ioi ld d', (ix+127)            ; D3 76 FD 56 7F
 ioi ld d', (ix-128)            ; D3 76 FD 56 80
 ioi ld d', (iy)                ; D3 76 DD 56 00
 ioi ld d', (iy+127)            ; D3 76 DD 56 7F
 ioi ld d', (iy-128)            ; D3 76 DD 56 80
 ioi ld d, (hl)                 ; D3 56
 ioi ld d, (ix)                 ; D3 FD 56 00
 ioi ld d, (ix+127)             ; D3 FD 56 7F
 ioi ld d, (ix-128)             ; D3 FD 56 80
 ioi ld d, (iy)                 ; D3 DD 56 00
 ioi ld d, (iy+127)             ; D3 DD 56 7F
 ioi ld d, (iy-128)             ; D3 DD 56 80
 ioi ld de', (-32768)           ; D3 76 ED 5B 00 80
 ioi ld de', (32767)            ; D3 76 ED 5B FF 7F
 ioi ld de', (65535)            ; D3 76 ED 5B FF FF
 ioi ld de, (-32768)            ; D3 ED 5B 00 80
 ioi ld de, (32767)             ; D3 ED 5B FF 7F
 ioi ld de, (65535)             ; D3 ED 5B FF FF
 ioi ld e', (hl)                ; D3 76 5E
 ioi ld e', (ix)                ; D3 76 FD 5E 00
 ioi ld e', (ix+127)            ; D3 76 FD 5E 7F
 ioi ld e', (ix-128)            ; D3 76 FD 5E 80
 ioi ld e', (iy)                ; D3 76 DD 5E 00
 ioi ld e', (iy+127)            ; D3 76 DD 5E 7F
 ioi ld e', (iy-128)            ; D3 76 DD 5E 80
 ioi ld e, (hl)                 ; D3 5E
 ioi ld e, (ix)                 ; D3 FD 5E 00
 ioi ld e, (ix+127)             ; D3 FD 5E 7F
 ioi ld e, (ix-128)             ; D3 FD 5E 80
 ioi ld e, (iy)                 ; D3 DD 5E 00
 ioi ld e, (iy+127)             ; D3 DD 5E 7F
 ioi ld e, (iy-128)             ; D3 DD 5E 80
 ioi ld h', (hl)                ; D3 76 66
 ioi ld h', (ix)                ; D3 76 FD 66 00
 ioi ld h', (ix+127)            ; D3 76 FD 66 7F
 ioi ld h', (ix-128)            ; D3 76 FD 66 80
 ioi ld h', (iy)                ; D3 76 DD 66 00
 ioi ld h', (iy+127)            ; D3 76 DD 66 7F
 ioi ld h', (iy-128)            ; D3 76 DD 66 80
 ioi ld h, (hl)                 ; D3 66
 ioi ld h, (ix)                 ; D3 FD 66 00
 ioi ld h, (ix+127)             ; D3 FD 66 7F
 ioi ld h, (ix-128)             ; D3 FD 66 80
 ioi ld h, (iy)                 ; D3 DD 66 00
 ioi ld h, (iy+127)             ; D3 DD 66 7F
 ioi ld h, (iy-128)             ; D3 DD 66 80
 ioi ld hl', (-32768)           ; D3 76 2A 00 80
 ioi ld hl', (32767)            ; D3 76 2A FF 7F
 ioi ld hl', (65535)            ; D3 76 2A FF FF
 ioi ld hl', (hl)               ; D3 76 DD E4 00
 ioi ld hl', (hl+127)           ; D3 76 DD E4 7F
 ioi ld hl', (hl-128)           ; D3 76 DD E4 80
 ioi ld hl', (ix)               ; D3 76 FD E4 00
 ioi ld hl', (ix+127)           ; D3 76 FD E4 7F
 ioi ld hl', (ix-128)           ; D3 76 FD E4 80
 ioi ld hl', (iy)               ; D3 76 E4 00
 ioi ld hl', (iy+127)           ; D3 76 E4 7F
 ioi ld hl', (iy-128)           ; D3 76 E4 80
 ioi ld hl, (-32768)            ; D3 2A 00 80
 ioi ld hl, (32767)             ; D3 2A FF 7F
 ioi ld hl, (65535)             ; D3 2A FF FF
 ioi ld hl, (hl)                ; D3 DD E4 00
 ioi ld hl, (hl+127)            ; D3 DD E4 7F
 ioi ld hl, (hl-128)            ; D3 DD E4 80
 ioi ld hl, (ix)                ; D3 FD E4 00
 ioi ld hl, (ix+127)            ; D3 FD E4 7F
 ioi ld hl, (ix-128)            ; D3 FD E4 80
 ioi ld hl, (iy)                ; D3 E4 00
 ioi ld hl, (iy+127)            ; D3 E4 7F
 ioi ld hl, (iy-128)            ; D3 E4 80
 ioi ld ix, (-32768)            ; D3 FD 2A 00 80
 ioi ld ix, (32767)             ; D3 FD 2A FF 7F
 ioi ld ix, (65535)             ; D3 FD 2A FF FF
 ioi ld iy, (-32768)            ; D3 DD 2A 00 80
 ioi ld iy, (32767)             ; D3 DD 2A FF 7F
 ioi ld iy, (65535)             ; D3 DD 2A FF FF
 ioi ld l', (hl)                ; D3 76 6E
 ioi ld l', (ix)                ; D3 76 FD 6E 00
 ioi ld l', (ix+127)            ; D3 76 FD 6E 7F
 ioi ld l', (ix-128)            ; D3 76 FD 6E 80
 ioi ld l', (iy)                ; D3 76 DD 6E 00
 ioi ld l', (iy+127)            ; D3 76 DD 6E 7F
 ioi ld l', (iy-128)            ; D3 76 DD 6E 80
 ioi ld l, (hl)                 ; D3 6E
 ioi ld l, (ix)                 ; D3 FD 6E 00
 ioi ld l, (ix+127)             ; D3 FD 6E 7F
 ioi ld l, (ix-128)             ; D3 FD 6E 80
 ioi ld l, (iy)                 ; D3 DD 6E 00
 ioi ld l, (iy+127)             ; D3 DD 6E 7F
 ioi ld l, (iy-128)             ; D3 DD 6E 80
 ioi ld sp, (-32768)            ; D3 ED 7B 00 80
 ioi ld sp, (32767)             ; D3 ED 7B FF 7F
 ioi ld sp, (65535)             ; D3 ED 7B FF FF
 ioi ldd                        ; D3 ED A8
 ioi ldd (bc), a                ; D3 02 0B
 ioi ldd (de), a                ; D3 12 1B
 ioi ldd (hl), a                ; D3 77 2B
 ioi ldd a, (bc)                ; D3 0A 0B
 ioi ldd a, (de)                ; D3 1A 1B
 ioi ldd a, (hl)                ; D3 7E 2B
 ioi lddr                       ; D3 ED B8
 ioi ldi                        ; D3 ED A0
 ioi ldi (bc), a                ; D3 02 03
 ioi ldi (de), a                ; D3 12 13
 ioi ldi (hl), a                ; D3 77 23
 ioi ldi a, (bc)                ; D3 0A 03
 ioi ldi a, (de)                ; D3 1A 13
 ioi ldi a, (hl)                ; D3 7E 23
 ioi ldir                       ; D3 ED B0
 ioi or (hl)                    ; D3 B6
 ioi or (ix)                    ; D3 FD B6 00
 ioi or (ix+127)                ; D3 FD B6 7F
 ioi or (ix-128)                ; D3 FD B6 80
 ioi or (iy)                    ; D3 DD B6 00
 ioi or (iy+127)                ; D3 DD B6 7F
 ioi or (iy-128)                ; D3 DD B6 80
 ioi or a', (hl)                ; D3 76 B6
 ioi or a', (ix)                ; D3 76 FD B6 00
 ioi or a', (ix+127)            ; D3 76 FD B6 7F
 ioi or a', (ix-128)            ; D3 76 FD B6 80
 ioi or a', (iy)                ; D3 76 DD B6 00
 ioi or a', (iy+127)            ; D3 76 DD B6 7F
 ioi or a', (iy-128)            ; D3 76 DD B6 80
 ioi or a, (hl)                 ; D3 B6
 ioi or a, (ix)                 ; D3 FD B6 00
 ioi or a, (ix+127)             ; D3 FD B6 7F
 ioi or a, (ix-128)             ; D3 FD B6 80
 ioi or a, (iy)                 ; D3 DD B6 00
 ioi or a, (iy+127)             ; D3 DD B6 7F
 ioi or a, (iy-128)             ; D3 DD B6 80
 ioi res 0, (hl)                ; D3 CB 86
 ioi res 0, (ix)                ; D3 FD CB 00 86
 ioi res 0, (ix+127)            ; D3 FD CB 7F 86
 ioi res 0, (ix-128)            ; D3 FD CB 80 86
 ioi res 0, (iy)                ; D3 DD CB 00 86
 ioi res 0, (iy+127)            ; D3 DD CB 7F 86
 ioi res 0, (iy-128)            ; D3 DD CB 80 86
 ioi res 1, (hl)                ; D3 CB 8E
 ioi res 1, (ix)                ; D3 FD CB 00 8E
 ioi res 1, (ix+127)            ; D3 FD CB 7F 8E
 ioi res 1, (ix-128)            ; D3 FD CB 80 8E
 ioi res 1, (iy)                ; D3 DD CB 00 8E
 ioi res 1, (iy+127)            ; D3 DD CB 7F 8E
 ioi res 1, (iy-128)            ; D3 DD CB 80 8E
 ioi res 2, (hl)                ; D3 CB 96
 ioi res 2, (ix)                ; D3 FD CB 00 96
 ioi res 2, (ix+127)            ; D3 FD CB 7F 96
 ioi res 2, (ix-128)            ; D3 FD CB 80 96
 ioi res 2, (iy)                ; D3 DD CB 00 96
 ioi res 2, (iy+127)            ; D3 DD CB 7F 96
 ioi res 2, (iy-128)            ; D3 DD CB 80 96
 ioi res 3, (hl)                ; D3 CB 9E
 ioi res 3, (ix)                ; D3 FD CB 00 9E
 ioi res 3, (ix+127)            ; D3 FD CB 7F 9E
 ioi res 3, (ix-128)            ; D3 FD CB 80 9E
 ioi res 3, (iy)                ; D3 DD CB 00 9E
 ioi res 3, (iy+127)            ; D3 DD CB 7F 9E
 ioi res 3, (iy-128)            ; D3 DD CB 80 9E
 ioi res 4, (hl)                ; D3 CB A6
 ioi res 4, (ix)                ; D3 FD CB 00 A6
 ioi res 4, (ix+127)            ; D3 FD CB 7F A6
 ioi res 4, (ix-128)            ; D3 FD CB 80 A6
 ioi res 4, (iy)                ; D3 DD CB 00 A6
 ioi res 4, (iy+127)            ; D3 DD CB 7F A6
 ioi res 4, (iy-128)            ; D3 DD CB 80 A6
 ioi res 5, (hl)                ; D3 CB AE
 ioi res 5, (ix)                ; D3 FD CB 00 AE
 ioi res 5, (ix+127)            ; D3 FD CB 7F AE
 ioi res 5, (ix-128)            ; D3 FD CB 80 AE
 ioi res 5, (iy)                ; D3 DD CB 00 AE
 ioi res 5, (iy+127)            ; D3 DD CB 7F AE
 ioi res 5, (iy-128)            ; D3 DD CB 80 AE
 ioi res 6, (hl)                ; D3 CB B6
 ioi res 6, (ix)                ; D3 FD CB 00 B6
 ioi res 6, (ix+127)            ; D3 FD CB 7F B6
 ioi res 6, (ix-128)            ; D3 FD CB 80 B6
 ioi res 6, (iy)                ; D3 DD CB 00 B6
 ioi res 6, (iy+127)            ; D3 DD CB 7F B6
 ioi res 6, (iy-128)            ; D3 DD CB 80 B6
 ioi res 7, (hl)                ; D3 CB BE
 ioi res 7, (ix)                ; D3 FD CB 00 BE
 ioi res 7, (ix+127)            ; D3 FD CB 7F BE
 ioi res 7, (ix-128)            ; D3 FD CB 80 BE
 ioi res 7, (iy)                ; D3 DD CB 00 BE
 ioi res 7, (iy+127)            ; D3 DD CB 7F BE
 ioi res 7, (iy-128)            ; D3 DD CB 80 BE
 ioi res.a 0, (hl)              ; D3 CB 86
 ioi res.a 0, (ix)              ; D3 FD CB 00 86
 ioi res.a 0, (ix+127)          ; D3 FD CB 7F 86
 ioi res.a 0, (ix-128)          ; D3 FD CB 80 86
 ioi res.a 0, (iy)              ; D3 DD CB 00 86
 ioi res.a 0, (iy+127)          ; D3 DD CB 7F 86
 ioi res.a 0, (iy-128)          ; D3 DD CB 80 86
 ioi res.a 1, (hl)              ; D3 CB 8E
 ioi res.a 1, (ix)              ; D3 FD CB 00 8E
 ioi res.a 1, (ix+127)          ; D3 FD CB 7F 8E
 ioi res.a 1, (ix-128)          ; D3 FD CB 80 8E
 ioi res.a 1, (iy)              ; D3 DD CB 00 8E
 ioi res.a 1, (iy+127)          ; D3 DD CB 7F 8E
 ioi res.a 1, (iy-128)          ; D3 DD CB 80 8E
 ioi res.a 2, (hl)              ; D3 CB 96
 ioi res.a 2, (ix)              ; D3 FD CB 00 96
 ioi res.a 2, (ix+127)          ; D3 FD CB 7F 96
 ioi res.a 2, (ix-128)          ; D3 FD CB 80 96
 ioi res.a 2, (iy)              ; D3 DD CB 00 96
 ioi res.a 2, (iy+127)          ; D3 DD CB 7F 96
 ioi res.a 2, (iy-128)          ; D3 DD CB 80 96
 ioi res.a 3, (hl)              ; D3 CB 9E
 ioi res.a 3, (ix)              ; D3 FD CB 00 9E
 ioi res.a 3, (ix+127)          ; D3 FD CB 7F 9E
 ioi res.a 3, (ix-128)          ; D3 FD CB 80 9E
 ioi res.a 3, (iy)              ; D3 DD CB 00 9E
 ioi res.a 3, (iy+127)          ; D3 DD CB 7F 9E
 ioi res.a 3, (iy-128)          ; D3 DD CB 80 9E
 ioi res.a 4, (hl)              ; D3 CB A6
 ioi res.a 4, (ix)              ; D3 FD CB 00 A6
 ioi res.a 4, (ix+127)          ; D3 FD CB 7F A6
 ioi res.a 4, (ix-128)          ; D3 FD CB 80 A6
 ioi res.a 4, (iy)              ; D3 DD CB 00 A6
 ioi res.a 4, (iy+127)          ; D3 DD CB 7F A6
 ioi res.a 4, (iy-128)          ; D3 DD CB 80 A6
 ioi res.a 5, (hl)              ; D3 CB AE
 ioi res.a 5, (ix)              ; D3 FD CB 00 AE
 ioi res.a 5, (ix+127)          ; D3 FD CB 7F AE
 ioi res.a 5, (ix-128)          ; D3 FD CB 80 AE
 ioi res.a 5, (iy)              ; D3 DD CB 00 AE
 ioi res.a 5, (iy+127)          ; D3 DD CB 7F AE
 ioi res.a 5, (iy-128)          ; D3 DD CB 80 AE
 ioi res.a 6, (hl)              ; D3 CB B6
 ioi res.a 6, (ix)              ; D3 FD CB 00 B6
 ioi res.a 6, (ix+127)          ; D3 FD CB 7F B6
 ioi res.a 6, (ix-128)          ; D3 FD CB 80 B6
 ioi res.a 6, (iy)              ; D3 DD CB 00 B6
 ioi res.a 6, (iy+127)          ; D3 DD CB 7F B6
 ioi res.a 6, (iy-128)          ; D3 DD CB 80 B6
 ioi res.a 7, (hl)              ; D3 CB BE
 ioi res.a 7, (ix)              ; D3 FD CB 00 BE
 ioi res.a 7, (ix+127)          ; D3 FD CB 7F BE
 ioi res.a 7, (ix-128)          ; D3 FD CB 80 BE
 ioi res.a 7, (iy)              ; D3 DD CB 00 BE
 ioi res.a 7, (iy+127)          ; D3 DD CB 7F BE
 ioi res.a 7, (iy-128)          ; D3 DD CB 80 BE
 ioi rl (hl)                    ; D3 CB 16
 ioi rl (ix)                    ; D3 FD CB 00 16
 ioi rl (ix+127)                ; D3 FD CB 7F 16
 ioi rl (ix-128)                ; D3 FD CB 80 16
 ioi rl (iy)                    ; D3 DD CB 00 16
 ioi rl (iy+127)                ; D3 DD CB 7F 16
 ioi rl (iy-128)                ; D3 DD CB 80 16
 ioi rlc (hl)                   ; D3 CB 06
 ioi rlc (ix)                   ; D3 FD CB 00 06
 ioi rlc (ix+127)               ; D3 FD CB 7F 06
 ioi rlc (ix-128)               ; D3 FD CB 80 06
 ioi rlc (iy)                   ; D3 DD CB 00 06
 ioi rlc (iy+127)               ; D3 DD CB 7F 06
 ioi rlc (iy-128)               ; D3 DD CB 80 06
 ioi rr (hl)                    ; D3 CB 1E
 ioi rr (ix)                    ; D3 FD CB 00 1E
 ioi rr (ix+127)                ; D3 FD CB 7F 1E
 ioi rr (ix-128)                ; D3 FD CB 80 1E
 ioi rr (iy)                    ; D3 DD CB 00 1E
 ioi rr (iy+127)                ; D3 DD CB 7F 1E
 ioi rr (iy-128)                ; D3 DD CB 80 1E
 ioi rrc (hl)                   ; D3 CB 0E
 ioi rrc (ix)                   ; D3 FD CB 00 0E
 ioi rrc (ix+127)               ; D3 FD CB 7F 0E
 ioi rrc (ix-128)               ; D3 FD CB 80 0E
 ioi rrc (iy)                   ; D3 DD CB 00 0E
 ioi rrc (iy+127)               ; D3 DD CB 7F 0E
 ioi rrc (iy-128)               ; D3 DD CB 80 0E
 ioi sbc (hl)                   ; D3 9E
 ioi sbc (ix)                   ; D3 FD 9E 00
 ioi sbc (ix+127)               ; D3 FD 9E 7F
 ioi sbc (ix-128)               ; D3 FD 9E 80
 ioi sbc (iy)                   ; D3 DD 9E 00
 ioi sbc (iy+127)               ; D3 DD 9E 7F
 ioi sbc (iy-128)               ; D3 DD 9E 80
 ioi sbc a', (hl)               ; D3 76 9E
 ioi sbc a', (ix)               ; D3 76 FD 9E 00
 ioi sbc a', (ix+127)           ; D3 76 FD 9E 7F
 ioi sbc a', (ix-128)           ; D3 76 FD 9E 80
 ioi sbc a', (iy)               ; D3 76 DD 9E 00
 ioi sbc a', (iy+127)           ; D3 76 DD 9E 7F
 ioi sbc a', (iy-128)           ; D3 76 DD 9E 80
 ioi sbc a, (hl)                ; D3 9E
 ioi sbc a, (ix)                ; D3 FD 9E 00
 ioi sbc a, (ix+127)            ; D3 FD 9E 7F
 ioi sbc a, (ix-128)            ; D3 FD 9E 80
 ioi sbc a, (iy)                ; D3 DD 9E 00
 ioi sbc a, (iy+127)            ; D3 DD 9E 7F
 ioi sbc a, (iy-128)            ; D3 DD 9E 80
 ioi set 0, (hl)                ; D3 CB C6
 ioi set 0, (ix)                ; D3 FD CB 00 C6
 ioi set 0, (ix+127)            ; D3 FD CB 7F C6
 ioi set 0, (ix-128)            ; D3 FD CB 80 C6
 ioi set 0, (iy)                ; D3 DD CB 00 C6
 ioi set 0, (iy+127)            ; D3 DD CB 7F C6
 ioi set 0, (iy-128)            ; D3 DD CB 80 C6
 ioi set 1, (hl)                ; D3 CB CE
 ioi set 1, (ix)                ; D3 FD CB 00 CE
 ioi set 1, (ix+127)            ; D3 FD CB 7F CE
 ioi set 1, (ix-128)            ; D3 FD CB 80 CE
 ioi set 1, (iy)                ; D3 DD CB 00 CE
 ioi set 1, (iy+127)            ; D3 DD CB 7F CE
 ioi set 1, (iy-128)            ; D3 DD CB 80 CE
 ioi set 2, (hl)                ; D3 CB D6
 ioi set 2, (ix)                ; D3 FD CB 00 D6
 ioi set 2, (ix+127)            ; D3 FD CB 7F D6
 ioi set 2, (ix-128)            ; D3 FD CB 80 D6
 ioi set 2, (iy)                ; D3 DD CB 00 D6
 ioi set 2, (iy+127)            ; D3 DD CB 7F D6
 ioi set 2, (iy-128)            ; D3 DD CB 80 D6
 ioi set 3, (hl)                ; D3 CB DE
 ioi set 3, (ix)                ; D3 FD CB 00 DE
 ioi set 3, (ix+127)            ; D3 FD CB 7F DE
 ioi set 3, (ix-128)            ; D3 FD CB 80 DE
 ioi set 3, (iy)                ; D3 DD CB 00 DE
 ioi set 3, (iy+127)            ; D3 DD CB 7F DE
 ioi set 3, (iy-128)            ; D3 DD CB 80 DE
 ioi set 4, (hl)                ; D3 CB E6
 ioi set 4, (ix)                ; D3 FD CB 00 E6
 ioi set 4, (ix+127)            ; D3 FD CB 7F E6
 ioi set 4, (ix-128)            ; D3 FD CB 80 E6
 ioi set 4, (iy)                ; D3 DD CB 00 E6
 ioi set 4, (iy+127)            ; D3 DD CB 7F E6
 ioi set 4, (iy-128)            ; D3 DD CB 80 E6
 ioi set 5, (hl)                ; D3 CB EE
 ioi set 5, (ix)                ; D3 FD CB 00 EE
 ioi set 5, (ix+127)            ; D3 FD CB 7F EE
 ioi set 5, (ix-128)            ; D3 FD CB 80 EE
 ioi set 5, (iy)                ; D3 DD CB 00 EE
 ioi set 5, (iy+127)            ; D3 DD CB 7F EE
 ioi set 5, (iy-128)            ; D3 DD CB 80 EE
 ioi set 6, (hl)                ; D3 CB F6
 ioi set 6, (ix)                ; D3 FD CB 00 F6
 ioi set 6, (ix+127)            ; D3 FD CB 7F F6
 ioi set 6, (ix-128)            ; D3 FD CB 80 F6
 ioi set 6, (iy)                ; D3 DD CB 00 F6
 ioi set 6, (iy+127)            ; D3 DD CB 7F F6
 ioi set 6, (iy-128)            ; D3 DD CB 80 F6
 ioi set 7, (hl)                ; D3 CB FE
 ioi set 7, (ix)                ; D3 FD CB 00 FE
 ioi set 7, (ix+127)            ; D3 FD CB 7F FE
 ioi set 7, (ix-128)            ; D3 FD CB 80 FE
 ioi set 7, (iy)                ; D3 DD CB 00 FE
 ioi set 7, (iy+127)            ; D3 DD CB 7F FE
 ioi set 7, (iy-128)            ; D3 DD CB 80 FE
 ioi set.a 0, (hl)              ; D3 CB C6
 ioi set.a 0, (ix)              ; D3 FD CB 00 C6
 ioi set.a 0, (ix+127)          ; D3 FD CB 7F C6
 ioi set.a 0, (ix-128)          ; D3 FD CB 80 C6
 ioi set.a 0, (iy)              ; D3 DD CB 00 C6
 ioi set.a 0, (iy+127)          ; D3 DD CB 7F C6
 ioi set.a 0, (iy-128)          ; D3 DD CB 80 C6
 ioi set.a 1, (hl)              ; D3 CB CE
 ioi set.a 1, (ix)              ; D3 FD CB 00 CE
 ioi set.a 1, (ix+127)          ; D3 FD CB 7F CE
 ioi set.a 1, (ix-128)          ; D3 FD CB 80 CE
 ioi set.a 1, (iy)              ; D3 DD CB 00 CE
 ioi set.a 1, (iy+127)          ; D3 DD CB 7F CE
 ioi set.a 1, (iy-128)          ; D3 DD CB 80 CE
 ioi set.a 2, (hl)              ; D3 CB D6
 ioi set.a 2, (ix)              ; D3 FD CB 00 D6
 ioi set.a 2, (ix+127)          ; D3 FD CB 7F D6
 ioi set.a 2, (ix-128)          ; D3 FD CB 80 D6
 ioi set.a 2, (iy)              ; D3 DD CB 00 D6
 ioi set.a 2, (iy+127)          ; D3 DD CB 7F D6
 ioi set.a 2, (iy-128)          ; D3 DD CB 80 D6
 ioi set.a 3, (hl)              ; D3 CB DE
 ioi set.a 3, (ix)              ; D3 FD CB 00 DE
 ioi set.a 3, (ix+127)          ; D3 FD CB 7F DE
 ioi set.a 3, (ix-128)          ; D3 FD CB 80 DE
 ioi set.a 3, (iy)              ; D3 DD CB 00 DE
 ioi set.a 3, (iy+127)          ; D3 DD CB 7F DE
 ioi set.a 3, (iy-128)          ; D3 DD CB 80 DE
 ioi set.a 4, (hl)              ; D3 CB E6
 ioi set.a 4, (ix)              ; D3 FD CB 00 E6
 ioi set.a 4, (ix+127)          ; D3 FD CB 7F E6
 ioi set.a 4, (ix-128)          ; D3 FD CB 80 E6
 ioi set.a 4, (iy)              ; D3 DD CB 00 E6
 ioi set.a 4, (iy+127)          ; D3 DD CB 7F E6
 ioi set.a 4, (iy-128)          ; D3 DD CB 80 E6
 ioi set.a 5, (hl)              ; D3 CB EE
 ioi set.a 5, (ix)              ; D3 FD CB 00 EE
 ioi set.a 5, (ix+127)          ; D3 FD CB 7F EE
 ioi set.a 5, (ix-128)          ; D3 FD CB 80 EE
 ioi set.a 5, (iy)              ; D3 DD CB 00 EE
 ioi set.a 5, (iy+127)          ; D3 DD CB 7F EE
 ioi set.a 5, (iy-128)          ; D3 DD CB 80 EE
 ioi set.a 6, (hl)              ; D3 CB F6
 ioi set.a 6, (ix)              ; D3 FD CB 00 F6
 ioi set.a 6, (ix+127)          ; D3 FD CB 7F F6
 ioi set.a 6, (ix-128)          ; D3 FD CB 80 F6
 ioi set.a 6, (iy)              ; D3 DD CB 00 F6
 ioi set.a 6, (iy+127)          ; D3 DD CB 7F F6
 ioi set.a 6, (iy-128)          ; D3 DD CB 80 F6
 ioi set.a 7, (hl)              ; D3 CB FE
 ioi set.a 7, (ix)              ; D3 FD CB 00 FE
 ioi set.a 7, (ix+127)          ; D3 FD CB 7F FE
 ioi set.a 7, (ix-128)          ; D3 FD CB 80 FE
 ioi set.a 7, (iy)              ; D3 DD CB 00 FE
 ioi set.a 7, (iy+127)          ; D3 DD CB 7F FE
 ioi set.a 7, (iy-128)          ; D3 DD CB 80 FE
 ioi sla (hl)                   ; D3 CB 26
 ioi sla (ix)                   ; D3 FD CB 00 26
 ioi sla (ix+127)               ; D3 FD CB 7F 26
 ioi sla (ix-128)               ; D3 FD CB 80 26
 ioi sla (iy)                   ; D3 DD CB 00 26
 ioi sla (iy+127)               ; D3 DD CB 7F 26
 ioi sla (iy-128)               ; D3 DD CB 80 26
 ioi sra (hl)                   ; D3 CB 2E
 ioi sra (ix)                   ; D3 FD CB 00 2E
 ioi sra (ix+127)               ; D3 FD CB 7F 2E
 ioi sra (ix-128)               ; D3 FD CB 80 2E
 ioi sra (iy)                   ; D3 DD CB 00 2E
 ioi sra (iy+127)               ; D3 DD CB 7F 2E
 ioi sra (iy-128)               ; D3 DD CB 80 2E
 ioi srl (hl)                   ; D3 CB 3E
 ioi srl (ix)                   ; D3 FD CB 00 3E
 ioi srl (ix+127)               ; D3 FD CB 7F 3E
 ioi srl (ix-128)               ; D3 FD CB 80 3E
 ioi srl (iy)                   ; D3 DD CB 00 3E
 ioi srl (iy+127)               ; D3 DD CB 7F 3E
 ioi srl (iy-128)               ; D3 DD CB 80 3E
 ioi sub (hl)                   ; D3 96
 ioi sub (ix)                   ; D3 FD 96 00
 ioi sub (ix+127)               ; D3 FD 96 7F
 ioi sub (ix-128)               ; D3 FD 96 80
 ioi sub (iy)                   ; D3 DD 96 00
 ioi sub (iy+127)               ; D3 DD 96 7F
 ioi sub (iy-128)               ; D3 DD 96 80
 ioi sub a', (hl)               ; D3 76 96
 ioi sub a', (ix)               ; D3 76 FD 96 00
 ioi sub a', (ix+127)           ; D3 76 FD 96 7F
 ioi sub a', (ix-128)           ; D3 76 FD 96 80
 ioi sub a', (iy)               ; D3 76 DD 96 00
 ioi sub a', (iy+127)           ; D3 76 DD 96 7F
 ioi sub a', (iy-128)           ; D3 76 DD 96 80
 ioi sub a, (hl)                ; D3 96
 ioi sub a, (ix)                ; D3 FD 96 00
 ioi sub a, (ix+127)            ; D3 FD 96 7F
 ioi sub a, (ix-128)            ; D3 FD 96 80
 ioi sub a, (iy)                ; D3 DD 96 00
 ioi sub a, (iy+127)            ; D3 DD 96 7F
 ioi sub a, (iy-128)            ; D3 DD 96 80
 ioi xor (hl)                   ; D3 AE
 ioi xor (ix)                   ; D3 FD AE 00
 ioi xor (ix+127)               ; D3 FD AE 7F
 ioi xor (ix-128)               ; D3 FD AE 80
 ioi xor (iy)                   ; D3 DD AE 00
 ioi xor (iy+127)               ; D3 DD AE 7F
 ioi xor (iy-128)               ; D3 DD AE 80
 ioi xor a', (hl)               ; D3 76 AE
 ioi xor a', (ix)               ; D3 76 FD AE 00
 ioi xor a', (ix+127)           ; D3 76 FD AE 7F
 ioi xor a', (ix-128)           ; D3 76 FD AE 80
 ioi xor a', (iy)               ; D3 76 DD AE 00
 ioi xor a', (iy+127)           ; D3 76 DD AE 7F
 ioi xor a', (iy-128)           ; D3 76 DD AE 80
 ioi xor a, (hl)                ; D3 AE
 ioi xor a, (ix)                ; D3 FD AE 00
 ioi xor a, (ix+127)            ; D3 FD AE 7F
 ioi xor a, (ix-128)            ; D3 FD AE 80
 ioi xor a, (iy)                ; D3 DD AE 00
 ioi xor a, (iy+127)            ; D3 DD AE 7F
 ioi xor a, (iy-128)            ; D3 DD AE 80
 ipres                          ; ED 5D
 ipset 0                        ; ED 46
 ipset 1                        ; ED 56
 ipset 2                        ; ED 4E
 ipset 3                        ; ED 5E
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
 jp (ix)                        ; FD E9
 jp (iy)                        ; DD E9
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
 ld (hl), hl                    ; DD F4 00
 ld (hl), l                     ; 75
 ld (hl+), a                    ; 77 23
 ld (hl+127), hl                ; DD F4 7F
 ld (hl-), a                    ; 77 2B
 ld (hl-128), hl                ; DD F4 80
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
 ld (ix), hl                    ; FD F4 00
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
 ld (ix+127), hl                ; FD F4 7F
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
 ld (ix-128), hl                ; FD F4 80
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
 ld (iy), hl                    ; F4 00
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
 ld (iy+127), hl                ; F4 7F
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
 ld (iy-128), hl                ; F4 80
 ld (iy-128), l                 ; DD 75 80
 ld (sp), hl                    ; D4 00
 ld (sp), ix                    ; FD D4 00
 ld (sp), iy                    ; DD D4 00
 ld (sp+0), hl                  ; D4 00
 ld (sp+0), ix                  ; FD D4 00
 ld (sp+0), iy                  ; DD D4 00
 ld (sp+255), hl                ; D4 FF
 ld (sp+255), ix                ; FD D4 FF
 ld (sp+255), iy                ; DD D4 FF
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
 ld a', (ix)                    ; 76 FD 7E 00
 ld a', (ix+127)                ; 76 FD 7E 7F
 ld a', (ix-128)                ; 76 FD 7E 80
 ld a', (iy)                    ; 76 DD 7E 00
 ld a', (iy+127)                ; 76 DD 7E 7F
 ld a', (iy-128)                ; 76 DD 7E 80
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
 ld a, eir                      ; ED 57
 ld a, h                        ; 7C
 ld a, iir                      ; ED 5F
 ld a, l                        ; 7D
 ld a, xpc                      ; ED 77
 ld b', (hl)                    ; 76 46
 ld b', (ix)                    ; 76 FD 46 00
 ld b', (ix+127)                ; 76 FD 46 7F
 ld b', (ix-128)                ; 76 FD 46 80
 ld b', (iy)                    ; 76 DD 46 00
 ld b', (iy+127)                ; 76 DD 46 7F
 ld b', (iy-128)                ; 76 DD 46 80
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
 ld c', (ix)                    ; 76 FD 4E 00
 ld c', (ix+127)                ; 76 FD 4E 7F
 ld c', (ix-128)                ; 76 FD 4E 80
 ld c', (iy)                    ; 76 DD 4E 00
 ld c', (iy+127)                ; 76 DD 4E 7F
 ld c', (iy-128)                ; 76 DD 4E 80
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
 ld d', (hl)                    ; 76 56
 ld d', (ix)                    ; 76 FD 56 00
 ld d', (ix+127)                ; 76 FD 56 7F
 ld d', (ix-128)                ; 76 FD 56 80
 ld d', (iy)                    ; 76 DD 56 00
 ld d', (iy+127)                ; 76 DD 56 7F
 ld d', (iy-128)                ; 76 DD 56 80
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
