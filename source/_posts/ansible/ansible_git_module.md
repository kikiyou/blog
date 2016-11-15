---
title: ansible的git 模块
date: 2016-10-7 10:19:44
tags: 
- ansible
- python
---
# ansible的git 模块
<!-- more -->
ansibel的git模块中包含如下函数
第一版 git模块 只处理master版本

``` python

def get_version(dest):
   ''' 
   samples the version of the git repo 
   commit 1adb284

   retrun 1adb284
   '''
   os.chdir(dest)
   cmd = "git show --abbrev-commit"
   sha = os.popen(cmd).read().split("\n")
   sha = sha[0].split()[1]
   return sha

def clone(repo, dest):
   ''' makes a new git repo if it does not already exist '''
   try:
       os.makedirs(dest)
   except:
       pass
   cmd = "git clone %s %s" % (repo, dest)
   cmd = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
   return cmd.communicate()

def pull(repo, dest):
   ''' updates repo from remote sources '''
   os.chdir(dest)
   cmd = "git pull -u origin"
   cmd = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
   return cmd.communicate()

def switchver(version, dest):
   ''' once pulled, switch to a particular SHA or tag '''
   os.chdir(dest)
   if version != 'HEAD':
      cmd = "git checkout %s --force" % version
   else:
      # is there a better way to do this?
      cmd = "git rebase origin"
   cmd = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
   (out, err) = cmd.communicate()
   return (out, err)
```