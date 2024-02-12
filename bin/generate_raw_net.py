#!/usr/bin/env python

import os
import sys
import numpy as np

def main():
	semsim_minimum_path = sys.argv[1]
	edge_pairs_sem_sim_path = sys.argv[2]
	network_path = sys.argv[3]

	f1=open(semsim_minimum_path)
	seq=f1.readline()
	min=0
	while(seq!=""):
		seq=seq.strip()
		min=float(seq)
		seq=f1.readline()


	f1=open(edge_pairs_sem_sim_path)
	seq=f1.readline()
	seq=f1.readline()
	sem_sim={}
	while(seq!=""):
		seq=seq.strip().split("\t")
		semsim_val=float(seq[2])
		if semsim_val<=0:
			sem_sim[(seq[0],seq[1])]=min
		else:
			sem_sim[(seq[0],seq[1])]=semsim_val
		seq=f1.readline()


	os.mkdir("raw")
	for i in range(0,1000,1):
		f1=open(str(i)+".txt")
		f2=open("./raw/"+str(i)+".txt","w")
		seq=f1.readline()
		while(seq!=""):
			seq=seq.strip().split("\t")
			seq=tuple(seq[0:2])
			f2.write(seq[0]+"\t"+seq[1]+"\t"+str(sem_sim[seq])+"\n")
			seq=f1.readline()

		if i==0:
			f1=open(network_path)
			f2=open("./raw/empirical.txt","w")
			seq=f1.readline()
			while(seq!=""):
				seq=seq.strip().split("\t")
				seq=tuple(seq[0:2])
				f2.write(seq[0]+"\t"+seq[1]+"\t"+str(sem_sim[seq])+"\n")
				seq=f1.readline()

if __name__ == '__main__':
    main()