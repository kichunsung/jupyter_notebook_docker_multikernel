import json
import argparse
import os
base_kernel_path ='/root/.local/share/jupyter/kernels/'
file_name = 'kernel'
default_kernel ={
     "argv": [ "/root/.pyenv/shims/python2", "-m", "ipykernel",
              "-f", "{connection_file}"],
     "display_name": "python2",
     "language": "python"
    }


def write(file_name,data):
    if not os.path.exists(os.path.dirname(file_name)):
        os.makedirs(os.path.dirname(file_name))
    # os.makedirs(os.path.dirname(file_name), exist_ok=True)
    write_dict_json(file_name,data,'w')

def write_dict_json(path, data, mode='a', encoding='utf-8', format='.json'):
    with open(path + format, mode=mode, encoding=encoding, newline='\n') as f:
        json.dump(data, f, ensure_ascii=False, indent='\t')

def gen_kernel(python_version,venv_name,venv_path):
    # make path
    save_path = os.path.join(os.path.join(base_kernel_path,venv_name),file_name)
    # gen json
    kernel = default_kernel
    kernel['argv'][0] = os.path.join(venv_path,'python') 
    kernel['display_name'] = python_version+'_'+venv_name
    print(kernel)
    print(save_path)
    # save json
    write(save_path,kernel)

if __name__ == '__main__':
    print("Generate kernel START")
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--python-version", required=True, help="python-version")
    parser.add_argument("-vn", "--venv-name",required=True,help="virtualenv name")
    parser.add_argument("-vp", "--venv-path",required=True,help="virtual_env path")
    args = parser.parse_args()
    args = vars(args)
    gen_kernel(**args)
    print("Generate kernel FINISH")

    """
    {
     "argv": [ "/root/.pyenv/shims/python2", "-m", "ipykernel",
              "-f", "{connection_file}"],
     "display_name": "python2",
     "language": "python"
    }
    """