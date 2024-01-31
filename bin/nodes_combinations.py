#!/usr/bin/env python

import sys

def main():
	i_node = sys.argv[1]
	all_nodes_path = sys.argv[2]

	nodes=[]
	f1=open(all_nodes_path)
	seq=f1.readline()
	while(seq!=''):
		nodes.append(seq.strip())
		seq=f1.readline()

	f2=open(i_node, "w")
	for i in nodes:
		f2.write(i_node+"\t"+i+"\n")

if __name__ == '__main__':
    main()