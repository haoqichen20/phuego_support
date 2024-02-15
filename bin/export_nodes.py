#!/usr/bin/env python

import sys
from igraph import *

def main():
	network_path = sys.argv[1]

	network=Graph.Read_Ncol(network_path,directed=False)
	names=network.vs["name"]
	f1=open('nodes.txt','w')
	for i in list(set(names)):
		f1.write(i+'\n')

if __name__ == '__main__':
	main()