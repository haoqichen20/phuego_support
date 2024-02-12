#!/usr/bin/env python

import os,sys
import numpy as np

def main():
	f1 = open('semsim.txt', 'w')

	# List only non-hidden files
	i_node_semsims = [entry for entry in os.listdir('.') if not entry.startswith('.')]

	# Calculate mean & std of each i_node_semsim.
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