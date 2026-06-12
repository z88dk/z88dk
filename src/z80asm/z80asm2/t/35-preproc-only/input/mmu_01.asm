#define cat(a,b) a ## b
REPTI I, 0, 1, 2, 3, 4, 5, 6, 7
    mmu I, A
    cat(mmu, I) A
  REPTI J, 0, 0xFF
    mmu I, J
    cat(mmu, I) J
  ENDR
ENDR
