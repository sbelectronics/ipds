Kermit modified for use with iPDS-100 / ISIS-II

NOTE: Does not set baud rate. Baud rate commands do nothing!

Use "Serial A P=N S=2 W=8 B=9600" or similar ISIS command to set baud
before running.

My general strategy is to do this first (via a job file):

```ISIS
SERIAL A P=N S=2 W=8 B=9600
ASSIGN :CO: TO :SO:
ASSIGN :CI: TO :SI:
```

Then I connect to the iPDS via serial dongle at 9600 baud. I can
operate the iPDS from my windows PC. At that point I run
kermit:

```
KERMIT
RECEIVE
```

... and I can do a kermit send from my favorite terminal program (scrt
by vandyke).

To get kermit to your iPDS for the very first time, send the HEX file
ASCII to the iPDS. Add delays to your terminal program on upload (recommended
20ms per character, 500ms per line). The iPDS can't take 9600 baud
full rate. Receive it like this:

```
COPY :SI: to :f0:kermit.hex
```

Send the HEX file as ASCII from your terminal program. Hit CTR

...and then convert the hex to binary:

```
HEXOBJ :f0:kermit.hex to :f0:kermit
```