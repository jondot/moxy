# Moxy

- run specs & define incomplete specs.



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


