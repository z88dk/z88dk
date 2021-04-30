SECTION code_clib
PUBLIC getk
PUBLIC _getk

getk:
_getk:
    ld   hl,0
    in   a,($1b)
    bit  2,a
    ret  z
    ld   e,a
    in   a,($1a)
    ld   l,a
    ld   h,0
    ret

;in a,($1b) ;bit 7 = ctrl, 6 = shift, 2 = pressed now, key was pressed

