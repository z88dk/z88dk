;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 30 September 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***

; This doesn't check for validity of filename at all.

                INCLUDE "#fileio.def"
                INCLUDE "#stdio.def"
                INCLUDE "#dor.def"
                INCLUDE "#error.def"

                XLIB    mkdir

;int mkdir(char *s1)
;on stack:
;return address,s1
;s1=filename of directory to make

.mkdir
;Repeating stuff from fopen, very bad but...
        ld      d,op_dir        ;make directory
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
        ld      hl,2+10
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
        ret     c
;Now we have to free the directory dor
        ld      a,dr_fre
        call_oz(os_dor)
        ld      hl,0            ;NULL
        ret


