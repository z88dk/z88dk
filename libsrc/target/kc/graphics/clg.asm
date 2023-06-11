;
;       CLS for the VEB MPM KC85/2..5
;       Stefano - Sept 2016
;
;
;	$Id: clg.asm $
;

		SECTION code_clib
                PUBLIC  clg
                PUBLIC  _clg

                EXTERN  kc_type
                EXTERN  kc_attr

                INCLUDE "target/kc/def/caos.def"

.clg
._clg

        ld      a,(kc_type)
        and     a
        jr      z,clg_not_kc85_4
        ; 85/4 needs to switch back to pixel memory  
        ld      a,(iy+1)
        res     1,a     ;access pixel memory
        ld      (iy+1),a
        out     ($84),a
clg_not_kc85_4:
        ; set window 0 to max size
        ld      a,0
        ld      (WINNR),a
        ld      hl,0
        ld      (WINON),hl
        ld      hl,$2028
        ld      (WINLG),hl
        ; set color
        ld      a,(kc_attr)
        ld      (COLOR),a
        ld      a,$0c ; clear screen
        call    PV1
        defb    FNCRT
        ret
