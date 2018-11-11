/*
 * EXTRACT bytes from a file
 * aralbrec @ z88dk.org
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdarg.h>
#include <errno.h>
#include <limits.h>
#include <ctype.h>
#include <compress/zx7.h>
#include <z80.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>

#include "user_interaction.h"

#define min(a,b)  (((a) < (b)) ? (a) : (b))

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

unsigned char  mmu_reg;      // 8k mmu register to use when loading memory
unsigned char *mmu_addr;     // start address of mmu slot

struct esx_mode screen_mode; // information about screen
struct esx_stat st;          // file info

unsigned char buffer[512];   // file buffer

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
   
   ebuf[strlen(ebuf) - 1] += 0x80;  
   return (int)ebuf;
}

// hex dump

void hexdump(uint32_t base, unsigned char *lbuffer, uint16_t len)
{
   static unsigned char *buffer;
   static unsigned char N;
   
   buffer = lbuffer;
   N = screen_mode.cols ? screen_mode.cols : 8;

   while (len)
   {
      unsigned char i;
      
      printf("%08lX%s", base, (screen_mode.cols == 0) ? "\n" : " ");

      for (i = 0; (i != N) && (i < len); ++i)
         printf("%02X ", buffer[i]);

      if (i != N)
         printf("%*s", (N - i) * 3, "");

      for (i = 0; (i != N) && (i < len); ++i)
      {
         printf("%c", isprint(buffer[i]) ? buffer[i] : '?');
         
         if (screen_mode.cols && ((i & 0x7) == 0x7))
            printf(" ");
      }
      
      if (screen_mode.cols || (i != N))
         printf("\n");
      
      base += i;
      buffer += i;
      
      len -= i;
   }
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

// bank 8k page into mmu2
// return non-zero if successful

unsigned char page_present(unsigned long address)
{
   unsigned char p;
   unsigned char q;
   
   // maximum of 224 8k pages on the zx next
   
   if ((p = zxn_page_from_addr(address)) > (unsigned char)__ZXNEXT_LAST_PAGE)
      return 0;
   
   // page in bank and test for presence
   
   ZXN_WRITE_REG(mmu_reg, p);

   p = z80_bpeek(mmu_addr);
   z80_bpoke(mmu_addr, ~p);
   
   q = z80_bpeek(mmu_addr);
   z80_bpoke(mmu_addr, p);
   
   return q == (unsigned char)(~p);
}

// program starts

extern unsigned char extract_get_mmu(void) __preserves_regs(b,c,d,e);

int main(int argc, char **argv)
{
   static unsigned char hex;
   static unsigned int  size;
   
   static uint32_t      remaining;
   static uint32_t      total;
   
   static uint32_t      transferred;
   static uint32_t      transfer_size;
   
   unsigned char i;
   
   // initialization

   old_cpu_speed = ZXN_READ_REG(REG_TURBO_MODE);
   ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);
   
   atexit(cleanup);
   
   // determine which mmu slot to use for paging
   
   mmu_reg = extract_get_mmu() + REG_MMU0;
   mmu_addr = (void *)zxn_addr_from_page(mmu_reg - REG_MMU0);

   // find out screen column width
   // esxdos ruled out by crt
   
   if ((esx_m_dosversion() == ESX_DOSVERSION_NEXTOS_48K) || esx_ide_mode_get(&screen_mode))
      screen_mode.cols = 32;
   
   screen_mode.cols = ((screen_mode.cols - 9) / 33) * 8;   // calculation for hexdump

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
      else if (!stricmp(p, "-m") || !stricmp(p, "-ml") || !stricmp(p, "-mb") || !stricmp(p, "-mp"))
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

         if (((options.mem == 1) && (options.memaddr & 0xffff0000UL)) || ((options.mem == 2) && ((options.memaddr >> 12) > __ZXNEXT_LAST_PAGE)))
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
      // compressed help text saves some space
      
      *dzx7_standard(help, buffer) = 0;
      puts(buffer);
      
      return 0;
   }
   
   options.inname = argv[1];
   if (options.outname && (stricmp(options.outname, options.inname) == 0))
      return error("In and out files are same");
   
   // open input file
   
   if ((fin = esx_f_open(options.inname, ESX_MODE_OPEN_EXIST | ESX_MODE_R)) == 0xff)
      return error("%u: Can't open %s", errno, options.inname);

   if (esx_f_fstat(fin, &st))
      return error("%u: Can't stat %s", errno, options.inname);

   if (options.offset)
   {
      if (options.offset < 0)
         if ((int32_t)(options.offset += st.size) < 0)
            options.offset = 0;
      
      if (options.offset >= st.size)
         return error("Offset exceeds input size");

      esx_f_seek(fin, options.offset, ESX_SEEK_SET);
   
      if (errno)
         return error("Can't seek to %lu in %s", options.offset, options.inname);
   }
   
   // transfer size

   remaining = (options.length == 0) ? ULONG_MAX : options.length;
   transfer_size = min((unsigned long)(st.size - options.offset), remaining);

   // open output file
   
   if (options.outname != NULL)
   {
      if (options.append)
         fout = esx_f_open(options.outname, ESX_MODE_OPEN_CREAT | ESX_MODE_RW);
      else
         fout = esx_f_open(options.outname, (options.force == 0) ? (ESX_MODE_OPEN_CREAT_NOEXIST | ESX_MODE_W) : (ESX_MODE_OPEN_CREAT_TRUNC | ESX_MODE_W));
      
      if (errno)
         return error("%u: Can't open %s%s", errno, options.outname, options.force ? "" : " (-f)");
      
      if (options.append)
      {
         if (esx_f_fstat(fout, &st))
            return error("%u: Can't stat %s", errno, options.outname);
         
         if (st.size > 0)
         {
            esx_f_seek(fout, st.size, ESX_SEEK_SET);
            
            if (errno)
               return error("Can't seek to %lu in %s", st.size, options.outname);
         }
      }
   }
   
   // copy input to output
   
   hex = (fout == 0xff) && (options.mem == 0);
   total = 0UL;

   while (remaining && (size = esxdos_f_read(fin, buffer, (remaining > sizeof(buffer)) ? sizeof(buffer) : remaining)))
   {
      remaining -= size;
      
      // write to output file
      
      if (fout != 0xff)
      {
         if (esx_f_write(fout, buffer, size) != size)
            return error("%u: Error writing file", errno);
         
         transferred += size;
         printf("%03u%%" "\x08\x08\x08\x08", (unsigned int)(transferred * 100 / transfer_size));
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

      // write to zx next paged memory
      
      if (options.mem == 2)
      {
         static unsigned char mmu_state;
         
         unsigned int tmp;
         unsigned int max;
         
         mmu_state = ZXN_READ_REG(mmu_reg);
         
         for (tmp = size; tmp; tmp -= max)
         {
            // how much space left in this 8k page?
            
            max = 0x2000 - (unsigned int)(options.memaddr & 0x1fff);
            if (max >= tmp) max = tmp;
            
            // page 8k into mmu5
            
            if (page_present(options.memaddr) == 0)
               break;
            
            memcpy((void*)((unsigned int)(options.memaddr & 0x1fff) + mmu_addr), buffer, max);
            options.memaddr += max;
         }
         
         ZXN_WRITE_REG(mmu_reg, mmu_state);
         
         if (tmp)
         {
            options.mem = 0;
            printf("Stopped at page %u (%lu bytes)\n", (unsigned int)(zxn_page_from_addr(options.memaddr)), total);
            
            if (fout == 0xff)
               break;
         }
      }

      // hexdump
      
      if (hex)
         hexdump(total + options.offset, buffer, size);
      
      // track bytes transferred
      
      total += size;
      
      // allow user to interrupt
      
      user_interaction();
   }
   
   if (errno)
      return error("Error reading file");

   // success
   
   return 0;
}
