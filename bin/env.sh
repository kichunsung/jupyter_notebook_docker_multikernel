#!/bin/bash
origin_dir=$(pwd)
if [ "$#" -lt 1 ]; then
    echo "$# is Illegal number of parameters."
    echo "Usage: $0 [env_list/{project_folder}]"
    exit 1
fi

cd $1

pyenv_base_path=/root/.pyenv/versions
echo workspace : $WORKSPACE
dir=$(pwd)
echo Current PATH : $dir
cd $dir
python_version="$(cat version)"
echo Python Version : $python_version

#for w in $(echo $(pwd) | tr "/" " ") ; do foldername=$w; done
virtualenv_name=${dir##*/}
echo Virtualenv_name : $virtualenv_name
#pyenv virtualenv
pyenv install -s $python_version
pyenv virtualenv -f $python_version $virtualenv_name
#pyenv activate $virtualenv_name

venv_path=$pyenv_base_path/$virtualenv_name
venv_path=$venv_path/bin
echo venv_path : $venv_path
$venv_path/pip install --upgrade pip
$venv_path/pip install -r requirements.txt
$venv_path/pip install ipykernel

# set multi kernel
cd $origin_dir
python gen_kernel.py -p $python_version -vn $virtualenv_name -vp $venv_path