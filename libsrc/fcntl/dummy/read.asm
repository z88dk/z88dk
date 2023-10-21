; Dummy function to keep rest of libs happy
;
; $Id: read.asm,v 1.4 2016-03-06 21:39:54 dom Exp $
;

        SECTION code_clib

        PUBLIC  read
        PUBLIC  _read
        PUBLIC  ___read

read:
_read:
___read:
        ret
