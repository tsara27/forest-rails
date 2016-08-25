module ForestLiana
  class SchemaUtils

    def self.associations(active_record_class)
      active_record_class
        .reflect_on_all_associations
        .select {|a| !polymorphic?(a)}
    end

    def self.one_associations(active_record_class)
      self.associations(active_record_class).select do |x|
        [:has_one, :belongs_to].include?(x.macro)
      end
    end

    def self.find_model_from_table_name(table_name)
      ActiveRecord::Base.subclasses.find do |subclass|
        if subclass.abstract_class?
          subclass.table_name = subclass.name.tableize
        end

        subclass.table_name == table_name
      end
    end

    def self.tables_names
      ActiveRecord::Base.connection.tables
    end

    private

    def self.polymorphic?(association)
      association.options[:polymorphic]
    end

  end
end

