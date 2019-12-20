;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 30 September 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***

; This doesn't check for validity of filename at all.
;
; -----
; $Id: mkdir.asm,v 1.8 2016-03-06 21:56:32 dom Exp $

                INCLUDE "fileio.def"
                INCLUDE "stdio.def"
                INCLUDE "dor.def"
                INCLUDE "error.def"

		SECTION	  code_clib
                PUBLIC    mkdir
                PUBLIC    _mkdir

;int mkdir(char *s1,int mode)
;on stack:
;return address,mode,s1
;s1=filename of directory to make

.mkdir
._mkdir
;Repeating stuff from fopen, very bad but...
	push	ix		;save callers ix
        ld      d,OP_DIR        ;make directory
;Try to open the file
;d=access mode..
;Create some room on the stack for the filename to be expanded into..
.fopen_try
        ld      hl,-10
        add     hl,sp
        ld      sp,hl
;So, d=mode, hl=where to expand filename to...
        ld      b,d     ;keep open specifier
        ex      de,hl   ;put this in final place
        ld      c,8     ;max chars to expand..
;Now, find the filename!
        ld      hl,4+10+2
        add     hl,sp
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a     ;hl should point to filename
        ld      a,b     ;open type
        ld      b,0     ;absolute page
        call_oz(gn_opf)
        ex      af,af'  ;keep our flags!
        ld      hl,10
        add     hl,sp
        ld      sp,hl   ;restore our stack (we did nothing to it!)
        ex      af,af'
;ix is our dor handle
        ld      hl,1
        jr	c,mkdir_exit	;failed to create
;Now we have to free the directory dor
        ld      a,dr_fre
        call_oz(os_dor)
        ld      hl,0            ;success
mkdir_exit:
	pop	ix		;restore callers ix
        ret


