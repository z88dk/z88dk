 adc a', (hl)                   ; 76 7F 8E
 adc a', (ix)                   ; 76 DD 8E 00
 adc a', (ix+0)                 ; 76 DD 8E 00
 adc a', (ix+126)               ; 76 DD 8E 7E
 adc a', (ix-128)               ; 76 DD 8E 80
 adc a', (iy)                   ; 76 FD 8E 00
 adc a', (iy+0)                 ; 76 FD 8E 00
 adc a', (iy+126)               ; 76 FD 8E 7E
 adc a', (iy-128)               ; 76 FD 8E 80
 adc a', 0                      ; 76 CE 00
 adc a', 127                    ; 76 CE 7F
 adc a', 255                    ; 76 CE FF
 adc a', a                      ; 76 7F 8F
 adc a', b                      ; 76 7F 88
 adc a', c                      ; 76 7F 89
 adc a', d                      ; 76 7F 8A
 adc a', e                      ; 76 7F 8B
 adc a', h                      ; 76 7F 8C
 adc a', l                      ; 76 7F 8D
 adc a, (hl)                    ; 7F 8E
 adc a, (ix)                    ; DD 8E 00
 adc a, (ix+0)                  ; DD 8E 00
 adc a, (ix+126)                ; DD 8E 7E
 adc a, (ix-128)                ; DD 8E 80
 adc a, (iy)                    ; FD 8E 00
 adc a, (iy+0)                  ; FD 8E 00
 adc a, (iy+126)                ; FD 8E 7E
 adc a, (iy-128)                ; FD 8E 80
 adc a, 0                       ; CE 00
 adc a, 127                     ; CE 7F
 adc a, 255                     ; CE FF
 adc a, a                       ; 7F 8F
 adc a, b                       ; 7F 88
 adc a, c                       ; 7F 89
 adc a, d                       ; 7F 8A
 adc a, e                       ; 7F 8B
 adc a, h                       ; 7F 8C
 adc a, l                       ; 7F 8D
 adc hl', bc                    ; 76 ED 4A
 adc hl', de                    ; 76 ED 5A
 adc hl', hl                    ; 76 ED 6A
 adc hl', sp                    ; 76 ED 7A
 adc hl, bc                     ; ED 4A
 adc hl, de                     ; ED 5A
 adc hl, hl                     ; ED 6A
 adc hl, sp                     ; ED 7A
 add a', (hl)                   ; 76 7F 86
 add a', (ix)                   ; 76 DD 86 00
 add a', (ix+0)                 ; 76 DD 86 00
 add a', (ix+126)               ; 76 DD 86 7E
 add a', (ix-128)               ; 76 DD 86 80
 add a', (iy)                   ; 76 FD 86 00
 add a', (iy+0)                 ; 76 FD 86 00
 add a', (iy+126)               ; 76 FD 86 7E
 add a', (iy-128)               ; 76 FD 86 80
 add a', 0                      ; 76 C6 00
 add a', 127                    ; 76 C6 7F
 add a', 255                    ; 76 C6 FF
 add a', a                      ; 76 7F 87
 add a', b                      ; 76 7F 80
 add a', c                      ; 76 7F 81
 add a', d                      ; 76 7F 82
 add a', e                      ; 76 7F 83
 add a', h                      ; 76 7F 84
 add a', l                      ; 76 7F 85
 add a, (hl)                    ; 7F 86
 add a, (ix)                    ; DD 86 00
 add a, (ix+0)                  ; DD 86 00
 add a, (ix+126)                ; DD 86 7E
 add a, (ix-128)                ; DD 86 80
 add a, (iy)                    ; FD 86 00
 add a, (iy+0)                  ; FD 86 00
 add a, (iy+126)                ; FD 86 7E
 add a, (iy-128)                ; FD 86 80
 add a, 0                       ; C6 00
 add a, 127                     ; C6 7F
 add a, 255                     ; C6 FF
 add a, a                       ; 7F 87
 add a, b                       ; 7F 80
 add a, c                       ; 7F 81
 add a, d                       ; 7F 82
 add a, e                       ; 7F 83
 add a, h                       ; 7F 84
 add a, l                       ; 7F 85
 add hl', bc                    ; 76 09
 add hl', de                    ; 76 19
 add hl', hl                    ; 76 29
 add hl', jk                    ; 76 65
 add hl', sp                    ; 76 39
 add hl, bc                     ; 09
 add hl, de                     ; 19
 add hl, hl                     ; 29
 add hl, jk                     ; 65
 add hl, sp                     ; 39
 add ix, bc                     ; DD 09
 add ix, de                     ; DD 19
 add ix, ix                     ; DD 29
 add ix, sp                     ; DD 39
 add iy, bc                     ; FD 09
 add iy, de                     ; FD 19
 add iy, iy                     ; FD 29
 add iy, sp                     ; FD 39
 add jkhl', bcde                ; 76 ED C6
 add jkhl, bcde                 ; ED C6
 add sp, -128                   ; 27 80
 add sp, 0                      ; 27 00
 add sp, 126                    ; 27 7E
 altd adc a, (hl)               ; 76 7F 8E
 altd adc a, (ix)               ; 76 DD 8E 00
 altd adc a, (ix+0)             ; 76 DD 8E 00
 altd adc a, (ix+126)           ; 76 DD 8E 7E
 altd adc a, (ix-128)           ; 76 DD 8E 80
 altd adc a, (iy)               ; 76 FD 8E 00
 altd adc a, (iy+0)             ; 76 FD 8E 00
 altd adc a, (iy+126)           ; 76 FD 8E 7E
 altd adc a, (iy-128)           ; 76 FD 8E 80
 altd adc a, 0                  ; 76 CE 00
 altd adc a, 127                ; 76 CE 7F
 altd adc a, 255                ; 76 CE FF
 altd adc a, a                  ; 76 7F 8F
 altd adc a, b                  ; 76 7F 88
 altd adc a, c                  ; 76 7F 89
 altd adc a, d                  ; 76 7F 8A
 altd adc a, e                  ; 76 7F 8B
 altd adc a, h                  ; 76 7F 8C
 altd adc a, l                  ; 76 7F 8D
 altd adc hl, bc                ; 76 ED 4A
 altd adc hl, de                ; 76 ED 5A
 altd adc hl, hl                ; 76 ED 6A
 altd adc hl, sp                ; 76 ED 7A
 altd add a, (hl)               ; 76 7F 86
 altd add a, (ix)               ; 76 DD 86 00
 altd add a, (ix+0)             ; 76 DD 86 00
 altd add a, (ix+126)           ; 76 DD 86 7E
 altd add a, (ix-128)           ; 76 DD 86 80
 altd add a, (iy)               ; 76 FD 86 00
 altd add a, (iy+0)             ; 76 FD 86 00
 altd add a, (iy+126)           ; 76 FD 86 7E
 altd add a, (iy-128)           ; 76 FD 86 80
 altd add a, 0                  ; 76 C6 00
 altd add a, 127                ; 76 C6 7F
 altd add a, 255                ; 76 C6 FF
 altd add a, a                  ; 76 7F 87
 altd add a, b                  ; 76 7F 80
 altd add a, c                  ; 76 7F 81
 altd add a, d                  ; 76 7F 82
 altd add a, e                  ; 76 7F 83
 altd add a, h                  ; 76 7F 84
 altd add a, l                  ; 76 7F 85
 altd add hl, bc                ; 76 09
 altd add hl, de                ; 76 19
 altd add hl, hl                ; 76 29
 altd add hl, jk                ; 76 65
 altd add hl, sp                ; 76 39
 altd add ix, bc                ; 76 DD 09
 altd add ix, de                ; 76 DD 19
 altd add ix, ix                ; 76 DD 29
 altd add ix, sp                ; 76 DD 39
 altd add iy, bc                ; 76 FD 09
 altd add iy, de                ; 76 FD 19
 altd add iy, iy                ; 76 FD 29
 altd add iy, sp                ; 76 FD 39
 altd add jkhl, bcde            ; 76 ED C6
 altd add sp, -128              ; 76 27 80
 altd add sp, 0                 ; 76 27 00
 altd add sp, 126               ; 76 27 7E
 altd and (hl)                  ; 76 7F A6
 altd and (ix)                  ; 76 DD A6 00
 altd and (ix+0)                ; 76 DD A6 00
 altd and (ix+126)              ; 76 DD A6 7E
 altd and (ix-128)              ; 76 DD A6 80
 altd and (iy)                  ; 76 FD A6 00
 altd and (iy+0)                ; 76 FD A6 00
 altd and (iy+126)              ; 76 FD A6 7E
 altd and (iy-128)              ; 76 FD A6 80
 altd and 0                     ; 76 E6 00
 altd and 127                   ; 76 E6 7F
 altd and 255                   ; 76 E6 FF
 altd and a                     ; 76 7F A7
 altd and b                     ; 76 7F A0
 altd and c                     ; 76 7F A1
 altd and d                     ; 76 7F A2
 altd and e                     ; 76 7F A3
 altd and h                     ; 76 7F A4
 altd and hl, de                ; 76 DC
 altd and ix, de                ; 76 DD DC
 altd and iy, de                ; 76 FD DC
 altd and jkhl, bcde            ; 76 ED E6
 altd and l                     ; 76 7F A5
 altd bit 0, (hl)               ; 76 CB 46
 altd bit 0, (ix)               ; 76 DD CB 00 46
 altd bit 0, (ix+0)             ; 76 DD CB 00 46
 altd bit 0, (ix+126)           ; 76 DD CB 7E 46
 altd bit 0, (ix-128)           ; 76 DD CB 80 46
 altd bit 0, (iy)               ; 76 FD CB 00 46
 altd bit 0, (iy+0)             ; 76 FD CB 00 46
 altd bit 0, (iy+126)           ; 76 FD CB 7E 46
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
 altd bit 1, (ix+0)             ; 76 DD CB 00 4E
 altd bit 1, (ix+126)           ; 76 DD CB 7E 4E
 altd bit 1, (ix-128)           ; 76 DD CB 80 4E
 altd bit 1, (iy)               ; 76 FD CB 00 4E
 altd bit 1, (iy+0)             ; 76 FD CB 00 4E
 altd bit 1, (iy+126)           ; 76 FD CB 7E 4E
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
 altd bit 2, (ix+0)             ; 76 DD CB 00 56
 altd bit 2, (ix+126)           ; 76 DD CB 7E 56
 altd bit 2, (ix-128)           ; 76 DD CB 80 56
 altd bit 2, (iy)               ; 76 FD CB 00 56
 altd bit 2, (iy+0)             ; 76 FD CB 00 56
 altd bit 2, (iy+126)           ; 76 FD CB 7E 56
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
 altd bit 3, (ix+0)             ; 76 DD CB 00 5E
 altd bit 3, (ix+126)           ; 76 DD CB 7E 5E
 altd bit 3, (ix-128)           ; 76 DD CB 80 5E
 altd bit 3, (iy)               ; 76 FD CB 00 5E
 altd bit 3, (iy+0)             ; 76 FD CB 00 5E
 altd bit 3, (iy+126)           ; 76 FD CB 7E 5E
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
 altd bit 4, (ix+0)             ; 76 DD CB 00 66
 altd bit 4, (ix+126)           ; 76 DD CB 7E 66
 altd bit 4, (ix-128)           ; 76 DD CB 80 66
 altd bit 4, (iy)               ; 76 FD CB 00 66
 altd bit 4, (iy+0)             ; 76 FD CB 00 66
 altd bit 4, (iy+126)           ; 76 FD CB 7E 66
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
 altd bit 5, (ix+0)             ; 76 DD CB 00 6E
 altd bit 5, (ix+126)           ; 76 DD CB 7E 6E
 altd bit 5, (ix-128)           ; 76 DD CB 80 6E
 altd bit 5, (iy)               ; 76 FD CB 00 6E
 altd bit 5, (iy+0)             ; 76 FD CB 00 6E
 altd bit 5, (iy+126)           ; 76 FD CB 7E 6E
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
 altd bit 6, (ix+0)             ; 76 DD CB 00 76
 altd bit 6, (ix+126)           ; 76 DD CB 7E 76
 altd bit 6, (ix-128)           ; 76 DD CB 80 76
 altd bit 6, (iy)               ; 76 FD CB 00 76
 altd bit 6, (iy+0)             ; 76 FD CB 00 76
 altd bit 6, (iy+126)           ; 76 FD CB 7E 76
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
 altd bit 7, (ix+0)             ; 76 DD CB 00 7E
 altd bit 7, (ix+126)           ; 76 DD CB 7E 7E
 altd bit 7, (ix-128)           ; 76 DD CB 80 7E
 altd bit 7, (iy)               ; 76 FD CB 00 7E
 altd bit 7, (iy+0)             ; 76 FD CB 00 7E
 altd bit 7, (iy+126)           ; 76 FD CB 7E 7E
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
 altd clr hl                    ; 76 BF
 altd cp (hl)                   ; 76 7F BE
 altd cp (ix)                   ; 76 DD BE 00
 altd cp (ix+0)                 ; 76 DD BE 00
 altd cp (ix+126)               ; 76 DD BE 7E
 altd cp (ix-128)               ; 76 DD BE 80
 altd cp (iy)                   ; 76 FD BE 00
 altd cp (iy+0)                 ; 76 FD BE 00
 altd cp (iy+126)               ; 76 FD BE 7E
 altd cp (iy-128)               ; 76 FD BE 80
 altd cp 0                      ; 76 FE 00
 altd cp 127                    ; 76 FE 7F
 altd cp 255                    ; 76 FE FF
 altd cp a                      ; 76 7F BF
 altd cp b                      ; 76 7F B8
 altd cp c                      ; 76 7F B9
 altd cp d                      ; 76 7F BA
 altd cp e                      ; 76 7F BB
 altd cp h                      ; 76 7F BC
 altd cp hl, -128               ; 76 48 80
 altd cp hl, 0                  ; 76 48 00
 altd cp hl, 126                ; 76 48 7E
 altd cp hl, de                 ; 76 ED 48
 altd cp jkhl, bcde             ; 76 ED 58
 altd cp l                      ; 76 7F BD
 altd cpl                       ; 76 2F
 altd cpl a                     ; 76 2F
 altd dec (hl)                  ; 76 35
 altd dec (ix)                  ; 76 DD 35 00
 altd dec (ix+0)                ; 76 DD 35 00
 altd dec (ix+126)              ; 76 DD 35 7E
 altd dec (ix-128)              ; 76 DD 35 80
 altd dec (iy)                  ; 76 FD 35 00
 altd dec (iy+0)                ; 76 FD 35 00
 altd dec (iy+126)              ; 76 FD 35 7E
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
 altd dec sp                    ; 76 3B
 altd djnz ASMPC                ; 76 10 FD
 altd djnz b, ASMPC             ; 76 10 FD
 altd dwjnz ASMPC               ; 76 ED 10 FC
 altd dwjnz bc, ASMPC           ; 76 ED 10 FC
 altd ex (sp), hl               ; 76 ED 54
 altd ex bc', hl                ; 76 ED 74
 altd ex bc, hl                 ; 76 B3
 altd ex de', hl                ; 76 E3
 altd ex de, hl                 ; 76 EB
 altd ex jk', hl                ; 76 ED 7C
 altd ex jk, hl                 ; 76 B9
 altd fsyscall                  ; 76 ED 55
 altd ibox a                    ; 76 ED 12
 altd inc (hl)                  ; 76 34
 altd inc (ix)                  ; 76 DD 34 00
 altd inc (ix+0)                ; 76 DD 34 00
 altd inc (ix+126)              ; 76 DD 34 7E
 altd inc (ix-128)              ; 76 DD 34 80
 altd inc (iy)                  ; 76 FD 34 00
 altd inc (iy+0)                ; 76 FD 34 00
 altd inc (iy+126)              ; 76 FD 34 7E
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
 altd inc sp                    ; 76 33
 altd ioe adc a, (hl)           ; 76 DB 7F 8E
 altd ioe adc a, (ix)           ; 76 DB DD 8E 00
 altd ioe adc a, (ix+0)         ; 76 DB DD 8E 00
 altd ioe adc a, (ix+126)       ; 76 DB DD 8E 7E
 altd ioe adc a, (ix-128)       ; 76 DB DD 8E 80
 altd ioe adc a, (iy)           ; 76 DB FD 8E 00
 altd ioe adc a, (iy+0)         ; 76 DB FD 8E 00
 altd ioe adc a, (iy+126)       ; 76 DB FD 8E 7E
 altd ioe adc a, (iy-128)       ; 76 DB FD 8E 80
 altd ioe add a, (hl)           ; 76 DB 7F 86
 altd ioe add a, (ix)           ; 76 DB DD 86 00
 altd ioe add a, (ix+0)         ; 76 DB DD 86 00
 altd ioe add a, (ix+126)       ; 76 DB DD 86 7E
 altd ioe add a, (ix-128)       ; 76 DB DD 86 80
 altd ioe add a, (iy)           ; 76 DB FD 86 00
 altd ioe add a, (iy+0)         ; 76 DB FD 86 00
 altd ioe add a, (iy+126)       ; 76 DB FD 86 7E
 altd ioe add a, (iy-128)       ; 76 DB FD 86 80
 altd ioe and (hl)              ; 76 DB 7F A6
 altd ioe and (ix)              ; 76 DB DD A6 00
 altd ioe and (ix+0)            ; 76 DB DD A6 00
 altd ioe and (ix+126)          ; 76 DB DD A6 7E
 altd ioe and (ix-128)          ; 76 DB DD A6 80
 altd ioe and (iy)              ; 76 DB FD A6 00
 altd ioe and (iy+0)            ; 76 DB FD A6 00
 altd ioe and (iy+126)          ; 76 DB FD A6 7E
 altd ioe and (iy-128)          ; 76 DB FD A6 80
 altd ioe bit 0, (hl)           ; 76 DB CB 46
 altd ioe bit 0, (ix)           ; 76 DB DD CB 00 46
 altd ioe bit 0, (ix+0)         ; 76 DB DD CB 00 46
 altd ioe bit 0, (ix+126)       ; 76 DB DD CB 7E 46
 altd ioe bit 0, (ix-128)       ; 76 DB DD CB 80 46
 altd ioe bit 0, (iy)           ; 76 DB FD CB 00 46
 altd ioe bit 0, (iy+0)         ; 76 DB FD CB 00 46
 altd ioe bit 0, (iy+126)       ; 76 DB FD CB 7E 46
 altd ioe bit 0, (iy-128)       ; 76 DB FD CB 80 46
 altd ioe bit 1, (hl)           ; 76 DB CB 4E
 altd ioe bit 1, (ix)           ; 76 DB DD CB 00 4E
 altd ioe bit 1, (ix+0)         ; 76 DB DD CB 00 4E
 altd ioe bit 1, (ix+126)       ; 76 DB DD CB 7E 4E
 altd ioe bit 1, (ix-128)       ; 76 DB DD CB 80 4E
 altd ioe bit 1, (iy)           ; 76 DB FD CB 00 4E
 altd ioe bit 1, (iy+0)         ; 76 DB FD CB 00 4E
 altd ioe bit 1, (iy+126)       ; 76 DB FD CB 7E 4E
 altd ioe bit 1, (iy-128)       ; 76 DB FD CB 80 4E
 altd ioe bit 2, (hl)           ; 76 DB CB 56
 altd ioe bit 2, (ix)           ; 76 DB DD CB 00 56
 altd ioe bit 2, (ix+0)         ; 76 DB DD CB 00 56
 altd ioe bit 2, (ix+126)       ; 76 DB DD CB 7E 56
 altd ioe bit 2, (ix-128)       ; 76 DB DD CB 80 56
 altd ioe bit 2, (iy)           ; 76 DB FD CB 00 56
 altd ioe bit 2, (iy+0)         ; 76 DB FD CB 00 56
 altd ioe bit 2, (iy+126)       ; 76 DB FD CB 7E 56
 altd ioe bit 2, (iy-128)       ; 76 DB FD CB 80 56
 altd ioe bit 3, (hl)           ; 76 DB CB 5E
 altd ioe bit 3, (ix)           ; 76 DB DD CB 00 5E
 altd ioe bit 3, (ix+0)         ; 76 DB DD CB 00 5E
 altd ioe bit 3, (ix+126)       ; 76 DB DD CB 7E 5E
 altd ioe bit 3, (ix-128)       ; 76 DB DD CB 80 5E
 altd ioe bit 3, (iy)           ; 76 DB FD CB 00 5E
 altd ioe bit 3, (iy+0)         ; 76 DB FD CB 00 5E
 altd ioe bit 3, (iy+126)       ; 76 DB FD CB 7E 5E
 altd ioe bit 3, (iy-128)       ; 76 DB FD CB 80 5E
 altd ioe bit 4, (hl)           ; 76 DB CB 66
 altd ioe bit 4, (ix)           ; 76 DB DD CB 00 66
 altd ioe bit 4, (ix+0)         ; 76 DB DD CB 00 66
 altd ioe bit 4, (ix+126)       ; 76 DB DD CB 7E 66
 altd ioe bit 4, (ix-128)       ; 76 DB DD CB 80 66
 altd ioe bit 4, (iy)           ; 76 DB FD CB 00 66
 altd ioe bit 4, (iy+0)         ; 76 DB FD CB 00 66
 altd ioe bit 4, (iy+126)       ; 76 DB FD CB 7E 66
 altd ioe bit 4, (iy-128)       ; 76 DB FD CB 80 66
 altd ioe bit 5, (hl)           ; 76 DB CB 6E
 altd ioe bit 5, (ix)           ; 76 DB DD CB 00 6E
 altd ioe bit 5, (ix+0)         ; 76 DB DD CB 00 6E
 altd ioe bit 5, (ix+126)       ; 76 DB DD CB 7E 6E
 altd ioe bit 5, (ix-128)       ; 76 DB DD CB 80 6E
 altd ioe bit 5, (iy)           ; 76 DB FD CB 00 6E
 altd ioe bit 5, (iy+0)         ; 76 DB FD CB 00 6E
 altd ioe bit 5, (iy+126)       ; 76 DB FD CB 7E 6E
 altd ioe bit 5, (iy-128)       ; 76 DB FD CB 80 6E
 altd ioe bit 6, (hl)           ; 76 DB CB 76
 altd ioe bit 6, (ix)           ; 76 DB DD CB 00 76
 altd ioe bit 6, (ix+0)         ; 76 DB DD CB 00 76
 altd ioe bit 6, (ix+126)       ; 76 DB DD CB 7E 76
 altd ioe bit 6, (ix-128)       ; 76 DB DD CB 80 76
 altd ioe bit 6, (iy)           ; 76 DB FD CB 00 76
 altd ioe bit 6, (iy+0)         ; 76 DB FD CB 00 76
 altd ioe bit 6, (iy+126)       ; 76 DB FD CB 7E 76
 altd ioe bit 6, (iy-128)       ; 76 DB FD CB 80 76
 altd ioe bit 7, (hl)           ; 76 DB CB 7E
 altd ioe bit 7, (ix)           ; 76 DB DD CB 00 7E
 altd ioe bit 7, (ix+0)         ; 76 DB DD CB 00 7E
 altd ioe bit 7, (ix+126)       ; 76 DB DD CB 7E 7E
 altd ioe bit 7, (ix-128)       ; 76 DB DD CB 80 7E
 altd ioe bit 7, (iy)           ; 76 DB FD CB 00 7E
 altd ioe bit 7, (iy+0)         ; 76 DB FD CB 00 7E
 altd ioe bit 7, (iy+126)       ; 76 DB FD CB 7E 7E
 altd ioe bit 7, (iy-128)       ; 76 DB FD CB 80 7E
 altd ioe cp (hl)               ; 76 DB 7F BE
 altd ioe cp (ix)               ; 76 DB DD BE 00
 altd ioe cp (ix+0)             ; 76 DB DD BE 00
 altd ioe cp (ix+126)           ; 76 DB DD BE 7E
 altd ioe cp (ix-128)           ; 76 DB DD BE 80
 altd ioe cp (iy)               ; 76 DB FD BE 00
 altd ioe cp (iy+0)             ; 76 DB FD BE 00
 altd ioe cp (iy+126)           ; 76 DB FD BE 7E
 altd ioe cp (iy-128)           ; 76 DB FD BE 80
 altd ioe dec (hl)              ; 76 DB 35
 altd ioe dec (ix)              ; 76 DB DD 35 00
 altd ioe dec (ix+0)            ; 76 DB DD 35 00
 altd ioe dec (ix+126)          ; 76 DB DD 35 7E
 altd ioe dec (ix-128)          ; 76 DB DD 35 80
 altd ioe dec (iy)              ; 76 DB FD 35 00
 altd ioe dec (iy+0)            ; 76 DB FD 35 00
 altd ioe dec (iy+126)          ; 76 DB FD 35 7E
 altd ioe dec (iy-128)          ; 76 DB FD 35 80
 altd ioe inc (hl)              ; 76 DB 34
 altd ioe inc (ix)              ; 76 DB DD 34 00
 altd ioe inc (ix+0)            ; 76 DB DD 34 00
 altd ioe inc (ix+126)          ; 76 DB DD 34 7E
 altd ioe inc (ix-128)          ; 76 DB DD 34 80
 altd ioe inc (iy)              ; 76 DB FD 34 00
 altd ioe inc (iy+0)            ; 76 DB FD 34 00
 altd ioe inc (iy+126)          ; 76 DB FD 34 7E
 altd ioe inc (iy-128)          ; 76 DB FD 34 80
 altd ioe ld a, (0x1234)        ; 76 DB 3A 34 12
 altd ioe ld a, (bc)            ; 76 DB 0A
 altd ioe ld a, (de)            ; 76 DB 1A
 altd ioe ld a, (hl)            ; 76 DB 7E
 altd ioe ld a, (ix)            ; 76 DB DD 7E 00
 altd ioe ld a, (ix+0)          ; 76 DB DD 7E 00
 altd ioe ld a, (ix+126)        ; 76 DB DD 7E 7E
 altd ioe ld a, (ix+a)          ; 76 DB DD 06
 altd ioe ld a, (ix-128)        ; 76 DB DD 7E 80
 altd ioe ld a, (iy)            ; 76 DB FD 7E 00
 altd ioe ld a, (iy+0)          ; 76 DB FD 7E 00
 altd ioe ld a, (iy+126)        ; 76 DB FD 7E 7E
 altd ioe ld a, (iy+a)          ; 76 DB FD 06
 altd ioe ld a, (iy-128)        ; 76 DB FD 7E 80
 altd ioe ld b, (hl)            ; 76 DB 46
 altd ioe ld b, (ix)            ; 76 DB DD 46 00
 altd ioe ld b, (ix+0)          ; 76 DB DD 46 00
 altd ioe ld b, (ix+126)        ; 76 DB DD 46 7E
 altd ioe ld b, (ix-128)        ; 76 DB DD 46 80
 altd ioe ld b, (iy)            ; 76 DB FD 46 00
 altd ioe ld b, (iy+0)          ; 76 DB FD 46 00
 altd ioe ld b, (iy+126)        ; 76 DB FD 46 7E
 altd ioe ld b, (iy-128)        ; 76 DB FD 46 80
 altd ioe ld bc, (0x1234)       ; 76 DB ED 4B 34 12
 altd ioe ld bcde, (0x1234)     ; 76 DB 93 34 12
 altd ioe ld bcde, (hl)         ; 76 DB DD 1A
 altd ioe ld bcde, (ix)         ; 76 DB DD CE 00
 altd ioe ld bcde, (ix+0)       ; 76 DB DD CE 00
 altd ioe ld bcde, (ix+126)     ; 76 DB DD CE 7E
 altd ioe ld bcde, (ix-128)     ; 76 DB DD CE 80
 altd ioe ld bcde, (iy)         ; 76 DB DD DE 00
 altd ioe ld bcde, (iy+0)       ; 76 DB DD DE 00
 altd ioe ld bcde, (iy+126)     ; 76 DB DD DE 7E
 altd ioe ld bcde, (iy-128)     ; 76 DB DD DE 80
 altd ioe ld c, (hl)            ; 76 DB 4E
 altd ioe ld c, (ix)            ; 76 DB DD 4E 00
 altd ioe ld c, (ix+0)          ; 76 DB DD 4E 00
 altd ioe ld c, (ix+126)        ; 76 DB DD 4E 7E
 altd ioe ld c, (ix-128)        ; 76 DB DD 4E 80
 altd ioe ld c, (iy)            ; 76 DB FD 4E 00
 altd ioe ld c, (iy+0)          ; 76 DB FD 4E 00
 altd ioe ld c, (iy+126)        ; 76 DB FD 4E 7E
 altd ioe ld c, (iy-128)        ; 76 DB FD 4E 80
 altd ioe ld d, (hl)            ; 76 DB 56
 altd ioe ld d, (ix)            ; 76 DB DD 56 00
 altd ioe ld d, (ix+0)          ; 76 DB DD 56 00
 altd ioe ld d, (ix+126)        ; 76 DB DD 56 7E
 altd ioe ld d, (ix-128)        ; 76 DB DD 56 80
 altd ioe ld d, (iy)            ; 76 DB FD 56 00
 altd ioe ld d, (iy+0)          ; 76 DB FD 56 00
 altd ioe ld d, (iy+126)        ; 76 DB FD 56 7E
 altd ioe ld d, (iy-128)        ; 76 DB FD 56 80
 altd ioe ld de, (0x1234)       ; 76 DB ED 5B 34 12
 altd ioe ld e, (hl)            ; 76 DB 5E
 altd ioe ld e, (ix)            ; 76 DB DD 5E 00
 altd ioe ld e, (ix+0)          ; 76 DB DD 5E 00
 altd ioe ld e, (ix+126)        ; 76 DB DD 5E 7E
 altd ioe ld e, (ix-128)        ; 76 DB DD 5E 80
 altd ioe ld e, (iy)            ; 76 DB FD 5E 00
 altd ioe ld e, (iy+0)          ; 76 DB FD 5E 00
 altd ioe ld e, (iy+126)        ; 76 DB FD 5E 7E
 altd ioe ld e, (iy-128)        ; 76 DB FD 5E 80
 altd ioe ld h, (hl)            ; 76 DB 66
 altd ioe ld h, (ix)            ; 76 DB DD 66 00
 altd ioe ld h, (ix+0)          ; 76 DB DD 66 00
 altd ioe ld h, (ix+126)        ; 76 DB DD 66 7E
 altd ioe ld h, (ix-128)        ; 76 DB DD 66 80
 altd ioe ld h, (iy)            ; 76 DB FD 66 00
 altd ioe ld h, (iy+0)          ; 76 DB FD 66 00
 altd ioe ld h, (iy+126)        ; 76 DB FD 66 7E
 altd ioe ld h, (iy-128)        ; 76 DB FD 66 80
 altd ioe ld hl, (0x1234)       ; 76 DB 2A 34 12
 altd ioe ld hl, (hl)           ; 76 DB DD E4 00
 altd ioe ld hl, (hl+0)         ; 76 DB DD E4 00
 altd ioe ld hl, (hl+126)       ; 76 DB DD E4 7E
 altd ioe ld hl, (hl-128)       ; 76 DB DD E4 80
 altd ioe ld hl, (ix)           ; 76 DB E4 00
 altd ioe ld hl, (ix+0)         ; 76 DB E4 00
 altd ioe ld hl, (ix+126)       ; 76 DB E4 7E
 altd ioe ld hl, (ix-128)       ; 76 DB E4 80
 altd ioe ld hl, (iy)           ; 76 DB FD E4 00
 altd ioe ld hl, (iy+0)         ; 76 DB FD E4 00
 altd ioe ld hl, (iy+126)       ; 76 DB FD E4 7E
 altd ioe ld hl, (iy-128)       ; 76 DB FD E4 80
 altd ioe ld jk, (0x1234)       ; 76 DB 99 34 12
 altd ioe ld jkhl, (0x1234)     ; 76 DB 94 34 12
 altd ioe ld jkhl, (hl)         ; 76 DB FD 1A
 altd ioe ld jkhl, (ix)         ; 76 DB FD CE 00
 altd ioe ld jkhl, (ix+0)       ; 76 DB FD CE 00
 altd ioe ld jkhl, (ix+126)     ; 76 DB FD CE 7E
 altd ioe ld jkhl, (ix-128)     ; 76 DB FD CE 80
 altd ioe ld jkhl, (iy)         ; 76 DB FD DE 00
 altd ioe ld jkhl, (iy+0)       ; 76 DB FD DE 00
 altd ioe ld jkhl, (iy+126)     ; 76 DB FD DE 7E
 altd ioe ld jkhl, (iy-128)     ; 76 DB FD DE 80
 altd ioe ld l, (hl)            ; 76 DB 6E
 altd ioe ld l, (ix)            ; 76 DB DD 6E 00
 altd ioe ld l, (ix+0)          ; 76 DB DD 6E 00
 altd ioe ld l, (ix+126)        ; 76 DB DD 6E 7E
 altd ioe ld l, (ix-128)        ; 76 DB DD 6E 80
 altd ioe ld l, (iy)            ; 76 DB FD 6E 00
 altd ioe ld l, (iy+0)          ; 76 DB FD 6E 00
 altd ioe ld l, (iy+126)        ; 76 DB FD 6E 7E
 altd ioe ld l, (iy-128)        ; 76 DB FD 6E 80
 altd ioe or (hl)               ; 76 DB 7F B6
 altd ioe or (ix)               ; 76 DB DD B6 00
 altd ioe or (ix+0)             ; 76 DB DD B6 00
 altd ioe or (ix+126)           ; 76 DB DD B6 7E
 altd ioe or (ix-128)           ; 76 DB DD B6 80
 altd ioe or (iy)               ; 76 DB FD B6 00
 altd ioe or (iy+0)             ; 76 DB FD B6 00
 altd ioe or (iy+126)           ; 76 DB FD B6 7E
 altd ioe or (iy-128)           ; 76 DB FD B6 80
 altd ioe res 0, (hl)           ; 76 DB CB 86
 altd ioe res 0, (ix)           ; 76 DB DD CB 00 86
 altd ioe res 0, (ix+0)         ; 76 DB DD CB 00 86
 altd ioe res 0, (ix+126)       ; 76 DB DD CB 7E 86
 altd ioe res 0, (ix-128)       ; 76 DB DD CB 80 86
 altd ioe res 0, (iy)           ; 76 DB FD CB 00 86
 altd ioe res 0, (iy+0)         ; 76 DB FD CB 00 86
 altd ioe res 0, (iy+126)       ; 76 DB FD CB 7E 86
 altd ioe res 0, (iy-128)       ; 76 DB FD CB 80 86
 altd ioe res 1, (hl)           ; 76 DB CB 8E
 altd ioe res 1, (ix)           ; 76 DB DD CB 00 8E
 altd ioe res 1, (ix+0)         ; 76 DB DD CB 00 8E
 altd ioe res 1, (ix+126)       ; 76 DB DD CB 7E 8E
 altd ioe res 1, (ix-128)       ; 76 DB DD CB 80 8E
 altd ioe res 1, (iy)           ; 76 DB FD CB 00 8E
 altd ioe res 1, (iy+0)         ; 76 DB FD CB 00 8E
 altd ioe res 1, (iy+126)       ; 76 DB FD CB 7E 8E
 altd ioe res 1, (iy-128)       ; 76 DB FD CB 80 8E
 altd ioe res 2, (hl)           ; 76 DB CB 96
 altd ioe res 2, (ix)           ; 76 DB DD CB 00 96
 altd ioe res 2, (ix+0)         ; 76 DB DD CB 00 96
 altd ioe res 2, (ix+126)       ; 76 DB DD CB 7E 96
 altd ioe res 2, (ix-128)       ; 76 DB DD CB 80 96
 altd ioe res 2, (iy)           ; 76 DB FD CB 00 96
 altd ioe res 2, (iy+0)         ; 76 DB FD CB 00 96
 altd ioe res 2, (iy+126)       ; 76 DB FD CB 7E 96
 altd ioe res 2, (iy-128)       ; 76 DB FD CB 80 96
 altd ioe res 3, (hl)           ; 76 DB CB 9E
 altd ioe res 3, (ix)           ; 76 DB DD CB 00 9E
 altd ioe res 3, (ix+0)         ; 76 DB DD CB 00 9E
 altd ioe res 3, (ix+126)       ; 76 DB DD CB 7E 9E
 altd ioe res 3, (ix-128)       ; 76 DB DD CB 80 9E
 altd ioe res 3, (iy)           ; 76 DB FD CB 00 9E
 altd ioe res 3, (iy+0)         ; 76 DB FD CB 00 9E
 altd ioe res 3, (iy+126)       ; 76 DB FD CB 7E 9E
 altd ioe res 3, (iy-128)       ; 76 DB FD CB 80 9E
 altd ioe res 4, (hl)           ; 76 DB CB A6
 altd ioe res 4, (ix)           ; 76 DB DD CB 00 A6
 altd ioe res 4, (ix+0)         ; 76 DB DD CB 00 A6
 altd ioe res 4, (ix+126)       ; 76 DB DD CB 7E A6
 altd ioe res 4, (ix-128)       ; 76 DB DD CB 80 A6
 altd ioe res 4, (iy)           ; 76 DB FD CB 00 A6
 altd ioe res 4, (iy+0)         ; 76 DB FD CB 00 A6
 altd ioe res 4, (iy+126)       ; 76 DB FD CB 7E A6
 altd ioe res 4, (iy-128)       ; 76 DB FD CB 80 A6
 altd ioe res 5, (hl)           ; 76 DB CB AE
 altd ioe res 5, (ix)           ; 76 DB DD CB 00 AE
 altd ioe res 5, (ix+0)         ; 76 DB DD CB 00 AE
 altd ioe res 5, (ix+126)       ; 76 DB DD CB 7E AE
 altd ioe res 5, (ix-128)       ; 76 DB DD CB 80 AE
 altd ioe res 5, (iy)           ; 76 DB FD CB 00 AE
 altd ioe res 5, (iy+0)         ; 76 DB FD CB 00 AE
 altd ioe res 5, (iy+126)       ; 76 DB FD CB 7E AE
 altd ioe res 5, (iy-128)       ; 76 DB FD CB 80 AE
 altd ioe res 6, (hl)           ; 76 DB CB B6
 altd ioe res 6, (ix)           ; 76 DB DD CB 00 B6
 altd ioe res 6, (ix+0)         ; 76 DB DD CB 00 B6
 altd ioe res 6, (ix+126)       ; 76 DB DD CB 7E B6
 altd ioe res 6, (ix-128)       ; 76 DB DD CB 80 B6
 altd ioe res 6, (iy)           ; 76 DB FD CB 00 B6
 altd ioe res 6, (iy+0)         ; 76 DB FD CB 00 B6
 altd ioe res 6, (iy+126)       ; 76 DB FD CB 7E B6
 altd ioe res 6, (iy-128)       ; 76 DB FD CB 80 B6
 altd ioe res 7, (hl)           ; 76 DB CB BE
 altd ioe res 7, (ix)           ; 76 DB DD CB 00 BE
 altd ioe res 7, (ix+0)         ; 76 DB DD CB 00 BE
 altd ioe res 7, (ix+126)       ; 76 DB DD CB 7E BE
 altd ioe res 7, (ix-128)       ; 76 DB DD CB 80 BE
 altd ioe res 7, (iy)           ; 76 DB FD CB 00 BE
 altd ioe res 7, (iy+0)         ; 76 DB FD CB 00 BE
 altd ioe res 7, (iy+126)       ; 76 DB FD CB 7E BE
 altd ioe res 7, (iy-128)       ; 76 DB FD CB 80 BE
 altd ioe rl (hl)               ; 76 DB CB 16
 altd ioe rl (ix)               ; 76 DB DD CB 00 16
 altd ioe rl (ix+0)             ; 76 DB DD CB 00 16
 altd ioe rl (ix+126)           ; 76 DB DD CB 7E 16
 altd ioe rl (ix-128)           ; 76 DB DD CB 80 16
 altd ioe rl (iy)               ; 76 DB FD CB 00 16
 altd ioe rl (iy+0)             ; 76 DB FD CB 00 16
 altd ioe rl (iy+126)           ; 76 DB FD CB 7E 16
 altd ioe rl (iy-128)           ; 76 DB FD CB 80 16
 altd ioe rlc (hl)              ; 76 DB CB 06
 altd ioe rlc (ix)              ; 76 DB DD CB 00 06
 altd ioe rlc (ix+0)            ; 76 DB DD CB 00 06
 altd ioe rlc (ix+126)          ; 76 DB DD CB 7E 06
 altd ioe rlc (ix-128)          ; 76 DB DD CB 80 06
 altd ioe rlc (iy)              ; 76 DB FD CB 00 06
 altd ioe rlc (iy+0)            ; 76 DB FD CB 00 06
 altd ioe rlc (iy+126)          ; 76 DB FD CB 7E 06
 altd ioe rlc (iy-128)          ; 76 DB FD CB 80 06
 altd ioe rr (hl)               ; 76 DB CB 1E
 altd ioe rr (ix)               ; 76 DB DD CB 00 1E
 altd ioe rr (ix+0)             ; 76 DB DD CB 00 1E
 altd ioe rr (ix+126)           ; 76 DB DD CB 7E 1E
 altd ioe rr (ix-128)           ; 76 DB DD CB 80 1E
 altd ioe rr (iy)               ; 76 DB FD CB 00 1E
 altd ioe rr (iy+0)             ; 76 DB FD CB 00 1E
 altd ioe rr (iy+126)           ; 76 DB FD CB 7E 1E
 altd ioe rr (iy-128)           ; 76 DB FD CB 80 1E
 altd ioe rrc (hl)              ; 76 DB CB 0E
 altd ioe rrc (ix)              ; 76 DB DD CB 00 0E
 altd ioe rrc (ix+0)            ; 76 DB DD CB 00 0E
 altd ioe rrc (ix+126)          ; 76 DB DD CB 7E 0E
 altd ioe rrc (ix-128)          ; 76 DB DD CB 80 0E
 altd ioe rrc (iy)              ; 76 DB FD CB 00 0E
 altd ioe rrc (iy+0)            ; 76 DB FD CB 00 0E
 altd ioe rrc (iy+126)          ; 76 DB FD CB 7E 0E
 altd ioe rrc (iy-128)          ; 76 DB FD CB 80 0E
 altd ioe sbc a, (hl)           ; 76 DB 7F 9E
 altd ioe sbc a, (ix)           ; 76 DB DD 9E 00
 altd ioe sbc a, (ix+0)         ; 76 DB DD 9E 00
 altd ioe sbc a, (ix+126)       ; 76 DB DD 9E 7E
 altd ioe sbc a, (ix-128)       ; 76 DB DD 9E 80
 altd ioe sbc a, (iy)           ; 76 DB FD 9E 00
 altd ioe sbc a, (iy+0)         ; 76 DB FD 9E 00
 altd ioe sbc a, (iy+126)       ; 76 DB FD 9E 7E
 altd ioe sbc a, (iy-128)       ; 76 DB FD 9E 80
 altd ioe set 0, (hl)           ; 76 DB CB C6
 altd ioe set 0, (ix)           ; 76 DB DD CB 00 C6
 altd ioe set 0, (ix+0)         ; 76 DB DD CB 00 C6
 altd ioe set 0, (ix+126)       ; 76 DB DD CB 7E C6
 altd ioe set 0, (ix-128)       ; 76 DB DD CB 80 C6
 altd ioe set 0, (iy)           ; 76 DB FD CB 00 C6
 altd ioe set 0, (iy+0)         ; 76 DB FD CB 00 C6
 altd ioe set 0, (iy+126)       ; 76 DB FD CB 7E C6
 altd ioe set 0, (iy-128)       ; 76 DB FD CB 80 C6
 altd ioe set 1, (hl)           ; 76 DB CB CE
 altd ioe set 1, (ix)           ; 76 DB DD CB 00 CE
 altd ioe set 1, (ix+0)         ; 76 DB DD CB 00 CE
 altd ioe set 1, (ix+126)       ; 76 DB DD CB 7E CE
 altd ioe set 1, (ix-128)       ; 76 DB DD CB 80 CE
 altd ioe set 1, (iy)           ; 76 DB FD CB 00 CE
 altd ioe set 1, (iy+0)         ; 76 DB FD CB 00 CE
 altd ioe set 1, (iy+126)       ; 76 DB FD CB 7E CE
 altd ioe set 1, (iy-128)       ; 76 DB FD CB 80 CE
 altd ioe set 2, (hl)           ; 76 DB CB D6
 altd ioe set 2, (ix)           ; 76 DB DD CB 00 D6
 altd ioe set 2, (ix+0)         ; 76 DB DD CB 00 D6
 altd ioe set 2, (ix+126)       ; 76 DB DD CB 7E D6
 altd ioe set 2, (ix-128)       ; 76 DB DD CB 80 D6
 altd ioe set 2, (iy)           ; 76 DB FD CB 00 D6
 altd ioe set 2, (iy+0)         ; 76 DB FD CB 00 D6
 altd ioe set 2, (iy+126)       ; 76 DB FD CB 7E D6
 altd ioe set 2, (iy-128)       ; 76 DB FD CB 80 D6
 altd ioe set 3, (hl)           ; 76 DB CB DE
 altd ioe set 3, (ix)           ; 76 DB DD CB 00 DE
 altd ioe set 3, (ix+0)         ; 76 DB DD CB 00 DE
 altd ioe set 3, (ix+126)       ; 76 DB DD CB 7E DE
 altd ioe set 3, (ix-128)       ; 76 DB DD CB 80 DE
 altd ioe set 3, (iy)           ; 76 DB FD CB 00 DE
 altd ioe set 3, (iy+0)         ; 76 DB FD CB 00 DE
 altd ioe set 3, (iy+126)       ; 76 DB FD CB 7E DE
 altd ioe set 3, (iy-128)       ; 76 DB FD CB 80 DE
 altd ioe set 4, (hl)           ; 76 DB CB E6
 altd ioe set 4, (ix)           ; 76 DB DD CB 00 E6
 altd ioe set 4, (ix+0)         ; 76 DB DD CB 00 E6
 altd ioe set 4, (ix+126)       ; 76 DB DD CB 7E E6
 altd ioe set 4, (ix-128)       ; 76 DB DD CB 80 E6
 altd ioe set 4, (iy)           ; 76 DB FD CB 00 E6
 altd ioe set 4, (iy+0)         ; 76 DB FD CB 00 E6
 altd ioe set 4, (iy+126)       ; 76 DB FD CB 7E E6
 altd ioe set 4, (iy-128)       ; 76 DB FD CB 80 E6
 altd ioe set 5, (hl)           ; 76 DB CB EE
 altd ioe set 5, (ix)           ; 76 DB DD CB 00 EE
 altd ioe set 5, (ix+0)         ; 76 DB DD CB 00 EE
 altd ioe set 5, (ix+126)       ; 76 DB DD CB 7E EE
 altd ioe set 5, (ix-128)       ; 76 DB DD CB 80 EE
 altd ioe set 5, (iy)           ; 76 DB FD CB 00 EE
 altd ioe set 5, (iy+0)         ; 76 DB FD CB 00 EE
 altd ioe set 5, (iy+126)       ; 76 DB FD CB 7E EE
 altd ioe set 5, (iy-128)       ; 76 DB FD CB 80 EE
 altd ioe set 6, (hl)           ; 76 DB CB F6
 altd ioe set 6, (ix)           ; 76 DB DD CB 00 F6
 altd ioe set 6, (ix+0)         ; 76 DB DD CB 00 F6
 altd ioe set 6, (ix+126)       ; 76 DB DD CB 7E F6
 altd ioe set 6, (ix-128)       ; 76 DB DD CB 80 F6
 altd ioe set 6, (iy)           ; 76 DB FD CB 00 F6
 altd ioe set 6, (iy+0)         ; 76 DB FD CB 00 F6
 altd ioe set 6, (iy+126)       ; 76 DB FD CB 7E F6
 altd ioe set 6, (iy-128)       ; 76 DB FD CB 80 F6
 altd ioe set 7, (hl)           ; 76 DB CB FE
 altd ioe set 7, (ix)           ; 76 DB DD CB 00 FE
 altd ioe set 7, (ix+0)         ; 76 DB DD CB 00 FE
 altd ioe set 7, (ix+126)       ; 76 DB DD CB 7E FE
 altd ioe set 7, (ix-128)       ; 76 DB DD CB 80 FE
 altd ioe set 7, (iy)           ; 76 DB FD CB 00 FE
 altd ioe set 7, (iy+0)         ; 76 DB FD CB 00 FE
 altd ioe set 7, (iy+126)       ; 76 DB FD CB 7E FE
 altd ioe set 7, (iy-128)       ; 76 DB FD CB 80 FE
 altd ioe sla (hl)              ; 76 DB CB 26
 altd ioe sla (ix)              ; 76 DB DD CB 00 26
 altd ioe sla (ix+0)            ; 76 DB DD CB 00 26
 altd ioe sla (ix+126)          ; 76 DB DD CB 7E 26
 altd ioe sla (ix-128)          ; 76 DB DD CB 80 26
 altd ioe sla (iy)              ; 76 DB FD CB 00 26
 altd ioe sla (iy+0)            ; 76 DB FD CB 00 26
 altd ioe sla (iy+126)          ; 76 DB FD CB 7E 26
 altd ioe sla (iy-128)          ; 76 DB FD CB 80 26
 altd ioe sra (hl)              ; 76 DB CB 2E
 altd ioe sra (ix)              ; 76 DB DD CB 00 2E
 altd ioe sra (ix+0)            ; 76 DB DD CB 00 2E
 altd ioe sra (ix+126)          ; 76 DB DD CB 7E 2E
 altd ioe sra (ix-128)          ; 76 DB DD CB 80 2E
 altd ioe sra (iy)              ; 76 DB FD CB 00 2E
 altd ioe sra (iy+0)            ; 76 DB FD CB 00 2E
 altd ioe sra (iy+126)          ; 76 DB FD CB 7E 2E
 altd ioe sra (iy-128)          ; 76 DB FD CB 80 2E
 altd ioe srl (hl)              ; 76 DB CB 3E
 altd ioe srl (ix)              ; 76 DB DD CB 00 3E
 altd ioe srl (ix+0)            ; 76 DB DD CB 00 3E
 altd ioe srl (ix+126)          ; 76 DB DD CB 7E 3E
 altd ioe srl (ix-128)          ; 76 DB DD CB 80 3E
 altd ioe srl (iy)              ; 76 DB FD CB 00 3E
 altd ioe srl (iy+0)            ; 76 DB FD CB 00 3E
 altd ioe srl (iy+126)          ; 76 DB FD CB 7E 3E
 altd ioe srl (iy-128)          ; 76 DB FD CB 80 3E
 altd ioe sub (hl)              ; 76 DB 7F 96
 altd ioe sub (ix)              ; 76 DB DD 96 00
 altd ioe sub (ix+0)            ; 76 DB DD 96 00
 altd ioe sub (ix+126)          ; 76 DB DD 96 7E
 altd ioe sub (ix-128)          ; 76 DB DD 96 80
 altd ioe sub (iy)              ; 76 DB FD 96 00
 altd ioe sub (iy+0)            ; 76 DB FD 96 00
 altd ioe sub (iy+126)          ; 76 DB FD 96 7E
 altd ioe sub (iy-128)          ; 76 DB FD 96 80
 altd ioe xor (hl)              ; 76 DB 7F AE
 altd ioe xor (ix)              ; 76 DB DD AE 00
 altd ioe xor (ix+0)            ; 76 DB DD AE 00
 altd ioe xor (ix+126)          ; 76 DB DD AE 7E
 altd ioe xor (ix-128)          ; 76 DB DD AE 80
 altd ioe xor (iy)              ; 76 DB FD AE 00
 altd ioe xor (iy+0)            ; 76 DB FD AE 00
 altd ioe xor (iy+126)          ; 76 DB FD AE 7E
 altd ioe xor (iy-128)          ; 76 DB FD AE 80
 altd ioi adc a, (hl)           ; 76 D3 7F 8E
 altd ioi adc a, (ix)           ; 76 D3 DD 8E 00
 altd ioi adc a, (ix+0)         ; 76 D3 DD 8E 00
 altd ioi adc a, (ix+126)       ; 76 D3 DD 8E 7E
 altd ioi adc a, (ix-128)       ; 76 D3 DD 8E 80
 altd ioi adc a, (iy)           ; 76 D3 FD 8E 00
 altd ioi adc a, (iy+0)         ; 76 D3 FD 8E 00
 altd ioi adc a, (iy+126)       ; 76 D3 FD 8E 7E
 altd ioi adc a, (iy-128)       ; 76 D3 FD 8E 80
 altd ioi add a, (hl)           ; 76 D3 7F 86
 altd ioi add a, (ix)           ; 76 D3 DD 86 00
 altd ioi add a, (ix+0)         ; 76 D3 DD 86 00
 altd ioi add a, (ix+126)       ; 76 D3 DD 86 7E
 altd ioi add a, (ix-128)       ; 76 D3 DD 86 80
 altd ioi add a, (iy)           ; 76 D3 FD 86 00
 altd ioi add a, (iy+0)         ; 76 D3 FD 86 00
 altd ioi add a, (iy+126)       ; 76 D3 FD 86 7E
 altd ioi add a, (iy-128)       ; 76 D3 FD 86 80
 altd ioi and (hl)              ; 76 D3 7F A6
 altd ioi and (ix)              ; 76 D3 DD A6 00
 altd ioi and (ix+0)            ; 76 D3 DD A6 00
 altd ioi and (ix+126)          ; 76 D3 DD A6 7E
 altd ioi and (ix-128)          ; 76 D3 DD A6 80
 altd ioi and (iy)              ; 76 D3 FD A6 00
 altd ioi and (iy+0)            ; 76 D3 FD A6 00
 altd ioi and (iy+126)          ; 76 D3 FD A6 7E
 altd ioi and (iy-128)          ; 76 D3 FD A6 80
 altd ioi bit 0, (hl)           ; 76 D3 CB 46
 altd ioi bit 0, (ix)           ; 76 D3 DD CB 00 46
 altd ioi bit 0, (ix+0)         ; 76 D3 DD CB 00 46
 altd ioi bit 0, (ix+126)       ; 76 D3 DD CB 7E 46
 altd ioi bit 0, (ix-128)       ; 76 D3 DD CB 80 46
 altd ioi bit 0, (iy)           ; 76 D3 FD CB 00 46
 altd ioi bit 0, (iy+0)         ; 76 D3 FD CB 00 46
 altd ioi bit 0, (iy+126)       ; 76 D3 FD CB 7E 46
 altd ioi bit 0, (iy-128)       ; 76 D3 FD CB 80 46
 altd ioi bit 1, (hl)           ; 76 D3 CB 4E
 altd ioi bit 1, (ix)           ; 76 D3 DD CB 00 4E
 altd ioi bit 1, (ix+0)         ; 76 D3 DD CB 00 4E
 altd ioi bit 1, (ix+126)       ; 76 D3 DD CB 7E 4E
 altd ioi bit 1, (ix-128)       ; 76 D3 DD CB 80 4E
 altd ioi bit 1, (iy)           ; 76 D3 FD CB 00 4E
 altd ioi bit 1, (iy+0)         ; 76 D3 FD CB 00 4E
 altd ioi bit 1, (iy+126)       ; 76 D3 FD CB 7E 4E
 altd ioi bit 1, (iy-128)       ; 76 D3 FD CB 80 4E
 altd ioi bit 2, (hl)           ; 76 D3 CB 56
 altd ioi bit 2, (ix)           ; 76 D3 DD CB 00 56
 altd ioi bit 2, (ix+0)         ; 76 D3 DD CB 00 56
 altd ioi bit 2, (ix+126)       ; 76 D3 DD CB 7E 56
 altd ioi bit 2, (ix-128)       ; 76 D3 DD CB 80 56
 altd ioi bit 2, (iy)           ; 76 D3 FD CB 00 56
 altd ioi bit 2, (iy+0)         ; 76 D3 FD CB 00 56
 altd ioi bit 2, (iy+126)       ; 76 D3 FD CB 7E 56
 altd ioi bit 2, (iy-128)       ; 76 D3 FD CB 80 56
 altd ioi bit 3, (hl)           ; 76 D3 CB 5E
 altd ioi bit 3, (ix)           ; 76 D3 DD CB 00 5E
 altd ioi bit 3, (ix+0)         ; 76 D3 DD CB 00 5E
 altd ioi bit 3, (ix+126)       ; 76 D3 DD CB 7E 5E
 altd ioi bit 3, (ix-128)       ; 76 D3 DD CB 80 5E
 altd ioi bit 3, (iy)           ; 76 D3 FD CB 00 5E
 altd ioi bit 3, (iy+0)         ; 76 D3 FD CB 00 5E
 altd ioi bit 3, (iy+126)       ; 76 D3 FD CB 7E 5E
 altd ioi bit 3, (iy-128)       ; 76 D3 FD CB 80 5E
 altd ioi bit 4, (hl)           ; 76 D3 CB 66
 altd ioi bit 4, (ix)           ; 76 D3 DD CB 00 66
 altd ioi bit 4, (ix+0)         ; 76 D3 DD CB 00 66
 altd ioi bit 4, (ix+126)       ; 76 D3 DD CB 7E 66
 altd ioi bit 4, (ix-128)       ; 76 D3 DD CB 80 66
 altd ioi bit 4, (iy)           ; 76 D3 FD CB 00 66
 altd ioi bit 4, (iy+0)         ; 76 D3 FD CB 00 66
 altd ioi bit 4, (iy+126)       ; 76 D3 FD CB 7E 66
 altd ioi bit 4, (iy-128)       ; 76 D3 FD CB 80 66
 altd ioi bit 5, (hl)           ; 76 D3 CB 6E
 altd ioi bit 5, (ix)           ; 76 D3 DD CB 00 6E
 altd ioi bit 5, (ix+0)         ; 76 D3 DD CB 00 6E
 altd ioi bit 5, (ix+126)       ; 76 D3 DD CB 7E 6E
 altd ioi bit 5, (ix-128)       ; 76 D3 DD CB 80 6E
 altd ioi bit 5, (iy)           ; 76 D3 FD CB 00 6E
 altd ioi bit 5, (iy+0)         ; 76 D3 FD CB 00 6E
 altd ioi bit 5, (iy+126)       ; 76 D3 FD CB 7E 6E
 altd ioi bit 5, (iy-128)       ; 76 D3 FD CB 80 6E
 altd ioi bit 6, (hl)           ; 76 D3 CB 76
 altd ioi bit 6, (ix)           ; 76 D3 DD CB 00 76
 altd ioi bit 6, (ix+0)         ; 76 D3 DD CB 00 76
 altd ioi bit 6, (ix+126)       ; 76 D3 DD CB 7E 76
 altd ioi bit 6, (ix-128)       ; 76 D3 DD CB 80 76
 altd ioi bit 6, (iy)           ; 76 D3 FD CB 00 76
 altd ioi bit 6, (iy+0)         ; 76 D3 FD CB 00 76
 altd ioi bit 6, (iy+126)       ; 76 D3 FD CB 7E 76
 altd ioi bit 6, (iy-128)       ; 76 D3 FD CB 80 76
 altd ioi bit 7, (hl)           ; 76 D3 CB 7E
 altd ioi bit 7, (ix)           ; 76 D3 DD CB 00 7E
 altd ioi bit 7, (ix+0)         ; 76 D3 DD CB 00 7E
 altd ioi bit 7, (ix+126)       ; 76 D3 DD CB 7E 7E
 altd ioi bit 7, (ix-128)       ; 76 D3 DD CB 80 7E
 altd ioi bit 7, (iy)           ; 76 D3 FD CB 00 7E
 altd ioi bit 7, (iy+0)         ; 76 D3 FD CB 00 7E
 altd ioi bit 7, (iy+126)       ; 76 D3 FD CB 7E 7E
 altd ioi bit 7, (iy-128)       ; 76 D3 FD CB 80 7E
 altd ioi cp (hl)               ; 76 D3 7F BE
 altd ioi cp (ix)               ; 76 D3 DD BE 00
 altd ioi cp (ix+0)             ; 76 D3 DD BE 00
 altd ioi cp (ix+126)           ; 76 D3 DD BE 7E
 altd ioi cp (ix-128)           ; 76 D3 DD BE 80
 altd ioi cp (iy)               ; 76 D3 FD BE 00
 altd ioi cp (iy+0)             ; 76 D3 FD BE 00
 altd ioi cp (iy+126)           ; 76 D3 FD BE 7E
 altd ioi cp (iy-128)           ; 76 D3 FD BE 80
 altd ioi dec (hl)              ; 76 D3 35
 altd ioi dec (ix)              ; 76 D3 DD 35 00
 altd ioi dec (ix+0)            ; 76 D3 DD 35 00
 altd ioi dec (ix+126)          ; 76 D3 DD 35 7E
 altd ioi dec (ix-128)          ; 76 D3 DD 35 80
 altd ioi dec (iy)              ; 76 D3 FD 35 00
 altd ioi dec (iy+0)            ; 76 D3 FD 35 00
 altd ioi dec (iy+126)          ; 76 D3 FD 35 7E
 altd ioi dec (iy-128)          ; 76 D3 FD 35 80
 altd ioi inc (hl)              ; 76 D3 34
 altd ioi inc (ix)              ; 76 D3 DD 34 00
 altd ioi inc (ix+0)            ; 76 D3 DD 34 00
 altd ioi inc (ix+126)          ; 76 D3 DD 34 7E
 altd ioi inc (ix-128)          ; 76 D3 DD 34 80
 altd ioi inc (iy)              ; 76 D3 FD 34 00
 altd ioi inc (iy+0)            ; 76 D3 FD 34 00
 altd ioi inc (iy+126)          ; 76 D3 FD 34 7E
 altd ioi inc (iy-128)          ; 76 D3 FD 34 80
 altd ioi ld a, (0x1234)        ; 76 D3 3A 34 12
 altd ioi ld a, (bc)            ; 76 D3 0A
 altd ioi ld a, (de)            ; 76 D3 1A
 altd ioi ld a, (hl)            ; 76 D3 7E
 altd ioi ld a, (ix)            ; 76 D3 DD 7E 00
 altd ioi ld a, (ix+0)          ; 76 D3 DD 7E 00
 altd ioi ld a, (ix+126)        ; 76 D3 DD 7E 7E
 altd ioi ld a, (ix+a)          ; 76 D3 DD 06
 altd ioi ld a, (ix-128)        ; 76 D3 DD 7E 80
 altd ioi ld a, (iy)            ; 76 D3 FD 7E 00
 altd ioi ld a, (iy+0)          ; 76 D3 FD 7E 00
 altd ioi ld a, (iy+126)        ; 76 D3 FD 7E 7E
 altd ioi ld a, (iy+a)          ; 76 D3 FD 06
 altd ioi ld a, (iy-128)        ; 76 D3 FD 7E 80
 altd ioi ld b, (hl)            ; 76 D3 46
 altd ioi ld b, (ix)            ; 76 D3 DD 46 00
 altd ioi ld b, (ix+0)          ; 76 D3 DD 46 00
 altd ioi ld b, (ix+126)        ; 76 D3 DD 46 7E
 altd ioi ld b, (ix-128)        ; 76 D3 DD 46 80
 altd ioi ld b, (iy)            ; 76 D3 FD 46 00
 altd ioi ld b, (iy+0)          ; 76 D3 FD 46 00
 altd ioi ld b, (iy+126)        ; 76 D3 FD 46 7E
 altd ioi ld b, (iy-128)        ; 76 D3 FD 46 80
 altd ioi ld bc, (0x1234)       ; 76 D3 ED 4B 34 12
 altd ioi ld bcde, (0x1234)     ; 76 D3 93 34 12
 altd ioi ld bcde, (hl)         ; 76 D3 DD 1A
 altd ioi ld bcde, (ix)         ; 76 D3 DD CE 00
 altd ioi ld bcde, (ix+0)       ; 76 D3 DD CE 00
 altd ioi ld bcde, (ix+126)     ; 76 D3 DD CE 7E
 altd ioi ld bcde, (ix-128)     ; 76 D3 DD CE 80
 altd ioi ld bcde, (iy)         ; 76 D3 DD DE 00
 altd ioi ld bcde, (iy+0)       ; 76 D3 DD DE 00
 altd ioi ld bcde, (iy+126)     ; 76 D3 DD DE 7E
 altd ioi ld bcde, (iy-128)     ; 76 D3 DD DE 80
 altd ioi ld c, (hl)            ; 76 D3 4E
 altd ioi ld c, (ix)            ; 76 D3 DD 4E 00
 altd ioi ld c, (ix+0)          ; 76 D3 DD 4E 00
 altd ioi ld c, (ix+126)        ; 76 D3 DD 4E 7E
 altd ioi ld c, (ix-128)        ; 76 D3 DD 4E 80
 altd ioi ld c, (iy)            ; 76 D3 FD 4E 00
 altd ioi ld c, (iy+0)          ; 76 D3 FD 4E 00
 altd ioi ld c, (iy+126)        ; 76 D3 FD 4E 7E
 altd ioi ld c, (iy-128)        ; 76 D3 FD 4E 80
 altd ioi ld d, (hl)            ; 76 D3 56
 altd ioi ld d, (ix)            ; 76 D3 DD 56 00
 altd ioi ld d, (ix+0)          ; 76 D3 DD 56 00
 altd ioi ld d, (ix+126)        ; 76 D3 DD 56 7E
 altd ioi ld d, (ix-128)        ; 76 D3 DD 56 80
 altd ioi ld d, (iy)            ; 76 D3 FD 56 00
 altd ioi ld d, (iy+0)          ; 76 D3 FD 56 00
 altd ioi ld d, (iy+126)        ; 76 D3 FD 56 7E
 altd ioi ld d, (iy-128)        ; 76 D3 FD 56 80
 altd ioi ld de, (0x1234)       ; 76 D3 ED 5B 34 12
 altd ioi ld e, (hl)            ; 76 D3 5E
 altd ioi ld e, (ix)            ; 76 D3 DD 5E 00
 altd ioi ld e, (ix+0)          ; 76 D3 DD 5E 00
 altd ioi ld e, (ix+126)        ; 76 D3 DD 5E 7E
 altd ioi ld e, (ix-128)        ; 76 D3 DD 5E 80
 altd ioi ld e, (iy)            ; 76 D3 FD 5E 00
 altd ioi ld e, (iy+0)          ; 76 D3 FD 5E 00
 altd ioi ld e, (iy+126)        ; 76 D3 FD 5E 7E
 altd ioi ld e, (iy-128)        ; 76 D3 FD 5E 80
 altd ioi ld h, (hl)            ; 76 D3 66
 altd ioi ld h, (ix)            ; 76 D3 DD 66 00
 altd ioi ld h, (ix+0)          ; 76 D3 DD 66 00
 altd ioi ld h, (ix+126)        ; 76 D3 DD 66 7E
 altd ioi ld h, (ix-128)        ; 76 D3 DD 66 80
 altd ioi ld h, (iy)            ; 76 D3 FD 66 00
 altd ioi ld h, (iy+0)          ; 76 D3 FD 66 00
 altd ioi ld h, (iy+126)        ; 76 D3 FD 66 7E
 altd ioi ld h, (iy-128)        ; 76 D3 FD 66 80
 altd ioi ld hl, (0x1234)       ; 76 D3 2A 34 12
 altd ioi ld hl, (hl)           ; 76 D3 DD E4 00
 altd ioi ld hl, (hl+0)         ; 76 D3 DD E4 00
 altd ioi ld hl, (hl+126)       ; 76 D3 DD E4 7E
 altd ioi ld hl, (hl-128)       ; 76 D3 DD E4 80
 altd ioi ld hl, (ix)           ; 76 D3 E4 00
 altd ioi ld hl, (ix+0)         ; 76 D3 E4 00
 altd ioi ld hl, (ix+126)       ; 76 D3 E4 7E
 altd ioi ld hl, (ix-128)       ; 76 D3 E4 80
 altd ioi ld hl, (iy)           ; 76 D3 FD E4 00
 altd ioi ld hl, (iy+0)         ; 76 D3 FD E4 00
 altd ioi ld hl, (iy+126)       ; 76 D3 FD E4 7E
 altd ioi ld hl, (iy-128)       ; 76 D3 FD E4 80
 altd ioi ld jk, (0x1234)       ; 76 D3 99 34 12
 altd ioi ld jkhl, (0x1234)     ; 76 D3 94 34 12
 altd ioi ld jkhl, (hl)         ; 76 D3 FD 1A
 altd ioi ld jkhl, (ix)         ; 76 D3 FD CE 00
 altd ioi ld jkhl, (ix+0)       ; 76 D3 FD CE 00
 altd ioi ld jkhl, (ix+126)     ; 76 D3 FD CE 7E
 altd ioi ld jkhl, (ix-128)     ; 76 D3 FD CE 80
 altd ioi ld jkhl, (iy)         ; 76 D3 FD DE 00
 altd ioi ld jkhl, (iy+0)       ; 76 D3 FD DE 00
 altd ioi ld jkhl, (iy+126)     ; 76 D3 FD DE 7E
 altd ioi ld jkhl, (iy-128)     ; 76 D3 FD DE 80
 altd ioi ld l, (hl)            ; 76 D3 6E
 altd ioi ld l, (ix)            ; 76 D3 DD 6E 00
 altd ioi ld l, (ix+0)          ; 76 D3 DD 6E 00
 altd ioi ld l, (ix+126)        ; 76 D3 DD 6E 7E
 altd ioi ld l, (ix-128)        ; 76 D3 DD 6E 80
 altd ioi ld l, (iy)            ; 76 D3 FD 6E 00
 altd ioi ld l, (iy+0)          ; 76 D3 FD 6E 00
 altd ioi ld l, (iy+126)        ; 76 D3 FD 6E 7E
 altd ioi ld l, (iy-128)        ; 76 D3 FD 6E 80
 altd ioi or (hl)               ; 76 D3 7F B6
 altd ioi or (ix)               ; 76 D3 DD B6 00
 altd ioi or (ix+0)             ; 76 D3 DD B6 00
 altd ioi or (ix+126)           ; 76 D3 DD B6 7E
 altd ioi or (ix-128)           ; 76 D3 DD B6 80
 altd ioi or (iy)               ; 76 D3 FD B6 00
 altd ioi or (iy+0)             ; 76 D3 FD B6 00
 altd ioi or (iy+126)           ; 76 D3 FD B6 7E
 altd ioi or (iy-128)           ; 76 D3 FD B6 80
 altd ioi res 0, (hl)           ; 76 D3 CB 86
 altd ioi res 0, (ix)           ; 76 D3 DD CB 00 86
 altd ioi res 0, (ix+0)         ; 76 D3 DD CB 00 86
 altd ioi res 0, (ix+126)       ; 76 D3 DD CB 7E 86
 altd ioi res 0, (ix-128)       ; 76 D3 DD CB 80 86
 altd ioi res 0, (iy)           ; 76 D3 FD CB 00 86
 altd ioi res 0, (iy+0)         ; 76 D3 FD CB 00 86
 altd ioi res 0, (iy+126)       ; 76 D3 FD CB 7E 86
 altd ioi res 0, (iy-128)       ; 76 D3 FD CB 80 86
 altd ioi res 1, (hl)           ; 76 D3 CB 8E
 altd ioi res 1, (ix)           ; 76 D3 DD CB 00 8E
 altd ioi res 1, (ix+0)         ; 76 D3 DD CB 00 8E
 altd ioi res 1, (ix+126)       ; 76 D3 DD CB 7E 8E
 altd ioi res 1, (ix-128)       ; 76 D3 DD CB 80 8E
 altd ioi res 1, (iy)           ; 76 D3 FD CB 00 8E
 altd ioi res 1, (iy+0)         ; 76 D3 FD CB 00 8E
 altd ioi res 1, (iy+126)       ; 76 D3 FD CB 7E 8E
 altd ioi res 1, (iy-128)       ; 76 D3 FD CB 80 8E
 altd ioi res 2, (hl)           ; 76 D3 CB 96
 altd ioi res 2, (ix)           ; 76 D3 DD CB 00 96
 altd ioi res 2, (ix+0)         ; 76 D3 DD CB 00 96
 altd ioi res 2, (ix+126)       ; 76 D3 DD CB 7E 96
 altd ioi res 2, (ix-128)       ; 76 D3 DD CB 80 96
 altd ioi res 2, (iy)           ; 76 D3 FD CB 00 96
 altd ioi res 2, (iy+0)         ; 76 D3 FD CB 00 96
 altd ioi res 2, (iy+126)       ; 76 D3 FD CB 7E 96
 altd ioi res 2, (iy-128)       ; 76 D3 FD CB 80 96
 altd ioi res 3, (hl)           ; 76 D3 CB 9E
 altd ioi res 3, (ix)           ; 76 D3 DD CB 00 9E
 altd ioi res 3, (ix+0)         ; 76 D3 DD CB 00 9E
 altd ioi res 3, (ix+126)       ; 76 D3 DD CB 7E 9E
 altd ioi res 3, (ix-128)       ; 76 D3 DD CB 80 9E
 altd ioi res 3, (iy)           ; 76 D3 FD CB 00 9E
 altd ioi res 3, (iy+0)         ; 76 D3 FD CB 00 9E
 altd ioi res 3, (iy+126)       ; 76 D3 FD CB 7E 9E
 altd ioi res 3, (iy-128)       ; 76 D3 FD CB 80 9E
 altd ioi res 4, (hl)           ; 76 D3 CB A6
 altd ioi res 4, (ix)           ; 76 D3 DD CB 00 A6
 altd ioi res 4, (ix+0)         ; 76 D3 DD CB 00 A6
 altd ioi res 4, (ix+126)       ; 76 D3 DD CB 7E A6
 altd ioi res 4, (ix-128)       ; 76 D3 DD CB 80 A6
 altd ioi res 4, (iy)           ; 76 D3 FD CB 00 A6
 altd ioi res 4, (iy+0)         ; 76 D3 FD CB 00 A6
 altd ioi res 4, (iy+126)       ; 76 D3 FD CB 7E A6
 altd ioi res 4, (iy-128)       ; 76 D3 FD CB 80 A6
 altd ioi res 5, (hl)           ; 76 D3 CB AE
 altd ioi res 5, (ix)           ; 76 D3 DD CB 00 AE
 altd ioi res 5, (ix+0)         ; 76 D3 DD CB 00 AE
 altd ioi res 5, (ix+126)       ; 76 D3 DD CB 7E AE
 altd ioi res 5, (ix-128)       ; 76 D3 DD CB 80 AE
 altd ioi res 5, (iy)           ; 76 D3 FD CB 00 AE
 altd ioi res 5, (iy+0)         ; 76 D3 FD CB 00 AE
 altd ioi res 5, (iy+126)       ; 76 D3 FD CB 7E AE
 altd ioi res 5, (iy-128)       ; 76 D3 FD CB 80 AE
 altd ioi res 6, (hl)           ; 76 D3 CB B6
 altd ioi res 6, (ix)           ; 76 D3 DD CB 00 B6
 altd ioi res 6, (ix+0)         ; 76 D3 DD CB 00 B6
 altd ioi res 6, (ix+126)       ; 76 D3 DD CB 7E B6
 altd ioi res 6, (ix-128)       ; 76 D3 DD CB 80 B6
 altd ioi res 6, (iy)           ; 76 D3 FD CB 00 B6
 altd ioi res 6, (iy+0)         ; 76 D3 FD CB 00 B6
 altd ioi res 6, (iy+126)       ; 76 D3 FD CB 7E B6
 altd ioi res 6, (iy-128)       ; 76 D3 FD CB 80 B6
 altd ioi res 7, (hl)           ; 76 D3 CB BE
 altd ioi res 7, (ix)           ; 76 D3 DD CB 00 BE
 altd ioi res 7, (ix+0)         ; 76 D3 DD CB 00 BE
 altd ioi res 7, (ix+126)       ; 76 D3 DD CB 7E BE
 altd ioi res 7, (ix-128)       ; 76 D3 DD CB 80 BE
 altd ioi res 7, (iy)           ; 76 D3 FD CB 00 BE
 altd ioi res 7, (iy+0)         ; 76 D3 FD CB 00 BE
 altd ioi res 7, (iy+126)       ; 76 D3 FD CB 7E BE
 altd ioi res 7, (iy-128)       ; 76 D3 FD CB 80 BE
 altd ioi rl (hl)               ; 76 D3 CB 16
 altd ioi rl (ix)               ; 76 D3 DD CB 00 16
 altd ioi rl (ix+0)             ; 76 D3 DD CB 00 16
 altd ioi rl (ix+126)           ; 76 D3 DD CB 7E 16
 altd ioi rl (ix-128)           ; 76 D3 DD CB 80 16
 altd ioi rl (iy)               ; 76 D3 FD CB 00 16
 altd ioi rl (iy+0)             ; 76 D3 FD CB 00 16
 altd ioi rl (iy+126)           ; 76 D3 FD CB 7E 16
 altd ioi rl (iy-128)           ; 76 D3 FD CB 80 16
 altd ioi rlc (hl)              ; 76 D3 CB 06
 altd ioi rlc (ix)              ; 76 D3 DD CB 00 06
 altd ioi rlc (ix+0)            ; 76 D3 DD CB 00 06
 altd ioi rlc (ix+126)          ; 76 D3 DD CB 7E 06
 altd ioi rlc (ix-128)          ; 76 D3 DD CB 80 06
 altd ioi rlc (iy)              ; 76 D3 FD CB 00 06
 altd ioi rlc (iy+0)            ; 76 D3 FD CB 00 06
 altd ioi rlc (iy+126)          ; 76 D3 FD CB 7E 06
 altd ioi rlc (iy-128)          ; 76 D3 FD CB 80 06
 altd ioi rr (hl)               ; 76 D3 CB 1E
 altd ioi rr (ix)               ; 76 D3 DD CB 00 1E
 altd ioi rr (ix+0)             ; 76 D3 DD CB 00 1E
 altd ioi rr (ix+126)           ; 76 D3 DD CB 7E 1E
 altd ioi rr (ix-128)           ; 76 D3 DD CB 80 1E
 altd ioi rr (iy)               ; 76 D3 FD CB 00 1E
 altd ioi rr (iy+0)             ; 76 D3 FD CB 00 1E
 altd ioi rr (iy+126)           ; 76 D3 FD CB 7E 1E
 altd ioi rr (iy-128)           ; 76 D3 FD CB 80 1E
 altd ioi rrc (hl)              ; 76 D3 CB 0E
 altd ioi rrc (ix)              ; 76 D3 DD CB 00 0E
 altd ioi rrc (ix+0)            ; 76 D3 DD CB 00 0E
 altd ioi rrc (ix+126)          ; 76 D3 DD CB 7E 0E
 altd ioi rrc (ix-128)          ; 76 D3 DD CB 80 0E
 altd ioi rrc (iy)              ; 76 D3 FD CB 00 0E
 altd ioi rrc (iy+0)            ; 76 D3 FD CB 00 0E
 altd ioi rrc (iy+126)          ; 76 D3 FD CB 7E 0E
 altd ioi rrc (iy-128)          ; 76 D3 FD CB 80 0E
 altd ioi sbc a, (hl)           ; 76 D3 7F 9E
 altd ioi sbc a, (ix)           ; 76 D3 DD 9E 00
 altd ioi sbc a, (ix+0)         ; 76 D3 DD 9E 00
 altd ioi sbc a, (ix+126)       ; 76 D3 DD 9E 7E
 altd ioi sbc a, (ix-128)       ; 76 D3 DD 9E 80
 altd ioi sbc a, (iy)           ; 76 D3 FD 9E 00
 altd ioi sbc a, (iy+0)         ; 76 D3 FD 9E 00
 altd ioi sbc a, (iy+126)       ; 76 D3 FD 9E 7E
 altd ioi sbc a, (iy-128)       ; 76 D3 FD 9E 80
 altd ioi set 0, (hl)           ; 76 D3 CB C6
 altd ioi set 0, (ix)           ; 76 D3 DD CB 00 C6
 altd ioi set 0, (ix+0)         ; 76 D3 DD CB 00 C6
 altd ioi set 0, (ix+126)       ; 76 D3 DD CB 7E C6
 altd ioi set 0, (ix-128)       ; 76 D3 DD CB 80 C6
 altd ioi set 0, (iy)           ; 76 D3 FD CB 00 C6
 altd ioi set 0, (iy+0)         ; 76 D3 FD CB 00 C6
 altd ioi set 0, (iy+126)       ; 76 D3 FD CB 7E C6
 altd ioi set 0, (iy-128)       ; 76 D3 FD CB 80 C6
 altd ioi set 1, (hl)           ; 76 D3 CB CE
 altd ioi set 1, (ix)           ; 76 D3 DD CB 00 CE
 altd ioi set 1, (ix+0)         ; 76 D3 DD CB 00 CE
 altd ioi set 1, (ix+126)       ; 76 D3 DD CB 7E CE
 altd ioi set 1, (ix-128)       ; 76 D3 DD CB 80 CE
 altd ioi set 1, (iy)           ; 76 D3 FD CB 00 CE
 altd ioi set 1, (iy+0)         ; 76 D3 FD CB 00 CE
 altd ioi set 1, (iy+126)       ; 76 D3 FD CB 7E CE
 altd ioi set 1, (iy-128)       ; 76 D3 FD CB 80 CE
 altd ioi set 2, (hl)           ; 76 D3 CB D6
 altd ioi set 2, (ix)           ; 76 D3 DD CB 00 D6
 altd ioi set 2, (ix+0)         ; 76 D3 DD CB 00 D6
 altd ioi set 2, (ix+126)       ; 76 D3 DD CB 7E D6
 altd ioi set 2, (ix-128)       ; 76 D3 DD CB 80 D6
 altd ioi set 2, (iy)           ; 76 D3 FD CB 00 D6
 altd ioi set 2, (iy+0)         ; 76 D3 FD CB 00 D6
 altd ioi set 2, (iy+126)       ; 76 D3 FD CB 7E D6
 altd ioi set 2, (iy-128)       ; 76 D3 FD CB 80 D6
 altd ioi set 3, (hl)           ; 76 D3 CB DE
 altd ioi set 3, (ix)           ; 76 D3 DD CB 00 DE
 altd ioi set 3, (ix+0)         ; 76 D3 DD CB 00 DE
 altd ioi set 3, (ix+126)       ; 76 D3 DD CB 7E DE
 altd ioi set 3, (ix-128)       ; 76 D3 DD CB 80 DE
 altd ioi set 3, (iy)           ; 76 D3 FD CB 00 DE
 altd ioi set 3, (iy+0)         ; 76 D3 FD CB 00 DE
 altd ioi set 3, (iy+126)       ; 76 D3 FD CB 7E DE
 altd ioi set 3, (iy-128)       ; 76 D3 FD CB 80 DE
 altd ioi set 4, (hl)           ; 76 D3 CB E6
 altd ioi set 4, (ix)           ; 76 D3 DD CB 00 E6
 altd ioi set 4, (ix+0)         ; 76 D3 DD CB 00 E6
 altd ioi set 4, (ix+126)       ; 76 D3 DD CB 7E E6
 altd ioi set 4, (ix-128)       ; 76 D3 DD CB 80 E6
 altd ioi set 4, (iy)           ; 76 D3 FD CB 00 E6
 altd ioi set 4, (iy+0)         ; 76 D3 FD CB 00 E6
 altd ioi set 4, (iy+126)       ; 76 D3 FD CB 7E E6
 altd ioi set 4, (iy-128)       ; 76 D3 FD CB 80 E6
 altd ioi set 5, (hl)           ; 76 D3 CB EE
 altd ioi set 5, (ix)           ; 76 D3 DD CB 00 EE
 altd ioi set 5, (ix+0)         ; 76 D3 DD CB 00 EE
 altd ioi set 5, (ix+126)       ; 76 D3 DD CB 7E EE
 altd ioi set 5, (ix-128)       ; 76 D3 DD CB 80 EE
 altd ioi set 5, (iy)           ; 76 D3 FD CB 00 EE
 altd ioi set 5, (iy+0)         ; 76 D3 FD CB 00 EE
 altd ioi set 5, (iy+126)       ; 76 D3 FD CB 7E EE
 altd ioi set 5, (iy-128)       ; 76 D3 FD CB 80 EE
 altd ioi set 6, (hl)           ; 76 D3 CB F6
 altd ioi set 6, (ix)           ; 76 D3 DD CB 00 F6
 altd ioi set 6, (ix+0)         ; 76 D3 DD CB 00 F6
 altd ioi set 6, (ix+126)       ; 76 D3 DD CB 7E F6
 altd ioi set 6, (ix-128)       ; 76 D3 DD CB 80 F6
 altd ioi set 6, (iy)           ; 76 D3 FD CB 00 F6
 altd ioi set 6, (iy+0)         ; 76 D3 FD CB 00 F6
 altd ioi set 6, (iy+126)       ; 76 D3 FD CB 7E F6
 altd ioi set 6, (iy-128)       ; 76 D3 FD CB 80 F6
 altd ioi set 7, (hl)           ; 76 D3 CB FE
 altd ioi set 7, (ix)           ; 76 D3 DD CB 00 FE
 altd ioi set 7, (ix+0)         ; 76 D3 DD CB 00 FE
 altd ioi set 7, (ix+126)       ; 76 D3 DD CB 7E FE
 altd ioi set 7, (ix-128)       ; 76 D3 DD CB 80 FE
 altd ioi set 7, (iy)           ; 76 D3 FD CB 00 FE
 altd ioi set 7, (iy+0)         ; 76 D3 FD CB 00 FE
 altd ioi set 7, (iy+126)       ; 76 D3 FD CB 7E FE
 altd ioi set 7, (iy-128)       ; 76 D3 FD CB 80 FE
 altd ioi sla (hl)              ; 76 D3 CB 26
 altd ioi sla (ix)              ; 76 D3 DD CB 00 26
 altd ioi sla (ix+0)            ; 76 D3 DD CB 00 26
 altd ioi sla (ix+126)          ; 76 D3 DD CB 7E 26
 altd ioi sla (ix-128)          ; 76 D3 DD CB 80 26
 altd ioi sla (iy)              ; 76 D3 FD CB 00 26
 altd ioi sla (iy+0)            ; 76 D3 FD CB 00 26
 altd ioi sla (iy+126)          ; 76 D3 FD CB 7E 26
 altd ioi sla (iy-128)          ; 76 D3 FD CB 80 26
 altd ioi sra (hl)              ; 76 D3 CB 2E
 altd ioi sra (ix)              ; 76 D3 DD CB 00 2E
 altd ioi sra (ix+0)            ; 76 D3 DD CB 00 2E
 altd ioi sra (ix+126)          ; 76 D3 DD CB 7E 2E
 altd ioi sra (ix-128)          ; 76 D3 DD CB 80 2E
 altd ioi sra (iy)              ; 76 D3 FD CB 00 2E
 altd ioi sra (iy+0)            ; 76 D3 FD CB 00 2E
 altd ioi sra (iy+126)          ; 76 D3 FD CB 7E 2E
 altd ioi sra (iy-128)          ; 76 D3 FD CB 80 2E
 altd ioi srl (hl)              ; 76 D3 CB 3E
 altd ioi srl (ix)              ; 76 D3 DD CB 00 3E
 altd ioi srl (ix+0)            ; 76 D3 DD CB 00 3E
 altd ioi srl (ix+126)          ; 76 D3 DD CB 7E 3E
 altd ioi srl (ix-128)          ; 76 D3 DD CB 80 3E
 altd ioi srl (iy)              ; 76 D3 FD CB 00 3E
 altd ioi srl (iy+0)            ; 76 D3 FD CB 00 3E
 altd ioi srl (iy+126)          ; 76 D3 FD CB 7E 3E
 altd ioi srl (iy-128)          ; 76 D3 FD CB 80 3E
 altd ioi sub (hl)              ; 76 D3 7F 96
 altd ioi sub (ix)              ; 76 D3 DD 96 00
 altd ioi sub (ix+0)            ; 76 D3 DD 96 00
 altd ioi sub (ix+126)          ; 76 D3 DD 96 7E
 altd ioi sub (ix-128)          ; 76 D3 DD 96 80
 altd ioi sub (iy)              ; 76 D3 FD 96 00
 altd ioi sub (iy+0)            ; 76 D3 FD 96 00
 altd ioi sub (iy+126)          ; 76 D3 FD 96 7E
 altd ioi sub (iy-128)          ; 76 D3 FD 96 80
 altd ioi xor (hl)              ; 76 D3 7F AE
 altd ioi xor (ix)              ; 76 D3 DD AE 00
 altd ioi xor (ix+0)            ; 76 D3 DD AE 00
 altd ioi xor (ix+126)          ; 76 D3 DD AE 7E
 altd ioi xor (ix-128)          ; 76 D3 DD AE 80
 altd ioi xor (iy)              ; 76 D3 FD AE 00
 altd ioi xor (iy+0)            ; 76 D3 FD AE 00
 altd ioi xor (iy+126)          ; 76 D3 FD AE 7E
 altd ioi xor (iy-128)          ; 76 D3 FD AE 80
 altd ld a, (0x1234)            ; 76 3A 34 12
 altd ld a, (bc)                ; 76 0A
 altd ld a, (de)                ; 76 1A
 altd ld a, (hl)                ; 76 7E
 altd ld a, (ix)                ; 76 DD 7E 00
 altd ld a, (ix+0)              ; 76 DD 7E 00
 altd ld a, (ix+126)            ; 76 DD 7E 7E
 altd ld a, (ix+a)              ; 76 DD 06
 altd ld a, (ix-128)            ; 76 DD 7E 80
 altd ld a, (iy)                ; 76 FD 7E 00
 altd ld a, (iy+0)              ; 76 FD 7E 00
 altd ld a, (iy+126)            ; 76 FD 7E 7E
 altd ld a, (iy+a)              ; 76 FD 06
 altd ld a, (iy-128)            ; 76 FD 7E 80
 altd ld a, (pw)                ; 76 8D 00
 altd ld a, (pw+0)              ; 76 8D 00
 altd ld a, (pw+126)            ; 76 8D 7E
 altd ld a, (pw+hl)             ; 76 8B
 altd ld a, (pw-128)            ; 76 8D 80
 altd ld a, (px)                ; 76 9D 00
 altd ld a, (px+0)              ; 76 9D 00
 altd ld a, (px+126)            ; 76 9D 7E
 altd ld a, (px+hl)             ; 76 9B
 altd ld a, (px-128)            ; 76 9D 80
 altd ld a, (py)                ; 76 AD 00
 altd ld a, (py+0)              ; 76 AD 00
 altd ld a, (py+126)            ; 76 AD 7E
 altd ld a, (py+hl)             ; 76 AB
 altd ld a, (py-128)            ; 76 AD 80
 altd ld a, (pz)                ; 76 BD 00
 altd ld a, (pz+0)              ; 76 BD 00
 altd ld a, (pz+126)            ; 76 BD 7E
 altd ld a, (pz+hl)             ; 76 BB
 altd ld a, (pz-128)            ; 76 BD 80
 altd ld a, 0                   ; 76 3E 00
 altd ld a, 127                 ; 76 3E 7F
 altd ld a, 255                 ; 76 3E FF
 altd ld a, a                   ; 76 7F 7F
 altd ld a, b                   ; 76 7F 78
 altd ld a, c                   ; 76 7F 79
 altd ld a, d                   ; 76 7F 7A
 altd ld a, e                   ; 76 7F 7B
 altd ld a, eir                 ; 76 ED 57
 altd ld a, h                   ; 76 7F 7C
 altd ld a, htr                 ; 76 ED 50
 altd ld a, iir                 ; 76 ED 5F
 altd ld a, l                   ; 76 7F 7D
 altd ld a, xpc                 ; 76 ED 77
 altd ld b, (hl)                ; 76 46
 altd ld b, (ix)                ; 76 DD 46 00
 altd ld b, (ix+0)              ; 76 DD 46 00
 altd ld b, (ix+126)            ; 76 DD 46 7E
 altd ld b, (ix-128)            ; 76 DD 46 80
 altd ld b, (iy)                ; 76 FD 46 00
 altd ld b, (iy+0)              ; 76 FD 46 00
 altd ld b, (iy+126)            ; 76 FD 46 7E
 altd ld b, (iy-128)            ; 76 FD 46 80
 altd ld b, 0                   ; 76 06 00
 altd ld b, 127                 ; 76 06 7F
 altd ld b, 255                 ; 76 06 FF
 altd ld b, a                   ; 76 7F 47
 altd ld b, b                   ; 76 7F 40
 altd ld b, c                   ; 76 7F 41
 altd ld b, d                   ; 76 7F 42
 altd ld b, e                   ; 76 7F 43
 altd ld b, h                   ; 76 7F 44
 altd ld b, l                   ; 76 7F 45
 altd ld bc, (0x1234)           ; 76 ED 4B 34 12
 altd ld bc, (pw)               ; 76 6D 00 00
 altd ld bc, (pw+0)             ; 76 6D 00 00
 altd ld bc, (pw+126)           ; 76 6D 00 7E
 altd ld bc, (pw+hl)            ; 76 6D 02
 altd ld bc, (pw-128)           ; 76 6D 00 80
 altd ld bc, (px)               ; 76 6D 10 00
 altd ld bc, (px+0)             ; 76 6D 10 00
 altd ld bc, (px+126)           ; 76 6D 10 7E
 altd ld bc, (px+hl)            ; 76 6D 12
 altd ld bc, (px-128)           ; 76 6D 10 80
 altd ld bc, (py)               ; 76 6D 20 00
 altd ld bc, (py+0)             ; 76 6D 20 00
 altd ld bc, (py+126)           ; 76 6D 20 7E
 altd ld bc, (py+hl)            ; 76 6D 22
 altd ld bc, (py-128)           ; 76 6D 20 80
 altd ld bc, (pz)               ; 76 6D 30 00
 altd ld bc, (pz+0)             ; 76 6D 30 00
 altd ld bc, (pz+126)           ; 76 6D 30 7E
 altd ld bc, (pz+hl)            ; 76 6D 32
 altd ld bc, (pz-128)           ; 76 6D 30 80
 altd ld bc, 0x1234             ; 76 01 34 12
 altd ld bc, bc                 ; ED 49
 altd ld bc, de                 ; ED 41
 altd ld bc, hl                 ; 76 91
 altd ld bcde, (0x1234)         ; 76 93 34 12
 altd ld bcde, (hl)             ; 76 DD 1A
 altd ld bcde, (ix)             ; 76 DD CE 00
 altd ld bcde, (ix+0)           ; 76 DD CE 00
 altd ld bcde, (ix+126)         ; 76 DD CE 7E
 altd ld bcde, (ix-128)         ; 76 DD CE 80
 altd ld bcde, (iy)             ; 76 DD DE 00
 altd ld bcde, (iy+0)           ; 76 DD DE 00
 altd ld bcde, (iy+126)         ; 76 DD DE 7E
 altd ld bcde, (iy-128)         ; 76 DD DE 80
 altd ld bcde, (pw)             ; 76 DD 0E 00
 altd ld bcde, (pw+0)           ; 76 DD 0E 00
 altd ld bcde, (pw+126)         ; 76 DD 0E 7E
 altd ld bcde, (pw+hl)          ; 76 DD 0C
 altd ld bcde, (pw-128)         ; 76 DD 0E 80
 altd ld bcde, (px)             ; 76 DD 1E 00
 altd ld bcde, (px+0)           ; 76 DD 1E 00
 altd ld bcde, (px+126)         ; 76 DD 1E 7E
 altd ld bcde, (px+hl)          ; 76 DD 1C
 altd ld bcde, (px-128)         ; 76 DD 1E 80
 altd ld bcde, (py)             ; 76 DD 2E 00
 altd ld bcde, (py+0)           ; 76 DD 2E 00
 altd ld bcde, (py+126)         ; 76 DD 2E 7E
 altd ld bcde, (py+hl)          ; 76 DD 2C
 altd ld bcde, (py-128)         ; 76 DD 2E 80
 altd ld bcde, (pz)             ; 76 DD 3E 00
 altd ld bcde, (pz+0)           ; 76 DD 3E 00
 altd ld bcde, (pz+126)         ; 76 DD 3E 7E
 altd ld bcde, (pz+hl)          ; 76 DD 3C
 altd ld bcde, (pz-128)         ; 76 DD 3E 80
 altd ld bcde, (sp)             ; 76 DD EE 00
 altd ld bcde, (sp+0)           ; 76 DD EE 00
 altd ld bcde, (sp+127)         ; 76 DD EE 7F
 altd ld bcde, (sp+255)         ; 76 DD EE FF
 altd ld bcde, (sp+hl)          ; 76 DD FE
 altd ld bcde, -128             ; 76 A3 80
 altd ld bcde, 0                ; 76 A3 00
 altd ld bcde, 126              ; 76 A3 7E
 altd ld bcde, pw               ; 76 DD CD
 altd ld bcde, px               ; 76 DD DD
 altd ld bcde, py               ; 76 DD ED
 altd ld bcde, pz               ; 76 DD FD
 altd ld c, (hl)                ; 76 4E
 altd ld c, (ix)                ; 76 DD 4E 00
 altd ld c, (ix+0)              ; 76 DD 4E 00
 altd ld c, (ix+126)            ; 76 DD 4E 7E
 altd ld c, (ix-128)            ; 76 DD 4E 80
 altd ld c, (iy)                ; 76 FD 4E 00
 altd ld c, (iy+0)              ; 76 FD 4E 00
 altd ld c, (iy+126)            ; 76 FD 4E 7E
 altd ld c, (iy-128)            ; 76 FD 4E 80
 altd ld c, 0                   ; 76 0E 00
 altd ld c, 127                 ; 76 0E 7F
 altd ld c, 255                 ; 76 0E FF
 altd ld c, a                   ; 76 7F 4F
 altd ld c, b                   ; 76 7F 48
 altd ld c, c                   ; 76 7F 49
 altd ld c, d                   ; 76 7F 4A
 altd ld c, e                   ; 76 7F 4B
 altd ld c, h                   ; 76 7F 4C
 altd ld c, l                   ; 76 7F 4D
 altd ld d, (hl)                ; 76 56
 altd ld d, (ix)                ; 76 DD 56 00
 altd ld d, (ix+0)              ; 76 DD 56 00
 altd ld d, (ix+126)            ; 76 DD 56 7E
 altd ld d, (ix-128)            ; 76 DD 56 80
 altd ld d, (iy)                ; 76 FD 56 00
 altd ld d, (iy+0)              ; 76 FD 56 00
 altd ld d, (iy+126)            ; 76 FD 56 7E
 altd ld d, (iy-128)            ; 76 FD 56 80
 altd ld d, 0                   ; 76 16 00
 altd ld d, 127                 ; 76 16 7F
 altd ld d, 255                 ; 76 16 FF
 altd ld d, a                   ; 76 7F 57
 altd ld d, b                   ; 76 7F 50
 altd ld d, c                   ; 76 7F 51
 altd ld d, d                   ; 76 7F 52
 altd ld d, e                   ; 76 7F 53
 altd ld d, h                   ; 76 7F 54
 altd ld d, l                   ; 76 7F 55
 altd ld de, (0x1234)           ; 76 ED 5B 34 12
 altd ld de, (pw)               ; 76 6D 40 00
 altd ld de, (pw+0)             ; 76 6D 40 00
 altd ld de, (pw+126)           ; 76 6D 40 7E
 altd ld de, (pw+hl)            ; 76 6D 42
 altd ld de, (pw-128)           ; 76 6D 40 80
 altd ld de, (px)               ; 76 6D 50 00
 altd ld de, (px+0)             ; 76 6D 50 00
 altd ld de, (px+126)           ; 76 6D 50 7E
 altd ld de, (px+hl)            ; 76 6D 52
 altd ld de, (px-128)           ; 76 6D 50 80
 altd ld de, (py)               ; 76 6D 60 00
 altd ld de, (py+0)             ; 76 6D 60 00
 altd ld de, (py+126)           ; 76 6D 60 7E
 altd ld de, (py+hl)            ; 76 6D 62
 altd ld de, (py-128)           ; 76 6D 60 80
 altd ld de, (pz)               ; 76 6D 70 00
 altd ld de, (pz+0)             ; 76 6D 70 00
 altd ld de, (pz+126)           ; 76 6D 70 7E
 altd ld de, (pz+hl)            ; 76 6D 72
 altd ld de, (pz-128)           ; 76 6D 70 80
 altd ld de, 0x1234             ; 76 11 34 12
 altd ld de, bc                 ; ED 59
 altd ld de, de                 ; ED 51
 altd ld de, hl                 ; 76 B1
 altd ld e, (hl)                ; 76 5E
 altd ld e, (ix)                ; 76 DD 5E 00
 altd ld e, (ix+0)              ; 76 DD 5E 00
 altd ld e, (ix+126)            ; 76 DD 5E 7E
 altd ld e, (ix-128)            ; 76 DD 5E 80
 altd ld e, (iy)                ; 76 FD 5E 00
 altd ld e, (iy+0)              ; 76 FD 5E 00
 altd ld e, (iy+126)            ; 76 FD 5E 7E
 altd ld e, (iy-128)            ; 76 FD 5E 80
 altd ld e, 0                   ; 76 1E 00
 altd ld e, 127                 ; 76 1E 7F
 altd ld e, 255                 ; 76 1E FF
 altd ld e, a                   ; 76 7F 5F
 altd ld e, b                   ; 76 7F 58
 altd ld e, c                   ; 76 7F 59
 altd ld e, d                   ; 76 7F 5A
 altd ld e, e                   ; 76 7F 5B
 altd ld e, h                   ; 76 7F 5C
 altd ld e, l                   ; 76 7F 5D
 altd ld h, (hl)                ; 76 66
 altd ld h, (ix)                ; 76 DD 66 00
 altd ld h, (ix+0)              ; 76 DD 66 00
 altd ld h, (ix+126)            ; 76 DD 66 7E
 altd ld h, (ix-128)            ; 76 DD 66 80
 altd ld h, (iy)                ; 76 FD 66 00
 altd ld h, (iy+0)              ; 76 FD 66 00
 altd ld h, (iy+126)            ; 76 FD 66 7E
 altd ld h, (iy-128)            ; 76 FD 66 80
 altd ld h, 0                   ; 76 26 00
 altd ld h, 127                 ; 76 26 7F
 altd ld h, 255                 ; 76 26 FF
 altd ld h, a                   ; 76 7F 67
 altd ld h, b                   ; 76 7F 60
 altd ld h, c                   ; 76 7F 61
 altd ld h, d                   ; 76 7F 62
 altd ld h, e                   ; 76 7F 63
 altd ld h, h                   ; 76 7F 64
 altd ld h, l                   ; 76 7F 65
 altd ld hl, (0x1234)           ; 76 2A 34 12
 altd ld hl, (hl)               ; 76 DD E4 00
 altd ld hl, (hl+0)             ; 76 DD E4 00
 altd ld hl, (hl+126)           ; 76 DD E4 7E
 altd ld hl, (hl-128)           ; 76 DD E4 80
 altd ld hl, (ix)               ; 76 E4 00
 altd ld hl, (ix+0)             ; 76 E4 00
 altd ld hl, (ix+126)           ; 76 E4 7E
 altd ld hl, (ix-128)           ; 76 E4 80
 altd ld hl, (iy)               ; 76 FD E4 00
 altd ld hl, (iy+0)             ; 76 FD E4 00
 altd ld hl, (iy+126)           ; 76 FD E4 7E
 altd ld hl, (iy-128)           ; 76 FD E4 80
 altd ld hl, (pw)               ; 76 85 00
 altd ld hl, (pw+0)             ; 76 85 00
 altd ld hl, (pw+126)           ; 76 85 7E
 altd ld hl, (pw+bc)            ; 76 ED 06
 altd ld hl, (pw-128)           ; 76 85 80
 altd ld hl, (px)               ; 76 95 00
 altd ld hl, (px+0)             ; 76 95 00
 altd ld hl, (px+126)           ; 76 95 7E
 altd ld hl, (px+bc)            ; 76 ED 16
 altd ld hl, (px-128)           ; 76 95 80
 altd ld hl, (py)               ; 76 A5 00
 altd ld hl, (py+0)             ; 76 A5 00
 altd ld hl, (py+126)           ; 76 A5 7E
 altd ld hl, (py+bc)            ; 76 ED 26
 altd ld hl, (py-128)           ; 76 A5 80
 altd ld hl, (pz)               ; 76 B5 00
 altd ld hl, (pz+0)             ; 76 B5 00
 altd ld hl, (pz+126)           ; 76 B5 7E
 altd ld hl, (pz+bc)            ; 76 ED 36
 altd ld hl, (pz-128)           ; 76 B5 80
 altd ld hl, (sp)               ; 76 C4 00
 altd ld hl, (sp+0)             ; 76 C4 00
 altd ld hl, (sp+127)           ; 76 C4 7F
 altd ld hl, (sp+255)           ; 76 C4 FF
 altd ld hl, (sp+hl)            ; 76 ED FE
 altd ld hl, 0x1234             ; 76 21 34 12
 altd ld hl, bc                 ; 76 81
 altd ld hl, de                 ; 76 A1
 altd ld hl, ix                 ; 76 DD 7C
 altd ld hl, iy                 ; 76 FD 7C
 altd ld hl, lxpc               ; 76 9F
 altd ld jk, (0x1234)           ; 76 99 34 12
 altd ld jk, 0x1234             ; 76 A9 34 12
 altd ld jkhl, (0x1234)         ; 76 94 34 12
 altd ld jkhl, (hl)             ; 76 FD 1A
 altd ld jkhl, (ix)             ; 76 FD CE 00
 altd ld jkhl, (ix+0)           ; 76 FD CE 00
 altd ld jkhl, (ix+126)         ; 76 FD CE 7E
 altd ld jkhl, (ix-128)         ; 76 FD CE 80
 altd ld jkhl, (iy)             ; 76 FD DE 00
 altd ld jkhl, (iy+0)           ; 76 FD DE 00
 altd ld jkhl, (iy+126)         ; 76 FD DE 7E
 altd ld jkhl, (iy-128)         ; 76 FD DE 80
 altd ld jkhl, (pw)             ; 76 FD 0E 00
 altd ld jkhl, (pw+0)           ; 76 FD 0E 00
 altd ld jkhl, (pw+126)         ; 76 FD 0E 7E
 altd ld jkhl, (pw+hl)          ; 76 FD 0C
 altd ld jkhl, (pw-128)         ; 76 FD 0E 80
 altd ld jkhl, (px)             ; 76 FD 1E 00
 altd ld jkhl, (px+0)           ; 76 FD 1E 00
 altd ld jkhl, (px+126)         ; 76 FD 1E 7E
 altd ld jkhl, (px+hl)          ; 76 FD 1C
 altd ld jkhl, (px-128)         ; 76 FD 1E 80
 altd ld jkhl, (py)             ; 76 FD 2E 00
 altd ld jkhl, (py+0)           ; 76 FD 2E 00
 altd ld jkhl, (py+126)         ; 76 FD 2E 7E
 altd ld jkhl, (py+hl)          ; 76 FD 2C
 altd ld jkhl, (py-128)         ; 76 FD 2E 80
 altd ld jkhl, (pz)             ; 76 FD 3E 00
 altd ld jkhl, (pz+0)           ; 76 FD 3E 00
 altd ld jkhl, (pz+126)         ; 76 FD 3E 7E
 altd ld jkhl, (pz+hl)          ; 76 FD 3C
 altd ld jkhl, (pz-128)         ; 76 FD 3E 80
 altd ld jkhl, (sp)             ; 76 FD EE 00
 altd ld jkhl, (sp+0)           ; 76 FD EE 00
 altd ld jkhl, (sp+127)         ; 76 FD EE 7F
 altd ld jkhl, (sp+255)         ; 76 FD EE FF
 altd ld jkhl, (sp+hl)          ; 76 FD FE
 altd ld jkhl, -128             ; 76 A4 80
 altd ld jkhl, 0                ; 76 A4 00
 altd ld jkhl, 126              ; 76 A4 7E
 altd ld jkhl, pw               ; 76 FD CD
 altd ld jkhl, px               ; 76 FD DD
 altd ld jkhl, py               ; 76 FD ED
 altd ld jkhl, pz               ; 76 FD FD
 altd ld l, (hl)                ; 76 6E
 altd ld l, (ix)                ; 76 DD 6E 00
 altd ld l, (ix+0)              ; 76 DD 6E 00
 altd ld l, (ix+126)            ; 76 DD 6E 7E
 altd ld l, (ix-128)            ; 76 DD 6E 80
 altd ld l, (iy)                ; 76 FD 6E 00
 altd ld l, (iy+0)              ; 76 FD 6E 00
 altd ld l, (iy+126)            ; 76 FD 6E 7E
 altd ld l, (iy-128)            ; 76 FD 6E 80
 altd ld l, 0                   ; 76 2E 00
 altd ld l, 127                 ; 76 2E 7F
 altd ld l, 255                 ; 76 2E FF
 altd ld l, a                   ; 76 7F 6F
 altd ld l, b                   ; 76 7F 68
 altd ld l, c                   ; 76 7F 69
 altd ld l, d                   ; 76 7F 6A
 altd ld l, e                   ; 76 7F 6B
 altd ld l, h                   ; 76 7F 6C
 altd ld l, l                   ; 76 7F 6D
 altd ld pw, (pw)               ; 76 6D 08 00
 altd ld pw, (pw+0)             ; 76 6D 08 00
 altd ld pw, (pw+126)           ; 76 6D 08 7E
 altd ld pw, (pw+hl)            ; 76 6D 0A
 altd ld pw, (pw-128)           ; 76 6D 08 80
 altd ld pw, (px)               ; 76 6D 18 00
 altd ld pw, (px+0)             ; 76 6D 18 00
 altd ld pw, (px+126)           ; 76 6D 18 7E
 altd ld pw, (px+hl)            ; 76 6D 1A
 altd ld pw, (px-128)           ; 76 6D 18 80
 altd ld pw, (py)               ; 76 6D 28 00
 altd ld pw, (py+0)             ; 76 6D 28 00
 altd ld pw, (py+126)           ; 76 6D 28 7E
 altd ld pw, (py+hl)            ; 76 6D 2A
 altd ld pw, (py-128)           ; 76 6D 28 80
 altd ld pw, (pz)               ; 76 6D 38 00
 altd ld pw, (pz+0)             ; 76 6D 38 00
 altd ld pw, (pz+126)           ; 76 6D 38 7E
 altd ld pw, (pz+hl)            ; 76 6D 3A
 altd ld pw, (pz-128)           ; 76 6D 38 80
 altd ld pw, pw                 ; 76 6D 07
 altd ld pw, pw+de              ; 76 6D 06
 altd ld pw, pw+hl              ; 76 6D 0E
 altd ld pw, pw+ix              ; 76 6D 04
 altd ld pw, pw+iy              ; 76 6D 05
 altd ld pw, px                 ; 76 6D 17
 altd ld pw, px+de              ; 76 6D 16
 altd ld pw, px+hl              ; 76 6D 1E
 altd ld pw, px+ix              ; 76 6D 14
 altd ld pw, px+iy              ; 76 6D 15
 altd ld pw, py                 ; 76 6D 27
 altd ld pw, py+de              ; 76 6D 26
 altd ld pw, py+hl              ; 76 6D 2E
 altd ld pw, py+ix              ; 76 6D 24
 altd ld pw, py+iy              ; 76 6D 25
 altd ld pw, pz                 ; 76 6D 37
 altd ld pw, pz+de              ; 76 6D 36
 altd ld pw, pz+hl              ; 76 6D 3E
 altd ld pw, pz+ix              ; 76 6D 34
 altd ld pw, pz+iy              ; 76 6D 35
 altd ld px, (pw)               ; 76 6D 48 00
 altd ld px, (pw+0)             ; 76 6D 48 00
 altd ld px, (pw+126)           ; 76 6D 48 7E
 altd ld px, (pw+hl)            ; 76 6D 4A
 altd ld px, (pw-128)           ; 76 6D 48 80
 altd ld px, (px)               ; 76 6D 58 00
 altd ld px, (px+0)             ; 76 6D 58 00
 altd ld px, (px+126)           ; 76 6D 58 7E
 altd ld px, (px+hl)            ; 76 6D 5A
 altd ld px, (px-128)           ; 76 6D 58 80
 altd ld px, (py)               ; 76 6D 68 00
 altd ld px, (py+0)             ; 76 6D 68 00
 altd ld px, (py+126)           ; 76 6D 68 7E
 altd ld px, (py+hl)            ; 76 6D 6A
 altd ld px, (py-128)           ; 76 6D 68 80
 altd ld px, (pz)               ; 76 6D 78 00
 altd ld px, (pz+0)             ; 76 6D 78 00
 altd ld px, (pz+126)           ; 76 6D 78 7E
 altd ld px, (pz+hl)            ; 76 6D 7A
 altd ld px, (pz-128)           ; 76 6D 78 80
 altd ld px, pw                 ; 76 6D 47
 altd ld px, pw+de              ; 76 6D 46
 altd ld px, pw+hl              ; 76 6D 4E
 altd ld px, pw+ix              ; 76 6D 44
 altd ld px, pw+iy              ; 76 6D 45
 altd ld px, px                 ; 76 6D 57
 altd ld px, px+de              ; 76 6D 56
 altd ld px, px+hl              ; 76 6D 5E
 altd ld px, px+ix              ; 76 6D 54
 altd ld px, px+iy              ; 76 6D 55
 altd ld px, py                 ; 76 6D 67
 altd ld px, py+de              ; 76 6D 66
 altd ld px, py+hl              ; 76 6D 6E
 altd ld px, py+ix              ; 76 6D 64
 altd ld px, py+iy              ; 76 6D 65
 altd ld px, pz                 ; 76 6D 77
 altd ld px, pz+de              ; 76 6D 76
 altd ld px, pz+hl              ; 76 6D 7E
 altd ld px, pz+ix              ; 76 6D 74
 altd ld px, pz+iy              ; 76 6D 75
 altd ld py, (pw)               ; 76 6D 88 00
 altd ld py, (pw+0)             ; 76 6D 88 00
 altd ld py, (pw+126)           ; 76 6D 88 7E
 altd ld py, (pw+hl)            ; 76 6D 8A
 altd ld py, (pw-128)           ; 76 6D 88 80
 altd ld py, (px)               ; 76 6D 98 00
 altd ld py, (px+0)             ; 76 6D 98 00
 altd ld py, (px+126)           ; 76 6D 98 7E
 altd ld py, (px+hl)            ; 76 6D 9A
 altd ld py, (px-128)           ; 76 6D 98 80
 altd ld py, (py)               ; 76 6D A8 00
 altd ld py, (py+0)             ; 76 6D A8 00
 altd ld py, (py+126)           ; 76 6D A8 7E
 altd ld py, (py+hl)            ; 76 6D AA
 altd ld py, (py-128)           ; 76 6D A8 80
 altd ld py, (pz)               ; 76 6D B8 00
 altd ld py, (pz+0)             ; 76 6D B8 00
 altd ld py, (pz+126)           ; 76 6D B8 7E
 altd ld py, (pz+hl)            ; 76 6D BA
 altd ld py, (pz-128)           ; 76 6D B8 80
 altd ld py, pw                 ; 76 6D 87
 altd ld py, pw+de              ; 76 6D 86
 altd ld py, pw+hl              ; 76 6D 8E
 altd ld py, pw+ix              ; 76 6D 84
 altd ld py, pw+iy              ; 76 6D 85
 altd ld py, px                 ; 76 6D 97
 altd ld py, px+de              ; 76 6D 96
 altd ld py, px+hl              ; 76 6D 9E
 altd ld py, px+ix              ; 76 6D 94
 altd ld py, px+iy              ; 76 6D 95
 altd ld py, py                 ; 76 6D A7
 altd ld py, py+de              ; 76 6D A6
 altd ld py, py+hl              ; 76 6D AE
 altd ld py, py+ix              ; 76 6D A4
 altd ld py, py+iy              ; 76 6D A5
 altd ld py, pz                 ; 76 6D B7
 altd ld py, pz+de              ; 76 6D B6
 altd ld py, pz+hl              ; 76 6D BE
 altd ld py, pz+ix              ; 76 6D B4
 altd ld py, pz+iy              ; 76 6D B5
 altd ld pz, (pw)               ; 76 6D C8 00
 altd ld pz, (pw+0)             ; 76 6D C8 00
 altd ld pz, (pw+126)           ; 76 6D C8 7E
 altd ld pz, (pw+hl)            ; 76 6D CA
 altd ld pz, (pw-128)           ; 76 6D C8 80
 altd ld pz, (px)               ; 76 6D D8 00
 altd ld pz, (px+0)             ; 76 6D D8 00
 altd ld pz, (px+126)           ; 76 6D D8 7E
 altd ld pz, (px+hl)            ; 76 6D DA
 altd ld pz, (px-128)           ; 76 6D D8 80
 altd ld pz, (py)               ; 76 6D E8 00
 altd ld pz, (py+0)             ; 76 6D E8 00
 altd ld pz, (py+126)           ; 76 6D E8 7E
 altd ld pz, (py+hl)            ; 76 6D EA
 altd ld pz, (py-128)           ; 76 6D E8 80
 altd ld pz, (pz)               ; 76 6D F8 00
 altd ld pz, (pz+0)             ; 76 6D F8 00
 altd ld pz, (pz+126)           ; 76 6D F8 7E
 altd ld pz, (pz+hl)            ; 76 6D FA
 altd ld pz, (pz-128)           ; 76 6D F8 80
 altd ld pz, pw                 ; 76 6D C7
 altd ld pz, pw+de              ; 76 6D C6
 altd ld pz, pw+hl              ; 76 6D CE
 altd ld pz, pw+ix              ; 76 6D C4
 altd ld pz, pw+iy              ; 76 6D C5
 altd ld pz, px                 ; 76 6D D7
 altd ld pz, px+de              ; 76 6D D6
 altd ld pz, px+hl              ; 76 6D DE
 altd ld pz, px+ix              ; 76 6D D4
 altd ld pz, px+iy              ; 76 6D D5
 altd ld pz, py                 ; 76 6D E7
 altd ld pz, py+de              ; 76 6D E6
 altd ld pz, py+hl              ; 76 6D EE
 altd ld pz, py+ix              ; 76 6D E4
 altd ld pz, py+iy              ; 76 6D E5
 altd ld pz, pz                 ; 76 6D F7
 altd ld pz, pz+de              ; 76 6D F6
 altd ld pz, pz+hl              ; 76 6D FE
 altd ld pz, pz+ix              ; 76 6D F4
 altd ld pz, pz+iy              ; 76 6D F5
 altd ldf a, (0x123456)         ; 76 9A 56 34 12
 altd ldf bc, (0x123456)        ; 76 ED 0A 56 34 12
 altd ldf bcde, (0x123456)      ; 76 DD 0A 56 34 12
 altd ldf de, (0x123456)        ; 76 ED 1A 56 34 12
 altd ldf hl, (0x123456)        ; 76 92 56 34 12
 altd ldf jkhl, (0x123456)      ; 76 FD 0A 56 34 12
 altd ldf pw, (0x123456)        ; 76 ED 08 56 34 12
 altd ldf px, (0x123456)        ; 76 ED 18 56 34 12
 altd ldf py, (0x123456)        ; 76 ED 28 56 34 12
 altd ldf pz, (0x123456)        ; 76 ED 38 56 34 12
 altd ldl pw, (sp)              ; 76 ED 03 00
 altd ldl pw, (sp+0)            ; 76 ED 03 00
 altd ldl pw, (sp+127)          ; 76 ED 03 7F
 altd ldl pw, (sp+255)          ; 76 ED 03 FF
 altd ldl pw, 0x1234            ; 76 ED 0D 34 12
 altd ldl pw, de                ; 76 DD 8F
 altd ldl pw, hl                ; 76 FD 8F
 altd ldl pw, ix                ; 76 DD 8C
 altd ldl pw, iy                ; 76 FD 8C
 altd ldl px, (sp)              ; 76 ED 13 00
 altd ldl px, (sp+0)            ; 76 ED 13 00
 altd ldl px, (sp+127)          ; 76 ED 13 7F
 altd ldl px, (sp+255)          ; 76 ED 13 FF
 altd ldl px, 0x1234            ; 76 ED 1D 34 12
 altd ldl px, de                ; 76 DD 9F
 altd ldl px, hl                ; 76 FD 9F
 altd ldl px, ix                ; 76 DD 9C
 altd ldl px, iy                ; 76 FD 9C
 altd ldl py, (sp)              ; 76 ED 23 00
 altd ldl py, (sp+0)            ; 76 ED 23 00
 altd ldl py, (sp+127)          ; 76 ED 23 7F
 altd ldl py, (sp+255)          ; 76 ED 23 FF
 altd ldl py, 0x1234            ; 76 ED 2D 34 12
 altd ldl py, de                ; 76 DD AF
 altd ldl py, hl                ; 76 FD AF
 altd ldl py, ix                ; 76 DD AC
 altd ldl py, iy                ; 76 FD AC
 altd ldl pz, (sp)              ; 76 ED 33 00
 altd ldl pz, (sp+0)            ; 76 ED 33 00
 altd ldl pz, (sp+127)          ; 76 ED 33 7F
 altd ldl pz, (sp+255)          ; 76 ED 33 FF
 altd ldl pz, 0x1234            ; 76 ED 3D 34 12
 altd ldl pz, de                ; 76 DD BF
 altd ldl pz, hl                ; 76 FD BF
 altd ldl pz, ix                ; 76 DD BC
 altd ldl pz, iy                ; 76 FD BC
 altd neg                       ; 76 ED 44
 altd neg bcde                  ; 76 DD 4D
 altd neg hl                    ; 76 4D
 altd neg jkhl                  ; 76 FD 4D
 altd or (hl)                   ; 76 7F B6
 altd or (ix)                   ; 76 DD B6 00
 altd or (ix+0)                 ; 76 DD B6 00
 altd or (ix+126)               ; 76 DD B6 7E
 altd or (ix-128)               ; 76 DD B6 80
 altd or (iy)                   ; 76 FD B6 00
 altd or (iy+0)                 ; 76 FD B6 00
 altd or (iy+126)               ; 76 FD B6 7E
 altd or (iy-128)               ; 76 FD B6 80
 altd or 0                      ; 76 F6 00
 altd or 127                    ; 76 F6 7F
 altd or 255                    ; 76 F6 FF
 altd or a                      ; 76 7F B7
 altd or b                      ; 76 7F B0
 altd or c                      ; 76 7F B1
 altd or d                      ; 76 7F B2
 altd or e                      ; 76 7F B3
 altd or h                      ; 76 7F B4
 altd or hl, de                 ; 76 EC
 altd or jkhl, bcde             ; 76 ED F6
 altd or l                      ; 76 7F B5
 altd pop af                    ; 76 F1
 altd pop bc                    ; 76 C1
 altd pop bcde                  ; 76 DD F1
 altd pop de                    ; 76 D1
 altd pop hl                    ; 76 E1
 altd pop jkhl                  ; 76 FD F1
 altd pop pw                    ; 76 ED C1
 altd pop px                    ; 76 ED D1
 altd pop py                    ; 76 ED E1
 altd pop pz                    ; 76 ED F1
 altd res 0, (hl)               ; 76 CB 86
 altd res 0, (ix)               ; 76 DD CB 00 86
 altd res 0, (ix+0)             ; 76 DD CB 00 86
 altd res 0, (ix+126)           ; 76 DD CB 7E 86
 altd res 0, (ix-128)           ; 76 DD CB 80 86
 altd res 0, (iy)               ; 76 FD CB 00 86
 altd res 0, (iy+0)             ; 76 FD CB 00 86
 altd res 0, (iy+126)           ; 76 FD CB 7E 86
 altd res 0, (iy-128)           ; 76 FD CB 80 86
 altd res 0, a                  ; 76 CB 87
 altd res 0, b                  ; 76 CB 80
 altd res 0, c                  ; 76 CB 81
 altd res 0, d                  ; 76 CB 82
 altd res 0, e                  ; 76 CB 83
 altd res 0, h                  ; 76 CB 84
 altd res 0, l                  ; 76 CB 85
 altd res 1, (hl)               ; 76 CB 8E
 altd res 1, (ix)               ; 76 DD CB 00 8E
 altd res 1, (ix+0)             ; 76 DD CB 00 8E
 altd res 1, (ix+126)           ; 76 DD CB 7E 8E
 altd res 1, (ix-128)           ; 76 DD CB 80 8E
 altd res 1, (iy)               ; 76 FD CB 00 8E
 altd res 1, (iy+0)             ; 76 FD CB 00 8E
 altd res 1, (iy+126)           ; 76 FD CB 7E 8E
 altd res 1, (iy-128)           ; 76 FD CB 80 8E
 altd res 1, a                  ; 76 CB 8F
 altd res 1, b                  ; 76 CB 88
 altd res 1, c                  ; 76 CB 89
 altd res 1, d                  ; 76 CB 8A
 altd res 1, e                  ; 76 CB 8B
 altd res 1, h                  ; 76 CB 8C
 altd res 1, l                  ; 76 CB 8D
 altd res 2, (hl)               ; 76 CB 96
 altd res 2, (ix)               ; 76 DD CB 00 96
 altd res 2, (ix+0)             ; 76 DD CB 00 96
 altd res 2, (ix+126)           ; 76 DD CB 7E 96
 altd res 2, (ix-128)           ; 76 DD CB 80 96
 altd res 2, (iy)               ; 76 FD CB 00 96
 altd res 2, (iy+0)             ; 76 FD CB 00 96
 altd res 2, (iy+126)           ; 76 FD CB 7E 96
 altd res 2, (iy-128)           ; 76 FD CB 80 96
 altd res 2, a                  ; 76 CB 97
 altd res 2, b                  ; 76 CB 90
 altd res 2, c                  ; 76 CB 91
 altd res 2, d                  ; 76 CB 92
 altd res 2, e                  ; 76 CB 93
 altd res 2, h                  ; 76 CB 94
 altd res 2, l                  ; 76 CB 95
 altd res 3, (hl)               ; 76 CB 9E
 altd res 3, (ix)               ; 76 DD CB 00 9E
 altd res 3, (ix+0)             ; 76 DD CB 00 9E
 altd res 3, (ix+126)           ; 76 DD CB 7E 9E
 altd res 3, (ix-128)           ; 76 DD CB 80 9E
 altd res 3, (iy)               ; 76 FD CB 00 9E
 altd res 3, (iy+0)             ; 76 FD CB 00 9E
 altd res 3, (iy+126)           ; 76 FD CB 7E 9E
 altd res 3, (iy-128)           ; 76 FD CB 80 9E
 altd res 3, a                  ; 76 CB 9F
 altd res 3, b                  ; 76 CB 98
 altd res 3, c                  ; 76 CB 99
 altd res 3, d                  ; 76 CB 9A
 altd res 3, e                  ; 76 CB 9B
 altd res 3, h                  ; 76 CB 9C
 altd res 3, l                  ; 76 CB 9D
 altd res 4, (hl)               ; 76 CB A6
 altd res 4, (ix)               ; 76 DD CB 00 A6
 altd res 4, (ix+0)             ; 76 DD CB 00 A6
 altd res 4, (ix+126)           ; 76 DD CB 7E A6
 altd res 4, (ix-128)           ; 76 DD CB 80 A6
 altd res 4, (iy)               ; 76 FD CB 00 A6
 altd res 4, (iy+0)             ; 76 FD CB 00 A6
 altd res 4, (iy+126)           ; 76 FD CB 7E A6
 altd res 4, (iy-128)           ; 76 FD CB 80 A6
 altd res 4, a                  ; 76 CB A7
 altd res 4, b                  ; 76 CB A0
 altd res 4, c                  ; 76 CB A1
 altd res 4, d                  ; 76 CB A2
 altd res 4, e                  ; 76 CB A3
 altd res 4, h                  ; 76 CB A4
 altd res 4, l                  ; 76 CB A5
 altd res 5, (hl)               ; 76 CB AE
 altd res 5, (ix)               ; 76 DD CB 00 AE
 altd res 5, (ix+0)             ; 76 DD CB 00 AE
 altd res 5, (ix+126)           ; 76 DD CB 7E AE
 altd res 5, (ix-128)           ; 76 DD CB 80 AE
 altd res 5, (iy)               ; 76 FD CB 00 AE
 altd res 5, (iy+0)             ; 76 FD CB 00 AE
 altd res 5, (iy+126)           ; 76 FD CB 7E AE
 altd res 5, (iy-128)           ; 76 FD CB 80 AE
 altd res 5, a                  ; 76 CB AF
 altd res 5, b                  ; 76 CB A8
 altd res 5, c                  ; 76 CB A9
 altd res 5, d                  ; 76 CB AA
 altd res 5, e                  ; 76 CB AB
 altd res 5, h                  ; 76 CB AC
 altd res 5, l                  ; 76 CB AD
 altd res 6, (hl)               ; 76 CB B6
 altd res 6, (ix)               ; 76 DD CB 00 B6
 altd res 6, (ix+0)             ; 76 DD CB 00 B6
 altd res 6, (ix+126)           ; 76 DD CB 7E B6
 altd res 6, (ix-128)           ; 76 DD CB 80 B6
 altd res 6, (iy)               ; 76 FD CB 00 B6
 altd res 6, (iy+0)             ; 76 FD CB 00 B6
 altd res 6, (iy+126)           ; 76 FD CB 7E B6
 altd res 6, (iy-128)           ; 76 FD CB 80 B6
 altd res 6, a                  ; 76 CB B7
 altd res 6, b                  ; 76 CB B0
 altd res 6, c                  ; 76 CB B1
 altd res 6, d                  ; 76 CB B2
 altd res 6, e                  ; 76 CB B3
 altd res 6, h                  ; 76 CB B4
 altd res 6, l                  ; 76 CB B5
 altd res 7, (hl)               ; 76 CB BE
 altd res 7, (ix)               ; 76 DD CB 00 BE
 altd res 7, (ix+0)             ; 76 DD CB 00 BE
 altd res 7, (ix+126)           ; 76 DD CB 7E BE
 altd res 7, (ix-128)           ; 76 DD CB 80 BE
 altd res 7, (iy)               ; 76 FD CB 00 BE
 altd res 7, (iy+0)             ; 76 FD CB 00 BE
 altd res 7, (iy+126)           ; 76 FD CB 7E BE
 altd res 7, (iy-128)           ; 76 FD CB 80 BE
 altd res 7, a                  ; 76 CB BF
 altd res 7, b                  ; 76 CB B8
 altd res 7, c                  ; 76 CB B9
 altd res 7, d                  ; 76 CB BA
 altd res 7, e                  ; 76 CB BB
 altd res 7, h                  ; 76 CB BC
 altd res 7, l                  ; 76 CB BD
 altd rl (hl)                   ; 76 CB 16
 altd rl (ix)                   ; 76 DD CB 00 16
 altd rl (ix+0)                 ; 76 DD CB 00 16
 altd rl (ix+126)               ; 76 DD CB 7E 16
 altd rl (ix-128)               ; 76 DD CB 80 16
 altd rl (iy)                   ; 76 FD CB 00 16
 altd rl (iy+0)                 ; 76 FD CB 00 16
 altd rl (iy+126)               ; 76 FD CB 7E 16
 altd rl (iy-128)               ; 76 FD CB 80 16
 altd rl 1, bcde                ; 76 DD 68
 altd rl 1, jkhl                ; 76 FD 68
 altd rl 2, bcde                ; 76 DD 69
 altd rl 2, jkhl                ; 76 FD 69
 altd rl 4, bcde                ; 76 DD 6B
 altd rl 4, jkhl                ; 76 FD 6B
 altd rl a                      ; 76 CB 17
 altd rl b                      ; 76 CB 10
 altd rl bc                     ; 76 62
 altd rl c                      ; 76 CB 11
 altd rl d                      ; 76 CB 12
 altd rl de                     ; 76 F3
 altd rl e                      ; 76 CB 13
 altd rl h                      ; 76 CB 14
 altd rl hl                     ; 76 42
 altd rl l                      ; 76 CB 15
 altd rla                       ; 76 17
 altd rlc (hl)                  ; 76 CB 06
 altd rlc (ix)                  ; 76 DD CB 00 06
 altd rlc (ix+0)                ; 76 DD CB 00 06
 altd rlc (ix+126)              ; 76 DD CB 7E 06
 altd rlc (ix-128)              ; 76 DD CB 80 06
 altd rlc (iy)                  ; 76 FD CB 00 06
 altd rlc (iy+0)                ; 76 FD CB 00 06
 altd rlc (iy+126)              ; 76 FD CB 7E 06
 altd rlc (iy-128)              ; 76 FD CB 80 06
 altd rlc 1, bcde               ; 76 DD 48
 altd rlc 1, jkhl               ; 76 FD 48
 altd rlc 2, bcde               ; 76 DD 49
 altd rlc 2, jkhl               ; 76 FD 49
 altd rlc 4, bcde               ; 76 DD 4B
 altd rlc 4, jkhl               ; 76 FD 4B
 altd rlc a                     ; 76 CB 07
 altd rlc b                     ; 76 CB 00
 altd rlc bc                    ; 76 60
 altd rlc c                     ; 76 CB 01
 altd rlc d                     ; 76 CB 02
 altd rlc de                    ; 76 50
 altd rlc e                     ; 76 CB 03
 altd rlc h                     ; 76 CB 04
 altd rlc l                     ; 76 CB 05
 altd rlca                      ; 76 07
 altd rr (hl)                   ; 76 CB 1E
 altd rr (ix)                   ; 76 DD CB 00 1E
 altd rr (ix+0)                 ; 76 DD CB 00 1E
 altd rr (ix+126)               ; 76 DD CB 7E 1E
 altd rr (ix-128)               ; 76 DD CB 80 1E
 altd rr (iy)                   ; 76 FD CB 00 1E
 altd rr (iy+0)                 ; 76 FD CB 00 1E
 altd rr (iy+126)               ; 76 FD CB 7E 1E
 altd rr (iy-128)               ; 76 FD CB 80 1E
 altd rr 1, bcde                ; 76 DD 78
 altd rr 1, jkhl                ; 76 FD 78
 altd rr 2, bcde                ; 76 DD 79
 altd rr 2, jkhl                ; 76 FD 79
 altd rr 4, bcde                ; 76 DD 7B
 altd rr 4, jkhl                ; 76 FD 7B
 altd rr a                      ; 76 CB 1F
 altd rr b                      ; 76 CB 18
 altd rr bc                     ; 76 63
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
 altd rrc (ix+0)                ; 76 DD CB 00 0E
 altd rrc (ix+126)              ; 76 DD CB 7E 0E
 altd rrc (ix-128)              ; 76 DD CB 80 0E
 altd rrc (iy)                  ; 76 FD CB 00 0E
 altd rrc (iy+0)                ; 76 FD CB 00 0E
 altd rrc (iy+126)              ; 76 FD CB 7E 0E
 altd rrc (iy-128)              ; 76 FD CB 80 0E
 altd rrc 1, bcde               ; 76 DD 58
 altd rrc 1, jkhl               ; 76 FD 58
 altd rrc 2, bcde               ; 76 DD 59
 altd rrc 2, jkhl               ; 76 FD 59
 altd rrc 4, bcde               ; 76 DD 5B
 altd rrc 4, jkhl               ; 76 FD 5B
 altd rrc a                     ; 76 CB 0F
 altd rrc b                     ; 76 CB 08
 altd rrc bc                    ; 76 61
 altd rrc c                     ; 76 CB 09
 altd rrc d                     ; 76 CB 0A
 altd rrc de                    ; 76 51
 altd rrc e                     ; 76 CB 0B
 altd rrc h                     ; 76 CB 0C
 altd rrc l                     ; 76 CB 0D
 altd rrca                      ; 76 0F
 altd sbc a, (hl)               ; 76 7F 9E
 altd sbc a, (ix)               ; 76 DD 9E 00
 altd sbc a, (ix+0)             ; 76 DD 9E 00
 altd sbc a, (ix+126)           ; 76 DD 9E 7E
 altd sbc a, (ix-128)           ; 76 DD 9E 80
 altd sbc a, (iy)               ; 76 FD 9E 00
 altd sbc a, (iy+0)             ; 76 FD 9E 00
 altd sbc a, (iy+126)           ; 76 FD 9E 7E
 altd sbc a, (iy-128)           ; 76 FD 9E 80
 altd sbc a, 0                  ; 76 DE 00
 altd sbc a, 127                ; 76 DE 7F
 altd sbc a, 255                ; 76 DE FF
 altd sbc a, a                  ; 76 7F 9F
 altd sbc a, b                  ; 76 7F 98
 altd sbc a, c                  ; 76 7F 99
 altd sbc a, d                  ; 76 7F 9A
 altd sbc a, e                  ; 76 7F 9B
 altd sbc a, h                  ; 76 7F 9C
 altd sbc a, l                  ; 76 7F 9D
 altd sbc hl, bc                ; 76 ED 42
 altd sbc hl, de                ; 76 ED 52
 altd sbc hl, hl                ; 76 ED 62
 altd sbc hl, sp                ; 76 ED 72
 altd sbox a                    ; 76 ED 02
 altd scf                       ; 76 37
 altd set 0, (hl)               ; 76 CB C6
 altd set 0, (ix)               ; 76 DD CB 00 C6
 altd set 0, (ix+0)             ; 76 DD CB 00 C6
 altd set 0, (ix+126)           ; 76 DD CB 7E C6
 altd set 0, (ix-128)           ; 76 DD CB 80 C6
 altd set 0, (iy)               ; 76 FD CB 00 C6
 altd set 0, (iy+0)             ; 76 FD CB 00 C6
 altd set 0, (iy+126)           ; 76 FD CB 7E C6
 altd set 0, (iy-128)           ; 76 FD CB 80 C6
 altd set 0, a                  ; 76 CB C7
 altd set 0, b                  ; 76 CB C0
 altd set 0, c                  ; 76 CB C1
 altd set 0, d                  ; 76 CB C2
 altd set 0, e                  ; 76 CB C3
 altd set 0, h                  ; 76 CB C4
 altd set 0, l                  ; 76 CB C5
 altd set 1, (hl)               ; 76 CB CE
 altd set 1, (ix)               ; 76 DD CB 00 CE
 altd set 1, (ix+0)             ; 76 DD CB 00 CE
 altd set 1, (ix+126)           ; 76 DD CB 7E CE
 altd set 1, (ix-128)           ; 76 DD CB 80 CE
 altd set 1, (iy)               ; 76 FD CB 00 CE
 altd set 1, (iy+0)             ; 76 FD CB 00 CE
 altd set 1, (iy+126)           ; 76 FD CB 7E CE
 altd set 1, (iy-128)           ; 76 FD CB 80 CE
 altd set 1, a                  ; 76 CB CF
 altd set 1, b                  ; 76 CB C8
 altd set 1, c                  ; 76 CB C9
 altd set 1, d                  ; 76 CB CA
 altd set 1, e                  ; 76 CB CB
 altd set 1, h                  ; 76 CB CC
 altd set 1, l                  ; 76 CB CD
 altd set 2, (hl)               ; 76 CB D6
 altd set 2, (ix)               ; 76 DD CB 00 D6
 altd set 2, (ix+0)             ; 76 DD CB 00 D6
 altd set 2, (ix+126)           ; 76 DD CB 7E D6
 altd set 2, (ix-128)           ; 76 DD CB 80 D6
 altd set 2, (iy)               ; 76 FD CB 00 D6
 altd set 2, (iy+0)             ; 76 FD CB 00 D6
 altd set 2, (iy+126)           ; 76 FD CB 7E D6
 altd set 2, (iy-128)           ; 76 FD CB 80 D6
 altd set 2, a                  ; 76 CB D7
 altd set 2, b                  ; 76 CB D0
 altd set 2, c                  ; 76 CB D1
 altd set 2, d                  ; 76 CB D2
 altd set 2, e                  ; 76 CB D3
 altd set 2, h                  ; 76 CB D4
 altd set 2, l                  ; 76 CB D5
 altd set 3, (hl)               ; 76 CB DE
 altd set 3, (ix)               ; 76 DD CB 00 DE
 altd set 3, (ix+0)             ; 76 DD CB 00 DE
 altd set 3, (ix+126)           ; 76 DD CB 7E DE
 altd set 3, (ix-128)           ; 76 DD CB 80 DE
 altd set 3, (iy)               ; 76 FD CB 00 DE
 altd set 3, (iy+0)             ; 76 FD CB 00 DE
 altd set 3, (iy+126)           ; 76 FD CB 7E DE
 altd set 3, (iy-128)           ; 76 FD CB 80 DE
 altd set 3, a                  ; 76 CB DF
 altd set 3, b                  ; 76 CB D8
 altd set 3, c                  ; 76 CB D9
 altd set 3, d                  ; 76 CB DA
 altd set 3, e                  ; 76 CB DB
 altd set 3, h                  ; 76 CB DC
 altd set 3, l                  ; 76 CB DD
 altd set 4, (hl)               ; 76 CB E6
 altd set 4, (ix)               ; 76 DD CB 00 E6
 altd set 4, (ix+0)             ; 76 DD CB 00 E6
 altd set 4, (ix+126)           ; 76 DD CB 7E E6
 altd set 4, (ix-128)           ; 76 DD CB 80 E6
 altd set 4, (iy)               ; 76 FD CB 00 E6
 altd set 4, (iy+0)             ; 76 FD CB 00 E6
 altd set 4, (iy+126)           ; 76 FD CB 7E E6
 altd set 4, (iy-128)           ; 76 FD CB 80 E6
 altd set 4, a                  ; 76 CB E7
 altd set 4, b                  ; 76 CB E0
 altd set 4, c                  ; 76 CB E1
 altd set 4, d                  ; 76 CB E2
 altd set 4, e                  ; 76 CB E3
 altd set 4, h                  ; 76 CB E4
 altd set 4, l                  ; 76 CB E5
 altd set 5, (hl)               ; 76 CB EE
 altd set 5, (ix)               ; 76 DD CB 00 EE
 altd set 5, (ix+0)             ; 76 DD CB 00 EE
 altd set 5, (ix+126)           ; 76 DD CB 7E EE
 altd set 5, (ix-128)           ; 76 DD CB 80 EE
 altd set 5, (iy)               ; 76 FD CB 00 EE
 altd set 5, (iy+0)             ; 76 FD CB 00 EE
 altd set 5, (iy+126)           ; 76 FD CB 7E EE
 altd set 5, (iy-128)           ; 76 FD CB 80 EE
 altd set 5, a                  ; 76 CB EF
 altd set 5, b                  ; 76 CB E8
 altd set 5, c                  ; 76 CB E9
 altd set 5, d                  ; 76 CB EA
 altd set 5, e                  ; 76 CB EB
 altd set 5, h                  ; 76 CB EC
 altd set 5, l                  ; 76 CB ED
 altd set 6, (hl)               ; 76 CB F6
 altd set 6, (ix)               ; 76 DD CB 00 F6
 altd set 6, (ix+0)             ; 76 DD CB 00 F6
 altd set 6, (ix+126)           ; 76 DD CB 7E F6
 altd set 6, (ix-128)           ; 76 DD CB 80 F6
 altd set 6, (iy)               ; 76 FD CB 00 F6
 altd set 6, (iy+0)             ; 76 FD CB 00 F6
 altd set 6, (iy+126)           ; 76 FD CB 7E F6
 altd set 6, (iy-128)           ; 76 FD CB 80 F6
 altd set 6, a                  ; 76 CB F7
 altd set 6, b                  ; 76 CB F0
 altd set 6, c                  ; 76 CB F1
 altd set 6, d                  ; 76 CB F2
 altd set 6, e                  ; 76 CB F3
 altd set 6, h                  ; 76 CB F4
 altd set 6, l                  ; 76 CB F5
 altd set 7, (hl)               ; 76 CB FE
 altd set 7, (ix)               ; 76 DD CB 00 FE
 altd set 7, (ix+0)             ; 76 DD CB 00 FE
 altd set 7, (ix+126)           ; 76 DD CB 7E FE
 altd set 7, (ix-128)           ; 76 DD CB 80 FE
 altd set 7, (iy)               ; 76 FD CB 00 FE
 altd set 7, (iy+0)             ; 76 FD CB 00 FE
 altd set 7, (iy+126)           ; 76 FD CB 7E FE
 altd set 7, (iy-128)           ; 76 FD CB 80 FE
 altd set 7, a                  ; 76 CB FF
 altd set 7, b                  ; 76 CB F8
 altd set 7, c                  ; 76 CB F9
 altd set 7, d                  ; 76 CB FA
 altd set 7, e                  ; 76 CB FB
 altd set 7, h                  ; 76 CB FC
 altd set 7, l                  ; 76 CB FD
 altd sla (hl)                  ; 76 CB 26
 altd sla (ix)                  ; 76 DD CB 00 26
 altd sla (ix+0)                ; 76 DD CB 00 26
 altd sla (ix+126)              ; 76 DD CB 7E 26
 altd sla (ix-128)              ; 76 DD CB 80 26
 altd sla (iy)                  ; 76 FD CB 00 26
 altd sla (iy+0)                ; 76 FD CB 00 26
 altd sla (iy+126)              ; 76 FD CB 7E 26
 altd sla (iy-128)              ; 76 FD CB 80 26
 altd sla 1, bcde               ; 76 DD 88
 altd sla 1, jkhl               ; 76 FD 88
 altd sla 2, bcde               ; 76 DD 89
 altd sla 2, jkhl               ; 76 FD 89
 altd sla 4, bcde               ; 76 DD 8B
 altd sla 4, jkhl               ; 76 FD 8B
 altd sla a                     ; 76 CB 27
 altd sla b                     ; 76 CB 20
 altd sla c                     ; 76 CB 21
 altd sla d                     ; 76 CB 22
 altd sla e                     ; 76 CB 23
 altd sla h                     ; 76 CB 24
 altd sla l                     ; 76 CB 25
 altd sll 1, bcde               ; 76 DD A8
 altd sll 1, jkhl               ; 76 FD A8
 altd sll 2, bcde               ; 76 DD A9
 altd sll 2, jkhl               ; 76 FD A9
 altd sll 4, bcde               ; 76 DD AB
 altd sll 4, jkhl               ; 76 FD AB
 altd sra (hl)                  ; 76 CB 2E
 altd sra (ix)                  ; 76 DD CB 00 2E
 altd sra (ix+0)                ; 76 DD CB 00 2E
 altd sra (ix+126)              ; 76 DD CB 7E 2E
 altd sra (ix-128)              ; 76 DD CB 80 2E
 altd sra (iy)                  ; 76 FD CB 00 2E
 altd sra (iy+0)                ; 76 FD CB 00 2E
 altd sra (iy+126)              ; 76 FD CB 7E 2E
 altd sra (iy-128)              ; 76 FD CB 80 2E
 altd sra 1, bcde               ; 76 DD 98
 altd sra 1, jkhl               ; 76 FD 98
 altd sra 2, bcde               ; 76 DD 99
 altd sra 2, jkhl               ; 76 FD 99
 altd sra 4, bcde               ; 76 DD 9B
 altd sra 4, jkhl               ; 76 FD 9B
 altd sra a                     ; 76 CB 2F
 altd sra b                     ; 76 CB 28
 altd sra c                     ; 76 CB 29
 altd sra d                     ; 76 CB 2A
 altd sra e                     ; 76 CB 2B
 altd sra h                     ; 76 CB 2C
 altd sra l                     ; 76 CB 2D
 altd srl (hl)                  ; 76 CB 3E
 altd srl (ix)                  ; 76 DD CB 00 3E
 altd srl (ix+0)                ; 76 DD CB 00 3E
 altd srl (ix+126)              ; 76 DD CB 7E 3E
 altd srl (ix-128)              ; 76 DD CB 80 3E
 altd srl (iy)                  ; 76 FD CB 00 3E
 altd srl (iy+0)                ; 76 FD CB 00 3E
 altd srl (iy+126)              ; 76 FD CB 7E 3E
 altd srl (iy-128)              ; 76 FD CB 80 3E
 altd srl 1, bcde               ; 76 DD B8
 altd srl 1, jkhl               ; 76 FD B8
 altd srl 2, bcde               ; 76 DD B9
 altd srl 2, jkhl               ; 76 FD B9
 altd srl 4, bcde               ; 76 DD BB
 altd srl 4, jkhl               ; 76 FD BB
 altd srl a                     ; 76 CB 3F
 altd srl b                     ; 76 CB 38
 altd srl c                     ; 76 CB 39
 altd srl d                     ; 76 CB 3A
 altd srl e                     ; 76 CB 3B
 altd srl h                     ; 76 CB 3C
 altd srl l                     ; 76 CB 3D
 altd sub (hl)                  ; 76 7F 96
 altd sub (ix)                  ; 76 DD 96 00
 altd sub (ix+0)                ; 76 DD 96 00
 altd sub (ix+126)              ; 76 DD 96 7E
 altd sub (ix-128)              ; 76 DD 96 80
 altd sub (iy)                  ; 76 FD 96 00
 altd sub (iy+0)                ; 76 FD 96 00
 altd sub (iy+126)              ; 76 FD 96 7E
 altd sub (iy-128)              ; 76 FD 96 80
 altd sub 0                     ; 76 D6 00
 altd sub 127                   ; 76 D6 7F
 altd sub 255                   ; 76 D6 FF
 altd sub a                     ; 76 7F 97
 altd sub b                     ; 76 7F 90
 altd sub c                     ; 76 7F 91
 altd sub d                     ; 76 7F 92
 altd sub e                     ; 76 7F 93
 altd sub h                     ; 76 7F 94
 altd sub hl, de                ; 76 55
 altd sub hl, jk                ; 76 45
 altd sub jkhl, bcde            ; 76 ED D6
 altd sub l                     ; 76 7F 95
 altd test bc                   ; 76 ED 4C
 altd test bcde                 ; 76 DD 5C
 altd test hl                   ; 76 4C
 altd test ix                   ; 76 DD 4C
 altd test iy                   ; 76 FD 4C
 altd test jkhl                 ; 76 FD 5C
 altd xor (hl)                  ; 76 7F AE
 altd xor (ix)                  ; 76 DD AE 00
 altd xor (ix+0)                ; 76 DD AE 00
 altd xor (ix+126)              ; 76 DD AE 7E
 altd xor (ix-128)              ; 76 DD AE 80
 altd xor (iy)                  ; 76 FD AE 00
 altd xor (iy+0)                ; 76 FD AE 00
 altd xor (iy+126)              ; 76 FD AE 7E
 altd xor (iy-128)              ; 76 FD AE 80
 altd xor 0                     ; 76 EE 00
 altd xor 127                   ; 76 EE 7F
 altd xor 255                   ; 76 EE FF
 altd xor a                     ; 76 7F AF
 altd xor b                     ; 76 7F A8
 altd xor c                     ; 76 7F A9
 altd xor d                     ; 76 7F AA
 altd xor e                     ; 76 7F AB
 altd xor h                     ; 76 7F AC
 altd xor hl, de                ; 76 54
 altd xor jkhl, bcde            ; 76 ED EE
 altd xor l                     ; 76 7F AD
 and (hl)                       ; 7F A6
 and (ix)                       ; DD A6 00
 and (ix+0)                     ; DD A6 00
 and (ix+126)                   ; DD A6 7E
 and (ix-128)                   ; DD A6 80
 and (iy)                       ; FD A6 00
 and (iy+0)                     ; FD A6 00
 and (iy+126)                   ; FD A6 7E
 and (iy-128)                   ; FD A6 80
 and 0                          ; E6 00
 and 127                        ; E6 7F
 and 255                        ; E6 FF
 and a                          ; 7F A7
 and a'                         ; 76 7F A7
 and b                          ; 7F A0
 and b'                         ; 76 7F A0
 and c                          ; 7F A1
 and c'                         ; 76 7F A1
 and d                          ; 7F A2
 and d'                         ; 76 7F A2
 and e                          ; 7F A3
 and e'                         ; 76 7F A3
 and h                          ; 7F A4
 and h'                         ; 76 7F A4
 and hl', de                    ; 76 DC
 and hl, de                     ; DC
 and ix, de                     ; DD DC
 and iy, de                     ; FD DC
 and jkhl', bcde                ; 76 ED E6
 and jkhl, bcde                 ; ED E6
 and l                          ; 7F A5
 and l'                         ; 76 7F A5
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
 bit 1, (ix)                    ; DD CB 00 4E
 bit 1, (ix+0)                  ; DD CB 00 4E
 bit 1, (ix+126)                ; DD CB 7E 4E
 bit 1, (ix-128)                ; DD CB 80 4E
 bit 1, (iy)                    ; FD CB 00 4E
 bit 1, (iy+0)                  ; FD CB 00 4E
 bit 1, (iy+126)                ; FD CB 7E 4E
 bit 1, (iy-128)                ; FD CB 80 4E
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
 bit 2, (ix)                    ; DD CB 00 56
 bit 2, (ix+0)                  ; DD CB 00 56
 bit 2, (ix+126)                ; DD CB 7E 56
 bit 2, (ix-128)                ; DD CB 80 56
 bit 2, (iy)                    ; FD CB 00 56
 bit 2, (iy+0)                  ; FD CB 00 56
 bit 2, (iy+126)                ; FD CB 7E 56
 bit 2, (iy-128)                ; FD CB 80 56
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
 bit 3, (ix)                    ; DD CB 00 5E
 bit 3, (ix+0)                  ; DD CB 00 5E
 bit 3, (ix+126)                ; DD CB 7E 5E
 bit 3, (ix-128)                ; DD CB 80 5E
 bit 3, (iy)                    ; FD CB 00 5E
 bit 3, (iy+0)                  ; FD CB 00 5E
 bit 3, (iy+126)                ; FD CB 7E 5E
 bit 3, (iy-128)                ; FD CB 80 5E
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
 bit 4, (ix)                    ; DD CB 00 66
 bit 4, (ix+0)                  ; DD CB 00 66
 bit 4, (ix+126)                ; DD CB 7E 66
 bit 4, (ix-128)                ; DD CB 80 66
 bit 4, (iy)                    ; FD CB 00 66
 bit 4, (iy+0)                  ; FD CB 00 66
 bit 4, (iy+126)                ; FD CB 7E 66
 bit 4, (iy-128)                ; FD CB 80 66
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
 bit 5, (ix)                    ; DD CB 00 6E
 bit 5, (ix+0)                  ; DD CB 00 6E
 bit 5, (ix+126)                ; DD CB 7E 6E
 bit 5, (ix-128)                ; DD CB 80 6E
 bit 5, (iy)                    ; FD CB 00 6E
 bit 5, (iy+0)                  ; FD CB 00 6E
 bit 5, (iy+126)                ; FD CB 7E 6E
 bit 5, (iy-128)                ; FD CB 80 6E
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
 bit 6, (ix)                    ; DD CB 00 76
 bit 6, (ix+0)                  ; DD CB 00 76
 bit 6, (ix+126)                ; DD CB 7E 76
 bit 6, (ix-128)                ; DD CB 80 76
 bit 6, (iy)                    ; FD CB 00 76
 bit 6, (iy+0)                  ; FD CB 00 76
 bit 6, (iy+126)                ; FD CB 7E 76
 bit 6, (iy-128)                ; FD CB 80 76
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
 bit 7, (ix)                    ; DD CB 00 7E
 bit 7, (ix+0)                  ; DD CB 00 7E
 bit 7, (ix+126)                ; DD CB 7E 7E
 bit 7, (ix-128)                ; DD CB 80 7E
 bit 7, (iy)                    ; FD CB 00 7E
 bit 7, (iy+0)                  ; FD CB 00 7E
 bit 7, (iy+126)                ; FD CB 7E 7E
 bit 7, (iy-128)                ; FD CB 80 7E
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
 bool ix                        ; DD CC
 bool iy                        ; FD CC
 call (hl)                      ; ED EA
 call (ix)                      ; DD EA
 call (iy)                      ; FD EA
 call 0x1234                    ; CD 34 12
 cbm 0                          ; ED 00 00
 cbm 127                        ; ED 00 7F
 cbm 255                        ; ED 00 FF
 ccf                            ; 3F
 ccf'                           ; 76 3F
 clr hl                         ; BF
 clr hl'                        ; 76 BF
 convc pw                       ; ED 0E
 convc px                       ; ED 1E
 convc py                       ; ED 2E
 convc pz                       ; ED 3E
 convd pw                       ; ED 0F
 convd px                       ; ED 1F
 convd py                       ; ED 2F
 convd pz                       ; ED 3F
 copy                           ; ED 80
 copyr                          ; ED 88
 cp (hl)                        ; 7F BE
 cp (ix)                        ; DD BE 00
 cp (ix+0)                      ; DD BE 00
 cp (ix+126)                    ; DD BE 7E
 cp (ix-128)                    ; DD BE 80
 cp (iy)                        ; FD BE 00
 cp (iy+0)                      ; FD BE 00
 cp (iy+126)                    ; FD BE 7E
 cp (iy-128)                    ; FD BE 80
 cp 0                           ; FE 00
 cp 127                         ; FE 7F
 cp 255                         ; FE FF
 cp a                           ; 7F BF
 cp a'                          ; 76 7F BF
 cp b                           ; 7F B8
 cp b'                          ; 76 7F B8
 cp c                           ; 7F B9
 cp c'                          ; 76 7F B9
 cp d                           ; 7F BA
 cp d'                          ; 76 7F BA
 cp e                           ; 7F BB
 cp e'                          ; 76 7F BB
 cp h                           ; 7F BC
 cp h'                          ; 76 7F BC
 cp hl', -128                   ; 76 48 80
 cp hl', 0                      ; 76 48 00
 cp hl', 126                    ; 76 48 7E
 cp hl', de                     ; 76 ED 48
 cp hl, -128                    ; 48 80
 cp hl, 0                       ; 48 00
 cp hl, 126                     ; 48 7E
 cp hl, de                      ; ED 48
 cp jkhl', bcde                 ; 76 ED 58
 cp jkhl, bcde                  ; ED 58
 cp l                           ; 7F BD
 cp l'                          ; 76 7F BD
 cpl                            ; 2F
 cpl a                          ; 2F
 cpl a'                         ; 76 2F
 dec (hl)                       ; 35
 dec (ix)                       ; DD 35 00
 dec (ix+0)                     ; DD 35 00
 dec (ix+126)                   ; DD 35 7E
 dec (ix-128)                   ; DD 35 80
 dec (iy)                       ; FD 35 00
 dec (iy+0)                     ; FD 35 00
 dec (iy+126)                   ; FD 35 7E
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
 djnz b', ASMPC                 ; 76 10 FD
 djnz b, ASMPC                  ; 10 FE
 dwjnz ASMPC                    ; ED 10 FD
 dwjnz bc', ASMPC               ; 76 ED 10 FC
 dwjnz bc, ASMPC                ; ED 10 FD
 ex (sp), hl                    ; ED 54
 ex (sp), hl'                   ; 76 ED 54
 ex (sp), ix                    ; DD E3
 ex (sp), iy                    ; FD E3
 ex af, af'                     ; 08
 ex bc', hl                     ; ED 74
 ex bc', hl'                    ; 76 ED 74
 ex bc, hl                      ; B3
 ex bc, hl'                     ; 76 B3
 ex de', hl                     ; E3
 ex de', hl'                    ; 76 E3
 ex de, hl                      ; EB
 ex de, hl'                     ; 76 EB
 ex jk', hl                     ; ED 7C
 ex jk', hl'                    ; 76 ED 7C
 ex jk, hl                      ; B9
 ex jk, hl'                     ; 76 B9
 ex jkhl, bcde                  ; B4
 exp                            ; ED D9
 exx                            ; D9
 flag c, hl                     ; ED DC
 flag gt, hl                    ; ED A4
 flag gtu, hl                   ; ED AC
 flag lt, hl                    ; ED B4
 flag nc, hl                    ; ED D4
 flag nz, hl                    ; ED C4
 flag v, hl                     ; ED BC
 flag z, hl                     ; ED CC
 fsyscall                       ; ED 55
 ibox a                         ; ED 12
 ibox a'                        ; 76 ED 12
 idet                           ; 5B
 inc (hl)                       ; 34
 inc (ix)                       ; DD 34 00
 inc (ix+0)                     ; DD 34 00
 inc (ix+126)                   ; DD 34 7E
 inc (ix-128)                   ; DD 34 80
 inc (iy)                       ; FD 34 00
 inc (iy+0)                     ; FD 34 00
 inc (iy+126)                   ; FD 34 7E
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
 ioe adc a', (hl)               ; DB 76 7F 8E
 ioe adc a', (ix)               ; DB 76 DD 8E 00
 ioe adc a', (ix+0)             ; DB 76 DD 8E 00
 ioe adc a', (ix+126)           ; DB 76 DD 8E 7E
 ioe adc a', (ix-128)           ; DB 76 DD 8E 80
 ioe adc a', (iy)               ; DB 76 FD 8E 00
 ioe adc a', (iy+0)             ; DB 76 FD 8E 00
 ioe adc a', (iy+126)           ; DB 76 FD 8E 7E
 ioe adc a', (iy-128)           ; DB 76 FD 8E 80
 ioe adc a, (hl)                ; DB 7F 8E
 ioe adc a, (ix)                ; DB DD 8E 00
 ioe adc a, (ix+0)              ; DB DD 8E 00
 ioe adc a, (ix+126)            ; DB DD 8E 7E
 ioe adc a, (ix-128)            ; DB DD 8E 80
 ioe adc a, (iy)                ; DB FD 8E 00
 ioe adc a, (iy+0)              ; DB FD 8E 00
 ioe adc a, (iy+126)            ; DB FD 8E 7E
 ioe adc a, (iy-128)            ; DB FD 8E 80
 ioe add a', (hl)               ; DB 76 7F 86
 ioe add a', (ix)               ; DB 76 DD 86 00
 ioe add a', (ix+0)             ; DB 76 DD 86 00
 ioe add a', (ix+126)           ; DB 76 DD 86 7E
 ioe add a', (ix-128)           ; DB 76 DD 86 80
 ioe add a', (iy)               ; DB 76 FD 86 00
 ioe add a', (iy+0)             ; DB 76 FD 86 00
 ioe add a', (iy+126)           ; DB 76 FD 86 7E
 ioe add a', (iy-128)           ; DB 76 FD 86 80
 ioe add a, (hl)                ; DB 7F 86
 ioe add a, (ix)                ; DB DD 86 00
 ioe add a, (ix+0)              ; DB DD 86 00
 ioe add a, (ix+126)            ; DB DD 86 7E
 ioe add a, (ix-128)            ; DB DD 86 80
 ioe add a, (iy)                ; DB FD 86 00
 ioe add a, (iy+0)              ; DB FD 86 00
 ioe add a, (iy+126)            ; DB FD 86 7E
 ioe add a, (iy-128)            ; DB FD 86 80
 ioe altd adc a, (hl)           ; DB 76 7F 8E
 ioe altd adc a, (ix)           ; DB 76 DD 8E 00
 ioe altd adc a, (ix+0)         ; DB 76 DD 8E 00
 ioe altd adc a, (ix+126)       ; DB 76 DD 8E 7E
 ioe altd adc a, (ix-128)       ; DB 76 DD 8E 80
 ioe altd adc a, (iy)           ; DB 76 FD 8E 00
 ioe altd adc a, (iy+0)         ; DB 76 FD 8E 00
 ioe altd adc a, (iy+126)       ; DB 76 FD 8E 7E
 ioe altd adc a, (iy-128)       ; DB 76 FD 8E 80
 ioe altd add a, (hl)           ; DB 76 7F 86
 ioe altd add a, (ix)           ; DB 76 DD 86 00
 ioe altd add a, (ix+0)         ; DB 76 DD 86 00
 ioe altd add a, (ix+126)       ; DB 76 DD 86 7E
 ioe altd add a, (ix-128)       ; DB 76 DD 86 80
 ioe altd add a, (iy)           ; DB 76 FD 86 00
 ioe altd add a, (iy+0)         ; DB 76 FD 86 00
 ioe altd add a, (iy+126)       ; DB 76 FD 86 7E
 ioe altd add a, (iy-128)       ; DB 76 FD 86 80
 ioe altd and (hl)              ; DB 76 7F A6
 ioe altd and (ix)              ; DB 76 DD A6 00
 ioe altd and (ix+0)            ; DB 76 DD A6 00
 ioe altd and (ix+126)          ; DB 76 DD A6 7E
 ioe altd and (ix-128)          ; DB 76 DD A6 80
 ioe altd and (iy)              ; DB 76 FD A6 00
 ioe altd and (iy+0)            ; DB 76 FD A6 00
 ioe altd and (iy+126)          ; DB 76 FD A6 7E
 ioe altd and (iy-128)          ; DB 76 FD A6 80
 ioe altd bit 0, (hl)           ; DB 76 CB 46
 ioe altd bit 0, (ix)           ; DB 76 DD CB 00 46
 ioe altd bit 0, (ix+0)         ; DB 76 DD CB 00 46
 ioe altd bit 0, (ix+126)       ; DB 76 DD CB 7E 46
 ioe altd bit 0, (ix-128)       ; DB 76 DD CB 80 46
 ioe altd bit 0, (iy)           ; DB 76 FD CB 00 46
 ioe altd bit 0, (iy+0)         ; DB 76 FD CB 00 46
 ioe altd bit 0, (iy+126)       ; DB 76 FD CB 7E 46
 ioe altd bit 0, (iy-128)       ; DB 76 FD CB 80 46
 ioe altd bit 1, (hl)           ; DB 76 CB 4E
 ioe altd bit 1, (ix)           ; DB 76 DD CB 00 4E
 ioe altd bit 1, (ix+0)         ; DB 76 DD CB 00 4E
 ioe altd bit 1, (ix+126)       ; DB 76 DD CB 7E 4E
 ioe altd bit 1, (ix-128)       ; DB 76 DD CB 80 4E
 ioe altd bit 1, (iy)           ; DB 76 FD CB 00 4E
 ioe altd bit 1, (iy+0)         ; DB 76 FD CB 00 4E
 ioe altd bit 1, (iy+126)       ; DB 76 FD CB 7E 4E
 ioe altd bit 1, (iy-128)       ; DB 76 FD CB 80 4E
 ioe altd bit 2, (hl)           ; DB 76 CB 56
 ioe altd bit 2, (ix)           ; DB 76 DD CB 00 56
 ioe altd bit 2, (ix+0)         ; DB 76 DD CB 00 56
 ioe altd bit 2, (ix+126)       ; DB 76 DD CB 7E 56
 ioe altd bit 2, (ix-128)       ; DB 76 DD CB 80 56
 ioe altd bit 2, (iy)           ; DB 76 FD CB 00 56
 ioe altd bit 2, (iy+0)         ; DB 76 FD CB 00 56
 ioe altd bit 2, (iy+126)       ; DB 76 FD CB 7E 56
 ioe altd bit 2, (iy-128)       ; DB 76 FD CB 80 56
 ioe altd bit 3, (hl)           ; DB 76 CB 5E
 ioe altd bit 3, (ix)           ; DB 76 DD CB 00 5E
 ioe altd bit 3, (ix+0)         ; DB 76 DD CB 00 5E
 ioe altd bit 3, (ix+126)       ; DB 76 DD CB 7E 5E
 ioe altd bit 3, (ix-128)       ; DB 76 DD CB 80 5E
 ioe altd bit 3, (iy)           ; DB 76 FD CB 00 5E
 ioe altd bit 3, (iy+0)         ; DB 76 FD CB 00 5E
 ioe altd bit 3, (iy+126)       ; DB 76 FD CB 7E 5E
 ioe altd bit 3, (iy-128)       ; DB 76 FD CB 80 5E
 ioe altd bit 4, (hl)           ; DB 76 CB 66
 ioe altd bit 4, (ix)           ; DB 76 DD CB 00 66
 ioe altd bit 4, (ix+0)         ; DB 76 DD CB 00 66
 ioe altd bit 4, (ix+126)       ; DB 76 DD CB 7E 66
 ioe altd bit 4, (ix-128)       ; DB 76 DD CB 80 66
 ioe altd bit 4, (iy)           ; DB 76 FD CB 00 66
 ioe altd bit 4, (iy+0)         ; DB 76 FD CB 00 66
 ioe altd bit 4, (iy+126)       ; DB 76 FD CB 7E 66
 ioe altd bit 4, (iy-128)       ; DB 76 FD CB 80 66
 ioe altd bit 5, (hl)           ; DB 76 CB 6E
 ioe altd bit 5, (ix)           ; DB 76 DD CB 00 6E
 ioe altd bit 5, (ix+0)         ; DB 76 DD CB 00 6E
 ioe altd bit 5, (ix+126)       ; DB 76 DD CB 7E 6E
 ioe altd bit 5, (ix-128)       ; DB 76 DD CB 80 6E
 ioe altd bit 5, (iy)           ; DB 76 FD CB 00 6E
 ioe altd bit 5, (iy+0)         ; DB 76 FD CB 00 6E
 ioe altd bit 5, (iy+126)       ; DB 76 FD CB 7E 6E
 ioe altd bit 5, (iy-128)       ; DB 76 FD CB 80 6E
 ioe altd bit 6, (hl)           ; DB 76 CB 76
 ioe altd bit 6, (ix)           ; DB 76 DD CB 00 76
 ioe altd bit 6, (ix+0)         ; DB 76 DD CB 00 76
 ioe altd bit 6, (ix+126)       ; DB 76 DD CB 7E 76
 ioe altd bit 6, (ix-128)       ; DB 76 DD CB 80 76
 ioe altd bit 6, (iy)           ; DB 76 FD CB 00 76
 ioe altd bit 6, (iy+0)         ; DB 76 FD CB 00 76
 ioe altd bit 6, (iy+126)       ; DB 76 FD CB 7E 76
 ioe altd bit 6, (iy-128)       ; DB 76 FD CB 80 76
 ioe altd bit 7, (hl)           ; DB 76 CB 7E
 ioe altd bit 7, (ix)           ; DB 76 DD CB 00 7E
 ioe altd bit 7, (ix+0)         ; DB 76 DD CB 00 7E
 ioe altd bit 7, (ix+126)       ; DB 76 DD CB 7E 7E
 ioe altd bit 7, (ix-128)       ; DB 76 DD CB 80 7E
 ioe altd bit 7, (iy)           ; DB 76 FD CB 00 7E
 ioe altd bit 7, (iy+0)         ; DB 76 FD CB 00 7E
 ioe altd bit 7, (iy+126)       ; DB 76 FD CB 7E 7E
 ioe altd bit 7, (iy-128)       ; DB 76 FD CB 80 7E
 ioe altd cp (hl)               ; DB 76 7F BE
 ioe altd cp (ix)               ; DB 76 DD BE 00
 ioe altd cp (ix+0)             ; DB 76 DD BE 00
 ioe altd cp (ix+126)           ; DB 76 DD BE 7E
 ioe altd cp (ix-128)           ; DB 76 DD BE 80
 ioe altd cp (iy)               ; DB 76 FD BE 00
 ioe altd cp (iy+0)             ; DB 76 FD BE 00
 ioe altd cp (iy+126)           ; DB 76 FD BE 7E
 ioe altd cp (iy-128)           ; DB 76 FD BE 80
 ioe altd dec (hl)              ; DB 76 35
 ioe altd dec (ix)              ; DB 76 DD 35 00
 ioe altd dec (ix+0)            ; DB 76 DD 35 00
 ioe altd dec (ix+126)          ; DB 76 DD 35 7E
 ioe altd dec (ix-128)          ; DB 76 DD 35 80
 ioe altd dec (iy)              ; DB 76 FD 35 00
 ioe altd dec (iy+0)            ; DB 76 FD 35 00
 ioe altd dec (iy+126)          ; DB 76 FD 35 7E
 ioe altd dec (iy-128)          ; DB 76 FD 35 80
 ioe altd inc (hl)              ; DB 76 34
 ioe altd inc (ix)              ; DB 76 DD 34 00
 ioe altd inc (ix+0)            ; DB 76 DD 34 00
 ioe altd inc (ix+126)          ; DB 76 DD 34 7E
 ioe altd inc (ix-128)          ; DB 76 DD 34 80
 ioe altd inc (iy)              ; DB 76 FD 34 00
 ioe altd inc (iy+0)            ; DB 76 FD 34 00
 ioe altd inc (iy+126)          ; DB 76 FD 34 7E
 ioe altd inc (iy-128)          ; DB 76 FD 34 80
 ioe altd ld a, (0x1234)        ; DB 76 3A 34 12
 ioe altd ld a, (bc)            ; DB 76 0A
 ioe altd ld a, (de)            ; DB 76 1A
 ioe altd ld a, (hl)            ; DB 76 7E
 ioe altd ld a, (ix)            ; DB 76 DD 7E 00
 ioe altd ld a, (ix+0)          ; DB 76 DD 7E 00
 ioe altd ld a, (ix+126)        ; DB 76 DD 7E 7E
 ioe altd ld a, (ix+a)          ; DB 76 DD 06
 ioe altd ld a, (ix-128)        ; DB 76 DD 7E 80
 ioe altd ld a, (iy)            ; DB 76 FD 7E 00
 ioe altd ld a, (iy+0)          ; DB 76 FD 7E 00
 ioe altd ld a, (iy+126)        ; DB 76 FD 7E 7E
 ioe altd ld a, (iy+a)          ; DB 76 FD 06
 ioe altd ld a, (iy-128)        ; DB 76 FD 7E 80
 ioe altd ld b, (hl)            ; DB 76 46
 ioe altd ld b, (ix)            ; DB 76 DD 46 00
 ioe altd ld b, (ix+0)          ; DB 76 DD 46 00
 ioe altd ld b, (ix+126)        ; DB 76 DD 46 7E
 ioe altd ld b, (ix-128)        ; DB 76 DD 46 80
 ioe altd ld b, (iy)            ; DB 76 FD 46 00
 ioe altd ld b, (iy+0)          ; DB 76 FD 46 00
 ioe altd ld b, (iy+126)        ; DB 76 FD 46 7E
 ioe altd ld b, (iy-128)        ; DB 76 FD 46 80
 ioe altd ld bc, (0x1234)       ; DB 76 ED 4B 34 12
 ioe altd ld bcde, (0x1234)     ; DB 76 93 34 12
 ioe altd ld bcde, (hl)         ; DB 76 DD 1A
 ioe altd ld bcde, (ix)         ; DB 76 DD CE 00
 ioe altd ld bcde, (ix+0)       ; DB 76 DD CE 00
 ioe altd ld bcde, (ix+126)     ; DB 76 DD CE 7E
 ioe altd ld bcde, (ix-128)     ; DB 76 DD CE 80
 ioe altd ld bcde, (iy)         ; DB 76 DD DE 00
 ioe altd ld bcde, (iy+0)       ; DB 76 DD DE 00
 ioe altd ld bcde, (iy+126)     ; DB 76 DD DE 7E
 ioe altd ld bcde, (iy-128)     ; DB 76 DD DE 80
 ioe altd ld c, (hl)            ; DB 76 4E
 ioe altd ld c, (ix)            ; DB 76 DD 4E 00
 ioe altd ld c, (ix+0)          ; DB 76 DD 4E 00
 ioe altd ld c, (ix+126)        ; DB 76 DD 4E 7E
 ioe altd ld c, (ix-128)        ; DB 76 DD 4E 80
 ioe altd ld c, (iy)            ; DB 76 FD 4E 00
 ioe altd ld c, (iy+0)          ; DB 76 FD 4E 00
 ioe altd ld c, (iy+126)        ; DB 76 FD 4E 7E
 ioe altd ld c, (iy-128)        ; DB 76 FD 4E 80
 ioe altd ld d, (hl)            ; DB 76 56
 ioe altd ld d, (ix)            ; DB 76 DD 56 00
 ioe altd ld d, (ix+0)          ; DB 76 DD 56 00
 ioe altd ld d, (ix+126)        ; DB 76 DD 56 7E
 ioe altd ld d, (ix-128)        ; DB 76 DD 56 80
 ioe altd ld d, (iy)            ; DB 76 FD 56 00
 ioe altd ld d, (iy+0)          ; DB 76 FD 56 00
 ioe altd ld d, (iy+126)        ; DB 76 FD 56 7E
 ioe altd ld d, (iy-128)        ; DB 76 FD 56 80
 ioe altd ld de, (0x1234)       ; DB 76 ED 5B 34 12
 ioe altd ld e, (hl)            ; DB 76 5E
 ioe altd ld e, (ix)            ; DB 76 DD 5E 00
 ioe altd ld e, (ix+0)          ; DB 76 DD 5E 00
 ioe altd ld e, (ix+126)        ; DB 76 DD 5E 7E
 ioe altd ld e, (ix-128)        ; DB 76 DD 5E 80
 ioe altd ld e, (iy)            ; DB 76 FD 5E 00
 ioe altd ld e, (iy+0)          ; DB 76 FD 5E 00
 ioe altd ld e, (iy+126)        ; DB 76 FD 5E 7E
 ioe altd ld e, (iy-128)        ; DB 76 FD 5E 80
 ioe altd ld h, (hl)            ; DB 76 66
 ioe altd ld h, (ix)            ; DB 76 DD 66 00
 ioe altd ld h, (ix+0)          ; DB 76 DD 66 00
 ioe altd ld h, (ix+126)        ; DB 76 DD 66 7E
 ioe altd ld h, (ix-128)        ; DB 76 DD 66 80
 ioe altd ld h, (iy)            ; DB 76 FD 66 00
 ioe altd ld h, (iy+0)          ; DB 76 FD 66 00
 ioe altd ld h, (iy+126)        ; DB 76 FD 66 7E
 ioe altd ld h, (iy-128)        ; DB 76 FD 66 80
 ioe altd ld hl, (0x1234)       ; DB 76 2A 34 12
 ioe altd ld hl, (hl)           ; DB 76 DD E4 00
 ioe altd ld hl, (hl+0)         ; DB 76 DD E4 00
 ioe altd ld hl, (hl+126)       ; DB 76 DD E4 7E
 ioe altd ld hl, (hl-128)       ; DB 76 DD E4 80
 ioe altd ld hl, (ix)           ; DB 76 E4 00
 ioe altd ld hl, (ix+0)         ; DB 76 E4 00
 ioe altd ld hl, (ix+126)       ; DB 76 E4 7E
 ioe altd ld hl, (ix-128)       ; DB 76 E4 80
 ioe altd ld hl, (iy)           ; DB 76 FD E4 00
 ioe altd ld hl, (iy+0)         ; DB 76 FD E4 00
 ioe altd ld hl, (iy+126)       ; DB 76 FD E4 7E
 ioe altd ld hl, (iy-128)       ; DB 76 FD E4 80
 ioe altd ld jk, (0x1234)       ; DB 76 99 34 12
 ioe altd ld jkhl, (0x1234)     ; DB 76 94 34 12
 ioe altd ld jkhl, (hl)         ; DB 76 FD 1A
 ioe altd ld jkhl, (ix)         ; DB 76 FD CE 00
 ioe altd ld jkhl, (ix+0)       ; DB 76 FD CE 00
 ioe altd ld jkhl, (ix+126)     ; DB 76 FD CE 7E
 ioe altd ld jkhl, (ix-128)     ; DB 76 FD CE 80
 ioe altd ld jkhl, (iy)         ; DB 76 FD DE 00
 ioe altd ld jkhl, (iy+0)       ; DB 76 FD DE 00
 ioe altd ld jkhl, (iy+126)     ; DB 76 FD DE 7E
 ioe altd ld jkhl, (iy-128)     ; DB 76 FD DE 80
 ioe altd ld l, (hl)            ; DB 76 6E
 ioe altd ld l, (ix)            ; DB 76 DD 6E 00
 ioe altd ld l, (ix+0)          ; DB 76 DD 6E 00
 ioe altd ld l, (ix+126)        ; DB 76 DD 6E 7E
 ioe altd ld l, (ix-128)        ; DB 76 DD 6E 80
 ioe altd ld l, (iy)            ; DB 76 FD 6E 00
 ioe altd ld l, (iy+0)          ; DB 76 FD 6E 00
 ioe altd ld l, (iy+126)        ; DB 76 FD 6E 7E
 ioe altd ld l, (iy-128)        ; DB 76 FD 6E 80
 ioe altd or (hl)               ; DB 76 7F B6
 ioe altd or (ix)               ; DB 76 DD B6 00
 ioe altd or (ix+0)             ; DB 76 DD B6 00
 ioe altd or (ix+126)           ; DB 76 DD B6 7E
 ioe altd or (ix-128)           ; DB 76 DD B6 80
 ioe altd or (iy)               ; DB 76 FD B6 00
 ioe altd or (iy+0)             ; DB 76 FD B6 00
 ioe altd or (iy+126)           ; DB 76 FD B6 7E
 ioe altd or (iy-128)           ; DB 76 FD B6 80
 ioe altd res 0, (hl)           ; DB 76 CB 86
 ioe altd res 0, (ix)           ; DB 76 DD CB 00 86
 ioe altd res 0, (ix+0)         ; DB 76 DD CB 00 86
 ioe altd res 0, (ix+126)       ; DB 76 DD CB 7E 86
 ioe altd res 0, (ix-128)       ; DB 76 DD CB 80 86
 ioe altd res 0, (iy)           ; DB 76 FD CB 00 86
 ioe altd res 0, (iy+0)         ; DB 76 FD CB 00 86
 ioe altd res 0, (iy+126)       ; DB 76 FD CB 7E 86
 ioe altd res 0, (iy-128)       ; DB 76 FD CB 80 86
 ioe altd res 1, (hl)           ; DB 76 CB 8E
 ioe altd res 1, (ix)           ; DB 76 DD CB 00 8E
 ioe altd res 1, (ix+0)         ; DB 76 DD CB 00 8E
 ioe altd res 1, (ix+126)       ; DB 76 DD CB 7E 8E
 ioe altd res 1, (ix-128)       ; DB 76 DD CB 80 8E
 ioe altd res 1, (iy)           ; DB 76 FD CB 00 8E
 ioe altd res 1, (iy+0)         ; DB 76 FD CB 00 8E
 ioe altd res 1, (iy+126)       ; DB 76 FD CB 7E 8E
 ioe altd res 1, (iy-128)       ; DB 76 FD CB 80 8E
 ioe altd res 2, (hl)           ; DB 76 CB 96
 ioe altd res 2, (ix)           ; DB 76 DD CB 00 96
 ioe altd res 2, (ix+0)         ; DB 76 DD CB 00 96
 ioe altd res 2, (ix+126)       ; DB 76 DD CB 7E 96
 ioe altd res 2, (ix-128)       ; DB 76 DD CB 80 96
 ioe altd res 2, (iy)           ; DB 76 FD CB 00 96
 ioe altd res 2, (iy+0)         ; DB 76 FD CB 00 96
 ioe altd res 2, (iy+126)       ; DB 76 FD CB 7E 96
 ioe altd res 2, (iy-128)       ; DB 76 FD CB 80 96
 ioe altd res 3, (hl)           ; DB 76 CB 9E
 ioe altd res 3, (ix)           ; DB 76 DD CB 00 9E
 ioe altd res 3, (ix+0)         ; DB 76 DD CB 00 9E
 ioe altd res 3, (ix+126)       ; DB 76 DD CB 7E 9E
 ioe altd res 3, (ix-128)       ; DB 76 DD CB 80 9E
 ioe altd res 3, (iy)           ; DB 76 FD CB 00 9E
 ioe altd res 3, (iy+0)         ; DB 76 FD CB 00 9E
 ioe altd res 3, (iy+126)       ; DB 76 FD CB 7E 9E
 ioe altd res 3, (iy-128)       ; DB 76 FD CB 80 9E
 ioe altd res 4, (hl)           ; DB 76 CB A6
 ioe altd res 4, (ix)           ; DB 76 DD CB 00 A6
 ioe altd res 4, (ix+0)         ; DB 76 DD CB 00 A6
 ioe altd res 4, (ix+126)       ; DB 76 DD CB 7E A6
 ioe altd res 4, (ix-128)       ; DB 76 DD CB 80 A6
 ioe altd res 4, (iy)           ; DB 76 FD CB 00 A6
 ioe altd res 4, (iy+0)         ; DB 76 FD CB 00 A6
 ioe altd res 4, (iy+126)       ; DB 76 FD CB 7E A6
 ioe altd res 4, (iy-128)       ; DB 76 FD CB 80 A6
 ioe altd res 5, (hl)           ; DB 76 CB AE
 ioe altd res 5, (ix)           ; DB 76 DD CB 00 AE
 ioe altd res 5, (ix+0)         ; DB 76 DD CB 00 AE
 ioe altd res 5, (ix+126)       ; DB 76 DD CB 7E AE
 ioe altd res 5, (ix-128)       ; DB 76 DD CB 80 AE
 ioe altd res 5, (iy)           ; DB 76 FD CB 00 AE
 ioe altd res 5, (iy+0)         ; DB 76 FD CB 00 AE
 ioe altd res 5, (iy+126)       ; DB 76 FD CB 7E AE
 ioe altd res 5, (iy-128)       ; DB 76 FD CB 80 AE
 ioe altd res 6, (hl)           ; DB 76 CB B6
 ioe altd res 6, (ix)           ; DB 76 DD CB 00 B6
 ioe altd res 6, (ix+0)         ; DB 76 DD CB 00 B6
 ioe altd res 6, (ix+126)       ; DB 76 DD CB 7E B6
 ioe altd res 6, (ix-128)       ; DB 76 DD CB 80 B6
 ioe altd res 6, (iy)           ; DB 76 FD CB 00 B6
 ioe altd res 6, (iy+0)         ; DB 76 FD CB 00 B6
 ioe altd res 6, (iy+126)       ; DB 76 FD CB 7E B6
 ioe altd res 6, (iy-128)       ; DB 76 FD CB 80 B6
 ioe altd res 7, (hl)           ; DB 76 CB BE
 ioe altd res 7, (ix)           ; DB 76 DD CB 00 BE
 ioe altd res 7, (ix+0)         ; DB 76 DD CB 00 BE
 ioe altd res 7, (ix+126)       ; DB 76 DD CB 7E BE
 ioe altd res 7, (ix-128)       ; DB 76 DD CB 80 BE
 ioe altd res 7, (iy)           ; DB 76 FD CB 00 BE
 ioe altd res 7, (iy+0)         ; DB 76 FD CB 00 BE
 ioe altd res 7, (iy+126)       ; DB 76 FD CB 7E BE
 ioe altd res 7, (iy-128)       ; DB 76 FD CB 80 BE
 ioe altd rl (hl)               ; DB 76 CB 16
 ioe altd rl (ix)               ; DB 76 DD CB 00 16
 ioe altd rl (ix+0)             ; DB 76 DD CB 00 16
 ioe altd rl (ix+126)           ; DB 76 DD CB 7E 16
 ioe altd rl (ix-128)           ; DB 76 DD CB 80 16
 ioe altd rl (iy)               ; DB 76 FD CB 00 16
 ioe altd rl (iy+0)             ; DB 76 FD CB 00 16
 ioe altd rl (iy+126)           ; DB 76 FD CB 7E 16
 ioe altd rl (iy-128)           ; DB 76 FD CB 80 16
 ioe altd rlc (hl)              ; DB 76 CB 06
 ioe altd rlc (ix)              ; DB 76 DD CB 00 06
 ioe altd rlc (ix+0)            ; DB 76 DD CB 00 06
 ioe altd rlc (ix+126)          ; DB 76 DD CB 7E 06
 ioe altd rlc (ix-128)          ; DB 76 DD CB 80 06
 ioe altd rlc (iy)              ; DB 76 FD CB 00 06
 ioe altd rlc (iy+0)            ; DB 76 FD CB 00 06
 ioe altd rlc (iy+126)          ; DB 76 FD CB 7E 06
 ioe altd rlc (iy-128)          ; DB 76 FD CB 80 06
 ioe altd rr (hl)               ; DB 76 CB 1E
 ioe altd rr (ix)               ; DB 76 DD CB 00 1E
 ioe altd rr (ix+0)             ; DB 76 DD CB 00 1E
 ioe altd rr (ix+126)           ; DB 76 DD CB 7E 1E
 ioe altd rr (ix-128)           ; DB 76 DD CB 80 1E
 ioe altd rr (iy)               ; DB 76 FD CB 00 1E
 ioe altd rr (iy+0)             ; DB 76 FD CB 00 1E
 ioe altd rr (iy+126)           ; DB 76 FD CB 7E 1E
 ioe altd rr (iy-128)           ; DB 76 FD CB 80 1E
 ioe altd rrc (hl)              ; DB 76 CB 0E
 ioe altd rrc (ix)              ; DB 76 DD CB 00 0E
 ioe altd rrc (ix+0)            ; DB 76 DD CB 00 0E
 ioe altd rrc (ix+126)          ; DB 76 DD CB 7E 0E
 ioe altd rrc (ix-128)          ; DB 76 DD CB 80 0E
 ioe altd rrc (iy)              ; DB 76 FD CB 00 0E
 ioe altd rrc (iy+0)            ; DB 76 FD CB 00 0E
 ioe altd rrc (iy+126)          ; DB 76 FD CB 7E 0E
 ioe altd rrc (iy-128)          ; DB 76 FD CB 80 0E
 ioe altd sbc a, (hl)           ; DB 76 7F 9E
 ioe altd sbc a, (ix)           ; DB 76 DD 9E 00
 ioe altd sbc a, (ix+0)         ; DB 76 DD 9E 00
 ioe altd sbc a, (ix+126)       ; DB 76 DD 9E 7E
 ioe altd sbc a, (ix-128)       ; DB 76 DD 9E 80
 ioe altd sbc a, (iy)           ; DB 76 FD 9E 00
 ioe altd sbc a, (iy+0)         ; DB 76 FD 9E 00
 ioe altd sbc a, (iy+126)       ; DB 76 FD 9E 7E
 ioe altd sbc a, (iy-128)       ; DB 76 FD 9E 80
 ioe altd set 0, (hl)           ; DB 76 CB C6
 ioe altd set 0, (ix)           ; DB 76 DD CB 00 C6
 ioe altd set 0, (ix+0)         ; DB 76 DD CB 00 C6
 ioe altd set 0, (ix+126)       ; DB 76 DD CB 7E C6
 ioe altd set 0, (ix-128)       ; DB 76 DD CB 80 C6
 ioe altd set 0, (iy)           ; DB 76 FD CB 00 C6
 ioe altd set 0, (iy+0)         ; DB 76 FD CB 00 C6
 ioe altd set 0, (iy+126)       ; DB 76 FD CB 7E C6
 ioe altd set 0, (iy-128)       ; DB 76 FD CB 80 C6
 ioe altd set 1, (hl)           ; DB 76 CB CE
 ioe altd set 1, (ix)           ; DB 76 DD CB 00 CE
 ioe altd set 1, (ix+0)         ; DB 76 DD CB 00 CE
 ioe altd set 1, (ix+126)       ; DB 76 DD CB 7E CE
 ioe altd set 1, (ix-128)       ; DB 76 DD CB 80 CE
 ioe altd set 1, (iy)           ; DB 76 FD CB 00 CE
 ioe altd set 1, (iy+0)         ; DB 76 FD CB 00 CE
 ioe altd set 1, (iy+126)       ; DB 76 FD CB 7E CE
 ioe altd set 1, (iy-128)       ; DB 76 FD CB 80 CE
 ioe altd set 2, (hl)           ; DB 76 CB D6
 ioe altd set 2, (ix)           ; DB 76 DD CB 00 D6
 ioe altd set 2, (ix+0)         ; DB 76 DD CB 00 D6
 ioe altd set 2, (ix+126)       ; DB 76 DD CB 7E D6
 ioe altd set 2, (ix-128)       ; DB 76 DD CB 80 D6
 ioe altd set 2, (iy)           ; DB 76 FD CB 00 D6
 ioe altd set 2, (iy+0)         ; DB 76 FD CB 00 D6
 ioe altd set 2, (iy+126)       ; DB 76 FD CB 7E D6
 ioe altd set 2, (iy-128)       ; DB 76 FD CB 80 D6
 ioe altd set 3, (hl)           ; DB 76 CB DE
 ioe altd set 3, (ix)           ; DB 76 DD CB 00 DE
 ioe altd set 3, (ix+0)         ; DB 76 DD CB 00 DE
 ioe altd set 3, (ix+126)       ; DB 76 DD CB 7E DE
 ioe altd set 3, (ix-128)       ; DB 76 DD CB 80 DE
 ioe altd set 3, (iy)           ; DB 76 FD CB 00 DE
 ioe altd set 3, (iy+0)         ; DB 76 FD CB 00 DE
 ioe altd set 3, (iy+126)       ; DB 76 FD CB 7E DE
 ioe altd set 3, (iy-128)       ; DB 76 FD CB 80 DE
 ioe altd set 4, (hl)           ; DB 76 CB E6
 ioe altd set 4, (ix)           ; DB 76 DD CB 00 E6
 ioe altd set 4, (ix+0)         ; DB 76 DD CB 00 E6
 ioe altd set 4, (ix+126)       ; DB 76 DD CB 7E E6
 ioe altd set 4, (ix-128)       ; DB 76 DD CB 80 E6
 ioe altd set 4, (iy)           ; DB 76 FD CB 00 E6
 ioe altd set 4, (iy+0)         ; DB 76 FD CB 00 E6
 ioe altd set 4, (iy+126)       ; DB 76 FD CB 7E E6
 ioe altd set 4, (iy-128)       ; DB 76 FD CB 80 E6
 ioe altd set 5, (hl)           ; DB 76 CB EE
 ioe altd set 5, (ix)           ; DB 76 DD CB 00 EE
 ioe altd set 5, (ix+0)         ; DB 76 DD CB 00 EE
 ioe altd set 5, (ix+126)       ; DB 76 DD CB 7E EE
 ioe altd set 5, (ix-128)       ; DB 76 DD CB 80 EE
 ioe altd set 5, (iy)           ; DB 76 FD CB 00 EE
 ioe altd set 5, (iy+0)         ; DB 76 FD CB 00 EE
 ioe altd set 5, (iy+126)       ; DB 76 FD CB 7E EE
 ioe altd set 5, (iy-128)       ; DB 76 FD CB 80 EE
 ioe altd set 6, (hl)           ; DB 76 CB F6
 ioe altd set 6, (ix)           ; DB 76 DD CB 00 F6
 ioe altd set 6, (ix+0)         ; DB 76 DD CB 00 F6
 ioe altd set 6, (ix+126)       ; DB 76 DD CB 7E F6
 ioe altd set 6, (ix-128)       ; DB 76 DD CB 80 F6
 ioe altd set 6, (iy)           ; DB 76 FD CB 00 F6
 ioe altd set 6, (iy+0)         ; DB 76 FD CB 00 F6
 ioe altd set 6, (iy+126)       ; DB 76 FD CB 7E F6
 ioe altd set 6, (iy-128)       ; DB 76 FD CB 80 F6
 ioe altd set 7, (hl)           ; DB 76 CB FE
 ioe altd set 7, (ix)           ; DB 76 DD CB 00 FE
 ioe altd set 7, (ix+0)         ; DB 76 DD CB 00 FE
 ioe altd set 7, (ix+126)       ; DB 76 DD CB 7E FE
 ioe altd set 7, (ix-128)       ; DB 76 DD CB 80 FE
 ioe altd set 7, (iy)           ; DB 76 FD CB 00 FE
 ioe altd set 7, (iy+0)         ; DB 76 FD CB 00 FE
 ioe altd set 7, (iy+126)       ; DB 76 FD CB 7E FE
 ioe altd set 7, (iy-128)       ; DB 76 FD CB 80 FE
 ioe altd sla (hl)              ; DB 76 CB 26
 ioe altd sla (ix)              ; DB 76 DD CB 00 26
 ioe altd sla (ix+0)            ; DB 76 DD CB 00 26
 ioe altd sla (ix+126)          ; DB 76 DD CB 7E 26
 ioe altd sla (ix-128)          ; DB 76 DD CB 80 26
 ioe altd sla (iy)              ; DB 76 FD CB 00 26
 ioe altd sla (iy+0)            ; DB 76 FD CB 00 26
 ioe altd sla (iy+126)          ; DB 76 FD CB 7E 26
 ioe altd sla (iy-128)          ; DB 76 FD CB 80 26
 ioe altd sra (hl)              ; DB 76 CB 2E
 ioe altd sra (ix)              ; DB 76 DD CB 00 2E
 ioe altd sra (ix+0)            ; DB 76 DD CB 00 2E
 ioe altd sra (ix+126)          ; DB 76 DD CB 7E 2E
 ioe altd sra (ix-128)          ; DB 76 DD CB 80 2E
 ioe altd sra (iy)              ; DB 76 FD CB 00 2E
 ioe altd sra (iy+0)            ; DB 76 FD CB 00 2E
 ioe altd sra (iy+126)          ; DB 76 FD CB 7E 2E
 ioe altd sra (iy-128)          ; DB 76 FD CB 80 2E
 ioe altd srl (hl)              ; DB 76 CB 3E
 ioe altd srl (ix)              ; DB 76 DD CB 00 3E
 ioe altd srl (ix+0)            ; DB 76 DD CB 00 3E
 ioe altd srl (ix+126)          ; DB 76 DD CB 7E 3E
 ioe altd srl (ix-128)          ; DB 76 DD CB 80 3E
 ioe altd srl (iy)              ; DB 76 FD CB 00 3E
 ioe altd srl (iy+0)            ; DB 76 FD CB 00 3E
 ioe altd srl (iy+126)          ; DB 76 FD CB 7E 3E
 ioe altd srl (iy-128)          ; DB 76 FD CB 80 3E
 ioe altd sub (hl)              ; DB 76 7F 96
 ioe altd sub (ix)              ; DB 76 DD 96 00
 ioe altd sub (ix+0)            ; DB 76 DD 96 00
 ioe altd sub (ix+126)          ; DB 76 DD 96 7E
 ioe altd sub (ix-128)          ; DB 76 DD 96 80
 ioe altd sub (iy)              ; DB 76 FD 96 00
 ioe altd sub (iy+0)            ; DB 76 FD 96 00
 ioe altd sub (iy+126)          ; DB 76 FD 96 7E
 ioe altd sub (iy-128)          ; DB 76 FD 96 80
 ioe altd xor (hl)              ; DB 76 7F AE
 ioe altd xor (ix)              ; DB 76 DD AE 00
 ioe altd xor (ix+0)            ; DB 76 DD AE 00
 ioe altd xor (ix+126)          ; DB 76 DD AE 7E
 ioe altd xor (ix-128)          ; DB 76 DD AE 80
 ioe altd xor (iy)              ; DB 76 FD AE 00
 ioe altd xor (iy+0)            ; DB 76 FD AE 00
 ioe altd xor (iy+126)          ; DB 76 FD AE 7E
 ioe altd xor (iy-128)          ; DB 76 FD AE 80
 ioe and (hl)                   ; DB 7F A6
 ioe and (ix)                   ; DB DD A6 00
 ioe and (ix+0)                 ; DB DD A6 00
 ioe and (ix+126)               ; DB DD A6 7E
 ioe and (ix-128)               ; DB DD A6 80
 ioe and (iy)                   ; DB FD A6 00
 ioe and (iy+0)                 ; DB FD A6 00
 ioe and (iy+126)               ; DB FD A6 7E
 ioe and (iy-128)               ; DB FD A6 80
 ioe bit 0, (hl)                ; DB CB 46
 ioe bit 0, (ix)                ; DB DD CB 00 46
 ioe bit 0, (ix+0)              ; DB DD CB 00 46
 ioe bit 0, (ix+126)            ; DB DD CB 7E 46
 ioe bit 0, (ix-128)            ; DB DD CB 80 46
 ioe bit 0, (iy)                ; DB FD CB 00 46
 ioe bit 0, (iy+0)              ; DB FD CB 00 46
 ioe bit 0, (iy+126)            ; DB FD CB 7E 46
 ioe bit 0, (iy-128)            ; DB FD CB 80 46
 ioe bit 1, (hl)                ; DB CB 4E
 ioe bit 1, (ix)                ; DB DD CB 00 4E
 ioe bit 1, (ix+0)              ; DB DD CB 00 4E
 ioe bit 1, (ix+126)            ; DB DD CB 7E 4E
 ioe bit 1, (ix-128)            ; DB DD CB 80 4E
 ioe bit 1, (iy)                ; DB FD CB 00 4E
 ioe bit 1, (iy+0)              ; DB FD CB 00 4E
 ioe bit 1, (iy+126)            ; DB FD CB 7E 4E
 ioe bit 1, (iy-128)            ; DB FD CB 80 4E
 ioe bit 2, (hl)                ; DB CB 56
 ioe bit 2, (ix)                ; DB DD CB 00 56
 ioe bit 2, (ix+0)              ; DB DD CB 00 56
 ioe bit 2, (ix+126)            ; DB DD CB 7E 56
 ioe bit 2, (ix-128)            ; DB DD CB 80 56
 ioe bit 2, (iy)                ; DB FD CB 00 56
 ioe bit 2, (iy+0)              ; DB FD CB 00 56
 ioe bit 2, (iy+126)            ; DB FD CB 7E 56
 ioe bit 2, (iy-128)            ; DB FD CB 80 56
 ioe bit 3, (hl)                ; DB CB 5E
 ioe bit 3, (ix)                ; DB DD CB 00 5E
 ioe bit 3, (ix+0)              ; DB DD CB 00 5E
 ioe bit 3, (ix+126)            ; DB DD CB 7E 5E
 ioe bit 3, (ix-128)            ; DB DD CB 80 5E
 ioe bit 3, (iy)                ; DB FD CB 00 5E
 ioe bit 3, (iy+0)              ; DB FD CB 00 5E
 ioe bit 3, (iy+126)            ; DB FD CB 7E 5E
 ioe bit 3, (iy-128)            ; DB FD CB 80 5E
 ioe bit 4, (hl)                ; DB CB 66
 ioe bit 4, (ix)                ; DB DD CB 00 66
 ioe bit 4, (ix+0)              ; DB DD CB 00 66
 ioe bit 4, (ix+126)            ; DB DD CB 7E 66
 ioe bit 4, (ix-128)            ; DB DD CB 80 66
 ioe bit 4, (iy)                ; DB FD CB 00 66
 ioe bit 4, (iy+0)              ; DB FD CB 00 66
 ioe bit 4, (iy+126)            ; DB FD CB 7E 66
 ioe bit 4, (iy-128)            ; DB FD CB 80 66
 ioe bit 5, (hl)                ; DB CB 6E
 ioe bit 5, (ix)                ; DB DD CB 00 6E
 ioe bit 5, (ix+0)              ; DB DD CB 00 6E
 ioe bit 5, (ix+126)            ; DB DD CB 7E 6E
 ioe bit 5, (ix-128)            ; DB DD CB 80 6E
 ioe bit 5, (iy)                ; DB FD CB 00 6E
 ioe bit 5, (iy+0)              ; DB FD CB 00 6E
 ioe bit 5, (iy+126)            ; DB FD CB 7E 6E
 ioe bit 5, (iy-128)            ; DB FD CB 80 6E
 ioe bit 6, (hl)                ; DB CB 76
 ioe bit 6, (ix)                ; DB DD CB 00 76
 ioe bit 6, (ix+0)              ; DB DD CB 00 76
 ioe bit 6, (ix+126)            ; DB DD CB 7E 76
 ioe bit 6, (ix-128)            ; DB DD CB 80 76
 ioe bit 6, (iy)                ; DB FD CB 00 76
 ioe bit 6, (iy+0)              ; DB FD CB 00 76
 ioe bit 6, (iy+126)            ; DB FD CB 7E 76
 ioe bit 6, (iy-128)            ; DB FD CB 80 76
 ioe bit 7, (hl)                ; DB CB 7E
 ioe bit 7, (ix)                ; DB DD CB 00 7E
 ioe bit 7, (ix+0)              ; DB DD CB 00 7E
 ioe bit 7, (ix+126)            ; DB DD CB 7E 7E
 ioe bit 7, (ix-128)            ; DB DD CB 80 7E
 ioe bit 7, (iy)                ; DB FD CB 00 7E
 ioe bit 7, (iy+0)              ; DB FD CB 00 7E
 ioe bit 7, (iy+126)            ; DB FD CB 7E 7E
 ioe bit 7, (iy-128)            ; DB FD CB 80 7E
 ioe cbm 0                      ; DB ED 00 00
 ioe cbm 127                    ; DB ED 00 7F
 ioe cbm 255                    ; DB ED 00 FF
 ioe cp (hl)                    ; DB 7F BE
 ioe cp (ix)                    ; DB DD BE 00
 ioe cp (ix+0)                  ; DB DD BE 00
 ioe cp (ix+126)                ; DB DD BE 7E
 ioe cp (ix-128)                ; DB DD BE 80
 ioe cp (iy)                    ; DB FD BE 00
 ioe cp (iy+0)                  ; DB FD BE 00
 ioe cp (iy+126)                ; DB FD BE 7E
 ioe cp (iy-128)                ; DB FD BE 80
 ioe dec (hl)                   ; DB 35
 ioe dec (ix)                   ; DB DD 35 00
 ioe dec (ix+0)                 ; DB DD 35 00
 ioe dec (ix+126)               ; DB DD 35 7E
 ioe dec (ix-128)               ; DB DD 35 80
 ioe dec (iy)                   ; DB FD 35 00
 ioe dec (iy+0)                 ; DB FD 35 00
 ioe dec (iy+126)               ; DB FD 35 7E
 ioe dec (iy-128)               ; DB FD 35 80
 ioe inc (hl)                   ; DB 34
 ioe inc (ix)                   ; DB DD 34 00
 ioe inc (ix+0)                 ; DB DD 34 00
 ioe inc (ix+126)               ; DB DD 34 7E
 ioe inc (ix-128)               ; DB DD 34 80
 ioe inc (iy)                   ; DB FD 34 00
 ioe inc (iy+0)                 ; DB FD 34 00
 ioe inc (iy+126)               ; DB FD 34 7E
 ioe inc (iy-128)               ; DB FD 34 80
 ioe ld (0x1234), a             ; DB 32 34 12
 ioe ld (0x1234), bc            ; DB ED 43 34 12
 ioe ld (0x1234), bcde          ; DB 83 34 12
 ioe ld (0x1234), de            ; DB ED 53 34 12
 ioe ld (0x1234), hl            ; DB 22 34 12
 ioe ld (0x1234), ix            ; DB DD 22 34 12
 ioe ld (0x1234), iy            ; DB FD 22 34 12
 ioe ld (0x1234), jk            ; DB 89 34 12
 ioe ld (0x1234), jkhl          ; DB 84 34 12
 ioe ld (0x1234), sp            ; DB ED 73 34 12
 ioe ld (bc), a                 ; DB 02
 ioe ld (de), a                 ; DB 12
 ioe ld (hl), 0                 ; DB 36 00
 ioe ld (hl), 127               ; DB 36 7F
 ioe ld (hl), 255               ; DB 36 FF
 ioe ld (hl), a                 ; DB 77
 ioe ld (hl), b                 ; DB 70
 ioe ld (hl), bcde              ; DB DD 1B
 ioe ld (hl), c                 ; DB 71
 ioe ld (hl), d                 ; DB 72
 ioe ld (hl), e                 ; DB 73
 ioe ld (hl), h                 ; DB 74
 ioe ld (hl), hl                ; DB DD F4 00
 ioe ld (hl), jkhl              ; DB FD 1B
 ioe ld (hl), l                 ; DB 75
 ioe ld (hl+0), hl              ; DB DD F4 00
 ioe ld (hl+126), hl            ; DB DD F4 7E
 ioe ld (hl-128), hl            ; DB DD F4 80
 ioe ld (ix), 0                 ; DB DD 36 00 00
 ioe ld (ix), 127               ; DB DD 36 00 7F
 ioe ld (ix), 255               ; DB DD 36 00 FF
 ioe ld (ix), a                 ; DB DD 77 00
 ioe ld (ix), b                 ; DB DD 70 00
 ioe ld (ix), bcde              ; DB DD CF 00
 ioe ld (ix), c                 ; DB DD 71 00
 ioe ld (ix), d                 ; DB DD 72 00
 ioe ld (ix), e                 ; DB DD 73 00
 ioe ld (ix), h                 ; DB DD 74 00
 ioe ld (ix), hl                ; DB F4 00
 ioe ld (ix), jkhl              ; DB FD CF 00
 ioe ld (ix), l                 ; DB DD 75 00
 ioe ld (ix+0), 0               ; DB DD 36 00 00
 ioe ld (ix+0), 127             ; DB DD 36 00 7F
 ioe ld (ix+0), 255             ; DB DD 36 00 FF
 ioe ld (ix+0), a               ; DB DD 77 00
 ioe ld (ix+0), b               ; DB DD 70 00
 ioe ld (ix+0), bcde            ; DB DD CF 00
 ioe ld (ix+0), c               ; DB DD 71 00
 ioe ld (ix+0), d               ; DB DD 72 00
 ioe ld (ix+0), e               ; DB DD 73 00
 ioe ld (ix+0), h               ; DB DD 74 00
 ioe ld (ix+0), hl              ; DB F4 00
 ioe ld (ix+0), jkhl            ; DB FD CF 00
 ioe ld (ix+0), l               ; DB DD 75 00
 ioe ld (ix+126), 0             ; DB DD 36 7E 00
 ioe ld (ix+126), 127           ; DB DD 36 7E 7F
 ioe ld (ix+126), 255           ; DB DD 36 7E FF
 ioe ld (ix+126), a             ; DB DD 77 7E
 ioe ld (ix+126), b             ; DB DD 70 7E
 ioe ld (ix+126), bcde          ; DB DD CF 7E
 ioe ld (ix+126), c             ; DB DD 71 7E
 ioe ld (ix+126), d             ; DB DD 72 7E
 ioe ld (ix+126), e             ; DB DD 73 7E
 ioe ld (ix+126), h             ; DB DD 74 7E
 ioe ld (ix+126), hl            ; DB F4 7E
 ioe ld (ix+126), jkhl          ; DB FD CF 7E
 ioe ld (ix+126), l             ; DB DD 75 7E
 ioe ld (ix-128), 0             ; DB DD 36 80 00
 ioe ld (ix-128), 127           ; DB DD 36 80 7F
 ioe ld (ix-128), 255           ; DB DD 36 80 FF
 ioe ld (ix-128), a             ; DB DD 77 80
 ioe ld (ix-128), b             ; DB DD 70 80
 ioe ld (ix-128), bcde          ; DB DD CF 80
 ioe ld (ix-128), c             ; DB DD 71 80
 ioe ld (ix-128), d             ; DB DD 72 80
 ioe ld (ix-128), e             ; DB DD 73 80
 ioe ld (ix-128), h             ; DB DD 74 80
 ioe ld (ix-128), hl            ; DB F4 80
 ioe ld (ix-128), jkhl          ; DB FD CF 80
 ioe ld (ix-128), l             ; DB DD 75 80
 ioe ld (iy), 0                 ; DB FD 36 00 00
 ioe ld (iy), 127               ; DB FD 36 00 7F
 ioe ld (iy), 255               ; DB FD 36 00 FF
 ioe ld (iy), a                 ; DB FD 77 00
 ioe ld (iy), b                 ; DB FD 70 00
 ioe ld (iy), bcde              ; DB DD DF 00
 ioe ld (iy), c                 ; DB FD 71 00
 ioe ld (iy), d                 ; DB FD 72 00
 ioe ld (iy), e                 ; DB FD 73 00
 ioe ld (iy), h                 ; DB FD 74 00
 ioe ld (iy), hl                ; DB FD F4 00
 ioe ld (iy), jkhl              ; DB FD DF 00
 ioe ld (iy), l                 ; DB FD 75 00
 ioe ld (iy+0), 0               ; DB FD 36 00 00
 ioe ld (iy+0), 127             ; DB FD 36 00 7F
 ioe ld (iy+0), 255             ; DB FD 36 00 FF
 ioe ld (iy+0), a               ; DB FD 77 00
 ioe ld (iy+0), b               ; DB FD 70 00
 ioe ld (iy+0), bcde            ; DB DD DF 00
 ioe ld (iy+0), c               ; DB FD 71 00
 ioe ld (iy+0), d               ; DB FD 72 00
 ioe ld (iy+0), e               ; DB FD 73 00
 ioe ld (iy+0), h               ; DB FD 74 00
 ioe ld (iy+0), hl              ; DB FD F4 00
 ioe ld (iy+0), jkhl            ; DB FD DF 00
 ioe ld (iy+0), l               ; DB FD 75 00
 ioe ld (iy+126), 0             ; DB FD 36 7E 00
 ioe ld (iy+126), 127           ; DB FD 36 7E 7F
 ioe ld (iy+126), 255           ; DB FD 36 7E FF
 ioe ld (iy+126), a             ; DB FD 77 7E
 ioe ld (iy+126), b             ; DB FD 70 7E
 ioe ld (iy+126), bcde          ; DB DD DF 7E
 ioe ld (iy+126), c             ; DB FD 71 7E
 ioe ld (iy+126), d             ; DB FD 72 7E
 ioe ld (iy+126), e             ; DB FD 73 7E
 ioe ld (iy+126), h             ; DB FD 74 7E
 ioe ld (iy+126), hl            ; DB FD F4 7E
 ioe ld (iy+126), jkhl          ; DB FD DF 7E
 ioe ld (iy+126), l             ; DB FD 75 7E
 ioe ld (iy-128), 0             ; DB FD 36 80 00
 ioe ld (iy-128), 127           ; DB FD 36 80 7F
 ioe ld (iy-128), 255           ; DB FD 36 80 FF
 ioe ld (iy-128), a             ; DB FD 77 80
 ioe ld (iy-128), b             ; DB FD 70 80
 ioe ld (iy-128), bcde          ; DB DD DF 80
 ioe ld (iy-128), c             ; DB FD 71 80
 ioe ld (iy-128), d             ; DB FD 72 80
 ioe ld (iy-128), e             ; DB FD 73 80
 ioe ld (iy-128), h             ; DB FD 74 80
 ioe ld (iy-128), hl            ; DB FD F4 80
 ioe ld (iy-128), jkhl          ; DB FD DF 80
 ioe ld (iy-128), l             ; DB FD 75 80
 ioe ld a', (0x1234)            ; DB 76 3A 34 12
 ioe ld a', (bc)                ; DB 76 0A
 ioe ld a', (de)                ; DB 76 1A
 ioe ld a', (hl)                ; DB 76 7E
 ioe ld a', (ix)                ; DB 76 DD 7E 00
 ioe ld a', (ix+0)              ; DB 76 DD 7E 00
 ioe ld a', (ix+126)            ; DB 76 DD 7E 7E
 ioe ld a', (ix+a)              ; DB 76 DD 06
 ioe ld a', (ix-128)            ; DB 76 DD 7E 80
 ioe ld a', (iy)                ; DB 76 FD 7E 00
 ioe ld a', (iy+0)              ; DB 76 FD 7E 00
 ioe ld a', (iy+126)            ; DB 76 FD 7E 7E
 ioe ld a', (iy+a)              ; DB 76 FD 06
 ioe ld a', (iy-128)            ; DB 76 FD 7E 80
 ioe ld a, (0x1234)             ; DB 3A 34 12
 ioe ld a, (bc)                 ; DB 0A
 ioe ld a, (de)                 ; DB 1A
 ioe ld a, (hl)                 ; DB 7E
 ioe ld a, (ix)                 ; DB DD 7E 00
 ioe ld a, (ix+0)               ; DB DD 7E 00
 ioe ld a, (ix+126)             ; DB DD 7E 7E
 ioe ld a, (ix+a)               ; DB DD 06
 ioe ld a, (ix-128)             ; DB DD 7E 80
 ioe ld a, (iy)                 ; DB FD 7E 00
 ioe ld a, (iy+0)               ; DB FD 7E 00
 ioe ld a, (iy+126)             ; DB FD 7E 7E
 ioe ld a, (iy+a)               ; DB FD 06
 ioe ld a, (iy-128)             ; DB FD 7E 80
 ioe ld b', (hl)                ; DB 76 46
 ioe ld b', (ix)                ; DB 76 DD 46 00
 ioe ld b', (ix+0)              ; DB 76 DD 46 00
 ioe ld b', (ix+126)            ; DB 76 DD 46 7E
 ioe ld b', (ix-128)            ; DB 76 DD 46 80
 ioe ld b', (iy)                ; DB 76 FD 46 00
 ioe ld b', (iy+0)              ; DB 76 FD 46 00
 ioe ld b', (iy+126)            ; DB 76 FD 46 7E
 ioe ld b', (iy-128)            ; DB 76 FD 46 80
 ioe ld b, (hl)                 ; DB 46
 ioe ld b, (ix)                 ; DB DD 46 00
 ioe ld b, (ix+0)               ; DB DD 46 00
 ioe ld b, (ix+126)             ; DB DD 46 7E
 ioe ld b, (ix-128)             ; DB DD 46 80
 ioe ld b, (iy)                 ; DB FD 46 00
 ioe ld b, (iy+0)               ; DB FD 46 00
 ioe ld b, (iy+126)             ; DB FD 46 7E
 ioe ld b, (iy-128)             ; DB FD 46 80
 ioe ld bc', (0x1234)           ; DB 76 ED 4B 34 12
 ioe ld bc, (0x1234)            ; DB ED 4B 34 12
 ioe ld bcde', (0x1234)         ; DB 76 93 34 12
 ioe ld bcde', (hl)             ; DB 76 DD 1A
 ioe ld bcde', (ix)             ; DB 76 DD CE 00
 ioe ld bcde', (ix+0)           ; DB 76 DD CE 00
 ioe ld bcde', (ix+126)         ; DB 76 DD CE 7E
 ioe ld bcde', (ix-128)         ; DB 76 DD CE 80
 ioe ld bcde', (iy)             ; DB 76 DD DE 00
 ioe ld bcde', (iy+0)           ; DB 76 DD DE 00
 ioe ld bcde', (iy+126)         ; DB 76 DD DE 7E
 ioe ld bcde', (iy-128)         ; DB 76 DD DE 80
 ioe ld bcde, (0x1234)          ; DB 93 34 12
 ioe ld bcde, (hl)              ; DB DD 1A
 ioe ld bcde, (ix)              ; DB DD CE 00
 ioe ld bcde, (ix+0)            ; DB DD CE 00
 ioe ld bcde, (ix+126)          ; DB DD CE 7E
 ioe ld bcde, (ix-128)          ; DB DD CE 80
 ioe ld bcde, (iy)              ; DB DD DE 00
 ioe ld bcde, (iy+0)            ; DB DD DE 00
 ioe ld bcde, (iy+126)          ; DB DD DE 7E
 ioe ld bcde, (iy-128)          ; DB DD DE 80
 ioe ld c', (hl)                ; DB 76 4E
 ioe ld c', (ix)                ; DB 76 DD 4E 00
 ioe ld c', (ix+0)              ; DB 76 DD 4E 00
 ioe ld c', (ix+126)            ; DB 76 DD 4E 7E
 ioe ld c', (ix-128)            ; DB 76 DD 4E 80
 ioe ld c', (iy)                ; DB 76 FD 4E 00
 ioe ld c', (iy+0)              ; DB 76 FD 4E 00
 ioe ld c', (iy+126)            ; DB 76 FD 4E 7E
 ioe ld c', (iy-128)            ; DB 76 FD 4E 80
 ioe ld c, (hl)                 ; DB 4E
 ioe ld c, (ix)                 ; DB DD 4E 00
 ioe ld c, (ix+0)               ; DB DD 4E 00
 ioe ld c, (ix+126)             ; DB DD 4E 7E
 ioe ld c, (ix-128)             ; DB DD 4E 80
 ioe ld c, (iy)                 ; DB FD 4E 00
 ioe ld c, (iy+0)               ; DB FD 4E 00
 ioe ld c, (iy+126)             ; DB FD 4E 7E
 ioe ld c, (iy-128)             ; DB FD 4E 80
 ioe ld d', (hl)                ; DB 76 56
 ioe ld d', (ix)                ; DB 76 DD 56 00
 ioe ld d', (ix+0)              ; DB 76 DD 56 00
 ioe ld d', (ix+126)            ; DB 76 DD 56 7E
 ioe ld d', (ix-128)            ; DB 76 DD 56 80
 ioe ld d', (iy)                ; DB 76 FD 56 00
 ioe ld d', (iy+0)              ; DB 76 FD 56 00
 ioe ld d', (iy+126)            ; DB 76 FD 56 7E
 ioe ld d', (iy-128)            ; DB 76 FD 56 80
 ioe ld d, (hl)                 ; DB 56
 ioe ld d, (ix)                 ; DB DD 56 00
 ioe ld d, (ix+0)               ; DB DD 56 00
 ioe ld d, (ix+126)             ; DB DD 56 7E
 ioe ld d, (ix-128)             ; DB DD 56 80
 ioe ld d, (iy)                 ; DB FD 56 00
 ioe ld d, (iy+0)               ; DB FD 56 00
 ioe ld d, (iy+126)             ; DB FD 56 7E
 ioe ld d, (iy-128)             ; DB FD 56 80
 ioe ld de', (0x1234)           ; DB 76 ED 5B 34 12
 ioe ld de, (0x1234)            ; DB ED 5B 34 12
 ioe ld e', (hl)                ; DB 76 5E
 ioe ld e', (ix)                ; DB 76 DD 5E 00
 ioe ld e', (ix+0)              ; DB 76 DD 5E 00
 ioe ld e', (ix+126)            ; DB 76 DD 5E 7E
 ioe ld e', (ix-128)            ; DB 76 DD 5E 80
 ioe ld e', (iy)                ; DB 76 FD 5E 00
 ioe ld e', (iy+0)              ; DB 76 FD 5E 00
 ioe ld e', (iy+126)            ; DB 76 FD 5E 7E
 ioe ld e', (iy-128)            ; DB 76 FD 5E 80
 ioe ld e, (hl)                 ; DB 5E
 ioe ld e, (ix)                 ; DB DD 5E 00
 ioe ld e, (ix+0)               ; DB DD 5E 00
 ioe ld e, (ix+126)             ; DB DD 5E 7E
 ioe ld e, (ix-128)             ; DB DD 5E 80
 ioe ld e, (iy)                 ; DB FD 5E 00
 ioe ld e, (iy+0)               ; DB FD 5E 00
 ioe ld e, (iy+126)             ; DB FD 5E 7E
 ioe ld e, (iy-128)             ; DB FD 5E 80
 ioe ld h', (hl)                ; DB 76 66
 ioe ld h', (ix)                ; DB 76 DD 66 00
 ioe ld h', (ix+0)              ; DB 76 DD 66 00
 ioe ld h', (ix+126)            ; DB 76 DD 66 7E
 ioe ld h', (ix-128)            ; DB 76 DD 66 80
 ioe ld h', (iy)                ; DB 76 FD 66 00
 ioe ld h', (iy+0)              ; DB 76 FD 66 00
 ioe ld h', (iy+126)            ; DB 76 FD 66 7E
 ioe ld h', (iy-128)            ; DB 76 FD 66 80
 ioe ld h, (hl)                 ; DB 66
 ioe ld h, (ix)                 ; DB DD 66 00
 ioe ld h, (ix+0)               ; DB DD 66 00
 ioe ld h, (ix+126)             ; DB DD 66 7E
 ioe ld h, (ix-128)             ; DB DD 66 80
 ioe ld h, (iy)                 ; DB FD 66 00
 ioe ld h, (iy+0)               ; DB FD 66 00
 ioe ld h, (iy+126)             ; DB FD 66 7E
 ioe ld h, (iy-128)             ; DB FD 66 80
 ioe ld hl', (0x1234)           ; DB 76 2A 34 12
 ioe ld hl', (hl)               ; DB 76 DD E4 00
 ioe ld hl', (hl+0)             ; DB 76 DD E4 00
 ioe ld hl', (hl+126)           ; DB 76 DD E4 7E
 ioe ld hl', (hl-128)           ; DB 76 DD E4 80
 ioe ld hl', (ix)               ; DB 76 E4 00
 ioe ld hl', (ix+0)             ; DB 76 E4 00
 ioe ld hl', (ix+126)           ; DB 76 E4 7E
 ioe ld hl', (ix-128)           ; DB 76 E4 80
 ioe ld hl', (iy)               ; DB 76 FD E4 00
 ioe ld hl', (iy+0)             ; DB 76 FD E4 00
 ioe ld hl', (iy+126)           ; DB 76 FD E4 7E
 ioe ld hl', (iy-128)           ; DB 76 FD E4 80
 ioe ld hl, (0x1234)            ; DB 2A 34 12
 ioe ld hl, (hl)                ; DB DD E4 00
 ioe ld hl, (hl+0)              ; DB DD E4 00
 ioe ld hl, (hl+126)            ; DB DD E4 7E
 ioe ld hl, (hl-128)            ; DB DD E4 80
 ioe ld hl, (ix)                ; DB E4 00
 ioe ld hl, (ix+0)              ; DB E4 00
 ioe ld hl, (ix+126)            ; DB E4 7E
 ioe ld hl, (ix-128)            ; DB E4 80
 ioe ld hl, (iy)                ; DB FD E4 00
 ioe ld hl, (iy+0)              ; DB FD E4 00
 ioe ld hl, (iy+126)            ; DB FD E4 7E
 ioe ld hl, (iy-128)            ; DB FD E4 80
 ioe ld ix, (0x1234)            ; DB DD 2A 34 12
 ioe ld iy, (0x1234)            ; DB FD 2A 34 12
 ioe ld jk', (0x1234)           ; DB 76 99 34 12
 ioe ld jk, (0x1234)            ; DB 99 34 12
 ioe ld jkhl', (0x1234)         ; DB 76 94 34 12
 ioe ld jkhl', (hl)             ; DB 76 FD 1A
 ioe ld jkhl', (ix)             ; DB 76 FD CE 00
 ioe ld jkhl', (ix+0)           ; DB 76 FD CE 00
 ioe ld jkhl', (ix+126)         ; DB 76 FD CE 7E
 ioe ld jkhl', (ix-128)         ; DB 76 FD CE 80
 ioe ld jkhl', (iy)             ; DB 76 FD DE 00
 ioe ld jkhl', (iy+0)           ; DB 76 FD DE 00
 ioe ld jkhl', (iy+126)         ; DB 76 FD DE 7E
 ioe ld jkhl', (iy-128)         ; DB 76 FD DE 80
 ioe ld jkhl, (0x1234)          ; DB 94 34 12
 ioe ld jkhl, (hl)              ; DB FD 1A
 ioe ld jkhl, (ix)              ; DB FD CE 00
 ioe ld jkhl, (ix+0)            ; DB FD CE 00
 ioe ld jkhl, (ix+126)          ; DB FD CE 7E
 ioe ld jkhl, (ix-128)          ; DB FD CE 80
 ioe ld jkhl, (iy)              ; DB FD DE 00
 ioe ld jkhl, (iy+0)            ; DB FD DE 00
 ioe ld jkhl, (iy+126)          ; DB FD DE 7E
 ioe ld jkhl, (iy-128)          ; DB FD DE 80
 ioe ld l', (hl)                ; DB 76 6E
 ioe ld l', (ix)                ; DB 76 DD 6E 00
 ioe ld l', (ix+0)              ; DB 76 DD 6E 00
 ioe ld l', (ix+126)            ; DB 76 DD 6E 7E
 ioe ld l', (ix-128)            ; DB 76 DD 6E 80
 ioe ld l', (iy)                ; DB 76 FD 6E 00
 ioe ld l', (iy+0)              ; DB 76 FD 6E 00
 ioe ld l', (iy+126)            ; DB 76 FD 6E 7E
 ioe ld l', (iy-128)            ; DB 76 FD 6E 80
 ioe ld l, (hl)                 ; DB 6E
 ioe ld l, (ix)                 ; DB DD 6E 00
 ioe ld l, (ix+0)               ; DB DD 6E 00
 ioe ld l, (ix+126)             ; DB DD 6E 7E
 ioe ld l, (ix-128)             ; DB DD 6E 80
 ioe ld l, (iy)                 ; DB FD 6E 00
 ioe ld l, (iy+0)               ; DB FD 6E 00
 ioe ld l, (iy+126)             ; DB FD 6E 7E
 ioe ld l, (iy-128)             ; DB FD 6E 80
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
 ioe or (hl)                    ; DB 7F B6
 ioe or (ix)                    ; DB DD B6 00
 ioe or (ix+0)                  ; DB DD B6 00
 ioe or (ix+126)                ; DB DD B6 7E
 ioe or (ix-128)                ; DB DD B6 80
 ioe or (iy)                    ; DB FD B6 00
 ioe or (iy+0)                  ; DB FD B6 00
 ioe or (iy+126)                ; DB FD B6 7E
 ioe or (iy-128)                ; DB FD B6 80
 ioe res 0, (hl)                ; DB CB 86
 ioe res 0, (ix)                ; DB DD CB 00 86
 ioe res 0, (ix+0)              ; DB DD CB 00 86
 ioe res 0, (ix+126)            ; DB DD CB 7E 86
 ioe res 0, (ix-128)            ; DB DD CB 80 86
 ioe res 0, (iy)                ; DB FD CB 00 86
 ioe res 0, (iy+0)              ; DB FD CB 00 86
 ioe res 0, (iy+126)            ; DB FD CB 7E 86
 ioe res 0, (iy-128)            ; DB FD CB 80 86
 ioe res 1, (hl)                ; DB CB 8E
 ioe res 1, (ix)                ; DB DD CB 00 8E
 ioe res 1, (ix+0)              ; DB DD CB 00 8E
 ioe res 1, (ix+126)            ; DB DD CB 7E 8E
 ioe res 1, (ix-128)            ; DB DD CB 80 8E
 ioe res 1, (iy)                ; DB FD CB 00 8E
 ioe res 1, (iy+0)              ; DB FD CB 00 8E
 ioe res 1, (iy+126)            ; DB FD CB 7E 8E
 ioe res 1, (iy-128)            ; DB FD CB 80 8E
 ioe res 2, (hl)                ; DB CB 96
 ioe res 2, (ix)                ; DB DD CB 00 96
 ioe res 2, (ix+0)              ; DB DD CB 00 96
 ioe res 2, (ix+126)            ; DB DD CB 7E 96
 ioe res 2, (ix-128)            ; DB DD CB 80 96
 ioe res 2, (iy)                ; DB FD CB 00 96
 ioe res 2, (iy+0)              ; DB FD CB 00 96
 ioe res 2, (iy+126)            ; DB FD CB 7E 96
 ioe res 2, (iy-128)            ; DB FD CB 80 96
 ioe res 3, (hl)                ; DB CB 9E
 ioe res 3, (ix)                ; DB DD CB 00 9E
 ioe res 3, (ix+0)              ; DB DD CB 00 9E
 ioe res 3, (ix+126)            ; DB DD CB 7E 9E
 ioe res 3, (ix-128)            ; DB DD CB 80 9E
 ioe res 3, (iy)                ; DB FD CB 00 9E
 ioe res 3, (iy+0)              ; DB FD CB 00 9E
 ioe res 3, (iy+126)            ; DB FD CB 7E 9E
 ioe res 3, (iy-128)            ; DB FD CB 80 9E
 ioe res 4, (hl)                ; DB CB A6
 ioe res 4, (ix)                ; DB DD CB 00 A6
 ioe res 4, (ix+0)              ; DB DD CB 00 A6
 ioe res 4, (ix+126)            ; DB DD CB 7E A6
 ioe res 4, (ix-128)            ; DB DD CB 80 A6
 ioe res 4, (iy)                ; DB FD CB 00 A6
 ioe res 4, (iy+0)              ; DB FD CB 00 A6
 ioe res 4, (iy+126)            ; DB FD CB 7E A6
 ioe res 4, (iy-128)            ; DB FD CB 80 A6
 ioe res 5, (hl)                ; DB CB AE
 ioe res 5, (ix)                ; DB DD CB 00 AE
 ioe res 5, (ix+0)              ; DB DD CB 00 AE
 ioe res 5, (ix+126)            ; DB DD CB 7E AE
 ioe res 5, (ix-128)            ; DB DD CB 80 AE
 ioe res 5, (iy)                ; DB FD CB 00 AE
 ioe res 5, (iy+0)              ; DB FD CB 00 AE
 ioe res 5, (iy+126)            ; DB FD CB 7E AE
 ioe res 5, (iy-128)            ; DB FD CB 80 AE
 ioe res 6, (hl)                ; DB CB B6
 ioe res 6, (ix)                ; DB DD CB 00 B6
 ioe res 6, (ix+0)              ; DB DD CB 00 B6
 ioe res 6, (ix+126)            ; DB DD CB 7E B6
 ioe res 6, (ix-128)            ; DB DD CB 80 B6
 ioe res 6, (iy)                ; DB FD CB 00 B6
 ioe res 6, (iy+0)              ; DB FD CB 00 B6
 ioe res 6, (iy+126)            ; DB FD CB 7E B6
 ioe res 6, (iy-128)            ; DB FD CB 80 B6
 ioe res 7, (hl)                ; DB CB BE
 ioe res 7, (ix)                ; DB DD CB 00 BE
 ioe res 7, (ix+0)              ; DB DD CB 00 BE
 ioe res 7, (ix+126)            ; DB DD CB 7E BE
 ioe res 7, (ix-128)            ; DB DD CB 80 BE
 ioe res 7, (iy)                ; DB FD CB 00 BE
 ioe res 7, (iy+0)              ; DB FD CB 00 BE
 ioe res 7, (iy+126)            ; DB FD CB 7E BE
 ioe res 7, (iy-128)            ; DB FD CB 80 BE
 ioe rl (hl)                    ; DB CB 16
 ioe rl (ix)                    ; DB DD CB 00 16
 ioe rl (ix+0)                  ; DB DD CB 00 16
 ioe rl (ix+126)                ; DB DD CB 7E 16
 ioe rl (ix-128)                ; DB DD CB 80 16
 ioe rl (iy)                    ; DB FD CB 00 16
 ioe rl (iy+0)                  ; DB FD CB 00 16
 ioe rl (iy+126)                ; DB FD CB 7E 16
 ioe rl (iy-128)                ; DB FD CB 80 16
 ioe rlc (hl)                   ; DB CB 06
 ioe rlc (ix)                   ; DB DD CB 00 06
 ioe rlc (ix+0)                 ; DB DD CB 00 06
 ioe rlc (ix+126)               ; DB DD CB 7E 06
 ioe rlc (ix-128)               ; DB DD CB 80 06
 ioe rlc (iy)                   ; DB FD CB 00 06
 ioe rlc (iy+0)                 ; DB FD CB 00 06
 ioe rlc (iy+126)               ; DB FD CB 7E 06
 ioe rlc (iy-128)               ; DB FD CB 80 06
 ioe rr (hl)                    ; DB CB 1E
 ioe rr (ix)                    ; DB DD CB 00 1E
 ioe rr (ix+0)                  ; DB DD CB 00 1E
 ioe rr (ix+126)                ; DB DD CB 7E 1E
 ioe rr (ix-128)                ; DB DD CB 80 1E
 ioe rr (iy)                    ; DB FD CB 00 1E
 ioe rr (iy+0)                  ; DB FD CB 00 1E
 ioe rr (iy+126)                ; DB FD CB 7E 1E
 ioe rr (iy-128)                ; DB FD CB 80 1E
 ioe rrc (hl)                   ; DB CB 0E
 ioe rrc (ix)                   ; DB DD CB 00 0E
 ioe rrc (ix+0)                 ; DB DD CB 00 0E
 ioe rrc (ix+126)               ; DB DD CB 7E 0E
 ioe rrc (ix-128)               ; DB DD CB 80 0E
 ioe rrc (iy)                   ; DB FD CB 00 0E
 ioe rrc (iy+0)                 ; DB FD CB 00 0E
 ioe rrc (iy+126)               ; DB FD CB 7E 0E
 ioe rrc (iy-128)               ; DB FD CB 80 0E
 ioe sbc a', (hl)               ; DB 76 7F 9E
 ioe sbc a', (ix)               ; DB 76 DD 9E 00
 ioe sbc a', (ix+0)             ; DB 76 DD 9E 00
 ioe sbc a', (ix+126)           ; DB 76 DD 9E 7E
 ioe sbc a', (ix-128)           ; DB 76 DD 9E 80
 ioe sbc a', (iy)               ; DB 76 FD 9E 00
 ioe sbc a', (iy+0)             ; DB 76 FD 9E 00
 ioe sbc a', (iy+126)           ; DB 76 FD 9E 7E
 ioe sbc a', (iy-128)           ; DB 76 FD 9E 80
 ioe sbc a, (hl)                ; DB 7F 9E
 ioe sbc a, (ix)                ; DB DD 9E 00
 ioe sbc a, (ix+0)              ; DB DD 9E 00
 ioe sbc a, (ix+126)            ; DB DD 9E 7E
 ioe sbc a, (ix-128)            ; DB DD 9E 80
 ioe sbc a, (iy)                ; DB FD 9E 00
 ioe sbc a, (iy+0)              ; DB FD 9E 00
 ioe sbc a, (iy+126)            ; DB FD 9E 7E
 ioe sbc a, (iy-128)            ; DB FD 9E 80
 ioe set 0, (hl)                ; DB CB C6
 ioe set 0, (ix)                ; DB DD CB 00 C6
 ioe set 0, (ix+0)              ; DB DD CB 00 C6
 ioe set 0, (ix+126)            ; DB DD CB 7E C6
 ioe set 0, (ix-128)            ; DB DD CB 80 C6
 ioe set 0, (iy)                ; DB FD CB 00 C6
 ioe set 0, (iy+0)              ; DB FD CB 00 C6
 ioe set 0, (iy+126)            ; DB FD CB 7E C6
 ioe set 0, (iy-128)            ; DB FD CB 80 C6
 ioe set 1, (hl)                ; DB CB CE
 ioe set 1, (ix)                ; DB DD CB 00 CE
 ioe set 1, (ix+0)              ; DB DD CB 00 CE
 ioe set 1, (ix+126)            ; DB DD CB 7E CE
 ioe set 1, (ix-128)            ; DB DD CB 80 CE
 ioe set 1, (iy)                ; DB FD CB 00 CE
 ioe set 1, (iy+0)              ; DB FD CB 00 CE
 ioe set 1, (iy+126)            ; DB FD CB 7E CE
 ioe set 1, (iy-128)            ; DB FD CB 80 CE
 ioe set 2, (hl)                ; DB CB D6
 ioe set 2, (ix)                ; DB DD CB 00 D6
 ioe set 2, (ix+0)              ; DB DD CB 00 D6
 ioe set 2, (ix+126)            ; DB DD CB 7E D6
 ioe set 2, (ix-128)            ; DB DD CB 80 D6
 ioe set 2, (iy)                ; DB FD CB 00 D6
 ioe set 2, (iy+0)              ; DB FD CB 00 D6
 ioe set 2, (iy+126)            ; DB FD CB 7E D6
 ioe set 2, (iy-128)            ; DB FD CB 80 D6
 ioe set 3, (hl)                ; DB CB DE
 ioe set 3, (ix)                ; DB DD CB 00 DE
 ioe set 3, (ix+0)              ; DB DD CB 00 DE
 ioe set 3, (ix+126)            ; DB DD CB 7E DE
 ioe set 3, (ix-128)            ; DB DD CB 80 DE
 ioe set 3, (iy)                ; DB FD CB 00 DE
 ioe set 3, (iy+0)              ; DB FD CB 00 DE
 ioe set 3, (iy+126)            ; DB FD CB 7E DE
 ioe set 3, (iy-128)            ; DB FD CB 80 DE
 ioe set 4, (hl)                ; DB CB E6
 ioe set 4, (ix)                ; DB DD CB 00 E6
 ioe set 4, (ix+0)              ; DB DD CB 00 E6
 ioe set 4, (ix+126)            ; DB DD CB 7E E6
 ioe set 4, (ix-128)            ; DB DD CB 80 E6
 ioe set 4, (iy)                ; DB FD CB 00 E6
 ioe set 4, (iy+0)              ; DB FD CB 00 E6
 ioe set 4, (iy+126)            ; DB FD CB 7E E6
 ioe set 4, (iy-128)            ; DB FD CB 80 E6
 ioe set 5, (hl)                ; DB CB EE
 ioe set 5, (ix)                ; DB DD CB 00 EE
 ioe set 5, (ix+0)              ; DB DD CB 00 EE
 ioe set 5, (ix+126)            ; DB DD CB 7E EE
 ioe set 5, (ix-128)            ; DB DD CB 80 EE
 ioe set 5, (iy)                ; DB FD CB 00 EE
 ioe set 5, (iy+0)              ; DB FD CB 00 EE
 ioe set 5, (iy+126)            ; DB FD CB 7E EE
 ioe set 5, (iy-128)            ; DB FD CB 80 EE
 ioe set 6, (hl)                ; DB CB F6
 ioe set 6, (ix)                ; DB DD CB 00 F6
 ioe set 6, (ix+0)              ; DB DD CB 00 F6
 ioe set 6, (ix+126)            ; DB DD CB 7E F6
 ioe set 6, (ix-128)            ; DB DD CB 80 F6
 ioe set 6, (iy)                ; DB FD CB 00 F6
 ioe set 6, (iy+0)              ; DB FD CB 00 F6
 ioe set 6, (iy+126)            ; DB FD CB 7E F6
 ioe set 6, (iy-128)            ; DB FD CB 80 F6
 ioe set 7, (hl)                ; DB CB FE
 ioe set 7, (ix)                ; DB DD CB 00 FE
 ioe set 7, (ix+0)              ; DB DD CB 00 FE
 ioe set 7, (ix+126)            ; DB DD CB 7E FE
 ioe set 7, (ix-128)            ; DB DD CB 80 FE
 ioe set 7, (iy)                ; DB FD CB 00 FE
 ioe set 7, (iy+0)              ; DB FD CB 00 FE
 ioe set 7, (iy+126)            ; DB FD CB 7E FE
 ioe set 7, (iy-128)            ; DB FD CB 80 FE
 ioe sla (hl)                   ; DB CB 26
 ioe sla (ix)                   ; DB DD CB 00 26
 ioe sla (ix+0)                 ; DB DD CB 00 26
 ioe sla (ix+126)               ; DB DD CB 7E 26
 ioe sla (ix-128)               ; DB DD CB 80 26
 ioe sla (iy)                   ; DB FD CB 00 26
 ioe sla (iy+0)                 ; DB FD CB 00 26
 ioe sla (iy+126)               ; DB FD CB 7E 26
 ioe sla (iy-128)               ; DB FD CB 80 26
 ioe sra (hl)                   ; DB CB 2E
 ioe sra (ix)                   ; DB DD CB 00 2E
 ioe sra (ix+0)                 ; DB DD CB 00 2E
 ioe sra (ix+126)               ; DB DD CB 7E 2E
 ioe sra (ix-128)               ; DB DD CB 80 2E
 ioe sra (iy)                   ; DB FD CB 00 2E
 ioe sra (iy+0)                 ; DB FD CB 00 2E
 ioe sra (iy+126)               ; DB FD CB 7E 2E
 ioe sra (iy-128)               ; DB FD CB 80 2E
 ioe srl (hl)                   ; DB CB 3E
 ioe srl (ix)                   ; DB DD CB 00 3E
 ioe srl (ix+0)                 ; DB DD CB 00 3E
 ioe srl (ix+126)               ; DB DD CB 7E 3E
 ioe srl (ix-128)               ; DB DD CB 80 3E
 ioe srl (iy)                   ; DB FD CB 00 3E
 ioe srl (iy+0)                 ; DB FD CB 00 3E
 ioe srl (iy+126)               ; DB FD CB 7E 3E
 ioe srl (iy-128)               ; DB FD CB 80 3E
 ioe sub (hl)                   ; DB 7F 96
 ioe sub (ix)                   ; DB DD 96 00
 ioe sub (ix+0)                 ; DB DD 96 00
 ioe sub (ix+126)               ; DB DD 96 7E
 ioe sub (ix-128)               ; DB DD 96 80
 ioe sub (iy)                   ; DB FD 96 00
 ioe sub (iy+0)                 ; DB FD 96 00
 ioe sub (iy+126)               ; DB FD 96 7E
 ioe sub (iy-128)               ; DB FD 96 80
 ioe xor (hl)                   ; DB 7F AE
 ioe xor (ix)                   ; DB DD AE 00
 ioe xor (ix+0)                 ; DB DD AE 00
 ioe xor (ix+126)               ; DB DD AE 7E
 ioe xor (ix-128)               ; DB DD AE 80
 ioe xor (iy)                   ; DB FD AE 00
 ioe xor (iy+0)                 ; DB FD AE 00
 ioe xor (iy+126)               ; DB FD AE 7E
 ioe xor (iy-128)               ; DB FD AE 80
 ioi adc a', (hl)               ; D3 76 7F 8E
 ioi adc a', (ix)               ; D3 76 DD 8E 00
 ioi adc a', (ix+0)             ; D3 76 DD 8E 00
 ioi adc a', (ix+126)           ; D3 76 DD 8E 7E
 ioi adc a', (ix-128)           ; D3 76 DD 8E 80
 ioi adc a', (iy)               ; D3 76 FD 8E 00
 ioi adc a', (iy+0)             ; D3 76 FD 8E 00
 ioi adc a', (iy+126)           ; D3 76 FD 8E 7E
 ioi adc a', (iy-128)           ; D3 76 FD 8E 80
 ioi adc a, (hl)                ; D3 7F 8E
 ioi adc a, (ix)                ; D3 DD 8E 00
 ioi adc a, (ix+0)              ; D3 DD 8E 00
 ioi adc a, (ix+126)            ; D3 DD 8E 7E
 ioi adc a, (ix-128)            ; D3 DD 8E 80
 ioi adc a, (iy)                ; D3 FD 8E 00
 ioi adc a, (iy+0)              ; D3 FD 8E 00
 ioi adc a, (iy+126)            ; D3 FD 8E 7E
 ioi adc a, (iy-128)            ; D3 FD 8E 80
 ioi add a', (hl)               ; D3 76 7F 86
 ioi add a', (ix)               ; D3 76 DD 86 00
 ioi add a', (ix+0)             ; D3 76 DD 86 00
 ioi add a', (ix+126)           ; D3 76 DD 86 7E
 ioi add a', (ix-128)           ; D3 76 DD 86 80
 ioi add a', (iy)               ; D3 76 FD 86 00
 ioi add a', (iy+0)             ; D3 76 FD 86 00
 ioi add a', (iy+126)           ; D3 76 FD 86 7E
 ioi add a', (iy-128)           ; D3 76 FD 86 80
 ioi add a, (hl)                ; D3 7F 86
 ioi add a, (ix)                ; D3 DD 86 00
 ioi add a, (ix+0)              ; D3 DD 86 00
 ioi add a, (ix+126)            ; D3 DD 86 7E
 ioi add a, (ix-128)            ; D3 DD 86 80
 ioi add a, (iy)                ; D3 FD 86 00
 ioi add a, (iy+0)              ; D3 FD 86 00
 ioi add a, (iy+126)            ; D3 FD 86 7E
 ioi add a, (iy-128)            ; D3 FD 86 80
 ioi altd adc a, (hl)           ; D3 76 7F 8E
 ioi altd adc a, (ix)           ; D3 76 DD 8E 00
 ioi altd adc a, (ix+0)         ; D3 76 DD 8E 00
 ioi altd adc a, (ix+126)       ; D3 76 DD 8E 7E
 ioi altd adc a, (ix-128)       ; D3 76 DD 8E 80
 ioi altd adc a, (iy)           ; D3 76 FD 8E 00
 ioi altd adc a, (iy+0)         ; D3 76 FD 8E 00
 ioi altd adc a, (iy+126)       ; D3 76 FD 8E 7E
 ioi altd adc a, (iy-128)       ; D3 76 FD 8E 80
 ioi altd add a, (hl)           ; D3 76 7F 86
 ioi altd add a, (ix)           ; D3 76 DD 86 00
 ioi altd add a, (ix+0)         ; D3 76 DD 86 00
 ioi altd add a, (ix+126)       ; D3 76 DD 86 7E
 ioi altd add a, (ix-128)       ; D3 76 DD 86 80
 ioi altd add a, (iy)           ; D3 76 FD 86 00
 ioi altd add a, (iy+0)         ; D3 76 FD 86 00
 ioi altd add a, (iy+126)       ; D3 76 FD 86 7E
 ioi altd add a, (iy-128)       ; D3 76 FD 86 80
 ioi altd and (hl)              ; D3 76 7F A6
 ioi altd and (ix)              ; D3 76 DD A6 00
 ioi altd and (ix+0)            ; D3 76 DD A6 00
 ioi altd and (ix+126)          ; D3 76 DD A6 7E
 ioi altd and (ix-128)          ; D3 76 DD A6 80
 ioi altd and (iy)              ; D3 76 FD A6 00
 ioi altd and (iy+0)            ; D3 76 FD A6 00
 ioi altd and (iy+126)          ; D3 76 FD A6 7E
 ioi altd and (iy-128)          ; D3 76 FD A6 80
 ioi altd bit 0, (hl)           ; D3 76 CB 46
 ioi altd bit 0, (ix)           ; D3 76 DD CB 00 46
 ioi altd bit 0, (ix+0)         ; D3 76 DD CB 00 46
 ioi altd bit 0, (ix+126)       ; D3 76 DD CB 7E 46
 ioi altd bit 0, (ix-128)       ; D3 76 DD CB 80 46
 ioi altd bit 0, (iy)           ; D3 76 FD CB 00 46
 ioi altd bit 0, (iy+0)         ; D3 76 FD CB 00 46
 ioi altd bit 0, (iy+126)       ; D3 76 FD CB 7E 46
 ioi altd bit 0, (iy-128)       ; D3 76 FD CB 80 46
 ioi altd bit 1, (hl)           ; D3 76 CB 4E
 ioi altd bit 1, (ix)           ; D3 76 DD CB 00 4E
 ioi altd bit 1, (ix+0)         ; D3 76 DD CB 00 4E
 ioi altd bit 1, (ix+126)       ; D3 76 DD CB 7E 4E
 ioi altd bit 1, (ix-128)       ; D3 76 DD CB 80 4E
 ioi altd bit 1, (iy)           ; D3 76 FD CB 00 4E
 ioi altd bit 1, (iy+0)         ; D3 76 FD CB 00 4E
 ioi altd bit 1, (iy+126)       ; D3 76 FD CB 7E 4E
 ioi altd bit 1, (iy-128)       ; D3 76 FD CB 80 4E
 ioi altd bit 2, (hl)           ; D3 76 CB 56
 ioi altd bit 2, (ix)           ; D3 76 DD CB 00 56
 ioi altd bit 2, (ix+0)         ; D3 76 DD CB 00 56
 ioi altd bit 2, (ix+126)       ; D3 76 DD CB 7E 56
 ioi altd bit 2, (ix-128)       ; D3 76 DD CB 80 56
 ioi altd bit 2, (iy)           ; D3 76 FD CB 00 56
 ioi altd bit 2, (iy+0)         ; D3 76 FD CB 00 56
 ioi altd bit 2, (iy+126)       ; D3 76 FD CB 7E 56
 ioi altd bit 2, (iy-128)       ; D3 76 FD CB 80 56
 ioi altd bit 3, (hl)           ; D3 76 CB 5E
 ioi altd bit 3, (ix)           ; D3 76 DD CB 00 5E
 ioi altd bit 3, (ix+0)         ; D3 76 DD CB 00 5E
 ioi altd bit 3, (ix+126)       ; D3 76 DD CB 7E 5E
 ioi altd bit 3, (ix-128)       ; D3 76 DD CB 80 5E
 ioi altd bit 3, (iy)           ; D3 76 FD CB 00 5E
 ioi altd bit 3, (iy+0)         ; D3 76 FD CB 00 5E
 ioi altd bit 3, (iy+126)       ; D3 76 FD CB 7E 5E
 ioi altd bit 3, (iy-128)       ; D3 76 FD CB 80 5E
 ioi altd bit 4, (hl)           ; D3 76 CB 66
 ioi altd bit 4, (ix)           ; D3 76 DD CB 00 66
 ioi altd bit 4, (ix+0)         ; D3 76 DD CB 00 66
 ioi altd bit 4, (ix+126)       ; D3 76 DD CB 7E 66
 ioi altd bit 4, (ix-128)       ; D3 76 DD CB 80 66
 ioi altd bit 4, (iy)           ; D3 76 FD CB 00 66
 ioi altd bit 4, (iy+0)         ; D3 76 FD CB 00 66
 ioi altd bit 4, (iy+126)       ; D3 76 FD CB 7E 66
 ioi altd bit 4, (iy-128)       ; D3 76 FD CB 80 66
 ioi altd bit 5, (hl)           ; D3 76 CB 6E
 ioi altd bit 5, (ix)           ; D3 76 DD CB 00 6E
 ioi altd bit 5, (ix+0)         ; D3 76 DD CB 00 6E
 ioi altd bit 5, (ix+126)       ; D3 76 DD CB 7E 6E
 ioi altd bit 5, (ix-128)       ; D3 76 DD CB 80 6E
 ioi altd bit 5, (iy)           ; D3 76 FD CB 00 6E
 ioi altd bit 5, (iy+0)         ; D3 76 FD CB 00 6E
 ioi altd bit 5, (iy+126)       ; D3 76 FD CB 7E 6E
 ioi altd bit 5, (iy-128)       ; D3 76 FD CB 80 6E
 ioi altd bit 6, (hl)           ; D3 76 CB 76
 ioi altd bit 6, (ix)           ; D3 76 DD CB 00 76
 ioi altd bit 6, (ix+0)         ; D3 76 DD CB 00 76
 ioi altd bit 6, (ix+126)       ; D3 76 DD CB 7E 76
 ioi altd bit 6, (ix-128)       ; D3 76 DD CB 80 76
 ioi altd bit 6, (iy)           ; D3 76 FD CB 00 76
 ioi altd bit 6, (iy+0)         ; D3 76 FD CB 00 76
 ioi altd bit 6, (iy+126)       ; D3 76 FD CB 7E 76
 ioi altd bit 6, (iy-128)       ; D3 76 FD CB 80 76
 ioi altd bit 7, (hl)           ; D3 76 CB 7E
 ioi altd bit 7, (ix)           ; D3 76 DD CB 00 7E
 ioi altd bit 7, (ix+0)         ; D3 76 DD CB 00 7E
 ioi altd bit 7, (ix+126)       ; D3 76 DD CB 7E 7E
 ioi altd bit 7, (ix-128)       ; D3 76 DD CB 80 7E
 ioi altd bit 7, (iy)           ; D3 76 FD CB 00 7E
 ioi altd bit 7, (iy+0)         ; D3 76 FD CB 00 7E
 ioi altd bit 7, (iy+126)       ; D3 76 FD CB 7E 7E
 ioi altd bit 7, (iy-128)       ; D3 76 FD CB 80 7E
 ioi altd cp (hl)               ; D3 76 7F BE
 ioi altd cp (ix)               ; D3 76 DD BE 00
 ioi altd cp (ix+0)             ; D3 76 DD BE 00
 ioi altd cp (ix+126)           ; D3 76 DD BE 7E
 ioi altd cp (ix-128)           ; D3 76 DD BE 80
 ioi altd cp (iy)               ; D3 76 FD BE 00
 ioi altd cp (iy+0)             ; D3 76 FD BE 00
 ioi altd cp (iy+126)           ; D3 76 FD BE 7E
 ioi altd cp (iy-128)           ; D3 76 FD BE 80
 ioi altd dec (hl)              ; D3 76 35
 ioi altd dec (ix)              ; D3 76 DD 35 00
 ioi altd dec (ix+0)            ; D3 76 DD 35 00
 ioi altd dec (ix+126)          ; D3 76 DD 35 7E
 ioi altd dec (ix-128)          ; D3 76 DD 35 80
 ioi altd dec (iy)              ; D3 76 FD 35 00
 ioi altd dec (iy+0)            ; D3 76 FD 35 00
 ioi altd dec (iy+126)          ; D3 76 FD 35 7E
 ioi altd dec (iy-128)          ; D3 76 FD 35 80
 ioi altd inc (hl)              ; D3 76 34
 ioi altd inc (ix)              ; D3 76 DD 34 00
 ioi altd inc (ix+0)            ; D3 76 DD 34 00
 ioi altd inc (ix+126)          ; D3 76 DD 34 7E
 ioi altd inc (ix-128)          ; D3 76 DD 34 80
 ioi altd inc (iy)              ; D3 76 FD 34 00
 ioi altd inc (iy+0)            ; D3 76 FD 34 00
 ioi altd inc (iy+126)          ; D3 76 FD 34 7E
 ioi altd inc (iy-128)          ; D3 76 FD 34 80
 ioi altd ld a, (0x1234)        ; D3 76 3A 34 12
 ioi altd ld a, (bc)            ; D3 76 0A
 ioi altd ld a, (de)            ; D3 76 1A
 ioi altd ld a, (hl)            ; D3 76 7E
 ioi altd ld a, (ix)            ; D3 76 DD 7E 00
 ioi altd ld a, (ix+0)          ; D3 76 DD 7E 00
 ioi altd ld a, (ix+126)        ; D3 76 DD 7E 7E
 ioi altd ld a, (ix+a)          ; D3 76 DD 06
 ioi altd ld a, (ix-128)        ; D3 76 DD 7E 80
 ioi altd ld a, (iy)            ; D3 76 FD 7E 00
 ioi altd ld a, (iy+0)          ; D3 76 FD 7E 00
 ioi altd ld a, (iy+126)        ; D3 76 FD 7E 7E
 ioi altd ld a, (iy+a)          ; D3 76 FD 06
 ioi altd ld a, (iy-128)        ; D3 76 FD 7E 80
 ioi altd ld b, (hl)            ; D3 76 46
 ioi altd ld b, (ix)            ; D3 76 DD 46 00
 ioi altd ld b, (ix+0)          ; D3 76 DD 46 00
 ioi altd ld b, (ix+126)        ; D3 76 DD 46 7E
 ioi altd ld b, (ix-128)        ; D3 76 DD 46 80
 ioi altd ld b, (iy)            ; D3 76 FD 46 00
 ioi altd ld b, (iy+0)          ; D3 76 FD 46 00
 ioi altd ld b, (iy+126)        ; D3 76 FD 46 7E
 ioi altd ld b, (iy-128)        ; D3 76 FD 46 80
 ioi altd ld bc, (0x1234)       ; D3 76 ED 4B 34 12
 ioi altd ld bcde, (0x1234)     ; D3 76 93 34 12
 ioi altd ld bcde, (hl)         ; D3 76 DD 1A
 ioi altd ld bcde, (ix)         ; D3 76 DD CE 00
 ioi altd ld bcde, (ix+0)       ; D3 76 DD CE 00
 ioi altd ld bcde, (ix+126)     ; D3 76 DD CE 7E
 ioi altd ld bcde, (ix-128)     ; D3 76 DD CE 80
 ioi altd ld bcde, (iy)         ; D3 76 DD DE 00
 ioi altd ld bcde, (iy+0)       ; D3 76 DD DE 00
 ioi altd ld bcde, (iy+126)     ; D3 76 DD DE 7E
 ioi altd ld bcde, (iy-128)     ; D3 76 DD DE 80
 ioi altd ld c, (hl)            ; D3 76 4E
 ioi altd ld c, (ix)            ; D3 76 DD 4E 00
 ioi altd ld c, (ix+0)          ; D3 76 DD 4E 00
 ioi altd ld c, (ix+126)        ; D3 76 DD 4E 7E
 ioi altd ld c, (ix-128)        ; D3 76 DD 4E 80
 ioi altd ld c, (iy)            ; D3 76 FD 4E 00
 ioi altd ld c, (iy+0)          ; D3 76 FD 4E 00
 ioi altd ld c, (iy+126)        ; D3 76 FD 4E 7E
 ioi altd ld c, (iy-128)        ; D3 76 FD 4E 80
 ioi altd ld d, (hl)            ; D3 76 56
 ioi altd ld d, (ix)            ; D3 76 DD 56 00
 ioi altd ld d, (ix+0)          ; D3 76 DD 56 00
 ioi altd ld d, (ix+126)        ; D3 76 DD 56 7E
 ioi altd ld d, (ix-128)        ; D3 76 DD 56 80
 ioi altd ld d, (iy)            ; D3 76 FD 56 00
 ioi altd ld d, (iy+0)          ; D3 76 FD 56 00
 ioi altd ld d, (iy+126)        ; D3 76 FD 56 7E
 ioi altd ld d, (iy-128)        ; D3 76 FD 56 80
 ioi altd ld de, (0x1234)       ; D3 76 ED 5B 34 12
 ioi altd ld e, (hl)            ; D3 76 5E
 ioi altd ld e, (ix)            ; D3 76 DD 5E 00
 ioi altd ld e, (ix+0)          ; D3 76 DD 5E 00
 ioi altd ld e, (ix+126)        ; D3 76 DD 5E 7E
 ioi altd ld e, (ix-128)        ; D3 76 DD 5E 80
 ioi altd ld e, (iy)            ; D3 76 FD 5E 00
 ioi altd ld e, (iy+0)          ; D3 76 FD 5E 00
 ioi altd ld e, (iy+126)        ; D3 76 FD 5E 7E
 ioi altd ld e, (iy-128)        ; D3 76 FD 5E 80
 ioi altd ld h, (hl)            ; D3 76 66
 ioi altd ld h, (ix)            ; D3 76 DD 66 00
 ioi altd ld h, (ix+0)          ; D3 76 DD 66 00
 ioi altd ld h, (ix+126)        ; D3 76 DD 66 7E
 ioi altd ld h, (ix-128)        ; D3 76 DD 66 80
 ioi altd ld h, (iy)            ; D3 76 FD 66 00
 ioi altd ld h, (iy+0)          ; D3 76 FD 66 00
 ioi altd ld h, (iy+126)        ; D3 76 FD 66 7E
 ioi altd ld h, (iy-128)        ; D3 76 FD 66 80
 ioi altd ld hl, (0x1234)       ; D3 76 2A 34 12
 ioi altd ld hl, (hl)           ; D3 76 DD E4 00
 ioi altd ld hl, (hl+0)         ; D3 76 DD E4 00
 ioi altd ld hl, (hl+126)       ; D3 76 DD E4 7E
 ioi altd ld hl, (hl-128)       ; D3 76 DD E4 80
 ioi altd ld hl, (ix)           ; D3 76 E4 00
 ioi altd ld hl, (ix+0)         ; D3 76 E4 00
 ioi altd ld hl, (ix+126)       ; D3 76 E4 7E
 ioi altd ld hl, (ix-128)       ; D3 76 E4 80
 ioi altd ld hl, (iy)           ; D3 76 FD E4 00
 ioi altd ld hl, (iy+0)         ; D3 76 FD E4 00
 ioi altd ld hl, (iy+126)       ; D3 76 FD E4 7E
 ioi altd ld hl, (iy-128)       ; D3 76 FD E4 80
 ioi altd ld jk, (0x1234)       ; D3 76 99 34 12
 ioi altd ld jkhl, (0x1234)     ; D3 76 94 34 12
 ioi altd ld jkhl, (hl)         ; D3 76 FD 1A
 ioi altd ld jkhl, (ix)         ; D3 76 FD CE 00
 ioi altd ld jkhl, (ix+0)       ; D3 76 FD CE 00
 ioi altd ld jkhl, (ix+126)     ; D3 76 FD CE 7E
 ioi altd ld jkhl, (ix-128)     ; D3 76 FD CE 80
 ioi altd ld jkhl, (iy)         ; D3 76 FD DE 00
 ioi altd ld jkhl, (iy+0)       ; D3 76 FD DE 00
 ioi altd ld jkhl, (iy+126)     ; D3 76 FD DE 7E
 ioi altd ld jkhl, (iy-128)     ; D3 76 FD DE 80
 ioi altd ld l, (hl)            ; D3 76 6E
 ioi altd ld l, (ix)            ; D3 76 DD 6E 00
 ioi altd ld l, (ix+0)          ; D3 76 DD 6E 00
 ioi altd ld l, (ix+126)        ; D3 76 DD 6E 7E
 ioi altd ld l, (ix-128)        ; D3 76 DD 6E 80
 ioi altd ld l, (iy)            ; D3 76 FD 6E 00
 ioi altd ld l, (iy+0)          ; D3 76 FD 6E 00
 ioi altd ld l, (iy+126)        ; D3 76 FD 6E 7E
 ioi altd ld l, (iy-128)        ; D3 76 FD 6E 80
 ioi altd or (hl)               ; D3 76 7F B6
 ioi altd or (ix)               ; D3 76 DD B6 00
 ioi altd or (ix+0)             ; D3 76 DD B6 00
 ioi altd or (ix+126)           ; D3 76 DD B6 7E
 ioi altd or (ix-128)           ; D3 76 DD B6 80
 ioi altd or (iy)               ; D3 76 FD B6 00
 ioi altd or (iy+0)             ; D3 76 FD B6 00
 ioi altd or (iy+126)           ; D3 76 FD B6 7E
 ioi altd or (iy-128)           ; D3 76 FD B6 80
 ioi altd res 0, (hl)           ; D3 76 CB 86
 ioi altd res 0, (ix)           ; D3 76 DD CB 00 86
 ioi altd res 0, (ix+0)         ; D3 76 DD CB 00 86
 ioi altd res 0, (ix+126)       ; D3 76 DD CB 7E 86
 ioi altd res 0, (ix-128)       ; D3 76 DD CB 80 86
 ioi altd res 0, (iy)           ; D3 76 FD CB 00 86
 ioi altd res 0, (iy+0)         ; D3 76 FD CB 00 86
 ioi altd res 0, (iy+126)       ; D3 76 FD CB 7E 86
 ioi altd res 0, (iy-128)       ; D3 76 FD CB 80 86
 ioi altd res 1, (hl)           ; D3 76 CB 8E
 ioi altd res 1, (ix)           ; D3 76 DD CB 00 8E
 ioi altd res 1, (ix+0)         ; D3 76 DD CB 00 8E
 ioi altd res 1, (ix+126)       ; D3 76 DD CB 7E 8E
 ioi altd res 1, (ix-128)       ; D3 76 DD CB 80 8E
 ioi altd res 1, (iy)           ; D3 76 FD CB 00 8E
 ioi altd res 1, (iy+0)         ; D3 76 FD CB 00 8E
 ioi altd res 1, (iy+126)       ; D3 76 FD CB 7E 8E
 ioi altd res 1, (iy-128)       ; D3 76 FD CB 80 8E
 ioi altd res 2, (hl)           ; D3 76 CB 96
 ioi altd res 2, (ix)           ; D3 76 DD CB 00 96
 ioi altd res 2, (ix+0)         ; D3 76 DD CB 00 96
 ioi altd res 2, (ix+126)       ; D3 76 DD CB 7E 96
 ioi altd res 2, (ix-128)       ; D3 76 DD CB 80 96
 ioi altd res 2, (iy)           ; D3 76 FD CB 00 96
 ioi altd res 2, (iy+0)         ; D3 76 FD CB 00 96
 ioi altd res 2, (iy+126)       ; D3 76 FD CB 7E 96
 ioi altd res 2, (iy-128)       ; D3 76 FD CB 80 96
 ioi altd res 3, (hl)           ; D3 76 CB 9E
 ioi altd res 3, (ix)           ; D3 76 DD CB 00 9E
 ioi altd res 3, (ix+0)         ; D3 76 DD CB 00 9E
 ioi altd res 3, (ix+126)       ; D3 76 DD CB 7E 9E
 ioi altd res 3, (ix-128)       ; D3 76 DD CB 80 9E
 ioi altd res 3, (iy)           ; D3 76 FD CB 00 9E
 ioi altd res 3, (iy+0)         ; D3 76 FD CB 00 9E
 ioi altd res 3, (iy+126)       ; D3 76 FD CB 7E 9E
 ioi altd res 3, (iy-128)       ; D3 76 FD CB 80 9E
 ioi altd res 4, (hl)           ; D3 76 CB A6
 ioi altd res 4, (ix)           ; D3 76 DD CB 00 A6
 ioi altd res 4, (ix+0)         ; D3 76 DD CB 00 A6
 ioi altd res 4, (ix+126)       ; D3 76 DD CB 7E A6
 ioi altd res 4, (ix-128)       ; D3 76 DD CB 80 A6
 ioi altd res 4, (iy)           ; D3 76 FD CB 00 A6
 ioi altd res 4, (iy+0)         ; D3 76 FD CB 00 A6
 ioi altd res 4, (iy+126)       ; D3 76 FD CB 7E A6
 ioi altd res 4, (iy-128)       ; D3 76 FD CB 80 A6
 ioi altd res 5, (hl)           ; D3 76 CB AE
 ioi altd res 5, (ix)           ; D3 76 DD CB 00 AE
 ioi altd res 5, (ix+0)         ; D3 76 DD CB 00 AE
 ioi altd res 5, (ix+126)       ; D3 76 DD CB 7E AE
 ioi altd res 5, (ix-128)       ; D3 76 DD CB 80 AE
 ioi altd res 5, (iy)           ; D3 76 FD CB 00 AE
 ioi altd res 5, (iy+0)         ; D3 76 FD CB 00 AE
 ioi altd res 5, (iy+126)       ; D3 76 FD CB 7E AE
 ioi altd res 5, (iy-128)       ; D3 76 FD CB 80 AE
 ioi altd res 6, (hl)           ; D3 76 CB B6
 ioi altd res 6, (ix)           ; D3 76 DD CB 00 B6
 ioi altd res 6, (ix+0)         ; D3 76 DD CB 00 B6
 ioi altd res 6, (ix+126)       ; D3 76 DD CB 7E B6
 ioi altd res 6, (ix-128)       ; D3 76 DD CB 80 B6
 ioi altd res 6, (iy)           ; D3 76 FD CB 00 B6
 ioi altd res 6, (iy+0)         ; D3 76 FD CB 00 B6
 ioi altd res 6, (iy+126)       ; D3 76 FD CB 7E B6
 ioi altd res 6, (iy-128)       ; D3 76 FD CB 80 B6
 ioi altd res 7, (hl)           ; D3 76 CB BE
 ioi altd res 7, (ix)           ; D3 76 DD CB 00 BE
 ioi altd res 7, (ix+0)         ; D3 76 DD CB 00 BE
 ioi altd res 7, (ix+126)       ; D3 76 DD CB 7E BE
 ioi altd res 7, (ix-128)       ; D3 76 DD CB 80 BE
 ioi altd res 7, (iy)           ; D3 76 FD CB 00 BE
 ioi altd res 7, (iy+0)         ; D3 76 FD CB 00 BE
 ioi altd res 7, (iy+126)       ; D3 76 FD CB 7E BE
 ioi altd res 7, (iy-128)       ; D3 76 FD CB 80 BE
 ioi altd rl (hl)               ; D3 76 CB 16
 ioi altd rl (ix)               ; D3 76 DD CB 00 16
 ioi altd rl (ix+0)             ; D3 76 DD CB 00 16
 ioi altd rl (ix+126)           ; D3 76 DD CB 7E 16
 ioi altd rl (ix-128)           ; D3 76 DD CB 80 16
 ioi altd rl (iy)               ; D3 76 FD CB 00 16
 ioi altd rl (iy+0)             ; D3 76 FD CB 00 16
 ioi altd rl (iy+126)           ; D3 76 FD CB 7E 16
 ioi altd rl (iy-128)           ; D3 76 FD CB 80 16
 ioi altd rlc (hl)              ; D3 76 CB 06
 ioi altd rlc (ix)              ; D3 76 DD CB 00 06
 ioi altd rlc (ix+0)            ; D3 76 DD CB 00 06
 ioi altd rlc (ix+126)          ; D3 76 DD CB 7E 06
 ioi altd rlc (ix-128)          ; D3 76 DD CB 80 06
 ioi altd rlc (iy)              ; D3 76 FD CB 00 06
 ioi altd rlc (iy+0)            ; D3 76 FD CB 00 06
 ioi altd rlc (iy+126)          ; D3 76 FD CB 7E 06
 ioi altd rlc (iy-128)          ; D3 76 FD CB 80 06
 ioi altd rr (hl)               ; D3 76 CB 1E
 ioi altd rr (ix)               ; D3 76 DD CB 00 1E
 ioi altd rr (ix+0)             ; D3 76 DD CB 00 1E
 ioi altd rr (ix+126)           ; D3 76 DD CB 7E 1E
 ioi altd rr (ix-128)           ; D3 76 DD CB 80 1E
 ioi altd rr (iy)               ; D3 76 FD CB 00 1E
 ioi altd rr (iy+0)             ; D3 76 FD CB 00 1E
 ioi altd rr (iy+126)           ; D3 76 FD CB 7E 1E
 ioi altd rr (iy-128)           ; D3 76 FD CB 80 1E
 ioi altd rrc (hl)              ; D3 76 CB 0E
 ioi altd rrc (ix)              ; D3 76 DD CB 00 0E
 ioi altd rrc (ix+0)            ; D3 76 DD CB 00 0E
 ioi altd rrc (ix+126)          ; D3 76 DD CB 7E 0E
 ioi altd rrc (ix-128)          ; D3 76 DD CB 80 0E
 ioi altd rrc (iy)              ; D3 76 FD CB 00 0E
 ioi altd rrc (iy+0)            ; D3 76 FD CB 00 0E
 ioi altd rrc (iy+126)          ; D3 76 FD CB 7E 0E
 ioi altd rrc (iy-128)          ; D3 76 FD CB 80 0E
 ioi altd sbc a, (hl)           ; D3 76 7F 9E
 ioi altd sbc a, (ix)           ; D3 76 DD 9E 00
 ioi altd sbc a, (ix+0)         ; D3 76 DD 9E 00
 ioi altd sbc a, (ix+126)       ; D3 76 DD 9E 7E
 ioi altd sbc a, (ix-128)       ; D3 76 DD 9E 80
 ioi altd sbc a, (iy)           ; D3 76 FD 9E 00
 ioi altd sbc a, (iy+0)         ; D3 76 FD 9E 00
 ioi altd sbc a, (iy+126)       ; D3 76 FD 9E 7E
 ioi altd sbc a, (iy-128)       ; D3 76 FD 9E 80
 ioi altd set 0, (hl)           ; D3 76 CB C6
 ioi altd set 0, (ix)           ; D3 76 DD CB 00 C6
 ioi altd set 0, (ix+0)         ; D3 76 DD CB 00 C6
 ioi altd set 0, (ix+126)       ; D3 76 DD CB 7E C6
 ioi altd set 0, (ix-128)       ; D3 76 DD CB 80 C6
 ioi altd set 0, (iy)           ; D3 76 FD CB 00 C6
 ioi altd set 0, (iy+0)         ; D3 76 FD CB 00 C6
 ioi altd set 0, (iy+126)       ; D3 76 FD CB 7E C6
 ioi altd set 0, (iy-128)       ; D3 76 FD CB 80 C6
 ioi altd set 1, (hl)           ; D3 76 CB CE
 ioi altd set 1, (ix)           ; D3 76 DD CB 00 CE
 ioi altd set 1, (ix+0)         ; D3 76 DD CB 00 CE
 ioi altd set 1, (ix+126)       ; D3 76 DD CB 7E CE
 ioi altd set 1, (ix-128)       ; D3 76 DD CB 80 CE
 ioi altd set 1, (iy)           ; D3 76 FD CB 00 CE
 ioi altd set 1, (iy+0)         ; D3 76 FD CB 00 CE
 ioi altd set 1, (iy+126)       ; D3 76 FD CB 7E CE
 ioi altd set 1, (iy-128)       ; D3 76 FD CB 80 CE
 ioi altd set 2, (hl)           ; D3 76 CB D6
 ioi altd set 2, (ix)           ; D3 76 DD CB 00 D6
 ioi altd set 2, (ix+0)         ; D3 76 DD CB 00 D6
 ioi altd set 2, (ix+126)       ; D3 76 DD CB 7E D6
 ioi altd set 2, (ix-128)       ; D3 76 DD CB 80 D6
 ioi altd set 2, (iy)           ; D3 76 FD CB 00 D6
 ioi altd set 2, (iy+0)         ; D3 76 FD CB 00 D6
 ioi altd set 2, (iy+126)       ; D3 76 FD CB 7E D6
 ioi altd set 2, (iy-128)       ; D3 76 FD CB 80 D6
 ioi altd set 3, (hl)           ; D3 76 CB DE
 ioi altd set 3, (ix)           ; D3 76 DD CB 00 DE
 ioi altd set 3, (ix+0)         ; D3 76 DD CB 00 DE
 ioi altd set 3, (ix+126)       ; D3 76 DD CB 7E DE
 ioi altd set 3, (ix-128)       ; D3 76 DD CB 80 DE
 ioi altd set 3, (iy)           ; D3 76 FD CB 00 DE
 ioi altd set 3, (iy+0)         ; D3 76 FD CB 00 DE
 ioi altd set 3, (iy+126)       ; D3 76 FD CB 7E DE
 ioi altd set 3, (iy-128)       ; D3 76 FD CB 80 DE
 ioi altd set 4, (hl)           ; D3 76 CB E6
 ioi altd set 4, (ix)           ; D3 76 DD CB 00 E6
 ioi altd set 4, (ix+0)         ; D3 76 DD CB 00 E6
 ioi altd set 4, (ix+126)       ; D3 76 DD CB 7E E6
 ioi altd set 4, (ix-128)       ; D3 76 DD CB 80 E6
 ioi altd set 4, (iy)           ; D3 76 FD CB 00 E6
 ioi altd set 4, (iy+0)         ; D3 76 FD CB 00 E6
 ioi altd set 4, (iy+126)       ; D3 76 FD CB 7E E6
 ioi altd set 4, (iy-128)       ; D3 76 FD CB 80 E6
 ioi altd set 5, (hl)           ; D3 76 CB EE
 ioi altd set 5, (ix)           ; D3 76 DD CB 00 EE
 ioi altd set 5, (ix+0)         ; D3 76 DD CB 00 EE
 ioi altd set 5, (ix+126)       ; D3 76 DD CB 7E EE
 ioi altd set 5, (ix-128)       ; D3 76 DD CB 80 EE
 ioi altd set 5, (iy)           ; D3 76 FD CB 00 EE
 ioi altd set 5, (iy+0)         ; D3 76 FD CB 00 EE
 ioi altd set 5, (iy+126)       ; D3 76 FD CB 7E EE
 ioi altd set 5, (iy-128)       ; D3 76 FD CB 80 EE
 ioi altd set 6, (hl)           ; D3 76 CB F6
 ioi altd set 6, (ix)           ; D3 76 DD CB 00 F6
 ioi altd set 6, (ix+0)         ; D3 76 DD CB 00 F6
 ioi altd set 6, (ix+126)       ; D3 76 DD CB 7E F6
 ioi altd set 6, (ix-128)       ; D3 76 DD CB 80 F6
 ioi altd set 6, (iy)           ; D3 76 FD CB 00 F6
 ioi altd set 6, (iy+0)         ; D3 76 FD CB 00 F6
 ioi altd set 6, (iy+126)       ; D3 76 FD CB 7E F6
 ioi altd set 6, (iy-128)       ; D3 76 FD CB 80 F6
 ioi altd set 7, (hl)           ; D3 76 CB FE
 ioi altd set 7, (ix)           ; D3 76 DD CB 00 FE
 ioi altd set 7, (ix+0)         ; D3 76 DD CB 00 FE
 ioi altd set 7, (ix+126)       ; D3 76 DD CB 7E FE
 ioi altd set 7, (ix-128)       ; D3 76 DD CB 80 FE
 ioi altd set 7, (iy)           ; D3 76 FD CB 00 FE
 ioi altd set 7, (iy+0)         ; D3 76 FD CB 00 FE
 ioi altd set 7, (iy+126)       ; D3 76 FD CB 7E FE
 ioi altd set 7, (iy-128)       ; D3 76 FD CB 80 FE
 ioi altd sla (hl)              ; D3 76 CB 26
 ioi altd sla (ix)              ; D3 76 DD CB 00 26
 ioi altd sla (ix+0)            ; D3 76 DD CB 00 26
 ioi altd sla (ix+126)          ; D3 76 DD CB 7E 26
 ioi altd sla (ix-128)          ; D3 76 DD CB 80 26
 ioi altd sla (iy)              ; D3 76 FD CB 00 26
 ioi altd sla (iy+0)            ; D3 76 FD CB 00 26
 ioi altd sla (iy+126)          ; D3 76 FD CB 7E 26
 ioi altd sla (iy-128)          ; D3 76 FD CB 80 26
 ioi altd sra (hl)              ; D3 76 CB 2E
 ioi altd sra (ix)              ; D3 76 DD CB 00 2E
 ioi altd sra (ix+0)            ; D3 76 DD CB 00 2E
 ioi altd sra (ix+126)          ; D3 76 DD CB 7E 2E
 ioi altd sra (ix-128)          ; D3 76 DD CB 80 2E
 ioi altd sra (iy)              ; D3 76 FD CB 00 2E
 ioi altd sra (iy+0)            ; D3 76 FD CB 00 2E
 ioi altd sra (iy+126)          ; D3 76 FD CB 7E 2E
 ioi altd sra (iy-128)          ; D3 76 FD CB 80 2E
 ioi altd srl (hl)              ; D3 76 CB 3E
 ioi altd srl (ix)              ; D3 76 DD CB 00 3E
 ioi altd srl (ix+0)            ; D3 76 DD CB 00 3E
 ioi altd srl (ix+126)          ; D3 76 DD CB 7E 3E
 ioi altd srl (ix-128)          ; D3 76 DD CB 80 3E
 ioi altd srl (iy)              ; D3 76 FD CB 00 3E
 ioi altd srl (iy+0)            ; D3 76 FD CB 00 3E
 ioi altd srl (iy+126)          ; D3 76 FD CB 7E 3E
 ioi altd srl (iy-128)          ; D3 76 FD CB 80 3E
 ioi altd sub (hl)              ; D3 76 7F 96
 ioi altd sub (ix)              ; D3 76 DD 96 00
 ioi altd sub (ix+0)            ; D3 76 DD 96 00
 ioi altd sub (ix+126)          ; D3 76 DD 96 7E
 ioi altd sub (ix-128)          ; D3 76 DD 96 80
 ioi altd sub (iy)              ; D3 76 FD 96 00
 ioi altd sub (iy+0)            ; D3 76 FD 96 00
 ioi altd sub (iy+126)          ; D3 76 FD 96 7E
 ioi altd sub (iy-128)          ; D3 76 FD 96 80
 ioi altd xor (hl)              ; D3 76 7F AE
 ioi altd xor (ix)              ; D3 76 DD AE 00
 ioi altd xor (ix+0)            ; D3 76 DD AE 00
 ioi altd xor (ix+126)          ; D3 76 DD AE 7E
 ioi altd xor (ix-128)          ; D3 76 DD AE 80
 ioi altd xor (iy)              ; D3 76 FD AE 00
 ioi altd xor (iy+0)            ; D3 76 FD AE 00
 ioi altd xor (iy+126)          ; D3 76 FD AE 7E
 ioi altd xor (iy-128)          ; D3 76 FD AE 80
 ioi and (hl)                   ; D3 7F A6
 ioi and (ix)                   ; D3 DD A6 00
 ioi and (ix+0)                 ; D3 DD A6 00
 ioi and (ix+126)               ; D3 DD A6 7E
 ioi and (ix-128)               ; D3 DD A6 80
 ioi and (iy)                   ; D3 FD A6 00
 ioi and (iy+0)                 ; D3 FD A6 00
 ioi and (iy+126)               ; D3 FD A6 7E
 ioi and (iy-128)               ; D3 FD A6 80
 ioi bit 0, (hl)                ; D3 CB 46
 ioi bit 0, (ix)                ; D3 DD CB 00 46
 ioi bit 0, (ix+0)              ; D3 DD CB 00 46
 ioi bit 0, (ix+126)            ; D3 DD CB 7E 46
 ioi bit 0, (ix-128)            ; D3 DD CB 80 46
 ioi bit 0, (iy)                ; D3 FD CB 00 46
 ioi bit 0, (iy+0)              ; D3 FD CB 00 46
 ioi bit 0, (iy+126)            ; D3 FD CB 7E 46
 ioi bit 0, (iy-128)            ; D3 FD CB 80 46
 ioi bit 1, (hl)                ; D3 CB 4E
 ioi bit 1, (ix)                ; D3 DD CB 00 4E
 ioi bit 1, (ix+0)              ; D3 DD CB 00 4E
 ioi bit 1, (ix+126)            ; D3 DD CB 7E 4E
 ioi bit 1, (ix-128)            ; D3 DD CB 80 4E
 ioi bit 1, (iy)                ; D3 FD CB 00 4E
 ioi bit 1, (iy+0)              ; D3 FD CB 00 4E
 ioi bit 1, (iy+126)            ; D3 FD CB 7E 4E
 ioi bit 1, (iy-128)            ; D3 FD CB 80 4E
 ioi bit 2, (hl)                ; D3 CB 56
 ioi bit 2, (ix)                ; D3 DD CB 00 56
 ioi bit 2, (ix+0)              ; D3 DD CB 00 56
 ioi bit 2, (ix+126)            ; D3 DD CB 7E 56
 ioi bit 2, (ix-128)            ; D3 DD CB 80 56
 ioi bit 2, (iy)                ; D3 FD CB 00 56
 ioi bit 2, (iy+0)              ; D3 FD CB 00 56
 ioi bit 2, (iy+126)            ; D3 FD CB 7E 56
 ioi bit 2, (iy-128)            ; D3 FD CB 80 56
 ioi bit 3, (hl)                ; D3 CB 5E
 ioi bit 3, (ix)                ; D3 DD CB 00 5E
 ioi bit 3, (ix+0)              ; D3 DD CB 00 5E
 ioi bit 3, (ix+126)            ; D3 DD CB 7E 5E
 ioi bit 3, (ix-128)            ; D3 DD CB 80 5E
 ioi bit 3, (iy)                ; D3 FD CB 00 5E
 ioi bit 3, (iy+0)              ; D3 FD CB 00 5E
 ioi bit 3, (iy+126)            ; D3 FD CB 7E 5E
 ioi bit 3, (iy-128)            ; D3 FD CB 80 5E
 ioi bit 4, (hl)                ; D3 CB 66
 ioi bit 4, (ix)                ; D3 DD CB 00 66
 ioi bit 4, (ix+0)              ; D3 DD CB 00 66
 ioi bit 4, (ix+126)            ; D3 DD CB 7E 66
 ioi bit 4, (ix-128)            ; D3 DD CB 80 66
 ioi bit 4, (iy)                ; D3 FD CB 00 66
 ioi bit 4, (iy+0)              ; D3 FD CB 00 66
 ioi bit 4, (iy+126)            ; D3 FD CB 7E 66
 ioi bit 4, (iy-128)            ; D3 FD CB 80 66
 ioi bit 5, (hl)                ; D3 CB 6E
 ioi bit 5, (ix)                ; D3 DD CB 00 6E
 ioi bit 5, (ix+0)              ; D3 DD CB 00 6E
 ioi bit 5, (ix+126)            ; D3 DD CB 7E 6E
 ioi bit 5, (ix-128)            ; D3 DD CB 80 6E
 ioi bit 5, (iy)                ; D3 FD CB 00 6E
 ioi bit 5, (iy+0)              ; D3 FD CB 00 6E
 ioi bit 5, (iy+126)            ; D3 FD CB 7E 6E
 ioi bit 5, (iy-128)            ; D3 FD CB 80 6E
 ioi bit 6, (hl)                ; D3 CB 76
 ioi bit 6, (ix)                ; D3 DD CB 00 76
 ioi bit 6, (ix+0)              ; D3 DD CB 00 76
 ioi bit 6, (ix+126)            ; D3 DD CB 7E 76
 ioi bit 6, (ix-128)            ; D3 DD CB 80 76
 ioi bit 6, (iy)                ; D3 FD CB 00 76
 ioi bit 6, (iy+0)              ; D3 FD CB 00 76
 ioi bit 6, (iy+126)            ; D3 FD CB 7E 76
 ioi bit 6, (iy-128)            ; D3 FD CB 80 76
 ioi bit 7, (hl)                ; D3 CB 7E
 ioi bit 7, (ix)                ; D3 DD CB 00 7E
 ioi bit 7, (ix+0)              ; D3 DD CB 00 7E
 ioi bit 7, (ix+126)            ; D3 DD CB 7E 7E
 ioi bit 7, (ix-128)            ; D3 DD CB 80 7E
 ioi bit 7, (iy)                ; D3 FD CB 00 7E
 ioi bit 7, (iy+0)              ; D3 FD CB 00 7E
 ioi bit 7, (iy+126)            ; D3 FD CB 7E 7E
 ioi bit 7, (iy-128)            ; D3 FD CB 80 7E
 ioi cbm 0                      ; D3 ED 00 00
 ioi cbm 127                    ; D3 ED 00 7F
 ioi cbm 255                    ; D3 ED 00 FF
 ioi cp (hl)                    ; D3 7F BE
 ioi cp (ix)                    ; D3 DD BE 00
 ioi cp (ix+0)                  ; D3 DD BE 00
 ioi cp (ix+126)                ; D3 DD BE 7E
 ioi cp (ix-128)                ; D3 DD BE 80
 ioi cp (iy)                    ; D3 FD BE 00
 ioi cp (iy+0)                  ; D3 FD BE 00
 ioi cp (iy+126)                ; D3 FD BE 7E
 ioi cp (iy-128)                ; D3 FD BE 80
 ioi dec (hl)                   ; D3 35
 ioi dec (ix)                   ; D3 DD 35 00
 ioi dec (ix+0)                 ; D3 DD 35 00
 ioi dec (ix+126)               ; D3 DD 35 7E
 ioi dec (ix-128)               ; D3 DD 35 80
 ioi dec (iy)                   ; D3 FD 35 00
 ioi dec (iy+0)                 ; D3 FD 35 00
 ioi dec (iy+126)               ; D3 FD 35 7E
 ioi dec (iy-128)               ; D3 FD 35 80
 ioi inc (hl)                   ; D3 34
 ioi inc (ix)                   ; D3 DD 34 00
 ioi inc (ix+0)                 ; D3 DD 34 00
 ioi inc (ix+126)               ; D3 DD 34 7E
 ioi inc (ix-128)               ; D3 DD 34 80
 ioi inc (iy)                   ; D3 FD 34 00
 ioi inc (iy+0)                 ; D3 FD 34 00
 ioi inc (iy+126)               ; D3 FD 34 7E
 ioi inc (iy-128)               ; D3 FD 34 80
 ioi ld (0x1234), a             ; D3 32 34 12
 ioi ld (0x1234), bc            ; D3 ED 43 34 12
 ioi ld (0x1234), bcde          ; D3 83 34 12
 ioi ld (0x1234), de            ; D3 ED 53 34 12
 ioi ld (0x1234), hl            ; D3 22 34 12
 ioi ld (0x1234), ix            ; D3 DD 22 34 12
 ioi ld (0x1234), iy            ; D3 FD 22 34 12
 ioi ld (0x1234), jk            ; D3 89 34 12
 ioi ld (0x1234), jkhl          ; D3 84 34 12
 ioi ld (0x1234), sp            ; D3 ED 73 34 12
 ioi ld (bc), a                 ; D3 02
 ioi ld (de), a                 ; D3 12
 ioi ld (hl), 0                 ; D3 36 00
 ioi ld (hl), 127               ; D3 36 7F
 ioi ld (hl), 255               ; D3 36 FF
 ioi ld (hl), a                 ; D3 77
 ioi ld (hl), b                 ; D3 70
 ioi ld (hl), bcde              ; D3 DD 1B
 ioi ld (hl), c                 ; D3 71
 ioi ld (hl), d                 ; D3 72
 ioi ld (hl), e                 ; D3 73
 ioi ld (hl), h                 ; D3 74
 ioi ld (hl), hl                ; D3 DD F4 00
 ioi ld (hl), jkhl              ; D3 FD 1B
 ioi ld (hl), l                 ; D3 75
 ioi ld (hl+0), hl              ; D3 DD F4 00
 ioi ld (hl+126), hl            ; D3 DD F4 7E
 ioi ld (hl-128), hl            ; D3 DD F4 80
 ioi ld (ix), 0                 ; D3 DD 36 00 00
 ioi ld (ix), 127               ; D3 DD 36 00 7F
 ioi ld (ix), 255               ; D3 DD 36 00 FF
 ioi ld (ix), a                 ; D3 DD 77 00
 ioi ld (ix), b                 ; D3 DD 70 00
 ioi ld (ix), bcde              ; D3 DD CF 00
 ioi ld (ix), c                 ; D3 DD 71 00
 ioi ld (ix), d                 ; D3 DD 72 00
 ioi ld (ix), e                 ; D3 DD 73 00
 ioi ld (ix), h                 ; D3 DD 74 00
 ioi ld (ix), hl                ; D3 F4 00
 ioi ld (ix), jkhl              ; D3 FD CF 00
 ioi ld (ix), l                 ; D3 DD 75 00
 ioi ld (ix+0), 0               ; D3 DD 36 00 00
 ioi ld (ix+0), 127             ; D3 DD 36 00 7F
 ioi ld (ix+0), 255             ; D3 DD 36 00 FF
 ioi ld (ix+0), a               ; D3 DD 77 00
 ioi ld (ix+0), b               ; D3 DD 70 00
 ioi ld (ix+0), bcde            ; D3 DD CF 00
 ioi ld (ix+0), c               ; D3 DD 71 00
 ioi ld (ix+0), d               ; D3 DD 72 00
 ioi ld (ix+0), e               ; D3 DD 73 00
 ioi ld (ix+0), h               ; D3 DD 74 00
 ioi ld (ix+0), hl              ; D3 F4 00
 ioi ld (ix+0), jkhl            ; D3 FD CF 00
 ioi ld (ix+0), l               ; D3 DD 75 00
 ioi ld (ix+126), 0             ; D3 DD 36 7E 00
 ioi ld (ix+126), 127           ; D3 DD 36 7E 7F
 ioi ld (ix+126), 255           ; D3 DD 36 7E FF
 ioi ld (ix+126), a             ; D3 DD 77 7E
 ioi ld (ix+126), b             ; D3 DD 70 7E
 ioi ld (ix+126), bcde          ; D3 DD CF 7E
 ioi ld (ix+126), c             ; D3 DD 71 7E
 ioi ld (ix+126), d             ; D3 DD 72 7E
 ioi ld (ix+126), e             ; D3 DD 73 7E
 ioi ld (ix+126), h             ; D3 DD 74 7E
 ioi ld (ix+126), hl            ; D3 F4 7E
 ioi ld (ix+126), jkhl          ; D3 FD CF 7E
 ioi ld (ix+126), l             ; D3 DD 75 7E
 ioi ld (ix-128), 0             ; D3 DD 36 80 00
 ioi ld (ix-128), 127           ; D3 DD 36 80 7F
 ioi ld (ix-128), 255           ; D3 DD 36 80 FF
 ioi ld (ix-128), a             ; D3 DD 77 80
 ioi ld (ix-128), b             ; D3 DD 70 80
 ioi ld (ix-128), bcde          ; D3 DD CF 80
 ioi ld (ix-128), c             ; D3 DD 71 80
 ioi ld (ix-128), d             ; D3 DD 72 80
 ioi ld (ix-128), e             ; D3 DD 73 80
 ioi ld (ix-128), h             ; D3 DD 74 80
 ioi ld (ix-128), hl            ; D3 F4 80
 ioi ld (ix-128), jkhl          ; D3 FD CF 80
 ioi ld (ix-128), l             ; D3 DD 75 80
 ioi ld (iy), 0                 ; D3 FD 36 00 00
 ioi ld (iy), 127               ; D3 FD 36 00 7F
 ioi ld (iy), 255               ; D3 FD 36 00 FF
 ioi ld (iy), a                 ; D3 FD 77 00
 ioi ld (iy), b                 ; D3 FD 70 00
 ioi ld (iy), bcde              ; D3 DD DF 00
 ioi ld (iy), c                 ; D3 FD 71 00
 ioi ld (iy), d                 ; D3 FD 72 00
 ioi ld (iy), e                 ; D3 FD 73 00
 ioi ld (iy), h                 ; D3 FD 74 00
 ioi ld (iy), hl                ; D3 FD F4 00
 ioi ld (iy), jkhl              ; D3 FD DF 00
 ioi ld (iy), l                 ; D3 FD 75 00
 ioi ld (iy+0), 0               ; D3 FD 36 00 00
 ioi ld (iy+0), 127             ; D3 FD 36 00 7F
 ioi ld (iy+0), 255             ; D3 FD 36 00 FF
 ioi ld (iy+0), a               ; D3 FD 77 00
 ioi ld (iy+0), b               ; D3 FD 70 00
 ioi ld (iy+0), bcde            ; D3 DD DF 00
 ioi ld (iy+0), c               ; D3 FD 71 00
 ioi ld (iy+0), d               ; D3 FD 72 00
 ioi ld (iy+0), e               ; D3 FD 73 00
 ioi ld (iy+0), h               ; D3 FD 74 00
 ioi ld (iy+0), hl              ; D3 FD F4 00
 ioi ld (iy+0), jkhl            ; D3 FD DF 00
 ioi ld (iy+0), l               ; D3 FD 75 00
 ioi ld (iy+126), 0             ; D3 FD 36 7E 00
 ioi ld (iy+126), 127           ; D3 FD 36 7E 7F
 ioi ld (iy+126), 255           ; D3 FD 36 7E FF
 ioi ld (iy+126), a             ; D3 FD 77 7E
 ioi ld (iy+126), b             ; D3 FD 70 7E
 ioi ld (iy+126), bcde          ; D3 DD DF 7E
 ioi ld (iy+126), c             ; D3 FD 71 7E
 ioi ld (iy+126), d             ; D3 FD 72 7E
 ioi ld (iy+126), e             ; D3 FD 73 7E
 ioi ld (iy+126), h             ; D3 FD 74 7E
 ioi ld (iy+126), hl            ; D3 FD F4 7E
 ioi ld (iy+126), jkhl          ; D3 FD DF 7E
 ioi ld (iy+126), l             ; D3 FD 75 7E
 ioi ld (iy-128), 0             ; D3 FD 36 80 00
 ioi ld (iy-128), 127           ; D3 FD 36 80 7F
 ioi ld (iy-128), 255           ; D3 FD 36 80 FF
 ioi ld (iy-128), a             ; D3 FD 77 80
 ioi ld (iy-128), b             ; D3 FD 70 80
 ioi ld (iy-128), bcde          ; D3 DD DF 80
 ioi ld (iy-128), c             ; D3 FD 71 80
 ioi ld (iy-128), d             ; D3 FD 72 80
 ioi ld (iy-128), e             ; D3 FD 73 80
 ioi ld (iy-128), h             ; D3 FD 74 80
 ioi ld (iy-128), hl            ; D3 FD F4 80
 ioi ld (iy-128), jkhl          ; D3 FD DF 80
 ioi ld (iy-128), l             ; D3 FD 75 80
 ioi ld a', (0x1234)            ; D3 76 3A 34 12
 ioi ld a', (bc)                ; D3 76 0A
 ioi ld a', (de)                ; D3 76 1A
 ioi ld a', (hl)                ; D3 76 7E
 ioi ld a', (ix)                ; D3 76 DD 7E 00
 ioi ld a', (ix+0)              ; D3 76 DD 7E 00
 ioi ld a', (ix+126)            ; D3 76 DD 7E 7E
 ioi ld a', (ix+a)              ; D3 76 DD 06
 ioi ld a', (ix-128)            ; D3 76 DD 7E 80
 ioi ld a', (iy)                ; D3 76 FD 7E 00
 ioi ld a', (iy+0)              ; D3 76 FD 7E 00
 ioi ld a', (iy+126)            ; D3 76 FD 7E 7E
 ioi ld a', (iy+a)              ; D3 76 FD 06
 ioi ld a', (iy-128)            ; D3 76 FD 7E 80
 ioi ld a, (0x1234)             ; D3 3A 34 12
 ioi ld a, (bc)                 ; D3 0A
 ioi ld a, (de)                 ; D3 1A
 ioi ld a, (hl)                 ; D3 7E
 ioi ld a, (ix)                 ; D3 DD 7E 00
 ioi ld a, (ix+0)               ; D3 DD 7E 00
 ioi ld a, (ix+126)             ; D3 DD 7E 7E
 ioi ld a, (ix+a)               ; D3 DD 06
 ioi ld a, (ix-128)             ; D3 DD 7E 80
 ioi ld a, (iy)                 ; D3 FD 7E 00
 ioi ld a, (iy+0)               ; D3 FD 7E 00
 ioi ld a, (iy+126)             ; D3 FD 7E 7E
 ioi ld a, (iy+a)               ; D3 FD 06
 ioi ld a, (iy-128)             ; D3 FD 7E 80
 ioi ld b', (hl)                ; D3 76 46
 ioi ld b', (ix)                ; D3 76 DD 46 00
 ioi ld b', (ix+0)              ; D3 76 DD 46 00
 ioi ld b', (ix+126)            ; D3 76 DD 46 7E
 ioi ld b', (ix-128)            ; D3 76 DD 46 80
 ioi ld b', (iy)                ; D3 76 FD 46 00
 ioi ld b', (iy+0)              ; D3 76 FD 46 00
 ioi ld b', (iy+126)            ; D3 76 FD 46 7E
 ioi ld b', (iy-128)            ; D3 76 FD 46 80
 ioi ld b, (hl)                 ; D3 46
 ioi ld b, (ix)                 ; D3 DD 46 00
 ioi ld b, (ix+0)               ; D3 DD 46 00
 ioi ld b, (ix+126)             ; D3 DD 46 7E
 ioi ld b, (ix-128)             ; D3 DD 46 80
 ioi ld b, (iy)                 ; D3 FD 46 00
 ioi ld b, (iy+0)               ; D3 FD 46 00
 ioi ld b, (iy+126)             ; D3 FD 46 7E
 ioi ld b, (iy-128)             ; D3 FD 46 80
 ioi ld bc', (0x1234)           ; D3 76 ED 4B 34 12
 ioi ld bc, (0x1234)            ; D3 ED 4B 34 12
 ioi ld bcde', (0x1234)         ; D3 76 93 34 12
 ioi ld bcde', (hl)             ; D3 76 DD 1A
 ioi ld bcde', (ix)             ; D3 76 DD CE 00
 ioi ld bcde', (ix+0)           ; D3 76 DD CE 00
 ioi ld bcde', (ix+126)         ; D3 76 DD CE 7E
 ioi ld bcde', (ix-128)         ; D3 76 DD CE 80
 ioi ld bcde', (iy)             ; D3 76 DD DE 00
 ioi ld bcde', (iy+0)           ; D3 76 DD DE 00
 ioi ld bcde', (iy+126)         ; D3 76 DD DE 7E
 ioi ld bcde', (iy-128)         ; D3 76 DD DE 80
 ioi ld bcde, (0x1234)          ; D3 93 34 12
 ioi ld bcde, (hl)              ; D3 DD 1A
 ioi ld bcde, (ix)              ; D3 DD CE 00
 ioi ld bcde, (ix+0)            ; D3 DD CE 00
 ioi ld bcde, (ix+126)          ; D3 DD CE 7E
 ioi ld bcde, (ix-128)          ; D3 DD CE 80
 ioi ld bcde, (iy)              ; D3 DD DE 00
 ioi ld bcde, (iy+0)            ; D3 DD DE 00
 ioi ld bcde, (iy+126)          ; D3 DD DE 7E
 ioi ld bcde, (iy-128)          ; D3 DD DE 80
 ioi ld c', (hl)                ; D3 76 4E
 ioi ld c', (ix)                ; D3 76 DD 4E 00
 ioi ld c', (ix+0)              ; D3 76 DD 4E 00
 ioi ld c', (ix+126)            ; D3 76 DD 4E 7E
 ioi ld c', (ix-128)            ; D3 76 DD 4E 80
 ioi ld c', (iy)                ; D3 76 FD 4E 00
 ioi ld c', (iy+0)              ; D3 76 FD 4E 00
 ioi ld c', (iy+126)            ; D3 76 FD 4E 7E
 ioi ld c', (iy-128)            ; D3 76 FD 4E 80
 ioi ld c, (hl)                 ; D3 4E
 ioi ld c, (ix)                 ; D3 DD 4E 00
 ioi ld c, (ix+0)               ; D3 DD 4E 00
 ioi ld c, (ix+126)             ; D3 DD 4E 7E
 ioi ld c, (ix-128)             ; D3 DD 4E 80
 ioi ld c, (iy)                 ; D3 FD 4E 00
 ioi ld c, (iy+0)               ; D3 FD 4E 00
 ioi ld c, (iy+126)             ; D3 FD 4E 7E
 ioi ld c, (iy-128)             ; D3 FD 4E 80
 ioi ld d', (hl)                ; D3 76 56
 ioi ld d', (ix)                ; D3 76 DD 56 00
 ioi ld d', (ix+0)              ; D3 76 DD 56 00
 ioi ld d', (ix+126)            ; D3 76 DD 56 7E
 ioi ld d', (ix-128)            ; D3 76 DD 56 80
 ioi ld d', (iy)                ; D3 76 FD 56 00
 ioi ld d', (iy+0)              ; D3 76 FD 56 00
 ioi ld d', (iy+126)            ; D3 76 FD 56 7E
 ioi ld d', (iy-128)            ; D3 76 FD 56 80
 ioi ld d, (hl)                 ; D3 56
 ioi ld d, (ix)                 ; D3 DD 56 00
 ioi ld d, (ix+0)               ; D3 DD 56 00
 ioi ld d, (ix+126)             ; D3 DD 56 7E
 ioi ld d, (ix-128)             ; D3 DD 56 80
 ioi ld d, (iy)                 ; D3 FD 56 00
 ioi ld d, (iy+0)               ; D3 FD 56 00
 ioi ld d, (iy+126)             ; D3 FD 56 7E
 ioi ld d, (iy-128)             ; D3 FD 56 80
 ioi ld de', (0x1234)           ; D3 76 ED 5B 34 12
 ioi ld de, (0x1234)            ; D3 ED 5B 34 12
 ioi ld e', (hl)                ; D3 76 5E
 ioi ld e', (ix)                ; D3 76 DD 5E 00
 ioi ld e', (ix+0)              ; D3 76 DD 5E 00
 ioi ld e', (ix+126)            ; D3 76 DD 5E 7E
 ioi ld e', (ix-128)            ; D3 76 DD 5E 80
 ioi ld e', (iy)                ; D3 76 FD 5E 00
 ioi ld e', (iy+0)              ; D3 76 FD 5E 00
 ioi ld e', (iy+126)            ; D3 76 FD 5E 7E
 ioi ld e', (iy-128)            ; D3 76 FD 5E 80
 ioi ld e, (hl)                 ; D3 5E
 ioi ld e, (ix)                 ; D3 DD 5E 00
 ioi ld e, (ix+0)               ; D3 DD 5E 00
 ioi ld e, (ix+126)             ; D3 DD 5E 7E
 ioi ld e, (ix-128)             ; D3 DD 5E 80
 ioi ld e, (iy)                 ; D3 FD 5E 00
 ioi ld e, (iy+0)               ; D3 FD 5E 00
 ioi ld e, (iy+126)             ; D3 FD 5E 7E
 ioi ld e, (iy-128)             ; D3 FD 5E 80
 ioi ld h', (hl)                ; D3 76 66
 ioi ld h', (ix)                ; D3 76 DD 66 00
 ioi ld h', (ix+0)              ; D3 76 DD 66 00
 ioi ld h', (ix+126)            ; D3 76 DD 66 7E
 ioi ld h', (ix-128)            ; D3 76 DD 66 80
 ioi ld h', (iy)                ; D3 76 FD 66 00
 ioi ld h', (iy+0)              ; D3 76 FD 66 00
 ioi ld h', (iy+126)            ; D3 76 FD 66 7E
 ioi ld h', (iy-128)            ; D3 76 FD 66 80
 ioi ld h, (hl)                 ; D3 66
 ioi ld h, (ix)                 ; D3 DD 66 00
 ioi ld h, (ix+0)               ; D3 DD 66 00
 ioi ld h, (ix+126)             ; D3 DD 66 7E
 ioi ld h, (ix-128)             ; D3 DD 66 80
 ioi ld h, (iy)                 ; D3 FD 66 00
 ioi ld h, (iy+0)               ; D3 FD 66 00
 ioi ld h, (iy+126)             ; D3 FD 66 7E
 ioi ld h, (iy-128)             ; D3 FD 66 80
 ioi ld hl', (0x1234)           ; D3 76 2A 34 12
 ioi ld hl', (hl)               ; D3 76 DD E4 00
 ioi ld hl', (hl+0)             ; D3 76 DD E4 00
 ioi ld hl', (hl+126)           ; D3 76 DD E4 7E
 ioi ld hl', (hl-128)           ; D3 76 DD E4 80
 ioi ld hl', (ix)               ; D3 76 E4 00
 ioi ld hl', (ix+0)             ; D3 76 E4 00
 ioi ld hl', (ix+126)           ; D3 76 E4 7E
 ioi ld hl', (ix-128)           ; D3 76 E4 80
 ioi ld hl', (iy)               ; D3 76 FD E4 00
 ioi ld hl', (iy+0)             ; D3 76 FD E4 00
 ioi ld hl', (iy+126)           ; D3 76 FD E4 7E
 ioi ld hl', (iy-128)           ; D3 76 FD E4 80
 ioi ld hl, (0x1234)            ; D3 2A 34 12
 ioi ld hl, (hl)                ; D3 DD E4 00
 ioi ld hl, (hl+0)              ; D3 DD E4 00
 ioi ld hl, (hl+126)            ; D3 DD E4 7E
 ioi ld hl, (hl-128)            ; D3 DD E4 80
 ioi ld hl, (ix)                ; D3 E4 00
 ioi ld hl, (ix+0)              ; D3 E4 00
 ioi ld hl, (ix+126)            ; D3 E4 7E
 ioi ld hl, (ix-128)            ; D3 E4 80
 ioi ld hl, (iy)                ; D3 FD E4 00
 ioi ld hl, (iy+0)              ; D3 FD E4 00
 ioi ld hl, (iy+126)            ; D3 FD E4 7E
 ioi ld hl, (iy-128)            ; D3 FD E4 80
 ioi ld ix, (0x1234)            ; D3 DD 2A 34 12
 ioi ld iy, (0x1234)            ; D3 FD 2A 34 12
 ioi ld jk', (0x1234)           ; D3 76 99 34 12
 ioi ld jk, (0x1234)            ; D3 99 34 12
 ioi ld jkhl', (0x1234)         ; D3 76 94 34 12
 ioi ld jkhl', (hl)             ; D3 76 FD 1A
 ioi ld jkhl', (ix)             ; D3 76 FD CE 00
 ioi ld jkhl', (ix+0)           ; D3 76 FD CE 00
 ioi ld jkhl', (ix+126)         ; D3 76 FD CE 7E
 ioi ld jkhl', (ix-128)         ; D3 76 FD CE 80
 ioi ld jkhl', (iy)             ; D3 76 FD DE 00
 ioi ld jkhl', (iy+0)           ; D3 76 FD DE 00
 ioi ld jkhl', (iy+126)         ; D3 76 FD DE 7E
 ioi ld jkhl', (iy-128)         ; D3 76 FD DE 80
 ioi ld jkhl, (0x1234)          ; D3 94 34 12
 ioi ld jkhl, (hl)              ; D3 FD 1A
 ioi ld jkhl, (ix)              ; D3 FD CE 00
 ioi ld jkhl, (ix+0)            ; D3 FD CE 00
 ioi ld jkhl, (ix+126)          ; D3 FD CE 7E
 ioi ld jkhl, (ix-128)          ; D3 FD CE 80
 ioi ld jkhl, (iy)              ; D3 FD DE 00
 ioi ld jkhl, (iy+0)            ; D3 FD DE 00
 ioi ld jkhl, (iy+126)          ; D3 FD DE 7E
 ioi ld jkhl, (iy-128)          ; D3 FD DE 80
 ioi ld l', (hl)                ; D3 76 6E
 ioi ld l', (ix)                ; D3 76 DD 6E 00
 ioi ld l', (ix+0)              ; D3 76 DD 6E 00
 ioi ld l', (ix+126)            ; D3 76 DD 6E 7E
 ioi ld l', (ix-128)            ; D3 76 DD 6E 80
 ioi ld l', (iy)                ; D3 76 FD 6E 00
 ioi ld l', (iy+0)              ; D3 76 FD 6E 00
 ioi ld l', (iy+126)            ; D3 76 FD 6E 7E
 ioi ld l', (iy-128)            ; D3 76 FD 6E 80
 ioi ld l, (hl)                 ; D3 6E
 ioi ld l, (ix)                 ; D3 DD 6E 00
 ioi ld l, (ix+0)               ; D3 DD 6E 00
 ioi ld l, (ix+126)             ; D3 DD 6E 7E
 ioi ld l, (ix-128)             ; D3 DD 6E 80
 ioi ld l, (iy)                 ; D3 FD 6E 00
 ioi ld l, (iy+0)               ; D3 FD 6E 00
 ioi ld l, (iy+126)             ; D3 FD 6E 7E
 ioi ld l, (iy-128)             ; D3 FD 6E 80
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
 ioi or (hl)                    ; D3 7F B6
 ioi or (ix)                    ; D3 DD B6 00
 ioi or (ix+0)                  ; D3 DD B6 00
 ioi or (ix+126)                ; D3 DD B6 7E
 ioi or (ix-128)                ; D3 DD B6 80
 ioi or (iy)                    ; D3 FD B6 00
 ioi or (iy+0)                  ; D3 FD B6 00
 ioi or (iy+126)                ; D3 FD B6 7E
 ioi or (iy-128)                ; D3 FD B6 80
 ioi res 0, (hl)                ; D3 CB 86
 ioi res 0, (ix)                ; D3 DD CB 00 86
 ioi res 0, (ix+0)              ; D3 DD CB 00 86
 ioi res 0, (ix+126)            ; D3 DD CB 7E 86
 ioi res 0, (ix-128)            ; D3 DD CB 80 86
 ioi res 0, (iy)                ; D3 FD CB 00 86
 ioi res 0, (iy+0)              ; D3 FD CB 00 86
 ioi res 0, (iy+126)            ; D3 FD CB 7E 86
 ioi res 0, (iy-128)            ; D3 FD CB 80 86
 ioi res 1, (hl)                ; D3 CB 8E
 ioi res 1, (ix)                ; D3 DD CB 00 8E
 ioi res 1, (ix+0)              ; D3 DD CB 00 8E
 ioi res 1, (ix+126)            ; D3 DD CB 7E 8E
 ioi res 1, (ix-128)            ; D3 DD CB 80 8E
 ioi res 1, (iy)                ; D3 FD CB 00 8E
 ioi res 1, (iy+0)              ; D3 FD CB 00 8E
 ioi res 1, (iy+126)            ; D3 FD CB 7E 8E
 ioi res 1, (iy-128)            ; D3 FD CB 80 8E
 ioi res 2, (hl)                ; D3 CB 96
 ioi res 2, (ix)                ; D3 DD CB 00 96
 ioi res 2, (ix+0)              ; D3 DD CB 00 96
 ioi res 2, (ix+126)            ; D3 DD CB 7E 96
 ioi res 2, (ix-128)            ; D3 DD CB 80 96
 ioi res 2, (iy)                ; D3 FD CB 00 96
 ioi res 2, (iy+0)              ; D3 FD CB 00 96
 ioi res 2, (iy+126)            ; D3 FD CB 7E 96
 ioi res 2, (iy-128)            ; D3 FD CB 80 96
 ioi res 3, (hl)                ; D3 CB 9E
 ioi res 3, (ix)                ; D3 DD CB 00 9E
 ioi res 3, (ix+0)              ; D3 DD CB 00 9E
 ioi res 3, (ix+126)            ; D3 DD CB 7E 9E
 ioi res 3, (ix-128)            ; D3 DD CB 80 9E
 ioi res 3, (iy)                ; D3 FD CB 00 9E
 ioi res 3, (iy+0)              ; D3 FD CB 00 9E
 ioi res 3, (iy+126)            ; D3 FD CB 7E 9E
 ioi res 3, (iy-128)            ; D3 FD CB 80 9E
 ioi res 4, (hl)                ; D3 CB A6
 ioi res 4, (ix)                ; D3 DD CB 00 A6
 ioi res 4, (ix+0)              ; D3 DD CB 00 A6
 ioi res 4, (ix+126)            ; D3 DD CB 7E A6
 ioi res 4, (ix-128)            ; D3 DD CB 80 A6
 ioi res 4, (iy)                ; D3 FD CB 00 A6
 ioi res 4, (iy+0)              ; D3 FD CB 00 A6
 ioi res 4, (iy+126)            ; D3 FD CB 7E A6
 ioi res 4, (iy-128)            ; D3 FD CB 80 A6
 ioi res 5, (hl)                ; D3 CB AE
 ioi res 5, (ix)                ; D3 DD CB 00 AE
 ioi res 5, (ix+0)              ; D3 DD CB 00 AE
 ioi res 5, (ix+126)            ; D3 DD CB 7E AE
 ioi res 5, (ix-128)            ; D3 DD CB 80 AE
 ioi res 5, (iy)                ; D3 FD CB 00 AE
 ioi res 5, (iy+0)              ; D3 FD CB 00 AE
 ioi res 5, (iy+126)            ; D3 FD CB 7E AE
 ioi res 5, (iy-128)            ; D3 FD CB 80 AE
 ioi res 6, (hl)                ; D3 CB B6
 ioi res 6, (ix)                ; D3 DD CB 00 B6
 ioi res 6, (ix+0)              ; D3 DD CB 00 B6
 ioi res 6, (ix+126)            ; D3 DD CB 7E B6
 ioi res 6, (ix-128)            ; D3 DD CB 80 B6
 ioi res 6, (iy)                ; D3 FD CB 00 B6
 ioi res 6, (iy+0)              ; D3 FD CB 00 B6
 ioi res 6, (iy+126)            ; D3 FD CB 7E B6
 ioi res 6, (iy-128)            ; D3 FD CB 80 B6
 ioi res 7, (hl)                ; D3 CB BE
 ioi res 7, (ix)                ; D3 DD CB 00 BE
 ioi res 7, (ix+0)              ; D3 DD CB 00 BE
 ioi res 7, (ix+126)            ; D3 DD CB 7E BE
 ioi res 7, (ix-128)            ; D3 DD CB 80 BE
 ioi res 7, (iy)                ; D3 FD CB 00 BE
 ioi res 7, (iy+0)              ; D3 FD CB 00 BE
 ioi res 7, (iy+126)            ; D3 FD CB 7E BE
 ioi res 7, (iy-128)            ; D3 FD CB 80 BE
 ioi rl (hl)                    ; D3 CB 16
 ioi rl (ix)                    ; D3 DD CB 00 16
 ioi rl (ix+0)                  ; D3 DD CB 00 16
 ioi rl (ix+126)                ; D3 DD CB 7E 16
 ioi rl (ix-128)                ; D3 DD CB 80 16
 ioi rl (iy)                    ; D3 FD CB 00 16
 ioi rl (iy+0)                  ; D3 FD CB 00 16
 ioi rl (iy+126)                ; D3 FD CB 7E 16
 ioi rl (iy-128)                ; D3 FD CB 80 16
 ioi rlc (hl)                   ; D3 CB 06
 ioi rlc (ix)                   ; D3 DD CB 00 06
 ioi rlc (ix+0)                 ; D3 DD CB 00 06
 ioi rlc (ix+126)               ; D3 DD CB 7E 06
 ioi rlc (ix-128)               ; D3 DD CB 80 06
 ioi rlc (iy)                   ; D3 FD CB 00 06
 ioi rlc (iy+0)                 ; D3 FD CB 00 06
 ioi rlc (iy+126)               ; D3 FD CB 7E 06
 ioi rlc (iy-128)               ; D3 FD CB 80 06
 ioi rr (hl)                    ; D3 CB 1E
 ioi rr (ix)                    ; D3 DD CB 00 1E
 ioi rr (ix+0)                  ; D3 DD CB 00 1E
 ioi rr (ix+126)                ; D3 DD CB 7E 1E
 ioi rr (ix-128)                ; D3 DD CB 80 1E
 ioi rr (iy)                    ; D3 FD CB 00 1E
 ioi rr (iy+0)                  ; D3 FD CB 00 1E
 ioi rr (iy+126)                ; D3 FD CB 7E 1E
 ioi rr (iy-128)                ; D3 FD CB 80 1E
 ioi rrc (hl)                   ; D3 CB 0E
 ioi rrc (ix)                   ; D3 DD CB 00 0E
 ioi rrc (ix+0)                 ; D3 DD CB 00 0E
 ioi rrc (ix+126)               ; D3 DD CB 7E 0E
 ioi rrc (ix-128)               ; D3 DD CB 80 0E
 ioi rrc (iy)                   ; D3 FD CB 00 0E
 ioi rrc (iy+0)                 ; D3 FD CB 00 0E
 ioi rrc (iy+126)               ; D3 FD CB 7E 0E
 ioi rrc (iy-128)               ; D3 FD CB 80 0E
 ioi sbc a', (hl)               ; D3 76 7F 9E
 ioi sbc a', (ix)               ; D3 76 DD 9E 00
 ioi sbc a', (ix+0)             ; D3 76 DD 9E 00
 ioi sbc a', (ix+126)           ; D3 76 DD 9E 7E
 ioi sbc a', (ix-128)           ; D3 76 DD 9E 80
 ioi sbc a', (iy)               ; D3 76 FD 9E 00
 ioi sbc a', (iy+0)             ; D3 76 FD 9E 00
 ioi sbc a', (iy+126)           ; D3 76 FD 9E 7E
 ioi sbc a', (iy-128)           ; D3 76 FD 9E 80
 ioi sbc a, (hl)                ; D3 7F 9E
 ioi sbc a, (ix)                ; D3 DD 9E 00
 ioi sbc a, (ix+0)              ; D3 DD 9E 00
 ioi sbc a, (ix+126)            ; D3 DD 9E 7E
 ioi sbc a, (ix-128)            ; D3 DD 9E 80
 ioi sbc a, (iy)                ; D3 FD 9E 00
 ioi sbc a, (iy+0)              ; D3 FD 9E 00
 ioi sbc a, (iy+126)            ; D3 FD 9E 7E
 ioi sbc a, (iy-128)            ; D3 FD 9E 80
 ioi set 0, (hl)                ; D3 CB C6
 ioi set 0, (ix)                ; D3 DD CB 00 C6
 ioi set 0, (ix+0)              ; D3 DD CB 00 C6
 ioi set 0, (ix+126)            ; D3 DD CB 7E C6
 ioi set 0, (ix-128)            ; D3 DD CB 80 C6
 ioi set 0, (iy)                ; D3 FD CB 00 C6
 ioi set 0, (iy+0)              ; D3 FD CB 00 C6
 ioi set 0, (iy+126)            ; D3 FD CB 7E C6
 ioi set 0, (iy-128)            ; D3 FD CB 80 C6
 ioi set 1, (hl)                ; D3 CB CE
 ioi set 1, (ix)                ; D3 DD CB 00 CE
 ioi set 1, (ix+0)              ; D3 DD CB 00 CE
 ioi set 1, (ix+126)            ; D3 DD CB 7E CE
 ioi set 1, (ix-128)            ; D3 DD CB 80 CE
 ioi set 1, (iy)                ; D3 FD CB 00 CE
 ioi set 1, (iy+0)              ; D3 FD CB 00 CE
 ioi set 1, (iy+126)            ; D3 FD CB 7E CE
 ioi set 1, (iy-128)            ; D3 FD CB 80 CE
 ioi set 2, (hl)                ; D3 CB D6
 ioi set 2, (ix)                ; D3 DD CB 00 D6
 ioi set 2, (ix+0)              ; D3 DD CB 00 D6
 ioi set 2, (ix+126)            ; D3 DD CB 7E D6
 ioi set 2, (ix-128)            ; D3 DD CB 80 D6
 ioi set 2, (iy)                ; D3 FD CB 00 D6
 ioi set 2, (iy+0)              ; D3 FD CB 00 D6
 ioi set 2, (iy+126)            ; D3 FD CB 7E D6
 ioi set 2, (iy-128)            ; D3 FD CB 80 D6
 ioi set 3, (hl)                ; D3 CB DE
 ioi set 3, (ix)                ; D3 DD CB 00 DE
 ioi set 3, (ix+0)              ; D3 DD CB 00 DE
 ioi set 3, (ix+126)            ; D3 DD CB 7E DE
 ioi set 3, (ix-128)            ; D3 DD CB 80 DE
 ioi set 3, (iy)                ; D3 FD CB 00 DE
 ioi set 3, (iy+0)              ; D3 FD CB 00 DE
 ioi set 3, (iy+126)            ; D3 FD CB 7E DE
 ioi set 3, (iy-128)            ; D3 FD CB 80 DE
 ioi set 4, (hl)                ; D3 CB E6
 ioi set 4, (ix)                ; D3 DD CB 00 E6
 ioi set 4, (ix+0)              ; D3 DD CB 00 E6
 ioi set 4, (ix+126)            ; D3 DD CB 7E E6
 ioi set 4, (ix-128)            ; D3 DD CB 80 E6
 ioi set 4, (iy)                ; D3 FD CB 00 E6
 ioi set 4, (iy+0)              ; D3 FD CB 00 E6
 ioi set 4, (iy+126)            ; D3 FD CB 7E E6
 ioi set 4, (iy-128)            ; D3 FD CB 80 E6
 ioi set 5, (hl)                ; D3 CB EE
 ioi set 5, (ix)                ; D3 DD CB 00 EE
 ioi set 5, (ix+0)              ; D3 DD CB 00 EE
 ioi set 5, (ix+126)            ; D3 DD CB 7E EE
 ioi set 5, (ix-128)            ; D3 DD CB 80 EE
 ioi set 5, (iy)                ; D3 FD CB 00 EE
 ioi set 5, (iy+0)              ; D3 FD CB 00 EE
 ioi set 5, (iy+126)            ; D3 FD CB 7E EE
 ioi set 5, (iy-128)            ; D3 FD CB 80 EE
 ioi set 6, (hl)                ; D3 CB F6
 ioi set 6, (ix)                ; D3 DD CB 00 F6
 ioi set 6, (ix+0)              ; D3 DD CB 00 F6
 ioi set 6, (ix+126)            ; D3 DD CB 7E F6
 ioi set 6, (ix-128)            ; D3 DD CB 80 F6
 ioi set 6, (iy)                ; D3 FD CB 00 F6
 ioi set 6, (iy+0)              ; D3 FD CB 00 F6
 ioi set 6, (iy+126)            ; D3 FD CB 7E F6
 ioi set 6, (iy-128)            ; D3 FD CB 80 F6
 ioi set 7, (hl)                ; D3 CB FE
 ioi set 7, (ix)                ; D3 DD CB 00 FE
 ioi set 7, (ix+0)              ; D3 DD CB 00 FE
 ioi set 7, (ix+126)            ; D3 DD CB 7E FE
 ioi set 7, (ix-128)            ; D3 DD CB 80 FE
 ioi set 7, (iy)                ; D3 FD CB 00 FE
 ioi set 7, (iy+0)              ; D3 FD CB 00 FE
 ioi set 7, (iy+126)            ; D3 FD CB 7E FE
 ioi set 7, (iy-128)            ; D3 FD CB 80 FE
 ioi sla (hl)                   ; D3 CB 26
 ioi sla (ix)                   ; D3 DD CB 00 26
 ioi sla (ix+0)                 ; D3 DD CB 00 26
 ioi sla (ix+126)               ; D3 DD CB 7E 26
 ioi sla (ix-128)               ; D3 DD CB 80 26
 ioi sla (iy)                   ; D3 FD CB 00 26
 ioi sla (iy+0)                 ; D3 FD CB 00 26
 ioi sla (iy+126)               ; D3 FD CB 7E 26
 ioi sla (iy-128)               ; D3 FD CB 80 26
 ioi sra (hl)                   ; D3 CB 2E
 ioi sra (ix)                   ; D3 DD CB 00 2E
 ioi sra (ix+0)                 ; D3 DD CB 00 2E
 ioi sra (ix+126)               ; D3 DD CB 7E 2E
 ioi sra (ix-128)               ; D3 DD CB 80 2E
 ioi sra (iy)                   ; D3 FD CB 00 2E
 ioi sra (iy+0)                 ; D3 FD CB 00 2E
 ioi sra (iy+126)               ; D3 FD CB 7E 2E
 ioi sra (iy-128)               ; D3 FD CB 80 2E
 ioi srl (hl)                   ; D3 CB 3E
 ioi srl (ix)                   ; D3 DD CB 00 3E
 ioi srl (ix+0)                 ; D3 DD CB 00 3E
 ioi srl (ix+126)               ; D3 DD CB 7E 3E
 ioi srl (ix-128)               ; D3 DD CB 80 3E
 ioi srl (iy)                   ; D3 FD CB 00 3E
 ioi srl (iy+0)                 ; D3 FD CB 00 3E
 ioi srl (iy+126)               ; D3 FD CB 7E 3E
 ioi srl (iy-128)               ; D3 FD CB 80 3E
 ioi sub (hl)                   ; D3 7F 96
 ioi sub (ix)                   ; D3 DD 96 00
 ioi sub (ix+0)                 ; D3 DD 96 00
 ioi sub (ix+126)               ; D3 DD 96 7E
 ioi sub (ix-128)               ; D3 DD 96 80
 ioi sub (iy)                   ; D3 FD 96 00
 ioi sub (iy+0)                 ; D3 FD 96 00
 ioi sub (iy+126)               ; D3 FD 96 7E
 ioi sub (iy-128)               ; D3 FD 96 80
 ioi xor (hl)                   ; D3 7F AE
 ioi xor (ix)                   ; D3 DD AE 00
 ioi xor (ix+0)                 ; D3 DD AE 00
 ioi xor (ix+126)               ; D3 DD AE 7E
 ioi xor (ix-128)               ; D3 DD AE 80
 ioi xor (iy)                   ; D3 FD AE 00
 ioi xor (iy+0)                 ; D3 FD AE 00
 ioi xor (iy+126)               ; D3 FD AE 7E
 ioi xor (iy-128)               ; D3 FD AE 80
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
 jp (ix)                        ; DD E9
 jp (iy)                        ; FD E9
 jp 0x1234                      ; C3 34 12
 jp c, 0x1234                   ; DA 34 12
 jp gt, 0x1234                  ; A2 34 12
 jp gtu, 0x1234                 ; AA 34 12
 jp lo, 0x1234                  ; EA 34 12
 jp lt, 0x1234                  ; B2 34 12
 jp lz, 0x1234                  ; E2 34 12
 jp m, 0x1234                   ; FA 34 12
 jp nc, 0x1234                  ; D2 34 12
 jp nz, 0x1234                  ; C2 34 12
 jp p, 0x1234                   ; F2 34 12
 jp pe, 0x1234                  ; EA 34 12
 jp po, 0x1234                  ; E2 34 12
 jp v, 0x1234                   ; BA 34 12
 jp z, 0x1234                   ; CA 34 12
 jr ASMPC                       ; 18 FE
 jr c, ASMPC                    ; 38 FE
 jr gt, ASMPC                   ; A0 FE
 jr gtu, ASMPC                  ; A8 FE
 jr lt, ASMPC                   ; B0 FE
 jr nc, ASMPC                   ; 30 FE
 jr nz, ASMPC                   ; 20 FE
 jr v, ASMPC                    ; B8 FE
 jr z, ASMPC                    ; 28 FE
 jre ASMPC                      ; 98 FD FF
 jre c, ASMPC                   ; ED DB FC FF
 jre gt, ASMPC                  ; ED A3 FC FF
 jre gtu, ASMPC                 ; ED AB FC FF
 jre lt, ASMPC                  ; ED B3 FC FF
 jre nc, ASMPC                  ; ED D3 FC FF
 jre nz, ASMPC                  ; ED C3 FC FF
 jre v, ASMPC                   ; ED BB FC FF
 jre z, ASMPC                   ; ED CB FC FF
 lcall 0x56, 0x1234             ; CF 34 12 56
 ld (0x1234), a                 ; 32 34 12
 ld (0x1234), bc                ; ED 43 34 12
 ld (0x1234), bcde              ; 83 34 12
 ld (0x1234), de                ; ED 53 34 12
 ld (0x1234), hl                ; 22 34 12
 ld (0x1234), ix                ; DD 22 34 12
 ld (0x1234), iy                ; FD 22 34 12
 ld (0x1234), jk                ; 89 34 12
 ld (0x1234), jkhl              ; 84 34 12
 ld (0x1234), sp                ; ED 73 34 12
 ld (bc), a                     ; 02
 ld (de), a                     ; 12
 ld (hl), 0                     ; 36 00
 ld (hl), 127                   ; 36 7F
 ld (hl), 255                   ; 36 FF
 ld (hl), a                     ; 77
 ld (hl), b                     ; 70
 ld (hl), bcde                  ; DD 1B
 ld (hl), c                     ; 71
 ld (hl), d                     ; 72
 ld (hl), e                     ; 73
 ld (hl), h                     ; 74
 ld (hl), hl                    ; DD F4 00
 ld (hl), jkhl                  ; FD 1B
 ld (hl), l                     ; 75
 ld (hl+0), hl                  ; DD F4 00
 ld (hl+126), hl                ; DD F4 7E
 ld (hl-128), hl                ; DD F4 80
 ld (ix), 0                     ; DD 36 00 00
 ld (ix), 127                   ; DD 36 00 7F
 ld (ix), 255                   ; DD 36 00 FF
 ld (ix), a                     ; DD 77 00
 ld (ix), b                     ; DD 70 00
 ld (ix), bcde                  ; DD CF 00
 ld (ix), c                     ; DD 71 00
 ld (ix), d                     ; DD 72 00
 ld (ix), e                     ; DD 73 00
 ld (ix), h                     ; DD 74 00
 ld (ix), hl                    ; F4 00
 ld (ix), jkhl                  ; FD CF 00
 ld (ix), l                     ; DD 75 00
 ld (ix+0), 0                   ; DD 36 00 00
 ld (ix+0), 127                 ; DD 36 00 7F
 ld (ix+0), 255                 ; DD 36 00 FF
 ld (ix+0), a                   ; DD 77 00
 ld (ix+0), b                   ; DD 70 00
 ld (ix+0), bcde                ; DD CF 00
 ld (ix+0), c                   ; DD 71 00
 ld (ix+0), d                   ; DD 72 00
 ld (ix+0), e                   ; DD 73 00
 ld (ix+0), h                   ; DD 74 00
 ld (ix+0), hl                  ; F4 00
 ld (ix+0), jkhl                ; FD CF 00
 ld (ix+0), l                   ; DD 75 00
 ld (ix+126), 0                 ; DD 36 7E 00
 ld (ix+126), 127               ; DD 36 7E 7F
 ld (ix+126), 255               ; DD 36 7E FF
 ld (ix+126), a                 ; DD 77 7E
 ld (ix+126), b                 ; DD 70 7E
 ld (ix+126), bcde              ; DD CF 7E
 ld (ix+126), c                 ; DD 71 7E
 ld (ix+126), d                 ; DD 72 7E
 ld (ix+126), e                 ; DD 73 7E
 ld (ix+126), h                 ; DD 74 7E
 ld (ix+126), hl                ; F4 7E
 ld (ix+126), jkhl              ; FD CF 7E
 ld (ix+126), l                 ; DD 75 7E
 ld (ix-128), 0                 ; DD 36 80 00
 ld (ix-128), 127               ; DD 36 80 7F
 ld (ix-128), 255               ; DD 36 80 FF
 ld (ix-128), a                 ; DD 77 80
 ld (ix-128), b                 ; DD 70 80
 ld (ix-128), bcde              ; DD CF 80
 ld (ix-128), c                 ; DD 71 80
 ld (ix-128), d                 ; DD 72 80
 ld (ix-128), e                 ; DD 73 80
 ld (ix-128), h                 ; DD 74 80
 ld (ix-128), hl                ; F4 80
 ld (ix-128), jkhl              ; FD CF 80
 ld (ix-128), l                 ; DD 75 80
 ld (iy), 0                     ; FD 36 00 00
 ld (iy), 127                   ; FD 36 00 7F
 ld (iy), 255                   ; FD 36 00 FF
 ld (iy), a                     ; FD 77 00
 ld (iy), b                     ; FD 70 00
 ld (iy), bcde                  ; DD DF 00
 ld (iy), c                     ; FD 71 00
 ld (iy), d                     ; FD 72 00
 ld (iy), e                     ; FD 73 00
 ld (iy), h                     ; FD 74 00
 ld (iy), hl                    ; FD F4 00
 ld (iy), jkhl                  ; FD DF 00
 ld (iy), l                     ; FD 75 00
 ld (iy+0), 0                   ; FD 36 00 00
 ld (iy+0), 127                 ; FD 36 00 7F
 ld (iy+0), 255                 ; FD 36 00 FF
 ld (iy+0), a                   ; FD 77 00
 ld (iy+0), b                   ; FD 70 00
 ld (iy+0), bcde                ; DD DF 00
 ld (iy+0), c                   ; FD 71 00
 ld (iy+0), d                   ; FD 72 00
 ld (iy+0), e                   ; FD 73 00
 ld (iy+0), h                   ; FD 74 00
 ld (iy+0), hl                  ; FD F4 00
 ld (iy+0), jkhl                ; FD DF 00
 ld (iy+0), l                   ; FD 75 00
 ld (iy+126), 0                 ; FD 36 7E 00
 ld (iy+126), 127               ; FD 36 7E 7F
 ld (iy+126), 255               ; FD 36 7E FF
 ld (iy+126), a                 ; FD 77 7E
 ld (iy+126), b                 ; FD 70 7E
 ld (iy+126), bcde              ; DD DF 7E
 ld (iy+126), c                 ; FD 71 7E
 ld (iy+126), d                 ; FD 72 7E
 ld (iy+126), e                 ; FD 73 7E
 ld (iy+126), h                 ; FD 74 7E
 ld (iy+126), hl                ; FD F4 7E
 ld (iy+126), jkhl              ; FD DF 7E
 ld (iy+126), l                 ; FD 75 7E
 ld (iy-128), 0                 ; FD 36 80 00
 ld (iy-128), 127               ; FD 36 80 7F
 ld (iy-128), 255               ; FD 36 80 FF
 ld (iy-128), a                 ; FD 77 80
 ld (iy-128), b                 ; FD 70 80
 ld (iy-128), bcde              ; DD DF 80
 ld (iy-128), c                 ; FD 71 80
 ld (iy-128), d                 ; FD 72 80
 ld (iy-128), e                 ; FD 73 80
 ld (iy-128), h                 ; FD 74 80
 ld (iy-128), hl                ; FD F4 80
 ld (iy-128), jkhl              ; FD DF 80
 ld (iy-128), l                 ; FD 75 80
 ld (pw), a                     ; 8E 00
 ld (pw), bc                    ; 6D 01 00
 ld (pw), bcde                  ; DD 0F 00
 ld (pw), de                    ; 6D 41 00
 ld (pw), hl                    ; 86 00
 ld (pw), ix                    ; 6D 81 00
 ld (pw), iy                    ; 6D C1 00
 ld (pw), jkhl                  ; FD 0F 00
 ld (pw), pw                    ; 6D 09 00
 ld (pw), px                    ; 6D 49 00
 ld (pw), py                    ; 6D 89 00
 ld (pw), pz                    ; 6D C9 00
 ld (pw+0), a                   ; 8E 00
 ld (pw+0), bc                  ; 6D 01 00
 ld (pw+0), bcde                ; DD 0F 00
 ld (pw+0), de                  ; 6D 41 00
 ld (pw+0), hl                  ; 86 00
 ld (pw+0), ix                  ; 6D 81 00
 ld (pw+0), iy                  ; 6D C1 00
 ld (pw+0), jkhl                ; FD 0F 00
 ld (pw+0), pw                  ; 6D 09 00
 ld (pw+0), px                  ; 6D 49 00
 ld (pw+0), py                  ; 6D 89 00
 ld (pw+0), pz                  ; 6D C9 00
 ld (pw+126), a                 ; 8E 7E
 ld (pw+126), bc                ; 6D 01 7E
 ld (pw+126), bcde              ; DD 0F 7E
 ld (pw+126), de                ; 6D 41 7E
 ld (pw+126), hl                ; 86 7E
 ld (pw+126), ix                ; 6D 81 7E
 ld (pw+126), iy                ; 6D C1 7E
 ld (pw+126), jkhl              ; FD 0F 7E
 ld (pw+126), pw                ; 6D 09 7E
 ld (pw+126), px                ; 6D 49 7E
 ld (pw+126), py                ; 6D 89 7E
 ld (pw+126), pz                ; 6D C9 7E
 ld (pw+bc), hl                 ; ED 07
 ld (pw+hl), a                  ; 8C
 ld (pw+hl), bc                 ; 6D 03
 ld (pw+hl), bcde               ; DD 0D
 ld (pw+hl), de                 ; 6D 43
 ld (pw+hl), ix                 ; 6D 83
 ld (pw+hl), iy                 ; 6D C3
 ld (pw+hl), jkhl               ; FD 0D
 ld (pw+hl), pw                 ; 6D 0B
 ld (pw+hl), px                 ; 6D 4B
 ld (pw+hl), py                 ; 6D 8B
 ld (pw+hl), pz                 ; 6D CB
 ld (pw-128), a                 ; 8E 80
 ld (pw-128), bc                ; 6D 01 80
 ld (pw-128), bcde              ; DD 0F 80
 ld (pw-128), de                ; 6D 41 80
 ld (pw-128), hl                ; 86 80
 ld (pw-128), ix                ; 6D 81 80
 ld (pw-128), iy                ; 6D C1 80
 ld (pw-128), jkhl              ; FD 0F 80
 ld (pw-128), pw                ; 6D 09 80
 ld (pw-128), px                ; 6D 49 80
 ld (pw-128), py                ; 6D 89 80
 ld (pw-128), pz                ; 6D C9 80
 ld (px), a                     ; 9E 00
 ld (px), bc                    ; 6D 11 00
 ld (px), bcde                  ; DD 1F 00
 ld (px), de                    ; 6D 51 00
 ld (px), hl                    ; 96 00
 ld (px), ix                    ; 6D 91 00
 ld (px), iy                    ; 6D D1 00
 ld (px), jkhl                  ; FD 1F 00
 ld (px), pw                    ; 6D 19 00
 ld (px), px                    ; 6D 59 00
 ld (px), py                    ; 6D 99 00
 ld (px), pz                    ; 6D D9 00
 ld (px+0), a                   ; 9E 00
 ld (px+0), bc                  ; 6D 11 00
 ld (px+0), bcde                ; DD 1F 00
 ld (px+0), de                  ; 6D 51 00
 ld (px+0), hl                  ; 96 00
 ld (px+0), ix                  ; 6D 91 00
 ld (px+0), iy                  ; 6D D1 00
 ld (px+0), jkhl                ; FD 1F 00
 ld (px+0), pw                  ; 6D 19 00
 ld (px+0), px                  ; 6D 59 00
 ld (px+0), py                  ; 6D 99 00
 ld (px+0), pz                  ; 6D D9 00
 ld (px+126), a                 ; 9E 7E
 ld (px+126), bc                ; 6D 11 7E
 ld (px+126), bcde              ; DD 1F 7E
 ld (px+126), de                ; 6D 51 7E
 ld (px+126), hl                ; 96 7E
 ld (px+126), ix                ; 6D 91 7E
 ld (px+126), iy                ; 6D D1 7E
 ld (px+126), jkhl              ; FD 1F 7E
 ld (px+126), pw                ; 6D 19 7E
 ld (px+126), px                ; 6D 59 7E
 ld (px+126), py                ; 6D 99 7E
 ld (px+126), pz                ; 6D D9 7E
 ld (px+bc), hl                 ; ED 17
 ld (px+hl), a                  ; 9C
 ld (px+hl), bc                 ; 6D 13
 ld (px+hl), bcde               ; DD 1D
 ld (px+hl), de                 ; 6D 53
 ld (px+hl), ix                 ; 6D 93
 ld (px+hl), iy                 ; 6D D3
 ld (px+hl), jkhl               ; FD 1D
 ld (px+hl), pw                 ; 6D 1B
 ld (px+hl), px                 ; 6D 5B
 ld (px+hl), py                 ; 6D 9B
 ld (px+hl), pz                 ; 6D DB
 ld (px-128), a                 ; 9E 80
 ld (px-128), bc                ; 6D 11 80
 ld (px-128), bcde              ; DD 1F 80
 ld (px-128), de                ; 6D 51 80
 ld (px-128), hl                ; 96 80
 ld (px-128), ix                ; 6D 91 80
 ld (px-128), iy                ; 6D D1 80
 ld (px-128), jkhl              ; FD 1F 80
 ld (px-128), pw                ; 6D 19 80
 ld (px-128), px                ; 6D 59 80
 ld (px-128), py                ; 6D 99 80
 ld (px-128), pz                ; 6D D9 80
 ld (py), a                     ; AE 00
 ld (py), bc                    ; 6D 21 00
 ld (py), bcde                  ; DD 2F 00
 ld (py), de                    ; 6D 61 00
 ld (py), hl                    ; A6 00
 ld (py), ix                    ; 6D A1 00
 ld (py), iy                    ; 6D E1 00
 ld (py), jkhl                  ; FD 2F 00
 ld (py), pw                    ; 6D 29 00
 ld (py), px                    ; 6D 69 00
 ld (py), py                    ; 6D A9 00
 ld (py), pz                    ; 6D E9 00
 ld (py+0), a                   ; AE 00
 ld (py+0), bc                  ; 6D 21 00
 ld (py+0), bcde                ; DD 2F 00
 ld (py+0), de                  ; 6D 61 00
 ld (py+0), hl                  ; A6 00
 ld (py+0), ix                  ; 6D A1 00
 ld (py+0), iy                  ; 6D E1 00
 ld (py+0), jkhl                ; FD 2F 00
 ld (py+0), pw                  ; 6D 29 00
 ld (py+0), px                  ; 6D 69 00
 ld (py+0), py                  ; 6D A9 00
 ld (py+0), pz                  ; 6D E9 00
 ld (py+126), a                 ; AE 7E
 ld (py+126), bc                ; 6D 21 7E
 ld (py+126), bcde              ; DD 2F 7E
 ld (py+126), de                ; 6D 61 7E
 ld (py+126), hl                ; A6 7E
 ld (py+126), ix                ; 6D A1 7E
 ld (py+126), iy                ; 6D E1 7E
 ld (py+126), jkhl              ; FD 2F 7E
 ld (py+126), pw                ; 6D 29 7E
 ld (py+126), px                ; 6D 69 7E
 ld (py+126), py                ; 6D A9 7E
 ld (py+126), pz                ; 6D E9 7E
 ld (py+bc), hl                 ; ED 27
 ld (py+hl), a                  ; AC
 ld (py+hl), bc                 ; 6D 23
 ld (py+hl), bcde               ; DD 2D
 ld (py+hl), de                 ; 6D 63
 ld (py+hl), ix                 ; 6D A3
 ld (py+hl), iy                 ; 6D E3
 ld (py+hl), jkhl               ; FD 2D
 ld (py+hl), pw                 ; 6D 2B
 ld (py+hl), px                 ; 6D 6B
 ld (py+hl), py                 ; 6D AB
 ld (py+hl), pz                 ; 6D EB
 ld (py-128), a                 ; AE 80
 ld (py-128), bc                ; 6D 21 80
 ld (py-128), bcde              ; DD 2F 80
 ld (py-128), de                ; 6D 61 80
 ld (py-128), hl                ; A6 80
 ld (py-128), ix                ; 6D A1 80
 ld (py-128), iy                ; 6D E1 80
 ld (py-128), jkhl              ; FD 2F 80
 ld (py-128), pw                ; 6D 29 80
 ld (py-128), px                ; 6D 69 80
 ld (py-128), py                ; 6D A9 80
 ld (py-128), pz                ; 6D E9 80
 ld (pz), a                     ; BE 00
 ld (pz), bc                    ; 6D 31 00
 ld (pz), bcde                  ; DD 3F 00
 ld (pz), de                    ; 6D 71 00
 ld (pz), hl                    ; B6 00
 ld (pz), ix                    ; 6D B1 00
 ld (pz), iy                    ; 6D F1 00
 ld (pz), jkhl                  ; FD 3F 00
 ld (pz), pw                    ; 6D 39 00
 ld (pz), px                    ; 6D 79 00
 ld (pz), py                    ; 6D B9 00
 ld (pz), pz                    ; 6D F9 00
 ld (pz+0), a                   ; BE 00
 ld (pz+0), bc                  ; 6D 31 00
 ld (pz+0), bcde                ; DD 3F 00
 ld (pz+0), de                  ; 6D 71 00
 ld (pz+0), hl                  ; B6 00
 ld (pz+0), ix                  ; 6D B1 00
 ld (pz+0), iy                  ; 6D F1 00
 ld (pz+0), jkhl                ; FD 3F 00
 ld (pz+0), pw                  ; 6D 39 00
 ld (pz+0), px                  ; 6D 79 00
 ld (pz+0), py                  ; 6D B9 00
 ld (pz+0), pz                  ; 6D F9 00
 ld (pz+126), a                 ; BE 7E
 ld (pz+126), bc                ; 6D 31 7E
 ld (pz+126), bcde              ; DD 3F 7E
 ld (pz+126), de                ; 6D 71 7E
 ld (pz+126), hl                ; B6 7E
 ld (pz+126), ix                ; 6D B1 7E
 ld (pz+126), iy                ; 6D F1 7E
 ld (pz+126), jkhl              ; FD 3F 7E
 ld (pz+126), pw                ; 6D 39 7E
 ld (pz+126), px                ; 6D 79 7E
 ld (pz+126), py                ; 6D B9 7E
 ld (pz+126), pz                ; 6D F9 7E
 ld (pz+bc), hl                 ; ED 37
 ld (pz+hl), a                  ; BC
 ld (pz+hl), bc                 ; 6D 33
 ld (pz+hl), bcde               ; DD 3D
 ld (pz+hl), de                 ; 6D 73
 ld (pz+hl), ix                 ; 6D B3
 ld (pz+hl), iy                 ; 6D F3
 ld (pz+hl), jkhl               ; FD 3D
 ld (pz+hl), pw                 ; 6D 3B
 ld (pz+hl), px                 ; 6D 7B
 ld (pz+hl), py                 ; 6D BB
 ld (pz+hl), pz                 ; 6D FB
 ld (pz-128), a                 ; BE 80
 ld (pz-128), bc                ; 6D 31 80
 ld (pz-128), bcde              ; DD 3F 80
 ld (pz-128), de                ; 6D 71 80
 ld (pz-128), hl                ; B6 80
 ld (pz-128), ix                ; 6D B1 80
 ld (pz-128), iy                ; 6D F1 80
 ld (pz-128), jkhl              ; FD 3F 80
 ld (pz-128), pw                ; 6D 39 80
 ld (pz-128), px                ; 6D 79 80
 ld (pz-128), py                ; 6D B9 80
 ld (pz-128), pz                ; 6D F9 80
 ld (sp), bcde                  ; DD EF 00
 ld (sp), hl                    ; D4 00
 ld (sp), ix                    ; DD D4 00
 ld (sp), iy                    ; FD D4 00
 ld (sp), jkhl                  ; FD EF 00
 ld (sp), pw                    ; ED 05 00
 ld (sp), px                    ; ED 15 00
 ld (sp), py                    ; ED 25 00
 ld (sp), pz                    ; ED 35 00
 ld (sp+0), bcde                ; DD EF 00
 ld (sp+0), hl                  ; D4 00
 ld (sp+0), ix                  ; DD D4 00
 ld (sp+0), iy                  ; FD D4 00
 ld (sp+0), jkhl                ; FD EF 00
 ld (sp+0), pw                  ; ED 05 00
 ld (sp+0), px                  ; ED 15 00
 ld (sp+0), py                  ; ED 25 00
 ld (sp+0), pz                  ; ED 35 00
 ld (sp+127), bcde              ; DD EF 7F
 ld (sp+127), hl                ; D4 7F
 ld (sp+127), ix                ; DD D4 7F
 ld (sp+127), iy                ; FD D4 7F
 ld (sp+127), jkhl              ; FD EF 7F
 ld (sp+127), pw                ; ED 05 7F
 ld (sp+127), px                ; ED 15 7F
 ld (sp+127), py                ; ED 25 7F
 ld (sp+127), pz                ; ED 35 7F
 ld (sp+255), bcde              ; DD EF FF
 ld (sp+255), hl                ; D4 FF
 ld (sp+255), ix                ; DD D4 FF
 ld (sp+255), iy                ; FD D4 FF
 ld (sp+255), jkhl              ; FD EF FF
 ld (sp+255), pw                ; ED 05 FF
 ld (sp+255), px                ; ED 15 FF
 ld (sp+255), py                ; ED 25 FF
 ld (sp+255), pz                ; ED 35 FF
 ld (sp+hl), bcde               ; DD FF
 ld (sp+hl), jkhl               ; FD FF
 ld a', (0x1234)                ; 76 3A 34 12
 ld a', (bc)                    ; 76 0A
 ld a', (de)                    ; 76 1A
 ld a', (hl)                    ; 76 7E
 ld a', (ix)                    ; 76 DD 7E 00
 ld a', (ix+0)                  ; 76 DD 7E 00
 ld a', (ix+126)                ; 76 DD 7E 7E
 ld a', (ix+a)                  ; 76 DD 06
 ld a', (ix-128)                ; 76 DD 7E 80
 ld a', (iy)                    ; 76 FD 7E 00
 ld a', (iy+0)                  ; 76 FD 7E 00
 ld a', (iy+126)                ; 76 FD 7E 7E
 ld a', (iy+a)                  ; 76 FD 06
 ld a', (iy-128)                ; 76 FD 7E 80
 ld a', (pw)                    ; 76 8D 00
 ld a', (pw+0)                  ; 76 8D 00
 ld a', (pw+126)                ; 76 8D 7E
 ld a', (pw+hl)                 ; 76 8B
 ld a', (pw-128)                ; 76 8D 80
 ld a', (px)                    ; 76 9D 00
 ld a', (px+0)                  ; 76 9D 00
 ld a', (px+126)                ; 76 9D 7E
 ld a', (px+hl)                 ; 76 9B
 ld a', (px-128)                ; 76 9D 80
 ld a', (py)                    ; 76 AD 00
 ld a', (py+0)                  ; 76 AD 00
 ld a', (py+126)                ; 76 AD 7E
 ld a', (py+hl)                 ; 76 AB
 ld a', (py-128)                ; 76 AD 80
 ld a', (pz)                    ; 76 BD 00
 ld a', (pz+0)                  ; 76 BD 00
 ld a', (pz+126)                ; 76 BD 7E
 ld a', (pz+hl)                 ; 76 BB
 ld a', (pz-128)                ; 76 BD 80
 ld a', 0                       ; 76 3E 00
 ld a', 127                     ; 76 3E 7F
 ld a', 255                     ; 76 3E FF
 ld a', a                       ; 76 7F 7F
 ld a', b                       ; 76 7F 78
 ld a', c                       ; 76 7F 79
 ld a', d                       ; 76 7F 7A
 ld a', e                       ; 76 7F 7B
 ld a', eir                     ; 76 ED 57
 ld a', h                       ; 76 7F 7C
 ld a', htr                     ; 76 ED 50
 ld a', iir                     ; 76 ED 5F
 ld a', l                       ; 76 7F 7D
 ld a', xpc                     ; 76 ED 77
 ld a, (0x1234)                 ; 3A 34 12
 ld a, (bc)                     ; 0A
 ld a, (de)                     ; 1A
 ld a, (hl)                     ; 7E
 ld a, (ix)                     ; DD 7E 00
 ld a, (ix+0)                   ; DD 7E 00
 ld a, (ix+126)                 ; DD 7E 7E
 ld a, (ix+a)                   ; DD 06
 ld a, (ix-128)                 ; DD 7E 80
 ld a, (iy)                     ; FD 7E 00
 ld a, (iy+0)                   ; FD 7E 00
 ld a, (iy+126)                 ; FD 7E 7E
 ld a, (iy+a)                   ; FD 06
 ld a, (iy-128)                 ; FD 7E 80
 ld a, (pw)                     ; 8D 00
 ld a, (pw+0)                   ; 8D 00
 ld a, (pw+126)                 ; 8D 7E
 ld a, (pw+hl)                  ; 8B
 ld a, (pw-128)                 ; 8D 80
 ld a, (px)                     ; 9D 00
 ld a, (px+0)                   ; 9D 00
 ld a, (px+126)                 ; 9D 7E
 ld a, (px+hl)                  ; 9B
 ld a, (px-128)                 ; 9D 80
 ld a, (py)                     ; AD 00
 ld a, (py+0)                   ; AD 00
 ld a, (py+126)                 ; AD 7E
 ld a, (py+hl)                  ; AB
 ld a, (py-128)                 ; AD 80
 ld a, (pz)                     ; BD 00
 ld a, (pz+0)                   ; BD 00
 ld a, (pz+126)                 ; BD 7E
 ld a, (pz+hl)                  ; BB
 ld a, (pz-128)                 ; BD 80
 ld a, 0                        ; 3E 00
 ld a, 127                      ; 3E 7F
 ld a, 255                      ; 3E FF
 ld a, a                        ; 7F 7F
 ld a, b                        ; 7F 78
 ld a, c                        ; 7F 79
 ld a, d                        ; 7F 7A
 ld a, e                        ; 7F 7B
 ld a, eir                      ; ED 57
 ld a, h                        ; 7F 7C
 ld a, htr                      ; ED 50
 ld a, iir                      ; ED 5F
 ld a, l                        ; 7F 7D
 ld a, xpc                      ; ED 77
 ld b', (hl)                    ; 76 46
 ld b', (ix)                    ; 76 DD 46 00
 ld b', (ix+0)                  ; 76 DD 46 00
 ld b', (ix+126)                ; 76 DD 46 7E
 ld b', (ix-128)                ; 76 DD 46 80
 ld b', (iy)                    ; 76 FD 46 00
 ld b', (iy+0)                  ; 76 FD 46 00
 ld b', (iy+126)                ; 76 FD 46 7E
 ld b', (iy-128)                ; 76 FD 46 80
 ld b', 0                       ; 76 06 00
 ld b', 127                     ; 76 06 7F
 ld b', 255                     ; 76 06 FF
 ld b', a                       ; 76 7F 47
 ld b', b                       ; 76 7F 40
 ld b', c                       ; 76 7F 41
 ld b', d                       ; 76 7F 42
 ld b', e                       ; 76 7F 43
 ld b', h                       ; 76 7F 44
 ld b', l                       ; 76 7F 45
 ld b, (hl)                     ; 46
 ld b, (ix)                     ; DD 46 00
 ld b, (ix+0)                   ; DD 46 00
 ld b, (ix+126)                 ; DD 46 7E
 ld b, (ix-128)                 ; DD 46 80
 ld b, (iy)                     ; FD 46 00
 ld b, (iy+0)                   ; FD 46 00
 ld b, (iy+126)                 ; FD 46 7E
 ld b, (iy-128)                 ; FD 46 80
 ld b, 0                        ; 06 00
 ld b, 127                      ; 06 7F
 ld b, 255                      ; 06 FF
 ld b, a                        ; 7F 47
 ld b, b                        ; 7F 40
 ld b, c                        ; 7F 41
 ld b, d                        ; 7F 42
 ld b, e                        ; 7F 43
 ld b, h                        ; 7F 44
 ld b, l                        ; 7F 45
 ld bc', (0x1234)               ; 76 ED 4B 34 12
 ld bc', (pw)                   ; 76 6D 00 00
 ld bc', (pw+0)                 ; 76 6D 00 00
 ld bc', (pw+126)               ; 76 6D 00 7E
 ld bc', (pw+hl)                ; 76 6D 02
 ld bc', (pw-128)               ; 76 6D 00 80
 ld bc', (px)                   ; 76 6D 10 00
 ld bc', (px+0)                 ; 76 6D 10 00
 ld bc', (px+126)               ; 76 6D 10 7E
 ld bc', (px+hl)                ; 76 6D 12
 ld bc', (px-128)               ; 76 6D 10 80
 ld bc', (py)                   ; 76 6D 20 00
 ld bc', (py+0)                 ; 76 6D 20 00
 ld bc', (py+126)               ; 76 6D 20 7E
 ld bc', (py+hl)                ; 76 6D 22
 ld bc', (py-128)               ; 76 6D 20 80
 ld bc', (pz)                   ; 76 6D 30 00
 ld bc', (pz+0)                 ; 76 6D 30 00
 ld bc', (pz+126)               ; 76 6D 30 7E
 ld bc', (pz+hl)                ; 76 6D 32
 ld bc', (pz-128)               ; 76 6D 30 80
 ld bc', 0x1234                 ; 76 01 34 12
 ld bc', bc                     ; ED 49
 ld bc', de                     ; ED 41
 ld bc', hl                     ; 76 91
 ld bc, (0x1234)                ; ED 4B 34 12
 ld bc, (pw)                    ; 6D 00 00
 ld bc, (pw+0)                  ; 6D 00 00
 ld bc, (pw+126)                ; 6D 00 7E
 ld bc, (pw+hl)                 ; 6D 02
 ld bc, (pw-128)                ; 6D 00 80
 ld bc, (px)                    ; 6D 10 00
 ld bc, (px+0)                  ; 6D 10 00
 ld bc, (px+126)                ; 6D 10 7E
 ld bc, (px+hl)                 ; 6D 12
 ld bc, (px-128)                ; 6D 10 80
 ld bc, (py)                    ; 6D 20 00
 ld bc, (py+0)                  ; 6D 20 00
 ld bc, (py+126)                ; 6D 20 7E
 ld bc, (py+hl)                 ; 6D 22
 ld bc, (py-128)                ; 6D 20 80
 ld bc, (pz)                    ; 6D 30 00
 ld bc, (pz+0)                  ; 6D 30 00
 ld bc, (pz+126)                ; 6D 30 7E
 ld bc, (pz+hl)                 ; 6D 32
 ld bc, (pz-128)                ; 6D 30 80
 ld bc, 0x1234                  ; 01 34 12
 ld bc, hl                      ; 91
 ld bcde', (0x1234)             ; 76 93 34 12
 ld bcde', (hl)                 ; 76 DD 1A
 ld bcde', (ix)                 ; 76 DD CE 00
 ld bcde', (ix+0)               ; 76 DD CE 00
 ld bcde', (ix+126)             ; 76 DD CE 7E
 ld bcde', (ix-128)             ; 76 DD CE 80
 ld bcde', (iy)                 ; 76 DD DE 00
 ld bcde', (iy+0)               ; 76 DD DE 00
 ld bcde', (iy+126)             ; 76 DD DE 7E
 ld bcde', (iy-128)             ; 76 DD DE 80
 ld bcde', (pw)                 ; 76 DD 0E 00
 ld bcde', (pw+0)               ; 76 DD 0E 00
 ld bcde', (pw+126)             ; 76 DD 0E 7E
 ld bcde', (pw+hl)              ; 76 DD 0C
 ld bcde', (pw-128)             ; 76 DD 0E 80
 ld bcde', (px)                 ; 76 DD 1E 00
 ld bcde', (px+0)               ; 76 DD 1E 00
 ld bcde', (px+126)             ; 76 DD 1E 7E
 ld bcde', (px+hl)              ; 76 DD 1C
 ld bcde', (px-128)             ; 76 DD 1E 80
 ld bcde', (py)                 ; 76 DD 2E 00
 ld bcde', (py+0)               ; 76 DD 2E 00
 ld bcde', (py+126)             ; 76 DD 2E 7E
 ld bcde', (py+hl)              ; 76 DD 2C
 ld bcde', (py-128)             ; 76 DD 2E 80
 ld bcde', (pz)                 ; 76 DD 3E 00
 ld bcde', (pz+0)               ; 76 DD 3E 00
 ld bcde', (pz+126)             ; 76 DD 3E 7E
 ld bcde', (pz+hl)              ; 76 DD 3C
 ld bcde', (pz-128)             ; 76 DD 3E 80
 ld bcde', (sp)                 ; 76 DD EE 00
 ld bcde', (sp+0)               ; 76 DD EE 00
 ld bcde', (sp+127)             ; 76 DD EE 7F
 ld bcde', (sp+255)             ; 76 DD EE FF
 ld bcde', (sp+hl)              ; 76 DD FE
 ld bcde', -128                 ; 76 A3 80
 ld bcde', 0                    ; 76 A3 00
 ld bcde', 126                  ; 76 A3 7E
 ld bcde', pw                   ; 76 DD CD
 ld bcde', px                   ; 76 DD DD
 ld bcde', py                   ; 76 DD ED
 ld bcde', pz                   ; 76 DD FD
 ld bcde, (0x1234)              ; 93 34 12
 ld bcde, (hl)                  ; DD 1A
 ld bcde, (ix)                  ; DD CE 00
 ld bcde, (ix+0)                ; DD CE 00
 ld bcde, (ix+126)              ; DD CE 7E
 ld bcde, (ix-128)              ; DD CE 80
 ld bcde, (iy)                  ; DD DE 00
 ld bcde, (iy+0)                ; DD DE 00
 ld bcde, (iy+126)              ; DD DE 7E
 ld bcde, (iy-128)              ; DD DE 80
 ld bcde, (pw)                  ; DD 0E 00
 ld bcde, (pw+0)                ; DD 0E 00
 ld bcde, (pw+126)              ; DD 0E 7E
 ld bcde, (pw+hl)               ; DD 0C
 ld bcde, (pw-128)              ; DD 0E 80
 ld bcde, (px)                  ; DD 1E 00
 ld bcde, (px+0)                ; DD 1E 00
 ld bcde, (px+126)              ; DD 1E 7E
 ld bcde, (px+hl)               ; DD 1C
 ld bcde, (px-128)              ; DD 1E 80
 ld bcde, (py)                  ; DD 2E 00
 ld bcde, (py+0)                ; DD 2E 00
 ld bcde, (py+126)              ; DD 2E 7E
 ld bcde, (py+hl)               ; DD 2C
 ld bcde, (py-128)              ; DD 2E 80
 ld bcde, (pz)                  ; DD 3E 00
 ld bcde, (pz+0)                ; DD 3E 00
 ld bcde, (pz+126)              ; DD 3E 7E
 ld bcde, (pz+hl)               ; DD 3C
 ld bcde, (pz-128)              ; DD 3E 80
 ld bcde, (sp)                  ; DD EE 00
 ld bcde, (sp+0)                ; DD EE 00
 ld bcde, (sp+127)              ; DD EE 7F
 ld bcde, (sp+255)              ; DD EE FF
 ld bcde, (sp+hl)               ; DD FE
 ld bcde, -128                  ; A3 80
 ld bcde, 0                     ; A3 00
 ld bcde, 126                   ; A3 7E
 ld bcde, pw                    ; DD CD
 ld bcde, px                    ; DD DD
 ld bcde, py                    ; DD ED
 ld bcde, pz                    ; DD FD
 ld c', (hl)                    ; 76 4E
 ld c', (ix)                    ; 76 DD 4E 00
 ld c', (ix+0)                  ; 76 DD 4E 00
 ld c', (ix+126)                ; 76 DD 4E 7E
 ld c', (ix-128)                ; 76 DD 4E 80
 ld c', (iy)                    ; 76 FD 4E 00
 ld c', (iy+0)                  ; 76 FD 4E 00
 ld c', (iy+126)                ; 76 FD 4E 7E
 ld c', (iy-128)                ; 76 FD 4E 80
 ld c', 0                       ; 76 0E 00
 ld c', 127                     ; 76 0E 7F
 ld c', 255                     ; 76 0E FF
 ld c', a                       ; 76 7F 4F
 ld c', b                       ; 76 7F 48
 ld c', c                       ; 76 7F 49
 ld c', d                       ; 76 7F 4A
 ld c', e                       ; 76 7F 4B
 ld c', h                       ; 76 7F 4C
 ld c', l                       ; 76 7F 4D
 ld c, (hl)                     ; 4E
 ld c, (ix)                     ; DD 4E 00
 ld c, (ix+0)                   ; DD 4E 00
 ld c, (ix+126)                 ; DD 4E 7E
 ld c, (ix-128)                 ; DD 4E 80
 ld c, (iy)                     ; FD 4E 00
 ld c, (iy+0)                   ; FD 4E 00
 ld c, (iy+126)                 ; FD 4E 7E
 ld c, (iy-128)                 ; FD 4E 80
 ld c, 0                        ; 0E 00
 ld c, 127                      ; 0E 7F
 ld c, 255                      ; 0E FF
 ld c, a                        ; 7F 4F
 ld c, b                        ; 7F 48
 ld c, c                        ; 7F 49
 ld c, d                        ; 7F 4A
 ld c, e                        ; 7F 4B
 ld c, h                        ; 7F 4C
 ld c, l                        ; 7F 4D
 ld d', (hl)                    ; 76 56
 ld d', (ix)                    ; 76 DD 56 00
 ld d', (ix+0)                  ; 76 DD 56 00
 ld d', (ix+126)                ; 76 DD 56 7E
 ld d', (ix-128)                ; 76 DD 56 80
 ld d', (iy)                    ; 76 FD 56 00
 ld d', (iy+0)                  ; 76 FD 56 00
 ld d', (iy+126)                ; 76 FD 56 7E
 ld d', (iy-128)                ; 76 FD 56 80
 ld d', 0                       ; 76 16 00
 ld d', 127                     ; 76 16 7F
 ld d', 255                     ; 76 16 FF
 ld d', a                       ; 76 7F 57
 ld d', b                       ; 76 7F 50
 ld d', c                       ; 76 7F 51
 ld d', d                       ; 76 7F 52
 ld d', e                       ; 76 7F 53
 ld d', h                       ; 76 7F 54
 ld d', l                       ; 76 7F 55
 ld d, (hl)                     ; 56
 ld d, (ix)                     ; DD 56 00
 ld d, (ix+0)                   ; DD 56 00
 ld d, (ix+126)                 ; DD 56 7E
 ld d, (ix-128)                 ; DD 56 80
 ld d, (iy)                     ; FD 56 00
 ld d, (iy+0)                   ; FD 56 00
 ld d, (iy+126)                 ; FD 56 7E
 ld d, (iy-128)                 ; FD 56 80
 ld d, 0                        ; 16 00
 ld d, 127                      ; 16 7F
 ld d, 255                      ; 16 FF
 ld d, a                        ; 7F 57
 ld d, b                        ; 7F 50
 ld d, c                        ; 7F 51
 ld d, d                        ; 7F 52
 ld d, e                        ; 7F 53
 ld d, h                        ; 7F 54
 ld d, l                        ; 7F 55
 ld de', (0x1234)               ; 76 ED 5B 34 12
 ld de', (pw)                   ; 76 6D 40 00
 ld de', (pw+0)                 ; 76 6D 40 00
 ld de', (pw+126)               ; 76 6D 40 7E
 ld de', (pw+hl)                ; 76 6D 42
 ld de', (pw-128)               ; 76 6D 40 80
 ld de', (px)                   ; 76 6D 50 00
 ld de', (px+0)                 ; 76 6D 50 00
 ld de', (px+126)               ; 76 6D 50 7E
 ld de', (px+hl)                ; 76 6D 52
 ld de', (px-128)               ; 76 6D 50 80
 ld de', (py)                   ; 76 6D 60 00
 ld de', (py+0)                 ; 76 6D 60 00
 ld de', (py+126)               ; 76 6D 60 7E
 ld de', (py+hl)                ; 76 6D 62
 ld de', (py-128)               ; 76 6D 60 80
 ld de', (pz)                   ; 76 6D 70 00
 ld de', (pz+0)                 ; 76 6D 70 00
 ld de', (pz+126)               ; 76 6D 70 7E
 ld de', (pz+hl)                ; 76 6D 72
 ld de', (pz-128)               ; 76 6D 70 80
 ld de', 0x1234                 ; 76 11 34 12
 ld de', bc                     ; ED 59
 ld de', de                     ; ED 51
 ld de', hl                     ; 76 B1
 ld de, (0x1234)                ; ED 5B 34 12
 ld de, (pw)                    ; 6D 40 00
 ld de, (pw+0)                  ; 6D 40 00
 ld de, (pw+126)                ; 6D 40 7E
 ld de, (pw+hl)                 ; 6D 42
 ld de, (pw-128)                ; 6D 40 80
 ld de, (px)                    ; 6D 50 00
 ld de, (px+0)                  ; 6D 50 00
 ld de, (px+126)                ; 6D 50 7E
 ld de, (px+hl)                 ; 6D 52
 ld de, (px-128)                ; 6D 50 80
 ld de, (py)                    ; 6D 60 00
 ld de, (py+0)                  ; 6D 60 00
 ld de, (py+126)                ; 6D 60 7E
 ld de, (py+hl)                 ; 6D 62
 ld de, (py-128)                ; 6D 60 80
 ld de, (pz)                    ; 6D 70 00
 ld de, (pz+0)                  ; 6D 70 00
 ld de, (pz+126)                ; 6D 70 7E
 ld de, (pz+hl)                 ; 6D 72
 ld de, (pz-128)                ; 6D 70 80
 ld de, 0x1234                  ; 11 34 12
 ld de, hl                      ; B1
 ld e', (hl)                    ; 76 5E
 ld e', (ix)                    ; 76 DD 5E 00
 ld e', (ix+0)                  ; 76 DD 5E 00
 ld e', (ix+126)                ; 76 DD 5E 7E
 ld e', (ix-128)                ; 76 DD 5E 80
 ld e', (iy)                    ; 76 FD 5E 00
 ld e', (iy+0)                  ; 76 FD 5E 00
 ld e', (iy+126)                ; 76 FD 5E 7E
 ld e', (iy-128)                ; 76 FD 5E 80
 ld e', 0                       ; 76 1E 00
 ld e', 127                     ; 76 1E 7F
 ld e', 255                     ; 76 1E FF
 ld e', a                       ; 76 7F 5F
 ld e', b                       ; 76 7F 58
 ld e', c                       ; 76 7F 59
 ld e', d                       ; 76 7F 5A
 ld e', e                       ; 76 7F 5B
 ld e', h                       ; 76 7F 5C
 ld e', l                       ; 76 7F 5D
 ld e, (hl)                     ; 5E
 ld e, (ix)                     ; DD 5E 00
 ld e, (ix+0)                   ; DD 5E 00
 ld e, (ix+126)                 ; DD 5E 7E
 ld e, (ix-128)                 ; DD 5E 80
 ld e, (iy)                     ; FD 5E 00
 ld e, (iy+0)                   ; FD 5E 00
 ld e, (iy+126)                 ; FD 5E 7E
 ld e, (iy-128)                 ; FD 5E 80
 ld e, 0                        ; 1E 00
 ld e, 127                      ; 1E 7F
 ld e, 255                      ; 1E FF
 ld e, a                        ; 7F 5F
 ld e, b                        ; 7F 58
 ld e, c                        ; 7F 59
 ld e, d                        ; 7F 5A
 ld e, e                        ; 7F 5B
 ld e, h                        ; 7F 5C
 ld e, l                        ; 7F 5D
 ld eir, a                      ; ED 47
 ld h', (hl)                    ; 76 66
 ld h', (ix)                    ; 76 DD 66 00
 ld h', (ix+0)                  ; 76 DD 66 00
 ld h', (ix+126)                ; 76 DD 66 7E
 ld h', (ix-128)                ; 76 DD 66 80
 ld h', (iy)                    ; 76 FD 66 00
 ld h', (iy+0)                  ; 76 FD 66 00
 ld h', (iy+126)                ; 76 FD 66 7E
 ld h', (iy-128)                ; 76 FD 66 80
 ld h', 0                       ; 76 26 00
 ld h', 127                     ; 76 26 7F
 ld h', 255                     ; 76 26 FF
 ld h', a                       ; 76 7F 67
 ld h', b                       ; 76 7F 60
 ld h', c                       ; 76 7F 61
 ld h', d                       ; 76 7F 62
 ld h', e                       ; 76 7F 63
 ld h', h                       ; 76 7F 64
 ld h', l                       ; 76 7F 65
 ld h, (hl)                     ; 66
 ld h, (ix)                     ; DD 66 00
 ld h, (ix+0)                   ; DD 66 00
 ld h, (ix+126)                 ; DD 66 7E
 ld h, (ix-128)                 ; DD 66 80
 ld h, (iy)                     ; FD 66 00
 ld h, (iy+0)                   ; FD 66 00
 ld h, (iy+126)                 ; FD 66 7E
 ld h, (iy-128)                 ; FD 66 80
 ld h, 0                        ; 26 00
 ld h, 127                      ; 26 7F
 ld h, 255                      ; 26 FF
 ld h, a                        ; 7F 67
 ld h, b                        ; 7F 60
 ld h, c                        ; 7F 61
 ld h, d                        ; 7F 62
 ld h, e                        ; 7F 63
 ld h, h                        ; 7F 64
 ld h, l                        ; 7F 65
 ld hl', (0x1234)               ; 76 2A 34 12
 ld hl', (hl)                   ; 76 DD E4 00
 ld hl', (hl+0)                 ; 76 DD E4 00
 ld hl', (hl+126)               ; 76 DD E4 7E
 ld hl', (hl-128)               ; 76 DD E4 80
 ld hl', (ix)                   ; 76 E4 00
 ld hl', (ix+0)                 ; 76 E4 00
 ld hl', (ix+126)               ; 76 E4 7E
 ld hl', (ix-128)               ; 76 E4 80
 ld hl', (iy)                   ; 76 FD E4 00
 ld hl', (iy+0)                 ; 76 FD E4 00
 ld hl', (iy+126)               ; 76 FD E4 7E
 ld hl', (iy-128)               ; 76 FD E4 80
 ld hl', (pw)                   ; 76 85 00
 ld hl', (pw+0)                 ; 76 85 00
 ld hl', (pw+126)               ; 76 85 7E
 ld hl', (pw+bc)                ; 76 ED 06
 ld hl', (pw-128)               ; 76 85 80
 ld hl', (px)                   ; 76 95 00
 ld hl', (px+0)                 ; 76 95 00
 ld hl', (px+126)               ; 76 95 7E
 ld hl', (px+bc)                ; 76 ED 16
 ld hl', (px-128)               ; 76 95 80
 ld hl', (py)                   ; 76 A5 00
 ld hl', (py+0)                 ; 76 A5 00
 ld hl', (py+126)               ; 76 A5 7E
 ld hl', (py+bc)                ; 76 ED 26
 ld hl', (py-128)               ; 76 A5 80
 ld hl', (pz)                   ; 76 B5 00
 ld hl', (pz+0)                 ; 76 B5 00
 ld hl', (pz+126)               ; 76 B5 7E
 ld hl', (pz+bc)                ; 76 ED 36
 ld hl', (pz-128)               ; 76 B5 80
 ld hl', (sp)                   ; 76 C4 00
 ld hl', (sp+0)                 ; 76 C4 00
 ld hl', (sp+127)               ; 76 C4 7F
 ld hl', (sp+255)               ; 76 C4 FF
 ld hl', (sp+hl)                ; 76 ED FE
 ld hl', 0x1234                 ; 76 21 34 12
 ld hl', bc                     ; 76 81
 ld hl', de                     ; 76 A1
 ld hl', ix                     ; 76 DD 7C
 ld hl', iy                     ; 76 FD 7C
 ld hl', lxpc                   ; 76 9F
 ld hl, (0x1234)                ; 2A 34 12
 ld hl, (hl)                    ; DD E4 00
 ld hl, (hl+0)                  ; DD E4 00
 ld hl, (hl+126)                ; DD E4 7E
 ld hl, (hl-128)                ; DD E4 80
 ld hl, (ix)                    ; E4 00
 ld hl, (ix+0)                  ; E4 00
 ld hl, (ix+126)                ; E4 7E
 ld hl, (ix-128)                ; E4 80
 ld hl, (iy)                    ; FD E4 00
 ld hl, (iy+0)                  ; FD E4 00
 ld hl, (iy+126)                ; FD E4 7E
 ld hl, (iy-128)                ; FD E4 80
 ld hl, (pw)                    ; 85 00
 ld hl, (pw+0)                  ; 85 00
 ld hl, (pw+126)                ; 85 7E
 ld hl, (pw+bc)                 ; ED 06
 ld hl, (pw-128)                ; 85 80
 ld hl, (px)                    ; 95 00
 ld hl, (px+0)                  ; 95 00
 ld hl, (px+126)                ; 95 7E
 ld hl, (px+bc)                 ; ED 16
 ld hl, (px-128)                ; 95 80
 ld hl, (py)                    ; A5 00
 ld hl, (py+0)                  ; A5 00
 ld hl, (py+126)                ; A5 7E
 ld hl, (py+bc)                 ; ED 26
 ld hl, (py-128)                ; A5 80
 ld hl, (pz)                    ; B5 00
 ld hl, (pz+0)                  ; B5 00
 ld hl, (pz+126)                ; B5 7E
 ld hl, (pz+bc)                 ; ED 36
 ld hl, (pz-128)                ; B5 80
 ld hl, (sp)                    ; C4 00
 ld hl, (sp+0)                  ; C4 00
 ld hl, (sp+127)                ; C4 7F
 ld hl, (sp+255)                ; C4 FF
 ld hl, (sp+hl)                 ; ED FE
 ld hl, 0x1234                  ; 21 34 12
 ld hl, bc                      ; 81
 ld hl, de                      ; A1
 ld hl, ix                      ; DD 7C
 ld hl, iy                      ; FD 7C
 ld hl, lxpc                    ; 9F
 ld htr, a                      ; ED 40
 ld iir, a                      ; ED 4F
 ld ix, (0x1234)                ; DD 2A 34 12
 ld ix, (pw)                    ; 6D 80 00
 ld ix, (pw+0)                  ; 6D 80 00
 ld ix, (pw+126)                ; 6D 80 7E
 ld ix, (pw+hl)                 ; 6D 82
 ld ix, (pw-128)                ; 6D 80 80
 ld ix, (px)                    ; 6D 90 00
 ld ix, (px+0)                  ; 6D 90 00
 ld ix, (px+126)                ; 6D 90 7E
 ld ix, (px+hl)                 ; 6D 92
 ld ix, (px-128)                ; 6D 90 80
 ld ix, (py)                    ; 6D A0 00
 ld ix, (py+0)                  ; 6D A0 00
 ld ix, (py+126)                ; 6D A0 7E
 ld ix, (py+hl)                 ; 6D A2
 ld ix, (py-128)                ; 6D A0 80
 ld ix, (pz)                    ; 6D B0 00
 ld ix, (pz+0)                  ; 6D B0 00
 ld ix, (pz+126)                ; 6D B0 7E
 ld ix, (pz+hl)                 ; 6D B2
 ld ix, (pz-128)                ; 6D B0 80
 ld ix, (sp)                    ; DD C4 00
 ld ix, (sp+0)                  ; DD C4 00
 ld ix, (sp+127)                ; DD C4 7F
 ld ix, (sp+255)                ; DD C4 FF
 ld ix, 0x1234                  ; DD 21 34 12
 ld ix, hl                      ; DD 7D
 ld iy, (0x1234)                ; FD 2A 34 12
 ld iy, (pw)                    ; 6D C0 00
 ld iy, (pw+0)                  ; 6D C0 00
 ld iy, (pw+126)                ; 6D C0 7E
 ld iy, (pw+hl)                 ; 6D C2
 ld iy, (pw-128)                ; 6D C0 80
 ld iy, (px)                    ; 6D D0 00
 ld iy, (px+0)                  ; 6D D0 00
 ld iy, (px+126)                ; 6D D0 7E
 ld iy, (px+hl)                 ; 6D D2
 ld iy, (px-128)                ; 6D D0 80
 ld iy, (py)                    ; 6D E0 00
 ld iy, (py+0)                  ; 6D E0 00
 ld iy, (py+126)                ; 6D E0 7E
 ld iy, (py+hl)                 ; 6D E2
 ld iy, (py-128)                ; 6D E0 80
 ld iy, (pz)                    ; 6D F0 00
 ld iy, (pz+0)                  ; 6D F0 00
 ld iy, (pz+126)                ; 6D F0 7E
 ld iy, (pz+hl)                 ; 6D F2
 ld iy, (pz-128)                ; 6D F0 80
 ld iy, (sp)                    ; FD C4 00
 ld iy, (sp+0)                  ; FD C4 00
 ld iy, (sp+127)                ; FD C4 7F
 ld iy, (sp+255)                ; FD C4 FF
 ld iy, 0x1234                  ; FD 21 34 12
 ld iy, hl                      ; FD 7D
 ld jk', (0x1234)               ; 76 99 34 12
 ld jk', 0x1234                 ; 76 A9 34 12
 ld jk, (0x1234)                ; 99 34 12
 ld jk, 0x1234                  ; A9 34 12
 ld jkhl', (0x1234)             ; 76 94 34 12
 ld jkhl', (hl)                 ; 76 FD 1A
 ld jkhl', (ix)                 ; 76 FD CE 00
 ld jkhl', (ix+0)               ; 76 FD CE 00
 ld jkhl', (ix+126)             ; 76 FD CE 7E
 ld jkhl', (ix-128)             ; 76 FD CE 80
 ld jkhl', (iy)                 ; 76 FD DE 00
 ld jkhl', (iy+0)               ; 76 FD DE 00
 ld jkhl', (iy+126)             ; 76 FD DE 7E
 ld jkhl', (iy-128)             ; 76 FD DE 80
 ld jkhl', (pw)                 ; 76 FD 0E 00
 ld jkhl', (pw+0)               ; 76 FD 0E 00
 ld jkhl', (pw+126)             ; 76 FD 0E 7E
 ld jkhl', (pw+hl)              ; 76 FD 0C
 ld jkhl', (pw-128)             ; 76 FD 0E 80
 ld jkhl', (px)                 ; 76 FD 1E 00
 ld jkhl', (px+0)               ; 76 FD 1E 00
 ld jkhl', (px+126)             ; 76 FD 1E 7E
 ld jkhl', (px+hl)              ; 76 FD 1C
 ld jkhl', (px-128)             ; 76 FD 1E 80
 ld jkhl', (py)                 ; 76 FD 2E 00
 ld jkhl', (py+0)               ; 76 FD 2E 00
 ld jkhl', (py+126)             ; 76 FD 2E 7E
 ld jkhl', (py+hl)              ; 76 FD 2C
 ld jkhl', (py-128)             ; 76 FD 2E 80
 ld jkhl', (pz)                 ; 76 FD 3E 00
 ld jkhl', (pz+0)               ; 76 FD 3E 00
 ld jkhl', (pz+126)             ; 76 FD 3E 7E
 ld jkhl', (pz+hl)              ; 76 FD 3C
 ld jkhl', (pz-128)             ; 76 FD 3E 80
 ld jkhl', (sp)                 ; 76 FD EE 00
 ld jkhl', (sp+0)               ; 76 FD EE 00
 ld jkhl', (sp+127)             ; 76 FD EE 7F
 ld jkhl', (sp+255)             ; 76 FD EE FF
 ld jkhl', (sp+hl)              ; 76 FD FE
 ld jkhl', -128                 ; 76 A4 80
 ld jkhl', 0                    ; 76 A4 00
 ld jkhl', 126                  ; 76 A4 7E
 ld jkhl', pw                   ; 76 FD CD
 ld jkhl', px                   ; 76 FD DD
 ld jkhl', py                   ; 76 FD ED
 ld jkhl', pz                   ; 76 FD FD
 ld jkhl, (0x1234)              ; 94 34 12
 ld jkhl, (hl)                  ; FD 1A
 ld jkhl, (ix)                  ; FD CE 00
 ld jkhl, (ix+0)                ; FD CE 00
 ld jkhl, (ix+126)              ; FD CE 7E
 ld jkhl, (ix-128)              ; FD CE 80
 ld jkhl, (iy)                  ; FD DE 00
 ld jkhl, (iy+0)                ; FD DE 00
 ld jkhl, (iy+126)              ; FD DE 7E
 ld jkhl, (iy-128)              ; FD DE 80
 ld jkhl, (pw)                  ; FD 0E 00
 ld jkhl, (pw+0)                ; FD 0E 00
 ld jkhl, (pw+126)              ; FD 0E 7E
 ld jkhl, (pw+hl)               ; FD 0C
 ld jkhl, (pw-128)              ; FD 0E 80
 ld jkhl, (px)                  ; FD 1E 00
 ld jkhl, (px+0)                ; FD 1E 00
 ld jkhl, (px+126)              ; FD 1E 7E
 ld jkhl, (px+hl)               ; FD 1C
 ld jkhl, (px-128)              ; FD 1E 80
 ld jkhl, (py)                  ; FD 2E 00
 ld jkhl, (py+0)                ; FD 2E 00
 ld jkhl, (py+126)              ; FD 2E 7E
 ld jkhl, (py+hl)               ; FD 2C
 ld jkhl, (py-128)              ; FD 2E 80
 ld jkhl, (pz)                  ; FD 3E 00
 ld jkhl, (pz+0)                ; FD 3E 00
 ld jkhl, (pz+126)              ; FD 3E 7E
 ld jkhl, (pz+hl)               ; FD 3C
 ld jkhl, (pz-128)              ; FD 3E 80
 ld jkhl, (sp)                  ; FD EE 00
 ld jkhl, (sp+0)                ; FD EE 00
 ld jkhl, (sp+127)              ; FD EE 7F
 ld jkhl, (sp+255)              ; FD EE FF
 ld jkhl, (sp+hl)               ; FD FE
 ld jkhl, -128                  ; A4 80
 ld jkhl, 0                     ; A4 00
 ld jkhl, 126                   ; A4 7E
 ld jkhl, pw                    ; FD CD
 ld jkhl, px                    ; FD DD
 ld jkhl, py                    ; FD ED
 ld jkhl, pz                    ; FD FD
 ld l', (hl)                    ; 76 6E
 ld l', (ix)                    ; 76 DD 6E 00
 ld l', (ix+0)                  ; 76 DD 6E 00
 ld l', (ix+126)                ; 76 DD 6E 7E
 ld l', (ix-128)                ; 76 DD 6E 80
 ld l', (iy)                    ; 76 FD 6E 00
 ld l', (iy+0)                  ; 76 FD 6E 00
 ld l', (iy+126)                ; 76 FD 6E 7E
 ld l', (iy-128)                ; 76 FD 6E 80
 ld l', 0                       ; 76 2E 00
 ld l', 127                     ; 76 2E 7F
 ld l', 255                     ; 76 2E FF
 ld l', a                       ; 76 7F 6F
 ld l', b                       ; 76 7F 68
 ld l', c                       ; 76 7F 69
 ld l', d                       ; 76 7F 6A
 ld l', e                       ; 76 7F 6B
 ld l', h                       ; 76 7F 6C
 ld l', l                       ; 76 7F 6D
 ld l, (hl)                     ; 6E
 ld l, (ix)                     ; DD 6E 00
 ld l, (ix+0)                   ; DD 6E 00
 ld l, (ix+126)                 ; DD 6E 7E
 ld l, (ix-128)                 ; DD 6E 80
 ld l, (iy)                     ; FD 6E 00
 ld l, (iy+0)                   ; FD 6E 00
 ld l, (iy+126)                 ; FD 6E 7E
 ld l, (iy-128)                 ; FD 6E 80
 ld l, 0                        ; 2E 00
 ld l, 127                      ; 2E 7F
 ld l, 255                      ; 2E FF
 ld l, a                        ; 7F 6F
 ld l, b                        ; 7F 68
 ld l, c                        ; 7F 69
 ld l, d                        ; 7F 6A
 ld l, e                        ; 7F 6B
 ld l, h                        ; 7F 6C
 ld l, l                        ; 7F 6D
 ld lxpc, hl                    ; 97
 ld pw', (pw)                   ; 76 6D 08 00
 ld pw', (pw+0)                 ; 76 6D 08 00
 ld pw', (pw+126)               ; 76 6D 08 7E
 ld pw', (pw+hl)                ; 76 6D 0A
 ld pw', (pw-128)               ; 76 6D 08 80
 ld pw', (px)                   ; 76 6D 18 00
 ld pw', (px+0)                 ; 76 6D 18 00
 ld pw', (px+126)               ; 76 6D 18 7E
 ld pw', (px+hl)                ; 76 6D 1A
 ld pw', (px-128)               ; 76 6D 18 80
 ld pw', (py)                   ; 76 6D 28 00
 ld pw', (py+0)                 ; 76 6D 28 00
 ld pw', (py+126)               ; 76 6D 28 7E
 ld pw', (py+hl)                ; 76 6D 2A
 ld pw', (py-128)               ; 76 6D 28 80
 ld pw', (pz)                   ; 76 6D 38 00
 ld pw', (pz+0)                 ; 76 6D 38 00
 ld pw', (pz+126)               ; 76 6D 38 7E
 ld pw', (pz+hl)                ; 76 6D 3A
 ld pw', (pz-128)               ; 76 6D 38 80
 ld pw', pw                     ; 76 6D 07
 ld pw', pw+de                  ; 76 6D 06
 ld pw', pw+hl                  ; 76 6D 0E
 ld pw', pw+ix                  ; 76 6D 04
 ld pw', pw+iy                  ; 76 6D 05
 ld pw', px                     ; 76 6D 17
 ld pw', px+de                  ; 76 6D 16
 ld pw', px+hl                  ; 76 6D 1E
 ld pw', px+ix                  ; 76 6D 14
 ld pw', px+iy                  ; 76 6D 15
 ld pw', py                     ; 76 6D 27
 ld pw', py+de                  ; 76 6D 26
 ld pw', py+hl                  ; 76 6D 2E
 ld pw', py+ix                  ; 76 6D 24
 ld pw', py+iy                  ; 76 6D 25
 ld pw', pz                     ; 76 6D 37
 ld pw', pz+de                  ; 76 6D 36
 ld pw', pz+hl                  ; 76 6D 3E
 ld pw', pz+ix                  ; 76 6D 34
 ld pw', pz+iy                  ; 76 6D 35
 ld pw, (htr+hl)                ; ED 01
 ld pw, (pw)                    ; 6D 08 00
 ld pw, (pw+0)                  ; 6D 08 00
 ld pw, (pw+126)                ; 6D 08 7E
 ld pw, (pw+hl)                 ; 6D 0A
 ld pw, (pw-128)                ; 6D 08 80
 ld pw, (px)                    ; 6D 18 00
 ld pw, (px+0)                  ; 6D 18 00
 ld pw, (px+126)                ; 6D 18 7E
 ld pw, (px+hl)                 ; 6D 1A
 ld pw, (px-128)                ; 6D 18 80
 ld pw, (py)                    ; 6D 28 00
 ld pw, (py+0)                  ; 6D 28 00
 ld pw, (py+126)                ; 6D 28 7E
 ld pw, (py+hl)                 ; 6D 2A
 ld pw, (py-128)                ; 6D 28 80
 ld pw, (pz)                    ; 6D 38 00
 ld pw, (pz+0)                  ; 6D 38 00
 ld pw, (pz+126)                ; 6D 38 7E
 ld pw, (pz+hl)                 ; 6D 3A
 ld pw, (pz-128)                ; 6D 38 80
 ld pw, (sp)                    ; ED 04 00
 ld pw, (sp+0)                  ; ED 04 00
 ld pw, (sp+127)                ; ED 04 7F
 ld pw, (sp+255)                ; ED 04 FF
 ld pw, 0x12345678              ; ED 0C 78 56 34 12
 ld pw, bcde                    ; DD 8D
 ld pw, jkhl                    ; FD 8D
 ld pw, pw                      ; 6D 07
 ld pw, pw+0                    ; 6D 0C 00
 ld pw, pw+126                  ; 6D 0C 7E
 ld pw, pw+de                   ; 6D 06
 ld pw, pw+hl                   ; 6D 0E
 ld pw, pw+ix                   ; 6D 04
 ld pw, pw+iy                   ; 6D 05
 ld pw, pw-128                  ; 6D 0C 80
 ld pw, px                      ; 6D 17
 ld pw, px+0                    ; 6D 1C 00
 ld pw, px+126                  ; 6D 1C 7E
 ld pw, px+de                   ; 6D 16
 ld pw, px+hl                   ; 6D 1E
 ld pw, px+ix                   ; 6D 14
 ld pw, px+iy                   ; 6D 15
 ld pw, px-128                  ; 6D 1C 80
 ld pw, py                      ; 6D 27
 ld pw, py+0                    ; 6D 2C 00
 ld pw, py+126                  ; 6D 2C 7E
 ld pw, py+de                   ; 6D 26
 ld pw, py+hl                   ; 6D 2E
 ld pw, py+ix                   ; 6D 24
 ld pw, py+iy                   ; 6D 25
 ld pw, py-128                  ; 6D 2C 80
 ld pw, pz                      ; 6D 37
 ld pw, pz+0                    ; 6D 3C 00
 ld pw, pz+126                  ; 6D 3C 7E
 ld pw, pz+de                   ; 6D 36
 ld pw, pz+hl                   ; 6D 3E
 ld pw, pz+ix                   ; 6D 34
 ld pw, pz+iy                   ; 6D 35
 ld pw, pz-128                  ; 6D 3C 80
 ld px', (pw)                   ; 76 6D 48 00
 ld px', (pw+0)                 ; 76 6D 48 00
 ld px', (pw+126)               ; 76 6D 48 7E
 ld px', (pw+hl)                ; 76 6D 4A
 ld px', (pw-128)               ; 76 6D 48 80
 ld px', (px)                   ; 76 6D 58 00
 ld px', (px+0)                 ; 76 6D 58 00
 ld px', (px+126)               ; 76 6D 58 7E
 ld px', (px+hl)                ; 76 6D 5A
 ld px', (px-128)               ; 76 6D 58 80
 ld px', (py)                   ; 76 6D 68 00
 ld px', (py+0)                 ; 76 6D 68 00
 ld px', (py+126)               ; 76 6D 68 7E
 ld px', (py+hl)                ; 76 6D 6A
 ld px', (py-128)               ; 76 6D 68 80
 ld px', (pz)                   ; 76 6D 78 00
 ld px', (pz+0)                 ; 76 6D 78 00
 ld px', (pz+126)               ; 76 6D 78 7E
 ld px', (pz+hl)                ; 76 6D 7A
 ld px', (pz-128)               ; 76 6D 78 80
 ld px', pw                     ; 76 6D 47
 ld px', pw+de                  ; 76 6D 46
 ld px', pw+hl                  ; 76 6D 4E
 ld px', pw+ix                  ; 76 6D 44
 ld px', pw+iy                  ; 76 6D 45
 ld px', px                     ; 76 6D 57
 ld px', px+de                  ; 76 6D 56
 ld px', px+hl                  ; 76 6D 5E
 ld px', px+ix                  ; 76 6D 54
 ld px', px+iy                  ; 76 6D 55
 ld px', py                     ; 76 6D 67
 ld px', py+de                  ; 76 6D 66
 ld px', py+hl                  ; 76 6D 6E
 ld px', py+ix                  ; 76 6D 64
 ld px', py+iy                  ; 76 6D 65
 ld px', pz                     ; 76 6D 77
 ld px', pz+de                  ; 76 6D 76
 ld px', pz+hl                  ; 76 6D 7E
 ld px', pz+ix                  ; 76 6D 74
 ld px', pz+iy                  ; 76 6D 75
 ld px, (htr+hl)                ; ED 11
 ld px, (pw)                    ; 6D 48 00
 ld px, (pw+0)                  ; 6D 48 00
 ld px, (pw+126)                ; 6D 48 7E
 ld px, (pw+hl)                 ; 6D 4A
 ld px, (pw-128)                ; 6D 48 80
 ld px, (px)                    ; 6D 58 00
 ld px, (px+0)                  ; 6D 58 00
 ld px, (px+126)                ; 6D 58 7E
 ld px, (px+hl)                 ; 6D 5A
 ld px, (px-128)                ; 6D 58 80
 ld px, (py)                    ; 6D 68 00
 ld px, (py+0)                  ; 6D 68 00
 ld px, (py+126)                ; 6D 68 7E
 ld px, (py+hl)                 ; 6D 6A
 ld px, (py-128)                ; 6D 68 80
 ld px, (pz)                    ; 6D 78 00
 ld px, (pz+0)                  ; 6D 78 00
 ld px, (pz+126)                ; 6D 78 7E
 ld px, (pz+hl)                 ; 6D 7A
 ld px, (pz-128)                ; 6D 78 80
 ld px, (sp)                    ; ED 14 00
 ld px, (sp+0)                  ; ED 14 00
 ld px, (sp+127)                ; ED 14 7F
 ld px, (sp+255)                ; ED 14 FF
 ld px, 0x12345678              ; ED 1C 78 56 34 12
 ld px, bcde                    ; DD 9D
 ld px, jkhl                    ; FD 9D
 ld px, pw                      ; 6D 47
 ld px, pw+0                    ; 6D 4C 00
 ld px, pw+126                  ; 6D 4C 7E
 ld px, pw+de                   ; 6D 46
 ld px, pw+hl                   ; 6D 4E
 ld px, pw+ix                   ; 6D 44
 ld px, pw+iy                   ; 6D 45
 ld px, pw-128                  ; 6D 4C 80
 ld px, px                      ; 6D 57
 ld px, px+0                    ; 6D 5C 00
 ld px, px+126                  ; 6D 5C 7E
 ld px, px+de                   ; 6D 56
 ld px, px+hl                   ; 6D 5E
 ld px, px+ix                   ; 6D 54
 ld px, px+iy                   ; 6D 55
 ld px, px-128                  ; 6D 5C 80
 ld px, py                      ; 6D 67
 ld px, py+0                    ; 6D 6C 00
 ld px, py+126                  ; 6D 6C 7E
 ld px, py+de                   ; 6D 66
 ld px, py+hl                   ; 6D 6E
 ld px, py+ix                   ; 6D 64
 ld px, py+iy                   ; 6D 65
 ld px, py-128                  ; 6D 6C 80
 ld px, pz                      ; 6D 77
 ld px, pz+0                    ; 6D 7C 00
 ld px, pz+126                  ; 6D 7C 7E
 ld px, pz+de                   ; 6D 76
 ld px, pz+hl                   ; 6D 7E
 ld px, pz+ix                   ; 6D 74
 ld px, pz+iy                   ; 6D 75
 ld px, pz-128                  ; 6D 7C 80
 ld py', (pw)                   ; 76 6D 88 00
 ld py', (pw+0)                 ; 76 6D 88 00
 ld py', (pw+126)               ; 76 6D 88 7E
 ld py', (pw+hl)                ; 76 6D 8A
 ld py', (pw-128)               ; 76 6D 88 80
 ld py', (px)                   ; 76 6D 98 00
 ld py', (px+0)                 ; 76 6D 98 00
 ld py', (px+126)               ; 76 6D 98 7E
 ld py', (px+hl)                ; 76 6D 9A
 ld py', (px-128)               ; 76 6D 98 80
 ld py', (py)                   ; 76 6D A8 00
 ld py', (py+0)                 ; 76 6D A8 00
 ld py', (py+126)               ; 76 6D A8 7E
 ld py', (py+hl)                ; 76 6D AA
 ld py', (py-128)               ; 76 6D A8 80
 ld py', (pz)                   ; 76 6D B8 00
 ld py', (pz+0)                 ; 76 6D B8 00
 ld py', (pz+126)               ; 76 6D B8 7E
 ld py', (pz+hl)                ; 76 6D BA
 ld py', (pz-128)               ; 76 6D B8 80
 ld py', pw                     ; 76 6D 87
 ld py', pw+de                  ; 76 6D 86
 ld py', pw+hl                  ; 76 6D 8E
 ld py', pw+ix                  ; 76 6D 84
 ld py', pw+iy                  ; 76 6D 85
 ld py', px                     ; 76 6D 97
 ld py', px+de                  ; 76 6D 96
 ld py', px+hl                  ; 76 6D 9E
 ld py', px+ix                  ; 76 6D 94
 ld py', px+iy                  ; 76 6D 95
 ld py', py                     ; 76 6D A7
 ld py', py+de                  ; 76 6D A6
 ld py', py+hl                  ; 76 6D AE
 ld py', py+ix                  ; 76 6D A4
 ld py', py+iy                  ; 76 6D A5
 ld py', pz                     ; 76 6D B7
 ld py', pz+de                  ; 76 6D B6
 ld py', pz+hl                  ; 76 6D BE
 ld py', pz+ix                  ; 76 6D B4
 ld py', pz+iy                  ; 76 6D B5
 ld py, (htr+hl)                ; ED 21
 ld py, (pw)                    ; 6D 88 00
 ld py, (pw+0)                  ; 6D 88 00
 ld py, (pw+126)                ; 6D 88 7E
 ld py, (pw+hl)                 ; 6D 8A
 ld py, (pw-128)                ; 6D 88 80
 ld py, (px)                    ; 6D 98 00
 ld py, (px+0)                  ; 6D 98 00
 ld py, (px+126)                ; 6D 98 7E
 ld py, (px+hl)                 ; 6D 9A
 ld py, (px-128)                ; 6D 98 80
 ld py, (py)                    ; 6D A8 00
 ld py, (py+0)                  ; 6D A8 00
 ld py, (py+126)                ; 6D A8 7E
 ld py, (py+hl)                 ; 6D AA
 ld py, (py-128)                ; 6D A8 80
 ld py, (pz)                    ; 6D B8 00
 ld py, (pz+0)                  ; 6D B8 00
 ld py, (pz+126)                ; 6D B8 7E
 ld py, (pz+hl)                 ; 6D BA
 ld py, (pz-128)                ; 6D B8 80
 ld py, (sp)                    ; ED 24 00
 ld py, (sp+0)                  ; ED 24 00
 ld py, (sp+127)                ; ED 24 7F
 ld py, (sp+255)                ; ED 24 FF
 ld py, 0x12345678              ; ED 2C 78 56 34 12
 ld py, bcde                    ; DD AD
 ld py, jkhl                    ; FD AD
 ld py, pw                      ; 6D 87
 ld py, pw+0                    ; 6D 8C 00
 ld py, pw+126                  ; 6D 8C 7E
 ld py, pw+de                   ; 6D 86
 ld py, pw+hl                   ; 6D 8E
 ld py, pw+ix                   ; 6D 84
 ld py, pw+iy                   ; 6D 85
 ld py, pw-128                  ; 6D 8C 80
 ld py, px                      ; 6D 97
 ld py, px+0                    ; 6D 9C 00
 ld py, px+126                  ; 6D 9C 7E
 ld py, px+de                   ; 6D 96
 ld py, px+hl                   ; 6D 9E
 ld py, px+ix                   ; 6D 94
 ld py, px+iy                   ; 6D 95
 ld py, px-128                  ; 6D 9C 80
 ld py, py                      ; 6D A7
 ld py, py+0                    ; 6D AC 00
 ld py, py+126                  ; 6D AC 7E
 ld py, py+de                   ; 6D A6
 ld py, py+hl                   ; 6D AE
 ld py, py+ix                   ; 6D A4
 ld py, py+iy                   ; 6D A5
 ld py, py-128                  ; 6D AC 80
 ld py, pz                      ; 6D B7
 ld py, pz+0                    ; 6D BC 00
 ld py, pz+126                  ; 6D BC 7E
 ld py, pz+de                   ; 6D B6
 ld py, pz+hl                   ; 6D BE
 ld py, pz+ix                   ; 6D B4
 ld py, pz+iy                   ; 6D B5
 ld py, pz-128                  ; 6D BC 80
 ld pz', (pw)                   ; 76 6D C8 00
 ld pz', (pw+0)                 ; 76 6D C8 00
 ld pz', (pw+126)               ; 76 6D C8 7E
 ld pz', (pw+hl)                ; 76 6D CA
 ld pz', (pw-128)               ; 76 6D C8 80
 ld pz', (px)                   ; 76 6D D8 00
 ld pz', (px+0)                 ; 76 6D D8 00
 ld pz', (px+126)               ; 76 6D D8 7E
 ld pz', (px+hl)                ; 76 6D DA
 ld pz', (px-128)               ; 76 6D D8 80
 ld pz', (py)                   ; 76 6D E8 00
 ld pz', (py+0)                 ; 76 6D E8 00
 ld pz', (py+126)               ; 76 6D E8 7E
 ld pz', (py+hl)                ; 76 6D EA
 ld pz', (py-128)               ; 76 6D E8 80
 ld pz', (pz)                   ; 76 6D F8 00
 ld pz', (pz+0)                 ; 76 6D F8 00
 ld pz', (pz+126)               ; 76 6D F8 7E
 ld pz', (pz+hl)                ; 76 6D FA
 ld pz', (pz-128)               ; 76 6D F8 80
 ld pz', pw                     ; 76 6D C7
 ld pz', pw+de                  ; 76 6D C6
 ld pz', pw+hl                  ; 76 6D CE
 ld pz', pw+ix                  ; 76 6D C4
 ld pz', pw+iy                  ; 76 6D C5
 ld pz', px                     ; 76 6D D7
 ld pz', px+de                  ; 76 6D D6
 ld pz', px+hl                  ; 76 6D DE
 ld pz', px+ix                  ; 76 6D D4
 ld pz', px+iy                  ; 76 6D D5
 ld pz', py                     ; 76 6D E7
 ld pz', py+de                  ; 76 6D E6
 ld pz', py+hl                  ; 76 6D EE
 ld pz', py+ix                  ; 76 6D E4
 ld pz', py+iy                  ; 76 6D E5
 ld pz', pz                     ; 76 6D F7
 ld pz', pz+de                  ; 76 6D F6
 ld pz', pz+hl                  ; 76 6D FE
 ld pz', pz+ix                  ; 76 6D F4
 ld pz', pz+iy                  ; 76 6D F5
 ld pz, (htr+hl)                ; ED 31
 ld pz, (pw)                    ; 6D C8 00
 ld pz, (pw+0)                  ; 6D C8 00
 ld pz, (pw+126)                ; 6D C8 7E
 ld pz, (pw+hl)                 ; 6D CA
 ld pz, (pw-128)                ; 6D C8 80
 ld pz, (px)                    ; 6D D8 00
 ld pz, (px+0)                  ; 6D D8 00
 ld pz, (px+126)                ; 6D D8 7E
 ld pz, (px+hl)                 ; 6D DA
 ld pz, (px-128)                ; 6D D8 80
 ld pz, (py)                    ; 6D E8 00
 ld pz, (py+0)                  ; 6D E8 00
 ld pz, (py+126)                ; 6D E8 7E
 ld pz, (py+hl)                 ; 6D EA
 ld pz, (py-128)                ; 6D E8 80
 ld pz, (pz)                    ; 6D F8 00
 ld pz, (pz+0)                  ; 6D F8 00
 ld pz, (pz+126)                ; 6D F8 7E
 ld pz, (pz+hl)                 ; 6D FA
 ld pz, (pz-128)                ; 6D F8 80
 ld pz, (sp)                    ; ED 34 00
 ld pz, (sp+0)                  ; ED 34 00
 ld pz, (sp+127)                ; ED 34 7F
 ld pz, (sp+255)                ; ED 34 FF
 ld pz, 0x12345678              ; ED 3C 78 56 34 12
 ld pz, bcde                    ; DD BD
 ld pz, jkhl                    ; FD BD
 ld pz, pw                      ; 6D C7
 ld pz, pw+0                    ; 6D CC 00
 ld pz, pw+126                  ; 6D CC 7E
 ld pz, pw+de                   ; 6D C6
 ld pz, pw+hl                   ; 6D CE
 ld pz, pw+ix                   ; 6D C4
 ld pz, pw+iy                   ; 6D C5
 ld pz, pw-128                  ; 6D CC 80
 ld pz, px                      ; 6D D7
 ld pz, px+0                    ; 6D DC 00
 ld pz, px+126                  ; 6D DC 7E
 ld pz, px+de                   ; 6D D6
 ld pz, px+hl                   ; 6D DE
 ld pz, px+ix                   ; 6D D4
 ld pz, px+iy                   ; 6D D5
 ld pz, px-128                  ; 6D DC 80
 ld pz, py                      ; 6D E7
 ld pz, py+0                    ; 6D EC 00
 ld pz, py+126                  ; 6D EC 7E
 ld pz, py+de                   ; 6D E6
 ld pz, py+hl                   ; 6D EE
 ld pz, py+ix                   ; 6D E4
 ld pz, py+iy                   ; 6D E5
 ld pz, py-128                  ; 6D EC 80
 ld pz, pz                      ; 6D F7
 ld pz, pz+0                    ; 6D FC 00
 ld pz, pz+126                  ; 6D FC 7E
 ld pz, pz+de                   ; 6D F6
 ld pz, pz+hl                   ; 6D FE
 ld pz, pz+ix                   ; 6D F4
 ld pz, pz+iy                   ; 6D F5
 ld pz, pz-128                  ; 6D FC 80
 ld sp, (0x1234)                ; ED 7B 34 12
 ld sp, 0x1234                  ; 31 34 12
 ld sp, hl                      ; F9
 ld sp, ix                      ; DD F9
 ld sp, iy                      ; FD F9
 ld xpc, a                      ; ED 67
 ldd                            ; ED A8
 lddr                           ; ED B8
 lddsr                          ; ED 98
 ldf (0x123456), a              ; 8A 56 34 12
 ldf (0x123456), bc             ; ED 0B 56 34 12
 ldf (0x123456), bcde           ; DD 0B 56 34 12
 ldf (0x123456), de             ; ED 1B 56 34 12
 ldf (0x123456), hl             ; 82 56 34 12
 ldf (0x123456), ix             ; ED 2B 56 34 12
 ldf (0x123456), iy             ; ED 3B 56 34 12
 ldf (0x123456), jkhl           ; FD 0B 56 34 12
 ldf (0x123456), pw             ; ED 09 56 34 12
 ldf (0x123456), px             ; ED 19 56 34 12
 ldf (0x123456), py             ; ED 29 56 34 12
 ldf (0x123456), pz             ; ED 39 56 34 12
 ldf a', (0x123456)             ; 76 9A 56 34 12
 ldf a, (0x123456)              ; 9A 56 34 12
 ldf bc', (0x123456)            ; 76 ED 0A 56 34 12
 ldf bc, (0x123456)             ; ED 0A 56 34 12
 ldf bcde', (0x123456)          ; 76 DD 0A 56 34 12
 ldf bcde, (0x123456)           ; DD 0A 56 34 12
 ldf de', (0x123456)            ; 76 ED 1A 56 34 12
 ldf de, (0x123456)             ; ED 1A 56 34 12
 ldf hl', (0x123456)            ; 76 92 56 34 12
 ldf hl, (0x123456)             ; 92 56 34 12
 ldf ix, (0x123456)             ; ED 2A 56 34 12
 ldf iy, (0x123456)             ; ED 3A 56 34 12
 ldf jkhl', (0x123456)          ; 76 FD 0A 56 34 12
 ldf jkhl, (0x123456)           ; FD 0A 56 34 12
 ldf pw', (0x123456)            ; 76 ED 08 56 34 12
 ldf pw, (0x123456)             ; ED 08 56 34 12
 ldf px', (0x123456)            ; 76 ED 18 56 34 12
 ldf px, (0x123456)             ; ED 18 56 34 12
 ldf py', (0x123456)            ; 76 ED 28 56 34 12
 ldf py, (0x123456)             ; ED 28 56 34 12
 ldf pz', (0x123456)            ; 76 ED 38 56 34 12
 ldf pz, (0x123456)             ; ED 38 56 34 12
 ldi                            ; ED A0
 ldir                           ; ED B0
 ldisr                          ; ED 90
 ldl pw', (sp)                  ; 76 ED 03 00
 ldl pw', (sp+0)                ; 76 ED 03 00
 ldl pw', (sp+127)              ; 76 ED 03 7F
 ldl pw', (sp+255)              ; 76 ED 03 FF
 ldl pw', 0x1234                ; 76 ED 0D 34 12
 ldl pw', de                    ; 76 DD 8F
 ldl pw', hl                    ; 76 FD 8F
 ldl pw', ix                    ; 76 DD 8C
 ldl pw', iy                    ; 76 FD 8C
 ldl pw, (sp)                   ; ED 03 00
 ldl pw, (sp+0)                 ; ED 03 00
 ldl pw, (sp+127)               ; ED 03 7F
 ldl pw, (sp+255)               ; ED 03 FF
 ldl pw, 0x1234                 ; ED 0D 34 12
 ldl pw, de                     ; DD 8F
 ldl pw, hl                     ; FD 8F
 ldl pw, ix                     ; DD 8C
 ldl pw, iy                     ; FD 8C
 ldl px', (sp)                  ; 76 ED 13 00
 ldl px', (sp+0)                ; 76 ED 13 00
 ldl px', (sp+127)              ; 76 ED 13 7F
 ldl px', (sp+255)              ; 76 ED 13 FF
 ldl px', 0x1234                ; 76 ED 1D 34 12
 ldl px', de                    ; 76 DD 9F
 ldl px', hl                    ; 76 FD 9F
 ldl px', ix                    ; 76 DD 9C
 ldl px', iy                    ; 76 FD 9C
 ldl px, (sp)                   ; ED 13 00
 ldl px, (sp+0)                 ; ED 13 00
 ldl px, (sp+127)               ; ED 13 7F
 ldl px, (sp+255)               ; ED 13 FF
 ldl px, 0x1234                 ; ED 1D 34 12
 ldl px, de                     ; DD 9F
 ldl px, hl                     ; FD 9F
 ldl px, ix                     ; DD 9C
 ldl px, iy                     ; FD 9C
 ldl py', (sp)                  ; 76 ED 23 00
 ldl py', (sp+0)                ; 76 ED 23 00
 ldl py', (sp+127)              ; 76 ED 23 7F
 ldl py', (sp+255)              ; 76 ED 23 FF
 ldl py', 0x1234                ; 76 ED 2D 34 12
 ldl py', de                    ; 76 DD AF
 ldl py', hl                    ; 76 FD AF
 ldl py', ix                    ; 76 DD AC
 ldl py', iy                    ; 76 FD AC
 ldl py, (sp)                   ; ED 23 00
 ldl py, (sp+0)                 ; ED 23 00
 ldl py, (sp+127)               ; ED 23 7F
 ldl py, (sp+255)               ; ED 23 FF
 ldl py, 0x1234                 ; ED 2D 34 12
 ldl py, de                     ; DD AF
 ldl py, hl                     ; FD AF
 ldl py, ix                     ; DD AC
 ldl py, iy                     ; FD AC
 ldl pz', (sp)                  ; 76 ED 33 00
 ldl pz', (sp+0)                ; 76 ED 33 00
 ldl pz', (sp+127)              ; 76 ED 33 7F
 ldl pz', (sp+255)              ; 76 ED 33 FF
 ldl pz', 0x1234                ; 76 ED 3D 34 12
 ldl pz', de                    ; 76 DD BF
 ldl pz', hl                    ; 76 FD BF
 ldl pz', ix                    ; 76 DD BC
 ldl pz', iy                    ; 76 FD BC
 ldl pz, (sp)                   ; ED 33 00
 ldl pz, (sp+0)                 ; ED 33 00
 ldl pz, (sp+127)               ; ED 33 7F
 ldl pz, (sp+255)               ; ED 33 FF
 ldl pz, 0x1234                 ; ED 3D 34 12
 ldl pz, de                     ; DD BF
 ldl pz, hl                     ; FD BF
 ldl pz, ix                     ; DD BC
 ldl pz, iy                     ; FD BC
 ldp (0x1234), hl               ; ED 65 34 12
 ldp (0x1234), ix               ; DD 65 34 12
 ldp (0x1234), iy               ; FD 65 34 12
 ldp (hl), hl                   ; ED 64
 ldp (ix), hl                   ; DD 64
 ldp (iy), hl                   ; FD 64
 ldp hl, (0x1234)               ; ED 6D 34 12
 ldp hl, (hl)                   ; ED 6C
 ldp hl, (ix)                   ; DD 6C
 ldp hl, (iy)                   ; FD 6C
 ldp ix, (0x1234)               ; DD 6D 34 12
 ldp iy, (0x1234)               ; FD 6D 34 12
 ljp 0x56, 0x1234               ; C7 34 12 56
 llcall (jkhl)                  ; ED FA
 llcall 0x5678, 0x1234          ; 8F 34 12 78 56
 lljp 0x5678, 0x1234            ; 87 34 12 78 56
 lljp c, 0x5678, 0x1234         ; ED DA 34 12 78 56
 lljp gt, 0x5678, 0x1234        ; ED A2 34 12 78 56
 lljp gtu, 0x5678, 0x1234       ; ED AA 34 12 78 56
 lljp lt, 0x5678, 0x1234        ; ED B2 34 12 78 56
 lljp nc, 0x5678, 0x1234        ; ED D2 34 12 78 56
 lljp nz, 0x5678, 0x1234        ; ED C2 34 12 78 56
 lljp v, 0x5678, 0x1234         ; ED BA 34 12 78 56
 lljp z, 0x5678, 0x1234         ; ED CA 34 12 78 56
 llret                          ; ED 8B
 lret                           ; ED 45
 lsddr                          ; ED D8
 lsdr                           ; ED F8
 lsidr                          ; ED D0
 lsir                           ; ED F0
 mul                            ; F7
 mulu                           ; A7
 neg                            ; ED 44
 neg bcde                       ; DD 4D
 neg bcde'                      ; 76 DD 4D
 neg hl                         ; 4D
 neg hl'                        ; 76 4D
 neg jkhl                       ; FD 4D
 neg jkhl'                      ; 76 FD 4D
 nop                            ; 00
 or (hl)                        ; 7F B6
 or (ix)                        ; DD B6 00
 or (ix+0)                      ; DD B6 00
 or (ix+126)                    ; DD B6 7E
 or (ix-128)                    ; DD B6 80
 or (iy)                        ; FD B6 00
 or (iy+0)                      ; FD B6 00
 or (iy+126)                    ; FD B6 7E
 or (iy-128)                    ; FD B6 80
 or 0                           ; F6 00
 or 127                         ; F6 7F
 or 255                         ; F6 FF
 or a                           ; 7F B7
 or a'                          ; 76 7F B7
 or b                           ; 7F B0
 or b'                          ; 76 7F B0
 or c                           ; 7F B1
 or c'                          ; 76 7F B1
 or d                           ; 7F B2
 or d'                          ; 76 7F B2
 or e                           ; 7F B3
 or e'                          ; 76 7F B3
 or h                           ; 7F B4
 or h'                          ; 76 7F B4
 or hl', de                     ; 76 EC
 or hl, de                      ; EC
 or ix, de                      ; DD EC
 or iy, de                      ; FD EC
 or jkhl', bcde                 ; 76 ED F6
 or jkhl, bcde                  ; ED F6
 or l                           ; 7F B5
 or l'                          ; 76 7F B5
 pop af                         ; F1
 pop af'                        ; 76 F1
 pop bc                         ; C1
 pop bc'                        ; 76 C1
 pop bcde                       ; DD F1
 pop bcde'                      ; 76 DD F1
 pop de                         ; D1
 pop de'                        ; 76 D1
 pop hl                         ; E1
 pop hl'                        ; 76 E1
 pop ip                         ; ED 7E
 pop ix                         ; DD E1
 pop iy                         ; FD E1
 pop jkhl                       ; FD F1
 pop jkhl'                      ; 76 FD F1
 pop pw                         ; ED C1
 pop pw'                        ; 76 ED C1
 pop px                         ; ED D1
 pop px'                        ; 76 ED D1
 pop py                         ; ED E1
 pop py'                        ; 76 ED E1
 pop pz                         ; ED F1
 pop pz'                        ; 76 ED F1
 pop su                         ; ED 6E
 push 0x1234                    ; ED A5 34 12
 push af                        ; F5
 push bc                        ; C5
 push bcde                      ; DD F5
 push de                        ; D5
 push hl                        ; E5
 push ip                        ; ED 76
 push ix                        ; DD E5
 push iy                        ; FD E5
 push jkhl                      ; FD F5
 push pw                        ; ED C5
 push px                        ; ED D5
 push py                        ; ED E5
 push pz                        ; ED F5
 push su                        ; ED 66
 rdmode                         ; ED 7F
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
 res 1, (ix+0)                  ; DD CB 00 8E
 res 1, (ix+126)                ; DD CB 7E 8E
 res 1, (ix-128)                ; DD CB 80 8E
 res 1, (iy)                    ; FD CB 00 8E
 res 1, (iy+0)                  ; FD CB 00 8E
 res 1, (iy+126)                ; FD CB 7E 8E
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
 res 2, (ix+0)                  ; DD CB 00 96
 res 2, (ix+126)                ; DD CB 7E 96
 res 2, (ix-128)                ; DD CB 80 96
 res 2, (iy)                    ; FD CB 00 96
 res 2, (iy+0)                  ; FD CB 00 96
 res 2, (iy+126)                ; FD CB 7E 96
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
 res 3, (ix+0)                  ; DD CB 00 9E
 res 3, (ix+126)                ; DD CB 7E 9E
 res 3, (ix-128)                ; DD CB 80 9E
 res 3, (iy)                    ; FD CB 00 9E
 res 3, (iy+0)                  ; FD CB 00 9E
 res 3, (iy+126)                ; FD CB 7E 9E
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
 res 4, (ix+0)                  ; DD CB 00 A6
 res 4, (ix+126)                ; DD CB 7E A6
 res 4, (ix-128)                ; DD CB 80 A6
 res 4, (iy)                    ; FD CB 00 A6
 res 4, (iy+0)                  ; FD CB 00 A6
 res 4, (iy+126)                ; FD CB 7E A6
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
 res 5, (ix+0)                  ; DD CB 00 AE
 res 5, (ix+126)                ; DD CB 7E AE
 res 5, (ix-128)                ; DD CB 80 AE
 res 5, (iy)                    ; FD CB 00 AE
 res 5, (iy+0)                  ; FD CB 00 AE
 res 5, (iy+126)                ; FD CB 7E AE
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
 res 6, (ix+0)                  ; DD CB 00 B6
 res 6, (ix+126)                ; DD CB 7E B6
 res 6, (ix-128)                ; DD CB 80 B6
 res 6, (iy)                    ; FD CB 00 B6
 res 6, (iy+0)                  ; FD CB 00 B6
 res 6, (iy+126)                ; FD CB 7E B6
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
 res 7, (ix+0)                  ; DD CB 00 BE
 res 7, (ix+126)                ; DD CB 7E BE
 res 7, (ix-128)                ; DD CB 80 BE
 res 7, (iy)                    ; FD CB 00 BE
 res 7, (iy+0)                  ; FD CB 00 BE
 res 7, (iy+126)                ; FD CB 7E BE
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
 ret nz                         ; C0
 ret p                          ; F0
 ret pe                         ; E8
 ret po                         ; E0
 ret z                          ; C8
 reti                           ; ED 4D
 rl (hl)                        ; CB 16
 rl (ix)                        ; DD CB 00 16
 rl (ix+0)                      ; DD CB 00 16
 rl (ix+126)                    ; DD CB 7E 16
 rl (ix-128)                    ; DD CB 80 16
 rl (iy)                        ; FD CB 00 16
 rl (iy+0)                      ; FD CB 00 16
 rl (iy+126)                    ; FD CB 7E 16
 rl (iy-128)                    ; FD CB 80 16
 rl 1, bcde                     ; DD 68
 rl 1, bcde'                    ; 76 DD 68
 rl 1, jkhl                     ; FD 68
 rl 1, jkhl'                    ; 76 FD 68
 rl 2, bcde                     ; DD 69
 rl 2, bcde'                    ; 76 DD 69
 rl 2, jkhl                     ; FD 69
 rl 2, jkhl'                    ; 76 FD 69
 rl 4, bcde                     ; DD 6B
 rl 4, bcde'                    ; 76 DD 6B
 rl 4, jkhl                     ; FD 6B
 rl 4, jkhl'                    ; 76 FD 6B
 rl a                           ; CB 17
 rl a'                          ; 76 CB 17
 rl b                           ; CB 10
 rl b'                          ; 76 CB 10
 rl bc                          ; 62
 rl bc'                         ; 76 62
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
 rl hl                          ; 42
 rl hl'                         ; 76 42
 rl l                           ; CB 15
 rl l'                          ; 76 CB 15
 rla                            ; 17
 rla'                           ; 76 17
 rlb a, bcde                    ; DD 6F
 rlb a, jkhl                    ; FD 6F
 rlc (hl)                       ; CB 06
 rlc (ix)                       ; DD CB 00 06
 rlc (ix+0)                     ; DD CB 00 06
 rlc (ix+126)                   ; DD CB 7E 06
 rlc (ix-128)                   ; DD CB 80 06
 rlc (iy)                       ; FD CB 00 06
 rlc (iy+0)                     ; FD CB 00 06
 rlc (iy+126)                   ; FD CB 7E 06
 rlc (iy-128)                   ; FD CB 80 06
 rlc 1, bcde                    ; DD 48
 rlc 1, bcde'                   ; 76 DD 48
 rlc 1, jkhl                    ; FD 48
 rlc 1, jkhl'                   ; 76 FD 48
 rlc 2, bcde                    ; DD 49
 rlc 2, bcde'                   ; 76 DD 49
 rlc 2, jkhl                    ; FD 49
 rlc 2, jkhl'                   ; 76 FD 49
 rlc 4, bcde                    ; DD 4B
 rlc 4, bcde'                   ; 76 DD 4B
 rlc 4, jkhl                    ; FD 4B
 rlc 4, jkhl'                   ; 76 FD 4B
 rlc 8, bcde                    ; DD 4F
 rlc 8, jkhl                    ; FD 4F
 rlc a                          ; CB 07
 rlc a'                         ; 76 CB 07
 rlc b                          ; CB 00
 rlc b'                         ; 76 CB 00
 rlc bc                         ; 60
 rlc bc'                        ; 76 60
 rlc c                          ; CB 01
 rlc c'                         ; 76 CB 01
 rlc d                          ; CB 02
 rlc d'                         ; 76 CB 02
 rlc de                         ; 50
 rlc de'                        ; 76 50
 rlc e                          ; CB 03
 rlc e'                         ; 76 CB 03
 rlc h                          ; CB 04
 rlc h'                         ; 76 CB 04
 rlc l                          ; CB 05
 rlc l'                         ; 76 CB 05
 rlca                           ; 07
 rlca'                          ; 76 07
 rr (hl)                        ; CB 1E
 rr (ix)                        ; DD CB 00 1E
 rr (ix+0)                      ; DD CB 00 1E
 rr (ix+126)                    ; DD CB 7E 1E
 rr (ix-128)                    ; DD CB 80 1E
 rr (iy)                        ; FD CB 00 1E
 rr (iy+0)                      ; FD CB 00 1E
 rr (iy+126)                    ; FD CB 7E 1E
 rr (iy-128)                    ; FD CB 80 1E
 rr 1, bcde                     ; DD 78
 rr 1, bcde'                    ; 76 DD 78
 rr 1, jkhl                     ; FD 78
 rr 1, jkhl'                    ; 76 FD 78
 rr 2, bcde                     ; DD 79
 rr 2, bcde'                    ; 76 DD 79
 rr 2, jkhl                     ; FD 79
 rr 2, jkhl'                    ; 76 FD 79
 rr 4, bcde                     ; DD 7B
 rr 4, bcde'                    ; 76 DD 7B
 rr 4, jkhl                     ; FD 7B
 rr 4, jkhl'                    ; 76 FD 7B
 rr a                           ; CB 1F
 rr a'                          ; 76 CB 1F
 rr b                           ; CB 18
 rr b'                          ; 76 CB 18
 rr bc                          ; 63
 rr bc'                         ; 76 63
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
 rrb a, bcde                    ; DD 7F
 rrb a, jkhl                    ; FD 7F
 rrc (hl)                       ; CB 0E
 rrc (ix)                       ; DD CB 00 0E
 rrc (ix+0)                     ; DD CB 00 0E
 rrc (ix+126)                   ; DD CB 7E 0E
 rrc (ix-128)                   ; DD CB 80 0E
 rrc (iy)                       ; FD CB 00 0E
 rrc (iy+0)                     ; FD CB 00 0E
 rrc (iy+126)                   ; FD CB 7E 0E
 rrc (iy-128)                   ; FD CB 80 0E
 rrc 1, bcde                    ; DD 58
 rrc 1, bcde'                   ; 76 DD 58
 rrc 1, jkhl                    ; FD 58
 rrc 1, jkhl'                   ; 76 FD 58
 rrc 2, bcde                    ; DD 59
 rrc 2, bcde'                   ; 76 DD 59
 rrc 2, jkhl                    ; FD 59
 rrc 2, jkhl'                   ; 76 FD 59
 rrc 4, bcde                    ; DD 5B
 rrc 4, bcde'                   ; 76 DD 5B
 rrc 4, jkhl                    ; FD 5B
 rrc 4, jkhl'                   ; 76 FD 5B
 rrc 8, bcde                    ; DD 5F
 rrc 8, jkhl                    ; FD 5F
 rrc a                          ; CB 0F
 rrc a'                         ; 76 CB 0F
 rrc b                          ; CB 08
 rrc b'                         ; 76 CB 08
 rrc bc                         ; 61
 rrc bc'                        ; 76 61
 rrc c                          ; CB 09
 rrc c'                         ; 76 CB 09
 rrc d                          ; CB 0A
 rrc d'                         ; 76 CB 0A
 rrc de                         ; 51
 rrc de'                        ; 76 51
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
 sbc a', (hl)                   ; 76 7F 9E
 sbc a', (ix)                   ; 76 DD 9E 00
 sbc a', (ix+0)                 ; 76 DD 9E 00
 sbc a', (ix+126)               ; 76 DD 9E 7E
 sbc a', (ix-128)               ; 76 DD 9E 80
 sbc a', (iy)                   ; 76 FD 9E 00
 sbc a', (iy+0)                 ; 76 FD 9E 00
 sbc a', (iy+126)               ; 76 FD 9E 7E
 sbc a', (iy-128)               ; 76 FD 9E 80
 sbc a', 0                      ; 76 DE 00
 sbc a', 127                    ; 76 DE 7F
 sbc a', 255                    ; 76 DE FF
 sbc a', a                      ; 76 7F 9F
 sbc a', b                      ; 76 7F 98
 sbc a', c                      ; 76 7F 99
 sbc a', d                      ; 76 7F 9A
 sbc a', e                      ; 76 7F 9B
 sbc a', h                      ; 76 7F 9C
 sbc a', l                      ; 76 7F 9D
 sbc a, (hl)                    ; 7F 9E
 sbc a, (ix)                    ; DD 9E 00
 sbc a, (ix+0)                  ; DD 9E 00
 sbc a, (ix+126)                ; DD 9E 7E
 sbc a, (ix-128)                ; DD 9E 80
 sbc a, (iy)                    ; FD 9E 00
 sbc a, (iy+0)                  ; FD 9E 00
 sbc a, (iy+126)                ; FD 9E 7E
 sbc a, (iy-128)                ; FD 9E 80
 sbc a, 0                       ; DE 00
 sbc a, 127                     ; DE 7F
 sbc a, 255                     ; DE FF
 sbc a, a                       ; 7F 9F
 sbc a, b                       ; 7F 98
 sbc a, c                       ; 7F 99
 sbc a, d                       ; 7F 9A
 sbc a, e                       ; 7F 9B
 sbc a, h                       ; 7F 9C
 sbc a, l                       ; 7F 9D
 sbc hl', bc                    ; 76 ED 42
 sbc hl', de                    ; 76 ED 52
 sbc hl', hl                    ; 76 ED 62
 sbc hl', sp                    ; 76 ED 72
 sbc hl, bc                     ; ED 42
 sbc hl, de                     ; ED 52
 sbc hl, hl                     ; ED 62
 sbc hl, sp                     ; ED 72
 sbox a                         ; ED 02
 sbox a'                        ; 76 ED 02
 scf                            ; 37
 scf'                           ; 76 37
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
 set 1, (ix+0)                  ; DD CB 00 CE
 set 1, (ix+126)                ; DD CB 7E CE
 set 1, (ix-128)                ; DD CB 80 CE
 set 1, (iy)                    ; FD CB 00 CE
 set 1, (iy+0)                  ; FD CB 00 CE
 set 1, (iy+126)                ; FD CB 7E CE
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
 set 2, (ix+0)                  ; DD CB 00 D6
 set 2, (ix+126)                ; DD CB 7E D6
 set 2, (ix-128)                ; DD CB 80 D6
 set 2, (iy)                    ; FD CB 00 D6
 set 2, (iy+0)                  ; FD CB 00 D6
 set 2, (iy+126)                ; FD CB 7E D6
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
 set 3, (ix+0)                  ; DD CB 00 DE
 set 3, (ix+126)                ; DD CB 7E DE
 set 3, (ix-128)                ; DD CB 80 DE
 set 3, (iy)                    ; FD CB 00 DE
 set 3, (iy+0)                  ; FD CB 00 DE
 set 3, (iy+126)                ; FD CB 7E DE
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
 set 4, (ix+0)                  ; DD CB 00 E6
 set 4, (ix+126)                ; DD CB 7E E6
 set 4, (ix-128)                ; DD CB 80 E6
 set 4, (iy)                    ; FD CB 00 E6
 set 4, (iy+0)                  ; FD CB 00 E6
 set 4, (iy+126)                ; FD CB 7E E6
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
 set 5, (ix+0)                  ; DD CB 00 EE
 set 5, (ix+126)                ; DD CB 7E EE
 set 5, (ix-128)                ; DD CB 80 EE
 set 5, (iy)                    ; FD CB 00 EE
 set 5, (iy+0)                  ; FD CB 00 EE
 set 5, (iy+126)                ; FD CB 7E EE
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
 set 6, (ix+0)                  ; DD CB 00 F6
 set 6, (ix+126)                ; DD CB 7E F6
 set 6, (ix-128)                ; DD CB 80 F6
 set 6, (iy)                    ; FD CB 00 F6
 set 6, (iy+0)                  ; FD CB 00 F6
 set 6, (iy+126)                ; FD CB 7E F6
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
 set 7, (ix+0)                  ; DD CB 00 FE
 set 7, (ix+126)                ; DD CB 7E FE
 set 7, (ix-128)                ; DD CB 80 FE
 set 7, (iy)                    ; FD CB 00 FE
 set 7, (iy+0)                  ; FD CB 00 FE
 set 7, (iy+126)                ; FD CB 7E FE
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
 setsysp 0x1234                 ; ED B1 34 12
 setusr                         ; ED 6F
 setusrp 0x1234                 ; ED B5 34 12
 sla (hl)                       ; CB 26
 sla (ix)                       ; DD CB 00 26
 sla (ix+0)                     ; DD CB 00 26
 sla (ix+126)                   ; DD CB 7E 26
 sla (ix-128)                   ; DD CB 80 26
 sla (iy)                       ; FD CB 00 26
 sla (iy+0)                     ; FD CB 00 26
 sla (iy+126)                   ; FD CB 7E 26
 sla (iy-128)                   ; FD CB 80 26
 sla 1, bcde                    ; DD 88
 sla 1, bcde'                   ; 76 DD 88
 sla 1, jkhl                    ; FD 88
 sla 1, jkhl'                   ; 76 FD 88
 sla 2, bcde                    ; DD 89
 sla 2, bcde'                   ; 76 DD 89
 sla 2, jkhl                    ; FD 89
 sla 2, jkhl'                   ; 76 FD 89
 sla 4, bcde                    ; DD 8B
 sla 4, bcde'                   ; 76 DD 8B
 sla 4, jkhl                    ; FD 8B
 sla 4, jkhl'                   ; 76 FD 8B
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
 sll 1, bcde                    ; DD A8
 sll 1, bcde'                   ; 76 DD A8
 sll 1, jkhl                    ; FD A8
 sll 1, jkhl'                   ; 76 FD A8
 sll 2, bcde                    ; DD A9
 sll 2, bcde'                   ; 76 DD A9
 sll 2, jkhl                    ; FD A9
 sll 2, jkhl'                   ; 76 FD A9
 sll 4, bcde                    ; DD AB
 sll 4, bcde'                   ; 76 DD AB
 sll 4, jkhl                    ; FD AB
 sll 4, jkhl'                   ; 76 FD AB
 sra (hl)                       ; CB 2E
 sra (ix)                       ; DD CB 00 2E
 sra (ix+0)                     ; DD CB 00 2E
 sra (ix+126)                   ; DD CB 7E 2E
 sra (ix-128)                   ; DD CB 80 2E
 sra (iy)                       ; FD CB 00 2E
 sra (iy+0)                     ; FD CB 00 2E
 sra (iy+126)                   ; FD CB 7E 2E
 sra (iy-128)                   ; FD CB 80 2E
 sra 1, bcde                    ; DD 98
 sra 1, bcde'                   ; 76 DD 98
 sra 1, jkhl                    ; FD 98
 sra 1, jkhl'                   ; 76 FD 98
 sra 2, bcde                    ; DD 99
 sra 2, bcde'                   ; 76 DD 99
 sra 2, jkhl                    ; FD 99
 sra 2, jkhl'                   ; 76 FD 99
 sra 4, bcde                    ; DD 9B
 sra 4, bcde'                   ; 76 DD 9B
 sra 4, jkhl                    ; FD 9B
 sra 4, jkhl'                   ; 76 FD 9B
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
 sret                           ; ED 83
 srl (hl)                       ; CB 3E
 srl (ix)                       ; DD CB 00 3E
 srl (ix+0)                     ; DD CB 00 3E
 srl (ix+126)                   ; DD CB 7E 3E
 srl (ix-128)                   ; DD CB 80 3E
 srl (iy)                       ; FD CB 00 3E
 srl (iy+0)                     ; FD CB 00 3E
 srl (iy+126)                   ; FD CB 7E 3E
 srl (iy-128)                   ; FD CB 80 3E
 srl 1, bcde                    ; DD B8
 srl 1, bcde'                   ; 76 DD B8
 srl 1, jkhl                    ; FD B8
 srl 1, jkhl'                   ; 76 FD B8
 srl 2, bcde                    ; DD B9
 srl 2, bcde'                   ; 76 DD B9
 srl 2, jkhl                    ; FD B9
 srl 2, jkhl'                   ; 76 FD B9
 srl 4, bcde                    ; DD BB
 srl 4, bcde'                   ; 76 DD BB
 srl 4, jkhl                    ; FD BB
 srl 4, jkhl'                   ; 76 FD BB
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
 sub (hl)                       ; 7F 96
 sub (ix)                       ; DD 96 00
 sub (ix+0)                     ; DD 96 00
 sub (ix+126)                   ; DD 96 7E
 sub (ix-128)                   ; DD 96 80
 sub (iy)                       ; FD 96 00
 sub (iy+0)                     ; FD 96 00
 sub (iy+126)                   ; FD 96 7E
 sub (iy-128)                   ; FD 96 80
 sub 0                          ; D6 00
 sub 127                        ; D6 7F
 sub 255                        ; D6 FF
 sub a                          ; 7F 97
 sub a'                         ; 76 7F 97
 sub b                          ; 7F 90
 sub b'                         ; 76 7F 90
 sub c                          ; 7F 91
 sub c'                         ; 76 7F 91
 sub d                          ; 7F 92
 sub d'                         ; 76 7F 92
 sub e                          ; 7F 93
 sub e'                         ; 76 7F 93
 sub h                          ; 7F 94
 sub h'                         ; 76 7F 94
 sub hl', de                    ; 76 55
 sub hl', jk                    ; 76 45
 sub hl, de                     ; 55
 sub hl, jk                     ; 45
 sub jkhl', bcde                ; 76 ED D6
 sub jkhl, bcde                 ; ED D6
 sub l                          ; 7F 95
 sub l'                         ; 76 7F 95
 sures                          ; ED 7D
 syscall                        ; ED 75
 sysret                         ; ED 83
 test bc                        ; ED 4C
 test bc'                       ; 76 ED 4C
 test bcde                      ; DD 5C
 test bcde'                     ; 76 DD 5C
 test hl                        ; 4C
 test hl'                       ; 76 4C
 test ix                        ; DD 4C
 test iy                        ; FD 4C
 test jkhl                      ; FD 5C
 test jkhl'                     ; 76 FD 5C
 uma                            ; ED C0
 ums                            ; ED C8
 xor (hl)                       ; 7F AE
 xor (ix)                       ; DD AE 00
 xor (ix+0)                     ; DD AE 00
 xor (ix+126)                   ; DD AE 7E
 xor (ix-128)                   ; DD AE 80
 xor (iy)                       ; FD AE 00
 xor (iy+0)                     ; FD AE 00
 xor (iy+126)                   ; FD AE 7E
 xor (iy-128)                   ; FD AE 80
 xor 0                          ; EE 00
 xor 127                        ; EE 7F
 xor 255                        ; EE FF
 xor a                          ; 7F AF
 xor a'                         ; 76 7F AF
 xor b                          ; 7F A8
 xor b'                         ; 76 7F A8
 xor c                          ; 7F A9
 xor c'                         ; 76 7F A9
 xor d                          ; 7F AA
 xor d'                         ; 76 7F AA
 xor e                          ; 7F AB
 xor e'                         ; 76 7F AB
 xor h                          ; 7F AC
 xor h'                         ; 76 7F AC
 xor hl', de                    ; 76 54
 xor hl, de                     ; 54
 xor jkhl', bcde                ; 76 ED EE
 xor jkhl, bcde                 ; ED EE
 xor l                          ; 7F AD
 xor l'                         ; 76 7F AD
