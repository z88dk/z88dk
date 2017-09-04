 adc (hl)               ; 8E
 adc (ix)               ; FD 8E 00
 adc (ix+127)           ; FD 8E 7F
 adc (ix-128)           ; FD 8E 80
 adc (iy)               ; DD 8E 00
 adc (iy+127)           ; DD 8E 7F
 adc (iy-128)           ; DD 8E 80
 adc -128               ; CE 80
 adc 127                ; CE 7F
 adc 255                ; CE FF
 adc a                  ; 8F
 adc a',(hl)            ; 76 8E
 adc a',(ix)            ; 76 FD 8E 00
 adc a',(ix+127)        ; 76 FD 8E 7F
 adc a',(ix-128)        ; 76 FD 8E 80
 adc a',(iy)            ; 76 DD 8E 00
 adc a',(iy+127)        ; 76 DD 8E 7F
 adc a',(iy-128)        ; 76 DD 8E 80
 adc a',-128            ; 76 CE 80
 adc a',127             ; 76 CE 7F
 adc a',255             ; 76 CE FF
 adc a',a               ; 76 8F
 adc a',b               ; 76 88
 adc a',c               ; 76 89
 adc a',d               ; 76 8A
 adc a',e               ; 76 8B
 adc a',h               ; 76 8C
 adc a',l               ; 76 8D
 adc a,(hl)             ; 8E
 adc a,(ix)             ; FD 8E 00
 adc a,(ix+127)         ; FD 8E 7F
 adc a,(ix-128)         ; FD 8E 80
 adc a,(iy)             ; DD 8E 00
 adc a,(iy+127)         ; DD 8E 7F
 adc a,(iy-128)         ; DD 8E 80
 adc a,-128             ; CE 80
 adc a,127              ; CE 7F
 adc a,255              ; CE FF
 adc a,a                ; 8F
 adc a,b                ; 88
 adc a,c                ; 89
 adc a,d                ; 8A
 adc a,e                ; 8B
 adc a,h                ; 8C
 adc a,l                ; 8D
 adc b                  ; 88
 adc c                  ; 89
 adc d                  ; 8A
 adc e                  ; 8B
 adc h                  ; 8C
 adc hl',bc             ; 76 ED 4A
 adc hl',de             ; 76 ED 5A
 adc hl',hl             ; 76 ED 6A
 adc hl',sp             ; 76 ED 7A
 adc hl,bc              ; ED 4A
 adc hl,de              ; ED 5A
 adc hl,hl              ; ED 6A
 adc hl,sp              ; ED 7A
 adc l                  ; 8D
 add (hl)               ; 86
 add (ix)               ; FD 86 00
 add (ix+127)           ; FD 86 7F
 add (ix-128)           ; FD 86 80
 add (iy)               ; DD 86 00
 add (iy+127)           ; DD 86 7F
 add (iy-128)           ; DD 86 80
 add -128               ; C6 80
 add 127                ; C6 7F
 add 255                ; C6 FF
 add a                  ; 87
 add a',(hl)            ; 76 86
 add a',(ix)            ; 76 FD 86 00
 add a',(ix+127)        ; 76 FD 86 7F
 add a',(ix-128)        ; 76 FD 86 80
 add a',(iy)            ; 76 DD 86 00
 add a',(iy+127)        ; 76 DD 86 7F
 add a',(iy-128)        ; 76 DD 86 80
 add a',-128            ; 76 C6 80
 add a',127             ; 76 C6 7F
 add a',255             ; 76 C6 FF
 add a',a               ; 76 87
 add a',b               ; 76 80
 add a',c               ; 76 81
 add a',d               ; 76 82
 add a',e               ; 76 83
 add a',h               ; 76 84
 add a',l               ; 76 85
 add a,(hl)             ; 86
 add a,(ix)             ; FD 86 00
 add a,(ix+127)         ; FD 86 7F
 add a,(ix-128)         ; FD 86 80
 add a,(iy)             ; DD 86 00
 add a,(iy+127)         ; DD 86 7F
 add a,(iy-128)         ; DD 86 80
 add a,-128             ; C6 80
 add a,127              ; C6 7F
 add a,255              ; C6 FF
 add a,a                ; 87
 add a,b                ; 80
 add a,c                ; 81
 add a,d                ; 82
 add a,e                ; 83
 add a,h                ; 84
 add a,l                ; 85
 add b                  ; 80
 add c                  ; 81
 add d                  ; 82
 add e                  ; 83
 add h                  ; 84
 add hl',bc             ; 76 09
 add hl',de             ; 76 19
 add hl',hl             ; 76 29
 add hl',sp             ; 76 39
 add hl,bc              ; 09
 add hl,de              ; 19
 add hl,hl              ; 29
 add hl,sp              ; 39
 add ix,bc              ; FD 09
 add ix,de              ; FD 19
 add ix,ix              ; FD 29
 add ix,sp              ; FD 39
 add iy,bc              ; DD 09
 add iy,de              ; DD 19
 add iy,iy              ; DD 29
 add iy,sp              ; DD 39
 add l                  ; 85
 add sp,-128            ; 27 80
 add sp,127             ; 27 7F
 altd adc (hl)          ; 76 8E
 altd adc (ix)          ; 76 FD 8E 00
 altd adc (ix+127)      ; 76 FD 8E 7F
 altd adc (ix-128)      ; 76 FD 8E 80
 altd adc (iy)          ; 76 DD 8E 00
 altd adc (iy+127)      ; 76 DD 8E 7F
 altd adc (iy-128)      ; 76 DD 8E 80
 altd adc -128          ; 76 CE 80
 altd adc 127           ; 76 CE 7F
 altd adc 255           ; 76 CE FF
 altd adc a             ; 76 8F
 altd adc a,(hl)        ; 76 8E
 altd adc a,(ix)        ; 76 FD 8E 00
 altd adc a,(ix+127)    ; 76 FD 8E 7F
 altd adc a,(ix-128)    ; 76 FD 8E 80
 altd adc a,(iy)        ; 76 DD 8E 00
 altd adc a,(iy+127)    ; 76 DD 8E 7F
 altd adc a,(iy-128)    ; 76 DD 8E 80
 altd adc a,-128        ; 76 CE 80
 altd adc a,127         ; 76 CE 7F
 altd adc a,255         ; 76 CE FF
 altd adc a,a           ; 76 8F
 altd adc a,b           ; 76 88
 altd adc a,c           ; 76 89
 altd adc a,d           ; 76 8A
 altd adc a,e           ; 76 8B
 altd adc a,h           ; 76 8C
 altd adc a,l           ; 76 8D
 altd adc b             ; 76 88
 altd adc c             ; 76 89
 altd adc d             ; 76 8A
 altd adc e             ; 76 8B
 altd adc h             ; 76 8C
 altd adc hl,bc         ; 76 ED 4A
 altd adc hl,de         ; 76 ED 5A
 altd adc hl,hl         ; 76 ED 6A
 altd adc hl,sp         ; 76 ED 7A
 altd adc l             ; 76 8D
 altd add (hl)          ; 76 86
 altd add (ix)          ; 76 FD 86 00
 altd add (ix+127)      ; 76 FD 86 7F
 altd add (ix-128)      ; 76 FD 86 80
 altd add (iy)          ; 76 DD 86 00
 altd add (iy+127)      ; 76 DD 86 7F
 altd add (iy-128)      ; 76 DD 86 80
 altd add -128          ; 76 C6 80
 altd add 127           ; 76 C6 7F
 altd add 255           ; 76 C6 FF
 altd add a             ; 76 87
 altd add a,(hl)        ; 76 86
 altd add a,(ix)        ; 76 FD 86 00
 altd add a,(ix+127)    ; 76 FD 86 7F
 altd add a,(ix-128)    ; 76 FD 86 80
 altd add a,(iy)        ; 76 DD 86 00
 altd add a,(iy+127)    ; 76 DD 86 7F
 altd add a,(iy-128)    ; 76 DD 86 80
 altd add a,-128        ; 76 C6 80
 altd add a,127         ; 76 C6 7F
 altd add a,255         ; 76 C6 FF
 altd add a,a           ; 76 87
 altd add a,b           ; 76 80
 altd add a,c           ; 76 81
 altd add a,d           ; 76 82
 altd add a,e           ; 76 83
 altd add a,h           ; 76 84
 altd add a,l           ; 76 85
 altd add b             ; 76 80
 altd add c             ; 76 81
 altd add d             ; 76 82
 altd add e             ; 76 83
 altd add h             ; 76 84
 altd add hl,bc         ; 76 09
 altd add hl,de         ; 76 19
 altd add hl,hl         ; 76 29
 altd add hl,sp         ; 76 39
 altd add l             ; 76 85
 altd and (hl)          ; 76 A6
 altd and (ix)          ; 76 FD A6 00
 altd and (ix+127)      ; 76 FD A6 7F
 altd and (ix-128)      ; 76 FD A6 80
 altd and (iy)          ; 76 DD A6 00
 altd and (iy+127)      ; 76 DD A6 7F
 altd and (iy-128)      ; 76 DD A6 80
 altd and -128          ; 76 E6 80
 altd and 127           ; 76 E6 7F
 altd and 255           ; 76 E6 FF
 altd and a             ; 76 A7
 altd and a,(hl)        ; 76 A6
 altd and a,(ix)        ; 76 FD A6 00
 altd and a,(ix+127)    ; 76 FD A6 7F
 altd and a,(ix-128)    ; 76 FD A6 80
 altd and a,(iy)        ; 76 DD A6 00
 altd and a,(iy+127)    ; 76 DD A6 7F
 altd and a,(iy-128)    ; 76 DD A6 80
 altd and a,-128        ; 76 E6 80
 altd and a,127         ; 76 E6 7F
 altd and a,255         ; 76 E6 FF
 altd and a,a           ; 76 A7
 altd and a,b           ; 76 A0
 altd and a,c           ; 76 A1
 altd and a,d           ; 76 A2
 altd and a,e           ; 76 A3
 altd and a,h           ; 76 A4
 altd and a,l           ; 76 A5
 altd and b             ; 76 A0
 altd and c             ; 76 A1
 altd and d             ; 76 A2
 altd and e             ; 76 A3
 altd and h             ; 76 A4
 altd and hl,de         ; 76 DC
 altd and l             ; 76 A5
 altd bool hl           ; 76 CC
 altd ccf               ; 76 3F
 altd ccf f             ; 76 3F
 altd cp (hl)           ; 76 BE
 altd cp (ix)           ; 76 FD BE 00
 altd cp (ix+127)       ; 76 FD BE 7F
 altd cp (ix-128)       ; 76 FD BE 80
 altd cp (iy)           ; 76 DD BE 00
 altd cp (iy+127)       ; 76 DD BE 7F
 altd cp (iy-128)       ; 76 DD BE 80
 altd cp -128           ; 76 FE 80
 altd cp 127            ; 76 FE 7F
 altd cp 255            ; 76 FE FF
 altd cp a              ; 76 BF
 altd cp a,(hl)         ; 76 BE
 altd cp a,(ix)         ; 76 FD BE 00
 altd cp a,(ix+127)     ; 76 FD BE 7F
 altd cp a,(ix-128)     ; 76 FD BE 80
 altd cp a,(iy)         ; 76 DD BE 00
 altd cp a,(iy+127)     ; 76 DD BE 7F
 altd cp a,(iy-128)     ; 76 DD BE 80
 altd cp a,-128         ; 76 FE 80
 altd cp a,127          ; 76 FE 7F
 altd cp a,255          ; 76 FE FF
 altd cp a,a            ; 76 BF
 altd cp a,b            ; 76 B8
 altd cp a,c            ; 76 B9
 altd cp a,d            ; 76 BA
 altd cp a,e            ; 76 BB
 altd cp a,h            ; 76 BC
 altd cp a,l            ; 76 BD
 altd cp b              ; 76 B8
 altd cp c              ; 76 B9
 altd cp d              ; 76 BA
 altd cp e              ; 76 BB
 altd cp h              ; 76 BC
 altd cp l              ; 76 BD
 altd cpl               ; 76 2F
 altd cpl a             ; 76 2F
 altd dec a             ; 76 3D
 altd dec b             ; 76 05
 altd dec bc            ; 76 0B
 altd dec c             ; 76 0D
 altd dec d             ; 76 15
 altd dec de            ; 76 1B
 altd dec e             ; 76 1D
 altd dec h             ; 76 25
 altd dec hl            ; 76 2B
 altd dec l             ; 76 2D
 altd djnz ASMPC        ; 76 10 FE
 altd ex (sp),hl        ; 76 ED 54
 altd ex de',hl         ; 76 E3
 altd ex de,hl          ; 76 EB
 altd inc a             ; 76 3C
 altd inc b             ; 76 04
 altd inc bc            ; 76 03
 altd inc c             ; 76 0C
 altd inc d             ; 76 14
 altd inc de            ; 76 13
 altd inc e             ; 76 1C
 altd inc h             ; 76 24
 altd inc hl            ; 76 23
 altd inc l             ; 76 2C
 altd ld a,(-32768)     ; 76 3A 00 80
 altd ld a,(32767)      ; 76 3A FF 7F
 altd ld a,(65535)      ; 76 3A FF FF
 altd ld a,(bc)         ; 76 0A
 altd ld a,(de)         ; 76 1A
 altd ld a,(hl)         ; 76 7E
 altd ld a,(ix)         ; 76 FD 7E 00
 altd ld a,(ix+127)     ; 76 FD 7E 7F
 altd ld a,(ix-128)     ; 76 FD 7E 80
 altd ld a,(iy)         ; 76 DD 7E 00
 altd ld a,(iy+127)     ; 76 DD 7E 7F
 altd ld a,(iy-128)     ; 76 DD 7E 80
 altd ld a,-128         ; 76 3E 80
 altd ld a,127          ; 76 3E 7F
 altd ld a,255          ; 76 3E FF
 altd ld a,a            ; 76 7F
 altd ld a,b            ; 76 78
 altd ld a,c            ; 76 79
 altd ld a,d            ; 76 7A
 altd ld a,e            ; 76 7B
 altd ld a,eir          ; 76 ED 57
 altd ld a,h            ; 76 7C
 altd ld a,iir          ; 76 ED 5F
 altd ld a,l            ; 76 7D
 altd ld a,xpc          ; 76 ED 77
 altd ld b,(hl)         ; 76 46
 altd ld b,(ix)         ; 76 FD 46 00
 altd ld b,(ix+127)     ; 76 FD 46 7F
 altd ld b,(ix-128)     ; 76 FD 46 80
 altd ld b,(iy)         ; 76 DD 46 00
 altd ld b,(iy+127)     ; 76 DD 46 7F
 altd ld b,(iy-128)     ; 76 DD 46 80
 altd ld b,-128         ; 76 06 80
 altd ld b,127          ; 76 06 7F
 altd ld b,255          ; 76 06 FF
 altd ld b,a            ; 76 47
 altd ld b,b            ; 76 40
 altd ld b,c            ; 76 41
 altd ld b,d            ; 76 42
 altd ld b,e            ; 76 43
 altd ld b,h            ; 76 44
 altd ld b,l            ; 76 45
 altd ld bc,(-32768)    ; 76 ED 4B 00 80
 altd ld bc,(32767)     ; 76 ED 4B FF 7F
 altd ld bc,(65535)     ; 76 ED 4B FF FF
 altd ld bc,-32768      ; 76 01 00 80
 altd ld bc,32767       ; 76 01 FF 7F
 altd ld bc,65535       ; 76 01 FF FF
 altd ld c,(hl)         ; 76 4E
 altd ld c,(ix)         ; 76 FD 4E 00
 altd ld c,(ix+127)     ; 76 FD 4E 7F
 altd ld c,(ix-128)     ; 76 FD 4E 80
 altd ld c,(iy)         ; 76 DD 4E 00
 altd ld c,(iy+127)     ; 76 DD 4E 7F
 altd ld c,(iy-128)     ; 76 DD 4E 80
 altd ld c,-128         ; 76 0E 80
 altd ld c,127          ; 76 0E 7F
 altd ld c,255          ; 76 0E FF
 altd ld c,a            ; 76 4F
 altd ld c,b            ; 76 48
 altd ld c,c            ; 76 49
 altd ld c,d            ; 76 4A
 altd ld c,e            ; 76 4B
 altd ld c,h            ; 76 4C
 altd ld c,l            ; 76 4D
 altd ld d,(hl)         ; 76 56
 altd ld d,(ix)         ; 76 FD 56 00
 altd ld d,(ix+127)     ; 76 FD 56 7F
 altd ld d,(ix-128)     ; 76 FD 56 80
 altd ld d,(iy)         ; 76 DD 56 00
 altd ld d,(iy+127)     ; 76 DD 56 7F
 altd ld d,(iy-128)     ; 76 DD 56 80
 altd ld d,-128         ; 76 16 80
 altd ld d,127          ; 76 16 7F
 altd ld d,255          ; 76 16 FF
 altd ld d,a            ; 76 57
 altd ld d,b            ; 76 50
 altd ld d,c            ; 76 51
 altd ld d,d            ; 76 52
 altd ld d,e            ; 76 53
 altd ld d,h            ; 76 54
 altd ld d,l            ; 76 55
 altd ld de,(-32768)    ; 76 ED 5B 00 80
 altd ld de,(32767)     ; 76 ED 5B FF 7F
 altd ld de,(65535)     ; 76 ED 5B FF FF
 altd ld de,-32768      ; 76 11 00 80
 altd ld de,32767       ; 76 11 FF 7F
 altd ld de,65535       ; 76 11 FF FF
 altd ld e,(hl)         ; 76 5E
 altd ld e,(ix)         ; 76 FD 5E 00
 altd ld e,(ix+127)     ; 76 FD 5E 7F
 altd ld e,(ix-128)     ; 76 FD 5E 80
 altd ld e,(iy)         ; 76 DD 5E 00
 altd ld e,(iy+127)     ; 76 DD 5E 7F
 altd ld e,(iy-128)     ; 76 DD 5E 80
 altd ld e,-128         ; 76 1E 80
 altd ld e,127          ; 76 1E 7F
 altd ld e,255          ; 76 1E FF
 altd ld e,a            ; 76 5F
 altd ld e,b            ; 76 58
 altd ld e,c            ; 76 59
 altd ld e,d            ; 76 5A
 altd ld e,e            ; 76 5B
 altd ld e,h            ; 76 5C
 altd ld e,l            ; 76 5D
 altd ld h,(hl)         ; 76 66
 altd ld h,(ix)         ; 76 FD 66 00
 altd ld h,(ix+127)     ; 76 FD 66 7F
 altd ld h,(ix-128)     ; 76 FD 66 80
 altd ld h,(iy)         ; 76 DD 66 00
 altd ld h,(iy+127)     ; 76 DD 66 7F
 altd ld h,(iy-128)     ; 76 DD 66 80
 altd ld h,-128         ; 76 26 80
 altd ld h,127          ; 76 26 7F
 altd ld h,255          ; 76 26 FF
 altd ld h,a            ; 76 67
 altd ld h,b            ; 76 60
 altd ld h,c            ; 76 61
 altd ld h,d            ; 76 62
 altd ld h,e            ; 76 63
 altd ld h,h            ; 76 64
 altd ld h,l            ; 76 65
 altd ld hl,(-32768)    ; 76 2A 00 80
 altd ld hl,(32767)     ; 76 2A FF 7F
 altd ld hl,(65535)     ; 76 2A FF FF
 altd ld hl,(hl)        ; 76 DD E4 00
 altd ld hl,(hl+127)    ; 76 DD E4 7F
 altd ld hl,(hl-128)    ; 76 DD E4 80
 altd ld hl,(ix)        ; 76 FD E4 00
 altd ld hl,(ix+127)    ; 76 FD E4 7F
 altd ld hl,(ix-128)    ; 76 FD E4 80
 altd ld hl,(iy)        ; 76 E4 00
 altd ld hl,(iy+127)    ; 76 E4 7F
 altd ld hl,(iy-128)    ; 76 E4 80
 altd ld hl,(sp)        ; 76 C4 00
 altd ld hl,(sp+-128)   ; 76 C4 80
 altd ld hl,(sp+127)    ; 76 C4 7F
 altd ld hl,(sp+255)    ; 76 C4 FF
 altd ld hl,-32768      ; 76 21 00 80
 altd ld hl,32767       ; 76 21 FF 7F
 altd ld hl,65535       ; 76 21 FF FF
 altd ld hl,ix          ; 76 FD 7C
 altd ld hl,iy          ; 76 DD 7C
 altd ld l,(hl)         ; 76 6E
 altd ld l,(ix)         ; 76 FD 6E 00
 altd ld l,(ix+127)     ; 76 FD 6E 7F
 altd ld l,(ix-128)     ; 76 FD 6E 80
 altd ld l,(iy)         ; 76 DD 6E 00
 altd ld l,(iy+127)     ; 76 DD 6E 7F
 altd ld l,(iy-128)     ; 76 DD 6E 80
 altd ld l,-128         ; 76 2E 80
 altd ld l,127          ; 76 2E 7F
 altd ld l,255          ; 76 2E FF
 altd ld l,a            ; 76 6F
 altd ld l,b            ; 76 68
 altd ld l,c            ; 76 69
 altd ld l,d            ; 76 6A
 altd ld l,e            ; 76 6B
 altd ld l,h            ; 76 6C
 altd ld l,l            ; 76 6D
 altd neg               ; 76 ED 44
 altd neg a             ; 76 ED 44
 altd or (hl)           ; 76 B6
 altd or (ix)           ; 76 FD B6 00
 altd or (ix+127)       ; 76 FD B6 7F
 altd or (ix-128)       ; 76 FD B6 80
 altd or (iy)           ; 76 DD B6 00
 altd or (iy+127)       ; 76 DD B6 7F
 altd or (iy-128)       ; 76 DD B6 80
 altd or -128           ; 76 F6 80
 altd or 127            ; 76 F6 7F
 altd or 255            ; 76 F6 FF
 altd or a              ; 76 B7
 altd or a,(hl)         ; 76 B6
 altd or a,(ix)         ; 76 FD B6 00
 altd or a,(ix+127)     ; 76 FD B6 7F
 altd or a,(ix-128)     ; 76 FD B6 80
 altd or a,(iy)         ; 76 DD B6 00
 altd or a,(iy+127)     ; 76 DD B6 7F
 altd or a,(iy-128)     ; 76 DD B6 80
 altd or a,-128         ; 76 F6 80
 altd or a,127          ; 76 F6 7F
 altd or a,255          ; 76 F6 FF
 altd or a,a            ; 76 B7
 altd or a,b            ; 76 B0
 altd or a,c            ; 76 B1
 altd or a,d            ; 76 B2
 altd or a,e            ; 76 B3
 altd or a,h            ; 76 B4
 altd or a,l            ; 76 B5
 altd or b              ; 76 B0
 altd or c              ; 76 B1
 altd or d              ; 76 B2
 altd or e              ; 76 B3
 altd or h              ; 76 B4
 altd or hl,de          ; 76 EC
 altd or l              ; 76 B5
 altd pop af            ; 76 F1
 altd pop bc            ; 76 C1
 altd pop de            ; 76 D1
 altd pop hl            ; 76 E1
 altd res 0,a           ; 76 CB 87
 altd res 0,b           ; 76 CB 80
 altd res 0,c           ; 76 CB 81
 altd res 0,d           ; 76 CB 82
 altd res 0,e           ; 76 CB 83
 altd res 0,h           ; 76 CB 84
 altd res 0,l           ; 76 CB 85
 altd res 1,a           ; 76 CB 8F
 altd res 1,b           ; 76 CB 88
 altd res 1,c           ; 76 CB 89
 altd res 1,d           ; 76 CB 8A
 altd res 1,e           ; 76 CB 8B
 altd res 1,h           ; 76 CB 8C
 altd res 1,l           ; 76 CB 8D
 altd res 2,a           ; 76 CB 97
 altd res 2,b           ; 76 CB 90
 altd res 2,c           ; 76 CB 91
 altd res 2,d           ; 76 CB 92
 altd res 2,e           ; 76 CB 93
 altd res 2,h           ; 76 CB 94
 altd res 2,l           ; 76 CB 95
 altd res 3,a           ; 76 CB 9F
 altd res 3,b           ; 76 CB 98
 altd res 3,c           ; 76 CB 99
 altd res 3,d           ; 76 CB 9A
 altd res 3,e           ; 76 CB 9B
 altd res 3,h           ; 76 CB 9C
 altd res 3,l           ; 76 CB 9D
 altd res 4,a           ; 76 CB A7
 altd res 4,b           ; 76 CB A0
 altd res 4,c           ; 76 CB A1
 altd res 4,d           ; 76 CB A2
 altd res 4,e           ; 76 CB A3
 altd res 4,h           ; 76 CB A4
 altd res 4,l           ; 76 CB A5
 altd res 5,a           ; 76 CB AF
 altd res 5,b           ; 76 CB A8
 altd res 5,c           ; 76 CB A9
 altd res 5,d           ; 76 CB AA
 altd res 5,e           ; 76 CB AB
 altd res 5,h           ; 76 CB AC
 altd res 5,l           ; 76 CB AD
 altd res 6,a           ; 76 CB B7
 altd res 6,b           ; 76 CB B0
 altd res 6,c           ; 76 CB B1
 altd res 6,d           ; 76 CB B2
 altd res 6,e           ; 76 CB B3
 altd res 6,h           ; 76 CB B4
 altd res 6,l           ; 76 CB B5
 altd res 7,a           ; 76 CB BF
 altd res 7,b           ; 76 CB B8
 altd res 7,c           ; 76 CB B9
 altd res 7,d           ; 76 CB BA
 altd res 7,e           ; 76 CB BB
 altd res 7,h           ; 76 CB BC
 altd res 7,l           ; 76 CB BD
 altd rl de             ; 76 F3
 altd rr de             ; 76 FB
 altd rr hl             ; 76 FC
 altd sbc (hl)          ; 76 9E
 altd sbc (ix)          ; 76 FD 9E 00
 altd sbc (ix+127)      ; 76 FD 9E 7F
 altd sbc (ix-128)      ; 76 FD 9E 80
 altd sbc (iy)          ; 76 DD 9E 00
 altd sbc (iy+127)      ; 76 DD 9E 7F
 altd sbc (iy-128)      ; 76 DD 9E 80
 altd sbc -128          ; 76 DE 80
 altd sbc 127           ; 76 DE 7F
 altd sbc 255           ; 76 DE FF
 altd sbc a             ; 76 9F
 altd sbc a,(hl)        ; 76 9E
 altd sbc a,(ix)        ; 76 FD 9E 00
 altd sbc a,(ix+127)    ; 76 FD 9E 7F
 altd sbc a,(ix-128)    ; 76 FD 9E 80
 altd sbc a,(iy)        ; 76 DD 9E 00
 altd sbc a,(iy+127)    ; 76 DD 9E 7F
 altd sbc a,(iy-128)    ; 76 DD 9E 80
 altd sbc a,-128        ; 76 DE 80
 altd sbc a,127         ; 76 DE 7F
 altd sbc a,255         ; 76 DE FF
 altd sbc a,a           ; 76 9F
 altd sbc a,b           ; 76 98
 altd sbc a,c           ; 76 99
 altd sbc a,d           ; 76 9A
 altd sbc a,e           ; 76 9B
 altd sbc a,h           ; 76 9C
 altd sbc a,l           ; 76 9D
 altd sbc b             ; 76 98
 altd sbc c             ; 76 99
 altd sbc d             ; 76 9A
 altd sbc e             ; 76 9B
 altd sbc h             ; 76 9C
 altd sbc hl,bc         ; 76 ED 42
 altd sbc hl,de         ; 76 ED 52
 altd sbc hl,hl         ; 76 ED 62
 altd sbc hl,sp         ; 76 ED 72
 altd sbc l             ; 76 9D
 altd scf               ; 76 37
 altd scf f             ; 76 37
 altd set 0,a           ; 76 CB C7
 altd set 0,b           ; 76 CB C0
 altd set 0,c           ; 76 CB C1
 altd set 0,d           ; 76 CB C2
 altd set 0,e           ; 76 CB C3
 altd set 0,h           ; 76 CB C4
 altd set 0,l           ; 76 CB C5
 altd set 1,a           ; 76 CB CF
 altd set 1,b           ; 76 CB C8
 altd set 1,c           ; 76 CB C9
 altd set 1,d           ; 76 CB CA
 altd set 1,e           ; 76 CB CB
 altd set 1,h           ; 76 CB CC
 altd set 1,l           ; 76 CB CD
 altd set 2,a           ; 76 CB D7
 altd set 2,b           ; 76 CB D0
 altd set 2,c           ; 76 CB D1
 altd set 2,d           ; 76 CB D2
 altd set 2,e           ; 76 CB D3
 altd set 2,h           ; 76 CB D4
 altd set 2,l           ; 76 CB D5
 altd set 3,a           ; 76 CB DF
 altd set 3,b           ; 76 CB D8
 altd set 3,c           ; 76 CB D9
 altd set 3,d           ; 76 CB DA
 altd set 3,e           ; 76 CB DB
 altd set 3,h           ; 76 CB DC
 altd set 3,l           ; 76 CB DD
 altd set 4,a           ; 76 CB E7
 altd set 4,b           ; 76 CB E0
 altd set 4,c           ; 76 CB E1
 altd set 4,d           ; 76 CB E2
 altd set 4,e           ; 76 CB E3
 altd set 4,h           ; 76 CB E4
 altd set 4,l           ; 76 CB E5
 altd set 5,a           ; 76 CB EF
 altd set 5,b           ; 76 CB E8
 altd set 5,c           ; 76 CB E9
 altd set 5,d           ; 76 CB EA
 altd set 5,e           ; 76 CB EB
 altd set 5,h           ; 76 CB EC
 altd set 5,l           ; 76 CB ED
 altd set 6,a           ; 76 CB F7
 altd set 6,b           ; 76 CB F0
 altd set 6,c           ; 76 CB F1
 altd set 6,d           ; 76 CB F2
 altd set 6,e           ; 76 CB F3
 altd set 6,h           ; 76 CB F4
 altd set 6,l           ; 76 CB F5
 altd set 7,a           ; 76 CB FF
 altd set 7,b           ; 76 CB F8
 altd set 7,c           ; 76 CB F9
 altd set 7,d           ; 76 CB FA
 altd set 7,e           ; 76 CB FB
 altd set 7,h           ; 76 CB FC
 altd set 7,l           ; 76 CB FD
 altd sub (hl)          ; 76 96
 altd sub (ix)          ; 76 FD 96 00
 altd sub (ix+127)      ; 76 FD 96 7F
 altd sub (ix-128)      ; 76 FD 96 80
 altd sub (iy)          ; 76 DD 96 00
 altd sub (iy+127)      ; 76 DD 96 7F
 altd sub (iy-128)      ; 76 DD 96 80
 altd sub -128          ; 76 D6 80
 altd sub 127           ; 76 D6 7F
 altd sub 255           ; 76 D6 FF
 altd sub a             ; 76 97
 altd sub a,(hl)        ; 76 96
 altd sub a,(ix)        ; 76 FD 96 00
 altd sub a,(ix+127)    ; 76 FD 96 7F
 altd sub a,(ix-128)    ; 76 FD 96 80
 altd sub a,(iy)        ; 76 DD 96 00
 altd sub a,(iy+127)    ; 76 DD 96 7F
 altd sub a,(iy-128)    ; 76 DD 96 80
 altd sub a,-128        ; 76 D6 80
 altd sub a,127         ; 76 D6 7F
 altd sub a,255         ; 76 D6 FF
 altd sub a,a           ; 76 97
 altd sub a,b           ; 76 90
 altd sub a,c           ; 76 91
 altd sub a,d           ; 76 92
 altd sub a,e           ; 76 93
 altd sub a,h           ; 76 94
 altd sub a,l           ; 76 95
 altd sub b             ; 76 90
 altd sub c             ; 76 91
 altd sub d             ; 76 92
 altd sub e             ; 76 93
 altd sub h             ; 76 94
 altd sub l             ; 76 95
 altd xor (hl)          ; 76 AE
 altd xor (ix)          ; 76 FD AE 00
 altd xor (ix+127)      ; 76 FD AE 7F
 altd xor (ix-128)      ; 76 FD AE 80
 altd xor (iy)          ; 76 DD AE 00
 altd xor (iy+127)      ; 76 DD AE 7F
 altd xor (iy-128)      ; 76 DD AE 80
 altd xor -128          ; 76 EE 80
 altd xor 127           ; 76 EE 7F
 altd xor 255           ; 76 EE FF
 altd xor a             ; 76 AF
 altd xor a,(hl)        ; 76 AE
 altd xor a,(ix)        ; 76 FD AE 00
 altd xor a,(ix+127)    ; 76 FD AE 7F
 altd xor a,(ix-128)    ; 76 FD AE 80
 altd xor a,(iy)        ; 76 DD AE 00
 altd xor a,(iy+127)    ; 76 DD AE 7F
 altd xor a,(iy-128)    ; 76 DD AE 80
 altd xor a,-128        ; 76 EE 80
 altd xor a,127         ; 76 EE 7F
 altd xor a,255         ; 76 EE FF
 altd xor a,a           ; 76 AF
 altd xor a,b           ; 76 A8
 altd xor a,c           ; 76 A9
 altd xor a,d           ; 76 AA
 altd xor a,e           ; 76 AB
 altd xor a,h           ; 76 AC
 altd xor a,l           ; 76 AD
 altd xor b             ; 76 A8
 altd xor c             ; 76 A9
 altd xor d             ; 76 AA
 altd xor e             ; 76 AB
 altd xor h             ; 76 AC
 altd xor l             ; 76 AD
 and (hl)               ; A6
 and (ix)               ; FD A6 00
 and (ix+127)           ; FD A6 7F
 and (ix-128)           ; FD A6 80
 and (iy)               ; DD A6 00
 and (iy+127)           ; DD A6 7F
 and (iy-128)           ; DD A6 80
 and -128               ; E6 80
 and 127                ; E6 7F
 and 255                ; E6 FF
 and a                  ; A7
 and a',(hl)            ; 76 A6
 and a',(ix)            ; 76 FD A6 00
 and a',(ix+127)        ; 76 FD A6 7F
 and a',(ix-128)        ; 76 FD A6 80
 and a',(iy)            ; 76 DD A6 00
 and a',(iy+127)        ; 76 DD A6 7F
 and a',(iy-128)        ; 76 DD A6 80
 and a',-128            ; 76 E6 80
 and a',127             ; 76 E6 7F
 and a',255             ; 76 E6 FF
 and a',a               ; 76 A7
 and a',b               ; 76 A0
 and a',c               ; 76 A1
 and a',d               ; 76 A2
 and a',e               ; 76 A3
 and a',h               ; 76 A4
 and a',l               ; 76 A5
 and a,(hl)             ; A6
 and a,(ix)             ; FD A6 00
 and a,(ix+127)         ; FD A6 7F
 and a,(ix-128)         ; FD A6 80
 and a,(iy)             ; DD A6 00
 and a,(iy+127)         ; DD A6 7F
 and a,(iy-128)         ; DD A6 80
 and a,-128             ; E6 80
 and a,127              ; E6 7F
 and a,255              ; E6 FF
 and a,a                ; A7
 and a,b                ; A0
 and a,c                ; A1
 and a,d                ; A2
 and a,e                ; A3
 and a,h                ; A4
 and a,l                ; A5
 and b                  ; A0
 and c                  ; A1
 and d                  ; A2
 and e                  ; A3
 and h                  ; A4
 and hl',de             ; 76 DC
 and hl,de              ; DC
 and ix,de              ; FD DC
 and iy,de              ; DD DC
 and l                  ; A5
 bit 0,(hl)             ; CB 46
 bit 0,(ix)             ; FD CB 00 46
 bit 0,(ix+127)         ; FD CB 7F 46
 bit 0,(ix-128)         ; FD CB 80 46
 bit 0,(iy)             ; DD CB 00 46
 bit 0,(iy+127)         ; DD CB 7F 46
 bit 0,(iy-128)         ; DD CB 80 46
 bit 0,a                ; CB 47
 bit 0,b                ; CB 40
 bit 0,c                ; CB 41
 bit 0,d                ; CB 42
 bit 0,e                ; CB 43
 bit 0,h                ; CB 44
 bit 0,l                ; CB 45
 bit 1,(hl)             ; CB 4E
 bit 1,(ix)             ; FD CB 00 4E
 bit 1,(ix+127)         ; FD CB 7F 4E
 bit 1,(ix-128)         ; FD CB 80 4E
 bit 1,(iy)             ; DD CB 00 4E
 bit 1,(iy+127)         ; DD CB 7F 4E
 bit 1,(iy-128)         ; DD CB 80 4E
 bit 1,a                ; CB 4F
 bit 1,b                ; CB 48
 bit 1,c                ; CB 49
 bit 1,d                ; CB 4A
 bit 1,e                ; CB 4B
 bit 1,h                ; CB 4C
 bit 1,l                ; CB 4D
 bit 2,(hl)             ; CB 56
 bit 2,(ix)             ; FD CB 00 56
 bit 2,(ix+127)         ; FD CB 7F 56
 bit 2,(ix-128)         ; FD CB 80 56
 bit 2,(iy)             ; DD CB 00 56
 bit 2,(iy+127)         ; DD CB 7F 56
 bit 2,(iy-128)         ; DD CB 80 56
 bit 2,a                ; CB 57
 bit 2,b                ; CB 50
 bit 2,c                ; CB 51
 bit 2,d                ; CB 52
 bit 2,e                ; CB 53
 bit 2,h                ; CB 54
 bit 2,l                ; CB 55
 bit 3,(hl)             ; CB 5E
 bit 3,(ix)             ; FD CB 00 5E
 bit 3,(ix+127)         ; FD CB 7F 5E
 bit 3,(ix-128)         ; FD CB 80 5E
 bit 3,(iy)             ; DD CB 00 5E
 bit 3,(iy+127)         ; DD CB 7F 5E
 bit 3,(iy-128)         ; DD CB 80 5E
 bit 3,a                ; CB 5F
 bit 3,b                ; CB 58
 bit 3,c                ; CB 59
 bit 3,d                ; CB 5A
 bit 3,e                ; CB 5B
 bit 3,h                ; CB 5C
 bit 3,l                ; CB 5D
 bit 4,(hl)             ; CB 66
 bit 4,(ix)             ; FD CB 00 66
 bit 4,(ix+127)         ; FD CB 7F 66
 bit 4,(ix-128)         ; FD CB 80 66
 bit 4,(iy)             ; DD CB 00 66
 bit 4,(iy+127)         ; DD CB 7F 66
 bit 4,(iy-128)         ; DD CB 80 66
 bit 4,a                ; CB 67
 bit 4,b                ; CB 60
 bit 4,c                ; CB 61
 bit 4,d                ; CB 62
 bit 4,e                ; CB 63
 bit 4,h                ; CB 64
 bit 4,l                ; CB 65
 bit 5,(hl)             ; CB 6E
 bit 5,(ix)             ; FD CB 00 6E
 bit 5,(ix+127)         ; FD CB 7F 6E
 bit 5,(ix-128)         ; FD CB 80 6E
 bit 5,(iy)             ; DD CB 00 6E
 bit 5,(iy+127)         ; DD CB 7F 6E
 bit 5,(iy-128)         ; DD CB 80 6E
 bit 5,a                ; CB 6F
 bit 5,b                ; CB 68
 bit 5,c                ; CB 69
 bit 5,d                ; CB 6A
 bit 5,e                ; CB 6B
 bit 5,h                ; CB 6C
 bit 5,l                ; CB 6D
 bit 6,(hl)             ; CB 76
 bit 6,(ix)             ; FD CB 00 76
 bit 6,(ix+127)         ; FD CB 7F 76
 bit 6,(ix-128)         ; FD CB 80 76
 bit 6,(iy)             ; DD CB 00 76
 bit 6,(iy+127)         ; DD CB 7F 76
 bit 6,(iy-128)         ; DD CB 80 76
 bit 6,a                ; CB 77
 bit 6,b                ; CB 70
 bit 6,c                ; CB 71
 bit 6,d                ; CB 72
 bit 6,e                ; CB 73
 bit 6,h                ; CB 74
 bit 6,l                ; CB 75
 bit 7,(hl)             ; CB 7E
 bit 7,(ix)             ; FD CB 00 7E
 bit 7,(ix+127)         ; FD CB 7F 7E
 bit 7,(ix-128)         ; FD CB 80 7E
 bit 7,(iy)             ; DD CB 00 7E
 bit 7,(iy+127)         ; DD CB 7F 7E
 bit 7,(iy-128)         ; DD CB 80 7E
 bit 7,a                ; CB 7F
 bit 7,b                ; CB 78
 bit 7,c                ; CB 79
 bit 7,d                ; CB 7A
 bit 7,e                ; CB 7B
 bit 7,h                ; CB 7C
 bit 7,l                ; CB 7D
 bool hl                ; CC
 bool hl'               ; 76 CC
 bool ix                ; FD CC
 bool iy                ; DD CC
 call -32768            ; CD 00 80
 call 32767             ; CD FF 7F
 call 65535             ; CD FF FF
 ccf                    ; 3F
 ccf f                  ; 3F
 ccf f'                 ; 76 3F
 cp (hl)                ; BE
 cp (ix)                ; FD BE 00
 cp (ix+127)            ; FD BE 7F
 cp (ix-128)            ; FD BE 80
 cp (iy)                ; DD BE 00
 cp (iy+127)            ; DD BE 7F
 cp (iy-128)            ; DD BE 80
 cp -128                ; FE 80
 cp 127                 ; FE 7F
 cp 255                 ; FE FF
 cp a                   ; BF
 cp a,(hl)              ; BE
 cp a,(ix)              ; FD BE 00
 cp a,(ix+127)          ; FD BE 7F
 cp a,(ix-128)          ; FD BE 80
 cp a,(iy)              ; DD BE 00
 cp a,(iy+127)          ; DD BE 7F
 cp a,(iy-128)          ; DD BE 80
 cp a,-128              ; FE 80
 cp a,127               ; FE 7F
 cp a,255               ; FE FF
 cp a,a                 ; BF
 cp a,b                 ; B8
 cp a,c                 ; B9
 cp a,d                 ; BA
 cp a,e                 ; BB
 cp a,h                 ; BC
 cp a,l                 ; BD
 cp b                   ; B8
 cp c                   ; B9
 cp d                   ; BA
 cp e                   ; BB
 cp h                   ; BC
 cp l                   ; BD
 cpl                    ; 2F
 cpl a                  ; 2F
 cpl a'                 ; 76 2F
 dec (hl)               ; 35
 dec (ix)               ; FD 35 00
 dec (ix+127)           ; FD 35 7F
 dec (ix-128)           ; FD 35 80
 dec (iy)               ; DD 35 00
 dec (iy+127)           ; DD 35 7F
 dec (iy-128)           ; DD 35 80
 dec a                  ; 3D
 dec a'                 ; 76 3D
 dec b                  ; 05
 dec b'                 ; 76 05
 dec bc                 ; 0B
 dec bc'                ; 76 0B
 dec c                  ; 0D
 dec c'                 ; 76 0D
 dec d                  ; 15
 dec d'                 ; 76 15
 dec de                 ; 1B
 dec de'                ; 76 1B
 dec e                  ; 1D
 dec e'                 ; 76 1D
 dec h                  ; 25
 dec h'                 ; 76 25
 dec hl                 ; 2B
 dec hl'                ; 76 2B
 dec ix                 ; FD 2B
 dec iy                 ; DD 2B
 dec l                  ; 2D
 dec l'                 ; 76 2D
 dec sp                 ; 3B
 djnz ASMPC             ; 10 FE
 djnz b',ASMPC          ; 76 10 FE
 djnz b,ASMPC           ; 10 FE
 ex (sp),hl             ; ED 54
 ex (sp),hl'            ; 76 ED 54
 ex (sp),ix             ; FD E3
 ex (sp),iy             ; DD E3
 ex af,af               ; 08
 ex af,af'              ; 08
 ex de',hl              ; E3
 ex de',hl'             ; 76 E3
 ex de,hl               ; EB
 ex de,hl'              ; 76 EB
 exx                    ; D9
 inc (hl)               ; 34
 inc (ix)               ; FD 34 00
 inc (ix+127)           ; FD 34 7F
 inc (ix-128)           ; FD 34 80
 inc (iy)               ; DD 34 00
 inc (iy+127)           ; DD 34 7F
 inc (iy-128)           ; DD 34 80
 inc a                  ; 3C
 inc a'                 ; 76 3C
 inc b                  ; 04
 inc b'                 ; 76 04
 inc bc                 ; 03
 inc bc'                ; 76 03
 inc c                  ; 0C
 inc c'                 ; 76 0C
 inc d                  ; 14
 inc d'                 ; 76 14
 inc de                 ; 13
 inc de'                ; 76 13
 inc e                  ; 1C
 inc e'                 ; 76 1C
 inc h                  ; 24
 inc h'                 ; 76 24
 inc hl                 ; 23
 inc hl'                ; 76 23
 inc ix                 ; FD 23
 inc iy                 ; DD 23
 inc l                  ; 2C
 inc l'                 ; 76 2C
 inc sp                 ; 33
 ioe ld a,(-32768)      ; DB 3A 00 80
 ioe ld a,(32767)       ; DB 3A FF 7F
 ioe ld a,(65535)       ; DB 3A FF FF
 ioe ldd                ; DB ED A8
 ioe lddr               ; DB ED B8
 ioe ldi                ; DB ED A0
 ioe ldir               ; DB ED B0
 ioi ld a,(-32768)      ; D3 3A 00 80
 ioi ld a,(32767)       ; D3 3A FF 7F
 ioi ld a,(65535)       ; D3 3A FF FF
 ioi ldd                ; D3 ED A8
 ioi lddr               ; D3 ED B8
 ioi ldi                ; D3 ED A0
 ioi ldir               ; D3 ED B0
 ipres                  ; ED 5D
 ipset 0                ; ED 46
 ipset 1                ; ED 56
 ipset 2                ; ED 4E
 ipset 3                ; ED 5E
 jp (hl)                ; E9
 jp (ix)                ; FD E9
 jp (iy)                ; DD E9
 jp -32768              ; C3 00 80
 jp 32767               ; C3 FF 7F
 jp 65535               ; C3 FF FF
 jp c,-32768            ; DA 00 80
 jp c,32767             ; DA FF 7F
 jp c,65535             ; DA FF FF
 jp lo,-32768           ; EA 00 80
 jp lo,32767            ; EA FF 7F
 jp lo,65535            ; EA FF FF
 jp lz,-32768           ; E2 00 80
 jp lz,32767            ; E2 FF 7F
 jp lz,65535            ; E2 FF FF
 jp m,-32768            ; FA 00 80
 jp m,32767             ; FA FF 7F
 jp m,65535             ; FA FF FF
 jp nc,-32768           ; D2 00 80
 jp nc,32767            ; D2 FF 7F
 jp nc,65535            ; D2 FF FF
 jp nv,-32768           ; E2 00 80
 jp nv,32767            ; E2 FF 7F
 jp nv,65535            ; E2 FF FF
 jp nz,-32768           ; C2 00 80
 jp nz,32767            ; C2 FF 7F
 jp nz,65535            ; C2 FF FF
 jp p,-32768            ; F2 00 80
 jp p,32767             ; F2 FF 7F
 jp p,65535             ; F2 FF FF
 jp pe,-32768           ; EA 00 80
 jp pe,32767            ; EA FF 7F
 jp pe,65535            ; EA FF FF
 jp po,-32768           ; E2 00 80
 jp po,32767            ; E2 FF 7F
 jp po,65535            ; E2 FF FF
 jp v,-32768            ; EA 00 80
 jp v,32767             ; EA FF 7F
 jp v,65535             ; EA FF FF
 jp z,-32768            ; CA 00 80
 jp z,32767             ; CA FF 7F
 jp z,65535             ; CA FF FF
 jr ASMPC               ; 18 FE
 jr c,ASMPC             ; 38 FE
 jr nc,ASMPC            ; 30 FE
 jr nz,ASMPC            ; 20 FE
 jr z,ASMPC             ; 28 FE
 ld (-32768),a          ; 32 00 80
 ld (-32768),bc         ; ED 43 00 80
 ld (-32768),de         ; ED 53 00 80
 ld (-32768),hl         ; 22 00 80
 ld (-32768),ix         ; FD 22 00 80
 ld (-32768),iy         ; DD 22 00 80
 ld (-32768),sp         ; ED 73 00 80
 ld (32767),a           ; 32 FF 7F
 ld (32767),bc          ; ED 43 FF 7F
 ld (32767),de          ; ED 53 FF 7F
 ld (32767),hl          ; 22 FF 7F
 ld (32767),ix          ; FD 22 FF 7F
 ld (32767),iy          ; DD 22 FF 7F
 ld (32767),sp          ; ED 73 FF 7F
 ld (65535),a           ; 32 FF FF
 ld (65535),bc          ; ED 43 FF FF
 ld (65535),de          ; ED 53 FF FF
 ld (65535),hl          ; 22 FF FF
 ld (65535),ix          ; FD 22 FF FF
 ld (65535),iy          ; DD 22 FF FF
 ld (65535),sp          ; ED 73 FF FF
 ld (bc),a              ; 02
 ld (de),a              ; 12
 ld (hl),-128           ; 36 80
 ld (hl),127            ; 36 7F
 ld (hl),255            ; 36 FF
 ld (hl),a              ; 77
 ld (hl),b              ; 70
 ld (hl),c              ; 71
 ld (hl),d              ; 72
 ld (hl),e              ; 73
 ld (hl),h              ; 74
 ld (hl),hl             ; DD F4 00
 ld (hl),l              ; 75
 ld (hl+127),hl         ; DD F4 7F
 ld (hl-128),hl         ; DD F4 80
 ld (ix),-128           ; FD 36 00 80
 ld (ix),127            ; FD 36 00 7F
 ld (ix),255            ; FD 36 00 FF
 ld (ix),a              ; FD 77 00
 ld (ix),b              ; FD 70 00
 ld (ix),c              ; FD 71 00
 ld (ix),d              ; FD 72 00
 ld (ix),e              ; FD 73 00
 ld (ix),h              ; FD 74 00
 ld (ix),hl             ; FD F4 00
 ld (ix),l              ; FD 75 00
 ld (ix+127),-128       ; FD 36 7F 80
 ld (ix+127),127        ; FD 36 7F 7F
 ld (ix+127),255        ; FD 36 7F FF
 ld (ix+127),a          ; FD 77 7F
 ld (ix+127),b          ; FD 70 7F
 ld (ix+127),c          ; FD 71 7F
 ld (ix+127),d          ; FD 72 7F
 ld (ix+127),e          ; FD 73 7F
 ld (ix+127),h          ; FD 74 7F
 ld (ix+127),hl         ; FD F4 7F
 ld (ix+127),l          ; FD 75 7F
 ld (ix-128),-128       ; FD 36 80 80
 ld (ix-128),127        ; FD 36 80 7F
 ld (ix-128),255        ; FD 36 80 FF
 ld (ix-128),a          ; FD 77 80
 ld (ix-128),b          ; FD 70 80
 ld (ix-128),c          ; FD 71 80
 ld (ix-128),d          ; FD 72 80
 ld (ix-128),e          ; FD 73 80
 ld (ix-128),h          ; FD 74 80
 ld (ix-128),hl         ; FD F4 80
 ld (ix-128),l          ; FD 75 80
 ld (iy),-128           ; DD 36 00 80
 ld (iy),127            ; DD 36 00 7F
 ld (iy),255            ; DD 36 00 FF
 ld (iy),a              ; DD 77 00
 ld (iy),b              ; DD 70 00
 ld (iy),c              ; DD 71 00
 ld (iy),d              ; DD 72 00
 ld (iy),e              ; DD 73 00
 ld (iy),h              ; DD 74 00
 ld (iy),hl             ; F4 00
 ld (iy),l              ; DD 75 00
 ld (iy+127),-128       ; DD 36 7F 80
 ld (iy+127),127        ; DD 36 7F 7F
 ld (iy+127),255        ; DD 36 7F FF
 ld (iy+127),a          ; DD 77 7F
 ld (iy+127),b          ; DD 70 7F
 ld (iy+127),c          ; DD 71 7F
 ld (iy+127),d          ; DD 72 7F
 ld (iy+127),e          ; DD 73 7F
 ld (iy+127),h          ; DD 74 7F
 ld (iy+127),hl         ; F4 7F
 ld (iy+127),l          ; DD 75 7F
 ld (iy-128),-128       ; DD 36 80 80
 ld (iy-128),127        ; DD 36 80 7F
 ld (iy-128),255        ; DD 36 80 FF
 ld (iy-128),a          ; DD 77 80
 ld (iy-128),b          ; DD 70 80
 ld (iy-128),c          ; DD 71 80
 ld (iy-128),d          ; DD 72 80
 ld (iy-128),e          ; DD 73 80
 ld (iy-128),h          ; DD 74 80
 ld (iy-128),hl         ; F4 80
 ld (iy-128),l          ; DD 75 80
 ld (sp),hl             ; D4 00
 ld (sp),ix             ; FD D4 00
 ld (sp),iy             ; DD D4 00
 ld (sp+-128),hl        ; D4 80
 ld (sp+-128),ix        ; FD D4 80
 ld (sp+-128),iy        ; DD D4 80
 ld (sp+127),hl         ; D4 7F
 ld (sp+127),ix         ; FD D4 7F
 ld (sp+127),iy         ; DD D4 7F
 ld (sp+255),hl         ; D4 FF
 ld (sp+255),ix         ; FD D4 FF
 ld (sp+255),iy         ; DD D4 FF
 ld a',(-32768)         ; 76 3A 00 80
 ld a',(32767)          ; 76 3A FF 7F
 ld a',(65535)          ; 76 3A FF FF
 ld a',(bc)             ; 76 0A
 ld a',(de)             ; 76 1A
 ld a',(hl)             ; 76 7E
 ld a',(ix)             ; 76 FD 7E 00
 ld a',(ix+127)         ; 76 FD 7E 7F
 ld a',(ix-128)         ; 76 FD 7E 80
 ld a',(iy)             ; 76 DD 7E 00
 ld a',(iy+127)         ; 76 DD 7E 7F
 ld a',(iy-128)         ; 76 DD 7E 80
 ld a',-128             ; 76 3E 80
 ld a',127              ; 76 3E 7F
 ld a',255              ; 76 3E FF
 ld a',a                ; 76 7F
 ld a',b                ; 76 78
 ld a',c                ; 76 79
 ld a',d                ; 76 7A
 ld a',e                ; 76 7B
 ld a',eir              ; 76 ED 57
 ld a',h                ; 76 7C
 ld a',iir              ; 76 ED 5F
 ld a',l                ; 76 7D
 ld a',xpc              ; 76 ED 77
 ld a,(-32768)          ; 3A 00 80
 ld a,(32767)           ; 3A FF 7F
 ld a,(65535)           ; 3A FF FF
 ld a,(bc)              ; 0A
 ld a,(de)              ; 1A
 ld a,(hl)              ; 7E
 ld a,(ix)              ; FD 7E 00
 ld a,(ix+127)          ; FD 7E 7F
 ld a,(ix-128)          ; FD 7E 80
 ld a,(iy)              ; DD 7E 00
 ld a,(iy+127)          ; DD 7E 7F
 ld a,(iy-128)          ; DD 7E 80
 ld a,-128              ; 3E 80
 ld a,127               ; 3E 7F
 ld a,255               ; 3E FF
 ld a,a                 ; 7F
 ld a,b                 ; 78
 ld a,c                 ; 79
 ld a,d                 ; 7A
 ld a,e                 ; 7B
 ld a,eir               ; ED 57
 ld a,h                 ; 7C
 ld a,iir               ; ED 5F
 ld a,l                 ; 7D
 ld a,xpc               ; ED 77
 ld b',(hl)             ; 76 46
 ld b',(ix)             ; 76 FD 46 00
 ld b',(ix+127)         ; 76 FD 46 7F
 ld b',(ix-128)         ; 76 FD 46 80
 ld b',(iy)             ; 76 DD 46 00
 ld b',(iy+127)         ; 76 DD 46 7F
 ld b',(iy-128)         ; 76 DD 46 80
 ld b',-128             ; 76 06 80
 ld b',127              ; 76 06 7F
 ld b',255              ; 76 06 FF
 ld b',a                ; 76 47
 ld b',b                ; 76 40
 ld b',c                ; 76 41
 ld b',d                ; 76 42
 ld b',e                ; 76 43
 ld b',h                ; 76 44
 ld b',l                ; 76 45
 ld b,(hl)              ; 46
 ld b,(ix)              ; FD 46 00
 ld b,(ix+127)          ; FD 46 7F
 ld b,(ix-128)          ; FD 46 80
 ld b,(iy)              ; DD 46 00
 ld b,(iy+127)          ; DD 46 7F
 ld b,(iy-128)          ; DD 46 80
 ld b,-128              ; 06 80
 ld b,127               ; 06 7F
 ld b,255               ; 06 FF
 ld b,a                 ; 47
 ld b,b                 ; 40
 ld b,c                 ; 41
 ld b,d                 ; 42
 ld b,e                 ; 43
 ld b,h                 ; 44
 ld b,l                 ; 45
 ld bc',(-32768)        ; 76 ED 4B 00 80
 ld bc',(32767)         ; 76 ED 4B FF 7F
 ld bc',(65535)         ; 76 ED 4B FF FF
 ld bc',-32768          ; 76 01 00 80
 ld bc',32767           ; 76 01 FF 7F
 ld bc',65535           ; 76 01 FF FF
 ld bc',bc              ; ED 49
 ld bc',de              ; ED 41
 ld bc,(-32768)         ; ED 4B 00 80
 ld bc,(32767)          ; ED 4B FF 7F
 ld bc,(65535)          ; ED 4B FF FF
 ld bc,-32768           ; 01 00 80
 ld bc,32767            ; 01 FF 7F
 ld bc,65535            ; 01 FF FF
 ld c',(hl)             ; 76 4E
 ld c',(ix)             ; 76 FD 4E 00
 ld c',(ix+127)         ; 76 FD 4E 7F
 ld c',(ix-128)         ; 76 FD 4E 80
 ld c',(iy)             ; 76 DD 4E 00
 ld c',(iy+127)         ; 76 DD 4E 7F
 ld c',(iy-128)         ; 76 DD 4E 80
 ld c',-128             ; 76 0E 80
 ld c',127              ; 76 0E 7F
 ld c',255              ; 76 0E FF
 ld c',a                ; 76 4F
 ld c',b                ; 76 48
 ld c',c                ; 76 49
 ld c',d                ; 76 4A
 ld c',e                ; 76 4B
 ld c',h                ; 76 4C
 ld c',l                ; 76 4D
 ld c,(hl)              ; 4E
 ld c,(ix)              ; FD 4E 00
 ld c,(ix+127)          ; FD 4E 7F
 ld c,(ix-128)          ; FD 4E 80
 ld c,(iy)              ; DD 4E 00
 ld c,(iy+127)          ; DD 4E 7F
 ld c,(iy-128)          ; DD 4E 80
 ld c,-128              ; 0E 80
 ld c,127               ; 0E 7F
 ld c,255               ; 0E FF
 ld c,a                 ; 4F
 ld c,b                 ; 48
 ld c,c                 ; 49
 ld c,d                 ; 4A
 ld c,e                 ; 4B
 ld c,h                 ; 4C
 ld c,l                 ; 4D
 ld d',(hl)             ; 76 56
 ld d',(ix)             ; 76 FD 56 00
 ld d',(ix+127)         ; 76 FD 56 7F
 ld d',(ix-128)         ; 76 FD 56 80
 ld d',(iy)             ; 76 DD 56 00
 ld d',(iy+127)         ; 76 DD 56 7F
 ld d',(iy-128)         ; 76 DD 56 80
 ld d',-128             ; 76 16 80
 ld d',127              ; 76 16 7F
 ld d',255              ; 76 16 FF
 ld d',a                ; 76 57
 ld d',b                ; 76 50
 ld d',c                ; 76 51
 ld d',d                ; 76 52
 ld d',e                ; 76 53
 ld d',h                ; 76 54
 ld d',l                ; 76 55
 ld d,(hl)              ; 56
 ld d,(ix)              ; FD 56 00
 ld d,(ix+127)          ; FD 56 7F
 ld d,(ix-128)          ; FD 56 80
 ld d,(iy)              ; DD 56 00
 ld d,(iy+127)          ; DD 56 7F
 ld d,(iy-128)          ; DD 56 80
 ld d,-128              ; 16 80
 ld d,127               ; 16 7F
 ld d,255               ; 16 FF
 ld d,a                 ; 57
 ld d,b                 ; 50
 ld d,c                 ; 51
 ld d,d                 ; 52
 ld d,e                 ; 53
 ld d,h                 ; 54
 ld d,l                 ; 55
 ld de',(-32768)        ; 76 ED 5B 00 80
 ld de',(32767)         ; 76 ED 5B FF 7F
 ld de',(65535)         ; 76 ED 5B FF FF
 ld de',-32768          ; 76 11 00 80
 ld de',32767           ; 76 11 FF 7F
 ld de',65535           ; 76 11 FF FF
 ld de',bc              ; ED 59
 ld de',de              ; ED 51
 ld de,(-32768)         ; ED 5B 00 80
 ld de,(32767)          ; ED 5B FF 7F
 ld de,(65535)          ; ED 5B FF FF
 ld de,-32768           ; 11 00 80
 ld de,32767            ; 11 FF 7F
 ld de,65535            ; 11 FF FF
 ld e',(hl)             ; 76 5E
 ld e',(ix)             ; 76 FD 5E 00
 ld e',(ix+127)         ; 76 FD 5E 7F
 ld e',(ix-128)         ; 76 FD 5E 80
 ld e',(iy)             ; 76 DD 5E 00
 ld e',(iy+127)         ; 76 DD 5E 7F
 ld e',(iy-128)         ; 76 DD 5E 80
 ld e',-128             ; 76 1E 80
 ld e',127              ; 76 1E 7F
 ld e',255              ; 76 1E FF
 ld e',a                ; 76 5F
 ld e',b                ; 76 58
 ld e',c                ; 76 59
 ld e',d                ; 76 5A
 ld e',e                ; 76 5B
 ld e',h                ; 76 5C
 ld e',l                ; 76 5D
 ld e,(hl)              ; 5E
 ld e,(ix)              ; FD 5E 00
 ld e,(ix+127)          ; FD 5E 7F
 ld e,(ix-128)          ; FD 5E 80
 ld e,(iy)              ; DD 5E 00
 ld e,(iy+127)          ; DD 5E 7F
 ld e,(iy-128)          ; DD 5E 80
 ld e,-128              ; 1E 80
 ld e,127               ; 1E 7F
 ld e,255               ; 1E FF
 ld e,a                 ; 5F
 ld e,b                 ; 58
 ld e,c                 ; 59
 ld e,d                 ; 5A
 ld e,e                 ; 5B
 ld e,h                 ; 5C
 ld e,l                 ; 5D
 ld eir,a               ; ED 47
 ld h',(hl)             ; 76 66
 ld h',(ix)             ; 76 FD 66 00
 ld h',(ix+127)         ; 76 FD 66 7F
 ld h',(ix-128)         ; 76 FD 66 80
 ld h',(iy)             ; 76 DD 66 00
 ld h',(iy+127)         ; 76 DD 66 7F
 ld h',(iy-128)         ; 76 DD 66 80
 ld h',-128             ; 76 26 80
 ld h',127              ; 76 26 7F
 ld h',255              ; 76 26 FF
 ld h',a                ; 76 67
 ld h',b                ; 76 60
 ld h',c                ; 76 61
 ld h',d                ; 76 62
 ld h',e                ; 76 63
 ld h',h                ; 76 64
 ld h',l                ; 76 65
 ld h,(hl)              ; 66
 ld h,(ix)              ; FD 66 00
 ld h,(ix+127)          ; FD 66 7F
 ld h,(ix-128)          ; FD 66 80
 ld h,(iy)              ; DD 66 00
 ld h,(iy+127)          ; DD 66 7F
 ld h,(iy-128)          ; DD 66 80
 ld h,-128              ; 26 80
 ld h,127               ; 26 7F
 ld h,255               ; 26 FF
 ld h,a                 ; 67
 ld h,b                 ; 60
 ld h,c                 ; 61
 ld h,d                 ; 62
 ld h,e                 ; 63
 ld h,h                 ; 64
 ld h,l                 ; 65
 ld hl',(-32768)        ; 76 2A 00 80
 ld hl',(32767)         ; 76 2A FF 7F
 ld hl',(65535)         ; 76 2A FF FF
 ld hl',(hl)            ; 76 DD E4 00
 ld hl',(hl+127)        ; 76 DD E4 7F
 ld hl',(hl-128)        ; 76 DD E4 80
 ld hl',(ix)            ; 76 FD E4 00
 ld hl',(ix+127)        ; 76 FD E4 7F
 ld hl',(ix-128)        ; 76 FD E4 80
 ld hl',(iy)            ; 76 E4 00
 ld hl',(iy+127)        ; 76 E4 7F
 ld hl',(iy-128)        ; 76 E4 80
 ld hl',(sp)            ; 76 C4 00
 ld hl',(sp+-128)       ; 76 C4 80
 ld hl',(sp+127)        ; 76 C4 7F
 ld hl',(sp+255)        ; 76 C4 FF
 ld hl',-32768          ; 76 21 00 80
 ld hl',32767           ; 76 21 FF 7F
 ld hl',65535           ; 76 21 FF FF
 ld hl',bc              ; ED 69
 ld hl',de              ; ED 61
 ld hl',ix              ; 76 FD 7C
 ld hl',iy              ; 76 DD 7C
 ld hl,(-32768)         ; 2A 00 80
 ld hl,(32767)          ; 2A FF 7F
 ld hl,(65535)          ; 2A FF FF
 ld hl,(hl)             ; DD E4 00
 ld hl,(hl+127)         ; DD E4 7F
 ld hl,(hl-128)         ; DD E4 80
 ld hl,(ix)             ; FD E4 00
 ld hl,(ix+127)         ; FD E4 7F
 ld hl,(ix-128)         ; FD E4 80
 ld hl,(iy)             ; E4 00
 ld hl,(iy+127)         ; E4 7F
 ld hl,(iy-128)         ; E4 80
 ld hl,(sp)             ; C4 00
 ld hl,(sp+-128)        ; C4 80
 ld hl,(sp+127)         ; C4 7F
 ld hl,(sp+255)         ; C4 FF
 ld hl,-32768           ; 21 00 80
 ld hl,32767            ; 21 FF 7F
 ld hl,65535            ; 21 FF FF
 ld hl,ix               ; FD 7C
 ld hl,iy               ; DD 7C
 ld iir,a               ; ED 4F
 ld ix,(-32768)         ; FD 2A 00 80
 ld ix,(32767)          ; FD 2A FF 7F
 ld ix,(65535)          ; FD 2A FF FF
 ld ix,(sp)             ; FD C4 00
 ld ix,(sp+-128)        ; FD C4 80
 ld ix,(sp+127)         ; FD C4 7F
 ld ix,(sp+255)         ; FD C4 FF
 ld ix,-32768           ; FD 21 00 80
 ld ix,32767            ; FD 21 FF 7F
 ld ix,65535            ; FD 21 FF FF
 ld ix,hl               ; FD 7D
 ld iy,(-32768)         ; DD 2A 00 80
 ld iy,(32767)          ; DD 2A FF 7F
 ld iy,(65535)          ; DD 2A FF FF
 ld iy,(sp)             ; DD C4 00
 ld iy,(sp+-128)        ; DD C4 80
 ld iy,(sp+127)         ; DD C4 7F
 ld iy,(sp+255)         ; DD C4 FF
 ld iy,-32768           ; DD 21 00 80
 ld iy,32767            ; DD 21 FF 7F
 ld iy,65535            ; DD 21 FF FF
 ld iy,hl               ; DD 7D
 ld l',(hl)             ; 76 6E
 ld l',(ix)             ; 76 FD 6E 00
 ld l',(ix+127)         ; 76 FD 6E 7F
 ld l',(ix-128)         ; 76 FD 6E 80
 ld l',(iy)             ; 76 DD 6E 00
 ld l',(iy+127)         ; 76 DD 6E 7F
 ld l',(iy-128)         ; 76 DD 6E 80
 ld l',-128             ; 76 2E 80
 ld l',127              ; 76 2E 7F
 ld l',255              ; 76 2E FF
 ld l',a                ; 76 6F
 ld l',b                ; 76 68
 ld l',c                ; 76 69
 ld l',d                ; 76 6A
 ld l',e                ; 76 6B
 ld l',h                ; 76 6C
 ld l',l                ; 76 6D
 ld l,(hl)              ; 6E
 ld l,(ix)              ; FD 6E 00
 ld l,(ix+127)          ; FD 6E 7F
 ld l,(ix-128)          ; FD 6E 80
 ld l,(iy)              ; DD 6E 00
 ld l,(iy+127)          ; DD 6E 7F
 ld l,(iy-128)          ; DD 6E 80
 ld l,-128              ; 2E 80
 ld l,127               ; 2E 7F
 ld l,255               ; 2E FF
 ld l,a                 ; 6F
 ld l,b                 ; 68
 ld l,c                 ; 69
 ld l,d                 ; 6A
 ld l,e                 ; 6B
 ld l,h                 ; 6C
 ld l,l                 ; 6D
 ld sp,(-32768)         ; ED 7B 00 80
 ld sp,(32767)          ; ED 7B FF 7F
 ld sp,(65535)          ; ED 7B FF FF
 ld sp,-32768           ; 31 00 80
 ld sp,32767            ; 31 FF 7F
 ld sp,65535            ; 31 FF FF
 ld sp,hl               ; F9
 ld sp,ix               ; FD F9
 ld sp,iy               ; DD F9
 ld xpc,a               ; ED 67
 ldd                    ; ED A8
 lddr                   ; ED B8
 ldi                    ; ED A0
 ldir                   ; ED B0
 ldp (-32768),hl        ; ED 65 00 80
 ldp (-32768),ix        ; FD 65 00 80
 ldp (-32768),iy        ; DD 65 00 80
 ldp (32767),hl         ; ED 65 FF 7F
 ldp (32767),ix         ; FD 65 FF 7F
 ldp (32767),iy         ; DD 65 FF 7F
 ldp (65535),hl         ; ED 65 FF FF
 ldp (65535),ix         ; FD 65 FF FF
 ldp (65535),iy         ; DD 65 FF FF
 ldp (hl),hl            ; ED 64
 ldp (ix),hl            ; FD 64
 ldp (iy),hl            ; DD 64
 ldp hl,(-32768)        ; ED 6D 00 80
 ldp hl,(32767)         ; ED 6D FF 7F
 ldp hl,(65535)         ; ED 6D FF FF
 ldp hl,(hl)            ; ED 6C
 ldp hl,(ix)            ; FD 6C
 ldp hl,(iy)            ; DD 6C
 ldp ix,(-32768)        ; FD 6D 00 80
 ldp ix,(32767)         ; FD 6D FF 7F
 ldp ix,(65535)         ; FD 6D FF FF
 ldp iy,(-32768)        ; DD 6D 00 80
 ldp iy,(32767)         ; DD 6D FF 7F
 ldp iy,(65535)         ; DD 6D FF FF
 neg                    ; ED 44
 neg a                  ; ED 44
 neg a'                 ; 76 ED 44
 nop                    ; 00
 or (hl)                ; B6
 or (ix)                ; FD B6 00
 or (ix+127)            ; FD B6 7F
 or (ix-128)            ; FD B6 80
 or (iy)                ; DD B6 00
 or (iy+127)            ; DD B6 7F
 or (iy-128)            ; DD B6 80
 or -128                ; F6 80
 or 127                 ; F6 7F
 or 255                 ; F6 FF
 or a                   ; B7
 or a',(hl)             ; 76 B6
 or a',(ix)             ; 76 FD B6 00
 or a',(ix+127)         ; 76 FD B6 7F
 or a',(ix-128)         ; 76 FD B6 80
 or a',(iy)             ; 76 DD B6 00
 or a',(iy+127)         ; 76 DD B6 7F
 or a',(iy-128)         ; 76 DD B6 80
 or a',-128             ; 76 F6 80
 or a',127              ; 76 F6 7F
 or a',255              ; 76 F6 FF
 or a',a                ; 76 B7
 or a',b                ; 76 B0
 or a',c                ; 76 B1
 or a',d                ; 76 B2
 or a',e                ; 76 B3
 or a',h                ; 76 B4
 or a',l                ; 76 B5
 or a,(hl)              ; B6
 or a,(ix)              ; FD B6 00
 or a,(ix+127)          ; FD B6 7F
 or a,(ix-128)          ; FD B6 80
 or a,(iy)              ; DD B6 00
 or a,(iy+127)          ; DD B6 7F
 or a,(iy-128)          ; DD B6 80
 or a,-128              ; F6 80
 or a,127               ; F6 7F
 or a,255               ; F6 FF
 or a,a                 ; B7
 or a,b                 ; B0
 or a,c                 ; B1
 or a,d                 ; B2
 or a,e                 ; B3
 or a,h                 ; B4
 or a,l                 ; B5
 or b                   ; B0
 or c                   ; B1
 or d                   ; B2
 or e                   ; B3
 or h                   ; B4
 or hl',de              ; 76 EC
 or hl,de               ; EC
 or ix,de               ; FD EC
 or iy,de               ; DD EC
 or l                   ; B5
 pop af                 ; F1
 pop af'                ; 76 F1
 pop bc                 ; C1
 pop bc'                ; 76 C1
 pop de                 ; D1
 pop de'                ; 76 D1
 pop hl                 ; E1
 pop hl'                ; 76 E1
 pop ip                 ; ED 7E
 pop ix                 ; FD E1
 pop iy                 ; DD E1
 push af                ; F5
 push bc                ; C5
 push de                ; D5
 push hl                ; E5
 push ip                ; ED 76
 push ix                ; FD E5
 push iy                ; DD E5
 res 0,(hl)             ; CB 86
 res 0,(ix)             ; FD CB 00 86
 res 0,(ix+127)         ; FD CB 7F 86
 res 0,(ix-128)         ; FD CB 80 86
 res 0,(iy)             ; DD CB 00 86
 res 0,(iy+127)         ; DD CB 7F 86
 res 0,(iy-128)         ; DD CB 80 86
 res 0,a                ; CB 87
 res 0,a'               ; 76 CB 87
 res 0,b                ; CB 80
 res 0,b'               ; 76 CB 80
 res 0,c                ; CB 81
 res 0,c'               ; 76 CB 81
 res 0,d                ; CB 82
 res 0,d'               ; 76 CB 82
 res 0,e                ; CB 83
 res 0,e'               ; 76 CB 83
 res 0,h                ; CB 84
 res 0,h'               ; 76 CB 84
 res 0,l                ; CB 85
 res 0,l'               ; 76 CB 85
 res 1,(hl)             ; CB 8E
 res 1,(ix)             ; FD CB 00 8E
 res 1,(ix+127)         ; FD CB 7F 8E
 res 1,(ix-128)         ; FD CB 80 8E
 res 1,(iy)             ; DD CB 00 8E
 res 1,(iy+127)         ; DD CB 7F 8E
 res 1,(iy-128)         ; DD CB 80 8E
 res 1,a                ; CB 8F
 res 1,a'               ; 76 CB 8F
 res 1,b                ; CB 88
 res 1,b'               ; 76 CB 88
 res 1,c                ; CB 89
 res 1,c'               ; 76 CB 89
 res 1,d                ; CB 8A
 res 1,d'               ; 76 CB 8A
 res 1,e                ; CB 8B
 res 1,e'               ; 76 CB 8B
 res 1,h                ; CB 8C
 res 1,h'               ; 76 CB 8C
 res 1,l                ; CB 8D
 res 1,l'               ; 76 CB 8D
 res 2,(hl)             ; CB 96
 res 2,(ix)             ; FD CB 00 96
 res 2,(ix+127)         ; FD CB 7F 96
 res 2,(ix-128)         ; FD CB 80 96
 res 2,(iy)             ; DD CB 00 96
 res 2,(iy+127)         ; DD CB 7F 96
 res 2,(iy-128)         ; DD CB 80 96
 res 2,a                ; CB 97
 res 2,a'               ; 76 CB 97
 res 2,b                ; CB 90
 res 2,b'               ; 76 CB 90
 res 2,c                ; CB 91
 res 2,c'               ; 76 CB 91
 res 2,d                ; CB 92
 res 2,d'               ; 76 CB 92
 res 2,e                ; CB 93
 res 2,e'               ; 76 CB 93
 res 2,h                ; CB 94
 res 2,h'               ; 76 CB 94
 res 2,l                ; CB 95
 res 2,l'               ; 76 CB 95
 res 3,(hl)             ; CB 9E
 res 3,(ix)             ; FD CB 00 9E
 res 3,(ix+127)         ; FD CB 7F 9E
 res 3,(ix-128)         ; FD CB 80 9E
 res 3,(iy)             ; DD CB 00 9E
 res 3,(iy+127)         ; DD CB 7F 9E
 res 3,(iy-128)         ; DD CB 80 9E
 res 3,a                ; CB 9F
 res 3,a'               ; 76 CB 9F
 res 3,b                ; CB 98
 res 3,b'               ; 76 CB 98
 res 3,c                ; CB 99
 res 3,c'               ; 76 CB 99
 res 3,d                ; CB 9A
 res 3,d'               ; 76 CB 9A
 res 3,e                ; CB 9B
 res 3,e'               ; 76 CB 9B
 res 3,h                ; CB 9C
 res 3,h'               ; 76 CB 9C
 res 3,l                ; CB 9D
 res 3,l'               ; 76 CB 9D
 res 4,(hl)             ; CB A6
 res 4,(ix)             ; FD CB 00 A6
 res 4,(ix+127)         ; FD CB 7F A6
 res 4,(ix-128)         ; FD CB 80 A6
 res 4,(iy)             ; DD CB 00 A6
 res 4,(iy+127)         ; DD CB 7F A6
 res 4,(iy-128)         ; DD CB 80 A6
 res 4,a                ; CB A7
 res 4,a'               ; 76 CB A7
 res 4,b                ; CB A0
 res 4,b'               ; 76 CB A0
 res 4,c                ; CB A1
 res 4,c'               ; 76 CB A1
 res 4,d                ; CB A2
 res 4,d'               ; 76 CB A2
 res 4,e                ; CB A3
 res 4,e'               ; 76 CB A3
 res 4,h                ; CB A4
 res 4,h'               ; 76 CB A4
 res 4,l                ; CB A5
 res 4,l'               ; 76 CB A5
 res 5,(hl)             ; CB AE
 res 5,(ix)             ; FD CB 00 AE
 res 5,(ix+127)         ; FD CB 7F AE
 res 5,(ix-128)         ; FD CB 80 AE
 res 5,(iy)             ; DD CB 00 AE
 res 5,(iy+127)         ; DD CB 7F AE
 res 5,(iy-128)         ; DD CB 80 AE
 res 5,a                ; CB AF
 res 5,a'               ; 76 CB AF
 res 5,b                ; CB A8
 res 5,b'               ; 76 CB A8
 res 5,c                ; CB A9
 res 5,c'               ; 76 CB A9
 res 5,d                ; CB AA
 res 5,d'               ; 76 CB AA
 res 5,e                ; CB AB
 res 5,e'               ; 76 CB AB
 res 5,h                ; CB AC
 res 5,h'               ; 76 CB AC
 res 5,l                ; CB AD
 res 5,l'               ; 76 CB AD
 res 6,(hl)             ; CB B6
 res 6,(ix)             ; FD CB 00 B6
 res 6,(ix+127)         ; FD CB 7F B6
 res 6,(ix-128)         ; FD CB 80 B6
 res 6,(iy)             ; DD CB 00 B6
 res 6,(iy+127)         ; DD CB 7F B6
 res 6,(iy-128)         ; DD CB 80 B6
 res 6,a                ; CB B7
 res 6,a'               ; 76 CB B7
 res 6,b                ; CB B0
 res 6,b'               ; 76 CB B0
 res 6,c                ; CB B1
 res 6,c'               ; 76 CB B1
 res 6,d                ; CB B2
 res 6,d'               ; 76 CB B2
 res 6,e                ; CB B3
 res 6,e'               ; 76 CB B3
 res 6,h                ; CB B4
 res 6,h'               ; 76 CB B4
 res 6,l                ; CB B5
 res 6,l'               ; 76 CB B5
 res 7,(hl)             ; CB BE
 res 7,(ix)             ; FD CB 00 BE
 res 7,(ix+127)         ; FD CB 7F BE
 res 7,(ix-128)         ; FD CB 80 BE
 res 7,(iy)             ; DD CB 00 BE
 res 7,(iy+127)         ; DD CB 7F BE
 res 7,(iy-128)         ; DD CB 80 BE
 res 7,a                ; CB BF
 res 7,a'               ; 76 CB BF
 res 7,b                ; CB B8
 res 7,b'               ; 76 CB B8
 res 7,c                ; CB B9
 res 7,c'               ; 76 CB B9
 res 7,d                ; CB BA
 res 7,d'               ; 76 CB BA
 res 7,e                ; CB BB
 res 7,e'               ; 76 CB BB
 res 7,h                ; CB BC
 res 7,h'               ; 76 CB BC
 res 7,l                ; CB BD
 res 7,l'               ; 76 CB BD
 ret                    ; C9
 ret c                  ; D8
 ret lo                 ; E8
 ret lz                 ; E0
 ret m                  ; F8
 ret nc                 ; D0
 ret nv                 ; E0
 ret nz                 ; C0
 ret p                  ; F0
 ret pe                 ; E8
 ret po                 ; E0
 ret v                  ; E8
 ret z                  ; C8
 reti                   ; ED 4D
 rl (hl)                ; CB 16
 rl (ix)                ; FD CB 00 16
 rl (ix+127)            ; FD CB 7F 16
 rl (ix-128)            ; FD CB 80 16
 rl (iy)                ; DD CB 00 16
 rl (iy+127)            ; DD CB 7F 16
 rl (iy-128)            ; DD CB 80 16
 rl a                   ; CB 17
 rl b                   ; CB 10
 rl c                   ; CB 11
 rl d                   ; CB 12
 rl de                  ; F3
 rl de'                 ; 76 F3
 rl e                   ; CB 13
 rl h                   ; CB 14
 rl l                   ; CB 15
 rla                    ; 17
 rlc (hl)               ; CB 06
 rlc (ix)               ; FD CB 00 06
 rlc (ix+127)           ; FD CB 7F 06
 rlc (ix-128)           ; FD CB 80 06
 rlc (iy)               ; DD CB 00 06
 rlc (iy+127)           ; DD CB 7F 06
 rlc (iy-128)           ; DD CB 80 06
 rlc a                  ; CB 07
 rlc b                  ; CB 00
 rlc c                  ; CB 01
 rlc d                  ; CB 02
 rlc e                  ; CB 03
 rlc h                  ; CB 04
 rlc l                  ; CB 05
 rlca                   ; 07
 rr (hl)                ; CB 1E
 rr (ix)                ; FD CB 00 1E
 rr (ix+127)            ; FD CB 7F 1E
 rr (ix-128)            ; FD CB 80 1E
 rr (iy)                ; DD CB 00 1E
 rr (iy+127)            ; DD CB 7F 1E
 rr (iy-128)            ; DD CB 80 1E
 rr a                   ; CB 1F
 rr b                   ; CB 18
 rr c                   ; CB 19
 rr d                   ; CB 1A
 rr de                  ; FB
 rr de'                 ; 76 FB
 rr e                   ; CB 1B
 rr h                   ; CB 1C
 rr hl                  ; FC
 rr hl'                 ; 76 FC
 rr ix                  ; FD FC
 rr iy                  ; DD FC
 rr l                   ; CB 1D
 rra                    ; 1F
 rrc (hl)               ; CB 0E
 rrc (ix)               ; FD CB 00 0E
 rrc (ix+127)           ; FD CB 7F 0E
 rrc (ix-128)           ; FD CB 80 0E
 rrc (iy)               ; DD CB 00 0E
 rrc (iy+127)           ; DD CB 7F 0E
 rrc (iy-128)           ; DD CB 80 0E
 rrc a                  ; CB 0F
 rrc b                  ; CB 08
 rrc c                  ; CB 09
 rrc d                  ; CB 0A
 rrc e                  ; CB 0B
 rrc h                  ; CB 0C
 rrc l                  ; CB 0D
 rrca                   ; 0F
 rst 16                 ; D7
 rst 24                 ; DF
 rst 32                 ; E7
 rst 40                 ; EF
 rst 56                 ; FF
 sbc (hl)               ; 9E
 sbc (ix)               ; FD 9E 00
 sbc (ix+127)           ; FD 9E 7F
 sbc (ix-128)           ; FD 9E 80
 sbc (iy)               ; DD 9E 00
 sbc (iy+127)           ; DD 9E 7F
 sbc (iy-128)           ; DD 9E 80
 sbc -128               ; DE 80
 sbc 127                ; DE 7F
 sbc 255                ; DE FF
 sbc a                  ; 9F
 sbc a',(hl)            ; 76 9E
 sbc a',(ix)            ; 76 FD 9E 00
 sbc a',(ix+127)        ; 76 FD 9E 7F
 sbc a',(ix-128)        ; 76 FD 9E 80
 sbc a',(iy)            ; 76 DD 9E 00
 sbc a',(iy+127)        ; 76 DD 9E 7F
 sbc a',(iy-128)        ; 76 DD 9E 80
 sbc a',-128            ; 76 DE 80
 sbc a',127             ; 76 DE 7F
 sbc a',255             ; 76 DE FF
 sbc a',a               ; 76 9F
 sbc a',b               ; 76 98
 sbc a',c               ; 76 99
 sbc a',d               ; 76 9A
 sbc a',e               ; 76 9B
 sbc a',h               ; 76 9C
 sbc a',l               ; 76 9D
 sbc a,(hl)             ; 9E
 sbc a,(ix)             ; FD 9E 00
 sbc a,(ix+127)         ; FD 9E 7F
 sbc a,(ix-128)         ; FD 9E 80
 sbc a,(iy)             ; DD 9E 00
 sbc a,(iy+127)         ; DD 9E 7F
 sbc a,(iy-128)         ; DD 9E 80
 sbc a,-128             ; DE 80
 sbc a,127              ; DE 7F
 sbc a,255              ; DE FF
 sbc a,a                ; 9F
 sbc a,b                ; 98
 sbc a,c                ; 99
 sbc a,d                ; 9A
 sbc a,e                ; 9B
 sbc a,h                ; 9C
 sbc a,l                ; 9D
 sbc b                  ; 98
 sbc c                  ; 99
 sbc d                  ; 9A
 sbc e                  ; 9B
 sbc h                  ; 9C
 sbc hl',bc             ; 76 ED 42
 sbc hl',de             ; 76 ED 52
 sbc hl',hl             ; 76 ED 62
 sbc hl',sp             ; 76 ED 72
 sbc hl,bc              ; ED 42
 sbc hl,de              ; ED 52
 sbc hl,hl              ; ED 62
 sbc hl,sp              ; ED 72
 sbc l                  ; 9D
 scf                    ; 37
 scf f                  ; 37
 scf f'                 ; 76 37
 set 0,(hl)             ; CB C6
 set 0,(ix)             ; FD CB 00 C6
 set 0,(ix+127)         ; FD CB 7F C6
 set 0,(ix-128)         ; FD CB 80 C6
 set 0,(iy)             ; DD CB 00 C6
 set 0,(iy+127)         ; DD CB 7F C6
 set 0,(iy-128)         ; DD CB 80 C6
 set 0,a                ; CB C7
 set 0,a'               ; 76 CB C7
 set 0,b                ; CB C0
 set 0,b'               ; 76 CB C0
 set 0,c                ; CB C1
 set 0,c'               ; 76 CB C1
 set 0,d                ; CB C2
 set 0,d'               ; 76 CB C2
 set 0,e                ; CB C3
 set 0,e'               ; 76 CB C3
 set 0,h                ; CB C4
 set 0,h'               ; 76 CB C4
 set 0,l                ; CB C5
 set 0,l'               ; 76 CB C5
 set 1,(hl)             ; CB CE
 set 1,(ix)             ; FD CB 00 CE
 set 1,(ix+127)         ; FD CB 7F CE
 set 1,(ix-128)         ; FD CB 80 CE
 set 1,(iy)             ; DD CB 00 CE
 set 1,(iy+127)         ; DD CB 7F CE
 set 1,(iy-128)         ; DD CB 80 CE
 set 1,a                ; CB CF
 set 1,a'               ; 76 CB CF
 set 1,b                ; CB C8
 set 1,b'               ; 76 CB C8
 set 1,c                ; CB C9
 set 1,c'               ; 76 CB C9
 set 1,d                ; CB CA
 set 1,d'               ; 76 CB CA
 set 1,e                ; CB CB
 set 1,e'               ; 76 CB CB
 set 1,h                ; CB CC
 set 1,h'               ; 76 CB CC
 set 1,l                ; CB CD
 set 1,l'               ; 76 CB CD
 set 2,(hl)             ; CB D6
 set 2,(ix)             ; FD CB 00 D6
 set 2,(ix+127)         ; FD CB 7F D6
 set 2,(ix-128)         ; FD CB 80 D6
 set 2,(iy)             ; DD CB 00 D6
 set 2,(iy+127)         ; DD CB 7F D6
 set 2,(iy-128)         ; DD CB 80 D6
 set 2,a                ; CB D7
 set 2,a'               ; 76 CB D7
 set 2,b                ; CB D0
 set 2,b'               ; 76 CB D0
 set 2,c                ; CB D1
 set 2,c'               ; 76 CB D1
 set 2,d                ; CB D2
 set 2,d'               ; 76 CB D2
 set 2,e                ; CB D3
 set 2,e'               ; 76 CB D3
 set 2,h                ; CB D4
 set 2,h'               ; 76 CB D4
 set 2,l                ; CB D5
 set 2,l'               ; 76 CB D5
 set 3,(hl)             ; CB DE
 set 3,(ix)             ; FD CB 00 DE
 set 3,(ix+127)         ; FD CB 7F DE
 set 3,(ix-128)         ; FD CB 80 DE
 set 3,(iy)             ; DD CB 00 DE
 set 3,(iy+127)         ; DD CB 7F DE
 set 3,(iy-128)         ; DD CB 80 DE
 set 3,a                ; CB DF
 set 3,a'               ; 76 CB DF
 set 3,b                ; CB D8
 set 3,b'               ; 76 CB D8
 set 3,c                ; CB D9
 set 3,c'               ; 76 CB D9
 set 3,d                ; CB DA
 set 3,d'               ; 76 CB DA
 set 3,e                ; CB DB
 set 3,e'               ; 76 CB DB
 set 3,h                ; CB DC
 set 3,h'               ; 76 CB DC
 set 3,l                ; CB DD
 set 3,l'               ; 76 CB DD
 set 4,(hl)             ; CB E6
 set 4,(ix)             ; FD CB 00 E6
 set 4,(ix+127)         ; FD CB 7F E6
 set 4,(ix-128)         ; FD CB 80 E6
 set 4,(iy)             ; DD CB 00 E6
 set 4,(iy+127)         ; DD CB 7F E6
 set 4,(iy-128)         ; DD CB 80 E6
 set 4,a                ; CB E7
 set 4,a'               ; 76 CB E7
 set 4,b                ; CB E0
 set 4,b'               ; 76 CB E0
 set 4,c                ; CB E1
 set 4,c'               ; 76 CB E1
 set 4,d                ; CB E2
 set 4,d'               ; 76 CB E2
 set 4,e                ; CB E3
 set 4,e'               ; 76 CB E3
 set 4,h                ; CB E4
 set 4,h'               ; 76 CB E4
 set 4,l                ; CB E5
 set 4,l'               ; 76 CB E5
 set 5,(hl)             ; CB EE
 set 5,(ix)             ; FD CB 00 EE
 set 5,(ix+127)         ; FD CB 7F EE
 set 5,(ix-128)         ; FD CB 80 EE
 set 5,(iy)             ; DD CB 00 EE
 set 5,(iy+127)         ; DD CB 7F EE
 set 5,(iy-128)         ; DD CB 80 EE
 set 5,a                ; CB EF
 set 5,a'               ; 76 CB EF
 set 5,b                ; CB E8
 set 5,b'               ; 76 CB E8
 set 5,c                ; CB E9
 set 5,c'               ; 76 CB E9
 set 5,d                ; CB EA
 set 5,d'               ; 76 CB EA
 set 5,e                ; CB EB
 set 5,e'               ; 76 CB EB
 set 5,h                ; CB EC
 set 5,h'               ; 76 CB EC
 set 5,l                ; CB ED
 set 5,l'               ; 76 CB ED
 set 6,(hl)             ; CB F6
 set 6,(ix)             ; FD CB 00 F6
 set 6,(ix+127)         ; FD CB 7F F6
 set 6,(ix-128)         ; FD CB 80 F6
 set 6,(iy)             ; DD CB 00 F6
 set 6,(iy+127)         ; DD CB 7F F6
 set 6,(iy-128)         ; DD CB 80 F6
 set 6,a                ; CB F7
 set 6,a'               ; 76 CB F7
 set 6,b                ; CB F0
 set 6,b'               ; 76 CB F0
 set 6,c                ; CB F1
 set 6,c'               ; 76 CB F1
 set 6,d                ; CB F2
 set 6,d'               ; 76 CB F2
 set 6,e                ; CB F3
 set 6,e'               ; 76 CB F3
 set 6,h                ; CB F4
 set 6,h'               ; 76 CB F4
 set 6,l                ; CB F5
 set 6,l'               ; 76 CB F5
 set 7,(hl)             ; CB FE
 set 7,(ix)             ; FD CB 00 FE
 set 7,(ix+127)         ; FD CB 7F FE
 set 7,(ix-128)         ; FD CB 80 FE
 set 7,(iy)             ; DD CB 00 FE
 set 7,(iy+127)         ; DD CB 7F FE
 set 7,(iy-128)         ; DD CB 80 FE
 set 7,a                ; CB FF
 set 7,a'               ; 76 CB FF
 set 7,b                ; CB F8
 set 7,b'               ; 76 CB F8
 set 7,c                ; CB F9
 set 7,c'               ; 76 CB F9
 set 7,d                ; CB FA
 set 7,d'               ; 76 CB FA
 set 7,e                ; CB FB
 set 7,e'               ; 76 CB FB
 set 7,h                ; CB FC
 set 7,h'               ; 76 CB FC
 set 7,l                ; CB FD
 set 7,l'               ; 76 CB FD
 sla (hl)               ; CB 26
 sla (ix)               ; FD CB 00 26
 sla (ix+127)           ; FD CB 7F 26
 sla (ix-128)           ; FD CB 80 26
 sla (iy)               ; DD CB 00 26
 sla (iy+127)           ; DD CB 7F 26
 sla (iy-128)           ; DD CB 80 26
 sla a                  ; CB 27
 sla b                  ; CB 20
 sla c                  ; CB 21
 sla d                  ; CB 22
 sla e                  ; CB 23
 sla h                  ; CB 24
 sla l                  ; CB 25
 sra (hl)               ; CB 2E
 sra (ix)               ; FD CB 00 2E
 sra (ix+127)           ; FD CB 7F 2E
 sra (ix-128)           ; FD CB 80 2E
 sra (iy)               ; DD CB 00 2E
 sra (iy+127)           ; DD CB 7F 2E
 sra (iy-128)           ; DD CB 80 2E
 sra a                  ; CB 2F
 sra b                  ; CB 28
 sra c                  ; CB 29
 sra d                  ; CB 2A
 sra e                  ; CB 2B
 sra h                  ; CB 2C
 sra l                  ; CB 2D
 srl (hl)               ; CB 3E
 srl (ix)               ; FD CB 00 3E
 srl (ix+127)           ; FD CB 7F 3E
 srl (ix-128)           ; FD CB 80 3E
 srl (iy)               ; DD CB 00 3E
 srl (iy+127)           ; DD CB 7F 3E
 srl (iy-128)           ; DD CB 80 3E
 srl a                  ; CB 3F
 srl b                  ; CB 38
 srl c                  ; CB 39
 srl d                  ; CB 3A
 srl e                  ; CB 3B
 srl h                  ; CB 3C
 srl l                  ; CB 3D
 sub (hl)               ; 96
 sub (ix)               ; FD 96 00
 sub (ix+127)           ; FD 96 7F
 sub (ix-128)           ; FD 96 80
 sub (iy)               ; DD 96 00
 sub (iy+127)           ; DD 96 7F
 sub (iy-128)           ; DD 96 80
 sub -128               ; D6 80
 sub 127                ; D6 7F
 sub 255                ; D6 FF
 sub a                  ; 97
 sub a',(hl)            ; 76 96
 sub a',(ix)            ; 76 FD 96 00
 sub a',(ix+127)        ; 76 FD 96 7F
 sub a',(ix-128)        ; 76 FD 96 80
 sub a',(iy)            ; 76 DD 96 00
 sub a',(iy+127)        ; 76 DD 96 7F
 sub a',(iy-128)        ; 76 DD 96 80
 sub a',-128            ; 76 D6 80
 sub a',127             ; 76 D6 7F
 sub a',255             ; 76 D6 FF
 sub a',a               ; 76 97
 sub a',b               ; 76 90
 sub a',c               ; 76 91
 sub a',d               ; 76 92
 sub a',e               ; 76 93
 sub a',h               ; 76 94
 sub a',l               ; 76 95
 sub a,(hl)             ; 96
 sub a,(ix)             ; FD 96 00
 sub a,(ix+127)         ; FD 96 7F
 sub a,(ix-128)         ; FD 96 80
 sub a,(iy)             ; DD 96 00
 sub a,(iy+127)         ; DD 96 7F
 sub a,(iy-128)         ; DD 96 80
 sub a,-128             ; D6 80
 sub a,127              ; D6 7F
 sub a,255              ; D6 FF
 sub a,a                ; 97
 sub a,b                ; 90
 sub a,c                ; 91
 sub a,d                ; 92
 sub a,e                ; 93
 sub a,h                ; 94
 sub a,l                ; 95
 sub b                  ; 90
 sub c                  ; 91
 sub d                  ; 92
 sub e                  ; 93
 sub h                  ; 94
 sub l                  ; 95
 xor (hl)               ; AE
 xor (ix)               ; FD AE 00
 xor (ix+127)           ; FD AE 7F
 xor (ix-128)           ; FD AE 80
 xor (iy)               ; DD AE 00
 xor (iy+127)           ; DD AE 7F
 xor (iy-128)           ; DD AE 80
 xor -128               ; EE 80
 xor 127                ; EE 7F
 xor 255                ; EE FF
 xor a                  ; AF
 xor a',(hl)            ; 76 AE
 xor a',(ix)            ; 76 FD AE 00
 xor a',(ix+127)        ; 76 FD AE 7F
 xor a',(ix-128)        ; 76 FD AE 80
 xor a',(iy)            ; 76 DD AE 00
 xor a',(iy+127)        ; 76 DD AE 7F
 xor a',(iy-128)        ; 76 DD AE 80
 xor a',-128            ; 76 EE 80
 xor a',127             ; 76 EE 7F
 xor a',255             ; 76 EE FF
 xor a',a               ; 76 AF
 xor a',b               ; 76 A8
 xor a',c               ; 76 A9
 xor a',d               ; 76 AA
 xor a',e               ; 76 AB
 xor a',h               ; 76 AC
 xor a',l               ; 76 AD
 xor a,(hl)             ; AE
 xor a,(ix)             ; FD AE 00
 xor a,(ix+127)         ; FD AE 7F
 xor a,(ix-128)         ; FD AE 80
 xor a,(iy)             ; DD AE 00
 xor a,(iy+127)         ; DD AE 7F
 xor a,(iy-128)         ; DD AE 80
 xor a,-128             ; EE 80
 xor a,127              ; EE 7F
 xor a,255              ; EE FF
 xor a,a                ; AF
 xor a,b                ; A8
 xor a,c                ; A9
 xor a,d                ; AA
 xor a,e                ; AB
 xor a,h                ; AC
 xor a,l                ; AD
 xor b                  ; A8
 xor c                  ; A9
 xor d                  ; AA
 xor e                  ; AB
 xor h                  ; AC
 xor l                  ; AD
