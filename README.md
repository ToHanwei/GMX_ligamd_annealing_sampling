# GMX_ligamd_annealing_sampling
Periodic simulated annealing sampling
____________________________________________
## 执行周期性退火模拟
### 脚本作用所
需的输入文件是小分子的mol2格式文件，使用脚本acpype.py产生GAFF力场的GROMACS拓扑文件；使用Gromacs对小分子执行周期性退火模拟。脚本filter_edr.py对结果进行分析，并从轨迹中抽取能量最低的小分子结构若干个。这些步骤通过使用auto_run.sh一步完成。如果你有多个小分子待处理，这个工具将会使过程得到简化。
### 使用方法
* 脚本后面带有两个参数，第一个是保留最后构象的个数，第二个参数是MD运行的步数；
* 创建一个空目录作为工作目录，在该目录下创建目录mol2；
* 拷贝acpype.py, filter_edr.py, auto_run.sh和mp.mdp等文件到工作目录下；
* 准备好小分子（可以多个）的mol2文件，放到工作目录的的mol2文件夹下；
* 打开终端进入工作目录，并执行：bash auto_run.sh 10 10000000。
### 需要注意
* auto_run.sh被赋予可执行权限，在终端下直接运行auto_run.sh也可执行
* 每个小分子执行完成后，会询问是否清理文件（.edr,.xtc等文件），如果需要清理请输入yes；20s没有回复默认不清理
* 运行出现问题请联系：hanwei@shanghaitech.edu.cn
