class PointNewOrdersSequences < ActiveRecord::Migration
  def up
    execute <<-SQL
        ALTER SEQUENCE orders_id_seq RESTART 18;
        ALTER SEQUENCE "orders_id_seq" INCREMENT BY 2;
    SQL
  end

  def down
    execute <<-SQL
        ALTER SEQUENCE "orders_id_seq" INCREMENT BY 1;
    SQL
  end
end
