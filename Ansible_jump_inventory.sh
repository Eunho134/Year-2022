# Ansible Jump Host inventory
# reference https://docs.ansible.com/

jump_ssh_port=""            # jumphost ssh service port 
jump_name=""                # jumphost terminal name
jump_ip=""                  # jumphost ip


[group]                     # inventory group name
172.25.0.xx                 # user ip

[group:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -p $jump_ssh_port $jump_name@$jump_ip"'
ansible_user=""             # target server ssh_name
ansible_password=""         # target server ssh_password
ansible_become_method=su    # ssh sudo role change
ansible_become_pass=""      # sudo password
