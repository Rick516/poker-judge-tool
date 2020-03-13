module API
    module V1
        class Root < Grape::API
            version 'v1', using: :path
            format :json 
            formatter :json, Grape::Formatter::Jbuilder 

            # 400 Bad Request
            rescue_from Grape::Exceptions::Base do
                error!({error: "400 Bad Request：不正なリクエストです"}, 400)
            end

            # 404 Not Found
            route :any, '*path' do
                error!({error: "404 Not Found：指定されたURLは存在しません"}, 404)
            end

            # 500 Internal Server Error
            rescue_from Exception do
                error!({error: "500 Internal Server Error：予期しないエラーです"}, 500)
            end

            mount API::V1::Cards::Check
        end
    end
end