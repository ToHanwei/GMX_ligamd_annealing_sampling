#结果储存文件夹
res="Result"
#过滤出值的个数
num=10

if [ -e ${res} ] 
then
	echo "开始运行"
else
	echo "创建目录"${res}
	mkdir ${res}
	echo "创建完成，开始运行"
fi

for file in `ls mol2`; do
	file_new="mol2/"${file}
	python ./acpype.py -i ${file_new}
	prefix=${file%.*2}
	DIR=${prefix}.acpype
	cd ${res}
	echo "进入目录"${res}
	mv ../${DIR} .
	if [ -e ${prefix} ]; then
		cd ${prefix}
		echo "进入目录"${prefix}
	else
		mkdir ${prefix}
		cd ${prefix}
		echo "进入目录"${prefix}
	fi

	echo "运行Gromacs程序"
	#Gromacs预处理命令
	gmx grompp -f ../../md.mdp -c ../${DIR}"/"${prefix}_GMX.gro -p ../${DIR}"/"${prefix}_GMX.top -o ${prefix}.tpr
	#正式运行MD
	gmx mdrun -v -deffnm ${prefix}
	#从轨迹文件中提取稳定构象帧
	gmx trjconv -f ${prefix}.xtc -o ${prefix}_struc.xtc -dt 200
	gmx eneconv -f ${prefix}.edr -o ${prefix}_struc.edr -dt 200
	#提取稳定构象能量值及其对应帧数
	echo "Total-Energy" | gmx energy -f ${prefix}_struc.edr -o ${prefix}_struc_edr.xvg
	#运行过滤脚本
	python ../../filter_edr.py -i ${prefix}_struc_edr.xvg -n $num -o yes -t ${prefix}.tpr -x ${prefix}.xtc
	#清理文件
	echo "需要清理文件吗？yes/no"
	read -t 20 clea
	if [ $clea == "yes" ]; then
		rm ${prefix}.edr ${prefix}.xtc ${prefix}.tpr ${prefix}.cpt ${prefix}.log
		echo "文件已清理"
	else
		echo "没有清理文件"
	fi
	echo "返回初始目录"
	cd ../../
done

