; stdio_parseperm
; 07.2009 aralbrec

PUBLIC stdio_parseperm

EXTERN strchr_callee
EXTERN ASMDISP_STRCHR_CALLEE

; parse file permissions
;
; flags   0000 CIOA
;         CA = 00, do not create, file must exist
;         CA = 01, create file if nec but no truncate if exists 
;         CA = 10, create and/or truncate file
;         CA = 11, create and/or truncate file
;          I =  1, file open for reading
;          O =  1, file open for writing
;          A =  1, writes append to end of file
;
; "r"     0000 0100
; "rb"    0000 0100
;
; "r+"    0000 0110
; "rb+"   0000 0110
; "r+b"   0000 0110
;
; "rw"    0000 1110
; "rw+"   0000 1110
; "rwb+"  0000 1110
;
; "w"     0000 1010
; "wb"    0000 1010
;
; "w+"    0000 1110
; "wb+"   0000 1110
; "w+b"   0000 1110
;
; "a"     0000 0011
; "ab"    0000 0011
;
; "a+"    0000 0111
; "ab+"   0000 0111
; "a+b"   0000 0111
;
; enter : de = string of file permissions to parse (mode string)
; exit  :  a = b = flags, carry set if permissions string invalid
; uses  : af, bc, de, hl

.stdio_parseperm

   ld b,0

.loop

   ld a,(de)
   or a
   jr z, exit
   
   cp 32                       ; dont want to match flag bytes in permtbl
   ret c
   
   ld c,a
   ld hl,permtbl
   call strchr_callee + ASMDISP_STRCHR_CALLEE
   ret c                       ; invalid char in permission string

   inc hl                      ; hl points at flag byte following permission letter
   ld a,(hl)
   or b
   ld b,a

   inc de                      ; next permission string char to parse
   jp loop

.exit

   ld a,b
   or a
   ret nz
   scf                         ; carry set if permission string empty
   ret

.permtbl

   defb 'r', $04
   defb 'w', $0a
   defb 'a', $03
   defb '+', $06
   defb 'b', $00               ; there is no distinction between binary and text mode
   defb 0
