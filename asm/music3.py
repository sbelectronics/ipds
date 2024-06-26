import sys

def nconv(s):
  freq = int(s)
  if freq==0:
    return "0"
  return "%d" % int(3579545.0/(32.0*freq))

def convert(fn):
  lines = open(fn,"rt").readlines()
  for line in lines:
    line = line.strip()
    if not line:
      continue
    parts = line.split(",")
    if len(parts)==3:
      parts = parts + ["0","15","0","15"]
    elif len(parts)==5:
      parts = parts + ["0", "15"]
    elif len(parts)==7:
      pass
    else:
      print("bad line %s" % line)
      sys.exit(-1)

    parts[1] = nconv(parts[1])
    parts[3] = nconv(parts[3])
    parts[5] = nconv(parts[5])

    print("\tDW\t%s" % (", ".join(parts)))
  print("\tDW\t0,0,15,0,15,0,15")

convert("wewish.txt")
