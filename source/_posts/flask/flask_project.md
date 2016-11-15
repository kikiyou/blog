---
title: flask项目组织方法

tags: 
- python
---

# flask项目组织方法
<!-- more -->
参考：https://exploreflask.com/blueprints.html
两种组织Blueprints 的方法。
1， 功能型

yourapp/
    __init__.py
    static/
    templates/
        home/
        control_panel/
        admin/
    views/
        __init__.py
        home.py
        control_panel.py
        admin.py
    models.py
2, 划分型

yourapp/
    __init__.py
    admin/
        __init__.py
        views.py
        static/
        templates/
    home/
        __init__.py
        views.py
        static/
        templates/
    control_panel/
        __init__.py
        views.py
        static/
        templates/
    models.py
每个单独的功能或模块可以放在一个views 文件或包里，公共服务接口可以放在上层位置，或作为单独的Blueprint (API 服务)或模块包。
根据项目的复杂度和功能特征来定。