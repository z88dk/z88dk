; int __CALLEE__ vfprintf_callee(FILE *stream, const char *format, void *arg_ptr)
; 05.2008 aralbrec

PUBLIC vfprintf_callee
EXTERN stdio_outchar, stdio_atou, jumptbl_printf, stdio_nextarg, stdio_error_eacces_mc, stdio_error_mc
PUBLIC ASMDISP_VFPRINTF_CALLEE, LIBDISP_VFPRINTF_CALLEE

INCLUDE "../stdio.def"

.vfprintf_callee

   pop hl
   pop bc
   pop de
   pop ix
   push hl

.asmentry

   ; enter : ix  = FILE *
   ;         de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ; exit  : hl  = number of chars output to stream, carry reset
   ;         hl  = -1 and carry if error

   bit 1,(ix+3)                ; open for output?
   jp z, stdio_error_eacces_mc
   
.libentry

   ; second entry point with ix equal to function address
   ;
   ; enter : ix  = FILE *
   ;         de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ; exit  : hl  = number of chars output to stream
   ;         hl  = -1 and carry if error

   ld hl,-STDIO_TEMPBUFSIZE
   add hl,sp
   ld sp,hl
   push bc

   exx
   ld bc,0
   exx
   
   ; bc' = number of chars output to stream = 0
   ; ix  = FILE *
   ; de  = format string
   ; stack = buffer (STDIO_TEMPBUFSIZE bytes), & parameter list

.formatloop

   ; de = pointer in format string
   ; stack = & parameter list
   
   ld a,(de)                   ; next format char
   or a                        ; reached the end of the format string?
   jr z, exitnoerror
   
   inc de
   cp '%'                     
   jr z, specifier

.ordinarychar

   call stdio_outchar          ; output a char onto the stream
   jp nc, formatloop           ; loop if no stream error detected

.exitwitherror
 
   ld hl,STDIO_TEMPBUFSIZE + 2 ; remove items from stack
   add hl,sp
   ld sp,hl
   jp stdio_error_mc

.exitnoerror

   ld hl,STDIO_TEMPBUFSIZE + 2 ; remove items from stack
   add hl,sp
   ld sp,hl

   exx
   push bc
   exx
   pop hl                      ; hl = number of chars written on stream
   or a
   ret

.specifier                     ; '%' already consumed

   ; read format parameters
   ; %{flags}{* | width}[.{* | prec}] [l] "bcdeEfFinopPsuxX"
   
   ld c,0
   
   ; de = pointer in format string
   ;  c = flags [-+ O#PLN]
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
   ;  c = flags [-+ O#PLN]
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
   ;  c = flags [-+ O#PLN]
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
   ;  c = flags [-+ O#PLN]
   ; stack = & parameter list

   ld a,(de)                   ; check for long specifier
   cp 'l'
   jr nz, nolongspec
   inc de                      ; consume the 'l'
   set 1,c                     ; set long flag

.nolongspec

   push hl
   ld hl,jumptbl_printf
   ex de,hl

   ;  b = width
   ; hl = pointer in format string
   ;  c = flags [-+ O#PLN]
   ; de = & jumptbl_printf
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
   
   pop af
   ex de,hl
   ld a,(de)
   cp '%'                      ; did we see %%
   ld a,'%'
   jp nz, ordinarychar         ; if no, output % but don't advance past the unknown fmt char
   inc de                      ; if %% advance past the second %
   jp ordinarychar

.fmtcharfound

   inc hl                      ; consume format char

   ;  b = width
   ; hl = pointer in format string
   ;  c = flags [-+ O#PLN]
   ; de = & jumptbl_printf.fmtchar
   ; stack = & parameter list, precision (MSB)

   pop af
   ex (sp),hl
   call doformat

   ; return here after formatted output done
   ;    hl = & parameter list
   ; stack = pointer in format string
   ;         carry set if error on stream, ERRNO set appropriately

   pop de
   push hl
   
   ; de = format string
   ; stack = & parameter list

   jp nc, formatloop           ; no error in stream
   jp exitwitherror

.doformat

   inc de
   push de
   
   ;  a = precision (default 1)
   ;  b = width (default 0)
   ;  c = flags [-+ O#PLN]
   ; hl = & parameter list
   ; stack = pointer in format string, ret, format function address
   
   call stdio_nextarg          ; get first 16-bit parameter
   
.callfmtfunc

   ; set-up for formatted output functions
   ;
   ; enter :     ix  = FILE *
   ;               a = precision (default 1)
   ;               b = width (default 0)
   ;               c = flags [-+ O#PLN]
   ;              de = 16-bit parameter (most significant word if long)
   ;              hl = & parameter list
   ;             bc' = total num chars output on stream thus far
   ;             carry flag reset (important for %x, %lx)
   ;           stack = output buffer, ptr in format string, ret
   ; on exit :   bc' = total num chars output on stream thus far
   ;              hl = & parameter list
   ;         carry set if error on stream, ERRNO set appropriately
   ;
   ; MUST NOT ALTER EXX REGISTERS FOR SPRINTF FAMILY

   or a                        ; clear carry
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

defc ASMDISP_VFPRINTF_CALLEE = # asmentry - vfprintf_callee
defc LIBDISP_VFPRINTF_CALLEE = # libentry - vfprintf_callee
 