#!coding:utf-8

from sys import argv
"""
该脚本修改md.mdp文件
"""

infile = argv[1]
steeps = argv[2]

with open(infile,mode='r') as readfile:
    for line in readfile:
        lins_list = line.strip().strip()
        if line_list[0] == "nsteps":
            line_list[2] = steeps
    outline = ""
    for line in line_list:
        outline += line
