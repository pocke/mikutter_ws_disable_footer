module Gtk
  class PostBox < Gtk::EventBox
    def post_it
      if postable?
        return unless before_post
        text = widget_post.buffer.text
        text += UserConfig[:footer] if add_footer? && !(text =~ /^\s/)
        @posting = service.post(:message => text){ |event, msg|
          notice [event, msg].inspect
          case event
          when :start
            Delayer.new{ start_post }
          when :fail
            Delayer.new{ end_post }
          when :success
            Delayer.new{ destroy } end } end end
  end
end
