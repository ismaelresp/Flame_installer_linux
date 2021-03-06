#!/bin/bash

#Checking miniconda/conda presence

condadir="which conda"
$condadir

if [ $? -eq 0 ]; 
	then
    		echo "Conda is present"
		export PATH="$condadir/bin:$PATH"
		conda config --set always_yes yes
		conda update -q conda
		source $HOME/.bashrc

else
	echo "conda is not present"
	wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
	bash $HOME/miniconda.sh -b -p $HOME/miniconda
	export PATH="$HOME/miniconda/bin:$PATH"
	conda config --set always_yes yes
	conda update -q conda
	source $HOME/.bashrc
fi

#Checking flame presence

flamedir="source activate flame"
$flamedir

if [ $? -eq 0 ]; 
	then
    		echo "Flame is present, checking if version is v1.0.0-rc2"
		cd $HOME/flame_core/flame
		git checkout v1.0.0-rc2
		if [ $? -eq 0];
			then
				echo "Flame is updated to last stable version"
		else
			git pull
			pip install -e .
			echo "Reseting model path"
			flame -c config -a silent
			git checkout v1.0.0-rc2
		
		cd $HOME/flame_core/flame_API
		git checkout v1.0.0-rc2
		if [ $? -eq 0];
			then
				echo "Flame API is updated to last stable version"
		else
			git pull
			git checkout v1.0.0-rc2
		
		echo "Flame and Flame API have been updated to stable version v1.0.0-rc2"

else
	#Downloading Flame and Flame API
	echo "Flame is not present. Installing stable version v1.0.0-rc2"
	mkdir $HOME/flame_core
	cd $HOME/flame_core
	git clone https://github.com/phi-grib/flame.git --branch v1.0.0-rc2 --depth 1
	git clone https://github.com/phi-grib/flame_API.git --branch v1.0.0-rc2 --depth 1
	cd flame
	echo "------- Working dir `pwd` -------"
	conda info -a
	conda env create -f environment.yml
	conda init
	source activate flame
	echo "------- Current env $CONDA_DEFAULT_ENV -------"
	pip install -e .
	echo "------ Using Flame `which flame` -----------"
	flame -c config -a silent
fi

# Adding Flame executable in desktop
installer_dir=$(find ${HOME} -name Flame_installer_linux | grep Flame)
cd ${installer_dir}/exec
sed -i "s?\/home\/eric?$HOME?" Flame.desktop
cp Flame.desktop $HOME/Desktop
cp Flame.desktop $HOME/.local/share/applications