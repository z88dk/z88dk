#define IM2_DEFINE_ISR(name)  void name(void) \
{ \
asm("\tEXTERN\tasm_im2_push_registers\n" \
"\tEXTERN\tasm_im2_pop_registers\n" \
"\n" \
"\tcall\tasm_im2_push_registers\n" \
"\tcall\t__im2_isr_" #name "\n" \
"\tcall\tasm_im2_pop_registers\n" \
"\n" \
"\tei\n" \
"\treti\n" \
); \
} \
void _im2_isr_##name(void)

#define IM2_DEFINE_ISR_8080(name)  void name(void) \
{ \
asm("\tEXTERN\tasm_im2_push_registers_8080\n" \
"\tEXTERN\tasm_im2_pop_registers_8080\n" \
"\n" \
"\tcall\tasm_im2_push_registers_8080\n" \
"\tcall\t__im2_isr_8080_" #name "\n" \
"\tcall\tasm_im2_pop_registers_8080\n" \
"\n" \
"\tei\n" \
"\treti\n" \
); \
} \
void _im2_isr_8080_##name(void)

unsigned int x;

IM2_DEFINE_ISR_8080(isr1)
{
   ++x;
}

IM2_DEFINE_ISR(isr2)
{
   ++x;
}

