# 1 "fflush.c"

# 13 "/home/dom/z88dk/include/sys/types.h"
typedef unsigned int size_t;




typedef signed int ssize_t;




typedef unsigned long clock_t;




typedef signed int pid_t;




typedef unsigned char bool_t;




typedef long time_t;




typedef short wild_t;




typedef unsigned long fpos_t;



typedef unsigned char u8_t;
typedef unsigned short u16_t;
typedef unsigned long u32_t;

typedef char i8_t;
typedef short i16_t;
typedef long i32_t;
# 28 "/home/dom/z88dk/include/fcntl.h"
typedef int mode_t;


extern int __LIB__ open(far char *name, int flags, mode_t mode);
extern int __LIB__ creat(far char *name, mode_t mode);
extern int __LIB__ close(int fd);
extern size_t __LIB__ read(int fd, void *ptr, size_t len);
extern size_t __LIB__ write(int fd, void *ptr, size_t len);
extern long __LIB__ lseek(int fd,long posn, int whence);

extern int __LIB__ __FASTCALL__ readbyte(int fd);
extern int __LIB__ __FASTCALL__ writebyte(int fd, int c);



extern int __LIB__ open_z88(far char *name, int flags, mode_t mode, char *explicit, size_t len);



extern int __LIB__ nropen(char *name, int flags, mode_t mode, char *explicit, size_t len);

#pragma  output ANSIstdio
# 35 "/home/dom/z88dk/include/stdio.h"
struct filestr {
union f0xx {
int fd;
u8_t *ptr;
} desc;
u8_t flags;
u8_t ungetc;
};
#asm




DEFVARS 0 {
fp_desc ds.w 1
fp_flags ds.b 1
fp_ungetc ds.b 1
}
#endasm
# 69
extern struct filestr _sgoioblk[10];
# 81
extern int __LIB__ fflush(FIlE *)
# 88
extern struct filestr __LIB__ *fopen(far char *name, unsigned char *mode);
extern struct filestr __LIB__ *fopen_z88(far char *name, unsigned char *mode, unsigned char *explicit, size_t len);
extern struct filestr __LIB__ *freopen(far char *name, unsigned char *mode, struct filestr *fp);
extern struct filestr __LIB__ *freopen_z88(far char *n, unsigned char *m, struct filestr *fp, unsigned char *explicit, size_t len);
extern struct filestr __LIB__ *fdopen(int fildes, unsigned char *mode);

extern int __LIB__ fclose(struct filestr *fp);

extern void __LIB__ closeall();


extern char __LIB__ *fgets(unsigned char *s, int, struct filestr *fp);
extern int __LIB__ fputs(unsigned char *s, struct filestr *fp);
extern int __LIB__ fputc(int c, struct filestr *fp);
extern int __LIB__ fgetc(struct filestr *fp);
extern int __LIB__ ungetc(int c, struct filestr *);
extern int __LIB__ feof(struct filestr *fp);
extern int __LIB__ puts(unsigned char *);


extern fpos_t __LIB__ ftell(struct filestr *fp);
extern int __LIB__ fgetpos(struct filestr *fp, fpos_t *pos);


extern int __LIB__ fseek(struct filestr *fp, fpos_t offset, int whence);
# 129
extern int __LIB__ printf(char *,...);
extern int __LIB__ fprintf(struct filestr *,char *,...);
extern int __LIB__ sprintf(char *,char *,...);
extern int vfprintf(struct filestr *,unsigned char *fmt,void *ap);
extern int __LIB__ vsprintf(char *str,unsigned char *fmt,void *ap);
# 139
extern int __LIB__ vfprintf_mini(struct filestr *, unsigned char *, void *);
extern int __LIB__ vfprintf_comp(struct filestr *, unsigned char *, void *);

extern __LIB__ printn(int number, int radix,struct filestr *file);
# 148
extern int __LIB__ scanf(unsigned char *fmt,...);
extern int __LIB__ fscanf(struct filestr *,unsigned char *fmt,...);
extern int __LIB__ sscanf(char *,unsigned char *fmt,...);
extern int __LIB__ vfscanf(struct filestr *, unsigned char *fmt, void *ap);
extern int __LIB__ vsscanf(char *str, unsigned char *fmt, void *ap);
# 162
extern int __LIB__ getarg(void);
# 176
extern int __LIB__ fchkstd(struct filestr *);


extern int __LIB__ fgetc_cons();
extern int __LIB__ fputc_cons(char c);
extern int __LIB__ fgets_cons(char *s, int n);

extern void __LIB__ fabandon(struct filestr *);

extern long __LIB__ fdtell(int fd);
extern int __LIB__ fdgetpos(int fd, fpos_t *posn);

extern int __LIB__ rename(char *s, char *d);

extern int __LIB__ remove(char *name);
# 200
extern int __LIB__ getk();

extern void __LIB__ puts_cons();
extern void __LIB__ printk(char *fmt,...);
# 11 "/home/dom/z88dk/include/net/stdio.h"
extern int __LIB__ fgetc_net(void *s);
extern int __LIB__ fputc_net(void *s, int c);
extern int __LIB__ closenet(void *s);
extern int __LIB__ opennet(struct filestr *fp, char *name,char *exp, size_t len);
# 15 "fflush.c"
int fflush(struct filestr *fp)
{
#asm



pop bc
pop ix
push ix
push bc
ld hl,-1 ;(-1)
ld a,(ix+fp_flags)
ld c,a
and 1
ret z ;not used
ld a,c
and 32
ret z ;not network
ld l,(ix+fp_desc)
ld h,(ix+fp_desc+1)
push hl
call fflush_net
pop bc
#endasm
# 51
}
