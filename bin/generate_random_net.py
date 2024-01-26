#!/usr/bin/env python

import sys
from igraph import *

network=Graph.Read_Ncol(sys.argv[2],directed=False)

names=network.vs["name"]
if sys.argv[1]=='0':
	f1=open('nodes.txt','w')
	for i in list(set(names)):
		f1.write(i+'\n')

degree=network.degree(network.vs,mode="OUT",loops=False)
flag=0
while(flag==0):
	net=network.Degree_Sequence(degree, method="vl")
	cl = net.connected_components()
	if (len(cl)==1):
		flag=1
		f1=open(sys.argv[1]+".txt","w")
		for i in net.es():
			node1=i.tuple[0]
			node2=i.tuple[1]
			f1.write( names[net.vs[node1].index]+"\t"+names[net.vs[node2].index]+"\n")
f1.close()
