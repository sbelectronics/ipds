# Path to the ISIS simulator, which you can find at:
# https://bionic.bloovis.com/cgit/isis/. The simulator is written
# by Mark Alexander and allows native ISIS-II tools to be run
# from Linux (or Windows?) making compiling easy.

ISIS=../simulator/isis/gnu/isis

# Most of the stuff compiles with native ISIS tools, except Nascome
# Basic, which uses the AZZ toolchain. 

ZCC = ../../z88dk/bin/zcc

# So ZCC can find its assembler...

export PATH := $(PATH):../../z88dk/bin

all: forth.hex hello.hex life.hex argtes.hex basic.hex

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

basic.obj:
	echo "nascom32k.asm" > nascom32k.lst
	rm -f basic.tmp basic.asm
	$(ZCC) +z80 -m8085 --no-crt -v -m --list -Ca-f0xFF @nascom32k.lst -o basic.tmp
	python3 ./makeisis.py < basic.tmp > basic.asm
	unix2dos basic.asm
	$(ISIS) :f3:asm80 basic.asm

basic: basic.obj
	rm -f basic.map
	$(ISIS) :f2:link basic.obj,syspds.lib to basic.lnk MAP
	$(ISIS) :f2:locate basic.lnk to basic PURGE MAP PRINT\(basic.map\)

basic-run: basic
	$(ISIS) basic

basic.hex: basic
	$(ISIS) :f2:objhex basic to basic.hex

clean:
	rm -f *.hex *.obj *.lnk *.map *.lst *.tmp *.lis forth hello life basic argtes
