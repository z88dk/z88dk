/*
 *  Set the FCB parameters to the supplied name pt 1
 *  This bit deals with userarea, device and filename
 *
 *  27/1/2002 - djm
 *
 *  $Id: parsefcb.c,v 1.3 2013-06-06 08:58:32 stefano Exp $
 */


#include <cpm.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>


void parsefcb(struct fcb *fc, unsigned char *name)
{
#ifdef DEVICES
    unsigned char *ptr;
    unsigned char c;

    fc->drive = 0;         /* Default drive */
    fc->uid   = getuid();  /* Set the userid */

    ptr = name;

    while ( isdigit(*ptr) )  /* Find the end of the user number */
	ptr++;

    if ( name != ptr && *ptr == ':' ) {  /* uid has to end in colon */
	fc->uid = atoi(name);
	name = ++ptr;
    }

    if ( *name && name[1] == ':' ) {    /* Found a drive specifier */
	fc->drive = toupper(*name) - 'A' + 1; 
	name += 2;                      /* Skip over drive letter & colon */
    }

    /* Now copy the name */
    ptr = fc->name;
    
    /* Copy the name across upto the '.' or a '*' */
    while ( *name != '.' && *name != '*' && *name > ' ' &&
	    ptr < &fc->name[8] )
	*ptr++ = toupper(*name++);

    /* Now fill up to the first 8, with either a ? or space */
    if ( *name == '*' )
	c = '?';
    else
	c = ' ';
    while ( ptr < &fc->name[8] ) {
	*ptr++ = c;
    }

    /* Loop till we get to the extension */
    while ( *name && *name++ != '.' )
	continue;

    /* Now fill in the extension */
    while ( *name > ' ' && *name != '*' &&
	    ptr < &fc->ext[8] )
	*ptr++ = toupper(*name++);

    /* Now fill up the extension, with either a ? or space */
    if ( *name == '*' )
	c = '?';
    else
	c = ' ';
    while ( ptr < &fc->ext[3] )
	*ptr++ = c;


    fc->extent = fc->next_record = 0;

#else

#asm

;
; This code comes from BDS C.  
; Leor Zolman put it into Public Domain (in 9/20/2002)
;


;
; Process filename having optional user area number prefix of form "<u#>/",
; return the effective user area number of the given filename in the upper
; 5 bits of A, and also store this value at "usrnum". Note that if no user
; number is specified, the current user area is presumed by default. After
; the user area prefix is processed, do a regular "setfcb":
;
; Note: a filename is considered to have a user number if the first char
; 	in the name is a decimal digit and the first non-decimal-digit
;	character in the name is a slash (/).
;
; z88dk related note: usrnum is now (IX+37)

vstfcu:

	pop bc			; ret addr
	pop de			; name
	pop hl
	push hl
	push de
	push bc

	push	hl
	pop		ix


 PUSH	BC	;save BC
	PUSH	HL		;save fcb pointer
	call	igwsp	;ignore blanks and tabs	
	call	isdec	;decimal digit?
	JP	NC,setfc2	;if so, go process

setfc0:
	PUSH	DE		;save text pointer

	;;;; fc->uid   = getuid();  /* Set the userid */

	;;LD 	c,gsuser  ;else get current effective user number
	ld	c,32
	LD 	e,0ffh
	call	bdos	;get current user area if implemented


	pop	DE	;restore text pointer
setfc1:
	RLCA		;rotate into upper 5 bits of A
	RLCA
	RLCA
	;; LD	(usrnum),A	;and save
	ld	(ix+37),a
	pop	HL	;restore junk
	pop	BC
	JP	vsetfcb	;and parse rest of filename

setfc2:
	LD 	b,0	;clear user number counter
	PUSH	DE	;save text pointer in case we invalidate user prefix
setfc3:
	SUB	'0'	;save next digit value
	LD 	c,a	; in C
	LD 	a,b	;multiply previous sum by 10
	ADD	A,a	;*2
	ADD	A,a	;*4
	ADD	A,a	;*8
	ADD	A,b	;*9
	ADD	A,b	;*10
	ADD	A,c	;add new digit
	LD 	b,a	;put sum in B
	INC	DE	;look at next char in text
	LD	A,(DE)	;is it a digit?	
	call	isdec
	JP	NC,setfc3	;if so, go on looping and summing digits
	CP	'/'	;make sure number is terminated by a slash
	JP	Z,setfc4
	pop	DE	;if not, entire number prefix is not really a 
	JP	setfc0	; user number, so just ignore it all.

setfc4:
	INC	DE	;ok, allow the user number
	pop	HL	;get old text pointer off the stack
	LD 	a,b	;get user number value
	JP	setfc1	;and go store it and parse rest of filename


; Set up a CP/M file control block at HL with the file whose
; simple null-terminated name is pointed to by DE:
; Format for filename must be: "[white space][d:]filename.ext"
; The user number prefix hack is NOT recognized by this subroutine.
;

vsetfcb:

	;;PUSH	BC
	call	igwsp	;ignore blanks and tabs	
	PUSH	HL	;save fcb ptr
	INC	DE	;peek at 2nd char of filename
	LD	A,(DE)
	DEC	DE
	CP	':'	;default disk byte value is 0
	LD 	a,0	; (for currently logged disk)
	JP	NZ,setf1
	LD	A,(DE)	;oh oh...we have a disk designator
	call	mapuc	;make it upper case
	SUB	'A'-1	;and fudge it a bit
	INC	DE	;advance DE past disk designator to filename
	INC	DE
setf1:
	LD 	(HL),a	;set disk byte
	INC	HL
	LD 	b,8
	call	setnm	;set filename, pad with blanks
	call	setnm3	;ignore extra characters in filename
	LD	A,(DE)
	CP	'.'	;if an extension is given,
	JP	NZ,setf2
	INC	DE	;skip the '.'
setf2:
	LD 	b,3
	call	setnm	;set the extension field and pad with blanks
	XOR	a	;and zero the appropriate fields of the fcb
	LD 	(HL),a
	LD	DE,20
	ADD	HL,DE
	LD 	(HL),a
	INC	HL
	LD 	(HL),a	;zero random record bytes of fcb
	INC	HL
	LD 	(HL),a
	INC	HL
	LD 	(HL),a
	pop	DE
	;;pop	BC
	ret

;
; This routine copies up to B characters from (DE) to (HL),
; padding with blanks on the right. An asterisk causes the rest
; of the field to be padded with '?' characters:
;

setnm:
	PUSH	BC
setnm1:
	LD	A,(DE)
	CP	'*'	;wild card?
	LD 	a,'?'	;if so, pad with ? characters
	JP	Z,pad2

setnm2:
	LD	A,(DE)
	call	legfc	;next char legal filename char?
	JP	C,pad	;if not, go pad for total of B characters
	LD 	(HL),a	;else store
	INC	HL
	INC	DE
	DEC	b
	JP	NZ,setnm1	;and go for more if B not yet zero
	pop	BC
setnm3:
	LD	A,(DE)	;skip rest of filename if B chars already found
	call	legfc
	RET	C
	INC	DE
	JP	setnm3

pad:
	LD 	a,' '	;pad with B blanks
pad2:
	LD 	(HL),a	;pad with B instances of char in A
	INC	HL
	DEC	b
	JP	NZ,pad2
	pop	BC
	ret





;
; Test if char in A is legal character to be in a filename:
;

legfc:
	call	mapuc
	CP	'.'	; '.' is illegal in a filename or extension
	SCF
	RET	Z
	CP	':'	;so is ':'
	SCF 	
	RET	Z
	CP	7fh	;delete is no good
	SCF
	RET	Z
	CP	'!'	;if less than exclamation pt, not legal char
	ret		;else good enough

;
; Map character in A to upper case if it is lower case:
;

mapuc:
	CP	'a'
	RET	C
	CP	'z'+1
	RET	NC
	SUB	32	;if lower case, map to upper
	ret

;
; Ignore blanks and tabs at text pointed to by DE:
;

igwsp:
	DEC	DE
igwsp1:
	INC	DE
	LD	A,(DE)
	CP	' '
	JP	Z,igwsp1
	CP	9
	JP	Z,igwsp1
	ret

;
; Return Cy if char in A is not a decimal digit:
;

isdec:
	CP	'0'
	RET	C
	CP	'9'+1
	CCF
	ret

#endasm

#endif
}

