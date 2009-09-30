require 'action_controller/test_case'

ActionController::TestCase.class_eval do
  # special overload methods for "global"/nested params
  [ :get, :post, :put, :delete ].each do |overloaded_method|
    define_method overloaded_method do |*args|
      action,params,extras = *args
      super action, @params.merge( params || {} ), *extras
    end
  end
  
  def setup
    super
    @params = {}
  end
end

### Example
# a_get_to(:index, params = false )
#   should_respond_with :success
# end

# a_get_to(:index, :foo => 'bar )
#   should_respond_with :success
# end

# a_get_to(:index) do
#   with_params(:foo => 'bar', :dummy => 1) do
#     should_respond_with :success
#     should "do some other stuff" do
#      assert_equal 1, @params[:dummy]
#     end
#   end
# end

Test::Unit::TestCase.class_eval do

  def self.a_request_to method, action, params={}, &blk
    context "a :#{method} to :#{action}" do
      setup do
        if params && params.blank?  # call method as lamda by default
          @action = lambda{ send method, action }
        else # params is nil or passed as hash, call method directly
          send method, action, params
        end
      end
      blk.call
    end
  end

  # # TODO: how to get block arg passed in define method? Do we need the string version?
  # %w[get post put delete].each do |method|
  #   class_eval <<-RUBY
  #   def self.a_#{method}_to action, &blk
  #     a_request_to method.intern, action, &blk
  #   end
  #   RUBY
  # end

  def self.a_get_to action, params={}, &blk
    a_request_to :get, action, params, &blk
  end
  def self.a_post_to action, params={}, &blk
    a_request_to :post, action, params, &blk
  end
  def self.a_put_to action, params={}, &blk
    a_request_to :put, action, params, &blk
  end
  def self.a_delete_to action, params={}, &blk
    a_request_to :delete, action, params, &blk
  end


  def self.with_params params, title="" 
    raise ArgumentError, "params must be a Hash" unless params.is_a?(Hash)
    name = title.blank? ? "with params = #{params.inspect}" : "with #{title} (#{params.inspect})"
    context name do
      setup do
        @params.merge! params
        @action.call
      end
      yield
    end
  end

end