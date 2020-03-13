module API
    class Base < Grape::API
        prefix 'api'
        mount API::V1::Root
    end
end