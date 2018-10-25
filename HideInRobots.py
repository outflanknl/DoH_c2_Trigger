#! /usr/bin/env python
import urllib2
import json
import sys
import random
import base64

def addToken(blob,token,min=3,max=15):
  line = blob
  out = ""
  #for line in fileinput.input():
  offset = 0
  while len(line) > 5:
    offset = random.randrange(min,max)
    if offset < len(line):
      out = out + "%s%s"%(line[:offset],token)
      line = line[offset:]
    else:
      out = out + "%s"%line
      line = ""
  return(out)

if __name__ == '__main__':
  with open(sys.argv[1], 'r') as f:
    content = f.read()
  #print(content)
  b64c = base64.b64encode(content)
  if b64c.find('=') > 0:
    oki = False
    print("Found a '=' at the end, add space and try again")
  else: oki = True
  while oki == False:
    content = content + " "
    b64c = base64.b64encode(content)
    if b64c.find('=') == -1:
      oki = True
    else: print("Found a '=' at the end, add space and try again")
  print("Managed to generate base64 without a '='!")
  print b64c
  b64cR = b64c[::-1]
  print("Reversed full payload")
  print("Added random newlines and '.html' extensions")
  b64cOUT = addToken(b64cR,".html\n")
  with open('%s.Lorum'%sys.argv[1], 'w') as the_file:
    the_file.write("Disallow: /" + b64cOUT + ".html\n")    
