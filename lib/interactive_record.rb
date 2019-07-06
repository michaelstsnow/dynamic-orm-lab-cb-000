require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def self.table_name
    self.name.to_s.pluralize.downcase
  end

  def self.column_names
    DB[:conn].results_as_hash = true

    sql= "PRAGMA table_info('#{table_name}');"
    columns=[]
    table_info = DB[:conn].execute(sql)
    table_info.each do  |col|
      columns << col["name"]
    end
    columns.compact
  end

  def initialize(attributes={})
    attributes.each do |key,value|
      self.send("#{key}=", value)
    end
  end

  def table_name_for_insert
    self.class.to_s.pluralize.downcase
  end

  def col_names_for_insert
    self.class.column_names.delete_if {|col| col == "id"}.join(", ")
  end

  def values_for_insert
    column_names=self.col_names_for_insert
    for column_names.each do |col|
      self['#{col}']
    end
  end

  def save
  end

  def self.find_by_name
  end

  def self.find_by
  end

end
