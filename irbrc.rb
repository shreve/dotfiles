puts "Ruby #{RUBY_VERSION}"
puts "`loadext` for some gems"

# IRB extensions
require 'irb/completion'

ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

if defined?(Rails)
  path = File.expand_path("./log/railsc.log")
  prompt = "[\e[1;31mrails/#{Rails.env}\e[0m]$ "
else
  path= File.expand_path("~/dotfiles/history/irb")
  prompt = "[\e[1;31mirb/local\e[0m]$ "
end

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = path
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:IGNORE_SIGINT] = true
IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_N => prompt,
  :PROMPT_I => prompt,
  :PROMPT_S => nil,
  :PROMPT_C => prompt,
  :RETURN => "=> %s\n",
  :AUTO_INDENT => true
}
IRB.conf[:PROMPT_MODE] = :CUSTOM
AwesomePrint.irb! rescue

def loadext
  reqs = %w[
    rubygems
    ostruct
    ap
  ]

  loaded_reqs = []
  errored_reqs = []

  reqs.each do |req|
    begin
      require req
      loaded_reqs.push req
    rescue LoadError
      errored_reqs.push req
    end
  end

  AwesomePrint.irb! rescue

  message = "Loaded: #{loaded_reqs.join(', ')}"
  message << "   |   Problem loading: #{errored_reqs.join(', ')}" if errored_reqs.size > 0
  message
end

# copy a string to the clipboard
def copy(string)
  IO.popen('pbcopy', 'w') { |f| f << string.to_s }
  string
end

def paste
  `pbpaste`
end

def clear
  system('clear')
end

def git(*args)
  puts `git #{args.join(' ')}`
end

def st; "st"; end

# d'oh
alias :exti :exit
alias :ext :exit

class Object
  # Easily print methods local to an object's class
  def local_methods
    (methods - Object.instance_methods).sort
  end

  def inspect
    begin
      ap self
    rescue
      super
    end
  end
end

class String
  def |(cmd)
    IO.popen(cmd.to_s, 'r+') do |pipe|
      pipe.write(self)
      pipe.close_write
      pipe.read
    end
  end
end

class Array
  def average
    sum / count
  end

  def sum
    inject(0, :+)
  end
end

def rec_req(*names)
  names.each do |name|
    unless is_a_dumb_file?(name)
      pwd = File.absolute_path('.')
      dir = File.join(pwd, name)
      if File.directory?(dir)
        Dir.entries(dir).each do |file|
          file = File.join(name, file)
          rec_req(file)
        end
      elsif File.file?(dir)
        require dir
      end
    end
  end
end
alias :rr :rec_req

def is_a_dumb_file? name
  name = File.basename(name)
  %w(.DS_Store . ..).include?(name)
end

class NilOut
  def write(*)
  end
end

def bench(iterations = 10, &block)
  return "You w0t m8?" unless block_given?
  times = []
  iterations.times do
    times.push(1000 * Benchmark.realtime { yield })
  end
  puts <<-EOF
    Max: #{times.max}ms
    Min: #{times.min}ms
    Sum: #{times.sum}ms for #{iterations} iterations
  EOF
  times.average
end

if File.exists?(path = File.join(Dir.pwd, '.irbrc'))
  load path
end
