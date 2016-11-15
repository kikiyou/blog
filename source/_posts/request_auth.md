---
title: request认证的支持
date: 2016-07-18 16:10:02
tags: python
---
# request认证的支持
<!-- more -->

Add in a proper AuthManager instead of the list version that was being used.
Added support for all Auth types that python supports

+ 第一个方案  创建包含usersname password 属性的对象
``` python

def test_AUTH_HTTPS_200_OK_GET(self):
    auth = requests.AuthObject('requeststest', 'requeststest')
    url = 'https://convore.com/api/account/verify.json'
    r = requests.get(url, auth=auth)

class AuthObject(object):   ##设定用户名 密码
    def __init__(self, username, password):
        self.username = username
        self.password = password

def get(url, params={}, headers={}, cookies=None, auth=None):
    r = Request(method='GET', url=url, params=params, headers=headers,
                cookiejar=cookies, auth=_detect_auth(url, auth))


def _detect_auth(url, auth):
    """Returns registered AuthObject for given url if available, defaulting to
    given AuthObject.
    """
    return _get_autoauth(url) if not auth else auth


def _get_autoauth(url):
    """Returns registered AuthObject for given url if available."""

    for (autoauth_url, auth) in AUTOAUTHS:
        if autoauth_url in url:
            return auth
    return None

AUTOAUTHS = []   ##配合全局认证的  全局参数

class Request(object):
    def __init__(self, url=None, headers=dict(), files=None, method=None,
                params=dict(), data=dict(), auth=None, cookiejar=None):

    
def _get_opener(self):
    if self.auth or self.cookiejar:
        if self.auth:
            authr = urllib2.HTTPPasswordMgrWithDefaultRealm()
            authr.add_password(None, self.url, self.auth.username, self.auth.password)


def add_autoauth(url, authobject):   ##自动认证  比如输入一次  以后访问自动传参数
    """Registers given AuthObject to given URL domain. for auto-activation.
    Once a URL is registered with an AuthObject, the configured HTTP
    Authentication will be used for all requests with URLS containing the given
    URL string.

    Example: ::
        >>> c_auth = requests.AuthObject('kennethreitz', 'xxxxxxx')
        >>> requests.add_autoauth('https://convore.com/api/', c_auth)
        >>> r = requests.get('https://convore.com/api/account/verify.json')
        # Automatically HTTP Authenticated! Wh00t!

    :param url: Base URL for given AuthObject to auto-activate for.
    :param authobject: AuthObject to auto-activate.
    """

    global AUTOAUTHS

    AUTOAUTHS.append((url, authobject))

```

+ 第二个方案 简化直接使用 list 传入
``` python
    >>> conv_auth = ('requeststest', 'requeststest') ##username password
    >>> r = requests.get('https://convore.com/api/account/verify.json', auth=conv_auth)

---------- 
auth = ('username','password')
auth[0]
auth[1]
def _get_opener(self):
    if self.auth or self.cookiejar:
        if self.auth:
            authr = urllib2.HTTPPasswordMgrWithDefaultRealm()

            authr.add_password(None, self.url, self.auth[0], self.auth[1])
            auth_handler = urllib2.HTTPBasicAuthHandler(authr)

            _handlers.append(auth_handler)
------------
```

