# ansible 变量提示 交互式 输入变量

执行到这里之后，会出现 交互式窗口 让你输入变量

$ansible-playbook prompts.yml
Enter password: 
Product release version: 456
Enter password2: 
confirm Enter password2: 



  vars_prompt:
    - name: "some_password"
      prompt: "Enter password"
      private: yes

    - name: "release_version"
      prompt: "Product release version"
      default: "my_default_version"
      private: no
   
    - name: "my_password2"
      prompt: "Enter password2"
      private: yes
      encrypt: "md5_crypt" 
      confirm: yes
      salt_size: 7
      salt: "foo" 

# this is just a simple example to show that vars_prompt works, but
# you might ask for a tag to use with the git module or perhaps
# a package version to use with the yum module.

  tasks:

  - name: imagine this did something interesting with $release_version
    action: shell echo foo >> /tmp/$release_version-alpha

  - name: look we crypted a password
    action: shell echo my password is $my_password2