module EnumFu
  def self.included(including_class)
    including_class.class_eval do

      # make a enum colume in active record model 
      # db schema
      #	  create_table 'users' do |t|
      #	    t.column 'role', :integer, :limit => 2
      #	  end
      #
      # model
      #	  class User < ActiveRecord::Base
      #	    acts_as_enum :role, [:customer, :admin]
      #	  end
      def self.acts_as_enum(name, values)
        # keep original name  in n to use later, 
        # I don't know why, but name's value is changed later
        n = name.to_s.dup

        # define an array contant with the given values
        # example: Car::STATUS =>  [:normal, :broken, :running]
        const_name = name.to_s.upcase
        self.const_set const_name, values
        
        # define an array contant with the given values humanized, useful for selects and values with spaces
        # example: Car::STATUS_HUMAN =>  [['Normal',:normal], ['Broken',:broken], ['Running away',:running_away]]
        const_human_name = name.to_s.upcase+'_HUMAN'
        human_values = values.map{ |value| [value.to_s.humanize,value]}.to_a
        self.const_set const_human_name, human_values
        
        #define a Hash constant with the humanized values associated with the enum value, useful for filter plugins
        #Example: Car::STATUS_VALUES =>  {'Normal' => 0, 'Broken' => 1, 'Running away' => 2}
        const_values_name = name.to_s.upcase+'_VALUES'
        hash_values = const_get(const_human_name).inject({}){ |state, (key,val)| state.merge(key => self.const_get(const_name).index(val)) }
        self.const_set const_values_name, hash_values
        

        # define a singleton method which get the enum value
        # example: Car.status(:broken)   =>  1
        p1 =  Proc.new { |v| self.const_get(const_name).index(v) }
        metaclass = class << self
          self
        end
        metaclass.send(:define_method, name, p1)

        # define an instance get/set methods  which get/set  the enum value
        # example: 
        # c = Car.new :status => :normal  
        # c.status => :normal
        # c.status = :broken
        #
        p2 =  Proc.new {
          # Before patch (Do not allow nil value)
          #  self.class.const_get(const_name)[read_attribute(name.to_s)||0]
          
	  # After patch by Josh Goebel (Now, it will return nil when db value is nil)
          attr_name = read_attribute(name.to_s)
          attr_name.nil? ? nil : self.class.const_get(const_name)[attr_name]
        }
        define_method name.to_sym, p2

        p3 =  Proc.new { |value|
          # Before patch (Do not allow nil value)
          #write_attribute name.to_s, self.class.const_get(const_name).index(sym.to_sym)
          
          # After patch by Georg Ledermann (Now it's possible to set as null Ex: c.status = nil )
          if value.blank?
            casted_value = nil
          elsif (value.is_a?(String) && value =~ /\A\d+\Z/) || value.is_a?(Integer)
            casted_value = value.to_i
          else
            casted_value = self.class.const_get(const_name).index(value.to_sym)
          end
          write_attribute name.to_s, casted_value
        }
        define_method name.to_s+'=', p3
      end
    end
  end
end

