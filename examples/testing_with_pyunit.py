import urllib
import unittest

# Pythonistas, set up a global proxy.
# i'm doing it with: 
#
#   $ export http_proxy="http://localhost:9292"
#
# before test run.

class TestGoogle(unittest.TestCase):
    def test_google_unauthorized(self): # passing self, heh.
        params = urllib.urlencode({'mock_text': 'stub_request(:get, "http://google.com?q=moxie").to_return(:status=>401)'})
        urllib.urlopen("http://google.com/__setup__",params).read()
        self.assertRaises(IOError, urllib.urlopen, "http://google.com/?q=moxie") # seriously, python.

if __name__ == '__main__':
    unittest.main()
