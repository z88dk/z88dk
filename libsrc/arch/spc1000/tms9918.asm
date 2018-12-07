;
; Variables and functions needed for tms9918 compatibily
;

	MODULE	tms9918
	SECTION	code_clib
	PUBLIC	msxbios


msxbios:
	push	ix
	ret

	SECTION	bss_clib

        PUBLIC  RG0SAV          ;keeping track of VDP register values
        PUBLIC  RG1SAV
        PUBLIC  RG2SAV
        PUBLIC  RG3SAV
        PUBLIC  RG4SAV
        PUBLIC  RG5SAV
        PUBLIC  RG6SAV
        PUBLIC  RG7SAV

RG0SAV:         defb    0       ;keeping track of VDP register values
RG1SAV:         defb    0
RG2SAV:         defb    0
RG3SAV:         defb    0
RG4SAV:         defb    0
RG5SAV:         defb    0
RG6SAV:         defb    0
RG7SAV:         defb    0

	
