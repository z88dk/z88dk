/*
 * (c) Copyright 2015 by Einar Saukas. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * The name of its author may not be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * Modified for 48k ZX Next by z88dk.org.  Program performs identically.
 * zcc +zxn -v -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size @zproject.lst -o dzx7 -pragma-include:zpragma.inc -subtype=dot -Cz"--clean --exclude-sections IGNORE" -create-app
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <z80.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>

#include "user_interaction.h"

#define BUFFER_SIZE     16384   // must be > MAX_OFFSET, must remain consistent with dzx7.asm
#define BUFFER_ADDR    (65536 - BUFFER_SIZE*2)

unsigned char ifp = 0xff;
unsigned char ofp = 0xff;

unsigned char *input_name;
unsigned int   input_name_sz;

unsigned char  output_name[ESX_FILENAME_LFN_MAX + 1];

extern unsigned char input_data[BUFFER_SIZE];
extern unsigned char output_data[BUFFER_SIZE];

unsigned int input_index;
unsigned int output_index;

unsigned long input_size;
unsigned long output_size;

struct esx_stat es;

unsigned int partial_counter;

unsigned char bit_mask;
unsigned char bit_value;

// custom esxdos error report

#define ebuf input_data

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

// dzx7 functions

unsigned char read_byte(void)
{
   if (input_index == partial_counter)
   {
      input_index = 0;
      partial_counter = esxdos_f_read(ifp, input_data, BUFFER_SIZE);
      input_size += partial_counter;
      
      if (partial_counter == 0)
         exit(error(input_size ? "Truncated input file %s" : "Empty input file %s", input_name));
   }
   
   return input_data[input_index++];
}

unsigned char read_bit(void)
{
   bit_mask >>= 1;
   
   if (bit_mask == 0)
   {
      bit_mask = 0x80;
      bit_value = read_byte();
   }
   
   return (bit_value & bit_mask) ? 1 : 0;
}

unsigned int read_elias_gamma(void)
{
   unsigned int value;
   unsigned char i;
   
   for (i = 0; !read_bit(); ++i) ;
   
   if (i > 15)
      return -1;
   
   for (value = 1; i; --i)
      value = (value << 1) | read_bit();
   
   return value;
}

unsigned int read_offset(void)
{
   unsigned int value;
   unsigned char i;
   
   value = read_byte();
   
   if (value < 128)
      return value;

   i = read_bit();
   i = (i << 1) | read_bit();
   i = (i << 1) | read_bit();
   i = (i << 1) | read_bit();
      
   return (value & 0x7f) | ((unsigned int)i << 7) + 0x80;
}

void save_output(void)
{
   if (output_index)
   {
      if (esx_f_write(ofp, output_data, output_index) != output_index)
         exit(error("Can't write output file %s", output_name));
      
      output_size += output_index;
      output_index = 0;
      
      // print percentage progress

      printf("%03u%%" "\x08\x08\x08\x08", (unsigned int)(input_size * 100 / es.size));
      user_interaction();
   }
}

void write_byte(unsigned char value)
{
   output_data[output_index++] = value;
   
   if (output_index == BUFFER_SIZE)
      save_output();
}

void write_bytes(unsigned int offset, unsigned int length)
{
   int i;
   
   if (offset > output_size+output_index)
      exit(error("Invalid data in input file %s", input_name));
   
   while (length-- > 0)
   {
      i = output_index - offset;
      write_byte(output_data[(i >= 0) ? i : BUFFER_SIZE+i]);
   }
}

void decompress(void)
{
   unsigned int length;

   input_size = 0;
   input_index = 0;
   partial_counter = 0;
   output_index = 0;
   output_size = 0;
   bit_mask = 0;
   
   write_byte(read_byte());
   while (1)
   {
      if (!read_bit())
         write_byte(read_byte());
      else
      {
         length = read_elias_gamma() + 1;
         
         if (length == 0)
         {
            save_output();
            
            if (input_index != partial_counter)
               exit(error("Input file %s too long", input_name));
            
            return;
         }
         
         write_bytes(read_offset() + 1, length);
      }
      
      // allow user to interrupt
      
      user_interaction();
   }  
}

// cleanup on exit

static unsigned char old_cpu_speed;
static unsigned char mode_zxnext;

void cleanup(void)
{
   if (ifp != 0xff) esx_f_close(ifp);
   if (ofp != 0xff) esx_f_close(ofp);

   puts("    ");

   if (mode_zxnext)
      ZXN_NEXTREGA(REG_TURBO_MODE, old_cpu_speed);
}

// program start

int main(int argc, char **argv)
{
   static unsigned char forced_mode;
   unsigned char i;
   
   // initialization
   
   mode_zxnext = (esx_m_dosversion() != ESX_DOSVERSION_ESXDOS);
   
   if (mode_zxnext)
   {
      old_cpu_speed = ZXN_READ_REG(REG_TURBO_MODE);
      ZXN_NEXTREG(REG_TURBO_MODE, RTM_14MHZ);
   }
   
   atexit(cleanup);
   
   puts("\nDZX7: LZ77/LZSS decompression\n(C) 2015 Einar Saukas\n\nv1.1 spectrum z88dk.org\n");

   // process optional parameters
   
   for (i = 1; (i < (unsigned char)argc) && (*argv[i] == '-'); ++i)
   {
      if (stricmp(argv[i], "-f") == 0)
         forced_mode = 1;
      else
         return error("Invalid parameter %s", argv[i]);
   }
   
   // determine output filename
   
   if (argc == i + 1)
   {
      input_name = argv[i];
      input_name_sz = strlen(input_name);

      if ((input_name_sz > 4) && (stricmp(input_name + input_name_sz - 4, ".ZX7") == 0))
         snprintf(output_name, sizeof(output_name), "%.*s", input_name_sz - 4, input_name);
      else
         exit(error("Can't infer output filename"));
   }
   else if (argc == i + 2)
   {
      input_name = argv[i];
      snprintf(output_name, sizeof(output_name), "%s", argv[i + 1]);
   }
   else
   {
      printf(".dzx7 [-f] inname.zx7 [outname]\n"
             "-f Overwrite output file\n\n");
      exit(0);
   }
   
   if (stricmp(output_name, input_name) == 0)
      return error("In and out files are same");

   // check for sufficient memory in main bank
   
   if (z80_wpeek(__SYSVAR_RAMTOP) >= (unsigned int)BUFFER_ADDR)
      exit(error("M RAMTOP no good (%u)", (unsigned int)BUFFER_ADDR - 1));
   
   // open input file
   
   if ((ifp = esx_f_open(input_name, ESX_MODE_OPEN_EXIST | ESX_MODE_R)) == 0xff)
      exit(error("Can't open input file %s", input_name));

   if (esx_f_fstat(ifp, &es))
      exit(error("Can't stat input file %s", input_name));

   // check output file

   if ((ofp = esx_f_open(output_name, forced_mode ? (ESX_MODE_OPEN_CREAT_TRUNC | ESX_MODE_W) : (ESX_MODE_OPEN_CREAT_NOEXIST | ESX_MODE_W))) == 0xff)
      exit(error("Can't create output file %s", output_name));
   
   // generate output file

   decompress();
   
   // done!
   
   printf("File decompressed from %lu to %lu bytes!", input_size, output_size);
   return 0;
}
