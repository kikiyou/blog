# ansible 添加互信key



   - code: "authorized_key: user=charlie key='$FILE(/home/charlie/.ssh/id_rsa.pub)'"
     description: "Shorthand available in Ansible 0.8 and later"


EXAMPLES:
# Example using key data from a local file on the management machine
- authorized_key: user=charlie key="{{ lookup('file', '/home/charlie/.ssh/id_rsa.pub') }}"

# Using github url as key source
- authorized_key: user=charlie key=https://github.com/charlie.keys

# Using alternate directory locations:
- authorized_key: user=charlie
                  key="{{ lookup('file', '/home/charlie/.ssh/id_rsa.pub') }}"
                  path='/etc/ssh/authorized_keys/charlie'
                  manage_dir=no

# Using with_file
- name: Set up authorized_keys for the deploy user
  authorized_key: user=deploy
                  key="{{ item }}"
  with_file:
    - public_keys/doe-jane
    - public_keys/doe-john

# Using key_options:
- authorized_key: user=charlie
                  key="{{ lookup('file', '/home/charlie/.ssh/id_rsa.pub') }}"
                  key_options='no-port-forwarding,host="10.0.1.1"'

# Set up authorized_keys exclusively with one key
- authorized_key: user=root key=public_keys/doe-jane state=present
                   exclusive=yes
