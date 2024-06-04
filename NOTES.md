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
