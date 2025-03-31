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
 adc.l a, (hl)                  ; 49 8E
 adc.l a, (ix)                  ; 49 DD 8E 00
 adc.l a, (ix+0)                ; 49 DD 8E 00
 adc.l a, (ix+126)              ; 49 DD 8E 7E
 adc.l a, (ix-128)              ; 49 DD 8E 80
 adc.l a, (iy)                  ; 49 FD 8E 00
 adc.l a, (iy+0)                ; 49 FD 8E 00
 adc.l a, (iy+126)              ; 49 FD 8E 7E
 adc.l a, (iy-128)              ; 49 FD 8E 80
 adc.lis a, (hl)                ; 49 8E
 adc.lis a, (ix)                ; 49 DD 8E 00
 adc.lis a, (ix+0)              ; 49 DD 8E 00
 adc.lis a, (ix+126)            ; 49 DD 8E 7E
 adc.lis a, (ix-128)            ; 49 DD 8E 80
 adc.lis a, (iy)                ; 49 FD 8E 00
 adc.lis a, (iy+0)              ; 49 FD 8E 00
 adc.lis a, (iy+126)            ; 49 FD 8E 7E
 adc.lis a, (iy-128)            ; 49 FD 8E 80
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
 add.l a, (hl)                  ; 49 86
 add.l a, (ix)                  ; 49 DD 86 00
 add.l a, (ix+0)                ; 49 DD 86 00
 add.l a, (ix+126)              ; 49 DD 86 7E
 add.l a, (ix-128)              ; 49 DD 86 80
 add.l a, (iy)                  ; 49 FD 86 00
 add.l a, (iy+0)                ; 49 FD 86 00
 add.l a, (iy+126)              ; 49 FD 86 7E
 add.l a, (iy-128)              ; 49 FD 86 80
 add.lis a, (hl)                ; 49 86
 add.lis a, (ix)                ; 49 DD 86 00
 add.lis a, (ix+0)              ; 49 DD 86 00
 add.lis a, (ix+126)            ; 49 DD 86 7E
 add.lis a, (ix-128)            ; 49 DD 86 80
 add.lis a, (iy)                ; 49 FD 86 00
 add.lis a, (iy+0)              ; 49 FD 86 00
 add.lis a, (iy+126)            ; 49 FD 86 7E
 add.lis a, (iy-128)            ; 49 FD 86 80
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
 and.l (hl)                     ; 49 A6
 and.l (ix)                     ; 49 DD A6 00
 and.l (ix+0)                   ; 49 DD A6 00
 and.l (ix+126)                 ; 49 DD A6 7E
 and.l (ix-128)                 ; 49 DD A6 80
 and.l (iy)                     ; 49 FD A6 00
 and.l (iy+0)                   ; 49 FD A6 00
 and.l (iy+126)                 ; 49 FD A6 7E
 and.l (iy-128)                 ; 49 FD A6 80
 and.lis (hl)                   ; 49 A6
 and.lis (ix)                   ; 49 DD A6 00
 and.lis (ix+0)                 ; 49 DD A6 00
 and.lis (ix+126)               ; 49 DD A6 7E
 and.lis (ix-128)               ; 49 DD A6 80
 and.lis (iy)                   ; 49 FD A6 00
 and.lis (iy+0)                 ; 49 FD A6 00
 and.lis (iy+126)               ; 49 FD A6 7E
 and.lis (iy-128)               ; 49 FD A6 80
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
 cp.l (hl)                      ; 49 BE
 cp.l (ix)                      ; 49 DD BE 00
 cp.l (ix+0)                    ; 49 DD BE 00
 cp.l (ix+126)                  ; 49 DD BE 7E
 cp.l (ix-128)                  ; 49 DD BE 80
 cp.l (iy)                      ; 49 FD BE 00
 cp.l (iy+0)                    ; 49 FD BE 00
 cp.l (iy+126)                  ; 49 FD BE 7E
 cp.l (iy-128)                  ; 49 FD BE 80
 cp.lis (hl)                    ; 49 BE
 cp.lis (ix)                    ; 49 DD BE 00
 cp.lis (ix+0)                  ; 49 DD BE 00
 cp.lis (ix+126)                ; 49 DD BE 7E
 cp.lis (ix-128)                ; 49 DD BE 80
 cp.lis (iy)                    ; 49 FD BE 00
 cp.lis (iy+0)                  ; 49 FD BE 00
 cp.lis (iy+126)                ; 49 FD BE 7E
 cp.lis (iy-128)                ; 49 FD BE 80
 dec bc                         ; 0B
 dec de                         ; 1B
 dec hl                         ; 2B
 dec sp                         ; 3B
 dec.l bc                       ; 49 0B
 dec.l de                       ; 49 1B
 dec.l hl                       ; 49 2B
 dec.l sp                       ; 49 3B
 dec.lis bc                     ; 49 0B
 dec.lis de                     ; 49 1B
 dec.lis hl                     ; 49 2B
 dec.lis sp                     ; 49 3B
 inc bc                         ; 03
 inc de                         ; 13
 inc hl                         ; 23
 inc sp                         ; 33
 inc.l bc                       ; 49 03
 inc.l de                       ; 49 13
 inc.l hl                       ; 49 23
 inc.l sp                       ; 49 33
 inc.lis bc                     ; 49 03
 inc.lis de                     ; 49 13
 inc.lis hl                     ; 49 23
 inc.lis sp                     ; 49 33
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
 or.l (hl)                      ; 49 B6
 or.l (ix)                      ; 49 DD B6 00
 or.l (ix+0)                    ; 49 DD B6 00
 or.l (ix+126)                  ; 49 DD B6 7E
 or.l (ix-128)                  ; 49 DD B6 80
 or.l (iy)                      ; 49 FD B6 00
 or.l (iy+0)                    ; 49 FD B6 00
 or.l (iy+126)                  ; 49 FD B6 7E
 or.l (iy-128)                  ; 49 FD B6 80
 or.lis (hl)                    ; 49 B6
 or.lis (ix)                    ; 49 DD B6 00
 or.lis (ix+0)                  ; 49 DD B6 00
 or.lis (ix+126)                ; 49 DD B6 7E
 or.lis (ix-128)                ; 49 DD B6 80
 or.lis (iy)                    ; 49 FD B6 00
 or.lis (iy+0)                  ; 49 FD B6 00
 or.lis (iy+126)                ; 49 FD B6 7E
 or.lis (iy-128)                ; 49 FD B6 80
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
 sbc.l a, (hl)                  ; 49 9E
 sbc.l a, (ix)                  ; 49 DD 9E 00
 sbc.l a, (ix+0)                ; 49 DD 9E 00
 sbc.l a, (ix+126)              ; 49 DD 9E 7E
 sbc.l a, (ix-128)              ; 49 DD 9E 80
 sbc.l a, (iy)                  ; 49 FD 9E 00
 sbc.l a, (iy+0)                ; 49 FD 9E 00
 sbc.l a, (iy+126)              ; 49 FD 9E 7E
 sbc.l a, (iy-128)              ; 49 FD 9E 80
 sbc.lis a, (hl)                ; 49 9E
 sbc.lis a, (ix)                ; 49 DD 9E 00
 sbc.lis a, (ix+0)              ; 49 DD 9E 00
 sbc.lis a, (ix+126)            ; 49 DD 9E 7E
 sbc.lis a, (ix-128)            ; 49 DD 9E 80
 sbc.lis a, (iy)                ; 49 FD 9E 00
 sbc.lis a, (iy+0)              ; 49 FD 9E 00
 sbc.lis a, (iy+126)            ; 49 FD 9E 7E
 sbc.lis a, (iy-128)            ; 49 FD 9E 80
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
 sub.l (hl)                     ; 49 96
 sub.l (ix)                     ; 49 DD 96 00
 sub.l (ix+0)                   ; 49 DD 96 00
 sub.l (ix+126)                 ; 49 DD 96 7E
 sub.l (ix-128)                 ; 49 DD 96 80
 sub.l (iy)                     ; 49 FD 96 00
 sub.l (iy+0)                   ; 49 FD 96 00
 sub.l (iy+126)                 ; 49 FD 96 7E
 sub.l (iy-128)                 ; 49 FD 96 80
 sub.lis (hl)                   ; 49 96
 sub.lis (ix)                   ; 49 DD 96 00
 sub.lis (ix+0)                 ; 49 DD 96 00
 sub.lis (ix+126)               ; 49 DD 96 7E
 sub.lis (ix-128)               ; 49 DD 96 80
 sub.lis (iy)                   ; 49 FD 96 00
 sub.lis (iy+0)                 ; 49 FD 96 00
 sub.lis (iy+126)               ; 49 FD 96 7E
 sub.lis (iy-128)               ; 49 FD 96 80
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
 xor.l (hl)                     ; 49 AE
 xor.l (ix)                     ; 49 DD AE 00
 xor.l (ix+0)                   ; 49 DD AE 00
 xor.l (ix+126)                 ; 49 DD AE 7E
 xor.l (ix-128)                 ; 49 DD AE 80
 xor.l (iy)                     ; 49 FD AE 00
 xor.l (iy+0)                   ; 49 FD AE 00
 xor.l (iy+126)                 ; 49 FD AE 7E
 xor.l (iy-128)                 ; 49 FD AE 80
 xor.lis (hl)                   ; 49 AE
 xor.lis (ix)                   ; 49 DD AE 00
 xor.lis (ix+0)                 ; 49 DD AE 00
 xor.lis (ix+126)               ; 49 DD AE 7E
 xor.lis (ix-128)               ; 49 DD AE 80
 xor.lis (iy)                   ; 49 FD AE 00
 xor.lis (iy+0)                 ; 49 FD AE 00
 xor.lis (iy+126)               ; 49 FD AE 7E
 xor.lis (iy-128)               ; 49 FD AE 80
