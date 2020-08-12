;       Z88 Small C+ Run Time Library 
;       Long functions
;	"8080" mode
;	Stefano - 29/4/2002
;

                SECTION   code_crt0_sccz80
                PUBLIC	l_long_and
		EXTERN	__retloc

;Logical routines for long functions    dehl
;first opr on stack


.l_long_and   
IF __CPU_GBZ80__
	pop	bc	;Return address
	push	hl	;Low word
	ld	hl,__retloc
	ld	(hl),c
	inc	hl
	ld	(hl),b
	pop	bc
ELSE
	ex	(sp),hl
	ld	(__retloc),hl
	pop	bc
ENDIF
        
IF __CPU_GBZ80__
	ld	hl,sp+0
ELSE
        ld      hl,0
        add     hl,sp   ;points to hl on stack
ENDIF

        ld      a,c
        and     (hl)
        inc     hl
        ld      c,a

        ld      a,b
        and     (hl)
        inc     hl
        ld      b,a

        ld      a,e
        and     (hl)
        inc     hl
        ld      e,a

        ld      a,d
        and     (hl)
	inc	hl
        ld      d,a

	ld	sp,hl
IF __CPU_GBZ80__
	ld	hl,__retloc
	ld	a,(hl+)
	ld	h,(hl)
	ld	l,a
	push	hl
ELSE
	ld	hl,(__retloc)
	push	hl
ENDIF
	
        ld      l,c     ;get the lower 16 back into hl
        ld      h,b
	ret
