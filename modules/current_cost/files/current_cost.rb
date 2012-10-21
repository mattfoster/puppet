#! /usr/bin/env ruby

require 'rubygems'
require 'daemons'
require 'collectd'
require 'rexml/document'
require 'serialport'

# Names and values to output
$data = {
#  'src'         => '//src',
#  'dsb'         => '//dsb',
#  'time'        => '//time',
#  'sensor'      => '//sensor',
#  'id'          => '//id',
#  'type'        => '//type',
  'temperature' => '//tmpr',
  'power'       => '//ch1/watts',
}

# Extract and print specified data.
def xml_to_string(xml)
  return if xml.nil?
  output = $data.each.map do |key, value|
    "#{key.to_str}:#{xml.elements[value].text.to_f}"
  end
  output.join(' ')
end

# Wrte the last values to a file, ready for cacti to eat
def write_last_measurement(line, filename = '/tmp/currentcost')
  File.open(filename, "w") do |file|
    file.puts Time.now,(line)
  end
end

def read_serial_data(port, stats)
  serialport = SerialPort.open(port, 57600, 8, 1, SerialPort::NONE) do |port|
    port.each_line do |raw|

      # Read and parse serial data
      if raw 
        xml = REXML::Document.new(raw)
        
        begin
          stats.temperature(:temperature).gauge = xml.elements[$data['temperature']].text.to_f
          stats.power(:power).gauge = xml.elements[$data['power']].text.to_f
          data = xml_to_string(xml)
          write_last_measurement(data)
          puts "[#{Time.now}: #{data}"
        rescue NoMethodError
          puts "[#{Time.now}: Problem grabbing XML info"
        end
      end

      # Do some logging
      puts "[#{Time.now}] read data from currentcost device: #{raw}"
      puts "[#{Time.now}] generated output: #{data}"
    end
  end
end

# Simple daemon which continually reads from the searial port, and logs
# currentcost data to collectd

options = {
  :dir_mod    => :system, 
  :log_output => true
}

# Most serial port settings (baud rate, etc are fixed by the device)
port = '/dev/ttyUSB0'
puts "[#{Time.now}] Starting CurrentCost monitor on #{port}"


Daemons.run_proc('CurrentCost', options) do
  Collectd.add_server(interval=10)
  Stats = Collectd.current_cost(:reader)
  Stats.with_full_proc_stats
  begin
    read_serial_data(port, Stats)
  rescue REXML::ParseException, EOFError
    puts "[#{Time.now}] problem reading data"
    retry
  end
end
