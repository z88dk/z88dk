/* declfunc.c */

extern int AddNewFunc(char *sname, int type, int storage, char zfar, char sign, TAG_SYMBOL *otag, int ident, int32_t *addr);
extern void newfunc(void);
extern SYMBOL *AddFuncCode(char *n, char type, char ident, char sign, char zfar, int storage, int more, char check, char simple, TAG_SYMBOL *otag, int32_t *addr);
extern void DoFnKR(SYMBOL *currfn, char simple);
extern void setlocvar(SYMBOL *prevarg, SYMBOL *currfn);
extern SYMBOL *dofnansi(SYMBOL *currfn, int32_t *addr);
extern int CheckANSI(void);
extern SYMBOL *getarg(int typ, TAG_SYMBOL *otag, int deftype, SYMBOL *prevarg, char issigned, char zfar, char proto);
