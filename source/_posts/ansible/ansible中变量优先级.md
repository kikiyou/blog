In 2.x, we have made the order of precedence more specific (with the last listed variables winning prioritization):

role defaults [1]
inventory vars [2]
inventory group_vars
inventory host_vars
playbook group_vars
playbook host_vars
host facts
play vars
play vars_prompt
play vars_files
registered vars
set_facts
role and include vars
block vars (only for tasks in block)
task vars (only for the task)
extra vars (always win precedence)
