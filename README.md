# Vagranthook

This project proves how to create a basic plugin that can hook to a specific event chain.

It is a base, so that in the future it can support further events.

Feel free to contribute.

# Installation

vagrant plugin install vagrant_hook

# How to use

In your vagrant box add something like:

config.vagrant_hook.check_outdated do |host|
    puts "hello world!"
end
