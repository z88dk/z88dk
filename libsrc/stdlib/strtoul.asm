;* * * * *  Small-C/Plus Z88 * * * * *
;  Version: v1.10b0.70pre2 Date: 1/4/2000 
;
;	Reconstructed for the z80 Module Assembler
;	By Dominic Morris <djm@jb.man.ac.uk>
;
;	Module compile time: Thu May  4 19:02:41 2000
;
; -----
; $Id: strtoul.asm,v 1.3 2001-09-10 16:08:33 stefano Exp $
;


;# 1 "strtoul.c"

	MODULE	strtoul.c

	INCLUDE "#z80_crt0.hdr"


;# 13 "/home/dom/z88dk/include/sys/types.h"
;typedef unsigned int size_t;
;typedef signed int ssize_t;
;typedef unsigned long clock_t;
;typedef signed int pid_t;
;typedef unsigned char bool_t;
;typedef long time_t;
;typedef short wild_t;
;typedef unsigned long fpos_t;
;typedef unsigned char u8_t;
;typedef unsigned short u16_t;
;typedef unsigned long u32_t;
;typedef char i8_t;
;typedef short i16_t;
;typedef long i32_t;
;# 28 "/home/dom/z88dk/include/fcntl.h"
;typedef int mode_t;
;extern int __LIB__ open(far char *name, int flags, mode_t mode);
;extern int __LIB__ creat(far char *name, mode_t mode);
;extern int __LIB__ close(int fd);
;extern size_t __LIB__ read(int fd, void *ptr, size_t len);
;extern size_t __LIB__ write(int fd, void *ptr, size_t len);
;extern long __LIB__ lseek(int fd,long posn, int whence);
;extern int __LIB__ __FASTCALL__ readbyte(int fd);
;extern int __LIB__ __FASTCALL__ writebyte(int fd, int c);
;extern int __LIB__ open_z88(far char *name, int flags, mode_t mode, char *explicit, size_t len);
;extern int __LIB__ nropen(char *name, int flags, mode_t mode, char *explicit, size_t len);
;#pragma  output ANSIstdio
;# 35 "/home/dom/z88dk/include/stdio.h"
;struct filestr {
;union f0xx {
;int fd;
;u8_t *ptr;
;} desc;
;u8_t flags;
;u8_t ungetc;
;};
;#asm
;# 69
;extern struct filestr _sgoioblk[10];
;# 88
;extern struct filestr __LIB__ *fopen(far char *name, unsigned char *mode);
;extern struct filestr __LIB__ *fopen_z88(far char *name, unsigned char *mode, unsigned char *explicit, size_t len);
;extern struct filestr __LIB__ *freopen(far char *name, unsigned char *mode, struct filestr *fp);
;extern struct filestr __LIB__ *freopen_z88(far char *n, unsigned char *m, struct filestr *fp, unsigned char *explicit, size_t len);
;extern struct filestr __LIB__ *fdopen(int fildes, unsigned char *mode);
;extern int __LIB__ fclose(struct filestr *fp);
;extern void __LIB__ closeall();
;extern char __LIB__ *fgets(unsigned char *s, int, struct filestr *fp);
;extern int __LIB__ fputs(unsigned char *s, struct filestr *fp);
;extern int __LIB__ fputc(int c, struct filestr *fp);
;extern int __LIB__ fgetc(struct filestr *fp);
;extern int __LIB__ ungetc(int c, struct filestr *);
;extern int __LIB__ feof(struct filestr *fp);
;extern int __LIB__ puts(unsigned char *);
;extern fpos_t __LIB__ ftell(struct filestr *fp);
;extern int __LIB__ fgetpos(struct filestr *fp, fpos_t *pos);
;extern int __LIB__ fseek(struct filestr *fp, fpos_t offset, int whence);
;# 129
;extern int __LIB__ printf(char *,...);
;extern int __LIB__ fprintf(struct filestr *,char *,...);
;extern int __LIB__ sprintf(char *,char *,...);
;extern int vfprintf(struct filestr *,unsigned char *fmt,void *ap);
;extern int __LIB__ vsprintf(char *str,unsigned char *fmt,void *ap);
;# 139
;extern int __LIB__ vfprintf_mini(struct filestr *, unsigned char *, void *);
;extern int __LIB__ vfprintf_comp(struct filestr *, unsigned char *, void *);
;extern __LIB__ printn(int number, int radix,struct filestr *file);
;# 148
;extern int __LIB__ scanf(unsigned char *fmt,...);
;extern int __LIB__ fscanf(struct filestr *,unsigned char *fmt,...);
;extern int __LIB__ sscanf(char *,unsigned char *fmt,...);
;extern int __LIB__ vfscanf(struct filestr *, unsigned char *fmt, void *ap);
;extern int __LIB__ vsscanf(char *str, unsigned char *fmt, void *ap);
;# 162
;extern int __LIB__ getarg(void);
;# 176
;extern int __LIB__ fchkstd(struct filestr *);
;extern int __LIB__ fgetc_cons();
;extern int __LIB__ fputc_cons(char c);
;extern int __LIB__ fgets_cons(char *s, int n);
;extern void __LIB__ fabandon(struct filestr *);
;extern long __LIB__ fdtell(int fd);
;extern int __LIB__ fdgetpos(int fd, fpos_t *posn);
;extern int __LIB__ rename(char *s, char *d);
;extern int __LIB__ remove(char *name);
;# 200
;extern int __LIB__ getk();
;extern void __LIB__ puts_cons();
;extern void __LIB__ printk(char *fmt,...);
;# 5 "/home/dom/z88dk/include/ctype.h"
;extern __LIB__ isalpha(char);
;extern __LIB__ isalnum(char);
;extern __LIB__ isascii(char);
;extern __LIB__ iscntrl(char);
;extern __LIB__ isdigit(char);
;extern __LIB__ isupper(char);
;extern __LIB__ islower(char);
;extern __LIB__ isprint(char);
;extern __LIB__ ispunct(char);
;extern __LIB__ isspace(char);
;extern __LIB__ isxdigit(char);
;extern char __LIB__ toascii(char);
;extern char __LIB__ toupper(char);
;extern char __LIB__ tolower(char);
;# 9 "/home/dom/z88dk/include/stdlib.h"
;extern __LIB__ abs(int);
;extern long __LIB__ labs(long);
;extern __LIB__ atexit();
;extern __LIB__ __FASTCALL__ exit(int);
;extern long __LIB__ strtol(char *,char **,int);
;extern unsigned long __LIB__ strtoul(char *,char **,int);
;extern int __LIB__ atoi(char *);
;# 29
;extern int __LIB__ rand(void);
;extern void __LIB__ srand(int);
;extern __LIB__ sleep(int);
;extern __LIB__ mkdir(char *);
;extern char __LIB__ *getcwd(char *buf, int maxlen);
;extern __LIB__ csleep(int);
;# 22 "/home/dom/z88dk/include/malloc.h"
;extern void __LIB__ *calloc(int,int);
;extern void __LIB__ *malloc(int);
;extern void __LIB__ free(void *);
;extern int __LIB__ getfree();
;extern int __LIB__ getlarge();
;extern void __LIB__ heapinit(int);
;# 17 "strtoul.c"
;unsigned long strtoul(char *nptr,char **endptr,int base)
;{

.strtoul
	LINE	18
;unsigned char c;
	LINE	20
;unsigned long r;
	LINE	21
;unsigned char *p,*q;
	LINE	22
;int a;
	LINE	23
;p=nptr;
	LINE	24
	ld	hl,-11	;const
	add	hl,sp
	ld	sp,hl
	ld	hl,4	;const
	add	hl,sp
	push	hl
	ld	hl,19	;const
	add	hl,sp
	call	l_gint	;
	pop	de
	call	l_pint
;c=0;
	LINE	25
	ld	hl,10	;const
	add	hl,sp
	push	hl
	ld	hl,0	;const
	pop	de
	ld	a,l
	ld	(de),a
;r=0L;
	LINE	26
	ld	hl,6	;const
	add	hl,sp
	push	hl
	ld	hl,0	;const
	ld	de,0
	pop	bc
	call	l_plong
;if(base<0||base==1||base>36)
	LINE	28
	ld	hl,13	;const
	add	hl,sp
	call	l_gint	;
	push	hl
	ld	hl,0	;const
	pop	de
	call	l_lt
	jp	c,i_4
	ld	hl,13	;const
	add	hl,sp
	call	l_gint	;
	push	hl
	ld	hl,1	;const
	pop	de
	call	l_eq
	jp	c,i_4
	ld	hl,13	;const
	add	hl,sp
	call	l_gint	;
	push	hl
	ld	hl,36	;const
	pop	de
	call	l_gt
	jp	c,i_4
	ld	hl,0	;const
	jr	i_5
.i_4
	ld	hl,1	;const
.i_5
	ld	a,h
	or	l
	jp	z,i_3
;{ if(endptr!=0)
	LINE	29
	ld	hl,15	;const
	add	hl,sp
	call	l_gint	;
	ld	a,h
	or	l
	jp	z,i_6
;*endptr=(char *)nptr;
	LINE	30
	ld	hl,15	;const
	add	hl,sp
	call	l_gint	;
	push	hl
	ld	hl,19	;const
	add	hl,sp
	call	l_gint	;
	pop	de
	call	l_pint
;return 0;
.i_6
	LINE	31
	ld	hl,0	;const
	ld	de,0
	exx
	ld	hl,11	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret


;}
;while(isspace(*p))
.i_3
	LINE	34
.i_7
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	ld	l,(hl)
	ld	h,0
	push	hl
	call	isspace
	pop	bc
	ld	a,h
	or	l
	jp	z,i_8
;p++;
	LINE	35
	ld	hl,4	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	inc	hl
	pop	de
	call	l_pint
	dec	hl
	jp	i_7
.i_8
;if(*p=='-'||*p=='+')
	LINE	36
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	hl,45	;const
	pop	de
	call	l_eq
	jp	c,i_10
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	hl,43	;const
	pop	de
	call	l_eq
	jp	c,i_10
	ld	hl,0	;const
	jr	i_11
.i_10
	ld	hl,1	;const
.i_11
	ld	a,h
	or	l
	jp	z,i_9
;c=*p++;
	LINE	37
	ld	hl,10	;const
	add	hl,sp
	push	hl
	ld	hl,6	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	inc	hl
	pop	de
	call	l_pint
	dec	hl
	ld	l,(hl)
	ld	h,0
	pop	de
	ld	a,l
	ld	(de),a
;if(base==0)
.i_9
	LINE	38
	ld	hl,13	;const
	add	hl,sp
	call	l_gint	;
	ld	a,h
	or	l
	jp	nz,i_12
;{ if(p[0]=='0')
	LINE	39
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	hl,48	;const
	pop	de
	call	l_eq
	jp	nc,i_13
;{ if(tolower(p[1])=='x'&&isxdigit(p[2]))
	LINE	40
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	inc	hl
	ld	l,(hl)
	ld	h,0
	push	hl
	call	tolower
	pop	bc
	push	hl
	ld	hl,120	;const
	pop	de
	call	l_eq
	jp	nc,i_15
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	inc	hl
	inc	hl
	ld	l,(hl)
	ld	h,0
	push	hl
	call	isxdigit
	pop	bc
	ld	a,h
	or	l
	jp	z,i_15
	ld	hl,1	;const
	jr	i_16
.i_15
	ld	hl,0	;const
.i_16
	ld	a,h
	or	l
	jp	z,i_14
;{ p+=2;
	LINE	41
	ld	hl,4	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	inc	hl
	inc	hl
	pop	de
	call	l_pint
;base=16; }
	LINE	42
	ld	hl,13	;const
	add	hl,sp
	push	hl
	ld	hl,16	;const
	pop	de
	call	l_pint
;else
	jp	i_17
.i_14
;base=8;
	LINE	44
	ld	hl,13	;const
	add	hl,sp
	push	hl
	ld	hl,8	;const
	pop	de
	call	l_pint
.i_17
;}else
	jp	i_18
.i_13
;base=10;
	LINE	46
	ld	hl,13	;const
	add	hl,sp
	push	hl
	ld	hl,10	;const
	pop	de
	call	l_pint
.i_18
;}
;q=p;
.i_12
	LINE	48
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	pop	de
	pop	bc
	push	hl
	push	de
;printf("Base is %d\n",base);
	LINE	49
	ld	hl,i_1+0
	push	hl
	ld	hl,15	;const
	add	hl,sp
	call	l_gint	;
	push	hl
	ld	a,2
	call	printf
	pop	bc
	pop	bc
;for(;;)
	LINE	50
.i_21
	jp	i_22
.i_19
	jp	i_21
.i_22
;{
	LINE	51
;if(!isalnum(*q))
	LINE	52
	ld	hl,2	;const
	add	hl,sp
	call	l_gint	;
	ld	l,(hl)
	ld	h,0
	push	hl
	call	isalnum
	pop	bc
	call	l_lneg
	jp	nc,i_23
;break;
	LINE	53
	jp	i_20
;a=isdigit(*q) ? (*q-'0') : (tolower(*q)-('a'-10) );
.i_23
	LINE	54
	ld	hl,2	;const
	add	hl,sp
	call	l_gint	;
	ld	l,(hl)
	ld	h,0
	push	hl
	call	isdigit
	pop	bc
	ld	a,h
	or	l
	jp	z,i_24
	ld	hl,2	;const
	add	hl,sp
	call	l_gint	;
	ld	l,(hl)
	ld	h,0
	ld	bc,-48
	add	hl,bc
	jp	i_25
.i_24
	ld	hl,2	;const
	add	hl,sp
	call	l_gint	;
	ld	l,(hl)
	ld	h,0
	push	hl
	call	tolower
	pop	bc
	ld	bc,-87
	add	hl,bc
.i_25
	pop	bc
	push	hl
;if(a>base)
	LINE	55
	ld	hl,0	;const
	add	hl,sp
	call	l_gint	;
	push	hl
	ld	hl,15	;const
	add	hl,sp
	call	l_gint	;
	pop	de
	call	l_gt
	jp	nc,i_26
;break;
	LINE	56
	jp	i_20
;if(r>(4294967295LU-(unsigned long)a)/base||r*base>4294967295LU-a)
.i_26
	LINE	57
	ld	hl,6	;const
	add	hl,sp
	call	l_glong
	push	de
	push	hl
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	ld	de,0
	ld	de,-1
	call	l_long_sub
	push	de
	push	hl
	ld	hl,17	;const
	add	hl,sp
	call	l_gint	;
	ld	de,0
	call	l_long_div_u
	call	l_long_ugt
	jp	c,i_28
	ld	hl,2	;const
	add	hl,sp
	call	l_glong
	push	de
	push	hl
	ld	hl,13	;const
	add	hl,sp
	call	l_gint	;
	ld	de,0
	call	l_long_mult
	push	de
	push	hl
	ld	hl,0	;const
	add	hl,sp
	call	l_gint	;
	ld	de,-1
	call	l_long_sub
	call	l_long_ugt
	jp	c,i_28
	ld	hl,0	;const
	jr	i_29
.i_28
	ld	hl,1	;const
.i_29
	ld	a,h
	or	l
	jp	z,i_27
;r=4294967295LU;
	LINE	58
	ld	hl,-2	;const
	add	hl,sp
	push	hl
	ld	hl,65535	;const
	ld	de,65535
	pop	bc
	call	l_plong
;else
	jp	i_30
.i_27
;r=r*base+a;
	LINE	60
	ld	hl,-2	;const
	add	hl,sp
	push	hl
	ld	hl,0	;const
	add	hl,sp
	call	l_glong
	push	de
	push	hl
	ld	hl,11	;const
	add	hl,sp
	call	l_gint	;
	ld	de,0
	call	l_long_mult
	push	de
	push	hl
	ld	hl,-2	;const
	add	hl,sp
	call	l_gint	;
	ld	de,0
	call	l_long_add
	pop	bc
	call	l_plong
.i_30
;printf("r is %ld\n",r);
	LINE	61
	ld	hl,i_1+12
	push	hl
	ld	hl,0	;const
	add	hl,sp
	call	l_glong
	push	de
	push	hl
	ld	a,3
	call	printf
	pop	bc
	pop	bc
	pop	bc
;q++;
	LINE	62
	ld	hl,-6	;const
	add	hl,sp
	push	hl
	call	l_gint	;
	inc	hl
	pop	de
	call	l_pint
	dec	hl
;}
	ld	hl,-8	;const
	add	hl,sp
	ld	sp,hl
	jp	i_19
.i_20
;printf("r is %ld\n",r);
	LINE	64
	ld	hl,i_1+12
	push	hl
	ld	hl,8	;const
	add	hl,sp
	call	l_glong
	push	de
	push	hl
	ld	a,3
	call	printf
	pop	bc
	pop	bc
	pop	bc
;if(q==p)
	LINE	65
	ld	hl,2	;const
	add	hl,sp
	call	l_gint	;
	push	hl
	ld	hl,6	;const
	add	hl,sp
	call	l_gint	;
	pop	de
	call	l_eq
	jp	nc,i_31
;{ if(endptr!=0)
	LINE	66
	ld	hl,15	;const
	add	hl,sp
	call	l_gint	;
	ld	a,h
	or	l
	jp	z,i_32
;*endptr=(char *)nptr;
	LINE	67
	ld	hl,15	;const
	add	hl,sp
	call	l_gint	;
	push	hl
	ld	hl,19	;const
	add	hl,sp
	call	l_gint	;
	pop	de
	call	l_pint
;return 0;
.i_32
	LINE	68
	ld	hl,0	;const
	ld	de,0
	exx
	ld	hl,11	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret


;}
;if(c=='-')
.i_31
	LINE	70
	ld	hl,10	;const
	add	hl,sp
	ld	l,(hl)
	ld	h,0
	push	hl
	ld	hl,45	;const
	pop	de
	call	l_eq
	jp	nc,i_33
;r=-r;
	LINE	71
	ld	hl,6	;const
	add	hl,sp
	push	hl
	ld	hl,8	;const
	add	hl,sp
	call	l_glong
	call	l_long_neg
	pop	bc
	call	l_plong
;if(endptr!=0)
.i_33
	LINE	72
	ld	hl,15	;const
	add	hl,sp
	call	l_gint	;
	ld	a,h
	or	l
	jp	z,i_34
;*endptr=(char *)q;
	LINE	73
	ld	hl,15	;const
	add	hl,sp
	call	l_gint	;
	push	hl
	ld	hl,4	;const
	add	hl,sp
	call	l_gint	;
	pop	de
	call	l_pint
;return r;
.i_34
	LINE	74
	ld	hl,6	;const
	add	hl,sp
	call	l_glong
	exx
	ld	hl,11	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret


;}
.i_1
	defm	"Base is %d"&13&""&0
	defm	"r is %ld"&13&""&0


