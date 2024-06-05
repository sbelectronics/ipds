ISIS=../simulator/isis/gnu/isis

all: forth.hex hello.hex

# .PHONY: env

export ISIS_F1=../simulator/isis/intel/plm80
export ISIS_F2=../simulator/isis/intel/utils
export ISIS_F3=../simulator/isis/intel/asm80

forth : forth.obj
	$(ISIS) :f2:link forth.obj,syspds.lib to forth.lnk
	$(ISIS) :f2:locate forth.lnk to forth MAP PRINT\(forth.map\)

forth.hex: forth
	$(ISIS) :f2:objhex forth to forth.hex

forth-run:
	$(ISIS) -l  forth

forth.obj: forth.asm
	$(ISIS) :f3:asm80 forth.asm

hello: hello.obj
	$(ISIS) :f2:link hello.obj,syspds.lib to hello.lnk  MAP
	$(ISIS) :f2:locate hello.lnk to hello MAP PRINT\(hello.map\)

hello.hex: hello
	$(ISIS) :f2:objhex hello to hello.hex	

hello-run:
	$(ISIS) hello

hello.obj: hello.asm
	$(ISIS) :f3:asm80 hello.asm	

clean:
	rm -f *.hex *.obj *.lnk *.map forth hello
