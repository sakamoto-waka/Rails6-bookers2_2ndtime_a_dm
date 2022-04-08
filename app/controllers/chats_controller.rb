class ChatsController < ApplicationController
  def show
    @user = User.find(params[:id])
    # pluckは引数の値を配列で取得、自分の:room_idを一度全て取得
    rooms = current_user.user_rooms.pluck(:room_id)
    # roomsにはたくさん部屋があるけどuser_idに合致するroomはひとつなのでfind_byを使ってる
    user_room = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    
    if user_room.nil?
      @room = Room.new
      @room.save
      # 自分と相手の＊2人分＊を中間テーブルに保存しておく
      UserRoom.create(user_id: @user.id, room_id: @room.id)
      UserRoom.create(user_id: current_user.id, room_id: @room_id)
    else
      @room = user_room.room
    end
    # チャット履歴の取得+新規送信するためのインスタンス作成
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end
  
  def create
    @chat = Chat.new(chat_params)
    respond_to do |format|
      if @chat.save
        format.html { redirect_to @chat }
        format.js
      else
        format.html { render :new }
        format.js { render :errors }  
      end  
    end
  end
    
  private
  
    def chat_params
      params.require(:chat).permit(:message, :room_id)
    end
end
