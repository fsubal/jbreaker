# frozen_string_literal: true

module Jbreaker
  # :nodoc:
  class Railtie < ::Rails::Railtie
    initializer :jbreaker do
      ActiveSupport.on_load :action_view do
        require 'jbreaker/handler'
        ActionView::Template.register_template_handler :jbreaker, Jbreaker::Handler
        require 'jbuilder/dependency_tracker'
      end

      if Rails::VERSION::MAJOR >= 5
        module ::ActionController
          module ApiRendering
            include ActionView::Rendering
          end
        end

        ActiveSupport.on_load :action_controller_api do
          include ActionController::Helpers
          include ActionController::ImplicitRender
        end
      end
    end

    generators do |app|
      Rails::Generators.configure! app.config.generators
      Rails::Generators.hidden_namespaces.uniq!
      require_relative '../generators/rails/scaffold_controller_generator'
    end
  end
end
