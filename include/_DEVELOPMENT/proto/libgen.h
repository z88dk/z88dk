include(__link__.m4)

#ifndef __LIBGEN_H__
#define __LIBGEN_H__

__D2PROTO(,,char,*,basename,char *path)
__D2PROTO(,,char,*,basename_ext,char *path)
__D2PROTO(,,char,*,dirname,char *path)
__DPROTO(`b,c',`b,c',unsigned char,,glob,const char *s, const char *pattern)
__DPROTO(`b,c',`b,c',unsigned char,,glob_dos,const char *s, const char *pattern)
__DPROTO(`b,c',`b,c',unsigned char,,glob_fat,const char *s, const char *pattern)
__D2PROTO(,,char,*,pathnice,char *path)

#endif
