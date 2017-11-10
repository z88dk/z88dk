;
;       Amstrad CPC library
; ******************************************************
; **       Librería de rutinas para Amstrad CPC       **
; **	   Raúl Simarro, 	  Artaburu 2009           **
; ******************************************************
;
;       $Id: cpc_GetScrAddress0.asm $
;

        SECTION   code_clib
        PUBLIC    cpc_GetScrAddress0


.cpc_GetScrAddress0
; coordinates are in (A,L)
	
;LD A,H
LD (inc_ancho+1),A
LD A,L
SRL A
SRL A
SRL A
; A indica el bloque a multiplicar x &50
LD D,A						;D
SLA A
SLA A
SLA A
SUB L
NEG
; A indica el desplazamiento a multiplicar x &800
LD E,A						;E
LD L,D
LD H,0
ADD HL,HL
LD BC,BLOQUES
ADD HL,BC
;HL APUNTA AL BLOQUE BUSCADO
LD C,(HL)
INC HL
LD H,(HL)
LD L,C
;HL TIENE EL VALOR DEL BLOQUE DE 8 BUSCADO


PUSH HL
LD D,0
LD HL,SUB_BLOQUES
ADD HL,DE
LD A,(HL)
POP HL

ADD H
LD H,A
.inc_ancho
LD E,0
;LD D,0
ADD HL,DE

RET


.BLOQUES
defw $C000,$C050,$C0A0,$C0F0,$C140,$C190,$C1E0,$C230,$C280,$C2D0,$C320,$C370,$C3C0,$C410,$C460,$C4B0,$C500,$C550,$C5A0,$C5F0,$C640,$C690,$C6E0,$C730,$C780
.SUB_BLOQUES
defb $00,$08,$10,$18,$20,$28,$30,$38
