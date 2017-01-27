# Copyright (c) 2006-2009 Mitch Garnaat http://garnaat.org/
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish, dis-
# tribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the fol-
# lowing conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABIL-
# ITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT
# SHALL THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

class Listener(object):
    """
    Represents an EC2 Load Balancer Listener tuple
    """

    def __init__(self, load_balancer=None, load_balancer_port=0,
                 instance_port=0, protocol='', ssl_certificate_id=None):
        self.load_balancer = load_balancer
        self.load_balancer_port = load_balancer_port
        self.instance_port = instance_port
        self.protocol = protocol
        self.ssl_certificate_id = ssl_certificate_id

    def __repr__(self):
        r = "(%d, %d, '%s'" % (self.load_balancer_port, self.instance_port, self.protocol)
        if self.ssl_certificate_id:
            r += ', %s' % (self.ssl_certificate_id)
        r += ')'
        return r

    def startElement(self, name, attrs, connection):
        return None

    def endElement(self, name, value, connection):
        if name == 'LoadBalancerPort':
            self.load_balancer_port = int(value)
        elif name == 'InstancePort':
            self.instance_port = int(value)
        elif name == 'Protocol':
            self.protocol = value
        elif name == 'SSLCertificateId':
            self.ssl_certificate_id = value
        else:
            setattr(self, name, value)

    def get_tuple(self):
        return self.load_balancer_port, self.instance_port, self.protocol

    def __getitem__(self, key):
        if key == 0:
            return self.load_balancer_port
        if key == 1:
            return self.instance_port
        if key == 2:
            return self.protocol
        raise KeyError




