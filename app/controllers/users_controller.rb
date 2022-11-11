class UsersController < ApplicationController
 before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    #過去７日分それぞれの投稿数を一覧表示する（表・グラフ）
    @today_book =  @books.created_today
    @yesterday_book = @books.created_yesterday
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    if @user.id != current_user.id
     redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

 #日別投稿数表示
  #① rails routesより、、、
  #Controller#Action => users#search_form
  #Prefix => user_search_form ,Verb => GET
  #URI Pattern => /users/:user_id/search_form(.:format)
  #となっているので、(params[:user_id])が必要
  
  #②if文で分岐させて空欄なら日付を選択するように表示します
  #③.countメソッドで検索してヒットした本を投稿した日付の投稿数を@search_bookで定義します。
  
  def search
    @user = User.find(params[:user_id])#①
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"#②
    else
      create_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{create_at}%"]).count#③
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
