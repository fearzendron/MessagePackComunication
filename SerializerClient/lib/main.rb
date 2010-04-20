require "rubygems"
require "wx"
require "socket"
require "msgpack"
include Wx

class MyFrame < Frame
  def initialize()
    super(nil, -1, "Ruby Boca Aberta!!!!")
    @my_panel = Panel.new(self)

    @my_label_host = StaticText.new(@my_panel, -1, 'Digite o IP!:', DEFAULT_POSITION, DEFAULT_SIZE, ALIGN_CENTER)
    @my_textbox_host = TextCtrl.new(@my_panel, -1, '127.0.0.1')

    @my_label_port = StaticText.new(@my_panel, -1, 'Digite a porta:', DEFAULT_POSITION, DEFAULT_SIZE, ALIGN_CENTER)
    @my_textbox_port = TextCtrl.new(@my_panel, -1, '20000')

    @my_label = StaticText.new(@my_panel, -1, 'Excreva uma mensagem!', DEFAULT_POSITION, DEFAULT_SIZE, ALIGN_CENTER)
    @my_textbox = TextCtrl.new(@my_panel, -1, '')

    @my_button = Button.new(@my_panel, -1, 'Enviar mensagem')

    @my_textbox_result = TextCtrl.new(@my_panel, -1, '')


    @my_panel_sizer = BoxSizer.new(VERTICAL)
    @my_panel.set_sizer(@my_panel_sizer)

    @my_panel_sizer.add(@my_label_host, 0, GROW|ALL, 2)
    @my_panel_sizer.add(@my_textbox_host, 0, GROW|ALL, 2)
    @my_panel_sizer.add(@my_label_port, 0, GROW|ALL, 2)
    @my_panel_sizer.add(@my_textbox_port, 0, GROW|ALL, 2)
    @my_panel_sizer.add(@my_label, 0, GROW|ALL, 2)
    @my_panel_sizer.add(@my_textbox, 0, GROW|ALL, 2)
    @my_panel_sizer.add(@my_button, 0, GROW|ALL, 2)
    @my_panel_sizer.add(@my_textbox_result, 0, GROW|ALL, 2)


    evt_button(@my_button.get_id()) { |event| my_button_click(event)}
    evt_close {|event| on_close(event)}

    show()
  end

  #Evento disparado quando se fecha a janela
  def on_close(event)
    message("Esta janela será fechada, ADEUSSSSSSS", "Close event")
    #close(true) - Don't call this - it will call on_close again, and your application will be caught in an infinite loop
    # Either call event.skip() to allow the Frame to close, or call destroy(), as follows
    destroy()
  end

  def my_button_click(event)

    host = @my_textbox_host.get_value
    port = @my_textbox_port.get_value
    mensagem = @my_textbox.get_value

    server = TCPSocket::new(host, port)

    server.write({'id' => 1, 'msg' => mensagem}.to_msgpack)
    server.flush
    retorno = server.sysread(1024)
    @my_textbox_result.set_value retorno
    server.close
    
    @my_textbox.set_value ""
  end

  def message(text, title)
    m = Wx::MessageDialog.new(self, text, title, Wx::OK | Wx::ICON_INFORMATION)
    m.show_modal()
  end

end

class MyApp < App

  def on_init
    MyFrame.new
  end

end

MyApp.new.main_loop()

