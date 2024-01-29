#!/usr/bin/env python

import sys

def main():
	gaf_path = sys.argv[1]
	species_ID = sys.argv[2]
	species = sys.argv[3]

	f1=open(gaf_path)
	f2=open(f'gaf_{species}.gaf','w')
	f2.write('!gaf-version: 2.1\n')
	seq=f1.readline()
	seq=f1.readline()
	f2.write(seq)
	seq=f1.readline()
	f2.write(seq)
	seq=f1.readline()
	f2.write(seq)
	seq=f1.readline()
	f2.write(seq)
	seq=f1.readline()
	f2.write(seq)
	seq=f1.readline()
	f2.write(seq)
	seq=f1.readline()
	f2.write(seq)
	seq=f1.readline()
	f2.write(seq)
	seq=f1.readline()
	while(seq!=""):
		seq=seq.strip().split("\t")
		if seq[12]==f'taxon:{species_ID}':
			if "NOT" not in seq:
				#print ("\t".join(seq[0:3])+"\t\t"+"\t".join(seq[4:])+"\n")
				f2.write("\t".join(seq[0:3])+"\t\t"+"\t".join(seq[4:])+"\n")
		seq=f1.readline()

if __name__ == '__main__':
    main()
