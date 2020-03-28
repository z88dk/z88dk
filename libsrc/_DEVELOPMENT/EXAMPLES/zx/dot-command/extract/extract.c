/*
 * EXTRACT bytes from a file
 * aralbrec @ z88dk.org
*/

// ZX SPECTRUM
//
// zcc +zx -vn -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size extract.c help-zx.asm -o extract -subtype=dot -create-app
// zcc +zx -vn -startup=30 -clib=new extract.c help-zx.asm -o extract -subtype=dot -create-app

// ZX NEXT
//
// zcc +zxn -vn -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size extract.c help-zxn.asm -o extract -subtype=dot -create-app
// zcc +zxn -vn -startup=30 -clib=new extract.c help-zxn.asm -o extract -subtype=dot -create-app

#pragma printf = "s X c u lu lX"
#pragma output CLIB_EXIT_STACK_SIZE = 1

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdarg.h>
#include <errno.h>
#include <limits.h>
#include <ctype.h>
#include <compress/zx7.h>
#include <input.h>
#include <z80.h>

#if __ZXNEXT

#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>

#else

#include <arch/zx.h>
#include <arch/zx/esxdos.h>

#endif

// command line parsing

struct opt
{
   unsigned char *inname;    // input filename
   int32_t        offset;    // starting byte offset into input file (negative is offset from end)
   uint32_t       length;    // number of bytes to extract
   
   unsigned char  force;     // allow overwrite of output file (0 = disallow overwrite)
   unsigned char  append;    // append to output file instead of overwrite (0 = overwrite)
   unsigned char *outname;   // output filename (NULL = none)
   unsigned char  mem;       // writing to memory if non-zero, mem=1 for current 64k, mem=2 for zx next linearized
   unsigned long  memaddr;   // destination memory address
};

struct opt options;          // all initialized to zero

// global variables

unsigned char fin  = 0xff;   // file descriptor
unsigned char fout = 0xff;   // file descriptor

struct esxdos_stat st;       // file info

unsigned char buffer[512];   // file buffer

unsigned char mmu2_state;

extern unsigned char help[]; // compressed help text

// generate custom esxdos error report

#define ebuf buffer

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
   
   ebuf[strlen(ebuf)-1] += 0x80;  
   return (int)ebuf;
}

// hex dump

void hexdump(uint32_t base, unsigned char *lbuffer, uint16_t len)
{
   static unsigned char *buffer;
   
   buffer = lbuffer;

   while (len)
   {
      unsigned char i;
      
      printf("%08lX\n", base);
      
      for (i = 0; (i != 8) && (i < len); ++i)
         printf("%02X ", buffer[i]);
      
      if (i != 8)
         printf("%*s", (8 - i) * 3, "");
      
      for (i = 0; (i != 8) && (i < len); ++i)
         printf("%c", isprint(buffer[i]) ? buffer[i] : '?');
      
      if (i != 8)
         printf("\n");
      
      base += i;
      buffer += i;
      
      len -= i;
   }
}

// clean up at exit

void cleanup_files(void)
{
   if (fin != 0xff)
      esxdos_f_close(fin);
   
   if (fout != 0xff)
      esxdos_f_close(fout);
}

#if __ZXNEXT

// determine 8k page from linear address

unsigned long page_number(unsigned long address)
{
   return (address & 0xffffe000) >> 13;
}

// bank 8k page into mmu2
// return non-zero if successful

unsigned char page_present(unsigned long address)
{
   unsigned char p;
   unsigned char q;
   
   // maximum of 224 8k pages on the zx next
   
   if ((p = (unsigned char)(page_number(address))) >= 224)
      return 0;
   
   // page in bank and test for presence
   
   ZXN_WRITE_MMU2(p);
   
   p = z80_bpeek(0x4000);
   
   z80_bpoke(0x4000, ~p);
   
   q = z80_bpeek(0x4000);
   
   z80_bpoke(0x4000, p);
   
   return q == (unsigned char)(~p);
}

#endif

// program starts

