/*
 *	An alternate miniprintf core which can print
 *	longs and unsigned values correctly.
 *
 *	djm 26/2/2000
 *
 *	Error in last digit - I'm not sure why - this occurs
 *	for *large* numbers..
 *
 *	djm 3/3/2000
 *	This routine is infact a vfprintf, so naming as such...
 *
 *	stefano 8/11/2010
 *	Rewrote 'miniprintn' in assembler, less usage of stack and save 180 bytes
 * 
 * --------
 * $Id: vfprintf_mini.c,v 1.5 2010-11-09 16:13:44 stefano Exp $
 */

#define ANSI_STDIO

#include <stdio.h>

/*
 * Once over to Small C this isn't negotiable! 
 * Arguments go downwards instead of upwards (we push from
 * left to right, not right to left, so we do a - instead of a +
 * to step to the next one..
 */

static void __CALLEE__ miniprintn(long number, FILE *fil, unsigned char flag);

int vfprintf_mini(FILE *fp, unsigned char *fmt,void *ap)
{
	/*
        unsigned char c;
        unsigned char k;
        unsigned char   *s;


        while ((c = *fmt++) != '\0') {
                if (c != '%') 
                        fputc(c,fp);
                else {
                        c = *fmt++;
                        switch (c) {
			case 'l':
				c=*fmt++;
				switch (c) {
					case 'd':
					case 'u':
						ap-=sizeof(int);
                                		miniprintn((long)*(long *)ap,fp,c=='d');
                                		ap -= sizeof(int);
						break;
				}
				break;

                        case 'd':
                                miniprintn((long)*(int *)ap,fp,1);
                                ap -= sizeof(int);
                                break;

                        case 'u':
                                miniprintn((unsigned long)*(unsigned int *)ap,fp,0);
                                ap -= sizeof(int);
                                break;

                        case 's':
                                s = *(char **)ap;
                                while ((k = *s++) != '\0')
                                        fputc(k,fp);
                                ap -= sizeof(char *);
                                break;

                        case 'c':
                                fputc(*(int *)ap,fp);
                                ap -= sizeof(int);
                                break;

                        default:
                                fputc(c,fp);
                        }
                }
        }
	return(0);
*/
#asm

LIB	fputc
LIB _miniprintn
LIB	l_glong
LIB	l_int2long_s

.vfprintf_callee

; int vfprintf_mini(FILE *fp, unsigned char *fmt,void *ap)

	pop af
	pop de	; arg_ptr
	pop hl	; format string
	pop bc	; fp
	push bc
	push hl
	push de
	push af

.fmtloop
	ld	a,(hl)
	inc hl
	and a
	jr	nz,cont
	ld	hl,0
	ret
	
.cont
	cp	'%'
	jr z,get_arg

; default
.nochar
	call _put_char
	jr	fmtloop	

.get_arg
	ld	a,(hl)
	inc hl
	cp	'l'
	jr nz,nol

		ld	a,(hl)
		inc hl
		push hl
		ld	hl,1	; flag set
		cp	'd'
		jr z,longnum
.nold
		dec	hl		; flag reset
		cp	'u'
		jr	z,longnum
		pop hl
		jr fmtloop
.longnum
		push hl
		pop	af
		push de
		;; push hl
		ex	de,hl
		call l_gint
		push bc
		push af
		call	l_glong
		pop af
		pop bc
		call do_miniprintn

		pop de
		pop hl
		dec de
		dec	de
		jr dec_loop

.nol
	cp	'd'
	jr	z,isd
	cp	'f'		; fake.. we have an integer here !
	jr nz,nod
.isd
	push hl
	push de
	ex	de,hl
	call l_gint
	push bc
	call	l_int2long_s
	ld	bc,1
	push bc
	pop af	; flag for signed output
	pop bc
	call do_miniprintn
	pop de
	pop hl
	jr dec_loop



.nod
	cp	'u'
	jr nz,nou

	push hl
	push de
	ex	de,hl
	call l_gint
	ld	de,0
	push de
	pop af	; flag for unsigned output
	call do_miniprintn
	pop de
	pop hl
.dec_loop
	dec de
	dec de
	jr	fmtloop

.nou
	cp	's'
	jr	nz,nostring

	push hl
	push de
	ex	de,hl
	call l_gint
.printstr
	ld	a,(hl)
	inc hl
	and	a
	jr	nz,contstr
	pop de
	pop hl
	jr dec_loop
.contstr
	call _put_char
	jr	printstr

.nostring
	cp	'c'
	jp	nz,nochar
	ld	a,(de)
	call _put_char
	jr	dec_loop


._put_char
	push de
	push hl
;	ld	h,0
;	ld	l,a
;	push hl
;	push	bc
;	call	fputc
;	pop	bc
;	pop	hl

	ld		l,a
	call	doprint	; awful trick to save few bytes

	pop hl
	pop de
	ret


.do_miniprintn
	push de	; num msw
	push hl	; num lsw
	push bc	; fp
	push af	; flag
	call	_miniprintn
	ret

#endasm
}


static void __CALLEE__ miniprintn(long number, FILE *file, unsigned char flag)
{
		/*
        unsigned long i;

        if (flag && number < 0 ){
                fputc('-', file);
                number = -number;
        }
        if ((i =(unsigned long) number / 10L) != 0)
                miniprintn(i,file,flag);
        fputc((unsigned long)number%10+'0', file);
        */
#asm
LIB l_long_neg
LIB l_long_div_u
LIB fputc

.printn2
	pop af	; ret addr.
	pop hl	; flag
	pop bc	; FILE ptr
	exx
	pop hl	; number LSW
	pop de	; number MSW
	push af	; ret addr.
.printn3	
	ld a,d
	rlca		; shift sign bit in first pos..
	and 1
	exx
	and l	; flag
	push bc
	exx
	jr	z,noneg
	
	call	l_long_neg
	pop bc
	push bc

	;push hl
	;push de
	;ld	l,'-'
	;call	doprint
	;pop de
	;pop hl

	ld	a,'-'
	call	_put_char 	; awful trick to save few bytes

.noneg
	pop bc
	xor a
	push af	; set terminator

.divloop
	push	bc
	push	de	; number MSW
	push	hl	; number LSW

;	ld	a,(flag)
;	and	2	; bit 2 of flag set->hex mode
;	ld	a,10
;	jr	z,nohexdiv
;	add 6
;.nohexdiv
;	ld	h,0
;	ld	l,a

	ld hl,10
	ld d,h
	ld e,h
	call	l_long_div_u
	pop	bc
	exx
	ld	a,l
	cp 255  ; force flag to non-zero
	push af	; save reminder as a digit in stack
	exx

	ld a,h
	or d
	or e
	or l			; is integer part of last division  zero ?
	jr nz,divloop	; not still ?.. loop
	
	
	; now recurse for the single digit
	; pick all from stack until you get the terminator
.printloop
	pop	af
	ld l,a
	ret	z
	
;	cp 10
;	jr c,nohex
;	; hex digits handling
;	add 17		; 49 for lowercase
;.nohex
	add '0'
	ld l,a
	
	call	doprint
	jr	printloop


.doprint
	ld	h,0
	push	hl
	push	bc	; FILE ptr
	call	fputc
	pop bc
	pop		hl
	ret

#endasm

}

