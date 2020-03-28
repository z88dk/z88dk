/*
 * Find STRINGS in file
 * aralbrec @ z88dk.org
*/

// zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o strings -pragma-include:zpragma.inc -subtype=dot -Cz"--clean" -create-app

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdarg.h>
#include <input.h>
#include <ctype.h>
#include <errno.h>
#include <compress/zx7.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>

#include "user_interaction.h"

#define max(a,b)  (((a) > (b)) ? (a) : (b))

// command line parsing

struct opt
{
   unsigned int  length;       // minimum printable string length
   unsigned char printoffset;  // print offset where string found; 0 = no, o/x/d = oct/hex/dec
   unsigned char whitespace;   // if set \n \r are part of the string
   unsigned char *separator;   // print string between finds; 0 = none

   unsigned char  force;       // allow overwrite of output file; 0 = disallow overwrite
   unsigned char  append;      // append to output file instead of overwrite; 0 = overwrite
   unsigned char *outfile;     // output filename
   unsigned char *infile;      // input filename
};

struct opt options = {
   4,      // length
   0,      // printoffset
   0,      // whitespace
   "",     // separator
   0,      // force
   0,      // append
   0,      // outfile
};

extern unsigned char help[];

// global variables

unsigned char fin  = 0xff;   // file descriptor
unsigned char fout = 0xff;   // file descriptor

struct esx_stat st;          // file info

uint32_t      roffset;       // file offset to start of read buffer
unsigned char rbuffer[512];  // read buffer
unsigned char wbuffer[512];  // write buffer

// generate custom esxdos error report

#define ebuf rbuffer

int error(char *fmt, ...)
{
   unsigned char *p;
   
   va_list v;
   va_start(v, fmt);

#ifdef __SCCZ80
   vsnprintf(ebuf, sizeof(ebuf), va_ptr(v,char *), v);
#else
   vsnprintf(ebuf, sizeof(ebuf), fmt, v);
#endif

   for (p = ebuf; p = strchr(p, '\n'); )
      *p = '\r';
   
   ebuf[strlen(ebuf) - 1] += 0x80;  
   return (int)ebuf;
}

// clean up at exit

static unsigned char old_cpu_speed;

void cleanup(void)
{
   if (fin != 0xff) esx_f_close(fin);
   if (fout != 0xff) esx_f_close(fout);
   
   puts("    ");

   ZXN_NEXTREGA(REG_TURBO_MODE, old_cpu_speed);
}

// program start

