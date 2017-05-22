I got this simple playbook

#!/usr/bin/env ansible-playbook
---
- name: simple ansible playbook ping
  hosts: all
  gather_facts: false
  tasks:    
  - name: look up value in etcd
    debug: msg="{{ lookup('etcd', 'weather') }}"