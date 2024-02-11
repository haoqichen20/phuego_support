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
			# No need to use target_dir here. Write to working dir is fine.
			f2.write(f'output = "edge_pairs_sem_sim.txt"\n')
		elif seq.startswith("file"):
			# This will only paste in the filename of i_node_combi, since it's passed as a path_ch.
			# But that's fine. In the next process, we'll also symbolink the file to the process making it accessible for the .jar.
			f2.write(f'file = "{edge_pairs}"\n')
		else:
			f2.write(seq+"\n")
		seq=f1.readline()

if __name__ == '__main__':
    main()