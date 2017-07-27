 ld a,(-32768)          ; 3A 00 80
 ld a,(32767)           ; 3A FF 7F
 ld a,(65535)           ; 3A FF FF
 ld a,(hl)              ; 7E
 ld a,(ix)              ; DD 7E 00
 ld a,(ix+127)          ; DD 7E 7F
 ld a,(ix-128)          ; DD 7E 80
 ld a,(iy)              ; FD 7E 00
 ld a,(iy+127)          ; FD 7E 7F
 ld a,(iy-128)          ; FD 7E 80
 ld a,-128              ; 3E 80
 ld a,127               ; 3E 7F
 ld a,255               ; 3E FF
 ld a,a                 ; 7F
 ld a,b                 ; 78
 ld a,c                 ; 79
 ld a,d                 ; 7A
 ld a,e                 ; 7B
 ld a,h                 ; 7C
 ld a,ixh               ; DD 7C
 ld a,ixl               ; DD 7D
 ld a,iyh               ; FD 7C
 ld a,iyl               ; FD 7D
 ld a,l                 ; 7D
 ld b,(hl)              ; 46
 ld b,(ix)              ; DD 46 00
 ld b,(ix+127)          ; DD 46 7F
 ld b,(ix-128)          ; DD 46 80
 ld b,(iy)              ; FD 46 00
 ld b,(iy+127)          ; FD 46 7F
 ld b,(iy-128)          ; FD 46 80
 ld b,-128              ; 06 80
 ld b,127               ; 06 7F
 ld b,255               ; 06 FF
 ld b,a                 ; 47
 ld b,b                 ; 40
 ld b,c                 ; 41
 ld b,d                 ; 42
 ld b,e                 ; 43
 ld b,h                 ; 44
 ld b,ixh               ; DD 44
 ld b,ixl               ; DD 45
 ld b,iyh               ; FD 44
 ld b,iyl               ; FD 45
 ld b,l                 ; 45
 ld c,(hl)              ; 4E
 ld c,(ix)              ; DD 4E 00
 ld c,(ix+127)          ; DD 4E 7F
 ld c,(ix-128)          ; DD 4E 80
 ld c,(iy)              ; FD 4E 00
 ld c,(iy+127)          ; FD 4E 7F
 ld c,(iy-128)          ; FD 4E 80
 ld c,-128              ; 0E 80
 ld c,127               ; 0E 7F
 ld c,255               ; 0E FF
 ld c,a                 ; 4F
 ld c,b                 ; 48
 ld c,c                 ; 49
 ld c,d                 ; 4A
 ld c,e                 ; 4B
 ld c,h                 ; 4C
 ld c,ixh               ; DD 4C
 ld c,ixl               ; DD 4D
 ld c,iyh               ; FD 4C
 ld c,iyl               ; FD 4D
 ld c,l                 ; 4D
 ld d,(hl)              ; 56
 ld d,(ix)              ; DD 56 00
 ld d,(ix+127)          ; DD 56 7F
 ld d,(ix-128)          ; DD 56 80
 ld d,(iy)              ; FD 56 00
 ld d,(iy+127)          ; FD 56 7F
 ld d,(iy-128)          ; FD 56 80
 ld d,-128              ; 16 80
 ld d,127               ; 16 7F
 ld d,255               ; 16 FF
 ld d,a                 ; 57
 ld d,b                 ; 50
 ld d,c                 ; 51
 ld d,d                 ; 52
 ld d,e                 ; 53
 ld d,h                 ; 54
 ld d,ixh               ; DD 54
 ld d,ixl               ; DD 55
 ld d,iyh               ; FD 54
 ld d,iyl               ; FD 55
 ld d,l                 ; 55
 ld e,(hl)              ; 5E
 ld e,(ix)              ; DD 5E 00
 ld e,(ix+127)          ; DD 5E 7F
 ld e,(ix-128)          ; DD 5E 80
 ld e,(iy)              ; FD 5E 00
 ld e,(iy+127)          ; FD 5E 7F
 ld e,(iy-128)          ; FD 5E 80
 ld e,-128              ; 1E 80
 ld e,127               ; 1E 7F
 ld e,255               ; 1E FF
 ld e,a                 ; 5F
 ld e,b                 ; 58
 ld e,c                 ; 59
 ld e,d                 ; 5A
 ld e,e                 ; 5B
 ld e,h                 ; 5C
 ld e,ixh               ; DD 5C
 ld e,ixl               ; DD 5D
 ld e,iyh               ; FD 5C
 ld e,iyl               ; FD 5D
 ld e,l                 ; 5D
 ld h,(hl)              ; 66
 ld h,(ix)              ; DD 66 00
 ld h,(ix+127)          ; DD 66 7F
 ld h,(ix-128)          ; DD 66 80
 ld h,(iy)              ; FD 66 00
 ld h,(iy+127)          ; FD 66 7F
 ld h,(iy-128)          ; FD 66 80
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
 ld ixh,-128            ; DD 26 80
 ld ixh,127             ; DD 26 7F
 ld ixh,255             ; DD 26 FF
 ld ixh,a               ; DD 67
 ld ixh,b               ; DD 60
 ld ixh,c               ; DD 61
 ld ixh,d               ; DD 62
 ld ixh,e               ; DD 63
 ld ixh,ixh             ; DD 64
 ld ixh,ixl             ; DD 65
 ld ixl,-128            ; DD 2E 80
 ld ixl,127             ; DD 2E 7F
 ld ixl,255             ; DD 2E FF
 ld ixl,a               ; DD 6F
 ld ixl,b               ; DD 68
 ld ixl,c               ; DD 69
 ld ixl,d               ; DD 6A
 ld ixl,e               ; DD 6B
 ld ixl,ixh             ; DD 6C
 ld ixl,ixl             ; DD 6D
 ld iyh,-128            ; FD 26 80
 ld iyh,127             ; FD 26 7F
 ld iyh,255             ; FD 26 FF
 ld iyh,a               ; FD 67
 ld iyh,b               ; FD 60
 ld iyh,c               ; FD 61
 ld iyh,d               ; FD 62
 ld iyh,e               ; FD 63
 ld iyh,iyh             ; FD 64
 ld iyh,iyl             ; FD 65
 ld iyl,-128            ; FD 2E 80
 ld iyl,127             ; FD 2E 7F
 ld iyl,255             ; FD 2E FF
 ld iyl,a               ; FD 6F
 ld iyl,b               ; FD 68
 ld iyl,c               ; FD 69
 ld iyl,d               ; FD 6A
 ld iyl,e               ; FD 6B
 ld iyl,iyh             ; FD 6C
 ld iyl,iyl             ; FD 6D
 ld l,(hl)              ; 6E
 ld l,(ix)              ; DD 6E 00
 ld l,(ix+127)          ; DD 6E 7F
 ld l,(ix-128)          ; DD 6E 80
 ld l,(iy)              ; FD 6E 00
 ld l,(iy+127)          ; FD 6E 7F
 ld l,(iy-128)          ; FD 6E 80
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
