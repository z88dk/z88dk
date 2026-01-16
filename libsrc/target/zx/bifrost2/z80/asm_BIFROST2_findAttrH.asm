; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost2

PUBLIC asm_BIFROST2_findAttrH

asm_BIFROST2_findAttrH:

; L=lin
; C=col

        ld h,102        ; HL=lookup/2+lin
        add hl,hl       ; HL=lookup+2*lin
        inc c           ; C=col+1
        srl c           ; C=INT((col-1)/2)+1
        ex af,af'       ; preserve ((col-1)%2)
        ld a,c          ; A=INT((col-1)/2)+1
        ld e,0          ; AE=256*INT((col-1)/2)+256
        rra
        rr e            ; AE=128*INT((col-1)/2)+128
        add a,c         ; AE=384*INT((col-1)/2)+384
        ld d,a          ; DE=384*INT((col-1)/2)+384
        add hl,de       ; HL=384*INT((col-1)/2)+384+lookup+2*lin
        ld e,(hl)
        inc hl
        ld d,(hl)       ; DE=PEEK (384*INT((col-1)/2)+384+lookup+2*lin)
        ex de,hl        ; HL=PEEK (384*INT((col-1)/2)+384+lookup+2*lin)
        ex af,af'
        ret nc
        inc hl          ; HL=PEEK (384*INT((col-1)/2)+384+lookup+2*lin)+((col-1)%2)
        ret
