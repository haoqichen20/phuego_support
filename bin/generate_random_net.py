#!/usr/bin/env python

import sys
from igraph import *

def main():
	ind = sys.argv[1]
	network_path = sys.argv[2]

	network=Graph.Read_Ncol(network_path,directed=False)
	names=network.vs["name"]
	degree=network.degree(network.vs,mode="OUT",loops=False)
	flag=0
	while(flag==0):
		net=network.Degree_Sequence(degree, method="vl")
		cl = net.connected_components()
		if (len(cl)==1):
			flag=1
			f1=open(ind+".txt","w")
			for i in net.es():
				node1=i.tuple[0]
				node2=i.tuple[1]
				f1.write( names[net.vs[node1].index]+"\t"+names[net.vs[node2].index]+"\n")
	f1.close()

if __name__ == '__main__':
    main()