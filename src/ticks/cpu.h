#ifndef CPU_H
#define CPU_H

extern int c_cpu;

#define CPU_Z80      1
#define CPU_Z180     2
#define CPU_R2KA     4
#define CPU_R3K      8
#define CPU_Z80N     16
#define CPU_R800     32
#define CPU_GBZ80    64
#define CPU_8080     128
#define CPU_8085     256
#define CPU_EZ80     512

#define is8080() ( (c_cpu & CPU_8080) )
#define is8085() ( (c_cpu & CPU_8085) )
#define is808x() ( (c_cpu & (CPU_8080|CPU_8085)) )
#define isgbz80() ( (c_cpu & CPU_GBZ80) == CPU_GBZ80 )
#define isr800() ( (c_cpu & CPU_R800) == CPU_R800 )
#define israbbit() ( c_cpu & (CPU_R2KA|CPU_R3K))
#define israbbit3k() ( c_cpu & (CPU_R3K))
#define isz180() ( c_cpu & (CPU_Z180))
#define isez80() ( c_cpu & (CPU_EZ80))
#define canaltreg() ( ( c_cpu & (CPU_8080|CPU_8085|CPU_GBZ80)) == 0 )
#define canindex() ( ( c_cpu & (CPU_8080|CPU_8085|CPU_GBZ80)) == 0 )
#define canixh() ( c_cpu & (CPU_Z80|CPU_Z80N|CPU_R800|CPU_EZ80))
#define cansll() ( c_cpu & (CPU_Z80|CPU_Z80N))
#define canz180() ( c_cpu & (CPU_Z180|CPU_EZ80))
#define cancbundoc() ( c_cpu & (CPU_Z80|CPU_Z80N))

#endif