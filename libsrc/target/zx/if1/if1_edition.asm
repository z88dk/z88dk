;
;       ZX IF1 & Microdrive functions
;
;       Stefano Bodrato - Jan. 2010
;
;
;       int (if1_issue);
;        - detect the Interface 1 shadow rom edition version
;
;       $Id: if1_edition.asm,v 1.3 2016-07-01 22:08:20 dom Exp $
;

		SECTION   code_clib
                PUBLIC    if1_edition
                PUBLIC    _if1_edition

if1_edition:     ; start creating an 'M' channel
_if1_edition:     ; start creating an 'M' channel

                rst     8
                defb    31h             ; Create Interface 1 system vars if required

                ld      hl,paged
                ld      (5CEDh),hl      ; Location for hook 32h to jump to

                rst     8               ; Call 'paged' with shadow paged in
                defb    32h             ; (in other words: page in the shadow ROM)

paged:
                set     0,(iy+7Ch)      ; FLAGS3: reset the "executing extended command" flag

        ; update jump table
                ld      a,(10A5h)
                or      a
                ld		hl,1			; ROM v1
                jr      z,finish

                inc		hl

                ld      a,(1fe4h)		; first byte of SCAN_M if issue 2
                cp		205
                jr		z,finish		; ROM v2
                
                inc		hl
                
                ld		a,(1fe6h)		; basing on an old paper, it should be the
										; first byte of SCAN_M in issue 3 IF1
                cp		205
                jr		z,finish		; ROM v3
                
                inc		hl				; anoother version ?   never heard about it, but..

finish:
                
                pop     bc              ; throw away some garbage
                pop     bc              ; ... from the stack
                
                ret
