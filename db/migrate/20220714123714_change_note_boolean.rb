class ChangeNoteBoolean < ActiveRecord::Migration[6.1]
  def change
    change_column_null :notes, :user_id, false
  end
end
