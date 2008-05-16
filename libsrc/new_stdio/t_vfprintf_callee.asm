; int t_vfprintf_callee(FILE *stream, const char *format, void *arg_ptr)
; 05.2008 aralbrec

XLIB t_vfprintf_callee
LIB stdio_outchar, stdio_atou, vfprintf_jumptbl
XDEF ASMDISP_VFPRINTF_CALLEE

INCLUDE "stdio.def"

.t_vfprintf_callee

   pop hl
   pop bc
   pop de
   pop ix
   push hl

.asmentry

   ; enter : ix  = FILE *
   ;         de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ; exit  : hl  = number of chars output to stream
   ;         carry if stream error: ERRNO set and hl=-1

   ; *** do something with ix to point at output function

   ld hl,-STDIO_TEMPBUFSZ
   add hl,sp
   ld sp,hl
   push bc

   exx
   ld bc,0
   exx
   
   ; bc' = number of chars output to stream = 0
   ; ix  = & attached file / device output function
   ; de  = format string
   ; stack = buffer (STDIO_TEMPBUFSZ bytes), & parameter list

.formatloop

   ; de = pointer in format string
   ; stack = & parameter list
   
   ld a,(de)                   ; next format char
   or a                        ; reached the end of the format string?
   jp z, exitnoerror
   
   inc de
   cp '%'                     
   jr z, specifier

.ordinarychar

   call stdio_outchar          ; output a char onto the stream
   jp nc, formatloop           ; loop if no stream error detected

.exitwitherror
 
   ld hl,STDIO_TEMPBUFSZ + 2   ; remove items from stack
   add hl,sp
   ld sp,hl
   
   ld hl,-1                    ; hl = error value, ERRNO set by stream already
   scf
   ret

.exitnoerror

   exx

   ld hl,STDIO_TEMPBUFSZ + 2   ; remove items from stack
   add hl,sp
   ld sp,hl

   ld l,c
   ld h,b                      ; hl = number of chars written on stream
   or a
   ret

.specifier                     ; '%' already consumed

   ; read format parameters
   ; %{flags}{* | width}[.{* | prec}] [l] "bcdeEfFinopPsuxX"
   
   ld c,0
   
   ; de = pointer in format string
   ;  c = flags [-+ O#P0N]
   ; stack = & parameter list
   
.flagloop

   ld a,(de)                   ; potential flag char
   ld hl,flags
   ld b,5
   
.flagsrch

   cp (hl)                     ; flag char found in table?
   inc hl                      ; move past table flag char
   jr z, flagfound
   inc hl                      ; move past table flag bitmask
   djnz flagsrch               ; loop until flag char not found

.width

   ;  a = current format string char
   ; de = pointer in format string
   ;  c = flags [-+ O#P0N]
   ; stack = & parameter list

   cp '*'
   jr nz, readwidth
   
   ; asterisk means width comes from parameter list
   
   pop hl
   dec hl
   ld b,(hl)
   dec hl
   push hl
   
   inc de                      ; consume *
   jp dot

.flagfound

   ld a,(hl)                   ; read bitmask from table
   inc hl
   or c
   ld c,a                      ; set flag register
   inc de                      ; next format string char
   jp flagloop

.readwidth                     ; read width from format string

   push bc
   call stdio_atou
   pop bc
   ld b,l

.dot

   ;  b = width
   ; de = pointer in format string
   ;  c = flags [-+ O#P0N]
   ; stack = & parameter list

   ld h,1                      ; h = default precision = 1
   ld a,(de)
   cp '.'
   jr nz, formatchar

   inc de                      ; consume .
   set 2,c                     ; indicate precision present in flags

   ld a,(de)
   cp '*'
   jr nz, readprec

   ; asterisk means precision comes from parameter list
   
   pop hl
   dec hl
   ld a,(hl)
   dec hl
   push hl
   ld h,a
   
   inc de                      ; consume *
   jp formatchar

.readprec                      ; read precision from format string

   push bc
   call stdio_atou
   pop bc
   ld h,l
   
.formatchar

   ;  b = width
   ;  h = precision
   ; de = pointer in format string
   ;  c = flags [-+ O#P0N]
   ; stack = & parameter list

   push hl
   ld hl,vfprintf_jumptbl
   ex de,hl

   ;  b = width
   ; hl = pointer in format string
   ;  c = flags [-+ O#P0N]
   ; de = & vfprintf_jumptbl
   ; stack = & parameter list, precision (MSB)

.specsrch

   ld a,(de)                   ; table's format char
   or a
   jr z, fmtcharerror
   
   cp (hl)
   jr z, fmtcharfound
   
   inc de                      ; next table entry
   inc de
   inc de
   inc de
   jp specsrch
   
.fmtcharerror

   ; unrecognized format char
   ; output '%' and consume bad char so that '%%' works
   ; bad things will happen if the format string terminates in '%'
   
   pop af
   ex de,hl
   inc de
   ld a,'%'
   jp ordinarychar

.fmtcharfound

   inc hl                      ; consume format char

   ;  b = width
   ; hl = pointer in format string
   ;  c = flags [-+ O#P0N]
   ; de = & vfprintf_jumptbl.fmtchar
   ; stack = & parameter list, precision (MSB)

   pop af
   ex (sp),hl
   call doformat

   ; return here after formatted output done
   ; stack = pointer in formatted string, & parameter list
   ;         carry set if error on stream, a = (errorno) set appropriately

   pop hl
   ex (sp),hl
   ex de,hl

   ; de = format string
   ; stack = & parameter list

   jp nc, formatloop           ; no error in stream
   jp exitwitherror

.doformat

   inc de
   push de
   
   ;  a = precision
   ;  b = width
   ; hl = & parameter list
   ;  c = flags [-+ O#P0N]
   ; stack = pointer in format string, return address, jump address

   ld d,(hl)                   ; de = 16-bit parameter
   dec hl
   ld e,(hl)
   dec hl

   ; set-up for formatted output functions
   ;
   ; enter :     ix  = & attached file / device output function
   ;               a = precision
   ;               b = width
   ;               c = flags [-+ O#P0N]
   ;              de = 16-bit parameter
   ;              hl = & parameter list
   ;             bc' = total num chars output on stream thus far
   ; on exit :   bc' = total num chars output on stream thus far
   ;         stack = & parameter list
   ;         carry set if error on stream, a = (errorno) set appropriately

   bit 7,d                     ; set negative flag if de < 0
   ret z                       ; doing it here saves a few bytes
   set 0,c
   ret                         ; ret calls formatted output function
   
.flags

   defb '-', 128
   defb '+', 64
   defb ' ', 32
   defb '0', 16
   defb '#', 8

defc ASMDISP_VFPRINTF_CALLEE = asmentry - t_vfprintf_callee
