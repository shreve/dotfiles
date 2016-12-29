# coding: utf-8
puts " 💎  Ruby #{RUBY_VERSION}"

# IRB extensions
require 'irb/completion'
require 'ap'
require 'benchmark'
require 'fileutils'

if defined?(Rails)
  path = Rails.root.join('log/railsc.log').to_s
  prompt = "[\e[1;31mrails/#{Rails.env}\e[0m]$ "
else
  path = File.expand_path('~/.irb_history')
  prompt = "[\e[1;31mirb/local\e[0m]$ "
end

FileUtils.touch(path) unless File.exist?(path)

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = path
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:IGNORE_SIGINT] = true
IRB.conf[:PROMPT][:CUSTOM] = {
  PROMPT_N: prompt,
  PROMPT_I: prompt,
  PROMPT_S: nil,
  PROMPT_C: prompt,
  RETURN: "=> %s\n",
  AUTO_INDENT: true
}
IRB.conf[:PROMPT_MODE] = :CUSTOM

AwesomePrint.irb!

# copy a string to the clipboard
def copy(string)
  IO.popen('xclip', 'w') { |f| f << string.to_s.strip }
  string
end

def paste
  `xclip -o`.strip
end

def clear
  system('clear')
end

def ls
  system('ls')
end

def git(*args)
  puts `git #{args.join(' ')}`
end

def st
  'st'
end

# d'oh
alias exti exit
alias ext exit

# Easily print methods local to an object's class
class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

# Pipe any string to a command line program
class String
  def |(other)
    IO.popen(other.to_s, 'r+') do |pipe|
      pipe.write(self)
      pipe.close_write
      pipe.read
    end
  end
end

# Include some nice rails array methods
class Array
  def average
    sum / count.to_f
  end

  def sum
    inject(0, :+)
  end
end

def recursive_require(*names)
  names.each do |name|
    next if a_dumb_file?(name)
    pwd = File.absolute_path('.')
    dir = File.join(pwd, name)
    Dir.entries(dir).each do |file|
      file = File.join(name, file)
      rec_req(file)
    end
    File.file?(dir) and require dir
  end
end
alias rr recursive_require

def a_dumb_file?(name)
  name = File.basename(name)
  %w(.DS_Store . ..).include?(name)
end

def bench(test = nil, iterations = 10, &block)
  return 'You w0t m8?' if (!block_given? and test.nil?)
  times = []
  iterations.times do
    times.push(1_000_000 * Benchmark.realtime do
      block_given? ? yield : test.call
    end)
  end
  puts "Max: #{times.max}μs\n" \
       "Min: #{times.min}μs\n" \
       "Avg: #{times.average}μs for #{iterations} iterations"
  times.average
end

# Allow directory-specific irb config
if File.exist?(path = File.join(Dir.pwd, '.irbrc'))
  load path
end
