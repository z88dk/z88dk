
	SECTION		bss_clib

	PUBLIC		__tms9918_screen_mode
	PUBLIC		__tms9918_attribute
	PUBLIC		__tms9918_border
        PUBLIC  RG0SAV          ;keeping track of VDP register values
        PUBLIC  RG1SAV
        PUBLIC  RG2SAV
        PUBLIC  RG3SAV
        PUBLIC  RG4SAV
        PUBLIC  RG5SAV
        PUBLIC  RG6SAV
        PUBLIC  RG7SAV


__tms9918_screen_mode:	defb	0
RG0SAV:         defb    0       ;keeping track of VDP register values
RG1SAV:         defb    0
RG2SAV:         defb    0
RG3SAV:         defb    0
RG4SAV:         defb    0
RG5SAV:         defb    0
RG6SAV:         defb    0
RG7SAV:         defb    0

	SECTION		data_clib

__tms9918_attribute:	defb	$f1	;white on black
__tms9918_border:	defb	$01	;black border

	
