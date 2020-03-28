;
;	Routine called when there is no
;	Zsock library/packages installed
;
;	djm 12/2/2000

        SECTION code_clib
	PUBLIC	no_zsock

	EXTERN	exit

	INCLUDE	"stdio.def"


.no_zsock
	ld	hl,message
	call_oz(gn_sop)
	call_oz(os_in)
	ld	hl,0
	jp	exit

	SECTION rodata_clib
.message
        defb   1,'7','#','3',32+7,32+1,32+34,32+7,131     ;dialogue box
        defb   1,'2','C','3',1,'4','+','T','U','R',1,'2','J','C'
        defb   1,'3','@',32,32  ;reset to (0,0)
        defm   "ZSock Library Error"
        defb   1,'3','@',32,32 ,1,'2','A',32+34  ;keep settings for 10
        defb   1,'7','#','3',32+8,32+3,32+32,32+5,128     ;dialogue box
        defb    1,'3','@',32,32,1,'2','J','C'
	defm	"The ZSock shared library could not be opened"
	defb	13,10
	defm	"Please install both ZSock and Installer v2+"
	defb	13,10
	defm	"to use this program correctly"
	defb	13,10
	defm	"ZSock also requires 2 free banks to function"
	defb	13,10
	defm	"correctly - delete files if required"
	defb	13,10
        defb    0
