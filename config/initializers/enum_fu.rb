require_relative '../../lib/enum_fu/lib/enum_fu'
ActiveRecord::Base.send :include, EnumFu