; --- Start of Static Variables ---



; --- Start of Scope Defns ---

	LIB	vfprintf_mini
	LIB	malloc
	LIB	getlarge
	LIB	feof
	LIB	labs
	LIB	getk
	LIB	atoi
	LIB	isprint
	LIB	free
	LIB	sprintf
	LIB	tolower
	LIB	ispunct
	LIB	read
	LIB	strtol
	LIB	exit
	LIB	rand
	LIB	isupper
	LIB	open
	LIB	fgetc
	LIB	freopen
	LIB	fgets
	LIB	open_z88
	LIB	fopen_z88
	LIB	creat
	LIB	close
	LIB	heapinit
	LIB	isxdigit
	LIB	toupper
	LIB	puts
	LIB	abs
	LIB	fseek
	LIB	calloc
	LIB	rename
	LIB	fopen
	LIB	fchkstd
	LIB	ftell
	LIB	readbyte
	LIB	fprintf
	LIB	vsscanf
	XREF	__sgoioblk
	LIB	fgetc_cons
	LIB	fgets_cons
	LIB	mkdir
	LIB	fputc
	LIB	isalpha
	LIB	remove
	LIB	isdigit
	LIB	scanf
	LIB	fputs
	LIB	isascii
	LIB	isalnum
	LIB	lseek
	LIB	vsprintf
	LIB	vfscanf
	LIB	toascii
	LIB	nropen
	LIB	writebyte
	LIB	fclose
	LIB	sleep
	LIB	iscntrl
	LIB	fgetpos
	LIB	printf
	LIB	sscanf
	LIB	fdopen
	LIB	printk
	LIB	printn
	LIB	fdtell
	LIB	closeall
	LIB	srand
	LIB	freopen_z88
	LIB	ungetc
	LIB	getarg
	LIB	atexit
	LIB	getcwd
	LIB	csleep
	LIB	getfree
	LIB	vfprintf_comp
	LIB	fscanf
	LIB	fabandon
	LIB	fdgetpos
	XREF	_vfprintf
	LIB	islower
	LIB	write
	LIB	fputc_cons
	LIB	puts_cons
	LIB	isspace


; --- End of Scope Defns ---


; --- End of Compilation ---
