 adc a', (hl)                   ; 76 8E
 adc a', (ix)                   ; 76 FD 8E 00
 adc a', (ix+0)                 ; 76 FD 8E 00
 adc a', (ix+126)               ; 76 FD 8E 7E
 adc a', (ix-128)               ; 76 FD 8E 80
 adc a', (iy)                   ; 76 DD 8E 00
 adc a', (iy+0)                 ; 76 DD 8E 00
 adc a', (iy+126)               ; 76 DD 8E 7E
 adc a', (iy-128)               ; 76 DD 8E 80
 adc a', 0                      ; 76 CE 00
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
 adc a, l                       ; 8D
 adc hl', bc                    ; 76 ED 4A
 adc hl', de                    ; 76 ED 5A
 adc hl', hl                    ; 76 ED 6A
 adc hl', sp                    ; 76 ED 7A
 adc hl, bc                     ; ED 4A
 adc hl, de                     ; ED 5A
 adc hl, hl                     ; ED 6A
 adc hl, sp                     ; ED 7A
 add a', (hl)                   ; 76 86
 add a', (ix)                   ; 76 FD 86 00
 add a', (ix+0)                 ; 76 FD 86 00
 add a', (ix+126)               ; 76 FD 86 7E
 add a', (ix-128)               ; 76 FD 86 80
 add a', (iy)                   ; 76 DD 86 00
 add a', (iy+0)                 ; 76 DD 86 00
 add a', (iy+126)               ; 76 DD 86 7E
 add a', (iy-128)               ; 76 DD 86 80
 add a', 0                      ; 76 C6 00
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
 add a, l                       ; 85
 add hl', bc                    ; 76 09
 add hl', de                    ; 76 19
 add hl', hl                    ; 76 29
 add hl', sp                    ; 76 39
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
 add sp, -128                   ; 27 80
 add sp, 0                      ; 27 00
 add sp, 126                    ; 27 7E
 altd adc a, (hl)               ; 76 8E
 altd adc a, (ix)               ; 76 FD 8E 00
 altd adc a, (ix+0)             ; 76 FD 8E 00
 altd adc a, (ix+126)           ; 76 FD 8E 7E
 altd adc a, (ix-128)           ; 76 FD 8E 80
 altd adc a, (iy)               ; 76 DD 8E 00
 altd adc a, (iy+0)             ; 76 DD 8E 00
 altd adc a, (iy+126)           ; 76 DD 8E 7E
 altd adc a, (iy-128)           ; 76 DD 8E 80
 altd adc a, 0                  ; 76 CE 00
 altd adc a, 127                ; 76 CE 7F
 altd adc a, 255                ; 76 CE FF
 altd adc a, a                  ; 76 8F
 altd adc a, b                  ; 76 88
 altd adc a, c                  ; 76 89
 altd adc a, d                  ; 76 8A
 altd adc a, e                  ; 76 8B
 altd adc a, h                  ; 76 8C
 altd adc a, l                  ; 76 8D
 altd adc hl, bc                ; 76 ED 4A
 altd adc hl, de                ; 76 ED 5A
 altd adc hl, hl                ; 76 ED 6A
 altd adc hl, sp                ; 76 ED 7A
 altd add a, (hl)               ; 76 86
 altd add a, (ix)               ; 76 FD 86 00
 altd add a, (ix+0)             ; 76 FD 86 00
 altd add a, (ix+126)           ; 76 FD 86 7E
 altd add a, (ix-128)           ; 76 FD 86 80
 altd add a, (iy)               ; 76 DD 86 00
 altd add a, (iy+0)             ; 76 DD 86 00
 altd add a, (iy+126)           ; 76 DD 86 7E
 altd add a, (iy-128)           ; 76 DD 86 80
 altd add a, 0                  ; 76 C6 00
 altd add a, 127                ; 76 C6 7F
 altd add a, 255                ; 76 C6 FF
 altd add a, a                  ; 76 87
 altd add a, b                  ; 76 80
 altd add a, c                  ; 76 81
 altd add a, d                  ; 76 82
 altd add a, e                  ; 76 83
 altd add a, h                  ; 76 84
 altd add a, l                  ; 76 85
 altd add hl, bc                ; 76 09
 altd add hl, de                ; 76 19
 altd add hl, hl                ; 76 29
 altd add hl, sp                ; 76 39
 altd add ix, bc                ; 76 FD 09
 altd add ix, de                ; 76 FD 19
 altd add ix, ix                ; 76 FD 29
 altd add ix, sp                ; 76 FD 39
 altd add iy, bc                ; 76 DD 09
 altd add iy, de                ; 76 DD 19
 altd add iy, iy                ; 76 DD 29
 altd add iy, sp                ; 76 DD 39
 altd add sp, -128              ; 76 27 80
 altd add sp, 0                 ; 76 27 00
 altd add sp, 126               ; 76 27 7E
 altd and (hl)                  ; 76 A6
 altd and (ix)                  ; 76 FD A6 00
 altd and (ix+0)                ; 76 FD A6 00
 altd and (ix+126)              ; 76 FD A6 7E
 altd and (ix-128)              ; 76 FD A6 80
 altd and (iy)                  ; 76 DD A6 00
 altd and (iy+0)                ; 76 DD A6 00
 altd and (iy+126)              ; 76 DD A6 7E
 altd and (iy-128)              ; 76 DD A6 80
 altd and 0                     ; 76 E6 00
 altd and 127                   ; 76 E6 7F
 altd and 255                   ; 76 E6 FF
 altd and a                     ; 76 A7
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
 altd bit 0, (ix+0)             ; 76 FD CB 00 46
 altd bit 0, (ix+126)           ; 76 FD CB 7E 46
 altd bit 0, (ix-128)           ; 76 FD CB 80 46
 altd bit 0, (iy)               ; 76 DD CB 00 46
 altd bit 0, (iy+0)             ; 76 DD CB 00 46
 altd bit 0, (iy+126)           ; 76 DD CB 7E 46
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
 altd bit 1, (ix+0)             ; 76 FD CB 00 4E
 altd bit 1, (ix+126)           ; 76 FD CB 7E 4E
 altd bit 1, (ix-128)           ; 76 FD CB 80 4E
 altd bit 1, (iy)               ; 76 DD CB 00 4E
 altd bit 1, (iy+0)             ; 76 DD CB 00 4E
 altd bit 1, (iy+126)           ; 76 DD CB 7E 4E
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
 altd bit 2, (ix+0)             ; 76 FD CB 00 56
 altd bit 2, (ix+126)           ; 76 FD CB 7E 56
 altd bit 2, (ix-128)           ; 76 FD CB 80 56
 altd bit 2, (iy)               ; 76 DD CB 00 56
 altd bit 2, (iy+0)             ; 76 DD CB 00 56
 altd bit 2, (iy+126)           ; 76 DD CB 7E 56
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
 altd bit 3, (ix+0)             ; 76 FD CB 00 5E
 altd bit 3, (ix+126)           ; 76 FD CB 7E 5E
 altd bit 3, (ix-128)           ; 76 FD CB 80 5E
 altd bit 3, (iy)               ; 76 DD CB 00 5E
 altd bit 3, (iy+0)             ; 76 DD CB 00 5E
 altd bit 3, (iy+126)           ; 76 DD CB 7E 5E
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
 altd bit 4, (ix+0)             ; 76 FD CB 00 66
 altd bit 4, (ix+126)           ; 76 FD CB 7E 66
 altd bit 4, (ix-128)           ; 76 FD CB 80 66
 altd bit 4, (iy)               ; 76 DD CB 00 66
 altd bit 4, (iy+0)             ; 76 DD CB 00 66
 altd bit 4, (iy+126)           ; 76 DD CB 7E 66
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
 altd bit 5, (ix+0)             ; 76 FD CB 00 6E
 altd bit 5, (ix+126)           ; 76 FD CB 7E 6E
 altd bit 5, (ix-128)           ; 76 FD CB 80 6E
 altd bit 5, (iy)               ; 76 DD CB 00 6E
 altd bit 5, (iy+0)             ; 76 DD CB 00 6E
 altd bit 5, (iy+126)           ; 76 DD CB 7E 6E
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
 altd bit 6, (ix+0)             ; 76 FD CB 00 76
 altd bit 6, (ix+126)           ; 76 FD CB 7E 76
 altd bit 6, (ix-128)           ; 76 FD CB 80 76
 altd bit 6, (iy)               ; 76 DD CB 00 76
 altd bit 6, (iy+0)             ; 76 DD CB 00 76
 altd bit 6, (iy+126)           ; 76 DD CB 7E 76
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
 altd bit 7, (ix+0)             ; 76 FD CB 00 7E
 altd bit 7, (ix+126)           ; 76 FD CB 7E 7E
 altd bit 7, (ix-128)           ; 76 FD CB 80 7E
 altd bit 7, (iy)               ; 76 DD CB 00 7E
 altd bit 7, (iy+0)             ; 76 DD CB 00 7E
 altd bit 7, (iy+126)           ; 76 DD CB 7E 7E
 altd bit 7, (iy-128)           ; 76 DD CB 80 7E
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
 altd cp (ix)                   ; 76 FD BE 00
 altd cp (ix+0)                 ; 76 FD BE 00
 altd cp (ix+126)               ; 76 FD BE 7E
 altd cp (ix-128)               ; 76 FD BE 80
 altd cp (iy)                   ; 76 DD BE 00
 altd cp (iy+0)                 ; 76 DD BE 00
 altd cp (iy+126)               ; 76 DD BE 7E
 altd cp (iy-128)               ; 76 DD BE 80
 altd cp 0                      ; 76 FE 00
 altd cp 127                    ; 76 FE 7F
 altd cp 255                    ; 76 FE FF
 altd cp a                      ; 76 BF
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
 altd dec (ix+0)                ; 76 FD 35 00
 altd dec (ix+126)              ; 76 FD 35 7E
 altd dec (ix-128)              ; 76 FD 35 80
 altd dec (iy)                  ; 76 DD 35 00
 altd dec (iy+0)                ; 76 DD 35 00
 altd dec (iy+126)              ; 76 DD 35 7E
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
 altd dec sp                    ; 76 3B
 altd djnz ASMPC                ; 76 10 FD
 altd djnz b, ASMPC             ; 76 10 FD
 altd ex (sp), hl               ; 76 ED 54
 altd ex de', hl                ; 76 E3
 altd ex de, hl                 ; 76 EB
 altd inc (hl)                  ; 76 34
 altd inc (ix)                  ; 76 FD 34 00
 altd inc (ix+0)                ; 76 FD 34 00
 altd inc (ix+126)              ; 76 FD 34 7E
 altd inc (ix-128)              ; 76 FD 34 80
 altd inc (iy)                  ; 76 DD 34 00
 altd inc (iy+0)                ; 76 DD 34 00
 altd inc (iy+126)              ; 76 DD 34 7E
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
 altd inc sp                    ; 76 33
 altd ioe adc a, (hl)           ; 76 DB 8E
 altd ioe adc a, (ix)           ; 76 DB FD 8E 00
 altd ioe adc a, (ix+0)         ; 76 DB FD 8E 00
 altd ioe adc a, (ix+126)       ; 76 DB FD 8E 7E
 altd ioe adc a, (ix-128)       ; 76 DB FD 8E 80
 altd ioe adc a, (iy)           ; 76 DB DD 8E 00
 altd ioe adc a, (iy+0)         ; 76 DB DD 8E 00
 altd ioe adc a, (iy+126)       ; 76 DB DD 8E 7E
 altd ioe adc a, (iy-128)       ; 76 DB DD 8E 80
 altd ioe add a, (hl)           ; 76 DB 86
 altd ioe add a, (ix)           ; 76 DB FD 86 00
 altd ioe add a, (ix+0)         ; 76 DB FD 86 00
 altd ioe add a, (ix+126)       ; 76 DB FD 86 7E
 altd ioe add a, (ix-128)       ; 76 DB FD 86 80
 altd ioe add a, (iy)           ; 76 DB DD 86 00
 altd ioe add a, (iy+0)         ; 76 DB DD 86 00
 altd ioe add a, (iy+126)       ; 76 DB DD 86 7E
 altd ioe add a, (iy-128)       ; 76 DB DD 86 80
 altd ioe and (hl)              ; 76 DB A6
 altd ioe and (ix)              ; 76 DB FD A6 00
 altd ioe and (ix+0)            ; 76 DB FD A6 00
 altd ioe and (ix+126)          ; 76 DB FD A6 7E
 altd ioe and (ix-128)          ; 76 DB FD A6 80
 altd ioe and (iy)              ; 76 DB DD A6 00
 altd ioe and (iy+0)            ; 76 DB DD A6 00
 altd ioe and (iy+126)          ; 76 DB DD A6 7E
 altd ioe and (iy-128)          ; 76 DB DD A6 80
 altd ioe bit 0, (hl)           ; 76 DB CB 46
 altd ioe bit 0, (ix)           ; 76 DB FD CB 00 46
 altd ioe bit 0, (ix+0)         ; 76 DB FD CB 00 46
 altd ioe bit 0, (ix+126)       ; 76 DB FD CB 7E 46
 altd ioe bit 0, (ix-128)       ; 76 DB FD CB 80 46
 altd ioe bit 0, (iy)           ; 76 DB DD CB 00 46
 altd ioe bit 0, (iy+0)         ; 76 DB DD CB 00 46
 altd ioe bit 0, (iy+126)       ; 76 DB DD CB 7E 46
 altd ioe bit 0, (iy-128)       ; 76 DB DD CB 80 46
 altd ioe bit 1, (hl)           ; 76 DB CB 4E
 altd ioe bit 1, (ix)           ; 76 DB FD CB 00 4E
 altd ioe bit 1, (ix+0)         ; 76 DB FD CB 00 4E
 altd ioe bit 1, (ix+126)       ; 76 DB FD CB 7E 4E
 altd ioe bit 1, (ix-128)       ; 76 DB FD CB 80 4E
 altd ioe bit 1, (iy)           ; 76 DB DD CB 00 4E
 altd ioe bit 1, (iy+0)         ; 76 DB DD CB 00 4E
 altd ioe bit 1, (iy+126)       ; 76 DB DD CB 7E 4E
 altd ioe bit 1, (iy-128)       ; 76 DB DD CB 80 4E
 altd ioe bit 2, (hl)           ; 76 DB CB 56
 altd ioe bit 2, (ix)           ; 76 DB FD CB 00 56
 altd ioe bit 2, (ix+0)         ; 76 DB FD CB 00 56
 altd ioe bit 2, (ix+126)       ; 76 DB FD CB 7E 56
 altd ioe bit 2, (ix-128)       ; 76 DB FD CB 80 56
 altd ioe bit 2, (iy)           ; 76 DB DD CB 00 56
 altd ioe bit 2, (iy+0)         ; 76 DB DD CB 00 56
 altd ioe bit 2, (iy+126)       ; 76 DB DD CB 7E 56
 altd ioe bit 2, (iy-128)       ; 76 DB DD CB 80 56
 altd ioe bit 3, (hl)           ; 76 DB CB 5E
 altd ioe bit 3, (ix)           ; 76 DB FD CB 00 5E
 altd ioe bit 3, (ix+0)         ; 76 DB FD CB 00 5E
 altd ioe bit 3, (ix+126)       ; 76 DB FD CB 7E 5E
 altd ioe bit 3, (ix-128)       ; 76 DB FD CB 80 5E
 altd ioe bit 3, (iy)           ; 76 DB DD CB 00 5E
 altd ioe bit 3, (iy+0)         ; 76 DB DD CB 00 5E
 altd ioe bit 3, (iy+126)       ; 76 DB DD CB 7E 5E
 altd ioe bit 3, (iy-128)       ; 76 DB DD CB 80 5E
 altd ioe bit 4, (hl)           ; 76 DB CB 66
 altd ioe bit 4, (ix)           ; 76 DB FD CB 00 66
 altd ioe bit 4, (ix+0)         ; 76 DB FD CB 00 66
 altd ioe bit 4, (ix+126)       ; 76 DB FD CB 7E 66
 altd ioe bit 4, (ix-128)       ; 76 DB FD CB 80 66
 altd ioe bit 4, (iy)           ; 76 DB DD CB 00 66
 altd ioe bit 4, (iy+0)         ; 76 DB DD CB 00 66
 altd ioe bit 4, (iy+126)       ; 76 DB DD CB 7E 66
 altd ioe bit 4, (iy-128)       ; 76 DB DD CB 80 66
 altd ioe bit 5, (hl)           ; 76 DB CB 6E
 altd ioe bit 5, (ix)           ; 76 DB FD CB 00 6E
 altd ioe bit 5, (ix+0)         ; 76 DB FD CB 00 6E
 altd ioe bit 5, (ix+126)       ; 76 DB FD CB 7E 6E
 altd ioe bit 5, (ix-128)       ; 76 DB FD CB 80 6E
 altd ioe bit 5, (iy)           ; 76 DB DD CB 00 6E
 altd ioe bit 5, (iy+0)         ; 76 DB DD CB 00 6E
 altd ioe bit 5, (iy+126)       ; 76 DB DD CB 7E 6E
 altd ioe bit 5, (iy-128)       ; 76 DB DD CB 80 6E
 altd ioe bit 6, (hl)           ; 76 DB CB 76
 altd ioe bit 6, (ix)           ; 76 DB FD CB 00 76
 altd ioe bit 6, (ix+0)         ; 76 DB FD CB 00 76
 altd ioe bit 6, (ix+126)       ; 76 DB FD CB 7E 76
 altd ioe bit 6, (ix-128)       ; 76 DB FD CB 80 76
 altd ioe bit 6, (iy)           ; 76 DB DD CB 00 76
 altd ioe bit 6, (iy+0)         ; 76 DB DD CB 00 76
 altd ioe bit 6, (iy+126)       ; 76 DB DD CB 7E 76
 altd ioe bit 6, (iy-128)       ; 76 DB DD CB 80 76
 altd ioe bit 7, (hl)           ; 76 DB CB 7E
 altd ioe bit 7, (ix)           ; 76 DB FD CB 00 7E
 altd ioe bit 7, (ix+0)         ; 76 DB FD CB 00 7E
 altd ioe bit 7, (ix+126)       ; 76 DB FD CB 7E 7E
 altd ioe bit 7, (ix-128)       ; 76 DB FD CB 80 7E
 altd ioe bit 7, (iy)           ; 76 DB DD CB 00 7E
 altd ioe bit 7, (iy+0)         ; 76 DB DD CB 00 7E
 altd ioe bit 7, (iy+126)       ; 76 DB DD CB 7E 7E
 altd ioe bit 7, (iy-128)       ; 76 DB DD CB 80 7E
 altd ioe cp (hl)               ; 76 DB BE
 altd ioe cp (ix)               ; 76 DB FD BE 00
 altd ioe cp (ix+0)             ; 76 DB FD BE 00
 altd ioe cp (ix+126)           ; 76 DB FD BE 7E
 altd ioe cp (ix-128)           ; 76 DB FD BE 80
 altd ioe cp (iy)               ; 76 DB DD BE 00
 altd ioe cp (iy+0)             ; 76 DB DD BE 00
 altd ioe cp (iy+126)           ; 76 DB DD BE 7E
 altd ioe cp (iy-128)           ; 76 DB DD BE 80
 altd ioe dec (hl)              ; 76 DB 35
 altd ioe dec (ix)              ; 76 DB FD 35 00
 altd ioe dec (ix+0)            ; 76 DB FD 35 00
 altd ioe dec (ix+126)          ; 76 DB FD 35 7E
 altd ioe dec (ix-128)          ; 76 DB FD 35 80
 altd ioe dec (iy)              ; 76 DB DD 35 00
 altd ioe dec (iy+0)            ; 76 DB DD 35 00
 altd ioe dec (iy+126)          ; 76 DB DD 35 7E
 altd ioe dec (iy-128)          ; 76 DB DD 35 80
 altd ioe inc (hl)              ; 76 DB 34
 altd ioe inc (ix)              ; 76 DB FD 34 00
 altd ioe inc (ix+0)            ; 76 DB FD 34 00
 altd ioe inc (ix+126)          ; 76 DB FD 34 7E
 altd ioe inc (ix-128)          ; 76 DB FD 34 80
 altd ioe inc (iy)              ; 76 DB DD 34 00
 altd ioe inc (iy+0)            ; 76 DB DD 34 00
 altd ioe inc (iy+126)          ; 76 DB DD 34 7E
 altd ioe inc (iy-128)          ; 76 DB DD 34 80
 altd ioe ld a, (0x1234)        ; 76 DB 3A 34 12
 altd ioe ld a, (bc)            ; 76 DB 0A
 altd ioe ld a, (de)            ; 76 DB 1A
 altd ioe ld a, (hl)            ; 76 DB 7E
 altd ioe ld a, (ix)            ; 76 DB FD 7E 00
 altd ioe ld a, (ix+0)          ; 76 DB FD 7E 00
 altd ioe ld a, (ix+126)        ; 76 DB FD 7E 7E
 altd ioe ld a, (ix-128)        ; 76 DB FD 7E 80
 altd ioe ld a, (iy)            ; 76 DB DD 7E 00
 altd ioe ld a, (iy+0)          ; 76 DB DD 7E 00
 altd ioe ld a, (iy+126)        ; 76 DB DD 7E 7E
 altd ioe ld a, (iy-128)        ; 76 DB DD 7E 80
 altd ioe ld b, (hl)            ; 76 DB 46
 altd ioe ld b, (ix)            ; 76 DB FD 46 00
 altd ioe ld b, (ix+0)          ; 76 DB FD 46 00
 altd ioe ld b, (ix+126)        ; 76 DB FD 46 7E
 altd ioe ld b, (ix-128)        ; 76 DB FD 46 80
 altd ioe ld b, (iy)            ; 76 DB DD 46 00
 altd ioe ld b, (iy+0)          ; 76 DB DD 46 00
 altd ioe ld b, (iy+126)        ; 76 DB DD 46 7E
 altd ioe ld b, (iy-128)        ; 76 DB DD 46 80
 altd ioe ld bc, (0x1234)       ; 76 DB ED 4B 34 12
 altd ioe ld c, (hl)            ; 76 DB 4E
 altd ioe ld c, (ix)            ; 76 DB FD 4E 00
 altd ioe ld c, (ix+0)          ; 76 DB FD 4E 00
 altd ioe ld c, (ix+126)        ; 76 DB FD 4E 7E
 altd ioe ld c, (ix-128)        ; 76 DB FD 4E 80
 altd ioe ld c, (iy)            ; 76 DB DD 4E 00
 altd ioe ld c, (iy+0)          ; 76 DB DD 4E 00
 altd ioe ld c, (iy+126)        ; 76 DB DD 4E 7E
 altd ioe ld c, (iy-128)        ; 76 DB DD 4E 80
 altd ioe ld d, (hl)            ; 76 DB 56
 altd ioe ld d, (ix)            ; 76 DB FD 56 00
 altd ioe ld d, (ix+0)          ; 76 DB FD 56 00
 altd ioe ld d, (ix+126)        ; 76 DB FD 56 7E
 altd ioe ld d, (ix-128)        ; 76 DB FD 56 80
 altd ioe ld d, (iy)            ; 76 DB DD 56 00
 altd ioe ld d, (iy+0)          ; 76 DB DD 56 00
 altd ioe ld d, (iy+126)        ; 76 DB DD 56 7E
 altd ioe ld d, (iy-128)        ; 76 DB DD 56 80
 altd ioe ld de, (0x1234)       ; 76 DB ED 5B 34 12
 altd ioe ld e, (hl)            ; 76 DB 5E
 altd ioe ld e, (ix)            ; 76 DB FD 5E 00
 altd ioe ld e, (ix+0)          ; 76 DB FD 5E 00
 altd ioe ld e, (ix+126)        ; 76 DB FD 5E 7E
 altd ioe ld e, (ix-128)        ; 76 DB FD 5E 80
 altd ioe ld e, (iy)            ; 76 DB DD 5E 00
 altd ioe ld e, (iy+0)          ; 76 DB DD 5E 00
 altd ioe ld e, (iy+126)        ; 76 DB DD 5E 7E
 altd ioe ld e, (iy-128)        ; 76 DB DD 5E 80
 altd ioe ld h, (hl)            ; 76 DB 66
 altd ioe ld h, (ix)            ; 76 DB FD 66 00
 altd ioe ld h, (ix+0)          ; 76 DB FD 66 00
 altd ioe ld h, (ix+126)        ; 76 DB FD 66 7E
 altd ioe ld h, (ix-128)        ; 76 DB FD 66 80
 altd ioe ld h, (iy)            ; 76 DB DD 66 00
 altd ioe ld h, (iy+0)          ; 76 DB DD 66 00
 altd ioe ld h, (iy+126)        ; 76 DB DD 66 7E
 altd ioe ld h, (iy-128)        ; 76 DB DD 66 80
 altd ioe ld hl, (0x1234)       ; 76 DB 2A 34 12
 altd ioe ld hl, (hl)           ; 76 DB DD E4 00
 altd ioe ld hl, (hl+0)         ; 76 DB DD E4 00
 altd ioe ld hl, (hl+126)       ; 76 DB DD E4 7E
 altd ioe ld hl, (hl-128)       ; 76 DB DD E4 80
 altd ioe ld hl, (ix)           ; 76 DB FD E4 00
 altd ioe ld hl, (ix+0)         ; 76 DB FD E4 00
 altd ioe ld hl, (ix+126)       ; 76 DB FD E4 7E
 altd ioe ld hl, (ix-128)       ; 76 DB FD E4 80
 altd ioe ld hl, (iy)           ; 76 DB E4 00
 altd ioe ld hl, (iy+0)         ; 76 DB E4 00
 altd ioe ld hl, (iy+126)       ; 76 DB E4 7E
 altd ioe ld hl, (iy-128)       ; 76 DB E4 80
 altd ioe ld l, (hl)            ; 76 DB 6E
 altd ioe ld l, (ix)            ; 76 DB FD 6E 00
 altd ioe ld l, (ix+0)          ; 76 DB FD 6E 00
 altd ioe ld l, (ix+126)        ; 76 DB FD 6E 7E
 altd ioe ld l, (ix-128)        ; 76 DB FD 6E 80
 altd ioe ld l, (iy)            ; 76 DB DD 6E 00
 altd ioe ld l, (iy+0)          ; 76 DB DD 6E 00
 altd ioe ld l, (iy+126)        ; 76 DB DD 6E 7E
 altd ioe ld l, (iy-128)        ; 76 DB DD 6E 80
 altd ioe or (hl)               ; 76 DB B6
 altd ioe or (ix)               ; 76 DB FD B6 00
 altd ioe or (ix+0)             ; 76 DB FD B6 00
 altd ioe or (ix+126)           ; 76 DB FD B6 7E
 altd ioe or (ix-128)           ; 76 DB FD B6 80
 altd ioe or (iy)               ; 76 DB DD B6 00
 altd ioe or (iy+0)             ; 76 DB DD B6 00
 altd ioe or (iy+126)           ; 76 DB DD B6 7E
 altd ioe or (iy-128)           ; 76 DB DD B6 80
 altd ioe res 0, (hl)           ; 76 DB CB 86
 altd ioe res 0, (ix)           ; 76 DB FD CB 00 86
 altd ioe res 0, (ix+0)         ; 76 DB FD CB 00 86
 altd ioe res 0, (ix+126)       ; 76 DB FD CB 7E 86
 altd ioe res 0, (ix-128)       ; 76 DB FD CB 80 86
 altd ioe res 0, (iy)           ; 76 DB DD CB 00 86
 altd ioe res 0, (iy+0)         ; 76 DB DD CB 00 86
 altd ioe res 0, (iy+126)       ; 76 DB DD CB 7E 86
 altd ioe res 0, (iy-128)       ; 76 DB DD CB 80 86
 altd ioe res 1, (hl)           ; 76 DB CB 8E
 altd ioe res 1, (ix)           ; 76 DB FD CB 00 8E
 altd ioe res 1, (ix+0)         ; 76 DB FD CB 00 8E
 altd ioe res 1, (ix+126)       ; 76 DB FD CB 7E 8E
 altd ioe res 1, (ix-128)       ; 76 DB FD CB 80 8E
 altd ioe res 1, (iy)           ; 76 DB DD CB 00 8E
 altd ioe res 1, (iy+0)         ; 76 DB DD CB 00 8E
 altd ioe res 1, (iy+126)       ; 76 DB DD CB 7E 8E
 altd ioe res 1, (iy-128)       ; 76 DB DD CB 80 8E
 altd ioe res 2, (hl)           ; 76 DB CB 96
 altd ioe res 2, (ix)           ; 76 DB FD CB 00 96
 altd ioe res 2, (ix+0)         ; 76 DB FD CB 00 96
 altd ioe res 2, (ix+126)       ; 76 DB FD CB 7E 96
 altd ioe res 2, (ix-128)       ; 76 DB FD CB 80 96
 altd ioe res 2, (iy)           ; 76 DB DD CB 00 96
 altd ioe res 2, (iy+0)         ; 76 DB DD CB 00 96
 altd ioe res 2, (iy+126)       ; 76 DB DD CB 7E 96
 altd ioe res 2, (iy-128)       ; 76 DB DD CB 80 96
 altd ioe res 3, (hl)           ; 76 DB CB 9E
 altd ioe res 3, (ix)           ; 76 DB FD CB 00 9E
 altd ioe res 3, (ix+0)         ; 76 DB FD CB 00 9E
 altd ioe res 3, (ix+126)       ; 76 DB FD CB 7E 9E
 altd ioe res 3, (ix-128)       ; 76 DB FD CB 80 9E
 altd ioe res 3, (iy)           ; 76 DB DD CB 00 9E
 altd ioe res 3, (iy+0)         ; 76 DB DD CB 00 9E
 altd ioe res 3, (iy+126)       ; 76 DB DD CB 7E 9E
 altd ioe res 3, (iy-128)       ; 76 DB DD CB 80 9E
 altd ioe res 4, (hl)           ; 76 DB CB A6
 altd ioe res 4, (ix)           ; 76 DB FD CB 00 A6
 altd ioe res 4, (ix+0)         ; 76 DB FD CB 00 A6
 altd ioe res 4, (ix+126)       ; 76 DB FD CB 7E A6
 altd ioe res 4, (ix-128)       ; 76 DB FD CB 80 A6
 altd ioe res 4, (iy)           ; 76 DB DD CB 00 A6
 altd ioe res 4, (iy+0)         ; 76 DB DD CB 00 A6
 altd ioe res 4, (iy+126)       ; 76 DB DD CB 7E A6
 altd ioe res 4, (iy-128)       ; 76 DB DD CB 80 A6
 altd ioe res 5, (hl)           ; 76 DB CB AE
 altd ioe res 5, (ix)           ; 76 DB FD CB 00 AE
 altd ioe res 5, (ix+0)         ; 76 DB FD CB 00 AE
 altd ioe res 5, (ix+126)       ; 76 DB FD CB 7E AE
 altd ioe res 5, (ix-128)       ; 76 DB FD CB 80 AE
 altd ioe res 5, (iy)           ; 76 DB DD CB 00 AE
 altd ioe res 5, (iy+0)         ; 76 DB DD CB 00 AE
 altd ioe res 5, (iy+126)       ; 76 DB DD CB 7E AE
 altd ioe res 5, (iy-128)       ; 76 DB DD CB 80 AE
 altd ioe res 6, (hl)           ; 76 DB CB B6
 altd ioe res 6, (ix)           ; 76 DB FD CB 00 B6
 altd ioe res 6, (ix+0)         ; 76 DB FD CB 00 B6
 altd ioe res 6, (ix+126)       ; 76 DB FD CB 7E B6
 altd ioe res 6, (ix-128)       ; 76 DB FD CB 80 B6
 altd ioe res 6, (iy)           ; 76 DB DD CB 00 B6
 altd ioe res 6, (iy+0)         ; 76 DB DD CB 00 B6
 altd ioe res 6, (iy+126)       ; 76 DB DD CB 7E B6
 altd ioe res 6, (iy-128)       ; 76 DB DD CB 80 B6
 altd ioe res 7, (hl)           ; 76 DB CB BE
 altd ioe res 7, (ix)           ; 76 DB FD CB 00 BE
 altd ioe res 7, (ix+0)         ; 76 DB FD CB 00 BE
 altd ioe res 7, (ix+126)       ; 76 DB FD CB 7E BE
 altd ioe res 7, (ix-128)       ; 76 DB FD CB 80 BE
 altd ioe res 7, (iy)           ; 76 DB DD CB 00 BE
 altd ioe res 7, (iy+0)         ; 76 DB DD CB 00 BE
 altd ioe res 7, (iy+126)       ; 76 DB DD CB 7E BE
 altd ioe res 7, (iy-128)       ; 76 DB DD CB 80 BE
 altd ioe rl (hl)               ; 76 DB CB 16
 altd ioe rl (ix)               ; 76 DB FD CB 00 16
 altd ioe rl (ix+0)             ; 76 DB FD CB 00 16
 altd ioe rl (ix+126)           ; 76 DB FD CB 7E 16
 altd ioe rl (ix-128)           ; 76 DB FD CB 80 16
 altd ioe rl (iy)               ; 76 DB DD CB 00 16
 altd ioe rl (iy+0)             ; 76 DB DD CB 00 16
 altd ioe rl (iy+126)           ; 76 DB DD CB 7E 16
 altd ioe rl (iy-128)           ; 76 DB DD CB 80 16
 altd ioe rlc (hl)              ; 76 DB CB 06
 altd ioe rlc (ix)              ; 76 DB FD CB 00 06
 altd ioe rlc (ix+0)            ; 76 DB FD CB 00 06
 altd ioe rlc (ix+126)          ; 76 DB FD CB 7E 06
 altd ioe rlc (ix-128)          ; 76 DB FD CB 80 06
 altd ioe rlc (iy)              ; 76 DB DD CB 00 06
 altd ioe rlc (iy+0)            ; 76 DB DD CB 00 06
 altd ioe rlc (iy+126)          ; 76 DB DD CB 7E 06
 altd ioe rlc (iy-128)          ; 76 DB DD CB 80 06
 altd ioe rr (hl)               ; 76 DB CB 1E
 altd ioe rr (ix)               ; 76 DB FD CB 00 1E
 altd ioe rr (ix+0)             ; 76 DB FD CB 00 1E
 altd ioe rr (ix+126)           ; 76 DB FD CB 7E 1E
 altd ioe rr (ix-128)           ; 76 DB FD CB 80 1E
 altd ioe rr (iy)               ; 76 DB DD CB 00 1E
 altd ioe rr (iy+0)             ; 76 DB DD CB 00 1E
 altd ioe rr (iy+126)           ; 76 DB DD CB 7E 1E
 altd ioe rr (iy-128)           ; 76 DB DD CB 80 1E
 altd ioe rrc (hl)              ; 76 DB CB 0E
 altd ioe rrc (ix)              ; 76 DB FD CB 00 0E
 altd ioe rrc (ix+0)            ; 76 DB FD CB 00 0E
 altd ioe rrc (ix+126)          ; 76 DB FD CB 7E 0E
 altd ioe rrc (ix-128)          ; 76 DB FD CB 80 0E
 altd ioe rrc (iy)              ; 76 DB DD CB 00 0E
 altd ioe rrc (iy+0)            ; 76 DB DD CB 00 0E
 altd ioe rrc (iy+126)          ; 76 DB DD CB 7E 0E
 altd ioe rrc (iy-128)          ; 76 DB DD CB 80 0E
 altd ioe sbc a, (hl)           ; 76 DB 9E
 altd ioe sbc a, (ix)           ; 76 DB FD 9E 00
 altd ioe sbc a, (ix+0)         ; 76 DB FD 9E 00
 altd ioe sbc a, (ix+126)       ; 76 DB FD 9E 7E
 altd ioe sbc a, (ix-128)       ; 76 DB FD 9E 80
 altd ioe sbc a, (iy)           ; 76 DB DD 9E 00
 altd ioe sbc a, (iy+0)         ; 76 DB DD 9E 00
 altd ioe sbc a, (iy+126)       ; 76 DB DD 9E 7E
 altd ioe sbc a, (iy-128)       ; 76 DB DD 9E 80
 altd ioe set 0, (hl)           ; 76 DB CB C6
 altd ioe set 0, (ix)           ; 76 DB FD CB 00 C6
 altd ioe set 0, (ix+0)         ; 76 DB FD CB 00 C6
 altd ioe set 0, (ix+126)       ; 76 DB FD CB 7E C6
 altd ioe set 0, (ix-128)       ; 76 DB FD CB 80 C6
 altd ioe set 0, (iy)           ; 76 DB DD CB 00 C6
 altd ioe set 0, (iy+0)         ; 76 DB DD CB 00 C6
 altd ioe set 0, (iy+126)       ; 76 DB DD CB 7E C6
 altd ioe set 0, (iy-128)       ; 76 DB DD CB 80 C6
 altd ioe set 1, (hl)           ; 76 DB CB CE
 altd ioe set 1, (ix)           ; 76 DB FD CB 00 CE
 altd ioe set 1, (ix+0)         ; 76 DB FD CB 00 CE
 altd ioe set 1, (ix+126)       ; 76 DB FD CB 7E CE
 altd ioe set 1, (ix-128)       ; 76 DB FD CB 80 CE
 altd ioe set 1, (iy)           ; 76 DB DD CB 00 CE
 altd ioe set 1, (iy+0)         ; 76 DB DD CB 00 CE
 altd ioe set 1, (iy+126)       ; 76 DB DD CB 7E CE
 altd ioe set 1, (iy-128)       ; 76 DB DD CB 80 CE
 altd ioe set 2, (hl)           ; 76 DB CB D6
 altd ioe set 2, (ix)           ; 76 DB FD CB 00 D6
 altd ioe set 2, (ix+0)         ; 76 DB FD CB 00 D6
 altd ioe set 2, (ix+126)       ; 76 DB FD CB 7E D6
 altd ioe set 2, (ix-128)       ; 76 DB FD CB 80 D6
 altd ioe set 2, (iy)           ; 76 DB DD CB 00 D6
 altd ioe set 2, (iy+0)         ; 76 DB DD CB 00 D6
 altd ioe set 2, (iy+126)       ; 76 DB DD CB 7E D6
 altd ioe set 2, (iy-128)       ; 76 DB DD CB 80 D6
 altd ioe set 3, (hl)           ; 76 DB CB DE
 altd ioe set 3, (ix)           ; 76 DB FD CB 00 DE
 altd ioe set 3, (ix+0)         ; 76 DB FD CB 00 DE
 altd ioe set 3, (ix+126)       ; 76 DB FD CB 7E DE
 altd ioe set 3, (ix-128)       ; 76 DB FD CB 80 DE
 altd ioe set 3, (iy)           ; 76 DB DD CB 00 DE
 altd ioe set 3, (iy+0)         ; 76 DB DD CB 00 DE
 altd ioe set 3, (iy+126)       ; 76 DB DD CB 7E DE
 altd ioe set 3, (iy-128)       ; 76 DB DD CB 80 DE
 altd ioe set 4, (hl)           ; 76 DB CB E6
 altd ioe set 4, (ix)           ; 76 DB FD CB 00 E6
 altd ioe set 4, (ix+0)         ; 76 DB FD CB 00 E6
 altd ioe set 4, (ix+126)       ; 76 DB FD CB 7E E6
 altd ioe set 4, (ix-128)       ; 76 DB FD CB 80 E6
 altd ioe set 4, (iy)           ; 76 DB DD CB 00 E6
 altd ioe set 4, (iy+0)         ; 76 DB DD CB 00 E6
 altd ioe set 4, (iy+126)       ; 76 DB DD CB 7E E6
 altd ioe set 4, (iy-128)       ; 76 DB DD CB 80 E6
 altd ioe set 5, (hl)           ; 76 DB CB EE
 altd ioe set 5, (ix)           ; 76 DB FD CB 00 EE
 altd ioe set 5, (ix+0)         ; 76 DB FD CB 00 EE
 altd ioe set 5, (ix+126)       ; 76 DB FD CB 7E EE
 altd ioe set 5, (ix-128)       ; 76 DB FD CB 80 EE
 altd ioe set 5, (iy)           ; 76 DB DD CB 00 EE
 altd ioe set 5, (iy+0)         ; 76 DB DD CB 00 EE
 altd ioe set 5, (iy+126)       ; 76 DB DD CB 7E EE
 altd ioe set 5, (iy-128)       ; 76 DB DD CB 80 EE
 altd ioe set 6, (hl)           ; 76 DB CB F6
 altd ioe set 6, (ix)           ; 76 DB FD CB 00 F6
 altd ioe set 6, (ix+0)         ; 76 DB FD CB 00 F6
 altd ioe set 6, (ix+126)       ; 76 DB FD CB 7E F6
 altd ioe set 6, (ix-128)       ; 76 DB FD CB 80 F6
 altd ioe set 6, (iy)           ; 76 DB DD CB 00 F6
 altd ioe set 6, (iy+0)         ; 76 DB DD CB 00 F6
 altd ioe set 6, (iy+126)       ; 76 DB DD CB 7E F6
 altd ioe set 6, (iy-128)       ; 76 DB DD CB 80 F6
 altd ioe set 7, (hl)           ; 76 DB CB FE
 altd ioe set 7, (ix)           ; 76 DB FD CB 00 FE
 altd ioe set 7, (ix+0)         ; 76 DB FD CB 00 FE
 altd ioe set 7, (ix+126)       ; 76 DB FD CB 7E FE
 altd ioe set 7, (ix-128)       ; 76 DB FD CB 80 FE
 altd ioe set 7, (iy)           ; 76 DB DD CB 00 FE
 altd ioe set 7, (iy+0)         ; 76 DB DD CB 00 FE
 altd ioe set 7, (iy+126)       ; 76 DB DD CB 7E FE
 altd ioe set 7, (iy-128)       ; 76 DB DD CB 80 FE
 altd ioe sla (hl)              ; 76 DB CB 26
 altd ioe sla (ix)              ; 76 DB FD CB 00 26
 altd ioe sla (ix+0)            ; 76 DB FD CB 00 26
 altd ioe sla (ix+126)          ; 76 DB FD CB 7E 26
 altd ioe sla (ix-128)          ; 76 DB FD CB 80 26
 altd ioe sla (iy)              ; 76 DB DD CB 00 26
 altd ioe sla (iy+0)            ; 76 DB DD CB 00 26
 altd ioe sla (iy+126)          ; 76 DB DD CB 7E 26
 altd ioe sla (iy-128)          ; 76 DB DD CB 80 26
 altd ioe sra (hl)              ; 76 DB CB 2E
 altd ioe sra (ix)              ; 76 DB FD CB 00 2E
 altd ioe sra (ix+0)            ; 76 DB FD CB 00 2E
 altd ioe sra (ix+126)          ; 76 DB FD CB 7E 2E
 altd ioe sra (ix-128)          ; 76 DB FD CB 80 2E
 altd ioe sra (iy)              ; 76 DB DD CB 00 2E
 altd ioe sra (iy+0)            ; 76 DB DD CB 00 2E
 altd ioe sra (iy+126)          ; 76 DB DD CB 7E 2E
 altd ioe sra (iy-128)          ; 76 DB DD CB 80 2E
 altd ioe srl (hl)              ; 76 DB CB 3E
 altd ioe srl (ix)              ; 76 DB FD CB 00 3E
 altd ioe srl (ix+0)            ; 76 DB FD CB 00 3E
 altd ioe srl (ix+126)          ; 76 DB FD CB 7E 3E
 altd ioe srl (ix-128)          ; 76 DB FD CB 80 3E
 altd ioe srl (iy)              ; 76 DB DD CB 00 3E
 altd ioe srl (iy+0)            ; 76 DB DD CB 00 3E
 altd ioe srl (iy+126)          ; 76 DB DD CB 7E 3E
 altd ioe srl (iy-128)          ; 76 DB DD CB 80 3E
 altd ioe sub (hl)              ; 76 DB 96
 altd ioe sub (ix)              ; 76 DB FD 96 00
 altd ioe sub (ix+0)            ; 76 DB FD 96 00
 altd ioe sub (ix+126)          ; 76 DB FD 96 7E
 altd ioe sub (ix-128)          ; 76 DB FD 96 80
 altd ioe sub (iy)              ; 76 DB DD 96 00
 altd ioe sub (iy+0)            ; 76 DB DD 96 00
 altd ioe sub (iy+126)          ; 76 DB DD 96 7E
 altd ioe sub (iy-128)          ; 76 DB DD 96 80
 altd ioe xor (hl)              ; 76 DB AE
 altd ioe xor (ix)              ; 76 DB FD AE 00
 altd ioe xor (ix+0)            ; 76 DB FD AE 00
 altd ioe xor (ix+126)          ; 76 DB FD AE 7E
 altd ioe xor (ix-128)          ; 76 DB FD AE 80
 altd ioe xor (iy)              ; 76 DB DD AE 00
 altd ioe xor (iy+0)            ; 76 DB DD AE 00
 altd ioe xor (iy+126)          ; 76 DB DD AE 7E
 altd ioe xor (iy-128)          ; 76 DB DD AE 80
 altd ioi adc a, (hl)           ; 76 D3 8E
 altd ioi adc a, (ix)           ; 76 D3 FD 8E 00
 altd ioi adc a, (ix+0)         ; 76 D3 FD 8E 00
 altd ioi adc a, (ix+126)       ; 76 D3 FD 8E 7E
 altd ioi adc a, (ix-128)       ; 76 D3 FD 8E 80
 altd ioi adc a, (iy)           ; 76 D3 DD 8E 00
 altd ioi adc a, (iy+0)         ; 76 D3 DD 8E 00
 altd ioi adc a, (iy+126)       ; 76 D3 DD 8E 7E
 altd ioi adc a, (iy-128)       ; 76 D3 DD 8E 80
 altd ioi add a, (hl)           ; 76 D3 86
 altd ioi add a, (ix)           ; 76 D3 FD 86 00
 altd ioi add a, (ix+0)         ; 76 D3 FD 86 00
 altd ioi add a, (ix+126)       ; 76 D3 FD 86 7E
 altd ioi add a, (ix-128)       ; 76 D3 FD 86 80
 altd ioi add a, (iy)           ; 76 D3 DD 86 00
 altd ioi add a, (iy+0)         ; 76 D3 DD 86 00
 altd ioi add a, (iy+126)       ; 76 D3 DD 86 7E
 altd ioi add a, (iy-128)       ; 76 D3 DD 86 80
 altd ioi and (hl)              ; 76 D3 A6
 altd ioi and (ix)              ; 76 D3 FD A6 00
 altd ioi and (ix+0)            ; 76 D3 FD A6 00
 altd ioi and (ix+126)          ; 76 D3 FD A6 7E
 altd ioi and (ix-128)          ; 76 D3 FD A6 80
 altd ioi and (iy)              ; 76 D3 DD A6 00
 altd ioi and (iy+0)            ; 76 D3 DD A6 00
 altd ioi and (iy+126)          ; 76 D3 DD A6 7E
 altd ioi and (iy-128)          ; 76 D3 DD A6 80
 altd ioi bit 0, (hl)           ; 76 D3 CB 46
 altd ioi bit 0, (ix)           ; 76 D3 FD CB 00 46
 altd ioi bit 0, (ix+0)         ; 76 D3 FD CB 00 46
 altd ioi bit 0, (ix+126)       ; 76 D3 FD CB 7E 46
 altd ioi bit 0, (ix-128)       ; 76 D3 FD CB 80 46
 altd ioi bit 0, (iy)           ; 76 D3 DD CB 00 46
 altd ioi bit 0, (iy+0)         ; 76 D3 DD CB 00 46
 altd ioi bit 0, (iy+126)       ; 76 D3 DD CB 7E 46
 altd ioi bit 0, (iy-128)       ; 76 D3 DD CB 80 46
 altd ioi bit 1, (hl)           ; 76 D3 CB 4E
 altd ioi bit 1, (ix)           ; 76 D3 FD CB 00 4E
 altd ioi bit 1, (ix+0)         ; 76 D3 FD CB 00 4E
 altd ioi bit 1, (ix+126)       ; 76 D3 FD CB 7E 4E
 altd ioi bit 1, (ix-128)       ; 76 D3 FD CB 80 4E
 altd ioi bit 1, (iy)           ; 76 D3 DD CB 00 4E
 altd ioi bit 1, (iy+0)         ; 76 D3 DD CB 00 4E
 altd ioi bit 1, (iy+126)       ; 76 D3 DD CB 7E 4E
 altd ioi bit 1, (iy-128)       ; 76 D3 DD CB 80 4E
 altd ioi bit 2, (hl)           ; 76 D3 CB 56
 altd ioi bit 2, (ix)           ; 76 D3 FD CB 00 56
 altd ioi bit 2, (ix+0)         ; 76 D3 FD CB 00 56
 altd ioi bit 2, (ix+126)       ; 76 D3 FD CB 7E 56
 altd ioi bit 2, (ix-128)       ; 76 D3 FD CB 80 56
 altd ioi bit 2, (iy)           ; 76 D3 DD CB 00 56
 altd ioi bit 2, (iy+0)         ; 76 D3 DD CB 00 56
 altd ioi bit 2, (iy+126)       ; 76 D3 DD CB 7E 56
 altd ioi bit 2, (iy-128)       ; 76 D3 DD CB 80 56
 altd ioi bit 3, (hl)           ; 76 D3 CB 5E
 altd ioi bit 3, (ix)           ; 76 D3 FD CB 00 5E
 altd ioi bit 3, (ix+0)         ; 76 D3 FD CB 00 5E
 altd ioi bit 3, (ix+126)       ; 76 D3 FD CB 7E 5E
 altd ioi bit 3, (ix-128)       ; 76 D3 FD CB 80 5E
 altd ioi bit 3, (iy)           ; 76 D3 DD CB 00 5E
 altd ioi bit 3, (iy+0)         ; 76 D3 DD CB 00 5E
 altd ioi bit 3, (iy+126)       ; 76 D3 DD CB 7E 5E
 altd ioi bit 3, (iy-128)       ; 76 D3 DD CB 80 5E
 altd ioi bit 4, (hl)           ; 76 D3 CB 66
 altd ioi bit 4, (ix)           ; 76 D3 FD CB 00 66
 altd ioi bit 4, (ix+0)         ; 76 D3 FD CB 00 66
 altd ioi bit 4, (ix+126)       ; 76 D3 FD CB 7E 66
 altd ioi bit 4, (ix-128)       ; 76 D3 FD CB 80 66
 altd ioi bit 4, (iy)           ; 76 D3 DD CB 00 66
 altd ioi bit 4, (iy+0)         ; 76 D3 DD CB 00 66
 altd ioi bit 4, (iy+126)       ; 76 D3 DD CB 7E 66
 altd ioi bit 4, (iy-128)       ; 76 D3 DD CB 80 66
 altd ioi bit 5, (hl)           ; 76 D3 CB 6E
 altd ioi bit 5, (ix)           ; 76 D3 FD CB 00 6E
 altd ioi bit 5, (ix+0)         ; 76 D3 FD CB 00 6E
 altd ioi bit 5, (ix+126)       ; 76 D3 FD CB 7E 6E
 altd ioi bit 5, (ix-128)       ; 76 D3 FD CB 80 6E
 altd ioi bit 5, (iy)           ; 76 D3 DD CB 00 6E
 altd ioi bit 5, (iy+0)         ; 76 D3 DD CB 00 6E
 altd ioi bit 5, (iy+126)       ; 76 D3 DD CB 7E 6E
 altd ioi bit 5, (iy-128)       ; 76 D3 DD CB 80 6E
 altd ioi bit 6, (hl)           ; 76 D3 CB 76
 altd ioi bit 6, (ix)           ; 76 D3 FD CB 00 76
 altd ioi bit 6, (ix+0)         ; 76 D3 FD CB 00 76
 altd ioi bit 6, (ix+126)       ; 76 D3 FD CB 7E 76
 altd ioi bit 6, (ix-128)       ; 76 D3 FD CB 80 76
 altd ioi bit 6, (iy)           ; 76 D3 DD CB 00 76
 altd ioi bit 6, (iy+0)         ; 76 D3 DD CB 00 76
 altd ioi bit 6, (iy+126)       ; 76 D3 DD CB 7E 76
 altd ioi bit 6, (iy-128)       ; 76 D3 DD CB 80 76
 altd ioi bit 7, (hl)           ; 76 D3 CB 7E
 altd ioi bit 7, (ix)           ; 76 D3 FD CB 00 7E
 altd ioi bit 7, (ix+0)         ; 76 D3 FD CB 00 7E
 altd ioi bit 7, (ix+126)       ; 76 D3 FD CB 7E 7E
 altd ioi bit 7, (ix-128)       ; 76 D3 FD CB 80 7E
 altd ioi bit 7, (iy)           ; 76 D3 DD CB 00 7E
 altd ioi bit 7, (iy+0)         ; 76 D3 DD CB 00 7E
 altd ioi bit 7, (iy+126)       ; 76 D3 DD CB 7E 7E
 altd ioi bit 7, (iy-128)       ; 76 D3 DD CB 80 7E
 altd ioi cp (hl)               ; 76 D3 BE
 altd ioi cp (ix)               ; 76 D3 FD BE 00
 altd ioi cp (ix+0)             ; 76 D3 FD BE 00
 altd ioi cp (ix+126)           ; 76 D3 FD BE 7E
 altd ioi cp (ix-128)           ; 76 D3 FD BE 80
 altd ioi cp (iy)               ; 76 D3 DD BE 00
 altd ioi cp (iy+0)             ; 76 D3 DD BE 00
 altd ioi cp (iy+126)           ; 76 D3 DD BE 7E
 altd ioi cp (iy-128)           ; 76 D3 DD BE 80
 altd ioi dec (hl)              ; 76 D3 35
 altd ioi dec (ix)              ; 76 D3 FD 35 00
 altd ioi dec (ix+0)            ; 76 D3 FD 35 00
 altd ioi dec (ix+126)          ; 76 D3 FD 35 7E
 altd ioi dec (ix-128)          ; 76 D3 FD 35 80
 altd ioi dec (iy)              ; 76 D3 DD 35 00
 altd ioi dec (iy+0)            ; 76 D3 DD 35 00
 altd ioi dec (iy+126)          ; 76 D3 DD 35 7E
 altd ioi dec (iy-128)          ; 76 D3 DD 35 80
 altd ioi inc (hl)              ; 76 D3 34
 altd ioi inc (ix)              ; 76 D3 FD 34 00
 altd ioi inc (ix+0)            ; 76 D3 FD 34 00
 altd ioi inc (ix+126)          ; 76 D3 FD 34 7E
 altd ioi inc (ix-128)          ; 76 D3 FD 34 80
 altd ioi inc (iy)              ; 76 D3 DD 34 00
 altd ioi inc (iy+0)            ; 76 D3 DD 34 00
 altd ioi inc (iy+126)          ; 76 D3 DD 34 7E
 altd ioi inc (iy-128)          ; 76 D3 DD 34 80
 altd ioi ld a, (0x1234)        ; 76 D3 3A 34 12
 altd ioi ld a, (bc)            ; 76 D3 0A
 altd ioi ld a, (de)            ; 76 D3 1A
 altd ioi ld a, (hl)            ; 76 D3 7E
 altd ioi ld a, (ix)            ; 76 D3 FD 7E 00
 altd ioi ld a, (ix+0)          ; 76 D3 FD 7E 00
 altd ioi ld a, (ix+126)        ; 76 D3 FD 7E 7E
 altd ioi ld a, (ix-128)        ; 76 D3 FD 7E 80
 altd ioi ld a, (iy)            ; 76 D3 DD 7E 00
 altd ioi ld a, (iy+0)          ; 76 D3 DD 7E 00
 altd ioi ld a, (iy+126)        ; 76 D3 DD 7E 7E
 altd ioi ld a, (iy-128)        ; 76 D3 DD 7E 80
 altd ioi ld b, (hl)            ; 76 D3 46
 altd ioi ld b, (ix)            ; 76 D3 FD 46 00
 altd ioi ld b, (ix+0)          ; 76 D3 FD 46 00
 altd ioi ld b, (ix+126)        ; 76 D3 FD 46 7E
 altd ioi ld b, (ix-128)        ; 76 D3 FD 46 80
 altd ioi ld b, (iy)            ; 76 D3 DD 46 00
 altd ioi ld b, (iy+0)          ; 76 D3 DD 46 00
 altd ioi ld b, (iy+126)        ; 76 D3 DD 46 7E
 altd ioi ld b, (iy-128)        ; 76 D3 DD 46 80
 altd ioi ld bc, (0x1234)       ; 76 D3 ED 4B 34 12
 altd ioi ld c, (hl)            ; 76 D3 4E
 altd ioi ld c, (ix)            ; 76 D3 FD 4E 00
 altd ioi ld c, (ix+0)          ; 76 D3 FD 4E 00
 altd ioi ld c, (ix+126)        ; 76 D3 FD 4E 7E
 altd ioi ld c, (ix-128)        ; 76 D3 FD 4E 80
 altd ioi ld c, (iy)            ; 76 D3 DD 4E 00
 altd ioi ld c, (iy+0)          ; 76 D3 DD 4E 00
 altd ioi ld c, (iy+126)        ; 76 D3 DD 4E 7E
 altd ioi ld c, (iy-128)        ; 76 D3 DD 4E 80
 altd ioi ld d, (hl)            ; 76 D3 56
 altd ioi ld d, (ix)            ; 76 D3 FD 56 00
 altd ioi ld d, (ix+0)          ; 76 D3 FD 56 00
 altd ioi ld d, (ix+126)        ; 76 D3 FD 56 7E
 altd ioi ld d, (ix-128)        ; 76 D3 FD 56 80
 altd ioi ld d, (iy)            ; 76 D3 DD 56 00
 altd ioi ld d, (iy+0)          ; 76 D3 DD 56 00
 altd ioi ld d, (iy+126)        ; 76 D3 DD 56 7E
 altd ioi ld d, (iy-128)        ; 76 D3 DD 56 80
 altd ioi ld de, (0x1234)       ; 76 D3 ED 5B 34 12
 altd ioi ld e, (hl)            ; 76 D3 5E
 altd ioi ld e, (ix)            ; 76 D3 FD 5E 00
 altd ioi ld e, (ix+0)          ; 76 D3 FD 5E 00
 altd ioi ld e, (ix+126)        ; 76 D3 FD 5E 7E
 altd ioi ld e, (ix-128)        ; 76 D3 FD 5E 80
 altd ioi ld e, (iy)            ; 76 D3 DD 5E 00
 altd ioi ld e, (iy+0)          ; 76 D3 DD 5E 00
 altd ioi ld e, (iy+126)        ; 76 D3 DD 5E 7E
 altd ioi ld e, (iy-128)        ; 76 D3 DD 5E 80
 altd ioi ld h, (hl)            ; 76 D3 66
 altd ioi ld h, (ix)            ; 76 D3 FD 66 00
 altd ioi ld h, (ix+0)          ; 76 D3 FD 66 00
 altd ioi ld h, (ix+126)        ; 76 D3 FD 66 7E
 altd ioi ld h, (ix-128)        ; 76 D3 FD 66 80
 altd ioi ld h, (iy)            ; 76 D3 DD 66 00
 altd ioi ld h, (iy+0)          ; 76 D3 DD 66 00
 altd ioi ld h, (iy+126)        ; 76 D3 DD 66 7E
 altd ioi ld h, (iy-128)        ; 76 D3 DD 66 80
 altd ioi ld hl, (0x1234)       ; 76 D3 2A 34 12
 altd ioi ld hl, (hl)           ; 76 D3 DD E4 00
 altd ioi ld hl, (hl+0)         ; 76 D3 DD E4 00
 altd ioi ld hl, (hl+126)       ; 76 D3 DD E4 7E
 altd ioi ld hl, (hl-128)       ; 76 D3 DD E4 80
 altd ioi ld hl, (ix)           ; 76 D3 FD E4 00
 altd ioi ld hl, (ix+0)         ; 76 D3 FD E4 00
 altd ioi ld hl, (ix+126)       ; 76 D3 FD E4 7E
 altd ioi ld hl, (ix-128)       ; 76 D3 FD E4 80
 altd ioi ld hl, (iy)           ; 76 D3 E4 00
 altd ioi ld hl, (iy+0)         ; 76 D3 E4 00
 altd ioi ld hl, (iy+126)       ; 76 D3 E4 7E
 altd ioi ld hl, (iy-128)       ; 76 D3 E4 80
 altd ioi ld l, (hl)            ; 76 D3 6E
 altd ioi ld l, (ix)            ; 76 D3 FD 6E 00
 altd ioi ld l, (ix+0)          ; 76 D3 FD 6E 00
 altd ioi ld l, (ix+126)        ; 76 D3 FD 6E 7E
 altd ioi ld l, (ix-128)        ; 76 D3 FD 6E 80
 altd ioi ld l, (iy)            ; 76 D3 DD 6E 00
 altd ioi ld l, (iy+0)          ; 76 D3 DD 6E 00
 altd ioi ld l, (iy+126)        ; 76 D3 DD 6E 7E
 altd ioi ld l, (iy-128)        ; 76 D3 DD 6E 80
 altd ioi or (hl)               ; 76 D3 B6
 altd ioi or (ix)               ; 76 D3 FD B6 00
 altd ioi or (ix+0)             ; 76 D3 FD B6 00
 altd ioi or (ix+126)           ; 76 D3 FD B6 7E
 altd ioi or (ix-128)           ; 76 D3 FD B6 80
 altd ioi or (iy)               ; 76 D3 DD B6 00
 altd ioi or (iy+0)             ; 76 D3 DD B6 00
 altd ioi or (iy+126)           ; 76 D3 DD B6 7E
 altd ioi or (iy-128)           ; 76 D3 DD B6 80
 altd ioi res 0, (hl)           ; 76 D3 CB 86
 altd ioi res 0, (ix)           ; 76 D3 FD CB 00 86
 altd ioi res 0, (ix+0)         ; 76 D3 FD CB 00 86
 altd ioi res 0, (ix+126)       ; 76 D3 FD CB 7E 86
 altd ioi res 0, (ix-128)       ; 76 D3 FD CB 80 86
 altd ioi res 0, (iy)           ; 76 D3 DD CB 00 86
 altd ioi res 0, (iy+0)         ; 76 D3 DD CB 00 86
 altd ioi res 0, (iy+126)       ; 76 D3 DD CB 7E 86
 altd ioi res 0, (iy-128)       ; 76 D3 DD CB 80 86
 altd ioi res 1, (hl)           ; 76 D3 CB 8E
 altd ioi res 1, (ix)           ; 76 D3 FD CB 00 8E
 altd ioi res 1, (ix+0)         ; 76 D3 FD CB 00 8E
 altd ioi res 1, (ix+126)       ; 76 D3 FD CB 7E 8E
 altd ioi res 1, (ix-128)       ; 76 D3 FD CB 80 8E
 altd ioi res 1, (iy)           ; 76 D3 DD CB 00 8E
 altd ioi res 1, (iy+0)         ; 76 D3 DD CB 00 8E
 altd ioi res 1, (iy+126)       ; 76 D3 DD CB 7E 8E
 altd ioi res 1, (iy-128)       ; 76 D3 DD CB 80 8E
 altd ioi res 2, (hl)           ; 76 D3 CB 96
 altd ioi res 2, (ix)           ; 76 D3 FD CB 00 96
 altd ioi res 2, (ix+0)         ; 76 D3 FD CB 00 96
 altd ioi res 2, (ix+126)       ; 76 D3 FD CB 7E 96
 altd ioi res 2, (ix-128)       ; 76 D3 FD CB 80 96
 altd ioi res 2, (iy)           ; 76 D3 DD CB 00 96
 altd ioi res 2, (iy+0)         ; 76 D3 DD CB 00 96
 altd ioi res 2, (iy+126)       ; 76 D3 DD CB 7E 96
 altd ioi res 2, (iy-128)       ; 76 D3 DD CB 80 96
 altd ioi res 3, (hl)           ; 76 D3 CB 9E
 altd ioi res 3, (ix)           ; 76 D3 FD CB 00 9E
 altd ioi res 3, (ix+0)         ; 76 D3 FD CB 00 9E
 altd ioi res 3, (ix+126)       ; 76 D3 FD CB 7E 9E
 altd ioi res 3, (ix-128)       ; 76 D3 FD CB 80 9E
 altd ioi res 3, (iy)           ; 76 D3 DD CB 00 9E
 altd ioi res 3, (iy+0)         ; 76 D3 DD CB 00 9E
 altd ioi res 3, (iy+126)       ; 76 D3 DD CB 7E 9E
 altd ioi res 3, (iy-128)       ; 76 D3 DD CB 80 9E
 altd ioi res 4, (hl)           ; 76 D3 CB A6
 altd ioi res 4, (ix)           ; 76 D3 FD CB 00 A6
 altd ioi res 4, (ix+0)         ; 76 D3 FD CB 00 A6
 altd ioi res 4, (ix+126)       ; 76 D3 FD CB 7E A6
 altd ioi res 4, (ix-128)       ; 76 D3 FD CB 80 A6
 altd ioi res 4, (iy)           ; 76 D3 DD CB 00 A6
 altd ioi res 4, (iy+0)         ; 76 D3 DD CB 00 A6
 altd ioi res 4, (iy+126)       ; 76 D3 DD CB 7E A6
 altd ioi res 4, (iy-128)       ; 76 D3 DD CB 80 A6
 altd ioi res 5, (hl)           ; 76 D3 CB AE
 altd ioi res 5, (ix)           ; 76 D3 FD CB 00 AE
 altd ioi res 5, (ix+0)         ; 76 D3 FD CB 00 AE
 altd ioi res 5, (ix+126)       ; 76 D3 FD CB 7E AE
 altd ioi res 5, (ix-128)       ; 76 D3 FD CB 80 AE
 altd ioi res 5, (iy)           ; 76 D3 DD CB 00 AE
 altd ioi res 5, (iy+0)         ; 76 D3 DD CB 00 AE
 altd ioi res 5, (iy+126)       ; 76 D3 DD CB 7E AE
 altd ioi res 5, (iy-128)       ; 76 D3 DD CB 80 AE
 altd ioi res 6, (hl)           ; 76 D3 CB B6
 altd ioi res 6, (ix)           ; 76 D3 FD CB 00 B6
 altd ioi res 6, (ix+0)         ; 76 D3 FD CB 00 B6
 altd ioi res 6, (ix+126)       ; 76 D3 FD CB 7E B6
 altd ioi res 6, (ix-128)       ; 76 D3 FD CB 80 B6
 altd ioi res 6, (iy)           ; 76 D3 DD CB 00 B6
 altd ioi res 6, (iy+0)         ; 76 D3 DD CB 00 B6
 altd ioi res 6, (iy+126)       ; 76 D3 DD CB 7E B6
 altd ioi res 6, (iy-128)       ; 76 D3 DD CB 80 B6
 altd ioi res 7, (hl)           ; 76 D3 CB BE
 altd ioi res 7, (ix)           ; 76 D3 FD CB 00 BE
 altd ioi res 7, (ix+0)         ; 76 D3 FD CB 00 BE
 altd ioi res 7, (ix+126)       ; 76 D3 FD CB 7E BE
 altd ioi res 7, (ix-128)       ; 76 D3 FD CB 80 BE
 altd ioi res 7, (iy)           ; 76 D3 DD CB 00 BE
 altd ioi res 7, (iy+0)         ; 76 D3 DD CB 00 BE
 altd ioi res 7, (iy+126)       ; 76 D3 DD CB 7E BE
 altd ioi res 7, (iy-128)       ; 76 D3 DD CB 80 BE
 altd ioi rl (hl)               ; 76 D3 CB 16
 altd ioi rl (ix)               ; 76 D3 FD CB 00 16
 altd ioi rl (ix+0)             ; 76 D3 FD CB 00 16
 altd ioi rl (ix+126)           ; 76 D3 FD CB 7E 16
 altd ioi rl (ix-128)           ; 76 D3 FD CB 80 16
 altd ioi rl (iy)               ; 76 D3 DD CB 00 16
 altd ioi rl (iy+0)             ; 76 D3 DD CB 00 16
 altd ioi rl (iy+126)           ; 76 D3 DD CB 7E 16
 altd ioi rl (iy-128)           ; 76 D3 DD CB 80 16
 altd ioi rlc (hl)              ; 76 D3 CB 06
 altd ioi rlc (ix)              ; 76 D3 FD CB 00 06
 altd ioi rlc (ix+0)            ; 76 D3 FD CB 00 06
 altd ioi rlc (ix+126)          ; 76 D3 FD CB 7E 06
 altd ioi rlc (ix-128)          ; 76 D3 FD CB 80 06
 altd ioi rlc (iy)              ; 76 D3 DD CB 00 06
 altd ioi rlc (iy+0)            ; 76 D3 DD CB 00 06
 altd ioi rlc (iy+126)          ; 76 D3 DD CB 7E 06
 altd ioi rlc (iy-128)          ; 76 D3 DD CB 80 06
 altd ioi rr (hl)               ; 76 D3 CB 1E
 altd ioi rr (ix)               ; 76 D3 FD CB 00 1E
 altd ioi rr (ix+0)             ; 76 D3 FD CB 00 1E
 altd ioi rr (ix+126)           ; 76 D3 FD CB 7E 1E
 altd ioi rr (ix-128)           ; 76 D3 FD CB 80 1E
 altd ioi rr (iy)               ; 76 D3 DD CB 00 1E
 altd ioi rr (iy+0)             ; 76 D3 DD CB 00 1E
 altd ioi rr (iy+126)           ; 76 D3 DD CB 7E 1E
 altd ioi rr (iy-128)           ; 76 D3 DD CB 80 1E
 altd ioi rrc (hl)              ; 76 D3 CB 0E
 altd ioi rrc (ix)              ; 76 D3 FD CB 00 0E
 altd ioi rrc (ix+0)            ; 76 D3 FD CB 00 0E
 altd ioi rrc (ix+126)          ; 76 D3 FD CB 7E 0E
 altd ioi rrc (ix-128)          ; 76 D3 FD CB 80 0E
 altd ioi rrc (iy)              ; 76 D3 DD CB 00 0E
 altd ioi rrc (iy+0)            ; 76 D3 DD CB 00 0E
 altd ioi rrc (iy+126)          ; 76 D3 DD CB 7E 0E
 altd ioi rrc (iy-128)          ; 76 D3 DD CB 80 0E
 altd ioi sbc a, (hl)           ; 76 D3 9E
 altd ioi sbc a, (ix)           ; 76 D3 FD 9E 00
 altd ioi sbc a, (ix+0)         ; 76 D3 FD 9E 00
 altd ioi sbc a, (ix+126)       ; 76 D3 FD 9E 7E
 altd ioi sbc a, (ix-128)       ; 76 D3 FD 9E 80
 altd ioi sbc a, (iy)           ; 76 D3 DD 9E 00
 altd ioi sbc a, (iy+0)         ; 76 D3 DD 9E 00
 altd ioi sbc a, (iy+126)       ; 76 D3 DD 9E 7E
 altd ioi sbc a, (iy-128)       ; 76 D3 DD 9E 80
 altd ioi set 0, (hl)           ; 76 D3 CB C6
 altd ioi set 0, (ix)           ; 76 D3 FD CB 00 C6
 altd ioi set 0, (ix+0)         ; 76 D3 FD CB 00 C6
 altd ioi set 0, (ix+126)       ; 76 D3 FD CB 7E C6
 altd ioi set 0, (ix-128)       ; 76 D3 FD CB 80 C6
 altd ioi set 0, (iy)           ; 76 D3 DD CB 00 C6
 altd ioi set 0, (iy+0)         ; 76 D3 DD CB 00 C6
 altd ioi set 0, (iy+126)       ; 76 D3 DD CB 7E C6
 altd ioi set 0, (iy-128)       ; 76 D3 DD CB 80 C6
 altd ioi set 1, (hl)           ; 76 D3 CB CE
 altd ioi set 1, (ix)           ; 76 D3 FD CB 00 CE
 altd ioi set 1, (ix+0)         ; 76 D3 FD CB 00 CE
 altd ioi set 1, (ix+126)       ; 76 D3 FD CB 7E CE
 altd ioi set 1, (ix-128)       ; 76 D3 FD CB 80 CE
 altd ioi set 1, (iy)           ; 76 D3 DD CB 00 CE
 altd ioi set 1, (iy+0)         ; 76 D3 DD CB 00 CE
 altd ioi set 1, (iy+126)       ; 76 D3 DD CB 7E CE
 altd ioi set 1, (iy-128)       ; 76 D3 DD CB 80 CE
 altd ioi set 2, (hl)           ; 76 D3 CB D6
 altd ioi set 2, (ix)           ; 76 D3 FD CB 00 D6
 altd ioi set 2, (ix+0)         ; 76 D3 FD CB 00 D6
 altd ioi set 2, (ix+126)       ; 76 D3 FD CB 7E D6
 altd ioi set 2, (ix-128)       ; 76 D3 FD CB 80 D6
 altd ioi set 2, (iy)           ; 76 D3 DD CB 00 D6
 altd ioi set 2, (iy+0)         ; 76 D3 DD CB 00 D6
 altd ioi set 2, (iy+126)       ; 76 D3 DD CB 7E D6
 altd ioi set 2, (iy-128)       ; 76 D3 DD CB 80 D6
 altd ioi set 3, (hl)           ; 76 D3 CB DE
 altd ioi set 3, (ix)           ; 76 D3 FD CB 00 DE
 altd ioi set 3, (ix+0)         ; 76 D3 FD CB 00 DE
 altd ioi set 3, (ix+126)       ; 76 D3 FD CB 7E DE
 altd ioi set 3, (ix-128)       ; 76 D3 FD CB 80 DE
 altd ioi set 3, (iy)           ; 76 D3 DD CB 00 DE
 altd ioi set 3, (iy+0)         ; 76 D3 DD CB 00 DE
 altd ioi set 3, (iy+126)       ; 76 D3 DD CB 7E DE
 altd ioi set 3, (iy-128)       ; 76 D3 DD CB 80 DE
 altd ioi set 4, (hl)           ; 76 D3 CB E6
 altd ioi set 4, (ix)           ; 76 D3 FD CB 00 E6
 altd ioi set 4, (ix+0)         ; 76 D3 FD CB 00 E6
 altd ioi set 4, (ix+126)       ; 76 D3 FD CB 7E E6
 altd ioi set 4, (ix-128)       ; 76 D3 FD CB 80 E6
 altd ioi set 4, (iy)           ; 76 D3 DD CB 00 E6
 altd ioi set 4, (iy+0)         ; 76 D3 DD CB 00 E6
 altd ioi set 4, (iy+126)       ; 76 D3 DD CB 7E E6
 altd ioi set 4, (iy-128)       ; 76 D3 DD CB 80 E6
 altd ioi set 5, (hl)           ; 76 D3 CB EE
 altd ioi set 5, (ix)           ; 76 D3 FD CB 00 EE
 altd ioi set 5, (ix+0)         ; 76 D3 FD CB 00 EE
 altd ioi set 5, (ix+126)       ; 76 D3 FD CB 7E EE
 altd ioi set 5, (ix-128)       ; 76 D3 FD CB 80 EE
 altd ioi set 5, (iy)           ; 76 D3 DD CB 00 EE
 altd ioi set 5, (iy+0)         ; 76 D3 DD CB 00 EE
 altd ioi set 5, (iy+126)       ; 76 D3 DD CB 7E EE
 altd ioi set 5, (iy-128)       ; 76 D3 DD CB 80 EE
 altd ioi set 6, (hl)           ; 76 D3 CB F6
 altd ioi set 6, (ix)           ; 76 D3 FD CB 00 F6
 altd ioi set 6, (ix+0)         ; 76 D3 FD CB 00 F6
 altd ioi set 6, (ix+126)       ; 76 D3 FD CB 7E F6
 altd ioi set 6, (ix-128)       ; 76 D3 FD CB 80 F6
 altd ioi set 6, (iy)           ; 76 D3 DD CB 00 F6
 altd ioi set 6, (iy+0)         ; 76 D3 DD CB 00 F6
 altd ioi set 6, (iy+126)       ; 76 D3 DD CB 7E F6
 altd ioi set 6, (iy-128)       ; 76 D3 DD CB 80 F6
 altd ioi set 7, (hl)           ; 76 D3 CB FE
 altd ioi set 7, (ix)           ; 76 D3 FD CB 00 FE
 altd ioi set 7, (ix+0)         ; 76 D3 FD CB 00 FE
 altd ioi set 7, (ix+126)       ; 76 D3 FD CB 7E FE
 altd ioi set 7, (ix-128)       ; 76 D3 FD CB 80 FE
 altd ioi set 7, (iy)           ; 76 D3 DD CB 00 FE
 altd ioi set 7, (iy+0)         ; 76 D3 DD CB 00 FE
 altd ioi set 7, (iy+126)       ; 76 D3 DD CB 7E FE
 altd ioi set 7, (iy-128)       ; 76 D3 DD CB 80 FE
 altd ioi sla (hl)              ; 76 D3 CB 26
 altd ioi sla (ix)              ; 76 D3 FD CB 00 26
 altd ioi sla (ix+0)            ; 76 D3 FD CB 00 26
 altd ioi sla (ix+126)          ; 76 D3 FD CB 7E 26
 altd ioi sla (ix-128)          ; 76 D3 FD CB 80 26
 altd ioi sla (iy)              ; 76 D3 DD CB 00 26
 altd ioi sla (iy+0)            ; 76 D3 DD CB 00 26
 altd ioi sla (iy+126)          ; 76 D3 DD CB 7E 26
 altd ioi sla (iy-128)          ; 76 D3 DD CB 80 26
 altd ioi sra (hl)              ; 76 D3 CB 2E
 altd ioi sra (ix)              ; 76 D3 FD CB 00 2E
 altd ioi sra (ix+0)            ; 76 D3 FD CB 00 2E
 altd ioi sra (ix+126)          ; 76 D3 FD CB 7E 2E
 altd ioi sra (ix-128)          ; 76 D3 FD CB 80 2E
 altd ioi sra (iy)              ; 76 D3 DD CB 00 2E
 altd ioi sra (iy+0)            ; 76 D3 DD CB 00 2E
 altd ioi sra (iy+126)          ; 76 D3 DD CB 7E 2E
 altd ioi sra (iy-128)          ; 76 D3 DD CB 80 2E
 altd ioi srl (hl)              ; 76 D3 CB 3E
 altd ioi srl (ix)              ; 76 D3 FD CB 00 3E
 altd ioi srl (ix+0)            ; 76 D3 FD CB 00 3E
 altd ioi srl (ix+126)          ; 76 D3 FD CB 7E 3E
 altd ioi srl (ix-128)          ; 76 D3 FD CB 80 3E
 altd ioi srl (iy)              ; 76 D3 DD CB 00 3E
 altd ioi srl (iy+0)            ; 76 D3 DD CB 00 3E
 altd ioi srl (iy+126)          ; 76 D3 DD CB 7E 3E
 altd ioi srl (iy-128)          ; 76 D3 DD CB 80 3E
 altd ioi sub (hl)              ; 76 D3 96
 altd ioi sub (ix)              ; 76 D3 FD 96 00
 altd ioi sub (ix+0)            ; 76 D3 FD 96 00
 altd ioi sub (ix+126)          ; 76 D3 FD 96 7E
 altd ioi sub (ix-128)          ; 76 D3 FD 96 80
 altd ioi sub (iy)              ; 76 D3 DD 96 00
 altd ioi sub (iy+0)            ; 76 D3 DD 96 00
 altd ioi sub (iy+126)          ; 76 D3 DD 96 7E
 altd ioi sub (iy-128)          ; 76 D3 DD 96 80
 altd ioi xor (hl)              ; 76 D3 AE
 altd ioi xor (ix)              ; 76 D3 FD AE 00
 altd ioi xor (ix+0)            ; 76 D3 FD AE 00
 altd ioi xor (ix+126)          ; 76 D3 FD AE 7E
 altd ioi xor (ix-128)          ; 76 D3 FD AE 80
 altd ioi xor (iy)              ; 76 D3 DD AE 00
 altd ioi xor (iy+0)            ; 76 D3 DD AE 00
 altd ioi xor (iy+126)          ; 76 D3 DD AE 7E
 altd ioi xor (iy-128)          ; 76 D3 DD AE 80
 altd ld a, (0x1234)            ; 76 3A 34 12
 altd ld a, (bc)                ; 76 0A
 altd ld a, (de)                ; 76 1A
 altd ld a, (hl)                ; 76 7E
 altd ld a, (ix)                ; 76 FD 7E 00
 altd ld a, (ix+0)              ; 76 FD 7E 00
 altd ld a, (ix+126)            ; 76 FD 7E 7E
 altd ld a, (ix-128)            ; 76 FD 7E 80
 altd ld a, (iy)                ; 76 DD 7E 00
 altd ld a, (iy+0)              ; 76 DD 7E 00
 altd ld a, (iy+126)            ; 76 DD 7E 7E
 altd ld a, (iy-128)            ; 76 DD 7E 80
 altd ld a, 0                   ; 76 3E 00
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
 altd ld b, (ix+0)              ; 76 FD 46 00
 altd ld b, (ix+126)            ; 76 FD 46 7E
 altd ld b, (ix-128)            ; 76 FD 46 80
 altd ld b, (iy)                ; 76 DD 46 00
 altd ld b, (iy+0)              ; 76 DD 46 00
 altd ld b, (iy+126)            ; 76 DD 46 7E
 altd ld b, (iy-128)            ; 76 DD 46 80
 altd ld b, 0                   ; 76 06 00
 altd ld b, 127                 ; 76 06 7F
 altd ld b, 255                 ; 76 06 FF
 altd ld b, a                   ; 76 47
 altd ld b, b                   ; 76 40
 altd ld b, c                   ; 76 41
 altd ld b, d                   ; 76 42
 altd ld b, e                   ; 76 43
 altd ld b, h                   ; 76 44
 altd ld b, l                   ; 76 45
 altd ld bc, (0x1234)           ; 76 ED 4B 34 12
 altd ld bc, 0x1234             ; 76 01 34 12
 altd ld bc, bc                 ; ED 49
 altd ld bc, de                 ; ED 41
 altd ld c, (hl)                ; 76 4E
 altd ld c, (ix)                ; 76 FD 4E 00
 altd ld c, (ix+0)              ; 76 FD 4E 00
 altd ld c, (ix+126)            ; 76 FD 4E 7E
 altd ld c, (ix-128)            ; 76 FD 4E 80
 altd ld c, (iy)                ; 76 DD 4E 00
 altd ld c, (iy+0)              ; 76 DD 4E 00
 altd ld c, (iy+126)            ; 76 DD 4E 7E
 altd ld c, (iy-128)            ; 76 DD 4E 80
 altd ld c, 0                   ; 76 0E 00
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
 altd ld d, (ix+0)              ; 76 FD 56 00
 altd ld d, (ix+126)            ; 76 FD 56 7E
 altd ld d, (ix-128)            ; 76 FD 56 80
 altd ld d, (iy)                ; 76 DD 56 00
 altd ld d, (iy+0)              ; 76 DD 56 00
 altd ld d, (iy+126)            ; 76 DD 56 7E
 altd ld d, (iy-128)            ; 76 DD 56 80
 altd ld d, 0                   ; 76 16 00
 altd ld d, 127                 ; 76 16 7F
 altd ld d, 255                 ; 76 16 FF
 altd ld d, a                   ; 76 57
 altd ld d, b                   ; 76 50
 altd ld d, c                   ; 76 51
 altd ld d, d                   ; 76 52
 altd ld d, e                   ; 76 53
 altd ld d, h                   ; 76 54
 altd ld d, l                   ; 76 55
 altd ld de, (0x1234)           ; 76 ED 5B 34 12
 altd ld de, 0x1234             ; 76 11 34 12
 altd ld de, bc                 ; ED 59
 altd ld de, de                 ; ED 51
 altd ld e, (hl)                ; 76 5E
 altd ld e, (ix)                ; 76 FD 5E 00
 altd ld e, (ix+0)              ; 76 FD 5E 00
 altd ld e, (ix+126)            ; 76 FD 5E 7E
 altd ld e, (ix-128)            ; 76 FD 5E 80
 altd ld e, (iy)                ; 76 DD 5E 00
 altd ld e, (iy+0)              ; 76 DD 5E 00
 altd ld e, (iy+126)            ; 76 DD 5E 7E
 altd ld e, (iy-128)            ; 76 DD 5E 80
 altd ld e, 0                   ; 76 1E 00
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
 altd ld h, (ix+0)              ; 76 FD 66 00
 altd ld h, (ix+126)            ; 76 FD 66 7E
 altd ld h, (ix-128)            ; 76 FD 66 80
 altd ld h, (iy)                ; 76 DD 66 00
 altd ld h, (iy+0)              ; 76 DD 66 00
 altd ld h, (iy+126)            ; 76 DD 66 7E
 altd ld h, (iy-128)            ; 76 DD 66 80
 altd ld h, 0                   ; 76 26 00
 altd ld h, 127                 ; 76 26 7F
 altd ld h, 255                 ; 76 26 FF
 altd ld h, a                   ; 76 67
 altd ld h, b                   ; 76 60
 altd ld h, c                   ; 76 61
 altd ld h, d                   ; 76 62
 altd ld h, e                   ; 76 63
 altd ld h, h                   ; 76 64
 altd ld h, l                   ; 76 65
 altd ld hl, (0x1234)           ; 76 2A 34 12
 altd ld hl, (hl)               ; 76 DD E4 00
 altd ld hl, (hl+0)             ; 76 DD E4 00
 altd ld hl, (hl+126)           ; 76 DD E4 7E
 altd ld hl, (hl-128)           ; 76 DD E4 80
 altd ld hl, (ix)               ; 76 FD E4 00
 altd ld hl, (ix+0)             ; 76 FD E4 00
 altd ld hl, (ix+126)           ; 76 FD E4 7E
 altd ld hl, (ix-128)           ; 76 FD E4 80
 altd ld hl, (iy)               ; 76 E4 00
 altd ld hl, (iy+0)             ; 76 E4 00
 altd ld hl, (iy+126)           ; 76 E4 7E
 altd ld hl, (iy-128)           ; 76 E4 80
 altd ld hl, (sp)               ; 76 C4 00
 altd ld hl, (sp+0)             ; 76 C4 00
 altd ld hl, (sp+127)           ; 76 C4 7F
 altd ld hl, (sp+255)           ; 76 C4 FF
 altd ld hl, 0x1234             ; 76 21 34 12
 altd ld hl, bc                 ; ED 69
 altd ld hl, de                 ; ED 61
 altd ld hl, ix                 ; 76 FD 7C
 altd ld hl, iy                 ; 76 DD 7C
 altd ld l, (hl)                ; 76 6E
 altd ld l, (ix)                ; 76 FD 6E 00
 altd ld l, (ix+0)              ; 76 FD 6E 00
 altd ld l, (ix+126)            ; 76 FD 6E 7E
 altd ld l, (ix-128)            ; 76 FD 6E 80
 altd ld l, (iy)                ; 76 DD 6E 00
 altd ld l, (iy+0)              ; 76 DD 6E 00
 altd ld l, (iy+126)            ; 76 DD 6E 7E
 altd ld l, (iy-128)            ; 76 DD 6E 80
 altd ld l, 0                   ; 76 2E 00
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
 altd or (hl)                   ; 76 B6
 altd or (ix)                   ; 76 FD B6 00
 altd or (ix+0)                 ; 76 FD B6 00
 altd or (ix+126)               ; 76 FD B6 7E
 altd or (ix-128)               ; 76 FD B6 80
 altd or (iy)                   ; 76 DD B6 00
 altd or (iy+0)                 ; 76 DD B6 00
 altd or (iy+126)               ; 76 DD B6 7E
 altd or (iy-128)               ; 76 DD B6 80
 altd or 0                      ; 76 F6 00
 altd or 127                    ; 76 F6 7F
 altd or 255                    ; 76 F6 FF
 altd or a                      ; 76 B7
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
 altd res 0, (hl)               ; 76 CB 86
 altd res 0, (ix)               ; 76 FD CB 00 86
 altd res 0, (ix+0)             ; 76 FD CB 00 86
 altd res 0, (ix+126)           ; 76 FD CB 7E 86
 altd res 0, (ix-128)           ; 76 FD CB 80 86
 altd res 0, (iy)               ; 76 DD CB 00 86
 altd res 0, (iy+0)             ; 76 DD CB 00 86
 altd res 0, (iy+126)           ; 76 DD CB 7E 86
 altd res 0, (iy-128)           ; 76 DD CB 80 86
 altd res 0, a                  ; 76 CB 87
 altd res 0, b                  ; 76 CB 80
 altd res 0, c                  ; 76 CB 81
 altd res 0, d                  ; 76 CB 82
 altd res 0, e                  ; 76 CB 83
 altd res 0, h                  ; 76 CB 84
 altd res 0, l                  ; 76 CB 85
 altd res 1, (hl)               ; 76 CB 8E
 altd res 1, (ix)               ; 76 FD CB 00 8E
 altd res 1, (ix+0)             ; 76 FD CB 00 8E
 altd res 1, (ix+126)           ; 76 FD CB 7E 8E
 altd res 1, (ix-128)           ; 76 FD CB 80 8E
 altd res 1, (iy)               ; 76 DD CB 00 8E
 altd res 1, (iy+0)             ; 76 DD CB 00 8E
 altd res 1, (iy+126)           ; 76 DD CB 7E 8E
 altd res 1, (iy-128)           ; 76 DD CB 80 8E
 altd res 1, a                  ; 76 CB 8F
 altd res 1, b                  ; 76 CB 88
 altd res 1, c                  ; 76 CB 89
 altd res 1, d                  ; 76 CB 8A
 altd res 1, e                  ; 76 CB 8B
 altd res 1, h                  ; 76 CB 8C
 altd res 1, l                  ; 76 CB 8D
 altd res 2, (hl)               ; 76 CB 96
 altd res 2, (ix)               ; 76 FD CB 00 96
 altd res 2, (ix+0)             ; 76 FD CB 00 96
 altd res 2, (ix+126)           ; 76 FD CB 7E 96
 altd res 2, (ix-128)           ; 76 FD CB 80 96
 altd res 2, (iy)               ; 76 DD CB 00 96
 altd res 2, (iy+0)             ; 76 DD CB 00 96
 altd res 2, (iy+126)           ; 76 DD CB 7E 96
 altd res 2, (iy-128)           ; 76 DD CB 80 96
 altd res 2, a                  ; 76 CB 97
 altd res 2, b                  ; 76 CB 90
 altd res 2, c                  ; 76 CB 91
 altd res 2, d                  ; 76 CB 92
 altd res 2, e                  ; 76 CB 93
 altd res 2, h                  ; 76 CB 94
 altd res 2, l                  ; 76 CB 95
 altd res 3, (hl)               ; 76 CB 9E
 altd res 3, (ix)               ; 76 FD CB 00 9E
 altd res 3, (ix+0)             ; 76 FD CB 00 9E
 altd res 3, (ix+126)           ; 76 FD CB 7E 9E
 altd res 3, (ix-128)           ; 76 FD CB 80 9E
 altd res 3, (iy)               ; 76 DD CB 00 9E
 altd res 3, (iy+0)             ; 76 DD CB 00 9E
 altd res 3, (iy+126)           ; 76 DD CB 7E 9E
 altd res 3, (iy-128)           ; 76 DD CB 80 9E
 altd res 3, a                  ; 76 CB 9F
 altd res 3, b                  ; 76 CB 98
 altd res 3, c                  ; 76 CB 99
 altd res 3, d                  ; 76 CB 9A
 altd res 3, e                  ; 76 CB 9B
 altd res 3, h                  ; 76 CB 9C
 altd res 3, l                  ; 76 CB 9D
 altd res 4, (hl)               ; 76 CB A6
 altd res 4, (ix)               ; 76 FD CB 00 A6
 altd res 4, (ix+0)             ; 76 FD CB 00 A6
 altd res 4, (ix+126)           ; 76 FD CB 7E A6
 altd res 4, (ix-128)           ; 76 FD CB 80 A6
 altd res 4, (iy)               ; 76 DD CB 00 A6
 altd res 4, (iy+0)             ; 76 DD CB 00 A6
 altd res 4, (iy+126)           ; 76 DD CB 7E A6
 altd res 4, (iy-128)           ; 76 DD CB 80 A6
 altd res 4, a                  ; 76 CB A7
 altd res 4, b                  ; 76 CB A0
 altd res 4, c                  ; 76 CB A1
 altd res 4, d                  ; 76 CB A2
 altd res 4, e                  ; 76 CB A3
 altd res 4, h                  ; 76 CB A4
 altd res 4, l                  ; 76 CB A5
 altd res 5, (hl)               ; 76 CB AE
 altd res 5, (ix)               ; 76 FD CB 00 AE
 altd res 5, (ix+0)             ; 76 FD CB 00 AE
 altd res 5, (ix+126)           ; 76 FD CB 7E AE
 altd res 5, (ix-128)           ; 76 FD CB 80 AE
 altd res 5, (iy)               ; 76 DD CB 00 AE
 altd res 5, (iy+0)             ; 76 DD CB 00 AE
 altd res 5, (iy+126)           ; 76 DD CB 7E AE
 altd res 5, (iy-128)           ; 76 DD CB 80 AE
 altd res 5, a                  ; 76 CB AF
 altd res 5, b                  ; 76 CB A8
 altd res 5, c                  ; 76 CB A9
 altd res 5, d                  ; 76 CB AA
 altd res 5, e                  ; 76 CB AB
 altd res 5, h                  ; 76 CB AC
 altd res 5, l                  ; 76 CB AD
 altd res 6, (hl)               ; 76 CB B6
 altd res 6, (ix)               ; 76 FD CB 00 B6
 altd res 6, (ix+0)             ; 76 FD CB 00 B6
 altd res 6, (ix+126)           ; 76 FD CB 7E B6
 altd res 6, (ix-128)           ; 76 FD CB 80 B6
 altd res 6, (iy)               ; 76 DD CB 00 B6
 altd res 6, (iy+0)             ; 76 DD CB 00 B6
 altd res 6, (iy+126)           ; 76 DD CB 7E B6
 altd res 6, (iy-128)           ; 76 DD CB 80 B6
 altd res 6, a                  ; 76 CB B7
 altd res 6, b                  ; 76 CB B0
 altd res 6, c                  ; 76 CB B1
 altd res 6, d                  ; 76 CB B2
 altd res 6, e                  ; 76 CB B3
 altd res 6, h                  ; 76 CB B4
 altd res 6, l                  ; 76 CB B5
 altd res 7, (hl)               ; 76 CB BE
 altd res 7, (ix)               ; 76 FD CB 00 BE
 altd res 7, (ix+0)             ; 76 FD CB 00 BE
 altd res 7, (ix+126)           ; 76 FD CB 7E BE
 altd res 7, (ix-128)           ; 76 FD CB 80 BE
 altd res 7, (iy)               ; 76 DD CB 00 BE
 altd res 7, (iy+0)             ; 76 DD CB 00 BE
 altd res 7, (iy+126)           ; 76 DD CB 7E BE
 altd res 7, (iy-128)           ; 76 DD CB 80 BE
 altd res 7, a                  ; 76 CB BF
 altd res 7, b                  ; 76 CB B8
 altd res 7, c                  ; 76 CB B9
 altd res 7, d                  ; 76 CB BA
 altd res 7, e                  ; 76 CB BB
 altd res 7, h                  ; 76 CB BC
 altd res 7, l                  ; 76 CB BD
 altd rl (hl)                   ; 76 CB 16
 altd rl (ix)                   ; 76 FD CB 00 16
 altd rl (ix+0)                 ; 76 FD CB 00 16
 altd rl (ix+126)               ; 76 FD CB 7E 16
 altd rl (ix-128)               ; 76 FD CB 80 16
 altd rl (iy)                   ; 76 DD CB 00 16
 altd rl (iy+0)                 ; 76 DD CB 00 16
 altd rl (iy+126)               ; 76 DD CB 7E 16
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
 altd rlc (ix+0)                ; 76 FD CB 00 06
 altd rlc (ix+126)              ; 76 FD CB 7E 06
 altd rlc (ix-128)              ; 76 FD CB 80 06
 altd rlc (iy)                  ; 76 DD CB 00 06
 altd rlc (iy+0)                ; 76 DD CB 00 06
 altd rlc (iy+126)              ; 76 DD CB 7E 06
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
 altd rr (ix+0)                 ; 76 FD CB 00 1E
 altd rr (ix+126)               ; 76 FD CB 7E 1E
 altd rr (ix-128)               ; 76 FD CB 80 1E
 altd rr (iy)                   ; 76 DD CB 00 1E
 altd rr (iy+0)                 ; 76 DD CB 00 1E
 altd rr (iy+126)               ; 76 DD CB 7E 1E
 altd rr (iy-128)               ; 76 DD CB 80 1E
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
 altd rrc (ix)                  ; 76 FD CB 00 0E
 altd rrc (ix+0)                ; 76 FD CB 00 0E
 altd rrc (ix+126)              ; 76 FD CB 7E 0E
 altd rrc (ix-128)              ; 76 FD CB 80 0E
 altd rrc (iy)                  ; 76 DD CB 00 0E
 altd rrc (iy+0)                ; 76 DD CB 00 0E
 altd rrc (iy+126)              ; 76 DD CB 7E 0E
 altd rrc (iy-128)              ; 76 DD CB 80 0E
 altd rrc a                     ; 76 CB 0F
 altd rrc b                     ; 76 CB 08
 altd rrc c                     ; 76 CB 09
 altd rrc d                     ; 76 CB 0A
 altd rrc e                     ; 76 CB 0B
 altd rrc h                     ; 76 CB 0C
 altd rrc l                     ; 76 CB 0D
 altd rrca                      ; 76 0F
 altd sbc a, (hl)               ; 76 9E
 altd sbc a, (ix)               ; 76 FD 9E 00
 altd sbc a, (ix+0)             ; 76 FD 9E 00
 altd sbc a, (ix+126)           ; 76 FD 9E 7E
 altd sbc a, (ix-128)           ; 76 FD 9E 80
 altd sbc a, (iy)               ; 76 DD 9E 00
 altd sbc a, (iy+0)             ; 76 DD 9E 00
 altd sbc a, (iy+126)           ; 76 DD 9E 7E
 altd sbc a, (iy-128)           ; 76 DD 9E 80
 altd sbc a, 0                  ; 76 DE 00
 altd sbc a, 127                ; 76 DE 7F
 altd sbc a, 255                ; 76 DE FF
 altd sbc a, a                  ; 76 9F
 altd sbc a, b                  ; 76 98
 altd sbc a, c                  ; 76 99
 altd sbc a, d                  ; 76 9A
 altd sbc a, e                  ; 76 9B
 altd sbc a, h                  ; 76 9C
 altd sbc a, l                  ; 76 9D
 altd sbc hl, bc                ; 76 ED 42
 altd sbc hl, de                ; 76 ED 52
 altd sbc hl, hl                ; 76 ED 62
 altd sbc hl, sp                ; 76 ED 72
 altd scf                       ; 76 37
 altd set 0, (hl)               ; 76 CB C6
 altd set 0, (ix)               ; 76 FD CB 00 C6
 altd set 0, (ix+0)             ; 76 FD CB 00 C6
 altd set 0, (ix+126)           ; 76 FD CB 7E C6
 altd set 0, (ix-128)           ; 76 FD CB 80 C6
 altd set 0, (iy)               ; 76 DD CB 00 C6
 altd set 0, (iy+0)             ; 76 DD CB 00 C6
 altd set 0, (iy+126)           ; 76 DD CB 7E C6
 altd set 0, (iy-128)           ; 76 DD CB 80 C6
 altd set 0, a                  ; 76 CB C7
 altd set 0, b                  ; 76 CB C0
 altd set 0, c                  ; 76 CB C1
 altd set 0, d                  ; 76 CB C2
 altd set 0, e                  ; 76 CB C3
 altd set 0, h                  ; 76 CB C4
 altd set 0, l                  ; 76 CB C5
 altd set 1, (hl)               ; 76 CB CE
 altd set 1, (ix)               ; 76 FD CB 00 CE
 altd set 1, (ix+0)             ; 76 FD CB 00 CE
 altd set 1, (ix+126)           ; 76 FD CB 7E CE
 altd set 1, (ix-128)           ; 76 FD CB 80 CE
 altd set 1, (iy)               ; 76 DD CB 00 CE
 altd set 1, (iy+0)             ; 76 DD CB 00 CE
 altd set 1, (iy+126)           ; 76 DD CB 7E CE
 altd set 1, (iy-128)           ; 76 DD CB 80 CE
 altd set 1, a                  ; 76 CB CF
 altd set 1, b                  ; 76 CB C8
 altd set 1, c                  ; 76 CB C9
 altd set 1, d                  ; 76 CB CA
 altd set 1, e                  ; 76 CB CB
 altd set 1, h                  ; 76 CB CC
 altd set 1, l                  ; 76 CB CD
 altd set 2, (hl)               ; 76 CB D6
 altd set 2, (ix)               ; 76 FD CB 00 D6
 altd set 2, (ix+0)             ; 76 FD CB 00 D6
 altd set 2, (ix+126)           ; 76 FD CB 7E D6
 altd set 2, (ix-128)           ; 76 FD CB 80 D6
 altd set 2, (iy)               ; 76 DD CB 00 D6
 altd set 2, (iy+0)             ; 76 DD CB 00 D6
 altd set 2, (iy+126)           ; 76 DD CB 7E D6
 altd set 2, (iy-128)           ; 76 DD CB 80 D6
 altd set 2, a                  ; 76 CB D7
 altd set 2, b                  ; 76 CB D0
 altd set 2, c                  ; 76 CB D1
 altd set 2, d                  ; 76 CB D2
 altd set 2, e                  ; 76 CB D3
 altd set 2, h                  ; 76 CB D4
 altd set 2, l                  ; 76 CB D5
 altd set 3, (hl)               ; 76 CB DE
 altd set 3, (ix)               ; 76 FD CB 00 DE
 altd set 3, (ix+0)             ; 76 FD CB 00 DE
 altd set 3, (ix+126)           ; 76 FD CB 7E DE
 altd set 3, (ix-128)           ; 76 FD CB 80 DE
 altd set 3, (iy)               ; 76 DD CB 00 DE
 altd set 3, (iy+0)             ; 76 DD CB 00 DE
 altd set 3, (iy+126)           ; 76 DD CB 7E DE
 altd set 3, (iy-128)           ; 76 DD CB 80 DE
 altd set 3, a                  ; 76 CB DF
 altd set 3, b                  ; 76 CB D8
 altd set 3, c                  ; 76 CB D9
 altd set 3, d                  ; 76 CB DA
 altd set 3, e                  ; 76 CB DB
 altd set 3, h                  ; 76 CB DC
 altd set 3, l                  ; 76 CB DD
 altd set 4, (hl)               ; 76 CB E6
 altd set 4, (ix)               ; 76 FD CB 00 E6
 altd set 4, (ix+0)             ; 76 FD CB 00 E6
 altd set 4, (ix+126)           ; 76 FD CB 7E E6
 altd set 4, (ix-128)           ; 76 FD CB 80 E6
 altd set 4, (iy)               ; 76 DD CB 00 E6
 altd set 4, (iy+0)             ; 76 DD CB 00 E6
 altd set 4, (iy+126)           ; 76 DD CB 7E E6
 altd set 4, (iy-128)           ; 76 DD CB 80 E6
 altd set 4, a                  ; 76 CB E7
 altd set 4, b                  ; 76 CB E0
 altd set 4, c                  ; 76 CB E1
 altd set 4, d                  ; 76 CB E2
 altd set 4, e                  ; 76 CB E3
 altd set 4, h                  ; 76 CB E4
 altd set 4, l                  ; 76 CB E5
 altd set 5, (hl)               ; 76 CB EE
 altd set 5, (ix)               ; 76 FD CB 00 EE
 altd set 5, (ix+0)             ; 76 FD CB 00 EE
 altd set 5, (ix+126)           ; 76 FD CB 7E EE
 altd set 5, (ix-128)           ; 76 FD CB 80 EE
 altd set 5, (iy)               ; 76 DD CB 00 EE
 altd set 5, (iy+0)             ; 76 DD CB 00 EE
 altd set 5, (iy+126)           ; 76 DD CB 7E EE
 altd set 5, (iy-128)           ; 76 DD CB 80 EE
 altd set 5, a                  ; 76 CB EF
 altd set 5, b                  ; 76 CB E8
 altd set 5, c                  ; 76 CB E9
 altd set 5, d                  ; 76 CB EA
 altd set 5, e                  ; 76 CB EB
 altd set 5, h                  ; 76 CB EC
 altd set 5, l                  ; 76 CB ED
 altd set 6, (hl)               ; 76 CB F6
 altd set 6, (ix)               ; 76 FD CB 00 F6
 altd set 6, (ix+0)             ; 76 FD CB 00 F6
 altd set 6, (ix+126)           ; 76 FD CB 7E F6
 altd set 6, (ix-128)           ; 76 FD CB 80 F6
 altd set 6, (iy)               ; 76 DD CB 00 F6
 altd set 6, (iy+0)             ; 76 DD CB 00 F6
 altd set 6, (iy+126)           ; 76 DD CB 7E F6
 altd set 6, (iy-128)           ; 76 DD CB 80 F6
 altd set 6, a                  ; 76 CB F7
 altd set 6, b                  ; 76 CB F0
 altd set 6, c                  ; 76 CB F1
 altd set 6, d                  ; 76 CB F2
 altd set 6, e                  ; 76 CB F3
 altd set 6, h                  ; 76 CB F4
 altd set 6, l                  ; 76 CB F5
 altd set 7, (hl)               ; 76 CB FE
 altd set 7, (ix)               ; 76 FD CB 00 FE
 altd set 7, (ix+0)             ; 76 FD CB 00 FE
 altd set 7, (ix+126)           ; 76 FD CB 7E FE
 altd set 7, (ix-128)           ; 76 FD CB 80 FE
 altd set 7, (iy)               ; 76 DD CB 00 FE
 altd set 7, (iy+0)             ; 76 DD CB 00 FE
 altd set 7, (iy+126)           ; 76 DD CB 7E FE
 altd set 7, (iy-128)           ; 76 DD CB 80 FE
 altd set 7, a                  ; 76 CB FF
 altd set 7, b                  ; 76 CB F8
 altd set 7, c                  ; 76 CB F9
 altd set 7, d                  ; 76 CB FA
 altd set 7, e                  ; 76 CB FB
 altd set 7, h                  ; 76 CB FC
 altd set 7, l                  ; 76 CB FD
 altd sla (hl)                  ; 76 CB 26
 altd sla (ix)                  ; 76 FD CB 00 26
 altd sla (ix+0)                ; 76 FD CB 00 26
 altd sla (ix+126)              ; 76 FD CB 7E 26
 altd sla (ix-128)              ; 76 FD CB 80 26
 altd sla (iy)                  ; 76 DD CB 00 26
 altd sla (iy+0)                ; 76 DD CB 00 26
 altd sla (iy+126)              ; 76 DD CB 7E 26
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
 altd sra (ix+0)                ; 76 FD CB 00 2E
 altd sra (ix+126)              ; 76 FD CB 7E 2E
 altd sra (ix-128)              ; 76 FD CB 80 2E
 altd sra (iy)                  ; 76 DD CB 00 2E
 altd sra (iy+0)                ; 76 DD CB 00 2E
 altd sra (iy+126)              ; 76 DD CB 7E 2E
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
 altd srl (ix+0)                ; 76 FD CB 00 3E
 altd srl (ix+126)              ; 76 FD CB 7E 3E
 altd srl (ix-128)              ; 76 FD CB 80 3E
 altd srl (iy)                  ; 76 DD CB 00 3E
 altd srl (iy+0)                ; 76 DD CB 00 3E
 altd srl (iy+126)              ; 76 DD CB 7E 3E
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
 altd sub (ix+0)                ; 76 FD 96 00
 altd sub (ix+126)              ; 76 FD 96 7E
 altd sub (ix-128)              ; 76 FD 96 80
 altd sub (iy)                  ; 76 DD 96 00
 altd sub (iy+0)                ; 76 DD 96 00
 altd sub (iy+126)              ; 76 DD 96 7E
 altd sub (iy-128)              ; 76 DD 96 80
 altd sub 0                     ; 76 D6 00
 altd sub 127                   ; 76 D6 7F
 altd sub 255                   ; 76 D6 FF
 altd sub a                     ; 76 97
 altd sub b                     ; 76 90
 altd sub c                     ; 76 91
 altd sub d                     ; 76 92
 altd sub e                     ; 76 93
 altd sub h                     ; 76 94
 altd sub l                     ; 76 95
 altd xor (hl)                  ; 76 AE
 altd xor (ix)                  ; 76 FD AE 00
 altd xor (ix+0)                ; 76 FD AE 00
 altd xor (ix+126)              ; 76 FD AE 7E
 altd xor (ix-128)              ; 76 FD AE 80
 altd xor (iy)                  ; 76 DD AE 00
 altd xor (iy+0)                ; 76 DD AE 00
 altd xor (iy+126)              ; 76 DD AE 7E
 altd xor (iy-128)              ; 76 DD AE 80
 altd xor 0                     ; 76 EE 00
 altd xor 127                   ; 76 EE 7F
 altd xor 255                   ; 76 EE FF
 altd xor a                     ; 76 AF
 altd xor b                     ; 76 A8
 altd xor c                     ; 76 A9
 altd xor d                     ; 76 AA
 altd xor e                     ; 76 AB
 altd xor h                     ; 76 AC
 altd xor l                     ; 76 AD
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
 and a'                         ; 76 A7
 and b                          ; A0
 and b'                         ; 76 A0
 and c                          ; A1
 and c'                         ; 76 A1
 and d                          ; A2
 and d'                         ; 76 A2
 and e                          ; A3
 and e'                         ; 76 A3
 and h                          ; A4
 and h'                         ; 76 A4
 and hl', de                    ; 76 DC
 and hl, de                     ; DC
 and ix, de                     ; FD DC
 and iy, de                     ; DD DC
 and l                          ; A5
 and l'                         ; 76 A5
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
 bit 0, a'                      ; 76 CB 47
 bit 0, b                       ; CB 40
 bit 0, b'                      ; 76 CB 40
 bit 0, c                       ; CB 41
 bit 0, c'                      ; 76 CB 41
 bit 0, d                       ; CB 42
 bit 0, d'                      ; 76 CB 42
 bit 0, e                       ; CB 43
 bit 0, e'                      ; 76 CB 43
 bit 0, h                       ; CB 44
 bit 0, h'                      ; 76 CB 44
 bit 0, l                       ; CB 45
 bit 0, l'                      ; 76 CB 45
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
 bit 1, a'                      ; 76 CB 4F
 bit 1, b                       ; CB 48
 bit 1, b'                      ; 76 CB 48
 bit 1, c                       ; CB 49
 bit 1, c'                      ; 76 CB 49
 bit 1, d                       ; CB 4A
 bit 1, d'                      ; 76 CB 4A
 bit 1, e                       ; CB 4B
 bit 1, e'                      ; 76 CB 4B
 bit 1, h                       ; CB 4C
 bit 1, h'                      ; 76 CB 4C
 bit 1, l                       ; CB 4D
 bit 1, l'                      ; 76 CB 4D
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
 bit 2, a'                      ; 76 CB 57
 bit 2, b                       ; CB 50
 bit 2, b'                      ; 76 CB 50
 bit 2, c                       ; CB 51
 bit 2, c'                      ; 76 CB 51
 bit 2, d                       ; CB 52
 bit 2, d'                      ; 76 CB 52
 bit 2, e                       ; CB 53
 bit 2, e'                      ; 76 CB 53
 bit 2, h                       ; CB 54
 bit 2, h'                      ; 76 CB 54
 bit 2, l                       ; CB 55
 bit 2, l'                      ; 76 CB 55
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
 bit 3, a'                      ; 76 CB 5F
 bit 3, b                       ; CB 58
 bit 3, b'                      ; 76 CB 58
 bit 3, c                       ; CB 59
 bit 3, c'                      ; 76 CB 59
 bit 3, d                       ; CB 5A
 bit 3, d'                      ; 76 CB 5A
 bit 3, e                       ; CB 5B
 bit 3, e'                      ; 76 CB 5B
 bit 3, h                       ; CB 5C
 bit 3, h'                      ; 76 CB 5C
 bit 3, l                       ; CB 5D
 bit 3, l'                      ; 76 CB 5D
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
 bit 4, a'                      ; 76 CB 67
 bit 4, b                       ; CB 60
 bit 4, b'                      ; 76 CB 60
 bit 4, c                       ; CB 61
 bit 4, c'                      ; 76 CB 61
 bit 4, d                       ; CB 62
 bit 4, d'                      ; 76 CB 62
 bit 4, e                       ; CB 63
 bit 4, e'                      ; 76 CB 63
 bit 4, h                       ; CB 64
 bit 4, h'                      ; 76 CB 64
 bit 4, l                       ; CB 65
 bit 4, l'                      ; 76 CB 65
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
 bit 5, a'                      ; 76 CB 6F
 bit 5, b                       ; CB 68
 bit 5, b'                      ; 76 CB 68
 bit 5, c                       ; CB 69
 bit 5, c'                      ; 76 CB 69
 bit 5, d                       ; CB 6A
 bit 5, d'                      ; 76 CB 6A
 bit 5, e                       ; CB 6B
 bit 5, e'                      ; 76 CB 6B
 bit 5, h                       ; CB 6C
 bit 5, h'                      ; 76 CB 6C
 bit 5, l                       ; CB 6D
 bit 5, l'                      ; 76 CB 6D
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
 bit 6, a'                      ; 76 CB 77
 bit 6, b                       ; CB 70
 bit 6, b'                      ; 76 CB 70
 bit 6, c                       ; CB 71
 bit 6, c'                      ; 76 CB 71
 bit 6, d                       ; CB 72
 bit 6, d'                      ; 76 CB 72
 bit 6, e                       ; CB 73
 bit 6, e'                      ; 76 CB 73
 bit 6, h                       ; CB 74
 bit 6, h'                      ; 76 CB 74
 bit 6, l                       ; CB 75
 bit 6, l'                      ; 76 CB 75
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
 bit 7, a'                      ; 76 CB 7F
 bit 7, b                       ; CB 78
 bit 7, b'                      ; 76 CB 78
 bit 7, c                       ; CB 79
 bit 7, c'                      ; 76 CB 79
 bit 7, d                       ; CB 7A
 bit 7, d'                      ; 76 CB 7A
 bit 7, e                       ; CB 7B
 bit 7, e'                      ; 76 CB 7B
 bit 7, h                       ; CB 7C
 bit 7, h'                      ; 76 CB 7C
 bit 7, l                       ; CB 7D
 bit 7, l'                      ; 76 CB 7D
 bool hl                        ; CC
 bool hl'                       ; 76 CC
 bool ix                        ; FD CC
 bool iy                        ; DD CC
 call 0x1234                    ; CD 34 12
 ccf                            ; 3F
 ccf'                           ; 76 3F
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
 cp a'                          ; 76 BF
 cp b                           ; B8
 cp b'                          ; 76 B8
 cp c                           ; B9
 cp c'                          ; 76 B9
 cp d                           ; BA
 cp d'                          ; 76 BA
 cp e                           ; BB
 cp e'                          ; 76 BB
 cp h                           ; BC
 cp h'                          ; 76 BC
 cp l                           ; BD
 cp l'                          ; 76 BD
 cpl                            ; 2F
 cpl a                          ; 2F
 cpl a'                         ; 76 2F
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
 djnz b', ASMPC                 ; 76 10 FD
 djnz b, ASMPC                  ; 10 FE
 ex (sp), hl                    ; ED 54
 ex (sp), hl'                   ; 76 ED 54
 ex (sp), ix                    ; FD E3
 ex (sp), iy                    ; DD E3
 ex af, af'                     ; 08
 ex de', hl                     ; E3
 ex de', hl'                    ; 76 E3
 ex de, hl                      ; EB
 ex de, hl'                     ; 76 EB
 exx                            ; D9
 idet                           ; 5B
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
 ioe adc a', (hl)               ; DB 76 8E
 ioe adc a', (ix)               ; DB 76 FD 8E 00
 ioe adc a', (ix+0)             ; DB 76 FD 8E 00
 ioe adc a', (ix+126)           ; DB 76 FD 8E 7E
 ioe adc a', (ix-128)           ; DB 76 FD 8E 80
 ioe adc a', (iy)               ; DB 76 DD 8E 00
 ioe adc a', (iy+0)             ; DB 76 DD 8E 00
 ioe adc a', (iy+126)           ; DB 76 DD 8E 7E
 ioe adc a', (iy-128)           ; DB 76 DD 8E 80
 ioe adc a, (hl)                ; DB 8E
 ioe adc a, (ix)                ; DB FD 8E 00
 ioe adc a, (ix+0)              ; DB FD 8E 00
 ioe adc a, (ix+126)            ; DB FD 8E 7E
 ioe adc a, (ix-128)            ; DB FD 8E 80
 ioe adc a, (iy)                ; DB DD 8E 00
 ioe adc a, (iy+0)              ; DB DD 8E 00
 ioe adc a, (iy+126)            ; DB DD 8E 7E
 ioe adc a, (iy-128)            ; DB DD 8E 80
 ioe add a', (hl)               ; DB 76 86
 ioe add a', (ix)               ; DB 76 FD 86 00
 ioe add a', (ix+0)             ; DB 76 FD 86 00
 ioe add a', (ix+126)           ; DB 76 FD 86 7E
 ioe add a', (ix-128)           ; DB 76 FD 86 80
 ioe add a', (iy)               ; DB 76 DD 86 00
 ioe add a', (iy+0)             ; DB 76 DD 86 00
 ioe add a', (iy+126)           ; DB 76 DD 86 7E
 ioe add a', (iy-128)           ; DB 76 DD 86 80
 ioe add a, (hl)                ; DB 86
 ioe add a, (ix)                ; DB FD 86 00
 ioe add a, (ix+0)              ; DB FD 86 00
 ioe add a, (ix+126)            ; DB FD 86 7E
 ioe add a, (ix-128)            ; DB FD 86 80
 ioe add a, (iy)                ; DB DD 86 00
 ioe add a, (iy+0)              ; DB DD 86 00
 ioe add a, (iy+126)            ; DB DD 86 7E
 ioe add a, (iy-128)            ; DB DD 86 80
 ioe altd adc a, (hl)           ; DB 76 8E
 ioe altd adc a, (ix)           ; DB 76 FD 8E 00
 ioe altd adc a, (ix+0)         ; DB 76 FD 8E 00
 ioe altd adc a, (ix+126)       ; DB 76 FD 8E 7E
 ioe altd adc a, (ix-128)       ; DB 76 FD 8E 80
 ioe altd adc a, (iy)           ; DB 76 DD 8E 00
 ioe altd adc a, (iy+0)         ; DB 76 DD 8E 00
 ioe altd adc a, (iy+126)       ; DB 76 DD 8E 7E
 ioe altd adc a, (iy-128)       ; DB 76 DD 8E 80
 ioe altd add a, (hl)           ; DB 76 86
 ioe altd add a, (ix)           ; DB 76 FD 86 00
 ioe altd add a, (ix+0)         ; DB 76 FD 86 00
 ioe altd add a, (ix+126)       ; DB 76 FD 86 7E
 ioe altd add a, (ix-128)       ; DB 76 FD 86 80
 ioe altd add a, (iy)           ; DB 76 DD 86 00
 ioe altd add a, (iy+0)         ; DB 76 DD 86 00
 ioe altd add a, (iy+126)       ; DB 76 DD 86 7E
 ioe altd add a, (iy-128)       ; DB 76 DD 86 80
 ioe altd and (hl)              ; DB 76 A6
 ioe altd and (ix)              ; DB 76 FD A6 00
 ioe altd and (ix+0)            ; DB 76 FD A6 00
 ioe altd and (ix+126)          ; DB 76 FD A6 7E
 ioe altd and (ix-128)          ; DB 76 FD A6 80
 ioe altd and (iy)              ; DB 76 DD A6 00
 ioe altd and (iy+0)            ; DB 76 DD A6 00
 ioe altd and (iy+126)          ; DB 76 DD A6 7E
 ioe altd and (iy-128)          ; DB 76 DD A6 80
 ioe altd bit 0, (hl)           ; DB 76 CB 46
 ioe altd bit 0, (ix)           ; DB 76 FD CB 00 46
 ioe altd bit 0, (ix+0)         ; DB 76 FD CB 00 46
 ioe altd bit 0, (ix+126)       ; DB 76 FD CB 7E 46
 ioe altd bit 0, (ix-128)       ; DB 76 FD CB 80 46
 ioe altd bit 0, (iy)           ; DB 76 DD CB 00 46
 ioe altd bit 0, (iy+0)         ; DB 76 DD CB 00 46
 ioe altd bit 0, (iy+126)       ; DB 76 DD CB 7E 46
 ioe altd bit 0, (iy-128)       ; DB 76 DD CB 80 46
 ioe altd bit 1, (hl)           ; DB 76 CB 4E
 ioe altd bit 1, (ix)           ; DB 76 FD CB 00 4E
 ioe altd bit 1, (ix+0)         ; DB 76 FD CB 00 4E
 ioe altd bit 1, (ix+126)       ; DB 76 FD CB 7E 4E
 ioe altd bit 1, (ix-128)       ; DB 76 FD CB 80 4E
 ioe altd bit 1, (iy)           ; DB 76 DD CB 00 4E
 ioe altd bit 1, (iy+0)         ; DB 76 DD CB 00 4E
 ioe altd bit 1, (iy+126)       ; DB 76 DD CB 7E 4E
 ioe altd bit 1, (iy-128)       ; DB 76 DD CB 80 4E
 ioe altd bit 2, (hl)           ; DB 76 CB 56
 ioe altd bit 2, (ix)           ; DB 76 FD CB 00 56
 ioe altd bit 2, (ix+0)         ; DB 76 FD CB 00 56
 ioe altd bit 2, (ix+126)       ; DB 76 FD CB 7E 56
 ioe altd bit 2, (ix-128)       ; DB 76 FD CB 80 56
 ioe altd bit 2, (iy)           ; DB 76 DD CB 00 56
 ioe altd bit 2, (iy+0)         ; DB 76 DD CB 00 56
 ioe altd bit 2, (iy+126)       ; DB 76 DD CB 7E 56
 ioe altd bit 2, (iy-128)       ; DB 76 DD CB 80 56
 ioe altd bit 3, (hl)           ; DB 76 CB 5E
 ioe altd bit 3, (ix)           ; DB 76 FD CB 00 5E
 ioe altd bit 3, (ix+0)         ; DB 76 FD CB 00 5E
 ioe altd bit 3, (ix+126)       ; DB 76 FD CB 7E 5E
 ioe altd bit 3, (ix-128)       ; DB 76 FD CB 80 5E
 ioe altd bit 3, (iy)           ; DB 76 DD CB 00 5E
 ioe altd bit 3, (iy+0)         ; DB 76 DD CB 00 5E
 ioe altd bit 3, (iy+126)       ; DB 76 DD CB 7E 5E
 ioe altd bit 3, (iy-128)       ; DB 76 DD CB 80 5E
 ioe altd bit 4, (hl)           ; DB 76 CB 66
 ioe altd bit 4, (ix)           ; DB 76 FD CB 00 66
 ioe altd bit 4, (ix+0)         ; DB 76 FD CB 00 66
 ioe altd bit 4, (ix+126)       ; DB 76 FD CB 7E 66
 ioe altd bit 4, (ix-128)       ; DB 76 FD CB 80 66
 ioe altd bit 4, (iy)           ; DB 76 DD CB 00 66
 ioe altd bit 4, (iy+0)         ; DB 76 DD CB 00 66
 ioe altd bit 4, (iy+126)       ; DB 76 DD CB 7E 66
 ioe altd bit 4, (iy-128)       ; DB 76 DD CB 80 66
 ioe altd bit 5, (hl)           ; DB 76 CB 6E
 ioe altd bit 5, (ix)           ; DB 76 FD CB 00 6E
 ioe altd bit 5, (ix+0)         ; DB 76 FD CB 00 6E
 ioe altd bit 5, (ix+126)       ; DB 76 FD CB 7E 6E
 ioe altd bit 5, (ix-128)       ; DB 76 FD CB 80 6E
 ioe altd bit 5, (iy)           ; DB 76 DD CB 00 6E
 ioe altd bit 5, (iy+0)         ; DB 76 DD CB 00 6E
 ioe altd bit 5, (iy+126)       ; DB 76 DD CB 7E 6E
 ioe altd bit 5, (iy-128)       ; DB 76 DD CB 80 6E
 ioe altd bit 6, (hl)           ; DB 76 CB 76
 ioe altd bit 6, (ix)           ; DB 76 FD CB 00 76
 ioe altd bit 6, (ix+0)         ; DB 76 FD CB 00 76
 ioe altd bit 6, (ix+126)       ; DB 76 FD CB 7E 76
 ioe altd bit 6, (ix-128)       ; DB 76 FD CB 80 76
 ioe altd bit 6, (iy)           ; DB 76 DD CB 00 76
 ioe altd bit 6, (iy+0)         ; DB 76 DD CB 00 76
 ioe altd bit 6, (iy+126)       ; DB 76 DD CB 7E 76
 ioe altd bit 6, (iy-128)       ; DB 76 DD CB 80 76
 ioe altd bit 7, (hl)           ; DB 76 CB 7E
 ioe altd bit 7, (ix)           ; DB 76 FD CB 00 7E
 ioe altd bit 7, (ix+0)         ; DB 76 FD CB 00 7E
 ioe altd bit 7, (ix+126)       ; DB 76 FD CB 7E 7E
 ioe altd bit 7, (ix-128)       ; DB 76 FD CB 80 7E
 ioe altd bit 7, (iy)           ; DB 76 DD CB 00 7E
 ioe altd bit 7, (iy+0)         ; DB 76 DD CB 00 7E
 ioe altd bit 7, (iy+126)       ; DB 76 DD CB 7E 7E
 ioe altd bit 7, (iy-128)       ; DB 76 DD CB 80 7E
 ioe altd cp (hl)               ; DB 76 BE
 ioe altd cp (ix)               ; DB 76 FD BE 00
 ioe altd cp (ix+0)             ; DB 76 FD BE 00
 ioe altd cp (ix+126)           ; DB 76 FD BE 7E
 ioe altd cp (ix-128)           ; DB 76 FD BE 80
 ioe altd cp (iy)               ; DB 76 DD BE 00
 ioe altd cp (iy+0)             ; DB 76 DD BE 00
 ioe altd cp (iy+126)           ; DB 76 DD BE 7E
 ioe altd cp (iy-128)           ; DB 76 DD BE 80
 ioe altd dec (hl)              ; DB 76 35
 ioe altd dec (ix)              ; DB 76 FD 35 00
 ioe altd dec (ix+0)            ; DB 76 FD 35 00
 ioe altd dec (ix+126)          ; DB 76 FD 35 7E
 ioe altd dec (ix-128)          ; DB 76 FD 35 80
 ioe altd dec (iy)              ; DB 76 DD 35 00
 ioe altd dec (iy+0)            ; DB 76 DD 35 00
 ioe altd dec (iy+126)          ; DB 76 DD 35 7E
 ioe altd dec (iy-128)          ; DB 76 DD 35 80
 ioe altd inc (hl)              ; DB 76 34
 ioe altd inc (ix)              ; DB 76 FD 34 00
 ioe altd inc (ix+0)            ; DB 76 FD 34 00
 ioe altd inc (ix+126)          ; DB 76 FD 34 7E
 ioe altd inc (ix-128)          ; DB 76 FD 34 80
 ioe altd inc (iy)              ; DB 76 DD 34 00
 ioe altd inc (iy+0)            ; DB 76 DD 34 00
 ioe altd inc (iy+126)          ; DB 76 DD 34 7E
 ioe altd inc (iy-128)          ; DB 76 DD 34 80
 ioe altd ld a, (0x1234)        ; DB 76 3A 34 12
 ioe altd ld a, (bc)            ; DB 76 0A
 ioe altd ld a, (de)            ; DB 76 1A
 ioe altd ld a, (hl)            ; DB 76 7E
 ioe altd ld a, (ix)            ; DB 76 FD 7E 00
 ioe altd ld a, (ix+0)          ; DB 76 FD 7E 00
 ioe altd ld a, (ix+126)        ; DB 76 FD 7E 7E
 ioe altd ld a, (ix-128)        ; DB 76 FD 7E 80
 ioe altd ld a, (iy)            ; DB 76 DD 7E 00
 ioe altd ld a, (iy+0)          ; DB 76 DD 7E 00
 ioe altd ld a, (iy+126)        ; DB 76 DD 7E 7E
 ioe altd ld a, (iy-128)        ; DB 76 DD 7E 80
 ioe altd ld b, (hl)            ; DB 76 46
 ioe altd ld b, (ix)            ; DB 76 FD 46 00
 ioe altd ld b, (ix+0)          ; DB 76 FD 46 00
 ioe altd ld b, (ix+126)        ; DB 76 FD 46 7E
 ioe altd ld b, (ix-128)        ; DB 76 FD 46 80
 ioe altd ld b, (iy)            ; DB 76 DD 46 00
 ioe altd ld b, (iy+0)          ; DB 76 DD 46 00
 ioe altd ld b, (iy+126)        ; DB 76 DD 46 7E
 ioe altd ld b, (iy-128)        ; DB 76 DD 46 80
 ioe altd ld bc, (0x1234)       ; DB 76 ED 4B 34 12
 ioe altd ld c, (hl)            ; DB 76 4E
 ioe altd ld c, (ix)            ; DB 76 FD 4E 00
 ioe altd ld c, (ix+0)          ; DB 76 FD 4E 00
 ioe altd ld c, (ix+126)        ; DB 76 FD 4E 7E
 ioe altd ld c, (ix-128)        ; DB 76 FD 4E 80
 ioe altd ld c, (iy)            ; DB 76 DD 4E 00
 ioe altd ld c, (iy+0)          ; DB 76 DD 4E 00
 ioe altd ld c, (iy+126)        ; DB 76 DD 4E 7E
 ioe altd ld c, (iy-128)        ; DB 76 DD 4E 80
 ioe altd ld d, (hl)            ; DB 76 56
 ioe altd ld d, (ix)            ; DB 76 FD 56 00
 ioe altd ld d, (ix+0)          ; DB 76 FD 56 00
 ioe altd ld d, (ix+126)        ; DB 76 FD 56 7E
 ioe altd ld d, (ix-128)        ; DB 76 FD 56 80
 ioe altd ld d, (iy)            ; DB 76 DD 56 00
 ioe altd ld d, (iy+0)          ; DB 76 DD 56 00
 ioe altd ld d, (iy+126)        ; DB 76 DD 56 7E
 ioe altd ld d, (iy-128)        ; DB 76 DD 56 80
 ioe altd ld de, (0x1234)       ; DB 76 ED 5B 34 12
 ioe altd ld e, (hl)            ; DB 76 5E
 ioe altd ld e, (ix)            ; DB 76 FD 5E 00
 ioe altd ld e, (ix+0)          ; DB 76 FD 5E 00
 ioe altd ld e, (ix+126)        ; DB 76 FD 5E 7E
 ioe altd ld e, (ix-128)        ; DB 76 FD 5E 80
 ioe altd ld e, (iy)            ; DB 76 DD 5E 00
 ioe altd ld e, (iy+0)          ; DB 76 DD 5E 00
 ioe altd ld e, (iy+126)        ; DB 76 DD 5E 7E
 ioe altd ld e, (iy-128)        ; DB 76 DD 5E 80
 ioe altd ld h, (hl)            ; DB 76 66
 ioe altd ld h, (ix)            ; DB 76 FD 66 00
 ioe altd ld h, (ix+0)          ; DB 76 FD 66 00
 ioe altd ld h, (ix+126)        ; DB 76 FD 66 7E
 ioe altd ld h, (ix-128)        ; DB 76 FD 66 80
 ioe altd ld h, (iy)            ; DB 76 DD 66 00
 ioe altd ld h, (iy+0)          ; DB 76 DD 66 00
 ioe altd ld h, (iy+126)        ; DB 76 DD 66 7E
 ioe altd ld h, (iy-128)        ; DB 76 DD 66 80
 ioe altd ld hl, (0x1234)       ; DB 76 2A 34 12
 ioe altd ld hl, (hl)           ; DB 76 DD E4 00
 ioe altd ld hl, (hl+0)         ; DB 76 DD E4 00
 ioe altd ld hl, (hl+126)       ; DB 76 DD E4 7E
 ioe altd ld hl, (hl-128)       ; DB 76 DD E4 80
 ioe altd ld hl, (ix)           ; DB 76 FD E4 00
 ioe altd ld hl, (ix+0)         ; DB 76 FD E4 00
 ioe altd ld hl, (ix+126)       ; DB 76 FD E4 7E
 ioe altd ld hl, (ix-128)       ; DB 76 FD E4 80
 ioe altd ld hl, (iy)           ; DB 76 E4 00
 ioe altd ld hl, (iy+0)         ; DB 76 E4 00
 ioe altd ld hl, (iy+126)       ; DB 76 E4 7E
 ioe altd ld hl, (iy-128)       ; DB 76 E4 80
 ioe altd ld l, (hl)            ; DB 76 6E
 ioe altd ld l, (ix)            ; DB 76 FD 6E 00
 ioe altd ld l, (ix+0)          ; DB 76 FD 6E 00
 ioe altd ld l, (ix+126)        ; DB 76 FD 6E 7E
 ioe altd ld l, (ix-128)        ; DB 76 FD 6E 80
 ioe altd ld l, (iy)            ; DB 76 DD 6E 00
 ioe altd ld l, (iy+0)          ; DB 76 DD 6E 00
 ioe altd ld l, (iy+126)        ; DB 76 DD 6E 7E
 ioe altd ld l, (iy-128)        ; DB 76 DD 6E 80
 ioe altd or (hl)               ; DB 76 B6
 ioe altd or (ix)               ; DB 76 FD B6 00
 ioe altd or (ix+0)             ; DB 76 FD B6 00
 ioe altd or (ix+126)           ; DB 76 FD B6 7E
 ioe altd or (ix-128)           ; DB 76 FD B6 80
 ioe altd or (iy)               ; DB 76 DD B6 00
 ioe altd or (iy+0)             ; DB 76 DD B6 00
 ioe altd or (iy+126)           ; DB 76 DD B6 7E
 ioe altd or (iy-128)           ; DB 76 DD B6 80
 ioe altd res 0, (hl)           ; DB 76 CB 86
 ioe altd res 0, (ix)           ; DB 76 FD CB 00 86
 ioe altd res 0, (ix+0)         ; DB 76 FD CB 00 86
 ioe altd res 0, (ix+126)       ; DB 76 FD CB 7E 86
 ioe altd res 0, (ix-128)       ; DB 76 FD CB 80 86
 ioe altd res 0, (iy)           ; DB 76 DD CB 00 86
 ioe altd res 0, (iy+0)         ; DB 76 DD CB 00 86
 ioe altd res 0, (iy+126)       ; DB 76 DD CB 7E 86
 ioe altd res 0, (iy-128)       ; DB 76 DD CB 80 86
 ioe altd res 1, (hl)           ; DB 76 CB 8E
 ioe altd res 1, (ix)           ; DB 76 FD CB 00 8E
 ioe altd res 1, (ix+0)         ; DB 76 FD CB 00 8E
 ioe altd res 1, (ix+126)       ; DB 76 FD CB 7E 8E
 ioe altd res 1, (ix-128)       ; DB 76 FD CB 80 8E
 ioe altd res 1, (iy)           ; DB 76 DD CB 00 8E
 ioe altd res 1, (iy+0)         ; DB 76 DD CB 00 8E
 ioe altd res 1, (iy+126)       ; DB 76 DD CB 7E 8E
 ioe altd res 1, (iy-128)       ; DB 76 DD CB 80 8E
 ioe altd res 2, (hl)           ; DB 76 CB 96
 ioe altd res 2, (ix)           ; DB 76 FD CB 00 96
 ioe altd res 2, (ix+0)         ; DB 76 FD CB 00 96
 ioe altd res 2, (ix+126)       ; DB 76 FD CB 7E 96
 ioe altd res 2, (ix-128)       ; DB 76 FD CB 80 96
 ioe altd res 2, (iy)           ; DB 76 DD CB 00 96
 ioe altd res 2, (iy+0)         ; DB 76 DD CB 00 96
 ioe altd res 2, (iy+126)       ; DB 76 DD CB 7E 96
 ioe altd res 2, (iy-128)       ; DB 76 DD CB 80 96
 ioe altd res 3, (hl)           ; DB 76 CB 9E
 ioe altd res 3, (ix)           ; DB 76 FD CB 00 9E
 ioe altd res 3, (ix+0)         ; DB 76 FD CB 00 9E
 ioe altd res 3, (ix+126)       ; DB 76 FD CB 7E 9E
 ioe altd res 3, (ix-128)       ; DB 76 FD CB 80 9E
 ioe altd res 3, (iy)           ; DB 76 DD CB 00 9E
 ioe altd res 3, (iy+0)         ; DB 76 DD CB 00 9E
 ioe altd res 3, (iy+126)       ; DB 76 DD CB 7E 9E
 ioe altd res 3, (iy-128)       ; DB 76 DD CB 80 9E
 ioe altd res 4, (hl)           ; DB 76 CB A6
 ioe altd res 4, (ix)           ; DB 76 FD CB 00 A6
 ioe altd res 4, (ix+0)         ; DB 76 FD CB 00 A6
 ioe altd res 4, (ix+126)       ; DB 76 FD CB 7E A6
 ioe altd res 4, (ix-128)       ; DB 76 FD CB 80 A6
 ioe altd res 4, (iy)           ; DB 76 DD CB 00 A6
 ioe altd res 4, (iy+0)         ; DB 76 DD CB 00 A6
 ioe altd res 4, (iy+126)       ; DB 76 DD CB 7E A6
 ioe altd res 4, (iy-128)       ; DB 76 DD CB 80 A6
 ioe altd res 5, (hl)           ; DB 76 CB AE
 ioe altd res 5, (ix)           ; DB 76 FD CB 00 AE
 ioe altd res 5, (ix+0)         ; DB 76 FD CB 00 AE
 ioe altd res 5, (ix+126)       ; DB 76 FD CB 7E AE
 ioe altd res 5, (ix-128)       ; DB 76 FD CB 80 AE
 ioe altd res 5, (iy)           ; DB 76 DD CB 00 AE
 ioe altd res 5, (iy+0)         ; DB 76 DD CB 00 AE
 ioe altd res 5, (iy+126)       ; DB 76 DD CB 7E AE
 ioe altd res 5, (iy-128)       ; DB 76 DD CB 80 AE
 ioe altd res 6, (hl)           ; DB 76 CB B6
 ioe altd res 6, (ix)           ; DB 76 FD CB 00 B6
 ioe altd res 6, (ix+0)         ; DB 76 FD CB 00 B6
 ioe altd res 6, (ix+126)       ; DB 76 FD CB 7E B6
 ioe altd res 6, (ix-128)       ; DB 76 FD CB 80 B6
 ioe altd res 6, (iy)           ; DB 76 DD CB 00 B6
 ioe altd res 6, (iy+0)         ; DB 76 DD CB 00 B6
 ioe altd res 6, (iy+126)       ; DB 76 DD CB 7E B6
 ioe altd res 6, (iy-128)       ; DB 76 DD CB 80 B6
 ioe altd res 7, (hl)           ; DB 76 CB BE
 ioe altd res 7, (ix)           ; DB 76 FD CB 00 BE
 ioe altd res 7, (ix+0)         ; DB 76 FD CB 00 BE
 ioe altd res 7, (ix+126)       ; DB 76 FD CB 7E BE
 ioe altd res 7, (ix-128)       ; DB 76 FD CB 80 BE
 ioe altd res 7, (iy)           ; DB 76 DD CB 00 BE
 ioe altd res 7, (iy+0)         ; DB 76 DD CB 00 BE
 ioe altd res 7, (iy+126)       ; DB 76 DD CB 7E BE
 ioe altd res 7, (iy-128)       ; DB 76 DD CB 80 BE
 ioe altd rl (hl)               ; DB 76 CB 16
 ioe altd rl (ix)               ; DB 76 FD CB 00 16
 ioe altd rl (ix+0)             ; DB 76 FD CB 00 16
 ioe altd rl (ix+126)           ; DB 76 FD CB 7E 16
 ioe altd rl (ix-128)           ; DB 76 FD CB 80 16
 ioe altd rl (iy)               ; DB 76 DD CB 00 16
 ioe altd rl (iy+0)             ; DB 76 DD CB 00 16
 ioe altd rl (iy+126)           ; DB 76 DD CB 7E 16
 ioe altd rl (iy-128)           ; DB 76 DD CB 80 16
 ioe altd rlc (hl)              ; DB 76 CB 06
 ioe altd rlc (ix)              ; DB 76 FD CB 00 06
 ioe altd rlc (ix+0)            ; DB 76 FD CB 00 06
 ioe altd rlc (ix+126)          ; DB 76 FD CB 7E 06
 ioe altd rlc (ix-128)          ; DB 76 FD CB 80 06
 ioe altd rlc (iy)              ; DB 76 DD CB 00 06
 ioe altd rlc (iy+0)            ; DB 76 DD CB 00 06
 ioe altd rlc (iy+126)          ; DB 76 DD CB 7E 06
 ioe altd rlc (iy-128)          ; DB 76 DD CB 80 06
 ioe altd rr (hl)               ; DB 76 CB 1E
 ioe altd rr (ix)               ; DB 76 FD CB 00 1E
 ioe altd rr (ix+0)             ; DB 76 FD CB 00 1E
 ioe altd rr (ix+126)           ; DB 76 FD CB 7E 1E
 ioe altd rr (ix-128)           ; DB 76 FD CB 80 1E
 ioe altd rr (iy)               ; DB 76 DD CB 00 1E
 ioe altd rr (iy+0)             ; DB 76 DD CB 00 1E
 ioe altd rr (iy+126)           ; DB 76 DD CB 7E 1E
 ioe altd rr (iy-128)           ; DB 76 DD CB 80 1E
 ioe altd rrc (hl)              ; DB 76 CB 0E
 ioe altd rrc (ix)              ; DB 76 FD CB 00 0E
 ioe altd rrc (ix+0)            ; DB 76 FD CB 00 0E
 ioe altd rrc (ix+126)          ; DB 76 FD CB 7E 0E
 ioe altd rrc (ix-128)          ; DB 76 FD CB 80 0E
 ioe altd rrc (iy)              ; DB 76 DD CB 00 0E
 ioe altd rrc (iy+0)            ; DB 76 DD CB 00 0E
 ioe altd rrc (iy+126)          ; DB 76 DD CB 7E 0E
 ioe altd rrc (iy-128)          ; DB 76 DD CB 80 0E
 ioe altd sbc a, (hl)           ; DB 76 9E
 ioe altd sbc a, (ix)           ; DB 76 FD 9E 00
 ioe altd sbc a, (ix+0)         ; DB 76 FD 9E 00
 ioe altd sbc a, (ix+126)       ; DB 76 FD 9E 7E
 ioe altd sbc a, (ix-128)       ; DB 76 FD 9E 80
 ioe altd sbc a, (iy)           ; DB 76 DD 9E 00
 ioe altd sbc a, (iy+0)         ; DB 76 DD 9E 00
 ioe altd sbc a, (iy+126)       ; DB 76 DD 9E 7E
 ioe altd sbc a, (iy-128)       ; DB 76 DD 9E 80
 ioe altd set 0, (hl)           ; DB 76 CB C6
 ioe altd set 0, (ix)           ; DB 76 FD CB 00 C6
 ioe altd set 0, (ix+0)         ; DB 76 FD CB 00 C6
 ioe altd set 0, (ix+126)       ; DB 76 FD CB 7E C6
 ioe altd set 0, (ix-128)       ; DB 76 FD CB 80 C6
 ioe altd set 0, (iy)           ; DB 76 DD CB 00 C6
 ioe altd set 0, (iy+0)         ; DB 76 DD CB 00 C6
 ioe altd set 0, (iy+126)       ; DB 76 DD CB 7E C6
 ioe altd set 0, (iy-128)       ; DB 76 DD CB 80 C6
 ioe altd set 1, (hl)           ; DB 76 CB CE
 ioe altd set 1, (ix)           ; DB 76 FD CB 00 CE
 ioe altd set 1, (ix+0)         ; DB 76 FD CB 00 CE
 ioe altd set 1, (ix+126)       ; DB 76 FD CB 7E CE
 ioe altd set 1, (ix-128)       ; DB 76 FD CB 80 CE
 ioe altd set 1, (iy)           ; DB 76 DD CB 00 CE
 ioe altd set 1, (iy+0)         ; DB 76 DD CB 00 CE
 ioe altd set 1, (iy+126)       ; DB 76 DD CB 7E CE
 ioe altd set 1, (iy-128)       ; DB 76 DD CB 80 CE
 ioe altd set 2, (hl)           ; DB 76 CB D6
 ioe altd set 2, (ix)           ; DB 76 FD CB 00 D6
 ioe altd set 2, (ix+0)         ; DB 76 FD CB 00 D6
 ioe altd set 2, (ix+126)       ; DB 76 FD CB 7E D6
 ioe altd set 2, (ix-128)       ; DB 76 FD CB 80 D6
 ioe altd set 2, (iy)           ; DB 76 DD CB 00 D6
 ioe altd set 2, (iy+0)         ; DB 76 DD CB 00 D6
 ioe altd set 2, (iy+126)       ; DB 76 DD CB 7E D6
 ioe altd set 2, (iy-128)       ; DB 76 DD CB 80 D6
 ioe altd set 3, (hl)           ; DB 76 CB DE
 ioe altd set 3, (ix)           ; DB 76 FD CB 00 DE
 ioe altd set 3, (ix+0)         ; DB 76 FD CB 00 DE
 ioe altd set 3, (ix+126)       ; DB 76 FD CB 7E DE
 ioe altd set 3, (ix-128)       ; DB 76 FD CB 80 DE
 ioe altd set 3, (iy)           ; DB 76 DD CB 00 DE
 ioe altd set 3, (iy+0)         ; DB 76 DD CB 00 DE
 ioe altd set 3, (iy+126)       ; DB 76 DD CB 7E DE
 ioe altd set 3, (iy-128)       ; DB 76 DD CB 80 DE
 ioe altd set 4, (hl)           ; DB 76 CB E6
 ioe altd set 4, (ix)           ; DB 76 FD CB 00 E6
 ioe altd set 4, (ix+0)         ; DB 76 FD CB 00 E6
 ioe altd set 4, (ix+126)       ; DB 76 FD CB 7E E6
 ioe altd set 4, (ix-128)       ; DB 76 FD CB 80 E6
 ioe altd set 4, (iy)           ; DB 76 DD CB 00 E6
 ioe altd set 4, (iy+0)         ; DB 76 DD CB 00 E6
 ioe altd set 4, (iy+126)       ; DB 76 DD CB 7E E6
 ioe altd set 4, (iy-128)       ; DB 76 DD CB 80 E6
 ioe altd set 5, (hl)           ; DB 76 CB EE
 ioe altd set 5, (ix)           ; DB 76 FD CB 00 EE
 ioe altd set 5, (ix+0)         ; DB 76 FD CB 00 EE
 ioe altd set 5, (ix+126)       ; DB 76 FD CB 7E EE
 ioe altd set 5, (ix-128)       ; DB 76 FD CB 80 EE
 ioe altd set 5, (iy)           ; DB 76 DD CB 00 EE
 ioe altd set 5, (iy+0)         ; DB 76 DD CB 00 EE
 ioe altd set 5, (iy+126)       ; DB 76 DD CB 7E EE
 ioe altd set 5, (iy-128)       ; DB 76 DD CB 80 EE
 ioe altd set 6, (hl)           ; DB 76 CB F6
 ioe altd set 6, (ix)           ; DB 76 FD CB 00 F6
 ioe altd set 6, (ix+0)         ; DB 76 FD CB 00 F6
 ioe altd set 6, (ix+126)       ; DB 76 FD CB 7E F6
 ioe altd set 6, (ix-128)       ; DB 76 FD CB 80 F6
 ioe altd set 6, (iy)           ; DB 76 DD CB 00 F6
 ioe altd set 6, (iy+0)         ; DB 76 DD CB 00 F6
 ioe altd set 6, (iy+126)       ; DB 76 DD CB 7E F6
 ioe altd set 6, (iy-128)       ; DB 76 DD CB 80 F6
 ioe altd set 7, (hl)           ; DB 76 CB FE
 ioe altd set 7, (ix)           ; DB 76 FD CB 00 FE
 ioe altd set 7, (ix+0)         ; DB 76 FD CB 00 FE
 ioe altd set 7, (ix+126)       ; DB 76 FD CB 7E FE
 ioe altd set 7, (ix-128)       ; DB 76 FD CB 80 FE
 ioe altd set 7, (iy)           ; DB 76 DD CB 00 FE
 ioe altd set 7, (iy+0)         ; DB 76 DD CB 00 FE
 ioe altd set 7, (iy+126)       ; DB 76 DD CB 7E FE
 ioe altd set 7, (iy-128)       ; DB 76 DD CB 80 FE
 ioe altd sla (hl)              ; DB 76 CB 26
 ioe altd sla (ix)              ; DB 76 FD CB 00 26
 ioe altd sla (ix+0)            ; DB 76 FD CB 00 26
 ioe altd sla (ix+126)          ; DB 76 FD CB 7E 26
 ioe altd sla (ix-128)          ; DB 76 FD CB 80 26
 ioe altd sla (iy)              ; DB 76 DD CB 00 26
 ioe altd sla (iy+0)            ; DB 76 DD CB 00 26
 ioe altd sla (iy+126)          ; DB 76 DD CB 7E 26
 ioe altd sla (iy-128)          ; DB 76 DD CB 80 26
 ioe altd sra (hl)              ; DB 76 CB 2E
 ioe altd sra (ix)              ; DB 76 FD CB 00 2E
 ioe altd sra (ix+0)            ; DB 76 FD CB 00 2E
 ioe altd sra (ix+126)          ; DB 76 FD CB 7E 2E
 ioe altd sra (ix-128)          ; DB 76 FD CB 80 2E
 ioe altd sra (iy)              ; DB 76 DD CB 00 2E
 ioe altd sra (iy+0)            ; DB 76 DD CB 00 2E
 ioe altd sra (iy+126)          ; DB 76 DD CB 7E 2E
 ioe altd sra (iy-128)          ; DB 76 DD CB 80 2E
 ioe altd srl (hl)              ; DB 76 CB 3E
 ioe altd srl (ix)              ; DB 76 FD CB 00 3E
 ioe altd srl (ix+0)            ; DB 76 FD CB 00 3E
 ioe altd srl (ix+126)          ; DB 76 FD CB 7E 3E
 ioe altd srl (ix-128)          ; DB 76 FD CB 80 3E
 ioe altd srl (iy)              ; DB 76 DD CB 00 3E
 ioe altd srl (iy+0)            ; DB 76 DD CB 00 3E
 ioe altd srl (iy+126)          ; DB 76 DD CB 7E 3E
 ioe altd srl (iy-128)          ; DB 76 DD CB 80 3E
 ioe altd sub (hl)              ; DB 76 96
 ioe altd sub (ix)              ; DB 76 FD 96 00
 ioe altd sub (ix+0)            ; DB 76 FD 96 00
 ioe altd sub (ix+126)          ; DB 76 FD 96 7E
 ioe altd sub (ix-128)          ; DB 76 FD 96 80
 ioe altd sub (iy)              ; DB 76 DD 96 00
 ioe altd sub (iy+0)            ; DB 76 DD 96 00
 ioe altd sub (iy+126)          ; DB 76 DD 96 7E
 ioe altd sub (iy-128)          ; DB 76 DD 96 80
 ioe altd xor (hl)              ; DB 76 AE
 ioe altd xor (ix)              ; DB 76 FD AE 00
 ioe altd xor (ix+0)            ; DB 76 FD AE 00
 ioe altd xor (ix+126)          ; DB 76 FD AE 7E
 ioe altd xor (ix-128)          ; DB 76 FD AE 80
 ioe altd xor (iy)              ; DB 76 DD AE 00
 ioe altd xor (iy+0)            ; DB 76 DD AE 00
 ioe altd xor (iy+126)          ; DB 76 DD AE 7E
 ioe altd xor (iy-128)          ; DB 76 DD AE 80
 ioe and (hl)                   ; DB A6
 ioe and (ix)                   ; DB FD A6 00
 ioe and (ix+0)                 ; DB FD A6 00
 ioe and (ix+126)               ; DB FD A6 7E
 ioe and (ix-128)               ; DB FD A6 80
 ioe and (iy)                   ; DB DD A6 00
 ioe and (iy+0)                 ; DB DD A6 00
 ioe and (iy+126)               ; DB DD A6 7E
 ioe and (iy-128)               ; DB DD A6 80
 ioe bit 0, (hl)                ; DB CB 46
 ioe bit 0, (ix)                ; DB FD CB 00 46
 ioe bit 0, (ix+0)              ; DB FD CB 00 46
 ioe bit 0, (ix+126)            ; DB FD CB 7E 46
 ioe bit 0, (ix-128)            ; DB FD CB 80 46
 ioe bit 0, (iy)                ; DB DD CB 00 46
 ioe bit 0, (iy+0)              ; DB DD CB 00 46
 ioe bit 0, (iy+126)            ; DB DD CB 7E 46
 ioe bit 0, (iy-128)            ; DB DD CB 80 46
 ioe bit 1, (hl)                ; DB CB 4E
 ioe bit 1, (ix)                ; DB FD CB 00 4E
 ioe bit 1, (ix+0)              ; DB FD CB 00 4E
 ioe bit 1, (ix+126)            ; DB FD CB 7E 4E
 ioe bit 1, (ix-128)            ; DB FD CB 80 4E
 ioe bit 1, (iy)                ; DB DD CB 00 4E
 ioe bit 1, (iy+0)              ; DB DD CB 00 4E
 ioe bit 1, (iy+126)            ; DB DD CB 7E 4E
 ioe bit 1, (iy-128)            ; DB DD CB 80 4E
 ioe bit 2, (hl)                ; DB CB 56
 ioe bit 2, (ix)                ; DB FD CB 00 56
 ioe bit 2, (ix+0)              ; DB FD CB 00 56
 ioe bit 2, (ix+126)            ; DB FD CB 7E 56
 ioe bit 2, (ix-128)            ; DB FD CB 80 56
 ioe bit 2, (iy)                ; DB DD CB 00 56
 ioe bit 2, (iy+0)              ; DB DD CB 00 56
 ioe bit 2, (iy+126)            ; DB DD CB 7E 56
 ioe bit 2, (iy-128)            ; DB DD CB 80 56
 ioe bit 3, (hl)                ; DB CB 5E
 ioe bit 3, (ix)                ; DB FD CB 00 5E
 ioe bit 3, (ix+0)              ; DB FD CB 00 5E
 ioe bit 3, (ix+126)            ; DB FD CB 7E 5E
 ioe bit 3, (ix-128)            ; DB FD CB 80 5E
 ioe bit 3, (iy)                ; DB DD CB 00 5E
 ioe bit 3, (iy+0)              ; DB DD CB 00 5E
 ioe bit 3, (iy+126)            ; DB DD CB 7E 5E
 ioe bit 3, (iy-128)            ; DB DD CB 80 5E
 ioe bit 4, (hl)                ; DB CB 66
 ioe bit 4, (ix)                ; DB FD CB 00 66
 ioe bit 4, (ix+0)              ; DB FD CB 00 66
 ioe bit 4, (ix+126)            ; DB FD CB 7E 66
 ioe bit 4, (ix-128)            ; DB FD CB 80 66
 ioe bit 4, (iy)                ; DB DD CB 00 66
 ioe bit 4, (iy+0)              ; DB DD CB 00 66
 ioe bit 4, (iy+126)            ; DB DD CB 7E 66
 ioe bit 4, (iy-128)            ; DB DD CB 80 66
 ioe bit 5, (hl)                ; DB CB 6E
 ioe bit 5, (ix)                ; DB FD CB 00 6E
 ioe bit 5, (ix+0)              ; DB FD CB 00 6E
 ioe bit 5, (ix+126)            ; DB FD CB 7E 6E
 ioe bit 5, (ix-128)            ; DB FD CB 80 6E
 ioe bit 5, (iy)                ; DB DD CB 00 6E
 ioe bit 5, (iy+0)              ; DB DD CB 00 6E
 ioe bit 5, (iy+126)            ; DB DD CB 7E 6E
 ioe bit 5, (iy-128)            ; DB DD CB 80 6E
 ioe bit 6, (hl)                ; DB CB 76
 ioe bit 6, (ix)                ; DB FD CB 00 76
 ioe bit 6, (ix+0)              ; DB FD CB 00 76
 ioe bit 6, (ix+126)            ; DB FD CB 7E 76
 ioe bit 6, (ix-128)            ; DB FD CB 80 76
 ioe bit 6, (iy)                ; DB DD CB 00 76
 ioe bit 6, (iy+0)              ; DB DD CB 00 76
 ioe bit 6, (iy+126)            ; DB DD CB 7E 76
 ioe bit 6, (iy-128)            ; DB DD CB 80 76
 ioe bit 7, (hl)                ; DB CB 7E
 ioe bit 7, (ix)                ; DB FD CB 00 7E
 ioe bit 7, (ix+0)              ; DB FD CB 00 7E
 ioe bit 7, (ix+126)            ; DB FD CB 7E 7E
 ioe bit 7, (ix-128)            ; DB FD CB 80 7E
 ioe bit 7, (iy)                ; DB DD CB 00 7E
 ioe bit 7, (iy+0)              ; DB DD CB 00 7E
 ioe bit 7, (iy+126)            ; DB DD CB 7E 7E
 ioe bit 7, (iy-128)            ; DB DD CB 80 7E
 ioe cp (hl)                    ; DB BE
 ioe cp (ix)                    ; DB FD BE 00
 ioe cp (ix+0)                  ; DB FD BE 00
 ioe cp (ix+126)                ; DB FD BE 7E
 ioe cp (ix-128)                ; DB FD BE 80
 ioe cp (iy)                    ; DB DD BE 00
 ioe cp (iy+0)                  ; DB DD BE 00
 ioe cp (iy+126)                ; DB DD BE 7E
 ioe cp (iy-128)                ; DB DD BE 80
 ioe dec (hl)                   ; DB 35
 ioe dec (ix)                   ; DB FD 35 00
 ioe dec (ix+0)                 ; DB FD 35 00
 ioe dec (ix+126)               ; DB FD 35 7E
 ioe dec (ix-128)               ; DB FD 35 80
 ioe dec (iy)                   ; DB DD 35 00
 ioe dec (iy+0)                 ; DB DD 35 00
 ioe dec (iy+126)               ; DB DD 35 7E
 ioe dec (iy-128)               ; DB DD 35 80
 ioe inc (hl)                   ; DB 34
 ioe inc (ix)                   ; DB FD 34 00
 ioe inc (ix+0)                 ; DB FD 34 00
 ioe inc (ix+126)               ; DB FD 34 7E
 ioe inc (ix-128)               ; DB FD 34 80
 ioe inc (iy)                   ; DB DD 34 00
 ioe inc (iy+0)                 ; DB DD 34 00
 ioe inc (iy+126)               ; DB DD 34 7E
 ioe inc (iy-128)               ; DB DD 34 80
 ioe ld (0x1234), a             ; DB 32 34 12
 ioe ld (0x1234), bc            ; DB ED 43 34 12
 ioe ld (0x1234), de            ; DB ED 53 34 12
 ioe ld (0x1234), hl            ; DB 22 34 12
 ioe ld (0x1234), ix            ; DB FD 22 34 12
 ioe ld (0x1234), iy            ; DB DD 22 34 12
 ioe ld (0x1234), sp            ; DB ED 73 34 12
 ioe ld (bc), a                 ; DB 02
 ioe ld (de), a                 ; DB 12
 ioe ld (hl), 0                 ; DB 36 00
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
 ioe ld (hl+0), hl              ; DB DD F4 00
 ioe ld (hl+126), hl            ; DB DD F4 7E
 ioe ld (hl-128), hl            ; DB DD F4 80
 ioe ld (ix), 0                 ; DB FD 36 00 00
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
 ioe ld (ix+0), 0               ; DB FD 36 00 00
 ioe ld (ix+0), 127             ; DB FD 36 00 7F
 ioe ld (ix+0), 255             ; DB FD 36 00 FF
 ioe ld (ix+0), a               ; DB FD 77 00
 ioe ld (ix+0), b               ; DB FD 70 00
 ioe ld (ix+0), c               ; DB FD 71 00
 ioe ld (ix+0), d               ; DB FD 72 00
 ioe ld (ix+0), e               ; DB FD 73 00
 ioe ld (ix+0), h               ; DB FD 74 00
 ioe ld (ix+0), hl              ; DB FD F4 00
 ioe ld (ix+0), l               ; DB FD 75 00
 ioe ld (ix+126), 0             ; DB FD 36 7E 00
 ioe ld (ix+126), 127           ; DB FD 36 7E 7F
 ioe ld (ix+126), 255           ; DB FD 36 7E FF
 ioe ld (ix+126), a             ; DB FD 77 7E
 ioe ld (ix+126), b             ; DB FD 70 7E
 ioe ld (ix+126), c             ; DB FD 71 7E
 ioe ld (ix+126), d             ; DB FD 72 7E
 ioe ld (ix+126), e             ; DB FD 73 7E
 ioe ld (ix+126), h             ; DB FD 74 7E
 ioe ld (ix+126), hl            ; DB FD F4 7E
 ioe ld (ix+126), l             ; DB FD 75 7E
 ioe ld (ix-128), 0             ; DB FD 36 80 00
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
 ioe ld (iy), 0                 ; DB DD 36 00 00
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
 ioe ld (iy+0), 0               ; DB DD 36 00 00
 ioe ld (iy+0), 127             ; DB DD 36 00 7F
 ioe ld (iy+0), 255             ; DB DD 36 00 FF
 ioe ld (iy+0), a               ; DB DD 77 00
 ioe ld (iy+0), b               ; DB DD 70 00
 ioe ld (iy+0), c               ; DB DD 71 00
 ioe ld (iy+0), d               ; DB DD 72 00
 ioe ld (iy+0), e               ; DB DD 73 00
 ioe ld (iy+0), h               ; DB DD 74 00
 ioe ld (iy+0), hl              ; DB F4 00
 ioe ld (iy+0), l               ; DB DD 75 00
 ioe ld (iy+126), 0             ; DB DD 36 7E 00
 ioe ld (iy+126), 127           ; DB DD 36 7E 7F
 ioe ld (iy+126), 255           ; DB DD 36 7E FF
 ioe ld (iy+126), a             ; DB DD 77 7E
 ioe ld (iy+126), b             ; DB DD 70 7E
 ioe ld (iy+126), c             ; DB DD 71 7E
 ioe ld (iy+126), d             ; DB DD 72 7E
 ioe ld (iy+126), e             ; DB DD 73 7E
 ioe ld (iy+126), h             ; DB DD 74 7E
 ioe ld (iy+126), hl            ; DB F4 7E
 ioe ld (iy+126), l             ; DB DD 75 7E
 ioe ld (iy-128), 0             ; DB DD 36 80 00
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
 ioe ld a', (0x1234)            ; DB 76 3A 34 12
 ioe ld a', (bc)                ; DB 76 0A
 ioe ld a', (de)                ; DB 76 1A
 ioe ld a', (hl)                ; DB 76 7E
 ioe ld a', (ix)                ; DB 76 FD 7E 00
 ioe ld a', (ix+0)              ; DB 76 FD 7E 00
 ioe ld a', (ix+126)            ; DB 76 FD 7E 7E
 ioe ld a', (ix-128)            ; DB 76 FD 7E 80
 ioe ld a', (iy)                ; DB 76 DD 7E 00
 ioe ld a', (iy+0)              ; DB 76 DD 7E 00
 ioe ld a', (iy+126)            ; DB 76 DD 7E 7E
 ioe ld a', (iy-128)            ; DB 76 DD 7E 80
 ioe ld a, (0x1234)             ; DB 3A 34 12
 ioe ld a, (bc)                 ; DB 0A
 ioe ld a, (de)                 ; DB 1A
 ioe ld a, (hl)                 ; DB 7E
 ioe ld a, (ix)                 ; DB FD 7E 00
 ioe ld a, (ix+0)               ; DB FD 7E 00
 ioe ld a, (ix+126)             ; DB FD 7E 7E
 ioe ld a, (ix-128)             ; DB FD 7E 80
 ioe ld a, (iy)                 ; DB DD 7E 00
 ioe ld a, (iy+0)               ; DB DD 7E 00
 ioe ld a, (iy+126)             ; DB DD 7E 7E
 ioe ld a, (iy-128)             ; DB DD 7E 80
 ioe ld b', (hl)                ; DB 76 46
 ioe ld b', (ix)                ; DB 76 FD 46 00
 ioe ld b', (ix+0)              ; DB 76 FD 46 00
 ioe ld b', (ix+126)            ; DB 76 FD 46 7E
 ioe ld b', (ix-128)            ; DB 76 FD 46 80
 ioe ld b', (iy)                ; DB 76 DD 46 00
 ioe ld b', (iy+0)              ; DB 76 DD 46 00
 ioe ld b', (iy+126)            ; DB 76 DD 46 7E
 ioe ld b', (iy-128)            ; DB 76 DD 46 80
 ioe ld b, (hl)                 ; DB 46
 ioe ld b, (ix)                 ; DB FD 46 00
 ioe ld b, (ix+0)               ; DB FD 46 00
 ioe ld b, (ix+126)             ; DB FD 46 7E
 ioe ld b, (ix-128)             ; DB FD 46 80
 ioe ld b, (iy)                 ; DB DD 46 00
 ioe ld b, (iy+0)               ; DB DD 46 00
 ioe ld b, (iy+126)             ; DB DD 46 7E
 ioe ld b, (iy-128)             ; DB DD 46 80
 ioe ld bc', (0x1234)           ; DB 76 ED 4B 34 12
 ioe ld bc, (0x1234)            ; DB ED 4B 34 12
 ioe ld c', (hl)                ; DB 76 4E
 ioe ld c', (ix)                ; DB 76 FD 4E 00
 ioe ld c', (ix+0)              ; DB 76 FD 4E 00
 ioe ld c', (ix+126)            ; DB 76 FD 4E 7E
 ioe ld c', (ix-128)            ; DB 76 FD 4E 80
 ioe ld c', (iy)                ; DB 76 DD 4E 00
 ioe ld c', (iy+0)              ; DB 76 DD 4E 00
 ioe ld c', (iy+126)            ; DB 76 DD 4E 7E
 ioe ld c', (iy-128)            ; DB 76 DD 4E 80
 ioe ld c, (hl)                 ; DB 4E
 ioe ld c, (ix)                 ; DB FD 4E 00
 ioe ld c, (ix+0)               ; DB FD 4E 00
 ioe ld c, (ix+126)             ; DB FD 4E 7E
 ioe ld c, (ix-128)             ; DB FD 4E 80
 ioe ld c, (iy)                 ; DB DD 4E 00
 ioe ld c, (iy+0)               ; DB DD 4E 00
 ioe ld c, (iy+126)             ; DB DD 4E 7E
 ioe ld c, (iy-128)             ; DB DD 4E 80
 ioe ld d', (hl)                ; DB 76 56
 ioe ld d', (ix)                ; DB 76 FD 56 00
 ioe ld d', (ix+0)              ; DB 76 FD 56 00
 ioe ld d', (ix+126)            ; DB 76 FD 56 7E
 ioe ld d', (ix-128)            ; DB 76 FD 56 80
 ioe ld d', (iy)                ; DB 76 DD 56 00
 ioe ld d', (iy+0)              ; DB 76 DD 56 00
 ioe ld d', (iy+126)            ; DB 76 DD 56 7E
 ioe ld d', (iy-128)            ; DB 76 DD 56 80
 ioe ld d, (hl)                 ; DB 56
 ioe ld d, (ix)                 ; DB FD 56 00
 ioe ld d, (ix+0)               ; DB FD 56 00
 ioe ld d, (ix+126)             ; DB FD 56 7E
 ioe ld d, (ix-128)             ; DB FD 56 80
 ioe ld d, (iy)                 ; DB DD 56 00
 ioe ld d, (iy+0)               ; DB DD 56 00
 ioe ld d, (iy+126)             ; DB DD 56 7E
 ioe ld d, (iy-128)             ; DB DD 56 80
 ioe ld de', (0x1234)           ; DB 76 ED 5B 34 12
 ioe ld de, (0x1234)            ; DB ED 5B 34 12
 ioe ld e', (hl)                ; DB 76 5E
 ioe ld e', (ix)                ; DB 76 FD 5E 00
 ioe ld e', (ix+0)              ; DB 76 FD 5E 00
 ioe ld e', (ix+126)            ; DB 76 FD 5E 7E
 ioe ld e', (ix-128)            ; DB 76 FD 5E 80
 ioe ld e', (iy)                ; DB 76 DD 5E 00
 ioe ld e', (iy+0)              ; DB 76 DD 5E 00
 ioe ld e', (iy+126)            ; DB 76 DD 5E 7E
 ioe ld e', (iy-128)            ; DB 76 DD 5E 80
 ioe ld e, (hl)                 ; DB 5E
 ioe ld e, (ix)                 ; DB FD 5E 00
 ioe ld e, (ix+0)               ; DB FD 5E 00
 ioe ld e, (ix+126)             ; DB FD 5E 7E
 ioe ld e, (ix-128)             ; DB FD 5E 80
 ioe ld e, (iy)                 ; DB DD 5E 00
 ioe ld e, (iy+0)               ; DB DD 5E 00
 ioe ld e, (iy+126)             ; DB DD 5E 7E
 ioe ld e, (iy-128)             ; DB DD 5E 80
 ioe ld h', (hl)                ; DB 76 66
 ioe ld h', (ix)                ; DB 76 FD 66 00
 ioe ld h', (ix+0)              ; DB 76 FD 66 00
 ioe ld h', (ix+126)            ; DB 76 FD 66 7E
 ioe ld h', (ix-128)            ; DB 76 FD 66 80
 ioe ld h', (iy)                ; DB 76 DD 66 00
 ioe ld h', (iy+0)              ; DB 76 DD 66 00
 ioe ld h', (iy+126)            ; DB 76 DD 66 7E
 ioe ld h', (iy-128)            ; DB 76 DD 66 80
 ioe ld h, (hl)                 ; DB 66
 ioe ld h, (ix)                 ; DB FD 66 00
 ioe ld h, (ix+0)               ; DB FD 66 00
 ioe ld h, (ix+126)             ; DB FD 66 7E
 ioe ld h, (ix-128)             ; DB FD 66 80
 ioe ld h, (iy)                 ; DB DD 66 00
 ioe ld h, (iy+0)               ; DB DD 66 00
 ioe ld h, (iy+126)             ; DB DD 66 7E
 ioe ld h, (iy-128)             ; DB DD 66 80
 ioe ld hl', (0x1234)           ; DB 76 2A 34 12
 ioe ld hl', (hl)               ; DB 76 DD E4 00
 ioe ld hl', (hl+0)             ; DB 76 DD E4 00
 ioe ld hl', (hl+126)           ; DB 76 DD E4 7E
 ioe ld hl', (hl-128)           ; DB 76 DD E4 80
 ioe ld hl', (ix)               ; DB 76 FD E4 00
 ioe ld hl', (ix+0)             ; DB 76 FD E4 00
 ioe ld hl', (ix+126)           ; DB 76 FD E4 7E
 ioe ld hl', (ix-128)           ; DB 76 FD E4 80
 ioe ld hl', (iy)               ; DB 76 E4 00
 ioe ld hl', (iy+0)             ; DB 76 E4 00
 ioe ld hl', (iy+126)           ; DB 76 E4 7E
 ioe ld hl', (iy-128)           ; DB 76 E4 80
 ioe ld hl, (0x1234)            ; DB 2A 34 12
 ioe ld hl, (hl)                ; DB DD E4 00
 ioe ld hl, (hl+0)              ; DB DD E4 00
 ioe ld hl, (hl+126)            ; DB DD E4 7E
 ioe ld hl, (hl-128)            ; DB DD E4 80
 ioe ld hl, (ix)                ; DB FD E4 00
 ioe ld hl, (ix+0)              ; DB FD E4 00
 ioe ld hl, (ix+126)            ; DB FD E4 7E
 ioe ld hl, (ix-128)            ; DB FD E4 80
 ioe ld hl, (iy)                ; DB E4 00
 ioe ld hl, (iy+0)              ; DB E4 00
 ioe ld hl, (iy+126)            ; DB E4 7E
 ioe ld hl, (iy-128)            ; DB E4 80
 ioe ld ix, (0x1234)            ; DB FD 2A 34 12
 ioe ld iy, (0x1234)            ; DB DD 2A 34 12
 ioe ld l', (hl)                ; DB 76 6E
 ioe ld l', (ix)                ; DB 76 FD 6E 00
 ioe ld l', (ix+0)              ; DB 76 FD 6E 00
 ioe ld l', (ix+126)            ; DB 76 FD 6E 7E
 ioe ld l', (ix-128)            ; DB 76 FD 6E 80
 ioe ld l', (iy)                ; DB 76 DD 6E 00
 ioe ld l', (iy+0)              ; DB 76 DD 6E 00
 ioe ld l', (iy+126)            ; DB 76 DD 6E 7E
 ioe ld l', (iy-128)            ; DB 76 DD 6E 80
 ioe ld l, (hl)                 ; DB 6E
 ioe ld l, (ix)                 ; DB FD 6E 00
 ioe ld l, (ix+0)               ; DB FD 6E 00
 ioe ld l, (ix+126)             ; DB FD 6E 7E
 ioe ld l, (ix-128)             ; DB FD 6E 80
 ioe ld l, (iy)                 ; DB DD 6E 00
 ioe ld l, (iy+0)               ; DB DD 6E 00
 ioe ld l, (iy+126)             ; DB DD 6E 7E
 ioe ld l, (iy-128)             ; DB DD 6E 80
 ioe ld sp, (0x1234)            ; DB ED 7B 34 12
 ioe ldd                        ; DB ED A8
 ioe lddr                       ; DB ED B8
 ioe lddsr                      ; DB ED 98
 ioe ldi                        ; DB ED A0
 ioe ldir                       ; DB ED B0
 ioe ldisr                      ; DB ED 90
 ioe lsddr                      ; DB ED D8
 ioe lsdr                       ; DB ED F8
 ioe lsidr                      ; DB ED D0
 ioe lsir                       ; DB ED F0
 ioe or (hl)                    ; DB B6
 ioe or (ix)                    ; DB FD B6 00
 ioe or (ix+0)                  ; DB FD B6 00
 ioe or (ix+126)                ; DB FD B6 7E
 ioe or (ix-128)                ; DB FD B6 80
 ioe or (iy)                    ; DB DD B6 00
 ioe or (iy+0)                  ; DB DD B6 00
 ioe or (iy+126)                ; DB DD B6 7E
 ioe or (iy-128)                ; DB DD B6 80
 ioe res 0, (hl)                ; DB CB 86
 ioe res 0, (ix)                ; DB FD CB 00 86
 ioe res 0, (ix+0)              ; DB FD CB 00 86
 ioe res 0, (ix+126)            ; DB FD CB 7E 86
 ioe res 0, (ix-128)            ; DB FD CB 80 86
 ioe res 0, (iy)                ; DB DD CB 00 86
 ioe res 0, (iy+0)              ; DB DD CB 00 86
 ioe res 0, (iy+126)            ; DB DD CB 7E 86
 ioe res 0, (iy-128)            ; DB DD CB 80 86
 ioe res 1, (hl)                ; DB CB 8E
 ioe res 1, (ix)                ; DB FD CB 00 8E
 ioe res 1, (ix+0)              ; DB FD CB 00 8E
 ioe res 1, (ix+126)            ; DB FD CB 7E 8E
 ioe res 1, (ix-128)            ; DB FD CB 80 8E
 ioe res 1, (iy)                ; DB DD CB 00 8E
 ioe res 1, (iy+0)              ; DB DD CB 00 8E
 ioe res 1, (iy+126)            ; DB DD CB 7E 8E
 ioe res 1, (iy-128)            ; DB DD CB 80 8E
 ioe res 2, (hl)                ; DB CB 96
 ioe res 2, (ix)                ; DB FD CB 00 96
 ioe res 2, (ix+0)              ; DB FD CB 00 96
 ioe res 2, (ix+126)            ; DB FD CB 7E 96
 ioe res 2, (ix-128)            ; DB FD CB 80 96
 ioe res 2, (iy)                ; DB DD CB 00 96
 ioe res 2, (iy+0)              ; DB DD CB 00 96
 ioe res 2, (iy+126)            ; DB DD CB 7E 96
 ioe res 2, (iy-128)            ; DB DD CB 80 96
 ioe res 3, (hl)                ; DB CB 9E
 ioe res 3, (ix)                ; DB FD CB 00 9E
 ioe res 3, (ix+0)              ; DB FD CB 00 9E
 ioe res 3, (ix+126)            ; DB FD CB 7E 9E
 ioe res 3, (ix-128)            ; DB FD CB 80 9E
 ioe res 3, (iy)                ; DB DD CB 00 9E
 ioe res 3, (iy+0)              ; DB DD CB 00 9E
 ioe res 3, (iy+126)            ; DB DD CB 7E 9E
 ioe res 3, (iy-128)            ; DB DD CB 80 9E
 ioe res 4, (hl)                ; DB CB A6
 ioe res 4, (ix)                ; DB FD CB 00 A6
 ioe res 4, (ix+0)              ; DB FD CB 00 A6
 ioe res 4, (ix+126)            ; DB FD CB 7E A6
 ioe res 4, (ix-128)            ; DB FD CB 80 A6
 ioe res 4, (iy)                ; DB DD CB 00 A6
 ioe res 4, (iy+0)              ; DB DD CB 00 A6
 ioe res 4, (iy+126)            ; DB DD CB 7E A6
 ioe res 4, (iy-128)            ; DB DD CB 80 A6
 ioe res 5, (hl)                ; DB CB AE
 ioe res 5, (ix)                ; DB FD CB 00 AE
 ioe res 5, (ix+0)              ; DB FD CB 00 AE
 ioe res 5, (ix+126)            ; DB FD CB 7E AE
 ioe res 5, (ix-128)            ; DB FD CB 80 AE
 ioe res 5, (iy)                ; DB DD CB 00 AE
 ioe res 5, (iy+0)              ; DB DD CB 00 AE
 ioe res 5, (iy+126)            ; DB DD CB 7E AE
 ioe res 5, (iy-128)            ; DB DD CB 80 AE
 ioe res 6, (hl)                ; DB CB B6
 ioe res 6, (ix)                ; DB FD CB 00 B6
 ioe res 6, (ix+0)              ; DB FD CB 00 B6
 ioe res 6, (ix+126)            ; DB FD CB 7E B6
 ioe res 6, (ix-128)            ; DB FD CB 80 B6
 ioe res 6, (iy)                ; DB DD CB 00 B6
 ioe res 6, (iy+0)              ; DB DD CB 00 B6
 ioe res 6, (iy+126)            ; DB DD CB 7E B6
 ioe res 6, (iy-128)            ; DB DD CB 80 B6
 ioe res 7, (hl)                ; DB CB BE
 ioe res 7, (ix)                ; DB FD CB 00 BE
 ioe res 7, (ix+0)              ; DB FD CB 00 BE
 ioe res 7, (ix+126)            ; DB FD CB 7E BE
 ioe res 7, (ix-128)            ; DB FD CB 80 BE
 ioe res 7, (iy)                ; DB DD CB 00 BE
 ioe res 7, (iy+0)              ; DB DD CB 00 BE
 ioe res 7, (iy+126)            ; DB DD CB 7E BE
 ioe res 7, (iy-128)            ; DB DD CB 80 BE
 ioe rl (hl)                    ; DB CB 16
 ioe rl (ix)                    ; DB FD CB 00 16
 ioe rl (ix+0)                  ; DB FD CB 00 16
 ioe rl (ix+126)                ; DB FD CB 7E 16
 ioe rl (ix-128)                ; DB FD CB 80 16
 ioe rl (iy)                    ; DB DD CB 00 16
 ioe rl (iy+0)                  ; DB DD CB 00 16
 ioe rl (iy+126)                ; DB DD CB 7E 16
 ioe rl (iy-128)                ; DB DD CB 80 16
 ioe rlc (hl)                   ; DB CB 06
 ioe rlc (ix)                   ; DB FD CB 00 06
 ioe rlc (ix+0)                 ; DB FD CB 00 06
 ioe rlc (ix+126)               ; DB FD CB 7E 06
 ioe rlc (ix-128)               ; DB FD CB 80 06
 ioe rlc (iy)                   ; DB DD CB 00 06
 ioe rlc (iy+0)                 ; DB DD CB 00 06
 ioe rlc (iy+126)               ; DB DD CB 7E 06
 ioe rlc (iy-128)               ; DB DD CB 80 06
 ioe rr (hl)                    ; DB CB 1E
 ioe rr (ix)                    ; DB FD CB 00 1E
 ioe rr (ix+0)                  ; DB FD CB 00 1E
 ioe rr (ix+126)                ; DB FD CB 7E 1E
 ioe rr (ix-128)                ; DB FD CB 80 1E
 ioe rr (iy)                    ; DB DD CB 00 1E
 ioe rr (iy+0)                  ; DB DD CB 00 1E
 ioe rr (iy+126)                ; DB DD CB 7E 1E
 ioe rr (iy-128)                ; DB DD CB 80 1E
 ioe rrc (hl)                   ; DB CB 0E
 ioe rrc (ix)                   ; DB FD CB 00 0E
 ioe rrc (ix+0)                 ; DB FD CB 00 0E
 ioe rrc (ix+126)               ; DB FD CB 7E 0E
 ioe rrc (ix-128)               ; DB FD CB 80 0E
 ioe rrc (iy)                   ; DB DD CB 00 0E
 ioe rrc (iy+0)                 ; DB DD CB 00 0E
 ioe rrc (iy+126)               ; DB DD CB 7E 0E
 ioe rrc (iy-128)               ; DB DD CB 80 0E
 ioe sbc a', (hl)               ; DB 76 9E
 ioe sbc a', (ix)               ; DB 76 FD 9E 00
 ioe sbc a', (ix+0)             ; DB 76 FD 9E 00
 ioe sbc a', (ix+126)           ; DB 76 FD 9E 7E
 ioe sbc a', (ix-128)           ; DB 76 FD 9E 80
 ioe sbc a', (iy)               ; DB 76 DD 9E 00
 ioe sbc a', (iy+0)             ; DB 76 DD 9E 00
 ioe sbc a', (iy+126)           ; DB 76 DD 9E 7E
 ioe sbc a', (iy-128)           ; DB 76 DD 9E 80
 ioe sbc a, (hl)                ; DB 9E
 ioe sbc a, (ix)                ; DB FD 9E 00
 ioe sbc a, (ix+0)              ; DB FD 9E 00
 ioe sbc a, (ix+126)            ; DB FD 9E 7E
 ioe sbc a, (ix-128)            ; DB FD 9E 80
 ioe sbc a, (iy)                ; DB DD 9E 00
 ioe sbc a, (iy+0)              ; DB DD 9E 00
 ioe sbc a, (iy+126)            ; DB DD 9E 7E
 ioe sbc a, (iy-128)            ; DB DD 9E 80
 ioe set 0, (hl)                ; DB CB C6
 ioe set 0, (ix)                ; DB FD CB 00 C6
 ioe set 0, (ix+0)              ; DB FD CB 00 C6
 ioe set 0, (ix+126)            ; DB FD CB 7E C6
 ioe set 0, (ix-128)            ; DB FD CB 80 C6
 ioe set 0, (iy)                ; DB DD CB 00 C6
 ioe set 0, (iy+0)              ; DB DD CB 00 C6
 ioe set 0, (iy+126)            ; DB DD CB 7E C6
 ioe set 0, (iy-128)            ; DB DD CB 80 C6
 ioe set 1, (hl)                ; DB CB CE
 ioe set 1, (ix)                ; DB FD CB 00 CE
 ioe set 1, (ix+0)              ; DB FD CB 00 CE
 ioe set 1, (ix+126)            ; DB FD CB 7E CE
 ioe set 1, (ix-128)            ; DB FD CB 80 CE
 ioe set 1, (iy)                ; DB DD CB 00 CE
 ioe set 1, (iy+0)              ; DB DD CB 00 CE
 ioe set 1, (iy+126)            ; DB DD CB 7E CE
 ioe set 1, (iy-128)            ; DB DD CB 80 CE
 ioe set 2, (hl)                ; DB CB D6
 ioe set 2, (ix)                ; DB FD CB 00 D6
 ioe set 2, (ix+0)              ; DB FD CB 00 D6
 ioe set 2, (ix+126)            ; DB FD CB 7E D6
 ioe set 2, (ix-128)            ; DB FD CB 80 D6
 ioe set 2, (iy)                ; DB DD CB 00 D6
 ioe set 2, (iy+0)              ; DB DD CB 00 D6
 ioe set 2, (iy+126)            ; DB DD CB 7E D6
 ioe set 2, (iy-128)            ; DB DD CB 80 D6
 ioe set 3, (hl)                ; DB CB DE
 ioe set 3, (ix)                ; DB FD CB 00 DE
 ioe set 3, (ix+0)              ; DB FD CB 00 DE
 ioe set 3, (ix+126)            ; DB FD CB 7E DE
 ioe set 3, (ix-128)            ; DB FD CB 80 DE
 ioe set 3, (iy)                ; DB DD CB 00 DE
 ioe set 3, (iy+0)              ; DB DD CB 00 DE
 ioe set 3, (iy+126)            ; DB DD CB 7E DE
 ioe set 3, (iy-128)            ; DB DD CB 80 DE
 ioe set 4, (hl)                ; DB CB E6
 ioe set 4, (ix)                ; DB FD CB 00 E6
 ioe set 4, (ix+0)              ; DB FD CB 00 E6
 ioe set 4, (ix+126)            ; DB FD CB 7E E6
 ioe set 4, (ix-128)            ; DB FD CB 80 E6
 ioe set 4, (iy)                ; DB DD CB 00 E6
 ioe set 4, (iy+0)              ; DB DD CB 00 E6
 ioe set 4, (iy+126)            ; DB DD CB 7E E6
 ioe set 4, (iy-128)            ; DB DD CB 80 E6
 ioe set 5, (hl)                ; DB CB EE
 ioe set 5, (ix)                ; DB FD CB 00 EE
 ioe set 5, (ix+0)              ; DB FD CB 00 EE
 ioe set 5, (ix+126)            ; DB FD CB 7E EE
 ioe set 5, (ix-128)            ; DB FD CB 80 EE
 ioe set 5, (iy)                ; DB DD CB 00 EE
 ioe set 5, (iy+0)              ; DB DD CB 00 EE
 ioe set 5, (iy+126)            ; DB DD CB 7E EE
 ioe set 5, (iy-128)            ; DB DD CB 80 EE
 ioe set 6, (hl)                ; DB CB F6
 ioe set 6, (ix)                ; DB FD CB 00 F6
 ioe set 6, (ix+0)              ; DB FD CB 00 F6
 ioe set 6, (ix+126)            ; DB FD CB 7E F6
 ioe set 6, (ix-128)            ; DB FD CB 80 F6
 ioe set 6, (iy)                ; DB DD CB 00 F6
 ioe set 6, (iy+0)              ; DB DD CB 00 F6
 ioe set 6, (iy+126)            ; DB DD CB 7E F6
 ioe set 6, (iy-128)            ; DB DD CB 80 F6
 ioe set 7, (hl)                ; DB CB FE
 ioe set 7, (ix)                ; DB FD CB 00 FE
 ioe set 7, (ix+0)              ; DB FD CB 00 FE
 ioe set 7, (ix+126)            ; DB FD CB 7E FE
 ioe set 7, (ix-128)            ; DB FD CB 80 FE
 ioe set 7, (iy)                ; DB DD CB 00 FE
 ioe set 7, (iy+0)              ; DB DD CB 00 FE
 ioe set 7, (iy+126)            ; DB DD CB 7E FE
 ioe set 7, (iy-128)            ; DB DD CB 80 FE
 ioe sla (hl)                   ; DB CB 26
 ioe sla (ix)                   ; DB FD CB 00 26
 ioe sla (ix+0)                 ; DB FD CB 00 26
 ioe sla (ix+126)               ; DB FD CB 7E 26
 ioe sla (ix-128)               ; DB FD CB 80 26
 ioe sla (iy)                   ; DB DD CB 00 26
 ioe sla (iy+0)                 ; DB DD CB 00 26
 ioe sla (iy+126)               ; DB DD CB 7E 26
 ioe sla (iy-128)               ; DB DD CB 80 26
 ioe sra (hl)                   ; DB CB 2E
 ioe sra (ix)                   ; DB FD CB 00 2E
 ioe sra (ix+0)                 ; DB FD CB 00 2E
 ioe sra (ix+126)               ; DB FD CB 7E 2E
 ioe sra (ix-128)               ; DB FD CB 80 2E
 ioe sra (iy)                   ; DB DD CB 00 2E
 ioe sra (iy+0)                 ; DB DD CB 00 2E
 ioe sra (iy+126)               ; DB DD CB 7E 2E
 ioe sra (iy-128)               ; DB DD CB 80 2E
 ioe srl (hl)                   ; DB CB 3E
 ioe srl (ix)                   ; DB FD CB 00 3E
 ioe srl (ix+0)                 ; DB FD CB 00 3E
 ioe srl (ix+126)               ; DB FD CB 7E 3E
 ioe srl (ix-128)               ; DB FD CB 80 3E
 ioe srl (iy)                   ; DB DD CB 00 3E
 ioe srl (iy+0)                 ; DB DD CB 00 3E
 ioe srl (iy+126)               ; DB DD CB 7E 3E
 ioe srl (iy-128)               ; DB DD CB 80 3E
 ioe sub (hl)                   ; DB 96
 ioe sub (ix)                   ; DB FD 96 00
 ioe sub (ix+0)                 ; DB FD 96 00
 ioe sub (ix+126)               ; DB FD 96 7E
 ioe sub (ix-128)               ; DB FD 96 80
 ioe sub (iy)                   ; DB DD 96 00
 ioe sub (iy+0)                 ; DB DD 96 00
 ioe sub (iy+126)               ; DB DD 96 7E
 ioe sub (iy-128)               ; DB DD 96 80
 ioe xor (hl)                   ; DB AE
 ioe xor (ix)                   ; DB FD AE 00
 ioe xor (ix+0)                 ; DB FD AE 00
 ioe xor (ix+126)               ; DB FD AE 7E
 ioe xor (ix-128)               ; DB FD AE 80
 ioe xor (iy)                   ; DB DD AE 00
 ioe xor (iy+0)                 ; DB DD AE 00
 ioe xor (iy+126)               ; DB DD AE 7E
 ioe xor (iy-128)               ; DB DD AE 80
 ioi adc a', (hl)               ; D3 76 8E
 ioi adc a', (ix)               ; D3 76 FD 8E 00
 ioi adc a', (ix+0)             ; D3 76 FD 8E 00
 ioi adc a', (ix+126)           ; D3 76 FD 8E 7E
 ioi adc a', (ix-128)           ; D3 76 FD 8E 80
 ioi adc a', (iy)               ; D3 76 DD 8E 00
 ioi adc a', (iy+0)             ; D3 76 DD 8E 00
 ioi adc a', (iy+126)           ; D3 76 DD 8E 7E
 ioi adc a', (iy-128)           ; D3 76 DD 8E 80
 ioi adc a, (hl)                ; D3 8E
 ioi adc a, (ix)                ; D3 FD 8E 00
 ioi adc a, (ix+0)              ; D3 FD 8E 00
 ioi adc a, (ix+126)            ; D3 FD 8E 7E
 ioi adc a, (ix-128)            ; D3 FD 8E 80
 ioi adc a, (iy)                ; D3 DD 8E 00
 ioi adc a, (iy+0)              ; D3 DD 8E 00
 ioi adc a, (iy+126)            ; D3 DD 8E 7E
 ioi adc a, (iy-128)            ; D3 DD 8E 80
 ioi add a', (hl)               ; D3 76 86
 ioi add a', (ix)               ; D3 76 FD 86 00
 ioi add a', (ix+0)             ; D3 76 FD 86 00
 ioi add a', (ix+126)           ; D3 76 FD 86 7E
 ioi add a', (ix-128)           ; D3 76 FD 86 80
 ioi add a', (iy)               ; D3 76 DD 86 00
 ioi add a', (iy+0)             ; D3 76 DD 86 00
 ioi add a', (iy+126)           ; D3 76 DD 86 7E
 ioi add a', (iy-128)           ; D3 76 DD 86 80
 ioi add a, (hl)                ; D3 86
 ioi add a, (ix)                ; D3 FD 86 00
 ioi add a, (ix+0)              ; D3 FD 86 00
 ioi add a, (ix+126)            ; D3 FD 86 7E
 ioi add a, (ix-128)            ; D3 FD 86 80
 ioi add a, (iy)                ; D3 DD 86 00
 ioi add a, (iy+0)              ; D3 DD 86 00
 ioi add a, (iy+126)            ; D3 DD 86 7E
 ioi add a, (iy-128)            ; D3 DD 86 80
 ioi altd adc a, (hl)           ; D3 76 8E
 ioi altd adc a, (ix)           ; D3 76 FD 8E 00
 ioi altd adc a, (ix+0)         ; D3 76 FD 8E 00
 ioi altd adc a, (ix+126)       ; D3 76 FD 8E 7E
 ioi altd adc a, (ix-128)       ; D3 76 FD 8E 80
 ioi altd adc a, (iy)           ; D3 76 DD 8E 00
 ioi altd adc a, (iy+0)         ; D3 76 DD 8E 00
 ioi altd adc a, (iy+126)       ; D3 76 DD 8E 7E
 ioi altd adc a, (iy-128)       ; D3 76 DD 8E 80
 ioi altd add a, (hl)           ; D3 76 86
 ioi altd add a, (ix)           ; D3 76 FD 86 00
 ioi altd add a, (ix+0)         ; D3 76 FD 86 00
 ioi altd add a, (ix+126)       ; D3 76 FD 86 7E
 ioi altd add a, (ix-128)       ; D3 76 FD 86 80
 ioi altd add a, (iy)           ; D3 76 DD 86 00
 ioi altd add a, (iy+0)         ; D3 76 DD 86 00
 ioi altd add a, (iy+126)       ; D3 76 DD 86 7E
 ioi altd add a, (iy-128)       ; D3 76 DD 86 80
 ioi altd and (hl)              ; D3 76 A6
 ioi altd and (ix)              ; D3 76 FD A6 00
 ioi altd and (ix+0)            ; D3 76 FD A6 00
 ioi altd and (ix+126)          ; D3 76 FD A6 7E
 ioi altd and (ix-128)          ; D3 76 FD A6 80
 ioi altd and (iy)              ; D3 76 DD A6 00
 ioi altd and (iy+0)            ; D3 76 DD A6 00
 ioi altd and (iy+126)          ; D3 76 DD A6 7E
 ioi altd and (iy-128)          ; D3 76 DD A6 80
 ioi altd bit 0, (hl)           ; D3 76 CB 46
 ioi altd bit 0, (ix)           ; D3 76 FD CB 00 46
 ioi altd bit 0, (ix+0)         ; D3 76 FD CB 00 46
 ioi altd bit 0, (ix+126)       ; D3 76 FD CB 7E 46
 ioi altd bit 0, (ix-128)       ; D3 76 FD CB 80 46
 ioi altd bit 0, (iy)           ; D3 76 DD CB 00 46
 ioi altd bit 0, (iy+0)         ; D3 76 DD CB 00 46
 ioi altd bit 0, (iy+126)       ; D3 76 DD CB 7E 46
 ioi altd bit 0, (iy-128)       ; D3 76 DD CB 80 46
 ioi altd bit 1, (hl)           ; D3 76 CB 4E
 ioi altd bit 1, (ix)           ; D3 76 FD CB 00 4E
 ioi altd bit 1, (ix+0)         ; D3 76 FD CB 00 4E
 ioi altd bit 1, (ix+126)       ; D3 76 FD CB 7E 4E
 ioi altd bit 1, (ix-128)       ; D3 76 FD CB 80 4E
 ioi altd bit 1, (iy)           ; D3 76 DD CB 00 4E
 ioi altd bit 1, (iy+0)         ; D3 76 DD CB 00 4E
 ioi altd bit 1, (iy+126)       ; D3 76 DD CB 7E 4E
 ioi altd bit 1, (iy-128)       ; D3 76 DD CB 80 4E
 ioi altd bit 2, (hl)           ; D3 76 CB 56
 ioi altd bit 2, (ix)           ; D3 76 FD CB 00 56
 ioi altd bit 2, (ix+0)         ; D3 76 FD CB 00 56
 ioi altd bit 2, (ix+126)       ; D3 76 FD CB 7E 56
 ioi altd bit 2, (ix-128)       ; D3 76 FD CB 80 56
 ioi altd bit 2, (iy)           ; D3 76 DD CB 00 56
 ioi altd bit 2, (iy+0)         ; D3 76 DD CB 00 56
 ioi altd bit 2, (iy+126)       ; D3 76 DD CB 7E 56
 ioi altd bit 2, (iy-128)       ; D3 76 DD CB 80 56
 ioi altd bit 3, (hl)           ; D3 76 CB 5E
 ioi altd bit 3, (ix)           ; D3 76 FD CB 00 5E
 ioi altd bit 3, (ix+0)         ; D3 76 FD CB 00 5E
 ioi altd bit 3, (ix+126)       ; D3 76 FD CB 7E 5E
 ioi altd bit 3, (ix-128)       ; D3 76 FD CB 80 5E
 ioi altd bit 3, (iy)           ; D3 76 DD CB 00 5E
 ioi altd bit 3, (iy+0)         ; D3 76 DD CB 00 5E
 ioi altd bit 3, (iy+126)       ; D3 76 DD CB 7E 5E
 ioi altd bit 3, (iy-128)       ; D3 76 DD CB 80 5E
 ioi altd bit 4, (hl)           ; D3 76 CB 66
 ioi altd bit 4, (ix)           ; D3 76 FD CB 00 66
 ioi altd bit 4, (ix+0)         ; D3 76 FD CB 00 66
 ioi altd bit 4, (ix+126)       ; D3 76 FD CB 7E 66
 ioi altd bit 4, (ix-128)       ; D3 76 FD CB 80 66
 ioi altd bit 4, (iy)           ; D3 76 DD CB 00 66
 ioi altd bit 4, (iy+0)         ; D3 76 DD CB 00 66
 ioi altd bit 4, (iy+126)       ; D3 76 DD CB 7E 66
 ioi altd bit 4, (iy-128)       ; D3 76 DD CB 80 66
 ioi altd bit 5, (hl)           ; D3 76 CB 6E
 ioi altd bit 5, (ix)           ; D3 76 FD CB 00 6E
 ioi altd bit 5, (ix+0)         ; D3 76 FD CB 00 6E
 ioi altd bit 5, (ix+126)       ; D3 76 FD CB 7E 6E
 ioi altd bit 5, (ix-128)       ; D3 76 FD CB 80 6E
 ioi altd bit 5, (iy)           ; D3 76 DD CB 00 6E
 ioi altd bit 5, (iy+0)         ; D3 76 DD CB 00 6E
 ioi altd bit 5, (iy+126)       ; D3 76 DD CB 7E 6E
 ioi altd bit 5, (iy-128)       ; D3 76 DD CB 80 6E
 ioi altd bit 6, (hl)           ; D3 76 CB 76
 ioi altd bit 6, (ix)           ; D3 76 FD CB 00 76
 ioi altd bit 6, (ix+0)         ; D3 76 FD CB 00 76
 ioi altd bit 6, (ix+126)       ; D3 76 FD CB 7E 76
 ioi altd bit 6, (ix-128)       ; D3 76 FD CB 80 76
 ioi altd bit 6, (iy)           ; D3 76 DD CB 00 76
 ioi altd bit 6, (iy+0)         ; D3 76 DD CB 00 76
 ioi altd bit 6, (iy+126)       ; D3 76 DD CB 7E 76
 ioi altd bit 6, (iy-128)       ; D3 76 DD CB 80 76
 ioi altd bit 7, (hl)           ; D3 76 CB 7E
 ioi altd bit 7, (ix)           ; D3 76 FD CB 00 7E
 ioi altd bit 7, (ix+0)         ; D3 76 FD CB 00 7E
 ioi altd bit 7, (ix+126)       ; D3 76 FD CB 7E 7E
 ioi altd bit 7, (ix-128)       ; D3 76 FD CB 80 7E
 ioi altd bit 7, (iy)           ; D3 76 DD CB 00 7E
 ioi altd bit 7, (iy+0)         ; D3 76 DD CB 00 7E
 ioi altd bit 7, (iy+126)       ; D3 76 DD CB 7E 7E
 ioi altd bit 7, (iy-128)       ; D3 76 DD CB 80 7E
 ioi altd cp (hl)               ; D3 76 BE
 ioi altd cp (ix)               ; D3 76 FD BE 00
 ioi altd cp (ix+0)             ; D3 76 FD BE 00
 ioi altd cp (ix+126)           ; D3 76 FD BE 7E
 ioi altd cp (ix-128)           ; D3 76 FD BE 80
 ioi altd cp (iy)               ; D3 76 DD BE 00
 ioi altd cp (iy+0)             ; D3 76 DD BE 00
 ioi altd cp (iy+126)           ; D3 76 DD BE 7E
 ioi altd cp (iy-128)           ; D3 76 DD BE 80
 ioi altd dec (hl)              ; D3 76 35
 ioi altd dec (ix)              ; D3 76 FD 35 00
 ioi altd dec (ix+0)            ; D3 76 FD 35 00
 ioi altd dec (ix+126)          ; D3 76 FD 35 7E
 ioi altd dec (ix-128)          ; D3 76 FD 35 80
 ioi altd dec (iy)              ; D3 76 DD 35 00
 ioi altd dec (iy+0)            ; D3 76 DD 35 00
 ioi altd dec (iy+126)          ; D3 76 DD 35 7E
 ioi altd dec (iy-128)          ; D3 76 DD 35 80
 ioi altd inc (hl)              ; D3 76 34
 ioi altd inc (ix)              ; D3 76 FD 34 00
 ioi altd inc (ix+0)            ; D3 76 FD 34 00
 ioi altd inc (ix+126)          ; D3 76 FD 34 7E
 ioi altd inc (ix-128)          ; D3 76 FD 34 80
 ioi altd inc (iy)              ; D3 76 DD 34 00
 ioi altd inc (iy+0)            ; D3 76 DD 34 00
 ioi altd inc (iy+126)          ; D3 76 DD 34 7E
 ioi altd inc (iy-128)          ; D3 76 DD 34 80
 ioi altd ld a, (0x1234)        ; D3 76 3A 34 12
 ioi altd ld a, (bc)            ; D3 76 0A
 ioi altd ld a, (de)            ; D3 76 1A
 ioi altd ld a, (hl)            ; D3 76 7E
 ioi altd ld a, (ix)            ; D3 76 FD 7E 00
 ioi altd ld a, (ix+0)          ; D3 76 FD 7E 00
 ioi altd ld a, (ix+126)        ; D3 76 FD 7E 7E
 ioi altd ld a, (ix-128)        ; D3 76 FD 7E 80
 ioi altd ld a, (iy)            ; D3 76 DD 7E 00
 ioi altd ld a, (iy+0)          ; D3 76 DD 7E 00
 ioi altd ld a, (iy+126)        ; D3 76 DD 7E 7E
 ioi altd ld a, (iy-128)        ; D3 76 DD 7E 80
 ioi altd ld b, (hl)            ; D3 76 46
 ioi altd ld b, (ix)            ; D3 76 FD 46 00
 ioi altd ld b, (ix+0)          ; D3 76 FD 46 00
 ioi altd ld b, (ix+126)        ; D3 76 FD 46 7E
 ioi altd ld b, (ix-128)        ; D3 76 FD 46 80
 ioi altd ld b, (iy)            ; D3 76 DD 46 00
 ioi altd ld b, (iy+0)          ; D3 76 DD 46 00
 ioi altd ld b, (iy+126)        ; D3 76 DD 46 7E
 ioi altd ld b, (iy-128)        ; D3 76 DD 46 80
 ioi altd ld bc, (0x1234)       ; D3 76 ED 4B 34 12
 ioi altd ld c, (hl)            ; D3 76 4E
 ioi altd ld c, (ix)            ; D3 76 FD 4E 00
 ioi altd ld c, (ix+0)          ; D3 76 FD 4E 00
 ioi altd ld c, (ix+126)        ; D3 76 FD 4E 7E
 ioi altd ld c, (ix-128)        ; D3 76 FD 4E 80
 ioi altd ld c, (iy)            ; D3 76 DD 4E 00
 ioi altd ld c, (iy+0)          ; D3 76 DD 4E 00
 ioi altd ld c, (iy+126)        ; D3 76 DD 4E 7E
 ioi altd ld c, (iy-128)        ; D3 76 DD 4E 80
 ioi altd ld d, (hl)            ; D3 76 56
 ioi altd ld d, (ix)            ; D3 76 FD 56 00
 ioi altd ld d, (ix+0)          ; D3 76 FD 56 00
 ioi altd ld d, (ix+126)        ; D3 76 FD 56 7E
 ioi altd ld d, (ix-128)        ; D3 76 FD 56 80
 ioi altd ld d, (iy)            ; D3 76 DD 56 00
 ioi altd ld d, (iy+0)          ; D3 76 DD 56 00
 ioi altd ld d, (iy+126)        ; D3 76 DD 56 7E
 ioi altd ld d, (iy-128)        ; D3 76 DD 56 80
 ioi altd ld de, (0x1234)       ; D3 76 ED 5B 34 12
 ioi altd ld e, (hl)            ; D3 76 5E
 ioi altd ld e, (ix)            ; D3 76 FD 5E 00
 ioi altd ld e, (ix+0)          ; D3 76 FD 5E 00
 ioi altd ld e, (ix+126)        ; D3 76 FD 5E 7E
 ioi altd ld e, (ix-128)        ; D3 76 FD 5E 80
 ioi altd ld e, (iy)            ; D3 76 DD 5E 00
 ioi altd ld e, (iy+0)          ; D3 76 DD 5E 00
 ioi altd ld e, (iy+126)        ; D3 76 DD 5E 7E
 ioi altd ld e, (iy-128)        ; D3 76 DD 5E 80
 ioi altd ld h, (hl)            ; D3 76 66
 ioi altd ld h, (ix)            ; D3 76 FD 66 00
 ioi altd ld h, (ix+0)          ; D3 76 FD 66 00
 ioi altd ld h, (ix+126)        ; D3 76 FD 66 7E
 ioi altd ld h, (ix-128)        ; D3 76 FD 66 80
 ioi altd ld h, (iy)            ; D3 76 DD 66 00
 ioi altd ld h, (iy+0)          ; D3 76 DD 66 00
 ioi altd ld h, (iy+126)        ; D3 76 DD 66 7E
 ioi altd ld h, (iy-128)        ; D3 76 DD 66 80
 ioi altd ld hl, (0x1234)       ; D3 76 2A 34 12
 ioi altd ld hl, (hl)           ; D3 76 DD E4 00
 ioi altd ld hl, (hl+0)         ; D3 76 DD E4 00
 ioi altd ld hl, (hl+126)       ; D3 76 DD E4 7E
 ioi altd ld hl, (hl-128)       ; D3 76 DD E4 80
 ioi altd ld hl, (ix)           ; D3 76 FD E4 00
 ioi altd ld hl, (ix+0)         ; D3 76 FD E4 00
 ioi altd ld hl, (ix+126)       ; D3 76 FD E4 7E
 ioi altd ld hl, (ix-128)       ; D3 76 FD E4 80
 ioi altd ld hl, (iy)           ; D3 76 E4 00
 ioi altd ld hl, (iy+0)         ; D3 76 E4 00
 ioi altd ld hl, (iy+126)       ; D3 76 E4 7E
 ioi altd ld hl, (iy-128)       ; D3 76 E4 80
 ioi altd ld l, (hl)            ; D3 76 6E
 ioi altd ld l, (ix)            ; D3 76 FD 6E 00
 ioi altd ld l, (ix+0)          ; D3 76 FD 6E 00
 ioi altd ld l, (ix+126)        ; D3 76 FD 6E 7E
 ioi altd ld l, (ix-128)        ; D3 76 FD 6E 80
 ioi altd ld l, (iy)            ; D3 76 DD 6E 00
 ioi altd ld l, (iy+0)          ; D3 76 DD 6E 00
 ioi altd ld l, (iy+126)        ; D3 76 DD 6E 7E
 ioi altd ld l, (iy-128)        ; D3 76 DD 6E 80
 ioi altd or (hl)               ; D3 76 B6
 ioi altd or (ix)               ; D3 76 FD B6 00
 ioi altd or (ix+0)             ; D3 76 FD B6 00
 ioi altd or (ix+126)           ; D3 76 FD B6 7E
 ioi altd or (ix-128)           ; D3 76 FD B6 80
 ioi altd or (iy)               ; D3 76 DD B6 00
 ioi altd or (iy+0)             ; D3 76 DD B6 00
 ioi altd or (iy+126)           ; D3 76 DD B6 7E
 ioi altd or (iy-128)           ; D3 76 DD B6 80
 ioi altd res 0, (hl)           ; D3 76 CB 86
 ioi altd res 0, (ix)           ; D3 76 FD CB 00 86
 ioi altd res 0, (ix+0)         ; D3 76 FD CB 00 86
 ioi altd res 0, (ix+126)       ; D3 76 FD CB 7E 86
 ioi altd res 0, (ix-128)       ; D3 76 FD CB 80 86
 ioi altd res 0, (iy)           ; D3 76 DD CB 00 86
 ioi altd res 0, (iy+0)         ; D3 76 DD CB 00 86
 ioi altd res 0, (iy+126)       ; D3 76 DD CB 7E 86
 ioi altd res 0, (iy-128)       ; D3 76 DD CB 80 86
 ioi altd res 1, (hl)           ; D3 76 CB 8E
 ioi altd res 1, (ix)           ; D3 76 FD CB 00 8E
 ioi altd res 1, (ix+0)         ; D3 76 FD CB 00 8E
 ioi altd res 1, (ix+126)       ; D3 76 FD CB 7E 8E
 ioi altd res 1, (ix-128)       ; D3 76 FD CB 80 8E
 ioi altd res 1, (iy)           ; D3 76 DD CB 00 8E
 ioi altd res 1, (iy+0)         ; D3 76 DD CB 00 8E
 ioi altd res 1, (iy+126)       ; D3 76 DD CB 7E 8E
 ioi altd res 1, (iy-128)       ; D3 76 DD CB 80 8E
 ioi altd res 2, (hl)           ; D3 76 CB 96
 ioi altd res 2, (ix)           ; D3 76 FD CB 00 96
 ioi altd res 2, (ix+0)         ; D3 76 FD CB 00 96
 ioi altd res 2, (ix+126)       ; D3 76 FD CB 7E 96
 ioi altd res 2, (ix-128)       ; D3 76 FD CB 80 96
 ioi altd res 2, (iy)           ; D3 76 DD CB 00 96
 ioi altd res 2, (iy+0)         ; D3 76 DD CB 00 96
 ioi altd res 2, (iy+126)       ; D3 76 DD CB 7E 96
 ioi altd res 2, (iy-128)       ; D3 76 DD CB 80 96
 ioi altd res 3, (hl)           ; D3 76 CB 9E
 ioi altd res 3, (ix)           ; D3 76 FD CB 00 9E
 ioi altd res 3, (ix+0)         ; D3 76 FD CB 00 9E
 ioi altd res 3, (ix+126)       ; D3 76 FD CB 7E 9E
 ioi altd res 3, (ix-128)       ; D3 76 FD CB 80 9E
 ioi altd res 3, (iy)           ; D3 76 DD CB 00 9E
 ioi altd res 3, (iy+0)         ; D3 76 DD CB 00 9E
 ioi altd res 3, (iy+126)       ; D3 76 DD CB 7E 9E
 ioi altd res 3, (iy-128)       ; D3 76 DD CB 80 9E
 ioi altd res 4, (hl)           ; D3 76 CB A6
 ioi altd res 4, (ix)           ; D3 76 FD CB 00 A6
 ioi altd res 4, (ix+0)         ; D3 76 FD CB 00 A6
 ioi altd res 4, (ix+126)       ; D3 76 FD CB 7E A6
 ioi altd res 4, (ix-128)       ; D3 76 FD CB 80 A6
 ioi altd res 4, (iy)           ; D3 76 DD CB 00 A6
 ioi altd res 4, (iy+0)         ; D3 76 DD CB 00 A6
 ioi altd res 4, (iy+126)       ; D3 76 DD CB 7E A6
 ioi altd res 4, (iy-128)       ; D3 76 DD CB 80 A6
 ioi altd res 5, (hl)           ; D3 76 CB AE
 ioi altd res 5, (ix)           ; D3 76 FD CB 00 AE
 ioi altd res 5, (ix+0)         ; D3 76 FD CB 00 AE
 ioi altd res 5, (ix+126)       ; D3 76 FD CB 7E AE
 ioi altd res 5, (ix-128)       ; D3 76 FD CB 80 AE
 ioi altd res 5, (iy)           ; D3 76 DD CB 00 AE
 ioi altd res 5, (iy+0)         ; D3 76 DD CB 00 AE
 ioi altd res 5, (iy+126)       ; D3 76 DD CB 7E AE
 ioi altd res 5, (iy-128)       ; D3 76 DD CB 80 AE
 ioi altd res 6, (hl)           ; D3 76 CB B6
 ioi altd res 6, (ix)           ; D3 76 FD CB 00 B6
 ioi altd res 6, (ix+0)         ; D3 76 FD CB 00 B6
 ioi altd res 6, (ix+126)       ; D3 76 FD CB 7E B6
 ioi altd res 6, (ix-128)       ; D3 76 FD CB 80 B6
 ioi altd res 6, (iy)           ; D3 76 DD CB 00 B6
 ioi altd res 6, (iy+0)         ; D3 76 DD CB 00 B6
 ioi altd res 6, (iy+126)       ; D3 76 DD CB 7E B6
 ioi altd res 6, (iy-128)       ; D3 76 DD CB 80 B6
 ioi altd res 7, (hl)           ; D3 76 CB BE
 ioi altd res 7, (ix)           ; D3 76 FD CB 00 BE
 ioi altd res 7, (ix+0)         ; D3 76 FD CB 00 BE
 ioi altd res 7, (ix+126)       ; D3 76 FD CB 7E BE
 ioi altd res 7, (ix-128)       ; D3 76 FD CB 80 BE
 ioi altd res 7, (iy)           ; D3 76 DD CB 00 BE
 ioi altd res 7, (iy+0)         ; D3 76 DD CB 00 BE
 ioi altd res 7, (iy+126)       ; D3 76 DD CB 7E BE
 ioi altd res 7, (iy-128)       ; D3 76 DD CB 80 BE
 ioi altd rl (hl)               ; D3 76 CB 16
 ioi altd rl (ix)               ; D3 76 FD CB 00 16
 ioi altd rl (ix+0)             ; D3 76 FD CB 00 16
 ioi altd rl (ix+126)           ; D3 76 FD CB 7E 16
 ioi altd rl (ix-128)           ; D3 76 FD CB 80 16
 ioi altd rl (iy)               ; D3 76 DD CB 00 16
 ioi altd rl (iy+0)             ; D3 76 DD CB 00 16
 ioi altd rl (iy+126)           ; D3 76 DD CB 7E 16
 ioi altd rl (iy-128)           ; D3 76 DD CB 80 16
 ioi altd rlc (hl)              ; D3 76 CB 06
 ioi altd rlc (ix)              ; D3 76 FD CB 00 06
 ioi altd rlc (ix+0)            ; D3 76 FD CB 00 06
 ioi altd rlc (ix+126)          ; D3 76 FD CB 7E 06
 ioi altd rlc (ix-128)          ; D3 76 FD CB 80 06
 ioi altd rlc (iy)              ; D3 76 DD CB 00 06
 ioi altd rlc (iy+0)            ; D3 76 DD CB 00 06
 ioi altd rlc (iy+126)          ; D3 76 DD CB 7E 06
 ioi altd rlc (iy-128)          ; D3 76 DD CB 80 06
 ioi altd rr (hl)               ; D3 76 CB 1E
 ioi altd rr (ix)               ; D3 76 FD CB 00 1E
 ioi altd rr (ix+0)             ; D3 76 FD CB 00 1E
 ioi altd rr (ix+126)           ; D3 76 FD CB 7E 1E
 ioi altd rr (ix-128)           ; D3 76 FD CB 80 1E
 ioi altd rr (iy)               ; D3 76 DD CB 00 1E
 ioi altd rr (iy+0)             ; D3 76 DD CB 00 1E
 ioi altd rr (iy+126)           ; D3 76 DD CB 7E 1E
 ioi altd rr (iy-128)           ; D3 76 DD CB 80 1E
 ioi altd rrc (hl)              ; D3 76 CB 0E
 ioi altd rrc (ix)              ; D3 76 FD CB 00 0E
 ioi altd rrc (ix+0)            ; D3 76 FD CB 00 0E
 ioi altd rrc (ix+126)          ; D3 76 FD CB 7E 0E
 ioi altd rrc (ix-128)          ; D3 76 FD CB 80 0E
 ioi altd rrc (iy)              ; D3 76 DD CB 00 0E
 ioi altd rrc (iy+0)            ; D3 76 DD CB 00 0E
 ioi altd rrc (iy+126)          ; D3 76 DD CB 7E 0E
 ioi altd rrc (iy-128)          ; D3 76 DD CB 80 0E
 ioi altd sbc a, (hl)           ; D3 76 9E
 ioi altd sbc a, (ix)           ; D3 76 FD 9E 00
 ioi altd sbc a, (ix+0)         ; D3 76 FD 9E 00
 ioi altd sbc a, (ix+126)       ; D3 76 FD 9E 7E
 ioi altd sbc a, (ix-128)       ; D3 76 FD 9E 80
 ioi altd sbc a, (iy)           ; D3 76 DD 9E 00
 ioi altd sbc a, (iy+0)         ; D3 76 DD 9E 00
 ioi altd sbc a, (iy+126)       ; D3 76 DD 9E 7E
 ioi altd sbc a, (iy-128)       ; D3 76 DD 9E 80
 ioi altd set 0, (hl)           ; D3 76 CB C6
 ioi altd set 0, (ix)           ; D3 76 FD CB 00 C6
 ioi altd set 0, (ix+0)         ; D3 76 FD CB 00 C6
 ioi altd set 0, (ix+126)       ; D3 76 FD CB 7E C6
 ioi altd set 0, (ix-128)       ; D3 76 FD CB 80 C6
 ioi altd set 0, (iy)           ; D3 76 DD CB 00 C6
 ioi altd set 0, (iy+0)         ; D3 76 DD CB 00 C6
 ioi altd set 0, (iy+126)       ; D3 76 DD CB 7E C6
 ioi altd set 0, (iy-128)       ; D3 76 DD CB 80 C6
 ioi altd set 1, (hl)           ; D3 76 CB CE
 ioi altd set 1, (ix)           ; D3 76 FD CB 00 CE
 ioi altd set 1, (ix+0)         ; D3 76 FD CB 00 CE
 ioi altd set 1, (ix+126)       ; D3 76 FD CB 7E CE
 ioi altd set 1, (ix-128)       ; D3 76 FD CB 80 CE
 ioi altd set 1, (iy)           ; D3 76 DD CB 00 CE
 ioi altd set 1, (iy+0)         ; D3 76 DD CB 00 CE
 ioi altd set 1, (iy+126)       ; D3 76 DD CB 7E CE
 ioi altd set 1, (iy-128)       ; D3 76 DD CB 80 CE
 ioi altd set 2, (hl)           ; D3 76 CB D6
 ioi altd set 2, (ix)           ; D3 76 FD CB 00 D6
 ioi altd set 2, (ix+0)         ; D3 76 FD CB 00 D6
 ioi altd set 2, (ix+126)       ; D3 76 FD CB 7E D6
 ioi altd set 2, (ix-128)       ; D3 76 FD CB 80 D6
 ioi altd set 2, (iy)           ; D3 76 DD CB 00 D6
 ioi altd set 2, (iy+0)         ; D3 76 DD CB 00 D6
 ioi altd set 2, (iy+126)       ; D3 76 DD CB 7E D6
 ioi altd set 2, (iy-128)       ; D3 76 DD CB 80 D6
 ioi altd set 3, (hl)           ; D3 76 CB DE
 ioi altd set 3, (ix)           ; D3 76 FD CB 00 DE
 ioi altd set 3, (ix+0)         ; D3 76 FD CB 00 DE
 ioi altd set 3, (ix+126)       ; D3 76 FD CB 7E DE
 ioi altd set 3, (ix-128)       ; D3 76 FD CB 80 DE
 ioi altd set 3, (iy)           ; D3 76 DD CB 00 DE
 ioi altd set 3, (iy+0)         ; D3 76 DD CB 00 DE
 ioi altd set 3, (iy+126)       ; D3 76 DD CB 7E DE
 ioi altd set 3, (iy-128)       ; D3 76 DD CB 80 DE
 ioi altd set 4, (hl)           ; D3 76 CB E6
 ioi altd set 4, (ix)           ; D3 76 FD CB 00 E6
 ioi altd set 4, (ix+0)         ; D3 76 FD CB 00 E6
 ioi altd set 4, (ix+126)       ; D3 76 FD CB 7E E6
 ioi altd set 4, (ix-128)       ; D3 76 FD CB 80 E6
 ioi altd set 4, (iy)           ; D3 76 DD CB 00 E6
 ioi altd set 4, (iy+0)         ; D3 76 DD CB 00 E6
 ioi altd set 4, (iy+126)       ; D3 76 DD CB 7E E6
 ioi altd set 4, (iy-128)       ; D3 76 DD CB 80 E6
 ioi altd set 5, (hl)           ; D3 76 CB EE
 ioi altd set 5, (ix)           ; D3 76 FD CB 00 EE
 ioi altd set 5, (ix+0)         ; D3 76 FD CB 00 EE
 ioi altd set 5, (ix+126)       ; D3 76 FD CB 7E EE
 ioi altd set 5, (ix-128)       ; D3 76 FD CB 80 EE
 ioi altd set 5, (iy)           ; D3 76 DD CB 00 EE
 ioi altd set 5, (iy+0)         ; D3 76 DD CB 00 EE
 ioi altd set 5, (iy+126)       ; D3 76 DD CB 7E EE
 ioi altd set 5, (iy-128)       ; D3 76 DD CB 80 EE
 ioi altd set 6, (hl)           ; D3 76 CB F6
 ioi altd set 6, (ix)           ; D3 76 FD CB 00 F6
 ioi altd set 6, (ix+0)         ; D3 76 FD CB 00 F6
 ioi altd set 6, (ix+126)       ; D3 76 FD CB 7E F6
 ioi altd set 6, (ix-128)       ; D3 76 FD CB 80 F6
 ioi altd set 6, (iy)           ; D3 76 DD CB 00 F6
 ioi altd set 6, (iy+0)         ; D3 76 DD CB 00 F6
 ioi altd set 6, (iy+126)       ; D3 76 DD CB 7E F6
 ioi altd set 6, (iy-128)       ; D3 76 DD CB 80 F6
 ioi altd set 7, (hl)           ; D3 76 CB FE
 ioi altd set 7, (ix)           ; D3 76 FD CB 00 FE
 ioi altd set 7, (ix+0)         ; D3 76 FD CB 00 FE
 ioi altd set 7, (ix+126)       ; D3 76 FD CB 7E FE
 ioi altd set 7, (ix-128)       ; D3 76 FD CB 80 FE
 ioi altd set 7, (iy)           ; D3 76 DD CB 00 FE
 ioi altd set 7, (iy+0)         ; D3 76 DD CB 00 FE
 ioi altd set 7, (iy+126)       ; D3 76 DD CB 7E FE
 ioi altd set 7, (iy-128)       ; D3 76 DD CB 80 FE
 ioi altd sla (hl)              ; D3 76 CB 26
 ioi altd sla (ix)              ; D3 76 FD CB 00 26
 ioi altd sla (ix+0)            ; D3 76 FD CB 00 26
 ioi altd sla (ix+126)          ; D3 76 FD CB 7E 26
 ioi altd sla (ix-128)          ; D3 76 FD CB 80 26
 ioi altd sla (iy)              ; D3 76 DD CB 00 26
 ioi altd sla (iy+0)            ; D3 76 DD CB 00 26
 ioi altd sla (iy+126)          ; D3 76 DD CB 7E 26
 ioi altd sla (iy-128)          ; D3 76 DD CB 80 26
 ioi altd sra (hl)              ; D3 76 CB 2E
 ioi altd sra (ix)              ; D3 76 FD CB 00 2E
 ioi altd sra (ix+0)            ; D3 76 FD CB 00 2E
 ioi altd sra (ix+126)          ; D3 76 FD CB 7E 2E
 ioi altd sra (ix-128)          ; D3 76 FD CB 80 2E
 ioi altd sra (iy)              ; D3 76 DD CB 00 2E
 ioi altd sra (iy+0)            ; D3 76 DD CB 00 2E
 ioi altd sra (iy+126)          ; D3 76 DD CB 7E 2E
 ioi altd sra (iy-128)          ; D3 76 DD CB 80 2E
 ioi altd srl (hl)              ; D3 76 CB 3E
 ioi altd srl (ix)              ; D3 76 FD CB 00 3E
 ioi altd srl (ix+0)            ; D3 76 FD CB 00 3E
 ioi altd srl (ix+126)          ; D3 76 FD CB 7E 3E
 ioi altd srl (ix-128)          ; D3 76 FD CB 80 3E
 ioi altd srl (iy)              ; D3 76 DD CB 00 3E
 ioi altd srl (iy+0)            ; D3 76 DD CB 00 3E
 ioi altd srl (iy+126)          ; D3 76 DD CB 7E 3E
 ioi altd srl (iy-128)          ; D3 76 DD CB 80 3E
 ioi altd sub (hl)              ; D3 76 96
 ioi altd sub (ix)              ; D3 76 FD 96 00
 ioi altd sub (ix+0)            ; D3 76 FD 96 00
 ioi altd sub (ix+126)          ; D3 76 FD 96 7E
 ioi altd sub (ix-128)          ; D3 76 FD 96 80
 ioi altd sub (iy)              ; D3 76 DD 96 00
 ioi altd sub (iy+0)            ; D3 76 DD 96 00
 ioi altd sub (iy+126)          ; D3 76 DD 96 7E
 ioi altd sub (iy-128)          ; D3 76 DD 96 80
 ioi altd xor (hl)              ; D3 76 AE
 ioi altd xor (ix)              ; D3 76 FD AE 00
 ioi altd xor (ix+0)            ; D3 76 FD AE 00
 ioi altd xor (ix+126)          ; D3 76 FD AE 7E
 ioi altd xor (ix-128)          ; D3 76 FD AE 80
 ioi altd xor (iy)              ; D3 76 DD AE 00
 ioi altd xor (iy+0)            ; D3 76 DD AE 00
 ioi altd xor (iy+126)          ; D3 76 DD AE 7E
 ioi altd xor (iy-128)          ; D3 76 DD AE 80
 ioi and (hl)                   ; D3 A6
 ioi and (ix)                   ; D3 FD A6 00
 ioi and (ix+0)                 ; D3 FD A6 00
 ioi and (ix+126)               ; D3 FD A6 7E
 ioi and (ix-128)               ; D3 FD A6 80
 ioi and (iy)                   ; D3 DD A6 00
 ioi and (iy+0)                 ; D3 DD A6 00
 ioi and (iy+126)               ; D3 DD A6 7E
 ioi and (iy-128)               ; D3 DD A6 80
 ioi bit 0, (hl)                ; D3 CB 46
 ioi bit 0, (ix)                ; D3 FD CB 00 46
 ioi bit 0, (ix+0)              ; D3 FD CB 00 46
 ioi bit 0, (ix+126)            ; D3 FD CB 7E 46
 ioi bit 0, (ix-128)            ; D3 FD CB 80 46
 ioi bit 0, (iy)                ; D3 DD CB 00 46
 ioi bit 0, (iy+0)              ; D3 DD CB 00 46
 ioi bit 0, (iy+126)            ; D3 DD CB 7E 46
 ioi bit 0, (iy-128)            ; D3 DD CB 80 46
 ioi bit 1, (hl)                ; D3 CB 4E
 ioi bit 1, (ix)                ; D3 FD CB 00 4E
 ioi bit 1, (ix+0)              ; D3 FD CB 00 4E
 ioi bit 1, (ix+126)            ; D3 FD CB 7E 4E
 ioi bit 1, (ix-128)            ; D3 FD CB 80 4E
 ioi bit 1, (iy)                ; D3 DD CB 00 4E
 ioi bit 1, (iy+0)              ; D3 DD CB 00 4E
 ioi bit 1, (iy+126)            ; D3 DD CB 7E 4E
 ioi bit 1, (iy-128)            ; D3 DD CB 80 4E
 ioi bit 2, (hl)                ; D3 CB 56
 ioi bit 2, (ix)                ; D3 FD CB 00 56
 ioi bit 2, (ix+0)              ; D3 FD CB 00 56
 ioi bit 2, (ix+126)            ; D3 FD CB 7E 56
 ioi bit 2, (ix-128)            ; D3 FD CB 80 56
 ioi bit 2, (iy)                ; D3 DD CB 00 56
 ioi bit 2, (iy+0)              ; D3 DD CB 00 56
 ioi bit 2, (iy+126)            ; D3 DD CB 7E 56
 ioi bit 2, (iy-128)            ; D3 DD CB 80 56
 ioi bit 3, (hl)                ; D3 CB 5E
 ioi bit 3, (ix)                ; D3 FD CB 00 5E
 ioi bit 3, (ix+0)              ; D3 FD CB 00 5E
 ioi bit 3, (ix+126)            ; D3 FD CB 7E 5E
 ioi bit 3, (ix-128)            ; D3 FD CB 80 5E
 ioi bit 3, (iy)                ; D3 DD CB 00 5E
 ioi bit 3, (iy+0)              ; D3 DD CB 00 5E
 ioi bit 3, (iy+126)            ; D3 DD CB 7E 5E
 ioi bit 3, (iy-128)            ; D3 DD CB 80 5E
 ioi bit 4, (hl)                ; D3 CB 66
 ioi bit 4, (ix)                ; D3 FD CB 00 66
 ioi bit 4, (ix+0)              ; D3 FD CB 00 66
 ioi bit 4, (ix+126)            ; D3 FD CB 7E 66
 ioi bit 4, (ix-128)            ; D3 FD CB 80 66
 ioi bit 4, (iy)                ; D3 DD CB 00 66
 ioi bit 4, (iy+0)              ; D3 DD CB 00 66
 ioi bit 4, (iy+126)            ; D3 DD CB 7E 66
 ioi bit 4, (iy-128)            ; D3 DD CB 80 66
 ioi bit 5, (hl)                ; D3 CB 6E
 ioi bit 5, (ix)                ; D3 FD CB 00 6E
 ioi bit 5, (ix+0)              ; D3 FD CB 00 6E
 ioi bit 5, (ix+126)            ; D3 FD CB 7E 6E
 ioi bit 5, (ix-128)            ; D3 FD CB 80 6E
 ioi bit 5, (iy)                ; D3 DD CB 00 6E
 ioi bit 5, (iy+0)              ; D3 DD CB 00 6E
 ioi bit 5, (iy+126)            ; D3 DD CB 7E 6E
 ioi bit 5, (iy-128)            ; D3 DD CB 80 6E
 ioi bit 6, (hl)                ; D3 CB 76
 ioi bit 6, (ix)                ; D3 FD CB 00 76
 ioi bit 6, (ix+0)              ; D3 FD CB 00 76
 ioi bit 6, (ix+126)            ; D3 FD CB 7E 76
 ioi bit 6, (ix-128)            ; D3 FD CB 80 76
 ioi bit 6, (iy)                ; D3 DD CB 00 76
 ioi bit 6, (iy+0)              ; D3 DD CB 00 76
 ioi bit 6, (iy+126)            ; D3 DD CB 7E 76
 ioi bit 6, (iy-128)            ; D3 DD CB 80 76
 ioi bit 7, (hl)                ; D3 CB 7E
 ioi bit 7, (ix)                ; D3 FD CB 00 7E
 ioi bit 7, (ix+0)              ; D3 FD CB 00 7E
 ioi bit 7, (ix+126)            ; D3 FD CB 7E 7E
 ioi bit 7, (ix-128)            ; D3 FD CB 80 7E
 ioi bit 7, (iy)                ; D3 DD CB 00 7E
 ioi bit 7, (iy+0)              ; D3 DD CB 00 7E
 ioi bit 7, (iy+126)            ; D3 DD CB 7E 7E
 ioi bit 7, (iy-128)            ; D3 DD CB 80 7E
 ioi cp (hl)                    ; D3 BE
 ioi cp (ix)                    ; D3 FD BE 00
 ioi cp (ix+0)                  ; D3 FD BE 00
 ioi cp (ix+126)                ; D3 FD BE 7E
 ioi cp (ix-128)                ; D3 FD BE 80
 ioi cp (iy)                    ; D3 DD BE 00
 ioi cp (iy+0)                  ; D3 DD BE 00
 ioi cp (iy+126)                ; D3 DD BE 7E
 ioi cp (iy-128)                ; D3 DD BE 80
 ioi dec (hl)                   ; D3 35
 ioi dec (ix)                   ; D3 FD 35 00
 ioi dec (ix+0)                 ; D3 FD 35 00
 ioi dec (ix+126)               ; D3 FD 35 7E
 ioi dec (ix-128)               ; D3 FD 35 80
 ioi dec (iy)                   ; D3 DD 35 00
 ioi dec (iy+0)                 ; D3 DD 35 00
 ioi dec (iy+126)               ; D3 DD 35 7E
 ioi dec (iy-128)               ; D3 DD 35 80
 ioi inc (hl)                   ; D3 34
 ioi inc (ix)                   ; D3 FD 34 00
 ioi inc (ix+0)                 ; D3 FD 34 00
 ioi inc (ix+126)               ; D3 FD 34 7E
 ioi inc (ix-128)               ; D3 FD 34 80
 ioi inc (iy)                   ; D3 DD 34 00
 ioi inc (iy+0)                 ; D3 DD 34 00
 ioi inc (iy+126)               ; D3 DD 34 7E
 ioi inc (iy-128)               ; D3 DD 34 80
 ioi ld (0x1234), a             ; D3 32 34 12
 ioi ld (0x1234), bc            ; D3 ED 43 34 12
 ioi ld (0x1234), de            ; D3 ED 53 34 12
 ioi ld (0x1234), hl            ; D3 22 34 12
 ioi ld (0x1234), ix            ; D3 FD 22 34 12
 ioi ld (0x1234), iy            ; D3 DD 22 34 12
 ioi ld (0x1234), sp            ; D3 ED 73 34 12
 ioi ld (bc), a                 ; D3 02
 ioi ld (de), a                 ; D3 12
 ioi ld (hl), 0                 ; D3 36 00
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
 ioi ld (hl+0), hl              ; D3 DD F4 00
 ioi ld (hl+126), hl            ; D3 DD F4 7E
 ioi ld (hl-128), hl            ; D3 DD F4 80
 ioi ld (ix), 0                 ; D3 FD 36 00 00
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
 ioi ld (ix+0), 0               ; D3 FD 36 00 00
 ioi ld (ix+0), 127             ; D3 FD 36 00 7F
 ioi ld (ix+0), 255             ; D3 FD 36 00 FF
 ioi ld (ix+0), a               ; D3 FD 77 00
 ioi ld (ix+0), b               ; D3 FD 70 00
 ioi ld (ix+0), c               ; D3 FD 71 00
 ioi ld (ix+0), d               ; D3 FD 72 00
 ioi ld (ix+0), e               ; D3 FD 73 00
 ioi ld (ix+0), h               ; D3 FD 74 00
 ioi ld (ix+0), hl              ; D3 FD F4 00
 ioi ld (ix+0), l               ; D3 FD 75 00
 ioi ld (ix+126), 0             ; D3 FD 36 7E 00
 ioi ld (ix+126), 127           ; D3 FD 36 7E 7F
 ioi ld (ix+126), 255           ; D3 FD 36 7E FF
 ioi ld (ix+126), a             ; D3 FD 77 7E
 ioi ld (ix+126), b             ; D3 FD 70 7E
 ioi ld (ix+126), c             ; D3 FD 71 7E
 ioi ld (ix+126), d             ; D3 FD 72 7E
 ioi ld (ix+126), e             ; D3 FD 73 7E
 ioi ld (ix+126), h             ; D3 FD 74 7E
 ioi ld (ix+126), hl            ; D3 FD F4 7E
 ioi ld (ix+126), l             ; D3 FD 75 7E
 ioi ld (ix-128), 0             ; D3 FD 36 80 00
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
 ioi ld (iy), 0                 ; D3 DD 36 00 00
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
 ioi ld (iy+0), 0               ; D3 DD 36 00 00
 ioi ld (iy+0), 127             ; D3 DD 36 00 7F
 ioi ld (iy+0), 255             ; D3 DD 36 00 FF
 ioi ld (iy+0), a               ; D3 DD 77 00
 ioi ld (iy+0), b               ; D3 DD 70 00
 ioi ld (iy+0), c               ; D3 DD 71 00
 ioi ld (iy+0), d               ; D3 DD 72 00
 ioi ld (iy+0), e               ; D3 DD 73 00
 ioi ld (iy+0), h               ; D3 DD 74 00
 ioi ld (iy+0), hl              ; D3 F4 00
 ioi ld (iy+0), l               ; D3 DD 75 00
 ioi ld (iy+126), 0             ; D3 DD 36 7E 00
 ioi ld (iy+126), 127           ; D3 DD 36 7E 7F
 ioi ld (iy+126), 255           ; D3 DD 36 7E FF
 ioi ld (iy+126), a             ; D3 DD 77 7E
 ioi ld (iy+126), b             ; D3 DD 70 7E
 ioi ld (iy+126), c             ; D3 DD 71 7E
 ioi ld (iy+126), d             ; D3 DD 72 7E
 ioi ld (iy+126), e             ; D3 DD 73 7E
 ioi ld (iy+126), h             ; D3 DD 74 7E
 ioi ld (iy+126), hl            ; D3 F4 7E
 ioi ld (iy+126), l             ; D3 DD 75 7E
 ioi ld (iy-128), 0             ; D3 DD 36 80 00
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
 ioi ld a', (0x1234)            ; D3 76 3A 34 12
 ioi ld a', (bc)                ; D3 76 0A
 ioi ld a', (de)                ; D3 76 1A
 ioi ld a', (hl)                ; D3 76 7E
 ioi ld a', (ix)                ; D3 76 FD 7E 00
 ioi ld a', (ix+0)              ; D3 76 FD 7E 00
 ioi ld a', (ix+126)            ; D3 76 FD 7E 7E
 ioi ld a', (ix-128)            ; D3 76 FD 7E 80
 ioi ld a', (iy)                ; D3 76 DD 7E 00
 ioi ld a', (iy+0)              ; D3 76 DD 7E 00
 ioi ld a', (iy+126)            ; D3 76 DD 7E 7E
 ioi ld a', (iy-128)            ; D3 76 DD 7E 80
 ioi ld a, (0x1234)             ; D3 3A 34 12
 ioi ld a, (bc)                 ; D3 0A
 ioi ld a, (de)                 ; D3 1A
 ioi ld a, (hl)                 ; D3 7E
 ioi ld a, (ix)                 ; D3 FD 7E 00
 ioi ld a, (ix+0)               ; D3 FD 7E 00
 ioi ld a, (ix+126)             ; D3 FD 7E 7E
 ioi ld a, (ix-128)             ; D3 FD 7E 80
 ioi ld a, (iy)                 ; D3 DD 7E 00
 ioi ld a, (iy+0)               ; D3 DD 7E 00
 ioi ld a, (iy+126)             ; D3 DD 7E 7E
 ioi ld a, (iy-128)             ; D3 DD 7E 80
 ioi ld b', (hl)                ; D3 76 46
 ioi ld b', (ix)                ; D3 76 FD 46 00
 ioi ld b', (ix+0)              ; D3 76 FD 46 00
 ioi ld b', (ix+126)            ; D3 76 FD 46 7E
 ioi ld b', (ix-128)            ; D3 76 FD 46 80
 ioi ld b', (iy)                ; D3 76 DD 46 00
 ioi ld b', (iy+0)              ; D3 76 DD 46 00
 ioi ld b', (iy+126)            ; D3 76 DD 46 7E
 ioi ld b', (iy-128)            ; D3 76 DD 46 80
 ioi ld b, (hl)                 ; D3 46
 ioi ld b, (ix)                 ; D3 FD 46 00
 ioi ld b, (ix+0)               ; D3 FD 46 00
 ioi ld b, (ix+126)             ; D3 FD 46 7E
 ioi ld b, (ix-128)             ; D3 FD 46 80
 ioi ld b, (iy)                 ; D3 DD 46 00
 ioi ld b, (iy+0)               ; D3 DD 46 00
 ioi ld b, (iy+126)             ; D3 DD 46 7E
 ioi ld b, (iy-128)             ; D3 DD 46 80
 ioi ld bc', (0x1234)           ; D3 76 ED 4B 34 12
 ioi ld bc, (0x1234)            ; D3 ED 4B 34 12
 ioi ld c', (hl)                ; D3 76 4E
 ioi ld c', (ix)                ; D3 76 FD 4E 00
 ioi ld c', (ix+0)              ; D3 76 FD 4E 00
 ioi ld c', (ix+126)            ; D3 76 FD 4E 7E
 ioi ld c', (ix-128)            ; D3 76 FD 4E 80
 ioi ld c', (iy)                ; D3 76 DD 4E 00
 ioi ld c', (iy+0)              ; D3 76 DD 4E 00
 ioi ld c', (iy+126)            ; D3 76 DD 4E 7E
 ioi ld c', (iy-128)            ; D3 76 DD 4E 80
 ioi ld c, (hl)                 ; D3 4E
 ioi ld c, (ix)                 ; D3 FD 4E 00
 ioi ld c, (ix+0)               ; D3 FD 4E 00
 ioi ld c, (ix+126)             ; D3 FD 4E 7E
 ioi ld c, (ix-128)             ; D3 FD 4E 80
 ioi ld c, (iy)                 ; D3 DD 4E 00
 ioi ld c, (iy+0)               ; D3 DD 4E 00
 ioi ld c, (iy+126)             ; D3 DD 4E 7E
 ioi ld c, (iy-128)             ; D3 DD 4E 80
 ioi ld d', (hl)                ; D3 76 56
 ioi ld d', (ix)                ; D3 76 FD 56 00
 ioi ld d', (ix+0)              ; D3 76 FD 56 00
 ioi ld d', (ix+126)            ; D3 76 FD 56 7E
 ioi ld d', (ix-128)            ; D3 76 FD 56 80
 ioi ld d', (iy)                ; D3 76 DD 56 00
 ioi ld d', (iy+0)              ; D3 76 DD 56 00
 ioi ld d', (iy+126)            ; D3 76 DD 56 7E
 ioi ld d', (iy-128)            ; D3 76 DD 56 80
 ioi ld d, (hl)                 ; D3 56
 ioi ld d, (ix)                 ; D3 FD 56 00
 ioi ld d, (ix+0)               ; D3 FD 56 00
 ioi ld d, (ix+126)             ; D3 FD 56 7E
 ioi ld d, (ix-128)             ; D3 FD 56 80
 ioi ld d, (iy)                 ; D3 DD 56 00
 ioi ld d, (iy+0)               ; D3 DD 56 00
 ioi ld d, (iy+126)             ; D3 DD 56 7E
 ioi ld d, (iy-128)             ; D3 DD 56 80
 ioi ld de', (0x1234)           ; D3 76 ED 5B 34 12
 ioi ld de, (0x1234)            ; D3 ED 5B 34 12
 ioi ld e', (hl)                ; D3 76 5E
 ioi ld e', (ix)                ; D3 76 FD 5E 00
 ioi ld e', (ix+0)              ; D3 76 FD 5E 00
 ioi ld e', (ix+126)            ; D3 76 FD 5E 7E
 ioi ld e', (ix-128)            ; D3 76 FD 5E 80
 ioi ld e', (iy)                ; D3 76 DD 5E 00
 ioi ld e', (iy+0)              ; D3 76 DD 5E 00
 ioi ld e', (iy+126)            ; D3 76 DD 5E 7E
 ioi ld e', (iy-128)            ; D3 76 DD 5E 80
 ioi ld e, (hl)                 ; D3 5E
 ioi ld e, (ix)                 ; D3 FD 5E 00
 ioi ld e, (ix+0)               ; D3 FD 5E 00
 ioi ld e, (ix+126)             ; D3 FD 5E 7E
 ioi ld e, (ix-128)             ; D3 FD 5E 80
 ioi ld e, (iy)                 ; D3 DD 5E 00
 ioi ld e, (iy+0)               ; D3 DD 5E 00
 ioi ld e, (iy+126)             ; D3 DD 5E 7E
 ioi ld e, (iy-128)             ; D3 DD 5E 80
 ioi ld h', (hl)                ; D3 76 66
 ioi ld h', (ix)                ; D3 76 FD 66 00
 ioi ld h', (ix+0)              ; D3 76 FD 66 00
 ioi ld h', (ix+126)            ; D3 76 FD 66 7E
 ioi ld h', (ix-128)            ; D3 76 FD 66 80
 ioi ld h', (iy)                ; D3 76 DD 66 00
 ioi ld h', (iy+0)              ; D3 76 DD 66 00
 ioi ld h', (iy+126)            ; D3 76 DD 66 7E
 ioi ld h', (iy-128)            ; D3 76 DD 66 80
 ioi ld h, (hl)                 ; D3 66
 ioi ld h, (ix)                 ; D3 FD 66 00
 ioi ld h, (ix+0)               ; D3 FD 66 00
 ioi ld h, (ix+126)             ; D3 FD 66 7E
 ioi ld h, (ix-128)             ; D3 FD 66 80
 ioi ld h, (iy)                 ; D3 DD 66 00
 ioi ld h, (iy+0)               ; D3 DD 66 00
 ioi ld h, (iy+126)             ; D3 DD 66 7E
 ioi ld h, (iy-128)             ; D3 DD 66 80
 ioi ld hl', (0x1234)           ; D3 76 2A 34 12
 ioi ld hl', (hl)               ; D3 76 DD E4 00
 ioi ld hl', (hl+0)             ; D3 76 DD E4 00
 ioi ld hl', (hl+126)           ; D3 76 DD E4 7E
 ioi ld hl', (hl-128)           ; D3 76 DD E4 80
 ioi ld hl', (ix)               ; D3 76 FD E4 00
 ioi ld hl', (ix+0)             ; D3 76 FD E4 00
 ioi ld hl', (ix+126)           ; D3 76 FD E4 7E
 ioi ld hl', (ix-128)           ; D3 76 FD E4 80
 ioi ld hl', (iy)               ; D3 76 E4 00
 ioi ld hl', (iy+0)             ; D3 76 E4 00
 ioi ld hl', (iy+126)           ; D3 76 E4 7E
 ioi ld hl', (iy-128)           ; D3 76 E4 80
 ioi ld hl, (0x1234)            ; D3 2A 34 12
 ioi ld hl, (hl)                ; D3 DD E4 00
 ioi ld hl, (hl+0)              ; D3 DD E4 00
 ioi ld hl, (hl+126)            ; D3 DD E4 7E
 ioi ld hl, (hl-128)            ; D3 DD E4 80
 ioi ld hl, (ix)                ; D3 FD E4 00
 ioi ld hl, (ix+0)              ; D3 FD E4 00
 ioi ld hl, (ix+126)            ; D3 FD E4 7E
 ioi ld hl, (ix-128)            ; D3 FD E4 80
 ioi ld hl, (iy)                ; D3 E4 00
 ioi ld hl, (iy+0)              ; D3 E4 00
 ioi ld hl, (iy+126)            ; D3 E4 7E
 ioi ld hl, (iy-128)            ; D3 E4 80
 ioi ld ix, (0x1234)            ; D3 FD 2A 34 12
 ioi ld iy, (0x1234)            ; D3 DD 2A 34 12
 ioi ld l', (hl)                ; D3 76 6E
 ioi ld l', (ix)                ; D3 76 FD 6E 00
 ioi ld l', (ix+0)              ; D3 76 FD 6E 00
 ioi ld l', (ix+126)            ; D3 76 FD 6E 7E
 ioi ld l', (ix-128)            ; D3 76 FD 6E 80
 ioi ld l', (iy)                ; D3 76 DD 6E 00
 ioi ld l', (iy+0)              ; D3 76 DD 6E 00
 ioi ld l', (iy+126)            ; D3 76 DD 6E 7E
 ioi ld l', (iy-128)            ; D3 76 DD 6E 80
 ioi ld l, (hl)                 ; D3 6E
 ioi ld l, (ix)                 ; D3 FD 6E 00
 ioi ld l, (ix+0)               ; D3 FD 6E 00
 ioi ld l, (ix+126)             ; D3 FD 6E 7E
 ioi ld l, (ix-128)             ; D3 FD 6E 80
 ioi ld l, (iy)                 ; D3 DD 6E 00
 ioi ld l, (iy+0)               ; D3 DD 6E 00
 ioi ld l, (iy+126)             ; D3 DD 6E 7E
 ioi ld l, (iy-128)             ; D3 DD 6E 80
 ioi ld sp, (0x1234)            ; D3 ED 7B 34 12
 ioi ldd                        ; D3 ED A8
 ioi lddr                       ; D3 ED B8
 ioi lddsr                      ; D3 ED 98
 ioi ldi                        ; D3 ED A0
 ioi ldir                       ; D3 ED B0
 ioi ldisr                      ; D3 ED 90
 ioi lsddr                      ; D3 ED D8
 ioi lsdr                       ; D3 ED F8
 ioi lsidr                      ; D3 ED D0
 ioi lsir                       ; D3 ED F0
 ioi or (hl)                    ; D3 B6
 ioi or (ix)                    ; D3 FD B6 00
 ioi or (ix+0)                  ; D3 FD B6 00
 ioi or (ix+126)                ; D3 FD B6 7E
 ioi or (ix-128)                ; D3 FD B6 80
 ioi or (iy)                    ; D3 DD B6 00
 ioi or (iy+0)                  ; D3 DD B6 00
 ioi or (iy+126)                ; D3 DD B6 7E
 ioi or (iy-128)                ; D3 DD B6 80
 ioi res 0, (hl)                ; D3 CB 86
 ioi res 0, (ix)                ; D3 FD CB 00 86
 ioi res 0, (ix+0)              ; D3 FD CB 00 86
 ioi res 0, (ix+126)            ; D3 FD CB 7E 86
 ioi res 0, (ix-128)            ; D3 FD CB 80 86
 ioi res 0, (iy)                ; D3 DD CB 00 86
 ioi res 0, (iy+0)              ; D3 DD CB 00 86
 ioi res 0, (iy+126)            ; D3 DD CB 7E 86
 ioi res 0, (iy-128)            ; D3 DD CB 80 86
 ioi res 1, (hl)                ; D3 CB 8E
 ioi res 1, (ix)                ; D3 FD CB 00 8E
 ioi res 1, (ix+0)              ; D3 FD CB 00 8E
 ioi res 1, (ix+126)            ; D3 FD CB 7E 8E
 ioi res 1, (ix-128)            ; D3 FD CB 80 8E
 ioi res 1, (iy)                ; D3 DD CB 00 8E
 ioi res 1, (iy+0)              ; D3 DD CB 00 8E
 ioi res 1, (iy+126)            ; D3 DD CB 7E 8E
 ioi res 1, (iy-128)            ; D3 DD CB 80 8E
 ioi res 2, (hl)                ; D3 CB 96
 ioi res 2, (ix)                ; D3 FD CB 00 96
 ioi res 2, (ix+0)              ; D3 FD CB 00 96
 ioi res 2, (ix+126)            ; D3 FD CB 7E 96
 ioi res 2, (ix-128)            ; D3 FD CB 80 96
 ioi res 2, (iy)                ; D3 DD CB 00 96
 ioi res 2, (iy+0)              ; D3 DD CB 00 96
 ioi res 2, (iy+126)            ; D3 DD CB 7E 96
 ioi res 2, (iy-128)            ; D3 DD CB 80 96
 ioi res 3, (hl)                ; D3 CB 9E
 ioi res 3, (ix)                ; D3 FD CB 00 9E
 ioi res 3, (ix+0)              ; D3 FD CB 00 9E
 ioi res 3, (ix+126)            ; D3 FD CB 7E 9E
 ioi res 3, (ix-128)            ; D3 FD CB 80 9E
 ioi res 3, (iy)                ; D3 DD CB 00 9E
 ioi res 3, (iy+0)              ; D3 DD CB 00 9E
 ioi res 3, (iy+126)            ; D3 DD CB 7E 9E
 ioi res 3, (iy-128)            ; D3 DD CB 80 9E
 ioi res 4, (hl)                ; D3 CB A6
 ioi res 4, (ix)                ; D3 FD CB 00 A6
 ioi res 4, (ix+0)              ; D3 FD CB 00 A6
 ioi res 4, (ix+126)            ; D3 FD CB 7E A6
 ioi res 4, (ix-128)            ; D3 FD CB 80 A6
 ioi res 4, (iy)                ; D3 DD CB 00 A6
 ioi res 4, (iy+0)              ; D3 DD CB 00 A6
 ioi res 4, (iy+126)            ; D3 DD CB 7E A6
 ioi res 4, (iy-128)            ; D3 DD CB 80 A6
 ioi res 5, (hl)                ; D3 CB AE
 ioi res 5, (ix)                ; D3 FD CB 00 AE
 ioi res 5, (ix+0)              ; D3 FD CB 00 AE
 ioi res 5, (ix+126)            ; D3 FD CB 7E AE
 ioi res 5, (ix-128)            ; D3 FD CB 80 AE
 ioi res 5, (iy)                ; D3 DD CB 00 AE
 ioi res 5, (iy+0)              ; D3 DD CB 00 AE
 ioi res 5, (iy+126)            ; D3 DD CB 7E AE
 ioi res 5, (iy-128)            ; D3 DD CB 80 AE
 ioi res 6, (hl)                ; D3 CB B6
 ioi res 6, (ix)                ; D3 FD CB 00 B6
 ioi res 6, (ix+0)              ; D3 FD CB 00 B6
 ioi res 6, (ix+126)            ; D3 FD CB 7E B6
 ioi res 6, (ix-128)            ; D3 FD CB 80 B6
 ioi res 6, (iy)                ; D3 DD CB 00 B6
 ioi res 6, (iy+0)              ; D3 DD CB 00 B6
 ioi res 6, (iy+126)            ; D3 DD CB 7E B6
 ioi res 6, (iy-128)            ; D3 DD CB 80 B6
 ioi res 7, (hl)                ; D3 CB BE
 ioi res 7, (ix)                ; D3 FD CB 00 BE
 ioi res 7, (ix+0)              ; D3 FD CB 00 BE
 ioi res 7, (ix+126)            ; D3 FD CB 7E BE
 ioi res 7, (ix-128)            ; D3 FD CB 80 BE
 ioi res 7, (iy)                ; D3 DD CB 00 BE
 ioi res 7, (iy+0)              ; D3 DD CB 00 BE
 ioi res 7, (iy+126)            ; D3 DD CB 7E BE
 ioi res 7, (iy-128)            ; D3 DD CB 80 BE
 ioi rl (hl)                    ; D3 CB 16
 ioi rl (ix)                    ; D3 FD CB 00 16
 ioi rl (ix+0)                  ; D3 FD CB 00 16
 ioi rl (ix+126)                ; D3 FD CB 7E 16
 ioi rl (ix-128)                ; D3 FD CB 80 16
 ioi rl (iy)                    ; D3 DD CB 00 16
 ioi rl (iy+0)                  ; D3 DD CB 00 16
 ioi rl (iy+126)                ; D3 DD CB 7E 16
 ioi rl (iy-128)                ; D3 DD CB 80 16
 ioi rlc (hl)                   ; D3 CB 06
 ioi rlc (ix)                   ; D3 FD CB 00 06
 ioi rlc (ix+0)                 ; D3 FD CB 00 06
 ioi rlc (ix+126)               ; D3 FD CB 7E 06
 ioi rlc (ix-128)               ; D3 FD CB 80 06
 ioi rlc (iy)                   ; D3 DD CB 00 06
 ioi rlc (iy+0)                 ; D3 DD CB 00 06
 ioi rlc (iy+126)               ; D3 DD CB 7E 06
 ioi rlc (iy-128)               ; D3 DD CB 80 06
 ioi rr (hl)                    ; D3 CB 1E
 ioi rr (ix)                    ; D3 FD CB 00 1E
 ioi rr (ix+0)                  ; D3 FD CB 00 1E
 ioi rr (ix+126)                ; D3 FD CB 7E 1E
 ioi rr (ix-128)                ; D3 FD CB 80 1E
 ioi rr (iy)                    ; D3 DD CB 00 1E
 ioi rr (iy+0)                  ; D3 DD CB 00 1E
 ioi rr (iy+126)                ; D3 DD CB 7E 1E
 ioi rr (iy-128)                ; D3 DD CB 80 1E
 ioi rrc (hl)                   ; D3 CB 0E
 ioi rrc (ix)                   ; D3 FD CB 00 0E
 ioi rrc (ix+0)                 ; D3 FD CB 00 0E
 ioi rrc (ix+126)               ; D3 FD CB 7E 0E
 ioi rrc (ix-128)               ; D3 FD CB 80 0E
 ioi rrc (iy)                   ; D3 DD CB 00 0E
 ioi rrc (iy+0)                 ; D3 DD CB 00 0E
 ioi rrc (iy+126)               ; D3 DD CB 7E 0E
 ioi rrc (iy-128)               ; D3 DD CB 80 0E
 ioi sbc a', (hl)               ; D3 76 9E
 ioi sbc a', (ix)               ; D3 76 FD 9E 00
 ioi sbc a', (ix+0)             ; D3 76 FD 9E 00
 ioi sbc a', (ix+126)           ; D3 76 FD 9E 7E
 ioi sbc a', (ix-128)           ; D3 76 FD 9E 80
 ioi sbc a', (iy)               ; D3 76 DD 9E 00
 ioi sbc a', (iy+0)             ; D3 76 DD 9E 00
 ioi sbc a', (iy+126)           ; D3 76 DD 9E 7E
 ioi sbc a', (iy-128)           ; D3 76 DD 9E 80
 ioi sbc a, (hl)                ; D3 9E
 ioi sbc a, (ix)                ; D3 FD 9E 00
 ioi sbc a, (ix+0)              ; D3 FD 9E 00
 ioi sbc a, (ix+126)            ; D3 FD 9E 7E
 ioi sbc a, (ix-128)            ; D3 FD 9E 80
 ioi sbc a, (iy)                ; D3 DD 9E 00
 ioi sbc a, (iy+0)              ; D3 DD 9E 00
 ioi sbc a, (iy+126)            ; D3 DD 9E 7E
 ioi sbc a, (iy-128)            ; D3 DD 9E 80
 ioi set 0, (hl)                ; D3 CB C6
 ioi set 0, (ix)                ; D3 FD CB 00 C6
 ioi set 0, (ix+0)              ; D3 FD CB 00 C6
 ioi set 0, (ix+126)            ; D3 FD CB 7E C6
 ioi set 0, (ix-128)            ; D3 FD CB 80 C6
 ioi set 0, (iy)                ; D3 DD CB 00 C6
 ioi set 0, (iy+0)              ; D3 DD CB 00 C6
 ioi set 0, (iy+126)            ; D3 DD CB 7E C6
 ioi set 0, (iy-128)            ; D3 DD CB 80 C6
 ioi set 1, (hl)                ; D3 CB CE
 ioi set 1, (ix)                ; D3 FD CB 00 CE
 ioi set 1, (ix+0)              ; D3 FD CB 00 CE
 ioi set 1, (ix+126)            ; D3 FD CB 7E CE
 ioi set 1, (ix-128)            ; D3 FD CB 80 CE
 ioi set 1, (iy)                ; D3 DD CB 00 CE
 ioi set 1, (iy+0)              ; D3 DD CB 00 CE
 ioi set 1, (iy+126)            ; D3 DD CB 7E CE
 ioi set 1, (iy-128)            ; D3 DD CB 80 CE
 ioi set 2, (hl)                ; D3 CB D6
 ioi set 2, (ix)                ; D3 FD CB 00 D6
 ioi set 2, (ix+0)              ; D3 FD CB 00 D6
 ioi set 2, (ix+126)            ; D3 FD CB 7E D6
 ioi set 2, (ix-128)            ; D3 FD CB 80 D6
 ioi set 2, (iy)                ; D3 DD CB 00 D6
 ioi set 2, (iy+0)              ; D3 DD CB 00 D6
 ioi set 2, (iy+126)            ; D3 DD CB 7E D6
 ioi set 2, (iy-128)            ; D3 DD CB 80 D6
 ioi set 3, (hl)                ; D3 CB DE
 ioi set 3, (ix)                ; D3 FD CB 00 DE
 ioi set 3, (ix+0)              ; D3 FD CB 00 DE
 ioi set 3, (ix+126)            ; D3 FD CB 7E DE
 ioi set 3, (ix-128)            ; D3 FD CB 80 DE
 ioi set 3, (iy)                ; D3 DD CB 00 DE
 ioi set 3, (iy+0)              ; D3 DD CB 00 DE
 ioi set 3, (iy+126)            ; D3 DD CB 7E DE
 ioi set 3, (iy-128)            ; D3 DD CB 80 DE
 ioi set 4, (hl)                ; D3 CB E6
 ioi set 4, (ix)                ; D3 FD CB 00 E6
 ioi set 4, (ix+0)              ; D3 FD CB 00 E6
 ioi set 4, (ix+126)            ; D3 FD CB 7E E6
 ioi set 4, (ix-128)            ; D3 FD CB 80 E6
 ioi set 4, (iy)                ; D3 DD CB 00 E6
 ioi set 4, (iy+0)              ; D3 DD CB 00 E6
 ioi set 4, (iy+126)            ; D3 DD CB 7E E6
 ioi set 4, (iy-128)            ; D3 DD CB 80 E6
 ioi set 5, (hl)                ; D3 CB EE
 ioi set 5, (ix)                ; D3 FD CB 00 EE
 ioi set 5, (ix+0)              ; D3 FD CB 00 EE
 ioi set 5, (ix+126)            ; D3 FD CB 7E EE
 ioi set 5, (ix-128)            ; D3 FD CB 80 EE
 ioi set 5, (iy)                ; D3 DD CB 00 EE
 ioi set 5, (iy+0)              ; D3 DD CB 00 EE
 ioi set 5, (iy+126)            ; D3 DD CB 7E EE
 ioi set 5, (iy-128)            ; D3 DD CB 80 EE
 ioi set 6, (hl)                ; D3 CB F6
 ioi set 6, (ix)                ; D3 FD CB 00 F6
 ioi set 6, (ix+0)              ; D3 FD CB 00 F6
 ioi set 6, (ix+126)            ; D3 FD CB 7E F6
 ioi set 6, (ix-128)            ; D3 FD CB 80 F6
 ioi set 6, (iy)                ; D3 DD CB 00 F6
 ioi set 6, (iy+0)              ; D3 DD CB 00 F6
 ioi set 6, (iy+126)            ; D3 DD CB 7E F6
 ioi set 6, (iy-128)            ; D3 DD CB 80 F6
 ioi set 7, (hl)                ; D3 CB FE
 ioi set 7, (ix)                ; D3 FD CB 00 FE
 ioi set 7, (ix+0)              ; D3 FD CB 00 FE
 ioi set 7, (ix+126)            ; D3 FD CB 7E FE
 ioi set 7, (ix-128)            ; D3 FD CB 80 FE
 ioi set 7, (iy)                ; D3 DD CB 00 FE
 ioi set 7, (iy+0)              ; D3 DD CB 00 FE
 ioi set 7, (iy+126)            ; D3 DD CB 7E FE
 ioi set 7, (iy-128)            ; D3 DD CB 80 FE
 ioi sla (hl)                   ; D3 CB 26
 ioi sla (ix)                   ; D3 FD CB 00 26
 ioi sla (ix+0)                 ; D3 FD CB 00 26
 ioi sla (ix+126)               ; D3 FD CB 7E 26
 ioi sla (ix-128)               ; D3 FD CB 80 26
 ioi sla (iy)                   ; D3 DD CB 00 26
 ioi sla (iy+0)                 ; D3 DD CB 00 26
 ioi sla (iy+126)               ; D3 DD CB 7E 26
 ioi sla (iy-128)               ; D3 DD CB 80 26
 ioi sra (hl)                   ; D3 CB 2E
 ioi sra (ix)                   ; D3 FD CB 00 2E
 ioi sra (ix+0)                 ; D3 FD CB 00 2E
 ioi sra (ix+126)               ; D3 FD CB 7E 2E
 ioi sra (ix-128)               ; D3 FD CB 80 2E
 ioi sra (iy)                   ; D3 DD CB 00 2E
 ioi sra (iy+0)                 ; D3 DD CB 00 2E
 ioi sra (iy+126)               ; D3 DD CB 7E 2E
 ioi sra (iy-128)               ; D3 DD CB 80 2E
 ioi srl (hl)                   ; D3 CB 3E
 ioi srl (ix)                   ; D3 FD CB 00 3E
 ioi srl (ix+0)                 ; D3 FD CB 00 3E
 ioi srl (ix+126)               ; D3 FD CB 7E 3E
 ioi srl (ix-128)               ; D3 FD CB 80 3E
 ioi srl (iy)                   ; D3 DD CB 00 3E
 ioi srl (iy+0)                 ; D3 DD CB 00 3E
 ioi srl (iy+126)               ; D3 DD CB 7E 3E
 ioi srl (iy-128)               ; D3 DD CB 80 3E
 ioi sub (hl)                   ; D3 96
 ioi sub (ix)                   ; D3 FD 96 00
 ioi sub (ix+0)                 ; D3 FD 96 00
 ioi sub (ix+126)               ; D3 FD 96 7E
 ioi sub (ix-128)               ; D3 FD 96 80
 ioi sub (iy)                   ; D3 DD 96 00
 ioi sub (iy+0)                 ; D3 DD 96 00
 ioi sub (iy+126)               ; D3 DD 96 7E
 ioi sub (iy-128)               ; D3 DD 96 80
 ioi xor (hl)                   ; D3 AE
 ioi xor (ix)                   ; D3 FD AE 00
 ioi xor (ix+0)                 ; D3 FD AE 00
 ioi xor (ix+126)               ; D3 FD AE 7E
 ioi xor (ix-128)               ; D3 FD AE 80
 ioi xor (iy)                   ; D3 DD AE 00
 ioi xor (iy+0)                 ; D3 DD AE 00
 ioi xor (iy+126)               ; D3 DD AE 7E
 ioi xor (iy-128)               ; D3 DD AE 80
 ip 0                           ; ED 46
 ip 1                           ; ED 56
 ip 2                           ; ED 4E
 ip 3                           ; ED 5E
 ipres                          ; ED 5D
 ipset 0                        ; ED 46
 ipset 1                        ; ED 56
 ipset 2                        ; ED 4E
 ipset 3                        ; ED 5E
 jp (hl)                        ; E9
 jp (ix)                        ; FD E9
 jp (iy)                        ; DD E9
 jp 0x1234                      ; C3 34 12
 jp c, 0x1234                   ; DA 34 12
 jp lo, 0x1234                  ; EA 34 12
 jp lz, 0x1234                  ; E2 34 12
 jp m, 0x1234                   ; FA 34 12
 jp nc, 0x1234                  ; D2 34 12
 jp nv, 0x1234                  ; E2 34 12
 jp nz, 0x1234                  ; C2 34 12
 jp p, 0x1234                   ; F2 34 12
 jp pe, 0x1234                  ; EA 34 12
 jp po, 0x1234                  ; E2 34 12
 jp v, 0x1234                   ; EA 34 12
 jp z, 0x1234                   ; CA 34 12
 jr ASMPC                       ; 18 FE
 jr c, ASMPC                    ; 38 FE
 jr nc, ASMPC                   ; 30 FE
 jr nz, ASMPC                   ; 20 FE
 jr z, ASMPC                    ; 28 FE
 lcall 0x56, 0x1234             ; CF 34 12 56
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
 ld (hl), hl                    ; DD F4 00
 ld (hl), l                     ; 75
 ld (hl+0), hl                  ; DD F4 00
 ld (hl+126), hl                ; DD F4 7E
 ld (hl-128), hl                ; DD F4 80
 ld (ix), 0                     ; FD 36 00 00
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
 ld (ix+0), 0                   ; FD 36 00 00
 ld (ix+0), 127                 ; FD 36 00 7F
 ld (ix+0), 255                 ; FD 36 00 FF
 ld (ix+0), a                   ; FD 77 00
 ld (ix+0), b                   ; FD 70 00
 ld (ix+0), c                   ; FD 71 00
 ld (ix+0), d                   ; FD 72 00
 ld (ix+0), e                   ; FD 73 00
 ld (ix+0), h                   ; FD 74 00
 ld (ix+0), hl                  ; FD F4 00
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
 ld (ix+126), hl                ; FD F4 7E
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
 ld (ix-128), hl                ; FD F4 80
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
 ld (iy), hl                    ; F4 00
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
 ld (iy+0), hl                  ; F4 00
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
 ld (iy+126), hl                ; F4 7E
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
 ld (iy-128), hl                ; F4 80
 ld (iy-128), l                 ; DD 75 80
 ld (sp), hl                    ; D4 00
 ld (sp), ix                    ; FD D4 00
 ld (sp), iy                    ; DD D4 00
 ld (sp+0), hl                  ; D4 00
 ld (sp+0), ix                  ; FD D4 00
 ld (sp+0), iy                  ; DD D4 00
 ld (sp+127), hl                ; D4 7F
 ld (sp+127), ix                ; FD D4 7F
 ld (sp+127), iy                ; DD D4 7F
 ld (sp+255), hl                ; D4 FF
 ld (sp+255), ix                ; FD D4 FF
 ld (sp+255), iy                ; DD D4 FF
 ld a', (0x1234)                ; 76 3A 34 12
 ld a', (bc)                    ; 76 0A
 ld a', (de)                    ; 76 1A
 ld a', (hl)                    ; 76 7E
 ld a', (ix)                    ; 76 FD 7E 00
 ld a', (ix+0)                  ; 76 FD 7E 00
 ld a', (ix+126)                ; 76 FD 7E 7E
 ld a', (ix-128)                ; 76 FD 7E 80
 ld a', (iy)                    ; 76 DD 7E 00
 ld a', (iy+0)                  ; 76 DD 7E 00
 ld a', (iy+126)                ; 76 DD 7E 7E
 ld a', (iy-128)                ; 76 DD 7E 80
 ld a', 0                       ; 76 3E 00
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
 ld a, eir                      ; ED 57
 ld a, h                        ; 7C
 ld a, iir                      ; ED 5F
 ld a, l                        ; 7D
 ld a, xpc                      ; ED 77
 ld b', (hl)                    ; 76 46
 ld b', (ix)                    ; 76 FD 46 00
 ld b', (ix+0)                  ; 76 FD 46 00
 ld b', (ix+126)                ; 76 FD 46 7E
 ld b', (ix-128)                ; 76 FD 46 80
 ld b', (iy)                    ; 76 DD 46 00
 ld b', (iy+0)                  ; 76 DD 46 00
 ld b', (iy+126)                ; 76 DD 46 7E
 ld b', (iy-128)                ; 76 DD 46 80
 ld b', 0                       ; 76 06 00
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
 ld b, l                        ; 45
 ld bc', (0x1234)               ; 76 ED 4B 34 12
 ld bc', 0x1234                 ; 76 01 34 12
 ld bc', bc                     ; ED 49
 ld bc', de                     ; ED 41
 ld bc, (0x1234)                ; ED 4B 34 12
 ld bc, 0x1234                  ; 01 34 12
 ld c', (hl)                    ; 76 4E
 ld c', (ix)                    ; 76 FD 4E 00
 ld c', (ix+0)                  ; 76 FD 4E 00
 ld c', (ix+126)                ; 76 FD 4E 7E
 ld c', (ix-128)                ; 76 FD 4E 80
 ld c', (iy)                    ; 76 DD 4E 00
 ld c', (iy+0)                  ; 76 DD 4E 00
 ld c', (iy+126)                ; 76 DD 4E 7E
 ld c', (iy-128)                ; 76 DD 4E 80
 ld c', 0                       ; 76 0E 00
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
 ld c, l                        ; 4D
 ld d', (hl)                    ; 76 56
 ld d', (ix)                    ; 76 FD 56 00
 ld d', (ix+0)                  ; 76 FD 56 00
 ld d', (ix+126)                ; 76 FD 56 7E
 ld d', (ix-128)                ; 76 FD 56 80
 ld d', (iy)                    ; 76 DD 56 00
 ld d', (iy+0)                  ; 76 DD 56 00
 ld d', (iy+126)                ; 76 DD 56 7E
 ld d', (iy-128)                ; 76 DD 56 80
 ld d', 0                       ; 76 16 00
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
 ld d, l                        ; 55
 ld de', (0x1234)               ; 76 ED 5B 34 12
 ld de', 0x1234                 ; 76 11 34 12
 ld de', bc                     ; ED 59
 ld de', de                     ; ED 51
 ld de, (0x1234)                ; ED 5B 34 12
 ld de, 0x1234                  ; 11 34 12
 ld e', (hl)                    ; 76 5E
 ld e', (ix)                    ; 76 FD 5E 00
 ld e', (ix+0)                  ; 76 FD 5E 00
 ld e', (ix+126)                ; 76 FD 5E 7E
 ld e', (ix-128)                ; 76 FD 5E 80
 ld e', (iy)                    ; 76 DD 5E 00
 ld e', (iy+0)                  ; 76 DD 5E 00
 ld e', (iy+126)                ; 76 DD 5E 7E
 ld e', (iy-128)                ; 76 DD 5E 80
 ld e', 0                       ; 76 1E 00
 ld e', 127                     ; 76 1E 7F
 ld e', 255                     ; 76 1E FF
 ld e', a                       ; 76 5F
 ld e', b                       ; 76 58
 ld e', c                       ; 76 59
 ld e', d                       ; 76 5A
 ld e', e                       ; 76 5B
 ld e', h                       ; 76 5C
 ld e', l                       ; 76 5D
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
 ld e, l                        ; 5D
 ld eir, a                      ; ED 47
 ld h', (hl)                    ; 76 66
 ld h', (ix)                    ; 76 FD 66 00
 ld h', (ix+0)                  ; 76 FD 66 00
 ld h', (ix+126)                ; 76 FD 66 7E
 ld h', (ix-128)                ; 76 FD 66 80
 ld h', (iy)                    ; 76 DD 66 00
 ld h', (iy+0)                  ; 76 DD 66 00
 ld h', (iy+126)                ; 76 DD 66 7E
 ld h', (iy-128)                ; 76 DD 66 80
 ld h', 0                       ; 76 26 00
 ld h', 127                     ; 76 26 7F
 ld h', 255                     ; 76 26 FF
 ld h', a                       ; 76 67
 ld h', b                       ; 76 60
 ld h', c                       ; 76 61
 ld h', d                       ; 76 62
 ld h', e                       ; 76 63
 ld h', h                       ; 76 64
 ld h', l                       ; 76 65
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
 ld hl', (0x1234)               ; 76 2A 34 12
 ld hl', (hl)                   ; 76 DD E4 00
 ld hl', (hl+0)                 ; 76 DD E4 00
 ld hl', (hl+126)               ; 76 DD E4 7E
 ld hl', (hl-128)               ; 76 DD E4 80
 ld hl', (ix)                   ; 76 FD E4 00
 ld hl', (ix+0)                 ; 76 FD E4 00
 ld hl', (ix+126)               ; 76 FD E4 7E
 ld hl', (ix-128)               ; 76 FD E4 80
 ld hl', (iy)                   ; 76 E4 00
 ld hl', (iy+0)                 ; 76 E4 00
 ld hl', (iy+126)               ; 76 E4 7E
 ld hl', (iy-128)               ; 76 E4 80
 ld hl', (sp)                   ; 76 C4 00
 ld hl', (sp+0)                 ; 76 C4 00
 ld hl', (sp+127)               ; 76 C4 7F
 ld hl', (sp+255)               ; 76 C4 FF
 ld hl', 0x1234                 ; 76 21 34 12
 ld hl', bc                     ; ED 69
 ld hl', de                     ; ED 61
 ld hl', ix                     ; 76 FD 7C
 ld hl', iy                     ; 76 DD 7C
 ld hl, (0x1234)                ; 2A 34 12
 ld hl, (hl)                    ; DD E4 00
 ld hl, (hl+0)                  ; DD E4 00
 ld hl, (hl+126)                ; DD E4 7E
 ld hl, (hl-128)                ; DD E4 80
 ld hl, (ix)                    ; FD E4 00
 ld hl, (ix+0)                  ; FD E4 00
 ld hl, (ix+126)                ; FD E4 7E
 ld hl, (ix-128)                ; FD E4 80
 ld hl, (iy)                    ; E4 00
 ld hl, (iy+0)                  ; E4 00
 ld hl, (iy+126)                ; E4 7E
 ld hl, (iy-128)                ; E4 80
 ld hl, (sp)                    ; C4 00
 ld hl, (sp+0)                  ; C4 00
 ld hl, (sp+127)                ; C4 7F
 ld hl, (sp+255)                ; C4 FF
 ld hl, 0x1234                  ; 21 34 12
 ld hl, ix                      ; FD 7C
 ld hl, iy                      ; DD 7C
 ld iir, a                      ; ED 4F
 ld ix, (0x1234)                ; FD 2A 34 12
 ld ix, (sp)                    ; FD C4 00
 ld ix, (sp+0)                  ; FD C4 00
 ld ix, (sp+127)                ; FD C4 7F
 ld ix, (sp+255)                ; FD C4 FF
 ld ix, 0x1234                  ; FD 21 34 12
 ld ix, hl                      ; FD 7D
 ld iy, (0x1234)                ; DD 2A 34 12
 ld iy, (sp)                    ; DD C4 00
 ld iy, (sp+0)                  ; DD C4 00
 ld iy, (sp+127)                ; DD C4 7F
 ld iy, (sp+255)                ; DD C4 FF
 ld iy, 0x1234                  ; DD 21 34 12
 ld iy, hl                      ; DD 7D
 ld l', (hl)                    ; 76 6E
 ld l', (ix)                    ; 76 FD 6E 00
 ld l', (ix+0)                  ; 76 FD 6E 00
 ld l', (ix+126)                ; 76 FD 6E 7E
 ld l', (ix-128)                ; 76 FD 6E 80
 ld l', (iy)                    ; 76 DD 6E 00
 ld l', (iy+0)                  ; 76 DD 6E 00
 ld l', (iy+126)                ; 76 DD 6E 7E
 ld l', (iy-128)                ; 76 DD 6E 80
 ld l', 0                       ; 76 2E 00
 ld l', 127                     ; 76 2E 7F
 ld l', 255                     ; 76 2E FF
 ld l', a                       ; 76 6F
 ld l', b                       ; 76 68
 ld l', c                       ; 76 69
 ld l', d                       ; 76 6A
 ld l', e                       ; 76 6B
 ld l', h                       ; 76 6C
 ld l', l                       ; 76 6D
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
 ld sp, (0x1234)                ; ED 7B 34 12
 ld sp, 0x1234                  ; 31 34 12
 ld sp, hl                      ; F9
 ld sp, ix                      ; FD F9
 ld sp, iy                      ; DD F9
 ld xpc, a                      ; ED 67
 ldd                            ; ED A8
 lddr                           ; ED B8
 lddsr                          ; ED 98
 ldi                            ; ED A0
 ldir                           ; ED B0
 ldisr                          ; ED 90
 ldp (0x1234), hl               ; ED 65 34 12
 ldp (0x1234), ix               ; FD 65 34 12
 ldp (0x1234), iy               ; DD 65 34 12
 ldp (hl), hl                   ; ED 64
 ldp (ix), hl                   ; FD 64
 ldp (iy), hl                   ; DD 64
 ldp hl, (0x1234)               ; ED 6D 34 12
 ldp hl, (hl)                   ; ED 6C
 ldp hl, (ix)                   ; FD 6C
 ldp hl, (iy)                   ; DD 6C
 ldp ix, (0x1234)               ; FD 6D 34 12
 ldp iy, (0x1234)               ; DD 6D 34 12
 ljp 0x56, 0x1234               ; C7 34 12 56
 lret                           ; ED 45
 lsddr                          ; ED D8
 lsdr                           ; ED F8
 lsidr                          ; ED D0
 lsir                           ; ED F0
 mul                            ; F7
 neg                            ; ED 44
 nop                            ; 00
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
 or a'                          ; 76 B7
 or b                           ; B0
 or b'                          ; 76 B0
 or c                           ; B1
 or c'                          ; 76 B1
 or d                           ; B2
 or d'                          ; 76 B2
 or e                           ; B3
 or e'                          ; 76 B3
 or h                           ; B4
 or h'                          ; 76 B4
 or hl', de                     ; 76 EC
 or hl, de                      ; EC
 or ix, de                      ; FD EC
 or iy, de                      ; DD EC
 or l                           ; B5
 or l'                          ; 76 B5
 pop af                         ; F1
 pop af'                        ; 76 F1
 pop bc                         ; C1
 pop bc'                        ; 76 C1
 pop de                         ; D1
 pop de'                        ; 76 D1
 pop hl                         ; E1
 pop hl'                        ; 76 E1
 pop ip                         ; ED 7E
 pop ix                         ; FD E1
 pop iy                         ; DD E1
 pop su                         ; ED 6E
 push af                        ; F5
 push bc                        ; C5
 push de                        ; D5
 push hl                        ; E5
 push ip                        ; ED 76
 push ix                        ; FD E5
 push iy                        ; DD E5
 push su                        ; ED 66
 rdmode                         ; ED 7F
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
 res 1, (ix)                    ; FD CB 00 8E
 res 1, (ix+0)                  ; FD CB 00 8E
 res 1, (ix+126)                ; FD CB 7E 8E
 res 1, (ix-128)                ; FD CB 80 8E
 res 1, (iy)                    ; DD CB 00 8E
 res 1, (iy+0)                  ; DD CB 00 8E
 res 1, (iy+126)                ; DD CB 7E 8E
 res 1, (iy-128)                ; DD CB 80 8E
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
 res 2, (ix)                    ; FD CB 00 96
 res 2, (ix+0)                  ; FD CB 00 96
 res 2, (ix+126)                ; FD CB 7E 96
 res 2, (ix-128)                ; FD CB 80 96
 res 2, (iy)                    ; DD CB 00 96
 res 2, (iy+0)                  ; DD CB 00 96
 res 2, (iy+126)                ; DD CB 7E 96
 res 2, (iy-128)                ; DD CB 80 96
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
 res 3, (ix)                    ; FD CB 00 9E
 res 3, (ix+0)                  ; FD CB 00 9E
 res 3, (ix+126)                ; FD CB 7E 9E
 res 3, (ix-128)                ; FD CB 80 9E
 res 3, (iy)                    ; DD CB 00 9E
 res 3, (iy+0)                  ; DD CB 00 9E
 res 3, (iy+126)                ; DD CB 7E 9E
 res 3, (iy-128)                ; DD CB 80 9E
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
 res 4, (ix)                    ; FD CB 00 A6
 res 4, (ix+0)                  ; FD CB 00 A6
 res 4, (ix+126)                ; FD CB 7E A6
 res 4, (ix-128)                ; FD CB 80 A6
 res 4, (iy)                    ; DD CB 00 A6
 res 4, (iy+0)                  ; DD CB 00 A6
 res 4, (iy+126)                ; DD CB 7E A6
 res 4, (iy-128)                ; DD CB 80 A6
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
 res 5, (ix)                    ; FD CB 00 AE
 res 5, (ix+0)                  ; FD CB 00 AE
 res 5, (ix+126)                ; FD CB 7E AE
 res 5, (ix-128)                ; FD CB 80 AE
 res 5, (iy)                    ; DD CB 00 AE
 res 5, (iy+0)                  ; DD CB 00 AE
 res 5, (iy+126)                ; DD CB 7E AE
 res 5, (iy-128)                ; DD CB 80 AE
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
 res 6, (ix)                    ; FD CB 00 B6
 res 6, (ix+0)                  ; FD CB 00 B6
 res 6, (ix+126)                ; FD CB 7E B6
 res 6, (ix-128)                ; FD CB 80 B6
 res 6, (iy)                    ; DD CB 00 B6
 res 6, (iy+0)                  ; DD CB 00 B6
 res 6, (iy+126)                ; DD CB 7E B6
 res 6, (iy-128)                ; DD CB 80 B6
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
 res 7, (ix)                    ; FD CB 00 BE
 res 7, (ix+0)                  ; FD CB 00 BE
 res 7, (ix+126)                ; FD CB 7E BE
 res 7, (ix-128)                ; FD CB 80 BE
 res 7, (iy)                    ; DD CB 00 BE
 res 7, (iy+0)                  ; DD CB 00 BE
 res 7, (iy+126)                ; DD CB 7E BE
 res 7, (iy-128)                ; DD CB 80 BE
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
 ret nz                         ; C0
 ret p                          ; F0
 ret pe                         ; E8
 ret po                         ; E0
 ret z                          ; C8
 reti                           ; ED 4D
 rl (hl)                        ; CB 16
 rl (ix)                        ; FD CB 00 16
 rl (ix+0)                      ; FD CB 00 16
 rl (ix+126)                    ; FD CB 7E 16
 rl (ix-128)                    ; FD CB 80 16
 rl (iy)                        ; DD CB 00 16
 rl (iy+0)                      ; DD CB 00 16
 rl (iy+126)                    ; DD CB 7E 16
 rl (iy-128)                    ; DD CB 80 16
 rl a                           ; CB 17
 rl a'                          ; 76 CB 17
 rl b                           ; CB 10
 rl b'                          ; 76 CB 10
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
 rl l                           ; CB 15
 rl l'                          ; 76 CB 15
 rla                            ; 17
 rla'                           ; 76 17
 rlc (hl)                       ; CB 06
 rlc (ix)                       ; FD CB 00 06
 rlc (ix+0)                     ; FD CB 00 06
 rlc (ix+126)                   ; FD CB 7E 06
 rlc (ix-128)                   ; FD CB 80 06
 rlc (iy)                       ; DD CB 00 06
 rlc (iy+0)                     ; DD CB 00 06
 rlc (iy+126)                   ; DD CB 7E 06
 rlc (iy-128)                   ; DD CB 80 06
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
 rr (hl)                        ; CB 1E
 rr (ix)                        ; FD CB 00 1E
 rr (ix+0)                      ; FD CB 00 1E
 rr (ix+126)                    ; FD CB 7E 1E
 rr (ix-128)                    ; FD CB 80 1E
 rr (iy)                        ; DD CB 00 1E
 rr (iy+0)                      ; DD CB 00 1E
 rr (iy+126)                    ; DD CB 7E 1E
 rr (iy-128)                    ; DD CB 80 1E
 rr a                           ; CB 1F
 rr a'                          ; 76 CB 1F
 rr b                           ; CB 18
 rr b'                          ; 76 CB 18
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
 rr ix                          ; FD FC
 rr iy                          ; DD FC
 rr l                           ; CB 1D
 rr l'                          ; 76 CB 1D
 rra                            ; 1F
 rra'                           ; 76 1F
 rrc (hl)                       ; CB 0E
 rrc (ix)                       ; FD CB 00 0E
 rrc (ix+0)                     ; FD CB 00 0E
 rrc (ix+126)                   ; FD CB 7E 0E
 rrc (ix-128)                   ; FD CB 80 0E
 rrc (iy)                       ; DD CB 00 0E
 rrc (iy+0)                     ; DD CB 00 0E
 rrc (iy+126)                   ; DD CB 7E 0E
 rrc (iy-128)                   ; DD CB 80 0E
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
 rst 16                         ; D7
 rst 24                         ; DF
 rst 32                         ; E7
 rst 40                         ; EF
 rst 56                         ; FF
 sbc a', (hl)                   ; 76 9E
 sbc a', (ix)                   ; 76 FD 9E 00
 sbc a', (ix+0)                 ; 76 FD 9E 00
 sbc a', (ix+126)               ; 76 FD 9E 7E
 sbc a', (ix-128)               ; 76 FD 9E 80
 sbc a', (iy)                   ; 76 DD 9E 00
 sbc a', (iy+0)                 ; 76 DD 9E 00
 sbc a', (iy+126)               ; 76 DD 9E 7E
 sbc a', (iy-128)               ; 76 DD 9E 80
 sbc a', 0                      ; 76 DE 00
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
 sbc a, l                       ; 9D
 sbc hl', bc                    ; 76 ED 42
 sbc hl', de                    ; 76 ED 52
 sbc hl', hl                    ; 76 ED 62
 sbc hl', sp                    ; 76 ED 72
 sbc hl, bc                     ; ED 42
 sbc hl, de                     ; ED 52
 sbc hl, hl                     ; ED 62
 sbc hl, sp                     ; ED 72
 scf                            ; 37
 scf'                           ; 76 37
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
 set 1, (ix)                    ; FD CB 00 CE
 set 1, (ix+0)                  ; FD CB 00 CE
 set 1, (ix+126)                ; FD CB 7E CE
 set 1, (ix-128)                ; FD CB 80 CE
 set 1, (iy)                    ; DD CB 00 CE
 set 1, (iy+0)                  ; DD CB 00 CE
 set 1, (iy+126)                ; DD CB 7E CE
 set 1, (iy-128)                ; DD CB 80 CE
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
 set 2, (ix)                    ; FD CB 00 D6
 set 2, (ix+0)                  ; FD CB 00 D6
 set 2, (ix+126)                ; FD CB 7E D6
 set 2, (ix-128)                ; FD CB 80 D6
 set 2, (iy)                    ; DD CB 00 D6
 set 2, (iy+0)                  ; DD CB 00 D6
 set 2, (iy+126)                ; DD CB 7E D6
 set 2, (iy-128)                ; DD CB 80 D6
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
 set 3, (ix)                    ; FD CB 00 DE
 set 3, (ix+0)                  ; FD CB 00 DE
 set 3, (ix+126)                ; FD CB 7E DE
 set 3, (ix-128)                ; FD CB 80 DE
 set 3, (iy)                    ; DD CB 00 DE
 set 3, (iy+0)                  ; DD CB 00 DE
 set 3, (iy+126)                ; DD CB 7E DE
 set 3, (iy-128)                ; DD CB 80 DE
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
 set 4, (ix)                    ; FD CB 00 E6
 set 4, (ix+0)                  ; FD CB 00 E6
 set 4, (ix+126)                ; FD CB 7E E6
 set 4, (ix-128)                ; FD CB 80 E6
 set 4, (iy)                    ; DD CB 00 E6
 set 4, (iy+0)                  ; DD CB 00 E6
 set 4, (iy+126)                ; DD CB 7E E6
 set 4, (iy-128)                ; DD CB 80 E6
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
 set 5, (ix)                    ; FD CB 00 EE
 set 5, (ix+0)                  ; FD CB 00 EE
 set 5, (ix+126)                ; FD CB 7E EE
 set 5, (ix-128)                ; FD CB 80 EE
 set 5, (iy)                    ; DD CB 00 EE
 set 5, (iy+0)                  ; DD CB 00 EE
 set 5, (iy+126)                ; DD CB 7E EE
 set 5, (iy-128)                ; DD CB 80 EE
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
 set 6, (ix)                    ; FD CB 00 F6
 set 6, (ix+0)                  ; FD CB 00 F6
 set 6, (ix+126)                ; FD CB 7E F6
 set 6, (ix-128)                ; FD CB 80 F6
 set 6, (iy)                    ; DD CB 00 F6
 set 6, (iy+0)                  ; DD CB 00 F6
 set 6, (iy+126)                ; DD CB 7E F6
 set 6, (iy-128)                ; DD CB 80 F6
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
 set 7, (ix)                    ; FD CB 00 FE
 set 7, (ix+0)                  ; FD CB 00 FE
 set 7, (ix+126)                ; FD CB 7E FE
 set 7, (ix-128)                ; FD CB 80 FE
 set 7, (iy)                    ; DD CB 00 FE
 set 7, (iy+0)                  ; DD CB 00 FE
 set 7, (iy+126)                ; DD CB 7E FE
 set 7, (iy-128)                ; DD CB 80 FE
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
 sla (hl)                       ; CB 26
 sla (ix)                       ; FD CB 00 26
 sla (ix+0)                     ; FD CB 00 26
 sla (ix+126)                   ; FD CB 7E 26
 sla (ix-128)                   ; FD CB 80 26
 sla (iy)                       ; DD CB 00 26
 sla (iy+0)                     ; DD CB 00 26
 sla (iy+126)                   ; DD CB 7E 26
 sla (iy-128)                   ; DD CB 80 26
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
 sra (hl)                       ; CB 2E
 sra (ix)                       ; FD CB 00 2E
 sra (ix+0)                     ; FD CB 00 2E
 sra (ix+126)                   ; FD CB 7E 2E
 sra (ix-128)                   ; FD CB 80 2E
 sra (iy)                       ; DD CB 00 2E
 sra (iy+0)                     ; DD CB 00 2E
 sra (iy+126)                   ; DD CB 7E 2E
 sra (iy-128)                   ; DD CB 80 2E
 sra a                          ; CB 2F
 sra a'                         ; 76 CB 2F
 sra b                          ; CB 28
 sra b'                         ; 76 CB 28
 sra c                          ; CB 29
 sra c'                         ; 76 CB 29
 sra d                          ; CB 2A
 sra d'                         ; 76 CB 2A
 sra e                          ; CB 2B
 sra e'                         ; 76 CB 2B
 sra h                          ; CB 2C
 sra h'                         ; 76 CB 2C
 sra l                          ; CB 2D
 sra l'                         ; 76 CB 2D
 srl (hl)                       ; CB 3E
 srl (ix)                       ; FD CB 00 3E
 srl (ix+0)                     ; FD CB 00 3E
 srl (ix+126)                   ; FD CB 7E 3E
 srl (ix-128)                   ; FD CB 80 3E
 srl (iy)                       ; DD CB 00 3E
 srl (iy+0)                     ; DD CB 00 3E
 srl (iy+126)                   ; DD CB 7E 3E
 srl (iy-128)                   ; DD CB 80 3E
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
 sub a'                         ; 76 97
 sub b                          ; 90
 sub b'                         ; 76 90
 sub c                          ; 91
 sub c'                         ; 76 91
 sub d                          ; 92
 sub d'                         ; 76 92
 sub e                          ; 93
 sub e'                         ; 76 93
 sub h                          ; 94
 sub h'                         ; 76 94
 sub l                          ; 95
 sub l'                         ; 76 95
 sures                          ; ED 7D
 syscall                        ; ED 75
 uma                            ; ED C0
 ums                            ; ED C8
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
 xor a'                         ; 76 AF
 xor b                          ; A8
 xor b'                         ; 76 A8
 xor c                          ; A9
 xor c'                         ; 76 A9
 xor d                          ; AA
 xor d'                         ; 76 AA
 xor e                          ; AB
 xor e'                         ; 76 AB
 xor h                          ; AC
 xor h'                         ; 76 AC
 xor l                          ; AD
 xor l'                         ; 76 AD
