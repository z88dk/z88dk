; int __CALLEE__ open_callee(char *filename, int flags)
; 06.2008 aralbrec

PUBLIC open_callee
PUBLIC ASMDISP_OPEN_CALLEE, LIBDISP_OPEN_CALLEE

EXTERN stdio_malloc, stdio_free, l_jpix, stdio_findfdslot
EXTERN stdio_error_enfile_mc, stdio_error_edevnf_mc, stdio_error_enomem_mc, stdio_error_mc
EXTERN _stdio_devtbl, _stdio_defdev

INCLUDE "../stdio.def"

.open_callee

   pop hl
   pop bc
   pop de
   push hl

.asmentry

   ; enter : de = char *filename
   ;          c = flags
   ;              0000 CIOA
   ;              CA = 00, do not create, file must exist
   ;              CA = 01, create file if nec but no truncate if exists 
   ;              CA = 10, create and/or truncate file
   ;              CA = 11, create and/or truncate file
   ;               I =  1, file open for reading
   ;               O =  1, file open for writing
   ;               A =  1, writes append to end of file
   ; exit  : hl = fd, ix = fdstruct *, carry reset if successful
   ;         hl = -1, carry set for fail
   ; uses  : all except iy, af'

   ; 1. find the device driver
   ;
   ; de = char *filename
   ;  c = flags
   
   ld a,d                     ; NULL filename?
   or e
   jr z, usedefault
   
   ld a,(de)
   or a                       ; filename empty?
   jr z, usedefault           ; if so use the default device
   
   inc de
   ld b,a                     ; b = device id
   
   ld a,(de)
   cp '>'                     ; device sentinel present?
   jr nz, usedefault - 1      ; if not use the default device
   
   inc de                     ; advance past "X>" in filename
   ld hl,_stdio_devtbl - 1    ; devices table

.loop0

   inc hl
   ld a,(hl)
   inc hl
   
   or a                        ; if we reached the end of the device table
   jp z, stdio_error_edevnf_mc ; indicate device not found
   
   cp b                        ; table device entry id matches?
   
   ld a,(hl)
   inc hl
   jr nz, loop0                ; no match, check next entry
   
   ld ixl,a
   ld a,(hl)
   ld ixh,a                    ; ix = device driver

.driverfound
.libentry
   
   ; 2. locate empty slot in fd table
   ;
   ;  c = flags
   ; de = char *filename
   ; ix = device driver
   
   call stdio_findfdslot
   jp c, stdio_error_enfile_mc ; fd table is full

   ; 3. create fdstruct
   ;
   ;  b = STDIO_NUMFD - fd
   ;  c = flags
   ; hl = MSB of fdtbl entry
   ; de = char *filename
   ; ix = device driver

   exx
   
   ld c,(ix-2)
   ld b,(ix-1)                 ; bc = bytes required by driver to maintain state
   
   ld a,STDIO_SIZEOF_FDSTRUCT
   add a,c
   ld c,a
   jr nc, noinc
   inc b

.noinc                         ; bc = total fdstruct size

   call stdio_malloc
   jp nc, stdio_error_enomem_mc
   
   ; hl = fdstruct
   ; ix = device driver
   
   push hl
   
   ld (hl),205                 ; write call instruction
   inc hl
   ld a,ixl
   ld (hl),a                   ; store device driver address
   inc hl
   ld a,ixh
   ld (hl),a

   pop ix                      ; ix = fdstruct
   exx

   ;  b = STDIO_NUMFD - fd
   ;  c = flags
   ; hl = MSB of fdtbl entry
   ; de = char *filename
   ; ix = fdstruct

   ld a,c
   and $07
   ld (ix+3),a                 ; store fdstruct flags
   ld (ix+4),1                 ; store reference count = 1
   
   ; 4. get device driver to open file
   ;
   ;  b = STDIO_NUMFD - fd
   ;  c = flags
   ; de = char *filename
   ; hl = MSB of fdtbl entry
   ; ix = fdstruct
 
   push bc
   push hl
   ld a,STDIO_MSG_OPEN
   call l_jpix                 ; call device driver
   pop hl
   pop bc
   jr c, fail                  ; device driver returned error

   ; 5. make entry in fdtable
   ;
   ; ix = fdstruct
   ; hl = MSB of fdtbl entry
   ;  b = STDIO_NUMFD - fd

   ld a,ixh
   ld (hl),a                   ; write fdstruct into fdtbl
   dec hl
   ld a,ixl
   ld (hl),a

   ld a,STDIO_NUMFD
   sub b
   ld l,a
   ld h,0                      ; hl = fd number
   ret

   dec de
   
.usedefault

   ld ix,(_stdio_defdev)
   ld a,ixh
   or ixl
   jr nz, driverfound
   
   jp stdio_error_edevnf_mc

.fail

   push ix
   pop hl
   call stdio_free             ; free the fdstruct
   jp stdio_error_mc

defc ASMDISP_OPEN_CALLEE = # asmentry - open_callee
defc LIBDISP_OPEN_CALLEE = # libentry - open_callee
