/*
  Bin2Var by David Phillips <david@acz.org>
  Converts binary images to TI Graph Link format files

  1.00 -- 08/22/00
    * first release
    * support for 83P, 8XP

  1.10 -- 08/23/00
    * made code more modular
    * added support for 82P, 86P, 86S
    * fixed __MSDOS__ macro spelling to be correct

  1.20 -- 08/24/00
    * added suport for 85S
    * corrected header for 8XP
    * changed error message printing to use stderr

  Edited by Jeremy Drake to add the tasmCmp symbol to 8XP files
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
#include <string.h>

#if (!defined(__MSDOS__)) && (!defined(__WIN32__))
#define stricmp strcasecmp
#endif

enum EXT { E_82P, E_83P, E_8XP, E_85S, E_86P, E_86S };

void die(const char *fmt, ...)
{
  va_list argptr;

  if (fmt)
  {
    va_start(argptr, fmt);
    vfprintf(stderr, fmt, argptr);
    va_end(argptr);
  }
  else
    fprintf(stderr, "Usage: bin2var input.bin output.ext\n\n"
                    "Valid extensions for the output file: "
                      "82p, 83p, 8xp, 85s, 86p, 86s\n");
  exit(1);
}

int fsize(FILE *fp)
{
  int p, size;

  p = ftell(fp);
  fseek(fp, 0L, SEEK_END);
  size = ftell(fp);
  fseek(fp, p, SEEK_SET);

  return size;
}

void cfwrite(const void *buf, int len, FILE *fp, unsigned short *chk)
{
  int i;

  fwrite(buf, len, 1, fp);
  for(i = 0; i < len; i++)
    *chk += ((unsigned char *)buf)[i];
}

void writecomment(FILE *fp, const char *comment)
{
  char str[50];

  fwrite(comment, strlen(comment), 1, fp);
  memset(str, 0, 42);
  fwrite(str, 42 - strlen(comment), 1, fp);
}

void genname(const char *fname, char *name)
{
  char str[256], *c;

  strcpy(str, fname);
  c = strchr(str, '.');
  if ((c - str) > 8)
    c[8] = 0;
  else
    *c = 0;
  c = str - 1;
  do
  {
    c++;
    *c = toupper(*c);
    if (!isalnum(*c))
      *c = 0;
  } while (*c != 0);
  if (!strlen(str))
    die("A valid variable name could not be generated!\n");
  strcpy(name, str);
}

int main(int argc, char* argv[])
{
  const char *comment = "Created with Bin2Var v1.10";
  FILE *fp;
  char *buf, str[256], *c;
  int i, n, ext, n2;
  unsigned short chk;

  printf("Bin2Var v1.20 by David Phillips <david@acz.org>\n\n");
  if (argc != 3)
    die(0);

  buf = strrchr(argv[2], '.');
  if (!buf)
    die("Output file must have an extension!\n");
  if (!stricmp(buf, ".82p"))
    ext = E_82P;
  else if (!stricmp(buf, ".83p"))
    ext = E_83P;
  else if (!stricmp(buf, ".8xp"))
    ext = E_8XP;
  else if (!stricmp(buf, ".85s"))
    ext = E_85S;
  else if (!stricmp(buf, ".86p"))
    ext = E_86P;
  else if (!stricmp(buf, ".86s"))
    ext = E_86S;
  else
    die("Extension \'%s\' is not supported!\n", buf);
  genname(argv[2], str);

  fp = fopen(argv[1], "rb");
  if (!fp)
    die("Failed to open input file: %s\n", argv[1]);
  n = fsize(fp);
  buf = (char *)malloc(n);
  fread(buf, n, 1, fp);
  if (ferror(fp))
    die("Error reading input file: %s\n", argv[1]);
  fclose(fp);
  fp = fopen(argv[2], "wb");
  if (!fp)
    die("Failed to open output file: %s\n", argv[2]);
  chk = 0;

  if (ext == E_82P)
    fwrite("**TI82**\x1a\x0a\x00", 11, 1, fp);
  else if (ext == E_83P)
    fwrite("**TI83**\x1a\x0a\x00", 11, 1, fp);
  else if (ext == E_8XP)
    fwrite("**TI83F*\x1a\x0a\x00", 11, 1, fp);
  else if (ext == E_85S)
    fwrite("**TI85**\x1a\x0c\x00", 11, 1, fp);
  else if ((ext == E_86P) || (ext == E_86S))
    fwrite("**TI86**\x1a\x0a\x00", 11, 1, fp);
  writecomment(fp, comment);
  if ((ext == E_82P) || (ext == E_83P))
    i = n + 17;
  else if (ext == E_8XP)
	  i = n + 19;
  else if (ext == E_85S)
    i = n + 10 + strlen(str);
  else
    i = n + 18;
  fwrite(&i, 2, 1, fp);
  if ((ext == E_82P) || (ext == E_83P) || (ext == E_8XP))
    cfwrite("\x0b\0x00", 2, fp, &chk);
  else if (ext == E_85S)
  {
    i = 4 + strlen(str);
    cfwrite(&i, 1, fp, &chk);
    cfwrite("\0x00", 1, fp, &chk);
  }
  else
    cfwrite("\x0c\0x00", 2, fp, &chk);
  if(ext == E_8XP)
	  i = n + 4;
  else
	  i = n + 2;

  cfwrite(&i, 2, fp, &chk);
  if ((ext == E_82P) || (ext == E_83P) || (ext == E_8XP))
    cfwrite("\x06", 1, fp, &chk);
  else if (ext == E_86P)
    cfwrite("\x12", 1, fp, &chk);
  else if ((ext == E_85S) || (ext == E_86S))
    cfwrite("\x0c", 1, fp, &chk);
  i = strlen(str);
  if ((ext == E_85S) || (ext == E_86P) || (ext == E_86S))
    cfwrite(&i, 1, fp, &chk);
  cfwrite(str, i, fp, &chk);
  memset(str, 0, 8);
  if (ext != E_85S)
    cfwrite(str, 8 - i, fp, &chk);
  if (ext == E_8XP)
  {
	i = n + 4;
	n2 = n + 2;
  }
  else
  {
	i = n + 2;
    n2 = n;
  }
  cfwrite(&i, 2, fp, &chk);
  cfwrite(&n2, 2, fp, &chk);
  if(ext == E_8XP)
  {
	  cfwrite("\xBB", 1, fp, &chk);
	  cfwrite("\x6D", 1, fp, &chk);
  }
  cfwrite(buf, n, fp, &chk);
  fwrite(&chk, 2, 1, fp);

  if (ferror(fp))
    die("Failed writing output file: %s\n", argv[2]);
  fclose(fp);
  free(buf);
  printf("'%s' successfully converted to '%s'\n", argv[1], argv[2]);

  return 0;
}

