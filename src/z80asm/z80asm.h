

#ifndef Z80ASM_H
#define Z80ASM_H


#define REG16_BC   0
#define REG16_DE   1
#define REG16_HL   2
#define REG16_SP   3
#define REG16_AF   4
#define REG16_IX   5
#define REG16_IY   6

#define FLAGS_NZ 0
#define FLAGS_Z  1
#define FLAGS_NC 2
#define FLAGS_C  3
#define FLAGS_PO 4
#define FLAGS_PE 5
#define FLAGS_P 6
#define FLAGS_M 7


#define CPU_Z80     1
#define CPU_RCM2000 2
#define CPU_RCM3000 4
#define CPU_Z180    8


#define CPU_RABBIT (CPU_RCM2000|CPU_RCM3000)
#define CPU_ZILOG (CPU_Z80|CPU_Z180)
#define CPU_ALL ( CPU_ZILOG |  CPU_RABBIT )


extern int   cpu_type;


extern char *Fetchfilename (FILE *fptr);

extern char *SearchFile(char *base, int is_include);

#endif