int main(int argc, char **argv)
{
   static unsigned char hex;
   static unsigned int  size;
   static uint32_t      remaining;
   static uint32_t      total;
   
   unsigned char i;
   
   // parse command line

   for (i = 2; i < (unsigned char)argc; ++i)
   {
      unsigned char *p = argv[i];
      
      if (!stricmp(p, "-f"))
         options.force = 1;
      else if (!stricmp(p, "-o") || !stricmp(p, "-a"))
      {
         if (options.outname != NULL)
            return error("%s: Second out file", p);
         
         options.append = *(p + 1) == 'a';
         options.outname = argv[++i];

         if (*options.outname == 0)
            return error("%s: Missing out file", p);
      }
#if __ZXNEXT
      else if (!stricmp(p, "-m") || !stricmp(p, "-ml") || !stricmp(p, "-mb") || !stricmp(p, "-mp"))
#else
      else if (!stricmp(p, "-m"))
#endif
      {
         unsigned char *end;
         
         if (options.mem != 0)
            return error("%s: Second address", p);
         
         options.mem = 2 - (*(p + 2) == 0);
         options.memaddr = strtoul(argv[++i], &end, 0);

			if (errno || *end)
            return error("%s: Bad address", p);
			
			if (*(p + 2) == 'b')
				options.memaddr *= 0x4000U;   // 16k bank number given
			
			if (*(p + 2) == 'p')
				options.memaddr *= 0x2000U;   // 8k page number given

         if (((options.mem == 1) && (options.memaddr & 0xffff0000UL)) || ((options.mem == 2) && ((unsigned int)(options.memaddr >> 16) >= 28U)))
            return error("%s: Out of range", p);
      }
      else if ((*p == '+') || (*p == '-'))
      {
         unsigned char *end;
         
         if (options.offset != 0)
            return error("%s: Second offset", p);
         
         options.offset = strtol(p, &end, 0);
         
         if (errno || *end)
            return error("%s: Bad offset", p);
      }
      else
      {
         unsigned char *end;
         
         if (options.length != 0)
            return error("%s: Second length", p);
         
         options.length = strtoul(p, &end, 0);
         
         if (errno || *end)
            return error("%s: Length expected", p);
      }
   }
   
   if ((unsigned char)argc < 2)
   {
      // zx7 compressed the help text from 434 bytes to 266 bytes.
      // the decompressor is somewhere around 70-80 bytes.
      
      dzx7_standard(help, buffer);
      printf("%s", buffer);
      
      return 0;
   }
   
   options.inname = argv[1];
   if (options.outname && (stricmp(options.outname, options.inname) == 0))
      return error("In and out files are same");
   
   atexit(cleanup_files);
   
   // open input file
   
   fin = esxdos_f_open(options.inname, ESXDOS_MODE_OPEN_EXIST | ESXDOS_MODE_R);
   
   if (errno)
      return error("%u: Can't open %s", errno, options.inname);
   
   if (options.offset)
   {
      if (esxdos_f_fstat(fin, &st) < 0)
         return error("%u: Can't stat %s", errno, options.inname);
      
      if (options.offset < 0)
         if ((int32_t)(options.offset += st.size) < 0)
            options.offset = 0;
   
      esxdos_f_read(fin, buffer, 1);   // reported bug: esxdos cannot seek unless r/w has occurred first
      esxdos_f_seek(fin, options.offset, ESXDOS_SEEK_SET);
   
      if (errno)
         return error("Can't seek to %lu in\n%s", options.offset, options.inname);
   }
   
   // open output file
   
   if (options.outname != NULL)
   {
      if (options.append)
         fout = esxdos_f_open(options.outname, ESXDOS_MODE_OPEN_CREAT | ESXDOS_MODE_R | ESXDOS_MODE_W);
      else
         fout = esxdos_f_open(options.outname, (options.force == 0) ? ESXDOS_MODE_CREAT_NOEXIST | ESXDOS_MODE_W : ESXDOS_MODE_CREAT_TRUNC | ESXDOS_MODE_W);
      
      if (errno)
         return error("%u: Can't open %s%s", errno, options.outname, options.force ? "" : " (-f)");
      
      if (options.append)
      {
         if (esxdos_f_fstat(fout, &st) < 0)
            return error("%u: Can't stat %s", errno, options.outname);
         
         if (st.size > 0)
         {
            esxdos_f_read(fout, buffer, 1);   // reported bug: esxdos cannot seek unless r/w has occurred first
            esxdos_f_seek(fout, st.size, ESXDOS_SEEK_SET);
            
            if (errno)
               return error("Can't seek to %lu in\n%s", st.size, options.outname);
         }
      }
   }
   
   // copy input to output
   
   hex = (fout == 0xff) && (options.mem == 0);
   remaining = (options.length == 0) ? ULONG_MAX : options.length;
   total = 0UL;

   while (remaining && (size = esxdos_f_read(fin, buffer, (remaining > sizeof(buffer)) ? sizeof(buffer) : remaining)))
   {
      remaining -= size;
      
      // write to output file
      
      if (fout != 0xff)
      {
         esxdos_f_write(fout, buffer, size);
         
         if (errno)
            return error("%u: Error writing file", errno);
      }
      
      // write to 64k memory

      if (options.mem == 1)
      {
         unsigned int max;
         
         max = (unsigned int)(0x10000UL - options.memaddr);
         
         if (size >= max)
         {
            memcpy((void*)options.memaddr, buffer, max);
            options.mem = 0;
            
            if (fout == 0xff)
               break;
         }
         else
         {
            memcpy((void*)options.memaddr, buffer, size);
            options.memaddr += size;
         }
      }

#if __ZXNEXT

      // write to zx next paged memory
      
      if (options.mem == 2)
      {
         unsigned int tmp;
         unsigned int max;
         
         mmu2_state = ZXN_READ_MMU2();
         
         for (tmp = size; tmp; tmp -= max)
         {
            // how much space left in this 8k page?
            
            max = 0x2000 - (unsigned int)(options.memaddr & 0x1fff);
            if (max >= tmp) max = tmp;
            
            // page 8k into mmu2
            
            if (page_present(options.memaddr) == 0)
               break;
            
            memcpy((void*)((unsigned int)(options.memaddr & 0x1fff) + 0x4000), buffer, max);
            options.memaddr += max;
         }
         
         ZXN_WRITE_MMU2(mmu2_state);
         
         if (tmp)
         {
            options.mem = 0;
            printf("Stopped at page %u (%lu bytes)\n", (unsigned int)(page_number(options.memaddr)), total);
            
            if (fout == 0xff)
               break;
         }
      }

#endif

      // hexdump
      
      if (hex)
         hexdump(total + options.offset, buffer, size);
      
      // track bytes transferred
      
      total += size;
      
      // allow user to interrupt
      
      if (in_key_pressed(IN_KEY_SCANCODE_SPACE | 0x8000))
      {
         in_wait_nokey();
         return error("L Break into Program");
      }
   }
   
   if (errno)
      return error("Error reading file");

   // success
   
   return 0;
}
