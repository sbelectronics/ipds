Disk Format
  * 640 KB
  * 96 TPI
  * 250 Kbps
  * Probably 2 sides, 80 track, 16 sectors, 256 bytes/sector (acorn.adfs.640 ?)
  * Track 0 Head 0 is 128 bytes, 16 sectors, FM
  * This is not CP/M !!!! It's probably ISIS or ISIS-II
  * From bitsavers:
    iPDS floppy format
    80 tracks
    track 0/0 128 bytes 16 sectors SD G1:16 G2:25
    other tracks 256 bytes 16 sectors DD G1:32 G2:50
    interleave
    1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15, 4, 8, 12, 16

Useful Commands
   * HELP
   * DIR
      * DIR - current drive
      * DIR 4 - disk 4 (bubble)
      * DIR I - show invisible files
   * COPY
      * COPY :F0:<fn> TO :F4:<fn>  - copy from floppy 0 to bubble
   * JOB
   * SERIAL
   * ASSIGN
   * ENDJOB - sends EOF to :CI:
   * @<filename> - cat file

Serial console?
    SERIAL A P=N S=2 W=8 B=9600
    ASSIGN :CO: TO :SO:
    ASSIGN :CI: TO :SI:

JOB Files
    # create a JOB file. Hit two blank lines to quit
    JOB :F1:SCOTT.CSD

    # execute the job file
    / :F1:SCOTT.CSD

    # auto-boot file for processor A
    JOB ABOOT.CSD

    # auto-boot file for processor B
    JOB BBOOT.CSD

    # format non-system disk
    IDISK :F1:SCOTT

    # format system disk
    IDISK :F1:SCOTT S

Devices:
   * :CO:  console output
   * :CI:  console input
   * :VO:  video output
   * :VI:  video input
   * :SO:  serial output
   * :SI:  serial input
   * :BB:  byte bucket
   * :LP:  line printer
   * :L1:  user list device
   * :I1:  user console input device
   * :O1:  user console oput device

Disk Devices
   * :F0: - floppy 0
   * :F1: - floppy 1
   * :F2: - floppy 2
   * :F3: - floppy 3
   * :F4: - bubble (physical 4)
   * :F5: - bubble (physical 5)

Prom program notes:
   * BLANKCHECK
      * BLANKCHECK PROM(0,0FFF)
   * COPY - copy between PROM and BUFFER
      * COPY PROM(0,0FFF) TO BUFFER(0)
      * COPY BUFFER(0,0FFF) TO PROM(0)
      * COPY BUFFER(0,0FFF) TO :F1:MON2.IUP
      * COPY :SI: TO :F1:MYFILE.HEX             ; terminate with CTRL-Z
   * DISPLAY
      * DISPLAY BUFFER(0,0100)
   * TYPE - set PROM TYPE
      * TYPE 2732
      * TYPE 2764
   * VERIFY - verify prom
      * VERIFY BUFFER(0,0FFF) TO PROM

Second Processor:
  FUNCT-HOME - switch CPUs
  FUNCT-UP / FUNCT-DOWN - change window size

Using Kermit
  https://www.rogerarrick.com/mds888/kermit.html

Files I put on the bubble:

DIRECTORY OF :F4:BUB
NAME  .EXT  BLKS   LENGTH   ATTR    NAME  .EXT  BLKS   LENGTH   ATTR
DIR           28     6625           SERIAL        16     3127
SUBMIT        20     4692           DEBUG         12     2566
ASSIGN        16     3129           COPY          36     8487
HEXOBJ        20     4344           DELETE        20     4699
KERMIT        52    12136           FORTH         28     6851
SAY           72    17760           SER   .CSD     4       79
VID   .CSD     4       50           LIFE           8     1136
ATTACH         4      503           BONG           4      467
                                344
20 FREE / 512 TOTAL BLOCK

Set up the bubble:

COPY :F1:DIR TO :F4:
COPY :F1:SUBMIT TO :F4:
COPY :F1:ASSIGN TO :F4:
COPY :F1:ATTACH TO :F4:
COPY :F1:SERIAL TO :F4:
COPY :F1:DEBUG TO :F4:
COPY :F1:COPY TO :F4:
COPY :F1:DELETE TO :F4:
COPY :F2:SER.CSD TO :F4:
COPY :F2:VID.CSD TO :F4:
COPY :F2:KERMIT TO :F4:

Set up backup disk

COPY :F0:DIR TO :F1:
COPY :F0:SUBMIT TO :F1:
COPY :F0:ASSIGN TO :F1:
COPY :F0:ATTACH TO :F1:
COPY :F0:SERIAL TO :F1:
COPY :F0:DEBUG TO :F1:
COPY :F0:COPY TO :F1:
COPY :F0:DELETE TO :F1:

Power supply

  * C2-C7: 200V 100uF

  * C14,C15: 25V, 470uF

  * C16, C17, C18, C19, C21: 10V, 1000uF (C21, C19 swapped from schem)

  * C20, C25: 16V, 470uF

  * C23, C24: 100uF, 25V

  * R18 brn-blk-brn - 100 (not measured)

  * R19 brn-blk-red - 1K (not measured)

  * R20 grn-blu-red - 5.6K (not measured)

  * R21 - 10k pot

  * R22 - grn-blu-ora - 56K (not measured)

  * 6/2024 - replaced most of the caps including the output filters and the 12V input filters.

  * 7/7/2024 - found bubble board not working again. Measured about 4.55V at the IPDS120 after the fuse. Replaced C16-C19, the 5V caps before the inductor. Now reading 4.87V, which is consistent with voltage drop on the pico fuse.

  * requirements:

      * +5V - 9.9 A
      * +12V1 - 2.92 A
      * +12V2 - 1.4 A
      * -12V - 0.51 A

      * possible meanwell RT-125B. PPT-125B is close but probably not good enough.
