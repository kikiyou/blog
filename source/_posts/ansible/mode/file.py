#!/usr/bin/python

# (c) 2012, Michael DeHaan <michael.dehaan@gmail.com>
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

try:
    import json
except ImportError:
    import simplejson as json
import os
import sys
import shlex
import subprocess
import shutil
import stat
import grp
import pwd

def debug(msg):
    # ansible ignores stderr, so it's safe to use for debug
    # print >>sys.stderr, msg
    pass

def exit_json(rc=0, **kwargs):
    # FIXME: if path exists, include the user, group, mode and context
    # in the data if not already present, such that this module is
    # also useful for inventory purposes
    if 'path' in kwargs:
        debug("adding path info")
        add_path_info(kwargs)
    print json.dumps(kwargs)
    sys.exit(rc)

def fail_json(**kwargs):
    kwargs['failed'] = True
    exit_json(rc=1, **kwargs)

def add_path_info(kwargs):
    path = kwargs['path']
    if os.path.exists(path):
        (user, group) = user_and_group(path)
        kwargs['user']  = user
        kwargs['group'] = group
        st = os.stat(path)
        kwargs['mode']  = stat.S_IMODE(st[stat.ST_MODE])
        # secontext not yet supported
        if os.path.isfile(path):
            kwargs['state'] = 'file'
        else:
            kwargs['state'] = 'directory'
    else:
        kwargs['state'] = 'absent'
    return kwargs 
 
# ===========================================

argfile = sys.argv[1]
args    = open(argfile, 'r').read()
items   = shlex.split(args)

if not len(items):
    fail_json(msg='the module requires arguments -a')
    sys.exit(1)

params = {}
for x in items:
    (k, v) = x.split("=")
    params[k] = v

state     = params.get('state','file')
path      = params.get('path', params.get('dest', params.get('name', None)))
link      = params.get('link', 'false')
mode      = params.get('mode', None)
owner     = params.get('owner', None)
group     = params.get('group', None)
recurse   = params.get('recurse', 'false')
secontext = params.get('secontext', None)

if state not in [ 'file', 'directory', 'absent' ]:
    fail_json(msg='invalid state')
if path is None:
    fail_json(msg='path is required')

changed = False

# ===========================================
# support functions

def md5sum(filename):
    return os.popen("/usr/bin/md5sum %s" % f).read()

def user_and_group(filename):
    st = os.stat(filename)
    uid = st.st_uid
    gid = st.st_gid
    user = pwd.getpwuid(uid)[0]
    group = grp.getgrgid(gid)[0]
    debug("got user=%s and group=%s" % (user, group))
    return (user, group)

    
def set_context_if_different(path, context, changed):
   if context is None:
       return changed
   if context is not None:
       fail_json(path=path, msg='context not yet supported')
    
def set_owner_if_different(path, owner, changed):
   if owner is None:
       debug('not tweaking owner')
       return changed
   user, group = user_and_group(path)
   if owner != user:
       debug('setting owner')
       rc = os.system("/bin/chown -R %s %s" % (owner, path))
       if rc != 0:
           fail_json(path=path, msg='chown failed')
       return True

   return changed
    
def set_group_if_different(path, group, changed):
   if group is None:
       debug('not tweaking group')
       return changed
   old_user, old_group = user_and_group(path)
   if old_group != group:
       debug('setting group')
       rc = os.system("/bin/chgrp -R %s %s" % (group, path))
       if rc != 0:
           fail_json(path=path, msg='chgrp failed')
       return True
   return changed

def set_mode_if_different(path, mode, changed):
   if mode is None:
       debug('not tweaking mode')
       return changed
   try:
       # FIXME: support English modes
       mode = int("0%s" % mode)
   except Exception, e:
       fail_json(path=path, msg='mode needs to be something octalish', details=str(e))  
 
   st = os.stat(path)
   prev_mode = stat.S_IMODE(st[stat.ST_MODE])

   if prev_mode != mode:
       # FIXME: comparison against string above will cause this to be executed
       # every time
       try:
           debug('setting mode')
           os.chmod(path, mode)
       except Exception, e:
           fail_json(path=path, msg='chmod failed', details=str(e))

       st = os.stat(path)
       new_mode = stat.S_IMODE(st[stat.ST_MODE])

       if new_mode != prev_mode:
           return True
   return changed

def rmtree_error(func, path, exc_info):
   fail_json(path=path, msg='failed to remove directory')

# ===========================================
# go...

prev_state = 'absent'
if os.path.exists(path):
    if os.path.isfile(path):
        prev_state = 'file'
    else:
        prev_state = 'directory'

if prev_state != 'absent' and state == 'absent':
    debug('requesting absent')
    try:
        if prev_state == 'directory':
            if os.path.islink(path):
                os.unlink(path)
            else:
                shutil.rmtree(path, ignore_errors=False, onerror=rmtree_error)
        else:
            os.unlink(path)
    except Exception, e:
        fail_json(path=path, msg=str(e))
    exit_json(path=path, changed=True)
    sys.exit(0)

if prev_state != 'absent' and prev_state != state:
    fail_json(path=path, msg='refusing to convert between file and directory')

if prev_state == 'absent' and state == 'absent':
    exit_json(path=path, changed=False)

if state == 'file':

    debug('requesting file')
    if prev_state == 'absent':
        fail_json(path=path, msg='file does not exist, use copy or template module to create')

    # set modes owners and context as needed
    changed = set_context_if_different(path, secontext, changed)
    changed = set_owner_if_different(path, owner, changed)
    changed = set_group_if_different(path, group, changed)
    changed = set_mode_if_different(path, mode, changed)

    exit_json(path=path, changed=changed)

elif state == 'directory':

    debug('requesting directory')
    if prev_state == 'absent':
        os.makedirs(path)
        changed = True
 
    # set modes owners and context as needed
    changed = set_context_if_different(path, secontext, changed)
    changed = set_owner_if_different(path, owner, changed)
    changed = set_group_if_different(path, owner, changed)
    changed = set_mode_if_different(path, owner, changed)

    exit_json(path=path, changed=changed)

fail_json(path=path, msg='unexpected position reached')
sys.exit(0)

