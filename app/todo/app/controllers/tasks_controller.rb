class TasksController < ApplicationController
    before_action :login_required
    def index
        @tasks=current_user.tasks.order(deadline: "ASC")
        @task= Task.new()
    end

    def edit
        @task=current_user.tasks.find(params[:id])
    end

    def create
        @task= Task.new()
        @task.title = params[:title]
        @task.content = params[:content]
        @task.deadline = params[:deadline]
        @task.user_id = current_user.id
        if @task.save
            redirect_to tasks_path , notice: "Todoを追加しました。"
        else
            @tasks=Task.order("id")
            render "index"
        end
    end

    def update
        @task=current_user.tasks.find(params[:id])
        @old_deadline = @task.deadline
        # @task.assign_attributes(params[:task])   # あんまりしないほうがいい(?)

        @task.title = params[:task][:title]
        @task.content = params[:task][:content]
        @task.check = params[:task][:check]

        # puts DateTime.parse(params[:task][:deadline])
        # puts Time.parse(params[:task][:deadline])
        # puts @task.deadline

        # puts DateTime.parse(params[:task][:deadline]) == @task.deadline
        # puts Time.parse(params[:task][:deadline]) == @task.deadline


        # 日時変更をしなかったときに deadline についてvalidation しない
        # DateTime だと TimeZone 見てくれないので Time に突っ込んで比較
        if Time.parse(params[:task][:deadline]) == @task.deadline
            @task.deadline = DateTime.now + 1 #汚いけど仮置
            if @task.save
                @task.update_column(:deadline, @old_deadline)   # 強制的に戻しておく
                redirect_to tasks_path, notice: "Todoを更新しました。"
            else
                @task.update_column(:deadline, @old_deadline)   # 強制的に戻しておく
                @task = current_user.tasks.find(params[:id])   # もう一回呼び出しておく
                render "edit"
            end
        else
            @task.deadline = params[:task][:deadline]
            if @task.save
                redirect_to tasks_path, notice: "Todoを更新しました。"
            else
                render "edit"
            end
        end
        
    end

    def destroy
        @task=current_user.tasks.find(params[:id])
        @task.destroy
        redirect_to tasks_path, notice: "Todoを削除しました"
    end

    def check
        @task=current_user.tasks.find(params[:task_id])
        puts params[:check]
        if params[:check] == '1'
            @task.check = true
            # puts '1だよ'
        elsif params[:check] == '0'
            @task.check = false
            # puts '0だお'
        else
            raise
        end
        if @task.save(validate: false)   # 期限超過したものをチェックできるようにする
            redirect_to tasks_path, notice: "Todoをチェックしました。"
        else
            raise
        end

    end
end
