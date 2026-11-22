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
 * Modified for ZX Next + ESXDOS by z88dk.org
 * Program performs identically.
 */

// ZX SPECTRUM
//
// zcc +zx -vn -subtype=dot -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size dzx7.c ram.asm -o dzx7 -create-app
// zcc +zx -vn -subtype=dot -startup=30 -clib=new dzx7.c ram.asm -o dzx7 -create-app

// ZX NEXT
//
// zcc +zxn -vn -subtype=dot -startup=30 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 --opt-code-size dzx7.c ram.asm -o dzx7 -create-app
// zcc +zxn -vn -subtype=dot -startup=30 -clib=new dzx7.c ram.asm -o dzx7 -create-app

#pragma printf = "%s %u %lu"
#pragma output CLIB_EXIT_STACK_SIZE = 3

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <errno.h>
#include <input.h>
#include <z80.h>

#if __ZXNEXT
#include <arch/zxn/esxdos.h>
#else
#include <arch/zx/esxdos.h>
#endif

#define BUFFER_SIZE     16384   // must be > MAX_OFFSET, must remain consistent with dzx7.asm
#define MAINBANK_ADDR  (65536 - BUFFER_SIZE*2)

unsigned char ifp;
unsigned char ofp;

unsigned char *input_name;
unsigned int   input_name_sz;

unsigned char  output_name[ESXDOS_PATH_MAX + 1];

extern unsigned char input_data[BUFFER_SIZE];
extern unsigned char output_data[BUFFER_SIZE];

unsigned int input_index;
unsigned int output_index;

unsigned long input_size;
unsigned long output_size;

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
   
   ebuf[strlen(ebuf)-1] += 0x80;  
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
      if (esxdos_f_write(ofp, output_data, output_index) != output_index)
         exit(error("Can't write output file %s", output_name));
      
      output_size += output_index;
      output_index = 0;
      
      printf(".");
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
      
      if (in_key_pressed(IN_KEY_SCANCODE_SPACE | 0x8000))
      {
         in_wait_nokey();
         exit(error("L Break into Program"));
      }
   }  
}

// cleanup on exit

void cleanup_ifp(void)
{
   esxdos_f_close(ifp);
}

void cleanup_ofp(void)
{
   esxdos_f_close(ofp);
}

void cleanup_lf(void)
{
   printf("\n\n");
}

// program start

int main(int argc, char **argv)
{
   static unsigned char forced_mode;
   unsigned char i;
   
   printf("DZX7: LZ77/LZSS decompression\nby Einar Saukas\nv1.0 zx spectrum z88dk.org\n\n");

   // process hidden optional parameters
   
   for (i = 1; (i < (unsigned char)argc) && (*argv[i] == '-'); ++i)
   {
      if (!stricmp(argv[i], "-f"))
         forced_mode = 1;
      else
         return error("Invalid parameter %s", argv[i]);
   }
   
   // determine output filename
   
   if (argc == i+1)
   {
      input_name = argv[i];
      input_name_sz = strlen(input_name);

      if ((input_name_sz > 4) && (!stricmp(input_name+input_name_sz-4, ".ZX7")))
         snprintf(output_name, sizeof(output_name), "%.*s", input_name_sz-4, input_name);
      else
         return error("Can't infer output filename");
   }
   else if (argc == i+2)
   {
      input_name = argv[i];
      snprintf(output_name, sizeof(output_name), "%s", argv[i+1]);
   }
   else
   {
      printf(".dzx7 [-f] inname.zx7 [outname]\n"
             "-f Overwrite output file\n\n");
      return 0;
   }
   
   if (!stricmp(output_name, input_name))
      return error("In and out files are same");

   // check for sufficient memory in main bank
   
   if (z80_wpeek(23730) >= (unsigned int)MAINBANK_ADDR)
      return error("M RAMTOP no good (%u)", (unsigned int)MAINBANK_ADDR);
   
   // open input file
   
   ifp = esxdos_f_open(input_name, ESXDOS_MODE_OPEN_EXIST | ESXDOS_MODE_R);

   if (errno)
      return error("Can't open input file %s", input_name);
   
   atexit(cleanup_ifp);
   
   // check output file

   ofp = esxdos_f_open(output_name, forced_mode ? ESXDOS_MODE_CREAT_TRUNC | ESXDOS_MODE_W : ESXDOS_MODE_CREAT_NOEXIST | ESXDOS_MODE_W);

   if (errno)
      return error("Can't create output file %s", output_name);
   
   atexit(cleanup_ofp);
   
   // generate output file
   
   atexit(cleanup_lf);

   decompress();
   
   // done!
   
   printf("\n\nFile decompressed from %lu to %lu bytes!", input_size, output_size);
   return 0;
}
