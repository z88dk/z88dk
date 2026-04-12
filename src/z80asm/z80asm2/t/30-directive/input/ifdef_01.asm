ifdef ; no symbol
endif
ifdef 23 ; no symbol
endif
ifdef X extra ; extra input
endif
else ; else without if
elseifdef ; elseifdef without if
elifdef ; elifdef without if
endif ; endif without if
ifdef X
else
else ; two elses
endif
ifdef X
else
elseifdef ; elseifdef after else
endif
ifdef X
else
elifdef ; elifdef after else
endif
