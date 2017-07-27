 add a, ixh                     ; DD 84
 add ixh                        ; DD 84
 add a, iyh                     ; FD 84
 add iyh                        ; FD 84
 add a, ixl                     ; DD 85
 add ixl                        ; DD 85
 add a, iyl                     ; FD 85
 add iyl                        ; FD 85
 adc a, ixh                     ; DD 8C
 adc ixh                        ; DD 8C
 adc a, iyh                     ; FD 8C
 adc iyh                        ; FD 8C
 adc a, ixl                     ; DD 8D
 adc ixl                        ; DD 8D
 adc a, iyl                     ; FD 8D
 adc iyl                        ; FD 8D
 sub a, ixh                     ; DD 94
 sub ixh                        ; DD 94
 sub a, iyh                     ; FD 94
 sub iyh                        ; FD 94
 sub a, ixl                     ; DD 95
 sub ixl                        ; DD 95
 sub a, iyl                     ; FD 95
 sub iyl                        ; FD 95
 sbc a, ixh                     ; DD 9C
 sbc ixh                        ; DD 9C
 sbc a, iyh                     ; FD 9C
 sbc iyh                        ; FD 9C
 sbc a, ixl                     ; DD 9D
 sbc ixl                        ; DD 9D
 sbc a, iyl                     ; FD 9D
 sbc iyl                        ; FD 9D
 and a, ixh                     ; DD A4
 and ixh                        ; DD A4
 and a, iyh                     ; FD A4
 and iyh                        ; FD A4
 and a, ixl                     ; DD A5
 and ixl                        ; DD A5
 and a, iyl                     ; FD A5
 and iyl                        ; FD A5
 xor a, ixh                     ; DD AC
 xor ixh                        ; DD AC
 xor a, iyh                     ; FD AC
 xor iyh                        ; FD AC
 xor a, ixl                     ; DD AD
 xor ixl                        ; DD AD
 xor a, iyl                     ; FD AD
 xor iyl                        ; FD AD
 or a, ixh                      ; DD B4
 or ixh                         ; DD B4
 or a, iyh                      ; FD B4
 or iyh                         ; FD B4
 or a, ixl                      ; DD B5
 or ixl                         ; DD B5
 or a, iyl                      ; FD B5
 or iyl                         ; FD B5
 cp a, ixh                      ; DD BC
 cp ixh                         ; DD BC
 cp a, iyh                      ; FD BC
 cp iyh                         ; FD BC
 cp a, ixl                      ; DD BD
 cp ixl                         ; DD BD
 cp a, iyl                      ; FD BD
 cp iyl                         ; FD BD
 inc ixh                        ; DD 24
 inc iyh                        ; FD 24
 inc ixl                        ; DD 2C
 inc iyl                        ; FD 2C
 dec ixh                        ; DD 25
 dec iyh                        ; FD 25
 dec ixl                        ; DD 2D
 dec iyl                        ; FD 2D
 daa                            ; 27
 rrd                            ; ED 67
 rld                            ; ED 6F
 push su                        ; ED 66
 pop su                         ; ED 6E
