 adc a, (hl)                    ; 8E
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
 adc.s a, (hl)                  ; 52 8E
 adc.s a, (ix)                  ; 52 DD 8E 00
 adc.s a, (ix+0)                ; 52 DD 8E 00
 adc.s a, (ix+126)              ; 52 DD 8E 7E
 adc.s a, (ix-128)              ; 52 DD 8E 80
 adc.s a, (iy)                  ; 52 FD 8E 00
 adc.s a, (iy+0)                ; 52 FD 8E 00
 adc.s a, (iy+126)              ; 52 FD 8E 7E
 adc.s a, (iy-128)              ; 52 FD 8E 80
 adc.sil a, (hl)                ; 52 8E
 adc.sil a, (ix)                ; 52 DD 8E 00
 adc.sil a, (ix+0)              ; 52 DD 8E 00
 adc.sil a, (ix+126)            ; 52 DD 8E 7E
 adc.sil a, (ix-128)            ; 52 DD 8E 80
 adc.sil a, (iy)                ; 52 FD 8E 00
 adc.sil a, (iy+0)              ; 52 FD 8E 00
 adc.sil a, (iy+126)            ; 52 FD 8E 7E
 adc.sil a, (iy-128)            ; 52 FD 8E 80
 add a, (hl)                    ; 86
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
 add.s a, (hl)                  ; 52 86
 add.s a, (ix)                  ; 52 DD 86 00
 add.s a, (ix+0)                ; 52 DD 86 00
 add.s a, (ix+126)              ; 52 DD 86 7E
 add.s a, (ix-128)              ; 52 DD 86 80
 add.s a, (iy)                  ; 52 FD 86 00
 add.s a, (iy+0)                ; 52 FD 86 00
 add.s a, (iy+126)              ; 52 FD 86 7E
 add.s a, (iy-128)              ; 52 FD 86 80
 add.sil a, (hl)                ; 52 86
 add.sil a, (ix)                ; 52 DD 86 00
 add.sil a, (ix+0)              ; 52 DD 86 00
 add.sil a, (ix+126)            ; 52 DD 86 7E
 add.sil a, (ix-128)            ; 52 DD 86 80
 add.sil a, (iy)                ; 52 FD 86 00
 add.sil a, (iy+0)              ; 52 FD 86 00
 add.sil a, (iy+126)            ; 52 FD 86 7E
 add.sil a, (iy-128)            ; 52 FD 86 80
 and (hl)                       ; A6
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
 and.s (hl)                     ; 52 A6
 and.s (ix)                     ; 52 DD A6 00
 and.s (ix+0)                   ; 52 DD A6 00
 and.s (ix+126)                 ; 52 DD A6 7E
 and.s (ix-128)                 ; 52 DD A6 80
 and.s (iy)                     ; 52 FD A6 00
 and.s (iy+0)                   ; 52 FD A6 00
 and.s (iy+126)                 ; 52 FD A6 7E
 and.s (iy-128)                 ; 52 FD A6 80
 and.sil (hl)                   ; 52 A6
 and.sil (ix)                   ; 52 DD A6 00
 and.sil (ix+0)                 ; 52 DD A6 00
 and.sil (ix+126)               ; 52 DD A6 7E
 and.sil (ix-128)               ; 52 DD A6 80
 and.sil (iy)                   ; 52 FD A6 00
 and.sil (iy+0)                 ; 52 FD A6 00
 and.sil (iy+126)               ; 52 FD A6 7E
 and.sil (iy-128)               ; 52 FD A6 80
 cp (hl)                        ; BE
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
 cp.s (hl)                      ; 52 BE
 cp.s (ix)                      ; 52 DD BE 00
 cp.s (ix+0)                    ; 52 DD BE 00
 cp.s (ix+126)                  ; 52 DD BE 7E
 cp.s (ix-128)                  ; 52 DD BE 80
 cp.s (iy)                      ; 52 FD BE 00
 cp.s (iy+0)                    ; 52 FD BE 00
 cp.s (iy+126)                  ; 52 FD BE 7E
 cp.s (iy-128)                  ; 52 FD BE 80
 cp.sil (hl)                    ; 52 BE
 cp.sil (ix)                    ; 52 DD BE 00
 cp.sil (ix+0)                  ; 52 DD BE 00
 cp.sil (ix+126)                ; 52 DD BE 7E
 cp.sil (ix-128)                ; 52 DD BE 80
 cp.sil (iy)                    ; 52 FD BE 00
 cp.sil (iy+0)                  ; 52 FD BE 00
 cp.sil (iy+126)                ; 52 FD BE 7E
 cp.sil (iy-128)                ; 52 FD BE 80
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
 or (hl)                        ; B6
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
 or.s (hl)                      ; 52 B6
 or.s (ix)                      ; 52 DD B6 00
 or.s (ix+0)                    ; 52 DD B6 00
 or.s (ix+126)                  ; 52 DD B6 7E
 or.s (ix-128)                  ; 52 DD B6 80
 or.s (iy)                      ; 52 FD B6 00
 or.s (iy+0)                    ; 52 FD B6 00
 or.s (iy+126)                  ; 52 FD B6 7E
 or.s (iy-128)                  ; 52 FD B6 80
 or.sil (hl)                    ; 52 B6
 or.sil (ix)                    ; 52 DD B6 00
 or.sil (ix+0)                  ; 52 DD B6 00
 or.sil (ix+126)                ; 52 DD B6 7E
 or.sil (ix-128)                ; 52 DD B6 80
 or.sil (iy)                    ; 52 FD B6 00
 or.sil (iy+0)                  ; 52 FD B6 00
 or.sil (iy+126)                ; 52 FD B6 7E
 or.sil (iy-128)                ; 52 FD B6 80
 sbc a, (hl)                    ; 9E
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
 sbc.s a, (hl)                  ; 52 9E
 sbc.s a, (ix)                  ; 52 DD 9E 00
 sbc.s a, (ix+0)                ; 52 DD 9E 00
 sbc.s a, (ix+126)              ; 52 DD 9E 7E
 sbc.s a, (ix-128)              ; 52 DD 9E 80
 sbc.s a, (iy)                  ; 52 FD 9E 00
 sbc.s a, (iy+0)                ; 52 FD 9E 00
 sbc.s a, (iy+126)              ; 52 FD 9E 7E
 sbc.s a, (iy-128)              ; 52 FD 9E 80
 sbc.sil a, (hl)                ; 52 9E
 sbc.sil a, (ix)                ; 52 DD 9E 00
 sbc.sil a, (ix+0)              ; 52 DD 9E 00
 sbc.sil a, (ix+126)            ; 52 DD 9E 7E
 sbc.sil a, (ix-128)            ; 52 DD 9E 80
 sbc.sil a, (iy)                ; 52 FD 9E 00
 sbc.sil a, (iy+0)              ; 52 FD 9E 00
 sbc.sil a, (iy+126)            ; 52 FD 9E 7E
 sbc.sil a, (iy-128)            ; 52 FD 9E 80
 sub (hl)                       ; 96
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
 sub b                          ; 90
 sub c                          ; 91
 sub d                          ; 92
 sub e                          ; 93
 sub h                          ; 94
 sub ixh                        ; DD 94
 sub ixl                        ; DD 95
 sub iyh                        ; FD 94
 sub iyl                        ; FD 95
 sub l                          ; 95
 sub.s (hl)                     ; 52 96
 sub.s (ix)                     ; 52 DD 96 00
 sub.s (ix+0)                   ; 52 DD 96 00
 sub.s (ix+126)                 ; 52 DD 96 7E
 sub.s (ix-128)                 ; 52 DD 96 80
 sub.s (iy)                     ; 52 FD 96 00
 sub.s (iy+0)                   ; 52 FD 96 00
 sub.s (iy+126)                 ; 52 FD 96 7E
 sub.s (iy-128)                 ; 52 FD 96 80
 sub.sil (hl)                   ; 52 96
 sub.sil (ix)                   ; 52 DD 96 00
 sub.sil (ix+0)                 ; 52 DD 96 00
 sub.sil (ix+126)               ; 52 DD 96 7E
 sub.sil (ix-128)               ; 52 DD 96 80
 sub.sil (iy)                   ; 52 FD 96 00
 sub.sil (iy+0)                 ; 52 FD 96 00
 sub.sil (iy+126)               ; 52 FD 96 7E
 sub.sil (iy-128)               ; 52 FD 96 80
 xor (hl)                       ; AE
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
 xor.s (hl)                     ; 52 AE
 xor.s (ix)                     ; 52 DD AE 00
 xor.s (ix+0)                   ; 52 DD AE 00
 xor.s (ix+126)                 ; 52 DD AE 7E
 xor.s (ix-128)                 ; 52 DD AE 80
 xor.s (iy)                     ; 52 FD AE 00
 xor.s (iy+0)                   ; 52 FD AE 00
 xor.s (iy+126)                 ; 52 FD AE 7E
 xor.s (iy-128)                 ; 52 FD AE 80
 xor.sil (hl)                   ; 52 AE
 xor.sil (ix)                   ; 52 DD AE 00
 xor.sil (ix+0)                 ; 52 DD AE 00
 xor.sil (ix+126)               ; 52 DD AE 7E
 xor.sil (ix-128)               ; 52 DD AE 80
 xor.sil (iy)                   ; 52 FD AE 00
 xor.sil (iy+0)                 ; 52 FD AE 00
 xor.sil (iy+126)               ; 52 FD AE 7E
 xor.sil (iy-128)               ; 52 FD AE 80
