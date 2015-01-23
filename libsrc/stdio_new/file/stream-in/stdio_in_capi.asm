; stdio_in_I, read IPv4 address in dotted notation
; 09.2008 aralbrec

PUBLIC stdio_in_capi

EXTERN stdio_incommon1, stdio_inexit, stdio_getchar
EXTERN stdio_ungetchar, stdio_in_i, htonl

EXTERN LIBDISP_STDIO_IN_I

; input %I parameter, read IPv4 address in dotted notation
; * accepts octets in octal, hex or decimal
; * 'a' indicates address should be stored in network byte order (big endian)
;
; enter :     ix  = FILE *
;               b = width
;               c = flags [000a*WL0]
;              hl = & parameter list
;             bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
; on exit :   bc' = total num chars read from stream thus far
;             de' = number of conversions done thus far
;              hl = & parameter list
;             carry set if EOF reached
;
; MUST NOT ALTER HL' FOR SSCANF FAMILY

.stdio_in_capi

   call stdio_incommon1        ; leading ws, sign, long *
   ret c
   
   bit 0,c                     ; return error if a sign was present
   jp nz, stdio_inexit

   push hl                     ; save & parameter list
   push de                     ; save long *
   push bc                     ; save real flags

   ; ix = FILE *
   ;  a = next char from stream

   ld c,8                      ; assignment suppression on
   push hl                     ; dummy MSW of IPv4 address

   call getoctet2
   ld h,e                      ; h = first octet
   call consumedot
   
   call getoctet
   ld l,e                      ; l = second octet
   call consumedot
   
   ex (sp),hl                  ; save MSW of IPv4 address
   
   call getoctet
   ld h,e                      ; h = third octet
   call consumedot
   
   call getoctet
   ld l,e                      ; l = fourth octet
   
   ; carry reset here
   
   pop de                      ; dehl = IPv4 address
   pop bc                      ; c = flags [000a*WL0]

   bit 3,c                     ; assignment suppression?
   jr nz, suppress

   bit 4,c                     ; 'a' flag = store in network order
   call nz, htonl

   ex de,hl                    ; hlde = IPv4 address
   ex (sp),hl                  ; hl = long *, stack = MSW of IPv4 address
   ld (hl),e                   ; write LSW of IPv4 address into long*
   inc hl
   ld (hl),d
   inc hl
   pop de                      ; de = MSW of IPv4 address
   ld (hl),e                   ; write MSW of IPv4 address into long*
   inc hl
   ld (hl),d

   exx
   inc de                      ; increase num conversions done
   exx

   pop hl                      ; hl = & parameter list
   ret

.suppress

   pop de
   pop hl
   ret

.getoctet

   call stdio_getchar
   jr c, error

.getoctet2

   call stdio_in_i + LIBDISP_STDIO_IN_I
   jr c, error
   inc d                       ; octet de should be < 256
   dec d
   ret z

.error

   pop bc                      ; ret address
   pop bc                      ; MSW of IPv4 address
   pop bc                      ; flags
   pop de                      ; long *
   pop hl                      ; & parameter list

   scf
   ret

.consumedot

   call stdio_getchar
   jr c, error
   
   cp '.'
   ret z
   
   call stdio_ungetchar
   jp error

   