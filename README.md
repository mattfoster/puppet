# Raspberry Pi Puppet Modules

Sick of repeatedly setting up the same things after wiping or upgrading your
Raspberry Pi's SD card? Me too! I made this simple puppet repo so I could
easily install my Current Cost monitoring software without too many boring,
manual steps.

## Usage

Install Raspbian to your SD card. I'm using wheezy, because that gives me
recent versions of ruby and collectd.
  
Manually install the `collectd` rubygem. There's a 
[bug](http://projects.puppetlabs.com/issues/1398) in puppet which means
you can't install two different types of package with the same name.
 
    sudo gem install collectd

Now install puppet:

    sudo apt-get install puppet

Clone this repo:

    git clone https://github.com/mattfoster/puppet.git

Edit the `nodes.pp`, to add your collectd server's secret key (the template
`collectd.conf` will use the π's hosname as the username). Now ensure you're in
the puppet directory, and run:

    sudo puppet apply --modulepath=modules nodes.pp 

That's it!

## More?

This is a very small repo, which does very little. Puppet is pretty open-ended,
so can be pretty hard to get to grips with.

If you've never used puppet before, this simple repo might give you enough to
help you get started. Once you get used to the idea of automating annoying
little administrative tasks you'll probably want to use it everywhere.

There's plenty of documentation online, at: http://docs.puppetlabs.com/ and
http://puppetcookbook.com/.
