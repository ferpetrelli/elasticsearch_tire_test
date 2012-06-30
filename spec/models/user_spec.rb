require 'spec_helper'

describe User do

  describe "Searching" do
    before(:each) do
      User.tire.index.delete
      User.create_elasticsearch_index

      @user_1 = User.create({
        :name => "test user",
        :age  => 25
      })
      @user_2 = User.create({
        :name => "another name in the spec",
        :age  => 23
      })

      User.all.each do |s|
        s.tire.update_index 
      end
      User.tire.index.refresh
    end

    context "Searching" do
      describe "users" do
        it "should filter users by name" do
          result = User.user_search(:name => "user")
          result.count.should == 1
          result.first.name.should == @user_1.name
        end

        it "should filter users by age" do
          result = User.user_search(:age => 23)
          result.count.should == 1
          result.first.age.should == @user_2.age
        end
      end
    end
  end
end