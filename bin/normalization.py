#!/usr/bin/env python

import igraph as ig
import sys,math,os
import numpy as np

def denoise_square(G):
	weight=G.strength(G.vs, mode='all', loops=False, weights='weight')
	for i in G.es():
		node_A=i.tuple[0]
		node_B=i.tuple[1]
		den=math.sqrt(weight[node_A]*weight[node_B])
		num=i["weight"]
		G.es[i.index]["weight"]=num/den
	return (G)

def normalization(net_path):
	gig=ig.Graph.Read_Ncol(net_path, weights=True, directed=False)
	nodes=gig.vs["name"]
	gig_norm=denoise_square(gig)
	f1=open("./laplacian/"+net_path.split("/")[-1],"w")
	for i in gig_norm.es:
		node1=i.tuple[0]
		node2=i.tuple[1]
		node1=gig.vs[node1]["name"]
		node2=gig.vs[node2]["name"]
		f1.write(node1+"\t"+node2+"\t"+str(i["weight"])+"\n")

def main():
	net_path=sys.argv[1]
	os.mkdir("laplacian")
	normalization(net_path)

if __name__ == '__main__':
    main()