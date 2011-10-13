# Moxy

Moxy or `moxy` is a programmable mock proxy. It is a proxy, exposed with web hooks that allow you to set up expectations on it, in terms of HTTP requests.  

For example, you might want to set up that a request to `http://google.com` will return the text `boo hoo`. Thats easy:

	$ curl -d "stub_request(:get, 'http://google.com').to_return(:body=>'boo hoo')" http://localhost:9292/__setup__

However, moxy was not made for practical jokes. It was made in order to allow you to integrate such things in integration tests.

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

See more in `/examples`.  


But these kind of things can already be done using `rack-test`, and other abstraction/mocking frameworks in other languages. Moxy can be an **extremely fitting** answer to your problems when:

* The juice is not worth the squeeze. You need to integration test but you don't want/need to invest effort in convoluted HTTP abstracting test code and helpers. Just set up a real response and go.

* The language / platform is not worth the squeeze. Some platforms and languages just aren't as great as Ruby. In .NET, for example, some parts of the framework don't allow for (real) testing. Using moxy clears this up pretty easily!.

* You need a proxy which is programmable. Reply with pre-programmed responses, send back files, or just pre-program to return all sorts of errors that blow in your face.




## Getting Started

Moxy can be used as a system executable or a deployable web app.  

A useful scenario for running as a gem is having several instances for many scenarios and applications.  

A good scenario for deploying as a web app is on a dedicated integration server.  


### As a gem

Run `gem install moxy` and then you can run moxy from your terminal:

	$ moxy  # no arguments, default to localhost, 9292
	$ moxy integration-notifier.dev.com 3000 

### Deploying as a webapp

Moxy will run on any rack handler:
	
	$ git clone https://github.com/jondot/moxy
	$ cd moxy; rackup



## Using Moxy



## Contributing

Fork, implement, add tests, pull request, get my everlasting thanks and a respectable place here :).


## Copyright

Copyright (c) 2011 [Dotan Nahum](http://gplus.to/dotan) [@jondot](http://twitter.com/jondot). See MIT-LICENSE for further details.
