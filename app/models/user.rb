class User < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks
  
  attr_accessible :age, :name

  validates :name, :presence => true

  mapping do
    indexes :name
    indexes :age, type: "integer"
  end

  def to_indexed_json
    to_json( methods: [:name, :age] )
  end
  
  def self.user_search(params = {})
    tire.search do
      filter :term, name:  params[:name] if params[:name].present?
      filter :term, age:   params[:age]  if params[:age].present?
    end
  end

end
