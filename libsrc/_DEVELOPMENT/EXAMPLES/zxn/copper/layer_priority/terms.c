// zcc +zxn -vn -startup=31 -SO3 -clib=sdcc_iy --max-allocs-per-node200000 @zproject.lst -o terms -pragma-include:zpragma.inc -subtype=nex -Cz"--clean" -create-app

#include <stdio.h>
#include <stropts.h>
#include <string.h>
#include <arch/zxn.h>
#include <arch/zxn/esxdos.h>
#include <input.h>
#include <im2.h>
#include <font/fzx.h>
#include <errno.h>
#include <z80.h>
#include <intrinsic.h>

extern FILE *window_1;
extern FILE *window_2;

// book

extern const unsigned char book[];

// copper list

extern unsigned int copper[];
extern unsigned int copper_end[];

// somewhat clumsy word wrapper

unsigned char *print_line_word_wrapped(FILE *out, unsigned char *s)
{
   static int              fd;
   static struct r_Rect16  paper;
   static struct fzx_font *font;
   static unsigned int     width;
   static unsigned int     len;

   // wear helmet
   
   if (*s == 0) return s;
   
   // blank line
   
   if (*s == '\n')
   {
      fputc('\n', out);
      return s+1;
   }
   
   // find file descriptor associated with FILE
   
   if ((fd = fileno(out)) < 0) return s;
   
   // gather information about terminal
   
   font = (struct fzx_font *)ioctl(fd, IOCTL_OTERM_FONT, -1);
   ioctl(fd, IOCTL_OTERM_FZX_GET_PAPER_RECT, &paper);
   width = paper.width - ioctl(fd, IOCTL_OTERM_FZX_LEFT_MARGIN, -1) - 1;
   
   // find the longest substring that fits the terminal width

   if ((len = (fzx_string_partition_ww(font, s, width) - s)) == 0)
      len = fzx_string_partition(font, s, width) - s;
   
   // print substring
   
   fprintf(out, "%.*s\n", len, s);
   
   // skip trailing spaces and one line terminator if present
   
   s += len;
   s += strspn(s, " ");
   s += (*s == '\n');
   
   return s;
}

// interrupt routine

unsigned char dx, dy;

IM2_DEFINE_ISR_8080(isr)
{
   unsigned char save;
   
   // save nextreg register
   
   save = IO_NEXTREG_REG;
   
   // simple update of layer 2 scroll
   
   ZXN_WRITE_REG(REG_LAYER_2_OFFSET_X, ++dx);
   
   if (++dy > 191) dy = 0;
   ZXN_WRITE_REG(REG_LAYER_2_OFFSET_Y, dy);
   
   // restore nextreg register
   
   IO_NEXTREG_REG = save;
}

void main(void)
{
   unsigned char fin;
   static unsigned char speed;  // initializes to 0
   
   // initially 3.5 MHz
   
   ZXN_WRITE_REG(REG_TURBO_MODE, speed);

   // load layer 2 background to 8k page 18
   // (relying on default palette)
   
   fin = esxdos_f_open("girl.nxi", ESXDOS_MODE_OPEN_EXIST | ESXDOS_MODE_R);
   if (errno) return;

   for (unsigned char i = 18; i != 24; ++i)
   {
      ZXN_WRITE_MMU7(i);
      esxdos_f_read(fin, (void*)0xe000, 0x2000);
   }
   
   ZXN_WRITE_MMU7(1);
   esxdos_f_close(fin);
   
   // enable layer 2
   
   ZXN_WRITE_REG(REG_LAYER_2_RAM_BANK, 9);   // layer 2 is in 16k bank 9
   IO_LAYER_2_CONFIG = IL2C_SHOW_LAYER_2;

   // set ula timex hi-res mode

   ZXN_WRITE_REG(REG_PERIPHERAL_3, RP3_ENABLE_SPEAKER | RP3_ENABLE_TIMEX);
   ts_vmod(TVM_HIRES | speed*8);
   
   tshr_cls_pix(0);
   
   // set global transparency colour so that we can see through layer 2 during testing
   
   ZXN_WRITE_REG(REG_GLOBAL_TRANSPARENCY_COLOR, 0x1f);
   
   // load copper program to change layer priority around terminals
   // layer 2 will have higher priority around hi-res ula rectangles
   // (interrupts are disabled)
   
   ZXN_WRITE_REG(REG_COPPER_CONTROL_LO, 0);
   ZXN_WRITE_REG(REG_COPPER_CONTROL_HI, 0);
   
   IO_NEXTREG_REG = REG_COPPER_DATA;
   
   for (unsigned char *p = copper; p != copper_end; ++p)
      IO_NEXTREG_DAT = *p;
   
   // enable copper
   
   ZXN_WRITE_REG(REG_COPPER_CONTROL_HI, RCCH_COPPER_RUN_ON_INTERRUPT);

   // set up im2 interrupt for layer 2 scroll
   // (interrupts are disabled)
   
   // tuck the im2 table underneath the program
   // this means our ORG should be 0x8184
   
   im2_init((void *)0x8000);
   memset((void *)0x8000, 0x81, 257);
   
   z80_bpoke(0x8181, 0xc3);   // z80 JP instruction
   z80_wpoke(0x8182, (unsigned int)isr);
   
   // enable interrupts
   
   intrinsic_ei();

   // main loop

   {
      unsigned char *p;
      unsigned char *q;
      
      p = q = book;
      
      while (1)
      {
         // window 1
         
         p = print_line_word_wrapped(window_1, p);
         if (*p == 0) p = book;
         
         // window 2
         
         q = print_line_word_wrapped(window_2, q);
         if (*q == 0) q = book;
         
         // user can change cpu speed
         
         if (in_inkey() == 's')
         {
            if (++speed > 2)
               speed = 0;
            
            ts_vmod(TVM_HIRES | speed*8);  // background colour depends on speed
            ZXN_WRITE_REG(REG_TURBO_MODE, speed);
         }
         
         // user pauses by holding key
      
         while (in_test_key()) ;
      }
   }
}
