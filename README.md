# Moxy

Moxy (or `moxy`) is a programmable mock proxy. It is an HTTP proxy exposing web hooks that you can use in order to tell it what to do, and when to do it.

For example, you might want to set up that a request to `http://google.com` will return the text `boo hoo`. Thats easy:

    $ curl -d "mock_text=stub_request(:get, 'http://google.com').to_return(:body=>'boo hoo')" http://localhost:9292/__setup__ 

However, moxy was not made just for one-offs. It was made in order to allow you to use such things in automated integration tests.

Here is an example in Ruby:

	it "should handle google crashes" do
		# setup responses at moxie.
		HTTParty.post('http://localhost:9292/__setup__', 
		          :body=>{
		            :mock_text=>'stub_request(:get, "http://google.com?q=moxie").to_return(:status=>401)'
		          })

		r = Google.get("http://google.com?q=moxie")

		r.code.must_equal 401
	end

See more languages and use cases in `/examples`.  


But these kind of things can already be done using `rack-test`, and other abstraction/mocking frameworks in other languages. Moxy can be an **extremely fitting** answer to your problems when:

* The juice is not worth the squeeze. You need to integration test but you don't want/need to invest effort in convoluted HTTP abstracting test code and helpers. Just set up a real response and go.

* The language / platform is not worth the squeeze. Some platforms and languages just aren't as great as Ruby. In .NET, for example, some parts of the framework don't allow for (real) testing. Using moxy clears this up pretty easily!.

* You need a proxy which is programmable. Reply with pre-programmed responses, send back files, or just pre-program to return all sorts of errors that blow in your face.




## Getting Started

Run `gem install moxy`


### As a system executable

	$ moxy  # no arguments, default to localhost, 9292
	$ moxy integration-notifier.dev.com 3000 

### As a Web app

	$ git clone https://github.com/jondot/moxy
	$ cd moxy; rackup

A web app is great for a dedicated integration server. Moxy will run on any rack handler.



## Using Moxy

1. Set `http://moxy-host:port` as a system proxy, or a proxy in your HTTP library in your code.
2. Issue any number of POSTs to your `http://moxy-host:port/__setup__` endpoint with a POST variable named `mock_text`.

Below are some examples of `mock_text` (in each, second line describes result).

    stub_request :get, "http://google.com"
    (Returns an empty content with 200 HTTP status code)


    stub_request(:get, "http://google.com").to_return(:body => "boo hoo!")
    (Returns boo hoo! as content)


    stub_request(:get, "http://google.com").to_return(:body => "boo hoo!", :code => 500)
    (Returns boo hoo! as content)

Since currently `moxy` uses [WebMock](https://github.com/bblimke/webmock) under the hood (that may change), this will be WebMock's syntax, and you can go learn about it
for more examples.

## Moxy Console
If you access `http://moxy-host:port/__setup__` in your browser, you'll be presented with the moxy console:
![](https://github.com/jondot/moxy/raw/master/examples/console1.png)
![](https://github.com/jondot/moxy/raw/master/examples/console2.png)


## Contributing

Fork, implement, add tests, pull request, get my everlasting thanks and a respectable place here :).


## Copyright

Copyright (c) 2011 [Dotan Nahum](http://gplus.to/dotan) [@jondot](http://twitter.com/jondot). See MIT-LICENSE for further details.
