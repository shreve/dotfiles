# coding: utf-8

# IRB extensions
begin
  require 'irb/completion'
  require 'ap'
  require 'benchmark'
  require 'fileutils'
  require 'io/console'
rescue LoadError => e
  puts e.message
end

begin
  AwesomePrint.irb!
rescue NameError => e
end

module ANSI
  CODES = {
    reset:     "\e[0m",
    bold:      "\e[1m",
    dim:       "\e[2m",
    underline: "\e[4m",
    lgray:     "\e[0;37m",
    gray:      "\e[0;30m",
    dgray:     "\e[38;5;236m",
    lred:      "\e[1;31m",
    red:       "\e[31m",
    green:     "\e[32m",
    yellow:    "\e[33m",
    blue:      "\e[34m",
    magenta:   "\e[35m",
    cyan:      "\e[36m",
    white:     "\e[37m"
  }.freeze

  def self.[](key)
    CODES[key]
  end
end

def color(*args)
  string = ''
  text = args.pop
  args.each { |style| string << ANSI[style] }
  string << text
  string << ANSI[:reset]
  string
end

puts "\n #{color :red, '💎'}  Ruby #{RUBY_VERSION}"

if defined?(Rails)
  path = Rails.root.join('log/railsc.log').to_s
  tag = "rails/#{Rails.env}"
else
  path = File.expand_path('~/.irb_history')
  tag = 'irb/local'
end

pwd = Dir.pwd.split('/').last(2).join('/')

hr = `tput cols`.strip.to_i.times.map { '—' }.join
prompt = "#{color :dgray, hr}\n[#{color :yellow, pwd}][#{color :green, tag}]"

require 'fileutils'
FileUtils.touch(path) unless File.exist?(path)

class Mock
  def method_missing(method, *args, &block)
    puts "mock." << method.to_s << "( " << args.map(&:to_s).join(', ') << " )"
    yield if block_given?
    "hello"
  end

  def size
    5
  end

  def to_str
    "actual prompt >"
  end

  def to_a
    to_str.split('')
  end

  def *
    to_str
  end
end

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = path
IRB.conf[:AUTO_INDENT] = false
IRB.conf[:IGNORE_SIGINT] = true
IRB.conf[:PROMPT][:CUSTOM] = {
  PROMPT_I: "#{prompt} > ", # Normal prompt
  PROMPT_S: "#{prompt} \" ", # Continued string prompt
  PROMPT_C: "#{prompt} λ ", # Continued command prompt
  RETURN: "=> %s\n",
  AUTO_INDENT: true
}
IRB.conf[:PROMPT_MODE] = :CUSTOM

# copy a string to the clipboard
def copy(string)
  IO.popen('xsel -i --clipboard', 'w') { |f| f << string.to_s.strip }
  string
end

def paste
  `xsel -o`.strip
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

%w(st diff ck rb).each do |cmd|
  define_method(cmd) { cmd }
end

def colors
  ANSI.keys.each do |key|
    puts color(key, key.to_s)
  end
  nil
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

# Access a random time between Jan 1, 1970 and now
class Time
  def self.random(from = Time.at(0), to = Time.now)
    Time.at(rand(to.to_f - from.to_f) + from.to_f)
  end
end

def bench(test = nil, iterations = 10)
  return 'You w0t m8?' if !block_given? && test.nil?
  times = []
  iterations.times do
    times.push(1_000_000 * Benchmark.realtime { block_given? ? yield : test.call })
  end
  puts "Max: #{times.max}μs\n" \
       "Min: #{times.min}μs\n" \
       "Avg: #{times.average}μs for #{iterations} iterations"
  times.average
end

# Allow directory-specific irb config
if File.exist?(path = File.join(Dir.pwd, '.irbrc')) and __FILE__ != path
  load path
end
