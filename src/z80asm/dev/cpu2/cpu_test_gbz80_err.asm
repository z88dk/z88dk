 adi hl, -128                   ; Error
 adi hl, 127                    ; Error
 adi hl, 255                    ; Error
 adi sp, -128                   ; Error
 adi sp, 127                    ; Error
 adi sp, 255                    ; Error
 arhl                           ; Error
 call m, -32768                 ; Error
 call m, 32767                  ; Error
 call m, 65535                  ; Error
 call p, -32768                 ; Error
 call p, 32767                  ; Error
 call p, 65535                  ; Error
 call pe, -32768                ; Error
 call pe, 32767                 ; Error
 call pe, 65535                 ; Error
 call po, -32768                ; Error
 call po, 32767                 ; Error
 call po, 65535                 ; Error
 cm -32768                      ; Error
 cm 32767                       ; Error
 cm 65535                       ; Error
 cp -32768                      ; Error
 cp 32767                       ; Error
 cp 65535                       ; Error
 cpe -32768                     ; Error
 cpe 32767                      ; Error
 cpe 65535                      ; Error
 cpo -32768                     ; Error
 cpo 32767                      ; Error
 cpo 65535                      ; Error
 dsub                           ; Error
 ex (sp), hl                    ; Error
 ex de, hl                      ; Error
 in -128                        ; Error
 in 127                         ; Error
 in 255                         ; Error
 in a, (-128)                   ; Error
 in a, (127)                    ; Error
 in a, (255)                    ; Error
 jk -32768                      ; Error
 jk 32767                       ; Error
 jk 65535                       ; Error
 jm -32768                      ; Error
 jm 32767                       ; Error
 jm 65535                       ; Error
 jnk -32768                     ; Error
 jnk 32767                      ; Error
 jnk 65535                      ; Error
 jnx5 -32768                    ; Error
 jnx5 32767                     ; Error
 jnx5 65535                     ; Error
 jpe -32768                     ; Error
 jpe 32767                      ; Error
 jpe 65535                      ; Error
 jpo -32768                     ; Error
 jpo 32767                      ; Error
 jpo 65535                      ; Error
 jx5 -32768                     ; Error
 jx5 32767                      ; Error
 jx5 65535                      ; Error
 ld (-32768), hl                ; Error
 ld (32767), hl                 ; Error
 ld (65535), hl                 ; Error
 ld (de), hl                    ; Error
 ld de, hl+-128                 ; Error
 ld de, hl+127                  ; Error
 ld de, hl+255                  ; Error
 ld de, sp+-128                 ; Error
 ld de, sp+127                  ; Error
 ld de, sp+255                  ; Error
 ld hl, (-32768)                ; Error
 ld hl, (32767)                 ; Error
 ld hl, (65535)                 ; Error
 ld hl, (de)                    ; Error
 ldhi -128                      ; Error
 ldhi 127                       ; Error
 ldhi 255                       ; Error
 ldsi -128                      ; Error
 ldsi 127                       ; Error
 ldsi 255                       ; Error
 lhld -32768                    ; Error
 lhld 32767                     ; Error
 lhld 65535                     ; Error
 lhlde                          ; Error
 lhlx                           ; Error
 out (-128), a                  ; Error
 out (127), a                   ; Error
 out (255), a                   ; Error
 out -128                       ; Error
 out 127                        ; Error
 out 255                        ; Error
 ovrst8                         ; Error
 rdel                           ; Error
 ret m                          ; Error
 ret p                          ; Error
 ret pe                         ; Error
 ret po                         ; Error
 rim                            ; Error
 rl de                          ; Error
 rlde                           ; Error
 rm                             ; Error
 rp                             ; Error
 rpe                            ; Error
 rpo                            ; Error
 rrhl                           ; Error
 rstv                           ; Error
 shld -32768                    ; Error
 shld 32767                     ; Error
 shld 65535                     ; Error
 shlde                          ; Error
 shlx                           ; Error
 sim                            ; Error
 sra hl                         ; Error
 sub hl, bc                     ; Error
 xchg                           ; Error
 xthl                           ; Error
