class MessagesController < ApplicationController

  def index
    @messages = Message.all
  end

  def create
    @message = Message.new( message_params )
    @message.user = current_user

    if @message.save

      html = ApplicationController.renderer.render( :partial => "messages/message", :locals => { :message => @message } )

      ActionCable.server.broadcast "public_channel", { :html => html }

      render :json => { :id => @message.id }
    else
      render :json => { :message => "error" }, :status => 400
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :nickname)
  end

end