+ 第三个方案 tags -> v0.3.0
``` python
    def test_AUTH_HTTPS_200_OK_GET(self):
        auth = ('requeststest', 'requeststest')
        url = 'https://convore.com/api/account/verify.json'
        r = requests.get(url, auth=auth)



    def request(method, url, **kwargs):
        data = kwargs.pop('data', dict()) or kwargs.pop('params', dict())

        r = Request(method=method, url=url, data=data, headers=kwargs.pop('headers', {}),
                cookiejar=kwargs.pop('cookies', None), files=kwargs.pop('files', None),
                auth=kwargs.pop('auth', auth_manager.get_auth(url)))
<!-- 没有直接传入auth时 有两中情况 -->
1. auth_manager.get_auth 查询是否定义了全局 密码，有的话返回全局密码
2. 没有的话返回 None 

auth_manager = AuthManager()

class AuthManager(object):
    """Authentication Manager."""
    
    def __new__(cls):
        singleton = cls.__dict__.get('__singleton__')
        if singleton is not None:
            return singleton

        cls.__singleton__ = singleton = object.__new__(cls)

        return singleton


    def __init__(self):
        self.passwd = {}
        self._auth = {}


    def __repr__(self):
        return '<AuthManager [%s]>' % (self.method)


    def add_auth(self, uri, auth):
        """Registers AuthObject to AuthManager."""
        
        uri = self.reduce_uri(uri, False)
        self._auth[uri] = auth

    def add_password(self, realm, uri, user, passwd):
        """Adds password to AuthManager."""
        # uri could be a single URI or a sequence
        if isinstance(uri, basestring):
            uri = [uri]
            
        reduced_uri = tuple([self.reduce_uri(u, False) for u in uri])
        
        if reduced_uri not in self.passwd:
            self.passwd[reduced_uri] = {}
        self.passwd[reduced_uri] = (user, passwd)


    def find_user_password(self, realm, authuri):
        for uris, authinfo in self.passwd.iteritems():
            reduced_authuri = self.reduce_uri(authuri, False)
            for uri in uris:
                if self.is_suburi(uri, reduced_authuri):
                    return authinfo

        return (None, None)


    def get_auth(self, uri):
        uri = self.reduce_uri(uri, False)
        return self._auth.get(uri, None)


    def reduce_uri(self, uri, default_port=True):
        """Accept authority or URI and extract only the authority and path."""
        # note HTTP URLs do not have a userinfo component
        parts = urllib2.urlparse.urlsplit(uri)
        if parts[1]:
            # URI
            scheme = parts[0]
            authority = parts[1]
            path = parts[2] or '/'
        else:
            # host or host:port
            scheme = None
            authority = uri
            path = '/'
        host, port = urllib2.splitport(authority)
        if default_port and port is None and scheme is not None:
            dport = {"http": 80,
                     "https": 443,
                     }.get(scheme)
            if dport is not None:
                authority = "%s:%d" % (host, dport)
        return authority, path

    
    def is_suburi(self, base, test):
        """Check if test is below base in a URI tree

        Both args must be URIs in reduced form.
        """
        if base == test:
            return True
        if base[0] != test[0]:
            return False
        common = urllib2.posixpath.commonprefix((base[1], test[1]))
        if len(common) == len(base[1]):
            return True
        return False


    def empty(self):
        self.passwd = {}


    def remove(self, uri, realm=None):
        # uri could be a single URI or a sequence
        if isinstance(uri, basestring):
            uri = [uri]

        for default_port in True, False:
            reduced_uri = tuple([self.reduce_uri(u, default_port) for u in uri])
            del self.passwd[reduced_uri][realm]


    def __contains__(self, uri):
        # uri could be a single URI or a sequence
        if isinstance(uri, basestring):
            uri = [uri]

        uri = tuple([self.reduce_uri(u, False) for u in uri])

        if uri in self.passwd:
            return True

        return False

    def _get_opener(self):
        """Creates appropriate opener object for urllib2."""

        _handlers = []

        if self.auth:
            if not isinstance(self.auth.handler, (urllib2.AbstractBasicAuthHandler, urllib2.AbstractDigestAuthHandler)):
                auth_manager.add_password(self.auth.realm, self.url, self.auth.username, self.auth.password)
                self.auth.handler = self.auth.handler(auth_manager)
                auth_manager.add_auth(self.url, self.auth)

            _handlers.append(self.auth.handler)

            _handlers.extend(get_handlers())
            opener = urllib2.build_opener(*_handlers)
            return opener.open
        else:
            return urllib2.urlopen

class Request(object):
    def __init__(self, url=None, headers=dict(), files=None, method=None,
                data=dict(), auth=None, cookiejar=None):
        if isinstance(auth, (list, tuple)):
            auth = AuthObject(*auth)
        if not auth:
            auth = auth_manager.get_auth(self.url)
        self.auth = auth
```