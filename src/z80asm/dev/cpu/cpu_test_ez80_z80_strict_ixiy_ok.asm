 adc a, (hl)                    ; 8E
 adc a, ixh                     ; FD 8C
 adc a, ixl                     ; FD 8D
 adc a, iyh                     ; DD 8C
 adc a, iyl                     ; DD 8D
 adc.l a, (hl)                  ; 49 8E
 add a, (hl)                    ; 86
 add a, ixh                     ; FD 84
 add a, ixl                     ; FD 85
 add a, iyh                     ; DD 84
 add a, iyl                     ; DD 85
 add.l a, (hl)                  ; 49 86
 and (hl)                       ; A6
 and ixh                        ; FD A4
 and ixl                        ; FD A5
 and iyh                        ; DD A4
 and iyl                        ; DD A5
 and.l (hl)                     ; 49 A6
 cp (hl)                        ; BE
 cp ixh                         ; FD BC
 cp ixl                         ; FD BD
 cp iyh                         ; DD BC
 cp iyl                         ; DD BD
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
 or ixh                         ; FD B4
 or ixl                         ; FD B5
 or iyh                         ; DD B4
 or iyl                         ; DD B5
 or.l (hl)                      ; 49 B6
 sbc a, (hl)                    ; 9E
 sbc a, ixh                     ; FD 9C
 sbc a, ixl                     ; FD 9D
 sbc a, iyh                     ; DD 9C
 sbc a, iyl                     ; DD 9D
 sbc.l a, (hl)                  ; 49 9E
 sub (hl)                       ; 96
 sub ixh                        ; FD 94
 sub ixl                        ; FD 95
 sub iyh                        ; DD 94
 sub iyl                        ; DD 95
 sub.l (hl)                     ; 49 96
 xor (hl)                       ; AE
 xor ixh                        ; FD AC
 xor ixl                        ; FD AD
 xor iyh                        ; DD AC
 xor iyl                        ; DD AD
 xor.l (hl)                     ; 49 AE
