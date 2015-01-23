; stdio_out_I
; 09.2008 aralbrec

PUBLIC stdio_out_capi
EXTERN stdio_nextarg, htonl, stdio_numprec, stdio_outcommon

INCLUDE "../../stdio.def"

; output %I parameter
; 
; IPv4 address in dotted decimal notation
; * precision affects each individual octet; can be 1 or 3 (1 is default)
; * width and justification applies to entire address
; * # indicates address is in network byte order (big endian)
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
; uses  : af, bc, de, hl, exx, bc'

.stdio_out_capi

   push de                     ; save most sig 16-bits
   call stdio_nextarg          ; get next 16-bit word from parameter list
   ex (sp),hl                  ; save & parameter list
   ex de,hl                    ; dehl = IPv4 address (little endian, host order)

   push bc                     ; save width and flags

   ld b,a                      ; save precision
   bit 3,c                     ; # indicates address is in network order
   call nz, htonl              ; if so convert to host order
   ld a,b
   ld bc,10                    ; num chars in buffer = 0, radix = 10
   
   push hl                     ; save IPv4 address
   push hl
   push de

   ld hl,STDIO_TEMPBUFSIZE + 13
   add hl,sp                   ; hl = & last char in temporary buffer

   cp 1                        ; limit precision to 1 or 3 to control buffer size
   jr z, precok                ; and for normal dotted string appearance
   ld a,3

   ; generate four octets with dots in buffer

.precok

   scf                         ; set carry flag - add a dot after octet please
   ld e,d
   call putoctet
   
   pop de
   call putoctet
   
   pop de
   ld e,d
   call putoctet
   
   or a                        ; clear carry flag - dont want the dot
   pop de
   call putoctet
   
   ; now output buffer onto stream with width and justification applied
   
   pop de                      ; d = width, e = flags [-+ O#PLN]
   call stdio_outcommon
   pop hl                      ; hl = & parameter list
   
   ret


.putoctet

   ld d,0                      ; de = octet for output
   
   push af                     ; save precision and carry flag
   call stdio_numprec
   pop af                      ; restore precision and carry flag
   ret nc                      ; done if dont want a dot
   
   ld (hl),'.'
   dec hl
   inc b
   
   ret
