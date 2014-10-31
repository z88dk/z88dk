#include <stdio.h>

extern unsigned int __LIB__ __FASTCALL__ nc_lsize(unsigned int handle);
extern unsigned int __LIB__ __FASTCALL__ nc_ltell(unsigned int handle);
extern unsigned int __LIB__ nc_lseek(unsigned int handle, unsigned int pos);


long lseek(int fd, long posn, int whence)
{
  switch(whence) {
    case 1:
      posn += nc_ltell(fd);
    case 2:
      posn = _fsizehandle(fd) - posn;
  }
  if (posn < 0 || posn > 0xFFFF)
    return -1L;
  return nc_lseek(fd, posn & 0xFFFF);
}

