res="Result"

if [ -e $res ] 
then
	echo "开始运行"
else
	echo "创建目录"$res
	mkdir $res
	echo "创建完成，开始运行"
fi

for file in `ls mol2`; do
	file_new="mol2/"$file
	#python ./acpype.py -i $file_new
	prefix=${file%.*2}
	DIR=$prefix".acpype"
	cd $res
	echo "进入目录"$res
	mv ../$DIR .
	if [ -e $prefix ]; then
		cd $prefix
		echo "进入目录"$prefix
	else
		mkdir $prefix
		cd $prefix
		echo "进入目录"$prefix
	fi

	echo "运行Gromacs程序"
	gmx grompp -f ../../md.mdp -c ../${DIR}"/"${prefix}_GMX.gro -p ../${DIR}"/"${prefix}_GMX.top -o ${prefix}.tpr
	gmx mdrun -v -deffnm ${prefix}
	gmx trjconv -f ${prefix}.xtc -o ${prefix}_struc.xtc -dt 200
	gmx eneconv -f ${prefix}.edr -o ${prefix}_struc.edr -dt 200
	echo "Total-Energy" | gmx energy -f ${prefix}_struc.edr -o ${prefix}_struc_edr.xvg
	cd ../../	
	echo "返回初始目录"
done
