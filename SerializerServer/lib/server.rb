require "rubygems"
require "socket"

class Server

  def initialize(sock)
    @sock = sock
    @pk = MessagePack::Unpacker.new
    @buffer = ''
    @nread = 0
  end

  def receive_data(data)
    @buffer << data

    while true
      @nread = @pk.execute(@buffer, @nread)

      if @pk.finished?
        msg = @pk.data
        process_message(msg)

        @pk.reset
        @buffer.slice!(0, @nread)
        @nread = 0

        next unless @buffer.empty?
      end

      break
    end

    if @buffer.length > 10*1024*1024
      raise "message is too large"
    end

  rescue
    puts "error while processing client packet: #{$!}"
  end

  def process_message(msg)
    puts "message reached: #{msg.inspect}"
  end

end