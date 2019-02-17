#!codeing:utf-8

"""
Filter low energy structure.
The input file is 'xvg' format file
Out is pkl format, save low energy structure number
"""
import os
import sys
import getopt

usage = """
Usage: sys.args[0] [option]
-h: 显示帮助信息
-i: 输入文件名
-n: 输出个数
-t: tpr文件名
-x: xtc轨迹文件名
-o: 是否(yes/no)打印能量
"""
def Usage():
	print(usage)
	sys.exit()

if len(sys.argv) == 1: Usage()
try:
	opts, args = getopt.getopt(sys.argv[1:], "hi:n:o:i:t:x:")
	opts = dict(opts)
except getopt.GetoptError:
	print("argv error,please input"); Usage()

#From input file obtain data of energy
infile = opts["-i"]
num = int(opts["-n"])
out = opts["-o"]
with open(infile, mode='r') as readf:
	edr_data = [line.split() for line in readf if line[0] not in ["#", "@"]]
#Sort and filter energe data
data = sorted(edr_data, key=lambda x:x[1])
data = [[int(float(edr[0])), edr[1]] for edr in data[:num]]

#Print energe information if -o is true
if out == "yes":
	print("Frame\tEnerage")
	for dat in data:
		print("{0}\t{1}".format(dat[0], dat[1]))

#Save Frame to file
trj = opts["-t"]
xtc = opts["-x"]
gro = "enegy_gro"
if not os.path.exists(gro): os.mkdir(gro)
for dat in data:
	name = xtc.split(".")[0]+"_"+str(dat[0])+".gro"
	cmd = "echo 0 | gmx trjconv -f {0} -s {1} -b {2} -e {2} -o {3}".format(
			xtc, trj, dat[0], name)
	os.system(cmd)
	os.system("mv "+name+" "+gro)

