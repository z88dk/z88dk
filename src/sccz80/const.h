/* constant.c */
extern int constant(LVALUE *lval);
extern int fnumber(LVALUE *val);
extern int number(LVALUE *lval);
extern int hex(char c);
extern void address(SYMBOL *ptr);
extern int pstr(LVALUE *lval);
extern int tstr(int32_t *val);
extern int storeq(int length, unsigned char *queue,int32_t *val);
extern int qstr(double *val);
extern void stowlit(int value, int size);
extern unsigned char litchar(void);
extern void size_of(LVALUE *lval);
extern void load_double_into_fa(LVALUE *lval);
extern void write_double_queue(void);
extern void decrement_double_ref(LVALUE *lval);
extern void decrement_double_ref_direct(double value);