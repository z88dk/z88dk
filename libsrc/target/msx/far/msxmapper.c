// https://map.grauw.nl/resources/dos2_environment.php#c5
// https://github.com/Konamiman/MSX/blob/master/SRC/SDCC/asmlib/asm.h

#include <stdio.h>
#include <arch/msx/asm.h>

#define EXTBIO 0xFFCA

// mapper routine MR
#define MR_ALL_SEG 0
#define MR_GET_P2 0x27
#define MR_PUT_P2 0x24

#define MR_GET_PH 0x15

Z80_registers regs;
register_usage usage;



uint mapper_variable_table() {
  static uint table_start = 0;
  if (table_start == 0) {
    usage = 2;

    regs.Bytes.A = 0;
    regs.Bytes.D = 4;
    regs.Bytes.E = 1;
    AsmCall(EXTBIO, &regs, usage, usage);

    table_start = regs.Words.HL;
  }
  return table_start;
}

uint mapper_variable_table_entry(char offset) {
  return *(char*)(mapper_variable_table()+offset);
}

uint mapper_routine_table() {
  static uint rtable_start = 0;
  if (rtable_start == 0) {
    usage = 2;

    regs.Bytes.A = 0;
    regs.Bytes.D = 4;
    regs.Bytes.E = 2;
    AsmCall(EXTBIO, &regs, usage, usage);

    rtable_start = regs.Words.HL;
    //printf("%d %d %d\n", regs.Bytes.A, regs.Bytes.B, regs.Bytes.C);
  }
  
  return rtable_start;
}


char mapper_get_p2() {
  usage = 2;

  uint address = mapper_routine_table() + MR_GET_P2;
  AsmCall(address, &regs, usage, usage);

  //printf("%d %d %d\n", regs.Bytes.A, regs.Bytes.B, regs.Bytes.C);
  
  return regs.Bytes.A;  
}

char mapper_get_ph(char * ptr) {
  usage = 2;

  uint address = mapper_routine_table() + MR_GET_P2;
  regs.Words.HL = ptr;
  AsmCall(address, &regs, usage, usage);

  //printf("%d %d %d\n", regs.Bytes.A, regs.Bytes.B, regs.Bytes.C);
  
  return regs.Bytes.A;  
}



char mapper_allocate() {
  usage = 2;

  uint address = mapper_routine_table() + MR_ALL_SEG;

  regs.Bytes.A = 0;
  regs.Bytes.B = 0;
  AsmCall(address, &regs, usage, usage);
  if (regs.Flags.C) return 0;
  return regs.Bytes.A;
}

void mapper_put_p2(char segment) {
  usage = 2;

  uint address = mapper_routine_table() + MR_PUT_P2;
  regs.Bytes.A = segment;
  AsmCall(address, &regs, usage, usage);
}

void mapper_test_alloc_swap() {
  char oldseg = mapper_get_p2();
  char newseg = mapper_allocate();
  printf("new segment: %d, put it in page 2\n", newseg);
  mapper_put_p2(newseg);
  printf("done, now restoring segment: %d\n", oldseg);
  mapper_put_p2(oldseg);
  printf("done\n");
}

void _main() {
  mapper_test_alloc_swap();
}

