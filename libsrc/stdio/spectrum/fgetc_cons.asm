;
; Devilishly simple Spectrum Routines
;
; getkey() Wait for keypress
;
; 17/5/99 djm
;
; 22/3/2000 djm Rechristened getchar
; 1/4/2000  djm Rechristened fgetc_cons
;
;
; $Id: fgetc_cons_rom.asm $
;


    SECTION code_clib
    PUBLIC  fgetc_cons
    PUBLIC  _fgetc_cons

    EXTERN in_Inkey

.fgetc_cons
._fgetc_cons
  
  call  in_Inkey
  ld  a,l
  and a
  jr  nz,_fgetc_cons

.fgetc_wait
  call  in_Inkey
  ld  a,l
  and a
  jr  z,fgetc_wait

IF STANDARDESCAPECHARS
  cp  13
  jr  nz,not_return
  ld  l,10
.not_return
ENDIF

  ret
