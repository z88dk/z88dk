 adc a, (hl)                    ; 8E
 adc a, ixh                     ; DD 8C
 adc a, ixl                     ; DD 8D
 adc a, iyh                     ; FD 8C
 adc a, iyl                     ; FD 8D
 adc.l a, (hl)                  ; 49 8E
 add a, (hl)                    ; 86
 add a, ixh                     ; DD 84
 add a, ixl                     ; DD 85
 add a, iyh                     ; FD 84
 add a, iyl                     ; FD 85
 add.l a, (hl)                  ; 49 86
 and (hl)                       ; A6
 and ixh                        ; DD A4
 and ixl                        ; DD A5
 and iyh                        ; FD A4
 and iyl                        ; FD A5
 and.l (hl)                     ; 49 A6
 cp (hl)                        ; BE
 cp ixh                         ; DD BC
 cp ixl                         ; DD BD
 cp iyh                         ; FD BC
 cp iyl                         ; FD BD
 cp.l (hl)                      ; 49 BE
 dec bc                         ; 0B
 dec de                         ; 1B
 dec hl                         ; 2B
 dec sp                         ; 3B
 dec.l bc                       ; 49 0B
 dec.l de                       ; 49 1B
 dec.l hl                       ; 49 2B
 dec.l sp                       ; 49 3B
 inc bc                         ; 03
 inc de                         ; 13
 inc hl                         ; 23
 inc sp                         ; 33
 inc.l bc                       ; 49 03
 inc.l de                       ; 49 13
 inc.l hl                       ; 49 23
 inc.l sp                       ; 49 33
 or (hl)                        ; B6
 or ixh                         ; DD B4
 or ixl                         ; DD B5
 or iyh                         ; FD B4
 or iyl                         ; FD B5
 or.l (hl)                      ; 49 B6
 sbc a, (hl)                    ; 9E
 sbc a, ixh                     ; DD 9C
 sbc a, ixl                     ; DD 9D
 sbc a, iyh                     ; FD 9C
 sbc a, iyl                     ; FD 9D
 sbc.l a, (hl)                  ; 49 9E
 sub (hl)                       ; 96
 sub ixh                        ; DD 94
 sub ixl                        ; DD 95
 sub iyh                        ; FD 94
 sub iyl                        ; FD 95
 sub.l (hl)                     ; 49 96
 xor (hl)                       ; AE
 xor ixh                        ; DD AC
 xor ixl                        ; DD AD
 xor iyh                        ; FD AC
 xor iyl                        ; FD AD
 xor.l (hl)                     ; 49 AE
