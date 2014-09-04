#!/usr/bin/env ruby
require 'methadone'

include Methadone::Main
include Methadone::CLILogging

main do |args|

  if options[:start]
    `launchctl load -w ~/Library/LaunchAgents/com.eskild.shaula.plist`
    puts "Shaula is watching you!"
  end

  if options[:stop]
    `launchctl unload -w ~/Library/LaunchAgents/com.eskild.shaula.plist`
    `networksetup -setairportpower en0 on`
    puts "Shaula is stopped! Enjoy internet!"
  end

  if args
    interval = args.to_i
    `networksetup -setairportpower en0 on`
    puts "Shaula gives you #{interval} minutes online. Enjoy!"
  
    job = fork do
      sleep interval * 60
      `networksetup -setairportpower en0 off`
    end
    Process.detach job

  end
end

version     '0.0.1'
description 'Shaula controls your online time!'

on("--start", "Turns off airport on login")
on("--stop", "Sets your internet free from Shaula")

go!