int main(int argc, char **argv)
{
   unsigned char i;
   
   static unsigned int   wsize;
   static unsigned char *wptr;

   static unsigned int   rsize;
   static unsigned char *rptr;
   
   static uint32_t olen;
   static uint32_t moffset;

   // initialization
   
   old_cpu_speed = ZXN_READ_REG(REG_TURBO_MODE);
   ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);
   
   atexit(cleanup);

   // parse command line

   for (i = 2; i < (unsigned char)argc; ++i)
   {
      unsigned char *p  = argv[i];

      if (!stricmp(p, "-f"))
         options.force = 1;
      else if (!stricmp(p, "-a") || !stricmp(p, "-o"))
      {
         if (options.outfile != NULL)
            return error("%s: Second out file", p);
         
         options.append = *(p + 1) == 'a';
         options.outfile = argv[++i];
         
         if (*options.outfile == 0)
            return error("%s: Missing filename", p);
      }
      else if (!stricmp(p, "-n"))
      {
         unsigned char *end;
         
         i++;   // avoid double evaluation in max macro
         options.length = max(_strtou_(argv[i], &end, 0), 2);

         if (errno || *end)
            return error("%s: Bad argument %s", p, argv[i]);
      }
      else if (!stricmp(p, "-s"))
      {
         options.separator = argv[++i];
         
         if (*options.separator == 0)
            return error("%s: Missing separator", p);
      }
      else if (!stricmp(p, "-t"))
      {
         options.printoffset = *argv[++i];
         
         if ((*(argv[i] + 1)) || ((options.printoffset != 'd') && (tolower(options.printoffset) != 'x') && (options.printoffset != 'o')))
            return error("%s: Bad argument %s", p, argv[i]);
      }
      else if (!stricmp(p, "-w"))
         options.whitespace = 1;
      else
         return error("%s: Unknown option", p);
   }
   
   if ((unsigned char)argc < 2)
   {
      // compressed help text saves some memory
      
      *dzx7_standard(help, rbuffer) = 0;
      puts(rbuffer);

      return 0;
   }

   options.infile = argv[1];
   
   if (options.outfile && (!stricmp(options.outfile, options.infile)))
      return error("In and out files are same");
   
   // open input file
   
   if ((fin = esx_f_open(options.infile, ESX_MODE_OPEN_EXIST | ESX_MODE_R)) == 0xff)
      return error("%u: Can't open %s", errno, options.infile);

   // open output file
   
   if (options.outfile != NULL)
   {
      if (options.append)
         fout = esx_f_open(options.outfile, ESX_MODE_OPEN_CREAT | ESX_MODE_RW);
      else
         fout = esx_f_open(options.outfile, (options.force == 0) ? (ESX_MODE_OPEN_CREAT_NOEXIST | ESX_MODE_W) : (ESX_MODE_OPEN_CREAT_TRUNC | ESX_MODE_W));
      
      if (errno)
         return error("%u: Can't open %s%s", errno, options.outfile, options.force ? "" : " (-f)");
      
      if (options.append)
      {
         if (esx_f_fstat(fout, &st))
            return error("%u: Can't stat %s", errno, options.outfile);
         
         if (st.size > 0)
         {
            esx_f_seek(fout, st.size, ESX_SEEK_SET);
            
            if (errno)
               return error("Can't seek to %lu in\n%s", st.size, options.outfile);
         }
      }
   }
   
   // record input file size
   
   if (esx_f_fstat(fin, &st))
      return error("%u: Can't stat %s", errno, options.infile);
   
   // strings
   // relying on default initialization of some vars here
   
   rptr  = rbuffer;
   rsize = esx_f_read(fin, rbuffer, sizeof(rbuffer));
   
   if (errno)
      return error("%u: Can't read from %s", errno, options.infile);

   while (rsize)
   {   
      // match phase
   
      while (rsize)
      {
         for ( ; rptr < (rbuffer + rsize); rptr++)
         {
            user_interaction();
            
            if ((*rptr == '\t') || (options.whitespace && (*rptr == '\r' || *rptr == '\n')))
               continue;
      
            if (isspace(*rptr))
               goto end_match;

            if (!isprint(*rptr))
               goto end_match;
         }
      
         roffset += rsize;
         rptr = rbuffer;
      
         rsize = esx_f_read(fin, rbuffer, sizeof(rbuffer));
         
         if (errno)
            return error("%u: Failed read from %s", errno, options.infile);
         
         // heartbeat
         
         printf("%03u%%" "\x08\x08\x08\x08", (unsigned int)(roffset * 100 / st.size));
      }

end_match:

      // check printable string
   
      olen = (roffset - moffset) + (uint32_t)(rptr - rbuffer);

      if (olen >= (uint32_t)(options.length))
      {
         // rewind input file to start of match
      
         esx_f_seek(fin, moffset, ESX_SEEK_SET);
         
         if (errno)
            return error("%u: Can't seek to match string", errno);
      
         // write match offset
      
         if ((options.printoffset == 'o') || (options.printoffset == 'd') || (tolower(options.printoffset) == 'x'))
         {
            snprintf(wbuffer, sizeof(wbuffer), "%%7l%c ", options.printoffset);
            snprintf(wbuffer + 7, sizeof(wbuffer) - 7, wbuffer, moffset);
         
            if (fout != 0xff)
               esx_f_write(fout, wbuffer + 7, strlen(wbuffer + 7));
            else
               printf("%s", wbuffer + 7);
         }

         // copy matched string to output
      
         while (olen && (wsize = esx_f_read(fin, wbuffer, (olen > sizeof(wbuffer)) ? sizeof(wbuffer) : olen)))
         {
            olen -= wsize;
            
            user_interaction();
         
            // write to output
         
            if (fout != 0xff)
               esx_f_write(fout, wbuffer, wsize);
            else
            {
               for (wptr = wbuffer; wsize; --wsize,++wptr)
               {
                  if (*wptr == '\t')
                     printf("        ");
                  else
                     putc(*wptr, stdout);
               }
            }
         }
      
         // print separator
         // there is no easy way to enter \n on the command line so add it automatically
      
         if (fout != 0xff)
         {
            snprintf(wbuffer, sizeof(wbuffer), "%s%s\n", *options.separator ? "\n" : "", options.separator);
            esx_f_write(fout, wbuffer, strlen(wbuffer));
         }
         else
            printf("%s%s\n", *options.separator ? "\n" : "", options.separator);

         // outfile error
         
         if (errno || olen)
            return error("%u: Can't write to %s", errno, options.outfile);
         
         // repair read file pointer
      
         esx_f_seek(fin, roffset + rsize, ESX_SEEK_SET);
      }
   
      // resume match phase

      moffset = roffset + (uint32_t)(++rptr - rbuffer);
   }

   return 0;
}
