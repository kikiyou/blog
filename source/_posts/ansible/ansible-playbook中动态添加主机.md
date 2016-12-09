# ansible-playbook 动态添加主机

## add_host模块 ansible 2.0
    ---
    - name: launch instances
      os_server:
        name: "{{ prefix }}-{{ item.name }}"
        state: present
        key_name: "{{ item.key }}"
        availability_zone: "{{ item.availability_zone }}"
        nics: "{{ item.nics }}"
        image: "{{ item.image }}"
        flavor: "{{ item.flavor }}"
      with_items: "{{ servers }}"
      register: "os_hosts"

    - name: add hosts to inventory
      add_host:
        name: "{{ item['openstack']['human_id'] }}"
        groups: "{{ item['item']['meta']['group'] }}"
        ansible_host: "{{ item.openstack.accessIPv4 }}"
      with_items: "{{ os_hosts.results }}"

[参考:](https://raymii.org/s/tutorials/Ansible_-_create_OpenStack_servers_with_os_server.html)