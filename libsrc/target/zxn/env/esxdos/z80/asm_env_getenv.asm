; char *env_getenv(unsigned char handle,const char *name,char *val,unsigned int valsz,void *buf,unsigned int bufsz)

INCLUDE "config_private.inc"

SECTION code_env

PUBLIC asm_env_getenv

EXTERN error_zc, error_znc
EXTERN l_jpix, l_ret, l_minu_bc_hl

EXTERN __env_name_sm, __env_value_sm
EXTERN __env_qualify_name

asm_env_getenv:

   ; Search for "name = value" pair in file and return value in val if found.
   ; Must hold exclusive access to environment file while searching it.
   ;
   ; enter : hl = char *name
   ;         de = char *val
   ;         bc = valsz not including space for terminating 0 > 0
   ;
   ;          e'= file handle
   ;         hl'= char *buf
   ;         bc'= bufsz > 0
   ;
   ; exit  : success if valsz == 0
   ;
   ;            hl = length of value string (val not written)
   ;            carry reset
   ;
   ;         success if valsz != 0
   ;
   ;            hl = char *val, zero terminated value written into buffer
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix

   push de                     ; save val
   push bc                     ; save valsz
   
   ; qualify name
   
   push hl
   
   call __env_qualify_name
   
   pop de
   jp nc, error_zc - 2         ; if name string is invalid

   ld bc,0                     ; file position
   ld ix,__env_name_sm         ; enter name search state machine

   exx

buf_loop:

   ;  e = file handle
   ; hl = buf
   ; bc = bufsz
   ; bc'= file position
   ; de'= char *name
   ; hl', ix = state
   ; stack = val, valsz

   ; load buffer
   
   push de                     ; save handle
   push bc                     ; save bufsz
   push hl                     ; save buf
   
   ld a,e

IF __SDCC_IY

   push hl
   pop iy

ELSE

   push ix

   push hl
   pop ix

ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_READ
   
IF __SDCC_IY

ELSE

   pop ix

ENDIF

   pop hl
   
   ; hl = buf
   ; bc = actual bytes read
   ; bc'= file position
   ; de'= char *name
   ; hl', ix = state
   ; stack = val, valsz, handle, bufsz
   
   jp c, error_zc - 4          ; if read error
   
   ld a,b
   or c
   
   jp z, error_zc - 4          ; if eof reached
   
   push hl

   ; name search loop
   
name_loop:

   ld a,(hl)
   
   exx

   ; hl'= buf
   ; bc'= actual bytes read
   ;  a = current char
   ; bc = file position
   ; de = char *name
   ; hl,ix = state
   ; stack = val, valsz, handle, bufsz, buf

   call l_jpix                 ; name match
   jr c, name_matched
   
   inc bc                      ; file position++
   
   exx
   
   cpi                         ; hl++, bc--
   jp pe, name_loop

   ; bc'= file position
   ; de'= char *name
   ; hl', ix = state
   ; stack = val, valsz, handle, bufsz, buf

   pop hl
   pop bc
   pop de
   
   jr buf_loop

name_matched:

   ; hl'= buf
   ; bc'= actual bytes read
   ;  a = current char
   ; bc = file position
   ; stack = val, valsz, handle, bufsz, buf
   
   ld ix,__env_value_sm        ; enter value state machine
   
   ld e,c
   ld d,b                      ; de = position of value
   
   exx
   
value_loop:

   exx
   
   call l_jpix
   jr nc, value_found

   ; hl'= buf
   ; bc'= actual bytes read
   ; bc = file position
   ; de = position of value
   ; hl, ix = state
   ; stack = val, valsz, handle, bufsz, buf
   
   inc bc                      ; file position++

   exx
   
   cpi                         ; hl++, bc--
   ld a,(hl)                   ; current char
   
   jp pe, value_loop
   
   ; bc'= file position
   ; de'= position of value
   ; hl', ix = state
   ; stack = val, valsz, handle, bufsz, buf

buf_load:

   pop hl                      ; hl = buf
   pop bc                      ; bc = bufsz
   pop de                      ;  e = handle
   
   push de
   push bc
   push hl
   
   ld a,e

IF __SDCC_IY

   push hl
   pop iy

ELSE

   push ix

   push hl
   pop ix

ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_READ
   
IF __SDCC_IY

ELSE

   pop ix

ENDIF

   pop hl
   
   ; hl = buf
   ; bc = actual bytes read
   ; bc'= file position
   ; de'= position of value
   ; hl', ix = state
   ; stack = val, valsz, handle, bufsz
   
   jp c, error_zc - 4          ; if read error

   push hl

   ld a,b
   or c

   jr z, value_found_exx       ; if eof reached

   ld a,(hl)                   ; a = current char
   jr value_loop

value_found_exx:

   exx

value_found:

   ; carry reset

   sbc hl,de

   ; de = position of value
   ; hl = length of value
   ; stack = val, valsz, handle, bufsz, buf

   pop bc
   pop bc
   pop bc

   ;  c = handle
   ; de = position of value
   ; hl = length of value
   ; stack = val, valsz

   ex (sp),hl
   
   ld a,h
   or l
   
   jp z, l_ret - 2             ; if valsz == 0 return length of value string

   push hl
   push bc
   
   ;  c = handle
   ; de = position of value
   ; stack = val, length of value, valsz, handle

   ; seek to start of value string
                                                              
   ld a,c
   ld bc,0
   ld l,__esx_seek_set
   
IF __SDCC_IY

   push hl
   pop iy

ELSE

   push hl
   pop ix

ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_SEEK
   
   pop de
   pop bc
   pop hl

   ;  e = handle
   ; bc = valsz
   ; hl = length of value
   ; stack = val
   
   jp c, error_zc - 1          ; if can't seek

   ; write value string to supplied buffer

   call l_minu_bc_hl
   
   ld c,l
   ld b,h                      ; bc = min(valsz, length of value)

   ;  e = handle
   ; bc = length of value
   ; stack = val

   pop hl                      ; hl = val
   push hl                     ; save val
   
   ld a,b
   or c
   
   jr z, zero_terminate        ; if length of value string is zero
   
   push bc                     ; save size

   ld a,e
   
IF __SDCC_IY

   push hl
   pop iy

ELSE

   push hl
   pop ix

ENDIF

   rst __ESX_RST_SYS
   defb __ESX_F_READ
   
   jp c, error_zc - 2          ; if read error
   
   ex (sp),hl                  ; hl = size
   
   sbc hl,bc
   jp nz, error_zc - 2         ; if complete string not read
   
   pop hl

zero_terminate:

   xor a
   ld (hl),a

   pop hl                      ; hl = val
   ret   
