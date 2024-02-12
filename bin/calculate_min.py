#!/usr/bin/env python

import numpy as np

def main():
	edge_pairs_sem_sim_path = sys.argv[1]
	f1 = open(edge_pairs_sem_sim_path)

	seq=f1.readline()
	seq=f1.readline()
	min=100
	while(seq!=""):
		seq=seq.strip().split("\t")
		if float(seq[2])<min and float(seq[2])>0:
			min=float(seq[2])
		seq=f1.readline()

	min=min/10.0

	f2=open('minimum.txt','w')
	f2.write(str(min))

if __name__ == '__main__':
    main()