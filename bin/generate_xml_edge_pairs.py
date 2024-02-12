#!/usr/bin/env python

import os,sys

def main():
	edge_pairs = sys.argv[1]
	xml_template_path = sys.argv[2]

	f1=open(xml_template_path)
	f2=open("sml_semsim_edge_pairs.xml","w")
	seq=f1.readline()
	while(seq!=""):
		seq=seq.strip()
		if seq.startswith("output "):
			f2.write(f'output = "edge_pairs_sem_sim.txt"\n')
		elif seq.startswith("file"):
			f2.write(f'file = "{edge_pairs}"\n')
		else:
			f2.write(seq+"\n")
		seq=f1.readline()

if __name__ == '__main__':
    main()