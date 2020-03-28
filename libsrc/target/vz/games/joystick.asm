;
;	Game device library for the VZ200 / VZ300
;	Stefano Bodrato - 2018
;
;	$Id: joystick.asm $
;
;		     		:	5	 	4		3		2		1		0
;		---------------------------------------------------------
;		68FEH		:	R	 	Q		E		  		W		T
;		68FDH		:	F 	A		D		CTRL	S		G
;		68FBH		:	V 	Z		C		SHFT	X		B
;		68F7H		:	4 	1		3   			2		5
;		68EFH		:	M 	SPC								N
;		68DFH		:	7 	0		8			  	9		6
;		68BFH		:	U 	P		I		RETN	O		Y
;		687FH		:	J		    K				  L
;		----------------------------------------------------------
;

        SECTION   code_clib
        PUBLIC    joystick
        PUBLIC    _joystick

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
	
	ld	a,l
	dec a	 ; 1-5 :LRDUF
	jr	nz,j_no1
	
	; xxxRLDUF -> xxx41325
	ld	a,($68F7)
	cpl
; xxxFUDLR
	ld b,0
	rra		; 5
	rl b
	rra		; 2
	rl b
	rra
	rra		; 3
	rl b
	rra		; 1
	rl b
	rra		; 4
	rl b
	ld	a,b
	
	jr	j_done

.j_no1

	dec a	 ; 6-0 :LRDUF
	jr	nz,j_no2
	
	; xxxRLDUF -> xxx96870
	ld	a,($68DF)
	cpl
; xxxFUDLR
	ld b,0
	rla
	rla
	
	rla		; 7	(U)
	rl e
	
	rla		; 0 (F)
	rl b
	rr e	; (U)
	rl b
	rla		; 8	(D)
	rl b
	
	rla
	rla	; 9 (R)
	rl e
	rla	; 6 (L)
	rl b
	rr e ; (R)
	rl b
	
	ld	a,b
	
	jr	j_done
	
.j_no2

	dec a	 ; qaop-mn
	jr	nz,j_no3
	
	; xxFFUDLR
	ld	a,($68EF)
	cpl
	ld	e,a
	rla
	rla
	and	@100000	; 'n'
	ld	b,a
	ld	a,e
	rra
	and	@10000	; 'm'
	or	b
	ld	b,a
	ld	a,($68FE)
	cpl
	rra
	and	@1000	; 'q'
	or	b
	ld	b,a	
	ld	a,($68FD)
	cpl
	rra
	rra
	and	@100	; 'a'
	or	b
	ld	b,a
	ld	a,($68BF)
	cpl
	ld	e,a
	and	@10		; 'o'
	or	b
	ld	b,a
	ld	a,e
	rra
	rra
	rra
	rra
	and	1		; 'p'
	or	b
	jr	j_done
	
.j_no3
	xor a
	
.j_done
	ld	h,0
	ld	l,a
	ret
