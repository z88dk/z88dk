/*
 *	  New stdio functions for Small C+
 *
 *	  djm 4/5/99
 *
 * --------
 * $Id: fgetc.c,v 1.13 2016-03-06 21:36:52 dom Exp $
 */

#define ANSI_STDIO
#define STDIO_ASM

#include <stdio.h>
#include <fcntl.h>

/*
 *	struct fp {
 *		union xx {
 *			int fd;
 *			char *str;
 *		} desc;
 *		u8_t error;
 *		u8_t flags;
 *		u8_t ungetc;
 */

int fgetc(FILE *fp)
{
#asm
IF __CPU_INTEL__ || __CPU_GBZ80__
    pop     bc
    pop     de  ;fp
    push    de
    push    bc
    ld      hl,-1	;EOF
    inc     de	
    inc     de
    ld      a,(de)	;de = &fp_flags get flags
    and     a
  IF __CPU_GBZ80__
    jr      z,fgetc_assign_ret
  ELSE
    ret     z
  ENDIF
    and     _IOEOF	;check we`re not write/EOF
  IF __CPU_GBZ80__
    jr      nz,fgetc_assign_ret
  ELSE
    ret     nz
  ENDIF
    inc     de      ;de=&fp_ungetc
    ld      a,(de)	;check for ungot char
    and     a
    jr      z,no_ungetc
    ex      de,hl
    ld      e,a
    ld      d,0
    ld      (hl),d	;set no ungetc character
    ex      de,hl
  IF __CPU_GBZ80__
fgetc_assign_ret:
    ld      d,h
    ld      e,l
  ENDIF
    ret
.no_ungetc
; Now do strings
    dec     de	;de=&fp_flags
    ld      a,(de)
    and     _IOSTRING
    jr      z,no_string	;not a string
    ex      de,hl
    dec     hl		;fp_desc+1
    ld      d,(hl)
    dec     hl		;fp_desc
    ld      e,(hl)
    ld      a,(de)
    inc     de
    ld      (hl),e		
    inc     hl		;fp_desc+1
    ld      (hl),d
    ex      de,hl
    ld      hl,-1	;EOF
    and     a	;test for zero
  IF __CPU_GBZ80__
    jr      z,fgetc_assign_ret
  ENDIF
    ret     z	;return EOF if so
    ld      l,a	;else return character
    ld      h,0
  IF __CPU_GBZ80__
    jr      fgetc_assign_ret
  ELSE
    ret
  ENDIF
.no_string
    dec     de	;fp_desc+1
    dec     de	;fp_desc
    push    de	;preserve fp
    call    fchkstd	;check for stdin (stdout/err have failed already)
    pop     de	;ix back
    jr      c,no_stdin
    call    fgetc_cons  ;get from console
    ret	                ;always succeeds - never EOF
.no_stdin
    ex      de,hl
    ld      e,(hl)
    inc     hl      ;fp_desc+1
    ld      d,(hl)
    dec     hl      ;fp_desc
    ex      de,hl
    push    de
    call    readbyte    ;readbyte sorts out stack (fastcall)
    pop     de          ;get fp back
  IF __GBZ80__
    jr      nc,fgetc_assign_ret
  ELSE
#ifdef __STDIO_BINARY
    push    de
    inc     de
    inc     de          ;de = &flags
    ld      a,(de)
    pop     de  
    and     _IOTEXT     ;check for text mode
    jr      z,not_text_fp
    ld      a,l
#ifdef __STDIO_EOFMARKER
    cp      __STDIO_EOFMARKER	;compare with the EOF marker
    jp      z,seteof
#endif
#ifdef __STDIO_CRLF
    cp      13
    jr      z,no_stdin		; Read again
#endif
#endif
not_text_fp:
    ld      a,h
    inc     a
    ret     nz
  ENDIF
.seteof
    ld      hl,-1
    inc     de	
    inc     de		;fp_flags
    ld      a,(de)
    or      _IOEOF
    ld      (de),a	;set EOF, return with EOF
  IF __CPU_GBZ80__
    jr      fgetc_assign_ret
  ENDIF
ELSE

  IF __CPU_RABBIT__
    ld      hl,(sp + 2)
    push    ix		;save callers ix
    ld      ix,hl
  ELSE
    pop     bc
    pop     hl	; fp
    push    hl
    push    bc
    push    ix	; callers ix
    push    hl
    pop     ix
  ENDIF

    ld      a,(ix+fp_flags)	;get flags
    and     a
    jp      z, is_eof
	;	Check removed to allow READ+WRITE streams
    ;and     _IOWRITE | _IOEOF	;check we`re not write/EOF
	and     _IOEOF	;check we`re not write/EOF
    jp      nz, is_eof
    ld      a,(ix+fp_ungetc)	;check for ungot char
    and     a
    jr      z,no_ungetc
    ld      l,a
    ld      h,0
    ld      (ix+fp_ungetc),h
    jp      fgetc_end
.no_ungetc
; Now do strings
    ld      a,(ix+fp_flags)
    and     _IOSTRING
    jr      z,no_string	;not a string
    ld      hl,(ix+fp_extra)	; check the length
    ld      a,h
    or      l
    jp      z,is_eof
    dec     hl
    ld      (ix+fp_extra),hl

    ld      hl,(ix+fp_desc)
    ld      a,(hl)
    inc     hl
    ld      (ix+fp_desc),hl
    and     a		;test for zero
    jr      z,is_eof	;return EOF if so
    ld      l,a		;else return character
    ld      h,0
    jr      fgetc_end
.no_string
    ld      a,(ix+fp_flags)
    and     _IOEXTRA
    jr      z,not_extra_fp
    ld      hl,(ix + fp_extra)
    ld      a,__STDIO_MSG_GETC
    call	l_jphl
    jr      nc, fgetc_end
    jr      seteof		;EOF reached (sock closed?)
.not_extra_fp
    push    ix		;preserve fp
    call	fchkstd		;check for stdin (stdout/err have failed already)
    pop     ix		;ix back
    jr      c,no_stdin
    call	fgetc_cons	;get from console
#ifdef __STDIO_EOFMARKER
    ld      a,l
    cp	__STDIO_EOFMARKER
    jr      z,is_eof
#endif
    push    hl
    call	fputc_cons
    pop     hl
    jr      fgetc_end	; always succeeds - never EOF when EOF has not been defined.
.no_stdin
    ld      hl,(ix+fp_desc)
    push    ix
    call	readbyte	; readbyte sorts out stack (fastcall)
    			; hl = byte read
    			; c = EOF
    			; nc = good
    pop     ix		; get fp back
#ifdef __STDIO_BINARY
    ld      a,_IOTEXT	;check for text mode
    and     (ix+fp_flags)
    jr      z,not_text_fp
    ld      a,l
#ifdef __STDIO_EOFMARKER
    cp	__STDIO_EOFMARKER	;compare with the EOF marker
    jr      z,is_eof
#endif
#ifdef __STDIO_CRLF
    cp      13
    jr      z,no_stdin		; Read again
#endif
.not_text_fp
#endif
    ; Check for value of -1
    ld      a,h
    inc     a
    jr      nz,fgetc_end
.is_eof
    ld      hl,-1		;signify EOF
.seteof
    ld      a,(ix+fp_flags)
    or      _IOEOF
    ld      (ix+fp_flags),a	;set EOF, return with EOF
.fgetc_end
    pop      ix
ENDIF
#endasm
}
