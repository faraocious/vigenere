defmodule VigAcc.Router.Homepage do
  use Maru.Router
  require Vig
  namespace :cypher do
    params do
      requires :text, type: String
      requires :key, type: String
    end

    get do
        conn 
        |> put_status(200)
        |>json(%{cyphered: Vig.cypher(params[:text], params[:key])})
    end
  end

  namespace :decypher do
    params do
      requires :text, type: String
      requires :key, type: String
    end

    get do
        conn 
        |> put_status(200)
        |>json(%{decyphered: Vig.decypher(params[:text], params[:key])})
     end

  end
end

defmodule VigAcc.API do
  use Maru.Router

  plug Plug.Logger
  plug Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Poison,
    parsers: [:urlencoded, :json, :multipart]
      
  mount VigAcc.Router.Homepage

  rescue_from :all, as: e do
    conn
    |> put_status(500)
    |> text("Server Error: #{inspect e}")
  end
end
