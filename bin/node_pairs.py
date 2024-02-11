#!/usr/bin/env python

import sys

def main():
	network_path = sys.argv[1]

	node_pairs=[]
	f1=open(network_path)
	seq=f1.readline()
	while(seq!=""):
		seq=seq.strip().split("\t")
		node_pairs.append((seq[0],seq[1]))
		seq=f1.readline()


	for ii in range(int(1000)):
		f1=open(str(ii)+".txt")
		seq=f1.readline()
		while(seq!=""):
			seq=seq.strip().split("\t")
			node_pairs.append((seq[0],seq[1]))
			seq=f1.readline()
			if ii==5000:
				node_pairs=list(set(node_pairs))

	node_pairs=list(set(node_pairs))
	f1=open("edge_pairs.txt","w")
	for i in node_pairs:
		f1.write(i[0]+"\t"+i[1]+"\n")

if __name__ == '__main__':
    main()