#include <stdio.h>
#include <nc.h>

/*
 *	Glue to make opendir API appear to work on an NC100
 */
 
static int d_inuse;
static int d_pos;

extern void __LIB__ *_findfirst(void);
extern void __LIB__ *_findnext(void);

/* For now we only do one dir */
DIR *opendir(const char *path)
{
  if (d_inuse)
    return NULL;

  _setdta(((struct nc_findfirst *)0xA000));	/* Reserved for the C lib */
  d_pos = 0;
  return (DIR *)0xA000;
}

int closedir(DIR *dp)
{
  d_inuse = 0;
  return 0;
}

struct dirent *readdir(DIR *dp)
{
  struct nc_findfirst *s;
  static struct dirent d;
  
  if (d_pos == 0) {
    memcpy(0xA000, "*.*", 4);
    s = _findfirst();
  }
  else
    s = _findnext();
    
  if (s == NULL)
    return NULL;
  d_pos++;
  memcpy(d.d_name, s->name, 12);
  d.d_ino = s->_oshandle;	/* Hack */
  d.d_attr = s->attr;
  d.d_size = s->size;
  d.d_time = s->time;
  d.d_date = s->date;
  return &d;
}

int seekdir(DIR *dp, long pos)
{
  if (d_pos == pos)
    return;
  d_pos = pos;
  
  while(d_pos != pos)
    if (readdir(dp) == NULL)
      return -1;
  return 0;
}

long telldir(DIR *dp)
{
  return d_pos;
}
