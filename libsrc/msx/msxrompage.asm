;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	Internal function, finalize the external ROM call
;	(safe ROM PAGE-IN / CALL / PAGE-OUT for MSX2)
;	This is the official method suggested by ASCII Corp
;
;	These perhaps could be optimized when in non-MSXDOS environment.
;
;
;	$Id: msxrompage.asm,v 1.4 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
	PUBLIC	msxrompage
	EXTERN	msxbios

        INCLUDE "msxbios.def"

	defc H_NMI  = $fdd6

msxrompage:
         push   hl
         ld     hl,$C300

         push   hl           ; push NOP ; JP EXTROM
         push   ix
         ld     hl,$21DD
         push   hl           ; push LD IX,<entry>
         ld     hl,$3333
         push   hl           ; push INC SP; INC SP
         ld     hl,0
         add    hl,sp        ; HL = offset of routine
         ld     a,$C3
         ld     (H_NMI),a
         ld     (H_NMI+1),hl ; JP <routine> in NMI hook
         ex     af,af'
         exx                 ; restore all registers
         ld     ix,NMI
         call	msxbios      ; call NMI-hook via NMI entry in ROMBIOS
                             ; NMI-hook will call SUBROM
         exx
         ex     af,af'       ; store all returned registers
         ld     hl,10
         add    hl,sp
         ld     sp,hl        ; remove routine from stack
         ex     af,af'
         exx                 ; restore all returned registers
         ret
