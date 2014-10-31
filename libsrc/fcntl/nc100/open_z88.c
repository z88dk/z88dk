#include <stdio.h>
#include <fcntl.h>

int open_z88(far char *nam, int flags, mode_t mode, char *outbuf, size_t extlen)
{
  return open(nam, flags, mode);
}
