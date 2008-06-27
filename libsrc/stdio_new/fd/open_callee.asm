; int __CALLEE__ open_callee(char *filename, int flags)
; 06.2008 aralbrec

XLIB open_callee
XDEF ASMDISP_OPEN_CALLEE, LIBDISP_OPEN_CALLEE

LIB stdio_malloc, stdio_free, l_jphl, fd_findslot
LIB stdio_error_enfile_mc, stdio_error_edevnf_mc, stdio_error_enomem_mc, stdio_error_mc
XREF _zdevtbl, _zdefdev

INCLUDE "stdio.def"

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
   ; exit  : hl = fd, de = fdstruct, carry reset if successful
   ;         hl = -1, carry set for fail
   ; uses  : all except iy, af'

   ; 1. find the device driver
   ;
   ; de = char *filename
   ;  c = flags
   
   ld a,(de)
   inc de
   
   or a                       ; filename empty?
   jr z, usedefault           ; if so use the default device
   ld b,a                     ; b = device id
   
   ld a,(de)
   cp '>'                     ; device sentinel present?
   jr nz, usedefault          ; if not use the default device
   
   inc de                     ; advance past "X>" in filename
   ld hl,_zdevtbl-1           ; devices table

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
   ld ixh,a                    ; ix = device message interpretter

.driverfound
.libentry
   
   ; 2. locate empty slot in fd table
   ;
   ;  c = flags
   ; de = char *filename
   ; ix = device msg interpretter
   
   call fd_findslot
   jp c, stdio_error_enfile_mc ; fd table is full

   ; 3. create fdstruct
   ;
   ;  b = MAXFILES - fd
   ;  c = flags
   ; hl = MSB of fdtbl entry
   ; de = char *filename
   ; ix = device msg int

   exx
   
   ld b,(ix-1)
   ld c,(ix-2)                 ; bc = bytes required by driver to maintain state
   
   ld a,FDSTR_SZ               ; a = sizeof(fdstruct)
   add a,c
   ld c,a
   jr nc, noinc
   inc b

.noinc                         ; bc = total fdstruct size

   call stdio_malloc
   jp nc, stdio_error_enomem_mc
   
   ; hl = fdstruct
   ; ix = device message interpretter
   
   ld (hl),205                 ; write call instruction
   inc hl
   ld a,ixl
   ld (hl),a                   ; store message interpretter address
   inc hl
   ld a,ixh
   ld (hl),a
   inc hl

   push hl
   exx

   ;  b = MAXFILES - fd
   ;  c = flags
   ; hl = MSB of fdtbl entry
   ; de = char *filename
   ; stack = fdstruct.flags0

   ex (sp),hl                  ; hl = fdstruct.flags0
   push bc

   ld a,c
   and $07
   ld (hl),a                   ; fdstruct.flags0
   inc hl
   ld (hl),0                   ; fdstruct.flags1
   inc hl
   ld (hl),1                   ; reference count = 1
   
   ; 4. get device driver to open file
   ;
   ;  c = flags
   ; de = char *filename
   ; hl = fdstruct.refcount
   ; stack = MSB of fdtbl entry, MSB = MAXFILES - fd
 
   ld a,c
   ld bc,-5
   add hl,bc
   ld b,a
   ld c,STDIO_MSG_OPEN
   push hl
   call l_jphl                 ; call device driver
   pop de                      ; de = fdstruct
   pop bc
   pop hl
   jr c, fail                  ; device driver returned error

   ; 5. make entry in fdtable
   ;
   ; de = fdstruct
   ; hl = MSB of fdtbl entry
   ;  b = MAXFILES - fd

   ld (hl),d                   ; write fdstruct into fdtbl
   dec hl
   ld (hl),e

   ld a,MAXFILES
   sub b
   ld l,a
   ld h,0                      ; hl = fd number
   ret

.usedefault

   dec de
   
   ld ix,(_zdefdev)
   ld a,ixh
   or ixl
   jr nz, driverfound
   
   jp stdio_error_edevnf_mc

.fail

   ex de,hl
   call stdio_free             ; free the fdstruct
   jp stdio_error_mc

defc ASMDISP_OPEN_CALLEE = asmentry - open_callee
defc LIBDISP_OPEN_CALLEE = libentry - open_callee
