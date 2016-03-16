class CheckTaskManager::Application
  config.middleware.insert_before 0,  "Rack::Cors", debug: true, logger: (-> { Rails.logger }) do
    allow do
      origins 'localhost:3000', '127.0.0.1:3000', 'check-projectmanager.bitballoon.com',
        /\Ahttp:\/\/192\.168\.0\.\d{1,3}(:\d+)?\z/

      resource '/cors',
        headers: :any,
        methods: [:post],
        credentials: true,
        max_age: 0

      resource '*',
        headers: :any,
        methods: [:get, :post, :delete, :put, :patch, :options, :head],
        max_age: 0
    end
  end
end
