ifndef ; no symbol
endif
ifndef 23 ; no symbol
endif
ifndef X extra ; extra input
endif
else ; else without if
elseifndef ; elseifndef without if
elifndef ; elifndef without if
endif ; endif without if
ifndef X
else
else ; two elses
endif
ifndef X
else
elseifndef ; elseifndef after else
endif
ifndef X
else
elifndef ; elifndef after else
endif
