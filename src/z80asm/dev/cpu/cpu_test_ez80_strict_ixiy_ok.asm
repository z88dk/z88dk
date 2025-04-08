 adc a, (hl)                    ; 8E
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
 adc hl, bc                     ; ED 4A
 adc hl, de                     ; ED 5A
 adc hl, hl                     ; ED 6A
 adc hl, sp                     ; ED 7A
 adc.s a, (hl)                  ; 52 8E
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
 adc.sil a, (hl)                ; 52 8E
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
 add a, (hl)                    ; 86
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
 add.s a, (hl)                  ; 52 86
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
 add.sil a, (hl)                ; 52 86
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
 and (hl)                       ; A6
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
 and a, ixh                     ; FD A4
 and a, ixl                     ; FD A5
 and a, iyh                     ; DD A4
 and a, iyl                     ; DD A5
 and b                          ; A0
 and c                          ; A1
 and d                          ; A2
 and e                          ; A3
 and h                          ; A4
 and l                          ; A5
 and.s (ix)                     ; 52 FD A6 00
 and.s (ix+0)                   ; 52 FD A6 00
 and.s (ix+126)                 ; 52 FD A6 7E
 and.s (ix-128)                 ; 52 FD A6 80
 and.s (iy)                     ; 52 DD A6 00
 and.s (iy+0)                   ; 52 DD A6 00
 and.s (iy+126)                 ; 52 DD A6 7E
 and.s (iy-128)                 ; 52 DD A6 80
 and.s a, (hl)                  ; 52 A6
 and.sil (ix)                   ; 52 FD A6 00
 and.sil (ix+0)                 ; 52 FD A6 00
 and.sil (ix+126)               ; 52 FD A6 7E
 and.sil (ix-128)               ; 52 FD A6 80
 and.sil (iy)                   ; 52 DD A6 00
 and.sil (iy+0)                 ; 52 DD A6 00
 and.sil (iy+126)               ; 52 DD A6 7E
 and.sil (iy-128)               ; 52 DD A6 80
 and.sil a, (hl)                ; 52 A6
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
 call 0x123456                  ; CD 56 34 12
 call c, 0x123456               ; DC 56 34 12
 call m, 0x123456               ; FC 56 34 12
 call nc, 0x123456              ; D4 56 34 12
 call nz, 0x123456              ; C4 56 34 12
 call p, 0x123456               ; F4 56 34 12
 call pe, 0x123456              ; EC 56 34 12
 call po, 0x123456              ; E4 56 34 12
 call z, 0x123456               ; CC 56 34 12
 call.il 0x123456               ; 5B CD 56 34 12
 call.il c, 0x123456            ; 5B DC 56 34 12
 call.il m, 0x123456            ; 5B FC 56 34 12
 call.il nc, 0x123456           ; 5B D4 56 34 12
 call.il nz, 0x123456           ; 5B C4 56 34 12
 call.il p, 0x123456            ; 5B F4 56 34 12
 call.il pe, 0x123456           ; 5B EC 56 34 12
 call.il po, 0x123456           ; 5B E4 56 34 12
 call.il z, 0x123456            ; 5B CC 56 34 12
 call.is 0x1234                 ; 49 CD 34 12
 call.is c, 0x1234              ; 49 DC 34 12
 call.is m, 0x1234              ; 49 FC 34 12
 call.is nc, 0x1234             ; 49 D4 34 12
 call.is nz, 0x1234             ; 49 C4 34 12
 call.is p, 0x1234              ; 49 F4 34 12
 call.is pe, 0x1234             ; 49 EC 34 12
 call.is po, 0x1234             ; 49 E4 34 12
 call.is z, 0x1234              ; 49 CC 34 12
 call.lil 0x123456              ; 5B CD 56 34 12
 call.lil c, 0x123456           ; 5B DC 56 34 12
 call.lil m, 0x123456           ; 5B FC 56 34 12
 call.lil nc, 0x123456          ; 5B D4 56 34 12
 call.lil nz, 0x123456          ; 5B C4 56 34 12
 call.lil p, 0x123456           ; 5B F4 56 34 12
 call.lil pe, 0x123456          ; 5B EC 56 34 12
 call.lil po, 0x123456          ; 5B E4 56 34 12
 call.lil z, 0x123456           ; 5B CC 56 34 12
 call.lis 0x1234                ; 49 CD 34 12
 call.lis c, 0x1234             ; 49 DC 34 12
 call.lis m, 0x1234             ; 49 FC 34 12
 call.lis nc, 0x1234            ; 49 D4 34 12
 call.lis nz, 0x1234            ; 49 C4 34 12
 call.lis p, 0x1234             ; 49 F4 34 12
 call.lis pe, 0x1234            ; 49 EC 34 12
 call.lis po, 0x1234            ; 49 E4 34 12
 call.lis z, 0x1234             ; 49 CC 34 12
 ccf                            ; 3F
 cp (hl)                        ; BE
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
 cp.s (ix)                      ; 52 FD BE 00
 cp.s (ix+0)                    ; 52 FD BE 00
 cp.s (ix+126)                  ; 52 FD BE 7E
 cp.s (ix-128)                  ; 52 FD BE 80
 cp.s (iy)                      ; 52 DD BE 00
 cp.s (iy+0)                    ; 52 DD BE 00
 cp.s (iy+126)                  ; 52 DD BE 7E
 cp.s (iy-128)                  ; 52 DD BE 80
 cp.sil (hl)                    ; 52 BE
 cp.sil (ix)                    ; 52 FD BE 00
 cp.sil (ix+0)                  ; 52 FD BE 00
 cp.sil (ix+126)                ; 52 FD BE 7E
 cp.sil (ix-128)                ; 52 FD BE 80
 cp.sil (iy)                    ; 52 DD BE 00
 cp.sil (iy+0)                  ; 52 DD BE 00
 cp.sil (iy+126)                ; 52 DD BE 7E
 cp.sil (iy-128)                ; 52 DD BE 80
 cpd                            ; ED A9
 cpd.s                          ; 52 ED A9
 cpd.sil                        ; 52 ED A9
 cpdr                           ; ED B9
 cpdr.s                         ; 52 ED B9
 cpdr.sil                       ; 52 ED B9
 cpi                            ; ED A1
 cpi.s                          ; 52 ED A1
 cpi.sil                        ; 52 ED A1
 cpir                           ; ED B1
 cpir.s                         ; 52 ED B1
 cpir.sil                       ; 52 ED B1
 cpl                            ; 2F
 daa                            ; 27
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
 dec b                          ; 05
 dec bc                         ; 0B
 dec c                          ; 0D
 dec d                          ; 15
 dec de                         ; 1B
 dec e                          ; 1D
 dec h                          ; 25
 dec hl                         ; 2B
 dec ix                         ; FD 2B
 dec ixh                        ; FD 25
 dec ixl                        ; FD 2D
 dec iy                         ; DD 2B
 dec iyh                        ; DD 25
 dec iyl                        ; DD 2D
 dec l                          ; 2D
 dec sp                         ; 3B
 dec.s (hl)                     ; 52 35
 dec.s (ix)                     ; 52 FD 35 00
 dec.s (ix+0)                   ; 52 FD 35 00
 dec.s (ix+126)                 ; 52 FD 35 7E
 dec.s (ix-128)                 ; 52 FD 35 80
 dec.s (iy)                     ; 52 DD 35 00
 dec.s (iy+0)                   ; 52 DD 35 00
 dec.s (iy+126)                 ; 52 DD 35 7E
 dec.s (iy-128)                 ; 52 DD 35 80
 dec.s bc                       ; 52 0B
 dec.s de                       ; 52 1B
 dec.s hl                       ; 52 2B
 dec.s ix                       ; 52 FD 2B
 dec.s iy                       ; 52 DD 2B
 dec.s sp                       ; 52 3B
 dec.sil (hl)                   ; 52 35
 dec.sil (ix)                   ; 52 FD 35 00
 dec.sil (ix+0)                 ; 52 FD 35 00
 dec.sil (ix+126)               ; 52 FD 35 7E
 dec.sil (ix-128)               ; 52 FD 35 80
 dec.sil (iy)                   ; 52 DD 35 00
 dec.sil (iy+0)                 ; 52 DD 35 00
 dec.sil (iy+126)               ; 52 DD 35 7E
 dec.sil (iy-128)               ; 52 DD 35 80
 dec.sil bc                     ; 52 0B
 dec.sil de                     ; 52 1B
 dec.sil hl                     ; 52 2B
 dec.sil ix                     ; 52 FD 2B
 dec.sil iy                     ; 52 DD 2B
 dec.sil sp                     ; 52 3B
 di                             ; F3
 djnz ASMPC                     ; 10 FE
 ei                             ; FB
 ex (sp), hl                    ; E3
 ex (sp), ix                    ; FD E3
 ex (sp), iy                    ; DD E3
 ex af, af'                     ; 08
 ex de, hl                      ; EB
 ex.s (sp), hl                  ; 52 E3
 ex.s (sp), ix                  ; 52 FD E3
 ex.s (sp), iy                  ; 52 DD E3
 ex.sil (sp), hl                ; 52 E3
 ex.sil (sp), ix                ; 52 FD E3
 ex.sil (sp), iy                ; 52 DD E3
 exx                            ; D9
 halt                           ; 76
 im 0                           ; ED 46
 im 1                           ; ED 56
 im 2                           ; ED 5E
 in a, (-128)                   ; DB 80
 in a, (0)                      ; DB 00
 in a, (127)                    ; DB 7F
 in a, (255)                    ; DB FF
 in a, (bc)                     ; ED 78
 in b, (bc)                     ; ED 40
 in c, (bc)                     ; ED 48
 in d, (bc)                     ; ED 50
 in e, (bc)                     ; ED 58
 in h, (bc)                     ; ED 60
 in l, (bc)                     ; ED 68
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
 inc (ix)                       ; FD 34 00
 inc (ix+0)                     ; FD 34 00
 inc (ix+126)                   ; FD 34 7E
 inc (ix-128)                   ; FD 34 80
 inc (iy)                       ; DD 34 00
 inc (iy+0)                     ; DD 34 00
 inc (iy+126)                   ; DD 34 7E
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
 inc ixh                        ; FD 24
 inc ixl                        ; FD 2C
 inc iy                         ; DD 23
 inc iyh                        ; DD 24
 inc iyl                        ; DD 2C
 inc l                          ; 2C
 inc sp                         ; 33
 inc.s (hl)                     ; 52 34
 inc.s (ix)                     ; 52 FD 34 00
 inc.s (ix+0)                   ; 52 FD 34 00
 inc.s (ix+126)                 ; 52 FD 34 7E
 inc.s (ix-128)                 ; 52 FD 34 80
 inc.s (iy)                     ; 52 DD 34 00
 inc.s (iy+0)                   ; 52 DD 34 00
 inc.s (iy+126)                 ; 52 DD 34 7E
 inc.s (iy-128)                 ; 52 DD 34 80
 inc.s bc                       ; 52 03
 inc.s de                       ; 52 13
 inc.s hl                       ; 52 23
 inc.s ix                       ; 52 FD 23
 inc.s iy                       ; 52 DD 23
 inc.s sp                       ; 52 33
 inc.sil (hl)                   ; 52 34
 inc.sil (ix)                   ; 52 FD 34 00
 inc.sil (ix+0)                 ; 52 FD 34 00
 inc.sil (ix+126)               ; 52 FD 34 7E
 inc.sil (ix-128)               ; 52 FD 34 80
 inc.sil (iy)                   ; 52 DD 34 00
 inc.sil (iy+0)                 ; 52 DD 34 00
 inc.sil (iy+126)               ; 52 DD 34 7E
 inc.sil (iy-128)               ; 52 DD 34 80
 inc.sil bc                     ; 52 03
 inc.sil de                     ; 52 13
 inc.sil hl                     ; 52 23
 inc.sil ix                     ; 52 FD 23
 inc.sil iy                     ; 52 DD 23
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
 jp (hl)                        ; E9
 jp (ix)                        ; FD E9
 jp (iy)                        ; DD E9
 jp 0x123456                    ; C3 56 34 12
 jp c, 0x123456                 ; DA 56 34 12
 jp m, 0x123456                 ; FA 56 34 12
 jp nc, 0x123456                ; D2 56 34 12
 jp nz, 0x123456                ; C2 56 34 12
 jp p, 0x123456                 ; F2 56 34 12
 jp pe, 0x123456                ; EA 56 34 12
 jp po, 0x123456                ; E2 56 34 12
 jp z, 0x123456                 ; CA 56 34 12
 jp.il 0x123456                 ; 5B C3 56 34 12
 jp.il c, 0x123456              ; 5B DA 56 34 12
 jp.il m, 0x123456              ; 5B FA 56 34 12
 jp.il nc, 0x123456             ; 5B D2 56 34 12
 jp.il nz, 0x123456             ; 5B C2 56 34 12
 jp.il p, 0x123456              ; 5B F2 56 34 12
 jp.il pe, 0x123456             ; 5B EA 56 34 12
 jp.il po, 0x123456             ; 5B E2 56 34 12
 jp.il z, 0x123456              ; 5B CA 56 34 12
 jp.lil 0x123456                ; 5B C3 56 34 12
 jp.lil c, 0x123456             ; 5B DA 56 34 12
 jp.lil m, 0x123456             ; 5B FA 56 34 12
 jp.lil nc, 0x123456            ; 5B D2 56 34 12
 jp.lil nz, 0x123456            ; 5B C2 56 34 12
 jp.lil p, 0x123456             ; 5B F2 56 34 12
 jp.lil pe, 0x123456            ; 5B EA 56 34 12
 jp.lil po, 0x123456            ; 5B E2 56 34 12
 jp.lil z, 0x123456             ; 5B CA 56 34 12
 jp.s (hl)                      ; 52 E9
 jp.s (ix)                      ; 52 FD E9
 jp.s (iy)                      ; 52 DD E9
 jp.sil (hl)                    ; 52 E9
 jp.sil (ix)                    ; 52 FD E9
 jp.sil (iy)                    ; 52 DD E9
 jp.sis 0x1234                  ; 40 C3 34 12
 jp.sis c, 0x1234               ; 40 DA 34 12
 jp.sis m, 0x1234               ; 40 FA 34 12
 jp.sis nc, 0x1234              ; 40 D2 34 12
 jp.sis nz, 0x1234              ; 40 C2 34 12
 jp.sis p, 0x1234               ; 40 F2 34 12
 jp.sis pe, 0x1234              ; 40 EA 34 12
 jp.sis po, 0x1234              ; 40 E2 34 12
 jp.sis z, 0x1234               ; 40 CA 34 12
 jr ASMPC                       ; 18 FE
 jr c, ASMPC                    ; 38 FE
 jr nc, ASMPC                   ; 30 FE
 jr nz, ASMPC                   ; 20 FE
 jr z, ASMPC                    ; 28 FE
 ld (0x123456), a               ; 32 56 34 12
 ld (bc), a                     ; 02
 ld (de), a                     ; 12
 ld (hl), -128                  ; 36 80
 ld (hl), 0                     ; 36 00
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
 ld (hl), ix                    ; ED 3E
 ld (hl), iy                    ; ED 3F
 ld (hl), l                     ; 75
 ld (ix), a                     ; FD 77 00
 ld (ix), b                     ; FD 70 00
 ld (ix), c                     ; FD 71 00
 ld (ix), d                     ; FD 72 00
 ld (ix), e                     ; FD 73 00
 ld (ix), h                     ; FD 74 00
 ld (ix), l                     ; FD 75 00
 ld (ix+0), a                   ; FD 77 00
 ld (ix+0), b                   ; FD 70 00
 ld (ix+0), c                   ; FD 71 00
 ld (ix+0), d                   ; FD 72 00
 ld (ix+0), e                   ; FD 73 00
 ld (ix+0), h                   ; FD 74 00
 ld (ix+0), l                   ; FD 75 00
 ld (ix+126), a                 ; FD 77 7E
 ld (ix+126), b                 ; FD 70 7E
 ld (ix+126), c                 ; FD 71 7E
 ld (ix+126), d                 ; FD 72 7E
 ld (ix+126), e                 ; FD 73 7E
 ld (ix+126), h                 ; FD 74 7E
 ld (ix+126), l                 ; FD 75 7E
 ld (ix-128), a                 ; FD 77 80
 ld (ix-128), b                 ; FD 70 80
 ld (ix-128), c                 ; FD 71 80
 ld (ix-128), d                 ; FD 72 80
 ld (ix-128), e                 ; FD 73 80
 ld (ix-128), h                 ; FD 74 80
 ld (ix-128), l                 ; FD 75 80
 ld (iy), a                     ; DD 77 00
 ld (iy), b                     ; DD 70 00
 ld (iy), c                     ; DD 71 00
 ld (iy), d                     ; DD 72 00
 ld (iy), e                     ; DD 73 00
 ld (iy), h                     ; DD 74 00
 ld (iy), l                     ; DD 75 00
 ld (iy+0), a                   ; DD 77 00
 ld (iy+0), b                   ; DD 70 00
 ld (iy+0), c                   ; DD 71 00
 ld (iy+0), d                   ; DD 72 00
 ld (iy+0), e                   ; DD 73 00
 ld (iy+0), h                   ; DD 74 00
 ld (iy+0), l                   ; DD 75 00
 ld (iy+126), a                 ; DD 77 7E
 ld (iy+126), b                 ; DD 70 7E
 ld (iy+126), c                 ; DD 71 7E
 ld (iy+126), d                 ; DD 72 7E
 ld (iy+126), e                 ; DD 73 7E
 ld (iy+126), h                 ; DD 74 7E
 ld (iy+126), l                 ; DD 75 7E
 ld (iy-128), a                 ; DD 77 80
 ld (iy-128), b                 ; DD 70 80
 ld (iy-128), c                 ; DD 71 80
 ld (iy-128), d                 ; DD 72 80
 ld (iy-128), e                 ; DD 73 80
 ld (iy-128), h                 ; DD 74 80
 ld (iy-128), l                 ; DD 75 80
 ld a, (0x123456)               ; 3A 56 34 12
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
 ld a, i                        ; ED 57
 ld a, ixh                      ; FD 7C
 ld a, ixl                      ; FD 7D
 ld a, iyh                      ; DD 7C
 ld a, iyl                      ; DD 7D
 ld a, mb                       ; ED 6E
 ld a, r                        ; ED 5F
 ld b, (hl)                     ; 46
 ld b, (ix)                     ; FD 46 00
 ld b, (ix+0)                   ; FD 46 00
 ld b, (ix+126)                 ; FD 46 7E
 ld b, (ix-128)                 ; FD 46 80
 ld b, (iy)                     ; DD 46 00
 ld b, (iy+0)                   ; DD 46 00
 ld b, (iy+126)                 ; DD 46 7E
 ld b, (iy-128)                 ; DD 46 80
 ld b, ixh                      ; FD 44
 ld b, ixl                      ; FD 45
 ld b, iyh                      ; DD 44
 ld b, iyl                      ; DD 45
 ld bc, (hl)                    ; ED 07
 ld bc, 0x123456                ; 01 56 34 12
 ld c, (hl)                     ; 4E
 ld c, (ix)                     ; FD 4E 00
 ld c, (ix+0)                   ; FD 4E 00
 ld c, (ix+126)                 ; FD 4E 7E
 ld c, (ix-128)                 ; FD 4E 80
 ld c, (iy)                     ; DD 4E 00
 ld c, (iy+0)                   ; DD 4E 00
 ld c, (iy+126)                 ; DD 4E 7E
 ld c, (iy-128)                 ; DD 4E 80
 ld c, ixh                      ; FD 4C
 ld c, ixl                      ; FD 4D
 ld c, iyh                      ; DD 4C
 ld c, iyl                      ; DD 4D
 ld d, (hl)                     ; 56
 ld d, (ix)                     ; FD 56 00
 ld d, (ix+0)                   ; FD 56 00
 ld d, (ix+126)                 ; FD 56 7E
 ld d, (ix-128)                 ; FD 56 80
 ld d, (iy)                     ; DD 56 00
 ld d, (iy+0)                   ; DD 56 00
 ld d, (iy+126)                 ; DD 56 7E
 ld d, (iy-128)                 ; DD 56 80
 ld d, ixh                      ; FD 54
 ld d, ixl                      ; FD 55
 ld d, iyh                      ; DD 54
 ld d, iyl                      ; DD 55
 ld de, (hl)                    ; ED 17
 ld de, 0x123456                ; 11 56 34 12
 ld e, (hl)                     ; 5E
 ld e, (ix)                     ; FD 5E 00
 ld e, (ix+0)                   ; FD 5E 00
 ld e, (ix+126)                 ; FD 5E 7E
 ld e, (ix-128)                 ; FD 5E 80
 ld e, (iy)                     ; DD 5E 00
 ld e, (iy+0)                   ; DD 5E 00
 ld e, (iy+126)                 ; DD 5E 7E
 ld e, (iy-128)                 ; DD 5E 80
 ld e, ixh                      ; FD 5C
 ld e, ixl                      ; FD 5D
 ld e, iyh                      ; DD 5C
 ld e, iyl                      ; DD 5D
 ld h, (hl)                     ; 66
 ld h, (ix)                     ; FD 66 00
 ld h, (ix+0)                   ; FD 66 00
 ld h, (ix+126)                 ; FD 66 7E
 ld h, (ix-128)                 ; FD 66 80
 ld h, (iy)                     ; DD 66 00
 ld h, (iy+0)                   ; DD 66 00
 ld h, (iy+126)                 ; DD 66 7E
 ld h, (iy-128)                 ; DD 66 80
 ld hl, (hl)                    ; ED 27
 ld hl, 0x123456                ; 21 56 34 12
 ld hl, i                       ; ED D7
 ld i, a                        ; ED 47
 ld i, hl                       ; ED C7
 ld ix, (hl)                    ; ED 31
 ld ix, (ix)                    ; FD 37 00
 ld ix, (ix+0)                  ; FD 37 00
 ld ix, (ix+126)                ; FD 37 7E
 ld ix, (ix-128)                ; FD 37 80
 ld ix, (iy)                    ; DD 31 00
 ld ix, (iy+0)                  ; DD 31 00
 ld ix, (iy+126)                ; DD 31 7E
 ld ix, (iy-128)                ; DD 31 80
 ld ix, 0x123456                ; FD 21 56 34 12
 ld ixh, -128                   ; FD 26 80
 ld ixh, 0                      ; FD 26 00
 ld ixh, 127                    ; FD 26 7F
 ld ixh, 255                    ; FD 26 FF
 ld ixh, a                      ; FD 67
 ld ixh, b                      ; FD 60
 ld ixh, c                      ; FD 61
 ld ixh, d                      ; FD 62
 ld ixh, e                      ; FD 63
 ld ixh, ixh                    ; FD 64
 ld ixh, ixl                    ; FD 65
 ld ixl, -128                   ; FD 2E 80
 ld ixl, 0                      ; FD 2E 00
 ld ixl, 127                    ; FD 2E 7F
 ld ixl, 255                    ; FD 2E FF
 ld ixl, a                      ; FD 6F
 ld ixl, b                      ; FD 68
 ld ixl, c                      ; FD 69
 ld ixl, d                      ; FD 6A
 ld ixl, e                      ; FD 6B
 ld ixl, ixh                    ; FD 6C
 ld ixl, ixl                    ; FD 6D
 ld iy, (hl)                    ; ED 37
 ld iy, (ix)                    ; FD 31 00
 ld iy, (ix+0)                  ; FD 31 00
 ld iy, (ix+126)                ; FD 31 7E
 ld iy, (ix-128)                ; FD 31 80
 ld iy, (iy)                    ; DD 37 00
 ld iy, (iy+0)                  ; DD 37 00
 ld iy, (iy+126)                ; DD 37 7E
 ld iy, (iy-128)                ; DD 37 80
 ld iy, 0x123456                ; DD 21 56 34 12
 ld iyh, -128                   ; DD 26 80
 ld iyh, 0                      ; DD 26 00
 ld iyh, 127                    ; DD 26 7F
 ld iyh, 255                    ; DD 26 FF
 ld iyh, a                      ; DD 67
 ld iyh, b                      ; DD 60
 ld iyh, c                      ; DD 61
 ld iyh, d                      ; DD 62
 ld iyh, e                      ; DD 63
 ld iyh, iyh                    ; DD 64
 ld iyh, iyl                    ; DD 65
 ld iyl, -128                   ; DD 2E 80
 ld iyl, 0                      ; DD 2E 00
 ld iyl, 127                    ; DD 2E 7F
 ld iyl, 255                    ; DD 2E FF
 ld iyl, a                      ; DD 6F
 ld iyl, b                      ; DD 68
 ld iyl, c                      ; DD 69
 ld iyl, d                      ; DD 6A
 ld iyl, e                      ; DD 6B
 ld iyl, iyh                    ; DD 6C
 ld iyl, iyl                    ; DD 6D
 ld l, (hl)                     ; 6E
 ld l, (ix)                     ; FD 6E 00
 ld l, (ix+0)                   ; FD 6E 00
 ld l, (ix+126)                 ; FD 6E 7E
 ld l, (ix-128)                 ; FD 6E 80
 ld l, (iy)                     ; DD 6E 00
 ld l, (iy+0)                   ; DD 6E 00
 ld l, (iy+126)                 ; DD 6E 7E
 ld l, (iy-128)                 ; DD 6E 80
 ld mb, a                       ; ED 6D
 ld r, a                        ; ED 4F
 ld sp, 0x123456                ; 31 56 34 12
 ld.s (bc), a                   ; 52 02
 ld.s (de), a                   ; 52 12
 ld.s (hl), -128                ; 52 36 80
 ld.s (hl), 0                   ; 52 36 00
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
 ld.s (hl), ix                  ; 52 ED 3E
 ld.s (hl), iy                  ; 52 ED 3F
 ld.s (hl), l                   ; 52 75
 ld.s (ix), a                   ; 52 FD 77 00
 ld.s (ix), b                   ; 52 FD 70 00
 ld.s (ix), c                   ; 52 FD 71 00
 ld.s (ix), d                   ; 52 FD 72 00
 ld.s (ix), e                   ; 52 FD 73 00
 ld.s (ix), h                   ; 52 FD 74 00
 ld.s (ix), l                   ; 52 FD 75 00
 ld.s (ix+0), a                 ; 52 FD 77 00
 ld.s (ix+0), b                 ; 52 FD 70 00
 ld.s (ix+0), c                 ; 52 FD 71 00
 ld.s (ix+0), d                 ; 52 FD 72 00
 ld.s (ix+0), e                 ; 52 FD 73 00
 ld.s (ix+0), h                 ; 52 FD 74 00
 ld.s (ix+0), l                 ; 52 FD 75 00
 ld.s (ix+126), a               ; 52 FD 77 7E
 ld.s (ix+126), b               ; 52 FD 70 7E
 ld.s (ix+126), c               ; 52 FD 71 7E
 ld.s (ix+126), d               ; 52 FD 72 7E
 ld.s (ix+126), e               ; 52 FD 73 7E
 ld.s (ix+126), h               ; 52 FD 74 7E
 ld.s (ix+126), l               ; 52 FD 75 7E
 ld.s (ix-128), a               ; 52 FD 77 80
 ld.s (ix-128), b               ; 52 FD 70 80
 ld.s (ix-128), c               ; 52 FD 71 80
 ld.s (ix-128), d               ; 52 FD 72 80
 ld.s (ix-128), e               ; 52 FD 73 80
 ld.s (ix-128), h               ; 52 FD 74 80
 ld.s (ix-128), l               ; 52 FD 75 80
 ld.s (iy), a                   ; 52 DD 77 00
 ld.s (iy), b                   ; 52 DD 70 00
 ld.s (iy), c                   ; 52 DD 71 00
 ld.s (iy), d                   ; 52 DD 72 00
 ld.s (iy), e                   ; 52 DD 73 00
 ld.s (iy), h                   ; 52 DD 74 00
 ld.s (iy), l                   ; 52 DD 75 00
 ld.s (iy+0), a                 ; 52 DD 77 00
 ld.s (iy+0), b                 ; 52 DD 70 00
 ld.s (iy+0), c                 ; 52 DD 71 00
 ld.s (iy+0), d                 ; 52 DD 72 00
 ld.s (iy+0), e                 ; 52 DD 73 00
 ld.s (iy+0), h                 ; 52 DD 74 00
 ld.s (iy+0), l                 ; 52 DD 75 00
 ld.s (iy+126), a               ; 52 DD 77 7E
 ld.s (iy+126), b               ; 52 DD 70 7E
 ld.s (iy+126), c               ; 52 DD 71 7E
 ld.s (iy+126), d               ; 52 DD 72 7E
 ld.s (iy+126), e               ; 52 DD 73 7E
 ld.s (iy+126), h               ; 52 DD 74 7E
 ld.s (iy+126), l               ; 52 DD 75 7E
 ld.s (iy-128), a               ; 52 DD 77 80
 ld.s (iy-128), b               ; 52 DD 70 80
 ld.s (iy-128), c               ; 52 DD 71 80
 ld.s (iy-128), d               ; 52 DD 72 80
 ld.s (iy-128), e               ; 52 DD 73 80
 ld.s (iy-128), h               ; 52 DD 74 80
 ld.s (iy-128), l               ; 52 DD 75 80
 ld.s a, (bc)                   ; 52 0A
 ld.s a, (de)                   ; 52 1A
 ld.s a, (hl)                   ; 52 7E
 ld.s a, (ix)                   ; 52 FD 7E 00
 ld.s a, (ix+0)                 ; 52 FD 7E 00
 ld.s a, (ix+126)               ; 52 FD 7E 7E
 ld.s a, (ix-128)               ; 52 FD 7E 80
 ld.s a, (iy)                   ; 52 DD 7E 00
 ld.s a, (iy+0)                 ; 52 DD 7E 00
 ld.s a, (iy+126)               ; 52 DD 7E 7E
 ld.s a, (iy-128)               ; 52 DD 7E 80
 ld.s b, (hl)                   ; 52 46
 ld.s b, (ix)                   ; 52 FD 46 00
 ld.s b, (ix+0)                 ; 52 FD 46 00
 ld.s b, (ix+126)               ; 52 FD 46 7E
 ld.s b, (ix-128)               ; 52 FD 46 80
 ld.s b, (iy)                   ; 52 DD 46 00
 ld.s b, (iy+0)                 ; 52 DD 46 00
 ld.s b, (iy+126)               ; 52 DD 46 7E
 ld.s b, (iy-128)               ; 52 DD 46 80
 ld.s bc, (hl)                  ; 52 ED 07
 ld.s c, (hl)                   ; 52 4E
 ld.s c, (ix)                   ; 52 FD 4E 00
 ld.s c, (ix+0)                 ; 52 FD 4E 00
 ld.s c, (ix+126)               ; 52 FD 4E 7E
 ld.s c, (ix-128)               ; 52 FD 4E 80
 ld.s c, (iy)                   ; 52 DD 4E 00
 ld.s c, (iy+0)                 ; 52 DD 4E 00
 ld.s c, (iy+126)               ; 52 DD 4E 7E
 ld.s c, (iy-128)               ; 52 DD 4E 80
 ld.s d, (hl)                   ; 52 56
 ld.s d, (ix)                   ; 52 FD 56 00
 ld.s d, (ix+0)                 ; 52 FD 56 00
 ld.s d, (ix+126)               ; 52 FD 56 7E
 ld.s d, (ix-128)               ; 52 FD 56 80
 ld.s d, (iy)                   ; 52 DD 56 00
 ld.s d, (iy+0)                 ; 52 DD 56 00
 ld.s d, (iy+126)               ; 52 DD 56 7E
 ld.s d, (iy-128)               ; 52 DD 56 80
 ld.s de, (hl)                  ; 52 ED 17
 ld.s e, (hl)                   ; 52 5E
 ld.s e, (ix)                   ; 52 FD 5E 00
 ld.s e, (ix+0)                 ; 52 FD 5E 00
 ld.s e, (ix+126)               ; 52 FD 5E 7E
 ld.s e, (ix-128)               ; 52 FD 5E 80
 ld.s e, (iy)                   ; 52 DD 5E 00
 ld.s e, (iy+0)                 ; 52 DD 5E 00
 ld.s e, (iy+126)               ; 52 DD 5E 7E
 ld.s e, (iy-128)               ; 52 DD 5E 80
 ld.s h, (hl)                   ; 52 66
 ld.s h, (ix)                   ; 52 FD 66 00
 ld.s h, (ix+0)                 ; 52 FD 66 00
 ld.s h, (ix+126)               ; 52 FD 66 7E
 ld.s h, (ix-128)               ; 52 FD 66 80
 ld.s h, (iy)                   ; 52 DD 66 00
 ld.s h, (iy+0)                 ; 52 DD 66 00
 ld.s h, (iy+126)               ; 52 DD 66 7E
 ld.s h, (iy-128)               ; 52 DD 66 80
 ld.s hl, (hl)                  ; 52 ED 27
 ld.s ix, (hl)                  ; 52 ED 31
 ld.s ix, (ix)                  ; 52 FD 37 00
 ld.s ix, (ix+0)                ; 52 FD 37 00
 ld.s ix, (ix+126)              ; 52 FD 37 7E
 ld.s ix, (ix-128)              ; 52 FD 37 80
 ld.s ix, (iy)                  ; 52 DD 31 00
 ld.s ix, (iy+0)                ; 52 DD 31 00
 ld.s ix, (iy+126)              ; 52 DD 31 7E
 ld.s ix, (iy-128)              ; 52 DD 31 80
 ld.s iy, (hl)                  ; 52 ED 37
 ld.s iy, (ix)                  ; 52 FD 31 00
 ld.s iy, (ix+0)                ; 52 FD 31 00
 ld.s iy, (ix+126)              ; 52 FD 31 7E
 ld.s iy, (ix-128)              ; 52 FD 31 80
 ld.s iy, (iy)                  ; 52 DD 37 00
 ld.s iy, (iy+0)                ; 52 DD 37 00
 ld.s iy, (iy+126)              ; 52 DD 37 7E
 ld.s iy, (iy-128)              ; 52 DD 37 80
 ld.s l, (hl)                   ; 52 6E
 ld.s l, (ix)                   ; 52 FD 6E 00
 ld.s l, (ix+0)                 ; 52 FD 6E 00
 ld.s l, (ix+126)               ; 52 FD 6E 7E
 ld.s l, (ix-128)               ; 52 FD 6E 80
 ld.s l, (iy)                   ; 52 DD 6E 00
 ld.s l, (iy+0)                 ; 52 DD 6E 00
 ld.s l, (iy+126)               ; 52 DD 6E 7E
 ld.s l, (iy-128)               ; 52 DD 6E 80
 ld.sil (bc), a                 ; 52 02
 ld.sil (de), a                 ; 52 12
 ld.sil (hl), -128              ; 52 36 80
 ld.sil (hl), 0                 ; 52 36 00
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
 ld.sil (hl), ix                ; 52 ED 3E
 ld.sil (hl), iy                ; 52 ED 3F
 ld.sil (hl), l                 ; 52 75
 ld.sil (ix), a                 ; 52 FD 77 00
 ld.sil (ix), b                 ; 52 FD 70 00
 ld.sil (ix), c                 ; 52 FD 71 00
 ld.sil (ix), d                 ; 52 FD 72 00
 ld.sil (ix), e                 ; 52 FD 73 00
 ld.sil (ix), h                 ; 52 FD 74 00
 ld.sil (ix), l                 ; 52 FD 75 00
 ld.sil (ix+0), a               ; 52 FD 77 00
 ld.sil (ix+0), b               ; 52 FD 70 00
 ld.sil (ix+0), c               ; 52 FD 71 00
 ld.sil (ix+0), d               ; 52 FD 72 00
 ld.sil (ix+0), e               ; 52 FD 73 00
 ld.sil (ix+0), h               ; 52 FD 74 00
 ld.sil (ix+0), l               ; 52 FD 75 00
 ld.sil (ix+126), a             ; 52 FD 77 7E
 ld.sil (ix+126), b             ; 52 FD 70 7E
 ld.sil (ix+126), c             ; 52 FD 71 7E
 ld.sil (ix+126), d             ; 52 FD 72 7E
 ld.sil (ix+126), e             ; 52 FD 73 7E
 ld.sil (ix+126), h             ; 52 FD 74 7E
 ld.sil (ix+126), l             ; 52 FD 75 7E
 ld.sil (ix-128), a             ; 52 FD 77 80
 ld.sil (ix-128), b             ; 52 FD 70 80
 ld.sil (ix-128), c             ; 52 FD 71 80
 ld.sil (ix-128), d             ; 52 FD 72 80
 ld.sil (ix-128), e             ; 52 FD 73 80
 ld.sil (ix-128), h             ; 52 FD 74 80
 ld.sil (ix-128), l             ; 52 FD 75 80
 ld.sil (iy), a                 ; 52 DD 77 00
 ld.sil (iy), b                 ; 52 DD 70 00
 ld.sil (iy), c                 ; 52 DD 71 00
 ld.sil (iy), d                 ; 52 DD 72 00
 ld.sil (iy), e                 ; 52 DD 73 00
 ld.sil (iy), h                 ; 52 DD 74 00
 ld.sil (iy), l                 ; 52 DD 75 00
 ld.sil (iy+0), a               ; 52 DD 77 00
 ld.sil (iy+0), b               ; 52 DD 70 00
 ld.sil (iy+0), c               ; 52 DD 71 00
 ld.sil (iy+0), d               ; 52 DD 72 00
 ld.sil (iy+0), e               ; 52 DD 73 00
 ld.sil (iy+0), h               ; 52 DD 74 00
 ld.sil (iy+0), l               ; 52 DD 75 00
 ld.sil (iy+126), a             ; 52 DD 77 7E
 ld.sil (iy+126), b             ; 52 DD 70 7E
 ld.sil (iy+126), c             ; 52 DD 71 7E
 ld.sil (iy+126), d             ; 52 DD 72 7E
 ld.sil (iy+126), e             ; 52 DD 73 7E
 ld.sil (iy+126), h             ; 52 DD 74 7E
 ld.sil (iy+126), l             ; 52 DD 75 7E
 ld.sil (iy-128), a             ; 52 DD 77 80
 ld.sil (iy-128), b             ; 52 DD 70 80
 ld.sil (iy-128), c             ; 52 DD 71 80
 ld.sil (iy-128), d             ; 52 DD 72 80
 ld.sil (iy-128), e             ; 52 DD 73 80
 ld.sil (iy-128), h             ; 52 DD 74 80
 ld.sil (iy-128), l             ; 52 DD 75 80
 ld.sil a, (bc)                 ; 52 0A
 ld.sil a, (de)                 ; 52 1A
 ld.sil a, (hl)                 ; 52 7E
 ld.sil a, (ix)                 ; 52 FD 7E 00
 ld.sil a, (ix+0)               ; 52 FD 7E 00
 ld.sil a, (ix+126)             ; 52 FD 7E 7E
 ld.sil a, (ix-128)             ; 52 FD 7E 80
 ld.sil a, (iy)                 ; 52 DD 7E 00
 ld.sil a, (iy+0)               ; 52 DD 7E 00
 ld.sil a, (iy+126)             ; 52 DD 7E 7E
 ld.sil a, (iy-128)             ; 52 DD 7E 80
 ld.sil b, (hl)                 ; 52 46
 ld.sil b, (ix)                 ; 52 FD 46 00
 ld.sil b, (ix+0)               ; 52 FD 46 00
 ld.sil b, (ix+126)             ; 52 FD 46 7E
 ld.sil b, (ix-128)             ; 52 FD 46 80
 ld.sil b, (iy)                 ; 52 DD 46 00
 ld.sil b, (iy+0)               ; 52 DD 46 00
 ld.sil b, (iy+126)             ; 52 DD 46 7E
 ld.sil b, (iy-128)             ; 52 DD 46 80
 ld.sil bc, (hl)                ; 52 ED 07
 ld.sil c, (hl)                 ; 52 4E
 ld.sil c, (ix)                 ; 52 FD 4E 00
 ld.sil c, (ix+0)               ; 52 FD 4E 00
 ld.sil c, (ix+126)             ; 52 FD 4E 7E
 ld.sil c, (ix-128)             ; 52 FD 4E 80
 ld.sil c, (iy)                 ; 52 DD 4E 00
 ld.sil c, (iy+0)               ; 52 DD 4E 00
 ld.sil c, (iy+126)             ; 52 DD 4E 7E
 ld.sil c, (iy-128)             ; 52 DD 4E 80
 ld.sil d, (hl)                 ; 52 56
 ld.sil d, (ix)                 ; 52 FD 56 00
 ld.sil d, (ix+0)               ; 52 FD 56 00
 ld.sil d, (ix+126)             ; 52 FD 56 7E
 ld.sil d, (ix-128)             ; 52 FD 56 80
 ld.sil d, (iy)                 ; 52 DD 56 00
 ld.sil d, (iy+0)               ; 52 DD 56 00
 ld.sil d, (iy+126)             ; 52 DD 56 7E
 ld.sil d, (iy-128)             ; 52 DD 56 80
 ld.sil de, (hl)                ; 52 ED 17
 ld.sil e, (hl)                 ; 52 5E
 ld.sil e, (ix)                 ; 52 FD 5E 00
 ld.sil e, (ix+0)               ; 52 FD 5E 00
 ld.sil e, (ix+126)             ; 52 FD 5E 7E
 ld.sil e, (ix-128)             ; 52 FD 5E 80
 ld.sil e, (iy)                 ; 52 DD 5E 00
 ld.sil e, (iy+0)               ; 52 DD 5E 00
 ld.sil e, (iy+126)             ; 52 DD 5E 7E
 ld.sil e, (iy-128)             ; 52 DD 5E 80
 ld.sil h, (hl)                 ; 52 66
 ld.sil h, (ix)                 ; 52 FD 66 00
 ld.sil h, (ix+0)               ; 52 FD 66 00
 ld.sil h, (ix+126)             ; 52 FD 66 7E
 ld.sil h, (ix-128)             ; 52 FD 66 80
 ld.sil h, (iy)                 ; 52 DD 66 00
 ld.sil h, (iy+0)               ; 52 DD 66 00
 ld.sil h, (iy+126)             ; 52 DD 66 7E
 ld.sil h, (iy-128)             ; 52 DD 66 80
 ld.sil hl, (hl)                ; 52 ED 27
 ld.sil ix, (hl)                ; 52 ED 31
 ld.sil ix, (ix)                ; 52 FD 37 00
 ld.sil ix, (ix+0)              ; 52 FD 37 00
 ld.sil ix, (ix+126)            ; 52 FD 37 7E
 ld.sil ix, (ix-128)            ; 52 FD 37 80
 ld.sil ix, (iy)                ; 52 DD 31 00
 ld.sil ix, (iy+0)              ; 52 DD 31 00
 ld.sil ix, (iy+126)            ; 52 DD 31 7E
 ld.sil ix, (iy-128)            ; 52 DD 31 80
 ld.sil iy, (hl)                ; 52 ED 37
 ld.sil iy, (ix)                ; 52 FD 31 00
 ld.sil iy, (ix+0)              ; 52 FD 31 00
 ld.sil iy, (ix+126)            ; 52 FD 31 7E
 ld.sil iy, (ix-128)            ; 52 FD 31 80
 ld.sil iy, (iy)                ; 52 DD 37 00
 ld.sil iy, (iy+0)              ; 52 DD 37 00
 ld.sil iy, (iy+126)            ; 52 DD 37 7E
 ld.sil iy, (iy-128)            ; 52 DD 37 80
 ld.sil l, (hl)                 ; 52 6E
 ld.sil l, (ix)                 ; 52 FD 6E 00
 ld.sil l, (ix+0)               ; 52 FD 6E 00
 ld.sil l, (ix+126)             ; 52 FD 6E 7E
 ld.sil l, (ix-128)             ; 52 FD 6E 80
 ld.sil l, (iy)                 ; 52 DD 6E 00
 ld.sil l, (iy+0)               ; 52 DD 6E 00
 ld.sil l, (iy+126)             ; 52 DD 6E 7E
 ld.sil l, (iy-128)             ; 52 DD 6E 80
 ld.sis (0x1234), a             ; 40 32 34 12
 ld.sis a, (0x1234)             ; 40 3A 34 12
 ld.sis bc, 0x1234              ; 40 01 34 12
 ld.sis de, 0x1234              ; 40 11 34 12
 ld.sis hl, 0x1234              ; 40 21 34 12
 ld.sis ix, 0x1234              ; 40 FD 21 34 12
 ld.sis iy, 0x1234              ; 40 DD 21 34 12
 ld.sis sp, 0x1234              ; 40 31 34 12
 or (hl)                        ; B6
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
 or.s (ix)                      ; 52 FD B6 00
 or.s (ix+0)                    ; 52 FD B6 00
 or.s (ix+126)                  ; 52 FD B6 7E
 or.s (ix-128)                  ; 52 FD B6 80
 or.s (iy)                      ; 52 DD B6 00
 or.s (iy+0)                    ; 52 DD B6 00
 or.s (iy+126)                  ; 52 DD B6 7E
 or.s (iy-128)                  ; 52 DD B6 80
 or.sil (hl)                    ; 52 B6
 or.sil (ix)                    ; 52 FD B6 00
 or.sil (ix+0)                  ; 52 FD B6 00
 or.sil (ix+126)                ; 52 FD B6 7E
 or.sil (ix-128)                ; 52 FD B6 80
 or.sil (iy)                    ; 52 DD B6 00
 or.sil (iy+0)                  ; 52 DD B6 00
 or.sil (iy+126)                ; 52 DD B6 7E
 or.sil (iy-128)                ; 52 DD B6 80
 otdr                           ; ED BB
 otdr.s                         ; 52 ED BB
 otdr.sil                       ; 52 ED BB
 otir                           ; ED B3
 otir.s                         ; 52 ED B3
 otir.sil                       ; 52 ED B3
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
 outd.s                         ; 52 ED AB
 outd.sil                       ; 52 ED AB
 outi                           ; ED A3
 outi.s                         ; 52 ED A3
 outi.sil                       ; 52 ED A3
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
 sbc a, (hl)                    ; 9E
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
 sbc hl, bc                     ; ED 42
 sbc hl, de                     ; ED 52
 sbc hl, hl                     ; ED 62
 sbc hl, sp                     ; ED 72
 sbc.s a, (hl)                  ; 52 9E
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
 sbc.sil a, (hl)                ; 52 9E
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
 sub (hl)                       ; 96
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
 sub b                          ; 90
 sub c                          ; 91
 sub d                          ; 92
 sub e                          ; 93
 sub h                          ; 94
 sub ixh                        ; FD 94
 sub ixl                        ; FD 95
 sub iyh                        ; DD 94
 sub iyl                        ; DD 95
 sub l                          ; 95
 sub.s (hl)                     ; 52 96
 sub.s (ix)                     ; 52 FD 96 00
 sub.s (ix+0)                   ; 52 FD 96 00
 sub.s (ix+126)                 ; 52 FD 96 7E
 sub.s (ix-128)                 ; 52 FD 96 80
 sub.s (iy)                     ; 52 DD 96 00
 sub.s (iy+0)                   ; 52 DD 96 00
 sub.s (iy+126)                 ; 52 DD 96 7E
 sub.s (iy-128)                 ; 52 DD 96 80
 sub.sil (hl)                   ; 52 96
 sub.sil (ix)                   ; 52 FD 96 00
 sub.sil (ix+0)                 ; 52 FD 96 00
 sub.sil (ix+126)               ; 52 FD 96 7E
 sub.sil (ix-128)               ; 52 FD 96 80
 sub.sil (iy)                   ; 52 DD 96 00
 sub.sil (iy+0)                 ; 52 DD 96 00
 sub.sil (iy+126)               ; 52 DD 96 7E
 sub.sil (iy-128)               ; 52 DD 96 80
 xor (hl)                       ; AE
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
 xor.s (ix)                     ; 52 FD AE 00
 xor.s (ix+0)                   ; 52 FD AE 00
 xor.s (ix+126)                 ; 52 FD AE 7E
 xor.s (ix-128)                 ; 52 FD AE 80
 xor.s (iy)                     ; 52 DD AE 00
 xor.s (iy+0)                   ; 52 DD AE 00
 xor.s (iy+126)                 ; 52 DD AE 7E
 xor.s (iy-128)                 ; 52 DD AE 80
 xor.sil (hl)                   ; 52 AE
 xor.sil (ix)                   ; 52 FD AE 00
 xor.sil (ix+0)                 ; 52 FD AE 00
 xor.sil (ix+126)               ; 52 FD AE 7E
 xor.sil (ix-128)               ; 52 FD AE 80
 xor.sil (iy)                   ; 52 DD AE 00
 xor.sil (iy+0)                 ; 52 DD AE 00
 xor.sil (iy+126)               ; 52 DD AE 7E
 xor.sil (iy-128)               ; 52 DD AE 80
