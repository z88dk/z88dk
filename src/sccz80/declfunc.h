/* declfunc.c */

extern int AddNewFunc(char *sname, int type, enum storage_type storage, char zfar, char sign, TAG_SYMBOL *otag, enum ident_type ident, int32_t *addr);
extern void newfunc(void);
extern SYMBOL *AddFuncCode(char *n, char type, enum ident_type ident, char sign, char zfar, enum storage_type storage, int more, char check, char simple, TAG_SYMBOL *otag, int32_t *addr);
extern void DoFnKR(SYMBOL *currfn, char simple);
extern void setlocvar(SYMBOL *prevarg, SYMBOL *currfn);
extern SYMBOL *dofnansi(SYMBOL *currfn, int32_t *addr);
extern int CheckANSI(void);
extern SYMBOL *getarg(int typ, enum ident_type ident, TAG_SYMBOL *otag, int deftype, SYMBOL *prevarg, char issigned, char zfar, char proto);
extern void check_trailing_modifiers(SYMBOL *currfn);
