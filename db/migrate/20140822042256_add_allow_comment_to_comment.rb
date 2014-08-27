class AddAllowCommentToComment < ActiveRecord::Migration
  def change
    add_column :comments, :isAllowComment, :string
  end
end
