class UsersController < ApplicationController
  before_action :load_user, except: [:index, :create, :new]

  before_action :authorize_user, except: [:index, :new, :create, :show]

  def index
    # запишем в неё всех пользователей
    @users = User.all
  end
  # Действие new будет отзываться по адресу /users/new
def new
  # Пока создадим новый экземпляр модели
  redirect_to root_url, alert: 'Вы уже залогинены' if current_user.present?
    @user = User.new
end
def create
  redirect_to root_url, alert: 'Вы уже залогинены' if current_user.present?

  @user = User.new(user_params)

  if @user.save
    redirect_to root_url, notice: 'Пользователь успешно зарегестрирован!'
  else
    render 'new'
  end
end

def edit
end

def show
  @questions = @user.questions.order(created_at: :desc)

  @new_question = @user.questions.build

  # Создаем три переменные с количеством вопросов, отвеченных вопросов и
  # неотвеченных вопросов
  @questions_count = @questions.count
  @answers_count = @questions.where.not(answer: nil).count
  @unanswered_count = @questions_count - @answers_count
end



# @questions = [
#   Question.new(text: 'Как дела?', created_at: Date.parse('27.03.2016'))
# ]

def update
  # Получаем параметры нового (обновленного) пользователя с помощью метода user_params
  @user = User.find params[:id]
  # пытаемся обновить юзера
  if @user.update(user_params)
    # Если получилось, отправляем пользователя на его страницу с сообщением
    redirect_to user_path(@user), notice: 'Данные обновлены'
  else
    # Если не получилось, как и в create, рисуем страницу редактирования
    # пользователя со списком ошибок
    render 'edit'
  end
end

private

  def authorize_user
    reject_user unless @user == current_user
  end

  def load_user
    @user ||= User.find params[:id]
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                                 :name, :username, :avatar_url)
  end
end
