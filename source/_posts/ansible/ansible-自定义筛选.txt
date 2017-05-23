# ansible自定义 筛选

ansible自定义 筛选，可以自定义 筛选内容，扩充jinjia模板

---

- name: Demonstrate custom jinja2 filters
  hosts: all
  tasks:
  - action: template src=templates/custom-filters.j2 dest=/tmp/custom-filters.txt




cat filter_plugins/custom_plugins.py

class FilterModule(object):
    ''' Custom filters are loaded by FilterModule objects '''

    def filters(self):
        ''' FilterModule objects return a dict mapping filter names to
            filter functions. '''
        return {
            'generate_answer': self.generate_answer,
        }

    def generate_answer(self, value):
        return '42'
------------

cat templates/custom-filters.j2

1 + 1 = {{ '1+1' | generate_answer }}
