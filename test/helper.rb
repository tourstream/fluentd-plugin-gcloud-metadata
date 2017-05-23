# simplecov must be loaded before any of target code
#if ENV['SIMPLE_COV']
  require 'simplecov'
  if defined?(SimpleCov::SourceFile)
    mod = SimpleCov::SourceFile
    def mod.new(*args, &block)
      m = allocate
      m.instance_eval do
        begin
          initialize(*args, &block)
        rescue Encoding::UndefinedConversionError
          @src = "".force_encoding('UTF-8')
        end
      end
      m
    end
  end
  unless SimpleCov.running
    SimpleCov.start do
      add_filter '/test/'
      add_filter '/gems/'
    end
  end
#end