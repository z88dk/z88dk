; unsigned char esx_f_open(unsigned char *filename,unsigned char mode)

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_f_open

EXTERN __esxdos_error_mc

asm_esx_f_open:

   ; enter : hl = char *filename
   ;          a = mode
   ;
   ; exit  : success
   ;
   ;            h = 0
   ;            l = file handle
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl, ix

   and ~__esx_mode_use_header  ; make sure +3 header is disabled
   ld b,a
   
   ld a,'*'
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_OPEN

   ld l,a
   ld h,0
   
   ret nc
   jp __esxdos_error_mc


; ***************************************************************************
; * F_OPEN ($9a) *
; ***************************************************************************
; Open a file.
; Entry:
; A=drive specifier (overridden if filespec includes a drive)
; IX=filespec, null-terminated
; B=access modes, a combination of:
; any/all of:
; esx_mode_read $01 request read access
; esx_mode_write $02 request write access
; esx_mode_use_header $40 read/write +3DOS header
; plus one of:
; esx_mode_open_exist $00 only open existing file
; esx_mode_open_creat $08 open existing or create file
; esx_mode_creat_noexist $04 create new file, error if exists
; esx_mode_creat_trunc $0c create new file, delete existing
;
; DE=8-byte buffer with/for +3DOS header data (if specified in mode)
; (NB: filetype will be set to $ff if headerless file was opened)
; Exit (success):
; Fc=0
; A=file handle
; Exit (failure):
; Fc=1
; A=error code
