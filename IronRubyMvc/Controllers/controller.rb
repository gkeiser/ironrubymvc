﻿module IronRubyMvc
  
  module Controllers
    
    module Filters
      
      module ClassMethods
        
        def self.reset_action_filters
          @action_filters = []
        end
        
        def before_action(name, options={}, &b)
          options[:before] ||= b if block_given?
          options[:before] ||= name.to_sym 
          filter(name, options.merge(:when => :before))     
        end

        def after_action(name, options={}, &b)
          options[:after] ||= b if block_given?
          options[:after] ||= name.to_sym
          filter("", options.merge(:when => :after))
        end

        def around_action(name, options={}, &b)
          options[:before] ||= b if block_given?
          options[:after] ||= b if block_given?
          options[:before] ||= name.to_sym
          options[:after] ||= name.to_sym
          filter(name, options.merge(:when => :around))
        end
        
        def authorized_action(name, options={}, &b)
          filter(name, options.merge(:when => :authorize), &b)
        end
        
        def exception_action(name, options={}, &b)
          filter(name, options.merge(:when => :exception), &b)
        end
        
        def before_result(name, options={}, &b)
          filter(name, options.merge(:when => :before_result), &b)
        end
        
        def after_result(name, options={}, &b)
          filter(name, options.merge(:when => :after_result), &b)
        end
        

        def filter(name, options={})
          @action_filters ||= []
          options = name if name.is_a? Class
          name = :controller if name.nil? || name.is_a?(Class)
          @action_filters << { :name => name.to_sym, :options => options } 
        end

        def action_filters
          @action_filters ||= []
          @action_filters
        end
        
      end
      
      def self.included(base)
        base.extend(ClassMethods)
      end
      
    end
    
    module Selectors
      
      module ClassMethods
        
        def action_selector(name, options={}, &b)
          @action_selectors ||= []
          options[:action] = b if block_given?
          options[:action] ||= name.to_sym #class.instance_method(name.to_sym)
          @action_selectors << { :name => name.to_sym, :options => options }
        end
        
        def action_selectors
          @action_selectors ||= []
          @action_selectors
        end
        
      end
      
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
    
  end
  
  #module Controllers
  
  class Controller < IronRubyMvcLibrary::Controllers::RubyController
 
    
    include Controllers::Filters
    include Controllers::Selectors   
    
    def fill_view_data
      instance_variables.each { |varname| view_data.add(varname[1..-1], instance_variable_get(varname.to_sym)) }
    end
    
    def return_view(*args)
      fill_view_data
      view args
    end
            
  end
  
  #end
  
  
  
end

#alias longer namespaces for convenience
Controller = IronRubyMvc::Controller
ActionFilter = IronRubyMvcLibrary::Controllers::RubyActionFilter
AuthorizationFilter = IronRubyMvcLibrary::Controllers::RubyAuthorizationFilter
ExceptionFilter = IronRubyMvcLibrary::Controllers::RubyExceptionFilter
ResultFilter = IronRubyMvcLibrary::Controllers::RubyResultFilter