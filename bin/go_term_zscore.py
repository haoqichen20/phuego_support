#!/usr/bin/env python

import os,sys
import numpy as np

def main():
	# List only non-hidden files
	i_node_semsims = [entry for entry in os.listdir('.') if not entry.startswith('.')]

	# The output file is created after the listing step, so won't be included in i_node_semsims.
	f1 = open('semsim.txt', 'w')
	# Calculate mean & std for each node.
	for i in i_node_semsims:
		f2=open(i)
		seq=f2.readline()
		seq=f2.readline()
		val=[]
		while(seq!=""):
			seq=seq.strip().split('\t')
			val.append(float(seq[2]))
			seq=f2.readline()

		mean=np.mean(val)
		std=np.std(val)
		
		node=i.split('.')[0]
		f1.write(node+"\t"+str(mean)+"\t"+str(std)+"\n")

if __name__ == '__main__':
    main()