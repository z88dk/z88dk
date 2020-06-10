/* codegen.c */
extern void header(void);
extern void DoLibHeader(void);
extern void trailer(void);
extern void outname(const char *sname, char pref);
extern int getloc(SYMBOL *sym, int off);
extern void putstk(LVALUE *lval);
extern void puttos(void);
extern void put2tos(void);
extern void swap(void);
extern void immed(void);
extern void immedlit(int lab,int offs);
extern void lpush(void);
extern void zpush(void);
extern void dpush_under(int val_type);



extern void mainpop(void);
extern void zpop(void);

extern char dopref(SYMBOL *sym);
extern void callrts(char *sname);
extern int callstk(Type *type, int n, int isfarptr, int last_argument_size);

extern void defbyte(void);
extern void defstorage(void);
extern void defword(void);
extern void deflong(void);
extern void defmesg(void);
extern void point(void);
extern int modstk(int newsp, Kind save,int saveaf, int usebc);
extern void scale(Kind type, Type *tag);


extern void vlongconst(double val);
extern void vlongconst_tostack(double val);
extern void vconst(int32_t val);
extern void const2(int32_t val);
extern void GlobalPrefix(void);
extern void jumpc(int);
extern void jumpnc(int);

extern void jumpr(int);
extern void opjumpr(char *, int);
extern void dummy(LVALUE *);
extern void EmitLine(int);



extern void output_section(const char *section_name);
extern void function_appendix(SYMBOL *func);


extern int zcriticaloffset(void);
extern void zconvert_constant_to_double(double value, Kind to, unsigned char isunsigned);
extern void zconvert_to_double(Kind from, Kind to, unsigned char isunsigned);
extern void zconvert_from_double(Kind from, Kind to, unsigned char isunsigned);
extern int push_function_argument_fnptr(Kind expr, Type *type, int push_sdccchar, int is_last_argument);
extern void reset_namespace();
extern void zwiden_stack_to_long(LVALUE *lval);
