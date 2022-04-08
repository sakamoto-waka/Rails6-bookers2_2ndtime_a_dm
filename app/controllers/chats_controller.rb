class ChatsController < ApplicationController
  def show
    @user = User.find(params[:id])
    # pluckは配列で取得
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
end
