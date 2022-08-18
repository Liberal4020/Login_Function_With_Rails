class NoteController < ApplicationController
  def get_notes
      render :json=> Note.all()
  end

  def post_note
    begin
      note = Note.new({title: params["title"], body: params["body"], user_id: params["user_id"]})
      if note.save
        render json: { status: 'SUCCESS' }, :status => :created
      else
        render json: { status: 'ERROR' }, :status => :internal_server_error
      end
    rescue => exception
      render json: { status: 'DB_CHECK_ERROR' }, :status => :internal_server_error
    end
  end
end
