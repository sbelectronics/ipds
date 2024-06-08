ISIS=../simulator/isis/gnu/isis

all: forth.hex hello.hex life.hex argtes.hex

# .PHONY: env

export ISIS_F1=../simulator/isis/intel/plm80
export ISIS_F2=../simulator/isis/intel/utils
export ISIS_F3=../simulator/isis/intel/asm80

forth : forth.obj conio.obj
	$(ISIS) :f2:link forth.obj,conio.obj,syspds.lib to forth.lnk
	$(ISIS) :f2:locate forth.lnk to forth MAP PRINT\(forth.map\)

forth.hex: forth
	$(ISIS) :f2:objhex forth to forth.hex

forth-run:
	$(ISIS) -l  forth

forth.obj: forth.asm
	$(ISIS) :f3:asm80 forth.asm

conio.obj: conio.asm
	$(ISIS) :f3:asm80 conio.asm

putil.obj: putil.asm
	$(ISIS) :f3:asm80 putil.asm

args.obj: args.asm
	$(ISIS) :f3:asm80 args.asm

argtes.obj: argtes.asm
	$(ISIS) :f3:asm80 argtes.asm

argtes: argtes.obj conio.obj args.obj putil.obj
	$(ISIS) :f2:link argtes.obj,conio.obj,args.obj,putil.obj,syspds.lib to argtes.lnk MAP
	$(ISIS) :f2:locate argtes.lnk to argtes PURGE MAP PRINT\(argtes.map\)

argtes-run:
	$(ISIS) argtes A

argtes.hex:
	$(ISIS) :f2:objhex argtes to argtes.hex

hello: hello.obj conio.obj
	$(ISIS) :f2:link hello.obj,conio.obj,syspds.lib to hello.lnk MAP
	$(ISIS) :f2:locate hello.lnk to hello PURGE MAP PRINT\(hello.map\)

hello.hex: hello
	$(ISIS) :f2:objhex hello to hello.hex	

hello-run:
	$(ISIS) hello

hello.obj: hello.asm
	$(ISIS) :f3:asm80 hello.asm

life.obj: life.asm
	$(ISIS) :f3:asm80 life.asm

life: life.obj args.obj
	$(ISIS) :f2:link life.obj,args.obj,syspds.lib to life.lnk MAP
	$(ISIS) :f2:locate life.lnk to life PURGE MAP PRINT\(life.map\)

life.hex: life
	$(ISIS) :f2:objhex life to life.hex

life-run:
	$(ISIS) life

clean:
	rm -f *.hex *.obj *.lnk *.map *.lst forth hello life
