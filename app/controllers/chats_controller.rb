class ChatsController < ApplicationController
  def show
    @user = User.find(params[:id])
    # pluckは配列で取得
    rooms = current_user.user_rooms.pluck(:room_id)
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)
  end
end
