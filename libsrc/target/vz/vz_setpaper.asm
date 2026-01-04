;*****************************************************
;
;	Video Technology library for small C compiler
;
;		Jason Oakley
;
;*****************************************************

; ----- void __FASTCALL__ vz_setpaper(int n)

    SECTION code_clib
    PUBLIC  vz_setpaper
    PUBLIC  _vz_setpaper

vz_setpaper:
_vz_setpaper:

    ld     a, l
    cp     $00
    jr     z,setbg1
	ld     a,($783B)
	set    4,a
	ld     ($6800),a
	ld     ($783B),a
	ret
setbg1:		
    ld     a,($783B)
    res    4,a
    ld     ($6800),a
    ld     ($783B),a
    ret