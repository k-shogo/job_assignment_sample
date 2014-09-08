class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :user,       index: true
      t.string     :title
      t.text       :description
      t.integer    :lock_version, default: 0
      t.datetime   :done

      t.timestamps
    end
  end
end
