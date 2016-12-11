    - name: Check to see if Plone 5 is running
      uri:
        url: http://127.0.0.1:5081/Plone
        method: GET
        status_code: 200

    - name: Check to see if Plone 4.3.x is running
      uri:
        url: http://127.0.0.1:4081/Plone
        method: GET
        status_code: 200